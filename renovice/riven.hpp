#pragma once

namespace renovice::riven
{
bool initialise();
bool reload_gate();
bool prepare_gate_reload();
void commit_prepared_gate();
void discard_prepared_gate();
}
