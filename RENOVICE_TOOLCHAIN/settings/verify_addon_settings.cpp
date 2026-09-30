// Deterministic gate for ADDON_SETTINGS_V1 and `member:` states (2026-09-30).
//
// Part 1: settings declarations parser (renovice/settings_core.hpp).
// Part 2: user values file parser and writer.
// Part 3: effective settings, per-value enable, master and section switches,
//         build rule, literal-lane gate.
// Part 4: delivery identity and the target-addon reuse rule.
// Part 5: the exact renovice/packages.cpp scanner end to end (stub config and
//         policy providers): package regression (`settings: {}`), valid
//         declarations, malformed values file (package-local stock), invalid
//         declarations (capability-local compiled defaults), `member:` policy,
//         and the exact operational log lines.
// Part 6: page model of the SCRIPT SETTINGS UI (when compiled with it),
//         including the declaration-derived tooltip (`stock_check`).
// Part 7: optional real package folder and values file (--package/--settings).
// Part 8: optional R5 edit-flow replay (--replay <stage file>): the host stage
//         calls the stock render harness recorded, through stage/apply and
//         the values file writer.
//
// Usage: verify_addon_settings <work dir> <phase2i fixture dir>
//            [--package <folder> [--settings <file>] | --replay <stage file>]
// Paths are used in \\?\ form, so deep work folders stay long-path safe.
#include <algorithm>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <map>
#include <string>
#include <string_view>
#include <vector>

#include "../../renovice/config.hpp"
#include "../../renovice/packages.hpp"
#include "../../renovice/script_control.hpp"
#include "../../renovice/settings_core.hpp"
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
bool pass = true;

void check(bool result, const std::string& name)
{
	std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
	pass &= result;
}

void write_bytes(const std::filesystem::path& path, const std::vector<unsigned char>& bytes)
{
	std::filesystem::create_directories(path.parent_path());
	std::ofstream output(path, std::ios::binary | std::ios::trunc);
	output.write(reinterpret_cast<const char*>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
}

void write_text(const std::filesystem::path& path, std::string_view text)
{
	write_bytes(path, std::vector<unsigned char>(text.begin(), text.end()));
}

std::vector<unsigned char> synthetic_pool(const std::vector<std::string>& strings)
{
	std::vector<unsigned char> bytes{0x09, 0x03, static_cast<unsigned char>(strings.size())};
	for (const auto& text : strings)
	{
		bytes.push_back(static_cast<unsigned char>(text.size()));
		bytes.insert(bytes.end(), text.begin(), text.end());
	}
	bytes.insert(bytes.end(), 32, 0x00);
	return bytes;
}

bool logged(std::string_view needle)
{
	return std::any_of(gate::log_lines.begin(), gate::log_lines.end(),
		[&](const std::string& line) { return line.find(needle) != std::string::npos; });
}

const packages::Package* find_package(const packages::Snapshot& snapshot, std::string_view folder)
{
	for (const auto& package : snapshot.packages)
		if (package.folder == folder) return &package;
	return nullptr;
}

const packages::Member* find_member(const packages::Package* package, std::string_view file)
{
	if (package == nullptr) return nullptr;
	for (const auto& member : package->members)
		if (member.filename == file) return &member;
	return nullptr;
}

// A declaration set shaped exactly like the Phase 1 generator output.
const char* top_settings =
	"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\", \"groups\": ["
	" { \"id\": \"survival\", \"label\": \"Survival\", \"order\": 10, \"aliases\": [\"Hell-Scrub\", \"Hellscrubber\"] },"
	" { \"id\": \"void_flood\", \"label\": \"Void Flood\", \"order\": 20, \"aliases\": [] },"
	" { \"id\": \"defense\", \"label\": \"Defense\", \"order\": 30, \"aliases\": [] } ] }";
const char* addon_settings =
	"{ \"values\": {"
	" \"survival.reward_interval\": { \"group\": \"survival\", \"label\": \"Reward interval\", \"unit\": \"s\","
	"   \"type\": \"int\", \"stock\": 300, \"min\": 1, \"max\": 3600, \"scope\": \"All Survival nodes\","
	"   \"lane\": \"addon\", \"applies\": \"live_next_read\" },"
	" \"survival.pickup_multiplier\": { \"group\": \"survival\", \"label\": \"Pickup multiplier\", \"unit\": \"x\","
	"   \"type\": \"float\", \"stock\": 1.5, \"min\": 0.25, \"max\": 10, \"scope\": \"Survival\","
	"   \"lane\": \"addon\", \"applies\": \"next_instance\" },"
	" \"defense.mode\": { \"group\": \"defense\", \"label\": \"Wave mode\", \"unit\": \"\","
	"   \"type\": \"enum\", \"stock\": 1, \"min\": 1, \"max\": 3, \"scope\": \"Defense\","
	"   \"lane\": \"addon\", \"applies\": \"next_mission\","
	"   \"options\": [ { \"label\": \"Normal\", \"value\": 1 }, { \"label\": \"Fast\", \"value\": 2 }, { \"label\": \"Endless\", \"value\": 3 } ] },"
	" \"defense.offset\": { \"group\": \"defense\", \"label\": \"Wave offset\", \"unit\": \"\","
	"   \"type\": \"int\", \"stock\": 0, \"min\": -5, \"max\": 5, \"scope\": \"Defense\","
	"   \"lane\": \"addon\", \"applies\": \"next_mission\" } } }";
const char* literal_settings =
	"{ \"values\": { \"void_flood.fractures_per_round.normal\": { \"group\": \"void_flood\","
	" \"label\": \"Fractures per round\", \"unit\": \"\", \"type\": \"int\", \"stock\": 3, \"min\": 1, \"max\": 20,"
	" \"scope\": \"Void Flood\", \"lane\": \"literal\", \"applies\": \"next_mission\" } } }";

const std::string addon_file = "Missions.targets.addon.lua_B";
const std::string literal_file = "fc711ff621a75552 (missions_exact-replacement).lua_B";

settings::Declarations parsed_declarations()
{
	settings::Declarations declarations;
	const auto error = settings::parse_declarations(top_settings,
		{{addon_file, addon_settings}, {literal_file, literal_settings}}, declarations);
	if (!error.empty()) std::cout << "INFO\tunexpected declaration error: " << error << '\n';
	return declarations;
}

// -----------------------------------------------------------------------------
void declarations_parser()
{
	const auto declarations = parsed_declarations();
	check(declarations.build == "2026.09.28.13.06" && declarations.groups.size() == 3
		&& declarations.groups[0].aliases.size() == 2 && declarations.values.size() == 5,
		"generator-shaped declarations parse: 3 groups, 5 values, aliases kept");
	const auto* reward = declarations.value("survival.reward_interval");
	check(reward != nullptr && reward->member == addon_file && reward->type == settings::ValueType::Int
		&& reward->stock == 300 && reward->minimum == 1 && reward->maximum == 3600
		&& reward->lane == settings::Lane::Addon && reward->applies == settings::Applies::LiveNextRead
		&& reward->unit == "s",
		"int value carries member, bounds, lane, applies and unit");
	const auto* mode = declarations.value("defense.mode");
	check(mode != nullptr && mode->type == settings::ValueType::Enum && mode->options.size() == 3
		&& mode->options[1].label == "Fast" && mode->options[1].value == 2,
		"enum value carries its options");
	const auto* flood = declarations.value("void_flood.fractures_per_round.normal");
	check(flood != nullptr && flood->lane == settings::Lane::Literal && flood->member == literal_file,
		"literal value belongs to its replacement member");

	check(!settings::declarations_present("{}", {{addon_file, "{}"}})
		&& !settings::declarations_present("", {})
		&& settings::declarations_present("{}", {{addon_file, addon_settings}}),
		"`settings: {}` means no declarations (package behaves exactly as today)");

	const std::string good_group = "{ \"id\": \"g\", \"label\": \"G\", \"order\": 1, \"aliases\": [] }";
	const auto top_with = [&](const std::string& extra)
	{
		return "{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"b\", \"groups\": [" + good_group + "]" + extra + " }";
	};
	const auto value_with = [](const std::string& body)
	{
		return "{ \"values\": { \"g.v\": { " + body + " } } }";
	};
	const std::string base_value = "\"group\": \"g\", \"label\": \"V\", \"unit\": \"\", \"type\": \"int\","
		" \"stock\": 5, \"min\": 0, \"max\": 10, \"scope\": \"s\", \"lane\": \"addon\", \"applies\": \"live_next_read\"";
	struct Reject { std::string top; std::string member; std::string expected; };
	const std::vector<Reject> rejects{
		{top_with(", \"extra\": 1"), value_with(base_value), "settings-unknown-field=extra"},
		{"{ \"format\": \"X\", \"build\": \"b\", \"groups\": [] }", value_with(base_value), "settings-format-not-RENOVICE_SETTINGS_DECL_V1"},
		{"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"groups\": [] }", value_with(base_value), "settings-build-invalid"},
		{"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"b\", \"groups\": {} }", value_with(base_value), "settings-groups-not-array"},
		{"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"b\", \"groups\": [" + good_group + "," + good_group + "] }", value_with(base_value), "group-duplicate=g"},
		{"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"b\", \"groups\": [{ \"id\": \"Bad-Id\", \"label\": \"G\", \"order\": 1 }] }", value_with(base_value), "group-id-invalid"},
		{"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"b\", \"groups\": [{ \"id\": \"g\", \"label\": \"G\", \"order\": 1.5 }] }", value_with(base_value), "group-order-invalid=g"},
		{top_with(""), value_with(base_value + ", \"enabled\": true"), "member=M value=g.v unknown-field=enabled"},
		{top_with(""), "{ \"values\": { \"g.v\": { \"group\": \"x\", \"label\": \"V\", \"type\": \"int\", \"stock\": 1, \"min\": 0, \"max\": 2 } } }", "member=M value=g.v group-not-declared=x"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"text\", \"stock\": 1, \"min\": 0, \"max\": 2"), "member=M value=g.v type-invalid=text"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"int\", \"stock\": 11, \"min\": 0, \"max\": 10"), "member=M value=g.v stock-outside-min-max"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"int\", \"stock\": 1.5, \"min\": 0, \"max\": 10"), "member=M value=g.v int-has-fraction"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"int\", \"stock\": 1, \"min\": 0, \"max\": 99999999"), "member=M value=g.v int-bound-not-exact-in-float32"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"enum\", \"stock\": 5, \"min\": 0, \"max\": 10, \"options\": [{\"label\": \"A\", \"value\": 1}]"), "member=M value=g.v enum-stock-not-an-option"},
		{top_with(""), value_with(base_value + ", \"options\": []"), "member=M value=g.v options-only-for-enum"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"int\", \"stock\": 5, \"min\": 0, \"max\": 10, \"lane\": \"server\""), "member=M value=g.v lane-invalid=server"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"int\", \"stock\": 5, \"min\": 0, \"max\": 10, \"applies\": \"now\""), "member=M value=g.v applies-invalid=now"},
		{top_with(""), value_with(base_value + ", \"stock_check\": \"sometimes\""), "member=M value=g.v stock_check-invalid=sometimes"},
		{top_with(""), value_with(base_value + ", \"stock_check\": true"), "member=M value=g.v stock_check-invalid"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"int\", \"stock\": 5, \"min\": 0, \"max\": 10, \"lane\": \"literal\", \"stock_check\": \"none\""), "member=M value=g.v stock_check-only-for-addon-lane"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"" + std::string(65, 'x') + "\", \"type\": \"int\", \"stock\": 5, \"min\": 0, \"max\": 10"), "member=M value=g.v label-invalid"},
		{top_with(""), "{ \"values\": { \"bad id\": {} } }", "member=M value-id-invalid=bad id"},
		{top_with(""), "{ \"values\": {}, \"enabled\": true }", "member=M settings-must-be-exactly-values-object"},
		{top_with(""), "[]", "member=M settings-not-object"},
		{"{ \"format\": ", value_with(base_value), "settings-invalid-json"},
	};
	for (const auto& reject : rejects)
	{
		settings::Declarations declarations_out;
		const auto error = settings::parse_declarations(reject.top, {{"M", reject.member}}, declarations_out);
		check(error == reject.expected, "declaration rejects: " + reject.expected + (error == reject.expected ? "" : " (got " + error + ")"));
	}
	{
		settings::Declarations duplicate;
		const auto error = settings::parse_declarations(top_with(""),
			{{"A", value_with(base_value)}, {"B", value_with(base_value)}}, duplicate);
		check(error == "value-duplicate-in-package=g.v", "a value id is unique across the members of a package");
	}
	{
		// stock_check (optional, addon lane): absent = live, so earlier
		// declarations (the phase2i generator output) keep their meaning.
		settings::Declarations absent, live, none;
		const bool parsed = settings::parse_declarations(top_with(""), {{"M", value_with(base_value)}}, absent).empty()
			&& settings::parse_declarations(top_with(""), {{"M", value_with(base_value + ", \"stock_check\": \"live\"")}}, live).empty()
			&& settings::parse_declarations(top_with(""), {{"M", value_with(base_value + ", \"stock_check\": \"none\"")}}, none).empty();
		check(parsed && absent.values[0].stock_check == settings::StockCheck::Live && !absent.values[0].stock_check_declared
			&& live.values[0].stock_check == settings::StockCheck::Live && live.values[0].stock_check_declared
			&& none.values[0].stock_check == settings::StockCheck::None && none.values[0].stock_check_declared
			&& std::all_of(declarations.values.begin(), declarations.values.end(),
				[](const settings::ValueDecl& value) { return value.stock_check == settings::StockCheck::Live; }),
			"stock_check: \"live\" | \"none\" parse; absent means live (backward compatible)");
	}
}

