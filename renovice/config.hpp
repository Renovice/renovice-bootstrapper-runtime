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

void log(std::string_view message) noexcept;
void verbose_log(std::string_view message) noexcept;
}
