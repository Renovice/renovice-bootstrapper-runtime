// Deterministic gate for LIVE_LITERALS_V1 (2026-09-30): typeable script-literal
// values synthesized by the host from captured stock bytes + a recipe.
//
// Part 1: the shared patch core (renovice/live_literal_patch_core.hpp): operand,
//         domain, LOADN / native f64 encoding, preimage verification, overlap,
//         permitted-diff application, master row values.
// Part 2: the recipe parser and declaration merge (live_literals_core.hpp) on
//         the real generated Missions recipe, plus negative cases (each one a
//         single mutation of the real file).
// Part 3: plan resolution and synthesis against the real U44 stock bytes: the
//         five values of the staged baked package (Mobile Defense 20 s, Void
//         Flood 4, Excavation 50 s, Control Area 30 s Plains and Cambion) must
//         reproduce the staged exact replacements byte for byte; precedence,
//         stock, off and fail-closed cases.
// Part 4: the exact renovice/packages.cpp scanner + renovice/live_literals.cpp
//         end to end (stub config and policy providers): recipe attach, merged
//         declarations and order, plans per values file, recipe rejection that
//         leaves the package intact, snapshot ownership, changed keys, the
//         synthesis cache and its fail-closed path.
// Part 5: SCRIPT SETTINGS page model, merged R7 + R8 (contract R9): a live
//         literal value is a normal R7 value (one row, value page = stepper or
//         text box + "Reset to default", default = its stock shown through
//         `default_label` for a range, Quick settings with a kept value); a
//         typed value goes through staging, the values file writer and the
//         plan resolution to the exact synthesized bytes; typing the default
//         (or Reset to default) removes the plan; a baked literal stays
//         read-only.
//
// Usage: verify_live_literals <work dir> <fixture dir> <stock corpus dir|-> <baked dir|->
#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <map>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

#include "../../renovice/config.hpp"
#include "../../renovice/live_literals.hpp"
#include "../../renovice/packages.hpp"
#include "../../renovice/script_control.hpp"
#include "../../renovice/settings_ui_core.hpp"

namespace gate
{
std::filesystem::path root;
std::filesystem::path inject;
std::vector<std::string> log_lines;
std::map<std::string, bool> policy;
}

namespace renovice::config
{
const std::filesystem::path& custom_scripts_directory() noexcept { return gate::root; }
const std::filesystem::path& injection_directory() noexcept { return gate::inject; }
void log(std::string_view message) noexcept
{
	try { gate::log_lines.emplace_back(message); } catch (...) {}
}
}

namespace renovice::script_control
{
bool candidate_enabled(std::string_view id)
{
	const auto found = gate::policy.find(std::string(id));
	return found == gate::policy.end() || found->second;
}
}

