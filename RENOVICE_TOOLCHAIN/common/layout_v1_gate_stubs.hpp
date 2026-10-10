#pragma once
// Offline-gate stand-ins for the folder functions LAYOUT_V2 (2026-10-10) added to renovice::config and
// renovice::script_control. The package/settings gates model the ORIGINAL CustomScripts layout rooted at
// gate::root (replacements in the root, Packages/, Settings/), so these return exactly the paths the
// pre-V2 loader used and their results stay unchanged. Include once per gate translation unit, after
// `namespace gate { std::filesystem::path root; ... }`.
#include <filesystem>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

namespace renovice::config
{
bool layout_v2() noexcept { return false; }
const std::filesystem::path& replacements_directory() noexcept { return gate::root; }
const std::filesystem::path& packages_directory() noexcept
{
	static std::filesystem::path path;
	path = gate::root / "Packages";
	return path;
}
const std::filesystem::path& settings_directory() noexcept
{
	static std::filesystem::path path;
	path = gate::root / "Settings";
	return path;
}
}

namespace renovice::script_control
{
bool read_package_values(std::string_view, std::string& text, bool& present, std::string& error)
{
	text.clear();
	present = false;
	error.clear();
	return false;
}
}
