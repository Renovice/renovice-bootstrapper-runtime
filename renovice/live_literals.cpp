#include "live_literals.hpp"

#include "config.hpp"

#include <algorithm>
#include <atomic>
#include <cstring>
#include <exception>
#include <fstream>
#include <limits>
#include <sstream>
#include <utility>

// The offline gate (RENOVICE_TOOLCHAIN/replacements/verify_live_literals.ps1)
// compiles this exact file with packages.cpp and stub providers; only the
// OpenWF console sink is left out there. Every line still reaches config::log.
#ifndef RENOVICE_PACKAGES_OFFLINE_GATE
#include "../owf_console.hpp"
#endif

namespace renovice::live_literals
{
namespace
{
std::mutex snapshot_mutex;
std::shared_ptr<const PlanSnapshot> active_snapshot = std::make_shared<PlanSnapshot>();
std::shared_ptr<const PlanSnapshot> prepared_snapshot;
std::atomic_size_t synthesis_lines = 0;
constexpr std::size_t maximum_synthesis_lines = 256;

void report(const std::string& message)
{
#ifndef RENOVICE_PACKAGES_OFFLINE_GATE
	conout << message << std::endl;
#endif
	config::log(message);
}

bool read_recipe(const std::filesystem::path& path, std::string& text)
{
	text.clear();
	std::error_code ec;
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || size == 0 || size > maximum_recipe_bytes) return false;
	text.resize(static_cast<std::size_t>(size));
	std::ifstream input(path, std::ios::binary);
	return input && static_cast<bool>(input.read(text.data(), static_cast<std::streamsize>(text.size())));
}
}

void attach_recipes(packages::Package& package, const std::filesystem::path& recipe_path)
{
	package.literal_recipes.reset();
	package.literals_reason.clear();
	try
	{
		std::string text;
		if (!read_recipe(recipe_path, text))
		{
			package.literals_reason = "recipe-unreadable-empty-or-too-large";
			return;
		}
		auto recipes = std::make_shared<Recipes>();
		if (auto error = parse_recipes(text, package.id, *recipes); !error.empty())
		{
			package.literals_reason = std::move(error);
			return;
		}
		if (!package.declarations && !package.settings_reason.empty())
		{
			// The package's own declarations were rejected: recipe values would
			// reference groups and a build nobody validated.
			package.literals_reason = "package-settings-declarations-rejected";
			return;
		}
		auto merged = package.declarations
			? std::make_shared<settings::Declarations>(*package.declarations)
			: std::make_shared<settings::Declarations>();
		if (auto error = merge_declarations(*recipes, *merged); !error.empty())
		{
			package.literals_reason = std::move(error);
			return;
		}
		package.declarations = std::move(merged);
		package.literal_recipes = std::move(recipes);
	}
	catch (const std::exception&)
	{
		package.literal_recipes.reset();
		package.literals_reason = "recipe-exception";
	}
}

