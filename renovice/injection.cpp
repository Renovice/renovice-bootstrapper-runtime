#include "injection.hpp"

#include "config.hpp"
#include "injection_core.hpp"

#include <algorithm>
#include <atomic>
#include <csetjmp>
#include <cstdint>
#include <cstring>
#include <exception>
#include <filesystem>
#include <fstream>
#include <limits>
#include <mutex>
#include <string>
#include <utility>
#include <vector>

#include <winsock2.h>
#include <windows.h>

#include <base.hpp>
#include <DetourHook.hpp>
#include <Module.hpp>
#include <Pattern.hpp>
#include <Pointer.hpp>

#include "../owf_console.hpp"
#include "../owf_luau.hpp"

namespace renovice::injection
{
namespace
{
using Loader = void(*)(void* manager, void* descriptor);
using KeyBuilder = char*(*)(char* output, long long capacity, void* handle_pair);
using FieldFunction = void(*)(luau_State* state, int index, const char* key);
using ProtectedCall = int(*)(luau_State* state, int arguments, int results, int error_function);
using CheckStack = void(*)(luau_State* state, int slots);
using GameAllocate = void*(*)(std::size_t size, unsigned int flags);

constexpr int deployed_table_tag = 7;
constexpr int deployed_function_tag = 8;

struct Chunk
{
	std::string name;
	std::vector<unsigned char> bytes;
};

struct RunResult
{
	bool completed = false;
	bool registry_restored = false;
	int protected_call_result = 0;
	int closure_tag = -1;
	int result_tag = -1;
	int fault_stage = 0;
	unsigned long fault_code = 0;
	void* fault_address = nullptr;
};

struct GuardState
{
	std::jmp_buf jump;
	volatile LONG active = 0;
	DWORD thread_id = 0;
	PVOID handler = nullptr;
	luau_State* state = nullptr;
	luau_TValue* base = nullptr;
	luau_TValue borrowed_original{};
	FieldFunction setfield = nullptr;
	char key[0x110]{};
	bool registry_may_be_shadowed = false;
	bool cleanup_attempted = false;
	int stage = 0;
	int fault_stage = 0;
	unsigned long fault_code = 0;
	void* fault_address = nullptr;
};

soup::DetourHook loader_hook;
KeyBuilder key_builder = nullptr;
FieldFunction getfield = nullptr;
FieldFunction setfield = nullptr;
ProtectedCall protected_call = nullptr;
CheckStack check_stack = nullptr;
GameAllocate game_allocate = nullptr;

std::vector<Chunk> active_chunks;
std::mutex capture_mutex;
void* captured_manager = nullptr;
std::uint32_t captured_name_handle[2]{};
void* captured_environment = nullptr;
std::atomic_bool context_ready = false;
std::atomic_bool subsystem_enabled = false;
std::atomic_bool region_pending = false;
std::atomic_bool f9_pending = false;
std::atomic_bool execution_running = false;
std::atomic<std::uint64_t> last_undump_millis = 0;
bool f9_was_down = false;
GuardState guard;

alignas(16) unsigned char fabricated_name_object[0x40]{};
alignas(16) unsigned char fabricated_descriptor[0x60]{};
std::uint32_t fabricated_name_part = 0;

bool read_file(const std::filesystem::path& path, std::vector<unsigned char>& bytes)
{
	std::error_code ec;
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || !valid_chunk_size(size)
		|| size > static_cast<std::uintmax_t>((std::numeric_limits<std::streamsize>::max)()))
	{
		return false;
	}
	bytes.resize(static_cast<std::size_t>(size));
	std::ifstream input(path, std::ios::binary);
	return input
		&& static_cast<bool>(input.read(
			reinterpret_cast<char*>(bytes.data()),
			static_cast<std::streamsize>(bytes.size())
		));
}

bool scan_snapshot(std::vector<Chunk>& snapshot)
{
	const auto& directory = config::injection_directory();
	std::error_code ec;
	std::filesystem::create_directories(directory, ec);
	if (ec)
	{
		conout << "RENOVICE Inject directory error: " << ec.message() << std::endl;
		return false;
	}

	for (std::filesystem::directory_iterator it(directory, ec), end; !ec && it != end; it.increment(ec))
	{
		if (!it->is_regular_file(ec))
		{
			if (ec) break;
			continue;
		}
		const auto path = it->path();
		if (!is_lua_bytecode_extension(path.extension().string()))
		{
			continue;
		}
		const auto name = path.filename().string();
		const auto kind = classify_script(name);
		if (kind != ScriptKind::Ordinary)
		{
			conout << "RENOVICE Inject transaction rejected: experimental "
				<< (kind == ScriptKind::ExperimentalSpawn ? "spawn" : "persistent")
				<< " module is not enabled in the source port: " << name << std::endl;
			return false;
		}
		Chunk chunk;
		chunk.name = name;
		if (!read_file(path, chunk.bytes))
		{
			conout << "RENOVICE Inject transaction rejected: unreadable, empty, or oversized "
				<< name << std::endl;
			return false;
		}
		snapshot.emplace_back(std::move(chunk));
	}
	if (ec)
	{
		conout << "RENOVICE Inject scan error: " << ec.message() << std::endl;
		return false;
	}
	std::sort(snapshot.begin(), snapshot.end(), [](const Chunk& lhs, const Chunk& rhs)
	{
		return lhs.name < rhs.name;
	});
	return true;
}

template <typename Function>
Function resolve_unique(const soup::Range& range, const char* pattern, const char* label)
{
	soup::Pointer hits[2]{};
	const auto count = range.scanWithMultipleResults(soup::Pattern(pattern), hits);
	if (count != 1)
	{
		conout << "RENOVICE Inject symbol rejected: " << label << " matches=" << count << std::endl;
		return nullptr;
	}
	conout << "RENOVICE Inject symbol: " << label << " target=" << hits[0].as<void*>() << std::endl;
	return hits[0].as<Function>();
}

bool is_table(int tag) noexcept
{
	// The deployed injector recorded tag 7 for _G, whereas the restored OpenWF
	// ABI header names tag 6 as LUAU_TABLE. _G cannot legitimately be a
	// function, so accepting both preserves the observed build while keeping
	// the source ABI usable. The live smoke test will settle this discrepancy.
	return tag == LUAU_TABLE || tag == deployed_table_tag;
}

bool is_function(int tag) noexcept
{
	return tag == LUAU_FUNCTION || tag == deployed_function_tag;
}

LONG CALLBACK fault_handler(EXCEPTION_POINTERS* information)
{
	if (guard.active
		&& guard.thread_id == GetCurrentThreadId()
		&& (information->ExceptionRecord->ExceptionCode & 0xc0000000u) == 0xc0000000u)
	{
		if (guard.fault_code == 0)
		{
			guard.fault_stage = guard.stage;
			guard.fault_code = information->ExceptionRecord->ExceptionCode;
			guard.fault_address = information->ExceptionRecord->ExceptionAddress;
		}
		guard.active = 0;
		std::longjmp(guard.jump, 1);
	}
	return EXCEPTION_CONTINUE_SEARCH;
}

void finish_guard() noexcept
{
	guard.active = 0;
	if (guard.handler != nullptr)
	{
		RemoveVectoredExceptionHandler(guard.handler);
		guard.handler = nullptr;
	}
}

void restore_lua_top() noexcept
{
	if (guard.state != nullptr && guard.base != nullptr
		&& !IsBadWritePtr(&guard.state->outtop, sizeof(guard.state->outtop)))
	{
		guard.state->outtop = guard.base;
	}
}

bool try_restore_registry_after_fault() noexcept
{
	if (!guard.registry_may_be_shadowed || guard.cleanup_attempted
		|| guard.state == nullptr || guard.base == nullptr || guard.setfield == nullptr)
	{
		return !guard.registry_may_be_shadowed;
	}
	if (IsBadWritePtr(guard.base, sizeof(luau_TValue))
		|| IsBadWritePtr(&guard.state->outtop, sizeof(guard.state->outtop)))
	{
		return false;
	}
	guard.cleanup_attempted = true;
	guard.active = 1;
	guard.stage = 6;
	*guard.base = guard.borrowed_original;
	guard.state->outtop = guard.base + 1;
	guard.setfield(guard.state, -10000, guard.key);
	guard.registry_may_be_shadowed = false;
	guard.state->outtop = guard.base;
	return true;
}

RunResult run_guarded(luau_State* state, void* manager, void* descriptor)
{
	RunResult result;
	if (state == nullptr || manager == nullptr || descriptor == nullptr
		|| IsBadReadPtr(state, sizeof(luau_State)) || state->outtop == nullptr)
	{
		return result;
	}

	std::memset(&guard, 0, sizeof(guard));
	guard.state = state;
	guard.base = state->outtop;
	guard.setfield = setfield;
	guard.thread_id = GetCurrentThreadId();
	guard.handler = AddVectoredExceptionHandler(1, fault_handler);
	if (guard.handler == nullptr)
	{
		return result;
	}

	if (setjmp(guard.jump) != 0)
	{
		// A first fault attempts the historically critical registry rollback
		// while the same thread-gated VEH is still installed. A second fault
		// returns here with cleanup_attempted already set and fails closed.
		const bool restored = try_restore_registry_after_fault();
		restore_lua_top();
		finish_guard();
		result.registry_restored = restored;
		result.fault_stage = guard.fault_stage;
		result.fault_code = guard.fault_code;
		result.fault_address = guard.fault_address;
		return result;
	}

	guard.active = 1;
	guard.stage = 1;
	key_builder(guard.key, 0x104, captured_name_handle);
	if (check_stack != nullptr)
	{
		check_stack(state, 8);
	}

	// Fetch the real global table and seed the fabricated descriptor so
	// GETGLOBAL/NAMECALL in the injected closure resolves native Warframe APIs.
	getfield(state, -10002, "_G");
	if (is_table(guard.base->type))
	{
		*reinterpret_cast<void**>(reinterpret_cast<unsigned char*>(descriptor) + 0x58)
			= reinterpret_cast<void*>(guard.base->value.as_uintptr);
	}
	state->outtop = guard.base;

	guard.stage = 2;
	getfield(state, -10000, guard.key);
	guard.borrowed_original = *guard.base;
	guard.registry_may_be_shadowed = true;
	guard.stage = 3;
	reinterpret_cast<Loader>(loader_hook.original)(manager, descriptor);
	state->outtop = guard.base + 1;

	guard.stage = 4;
	getfield(state, -10000, guard.key);
	result.closure_tag = (guard.base + 1)->type;
	if (!is_function(result.closure_tag))
	{
		guard.stage = 6;
		*guard.base = guard.borrowed_original;
		state->outtop = guard.base + 1;
		setfield(state, -10000, guard.key);
		guard.registry_may_be_shadowed = false;
		restore_lua_top();
		finish_guard();
		result.registry_restored = true;
		return result;
	}

	getfield(state, -10002, "_G");
	guard.stage = 5;
	result.protected_call_result = protected_call(state, 1, 1, 0);
	result.result_tag = (guard.base + 1)->type;

	guard.stage = 6;
	*guard.base = guard.borrowed_original;
	state->outtop = guard.base + 1;
	setfield(state, -10000, guard.key);
	guard.registry_may_be_shadowed = false;
	restore_lua_top();
	finish_guard();
	result.completed = true;
	result.registry_restored = true;
	return result;
}

void loader_detour(void* manager, void* descriptor)
{
	if (!context_ready.load(std::memory_order_acquire) && descriptor != nullptr
		&& !IsBadReadPtr(descriptor, 0x60))
	{
		std::lock_guard lock(capture_mutex);
		if (!context_ready.load(std::memory_order_relaxed))
		{
			void* name_object = *reinterpret_cast<void**>(
				reinterpret_cast<unsigned char*>(descriptor) + 0x08);
				void* environment = *reinterpret_cast<void**>(
					reinterpret_cast<unsigned char*>(descriptor) + 0x58);
				if (environment != nullptr && IsBadReadPtr(environment, 0x10))
				{
					environment = nullptr;
				}
			if (name_object != nullptr && !IsBadReadPtr(name_object, 0x30))
			{
				void** first_pointer = reinterpret_cast<void**>(
					reinterpret_cast<unsigned char*>(name_object) + 0x10);
				auto* second = reinterpret_cast<std::uint32_t*>(
					reinterpret_cast<unsigned char*>(name_object) + 0x2c);
				if (!IsBadReadPtr(first_pointer, sizeof(*first_pointer))
					&& *first_pointer != nullptr
					&& !IsBadReadPtr(*first_pointer, sizeof(std::uint32_t))
					&& !IsBadReadPtr(second, sizeof(*second)))
				{
					captured_name_handle[0] = *reinterpret_cast<std::uint32_t*>(*first_pointer);
					captured_name_handle[1] = *second;
					captured_environment = environment;
					captured_manager = manager;
					context_ready.store(true, std::memory_order_release);
					conout << "RENOVICE Inject captured live manager=" << manager
						<< " environment=" << environment << std::endl;
				}
			}
		}
	}
	reinterpret_cast<Loader>(loader_hook.original)(manager, descriptor);
}

void run_chunk(const Chunk& chunk, luau_State* boundary_state)
{
	void* manager = captured_manager;
	if (manager == nullptr || IsBadReadPtr(manager, 0x28))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": manager unavailable" << std::endl;
		return;
	}
	auto* manager_state = *reinterpret_cast<luau_State**>(
		reinterpret_cast<unsigned char*>(manager) + 0x20);
	if (manager_state == nullptr || IsBadReadPtr(manager_state, sizeof(luau_State)))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": manager state unavailable" << std::endl;
		return;
	}
	(void)boundary_state; // The boundary proves the thread; the manager owns the main VM state used for loading.

	void* game_buffer = game_allocate(chunk.bytes.size(), 0);
	if (game_buffer == nullptr || IsBadWritePtr(game_buffer, chunk.bytes.size()))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": game allocation failed" << std::endl;
		return;
	}
	std::memcpy(game_buffer, chunk.bytes.data(), chunk.bytes.size());

	fabricated_name_part = captured_name_handle[0];
	std::memset(fabricated_name_object, 0, sizeof(fabricated_name_object));
	*reinterpret_cast<void**>(fabricated_name_object + 0x10) = &fabricated_name_part;
	*reinterpret_cast<std::uint32_t*>(fabricated_name_object + 0x2c) = captured_name_handle[1];

	std::memset(fabricated_descriptor, 0, sizeof(fabricated_descriptor));
	*reinterpret_cast<void**>(fabricated_descriptor + 0x08) = fabricated_name_object;
	*reinterpret_cast<void**>(fabricated_descriptor + 0x38) = game_buffer;
	*reinterpret_cast<std::uint32_t*>(fabricated_descriptor + 0x40)
		= static_cast<std::uint32_t>(chunk.bytes.size());
	*reinterpret_cast<void**>(fabricated_descriptor + 0x58) = captured_environment;

	const auto result = run_guarded(manager_state, manager, fabricated_descriptor);
	if (result.completed && result.registry_restored)
	{
		conout << "RENOVICE Inject PASS " << chunk.name
			<< " closure_tag=" << result.closure_tag
			<< " pcall=" << result.protected_call_result
			<< " result_tag=" << result.result_tag << std::endl;
	}
	else if (result.fault_code != 0)
	{
		conout << "RENOVICE Inject FAULT " << chunk.name
			<< " stage=" << result.fault_stage
			<< " exception_code=" << static_cast<std::uint32_t>(result.fault_code)
			<< " address=" << result.fault_address
			<< " registry_restored=" << result.registry_restored << std::endl;
	}
	else
	{
		conout << "RENOVICE Inject FAIL " << chunk.name
			<< " closure_tag=" << result.closure_tag
			<< " registry_restored=" << result.registry_restored << std::endl;
	}
}

