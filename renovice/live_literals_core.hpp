#pragma once

// LIVE_LITERALS_V1: typeable script-literal values (2026-09-30).
//
// Contract: work/research/universal-mission-editor-2026-09-29/CONTRACT_PHASE1.md
// Revision R8 (R5-L "host-side replacement synthesis" + R5-C composition).
//
// A package may ship `literals.json` next to package.json: a declarative
// literal-patch RECIPE per value instead of baked replacement bytes. At every
// committing scan (startup, F9, SCRIPT SETTINGS apply) the host resolves the
// current values into one patch plan per module; the replacement lane then
// synthesizes the module's bytes from the CAPTURED STOCK BYTES (the natural
// load, or the stock body it captured earlier) + the plan, after verifying the
// pinned stock SHA-256 and every preimage. A value that is off or at its
// declared stock adds no patch; a module without patches loads stock.
//
// Old DLLs never read literals.json (a package ignores every non-lua_B file
// except package.json), so the package stays valid there and the recipe values
// simply do not exist (stock). Nothing in this file names a mission, a module
// or a value: the recipe is data, the rules are generic.
//
// Everything here is pure and deterministic, so the offline gate
// (RENOVICE_TOOLCHAIN/replacements/verify_live_literals.ps1) exercises the
// exact rules the DLL uses.
//
// Recipe schema (all fields required unless marked optional):
// {
//   "format": "RENOVICE_LIVE_LITERALS_V1",
//   "package": "package:<folder lower>",        // the package state id
//   "build": "<client build>",                  // equals package.json settings.build
//   "modules": { "<16 hex key>": { "file": "...", "stock_size": N,
//                                  "stock_sha256": "<64 hex>" } },
//   "groups": [ <group declaration> ... ],      // optional; groups only recipe values use
//   "values": {
//     "<value id>": {
//       "declaration": { <ADDON_SETTINGS_V1 value declaration, "lane": "literal"> },
//       "module": "<16 hex key>",
//       "insert_before": "<declared value id>", // optional: display order
//       "drives": [ { "row": "<row id>", "scale": S, "integer": B, "stock": R,
//                     "sites": [ { "kind": "loadn"|"number_constant",
//                                  "offset": N, "expected": "<hex>",
//                                  "register": N,               // loadn
//                                  "rewrites_instruction": true, // optional, loadn
//                                  "constant_gate": "K_CONSTANT_EXCLUSIVE_V1", // number_constant
//                                  "numerator": X, "denominator": Y,
//                                  "inverse": true } ] } ]      // optional
//     } } }
// A value whose single drive names its own id is a DIRECT row value; any other
// value is a MASTER knob (row value = master x scale). A row's own value, when
// it is on, wins over its master (the addon lane's rule, CONTRACT R5-3).

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <initializer_list>
#include <iterator>
#include <map>
#include <memory>
#include <set>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "live_literal_patch_core.hpp"
#include "settings_core.hpp"

namespace renovice::live_literals
{
namespace patch = renovice::live_literal_patch;

inline constexpr std::string_view recipe_filename = "literals.json";
inline constexpr std::string_view recipe_format = "RENOVICE_LIVE_LITERALS_V1";
inline constexpr std::size_t maximum_recipe_bytes = 2u * 1024u * 1024u;
inline constexpr std::size_t maximum_modules = 256;
inline constexpr std::size_t maximum_drives_per_value = 64;
inline constexpr std::size_t maximum_sites_per_drive = 64;
inline constexpr std::size_t maximum_stock_size = 1u << 28;
inline constexpr std::size_t maximum_logged_rejections = 16;

struct ModuleRecipe
{
	std::uint64_t key = 0;
	std::string file;
	std::size_t stock_size = 0;
	std::string stock_sha256; // lower-case hex
};

struct Drive
{
	std::string row;
	double scale = 1.0;
	bool integer_row = false;
	double row_stock = 0.0;
	std::vector<patch::Site> sites;
};

struct ValueRecipe
{
	std::string id;
	std::uint64_t module = 0;
	std::string insert_before;
	std::vector<Drive> drives;
	settings::json::Value declaration; // validated by merge_declarations
	[[nodiscard]] bool direct() const noexcept { return drives.size() == 1 && drives.front().row == id; }
};

struct Recipes
{
	std::string package;
	std::string build;
	std::vector<ModuleRecipe> modules; // sorted by key
	std::vector<settings::GroupDecl> groups;
	std::vector<ValueRecipe> values;   // file order

