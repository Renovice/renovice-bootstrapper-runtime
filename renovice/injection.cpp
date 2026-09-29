#include "injection.hpp"

#include "addon_transaction.hpp"
#include "config.hpp"
#include "de_vm_authority.hpp"
#include "injection_core.hpp"
#include "de_proto_graph_u43.hpp"
#include "callback_runtime_bytecode.hpp"
#include "automatic_damage_runtime_bytecode.hpp"
#include "engine_damage.hpp"
#include "addon_trace_policy.hpp"
#include "caster_diagnostic_budget.hpp"
#include "injected_interrupt_budget.hpp"
#include "vm_stack_write.hpp"
#include "vm_api_frame.hpp"
#include "vm_memory_evidence.hpp"
#include "generation_ownership.hpp"
#include "replacements.hpp"
#include "riven.hpp"
#include "script_control.hpp"
#include "swf.hpp"

#include <algorithm>
#include <array>
#include <atomic>
#include <cmath>
#include <cstdio>
#include <csetjmp>
#include <cstdint>
#include <cstring>
#include <exception>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <limits>
#include <memory>
#include <mutex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include <winsock2.h>
#include <windows.h>
#include "diagnostic_read_probe.hpp"
#include <dbghelp.h>
#include <psapi.h>

#include <base.hpp>
#include <CompactDetourHook.hpp>
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
using Loader = bool(*)(void* manager, void* descriptor);
using KeyBuilder = char*(*)(char* output, long long capacity, void* handle_pair);
using FieldFunction = void(*)(luau_State* state, int index, const char* key);
using ProtectedCall = int(*)(luau_State* state, int arguments, int results, int error_function);
using VmExecute = void(*)(luau_State* state);
using DeLuauInterruptIncrement = std::uint32_t(*)(luau_State* state);
using CheckStack = int(*)(luau_State* state, int slots);
using GcBarrierBack = void(*)(luau_State*, luau_GCObject*, luau_GCObject**);
using GamePushValue = void(*)(luau_State* state, int index);
using GameAllocate = void*(*)(std::size_t size, unsigned int flags);

constexpr int deployed_table_tag = 7;
constexpr int deployed_function_tag = 8;
constexpr int deployed_userdata_tag = 9;
constexpr int deployed_string_tag = 6;
const std::string callback_runtime_registry_key = "RENOVICE.callback-runtime.v45";
const std::string diagnostic_trace_registry_key = "RENOVICE.diagnostic-trace-bridge.v76";
const std::string automatic_damage_runtime_registry_key =
	"RENOVICE.automatic-damage-runtime.v79";

struct Chunk
{
	std::string name;
	std::vector<unsigned char> bytes;
	ScriptKind kind = ScriptKind::Ordinary;
	std::uint64_t target_key = 0;
	// One `.targets.addon` file expands to one TargetManagedAddon chunk per
	// declared key. Each binding selects `returned.targets["<key>"]` as its
	// lifecycle root; the file name, bytes and Scripts policy stay shared.
	bool multi_target = false;
};

struct AddonRecord
{
	std::string name;
	std::string registry_key;
	std::uint64_t generation = 0;
	void* global_state = nullptr;
	std::uint32_t owner_thread = 0;
};

struct TargetAddonRecord
{
	struct NativeCallRequest
	{
		std::string name;
		bool before = false;
		bool after = false;
	};
	struct LuaCallRequest
	{
		std::int32_t prototype = -1;
		bool before = false;
		bool after = false;
	};

	AddonRecord addon;
	std::uint64_t target_key = 0;
	std::uint64_t content_key = 0;
	std::uintptr_t shared_table_identity = 0;
	// Exact module environment this binding's chunk executed in.
	void* bound_environment = nullptr;
	void* global_state = nullptr;
	std::uint32_t owner_thread = 0;
	bool requires_native_damage_adapters = false;
	bool requires_native_callsite_adapters = false;
	bool requires_lua_call_hooks = false;
	std::vector<NativeCallRequest> native_call_requests;
	std::vector<LuaCallRequest> lua_call_requests;
};

// Soup's compact detour resolves the target again when disable() runs. Once
// enabled, that first E9 resolves to the detour cave, so the library restores
// the original five bytes into the cave and leaves the function entry patched.
// Capture the resolved function entry before enabling and always restore that
// exact address. This class is used by the reloadable addon hooks only; the
// pinned Soup submodule remains unchanged and reproducible.
struct ReloadableCompactDetourHook : soup::CompactDetourHook
{
	void* installed_target = nullptr;
	bool installed = false;

	void create_captured()
	{
		installed_target = getEffectiveTarget();
		if (installed_target == nullptr)
		{
			throw std::runtime_error("compact detour target resolution failed");
		}
		soup::CompactDetourHook::create();
	}

	void enable_captured()
	{
		soup::CompactDetourHook::enable();
		installed = true;
	}

	[[nodiscard]] bool can_restore_captured() const noexcept
	{
		if (!installed) return true;
		if (installed_target == nullptr || original == nullptr || code_cave == nullptr)
		{
			return false;
		}
		const auto* const entry = static_cast<const std::uint8_t*>(installed_target);
		if (std::memcmp(entry, original, sizeof(jmp_trampoline)) == 0) return true;
		if (entry[0] != 0xE9u) return false;
		std::int32_t displacement = 0;
		std::memcpy(&displacement, entry + 1, sizeof(displacement));
		return exact_relative_jump_to(
			reinterpret_cast<std::uintptr_t>(installed_target),
			entry[0], displacement,
			reinterpret_cast<std::uintptr_t>(code_cave));
	}

	[[nodiscard]] bool restore_captured() noexcept
	{
		if (!installed) return true;
		if (!can_restore_captured()) return false;
		auto* const entry = static_cast<std::uint8_t*>(installed_target);
		if (std::memcmp(entry, original, sizeof(jmp_trampoline)) == 0)
		{
			installed = false;
			return true;
		}
		DWORD old_protection = 0;
		if (!VirtualProtect(
				entry, sizeof(jmp_trampoline), PAGE_EXECUTE_READWRITE,
				&old_protection))
		{
			return false;
		}
		std::memcpy(entry, original, sizeof(jmp_trampoline));
		FlushInstructionCache(
			GetCurrentProcess(), entry, sizeof(jmp_trampoline));
		DWORD ignored = 0;
		const bool protection_restored = VirtualProtect(
			entry, sizeof(jmp_trampoline), old_protection, &ignored) != FALSE;
		const bool bytes_restored =
			std::memcmp(entry, original, sizeof(jmp_trampoline)) == 0;
		installed = !bytes_restored;
		return bytes_restored && protection_restored;
	}

	[[nodiscard]] bool destroy_captured() noexcept
	{
		if (!restore_captured()) return false;
		if (code_cave != nullptr)
		{
			soup::CompactDetourHook::destroy();
		}
		code_cave = nullptr;
		installed_target = nullptr;
		installed = false;
		return true;
	}
};

struct NativeCallHookRecord
{
	std::string name;
	std::uint32_t hash = 0;
	luau_CFunction target = nullptr;
	ReloadableCompactDetourHook hook;
};

inline constexpr std::size_t maximum_native_call_hooks = 32;

struct TargetLoadBoundary
{
	std::uint64_t key = 0;
	std::uint32_t name_handle[2]{};
	bool valid = false;
	bool addon_target = false;
	bool pause_menu = false;
	bool diagnostic_damage_source = false;
};

struct TargetExecutionBoundary
{
	std::uint64_t key = 0;
	std::uint32_t name_handle[2]{};
	void* environment = nullptr;
	void* global_state = nullptr;
	void* root_proto = nullptr;
	bool valid = false;
};

struct TargetModuleIdentity
{
	std::uint64_t target_key = 0;
	void* global_state = nullptr;
	void* environment = nullptr;
	void* root_proto = nullptr;
	void* manager = nullptr;
	std::uint32_t name_handle[2]{};
	std::uint32_t owner_thread = 0;
	bool pause_attached = false;
	std::vector<TargetProtoRecord> prototypes;
	// False for the loader-recorded identity; true for the identity recorded
	// when that load's root prototype returned in a different environment.
	bool runtime_root = false;
};

struct TargetExecutionIdentity
{
	std::uint64_t target_key = 0;
	void* global_state = nullptr;
	void* environment = nullptr;
	void* root_proto = nullptr;
	std::vector<TargetProtoRecord> prototypes;
};

struct TargetCallsite
{
	std::uint64_t target_key = 0;
	std::int32_t prototype = -1;
	std::uint32_t instruction = 0;
	bool exact = false;
};

struct DiagnosticProtoIdentity
{
	std::uintptr_t address = 0;
	std::uintptr_t code = 0;
	std::int32_t instructions = 0;
	std::int32_t bytecode_id = -1;
	std::uint64_t body_key = 0;
	void* global_state = nullptr;
	std::string module_path;
	std::string module_name;
	DiagnosticProtoIdentity* next = nullptr;
};

struct DiagnosticDamageCallsite
{
	TargetCallsite callsite;
	std::string module_path;
	std::string module_name;
};

struct AutomaticDamageTraceContext
{
	bool active = false;
	std::uint64_t sequence = 0;
	DiagnosticDamageCallsite source;
	std::string target_type;
};

struct TargetLuaCall
{
	TargetCallsite callsite;
	luau_Closure* closure = nullptr;
};

struct TargetRootWatch
{
	std::uint64_t target_key = 0;
	const void* global_state = nullptr;
	const void* root_proto = nullptr;
};

// POD carried across the naked stock VM execute call; no ownership.
struct TargetRootEntry
{
	std::uint64_t target_key = 0;
	void* global_state = nullptr;
	void* root_proto = nullptr;
	void* environment = nullptr;
	bool valid = false;
};
static_assert(std::is_trivially_copyable_v<TargetRootEntry>);

struct TargetExecutionSnapshot
{
	std::uint64_t generation = 0;
	std::vector<TargetExecutionIdentity> identities;
	// Loader-recorded roots of modules with enabled target addons. Observed at
	// VM execute entry to learn the runtime environment each root ran in.
	std::vector<TargetRootWatch> roots;
	struct Providers
	{
		std::uint64_t key;
		const luau_GlobalState* vm;
		std::vector<AddonRecord> addons;
		std::vector<std::string> native_methods;
		std::vector<std::int32_t> lua_before_prototypes;
		bool native_damage = false;
		bool native_callsite = false;
	};
	std::vector<Providers> providers;
};

struct TargetScriptBinding
{
	std::uint64_t target_key = 0;
	void* global_state = nullptr;
	std::uintptr_t script_resource_identity = 0;
	std::uintptr_t ability_identity = 0;
	std::uint32_t owner_thread = 0;
};

struct ActiveRunScriptBoundary
{
	bool active = false;
	luau_State* state = nullptr;
	void* global_state = nullptr;
	luau_CallInfo* owner_call_info = nullptr;
	std::uint32_t owner_function_tag = LUAU_NIL;
	std::uintptr_t owner_function_identity = 0;
	std::uintptr_t script_resource_identity = 0;
	std::uintptr_t ability_identity = 0;
	std::uint32_t owner_thread = 0;
	std::uint64_t generation = 0;
	std::uint64_t token = 0;
};

static_assert(std::is_trivially_copyable_v<ActiveRunScriptBoundary>);

struct ActivePauseLoadBoundary
{
	bool active = false;
	std::uint64_t body_key = 0;
	std::uint32_t name_handle[2]{};
	std::uint32_t owner_thread = 0;
	std::size_t initialize_assignments = 0;
};

struct PendingTargetAddonRefresh
{
	std::uint64_t target_key = 0;
	void* global_state = nullptr;
	void* manager = nullptr;
	std::uint32_t name_handle[2]{};
	std::uint32_t owner_thread = 0;
};

struct RunResult
{
	bool completed = false;
	bool registry_restored = false;
	int protected_call_result = 0;
	int closure_tag = -1;
	int result_tag = -1;
	bool lifecycle_stored = false;
	bool exact_environment_used = false;
	void* borrowed_environment = nullptr;
	int fault_stage = 0;
	unsigned long fault_code = 0;
	void* fault_address = nullptr;
	int multi_target_failure = 0;
	int error_tag = -1;
	char error_text[lua_error_text_capacity]{};
};

static_assert(std::is_trivially_copyable_v<RunResult>);

struct GuardState
{
	std::jmp_buf jump;
	volatile LONG active = 0;
	DWORD thread_id = 0;
	PVOID handler = nullptr;
	luau_State* state = nullptr;
	void** outer_error_jump_slot = nullptr;
	void* outer_error_jump = nullptr;
	std::ptrdiff_t base_offset = 0;
	luau_TValue borrowed_original{};
	FieldFunction setfield = nullptr;
	char key[0x110]{};
	bool registry_may_be_shadowed = false;
	bool original_rooted = false;
	int stage = 0;
	int fault_stage = 0;
	unsigned long fault_code = 0;
	void* fault_address = nullptr;
};

soup::DetourHook loader_hook;
soup::DetourHook vm_execute_hook;
soup::DetourHook de_luau_interrupt_hook;
KeyBuilder key_builder = nullptr;
FieldFunction getfield = nullptr;
FieldFunction setfield = nullptr;
ProtectedCall protected_call = nullptr;
bool injected_interrupt_contract_ready = false;
std::atomic<bool> lua_before_observer_ready = false;
bool memory_evidence_layout_ready = false;
CheckStack check_stack = nullptr;
GcBarrierBack gc_barrierback = nullptr;
GamePushValue game_pushvalue = nullptr;
void prepare_stack_write(luau_State* state)
{
    if (state == nullptr || gc_barrierback == nullptr) {
        config::log("RENOVICE VM_STACK build=V93 event=barrier-unavailable; stack unchanged");
        throw 2;
    }
    if ((state->marked & native_gc_black_mask_u43) != 0)
        gc_barrierback(state, reinterpret_cast<luau_GCObject*>(state), &state->gclist);
}
void require_stack(luau_State* state, int slots)
{
    if (state == nullptr || check_stack == nullptr || !check_stack(state, slots)) {
        config::log("RENOVICE VM_STACK build=V93 event=reservation-failed; stack unchanged");
        throw 2; // existing DE-Lua exception convention; never write past the frame
    }
}
void push_stack_value(luau_State* state, luau_TValue value)
{
    if (state == nullptr || gc_barrierback == nullptr || check_stack == nullptr
        || !checked_stack_append(*state, value,
            [state](int slots) { return check_stack(state, slots) != 0; },
            [state] { gc_barrierback(state, reinterpret_cast<luau_GCObject*>(state), &state->gclist); })) {
        config::log("RENOVICE VM_STACK build=V93 event=append-rejected; stack unchanged");
        throw 2;
    }
}
GameAllocate game_allocate = nullptr;

std::vector<Chunk> active_chunks;
std::vector<std::uint64_t> configured_target_keys;
std::vector<AddonRecord> active_addons;
std::vector<TargetAddonRecord> active_target_addons;
std::vector<TargetModuleIdentity> target_module_identities;
std::vector<TargetModuleIdentity> pause_menu_identities;
std::vector<TargetScriptBinding> target_script_bindings;
std::vector<PendingTargetAddonRefresh> pending_target_addon_refreshes;
std::atomic_bool target_addon_refresh_pending = false;
// Root returns observed after the stock VM execute call. Guarded by its own
// mutex, never held while Lua runs; applied at the next exact idle return.
std::mutex target_root_return_mutex;
std::vector<std::pair<TargetRootEntry, std::uint32_t>> pending_target_root_returns;
std::atomic_bool target_root_return_pending = false;
std::atomic_bool target_root_watch_enabled = false;
// Native hooks are process-owned. Their Lua providers are immutable,
// generation-owned snapshots. Readers retain the exact snapshot while a host
// callback runs; publication retires old snapshots after the last reader.
std::atomic<std::shared_ptr<const TargetExecutionSnapshot>>
	published_target_execution_snapshot;
GenerationDispatchGate generation_dispatch_gate;
inline constexpr std::size_t diagnostic_proto_bucket_count = 4096;
std::array<std::atomic<DiagnosticProtoIdentity*>, diagnostic_proto_bucket_count>
	diagnostic_proto_buckets{};
std::vector<std::unique_ptr<DiagnosticProtoIdentity>> diagnostic_proto_storage;
struct DiagnosticModuleRoot
{
	std::uint64_t body_key = 0;
	void* global_state = nullptr;
	void* root_proto = nullptr;
	std::string registry_key;
};
std::vector<DiagnosticModuleRoot> diagnostic_module_roots;
std::atomic_bool diagnostic_root_cleanup_pending = false;
std::recursive_mutex generation_mutex;
std::uint64_t next_target_addon_identity = 1;
std::mutex capture_mutex;
void* captured_manager = nullptr;
std::uint32_t captured_name_handle[2]{};
void* captured_environment = nullptr;
std::atomic_bool context_ready = false;
std::atomic<void*> captured_global_state = nullptr;
std::atomic<std::uint32_t> captured_owner_thread = 0;
std::atomic<SafeRuntimeTick> safe_runtime_tick = nullptr;
std::atomic<SafeRuntimeControlPoll> safe_runtime_control_poll = nullptr;
std::atomic_bool first_safe_runtime_tick_logged = false;
std::atomic_bool subsystem_enabled = false;
std::atomic_bool startup_pending = false;
std::atomic_bool f9_pending = false;
std::atomic_bool execution_running = false;
std::atomic_bool observe_target_addons = false;
// The DE interrupt leaf is process-wide, while luaCalls.before is optional.
// Keep the leaf's common path stock-only until an exact, published provider
// and target-module identity can possibly accept a call.
std::atomic_bool lua_before_provider_fast_gate = false;
std::atomic_bool scripts_ui_enabled = false;
// Preserved for negative-evidence archaeology only. Live testing disproved the
// cached module-export attachment model; keep its code available but prevent it
// from participating in the new observation pass.
std::atomic_bool retracted_cached_card_export_decorator_enabled = false;
std::atomic<void*> published_pause_global_state = nullptr;
std::atomic<void*> published_pause_root_proto = nullptr;
bool f9_was_down = false;
std::uint64_t next_generation = 1;
std::uint64_t active_generation = 0;
GuardState guard;
std::recursive_mutex lua_execution_mutex;
thread_local std::size_t lua_execution_depth = 0;
thread_local bool float_argument_transform_running = false;
thread_local bool native_call_hook_running = false;
thread_local bool automatic_damage_runtime_running = false;
thread_local AutomaticDamageTraceContext automatic_damage_trace_context;
thread_local bool lua_call_hook_running = false;
thread_local bool safe_runtime_tick_running = false;
thread_local bool safe_runtime_control_poll_running = false;
thread_local std::uint64_t previous_safe_runtime_control_poll_ms = 0;
thread_local std::uint64_t last_deferred_reload_sequence_logged = 0;
thread_local SafeRuntimeTickBoundaryBlocker last_deferred_reload_blocker =
	SafeRuntimeTickBoundaryBlocker::Ready;
thread_local std::uint64_t last_deferred_lua_boundary_sequence_logged = 0;
thread_local LuaMutationBoundaryBlocker last_deferred_lua_boundary_blocker =
	LuaMutationBoundaryBlocker::Ready;
thread_local std::uint64_t last_drain_deferred_reload_sequence_logged = 0;
thread_local const char* last_drain_deferred_reason = nullptr;
thread_local std::uintptr_t failed_scripts_bridge_shared_table = 0;
thread_local std::uint64_t failed_scripts_bridge_attempt_ms = 0;

inline constexpr std::uint64_t safe_runtime_tick_interval_ms = 8;
inline constexpr std::uint64_t scripts_bridge_retry_interval_ms = 2000;

std::atomic<std::uint64_t> reload_request_sequence = 0;
std::atomic<std::uint64_t> automatic_damage_sequence = 0;
std::atomic_bool automatic_damage_budget_suppression_logged = false;
std::atomic_bool automatic_damage_duplicate_suppression_logged = false;
std::atomic_bool automatic_damage_runtime_failure_logged = false;

std::uint32_t ability_card_export_hash = 0;
std::uint32_t set_damage_callback_hash = 0;
std::uint32_t set_source_object_hash = 0;
std::uint32_t push_float_arg_hash = 0;
std::uint32_t run_script_hash = 0;
luau_CFunction original_set_damage_callback = nullptr;
luau_CFunction original_set_source_object = nullptr;
luau_CFunction original_push_float_arg = nullptr;
luau_CFunction original_run_script = nullptr;
soup::DetourHook set_damage_callback_native_hook;
soup::DetourHook set_source_object_native_hook;
ReloadableCompactDetourHook push_float_arg_native_hook;
std::vector<std::unique_ptr<NativeCallHookRecord>> native_call_hooks;
std::vector<std::string> native_call_hook_names;
std::recursive_mutex native_call_hook_mutex;
bool native_hook_adapters_enabled = false;
unsigned int native_hook_adapter_mask = 0;
soup::DetourHook run_script_native_hook;
bool run_script_native_hook_enabled = false;
std::unordered_set<std::string> logged_native_hook_events;
std::atomic<std::uint64_t> run_script_observation_sequence = 0;
std::atomic<std::uint64_t> run_script_entry_sequence = 0;
std::atomic<std::uint64_t> run_script_candidate_sequence = 0;

// The game's own crash logger reports null GPFs without preserving the native
// caller.  Keep a deliberately small, non-swallowing first-chance trace so a
// live crash can be tied to an exact Warframe.x64.exe call site.  The handler
// does not allocate, format through the CRT, or change exception dispatch.
PVOID process_fault_diagnostics_handler = nullptr;
HANDLE process_fault_diagnostics_log = INVALID_HANDLE_VALUE;
volatile LONG process_fault_diagnostics_count = 0;
volatile LONG process_fault_dump_in_progress = 0;
std::atomic_bool process_fault_diagnostics_accepting = false;
std::atomic<std::uint32_t> process_fault_diagnostics_in_flight = 0;
std::uintptr_t process_fault_exe_base = 0;
std::size_t process_fault_exe_size = 0;
std::uintptr_t process_fault_proxy_base = 0;
std::size_t process_fault_proxy_size = 0;
wchar_t process_fault_dump_path[MAX_PATH]{};
HMODULE process_fault_dbghelp = nullptr;
using MiniDumpWriteDumpFunction = BOOL(WINAPI*)(
	HANDLE, DWORD, HANDLE, MINIDUMP_TYPE,
	const MINIDUMP_EXCEPTION_INFORMATION*,
	const MINIDUMP_USER_STREAM_INFORMATION*,
	const MINIDUMP_CALLBACK_INFORMATION*);
MiniDumpWriteDumpFunction process_fault_write_dump = nullptr;
std::mutex process_fault_diagnostics_mutex;

struct FixedFaultLog
{
	char bytes[16384]{};
	std::size_t length = 0;

	void append(char value) noexcept
	{
		if (length < sizeof(bytes)) bytes[length++] = value;
	}

	void append(const char* value) noexcept
	{
		if (value == nullptr) return;
		while (*value != '\0' && length < sizeof(bytes)) bytes[length++] = *value++;
	}

	void append_decimal(std::uint64_t value) noexcept
	{
		char reversed[24]{};
		std::size_t count = 0;
		do
		{
			reversed[count++] = static_cast<char>('0' + (value % 10));
			value /= 10;
		} while (value != 0 && count < sizeof(reversed));
		while (count != 0) append(reversed[--count]);
	}

	void append_hex(std::uint64_t value) noexcept
	{
		static constexpr char digits[] = "0123456789ABCDEF";
		append("0x");
		bool emitted = false;
		for (int shift = 60; shift >= 0; shift -= 4)
		{
			const auto digit = static_cast<unsigned int>((value >> shift) & 0x0f);
			if (digit != 0 || emitted || shift == 0)
			{
				append(digits[digit]);
				emitted = true;
			}
		}
	}
};

bool module_image_bounds(
	HMODULE module,
	std::uintptr_t& base,
	std::size_t& size) noexcept
{
	if (module == nullptr) return false;
	MEMORY_BASIC_INFORMATION region{};
	const auto address = reinterpret_cast<std::uintptr_t>(module);
	if (VirtualQuery(reinterpret_cast<void*>(address), &region, sizeof(region)) == 0
		|| region.AllocationBase == nullptr)
	{
		return false;
	}
	base = reinterpret_cast<std::uintptr_t>(region.AllocationBase);
	size = 0;
	for (auto cursor = base;;)
	{
		MEMORY_BASIC_INFORMATION current{};
		if (VirtualQuery(reinterpret_cast<void*>(cursor), &current, sizeof(current)) == 0
			|| current.AllocationBase != region.AllocationBase
			|| current.RegionSize == 0)
		{
			break;
		}
		const auto next = cursor + current.RegionSize;
		if (next <= cursor) break;
		size = static_cast<std::size_t>(next - base);
		cursor = next;
	}
	return size != 0;
}

void append_fault_address(FixedFaultLog& output, std::uintptr_t address) noexcept
{
	output.append_hex(address);
	if (address >= process_fault_exe_base
		&& address - process_fault_exe_base < process_fault_exe_size)
	{
		output.append(" (Warframe.x64.exe+");
		output.append_hex(address - process_fault_exe_base);
		output.append(')');
	}
	else if (address >= process_fault_proxy_base
		&& address - process_fault_proxy_base < process_fault_proxy_size)
	{
		output.append(" (wtsapi32.dll+");
		output.append_hex(address - process_fault_proxy_base);
		output.append(')');
	}
}

template <typename T>
bool read_fault_value(std::uintptr_t address, T& value) noexcept
{
	SIZE_T bytes_read = 0;
	return address >= 0x10000
		&& ReadProcessMemory(
			GetCurrentProcess(), reinterpret_cast<const void*>(address), &value,
			sizeof(value), &bytes_read)
		&& bytes_read == sizeof(value);
}

void append_remote_debug_name(
	FixedFaultLog& output,
	std::uintptr_t address) noexcept
{
	if (address < 0x10000)
	{
		output.append("<none>");
		return;
	}
	char name[128]{};
	SIZE_T bytes_read = 0;
	if (!ReadProcessMemory(
		GetCurrentProcess(), reinterpret_cast<const void*>(address), name,
		sizeof(name) - 1, &bytes_read) || bytes_read == 0)
	{
		output.append("<unreadable>");
		return;
	}
	name[sizeof(name) - 1] = '\0';
	for (std::size_t index = 0; index < bytes_read && name[index] != '\0'; ++index)
	{
		const unsigned char character = static_cast<unsigned char>(name[index]);
		output.append(character >= 0x20 && character <= 0x7e
			? static_cast<char>(character) : '?');
	}
}

void append_luau_frame(
	FixedFaultLog& output,
	std::size_t frame_index,
	std::uintptr_t call_info) noexcept
{
	luau_CallInfo frame_info{};
	if (!read_fault_value(call_info, frame_info))
	{
		output.append("\r\nluau_frame[");
		output.append_decimal(frame_index);
		output.append("] ci="); output.append_hex(call_info);
		output.append(" <unreadable>");
		return;
	}
	const auto function_slot = reinterpret_cast<std::uintptr_t>(frame_info.func);
	luau_TValue function{};
	if (!read_fault_value(function_slot, function))
	{
		output.append("\r\nluau_frame[");
		output.append_decimal(frame_index);
		output.append("] ci="); output.append_hex(call_info);
		output.append(" func_slot="); output.append_hex(function_slot);
		output.append(" <unreadable TValue>");
		return;
	}
	output.append("\r\nluau_frame[");
	output.append_decimal(frame_index);
	output.append("] ci="); output.append_hex(call_info);
	output.append(" func_slot="); output.append_hex(function_slot);
	output.append(" base="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(frame_info.base));
	output.append(" top="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(frame_info.top));
	output.append(" savedpc="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(frame_info.savedpc));
	output.append(" nresults="); output.append_decimal(
		static_cast<std::uint32_t>(frame_info.nresults));
	output.append(" flags="); output.append_decimal(frame_info.flags);
	output.append(" tag="); output.append_decimal(function.type);
	output.append(" closure="); output.append_hex(function.value.as_uintptr);
	if ((function.type != LUAU_FUNCTION
		&& function.type != deployed_function_tag)
		|| function.value.as_uintptr < 0x10000)
	{
		return;
	}
	luau_Closure closure{};
	if (!read_fault_value(function.value.as_uintptr, closure))
	{
		output.append(" <unreadable closure>");
		return;
	}
	output.append(" isC="); output.append_decimal(closure.isC);
	output.append(" nup="); output.append_decimal(closure.nupvalues);
	output.append(" stacksize="); output.append_decimal(closure.stacksize);
	output.append(" env="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(closure.env));
	if (closure.isC)
	{
		output.append(" c.func=");
		append_fault_address(
			output, reinterpret_cast<std::uintptr_t>(closure.c.func));
		output.append(" c.cont=");
		append_fault_address(
			output, reinterpret_cast<std::uintptr_t>(closure.c.cont));
		output.append(" debugname=");
		append_remote_debug_name(
			output, reinterpret_cast<std::uintptr_t>(closure.c.debugname));
	}
	else
	{
		output.append(" proto=");
		output.append_hex(reinterpret_cast<std::uintptr_t>(closure.l.p));
		const auto savedpc = reinterpret_cast<std::uintptr_t>(frame_info.savedpc);
		if (savedpc >= 0x10020)
		{
			output.append(" code[-8..+3]=");
			const auto first_word = savedpc - sizeof(std::uint32_t) * 8;
			for (std::size_t index = 0; index < 12; ++index)
			{
				std::uint32_t word = 0;
				if (index != 0) output.append(',');
				if (read_fault_value(
					first_word + index * sizeof(std::uint32_t), word))
				{
					output.append_hex(word);
				}
				else
				{
					output.append("<unreadable>");
				}
			}
		}
	}
}

void append_luau_state(
	FixedFaultLog& output,
	std::uintptr_t state_address) noexcept
{
	luau_State state{};
	if (!read_fault_value(state_address, state))
	{
		output.append("\r\nluau_state="); output.append_hex(state_address);
		output.append(" <unreadable>");
		return;
	}
	const auto current_call = reinterpret_cast<std::uintptr_t>(state.ci);
	const auto base_call = reinterpret_cast<std::uintptr_t>(state.base_ci);
	output.append("\r\nluau_state="); output.append_hex(state_address);
	output.append(" outtop="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(state.outtop));
	output.append(" intop="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(state.intop));
	output.append(" ci="); output.append_hex(current_call);
	output.append(" base_ci="); output.append_hex(base_call);
	output.append(" stack="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(state.stack));
	output.append(" stack_last="); output.append_hex(
		reinterpret_cast<std::uintptr_t>(state.stack_last));

	if (current_call < 0x10000 || base_call < 0x10000
		|| current_call < base_call
		|| current_call - base_call > sizeof(luau_CallInfo) * 4096)
	{
		output.append("\r\nluau_call_chain=<invalid bounds>");
		return;
	}
	auto call_info = current_call;
	for (std::size_t frame = 0; frame < 32 && call_info >= base_call; ++frame)
	{
		append_luau_frame(output, frame, call_info);
		if (call_info == base_call || call_info < sizeof(luau_CallInfo)) break;
		call_info -= sizeof(luau_CallInfo);
	}
}

bool write_process_fault_dump(EXCEPTION_POINTERS* information) noexcept
{
	if (process_fault_write_dump == nullptr || process_fault_dump_path[0] == L'\0'
		|| InterlockedCompareExchange(&process_fault_dump_in_progress, 1, 0) != 0)
	{
		return false;
	}
	HANDLE dump = CreateFileW(
		process_fault_dump_path, GENERIC_WRITE, FILE_SHARE_READ,
		nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
	if (dump == INVALID_HANDLE_VALUE)
	{
		InterlockedExchange(&process_fault_dump_in_progress, 0);
		return false;
	}
	MINIDUMP_EXCEPTION_INFORMATION exception{};
	exception.ThreadId = GetCurrentThreadId();
	exception.ExceptionPointers = information;
	exception.ClientPointers = FALSE;
	const auto type = static_cast<MINIDUMP_TYPE>(
		MiniDumpNormal
		| MiniDumpWithDataSegs
		| MiniDumpWithHandleData
		| MiniDumpWithUnloadedModules
		| MiniDumpWithIndirectlyReferencedMemory
		| MiniDumpWithThreadInfo
		| MiniDumpWithFullMemoryInfo);
	const BOOL result = process_fault_write_dump(
		GetCurrentProcess(), GetCurrentProcessId(), dump, type,
		&exception, nullptr, nullptr);
	FlushFileBuffers(dump);
	CloseHandle(dump);
	InterlockedExchange(&process_fault_dump_in_progress, 0);
	return result != FALSE;
}

LONG CALLBACK process_fault_diagnostics(EXCEPTION_POINTERS* information)
{
	if (diagnostics::intentional_read_probe_active()) return EXCEPTION_CONTINUE_SEARCH;
	if (!config::diagnostics_enabled()
		|| !process_fault_diagnostics_accepting.load(std::memory_order_acquire))
	{
		return EXCEPTION_CONTINUE_SEARCH;
	}
	process_fault_diagnostics_in_flight.fetch_add(1, std::memory_order_acq_rel);
	struct Invocation
	{
		~Invocation() noexcept
		{
			process_fault_diagnostics_in_flight.fetch_sub(
				1, std::memory_order_acq_rel);
		}
	} invocation;
	if (!config::diagnostics_enabled()
		|| !process_fault_diagnostics_accepting.load(std::memory_order_acquire))
	{
		return EXCEPTION_CONTINUE_SEARCH;
	}
	if (information == nullptr || information->ExceptionRecord == nullptr
		|| information->ContextRecord == nullptr
		|| process_fault_diagnostics_log == INVALID_HANDLE_VALUE)
	{
		return EXCEPTION_CONTINUE_SEARCH;
	}
	const auto* record = information->ExceptionRecord;
	if (record->ExceptionCode != EXCEPTION_ACCESS_VIOLATION
		&& record->ExceptionCode != EXCEPTION_IN_PAGE_ERROR)
	{
		return EXCEPTION_CONTINUE_SEARCH;
	}
	const auto fault_instruction = reinterpret_cast<std::uintptr_t>(
		record->ExceptionAddress);
	const auto accessed_address = record->NumberParameters >= 2
		? static_cast<std::uintptr_t>(record->ExceptionInformation[1]) : 0;
	// Restrict the trace to the null/near-null faults reported by EE.log.  This
	// avoids recording ordinary first-chance exceptions used by the engine.
	if (fault_instruction >= 0x10000 && accessed_address >= 0x10000)
	{
		return EXCEPTION_CONTINUE_SEARCH;
	}
	if (guard.active && guard.thread_id == GetCurrentThreadId())
	{
		return EXCEPTION_CONTINUE_SEARCH;
	}
	const LONG sequence = InterlockedIncrement(&process_fault_diagnostics_count);
	if (sequence > 64) return EXCEPTION_CONTINUE_SEARCH;

	FixedFaultLog output;
	output.append("\r\nRENOVICE_NATIVE_FAULT sequence=");
	output.append_decimal(static_cast<std::uint64_t>(sequence));
	output.append(" thread=");
	output.append_decimal(GetCurrentThreadId());
	output.append(" code=");
	output.append_hex(record->ExceptionCode);
	output.append(" operation=");
	output.append_decimal(record->NumberParameters >= 1
		? static_cast<std::uint64_t>(record->ExceptionInformation[0]) : 0);
	output.append(" accessed=");
	output.append_hex(accessed_address);
	output.append("\r\ninstruction=");
	append_fault_address(output, fault_instruction);

#if defined(_M_X64)
	const auto* context = information->ContextRecord;
	output.append("\r\nRIP=");
	append_fault_address(output, static_cast<std::uintptr_t>(context->Rip));
	output.append(" RSP="); output.append_hex(context->Rsp);
	output.append(" RBP="); output.append_hex(context->Rbp);
	output.append(" RAX="); output.append_hex(context->Rax);
	output.append(" RBX="); output.append_hex(context->Rbx);
	output.append(" RCX="); output.append_hex(context->Rcx);
	output.append(" RDX="); output.append_hex(context->Rdx);
	output.append(" RSI="); output.append_hex(context->Rsi);
	output.append(" RDI="); output.append_hex(context->Rdi);
	output.append(" R8="); output.append_hex(context->R8);
	output.append(" R9="); output.append_hex(context->R9);
	output.append(" R10="); output.append_hex(context->R10);
	output.append(" R11="); output.append_hex(context->R11);
	// The current U43 null-resume signature has the Luau state in both RBX and
	// RCX.  Record either plausible state only once, including the exact C
	// closure function/continuation/debug name for every active CallInfo.
	if (context->Rbx >= 0x10000)
	{
		append_luau_state(output, static_cast<std::uintptr_t>(context->Rbx));
	}
	if (context->Rcx >= 0x10000 && context->Rcx != context->Rbx)
	{
		append_luau_state(output, static_cast<std::uintptr_t>(context->Rcx));
	}

	std::uintptr_t stack_words[48]{};
	SIZE_T bytes_read = 0;
	if (ReadProcessMemory(
		GetCurrentProcess(), reinterpret_cast<void*>(context->Rsp), stack_words,
		sizeof(stack_words), &bytes_read))
	{
		const auto word_count = bytes_read / sizeof(stack_words[0]);
		for (std::size_t index = 0; index < word_count; ++index)
		{
			output.append("\r\nstack[");
			output.append_decimal(index);
			output.append("]=");
			append_fault_address(output, stack_words[index]);
		}
	}
#endif
	output.append("\r\nRENOVICE_NATIVE_FAULT_END\r\n");
	DWORD written = 0;
	WriteFile(
		process_fault_diagnostics_log, output.bytes,
		static_cast<DWORD>(output.length), &written, nullptr);
	FlushFileBuffers(process_fault_diagnostics_log);
	const bool dump_written = write_process_fault_dump(information);
	static constexpr char dump_pass[] = "RENOVICE_MINIDUMP=PASS\r\n";
	static constexpr char dump_fail[] = "RENOVICE_MINIDUMP=FAIL\r\n";
	const char* dump_status = dump_written ? dump_pass : dump_fail;
	const DWORD dump_status_size = dump_written
		? static_cast<DWORD>(sizeof(dump_pass) - 1)
		: static_cast<DWORD>(sizeof(dump_fail) - 1);
	WriteFile(
		process_fault_diagnostics_log, dump_status, dump_status_size,
		&written, nullptr);
	FlushFileBuffers(process_fault_diagnostics_log);
	return EXCEPTION_CONTINUE_SEARCH;
}

void release_process_fault_diagnostic_resources() noexcept
{
	if (process_fault_diagnostics_log != INVALID_HANDLE_VALUE)
	{
		CloseHandle(process_fault_diagnostics_log);
		process_fault_diagnostics_log = INVALID_HANDLE_VALUE;
	}
	process_fault_write_dump = nullptr;
	if (process_fault_dbghelp != nullptr)
	{
		FreeLibrary(process_fault_dbghelp);
		process_fault_dbghelp = nullptr;
	}
	process_fault_dump_path[0] = L'\0';
	InterlockedExchange(&process_fault_diagnostics_count, 0);
	InterlockedExchange(&process_fault_dump_in_progress, 0);
}

bool install_process_fault_diagnostics()
{
	if (!config::diagnostics_enabled()) return true;
	if (process_fault_diagnostics_handler != nullptr)
	{
		process_fault_diagnostics_accepting.store(true, std::memory_order_release);
		return true;
	}
	// A previous removal may have timed out while its last callback drained.
	// Reuse no handle or dbghelp pointer from that retired observer.
	if (process_fault_diagnostics_log != INVALID_HANDLE_VALUE
		|| process_fault_dbghelp != nullptr)
	{
		if (process_fault_diagnostics_in_flight.load(
				std::memory_order_acquire) != 0)
		{
			return false;
		}
		release_process_fault_diagnostic_resources();
	}
	module_image_bounds(
		GetModuleHandleW(nullptr), process_fault_exe_base, process_fault_exe_size);
	module_image_bounds(
		GetModuleHandleW(L"wtsapi32.dll"),
		process_fault_proxy_base, process_fault_proxy_size);

	wchar_t executable_path[MAX_PATH]{};
	const DWORD path_length = GetModuleFileNameW(
		nullptr, executable_path, static_cast<DWORD>(std::size(executable_path)));
	if (path_length == 0 || path_length >= std::size(executable_path)) return false;
	wchar_t* separator = executable_path + path_length;
	while (separator != executable_path && separator[-1] != L'\\') --separator;
	if (separator == executable_path) return false;
	static constexpr wchar_t suffix[] =
		L"OpenWF\\CustomScripts\\Logs\\renovice_fault.log";
	static constexpr wchar_t dump_suffix[] =
		L"OpenWF\\CustomScripts\\Diagnostics\\renovice_fault.dmp";
	if (static_cast<std::size_t>(separator - executable_path)
		+ std::size(suffix) > std::size(executable_path))
	{
		return false;
	}
	const auto directory_length = static_cast<std::size_t>(
		separator - executable_path);
	if (directory_length + std::size(dump_suffix)
		> std::size(process_fault_dump_path))
	{
		return false;
	}
	std::memcpy(
		process_fault_dump_path, executable_path,
		directory_length * sizeof(wchar_t));
	std::memcpy(
		process_fault_dump_path + directory_length,
		dump_suffix, sizeof(dump_suffix));
	std::memcpy(separator, suffix, sizeof(suffix));
	process_fault_diagnostics_log = CreateFileW(
		executable_path, GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE,
		nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
	if (process_fault_diagnostics_log == INVALID_HANDLE_VALUE) return false;
	process_fault_dbghelp = LoadLibraryW(L"dbghelp.dll");
	if (process_fault_dbghelp != nullptr)
	{
		process_fault_write_dump = reinterpret_cast<MiniDumpWriteDumpFunction>(
			GetProcAddress(process_fault_dbghelp, "MiniDumpWriteDump"));
	}

	if (config::diagnostics_enabled())
	{
		static constexpr char startup[] =
			"RENOVICE native null-fault diagnostics armed; exceptions are logged but not intercepted.\r\n";
		DWORD written = 0;
		WriteFile(
			process_fault_diagnostics_log, startup,
			static_cast<DWORD>(sizeof(startup) - 1), &written, nullptr);
	}
	process_fault_diagnostics_accepting.store(true, std::memory_order_release);
	process_fault_diagnostics_handler = AddVectoredExceptionHandler(
		0, process_fault_diagnostics);
	if (process_fault_diagnostics_handler == nullptr)
	{
		process_fault_diagnostics_accepting.store(false, std::memory_order_release);
		CloseHandle(process_fault_diagnostics_log);
		process_fault_diagnostics_log = INVALID_HANDLE_VALUE;
		if (process_fault_dbghelp != nullptr) FreeLibrary(process_fault_dbghelp);
		process_fault_dbghelp = nullptr;
		process_fault_write_dump = nullptr;
		return false;
	}
	return true;
}

bool uninstall_process_fault_diagnostics() noexcept
{
	process_fault_diagnostics_accepting.store(false, std::memory_order_release);
	bool removed = true;
	if (process_fault_diagnostics_handler != nullptr)
	{
		removed = RemoveVectoredExceptionHandler(
			process_fault_diagnostics_handler) != 0;
		if (removed) process_fault_diagnostics_handler = nullptr;
	}
	if (!removed) return false;
	const auto deadline = GetTickCount64() + 5000;
	while (process_fault_diagnostics_in_flight.load(std::memory_order_acquire) != 0
		&& GetTickCount64() < deadline)
	{
		Sleep(1);
	}
	if (process_fault_diagnostics_in_flight.load(std::memory_order_acquire) != 0)
	{
		return false;
	}
	release_process_fault_diagnostic_resources();
	return true;
}

bool reconcile_process_fault_diagnostics()
{
	std::lock_guard lock(process_fault_diagnostics_mutex);
	return config::diagnostics_enabled()
		? install_process_fault_diagnostics()
		: uninstall_process_fault_diagnostics();
}
std::atomic<std::uint64_t> diagnostic_trace_sequence = 0;
std::atomic_bool diagnostic_trace_suppression_logged = false;
std::atomic_bool diagnostic_trace_install_failure_logged = false;
std::atomic_bool diagnostic_trace_callback_failure_logged = false;
bool diagnostic_snapshot_capacity_available(const config::Flags& flags) noexcept
{
    const auto used = diagnostic_trace_sequence.load(std::memory_order_relaxed);
    if (diagnostic_snapshot_work_allowed(flags.diagnostics_mode, used, flags.diagnostics_max_events)) return true;
    if (diagnostic_bridge_may_format(flags.diagnostics_mode) && used >= flags.diagnostics_max_events
        && !diagnostic_trace_suppression_logged.exchange(true)) {
        config::diagnostic_log("RENOVICE VM_MEMORY build=V94 event=observer-work-suppressed reason=output-budget-exhausted; gameplay callbacks and stock calls retained",
            config::DiagnosticsMode::battle);
    }
    return false;
}
std::atomic_bool pause_menu_body_dumped = false;
bool run_script_binding_failure_logged = false;
thread_local ActiveRunScriptBoundary active_run_script_boundary;
thread_local std::uint64_t next_run_script_boundary_token = 1;
thread_local ActivePauseLoadBoundary active_pause_load_boundary;

void clear_active_run_script_boundary() noexcept
{
	active_run_script_boundary = {};
}

bool run_script_boundary_is_live(
	const ActiveRunScriptBoundary& boundary,
	const luau_State* state
) noexcept

{
	constexpr std::size_t maximum_total_frames = 4096;
	if (!boundary.active || boundary.token == 0 || boundary.generation == 0
		|| state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| boundary.state != state
		|| boundary.global_state == nullptr
		|| boundary.global_state != state->global_state
		|| boundary.owner_thread == 0
		|| boundary.owner_thread != static_cast<std::uint32_t>(GetCurrentThreadId())
		|| boundary.owner_call_info == nullptr
		|| state->base_ci == nullptr || state->ci == nullptr || state->end_ci == nullptr)
	{
		return false;
	}

	const auto base = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto current = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	const auto owner = reinterpret_cast<std::uintptr_t>(boundary.owner_call_info);
	if (!valid_target_call_stack_bounds(
			current, base, sizeof(luau_CallInfo), maximum_total_frames)
		|| end < base || current >= end
		|| sizeof(luau_CallInfo) > end - current
		|| owner < base || owner > current
		|| (owner - base) % sizeof(luau_CallInfo) != 0
		|| sizeof(luau_CallInfo) > end - owner
		|| diagnostics::bad_read_ptr(
			boundary.owner_call_info, sizeof(luau_CallInfo))
		|| boundary.owner_call_info->func == nullptr
		|| diagnostics::bad_read_ptr(
			boundary.owner_call_info->func, sizeof(luau_TValue)))
	{
		return false;
	}

	const auto& function = *boundary.owner_call_info->func;
	return function.type == boundary.owner_function_tag
		&& function.value.as_uintptr == boundary.owner_function_identity;
}

// A new detour entry at the exact saved CallInfo cannot be a still-active
// nested invocation. It is the same frame slot reused after a stock longjmp;
// retire it before classifying this entry. Genuine recursion has a deeper
// CallInfo and remains reentrant.
bool prepare_run_script_boundary_entry(luau_State* state) noexcept
{
	if (!active_run_script_boundary.active) return false;
	const bool live = run_script_boundary_is_live(
		active_run_script_boundary, state);
	if (!live || active_run_script_boundary.owner_call_info == state->ci)
	{
		clear_active_run_script_boundary();
		return false;
	}
	return true;
}

ActiveRunScriptBoundary make_run_script_boundary(
	luau_State* state,
	std::uintptr_t script_resource_identity,
	std::uintptr_t ability_identity,
	std::uint64_t generation
) noexcept
{
	ActiveRunScriptBoundary boundary;
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr
		|| state->ci == nullptr || state->base_ci == nullptr
		|| state->end_ci == nullptr
		|| diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		|| state->ci->func == nullptr
		|| diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue))
		|| script_resource_identity == 0 || generation == 0)
	{
		return boundary;
	}

	const auto base = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto current = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	if (!valid_target_call_stack_bounds(
			current, base, sizeof(luau_CallInfo), 4096)
		|| end < base || current >= end
		|| sizeof(luau_CallInfo) > end - current)
	{
		return boundary;
	}

	auto token = next_run_script_boundary_token++;
	if (token == 0) token = next_run_script_boundary_token++;
	boundary.active = true;
	boundary.state = state;
	boundary.global_state = state->global_state;
	boundary.owner_call_info = state->ci;
	boundary.owner_function_tag = state->ci->func->type;
	boundary.owner_function_identity = state->ci->func->value.as_uintptr;
	boundary.script_resource_identity = script_resource_identity;
	boundary.ability_identity = ability_identity;
	boundary.owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	boundary.generation = generation;
	boundary.token = token;
	return boundary;
}

void finish_run_script_boundary(
	std::uint64_t token,
	const ActiveRunScriptBoundary& previous,
	luau_State* state
) noexcept
{
	if (active_run_script_boundary.token == token
		|| !run_script_boundary_is_live(active_run_script_boundary, state))
	{
		clear_active_run_script_boundary();
	}
	if (run_script_boundary_is_live(previous, state))
	{
		active_run_script_boundary = previous;
	}
}

void clear_run_script_boundary_at_exact_idle(luau_State* state) noexcept
{
	if (state != nullptr && active_run_script_boundary.active
		&& active_run_script_boundary.state == state
		&& active_run_script_boundary.owner_thread
			== static_cast<std::uint32_t>(GetCurrentThreadId()))
	{
		clear_active_run_script_boundary();
	}
}

enum class StockNativeFinalizeKind : std::uint8_t
{
	none,
	set_source_object,
	set_damage_callback,
};

struct ActiveStockNativeFinalize
{
	bool active = false;
	StockNativeFinalizeKind kind = StockNativeFinalizeKind::none;
	luau_State* state = nullptr;
	void* global_state = nullptr;
	luau_CallInfo* owner_call_info = nullptr;
	std::uint32_t owner_function_tag = LUAU_NIL;
	std::uintptr_t owner_function_identity = 0;
	std::ptrdiff_t argument_base_offset = -1;
	std::uint32_t argument_tags[2]{};
	std::uintptr_t argument_values[2]{};
	std::uint64_t target_key = 0;
	std::uint64_t trace_attempt = 0;
	std::uint64_t generation = 0;
	std::uint64_t token = 0;
	std::uint32_t owner_thread = 0;
	bool detailed_trace = false;
};

static_assert(std::is_trivially_copyable_v<ActiveStockNativeFinalize>);

thread_local ActiveStockNativeFinalize active_stock_native_finalize;
thread_local std::uint64_t next_stock_native_finalize_token = 1;

void clear_active_stock_native_finalize() noexcept
{
	active_stock_native_finalize = {};
}

bool stock_native_finalize_is_live(
	const ActiveStockNativeFinalize& boundary,
	const luau_State* state
) noexcept
{
	constexpr std::size_t maximum_total_frames = 4096;
	if (!boundary.active || boundary.kind == StockNativeFinalizeKind::none
		|| boundary.token == 0 || boundary.generation == 0
		|| state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| boundary.state != state || boundary.global_state == nullptr
		|| boundary.global_state != state->global_state
		|| boundary.owner_thread == 0
		|| boundary.owner_thread != static_cast<std::uint32_t>(GetCurrentThreadId())
		|| boundary.owner_call_info == nullptr
		|| state->base_ci == nullptr || state->ci == nullptr || state->end_ci == nullptr)
	{
		return false;
	}

	const auto base = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto current = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	const auto owner = reinterpret_cast<std::uintptr_t>(boundary.owner_call_info);
	if (!valid_target_call_stack_bounds(
			current, base, sizeof(luau_CallInfo), maximum_total_frames)
		|| end < base || current >= end
		|| sizeof(luau_CallInfo) > end - current
		|| owner < base || owner > current
		|| (owner - base) % sizeof(luau_CallInfo) != 0
		|| sizeof(luau_CallInfo) > end - owner
		|| diagnostics::bad_read_ptr(
			boundary.owner_call_info, sizeof(luau_CallInfo))
		|| boundary.owner_call_info->func == nullptr
		|| diagnostics::bad_read_ptr(
			boundary.owner_call_info->func, sizeof(luau_TValue)))
	{
		return false;
	}

	const auto& function = *boundary.owner_call_info->func;
	return function.type == boundary.owner_function_tag
		&& function.value.as_uintptr == boundary.owner_function_identity;
}

void prepare_stock_native_finalize_entry(luau_State* state) noexcept
{
	if (!active_stock_native_finalize.active) return;
	const bool live = stock_native_finalize_is_live(
		active_stock_native_finalize, state);
	if (!live || active_stock_native_finalize.owner_call_info == state->ci)
	{
		clear_active_stock_native_finalize();
	}
}

ActiveStockNativeFinalize make_stock_native_finalize(
	StockNativeFinalizeKind kind,
	luau_State* state,
	std::uint64_t generation,
	std::uint64_t target_key,
	std::uint64_t trace_attempt,
	bool detailed_trace
) noexcept
{
	ActiveStockNativeFinalize boundary;
	if (kind == StockNativeFinalizeKind::none || state == nullptr
		|| diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr || state->intop == nullptr
		|| state->stack == nullptr || state->stack_last == nullptr
		|| state->ci == nullptr || state->base_ci == nullptr
		|| state->end_ci == nullptr
		|| diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		|| state->ci->func == nullptr
		|| diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue))
		|| luau_gettop(state) < 2 || generation == 0)
	{
		return boundary;
	}

	const auto base = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto current = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	if (!valid_target_call_stack_bounds(
			current, base, sizeof(luau_CallInfo), 4096)
		|| end < base || current >= end
		|| sizeof(luau_CallInfo) > end - current)
	{
		return boundary;
	}

	auto token = next_stock_native_finalize_token++;
	if (token == 0) token = next_stock_native_finalize_token++;
	boundary.active = true;
	boundary.kind = kind;
	boundary.state = state;
	boundary.global_state = state->global_state;
	boundary.owner_call_info = state->ci;
	boundary.owner_function_tag = state->ci->func->type;
	boundary.owner_function_identity = state->ci->func->value.as_uintptr;
	boundary.argument_base_offset = luau_savestack(state, state->intop);
	for (std::size_t index = 0; index != 2; ++index)
	{
		boundary.argument_tags[index] = state->intop[index].type;
		boundary.argument_values[index] = state->intop[index].value.as_uintptr;
	}
	boundary.target_key = target_key;
	boundary.trace_attempt = trace_attempt;
	boundary.generation = generation;
	boundary.token = token;
	boundary.owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	boundary.detailed_trace = detailed_trace;
	return boundary;
}

void finish_stock_native_finalize(
	std::uint64_t token,
	const ActiveStockNativeFinalize& previous,
	luau_State* state
) noexcept
{
	if (active_stock_native_finalize.token == token
		|| !stock_native_finalize_is_live(active_stock_native_finalize, state))
	{
		clear_active_stock_native_finalize();
	}
	if (stock_native_finalize_is_live(previous, state))
	{
		active_stock_native_finalize = previous;
	}
}

bool stock_native_finalize_arguments(
	const ActiveStockNativeFinalize& boundary,
	luau_State* state,
	luau_TValue (&arguments)[2]
) noexcept
{
	if (!stock_native_finalize_is_live(boundary, state)
		|| boundary.argument_base_offset < 0 || state->stack == nullptr
		|| state->stack_last == nullptr
		|| state->intop == nullptr
		|| luau_savestack(state, state->intop) != boundary.argument_base_offset)
	{
		return false;
	}
	const auto stack_begin = reinterpret_cast<std::uintptr_t>(state->stack);
	const auto stack_end = reinterpret_cast<std::uintptr_t>(state->stack_last);
	const auto byte_offset = static_cast<std::uintptr_t>(
		boundary.argument_base_offset);
	if (stack_end < stack_begin || byte_offset > stack_end - stack_begin
		|| byte_offset % alignof(luau_TValue) != 0
		|| 2 * sizeof(luau_TValue) > stack_end - stack_begin - byte_offset)
	{
		return false;
	}
	auto* const base = luau_restorestack(state, boundary.argument_base_offset);
	if (diagnostics::bad_read_ptr(base, 2 * sizeof(luau_TValue))) return false;
	for (std::size_t index = 0; index != 2; ++index)
	{
		if (base[index].type != boundary.argument_tags[index]
			|| base[index].value.as_uintptr != boundary.argument_values[index])
		{
			return false;
		}
		arguments[index] = base[index];
	}
	return true;
}

void clear_stock_native_finalize_at_exact_idle(luau_State* state) noexcept
{
	if (state != nullptr && active_stock_native_finalize.active
		&& active_stock_native_finalize.state == state
		&& active_stock_native_finalize.owner_thread
			== static_cast<std::uint32_t>(GetCurrentThreadId()))
	{
		clear_active_stock_native_finalize();
	}
}

// The generic native-call detour is process-owned, while every provider and
// observer is generation-owned.  Only this scalar frame fingerprint may span
// the stock C callback: DE can longjmp out of that callback without running a
// C++ destructor.  The argument values themselves remain rooted in DE's
// native-call frame and are re-read only after the exact frame is proven live.
struct ActiveNativeCallBoundary
{
	bool active = false;
	bool engine_source_published = false;
	luau_State* state = nullptr;
	void* global_state = nullptr;
	luau_CallInfo* owner_call_info = nullptr;
	std::uint32_t owner_function_tag = LUAU_NIL;
	std::uintptr_t owner_function_identity = 0;
	std::uint64_t generation = 0;
	std::uint64_t token = 0;
	std::uint32_t owner_thread = 0;
};
static_assert(std::is_trivially_copyable_v<ActiveNativeCallBoundary>);

thread_local ActiveNativeCallBoundary active_native_call_boundary;
thread_local std::uint64_t next_native_call_boundary_token = 1;

void clear_active_native_call_boundary() noexcept
{
	if (active_native_call_boundary.engine_source_published)
		engine_damage::clear_source();
	active_native_call_boundary = {};
	native_call_hook_running = false;
}

bool native_call_boundary_is_live(
	const ActiveNativeCallBoundary& boundary,
	const luau_State* state
) noexcept
{
	constexpr std::size_t maximum_total_frames = 4096;
	if (!boundary.active || boundary.token == 0 || boundary.generation == 0
		|| state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| boundary.state != state || boundary.global_state == nullptr
		|| boundary.global_state != state->global_state
		|| boundary.owner_thread == 0
		|| boundary.owner_thread != static_cast<std::uint32_t>(GetCurrentThreadId())
		|| boundary.owner_call_info == nullptr
		|| state->base_ci == nullptr || state->ci == nullptr || state->end_ci == nullptr)
	{
		return false;
	}
	const auto base = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto current = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	const auto owner = reinterpret_cast<std::uintptr_t>(boundary.owner_call_info);
	if (!valid_target_call_stack_bounds(
			current, base, sizeof(luau_CallInfo), maximum_total_frames)
		|| end < base || current >= end
		|| sizeof(luau_CallInfo) > end - current
		|| owner < base || owner > current
		|| (owner - base) % sizeof(luau_CallInfo) != 0
		|| sizeof(luau_CallInfo) > end - owner
		|| diagnostics::bad_read_ptr(
			boundary.owner_call_info, sizeof(luau_CallInfo))
		|| boundary.owner_call_info->func == nullptr
		|| diagnostics::bad_read_ptr(
			boundary.owner_call_info->func, sizeof(luau_TValue)))
	{
		return false;
	}
	const auto& function = *boundary.owner_call_info->func;
	return function.type == boundary.owner_function_tag
		&& function.value.as_uintptr == boundary.owner_function_identity;
}

// Returns true only for a genuine nested call below the still-live owner.
// Reuse of the saved CallInfo after a DE longjmp is a stale boundary and is
// retired, including its explicitly published engine-damage source.
bool prepare_native_call_boundary_entry(luau_State* state) noexcept
{
	if (!active_native_call_boundary.active)
	{
		native_call_hook_running = false;
		return false;
	}
	const bool live = native_call_boundary_is_live(
		active_native_call_boundary, state);
	if (!live || (state != nullptr
		&& active_native_call_boundary.owner_call_info == state->ci))
	{
		clear_active_native_call_boundary();
		return false;
	}
	native_call_hook_running = true;
	return true;
}

ActiveNativeCallBoundary make_native_call_boundary(
	luau_State* state,
	std::uint64_t generation
) noexcept
{
	ActiveNativeCallBoundary boundary;
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr
		|| state->ci == nullptr || state->base_ci == nullptr
		|| state->end_ci == nullptr
		|| diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		|| state->ci->func == nullptr
		|| diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue))
		|| generation == 0)
	{
		return boundary;
	}
	const auto base = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto current = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	if (!valid_target_call_stack_bounds(
			current, base, sizeof(luau_CallInfo), 4096)
		|| end < base || current >= end
		|| sizeof(luau_CallInfo) > end - current)
	{
		return boundary;
	}
	auto token = next_native_call_boundary_token++;
	if (token == 0) token = next_native_call_boundary_token++;
	boundary.active = true;
	boundary.state = state;
	boundary.global_state = state->global_state;
	boundary.owner_call_info = state->ci;
	boundary.owner_function_tag = state->ci->func->type;
	boundary.owner_function_identity = state->ci->func->value.as_uintptr;
	boundary.generation = generation;
	boundary.token = token;
	boundary.owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	return boundary;
}

void finish_native_call_boundary(
	std::uint64_t token,
	const ActiveNativeCallBoundary& previous,
	luau_State* state
) noexcept
{
	if (active_native_call_boundary.token == token
		|| !native_call_boundary_is_live(active_native_call_boundary, state))
	{
		clear_active_native_call_boundary();
	}
	if (native_call_boundary_is_live(previous, state))
	{
		active_native_call_boundary = previous;
		native_call_hook_running = true;
	}
}

void clear_native_call_boundary_at_exact_idle(luau_State* state) noexcept
{
	if (state != nullptr && active_native_call_boundary.active
		&& active_native_call_boundary.state == state
		&& active_native_call_boundary.owner_thread
			== static_cast<std::uint32_t>(GetCurrentThreadId()))
	{
		clear_active_native_call_boundary();
	}
	else if (state != nullptr && !active_native_call_boundary.active)
	{
		// Self-heal the legacy scalar guard as well. Exact idle cannot be inside
		// a genuine native callback, so a set flag without a live POD owner is
		// stale evidence from an older unwind.
		native_call_hook_running = false;
	}
}

struct ScopedPauseLoadBoundary
{
	ActivePauseLoadBoundary previous;

	ScopedPauseLoadBoundary(
		bool active,
		std::uint64_t body_key,
		const std::uint32_t* name_handle
	) noexcept
		: previous(active_pause_load_boundary)
	{
		active_pause_load_boundary = {};
		if (active && body_key != 0 && name_handle != nullptr)
		{
			active_pause_load_boundary.active = true;
			active_pause_load_boundary.body_key = body_key;
			active_pause_load_boundary.name_handle[0] = name_handle[0];
			active_pause_load_boundary.name_handle[1] = name_handle[1];
			active_pause_load_boundary.owner_thread =
				static_cast<std::uint32_t>(GetCurrentThreadId());
		}
	}

	~ScopedPauseLoadBoundary()
	{
		active_pause_load_boundary = previous;
	}
};

int ability_card_wrapper(luau_State* state);
int set_damage_callback_adapter(luau_State* state);
int set_source_object_adapter(luau_State* state);
TargetCallsite target_callsite_for_active_call_stack(luau_State* state);
int push_float_arg_adapter(luau_State* state);
int addon_damage_callback_wrapper(luau_State* state);
int run_script_observer_adapter(luau_State* state);
int diagnostic_trace_bridge(luau_State* state);
int target_hook_registry_dispatcher(luau_State* state);
int pause_menu_builder_wrapper(luau_State* state);
int open_scripts_settings_callback(luau_State* state);
int scripts_settings_elements_callback(luau_State* state);
int scripts_settings_changed_callback(luau_State* state);
int scripts_settings_done_callback(luau_State* state);
void disable_native_hook_adapters(const char* reason);
bool decorate_pause_initialize_assignment(
	std::uint64_t body_key,
	luau_State* state,
	const luau_TValue& initialize_value,
	const char* source
);
void remember_target_script_binding(
	std::uint64_t target_key,
	luau_State* state
);
void remember_target_script_binding_from_boundary(
	std::uint64_t target_key,
	luau_State* state,
	const ActiveRunScriptBoundary& boundary
);
void remember_pause_menu_identity(
	std::uint64_t body_key,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle
);
std::uint64_t target_key_for_script_resource(
	const luau_GlobalState* global_state,
	std::uintptr_t script_resource_identity
) noexcept;
void vm_execute_detour(luau_State* state);
std::uint32_t de_luau_interrupt_increment_detour(luau_State* state);
void clear_callback_runtime_result_root_at_exact_idle(luau_State* state) noexcept;
void maybe_poll_runtime_controls() noexcept;
void maybe_run_safe_runtime_tick(luau_State* state) noexcept;
bool drain_pending_target_addons_for_vm(luau_State* state);
void queue_target_addon_refreshes();
bool push_environment_table(
	luau_State* state,
	void* environment,
	luau_TValue* destination
);
bool lifecycle_hook_value(
	luau_State* state,
	const AddonRecord& addon,
	const char* hook_name,
	luau_TValue& output
);
bool install_target_hook_registry_dispatcher(
	luau_State* state,
	void* target_environment,
	std::uint64_t target_key);

bool target_chunk_exists(std::uint64_t target_key);
bool target_key_is_configured(std::uint64_t target_key);

struct ScopedExecutionDepth
{
	ScopedExecutionDepth() noexcept { ++lua_execution_depth; }
	~ScopedExecutionDepth() noexcept
	{
		if (lua_execution_depth != 0) --lua_execution_depth;
	}
};

struct ScopedSafeRuntimeTick
{
	ScopedSafeRuntimeTick() noexcept { safe_runtime_tick_running = true; }
	~ScopedSafeRuntimeTick() noexcept { safe_runtime_tick_running = false; }
};

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

bool scan_snapshot(
	std::vector<Chunk>& snapshot,
	std::vector<std::uint64_t>& target_keys
)
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
		const bool internal_bridge = is_internal_scripts_ui_bridge(name);
		const auto kind = runtime_script_kind(name);
		script_control::Kind control_kind = script_control::Kind::OneShot;
		if (kind == ScriptKind::ManagedAddon) control_kind = script_control::Kind::Addon;
		else if (kind == ScriptKind::TargetManagedAddon) control_kind = script_control::Kind::TargetAddon;
		const auto script_id = script_control::stable_id(control_kind, name);
		const bool policy_enabled = internal_bridge
			|| script_control::candidate_enabled(script_id);
		if (!internal_bridge && is_multi_target_addon(name))
		{
			// Inventory, not execution: declared keys are read from the string
			// pool even while the file is disabled so a later enable can bind
			// modules that already loaded. A malformed multi-target file fails
			// locally; the rest of the generation remains admissible.
			std::vector<unsigned char> bytes;
			std::vector<std::uint64_t> declared;
			const char* reason = multi_target_filename_error(name);
			if (reason == nullptr && !read_file(path, bytes))
				reason = "unreadable-empty-or-oversized";
			if (reason == nullptr)
				reason = discover_multi_target_keys(bytes.data(), bytes.size(), declared);
			if (reason != nullptr)
			{
				const std::string rejected = "RENOVICE MULTI-TARGET ADDON REJECT file="
					+ name + " reason=" + reason
					+ " scope=file-local generation=continues";
				conout << rejected << std::endl;
				config::log(rejected);
				continue;
			}
			target_keys.insert(target_keys.end(), declared.begin(), declared.end());
			std::ostringstream inventory;
			inventory << "RENOVICE MULTI-TARGET ADDON INVENTORY file=" << name
				<< " targets=" << declared.size()
				<< " enabled=" << (policy_enabled ? 1 : 0);
			config::log(inventory.str());
			if (!policy_enabled) continue;
			for (const auto key : declared)
			{
				Chunk chunk;
				chunk.name = name;
				chunk.kind = ScriptKind::TargetManagedAddon;
				chunk.target_key = key;
				chunk.multi_target = true;
				chunk.bytes = bytes;
				snapshot.emplace_back(std::move(chunk));
			}
			continue;
		}
		std::uint64_t target_key = 0;
		if (target_addon_target_discovery_required(kind, policy_enabled))
		{
			if (!target_addon_key(name, target_key))
			{
				conout << "RENOVICE Inject transaction rejected: target addon requires "
					"a nonzero 16-hex original-body key prefix: " << name << std::endl;
				return false;
			}
			target_keys.push_back(target_key);
		}
		if (!policy_enabled) continue;
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
		chunk.target_key = target_key;
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
		// Multi-target bindings share a filename; the key keeps order total.
		return lhs.name != rhs.name ? lhs.name < rhs.name
			: lhs.target_key < rhs.target_key;
	});
	std::sort(target_keys.begin(), target_keys.end());
	target_keys.erase(
		std::unique(target_keys.begin(), target_keys.end()), target_keys.end());
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

const char* lua_mutation_boundary_label(
	LuaMutationBoundaryBlocker blocker
) noexcept
{
	switch (blocker)
	{
	case LuaMutationBoundaryBlocker::Ready: return "ready";
	case LuaMutationBoundaryBlocker::ThreadSuspended: return "thread-suspended";
	case LuaMutationBoundaryBlocker::StackUnavailable: return "stack-unavailable";
	case LuaMutationBoundaryBlocker::StackOrderInvalid: return "stack-order-invalid";
	case LuaMutationBoundaryBlocker::CallInfoUnavailable: return "callinfo-unavailable";
	case LuaMutationBoundaryBlocker::CallInfoBoundsInvalid: return "callinfo-bounds-invalid";
	case LuaMutationBoundaryBlocker::CurrentFrameInvalid: return "current-frame-invalid";
	case LuaMutationBoundaryBlocker::LuaFrameActive: return "lua-frame-active";
	}
	return "unknown";
}

LuaMutationBoundaryBlocker inspect_lua_mutation_boundary(
	luau_State* state
) noexcept
{
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State)))
		return LuaMutationBoundaryBlocker::StackUnavailable;

	const auto stack = reinterpret_cast<std::uintptr_t>(state->stack);
	const auto intop = reinterpret_cast<std::uintptr_t>(state->intop);
	const auto outtop = reinterpret_cast<std::uintptr_t>(state->outtop);
	const auto stack_last = reinterpret_cast<std::uintptr_t>(state->stack_last);
	const auto base_ci = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto current_ci = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto end_ci = reinterpret_cast<std::uintptr_t>(state->end_ci);

	const auto structural = lua_mutation_boundary_blocker(
		state->status,
		stack, intop, outtop, stack_last,
		base_ci, current_ci, end_ci, sizeof(luau_CallInfo),
		false, false, false);
	if (structural != LuaMutationBoundaryBlocker::CurrentFrameInvalid)
		return structural;

	if (state->ci == nullptr || diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		|| state->ci->func == nullptr
		|| diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue)))
	{
		return LuaMutationBoundaryBlocker::CurrentFrameInvalid;
	}
	const auto function_slot = reinterpret_cast<std::uintptr_t>(state->ci->func);
	const auto frame_base = reinterpret_cast<std::uintptr_t>(state->ci->base);
	const auto frame_top = reinterpret_cast<std::uintptr_t>(state->ci->top);
	const bool frame_stack_owned = function_slot >= stack && function_slot < intop
		&& frame_base == intop && frame_top >= outtop && frame_top <= stack_last;
	const bool function = frame_stack_owned && is_function(state->ci->func->type);
	luau_Closure* closure = nullptr;
	const bool closure_readable = function
		&& state->ci->func->value.as_uintptr != 0
		&& !diagnostics::bad_read_ptr(reinterpret_cast<void*>(
			state->ci->func->value.as_uintptr), offsetof(luau_Closure, c.func));
	if (closure_readable)
		closure = reinterpret_cast<luau_Closure*>(state->ci->func->value.as_uintptr);

	return lua_mutation_boundary_blocker(
		state->status,
		stack, intop, outtop, stack_last,
		base_ci, current_ci, end_ci, sizeof(luau_CallInfo),
		frame_stack_owned && closure_readable,
		function,
		closure != nullptr && closure->isC != 0);
}

bool is_userdata(int tag) noexcept
{
	return tag == LUAU_USERDATA || tag == deployed_userdata_tag;
}

Object* readable_engine_object(const luau_TValue& value) noexcept
{
	if (!is_userdata(value.type) || value.value.as_uintptr == 0
		|| value.value.as_uintptr >
			(std::numeric_limits<std::uintptr_t>::max)() - 0x18)
	{
		return nullptr;
	}

	auto* const wrapper_slot = reinterpret_cast<void**>(
		value.value.as_uintptr + 0x18);
	if (diagnostics::bad_read_ptr(wrapper_slot, sizeof(*wrapper_slot))
		|| *wrapper_slot == nullptr)
	{
		return nullptr;
	}

	void* indirect = *wrapper_slot;
	if (diagnostics::bad_read_ptr(indirect, sizeof(void*))) return nullptr;
	if (game_version < GV(38, 5, 0))
	{
		indirect = *reinterpret_cast<void**>(indirect);
		if (indirect == nullptr || diagnostics::bad_read_ptr(indirect, sizeof(void*)))
		{
			return nullptr;
		}
	}

	auto* const object = *reinterpret_cast<Object**>(indirect);
	return object != nullptr && !diagnostics::bad_read_ptr(object, sizeof(Object))
		? object : nullptr;
}

luau_TValue dereference_upvalue(luau_TValue value) noexcept
{
	if (value.type == LUAU_TUPVAL && value.value.gc != nullptr
		&& !diagnostics::bad_read_ptr(value.value.gc, sizeof(luau_UpVal))
		&& value.value.gc->uv.v != nullptr
		&& !diagnostics::bad_read_ptr(value.value.gc->uv.v, sizeof(luau_TValue)))
	{
		return *value.value.gc->uv.v;
	}
	return value;
}

luau_TValue* writable_upvalue_slot(
	luau_Closure* closure,
	std::size_t index
) noexcept
{
	if (closure == nullptr || index >= closure->nupvalues) return nullptr;
	auto* slot = closure->isC
		? &closure->c.upvals[index]
		: &closure->l.uprefs[index];
	if (slot->type == LUAU_TUPVAL)
	{
		if (slot->value.gc == nullptr
			|| diagnostics::bad_read_ptr(slot->value.gc, sizeof(luau_UpVal))
			|| slot->value.gc->uv.v == nullptr
			|| diagnostics::bad_read_ptr(slot->value.gc->uv.v, sizeof(luau_TValue)))
		{
			return nullptr;
		}
		slot = slot->value.gc->uv.v;
	}
	return slot;
}

bool readable_lua_closure(const luau_TValue& value, luau_Closure*& closure) noexcept
{
	closure = nullptr;
	if (!is_function(value.type) || value.value.as_uintptr == 0
		|| diagnostics::bad_read_ptr(reinterpret_cast<void*>(value.value.as_uintptr),
			offsetof(luau_Closure, c.func)))
	{
		return false;
	}
	closure = reinterpret_cast<luau_Closure*>(value.value.as_uintptr);
	return true;
}

struct AbilityCardQueryObservation
{
	bool valid = false;
	bool has_ability = false;
	bool modded_is_boolean = false;
	bool modded = false;
	bool level_is_number = false;
	float level = 0;
	std::uint32_t query_tag = LUAU_NIL;
	std::uintptr_t query_identity = 0;
	luau_TValue query_value{};
std::uint32_t ability_tag = LUAU_NIL;
	std::uintptr_t ability_identity = 0;
	luau_TValue ability_value{};
};

bool push_vm_global(luau_State* state, const char* name)
{
	if (state == nullptr || state->outtop == nullptr || name == nullptr
		|| check_stack == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	auto* const base = state->outtop;
	if (wf_hash != nullptr && luau_gettable != nullptr)
	{
		// Current DE globals are indexed by a native-name hash stored in a
		// BOOL-tagged TValue. OpenWF's ivkr_push_global uses this exact encoding.
		base->value.as_bool = wf_hash(name);
		base->type = LUAU_BOOL;
		state->outtop = base + 1;
		try
		{
			luau_gettable(state, -10002);
			return state->outtop == base + 1;
		}
		catch (const int&)
		{
			state->outtop = base;
			return false;
		}
	}
	if (getfield != nullptr)
	{
		getfield(state, -10002, name);
		return state->outtop == base + 1;
	}
	return false;
}

bool push_hashed_table_field(
	luau_State* state,
	int table_index,
	const char* name
)
{
	if (state == nullptr || state->outtop == nullptr || name == nullptr
		|| wf_hash == nullptr || luau_gettable == nullptr
		|| check_stack == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	auto* const base = state->outtop;
	base->value.as_bool = wf_hash(name);
	base->type = LUAU_BOOL;
	state->outtop = base + 1;
	const int destination_index = table_index < 0
		? table_index - 1 : table_index;
	try
	{
		luau_gettable(state, destination_index);
		return state->outtop == base + 1;
	}
	catch (const int&)
	{
		state->outtop = base;
		return false;
	}
}

bool set_hashed_table_field(
	luau_State* state,
	int table_index,
	const char* name,
	const luau_TValue& value
)
{
	if (state == nullptr || state->outtop == nullptr || name == nullptr
		|| wf_hash == nullptr || luau_settable == nullptr
		|| check_stack == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 3);
	auto* const base = state->outtop;
	base->value.as_bool = wf_hash(name);
	base->type = LUAU_BOOL;
	state->outtop = base + 1;
	push_stack_value(state, value);
	const int destination_index = table_index < 0
		? table_index - 2 : table_index;
	try
	{
		luau_settable(state, destination_index);
		return state->outtop == base;
	}
	catch (const int&)
	{
		state->outtop = base;
		return false;
	}
}

bool read_ability_card_query(
	luau_State* state,
	AbilityCardQueryObservation& observation
)
{
	observation = {};
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| check_stack == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 8);
	auto* const base = state->outtop;
	if (!push_vm_global(state, "_T"))
	{
		state->outtop = base;
		return false;
	}
	if (!is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "AbilityLevelQueryParms");
	if (!is_table((base + 1)->type))
	{
		state->outtop = base;
		return false;
	}
	observation.valid = true;
	observation.query_tag = (base + 1)->type;
	observation.query_identity = (base + 1)->value.as_uintptr;
	observation.query_value = *(base + 1);

	getfield(state, -1, "Ability");
	observation.ability_tag = (base + 2)->type;
	observation.ability_identity = (base + 2)->value.as_uintptr;
	observation.ability_value = *(base + 2);
	observation.has_ability = observation.ability_tag != LUAU_NIL;

	state->outtop = base + 2;
	getfield(state, -1, "Modded");
	observation.modded_is_boolean = (base + 2)->type == LUAU_BOOL;
	observation.modded = observation.modded_is_boolean
		&& (base + 2)->value.as_bool != 0;

	state->outtop = base + 2;
	getfield(state, -1, "Level");
	observation.level_is_number = (base + 2)->type == LUAU_NUMBER;
	if (observation.level_is_number)
	{
		observation.level = (base + 2)->value.as_float;
	}
	state->outtop = base;
	return true;
}

bool native_call_hook_value(
	luau_State* state,
	const AddonRecord& addon,
	const char* method_name,
	const char* phase,
	luau_TValue& output
)
{
	output = {};
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| method_name == nullptr || phase == nullptr)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	getfield(state, -10000, addon.registry_key.c_str());
	auto* base = luau_restorestack(state, base_offset);
	if (!is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "hooks");
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 1)->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "nativeCalls");
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 2)->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, method_name);
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 3)->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, phase);
	base = luau_restorestack(state, base_offset);
	if (!is_function((base + 4)->type))
	{
		state->outtop = base;
		return false;
	}
	output = *(base + 4);
	state->outtop = base;
	return true;
}

bool lua_call_hook_value(
	luau_State* state,
	const AddonRecord& addon,
	std::int32_t prototype,
	const char* phase,
	luau_TValue& output
)
{
	output = {};
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| luau_gettable == nullptr || phase == nullptr || prototype < 0)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	getfield(state, -10000, addon.registry_key.c_str());
	auto* base = luau_restorestack(state, base_offset);
	if (!is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "hooks");
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 1)->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "luaCalls");
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 2)->type))
	{
		state->outtop = base;
		return false;
	}
	if (!luau_push_number(state, static_cast<float>(prototype)))
	{
		state->outtop = base;
		return false;
	}
	try
	{
		luau_gettable(state, -2);
	}
	catch (const int&)
	{
		state->outtop = base;
		return false;
	}
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 3)->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, phase);
	base = luau_restorestack(state, base_offset);
	if (!is_function((base + 4)->type))
	{
		state->outtop = base;
		return false;
	}
	output = *(base + 4);
	state->outtop = base;
	return true;
}

bool read_native_call_requests(
	luau_State* state,
	const AddonRecord& addon,
	std::vector<TargetAddonRecord::NativeCallRequest>& requests,
	std::string& error
)
{
	requests.clear();
	error.clear();
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| luau_next == nullptr)
	{
		error = "missing-vm-table-api";
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	getfield(state, -10000, addon.registry_key.c_str());
	auto* base = luau_restorestack(state, base_offset);
	if (!is_table(base->type))
	{
		error = "missing-lifecycle-root";
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "hooks");
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 1)->type))
	{
		state->outtop = base;
		return true;
	}
	getfield(state, -1, "nativeCalls");
	base = luau_restorestack(state, base_offset);
	if ((base + 2)->type == LUAU_NIL)
	{
		state->outtop = base;
		return true;
	}
	if (!is_table((base + 2)->type))
	{
		error = "nativeCalls-not-table";
		state->outtop = base;
		return false;
	}

	luau_TValue nil{};
	nil.type = LUAU_NIL;
	push_stack_value(state, nil);
	while (luau_next(state, -2) != 0)
	{
		base = luau_restorestack(state, base_offset);
		auto key = state->outtop[-2];
		const auto specification = state->outtop[-1];
		if (key.type == deployed_string_tag) key.type = LUAU_STRING;
		if (key.type != LUAU_STRING || key.value.as_uintptr == 0
			|| !is_table(specification.type))
		{
			error = "nativeCalls-entry-shape";
			state->outtop = base;
			return false;
		}
		const char* const name_text = key.getString();
		const std::size_t name_length = name_text == nullptr
			? 0 : strnlen_s(name_text, 65);
		if (name_length == 0 || name_length > 64)
		{
			error = "nativeCalls-method-name";
			state->outtop = base;
			return false;
		}

		getfield(state, -1, "before");
		const bool before_absent = state->outtop[-1].type == LUAU_NIL;
		const bool before = is_function(state->outtop[-1].type);
		--state->outtop;
		getfield(state, -1, "after");
		const bool after_absent = state->outtop[-1].type == LUAU_NIL;
		const bool after = is_function(state->outtop[-1].type);
		--state->outtop;
		if ((!before_absent && !before) || (!after_absent && !after)
			|| (!before && !after))
		{
			error = "nativeCalls-phase-shape:" + std::string(name_text, name_length);
			state->outtop = base;
			return false;
		}
		requests.push_back({std::string(name_text, name_length), before, after});
		--state->outtop;
	}
	state->outtop = luau_restorestack(state, base_offset);
	std::sort(requests.begin(), requests.end(), [](const auto& lhs, const auto& rhs)
	{
		return lhs.name < rhs.name;
	});
	return true;
}

bool read_lua_call_requests(
	luau_State* state,
	const AddonRecord& addon,
	std::vector<TargetAddonRecord::LuaCallRequest>& requests,
	std::string& error
)
{
	requests.clear();
	error.clear();
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| luau_next == nullptr)
	{
		error = "missing-vm-table-api";
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	getfield(state, -10000, addon.registry_key.c_str());
	auto* base = luau_restorestack(state, base_offset);
	if (!is_table(base->type))
	{
		error = "missing-lifecycle-root";
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "hooks");
	base = luau_restorestack(state, base_offset);
	if (!is_table((base + 1)->type))
	{
		state->outtop = base;
		return true;
	}
	getfield(state, -1, "luaCalls");
	base = luau_restorestack(state, base_offset);
	if ((base + 2)->type == LUAU_NIL)
	{
		state->outtop = base;
		return true;
	}
	if (!is_table((base + 2)->type))
	{
		error = "luaCalls-not-table";
		state->outtop = base;
		return false;
	}

	luau_TValue nil{};
	nil.type = LUAU_NIL;
	push_stack_value(state, nil);
	while (luau_next(state, -2) != 0)
	{
		base = luau_restorestack(state, base_offset);
		const auto key = state->outtop[-2];
		const auto specification = state->outtop[-1];
		if (key.type != LUAU_NUMBER
			|| !valid_lua_call_prototype_id(key.value.as_float)
			|| !is_table(specification.type))
		{
			error = "luaCalls-entry-shape";
			state->outtop = base;
			return false;
		}
		const auto prototype = static_cast<std::int32_t>(key.value.as_float);
		getfield(state, -1, "before");
		const bool before_absent = state->outtop[-1].type == LUAU_NIL;
		const bool before = is_function(state->outtop[-1].type);
		--state->outtop;
		getfield(state, -1, "after");
		const bool after_absent = state->outtop[-1].type == LUAU_NIL;
		const bool after = is_function(state->outtop[-1].type);
		--state->outtop;
		if ((!before_absent && !before) || (!after_absent && !after)
			|| (!before && !after))
		{
			error = "luaCalls-phase-shape:" + std::to_string(prototype);
			state->outtop = base;
			return false;
		}
		if (!lua_call_request_supported(before, after))
		{
			error = "luaCalls-after-retirement-not-implemented:"
				+ std::to_string(prototype);
			state->outtop = base;
			return false;
		}
		if (before && !lua_before_observer_ready.load(std::memory_order_acquire))
		{
			error = "luaCalls-before-observer-unavailable:"
				+ std::to_string(prototype);
			state->outtop = base;
			return false;
		}
		if (std::any_of(requests.begin(), requests.end(), [&](const auto& request)
			{ return request.prototype == prototype; }))
		{
			error = "luaCalls-duplicate-prototype:" + std::to_string(prototype);
			state->outtop = base;
			return false;
		}
		requests.push_back({prototype, before, after});
		--state->outtop;
	}
	state->outtop = luau_restorestack(state, base_offset);
	std::sort(requests.begin(), requests.end(), [](const auto& lhs, const auto& rhs)
	{
		return lhs.prototype < rhs.prototype;
	});
	return true;
}

bool read_ability_card_result(
	luau_State* state,
	std::uint32_t& result_tag,
	std::uintptr_t& result_identity,
	luau_TValue& result_value
)
{
	result_tag = LUAU_NIL;
	result_identity = 0;
	result_value = {};
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| check_stack == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 4);
	auto* const base = state->outtop;
	if (!push_vm_global(state, "_T"))
	{
		state->outtop = base;
		return false;
	}
	if (!is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "AbilityUpgradeLevelInfo");
	result_tag = (base + 1)->type;
	result_identity = (base + 1)->value.as_uintptr;
	result_value = *(base + 1);
	const bool result_is_table = is_table(result_tag);
	state->outtop = base;
	return result_is_table;
}

bool target_addon_active_locked(
	std::uint64_t target_key,
	const luau_GlobalState* global_state
) noexcept
{
	return std::any_of(
		active_target_addons.begin(), active_target_addons.end(),
		[&](const TargetAddonRecord& addon)
		{
			return addon.target_key == target_key
				&& addon.global_state == global_state;
		});
}

bool native_damage_adapters_requested_locked() noexcept
{
	return std::any_of(
		active_target_addons.begin(), active_target_addons.end(),
		[](const TargetAddonRecord& addon)
		{
			return addon.requires_native_damage_adapters;
		});
}

bool native_callsite_adapters_requested_locked() noexcept
{
	return std::any_of(
		active_target_addons.begin(), active_target_addons.end(),
		[](const TargetAddonRecord& addon)
		{
			return addon.requires_native_callsite_adapters;
		});
}

std::vector<std::string> native_call_hook_names_requested_locked()
{
	std::vector<std::string> names;
	for (const auto& addon : active_target_addons)
	{
		for (const auto& request : addon.native_call_requests)
		{
			names.push_back(request.name);
		}
	}
	std::sort(names.begin(), names.end());
	names.erase(std::unique(names.begin(), names.end()), names.end());
	return names;
}

void publish_target_execution_snapshot_locked()
{
	auto snapshot = std::make_shared<TargetExecutionSnapshot>();
	snapshot->generation = active_generation;
	for (const auto& addon : active_target_addons)
	{
		auto entry = std::find_if(snapshot->providers.begin(), snapshot->providers.end(),
			[&](const auto& p) { return p.key == addon.target_key && p.vm == addon.global_state; });
		if (entry == snapshot->providers.end())
		{
			snapshot->providers.push_back({addon.target_key,
				static_cast<const luau_GlobalState*>(addon.global_state),
				{addon.addon}, {}, {}, addon.requires_native_damage_adapters,
				addon.requires_native_callsite_adapters});
		}
		else
		{
			entry->addons.push_back(addon.addon);
			entry->native_damage = entry->native_damage
				|| addon.requires_native_damage_adapters;
			entry->native_callsite = entry->native_callsite
				|| addon.requires_native_callsite_adapters;
		}
		entry = std::find_if(snapshot->providers.begin(), snapshot->providers.end(),
			[&](const auto& p) { return p.key == addon.target_key && p.vm == addon.global_state; });
		for (const auto& request : addon.native_call_requests)
			entry->native_methods.push_back(request.name);
		for (const auto& request : addon.lua_call_requests)
			if (request.before)
				entry->lua_before_prototypes.push_back(request.prototype);
	}
	for (auto& entry : snapshot->providers)
	{
		std::sort(entry.addons.begin(), entry.addons.end(),
			[](const auto& a, const auto& b) { return a.name < b.name; });
		std::sort(entry.native_methods.begin(), entry.native_methods.end());
		entry.native_methods.erase(std::unique(
			entry.native_methods.begin(), entry.native_methods.end()),
			entry.native_methods.end());
		std::sort(entry.lua_before_prototypes.begin(),
			entry.lua_before_prototypes.end());
		entry.lua_before_prototypes.erase(std::unique(
			entry.lua_before_prototypes.begin(),
			entry.lua_before_prototypes.end()),
			entry.lua_before_prototypes.end());
	}
	for (const auto& identity : target_module_identities)
	{
		const bool active_execution_target = std::any_of(
			active_target_addons.begin(), active_target_addons.end(),
			[&](const TargetAddonRecord& addon)
			{
				return target_addon_requires_execution_identity(
						addon.requires_native_damage_adapters,
						addon.requires_native_callsite_adapters,
						addon.requires_lua_call_hooks,
						!addon.native_call_requests.empty())
					&& addon.target_key == identity.target_key
					&& addon.global_state == identity.global_state;
			});
		if (!active_execution_target) continue;
		TargetExecutionIdentity published_identity{
			identity.target_key,
			identity.global_state,
			identity.environment,
			identity.root_proto,
			{},
		};
		published_identity.prototypes = identity.prototypes;
		std::sort(published_identity.prototypes.begin(), published_identity.prototypes.end(),
			[](const auto& lhs, const auto& rhs) { return lhs.address < rhs.address; });
		snapshot->identities.push_back(std::move(published_identity));
	}
	for (const auto& identity : target_module_identities)
	{
		if (identity.runtime_root || identity.root_proto == nullptr) continue;
		const bool desired = std::any_of(
			active_chunks.begin(), active_chunks.end(), [&](const Chunk& chunk)
			{
				return chunk.kind == ScriptKind::TargetManagedAddon
					&& chunk.target_key == identity.target_key;
			});
		const bool duplicate = std::any_of(
			snapshot->roots.begin(), snapshot->roots.end(),
			[&](const TargetRootWatch& root)
			{
				return root.global_state == identity.global_state
					&& root.root_proto == identity.root_proto;
			});
		if (desired && !duplicate)
		{
			snapshot->roots.push_back({identity.target_key,
				identity.global_state, identity.root_proto});
		}
	}
	target_root_watch_enabled.store(
		!snapshot->roots.empty(), std::memory_order_release);
	const bool has_admitted_lua_before_provider = std::any_of(
		snapshot->providers.begin(), snapshot->providers.end(),
		[&](const TargetExecutionSnapshot::Providers& provider)
		{
			if (provider.lua_before_prototypes.empty()) return false;
			return std::any_of(
				snapshot->identities.begin(), snapshot->identities.end(),
				[&](const TargetExecutionIdentity& identity)
				{
					if (identity.target_key != provider.key
						|| identity.global_state != provider.vm)
					{
						return false;
					}
					return std::any_of(
						identity.prototypes.begin(), identity.prototypes.end(),
						[&](const TargetProtoRecord& prototype)
						{
							return std::binary_search(
								provider.lua_before_prototypes.begin(),
								provider.lua_before_prototypes.end(),
								prototype.bytecode_id);
						});
				});
		});
	published_target_execution_snapshot.store(
		std::shared_ptr<const TargetExecutionSnapshot>(std::move(snapshot)),
		std::memory_order_release);
	lua_before_provider_fast_gate.store(
		has_admitted_lua_before_provider, std::memory_order_release);
}

struct TargetExecutionLease
{
	GenerationDispatchGate::Lease dispatch;
	std::shared_ptr<const TargetExecutionSnapshot> snapshot;
	explicit operator bool() const noexcept
	{
		return dispatch && snapshot != nullptr;
	}
};

TargetExecutionLease acquire_target_execution_snapshot() noexcept
{
	TargetExecutionLease result;
	result.dispatch = generation_dispatch_gate.try_dispatch();
	if (!result.dispatch) return result;
	result.snapshot = published_target_execution_snapshot.load(
		std::memory_order_acquire);
	return result;
}

struct HookAddonSnapshot
{
	TargetExecutionLease execution;
	const std::vector<AddonRecord>* addons = nullptr;
	using const_iterator = std::vector<AddonRecord>::const_iterator;
	const_iterator begin() const noexcept
	{
		return addons == nullptr ? empty_records().begin() : addons->begin();
	}
	const_iterator end() const noexcept
	{
		return addons == nullptr ? empty_records().end() : addons->end();
	}
	bool empty() const noexcept { return begin() == end(); }
	std::size_t size() const noexcept
	{
		return addons == nullptr ? 0 : addons->size();
	}
	static const std::vector<AddonRecord>& empty_records() noexcept
	{
		static const std::vector<AddonRecord> value;
		return value;
	}
};

const TargetProtoRecord* published_target_proto(
	const TargetExecutionIdentity& identity,
	std::uintptr_t address) noexcept;
bool published_target_proto_is_live(
	const TargetProtoRecord& recorded) noexcept;
bool published_target_closure_is_live(
	luau_State* state,
	luau_Closure* closure,
	const TargetExecutionIdentity& identity,
	const TargetProtoRecord*& matched) noexcept;

std::uint64_t target_key_for_published_closure(
	luau_State* state,
	const luau_TValue& function,
	bool* ambiguous_match = nullptr
) noexcept
{
	auto execution = acquire_target_execution_snapshot();
	const auto* snapshot = execution.snapshot.get();
	luau_Closure* closure = nullptr;
	if (snapshot == nullptr || state == nullptr || state->global_state == nullptr
		|| !readable_lua_closure(function, closure) || closure->isC)
	{
		return 0;
	}
	std::uint64_t selected = 0;
	for (auto it = snapshot->identities.rbegin();
		it != snapshot->identities.rend(); ++it)
	{
		const TargetProtoRecord* prototype = nullptr;
		if (published_target_closure_is_live(
				state, closure, *it, prototype))
		{
			if (!merge_target_ability_match(it->target_key, selected))
			{
				if (ambiguous_match) *ambiguous_match = true;
				return 0;
			}
		}
	}
	return selected;
}

const TargetProtoRecord* published_target_proto(
	const TargetExecutionIdentity& identity,
	std::uintptr_t address
) noexcept
{
	const auto prototype = std::lower_bound(
		identity.prototypes.begin(), identity.prototypes.end(), address,
		[](const TargetProtoRecord& candidate, std::uintptr_t value)
		{
			return candidate.address < value;
		});
	return prototype != identity.prototypes.end()
		&& prototype->address == address ? &*prototype : nullptr;
}

bool published_target_proto_is_live(const TargetProtoRecord& recorded) noexcept
{
	constexpr std::size_t prototype_prefix_size = 0xb0;
	if (recorded.address < 0x10000
		|| recorded.address % alignof(void*) != 0
		|| recorded.code < 0x10000
		|| recorded.code % sizeof(std::uint32_t) != 0
		|| recorded.instructions <= 0 || recorded.instructions > 1048576
		|| recorded.bytecode_id < 0
		|| diagnostics::bad_read_ptr(
			reinterpret_cast<const void*>(recorded.address),
			prototype_prefix_size))
	{
		return false;
	}

	std::array<unsigned char, prototype_prefix_size> bytes{};
	std::memcpy(bytes.data(), reinterpret_cast<const void*>(recorded.address),
		bytes.size());
	std::uintptr_t live_code = 0;
	std::int32_t live_instructions = 0;
	std::int32_t live_bytecode_id = -1;
	std::memcpy(&live_code, bytes.data() + 0x10, sizeof(live_code));
	std::memcpy(&live_instructions, bytes.data() + 0x88,
		sizeof(live_instructions));
	std::memcpy(&live_bytecode_id, bytes.data() + 0xa8,
		sizeof(live_bytecode_id));
	if (bytes[0] != 12 || live_code != recorded.code
		|| live_instructions != recorded.instructions
		|| live_bytecode_id != recorded.bytecode_id)
	{
		return false;
	}
	const auto code_bytes = static_cast<std::size_t>(live_instructions)
		* sizeof(std::uint32_t);
	return !diagnostics::bad_read_ptr(
		reinterpret_cast<const void*>(live_code), code_bytes);
}

bool published_target_closure_is_live(
	luau_State* state,
	luau_Closure* closure,
	const TargetExecutionIdentity& identity,
	const TargetProtoRecord*& matched
) noexcept
{
	matched = nullptr;
	if (state == nullptr || state->global_state == nullptr || closure == nullptr
		|| diagnostics::bad_read_ptr(
			closure, offsetof(luau_Closure, l.uprefs))
		|| closure->isC || closure->l.p == nullptr
		|| identity.target_key == 0
		|| identity.global_state != state->global_state
		|| identity.environment == nullptr
		|| closure->env != identity.environment
		|| diagnostics::bad_read_ptr(identity.environment, sizeof(std::uint8_t))
		|| identity.root_proto == nullptr)
	{
		return false;
	}

	const auto* const root = published_target_proto(
		identity, reinterpret_cast<std::uintptr_t>(identity.root_proto));
	const auto* const prototype = published_target_proto(
		identity, reinterpret_cast<std::uintptr_t>(closure->l.p));
	if (root == nullptr || root->parent != 0 || prototype == nullptr
		|| !published_target_proto_is_live(*root)
		|| (prototype != root && !published_target_proto_is_live(*prototype)))
	{
		return false;
	}
	matched = prototype;
	return true;
}

TargetLuaCall target_lua_call_for_published_closure(
	const TargetExecutionSnapshot& snapshot,
	luau_State* state,
	const luau_TValue& function
) noexcept
{
	TargetLuaCall selected;
	luau_Closure* closure = nullptr;
	if (state == nullptr || state->global_state == nullptr
		|| !readable_lua_closure(function, closure) || closure->isC
		|| closure->l.p == nullptr
		|| diagnostics::bad_read_ptr(closure, offsetof(luau_Closure, l.uprefs)))
	{
		return {};
	}
	// Exact prototype identity is the authority: a module root can run in a
	// runtime environment different from the one recorded at load, and every
	// closure it creates inherits that runtime environment. The strict
	// load-environment comparison therefore rejected every live call (no
	// luaCalls dispatch since V107). The same VM, a registry-pinned recorded
	// prototype, live code/instruction/bytecode-id identity and a unique owning
	// key remain mandatory; ambiguity fails closed.
	const auto owner = select_target_prototype_owner(
		snapshot.identities, state->global_state, closure->env,
		reinterpret_cast<std::uintptr_t>(closure->l.p),
		[](const TargetProtoRecord& record)
		{
			return published_target_proto_is_live(record);
		});
	if (!owner.exact || owner.ambiguous) return {};
	selected.callsite.target_key = owner.target_key;
	selected.callsite.prototype = owner.bytecode_id;
	selected.callsite.exact = true;
	selected.closure = closure;
	return selected;
}

std::uint64_t target_key_for_closure_locked(
	luau_State* state,
	const luau_TValue& function
) noexcept
{
	luau_Closure* closure = nullptr;
	if (state == nullptr || state->global_state == nullptr
		|| !readable_lua_closure(function, closure) || closure->isC)
	{
		return 0;
	}
	std::uint64_t selected = 0;
	for (auto it = target_module_identities.rbegin();
		it != target_module_identities.rend(); ++it)
	{
		if (it->global_state != state->global_state
			|| it->environment == nullptr || closure->env != it->environment
			|| it->root_proto == nullptr
			|| !target_addon_active_locked(it->target_key, state->global_state))
		{
			continue;
		}
		const auto find_prototype = [&](std::uintptr_t address)
			-> const TargetProtoRecord*
		{
			const auto prototype = std::lower_bound(
				it->prototypes.begin(), it->prototypes.end(), address,
				[](const TargetProtoRecord& candidate, std::uintptr_t value)
				{
					return candidate.address < value;
				});
			return prototype != it->prototypes.end()
				&& prototype->address == address ? &*prototype : nullptr;
		};
		const auto* const root = find_prototype(
			reinterpret_cast<std::uintptr_t>(it->root_proto));
		const auto* const prototype = find_prototype(
			reinterpret_cast<std::uintptr_t>(closure->l.p));
		if (root != nullptr && root->parent == 0 && prototype != nullptr
			&& published_target_proto_is_live(*root)
			&& (prototype == root || published_target_proto_is_live(*prototype)))
		{
			if (!merge_target_ability_match(it->target_key, selected)) return 0;
		}
	}
	return selected;
}

HookAddonSnapshot hook_addons_snapshot(
	std::uint64_t target_key,
	const luau_GlobalState* global_state
)
{
	HookAddonSnapshot result;
	result.execution = acquire_target_execution_snapshot();
	if (result.execution.snapshot)
		for (const auto& entry : result.execution.snapshot->providers)
			if (entry.key == target_key && entry.vm == global_state)
			{
				result.addons = &entry.addons;
				break;
			}
	return result;
}

bool target_provider_claims_native_method(
	std::uint64_t target_key,
	const luau_GlobalState* global_state,
	std::string_view method) noexcept
{
	auto execution = acquire_target_execution_snapshot();
	const auto* snapshot = execution.snapshot.get();
	if (snapshot == nullptr) return false;
	for (const auto& entry : snapshot->providers)
	{
		if (entry.key != target_key || entry.vm != global_state) continue;
		return std::binary_search(
			entry.native_methods.begin(), entry.native_methods.end(), method);
	}
	return false;
}

bool target_provider_claims_lua_before(
	const TargetExecutionSnapshot& snapshot,
	std::uint64_t target_key,
	const luau_GlobalState* global_state,
	std::int32_t prototype) noexcept
{
	for (const auto& entry : snapshot.providers)
	{
		if (entry.key != target_key || entry.vm != global_state) continue;
		return std::binary_search(
			entry.lua_before_prototypes.begin(),
			entry.lua_before_prototypes.end(), prototype);
	}
	return false;
}

bool any_target_provider_claims_native_method(
	const luau_GlobalState* global_state,
	std::string_view method) noexcept
{
	auto execution = acquire_target_execution_snapshot();
	if (!execution) return false;
	for (const auto& entry : execution.snapshot->providers)
	{
		if (entry.vm == global_state && std::binary_search(
			entry.native_methods.begin(), entry.native_methods.end(), method))
		{
			return true;
		}
	}
	return false;
}

bool target_snapshot_requests_native_damage(
	const luau_GlobalState* global_state) noexcept
{
	auto execution = acquire_target_execution_snapshot();
	if (!execution) return false;
	return std::any_of(
		execution.snapshot->providers.begin(), execution.snapshot->providers.end(),
		[&](const auto& entry)
		{
			return entry.vm == global_state && entry.native_damage;
		});
}

bool target_snapshot_requests_native_callsite(
	const luau_GlobalState* global_state) noexcept
{
	auto execution = acquire_target_execution_snapshot();
	if (!execution) return false;
	return std::any_of(
		execution.snapshot->providers.begin(), execution.snapshot->providers.end(),
		[&](const auto& entry)
		{
			return entry.vm == global_state && entry.native_callsite;
		});
}

// Destructor-free bounded copy of a Lua error string. Callable inside raw
// protected leaves: it owns only a fixed stack buffer and scalar state.
void capture_lua_error_text(
	const luau_TValue& value,
	char* output,
	std::size_t capacity) noexcept
{
	if (output == nullptr || capacity == 0) return;
	output[0] = '\0';
	if ((value.type != LUAU_STRING && value.type != deployed_string_tag)
		|| value.value.as_uintptr == 0
		|| value.value.as_uintptr > (std::numeric_limits<std::uintptr_t>::max)() - 0x18)
	{
		return;
	}
	const char* const text = reinterpret_cast<const char*>(value.value.as_uintptr + 0x18);
	char raw[lua_error_text_capacity]{};
	const std::size_t limit = capacity < sizeof(raw) ? capacity : sizeof(raw);
	std::size_t length = 0;
	while (length != limit && !diagnostics::bad_read_ptr(text + length, 1)
		&& text[length] != '\0')
	{
		raw[length] = text[length];
		++length;
	}
	sanitize_error_text(raw, length, output, capacity);
}

void append_error_value(
	std::ostringstream& details,
	const char* label,
	const luau_TValue& value
)
{
	details << ' ' << label << "_tag=" << static_cast<int>(value.type);
	if ((value.type == LUAU_STRING || value.type == deployed_string_tag)
		&& value.value.as_uintptr != 0
		&& value.value.as_uintptr <=
			(std::numeric_limits<std::uintptr_t>::max)() - 0x18
		&& !diagnostics::bad_read_ptr(reinterpret_cast<void*>(value.value.as_uintptr + 0x18), 1))
	{
		const char* const text = const_cast<luau_TValue&>(value).getString();
		constexpr std::size_t maximum_error_length = 1024;
		std::size_t length = 0;
		while (length != maximum_error_length
			&& !diagnostics::bad_read_ptr(text + length, 1) && text[length] != '\0')
		{
			++length;
		}
		details << "=\"";
		details.write(text, static_cast<std::streamsize>(length));
		if (length == maximum_error_length) details << "...";
		details << '"';
	}
	else if (value.type == LUAU_BOOL)
	{
		details << '=' << (value.value.as_bool != 0 ? "true" : "false");
	}
	else if (value.type == LUAU_NUMBER)
	{
		details << '=' << value.value.as_float;
	}
	else if (value.type != LUAU_NIL)
	{
		details << "=0x" << std::hex << value.value.as_uintptr << std::dec;
	}
}

std::atomic<std::uint64_t> addon_trace_sequence = 0;
std::atomic_bool addon_trace_suppression_logged = false;
std::atomic<std::uint64_t> addon_trace_attempts = 0;
std::atomic<std::uint64_t> native_ingress_trace_sequence = 0;
std::atomic_bool native_ingress_trace_suppression_logged = false;
std::atomic<std::uint64_t> damage_timing_sequence = 0;
thread_local std::uint64_t addon_trace_attempt = 0;
thread_local bool addon_trace_detail_enabled = true;
thread_local std::uint64_t addon_dispatch_errors = 0;

struct AddonDetailScope
{
	bool previous = addon_trace_detail_enabled;
	explicit AddonDetailScope(bool enabled) { addon_trace_detail_enabled = enabled; }
	~AddonDetailScope() { addon_trace_detail_enabled = previous; }
};

struct AddonTraceScope
{
	std::uint64_t previous = addon_trace_attempt;
	explicit AddonTraceScope(std::uint64_t existing = 0)
	{
		addon_trace_attempt = existing != 0 ? existing
			: addon_trace_attempts.fetch_add(1, std::memory_order_relaxed) + 1;
	}
	~AddonTraceScope() { addon_trace_attempt = previous; }
};

bool full_addon_trace_requested() noexcept
{
	return config::diagnostics_mode() == config::DiagnosticsMode::trace;
}

void trace_addon(luau_State* state, std::uint64_t key, const char* event,
	const std::string& detail = {}, const luau_TValue* arguments = nullptr,
	std::size_t argument_count = 0) noexcept
{
	const auto mode = config::diagnostics_mode();
	if (mode == config::DiagnosticsMode::off || event == nullptr) return;
	try
	{
		if (!diagnostic_runtime_event_allowed(mode, event)) return;
		const auto flags = config::flags();
		if (!diagnostic_trace_selected(flags, key, event, detail)) return;
		const auto sequence = addon_trace_sequence.fetch_add(1, std::memory_order_relaxed) + 1;
		const auto limit = flags.diagnostics_max_events;
		if (sequence > limit)
		{
			if (!addon_trace_suppression_logged.exchange(true, std::memory_order_relaxed))
			{
				std::ostringstream suppressed;
				suppressed << "RENOVICE ADDON_TRACE build=V79 event=trace.suppressed"
					<< " reason=event-budget-exhausted limit=" << limit;
				config::diagnostic_log(suppressed.str(), mode);
			}
			return;
		}
		std::ostringstream out;
		out << "RENOVICE ADDON_TRACE build=V79 pid=" << GetCurrentProcessId()
			<< " tick_ms=" << GetTickCount64() << " seq=" << sequence
			<< " attempt=" << addon_trace_attempt << " thread=" << GetCurrentThreadId()
			<< " key=0x" << std::hex << key << std::dec
			<< " state=" << state << " vm=" << (state ? state->global_state : nullptr);
		out << " event=" << event << " ci=" << (state ? state->ci : nullptr)
			<< " top=" << (state ? state->outtop : nullptr) << ' ' << detail;
		if (arguments)
		{
			out << " argc=" << argument_count;
			for (std::size_t i = 0; i < argument_count && i < 8; ++i)
				append_error_value(out, ("arg" + std::to_string(i)).c_str(), arguments[i]);
		}
		config::diagnostic_log(out.str(), mode);
	}
	catch (...)
	{
		config::diagnostic_log(
			"RENOVICE ADDON_TRACE build=V79 event=trace.failure reason=formatter-exception",
			config::DiagnosticsMode::errors);
	}
}

const char* readable_string_handle(std::uint32_t handle) noexcept
{
	if (string_pool == nullptr || diagnostics::bad_read_ptr(string_pool, sizeof(*string_pool))
		|| *string_pool == nullptr)
	{
		return nullptr;
	}
	const auto bucket_index = static_cast<std::size_t>(handle & 0xffffu);
	const auto byte_offset = static_cast<std::size_t>(handle >> 16);
	auto* const buckets = *string_pool;
	if (diagnostics::bad_read_ptr(buckets + bucket_index, sizeof(StringPoolBucket))
		|| buckets[bucket_index].data == nullptr
		|| byte_offset > (std::numeric_limits<std::uintptr_t>::max)()
			- reinterpret_cast<std::uintptr_t>(buckets[bucket_index].data))
	{
		return nullptr;
	}
	const auto* const text = buckets[bucket_index].data + byte_offset;
	return diagnostics::bad_read_ptr(text, 1) ? nullptr : text;
}

void append_bounded_trace_text(
	std::ostringstream& details, const char* label, const char* text) noexcept
{
	details << ' ' << label << "=\"";
	if (text == nullptr)
	{
		details << "<unavailable>\"";
		return;
	}
	constexpr std::size_t maximum_length = 240;
	std::size_t length = 0;
	while (length != maximum_length && !diagnostics::bad_read_ptr(text + length, 1)
		&& text[length] != '\0')
	{
		++length;
	}
	for (std::size_t i = 0; i != length; ++i)
	{
		const unsigned char character = static_cast<unsigned char>(text[i]);
		details << (character >= 0x20 && character <= 0x7e
			&& character != '"' && character != '\\'
			? static_cast<char>(character) : '?');
	}
	if (length == maximum_length) details << "...";
	details << '"';
}

void append_engine_object_trace(
	std::ostringstream& details,
	const char* label,
	const luau_TValue& value
) noexcept
{
	details << ' ' << label << "_tag=" << value.type
		<< ' ' << label << "_userdata=0x" << std::hex
		<< value.value.as_uintptr << std::dec;
	auto* const object = readable_engine_object(value);
	details << ' ' << label << "_object=" << object;
	if (object == nullptr) return;
	details << ' ' << label << "_id=0x" << std::hex << object->id
		<< ' ' << label << "_object_path_handle=0x" << object->path_handle
		<< std::dec;
	auto* const type = object->type;
	details << ' ' << label << "_type=" << type;
	if (type == nullptr || diagnostics::bad_read_ptr(type, sizeof(ObjectType))) return;
	std::uint32_t type_path_handle = 0;
	if (type->path_handle != nullptr
		&& !diagnostics::bad_read_ptr(type->path_handle, sizeof(*type->path_handle)))
	{
		type_path_handle = *type->path_handle;
	}
	details << ' ' << label << "_type_path_handle=0x" << std::hex
		<< type_path_handle << ' ' << label << "_type_name_handle=0x"
		<< type->name_handle << std::dec;
	append_bounded_trace_text(details,
		(std::string(label) + "_type_path").c_str(),
		readable_string_handle(type_path_handle));
	append_bounded_trace_text(details,
		(std::string(label) + "_type_name").c_str(),
		readable_string_handle(type->name_handle));
}

void trace_damage_object_identities(
	luau_State* state,
	std::uint64_t key,
	std::uint64_t correlation,
	const luau_TValue& source,
	const luau_TValue& callback_context,
	const luau_TValue& damage_packet
) noexcept
{
	try
	{
		std::ostringstream details;
		details << "correlation=" << correlation;
		append_engine_object_trace(details, "source", source);
		append_engine_object_trace(details, "callback", callback_context);
		append_engine_object_trace(details, "packet", damage_packet);
		trace_addon(state, key, "damage.identity", details.str());
	}
	catch (...)
	{
		trace_addon(state, key, "damage.identity.error",
			"correlation=" + std::to_string(correlation)
				+ " reason=formatter-exception");
	}
}

std::string bounded_diagnostic_text(const char* value)
{
	if (value == nullptr) return {};
	constexpr std::size_t maximum = 240;
	std::size_t length = 0;
	while (length != maximum && !diagnostics::bad_read_ptr(value + length, 1)
		&& value[length] != '\0')
	{
		++length;
	}
	return std::string(value, length);
}

std::string engine_object_type_name(const luau_TValue& value)
{
	auto* const object = readable_engine_object(value);
	if (object == nullptr || object->type == nullptr
		|| diagnostics::bad_read_ptr(object->type, sizeof(ObjectType)))
	{
		return {};
	}
	return bounded_diagnostic_text(
		readable_string_handle(object->type->name_handle));
}

std::size_t diagnostic_proto_bucket(std::uintptr_t address) noexcept
{
	return ((address >> 4) ^ (address >> 19))
		& (diagnostic_proto_bucket_count - 1);
}

std::string native_damage_object_type(std::uintptr_t address)
{
	const auto copy = [](const void* input, void* output, std::size_t size) {
		SIZE_T copied = 0;
		return input != nullptr && ReadProcessMemory(GetCurrentProcess(), input,
			output, size, &copied) && copied == size;
	};
	Object object{};
	ObjectType type{};
	StringPoolBucket* buckets = nullptr;
	StringPoolBucket bucket{};
	if (!copy(reinterpret_cast<const void*>(address), &object, sizeof(object))
		|| !copy(object.type, &type, sizeof(type))
		|| !copy(string_pool, &buckets, sizeof(buckets)) || buckets == nullptr
		|| !copy(buckets + (type.name_handle & 0xffffu), &bucket, sizeof(bucket))
		|| bucket.data == nullptr) return {};
	const auto offset = type.name_handle >> 16;
	std::string result;
	for (std::size_t i = 0; i < 240; ++i) {
		char character = 0;
		if (!copy(bucket.data + offset + i, &character, 1)) return {};
		if (character == 0) return result;
		result += character;
	}
	return result;
}

const DiagnosticProtoIdentity* diagnostic_proto_identity(
	void* global_state, std::uintptr_t address) noexcept
{
	if (global_state == nullptr || address == 0) return nullptr;
	const DiagnosticProtoIdentity* selected = nullptr;
	for (auto* candidate = diagnostic_proto_buckets[
		diagnostic_proto_bucket(address)].load(std::memory_order_acquire);
		candidate != nullptr; candidate = candidate->next)
	{
		if (candidate->global_state != global_state
			|| candidate->address != address)
		{
			continue;
		}
		if (selected != nullptr
			&& (selected->body_key != candidate->body_key
				|| selected->code != candidate->code
				|| selected->instructions != candidate->instructions))
		{
			return nullptr;
		}
		selected = candidate;
	}
	return selected;
}

DiagnosticDamageCallsite diagnostic_damage_callsite_for_active_stack(
	luau_State* state)
{
	constexpr std::size_t maximum_total_frames = 4096;
	constexpr std::size_t maximum_inspected_frames = 32;
	if (state == nullptr || state->global_state == nullptr
		|| state->ci == nullptr || state->base_ci == nullptr)
	{
		return {};
	}
	const auto current = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto base = reinterpret_cast<std::uintptr_t>(state->base_ci);
	if (!valid_target_call_stack_bounds(
			current, base, sizeof(luau_CallInfo), maximum_total_frames))
	{
		return {};
	}
	auto address = current;
	for (std::size_t frame = 0;
		frame != maximum_inspected_frames && address >= base; ++frame)
	{
		auto* const info = reinterpret_cast<luau_CallInfo*>(address);
		if (diagnostics::bad_read_ptr(info, sizeof(*info)) || info->func == nullptr
			|| diagnostics::bad_read_ptr(info->func, sizeof(luau_TValue)))
		{
			break;
		}
		luau_Closure* closure = nullptr;
		if (readable_lua_closure(*info->func, closure) && !closure->isC)
		{
			const auto* identity = diagnostic_proto_identity(
				state->global_state,
				reinterpret_cast<std::uintptr_t>(closure->l.p));
			if (identity != nullptr)
			{
				DiagnosticDamageCallsite result;
				result.callsite.target_key = identity->body_key;
				result.callsite.prototype = identity->bytecode_id;
				result.module_path = identity->module_path;
				result.module_name = identity->module_name;
				std::uint32_t instruction = 0;
				const auto bytes = static_cast<std::size_t>(
					identity->instructions) * sizeof(std::uint32_t);
				if (!diagnostics::bad_read_ptr(
						reinterpret_cast<const void*>(identity->code), bytes)
					&& native_callsite_instruction_from_saved_pc(
						reinterpret_cast<const std::uint32_t*>(identity->code),
						identity->instructions, info->savedpc, instruction, game_version >= GV(44, 0, 0)))
				{
					result.callsite.instruction = instruction;
					result.callsite.exact = true;
				}
				return result;
			}
		}
		if (address == base || address < sizeof(luau_CallInfo)) break;
		address -= sizeof(luau_CallInfo);
	}
	return {};
}

int diagnostic_trace_bridge(luau_State* state)
{
	// Config reload commits after the managed-generation transaction. A bridge
	// in another VM can therefore remain reachable until that VM next reaches a
	// natural target boundary. Keep off/errors modes formatting-free even while
	// physical bridge cleanup is pending in that VM.
	if (!diagnostic_bridge_may_format(config::diagnostics_mode())) return 0;
	// This bridge is intentionally observation-only. It never raises a Lua
	// error and never changes the caller's results. A bounded event budget keeps
	// a bad gameplay loop from turning diagnostic logging into a new failure.
	try
	{
		const auto maximum_events = config::flags().diagnostics_max_events;
		const auto sequence = diagnostic_trace_sequence.fetch_add(
			1, std::memory_order_relaxed) + 1;
		if (sequence > maximum_events)
		{
			if (!diagnostic_trace_suppression_logged.exchange(
				true, std::memory_order_relaxed))
			{
				std::ostringstream suppressed;
				suppressed << "RENOVICE TRACE SUPPRESSED reason=event-budget-exhausted limit="
					<< maximum_events;
				config::diagnostic_log(
					suppressed.str(), config::DiagnosticsMode::battle);
			}
			return 0;
		}

		// Managed caster records need their complete structured payload. Ordinary
		// error-value formatting deliberately truncates strings and cannot carry
		// these records. Only the protected managed observer's active context may
		// use this lane; bounds/termination failures produce an explicit failure.
		if (automatic_damage_trace_context.active && state != nullptr
			&& state->intop != nullptr && luau_gettop(state) == 3) {
			auto event = state->intop[0];
			auto payload = state->intop[2];
			const auto text = [](luau_TValue& value, std::size_t maximum) -> std::string {
				if ((value.type != LUAU_STRING && value.type != deployed_string_tag)
					|| value.value.as_uintptr == 0
					|| value.value.as_uintptr > (std::numeric_limits<std::uintptr_t>::max)() - 0x18)
					return {};
				const char* input = value.getString();
				std::string result;
				for (std::size_t i = 0; i <= maximum;) {
					std::array<char, 128> buffer{}; SIZE_T copied = 0;
					const auto address = reinterpret_cast<std::uintptr_t>(input);
					if (address > (std::numeric_limits<std::uintptr_t>::max)() - i) return {};
					const auto count = (std::min)({buffer.size(), maximum + 1 - i,
						std::size_t{4096} - ((address + i) & 4095)});
					if (!ReadProcessMemory(GetCurrentProcess(), input + i, buffer.data(), count, &copied)
						|| copied != count) return {};
					for (std::size_t j = 0; j != count; ++j) {
						if (buffer[j] == 0) return result;
						if (i + j == maximum) return {};
						result.push_back(buffer[j]);
					}
					i += count;
				}
				return {};
			};
			const auto event_name = text(event, 32);
			if (event_name == "CASTER_STATS" || event_name == "CASTER_CALCULATION" || event_name == "BUFF_LIST") {
				const auto json = text(payload, 8192);
				if (json.empty() || state->intop[1].type != LUAU_NUMBER
					|| state->intop[1].value.as_float != automatic_damage_trace_context.sequence) {
					config::diagnostic_log("RENOVICE CASTER_STATS build=V82 event=failed reason=payload-or-id", config::DiagnosticsMode::errors);
					return 0;
				}
				std::ostringstream record;
				record << "RENOVICE CASTER_STATS build=V82 pid=" << GetCurrentProcessId()
					<< " vm=" << state->global_state << " tick_ms=" << GetTickCount64()
					<< " event=" << event_name << " snapshot=" << automatic_damage_trace_context.sequence
					<< " source_body=0x" << std::hex << automatic_damage_trace_context.source.callsite.target_key << std::dec;
				append_bounded_trace_text(record, "source_path", automatic_damage_trace_context.source.module_path.c_str());
				append_bounded_trace_text(record, "source_name", automatic_damage_trace_context.source.module_name.c_str());
				record << " json=" << json;
				config::diagnostic_log(record.str(), config::DiagnosticsMode::battle);
				return 0;
			}
		}
		std::ostringstream details;
		details << "RENOVICE TRACE build=V79 pid=" << GetCurrentProcessId()
			<< " tick_ms=" << GetTickCount64() << " seq=" << sequence
			<< " vm=" << (state != nullptr ? state->global_state : nullptr)
			<< " thread=" << GetCurrentThreadId();
		if (automatic_damage_trace_context.active)
		{
			details << " auto_capture=scripted-damagedd"
				<< " auto_sequence=" << automatic_damage_trace_context.sequence
				<< " source_body=0x" << std::hex
				<< automatic_damage_trace_context.source.callsite.target_key
				<< std::dec
				<< " source_prototype="
				<< automatic_damage_trace_context.source.callsite.prototype
				<< " source_instruction="
				<< automatic_damage_trace_context.source.callsite.instruction;
			append_bounded_trace_text(details, "source_path",
				automatic_damage_trace_context.source.module_path.empty()
					? nullptr
					: automatic_damage_trace_context.source.module_path.c_str());
			append_bounded_trace_text(details, "source_name",
				automatic_damage_trace_context.source.module_name.empty()
					? nullptr
					: automatic_damage_trace_context.source.module_name.c_str());
			append_bounded_trace_text(details, "target_type",
				automatic_damage_trace_context.target_type.empty()
					? nullptr
					: automatic_damage_trace_context.target_type.c_str());
		}
		if (state == nullptr || state->intop == nullptr || state->outtop == nullptr)
		{
			details << " arguments=unavailable";
		}
		else
		{
			const int argument_count = luau_gettop(state);
			details << " arguments=" << argument_count;
			for (int i = 0; i != argument_count; ++i)
			{
				const std::string label = "arg" + std::to_string(i);
				auto value = state->intop[i];
				// The live DE build shifts GC-backed TValue tags by one relative
				// to the restored upstream header. Decode the observed string tag
				// for diagnostics without changing VM values or general ABI logic.
				if (value.type == deployed_string_tag) value.type = LUAU_STRING;
				append_error_value(details, label.c_str(), value);
			}
		}
		config::diagnostic_log(details.str(), config::DiagnosticsMode::battle);
	}
	catch (...)
	{
		// A C callback must not unwind through the game's Luau VM. The one-time
		// fallback still makes an unexpected formatter failure visible.
		if (!diagnostic_trace_suppression_logged.exchange(
			true, std::memory_order_relaxed))
		{
			config::diagnostic_log(
				"RENOVICE TRACE SUPPRESSED reason=native-formatter-exception",
				config::DiagnosticsMode::battle);
		}
	}
	return 0;
}

enum class SharedCallbackLeafStage : std::uint8_t
{
	none,
	reserve_stack,
	push_function,
	push_argument,
	invoke_callback,
	capture_error,
	capture_error_field,
	capture_result,
};

constexpr std::size_t shared_callback_result_capacity = 8;
constexpr std::size_t shared_callback_error_field_count = 10;
constexpr const char* shared_callback_error_fields[shared_callback_error_field_count]{
	"message", "Message", "error", "Error", "what", "reason",
	"traceback", "stack", "source", "line",
};

struct SharedCallbackLeafContext
{
	luau_TValue function{};
	const luau_TValue* arguments = nullptr;
	std::size_t argument_count = 0;
	int requested_results = 0;
	luau_TValue results[shared_callback_result_capacity]{};
	std::size_t actual_result_count = 0;
	std::size_t copied_result_count = 0;
	luau_TValue error{};
	luau_TValue error_fields[shared_callback_error_field_count]{};
	std::uint16_t error_field_mask = 0;
	int callback_status = 0;
	bool error_present = false;
	bool completed = false;
	SharedCallbackLeafStage stage = SharedCallbackLeafStage::none;
	std::size_t failure_index = 0;
};
static_assert(std::is_trivially_copyable_v<SharedCallbackLeafContext>);

struct SharedCallbackOutcome
{
	SharedCallbackLeafContext leaf{};
	bool accepted = false;
	bool admitted = false;
	bool restored = false;
	int raw_status = -1;
};

struct SharedCallbackMemorySnapshot
{
	bool enabled = false;
	std::uint64_t before = 0;
};
static_assert(std::is_trivially_copyable_v<SharedCallbackMemorySnapshot>);

// BEGIN SHARED_CALLBACK_PROTECTED_LEAF
// This complete region runs below DE's raw protected boundary. It deliberately
// owns only scalars, raw pointers, fixed TValue arrays, and a POD context. A DE
// Lua error may skip every ordinary C++ scope in this leaf without stranding a
// lock, string, vector, TLS owner, or generation lease.
bool shared_callback_leaf_push_value(
	luau_State* state,
	const luau_TValue& value)
{
	if (state == nullptr || state->outtop == nullptr || state->stack_last == nullptr
		|| gc_barrierback == nullptr || state->outtop >= state->stack_last)
	{
		return false;
	}
	if ((state->marked & native_gc_black_mask_u43) != 0)
	{
		gc_barrierback(
			state, reinterpret_cast<luau_GCObject*>(state), &state->gclist);
	}
	*state->outtop = value;
	++state->outtop;
	return true;
}

void shared_callback_leaf_capture_error(
	luau_State* state,
	std::ptrdiff_t error_offset,
	SharedCallbackLeafContext* context)
{
	if (state == nullptr || context == nullptr || state->stack == nullptr
		|| state->stack_last == nullptr || state->outtop == nullptr
		|| error_offset < 0)
	{
		return;
	}
	auto* error = luau_restorestack(state, error_offset);
	if (error < state->stack || error >= state->stack_last
		|| state->outtop <= error || state->outtop > state->stack_last)
	{
		return;
	}
	context->error = *error;
	context->error_present = true;
	if (!is_table(context->error.type) || getfield == nullptr
		|| check_stack(state, 2) == 0)
	{
		return;
	}
	error = luau_restorestack(state, error_offset);
	if (error < state->stack || error >= state->stack_last) return;
	state->outtop = error + 1;
	for (std::size_t index = 0;
		index != shared_callback_error_field_count; ++index)
	{
		context->stage = SharedCallbackLeafStage::capture_error_field;
		context->failure_index = index;
		getfield(state, -1, shared_callback_error_fields[index]);
		error = luau_restorestack(state, error_offset);
		if (state->outtop == error + 2 && (error + 1)->type != LUAU_NIL)
		{
			context->error_fields[index] = *(error + 1);
			context->error_field_mask |= static_cast<std::uint16_t>(1u << index);
		}
		state->outtop = error + 1;
	}
}

void shared_callback_protected_leaf(luau_State* state, void* opaque)
{
	auto* const context = static_cast<SharedCallbackLeafContext*>(opaque);
	if (state == nullptr || context == nullptr || state->stack == nullptr
		|| state->stack_last == nullptr || state->outtop == nullptr
		|| state->ci == nullptr || state->ci->top == nullptr
		|| check_stack == nullptr || protected_call == nullptr
		|| gc_barrierback == nullptr || !is_function(context->function.type)
		|| context->requested_results < 0
		|| context->requested_results > static_cast<int>(shared_callback_result_capacity)
		|| (context->argument_count != 0 && context->arguments == nullptr)
		|| context->argument_count > static_cast<std::size_t>(
			(std::numeric_limits<int>::max)() - 2))
	{
		return;
	}

	context->stage = SharedCallbackLeafStage::reserve_stack;
	const auto required_slots = (std::max)(
		context->argument_count + 2,
		static_cast<std::size_t>(context->requested_results + 2));
	if (required_slots > static_cast<std::size_t>((std::numeric_limits<int>::max)())
		|| check_stack(state, static_cast<int>(required_slots)) == 0
		|| state->stack == nullptr || state->stack_last == nullptr
		|| state->outtop == nullptr || state->ci == nullptr
		|| state->ci->top == nullptr || state->outtop < state->stack
		|| state->outtop > state->stack_last
		|| state->ci->top < state->outtop
		|| state->ci->top > state->stack_last
		|| required_slots > static_cast<std::size_t>(state->stack_last - state->outtop)
		|| required_slots > static_cast<std::size_t>(state->ci->top - state->outtop))
	{
		return;
	}

	const auto base_offset = luau_savestack(state, state->outtop);
	context->stage = SharedCallbackLeafStage::push_function;
	if (!shared_callback_leaf_push_value(state, context->function)) return;
	for (std::size_t index = 0; index != context->argument_count; ++index)
	{
		context->stage = SharedCallbackLeafStage::push_argument;
		context->failure_index = index;
		if (!shared_callback_leaf_push_value(state, context->arguments[index])) return;
	}

	context->stage = SharedCallbackLeafStage::invoke_callback;
	context->callback_status = protected_call(
		state, static_cast<int>(context->argument_count),
		context->requested_results, 0);
	auto* base = luau_restorestack(state, base_offset);
	if (state->outtop == nullptr || base < state->stack || base > state->stack_last
		|| state->outtop < base || state->outtop > state->stack_last)
	{
		return;
	}

	if (context->callback_status != 0)
	{
		context->stage = SharedCallbackLeafStage::capture_error;
		shared_callback_leaf_capture_error(state, base_offset, context);
		context->completed = true;
		return;
	}

	context->stage = SharedCallbackLeafStage::capture_result;
	context->actual_result_count = static_cast<std::size_t>(state->outtop - base);
	context->copied_result_count = (std::min)(
		context->actual_result_count, shared_callback_result_capacity);
	for (std::size_t index = 0; index != context->copied_result_count; ++index)
	{
		context->results[index] = base[index];
	}
	context->completed = true;
}
// END SHARED_CALLBACK_PROTECTED_LEAF

const char* shared_callback_leaf_stage_label(SharedCallbackLeafStage stage) noexcept
{
	switch (stage)
	{
	case SharedCallbackLeafStage::none: return "none";
	case SharedCallbackLeafStage::reserve_stack: return "reserve-stack";
	case SharedCallbackLeafStage::push_function: return "push-function";
	case SharedCallbackLeafStage::push_argument: return "push-argument";
	case SharedCallbackLeafStage::invoke_callback: return "invoke-callback";
	case SharedCallbackLeafStage::capture_error: return "capture-error";
	case SharedCallbackLeafStage::capture_error_field: return "capture-error-field";
	case SharedCallbackLeafStage::capture_result: return "capture-result";
	}
	return "unknown";
}

std::uint64_t read_shared_callback_memory_total(luau_State* state) noexcept
{
	std::uint64_t result = 0;
	if (state != nullptr && state->global_state != nullptr)
	{
		std::memcpy(
			&result, reinterpret_cast<const char*>(state->global_state) + 0x48,
			sizeof(result));
	}
	return result;
}

SharedCallbackMemorySnapshot capture_shared_callback_memory(
	luau_State* state) noexcept
{
	SharedCallbackMemorySnapshot snapshot;
	snapshot.enabled = state != nullptr && state->global_state != nullptr
		&& diagnostic_bridge_may_format(config::diagnostics_mode());
	if (snapshot.enabled) snapshot.before = read_shared_callback_memory_total(state);
	return snapshot;
}

void report_shared_callback_memory(
	luau_State* state,
	const char* label,
	const SharedCallbackMemorySnapshot& snapshot) noexcept
{
	if (!snapshot.enabled) return;
	try
	{
		static std::atomic<std::uint64_t> counts[4]{};
		static std::atomic<std::uint64_t> positive_net[4]{};
		static std::atomic<std::uint64_t> negative_net[4]{};
		const std::string_view name = label == nullptr ? "unknown" : label;
		const unsigned lane = name == "casterStats.before" ? 0
			: name == "casterAfter" ? 1
			: name.starts_with("automaticDamage") ? 2 : 3;
		const auto after = read_shared_callback_memory_total(state);
		const auto positive = after >= snapshot.before ? after - snapshot.before : 0;
		const auto negative = snapshot.before > after ? snapshot.before - after : 0;
		const auto positive_sum = positive_net[lane].fetch_add(positive) + positive;
		const auto negative_sum = negative_net[lane].fetch_add(negative) + negative;
		const auto count = counts[lane].fetch_add(1) + 1;
		if (count > 8 && (count & (count - 1)) != 0) return;
		std::ostringstream out;
		out << "RENOVICE VM_MEMORY build=V110 pid=" << GetCurrentProcessId()
			<< " vm=" << (state != nullptr ? state->global_state : nullptr)
			<< " tick_ms=" << GetTickCount64()
			<< " lane=" << lane << " label=" << name << " calls=" << count
			<< " lua_before=" << snapshot.before << " lua_after=" << after
			<< " positive_net_sum=" << positive_sum
			<< " negative_net_sum=" << negative_sum;
		config::diagnostic_log(out.str(), config::DiagnosticsMode::battle);
	}
	catch (...)
	{
		// Read-only evidence cannot alter callback results.
	}
}

bool invoke_shared_callback(
	luau_State* state,
	const luau_TValue& function,
	const luau_TValue* arguments,
	std::size_t argument_count,
	int requested_results,
	const char* label,
	SharedCallbackOutcome& outcome)
{
	outcome = {};
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| protected_call == nullptr || gc_barrierback == nullptr
		|| !is_function(function.type)
		|| requested_results < 0
		|| requested_results > static_cast<int>(shared_callback_result_capacity)
		|| (argument_count != 0 && arguments == nullptr)
		|| argument_count > static_cast<std::size_t>(
			(std::numeric_limits<int>::max)() - 2))
	{
		return false;
	}
	std::vector<luau_TValue> staged_arguments;
	try
	{
		if (argument_count != 0)
			staged_arguments.assign(arguments, arguments + argument_count);
	}
	catch (...)
	{
		return false;
	}
	outcome.accepted = true;
	outcome.leaf.function = function;
	outcome.leaf.arguments = staged_arguments.empty()
		? nullptr : staged_arguments.data();
	outcome.leaf.argument_count = argument_count;
	outcome.leaf.requested_results = requested_results;
	const auto memory = capture_shared_callback_memory(state);
	ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &shared_callback_protected_leaf, &outcome.leaf);
	outcome.admitted = protected_result.admitted;
	outcome.restored = protected_result.restored;
	outcome.raw_status = protected_result.status;
	report_shared_callback_memory(state, label, memory);
	return outcome.admitted && outcome.restored && outcome.raw_status == 0
		&& outcome.leaf.completed;
}

std::string shared_callback_error_details(const SharedCallbackOutcome& outcome)
{
	std::ostringstream details;
	if (!outcome.leaf.error_present)
	{
		details << " error_result=missing";
		return details.str();
	}
	append_error_value(details, "error", outcome.leaf.error);
	for (std::size_t index = 0; index != shared_callback_error_field_count; ++index)
	{
		if ((outcome.leaf.error_field_mask & (1u << index)) == 0) continue;
		std::string field_label = "error_field_";
		field_label += shared_callback_error_fields[index];
		append_error_value(
			details, field_label.c_str(), outcome.leaf.error_fields[index]);
	}
	return details.str();
}

void append_shared_callback_transport_failure(
	std::ostringstream& failure,
	const SharedCallbackOutcome& outcome)
{
	failure << " protected_admitted=" << (outcome.admitted ? 1 : 0)
		<< " protected_restored=" << (outcome.restored ? 1 : 0)
		<< " raw_status=" << outcome.raw_status
		<< " stage=" << shared_callback_leaf_stage_label(outcome.leaf.stage)
		<< " index=" << outcome.leaf.failure_index;
}

bool call_value(
	luau_State* state,
	const luau_TValue& function,
	const luau_TValue* arguments,
	std::size_t argument_count,
	const char* label,
	std::string* traced_results = nullptr
)
{
	constexpr int traced_result_count = 8;
	const int requested_results = traced_results == nullptr ? 0 : traced_result_count;
	SharedCallbackOutcome outcome;
	const bool invoked = invoke_shared_callback(
		state, function, arguments, argument_count, requested_results, label, outcome);
	if (!outcome.accepted) return false;
	if (!invoked || outcome.leaf.callback_status != 0)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (!invoked) append_shared_callback_transport_failure(failure, outcome);
		else failure << " pcall=" << outcome.leaf.callback_status
			<< shared_callback_error_details(outcome);
		trace_addon(state, 0, "pcall.error", failure.str());
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}
	if (traced_results != nullptr)
	{
		std::ostringstream results;
		results << "resultc=" << requested_results;
		if (outcome.leaf.actual_result_count
			!= static_cast<std::size_t>(requested_results))
		{
			results << " stack_resultc=" << outcome.leaf.actual_result_count;
		}
		for (std::size_t i = 0; i != outcome.leaf.copied_result_count; ++i)
		{
			append_error_value(
				results, ("result" + std::to_string(i)).c_str(),
				outcome.leaf.results[i]);
		}
		*traced_results = results.str();
	}
	return true;
}

bool call_boolean_value(
	luau_State* state,
	const luau_TValue& function,
	const luau_TValue* arguments,
	std::size_t argument_count,
	const char* label,
	bool& output
)
{
	output = false;
	SharedCallbackOutcome outcome;
	const bool invoked = invoke_shared_callback(
		state, function, arguments, argument_count, 1, label, outcome);
	if (!outcome.accepted) return false;
	const bool result_is_boolean = invoked && outcome.leaf.callback_status == 0
		&& outcome.leaf.actual_result_count == 1
		&& outcome.leaf.copied_result_count == 1
		&& outcome.leaf.results[0].type == LUAU_BOOL;
	if (result_is_boolean) output = outcome.leaf.results[0].value.as_bool != 0;
	if (!result_is_boolean)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (!invoked) append_shared_callback_transport_failure(failure, outcome);
		else if (outcome.leaf.callback_status != 0)
		{
			failure << " pcall=" << outcome.leaf.callback_status
				<< shared_callback_error_details(outcome);
		}
		else failure << " result=non-boolean";
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}
	return true;
}

bool call_number_value(
	luau_State* state,
	const luau_TValue& function,
	const luau_TValue* arguments,
	std::size_t argument_count,
	const char* label,
	float& output
)
{
	output = 0;
	SharedCallbackOutcome outcome;
	const bool invoked = invoke_shared_callback(
		state, function, arguments, argument_count, 1, label, outcome);
	if (!outcome.accepted) return false;
	const bool result_is_number = invoked && outcome.leaf.callback_status == 0
		&& outcome.leaf.actual_result_count == 1
		&& outcome.leaf.copied_result_count == 1
		&& outcome.leaf.results[0].type == LUAU_NUMBER
		&& std::isfinite(outcome.leaf.results[0].value.as_float);
	if (result_is_number) output = outcome.leaf.results[0].value.as_float;
	if (!result_is_number)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (!invoked) append_shared_callback_transport_failure(failure, outcome);
		else if (outcome.leaf.callback_status != 0)
		{
			failure << " pcall=" << outcome.leaf.callback_status
				<< shared_callback_error_details(outcome);
		}
		else failure << " result=non-finite-or-non-number";
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}
	return true;
}

bool call_identity_value(
	luau_State* state,
	const luau_TValue& function,
	const luau_TValue* arguments,
	std::size_t argument_count,
	const char* label,
	luau_TValue& output
)
{
	output = {};
	SharedCallbackOutcome outcome;
	const bool invoked = invoke_shared_callback(
		state, function, arguments, argument_count, 1, label, outcome);
	if (!outcome.accepted) return false;
	const bool result_has_identity = invoked && outcome.leaf.callback_status == 0
		&& outcome.leaf.actual_result_count == 1
		&& outcome.leaf.copied_result_count == 1
		&& outcome.leaf.results[0].type != LUAU_NIL
		&& outcome.leaf.results[0].value.as_uintptr != 0;
	if (result_has_identity) output = outcome.leaf.results[0];
	const int result_tag = outcome.leaf.copied_result_count == 1
		? static_cast<int>(outcome.leaf.results[0].type) : -1;
	if (!result_has_identity)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (!invoked) append_shared_callback_transport_failure(failure, outcome);
		else if (outcome.leaf.callback_status != 0)
		{
			failure << " pcall=" << outcome.leaf.callback_status
				<< shared_callback_error_details(outcome);
		}
		else failure << " result=missing-identity tag=" << result_tag;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}
	return true;
}

bool call_table_value(
	luau_State* state,
	const luau_TValue& function,
	const luau_TValue* arguments,
	std::size_t argument_count,
	const char* label,
	luau_TValue& output
)
{
	output = {};
	SharedCallbackOutcome outcome;
	const bool invoked = invoke_shared_callback(
		state, function, arguments, argument_count, 1, label, outcome);
	if (!outcome.accepted) return false;
	const bool result_is_table = invoked && outcome.leaf.callback_status == 0
		&& outcome.leaf.actual_result_count == 1
		&& outcome.leaf.copied_result_count == 1
		&& is_table(outcome.leaf.results[0].type);
	if (result_is_table) output = outcome.leaf.results[0];
	const int result_tag = outcome.leaf.copied_result_count == 1
		? static_cast<int>(outcome.leaf.results[0].type) : -1;
	if (!result_is_table)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (!invoked) append_shared_callback_transport_failure(failure, outcome);
		else if (outcome.leaf.callback_status != 0)
		{
			failure << " pcall=" << outcome.leaf.callback_status
				<< shared_callback_error_details(outcome);
		}
		else failure << " result=non-table tag=" << result_tag;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}
	return true;
}

bool table_set_string(luau_State* state, int table_index, const char* key, const std::string& value)
{
	if (state == nullptr || luau_pushstring == nullptr || setfield == nullptr) return false;
	const int destination_index = table_index < 0 ? table_index - 1 : table_index;
	if (luau_pushstring(state, value.c_str()) == nullptr) return false;
	setfield(state, destination_index, key);
	return true;
}

bool table_set_value(
	luau_State* state,
	int table_index,
	const char* key,
	const luau_TValue& value
)
{
	if (state == nullptr || state->outtop == nullptr || setfield == nullptr) return false;
	const int destination_index = table_index < 0 ? table_index - 1 : table_index;
	push_stack_value(state, value);
	setfield(state, destination_index, key);
	return true;
}

bool table_set_bool(luau_State* state, int table_index, const char* key, bool value)
{
	luau_TValue boolean{};
	boolean.value.as_bool = value;
	boolean.type = LUAU_BOOL;
	return table_set_value(state, table_index, key, boolean);
}

bool make_string_value(luau_State* state, const char* value, luau_TValue& output)
{
	output = {};
	if (state == nullptr || state->outtop == nullptr || value == nullptr
		|| check_stack == nullptr || luau_pushstring == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 1);
	auto* const base = state->outtop;
	if (luau_pushstring(state, value) == nullptr)
	{
		state->outtop = base;
		return false;
	}
	output = *base;
	state->outtop = base;
	return true;
}

bool field_value(
	luau_State* state,
	const luau_TValue& owner,
	const char* field,
	luau_TValue& output
)
{
	output = {};
	if (state == nullptr || state->outtop == nullptr || field == nullptr
		|| check_stack == nullptr || getfield == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	auto* const base = state->outtop;
	push_stack_value(state, owner);
	getfield(state, -1, field);
	const bool present = state->outtop == base + 2
		&& (base + 1)->type != LUAU_NIL;
	if (present) output = *(base + 1);
	state->outtop = base;
	return present;
}

bool common_ui_movie_value(
	luau_State* state,
	const char* field,
	luau_TValue& output
)
{
	output = {};
	if (state == nullptr || state->outtop == nullptr || field == nullptr
		|| check_stack == nullptr || getfield == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 3);
	auto* const base = state->outtop;
	if (!push_vm_global(state, "_G") || !is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	const bool field_pushed = push_hashed_table_field(state, -1, field);
	const bool present = field_pushed && state->outtop == base + 2
		&& (base + 1)->type != LUAU_NIL
		&& (base + 1)->value.as_uintptr != 0;
	if (present) output = *(base + 1);
	state->outtop = base;
	return present;
}

constexpr const char* scripts_settings_elements_name =
	"_RENOVICEScriptsSettingsElementsV10";
constexpr const char* scripts_settings_native_elements_name =
	"_RENOVICEScriptsNativeElementsV10";
constexpr const char* scripts_settings_changed_name =
	"_RENOVICEScriptsSettingsChangedV10";
constexpr const char* scripts_settings_done_name =
	"_RENOVICEScriptsSettingsDoneV10";
constexpr const char* scripts_settings_bridge_name =
	"_RENOVICEScriptsOpenBridgeV10";
constexpr const char* target_hook_registry_dispatcher_name =
	"_RENOVICETargetHookV26";

std::mutex scripts_settings_pending_mutex;
std::unordered_map<std::string, bool> scripts_settings_pending;

bool registry_scripts_bridge_value(
	luau_State* state,
	luau_TValue& output
)
{
	AddonRecord bridge;
	bool found = false;
	{
		std::lock_guard lock(generation_mutex);
		const auto it = std::find_if(
			active_addons.begin(), active_addons.end(), [](const AddonRecord& addon)
			{
				return is_internal_scripts_ui_bridge(addon.name);
			});
		if (it != active_addons.end())
		{
			bridge = *it;
			found = true;
		}
	}
	return found && lifecycle_hook_value(
		state, bridge, "openScriptsSettings", output);
}

void clear_scripts_settings_pending()
{
	std::lock_guard lock(scripts_settings_pending_mutex);
	scripts_settings_pending.clear();
}

bool raw_push_vm_global_noexcept(luau_State* state, const char* name) noexcept
{
	if (state == nullptr || state->outtop == nullptr || name == nullptr
		|| check_stack == nullptr || !check_stack(state, 2)) return false;
	auto* const base = state->outtop;
	if (wf_hash != nullptr && luau_gettable != nullptr)
	{
		luau_TValue hash{};
		hash.value.as_bool = wf_hash(name);
		hash.type = LUAU_BOOL;
		if (!append_game_vm_stack_value(state, hash)) return false;
		luau_gettable(state, -10002);
		return state->outtop == base + 1;
	}
	if (getfield == nullptr) return false;
	getfield(state, -10002, name);
	return state->outtop == base + 1;
}

bool raw_push_hashed_table_field_noexcept(
	luau_State* state, int table_index, const char* name) noexcept
{
	if (state == nullptr || state->outtop == nullptr || name == nullptr
		|| check_stack == nullptr || !check_stack(state, 2)) return false;
	const int destination_index = table_index < 0 ? table_index - 1 : table_index;
	if (wf_hash != nullptr && luau_gettable != nullptr)
	{
		luau_TValue hash{};
		hash.value.as_bool = wf_hash(name);
		hash.type = LUAU_BOOL;
		if (!append_game_vm_stack_value(state, hash)) return false;
		luau_gettable(state, destination_index);
		return true;
	}
	if (getfield == nullptr) return false;
	getfield(state, destination_index, name);
	return true;
}

struct ClearScriptsSettingsCallbacksContext
{
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<ClearScriptsSettingsCallbacksContext>);

void clear_scripts_settings_callbacks_leaf(luau_State* state, void* raw_context)
{
	auto* const context = static_cast<ClearScriptsSettingsCallbacksContext*>(
		raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| setfield == nullptr) return;
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!raw_push_vm_global_noexcept(state, "_T")) return;
	auto* const base = luau_restorestack(state, base_offset);
	if (!is_table(base->type)) return;
	static constexpr const char* fields[]{
		scripts_settings_elements_name,
		scripts_settings_native_elements_name,
		scripts_settings_changed_name,
		scripts_settings_done_name,
	};
	luau_TValue nil{};
	nil.type = LUAU_NIL;
	for (const char* const field : fields)
	{
		state->outtop = base + 1;
		if (!append_game_vm_stack_value(state, nil)) return;
		setfield(state, -2, field);
	}
	context->completed = true;
}

void clear_scripts_settings_callbacks(luau_State* state)
{
	ClearScriptsSettingsCallbacksContext context;
	(void)de_vm_authority::run_current_vm_protected(
		state, &clear_scripts_settings_callbacks_leaf, &context);
}

bool table_set_array_value(
	luau_State* state,
	int table_index,
	std::size_t index,
	const luau_TValue& value
);

constexpr const char* scripts_settings_elements_return_root =
	"RENOVICE.scripts-settings-elements.return.v109";

struct PreparedScriptsSettingsRow
{
	std::string label;
	std::string id;
	std::string tooltip;
	bool enabled = false;
	bool valid = false;
};

struct ScriptsSettingsRowView
{
	const char* label = nullptr;
	const char* id = nullptr;
	const char* tooltip = nullptr;
	bool enabled = false;
	bool valid = false;
};
static_assert(std::is_trivially_copyable_v<ScriptsSettingsRowView>);

struct ScriptsSettingsElementsLeafContext
{
	const ScriptsSettingsRowView* rows = nullptr;
	std::size_t row_count = 0;
	luau_TValue control_type{};
	std::size_t failure_index = 0;
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<ScriptsSettingsElementsLeafContext>);

bool raw_table_set_string(
	luau_State* state, int table_index, const char* key, const char* value) noexcept
{
	if (state == nullptr || key == nullptr || value == nullptr
		|| luau_pushstring == nullptr || setfield == nullptr) return false;
	const int destination_index = table_index < 0 ? table_index - 1 : table_index;
	if (luau_pushstring(state, value) == nullptr) return false;
	setfield(state, destination_index, key);
	return true;
}

bool raw_table_set_value(
	luau_State* state, int table_index, const char* key,
	const luau_TValue& value) noexcept
{
	if (state == nullptr || key == nullptr || setfield == nullptr) return false;
	const int destination_index = table_index < 0 ? table_index - 1 : table_index;
	if (!append_game_vm_stack_value(state, value)) return false;
	setfield(state, destination_index, key);
	return true;
}

bool raw_table_set_bool(
	luau_State* state, int table_index, const char* key, bool value) noexcept
{
	luau_TValue boolean{};
	boolean.value.as_bool = value;
	boolean.type = LUAU_BOOL;
	return raw_table_set_value(state, table_index, key, boolean);
}

bool raw_table_set_array_value(
	luau_State* state, int table_index, std::size_t index,
	const luau_TValue& value) noexcept
{
	if (state == nullptr || luau_settable == nullptr
		|| index > (1u << 24)) return false;
	if (!luau_push_number(state, static_cast<float>(index))
		|| !append_game_vm_stack_value(state, value)) return false;
	luau_settable(state, table_index < 0 ? table_index - 2 : table_index);
	return true;
}

void scripts_settings_elements_leaf(luau_State* state, void* raw_context)
{
	auto* const context = static_cast<ScriptsSettingsElementsLeafContext*>(
		raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| state->stack == nullptr || state->ci == nullptr
		|| state->ci->top == nullptr || check_stack == nullptr
		|| luau_createtable == nullptr || luau_pushstring == nullptr
		|| luau_settable == nullptr || setfield == nullptr
		|| context->row_count > static_cast<std::size_t>(1u << 24)
		|| (context->row_count != 0 && context->rows == nullptr)
		|| !check_stack(state, 40)) return;

	const auto base_offset = luau_savestack(state, state->outtop);
	luau_createtable(state, static_cast<int>(context->row_count), 0);
	for (std::size_t index = 0; index != context->row_count; ++index)
	{
		context->failure_index = index;
		auto* base = luau_restorestack(state, base_offset);
		state->outtop = base + 1;
		luau_createtable(state, 0, 7);
		const auto row_offset = luau_savestack(state, state->outtop - 1);
		const auto& row = context->rows[index];
		if (!raw_table_set_string(state, -1, "mLabel", row.label)
			|| !raw_table_set_string(state, -1, "mRawName", row.id)
			|| !raw_table_set_string(state, -1, "mSetting", row.id)
			|| !raw_table_set_string(state, -1, "mTooltip", row.tooltip)
			|| !raw_table_set_value(state, -1, "mType", context->control_type)
			|| !raw_table_set_bool(state, -1, "mValue", row.enabled)
			|| !raw_table_set_bool(state, -1, "mLocked", !row.valid)) return;
		const auto row_value = *luau_restorestack(state, row_offset);
		base = luau_restorestack(state, base_offset);
		state->outtop = base + 1;
		if (!raw_table_set_array_value(state, -1, index + 1, row_value)) return;
	}

	auto* const base = luau_restorestack(state, base_offset);
	state->outtop = base + 1;
	const auto result = *base;
	if (luau_pushstring(state, scripts_settings_elements_return_root) == nullptr
		|| !append_game_vm_stack_value(state, result)) return;
	luau_settable(state, -10000);
	context->completed = true;
}

struct ScriptsSettingsElementsRootContext
{
	luau_TValue value{};
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<ScriptsSettingsElementsRootContext>);

void read_scripts_settings_elements_root_leaf(
	luau_State* state, void* raw_context)
{
	auto* const context = static_cast<ScriptsSettingsElementsRootContext*>(
		raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| getfield == nullptr) return;
	const auto base_offset = luau_savestack(state, state->outtop);
	getfield(state, -10000, scripts_settings_elements_return_root);
	auto* const base = luau_restorestack(state, base_offset);
	if (is_table(base->type))
	{
		context->value = *base;
		context->completed = true;
	}
}

struct ScriptsSettingsElementsClearContext
{
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<ScriptsSettingsElementsClearContext>);

void clear_scripts_settings_elements_root_leaf(
	luau_State* state, void* raw_context)
{
	auto* const context = static_cast<ScriptsSettingsElementsClearContext*>(
		raw_context);
	if (context == nullptr || state == nullptr || setfield == nullptr) return;
	luau_TValue nil{};
	nil.type = LUAU_NIL;
	if (!append_game_vm_stack_value(state, nil)) return;
	setfield(state, -10000, scripts_settings_elements_return_root);
	context->completed = true;
}

bool clear_scripts_settings_elements_root(luau_State* state) noexcept
{
	ScriptsSettingsElementsClearContext context;
	const auto result = de_vm_authority::run_current_vm_protected(
		state, &clear_scripts_settings_elements_root_leaf, &context);
	return result.admitted && result.restored && result.status == 0
		&& context.completed;
}

int scripts_settings_elements_callback(luau_State* state)
{
	try
	{
		if (state == nullptr || state->outtop == nullptr || state->intop == nullptr
			|| check_stack == nullptr || luau_createtable == nullptr
			|| luau_pushcclosurek == nullptr)
		{
			config::log("RENOVICE Scripts settings elements FAIL reason=callback-state");
			return 0;
		}
		const int argument_count = luau_gettop(state);
		if (!pause_toggle_provider_argument_ready(
			static_cast<std::size_t>(argument_count),
			argument_count >= 1 && state->intop[0].type == LUAU_NUMBER))
		{
			config::log("RENOVICE Scripts settings elements FAIL reason=CHECKBOX-type argc="
				+ std::to_string(argument_count));
			return 0;
		}
		const auto control_type = state->intop[0];
		config::log("RENOVICE Scripts settings elements ENTER argc="
			+ std::to_string(argument_count) + " checkbox_tag="
			+ std::to_string(control_type.type) + " checkbox_value="
			+ std::to_string(control_type.value.as_float));

		// Reserve the one C-result slot before creating any owning C++ object. A
		// DE allocation error here follows the game's native error path without
		// skipping a Renovice vector/string destructor.
		if (!check_stack(state, 1)) return 0;

		luau_TValue result_table{};
		std::size_t result_rows = 0;
		bool prepared = false;
		{
			const auto scripts = script_control::snapshot();
			result_rows = scripts.size();
			config::log("RENOVICE Scripts settings inventory rows="
				+ std::to_string(result_rows));
			// Lua numeric array keys are exact only through 2^24 in this float-number
			// VM. This is an ABI representability bound, not a loader/menu policy.
			if (result_rows > static_cast<std::size_t>(1u << 24))
			{
				config::log("RENOVICE Scripts settings elements FAIL reason=row-count-unrepresentable");
				return 0;
			}
			std::vector<PreparedScriptsSettingsRow> prepared_rows;
			prepared_rows.reserve(result_rows);
			for (const auto& script : scripts)
			{
				PreparedScriptsSettingsRow row;
				row.label = script_control::menu_display_name(
					script.kind, script.filename);
				row.id = script.id;
				row.tooltip = script_control::kind_label(script.kind);
				if (!script.target.empty()) row.tooltip += " | target " + script.target;
				row.tooltip += " | " + script.status;
				row.enabled = script.enabled;
				row.valid = script.valid;
				prepared_rows.emplace_back(std::move(row));
			}
			std::vector<ScriptsSettingsRowView> row_views;
			row_views.reserve(prepared_rows.size());
			for (const auto& row : prepared_rows)
			{
				row_views.push_back(ScriptsSettingsRowView{
					row.label.c_str(), row.id.c_str(), row.tooltip.c_str(),
					row.enabled, row.valid});
			}
			ScriptsSettingsElementsLeafContext build_context;
			build_context.rows = row_views.data();
			build_context.row_count = row_views.size();
			build_context.control_type = control_type;
			const auto build_result = de_vm_authority::run_current_vm_protected(
				state, &scripts_settings_elements_leaf, &build_context);
			if (!build_result.admitted || !build_result.restored
				|| build_result.status != 0 || !build_context.completed)
			{
				config::log("RENOVICE Scripts settings elements FAIL reason=protected-build index="
					+ std::to_string(build_context.failure_index)
					+ " status=" + std::to_string(build_result.status));
				return 0;
			}
			ScriptsSettingsElementsRootContext read_context;
			const auto read_result = de_vm_authority::run_current_vm_protected(
				state, &read_scripts_settings_elements_root_leaf, &read_context);
			if (!read_result.admitted || !read_result.restored
				|| read_result.status != 0 || !read_context.completed)
			{
				(void)clear_scripts_settings_elements_root(state);
				config::log("RENOVICE Scripts settings elements FAIL reason=protected-root-read");
				return 0;
			}
			result_table = read_context.value;
			prepared = true;
		}

		if (!prepared || !append_game_vm_stack_value_reserved(state, result_table))
		{
			(void)clear_scripts_settings_elements_root(state);
			config::log("RENOVICE Scripts settings elements FAIL reason=result-slot");
			return 0;
		}
		if (!clear_scripts_settings_elements_root(state))
		{
			config::log("RENOVICE Scripts settings elements FAIL reason=temporary-root-clear");
		}
		config::log("RENOVICE Scripts settings elements PASS rows="
			+ std::to_string(result_rows));
		return 1;
	}
	catch (...)
	{
		config::log("RENOVICE Scripts settings elements FAIL reason=native-exception");
		return 0;
	}
}

int scripts_settings_changed_callback(luau_State* state)
{
	try
	{
		const auto argument_count = state != nullptr && state->intop != nullptr
			? luau_gettop(state) : 0;
		auto id_value = argument_count >= 2 ? state->intop[1] : luau_TValue{};
		if (id_value.type == deployed_string_tag) id_value.type = LUAU_STRING;
		if (!scripts_settings_value_change_ready(
			static_cast<std::size_t>(argument_count),
			argument_count >= 1 && state->intop[0].type == LUAU_BOOL,
			id_value.type == LUAU_STRING && id_value.value.as_uintptr != 0))
		{
			config::log("RENOVICE Scripts settings stage FAIL reason=callback-arguments");
			return 0;
		}
		const std::string id = id_value.getString();
		const bool requested = state->intop[0].value.as_bool != 0;
		const auto scripts = script_control::snapshot();
		const auto found = std::find_if(scripts.begin(), scripts.end(), [&](const auto& script)
		{
			return script.id == id;
		});
		if (found == scripts.end() || !found->valid)
		{
			config::log("RENOVICE Scripts settings stage FAIL id=" + id
				+ " reason=missing-or-invalid");
			return 0;
		}
		{
			std::lock_guard lock(scripts_settings_pending_mutex);
			if (found->enabled == requested) scripts_settings_pending.erase(id);
			else scripts_settings_pending[id] = requested;
		}
		config::log("RENOVICE Scripts settings stage PASS id=" + id
			+ " requested=" + (requested ? "enabled" : "disabled"));
	}
	catch (...)
	{
		config::log("RENOVICE Scripts settings stage FAIL reason=native-exception");
	}
	return 0;
}

int scripts_settings_done_callback(luau_State* state)
{
	const auto argument_count = state != nullptr && state->intop != nullptr
		? luau_gettop(state) : 0;
	const auto decision = classify_scripts_settings_completion(
		static_cast<std::size_t>(argument_count),
		argument_count >= 2 && state->intop[1].type == LUAU_NIL,
		argument_count >= 2 && state->intop[1].type == LUAU_BOOL,
		argument_count >= 2 && state->intop[1].value.as_bool != 0);
	const bool confirmed = decision == ScriptsSettingsCompletionDecision::Confirm;
	const bool cancelled = decision == ScriptsSettingsCompletionDecision::Cancel;
	const bool recognized_close = confirmed || cancelled;
	config::log("RENOVICE Scripts settings completion ENTER argc="
		+ std::to_string(argument_count) + " flag_tag="
		+ std::to_string(argument_count >= 2 ? state->intop[1].type : -1)
		+ " decision=" + (confirmed ? "confirm" : (cancelled ? "cancel" : "reject")));
	std::vector<std::pair<std::string, bool>> requests;
	{
		std::lock_guard lock(scripts_settings_pending_mutex);
		if (recognized_close)
		{
			requests.assign(scripts_settings_pending.begin(), scripts_settings_pending.end());
			std::sort(requests.begin(), requests.end());
		}
		scripts_settings_pending.clear();
	}
	const bool apply_on_close = scripts_settings_should_apply_on_close(
		decision, requests.size());
	if (apply_on_close)
	{
		std::string error;
		if (!script_control::request_enabled_batch(requests, error))
		{
			config::log("RENOVICE Scripts settings commit FAIL reason=" + error);
		}
		else
		{
			config::log("RENOVICE Scripts settings commit PASS action="
				+ std::string(confirmed ? "confirm" : "close-with-changes")
				+ " changes=" + std::to_string(requests.size()));
			request_reload("Scripts settings applied changes");
		}
	}
	else if (recognized_close)
	{
		config::log(std::string("RENOVICE Scripts settings close PASS action=")
			+ (confirmed ? "confirm-no-changes" : "close-no-changes")
			+ " staged-cleared");
	}
	else
	{
		config::log("RENOVICE Scripts settings close FAIL reason=completion-contract staged-cleared");
	}
	clear_scripts_settings_callbacks(state);
	return 0;
}

struct OpenScriptsSettingsLeafContext
{
	luau_TValue parent_movie{};
	luau_TValue bridge{};
	bool bridge_present = false;
	bool completed = false;
	bool opened = false;
	int callback_status = -1;
};
static_assert(std::is_trivially_copyable_v<OpenScriptsSettingsLeafContext>);

void open_scripts_settings_leaf(luau_State* state, void* raw_context)
{
	auto* const context = static_cast<OpenScriptsSettingsLeafContext*>(
		raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| check_stack == nullptr || luau_pushcclosurek == nullptr
		|| luau_pushstring == nullptr || setfield == nullptr
		|| protected_call == nullptr || !check_stack(state, 24)) return;
	const auto base_offset = luau_savestack(state, state->outtop);
	auto* base = luau_restorestack(state, base_offset);

	if (!raw_push_vm_global_noexcept(state, "_G") || !is_table(base->type)
		|| !raw_push_hashed_table_field_noexcept(
			state, -1, "UIMovie_GenericSettings")) return;
	base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 2 || (base + 1)->type == LUAU_NIL
		|| (base + 1)->value.as_uintptr == 0) return;
	const auto settings_resource = *(base + 1);

	state->outtop = base;
	if (!raw_push_vm_global_noexcept(state, "_T")) return;
	base = luau_restorestack(state, base_offset);
	if (!is_table(base->type)) return;
	luau_pushcclosurek(
		state, &scripts_settings_elements_callback,
		"RENOVICE native script settings elements", 0, nullptr);
	setfield(state, -2, scripts_settings_native_elements_name);
	luau_pushcclosurek(
		state, &scripts_settings_changed_callback,
		"RENOVICE native script settings stage", 0, nullptr);
	setfield(state, -2, scripts_settings_changed_name);
	luau_pushcclosurek(
		state, &scripts_settings_done_callback,
		"RENOVICE native script settings close", 0, nullptr);
	setfield(state, -2, scripts_settings_done_name);

	luau_TValue bridge = context->bridge;
	if (!context->bridge_present)
	{
		state->outtop = base + 1;
		if (!raw_push_hashed_table_field_noexcept(
				state, -1, scripts_settings_bridge_name)) return;
		base = luau_restorestack(state, base_offset);
		if (state->outtop != base + 2 || !is_function((base + 1)->type)) return;
		bridge = *(base + 1);
	}
	if (!is_function(bridge.type)) return;

	state->outtop = base;
	if (!append_game_vm_stack_value(state, bridge)
		|| !append_game_vm_stack_value(state, context->parent_movie)
		|| !append_game_vm_stack_value(state, settings_resource)
		|| luau_pushstring(state, scripts_settings_elements_name) == nullptr
		|| luau_pushstring(state, scripts_settings_changed_name) == nullptr
		|| luau_pushstring(state, scripts_settings_done_name) == nullptr) return;
	context->callback_status = protected_call(state, 5, 1, 0);
	base = luau_restorestack(state, base_offset);
	context->completed = true;
	context->opened = context->callback_status == 0
		&& state->outtop == base + 1 && base->type == LUAU_BOOL
		&& base->value.as_bool != 0;
}

int open_scripts_settings_callback(luau_State* state)
{
	try
	{
		if (!scripts_ui_enabled.load(std::memory_order_acquire))
		{
			config::log("RENOVICE Scripts settings open REJECT reason=bridge-not-configured");
			return 0;
		}
		const auto* wrapper = state != nullptr && state->ci != nullptr
			&& state->ci->func != nullptr && is_function(state->ci->func->type)
			? reinterpret_cast<const luau_Closure*>(state->ci->func->value.as_uintptr)
			: nullptr;
		if (wrapper == nullptr || !wrapper->isC || wrapper->nupvalues < 1
			|| state->outtop == nullptr)
		{
			return 0;
		}
		const auto parent_movie = dereference_upvalue(wrapper->c.upvals[0]);
		if (!is_userdata(parent_movie.type) || parent_movie.value.as_uintptr == 0)
		{
			config::log("RENOVICE Scripts settings open FAIL reason=captured-parent-mMovie");
			return 0;
		}
		config::log("RENOVICE Scripts settings parent movie PASS source=captured-upvalue");
		clear_scripts_settings_pending();
		luau_TValue bridge{};
		OpenScriptsSettingsLeafContext context;
		context.parent_movie = parent_movie;
		context.bridge_present = registry_scripts_bridge_value(state, bridge);
		context.bridge = bridge;
		const auto protected_open = de_vm_authority::run_current_vm_protected(
			state, &open_scripts_settings_leaf, &context);
		if (!protected_open.admitted || !protected_open.restored
			|| protected_open.status != 0 || !context.completed || !context.opened)
		{
			clear_scripts_settings_callbacks(state);
			config::log("RENOVICE Scripts settings open FAIL reason=protected-lua-namecall-bridge status="
				+ std::to_string(protected_open.status)
				+ " callback=" + std::to_string(context.callback_status));
			return 0;
		}
		config::log("RENOVICE Scripts settings open PASS renderer=ThemedGenericSettings.CHECKBOX bridge=lua-namecall-v10 lotusutilities-enum=v13");
	}
	catch (...)
	{
		clear_scripts_settings_callbacks(state);
		config::log("RENOVICE Scripts settings open FAIL reason=native-exception");
	}
	return 0;
}

std::size_t array_next_index(luau_State* state, int table_index)
{
	if (state == nullptr || state->outtop == nullptr || luau_next == nullptr) return 1;
	std::size_t maximum = 0;
	const int next_table_index = table_index < 0 ? table_index - 1 : table_index;
	luau_TValue nil{};
	nil.type = LUAU_NIL;
	push_stack_value(state, nil);
	while (luau_next(state, next_table_index) != 0)
	{
		// next leaves key,value. Pop only the value so the key is retained for
		// the next iteration, exactly like lua_next's public stack contract.
		if (state->outtop >= state->stack + 2)
		{
			const auto& key = state->outtop[-2];
			if (key.type == LUAU_NUMBER && key.value.as_float >= 1.0f)
			{
				const auto integer = static_cast<std::size_t>(key.value.as_float);
				if (static_cast<float>(integer) == key.value.as_float)
					maximum = (std::max)(maximum, integer);
			}
		}
		--state->outtop;
	}
	return maximum + 1;
}

bool table_set_array_value(
	luau_State* state,
	int table_index,
	std::size_t index,
	const luau_TValue& value
)
{
	if (state == nullptr || luau_settable == nullptr
		|| index > (1u << 24))
	{
		return false;
	}
	if (!luau_push_number(state, static_cast<float>(index))) return false;
	push_stack_value(state, value);
	luau_settable(state, table_index < 0 ? table_index - 2 : table_index);
	return true;
}

bool table_get_array_value(
	luau_State* state,
	int table_index,
	std::size_t index,
	luau_TValue& value
)
{
	value = {};
	if (state == nullptr || state->outtop == nullptr || luau_gettable == nullptr
		|| index > (1u << 24))
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!luau_push_number(state, static_cast<float>(index))) return false;
	const int destination_index = table_index < 0
		? table_index - 1 : table_index;
	try
	{
		luau_gettable(state, destination_index);
		value = state->outtop[-1];
		state->outtop = luau_restorestack(state, base_offset);
		return true;
	}
	catch (const int&)
	{
		state->outtop = luau_restorestack(state, base_offset);
		return false;
	}
}

bool ui_leaf_push_environment_table(
	luau_State* state,
	void* environment
) noexcept
{
	if (state == nullptr || environment == nullptr
		|| diagnostics::bad_read_ptr(environment, sizeof(std::uint8_t)))
	{
		return false;
	}
	luau_TValue value{};
	value.type = static_cast<std::uint32_t>(
		*reinterpret_cast<const std::uint8_t*>(environment));
	value.value.as_uintptr = reinterpret_cast<std::uintptr_t>(environment);
	return is_table(value.type)
		&& append_game_vm_stack_value_reserved(state, value);
}

bool ui_leaf_push_vm_global(luau_State* state, const char* name) noexcept
{
	if (state == nullptr || state->outtop == nullptr || name == nullptr)
		return false;
	auto* const base = state->outtop;
	if (wf_hash != nullptr && luau_gettable != nullptr)
	{
		luau_TValue key{};
		key.value.as_bool = wf_hash(name);
		key.type = LUAU_BOOL;
		if (!append_game_vm_stack_value_reserved(state, key)) return false;
		luau_gettable(state, -10002);
		return state->outtop == base + 1;
	}
	if (getfield == nullptr) return false;
	getfield(state, -10002, name);
	return state->outtop == base + 1;
}

bool ui_leaf_push_hashed_table_field(
	luau_State* state,
	int table_index,
	const char* name
) noexcept
{
	if (state == nullptr || state->outtop == nullptr || name == nullptr
		|| wf_hash == nullptr || luau_gettable == nullptr)
	{
		return false;
	}
	auto* const base = state->outtop;
	luau_TValue key{};
	key.value.as_bool = wf_hash(name);
	key.type = LUAU_BOOL;
	if (!append_game_vm_stack_value_reserved(state, key)) return false;
	luau_gettable(state, table_index < 0 ? table_index - 1 : table_index);
	return state->outtop == base + 1;
}

std::size_t ui_leaf_array_next_index(
	luau_State* state,
	int table_index
) noexcept
{
	if (state == nullptr || state->outtop == nullptr || luau_next == nullptr)
		return 0;
	std::size_t maximum = 0;
	const int next_table_index = table_index < 0 ? table_index - 1 : table_index;
	luau_TValue nil{};
	nil.type = LUAU_NIL;
	if (!append_game_vm_stack_value_reserved(state, nil)) return 0;
	while (luau_next(state, next_table_index) != 0)
	{
		if (state->outtop < state->stack + 2) return 0;
		const auto& key = state->outtop[-2];
		if (key.type == LUAU_NUMBER && key.value.as_float >= 1.0f)
		{
			const auto integer = static_cast<std::size_t>(key.value.as_float);
			if (static_cast<float>(integer) == key.value.as_float)
				maximum = (std::max)(maximum, integer);
		}
		--state->outtop;
	}
	return maximum + 1;
}

bool ui_leaf_set_literal(
	luau_State* state,
	int table_index,
	const char* key,
	const char* value
) noexcept
{
	if (state == nullptr || key == nullptr || value == nullptr
		|| luau_pushstring == nullptr || setfield == nullptr)
	{
		return false;
	}
	const int destination_index = table_index < 0 ? table_index - 1 : table_index;
	if (luau_pushstring(state, value) == nullptr) return false;
	setfield(state, destination_index, key);
	return true;
}

bool ui_leaf_set_array_value(
	luau_State* state,
	int table_index,
	std::size_t index,
	luau_TValue value
) noexcept
{
	if (state == nullptr || luau_settable == nullptr
		|| index == 0 || index > (1u << 24))
	{
		return false;
	}
	if (!luau_push_number(state, static_cast<float>(index))) return false;
	if (!append_game_vm_stack_value_reserved(state, value)) return false;
	luau_settable(state, table_index < 0 ? table_index - 2 : table_index);
	return true;
}

bool append_scripts_menu_raw(
	luau_State* state,
	const luau_TValue& stock_entries,
	const luau_TValue& parent_movie
) noexcept
{
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| luau_createtable == nullptr || luau_settable == nullptr
		|| setfield == nullptr
		|| luau_pushcclosurek == nullptr || luau_pushstring == nullptr
		|| !is_table(stock_entries.type)
		|| !is_userdata(parent_movie.type) || parent_movie.value.as_uintptr == 0)
	{
		return false;
	}
	if (check_stack(state, 12) == 0) return false;
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!append_game_vm_stack_value_reserved(state, stock_entries)) return false;
	const auto insertion_index = ui_leaf_array_next_index(state, -1);
	if (insertion_index == 0) return false;

	luau_createtable(state, 0, 3);
	const auto parent_offset = luau_savestack(state, state->outtop - 1);
	if (!ui_leaf_set_literal(state, -1, "Name", "SCRIPTS")
		|| !ui_leaf_set_literal(state, -1, "Description",
			"Enable or disable RENOVICE Lua addons and replacements"))
	{
		return false;
	}

	if (!append_game_vm_stack_value_reserved(state, parent_movie)) return false;
	luau_pushcclosurek(
		state, &open_scripts_settings_callback,
		"RENOVICE open native Scripts settings", 1, nullptr);
	setfield(state, -2, "CallBack");
	auto* const parent_slot = luau_restorestack(state, parent_offset);
	const auto parent = *parent_slot;
	state->outtop = parent_slot;
	if (!ui_leaf_set_array_value(state, -1, insertion_index, parent)) return false;
	state->outtop = luau_restorestack(state, base_offset);
	return true;
}

enum class PauseMenuAppendFailure : std::uint8_t
{
	none,
	prerequisite,
	stack_capacity,
	environment,
	movie_capture,
	menu_append,
};

struct PauseMenuAppendContext
{
	void* environment = nullptr;
	luau_TValue stock_entries{};
	std::uint32_t stock_entries_tag = LUAU_NIL;
	PauseMenuAppendFailure failure = PauseMenuAppendFailure::none;
	bool completed = false;
	bool appended = false;
};
static_assert(std::is_trivially_copyable_v<PauseMenuAppendContext>);

// BEGIN PAUSE_MENU_APPEND_PROTECTED_LEAF
void pause_menu_append_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<PauseMenuAppendContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| context->environment == nullptr || getfield == nullptr
		|| check_stack == nullptr)
	{
		if (context != nullptr)
		{
			context->failure = PauseMenuAppendFailure::prerequisite;
			context->completed = true;
		}
		return;
	}
	if (check_stack(state, 16) == 0)
	{
		context->failure = PauseMenuAppendFailure::stack_capacity;
		context->completed = true;
		return;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!ui_leaf_push_environment_table(state, context->environment))
	{
		context->failure = PauseMenuAppendFailure::environment;
		context->completed = true;
		return;
	}
	auto* base = luau_restorestack(state, base_offset);
	getfield(state, -1, "mMovie");
	base = luau_restorestack(state, base_offset);
	const bool environment_is_table = is_table(base->type);
	const bool movie_is_userdata = state->outtop == base + 2
		&& is_userdata((base + 1)->type)
		&& (base + 1)->value.as_uintptr != 0;
	const auto parent_movie = movie_is_userdata
		? *(base + 1) : luau_TValue{};
	state->outtop = base;
	if (!pause_callback_movie_capture_ready(
		true, true, environment_is_table, movie_is_userdata))
	{
		context->failure = PauseMenuAppendFailure::movie_capture;
		context->completed = true;
		return;
	}
	if (!append_scripts_menu_raw(
		state, context->stock_entries, parent_movie))
	{
		context->failure = PauseMenuAppendFailure::menu_append;
		context->completed = true;
		return;
	}
	context->appended = true;
	context->completed = true;
}
// END PAUSE_MENU_APPEND_PROTECTED_LEAF

// BEGIN PAUSE_MENU_BUILDER_OUTER
int pause_menu_builder_wrapper(luau_State* state)
{
	const auto* wrapper = state != nullptr && state->ci != nullptr
		&& state->ci->func != nullptr && is_function(state->ci->func->type)
		? reinterpret_cast<const luau_Closure*>(state->ci->func->value.as_uintptr)
		: nullptr;
	if (wrapper == nullptr || !wrapper->isC || wrapper->nupvalues < 1) return 0;
	const auto original = dereference_upvalue(wrapper->c.upvals[0]);
	luau_Closure* original_closure = nullptr;
	const int argument_count = luau_gettop(state);
	std::vector<luau_TValue> arguments(state->intop, state->intop + argument_count);
	bool appended = false;
	if (!scripts_ui_enabled.load(std::memory_order_acquire))
	{
		config::log("RENOVICE Scripts UI row append SKIP reason=bridge-not-configured");
	}
	else if (arguments.empty() || !is_table(arguments.front().type))
	{
		config::log("RENOVICE Scripts UI row append FAIL reason=dispatch-menu-argument");
	}
	else if (!readable_lua_closure(original, original_closure)
		|| original_closure->isC || original_closure->env == nullptr)
	{
		config::log("RENOVICE Scripts UI row append FAIL reason=dispatch-owner-environment");
	}
	else
	{
		PauseMenuAppendContext context{};
		context.environment = original_closure->env;
		context.stock_entries = arguments.front();
		context.stock_entries_tag = arguments.front().type;
		const auto protected_append = de_vm_authority::run_current_vm_protected(
			state, &pause_menu_append_protected_leaf, &context);
		appended = protected_append.admitted && protected_append.restored
			&& protected_append.status == 0 && context.completed
			&& context.appended;
		if (!appended)
		{
			const char* reason = "raw-protection";
			switch (context.failure)
			{
			case PauseMenuAppendFailure::environment:
				reason = "dispatch-environment-table"; break;
			case PauseMenuAppendFailure::movie_capture:
				reason = "module-mMovie-capture"; break;
			case PauseMenuAppendFailure::menu_append:
				reason = "menu-table-unavailable"; break;
			case PauseMenuAppendFailure::stack_capacity:
				reason = "stack-capacity"; break;
			case PauseMenuAppendFailure::prerequisite:
				reason = "prerequisite"; break;
			case PauseMenuAppendFailure::none:
				break;
			}
			std::ostringstream failure;
			failure << "RENOVICE Scripts UI row append FAIL reason=" << reason
				<< " tag=" << context.stock_entries_tag
				<< " admitted=" << protected_append.admitted
				<< " restored=" << protected_append.restored
				<< " raw_status=" << protected_append.status;
			config::log(failure.str());
		}
		else config::log(
			"RENOVICE Scripts UI row append PASS owner=Initialize.U14.Builder.U58 parent_movie=captured");
	}
	// The wrapper is an additive observer around DE's final dispatch callback.
	// Forward the original call even when our row cannot be appended; otherwise
	// an ABI drift would suppress the stock pause menu instead of failing closed.
	if (!call_value(
		state, original, arguments.data(), arguments.size(),
		"original.TopMenuMenuDispatch"))
	{
		config::log("RENOVICE Scripts UI dispatch FAIL reason=original-callback");
		return 0;
	}
	if (!appended)
	{
		config::log("RENOVICE Scripts UI stock dispatch PASS after additive append failure");
	}
	return 0;
}
// END PAUSE_MENU_BUILDER_OUTER

struct LifecycleHookValueContext
{
	const char* registry_key = nullptr;
	const char* hook_name = nullptr;
	luau_TValue output{};
	bool completed = false;
	bool found = false;
};
static_assert(std::is_trivially_copyable_v<LifecycleHookValueContext>);

// BEGIN LIFECYCLE_HOOK_VALUE_PROTECTED_LEAF
void lifecycle_hook_value_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<LifecycleHookValueContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| context->registry_key == nullptr || context->hook_name == nullptr
		|| getfield == nullptr || check_stack == nullptr)
	{
		if (context != nullptr) context->completed = true;
		return;
	}
	if (check_stack(state, 4) == 0)
	{
		context->completed = true;
		return;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	getfield(state, -10000, context->registry_key);
	auto* base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 1 || !is_table(base->type))
	{
		context->completed = true;
		return;
	}
	getfield(state, -1, "hooks");
	base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 2 || !is_table((base + 1)->type))
	{
		context->completed = true;
		return;
	}
	getfield(state, -1, context->hook_name);
	base = luau_restorestack(state, base_offset);
	if (state->outtop == base + 3 && is_function((base + 2)->type))
	{
		context->output = *(base + 2);
		context->found = true;
	}
	context->completed = true;
}
// END LIFECYCLE_HOOK_VALUE_PROTECTED_LEAF

// BEGIN LIFECYCLE_HOOK_VALUE_OUTER
bool lifecycle_hook_value(
	luau_State* state,
	const AddonRecord& addon,
	const char* hook_name,
	luau_TValue& output
)
{
	output = {};
	output.type = LUAU_NIL;
	if (state == nullptr || state->outtop == nullptr || hook_name == nullptr
		|| addon.registry_key.empty()) return false;
	LifecycleHookValueContext context{};
	context.registry_key = addon.registry_key.c_str();
	context.hook_name = hook_name;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &lifecycle_hook_value_protected_leaf, &context);
	const bool found = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed && context.found;
	if (found) output = context.output;
	return found;
}
// END LIFECYCLE_HOOK_VALUE_OUTER

std::uint64_t target_key_for_active_call_stack(luau_State* state)
{
	constexpr std::size_t maximum_total_frames = 4096;
	constexpr std::size_t maximum_inspected_frames = 32;
	std::uint64_t selected_target_key = 0;
	std::size_t matched_frame = maximum_inspected_frames;
	std::size_t inspected_frames = 0;
	bool ambiguous = false;
	const char* status = "invalid-bounds";
	std::ostringstream frames;

	if (state != nullptr && state->global_state != nullptr
		&& state->ci != nullptr && state->base_ci != nullptr)
	{
		const auto current_call = reinterpret_cast<std::uintptr_t>(state->ci);
		const auto base_call = reinterpret_cast<std::uintptr_t>(state->base_ci);
		if (valid_target_call_stack_bounds(
				current_call, base_call, sizeof(luau_CallInfo), maximum_total_frames))
		{
			status = "missing";
			auto call_info_address = current_call;
			for (std::size_t frame = 0;
				frame != maximum_inspected_frames && call_info_address >= base_call;
				++frame)
			{
				++inspected_frames;
				auto* const call_info = reinterpret_cast<luau_CallInfo*>(
					call_info_address);
				if (diagnostics::bad_read_ptr(call_info, sizeof(*call_info))
					|| call_info->func == nullptr
					|| diagnostics::bad_read_ptr(call_info->func, sizeof(luau_TValue)))
				{
					frames << " frame" << frame << "=unreadable";
					break;
				}

				const auto function = *call_info->func;
				bool ambiguous_closure = false;
				const auto candidate = target_key_for_published_closure(
					state, function, &ambiguous_closure);
				if (ambiguous_closure)
				{
					ambiguous = true;
					status = "ambiguous-prototype";
					break;
				}
				frames << " frame" << frame << "_tag=" << function.type;
				luau_Closure* closure = nullptr;
				if (readable_lua_closure(function, closure))
				{
					frames << "_closure=" << closure
						<< "_isC=" << static_cast<unsigned int>(closure->isC)
						<< "_proto=" << (closure->isC ? nullptr : closure->l.p)
						<< "_env=" << closure->env;
				}
				if (candidate != 0)
				{
					frames << "_target=0x" << std::hex << candidate << std::dec;
					if (matched_frame == maximum_inspected_frames) matched_frame = frame;
					if (!merge_target_ability_match(
							candidate, selected_target_key))
					{
						ambiguous = true;
						status = "ambiguous";
						break;
					}
				}

				if (call_info_address == base_call
					|| call_info_address < sizeof(luau_CallInfo))
				{
					break;
				}
				call_info_address -= sizeof(luau_CallInfo);
			}
			if (!ambiguous && selected_target_key != 0) status = "match";
		}
	}

	// A live DE closure can retain the exact published prototype while using an
	// environment that differs from the module's original publication frame.
	// The strict closure/environment lookup above then rejects a call even though
	// the current-generation prototype graph proves one exact target. Native-call
	// dispatch already uses this exact prototype+saved-PC identity. Reuse that
	// authority as a fail-closed fallback so SetSourceObject can attach the
	// additive damage callback before RadialDamage executes.
	if (!ambiguous && selected_target_key == 0)
	{
		const auto callsite = target_callsite_for_active_call_stack(state);
		const auto fallback_target = select_exact_stack_target(
			selected_target_key, ambiguous, callsite.target_key, callsite.exact);
		if (fallback_target != 0)
		{
			selected_target_key = fallback_target;
			matched_frame = 0;
			status = "exact-prototype-fallback";
			frames << " fallback_target=0x" << std::hex
				<< callsite.target_key << std::dec
				<< "_prototype=" << callsite.prototype
				<< "_instruction=" << callsite.instruction;
		}
	}

	{
		std::ostringstream observation;
		observation << "RENOVICE target call stack OBSERVE status=" << status
			<< " key=0x" << std::hex << selected_target_key << std::dec
			<< " matched_frame="
			<< (matched_frame == maximum_inspected_frames ? -1
				: static_cast<int>(matched_frame))
			<< " inspected_frames=" << inspected_frames
			<< " vm=" << (state == nullptr ? nullptr : state->global_state)
			<< frames.str();
		trace_addon(state, selected_target_key, "target.stack", observation.str());
	}
	return ambiguous ? 0 : selected_target_key;
}

TargetCallsite target_callsite_for_active_call_stack(luau_State* state)
{
	constexpr std::size_t maximum_total_frames = 4096;
	constexpr std::size_t maximum_inspected_frames = 32;
	TargetCallsite selected;
	bool ambiguous = false;
	auto execution = acquire_target_execution_snapshot();
	const auto* snapshot = execution.snapshot.get();
	if (snapshot == nullptr || state == nullptr || state->global_state == nullptr
		|| state->ci == nullptr || state->base_ci == nullptr)
	{
		return {};
	}

	const auto current_call = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto base_call = reinterpret_cast<std::uintptr_t>(state->base_ci);
	if (!valid_target_call_stack_bounds(
			current_call, base_call, sizeof(luau_CallInfo), maximum_total_frames))
	{
		return {};
	}

	auto call_info_address = current_call;
	for (std::size_t frame = 0;
		frame != maximum_inspected_frames && call_info_address >= base_call;
		++frame)
	{
		auto* const call_info = reinterpret_cast<luau_CallInfo*>(call_info_address);
		if (diagnostics::bad_read_ptr(call_info, sizeof(*call_info))
			|| call_info->func == nullptr
			|| diagnostics::bad_read_ptr(call_info->func, sizeof(luau_TValue)))
		{
			break;
		}

		luau_Closure* closure = nullptr;
		if (readable_lua_closure(*call_info->func, closure) && !closure->isC)
		{
			const auto proto_address = reinterpret_cast<std::uintptr_t>(closure->l.p);
			for (auto identity = snapshot->identities.rbegin();
				identity != snapshot->identities.rend(); ++identity)
			{
				if (identity->global_state != state->global_state) continue;
				const auto proto = std::lower_bound(
					identity->prototypes.begin(), identity->prototypes.end(), proto_address,
					[](const TargetProtoRecord& candidate, std::uintptr_t value)
					{
						return candidate.address < value;
					});
				if (proto == identity->prototypes.end()
					|| proto->address != proto_address)
				{
					continue;
				}
				if (!merge_target_ability_match(
						identity->target_key, selected.target_key))
				{
					ambiguous = true;
					break;
				}
				if (!selected.exact)
				{
					std::uint32_t instruction = 0;
					const auto byte_count = static_cast<std::size_t>(proto->instructions)
						* sizeof(std::uint32_t);
					if (!diagnostics::bad_read_ptr(reinterpret_cast<const void*>(proto->code), byte_count)
						&& native_callsite_instruction_from_saved_pc(
							reinterpret_cast<const std::uint32_t*>(proto->code),
							proto->instructions, call_info->savedpc, instruction, game_version >= GV(44, 0, 0)))
					{
						selected.prototype = proto->bytecode_id;
						selected.instruction = instruction;
						selected.exact = true;
					}
				}
			}
		}
		if (ambiguous) return {};
		if (call_info_address == base_call
			|| call_info_address < sizeof(luau_CallInfo))
		{
			break;
		}
		call_info_address -= sizeof(luau_CallInfo);
	}
	if (selected.target_key == 0 || !selected.exact) return {};
	return selected;
}

void trace_native_call_ingress(
	luau_State* state,
	std::size_t slot,
	const NativeCallHookRecord& record,
	luau_CFunction original,
	const TargetCallsite& callsite,
	bool reentrant) noexcept
{
	try
	{
		const auto flags = config::flags();
		if (!diagnostic_native_ingress_selected(flags, record.name)) return;
		const auto sequence = native_ingress_trace_sequence.fetch_add(
			1, std::memory_order_relaxed) + 1;
		if (!sample_native_ingress(sequence, flags.diagnostics_max_events))
		{
			if (!native_ingress_trace_suppression_logged.exchange(
					true, std::memory_order_relaxed))
			{
				std::ostringstream suppressed;
				suppressed << "RENOVICE NATIVE_INGRESS build=V79"
					<< " event=trace.suppressed reason=ingress-budget-exhausted"
					<< " configured_limit=" << flags.diagnostics_max_events
					<< " hard_limit=128 method=" << record.name;
				config::diagnostic_log(
					suppressed.str(), config::DiagnosticsMode::trace);
			}
			return;
		}

		std::ostringstream out;
		out << "RENOVICE NATIVE_INGRESS build=V79 pid=" << GetCurrentProcessId()
			<< " tick_ms=" << GetTickCount64() << " seq=" << sequence
			<< " thread=" << GetCurrentThreadId() << " method=" << record.name
			<< " slot=" << slot << " target=" << reinterpret_cast<void*>(record.target)
			<< " original=" << reinterpret_cast<void*>(original)
			<< " reentrant=" << reentrant
			<< " state=" << state
			<< " vm=" << (state == nullptr ? nullptr : state->global_state)
			<< " ci=" << (state == nullptr ? nullptr : state->ci)
			<< " base_ci=" << (state == nullptr ? nullptr : state->base_ci)
			<< " configured_target=0x" << std::hex
			<< (flags.diagnostics_target_filter_set
				? flags.diagnostics_target_key : 0)
			<< " resolved_target=0x" << callsite.target_key << std::dec
			<< " resolved_exact=" << callsite.exact
			<< " resolved_prototype=" << callsite.prototype
			<< " resolved_instruction=" << callsite.instruction;

		constexpr std::size_t maximum_frames = 8;
		constexpr std::size_t maximum_total_frames = 4096;
		auto execution = acquire_target_execution_snapshot();
		const auto* snapshot = execution.snapshot.get();
		if (state == nullptr || state->global_state == nullptr
			|| state->ci == nullptr || state->base_ci == nullptr)
		{
			out << " stack_status=missing-state";
		}
		else
		{
			const auto current_call = reinterpret_cast<std::uintptr_t>(state->ci);
			const auto base_call = reinterpret_cast<std::uintptr_t>(state->base_ci);
			if (!valid_target_call_stack_bounds(
					current_call, base_call, sizeof(luau_CallInfo), maximum_total_frames))
			{
				out << " stack_status=invalid-bounds";
			}
			else
			{
				out << " stack_status=readable";
				auto address = current_call;
				for (std::size_t frame = 0;
					frame != maximum_frames && address >= base_call; ++frame)
				{
					auto* const info = reinterpret_cast<luau_CallInfo*>(address);
					out << " frame" << frame << "_ci=" << info;
					if (diagnostics::bad_read_ptr(info, sizeof(*info)) || info->func == nullptr
						|| diagnostics::bad_read_ptr(info->func, sizeof(luau_TValue)))
					{
						out << "_status=unreadable";
						break;
					}
					const auto function = *info->func;
					out << "_tag=" << function.type
						<< "_savedpc=" << info->savedpc
						<< "_nresults=" << info->nresults
						<< "_flags=" << info->flags;
					luau_Closure* closure = nullptr;
					if (readable_lua_closure(function, closure))
					{
						out << "_closure=" << closure
							<< "_isC=" << static_cast<unsigned int>(closure->isC);
						if (!closure->isC)
						{
							const auto proto_address = reinterpret_cast<std::uintptr_t>(
								closure->l.p);
							out << "_proto=" << closure->l.p;
							bool matched = false;
							if (snapshot != nullptr)
							{
								for (auto identity = snapshot->identities.rbegin();
									identity != snapshot->identities.rend(); ++identity)
								{
									if (identity->global_state != state->global_state) continue;
									const auto proto = std::lower_bound(
										identity->prototypes.begin(), identity->prototypes.end(),
										proto_address,
										[](const TargetProtoRecord& candidate, std::uintptr_t value)
										{
											return candidate.address < value;
										});
									if (proto == identity->prototypes.end()
										|| proto->address != proto_address) continue;
									matched = true;
									std::uint32_t instruction = 0;
									const auto byte_count = static_cast<std::size_t>(proto->instructions)
										* sizeof(std::uint32_t);
									const bool pc_exact = !diagnostics::bad_read_ptr(
											reinterpret_cast<const void*>(proto->code), byte_count)
										&& native_callsite_instruction_from_saved_pc(
											reinterpret_cast<const std::uint32_t*>(proto->code),
											proto->instructions, info->savedpc, instruction, game_version >= GV(44, 0, 0));
									out << "_identity_target=0x" << std::hex
										<< identity->target_key << std::dec
										<< "_bytecode_id=" << proto->bytecode_id
										<< "_code=" << reinterpret_cast<void*>(proto->code)
										<< "_instructions=" << proto->instructions
										<< "_pc_exact=" << pc_exact
										<< "_instruction=" << instruction;
								}
							}
							if (!matched) out << "_identity=missing";
						}
					}
					if (address == base_call || address < sizeof(luau_CallInfo)) break;
					address -= sizeof(luau_CallInfo);
				}
			}
		}
		config::diagnostic_log(out.str(), config::DiagnosticsMode::trace);
	}
	catch (...)
	{
		config::diagnostic_log(
			"RENOVICE NATIVE_INGRESS build=V79 event=trace.failure reason=formatter-exception",
			config::DiagnosticsMode::errors);
	}
}

std::uint64_t target_key_for_matcher(
	luau_State* state,
	const luau_TValue& value,
	const char* matcher_name
)
{
	if (state == nullptr || state->global_state == nullptr
		|| value.type == LUAU_NIL || matcher_name == nullptr)
	{
		return 0;
	}

	std::uint64_t selected_target_key = 0;
	auto execution = acquire_target_execution_snapshot();
	if (!execution) return 0;
	for (const auto& provider : execution.snapshot->providers)
	{
		if (provider.vm != state->global_state) continue;
		for (const auto& addon : provider.addons)
		{
			luau_TValue matcher{};
			if (!lifecycle_hook_value(state, addon, matcher_name, matcher)) continue;
			bool matched = false;
			if (!call_boolean_value(
					state, matcher, &value, 1, matcher_name, matched)
				|| !matched)
			{
				continue;
			}
			if (!merge_target_ability_match(provider.key, selected_target_key))
			{
				std::ostringstream failure;
				failure << "RENOVICE ability matcher FAIL ambiguous targets first=0x"
					<< std::hex << selected_target_key << " second=0x"
					<< provider.key << std::dec;
				conout << failure.str() << std::endl;
				config::log(failure.str());
				return 0;
			}
		}
	}
	return selected_target_key;
}

std::uint64_t target_key_for_ability(
	luau_State* state,
	const luau_TValue& ability
)
{
	return target_key_for_matcher(state, ability, "matchesAbility");
}

void log_native_hook_once(
	luau_State* state,
	std::uint64_t target_key,
	const char* event
)
{
	std::ostringstream identity;
	identity << event << ':' << std::hex << target_key << ':'
		<< (state == nullptr ? nullptr : state->global_state);
	{
		std::lock_guard lock(generation_mutex);
		if (!logged_native_hook_events.insert(identity.str()).second) return;
	}
	std::ostringstream success;
	success << "RENOVICE native hook PASS key=" << std::hex << target_key
		<< std::dec << " event=" << event
		<< " vm=" << (state == nullptr ? nullptr : state->global_state);
	conout << success.str() << std::endl;
	config::log(success.str());
}

void dispatch_target_hook(
	luau_State* state,
	std::uint64_t target_key,
	const char* hook_name,
	const luau_TValue* arguments,
	std::size_t argument_count
)
{
	const auto& providers = hook_addons_snapshot(target_key, state->global_state);
	const bool detailed_trace = addon_trace_detail_enabled || full_addon_trace_requested();
	if (detailed_trace) trace_addon(state, target_key, "dispatch.begin",
		std::string("hook=") + hook_name + " providers=" + std::to_string(providers.size()),
		arguments, argument_count);
	for (const auto& addon : providers)
	{
		luau_TValue hook{};
		if (lifecycle_hook_value(state, addon, hook_name, hook))
		{
			std::string label;
			if (detailed_trace)
			{
				label = std::string("hook=") + hook_name + " addon=" + addon.name + " registry=" + addon.registry_key;
				trace_addon(state, target_key, "dispatch.enter", label, arguments, argument_count);
			}
			const bool trace_results = config::flags().diagnostics
				&& std::strcmp(hook_name, "afterDamage") == 0;
			std::string results;
			const bool passed = call_value(
				state, hook, arguments, argument_count, hook_name,
				trace_results ? &results : nullptr);
			if (!passed)
			{
				++addon_dispatch_errors;
				if (label.empty()) label = std::string("hook=") + hook_name + " addon=" + addon.name + " registry=" + addon.registry_key;
			}
			if (passed && trace_results)
			{
				if (label.empty()) label = std::string("hook=") + hook_name + " addon=" + addon.name + " registry=" + addon.registry_key;
				trace_addon(state, target_key, "dispatch.results", label + " " + results);
			}
			if (detailed_trace || !passed)
				trace_addon(state, target_key, passed ? "dispatch.return" : "dispatch.error", label);
			if (passed && detailed_trace)
			{
				log_native_hook_once(state, target_key, hook_name);
			}
		}
		else trace_addon(state, target_key, "dispatch.missing-hook",
			std::string("hook=") + hook_name + " addon=" + addon.name);
	}
	if (detailed_trace) trace_addon(state, target_key, "dispatch.end", std::string("hook=") + hook_name);
}

int target_hook_registry_dispatcher(luau_State* state)
{
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return 0;
	try
	{
		const auto argument_count = state != nullptr && state->intop != nullptr
			? luau_gettop(state) : 0;
		if (argument_count < 2 || state->global_state == nullptr)
		{
			return 0;
		}
		auto key_value = state->intop[0];
		auto hook_value = state->intop[1];
		if (key_value.type == deployed_string_tag) key_value.type = LUAU_STRING;
		if (hook_value.type == deployed_string_tag) hook_value.type = LUAU_STRING;
		if (key_value.type != LUAU_STRING || hook_value.type != LUAU_STRING
			|| key_value.value.as_uintptr == 0 || hook_value.value.as_uintptr == 0)
		{
			return 0;
		}

		const char* const key_text = key_value.getString();
		const char* const hook_name = hook_value.getString();
		if (key_text == nullptr || hook_name == nullptr
			|| std::strlen(key_text) != 16 || std::strlen(hook_name) > 64)
		{
			return 0;
		}
		std::uint64_t target_key = 0;
		if (!replacements::parse_filename_key(key_text, target_key))
		{
			return 0;
		}

		std::vector<luau_TValue> arguments;
		arguments.reserve(static_cast<std::size_t>(argument_count - 2));
		arguments.insert(
			arguments.end(), state->intop + 2, state->intop + argument_count);
		dispatch_target_hook(
			state, target_key, hook_name,
			arguments.empty() ? nullptr : arguments.data(), arguments.size());
	}
	catch (...)
	{
		// Native callbacks must never unwind through DE's VM.
		config::log("RENOVICE target registry dispatcher FAIL reason=native-exception");
	}
	return 0;
}

struct TargetHookRegistryInstallContext
{
	void* target_environment = nullptr;
	bool completed = false;
	bool passed = false;
};
static_assert(std::is_trivially_copyable_v<TargetHookRegistryInstallContext>);

void install_target_hook_registry_dispatcher_leaf(
	luau_State* state, void* raw_context) noexcept
{
	auto* const context = static_cast<TargetHookRegistryInstallContext*>(
		raw_context);
	if (context == nullptr || state == nullptr || state->stack == nullptr
		|| state->stack_last == nullptr || state->outtop == nullptr
		|| state->ci == nullptr || state->ci->top == nullptr
		|| context->target_environment == nullptr || check_stack == nullptr
		|| luau_pushcclosurek == nullptr || wf_hash == nullptr
		|| luau_settable == nullptr)
	{
		if (context != nullptr) context->completed = true;
		return;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (check_stack(state, 6) == 0)
	{
		context->completed = true;
		return;
	}
	auto* base = luau_restorestack(state, base_offset);
	if (!push_environment_table(state, context->target_environment, base))
	{
		context->completed = true;
		return;
	}
	base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 1 || !is_table(base->type))
	{
		context->completed = true;
		return;
	}

	luau_pushcclosurek(
		state, &target_hook_registry_dispatcher,
		"RENOVICE target registry hook dispatcher", 0, nullptr);
	base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 2 || !is_function((base + 1)->type))
	{
		context->completed = true;
		return;
	}
	const auto dispatcher = *(base + 1);
	state->outtop = base + 1;
	luau_TValue key{};
	key.value.as_bool = wf_hash(target_hook_registry_dispatcher_name);
	key.type = LUAU_BOOL;
	if (!append_game_vm_stack_value_reserved(state, key)
		|| !append_game_vm_stack_value_reserved(state, dispatcher))
	{
		context->completed = true;
		return;
	}
	luau_settable(state, -3);

	base = luau_restorestack(state, base_offset);
	state->outtop = base + 1;
	if (!raw_push_hashed_table_field_noexcept(
			state, -1, target_hook_registry_dispatcher_name))
	{
		context->completed = true;
		return;
	}
	base = luau_restorestack(state, base_offset);
	luau_Closure* installed = nullptr;
	context->passed = state->outtop == base + 2
		&& readable_lua_closure(*(base + 1), installed)
		&& installed->isC
		&& installed->c.func == &target_hook_registry_dispatcher;
	context->completed = true;
}

bool install_target_hook_registry_dispatcher(
	luau_State* state,
	void* target_environment,
	std::uint64_t target_key)
{
	TargetHookRegistryInstallContext context{};
	context.target_environment = target_environment;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &install_target_hook_registry_dispatcher_leaf, &context);
	const bool pass = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed && context.passed;
	if (pass)
	{
		log_native_hook_once(
			state, target_key, "target-environment-dispatcher.install");
	}
	return pass;
}

bool publish_ability_card_result(
	luau_State* state,
	const luau_TValue& rows,
	std::uintptr_t& readback_identity
)
{
	readback_identity = 0;
	if (state == nullptr || state->outtop == nullptr || setfield == nullptr
		|| check_stack == nullptr || !is_table(rows.type))
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 4);
	auto* const base = state->outtop;
	if (!push_vm_global(state, "_T") || !is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	push_stack_value(state, rows);
	setfield(state, -2, "AbilityUpgradeLevelInfo");
	state->outtop = base;

	std::uint32_t result_tag = LUAU_NIL;
	luau_TValue readback{};
	if (!read_ability_card_result(
		state, result_tag, readback_identity, readback))
	{
		return false;
	}
	return readback_identity == rows.value.as_uintptr;
}

bool dispatch_ability_card_hooks(
	luau_State* state,
	std::uint64_t target_key,
	const luau_TValue& stock_rows,
	const luau_TValue& query,
	std::uintptr_t& published_identity
)
{
	published_identity = 0;
	luau_TValue staged_rows = stock_rows;
	bool found_provider = false;
	for (const auto& addon : hook_addons_snapshot(target_key, state->global_state))
	{
		luau_TValue hook{};
		if (!lifecycle_hook_value(state, addon, "afterAbilityCard", hook)) continue;
		found_provider = true;
		const luau_TValue arguments[2]{staged_rows, query};
		luau_TValue provider_rows{};
		if (!call_table_value(
			state, hook, arguments, 2, "afterAbilityCard", provider_rows))
		{
			return false;
		}
		staged_rows = provider_rows;
	}
	if (!found_provider) return false;
	if (!publish_ability_card_result(state, staged_rows, published_identity))
	{
		std::ostringstream failure;
		failure << "RENOVICE ability card publish FAIL key=" << std::hex
			<< target_key << std::dec;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}
	log_native_hook_once(state, target_key, "afterAbilityCard.publish");
	return true;
}

bool target_hook_available(
	luau_State* state,
	std::uint64_t target_key,
	const char* hook_name
)
{
	for (const auto& addon : hook_addons_snapshot(target_key, state->global_state))
	{
		luau_TValue hook{};
		if (lifecycle_hook_value(state, addon, hook_name, hook)) return true;
	}
	return false;
}

bool push_environment_table(
	luau_State* state,
	void* environment,
	luau_TValue* destination
)
{
	if (state == nullptr || environment == nullptr || destination == nullptr
		|| diagnostics::bad_read_ptr(environment, sizeof(std::uint8_t)))
	{
		return false;
	}
	const auto tag = static_cast<int>(*reinterpret_cast<std::uint8_t*>(environment));
	if (!is_table(tag)) return false;
	prepare_stack_write(state);
	destination->value.as_uintptr = reinterpret_cast<std::uintptr_t>(environment);
	destination->type = static_cast<std::uint32_t>(tag);
	state->outtop = destination + 1;
	return true;
}

bool read_diagnostic_trace_registry_root(
	luau_State* state,
	luau_TValue& output
)
{
	output = {};
	output.type = LUAU_NIL;
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| check_stack == nullptr)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 1);
	getfield(state, -10000, diagnostic_trace_registry_key.c_str());
	auto* const base = luau_restorestack(state, base_offset);
	luau_Closure* root = nullptr;
	const bool owned = readable_lua_closure(*base, root)
		&& root->isC && root->c.func == &diagnostic_trace_bridge;
	if (owned) output = *base;
	state->outtop = base;
	return owned;
}

bool write_diagnostic_trace_registry_root(
	luau_State* state,
	const luau_TValue& value
)
{
	luau_Closure* value_closure = nullptr;
	if (state == nullptr || state->outtop == nullptr || setfield == nullptr
		|| getfield == nullptr || check_stack == nullptr
		|| !readable_lua_closure(value, value_closure)
		|| !value_closure->isC
		|| value_closure->c.func != &diagnostic_trace_bridge)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 1);
	auto* base = luau_restorestack(state, base_offset);
	prepare_stack_write(state);
	*base = value;
	state->outtop = base + 1;
	setfield(state, -10000, diagnostic_trace_registry_key.c_str());
	state->outtop = base;
	getfield(state, -10000, diagnostic_trace_registry_key.c_str());
	base = luau_restorestack(state, base_offset);
	luau_Closure* readback = nullptr;
	const bool rooted = readable_lua_closure(*base, readback)
		&& readback == value_closure && readback->isC
		&& readback->c.func == &diagnostic_trace_bridge;
	state->outtop = base;
	return rooted;
}

bool clear_diagnostic_trace_registry_root(luau_State* state)
{
	if (state == nullptr || state->outtop == nullptr || setfield == nullptr
		|| getfield == nullptr || check_stack == nullptr)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 1);
	auto* base = luau_restorestack(state, base_offset);
	base->value.as_uintptr = 0;
	base->type = LUAU_NIL;
	state->outtop = base + 1;
	setfield(state, -10000, diagnostic_trace_registry_key.c_str());
	state->outtop = base;
	getfield(state, -10000, diagnostic_trace_registry_key.c_str());
	base = luau_restorestack(state, base_offset);
	const bool cleared = base->type == LUAU_NIL;
	state->outtop = base;
	return cleared;
}

bool ensure_diagnostic_trace_registry_root(luau_State* state)
{
	luau_TValue existing{};
	if (read_diagnostic_trace_registry_root(state, existing)) return true;
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| luau_pushcclosurek == nullptr)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	luau_pushcclosurek(
		state, &diagnostic_trace_bridge,
		"RENOVICE automatic damage trace", 0, nullptr);
	auto* const base = luau_restorestack(state, base_offset);
	const auto value = *base;
	const bool rooted = write_diagnostic_trace_registry_root(state, value);
	state->outtop = base;
	return rooted;
}

bool ui_leaf_write_registry_value(
	luau_State* state,
	const char* key,
	luau_TValue value
) noexcept
{
	if (state == nullptr || state->outtop == nullptr || key == nullptr
		|| setfield == nullptr || getfield == nullptr)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!append_game_vm_stack_value_reserved(state, value)) return false;
	setfield(state, -10000, key);
	state->outtop = luau_restorestack(state, base_offset);
	getfield(state, -10000, key);
	auto* const base = luau_restorestack(state, base_offset);
	const bool exact = state->outtop == base + 1
		&& base->type == value.type
		&& (value.type == LUAU_NIL
			|| base->value.as_uintptr == value.value.as_uintptr);
	state->outtop = base;
	return exact;
}

enum class SharedTableLeafFailure : std::uint8_t
{
	none,
	prerequisite,
	stack_capacity,
	shared_global_lookup,
	shared_global_not_table,
	diagnostic_registry_root,
	shared_field_collision,
	diagnostic_prerequisite,
	shared_field_remove,
	shared_field_remove_readback,
	readback_mismatch,
};

struct SharedTableLeafContext
{
	const char* registry_key = nullptr;
	bool diagnostics_enabled = false;
	bool preserve_owned_bridge = false;
	bool registry_root_required = false;
	bool completed = false;
	bool passed = false;
	bool bridge_removed = false;
	bool bridge_installed = false;
	std::uintptr_t shared_table_identity = 0;
	DiagnosticBridgeAction action = DiagnosticBridgeAction::leave_absent;
	SharedTableLeafFailure failure = SharedTableLeafFailure::none;
};
static_assert(std::is_trivially_copyable_v<SharedTableLeafContext>);

// BEGIN TARGET_SHARED_TABLE_PROTECTED_LEAF
void prepare_target_shared_table_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<SharedTableLeafContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| context->registry_key == nullptr || check_stack == nullptr
		|| getfield == nullptr || setfield == nullptr)
	{
		if (context != nullptr)
		{
			context->failure = SharedTableLeafFailure::prerequisite;
			context->completed = true;
		}
		return;
	}
	if (check_stack(state, 8) == 0)
	{
		context->failure = SharedTableLeafFailure::stack_capacity;
		context->completed = true;
		return;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!ui_leaf_push_vm_global(state, "_T"))
	{
		context->failure = SharedTableLeafFailure::shared_global_lookup;
		context->completed = true;
		return;
	}
	auto* base = luau_restorestack(state, base_offset);
	if (!is_table(base->type))
	{
		context->failure = SharedTableLeafFailure::shared_global_not_table;
		context->completed = true;
		return;
	}
	context->shared_table_identity = base->value.as_uintptr;
	getfield(state, -1, "RENOVICE_TRACE");
	base = luau_restorestack(state, base_offset);
	const auto existing_value = *(base + 1);
	luau_Closure* existing = nullptr;
	const bool field_present = existing_value.type != LUAU_NIL;
	const bool field_owned = field_present
		&& readable_lua_closure(existing_value, existing)
		&& existing->isC && existing->c.func == &diagnostic_trace_bridge;
	const bool can_mutate = setfield != nullptr
		&& (!context->diagnostics_enabled || luau_pushcclosurek != nullptr);
	context->action = classify_diagnostic_bridge_action(
		context->diagnostics_enabled, field_present, field_owned, can_mutate);

	luau_TValue nil{};
	nil.type = LUAU_NIL;
	if (context->action == DiagnosticBridgeAction::leave_absent
		|| context->action == DiagnosticBridgeAction::leave_foreign_disabled)
	{
		if (!context->registry_root_required
			&& !ui_leaf_write_registry_value(
				state, context->registry_key, nil))
		{
			context->failure = SharedTableLeafFailure::diagnostic_registry_root;
			context->completed = true;
			return;
		}
		context->passed = true;
		context->completed = true;
		return;
	}
	if (context->action == DiagnosticBridgeAction::keep_owned)
	{
		context->passed = ui_leaf_write_registry_value(
			state, context->registry_key, existing_value);
		if (!context->passed)
			context->failure = SharedTableLeafFailure::diagnostic_registry_root;
		context->completed = true;
		return;
	}
	if (context->action == DiagnosticBridgeAction::reject_collision
		|| context->action == DiagnosticBridgeAction::reject_prerequisite)
	{
		if (!context->registry_root_required)
			(void)ui_leaf_write_registry_value(
				state, context->registry_key, nil);
		context->failure = context->action
			== DiagnosticBridgeAction::reject_collision
			? SharedTableLeafFailure::shared_field_collision
			: SharedTableLeafFailure::diagnostic_prerequisite;
		context->completed = true;
		return;
	}
	if (context->action == DiagnosticBridgeAction::remove_owned)
	{
		if (context->preserve_owned_bridge)
		{
			context->passed = true;
			context->completed = true;
			return;
		}
		if (!context->registry_root_required
			&& !ui_leaf_write_registry_value(
				state, context->registry_key, nil))
		{
			context->failure = SharedTableLeafFailure::diagnostic_registry_root;
			context->completed = true;
			return;
		}
		base = luau_restorestack(state, base_offset);
		state->outtop = base + 1;
		if (!append_game_vm_stack_value_reserved(state, nil))
		{
			context->failure = SharedTableLeafFailure::shared_field_remove;
			context->completed = true;
			return;
		}
		setfield(state, -2, "RENOVICE_TRACE");
		state->outtop = base + 1;
		getfield(state, -1, "RENOVICE_TRACE");
		base = luau_restorestack(state, base_offset);
		if ((base + 1)->type != LUAU_NIL)
		{
			context->failure = SharedTableLeafFailure::shared_field_remove_readback;
			context->completed = true;
			return;
		}
		context->bridge_removed = true;
		context->passed = true;
		context->completed = true;
		return;
	}

	base = luau_restorestack(state, base_offset);
	state->outtop = base + 1;
	luau_pushcclosurek(
		state, &diagnostic_trace_bridge,
		"RENOVICE exact-pipeline trace", 0, nullptr);
	setfield(state, -2, "RENOVICE_TRACE");
	state->outtop = base + 1;
	getfield(state, -1, "RENOVICE_TRACE");
	base = luau_restorestack(state, base_offset);
	luau_Closure* installed = nullptr;
	const bool installed_exact = readable_lua_closure(*(base + 1), installed)
		&& installed->isC && installed->c.func == &diagnostic_trace_bridge;
	const auto installed_value = *(base + 1);
	if (!installed_exact)
	{
		context->failure = SharedTableLeafFailure::readback_mismatch;
		context->completed = true;
		return;
	}
	if (!ui_leaf_write_registry_value(
		state, context->registry_key, installed_value))
	{
		base = luau_restorestack(state, base_offset);
		state->outtop = base + 1;
		if (append_game_vm_stack_value_reserved(state, nil))
			setfield(state, -2, "RENOVICE_TRACE");
		context->failure = SharedTableLeafFailure::diagnostic_registry_root;
		context->completed = true;
		return;
	}
	context->bridge_installed = true;
	context->passed = true;
	context->completed = true;
}
// END TARGET_SHARED_TABLE_PROTECTED_LEAF

bool prepare_target_shared_table(
	std::uint64_t target_key,
	luau_State* state,
	void* environment,
	std::uintptr_t& shared_table_identity,
	bool bridge_allowed = true,
	bool global_bridge_reconciliation = false
)
{
	shared_table_identity = 0;
	const auto diagnostic_flags = config::flags();
	const bool selected_for_this_target = diagnostic_trace_selected(
		diagnostic_flags, target_key, "target.trace.bridge", {});
	const bool diagnostics_enabled = bridge_allowed
		&& diagnostic_bridge_may_format(diagnostic_flags.diagnostics_mode)
		&& selected_for_this_target
		&& diagnostic_flags.diagnostics_method.empty()
		&& diagnostic_flags.diagnostics_addon.empty();
	const bool preserve_owned_bridge =
		preserve_owned_diagnostic_bridge_for_other_target(
			diagnostic_flags, bridge_allowed, selected_for_this_target,
			global_bridge_reconciliation);
	const bool registry_root_required =
		diagnostic_bridge_registry_root_required(
			diagnostics_enabled, preserve_owned_bridge,
			universal_observer_requested(diagnostic_flags));
	const auto reject_once = [](const char* reason)
	{
		if (!diagnostic_trace_install_failure_logged.exchange(
			true, std::memory_order_relaxed))
		{
			std::string failure = "RENOVICE target shared table FAIL reason=";
			failure += reason;
			conout << failure << std::endl;
			config::diagnostic_log(failure, config::DiagnosticsMode::errors);
		}
		return false;
	};
	if (target_key == 0 || state == nullptr || state->outtop == nullptr
		|| getfield == nullptr || check_stack == nullptr)
	{
		return reject_once("prerequisite-unavailable");
	}

	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	SharedTableLeafContext context{};
	context.registry_key = diagnostic_trace_registry_key.c_str();
	context.diagnostics_enabled = diagnostics_enabled;
	context.preserve_owned_bridge = preserve_owned_bridge;
	context.registry_root_required = registry_root_required;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &prepare_target_shared_table_protected_leaf, &context);
	shared_table_identity = context.shared_table_identity;
	const bool passed = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed && context.passed;
	if (!passed)
	{
		const char* reason = "raw-protection";
		switch (context.failure)
		{
		case SharedTableLeafFailure::prerequisite:
			reason = "prerequisite-unavailable"; break;
		case SharedTableLeafFailure::stack_capacity:
			reason = "stack-capacity-unavailable"; break;
		case SharedTableLeafFailure::shared_global_lookup:
			reason = "shared-global-lookup-failed"; break;
		case SharedTableLeafFailure::shared_global_not_table:
			reason = "shared-global-not-table"; break;
		case SharedTableLeafFailure::diagnostic_registry_root:
			reason = "diagnostic-registry-root-failed"; break;
		case SharedTableLeafFailure::shared_field_collision:
			reason = "shared-field-collision"; break;
		case SharedTableLeafFailure::diagnostic_prerequisite:
			reason = "diagnostic-prerequisite-unavailable"; break;
		case SharedTableLeafFailure::shared_field_remove:
			reason = "shared-field-remove-failed"; break;
		case SharedTableLeafFailure::shared_field_remove_readback:
			reason = "shared-field-remove-readback-mismatch"; break;
		case SharedTableLeafFailure::readback_mismatch:
			reason = "readback-mismatch"; break;
		case SharedTableLeafFailure::none:
			break;
		}
		return reject_once(reason);
	}
	if (context.bridge_removed)
	{
		diagnostic_trace_sequence.store(0, std::memory_order_relaxed);
		diagnostic_trace_suppression_logged.store(false, std::memory_order_relaxed);
		diagnostic_trace_install_failure_logged.store(false, std::memory_order_relaxed);
		diagnostic_trace_callback_failure_logged.store(false, std::memory_order_relaxed);
		addon_trace_sequence.store(0, std::memory_order_relaxed);
		addon_trace_suppression_logged.store(false, std::memory_order_relaxed);
		native_ingress_trace_sequence.store(0, std::memory_order_relaxed);
		native_ingress_trace_suppression_logged.store(false, std::memory_order_relaxed);
		automatic_damage_sequence.store(0, std::memory_order_relaxed);
		automatic_damage_budget_suppression_logged.store(
			false, std::memory_order_relaxed);
		automatic_damage_duplicate_suppression_logged.store(
			false, std::memory_order_relaxed);
		automatic_damage_runtime_failure_logged.store(
			false, std::memory_order_relaxed);
		config::diagnostic_log(
			"RENOVICE trace bridge removed", config::DiagnosticsMode::trace);
		return true;
	}
	if (context.bridge_installed)
	{
		diagnostic_trace_sequence.store(0, std::memory_order_relaxed);
		diagnostic_trace_suppression_logged.store(false, std::memory_order_relaxed);
		diagnostic_trace_install_failure_logged.store(false, std::memory_order_relaxed);
		diagnostic_trace_callback_failure_logged.store(false, std::memory_order_relaxed);
		addon_trace_sequence.store(0, std::memory_order_relaxed);
		addon_trace_suppression_logged.store(false, std::memory_order_relaxed);
		native_ingress_trace_sequence.store(0, std::memory_order_relaxed);
		native_ingress_trace_suppression_logged.store(false, std::memory_order_relaxed);
		std::ostringstream success;
		success << "RENOVICE trace bridge PASS key=" << std::hex << target_key
			<< std::dec << " vm=" << state->global_state
			<< " env=" << environment
			<< " shared=0x" << std::hex << shared_table_identity << std::dec;
		config::diagnostic_log(success.str(), config::DiagnosticsMode::trace);
	}
	return true;
}

struct InspectSharedTableContext
{
	bool inspect_scripts_bridge = false;
	bool completed = false;
	bool passed = false;
	bool scripts_bridge_present = false;
	std::uintptr_t shared_table_identity = 0;
};
static_assert(std::is_trivially_copyable_v<InspectSharedTableContext>);

// BEGIN INSPECT_SHARED_TABLE_PROTECTED_LEAF
void inspect_current_shared_table_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<InspectSharedTableContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| check_stack == nullptr)
	{
		if (context != nullptr) context->completed = true;
		return;
	}
	if (check_stack(state, 4) == 0)
	{
		context->completed = true;
		return;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!ui_leaf_push_vm_global(state, "_T"))
	{
		context->completed = true;
		return;
	}
	auto* base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 1 || !is_table(base->type))
	{
		context->completed = true;
		return;
	}
	context->shared_table_identity = base->value.as_uintptr;
	if (context->inspect_scripts_bridge)
	{
		context->scripts_bridge_present = ui_leaf_push_hashed_table_field(
			state, -1, scripts_settings_bridge_name)
			&& state->outtop == base + 2 && is_function((base + 1)->type);
	}
	context->passed = context->shared_table_identity != 0;
	context->completed = true;
}
// END INSPECT_SHARED_TABLE_PROTECTED_LEAF

bool inspect_current_shared_table(
	luau_State* state,
	std::uintptr_t& shared_table_identity,
	bool& scripts_bridge_present
)
{
	shared_table_identity = 0;
	scripts_bridge_present = false;
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr)
	{
		return false;
	}

	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	InspectSharedTableContext context{};
	context.inspect_scripts_bridge = scripts_ui_enabled.load(
		std::memory_order_acquire);
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &inspect_current_shared_table_protected_leaf, &context);
	const bool passed = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed && context.passed;
	if (!passed) return false;
	shared_table_identity = context.shared_table_identity;
	scripts_bridge_present = context.scripts_bridge_present;
	return true;
}

struct TargetCardReadContext
{
	luau_TValue original{};
	luau_TValue arguments[2]{};
	bool succeeded = false;
};
static_assert(std::is_trivially_copyable_v<TargetCardReadContext>);

void read_target_card_values_leaf(luau_State* state, void* raw_context)
{
	auto* const context = static_cast<TargetCardReadContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| getfield == nullptr) return;
	luau_Closure* original_closure = nullptr;
	if (!readable_lua_closure(context->original, original_closure)
		|| original_closure->isC || original_closure->env == nullptr
		|| diagnostics::bad_read_ptr(
			original_closure->env, sizeof(std::uint8_t)))
	{
		return;
	}
	auto* const base = state->outtop;
	luau_TValue environment{};
	environment.value.as_uintptr = reinterpret_cast<std::uintptr_t>(
		original_closure->env);
	environment.type = static_cast<std::uint32_t>(
		*reinterpret_cast<const std::uint8_t*>(original_closure->env));
	if (!is_table(environment.type)
		|| !append_game_vm_stack_value(state, environment)) return;
	getfield(state, -1, "_T");
	if (!is_table((base + 1)->type))
	{
		return;
	}
	getfield(state, -1, "AbilityUpgradeLevelInfo");
	if (!is_table((base + 2)->type))
	{
		return;
	}
	context->arguments[0] = *(base + 2);
	state->outtop = base + 2;
	getfield(state, -1, "AbilityLevelQueryParms");
	context->arguments[1] = *(base + 2);
	context->succeeded = is_table(context->arguments[1].type);
}

int ability_card_wrapper(luau_State* state)
{
	const auto* wrapper = state != nullptr && state->ci != nullptr
		&& state->ci->func != nullptr && is_function(state->ci->func->type)
		? reinterpret_cast<const luau_Closure*>(state->ci->func->value.as_uintptr)
		: nullptr;
	if (wrapper == nullptr || !wrapper->isC || wrapper->nupvalues < 2)
	{
		return 0;
	}
	const auto original = dereference_upvalue(wrapper->c.upvals[0]);
	const auto target_key = static_cast<std::uint64_t>(
		wrapper->c.upvals[1].value.as_uintptr);
	const int argument_count = luau_gettop(state);
	std::vector<luau_TValue> arguments(
		state->intop, state->intop + argument_count);
	if (!call_value(
		state, original, arguments.data(), arguments.size(),
		"original.GetAbilityUpgradeLevelInfo"))
	{
		return 0;
	}
	// The stock call and argument vector are complete before the generation
	// lease is acquired. Read the two card tables in a destructor-free protected
	// leaf so a DE field/metamethod error cannot strand the lease.
	TargetCardReadContext card_read{};
	card_read.original = original;
	const auto protected_read = de_vm_authority::run_current_vm_protected(
		state, &read_target_card_values_leaf, &card_read);
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (generation_dispatch && protected_read.admitted
		&& protected_read.restored && protected_read.status == 0
		&& card_read.succeeded)
	{
		dispatch_target_hook(
			state, target_key, "afterAbilityCard", card_read.arguments, 2);
	}
	return 0;
}

bool same_lua_value(const luau_TValue& lhs, const luau_TValue& rhs) noexcept;

enum class CallbackRuntimeLeafStage : std::uint8_t
{
	none,
	reserve_stack,
	lookup_runtime,
	lookup_method,
	push_argument,
	invoke_method,
	root_result,
	read_root,
	create_native_setter,
	invoke_native_setter,
	clear_root,
};

struct CallbackRuntimeResultRoot
{
	bool active = false;
	luau_State* state = nullptr;
	void* global_state = nullptr;
	std::uint32_t owner_thread = 0;
	std::uint64_t token = 0;
	luau_TValue value{};
	char registry_key[96]{};
};
static_assert(std::is_trivially_copyable_v<CallbackRuntimeResultRoot>);

struct CallbackRuntimeLeafContext
{
	const char* runtime_registry_key = nullptr;
	const char* method = nullptr;
	const char* result_root_key = nullptr;
	luau_TValue arguments[2]{};
	luau_TValue result{};
	SharedCallbackLeafContext callback{};
	std::size_t actual_result_count = 0;
	CallbackRuntimeLeafStage stage = CallbackRuntimeLeafStage::none;
	bool runtime_present = false;
	bool method_present = false;
	bool result_present = false;
	bool root_may_be_installed = false;
	bool root_installed = false;
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<CallbackRuntimeLeafContext>);

struct CallbackRuntimeRootClearContext
{
	const char* registry_key = nullptr;
	bool cleared = false;
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<CallbackRuntimeRootClearContext>);

struct DamageCallbackInstallLeafContext
{
	luau_CFunction native = nullptr;
	const char* result_root_key = nullptr;
	luau_TValue receiver{};
	luau_TValue expected_callback{};
	SharedCallbackLeafContext callback{};
	CallbackRuntimeLeafStage stage = CallbackRuntimeLeafStage::none;
	bool root_present = false;
	bool root_cleared = false;
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<DamageCallbackInstallLeafContext>);

std::atomic<std::uint64_t> callback_runtime_root_sequence{0};
thread_local CallbackRuntimeResultRoot pending_callback_runtime_result_root;

// BEGIN CALLBACK_RUNTIME_PROTECTED_LEAF
// Callback-runtime lookup, Lua closure creation, registry rooting, native C
// closure allocation, and both protected calls are all DE operations. Keep the
// complete mutation path below one of these POD-only raw leaves.
bool callback_runtime_leaf_reserve(luau_State* state, std::size_t slots)
{
	if (state == nullptr || state->stack == nullptr || state->stack_last == nullptr
		|| state->outtop == nullptr || state->ci == nullptr
		|| state->ci->top == nullptr || check_stack == nullptr
		|| slots > static_cast<std::size_t>((std::numeric_limits<int>::max)())
		|| check_stack(state, static_cast<int>(slots)) == 0
		|| state->outtop < state->stack || state->outtop > state->stack_last
		|| state->ci->top < state->outtop || state->ci->top > state->stack_last)
	{
		return false;
	}
	return slots <= static_cast<std::size_t>(state->stack_last - state->outtop)
		&& slots <= static_cast<std::size_t>(state->ci->top - state->outtop);
}

bool callback_runtime_leaf_clear_root(luau_State* state, const char* key)
{
	if (state == nullptr || key == nullptr || *key == '\0' || setfield == nullptr
		|| getfield == nullptr || !callback_runtime_leaf_reserve(state, 2))
	{
		return false;
	}
	const auto saved_top = luau_savestack(state, state->outtop);
	luau_TValue nil{};
	nil.type = LUAU_NIL;
	if (!shared_callback_leaf_push_value(state, nil)) return false;
	setfield(state, -10000, key);
	state->outtop = luau_restorestack(state, saved_top);
	getfield(state, -10000, key);
	auto* const base = luau_restorestack(state, saved_top);
	const bool cleared = state->outtop == base + 1 && base->type == LUAU_NIL;
	state->outtop = base;
	return cleared;
}

void callback_runtime_root_clear_protected_leaf(luau_State* state, void* opaque)
{
	auto* const context = static_cast<CallbackRuntimeRootClearContext*>(opaque);
	if (context == nullptr || context->registry_key == nullptr) return;
	context->cleared = callback_runtime_leaf_clear_root(
		state, context->registry_key);
	context->completed = true;
}

void callback_runtime_protected_leaf(luau_State* state, void* opaque)
{
	auto* const context = static_cast<CallbackRuntimeLeafContext*>(opaque);
	if (state == nullptr || context == nullptr || context->runtime_registry_key == nullptr
		|| context->method == nullptr || getfield == nullptr || setfield == nullptr
		|| protected_call == nullptr || gc_barrierback == nullptr)
	{
		return;
	}
	context->stage = CallbackRuntimeLeafStage::reserve_stack;
	if (!callback_runtime_leaf_reserve(state, 10)) return;
	const auto base_offset = luau_savestack(state, state->outtop);

	context->stage = CallbackRuntimeLeafStage::lookup_runtime;
	getfield(state, -10000, context->runtime_registry_key);
	auto* base = luau_restorestack(state, base_offset);
	context->runtime_present = state->outtop == base + 1 && is_table(base->type);
	if (!context->runtime_present)
	{
		context->completed = true;
		return;
	}

	context->stage = CallbackRuntimeLeafStage::lookup_method;
	getfield(state, -1, context->method);
	base = luau_restorestack(state, base_offset);
	context->method_present = state->outtop == base + 2
		&& is_function((base + 1)->type);
	if (!context->method_present)
	{
		context->completed = true;
		return;
	}

	context->stage = CallbackRuntimeLeafStage::push_argument;
	if (!shared_callback_leaf_push_value(state, context->arguments[0])
		|| !shared_callback_leaf_push_value(state, context->arguments[1]))
	{
		return;
	}
	context->stage = CallbackRuntimeLeafStage::invoke_method;
	context->callback.callback_status = protected_call(state, 2, 1, 0);
	base = luau_restorestack(state, base_offset);
	if (context->callback.callback_status != 0)
	{
		context->callback.stage = SharedCallbackLeafStage::capture_error;
		shared_callback_leaf_capture_error(
			state, base_offset + static_cast<std::ptrdiff_t>(sizeof(luau_TValue)),
			&context->callback);
		context->callback.completed = true;
		context->completed = true;
		return;
	}
	if (state->outtop == nullptr || state->outtop < base
		|| state->outtop > state->stack_last)
	{
		return;
	}
	context->actual_result_count = static_cast<std::size_t>(state->outtop - base);
	context->result_present = context->actual_result_count == 2;
	if (!context->result_present)
	{
		context->completed = true;
		return;
	}
	context->result = base[1];
	context->callback.results[0] = context->result;
	context->callback.actual_result_count = 1;
	context->callback.copied_result_count = 1;
	context->callback.completed = true;

	if (context->result_root_key != nullptr && *context->result_root_key != '\0')
	{
		context->stage = CallbackRuntimeLeafStage::root_result;
		if (!shared_callback_leaf_push_value(state, context->result)) return;
		context->root_may_be_installed = true;
		setfield(state, -10000, context->result_root_key);
		base = luau_restorestack(state, base_offset);
		state->outtop = base + 2;
		context->stage = CallbackRuntimeLeafStage::read_root;
		getfield(state, -10000, context->result_root_key);
		base = luau_restorestack(state, base_offset);
		context->root_installed = state->outtop == base + 3
			&& same_lua_value(base[2], context->result);
		state->outtop = base + 2;
		if (!context->root_installed) return;
	}
	context->completed = true;
}

void damage_callback_install_protected_leaf(luau_State* state, void* opaque)
{
	auto* const context = static_cast<DamageCallbackInstallLeafContext*>(opaque);
	if (state == nullptr || context == nullptr || context->native == nullptr
		|| context->result_root_key == nullptr || *context->result_root_key == '\0'
		|| getfield == nullptr || setfield == nullptr || luau_pushcclosurek == nullptr
		|| protected_call == nullptr || gc_barrierback == nullptr)
	{
		return;
	}
	context->stage = CallbackRuntimeLeafStage::reserve_stack;
	if (!callback_runtime_leaf_reserve(state, 10)) return;
	const auto base_offset = luau_savestack(state, state->outtop);
	context->stage = CallbackRuntimeLeafStage::read_root;
	getfield(state, -10000, context->result_root_key);
	auto* base = luau_restorestack(state, base_offset);
	context->root_present = state->outtop == base + 1
		&& same_lua_value(*base, context->expected_callback);
	if (!context->root_present)
	{
		context->stage = CallbackRuntimeLeafStage::clear_root;
		context->root_cleared = callback_runtime_leaf_clear_root(
			state, context->result_root_key);
		context->completed = true;
		return;
	}

	context->stage = CallbackRuntimeLeafStage::create_native_setter;
	luau_pushcclosurek(
		state, context->native, "RENOVICE protected SetDamageCallback", 0, nullptr);
	base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 2 || !is_function((base + 1)->type)) return;
	if (!shared_callback_leaf_push_value(state, context->receiver)
		|| !shared_callback_leaf_push_value(state, *base))
	{
		return;
	}
	context->stage = CallbackRuntimeLeafStage::invoke_native_setter;
	context->callback.callback_status = protected_call(state, 2, 0, 0);
	base = luau_restorestack(state, base_offset);
	if (context->callback.callback_status != 0)
	{
		context->callback.stage = SharedCallbackLeafStage::capture_error;
		shared_callback_leaf_capture_error(
			state, base_offset + static_cast<std::ptrdiff_t>(sizeof(luau_TValue)),
			&context->callback);
	}
	context->callback.completed = true;
	context->stage = CallbackRuntimeLeafStage::clear_root;
	context->root_cleared = callback_runtime_leaf_clear_root(
		state, context->result_root_key);
	context->completed = true;
}
// END CALLBACK_RUNTIME_PROTECTED_LEAF

const char* callback_runtime_leaf_stage_label(CallbackRuntimeLeafStage stage) noexcept
{
	switch (stage)
	{
	case CallbackRuntimeLeafStage::none: return "none";
	case CallbackRuntimeLeafStage::reserve_stack: return "reserve-stack";
	case CallbackRuntimeLeafStage::lookup_runtime: return "lookup-runtime";
	case CallbackRuntimeLeafStage::lookup_method: return "lookup-method";
	case CallbackRuntimeLeafStage::push_argument: return "push-argument";
	case CallbackRuntimeLeafStage::invoke_method: return "invoke-method";
	case CallbackRuntimeLeafStage::root_result: return "root-result";
	case CallbackRuntimeLeafStage::read_root: return "read-root";
	case CallbackRuntimeLeafStage::create_native_setter: return "create-native-setter";
	case CallbackRuntimeLeafStage::invoke_native_setter: return "invoke-native-setter";
	case CallbackRuntimeLeafStage::clear_root: return "clear-root";
	}
	return "unknown";
}

bool initialize_callback_runtime_result_root(
	luau_State* state,
	CallbackRuntimeResultRoot& root) noexcept
{
	root = {};
	if (state == nullptr || state->global_state == nullptr) return false;
	auto token = callback_runtime_root_sequence.fetch_add(
		1, std::memory_order_relaxed) + 1;
	if (token == 0)
		token = callback_runtime_root_sequence.fetch_add(
			1, std::memory_order_relaxed) + 1;
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	const int written = std::snprintf(
		root.registry_key, sizeof(root.registry_key),
		"RENOVICE.callback-result.v109.%08x.%016llx",
		static_cast<unsigned>(owner_thread),
		static_cast<unsigned long long>(token));
	if (written <= 0 || static_cast<std::size_t>(written) >= sizeof(root.registry_key))
	{
		root = {};
		return false;
	}
	root.state = state;
	root.global_state = state->global_state;
	root.owner_thread = owner_thread;
	root.token = token;
	return true;
}

bool clear_callback_runtime_result_root(
	luau_State* state,
	CallbackRuntimeResultRoot& root) noexcept
{
	if (!root.active) return true;
	if (state == nullptr || root.state != state
		|| root.global_state != state->global_state
		|| root.owner_thread != static_cast<std::uint32_t>(GetCurrentThreadId())
		|| root.registry_key[0] == '\0')
	{
		return false;
	}
	CallbackRuntimeRootClearContext context;
	context.registry_key = root.registry_key;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &callback_runtime_root_clear_protected_leaf, &context);
	const bool cleared = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed && context.cleared;
	if (cleared) root = {};
	return cleared;
}

bool clear_or_defer_callback_runtime_result_root(
	luau_State* state,
	CallbackRuntimeResultRoot& root) noexcept
{
	if (!root.active || clear_callback_runtime_result_root(state, root)) return true;
	if (!pending_callback_runtime_result_root.active)
	{
		pending_callback_runtime_result_root = root;
		root = {};
	}
	config::diagnostic_log(
		"RENOVICE callback runtime root clear deferred until exact idle",
		config::DiagnosticsMode::errors);
	return false;
}

bool clear_pending_callback_runtime_result_root(luau_State* state) noexcept
{
	return !pending_callback_runtime_result_root.active
		|| clear_callback_runtime_result_root(
			state, pending_callback_runtime_result_root);
}

void clear_callback_runtime_result_root_at_exact_idle(luau_State* state) noexcept
{
	if (state != nullptr && pending_callback_runtime_result_root.active
		&& pending_callback_runtime_result_root.state == state
		&& pending_callback_runtime_result_root.global_state == state->global_state
		&& pending_callback_runtime_result_root.owner_thread
			== static_cast<std::uint32_t>(GetCurrentThreadId()))
	{
		clear_pending_callback_runtime_result_root(state);
	}
}

bool call_callback_runtime(
	luau_State* state,
	std::uint64_t key,
	const char* method,
	const luau_TValue (&arguments)[2],
	luau_TValue& result,
	CallbackRuntimeResultRoot* result_root = nullptr)
{
	result = {};
	if (state == nullptr || state->outtop == nullptr || method == nullptr
		|| !clear_pending_callback_runtime_result_root(state))
	{
		return false;
	}
	CallbackRuntimeResultRoot staged_root;
	if (result_root != nullptr
		&& !initialize_callback_runtime_result_root(state, staged_root))
	{
		return false;
	}
	CallbackRuntimeLeafContext context;
	context.runtime_registry_key = callback_runtime_registry_key.c_str();
	context.method = method;
	context.result_root_key = result_root != nullptr
		? staged_root.registry_key : nullptr;
	context.arguments[0] = arguments[0];
	context.arguments[1] = arguments[1];
	const auto memory = capture_shared_callback_memory(state);
	ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &callback_runtime_protected_leaf, &context);
	report_shared_callback_memory(state, "DamageData.copy", memory);

	if (result_root != nullptr && context.root_may_be_installed)
	{
		staged_root.active = true;
		staged_root.value = context.result;
	}
	const bool transport_ok = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed;
	if (!transport_ok)
	{
		std::ostringstream detail;
		detail << "method=" << method
			<< " admitted=" << protected_result.admitted
			<< " restored=" << protected_result.restored
			<< " raw_status=" << protected_result.status
			<< " stage=" << callback_runtime_leaf_stage_label(context.stage);
		trace_addon(state, key, "damage.factory.error", detail.str());
		clear_or_defer_callback_runtime_result_root(state, staged_root);
		return false;
	}
	if (!context.runtime_present)
	{
		trace_addon(state, key, "damage.factory.reject", "reason=runtime-not-loaded");
		return false;
	}
	if (!context.method_present)
	{
		trace_addon(state, key, "damage.factory.reject", "reason=missing-method");
		return false;
	}
	if (context.callback.callback_status != 0)
	{
		SharedCallbackOutcome outcome;
		outcome.leaf = context.callback;
		trace_addon(state, key, "damage.factory.error", std::string("method=") + method
			+ " pcall=" + std::to_string(context.callback.callback_status)
			+ shared_callback_error_details(outcome));
		clear_or_defer_callback_runtime_result_root(state, staged_root);
		return false;
	}
	if (!context.result_present
		|| (result_root != nullptr && !context.root_installed))
	{
		trace_addon(state, key, "damage.factory.reject", "reason=result-count-or-root");
		clear_or_defer_callback_runtime_result_root(state, staged_root);
		return false;
	}
	result = context.result;
	if (result_root != nullptr) *result_root = staged_root;
	trace_addon(state, key, "damage.factory.return", std::string("method=") + method);
	return true;
}

bool set_damage_callback_protected(
	luau_State* state,
	std::uint64_t key,
	const luau_TValue& receiver,
	const luau_TValue& callback,
	CallbackRuntimeResultRoot& result_root)
{
	luau_Closure* closure = nullptr;
	if (!result_root.active || result_root.state != state
		|| result_root.global_state != (state != nullptr ? state->global_state : nullptr)
		|| !same_lua_value(result_root.value, callback)
		|| !readable_lua_closure(callback, closure) || closure->isC)
	{
		trace_addon(state, key, "damage.install.reject", "reason=callback-not-rooted-lua");
		clear_or_defer_callback_runtime_result_root(state, result_root);
		return false;
	}
	const auto native = set_damage_callback_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(set_damage_callback_native_hook.original)
		: original_set_damage_callback;
	if (native == nullptr || luau_pushcclosurek == nullptr)
	{
		clear_or_defer_callback_runtime_result_root(state, result_root);
		return false;
	}
	const luau_TValue arguments[]{receiver, callback};
	trace_addon(state, key, "damage.install.native-enter",
		"callback_isC=0 protected=1 rooted=1", arguments, 2);
	DamageCallbackInstallLeafContext context;
	context.native = native;
	context.result_root_key = result_root.registry_key;
	context.receiver = receiver;
	context.expected_callback = callback;
	const auto memory = capture_shared_callback_memory(state);
	ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &damage_callback_install_protected_leaf, &context);
	report_shared_callback_memory(state, "SetDamageCallback.install", memory);
	if (context.root_cleared) result_root = {};
	else clear_or_defer_callback_runtime_result_root(state, result_root);
	const bool passed = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed
		&& context.root_present && context.root_cleared
		&& context.callback.callback_status == 0;
	if (!passed && context.callback.callback_status != 0)
	{
		SharedCallbackOutcome outcome;
		outcome.leaf = context.callback;
		trace_addon(state, key, "damage.install.native-error",
			"pcall=" + std::to_string(context.callback.callback_status)
			+ shared_callback_error_details(outcome));
	}
	else if (!passed)
	{
		std::ostringstream detail;
		detail << "admitted=" << protected_result.admitted
			<< " restored=" << protected_result.restored
			<< " raw_status=" << protected_result.status
			<< " stage=" << callback_runtime_leaf_stage_label(context.stage)
			<< " rooted=" << context.root_present
			<< " cleared=" << context.root_cleared;
		trace_addon(state, key, "damage.install.native-error", detail.str());
	}
	trace_addon(state, key, "damage.install.native-return",
		std::string("status=") + (passed ? "ok" : "error"));
	return passed;
}

int addon_damage_callback_wrapper(luau_State* state)
{
	const auto* wrapper = state != nullptr && state->ci != nullptr
		&& state->ci->func != nullptr && is_function(state->ci->func->type)
		? reinterpret_cast<const luau_Closure*>(state->ci->func->value.as_uintptr)
		: nullptr;
	if (wrapper == nullptr || !wrapper->isC || wrapper->nupvalues < 4
		|| state->intop == nullptr || luau_gettop(state) < 2)
	{
		trace_addon(state, 0, "damage.callback.reject", "reason=callback-shape");
		return 0;
	}
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return 0;
	AddonTraceScope trace_scope(wrapper->nupvalues >= 3
		? wrapper->c.upvals[2].value.as_uintptr : 0);
	static thread_local std::uint64_t calls = 0, positive_calls = 0;
	const bool numeric = state->intop[1].type == LUAU_NUMBER;
	const bool positive = numeric && state->intop[1].value.as_float > 0;
	const bool zero = numeric && state->intop[1].value.as_float == 0;
	++calls;
	positive_calls += positive;
	// Keep the generic callback envelope on its bounded sampler so logging
	// cannot add hundreds of milliseconds to every positive damage result and
	// distort the timing being measured.
	const bool detailed_damage_trace = sample_damage_trace(
		calls, positive_calls, positive);
	AddonDetailScope detail_scope(detailed_damage_trace);
	LARGE_INTEGER started{}, ended{};
	QueryPerformanceCounter(&started);
	const auto errors_before = addon_dispatch_errors;
	const auto target_key = static_cast<std::uint64_t>(
		wrapper->c.upvals[0].value.as_uintptr);
	trace_addon(state, target_key, "damage.callback.enter", {},
		state->intop, static_cast<std::size_t>(luau_gettop(state)));
	// The callback's second argument is the engine-reported damage for this
	// resolved source hit. Dispatch it at that exact boundary. The enclosing
	// native area call can
	// outlive the final enemy hit, so treating its return as an effect boundary
	// caused grants to arrive after the target had died.
	if (positive)
	{
		const auto correlation = damage_timing_sequence.fetch_add(
			1, std::memory_order_relaxed) + 1;
		luau_TValue correlation_value{};
		correlation_value.type = LUAU_NUMBER;
		correlation_value.value.as_float = static_cast<float>(correlation);
		luau_TValue addon_arguments[5]{
			dereference_upvalue(wrapper->c.upvals[1]),
			state->intop[1],
			state->intop[0],
			dereference_upvalue(wrapper->c.upvals[3]),
			correlation_value,
		};
		// DamageData supplies a short-lived callback wrapper whose native Object
		// is valid but whose Lua metatable does not publish ordinary Entity/Avatar
		// methods. Rewrap that exact Object through the game's own push routine so
		// addons receive the canonical engine userdata and can synchronously read
		// authoritative state such as IsKilled and GetHealth. Keep the pushed
		// userdata rooted on this stack across every provider call.
		const auto callback_root_offset = luau_savestack(state, state->outtop);
		bool canonical_callback_target = false;
		auto* const callback_object = readable_engine_object(addon_arguments[2]);
		if (callback_object != nullptr && luau_pushobject != nullptr
			&& check_stack != nullptr)
		{
			try
			{
				ScopedVmApiFrame frame_capacity(state);
				require_stack(state, 2);
				const auto root_offset = luau_savestack(state, state->outtop);
				luau_pushobject(state, callback_object);
				auto* const root = luau_restorestack(state, root_offset);
				if (state->outtop == root + 1 && is_userdata(root->type))
				{
					addon_arguments[2] = *root;
					canonical_callback_target = true;
				}
				else
				{
					state->outtop = root;
				}
			}
			catch (...)
			{
				state->outtop = luau_restorestack(state, callback_root_offset);
			}
		}
		if (detailed_damage_trace)
		{
			trace_addon(state, target_key, "damage.target-canonical",
				std::string("status=") + (canonical_callback_target
					? "game-pushobject" : "original-callback-wrapper"),
				&addon_arguments[2], 1);
			trace_addon(state, target_key, "damage.timing.receive",
				"correlation=" + std::to_string(correlation),
				addon_arguments, 5);
			trace_damage_object_identities(
				state, target_key, correlation,
				addon_arguments[0], addon_arguments[2], addon_arguments[3]);
		}
		dispatch_target_hook(
			state, target_key, "afterDamage", addon_arguments, 5);
		state->outtop = luau_restorestack(state, callback_root_offset);
		if (detailed_damage_trace)
		{
			trace_addon(state, target_key, "damage.timing.after-addon",
				"correlation=" + std::to_string(correlation));
		}
	}
	trace_addon(state, target_key, "damage.callback.return");
	QueryPerformanceCounter(&ended);
	static thread_local DamagePerformanceWindow window;
	static thread_local ULONGLONG window_start = GetTickCount64();
	window.add(positive, zero,
		static_cast<std::uint64_t>(ended.QuadPart - started.QuadPart), addon_dispatch_errors - errors_before);
	const auto now = GetTickCount64();
	if (now - window_start >= 2000)
	{
		LARGE_INTEGER frequency{};
		QueryPerformanceFrequency(&frequency);
		const double microseconds = 1000000.0 / static_cast<double>(frequency.QuadPart);
		std::ostringstream performance;
		performance << "scope=host-dispatch-all-targets window_ms=" << now - window_start
			<< " calls=" << window.calls << " positive=" << window.positive << " zero=" << window.zero
			<< " errors=" << window.errors << " total_us=" << static_cast<double>(window.ticks) * microseconds
			<< " max_us=" << static_cast<double>(window.maximum_ticks) * microseconds;
		trace_addon(state, 0, "damage.performance", performance.str());
		window = {};
		window_start = now;
	}
	return 0;
}

bool install_addon_damage_callback(
	luau_State* state,
	std::uint64_t target_key,
	const luau_TValue& receiver,
	const luau_TValue& source_ability
)
{
	const auto original = set_damage_callback_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(set_damage_callback_native_hook.original)
		: original_set_damage_callback;
	if (original == nullptr || luau_pushcclosurek == nullptr
		|| !target_hook_available(state, target_key, "afterDamage"))
	{
		trace_addon(state, target_key, "damage.install.reject",
			"reason=missing-native-function-or-afterDamage");
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 12);
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!luau_push_lightuserdata(
		state, reinterpret_cast<void*>(static_cast<std::uintptr_t>(target_key))))
	{
		trace_addon(state, target_key, "damage.install.reject", "reason=key-stack-push");
		return false;
	}
	push_stack_value(state, source_ability);
	if (!luau_push_lightuserdata(state,
		reinterpret_cast<void*>(static_cast<std::uintptr_t>(addon_trace_attempt))))
	{
		state->outtop = luau_restorestack(state, base_offset);
		trace_addon(state, target_key, "damage.install.reject", "reason=trace-stack-push");
		return false;
	}
	// Preserve the exact RadialDamageData receiver in the callback closure so a
	// diagnostic run can correlate resolved hits that came from the same damage
	// packet without changing the generic afterDamage contract.
	push_stack_value(state, receiver);
	luau_pushcclosurek(
		state, &addon_damage_callback_wrapper,
		"RENOVICE additive damage dispatcher", 4, nullptr);
	const luau_TValue arguments[]{receiver, state->outtop[-1]};
	luau_TValue callback{};
	CallbackRuntimeResultRoot callback_root;
	bool passed = call_callback_runtime(
		state, target_key, "prepareSource", arguments, callback, &callback_root);
	if (passed)
	{
		passed = set_damage_callback_protected(
			state, target_key, receiver, callback, callback_root);
	}
	if (callback_root.active
		&& !clear_or_defer_callback_runtime_result_root(state, callback_root))
	{
		passed = false;
	}
	if (passed)
	{
		luau_TValue ignored{};
		passed = call_callback_runtime(state, target_key, "commitSource", arguments, ignored);
	}
	state->outtop = luau_restorestack(state, base_offset);
	if (!passed) return false;
	log_native_hook_once(
		state, target_key, "SetSourceObject.installDamageCallback");
	return true;
}

int set_source_object_adapter(luau_State* state)
{
	const auto original = set_source_object_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(set_source_object_native_hook.original)
		: original_set_source_object;
	if (original == nullptr) return 0;

	prepare_stock_native_finalize_entry(state);
	const auto previous_boundary = active_stock_native_finalize;
	ActiveStockNativeFinalize plan;
	{
		// Prepare every addon decision, trace owner, and generation borrow before
		// entering stock. Only a POD frame fingerprint crosses the stock call.
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		if (generation_dispatch && state != nullptr && state->intop != nullptr
			&& target_snapshot_requests_native_damage(state->global_state)
			&& luau_gettop(state) >= 2)
		{
			AddonTraceScope trace_scope;
			const auto trace_attempt = addon_trace_attempt;
			const bool detailed_trace = trace_attempt <= 4
				|| trace_attempt % 128 == 0;
			AddonDetailScope detail_scope(detailed_trace);
			trace_addon(
				state, 0, "source.enter", {}, state->intop,
				static_cast<std::size_t>(luau_gettop(state)));
			log_native_hook_once(state, 0, "SetSourceObject.detour-entry");
			// Native calls require actual caller evidence, not a broad VM scope.
			const auto target_key = target_key_for_active_call_stack(state);
			if (target_key != 0)
			{
				log_native_hook_once(
					state, target_key, "SetSourceObject.targetCallStack.match");
			}
			trace_addon(state, target_key, "source.native-enter");
			plan = make_stock_native_finalize(
				StockNativeFinalizeKind::set_source_object,
				state, active_generation, target_key, trace_attempt,
				detailed_trace);
		}
	}
	if (plan.active) active_stock_native_finalize = plan;

	// Intentionally naked: stock errors propagate with no RENOVICE lease,
	// trace/detail RAII owner, snapshot, string, or unrooted TValue copy alive.
	const int result_count = original(state);

	if (plan.active)
	{
		finish_stock_native_finalize(plan.token, previous_boundary, state);
	}
	if (!plan.active) return result_count;

	{
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		luau_TValue arguments[2]{};
		if (!generation_dispatch || active_generation != plan.generation
			|| !stock_native_finalize_arguments(plan, state, arguments))
		{
			return result_count;
		}

		AddonTraceScope trace_scope(plan.trace_attempt);
		AddonDetailScope detail_scope(plan.detailed_trace);
		auto target_key = plan.target_key;
		trace_addon(state, target_key, "source.native-return",
			"results=" + std::to_string(result_count));
		if (result_count != 0)
		{
			trace_addon(
				state, target_key, "source.reject",
				"reason=arguments-or-native-results");
			return result_count;
		}

		if (target_key == 0)
		{
			target_key = target_key_for_matcher(
				state, arguments[1], "matchesDamageSource");
		}
		if (target_key == 0)
		{
			trace_addon(state, 0, "source.reject", "reason=no-exact-target");
			log_native_hook_once(state, 0, "SetSourceObject.target.missing");
			return result_count;
		}
		log_native_hook_once(state, target_key, "SetSourceObject.target.match");
		if (install_addon_damage_callback(
				state, target_key, arguments[0], arguments[1]))
		{
			log_native_hook_once(
				state, target_key, "SetSourceObject.attachDamageCallback");
			trace_addon(state, target_key, "source.attach-return");
		}
		else trace_addon(state, target_key, "source.attach-failed");
		trace_addon(state, target_key, "source.return");
	}
	return result_count;
}

int set_damage_callback_adapter(luau_State* state)
{
	const auto original = set_damage_callback_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(set_damage_callback_native_hook.original)
		: original_set_damage_callback;
	if (original == nullptr) return 0;

	prepare_stock_native_finalize_entry(state);
	const auto previous_boundary = active_stock_native_finalize;
	ActiveStockNativeFinalize plan;
	{
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		if (generation_dispatch && state != nullptr && state->intop != nullptr
			&& target_snapshot_requests_native_damage(state->global_state)
			&& luau_gettop(state) >= 2)
		{
			AddonTraceScope trace_scope;
			const auto trace_attempt = addon_trace_attempt;
			log_native_hook_once(state, 0, "SetDamageCallback.detour-entry");
			auto target_key = target_key_for_published_closure(
				state, state->intop[1]);
			if (target_key == 0)
				target_key = target_key_for_active_call_stack(state);
			plan = make_stock_native_finalize(
				StockNativeFinalizeKind::set_damage_callback,
				state, active_generation, target_key, trace_attempt, true);
		}
	}
	if (plan.active) active_stock_native_finalize = plan;

	// First perform the exact stock request. A failed optional decoration must
	// leave this callback installed. This call is intentionally naked.
	const int result_count = original(state);

	if (plan.active)
	{
		finish_stock_native_finalize(plan.token, previous_boundary, state);
	}
	if (!plan.active) return result_count;

	{
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		luau_TValue arguments[2]{};
		if (!generation_dispatch || active_generation != plan.generation
			|| plan.target_key == 0 || result_count != 0
			|| !stock_native_finalize_arguments(plan, state, arguments))
		{
			return result_count;
		}
		AddonTraceScope trace_scope(plan.trace_attempt);
		const auto base_offset = luau_savestack(state, state->outtop);
		luau_TValue callback{}, ignored{};
		CallbackRuntimeResultRoot callback_root;
		if (call_callback_runtime(
				state, plan.target_key, "commitOriginal", arguments, ignored)
			&& call_callback_runtime(
				state, plan.target_key, "prepareOriginal", arguments, callback,
				&callback_root))
		{
			if (callback.value.as_uintptr == arguments[1].value.as_uintptr)
			{
				clear_or_defer_callback_runtime_result_root(state, callback_root);
				trace_addon(
					state, plan.target_key, "damage.stock.deferred",
					"reason=no-source-association stock-preserved=1");
			}
			else if (set_damage_callback_protected(
					state, plan.target_key, arguments[0], callback, callback_root))
				trace_addon(
					state, plan.target_key, "damage.stock.attached",
					"stock-preserved=1");
			else trace_addon(
				state, plan.target_key, "damage.stock.attach-failed",
				"stock-preserved=1");
		}
		if (callback_root.active)
			clear_or_defer_callback_runtime_result_root(state, callback_root);
		state->outtop = luau_restorestack(state, base_offset);
	}
	return result_count;
}

bool same_lua_value(const luau_TValue& lhs, const luau_TValue& rhs) noexcept
{
	if (lhs.type != rhs.type) return false;
	if (lhs.type == LUAU_NUMBER) return lhs.value.as_float == rhs.value.as_float;
	if (lhs.type == LUAU_BOOL) return lhs.value.as_bool == rhs.value.as_bool;
	return lhs.value.as_uintptr == rhs.value.as_uintptr;
}

luau_TValue target_diagnostic_trace_callback_value(
	luau_State* state,
	std::uint64_t target_key
)
{
	luau_TValue result{};
	result.type = LUAU_NIL;
	const auto flags = config::flags();
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| getfield == nullptr
		|| !diagnostic_snapshot_capacity_available(flags)
		|| !flags.diagnostics_method.empty() || !flags.diagnostics_addon.empty()
		|| !diagnostic_trace_selected(
			flags, target_key, "target.trace.callback", {}))
	{
		return result;
	}
	if (read_diagnostic_trace_registry_root(state, result)) return result;

	const auto base_offset = luau_savestack(state, state->outtop);
	const char* failure_reason = "shared-global-lookup-failed";
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 6);
	auto* const base = state->outtop;
	if (push_vm_global(state, "_T") && is_table(base->type))
	{
		getfield(state, -1, "RENOVICE_TRACE");
		luau_Closure* trace = nullptr;
		if (readable_lua_closure(*(base + 1), trace)
			&& trace->isC && trace->c.func == &diagnostic_trace_bridge)
		{
			result = *(base + 1);
			if (!write_diagnostic_trace_registry_root(state, result))
			{
				result = {};
				result.type = LUAU_NIL;
				failure_reason = "diagnostic-registry-root-failed";
			}
		}
		else
		{
			failure_reason = (base + 1)->type == LUAU_NIL
				? "trace-field-absent" : "trace-field-not-owned-cclosure";
		}
	}
	state->outtop = luau_restorestack(state, base_offset);
	if (result.type != LUAU_NIL) return result;
	if (!diagnostic_trace_callback_failure_logged.exchange(
		true, std::memory_order_relaxed))
	{
		std::ostringstream failure;
		failure << "RENOVICE target trace callback FAIL reason=" << failure_reason
			<< " key=" << std::hex << target_key << std::dec
			<< " vm=" << state->global_state;
		config::diagnostic_log(failure.str(), config::DiagnosticsMode::errors);
	}
	return result;
}

enum class LuaCallBeforeLeafStage : std::uint8_t
{
	none,
	reserve_stack,
	create_arguments_table,
	write_argument,
	create_upvalues_table,
	write_upvalue,
	lookup_provider,
	invoke_provider,
	read_argument,
	read_upvalue,
};

struct LuaCallBeforeLeafContext
{
	std::ptrdiff_t base_offset = 0;
	std::int32_t prototype = -1;
	const char* const* provider_registry_keys = nullptr;
	std::size_t provider_count = 0;
	const luau_TValue* stock_arguments = nullptr;
	std::size_t argument_count = 0;
	const luau_TValue* stock_upvalues = nullptr;
	std::size_t upvalue_count = 0;
	luau_TValue* candidate_arguments = nullptr;
	luau_TValue* candidate_upvalues = nullptr;
	const char* trace_registry_key = nullptr;
	bool trace_requested = false;
	bool trace_available = false;
	bool invoked = false;
	bool completed = false;
	LuaCallBeforeLeafStage stage = LuaCallBeforeLeafStage::none;
	std::size_t failure_index = 0;
	int callback_status = 0;
	int error_tag = -1;
	char error_text[lua_error_text_capacity]{};
};
static_assert(std::is_trivially_copyable_v<LuaCallBeforeLeafContext>);

// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF
// Everything in this region runs below DE's raw protected boundary. These
// helpers intentionally own only scalar values, raw pointers, and TValues: a
// DE Luau error longjmps out of this region and skips C++ destructors here.
bool lua_call_before_leaf_reserve(luau_State* state, int slots)
{
	return state != nullptr && check_stack != nullptr && slots >= 0
		&& check_stack(state, slots) != 0;
}

bool lua_call_before_leaf_push_value(
	luau_State* state,
	const luau_TValue& value)
{
	if (state == nullptr || state->outtop == nullptr || gc_barrierback == nullptr
		|| !lua_call_before_leaf_reserve(state, 1)
		|| state->outtop >= state->stack_last)
	{
		return false;
	}
	if ((state->marked & native_gc_black_mask_u43) != 0)
	{
		gc_barrierback(
			state, reinterpret_cast<luau_GCObject*>(state), &state->gclist);
	}
	*state->outtop = value;
	++state->outtop;
	return true;
}

bool lua_call_before_leaf_push_number(luau_State* state, float value)
{
	if (state == nullptr || state->outtop == nullptr
		|| !lua_call_before_leaf_reserve(state, 1)
		|| state->outtop >= state->stack_last)
	{
		return false;
	}
	state->outtop->value.as_float = value;
	state->outtop->type = LUAU_NUMBER;
	++state->outtop;
	return true;
}

bool lua_call_before_leaf_set_array(
	luau_State* state,
	int table_index,
	std::size_t index,
	const luau_TValue& value)
{
	if (luau_settable == nullptr || index > (1u << 24)
		|| !lua_call_before_leaf_push_number(state, static_cast<float>(index))
		|| !lua_call_before_leaf_push_value(state, value))
	{
		return false;
	}
	luau_settable(state, table_index < 0 ? table_index - 2 : table_index);
	return true;
}

bool lua_call_before_leaf_get_array(
	luau_State* state,
	int table_index,
	std::size_t index,
	luau_TValue* output)
{
	if (state == nullptr || state->outtop == nullptr || output == nullptr
		|| luau_gettable == nullptr || index > (1u << 24))
	{
		return false;
	}
	const auto saved_top = luau_savestack(state, state->outtop);
	if (!lua_call_before_leaf_push_number(state, static_cast<float>(index)))
		return false;
	luau_gettable(state, table_index < 0 ? table_index - 1 : table_index);
	auto* const base = luau_restorestack(state, saved_top);
	if (state->outtop != base + 1) return false;
	*output = *base;
	state->outtop = base;
	return true;
}

bool lua_call_before_leaf_provider(
	luau_State* state,
	const char* registry_key,
	std::int32_t prototype,
	luau_TValue* output)
{
	if (state == nullptr || state->outtop == nullptr || registry_key == nullptr
		|| output == nullptr || getfield == nullptr || luau_gettable == nullptr
		|| prototype < 0)
	{
		return false;
	}
	const auto saved_top = luau_savestack(state, state->outtop);
	getfield(state, -10000, registry_key);
	auto* base = luau_restorestack(state, saved_top);
	if (!is_table(base->type)) { state->outtop = base; return false; }
	getfield(state, -1, "hooks");
	base = luau_restorestack(state, saved_top);
	if (!is_table((base + 1)->type)) { state->outtop = base; return false; }
	getfield(state, -1, "luaCalls");
	base = luau_restorestack(state, saved_top);
	if (!is_table((base + 2)->type)) { state->outtop = base; return false; }
	if (!lua_call_before_leaf_push_number(state, static_cast<float>(prototype)))
	{
		state->outtop = base;
		return false;
	}
	luau_gettable(state, -2);
	base = luau_restorestack(state, saved_top);
	if (!is_table((base + 3)->type)) { state->outtop = base; return false; }
	getfield(state, -1, "before");
	base = luau_restorestack(state, saved_top);
	if (!is_function((base + 4)->type)) { state->outtop = base; return false; }
	*output = *(base + 4);
	state->outtop = base;
	return true;
}

luau_TValue lua_call_before_leaf_trace(
	luau_State* state,
	LuaCallBeforeLeafContext* context)
{
	luau_TValue result{};
	result.type = LUAU_NIL;
	if (state == nullptr || context == nullptr || !context->trace_requested
		|| context->trace_registry_key == nullptr || getfield == nullptr)
	{
		return result;
	}
	const auto saved_top = luau_savestack(state, state->outtop);
	getfield(state, -10000, context->trace_registry_key);
	auto* base = luau_restorestack(state, saved_top);
	luau_Closure* closure = nullptr;
	if (readable_lua_closure(*base, closure) && closure->isC
		&& closure->c.func == &diagnostic_trace_bridge)
	{
		result = *base;
		context->trace_available = true;
		state->outtop = base;
		return result;
	}
	state->outtop = base;

	if (wf_hash != nullptr && luau_gettable != nullptr
		&& lua_call_before_leaf_reserve(state, 1))
	{
		base = luau_restorestack(state, saved_top);
		base->value.as_bool = wf_hash("_T");
		base->type = LUAU_BOOL;
		state->outtop = base + 1;
		luau_gettable(state, -10002);
	}
	else
	{
		getfield(state, -10002, "_T");
	}
	base = luau_restorestack(state, saved_top);
	if (state->outtop == base + 1 && is_table(base->type))
	{
		getfield(state, -1, "RENOVICE_TRACE");
		base = luau_restorestack(state, saved_top);
		closure = nullptr;
		if (state->outtop == base + 2
			&& readable_lua_closure(*(base + 1), closure) && closure->isC
			&& closure->c.func == &diagnostic_trace_bridge)
		{
			result = *(base + 1);
			context->trace_available = true;
		}
	}
	state->outtop = luau_restorestack(state, saved_top);
	return result;
}

void lua_call_before_protected_leaf(luau_State* state, void* raw_context)
{
	auto* const context = static_cast<LuaCallBeforeLeafContext*>(raw_context);
	if (state == nullptr || context == nullptr || luau_createtable == nullptr
		|| protected_call == nullptr || context->prototype < 0
		|| context->provider_registry_keys == nullptr
		|| (context->argument_count != 0
			&& (context->stock_arguments == nullptr
				|| context->candidate_arguments == nullptr))
		|| (context->upvalue_count != 0
			&& (context->stock_upvalues == nullptr
				|| context->candidate_upvalues == nullptr)))
	{
		return;
	}

	context->stage = LuaCallBeforeLeafStage::reserve_stack;
	if (!lua_call_before_leaf_reserve(state, 16)) return;
	state->outtop = luau_restorestack(state, context->base_offset);

	context->stage = LuaCallBeforeLeafStage::create_arguments_table;
	luau_createtable(state, static_cast<int>(context->argument_count), 0);
	for (std::size_t index = 0; index != context->argument_count; ++index)
	{
		context->stage = LuaCallBeforeLeafStage::write_argument;
		context->failure_index = index;
		if (!lua_call_before_leaf_set_array(
				state, -1, index + 1, context->stock_arguments[index])) return;
	}
	const auto arguments_table_offset = luau_savestack(state, state->outtop - 1);

	context->stage = LuaCallBeforeLeafStage::create_upvalues_table;
	luau_createtable(state, static_cast<int>(context->upvalue_count), 0);
	for (std::size_t index = 0; index != context->upvalue_count; ++index)
	{
		context->stage = LuaCallBeforeLeafStage::write_upvalue;
		context->failure_index = index;
		if (!lua_call_before_leaf_set_array(
				state, -1, index + 1, context->stock_upvalues[index])) return;
	}
	const auto upvalues_table_offset = luau_savestack(state, state->outtop - 1);

	for (std::size_t index = 0; index != context->provider_count; ++index)
	{
		context->stage = LuaCallBeforeLeafStage::lookup_provider;
		context->failure_index = index;
		luau_TValue callback{};
		if (!lua_call_before_leaf_provider(
				state, context->provider_registry_keys[index],
				context->prototype, &callback))
		{
			continue;
		}
		context->invoked = true;

		luau_TValue callback_arguments[4]{};
		callback_arguments[0].type = LUAU_NUMBER;
		callback_arguments[0].value.as_float =
			static_cast<float>(context->prototype);
		callback_arguments[1] = *luau_restorestack(
			state, arguments_table_offset);
		callback_arguments[2] = *luau_restorestack(
			state, upvalues_table_offset);
		callback_arguments[3] = lua_call_before_leaf_trace(state, context);

		context->stage = LuaCallBeforeLeafStage::invoke_provider;
		const auto callback_base_offset = luau_savestack(state, state->outtop);
		if (!lua_call_before_leaf_push_value(state, callback)) return;
		for (std::size_t argument = 0; argument != 4; ++argument)
		{
			if (!lua_call_before_leaf_push_value(
					state, callback_arguments[argument])) return;
		}
		state->interrupt_count = 0;
		context->callback_status = protected_call(state, 4, 0, 0);
		if (context->callback_status != 0
			&& state->outtop > luau_restorestack(state, callback_base_offset))
		{
			context->error_tag = static_cast<int>((state->outtop - 1)->type);
			capture_lua_error_text(*(state->outtop - 1),
				context->error_text, sizeof(context->error_text));
		}
		state->outtop = luau_restorestack(state, callback_base_offset);
		if (context->callback_status != 0) return;
	}

	if (!context->invoked)
	{
		context->stage = LuaCallBeforeLeafStage::none;
		context->completed = true;
		return;
	}
	for (std::size_t index = 0; index != context->argument_count; ++index)
	{
		context->stage = LuaCallBeforeLeafStage::read_argument;
		context->failure_index = index;
		state->outtop = luau_restorestack(state, arguments_table_offset) + 1;
		if (!lua_call_before_leaf_get_array(
				state, -1, index + 1, &context->candidate_arguments[index])) return;
	}
	for (std::size_t index = 0; index != context->upvalue_count; ++index)
	{
		context->stage = LuaCallBeforeLeafStage::read_upvalue;
		context->failure_index = index;
		state->outtop = luau_restorestack(state, upvalues_table_offset) + 1;
		if (!lua_call_before_leaf_get_array(
				state, -1, index + 1, &context->candidate_upvalues[index])) return;
	}
	context->stage = LuaCallBeforeLeafStage::none;
	context->completed = true;
}
// END LUA_CALL_BEFORE_PROTECTED_LEAF

const char* lua_call_before_leaf_stage_label(
	LuaCallBeforeLeafStage stage) noexcept
{
	switch (stage)
	{
	case LuaCallBeforeLeafStage::none: return "none";
	case LuaCallBeforeLeafStage::reserve_stack: return "reserve-stack";
	case LuaCallBeforeLeafStage::create_arguments_table: return "create-arguments-table";
	case LuaCallBeforeLeafStage::write_argument: return "write-argument";
	case LuaCallBeforeLeafStage::create_upvalues_table: return "create-upvalues-table";
	case LuaCallBeforeLeafStage::write_upvalue: return "write-upvalue";
	case LuaCallBeforeLeafStage::lookup_provider: return "lookup-provider";
	case LuaCallBeforeLeafStage::invoke_provider: return "invoke-provider";
	case LuaCallBeforeLeafStage::read_argument: return "read-argument";
	case LuaCallBeforeLeafStage::read_upvalue: return "read-upvalue";
	}
	return "unknown";
}

bool lua_call_stack_span_is_live(
	const luau_State* state,
	std::ptrdiff_t offset,
	std::size_t count) noexcept
{
	if (state == nullptr || state->stack == nullptr || state->stack_last == nullptr
		|| offset < 0) return false;
	const auto begin = reinterpret_cast<std::uintptr_t>(state->stack);
	const auto end = reinterpret_cast<std::uintptr_t>(state->stack_last);
	const auto byte_offset = static_cast<std::uintptr_t>(offset);
	if (end < begin || byte_offset > end - begin
		|| byte_offset % alignof(luau_TValue) != 0) return false;
	const auto remaining = end - begin - byte_offset;
	return count <= remaining / sizeof(luau_TValue);
}

bool lua_call_frame_offset_is_live(
	const luau_State* state,
	std::ptrdiff_t offset) noexcept
{
	if (state == nullptr || state->base_ci == nullptr || state->end_ci == nullptr
		|| offset < 0) return false;
	const auto begin = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	const auto byte_offset = static_cast<std::uintptr_t>(offset);
	return end >= begin && byte_offset <= end - begin
		&& byte_offset % alignof(luau_CallInfo) == 0
		&& sizeof(luau_CallInfo) <= end - begin - byte_offset;
}

bool dispatch_lua_call_phase(
	luau_State* state,
	const TargetLuaCall& call,
	const char* phase,
	std::vector<luau_TValue>& arguments,
	luau_TValue* stock_argument_base)
{
	if (lua_call_hook_running) return true;
	if (!call.callsite.exact || call.closure == nullptr || call.closure->isC
		|| state == nullptr || state->stack == nullptr || state->stack_last == nullptr
		|| state->intop == nullptr || state->outtop == nullptr
		|| state->ci == nullptr || state->base_ci == nullptr
		|| state->end_ci == nullptr || state->ci->top == nullptr
		|| check_stack == nullptr || gc_barrierback == nullptr
		|| getfield == nullptr || luau_gettable == nullptr
		|| luau_settable == nullptr || luau_createtable == nullptr
		|| protected_call == nullptr || phase == nullptr
		|| std::strcmp(phase, "before") != 0
		|| arguments.size() > (1u << 24))
	{
		return false;
	}

	const auto& providers = hook_addons_snapshot(
		call.callsite.target_key, state->global_state);
	if (providers.empty()) return true;
	const auto frame_begin = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto frame_end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	const auto current_frame = reinterpret_cast<std::uintptr_t>(state->ci);
	if (frame_end < frame_begin || current_frame < frame_begin
		|| current_frame > frame_end
		|| sizeof(luau_CallInfo) > frame_end - current_frame)
	{
		return false;
	}
	const auto original_intop_offset = luau_savestack(state, state->intop);
	const auto base_offset = luau_savestack(state, state->outtop);
	const auto original_frame_offset = static_cast<std::ptrdiff_t>(
		current_frame - frame_begin);
	const auto original_frame_limit_offset = luau_savestack(
		state, state->ci->top);
	const auto stock_argument_base_offset = stock_argument_base == nullptr
		? std::ptrdiff_t{-1} : luau_savestack(state, stock_argument_base);
	if (!lua_call_stack_span_is_live(
			state, stock_argument_base_offset, arguments.size())) return false;

	struct ScopedLuaCallHook
	{
		ScopedLuaCallHook() noexcept { lua_call_hook_running = true; }
		~ScopedLuaCallHook() noexcept { lua_call_hook_running = false; }
	} hook_scope;
	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;

	std::vector<const char*> provider_registry_keys;
	provider_registry_keys.reserve(providers.size());
	for (const auto& addon : providers)
		provider_registry_keys.push_back(addon.registry_key.c_str());

	std::vector<luau_TValue> stock_upvalues;
	stock_upvalues.reserve(call.closure->nupvalues);
	for (std::size_t index = 0; index != call.closure->nupvalues; ++index)
	{
		auto* const slot = writable_upvalue_slot(call.closure, index);
		if (slot == nullptr) return false;
		stock_upvalues.push_back(*slot);
	}
	std::vector<luau_TValue> candidate_arguments(arguments.size());
	std::vector<luau_TValue> candidate_upvalues(stock_upvalues.size());

	const auto flags = config::flags();
	const bool trace_requested = diagnostic_snapshot_capacity_available(flags)
		&& flags.diagnostics_method.empty() && flags.diagnostics_addon.empty()
		&& diagnostic_trace_selected(
			flags, call.callsite.target_key, "target.trace.callback", {});
	LuaCallBeforeLeafContext context;
	context.base_offset = base_offset;
	context.prototype = call.callsite.prototype;
	context.provider_registry_keys = provider_registry_keys.data();
	context.provider_count = provider_registry_keys.size();
	context.stock_arguments = arguments.data();
	context.argument_count = arguments.size();
	context.stock_upvalues = stock_upvalues.data();
	context.upvalue_count = stock_upvalues.size();
	context.candidate_arguments = candidate_arguments.data();
	context.candidate_upvalues = candidate_upvalues.data();
	context.trace_registry_key = diagnostic_trace_registry_key.c_str();
	context.trace_requested = trace_requested;

	ScopedVmApiFrame frame_capacity(state);
	ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);
	const auto protected_result =
		de_vm_authority::run_current_vm_protected(
			state, &lua_call_before_protected_leaf, &context);

	// DE's raw runner restores only its error-jump chain. The shared wrapper has
	// already relocation-safely restored ci, ci->top, intop, and outtop here;
	// retain the outer offsets and frame guard as an independent exact check.
	const bool stack_offsets_live =
		lua_call_stack_span_is_live(state, original_intop_offset, 0)
		&& lua_call_stack_span_is_live(state, base_offset, 0)
		&& lua_call_stack_span_is_live(
			state, stock_argument_base_offset, arguments.size());
	const bool frame_offset_live = lua_call_frame_offset_is_live(
		state, original_frame_offset);
	auto* const expected_frame = frame_offset_live
		? reinterpret_cast<luau_CallInfo*>(
			reinterpret_cast<char*>(state->base_ci) + original_frame_offset)
		: nullptr;
	const bool exact_frame_return = expected_frame != nullptr
		&& state->ci == expected_frame;
	if (stack_offsets_live)
	{
		state->intop = luau_restorestack(state, original_intop_offset);
		state->outtop = luau_restorestack(state, base_offset);
	}
	frame_capacity.restore();
	const auto expected_frame_limit = (std::max)(
		original_frame_limit_offset, base_offset);
	const bool exact_frame_limit = exact_frame_return
		&& lua_call_stack_span_is_live(state, expected_frame_limit, 0)
		&& state->ci->top == luau_restorestack(state, expected_frame_limit);
	if (!stack_offsets_live || !exact_frame_return || !exact_frame_limit)
		return false;
	auto* const live_argument_base = luau_restorestack(
		state, stock_argument_base_offset);

	std::vector<luau_TValue*> live_upvalue_slots(
		stock_upvalues.size(), nullptr);
	bool live_stock_exact = true;
	for (std::size_t index = 0; index != live_upvalue_slots.size(); ++index)
	{
		live_upvalue_slots[index] = writable_upvalue_slot(call.closure, index);
		if (live_upvalue_slots[index] == nullptr
			|| !same_lua_value(*live_upvalue_slots[index], stock_upvalues[index]))
		{
			live_stock_exact = false;
		}
	}
	for (std::size_t index = 0; index != arguments.size(); ++index)
		if (!same_lua_value(live_argument_base[index], arguments[index]))
			live_stock_exact = false;

	const auto restore_stock = [&]() noexcept
	{
		for (std::size_t index = 0; index != arguments.size(); ++index)
			live_argument_base[index] = arguments[index];
		for (std::size_t index = 0; index != live_upvalue_slots.size(); ++index)
			if (live_upvalue_slots[index] != nullptr)
				*live_upvalue_slots[index] = stock_upvalues[index];
	};
	if (!protected_result.admitted || !protected_result.restored
		|| protected_result.status != 0
		|| !context.completed || !live_stock_exact)
	{
		restore_stock();
		static std::atomic<std::uint64_t> errors = 0;
		const auto sequence = errors.fetch_add(1, std::memory_order_relaxed) + 1;
		if (sample_vm_host_error(sequence))
		{
			std::ostringstream failure;
			failure << "RENOVICE luaCalls.before protected leaf FAIL key=0x"
				<< std::hex << call.callsite.target_key << std::dec
				<< " prototype=" << call.callsite.prototype
				<< " admitted=" << protected_result.admitted
				<< " restored=" << protected_result.restored
				<< " raw_status=" << protected_result.status
				<< " stage=" << lua_call_before_leaf_stage_label(context.stage)
				<< " index=" << context.failure_index
				<< " callback_status=" << context.callback_status
				<< " stock_exact=" << live_stock_exact
				<< " occurrence=" << sequence
				<< " stock-restored=1";
			if (context.error_tag >= 0)
			{
				failure << " error_tag=" << context.error_tag
					<< " error=\"" << context.error_text << '"';
			}
			config::log(failure.str());
		}
		return false;
	}
	if (!context.invoked) return true;

	for (std::size_t index = 0; index != candidate_arguments.size(); ++index)
	{
		if (same_lua_value(arguments[index], candidate_arguments[index])) continue;
		if (!target_lua_argument_mutation_allowed(
				true, arguments[index].type, candidate_arguments[index].type,
				candidate_arguments[index].type == LUAU_NUMBER
					&& std::isfinite(candidate_arguments[index].value.as_float)))
		{
			restore_stock();
			std::ostringstream failure;
			failure << "RENOVICE luaCalls mutation rejected key=0x" << std::hex
				<< call.callsite.target_key << std::dec
				<< " prototype=" << call.callsite.prototype
				<< " phase=before argument=" << (index + 1)
				<< " original_tag=" << arguments[index].type
				<< " candidate_tag=" << candidate_arguments[index].type;
			config::log(failure.str());
			return false;
		}
	}
	for (std::size_t index = 0; index != candidate_upvalues.size(); ++index)
	{
		if (same_lua_value(stock_upvalues[index], candidate_upvalues[index])) continue;
		if (!target_lua_scalar_mutation_allowed(
				stock_upvalues[index].type, candidate_upvalues[index].type,
				candidate_upvalues[index].type == LUAU_NUMBER
					&& std::isfinite(candidate_upvalues[index].value.as_float)))
		{
			restore_stock();
			std::ostringstream failure;
			failure << "RENOVICE luaCalls mutation rejected key=0x" << std::hex
				<< call.callsite.target_key << std::dec
				<< " prototype=" << call.callsite.prototype
				<< " phase=before upvalue=" << (index + 1)
				<< " original_tag=" << stock_upvalues[index].type
				<< " candidate_tag=" << candidate_upvalues[index].type;
			config::log(failure.str());
			return false;
		}
	}

	for (std::size_t index = 0; index != candidate_upvalues.size(); ++index)
		*live_upvalue_slots[index] = candidate_upvalues[index];
	for (std::size_t index = 0; index != candidate_arguments.size(); ++index)
	{
		live_argument_base[index] = candidate_arguments[index];
		arguments[index] = candidate_arguments[index];
	}
	if (trace_requested && !context.trace_available
		&& !diagnostic_trace_callback_failure_logged.exchange(
			true, std::memory_order_relaxed))
	{
		config::diagnostic_log(
			"RENOVICE target trace callback unavailable in luaCalls.before protected leaf",
			config::DiagnosticsMode::errors);
	}
	const std::string event = "luaCalls."
		+ std::to_string(call.callsite.prototype) + ".before";
	log_native_hook_once(state, call.callsite.target_key, event.c_str());
	return true;
}

enum class NativeCallPhaseLeafStage : std::uint8_t
{
	none,
	reserve_stack,
	create_arguments_table,
	write_argument,
	create_results_table,
	write_result,
	lookup_trace,
	lookup_provider,
	invoke_provider,
	read_value,
};

struct NativeCallPhaseLeafContext
{
	std::ptrdiff_t base_offset = 0;
	std::int32_t prototype = -1;
	std::uint32_t instruction = 0;
	const char* method_name = nullptr;
	const char* phase = nullptr;
	const char* trace_registry_key = nullptr;
	const char* const* provider_registry_keys = nullptr;
	std::uint8_t* provider_invoked = nullptr;
	std::size_t provider_count = 0;
	const luau_TValue* arguments = nullptr;
	std::size_t argument_count = 0;
	const luau_TValue* results = nullptr;
	std::size_t result_count = 0;
	luau_TValue* transformed = nullptr;
	bool after_phase = false;
	bool trace_requested = false;
	bool trace_available = false;
	bool invoked = false;
	bool completed = false;
	NativeCallPhaseLeafStage stage = NativeCallPhaseLeafStage::none;
	std::size_t failure_index = 0;
	int callback_status = 0;
};
static_assert(std::is_trivially_copyable_v<NativeCallPhaseLeafContext>);

// BEGIN NATIVE_CALL_PHASE_PROTECTED_LEAF
// The raw runner can escape any VM primitive below through DE's longjmp.  This
// leaf therefore owns no mutex, lease, string, vector, smart pointer, or other
// destructor-dependent C++ state.  Every pointer targets storage retained by
// the outer transaction until run_current_vm_protected returns.
bool native_call_phase_leaf_set_array(
	luau_State* state,
	std::ptrdiff_t table_offset,
	std::size_t index,
	const luau_TValue& value) noexcept
{
	if (state == nullptr || luau_settable == nullptr || index > (1u << 24)
		|| !lua_call_stack_span_is_live(state, table_offset, 1)) return false;
	state->outtop = luau_restorestack(state, table_offset) + 1;
	if (!lua_call_before_leaf_push_number(state, static_cast<float>(index))
		|| !lua_call_before_leaf_push_value(state, value)) return false;
	luau_settable(state, -3);
	return true;
}

bool native_call_phase_leaf_get_array(
	luau_State* state,
	std::ptrdiff_t table_offset,
	std::size_t index,
	luau_TValue& value) noexcept
{
	value = {};
	if (state == nullptr || luau_gettable == nullptr || index > (1u << 24)
		|| !lua_call_stack_span_is_live(state, table_offset, 1)) return false;
	state->outtop = luau_restorestack(state, table_offset) + 1;
	if (!lua_call_before_leaf_push_number(state, static_cast<float>(index))) return false;
	luau_gettable(state, -2);
	if (state->outtop == nullptr || state->outtop <= state->stack) return false;
	value = state->outtop[-1];
	return true;
}

bool native_call_phase_leaf_callback(
	luau_State* state,
	std::ptrdiff_t lookup_base_offset,
	const char* registry_key,
	const char* method_name,
	const char* phase,
	luau_TValue& callback) noexcept
{
	callback = {};
	callback.type = LUAU_NIL;
	if (state == nullptr || getfield == nullptr || registry_key == nullptr
		|| method_name == nullptr || phase == nullptr
		|| !lua_call_stack_span_is_live(state, lookup_base_offset, 0)) return false;
	state->outtop = luau_restorestack(state, lookup_base_offset);
	getfield(state, -10000, registry_key);
	auto* const base = luau_restorestack(state, lookup_base_offset);
	if (!is_table(base[0].type)) return false;
	getfield(state, -1, "hooks");
	if (!is_table(base[1].type)) return false;
	getfield(state, -1, "nativeCalls");
	if (!is_table(base[2].type)) return false;
	getfield(state, -1, method_name);
	if (!is_table(base[3].type)) return false;
	getfield(state, -1, phase);
	if (!is_function(base[4].type)) return false;
	callback = base[4];
	return true;
}

void native_call_phase_protected_leaf(luau_State* state, void* opaque)
{
	auto* const context = static_cast<NativeCallPhaseLeafContext*>(opaque);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| state->stack == nullptr || state->stack_last == nullptr
		|| check_stack == nullptr || gc_barrierback == nullptr
		|| getfield == nullptr || luau_gettable == nullptr
		|| luau_settable == nullptr || luau_createtable == nullptr
		|| protected_call == nullptr || context->method_name == nullptr
		|| context->phase == nullptr || context->provider_registry_keys == nullptr
		|| (context->provider_count != 0 && context->provider_invoked == nullptr)
		|| (context->argument_count != 0 && context->arguments == nullptr)
		|| ((context->after_phase ? context->result_count : context->argument_count) != 0
			&& context->transformed == nullptr))
	{
		return;
	}
	context->stage = NativeCallPhaseLeafStage::reserve_stack;
	// Table entries are written two stack values at a time; their array storage
	// is owned by the table, so argument/result counts do not consume an equal
	// number of live stack slots here.
	if (!lua_call_before_leaf_reserve(state, 32)) return;

	context->stage = NativeCallPhaseLeafStage::create_arguments_table;
	luau_createtable(state, static_cast<int>(context->argument_count), 0);
	const auto arguments_table_offset = luau_savestack(state, state->outtop - 1);
	for (std::size_t index = 0; index != context->argument_count; ++index)
	{
		context->stage = NativeCallPhaseLeafStage::write_argument;
		context->failure_index = index;
		if (!native_call_phase_leaf_set_array(
				state, arguments_table_offset, index + 1,
				context->arguments[index])) return;
	}
	state->outtop = luau_restorestack(state, arguments_table_offset) + 1;

	std::ptrdiff_t results_table_offset = -1;
	if (context->after_phase)
	{
		context->stage = NativeCallPhaseLeafStage::create_results_table;
		luau_createtable(state, static_cast<int>(context->result_count), 0);
		results_table_offset = luau_savestack(state, state->outtop - 1);
		for (std::size_t index = 0; index != context->result_count; ++index)
		{
			context->stage = NativeCallPhaseLeafStage::write_result;
			context->failure_index = index;
			if (!native_call_phase_leaf_set_array(
					state, results_table_offset, index + 1,
					context->results[index])) return;
		}
		state->outtop = luau_restorestack(state, results_table_offset) + 1;
	}

	luau_TValue trace{};
	trace.type = LUAU_NIL;
	if (context->trace_requested && context->trace_registry_key != nullptr)
	{
		context->stage = NativeCallPhaseLeafStage::lookup_trace;
		const auto trace_base_offset = luau_savestack(state, state->outtop);
		getfield(state, -10000, context->trace_registry_key);
		auto* const trace_base = luau_restorestack(state, trace_base_offset);
		luau_Closure* trace_closure = nullptr;
		if (readable_lua_closure(trace_base[0], trace_closure)
			&& trace_closure->isC
			&& trace_closure->c.func == &diagnostic_trace_bridge)
		{
			trace = trace_base[0];
			context->trace_available = true;
		}
		else
		{
			// Preserve the previous lazy shared-global fallback without allocating
			// or rooting from C++ inside the raw leaf. The shared table itself roots
			// the owned bridge for the duration of this callback.
			state->outtop = trace_base;
			getfield(state, -10000, "_T");
			if (is_table(trace_base[0].type))
			{
				getfield(state, -1, "RENOVICE_TRACE");
				trace_closure = nullptr;
				if (readable_lua_closure(trace_base[1], trace_closure)
					&& trace_closure->isC
					&& trace_closure->c.func == &diagnostic_trace_bridge)
				{
					trace = trace_base[1];
					context->trace_available = true;
				}
			}
		}
		state->outtop = trace_base;
	}

	for (std::size_t provider = 0; provider != context->provider_count; ++provider)
	{
		context->stage = NativeCallPhaseLeafStage::lookup_provider;
		context->failure_index = provider;
		const auto lookup_base_offset = luau_savestack(state, state->outtop);
		luau_TValue callback{};
		if (!native_call_phase_leaf_callback(
				state, lookup_base_offset,
				context->provider_registry_keys[provider],
				context->method_name, context->phase, callback))
		{
			state->outtop = luau_restorestack(state, lookup_base_offset);
			continue;
		}
		state->outtop = luau_restorestack(state, lookup_base_offset);
		context->invoked = true;
		context->provider_invoked[provider] = 1;
		luau_TValue callback_arguments[5]{};
		callback_arguments[0].type = LUAU_NUMBER;
		callback_arguments[0].value.as_float = static_cast<float>(context->prototype);
		callback_arguments[1].type = LUAU_NUMBER;
		callback_arguments[1].value.as_float = static_cast<float>(context->instruction);
		callback_arguments[2] = *luau_restorestack(state, arguments_table_offset);
		if (context->after_phase)
			callback_arguments[3] = *luau_restorestack(state, results_table_offset);
		callback_arguments[native_provider_trace_argument_index(
			context->after_phase)] = trace;
		const auto callback_argument_count =
			native_provider_callback_argument_count(context->after_phase);
		context->stage = NativeCallPhaseLeafStage::invoke_provider;
		if (!lua_call_before_leaf_push_value(state, callback)) return;
		for (std::size_t index = 0; index != callback_argument_count; ++index)
			if (!lua_call_before_leaf_push_value(state, callback_arguments[index])) return;
		context->callback_status = protected_call(
			state, static_cast<int>(callback_argument_count), 0, 0);
		state->outtop = luau_restorestack(state, lookup_base_offset);
		if (context->callback_status != 0) return;
	}

	const auto table_offset = context->after_phase
		? results_table_offset : arguments_table_offset;
	const auto transformed_count = context->after_phase
		? context->result_count : context->argument_count;
	for (std::size_t index = 0; index != transformed_count; ++index)
	{
		context->stage = NativeCallPhaseLeafStage::read_value;
		context->failure_index = index;
		if (!native_call_phase_leaf_get_array(
				state, table_offset, index + 1, context->transformed[index])) return;
	}
	context->completed = true;
}
// END NATIVE_CALL_PHASE_PROTECTED_LEAF

const char* native_call_phase_leaf_stage_label(
	NativeCallPhaseLeafStage stage) noexcept
{
	switch (stage)
	{
	case NativeCallPhaseLeafStage::none: return "none";
	case NativeCallPhaseLeafStage::reserve_stack: return "reserve-stack";
	case NativeCallPhaseLeafStage::create_arguments_table: return "create-arguments-table";
	case NativeCallPhaseLeafStage::write_argument: return "write-argument";
	case NativeCallPhaseLeafStage::create_results_table: return "create-results-table";
	case NativeCallPhaseLeafStage::write_result: return "write-result";
	case NativeCallPhaseLeafStage::lookup_trace: return "lookup-trace";
	case NativeCallPhaseLeafStage::lookup_provider: return "lookup-provider";
	case NativeCallPhaseLeafStage::invoke_provider: return "invoke-provider";
	case NativeCallPhaseLeafStage::read_value: return "read-value";
	}
	return "unknown";
}

bool dispatch_native_call_phase(
	luau_State* state,
	const TargetCallsite& callsite,
	const char* method_name,
	const char* phase,
	std::vector<luau_TValue>& arguments,
	std::vector<luau_TValue>* results
)
{
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| luau_createtable == nullptr || method_name == nullptr || phase == nullptr)
	{
		return false;
	}
	const auto& providers = hook_addons_snapshot(
		callsite.target_key, state->global_state);
	if (providers.empty()) return true;
	if (arguments.size() > static_cast<std::size_t>((std::numeric_limits<int>::max)())
		|| (results != nullptr
			&& results->size() > static_cast<std::size_t>((std::numeric_limits<int>::max)())))
	{
		return false;
	}

	std::vector<const char*> provider_registry_keys;
	provider_registry_keys.reserve(providers.size());
	for (const auto& addon : providers)
		provider_registry_keys.push_back(addon.registry_key.c_str());
	std::vector<std::uint8_t> provider_invoked(providers.size(), 0);
	auto& values = results == nullptr ? arguments : *results;
	std::vector<luau_TValue> candidate(values.size());
	const auto flags = config::flags();
	const bool trace_requested = diagnostic_snapshot_capacity_available(flags)
		&& flags.diagnostics_method.empty() && flags.diagnostics_addon.empty()
		&& diagnostic_trace_selected(
			flags, callsite.target_key, "target.trace.callback", {});

	NativeCallPhaseLeafContext context;
	context.base_offset = luau_savestack(state, state->outtop);
	context.prototype = callsite.prototype;
	context.instruction = callsite.instruction;
	context.method_name = method_name;
	context.phase = phase;
	context.trace_registry_key = diagnostic_trace_registry_key.c_str();
	context.provider_registry_keys = provider_registry_keys.data();
	context.provider_invoked = provider_invoked.data();
	context.provider_count = provider_registry_keys.size();
	context.arguments = arguments.data();
	context.argument_count = arguments.size();
	context.results = results == nullptr ? nullptr : results->data();
	context.result_count = results == nullptr ? 0 : results->size();
	context.transformed = candidate.data();
	context.after_phase = results != nullptr;
	context.trace_requested = trace_requested;

	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	ScopedVmApiFrame frame_capacity(state);
	ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &native_call_phase_protected_leaf, &context);
	frame_capacity.restore();
	for (std::size_t index = 0; index != providers.size(); ++index)
	{
		if (provider_invoked[index] == 0) continue;
		const auto& addon = (*providers.addons)[index];
		const std::string provider_detail = std::string("method=") + method_name
			+ " phase=" + phase + " addon=" + addon.name
			+ " registry=" + addon.registry_key;
		trace_addon(state, callsite.target_key,
			"native.call.provider.enter", provider_detail);
		const bool this_provider_failed =
			(!protected_result.admitted || !protected_result.restored
				|| protected_result.status != 0 || !context.completed)
			&& context.failure_index == index;
		trace_addon(state, callsite.target_key,
			this_provider_failed ? "native.call.provider.error"
				: "native.call.provider.return", provider_detail);
	}
	if (!protected_result.admitted || !protected_result.restored
		|| protected_result.status != 0 || !context.completed)
	{
		std::ostringstream failure;
		failure << "RENOVICE nativeCalls protected leaf FAIL method=" << method_name
			<< " phase=" << phase
			<< " admitted=" << protected_result.admitted
			<< " restored=" << protected_result.restored
			<< " raw_status=" << protected_result.status
			<< " stage=" << native_call_phase_leaf_stage_label(context.stage)
			<< " index=" << context.failure_index
			<< " callback_status=" << context.callback_status
			<< " stock-retained=1";
		config::log(failure.str());
		trace_addon(state, callsite.target_key,
			"native.call.provider.error", failure.str());
		return false;
	}
	if (context.invoked) values = std::move(candidate);
	if (trace_requested && !context.trace_available
		&& !diagnostic_trace_callback_failure_logged.exchange(
			true, std::memory_order_relaxed))
	{
		config::diagnostic_log(
			"RENOVICE target trace callback unavailable in nativeCalls protected leaf",
			config::DiagnosticsMode::errors);
	}
	std::ostringstream detail;
	detail << "method=" << method_name << " phase=" << phase
		<< " providers=" << providers.size()
		<< " invoked=" << (context.invoked ? 1 : 0)
		<< " protected=1";
	trace_addon(state, callsite.target_key,
		"native.call.provider.return", detail.str());
	return true;
}

// Used only by the accepted lifecycle reset path. Native-call observers below
// use the destructor-free raw lookup instead.
bool automatic_damage_runtime_method(
	luau_State* state,
	const char* method,
	luau_TValue& output)
{
	output = {};
	output.type = LUAU_NIL;
	if (state == nullptr || state->outtop == nullptr || method == nullptr
		|| getfield == nullptr || check_stack == nullptr)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	getfield(state, -10000, automatic_damage_runtime_registry_key.c_str());
	auto* base = luau_restorestack(state, base_offset);
	if (!is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, method);
	base = luau_restorestack(state, base_offset);
	const bool valid = is_function((base + 1)->type);
	if (valid) output = *(base + 1);
	state->outtop = base;
	return valid;
}

std::atomic<std::uint64_t> caster_stats_sequence{0};
std::atomic<std::uint64_t> caster_stats_budget_used{0};
std::atomic<std::uint64_t> caster_calculation_budget_used{0};
std::atomic<std::uint64_t> caster_hud_budget_used{0};
std::atomic<bool> caster_stats_failure_logged{false};

struct ScopedAutomaticDamageTraceContext
{
	AutomaticDamageTraceContext previous;
	ScopedAutomaticDamageTraceContext(
		std::uint64_t sequence,
		const DiagnosticDamageCallsite& source,
		std::string_view target_type)
		: previous(automatic_damage_trace_context)
	{
		automatic_damage_trace_context.active = true;
		automatic_damage_trace_context.sequence = sequence;
		automatic_damage_trace_context.source = source;
		automatic_damage_trace_context.target_type = target_type;
	}
	~ScopedAutomaticDamageTraceContext() noexcept
	{
		automatic_damage_trace_context = std::move(previous);
	}
};

enum class NativeObserverProtectedKind : std::uint8_t
{
	automatic_before,
	automatic_after,
	caster_before,
	caster_after,
};

enum class NativeObserverProtectedStage : std::uint8_t
{
	none,
	lookup_callback,
	lookup_trace,
	create_values,
	write_value,
	push_method,
	invoke_callback,
	read_result,
};

struct NativeObserverProtectedContext
{
	NativeObserverProtectedKind kind = NativeObserverProtectedKind::automatic_before;
	const luau_TValue* values = nullptr;
	std::size_t value_count = 0;
	const char* runtime_registry_key = nullptr;
	const char* trace_registry_key = nullptr;
	const char* callback_method = nullptr;
	const char* method = nullptr;
	std::int32_t prototype = -1;
	std::uint32_t instruction = 0;
	std::int32_t damage_type = 0;
	float identifier = 0;
	float output = 0;
	bool damage_type_filter_set = false;
	bool diagnostics_buffs = false;
	bool passed = false;
	bool completed = false;
	NativeObserverProtectedStage stage = NativeObserverProtectedStage::none;
	std::size_t failure_index = 0;
	int callback_status = 0;
};
static_assert(std::is_trivially_copyable_v<NativeObserverProtectedContext>);

// BEGIN NATIVE_OBSERVER_PROTECTED_LEAF
// This entire path is below DE's raw protected boundary. It owns only scalars,
// raw pointers, and TValues. A DE longjmp skips no C++ destructor here; the
// shared raw wrapper restores the exact CallInfo and stack window.
bool native_observer_leaf_lookup(
	luau_State* state,
	std::ptrdiff_t base_offset,
	const char* registry_key,
	const char* method,
	luau_TValue& callback) noexcept
{
	callback = {};
	callback.type = LUAU_NIL;
	if (state == nullptr || registry_key == nullptr || method == nullptr
		|| getfield == nullptr
		|| !lua_call_stack_span_is_live(state, base_offset, 0)) return false;
	state->outtop = luau_restorestack(state, base_offset);
	getfield(state, -10000, registry_key);
	auto* base = luau_restorestack(state, base_offset);
	if (!is_table(base[0].type)) return false;
	getfield(state, -1, method);
	base = luau_restorestack(state, base_offset);
	if (!is_function(base[1].type)) return false;
	callback = base[1];
	state->outtop = base;
	return true;
}

bool native_observer_leaf_trace(
	luau_State* state,
	std::ptrdiff_t base_offset,
	const char* registry_key,
	luau_TValue& trace) noexcept
{
	trace = {};
	trace.type = LUAU_NIL;
	if (state == nullptr || registry_key == nullptr || getfield == nullptr
		|| !lua_call_stack_span_is_live(state, base_offset, 0)) return false;
	state->outtop = luau_restorestack(state, base_offset);
	getfield(state, -10000, registry_key);
	auto* const base = luau_restorestack(state, base_offset);
	luau_Closure* root = nullptr;
	const bool owned = readable_lua_closure(base[0], root)
		&& root->isC && root->c.func == &diagnostic_trace_bridge;
	if (owned) trace = base[0];
	state->outtop = base;
	return owned;
}

void native_observer_protected_leaf(luau_State* state, void* opaque)
{
	auto* const context = static_cast<NativeObserverProtectedContext*>(opaque);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| state->stack == nullptr || state->stack_last == nullptr
		|| context->runtime_registry_key == nullptr
		|| context->callback_method == nullptr
		|| getfield == nullptr || luau_createtable == nullptr
		|| protected_call == nullptr || gc_barrierback == nullptr
		|| !injected_interrupt_contract_ready
		|| (context->value_count != 0 && context->values == nullptr)
		|| context->value_count > static_cast<std::size_t>(
			(std::numeric_limits<int>::max)())
		|| (context->kind == NativeObserverProtectedKind::caster_before
			&& (context->trace_registry_key == nullptr
				|| context->method == nullptr || luau_pushstring == nullptr
				|| context->value_count > 1024))
		|| (context->kind == NativeObserverProtectedKind::automatic_before
			&& context->trace_registry_key == nullptr)
		|| !lua_call_before_leaf_reserve(state, 32)) return;

	const auto base_offset = luau_savestack(state, state->outtop);
	context->stage = NativeObserverProtectedStage::lookup_callback;
	luau_TValue callback{};
	if (!native_observer_leaf_lookup(
			state, base_offset, context->runtime_registry_key,
			context->callback_method, callback))
	{
		context->completed = true;
		state->outtop = luau_restorestack(state, base_offset);
		return;
	}

	luau_TValue trace{};
	trace.type = LUAU_NIL;
	const bool before = context->kind == NativeObserverProtectedKind::automatic_before
		|| context->kind == NativeObserverProtectedKind::caster_before;
	if (before)
	{
		context->stage = NativeObserverProtectedStage::lookup_trace;
		if (!native_observer_leaf_trace(
				state, base_offset, context->trace_registry_key, trace))
		{
			context->completed = true;
			state->outtop = luau_restorestack(state, base_offset);
			return;
		}
	}

	context->stage = NativeObserverProtectedStage::create_values;
	state->outtop = luau_restorestack(state, base_offset);
	luau_createtable(state, static_cast<int>(context->value_count), 0);
	const auto values_table_offset = luau_savestack(state, state->outtop - 1);
	for (std::size_t index = 0; index != context->value_count; ++index)
	{
		context->stage = NativeObserverProtectedStage::write_value;
		context->failure_index = index;
		if (!native_call_phase_leaf_set_array(
				state, values_table_offset, index + 1,
				context->values[index])) return;
	}
	state->outtop = luau_restorestack(state, values_table_offset) + 1;

	luau_TValue callback_arguments[5]{};
	std::size_t callback_argument_count = 0;
	int result_count = 0;
	if (context->kind == NativeObserverProtectedKind::automatic_before)
	{
		callback_argument_count = 5;
		result_count = 1;
		callback_arguments[0] = trace;
		callback_arguments[1].type = LUAU_NUMBER;
		callback_arguments[1].value.as_float =
			static_cast<float>(context->prototype);
		callback_arguments[2].type = LUAU_NUMBER;
		callback_arguments[2].value.as_float =
			static_cast<float>(context->instruction);
		callback_arguments[3] = *luau_restorestack(state, values_table_offset);
		if (context->damage_type_filter_set)
		{
			callback_arguments[4].type = LUAU_NUMBER;
			callback_arguments[4].value.as_float =
				static_cast<float>(context->damage_type);
		}
		else callback_arguments[4].type = LUAU_NIL;
	}
	else if (context->kind == NativeObserverProtectedKind::caster_before)
	{
		callback_argument_count = 5;
		result_count = 1;
		callback_arguments[0] = trace;
		callback_arguments[1].type = LUAU_NUMBER;
		callback_arguments[1].value.as_float = context->identifier;
		context->stage = NativeObserverProtectedStage::push_method;
		if (luau_pushstring(state, context->method) == nullptr) return;
		callback_arguments[2] = state->outtop[-1];
		callback_arguments[3] = *luau_restorestack(state, values_table_offset);
		callback_arguments[4].type = LUAU_BOOL;
		callback_arguments[4].value.as_bool = context->diagnostics_buffs;
	}
	else
	{
		callback_argument_count = 2;
		callback_arguments[0].type = LUAU_NUMBER;
		callback_arguments[0].value.as_float = context->identifier;
		callback_arguments[1] = *luau_restorestack(state, values_table_offset);
	}

	const auto call_offset = luau_savestack(state, state->outtop);
	context->stage = NativeObserverProtectedStage::invoke_callback;
	if (!lua_call_before_leaf_push_value(state, callback)) return;
	for (std::size_t index = 0; index != callback_argument_count; ++index)
		if (!lua_call_before_leaf_push_value(
				state, callback_arguments[index])) return;
	automatic_damage_runtime_running = true;
	context->callback_status = protected_call(
		state, static_cast<int>(callback_argument_count), result_count, 0);
	automatic_damage_runtime_running = false;
	auto* const call_base = luau_restorestack(state, call_offset);
	if (context->callback_status == 0)
	{
		if (result_count == 0)
		{
			context->passed = state->outtop == call_base;
		}
		else
		{
			context->stage = NativeObserverProtectedStage::read_result;
			context->passed = state->outtop == call_base + 1
				&& call_base[0].type == LUAU_NUMBER
				&& std::isfinite(call_base[0].value.as_float);
			if (context->passed) context->output = call_base[0].value.as_float;
		}
	}
	state->outtop = luau_restorestack(state, base_offset);
	context->completed = true;
}
// END NATIVE_OBSERVER_PROTECTED_LEAF

bool run_native_observer_protected(
	luau_State* state,
	NativeObserverProtectedContext& context) noexcept
{
	if (state == nullptr) return false;
	ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);
	const auto result = de_vm_authority::run_current_vm_protected(
		state, &native_observer_protected_leaf, &context);
	// A raw VM escape may skip the diagnostic helper's scalar recursion guard.
	// The shared raw wrapper has already restored the exact game frame here.
	automatic_damage_runtime_running = false;
	return result.admitted && result.restored && result.status == 0
		&& context.completed && context.passed;
}

// Bounded native getter evidence shares the existing diagnostics toggle. The
// observer's own getter calls have a separate budget from calls made by stock.
std::atomic<std::uint64_t> buff_native_stock_sequence{0};
std::atomic<std::uint64_t> buff_native_observer_sequence{0};
std::atomic<bool> buff_native_stock_suppressed{false};
std::atomic<bool> buff_native_observer_suppressed{false};
std::atomic<std::uint64_t> hud_native_stock_sequence{0};
std::atomic<std::uint64_t> hud_native_observer_sequence{0};
std::atomic<bool> hud_native_stock_suppressed{false};
std::atomic<bool> hud_native_observer_suppressed{false};

struct NativeBuffProbe
{
    std::uint64_t sequence = 0;
    std::size_t slot = 0;
    bool observer = false;
    bool sampled = false;
    const char* method = "GetBuffNotifications";
};

void log_native_buff_probe(const NativeBuffProbe& probe, const char* event,
    const char* reason, luau_State* state, int returned = -1) noexcept
{
    if (!probe.sampled) return;
    try {
        int result_tag = -1;
        if (returned > 0 && state != nullptr && state->intop != nullptr
            && state->outtop != nullptr && state->outtop >= state->intop
            && state->outtop - state->intop >= returned)
            result_tag = (state->outtop - returned)->type;
        std::ostringstream message;
        message << "RENOVICE BUFF_NATIVE build=V87 pid=" << GetCurrentProcessId()
            << " vm=" << (state == nullptr ? nullptr : state->global_state)
            << " tick_ms=" << GetTickCount64() << " event=" << event
            << " sequence=" << probe.sequence << " binding_slot=" << probe.slot
            << " method=" << probe.method
            << " lane=" << (probe.observer ? "observer" : "stock")
            << " reentrant=" << native_call_hook_running
            << " observer_running=" << automatic_damage_runtime_running
            << " reason=" << reason << " returned_count=" << returned
            << " result0_tag=" << result_tag;
        config::diagnostic_log(message.str(), config::DiagnosticsMode::battle);
    } catch (...) { /* Diagnostics must preserve the stock call/result. */ }
}

NativeBuffProbe begin_native_buff_probe(const config::Flags& flags,
    const std::string& method, std::size_t slot, luau_State* state) noexcept
{
    NativeBuffProbe probe;
    if (!universal_buffs_requested(flags)
        || (method != "GetBuffNotifications" && method != "GetHudStatus")) return probe;
    const bool hud_owner = method == "GetHudStatus";
    probe.method = hud_owner ? "GetHudStatus" : "GetBuffNotifications";
    probe.slot = slot;
    probe.observer = native_call_hook_running || automatic_damage_runtime_running;
    auto& counter = hud_owner
        ? (probe.observer ? hud_native_observer_sequence : hud_native_stock_sequence)
        : (probe.observer ? buff_native_observer_sequence : buff_native_stock_sequence);
    auto& suppressed = hud_owner
        ? (probe.observer ? hud_native_observer_suppressed : hud_native_stock_suppressed)
        : (probe.observer ? buff_native_observer_suppressed : buff_native_stock_suppressed);
    probe.sequence = counter.fetch_add(1, std::memory_order_relaxed) + 1;
    probe.sampled = sample_native_ingress(probe.sequence, flags.diagnostics_max_events);
    if (!probe.sampled && !suppressed.exchange(true)) {
        probe.sampled = true;
        log_native_buff_probe(probe, "suppressed", "getter-probe-budget-exhausted", state);
        probe.sampled = false;
    }
    log_native_buff_probe(probe, "ingress", "native-getter-entered", state);
    return probe;
}

struct NativeCallOriginalPlan
{
	bool active = false;
	bool provider_selected = false;
	bool automatic_selected = false;
	bool caster_selected = false;
	bool buffs_selected = false;
	bool diagnostics_buffs = false;
	std::size_t slot = 0;
	std::uint64_t generation = 0;
	TargetCallsite provider_callsite{};
	TargetCallsite diagnostic_callsite{};
	std::ptrdiff_t argument_base_offset = -1;
	std::ptrdiff_t argument_top_offset = -1;
	std::size_t argument_count = 0;
	std::uint64_t argument_fingerprint = 0;
	std::uint64_t automatic_sequence = 0;
	float automatic_transaction = 0;
	float caster_snapshot = 0;
	NativeBuffProbe buff_probe{};
	std::uint64_t boundary_token = 0;
};
static_assert(std::is_trivially_copyable_v<NativeCallOriginalPlan>);
static_assert(std::is_trivially_copyable_v<NativeBuffProbe>);

std::uint64_t native_call_value_fingerprint(
	const luau_TValue* values,
	std::size_t count) noexcept
{
	if (values == nullptr && count != 0) return 0;
	std::uint64_t hash = 1469598103934665603ull;
	for (std::size_t index = 0; index != count; ++index)
	{
		hash ^= static_cast<std::uint64_t>(values[index].type);
		hash *= 1099511628211ull;
		hash ^= static_cast<std::uint64_t>(values[index].value.as_uintptr);
		hash *= 1099511628211ull;
	}
	hash ^= static_cast<std::uint64_t>(count);
	hash *= 1099511628211ull;
	return hash;
}

bool native_call_arguments_live(
	const NativeCallOriginalPlan& plan,
	luau_State* state,
	std::vector<luau_TValue>& arguments) noexcept
{
	arguments.clear();
	if (!plan.active || state == nullptr || state->intop == nullptr
		|| plan.argument_base_offset < 0
		|| !lua_call_stack_span_is_live(
			state, plan.argument_base_offset, plan.argument_count)
		|| luau_savestack(state, state->intop) != plan.argument_base_offset)
	{
		return false;
	}
	auto* const base = luau_restorestack(state, plan.argument_base_offset);
	if (native_call_value_fingerprint(base, plan.argument_count)
		!= plan.argument_fingerprint) return false;
	try
	{
		arguments.assign(base, base + plan.argument_count);
		return true;
	}
	catch (...)
	{
		arguments.clear();
		return false;
	}
}

int native_call_adapter(luau_State* state, std::size_t slot)
{
	luau_CFunction original = nullptr;
	{
		std::lock_guard hook_lock(native_call_hook_mutex);
		if (slot < native_call_hooks.size() && native_call_hooks[slot] != nullptr)
		{
			const auto& record = *native_call_hooks[slot];
			original = record.hook.isCreated()
				? reinterpret_cast<luau_CFunction>(record.hook.original)
				: record.target;
		}
	}
	if (original == nullptr) return 0;

	const bool reentrant = prepare_native_call_boundary_entry(state);
	const auto previous_boundary = active_native_call_boundary;
	NativeCallOriginalPlan plan;
	try
	{
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		if (generation_dispatch && !reentrant && state != nullptr
			&& state->intop != nullptr && state->outtop != nullptr)
		{
			std::lock_guard hook_lock(native_call_hook_mutex);
			if (slot < native_call_hooks.size() && native_call_hooks[slot] != nullptr)
			{
				const auto& record = *native_call_hooks[slot];
				const auto current_original = record.hook.isCreated()
					? reinterpret_cast<luau_CFunction>(record.hook.original)
					: record.target;
				if (current_original == original)
				{
					const auto flags = config::flags();
					const auto* global_state = state->global_state;
					const bool method_requested =
						diagnostics_claims_native_method(flags, record.name)
						|| any_target_provider_claims_native_method(
							global_state, record.name);
					if (method_requested)
					{
						TargetCallsite callsite;
						DiagnosticDamageCallsite diagnostic_source;
						const auto buff_probe = begin_native_buff_probe(
							flags, record.name, slot, state);
						if (observe_target_addons.load(std::memory_order_acquire))
							callsite = target_callsite_for_active_call_stack(state);
						if (universal_observer_requested(flags))
							diagnostic_source = diagnostic_damage_callsite_for_active_stack(state);
						trace_native_call_ingress(
							state, slot, record, original, callsite, false);
						const int argument_count = luau_gettop(state);
						if (argument_count >= 0)
						{
							const auto argument_base_offset = luau_savestack(state, state->intop);
							const auto argument_top_offset = luau_savestack(state, state->outtop);
							std::vector<luau_TValue> arguments(
								state->intop, state->intop + argument_count);
							const auto stock_arguments = arguments;
							const auto target_type = arguments.empty()
								? std::string{} : engine_object_type_name(arguments[0]);
							const bool provider_selected = callsite.exact
								&& target_provider_claims_native_method(
									callsite.target_key, state->global_state, record.name);
							const bool observer_capacity = diagnostic_snapshot_capacity_available(flags);
							const bool caster_selected = observer_capacity &&
								flags.diagnostics_caster_stats
								&& automatic_scripted_damage_requested(flags)
								&& !automatic_damage_runtime_running
								&& (record.name == "SetSource" || record.name == "DamageDD"
									|| record.name == "RadialDamage" || record.name == "ModifyValue"
									|| record.name == "GetUpgradeModifiedValue")
								&& flags.diagnostics_addon.empty()
								&& (!flags.diagnostics_target_filter_set
									|| (flags.diagnostics_target_filter_valid
										&& diagnostic_source.callsite.target_key
											== flags.diagnostics_target_key))
								&& (flags.diagnostics_damage_source.empty()
									|| config::ascii_lower(diagnostic_source.module_path)
										== flags.diagnostics_damage_source
									|| config::ascii_lower(diagnostic_source.module_name)
										== flags.diagnostics_damage_source)
								&& (record.name == "SetSource" || record.name == "ModifyValue"
									|| record.name == "GetUpgradeModifiedValue"
									|| flags.diagnostics_method.empty()
									|| config::ascii_lower(record.name) == flags.diagnostics_method)
								&& (record.name != "DamageDD"
									|| flags.diagnostics_damage_target_type.empty()
									|| config::ascii_lower(target_type)
										== flags.diagnostics_damage_target_type);
							bool automatic_selected = observer_capacity &&
								arguments.size() >= 2
								&& automatic_scripted_damage_selected(
									flags, record.name,
									diagnostic_source.callsite.target_key,
									diagnostic_source.module_path,
									diagnostic_source.module_name,
									target_type);
							if (automatic_selected && provider_selected)
							{
								automatic_selected = false;
								if (!automatic_damage_duplicate_suppression_logged.exchange(
										true, std::memory_order_relaxed))
								{
									std::ostringstream suppressed;
									suppressed << "RENOVICE AUTO_DAMAGE build=V79 event=suppressed"
										<< " reason=exact-target-provider-owns-method"
										<< " method=" << record.name
										<< " source_body=0x" << std::hex
										<< diagnostic_source.callsite.target_key << std::dec;
									config::diagnostic_log(
										suppressed.str(), config::DiagnosticsMode::battle);
								}
							}
							const bool buffs_selected = observer_capacity &&
								universal_buffs_requested(flags)
								&& !automatic_damage_runtime_running
								&& (record.name == "GetBuffNotifications"
									|| record.name == "GetHudStatus")
								&& flags.diagnostics_addon.empty()
								&& (!flags.diagnostics_target_filter_set
									|| (flags.diagnostics_target_filter_valid
										&& diagnostic_source.callsite.target_key
											== flags.diagnostics_target_key))
								&& (flags.diagnostics_method.empty()
									|| flags.diagnostics_method
										== config::ascii_lower(record.name))
								&& (flags.diagnostics_damage_source.empty()
									|| config::ascii_lower(diagnostic_source.module_path)
										== flags.diagnostics_damage_source
									|| config::ascii_lower(diagnostic_source.module_name)
										== flags.diagnostics_damage_source);
							const bool engine_capture =
								flags.diagnostics_damage_capture
									== config::DamageCaptureMode::engine;
							const char* buff_selection_reason = buffs_selected
								? "buff-observer-selected"
								: automatic_damage_runtime_running ? "observer-self-call"
								: !flags.diagnostics_addon.empty() ? "addon-filter"
								: flags.diagnostics_target_filter_set
									&& (!flags.diagnostics_target_filter_valid
										|| diagnostic_source.callsite.target_key
											!= flags.diagnostics_target_key) ? "body-filter"
								: !flags.diagnostics_method.empty()
									&& flags.diagnostics_method
										!= config::ascii_lower(record.name) ? "method-filter"
								: !flags.diagnostics_damage_source.empty()
									? "source-filter" : "capture-not-requested";
							log_native_buff_probe(
								buff_probe, "selection", buff_selection_reason, state);

							const bool needs_boundary = provider_selected
								|| automatic_selected || caster_selected || buffs_selected
								|| engine_capture || buff_probe.sampled;
							if (needs_boundary)
							{
								const auto boundary = make_native_call_boundary(
									state, active_generation);
								if (boundary.active)
								{
									active_native_call_boundary = boundary;
									native_call_hook_running = true;
									plan.active = true;
									plan.slot = slot;
									plan.generation = active_generation;
									plan.provider_selected = provider_selected;
									plan.automatic_selected = automatic_selected;
									plan.caster_selected = caster_selected;
									plan.buffs_selected = buffs_selected;
									plan.diagnostics_buffs = flags.diagnostics_buffs;
									plan.provider_callsite = callsite;
									plan.diagnostic_callsite = diagnostic_source.callsite;
									plan.argument_base_offset = argument_base_offset;
									plan.argument_top_offset = argument_top_offset;
									plan.argument_count = arguments.size();
									plan.buff_probe = buff_probe;
									plan.boundary_token = boundary.token;

									if (provider_selected)
									{
										std::ostringstream before_details;
										before_details << "method=" << record.name
											<< " phase=before prototype=" << callsite.prototype
											<< " instruction=" << callsite.instruction
											<< " values=arguments";
										trace_addon(state, callsite.target_key,
											"native.call.before", before_details.str(),
											arguments.data(), arguments.size());
										if (dispatch_native_call_phase(
												state, callsite, record.name.c_str(),
												"before", arguments, nullptr))
										{
											state->intop = luau_restorestack(
												state, argument_base_offset);
											state->outtop = luau_restorestack(
												state, argument_top_offset);
											prepare_stack_write(state);
											std::copy(arguments.begin(), arguments.end(), state->intop);
										}
										else
										{
											state->intop = luau_restorestack(
												state, argument_base_offset);
											state->outtop = luau_restorestack(
												state, argument_top_offset);
											prepare_stack_write(state);
											std::copy(stock_arguments.begin(),
												stock_arguments.end(), state->intop);
											arguments = stock_arguments;
											trace_addon(state, callsite.target_key,
												"native.call.before.reject",
												"method=" + record.name
													+ " stock_arguments_restored=1");
										}
									}

									if (plan.automatic_selected)
									{
										plan.automatic_sequence = automatic_damage_sequence.fetch_add(
											1, std::memory_order_relaxed) + 1;
										const auto transaction_budget = (std::max)(
											std::uint64_t{1}, (std::min)(
												std::uint64_t{4096},
												flags.diagnostics_max_events / 10));
										if (plan.automatic_sequence > transaction_budget)
										{
											plan.automatic_selected = false;
											if (!automatic_damage_budget_suppression_logged.exchange(
													true, std::memory_order_relaxed))
											{
												std::ostringstream suppressed;
												suppressed << "RENOVICE AUTO_DAMAGE build=V79 event=suppressed"
													<< " reason=transaction-budget-exhausted limit="
													<< transaction_budget;
												config::diagnostic_log(
													suppressed.str(), config::DiagnosticsMode::battle);
											}
										}
									}
									if (plan.automatic_selected)
									{
										ScopedAutomaticDamageTraceContext automatic_context(
											plan.automatic_sequence, diagnostic_source, target_type);
										NativeObserverProtectedContext observer;
										observer.kind = NativeObserverProtectedKind::automatic_before;
										observer.values = arguments.data();
										observer.value_count = arguments.size();
										observer.runtime_registry_key =
											automatic_damage_runtime_registry_key.c_str();
										observer.trace_registry_key =
											diagnostic_trace_registry_key.c_str();
										observer.callback_method = "before";
										observer.prototype =
											diagnostic_source.callsite.prototype;
										observer.instruction =
											diagnostic_source.callsite.instruction;
										observer.damage_type_filter_set =
											flags.diagnostics_damage_type_filter_set;
										observer.damage_type = flags.diagnostics_damage_type;
										if (!run_native_observer_protected(state, observer)
											&& !automatic_damage_runtime_failure_logged.exchange(
												true, std::memory_order_relaxed))
										{
											config::diagnostic_log(
												"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=before",
												config::DiagnosticsMode::errors);
										}
										plan.automatic_transaction = observer.output;
									}

									if (plan.caster_selected || plan.buffs_selected)
									{
										const auto lane = caster_diagnostic_lane(record.name);
										const bool calculation =
											lane == CasterDiagnosticLane::calculation;
										auto& budget = lane == CasterDiagnosticLane::hud
											? caster_hud_budget_used
											: calculation ? caster_calculation_budget_used
												: caster_stats_budget_used;
										const auto used = budget.fetch_add(
											1, std::memory_order_relaxed) + 1;
										const auto limit = caster_diagnostic_limit(
											lane, flags.diagnostics_max_events);
										if (used <= limit)
										{
											const auto id = caster_stats_sequence.fetch_add(
												1, std::memory_order_relaxed) + 1;
											if (id <= 16777215)
											{
												ScopedAutomaticDamageTraceContext context(
													id, diagnostic_source, target_type);
												NativeObserverProtectedContext observer;
												observer.kind = NativeObserverProtectedKind::caster_before;
												observer.values = arguments.data();
												observer.value_count = arguments.size();
												observer.runtime_registry_key =
													automatic_damage_runtime_registry_key.c_str();
												observer.trace_registry_key =
													diagnostic_trace_registry_key.c_str();
												observer.callback_method = "casterBefore";
												observer.method = record.name.c_str();
												observer.identifier = static_cast<float>(id);
												observer.diagnostics_buffs = flags.diagnostics_buffs;
												if (!run_native_observer_protected(state, observer)
													&& !caster_stats_failure_logged.exchange(true))
													config::diagnostic_log(
														"RENOVICE CASTER_STATS build=V82 event=failed phase=before",
														config::DiagnosticsMode::errors);
												plan.caster_snapshot = observer.output;
											}
											else if (id == 16777216)
												config::diagnostic_log(
													"RENOVICE CASTER_STATS build=V86 event=suppressed reason=exact-float-id-exhausted",
													config::DiagnosticsMode::errors);
										}
										else if (used == limit + 1)
										{
											config::diagnostic_log(
												std::string("RENOVICE CASTER_STATS build=V88 event=suppressed lane=")
												+ (lane == CasterDiagnosticLane::hud ? "hud"
													: calculation ? "calculation" : "combat")
												+ " reason=snapshot-budget-exhausted limit="
												+ std::to_string(limit), config::DiagnosticsMode::battle);
										}
										log_native_buff_probe(buff_probe, "observer-before",
											plan.caster_snapshot > 0
												? "callback-pending-root-ready"
												: "callback-unavailable-or-rejected", state);
									}

									state->intop = luau_restorestack(
										state, argument_base_offset);
									state->outtop = luau_restorestack(
										state, argument_top_offset);
									plan.argument_fingerprint = native_call_value_fingerprint(
										state->intop, plan.argument_count);
									if (engine_capture)
									{
										engine_damage::Source native_source;
										native_source.body = diagnostic_source.callsite.target_key;
										native_source.caster_snapshot =
											std::isfinite(plan.caster_snapshot)
											&& plan.caster_snapshot > 0
											? static_cast<std::uint64_t>(plan.caster_snapshot) : 0;
										native_source.prototype = diagnostic_source.callsite.prototype;
										native_source.instruction = diagnostic_source.callsite.instruction;
										native_source.vm = state->global_state;
										native_source.path = diagnostic_source.module_path;
										native_source.name = diagnostic_source.module_name;
										native_source.method = record.name;
										if (engine_damage::publish_source(&native_source))
											active_native_call_boundary.engine_source_published = true;
										else config::diagnostic_log(
											"RENOVICE ENGINE_DAMAGE event=source-publish-failed stock-retained=1",
											config::DiagnosticsMode::errors);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	catch (...)
	{
		if (plan.active)
			finish_native_call_boundary(
				plan.boundary_token, previous_boundary, state);
		plan = {};
		config::diagnostic_log(
			"RENOVICE nativeCalls preflight failed; stock retained",
			config::DiagnosticsMode::errors);
	}

	// Intentionally naked. Every mutex, generation lease, vector, string,
	// diagnostic scope, and source staging object has ended. DE keeps exact
	// ownership of stock error propagation; only the POD boundary and copied
	// process-owned engine source remain recoverable after a longjmp.
	const int result_count = original(state);

	if (!plan.active) return result_count;

	try
	{
		log_native_buff_probe(
			plan.buff_probe, "return", "stock-result-before-observer",
			state, result_count);
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		std::string method;
		if (generation_dispatch && active_generation == plan.generation
			&& native_call_boundary_is_live(active_native_call_boundary, state)
			&& active_native_call_boundary.token == plan.boundary_token)
		{
			{
				std::lock_guard hook_lock(native_call_hook_mutex);
				if (plan.slot < native_call_hooks.size()
					&& native_call_hooks[plan.slot] != nullptr)
				{
					const auto& record = *native_call_hooks[plan.slot];
					const auto current_original = record.hook.isCreated()
						? reinterpret_cast<luau_CFunction>(record.hook.original)
						: record.target;
					if (current_original == original) method = record.name;
				}
			}
			std::vector<luau_TValue> arguments;
			if (!method.empty() && native_call_arguments_live(plan, state, arguments))
			{
				DiagnosticDamageCallsite diagnostic_source =
					diagnostic_damage_callsite_for_active_stack(state);
				diagnostic_source.callsite = plan.diagnostic_callsite;
				const auto target_type = arguments.empty()
					? std::string{} : engine_object_type_name(arguments[0]);
				std::vector<luau_TValue> results;
				bool results_valid = false;
				const bool result_count_available = result_count >= 0
					&& state->intop != nullptr && state->outtop != nullptr
					&& state->outtop >= state->intop
					&& static_cast<std::size_t>(result_count)
						<= static_cast<std::size_t>(state->outtop - state->intop);
				const auto result_base_offset = result_count_available
					? luau_savestack(state, state->outtop - result_count) : -1;
				const auto result_top_offset = result_count_available
					? luau_savestack(state, state->outtop) : -1;
				const bool result_window_live = result_count_available
					&& lua_call_stack_span_is_live(
						state, result_base_offset,
						static_cast<std::size_t>(result_count));
				if (result_window_live)
				{
					results_valid = true;
					results.assign(state->outtop - result_count, state->outtop);
					if (plan.caster_snapshot > 0)
					{
						const auto result_intop_offset = luau_savestack(state, state->intop);
						ScopedAutomaticDamageTraceContext context(
							static_cast<std::uint64_t>(plan.caster_snapshot),
							diagnostic_source, target_type);
						NativeObserverProtectedContext observer;
						observer.kind = NativeObserverProtectedKind::caster_after;
						observer.values = results.data();
						observer.value_count = results.size();
						observer.runtime_registry_key =
							automatic_damage_runtime_registry_key.c_str();
						observer.callback_method = "casterAfter";
						observer.identifier = plan.caster_snapshot;
						if (!run_native_observer_protected(state, observer)
							&& !caster_stats_failure_logged.exchange(true))
							config::diagnostic_log(
								"RENOVICE CASTER_STATS build=V82 event=failed phase=after",
								config::DiagnosticsMode::errors);
						state->intop = luau_restorestack(state, result_intop_offset);
						state->outtop = luau_restorestack(state, result_top_offset);
						log_native_buff_probe(plan.buff_probe, "observer-after",
							"callback-returned", state);
					}
					if (plan.automatic_transaction > 0)
					{
						ScopedAutomaticDamageTraceContext context(
							plan.automatic_sequence, diagnostic_source, target_type);
						NativeObserverProtectedContext observer;
						observer.kind = NativeObserverProtectedKind::automatic_after;
						observer.values = results.data();
						observer.value_count = results.size();
						observer.runtime_registry_key =
							automatic_damage_runtime_registry_key.c_str();
						observer.callback_method = "after";
						observer.identifier = plan.automatic_transaction;
						if (!run_native_observer_protected(state, observer)
							&& !automatic_damage_runtime_failure_logged.exchange(
								true, std::memory_order_relaxed))
							config::diagnostic_log(
								"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=after",
								config::DiagnosticsMode::errors);
					}
					if (plan.provider_selected)
					{
						std::ostringstream after_details;
						after_details << "method=" << method
							<< " phase=after prototype="
							<< plan.provider_callsite.prototype
							<< " instruction=" << plan.provider_callsite.instruction
							<< " values=results";
						trace_addon(state, plan.provider_callsite.target_key,
							"native.call.after", after_details.str(),
							results.data(), results.size());
						if (dispatch_native_call_phase(
								state, plan.provider_callsite, method.c_str(),
								"after", arguments, &results))
						{
							state->outtop = luau_restorestack(state, result_top_offset);
							prepare_stack_write(state);
							std::copy(results.begin(), results.end(),
								luau_restorestack(state, result_base_offset));
						}
						else
						{
							state->outtop = luau_restorestack(state, result_top_offset);
							trace_addon(state, plan.provider_callsite.target_key,
								"native.call.after.reject",
								"method=" + method + " stock_results_retained=1");
						}
					}
				}
				else if (plan.automatic_transaction > 0)
				{
					ScopedAutomaticDamageTraceContext context(
						plan.automatic_sequence, diagnostic_source, target_type);
					NativeObserverProtectedContext observer;
					observer.kind = NativeObserverProtectedKind::automatic_after;
					observer.values = results.data();
					observer.value_count = results.size();
					observer.runtime_registry_key =
						automatic_damage_runtime_registry_key.c_str();
					observer.callback_method = "after";
					observer.identifier = plan.automatic_transaction;
					if (!run_native_observer_protected(state, observer)
						&& !automatic_damage_runtime_failure_logged.exchange(
							true, std::memory_order_relaxed))
						config::diagnostic_log(
							"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=after-invalid-results",
							config::DiagnosticsMode::errors);
				}
				if (plan.provider_selected)
				{
					const std::string event = std::string("nativeCalls.") + method;
					std::ostringstream details;
					details << "method=" << method
						<< " prototype=" << plan.provider_callsite.prototype
						<< " instruction=" << plan.provider_callsite.instruction
						<< " arguments=" << plan.argument_count
						<< " results=" << result_count
						<< " results_valid=" << (results_valid ? 1 : 0);
					log_native_hook_once(
						state, plan.provider_callsite.target_key, event.c_str());
					trace_addon(state, plan.provider_callsite.target_key,
						"native.call.return", details.str());
				}
			}
		}
	}
	catch (...)
	{
		config::diagnostic_log(
			"RENOVICE nativeCalls post phase failed; stock result retained",
			config::DiagnosticsMode::errors);
	}
	if (active_native_call_boundary.engine_source_published)
	{
		engine_damage::clear_source();
		active_native_call_boundary.engine_source_published = false;
	}
	finish_native_call_boundary(
		plan.boundary_token, previous_boundary, state);
	return result_count;
}

template <std::size_t Slot>
int native_call_adapter_slot(luau_State* state)
{
	return native_call_adapter(state, Slot);
}

template <std::size_t... Slots>
constexpr std::array<luau_CFunction, sizeof...(Slots)>
make_native_call_adapters(std::index_sequence<Slots...>)
{
	return {&native_call_adapter_slot<Slots>...};
}

constexpr auto native_call_adapters = make_native_call_adapters(
	std::make_index_sequence<maximum_native_call_hooks>{});

int push_float_arg_adapter(luau_State* state)
{
	const auto original = push_float_arg_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(push_float_arg_native_hook.original)
		: original_push_float_arg;
	if (original == nullptr) return 0;
	{
		// Every lease, provider snapshot, recursion marker, and log owner ends
		// before the stock C callback. A DE Lua error may longjmp out of stock.
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		if (generation_dispatch && state != nullptr && state->intop != nullptr
			&& target_snapshot_requests_native_callsite(state->global_state)
			&& !float_argument_transform_running
			&& luau_gettop(state) >= 2 && state->intop[1].type == LUAU_NUMBER)
		{
			const auto callsite = target_callsite_for_active_call_stack(state);
			if (callsite.exact)
			{
				const auto& providers = hook_addons_snapshot(
					callsite.target_key, state->global_state);
				if (!providers.empty())
				{
					struct ScopedTransform
					{
						ScopedTransform() noexcept
						{
							float_argument_transform_running = true;
						}
						~ScopedTransform() noexcept
						{
							float_argument_transform_running = false;
						}
					} transform_scope;
					const float stock_value = state->intop[1].value.as_float;
					float transformed_value = stock_value;
					for (const auto& addon : providers)
					{
						luau_TValue transform{};
						if (!lifecycle_hook_value(
								state, addon, "transformFloatArgument", transform))
						{
							continue;
						}
						luau_TValue arguments[3]{};
						for (auto& argument : arguments) argument.type = LUAU_NUMBER;
						arguments[0].value.as_float = static_cast<float>(callsite.prototype);
						arguments[1].value.as_float = static_cast<float>(callsite.instruction);
						arguments[2].value.as_float = transformed_value;
						float candidate = transformed_value;
						if (call_number_value(
								state, transform, arguments, std::size(arguments),
								"transformFloatArgument", candidate))
						{
							transformed_value = candidate;
						}
					}
					if (transformed_value != stock_value)
					{
						state->intop[1].value.as_float = transformed_value;
						log_native_hook_once(
							state, callsite.target_key,
							"PushFloatArg.instruction-transform");
						std::ostringstream details;
						details << "prototype=" << callsite.prototype
							<< " instruction=" << callsite.instruction
							<< " stock=" << stock_value
							<< " transformed=" << transformed_value;
						trace_addon(
							state, callsite.target_key,
							"native.float.transform", details.str());
					}
				}
			}
		}
	}

	// Intentionally naked: no RENOVICE lease, snapshot, TLS guard, string,
	// stream, or other destructor-owned state crosses the stock callback.
	return original(state);
}

int run_script_observer_adapter(luau_State* state)
{
	const auto original = run_script_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(run_script_native_hook.original)
		: original_run_script;
	if (original == nullptr) return 0;

	struct RunScriptOriginalPlan
	{
		bool observe_ability_card = false;
		bool install_boundary = false;
		std::uint64_t generation = 0;
		std::uint64_t sequence = 0;
		void* before_global_state = nullptr;
		std::uint32_t owner_thread = 0;
		std::uint32_t argument_tags[4]{};
		std::uintptr_t argument_values[4]{};
		AbilityCardQueryObservation query{};
		ActiveRunScriptBoundary previous_boundary{};
		ActiveRunScriptBoundary boundary{};
	};
	static_assert(std::is_trivially_copyable_v<RunScriptOriginalPlan>);
	RunScriptOriginalPlan plan;
	const bool reentrant = prepare_run_script_boundary_entry(state);
	plan.previous_boundary = active_run_script_boundary;

	{
		// The admission lease protects only RENOVICE's before-phase inspection.
		// It is deliberately destroyed before the stock RunScript callback.
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		if (generation_dispatch)
		{
			plan.generation = active_generation;
			const bool enabled = observe_target_addons.load(
				std::memory_order_acquire);
			const int argument_count = state != nullptr && state->intop != nullptr
				&& state->outtop != nullptr ? luau_gettop(state) : 0;
			const bool synchronous_flag_is_boolean = argument_count == 4
				&& state->intop[3].type == LUAU_BOOL;
			const bool synchronous_flag = synchronous_flag_is_boolean
				&& state->intop[3].value.as_bool != 0;
			const auto script_resource_identity = argument_count >= 2
				? state->intop[1].value.as_uintptr : 0;
			const bool binding_candidate = run_script_target_binding_candidate(
				enabled,
				argument_count < 0 ? 0 : static_cast<std::size_t>(argument_count),
				synchronous_flag_is_boolean,
				synchronous_flag,
				script_resource_identity);
			const auto entry_sequence = enabled && !reentrant
				? run_script_entry_sequence.fetch_add(
					1, std::memory_order_acq_rel) + 1 : 0;
			const auto candidate_sequence = enabled && !reentrant
				&& argument_count == 4 && synchronous_flag_is_boolean
				&& synchronous_flag
				? run_script_candidate_sequence.fetch_add(
					1, std::memory_order_acq_rel) + 1 : 0;
			const bool query_is_table = enabled && !reentrant
				&& argument_count == 4 && synchronous_flag_is_boolean
				&& synchronous_flag
				&& read_ability_card_query(state, plan.query);
			const auto decision = classify_run_script_observation(
				enabled, reentrant,
				argument_count < 0 ? 0 : static_cast<std::size_t>(argument_count),
				synchronous_flag_is_boolean, synchronous_flag,
				query_is_table, plan.query.has_ability);
			if (enabled && !reentrant && should_sample_run_script_entry(
				entry_sequence, candidate_sequence,
				argument_count < 0
					? 0 : static_cast<std::size_t>(argument_count),
				synchronous_flag_is_boolean, synchronous_flag))
			{
				std::ostringstream entry;
				entry << "RENOVICE RunScript ENTRY seq=" << entry_sequence
					<< " candidate_seq=" << candidate_sequence
					<< " vm=" << (state != nullptr ? state->global_state : nullptr)
					<< " thread=" << GetCurrentThreadId()
					<< " args=" << argument_count << " tags=";
				const int recorded_arguments = std::min(argument_count, 6);
				for (int i = 0; i < recorded_arguments; ++i)
				{
					if (i != 0) entry << ',';
					entry << state->intop[i].type;
				}
				entry << " sync_bool="
					<< (synchronous_flag_is_boolean ? 1 : 0)
					<< " sync=" << (synchronous_flag ? 1 : 0)
					<< " query_table=" << (query_is_table ? 1 : 0)
					<< " ability=" << (plan.query.has_ability ? 1 : 0)
					<< " decision=" << static_cast<unsigned int>(decision);
				conout << entry.str() << std::endl;
				config::log(entry.str());
			}

			if (binding_candidate
				|| decision == RunScriptObservationDecision::ObserveAbilityCard)
			{
				const auto ability_identity = decision
					== RunScriptObservationDecision::ObserveAbilityCard
					? plan.query.ability_identity : 0;
				plan.boundary = make_run_script_boundary(
					state, script_resource_identity, ability_identity,
					plan.generation);
				plan.install_boundary = plan.boundary.active;
			}

			if (decision == RunScriptObservationDecision::ObserveAbilityCard)
			{
				plan.observe_ability_card = true;
				for (std::size_t i = 0; i != 4; ++i)
				{
					plan.argument_tags[i] = state->intop[i].type;
					plan.argument_values[i] = state->intop[i].value.as_uintptr;
				}
				plan.sequence = run_script_observation_sequence.fetch_add(
					1, std::memory_order_acq_rel) + 1;
				plan.before_global_state = state->global_state;
				plan.owner_thread = static_cast<std::uint32_t>(
					GetCurrentThreadId());

				std::ostringstream before;
				before << "RENOVICE card query OBSERVE phase=before seq="
					<< plan.sequence
					<< " vm=" << plan.before_global_state
					<< " thread=" << plan.owner_thread
					<< " args=" << argument_count
					<< " tags=" << plan.argument_tags[0] << ','
					<< plan.argument_tags[1] << ',' << plan.argument_tags[2]
					<< ',' << plan.argument_tags[3]
					<< " values="
					<< reinterpret_cast<void*>(plan.argument_values[0]) << ','
					<< reinterpret_cast<void*>(plan.argument_values[1]) << ','
					<< reinterpret_cast<void*>(plan.argument_values[2]) << ','
					<< reinterpret_cast<void*>(plan.argument_values[3])
					<< " query_tag=" << plan.query.query_tag
					<< " query="
					<< reinterpret_cast<void*>(plan.query.query_identity)
					<< " ability_tag=" << plan.query.ability_tag
					<< " ability="
					<< reinterpret_cast<void*>(plan.query.ability_identity)
					<< " modded_tag="
					<< (plan.query.modded_is_boolean ? LUAU_BOOL : LUAU_NIL)
					<< " modded=" << (plan.query.modded ? 1 : 0)
					<< " level="
					<< (plan.query.level_is_number ? plan.query.level : -1.0f);
				conout << before.str() << std::endl;
				config::log(before.str());
			}
		}
	}

	if (plan.install_boundary)
	{
		active_run_script_boundary = plan.boundary;
	}

	// Intentionally naked. Only the trivially-copyable plan and the
	// self-validating POD boundary survive while stock owns RunScript.
	const int result_count = original(state);

	if (plan.install_boundary)
	{
		finish_run_script_boundary(
			plan.boundary.token, plan.previous_boundary, state);
	}
	if (!plan.observe_ability_card) return result_count;

	{
		// Reborrow only after stock returned normally. A generation replacement
		// while stock ran invalidates this post phase without changing its result.
		auto generation_dispatch = generation_dispatch_gate.try_dispatch();
		if (!generation_dispatch || active_generation != plan.generation)
		{
			return result_count;
		}

		std::uint32_t result_tag = LUAU_NIL;
		std::uintptr_t result_identity = 0;
		luau_TValue result_value{};
		const bool result_is_table = read_ability_card_result(
			state, result_tag, result_identity, result_value);
		const auto target_key = result_is_table
			? target_key_for_ability(state, plan.query.ability_value) : 0;
		if (target_key != 0)
		{
			remember_target_script_binding_from_boundary(
				target_key, state, plan.boundary);
		}
		const auto result = classify_run_script_observation_result(
			result_count, result_is_table);
		std::uintptr_t published_identity = 0;
		bool card_published = false;
		if (result == RunScriptObservationResult::Complete && target_key != 0)
		{
			card_published = dispatch_ability_card_hooks(
				state, target_key, result_value, plan.query.query_value,
				published_identity);
		}
		const char* result_label = "complete";
		if (result == RunScriptObservationResult::OriginalResultCountChanged)
		{
			result_label = "original-result-count-changed";
		}
		else if (result == RunScriptObservationResult::MissingAbilityCardResult)
		{
			result_label = "missing-ability-card-result";
		}

		std::ostringstream after;
		after << "RENOVICE card query OBSERVE phase=after seq=" << plan.sequence
			<< " vm=" << state->global_state << " thread=" << plan.owner_thread
			<< " same_vm="
			<< (plan.before_global_state == state->global_state ? 1 : 0)
			<< " original_results=" << result_count
			<< " result_tag=" << result_tag
			<< " result=" << reinterpret_cast<void*>(result_identity)
			<< " target_match=" << (target_key != 0 ? 1 : 0)
			<< " target_key=0x" << std::hex << target_key << std::dec
			<< " card_published=" << (card_published ? 1 : 0)
			<< " published=" << reinterpret_cast<void*>(published_identity)
			<< " status=" << result_label;
		conout << after.str() << std::endl;
		config::log(after.str());
	}
	return result_count;
}

bool ensure_run_script_observer()
{
	if (run_script_native_hook_enabled) return true;
	if (run_script_hash == 0 || swig_types.empty()) return false;

	std::unordered_set<SwigTypeDesc*> seen_types;
	std::vector<SwigMethod*> candidates;
	std::unordered_set<luau_CFunction> originals;
	for (const auto& [_, type] : swig_types)
	{
		if (type == nullptr || !seen_types.insert(type).second
			|| type->methods == nullptr || diagnostics::bad_read_ptr(type->methods, sizeof(SwigMethod)))
		{
			continue;
		}
		for (auto* method = type->methods;
			!diagnostics::bad_read_ptr(method, sizeof(*method)) && method->hash != 0; ++method)
		{
			if (method->hash != run_script_hash) continue;
			candidates.push_back(method);
			originals.insert(method->func);
		}
	}
	if (!native_hook_binding_valid(candidates.size(), originals.size()))
	{
		if (!run_script_binding_failure_logged)
		{
			run_script_binding_failure_logged = true;
			std::ostringstream failure;
			failure << "RENOVICE RunScript observer FAIL bindings="
				<< candidates.size() << " originals=" << originals.size();
			conout << failure.str() << std::endl;
			config::log(failure.str());
		}
		return false;
	}

	original_run_script = *originals.begin();
	run_script_native_hook.detour = reinterpret_cast<void*>(
		&run_script_observer_adapter);
	run_script_native_hook.target = reinterpret_cast<void*>(original_run_script);
	run_script_native_hook.create();
	if (!run_script_native_hook.isCreated()
		|| run_script_native_hook.original == nullptr)
	{
		original_run_script = nullptr;
		config::log("RENOVICE RunScript observer FAIL native detour creation rejected");
		return false;
	}
	run_script_native_hook.enable();
	run_script_native_hook_enabled = true;
	run_script_binding_failure_logged = false;
	std::ostringstream success;
	success << "RENOVICE RunScript observer PASS bindings="
		<< candidates.size() << " original="
		<< reinterpret_cast<void*>(original_run_script)
		<< " trampoline=" << run_script_native_hook.original
		<< " mode=native-detour hash=0x" << std::hex << run_script_hash;
	conout << success.str() << std::endl;
	config::log(success.str());
	return true;
}

bool ensure_native_hook_adapters(
	bool damage_requested,
	bool callsite_requested,
	const std::vector<std::string>& requested_native_calls
)
{
	std::lock_guard native_lock(native_call_hook_mutex);
	constexpr unsigned int damage_mask = 1;
	constexpr unsigned int callsite_mask = 2;
	constexpr unsigned int native_calls_mask = 4;
	const unsigned int requested_mask =
		(damage_requested ? damage_mask : 0)
		| (callsite_requested ? callsite_mask : 0)
		| (!requested_native_calls.empty() ? native_calls_mask : 0);
	if (requested_mask == 0 || swig_types.empty()) return false;
	if (native_hook_adapters_enabled
		&& native_hook_contract_covered(
			native_hook_adapter_mask, native_call_hook_names,
			requested_mask, requested_native_calls))
	{
		return true;
	}
	const bool extend_existing = native_hook_adapters_enabled;
	const bool install_damage = damage_requested
		&& (native_hook_adapter_mask & damage_mask) == 0;
	const bool install_callsite = callsite_requested
		&& (native_hook_adapter_mask & callsite_mask) == 0;
	if ((install_damage && (set_damage_callback_hash == 0
			|| set_source_object_hash == 0))
		|| (install_callsite && push_float_arg_hash == 0))
	{
		return false;
	}

	struct Bindings
	{
		std::vector<SwigMethod*> candidates;
		std::unordered_set<luau_CFunction> originals;
	};
	std::unordered_set<SwigTypeDesc*> seen_types;
	std::vector<SwigTypeDesc*> all_types;
	for (const auto& [_, type] : swig_types)
	{
		if (type != nullptr && seen_types.insert(type).second
			&& type->methods != nullptr
			&& !diagnostics::bad_read_ptr(type->methods, sizeof(SwigMethod)))
		{
			all_types.push_back(type);
		}
	}
	const auto collect = [](
		const std::vector<SwigTypeDesc*>& types,
		std::uint32_t hash,
		luau_CFunction adapter)
	{
		Bindings result;
		for (auto* type : types)
		{
			for (auto* method = type->methods;
				!diagnostics::bad_read_ptr(method, sizeof(*method)) && method->hash != 0; ++method)
			{
				if (method->hash != hash) continue;
				result.candidates.push_back(method);
				if (method->func != adapter) result.originals.insert(method->func);
			}
		}
		return result;
	};
	const auto validate = [](const char* name, const Bindings& bindings)
	{
		if (native_hook_binding_valid(
				bindings.candidates.size(), bindings.originals.size()))
		{
			return true;
		}
		std::ostringstream failure;
		failure << "RENOVICE native hook adapter rejected " << name
			<< " bindings=" << bindings.candidates.size()
			<< " originals=" << bindings.originals.size();
		config::log(failure.str());
		return false;
	};

	Bindings damage_callbacks, source_objects, push_float_arguments;
	if (install_damage)
	{
		damage_callbacks = collect(
			all_types, set_damage_callback_hash, &set_damage_callback_adapter);
		if (!validate("SetDamageCallback", damage_callbacks)) return false;
		std::vector<SwigTypeDesc*> damage_data_types;
		for (auto* type : all_types)
		{
			for (auto* method = type->methods;
				!diagnostics::bad_read_ptr(method, sizeof(*method)) && method->hash != 0; ++method)
			{
				if (method->hash == set_damage_callback_hash)
				{
					damage_data_types.push_back(type);
					break;
				}
			}
		}
		source_objects = collect(
			damage_data_types, set_source_object_hash, &set_source_object_adapter);
		if (!validate("SetSourceObject", source_objects))
		{
			return false;
		}
	}
	if (install_callsite)
	{
		push_float_arguments = collect(
			all_types, push_float_arg_hash, &push_float_arg_adapter);
		if (!validate("PushFloatArg", push_float_arguments)) return false;
	}
	if (requested_native_calls.size() > maximum_native_call_hooks)
	{
		config::log("RENOVICE nativeCalls rejected reason=too-many-methods count="
			+ std::to_string(requested_native_calls.size()));
		return false;
	}
	struct GenericHookPlan
	{
		std::string name;
		luau_CFunction target = nullptr;
	};
	std::vector<GenericHookPlan> generic_hook_plans;
	std::unordered_set<luau_CFunction> generic_targets;
	for (const auto& record : native_call_hooks)
	{
		if (record != nullptr && record->target != nullptr)
			generic_targets.insert(record->target);
	}
	for (const auto& name : requested_native_calls)
	{
		if (std::binary_search(
			native_call_hook_names.begin(), native_call_hook_names.end(), name))
		{
			continue;
		}
		if (name == "SetDamageCallback" || name == "SetSourceObject"
			|| name == "RunScript"
			|| name == "PushFloatArg")
		{
			config::log("RENOVICE nativeCalls rejected method=" + name
				+ " reason=reserved-native-adapter-conflict");
			return false;
		}
		const auto hash = wf_hash(name.c_str());
		auto bindings = collect(all_types, hash, nullptr);
		if (!exact_native_call_bindings_valid(
				bindings.candidates.size(), bindings.originals.size(),
				native_call_hooks.size() + generic_hook_plans.size(),
				maximum_native_call_hooks))
		{
			std::ostringstream failure;
			failure << "RENOVICE nativeCalls rejected method=" << name
				<< " reason=invalid-exact-binding-set bindings="
				<< bindings.candidates.size() << " originals="
				<< bindings.originals.size() << " planned="
				<< (native_call_hooks.size() + generic_hook_plans.size())
				<< " maximum="
				<< maximum_native_call_hooks;
			config::log(failure.str());
			return false;
		}
		std::vector<luau_CFunction> originals(
			bindings.originals.begin(), bindings.originals.end());
		std::sort(originals.begin(), originals.end(), [](auto lhs, auto rhs)
		{
			return reinterpret_cast<std::uintptr_t>(lhs)
				< reinterpret_cast<std::uintptr_t>(rhs);
		});
		for (const auto original : originals)
		{
			if (!generic_targets.insert(original).second)
			{
				config::log("RENOVICE nativeCalls rejected method=" + name
					+ " reason=ambiguous-native-alias");
				return false;
			}
			generic_hook_plans.push_back({name, original});
		}
	}

	const auto create_standard = [](const char* name, soup::DetourHook& hook,
		luau_CFunction original, luau_CFunction adapter)
	{
		hook.detour = reinterpret_cast<void*>(adapter);
		hook.target = reinterpret_cast<void*>(original);
		try
		{
			hook.create();
		}
		catch (const std::exception& exception)
		{
			std::ostringstream failure;
			failure << "RENOVICE native hook adapter FAIL name=" << name
				<< " stage=create mode=long target="
				<< reinterpret_cast<void*>(original)
				<< " reason=" << exception.what();
			config::log(failure.str());
			if (hook.isCreated()) hook.destroy();
			return false;
		}
		catch (...)
		{
			config::log(std::string("RENOVICE native hook adapter FAIL name=")
				+ name + " stage=create mode=long reason=unknown-exception");
			if (hook.isCreated()) hook.destroy();
			return false;
		}
		const bool created = hook.isCreated() && hook.original != nullptr;
		if (!created)
		{
			config::log(std::string("RENOVICE native hook adapter FAIL name=")
				+ name + " stage=create mode=long reason=missing-trampoline");
		}
		return created;
	};
	const auto create_compact = [](const char* name,
		ReloadableCompactDetourHook& hook, luau_CFunction original,
		luau_CFunction adapter)
	{
		hook.detour = reinterpret_cast<void*>(adapter);
		hook.target = reinterpret_cast<void*>(original);
		hook.code_cave = soup::Module(nullptr).range.scan(
			soup::CompactDetourHook::getCodeCavePattern()).as<void*>();
		if (hook.code_cave == nullptr)
		{
			config::log(std::string("RENOVICE native hook adapter FAIL name=")
				+ name + " stage=create mode=compact reason=no-code-cave");
			return false;
		}
		try
		{
			hook.create_captured();
		}
		catch (const std::exception& exception)
		{
			std::ostringstream failure;
			failure << "RENOVICE native hook adapter FAIL name=" << name
				<< " stage=create mode=compact target="
				<< reinterpret_cast<void*>(original)
				<< " cave=" << hook.code_cave
				<< " reason=" << exception.what();
			config::log(failure.str());
			// Compact creation writes its cave before validating the target
			// prologue. Restore the cave even when no trampoline was produced.
			if (!hook.destroy_captured())
			{
				config::log(std::string("RENOVICE native hook adapter FATAL name=")
					+ name + " stage=create-cleanup reason=captured-target-restore-rejected");
			}
			return false;
		}
		catch (...)
		{
			config::log(std::string("RENOVICE native hook adapter FAIL name=")
				+ name + " stage=create mode=compact reason=unknown-exception");
			if (!hook.destroy_captured())
			{
				config::log(std::string("RENOVICE native hook adapter FATAL name=")
					+ name + " stage=create-cleanup reason=captured-target-restore-rejected");
			}
			return false;
		}
		const bool created = hook.isCreated() && hook.original != nullptr;
		if (!created)
		{
			config::log(std::string("RENOVICE native hook adapter FAIL name=")
				+ name + " stage=create mode=compact reason=missing-trampoline");
			if (!hook.destroy_captured())
			{
				config::log(std::string("RENOVICE native hook adapter FATAL name=")
					+ name + " stage=create-cleanup reason=captured-target-restore-rejected");
			}
		}
		return created;
	};
	const auto native_call_hook_base = native_call_hooks.size();
	const auto destroy_created = [&]()
	{
		for (std::size_t index = native_call_hook_base;
			index != native_call_hooks.size(); ++index)
		{
			auto& record = native_call_hooks[index];
			if (record != nullptr && record->hook.isCreated())
			{
				if (!record->hook.destroy_captured())
				{
					config::log("RENOVICE native hook adapter FATAL stage=rollback reason=captured-target-restore-rejected");
				}
			}
		}
		native_call_hooks.resize(native_call_hook_base);
		if (install_callsite && push_float_arg_native_hook.isCreated()
			&& !push_float_arg_native_hook.destroy_captured())
		{
			config::log("RENOVICE native hook adapter FATAL name=PushFloatArg stage=rollback reason=captured-target-restore-rejected");
		}
		if (install_damage && set_source_object_native_hook.isCreated())
			set_source_object_native_hook.destroy();
		if (install_damage && set_damage_callback_native_hook.isCreated())
			set_damage_callback_native_hook.destroy();
		if (install_callsite) push_float_arg_native_hook.code_cave = nullptr;
	};
	bool hooks_created = true;
	if (install_damage)
	{
		original_set_damage_callback = *damage_callbacks.originals.begin();
		original_set_source_object = *source_objects.originals.begin();
		hooks_created = create_standard(
			"SetDamageCallback",
			set_damage_callback_native_hook, original_set_damage_callback,
			&set_damage_callback_adapter)
			&& create_standard("SetSourceObject", set_source_object_native_hook,
				original_set_source_object,
				&set_source_object_adapter);
	}
	if (hooks_created && install_callsite)
	{
		original_push_float_arg = *push_float_arguments.originals.begin();
		hooks_created = create_compact(
			"PushFloatArg",
			push_float_arg_native_hook, original_push_float_arg,
			&push_float_arg_adapter);
	}
	for (std::size_t i = 0; hooks_created && i != generic_hook_plans.size(); ++i)
	{
		auto record = std::make_unique<NativeCallHookRecord>();
		record->name = generic_hook_plans[i].name;
		record->hash = wf_hash(record->name.c_str());
		record->target = generic_hook_plans[i].target;
		hooks_created = create_compact(
			record->name.c_str(), record->hook, record->target,
			native_call_adapters[native_call_hook_base + i]);
		native_call_hooks.emplace_back(std::move(record));
	}
	hooks_created = hooks_created && native_hook_adapter_bundle_valid(
		install_damage,
		install_callsite,
		!install_damage || set_damage_callback_native_hook.isCreated(),
		!install_damage || set_source_object_native_hook.isCreated(),
		!install_callsite || push_float_arg_native_hook.isCreated(),
		native_call_hooks.size()
			== native_call_hook_base + generic_hook_plans.size());
	if (!hooks_created)
	{
		destroy_created();
		if (install_callsite) original_push_float_arg = nullptr;
		if (install_damage)
		{
			original_set_source_object = nullptr;
			original_set_damage_callback = nullptr;
		}
		config::log("RENOVICE native hook adapter FAIL native detour creation rejected");
		return false;
	}

	bool damage_callback_enabled = false;
	bool source_object_enabled = false;
	bool push_float_enabled = false;
	std::size_t native_call_hooks_enabled = 0;
	try
	{
		if (install_damage)
		{
			set_damage_callback_native_hook.enable();
			damage_callback_enabled = true;
			set_source_object_native_hook.enable();
			source_object_enabled = true;
		}
		if (install_callsite)
		{
			push_float_arg_native_hook.enable_captured();
			push_float_enabled = true;
		}
		for (std::size_t index = native_call_hook_base;
			index != native_call_hooks.size(); ++index)
		{
			auto& record = native_call_hooks[index];
			record->hook.enable_captured();
			++native_call_hooks_enabled;
		}
	}
	catch (const std::exception& exception)
	{
		config::log(std::string(
			"RENOVICE native hook adapter FAIL stage=enable reason=")
			+ exception.what());
		hooks_created = false;
	}
	catch (...)
	{
		config::log(
			"RENOVICE native hook adapter FAIL stage=enable reason=unknown-exception");
		hooks_created = false;
	}
	if (!hooks_created)
	{
		for (std::size_t i = 0; i != native_call_hooks_enabled; ++i)
		{
			if (!native_call_hooks[native_call_hook_base + i]->hook.restore_captured())
			{
				config::log("RENOVICE native hook adapter FATAL stage=enable-rollback reason=captured-target-restore-rejected");
			}
		}
		if (push_float_enabled && !push_float_arg_native_hook.restore_captured())
		{
			config::log("RENOVICE native hook adapter FATAL name=PushFloatArg stage=enable-rollback reason=captured-target-restore-rejected");
		}
		if (source_object_enabled) set_source_object_native_hook.disable();
		if (damage_callback_enabled) set_damage_callback_native_hook.disable();
		destroy_created();
		if (install_callsite) original_push_float_arg = nullptr;
		if (install_damage)
		{
			original_set_source_object = nullptr;
			original_set_damage_callback = nullptr;
		}
		return false;
	}
	native_hook_adapter_mask |= requested_mask;
	native_call_hook_names = merge_native_hook_methods(
		std::move(native_call_hook_names), requested_native_calls);
	native_hook_adapters_enabled = true;
	std::ostringstream success;
	success << "RENOVICE native hook adapter PASS ownership=process"
		<< " operation=" << (extend_existing ? "extend" : "install")
		<< " damage=" << damage_requested
		<< " callsite=" << callsite_requested;
	if (install_damage)
	{
		success << " SetDamageCallback=" << damage_callbacks.candidates.size()
			<< " SetSourceObject=" << source_objects.candidates.size();
	}
	if (install_callsite)
		success << " PushFloatArg=" << push_float_arguments.candidates.size();
	success << " nativeCalls=" << requested_native_calls.size()
		<< " nativeBindings=" << native_call_hooks.size()
		<< " mode=long-damage-transport+compact-exact-native-calls";
	conout << success.str() << std::endl;
	config::log(success.str());
	for (std::size_t index = native_call_hook_base;
		index != native_call_hooks.size(); ++index)
	{
		const auto& record = native_call_hooks[index];
		if (record == nullptr) continue;
		std::ostringstream binding;
		binding << "RENOVICE native hook binding PASS name=" << record->name
			<< " target=" << record->hook.installed_target
			<< " cave=" << record->hook.code_cave
			<< " restore=captured-target";
		config::log(binding.str());
	}
	return true;
}

void disable_native_hook_adapters(const char* reason)
{
	std::lock_guard native_lock(native_call_hook_mutex);
	if (!native_hook_adapters_enabled) return;
	for (const auto& record : native_call_hooks)
	{
		if (record != nullptr && record->hook.isCreated()
			&& !record->hook.can_restore_captured())
		{
			config::log("RENOVICE native hook adapter FATAL stage=disable reason=captured-native-call-target-mismatch");
			return;
		}
	}
	if (push_float_arg_native_hook.isCreated()
		&& !push_float_arg_native_hook.can_restore_captured())
	{
		config::log("RENOVICE native hook adapter FATAL stage=disable reason=captured-PushFloatArg-target-mismatch");
		return;
	}
	for (auto& record : native_call_hooks)
	{
		if (record != nullptr && record->hook.isCreated())
		{
			if (!record->hook.restore_captured())
			{
				config::log("RENOVICE native hook adapter FATAL stage=disable reason=captured-native-call-restore-failed");
				return;
			}
		}
	}
	if (push_float_arg_native_hook.isCreated())
	{
		if (!push_float_arg_native_hook.restore_captured())
		{
			config::log("RENOVICE native hook adapter FATAL stage=disable reason=captured-PushFloatArg-restore-failed");
			return;
		}
	}
	for (auto& record : native_call_hooks)
	{
		if (record != nullptr && record->hook.isCreated()
			&& !record->hook.destroy_captured())
		{
			config::log("RENOVICE native hook adapter FATAL stage=destroy reason=captured-native-call-cleanup-failed");
			return;
		}
	}
	native_call_hooks.clear();
	native_call_hook_names.clear();
	if (push_float_arg_native_hook.isCreated()
		&& !push_float_arg_native_hook.destroy_captured())
	{
		config::log("RENOVICE native hook adapter FATAL stage=destroy reason=captured-PushFloatArg-cleanup-failed");
		return;
	}
	if (set_source_object_native_hook.isCreated())
	{
		set_source_object_native_hook.disable();
		set_source_object_native_hook.destroy();
	}
	if (set_damage_callback_native_hook.isCreated())
	{
		set_damage_callback_native_hook.disable();
		set_damage_callback_native_hook.destroy();
	}
	original_set_source_object = nullptr;
	original_set_damage_callback = nullptr;
	original_push_float_arg = nullptr;
	native_hook_adapter_mask = 0;
	native_hook_adapters_enabled = false;
	std::ostringstream message;
	message << "RENOVICE native hook adapter DISABLED reason="
		<< (reason == nullptr ? "unspecified" : reason);
	conout << message.str() << std::endl;
	config::log(message.str());
}

bool reconcile_native_hook_contract(const char* stage)
{
	if (!subsystem_enabled.load(std::memory_order_acquire)) return true;
	bool native_damage_adapters_requested = false;
	bool native_callsite_adapters_requested = false;
	std::vector<std::string> requested_native_calls;
	{
		std::lock_guard lock(generation_mutex);
		native_damage_adapters_requested =
			native_damage_adapters_requested_locked();
		native_callsite_adapters_requested =
			native_callsite_adapters_requested_locked();
		requested_native_calls = native_call_hook_names_requested_locked();
	}
	const auto flags = config::flags();
	engine_damage::set_type_resolver(&native_damage_object_type);
	if (!engine_damage::reconcile(flags)) return false;
	requested_native_calls = native_calls_with_diagnostics(flags, std::move(requested_native_calls));
	const unsigned int requested_mask =
		(native_damage_adapters_requested ? 1u : 0u)
		| (native_callsite_adapters_requested ? 2u : 0u)
		| (!requested_native_calls.empty() ? 4u : 0u);
	bool native_configuration_current = false;
	{
		std::lock_guard native_lock(native_call_hook_mutex);
		native_configuration_current = native_hook_adapters_enabled
			&& native_hook_contract_covered(
				native_hook_adapter_mask, native_call_hook_names,
				requested_mask, requested_native_calls);
	}
	if (native_configuration_current) return true;
	if (requested_mask == 0)
	{
		// Detours are process-owned. With no current handler contract they stay
		// installed and their adapters immediately forward to stock.
		return true;
	}
	if (wf_hash == nullptr) return false;
	if (native_damage_adapters_requested && set_damage_callback_hash == 0)
		set_damage_callback_hash = wf_hash("SetDamageCallback");
	if (native_damage_adapters_requested && set_source_object_hash == 0)
		set_source_object_hash = wf_hash("SetSourceObject");
	if (native_callsite_adapters_requested && push_float_arg_hash == 0)
		push_float_arg_hash = wf_hash("PushFloatArg");
	if (ensure_native_hook_adapters(
			native_damage_adapters_requested,
			native_callsite_adapters_requested,
			requested_native_calls))
	{
		return true;
	}
	std::ostringstream failure;
	failure << "RENOVICE native hook adapter FAIL stage="
		<< (stage == nullptr ? "reconcile" : stage);
	config::log(failure.str());
	return false;
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

// Loader and protected calls can relocate the stack after capacity checks.
luau_TValue* guard_base() noexcept
{
    return guard.state == nullptr || guard.state->stack == nullptr ? nullptr
        : luau_restorestack(guard.state, guard.base_offset);
}

void finish_guard() noexcept
{
    if (guard.original_rooted && !guard.registry_may_be_shadowed && guard_base() != nullptr)
    {
        auto* const base = guard_base();
        *base = {};
        base->type = LUAU_NIL;
        guard.state->outtop = base + 1;
        guard.setfield(guard.state, -10000, "RENOVICE.guarded-module-original");
        guard.state->outtop = guard_base();
        guard.original_rooted = false;
    }
    guard.active = 0;
	if (guard.handler != nullptr)
	{
		RemoveVectoredExceptionHandler(guard.handler);
		guard.handler = nullptr;
	}
}

void disarm_guard_exception_handler() noexcept
{
	guard.active = 0;
	if (guard.handler != nullptr)
	{
		RemoveVectoredExceptionHandler(guard.handler);
		guard.handler = nullptr;
	}
}

bool capture_guard_outer_error_jump(luau_State* state) noexcept
{
	if (state == nullptr || state->global_state == nullptr
		|| luau_GlobalState::error_longjump_data_offset == 0)
	{
		return false;
	}
	auto** const slot = reinterpret_cast<void**>(
		reinterpret_cast<unsigned char*>(state->global_state)
		+ luau_GlobalState::error_longjump_data_offset);
	if (IsBadReadPtr(slot, sizeof(*slot)) || IsBadWritePtr(slot, sizeof(*slot))
		|| *slot == nullptr)
	{
		return false;
	}
	guard.outer_error_jump_slot = slot;
	guard.outer_error_jump = *slot;
	return true;
}

bool restore_guard_outer_error_jump_after_fault() noexcept
{
	if (guard.outer_error_jump_slot == nullptr || guard.outer_error_jump == nullptr
		|| IsBadWritePtr(guard.outer_error_jump_slot,
			sizeof(*guard.outer_error_jump_slot)))
	{
		return false;
	}
	*guard.outer_error_jump_slot = guard.outer_error_jump;
	return true;
}

void abandon_guard_without_vm_access() noexcept
{
	// Frame restoration failure means no Lua pointer is trustworthy. Retire the
	// native VEH only; touching the registry or stack here would turn one caught
	// Loader failure into a second unprotected VM fault.
	disarm_guard_exception_handler();
	guard.original_rooted = false;
	guard.registry_may_be_shadowed = false;
}

void restore_lua_top() noexcept
{
	if (guard.state != nullptr && guard_base() != nullptr
		&& !IsBadWritePtr(&guard.state->outtop, sizeof(guard.state->outtop)))
	{
		guard.state->outtop = guard_base();
	}
}

void set_registry_nil(luau_State* state, luau_TValue* base, const char* key)
{
	base->value.as_uintptr = 0;
	base->type = LUAU_NIL;
	state->outtop = base + 1;
	setfield(state, -10000, key);
}

struct ProtectedStockLoaderContext
{
	Loader loader = nullptr;
	void* manager = nullptr;
	void* descriptor = nullptr;
	bool returned = false;
	bool value = false;
};
static_assert(std::is_trivially_copyable_v<ProtectedStockLoaderContext>);

struct ProtectedStockLoaderResult
{
	bool admitted = false;
	bool restored = false;
	bool returned = false;
	bool value = false;
	int status = -1;
};
static_assert(std::is_trivially_copyable_v<ProtectedStockLoaderResult>);

enum class StockLoaderErrorPolicy : std::uint8_t
{
	ContainAndRestore,
	PreserveForStockRethrow,
};

// Destructor-free DE boundary. Loader can raise through DE's longjmp from
// operations which occur after its internally protected undump/check-stack
// work (notably the registry setfield). No C++ owner may be introduced here.
void protected_stock_loader_leaf(
	luau_State*,
	void* raw_context) noexcept
{
	auto* const context = static_cast<ProtectedStockLoaderContext*>(raw_context);
	if (context == nullptr || context->loader == nullptr) return;
	context->value = context->loader(context->manager, context->descriptor);
	context->returned = true;
}

ProtectedStockLoaderResult invoke_stock_loader_protected(
	luau_State* state,
	void* manager,
	void* descriptor,
	StockLoaderErrorPolicy error_policy) noexcept
{
	ProtectedStockLoaderResult result{};
	ProtectedStockLoaderContext context{};
	context.loader = reinterpret_cast<Loader>(loader_hook.original);
	context.manager = manager;
	context.descriptor = descriptor;
	if (context.loader == nullptr) return result;

	const auto protected_result = error_policy
		== StockLoaderErrorPolicy::PreserveForStockRethrow
		? de_vm_authority::run_current_vm_rethrowable(
			state, &protected_stock_loader_leaf, &context)
		: de_vm_authority::run_current_vm_protected(
			state, &protected_stock_loader_leaf, &context);
	result.admitted = protected_result.admitted;
	result.restored = protected_result.restored;
	result.status = protected_result.status;
	result.returned = context.returned;
	result.value = context.value;
	return result;
}

struct GuardedRunLeafContext
{
	Loader loader = nullptr;
	void* manager = nullptr;
	void* descriptor = nullptr;
	const std::uint32_t* name_handle = nullptr;
	const char* lifecycle_key = nullptr;
	// Lowercase 16-hex key text of a multi-target binding, or nullptr.
	const char* multi_target_key = nullptr;
	// Exact target-module environment (runtime root instance), or nullptr to
	// use the borrowed registry closure's load environment.
	void* exact_environment = nullptr;
	bool pass_global_argument = false;
	bool use_borrowed_closure_environment = false;
	bool guard_prepared = false;
	bool returned = false;
	RunResult result{};
};
static_assert(std::is_trivially_copyable_v<GuardedRunLeafContext>);

struct GuardRegistryRecoveryContext
{
	const char* lifecycle_key = nullptr;
	bool clear_lifecycle_root = false;
	bool attempted = false;
	bool target_restored = false;
	bool temporary_root_cleared = false;
	bool lifecycle_root_cleared = false;
	bool completed = false;
};
static_assert(std::is_trivially_copyable_v<GuardRegistryRecoveryContext>);

// BEGIN GUARDED_RUN_PROTECTED_LEAF
// Destructor-free DE boundary. Every operation below which can raise through
// DE's luaD_throw path is contained by run_current_vm_protected. Rich C++
// ownership stays in run_chunk, outside this leaf.
void run_guarded_protected_leaf(luau_State* state, void* raw_context) noexcept
{
	auto* const context = static_cast<GuardedRunLeafContext*>(raw_context);
	if (context == nullptr || state == nullptr || context->loader == nullptr
		|| context->manager == nullptr
		|| context->descriptor == nullptr || context->name_handle == nullptr
		|| check_stack == nullptr || gc_barrierback == nullptr
		|| key_builder == nullptr || getfield == nullptr || setfield == nullptr
		|| protected_call == nullptr)
	{
		return;
	}
	RunResult& result = context->result;

	// check_stack may relocate the VM stack. The outer raw-protected runner owns
	// the exact pre-call frame snapshot; this leaf records its working offset
	// only after the reservation has completed.
	if (check_stack(state, 8) == 0)
	{
		result.protected_call_result = -7;
		context->returned = true;
		return;
	}

	std::memset(&guard, 0, sizeof(guard));
	guard.state = state;
	guard.base_offset = luau_savestack(state, state->outtop);
	guard.setfield = setfield;
	guard.thread_id = GetCurrentThreadId();
	context->guard_prepared = true;
	if (!capture_guard_outer_error_jump(state))
	{
		result.protected_call_result = -9;
		context->returned = true;
		return;
	}
	guard.handler = AddVectoredExceptionHandler(1, fault_handler);
	if (guard.handler == nullptr)
	{
		result.protected_call_result = -8;
		context->returned = true;
		return;
	}

	if (setjmp(guard.jump) != 0)
	{
		// The VEH can interrupt Loader or luaD_pcall while either owns a nested
		// DE error-jump record. Restore the enclosing raw runner's exact record
		// before returning. Do not touch the VM here: the fault may have skipped
		// a child pcall activation. The outer raw runner restores the exact frame,
		// then settle_guard_after_protected_exit performs protected registry repair.
		const bool error_jump_restored =
			restore_guard_outer_error_jump_after_fault();
		disarm_guard_exception_handler();
		result.registry_restored = false;
		if (!error_jump_restored && result.protected_call_result == 0)
			result.protected_call_result = -10;
		result.fault_stage = guard.fault_stage;
		result.fault_code = guard.fault_code;
		result.fault_address = guard.fault_address;
		context->returned = true;
		return;
	}

	guard.active = 1;
	guard.stage = 1;
	key_builder(guard.key, 0x104, const_cast<std::uint32_t*>(context->name_handle));

	guard.stage = 2;
	getfield(state, -10000, guard.key);
	// A C++ TValue copy is not a GC root while the loader shadows its key.
    setfield(state, -10000, "RENOVICE.guarded-module-original");
    getfield(state, -10000, "RENOVICE.guarded-module-original");
    guard.borrowed_original = *guard_base();
    guard.original_rooted = true;
	guard.registry_may_be_shadowed = true;
	state->outtop = guard_base();

	// A target-scoped addon must inherit the exact target module closure's
	// environment. Sharing only global_state is insufficient: Warframe can host
	// multiple environment tables inside one DE VM, so a VM-wide addon load can
	// be invisible to both target gameplay and its presentation callbacks.
	if (context->use_borrowed_closure_environment)
	{
		const bool borrowed_is_function = is_function(guard.borrowed_original.type);
		const bool closure_readable = guard.borrowed_original.value.as_uintptr != 0
			&& !diagnostics::bad_read_ptr(reinterpret_cast<void*>(
				guard.borrowed_original.value.as_uintptr), offsetof(luau_Closure, c.func));
		auto* closure = closure_readable ? reinterpret_cast<luau_Closure*>(
			guard.borrowed_original.value.as_uintptr) : nullptr;
		// The borrowed registry closure proves the target module is loaded in
		// this VM. Its environment is the LOAD environment; when the module root
		// has since run in a different RUNTIME environment, the caller passes
		// that exact environment and the addon executes there instead.
		void* const selected_environment = context->exact_environment != nullptr
			? context->exact_environment
			: (closure != nullptr ? closure->env : nullptr);
		const bool environment_readable = closure != nullptr
			&& selected_environment != nullptr
			&& !diagnostics::bad_read_ptr(selected_environment, 0x10);
		if (!valid_target_closure_environment(
			borrowed_is_function, closure_readable, environment_readable))
		{
			guard.stage = 6;
			if ((guard.state->marked & native_gc_black_mask_u43) != 0)
			{
				gc_barrierback(guard.state,
					reinterpret_cast<luau_GCObject*>(guard.state),
					&guard.state->gclist);
			}
			*guard_base() = guard.borrowed_original;
			state->outtop = guard_base() + 1;
			setfield(state, -10000, guard.key);
			guard.registry_may_be_shadowed = false;
			restore_lua_top();
			finish_guard();
			result.registry_restored = true;
			result.protected_call_result = -4;
			context->returned = true;
			return;
		}
		result.borrowed_environment = selected_environment;
		result.exact_environment_used = true;
		*reinterpret_cast<void**>(reinterpret_cast<unsigned char*>(context->descriptor) + 0x58)
			= selected_environment;
	}
	else if (context->pass_global_argument)
	{
		// Ordinary Inject/addon chunks retain the established VM-global behavior.
		getfield(state, -10002, "_G");
		if (is_table(guard_base()->type))
		{
			*reinterpret_cast<void**>(reinterpret_cast<unsigned char*>(context->descriptor) + 0x58)
				= reinterpret_cast<void*>(guard_base()->value.as_uintptr);
		}
		state->outtop = guard_base();
	}

	guard.stage = 3;
	// This entire leaf already runs inside the outer raw-protected boundary.
	// Invoke the shared destructor-free Loader leaf directly: nesting a second
	// raw error-jump record under the native VEH would let a caught access fault
	// bypass that inner record's normal restoration.
	ProtectedStockLoaderContext loader_context{};
	loader_context.loader = context->loader;
	loader_context.manager = context->manager;
	loader_context.descriptor = context->descriptor;
	protected_stock_loader_leaf(state, &loader_context);
	const bool loader_pass = loader_context.returned && loader_context.value;
	state->outtop = guard_base() + 1;
	if (!loader_pass)
	{
		guard.stage = 6;
		if ((guard.state->marked & native_gc_black_mask_u43) != 0)
		{
			gc_barrierback(guard.state,
				reinterpret_cast<luau_GCObject*>(guard.state),
				&guard.state->gclist);
		}
		*guard_base() = guard.borrowed_original;
		state->outtop = guard_base() + 1;
		setfield(state, -10000, guard.key);
		guard.registry_may_be_shadowed = false;
		restore_lua_top();
		finish_guard();
		result.registry_restored = true;
		result.protected_call_result = -3;
		context->returned = true;
		return;
	}

	guard.stage = 4;
	getfield(state, -10000, guard.key);
	result.closure_tag = (guard_base() + 1)->type;
	if (!is_function(result.closure_tag))
	{
		guard.stage = 6;
		if ((guard.state->marked & native_gc_black_mask_u43) != 0)
		{
			gc_barrierback(guard.state,
				reinterpret_cast<luau_GCObject*>(guard.state),
				&guard.state->gclist);
		}
		*guard_base() = guard.borrowed_original;
		state->outtop = guard_base() + 1;
		setfield(state, -10000, guard.key);
		guard.registry_may_be_shadowed = false;
		restore_lua_top();
		finish_guard();
		result.registry_restored = true;
		context->returned = true;
		return;
	}

	guard.stage = 5;
	if (context->pass_global_argument)
	{
		// Supply `_G` explicitly for compatibility with existing Inject chunks.
		// Module globals such as Warframe's shared `_T` must be resolved normally
		// by the chunk from the loader-assigned closure environment. The current
		// callback state's global pseudo-index is not necessarily that environment.
		getfield(state, -10002, "_G");
		result.protected_call_result = protected_call(state, 1, 1, 0);
		result.result_tag = (guard_base() + 1)->type;
	}
	else
	{
		result.protected_call_result = protected_call(state, 0, 0, 0);
		result.result_tag = -1;
	}
	if (result.protected_call_result != 0 && state->outtop > guard_base())
	{
		// Bounded operational copy of the chunk's Lua error before any restore.
		result.error_tag = static_cast<int>((state->outtop - 1)->type);
		capture_lua_error_text(*(state->outtop - 1),
			result.error_text, sizeof(result.error_text));
	}
	// MULTI_TARGET_SELECTION: a `.targets.addon` binding replaces the returned
	// container at slot +1 with `container.targets["<key>"]` before the
	// unchanged lifecycle storage and hook-contract validation below. Absent
	// entry activate/cleanup fields inherit the container's functions; hooks
	// never inherit because prototype/callsite identities are module-specific.
	// Destructor-free: slots +1..+4 lie inside the check_stack(state, 8) reserve.
	if (result.protected_call_result == 0 && context->lifecycle_key != nullptr
		&& context->multi_target_key != nullptr)
	{
		guard.stage = 8;
		const bool container_is_table = is_table(result.result_tag);
		bool container_hooks_absent = true;
		bool container_activate_function = false;
		bool container_cleanup_function = false;
		bool targets_is_table = false;
		bool entry_absent = true;
		bool entry_is_table = false;
		bool entry_activate_absent = true;
		bool entry_activate_function = false;
		bool entry_cleanup_absent = true;
		bool entry_cleanup_function = false;
		if (container_is_table)
		{
			state->outtop = guard_base() + 2;
			getfield(state, -1, "hooks");
			container_hooks_absent = (guard_base() + 2)->type == LUAU_NIL;
			state->outtop = guard_base() + 2;
			getfield(state, -1, "activate");
			container_activate_function = is_function((guard_base() + 2)->type);
			state->outtop = guard_base() + 2;
			getfield(state, -1, "cleanup");
			container_cleanup_function = is_function((guard_base() + 2)->type);
			state->outtop = guard_base() + 2;
			getfield(state, -1, "targets");
			targets_is_table = is_table((guard_base() + 2)->type);
			if (targets_is_table)
			{
				getfield(state, -1, context->multi_target_key);
				entry_absent = (guard_base() + 3)->type == LUAU_NIL;
				entry_is_table = is_table((guard_base() + 3)->type);
				if (entry_is_table)
				{
					getfield(state, -1, "activate");
					entry_activate_absent = (guard_base() + 4)->type == LUAU_NIL;
					entry_activate_function = is_function((guard_base() + 4)->type);
					state->outtop = guard_base() + 4;
					getfield(state, -1, "cleanup");
					entry_cleanup_absent = (guard_base() + 4)->type == LUAU_NIL;
					entry_cleanup_function = is_function((guard_base() + 4)->type);
					state->outtop = guard_base() + 4;
				}
			}
		}
		const auto selection = classify_multi_target_selection(
			container_is_table, container_hooks_absent, targets_is_table,
			entry_absent, entry_is_table,
			entry_activate_absent, entry_activate_function,
			container_activate_function,
			entry_cleanup_absent, entry_cleanup_function,
			container_cleanup_function);
		if (selection != MultiTargetSelectFailure::none)
		{
			result.multi_target_failure = static_cast<int>(selection);
			result.protected_call_result = -5;
		}
		else
		{
			// Stack: +1 container, +2 targets, +3 entry; top is +4.
			if (entry_activate_absent)
			{
				state->outtop = guard_base() + 4;
				getfield(state, -3, "activate");
				setfield(state, -2, "activate");
			}
			if (entry_cleanup_absent)
			{
				state->outtop = guard_base() + 4;
				getfield(state, -3, "cleanup");
				setfield(state, -2, "cleanup");
			}
			if ((state->marked & native_gc_black_mask_u43) != 0)
			{
				gc_barrierback(state,
					reinterpret_cast<luau_GCObject*>(state),
					&state->gclist);
			}
			*(guard_base() + 1) = *(guard_base() + 3);
			result.result_tag = (guard_base() + 1)->type;
			state->outtop = guard_base() + 2;
		}
		guard.stage = 5;
	}
	if (result.protected_call_result == 0 && context->lifecycle_key != nullptr)
	{
		if (!is_table(result.result_tag))
		{
			result.protected_call_result = -1;
		}
		else
		{
			guard.stage = 7;
			if ((state->marked & native_gc_black_mask_u43) != 0)
			{
				gc_barrierback(state,
					reinterpret_cast<luau_GCObject*>(state),
					&state->gclist);
			}
			*guard_base() = *(guard_base() + 1);
			state->outtop = guard_base() + 1;
			setfield(state, -10000, context->lifecycle_key);
			result.lifecycle_stored = true;

			state->outtop = guard_base();
			getfield(state, -10000, context->lifecycle_key);
			getfield(state, -1, "activate");
			const bool activate_valid = is_function((guard_base() + 1)->type);
			state->outtop = guard_base() + 1;
			getfield(state, -1, "cleanup");
			const bool cleanup_valid = is_function((guard_base() + 1)->type);
			bool hook_contract_valid = true;
			if (context->use_borrowed_closure_environment)
			{
				state->outtop = guard_base() + 1;
				getfield(state, -1, "hooks");
				const bool hooks_absent = (guard_base() + 1)->type == LUAU_NIL;
				const bool hooks_valid = is_table((guard_base() + 1)->type);
				bool after_card_valid = false;
				bool after_damage_valid = false;
				bool matches_ability_valid = false;
				bool matches_damage_source_valid = false;
				bool transform_float_argument_absent_or_valid = true;
				bool native_calls_absent_or_valid = true;
				bool lua_calls_absent_or_valid = true;
				if (hooks_valid)
				{
					state->outtop = guard_base() + 2;
					getfield(state, -1, "matchesAbility");
					matches_ability_valid = is_function((guard_base() + 2)->type);
					state->outtop = guard_base() + 2;
					getfield(state, -1, "matchesDamageSource");
					matches_damage_source_valid = is_function((guard_base() + 2)->type);
					state->outtop = guard_base() + 2;
					getfield(state, -1, "afterAbilityCard");
					after_card_valid = is_function((guard_base() + 2)->type);
					state->outtop = guard_base() + 2;
					getfield(state, -1, "afterDamage");
					after_damage_valid = is_function((guard_base() + 2)->type);
					state->outtop = guard_base() + 2;
					getfield(state, -1, "transformFloatArgument");
					transform_float_argument_absent_or_valid =
						(guard_base() + 2)->type == LUAU_NIL
						|| is_function((guard_base() + 2)->type);
					state->outtop = guard_base() + 2;
					getfield(state, -1, "nativeCalls");
					native_calls_absent_or_valid =
						(guard_base() + 2)->type == LUAU_NIL
						|| is_table((guard_base() + 2)->type);
					state->outtop = guard_base() + 2;
					getfield(state, -1, "luaCalls");
					lua_calls_absent_or_valid =
						(guard_base() + 2)->type == LUAU_NIL
						|| is_table((guard_base() + 2)->type);
				}
				hook_contract_valid = valid_target_hook_contract(
					hooks_absent, hooks_valid, matches_ability_valid,
					matches_damage_source_valid,
					after_card_valid, after_damage_valid,
					transform_float_argument_absent_or_valid,
					native_calls_absent_or_valid,
					lua_calls_absent_or_valid);
			}
			if (!activate_valid || !cleanup_valid || !hook_contract_valid)
			{
				set_registry_nil(state, guard_base(), context->lifecycle_key);
				result.lifecycle_stored = false;
				result.protected_call_result = -2;
			}
		}
	}

	guard.stage = 6;
	if ((guard.state->marked & native_gc_black_mask_u43) != 0)
	{
		gc_barrierback(guard.state,
			reinterpret_cast<luau_GCObject*>(guard.state),
			&guard.state->gclist);
	}
	*guard_base() = guard.borrowed_original;
	state->outtop = guard_base() + 1;
	setfield(state, -10000, guard.key);
	guard.registry_may_be_shadowed = false;
	restore_lua_top();
	finish_guard();
	result.completed = result.protected_call_result == 0
		&& (context->lifecycle_key == nullptr || result.lifecycle_stored);
	result.registry_restored = true;
	context->returned = true;
}
// END GUARDED_RUN_PROTECTED_LEAF

// BEGIN GUARDED_RUN_RECOVERY_LEAF
// The primary raw runner restores the exact CallInfo and stack pointers before
// this leaf is entered. This second protected leaf repairs only the registry
// ownership that can outlive a failed module-load batch.
void guarded_run_registry_recovery_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<GuardRegistryRecoveryContext*>(raw_context);
	if (context == nullptr || state == nullptr || guard.state != state
		|| guard.setfield == nullptr || check_stack == nullptr)
	{
		return;
	}
	context->attempted = true;
	context->target_restored = !guard.registry_may_be_shadowed;
	context->temporary_root_cleared = !guard.original_rooted;
	context->lifecycle_root_cleared = !context->clear_lifecycle_root;
	if (context->target_restored && context->temporary_root_cleared
		&& context->lifecycle_root_cleared)
	{
		context->completed = true;
		return;
	}
	if (check_stack(state, 2) == 0) return;
	auto* base = guard_base();
	if (base == nullptr || IsBadWritePtr(base, sizeof(luau_TValue))
		|| IsBadWritePtr(&state->outtop, sizeof(state->outtop)))
	{
		return;
	}

	if (guard.registry_may_be_shadowed)
	{
		if (gc_barrierback == nullptr) return;
		if ((state->marked & native_gc_black_mask_u43) != 0)
		{
			gc_barrierback(state,
				reinterpret_cast<luau_GCObject*>(state),
				&state->gclist);
		}
		base = guard_base();
		if (base == nullptr) return;
		*base = guard.borrowed_original;
		state->outtop = base + 1;
		guard.setfield(state, -10000, guard.key);
		guard.registry_may_be_shadowed = false;
		context->target_restored = true;
	}

	if (guard.original_rooted)
	{
		base = guard_base();
		if (base == nullptr) return;
		base->value.as_uintptr = 0;
		base->type = LUAU_NIL;
		state->outtop = base + 1;
		guard.setfield(
			state, -10000, "RENOVICE.guarded-module-original");
		guard.original_rooted = false;
		context->temporary_root_cleared = true;
	}
	if (context->clear_lifecycle_root)
	{
		base = guard_base();
		if (base == nullptr || context->lifecycle_key == nullptr) return;
		base->value.as_uintptr = 0;
		base->type = LUAU_NIL;
		state->outtop = base + 1;
		guard.setfield(state, -10000, context->lifecycle_key);
		context->lifecycle_root_cleared = true;
	}
	state->outtop = guard_base();
	context->completed = context->target_restored
		&& context->temporary_root_cleared
		&& context->lifecycle_root_cleared;
}
// END GUARDED_RUN_RECOVERY_LEAF

bool settle_guard_after_protected_exit(
	luau_State* state,
	bool guard_prepared,
	bool primary_frame_restored,
	const char* lifecycle_key,
	bool clear_lifecycle_root) noexcept
{
	if (!guard_prepared) return primary_frame_restored;
	// A Lua longjmp can bypass finish_guard. Retire its now-stale native jump
	// target before any second VM operation is attempted.
	disarm_guard_exception_handler();
	if (!primary_frame_restored || guard.state != state)
	{
		abandon_guard_without_vm_access();
		return false;
	}
	if (!guard.registry_may_be_shadowed && !guard.original_rooted
		&& !clear_lifecycle_root)
	{
		return true;
	}

	GuardRegistryRecoveryContext context{};
	context.lifecycle_key = lifecycle_key;
	context.clear_lifecycle_root = clear_lifecycle_root;
	const auto recovery = de_vm_authority::run_current_vm_protected(
		state, &guarded_run_registry_recovery_leaf, &context);
	const bool recovered = recovery.admitted && recovery.restored
		&& recovery.status == 0 && context.attempted && context.completed
		&& !guard.registry_may_be_shadowed && !guard.original_rooted;
	if (!recovered) abandon_guard_without_vm_access();
	return recovered;
}

RunResult run_guarded(
	luau_State* state,
	void* manager,
	void* descriptor,
	const std::uint32_t* name_handle,
	const char* lifecycle_key,
	bool pass_global_argument,
	bool use_borrowed_closure_environment,
	const char* multi_target_key = nullptr,
	void* exact_environment = nullptr)
{
	RunResult result{};
	if (state == nullptr || manager == nullptr || descriptor == nullptr
		|| name_handle == nullptr
		|| diagnostics::bad_read_ptr(
			name_handle, sizeof(std::uint32_t) * 2)
		|| diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->outtop == nullptr || check_stack == nullptr
		|| gc_barrierback == nullptr || key_builder == nullptr
		|| getfield == nullptr || setfield == nullptr || protected_call == nullptr)
	{
		return result;
	}

	GuardedRunLeafContext context{};
	context.loader = reinterpret_cast<Loader>(loader_hook.original);
	context.manager = manager;
	context.descriptor = descriptor;
	context.name_handle = name_handle;
	context.lifecycle_key = lifecycle_key;
	context.multi_target_key = lifecycle_key != nullptr ? multi_target_key : nullptr;
	context.exact_environment = use_borrowed_closure_environment
		? exact_environment : nullptr;
	context.pass_global_argument = pass_global_argument;
	context.use_borrowed_closure_environment =
		use_borrowed_closure_environment;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &run_guarded_protected_leaf, &context);
	result = context.result;
	if (!protected_result.admitted)
	{
		result.protected_call_result = -6;
		result.registry_restored = true;
		return result;
	}
	const bool registry_safe = settle_guard_after_protected_exit(
		state, context.guard_prepared, protected_result.restored,
		context.lifecycle_key,
		context.guard_prepared && context.lifecycle_key != nullptr
			&& guard.stage == 7
			&& (protected_result.status != 0 || !context.returned
				|| !context.result.completed));
	result.registry_restored = registry_safe;
	if (!protected_result.restored || protected_result.status != 0
		|| !context.returned)
	{
		result.completed = false;
		if (result.protected_call_result == 0)
			result.protected_call_result = -6;
	}
	if (!registry_safe) result.completed = false;
	return result;
}

enum class LifecycleLeafFailure : std::uint8_t
{
	none,
	stack_capacity,
	exception_guard,
	native_fault,
	lifecycle_root_not_table,
	operation_not_function,
	protected_call_rejected,
};

struct LifecycleLeafContext
{
	const char* registry_key = nullptr;
	const char* field = nullptr;
	bool guard_prepared = false;
	bool returned = false;
	bool success = false;
	LifecycleLeafFailure failure = LifecycleLeafFailure::none;
	unsigned long fault_code = 0;
	void* fault_address = nullptr;
	int error_tag = -1;
	char error_text[lua_error_text_capacity]{};
};
static_assert(std::is_trivially_copyable_v<LifecycleLeafContext>);

// BEGIN LIFECYCLE_OPERATION_PROTECTED_LEAF
// Addon lifecycle callbacks and registry release mutate the DE VM only in this
// destructor-free leaf. The outer operation keeps strings, logging, locks and
// generation ownership alive without exposing them to a DE longjmp.
void lifecycle_operation_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<LifecycleLeafContext*>(raw_context);
	if (context == nullptr || state == nullptr || context->registry_key == nullptr
		|| check_stack == nullptr || getfield == nullptr || setfield == nullptr
		|| protected_call == nullptr)
	{
		return;
	}
	if (check_stack(state, 4) == 0)
	{
		context->failure = LifecycleLeafFailure::stack_capacity;
		context->returned = true;
		return;
	}

	std::memset(&guard, 0, sizeof(guard));
	guard.state = state;
	guard.base_offset = luau_savestack(state, state->outtop);
	guard.setfield = setfield;
	guard.thread_id = GetCurrentThreadId();
	context->guard_prepared = true;
	if (!capture_guard_outer_error_jump(state))
	{
		context->failure = LifecycleLeafFailure::exception_guard;
		context->returned = true;
		return;
	}
	guard.handler = AddVectoredExceptionHandler(1, fault_handler);
	if (guard.handler == nullptr)
	{
		context->failure = LifecycleLeafFailure::exception_guard;
		context->returned = true;
		return;
	}
	if (setjmp(guard.jump) != 0)
	{
		(void)restore_guard_outer_error_jump_after_fault();
		disarm_guard_exception_handler();
		context->failure = LifecycleLeafFailure::native_fault;
		context->fault_code = guard.fault_code;
		context->fault_address = guard.fault_address;
		context->returned = true;
		return;
	}

	guard.active = 1;
	guard.stage = 20;
	if (context->field == nullptr)
	{
		set_registry_nil(state, guard_base(), context->registry_key);
	}
	else
	{
		getfield(state, -10000, context->registry_key);
		if (!is_table(guard_base()->type))
		{
			restore_lua_top();
			finish_guard();
			context->failure = LifecycleLeafFailure::lifecycle_root_not_table;
			context->returned = true;
			return;
		}
		getfield(state, -1, context->field);
		if (!is_function((guard_base() + 1)->type))
		{
			restore_lua_top();
			finish_guard();
			context->failure = LifecycleLeafFailure::operation_not_function;
			context->returned = true;
			return;
		}
		state->outtop = guard_base() + 2;
		if (protected_call(state, 0, 0, 0) != 0)
		{
			if (state->outtop > guard_base())
			{
				context->error_tag = static_cast<int>((state->outtop - 1)->type);
				capture_lua_error_text(*(state->outtop - 1),
					context->error_text, sizeof(context->error_text));
			}
			restore_lua_top();
			finish_guard();
			context->failure = LifecycleLeafFailure::protected_call_rejected;
			context->returned = true;
			return;
		}
	}
	restore_lua_top();
	finish_guard();
	context->success = true;
	context->returned = true;
}
// END LIFECYCLE_OPERATION_PROTECTED_LEAF

bool lifecycle_operation(luau_State* state, const AddonRecord& addon, const char* field)
{
	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	const char* operation = field == nullptr ? "release" : field;
	LifecycleLeafContext context{};
	auto log_failure = [&](const char* reason)
	{
		std::ostringstream failure;
		failure << "RENOVICE addon lifecycle FAIL " << addon.name
			<< " field=" << operation << " reason=" << reason;
		if (context.error_tag >= 0)
		{
			// Operational error reporting (bounded, sanitized), not diagnostics.
			failure << " error_tag=" << context.error_tag
				<< " error=\"" << context.error_text << '"';
		}
		conout << failure.str() << std::endl;
		config::log(failure.str());
	};
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->outtop == nullptr || check_stack == nullptr)
	{
		log_failure("state-unavailable");
		return false;
	}
	const auto lua_blocker = inspect_lua_mutation_boundary(state);
	if (lua_blocker != LuaMutationBoundaryBlocker::Ready)
	{
		log_failure(lua_mutation_boundary_label(lua_blocker));
		return false;
	}

	context.registry_key = addon.registry_key.c_str();
	context.field = field;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &lifecycle_operation_protected_leaf, &context);
	if (context.guard_prepared)
	{
		// A DE longjmp can skip the leaf's finish_guard call. Its exact VM frame
		// has already been restored by the authority wrapper; only native guard
		// ownership remains to be retired here.
		abandon_guard_without_vm_access();
	}
	if (!protected_result.admitted)
	{
		log_failure("raw-protection-not-admitted");
		return false;
	}
	if (!protected_result.restored)
	{
		log_failure("raw-frame-restore-failed");
		return false;
	}
	if (protected_result.status != 0 || !context.returned)
	{
		log_failure("de-lua-error");
		return false;
	}
	if (context.success) return true;
	if (context.failure == LifecycleLeafFailure::native_fault)
	{
		conout << "RENOVICE addon lifecycle FAULT " << addon.name
			<< " field=" << operation
			<< " exception_code=" << static_cast<std::uint32_t>(context.fault_code)
			<< " address=" << context.fault_address << std::endl;
		std::ostringstream failure;
		failure << "RENOVICE addon lifecycle FAULT " << addon.name
			<< " field=" << operation
			<< " exception_code=" << static_cast<std::uint32_t>(context.fault_code)
			<< " address=" << context.fault_address;
		config::log(failure.str());
		return false;
	}
	const char* reason = "protected-leaf-incomplete";
	switch (context.failure)
	{
	case LifecycleLeafFailure::stack_capacity:
		reason = "stack-capacity-unavailable";
		break;
	case LifecycleLeafFailure::exception_guard:
		reason = "exception-guard-unavailable";
		break;
	case LifecycleLeafFailure::lifecycle_root_not_table:
		reason = "lifecycle-root-not-table";
		break;
	case LifecycleLeafFailure::operation_not_function:
		reason = "operation-not-function";
		break;
	case LifecycleLeafFailure::protected_call_rejected:
		reason = "protected-call-rejected";
		break;
	case LifecycleLeafFailure::none:
	case LifecycleLeafFailure::native_fault:
		break;
	}
	log_failure(reason);
	return false;
}

bool read_loader_name_handle(void* descriptor, std::uint32_t (&output)[2]) noexcept
{
	if (descriptor == nullptr || diagnostics::bad_read_ptr(descriptor, 0x60)) return false;
	void* name_object = *reinterpret_cast<void**>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x08);
	if (name_object == nullptr || diagnostics::bad_read_ptr(name_object, 0x30)) return false;
	void** first_pointer = reinterpret_cast<void**>(
		reinterpret_cast<unsigned char*>(name_object) + 0x10);
	auto* second = reinterpret_cast<std::uint32_t*>(
		reinterpret_cast<unsigned char*>(name_object) + 0x2c);
	if (diagnostics::bad_read_ptr(first_pointer, sizeof(*first_pointer))
		|| *first_pointer == nullptr
		|| diagnostics::bad_read_ptr(*first_pointer, sizeof(std::uint32_t))
		|| diagnostics::bad_read_ptr(second, sizeof(*second)))
	{
		return false;
	}
	output[0] = *reinterpret_cast<std::uint32_t*>(*first_pointer);
	output[1] = *second;
	return true;
}

TargetLoadBoundary inspect_target_load(void* descriptor) noexcept
{
	TargetLoadBoundary boundary;
	if (descriptor == nullptr || diagnostics::bad_read_ptr(descriptor, 0x44)
		|| !read_loader_name_handle(descriptor, boundary.name_handle))
	{
		return boundary;
	}
	auto* body = *reinterpret_cast<unsigned char**>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x38);
	const auto size = *reinterpret_cast<std::uint32_t*>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x40);
	if (body == nullptr || size == 0 || size >= (1u << 28)
		|| diagnostics::bad_read_ptr(body, size))
	{
		return boundary;
	}
	const bool inspect_pause_menu = scripts_ui_attachment_requested(
		subsystem_enabled.load(std::memory_order_acquire),
		scripts_ui_enabled.load(std::memory_order_acquire));
	boundary.pause_menu = inspect_pause_menu
		&& pause_top_menu_signature(body, size);
	const bool inspect_addon_target = observe_target_addons.load(std::memory_order_acquire);
	boundary.diagnostic_damage_source = universal_observer_requested(
		config::flags());
	if (!boundary.pause_menu && !inspect_addon_target
		&& !boundary.diagnostic_damage_source)
	{
		return boundary;
	}
	boundary.key = replacements::body_key(std::string_view(
		reinterpret_cast<const char*>(body), size));
	boundary.addon_target = inspect_addon_target
		&& target_key_is_configured(boundary.key);
	boundary.valid = boundary.key != 0
		&& (boundary.pause_menu || boundary.addon_target
			|| boundary.diagnostic_damage_source);
	return boundary;
}

void dump_pause_menu_body_once(
	const TargetLoadBoundary& boundary,
	void* descriptor
) noexcept
{
	if (!boundary.pause_menu || boundary.key == 0 || descriptor == nullptr
		|| diagnostics::bad_read_ptr(descriptor, 0x44))
	{
		return;
	}
	bool expected = false;
	if (!pause_menu_body_dumped.compare_exchange_strong(
		expected, true, std::memory_order_acq_rel))
	{
		return;
	}
	try
	{
		auto* body = *reinterpret_cast<unsigned char**>(
			reinterpret_cast<unsigned char*>(descriptor) + 0x38);
		const auto size = *reinterpret_cast<std::uint32_t*>(
			reinterpret_cast<unsigned char*>(descriptor) + 0x40);
		if (body == nullptr || size == 0 || size >= (1u << 28)
			|| diagnostics::bad_read_ptr(body, size))
		{
			config::log("RENOVICE Scripts UI bytecode dump FAIL reason=invalid-body");
			return;
		}
		const auto directory = config::custom_scripts_directory() / L"Diagnostics";
		std::error_code ec;
		std::filesystem::create_directories(directory, ec);
		if (ec)
		{
			config::log("RENOVICE Scripts UI bytecode dump FAIL reason=create-directory");
			return;
		}
		const auto destination = directory / L"TopMenu.current.lua_B";
		const auto temporary = directory / L"TopMenu.current.lua_B.tmp";
		{
			std::ofstream output(temporary, std::ios::binary | std::ios::trunc);
			if (!output
				|| !output.write(
					reinterpret_cast<const char*>(body),
					static_cast<std::streamsize>(size)))
			{
				config::log("RENOVICE Scripts UI bytecode dump FAIL reason=write");
				return;
			}
			output.flush();
			if (!output)
			{
				config::log("RENOVICE Scripts UI bytecode dump FAIL reason=flush");
				return;
			}
		}
		std::filesystem::remove(destination, ec);
		ec.clear();
		std::filesystem::rename(temporary, destination, ec);
		if (ec)
		{
			config::log("RENOVICE Scripts UI bytecode dump FAIL reason=commit");
			return;
		}
		std::ostringstream success;
		success << "RENOVICE Scripts UI bytecode dump PASS key=" << std::hex
			<< boundary.key << std::dec << " bytes=" << size
			<< " path=" << destination.string();
		config::log(success.str());
	}
	catch (...)
	{
		config::log("RENOVICE Scripts UI bytecode dump FAIL reason=exception");
	}
}

bool target_chunk_exists(std::uint64_t target_key)
{
	std::lock_guard lock(generation_mutex);
	return std::any_of(active_chunks.begin(), active_chunks.end(), [&](const Chunk& chunk)
	{
		return chunk.kind == ScriptKind::TargetManagedAddon
			&& chunk.target_key == target_key;
	});
}

bool target_key_is_configured(std::uint64_t target_key)
{
	std::lock_guard lock(generation_mutex);
	return std::binary_search(
		configured_target_keys.begin(), configured_target_keys.end(), target_key);
}

bool target_chunks_configured_locked() noexcept
{
	return std::any_of(active_chunks.begin(), active_chunks.end(), [](const Chunk& chunk)
	{
		return chunk.kind == ScriptKind::TargetManagedAddon;
	});
}

void remember_target_script_binding_from_boundary(
	std::uint64_t target_key,
	luau_State* state,
	const ActiveRunScriptBoundary& boundary
)
{
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	if (state == nullptr || boundary.generation != active_generation
		|| !run_script_boundary_is_live(boundary, state)
		|| !target_script_binding_capture_allowed(
		target_key,
		state->global_state,
		owner_thread,
		boundary.active,
		boundary.global_state,
		boundary.owner_thread,
		boundary.script_resource_identity))
	{
		return;
	}

	TargetScriptBinding binding{
		target_key,
		state->global_state,
		boundary.script_resource_identity,
		boundary.ability_identity,
		owner_thread,
	};
	std::lock_guard lock(generation_mutex);
	const auto duplicate = std::find_if(
		target_script_bindings.begin(), target_script_bindings.end(),
		[&](const TargetScriptBinding& existing)
		{
			return same_target_script_binding(
				existing.target_key, existing.global_state,
				existing.script_resource_identity,
				binding.target_key, binding.global_state,
				binding.script_resource_identity);
		});
	if (duplicate != target_script_bindings.end())
	{
		duplicate->ability_identity = binding.ability_identity;
		duplicate->owner_thread = owner_thread;
		return;
	}

	target_script_bindings.push_back(binding);
	std::ostringstream success;
	success << "RENOVICE target script binding PASS key=" << std::hex
		<< target_key << std::dec
		<< " vm=" << binding.global_state
		<< " script=" << reinterpret_cast<void*>(binding.script_resource_identity)
		<< " ability=" << reinterpret_cast<void*>(binding.ability_identity)
		<< " thread=" << owner_thread;
	conout << success.str() << std::endl;
	config::log(success.str());
}

void remember_target_script_binding(
	std::uint64_t target_key,
	luau_State* state
)
{
	// RunScript no longer lends its generation across the stock callback. The
	// nested loader borrows the current generation only for this publication.
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return;
	const auto boundary = active_run_script_boundary;
	remember_target_script_binding_from_boundary(target_key, state, boundary);
}

std::uint64_t target_key_for_script_resource(
	const luau_GlobalState* global_state,
	std::uintptr_t script_resource_identity
) noexcept
{
	if (global_state == nullptr || script_resource_identity == 0) return 0;
	std::lock_guard lock(generation_mutex);
	std::uint64_t matched_key = 0;
	for (auto it = target_script_bindings.rbegin();
		it != target_script_bindings.rend(); ++it)
	{
		if (it->global_state != global_state
			|| it->script_resource_identity != script_resource_identity)
		{
			continue;
		}
		if (matched_key != 0 && matched_key != it->target_key)
		{
			return 0;
		}
		matched_key = it->target_key;
	}
	return matched_key;
}

void remember_target_module_identity(
	std::uint64_t target_key,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle
)
{
	if (target_key == 0 || state == nullptr || state->outtop == nullptr
		|| state->global_state == nullptr || manager == nullptr
		|| name_handle == nullptr
		|| !target_key_is_configured(target_key))
	{
		return;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	auto* const base = state->outtop;
	char registry_key[0x110]{};
	key_builder(registry_key, 0x104, const_cast<std::uint32_t*>(name_handle));
	getfield(state, -10000, registry_key);
	luau_Closure* closure = nullptr;
	if (!readable_lua_closure(*base, closure) || closure->isC
		|| closure->env == nullptr || closure->l.p == nullptr)
	{
		state->outtop = base;
		return;
	}
	TargetModuleIdentity identity{
		target_key,
		state->global_state,
		closure->env,
		closure->l.p,
		manager,
		{name_handle[0], name_handle[1]},
		static_cast<std::uint32_t>(GetCurrentThreadId()),
		false,
		{},
	};
	{
		std::lock_guard lock(generation_mutex);
		for (auto& existing : target_module_identities)
		{
			if (existing.target_key == target_key
				&& existing.global_state == identity.global_state
				&& existing.root_proto == identity.root_proto
				&& existing.environment == identity.environment)
			{
				existing.manager = manager;
				existing.name_handle[0] = name_handle[0];
				existing.name_handle[1] = name_handle[1];
				existing.owner_thread = identity.owner_thread;
				state->outtop = base;
				return;
			}
		}
	}
	TargetProtoGraph graph;
	if (game_version >= GV(43, 0, 0) && game_version < GV(45, 0, 0))
	{
		graph = collect_target_proto_graph_u43(
			reinterpret_cast<std::uintptr_t>(closure->l.p),
			[](std::uintptr_t address, void* output, std::size_t size)
			{
				SIZE_T copied = 0;
				return ReadProcessMemory(GetCurrentProcess(),
					reinterpret_cast<const void*>(address), output, size, &copied)
					&& copied == size;
			});
	}
	else graph.error = "unsupported-prototype-layout-version";
	if (graph.error == nullptr && setfield != nullptr)
	{
		// Snapshots survive reloads. Root the original closure for exactly that
		// lifetime, so GC cannot recycle a published prototype address.
		std::ostringstream pin;
		pin << "RENOVICE.prototype-root." << std::hex << target_key << '.' << closure->l.p;
		setfield(state, -10000, pin.str().c_str());
		state->outtop = base;
		getfield(state, -10000, pin.str().c_str());
		luau_Closure* readback = nullptr;
		if (!readable_lua_closure(*base, readback) || readback != closure)
			graph.error = "prototype-root-registry-readback";
	}
	else if (graph.error == nullptr) graph.error = "prototype-root-registry-unavailable";
	if (graph.error != nullptr)
	{
		trace_addon(state, target_key, "module.graph.reject", graph.error);
	}
	else
	{
		identity.prototypes = std::move(graph.records);
		std::ostringstream details;
		details << "root=" << identity.root_proto << " environment=" << identity.environment
			<< " nodes=" << identity.prototypes.size() << " registry_rooted=1";
		trace_addon(state, target_key, "module.graph.ready", details.str());
		for (const auto& proto : identity.prototypes)
		{
			std::ostringstream record;
			record << "proto=0x" << std::hex << proto.address << " parent=0x" << proto.parent
				<< " code=0x" << proto.code << std::dec << " instructions=" << proto.instructions
				<< " bytecode_id=" << proto.bytecode_id;
			trace_addon(state, target_key, "module.prototype", record.str());
		}
	}
	state->outtop = base;
	std::lock_guard lock(generation_mutex);
	const auto duplicate = std::find_if(
		target_module_identities.begin(), target_module_identities.end(),
		[&](const TargetModuleIdentity& existing)
		{
			return existing.target_key == identity.target_key
				&& existing.global_state == identity.global_state
				&& existing.environment == identity.environment
				&& existing.root_proto == identity.root_proto;
		});
	if (duplicate != target_module_identities.end())
	{
		duplicate->manager = manager;
		duplicate->name_handle[0] = name_handle[0];
		duplicate->name_handle[1] = name_handle[1];
		duplicate->owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	}
	else
	{
		target_module_identities.push_back(identity);
		std::ostringstream success;
		success << "RENOVICE target module identity PASS key=" << std::hex
			<< target_key << std::dec << " env=" << identity.environment
			<< " proto=" << identity.root_proto;
		conout << success.str() << std::endl;
		config::log(success.str());
	}
	publish_target_execution_snapshot_locked();
}

void remember_diagnostic_module_identity(
	std::uint64_t body_key,
	luau_State* state,
	const std::uint32_t* name_handle
)
{
	if (body_key == 0 || state == nullptr || state->outtop == nullptr
		|| state->global_state == nullptr || name_handle == nullptr
		|| key_builder == nullptr || getfield == nullptr || setfield == nullptr
		|| check_stack == nullptr)
	{
		return;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	const auto base_offset = luau_savestack(state, state->outtop);
	char registry_key[0x110]{};
	key_builder(registry_key, 0x104, const_cast<std::uint32_t*>(name_handle));
	getfield(state, -10000, registry_key);
	auto* const base = luau_restorestack(state, base_offset);
	luau_Closure* closure = nullptr;
	if (!readable_lua_closure(*base, closure) || closure->isC
		|| closure->l.p == nullptr)
	{
		state->outtop = base;
		return;
	}
	{
		std::lock_guard lock(generation_mutex);
		const auto duplicate = std::any_of(
			diagnostic_module_roots.begin(), diagnostic_module_roots.end(),
			[&](const DiagnosticModuleRoot& root)
			{
				return root.global_state == state->global_state
					&& root.root_proto == closure->l.p;
			});
		if (duplicate)
		{
			state->outtop = base;
			return;
		}
	}

	TargetProtoGraph graph;
	if (game_version >= GV(43, 0, 0) && game_version < GV(45, 0, 0))
	{
		graph = collect_target_proto_graph_u43(
			reinterpret_cast<std::uintptr_t>(closure->l.p),
			[](std::uintptr_t address, void* output, std::size_t size)
			{
				SIZE_T copied = 0;
				return ReadProcessMemory(
					GetCurrentProcess(), reinterpret_cast<const void*>(address),
					output, size, &copied) && copied == size;
			});
	}
	else graph.error = "unsupported-prototype-layout-version";
	if (graph.error != nullptr)
	{
		state->outtop = base;
		config::diagnostic_log(
			std::string("RENOVICE automatic damage module reject reason=")
				+ graph.error,
			config::DiagnosticsMode::errors);
		return;
	}

	std::ostringstream pin;
	pin << "RENOVICE.auto-damage-prototype-root." << std::hex << body_key
		<< '.' << closure->l.p;
	setfield(state, -10000, pin.str().c_str());
	state->outtop = base;
	getfield(state, -10000, pin.str().c_str());
	luau_Closure* rooted = nullptr;
	if (!readable_lua_closure(*base, rooted) || rooted != closure)
	{
		state->outtop = base;
		config::diagnostic_log(
			"RENOVICE automatic damage module reject reason=registry-root-readback",
			config::DiagnosticsMode::errors);
		return;
	}
	state->outtop = base;

	const auto module_path = bounded_diagnostic_text(
		readable_string_handle(name_handle[0]));
	const auto module_name = bounded_diagnostic_text(
		readable_string_handle(name_handle[1]));
	std::lock_guard lock(generation_mutex);
	const auto duplicate = std::any_of(
		diagnostic_module_roots.begin(), diagnostic_module_roots.end(),
		[&](const DiagnosticModuleRoot& root)
		{
			return root.global_state == state->global_state
				&& root.root_proto == closure->l.p;
		});
	if (duplicate) return;
	diagnostic_module_roots.push_back(
		{body_key, state->global_state, closure->l.p, pin.str()});
	for (const auto& proto : graph.records)
	{
		auto owned = std::make_unique<DiagnosticProtoIdentity>();
		owned->address = proto.address;
		owned->code = proto.code;
		owned->instructions = proto.instructions;
		owned->bytecode_id = proto.bytecode_id;
		owned->body_key = body_key;
		owned->global_state = state->global_state;
		owned->module_path = module_path;
		owned->module_name = module_name;
		auto* const published = owned.get();
		diagnostic_proto_storage.emplace_back(std::move(owned));
		auto& bucket = diagnostic_proto_buckets[
			diagnostic_proto_bucket(proto.address)];
		auto* head = bucket.load(std::memory_order_relaxed);
		do
		{
			published->next = head;
		}
		while (!bucket.compare_exchange_weak(
			head, published, std::memory_order_release,
			std::memory_order_relaxed));
	}
}

struct ClearDiagnosticModuleRootsContext
{
	const char* const* registry_keys = nullptr;
	std::size_t registry_key_count = 0;
	std::size_t failure_index = static_cast<std::size_t>(-1);
	bool completed = false;
	bool passed = false;
};
static_assert(std::is_trivially_copyable_v<ClearDiagnosticModuleRootsContext>);

// BEGIN CLEAR_DIAGNOSTIC_MODULE_ROOTS_PROTECTED_LEAF
void clear_diagnostic_module_roots_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<ClearDiagnosticModuleRootsContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| context->registry_keys == nullptr || context->registry_key_count == 0
		|| check_stack == nullptr || getfield == nullptr || setfield == nullptr)
	{
		if (context != nullptr) context->completed = true;
		return;
	}
	if (check_stack(state, 2) == 0)
	{
		context->completed = true;
		return;
	}
	luau_TValue nil{};
	nil.type = LUAU_NIL;
	for (std::size_t index = 0; index < context->registry_key_count; ++index)
	{
		const char* const key = context->registry_keys[index];
		if (key == nullptr || !ui_leaf_write_registry_value(state, key, nil))
		{
			context->failure_index = index;
			context->completed = true;
			return;
		}
	}
	context->passed = true;
	context->completed = true;
}
// END CLEAR_DIAGNOSTIC_MODULE_ROOTS_PROTECTED_LEAF

bool clear_diagnostic_module_roots_for_vm(luau_State* state)
{
	if (state == nullptr || state->outtop == nullptr || state->global_state == nullptr
		|| getfield == nullptr || setfield == nullptr || check_stack == nullptr)
	{
		return false;
	}
	{
		std::lock_guard lock(generation_mutex);
		if (std::none_of(
			diagnostic_module_roots.begin(), diagnostic_module_roots.end(),
			[&](const DiagnosticModuleRoot& root)
			{
				return root.global_state == state->global_state;
			}))
		{
			diagnostic_root_cleanup_pending.store(
				!diagnostic_module_roots.empty(), std::memory_order_release);
			return true;
		}
	}

	auto generation_mutation = generation_dispatch_gate.begin_mutation(
		std::chrono::seconds(5));
	if (!generation_mutation) return false;
	const auto* const global_state = state->global_state;
	std::vector<std::string> registry_key_storage;
	bool any_roots_remain = false;
	{
		std::lock_guard lock(generation_mutex);
		any_roots_remain = !diagnostic_module_roots.empty();
		for (const auto& root : diagnostic_module_roots)
		{
			if (root.global_state == global_state)
				registry_key_storage.push_back(root.registry_key);
		}
	}
	if (registry_key_storage.empty())
	{
		diagnostic_root_cleanup_pending.store(
			any_roots_remain, std::memory_order_release);
		return true;
	}
	std::vector<const char*> registry_keys;
	registry_keys.reserve(registry_key_storage.size());
	for (const auto& key : registry_key_storage)
		registry_keys.push_back(key.c_str());
	ClearDiagnosticModuleRootsContext context{};
	context.registry_keys = registry_keys.data();
	context.registry_key_count = registry_keys.size();
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &clear_diagnostic_module_roots_protected_leaf, &context);
	const bool cleared = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed && context.passed;
	if (!cleared) return false;

	std::lock_guard lock(generation_mutex);
	diagnostic_module_roots.erase(std::remove_if(
		diagnostic_module_roots.begin(), diagnostic_module_roots.end(),
		[&](const DiagnosticModuleRoot& root)
		{
			return root.global_state == global_state;
		}), diagnostic_module_roots.end());
	diagnostic_proto_storage.erase(std::remove_if(
		diagnostic_proto_storage.begin(), diagnostic_proto_storage.end(),
		[&](const std::unique_ptr<DiagnosticProtoIdentity>& identity)
		{
			return identity->global_state == global_state;
		}), diagnostic_proto_storage.end());
	for (auto& bucket : diagnostic_proto_buckets)
		bucket.store(nullptr, std::memory_order_release);
	for (const auto& identity : diagnostic_proto_storage)
	{
		auto& bucket = diagnostic_proto_buckets[
			diagnostic_proto_bucket(identity->address)];
		auto* head = bucket.load(std::memory_order_relaxed);
		identity->next = head;
		bucket.store(identity.get(), std::memory_order_release);
	}
	diagnostic_root_cleanup_pending.store(
		!diagnostic_module_roots.empty(), std::memory_order_release);
	return true;
}

void remember_pause_menu_identity(
	std::uint64_t body_key,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle
)
{
	if (body_key == 0 || state == nullptr || state->outtop == nullptr
		|| state->global_state == nullptr || manager == nullptr
		|| name_handle == nullptr || key_builder == nullptr || getfield == nullptr
		|| check_stack == nullptr)
	{
		return;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	auto* const base = state->outtop;
	char registry_key[0x110]{};
	key_builder(registry_key, 0x104, const_cast<std::uint32_t*>(name_handle));
	getfield(state, -10000, registry_key);
	luau_Closure* closure = nullptr;
	if (!readable_lua_closure(*base, closure) || closure->isC
		|| closure->env == nullptr || closure->l.p == nullptr)
	{
		state->outtop = base;
		config::log("RENOVICE Scripts UI identity FAIL reason=root-closure-unavailable");
		return;
	}
	TargetModuleIdentity identity{
		body_key,
		state->global_state,
		closure->env,
		closure->l.p,
		manager,
		{name_handle[0], name_handle[1]},
		static_cast<std::uint32_t>(GetCurrentThreadId()),
	};
	state->outtop = base;
	std::lock_guard lock(generation_mutex);
	const auto duplicate = std::find_if(
		pause_menu_identities.begin(), pause_menu_identities.end(),
		[&](const TargetModuleIdentity& existing)
		{
			return existing.target_key == identity.target_key
				&& existing.global_state == identity.global_state
				&& existing.environment == identity.environment
				&& existing.root_proto == identity.root_proto;
		});
	if (duplicate != pause_menu_identities.end())
	{
		duplicate->manager = manager;
		duplicate->name_handle[0] = name_handle[0];
		duplicate->name_handle[1] = name_handle[1];
		duplicate->owner_thread = identity.owner_thread;
		published_pause_root_proto.store(
			identity.root_proto, std::memory_order_release);
		published_pause_global_state.store(
			identity.global_state, std::memory_order_release);
		return;
	}
	pause_menu_identities.push_back(identity);
	// Publish an exact, lock-free rejection key for the process-wide VM entry
	// hook. Every unrelated script now bypasses the identity vector and mutex.
	published_pause_root_proto.store(identity.root_proto, std::memory_order_release);
	published_pause_global_state.store(identity.global_state, std::memory_order_release);
	std::ostringstream success;
	success << "RENOVICE Scripts UI identity PASS key=" << std::hex
		<< body_key << std::dec << " vm=" << identity.global_state
		<< " env=" << identity.environment << " proto=" << identity.root_proto;
	conout << success.str() << std::endl;
	config::log(success.str());
}

bool decorate_target_card_export(
	std::uint64_t target_key,
	luau_State* state,
	const std::uint32_t* name_handle
)
{
	if (target_key == 0 || state == nullptr || state->outtop == nullptr
		|| name_handle == nullptr || getfield == nullptr || setfield == nullptr
		|| key_builder == nullptr || check_stack == nullptr
		|| luau_pushcclosurek == nullptr || !target_chunk_exists(target_key))
	{
		return false;
	}

	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 8);
	auto* const base = state->outtop;
	char registry_key[0x110]{};
	key_builder(registry_key, 0x104, const_cast<std::uint32_t*>(name_handle));
	getfield(state, -10000, registry_key);
	luau_Closure* root = nullptr;
	if (!readable_lua_closure(*base, root) || root->isC || root->env == nullptr)
	{
		state->outtop = base;
		config::log("RENOVICE card export attach FAIL reason=root-closure-unavailable");
		return false;
	}
	state->outtop = base;
	if (!push_environment_table(state, root->env, base))
	{
		state->outtop = base;
		config::log("RENOVICE card export attach FAIL reason=module-environment-not-table");
		return false;
	}
	getfield(state, -1, "GetAbilityUpgradeLevelInfo");
	luau_Closure* original_closure = nullptr;
	if (!readable_lua_closure(*(base + 1), original_closure))
	{
		state->outtop = base;
		config::log("RENOVICE card export attach FAIL reason=export-not-function");
		return false;
	}
	if (original_closure->isC && original_closure->c.func == &ability_card_wrapper)
	{
		state->outtop = base;
		return true;
	}

	const auto original = *(base + 1);
	state->outtop = base + 1;
	push_stack_value(state, original);
	if (!luau_push_lightuserdata(
		state, reinterpret_cast<void*>(static_cast<std::uintptr_t>(target_key))))
	{
		state->outtop = base;
		config::log("RENOVICE card export attach FAIL reason=target-key-upvalue");
		return false;
	}
	luau_pushcclosurek(
		state, &ability_card_wrapper,
		"RENOVICE after-card dispatcher", 2, nullptr);
	setfield(state, -2, "GetAbilityUpgradeLevelInfo");

	// Verify the exact environment field the engine owns. This PASS is based on
	// readback, not on observing a C API call that bytecode never makes.
	state->outtop = base + 1;
	getfield(state, -1, "GetAbilityUpgradeLevelInfo");
	luau_Closure* installed = nullptr;
	const bool pass = readable_lua_closure(*(base + 1), installed)
		&& installed->isC && installed->c.func == &ability_card_wrapper;
	state->outtop = base;
	if (!pass)
	{
		config::log("RENOVICE card export attach FAIL reason=readback-mismatch");
		return false;
	}
	log_native_hook_once(
		state, target_key, "GetAbilityUpgradeLevelInfo.attach");
	return true;
}

enum class PauseInitializeInstallFailure : std::uint8_t
{
	none,
	prerequisite,
	stack_capacity,
	environment,
	closure_create,
	readback_mismatch,
};

struct PauseInitializeInstallContext
{
	void* environment = nullptr;
	luau_TValue* dispatch_slot = nullptr;
	luau_TValue original_dispatch{};
	PauseInitializeInstallFailure failure = PauseInitializeInstallFailure::none;
	bool completed = false;
	bool passed = false;
};
static_assert(std::is_trivially_copyable_v<PauseInitializeInstallContext>);

// BEGIN PAUSE_INITIALIZE_INSTALL_PROTECTED_LEAF
void decorate_pause_initialize_assignment_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<PauseInitializeInstallContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| context->environment == nullptr || context->dispatch_slot == nullptr
		|| check_stack == nullptr || setfield == nullptr
		|| luau_pushcclosurek == nullptr)
	{
		if (context != nullptr)
		{
			context->failure = PauseInitializeInstallFailure::prerequisite;
			context->completed = true;
		}
		return;
	}
	if (check_stack(state, 8) == 0)
	{
		context->failure = PauseInitializeInstallFailure::stack_capacity;
		context->completed = true;
		return;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!ui_leaf_push_environment_table(state, context->environment))
	{
		context->failure = PauseInitializeInstallFailure::environment;
		context->completed = true;
		return;
	}
	if (!append_game_vm_stack_value_reserved(
		state, context->original_dispatch))
	{
		context->failure = PauseInitializeInstallFailure::closure_create;
		context->completed = true;
		return;
	}
	luau_pushcclosurek(
		state, &pause_menu_builder_wrapper,
		"RENOVICE pause Scripts menu dispatch", 1, nullptr);
	auto* base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 2 || !is_function((base + 1)->type))
	{
		context->failure = PauseInitializeInstallFailure::closure_create;
		context->completed = true;
		return;
	}
	const auto wrapper_value = *(base + 1);
	setfield(state, -2, "_RENOVICEPauseMenuDispatchWrapper");
	*context->dispatch_slot = wrapper_value;

	luau_Closure* installed = nullptr;
	context->passed = readable_lua_closure(
		dereference_upvalue(*context->dispatch_slot), installed)
		&& installed->isC && installed->c.func == &pause_menu_builder_wrapper
		&& installed->nupvalues == 1
		&& dereference_upvalue(installed->c.upvals[0]).value.as_uintptr
			== context->original_dispatch.value.as_uintptr;
	if (!context->passed)
		context->failure = PauseInitializeInstallFailure::readback_mismatch;
	context->completed = true;
}
// END PAUSE_INITIALIZE_INSTALL_PROTECTED_LEAF

// BEGIN PAUSE_INITIALIZE_INSTALL_OUTER
bool decorate_pause_initialize_assignment(
	std::uint64_t body_key,
	luau_State* state,
	const luau_TValue& initialize_value,
	const char* source
)
{
	if (body_key == 0 || state == nullptr || state->outtop == nullptr
		|| setfield == nullptr || check_stack == nullptr
		|| luau_pushcclosurek == nullptr)
	{
		return false;
	}
	luau_Closure* initialize = nullptr;
	if (!readable_lua_closure(initialize_value, initialize) || initialize->isC
		|| initialize->env == nullptr)
	{
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=Initialize-assignment-shape"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " tag=" << initialize_value.type;
		config::log(failure.str());
		return false;
	}
	if (initialize->nupvalues != pause_initialize_upvalue_count)
	{
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=Initialize-upvalue-count"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " observed=" << static_cast<unsigned int>(initialize->nupvalues)
			<< " expected=" << pause_initialize_upvalue_count
			<< " stacksize=" << static_cast<unsigned int>(initialize->stacksize)
			<< " env=" << initialize->env;
		config::log(failure.str());
		return false;
	}
	auto* const builder_slot = writable_upvalue_slot(
		initialize, pause_initialize_builder_upvalue);
	if (builder_slot == nullptr)
	{
		config::log("RENOVICE Scripts UI attach FAIL reason=Initialize-builder-slot-unreadable");
		return false;
	}
	const auto builder_value = dereference_upvalue(*builder_slot);
	luau_Closure* original_builder = nullptr;
	if (!readable_lua_closure(builder_value, original_builder))
	{
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=Initialize-builder-not-function"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " tag=" << builder_value.type;
		config::log(failure.str());
		return false;
	}
	if (original_builder->isC
		|| !pause_top_menu_closure_contract(
			initialize->nupvalues, original_builder->nupvalues)
		|| original_builder->l.p == nullptr)
	{
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=builder-closure-contract"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " is_c=" << (original_builder->isC ? 1 : 0)
			<< " upvalues=" << static_cast<unsigned int>(original_builder->nupvalues)
			<< " stacksize=" << static_cast<unsigned int>(original_builder->stacksize)
			<< " proto=" << (original_builder->isC ? nullptr : original_builder->l.p)
			<< " env=" << original_builder->env;
		config::log(failure.str());
		return false;
	}
	auto* const dispatch_slot = writable_upvalue_slot(
		original_builder, pause_builder_dispatch_upvalue);
	if (dispatch_slot == nullptr)
	{
		config::log("RENOVICE Scripts UI attach FAIL reason=builder-dispatch-slot-unreadable");
		return false;
	}
	const auto original_dispatch = dereference_upvalue(*dispatch_slot);
	luau_Closure* dispatch = nullptr;
	if (!readable_lua_closure(original_dispatch, dispatch))
	{
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=builder-dispatch-not-function"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " tag=" << original_dispatch.type;
		config::log(failure.str());
		return false;
	}
	if (dispatch->isC && dispatch->c.func == &pause_menu_builder_wrapper)
	{
		config::log("RENOVICE Scripts UI attach PASS reason=already-installed");
		return true;
	}

	// Root the generated closure through a normal environment-table write before
	// assigning it into DE's captured dispatch upvalue.  The wrapper receives
	// the completed stock mMenuOptions array as its normal first Lua argument.
	PauseInitializeInstallContext context{};
	context.environment = initialize->env;
	context.dispatch_slot = dispatch_slot;
	context.original_dispatch = original_dispatch;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &decorate_pause_initialize_assignment_protected_leaf, &context);
	const bool pass = protected_result.admitted && protected_result.restored
		&& protected_result.status == 0 && context.completed && context.passed;
	if (!pass && context.failure == PauseInitializeInstallFailure::environment)
	{
		config::log("RENOVICE Scripts UI attach FAIL reason=Initialize-environment-not-table");
	}
	std::ostringstream result;
	result << "RENOVICE Scripts UI attach " << (pass ? "PASS" : "FAIL")
		<< " source=" << (source != nullptr ? source : "unknown")
		<< " owner=Initialize.U" << pause_initialize_builder_upvalue
		<< ".Builder.U" << pause_builder_dispatch_upvalue
		<< " initialize=" << reinterpret_cast<void*>(initialize_value.value.as_uintptr)
		<< " builder=" << reinterpret_cast<void*>(builder_value.value.as_uintptr)
		<< " dispatch=" << reinterpret_cast<void*>(original_dispatch.value.as_uintptr)
		<< " top_menu_key=" << std::hex << body_key << std::dec;
	conout << result.str() << std::endl;
	config::log(result.str());
	return pass;
}
// END PAUSE_INITIALIZE_INSTALL_OUTER

struct PauseEnvironmentReadContext
{
	void* environment = nullptr;
	luau_TValue initialize_value{};
	void* initialize_environment = nullptr;
	std::uint32_t menu_options_tag = LUAU_NIL;
	std::uint32_t initialize_tag = LUAU_NIL;
	std::uint8_t initialize_upvalues = 0;
	bool completed = false;
	bool environment_is_table = false;
	bool menu_options_is_table = false;
	bool initialize_is_lua = false;
};
static_assert(std::is_trivially_copyable_v<PauseEnvironmentReadContext>);

// BEGIN PAUSE_ENVIRONMENT_READ_PROTECTED_LEAF
void decorate_pause_menu_environment_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<PauseEnvironmentReadContext*>(raw_context);
	if (context == nullptr || state == nullptr || state->outtop == nullptr
		|| context->environment == nullptr || getfield == nullptr
		|| check_stack == nullptr)
	{
		if (context != nullptr) context->completed = true;
		return;
	}
	if (check_stack(state, 8) == 0)
	{
		context->completed = true;
		return;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	if (!ui_leaf_push_environment_table(state, context->environment))
	{
		context->completed = true;
		return;
	}
	auto* base = luau_restorestack(state, base_offset);
	context->environment_is_table = state->outtop == base + 1
		&& is_table(base->type);
	if (!context->environment_is_table)
	{
		context->completed = true;
		return;
	}
	getfield(state, -1, "mMenuOptions");
	base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 2)
	{
		context->completed = true;
		return;
	}
	context->menu_options_tag = (base + 1)->type;
	context->menu_options_is_table = is_table((base + 1)->type);
	state->outtop = base + 1;
	if (!context->menu_options_is_table)
	{
		context->completed = true;
		return;
	}
	getfield(state, -1, "Initialize");
	base = luau_restorestack(state, base_offset);
	if (state->outtop != base + 2)
	{
		context->completed = true;
		return;
	}
	context->initialize_tag = (base + 1)->type;
	context->initialize_value = *(base + 1);
	luau_Closure* initialize = nullptr;
	context->initialize_is_lua = readable_lua_closure(
		context->initialize_value, initialize) && !initialize->isC;
	if (context->initialize_is_lua)
	{
		context->initialize_environment = initialize->env;
		context->initialize_upvalues = initialize->nupvalues;
	}
	context->completed = true;
}
// END PAUSE_ENVIRONMENT_READ_PROTECTED_LEAF

bool decorate_pause_menu_environment(
	std::uint64_t body_key,
	luau_State* state,
	void* environment,
	const char* source
)
{
	if (body_key == 0 || state == nullptr || state->outtop == nullptr
		|| state->global_state == nullptr || environment == nullptr
		|| getfield == nullptr || setfield == nullptr
		|| check_stack == nullptr || luau_pushcclosurek == nullptr
		|| diagnostics::bad_read_ptr(environment, sizeof(std::uint8_t)))
	{
		return false;
	}
	// The exact root publishes mMenuOptions at instruction 49 and Initialize at
	// instruction 687 into its own closure environment. Startup VM returns can
	// precede both writes, so use mMenuOptions as the semantic publication gate
	// and keep this exact identity pending until the state exists.
	PauseEnvironmentReadContext context{};
	context.environment = environment;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		state, &decorate_pause_menu_environment_protected_leaf, &context);
	const bool read_completed = protected_result.admitted
		&& protected_result.restored && protected_result.status == 0
		&& context.completed;
	if (!read_completed || !context.environment_is_table)
	{
		config::log("RENOVICE Scripts UI attach FAIL reason=TopMenu-environment-not-table");
		return false;
	}
	if (!context.menu_options_is_table)
	{
		if (source != nullptr
			&& std::strcmp(source, "vm-runtime-root-return") == 0)
		{
			std::ostringstream failure;
			failure << "RENOVICE Scripts UI attach FAIL reason=runtime-mMenuOptions-not-table"
				<< " tag=" << static_cast<int>(context.menu_options_tag)
				<< " runtime_env=" << environment;
			config::log(failure.str());
		}
		return false;
	}
	if (!context.initialize_is_lua)
	{
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=published-Initialize-not-lua-function"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " initialize_tag=" << static_cast<int>(context.initialize_tag);
		config::log(failure.str());
		return false;
	}
	if (!pause_environment_publication_ready(
		context.menu_options_is_table, environment,
		context.initialize_environment, true, context.initialize_upvalues))
	{
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=published-Initialize-owner"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " recorded_env=" << environment
			<< " initialize_env=" << context.initialize_environment
			<< " upvalues=" << static_cast<unsigned int>(context.initialize_upvalues);
		config::log(failure.str());
		return false;
	}
	return decorate_pause_initialize_assignment(
		body_key, state, context.initialize_value,
		"published-TopMenu-environment");
}

TargetExecutionBoundary inspect_pause_vm_root_execution(
	luau_State* state
) noexcept
{
	TargetExecutionBoundary boundary;
	if (!scripts_ui_attachment_requested(
			subsystem_enabled.load(std::memory_order_acquire),
			scripts_ui_enabled.load(std::memory_order_acquire))
		|| state == nullptr || state->ci == nullptr || state->ci->func == nullptr
		|| state->global_state == nullptr
		|| diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		|| diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue)))
	{
		return boundary;
	}
	const auto function = *state->ci->func;
	luau_Closure* closure = nullptr;
	if (!readable_lua_closure(function, closure) || closure->isC
		|| closure->l.p == nullptr || closure->env == nullptr)
	{
		return boundary;
	}
	// This hook is process-wide, but the ownership test is exact and lock-free
	// for every unrelated script. Only the published TopMenu root reaches the
	// identity vector and its mutex.
	if (!pause_exact_root_published(
		published_pause_global_state.load(std::memory_order_acquire),
		published_pause_root_proto.load(std::memory_order_acquire),
		state->global_state,
		closure->l.p))
	{
		return boundary;
	}

	std::lock_guard lock(generation_mutex);
	for (auto it = pause_menu_identities.rbegin();
		it != pause_menu_identities.rend(); ++it)
	{
		const bool owned = pause_runtime_root_owned(
			it->global_state, it->root_proto,
			state->global_state, closure->l.p, closure->env);
		if (pause_runtime_root_requires_revalidation(owned, it->pause_attached))
		{
			boundary.key = it->target_key;
			boundary.name_handle[0] = it->name_handle[0];
			boundary.name_handle[1] = it->name_handle[1];
			boundary.environment = closure->env;
			boundary.global_state = state->global_state;
			boundary.root_proto = closure->l.p;
			boundary.valid = true;
			break;
		}
	}
	return boundary;
}

bool read_memory_evidence(const void* address, void* output, std::size_t size) noexcept
{
    SIZE_T copied = 0;
    return ReadProcessMemory(GetCurrentProcess(), address, output, size, &copied)
        && copied == size;
}

void append_memory_hex(std::ostringstream& out, const unsigned char* data, std::size_t size)
{
    constexpr char digits[] = "0123456789ABCDEF";
    for (std::size_t i = 0; i != size; ++i) {
        out.put(digits[data[i] >> 4]);
        out.put(digits[data[i] & 15]);
    }
}

void capture_vm_memory_evidence(luau_State* state, std::uint64_t sequence, std::uint64_t tick_ms) noexcept
{
    // Separate body: disabled/intervening VM returns do not reserve this buffer.
    // These are bounded Windows reads, not Lua API calls or GC control.
    try {
        std::array<unsigned char, 0x4040> global{};
        std::ostringstream out;
        FILETIME utc{};
        GetSystemTimeAsFileTime(&utc);
        out << "RENOVICE VM_MEMORY build=V96 pid=" << GetCurrentProcessId()
            << " vm=" << state->global_state << " thread=" << GetCurrentThreadId()
            << " tick_ms=" << tick_ms << " utc_filetime="
            << ((static_cast<std::uint64_t>(utc.dwHighDateTime) << 32) | utc.dwLowDateTime)
            << " sequence=" << sequence << " exe_base=" << GetModuleHandleW(nullptr)
            << " dll_base=" << GetModuleHandleW(L"WTSAPI32.dll") << " non_atomic=1";
        if (!read_memory_evidence(state->global_state, global.data(), global.size())) {
            out << " global_read=unavailable";
            config::memory_log(out.str());
            return;
        }
        const auto u64 = [&](std::size_t offset) {
            std::uint64_t result = 0;
            std::memcpy(&result, global.data() + offset, sizeof(result));
            return result;
        };
        std::uint32_t cycles = 0;
        std::memcpy(&cycles, global.data() + 0x4000, sizeof(cycles));
        const auto lua_bytes = u64(0x48);
        out << " lua_bytes=" << lua_bytes << " gc_state=" << static_cast<unsigned>(global[0x22])
            << " completed_cycles=" << cycles << " gc_threshold=" << u64(0x40)
            << " gray=" << reinterpret_cast<void*>(u64(0x28))
            << " gray_again=" << reinterpret_cast<void*>(u64(0x30))
            << " weak=" << reinterpret_cast<void*>(u64(0x38));
        PROCESS_MEMORY_COUNTERS_EX memory{};
        memory.cb = sizeof(memory);
        if (K32GetProcessMemoryInfo(GetCurrentProcess(),
                reinterpret_cast<PROCESS_MEMORY_COUNTERS*>(&memory), sizeof(memory)))
            out << " working_set=" << memory.WorkingSetSize << " private_bytes=" << memory.PrivateUsage;
        else out << " process_memory=unavailable";
        if (lua_bytes >= 64ull * 1024ull * 1024ull) {
            out << " raw_gc_roots=";
            append_memory_hex(out, global.data() + 0x20, 0x60);
            for (const auto root_offset : {0x28u, 0x30u, 0x38u}) {
                std::array<std::uint64_t, 8> seen{};
                auto address = u64(root_offset);
                out << " queue_" << root_offset << "={";
                const char* stop = "end-of-list";
                for (std::size_t index = 0; address != 0; ++index) {
                    if (index == seen.size()) { stop = "node-budget"; break; }
                    if (std::find(seen.begin(), seen.begin() + index, address) != seen.begin() + index) {
                        stop = "repeated-address-or-race"; break;
                    }
                    seen[index] = address;
                    std::array<unsigned char, 144> object{};
                    if (!read_memory_evidence(reinterpret_cast<void*>(address), object.data(), object.size())) {
                        stop = "object-unavailable"; break;
                    }
                    out << " node=" << reinterpret_cast<void*>(address)
                        << ':' << static_cast<unsigned>(object[0]) << ':';
                    append_memory_hex(out, object.data(), object.size());
                    const auto link = native_gray_link_offset_u43(object[0]);
                    if (link < 0) { stop = "unsupported-gray-tag"; break; }
                    std::memcpy(&address, object.data() + link, sizeof(address));
                }
                out << " stop=" << stop << " remaining=" << reinterpret_cast<void*>(address) << '}';
            }
            std::array<unsigned char, 144> main_thread{};
            out << " main_thread=" << reinterpret_cast<void*>(u64(0x2f8));
            if (read_memory_evidence(reinterpret_cast<void*>(u64(0x2f8)), main_thread.data(), main_thread.size())) {
                out << " raw_main_thread=";
                append_memory_hex(out, main_thread.data(), main_thread.size());
            } else out << " main_thread_read=unavailable";
        }
        config::memory_log(out.str());
    } catch (...) {
        config::memory_log("RENOVICE VM_MEMORY build=V96 event=bounded-capture-failed stock-state-unchanged=1");
    }
}

void maybe_sample_vm_memory(luau_State* state) noexcept
{
    // Reuse the natural outer owning-VM return; no worker, filesystem polling,
    // fabricated frame, userdata construction, stock replay or retained root.
    if (!config::memory_diagnostics_enabled() || !memory_evidence_layout_ready) return;
    if (state == nullptr || lua_execution_depth != 0
        || GetCurrentThreadId() != captured_owner_thread.load(std::memory_order_acquire)
        || state->global_state == nullptr
        || state->global_state != captured_global_state.load(std::memory_order_acquire)) return;
    static VmMemorySampleGate gate;
    const auto now = GetTickCount64();
    if (gate.admit(true, true, now)) capture_vm_memory_evidence(state, gate.sequence, now);
}

bool exact_current_lua_instruction(
	luau_State* state,
	std::uint32_t& raw_instruction
) noexcept
{
	raw_instruction = 0;
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->ci == nullptr
		|| diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		|| state->ci->func == nullptr
		|| diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue))
		|| state->ci->savedpc == nullptr)
	{
		return false;
	}
	luau_Closure* caller = nullptr;
	if (!readable_lua_closure(*state->ci->func, caller) || caller->isC
		|| caller->l.p == nullptr)
	{
		return false;
	}
	constexpr std::size_t prototype_prefix_size = 0xb0;
	const auto proto_address = reinterpret_cast<std::uintptr_t>(caller->l.p);
	if (proto_address < 0x10000 || proto_address % alignof(void*) != 0
		|| diagnostics::bad_read_ptr(caller->l.p, prototype_prefix_size))
	{
		return false;
	}
	std::array<unsigned char, prototype_prefix_size> bytes{};
	std::memcpy(bytes.data(), caller->l.p, bytes.size());
	std::uintptr_t code = 0;
	std::int32_t instruction_count = 0;
	std::memcpy(&code, bytes.data() + 0x10, sizeof(code));
	std::memcpy(&instruction_count, bytes.data() + 0x88,
		sizeof(instruction_count));
	if (bytes[0] != 12 || code < 0x10000 || code % sizeof(std::uint32_t) != 0
		|| instruction_count <= 0 || instruction_count > 1048576)
	{
		return false;
	}
	const auto byte_count = static_cast<std::size_t>(instruction_count)
		* sizeof(std::uint32_t);
	if (diagnostics::bad_read_ptr(reinterpret_cast<const void*>(code), byte_count))
		return false;
	std::uint32_t instruction = 0;
	if (!instruction_from_saved_pc(
			code, instruction_count,
			reinterpret_cast<std::uintptr_t>(state->ci->savedpc), instruction))
	{
		return false;
	}
	raw_instruction = reinterpret_cast<const std::uint32_t*>(code)[instruction];
	return true;
}

std::uint32_t de_luau_interrupt_increment_detour(luau_State* state)
{
	auto* const original = reinterpret_cast<DeLuauInterruptIncrement>(
		de_luau_interrupt_hook.original);
	if (original == nullptr) return 0;

	// DE callback 0x197EC80 reaches this unique leaf only for its negative-state
	// instruction path. Preserve the exact stock counter increment and return
	// value once, before RENOVICE performs any optional observation. Hooking the
	// leaf also avoids relocating the callback entry's relative JNS/CALL prologue.
	const auto stock_count = original(state);
	return preserve_stock_interrupt_result(stock_count, [&]
	{
		if (!lua_before_provider_fast_gate.load(std::memory_order_acquire))
			return;
		if (state == nullptr || state->stack == nullptr || state->stack_last == nullptr
			|| state->intop == nullptr || state->outtop == nullptr
			|| lua_call_hook_running)
		{
			return;
		}
		std::uint32_t raw_instruction = 0;
		if (!exact_current_lua_instruction(state, raw_instruction)) return;
		DeLuaCallInstruction decoded;
		if (!decode_de_lua_call_instruction(raw_instruction, decoded, game_version >= GV(44, 0, 0))) return;

		auto* const info = state->ci;
		if (info == nullptr || info->base == nullptr || info->top == nullptr)
		{
			return;
		}
		DeLuaCallWindow window;
		if (!resolve_de_lua_call_window(
				raw_instruction,
				reinterpret_cast<std::uintptr_t>(info->base),
				reinterpret_cast<std::uintptr_t>(info->top),
				reinterpret_cast<std::uintptr_t>(state->outtop),
				reinterpret_cast<std::uintptr_t>(state->stack),
				reinterpret_cast<std::uintptr_t>(state->stack_last),
				sizeof(luau_TValue), 256, window, game_version >= GV(44, 0, 0))
			|| diagnostics::bad_read_ptr(
				reinterpret_cast<const void*>(window.function_slot),
				sizeof(luau_TValue)))
		{
			return;
		}

		auto* const argument_base = reinterpret_cast<luau_TValue*>(
			window.argument_base);
		const auto argument_bytes = window.argument_count * sizeof(luau_TValue);
		if (argument_bytes != 0
			&& diagnostics::bad_read_ptr(argument_base, argument_bytes))
		{
			return;
		}
		const auto function = *reinterpret_cast<const luau_TValue*>(
			window.function_slot);
		auto execution = acquire_target_execution_snapshot();
		if (!execution) return;
		const auto call = target_lua_call_for_published_closure(
			*execution.snapshot, state, function);
		if (!call.callsite.exact
			|| !target_provider_claims_lua_before(
				*execution.snapshot, call.callsite.target_key, state->global_state,
				call.callsite.prototype))
		{
			return;
		}

		// Only an exact live module identity with an active luaCalls.before provider
		// may touch the VM tops. Unrelated UI/interpreter calls return above through
		// a read-only path and therefore cannot write intop/outtop.
		struct ScopedObserverStack
		{
			luau_State* state;
			std::ptrdiff_t intop_offset;
			std::ptrdiff_t outtop_offset;
			~ScopedObserverStack() noexcept
			{
				state->intop = luau_restorestack(state, intop_offset);
				state->outtop = luau_restorestack(state, outtop_offset);
			}
		} stack_scope{
			state,
			luau_savestack(state, state->intop),
			luau_savestack(state, state->outtop)};

		std::vector<luau_TValue> arguments;
		arguments.assign(argument_base, argument_base + window.argument_count);
		if (!dispatch_lua_call_phase(
				state, call, "before", arguments, argument_base))
		{
			trace_addon(state, call.callsite.target_key,
				"lua.call.before.reject",
				"exact interrupt counter leaf retained stock call=1");
		}
	});
}

// Generic target-root instance binding (2026-09-29). Observes the natural
// VM execute entry of a loader-recorded target root prototype so the exact
// environment that root runs in is learned without any module-specific branch.
TargetRootEntry inspect_target_root_entry(luau_State* state) noexcept
{
	TargetRootEntry entry;
	if (!target_root_watch_enabled.load(std::memory_order_acquire)
		|| state == nullptr || state->ci == nullptr || state->ci->func == nullptr
		|| state->global_state == nullptr
		|| diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		|| diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue)))
	{
		return entry;
	}
	luau_Closure* closure = nullptr;
	if (!readable_lua_closure(*state->ci->func, closure) || closure->isC
		|| closure->l.p == nullptr || closure->env == nullptr)
	{
		return entry;
	}
	auto execution = acquire_target_execution_snapshot();
	if (!execution) return entry;
	for (const auto& root : execution.snapshot->roots)
	{
		if (root.global_state == state->global_state
			&& root.root_proto == closure->l.p)
		{
			entry.target_key = root.target_key;
			entry.global_state = state->global_state;
			entry.root_proto = closure->l.p;
			entry.environment = closure->env;
			entry.valid = true;
			break;
		}
	}
	return entry;
}

void queue_target_root_return(const TargetRootEntry& entry) noexcept
{
	constexpr std::size_t maximum_pending_root_returns = 64;
	try
	{
		const auto thread = static_cast<std::uint32_t>(GetCurrentThreadId());
		std::lock_guard lock(target_root_return_mutex);
		auto existing = std::find_if(
			pending_target_root_returns.begin(), pending_target_root_returns.end(),
			[&](const auto& pending)
			{
				return pending.first.global_state == entry.global_state
					&& pending.first.root_proto == entry.root_proto;
			});
		if (existing != pending_target_root_returns.end())
		{
			*existing = {entry, thread};
		}
		else if (pending_target_root_returns.size() < maximum_pending_root_returns)
		{
			pending_target_root_returns.push_back({entry, thread});
		}
		target_root_return_pending.store(true, std::memory_order_release);
	}
	catch (...)
	{
	}
}

void apply_target_root_returns(luau_State* state)
{
	if (state == nullptr || state->global_state == nullptr) return;
	const auto thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	std::vector<TargetRootEntry> ready;
	{
		std::lock_guard lock(target_root_return_mutex);
		for (auto it = pending_target_root_returns.begin();
			it != pending_target_root_returns.end();)
		{
			if (it->first.global_state == state->global_state && it->second == thread)
			{
				ready.push_back(it->first);
				it = pending_target_root_returns.erase(it);
			}
			else ++it;
		}
		target_root_return_pending.store(
			!pending_target_root_returns.empty(), std::memory_order_release);
	}
	for (const auto& entry : ready)
	{
		TargetModuleIdentity created;
		void* load_environment = nullptr;
		TargetRootReturnAction action = TargetRootReturnAction::not_a_target_root;
		{
			std::lock_guard generation_lock(generation_mutex);
			for (const auto& identity : target_module_identities)
			{
				if (identity.target_key == entry.target_key
					&& identity.global_state == entry.global_state
					&& identity.root_proto == entry.root_proto
					&& !identity.runtime_root)
				{
					load_environment = identity.environment;
				}
			}
			action = record_target_root_return(
				target_module_identities, entry.target_key, entry.global_state,
				entry.root_proto, entry.environment, &created);
			if (action == TargetRootReturnAction::rebind)
			{
				PendingTargetAddonRefresh job{
					created.target_key,
					created.global_state,
					created.manager,
					{created.name_handle[0], created.name_handle[1]},
					created.owner_thread,
				};
				auto existing = std::find_if(
					pending_target_addon_refreshes.begin(),
					pending_target_addon_refreshes.end(),
					[&](const PendingTargetAddonRefresh& candidate)
					{
						return same_target_addon_context(
							job.target_key, job.global_state, job.owner_thread,
							candidate.target_key, candidate.global_state,
							candidate.owner_thread);
					});
				if (existing == pending_target_addon_refreshes.end())
					pending_target_addon_refreshes.push_back(job);
				else *existing = job;
				publish_target_execution_snapshot_locked();
				target_addon_refresh_pending.store(true, std::memory_order_release);
			}
		}
		if (action != TargetRootReturnAction::rebind) continue;
		std::ostringstream observed;
		observed << "RENOVICE TARGET ROOT RETURN key=" << std::hex << entry.target_key
			<< std::dec << " vm=" << entry.global_state
			<< " proto=" << entry.root_proto
			<< " load_env=" << load_environment
			<< " runtime_env=" << entry.environment
			<< " action=rebind-queued";
		conout << observed.str() << std::endl;
		config::log(observed.str());
	}
}

void vm_execute_detour(luau_State* state)
{
	const auto pause_root = inspect_pause_vm_root_execution(state);
	const auto target_root = inspect_target_root_entry(state);
	const bool target_observation_enabled = observe_target_addons.load(
		std::memory_order_acquire);
	std::uint64_t target_execution_key = 0;
	{
		// Snapshot ownership ends before stock VM execution. DE reports ordinary
		// script errors with a native longjmp, which does not unwind C++ objects.
		// No generation lease, mutex, TLS marker, vector, or scoped cleanup may
		// therefore cross the stock interpreter call below.
		auto generation_dispatch = target_observation_enabled
			? generation_dispatch_gate.try_dispatch()
			: GenerationDispatchGate::Lease{};
		if (generation_dispatch
			&& state != nullptr && state->ci != nullptr
			&& state->ci->func != nullptr && state->global_state != nullptr
			&& !diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
			&& !diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue)))
		{
			target_execution_key = target_key_for_published_closure(
				state, *state->ci->func);
		}
	}
	if (pause_root.valid)
	{
		std::ostringstream observed;
		observed << "RENOVICE Scripts UI exact root ENTER key="
			<< std::hex << pause_root.key << std::dec
			<< " vm=" << pause_root.global_state
			<< " proto=" << pause_root.root_proto
			<< " runtime_env=" << pause_root.environment;
		config::log(observed.str());
	}
	if (target_execution_key != 0)
	{
		log_native_hook_once(
			state, target_execution_key, "target-execution.enter");
	}

	// This call is intentionally naked. A stock Lua error may longjmp out of it;
	// all RENOVICE-owned objects and stateful markers have already been released.
	reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);

	// Reached only on a normal root return: a DE error longjmps past this line.
	if (target_root.valid) queue_target_root_return(target_root);

	if (pause_root.valid)
	{
		const bool attached = decorate_pause_menu_environment(
			pause_root.key, state, pause_root.environment,
			"vm-exact-root-return");
		std::ostringstream result;
		result << "RENOVICE Scripts UI exact root RESULT "
			<< (attached ? "PASS" : "FAIL")
			<< " key=" << std::hex << pause_root.key << std::dec
			<< " vm=" << pause_root.global_state
			<< " proto=" << pause_root.root_proto
			<< " runtime_env=" << pause_root.environment;
		conout << result.str() << std::endl;
		config::log(result.str());
		if (attached)
		{
			std::lock_guard lock(generation_mutex);
			for (auto& identity : pause_menu_identities)
			{
				if (identity.target_key == pause_root.key
					&& identity.global_state == pause_root.global_state
					&& identity.root_proto == pause_root.root_proto)
				{
					identity.pause_attached = true;
				}
			}
		}
	}

	// The native VM routine is re-entrant. Without a manual depth marker (which
	// a Lua longjmp could poison), exact base-frame identity is the authoritative
	// proof that this is an outer, idle return where mutation is admissible.
	const bool exact_idle_return = state != nullptr
		&& !diagnostics::bad_read_ptr(state, sizeof(luau_State))
		&& state->ci != nullptr && state->base_ci != nullptr
		&& state->ci == state->base_ci
		&& inspect_lua_mutation_boundary(state)
			== LuaMutationBoundaryBlocker::Ready;
	if (!exact_idle_return) return;
	clear_run_script_boundary_at_exact_idle(state);
	clear_stock_native_finalize_at_exact_idle(state);
	clear_native_call_boundary_at_exact_idle(state);
	clear_callback_runtime_result_root_at_exact_idle(state);

	if (target_root_return_pending.load(std::memory_order_acquire)
		&& lua_execution_depth == 0)
	{
		// Root returns only record data under their own mutex; identity update
		// and the queued rebind happen here, outside every native Lua caller.
		apply_target_root_returns(state);
	}
	if (target_addon_refresh_pending.load(std::memory_order_acquire)
		&& lua_execution_depth == 0)
	{
		// A natural target load can discover that existing VM-local roots need a
		// destructive rebind. Do that only after this callback has released its
		// generation; first-time additive binding still occurs synchronously in
		// the loader so the first ability-card query can see it.
		drain_pending_target_addons_for_vm(state);
	}
	maybe_sample_vm_memory(state);
	maybe_poll_runtime_controls();
	maybe_run_safe_runtime_tick(state);
}

void maybe_poll_runtime_controls() noexcept
{
	const auto callback = safe_runtime_control_poll.load(std::memory_order_acquire);
	if (callback == nullptr)
	{
		return;
	}
	const auto expected_owner_thread = captured_owner_thread.load(
		std::memory_order_acquire);
	const auto boundary_owner_thread = static_cast<std::uint32_t>(
		GetCurrentThreadId());
	if (!safe_runtime_control_poll_ready(
		expected_owner_thread,
		boundary_owner_thread,
		0,
		lua_execution_depth,
		safe_runtime_control_poll_running))
	{
		return;
	}
	const auto now_ms = static_cast<std::uint64_t>(GetTickCount64());
	if (!safe_runtime_tick_due(
		now_ms, previous_safe_runtime_control_poll_ms,
		safe_runtime_tick_interval_ms))
	{
		return;
	}
	previous_safe_runtime_control_poll_ms = now_ms;
	safe_runtime_control_poll_running = true;
	try
	{
		callback();
	}
	catch (...)
	{
		config::log(
			"RENOVICE safe runtime control poll caught an unexpected exception");
	}
	safe_runtime_control_poll_running = false;
}

void maybe_run_safe_runtime_tick(luau_State* state) noexcept
{
	const auto callback = safe_runtime_tick.load(std::memory_order_acquire);
	if (callback == nullptr || state == nullptr
		|| diagnostics::bad_read_ptr(state, sizeof(luau_State)))
	{
		return;
	}
	// V35 gated only the work inside drain(). The enclosing callback continued
	// to tick bgscript and ordinary Pluto scripts on every accepted DE VM return.
	// A live debugger capture caught that exact path during the UI freeze. Keep
	// the entire callback dormant unless startup or an explicit reload is queued.
	if (!runtime_work_pending())
	{
		return;
	}
	const auto expected_global_state = captured_global_state.load(
		std::memory_order_acquire);
	const auto expected_owner_thread = captured_owner_thread.load(
		std::memory_order_acquire);
	const auto boundary_owner_thread = static_cast<std::uint32_t>(
		GetCurrentThreadId());
	const auto blocker = safe_runtime_tick_boundary_blocker(
		expected_global_state,
		expected_owner_thread,
		state->global_state,
		boundary_owner_thread,
		0,
		lua_execution_depth,
		true,
		safe_runtime_tick_running);
	if (blocker != SafeRuntimeTickBoundaryBlocker::Ready)
	{
		if (reload_pending())
		{
			const auto sequence = reload_request_sequence.load(
				std::memory_order_acquire);
			if (sequence != last_deferred_reload_sequence_logged
				|| blocker != last_deferred_reload_blocker)
			{
				const char* reason = "unknown";
				switch (blocker)
				{
				case SafeRuntimeTickBoundaryBlocker::MissingCapturedVm:
					reason = "missing-captured-vm"; break;
				case SafeRuntimeTickBoundaryBlocker::WrongVm:
					reason = "wrong-vm"; break;
				case SafeRuntimeTickBoundaryBlocker::MissingOwnerThread:
					reason = "missing-owner-thread"; break;
				case SafeRuntimeTickBoundaryBlocker::WrongOwnerThread:
					reason = "wrong-owner-thread"; break;
				case SafeRuntimeTickBoundaryBlocker::VmExecutionActive:
					reason = "vm-execution-active"; break;
				case SafeRuntimeTickBoundaryBlocker::RenoviceExecutionActive:
					reason = "renovice-execution-active"; break;
				case SafeRuntimeTickBoundaryBlocker::NotOuterInterpreterReturn:
					reason = "not-outer-interpreter-return"; break;
				case SafeRuntimeTickBoundaryBlocker::CallbackActive:
					reason = "runtime-callback-active"; break;
				case SafeRuntimeTickBoundaryBlocker::Ready:
					reason = "ready"; break;
				}
				std::ostringstream deferred;
				deferred << "RENOVICE reload DEFERRED boundary=outer-vm-return"
					<< " sequence=" << sequence
					<< " reason=" << reason
					<< " expected_thread=" << expected_owner_thread
					<< " boundary_thread=" << boundary_owner_thread
					<< " expected_vm=" << expected_global_state
					<< " boundary_vm=" << state->global_state
					<< " vm_depth=0"
					<< " renovice_depth=" << lua_execution_depth
					<< " callback_running=" << (safe_runtime_tick_running ? 1 : 0)
					<< " ci=" << state->ci << " base_ci=" << state->base_ci;
				config::log(deferred.str());
				last_deferred_reload_sequence_logged = sequence;
				last_deferred_reload_blocker = blocker;
			}
		}
		return;
	}
	const auto lua_blocker = inspect_lua_mutation_boundary(state);
	if (lua_blocker != LuaMutationBoundaryBlocker::Ready)
	{
		if (reload_pending())
		{
			const auto sequence = reload_request_sequence.load(
				std::memory_order_acquire);
			if (sequence != last_deferred_lua_boundary_sequence_logged
				|| lua_blocker != last_deferred_lua_boundary_blocker)
			{
				std::ostringstream deferred;
				deferred << "RENOVICE reload DEFERRED boundary=lua-mutation-host"
					<< " sequence=" << sequence
					<< " reason=" << lua_mutation_boundary_label(lua_blocker)
					<< " state=" << state
					<< " status=" << static_cast<unsigned int>(state->status)
					<< " intop=" << state->intop
					<< " outtop=" << state->outtop
					<< " ci=" << state->ci
					<< " base_ci=" << state->base_ci;
				config::log(deferred.str());
				last_deferred_lua_boundary_sequence_logged = sequence;
				last_deferred_lua_boundary_blocker = lua_blocker;
			}
		}
		return;
	}
	ScopedSafeRuntimeTick runtime_tick_scope;
	if (!first_safe_runtime_tick_logged.exchange(true, std::memory_order_acq_rel))
	{
		std::ostringstream first_tick;
		first_tick << "RENOVICE pending transaction FIRST PASS mode=outer-vm-return"
			<< " thread=" << boundary_owner_thread
			<< " vm=" << state->global_state
			<< " ci=" << state->ci
			<< " base_ci=" << state->base_ci;
		conout << first_tick.str() << std::endl;
		config::log(first_tick.str());
	}
	try
	{
		callback(state);
	}
	catch (...)
	{
		conout << "RENOVICE pending transaction caught an unexpected exception"
			<< std::endl;
		config::log(
			"RENOVICE pending transaction caught an unexpected exception");
	}
}

bool run_chunk(const Chunk& chunk, luau_State* boundary_state,
	const std::string* lifecycle_key, void* execution_environment,
	bool pass_global_argument, void* execution_manager,
	const std::uint32_t* execution_name_handle, bool use_borrowed_closure_environment,
	const char* multi_target_key = nullptr);

bool ensure_callback_runtime(luau_State* state, void* manager,
	const std::uint32_t* name_handle)
{
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	getfield(state, -10000, callback_runtime_registry_key.c_str());
	const bool ready = is_table(state->outtop[-1].type);
	state->outtop = luau_restorestack(state, base_offset);
	if (ready) return true;
	Chunk runtime;
	runtime.name = "embedded-callback-runtime-v45";
	if (game_version >= GV(44, 0, 0))
        runtime.bytes.assign(std::begin(callback_runtime_bytecode_u44), std::end(callback_runtime_bytecode_u44));
    else runtime.bytes.assign(std::begin(callback_runtime_bytecode), std::end(callback_runtime_bytecode));
	const bool passed = run_chunk(runtime, state, &callback_runtime_registry_key,
		nullptr, true, manager, name_handle, true);
	trace_addon(state, 0, passed ? "damage.runtime.ready" : "damage.runtime.error",
		"storage=embedded-dll bytes=" + std::to_string(runtime.bytes.size()));
	return passed;
}

std::vector<const luau_GlobalState*> automatic_damage_failed_vms;

bool ensure_automatic_damage_runtime(
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle)
{
	if (!universal_observer_requested(config::flags())) return true;
	if (state == nullptr || state->outtop == nullptr
		|| !ensure_diagnostic_trace_registry_root(state))
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	getfield(state, -10000, automatic_damage_runtime_registry_key.c_str());
	const bool ready = is_table(state->outtop[-1].type);
	state->outtop = luau_restorestack(state, base_offset);
	if (ready) return true;
	if (std::find(automatic_damage_failed_vms.begin(), automatic_damage_failed_vms.end(),
		state->global_state) != automatic_damage_failed_vms.end()) return false;

	Chunk runtime;
	runtime.name = "embedded-automatic-damage-runtime-v86";
	if (game_version >= GV(44, 0, 0))
        runtime.bytes.assign(std::begin(automatic_damage_runtime_bytecode_u44), std::end(automatic_damage_runtime_bytecode_u44));
    else runtime.bytes.assign(std::begin(automatic_damage_runtime_bytecode), std::end(automatic_damage_runtime_bytecode));
	const bool passed = run_chunk(
		runtime, state, &automatic_damage_runtime_registry_key,
		nullptr, true, manager, name_handle, true);
	if (!passed) automatic_damage_failed_vms.push_back(state->global_state);
	std::ostringstream result;
	result << "RENOVICE automatic damage runtime "
		<< (passed ? "PASS" : "FAIL")
		<< " build=V87 storage=embedded-dll bytes="
		<< runtime.bytes.size()
		<< " coverage=scripted-DamageDD-and-native-HUD-buffs";
	conout << result.str() << std::endl;
	config::log(result.str());
	return passed;
}

bool reset_automatic_damage_runtime(luau_State* state)
{
	luau_TValue callback{};
	if (!automatic_damage_runtime_method(state, "reset", callback)) return false;
	return call_value(state, callback, nullptr, 0, "automaticDamage.reset");
}

bool clear_automatic_damage_runtime(luau_State* state)
{
	if (state == nullptr || state->outtop == nullptr || setfield == nullptr
		|| getfield == nullptr || check_stack == nullptr)
	{
		return false;
	}
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 1);
	auto* base = luau_restorestack(state, base_offset);
	base->value.as_uintptr = 0;
	base->type = LUAU_NIL;
	state->outtop = base + 1;
	setfield(state, -10000, automatic_damage_runtime_registry_key.c_str());
	state->outtop = base;
	getfield(state, -10000, automatic_damage_runtime_registry_key.c_str());
	base = luau_restorestack(state, base_offset);
	const bool cleared = base->type == LUAU_NIL;
	state->outtop = base;
	return cleared;
}

bool activate_target_addons(
	std::uint64_t target_key,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle,
	bool* deferred = nullptr
);

enum class LoaderDetourDisposition : std::uint8_t
{
	Return,
	RethrowStockError,
};

struct LoaderDetourOutcome
{
	LoaderDetourDisposition disposition = LoaderDetourDisposition::Return;
	luau_State* state = nullptr;
	int status = 0;
	bool value = false;
};
static_assert(std::is_trivially_copyable_v<LoaderDetourOutcome>);

LoaderDetourOutcome loader_detour_owned(
	luau_State* loader_state,
	void* manager,
	void* descriptor)
{
	// The pause-menu fingerprint is always observed at the natural module-load
	// boundary. It does no file polling and only decorates a positive semantic
	// match. Addon targets continue to use their exact body-key association.
	const auto target_boundary = inspect_target_load(descriptor);
	dump_pause_menu_body_once(target_boundary, descriptor);
	ScopedPauseLoadBoundary pause_load_scope(
		target_boundary.pause_menu,
		target_boundary.key,
		target_boundary.name_handle);
	if (target_boundary.pause_menu)
	{
		std::ostringstream entered;
		entered << "RENOVICE Scripts UI load ENTER key=" << std::hex
			<< target_boundary.key << std::dec
			<< " thread=" << GetCurrentThreadId();
		conout << entered.str() << std::endl;
		config::log(entered.str());
	}
	replacements::begin_module_load(
		manager, descriptor, target_boundary.valid ? target_boundary.key : 0);
	if (!context_ready.load(std::memory_order_acquire) && descriptor != nullptr
		&& !diagnostics::bad_read_ptr(descriptor, 0x60))
	{
		std::lock_guard lock(capture_mutex);
		if (!context_ready.load(std::memory_order_relaxed))
		{
			void* name_object = *reinterpret_cast<void**>(
				reinterpret_cast<unsigned char*>(descriptor) + 0x08);
				void* environment = *reinterpret_cast<void**>(
					reinterpret_cast<unsigned char*>(descriptor) + 0x58);
				if (environment != nullptr && diagnostics::bad_read_ptr(environment, 0x10))
				{
					environment = nullptr;
				}
			if (name_object != nullptr && !diagnostics::bad_read_ptr(name_object, 0x30))
			{
				void** first_pointer = reinterpret_cast<void**>(
					reinterpret_cast<unsigned char*>(name_object) + 0x10);
				auto* second = reinterpret_cast<std::uint32_t*>(
					reinterpret_cast<unsigned char*>(name_object) + 0x2c);
				if (!diagnostics::bad_read_ptr(first_pointer, sizeof(*first_pointer))
					&& *first_pointer != nullptr
					&& !diagnostics::bad_read_ptr(*first_pointer, sizeof(std::uint32_t))
					&& !diagnostics::bad_read_ptr(second, sizeof(*second)))
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
	const auto loader_result = invoke_stock_loader_protected(
		loader_state, manager, descriptor,
		StockLoaderErrorPolicy::PreserveForStockRethrow);
	replacements::complete_module_load(manager, descriptor);
	if (loader_result.admitted && loader_result.status != 0)
	{
		// Keep DE's error TValue and activation exactly as Loader left them. The
		// outer wrapper rethrows only after this function's pause/load ownership
		// and every other C++ local have been destroyed.
		return {
			LoaderDetourDisposition::RethrowStockError,
			loader_state,
			loader_result.status,
			false,
		};
	}
	const bool result = loader_result.admitted && loader_result.restored
		&& loader_result.status == 0 && loader_result.returned
		&& loader_result.value;
	if (context_ready.load(std::memory_order_acquire)
		&& captured_global_state.load(std::memory_order_acquire) == nullptr
		&& manager == captured_manager && manager != nullptr
		&& !diagnostics::bad_read_ptr(manager, 0x28))
	{
		auto* manager_state = *reinterpret_cast<luau_State**>(
			reinterpret_cast<unsigned char*>(manager) + 0x20);
		if (manager_state != nullptr
			&& !diagnostics::bad_read_ptr(manager_state, sizeof(luau_State))
			&& manager_state->global_state != nullptr)
		{
			captured_global_state.store(
				manager_state->global_state, std::memory_order_release);
			captured_owner_thread.store(
				static_cast<std::uint32_t>(GetCurrentThreadId()),
				std::memory_order_release);
			std::ostringstream captured;
			captured << "RENOVICE safe runtime tick VM captured after loader return"
				<< " thread=" << GetCurrentThreadId()
				<< " vm=" << manager_state->global_state;
			conout << captured.str() << std::endl;
			config::log(captured.str());
		}
	}
	if (vm_loader_may_drain_pending(lua_execution_depth)
		&& manager != nullptr && !diagnostics::bad_read_ptr(manager, 0x28))
	{
		auto* state = *reinterpret_cast<luau_State**>(
			reinterpret_cast<unsigned char*>(manager) + 0x20);
		if (!universal_observer_requested(config::flags())
			&& diagnostic_root_cleanup_pending.load(std::memory_order_acquire)
			&& !clear_diagnostic_module_roots_for_vm(state))
		{
			config::log(
				"RENOVICE diagnostics lifecycle DEFER reason=foreign-vm-prototype-root-release");
		}
		if (result && target_boundary.pause_menu)
		{
			remember_pause_menu_identity(
				target_boundary.key, state, manager, target_boundary.name_handle);
		}
		if (result && target_boundary.addon_target)
		{
			remember_target_script_binding(target_boundary.key, state);
			remember_target_module_identity(
				target_boundary.key, state, manager, target_boundary.name_handle);
		}
		if (result && target_boundary.diagnostic_damage_source)
		{
			remember_diagnostic_module_identity(
				target_boundary.key, state, target_boundary.name_handle);
			if (!ensure_automatic_damage_runtime(
					state, manager, target_boundary.name_handle)
				&& !automatic_damage_runtime_failure_logged.exchange(
					true, std::memory_order_relaxed))
			{
				config::diagnostic_log(
					"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=module-load",
					config::DiagnosticsMode::errors);
			}
		}
		replacements::drain_pending_for_vm(state);
		bool target_generation_ready = false;
		bool target_generation_deferred = false;
		if (target_addon_may_activate(result, target_boundary.addon_target, lua_execution_depth))
		{
			target_generation_ready = activate_target_addons(
				target_boundary.key, state, manager, target_boundary.name_handle,
				&target_generation_deferred);
		}
		if (target_generation_deferred) queue_target_addon_refreshes();
		if (result && target_boundary.addon_target && target_generation_ready
			&& retracted_cached_card_export_decorator_enabled.load(
				std::memory_order_acquire))
		{
			decorate_target_card_export(
				target_boundary.key, state, target_boundary.name_handle);
		}
	}
	if (target_boundary.pause_menu)
	{
		std::ostringstream exited;
		exited << "RENOVICE Scripts UI load EXIT key=" << std::hex
			<< target_boundary.key << std::dec
			<< " result=" << (result ? "PASS" : "FAIL")
			<< " Initialize_assignments="
			<< active_pause_load_boundary.initialize_assignments;
		conout << exited.str() << std::endl;
		config::log(exited.str());
	}
	return {LoaderDetourDisposition::Return, nullptr, 0, result};
}

bool loader_detour(void* manager, void* descriptor)
{
	// Before DE_VM_AUTHORITY is installed (the hook is created earlier during
	// startup), forward through the exact stock path with no C++ owner alive.
	// Once authority is ready every Loader call is caught by the shared raw
	// boundary below.
	auto* const original = reinterpret_cast<Loader>(loader_hook.original);
	if (original == nullptr) return false;
	if (!de_vm_authority::ready() || manager == nullptr
		|| diagnostics::bad_read_ptr(manager, 0x28))
	{
		return original(manager, descriptor);
	}
	auto* const state = *reinterpret_cast<luau_State**>(
		reinterpret_cast<unsigned char*>(manager) + 0x20);
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State)))
	{
		return original(manager, descriptor);
	}

	const auto outcome = loader_detour_owned(state, manager, descriptor);
	if (outcome.disposition == LoaderDetourDisposition::RethrowStockError)
	{
		de_vm_authority::rethrow_current_vm_error(outcome.state, outcome.status);
	}
	return outcome.value;
}

bool run_chunk(
	const Chunk& chunk,
	luau_State* boundary_state,
	const std::string* lifecycle_key = nullptr,
	void* execution_environment = nullptr,
	bool pass_global_argument = true,
	void* execution_manager = nullptr,
	const std::uint32_t* execution_name_handle = nullptr,
	bool use_borrowed_closure_environment = false,
	const char* multi_target_key // default: forward declaration above
)
{
	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	void* manager = execution_manager != nullptr ? execution_manager : captured_manager;
	std::uint32_t name_handle[2]{};
	if (execution_name_handle != nullptr
		&& !diagnostics::bad_read_ptr(execution_name_handle, sizeof(name_handle)))
	{
		name_handle[0] = execution_name_handle[0];
		name_handle[1] = execution_name_handle[1];
	}
	else
	{
		name_handle[0] = captured_name_handle[0];
		name_handle[1] = captured_name_handle[1];
	}
	if (manager == nullptr || diagnostics::bad_read_ptr(manager, 0x28))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": manager unavailable" << std::endl;
		return false;
	}
	auto* manager_state = *reinterpret_cast<luau_State**>(
		reinterpret_cast<unsigned char*>(manager) + 0x20);
	if (manager_state == nullptr || diagnostics::bad_read_ptr(manager_state, sizeof(luau_State)))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": manager state unavailable" << std::endl;
		return false;
	}
	const bool boundary_readable = boundary_state != nullptr
		&& !diagnostics::bad_read_ptr(boundary_state, sizeof(luau_State));
	const bool shared_global = boundary_readable
		&& manager_state->global_state != nullptr
		&& manager_state->global_state == boundary_state->global_state;
	if (!valid_execution_boundary(true, boundary_readable, shared_global))
	{
		conout << "RENOVICE Inject skipped " << chunk.name
			<< ": current DE execution boundary is not in the captured manager VM" << std::endl;
		return false;
	}
	const auto lua_blocker = inspect_lua_mutation_boundary(boundary_state);
	if (lua_blocker != LuaMutationBoundaryBlocker::Ready)
	{
		conout << "RENOVICE Inject skipped " << chunk.name
			<< ": Lua mutation boundary "
			<< lua_mutation_boundary_label(lua_blocker) << std::endl;
		return false;
	}

	void* game_buffer = game_allocate(chunk.bytes.size(), 0);
	if (game_buffer == nullptr || IsBadWritePtr(game_buffer, chunk.bytes.size()))
	{
		conout << "RENOVICE Inject skipped " << chunk.name << ": game allocation failed" << std::endl;
		return false;
	}
	std::memcpy(game_buffer, chunk.bytes.data(), chunk.bytes.size());

	alignas(16) unsigned char fabricated_name_object[0x40]{};
	alignas(16) unsigned char fabricated_descriptor[0x60]{};
	std::uint32_t fabricated_name_part = name_handle[0];
	*reinterpret_cast<void**>(fabricated_name_object + 0x10) = &fabricated_name_part;
	*reinterpret_cast<std::uint32_t*>(fabricated_name_object + 0x2c) = name_handle[1];

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
		name_handle,
		lifecycle_key == nullptr ? nullptr : lifecycle_key->c_str(),
		pass_global_argument,
		use_borrowed_closure_environment,
		multi_target_key,
		use_borrowed_closure_environment ? execution_environment : nullptr);
	if (result.completed && result.registry_restored)
	{
		std::ostringstream success;
		success << "RENOVICE Inject PASS " << chunk.name;
		if (multi_target_key != nullptr) success << " target=" << multi_target_key;
		success
			<< " closure_tag=" << result.closure_tag
			<< " pcall=" << result.protected_call_result
			<< " result_tag=" << result.result_tag
			<< " exact_env=" << result.exact_environment_used
			<< " env=" << result.borrowed_environment;
		conout << success.str() << std::endl;
		config::log(success.str());
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
		failure << "RENOVICE Inject FAIL " << chunk.name;
		if (multi_target_key != nullptr)
		{
			failure << " target=" << multi_target_key << " multi_target_reason="
				<< multi_target_select_failure_label(result.multi_target_failure);
		}
		failure
			<< " fault_stage=" << result.fault_stage
			<< " fault_code=" << result.fault_code
			<< " closure_tag=" << result.closure_tag
			<< " pcall=" << result.protected_call_result
			<< " result_tag=" << result.result_tag
			<< " registry_restored=" << result.registry_restored;
		if (result.error_tag >= 0)
		{
			failure << " error_tag=" << result.error_tag
				<< " error=\"" << result.error_text << '"';
		}
		config::log(failure.str());
	}
	if (failed_chunk_has_lifecycle_root_to_release(
		lifecycle_key != nullptr, result.lifecycle_stored))
	{
		AddonRecord failed;
		failed.name = chunk.name;
		failed.registry_key = *lifecycle_key;
		failed.generation = active_generation;
		failed.global_state = boundary_state == nullptr
			? nullptr : boundary_state->global_state;
		failed.owner_thread = GetCurrentThreadId();
		if (!lifecycle_operation(boundary_state, failed, nullptr))
		{
			conout << "RENOVICE ADDON FATAL: failed lifecycle root could not be released" << std::endl;
			subsystem_enabled.store(false, std::memory_order_release);
		}
	}
	else if (lifecycle_key != nullptr)
	{
		config::log("RENOVICE addon lifecycle release SKIP addon=" + chunk.name
			+ " reason=no-stored-root");
	}
	return false;
}

bool activate_target_addons_locked(
	std::uint64_t target_key,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle,
	bool current_thread_borrows_generation,
	bool* deferred
)
{
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr || manager == nullptr
		|| name_handle == nullptr)
	{
		return false;
	}
	if (inspect_lua_mutation_boundary(state)
		!= LuaMutationBoundaryBlocker::Ready)
	{
		return false;
	}
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	void* const global_state = state->global_state;

	std::vector<const Chunk*> desired;
	for (const auto& chunk : active_chunks)
	{
		if (chunk.kind == ScriptKind::TargetManagedAddon
			&& chunk.target_key == target_key)
		{
			desired.push_back(&chunk);
		}
	}

	std::vector<TargetAddonRecord> current;
	for (const auto& addon : active_target_addons)
	{
		if (same_target_addon_context(
			target_key, global_state, owner_thread,
			addon.target_key, addon.global_state, addon.owner_thread))
		{
			current.push_back(addon);
		}
	}
	std::sort(current.begin(), current.end(), [](const auto& lhs, const auto& rhs)
	{
		return lhs.addon.name < rhs.addon.name;
	});

	// Resolve the target module's exact shared table before executing addon
	// bytecode. The optional trace bridge is installed only in explicit
	// Diagnostics mode; normal gameplay keeps the same addon identity without
	// a per-callback native logging bridge.
	std::uintptr_t current_shared_table_identity = 0;
	// Latest identity of this module in this VM: the runtime root instance when
	// its root returned in a new environment, otherwise the loader identity.
	void* target_environment = nullptr;
	if (!desired.empty())
	{
		if (!ensure_callback_runtime(state, manager, name_handle)) return false;
		for (auto identity = target_module_identities.rbegin();
			identity != target_module_identities.rend(); ++identity)
		{
			if (identity->target_key == target_key
				&& identity->global_state == global_state)
			{
				target_environment = identity->environment;
				break;
			}
		}
		if (!prepare_target_shared_table(
			target_key, state, target_environment,
			current_shared_table_identity))
		{
			conout << "RENOVICE TARGET ADDON ROLLBACK shared table unavailable: key="
				<< std::hex << target_key << std::dec << std::endl;
			return false;
		}
		if (!install_target_hook_registry_dispatcher(
			state, target_environment, target_key))
		{
			std::ostringstream failure;
			failure << "RENOVICE TARGET ADDON ROLLBACK registry dispatcher unavailable: key="
				<< std::hex << target_key << std::dec;
			conout << failure.str() << std::endl;
			config::log(failure.str());
			return false;
		}

		bool exact_name_and_content_match = current.size() == desired.size();
		bool exact_shared_table_match = exact_name_and_content_match;
		for (std::size_t i = 0;
			exact_name_and_content_match && i != desired.size(); ++i)
		{
			const auto content_key = replacements::body_key(std::string_view(
				reinterpret_cast<const char*>(desired[i]->bytes.data()),
				desired[i]->bytes.size()));
			exact_name_and_content_match = current[i].addon.name == desired[i]->name
				&& current[i].content_key == content_key
				&& current[i].bound_environment == target_environment;
			exact_shared_table_match = exact_shared_table_match
				&& same_target_addon_generation(
					current[i].content_key, current[i].shared_table_identity,
					content_key, current_shared_table_identity);
		}
		const auto generation_action = classify_target_addon_generation_action(
			exact_name_and_content_match, exact_shared_table_match);
		if (target_addon_action_requires_exclusive_mutation(
			current_thread_borrows_generation, !current.empty(), generation_action))
		{
			if (deferred != nullptr) *deferred = true;
			std::ostringstream message;
			message << "RENOVICE TARGET ADDON DEFER key=" << std::hex << target_key
				<< std::dec << " reason=destructive-generation-replacement";
			config::log(message.str());
			return false;
		}
		if (generation_action == TargetAddonGenerationAction::reuse)
		{
			return true;
		}
		if (generation_action == TargetAddonGenerationAction::reactivate_roots)
		{
			const auto transaction = reactivate_addon_generation(
				current,
				[&](const TargetAddonRecord& addon)
				{
					return lifecycle_operation(state, addon.addon, "cleanup");
				},
				[&](const TargetAddonRecord& addon)
				{
					return lifecycle_operation(state, addon.addon, "activate");
				});
			if (transaction != TransactionResult::Committed)
			{
				const bool fatal = transaction == TransactionResult::RollbackFailed;
				const char* cause = transaction == TransactionResult::CleanupRejected
					? "cleanup-rejected"
					: transaction == TransactionResult::ActivationRejected
						? "activation-rejected"
						: "rollback-failed";
				std::ostringstream failure;
				failure << "RENOVICE TARGET ADDON "
					<< (fatal ? "FATAL" : "ROLLBACK")
					<< " key=" << std::hex << target_key << std::dec
					<< " reason=existing-root-reactivation-"
					<< cause;
				conout << failure.str() << std::endl;
				config::log(failure.str());
				if (fatal) subsystem_enabled.store(false, std::memory_order_release);
				return false;
			}
			for (auto& addon : current)
			{
				addon.shared_table_identity = current_shared_table_identity;
			}
			active_target_addons.erase(std::remove_if(
				active_target_addons.begin(), active_target_addons.end(),
				[&](const TargetAddonRecord& addon)
				{
					return same_target_addon_context(
						target_key, global_state, owner_thread,
						addon.target_key, addon.global_state, addon.owner_thread);
				}), active_target_addons.end());
			active_target_addons.insert(
				active_target_addons.end(), current.begin(), current.end());
			publish_target_execution_snapshot_locked();
			std::ostringstream success;
			success << "RENOVICE TARGET ADDON REBIND PASS key=" << std::hex
				<< target_key << std::dec << " addons=" << current.size()
				<< " mode=existing-registry-roots shared_table="
				<< reinterpret_cast<void*>(current_shared_table_identity);
			conout << success.str() << std::endl;
			config::log(success.str());
			return true;
		}
	}
	else if (current.empty())
	{
		return true;
	}
	else if (target_addon_action_requires_exclusive_mutation(
		current_thread_borrows_generation, true,
		TargetAddonGenerationAction::replace_roots))
	{
		if (deferred != nullptr) *deferred = true;
		std::ostringstream message;
		message << "RENOVICE TARGET ADDON DEFER key=" << std::hex << target_key
			<< std::dec << " reason=destructive-generation-removal";
		config::log(message.str());
		return false;
	}

	std::vector<TargetAddonRecord> staged;
	char multi_target_key_text[17]{};
	format_target_key_text(target_key, multi_target_key_text);
	for (const auto* chunk : desired)
	{
		TargetAddonRecord candidate;
		candidate.addon.name = chunk->name;
		candidate.addon.registry_key = "__RENOVICE_TARGET_ADDON_"
			+ std::to_string(next_target_addon_identity++);
		candidate.addon.generation = active_generation;
		candidate.addon.global_state = global_state;
		candidate.addon.owner_thread = owner_thread;
		candidate.target_key = target_key;
		candidate.content_key = replacements::body_key(std::string_view(
			reinterpret_cast<const char*>(chunk->bytes.data()), chunk->bytes.size()));
		// The successful bridge install above proved the exact `_T` identity
		// against which this chunk is about to execute.
		candidate.shared_table_identity = current_shared_table_identity;
		candidate.bound_environment = target_environment;
		candidate.global_state = global_state;
		candidate.owner_thread = owner_thread;
		if (!run_chunk(
			*chunk, state, &candidate.addon.registry_key,
			target_environment, true, manager, name_handle, true,
			chunk->multi_target ? multi_target_key_text : nullptr))
		{
			bool released = true;
			for (const auto& previous : staged)
			{
				released = lifecycle_operation(state, previous.addon, nullptr) && released;
			}
			if (!released)
			{
				conout << "RENOVICE TARGET ADDON FATAL: staged roots could not be released"
					<< std::endl;
				subsystem_enabled.store(false, std::memory_order_release);
			}
			std::ostringstream failure;
			failure << "RENOVICE TARGET ADDON ROLLBACK stage failed: "
				<< chunk->name << " key=" << multi_target_key_text
				<< " multi_target=" << (chunk->multi_target ? 1 : 0)
				<< " previous target generation retained";
			conout << failure.str() << std::endl;
			config::log(failure.str());
			return false;
		}
		luau_TValue matches_damage_source{};
		luau_TValue after_damage{};
		luau_TValue transform_float_argument{};
		const bool has_matches_damage_source = lifecycle_hook_value(
			state, candidate.addon, "matchesDamageSource", matches_damage_source);
		const bool has_after_damage = lifecycle_hook_value(
			state, candidate.addon, "afterDamage", after_damage);
		const bool has_transform_float_argument = lifecycle_hook_value(
			state, candidate.addon, "transformFloatArgument", transform_float_argument);
		std::string native_call_error;
		if (!read_native_call_requests(
				state, candidate.addon, candidate.native_call_requests,
				native_call_error))
		{
			bool released = lifecycle_operation(
				state, candidate.addon, nullptr);
			for (const auto& previous : staged)
			{
				released = lifecycle_operation(
					state, previous.addon, nullptr) && released;
			}
			std::ostringstream failure;
			failure << "RENOVICE TARGET ADDON ROLLBACK nativeCalls invalid addon="
				<< candidate.addon.name << " reason=" << native_call_error
				<< " roots_released=" << released;
			conout << failure.str() << std::endl;
			config::log(failure.str());
			if (!released) subsystem_enabled.store(false, std::memory_order_release);
			return false;
		}
		std::string lua_call_error;
		if (!read_lua_call_requests(
				state, candidate.addon, candidate.lua_call_requests,
				lua_call_error))
		{
			bool released = lifecycle_operation(
				state, candidate.addon, nullptr);
			for (const auto& previous : staged)
			{
				released = lifecycle_operation(
					state, previous.addon, nullptr) && released;
			}
			std::ostringstream failure;
			failure << "RENOVICE TARGET ADDON ROLLBACK luaCalls invalid addon="
				<< candidate.addon.name << " reason=" << lua_call_error
				<< " roots_released=" << released;
			conout << failure.str() << std::endl;
			config::log(failure.str());
			if (!released) subsystem_enabled.store(false, std::memory_order_release);
			return false;
		}
		if (!candidate.lua_call_requests.empty())
		{
			const auto identity = std::find_if(
				target_module_identities.rbegin(), target_module_identities.rend(),
				[&](const TargetModuleIdentity& item)
				{
					return item.target_key == target_key
						&& item.global_state == global_state;
				});
			for (const auto& request : candidate.lua_call_requests)
			{
				const auto matches = identity == target_module_identities.rend() ? 0u
					: static_cast<unsigned int>(std::count_if(
						identity->prototypes.begin(), identity->prototypes.end(),
						[&](const TargetProtoRecord& proto)
						{ return proto.bytecode_id == request.prototype; }));
				if (matches != 1)
				{
					bool released = lifecycle_operation(
						state, candidate.addon, nullptr);
					for (const auto& previous : staged)
					{
						released = lifecycle_operation(
							state, previous.addon, nullptr) && released;
					}
					std::ostringstream failure;
					failure << "RENOVICE TARGET ADDON ROLLBACK luaCalls prototype rejected addon="
						<< candidate.addon.name << " prototype=" << request.prototype
						<< " matches=" << matches << " roots_released=" << released;
					conout << failure.str() << std::endl;
					config::log(failure.str());
					if (!released) subsystem_enabled.store(false, std::memory_order_release);
					return false;
				}
			}
		}
		candidate.requires_native_damage_adapters =
			target_addon_requires_native_damage_adapters(
				has_matches_damage_source, has_after_damage);
		candidate.requires_native_callsite_adapters =
			target_addon_requires_native_callsite_adapters(
				has_transform_float_argument);
		candidate.requires_lua_call_hooks = !candidate.lua_call_requests.empty();
		staged.emplace_back(std::move(candidate));
	}

	const auto transaction = commit_addon_generation(
		current,
		staged,
		[&](const TargetAddonRecord& addon)
		{
			return lifecycle_operation(state, addon.addon, "cleanup");
		},
		[&](const TargetAddonRecord& addon)
		{
			return lifecycle_operation(state, addon.addon, "activate");
		},
		[&](const TargetAddonRecord& addon)
		{
			return lifecycle_operation(state, addon.addon, nullptr);
		});

	active_target_addons.erase(std::remove_if(
		active_target_addons.begin(), active_target_addons.end(),
		[&](const TargetAddonRecord& addon)
		{
			return same_target_addon_context(
				target_key, global_state, owner_thread,
				addon.target_key, addon.global_state, addon.owner_thread);
		}), active_target_addons.end());
	active_target_addons.insert(
		active_target_addons.end(), current.begin(), current.end());
	publish_target_execution_snapshot_locked();

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
		std::ostringstream failure;
		failure << "RENOVICE TARGET ADDON "
			<< (transaction == TransactionResult::RollbackFailed
				|| transaction == TransactionResult::ReleaseRejected ? "FATAL" : "ROLLBACK")
			<< " key=" << std::hex << target_key << " reason=" << label;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		if (transaction == TransactionResult::RollbackFailed
			|| transaction == TransactionResult::ReleaseRejected)
		{
			subsystem_enabled.store(false, std::memory_order_release);
		}
		return false;
	}

	std::ostringstream success;
	success << "RENOVICE TARGET ADDON PASS key=" << std::hex << target_key
		<< std::dec << " addons=" << current.size()
		<< " vm=" << global_state << " thread=" << owner_thread;
	conout << success.str() << std::endl;
	config::log(success.str());
	const bool native_damage_adapters_requested =
		native_damage_adapters_requested_locked();
	const bool native_callsite_adapters_requested =
		native_callsite_adapters_requested_locked();
	const auto requested_native_calls = native_calls_with_diagnostics(
		config::flags(), native_call_hook_names_requested_locked());
	if (!current.empty() && wf_hash != nullptr)
	{
		if (run_script_hash == 0)
		{
			run_script_hash = wf_hash("RunScript");
		}
		ensure_run_script_observer();
		if (native_damage_adapters_requested || native_callsite_adapters_requested
			|| !requested_native_calls.empty())
		{
			if (native_damage_adapters_requested && set_damage_callback_hash == 0)
			{
				set_damage_callback_hash = wf_hash("SetDamageCallback");
			}
			if (native_damage_adapters_requested && set_source_object_hash == 0)
			{
				set_source_object_hash = wf_hash("SetSourceObject");
			}
			if (native_callsite_adapters_requested && push_float_arg_hash == 0)
			{
				push_float_arg_hash = wf_hash("PushFloatArg");
			}
			if (!ensure_native_hook_adapters(
				native_damage_adapters_requested,
				native_callsite_adapters_requested,
				requested_native_calls))
			{
				config::log("RENOVICE TARGET ADDON FAIL reason=native-adapter-commit");
				return false;
			}
		}
	}
	// Process-owned detours are never removed by a target generation change.
	// Published generation handlers decide whether an installed detour is active.
	return true;
}

bool activate_target_addons(
	std::uint64_t target_key,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle,
	bool* deferred
)
{
	if (deferred != nullptr) *deferred = false;
	const bool current_thread_borrows_generation =
		generation_dispatch_gate.current_thread_dispatching();
	if (current_thread_borrows_generation)
	{
		std::lock_guard generation_lock(generation_mutex);
		return activate_target_addons_locked(
			target_key, state, manager, name_handle, true, deferred);
	}

	auto generation_mutation = generation_dispatch_gate.begin_mutation(
		std::chrono::seconds(5));
	if (!generation_mutation)
	{
		if (deferred != nullptr) *deferred = true;
		config::log("RENOVICE TARGET ADDON DEFER reason=generation-borrow-timeout");
		return false;
	}
	std::lock_guard generation_lock(generation_mutex);
	return activate_target_addons_locked(
		target_key, state, manager, name_handle, false, deferred);
}

void queue_target_addon_refreshes()
{
	std::lock_guard generation_lock(generation_mutex);
	for (const auto& identity : target_module_identities)
	{
		const bool desired = std::any_of(
			active_chunks.begin(), active_chunks.end(), [&](const Chunk& chunk)
			{
				return chunk.kind == ScriptKind::TargetManagedAddon
					&& chunk.target_key == identity.target_key;
			});
		const bool active = std::any_of(
			active_target_addons.begin(), active_target_addons.end(),
			[&](const TargetAddonRecord& addon)
			{
				return same_target_addon_context(
					identity.target_key, identity.global_state, identity.owner_thread,
					addon.target_key, addon.global_state, addon.owner_thread);
			});
		if (!target_addon_refresh_required(desired, active)) continue;

		PendingTargetAddonRefresh job{
			identity.target_key,
			identity.global_state,
			identity.manager,
			{identity.name_handle[0], identity.name_handle[1]},
			identity.owner_thread,
		};
		auto existing = std::find_if(
			pending_target_addon_refreshes.begin(),
			pending_target_addon_refreshes.end(),
			[&](const PendingTargetAddonRefresh& candidate)
			{
				return same_target_addon_context(
					job.target_key, job.global_state, job.owner_thread,
					candidate.target_key, candidate.global_state,
					candidate.owner_thread);
			});
		if (existing == pending_target_addon_refreshes.end())
		{
			pending_target_addon_refreshes.push_back(job);
		}
		else
		{
			*existing = job;
		}
	}
	target_addon_refresh_pending.store(
		!pending_target_addon_refreshes.empty(), std::memory_order_release);
}

bool reconcile_target_diagnostic_bridge_for_current_vm(luau_State* state)
{
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr)
	{
		return false;
	}
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	const auto flags = config::flags();
	std::lock_guard generation_lock(generation_mutex);
	const TargetModuleIdentity* first_identity = nullptr;
	const TargetModuleIdentity* first_desired = nullptr;
	const TargetModuleIdentity* selected = nullptr;
	for (const auto& identity : target_module_identities)
	{
		if (identity.global_state != state->global_state
			|| identity.owner_thread != owner_thread)
		{
			continue;
		}
		if (first_identity == nullptr) first_identity = &identity;
		const bool desired = std::any_of(
			active_chunks.begin(), active_chunks.end(), [&](const Chunk& chunk)
			{
				return chunk.kind == ScriptKind::TargetManagedAddon
					&& chunk.target_key == identity.target_key;
			});
		if (!desired) continue;
		if (first_desired == nullptr) first_desired = &identity;
		const bool bridge_selected = diagnostic_bridge_may_format(flags.diagnostics_mode)
			&& flags.diagnostics_method.empty()
			&& flags.diagnostics_addon.empty()
			&& diagnostic_trace_selected(
				flags, identity.target_key, "target.trace.bridge", {});
		if (bridge_selected)
		{
			selected = &identity;
			break;
		}
	}
	if (selected == nullptr)
		selected = first_desired != nullptr ? first_desired : first_identity;
	if (selected == nullptr) return true;
	const bool target_addon_present = std::any_of(
		active_chunks.begin(), active_chunks.end(), [&](const Chunk& chunk)
		{
			return chunk.kind == ScriptKind::TargetManagedAddon
				&& chunk.target_key == selected->target_key;
		});
	std::uintptr_t shared_table_identity = 0;
	return prepare_target_shared_table(
		selected->target_key, state, selected->environment,
		shared_table_identity, target_addon_present, true);
}

bool drain_pending_target_addons_for_vm(luau_State* state)
{
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr)
	{
		return false;
	}
	if (inspect_lua_mutation_boundary(state)
		!= LuaMutationBoundaryBlocker::Ready)
	{
		return false;
	}
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	bool complete = true;
	for (;;)
	{
		PendingTargetAddonRefresh pending;
		bool found = false;
		{
			std::lock_guard generation_lock(generation_mutex);
			const auto job = std::find_if(
				pending_target_addon_refreshes.begin(),
				pending_target_addon_refreshes.end(),
				[&](const PendingTargetAddonRefresh& candidate)
				{
					return target_addon_refresh_ready(
						candidate.global_state, candidate.owner_thread,
						state->global_state, owner_thread);
				});
			if (job != pending_target_addon_refreshes.end())
			{
				pending = *job;
				found = true;
			}
			else
			{
				target_addon_refresh_pending.store(
					!pending_target_addon_refreshes.empty(),
					std::memory_order_release);
			}
		}
		if (!found) return complete;

		bool deferred = false;
		const bool activated = activate_target_addons(
			pending.target_key, state, pending.manager, pending.name_handle,
			&deferred);
		if (deferred)
		{
			target_addon_refresh_pending.store(true, std::memory_order_release);
			return false;
		}

		{
			std::lock_guard generation_lock(generation_mutex);
			pending_target_addon_refreshes.erase(std::remove_if(
				pending_target_addon_refreshes.begin(),
				pending_target_addon_refreshes.end(),
				[&](const PendingTargetAddonRefresh& candidate)
				{
					return same_target_addon_context(
						pending.target_key, pending.global_state, pending.owner_thread,
						candidate.target_key, candidate.global_state,
						candidate.owner_thread);
				}), pending_target_addon_refreshes.end());
			target_addon_refresh_pending.store(
				!pending_target_addon_refreshes.empty(),
				std::memory_order_release);
		}
		if (!activated)
		{
			complete = false;
			std::ostringstream failure;
			failure << "RENOVICE TARGET ADDON PENDING ABORT key="
				<< std::hex << pending.target_key << std::dec
				<< " reason=activation-rejected retry=natural-load-or-F9";
			config::log(failure.str());
		}
	}
}

std::size_t queue_stale_target_addons_for_current_shared_table(
	luau_State* state,
	std::uintptr_t current_shared_table_identity
)
{
	if (state == nullptr || state->global_state == nullptr
		|| current_shared_table_identity == 0)
	{
		return 0;
	}
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	std::lock_guard generation_lock(generation_mutex);
	std::size_t queued = 0;
	for (const auto& identity : target_module_identities)
	{
		if (identity.global_state != state->global_state
			|| identity.owner_thread != owner_thread)
		{
			continue;
		}
		const auto desired_count = static_cast<std::size_t>(std::count_if(
			active_chunks.begin(), active_chunks.end(), [&](const Chunk& chunk)
			{
				return chunk.kind == ScriptKind::TargetManagedAddon
					&& chunk.target_key == identity.target_key;
			}));
		std::size_t active_count = 0;
		bool current_shared_table = true;
		for (const auto& addon : active_target_addons)
		{
			if (!same_target_addon_context(
				identity.target_key, identity.global_state, identity.owner_thread,
				addon.target_key, addon.global_state, addon.owner_thread))
			{
				continue;
			}
			++active_count;
			current_shared_table = current_shared_table
				&& addon.shared_table_identity == current_shared_table_identity;
		}
		if (!target_addon_generation_rebind_required(
			desired_count, active_count, current_shared_table))
		{
			continue;
		}

		PendingTargetAddonRefresh job{
			identity.target_key,
			identity.global_state,
			identity.manager,
			{identity.name_handle[0], identity.name_handle[1]},
			identity.owner_thread,
		};
		auto existing = std::find_if(
			pending_target_addon_refreshes.begin(),
			pending_target_addon_refreshes.end(),
			[&](const PendingTargetAddonRefresh& candidate)
			{
				return same_target_addon_context(
					job.target_key, job.global_state, job.owner_thread,
					candidate.target_key, candidate.global_state,
					candidate.owner_thread);
			});
		if (existing == pending_target_addon_refreshes.end())
		{
			pending_target_addon_refreshes.push_back(job);
			++queued;
		}
		else
		{
			*existing = job;
		}
	}
	target_addon_refresh_pending.store(
		!pending_target_addon_refreshes.empty(), std::memory_order_release);
	return queued;
}

bool maintain_current_vm_generation(luau_State* state)
{
	if (!scripts_ui_enabled.load(std::memory_order_acquire)
		&& !observe_target_addons.load(std::memory_order_acquire))
	{
		return true;
	}
	std::uintptr_t shared_table_identity = 0;
	bool scripts_bridge_present = false;
	if (!inspect_current_shared_table(
		state, shared_table_identity, scripts_bridge_present))
	{
		config::log("RENOVICE VM generation maintenance FAIL reason=_T-unavailable");
		return false;
	}

	bool bridge_ready = !scripts_ui_enabled.load(std::memory_order_acquire)
		|| scripts_bridge_present;
	if (!bridge_ready)
	{
		const auto now_ms = static_cast<std::uint64_t>(GetTickCount64());
		const bool retry_due = failed_scripts_bridge_shared_table
			!= shared_table_identity
			|| safe_runtime_tick_due(
				now_ms, failed_scripts_bridge_attempt_ms,
				scripts_bridge_retry_interval_ms);
		if (retry_due)
		{
			Chunk bridge;
			bool bridge_found = false;
			{
				std::lock_guard generation_lock(generation_mutex);
				const auto found = std::find_if(
					active_chunks.begin(), active_chunks.end(), [](const Chunk& chunk)
					{
						return is_internal_scripts_ui_bridge(chunk.name);
					});
				if (found != active_chunks.end())
				{
					bridge = *found;
					bridge_found = true;
				}
			}
			failed_scripts_bridge_shared_table = shared_table_identity;
			failed_scripts_bridge_attempt_ms = now_ms;
			if (bridge_found && run_chunk(bridge, state))
			{
				std::uintptr_t verified_identity = 0;
				bool verified_bridge = false;
				bridge_ready = inspect_current_shared_table(
					state, verified_identity, verified_bridge)
					&& verified_identity == shared_table_identity
					&& verified_bridge;
			}
			if (bridge_ready)
			{
				failed_scripts_bridge_shared_table = 0;
				failed_scripts_bridge_attempt_ms = 0;
				std::ostringstream success;
				success << "RENOVICE Scripts UI bridge REBOUND shared_table="
					<< reinterpret_cast<void*>(shared_table_identity)
					<< " vm=" << state->global_state;
				conout << success.str() << std::endl;
				config::log(success.str());
			}
			else
			{
				std::ostringstream failure;
				failure << "RENOVICE Scripts UI bridge rebind FAIL shared_table="
					<< reinterpret_cast<void*>(shared_table_identity)
					<< " bridge_chunk=" << (bridge_found ? "present" : "missing");
				config::log(failure.str());
			}
		}
	}

	const auto queued = observe_target_addons.load(std::memory_order_acquire)
		? queue_stale_target_addons_for_current_shared_table(
			state, shared_table_identity)
		: 0;
	const bool target_ready = drain_pending_target_addons_for_vm(state);
	if (queued != 0)
	{
		std::ostringstream repaired;
		repaired << "RENOVICE target addon _T generation CHANGE queued="
			<< queued << " shared_table="
			<< reinterpret_cast<void*>(shared_table_identity)
			<< " result=" << (target_ready ? "PASS" : "RETRY");
		conout << repaired.str() << std::endl;
		config::log(repaired.str());
	}
	return bridge_ready && target_ready;
}

bool apply_generation(
	const std::vector<Chunk>& candidate,
	const std::vector<std::uint64_t>& candidate_target_keys,
	luau_State* boundary_state,
	const char* trigger
)
{
	auto generation_mutation = generation_dispatch_gate.begin_mutation(
		std::chrono::seconds(5));
	if (!generation_mutation)
	{
		conout << "RENOVICE ADDON ROLLBACK: active generation callbacks did not drain"
			<< std::endl;
		config::log("RENOVICE ADDON ROLLBACK reason=generation-borrow-timeout");
		return false;
	}
	std::lock_guard generation_lock(generation_mutex);
	const auto generation = next_generation++;
	auto* state = boundary_state;
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State)))
	{
		conout << "RENOVICE ADDON ROLLBACK: current DE execution boundary unavailable" << std::endl;
		return false;
	}
	const auto lua_blocker = inspect_lua_mutation_boundary(state);
	if (lua_blocker != LuaMutationBoundaryBlocker::Ready)
	{
		conout << "RENOVICE ADDON ROLLBACK: Lua mutation boundary "
			<< lua_mutation_boundary_label(lua_blocker) << std::endl;
		return false;
	}
	const bool managed_generation_reused =
		unchanged_managed_generation_can_reuse_roots(
			active_chunks, candidate, active_addons);
	if (!managed_generation_reused)
	{
		std::vector<AddonRecord> staged;
		std::size_t addon_index = 0;
		for (const auto& chunk : candidate)
		{
			if (chunk.kind != ScriptKind::ManagedAddon) continue;
			AddonRecord addon;
			addon.name = chunk.name;
			addon.registry_key = "__RENOVICE_ADDON_" + std::to_string(generation)
				+ "_" + std::to_string(addon_index++);
			addon.generation = generation;
			addon.global_state = state->global_state;
			addon.owner_thread = GetCurrentThreadId();
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
			}
			if (transaction == TransactionResult::RollbackFailed
				|| transaction == TransactionResult::ReleaseRejected)
			{
				subsystem_enabled.store(false, std::memory_order_release);
			}
			return false;
		}
	}

	active_generation = generation;
	active_chunks = candidate;
	configured_target_keys = candidate_target_keys;
	// Root-instance watch set follows the committed enabled target addons.
	publish_target_execution_snapshot_locked();
	scripts_ui_enabled.store(std::any_of(
		active_chunks.begin(), active_chunks.end(), [](const Chunk& chunk)
		{
			return is_internal_scripts_ui_bridge(chunk.name);
		}), std::memory_order_release);
	queue_target_addon_refreshes();
	const bool target_refresh_complete = drain_pending_target_addons_for_vm(state);
	std::size_t ordinary_failures = 0;
	std::size_t ordinary_count = 0;
	std::size_t target_addon_count = 0;
	for (const auto& chunk : active_chunks)
	{
		if (chunk.kind == ScriptKind::TargetManagedAddon)
		{
			++target_addon_count;
		}
		else if (chunk.kind == ScriptKind::Ordinary)
		{
			++ordinary_count;
			if (!run_chunk(chunk, boundary_state)) ++ordinary_failures;
		}
	}
	if (target_addon_count != 0)
	{
		// Once enabled, keep observing natural loads so removing the final target
		// addon can still clean a previously activated VM-local generation.
		observe_target_addons.store(true, std::memory_order_release);
	}
	conout << "RENOVICE RELOAD PASS trigger=" << trigger
		<< " generation=" << generation
		<< " addons=" << active_addons.size()
		<< " managed_generation="
		<< (managed_generation_reused ? "reused" : "replaced")
		<< " target_addons=" << target_addon_count
		<< " observed_target_keys=" << configured_target_keys.size()
		<< " one_shots=" << ordinary_count
		<< " one_shot_failures=" << ordinary_failures
		<< " target_pending=" << pending_target_addon_refreshes.size()
		<< " applies=generic-immediate/target-per-vm-transactional"
		<< (target_refresh_complete ? "" : "/current-vm-retry-pending")
		<< std::endl;
	std::ostringstream success;
	success << "RENOVICE RELOAD PASS trigger=" << trigger
		<< " generation=" << generation
		<< " addons=" << active_addons.size()
		<< " managed_generation="
		<< (managed_generation_reused ? "reused" : "replaced")
		<< " target_addons=" << target_addon_count
		<< " observed_target_keys=" << configured_target_keys.size()
		<< " one_shots=" << ordinary_count
		<< " one_shot_failures=" << ordinary_failures
		<< " target_pending=" << pending_target_addon_refreshes.size();
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
	if (!initialise_game_vm_stack_bridge()) return false;
	game_allocate = resolve_unique<GameAllocate>(range, signature_game_allocator, "game allocator");
	protected_call = resolve_unique<ProtectedCall>(range, signature_protected_call, "protected call");
	auto vm_execute = resolve_unique<VmExecute>(range, signature_vm_execute, "Luau VM execute");
	auto interrupt_increment = resolve_unique<DeLuauInterruptIncrement>(range,
		signature_interrupt_increment_u43, "U43 thread interrupt increment");
	auto interrupt_guard = resolve_unique<void*>(range,
		signature_interrupt_guard_u43, "U43 DE Luau interrupt callback");
	if (loader == nullptr || key_builder == nullptr || getfield == nullptr
		|| setfield == nullptr || check_stack == nullptr || game_allocate == nullptr
		|| protected_call == nullptr || vm_execute == nullptr || gc_barrierback == nullptr
		|| interrupt_increment == nullptr || interrupt_guard == nullptr)
	{
		return false;
	}
	injected_interrupt_contract_ready = true;
	memory_evidence_layout_ready =
		resolve_unique<void*>(range, signature_memory_gc_counter_u43, "U43 read-only GC counter fields") != nullptr
		&& resolve_unique<void*>(range, signature_memory_gc_roots_u43, "U43 read-only GC root fields") != nullptr
		&& resolve_unique<void*>(range, signature_memory_gc_thread_link_u43, "U43 read-only GC thread link") != nullptr;
	memory_evidence_layout_ready = memory_evidence_layout_ready
		&& resolve_unique<void*>(range, signature_memory_gc_table_link_u43, "U43 read-only GC table link") != nullptr
		&& resolve_unique<void*>(range, signature_memory_gc_total_u43, "U43 read-only GC total bytes") != nullptr;
	config::log(std::string("RENOVICE VM_MEMORY build=V96 event=layout-")
		+ (memory_evidence_layout_ready ? "ready" : "rejected")
		+ " interval_ms=5000 lua-api-calls=0 collector-control=0 physical-session-log=1");
	config::log("RENOVICE VM_STACK build=V93 event=contract-ready barrier=native checked-reservation=yes callback-offsets=yes");
	config::log("RENOVICE VM_FRAME build=V110 event=contract-ready capacity-restore=all-api-owners lua-call-host-frame=native-protected lua-call-boundary=de-interrupt-counter-leaf-before-only provider-fast-gate=atomic live-prototype=environment-code-count-body native-damage-target=exact-prototype-fallback native-limit=8000-unchanged");

	loader_hook.target = reinterpret_cast<void*>(loader);
	loader_hook.detour = reinterpret_cast<void*>(&loader_detour);
	vm_execute_hook.target = reinterpret_cast<void*>(vm_execute);
	vm_execute_hook.detour = reinterpret_cast<void*>(&vm_execute_detour);
	de_luau_interrupt_hook.target = reinterpret_cast<void*>(interrupt_increment);
	de_luau_interrupt_hook.detour = reinterpret_cast<void*>(
		&de_luau_interrupt_increment_detour);
	try
	{
		loader_hook.create();
		vm_execute_hook.create();
	}
	catch (const std::exception& exception)
	{
		if (vm_execute_hook.isCreated()) vm_execute_hook.destroy();
		if (loader_hook.isCreated()) loader_hook.destroy();
		conout << "RENOVICE Inject loader hook failed closed: " << exception.what() << std::endl;
		return false;
	}
	if (!loader_hook.isCreated() || !vm_execute_hook.isCreated())
	{
		if (vm_execute_hook.isCreated()) vm_execute_hook.destroy();
		if (loader_hook.isCreated()) loader_hook.destroy();
		conout << "RENOVICE Inject loader hook failed closed: trampoline creation failed"
			<< std::endl;
		return false;
	}
	// protected_call remains a directly resolved call target for RENOVICE-owned
	// addon execution. It is deliberately not detoured process-wide.
	vm_execute_hook.enable();
	loader_hook.enable();

	// The ordinary Inject/Replacement loader is already active. A failure in the
	// optional nested-call observer may reject only providers that request
	// hooks.luaCalls; it must never roll back unrelated scripts or the UI bridge.
	lua_before_observer_ready.store(false, std::memory_order_release);
	try
	{
		de_luau_interrupt_hook.create();
		if (!de_luau_interrupt_hook.isCreated())
			throw std::runtime_error("interrupt-counter trampoline creation failed");
		de_luau_interrupt_hook.enable();
		lua_before_observer_ready.store(true, std::memory_order_release);
		config::log("RENOVICE luaCalls before observer build=V110 boundary=DE-interrupt-counter-leaf-0x1AB150 owner-callback=0x197EC80 stock-first=1 stock-result-preserved=1 provider-fast-gate=atomic unrelated-stack-write=0 live-prototype=environment-code-count-body after=fail-closed");
	}
	catch (const std::exception& exception)
	{
		if (de_luau_interrupt_hook.isCreated())
			de_luau_interrupt_hook.destroy();
		conout << "RENOVICE luaCalls before observer unavailable; ordinary Inject and Replacement remain enabled: "
			<< exception.what() << std::endl;
		config::log(std::string("RENOVICE luaCalls before observer unavailable build=V110; base-loader-retained=1 reason=")
			+ exception.what());
	}
	return true;
}
}

bool initialise_game_vm_stack_bridge() noexcept
{
	try
	{
		if (check_stack != nullptr && gc_barrierback != nullptr
			&& game_pushvalue != nullptr) return true;
		const soup::Module game(nullptr);
		const auto& range = game.range;
		auto* const resolved_check_stack = resolve_unique<CheckStack>(
			range, signature_checkstack, "checkstack");
		auto* const resolved_barrier = resolve_unique<GcBarrierBack>(
			range, signature_gc_barrierback_u43,
			"U43 stack GC write barrier");
		auto* const resolved_pushvalue = resolve_unique<GamePushValue>(
			range, signature_lua_pushvalue_u43,
			"U43 native lua_pushvalue");
		if (resolved_check_stack == nullptr || resolved_barrier == nullptr
			|| resolved_pushvalue == nullptr)
		{
			config::log(
				"RENOVICE VM_BRIDGE build=V100 event=resolution-rejected; game stack writes disabled");
			return false;
		}
		check_stack = resolved_check_stack;
		gc_barrierback = resolved_barrier;
		game_pushvalue = resolved_pushvalue;
		config::log(
			"RENOVICE VM_BRIDGE build=V100 event=contract-ready checked-reservation=1 native-pushvalue=1 fallback-thread-barrier=1");
		return true;
	}
	catch (...)
	{
		config::log(
			"RENOVICE VM_BRIDGE build=V100 event=resolution-fault; game stack writes disabled");
		return false;
	}
}

bool reserve_game_vm_stack(luau_State* state, int slots) noexcept
{
	if (state == nullptr || slots < 0 || check_stack == nullptr) return false;
	return check_stack(state, slots) != 0;
}

bool push_game_vm_stack_index(luau_State* state, int index) noexcept
{
	if (state == nullptr || check_stack == nullptr || game_pushvalue == nullptr)
		return false;
	if (!check_stack(state, 1)) return false;
	game_pushvalue(state, index);
	return true;
}

bool append_game_vm_stack_value(
	luau_State* state, luau_TValue value) noexcept
{
	if (state == nullptr || check_stack == nullptr || gc_barrierback == nullptr)
		return false;
	return checked_stack_append(*state, value,
		[state](int slots) { return check_stack(state, slots) != 0; },
		[state]
		{
			gc_barrierback(state, reinterpret_cast<luau_GCObject*>(state),
				&state->gclist);
		});
}

bool append_game_vm_stack_value_reserved(
	luau_State* state, luau_TValue value) noexcept
{
	// The caller owns the wider host+argument+scratch proof. This final append
	// gate independently proves both physical storage and the current CallInfo
	// window. check_stack may allocate or raise a DE Luau error and must never
	// run while native C++ lock/generation leases are live outside protection.
	if (state == nullptr || gc_barrierback == nullptr
		|| state->stack == nullptr || state->outtop == nullptr
		|| state->stack_last == nullptr || state->ci == nullptr
		|| state->ci->top == nullptr || state->outtop < state->stack
		|| state->outtop >= state->stack_last
		|| state->ci->top > state->stack_last
		|| state->outtop >= state->ci->top)
	{
		return false;
	}
	if ((state->marked & native_gc_black_mask_u43) != 0)
	{
		gc_barrierback(state, reinterpret_cast<luau_GCObject*>(state),
			&state->gclist);
	}
	*state->outtop++ = value;
	return true;
}

void maybe_wrap_global(luau_State* state, std::uint32_t name_hash) noexcept
{
	// TopMenu executes and publishes Initialize inside the original loader call.
	// Observe that exact SETGLOBAL while the semantic TopMenu load boundary is
	// active, then replace only Initialize's captured row-builder upvalue. This
	// binds the extension to DE's base script instead of polling UI instances.
	try
	{
		if (active_pause_load_boundary.active
			&& subsystem_enabled.load(std::memory_order_acquire)
			&& state != nullptr && state->outtop != nullptr
			&& wf_hash != nullptr
			&& active_pause_load_boundary.owner_thread
				== static_cast<std::uint32_t>(GetCurrentThreadId())
			&& name_hash == wf_hash("Initialize"))
		{
			const auto assignment = ++active_pause_load_boundary.initialize_assignments;
			const auto assigned = state->outtop[-1];
			if (assignment <= 4)
			{
				std::ostringstream observed;
				observed << "RENOVICE Scripts UI SETGLOBAL OBSERVE key=" << std::hex
					<< active_pause_load_boundary.body_key << std::dec
					<< " assignment=" << assignment
					<< " tag=" << assigned.type
					<< " identity="
					<< reinterpret_cast<void*>(assigned.value.as_uintptr);
				luau_Closure* closure = nullptr;
				if (readable_lua_closure(assigned, closure))
				{
					observed << " is_c=" << (closure->isC ? 1 : 0)
						<< " upvalues="
						<< static_cast<unsigned int>(closure->nupvalues)
						<< " stacksize="
						<< static_cast<unsigned int>(closure->stacksize)
						<< " env=" << closure->env
						<< " proto="
						<< (closure->isC ? nullptr : closure->l.p);
				}
				conout << observed.str() << std::endl;
				config::log(observed.str());
			}
			const bool attached = decorate_pause_initialize_assignment(
				active_pause_load_boundary.body_key,
				state,
				assigned,
				"setglobal");
			std::ostringstream result;
			result << "RENOVICE Scripts UI SETGLOBAL RESULT "
				<< (attached ? "PASS" : "FAIL")
				<< " key=" << std::hex
				<< active_pause_load_boundary.body_key << std::dec
				<< " assignment=" << assignment;
			conout << result.str() << std::endl;
			config::log(result.str());
		}
	}
	catch (...)
	{
		config::log("RENOVICE Scripts UI SETGLOBAL RESULT FAIL reason=exception");
	}

	if (!retracted_cached_card_export_decorator_enabled.load(
			std::memory_order_acquire)
		|| !subsystem_enabled.load(std::memory_order_acquire)
		|| !observe_target_addons.load(std::memory_order_acquire)
		|| state == nullptr || state->stack == nullptr || state->outtop == nullptr
		|| state->ci == nullptr
		|| state->ci->func == nullptr || luau_pushcclosurek == nullptr
		|| wf_hash == nullptr)
	{
		return;
	}
	if (ability_card_export_hash == 0)
	{
		ability_card_export_hash = wf_hash("GetAbilityUpgradeLevelInfo");
	}
	if (name_hash != ability_card_export_hash || state->outtop == state->intop)
	{
		return;
	}
	const auto assigned_slot_offset = luau_savestack(state, state->outtop - 1);
	auto* assigned_slot = luau_restorestack(state, assigned_slot_offset);
	luau_Closure* assigned_closure = nullptr;
	if (!readable_lua_closure(*assigned_slot, assigned_closure)
		|| (assigned_closure->isC
			&& assigned_closure->c.func == &ability_card_wrapper))
	{
		return;
	}
	std::uint64_t target_key = 0;
	{
		std::lock_guard lock(generation_mutex);
		// The value being assigned is the module export. The current frame is
		// the VM's SETGLOBAL helper and does not establish script ownership. This
		// legacy API path is only a fallback; VM SETGLOBAL bytecode does not call
		// it, so natural module loads use decorate_target_card_export instead.
		target_key = target_key_for_closure_locked(state, *assigned_slot);
	}
	if (target_key == 0) return;
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 4);
	assigned_slot = luau_restorestack(state, assigned_slot_offset);
	const auto original = *assigned_slot;
	push_stack_value(state, original);
	if (!luau_push_lightuserdata(
		state, reinterpret_cast<void*>(static_cast<std::uintptr_t>(target_key))))
	{
		state->outtop = assigned_slot + 1;
		return;
	}
	luau_pushcclosurek(
		state, &ability_card_wrapper,
		"RENOVICE after-card dispatcher", 2, nullptr);
	prepare_stack_write(state);
			*assigned_slot = state->outtop[-1];
	state->outtop = assigned_slot + 1;
	log_native_hook_once(
		state, target_key, "GetAbilityUpgradeLevelInfo.attach");
}

bool execute_module_refresh(
	const std::string& name,
	const std::vector<unsigned char>& bytes,
	void* environment,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle
)
{
	if (bytes.empty() || environment == nullptr || manager == nullptr || name_handle == nullptr)
	{
		return false;
	}
	Chunk chunk;
	chunk.name = name;
	chunk.bytes = bytes;
	chunk.kind = ScriptKind::Ordinary;
	return run_chunk(chunk, state, nullptr, environment, false, manager, name_handle);
}

struct NativeModuleRefreshLeafContext
{
	void* manager = nullptr;
	void* descriptor = nullptr;
	const unsigned char* bytecode = nullptr;
	std::size_t bytecode_size = 0;
	void** body_slot = nullptr;
	std::uint32_t* size_slot = nullptr;
	void* game_buffer = nullptr;
	bool guard_prepared = false;
	bool completed = false;
	bool loaded = false;
	bool native_fault = false;
	bool outer_error_jump_restored = false;
	int loader_status = -1;
	unsigned long fault_code = 0;
	void* fault_address = nullptr;
	int fault_stage = 0;
};
static_assert(std::is_trivially_copyable_v<NativeModuleRefreshLeafContext>);

// BEGIN NATIVE_MODULE_REFRESH_PROTECTED_LEAF
// The VEH target lives inside the outer DE raw-protected frame. A native fault
// in Loader may therefore jump across only the nested Loader raw runner. The
// fault branch restores the outer DE error-jump record before returning to the
// outer runner, whose normal epilogue restores ci, ci->top, intop and outtop.
// This leaf must remain destructor-free.
void native_module_refresh_protected_leaf(
	luau_State* state,
	void* raw_context) noexcept
{
	auto* const context = static_cast<NativeModuleRefreshLeafContext*>(
		raw_context);
	if (context == nullptr || state == nullptr || context->manager == nullptr
		|| context->descriptor == nullptr || context->bytecode == nullptr
		|| context->bytecode_size == 0 || context->body_slot == nullptr
		|| context->size_slot == nullptr || game_allocate == nullptr)
	{
		return;
	}
	if (guard.active != 0 || guard.handler != nullptr)
	{
		context->completed = true;
		return;
	}

	std::memset(&guard, 0, sizeof(guard));
	guard.state = state;
	guard.base_offset = luau_savestack(state, state->outtop);
	guard.thread_id = GetCurrentThreadId();
	if (!capture_guard_outer_error_jump(state))
	{
		context->completed = true;
		return;
	}
	guard.handler = AddVectoredExceptionHandler(1, fault_handler);
	if (guard.handler == nullptr)
	{
		context->completed = true;
		return;
	}
	context->guard_prepared = true;
	if (setjmp(guard.jump) != 0)
	{
		context->native_fault = true;
		context->fault_stage = guard.fault_stage;
		context->fault_code = guard.fault_code;
		context->fault_address = guard.fault_address;
		context->outer_error_jump_restored =
			restore_guard_outer_error_jump_after_fault();
		if (context->game_buffer != nullptr
			&& *context->body_slot == context->game_buffer)
		{
			*context->body_slot = nullptr;
			*context->size_slot = 0;
		}
		disarm_guard_exception_handler();
		context->completed = true;
		return;
	}

	guard.active = 1;
	guard.stage = 29;
	context->game_buffer = game_allocate(context->bytecode_size, 0);
	if (context->game_buffer == nullptr
		|| IsBadWritePtr(context->game_buffer, context->bytecode_size))
	{
		disarm_guard_exception_handler();
		context->completed = true;
		return;
	}
	std::memcpy(
		context->game_buffer, context->bytecode, context->bytecode_size);

	guard.stage = 30;
	*context->body_slot = context->game_buffer;
	*context->size_slot = static_cast<std::uint32_t>(context->bytecode_size);
	const auto loader_result = invoke_stock_loader_protected(
		state, context->manager, context->descriptor,
		StockLoaderErrorPolicy::ContainAndRestore);
	context->loader_status = loader_result.status;
	if (loader_result.admitted && !loader_result.restored)
	{
		if (*context->body_slot == context->game_buffer)
		{
			*context->body_slot = nullptr;
			*context->size_slot = 0;
		}
		abandon_guard_without_vm_access();
		context->completed = true;
		return;
	}
	context->loaded = loader_result.admitted && loader_result.restored
		&& loader_result.status == 0 && loader_result.returned
		&& loader_result.value;
	if (loader_result.status != 0
		&& *context->body_slot == context->game_buffer)
	{
		*context->body_slot = nullptr;
		*context->size_slot = 0;
	}
	if (context->guard_prepared) disarm_guard_exception_handler();
	context->completed = true;
}
// END NATIVE_MODULE_REFRESH_PROTECTED_LEAF

bool execute_native_module_refresh(
	const std::string& name,
	const std::vector<unsigned char>& bytes,
	luau_State* state,
	void* manager,
	void* descriptor
)
{
	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	if (bytes.empty() || !valid_chunk_size(bytes.size())
		|| state == nullptr || manager == nullptr || descriptor == nullptr
		|| diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| diagnostics::bad_read_ptr(manager, 0x28) || IsBadWritePtr(descriptor, 0x44))
	{
		return false;
	}
	auto* manager_state = *reinterpret_cast<luau_State**>(
		reinterpret_cast<unsigned char*>(manager) + 0x20);
	if (manager_state == nullptr || diagnostics::bad_read_ptr(manager_state, sizeof(luau_State))
		|| manager_state->global_state == nullptr
		|| manager_state->global_state != state->global_state
		|| manager_state->outtop == nullptr)
	{
		return false;
	}
	auto** body_slot = reinterpret_cast<void**>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x38);
	auto* size_slot = reinterpret_cast<std::uint32_t*>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x40);
	if (*body_slot != nullptr || *size_slot != 0)
	{
		conout << "RENOVICE native module refresh skipped " << name
			<< ": descriptor is already carrying bytecode" << std::endl;
		return false;
	}
	NativeModuleRefreshLeafContext context{};
	context.manager = manager;
	context.descriptor = descriptor;
	context.bytecode = bytes.data();
	context.bytecode_size = bytes.size();
	context.body_slot = body_slot;
	context.size_slot = size_slot;
	const auto protected_result = de_vm_authority::run_current_vm_protected(
		manager_state, &native_module_refresh_protected_leaf, &context);
	// If an outer DE escape skipped the leaf epilogue, retire its native handler
	// only after the shared runner has restored the exact VM frame.
	if (context.guard_prepared) disarm_guard_exception_handler();
	if (!protected_result.admitted || !protected_result.restored
		|| protected_result.status != 0 || !context.completed)
	{
		if (context.game_buffer != nullptr
			&& *body_slot == context.game_buffer)
		{
			*body_slot = nullptr;
			*size_slot = 0;
		}
		return false;
	}
	if (context.native_fault)
	{
		std::ostringstream failure;
		failure << "RENOVICE native module refresh FAULT " << name
			<< " stage=" << context.fault_stage
			<< " exception_code=" << static_cast<std::uint32_t>(
				context.fault_code)
			<< " address=" << context.fault_address
			<< " outer_error_jump_restored="
			<< context.outer_error_jump_restored;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}
	std::ostringstream result;
	result << "RENOVICE native module refresh "
		<< (context.loaded ? "PASS" : "FAIL")
		<< " " << name << " descriptor=" << descriptor
		<< " bytes=" << bytes.size();
	conout << result.str() << std::endl;
	config::log(result.str());
	return context.loaded;
}

InitialiseResult initialise()
{
	const bool diagnostics_ready = reconcile_process_fault_diagnostics();
	const std::string diagnostics_state = !diagnostics_ready
		? "RENOVICE native null-fault diagnostics unavailable"
		: config::diagnostics_enabled()
			? "RENOVICE native null-fault diagnostics armed"
			: "RENOVICE native null-fault diagnostics absent while diagnostics are off";
	conout << diagnostics_state << std::endl;
	config::log(diagnostics_state);
	const bool safe_tick_registered = safe_runtime_tick.load(
		std::memory_order_acquire) != nullptr;
	const std::string safe_tick_state = safe_tick_registered
		? "RENOVICE pending-only transaction drain registered: outer VM return; legacy Pluto scheduler excluded"
		: "RENOVICE transaction drain unavailable: callback not registered";
	conout << safe_tick_state << std::endl;
	config::log(safe_tick_state);
	const bool control_poll_registered = safe_runtime_control_poll.load(
		std::memory_order_acquire) != nullptr;
	const std::string control_poll_state = control_poll_registered
		? "RENOVICE F9 latch registered: Lua-free owner-thread VM returns"
		: "RENOVICE F9 latch unavailable: control callback not registered";
	conout << control_poll_state << std::endl;
	config::log(control_poll_state);
	std::vector<Chunk> snapshot;
	std::vector<std::uint64_t> target_keys;
	if (!scan_snapshot(snapshot, target_keys))
	{
		return InitialiseResult::Failed;
	}
	{
		std::lock_guard lock(generation_mutex);
		configured_target_keys = target_keys;
	}
	observe_target_addons.store(!target_keys.empty(), std::memory_order_release);
	if (!install_loader_hook())
	{
		return InitialiseResult::Failed;
	}
	active_chunks = std::move(snapshot);
	subsystem_enabled.store(true, std::memory_order_release);
	scripts_ui_enabled.store(std::any_of(
		active_chunks.begin(), active_chunks.end(), [](const Chunk& chunk)
		{
			return is_internal_scripts_ui_bridge(chunk.name);
		}), std::memory_order_release);
	startup_pending.store(true, std::memory_order_release);
	{
		const std::string architecture = "RENOVICE Scripts UI architecture="
			+ std::string(pause_menu_architecture_marker);
		conout << architecture << std::endl;
		config::log(architecture);
		const std::string ui_state = scripts_ui_enabled.load(
			std::memory_order_acquire)
			? "RENOVICE Scripts UI enabled: required NAMECALL bridge configured"
			: "RENOVICE Scripts UI disabled: required NAMECALL bridge absent; stock TopMenu preserved";
		conout << ui_state << std::endl;
		config::log(ui_state);
	}
	const auto addons = std::count_if(active_chunks.begin(), active_chunks.end(), [](const Chunk& chunk)
	{
		return chunk.kind == ScriptKind::ManagedAddon;
	});
	const auto target_addons = std::count_if(
		active_chunks.begin(), active_chunks.end(), [](const Chunk& chunk)
		{
			return chunk.kind == ScriptKind::TargetManagedAddon;
		});
	conout << "RENOVICE additive injection enabled: staged_chunks=" << active_chunks.size()
		<< " managed_addons=" << addons
		<< " target_managed_addons=" << target_addons
		<< " observed_target_keys=" << target_keys.size()
		<< " (legacy persist/spawn disabled)" << std::endl;
	return InitialiseResult::Enabled;
}

void set_safe_runtime_tick(SafeRuntimeTick callback) noexcept
{
	safe_runtime_tick.store(callback, std::memory_order_release);
}

void set_safe_runtime_control_poll(SafeRuntimeControlPoll callback) noexcept
{
	safe_runtime_control_poll.store(callback, std::memory_order_release);
}

void notify_swig_types_ready()
{
	if (!subsystem_enabled.load(std::memory_order_acquire)
		|| wf_hash == nullptr)
	{
		return;
	}
	if (observe_target_addons.load(std::memory_order_acquire))
	{
		bool target_configured = false;
		{
			std::lock_guard lock(generation_mutex);
			target_configured = target_chunks_configured_locked();
		}
		if (target_configured)
		{
			if (run_script_hash == 0) run_script_hash = wf_hash("RunScript");
			if (!ensure_run_script_observer())
			{
				config::log(
					"RENOVICE RunScript observer deferred after SWIG registry readiness");
			}
		}
	}
	reconcile_native_hook_contract("swig-ready-reconcile");
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
			reload_request_sequence.fetch_add(1, std::memory_order_acq_rel);
			conout << "RENOVICE F9 QUEUED source=GetAsyncKeyState" << std::endl;
			config::log("RENOVICE F9 QUEUED source=GetAsyncKeyState");
		}
	}
}

void request_reload(const char* source) noexcept
{
	if (!subsystem_enabled.load(std::memory_order_acquire)) return;
	const bool already_pending = f9_pending.exchange(true, std::memory_order_acq_rel);
	if (!already_pending)
	{
		reload_request_sequence.fetch_add(1, std::memory_order_acq_rel);
		std::string message = "RENOVICE reload QUEUED source=";
		message += source != nullptr ? source : "internal";
		conout << message << std::endl;
		config::log(message);
	}
}

bool reload_pending() noexcept
{
	return subsystem_enabled.load(std::memory_order_acquire)
		&& f9_pending.load(std::memory_order_acquire);
}

bool runtime_work_pending() noexcept
{
	return subsystem_enabled.load(std::memory_order_acquire)
		&& safe_runtime_transaction_should_run(
			f9_pending.load(std::memory_order_acquire),
			startup_pending.load(std::memory_order_acquire));
}

void drain(luau_State* state)
{
	if (observe_target_addons.load(std::memory_order_acquire)
		&& !run_script_native_hook_enabled)
	{
		bool have_configured_target_addon = false;
		{
			std::lock_guard lock(generation_mutex);
			have_configured_target_addon = target_chunks_configured_locked();
		}
		if (have_configured_target_addon && wf_hash != nullptr)
		{
			if (run_script_hash == 0)
			{
				run_script_hash = wf_hash("RunScript");
			}
			ensure_run_script_observer();
		}
	}
	reconcile_native_hook_contract("drain-reconcile");
	const auto log_deferred_reload = [](const char* reason)
	{
		if (!f9_pending.load(std::memory_order_acquire)) return;
		const auto sequence = reload_request_sequence.load(std::memory_order_acquire);
		if (sequence == last_drain_deferred_reload_sequence_logged
			&& reason == last_drain_deferred_reason)
		{
			return;
		}
		std::string message = "RENOVICE F9 DRAIN deferred reason=";
		message += reason;
		message += " sequence=" + std::to_string(sequence);
		config::log(message);
		last_drain_deferred_reload_sequence_logged = sequence;
		last_drain_deferred_reason = reason;
	};
	if (!subsystem_enabled.load(std::memory_order_acquire))
	{
		log_deferred_reload("subsystem-disabled");
		return;
	}
	if (!context_ready.load(std::memory_order_acquire))
	{
		log_deferred_reload("context-unavailable");
		return;
	}
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State)))
	{
		log_deferred_reload("state-unavailable");
		return;
	}
	if (state->global_state == nullptr
		|| state->global_state
			!= captured_global_state.load(std::memory_order_acquire))
	{
		log_deferred_reload("wrong-vm");
		return;
	}
	if (static_cast<std::uint32_t>(GetCurrentThreadId())
		!= captured_owner_thread.load(std::memory_order_acquire))
	{
		log_deferred_reload("wrong-owner-thread");
		return;
	}
	const auto lua_blocker = inspect_lua_mutation_boundary(state);
	if (lua_blocker != LuaMutationBoundaryBlocker::Ready)
	{
		log_deferred_reload(lua_mutation_boundary_label(lua_blocker));
		return;
	}
	if (execution_running.exchange(true, std::memory_order_acq_rel))
	{
		log_deferred_reload("transaction-already-running");
		return;
	}
	struct ExecutionReset
	{
		~ExecutionReset()
		{
			execution_running.store(false, std::memory_order_release);
		}
	} execution_reset;

	const bool reload = f9_pending.exchange(false, std::memory_order_acq_rel);
	const bool startup = startup_pending.exchange(false, std::memory_order_acq_rel);
	if (!idle_vm_generation_work_allowed(reload, startup))
	{
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
		script_control::discard_prepared_reload();
		swf::discard_prepared_reload();
		replacements::discard_prepared_reload();
		riven::discard_prepared_gate();
	};
	auto commit_prepared = [state]
	{
		config::commit_prepared_reload();
		if (!reconcile_process_fault_diagnostics())
		{
			conout << "RENOVICE diagnostics lifecycle reconcile FAIL" << std::endl;
			config::log("RENOVICE diagnostics lifecycle reconcile FAIL");
		}
		engine_damage::reset_budget();
		caster_stats_budget_used.store(0, std::memory_order_relaxed);
		caster_calculation_budget_used.store(0, std::memory_order_relaxed);
		caster_hud_budget_used.store(0, std::memory_order_relaxed);
        buff_native_stock_sequence.store(0, std::memory_order_relaxed);
        buff_native_observer_sequence.store(0, std::memory_order_relaxed);
        buff_native_stock_suppressed.store(false, std::memory_order_relaxed);
        buff_native_observer_suppressed.store(false, std::memory_order_relaxed);
        hud_native_stock_sequence.store(0, std::memory_order_relaxed);
        hud_native_observer_sequence.store(0, std::memory_order_relaxed);
        hud_native_stock_suppressed.store(false, std::memory_order_relaxed);
        hud_native_observer_suppressed.store(false, std::memory_order_relaxed);
		caster_stats_failure_logged.store(false, std::memory_order_relaxed);
		automatic_damage_failed_vms.clear(); // An explicit F9 commit permits a fresh attempt.
		addon_trace_sequence.store(0, std::memory_order_relaxed);
		addon_trace_suppression_logged.store(false, std::memory_order_relaxed);
		native_ingress_trace_sequence.store(0, std::memory_order_relaxed);
		native_ingress_trace_suppression_logged.store(false, std::memory_order_relaxed);
		automatic_damage_sequence.store(0, std::memory_order_relaxed);
		automatic_damage_budget_suppression_logged.store(
			false, std::memory_order_relaxed);
		automatic_damage_duplicate_suppression_logged.store(
			false, std::memory_order_relaxed);
		automatic_damage_runtime_failure_logged.store(
			false, std::memory_order_relaxed);
		diagnostic_trace_sequence.store(0, std::memory_order_relaxed);
		diagnostic_trace_suppression_logged.store(false, std::memory_order_relaxed);
		diagnostic_trace_install_failure_logged.store(false, std::memory_order_relaxed);
		diagnostic_trace_callback_failure_logged.store(false, std::memory_order_relaxed);
		const bool diagnostic_bridge_ready =
			reconcile_target_diagnostic_bridge_for_current_vm(state);
		if (!diagnostic_bridge_ready)
		{
			conout << "RENOVICE diagnostics bridge reconcile FAIL" << std::endl;
			config::diagnostic_log(
				"RENOVICE diagnostics bridge reconcile FAIL",
				config::DiagnosticsMode::errors);
		}
		if (universal_observer_requested(config::flags()))
		{
			if (!ensure_automatic_damage_runtime(
					state, captured_manager, captured_name_handle))
			{
				config::diagnostic_log(
					"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=F9-commit",
					config::DiagnosticsMode::errors);
			}
			else reset_automatic_damage_runtime(state);
		}
		else
		{
			if (!clear_automatic_damage_runtime(state))
			{
				config::log(
					"RENOVICE diagnostics lifecycle FAIL reason=automatic-runtime-root-release");
			}
			diagnostic_root_cleanup_pending.store(true, std::memory_order_release);
			if (!clear_diagnostic_module_roots_for_vm(state))
			{
				config::log(
					"RENOVICE diagnostics lifecycle FAIL reason=prototype-root-release");
			}
		}
		reconcile_native_hook_contract("F9-commit-reconcile");
		script_control::commit_prepared_reload();
		swf::commit_prepared_reload();
		replacements::commit_prepared_reload();
		riven::commit_prepared_gate();
	};

	bool transaction_valid = true;
	std::vector<Chunk> candidate;
	std::vector<std::uint64_t> candidate_target_keys;
	if (reload)
	{
		if (!config::prepare_reload())
		{
			conout << "RENOVICE F9 configuration reload rejected: previous flags retained" << std::endl;
			transaction_valid = false;
		}
		if (transaction_valid && !script_control::prepare_reload())
		{
			conout << "RENOVICE F9 script-state reload rejected: previous policy retained" << std::endl;
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
		if (transaction_valid
			&& !scan_snapshot(candidate, candidate_target_keys))
		{
			transaction_valid = false;
		}
		if (!transaction_valid) discard_prepared();
	}

	if (transaction_valid)
	{
		if (!reload && !scan_snapshot(candidate, candidate_target_keys))
		{
			transaction_valid = false;
		}
		if (transaction_valid
			&& apply_generation(
				candidate, candidate_target_keys,
				state, reload ? "F9" : "startup"))
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
	maintain_current_vm_generation(state);
}

bool drain_requested(luau_State* state)
{
	if (!reload_pending()) return false;
	drain(state);
	return !reload_pending();
}
}