bool install_loader_hook()
{
	const soup::Module game(nullptr);
	const auto& range = game.range;
	auto loader = resolve_unique<Loader>(range, signature_module_loader, "module loader");
	key_builder = resolve_unique<KeyBuilder>(range, signature_name_key_builder, "name-key builder");
	getfield = resolve_unique<FieldFunction>(range, signature_getfield, "getfield");
	setfield = resolve_unique<FieldFunction>(range, signature_setfield, "setfield");
	check_stack = resolve_unique<CheckStack>(range, signature_checkstack, "checkstack");
	game_allocate = resolve_unique<GameAllocate>(range, signature_game_allocator, "game allocator");
	protected_call = resolve_unique<ProtectedCall>(range, signature_protected_call, "protected call");
	if (loader == nullptr || key_builder == nullptr || getfield == nullptr
		|| setfield == nullptr || check_stack == nullptr || game_allocate == nullptr
		|| protected_call == nullptr)
	{
		return false;
	}

	loader_hook.target = reinterpret_cast<void*>(loader);
	loader_hook.detour = reinterpret_cast<void*>(&loader_detour);
	try
	{
		loader_hook.create();
	}
	catch (const std::exception& exception)
	{
		conout << "RENOVICE Inject loader hook failed closed: " << exception.what() << std::endl;
		return false;
	}
	if (!loader_hook.isCreated())
	{
		conout << "RENOVICE Inject loader hook failed closed: trampoline creation failed" << std::endl;
		return false;
	}
	loader_hook.enable();
	return true;
}
}

