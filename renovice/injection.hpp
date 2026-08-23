#pragma once

#include <string>
#include <vector>

struct luau_State;

namespace renovice::injection
{
enum class InitialiseResult
{
	Enabled,
	Failed,
};

InitialiseResult initialise();
void notify_undump() noexcept;
void poll_f9(bool allow_reload) noexcept;
void drain(luau_State* state);
bool execute_module_refresh(
	const std::string& name,
	const std::vector<unsigned char>& bytes,
	void* environment,
	luau_State* state
);
}
