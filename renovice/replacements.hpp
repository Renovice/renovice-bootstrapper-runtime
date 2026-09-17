#pragma once

#include "replacements_core.hpp"

struct luau_State;

namespace renovice::replacements
{
enum class InitialiseResult
{
	Disabled,
	Enabled,
	Failed,
};

InitialiseResult initialise(std::string_view exact_build, bool observe_undumps);
bool reload();
bool prepare_reload();
void commit_prepared_reload();
void discard_prepared_reload();
void begin_module_load(void* manager, void* descriptor, std::uint64_t observed_body_key = 0);
void complete_module_load(void* manager, void* descriptor);
bool reexecute_changed_loaded(luau_State* state);
bool drain_pending_for_vm(luau_State* state);
}