InitialiseResult initialise()
{
	std::vector<Chunk> snapshot;
	if (!scan_snapshot(snapshot))
	{
		return InitialiseResult::Failed;
	}
	if (!install_loader_hook())
	{
		return InitialiseResult::Failed;
	}
	active_chunks = std::move(snapshot);
	subsystem_enabled.store(true, std::memory_order_release);
	conout << "RENOVICE additive injection enabled: staged_chunks=" << active_chunks.size()
		<< " (ordinary one-shot mode; experimental persist/spawn disabled)" << std::endl;
	return InitialiseResult::Enabled;
}

void notify_undump() noexcept
{
	if (!subsystem_enabled.load(std::memory_order_acquire))
	{
		return;
	}
	const auto now = static_cast<std::uint64_t>(GetTickCount64());
	const auto previous = last_undump_millis.exchange(now, std::memory_order_acq_rel);
	if (previous == 0 || now - previous > 1500)
	{
		region_pending.store(true, std::memory_order_release);
	}
}

void poll_f9() noexcept
{
	if (!subsystem_enabled.load(std::memory_order_acquire))
	{
		return;
	}
	const bool down = (GetAsyncKeyState(VK_F9) & 0x8000) != 0;
	if (down && !f9_was_down)
	{
		f9_pending.store(true, std::memory_order_release);
	}
	f9_was_down = down;
}