// -----------------------------------------------------------------------------
void values_file()
{
	settings::UserState state;
	const std::string good =
		"\xEF\xBB\xBF{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\","
		" \"build\": \"2026.09.28.13.06\", \"use_stock\": false, \"groups\": { \"survival\": true, \"defense\": false },"
		" \"values\": { \"survival.reward_interval\": { \"enabled\": true, \"value\": 150 },"
		"   \"survival.pickup_multiplier\": { \"enabled\": false, \"value\": 2.5 },"
		"   \"defense.mode\": { \"enabled\": true, \"value\": 2, \"stock\": 1 },"
		"   \"shape.bad\": { \"enabled\": \"yes\" } } }";
	check(settings::parse_values_file(good, "package:missions", state).empty()
		&& state.build == "2026.09.28.13.06" && !state.use_stock && state.groups.size() == 2
		&& !state.groups["defense"] && state.values.size() == 4
		&& state.values["survival.reward_interval"].enabled && state.values["survival.reward_interval"].value == 150
		&& state.values["defense.mode"].has_stock && !state.values["shape.bad"].shape_valid
		&& state.values["shape.bad"].shape_reason == "enabled-not-boolean",
		"values file parses (BOM, groups, per-value enabled/value/stock); a bad entry is entry-local");
	const std::vector<std::pair<std::string, std::string>> malformed{
		{"{", "values-file-invalid-json"},
		{"[]", "values-file-not-object"},
		{"{ \"format\": \"X\", \"package\": \"package:missions\" }", "values-file-format-not-RENOVICE_SCRIPT_SETTINGS_V1"},
		{"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:other\" }", "values-file-package-mismatch expected=package:missions found=package:other"},
		{"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"extra\": 1 }", "values-file-unknown-field=extra"},
		{"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"use_stock\": 1 }", "values-file-use_stock-not-boolean"},
		{"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"groups\": { \"a\": 1 } }", "values-file-group-not-boolean=a"},
		{"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"values\": [] }", "values-file-values-not-object"},
		{"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\" } x", "values-file-trailing-data"},
		{"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\" }", "values-file-invalid-json"},
		{std::string(settings::maximum_values_file_bytes + 1, ' '), "values-file-too-large"},
	};
	for (const auto& [text, expected] : malformed)
	{
		const auto error = settings::parse_values_file(text, "package:missions", state);
		check(error == expected, "malformed values file: " + expected + (error == expected ? "" : " (got " + error + ")"));
	}

	// Writer round trip, with the declared stock recorded per value.
	const auto declarations = parsed_declarations();
	settings::UserState written;
	written.package = "package:missions";
	written.build = "2026.09.28.13.06";
	written.use_stock = true;
	written.groups["survival"] = false;
	written.values["survival.reward_interval"] = settings::UserValue{true, {}, true, true, 150, false, 0};
	written.values["survival.pickup_multiplier"] = settings::UserValue{true, {}, false, true, 0.75, false, 0};
	const auto text = settings::write_values_file(written, &declarations);
	settings::UserState reread;
	check(settings::parse_values_file(text, "package:missions", reread).empty()
		&& reread.use_stock && !reread.groups["survival"]
		&& reread.values["survival.reward_interval"].value == 150
		&& reread.values["survival.reward_interval"].has_stock && reread.values["survival.reward_interval"].stock == 300
		&& reread.values["survival.pickup_multiplier"].value == 0.75
		&& !reread.values["survival.pickup_multiplier"].enabled,
		"writer round trip keeps master, sections, values and records the declared stock");
	check(text.find("\"survival.reward_interval\": { \"enabled\": true, \"value\": 150, \"stock\": 300 }") != std::string::npos,
		"writer output is deterministic and human-editable");
}

// -----------------------------------------------------------------------------
void effective_rules()
{
	const auto declarations = parsed_declarations();
	const auto absent = settings::evaluate(declarations, nullptr, {});
	check(absent.file == settings::FileStatus::Absent && absent.effective.empty(),
		"missing values file: every value is stock");
	const auto malformed = settings::evaluate(declarations, nullptr, "values-file-invalid-json");
	check(malformed.file == settings::FileStatus::Malformed && malformed.effective.empty()
		&& malformed.file_reason == "values-file-invalid-json",
		"malformed values file: the package reverts to stock with the exact reason");

	settings::UserState state;
	state.package = "package:missions";
	state.build = "2026.09.28.13.06";
	state.values["survival.reward_interval"] = settings::UserValue{true, {}, true, true, 150, false, 0};
	state.values["survival.pickup_multiplier"] = settings::UserValue{true, {}, false, true, 2.5, false, 0};
	state.values["defense.mode"] = settings::UserValue{true, {}, true, true, 2, false, 0};
	state.values["defense.offset"] = settings::UserValue{true, {}, true, true, -3, false, 0};
	state.values["unknown.id"] = settings::UserValue{true, {}, true, true, 1, false, 0};
	auto result = settings::evaluate(declarations, &state, {});
	check(result.effective.count("survival.reward_interval") && !result.effective.count("survival.pickup_multiplier")
		&& result.effective.count("defense.mode") && result.effective.count("defense.offset")
		&& result.unknown_entries == 1 && result.rejections.empty(),
		"per-value enable: an enabled valid value is effective, a disabled one stays stock, unknown ids are ignored");

	const auto reject_reason = [&](const std::string& id, double value) -> std::string
	{
		auto copy = state;
		copy.values[id].value = value;
		const auto evaluated = settings::evaluate(declarations, &copy, {});
		for (const auto& rejection : evaluated.rejections)
			if (rejection.id == id) return rejection.reason;
		return evaluated.effective.count(id) ? "effective" : "stock";
	};
	check(reject_reason("survival.reward_interval", 0) == "outside-min-max"
		&& reject_reason("survival.reward_interval", 3601) == "outside-min-max"
		&& reject_reason("survival.reward_interval", 150.5) == "int-has-fraction"
		&& reject_reason("defense.mode", 4) == "outside-min-max"
		&& reject_reason("defense.mode", 1.5) == "enum-value-not-an-option"
		&& reject_reason("defense.offset", -5) == "effective",
		"invalid values revert only that value to stock with an exact reason");

	auto master = state;
	master.use_stock = true;
	check(settings::evaluate(declarations, &master, {}).effective.empty(),
		"master `use_stock` makes every value stock and keeps the remembered values");
	auto section = state;
	section.groups["survival"] = false;
	const auto sectioned = settings::evaluate(declarations, &section, {});
	check(!sectioned.effective.count("survival.reward_interval") && sectioned.effective.count("defense.mode"),
		"a section switch reverts only its group");

	auto moved = state;
	moved.build = "2026.10.01.00.00";
	auto moved_result = settings::evaluate(declarations, &moved, {});
	check(!moved_result.effective.count("survival.reward_interval")
		&& std::any_of(moved_result.rejections.begin(), moved_result.rejections.end(),
			[](const settings::ValueRejection& r) { return r.reason == "build-mismatch-stock-unverified"; }),
		"build mismatch without a recorded stock never carries a value over");
	moved.values["survival.reward_interval"].has_stock = true;
	moved.values["survival.reward_interval"].stock = 300;
	check(settings::evaluate(declarations, &moved, {}).effective.count("survival.reward_interval"),
		"build mismatch keeps a value whose recorded stock equals the declared stock");
	auto drifted = state;
	drifted.values["survival.reward_interval"].has_stock = true;
	drifted.values["survival.reward_interval"].stock = 250;
	check(!settings::evaluate(declarations, &drifted, {}).effective.count("survival.reward_interval"),
		"a recorded stock that differs from the declaration fails closed");

	// Literal-lane gate for the replacement member.
	check(!settings::literal_member_admitted(declarations, nullptr, absent, literal_file),
		"literal member without a values file stays stock (not staged)");
	auto literal = state;
	literal.values["void_flood.fractures_per_round.normal"] = settings::UserValue{true, {}, true, true, 4, false, 0};
	auto literal_eval = settings::evaluate(declarations, &literal, {});
	check(settings::literal_member_admitted(declarations, &literal, literal_eval, literal_file),
		"literal member is staged when its value is enabled");
	literal.values["void_flood.fractures_per_round.normal"].enabled = false;
	check(!settings::literal_member_admitted(declarations, &literal, settings::evaluate(declarations, &literal, {}), literal_file),
		"per-value switch off: the one-value literal member stays stock");
	literal.values["void_flood.fractures_per_round.normal"].enabled = true;
	literal.use_stock = true;
	check(!settings::literal_member_admitted(declarations, &literal, settings::evaluate(declarations, &literal, {}), literal_file),
		"master `use_stock` also holds back literal members");
	check(settings::literal_member_admitted(declarations, &literal, literal_eval, "other.lua_B"),
		"a replacement member without literal declarations is unaffected");
}

