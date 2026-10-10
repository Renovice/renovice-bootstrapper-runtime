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
// Script folder layout (LAYOUT_V2, 2026-10-10). custom_scripts_directory() is the root (OpenWF/LuaScripts
// in V2, OpenWF/CustomScripts in V1); injection_directory() is Addons/ (V2) or Inject/ (V1).
bool layout_v2() noexcept;
const std::filesystem::path& replacements_directory() noexcept;   // V2 Replacements/, V1 the root
const std::filesystem::path& packages_directory() noexcept;       // <root>/Packages
const std::filesystem::path& config_file_path() noexcept;         // V2 Config/Logs.cfg, V1 renovice.cfg
const std::filesystem::path& script_states_path() noexcept;       // V2 Config/ScriptStates.json, V1 ScriptStates.json
const std::filesystem::path& settings_directory() noexcept;       // V1 Settings/; empty in V2 (values in ScriptStates)
const std::filesystem::path& dumps_directory() noexcept;          // V2 Logs/Dumps/, V1 Diagnostics/
std::filesystem::path riven_lock_config_path();                   // V2 Config/riven_lock.cfg, V1 root
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
