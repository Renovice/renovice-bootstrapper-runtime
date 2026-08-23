#pragma once

#include "replacements_core.hpp"

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
}