// -----------------------------------------------------------------------------
void delivery_identity()
{
	const auto declarations = parsed_declarations();
	settings::UserState state;
	state.package = "package:missions";
	state.values["survival.reward_interval"] = settings::UserValue{true, {}, true, true, 150, false, 0};
	state.values["defense.mode"] = settings::UserValue{true, {}, true, true, 2, false, 0};
	state.values["void_flood.fractures_per_round.normal"] = settings::UserValue{true, {}, true, true, 4, false, 0};
	const auto evaluation = settings::evaluate(declarations, &state, {});
	const auto delivery = settings::member_delivery(declarations, &state, evaluation, addon_file);
	check(delivery->values.size() == 2 && delivery->values[0].id == "defense.mode"
		&& delivery->values[1].id == "survival.reward_interval"
		&& delivery->values[1].value == 150.0f && delivery->values[1].stock == 300.0f,
		"delivery holds only this member's effective addon-lane values, sorted, with stock");
	const auto again = settings::member_delivery(declarations, &state, evaluation, addon_file);
	check(delivery->identity == again->identity && delivery->identity.rfind("settings-v1:", 0) == 0
		&& delivery->identity.size() == 12 + 64,
		"delivery identity is a deterministic SHA-256");
	auto changed = state;
	changed.values["survival.reward_interval"].value = 151;
	const auto changed_delivery = settings::member_delivery(
		declarations, &changed, settings::evaluate(declarations, &changed, {}), addon_file);
	auto disabled = state;
	disabled.values["survival.reward_interval"].enabled = false;
	const auto disabled_delivery = settings::member_delivery(
		declarations, &disabled, settings::evaluate(declarations, &disabled, {}), addon_file);
	check(changed_delivery->identity != delivery->identity && disabled_delivery->identity != delivery->identity
		&& disabled_delivery->values.size() == 1,
		"a value edit or a per-value switch changes the identity (forces re-activation)");
	const auto stock_delivery = settings::member_delivery(declarations, nullptr, settings::evaluate(declarations, nullptr, {}), addon_file);
	check(stock_delivery->values.empty() && !stock_delivery->identity.empty()
		&& stock_delivery->identity != delivery->identity,
		"an all-stock package still delivers an (empty) table with its own identity");
	check(settings::sha256_hex("abc") == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
		&& settings::sha256_hex("") == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
		"SHA-256 matches the FIPS 180-4 vectors");
	check(settings::target_addon_binding_reusable(true, true, true, "", "")
		&& settings::target_addon_binding_reusable(true, true, true, delivery->identity, again->identity)
		&& !settings::target_addon_binding_reusable(true, true, true, delivery->identity, changed_delivery->identity)
		&& !settings::target_addon_binding_reusable(true, true, true, "", delivery->identity)
		&& !settings::target_addon_binding_reusable(true, false, true, "", ""),
		"reuse identity: bytes AND settings; loose addons (no settings) reuse exactly as before");
}

// -----------------------------------------------------------------------------
void member_states()
{
	check(script_control::member_state_id("Missions", "Missions.targets.addon.lua_B")
			== "member:missions/missions.targets.addon.lua_b"
		&& script_control::is_member_state_id("member:missions/x.lua_b")
		&& !script_control::is_member_state_id("package:missions")
		&& !script_control::is_member_state_id("member:"),
		"member ids are member:<folder>/<file>, lowercased");
	check(script_control::valid_state_id(script_control::member_state_id("Missions", literal_file)),
		"member ids satisfy the ScriptStates.json id rules");
}

// -----------------------------------------------------------------------------
std::string manifest_with(const std::string& top, const std::string& addon, const std::string& literal)
{
	std::string text = "{ \"schema\": 1, \"name\": \"Missions\", \"members\": {\n";
	text += "  \"" + addon_file + "\": { \"label\": \"Mission values\"" + (addon.empty() ? "" : ", \"settings\": " + addon) + " },\n";
	text += "  \"" + literal_file + "\": { \"label\": \"Void Flood\"" + (literal.empty() ? "" : ", \"settings\": " + literal) + " }\n";
	text += "}, \"settings\": " + top + " }\n";
	return text;
}

void end_to_end(const std::filesystem::path& work)
{
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);
	gate::policy.clear();
	const auto addon_bytes = synthetic_pool({"f10a043e7f825db2", "6fa60841c9e0f207"});
	const std::vector<unsigned char> flood{'F', 'L', 'O', 'O', 'D', '4'};
	const auto missions = gate::root / "Packages" / "Missions";
	write_bytes(missions / addon_file, addon_bytes);
	write_bytes(missions / literal_file, flood);
	write_bytes(gate::inject / "3333333333333333.Loose.target.addon.lua_B", {'L', 'O', 'O', 'S', 'E'});

	// 1. Package regression: `settings: {}` behaves exactly as before.
	write_text(missions / "package.json", manifest_with("{}", "", ""));
	gate::log_lines.clear();
	check(packages::initialise(), "startup scan PASS (package without declarations)");
	auto snapshot = packages::candidate();
	auto* package = find_package(*snapshot, "Missions");
	auto* addon = find_member(package, addon_file);
	auto* literal = find_member(package, literal_file);
	check(package != nullptr && package->accepted && !package->declarations && package->settings_reason.empty()
		&& addon != nullptr && addon->staged && !addon->delivery && addon->bytes == addon_bytes
		&& literal != nullptr && literal->staged && literal->bytes == flood
		&& addon->state_id == "member:missions/missions.targets.addon.lua_b",
		"package regression: no declarations -> all members staged, no delivery (context.settings = nil)");
	check(!logged("RENOVICE SETTINGS"), "package regression: no settings log lines at all");
	check(logged("RENOVICE PACKAGE ACCEPT trigger=startup package=Missions id=package:missions members=2 replacements=1 target_addons=1 target_keys=2 lanes=replacement+inject"),
		"package regression: the ACCEPT line is unchanged");

	// 2. Valid declarations, no values file: everything stock.
	write_text(missions / "package.json", manifest_with(top_settings, addon_settings, literal_settings));
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS (declarations, values file absent)");
	snapshot = packages::candidate();
	package = find_package(*snapshot, "Missions");
	addon = find_member(package, addon_file);
	literal = find_member(package, literal_file);
	check(package != nullptr && package->accepted && package->declarations != nullptr
		&& addon != nullptr && addon->staged && addon->delivery != nullptr && addon->delivery->values.empty()
		&& literal != nullptr && !literal->staged && literal->bytes.empty(),
		"declarations without a values file: addon gets an empty table, literal member stays stock");
	check(logged("RENOVICE SETTINGS PACKAGE trigger=F9 package=Missions declarations=5 groups=3 file=absent use_stock=0 effective=0 rejected=0 unknown_entries=0 members_staged=1/2")
		&& logged("RENOVICE SETTINGS LITERAL MEMBER STOCK trigger=F9 package=Missions member=" + literal_file + " reason=literal-values-not-enabled scope=member-local")
		&& logged("RENOVICE SETTINGS DELIVERY trigger=F9 package=Missions member=" + addon_file + " values=0 identity="),
		"operational lines: package summary, literal gate, delivery");
	packages::discard_prepared_reload();

	// 3. Valid values file (the Phase 1 migration shape).
	const auto settings_dir = gate::root / "Settings";
	write_text(settings_dir / "Missions.json",
		"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"build\": \"2026.09.28.13.06\","
		" \"use_stock\": false, \"groups\": { \"survival\": true, \"void_flood\": true },"
		" \"values\": { \"survival.reward_interval\": { \"enabled\": true, \"value\": 150 },"
		" \"void_flood.fractures_per_round.normal\": { \"enabled\": true, \"value\": 4 },"
		" \"defense.offset\": { \"enabled\": true, \"value\": 9 } } }");
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS (valid values file)");
	snapshot = packages::candidate();
	package = find_package(*snapshot, "Missions");
	addon = find_member(package, addon_file);
	literal = find_member(package, literal_file);
	check(addon != nullptr && addon->delivery != nullptr && addon->delivery->values.size() == 1
		&& addon->delivery->values[0].id == "survival.reward_interval" && addon->delivery->values[0].value == 150.0f
		&& literal != nullptr && literal->staged && literal->bytes == flood,
		"valid values file: enabled value delivered, literal member staged");
	check(logged("RENOVICE SETTINGS VALUE REJECT trigger=F9 package=Missions id=defense.offset reason=outside-min-max scope=value-local value=stock")
		&& logged("file=valid use_stock=0 effective=2 rejected=1"),
		"an out-of-range value reverts only itself, with an exact line");
	const auto valid_identity = addon->delivery->identity;
	packages::commit_prepared_reload();

	// 4. Settings-only change -> new identity (forces cleanup + activate).
	write_text(settings_dir / "Missions.json",
		"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"build\": \"2026.09.28.13.06\","
		" \"use_stock\": false, \"values\": { \"survival.reward_interval\": { \"enabled\": true, \"value\": 120 },"
		" \"void_flood.fractures_per_round.normal\": { \"enabled\": true, \"value\": 4 } } }");
	check(packages::prepare_reload(), "F9 prepare PASS (settings-only change)");
	addon = find_member(find_package(*packages::candidate(), "Missions"), addon_file);
	check(addon != nullptr && addon->delivery != nullptr && addon->delivery->identity != valid_identity
		&& addon->bytes == addon_bytes,
		"identity-includes-settings: unchanged bytes, changed settings -> different identity");
	packages::commit_prepared_reload();

	// 5. Malformed values file: package-local stock, loose files and the package still load.
	write_text(settings_dir / "Missions.json", "{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", ");
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS with a malformed values file (never rejects the transaction)");
	snapshot = packages::candidate();
	package = find_package(*snapshot, "Missions");
	addon = find_member(package, addon_file);
	literal = find_member(package, literal_file);
	check(package != nullptr && package->accepted && addon != nullptr && addon->staged
		&& addon->delivery != nullptr && addon->delivery->values.empty()
		&& literal != nullptr && !literal->staged,
		"fail-closed: malformed values file -> this package is stock (empty table, literal held back)");
	check(logged("RENOVICE SETTINGS FILE REJECT trigger=F9 package=Missions file=Settings/Missions.json reason=values-file-invalid-json scope=package-local values=stock"),
		"fail-closed: exact FILE REJECT line");
	packages::discard_prepared_reload();

	// 6. Invalid declarations: settings capability off, compiled defaults.
	write_text(missions / "package.json", manifest_with(top_settings,
		"{ \"values\": { \"survival.reward_interval\": { \"group\": \"nope\", \"label\": \"X\", \"type\": \"int\", \"stock\": 1, \"min\": 0, \"max\": 2 } } }",
		""));
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS with invalid declarations");
	snapshot = packages::candidate();
	package = find_package(*snapshot, "Missions");
	addon = find_member(package, addon_file);
	literal = find_member(package, literal_file);
	check(package != nullptr && package->accepted && !package->declarations
		&& package->settings_reason == "member=" + addon_file + " value=survival.reward_interval group-not-declared=nope"
		&& addon != nullptr && addon->staged && !addon->delivery && literal != nullptr && literal->staged,
		"fail-closed: invalid declarations reject only the settings capability (members keep compiled defaults)");
	check(logged("RENOVICE SETTINGS DECLARATIONS REJECT trigger=F9 package=Missions reason=member=" + addon_file
			+ " value=survival.reward_interval group-not-declared=nope scope=settings-capability-local members=compiled-defaults"),
		"fail-closed: exact DECLARATIONS REJECT line");
	packages::discard_prepared_reload();

	// 7. member: policy.
	write_text(missions / "package.json", manifest_with("{}", "", ""));
	gate::policy[script_control::member_state_id("Missions", addon_file)] = false;
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS with a disabled member");
	snapshot = packages::candidate();
	package = find_package(*snapshot, "Missions");
	addon = find_member(package, addon_file);
	literal = find_member(package, literal_file);
	check(package != nullptr && package->accepted && addon != nullptr && !addon->enabled && !addon->staged
		&& addon->bytes.empty() && addon->target_keys.size() == 2
		&& literal != nullptr && literal->staged && literal->bytes == flood,
		"member: off -> excluded from staging, still validated, keys still inventoried; siblings unaffected");
	check(logged("RENOVICE PACKAGE MEMBER DISABLED trigger=F9 package=Missions member=" + addon_file
			+ " id=member:missions/missions.targets.addon.lua_b scope=member-local"),
		"member: off -> exact MEMBER DISABLED line");
	gate::policy.clear();
	packages::discard_prepared_reload();

	// 8. Reserved infrastructure never becomes a member; loose names unchanged.
	packages::MemberKind kind{};
	std::uint64_t key = 0;
	check(std::string_view(packages::classify_member("_RENOVICE_INTERNAL_ScriptSettingsBridgeV1.lua_B", kind, key))
			== "member-is-bootstrapper-infrastructure"
		&& std::string_view(packages::classify_member("_renovice_internal_Anything.lua_B", kind, key))
			== "member-is-bootstrapper-infrastructure",
		"reserved _RENOVICE_INTERNAL_ names are never package members");
	check(injection::classify_internal_chunk("_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B") == injection::InternalChunk::ScriptsBridgeV10
		&& injection::classify_internal_chunk("_RENOVICE_INTERNAL_ScriptSettingsBridgeV1.lua_B") == injection::InternalChunk::ScriptSettingsBridgeV1
		&& injection::classify_internal_chunk("_RENOVICE_INTERNAL_ScriptSettingsProbeP0.lua_B") == injection::InternalChunk::SettingsProbeP0
		&& injection::classify_internal_chunk("_RENOVICE_INTERNAL_Other.lua_B") == injection::InternalChunk::Reserved
		&& injection::classify_internal_chunk("Missions.targets.addon.lua_B") == injection::InternalChunk::None
		&& injection::optional_internal_bridge_admitted(injection::InternalChunk::ScriptSettingsBridgeV1, false)
		&& !injection::optional_internal_bridge_admitted(injection::InternalChunk::SettingsProbeP0, false)
		&& injection::optional_internal_bridge_admitted(injection::InternalChunk::SettingsProbeP0, true)
		&& !injection::optional_internal_bridge_admitted(injection::InternalChunk::Reserved, true),
		"internal chunk classification: only named bridges load; the probe only in a probe build");
	check(script_control::stable_id(script_control::Kind::TargetAddon, "Missions.targets.addon.lua_B")
			== "target-addon:missions.targets.addon.lua_b"
		&& script_control::stable_id(script_control::Kind::Package, "Missions") == "package:missions"
		&& script_control::stable_id(script_control::Kind::Replacement, literal_file)
			== "replacement:fc711ff621a75552 (missions_exact-replacement).lua_b",
		"loose/package stable ids unchanged");
}