void drain(luau_State* state)
{
	if (!subsystem_enabled.load(std::memory_order_acquire)
		|| !context_ready.load(std::memory_order_acquire)
		|| execution_running.exchange(true, std::memory_order_acq_rel))
	{
		return;
	}

	const bool reload = f9_pending.exchange(false, std::memory_order_acq_rel);
	const bool region = region_pending.exchange(false, std::memory_order_acq_rel);
	if (!reload && !region)
	{
		execution_running.store(false, std::memory_order_release);
		return;
	}

	bool snapshot_valid = true;
	if (reload || region)
	{
		if (reload && !config::reload())
		{
			conout << "RENOVICE F9 configuration reload rejected: previous flags retained" << std::endl;
			snapshot_valid = false;
		}
		std::vector<Chunk> candidate;
		snapshot_valid = snapshot_valid && scan_snapshot(candidate);
		if (snapshot_valid)
		{
			active_chunks = std::move(candidate);
			conout << "RENOVICE Inject snapshot committed: trigger="
				<< (reload ? "F9" : "region") << " chunks=" << active_chunks.size() << std::endl;
		}
		else
		{
			conout << "RENOVICE Inject snapshot rollback: previous generation retained" << std::endl;
		}
	}

	if (snapshot_valid || region)
	{
		for (const auto& chunk : active_chunks)
		{
			run_chunk(chunk, state);
		}
	}
	execution_running.store(false, std::memory_order_release);
}
}
