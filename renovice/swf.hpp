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
bool prepare_reload();
void commit_prepared_reload();
void discard_prepared_reload();
}