// -----------------------------------------------------------------------------
// Phase 1 generator contract (ability-editor 07d3196, CONTRACT_PHASE1.md): the
// exact phase2i package.json and hand-made live-test Settings/Missions.json.
std::string read_text(const std::filesystem::path& path)
{
	std::ifstream input(path, std::ios::binary);
	return std::string((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
}

void phase1_contract(const std::filesystem::path& fixtures, const std::filesystem::path& work)
{
	const auto manifest_text = read_text(fixtures / "package.json");
	const auto values_text = read_text(fixtures / "Missions.json");
	check(!manifest_text.empty() && !values_text.empty(), "phase2i contract fixtures are present");
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);
	gate::policy.clear();
	const auto missions = gate::root / "Packages" / "Missions";
	const auto addon_bytes = synthetic_pool({"f10a043e7f825db2", "6fa60841c9e0f207", "caec63d8e739b693"});
	const std::vector<unsigned char> flood{'F', 'L', 'O', 'O', 'D', '4'};
	write_bytes(missions / addon_file, addon_bytes);
	write_bytes(missions / literal_file, flood);
	write_text(missions / "package.json", manifest_text);
	write_text(gate::root / "Settings" / "Missions.json", values_text);
	gate::log_lines.clear();
	check(packages::initialise(), "phase2i: startup scan PASS");
	const auto snapshot = packages::candidate();
	const auto* package = find_package(*snapshot, "Missions");
	const auto* addon = find_member(package, addon_file);
	const auto* literal = find_member(package, literal_file);
	if (package != nullptr && (!package->reason.empty() || !package->settings_reason.empty()))
	{
		std::cout << "INFO\tphase2i package reason=" << package->reason
			<< " settings_reason=" << package->settings_reason << '\n';
	}
	check(package != nullptr && package->accepted && package->declarations != nullptr
		&& package->declarations->values.size() == 4 && package->declarations->groups.size() == 4
		&& package->settings_reason.empty(),
		"phase2i: generator declarations are accepted by the runtime parser (4 values, 4 groups)");
	check(addon != nullptr && addon->staged && addon->delivery != nullptr
		&& addon->delivery->values.size() == 1
		&& addon->delivery->values[0].id == "survival.reward_interval"
		&& addon->delivery->values[0].value == 150.0f && addon->delivery->values[0].stock == 300.0f,
		"phase2i: only survival.reward_interval is delivered (purgatory disabled, lantern absent = stock)");
	check(literal != nullptr && literal->staged && literal->bytes == flood,
		"phase2i: the enabled Void Flood literal keeps its replacement member staged (D2)");
	check(logged("RENOVICE SETTINGS PACKAGE trigger=startup package=Missions declarations=4 groups=4 file=valid use_stock=0 effective=2 rejected=0 unknown_entries=0 members_staged=2/2"),
		"phase2i: exact operational summary line");

	// The same package through the UI model: labels follow D1.
	using namespace renovice::settings_ui;
	PackageView view;
	view.folder = "Missions";
	view.display = "Missions";
	view.declarations = package != nullptr ? package->declarations.get() : nullptr;
	(void)settings::parse_values_file(values_text, "package:missions", view.state);
	const auto page = build_flat_page({view});
	// A float's editor row is the BUTTON that opens its INPUTBOX page.
	const auto matches = [](const Row& row, std::string_view setting)
	{
		if (row.setting == setting) return true;
		if (setting.rfind("value:missions/", 0) != 0) return false;
		return row.action == "open:val:Missions/" + std::string(setting.substr(15));
	};
	const auto label_of = [&](std::string_view setting) -> std::string
	{
		for (const auto& row : page.rows)
			if (matches(row, setting)) return row.label;
		return "<missing>";
	};
	check(label_of("value:missions/survival.reward_interval") == "Reward interval: 150 s (stock 300 s)"
		&& label_of("custom:missions/survival.reward_interval") == "Custom Reward interval"
		&& label_of("value:missions/purgatory.difficulty1.warrior_level") == "Difficulty 1 warrior level: 15"
		&& label_of("group:missions/survival") == "Custom Survival values",
		"phase2i: row labels follow CONTRACT_PHASE1 D1 (R4: the int warrior level is a value BUTTON; its stock suffix does not fit 40)");
	bool within_budget = true;
	for (const auto& row : page.rows)
		within_budget &= row.label.size() <= (row.kind == RowKind::Title ? maximum_title_label : maximum_row_label);
	check(within_budget, "phase2i: every row label is within the width budget");
	const auto tooltip_of = [&](std::string_view setting) -> std::string
	{
		for (const auto& row : page.rows)
			if (matches(row, setting)) return row.tooltip;
		return {};
	};
	check(tooltip_of("value:missions/survival.reward_interval").find(live_stock_sentence) != std::string::npos
		&& tooltip_of("value:missions/void_flood.fractures_per_round.normal").find(live_stock_sentence) == std::string::npos,
		"phase2i: without stock_check the addon rows keep the live-stock sentence (backward compatible); literal rows never carry it");

	// Live defect 2026-09-30 (DLL ed2a996d, bridge 9c1450ed): the phase2i flat
	// page ran off the screen without a scroll bar. Stock attaches the scroll
	// bar only to uniform-height lists without INPUTBOX rows.
	std::size_t inputboxes = 0;
	std::size_t spacers = 0;
	for (const auto& row : page.rows)
	{
		inputboxes += row.kind == RowKind::InputBox ? 1u : 0u;
		spacers += row.kind == RowKind::Spacer ? 1u : 0u;
	}
	check(page.rows.size() > stock_uniform_visible_rows && inputboxes == 0 && spacers == 0
		&& stock_uniform_heights(page) && stock_scroll_attached(page),
		"phase2i: the flat page (" + std::to_string(page.rows.size())
			+ " rows) keeps the stock scroll contract: uniform 44 px rows, no INPUTBOX, scroll bar attached");
	const Row* reward_button = nullptr;
	for (const auto& row : page.rows)
		if (row.action == "open:val:Missions/survival.reward_interval") reward_button = &row;
	const auto reward_page = build_value_page(view, "survival.reward_interval");
	check(reward_button != nullptr && reward_button->kind == RowKind::Button
		&& reward_button->label == "Reward interval: 150 s (stock 300 s)"
		&& !reward_button->locked
		&& reward_page.title == "REWARD INTERVAL" && reward_page.rows.size() == 1
		&& reward_page.rows[0].kind == RowKind::InputBox && reward_page.rows[0].content == "150"
		&& reward_page.rows[0].setting == "value:missions/survival.reward_interval" && reward_page.rows[0].validate,
		"phase2i: the float Reward interval is a BUTTON labelled with its value (no stock sub-label) that opens its one-row INPUTBOX page");
}

// -----------------------------------------------------------------------------
void ui_page_model()
{
	using namespace renovice::settings_ui;
	const auto declarations = parsed_declarations();
	PackageView view;
	view.folder = "Missions";
	view.display = "Missions";
	view.package_enabled = true;
	view.declarations = &declarations;
	view.members.push_back(MemberView{addon_file, "Mission values", "member:missions/missions.targets.addon.lua_b", true, false});
	view.members.push_back(MemberView{literal_file, "Void Flood fractures", "member:missions/" + script_control::ascii_lower(literal_file), true, true});
	view.state.package = "package:missions";
	view.state.values["survival.reward_interval"] = settings::UserValue{true, {}, true, true, 150, false, 0};
	view.state.values["survival.pickup_multiplier"] = settings::UserValue{true, {}, false, true, 2.5, false, 0};
	view.state.groups["defense"] = false;

	const auto flat = build_flat_page({view});
	const auto count_kind = [](const Page& page, RowKind kind)
	{
		return static_cast<std::size_t>(std::count_if(page.rows.begin(), page.rows.end(),
			[&](const Row& row) { return row.kind == kind; }));
	};
	check(flat.title == "SCRIPT SETTINGS" && !flat.search && !flat.rows.empty(),
		"flat page: native title; the stock search box stays off (R4: the stock filter re-adds populate-time copies)");
	bool only_stock_types = true;
	bool labels_fit = true;
	bool no_glyphs = true;
	for (const auto& row : flat.rows)
	{
		only_stock_types &= row.kind == RowKind::Title || row.kind == RowKind::Spacer
			|| row.kind == RowKind::Checkbox || row.kind == RowKind::InputCount
			|| row.kind == RowKind::InputBox || row.kind == RowKind::Toggle || row.kind == RowKind::Button;
		const std::size_t budget = row.kind == RowKind::Title ? maximum_title_label : maximum_row_label;
		labels_fit &= row.label.size() <= budget;
		no_glyphs &= row.label.empty() || (row.label.front() != ' ' && row.label.find("--") == std::string::npos
			&& row.label.find('|') == std::string::npos);
	}
	check(only_stock_types, "flat page uses stock row types only");
	check(labels_fit, "every row label fits the width budget (40 value / 48 title)");
	check(no_glyphs, "no leading spaces, box or tree glyphs in labels");
	const auto find_row = [&](const Page& page, std::string_view setting) -> const Row*
	{
		for (const auto& row : page.rows)
			if (row.setting == setting) return &row;
		return nullptr;
	};
	const auto* master = find_row(flat, "stock:missions");
	const auto* package_row = find_row(flat, "package:missions");
	const auto* member_row = find_row(flat, "member:missions/missions.targets.addon.lua_b");
	const auto* custom = find_row(flat, "custom:missions/survival.reward_interval");
	const auto reward_page = build_value_page(view, "survival.reward_interval");
	const auto* editor = reward_page.rows.size() == 1 ? &reward_page.rows[0] : nullptr;
	const auto* enum_editor = find_row(flat, "value:missions/defense.mode");
	const auto* section = find_row(flat, "group:missions/defense");
	const auto literal_page = build_value_page(view, "void_flood.fractures_per_round.normal");
	const auto* literal_value = literal_page.rows.size() == 1 ? &literal_page.rows[0] : nullptr;
	check(master != nullptr && master->kind == RowKind::Checkbox && !master->value
		&& package_row != nullptr && package_row->value
		&& member_row != nullptr && member_row->kind == RowKind::Checkbox && member_row->value,
		"package, master and member switches are CHECKBOX rows with current state");
	const auto find_action = [&](const Page& page, std::string_view action) -> const Row*
	{
		for (const auto& row : page.rows)
			if (row.action == action) return &row;
		return nullptr;
	};
	const auto* int_button = find_action(flat, "open:val:Missions/survival.reward_interval");
	check(custom != nullptr && custom->kind == RowKind::Checkbox && custom->value
		&& custom->label == "Custom Reward interval"
		&& int_button != nullptr && int_button->kind == RowKind::Button && !int_button->locked
		&& int_button->label == "Reward interval: 150 s (stock 300 s)"
		&& find_row(flat, "value:missions/survival.reward_interval") == nullptr
		&& editor != nullptr && editor->kind == RowKind::InputCount && editor->count == 150
		&& editor->minimum == 1 && editor->maximum == 3600
		&& editor->label == "Reward interval (stock 300 s)" && editor->validate
		&& reward_page.title == "REWARD INTERVAL",
		"R4 int >= 0: Custom checkbox + a value BUTTON on the list; its one-row page holds the INPUTCOUNT with stock in the label and bounds");
	const auto* float_button = find_action(flat, "open:val:Missions/survival.pickup_multiplier");
	const auto* negative_button = find_action(flat, "open:val:Missions/defense.offset");
	const auto float_page = build_value_page(view, "survival.pickup_multiplier");
	const auto negative_page = build_value_page(view, "defense.offset");
	const auto* float_editor = float_page.rows.empty() ? nullptr : &float_page.rows[0];
	const auto* negative = negative_page.rows.empty() ? nullptr : &negative_page.rows[0];
	check(float_button != nullptr && float_button->kind == RowKind::Button
		&& float_button->label == "Pickup multiplier: 2.5x (stock 1.5x)"
		&& float_button->setting == "action:open:val:Missions/survival.pickup_multiplier"
		&& negative_button != nullptr && negative_button->kind == RowKind::Button
		&& find_row(flat, "value:missions/survival.pickup_multiplier") == nullptr
		&& find_row(flat, "value:missions/defense.offset") == nullptr,
		"float and negative int: the list shows a BUTTON with the current value, never the INPUTBOX itself");
	check(float_editor != nullptr && float_page.rows.size() == 1 && float_editor->kind == RowKind::InputBox
		&& float_editor->content == "2.5" && float_editor->setting == "value:missions/survival.pickup_multiplier"
		&& float_editor->validate && !float_editor->integer && float_page.title == "PICKUP MULTIPLIER"
		&& negative != nullptr && negative_page.rows.size() == 1 && negative->kind == RowKind::InputBox && negative->integer
		&& enum_editor != nullptr && enum_editor->kind == RowKind::Toggle && enum_editor->options.size() == 3
		&& enum_editor->number == 1,
		"value page: one validated INPUTBOX (float / negative int); enum uses TOGGLE at its stock option");
	check(!build_value_page(view, "survival.reward_interval").rows.empty()
		&& build_value_page(view, "defense.mode").rows.empty()
		&& build_value_page(view, "no.such.value").rows.empty(),
		"R4 value pages exist for every number (INPUTCOUNT or INPUTBOX); the enum TOGGLE stays inline");
	check(section != nullptr && section->kind == RowKind::Checkbox && !section->value,
		"section switch is the first row of its section and reflects the file");
	const auto* literal_button = find_action(flat, "open:val:Missions/void_flood.fractures_per_round.normal");
	check(literal_value != nullptr && literal_value->locked && literal_value->kind == RowKind::InputCount
		&& literal_button != nullptr && !literal_button->locked,
		"literal-lane values are read-only in v1: the value page editor is locked, the list BUTTON is not (R4: stock never restores a locked row's Label alpha on a recycled clip)");
	{
		// R4: no list page holds a stock INPUTCOUNT (widgets bound to the
		// first clip), an INPUTBOX (breaks the scroll contract) or a locked
		// value BUTTON (Label alpha leak); every number opens its value page.
		const auto list_safe = [&](const Page& page)
		{
			return std::all_of(page.rows.begin(), page.rows.end(), [](const Row& row)
			{
				return row.kind != RowKind::InputCount && row.kind != RowKind::InputBox
					&& !(row.kind == RowKind::Button && row.locked);
			});
		};
		bool every_number_opens = true;
		for (const auto& declaration : declarations.values)
		{
			if (declaration.type == settings::ValueType::Enum) continue;
			const auto page = build_value_page(view, declaration.id);
			every_number_opens &= find_action(flat, "open:val:Missions/" + declaration.id) != nullptr
				&& page.rows.size() == 1
				&& page.rows[0].kind == (declaration.type == settings::ValueType::Int && declaration.minimum >= 0
					? RowKind::InputCount : RowKind::InputBox);
		}
		check(list_safe(flat) && list_safe(build_group_page(view, "survival")) && every_number_opens,
			"R4 list pages hold no INPUTCOUNT, no INPUTBOX and no locked value BUTTON; every number opens its one-row page");
	}
	check(std::all_of(flat.rows.begin(), flat.rows.end(), [](const Row& row)
		{
			return row.kind != RowKind::Button || row.action.rfind("open:val:", 0) == 0;
		}),
		"flat page: its only BUTTONs open value pages (no package/section navigation, Restore or FinishSelection)");

	// Stock scroll contract (44.0.2 ThemedGenericSettings Update L4740-4880).
	{
		Page mixed;
		mixed.rows.push_back(title("Section"));
		mixed.rows.push_back(checkbox("Switch", "x", false, ""));
		Page with_box = mixed;
		Row box;
		box.kind = RowKind::InputBox;
		with_box.rows.push_back(box);
		Page long_uniform;
		for (std::size_t index = 0; index != stock_uniform_visible_rows + 1; ++index)
			long_uniform.rows.push_back(checkbox("Row", "r", false, ""));
		Page fits = long_uniform;
		fits.rows.pop_back();
		check(stock_uniform_heights(mixed) && !stock_uniform_heights(with_box)
			&& stock_scroll_attached(long_uniform) && !stock_scroll_attached(fits) && !stock_scroll_attached(with_box),
			"scroll model: TITLE (mHeight 44) and CHECKBOX are uniform; any INPUTBOX disables the scroll bar; more than 14 uniform rows attach it");
	}
	check(count_kind(flat, RowKind::InputBox) == 0 && count_kind(flat, RowKind::Spacer) == 0
		&& stock_uniform_heights(flat),
		"flat page keeps the stock scroll contract (no INPUTBOX, no SPACER, uniform heights)");
	check(custom != nullptr && custom->tooltip.find("All Survival nodes") != std::string::npos
		&& custom->tooltip.find("Applies: live, at the next read") != std::string::npos,
		"tooltips carry scope and apply timing");
	check(custom != nullptr && editor != nullptr && literal_value != nullptr
		&& custom->tooltip.find(live_stock_sentence) != std::string::npos
		&& editor->tooltip.find(live_stock_sentence) != std::string::npos
		&& literal_value->tooltip.find(live_stock_sentence) == std::string::npos,
		"stock_check absent (live): addon rows say the value applies only where the live value equals stock; literal rows do not");
	{
		// An addon that applies its value without a live stock comparison
		// (stock_check "none") must not claim one.
		settings::Declarations none;
		const auto error = settings::parse_declarations(
			"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"b\", \"groups\": ["
			" { \"id\": \"g\", \"label\": \"Group\", \"order\": 1, \"aliases\": [] } ] }",
			{{"Other.target.addon.lua_B",
				"{ \"values\": { \"g.transform\": { \"group\": \"g\", \"label\": \"Forced level\", \"unit\": \"\","
				" \"type\": \"int\", \"stock\": 5, \"min\": 0, \"max\": 5, \"scope\": \"Unticked: dynamic\","
				" \"lane\": \"addon\", \"applies\": \"live_next_read\", \"stock_check\": \"none\" } } }"}},
			none);
		PackageView other;
		other.folder = "Other";
		other.display = "Other";
		other.declarations = &none;
		const auto other_page = build_flat_page({other});
		const auto* none_custom = find_row(other_page, "custom:other/g.transform");
		const auto none_page = build_value_page(other, "g.transform");
		const auto* none_editor = none_page.rows.size() == 1 ? &none_page.rows[0] : nullptr;
		check(error.empty() && none_custom != nullptr && none_editor != nullptr
			&& none_editor->tooltip == "Stock 5. Range 0 to 5. Unticked: dynamic. Applies: live, at the next read."
			&& none_custom->tooltip == "Off: the stock value is used. " + none_editor->tooltip,
			"stock_check none: the tooltip is derived from the declaration and omits the live-stock sentence");
	}

	const auto root = build_root_page({view});
	check(root.rows.size() == 1
		&& root.rows[0].kind == RowKind::Button && root.rows[0].action == "open:pkg:Missions"
		&& root.rows[0].label == "Missions: 5 values - 1 custom",
		"R5 nested L1 (Risk of Options): the top page only lists the packages, one BUTTON each with a value summary");
	{
		// R3: BUTTON rows carry no stock sub-label; the detail is part of the
		// 40-character label and the label, never the detail, is cut.
		const auto cut = button_label("A very long mission section label that cannot fit", "12 values - 3 custom");
		const auto plain = button_label("Restore all stock values", "");
		const auto dropped = button("Section", "open:grp:X/y", std::string(36, 'd'), "Open Section.");
		check(cut.size() <= maximum_row_label && cut.size() > 22 && cut.compare(cut.size() - 22, 22, ": 12 values - 3 custom") == 0
			&& plain == "Restore all stock values"
			&& dropped.label == "Section" && dropped.tooltip.rfind(std::string(36, 'd') + ". Open Section.", 0) == 0,
			"R3 BUTTON label: '<label>: <detail>' within 40 characters, the label is cut and a detail that cannot fit opens the tooltip");
		settings::ValueDecl long_value;
		long_value.label = "Bonus damage per Cold status stack";
		long_value.unit = "x";
		long_value.stock = 0;
		const auto long_label = value_button_label(long_value, 1.75);
		check(long_label == "Bonus damage per Cold status: 1.75x",
			"R3 value BUTTON: the current value always shows; the stock suffix goes first, then the label is cut at a word");
	}
	const auto package_page = build_package_page(view);
	check(std::any_of(package_page.rows.begin(), package_page.rows.end(),
			[](const Row& row) { return row.kind == RowKind::Button && row.action == "open:grp:Missions/survival"; })
		&& std::any_of(package_page.rows.begin(), package_page.rows.end(),
			[](const Row& row) { return row.kind == RowKind::Button && row.action == "restore:Missions"; }),
		"nested L2: mission-type buttons and Restore all");
	check(!package_page.rows.empty() && package_page.rows[0].setting == "package:missions"
		&& package_page.rows.size() > 1 && package_page.rows[1].setting == "stock:missions"
		&& std::none_of(package_page.rows.begin(), package_page.rows.end(),
			[](const Row& row) { return row.kind == RowKind::Title && row.label == "MISSIONS"; })
		&& std::count_if(package_page.rows.begin(), package_page.rows.end(),
			[](const Row& row) { return row.setting.rfind("member:", 0) == 0; }) == 2,
		"R5 nested L2: the package switch and the use-stock master first (the page title names the package), then member switches (2 members)");
	{
		PackageView single = view;
		single.members.resize(1);
		const auto single_page = build_package_page(single);
		check(std::none_of(single_page.rows.begin(), single_page.rows.end(),
				[](const Row& row) { return row.setting.rfind("member:", 0) == 0; }),
			"R5 nested L2: no member switch when the package has one member");
	}
	const auto group_page = build_group_page(view, "survival");
	check(!group_page.search && group_page.rows.front().setting == "group:missions/survival"
		&& std::any_of(group_page.rows.begin(), group_page.rows.end(),
			[](const Row& row) { return row.action == "restore:Missions/survival"; }),
		"nested L3: section switch first, Restore section; the stock search box stays off (R4)");
	check(stock_uniform_heights(root) && stock_uniform_heights(package_page) && stock_uniform_heights(group_page)
		&& find_action(group_page, "open:val:Missions/survival.pickup_multiplier") != nullptr,
		"nested pages keep the stock scroll contract too; floats open the same value page");

	// Member switches: long manifest labels are cut without dangling list
	// punctuation; the full label, the file and the declared values are in the tooltip.
	{
		const MemberView tunables{addon_file, "Mission tunables: Purgatory, HalloweenLanternEndless, SurvivalMission",
			"member:missions/missions.targets.addon.lua_b", true, false};
		const MemberView exact{literal_file, "Exact replacement: ZarimanCorruptionMission (void_flood.fractures_per_round.normal)",
			"member:missions/x", true, true};
		const MemberView fits_row{addon_file, "Mission values: Survival, Defense", "member:missions/y", true, false};
		const auto exact_tooltip = member_tooltip(view, exact);
		const auto addon_tooltip = member_tooltip(view, fits_row);
		check(member_row_label(tunables) == "Mission tunables: Purgatory"
			&& member_row_label(exact) == "Exact replacement"
			&& member_row_label(fits_row) == "Mission values: Survival, Defense",
			"member row label: fits unchanged; over 40 cut at a word without trailing ',' or ':'");
		check(exact_tooltip.rfind("Exact replacement: ZarimanCorruptionMission (void_flood.fractures_per_round.normal). Replaces a stock script.", 0) == 0
			&& exact_tooltip.find("File: " + literal_file + ".") != std::string::npos
			&& exact_tooltip.find("Sections: Void Flood (1).") != std::string::npos
			&& addon_tooltip.find("Sections: Survival (2), Defense (2).") != std::string::npos
			&& addon_tooltip.find("Replaces") == std::string::npos
			&& exact_tooltip.size() <= maximum_tooltip,
			"member tooltip: full label, replacement note, file and declared values per section");
		const auto* literal_member_row = find_row(flat, "member:missions/" + script_control::ascii_lower(literal_file));
		check(literal_member_row != nullptr && literal_member_row->label == "Void Flood fractures"
			&& literal_member_row->tooltip == member_tooltip(view, view.members[1]),
			"the flat page uses the member label and tooltip helpers");
	}

	// Staging -> applied state.
	Session session;
	check(stage(session, {view}, "custom:missions/survival.pickup_multiplier", StagedValue::of_bool(true)).empty()
		&& stage(session, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("3.25")).empty()
		&& stage(session, {view}, "value:missions/survival.reward_interval", StagedValue::of_number(200)).empty()
		&& stage(session, {view}, "stock:missions", StagedValue::of_bool(true)).empty()
		&& stage(session, {view}, "member:missions/missions.targets.addon.lua_b", StagedValue::of_bool(false)).empty(),
		"staging accepts CHECKBOX, INPUTCOUNT, INPUTBOX text and member rows");
	check(stage(session, {view}, "value:missions/survival.reward_interval", StagedValue::of_number(9999)) == "outside-min-max"
		&& stage(session, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("abc")) == "not-a-number"
		&& stage(session, {view}, "value:missions/void_flood.fractures_per_round.normal", StagedValue::of_number(5)) == "read-only-row"
		&& stage(session, {view}, "value:other/x", StagedValue::of_number(1)) == "unknown-setting",
		"host re-validates every staged value (second line of defence behind the native validator)");
	auto applied = apply(session, {view});
	check(applied.packages.size() == 1 && applied.packages[0].state.use_stock
		&& applied.packages[0].state.values["survival.pickup_multiplier"].enabled
		&& applied.packages[0].state.values["survival.pickup_multiplier"].value == 3.25
		&& applied.packages[0].state.values["survival.reward_interval"].value == 200
		&& applied.policy.size() == 1 && applied.policy[0].first == "member:missions/missions.targets.addon.lua_b"
		&& !applied.policy[0].second,
		"apply merges staged rows into one values file per package and one policy batch");
	Session restore_session;
	restore(restore_session, {view}, "Missions/survival");
	auto restored = apply(restore_session, {view});
	check(restored.packages.size() == 1
		&& !restored.packages[0].state.values["survival.reward_interval"].enabled
		&& restored.packages[0].state.values["survival.reward_interval"].value == 150,
		"Restore unticks Custom in scope and remembers the value");
	Session empty_session;
	const auto nothing = apply(empty_session, {view});
	check(nothing.packages.empty() && nothing.policy.empty(), "a session with no changes is a no-op");
	Session same_session;
	(void)stage(same_session, {view}, "value:missions/survival.reward_interval", StagedValue::of_number(150));
	check(apply(same_session, {view}).packages.empty(), "restaging the current value is not a change");

	// R5 (live 2026-09-30): a value edited on its page was written with
	// enabled=false, because the "Custom" switch is a separate list row that
	// the completion pass restaged unticked. An edit now turns it on.
	{
		const auto value_of = [](const Applied& result, std::string_view id, bool& enabled, double& value)
		{
			for (const auto& package : result.packages)
			{
				const auto entry = package.state.values.find(std::string(id));
				if (entry == package.state.values.end()) continue;
				enabled = entry->second.enabled;
				value = entry->second.value;
				return true;
			}
			return false;
		};
		bool enabled = false;
		double number = 0;
		Session edited;
		const bool staged = stage(edited, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("3.25")).empty()
			&& stage(edited, {view}, "custom:missions/survival.pickup_multiplier", StagedValue::of_bool(false)).empty();
		check(staged && value_of(apply(edited, {view}), "survival.pickup_multiplier", enabled, number) && enabled && number == 3.25
			&& edited.implied_custom.size() == 1,
			"R5: an edited value is written enabled, although the list's unticked Custom row is restaged at close");
		const auto group_view = overlay(edited, {view});
		const auto edited_page = build_group_page(group_view[0], "survival");
		const auto* switch_row = find_row(edited_page, "custom:missions/survival.pickup_multiplier");
		const auto* value_button = find_action(edited_page, "open:val:Missions/survival.pickup_multiplier");
		check(switch_row != nullptr && switch_row->value && value_button != nullptr
			&& value_button->label == "Pickup multiplier: 3.25x (stock 1.5x)",
			"R5: the page the bridge re-reads after the value page closes shows the ticked switch and the new value");

		Session unticked;
		(void)stage(unticked, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("3.25"));
		(void)stage(unticked, {view}, "custom:missions/survival.pickup_multiplier", StagedValue::of_bool(false), StageSource::Click);
		check(value_of(apply(unticked, {view}), "survival.pickup_multiplier", enabled, number) && !enabled && number == 3.25,
			"R5: an explicit click on the switch after the edit decides (off, the value is remembered)");

		Session unchanged;
		(void)stage(unchanged, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("2.5"));
		(void)stage(unchanged, {view}, "custom:missions/survival.pickup_multiplier", StagedValue::of_bool(false));
		check(apply(unchanged, {view}).packages.empty() && unchanged.implied_custom.empty(),
			"R5: closing a value page without a change turns nothing on and writes nothing");

		Session back;
		(void)stage(back, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("3.25"));
		(void)stage(back, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("2.5"));
		check(apply(back, {view}).packages.empty() && back.implied_custom.empty(),
			"R5: an edit set back to the opening value restores the opening state");

		Session enabled_edit;
		(void)stage(enabled_edit, {view}, "value:missions/survival.reward_interval", StagedValue::of_number(60));
		(void)stage(enabled_edit, {view}, "custom:missions/survival.reward_interval", StagedValue::of_bool(true));
		check(value_of(apply(enabled_edit, {view}), "survival.reward_interval", enabled, number) && enabled && number == 60,
			"R5: an already custom value keeps its switch and takes the new value (INPUTCOUNT page)");

		Session restored_edit;
		(void)stage(restored_edit, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("3.25"));
		restore(restored_edit, {view}, "Missions/survival");
		check(value_of(apply(restored_edit, {view}), "survival.pickup_multiplier", enabled, number) && !enabled && number == 3.25,
			"R5: Restore still wins over an edit in its scope");

		Session rejected;
		check(stage(rejected, {view}, "value:missions/survival.pickup_multiplier", StagedValue::of_text("250")) == "outside-min-max"
			&& rejected.implied_custom.empty() && apply(rejected, {view}).packages.empty(),
			"R5: a rejected value turns nothing on (the bridge shows the stock message on Back)");
	}
}

// -----------------------------------------------------------------------------
// Part 7 (optional, --package <folder> [--settings <file>]): a REAL package
// folder and values file through the exact scanner, the settings evaluation,
// the member deliveries and the SCRIPT SETTINGS page model (built the way the
// host's build_script_settings_views builds it). Every declaration, delivery
// and row is printed so the result can be read without the game.
void external_package(const std::filesystem::path& package_folder, const std::filesystem::path* values_path,
	const std::filesystem::path& work)
{
	using namespace renovice::settings_ui;
	const auto source = package_folder.filename().empty() ? package_folder.parent_path() : package_folder;
	const std::string folder = source.filename().string();
	const std::string label = "external " + folder + ": ";
	std::cout << "INFO\texternal package folder=" << folder << " settings="
		<< (values_path != nullptr ? values_path->filename().string() : std::string("<none: every value stock>")) << '\n';
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);
	gate::policy.clear();
	std::filesystem::create_directories(gate::root / "Packages" / folder, ec);
	std::filesystem::copy(source, gate::root / "Packages" / folder, std::filesystem::copy_options::recursive, ec);
	check(!ec && std::filesystem::is_regular_file(gate::root / "Packages" / folder / "package.json"),
		label + "package folder copied into an empty CustomScripts tree");
	std::string values_text;
	if (values_path != nullptr)
	{
		values_text = read_text(*values_path);
		check(!values_text.empty(), label + "values file read");
		write_text(gate::root / "Settings" / settings::values_file_name(folder), values_text);
	}
	gate::log_lines.clear();
	check(packages::initialise(), label + "startup scan PASS");
	const auto snapshot = packages::candidate();
	const auto* package = snapshot ? find_package(*snapshot, folder) : nullptr;
	for (const auto& line : gate::log_lines) std::cout << "LOG\t" << line << '\n';
	check(package != nullptr && package->accepted,
		label + "package accepted" + (package != nullptr && !package->reason.empty() ? " (reason " + package->reason + ")" : ""));
	check(package != nullptr && package->declarations != nullptr && package->settings_reason.empty(),
		label + "settings declarations accepted by the runtime parser"
			+ (package != nullptr && !package->settings_reason.empty() ? " (reason " + package->settings_reason + ")" : ""));
	if (package == nullptr || package->declarations == nullptr) return;
	const auto& declarations = *package->declarations;
	for (const auto& value : declarations.values)
	{
		std::cout << "DECL\tid=" << value.id << " member=" << value.member << " group=" << value.group
			<< " lane=" << settings::lane_label(value.lane) << " type=" << settings::value_type_label(value.type)
			<< " stock=" << settings::json::number_text(value.stock) << " min=" << settings::json::number_text(value.minimum)
			<< " max=" << settings::json::number_text(value.maximum) << " applies=" << settings::applies_label(value.applies)
			<< " stock_check=" << (value.lane != settings::Lane::Addon ? "n/a"
				: std::string(settings::stock_check_label(value.stock_check)) + (value.stock_check_declared ? "" : "(default)"))
			<< '\n';
	}

	// The values file exactly as the runtime reads it.
	settings::UserState state;
	std::string file_error;
	const bool present = packages::read_settings_values(*package, state, file_error);
	check(present == (values_path != nullptr), label + (values_path != nullptr
		? "the runtime finds Settings/" + settings::values_file_name(folder)
		: std::string("no values file (every value stock)")));
	check(file_error.empty(), label + "values file valid" + (file_error.empty() ? "" : " (reason " + file_error + ")"));
	const auto evaluation = settings::evaluate(declarations, present && file_error.empty() ? &state : nullptr, file_error);
	for (const auto& rejection : evaluation.rejections)
		std::cout << "REJECT\tid=" << rejection.id << " reason=" << rejection.reason << '\n';
	std::cout << "INFO\tfile=" << settings::file_status_label(evaluation.file) << " use_stock=" << (evaluation.use_stock ? 1 : 0)
		<< " effective=" << evaluation.effective.size() << " rejected=" << evaluation.rejections.size()
		<< " unknown_entries=" << evaluation.unknown_entries << '\n';
	check(evaluation.rejections.empty(), label + "no value in the values file is rejected");

	// Deliveries: every addon member that declares values receives one.
	bool deliveries = true;
	for (const auto& member : package->members)
	{
		std::cout << "MEMBER\t" << member.filename << " staged=" << (member.staged ? 1 : 0)
			<< " enabled=" << (member.enabled ? 1 : 0) << " delivery=" << (member.delivery ? "yes" : "nil");
		if (member.delivery) std::cout << " values=" << member.delivery->values.size() << " identity=" << member.delivery->identity;
		std::cout << '\n';
		if (member.delivery)
		{
			for (const auto& value : member.delivery->values)
			{
				std::cout << "DELIVER\t" << member.filename << " context.settings[\"" << value.id << "\"] = { enabled = true, value = "
					<< settings::json::number_text(value.value) << ", stock = " << settings::json::number_text(value.stock) << " }\n";
			}
		}
		const bool addon = member.kind != packages::MemberKind::Replacement;
		if (addon && settings::member_declares_values(declarations, member.filename)) deliveries &= member.delivery != nullptr;
	}
	check(deliveries, label + "every addon member that declares values receives a delivery (context.settings)");

	// SCRIPT SETTINGS page model, as build_script_settings_views builds it.
	PackageView view;
	view.folder = package->folder;
	view.display = package->display;
	view.declarations = &declarations;
	for (const auto& member : package->members)
	{
		view.members.push_back(MemberView{member.filename, member.label, member.state_id, member.enabled,
			member.kind == packages::MemberKind::Replacement});
	}
	if (present && file_error.empty()) view.state = state;
	const auto page = build_flat_page({view});
	bool labels_fit = true;
	bool tooltips_fit = true;
	bool sentence_rule = true;
	// ROW / VALROW lines carry every descriptor field the host sends, so the
	// stock-render gate (verify_script_settings_render.ps1 -PageRows) can run
	// exactly these rows through the stock screen.
	const auto print_row = [](const std::string& prefix, const Row& row)
	{
		std::cout << prefix << '\t' << row_kind_name(row.kind) << '\t' << row.setting << '\t' << row.label;
		if (row.kind == RowKind::InputCount) std::cout << "\tcount=" << settings::json::number_text(row.count);
		if (row.kind == RowKind::InputBox) std::cout << "\tcontent=" << row.content;
		if (row.kind == RowKind::Checkbox) std::cout << "\tvalue=" << (row.value ? "on" : "off");
		if (row.kind == RowKind::Button) std::cout << "\taction=" << row.action;
		if (row.kind == RowKind::Toggle)
		{
			std::cout << "\tnumber=" << settings::json::number_text(row.number);
			for (const auto& option : row.options)
				std::cout << "\toption=" << settings::json::number_text(option.value) << ':' << option.label;
		}
		if (row.kind == RowKind::InputCount || row.kind == RowKind::InputBox)
		{
			std::cout << "\tmin=" << settings::json::number_text(row.minimum)
				<< "\tmax=" << settings::json::number_text(row.maximum);
			if (row.validate) std::cout << "\tvalidate";
			if (row.integer) std::cout << "\tinteger";
			if (!row.invalid_message.empty()) std::cout << "\tinvalid=" << row.invalid_message;
		}
		if (row.locked) std::cout << "\tlocked";
		if (!row.tooltip.empty()) std::cout << "\ttooltip=" << row.tooltip;
		std::cout << '\n';
	};
	std::cout << "PAGE\ttitle=" << page.title << "\tsearch=" << (page.search ? 1 : 0) << '\n';
	for (const auto& row : page.rows)
	{
		print_row("ROW", row);
		labels_fit &= row.label.size() <= (row.kind == RowKind::Title ? maximum_title_label : maximum_row_label);
		tooltips_fit &= row.tooltip.size() <= maximum_tooltip;
		for (const auto& declaration : declarations.values)
		{
			const std::string suffix = settings_ui::folder_key(view.folder) + "/" + declaration.id;
			if (row.setting != "value:" + suffix && row.setting != "custom:" + suffix) continue;
			const bool claims = row.tooltip.find(live_stock_sentence) != std::string::npos;
			sentence_rule &= claims == (declaration.lane == settings::Lane::Addon
				&& declaration.stock_check == settings::StockCheck::Live);
		}
	}
	bool value_pages = true;
	for (const auto& row : page.rows)
	{
		if (row.action.rfind("open:val:", 0) != 0) continue;
		const auto body = std::string_view(row.action).substr(9);
		const auto slash = body.find('/');
		const auto value_page = slash == std::string_view::npos ? Page{}
			: build_value_page(view, body.substr(slash + 1));
		std::cout << "VALPAGE\t" << row.action << "\ttitle=" << value_page.title << "\trows=" << value_page.rows.size();
		if (!value_page.rows.empty())
			std::cout << '\t' << row_kind_name(value_page.rows[0].kind) << '\t' << value_page.rows[0].setting
				<< '\t' << value_page.rows[0].label << "\tcontent=" << value_page.rows[0].content;
		std::cout << '\n';
		for (const auto& value_row : value_page.rows) print_row("VALROW\t" + row.action, value_row);
		const auto* value_declaration = slash == std::string_view::npos ? nullptr
			: declarations.value(body.substr(slash + 1));
		value_pages &= value_declaration != nullptr && value_page.rows.size() == 1
			&& value_page.rows[0].kind == (value_declaration->type == settings::ValueType::Int
				&& value_declaration->minimum >= 0 ? RowKind::InputCount : RowKind::InputBox)
			&& value_page.rows[0].label == editor_label(*value_declaration)
			&& row.label == value_button_label(*value_declaration, current_value(view, *value_declaration));
	}
	bool member_labels = true;
	for (const auto& member : view.members)
		member_labels &= clean(member.label.empty() ? member.filename : member.label).size() <= maximum_row_label;
	std::cout << "SCROLL\trows=" << page.rows.size() << " uniform=" << (stock_uniform_heights(page) ? 1 : 0)
		<< " scroll=" << (stock_scroll_attached(page) ? 1 : 0) << '\n';
	check(!page.rows.empty(), label + "SCRIPT SETTINGS page has rows");
	check(stock_uniform_heights(page),
		label + "the flat page keeps the stock scroll contract (uniform 44 px rows, no INPUTBOX): it scrolls once it exceeds 14 rows");
	check(value_pages, label + "every value-page BUTTON shows its current value and opens exactly one editor for the same value (INPUTCOUNT for int >= 0, else INPUTBOX)");
	check(!page.search && std::all_of(page.rows.begin(), page.rows.end(), [](const Row& row)
		{
			return row.kind != RowKind::InputCount && row.kind != RowKind::InputBox
				&& !(row.kind == RowKind::Button && row.locked);
		}),
		label + "R4: the flat page holds no INPUTCOUNT, INPUTBOX or locked BUTTON, and the stock search box stays off");
	check(view.members.size() < 2 || member_labels,
		label + "every member label fits the 40-character row without cutting (package.json producer rule)");
	// R5: the nested layout (the default) for this package: the package page
	// and every section page keep the stock row rules proven in R2-R4.
	{
		const auto list_safe = [](const Page& nested)
		{
			return stock_uniform_heights(nested) && !nested.search
				&& std::all_of(nested.rows.begin(), nested.rows.end(), [](const Row& row)
				{
					return row.kind != RowKind::InputCount && row.kind != RowKind::InputBox
						&& !(row.kind == RowKind::Button && row.locked) && row.label.size() <= maximum_title_label;
				});
		};
		const auto root = build_root_page({view});
		const auto package_page = build_package_page(view);
		bool nested_ok = root.rows.size() == 1 && root.rows[0].action == "open:pkg:" + view.folder
			&& list_safe(root) && list_safe(package_page);
		std::size_t sections = 0;
		std::size_t section_rows = 0;
		for (const auto& row : package_page.rows)
		{
			if (row.action.rfind("open:grp:", 0) != 0) continue;
			const auto group = row.action.substr(row.action.find('/') + 1);
			const auto section = build_group_page(view, group);
			++sections;
			section_rows += section.rows.size();
			nested_ok &= !section.rows.empty() && list_safe(section);
			for (const auto& section_row : section.rows)
			{
				if (section_row.action.rfind("open:val:", 0) == 0)
					nested_ok &= !build_value_page(view, section_row.action.substr(section_row.action.find('/') + 1)).rows.empty();
			}
		}
		std::cout << "NESTED\troot_rows=" << root.rows.size() << " package_rows=" << package_page.rows.size()
			<< " sections=" << sections << " section_rows=" << section_rows << '\n';
		check(nested_ok && sections == static_cast<std::size_t>(std::count_if(declarations.groups.begin(), declarations.groups.end(),
				[&](const settings::GroupDecl& group) { return value_count(view, group.id) != 0; })),
			label + "R5 nested layout: one package BUTTON on the top page; the package and every section page keep the stock row rules; every value BUTTON opens its value page");
	}
	check(labels_fit, label + "every row label fits the width budget (40 value / 48 title)");
	check(tooltips_fit, label + "every tooltip fits the tooltip budget");
	check(sentence_rule, label + "the live-stock tooltip sentence appears exactly on addon rows with stock_check live");
}

