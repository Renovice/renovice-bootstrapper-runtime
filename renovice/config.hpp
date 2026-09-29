#pragma once

#include "config_core.hpp"

#include <filesystem>
#include <string_view>

namespace renovice::config
{
bool initialise();
bool reload();
bool prepare_reload();
void commit_prepared_reload();
void discard_prepared_reload();

const std::filesystem::path& custom_scripts_directory() noexcept;
const std::filesystem::path& injection_directory() noexcept;
Flags flags();
DiagnosticsMode diagnostics_mode() noexcept;
bool diagnostics_enabled() noexcept;
bool memory_diagnostics_enabled() noexcept;
void memory_log(std::string_view message) noexcept;

void log(std::string_view message) noexcept;
void verbose_log(std::string_view message) noexcept;
void diagnostic_log(std::string_view message, DiagnosticsMode minimum_mode) noexcept;
// Buffered diagnostic lines reach the source log on a bounded cadence; these
// force them out (normal shutdown flushes automatically).
void flush_log() noexcept;
void flush_log_for_fault() noexcept;
}
