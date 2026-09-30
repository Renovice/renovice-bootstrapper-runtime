#pragma once

// LIVE_LITERALS_V1 runtime (2026-09-30): recipe attachment during the package
// scan, per-package plan resolution, and the committed plan snapshot the
// replacement lane synthesizes from. Pure rules: live_literals_core.hpp.
//
// Ownership:
//   - Recipes and declarations: the package snapshot of one scan (startup/F9).
//   - Plans: resolved at every committing scan from the values file; the
//     replacement lane prepares/commits/discards a PlanSnapshot together with
//     its byte snapshot, so a plan is visible only after its F9 commits.
//   - Synthesized bytes: cached per committed plan (process memory, no VM
//     object). Every synthesis re-verifies the stock size, SHA-256 and every
//     preimage; a failure holds only that module at stock.
// Nothing here touches a VM; the replacement lane decides where bytes go.

#include "live_literals_core.hpp"
#include "packages.hpp"

#include <cstdint>
#include <filesystem>
#include <functional>
#include <map>
#include <memory>
#include <mutex>
#include <set>
#include <string>
#include <vector>

namespace renovice::live_literals
{
// A committed plan and its synthesis cache.
struct RuntimePlan
{
	ModulePlan plan;
	std::string package;
	mutable std::mutex mutex;
	mutable std::string failure;
	mutable std::vector<unsigned char> stock;                  // verified stock copy
	mutable std::shared_ptr<const std::vector<unsigned char>> bytes;
};

struct PlanSnapshot
{
	std::map<std::uint64_t, std::shared_ptr<const RuntimePlan>> plans;
	// Keys of every structurally valid recipe (inventory, also while disabled
	// or at stock), so the replacement lane captures the stock body and loader
	// context at the natural load and a later edit can refresh the module.
	std::set<std::uint64_t> recipe_keys;
};

// Package scan: reads <package folder>\literals.json (when present), parses it
// and merges its values into package.declarations. A failure sets
// package.literals_reason and leaves the declarations of package.json as they
// were (the rest of the package is unaffected).
void attach_recipes(packages::Package& package, const std::filesystem::path& recipe_path);

// Committing scans: resolves the package's current values into module plans
// (package.literal_plans) and reports the recipe status, every plan and every
// module held at stock (bounded, operational lines).
void resolve_package_plans(
	packages::Package& package,
	const settings::UserState* state,
	const settings::PackageEvaluation& evaluation,
	const char* trigger);

// Collects the plans of every accepted package of `snapshot` in package order.
// A module already owned by a byte replacement (loose file or package member)
// or by an earlier package's plan keeps that owner; the later plan is held at
// stock with an exact reason.
std::shared_ptr<const PlanSnapshot> build_snapshot(
	const packages::Snapshot* snapshot,
	const std::function<bool(std::uint64_t)>& owned_by_replacement,
	const char* trigger);

std::shared_ptr<const PlanSnapshot> active() noexcept;
void publish(std::shared_ptr<const PlanSnapshot> snapshot) noexcept;   // startup
void prepare(std::shared_ptr<const PlanSnapshot> snapshot) noexcept;   // F9 prepare
void commit_prepared() noexcept;
void discard_prepared() noexcept;
std::shared_ptr<const PlanSnapshot> prepared() noexcept;

// Keys whose effective plan differs between two snapshots (added, removed or
// another identity).
std::vector<std::uint64_t> changed_keys(const PlanSnapshot& previous, const PlanSnapshot& next);

// The synthesized module for `key` from its stock body, or nullptr (no plan,
// or the plan failed verification: the module loads stock). `source` names the
// caller for the one PASS/FAIL line per plan ("undump", "refresh").
std::shared_ptr<const std::vector<unsigned char>> synthesized(
	const PlanSnapshot& snapshot, std::uint64_t key,
	const unsigned char* stock, std::size_t size, const char* source);
}