// -----------------------------------------------------------------------------
// Part 8 (optional, --replay <file>): the R5 edit flow end to end. The stock
// render harness (verify_script_settings_render.ps1) drives the bridge under
// test through the stock GenericSettings screen, with nested navigation, value
// pages, Confirm and Back, and records every host stage call. Each recorded
// session is replayed here from the same opening state through the exact host
// model (settings_ui::stage, apply) and the values file writer and parser.
// Lines (tab-separated):
//   SESSION <name>
//   STAGE   <setting> <bool|number|text> <value> <click|restage>
//   RESTORE <Folder>[/<group>]
//   EXPECT  <session> <folder> <value id> enabled=<0|1> value=<number>
//   EXPECT  <session> <folder> file=unchanged
namespace r5
{
const char* frost_top =
	"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\", \"groups\": ["
	" { \"id\": \"ice_wave\", \"label\": \"Ice Wave\", \"order\": 10, \"aliases\": [] } ] }";
const char* frost_values =
	"{ \"values\": { \"ice_wave.bonus_per_cold_stack\": { \"group\": \"ice_wave\", \"label\": \"Bonus per Cold stack\","
	" \"unit\": \"x\", \"type\": \"float\", \"stock\": 0, \"min\": 0, \"max\": 100, \"scope\": \"Frost Ice Wave\","
	" \"lane\": \"addon\", \"applies\": \"live_next_read\", \"stock_check\": \"none\" } } }";
const char* missions_top =
	"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\", \"groups\": ["
	" { \"id\": \"survival\", \"label\": \"Survival\", \"order\": 10, \"aliases\": [] },"
	" { \"id\": \"purgatory\", \"label\": \"Purgatory\", \"order\": 20, \"aliases\": [] } ] }";
const char* missions_values =
	"{ \"values\": {"
	" \"survival.reward_interval\": { \"group\": \"survival\", \"label\": \"Reward interval\", \"unit\": \"s\","
	"   \"type\": \"float\", \"stock\": 300, \"min\": 1, \"max\": 32767, \"scope\": \"All Survival nodes. Case: normal\","
	"   \"lane\": \"addon\", \"applies\": \"live_next_read\" },"
	" \"survival.alert_interval\": { \"group\": \"survival\", \"label\": \"Seconds per reward rotation\", \"unit\": \"s\","
	"   \"type\": \"float\", \"stock\": 600, \"min\": 1, \"max\": 60000, \"scope\": \"All Survival nodes. Case: alert\","
	"   \"lane\": \"addon\", \"applies\": \"live_next_read\" },"
	" \"purgatory.difficulty1.warrior_level\": { \"group\": \"purgatory\", \"label\": \"Difficulty 1 warrior level\","
	"   \"unit\": \"\", \"type\": \"int\", \"stock\": 10, \"min\": 1, \"max\": 1000, \"scope\": \"Purgatory\","
	"   \"lane\": \"addon\", \"applies\": \"live_next_read\" } } }";

std::vector<std::string> split_tabs(const std::string& line)
{
	std::vector<std::string> fields;
	std::size_t start = 0;
	while (true)
	{
		const auto tab = line.find('\t', start);
		fields.push_back(line.substr(start, tab == std::string::npos ? std::string::npos : tab - start));
		if (tab == std::string::npos) break;
		start = tab + 1;
	}
	return fields;
}
}