void resolve_package_plans(
	packages::Package& package,
	const settings::UserState* state,
	const settings::PackageEvaluation& evaluation,
	const char* trigger)
{
	package.literal_plans.clear();
	if (!package.literals_reason.empty())
	{
		if (trigger != nullptr)
		{
			report("RENOVICE LIVE LITERALS RECIPE REJECT trigger=" + std::string(trigger)
				+ " package=" + package.folder + " reason=" + package.literals_reason
				+ " scope=recipe-local modules=stock");
		}
		return;
	}
	if (!package.literal_recipes || !package.declarations) return;
	const auto& recipes = *package.literal_recipes;
	Resolution resolution;
	if (package.accepted)
		resolution = resolve_plans(recipes, *package.declarations, state, evaluation);
	if (trigger == nullptr)
	{
		package.literal_plans = std::move(resolution.plans);
		return;
	}
	report("RENOVICE LIVE LITERALS RECIPE ACCEPT trigger=" + std::string(trigger)
		+ " package=" + package.folder + " modules=" + std::to_string(recipes.modules.size())
		+ " values=" + std::to_string(recipes.values.size())
		+ " plans=" + std::to_string(resolution.plans.size())
		+ " held_stock=" + std::to_string(resolution.rejections.size())
		+ " package_accepted=" + (package.accepted ? "1" : "0"));
	std::size_t logged = 0;
	for (const auto& rejection : resolution.rejections)
	{
		if (logged++ == maximum_logged_rejections) break;
		report("RENOVICE LIVE LITERALS PLAN REJECT trigger=" + std::string(trigger)
			+ " package=" + package.folder + " key=" + hex64(rejection.key)
			+ " value=" + rejection.value + " reason=" + rejection.reason
			+ " scope=module-local module=stock");
	}
	if (resolution.rejections.size() > maximum_logged_rejections)
	{
		report("RENOVICE LIVE LITERALS PLAN REJECT trigger=" + std::string(trigger)
			+ " package=" + package.folder + " suppressed="
			+ std::to_string(resolution.rejections.size() - maximum_logged_rejections));
	}
	logged = 0;
	for (const auto& plan : resolution.plans)
	{
		if (logged++ == maximum_logged_rejections) break;
		std::string values;
		for (const auto& id : plan.values) values += (values.empty() ? "" : ",") + id;
		report("RENOVICE LIVE LITERALS PLAN trigger=" + std::string(trigger)
			+ " package=" + package.folder + " key=" + hex64(plan.key)
			+ " file=" + plan.file + " patches=" + std::to_string(plan.patches.size())
			+ " values=" + values + " identity=" + plan.identity);
	}
	package.literal_plans = std::move(resolution.plans);
}

std::shared_ptr<const PlanSnapshot> build_snapshot(
	const packages::Snapshot* snapshot,
	const std::function<bool(std::uint64_t)>& owned_by_replacement,
	const char* trigger)
{
	auto result = std::make_shared<PlanSnapshot>();
	if (snapshot == nullptr) return result;
	std::map<std::uint64_t, std::string> owners;
	for (const auto& package : snapshot->packages)
	{
		if (!package.structurally_valid || !package.literal_recipes) continue;
		for (const auto& module : package.literal_recipes->modules) result->recipe_keys.insert(module.key);
		if (!package.accepted) continue;
		for (const auto& plan : package.literal_plans)
		{
			std::string holder;
			if (owned_by_replacement && owned_by_replacement(plan.key)) holder = "replacement";
			else if (const auto found = owners.find(plan.key); found != owners.end()) holder = "package:" + found->second;
			if (!holder.empty())
			{
				if (trigger != nullptr)
				{
					report("RENOVICE LIVE LITERALS PLAN REJECT trigger=" + std::string(trigger)
						+ " package=" + package.folder + " key=" + hex64(plan.key)
						+ " reason=module-owned-by holder=" + holder + " scope=module-local module=holder");
				}
				continue;
			}
			owners.emplace(plan.key, package.folder);
			auto runtime = std::make_shared<RuntimePlan>();
			runtime->plan = plan;
			runtime->package = package.folder;
			result->plans.emplace(plan.key, std::move(runtime));
		}
	}
	if (trigger != nullptr && !result->recipe_keys.empty())
	{
		report("RENOVICE LIVE LITERALS SNAPSHOT trigger=" + std::string(trigger)
			+ " recipe_modules=" + std::to_string(result->recipe_keys.size())
			+ " plans=" + std::to_string(result->plans.size()));
	}
	return result;
}

std::shared_ptr<const PlanSnapshot> active() noexcept
{
	std::lock_guard lock(snapshot_mutex);
	return active_snapshot;
}

void publish(std::shared_ptr<const PlanSnapshot> snapshot) noexcept
{
	std::lock_guard lock(snapshot_mutex);
	active_snapshot = snapshot ? std::move(snapshot) : std::make_shared<const PlanSnapshot>();
	prepared_snapshot.reset();
}

