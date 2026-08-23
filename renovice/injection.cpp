#include "injection.hpp"

#include "addon_transaction.hpp"
#include "config.hpp"
#include "injection_core.hpp"
#include "replacements.hpp"
#include "riven.hpp"
#include "swf.hpp"

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
#include <sstream>
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
	ScriptKind kind = ScriptKind::Ordinary;
};

struct AddonRecord
{
	std::string name;
	std::string registry_key;
};

struct RunResult
{
	bool completed = false;
	bool registry_restored = false;
	int protected_call_result = 0;
	int closure_tag = -1;
	int result_tag = -1;
	bool lifecycle_stored = false;
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
std::vector<AddonRecord> active_addons;
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
bool generation_active = false;
std::uint64_t next_generation = 1;
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
		if (kind == ScriptKind::ExperimentalPersistent || kind == ScriptKind::ExperimentalSpawn)
		{
			conout << "RENOVICE Inject transaction rejected: experimental "
				<< (kind == ScriptKind::ExperimentalSpawn ? "spawn" : "persistent")
				<< " module is not enabled in the source port: " << name << std::endl;
			return false;
		}
		Chunk chunk;
		chunk.name = name;
		chunk.kind = kind;
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

void set_registry_nil(luau_State* state, luau_TValue* base, const char* key)
{
	base->value.as_uintptr = 0;
	base->type = LUAU_NIL;
	state->outtop = base + 1;
	setfield(state, -10000, key);
}

RunResult run_guarded(
	luau_State* state,
	void* manager,
	void* descriptor,
	const char* lifecycle_key,
	bool pass_global_argument
)
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

	// Ordinary Inject/addon chunks use the current VM global environment. A hot
	// replacement instead preserves the exact module environment captured when
	// that stock module originally loaded, so its top-level assignments replace
	// ActivateAbility and sibling exports in place.
	if (pass_global_argument)
	{
		getfield(state, -10002, "_G");
		if (is_table(guard.base->type))
		{
			*reinterpret_cast<void**>(reinterpret_cast<unsigned char*>(descriptor) + 0x58)
				= reinterpret_cast<void*>(guard.base->value.as_uintptr);
		}
		state->outtop = guard.base;
	}

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

	guard.stage = 5;
	if (pass_global_argument)
	{
		// Supply both stable host contexts explicitly. Older Inject chunks that
		// read only `local global = ...` remain compatible; addons that need
		// Warframe's shared cross-module table use the second `_T` argument
		// instead of assuming `_G._T` has identical lookup semantics.
		getfield(state, -10002, "_G");
		getfield(state, -10002, "_T");
		result.protected_call_result = protected_call(state, 2, 1, 0);
		result.result_tag = (guard.base + 1)->type;
	}
	else
	{
		result.protected_call_result = protected_call(state, 0, 0, 0);
		result.result_tag = -1;
	}
	if (result.protected_call_result == 0 && lifecycle_key != nullptr)
	{
		if (!is_table(result.result_tag))
		{
			result.protected_call_result = -1;
		}
		else
		{
			guard.stage = 7;
			*guard.base = *(guard.base + 1);
			state->outtop = guard.base + 1;
			setfield(state, -10000, lifecycle_key);
			result.lifecycle_stored = true;

			state->outtop = guard.base;
			getfield(state, -10000, lifecycle_key);
			getfield(state, -1, "activate");
			const bool activate_valid = is_function((guard.base + 1)->type);
			state->outtop = guard.base + 1;
			getfield(state, -1, "cleanup");
			const bool cleanup_valid = is_function((guard.base + 1)->type);
			if (!activate_valid || !cleanup_valid)
			{
				set_registry_nil(state, guard.base, lifecycle_key);
				result.lifecycle_stored = false;
				result.protected_call_result = -2;
			}
		}
	}

	guard.stage = 6;
	*guard.base = guard.borrowed_original;
	state->outtop = guard.base + 1;
	setfield(state, -10000, guard.key);
	guard.registry_may_be_shadowed = false;
	restore_lua_top();
	finish_guard();
	result.completed = result.protected_call_result == 0
		&& (lifecycle_key == nullptr || result.lifecycle_stored);
	result.registry_restored = true;
	return result;
}

