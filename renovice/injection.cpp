#include "injection.hpp"

#include "addon_transaction.hpp"
#include "config.hpp"
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

struct TargetExecutionSnapshot
{
	std::uint64_t generation = 0;
	std::vector<TargetExecutionIdentity> identities;
	struct Providers
	{
		std::uint64_t key;
		const luau_GlobalState* vm;
		std::vector<AddonRecord> addons;
		std::vector<std::string> native_methods;
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
	void* global_state = nullptr;
	std::uintptr_t script_resource_identity = 0;
	std::uintptr_t ability_identity = 0;
	std::uint32_t owner_thread = 0;
};

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
};

struct GuardState
{
	std::jmp_buf jump;
	volatile LONG active = 0;
	DWORD thread_id = 0;
	PVOID handler = nullptr;
	luau_State* state = nullptr;
	std::ptrdiff_t base_offset = 0;
	luau_TValue borrowed_original{};
	FieldFunction setfield = nullptr;
	char key[0x110]{};
	bool registry_may_be_shadowed = false;
	bool original_rooted = false;
	bool cleanup_attempted = false;
	int stage = 0;
	int fault_stage = 0;
	unsigned long fault_code = 0;
	void* fault_address = nullptr;
};

soup::DetourHook loader_hook;
soup::DetourHook vm_execute_hook;
KeyBuilder key_builder = nullptr;
FieldFunction getfield = nullptr;
FieldFunction setfield = nullptr;
ProtectedCall protected_call = nullptr;
bool injected_interrupt_contract_ready = false;
bool memory_evidence_layout_ready = false;
int protected_callback_call(luau_State* state, int arguments, int results, int error_handler, const char* label)
{
	if (!injected_interrupt_contract_ready || state == nullptr || protected_call == nullptr)
		return 2;
	// Keep the existing bounded watchdog. Inserted callbacks must not spend the
	// suspended stock coroutine's allowance on diagnostic or addon instructions.
	ScopedInjectedInterruptBudget budget(state->interrupt_count);
    // Read-only native accounting; bounded C++ reporting allocates no DE-Lua
    // objects and does not step/stop/restart the collector.
    struct MemoryObservation {
        luau_State* state;
        const char* label;
        bool enabled;
        std::uint64_t before = 0;
        static std::uint64_t total(luau_State* value) noexcept {
            std::uint64_t result = 0;
            std::memcpy(&result, reinterpret_cast<const char*>(value->global_state) + 0x48, sizeof(result));
            return result;
        }
        MemoryObservation(luau_State* value, const char* name)
            : state(value), label(name), enabled(value->global_state != nullptr
                && diagnostic_bridge_may_format(config::diagnostics_mode())) {
            if (enabled) before = total(state);
        }
        ~MemoryObservation() noexcept {
            if (!enabled) return;
            try {
                static std::atomic<std::uint64_t> counts[4]{};
                static std::atomic<std::uint64_t> positive_net[4]{};
                static std::atomic<std::uint64_t> negative_net[4]{};
                const std::string_view name = label == nullptr ? "unknown" : label;
                const unsigned lane = name == "casterStats.before" ? 0
                    : name == "casterAfter" ? 1
                    : name.starts_with("automaticDamage") ? 2 : 3;
                const auto after = total(state);
                const auto positive = after >= before ? after - before : 0;
                const auto negative = before > after ? before - after : 0;
                const auto positive_sum = positive_net[lane].fetch_add(positive) + positive;
                const auto negative_sum = negative_net[lane].fetch_add(negative) + negative;
                const auto count = counts[lane].fetch_add(1) + 1;
                if (count > 8 && (count & (count - 1)) != 0) return;
                std::ostringstream out;
                out << "RENOVICE VM_MEMORY build=V94 pid=" << GetCurrentProcessId()
                    << " vm=" << state->global_state << " tick_ms=" << GetTickCount64()
                    << " lane=" << lane << " label=" << name << " calls=" << count
                    << " lua_before=" << before << " lua_after=" << after
                    << " positive_net_sum=" << positive_sum << " negative_net_sum=" << negative_sum;
                config::diagnostic_log(out.str(),config::DiagnosticsMode::battle);
            } catch (...) { /* Read-only evidence cannot alter callback unwind. */ }
        }
    } memory(state,label);
	return protected_call(state, arguments, results, error_handler);
}
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
thread_local std::size_t vm_execution_depth = 0;
thread_local std::uint64_t active_target_execution_key = 0;
thread_local luau_GlobalState* active_target_execution_global_state = nullptr;
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
thread_local bool run_script_observer_active = false;
thread_local ActiveRunScriptBoundary active_run_script_boundary;
thread_local ActivePauseLoadBoundary active_pause_load_boundary;

struct ScopedRunScriptBoundary
{
	bool previous_observer_active = false;
	ActiveRunScriptBoundary previous_boundary;

	ScopedRunScriptBoundary(
		void* global_state,
		std::uintptr_t script_resource_identity,
		std::uintptr_t ability_identity,
		std::uint32_t owner_thread
	) noexcept
		: previous_observer_active(run_script_observer_active),
		previous_boundary(active_run_script_boundary)
	{
		run_script_observer_active = true;
		active_run_script_boundary = {
			true,
			global_state,
			script_resource_identity,
			ability_identity,
			owner_thread,
		};
	}

	~ScopedRunScriptBoundary()
	{
		active_run_script_boundary = previous_boundary;
		run_script_observer_active = previous_observer_active;
	}
};

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

struct ScopedVmExecutionDepth
{
	ScopedVmExecutionDepth() noexcept { ++vm_execution_depth; }
	~ScopedVmExecutionDepth() noexcept
	{
		if (vm_execution_depth != 0) --vm_execution_depth;
	}
};

struct ScopedTargetExecution
{
	std::uint64_t previous_key = 0;
	luau_GlobalState* previous_global_state = nullptr;

	ScopedTargetExecution(
		std::uint64_t target_key,
		luau_GlobalState* global_state
	) noexcept
		: previous_key(active_target_execution_key),
		previous_global_state(active_target_execution_global_state)
	{
		active_target_execution_key = target_key;
		active_target_execution_global_state = target_key != 0
			? global_state : nullptr;
	}

	~ScopedTargetExecution() noexcept
	{
		active_target_execution_key = previous_key;
		active_target_execution_global_state = previous_global_state;
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
		return lhs.name < rhs.name;
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
				{addon.addon}, {}, addon.requires_native_damage_adapters,
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
	}
	for (auto& entry : snapshot->providers)
	{
		std::sort(entry.addons.begin(), entry.addons.end(),
			[](const auto& a, const auto& b) { return a.name < b.name; });
		std::sort(entry.native_methods.begin(), entry.native_methods.end());
		entry.native_methods.erase(std::unique(
			entry.native_methods.begin(), entry.native_methods.end()),
			entry.native_methods.end());
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
	published_target_execution_snapshot.store(
		std::shared_ptr<const TargetExecutionSnapshot>(std::move(snapshot)),
		std::memory_order_release);
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
		const auto address = reinterpret_cast<std::uintptr_t>(closure->l.p);
		const auto proto = std::lower_bound(
			it->prototypes.begin(), it->prototypes.end(), address,
			[](const TargetProtoRecord& candidate, std::uintptr_t value)
			{
				return candidate.address < value;
			});
		if (it->global_state == state->global_state
			&& proto != it->prototypes.end() && proto->address == address)
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

TargetLuaCall target_lua_call_for_published_closure(
	luau_State* state,
	const luau_TValue& function
) noexcept
{
	TargetLuaCall selected;
	auto execution = acquire_target_execution_snapshot();
	const auto* snapshot = execution.snapshot.get();
	luau_Closure* closure = nullptr;
	if (snapshot == nullptr || state == nullptr || state->global_state == nullptr
		|| !readable_lua_closure(function, closure) || closure->isC)
	{
		return {};
	}
	const auto address = reinterpret_cast<std::uintptr_t>(closure->l.p);
	for (auto it = snapshot->identities.rbegin();
		it != snapshot->identities.rend(); ++it)
	{
		if (it->global_state != state->global_state) continue;
		const auto proto = std::lower_bound(
			it->prototypes.begin(), it->prototypes.end(), address,
			[](const TargetProtoRecord& candidate, std::uintptr_t value)
			{
				return candidate.address < value;
			});
		if (proto == it->prototypes.end() || proto->address != address) continue;
		if (selected.callsite.target_key != 0
			&& selected.callsite.target_key != it->target_key)
		{
			return {};
		}
		selected.callsite.target_key = it->target_key;
		selected.callsite.prototype = proto->bytecode_id;
		selected.callsite.exact = true;
		selected.closure = closure;
	}
	return selected;
}

bool target_lua_call_frame_active(
	luau_State* state,
	luau_Closure* target,
	bool& scan_valid
) noexcept
{
	scan_valid = false;
	if (state == nullptr || target == nullptr) return false;
	const auto current_call = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto base_call = reinterpret_cast<std::uintptr_t>(state->base_ci);
	constexpr std::size_t maximum_total_frames = 4096;
	if (!valid_target_call_stack_bounds(
		current_call, base_call, sizeof(luau_CallInfo), maximum_total_frames))
	{
		return false;
	}
	for (auto address = current_call;; address -= sizeof(luau_CallInfo))
	{
		auto* const frame = reinterpret_cast<luau_CallInfo*>(address);
		if (diagnostics::bad_read_ptr(frame, sizeof(luau_CallInfo)) || frame->func == nullptr
			|| diagnostics::bad_read_ptr(frame->func, sizeof(luau_TValue)))
		{
			return false;
		}
		if (is_function(frame->func->type)
			&& frame->func->value.as_uintptr
				== reinterpret_cast<std::uintptr_t>(target))
		{
			scan_valid = true;
			return true;
		}
		if (address == base_call) break;
		if (address < sizeof(luau_CallInfo)) return false;
	}
	scan_valid = true;
	return false;
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
		if (it->global_state == state->global_state
			&& target_addon_active_locked(it->target_key, state->global_state)
			&& std::any_of(it->prototypes.begin(), it->prototypes.end(),
				[&](const auto& proto) { return proto.address
					== reinterpret_cast<std::uintptr_t>(closure->l.p); }))
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
std::atomic<std::uint64_t> lua_after_skip_trace_sequence = 0;
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
						identity->instructions, info->savedpc, instruction))
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

std::string protected_call_error_details(
	luau_State* state,
	const luau_TValue* base
)
{
	std::ostringstream details;
	if (state == nullptr || state->stack == nullptr || state->outtop == nullptr
		|| base == nullptr
		|| state->outtop <= base)
	{
		details << " error_result=missing";
		return details.str();
	}

	const auto error = *base;
	append_error_value(details, "error", error);
	if (is_table(error.type) && getfield != nullptr && check_stack != nullptr)
	{
		static constexpr const char* fields[]{
			"message", "Message", "error", "Error", "what", "reason",
			"traceback", "stack", "source", "line",
		};
		const auto base_offset = luau_savestack(state, base);
		const auto saved_top_offset = luau_savestack(state, state->outtop);
		ScopedVmApiFrame frame_capacity(state);
		require_stack(state, 2);
		auto* const live_base = luau_restorestack(state, base_offset);
		state->outtop = live_base + 1;
		for (const char* const field : fields)
		{
			getfield(state, -1, field);
			if (state->outtop == live_base + 2
				&& (live_base + 1)->type != LUAU_NIL)
			{
				std::string label = "error_field_";
				label += field;
				append_error_value(details, label.c_str(), *(live_base + 1));
			}
			state->outtop = live_base + 1;
		}
		state->outtop = luau_restorestack(state, saved_top_offset);
	}
	return details.str();
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
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| protected_call == nullptr || !is_function(function.type)
		|| argument_count > static_cast<std::size_t>((std::numeric_limits<int>::max)()))
	{
		return false;
	}
	constexpr int traced_result_count = 8;
	const int requested_results = traced_results == nullptr ? 0 : traced_result_count;
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>((std::max)(
		argument_count + 2,
		static_cast<std::size_t>(requested_results + 2))));
	const auto base_offset = luau_savestack(state, state->outtop);
	push_stack_value(state, function);
	for (std::size_t i = 0; i != argument_count; ++i)
	{
		push_stack_value(state, arguments[i]);
	}
	const int status = protected_callback_call(
		state, static_cast<int>(argument_count), requested_results, 0, label);
	// A Lua callback may grow and relocate the stack, including on error.
	auto* const base = luau_restorestack(state, base_offset);
	if (status != 0)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label
			<< " pcall=" << status
			<< protected_call_error_details(state, base);
		trace_addon(state, 0, "pcall.error", failure.str());
		conout << failure.str() << std::endl;
		config::log(failure.str());
		state->outtop = base;
		return false;
	}
	if (traced_results != nullptr)
	{
		std::ostringstream results;
		results << "resultc=" << requested_results;
		if (state->outtop != base + requested_results)
		{
			results << " stack_resultc=" << (state->outtop - base);
		}
		const auto available = state->outtop > base
			? static_cast<std::size_t>(state->outtop - base) : 0;
		for (std::size_t i = 0;
			i < available && i < static_cast<std::size_t>(requested_results); ++i)
		{
			append_error_value(
				results, ("result" + std::to_string(i)).c_str(), base[i]);
		}
		*traced_results = results.str();
	}
	state->outtop = base;
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
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| protected_call == nullptr || !is_function(function.type)
		|| argument_count > static_cast<std::size_t>((std::numeric_limits<int>::max)()))
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>(argument_count + 2));
	const auto base_offset = luau_savestack(state, state->outtop);
	push_stack_value(state, function);
	for (std::size_t i = 0; i != argument_count; ++i)
	{
		push_stack_value(state, arguments[i]);
	}
	const int status = protected_callback_call(
		state, static_cast<int>(argument_count), 1, 0, label);
	auto* const base = luau_restorestack(state, base_offset);
	const bool result_is_boolean = status == 0
		&& state->outtop == base + 1 && base->type == LUAU_BOOL;
	if (result_is_boolean) output = base->value.as_bool != 0;
	if (status != 0 || !result_is_boolean)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (status != 0)
		{
			failure << " pcall=" << status
				<< protected_call_error_details(state, base);
		}
		else failure << " result=non-boolean";
		conout << failure.str() << std::endl;
		config::log(failure.str());
		state->outtop = base;
		return false;
	}
	state->outtop = base;
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
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| protected_call == nullptr || !is_function(function.type)
		|| argument_count > static_cast<std::size_t>((std::numeric_limits<int>::max)()))
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>(argument_count + 2));
	const auto base_offset = luau_savestack(state, state->outtop);
	push_stack_value(state, function);
	for (std::size_t i = 0; i != argument_count; ++i)
	{
		push_stack_value(state, arguments[i]);
	}
	const int status = protected_callback_call(
		state, static_cast<int>(argument_count), 1, 0, label);
	auto* const base = luau_restorestack(state, base_offset);
	const bool result_is_number = status == 0
		&& state->outtop == base + 1 && base->type == LUAU_NUMBER
		&& std::isfinite(base->value.as_float);
	if (result_is_number) output = base->value.as_float;
	if (!result_is_number)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (status != 0)
		{
			failure << " pcall=" << status
				<< protected_call_error_details(state, base);
		}
		else failure << " result=non-finite-or-non-number";
		conout << failure.str() << std::endl;
		config::log(failure.str());
		state->outtop = base;
		return false;
	}
	state->outtop = base;
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
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| protected_call == nullptr || !is_function(function.type)
		|| argument_count > static_cast<std::size_t>((std::numeric_limits<int>::max)()))
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>(argument_count + 2));
	const auto base_offset = luau_savestack(state, state->outtop);
	push_stack_value(state, function);
	for (std::size_t i = 0; i != argument_count; ++i)
	{
		push_stack_value(state, arguments[i]);
	}
	const int status = protected_callback_call(
		state, static_cast<int>(argument_count), 1, 0, label);
	auto* const base = luau_restorestack(state, base_offset);
	const bool result_has_identity = status == 0
		&& state->outtop == base + 1 && base->type != LUAU_NIL
		&& base->value.as_uintptr != 0;
	if (result_has_identity) output = *base;
	const int result_tag = state->outtop == base + 1
		? static_cast<int>(base->type) : -1;
	if (status != 0 || !result_has_identity)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (status != 0)
		{
			failure << " pcall=" << status
				<< protected_call_error_details(state, base);
		}
		else failure << " result=missing-identity tag=" << result_tag;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		state->outtop = base;
		return false;
	}
	state->outtop = base;
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
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| protected_call == nullptr || !is_function(function.type)
		|| argument_count > static_cast<std::size_t>((std::numeric_limits<int>::max)()))
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>(argument_count + 2));
	const auto base_offset = luau_savestack(state, state->outtop);
	push_stack_value(state, function);
	for (std::size_t i = 0; i != argument_count; ++i)
	{
		push_stack_value(state, arguments[i]);
	}
	const int status = protected_callback_call(
		state, static_cast<int>(argument_count), 1, 0, label);
	auto* const base = luau_restorestack(state, base_offset);
	const bool result_is_table = status == 0
		&& state->outtop == base + 1 && is_table(base->type);
	if (result_is_table) output = *base;
	const int result_tag = state->outtop == base + 1
		? static_cast<int>(base->type) : -1;
	if (status != 0 || !result_is_table)
	{
		std::ostringstream failure;
		failure << "RENOVICE hook callback FAIL label=" << label;
		if (status != 0)
		{
			failure << " pcall=" << status
				<< protected_call_error_details(state, base);
		}
		else failure << " result=non-table tag=" << result_tag;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		state->outtop = base;
		return false;
	}
	state->outtop = base;
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

