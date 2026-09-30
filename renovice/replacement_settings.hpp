#pragma once

#include "replacement_settings_core.hpp"

#include <cstdint>
#include <memory>

namespace renovice::replacement_settings
{
// Publishes the committed REPLACEMENT_SETTINGS_V1 snapshot built from the
// package snapshot that was just committed (startup scan, or F9 after
// packages::commit_prepared_reload). Never called with a prepared (uncommitted)
// snapshot, so an accessor call can never observe a generation that may still
// roll back. Operational log lines are written only when a snapshot holds or
// held an entry, so a setup without such packages logs exactly as before.
void commit(const std::shared_ptr<const packages::Snapshot>& committed_packages, const char* trigger);

// The committed snapshot (never null). Callers keep the returned shared_ptr for
// the whole call; a concurrent commit cannot free it.
std::shared_ptr<const Snapshot> committed() noexcept;
}
