#pragma once

namespace renovice::riven
{
bool initialise();
void prepare_gate_reload();
void commit_prepared_gate();
void discard_prepared_gate();
}