void clear_scripts_settings_callbacks(luau_State* state)
{
	if (state == nullptr || state->outtop == nullptr || setfield == nullptr) return;
	auto* const base = state->outtop;
	if (!push_vm_global(state, "_T") || !is_table(base->type))
	{
		state->outtop = base;
		return;
	}
	luau_TValue nil{};
	nil.type = LUAU_NIL;
	table_set_value(state, -1, scripts_settings_elements_name, nil);
	table_set_value(state, -1, scripts_settings_native_elements_name, nil);
	table_set_value(state, -1, scripts_settings_changed_name, nil);
	table_set_value(state, -1, scripts_settings_done_name, nil);
	state->outtop = base;
}

bool table_set_array_value(
	luau_State* state,
	int table_index,
	std::size_t index,
	const luau_TValue& value
);

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

		const auto scripts = script_control::snapshot();
		config::log("RENOVICE Scripts settings inventory rows="
			+ std::to_string(scripts.size()));
		if (scripts.size() > 4096)
		{
			config::log("RENOVICE Scripts settings elements FAIL reason=row-limit");
			return 0;
		}
		ScopedVmApiFrame frame_capacity(state);
		require_stack(state, 40);
		auto* const base = state->outtop;
		luau_createtable(state, static_cast<int>(scripts.size()), 0);
		std::size_t row_index = 1;
		for (const auto& script : scripts)
		{
			luau_createtable(state, 0, 7);
			auto* const row_slot = state->outtop - 1;
			const std::string label = script_control::menu_display_name(
				script.kind, script.filename);
			std::string tooltip = script_control::kind_label(script.kind);
			if (!script.target.empty()) tooltip += " | target " + script.target;
			tooltip += " | " + script.status;
			if (!table_set_string(state, -1, "mLabel", label)
				|| !table_set_string(state, -1, "mRawName", script.id)
				|| !table_set_string(state, -1, "mSetting", script.id)
				|| !table_set_string(state, -1, "mTooltip", tooltip)
				|| !table_set_value(state, -1, "mType", control_type)
				|| !table_set_bool(state, -1, "mValue", script.enabled)
				|| !table_set_bool(state, -1, "mLocked", !script.valid))
			{
				state->outtop = base;
				config::log("RENOVICE Scripts settings elements FAIL reason=row-fields index="
					+ std::to_string(row_index));
				return 0;
			}
			const auto row = *row_slot;
			state->outtop = row_slot;
			if (!table_set_array_value(state, -1, row_index++, row))
			{
				state->outtop = base;
				config::log("RENOVICE Scripts settings elements FAIL reason=array-insert index="
					+ std::to_string(row_index));
				return 0;
			}
		}
		config::log("RENOVICE Scripts settings elements PASS rows="
			+ std::to_string(scripts.size()));
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
			|| state->outtop == nullptr || check_stack == nullptr
			|| luau_pushcclosurek == nullptr || setfield == nullptr)
		{
			return 0;
		}
		ScopedVmApiFrame frame_capacity(state);
		require_stack(state, 20);
		auto* const base = state->outtop;
		const auto parent_movie = dereference_upvalue(wrapper->c.upvals[0]);
		if (!is_userdata(parent_movie.type) || parent_movie.value.as_uintptr == 0)
		{
			config::log("RENOVICE Scripts settings open FAIL reason=captured-parent-mMovie");
			return 0;
		}
		config::log("RENOVICE Scripts settings parent movie PASS source=captured-upvalue");

		luau_TValue settings_resource{};
		if (!common_ui_movie_value(state, "UIMovie_GenericSettings", settings_resource))
		{
			config::log("RENOVICE Scripts settings open FAIL reason=UIMovie_GenericSettings");
			return 0;
		}
		if (!push_vm_global(state, "_T") || !is_table(base->type))
		{
			state->outtop = base;
			config::log("RENOVICE Scripts settings open FAIL reason=_T-table");
			return 0;
		}
		clear_scripts_settings_pending();
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
		luau_TValue bridge{};
		state->outtop = base;
		bool bridge_present = registry_scripts_bridge_value(state, bridge);
		if (!bridge_present)
		{
			// Compatibility fallback for pre-V26 bridge bytecode. New generations
			// keep the opener rooted in the VM registry so replacing _T cannot
			// make a second SCRIPTS click lose it.
			if (push_vm_global(state, "_T") && is_table(base->type))
			{
				bridge_present = push_hashed_table_field(
					state, -1, scripts_settings_bridge_name)
					&& state->outtop == base + 2
					&& is_function((base + 1)->type);
				if (bridge_present) bridge = *(base + 1);
			}
		}
		state->outtop = base;
		if (!bridge_present)
		{
			clear_scripts_settings_callbacks(state);
			config::log("RENOVICE Scripts settings open FAIL reason=lua-namecall-bridge-missing");
			return 0;
		}

		luau_TValue elements_name{};
		luau_TValue changed_name{};
		luau_TValue done_name{};
		if (!make_string_value(state, scripts_settings_elements_name, elements_name)
			|| !make_string_value(state, scripts_settings_changed_name, changed_name)
			|| !make_string_value(state, scripts_settings_done_name, done_name))
		{
			clear_scripts_settings_callbacks(state);
			config::log("RENOVICE Scripts settings open FAIL reason=bridge-arguments");
			return 0;
		}
		const luau_TValue bridge_arguments[]{
			parent_movie, settings_resource, elements_name, changed_name, done_name,
		};
		bool opened = false;
		if (!call_boolean_value(
			state, bridge, bridge_arguments, std::size(bridge_arguments),
			"ScriptsSettingsBridgeV10", opened) || !opened)
		{
			clear_scripts_settings_callbacks(state);
			config::log("RENOVICE Scripts settings open FAIL reason=lua-namecall-bridge");
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

bool append_scripts_menu(
	luau_State* state,
	const luau_TValue& stock_entries,
	const luau_TValue& parent_movie
)
{
	if (state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| luau_createtable == nullptr || luau_settable == nullptr
		|| luau_pushcclosurek == nullptr || luau_pushstring == nullptr
		|| !is_table(stock_entries.type)
		|| !is_userdata(parent_movie.type) || parent_movie.value.as_uintptr == 0)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 12);
	auto* const base = state->outtop;
	push_stack_value(state, stock_entries);
	const auto insertion_index = array_next_index(state, -1);

	luau_createtable(state, 0, 3);
	auto* const parent_slot = state->outtop - 1;
	if (!table_set_string(state, -1, "Name", "SCRIPTS")
		|| !table_set_string(state, -1, "Description",
			"Enable or disable RENOVICE Lua addons and replacements"))
	{
		state->outtop = base;
		return false;
	}

	push_stack_value(state, parent_movie);
	luau_pushcclosurek(
		state, &open_scripts_settings_callback,
		"RENOVICE open native Scripts settings", 1, nullptr);
	setfield(state, -2, "CallBack");
	const auto parent = *parent_slot;
	state->outtop = parent_slot;
	if (!table_set_array_value(state, -1, insertion_index, parent))
	{
		state->outtop = base;
		return false;
	}
	state->outtop = base;
	return true;
}

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
		ScopedVmApiFrame frame_capacity(state);
		require_stack(state, 4);
		auto* const capture_base = state->outtop;
		if (!push_environment_table(state, original_closure->env, capture_base))
		{
			state->outtop = capture_base;
			config::log("RENOVICE Scripts UI row append FAIL reason=dispatch-environment-table");
		}
		else
		{
			getfield(state, -1, "mMovie");
			const bool environment_is_table = is_table(capture_base->type);
			const bool movie_is_userdata = state->outtop == capture_base + 2
				&& is_userdata((capture_base + 1)->type)
				&& (capture_base + 1)->value.as_uintptr != 0;
			const auto parent_movie = movie_is_userdata
				? *(capture_base + 1) : luau_TValue{};
			state->outtop = capture_base;
			if (!pause_callback_movie_capture_ready(
				true, true, environment_is_table, movie_is_userdata))
			{
				config::log("RENOVICE Scripts UI row append FAIL reason=module-mMovie-capture");
			}
			else if (!append_scripts_menu(state, arguments.front(), parent_movie))
			{
				std::ostringstream failure;
				failure << "RENOVICE Scripts UI row append FAIL reason=menu-table-unavailable"
					<< " tag=" << arguments.front().type;
				config::log(failure.str());
			}
			else
			{
				appended = true;
				config::log("RENOVICE Scripts UI row append PASS owner=Initialize.U14.Builder.U58 parent_movie=captured");
			}
		}
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

bool lifecycle_hook_value(
	luau_State* state,
	const AddonRecord& addon,
	const char* hook_name,
	luau_TValue& output
)
{
	auto* const base = state->outtop;
	getfield(state, -10000, addon.registry_key.c_str());
	if (!is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "hooks");
	if (!is_table((base + 1)->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, hook_name);
	if (!is_function((base + 2)->type))
	{
		state->outtop = base;
		return false;
	}
	output = *(base + 2);
	state->outtop = base;
	return true;
}

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
							proto->instructions, call_info->savedpc, instruction))
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
											proto->instructions, info->savedpc, instruction);
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