bool lifecycle_operation(luau_State* state, const AddonRecord& addon, const char* field)
{
	const char* operation = field == nullptr ? "release" : field;
	auto log_failure = [&](const char* reason)
	{
		std::ostringstream failure;
		failure << "RENOVICE addon lifecycle FAIL " << addon.name
			<< " field=" << operation << " reason=" << reason;
		conout << failure.str() << std::endl;
		config::log(failure.str());
	};
	if (state == nullptr || IsBadReadPtr(state, sizeof(luau_State)) || state->outtop == nullptr)
	{
		log_failure("state-unavailable");
		return false;
	}
	std::memset(&guard, 0, sizeof(guard));
	guard.state = state;
	guard.base = state->outtop;
	guard.thread_id = GetCurrentThreadId();
	guard.handler = AddVectoredExceptionHandler(1, fault_handler);
	if (guard.handler == nullptr)
	{
		log_failure("exception-guard-unavailable");
		return false;
	}
	if (setjmp(guard.jump) != 0)
	{
		restore_lua_top();
		finish_guard();
		conout << "RENOVICE addon lifecycle FAULT " << addon.name
			<< " field=" << operation
			<< " exception_code=" << static_cast<std::uint32_t>(guard.fault_code)
			<< " address=" << guard.fault_address << std::endl;
		std::ostringstream failure;
		failure << "RENOVICE addon lifecycle FAULT " << addon.name
			<< " field=" << operation
			<< " exception_code=" << static_cast<std::uint32_t>(guard.fault_code)
			<< " address=" << guard.fault_address;
		config::log(failure.str());
		return false;
	}
	guard.active = 1;
	guard.stage = 20;
	check_stack(state, 4);
	if (field == nullptr)
	{
		set_registry_nil(state, guard.base, addon.registry_key.c_str());
	}
	else
	{
		getfield(state, -10000, addon.registry_key.c_str());
		if (!is_table(guard.base->type))
		{
			restore_lua_top();
			finish_guard();
			log_failure("lifecycle-root-not-table");
			return false;
		}
		getfield(state, -1, field);
		if (!is_function((guard.base + 1)->type))
		{
			restore_lua_top();
			finish_guard();
			log_failure("operation-not-function");
			return false;
		}
		state->outtop = guard.base + 2;
		if (protected_call(state, 0, 0, 0) != 0)
		{
			restore_lua_top();
			finish_guard();
			log_failure("protected-call-rejected");
			return false;
		}
	}
	restore_lua_top();
	finish_guard();
	return true;
}

void loader_detour(void* manager, void* descriptor)
{
	replacements::observe_module_load(manager, descriptor);
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

bool run_chunk(
	const Chunk& chunk,
	luau_State* boundary_state,
	const std::string* lifecycle_key = nullptr,
	void* execution_environment = nullptr,
	bool pass_global_argument = true
)
{
	void* manager = captured_manager;
	if (manager == nullptr || IsBadReadPtr(manager, 0x28))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": manager unavailable" << std::endl;
		return false;
	}
	auto* manager_state = *reinterpret_cast<luau_State**>(
		reinterpret_cast<unsigned char*>(manager) + 0x20);
	if (manager_state == nullptr || IsBadReadPtr(manager_state, sizeof(luau_State)))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": manager state unavailable" << std::endl;
		return false;
	}
	const bool boundary_readable = boundary_state != nullptr
		&& !IsBadReadPtr(boundary_state, sizeof(luau_State));
	const bool shared_global = boundary_readable
		&& manager_state->global_state != nullptr
		&& manager_state->global_state == boundary_state->global_state;
	if (!valid_execution_boundary(true, boundary_readable, shared_global))
	{
		conout << "RENOVICE Inject skipped " << chunk.name
			<< ": current DE execution boundary is not in the captured manager VM" << std::endl;
		return false;
	}

	void* game_buffer = game_allocate(chunk.bytes.size(), 0);
	if (game_buffer == nullptr || IsBadWritePtr(game_buffer, chunk.bytes.size()))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": game allocation failed" << std::endl;
		return false;
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
	*reinterpret_cast<void**>(fabricated_descriptor + 0x58)
		= execution_environment != nullptr ? execution_environment : captured_environment;

	const auto result = run_guarded(
		boundary_state,
		manager,
		fabricated_descriptor,
		lifecycle_key == nullptr ? nullptr : lifecycle_key->c_str(),
		pass_global_argument);
	if (result.completed && result.registry_restored)
	{
		conout << "RENOVICE Inject PASS " << chunk.name
			<< " closure_tag=" << result.closure_tag
			<< " pcall=" << result.protected_call_result
			<< " result_tag=" << result.result_tag << std::endl;
		return true;
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
			<< " pcall=" << result.protected_call_result
			<< " result_tag=" << result.result_tag
			<< " registry_restored=" << result.registry_restored << std::endl;
		std::ostringstream failure;
		failure << "RENOVICE Inject FAIL " << chunk.name
			<< " fault_stage=" << result.fault_stage
			<< " fault_code=" << result.fault_code
			<< " closure_tag=" << result.closure_tag
			<< " pcall=" << result.protected_call_result
			<< " result_tag=" << result.result_tag
			<< " registry_restored=" << result.registry_restored;
		config::log(failure.str());
	}
	if (lifecycle_key != nullptr)
	{
		AddonRecord failed{chunk.name, *lifecycle_key};
		if (!lifecycle_operation(boundary_state, failed, nullptr))
		{
			conout << "RENOVICE ADDON FATAL: failed lifecycle root could not be released" << std::endl;
			subsystem_enabled.store(false, std::memory_order_release);
		}
	}
	return false;
}

