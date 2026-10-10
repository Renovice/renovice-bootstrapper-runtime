#pragma once

#include "script_control_core.hpp"

#include <string>
#include <vector>

namespace renovice::script_control
{
struct ScriptInfo
{
	std::string id;
	std::string filename;
	Kind kind = Kind::OneShot;
	std::string target;
	bool enabled = true;
	bool pending = false;
	bool valid = true;
	std::string status;
	// Packages only: the complete menu label and the tooltip body (description
	// and member summary). Empty for every loose file, whose label and tooltip
	// are derived from the filename exactly as before.
	std::string label;
	std::string detail;
};

bool initialise();
bool prepare_reload();
void commit_prepared_reload();
void discard_prepared_reload();

// Scanners use the prepared policy during an F9 transaction and the active
// policy at startup. An absent entry is enabled for backward compatibility.
bool candidate_enabled(std::string_view id);
// Active policy overlaid with requests saved but not yet committed by F9 (what
// the next generation will use). For UI display only.
bool displayed_enabled(std::string_view id);

std::vector<ScriptInfo> snapshot();

// LAYOUT_V2: SCRIPT SETTINGS values live in Config/ScriptStates.json `values`, one entry per package
// id, each the former Settings/<Package>.json object as exact JSON text. read_package_values returns
// false when the entry (or the file) is absent; on a read or JSON failure it returns true with a
// non-empty error. write_package_values replaces/adds entries and keeps every switch and every other
// package's values. Both are no-ops returning false in the original layout.
bool read_package_values(std::string_view package_id, std::string& text, bool& present, std::string& error);
bool write_package_values(
	const std::vector<std::pair<std::string, std::string>>& entries, std::string& error);
bool request_enabled(std::string_view id, bool enabled, std::string& error);
bool request_enabled_batch(
	const std::vector<std::pair<std::string, bool>>& requests,
	std::string& error
);
}
