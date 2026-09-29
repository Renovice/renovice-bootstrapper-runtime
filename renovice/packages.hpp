#pragma once

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
};

struct Snapshot
{
	std::vector<Package> packages;
};

std::filesystem::path directory();

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