void replay(const std::filesystem::path& file)
{
	using namespace renovice::settings_ui;
	settings::Declarations frost;
	settings::Declarations missions;
	const auto frost_error = settings::parse_declarations(r5::frost_top,
		{{"8fba3a28f8fef624.IceWaveColdStackDamage.target.addon.lua_B", r5::frost_values}}, frost);
	const auto missions_error = settings::parse_declarations(r5::missions_top,
		{{addon_file, r5::missions_values}}, missions);
	check(frost_error.empty() && missions_error.empty(), "R5 replay: the Frost and Missions declarations parse");
	std::vector<PackageView> views(2);
	views[0].folder = "Frost";
	views[0].display = "Frost";
	views[0].declarations = &frost;
	views[0].state.package = "package:frost";
	views[0].state.values["ice_wave.bonus_per_cold_stack"] = settings::UserValue{true, {}, true, true, 50, false, 0};
	views[1].folder = "Missions";
	views[1].display = "Missions";
	views[1].declarations = &missions;
	views[1].state.package = "package:missions";
	views[1].state.values["survival.reward_interval"] = settings::UserValue{true, {}, true, true, 150, false, 0};

	std::ifstream input(file, std::ios::binary);
	check(static_cast<bool>(input), "R5 replay: the recorded stage file is readable");
	std::map<std::string, Applied> results;
	std::map<std::string, std::size_t> stage_counts;
	std::string current;
	Session session;
	std::vector<std::vector<std::string>> expectations;
	const auto finish = [&]()
	{
		if (current.empty()) return;
		results[current] = renovice::settings_ui::apply(session, views);
		for (const auto& package : results[current].packages)
		{
			const auto text = settings::write_values_file(package.state, package.declarations);
			settings::UserState reread;
			const auto error = settings::parse_values_file(text, package.state.package, reread);
			std::cout << "REPLAY\tsession=" << current << " write " << package.folder
				<< (error.empty() ? " parse=ok" : " parse=" + error) << '\n';
			for (const auto& [id, value] : reread.values)
			{
				std::cout << "REPLAY\tsession=" << current << " file " << package.folder << '/' << id
					<< " enabled=" << (value.enabled ? 1 : 0) << " value=" << settings::json::number_text(value.value) << '\n';
			}
		}
		session = Session{};
	};
	std::string line;
	while (std::getline(input, line))
	{
		if (!line.empty() && line.back() == '\r') line.pop_back();
		const auto fields = r5::split_tabs(line);
		if (fields.empty()) continue;
		if (fields[0] == "SESSION" && fields.size() == 2)
		{
			finish();
			current = fields[1];
		}
		else if (fields[0] == "STAGE" && fields.size() == 5 && !current.empty())
		{
			StagedValue value;
			if (fields[2] == "bool") value = StagedValue::of_bool(fields[3] == "true");
			else if (fields[2] == "number") value = StagedValue::of_number(std::stod(fields[3]));
			else value = StagedValue::of_text(fields[3]);
			const auto source = fields[4] == "click" ? StageSource::Click : StageSource::Restage;
			const auto reason = stage(session, views, fields[1], value, source);
			++stage_counts[current];
			std::cout << "REPLAY\tsession=" << current << " stage " << fields[1] << " = " << fields[3]
				<< " (" << fields[4] << ") -> " << (reason.empty() ? std::string("accepted") : "REJECT " + reason) << '\n';
		}
		else if (fields[0] == "RESTORE" && fields.size() == 2 && !current.empty())
		{
			restore(session, views, fields[1]);
			std::cout << "REPLAY\tsession=" << current << " restore " << fields[1] << '\n';
		}
		else if (fields[0] == "EXPECT") expectations.push_back(fields);
	}
	finish();
	check(!results.empty(), "R5 replay: at least one recorded session");
	for (const auto& expectation : expectations)
	{
		const auto& name = expectation.size() > 1 ? expectation[1] : std::string();
		const auto result = results.find(name);
		if (expectation.size() == 4 && expectation[3] == "file=unchanged")
		{
			const bool unchanged = result != results.end() && std::none_of(result->second.packages.begin(),
				result->second.packages.end(), [&](const AppliedPackage& package) { return package.folder == expectation[2]; });
			check(unchanged, "R5 replay " + name + ": Settings/" + expectation[2] + ".json is not written");
			continue;
		}
		bool found = false;
		bool enabled = false;
		double value = 0;
		if (result != results.end() && expectation.size() == 6)
		{
			for (const auto& package : result->second.packages)
			{
				if (package.folder != expectation[2]) continue;
				settings::UserState reread;
				const auto text = settings::write_values_file(package.state, package.declarations);
				if (!settings::parse_values_file(text, package.state.package, reread).empty()) continue;
				const auto entry = reread.values.find(expectation[3]);
				if (entry == reread.values.end()) continue;
				found = true;
				enabled = entry->second.enabled;
				value = entry->second.value;
			}
		}
		const bool want_enabled = expectation.size() == 6 && expectation[4] == "enabled=1";
		const double want_value = expectation.size() == 6 && expectation[5].rfind("value=", 0) == 0
			? std::stod(expectation[5].substr(6)) : -1;
		check(found && enabled == want_enabled && value == want_value,
			"R5 replay " + name + ": Settings/" + (expectation.size() > 2 ? expectation[2] : std::string()) + ".json holds "
				+ (expectation.size() > 3 ? expectation[3] : std::string()) + " " + (expectation.size() > 4 ? expectation[4] : std::string())
				+ " " + (expectation.size() > 5 ? expectation[5] : std::string()) + " (stages: " + std::to_string(stage_counts[name]) + ")");
	}
}