bool apply_generation(
	const std::vector<Chunk>& candidate,
	luau_State* boundary_state,
	const char* trigger
)
{
	const auto generation = next_generation++;
	auto* state = boundary_state;
	if (state == nullptr || IsBadReadPtr(state, sizeof(luau_State)))
	{
		conout << "RENOVICE ADDON ROLLBACK: current DE execution boundary unavailable" << std::endl;
		return false;
	}
	std::vector<AddonRecord> staged;
	std::size_t addon_index = 0;
	for (const auto& chunk : candidate)
	{
		if (chunk.kind != ScriptKind::ManagedAddon) continue;
		AddonRecord addon;
		addon.name = chunk.name;
		addon.registry_key = "__RENOVICE_ADDON_" + std::to_string(generation)
			+ "_" + std::to_string(addon_index++);
		if (!run_chunk(chunk, boundary_state, &addon.registry_key))
		{
			bool released = true;
			for (const auto& previous : staged)
			{
				released = lifecycle_operation(state, previous, nullptr) && released;
			}
			if (!released)
			{
				conout << "RENOVICE ADDON FATAL: staged lifecycle roots could not be released" << std::endl;
				subsystem_enabled.store(false, std::memory_order_release);
			}
			conout << "RENOVICE ADDON ROLLBACK stage failed: " << chunk.name
				<< " previous generation remains active" << std::endl;
			return false;
		}
		staged.emplace_back(std::move(addon));
	}

	const auto transaction = commit_addon_generation(
		active_addons,
		staged,
		[&](const AddonRecord& addon) { return lifecycle_operation(state, addon, "cleanup"); },
		[&](const AddonRecord& addon) { return lifecycle_operation(state, addon, "activate"); },
		[&](const AddonRecord& addon) { return lifecycle_operation(state, addon, nullptr); });
	if (transaction != TransactionResult::Committed)
	{
		const char* label = "unknown";
		switch (transaction)
		{
		case TransactionResult::CleanupRejected: label = "old cleanup rejected"; break;
		case TransactionResult::ActivationRejected: label = "new activation rejected"; break;
		case TransactionResult::ReleaseRejected: label = "old registry release rejected"; break;
		case TransactionResult::RollbackFailed: label = "rollback reactivation failed"; break;
		case TransactionResult::Committed: break;
		}
		conout << "RENOVICE ADDON "
			<< (transaction == TransactionResult::RollbackFailed
				|| transaction == TransactionResult::ReleaseRejected ? "FATAL" : "ROLLBACK")
			<< ": " << label << std::endl;
		config::log(std::string("RENOVICE ADDON ROLLBACK: ") + label);
		if (transaction == TransactionResult::ReleaseRejected)
		{
			active_chunks = candidate;
			generation_active = true;
		}
		if (transaction == TransactionResult::RollbackFailed
			|| transaction == TransactionResult::ReleaseRejected)
		{
			subsystem_enabled.store(false, std::memory_order_release);
		}
		return false;
	}

	active_chunks = candidate;
	generation_active = true;
	std::size_t ordinary_failures = 0;
	for (const auto& chunk : active_chunks)
	{
		if (chunk.kind == ScriptKind::Ordinary && !run_chunk(chunk, boundary_state))
		{
			++ordinary_failures;
		}
	}
	conout << "RENOVICE RELOAD PASS trigger=" << trigger
		<< " generation=" << generation
		<< " addons=" << active_addons.size()
		<< " one_shots=" << (active_chunks.size() - active_addons.size())
		<< " one_shot_failures=" << ordinary_failures
		<< " applies=immediate-safe-boundary/next-event" << std::endl;
	std::ostringstream success;
	success << "RENOVICE RELOAD PASS trigger=" << trigger
		<< " generation=" << generation
		<< " addons=" << active_addons.size()
		<< " one_shots=" << (active_chunks.size() - active_addons.size())
		<< " one_shot_failures=" << ordinary_failures;
	config::log(success.str());
	if (ordinary_failures != 0)
	{
		conout << "RENOVICE warning: managed addon commit succeeded, but one-shot failures cannot be transactionally undone" << std::endl;
	}
	return true;
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

bool execute_module_refresh(
	const std::string& name,
	const std::vector<unsigned char>& bytes,
	void* environment,
	luau_State* state
)
{
	if (bytes.empty() || environment == nullptr)
	{
		return false;
	}
	Chunk chunk;
	chunk.name = name;
	chunk.bytes = bytes;
	chunk.kind = ScriptKind::Ordinary;
	return run_chunk(chunk, state, nullptr, environment, false);
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
	const auto addons = std::count_if(active_chunks.begin(), active_chunks.end(), [](const Chunk& chunk)
	{
		return chunk.kind == ScriptKind::ManagedAddon;
	});
	conout << "RENOVICE additive injection enabled: staged_chunks=" << active_chunks.size()
		<< " managed_addons=" << addons
		<< " (legacy persist/spawn disabled)" << std::endl;
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

void poll_f9(bool allow_reload) noexcept
{
	if (!subsystem_enabled.load(std::memory_order_acquire))
	{
		return;
	}
	const auto key_state = GetAsyncKeyState(VK_F9);
	const bool down = (key_state & 0x8000) != 0;
	const bool pressed_since_poll = (key_state & 0x0001) != 0;
	if (consume_f9_signal(down, pressed_since_poll, allow_reload, f9_was_down))
	{
		const bool already_pending = f9_pending.exchange(true, std::memory_order_acq_rel);
		if (!already_pending)
		{
			conout << "RENOVICE F9 QUEUED source=GetAsyncKeyState" << std::endl;
			config::log("RENOVICE F9 QUEUED source=GetAsyncKeyState");
		}
	}
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
	if (reload)
	{
		conout << "RENOVICE F9 DRAIN entered same-VM script boundary" << std::endl;
		config::log("RENOVICE F9 DRAIN entered same-VM script boundary");
	}

	auto discard_prepared = []
	{
		config::discard_prepared_reload();
		swf::discard_prepared_reload();
		replacements::discard_prepared_reload();
		riven::discard_prepared_gate();
	};
	auto commit_prepared = []
	{
		config::commit_prepared_reload();
		swf::commit_prepared_reload();
		replacements::commit_prepared_reload();
		riven::commit_prepared_gate();
	};

	bool transaction_valid = true;
	std::vector<Chunk> candidate;
	if (reload)
	{
		if (!config::prepare_reload())
		{
			conout << "RENOVICE F9 configuration reload rejected: previous flags retained" << std::endl;
			transaction_valid = false;
		}
		if (transaction_valid && !swf::prepare_reload())
		{
			conout << "RENOVICE F9 SWF reload rejected: previous snapshot retained" << std::endl;
			transaction_valid = false;
		}
		if (transaction_valid && !replacements::prepare_reload())
		{
			conout << "RENOVICE F9 Lua replacement reload rejected: previous snapshot retained" << std::endl;
			transaction_valid = false;
		}
		if (transaction_valid && !riven::prepare_gate_reload())
		{
			conout << "RENOVICE F9 Riven gate reload rejected: previous gate retained" << std::endl;
			transaction_valid = false;
		}
		if (transaction_valid && !scan_snapshot(candidate)) transaction_valid = false;
		if (!transaction_valid) discard_prepared();
	}

	const auto current_flags = config::flags();
	const bool should_apply = reload || !generation_active || (region && current_flags.auto_spawn);
	if (transaction_valid && should_apply)
	{
		if (!reload && !scan_snapshot(candidate)) transaction_valid = false;
		if (transaction_valid
			&& apply_generation(candidate, state, reload ? "F9" : (generation_active ? "region" : "startup")))
		{
			if (reload)
			{
				commit_prepared();
				const bool module_refresh_complete = replacements::reexecute_changed_loaded(state);
				if (!module_refresh_complete)
				{
					conout << "RENOVICE F9 module refresh incomplete; replacement map remains committed for the next natural load" << std::endl;
				}
				config::log(module_refresh_complete
					? "RENOVICE F9 COMMITTED module_refresh=PASS"
					: "RENOVICE F9 COMMITTED module_refresh=INCOMPLETE");
			}
		}
		else
		{
			if (reload) discard_prepared();
			conout << "RENOVICE RELOAD ROLLBACK: previous managed generation retained when possible" << std::endl;
			if (reload)
			{
				config::log("RENOVICE F9 ROLLBACK during managed generation apply");
			}
		}
	}
	else if (!transaction_valid)
	{
		conout << "RENOVICE RELOAD ROLLBACK: validation failed before addon staging" << std::endl;
		if (reload)
		{
			config::log("RENOVICE F9 ROLLBACK before addon staging");
		}
	}
	else if (region)
	{
		config::verbose_log("RENOVICE region reload skipped because AutoSpawn is false");
	}
	execution_running.store(false, std::memory_order_release);
}
}
