#include "de_vm_authority.hpp"

#include <atomic>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <exception>
#include <sstream>
#include <stdexcept>
#include <string>
#include <type_traits>

#include <DetourHook.hpp>
#include <Module.hpp>
#include <Pattern.hpp>
#include <Pointer.hpp>
#include <windows.h>

#include "../owf_console.hpp"
#include "../owf_luau.hpp"
#include "config.hpp"
#include "injection.hpp"

namespace renovice::de_vm_authority
{
namespace
{
using ScriptMgrLock = void(*)(void* holder);
using ProtectedCall = int(*)(luau_State*, int, int, int);
using RawProtectedBody = void(*)(luau_State*, void* context);
using RawProtectedRun = int(*)(
	luau_State*, RawProtectedBody body, void* context);
using VmThrow = void(*)(luau_State*, int);
using FlashShutdown = void(*)(void* object);

inline constexpr const char* signature_lock_enter_u44 = "48 8B 09 48 8B 09 48 FF 25 ? ? ? ? CC CC CC 48 89 5C 24 18 48 89 6C 24 20 56 57 41 55";
inline constexpr const char* signature_lock_enter =
	"48 8B 09 48 8B 09 48 FF 25 ? ? ? ? CC CC CC 48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20";
inline constexpr const char* signature_lock_leave_u44 = "48 8B 09 48 8B 09 48 FF 25 ? ? ? ? CC CC CC 48 83 EC 28 E8 ? ? ? ? 48 8B 08 48 8B 91 30 09 00 00";
inline constexpr const char* signature_lock_leave =
	"48 8B 09 48 8B 09 48 FF 25 ? ? ? ? CC CC CC 40 57 48 81 EC C0 00 00 00";
inline constexpr const char* signature_locked_dispatcher =
	"48 89 5C 24 10 48 89 74 24 18 57 48 83 EC 50 48 8B F9 0F 29 74 24 40 48 8D 0D ? ? ? ? 0F 28 F3 41 8B F0 48 8B DA E8 ? ? ? ?";
inline constexpr const char* signature_protected_call =
	"48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 40 45 33 D2 41 8B F0 44 8B DA";
inline constexpr const char* signature_raw_protected_run =
	"40 53 48 81 EC 60 01 00 00 48 8B 05 ? ? ? ? 48 33 C4 48 89 84 24 50 01 00 00 48 8B 41 18 48 89 54 24 30";
// Exact pinned luaD_throw at RVA 0x991C90 in
// Warframe.x64.exe CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93.
// It writes the unchanged status to errorjmp+8 and longjmps errorjmp+0x10.
inline constexpr const char* signature_vm_throw =
	"48 83 EC 28 48 8B 41 18 4C 8B C1 48 8B 88 B8 04 00 00 48 85 C9 74 12 89 51 08 48 83 C1 10 BA 01 00 00 00";
inline constexpr const char* signature_flash_shutdown =
	"48 89 5C 24 20 57 48 83 EC 20 48 8B 81 C8 00 00 00 48 8B D9 48 83 38 00 0F 84 ? ? ? ? 48 8B 41 10 48 89 6C 24 38 48 8D 2D ? ? ? ? 48 3B C5 74 0A 83 78 0C 01 0F 87 ? ? ? ?";

ScriptMgrLock lock_enter = nullptr;
ScriptMgrLock lock_leave = nullptr;
ProtectedCall game_protected_call = nullptr;
RawProtectedRun raw_protected_run = nullptr;
VmThrow vm_throw = nullptr;

// luaD_rawrunprotected restores the prior DE error-jump record and reports the
// status. It does not perform luaD_pcall's activation/stack recovery. Keep the
// complete caller-owned VM restoration record trivially copyable so a DE
// longjmp can never skip C++ destruction inside the protected boundary.
struct RawVmFrameSnapshot
{
	std::ptrdiff_t intop_offset = 0;
	std::ptrdiff_t outtop_offset = 0;
	std::ptrdiff_t frame_offset = 0;
	std::ptrdiff_t frame_top_offset = 0;
};
static_assert(std::is_trivially_copyable_v<RawVmFrameSnapshot>);

bool capture_raw_vm_frame(
	const luau_State* state,
	RawVmFrameSnapshot& snapshot) noexcept
{
	if (state == nullptr || state->stack == nullptr
		|| state->stack_last == nullptr || state->intop == nullptr
		|| state->outtop == nullptr || state->ci == nullptr
		|| state->base_ci == nullptr || state->end_ci == nullptr
		|| state->ci->top == nullptr || state->stack > state->intop
		|| state->intop > state->outtop || state->outtop > state->ci->top
		|| state->ci->top > state->stack_last)
	{
		return false;
	}

	const auto frame_begin = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto frame_end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	const auto current_frame = reinterpret_cast<std::uintptr_t>(state->ci);
	if (frame_end < frame_begin || current_frame < frame_begin
		|| current_frame >= frame_end
		|| sizeof(luau_CallInfo) > frame_end - current_frame)
	{
		return false;
	}
	const auto frame_offset = current_frame - frame_begin;
	if (frame_offset % sizeof(luau_CallInfo) != 0) return false;

	snapshot.intop_offset = luau_savestack(state, state->intop);
	snapshot.outtop_offset = luau_savestack(state, state->outtop);
	snapshot.frame_offset = static_cast<std::ptrdiff_t>(frame_offset);
	snapshot.frame_top_offset = luau_savestack(state, state->ci->top);
	return snapshot.intop_offset >= 0 && snapshot.outtop_offset >= 0
		&& snapshot.frame_offset >= 0 && snapshot.frame_top_offset >= 0;
}

bool restore_raw_vm_frame(
	luau_State* state,
	const RawVmFrameSnapshot& snapshot) noexcept
{
	if (state == nullptr || state->stack == nullptr
		|| state->stack_last == nullptr || state->base_ci == nullptr
		|| state->end_ci == nullptr || snapshot.intop_offset < 0
		|| snapshot.outtop_offset < snapshot.intop_offset
		|| snapshot.frame_offset < 0
		|| snapshot.frame_top_offset < snapshot.outtop_offset)
	{
		return false;
	}

	const auto stack_begin = reinterpret_cast<std::uintptr_t>(state->stack);
	const auto stack_end = reinterpret_cast<std::uintptr_t>(state->stack_last);
	const auto frame_begin = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto frame_end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	if (stack_end < stack_begin || frame_end < frame_begin) return false;
	const auto stack_bytes = stack_end - stack_begin;
	const auto frame_bytes = frame_end - frame_begin;
	const auto intop_bytes = static_cast<std::uintptr_t>(snapshot.intop_offset);
	const auto outtop_bytes = static_cast<std::uintptr_t>(snapshot.outtop_offset);
	const auto frame_offset = static_cast<std::uintptr_t>(snapshot.frame_offset);
	const auto frame_top_bytes = static_cast<std::uintptr_t>(
		snapshot.frame_top_offset);
	if (intop_bytes > stack_bytes || outtop_bytes > stack_bytes
		|| frame_top_bytes > stack_bytes || frame_offset > frame_bytes
		|| frame_offset % sizeof(luau_CallInfo) != 0
		|| sizeof(luau_CallInfo) > frame_bytes - frame_offset)
	{
		return false;
	}

	auto* const frame = reinterpret_cast<luau_CallInfo*>(
		reinterpret_cast<char*>(state->base_ci) + frame_offset);
	state->ci = frame;
	state->intop = luau_restorestack(state, snapshot.intop_offset);
	state->outtop = luau_restorestack(state, snapshot.outtop_offset);
	frame->top = luau_restorestack(state, snapshot.frame_top_offset);
	return state->stack <= state->intop && state->intop <= state->outtop
		&& state->outtop <= frame->top && frame->top <= state->stack_last;
}
void* lock_holder = nullptr;
void* flash_null_sentinel = nullptr;
soup::DetourHook flash_shutdown_hook;
std::atomic_bool authority_ready = false;

std::atomic<luau_State*> published_state = nullptr;
std::atomic<void*> published_global_state = nullptr;
std::atomic<void*> published_flash = nullptr;
std::atomic<std::uint32_t> published_owner_thread = 0;
std::atomic<std::uint64_t> published_generation = 0;
std::atomic<std::uint64_t> in_flight = 0;
std::atomic_bool accepting = false;

// One C closure is rooted under a stable registry key for each admitted Flash
// generation. The TValue snapshot is published by accepting's release store
// and consumed only after its matching acquire plus the ScriptMgr lock.
constexpr const char* host_registry_key =
	"RENOVICE.DE_VM_AUTHORITY.host.v109";
luau_TValue host_closure{};
std::uint64_t host_closure_generation = 0;

thread_local luau_State* transaction_state = nullptr;
thread_local std::uint64_t transaction_generation = 0;
thread_local std::uint32_t transaction_depth = 0;

bool readable_committed_range(const void* address, std::size_t size) noexcept
{
	if (address == nullptr || size == 0) return false;
	MEMORY_BASIC_INFORMATION memory{};
	if (VirtualQuery(address, &memory, sizeof(memory)) != sizeof(memory)
		|| memory.State != MEM_COMMIT
		|| (memory.Protect & (PAGE_GUARD | PAGE_NOACCESS)) != 0)
	{
		return false;
	}
	const auto begin = reinterpret_cast<std::uintptr_t>(address);
	const auto region_begin = reinterpret_cast<std::uintptr_t>(memory.BaseAddress);
	const auto region_end = region_begin + memory.RegionSize;
	return begin >= region_begin && begin <= region_end
		&& size <= region_end - begin;
}

bool stock_flash_shutdown_will_teardown(void* object) noexcept
{
	// Exact U43 RVA 0x510180 wraps the complete teardown body in one conjunction:
	//   **(object + 0xC8) != 0
	//   && (*(object + 0x10) == null-sentinel
	//       || *(uint32_t*)(*(object + 0x10) + 0x0C) < 2)
	// The second comparison compiles as unsigned JA to the epilogue. Mirror the
	// entire predicate, not only +0xC8, so a stock no-op call cannot retire the
	// RENOVICE generation while Flash remains live.
	constexpr std::size_t internal_owner_offset = 0xC8;
	constexpr std::size_t resource_offset = 0x10;
	constexpr std::size_t resource_reference_count_offset = 0x0C;
	if (object == nullptr) return false;
	const auto object_address = reinterpret_cast<std::uintptr_t>(object);
	if (object_address > UINTPTR_MAX - internal_owner_offset
		|| object_address > UINTPTR_MAX - resource_offset)
	{
		return false;
	}
	const auto* const owner_slot = reinterpret_cast<const void*>(
		object_address + internal_owner_offset);
	if (!readable_committed_range(owner_slot, sizeof(void*))) return false;

	void* owner = nullptr;
	std::memcpy(&owner, owner_slot, sizeof(owner));
	if (!readable_committed_range(owner, sizeof(void*))) return false;

	void* owned_resource = nullptr;
	std::memcpy(&owned_resource, owner, sizeof(owned_resource));
	if (owned_resource == nullptr) return false;

	const auto* const resource_slot = reinterpret_cast<const void*>(
		object_address + resource_offset);
	if (!readable_committed_range(resource_slot, sizeof(void*))) return false;
	void* resource = nullptr;
	std::memcpy(&resource, resource_slot, sizeof(resource));
	if (resource == flash_null_sentinel) return true;
	if (resource == nullptr) return false;

	const auto resource_address = reinterpret_cast<std::uintptr_t>(resource);
	if (resource_address > UINTPTR_MAX - resource_reference_count_offset)
		return false;
	const auto* const reference_count_slot = reinterpret_cast<const void*>(
		resource_address + resource_reference_count_offset);
	if (!readable_committed_range(
		reference_count_slot, sizeof(std::uint32_t)))
	{
		return false;
	}
	std::uint32_t reference_count = 0;
	std::memcpy(&reference_count, reference_count_slot, sizeof(reference_count));
	return reference_count < 2;
}

soup::Pointer resolve_unique(
	const soup::Range& range,
	const char* pattern,
	const char* label) noexcept
{
	try
	{
		soup::Pointer matches[2]{};
		const auto count = range.scanWithMultipleResults(
			soup::Pattern(pattern), matches);
		if (count == 1) return matches[0];
		std::ostringstream failure;
		failure << "RENOVICE DE_VM_AUTHORITY resolve FAIL primitive=" << label
			<< " matches=" << count;
		conout << failure.str() << std::endl;
		config::log(failure.str());
	}
	catch (...)
	{
		const std::string failure = std::string(
			"RENOVICE DE_VM_AUTHORITY resolve EXCEPTION primitive=") + label;
		conout << failure << std::endl;
		config::log(failure);
	}
	return {};
}

void close_generation(const char* reason) noexcept
{
	accepting.store(false, std::memory_order_release);
	const auto generation = published_generation.fetch_add(
		1, std::memory_order_acq_rel) + 1;
	published_state.store(nullptr, std::memory_order_release);
	published_global_state.store(nullptr, std::memory_order_release);
	published_flash.store(nullptr, std::memory_order_release);
	published_owner_thread.store(0, std::memory_order_release);
	try
	{
		std::ostringstream event;
		event << "RENOVICE DE_VM_AUTHORITY generation CLOSE reason=" << reason
			<< " generation=" << generation
			<< " in_flight=" << in_flight.load(std::memory_order_acquire);
		config::diagnostic_log(event.str(), config::DiagnosticsMode::errors);
	}
	catch (...) {}
}

void flash_shutdown_detour(void* object)
{
	// FlashMgr::Shutdown is process-wide, but only the exact object that
	// published this generation owns its retirement. An unrelated/stale manager
	// must never close a newer UI generation.
	const auto current = published_flash.load(std::memory_order_acquire);
	if (current != nullptr && current == object
		&& stock_flash_shutdown_will_teardown(object))
	{
		// Close admission before stock tears down Flash resources. Never wait
		// here: shutdown can be nested on the same owner thread as a callback.
		close_generation("FlashMgr.Shutdown.exact-object");
	}
	else if (current != nullptr && current == object)
	{
		try
		{
			config::diagnostic_log(
				"RENOVICE DE_VM_AUTHORITY shutdown SKIP reason=stock-noop-predicate",
				config::DiagnosticsMode::errors);
		}
		catch (...) {}
	}
	else if (current != nullptr)
	{
		try
		{
			std::ostringstream event;
			event << "RENOVICE DE_VM_AUTHORITY shutdown SKIP reason=object-mismatch"
				<< " current=" << current << " shutdown=" << object;
			config::diagnostic_log(event.str(), config::DiagnosticsMode::errors);
		}
		catch (...) {}
	}
	auto* const original = reinterpret_cast<FlashShutdown>(
		flash_shutdown_hook.original);
	if (original != nullptr) original(object);
}

struct RootHostClosureContext
{
	std::ptrdiff_t saved_top = 0;
	int(*host_callback)(luau_State*) = nullptr;
	luau_TValue rooted{};
	bool exact = false;
};

// This function is entered only through DE's exact luaD_rawrunprotected-shaped
// primitive. It intentionally owns no non-trivial C++ locals: a DE Luau error
// longjmps back to the engine runner and therefore bypasses C++ destructors in
// this frame. The caller restores the stack by offset for both status paths.
void root_host_closure_protected(
	luau_State* state,
	void* raw_context)
{
	auto* const context = static_cast<RootHostClosureContext*>(raw_context);
	if (state == nullptr || context == nullptr
		|| context->host_callback == nullptr
		|| luau_pushcclosurek == nullptr || luau_pushstring == nullptr
		|| luau_gettable == nullptr || luau_settable == nullptr
		|| !injection::reserve_game_vm_stack(state, 2))
	{
		return;
	}

	luau_pushcclosurek(
		state, context->host_callback, "OpenWF protected Pluto frame", 0, nullptr);
	auto* base = luau_restorestack(state, context->saved_top);
	if (state->outtop != base + 1
		|| base->type != owf_game_tag(LUAU_FUNCTION))
	{
		return;
	}
	const auto closure = *base;

	// Keep the new closure rooted on the DE stack while the registry key may be
	// interned/allocated. Then reorder the two already-rooted stack values into
	// key,value without exposing an unrooted GC pointer.
	luau_pushstring(state, host_registry_key);
	base = luau_restorestack(state, context->saved_top);
	if (state->outtop != base + 2)
	{
		return;
	}
	const auto key = base[1];
	base[0] = key;
	base[1] = closure;
	luau_settable(state, -10000);
	state->outtop = luau_restorestack(state, context->saved_top);

	// Read back the exact rooted closure before opening admission.
	luau_pushstring(state, host_registry_key);
	const auto type = luau_gettable(state, -10000);
	base = luau_restorestack(state, context->saved_top);
	const bool exact = state->outtop == base + 1
		&& type == static_cast<int>(owf_game_tag(LUAU_FUNCTION))
		&& base->type == closure.type
		&& base->value.as_uintptr == closure.value.as_uintptr;
	if (exact)
	{
		context->rooted = *base;
		context->exact = true;
	}
}

bool root_host_closure(
	luau_State* state,
	int(*host_callback)(luau_State*),
	luau_TValue& rooted) noexcept
{
	rooted = {};
	if (state == nullptr || host_callback == nullptr
		|| state->stack == nullptr || state->outtop == nullptr
		|| state->stack_last == nullptr || state->outtop < state->stack
		|| state->outtop > state->stack_last
		|| raw_protected_run == nullptr)
	{
		return false;
	}

	RawVmFrameSnapshot frame_snapshot{};
	if (!capture_raw_vm_frame(state, frame_snapshot)) return false;

	RootHostClosureContext context{};
	context.saved_top = luau_savestack(state, state->outtop);
	context.host_callback = host_callback;
	const auto status = raw_protected_run(
		state, &root_host_closure_protected, &context);

	// The raw runner restores only the error-jump link. The protected body may
	// grow/relocate both VM arrays or terminate with a child CallInfo active, so
	// recover every borrowed activation pointer by saved byte offset first.
	if (!restore_raw_vm_frame(state, frame_snapshot)) return false;
	if (status != 0 || !context.exact) return false;
	rooted = context.rooted;
	return true;
}

struct LockLease
{
	bool owned = false;
	~LockLease() noexcept
	{
		if (owned && lock_leave != nullptr) lock_leave(lock_holder);
	}
};

struct GenerationLease
{
	bool owned = false;
	~GenerationLease() noexcept
	{
		if (owned) in_flight.fetch_sub(1, std::memory_order_acq_rel);
	}
};

struct ThreadTransaction
{
	luau_State* prior_state = nullptr;
	std::uint64_t prior_generation = 0;
	std::uint32_t prior_depth = 0;
	ThreadTransaction(luau_State* state, std::uint64_t generation) noexcept
		: prior_state(transaction_state),
		  prior_generation(transaction_generation),
		  prior_depth(transaction_depth)
	{
		transaction_state = state;
		transaction_generation = generation;
		transaction_depth = prior_depth + 1;
	}
	~ThreadTransaction() noexcept
	{
		transaction_state = prior_state;
		transaction_generation = prior_generation;
		transaction_depth = prior_depth;
	}
};

void rollback_shutdown_hook(bool enabled, bool created) noexcept
{
	authority_ready.store(false, std::memory_order_release);
	if (enabled)
	{
		try { flash_shutdown_hook.disable(); }
		catch (...) {}
	}
	if (created)
	{
		try { flash_shutdown_hook.destroy(); }
		catch (...) {}
	}
	lock_enter = nullptr;
	lock_leave = nullptr;
	game_protected_call = nullptr;
	raw_protected_run = nullptr;
	vm_throw = nullptr;
	lock_holder = nullptr;
	flash_null_sentinel = nullptr;
}
}

bool initialise(bool exact_supported_build) noexcept
{
	if (authority_ready.load(std::memory_order_acquire)) return true;
	if (!exact_supported_build)
	{
		config::log("RENOVICE DE_VM_AUTHORITY rejected: executable is not the exact certified build");
		return false;
	}

	bool shutdown_created = false;
	bool shutdown_enabled = false;
	try
	{
		const auto range = soup::Module(nullptr).range;
		const auto enter = resolve_unique(range, game_version >= GV(44, 0, 0) ? signature_lock_enter_u44 : signature_lock_enter, "lock-enter");
		const auto leave = resolve_unique(range, game_version >= GV(44, 0, 0) ? signature_lock_leave_u44 : signature_lock_leave, "lock-leave");
		const auto dispatcher = resolve_unique(
			range, signature_locked_dispatcher, "locked-dispatcher");
		const auto pcall = resolve_unique(
			range, signature_protected_call, "protected-call");
		const auto raw_pcall = resolve_unique(
			range, signature_raw_protected_run, "raw-protected-run");
		const auto throw_error = resolve_unique(
			range, signature_vm_throw, "vm-throw");
		const auto shutdown = resolve_unique(
			range, signature_flash_shutdown, "flash-shutdown");
		if (!enter || !leave || !dispatcher || !pcall || !raw_pcall || !throw_error
			|| !shutdown)
			throw std::runtime_error("one or more primitives were not unique");

		const auto dispatcher_holder = dispatcher.add(26).rip().as<void*>();
		const auto dispatcher_enter = dispatcher.add(40).rip().as<void*>();
		const auto shutdown_null_sentinel = shutdown.add(0x2A).rip().as<void*>();
		if (dispatcher_enter != enter.as<void*>()
			|| !readable_committed_range(dispatcher_holder, sizeof(void*))
			|| !readable_committed_range(
				shutdown_null_sentinel, sizeof(void*)))
		{
			throw std::runtime_error(
				"locked dispatcher or Flash sentinel cross-check failed");
		}

		lock_enter = enter.as<ScriptMgrLock>();
		lock_leave = leave.as<ScriptMgrLock>();
		game_protected_call = pcall.as<ProtectedCall>();
		raw_protected_run = raw_pcall.as<RawProtectedRun>();
		vm_throw = throw_error.as<VmThrow>();
		lock_holder = dispatcher_holder;
		flash_null_sentinel = shutdown_null_sentinel;

		flash_shutdown_hook.target = shutdown.as<void*>();
		flash_shutdown_hook.detour = reinterpret_cast<void*>(
			&flash_shutdown_detour);
		flash_shutdown_hook.create();
		shutdown_created = true;
		flash_shutdown_hook.enable();
		shutdown_enabled = true;

		static constexpr char success[] =
			"RENOVICE DE_VM_AUTHORITY PASS lock=ScriptMgr pcall=protected raw=frame-restored throw=exact-status publication=raw-protected flash_lifecycle=shutdown-owned";
		conout << success << std::endl;
		config::log(success);
		// Commit readiness only after every fallible resolution, hook and report
		// step has completed. Catch paths always restore the all-null state.
		authority_ready.store(true, std::memory_order_release);
		return true;
	}
	catch (const std::exception& error)
	{
		rollback_shutdown_hook(shutdown_enabled, shutdown_created);
		const std::string failure = std::string(
			"RENOVICE DE_VM_AUTHORITY FAIL reason=") + error.what();
		conout << failure << std::endl;
		config::log(failure);
	}
	catch (...)
	{
		rollback_shutdown_hook(shutdown_enabled, shutdown_created);
		conout << "RENOVICE DE_VM_AUTHORITY FAIL reason=unknown-exception" << std::endl;
		config::log("RENOVICE DE_VM_AUTHORITY FAIL reason=unknown-exception");
	}
	return false;
}

bool ready() noexcept
{
	return authority_ready.load(std::memory_order_acquire);
}

bool commit_flash_publication(
	luau_State* state,
	void* flash_object,
	int(*host_callback)(luau_State*)) noexcept
{
	if (!ready() || lock_enter == nullptr || lock_leave == nullptr
		|| lock_holder == nullptr || raw_protected_run == nullptr)
	{
		return false;
	}

	// gFlashMgr's stock publisher already owns this recursive Windows critical
	// section. Reacquire it explicitly so every future caller of this public
	// commit boundary has the same ScriptMgr ownership contract.
	lock_enter(lock_holder);
	LockLease publication_lock{true};
	if (!ready()) return false;
	if (state == nullptr || state->global_state == nullptr || flash_object == nullptr)
	{
		close_generation("gFlashMgr.nil");
		return false;
	}

	const auto same = accepting.load(std::memory_order_acquire)
		&& published_state.load(std::memory_order_acquire) == state
		&& published_global_state.load(std::memory_order_acquire) == state->global_state
		&& published_flash.load(std::memory_order_acquire) == flash_object
		&& published_owner_thread.load(std::memory_order_acquire)
			== GetCurrentThreadId();
	if (same && host_closure_generation
		== published_generation.load(std::memory_order_acquire))
	{
		return true;
	}

	accepting.store(false, std::memory_order_release);
	luau_TValue next_host{};
	if (!root_host_closure(state, host_callback, next_host))
	{
		close_generation("gFlashMgr.host-root-failed");
		config::diagnostic_log(
			"RENOVICE DE_VM_AUTHORITY generation REJECT reason=host-root-failed",
			config::DiagnosticsMode::errors);
		return false;
	}
	published_state.store(state, std::memory_order_release);
	published_global_state.store(state->global_state, std::memory_order_release);
	published_flash.store(flash_object, std::memory_order_release);
	published_owner_thread.store(GetCurrentThreadId(), std::memory_order_release);
	const auto generation = published_generation.fetch_add(
		1, std::memory_order_acq_rel) + 1;
	host_closure = next_host;
	host_closure_generation = generation;
	accepting.store(true, std::memory_order_release);
	try
	{
		std::ostringstream event;
		event << "RENOVICE DE_VM_AUTHORITY generation OPEN generation="
			<< generation << " state=" << state << " vm=" << state->global_state
			<< " flash=" << flash_object << " thread=" << GetCurrentThreadId();
		config::diagnostic_log(event.str(), config::DiagnosticsMode::errors);
	}
	catch (...) {}
	return true;
}

TransactionResult transact(
	luau_State* required_state,
	bool require_idle,
	TransactionBody body,
	void* context) noexcept
{
	TransactionResult result;
	if (!ready() || body == nullptr
		|| !accepting.load(std::memory_order_acquire)
		|| lock_enter == nullptr || lock_leave == nullptr || lock_holder == nullptr)
	{
		return result;
	}

	lock_enter(lock_holder);
	LockLease lock{true};
	const auto generation = published_generation.load(std::memory_order_acquire);
	auto* const published_main_state = published_state.load(std::memory_order_acquire);
	auto* const global_state = published_global_state.load(std::memory_order_acquire);
	auto* const state = required_state != nullptr
		? required_state : published_main_state;
	const auto owner_thread = published_owner_thread.load(std::memory_order_acquire);
	if (!accepting.load(std::memory_order_acquire)
		|| generation == 0 || published_main_state == nullptr
		|| state == nullptr || global_state == nullptr
		|| state->global_state != global_state
		|| owner_thread == 0 || owner_thread != GetCurrentThreadId())
	{
		return result;
	}

	if (require_idle && (state->ci != state->base_ci
		|| state->stack == nullptr || state->stack_last == nullptr
		|| state->intop == nullptr || state->outtop == nullptr
		|| state->stack > state->intop || state->intop > state->outtop
		|| state->outtop > state->stack_last))
	{
		return result;
	}

	in_flight.fetch_add(1, std::memory_order_acq_rel);
	GenerationLease generation_lease{true};
	if (!accepting.load(std::memory_order_acquire)
		|| published_generation.load(std::memory_order_acquire) != generation
		|| published_state.load(std::memory_order_acquire) != published_main_state)
	{
		return result;
	}

	ThreadTransaction transaction(state, generation);
	try
	{
		result.generation = generation;
		const auto value = body(state, context);
		const bool generation_survived = transaction_generation_alive()
			&& published_state.load(std::memory_order_acquire) == published_main_state
			&& published_global_state.load(std::memory_order_acquire) == global_state
			&& published_owner_thread.load(std::memory_order_acquire) == owner_thread;
		if (generation_survived)
		{
			result.value = value;
			result.executed = true;
		}
		else
		{
			config::diagnostic_log(
				"RENOVICE DE_VM_AUTHORITY transaction retired during body",
				config::DiagnosticsMode::errors);
		}
	}
	catch (...)
	{
		config::diagnostic_log(
			"RENOVICE DE_VM_AUTHORITY transaction caught C++ exception",
			config::DiagnosticsMode::errors);
	}
	return result;
}

CurrentVmProtectedResult run_current_vm_protected(
	luau_State* state,
	CurrentVmProtectedBody body,
	void* context) noexcept
{
	CurrentVmProtectedResult result;
	if (!ready() || raw_protected_run == nullptr || state == nullptr
		|| body == nullptr || state->global_state == nullptr)
	{
		return result;
	}

	// An admitted transaction must stay on its exact state/generation. With no
	// transaction, admission comes only from an exact DE native hook which is
	// already executing this state on its owner thread; this primitive does not
	// attempt to manufacture that ownership or move the VM between threads.
	if (transaction_depth != 0 && !transaction_active_for(state)) return result;
	RawVmFrameSnapshot frame_snapshot{};
	if (!capture_raw_vm_frame(state, frame_snapshot)) return result;

	result.admitted = true;
	result.status = raw_protected_run(state, body, context);
	result.restored = restore_raw_vm_frame(state, frame_snapshot);
	return result;
}

CurrentVmProtectedResult run_current_vm_rethrowable(
	luau_State* state,
	CurrentVmProtectedBody body,
	void* context) noexcept
{
	CurrentVmProtectedResult result;
	if (!ready() || raw_protected_run == nullptr || vm_throw == nullptr
		|| state == nullptr || body == nullptr || state->global_state == nullptr)
	{
		return result;
	}

	if (transaction_depth != 0 && !transaction_active_for(state)) return result;
	RawVmFrameSnapshot frame_snapshot{};
	if (!capture_raw_vm_frame(state, frame_snapshot)) return result;

	result.admitted = true;
	result.status = raw_protected_run(state, body, context);
	if (result.status == 0)
	{
		result.restored = restore_raw_vm_frame(state, frame_snapshot);
	}
	// For an error, restoring outtop/CallInfo here would discard or unroot the
	// exact DE error object. The detour's outer C++ scope releases ownership and
	// then calls rethrow_current_vm_error without another VM operation.
	return result;
}

[[noreturn]] void rethrow_current_vm_error(
	luau_State* state,
	int status) noexcept
{
	// Admission guarantees vm_throw was resolved uniquely for the pinned build.
	// If this invariant is violated there is no faithful stock error path left;
	// terminate instead of returning into a corrupted VM activation.
	if (state == nullptr || status == 0 || vm_throw == nullptr)
	{
		std::terminate();
	}
	vm_throw(state, status);
	std::terminate();
}

int protected_call(
	luau_State* state,
	int arguments,
	int results,
	int error_function) noexcept
{
	if (!transaction_active_for(state) || game_protected_call == nullptr)
		return 2;
	return game_protected_call(state, arguments, results, error_function);
}

bool push_host_closure(luau_State* state) noexcept
{
	if (!transaction_active_for(state)
		|| host_closure_generation == 0
		|| host_closure_generation != transaction_generation
		|| host_closure.type != owf_game_tag(LUAU_FUNCTION))
	{
		return false;
	}
	return injection::append_game_vm_stack_value_reserved(state, host_closure);
}

bool transaction_active_for(const luau_State* state) noexcept
{
	return transaction_depth != 0 && state != nullptr
		&& transaction_state == state
		&& accepting.load(std::memory_order_acquire)
		&& transaction_generation != 0
		&& transaction_generation == published_generation.load(
			std::memory_order_acquire);
}

bool transaction_generation_alive() noexcept
{
	return transaction_depth != 0 && transaction_generation != 0
		&& accepting.load(std::memory_order_acquire)
		&& transaction_generation == published_generation.load(
			std::memory_order_acquire);
}

std::uint64_t transaction_generation_id() noexcept
{
	return transaction_depth == 0 ? 0 : transaction_generation;
}

std::uint64_t active_generation() noexcept
{
	return published_generation.load(std::memory_order_acquire);
}
}