namespace
{
using namespace renovice;
namespace patch = renovice::live_literal_patch;
namespace ll = renovice::live_literals;
bool pass = true;

void check(bool result, const std::string& name)
{
	std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
	pass &= result;
}

std::string read_text(const std::filesystem::path& path)
{
	std::ifstream input(path, std::ios::binary);
	return std::string(std::istreambuf_iterator<char>(input), {});
}

void write_text(const std::filesystem::path& path, std::string_view text)
{
	std::filesystem::create_directories(path.parent_path());
	std::ofstream output(path, std::ios::binary | std::ios::trunc);
	output.write(text.data(), static_cast<std::streamsize>(text.size()));
}

bool logged(std::string_view needle)
{
	return std::any_of(gate::log_lines.begin(), gate::log_lines.end(),
		[&](const std::string& line) { return line.find(needle) != std::string::npos; });
}

std::string replace_once(std::string text, std::string_view from, std::string_view to)
{
	const auto at = text.find(from);
	if (at == std::string::npos) return {};
	text.replace(at, from.size(), to);
	return text;
}

// Replaces the first `from` after the first `anchor` (empty string when either is missing).
std::string replace_after(std::string text, std::string_view anchor, std::string_view from, std::string_view to)
{
	const auto base = text.find(anchor);
	if (base == std::string::npos) return {};
	const auto at = text.find(from, base);
	if (at == std::string::npos) return {};
	text.replace(at, from.size(), to);
	return text;
}

patch::Site loadn(std::size_t offset, unsigned char reg, int stock)
{
	patch::Site site;
	site.kind = patch::SiteKind::Loadn;
	site.offset = offset;
	site.reg = reg;
	site.expected = {0x08, reg, static_cast<unsigned char>(stock & 0xFF), static_cast<unsigned char>((stock >> 8) & 0xFF), 0, 0, 0, 0};
	return site;
}

// ---------------------------------------------------------------------------
void part1_core()
{
	std::array<unsigned char, 8> out{};
	auto site = loadn(4, 18, 240);
	check(patch::encode(site, 60.0, out) == patch::Error::None && out[0] == 0x08 && out[1] == 18 && out[2] == 60 && out[3] == 0,
		"core: LOADN encode {08, reg, imm16 LE}");
	check(patch::encode(site, 32767.0, out) == patch::Error::None && out[2] == 0xFF && out[3] == 0x7F, "core: LOADN 32767 encodes");
	check(patch::encode(site, 32768.0, out) == patch::Error::OperandOutOfDomain, "core: LOADN 32768 rejected (domain)");
	check(patch::encode(site, 0.0, out) == patch::Error::OperandOutOfDomain, "core: LOADN 0 rejected (domain 1..32767)");
	check(patch::encode(site, 2.5, out) == patch::Error::OperandOutOfDomain, "core: LOADN fraction rejected");
	patch::Site constant;
	constant.kind = patch::SiteKind::NumberConstant;
	constant.offset = 9;
	check(patch::encode(constant, 0.35, out) == patch::Error::None && std::bit_cast<double>(out) == 0.35,
		"core: constant encodes the f64 bits little-endian");
	check(patch::encode(constant, std::numeric_limits<double>::infinity(), out) == patch::Error::OperandNotFinite,
		"core: non-finite constant rejected");
	site.numerator = 3.0;
	check(patch::operand(site, 20.0) == 60.0, "core: operand = value x numerator / denominator");
	site.numerator = 1.0;
	patch::Site inverse = site;
	inverse.inverse = true;
	inverse.numerator = 120.0;
	check(patch::operand(inverse, 4.0) == 30.0, "core: inverse operand = numerator / value");
	check(patch::row_value(20.0, 3.0, true) == 60.0 && patch::row_value(50.0, 1.4, true) == 70.0
		&& patch::row_value(0.5, 3.0, false) == 1.5, "core: master row value (llround for integer rows)");
	check(patch::stock_error(site, 240.0) == patch::Error::None && patch::stock_error(site, 180.0) == patch::Error::StockDisagrees,
		"core: recorded stock must be what the preimage encodes");
	std::vector<unsigned char> body = {1, 2, 3, 4, 0x08, 18, 240, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9};
	const double stock_constant = 1.25;
	std::memcpy(body.data() + 9, &stock_constant, 8);
	std::memcpy(constant.expected.data(), &stock_constant, 8);
	check(patch::verify(site, body.data(), body.size()) == patch::Error::None, "core: verify LOADN preimage");
	check(patch::verify(constant, body.data(), body.size()) == patch::Error::None, "core: verify constant with tag byte 2");
	auto bad = site;
	bad.offset = 17;
	check(patch::verify(bad, body.data(), body.size()) == patch::Error::Extent, "core: extent outside body rejected");
	bad = site;
	bad.expected[2] = 180;
	check(patch::verify(bad, body.data(), body.size()) == patch::Error::PreimageChanged, "core: changed preimage rejected");
	bad = site;
	bad.reg = 17;
	bad.expected[1] = 18;
	check(patch::verify(bad, body.data(), body.size()) == patch::Error::NotLoadnOfRegister, "core: LOADN of another register rejected");
	auto moved = constant;
	moved.offset = 8;
	std::memcpy(moved.expected.data(), body.data() + 8, 8);
	check(patch::verify(moved, body.data(), body.size()) == patch::Error::ConstantTag, "core: constant without the tag byte rejected");
	patch::Patch a;
	a.site = site;
	(void)patch::encode(site, 60.0, a.bytes);
	patch::Patch b;
	b.site = constant;
	(void)patch::encode(constant, 2.5, b.bytes);
	std::vector<unsigned char> result;
	std::size_t failed = 0;
	check(patch::apply(body.data(), body.size(), {a, b}, result, failed) == patch::Error::None && result.size() == body.size()
		&& result[6] == 60 && std::memcmp(result.data() + 9, b.bytes.data(), 8) == 0 && result[0] == 1 && result[18] == 9,
		"core: apply changes exactly the patched extents");
	patch::Patch c = a;
	c.site.offset = 6;
	check(patch::apply(body.data(), body.size(), {a, c}, result, failed) != patch::Error::None && result.empty(),
		"core: overlapping or unverified patches fail closed (no output)");
}

// ---------------------------------------------------------------------------
struct Fixture
{
	std::string recipe;
	std::string manifest;
	std::vector<std::string> expected_order;
};

ll::Recipes parse_ok(const std::string& text)
{
	ll::Recipes recipes;
	const auto error = ll::parse_recipes(text, "package:missions", recipes);
	if (!error.empty()) std::cout << "INFO\tparse error: " << error << '\n';
	return recipes;
}

std::string parse_error(const std::string& text)
{
	ll::Recipes recipes;
	return ll::parse_recipes(text, "package:missions", recipes);
}

settings::Declarations manifest_declarations(const std::string& manifest_text)
{
	packages::Manifest manifest;
	(void)packages::parse_manifest(manifest_text, manifest);
	std::vector<std::pair<std::string, std::string>> members;
	for (const auto& member : manifest.members)
		if (!member.settings_json.empty()) members.emplace_back(member.filename, member.settings_json);
	settings::Declarations declarations;
	const auto error = settings::parse_declarations(manifest.settings_json, members, declarations);
	if (!error.empty()) std::cout << "INFO\tdeclarations error: " << error << '\n';
	return declarations;
}

void part2_recipe(const Fixture& fixture, ll::Recipes& recipes, settings::Declarations& merged)
{
	check(parse_error(fixture.recipe).empty(), "recipe: the generated Missions recipe parses");
	recipes = parse_ok(fixture.recipe);
	std::size_t masters = 0, sites = 0, constants = 0, rewrites = 0;
	for (const auto& value : recipes.values)
	{
		masters += value.direct() ? 0 : 1;
		for (const auto& drive : value.drives)
			for (const auto& site : drive.sites)
			{
				++sites;
				constants += site.kind == patch::SiteKind::NumberConstant ? 1 : 0;
				rewrites += site.rewrites_instruction ? 1 : 0;
			}
	}
	std::cout << "INFO\trecipe values=" << recipes.values.size() << " masters=" << masters << " modules=" << recipes.modules.size()
		<< " sites=" << sites << " constant_sites=" << constants << " rewrite_sites=" << rewrites << '\n';
	check(recipes.values.size() >= 100 && recipes.modules.size() >= 25 && masters >= 10 && constants > 0 && rewrites > 0,
		"recipe: headline scope (>= 100 values, masters, constant and rewritten-instruction sites)");
	merged = manifest_declarations(fixture.manifest);
	const auto before = merged.values.size();
	check(ll::merge_declarations(recipes, merged).empty() && merged.values.size() == before + recipes.values.size(),
		"merge: every recipe value joins the package declarations");
	const auto* md = merged.value("mobiledefense.time_per_terminal");
	check(md != nullptr && md->live_literal && md->lane == settings::Lane::Literal && md->member == "literals.json"
		&& md->stock == 80.0 && md->stock_check == settings::StockCheck::None && settings::editable_in_game(*md),
		"merge: a recipe value is a typeable live literal (member literals.json, stock 80)");
	std::vector<std::string> order;
	for (const auto& value : merged.values)
		if (value.group == "mobiledefense" || value.group == "defense") order.push_back(value.group + " " + value.id);
	check(order == fixture.expected_order, "merge: insert_before places recipe values in the generator's section order");

	struct Mutation { std::string from, to, reason; };
	const std::vector<Mutation> mutations = {
		{"\"format\": \"RENOVICE_LIVE_LITERALS_V1\"", "\"format\": \"RENOVICE_LIVE_LITERALS_V2\"", "recipe-format-not-RENOVICE_LIVE_LITERALS_V1"},
		{"\"package\": \"package:missions\"", "\"package\": \"package:other\"", "recipe-package-mismatch"},
		{"\"format\": \"RENOVICE_LIVE_LITERALS_V1\"", "\"format\": \"RENOVICE_LIVE_LITERALS_V1\", \"extra\": 1", "recipe-unknown-field=extra"},
		{"\"stock_sha256\": \"", "\"stock_sha256\": \"zz", "recipe-module-stock_sha256-invalid"},
		{"\"constant_gate\": \"K_CONSTANT_EXCLUSIVE_V1\"", "\"constant_gate\": \"none\"", "site-constant-without-exclusivity-proof"},
		{"\"kind\": \"loadn\"", "\"kind\": \"jump\"", "site-kind-invalid=jump"},
		{"\"expected\": \"08", "\"expected\": \"0808", "site-expected-invalid"},
		{"\"module\": \"", "\"module\": \"0000000000000009\", \"x\": \"", "recipe-value-unknown-field=x"},
	};
	for (const auto& mutation : mutations)
	{
		const auto text = replace_once(fixture.recipe, mutation.from, mutation.to);
		const auto error = text.empty() ? std::string("mutation-not-applied") : parse_error(text);
		check(error.find(mutation.reason) != std::string::npos, "recipe reject: " + mutation.reason + " (" + error + ")");
	}
	// A recorded row stock that disagrees with the preimage (Mobile Defense maximum 240 -> 241).
	{
		const auto text = replace_after(fixture.recipe, "\"row\": \"mobiledefense.total_time.maximum\"", "\"stock\": 240", "\"stock\": 241");
		const auto error = text.empty() ? std::string("mutation-not-applied") : parse_error(text);
		check(error.find("stock-value-disagrees-with-preimage") != std::string::npos, "recipe reject: stock disagrees with the preimage (" + error + ")");
	}
	// Overlap and double drive: an extra value inserted at the head of "values".
	const std::string site_text = "{\"kind\": \"loadn\", \"offset\": 21642, \"expected\": \"0812f000\", \"register\": 18, \"numerator\": 1, \"denominator\": 1}";
	const auto extra_value = [&](const std::string& id, const std::string& row, int scale)
	{
		return "\"" + id + "\": {\"declaration\": {\"group\": \"mobiledefense\", \"label\": \"Gate extra\", \"unit\": \"s\", \"type\": \"int\", "
			"\"stock\": " + std::to_string(240 / scale) + ", \"min\": 1, \"max\": 100, \"scope\": \"gate\", \"lane\": \"literal\", "
			"\"applies\": \"next_mission\"}, \"module\": \"a807aae359ffc1eb\", \"drives\": [{\"row\": \"" + row + "\", \"scale\": "
			+ std::to_string(scale) + ", \"integer\": true, \"stock\": 240, \"sites\": [" + site_text + "]}]},\n    ";
	};
	{
		const auto text = replace_once(fixture.recipe, "\"values\": {\n    ", "\"values\": {\n    " + extra_value("gate.overlap", "gate.overlap", 1));
		const auto error = text.empty() ? std::string("mutation-not-applied") : parse_error(text);
		check(error.find("recipe-sites-overlap") != std::string::npos, "recipe reject: two rows share a site byte (" + error + ")");
	}
	{
		const auto text = replace_once(fixture.recipe, "\"values\": {\n    ",
			"\"values\": {\n    " + extra_value("gate.second_master", "mobiledefense.total_time.maximum", 3));
		const auto error = text.empty() ? std::string("mutation-not-applied") : parse_error(text);
		check(error.find("recipe-row-driven-twice") != std::string::npos, "recipe reject: a row driven by two masters (" + error + ")");
	}
	// Merge rejects: declared stock that is not what the bytes hold; range outside the operand domain; addon lane.
	{
		const auto text = replace_after(fixture.recipe, "\"mobiledefense.time_per_terminal\": {", "\"stock\": 80,", "\"stock\": 81,");
		ll::Recipes r;
		settings::Declarations d = manifest_declarations(fixture.manifest);
		const auto error = text.empty() ? std::string("mutation-not-applied")
			: (ll::parse_recipes(text, "package:missions", r).empty() ? ll::merge_declarations(r, d) : std::string("parse"));
		check(error.find("recipe-declared-stock-disagrees-with-row") != std::string::npos,
			"merge reject: declared stock is not what the stock bytes hold (" + error + ")");
	}
	{
		auto text = fixture.recipe;
		const auto at = text.find("\"declaration\": {\n        \"group\": \"hijack\"");
		const auto max_at = at == std::string::npos ? std::string::npos : text.find("\"max\": 32767", at);
		if (max_at != std::string::npos) text.replace(max_at, 12, "\"max\": 40000");
		ll::Recipes r;
		settings::Declarations d = manifest_declarations(fixture.manifest);
		const auto error = max_at == std::string::npos ? std::string("mutation-not-applied")
			: (ll::parse_recipes(text, "package:missions", r).empty() ? ll::merge_declarations(r, d) : std::string("parse"));
		check(error.find("recipe-declared-range-outside-operand-domain") != std::string::npos,
			"merge reject: a declared range beyond the LOADN domain (" + error + ")");
	}
	{
		auto text = replace_once(fixture.recipe, "\"lane\": \"literal\"", "\"lane\": \"addon\"");
		ll::Recipes r;
		settings::Declarations d = manifest_declarations(fixture.manifest);
		const auto error = text.empty() ? std::string("mutation-not-applied")
			: (ll::parse_recipes(text, "package:missions", r).empty() ? ll::merge_declarations(r, d) : std::string("parse"));
		check(error.find("recipe-declaration-lane-not-literal") != std::string::npos, "merge reject: an addon-lane declaration (" + error + ")");
	}
	{
		settings::Declarations d = manifest_declarations(fixture.manifest);
		d.build = "2026.01.01.00.00";
		check(ll::merge_declarations(recipes, d).find("recipe-build-mismatch") == 0, "merge reject: recipe for another client build");
	}
	{
		settings::Declarations d = manifest_declarations(fixture.manifest);
		settings::ValueDecl clash;
		clash.id = recipes.values.front().id;
		d.values.push_back(clash);
		check(ll::merge_declarations(recipes, d).find("recipe-value-already-declared=") == 0, "merge reject: a value id already in package.json");
	}
}

// ---------------------------------------------------------------------------
settings::UserState state_with(const settings::Declarations& declarations, const std::map<std::string, std::pair<bool, double>>& values)
{
	settings::UserState state;
	state.package = "package:missions";
	state.build = declarations.build;
	for (const auto& [id, entry] : values)
	{
		settings::UserValue value;
		value.enabled = entry.first;
		value.has_value = true;
		value.value = entry.second;
		if (const auto* declaration = declarations.value(id)) { value.has_stock = true; value.stock = declaration->stock; }
		state.values[id] = value;
	}
	return state;
}

ll::Resolution resolve(const ll::Recipes& recipes, const settings::Declarations& merged, const settings::UserState& state)
{
	const auto evaluation = settings::evaluate(merged, &state, {});
	return ll::resolve_plans(recipes, merged, &state, evaluation);
}

const ll::ModulePlan* plan_of(const ll::Resolution& resolution, std::uint64_t key)
{
	for (const auto& plan : resolution.plans)
		if (plan.key == key) return &plan;
	return nullptr;
}

void part3_synthesis(const ll::Recipes& recipes, const settings::Declarations& merged,
	const std::filesystem::path& corpus, const std::filesystem::path& baked)
{
	// Pinned SHA-256 of the staged baked exact replacements (work/staging/missions-full-package, generator 4511059).
	struct Baked { std::uint64_t key; const char* file; const char* sha; };
	const std::vector<Baked> staged = {
		{0xa807aae359ffc1ebull, "a807aae359ffc1eb (missions_exact-replacement).lua_B", "fff653e0efb3e6a4074b668d1ec3050a3fa1ae0a0ed3c06f7614521e3ad0e847"},
		{0xfc711ff621a75552ull, "fc711ff621a75552 (missions_exact-replacement).lua_B", "e979f5e7906f0d88e49c42b4191eca6afdc1237fddd91d52cbf427db3fa9f6d2"},
		{0xf7444e3c621ff018ull, "f7444e3c621ff018 (missions_exact-replacement).lua_B", "66b4f9349c0ec7fb45a457dfc2eed5d49c102c7b79e0c1183a6a874e8e7830e7"},
		{0xb3a5a18d68d61e16ull, "b3a5a18d68d61e16 (missions_exact-replacement).lua_B", "e2e8bb2f5b67aec1540245b18ac1786a4ab3ebe485d51faafc27ecb6add27e57"},
		{0x8a0b0819de60df01ull, "8a0b0819de60df01 (missions_exact-replacement).lua_B", "f0436757c021bdd7c9121dd57031791d0f8eb9aada9939727e488c783c1e134b"},
	};
	const auto state = state_with(merged, {
		{"mobiledefense.time_per_terminal", {true, 20}}, {"void_flood.fractures_per_round.normal", {true, 4}},
		{"excavation.dig_time", {true, 50}}, {"control_area_plains.duration", {true, 30}}, {"control_area_deimos.duration", {true, 30}}});
	const auto resolution = resolve(recipes, merged, state);
	check(resolution.plans.size() == 5 && resolution.rejections.empty(), "plans: the five staged values resolve to five module plans");
	for (const auto& item : staged)
	{
		const auto* plan = plan_of(resolution, item.key);
		const auto* module = recipes.module(item.key);
		if (plan == nullptr || module == nullptr)
		{
			check(false, "synthesis: plan for " + ll::hex64(item.key));
			continue;
		}
		const auto stock = read_text(corpus / module->file);
		const auto synthesis = ll::synthesize(*plan, reinterpret_cast<const unsigned char*>(stock.data()), stock.size());
		const std::string bytes(synthesis.bytes.begin(), synthesis.bytes.end());
		const auto digest = settings::sha256_hex(bytes);
		check(synthesis.error.empty() && digest == item.sha,
			"synthesis byte-exact vs the staged baked replacement " + ll::hex64(item.key) + " (" + std::to_string(plan->patches.size())
				+ " patches, sha256 " + digest.substr(0, 16) + ")");
		if (!baked.empty() && std::filesystem::exists(baked / item.file))
			check(read_text(baked / item.file) == bytes, "synthesis equals the staged file bytes: " + std::string(item.file));
		// Fail closed: wrong size, one changed stock byte (SHA-256), a changed preimage under a matching SHA.
		const auto shorter = ll::synthesize(*plan, reinterpret_cast<const unsigned char*>(stock.data()), stock.size() - 1);
		check(shorter.bytes.empty() && shorter.error.rfind("stock-size-mismatch", 0) == 0, "fail closed: stock size mismatch " + ll::hex64(item.key));
		auto changed = stock;
		changed[changed.size() / 2] = static_cast<char>(changed[changed.size() / 2] ^ 0x5A);
		const auto tampered = ll::synthesize(*plan, reinterpret_cast<const unsigned char*>(changed.data()), changed.size());
		check(tampered.bytes.empty() && tampered.error.rfind("stock-sha256-mismatch", 0) == 0, "fail closed: stock SHA-256 mismatch " + ll::hex64(item.key));
		auto forged = *plan;
		forged.patches.front().site.expected[2] = static_cast<unsigned char>(forged.patches.front().site.expected[2] ^ 1);
		const auto preimage = ll::synthesize(forged, reinterpret_cast<const unsigned char*>(stock.data()), stock.size());
		check(preimage.bytes.empty() && preimage.error.rfind("preimage-changed", 0) == 0, "fail closed: preimage changed " + ll::hex64(item.key));
	}
	// Defaults, off, precedence.
	check(resolve(recipes, merged, state_with(merged, {{"mobiledefense.time_per_terminal", {true, 80}}})).plans.empty(),
		"default: a master at its stock adds no patch (stock module)");
	check(resolve(recipes, merged, state_with(merged, {{"mobiledefense.time_per_terminal", {false, 20}}})).plans.empty(),
		"off: a disabled value adds no patch");
	check(resolve(recipes, merged, state_with(merged, {{"void_flood.fractures_per_round.normal", {true, 3}}})).plans.empty(),
		"default: a row at its stock adds no patch");
	{
		auto use_stock = state_with(merged, {{"mobiledefense.time_per_terminal", {true, 20}}});
		use_stock.use_stock = true;
		check(resolve(recipes, merged, use_stock).plans.empty(), "use_stock: no patch");
		auto group_off = state_with(merged, {{"mobiledefense.time_per_terminal", {true, 20}}});
		group_off.groups["mobiledefense"] = false;
		check(resolve(recipes, merged, group_off).plans.empty(), "section switch off: no patch");
		const auto evaluation = settings::evaluate(merged, nullptr, "values-file-invalid-json");
		check(ll::resolve_plans(recipes, merged, nullptr, evaluation).plans.empty(), "malformed values file: no patch");
	}
	{
		const auto both = resolve(recipes, merged, state_with(merged, {
			{"excavation.dig_time", {true, 50}}, {"excavation.dig_duration_elite_alert", {true, 200}}}));
		const auto* plan = plan_of(both, 0xf7444e3c621ff018ull);
		int fifty = 0, two_hundred = 0;
		if (plan != nullptr)
			for (const auto& item : plan->patches) { fifty += item.bytes[2] == 50 ? 1 : 0; two_hundred += item.bytes[2] == 200 ? 1 : 0; }
		check(plan != nullptr && plan->patches.size() == 3 && fifty == 2 && two_hundred == 1,
			"precedence: a row's own value wins over its master (Elite Alert 200, others 50)");
		const auto stock_row = resolve(recipes, merged, state_with(merged, {
			{"excavation.dig_time", {true, 50}}, {"excavation.dig_duration_elite_alert", {true, 140}}}));
		plan = plan_of(stock_row, 0xf7444e3c621ff018ull);
		check(plan != nullptr && plan->patches.size() == 2, "precedence: a row's own value at stock keeps that row stock under a master");
	}
	{
		// Float constant site (Purgatory time per pickup, 5 -> 7.5).
		const auto r = resolve(recipes, merged, state_with(merged, {{"purgatory.pickup_time_bonus", {true, 7.5}}}));
		const auto* plan = r.plans.size() == 1 ? &r.plans.front() : nullptr;
		double encoded = 0;
		if (plan != nullptr && plan->patches.size() == 1) std::memcpy(&encoded, plan->patches.front().bytes.data(), 8);
		const auto* module = plan != nullptr ? recipes.module(plan->key) : nullptr;
		bool synthesized = false;
		if (module != nullptr)
		{
			const auto stock = read_text(corpus / module->file);
			synthesized = ll::synthesize(*plan, reinterpret_cast<const unsigned char*>(stock.data()), stock.size()).error.empty();
		}
		check(encoded == 7.5 && synthesized, "float: a constant site takes a fractional value (7.5) and synthesizes");
	}
	// Every recipe value alone at its min and at its max resolves and synthesizes against the real stock bytes.
	std::size_t extremes = 0, failures = 0;
	std::map<std::uint64_t, std::string> stocks;
	for (const auto& recipe : recipes.values)
	{
		const auto* declaration = merged.value(recipe.id);
		for (const double end : {declaration->minimum, declaration->maximum})
		{
			const auto r = resolve(recipes, merged, state_with(merged, {{recipe.id, {true, end}}}));
			for (const auto& plan : r.plans)
			{
				auto& stock = stocks[plan.key];
				if (stock.empty()) stock = read_text(corpus / recipes.module(plan.key)->file);
				failures += ll::synthesize(plan, reinterpret_cast<const unsigned char*>(stock.data()), stock.size()).error.empty() ? 0 : 1;
				++extremes;
			}
			failures += r.rejections.size();
		}
	}
	check(failures == 0 && extremes > 0, "every value at its min and max synthesizes (" + std::to_string(extremes) + " module syntheses)");
}

// ---------------------------------------------------------------------------
void part4_scan(const std::filesystem::path& work, const Fixture& fixture, const std::filesystem::path& corpus)
{
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);
	const auto folder = gate::root / "Packages" / "Missions";
	write_text(folder / "package.json", fixture.manifest);
	write_text(folder / "0000000000000001 (live literals gate dummy).lua_B", "dummy replacement bytes");
	write_text(folder / "literals.json", fixture.recipe);
	const auto values_path = gate::root / "Settings" / "Missions.json";
	const auto values_file = [&](const std::string& entries)
	{
		write_text(values_path, "{\"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"build\": \"2026.09.28.13.06\","
			" \"use_stock\": false, \"groups\": {}, \"values\": {" + entries + "}}");
	};
	values_file("\"mobiledefense.time_per_terminal\": {\"enabled\": true, \"value\": 20, \"stock\": 80},"
		" \"hijack.payload_health\": {\"enabled\": true, \"value\": 20000, \"stock\": 10000}");
	gate::log_lines.clear();
	check(packages::initialise(), "scan: startup scan passes");
	auto snapshot = packages::candidate();
	const packages::Package* package = snapshot && snapshot->packages.size() == 1 ? &snapshot->packages.front() : nullptr;
	check(package != nullptr && package->accepted && package->literal_recipes && package->literals_reason.empty(),
		"scan: package accepted with its recipe attached");
	if (package == nullptr) return;
	const auto* md = package->declarations ? package->declarations->value("mobiledefense.time_per_terminal") : nullptr;
	check(md != nullptr && md->live_literal, "scan: recipe values are merged into the package declarations");
	check(package->literal_plans.size() == 2, "scan: two enabled non-stock values -> two module plans");
	check(logged("RENOVICE LIVE LITERALS RECIPE ACCEPT trigger=startup package=Missions") && logged("RENOVICE LIVE LITERALS PLAN trigger=startup")
		&& logged("values=hijack.payload_health"), "scan: RECIPE ACCEPT and PLAN lines");
	check(logged("RENOVICE SETTINGS PACKAGE trigger=startup package=Missions") && logged("rejected=0"),
		"scan: the values file is evaluated with the recipe values (no rejection)");

