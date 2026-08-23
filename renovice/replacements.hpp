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
}
