#pragma once

namespace renovice::swf
{
enum class InitialiseResult
{
	Disabled,
	Enabled,
	Failed,
};

InitialiseResult initialise();
bool reload();
}
