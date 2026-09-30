#pragma once

#include "live_literals_core.hpp"
#include "packages_core.hpp"

#include <cstdint>
#include <filesystem>
#include <memory>
#include <string>
#include <vector>

namespace renovice::packages
{
struct Member
{
	std::string filename;
	MemberKind kind = MemberKind::Replacement;
	// Replacement members: the replacement content key. Single-key target
	// addons: the target key. Zero for multi-target addons.
	std::uint64_t key = 0;
	// Target keys this member binds (single key, or the declared pool keys).
	std::vector<std::uint64_t> target_keys;
	// Present only for members of an accepted, enabled package in a committing
	// scan (startup/F9). Inventory scans never keep replacement bytes.
	std::vector<unsigned char> bytes;
	std::string label;
	// `member:<folder>/<file>` enable policy (ScriptStates.json). A disabled
	// member is still structurally validated and its keys stay inventoried.
	std::string state_id;
	bool enabled = true;
	// Enters its lane in this generation: package accepted, member enabled
	// and, for a replacement with literal declarations, admitted by the
	// literal-lane settings gate.
	bool staged = false;
	// ADDON_SETTINGS_V1 delivery for an addon member that declares values
	// (committing scans only). nullptr: no declarations, the addon receives
	// context.settings = nil and keeps its compiled defaults.
	std::shared_ptr<const settings::MemberDelivery> delivery;
};

struct Package
{
	std::string folder;
	std::string id;
	std::string display;
	std::string description;
	bool enabled = false;
	// Folder, manifest and every member passed static validation, so the
	// package's keys are known and inventoried even while it is disabled.
	bool structurally_valid = false;
	// Structurally valid, enabled and free of conflicts: its members enter
	// their normal lanes in this generation.
	bool accepted = false;
	std::string reason;
	std::vector<Member> members;
	// Validated settings declarations, or nullptr (none, or rejected with
	// settings_reason; a rejection is local to the settings capability).
	std::shared_ptr<const settings::Declarations> declarations;
	std::string settings_reason;
	// LIVE_LITERALS_V1 (live_literals.hpp): the parsed literals.json recipe (its
	// values are merged into `declarations`), or nullptr with literals_reason
	// (recipe-local: the rest of the package is unaffected). literal_plans:
	// the current values resolved into module patch plans (committing scans).
	std::shared_ptr<const live_literals::Recipes> literal_recipes;
	std::string literals_reason;
	std::vector<live_literals::ModulePlan> literal_plans;
};

struct Snapshot
{
	std::vector<Package> packages;
};

std::filesystem::path directory();

// ADDON_SETTINGS_V1 user values: CustomScripts\Settings\<folder>.json.
// read_settings_values returns false when the file is absent; on a read or
// parse failure it returns true with a non-empty error.
std::filesystem::path settings_values_path(std::string_view folder);
bool read_settings_values(const Package& package, settings::UserState& state, std::string& error);

// Startup: scan with the active policy and publish it as the active snapshot.
// Returns false only for a Packages-root I/O error; per-package problems are
// package-local and never fail the scan.
bool initialise();

// F9: scan with the prepared policy. Consumed by the replacement lane and the
// Inject scanner of the same transaction, then committed or discarded with it.
bool prepare_reload();
void commit_prepared_reload();
void discard_prepared_reload();

// Prepared snapshot during an F9 transaction, otherwise the active snapshot.
std::shared_ptr<const Snapshot> candidate();

// Fresh, quiet scan for the Scripts menu (no replacement bytes, no log lines).
std::shared_ptr<const Snapshot> inventory();
}