void prepare(std::shared_ptr<const PlanSnapshot> snapshot) noexcept
{
	std::lock_guard lock(snapshot_mutex);
	prepared_snapshot = snapshot ? std::move(snapshot) : std::make_shared<const PlanSnapshot>();
}

void commit_prepared() noexcept
{
	std::lock_guard lock(snapshot_mutex);
	if (!prepared_snapshot) return;
	active_snapshot = std::move(prepared_snapshot);
	prepared_snapshot.reset();
}

void discard_prepared() noexcept
{
	std::lock_guard lock(snapshot_mutex);
	prepared_snapshot.reset();
}

std::shared_ptr<const PlanSnapshot> prepared() noexcept
{
	std::lock_guard lock(snapshot_mutex);
	return prepared_snapshot;
}

std::vector<std::uint64_t> changed_keys(const PlanSnapshot& previous, const PlanSnapshot& next)
{
	std::set<std::uint64_t> changed;
	for (const auto& [key, plan] : previous.plans)
	{
		const auto found = next.plans.find(key);
		if (found == next.plans.end() || found->second->plan.identity != plan->plan.identity) changed.insert(key);
	}
	for (const auto& [key, plan] : next.plans)
	{
		const auto found = previous.plans.find(key);
		if (found == previous.plans.end() || found->second->plan.identity != plan->plan.identity) changed.insert(key);
	}
	return std::vector<std::uint64_t>(changed.begin(), changed.end());
}

std::shared_ptr<const std::vector<unsigned char>> synthesized(
	const PlanSnapshot& snapshot, std::uint64_t key,
	const unsigned char* stock, std::size_t size, const char* source)
{
	const auto found = snapshot.plans.find(key);
	if (found == snapshot.plans.end() || stock == nullptr || size == 0) return nullptr;
	const RuntimePlan& runtime = *found->second;
	std::string line;
	std::shared_ptr<const std::vector<unsigned char>> result;
	try
	{
		std::lock_guard lock(runtime.mutex);
		// A later load of the same key reuses the bytes only when its stock body
		// is exactly the verified stock copy; anything else is re-verified.
		if (runtime.bytes && runtime.stock.size() == size
			&& std::memcmp(runtime.stock.data(), stock, size) == 0)
		{
			return runtime.bytes;
		}
		auto synthesis = synthesize(runtime.plan, stock, size);
		if (!synthesis.error.empty() && synthesis.error == runtime.failure) return nullptr; // reported once
		std::ostringstream message;
		if (synthesis.error.empty())
		{
			runtime.stock.assign(stock, stock + size);
			runtime.bytes = std::make_shared<const std::vector<unsigned char>>(std::move(synthesis.bytes));
			result = runtime.bytes;
			message << "RENOVICE LIVE LITERALS SYNTHESIZE PASS key=" << hex64(key)
				<< " source=" << (source != nullptr ? source : "unknown")
				<< " package=" << runtime.package << " file=" << runtime.plan.file
				<< " patches=" << runtime.plan.patches.size()
				<< " bytes=" << result->size() << " identity=" << runtime.plan.identity;
		}
		else
		{
			runtime.failure = synthesis.error;
			message << "RENOVICE LIVE LITERALS SYNTHESIZE FAIL key=" << hex64(key)
				<< " source=" << (source != nullptr ? source : "unknown")
				<< " package=" << runtime.package << " file=" << runtime.plan.file
				<< " reason=" << synthesis.error << " scope=module-local module=stock";
		}
		line = message.str();
	}
	catch (const std::exception&)
	{
		line = "RENOVICE LIVE LITERALS SYNTHESIZE FAIL key=" + hex64(key) + " reason=native-exception scope=module-local module=stock";
		result.reset();
	}
	if (!line.empty() && synthesis_lines.fetch_add(1, std::memory_order_relaxed) < maximum_synthesis_lines)
		report(line);
	return result;
}
}