bool install_target_hook_registry_dispatcher(
	luau_State* state,
	void* target_environment,
	std::uint64_t target_key)
{
	if (state == nullptr || state->outtop == nullptr || state->global_state == nullptr
		|| target_environment == nullptr || check_stack == nullptr
		|| luau_pushcclosurek == nullptr)
	{
		return false;
	}
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 6);
	auto* const base = state->outtop;
	if (!push_environment_table(state, target_environment, base)
		|| !is_table(base->type))
	{
		state->outtop = base;
		return false;
	}

	luau_pushcclosurek(
		state, &target_hook_registry_dispatcher,
		"RENOVICE target registry hook dispatcher", 0, nullptr);
	const auto dispatcher = *(base + 1);
	state->outtop = base + 1;
	if (!set_hashed_table_field(
			state, -1, target_hook_registry_dispatcher_name, dispatcher))
	{
		state->outtop = base;
		return false;
	}

	state->outtop = base + 1;
	const bool pushed = push_hashed_table_field(
		state, -1, target_hook_registry_dispatcher_name);
	luau_Closure* installed = nullptr;
	const bool pass = pushed && state->outtop == base + 2
		&& readable_lua_closure(*(base + 1), installed)
		&& installed->isC
		&& installed->c.func == &target_hook_registry_dispatcher;
	state->outtop = base;
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
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 6);
	auto* const base = state->outtop;
	// DE resolves `_T` through the VM's hashed-global path. It is not required
	// to be a direct string field on the borrowed closure environment. Reuse the
	// same lookup primitive already proven by the live card observer.
	if (!push_vm_global(state, "_T"))
	{
		state->outtop = base;
		return reject_once("shared-global-lookup-failed");
	}
	if (!is_table(base->type))
	{
		state->outtop = base;
		return reject_once("shared-global-not-table");
	}
	shared_table_identity = base->value.as_uintptr;
	getfield(state, -1, "RENOVICE_TRACE");
	luau_Closure* existing = nullptr;
	const bool field_present = (base + 1)->type != LUAU_NIL;
	const bool field_owned = field_present
		&& readable_lua_closure(*(base + 1), existing)
		&& existing->isC && existing->c.func == &diagnostic_trace_bridge;
	const bool can_mutate = setfield != nullptr
		&& (!diagnostics_enabled || luau_pushcclosurek != nullptr);
	const auto action = classify_diagnostic_bridge_action(
		diagnostics_enabled, field_present, field_owned, can_mutate);

	if (action == DiagnosticBridgeAction::leave_absent
		|| action == DiagnosticBridgeAction::leave_foreign_disabled)
	{
		if (!registry_root_required)
			(void)clear_diagnostic_trace_registry_root(state);
		state->outtop = base;
		return true;
	}
	if (action == DiagnosticBridgeAction::keep_owned)
	{
		const auto existing_value = *(base + 1);
		if (!write_diagnostic_trace_registry_root(state, existing_value))
		{
			state->outtop = base;
			return reject_once("diagnostic-registry-root-failed");
		}
		state->outtop = base;
		return true;
	}
	if (action == DiagnosticBridgeAction::reject_collision)
	{
		if (!registry_root_required)
			(void)clear_diagnostic_trace_registry_root(state);
		state->outtop = base;
		return reject_once("shared-field-collision");
	}
	if (action == DiagnosticBridgeAction::reject_prerequisite)
	{
		if (!registry_root_required)
			(void)clear_diagnostic_trace_registry_root(state);
		state->outtop = base;
		return reject_once("diagnostic-prerequisite-unavailable");
	}
	if (action == DiagnosticBridgeAction::remove_owned)
	{
		if (preserve_owned_bridge)
		{
			state->outtop = base;
			return true;
		}
		if (!registry_root_required)
			(void)clear_diagnostic_trace_registry_root(state);
		state->outtop = base + 1;
		luau_TValue nil{};
		nil.type = LUAU_NIL;
		if (!table_set_value(state, -1, "RENOVICE_TRACE", nil))
		{
			state->outtop = base;
			return reject_once("shared-field-remove-failed");
		}
		state->outtop = base + 1;
		getfield(state, -1, "RENOVICE_TRACE");
		const bool removed = (base + 1)->type == LUAU_NIL;
		state->outtop = base;
		if (!removed) return reject_once("shared-field-remove-readback-mismatch");
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
		lua_after_skip_trace_sequence.store(0, std::memory_order_relaxed);
		config::diagnostic_log(
			"RENOVICE trace bridge removed", config::DiagnosticsMode::trace);
		return true;
	}

	state->outtop = base + 1;
	luau_pushcclosurek(
		state, &diagnostic_trace_bridge,
		"RENOVICE exact-pipeline trace", 0, nullptr);
	setfield(state, -2, "RENOVICE_TRACE");

	state->outtop = base + 1;
	getfield(state, -1, "RENOVICE_TRACE");
	luau_Closure* installed = nullptr;
	const bool pass = readable_lua_closure(*(base + 1), installed)
		&& installed->isC && installed->c.func == &diagnostic_trace_bridge;
	const auto installed_value = *(base + 1);
	state->outtop = base;
	if (!pass)
	{
		return reject_once("readback-mismatch");
	}
	if (!write_diagnostic_trace_registry_root(state, installed_value))
	{
		state->outtop = base + 1;
		luau_TValue nil{};
		nil.type = LUAU_NIL;
		(void)table_set_value(state, -1, "RENOVICE_TRACE", nil);
		state->outtop = base;
		return reject_once("diagnostic-registry-root-failed");
	}

	diagnostic_trace_sequence.store(0, std::memory_order_relaxed);
	diagnostic_trace_suppression_logged.store(false, std::memory_order_relaxed);
	diagnostic_trace_install_failure_logged.store(false, std::memory_order_relaxed);
	diagnostic_trace_callback_failure_logged.store(false, std::memory_order_relaxed);
	addon_trace_sequence.store(0, std::memory_order_relaxed);
	addon_trace_suppression_logged.store(false, std::memory_order_relaxed);
	native_ingress_trace_sequence.store(0, std::memory_order_relaxed);
	native_ingress_trace_suppression_logged.store(false, std::memory_order_relaxed);
	lua_after_skip_trace_sequence.store(0, std::memory_order_relaxed);
	std::ostringstream success;
	success << "RENOVICE trace bridge PASS key=" << std::hex << target_key
		<< std::dec << " vm=" << state->global_state
		<< " env=" << environment
		<< " shared=0x" << std::hex << shared_table_identity << std::dec;
	config::diagnostic_log(success.str(), config::DiagnosticsMode::trace);
	return true;
}

bool inspect_current_shared_table(
	luau_State* state,
	std::uintptr_t& shared_table_identity,
	bool& scripts_bridge_present
)
{
	shared_table_identity = 0;
	scripts_bridge_present = false;
	if (state == nullptr || state->outtop == nullptr || getfield == nullptr
		|| check_stack == nullptr)
	{
		return false;
	}

	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 4);
	auto* const base = state->outtop;
	if (!push_vm_global(state, "_T") || !is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	shared_table_identity = base->value.as_uintptr;
	if (scripts_ui_enabled.load(std::memory_order_acquire))
	{
		scripts_bridge_present = push_hashed_table_field(
			state, -1, scripts_settings_bridge_name)
			&& state->outtop == base + 2 && is_function((base + 1)->type);
	}
	state->outtop = base;
	return shared_table_identity != 0;
}

bool read_target_card_values(
	luau_State* state,
	const luau_TValue& original,
	luau_TValue (&arguments)[2]
)
{
	luau_Closure* original_closure = nullptr;
	if (!readable_lua_closure(original, original_closure)
		|| original_closure->isC || original_closure->env == nullptr)
	{
		return false;
	}
	auto* const base = state->outtop;
	if (!push_environment_table(state, original_closure->env, base)) return false;
	getfield(state, -1, "_T");
	if (!is_table((base + 1)->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "AbilityUpgradeLevelInfo");
	if (!is_table((base + 2)->type))
	{
		state->outtop = base;
		return false;
	}
	arguments[0] = *(base + 2);
	state->outtop = base + 2;
	getfield(state, -1, "AbilityLevelQueryParms");
	arguments[1] = *(base + 2);
	state->outtop = base;
	return is_table(arguments[1].type);
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
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!call_value(
		state, original, arguments.data(), arguments.size(),
		"original.GetAbilityUpgradeLevelInfo"))
	{
		return 0;
	}
	luau_TValue card_arguments[2]{};
	if (generation_dispatch
		&& read_target_card_values(state, original, card_arguments))
	{
		dispatch_target_hook(
			state, target_key, "afterAbilityCard", card_arguments, 2);
	}
	return 0;
}

// Result remains rooted on the Lua stack until the caller restores its top.
// All constructor/association operations execute through a real protected frame.
bool call_callback_runtime(luau_State* state, std::uint64_t key,
	const char* method, const luau_TValue (&arguments)[2], luau_TValue& result)
{
	result = {};
	if (!state || !state->outtop || !check_stack || !getfield || !protected_call)
		return false;
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 6);
	getfield(state, -10000, callback_runtime_registry_key.c_str());
	if (!is_table(state->outtop[-1].type))
	{
		state->outtop = luau_restorestack(state, base_offset);
		trace_addon(state, key, "damage.factory.reject", "reason=runtime-not-loaded");
		return false;
	}
	getfield(state, -1, method);
	if (!is_function(state->outtop[-1].type))
	{
		state->outtop = luau_restorestack(state, base_offset);
		trace_addon(state, key, "damage.factory.reject", "reason=missing-method");
		return false;
	}
	push_stack_value(state, arguments[0]);
	push_stack_value(state, arguments[1]);
	const int status = protected_callback_call(state, 2, 1, 0, "DamageData.copy");
	auto* base = luau_restorestack(state, base_offset);
	if (status != 0)
	{
		trace_addon(state, key, "damage.factory.error", std::string("method=") + method
			+ " pcall=" + std::to_string(status) + protected_call_error_details(state, base + 1));
		state->outtop = luau_restorestack(state, base_offset);
		return false;
	}
	if (state->outtop != base + 2)
	{
		state->outtop = base;
		trace_addon(state, key, "damage.factory.reject", "reason=result-count");
		return false;
	}
	result = base[1];
	trace_addon(state, key, "damage.factory.return", std::string("method=") + method);
	return true;
}

bool set_damage_callback_protected(luau_State* state, std::uint64_t key,
	const luau_TValue& receiver, const luau_TValue& callback)
{
	luau_Closure* closure = nullptr;
	if (!readable_lua_closure(callback, closure) || closure->isC)
	{
		trace_addon(state, key, "damage.install.reject", "reason=callback-not-lua");
		return false;
	}
	const auto native = set_damage_callback_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(set_damage_callback_native_hook.original)
		: original_set_damage_callback;
	if (!native || !luau_pushcclosurek) return false;
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 6);
	luau_pushcclosurek(state, native, "RENOVICE protected SetDamageCallback", 0, nullptr);
	const auto setter = state->outtop[-1];
	const luau_TValue arguments[]{receiver, callback};
	trace_addon(state, key, "damage.install.native-enter", "callback_isC=0 protected=1", arguments, 2);
	const bool passed = call_value(state, setter, arguments, 2, "SetDamageCallback.install");
	state->outtop = luau_restorestack(state, base_offset);
	trace_addon(state, key, "damage.install.native-return", std::string("status=") + (passed ? "ok" : "error"));
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
	bool passed = call_callback_runtime(state, target_key, "prepareSource", arguments, callback)
		&& set_damage_callback_protected(state, target_key, receiver, callback);
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
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return original(state);
	if (state == nullptr || !target_snapshot_requests_native_damage(
		state->global_state))
	{
		return original(state);
	}
	AddonTraceScope trace_scope;
	AddonDetailScope detail_scope(addon_trace_attempt <= 4 || addon_trace_attempt % 128 == 0);
	trace_addon(state, 0, "source.enter", {}, state ? state->intop : nullptr,
		state && state->intop ? static_cast<std::size_t>(luau_gettop(state)) : 0);
	log_native_hook_once(state, 0, "SetSourceObject.detour-entry");
	luau_TValue receiver{};
	luau_TValue source_ability{};
	const bool arguments_valid = state != nullptr && state->intop != nullptr
		&& luau_gettop(state) >= 2;
	if (arguments_valid)
	{
		receiver = state->intop[0];
		source_ability = state->intop[1];
	}
	std::uint64_t target_key = 0;
	// Native calls require actual caller evidence, not a broad VM execution scope.
	if (target_key == 0)
	{
		target_key = target_key_for_active_call_stack(state);
		if (target_key != 0)
		{
			log_native_hook_once(
				state, target_key, "SetSourceObject.targetCallStack.match");
		}
	}
	trace_addon(state, target_key, "source.native-enter");
	const int result_count = original != nullptr ? original(state) : 0;
	trace_addon(state, target_key, "source.native-return",
		"results=" + std::to_string(result_count));
	if (!arguments_valid || result_count != 0)
	{
		trace_addon(state, target_key, "source.reject", "reason=arguments-or-native-results");
		return result_count;
	}

	if (target_key == 0)
	{
		target_key = target_key_for_matcher(
			state, source_ability, "matchesDamageSource");
	}
	if (target_key == 0)
	{
		trace_addon(state, 0, "source.reject", "reason=no-exact-target");
		log_native_hook_once(state, 0, "SetSourceObject.target.missing");
		return result_count;
	}
	log_native_hook_once(state, target_key, "SetSourceObject.target.match");
	if (install_addon_damage_callback(
		state, target_key, receiver, source_ability))
	{
		log_native_hook_once(state, target_key, "SetSourceObject.attachDamageCallback");
		trace_addon(state, target_key, "source.attach-return");
	}
	else trace_addon(state, target_key, "source.attach-failed");
	trace_addon(state, target_key, "source.return");
	return result_count;
}

