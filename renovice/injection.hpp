#pragma once

#include <cstdint>
#include <string>
#include <vector>

struct luau_State;
struct luau_TValue;

namespace renovice::injection
{
enum class InitialiseResult
{
	Enabled,
	Failed,
};

using SafeRuntimeTick = void(*)(luau_State* state);
using SafeRuntimeControlPoll = void(*)();

// Resolve the native U43 stack reservation and thread-GC publication contract
// without installing addon hooks. OpenWF and the managed injector share this
// one authoritative game-VM write path.
bool initialise_game_vm_stack_bridge() noexcept;
bool reserve_game_vm_stack(luau_State* state, int slots) noexcept;
// Copy an existing game-VM stack value through DE's native lua_pushvalue.
// This is the authoritative path when the source already has a VM stack root.
bool push_game_vm_stack_index(luau_State* state, int index) noexcept;
// Input is copied before native reservation because reservation may relocate
// the source stack slot.
bool append_game_vm_stack_value(luau_State* state, luau_TValue value) noexcept;
// Append only when the caller has already proved one free stack slot. This
// path never invokes check_stack and therefore cannot grow the stack or raise
// a DE Luau error through a native C++ ownership frame.
bool append_game_vm_stack_value_reserved(
	luau_State* state, luau_TValue value) noexcept;

// Registers the pending-only RENOVICE transaction callback. A DE interpreter
// return can still sit inside the native caller that entered it, so periodic
// OpenWF/Pluto script work is forbidden from this boundary.
void set_safe_runtime_tick(SafeRuntimeTick callback) noexcept;
// Registers a Lua-free control poll. It may only latch requests such as F9;
// actual script work still drains at the exact safe VM boundary above.
void set_safe_runtime_control_poll(SafeRuntimeControlPoll callback) noexcept;
InitialiseResult initialise();
// Called once the source bootstrapper has populated the native SWIG registry.
// Target observers must bind here, before the first natural target module load.
void notify_swig_types_ready();
void poll_f9(bool allow_reload) noexcept;
void request_reload(const char* source) noexcept;
// Cheap native check used to prioritize an explicit request at the next safe
// outer VM return. It performs no Lua or filesystem work.
bool reload_pending() noexcept;
// Includes the initial injection transaction as well as an explicit reload.
// This is the sole condition that authorizes the callback above to run.
bool runtime_work_pending() noexcept;
void drain(luau_State* state);
// Services only an already-queued reload on the exact captured VM/thread.
// Retained for narrow VM-owned boundaries; stock HUD methods must not be hooked
// to call it.
bool drain_requested(luau_State* state);
// Historical cached-export attachment point. The implementation is retained as
// negative evidence but runtime-disabled: VM SETGLOBAL does not call the public
// helper, and the ability card is now observed at the real RunScript boundary.
void maybe_wrap_global(luau_State* state, std::uint32_t name_hash) noexcept;
bool execute_module_refresh(
	const std::string& name,
	const std::vector<unsigned char>& bytes,
	void* environment,
	luau_State* state,
	void* manager,
	const std::uint32_t* name_handle
);
bool execute_native_module_refresh(
	const std::string& name,
	const std::vector<unsigned char>& bytes,
	luau_State* state,
	void* manager,
	void* descriptor
);
}