std::filesystem::path long_path(const std::filesystem::path& path)
{
	// \\?\ form: MSVC std::filesystem then creates, copies and removes trees
	// beyond MAX_PATH (the repository or the work folder may be deep).
	const std::wstring& native = path.native();
	if (native.rfind(LR"(\\?\)", 0) == 0) return path;
	const std::wstring absolute = std::filesystem::absolute(path).native();
	if (absolute.rfind(LR"(\\)", 0) == 0) return std::filesystem::path(LR"(\\?\UNC\)" + absolute.substr(2));
	return std::filesystem::path(LR"(\\?\)" + absolute);
}
}

int main(int argc, char** argv)
{
	const bool with_package = argc >= 5 && std::string_view(argv[3]) == "--package";
	const bool with_settings = argc == 7 && with_package && std::string_view(argv[5]) == "--settings";
	const bool with_replay = argc == 5 && std::string_view(argv[3]) == "--replay";
	if (!(argc == 3 || (argc == 5 && with_package) || with_settings || with_replay))
	{
		std::cerr << "usage: verify_addon_settings <work dir> <phase2i fixture dir>"
			" [--package <folder> [--settings <file>] | --replay <stage file>]\n";
		return 2;
	}
	const auto work = long_path(argv[1]);
	declarations_parser();
	values_file();
	effective_rules();
	delivery_identity();
	member_states();
	end_to_end(work);
	phase1_contract(long_path(argv[2]), work / "phase2i");
	ui_page_model();
	if (with_package)
	{
		const auto values = with_settings ? long_path(argv[6]) : std::filesystem::path();
		external_package(long_path(argv[4]), with_settings ? &values : nullptr, work / "external");
	}
	if (with_replay) replay(long_path(argv[4]));
	std::cout << (pass ? "ADDON SETTINGS PASS" : "ADDON SETTINGS FAIL") << '\n';
	return pass ? 0 : 1;
}