int set_damage_callback_adapter(luau_State* state)
{
	const auto original = set_damage_callback_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(set_damage_callback_native_hook.original)
		: original_set_damage_callback;
	if (original == nullptr) return 0;
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return original(state);
	if (state == nullptr || !target_snapshot_requests_native_damage(
		state->global_state))
	{
		return original(state);
	}
	AddonTraceScope trace_scope;
	log_native_hook_once(state, 0, "SetDamageCallback.detour-entry");
	const bool valid = state && state->intop && luau_gettop(state) >= 2;
	const luau_TValue arguments[]{valid ? state->intop[0] : luau_TValue{},
		valid ? state->intop[1] : luau_TValue{}};
	std::uint64_t target_key = 0;
	if (valid)
	{
		target_key = target_key_for_published_closure(state, arguments[1]);
		if (!target_key) target_key = target_key_for_active_call_stack(state);
	}
	// First perform the exact stock request. A failed optional decoration must
	// leave this callback installed, not change its argument to a C closure.
	const int result_count = original ? original(state) : 0;
	if (!valid || result_count != 0 || !target_key) return result_count;
	const auto base_offset = luau_savestack(state, state->outtop);
	luau_TValue callback{}, ignored{};
	if (call_callback_runtime(state, target_key, "commitOriginal", arguments, ignored)
		&& call_callback_runtime(state, target_key, "prepareOriginal", arguments, callback))
	{
		if (callback.value.as_uintptr == arguments[1].value.as_uintptr)
			trace_addon(state, target_key, "damage.stock.deferred", "reason=no-source-association stock-preserved=1");
		else if (set_damage_callback_protected(state, target_key, arguments[0], callback))
			trace_addon(state, target_key, "damage.stock.attached", "stock-preserved=1");
		else trace_addon(state, target_key, "damage.stock.attach-failed", "stock-preserved=1");
	}
	state->outtop = luau_restorestack(state, base_offset);
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

// The VM execution hook is inside a stock Lua frame. Execute inserted Lua API
// work through a real protected C frame; changing L->base alone would be undone
// by nested pcall and would misrepresent the parent's register window.
struct LuaCallPhaseContext {
    luau_State* state;
    const TargetLuaCall* call;
    const char* phase;
    std::vector<luau_TValue>* arguments;
    std::ptrdiff_t stock_base_offset;
    int stock_argument_count;
    const char* argument_root_key;
    bool* argument_root_created;
    bool result = false;
};
thread_local LuaCallPhaseContext* lua_call_phase_context = nullptr;

bool dispatch_lua_call_phase_impl(
	luau_State* state,
	const TargetLuaCall& call,
	const char* phase,
	std::vector<luau_TValue>& arguments
)
{
	if (lua_call_hook_running) return true;
	if (!call.callsite.exact || call.closure == nullptr || call.closure->isC
		|| state == nullptr || state->outtop == nullptr || check_stack == nullptr
		|| luau_createtable == nullptr || phase == nullptr)
	{
		return false;
	}
	const auto& providers = hook_addons_snapshot(
		call.callsite.target_key, state->global_state);
	if (providers.empty()) return true;
	struct ScopedLuaCallHook
	{
		ScopedLuaCallHook() noexcept { lua_call_hook_running = true; }
		~ScopedLuaCallHook() noexcept { lua_call_hook_running = false; }
	} hook_scope;
	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;

	std::vector<luau_TValue> stock_upvalues;
	stock_upvalues.reserve(call.closure->nupvalues);
	for (std::size_t index = 0; index != call.closure->nupvalues; ++index)
	{
		auto* const slot = writable_upvalue_slot(call.closure, index);
		if (slot == nullptr) return false;
		stock_upvalues.push_back(*slot);
	}

	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 12);
	luau_createtable(state, static_cast<int>(arguments.size()), 0);
	for (std::size_t index = 0; index != arguments.size(); ++index)
	{
		if (!table_set_array_value(state, -1, index + 1, arguments[index]))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	const auto arguments_table_offset = luau_savestack(state, state->outtop - 1);
	// Copies in a C++ vector are not GC roots. Stock execution can release its
	// argument registers before the after hook runs; keep the snapshot alive.
	if (std::string_view(phase) == "before" && lua_call_phase_context != nullptr)
	{
		push_stack_value(state, state->outtop[-1]);
		setfield(state, -10000, lua_call_phase_context->argument_root_key);
		*lua_call_phase_context->argument_root_created = true;
	}
	luau_createtable(state, static_cast<int>(stock_upvalues.size()), 0);
	for (std::size_t index = 0; index != stock_upvalues.size(); ++index)
	{
		if (!table_set_array_value(state, -1, index + 1, stock_upvalues[index]))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	const auto upvalues_table_offset = luau_savestack(state, state->outtop - 1);

	bool invoked = false;
	for (const auto& addon : providers)
	{
		luau_TValue callback{};
		if (!lua_call_hook_value(
				state, addon, call.callsite.prototype, phase, callback))
		{
			continue;
		}
		invoked = true;
		luau_TValue callback_arguments[4]{};
		callback_arguments[0].type = LUAU_NUMBER;
		callback_arguments[0].value.as_float =
			static_cast<float>(call.callsite.prototype);
		callback_arguments[1] = *luau_restorestack(state, arguments_table_offset);
		callback_arguments[2] = *luau_restorestack(state, upvalues_table_offset);
		callback_arguments[lua_provider_trace_argument_index()] =
			target_diagnostic_trace_callback_value(
				state, call.callsite.target_key);
		const std::string label = "luaCalls."
			+ std::to_string(call.callsite.prototype) + '.' + phase;
		if (!call_value(
				state, callback, callback_arguments,
				lua_provider_callback_argument_count(), label.c_str()))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	if (!invoked)
	{
		state->outtop = luau_restorestack(state, base_offset);
		return true;
	}

	const bool before_phase = std::string_view(phase) == "before";
	std::vector<luau_TValue> transformed_arguments(arguments.size());
	for (std::size_t index = 0; index != transformed_arguments.size(); ++index)
	{
		state->outtop = luau_restorestack(state, arguments_table_offset) + 1;
		if (!table_get_array_value(
				state, -1, index + 1, transformed_arguments[index]))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
		if (!same_lua_value(arguments[index], transformed_arguments[index])
			&& !target_lua_argument_mutation_allowed(
				before_phase,
				arguments[index].type,
				transformed_arguments[index].type,
				transformed_arguments[index].type == LUAU_NUMBER
					&& std::isfinite(transformed_arguments[index].value.as_float)))
		{
			std::ostringstream failure;
			failure << "RENOVICE luaCalls mutation rejected key=0x" << std::hex
				<< call.callsite.target_key << std::dec
				<< " prototype=" << call.callsite.prototype
				<< " phase=" << phase << " argument=" << (index + 1)
				<< " original_tag=" << arguments[index].type
				<< " candidate_tag=" << transformed_arguments[index].type;
			config::log(failure.str());
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}

	std::vector<luau_TValue> transformed_upvalues(stock_upvalues.size());
	for (std::size_t index = 0; index != transformed_upvalues.size(); ++index)
	{
		state->outtop = luau_restorestack(state, upvalues_table_offset) + 1;
		if (!table_get_array_value(
				state, -1, index + 1, transformed_upvalues[index]))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
		if (!same_lua_value(stock_upvalues[index], transformed_upvalues[index])
			&& !target_lua_scalar_mutation_allowed(
				stock_upvalues[index].type,
				transformed_upvalues[index].type,
				transformed_upvalues[index].type == LUAU_NUMBER
					&& std::isfinite(transformed_upvalues[index].value.as_float)))
		{
			std::ostringstream failure;
			failure << "RENOVICE luaCalls mutation rejected key=0x" << std::hex
				<< call.callsite.target_key << std::dec
				<< " prototype=" << call.callsite.prototype
				<< " phase=" << phase << " upvalue=" << (index + 1)
				<< " original_tag=" << stock_upvalues[index].type
				<< " candidate_tag=" << transformed_upvalues[index].type;
			config::log(failure.str());
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	state->outtop = luau_restorestack(state, base_offset);
	if (before_phase)
	{
		const auto* context = lua_call_phase_context;
		const int live_argument_count = context != nullptr ? context->stock_argument_count : -1;
		if (live_argument_count < 0
			|| static_cast<std::size_t>(live_argument_count) != arguments.size()
			|| context->state != state)
		{
			return false;
		}
	}
	std::vector<luau_TValue*> transformed_upvalue_slots(
		transformed_upvalues.size(), nullptr);
	for (std::size_t index = 0; index != transformed_upvalues.size(); ++index)
	{
		if (same_lua_value(stock_upvalues[index], transformed_upvalues[index])) continue;
		transformed_upvalue_slots[index] = writable_upvalue_slot(call.closure, index);
		if (transformed_upvalue_slots[index] == nullptr)
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	for (std::size_t index = 0; index != transformed_upvalues.size(); ++index)
	{
		if (transformed_upvalue_slots[index] == nullptr) continue;
		*transformed_upvalue_slots[index] = transformed_upvalues[index];
	}
	if (before_phase)
	{
		for (std::size_t index = 0; index != transformed_arguments.size(); ++index)
		{
			if (same_lua_value(arguments[index], transformed_arguments[index])) continue;
			luau_restorestack(state, lua_call_phase_context->stock_base_offset)[index] = transformed_arguments[index];
			arguments[index] = transformed_arguments[index];
		}
	}
	state->outtop = luau_restorestack(state, base_offset);
	const std::string event = "luaCalls."
		+ std::to_string(call.callsite.prototype) + '.' + phase;
	log_native_hook_once(state, call.callsite.target_key, event.c_str());
	return true;
}

int protected_lua_call_phase_callback(luau_State* state)
{
    auto* context = lua_call_phase_context;
    if (context == nullptr || context->state != state) return 0;
    context->result = dispatch_lua_call_phase_impl(
        state, *context->call, context->phase, *context->arguments);
    return 0;
}

bool dispatch_lua_call_phase(
    luau_State* state, const TargetLuaCall& call, const char* phase,
    std::vector<luau_TValue>& arguments, const char* argument_root_key, bool* argument_root_created)
{
    if (lua_call_hook_running) return true;
    if (state == nullptr || state->stack == nullptr || state->intop == nullptr
        || state->outtop == nullptr || check_stack == nullptr || getfield == nullptr
        || setfield == nullptr || luau_pushcclosurek == nullptr || protected_call == nullptr)
        return false;
    LuaCallPhaseContext context{state, &call, phase, &arguments,
        luau_savestack(state, state->intop), luau_gettop(state), argument_root_key, argument_root_created};
    const auto top_offset = luau_savestack(state, state->outtop);
    ScopedVmApiFrame frame_capacity(state);
    // Only two slots in the stock frame. The provider's tables and callbacks
    // execute in the VM-created C frame, whose base/CallInfo agree throughout GC.
    if (!check_stack(state, 2)) {
        config::log("RENOVICE VM_FRAME build=V95 event=host-frame-entry-rejected slots=2 stock-frame-preserved=1");
        return false;
    }
    static constexpr const char* registry_key = "RENOVICE_LuaCallHostFrame_V95";
    getfield(state, -10000, registry_key);
    luau_Closure* closure = nullptr;
    if (!readable_lua_closure(state->outtop[-1], closure) || !closure->isC
        || closure->c.func != &protected_lua_call_phase_callback) {
        state->outtop = luau_restorestack(state, top_offset);
        luau_pushcclosurek(state, &protected_lua_call_phase_callback,
            "RENOVICE protected Lua-call host frame", 0, nullptr);
        push_stack_value(state, state->outtop[-1]);
        setfield(state, -10000, registry_key); // keep one copy as the callable
    }
    struct ScopedContext {
        LuaCallPhaseContext* previous;
        explicit ScopedContext(LuaCallPhaseContext* value) noexcept
            : previous(lua_call_phase_context) { lua_call_phase_context = value; }
        ~ScopedContext() noexcept { lua_call_phase_context = previous; }
    } context_scope(&context);
    const int status = protected_callback_call(state, 0, 0, 0, "luaCalls.host-frame");
    // Native pcall leaves its error at the saved call slot. Decode it before
    // restoring top; querying error-table fields here could throw another error.
    if (status != 0) {
        static std::atomic<std::uint64_t> errors = 0;
        const auto sequence = errors.fetch_add(1, std::memory_order_relaxed) + 1;
        if (sample_vm_host_error(sequence)) {
            try {
                std::ostringstream out;
                out << "RENOVICE VM_FRAME build=V96 event=host-callback-error pid="
                    << GetCurrentProcessId() << " vm=" << state->global_state
                    << " thread=" << GetCurrentThreadId() << " tick_ms=" << GetTickCount64()
                    << " key=0x" << std::hex << call.callsite.target_key << std::dec
                    << " prototype=" << call.callsite.prototype << " phase=" << phase
                    << " pcall=" << status << " occurrence=" << sequence;
                const auto* error = luau_restorestack(state, top_offset);
                if (state->outtop != nullptr && state->outtop > error)
                    append_error_value(out, "error", *error);
                else out << " error_result=missing";
                out << " stock-frame-restored-on-return=1";
                config::log(out.str());
            } catch (...) { config::log("RENOVICE VM_FRAME build=V96 event=host-error-format-failed stock-recovery-retained=1"); }
        } else if (sequence == 9) {
            config::log("RENOVICE VM_FRAME build=V96 event=host-error-suppression after=8 policy=powers-of-two decoded-context-retained=1");
        }
    }
    state->intop = luau_restorestack(state, context.stock_base_offset);
    state->outtop = luau_restorestack(state, top_offset);
    return status == 0 && context.result;
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

	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 12);
	luau_createtable(state, static_cast<int>(arguments.size()), 0);
	for (std::size_t i = 0; i != arguments.size(); ++i)
	{
		if (!table_set_array_value(state, -1, i + 1, arguments[i]))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	const auto arguments_table_offset = luau_savestack(
		state, state->outtop - 1);
	std::ptrdiff_t results_table_offset = 0;
	if (results != nullptr)
	{
		luau_createtable(state, static_cast<int>(results->size()), 0);
		for (std::size_t i = 0; i != results->size(); ++i)
		{
			if (!table_set_array_value(state, -1, i + 1, (*results)[i]))
			{
				state->outtop = luau_restorestack(state, base_offset);
				return false;
			}
		}
		results_table_offset = luau_savestack(state, state->outtop - 1);
	}

	bool invoked = false;
	for (const auto& addon : providers)
	{
		luau_TValue callback{};
		if (!native_call_hook_value(
				state, addon, method_name, phase, callback))
		{
			continue;
		}
		invoked = true;
		const bool after_phase = results != nullptr;
		luau_TValue callback_arguments[5]{};
		callback_arguments[0].type = LUAU_NUMBER;
		callback_arguments[0].value.as_float =
			static_cast<float>(callsite.prototype);
		callback_arguments[1].type = LUAU_NUMBER;
		callback_arguments[1].value.as_float =
			static_cast<float>(callsite.instruction);
		callback_arguments[2] = *luau_restorestack(
			state, arguments_table_offset);
		const std::size_t callback_argument_count =
			native_provider_callback_argument_count(after_phase);
		if (results != nullptr)
		{
			callback_arguments[3] = *luau_restorestack(
				state, results_table_offset);
		}
		callback_arguments[native_provider_trace_argument_index(after_phase)] =
			target_diagnostic_trace_callback_value(
				state, callsite.target_key);
		const std::string label = std::string("nativeCalls.")
			+ method_name + '.' + phase;
		const std::string provider_detail = std::string("method=") + method_name
			+ " phase=" + phase + " addon=" + addon.name
			+ " registry=" + addon.registry_key;
		trace_addon(
			state, callsite.target_key, "native.call.provider.enter", provider_detail);
		if (!call_value(
				state, callback, callback_arguments,
				callback_argument_count, label.c_str()))
		{
			trace_addon(
				state, callsite.target_key, "native.call.provider.error", provider_detail);
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
		trace_addon(
			state, callsite.target_key, "native.call.provider.return", provider_detail);
	}
	if (!invoked)
	{
		state->outtop = luau_restorestack(state, base_offset);
		return true;
	}

	const auto table_offset = results == nullptr
		? arguments_table_offset : results_table_offset;
	auto& transformed = results == nullptr ? arguments : *results;
	for (std::size_t i = 0; i != transformed.size(); ++i)
	{
		state->outtop = luau_restorestack(state, table_offset) + 1;
		luau_TValue value{};
		if (!table_get_array_value(state, -1, i + 1, value))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
		transformed[i] = value;
	}
	state->outtop = luau_restorestack(state, base_offset);
	return true;
}

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
	auto* const base = luau_restorestack(state, base_offset);
	if (!is_table(base->type))
	{
		state->outtop = base;
		return false;
	}
	getfield(state, -1, method);
	auto* const live_base = luau_restorestack(state, base_offset);
	const bool valid = is_function((live_base + 1)->type);
	if (valid) output = *(live_base + 1);
	state->outtop = live_base;
	return valid;
}

bool call_automatic_damage_runtime_before(
	luau_State* state,
	const DiagnosticDamageCallsite& source,
	const std::vector<luau_TValue>& arguments,
	const config::Flags& flags,
	float& transaction)
{
	transaction = 0;
	if (automatic_damage_runtime_running || state == nullptr
		|| state->outtop == nullptr || check_stack == nullptr
		|| luau_createtable == nullptr
		|| arguments.size() > static_cast<std::size_t>(
			(std::numeric_limits<int>::max)()))
	{
		return false;
	}
	luau_TValue callback{};
	luau_TValue trace{};
	if (!automatic_damage_runtime_method(state, "before", callback)
		|| !read_diagnostic_trace_registry_root(state, trace))
	{
		return false;
	}

	struct ScopedAutomaticRuntime
	{
		ScopedAutomaticRuntime() noexcept { automatic_damage_runtime_running = true; }
		~ScopedAutomaticRuntime() noexcept { automatic_damage_runtime_running = false; }
	} runtime_scope;

	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>((std::max)(
		arguments.size() * 2 + 12,
		static_cast<std::size_t>(16))));
	luau_createtable(state, static_cast<int>(arguments.size()), 0);
	for (std::size_t index = 0; index != arguments.size(); ++index)
	{
		if (!table_set_array_value(state, -1, index + 1, arguments[index]))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	auto* const base = luau_restorestack(state, base_offset);
	luau_TValue callback_arguments[5]{};
	callback_arguments[0] = trace;
	callback_arguments[1].type = LUAU_NUMBER;
	callback_arguments[1].value.as_float =
		static_cast<float>(source.callsite.prototype);
	callback_arguments[2].type = LUAU_NUMBER;
	callback_arguments[2].value.as_float =
		static_cast<float>(source.callsite.instruction);
	callback_arguments[3] = *base;
	if (flags.diagnostics_damage_type_filter_set)
	{
		callback_arguments[4].type = LUAU_NUMBER;
		callback_arguments[4].value.as_float =
			static_cast<float>(flags.diagnostics_damage_type);
	}
	else callback_arguments[4].type = LUAU_NIL;
	const bool passed = call_number_value(
		state, callback, callback_arguments, std::size(callback_arguments),
		"automaticDamage.before", transaction);
	state->outtop = luau_restorestack(state, base_offset);
	return passed;
}

bool call_automatic_damage_runtime_after(
	luau_State* state,
	float transaction,
	const std::vector<luau_TValue>& results,
	const char* method = "after")
{
	if (automatic_damage_runtime_running || transaction <= 0
		|| !std::isfinite(transaction) || state == nullptr
		|| state->outtop == nullptr || check_stack == nullptr
		|| luau_createtable == nullptr
		|| results.size() > static_cast<std::size_t>(
			(std::numeric_limits<int>::max)()))
	{
		return false;
	}
	luau_TValue callback{};
	if (!automatic_damage_runtime_method(state, method, callback)) return false;

	struct ScopedAutomaticRuntime
	{
		ScopedAutomaticRuntime() noexcept { automatic_damage_runtime_running = true; }
		~ScopedAutomaticRuntime() noexcept { automatic_damage_runtime_running = false; }
	} runtime_scope;

	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>((std::max)(
		results.size() * 2 + 8,
		static_cast<std::size_t>(12))));
	luau_createtable(state, static_cast<int>(results.size()), 0);
	for (std::size_t index = 0; index != results.size(); ++index)
	{
		if (!table_set_array_value(state, -1, index + 1, results[index]))
		{
			state->outtop = luau_restorestack(state, base_offset);
			return false;
		}
	}
	auto* const base = luau_restorestack(state, base_offset);
	luau_TValue callback_arguments[2]{};
	callback_arguments[0].type = LUAU_NUMBER;
	callback_arguments[0].value.as_float = transaction;
	callback_arguments[1] = *base;
	const bool passed = call_value(
		state, callback, callback_arguments, std::size(callback_arguments),
		method);
	state->outtop = luau_restorestack(state, base_offset);
	return passed;
}

std::atomic<std::uint64_t> caster_stats_sequence{0};
std::atomic<std::uint64_t> caster_stats_budget_used{0};
std::atomic<std::uint64_t> caster_calculation_budget_used{0};
std::atomic<std::uint64_t> caster_hud_budget_used{0};
std::atomic<bool> caster_stats_failure_logged{false};

bool call_caster_stats_before(luau_State* state, float id, const std::string& method,
	const std::vector<luau_TValue>& arguments, float& snapshot)
{
	snapshot = 0;
	if (automatic_damage_runtime_running || state == nullptr || state->outtop == nullptr
		|| check_stack == nullptr || luau_createtable == nullptr || luau_pushstring == nullptr
		|| arguments.size() > 1024) return false;
	luau_TValue callback{}, trace{};
	if (!automatic_damage_runtime_method(state, "casterBefore", callback)
		|| !read_diagnostic_trace_registry_root(state, trace)) return false;
	struct Scope {
		Scope() { automatic_damage_runtime_running = true; }
		~Scope() { automatic_damage_runtime_running = false; }
	} scope;
	const auto offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, static_cast<int>(arguments.size() * 2 + 16));
	luau_createtable(state, static_cast<int>(arguments.size()), 0);
	for (std::size_t index = 0; index != arguments.size(); ++index) {
		if (!table_set_array_value(state, -1, index + 1, arguments[index])) {
			state->outtop = luau_restorestack(state, offset); return false;
		}
	}
	luau_TValue values[5]{};
	values[4].type = LUAU_BOOL; values[4].value.as_bool = config::flags().diagnostics_buffs;
	values[0] = trace;
	values[1].type = LUAU_NUMBER; values[1].value.as_float = id;
	values[3] = *luau_restorestack(state, offset);
	if (luau_pushstring(state, method.c_str()) == nullptr) {
		state->outtop = luau_restorestack(state, offset); return false;
	}
	values[2] = *(state->outtop - 1);
	const bool passed = call_number_value(state, callback, values, std::size(values),
		"casterStats.before", snapshot);
	state->outtop = luau_restorestack(state, offset);
	return passed;
}

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

int native_call_adapter(luau_State* state, std::size_t slot)
{
	std::unique_lock hook_lock(native_call_hook_mutex);
	if (slot >= native_call_hooks.size() || native_call_hooks[slot] == nullptr)
	{
		return 0;
	}
	const auto& record = *native_call_hooks[slot];
	const auto original = record.hook.isCreated()
		? reinterpret_cast<luau_CFunction>(record.hook.original)
		: record.target;
	if (original == nullptr) return 0;
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return original(state);
	const auto flags = config::flags();
	const auto* global_state = state == nullptr
		? nullptr : state->global_state;
	if (native_call_hook_running
		|| (!diagnostics_claims_native_method(flags, record.name)
			&& !any_target_provider_claims_native_method(
				global_state, record.name)))
	{
		return original(state);
	}
	TargetCallsite callsite;
	DiagnosticDamageCallsite diagnostic_source;
	const auto buff_probe = begin_native_buff_probe(flags, record.name, slot, state);
	if (state != nullptr)
	{
		if (observe_target_addons.load(std::memory_order_acquire))
			callsite = target_callsite_for_active_call_stack(state);
		if (universal_observer_requested(flags))
			diagnostic_source = diagnostic_damage_callsite_for_active_stack(state);
	}
	trace_native_call_ingress(
		state, slot, record, original, callsite, native_call_hook_running);
	engine_damage::Source native_source;
	native_source.body = diagnostic_source.callsite.target_key;
	native_source.prototype = diagnostic_source.callsite.prototype;
	native_source.instruction = diagnostic_source.callsite.instruction;
	native_source.vm = state == nullptr ? nullptr : state->global_state;
	native_source.path = diagnostic_source.module_path;
	native_source.name = diagnostic_source.module_name;
	native_source.method = record.name;
	engine_damage::SourceScope native_source_scope(
		flags.diagnostics_damage_capture == config::DamageCaptureMode::engine
			? &native_source : nullptr);
	if (native_call_hook_running || state == nullptr || state->intop == nullptr
		|| state->outtop == nullptr)
	{
		log_native_buff_probe(buff_probe, "selection", "stock-only-reentrant-or-invalid-frame", state);
		const int returned = original(state);
		log_native_buff_probe(buff_probe, "return", "stock-only", state, returned);
		return returned;
	}
	const int argument_count = luau_gettop(state);
	if (argument_count < 0) return original(state);
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
	const bool caster_selected = observer_capacity && flags.diagnostics_caster_stats
		&& automatic_scripted_damage_requested(flags)
		&& !automatic_damage_runtime_running
		&& (record.name == "SetSource" || record.name == "DamageDD"
			|| record.name == "RadialDamage" || record.name == "ModifyValue"
			|| record.name == "GetUpgradeModifiedValue")
		&& flags.diagnostics_addon.empty()
		&& (!flags.diagnostics_target_filter_set || (flags.diagnostics_target_filter_valid
			&& diagnostic_source.callsite.target_key == flags.diagnostics_target_key))
		&& (flags.diagnostics_damage_source.empty()
			|| config::ascii_lower(diagnostic_source.module_path) == flags.diagnostics_damage_source
			|| config::ascii_lower(diagnostic_source.module_name) == flags.diagnostics_damage_source)
		&& (record.name == "SetSource" || record.name == "ModifyValue"
			|| record.name == "GetUpgradeModifiedValue"
			|| flags.diagnostics_method.empty()
			|| config::ascii_lower(record.name) == flags.diagnostics_method)
		&& (record.name != "DamageDD" || flags.diagnostics_damage_target_type.empty()
			|| config::ascii_lower(target_type) == flags.diagnostics_damage_target_type);
	bool automatic_selected = observer_capacity && arguments.size() >= 2
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
    // Observe the stock native getter's returned list, never clear it or change
    // its entries. This shared HUD lane includes effects created by native code.
    const bool buffs_selected = observer_capacity && universal_buffs_requested(flags)
        && !automatic_damage_runtime_running
        && (record.name == "GetBuffNotifications" || record.name == "GetHudStatus")
        && flags.diagnostics_addon.empty()
        && (!flags.diagnostics_target_filter_set || (flags.diagnostics_target_filter_valid
            && diagnostic_source.callsite.target_key == flags.diagnostics_target_key))
        && (flags.diagnostics_method.empty() || flags.diagnostics_method == config::ascii_lower(record.name))
        && (flags.diagnostics_damage_source.empty()
            || config::ascii_lower(diagnostic_source.module_path) == flags.diagnostics_damage_source
            || config::ascii_lower(diagnostic_source.module_name) == flags.diagnostics_damage_source);
    const char* buff_selection_reason = buffs_selected ? "buff-observer-selected"
        : automatic_damage_runtime_running ? "observer-self-call"
        : !flags.diagnostics_addon.empty() ? "addon-filter"
        : flags.diagnostics_target_filter_set && (!flags.diagnostics_target_filter_valid
            || diagnostic_source.callsite.target_key != flags.diagnostics_target_key) ? "body-filter"
        : !flags.diagnostics_method.empty() && flags.diagnostics_method != config::ascii_lower(record.name) ? "method-filter"
        : !flags.diagnostics_damage_source.empty() ? "source-filter" : "capture-not-requested";
    log_native_buff_probe(buff_probe, "selection", buff_selection_reason, state);
    if (!provider_selected && !automatic_selected && !caster_selected && !buffs_selected) {
        const int returned = original(state);
        log_native_buff_probe(buff_probe, "return", "stock-only-filtered", state, returned);
        return returned;
    }

	struct ScopedNativeCallHook
	{
		ScopedNativeCallHook() noexcept { native_call_hook_running = true; }
		~ScopedNativeCallHook() noexcept { native_call_hook_running = false; }
	} hook_scope;

	if (provider_selected)
	{
		std::ostringstream before_details;
		before_details << "method=" << record.name
			<< " phase=before prototype=" << callsite.prototype
			<< " instruction=" << callsite.instruction
			<< " values=arguments";
		trace_addon(
			state, callsite.target_key, "native.call.before", before_details.str(),
			arguments.data(), arguments.size());
		if (dispatch_native_call_phase(
				state, callsite, record.name.c_str(), "before", arguments, nullptr))
		{
			state->intop = luau_restorestack(state, argument_base_offset);
			state->outtop = luau_restorestack(state, argument_top_offset);
			prepare_stack_write(state);
			std::copy(arguments.begin(), arguments.end(), state->intop);
		}
		else
		{
			state->intop = luau_restorestack(state, argument_base_offset);
			state->outtop = luau_restorestack(state, argument_top_offset);
			prepare_stack_write(state);
			std::copy(stock_arguments.begin(), stock_arguments.end(), state->intop);
			arguments = stock_arguments;
			trace_addon(state, callsite.target_key, "native.call.before.reject",
				"method=" + record.name + " stock_arguments_restored=1");
		}
	}

	std::uint64_t automatic_sequence_value = 0;
	float automatic_transaction = 0;
	if (automatic_selected)
	{
		automatic_sequence_value = automatic_damage_sequence.fetch_add(
			1, std::memory_order_relaxed) + 1;
		const auto transaction_budget = (std::max)(
			std::uint64_t{1}, (std::min)(
				std::uint64_t{4096}, flags.diagnostics_max_events / 10));
		if (automatic_sequence_value > transaction_budget)
		{
			automatic_selected = false;
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
	if (automatic_selected)
	{
		ScopedAutomaticDamageTraceContext automatic_context(
			automatic_sequence_value, diagnostic_source, target_type);
		if (!call_automatic_damage_runtime_before(
				state, diagnostic_source, arguments, flags,
				automatic_transaction)
			&& !automatic_damage_runtime_failure_logged.exchange(
				true, std::memory_order_relaxed))
		{
			config::diagnostic_log(
				"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=before",
				config::DiagnosticsMode::errors);
		}
	}

	float caster_snapshot = 0;
	if (caster_selected || buffs_selected) {
        // Queue getters run at the game's existing HUD update boundary. Empty
        // lists must not consume the combat snapshot budget. The Lua pending
        // entry roots the receiver before stock may overwrite its argument slot.
        const auto lane = caster_diagnostic_lane(record.name);
        const bool calculation = lane == CasterDiagnosticLane::calculation;
        auto& budget = lane == CasterDiagnosticLane::hud ? caster_hud_budget_used
            : calculation ? caster_calculation_budget_used : caster_stats_budget_used;
        const auto used = budget.fetch_add(1, std::memory_order_relaxed) + 1;
		const auto limit = caster_diagnostic_limit(lane, flags.diagnostics_max_events);
		if (used <= limit) {
			const auto id = caster_stats_sequence.fetch_add(1, std::memory_order_relaxed) + 1;
			if (id <= 16777215) {
				ScopedAutomaticDamageTraceContext context(id, diagnostic_source, target_type);
				if (!call_caster_stats_before(state, static_cast<float>(id), record.name, arguments, caster_snapshot)
					&& !caster_stats_failure_logged.exchange(true))
					config::diagnostic_log("RENOVICE CASTER_STATS build=V82 event=failed phase=before", config::DiagnosticsMode::errors);
			} else if (id == 16777216) {
                config::diagnostic_log("RENOVICE CASTER_STATS build=V86 event=suppressed reason=exact-float-id-exhausted", config::DiagnosticsMode::errors);
            }
		} else if (used == limit + 1) {
			config::diagnostic_log(std::string("RENOVICE CASTER_STATS build=V88 event=suppressed lane=")
                + (lane == CasterDiagnosticLane::hud ? "hud" : calculation ? "calculation" : "combat") + " reason=snapshot-budget-exhausted limit="
				+ std::to_string(limit), config::DiagnosticsMode::battle);
		}
		log_native_buff_probe(buff_probe, "observer-before", caster_snapshot > 0
            ? "callback-pending-root-ready" : "callback-unavailable-or-rejected", state);
	}
	native_source.caster_snapshot = std::isfinite(caster_snapshot) && caster_snapshot > 0
		? static_cast<std::uint64_t>(caster_snapshot) : 0;
	// Diagnostic callbacks may grow the VM stack. Restore the authoritative
	// native argument frame before calling stock, just as the addon phase does.
	state->intop = luau_restorestack(state, argument_base_offset);
	state->outtop = luau_restorestack(state, argument_top_offset);
	const int result_count = original(state);
	log_native_buff_probe(buff_probe, "return", "stock-result-before-observer", state, result_count);
	std::vector<luau_TValue> results;
	bool results_valid = false;
	if (result_count >= 0 && state->outtop >= state->intop + result_count)
	{
		results_valid = true;
		const auto result_base_offset = luau_savestack(
			state, state->outtop - result_count);
		const auto result_top_offset = luau_savestack(state, state->outtop);
		results.assign(
			state->outtop - result_count, state->outtop);
		if (caster_snapshot > 0) {
			const auto result_intop_offset = luau_savestack(state, state->intop);
			ScopedAutomaticDamageTraceContext context(static_cast<std::uint64_t>(caster_snapshot), diagnostic_source, target_type);
			if (!call_automatic_damage_runtime_after(state, caster_snapshot, results, "casterAfter")
				&& !caster_stats_failure_logged.exchange(true))
				config::diagnostic_log("RENOVICE CASTER_STATS build=V82 event=failed phase=after", config::DiagnosticsMode::errors);
			state->intop = luau_restorestack(state, result_intop_offset);
			state->outtop = luau_restorestack(state, result_top_offset);
			log_native_buff_probe(buff_probe, "observer-after", "callback-returned", state);
		}
		if (automatic_transaction > 0)
		{
			ScopedAutomaticDamageTraceContext automatic_context(
				automatic_sequence_value, diagnostic_source, target_type);
			if (!call_automatic_damage_runtime_after(
					state, automatic_transaction, results)
				&& !automatic_damage_runtime_failure_logged.exchange(
					true, std::memory_order_relaxed))
			{
				config::diagnostic_log(
					"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=after",
					config::DiagnosticsMode::errors);
			}
		}
		if (provider_selected)
		{
			std::ostringstream after_details;
			after_details << "method=" << record.name
				<< " phase=after prototype=" << callsite.prototype
				<< " instruction=" << callsite.instruction
				<< " values=results";
			trace_addon(
				state, callsite.target_key, "native.call.after", after_details.str(),
				results.data(), results.size());
			if (dispatch_native_call_phase(
					state, callsite, record.name.c_str(), "after", arguments, &results))
			{
				state->outtop = luau_restorestack(state, result_top_offset);
				prepare_stack_write(state);
				std::copy(results.begin(), results.end(),
					luau_restorestack(state, result_base_offset));
			}
			else
			{
				state->outtop = luau_restorestack(state, result_top_offset);
				trace_addon(state, callsite.target_key, "native.call.after.reject",
					"method=" + record.name + " stock_results_retained=1");
			}
		}
	}
	else if (automatic_transaction > 0)
	{
		ScopedAutomaticDamageTraceContext automatic_context(
			automatic_sequence_value, diagnostic_source, target_type);
		if (!call_automatic_damage_runtime_after(
				state, automatic_transaction, results)
			&& !automatic_damage_runtime_failure_logged.exchange(
				true, std::memory_order_relaxed))
		{
			config::diagnostic_log(
				"RENOVICE AUTO_DAMAGE build=V79 event=runtime-failure phase=after-invalid-results",
				config::DiagnosticsMode::errors);
		}
	}
	hook_lock.unlock();
	if (provider_selected)
	{
		const std::string event = std::string("nativeCalls.") + record.name;
		std::ostringstream details;
		details << "method=" << record.name
			<< " prototype=" << callsite.prototype
			<< " instruction=" << callsite.instruction
			<< " arguments=" << argument_count
			<< " results=" << result_count
			<< " results_valid=" << (results_valid ? 1 : 0);
		log_native_hook_once(state, callsite.target_key, event.c_str());
		trace_addon(state, callsite.target_key, "native.call.return", details.str());
	}
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
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return original(state);
	if (state == nullptr || !target_snapshot_requests_native_callsite(
		state->global_state))
	{
		return original(state);
	}
	if (float_argument_transform_running || state == nullptr || state->intop == nullptr
		|| luau_gettop(state) < 2 || state->intop[1].type != LUAU_NUMBER)
	{
		return original(state);
	}

	const auto callsite = target_callsite_for_active_call_stack(state);
	if (!callsite.exact) return original(state);
	const auto& providers = hook_addons_snapshot(
		callsite.target_key, state->global_state);
	if (providers.empty()) return original(state);

	struct ScopedTransform
	{
		ScopedTransform() { float_argument_transform_running = true; }
		~ScopedTransform() { float_argument_transform_running = false; }
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
			state, callsite.target_key, "PushFloatArg.instruction-transform");
		std::ostringstream details;
		details << "prototype=" << callsite.prototype
			<< " instruction=" << callsite.instruction
			<< " stock=" << stock_value << " transformed=" << transformed_value;
		trace_addon(state, callsite.target_key, "native.float.transform", details.str());
	}
	return original(state);
}

int run_script_observer_adapter(luau_State* state)
{
	const auto original = run_script_native_hook.isCreated()
		? reinterpret_cast<luau_CFunction>(run_script_native_hook.original)
		: original_run_script;
	if (original == nullptr) return 0;
	auto generation_dispatch = generation_dispatch_gate.try_dispatch();
	if (!generation_dispatch) return original(state);

	const bool enabled = observe_target_addons.load(std::memory_order_acquire);
	const bool reentrant = run_script_observer_active;
	const int argument_count = state != nullptr && state->intop != nullptr
		&& state->outtop != nullptr ? luau_gettop(state) : 0;
	const bool synchronous_flag_is_boolean = argument_count == 4
		&& state->intop[3].type == LUAU_BOOL;
	const bool synchronous_flag = synchronous_flag_is_boolean
		&& state->intop[3].value.as_bool != 0;
	const bool binding_candidate = run_script_target_binding_candidate(
		enabled,
		argument_count < 0 ? 0 : static_cast<std::size_t>(argument_count),
		synchronous_flag_is_boolean,
		synchronous_flag,
		argument_count >= 2 ? state->intop[1].value.as_uintptr : 0);
	const auto entry_sequence = enabled && !reentrant
		? run_script_entry_sequence.fetch_add(1, std::memory_order_acq_rel) + 1 : 0;
	const auto candidate_sequence = enabled && !reentrant
		&& argument_count == 4 && synchronous_flag_is_boolean && synchronous_flag
		? run_script_candidate_sequence.fetch_add(1, std::memory_order_acq_rel) + 1 : 0;
	AbilityCardQueryObservation query;
	const bool query_is_table = enabled && !reentrant && argument_count == 4
		&& synchronous_flag_is_boolean && synchronous_flag
		&& read_ability_card_query(state, query);
	const auto decision = classify_run_script_observation(
		enabled, reentrant,
		argument_count < 0 ? 0 : static_cast<std::size_t>(argument_count),
		synchronous_flag_is_boolean, synchronous_flag,
		query_is_table, query.has_ability);
	if (enabled && !reentrant && should_sample_run_script_entry(
		entry_sequence, candidate_sequence,
		argument_count < 0 ? 0 : static_cast<std::size_t>(argument_count),
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
		entry << " sync_bool=" << (synchronous_flag_is_boolean ? 1 : 0)
			<< " sync=" << (synchronous_flag ? 1 : 0)
			<< " query_table=" << (query_is_table ? 1 : 0)
			<< " ability=" << (query.has_ability ? 1 : 0)
			<< " decision=" << static_cast<unsigned int>(decision);
		conout << entry.str() << std::endl;
		config::log(entry.str());
	}
	if (decision != RunScriptObservationDecision::ObserveAbilityCard)
	{
		if (binding_candidate)
		{
			ScopedRunScriptBoundary scoped_binding(
				state->global_state,
				state->intop[1].value.as_uintptr,
				0,
				static_cast<std::uint32_t>(GetCurrentThreadId()));
			return original(state);
		}
		return original(state);
	}

	std::uint32_t argument_tags[4]{};
	std::uintptr_t argument_values[4]{};
	for (std::size_t i = 0; i != 4; ++i)
	{
		argument_tags[i] = state->intop[i].type;
		argument_values[i] = state->intop[i].value.as_uintptr;
	}
	const auto sequence = run_script_observation_sequence.fetch_add(
		1, std::memory_order_acq_rel) + 1;
	auto* const before_global_state = state->global_state;
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	ScopedRunScriptBoundary scoped_observer(
		before_global_state, argument_values[1], query.ability_identity, owner_thread);

	std::ostringstream before;
	before << "RENOVICE card query OBSERVE phase=before seq=" << sequence
		<< " vm=" << before_global_state << " thread=" << owner_thread
		<< " args=" << argument_count
		<< " tags=" << argument_tags[0] << ',' << argument_tags[1] << ','
		<< argument_tags[2] << ',' << argument_tags[3]
		<< " values=" << reinterpret_cast<void*>(argument_values[0]) << ','
		<< reinterpret_cast<void*>(argument_values[1]) << ','
		<< reinterpret_cast<void*>(argument_values[2]) << ','
		<< reinterpret_cast<void*>(argument_values[3])
		<< " query_tag=" << query.query_tag
		<< " query=" << reinterpret_cast<void*>(query.query_identity)
		<< " ability_tag=" << query.ability_tag
		<< " ability=" << reinterpret_cast<void*>(query.ability_identity)
		<< " modded_tag=" << (query.modded_is_boolean ? LUAU_BOOL : LUAU_NIL)
		<< " modded=" << (query.modded ? 1 : 0)
		<< " level=" << (query.level_is_number ? query.level : -1.0f);
	conout << before.str() << std::endl;
	config::log(before.str());

	const int result_count = original(state);
	std::uint32_t result_tag = LUAU_NIL;
	std::uintptr_t result_identity = 0;
	luau_TValue result_value{};
	const bool result_is_table = read_ability_card_result(
		state, result_tag, result_identity, result_value);
	const auto target_key = result_is_table
		? target_key_for_ability(state, query.ability_value) : 0;
	if (target_key != 0)
	{
		remember_target_script_binding(target_key, state);
	}
	const auto result = classify_run_script_observation_result(
		result_count, result_is_table);
	std::uintptr_t published_identity = 0;
	bool card_published = false;
	if (result == RunScriptObservationResult::Complete && target_key != 0)
	{
		card_published = dispatch_ability_card_hooks(
			state, target_key, result_value, query.query_value,
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
	after << "RENOVICE card query OBSERVE phase=after seq=" << sequence
		<< " vm=" << state->global_state << " thread=" << owner_thread
		<< " same_vm=" << (before_global_state == state->global_state ? 1 : 0)
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

void restore_lua_top() noexcept
{
	if (guard.state != nullptr && guard_base() != nullptr
		&& !IsBadWritePtr(&guard.state->outtop, sizeof(guard.state->outtop)))
	{
		guard.state->outtop = guard_base();
	}
}

bool try_restore_registry_after_fault() noexcept
{
	if (!guard.registry_may_be_shadowed || guard.cleanup_attempted
		|| guard.state == nullptr || guard_base() == nullptr || guard.setfield == nullptr)
	{
		return !guard.registry_may_be_shadowed;
	}
	if (IsBadWritePtr(guard_base(), sizeof(luau_TValue))
		|| IsBadWritePtr(&guard.state->outtop, sizeof(guard.state->outtop)))
	{
		return false;
	}
	guard.cleanup_attempted = true;
	guard.active = 1;
	guard.stage = 6;
	prepare_stack_write(guard.state);
	*guard_base() = guard.borrowed_original;
	guard.state->outtop = guard_base() + 1;
	guard.setfield(guard.state, -10000, guard.key);
	guard.registry_may_be_shadowed = false;
	guard.state->outtop = guard_base();
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
	const std::uint32_t* name_handle,
	const char* lifecycle_key,
	bool pass_global_argument,
	bool use_borrowed_closure_environment
)
{
	RunResult result;
	if (state == nullptr || manager == nullptr || descriptor == nullptr
		|| name_handle == nullptr || diagnostics::bad_read_ptr(name_handle, sizeof(std::uint32_t) * 2)
		|| diagnostics::bad_read_ptr(state, sizeof(luau_State)) || state->outtop == nullptr
		|| check_stack == nullptr)
	{
		return result;
	}

	// check_stack may relocate the VM stack. Capture the relocation-safe offset after
	// it completes; all later loader/pcall and recovery addresses are recomputed.
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 8);
	std::memset(&guard, 0, sizeof(guard));
	guard.state = state;
	guard.base_offset = luau_savestack(state, state->outtop);
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
	key_builder(guard.key, 0x104, const_cast<std::uint32_t*>(name_handle));

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
	if (use_borrowed_closure_environment)
	{
		const bool borrowed_is_function = is_function(guard.borrowed_original.type);
		const bool closure_readable = guard.borrowed_original.value.as_uintptr != 0
			&& !diagnostics::bad_read_ptr(reinterpret_cast<void*>(
				guard.borrowed_original.value.as_uintptr), offsetof(luau_Closure, c.func));
		auto* closure = closure_readable ? reinterpret_cast<luau_Closure*>(
			guard.borrowed_original.value.as_uintptr) : nullptr;
		const bool environment_readable = closure != nullptr
			&& closure->env != nullptr && !diagnostics::bad_read_ptr(closure->env, 0x10);
		if (!valid_target_closure_environment(
			borrowed_is_function, closure_readable, environment_readable))
		{
			guard.stage = 6;
			prepare_stack_write(guard.state);
			*guard_base() = guard.borrowed_original;
			state->outtop = guard_base() + 1;
			setfield(state, -10000, guard.key);
			guard.registry_may_be_shadowed = false;
			restore_lua_top();
			finish_guard();
			result.registry_restored = true;
			result.protected_call_result = -4;
			return result;
		}
		result.borrowed_environment = closure->env;
		result.exact_environment_used = true;
		*reinterpret_cast<void**>(reinterpret_cast<unsigned char*>(descriptor) + 0x58)
			= closure->env;
	}
	else if (pass_global_argument)
	{
		// Ordinary Inject/addon chunks retain the established VM-global behavior.
		getfield(state, -10002, "_G");
		if (is_table(guard_base()->type))
		{
			*reinterpret_cast<void**>(reinterpret_cast<unsigned char*>(descriptor) + 0x58)
				= reinterpret_cast<void*>(guard_base()->value.as_uintptr);
		}
		state->outtop = guard_base();
	}

	guard.stage = 3;
	const bool loader_pass = reinterpret_cast<Loader>(loader_hook.original)(manager, descriptor);
	state->outtop = guard_base() + 1;
	if (!loader_pass)
	{
		guard.stage = 6;
		prepare_stack_write(guard.state);
		*guard_base() = guard.borrowed_original;
		state->outtop = guard_base() + 1;
		setfield(state, -10000, guard.key);
		guard.registry_may_be_shadowed = false;
		restore_lua_top();
		finish_guard();
		result.registry_restored = true;
		result.protected_call_result = -3;
		return result;
	}

	guard.stage = 4;
	getfield(state, -10000, guard.key);
	result.closure_tag = (guard_base() + 1)->type;
	if (!is_function(result.closure_tag))
	{
		guard.stage = 6;
		prepare_stack_write(guard.state);
		*guard_base() = guard.borrowed_original;
		state->outtop = guard_base() + 1;
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
	if (result.protected_call_result == 0 && lifecycle_key != nullptr)
	{
		if (!is_table(result.result_tag))
		{
			result.protected_call_result = -1;
		}
		else
		{
			guard.stage = 7;
			prepare_stack_write(state);
			*guard_base() = *(guard_base() + 1);
			state->outtop = guard_base() + 1;
			setfield(state, -10000, lifecycle_key);
			result.lifecycle_stored = true;

			state->outtop = guard_base();
			getfield(state, -10000, lifecycle_key);
			getfield(state, -1, "activate");
			const bool activate_valid = is_function((guard_base() + 1)->type);
			state->outtop = guard_base() + 1;
			getfield(state, -1, "cleanup");
			const bool cleanup_valid = is_function((guard_base() + 1)->type);
			bool hook_contract_valid = true;
			if (use_borrowed_closure_environment)
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
				set_registry_nil(state, guard_base(), lifecycle_key);
				result.lifecycle_stored = false;
				result.protected_call_result = -2;
			}
		}
	}

	guard.stage = 6;
	prepare_stack_write(guard.state);
	*guard_base() = guard.borrowed_original;
	state->outtop = guard_base() + 1;
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
	std::lock_guard execution_lock(lua_execution_mutex);
	ScopedExecutionDepth execution_depth;
	const char* operation = field == nullptr ? "release" : field;
	auto log_failure = [&](const char* reason)
	{
		std::ostringstream failure;
		failure << "RENOVICE addon lifecycle FAIL " << addon.name
			<< " field=" << operation << " reason=" << reason;
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
	// Establish capacity before the guard captures its top offset. Later stack
	// relocation is handled by guard_base during normal and fault cleanup.
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 4);
	std::memset(&guard, 0, sizeof(guard));
	guard.state = state;
	guard.base_offset = luau_savestack(state, state->outtop);
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
	if (field == nullptr)
	{
		set_registry_nil(state, guard_base(), addon.registry_key.c_str());
	}
	else
	{
		getfield(state, -10000, addon.registry_key.c_str());
		if (!is_table(guard_base()->type))
		{
			restore_lua_top();
			finish_guard();
			log_failure("lifecycle-root-not-table");
			return false;
		}
		getfield(state, -1, field);
		if (!is_function((guard_base() + 1)->type))
		{
			restore_lua_top();
			finish_guard();
			log_failure("operation-not-function");
			return false;
		}
		state->outtop = guard_base() + 2;
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

void remember_target_script_binding(
	std::uint64_t target_key,
	luau_State* state
)
{
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	if (state == nullptr || !target_script_binding_capture_allowed(
		target_key,
		state->global_state,
		owner_thread,
		active_run_script_boundary.active,
		active_run_script_boundary.global_state,
		active_run_script_boundary.owner_thread,
		active_run_script_boundary.script_resource_identity))
	{
		return;
	}

	TargetScriptBinding binding{
		target_key,
		state->global_state,
		active_run_script_boundary.script_resource_identity,
		active_run_script_boundary.ability_identity,
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
	if (game_version >= GV(43, 0, 0) && game_version < GV(44, 0, 0))
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
	if (game_version >= GV(43, 0, 0) && game_version < GV(44, 0, 0))
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
	std::lock_guard lock(generation_mutex);
	const auto base_offset = luau_savestack(state, state->outtop);
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 2);
	for (const auto& root : diagnostic_module_roots)
	{
		if (root.global_state != state->global_state) continue;
		auto* base = luau_restorestack(state, base_offset);
		luau_TValue nil{};
		nil.type = LUAU_NIL;
		push_stack_value(state, nil);
		setfield(state, -10000, root.registry_key.c_str());
		state->outtop = base;
		getfield(state, -10000, root.registry_key.c_str());
		base = luau_restorestack(state, base_offset);
		const bool cleared = base->type == LUAU_NIL;
		state->outtop = base;
		if (!cleared) return false;
	}

	const auto* const global_state = state->global_state;
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
	state->outtop = luau_restorestack(state, base_offset);
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

	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 8);
	auto* const base = state->outtop;
	if (!push_environment_table(state, initialize->env, base))
	{
		state->outtop = base;
		config::log("RENOVICE Scripts UI attach FAIL reason=Initialize-environment-not-table");
		return false;
	}
	// Root the generated closure through a normal environment-table write before
	// assigning it into DE's captured dispatch upvalue.  The wrapper receives
	// the completed stock mMenuOptions array as its normal first Lua argument.
	push_stack_value(state, original_dispatch);
	luau_pushcclosurek(
		state, &pause_menu_builder_wrapper,
		"RENOVICE pause Scripts menu dispatch", 1, nullptr);
	const auto wrapper_value = *(base + 1);
	setfield(state, -2, "_RENOVICEPauseMenuDispatchWrapper");
	*dispatch_slot = wrapper_value;

	luau_Closure* installed = nullptr;
	const bool pass = readable_lua_closure(
		dereference_upvalue(*dispatch_slot), installed)
		&& installed->isC && installed->c.func == &pause_menu_builder_wrapper
		&& installed->nupvalues == 1
		&& dereference_upvalue(installed->c.upvals[0]).value.as_uintptr
			== original_dispatch.value.as_uintptr;
	state->outtop = base;
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
	ScopedVmApiFrame frame_capacity(state);
	require_stack(state, 8);
	auto* const base = state->outtop;
	// The exact root publishes mMenuOptions at instruction 49 and Initialize at
	// instruction 687 into its own closure environment. Startup VM returns can
	// precede both writes, so use mMenuOptions as the semantic publication gate
	// and keep this exact identity pending until the state exists.
	if (!push_environment_table(state, environment, base))
	{
		state->outtop = base;
		config::log("RENOVICE Scripts UI attach FAIL reason=TopMenu-environment-not-table");
		return false;
	}
	getfield(state, -1, "mMenuOptions");
	const bool menu_options_is_table = is_table((base + 1)->type);
	state->outtop = base + 1;
	if (!menu_options_is_table)
	{
		if (source != nullptr
			&& std::strcmp(source, "vm-runtime-root-return") == 0)
		{
			std::ostringstream failure;
			failure << "RENOVICE Scripts UI attach FAIL reason=runtime-mMenuOptions-not-table"
				<< " tag=" << static_cast<int>((base + 1)->type)
				<< " runtime_env=" << environment;
			config::log(failure.str());
		}
		state->outtop = base;
		return false;
	}
	getfield(state, -1, "Initialize");
	const int initialize_tag = static_cast<int>((base + 1)->type);
	luau_Closure* initialize = nullptr;
	const bool initialize_is_lua = readable_lua_closure(*(base + 1), initialize)
		&& !initialize->isC;
	if (!initialize_is_lua)
	{
		state->outtop = base;
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=published-Initialize-not-lua-function"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " initialize_tag=" << initialize_tag;
		config::log(failure.str());
		return false;
	}
	if (!pause_environment_publication_ready(
		menu_options_is_table, environment, initialize->env,
		true, initialize->nupvalues))
	{
		state->outtop = base;
		std::ostringstream failure;
		failure << "RENOVICE Scripts UI attach FAIL reason=published-Initialize-owner"
			<< " source=" << (source != nullptr ? source : "unknown")
			<< " recorded_env=" << environment
			<< " initialize_env=" << initialize->env
			<< " upvalues=" << static_cast<unsigned int>(initialize->nupvalues);
		config::log(failure.str());
		return false;
	}
	const auto initialize_value = *(base + 1);
	state->outtop = base;
	return decorate_pause_initialize_assignment(
		body_key, state, initialize_value, "published-TopMenu-environment");
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
    if (state == nullptr || vm_execution_depth != 0 || lua_execution_depth != 0
        || GetCurrentThreadId() != captured_owner_thread.load(std::memory_order_acquire)
        || state->global_state == nullptr
        || state->global_state != captured_global_state.load(std::memory_order_acquire)) return;
    static VmMemorySampleGate gate;
    const auto now = GetTickCount64();
    if (gate.admit(true, true, now)) capture_vm_memory_evidence(state, gate.sequence, now);
}

void vm_execute_detour(luau_State* state)
{
	const auto pause_root = inspect_pause_vm_root_execution(state);
	const bool target_observation_enabled = observe_target_addons.load(
		std::memory_order_acquire);
	auto generation_dispatch = target_observation_enabled
		? generation_dispatch_gate.try_dispatch()
		: GenerationDispatchGate::Lease{};
	std::uint64_t target_execution_key = 0;
	TargetLuaCall target_lua_call;
	std::vector<luau_TValue> target_lua_arguments;
	bool target_lua_arguments_captured = false;
	struct ScopedLuaArgumentRoot
	{
		luau_State* state;
		std::string key;
		bool active = false;
		explicit ScopedLuaArgumentRoot(luau_State* owner)
			: state(owner) {}
		void release() noexcept
		{
			if (!active || state == nullptr || state->stack == nullptr
				|| state->outtop == nullptr || check_stack == nullptr || setfield == nullptr) return;
			active = false;
			const auto top = luau_savestack(state, state->outtop);
			ScopedVmApiFrame frame_capacity(state);
			try
			{
				if (check_stack(state, 1))
				{
					luau_TValue nil{}; nil.type = LUAU_NIL;
					push_stack_value(state, nil);
					setfield(state, -10000, key.c_str());
				}
				else config::log("RENOVICE VM_FRAME build=V95 event=argument-root-release-rejected native-capacity=0");
			}
			catch (...) { config::log("RENOVICE VM_FRAME build=V95 event=argument-root-release-error"); }
			state->outtop = luau_restorestack(state, top);
		}
		~ScopedLuaArgumentRoot() noexcept { release(); }
	} argument_root(state);
	if (generation_dispatch
		&& state != nullptr && state->ci != nullptr
		&& state->ci->func != nullptr && state->global_state != nullptr
		&& !diagnostics::bad_read_ptr(state->ci, sizeof(luau_CallInfo))
		&& !diagnostics::bad_read_ptr(state->ci->func, sizeof(luau_TValue)))
	{
		target_execution_key = target_key_for_published_closure(
			state, *state->ci->func);
		if (!lua_call_hook_running)
		{
			target_lua_call = target_lua_call_for_published_closure(
				state, *state->ci->func);
			const int argument_count = luau_gettop(state);
			if (target_lua_call.callsite.exact && argument_count >= 0
				&& argument_count <= 256 && state->intop != nullptr)
			{
				target_lua_arguments.assign(
					state->intop, state->intop + argument_count);
				target_lua_arguments_captured = true;
				argument_root.key = "RENOVICE_LuaCallArgs_V95_" +
					std::to_string(reinterpret_cast<std::uintptr_t>(&argument_root));
			}
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
	{
		// VM execution can leave through a C++ exception/unwind path. Keep the
		// counter scoped so one aborted module cannot block every later reload
		// boundary until the process restarts.
		ScopedVmExecutionDepth execution_depth;
		ScopedTargetExecution target_execution_scope(
			target_execution_key,
			state != nullptr ? state->global_state : nullptr);
		if (target_execution_key != 0)
		{
			log_native_hook_once(
				state, target_execution_key, "target-execution.enter");
		}
		if (target_lua_call.callsite.exact && target_lua_arguments_captured
			&& !dispatch_lua_call_phase(
				state, target_lua_call, "before", target_lua_arguments, argument_root.key.c_str(), &argument_root.active))
		{
			trace_addon(state, target_lua_call.callsite.target_key,
				"lua.call.before.reject", "stock execution retained=1");
		}
		reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);
		if (target_lua_call.callsite.exact && target_lua_arguments_captured && argument_root.active)
		{
			bool frame_scan_valid = false;
			const bool target_frame_still_active = state->status == 0
				? target_lua_call_frame_active(
					state, target_lua_call.closure, frame_scan_valid)
				: false;
			if (!lua_call_after_dispatch_allowed(
				true, state->status, frame_scan_valid, target_frame_still_active))
			{
				const std::string event = "luaCalls."
					+ std::to_string(target_lua_call.callsite.prototype)
					+ ".after.skipped";
				const char* const reason = state->status != 0
					? "thread-status" : (!frame_scan_valid
						? "callinfo-scan" : "target-frame-active");
				const std::string details = std::string("reason=") + reason
					+ " status=" + std::to_string(state->status)
					+ " frame_scan=" + (frame_scan_valid ? "valid" : "invalid")
					+ " target_active=" + (target_frame_still_active ? "1" : "0")
					+ " stock-resume-preserved=1";
				log_native_hook_once(state,
					target_lua_call.callsite.target_key, event.c_str());
				const auto skip_sequence = lua_after_skip_trace_sequence.fetch_add(
					1, std::memory_order_relaxed) + 1;
				if (sample_repeated_skip_trace(skip_sequence))
				{
					trace_addon(state, target_lua_call.callsite.target_key,
						"lua.call.after.skip",
						details + " occurrence=" + std::to_string(skip_sequence));
				}
			}
			else if (!dispatch_lua_call_phase(
				state, target_lua_call, "after", target_lua_arguments, argument_root.key.c_str(), &argument_root.active))
			{
				trace_addon(state, target_lua_call.callsite.target_key,
					"lua.call.after.reject", "stock result retained=1");
			}
		}
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
	}
	argument_root.release();
	// F9 is admitted only after every handler call above has finished. Release
	// this execution's generation before the outer-return control tick may
	// begin the next generation transaction on this same thread.
	generation_dispatch = {};
	if (target_addon_refresh_pending.load(std::memory_order_acquire)
		&& vm_execution_depth == 0 && lua_execution_depth == 0)
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
		vm_execution_depth,
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
		vm_execution_depth,
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
					<< " vm_depth=" << vm_execution_depth
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
	const std::uint32_t* execution_name_handle, bool use_borrowed_closure_environment);

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
	runtime.bytes.assign(std::begin(callback_runtime_bytecode), std::end(callback_runtime_bytecode));
	const bool passed = run_chunk(runtime, state, &callback_runtime_registry_key,
		nullptr, true, manager, name_handle, true);
	trace_addon(state, 0, passed ? "damage.runtime.ready" : "damage.runtime.error",
		"storage=embedded-dll bytes=" + std::to_string(sizeof(callback_runtime_bytecode)));
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
	runtime.bytes.assign(
		std::begin(automatic_damage_runtime_bytecode),
		std::end(automatic_damage_runtime_bytecode));
	const bool passed = run_chunk(
		runtime, state, &automatic_damage_runtime_registry_key,
		nullptr, true, manager, name_handle, true);
	if (!passed) automatic_damage_failed_vms.push_back(state->global_state);
	std::ostringstream result;
	result << "RENOVICE automatic damage runtime "
		<< (passed ? "PASS" : "FAIL")
		<< " build=V87 storage=embedded-dll bytes="
		<< sizeof(automatic_damage_runtime_bytecode)
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

bool loader_detour(void* manager, void* descriptor)
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
	const bool result = reinterpret_cast<Loader>(loader_hook.original)(manager, descriptor);
	replacements::complete_module_load(manager, descriptor);
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
	return result;
}

bool run_chunk(
	const Chunk& chunk,
	luau_State* boundary_state,
	const std::string* lifecycle_key = nullptr,
	void* execution_environment = nullptr,
	bool pass_global_argument = true,
	void* execution_manager = nullptr,
	const std::uint32_t* execution_name_handle = nullptr,
	bool use_borrowed_closure_environment = false
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
		use_borrowed_closure_environment);
	if (result.completed && result.registry_restored)
	{
		std::ostringstream success;
		success << "RENOVICE Inject PASS " << chunk.name
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
		failure << "RENOVICE Inject FAIL " << chunk.name
			<< " fault_stage=" << result.fault_stage
			<< " fault_code=" << result.fault_code
			<< " closure_tag=" << result.closure_tag
			<< " pcall=" << result.protected_call_result
			<< " result_tag=" << result.result_tag
			<< " registry_restored=" << result.registry_restored;
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
	if (!desired.empty())
	{
		if (!ensure_callback_runtime(state, manager, name_handle)) return false;
		void* target_environment = nullptr;
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
				&& current[i].content_key == content_key;
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
		candidate.global_state = global_state;
		candidate.owner_thread = owner_thread;
		if (!run_chunk(
			*chunk, state, &candidate.addon.registry_key,
			nullptr, true, manager, name_handle, true))
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
			conout << "RENOVICE TARGET ADDON ROLLBACK stage failed: "
				<< chunk->name << " previous target generation retained" << std::endl;
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
	auto interrupt_increment = resolve_unique<void*>(range,
		signature_interrupt_increment_u43, "U43 thread interrupt increment");
	auto interrupt_guard = resolve_unique<void*>(range,
		signature_interrupt_guard_u43, "U43 bounded interrupt guard");
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
	config::log("RENOVICE VM_FRAME build=V95 event=contract-ready capacity-restore=all-48-api-owners lua-call-host-frame=native-protected native-limit=8000-unchanged");

	loader_hook.target = reinterpret_cast<void*>(loader);
	loader_hook.detour = reinterpret_cast<void*>(&loader_detour);
	vm_execute_hook.target = reinterpret_cast<void*>(vm_execute);
	vm_execute_hook.detour = reinterpret_cast<void*>(&vm_execute_detour);
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
	std::memset(&guard, 0, sizeof(guard));
	guard.state = manager_state;
	guard.base_offset = luau_savestack(manager_state, manager_state->outtop);
	guard.thread_id = GetCurrentThreadId();
	guard.handler = AddVectoredExceptionHandler(1, fault_handler);
	if (guard.handler == nullptr)
	{
		return false;
	}
	void* game_buffer = game_allocate(bytes.size(), 0);
	if (game_buffer == nullptr || IsBadWritePtr(game_buffer, bytes.size()))
	{
		finish_guard();
		return false;
	}
	std::memcpy(game_buffer, bytes.data(), bytes.size());
	if (setjmp(guard.jump) != 0)
	{
		if (*body_slot == game_buffer)
		{
			*body_slot = nullptr;
			*size_slot = 0;
		}
		restore_lua_top();
		finish_guard();
		std::ostringstream failure;
		failure << "RENOVICE native module refresh FAULT " << name
			<< " stage=" << guard.fault_stage
			<< " exception_code=" << static_cast<std::uint32_t>(guard.fault_code)
			<< " address=" << guard.fault_address;
		conout << failure.str() << std::endl;
		config::log(failure.str());
		return false;
	}

	guard.active = 1;
	guard.stage = 30;
	*body_slot = game_buffer;
	*size_slot = static_cast<std::uint32_t>(bytes.size());
	const bool loaded = reinterpret_cast<Loader>(loader_hook.original)(manager, descriptor);
	restore_lua_top();
	finish_guard();
	std::ostringstream result;
	result << "RENOVICE native module refresh " << (loaded ? "PASS" : "FAIL")
		<< " " << name << " descriptor=" << descriptor
		<< " bytes=" << bytes.size();
	conout << result.str() << std::endl;
	config::log(result.str());
	return loaded;
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
		lua_after_skip_trace_sequence.store(0, std::memory_order_relaxed);
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