	// Snapshot ownership and changed keys.
	auto plans = ll::build_snapshot(snapshot.get(), [](std::uint64_t) { return false; }, "startup");
	check(plans->plans.size() == 2 && plans->recipe_keys.size() == package->literal_recipes->modules.size(),
		"snapshot: plans committed, every recipe module inventoried");
	const std::uint64_t md_key = 0xa807aae359ffc1ebull;
	auto owned = ll::build_snapshot(snapshot.get(), [&](std::uint64_t key) { return key == md_key; }, "F9");
	check(owned->plans.size() == 1 && owned->plans.count(md_key) == 0 && logged("reason=module-owned-by holder=replacement"),
		"snapshot: a module owned by a byte replacement keeps that owner (plan held, logged)");
	check(ll::changed_keys(*plans, *plans).empty() && ll::changed_keys(*plans, *owned) == std::vector<std::uint64_t>{md_key},
		"changed keys: identical plans unchanged; a removed plan is a changed key");

	// The synthesis cache: same bytes object for the same stock; failure is stock and logged once.
	const auto* module = package->literal_recipes->module(md_key);
	const auto stock = read_text(corpus / module->file);
	const auto first = ll::synthesized(*plans, md_key, reinterpret_cast<const unsigned char*>(stock.data()), stock.size(), "undump");
	const auto second = ll::synthesized(*plans, md_key, reinterpret_cast<const unsigned char*>(stock.data()), stock.size(), "refresh");
	check(first != nullptr && first == second && logged("RENOVICE LIVE LITERALS SYNTHESIZE PASS key=a807aae359ffc1eb source=undump"),
		"cache: synthesized once, reused for the same stock body");
	auto broken = stock;
	broken[100] = static_cast<char>(broken[100] ^ 1);
	const auto lines_before = gate::log_lines.size();
	const auto failed1 = ll::synthesized(*plans, md_key, reinterpret_cast<const unsigned char*>(broken.data()), broken.size(), "undump");
	const auto failed2 = ll::synthesized(*plans, md_key, reinterpret_cast<const unsigned char*>(broken.data()), broken.size(), "undump");
	check(failed1 == nullptr && failed2 == nullptr && gate::log_lines.size() == lines_before + 1
		&& logged("SYNTHESIZE FAIL key=a807aae359ffc1eb source=undump") && logged("module=stock"),
		"fail closed: a different stock body loads stock, one FAIL line");
	check(ll::synthesized(*plans, 0x1234ull, reinterpret_cast<const unsigned char*>(stock.data()), stock.size(), "undump") == nullptr,
		"no plan: nullptr (the undump passes stock through)");