	[[nodiscard]] const ModuleRecipe* module(std::uint64_t key) const noexcept
	{
		const auto found = std::lower_bound(modules.begin(), modules.end(), key,
			[](const ModuleRecipe& lhs, std::uint64_t rhs) { return lhs.key < rhs; });
		return found != modules.end() && found->key == key ? &*found : nullptr;
	}
	[[nodiscard]] const ValueRecipe* value(std::string_view id) const noexcept
	{
		for (const auto& value : values)
			if (value.id == id) return &value;
		return nullptr;
	}
};

inline std::string hex64(std::uint64_t value)
{
	static constexpr char digits[] = "0123456789abcdef";
	std::string text(16, '0');
	for (int i = 15; i >= 0; --i)
	{
		text[static_cast<std::size_t>(i)] = digits[value & 0xFu];
		value >>= 4;
	}
	return text;
}

inline std::string hex_bytes(const unsigned char* bytes, std::size_t count)
{
	static constexpr char digits[] = "0123456789abcdef";
	std::string text;
	text.reserve(count * 2);
	for (std::size_t n = 0; n != count; ++n)
	{
		text.push_back(digits[bytes[n] >> 4]);
		text.push_back(digits[bytes[n] & 0xFu]);
	}
	return text;
}

namespace detail
{
inline bool parse_key(std::string_view text, std::uint64_t& key) noexcept
{
	if (text.size() != 16) return false;
	std::uint64_t value = 0;
	for (const char c : text)
	{
		int digit = -1;
		if (c >= '0' && c <= '9') digit = c - '0';
		else if (c >= 'a' && c <= 'f') digit = c - 'a' + 10;
		else return false; // lower-case only: one spelling per key
		value = (value << 4) | static_cast<std::uint64_t>(digit);
	}
	if (value == 0) return false;
	key = value;
	return true;
}

inline bool parse_hex(std::string_view text, unsigned char* out, std::size_t count) noexcept
{
	if (text.size() != count * 2) return false;
	for (std::size_t n = 0; n != count; ++n)
	{
		int value = 0;
		for (std::size_t k = 0; k != 2; ++k)
		{
			const char c = text[n * 2 + k];
			int digit = -1;
			if (c >= '0' && c <= '9') digit = c - '0';
			else if (c >= 'a' && c <= 'f') digit = c - 'a' + 10;
			else return false;
			value = value * 16 + digit;
		}
		out[n] = static_cast<unsigned char>(value);
	}
	return true;
}

inline bool whole_in(const settings::json::Value* value, double low, double high, double& out) noexcept
{
	if (value == nullptr || !value->is_number() || !settings::whole(value->number)
		|| value->number < low || value->number > high)
	{
		return false;
	}
	out = value->number;
	return true;
}

inline bool only_fields(const settings::json::Value& object, std::initializer_list<std::string_view> allowed, std::string& unknown)
{
	for (const auto& [key, field] : object.members)
	{
		(void)field;
		if (std::find(allowed.begin(), allowed.end(), key) == allowed.end())
		{
			unknown = key;
			return false;
		}
	}
	return true;
}

inline std::string parse_site(const settings::json::Value& value, patch::Site& site)
{
	if (!value.is_object()) return "site-not-object";
	std::string unknown;
	if (!only_fields(value, {"kind", "offset", "expected", "register", "rewrites_instruction", "constant_gate",
		"numerator", "denominator", "inverse"}, unknown))
	{
		return "site-unknown-field=" + unknown;
	}
	const auto* kind = value.find("kind");
	if (kind == nullptr || !kind->is_string()) return "site-kind-missing";
	if (kind->text == "loadn") site.kind = patch::SiteKind::Loadn;
	else if (kind->text == "number_constant") site.kind = patch::SiteKind::NumberConstant;
	else return "site-kind-invalid=" + kind->text;
	double offset = 0.0;
	if (!whole_in(value.find("offset"), 0.0, static_cast<double>(maximum_stock_size), offset)) return "site-offset-invalid";
	site.offset = static_cast<std::size_t>(offset);
	const auto* expected = value.find("expected");
	if (expected == nullptr || !expected->is_string()
		|| !parse_hex(expected->text, site.expected.data(), patch::width(site.kind)))
	{
		return "site-expected-invalid";
	}
	const auto* rewrites = value.find("rewrites_instruction");
	const auto* gate = value.find("constant_gate");
	const auto* reg = value.find("register");
	if (site.kind == patch::SiteKind::Loadn)
	{
		double number = 0.0;
		if (!whole_in(reg, 0.0, 255.0, number)) return "site-register-invalid";
		site.reg = static_cast<unsigned char>(number);
		if (rewrites != nullptr)
		{
			if (!rewrites->is_bool()) return "site-rewrites_instruction-invalid";
			site.rewrites_instruction = rewrites->boolean;
		}
		if (gate != nullptr) return "site-constant_gate-only-for-number_constant";
	}
	else
	{
		if (reg != nullptr || rewrites != nullptr) return "site-register-only-for-loadn";
		// Shared-constant safety: a constant is admissible only with the
		// registrar's exclusivity proof (bound to the pinned stock SHA-256).
		if (gate == nullptr || !gate->is_string() || gate->text != patch::constant_exclusivity_gate)
			return "site-constant-without-exclusivity-proof";
	}
	const auto* numerator = value.find("numerator");
	const auto* denominator = value.find("denominator");
	if (numerator == nullptr || !numerator->is_number() || denominator == nullptr || !denominator->is_number())
		return "site-scale-invalid";
	site.numerator = numerator->number;
	site.denominator = denominator->number;
	if (const auto* inverse = value.find("inverse"))
	{
		if (!inverse->is_bool()) return "site-inverse-invalid";
		site.inverse = inverse->boolean;
	}
	if (const auto error = patch::shape_error(site); error != patch::Error::None) return patch::error_text(error);
	return {};
}

inline std::string parse_drive(const settings::json::Value& value, Drive& drive)
{
	if (!value.is_object()) return "drive-not-object";
	std::string unknown;
	if (!only_fields(value, {"row", "scale", "integer", "stock", "sites"}, unknown)) return "drive-unknown-field=" + unknown;
	const auto* row = value.find("row");
	if (row == nullptr || !row->is_string() || !settings::valid_value_id(row->text)) return "drive-row-invalid";
	drive.row = row->text;
	const auto* scale = value.find("scale");
	if (scale == nullptr || !scale->is_number() || !(scale->number > 0.0)) return "drive-scale-invalid row=" + drive.row;
	drive.scale = scale->number;
	const auto* integer = value.find("integer");
	if (integer == nullptr || !integer->is_bool()) return "drive-integer-invalid row=" + drive.row;
	drive.integer_row = integer->boolean;
	const auto* stock = value.find("stock");
	if (stock == nullptr || !stock->is_number()) return "drive-stock-invalid row=" + drive.row;
	drive.row_stock = stock->number;
	const auto* sites = value.find("sites");
	if (sites == nullptr || !sites->is_array() || sites->items.empty() || sites->items.size() > maximum_sites_per_drive)
		return "drive-sites-invalid row=" + drive.row;
	for (const auto& item : sites->items)
	{
		patch::Site site;
		if (auto error = parse_site(item, site); !error.empty()) return error + " row=" + drive.row;
		if (const auto error = patch::stock_error(site, drive.row_stock); error != patch::Error::None)
			return std::string(patch::error_text(error)) + " row=" + drive.row + " offset=" + std::to_string(site.offset);
		drive.sites.push_back(site);
	}
	return {};
}
}

// Parses literals.json. Returns an empty string on success, otherwise the exact
// reason that rejects ONLY the live-literal capability of this package.
inline std::string parse_recipes(std::string_view text, std::string_view expected_package, Recipes& out)
{
	out = Recipes{};
	if (text.size() > maximum_recipe_bytes) return "recipe-too-large";
	settings::json::Value root;
	if (auto error = settings::json::parse(text, root); !error.empty()) return "recipe-" + error;
	if (!root.is_object()) return "recipe-not-object";
	std::string unknown;
	if (!detail::only_fields(root, {"format", "package", "build", "modules", "groups", "values"}, unknown))
		return "recipe-unknown-field=" + unknown;
	const auto* format = root.find("format");
	if (format == nullptr || !format->is_string() || format->text != recipe_format)
		return "recipe-format-not-RENOVICE_LIVE_LITERALS_V1";
	const auto* package = root.find("package");
	if (package == nullptr || !package->is_string()) return "recipe-package-missing";
	if (package->text != expected_package)
		return "recipe-package-mismatch expected=" + std::string(expected_package) + " found=" + package->text;
	out.package = package->text;
	const auto* build = root.find("build");
	if (build == nullptr || !build->is_string() || !settings::valid_text(build->text, settings::maximum_text_length, false))
		return "recipe-build-invalid";
	out.build = build->text;
	const auto* modules = root.find("modules");
	if (modules == nullptr || !modules->is_object() || modules->members.empty()) return "recipe-modules-invalid";
	if (modules->members.size() > maximum_modules) return "recipe-too-many-modules";
	for (const auto& [key_text, module] : modules->members)
	{
		ModuleRecipe recipe;
		if (!detail::parse_key(key_text, recipe.key)) return "recipe-module-key-invalid=" + key_text;
		if (!module.is_object()) return "recipe-module-not-object=" + key_text;
		if (!detail::only_fields(module, {"file", "stock_size", "stock_sha256"}, unknown))
			return "recipe-module-unknown-field=" + unknown;
		const auto* file = module.find("file");
		if (file == nullptr || !file->is_string() || !settings::valid_text(file->text, 128, false))
			return "recipe-module-file-invalid=" + key_text;
		recipe.file = file->text;
		double size = 0.0;
		if (!detail::whole_in(module.find("stock_size"), 1.0, static_cast<double>(maximum_stock_size - 1), size))
			return "recipe-module-stock_size-invalid=" + key_text;
		recipe.stock_size = static_cast<std::size_t>(size);
		const auto* sha = module.find("stock_sha256");
		unsigned char digest[32]{};
		if (sha == nullptr || !sha->is_string() || !detail::parse_hex(sha->text, digest, 32))
			return "recipe-module-stock_sha256-invalid=" + key_text;
		recipe.stock_sha256 = sha->text;
		out.modules.push_back(std::move(recipe));
	}
	std::sort(out.modules.begin(), out.modules.end(),
		[](const ModuleRecipe& lhs, const ModuleRecipe& rhs) { return lhs.key < rhs.key; });
	if (std::adjacent_find(out.modules.begin(), out.modules.end(),
		[](const ModuleRecipe& lhs, const ModuleRecipe& rhs) { return lhs.key == rhs.key; }) != out.modules.end())
	{
		return "recipe-module-duplicate";
	}
	if (const auto* groups = root.find("groups"))
	{
		if (!groups->is_array() || groups->items.size() > settings::maximum_groups_per_package) return "recipe-groups-invalid";
		for (const auto& item : groups->items)
		{
			settings::GroupDecl group;
			if (auto error = settings::detail::parse_group(item, group); !error.empty()) return "recipe-" + error;
			for (const auto& existing : out.groups)
				if (existing.id == group.id) return "recipe-group-duplicate=" + group.id;
			out.groups.push_back(std::move(group));
		}
	}
	const auto* values = root.find("values");
	if (values == nullptr || !values->is_object() || values->members.empty()) return "recipe-values-invalid";
	if (values->members.size() > settings::maximum_values_per_package) return "recipe-too-many-values";
	for (const auto& [id, value] : values->members)
	{
		if (!settings::valid_value_id(id)) return "recipe-value-id-invalid=" + id;
		const std::string where = " value=" + id;
		if (!value.is_object()) return "recipe-value-not-object" + where;
		if (!detail::only_fields(value, {"declaration", "module", "insert_before", "drives"}, unknown))
			return "recipe-value-unknown-field=" + unknown + where;
		ValueRecipe recipe;
		recipe.id = id;
		const auto* declaration = value.find("declaration");
		if (declaration == nullptr || !declaration->is_object()) return "recipe-declaration-missing" + where;
		recipe.declaration = *declaration;
		const auto* module = value.find("module");
		if (module == nullptr || !module->is_string() || !detail::parse_key(module->text, recipe.module))
			return "recipe-value-module-invalid" + where;
		const ModuleRecipe* owner = out.module(recipe.module);
		if (owner == nullptr) return "recipe-value-module-not-declared" + where;
		if (const auto* before = value.find("insert_before"))
		{
			if (!before->is_string() || !settings::valid_value_id(before->text)) return "recipe-insert_before-invalid" + where;
			recipe.insert_before = before->text;
		}
		const auto* drives = value.find("drives");
		if (drives == nullptr || !drives->is_array() || drives->items.empty()
			|| drives->items.size() > maximum_drives_per_value)
		{
			return "recipe-drives-invalid" + where;
		}
		std::set<std::string> rows;
		for (const auto& item : drives->items)
		{
			Drive drive;
			if (auto error = detail::parse_drive(item, drive); !error.empty()) return "recipe-" + error + where;
			if (!rows.insert(drive.row).second) return "recipe-drive-row-duplicate row=" + drive.row + where;
			for (const auto& site : drive.sites)
			{
				if (site.offset + patch::width(site.kind) > owner->stock_size)
					return "recipe-site-outside-stock-size row=" + drive.row + where;
			}
			recipe.drives.push_back(std::move(drive));
		}
		for (const auto& existing : out.values)
			if (existing.id == id) return "recipe-value-duplicate" + where;
		out.values.push_back(std::move(recipe));
	}
	// Every row keeps one site set across the values that drive it (a master
	// and the row's own value), and distinct rows of one module never share a
	// byte (the registrar's competing-owner rule, re-verified here).
	std::map<std::pair<std::uint64_t, std::string>, const Drive*> rows;
	for (const auto& value : out.values)
	{
		for (const auto& drive : value.drives)
		{
			const auto [slot, inserted] = rows.emplace(std::make_pair(value.module, drive.row), &drive);
			if (inserted) continue;
			const Drive& other = *slot->second;
			bool same = other.sites.size() == drive.sites.size() && other.row_stock == drive.row_stock
				&& other.integer_row == drive.integer_row;
			for (std::size_t n = 0; same && n != drive.sites.size(); ++n)
			{
				const auto& a = other.sites[n];
				const auto& b = drive.sites[n];
				same = a.kind == b.kind && a.offset == b.offset && a.expected == b.expected && a.reg == b.reg
					&& a.rewrites_instruction == b.rewrites_instruction && a.inverse == b.inverse
					&& a.numerator == b.numerator && a.denominator == b.denominator;
			}
			if (!same) return "recipe-row-sites-disagree row=" + drive.row;
		}
	}
	for (auto lhs = rows.begin(); lhs != rows.end(); ++lhs)
	{
		for (auto rhs = std::next(lhs); rhs != rows.end() && rhs->first.first == lhs->first.first; ++rhs)
		{
			for (const auto& a : lhs->second->sites)
				for (const auto& b : rhs->second->sites)
					if (patch::overlaps(a, b))
						return "recipe-sites-overlap rows=" + lhs->first.second + "," + rhs->first.second;
		}
	}
	// Each row has at most one direct value and at most one master.
	std::map<std::pair<std::uint64_t, std::string>, std::pair<int, int>> drivers;
	for (const auto& value : out.values)
	{
		for (const auto& drive : value.drives)
		{
			auto& count = drivers[std::make_pair(value.module, drive.row)];
			(value.direct() ? count.first : count.second) += 1;
			if (count.first > 1 || count.second > 1) return "recipe-row-driven-twice row=" + drive.row;
		}
	}
	return {};
}

// Merges the recipe values (and recipe-only groups) into the package's parsed
// declarations. Every value goes through the unchanged ADDON_SETTINGS_V1
// declaration parser with `member` = literals.json; it must be a literal-lane
// int or float value whose declared stock is exactly what the stock bytes hold
// and whose whole declared range encodes at every site. On success the merged
// values are typeable in game (`live_literal`).
inline std::string merge_declarations(const Recipes& recipes, settings::Declarations& declarations)
{
	if (!declarations.build.empty() && declarations.build != recipes.build)
		return "recipe-build-mismatch declarations=" + declarations.build + " recipe=" + recipes.build;
	settings::Declarations merged = declarations;
	if (merged.build.empty()) merged.build = recipes.build;
	for (const auto& group : recipes.groups)
	{
		if (merged.group(group.id) != nullptr) return "recipe-group-already-declared=" + group.id;
		if (merged.groups.size() >= settings::maximum_groups_per_package) return "recipe-too-many-groups";
		merged.groups.push_back(group);
	}
	for (const auto& recipe : recipes.values)
	{
		if (merged.value(recipe.id) != nullptr) return "recipe-value-already-declared=" + recipe.id;
		if (merged.values.size() >= settings::maximum_values_per_package) return "recipe-too-many-values";
		settings::ValueDecl declaration;
		if (auto error = settings::detail::parse_value_decl(
			recipe.id, recipe.declaration, std::string(recipe_filename), merged.groups, declaration); !error.empty())
		{
			return "recipe-" + error;
		}
		const std::string where = " value=" + recipe.id;
		if (declaration.lane != settings::Lane::Literal) return "recipe-declaration-lane-not-literal" + where;
		if (declaration.type == settings::ValueType::Enum) return "recipe-declaration-enum-not-supported" + where;
		// The declared default must be the stock the player gets: the direct
		// row's recorded stock, or for a master the first row's stock through
		// its scale (exactly what the stock bytes hold, checked at parse).
		const Drive& first = recipe.drives.front();
		if (patch::row_value(declaration.stock, recipe.direct() ? 1.0 : first.scale, first.integer_row) != first.row_stock)
			return "recipe-declared-stock-disagrees-with-row" + where;
		for (const auto& drive : recipe.drives)
		{
			const double scale = recipe.direct() ? 1.0 : drive.scale;
			for (const double end : {declaration.minimum, declaration.maximum})
			{
				const double row = patch::row_value(end, scale, drive.integer_row);
				for (const auto& site : drive.sites)
				{
					if (patch::operand_error(site, row) != patch::Error::None)
						return "recipe-declared-range-outside-operand-domain row=" + drive.row + where;
				}
			}
		}
		declaration.live_literal = true;
		declaration.stock_check = settings::StockCheck::None; // the host patches; no live stock comparison
		auto position = merged.values.end();
		if (!recipe.insert_before.empty())
		{
			position = std::find_if(merged.values.begin(), merged.values.end(),
				[&](const settings::ValueDecl& value) { return value.id == recipe.insert_before; });
		}
		merged.values.insert(position, std::move(declaration));
	}
	declarations = std::move(merged);
	return {};
}

// ---------------------------------------------------------------------------
// Plan resolution (committing scans).
// ---------------------------------------------------------------------------
struct ModulePlan
{
	std::uint64_t key = 0;
	std::string file;
	std::size_t stock_size = 0;
	std::string stock_sha256;
	std::vector<patch::Patch> patches;     // sorted by offset
	std::vector<std::string> values;       // contributing value ids, sorted
	std::string identity;                  // stable digest of key, stock and patches
};

struct PlanRejection
{
	std::uint64_t key = 0;
	std::string value;
	std::string reason;
};

struct Resolution
{
	std::vector<ModulePlan> plans;           // sorted by key; only modules with patches
	std::vector<PlanRejection> rejections;   // modules held at stock, with the exact reason
};

inline std::string plan_identity(const ModulePlan& plan)
{
	std::string canonical = "LIVE_LITERALS_V1\n" + hex64(plan.key) + "\n" + plan.stock_sha256 + "\n"
		+ std::to_string(plan.stock_size) + "\n";
	for (const auto& item : plan.patches)
	{
		canonical += std::to_string(item.site.offset) + ":" + hex_bytes(item.site.expected.data(), patch::width(item.site.kind))
			+ ">" + hex_bytes(item.bytes.data(), patch::width(item.site.kind)) + "\n";
	}
	return "live-literals-v1:" + settings::sha256_hex(canonical).substr(0, 32);
}

// `state` is the parsed values file when it is valid (else nullptr: every
// value stock). A value APPLIES when it is effective (on, valid, section on,
// package not on stock) and differs from its declared stock.
inline Resolution resolve_plans(
	const Recipes& recipes,
	const settings::Declarations& declarations,
	const settings::UserState* state,
	const settings::PackageEvaluation& evaluation)
{
	Resolution result;
	if (state == nullptr || evaluation.file != settings::FileStatus::Valid || evaluation.use_stock) return result;
	struct Choice
	{
		bool direct_on = false;
		double direct_value = 0.0;
		bool master_applied = false;
		double master_value = 0.0;
		const ValueRecipe* master = nullptr;
		const ValueRecipe* direct = nullptr;
		const Drive* drive = nullptr;
		double scale = 1.0;
	};
	std::map<std::uint64_t, std::map<std::string, Choice>> modules;
	for (const auto& recipe : recipes.values)
	{
		const auto* declaration = declarations.value(recipe.id);
		if (declaration == nullptr || !declaration->live_literal) continue;
		const bool effective = evaluation.effective.count(recipe.id) != 0;
		const auto entry = state->values.find(recipe.id);
		if (!effective || entry == state->values.end() || !entry->second.has_value) continue;
		const double value = entry->second.value;
		for (const auto& drive : recipe.drives)
		{
			auto& choice = modules[recipe.module][drive.row];
			choice.drive = &drive;
			if (recipe.direct())
			{
				choice.direct_on = true;
				choice.direct_value = value;
				choice.direct = &recipe;
			}
			else if (value != declaration->stock)
			{
				choice.master_applied = true;
				choice.master_value = value;
				choice.master = &recipe;
				choice.scale = drive.scale;
			}
		}
	}
	for (const auto& [key, rows] : modules)
	{
		const ModuleRecipe* module = recipes.module(key);
		if (module == nullptr) continue;
		ModulePlan plan;
		plan.key = key;
		plan.file = module->file;
		plan.stock_size = module->stock_size;
		plan.stock_sha256 = module->stock_sha256;
		std::set<std::string> contributing;
		bool rejected = false;
		for (const auto& [row, choice] : rows)
		{
			double row_value = 0.0;
			const ValueRecipe* source = nullptr;
			if (choice.direct_on)
			{
				// The row's own value wins; at its stock the row stays stock.
				if (choice.direct_value == choice.drive->row_stock) continue;
				row_value = choice.direct_value;
				source = choice.direct;
			}
			else if (choice.master_applied)
			{
				row_value = patch::row_value(choice.master_value, choice.scale, choice.drive->integer_row);
				source = choice.master;
			}
			else continue;
			for (const auto& site : choice.drive->sites)
			{
				patch::Patch item;
				item.site = site;
				if (const auto error = patch::encode(site, row_value, item.bytes); error != patch::Error::None)
				{
					result.rejections.push_back({key, source->id, std::string(patch::error_text(error))
						+ " row=" + row + " offset=" + std::to_string(site.offset)});
					rejected = true;
					break;
				}
				plan.patches.push_back(item);
			}
			if (rejected) break;
			contributing.insert(source->id);
		}
		if (rejected || plan.patches.empty()) continue;
		std::sort(plan.patches.begin(), plan.patches.end(),
			[](const patch::Patch& lhs, const patch::Patch& rhs) { return lhs.site.offset < rhs.site.offset; });
		plan.values.assign(contributing.begin(), contributing.end());
		plan.identity = plan_identity(plan);
		result.plans.push_back(std::move(plan));
	}
	return result;
}

// ---------------------------------------------------------------------------
// Synthesis (runtime: the captured stock bytes of one natural load).
// ---------------------------------------------------------------------------
struct Synthesis
{
	std::vector<unsigned char> bytes;
	std::string error; // empty on success
};

inline Synthesis synthesize(const ModulePlan& plan, const unsigned char* stock, std::size_t size)
{
	Synthesis result;
	if (stock == nullptr || size != plan.stock_size)
	{
		result.error = "stock-size-mismatch expected=" + std::to_string(plan.stock_size) + " found=" + std::to_string(size);
		return result;
	}
	const auto digest = settings::sha256_hex(std::string_view(reinterpret_cast<const char*>(stock), size));
	if (digest != plan.stock_sha256)
	{
		result.error = "stock-sha256-mismatch expected=" + plan.stock_sha256.substr(0, 16) + " found=" + digest.substr(0, 16);
		return result;
	}
	std::size_t failed = 0;
	const auto error = patch::apply(stock, size, plan.patches, result.bytes, failed);
	if (error != patch::Error::None)
	{
		result.bytes.clear();
		result.error = std::string(patch::error_text(error));
		if (failed < plan.patches.size()) result.error += " offset=" + std::to_string(plan.patches[failed].site.offset);
	}
	return result;
}
}
