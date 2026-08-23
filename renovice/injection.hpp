#pragma once

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
}