	// Values changed and F9: the plan identity changes.
	values_file("\"mobiledefense.time_per_terminal\": {\"enabled\": true, \"value\": 25, \"stock\": 80}");
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9: prepare scan passes");
	auto next = ll::build_snapshot(packages::candidate().get(), [](std::uint64_t) { return false; }, "F9");
	packages::commit_prepared_reload();
	const auto changed = ll::changed_keys(*plans, *next);
	check(next->plans.size() == 1 && changed.size() == 2, "F9: new value -> new identity; removed plan -> changed (2 keys)");

	// Recipe rejection is recipe-local: the package and its own declarations stay intact.
	write_text(folder / "literals.json", replace_once(fixture.recipe, "\"format\": \"RENOVICE_LIVE_LITERALS_V1\"", "\"format\": \"X\""));
	gate::log_lines.clear();
	check(packages::prepare_reload(), "reject: scan passes with a broken recipe");
	snapshot = packages::candidate();
	package = &snapshot->packages.front();
	check(package->accepted && !package->literal_recipes && !package->literals_reason.empty() && package->declarations
		&& package->declarations->value("mobiledefense.time_per_terminal") == nullptr
		&& package->declarations->value("survival.reward_interval") != nullptr,
		"reject: package accepted, recipe values absent, package.json values intact");
	check(logged("RENOVICE LIVE LITERALS RECIPE REJECT trigger=F9 package=Missions reason=recipe-format-not-RENOVICE_LIVE_LITERALS_V1"),
		"reject: RECIPE REJECT line with the exact reason");
	packages::commit_prepared_reload();

