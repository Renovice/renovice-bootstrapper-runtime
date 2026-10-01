#pragma once

// ENGINE_PARAM_OVERRIDE runtime (contract R16, 2026-10-01). Pure rules:
// engine_params_core.hpp; per-build registration: engine_params_builds.hpp.
//
// Ownership:
//   - The native hook (push_value detour) and its trampoline: process-owned,
//     installed once at startup, never retired by F9.
//   - Recipes: the package snapshot of one scan (startup/F9).
//   - Plans: generation-owned. A plan is resolved at every committing scan
//     from the member's delivered values, published at startup, prepared at
//     F9 and visible to the hook only after its F9 commits. A call already in
//     the hook finishes on the plan it loaded.
//   - Module identities: process-owned records of prototype addresses and code
//     hashes, taken at each natural load of a recipe module (no Lua object is
//     retained; nothing is pinned in the registry).
// Diagnostics=false: the hook formats and writes nothing. Operational lines
// (install result, recipe and plan per committing scan) are bounded and are
// written only at startup and F9, like the LIVE LITERALS lines.

#include "engine_params_core.hpp"
#include "packages.hpp"

#include <cstdint>
#include <filesystem>
#include <memory>
#include <string_view>

namespace renovice::engine_params
{
// main.cpp: the SHA-256 (lower hex) of the running executable, computed by the
// startup build gate. Without it nothing installs.
void set_executable_digest(std::string_view digest) noexcept;

// Startup, before the first package scan. Installs the process-owned hook
// when a package folder holds engine_params.json, the executable is
// registered and every registered byte range is present. One operational line.
bool initialise();
[[nodiscard]] bool installed() noexcept;

// Package scan (packages.cpp).
void attach_recipe(packages::Package& package, const std::filesystem::path& path);
// After the member deliveries of a committing scan: resolves the plan and,
// when the hook is installed, withholds the owned values from the member's
// delivery. Logs the recipe and plan when `trigger` is set.
void resolve_package(packages::Package& package, const char* trigger);
// After every package: a (module, hash) pair has one owner. A later package
// that overlaps an earlier one keeps its values on its addon (delivery
// restored) and gets no plan.
void resolve_conflicts(packages::Snapshot& snapshot, const char* trigger);

// Plan snapshot lifecycle (packages.cpp).
std::shared_ptr<const PlanSnapshot> build_snapshot(const packages::Snapshot* snapshot);
void publish(std::shared_ptr<const PlanSnapshot> snapshot, const char* trigger) noexcept;   // startup
void prepare(std::shared_ptr<const PlanSnapshot> snapshot) noexcept;                        // F9 prepare
void commit_prepared(const char* trigger) noexcept;
void discard_prepared() noexcept;
std::shared_ptr<const PlanSnapshot> active() noexcept;

// Module identity (injection.cpp, natural load boundary and F9 refresh).
[[nodiscard]] bool observing() noexcept;
[[nodiscard]] bool module_wanted(std::uint64_t key) noexcept;
void record_module(std::uint64_t key, const void* vm, const void* root_proto) noexcept;
}