	// A package without literals.json scans exactly as before (no recipe, no line).
	std::filesystem::remove(folder / "literals.json");
	gate::log_lines.clear();
	check(packages::prepare_reload(), "absent: scan passes without literals.json");
	snapshot = packages::candidate();
	check(!snapshot->packages.front().literal_recipes && snapshot->packages.front().literals_reason.empty()
		&& !logged("LIVE LITERALS"), "absent: no recipe, no LIVE LITERALS line");
	packages::commit_prepared_reload();
}

// ---------------------------------------------------------------------------
void part5_ui(const ll::Recipes& recipes, const settings::Declarations& merged, const std::filesystem::path& corpus)
{
	namespace ui = settings_ui;
	ui::PackageView view;
	view.folder = "Missions";
	view.display = "Missions";
	view.declarations = &merged;
	view.state = state_with(merged, {});
	const std::vector<ui::PackageView> views{view};
	const std::string id = "mobiledefense.time_per_terminal";
	const auto* md = merged.value(id);
	check(md != nullptr && md->type == settings::ValueType::Int && md->default_label == "60-80 s" && !md->default_declared
		&& md->path.size() == 2 && md->row == "Time per terminal" && !md->quick.empty(),
		"R9: Time per terminal is a live literal int with R7 path, row, quick label and the range default '60-80 s' (no `default`)");

	// Value page: the stock stepper (INPUTCOUNT, int >= 0) and Reset to default.
	const auto page = ui::build_value_page(view, id);
	check(page.rows.size() == 2 && page.rows.front().kind == ui::RowKind::InputCount && !page.rows.front().locked
		&& page.rows.front().validate && page.rows.front().count == 80.0
		&& page.rows.front().tooltip.find("Default 60-80 s.") != std::string::npos
		&& page.rows.front().tooltip.find("Applies at the next mission.") != std::string::npos
		&& page.rows.front().tooltip.find("Built into") == std::string::npos
		&& page.rows.back().label == "Reset to default: 60-80 s",
		"UI: a live literal value page is a typeable stepper (not locked, validated) with 'Reset to default: 60-80 s'");
	const auto row_label = [&](const ui::PackageView& current)
	{
		return ui::value_row_label(current, *md);
	};
	check(row_label(view) == "Time per terminal: 60-80 s (default)", "R9: the row shows the range default 'Time per terminal: 60-80 s (default)'");

	// A typed value: staged, shown, written, resolved to the plan and synthesized.
	ui::Session session;
	check(ui::stage(session, views, "value:missions/" + id, ui::StagedValue::of_number(20)).empty(),
		"UI: staging a typed live literal value is accepted");
	check(ui::stage(session, views, "value:missions/" + id, ui::StagedValue::of_number(20000)) == "outside-min-max",
		"UI: an out-of-range value is refused");
	const auto overlaid = ui::overlay(session, views);
	check(row_label(overlaid.front()) == "Time per terminal: 20 s", "R9: after the edit the row reads 'Time per terminal: 20 s'");
	const auto applied = ui::apply(session, views);
	check(applied.packages.size() == 1, "apply: the edit writes the Missions values file");
	if (applied.packages.size() != 1) return;
	const auto text = settings::write_values_file(applied.packages.front().state, &merged);
	settings::UserState written;
	check(settings::parse_values_file(text, "package:missions", written).empty() && written.values.count(id) != 0
		&& written.values.at(id).enabled && written.values.at(id).value == 20.0,
		"apply: the written file holds { enabled: true, value: 20 } (enabled = value != default)");
	const auto resolution = resolve(recipes, merged, written);
	const auto* plan = plan_of(resolution, 0xa807aae359ffc1ebull);
	check(resolution.plans.size() == 1 && plan != nullptr && plan->patches.size() == 2 && plan->values == std::vector<std::string>{id},
		"R9: the written file resolves to one plan for Mobile Defense (both total-time rows)");
	if (plan != nullptr && !corpus.empty())
	{
		const auto stock = read_text(corpus / plan->file);
		const auto synthesis = ll::synthesize(*plan, reinterpret_cast<const unsigned char*>(stock.data()), stock.size());
		const auto digest = synthesis.error.empty()
			? settings::sha256_hex(std::string_view(reinterpret_cast<const char*>(synthesis.bytes.data()), synthesis.bytes.size()))
			: std::string();
		check(digest == "fff653e0efb3e6a4074b668d1ec3050a3fa1ae0a0ed3c06f7614521e3ad0e847",
			"R9: menu edit 20 -> values file -> plan -> synthesis equals the baked Mobile Defense 20 s replacement (fff653e0)");
	}

	// Typing the default number again (80) or Reset to default: the value is at its default, no plan (the stock range).
	{
		ui::PackageView edited = view;
		edited.state = written;
		const std::vector<ui::PackageView> edited_views{edited};
		ui::Session again;
		check(ui::stage(again, edited_views, "value:missions/" + id, ui::StagedValue::of_number(80)).empty(),
			"R9: typing the default number 80 is accepted");
		const auto at_default = ui::apply(again, edited_views);
		settings::UserState state;
		const bool parsed = at_default.packages.size() == 1
			&& settings::parse_values_file(settings::write_values_file(at_default.packages.front().state, &merged), "package:missions", state).empty();
		check(parsed && !state.values.at(id).enabled && resolve(recipes, merged, state).plans.empty()
			&& row_label(ui::overlay(again, edited_views).front()) == "Time per terminal: 60-80 s (default)",
			"R9: the typed default (80) is 'at default': enabled false, no plan, the row shows '60-80 s (default)'");
		ui::Session reset;
		check(ui::reset(reset, edited_views, "Missions/value:" + id), "R9: Reset to default is accepted for a live literal");
		const auto after_reset = ui::apply(reset, edited_views);
		settings::UserState reset_state;
		check(after_reset.packages.size() == 1
			&& settings::parse_values_file(settings::write_values_file(after_reset.packages.front().state, &merged), "package:missions", reset_state).empty()
			&& !reset_state.values.at(id).enabled && reset_state.values.at(id).value == 80.0 && resolve(recipes, merged, reset_state).plans.empty(),
			"R9: Reset to default writes { enabled: false, value: 80 } and removes the plan");
	}

	// Quick settings: a live literal quick value keeps its number (qval page) and its on/off applies it.
	{
		const auto quick = ui::build_quick_page(view);
		const auto open = std::find_if(quick.rows.begin(), quick.rows.end(), [&](const ui::Row& row)
			{
				return row.action == "open:qval:Missions/" + id;
			});
		check(open != quick.rows.end(), "R9: the Quick settings row of a live literal opens its kept-value page (qval)");
		const auto kept = ui::build_value_page(view, id, true);
		check(kept.rows.size() == 2 && kept.rows.front().kind == ui::RowKind::InputCount && !kept.rows.front().locked
			&& kept.rows.front().setting == "stored:missions/" + id, "R9: the kept-value page is a typeable stepper (stored:)");
		ui::Session quick_session;
		check(ui::stage(quick_session, views, "stored:missions/" + id, ui::StagedValue::of_number(25)).empty()
			&& ui::stage(quick_session, views, "active:missions/" + id, ui::StagedValue::of_bool(true)).empty(),
			"R9: the kept number and the Quick on/off of a live literal are accepted");
		const auto quick_applied = ui::apply(quick_session, views);
		settings::UserState state;
		const bool parsed = quick_applied.packages.size() == 1
			&& settings::parse_values_file(settings::write_values_file(quick_applied.packages.front().state, &merged), "package:missions", state).empty();
		const auto quick_plans = parsed ? resolve(recipes, merged, state) : ll::Resolution{};
		check(parsed && state.values.at(id).enabled && state.values.at(id).value == 25.0 && quick_plans.plans.size() == 1,
			"R9: Quick on with kept 25 writes { enabled: true, value: 25 } and resolves to the Mobile Defense plan");
	}

	// A baked literal (a replacement member's literal value, not a recipe value) stays read-only.
	settings::Declarations baked = merged;
	for (auto& value : baked.values) value.live_literal = false;
	ui::PackageView baked_view = view;
	baked_view.declarations = &baked;
	const auto baked_page = ui::build_value_page(baked_view, id);
	check(baked_page.rows.size() == 2 && baked_page.rows.front().kind == ui::RowKind::Checkbox
		&& baked_page.rows.front().tooltip.find("Built into the mission script") != std::string::npos,
		"UI: a baked literal value keeps the built-value switch (read-only number)");
	const std::vector<ui::PackageView> baked_views{baked_view};
	ui::Session baked_session;
	check(ui::stage(baked_session, baked_views, "value:missions/" + id, ui::StagedValue::of_number(25)) == "read-only-row",
		"UI: staging a baked literal value is refused");
}
}

int main(int argc, char** argv)
{
	std::cout << std::unitbuf; // a crash never hides the last checks
	if (argc != 5)
	{
		std::cerr << "usage: verify_live_literals <work dir> <fixture dir> <stock corpus dir> <baked dir|->\n";
		return 2;
	}
	const std::filesystem::path work = argv[1];
	const std::filesystem::path fixtures = argv[2];
	const std::filesystem::path corpus = argv[3];
	const std::filesystem::path baked = std::string(argv[4]) == "-" ? std::filesystem::path() : std::filesystem::path(argv[4]);
	Fixture fixture;
	fixture.recipe = read_text(fixtures / "literals.json");
	fixture.manifest = read_text(fixtures / "package.json");
	{
		std::istringstream lines(read_text(fixtures / "expected_order.txt"));
		for (std::string line; std::getline(lines, line);)
			if (!line.empty()) fixture.expected_order.push_back(line);
	}
	check(!fixture.recipe.empty() && !fixture.manifest.empty() && !fixture.expected_order.empty(), "fixtures present");
	part1_core();
	ll::Recipes recipes;
	settings::Declarations merged;
	part2_recipe(fixture, recipes, merged);
	part3_synthesis(recipes, merged, corpus, baked);
	part4_scan(work, fixture, corpus);
	part5_ui(recipes, merged, corpus);
	std::cout << (pass ? "LIVE LITERALS CHECKER PASS" : "LIVE LITERALS CHECKER FAIL") << '\n';
	return pass ? 0 : 1;
}
