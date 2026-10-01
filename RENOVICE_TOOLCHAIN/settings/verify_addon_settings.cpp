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
// Part 6: R7 page model of the SCRIPT SETTINGS UI: page tree (path), one row
//         per value, value pages with "Reset to default", "Reset all to
//         defaults", Quick settings, the value/default staging model and the
//         declared default's delivery; no package, member or Custom switch.
// Part 7: optional real package folders and values files (--package
//         <folder> [--settings <file>], repeatable): every reachable page.
// Part 8: optional host tape for the stock render harness (--tape <plan>).
//
// Usage: verify_addon_settings <work dir> <phase2i fixture dir>
//            [--package <folder> [--settings <file>]]... [--tape <plan>]
//            [--script-states <ScriptStates.json>] (R13: replays an installed
//            policy file; every delivered value must reach a staged member)
// Paths are used in \\?\ form, so deep work folders stay long-path safe.
#include <algorithm>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <map>
#include <memory>
#include <set>
#include <sstream>
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
// R13: --script-states <ScriptStates.json> replays an installed policy file in
// the external (Part 7) scan.
std::map<std::string, bool> external_policy;
bool external_policy_loaded = false;
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
		// Revision R7 layout and default fields.
		{top_with(""), value_with(base_value + ", \"path\": []"), "member=M value=g.v path-invalid"},
		{top_with(""), value_with(base_value + ", \"path\": [\"A\", \"B\", \"C\", \"D\", \"E\", \"F\", \"G\"]"), "member=M value=g.v path-invalid"},
		{top_with(""), value_with(base_value + ", \"path\": [\" padded\"]"), "member=M value=g.v path-element-invalid"},
		{top_with(""), value_with(base_value + ", \"path\": [\"" + std::string(41, 'p') + "\"]"), "member=M value=g.v path-element-invalid"},
		{top_with(""), value_with(base_value + ", \"row\": \"" + std::string(34, 'r') + "\""), "member=M value=g.v row-invalid"},
		{top_with(""), value_with(base_value + ", \"quick\": \"\""), "member=M value=g.v quick-invalid"},
		{top_with(""), value_with(base_value + ", \"default_label\": \"" + std::string(21, 'd') + "\""), "member=M value=g.v default_label-invalid"},
		{top_with(""), value_with(base_value + ", \"default\": 11"), "member=M value=g.v default-outside-min-max"},
		{top_with(""), value_with(base_value + ", \"default\": 2.5"), "member=M value=g.v default-int-has-fraction"},
		{top_with(""), value_with(base_value + ", \"default\": \"x\""), "member=M value=g.v default-not-number"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"int\", \"stock\": 5, \"min\": 0, \"max\": 10, \"lane\": \"literal\", \"default\": 4"), "member=M value=g.v default-only-for-addon-lane"},
		{top_with(""), value_with("\"group\": \"g\", \"label\": \"V\", \"type\": \"enum\", \"stock\": 1, \"min\": 0, \"max\": 10, \"options\": [{\"label\": \"A\", \"value\": 1}], \"default\": 2"), "member=M value=g.v default-not-an-option"},
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
	{
		// R7: path, row, quick, default_label and default are optional; absent
		// keeps every V1 meaning (the phase2i fixture below has none of them).
		settings::Declarations with, without;
		const bool parsed = settings::parse_declarations(top_with(""), {{"M", value_with(base_value
			+ ", \"path\": [\"Survival\", \"Rewards / drops\"], \"row\": \"Squad\", \"quick\": \"Survival: rewards\","
			  " \"default_label\": \"60-80 s\", \"default\": 7")}}, with).empty()
			&& settings::parse_declarations(top_with(""), {{"M", value_with(base_value)}}, without).empty();
		check(parsed && with.values[0].path == std::vector<std::string>{"Survival", "Rewards / drops"}
			&& with.values[0].row == "Squad" && with.values[0].quick == "Survival: rewards"
			&& with.values[0].default_label == "60-80 s" && with.values[0].default_declared
			&& settings::default_of(with.values[0]) == 7
			&& without.values[0].path.empty() && without.values[0].row.empty() && !without.values[0].default_declared
			&& settings::default_of(without.values[0]) == 5,
			"R7 fields parse (path, row, quick, default_label, default); absent: no path, default = stock");
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

	// 7. member: policy. Contract R13 (2026-10-01): retired. The live defect:
	// ScriptStates.json kept `member:missions/missions.targets.addon.lua_b:
	// false` from the R5/R6 member switches; SCRIPT SETTINGS has had no member
	// switch since R7 and SCRIPTS shows one row per package, so the addon was
	// never staged (`members_staged=0/1`, `SETTINGS DELIVERY ... staged=0`)
	// while the player edited its values. The package row is now the only
	// enable owner; a stored `false` is reported and the file is not touched.
	write_text(missions / "package.json", manifest_with("{}", "", ""));
	gate::policy[script_control::member_state_id("Missions", addon_file)] = false;
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS with a stored member: false");
	snapshot = packages::candidate();
	package = find_package(*snapshot, "Missions");
	addon = find_member(package, addon_file);
	literal = find_member(package, literal_file);
	check(package != nullptr && package->accepted && addon != nullptr && addon->enabled && addon->staged
		&& addon->policy_off_ignored && addon->bytes == addon_bytes && addon->target_keys.size() == 2
		&& literal != nullptr && literal->staged && literal->bytes == flood && !literal->policy_off_ignored,
		"R13 member: false -> ignored: the member follows its package row and is staged; siblings unaffected");
	check(logged("RENOVICE PACKAGE MEMBER POLICY IGNORED trigger=F9 package=Missions member=" + addon_file
			+ " id=member:missions/missions.targets.addon.lua_b stored=false reason=member-switch-retired-R13"
			+ " owner=package:missions file=unchanged")
		&& !logged("RENOVICE PACKAGE MEMBER DISABLED"),
		"R13 member: false -> exact POLICY IGNORED line, no MEMBER DISABLED line");
	packages::discard_prepared_reload();

	// 7b. The live state of 2026-10-01 end to end: a stored member `false`, a
	// declared addon value enabled in the values file -> the value is
	// delivered to a staged member (this is what would have caught the defect).
	write_text(missions / "package.json", manifest_with(top_settings, addon_settings, literal_settings));
	write_text(settings_dir / "Missions.json",
		"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"build\": \"2026.09.28.13.06\","
		" \"use_stock\": false, \"values\": { \"survival.reward_interval\": { \"enabled\": true, \"value\": 150 } } }");
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS (stored member false + enabled addon value)");
	snapshot = packages::candidate();
	package = find_package(*snapshot, "Missions");
	addon = find_member(package, addon_file);
	check(package != nullptr && package->accepted && addon != nullptr && addon->staged
		&& addon->delivery != nullptr && addon->delivery->values.size() == 1
		&& addon->delivery->values[0].id == "survival.reward_interval" && addon->delivery->values[0].value == 150.0f,
		"R13 regression: an enabled value of a member with a stored false is delivered to a staged member");
	check(logged("RENOVICE SETTINGS DELIVERY trigger=F9 package=Missions member=" + addon_file + " values=1 identity=")
		&& logged(" staged=1") && !logged("members_staged=0/"),
		"R13 regression: delivery reports staged=1 and the package summary never reports 0 staged members");
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

	// R7: the same path-less (pre-R7) package through the page model: its
	// sections render flat on the package page, one row per value.
	using namespace renovice::settings_ui;
	PackageView view;
	view.folder = "Missions";
	view.display = "Missions";
	view.declarations = package != nullptr ? package->declarations.get() : nullptr;
	(void)settings::parse_values_file(values_text, "package:missions", view.state);
	if (view.declarations == nullptr) return;
	const auto page = build_package_page(view);
	const auto label_of = [&](std::string_view action) -> std::string
	{
		for (const auto& row : page.rows)
			if (row.action == action) return row.label;
		return "<missing>";
	};
	std::size_t titles = 0;
	for (const auto& row : page.rows) titles += row.kind == RowKind::Title ? 1u : 0u;
	check(label_of("open:val:Missions/survival.reward_interval") == "Reward interval: 150 s"
		&& label_of("open:val:Missions/purgatory.difficulty1.warrior_level") == "Difficulty 1 warrior level: 10 (default)"
		&& label_of("open:val:Missions/lantern.tier_up_interval") == "Tier up interval: 90 s (default)"
		&& label_of("open:val:Missions/void_flood.fractures_per_round.normal") == "Fractures per round normal: 4"
		&& titles == 4 && page.rows.back().action == "resetall:Missions",
		"phase2i (no path): one row per value under its section TITLE, the current value or '(default)'; "
		"a disabled entry shows the default (15 is kept in the file); Reset all last");
	const auto reward_page = build_value_page(view, "survival.reward_interval");
	check(reward_page.title == "REWARD INTERVAL" && reward_page.rows.size() == 2
		&& reward_page.rows[0].kind == RowKind::InputBox && reward_page.rows[0].content == "150"
		&& reward_page.rows[0].setting == "value:missions/survival.reward_interval" && reward_page.rows[0].validate
		&& reward_page.rows[1].kind == RowKind::Button && reward_page.rows[1].label == "Reset to default: 300 s"
		&& reward_page.rows[1].action == "reset:Missions/value:survival.reward_interval",
		"phase2i value page: the validated INPUTBOX and 'Reset to default: 300 s'");
	const auto literal_page = build_value_page(view, "void_flood.fractures_per_round.normal");
	check(literal_page.rows.size() == 2 && literal_page.rows[0].kind == RowKind::Checkbox
		&& literal_page.rows[0].setting == "active:missions/void_flood.fractures_per_round.normal" && literal_page.rows[0].value,
		"phase2i literal value (no choices declared): the value page shows the built-value switch (the member applies when on)");
	check(reward_page.rows[0].tooltip.find(live_stock_sentence) != std::string::npos
		&& literal_page.rows[0].tooltip.find(live_stock_sentence) == std::string::npos,
		"phase2i: without stock_check the addon editor keeps the live-default sentence; literal rows never carry it");
}

using namespace renovice::settings_ui;

// -----------------------------------------------------------------------------
// R7 page model on a synthetic two-package set: Missions with paths (mission
// type -> category -> set -> value), Quick settings and a literal choice, and
// a Frost-like path-less package with an author's default.
namespace r7
{
const char* missions_top =
	"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\", \"groups\": ["
	" { \"id\": \"defense\", \"label\": \"Defense\", \"order\": 10, \"aliases\": [\"MT_DEFENSE\", \"SolNode1\"] },"
	" { \"id\": \"survival\", \"label\": \"Survival\", \"order\": 20, \"aliases\": [] },"
	" { \"id\": \"survival_advanced\", \"label\": \"Survival: advanced\", \"order\": 25, \"aliases\": [] },"
	" { \"id\": \"void_flood\", \"label\": \"Void Flood\", \"order\": 30, \"aliases\": [] } ] }";
std::string value(std::string_view id, std::string_view group, std::string_view path, std::string_view row,
	std::string_view type, double stock, double minimum, double maximum, std::string_view unit, std::string_view extra = "")
{
	return "\"" + std::string(id) + "\": { \"group\": \"" + std::string(group) + "\", \"label\": \"" + std::string(row) + " label\","
		" \"unit\": \"" + std::string(unit) + "\", \"type\": \"" + std::string(type) + "\", \"stock\": " + settings::json::number_text(stock)
		+ ", \"min\": " + settings::json::number_text(minimum) + ", \"max\": " + settings::json::number_text(maximum)
		+ ", \"scope\": \"What " + std::string(row) + " changes\", \"lane\": \"addon\", \"applies\": \"live_next_read\","
		" \"path\": " + std::string(path) + ", \"row\": \"" + std::string(row) + "\"" + std::string(extra) + " }";
}
std::string missions_addon()
{
	const std::string timers = "[\"Survival\", \"Timers\"]";
	const std::string set = "[\"Survival\", \"Enemies\", \"Max enemies at once\"]";
	return "{ \"values\": { "
		+ value("defense.mode", "defense", "[\"Defense\"]", "Wave mode", "enum", 1, 1, 3, "",
			", \"options\": [ { \"label\": \"Normal\", \"value\": 1 }, { \"label\": \"Fast\", \"value\": 2 } ]") + ", "
		+ value("defense.offset", "defense", "[\"Defense\"]", "Wave offset", "int", 0, -5, 5, "") + ", "
		+ value("survival.reward_interval", "survival", timers, "Time between rewards", "float", 300, 1, 32767, "s",
			", \"quick\": \"Survival: time between rewards\"") + ", "
		+ value("survival.alert_interval", "survival", timers, "Alert mission length", "float", 600, 1, 32767, "s") + ", "
		+ value("survival.max.p1", "survival", set, "Solo", "int", 10, 0, 100, "", ", \"default_label\": \"7-10\"") + ", "
		+ value("survival.max.p4", "survival", set, "Squad", "int", 28, 0, 100, "") + ", "
		+ value("survival.max.hard.p4", "survival", "[\"Survival\", \"Enemies\", \"Max enemies at once\", \"Hard nodes\"]",
			"Squad", "int", 28, 0, 100, "") + ", "
		+ value("survival.level", "survival_advanced", "[\"Survival\", \"Advanced\"]", "Level boost", "int", 5, 0, 50, "")
		+ " } }";
}
const char* missions_literal =
	"{ \"values\": { \"void_flood.fractures\": { \"group\": \"void_flood\", \"label\": \"Fractures per round\", \"unit\": \"\","
	" \"type\": \"enum\", \"stock\": 3, \"min\": 1, \"max\": 20, \"scope\": \"Fractures opened per round\", \"lane\": \"literal\","
	" \"applies\": \"next_mission\", \"options\": [ { \"label\": \"3\", \"value\": 3 }, { \"label\": \"4\", \"value\": 4 } ],"
	" \"path\": [\"Void Flood\"], \"row\": \"Fractures per round\", \"quick\": \"Void Flood: fractures per round\" } } }";
const char* frost_top =
	"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\", \"groups\": ["
	" { \"id\": \"ice_wave\", \"label\": \"Ice Wave\", \"order\": 10, \"aliases\": [\"Frost\"] } ] }";
const char* frost_values =
	"{ \"values\": { \"ice_wave.bonus_per_cold_stack\": { \"group\": \"ice_wave\", \"label\": \"Bonus per Cold stack\","
	" \"unit\": \"x\", \"type\": \"float\", \"stock\": 0, \"min\": 0, \"max\": 100, \"default\": 50,"
	" \"scope\": \"Ice Wave damage grows with Cold stacks. 0 turns the bonus off\","
	" \"lane\": \"addon\", \"applies\": \"live_next_read\", \"stock_check\": \"none\" } } }";
const std::string missions_addon_file = "Missions.targets.addon.lua_B";
const std::string missions_literal_file = "0123456789abcdef (missions_exact-replacement).lua_B";
const std::string frost_file = "8fba3a28f8fef624.IceWaveColdStackDamage.target.addon.lua_B";
}

const Row* row_by(const Page& page, std::string_view key)
{
	for (const auto& row : page.rows)
		if (row.action == key || row.setting == key) return &row;
	return nullptr;
}

std::string labels(const Page& page)
{
	std::string text;
	for (const auto& row : page.rows) text += (text.empty() ? "" : " | ") + row.label;
	return text;
}

// The rules every page obeys (R2-R5 stock row rules plus R7): list pages are
// uniform BUTTON/TITLE/SPACER rows (CHECKBOX only on Quick settings), no
// INPUTCOUNT/INPUTBOX/locked row, no search box; value pages hold at most the
// editor and one BUTTON (never scrolled); no package, member, "Use stock
// values", section or "Custom" switch anywhere; labels and tooltips in budget.
std::string page_rule_problem(std::string_view id, const Page& page)
{
	const bool value_page = id.rfind("val:", 0) == 0 || id.rfind("qval:", 0) == 0;
	const bool quick_page = id.rfind("quick:", 0) == 0;
	if (page.search) return "search box shown";
	if (page.title.size() > maximum_title_label) return "title over 48";
	std::set<std::string> seen;
	for (const auto& row : page.rows)
	{
		const std::string_view setting = row.setting;
		for (const char* banned : {"package:", "member:", "stock:", "group:", "custom:", "note:"})
			if (setting.rfind(banned, 0) == 0) return "switch row " + row.setting;
		if (row.label.rfind("Custom ", 0) == 0 || row.label.find("::") != std::string::npos) return "label '" + row.label + "'";
		if (row.label.size() > (row.kind == RowKind::Title ? maximum_title_label : maximum_row_label)) return "label over budget '" + row.label + "'";
		if (row.tooltip.size() > maximum_tooltip) return "tooltip over budget";
		if (row.kind == RowKind::Button && row.locked) return "locked BUTTON";
		if (row.kind != RowKind::Spacer && row.kind != RowKind::Title && !seen.insert(row.label).second)
			return "two rows read '" + row.label + "'";
		if (!value_page)
		{
			if (row.kind == RowKind::InputCount || row.kind == RowKind::InputBox || row.kind == RowKind::Toggle)
				return "editor row on a list page";
			if (row.kind == RowKind::Checkbox && !quick_page) return "CHECKBOX outside Quick settings";
		}
	}
	if (!value_page && !stock_uniform_heights(page)) return "list page not uniform";
	if (value_page && (page.rows.size() != 2 || page.rows[1].kind != RowKind::Button
		|| page.rows[1].action.rfind("reset:", 0) != 0))
		return "value page is not editor + 'Reset to default'";
	return {};
}

// Every page reachable from the root through "open:" actions, in visit order.
std::vector<std::pair<std::string, Page>> reachable_pages(const std::vector<PackageView>& views, std::string_view root)
{
	std::vector<std::pair<std::string, Page>> pages;
	std::set<std::string> queued{std::string(root)};
	std::vector<std::string> pending{std::string(root)};
	while (!pending.empty())
	{
		const auto id = pending.front();
		pending.erase(pending.begin());
		bool found = false;
		auto page = select_page(views, id, found);
		if (!found) continue;
		for (const auto& row : page.rows)
		{
			if (row.action.rfind("open:", 0) != 0) continue;
			const auto child = row.action.substr(5);
			if (queued.insert(child).second) pending.push_back(child);
		}
		pages.emplace_back(id, std::move(page));
	}
	return pages;
}

void ui_page_model()
{
	settings::Declarations missions;
	settings::Declarations frost;
	const auto missions_error = settings::parse_declarations(r7::missions_top,
		{{r7::missions_addon_file, r7::missions_addon()}, {r7::missions_literal_file, r7::missions_literal}}, missions);
	const auto frost_error = settings::parse_declarations(r7::frost_top, {{r7::frost_file, r7::frost_values}}, frost);
	check(missions_error.empty() && frost_error.empty(),
		"R7 synthetic declarations parse" + (missions_error.empty() ? std::string() : " (" + missions_error + ")")
			+ (frost_error.empty() ? std::string() : " (" + frost_error + ")"));
	if (!missions_error.empty() || !frost_error.empty()) return;
	std::vector<PackageView> views(2);
	views[0].folder = "Missions";
	views[0].display = "Missions";
	views[0].declarations = &missions;
	views[0].members.push_back(MemberView{r7::missions_addon_file, "Mission values: 21 sections", "member:missions/x", true, false});
	views[0].members.push_back(MemberView{r7::missions_literal_file, "Void Flood", "member:missions/y", true, true});
	views[0].state.package = "package:missions";
	views[0].state.values["survival.reward_interval"] = settings::UserValue{true, {}, true, true, 150, false, 0};
	views[0].state.values["void_flood.fractures"] = settings::UserValue{true, {}, true, true, 4, false, 0};
	views[1].folder = "Frost";
	views[1].display = "Frost";
	views[1].declarations = &frost;

	// Page tree and rows.
	const auto root = build_root_page(views);
	check(labels(root) == "Missions: 2 changed | Frost",
		"root: one BUTTON per script with options ('N changed' when any value differs from its default): " + labels(root));
	const auto package_page = build_package_page(views[0]);
	check(labels(package_page) == "Quick settings: 2 on | Defense | Survival: 1 changed | Void Flood: 1 changed |  | Reset all to defaults"
		&& package_page.rows.back().action == "resetall:Missions",
		"package page: Quick settings first, then the mission types in declaration order, then one Reset all: " + labels(package_page));
	bool found = false;
	const auto survival = select_page(views, "node:Missions/1", found);
	check(found && survival.title == "SURVIVAL" && labels(survival) == "Timers: 1 changed | Enemies | Advanced |  | Reset all to defaults"
		&& survival.rows.back().action == "resetall:Missions/node:1",
		"mission type page: its categories in order (Advanced last), Reset all for this page: " + labels(survival));
	const auto timers = select_page(views, "node:Missions/1.0", found);
	check(found && labels(timers) == "Time between rewards: 150 s | Alert mission length: 600 s (default) |  | Reset all to defaults",
		"category page: one row per value, 'X: 150 s' when changed, '(default)' otherwise: " + labels(timers));
	const auto set = select_page(views, "node:Missions/1.1.0", found);
	check(found && set.title == "MAX ENEMIES AT ONCE"
		&& labels(set) == "Solo: 7-10 (default) | Squad: 28 (default) | Hard nodes |  | Reset all to defaults",
		"set page: per-player rows, the range default label, the named variant after them: " + labels(set));
	const auto frost_page = build_package_page(views[1]);
	check(labels(frost_page) == "Bonus per Cold stack: 50x (default) |  | Reset all to defaults",
		"path-less package (older layout, Frost): its values directly on the package page; the author's default 50x shows: "
			+ labels(frost_page));
	const auto flat = build_flat_page(views);
	check(labels(flat).find("SURVIVAL - TIMERS | Time between rewards: 150 s") != std::string::npos
		&& labels(flat).find("FROST | Bonus per Cold stack: 50x (default)") != std::string::npos
		&& std::all_of(flat.rows.begin(), flat.rows.end(), [](const Row& row)
			{
				return row.kind == RowKind::Title || (row.kind == RowKind::Button && row.action.rfind("open:val:", 0) == 0);
			}),
		"flat layout (SettingsMenuNested=false): TITLE per script and page, one value BUTTON per value, nothing else");

	// Value pages.
	const auto reward = select_page(views, "val:Missions/survival.reward_interval", found);
	check(found && reward.title == "TIME BETWEEN REWARDS LABEL" && reward.rows.size() == 2
		&& reward.rows[0].kind == RowKind::InputBox && reward.rows[0].label == "Value (s)" && reward.rows[0].content == "150"
		&& reward.rows[0].tooltip.rfind("Default 300 s. Range 1 to 32767. Applies live, at the next read.", 0) == 0
		&& reward.rows[1].label == "Reset to default: 300 s" && reward.rows[1].action == "reset:Missions/value:survival.reward_interval",
		"value page: the editor (INPUTBOX for a float) with 'Default ...' in its tooltip, then 'Reset to default: 300 s'");
	const auto solo = select_page(views, "val:Missions/survival.max.p1", found);
	const auto mode = select_page(views, "val:Missions/defense.mode", found);
	const auto offset = select_page(views, "val:Missions/defense.offset", found);
	const auto flood = select_page(views, "val:Missions/void_flood.fractures", found);
	check(solo.rows.size() == 2 && solo.rows[0].kind == RowKind::InputCount && solo.rows[0].count == 10
		&& solo.rows[1].label == "Reset to default: 7-10"
		&& mode.rows.size() == 2 && mode.rows[0].kind == RowKind::Toggle && mode.rows[0].options.size() == 2
		&& mode.rows[0].options[0].label == "Normal (default)"
		&& offset.rows.size() == 2 && offset.rows[0].kind == RowKind::InputBox && offset.rows[0].integer
		&& flood.rows.size() == 2 && flood.rows[0].kind == RowKind::Toggle && flood.rows[0].number == 4
		&& flood.rows[0].options.size() == 2 && flood.rows[0].options[0].label == "3 (default)" && !flood.rows[0].locked,
		"value pages: INPUTCOUNT (int >= 0), TOGGLE (enum, the default marked), INPUTBOX (negative int), "
		"and a literal value's choice between the default and the built value");
	for (const auto& [id, page] : reachable_pages(views, "root"))
	{
		const auto problem = page_rule_problem(id, page);
		check(problem.empty(), "stock row rules on page " + id + (problem.empty() ? "" : ": " + problem));
	}

	// Quick settings: the one on/off, keeping the typed value.
	const auto quick = select_page(views, "quick:Missions", found);
	check(found && labels(quick) == "Survival: time between rewards | Survival: 150 s | Void Flood: fractures per round | Void Flood: 4"
		&& quick.rows[0].kind == RowKind::Checkbox && quick.rows[0].value && quick.rows[0].setting == "active:missions/survival.reward_interval"
		&& quick.rows[1].action == "open:qval:Missions/survival.reward_interval"
		&& quick.rows[3].action == "open:val:Missions/void_flood.fractures",
		"Quick settings: per headline value its on/off (CHECKBOX) and the value it keeps: " + labels(quick));

	const auto file_of = [](const Applied& applied, std::string_view folder, std::string_view id, bool& enabled, double& number)
	{
		for (const auto& package : applied.packages)
		{
			if (package.folder != folder) continue;
			const auto entry = package.state.values.find(std::string(id));
			if (entry == package.state.values.end()) return false;
			enabled = entry->second.enabled;
			number = entry->second.value;
			return true;
		}
		return false;
	};
	bool enabled = false;
	double number = 0;
	{
		Session session;
		check(stage(session, views, "value:missions/survival.reward_interval", StagedValue::of_text("60")).empty()
			&& file_of(settings_ui::apply(session, views), "Missions", "survival.reward_interval", enabled, number) && enabled && number == 60,
			"changing a value applies it: written enabled with the value (enabled = value ~= default)");
		(void)stage(session, views, "value:missions/survival.reward_interval", StagedValue::of_number(300));
		check(file_of(settings_ui::apply(session, views), "Missions", "survival.reward_interval", enabled, number) && !enabled && number == 300,
			"a value set to its default is 'leave it as intended': written disabled");
	}
	{
		Session session;
		(void)stage(session, views, "value:missions/survival.reward_interval", StagedValue::of_text("150"));
		(void)stage(session, views, "value:missions/survival.alert_interval", StagedValue::of_text("600"));
		(void)stage(session, views, "value:missions/survival.max.p1", StagedValue::of_number(10));
		check(session.operations.empty() && settings_ui::apply(session, views).packages.empty(),
			"closing value pages without a change (the completion restage) records nothing and writes nothing");
	}
	{
		Session session;
		(void)stage(session, views, "value:missions/survival.alert_interval", StagedValue::of_text("90"));
		check(reset(session, views, "Missions/value:survival.reward_interval")
			&& file_of(settings_ui::apply(session, views), "Missions", "survival.reward_interval", enabled, number) && !enabled && number == 300
			&& file_of(settings_ui::apply(session, views), "Missions", "survival.alert_interval", enabled, number) && enabled && number == 90,
			"Reset to default: only that value returns to its default (the stored number too)");
		const auto after = overlay(session, views);
		bool refreshed = false;
		const auto timers_after = select_page(after, "node:Missions/1.0", refreshed);
		check(refreshed && labels(timers_after) == "Time between rewards: 300 s (default) | Alert mission length: 90 s |  | Reset all to defaults",
			"the page the bridge re-reads after the reset shows the default: " + labels(timers_after));
	}
	{
		Session session;
		(void)stage(session, views, "value:missions/defense.offset", StagedValue::of_text("-2"));
		(void)stage(session, views, "value:missions/survival.max.p4", StagedValue::of_number(40));
		check(reset(session, views, "Missions/node:1")
			&& file_of(settings_ui::apply(session, views), "Missions", "survival.reward_interval", enabled, number) && !enabled && number == 300
			&& file_of(settings_ui::apply(session, views), "Missions", "survival.max.p4", enabled, number) && !enabled && number == 28
			&& file_of(settings_ui::apply(session, views), "Missions", "defense.offset", enabled, number) && enabled && number == -2,
			"Reset all to defaults on a mission type page resets everything below it and nothing else");
		(void)stage(session, views, "value:missions/survival.max.p4", StagedValue::of_number(33), StageSource::Click);
		check(file_of(settings_ui::apply(session, views), "Missions", "survival.max.p4", enabled, number) && enabled && number == 33,
			"an edit after a reset applies (operations replay in order)");
		Session all;
		check(reset(all, views, "Missions") && file_of(settings_ui::apply(all, views), "Missions", "void_flood.fractures", enabled, number) && !enabled,
			"Reset all on the package page also turns the built literal value off (its replacement member stays out)");
		check(!reset(all, views, "Missions/node:9") && !reset(all, views, "Missions/value:no.such") && !reset(all, views, "Nothing"),
			"a reset of an unknown scope is refused");
	}
	{
		// Quick on/off keeps the stored number; the detailed row shows what applies.
		Session session;
		check(stage(session, views, "active:missions/survival.reward_interval", StagedValue::of_bool(false), StageSource::Click).empty()
			&& file_of(settings_ui::apply(session, views), "Missions", "survival.reward_interval", enabled, number) && !enabled && number == 150,
			"Quick settings off: the mission returns to its default, the typed 150 is kept");
		(void)stage(session, views, "stored:missions/survival.reward_interval", StagedValue::of_text("45"));
		const auto off_views = overlay(session, views);
		const auto quick_off = select_page(off_views, "quick:Missions", found);
		const auto timers_off = select_page(off_views, "node:Missions/1.0", found);
		check(file_of(settings_ui::apply(session, views), "Missions", "survival.reward_interval", enabled, number) && !enabled && number == 45
			&& quick_off.rows[1].label == "Survival: 45 s" && !quick_off.rows[0].value
			&& timers_off.rows[0].label == "Time between rewards: 300 s (default)",
			"the quick value page edits the kept number while off; the detailed row shows the default that applies");
		(void)stage(session, views, "active:missions/survival.reward_interval", StagedValue::of_bool(true), StageSource::Click);
		check(file_of(settings_ui::apply(session, views), "Missions", "survival.reward_interval", enabled, number) && enabled && number == 45,
			"Quick settings on again: the kept number applies (same storage as the detailed pages)");
		Session literal;
		(void)stage(literal, views, "active:missions/void_flood.fractures", StagedValue::of_bool(false), StageSource::Click);
		check(file_of(settings_ui::apply(literal, views), "Missions", "void_flood.fractures", enabled, number) && !enabled,
			"a literal quick value off: its replacement member stays out (default behaviour)");
		(void)stage(literal, views, "value:missions/void_flood.fractures", StagedValue::of_number(4));
		const auto literal_views = overlay(literal, views);
		bool literal_found = false;
		const auto literal_quick = select_page(literal_views, "quick:Missions", literal_found);
		check(literal_found && literal_quick.rows[2].value && settings_ui::apply(literal, views).packages.empty(),
			"choosing the built value on the literal value page applies the member again (back to the file state: nothing to write)");
	}
	{
		Session session;
		check(stage(session, views, "custom:missions/survival.reward_interval", StagedValue::of_bool(true)) == "unknown-setting"
			&& stage(session, views, "package:missions", StagedValue::of_bool(false)) == "unknown-setting"
			&& stage(session, views, "member:missions/x", StagedValue::of_bool(false)) == "unknown-setting"
			&& stage(session, views, "stock:missions", StagedValue::of_bool(true)) == "unknown-setting"
			&& stage(session, views, "group:missions/survival", StagedValue::of_bool(false)) == "unknown-setting"
			&& stage(session, views, "active:missions/survival.alert_interval", StagedValue::of_bool(true)) == "unknown-setting"
			&& stage(session, views, "value:missions/survival.reward_interval", StagedValue::of_number(99999)) == "outside-min-max"
			&& stage(session, views, "value:missions/survival.reward_interval", StagedValue::of_text("abc")) == "not-a-number"
			&& stage(session, views, "value:missions/void_flood.fractures", StagedValue::of_number(5)) == "enum-value-not-an-option"
			&& session.operations.empty(),
			"no package, member, 'Use stock values', section or Custom setting is accepted any more (SCRIPTS owns enabling); "
			"the host re-validates every value");
	}
	{
		// Files written before R7: use_stock or a section switched off. Turning a
		// value on switches them back on without letting anything else start.
		auto legacy = views;
		legacy[0].state.use_stock = true;
		const auto legacy_page = select_page(legacy, "node:Missions/1.0", found);
		Session session;
		(void)stage(session, legacy, "value:missions/survival.alert_interval", StagedValue::of_text("90"));
		const auto applied = settings_ui::apply(session, legacy);
		check(legacy_page.rows[0].label == "Time between rewards: 300 s (default)"
			&& file_of(applied, "Missions", "survival.alert_interval", enabled, number) && enabled && number == 90
			&& file_of(applied, "Missions", "survival.reward_interval", enabled, number) && !enabled && number == 150
			&& !applied.packages[0].state.use_stock && applied.packages[0].state.groups.size() == missions.groups.size(),
			"a use_stock file shows defaults; an edit writes use_stock false, every section on and keeps other values off");
	}
	{
		// The author's default (Frost-like, stock 0, default 50).
		Session session;
		(void)stage(session, views, "value:frost/ice_wave.bonus_per_cold_stack", StagedValue::of_text("50"));
		check(session.operations.empty(), "Frost: confirming 50 (the default) is no change");
		(void)stage(session, views, "value:frost/ice_wave.bonus_per_cold_stack", StagedValue::of_text("0"));
		check(file_of(settings_ui::apply(session, views), "Frost", "ice_wave.bonus_per_cold_stack", enabled, number) && enabled && number == 0,
			"Frost: 0 differs from the author's default: written enabled (0 turns the bonus off)");
		settings::UserState state;
		state.package = "package:frost";
		const auto absent = settings::evaluate(frost, nullptr, {});
		const auto delivered = settings::member_delivery(frost, nullptr, absent, r7::frost_file);
		state.values["ice_wave.bonus_per_cold_stack"] = settings::UserValue{true, {}, false, true, 70, false, 0};
		const auto off = settings::evaluate(frost, &state, {});
		const auto off_delivery = settings::member_delivery(frost, &state, off, r7::frost_file);
		state.values["ice_wave.bonus_per_cold_stack"].enabled = true;
		const auto on = settings::evaluate(frost, &state, {});
		const auto on_delivery = settings::member_delivery(frost, &state, on, r7::frost_file);
		state.use_stock = true;
		const auto stock = settings::evaluate(frost, &state, {});
		const auto stock_delivery = settings::member_delivery(frost, &state, stock, r7::frost_file);
		const auto malformed = settings::evaluate(frost, nullptr, "values-file-invalid-json");
		const auto malformed_delivery = settings::member_delivery(frost, nullptr, malformed, r7::frost_file);
		check(delivered->values.size() == 1 && delivered->values[0].value == 50.0f && delivered->values[0].stock == 0.0f
			&& off_delivery->values.size() == 1 && off_delivery->values[0].value == 50.0f
			&& on_delivery->values.size() == 1 && on_delivery->values[0].value == 70.0f
			&& stock_delivery->values.empty() && malformed_delivery->values.empty(),
			"declared default: delivered at 50 with no file or a disabled entry, the file value when enabled; "
			"nothing on use_stock or a malformed file (fail closed = game stock)");
		const auto missions_absent = settings::evaluate(missions, nullptr, {});
		check(settings::member_delivery(missions, nullptr, missions_absent, r7::missions_addon_file)->values.empty(),
			"no declared default (Missions): nothing is delivered without an enabled entry (V1 unchanged)");
	}
}

// -----------------------------------------------------------------------------
// Part 7 (optional, --package <folder> [--settings <file>], repeatable): REAL
// package folders and values files through the exact scanner, the settings
// evaluation, the member deliveries and the SCRIPT SETTINGS page model (built
// the way the host's build_script_settings_views builds it). Every
// declaration, delivery, reachable page and row is printed.
struct ExternalPackage
{
	std::filesystem::path folder;
	std::filesystem::path values;
};

void print_row(const std::string& prefix, const Row& row)
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
}

// Scans the packages into one CustomScripts tree and builds the host views.
std::vector<PackageView> scan_external(const std::vector<ExternalPackage>& inputs, const std::filesystem::path& work,
	std::shared_ptr<const packages::Snapshot>& snapshot)
{
	std::vector<PackageView> views;
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);
	gate::policy = gate::external_policy;
	if (gate::external_policy_loaded)
		std::cout << "INFO\treplaying ScriptStates.json policy entries=" << gate::policy.size() << '\n';
	for (const auto& input : inputs)
	{
		const auto source = input.folder.filename().empty() ? input.folder.parent_path() : input.folder;
		const std::string folder = source.filename().string();
		std::filesystem::create_directories(gate::root / "Packages" / folder, ec);
		std::filesystem::copy(source, gate::root / "Packages" / folder, std::filesystem::copy_options::recursive, ec);
		check(!ec && std::filesystem::is_regular_file(gate::root / "Packages" / folder / "package.json"),
			"external " + folder + ": package folder copied into an empty CustomScripts tree");
		if (!input.values.empty())
			write_text(gate::root / "Settings" / settings::values_file_name(folder), read_text(input.values));
	}
	gate::log_lines.clear();
	check(packages::initialise(), "external: startup scan PASS");
	snapshot = packages::candidate();
	for (const auto& line : gate::log_lines) std::cout << "LOG\t" << line << '\n';
	if (!snapshot) return views;
	for (const auto& input : inputs)
	{
		const auto source = input.folder.filename().empty() ? input.folder.parent_path() : input.folder;
		const std::string folder = source.filename().string();
		const std::string label = "external " + folder + ": ";
		const auto* package = find_package(*snapshot, folder);
		check(package != nullptr && package->accepted,
			label + "package accepted" + (package != nullptr && !package->reason.empty() ? " (reason " + package->reason + ")" : ""));
		check(package != nullptr && package->declarations != nullptr && package->settings_reason.empty(),
			label + "settings declarations accepted by the runtime parser"
				+ (package != nullptr && !package->settings_reason.empty() ? " (reason " + package->settings_reason + ")" : ""));
		if (package == nullptr || package->declarations == nullptr) continue;
		const auto& declarations = *package->declarations;
		for (const auto& value : declarations.values)
		{
			std::cout << "DECL\tid=" << value.id << " member=" << value.member << " group=" << value.group
				<< " lane=" << settings::lane_label(value.lane) << " type=" << settings::value_type_label(value.type)
				<< " stock=" << settings::json::number_text(value.stock)
				<< " default=" << (value.default_declared ? settings::json::number_text(value.default_value) : std::string("stock"))
				<< " min=" << settings::json::number_text(value.minimum) << " max=" << settings::json::number_text(value.maximum)
				<< " applies=" << settings::applies_label(value.applies)
				<< " path=";
			for (std::size_t index = 0; index != value.path.size(); ++index) std::cout << (index ? " > " : "") << value.path[index];
			std::cout << " row=" << value.row << (value.quick.empty() ? "" : " quick=" + value.quick) << '\n';
		}
		settings::UserState state;
		std::string file_error;
		const bool present = packages::read_settings_values(*package, state, file_error);
		check(present == !input.values.empty(), label + (!input.values.empty()
			? "the runtime finds Settings/" + settings::values_file_name(folder)
			: std::string("no values file (every value at its default)")));
		check(file_error.empty(), label + "values file valid" + (file_error.empty() ? "" : " (reason " + file_error + ")"));
		const auto evaluation = settings::evaluate(declarations, present && file_error.empty() ? &state : nullptr, file_error);
		for (const auto& rejection : evaluation.rejections)
			std::cout << "REJECT\tid=" << rejection.id << " reason=" << rejection.reason << '\n';
		std::cout << "INFO\t" << folder << " file=" << settings::file_status_label(evaluation.file) << " use_stock=" << (evaluation.use_stock ? 1 : 0)
			<< " effective=" << evaluation.effective.size() << " defaults=" << evaluation.defaulted.size()
			<< " rejected=" << evaluation.rejections.size() << " unknown_entries=" << evaluation.unknown_entries << '\n';
		check(evaluation.rejections.empty(), label + "no value in the values file is rejected");
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
		// R13 (2026-10-01): the gate that would have caught the live Defense
		// defect. With the installed ScriptStates.json replayed, an enabled
		// package must stage every member that receives at least one value;
		// R11 staged 0/1 (`member:missions/missions.targets.addon.lua_b`).
		bool reachable = true;
		for (const auto& member : package->members)
		{
			if (package->enabled && member.delivery && !member.delivery->values.empty() && !member.staged)
			{
				reachable = false;
				std::cout << "UNREACHABLE\t" << member.filename << " values=" << member.delivery->values.size()
					<< " enabled=" << (member.enabled ? 1 : 0) << " policy_off_ignored=" << (member.policy_off_ignored ? 1 : 0) << '\n';
			}
		}
		check(reachable, label + "every delivered value reaches a staged member (installed policy "
			+ (gate::external_policy_loaded ? std::string("replayed") : std::string("absent")) + ")");
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
		else if (present) { view.file_malformed = true; view.file_reason = file_error; }
		views.push_back(std::move(view));
	}
	return views;
}

// The navigation as the player walks it: every page right under the row that opens it.
void print_tree_page(const std::vector<PackageView>& views, const std::string& id, std::size_t depth, std::set<std::string>& seen)
{
	if (!seen.insert(id).second || depth > 8) return;
	bool found = false;
	const auto page = select_page(views, id, found);
	if (!found) return;
	for (const auto& row : page.rows)
	{
		if (row.kind == RowKind::Spacer) continue;
		std::cout << "TREE\t" << std::string(depth * 2, ' ') << row.label << '\n';
		if (row.action.rfind("open:node:", 0) == 0 || row.action.rfind("open:quick:", 0) == 0)
			print_tree_page(views, row.action.substr(5), depth + 1, seen);
	}
}

void print_tree(const PackageView& view)
{
	std::set<std::string> seen;
	std::cout << "TREE\t" << view.display << '\n';
	print_tree_page({view}, "pkg:" + view.folder, 1, seen);
}

void external_packages(const std::vector<ExternalPackage>& inputs, const std::filesystem::path& work)
{
	std::shared_ptr<const packages::Snapshot> snapshot;
	const auto views = scan_external(inputs, work, snapshot);
	check(views.size() == inputs.size(), "external: every package has a settings view");
	if (views.empty()) return;
	// The flat page (PAGE/ROW/VALROW lines, for verify_script_settings_render.ps1 -PageRows).
	const auto flat = build_flat_page(views);
	std::cout << "PAGE\ttitle=" << flat.title << "\tsearch=" << (flat.search ? 1 : 0) << '\n';
	for (const auto& row : flat.rows) print_row("ROW", row);
	for (const auto& row : flat.rows)
	{
		if (row.action.rfind("open:", 0) != 0) continue;
		bool found = false;
		const auto value_page = select_page(views, row.action.substr(5), found);
		std::cout << "VALPAGE\t" << row.action << "\ttitle=" << value_page.title << "\trows=" << value_page.rows.size() << '\n';
		for (const auto& value_row : value_page.rows) print_row("VALROW\t" + row.action, value_row);
	}
	std::cout << "SCROLL\trows=" << flat.rows.size() << " uniform=" << (stock_uniform_heights(flat) ? 1 : 0)
		<< " scroll=" << (stock_scroll_attached(flat) ? 1 : 0) << '\n';
	check(stock_uniform_heights(flat) && std::all_of(flat.rows.begin(), flat.rows.end(), [](const Row& row)
		{
			return row.kind == RowKind::Title || (row.kind == RowKind::Button && row.action.rfind("open:val:", 0) == 0);
		}), "external: the flat layout is TITLE and value BUTTON rows only (uniform, scrolls past 14 rows)");

	// Every reachable nested page.
	const auto pages = reachable_pages(views, "root");
	std::size_t value_pages = 0, list_pages = 0, rows = 0;
	bool rules = true;
	std::map<std::string, std::size_t> opened; // value id -> times a detailed page opens it
	for (const auto& [id, page] : pages)
	{
		std::cout << "PAGEDUMP\t" << id << "\ttitle=" << page.title << "\trows=" << page.rows.size() << '\n';
		for (const auto& row : page.rows) print_row("PAGEROW\t" + id, row);
		const auto problem = page_rule_problem(id, page);
		if (!problem.empty()) std::cout << "FAIL-DETAIL\tpage " << id << ": " << problem << '\n';
		rules &= problem.empty();
		rows += page.rows.size();
		(id.rfind("val:", 0) == 0 || id.rfind("qval:", 0) == 0 ? value_pages : list_pages) += 1;
		if (id.rfind("quick:", 0) == 0) continue;
		for (const auto& row : page.rows)
			if (row.action.rfind("open:val:", 0) == 0) ++opened[row.action.substr(row.action.find('/') + 1)];
	}
	std::cout << "NESTED\tpages=" << pages.size() << " list_pages=" << list_pages << " value_pages=" << value_pages
		<< " rows=" << rows << '\n';
	check(rules, "external: every reachable page keeps the stock row rules and holds no package, member, 'Use stock values', "
		"section or 'Custom' switch (" + std::to_string(pages.size()) + " pages)");
	bool reachable = true;
	std::size_t declared = 0;
	for (const auto& view : views)
	{
		for (const auto& value : view.declarations->values)
		{
			++declared;
			const auto count = opened.find(value.id);
			reachable &= count != opened.end() && count->second == 1;
			if (count == opened.end() || count->second != 1)
				std::cout << "FAIL-DETAIL\tvalue " << value.id << " is opened by " << (count == opened.end() ? 0 : count->second) << " rows\n";
		}
	}
	check(reachable, "external: every declared value has exactly one row in the page tree (" + std::to_string(declared) + " values)");
	for (const auto& view : views) print_tree(view);
}

// -----------------------------------------------------------------------------
// Part 8 (optional, --tape <plan>): the host side of the stock render harness.
// verify_script_settings_render.ps1 drives the bridge under test through the
// stock screen with these host pages: for every prefix of the planned host
// calls (stage and act, in order) this prints the pages that changed
// (TAPEPAGE/TAPEROW, step = calls applied), then applies the whole session
// through the values file writer and checks the EXPECT lines. The harness
// checks that the bridge made exactly the planned calls.
// Plan lines (tab-separated):
//   STAGE <setting> <bool|number|text> <value> <click|restage>
//   ACT <action>
//   EXPECTFILE <folder> <value id> enabled=<0|1> value=<number>
//   EXPECTFILE <folder> file=unchanged
//   EXPECTROW <step> <page id> <row key (action or setting)> <label>
//   EXPECTPLAN <folder> <16-hex module key> values=<id[,id]> rows=<row=value[,row=value]> patches=<n>
//     (merged R7 + R8, contract R9: the LIVE_LITERALS_V1 synthesis plan the
//     written values file resolves to, through the exact live_literals_core
//     resolution; with --corpus <dir> the module is also synthesized from its
//     real stock bytes, which must pass size, SHA-256, preimage and diff checks)
namespace tape
{
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

std::string page_text(const Page& page)
{
	std::ostringstream out;
	out << page.title << '\x1f' << page.empty_message << '\x1f';
	for (const auto& row : page.rows)
	{
		out << row_kind_name(row.kind) << '\x1e' << row.setting << '\x1e' << row.label << '\x1e' << row.action << '\x1e'
			<< row.content << '\x1e' << row.value << '\x1e' << row.count << '\x1e' << row.number << '\x1e' << row.tooltip << '\x1d';
	}
	return out.str();
}
}

// R9: the synthesis plans of one written values file (the runtime's resolution).
struct TapePlan
{
	std::string folder;
	std::string key;
	std::string values;
	std::string rows;
	std::size_t patches = 0;
	std::string synthesis; // "pass sha256=<16 hex>", "fail <reason>" or "" (no corpus)
};

std::vector<TapePlan> tape_plans(const packages::Package& package, const std::string& text, const std::filesystem::path& corpus)
{
	std::vector<TapePlan> out;
	if (!package.literal_recipes || !package.declarations) return out;
	const auto& recipes = *package.literal_recipes;
	const auto& declarations = *package.declarations;
	settings::UserState state;
	if (!settings::parse_values_file(text, "package:" + settings_ui::folder_key(package.folder), state).empty()) return out;
	const auto evaluation = settings::evaluate(declarations, &state, {});
	const auto resolution = live_literals::resolve_plans(recipes, declarations, &state, evaluation);
	for (const auto& rejection : resolution.rejections)
		std::cout << "TAPEPLANREJECT\t" << package.folder << '\t' << live_literals::hex64(rejection.key) << '\t' << rejection.value
			<< '\t' << rejection.reason << '\n';
	for (const auto& plan : resolution.plans)
	{
		TapePlan item;
		item.folder = package.folder;
		item.key = live_literals::hex64(plan.key);
		for (const auto& id : plan.values) item.values += (item.values.empty() ? "" : ",") + id;
		item.patches = plan.patches.size();
		// Row values as the resolution chose them: a row's own applied value wins, else its applied master.
		std::map<std::string, std::string> rows;
		for (const auto& recipe : recipes.values)
		{
			if (recipe.module != plan.key || std::find(plan.values.begin(), plan.values.end(), recipe.id) == plan.values.end()) continue;
			const auto entry = state.values.find(recipe.id);
			if (entry == state.values.end()) continue;
			for (const auto& drive : recipe.drives)
			{
				const double row = recipe.direct() ? entry->second.value
					: live_literals::patch::row_value(entry->second.value, drive.scale, drive.integer_row);
				if (recipe.direct() || rows.count(drive.row) == 0) rows[drive.row] = settings::json::number_text(row);
			}
		}
		for (const auto& [row, value] : rows) item.rows += (item.rows.empty() ? "" : ",") + row + "=" + value;
		if (!corpus.empty())
		{
			const auto bytes = read_text(corpus / plan.file);
			const auto synthesis = live_literals::synthesize(plan, reinterpret_cast<const unsigned char*>(bytes.data()), bytes.size());
			item.synthesis = synthesis.error.empty()
				? "pass sha256=" + settings::sha256_hex(std::string_view(reinterpret_cast<const char*>(synthesis.bytes.data()),
					synthesis.bytes.size())).substr(0, 16)
				: "fail " + synthesis.error;
		}
		std::cout << "TAPEPLAN\t" << item.folder << '\t' << item.key << "\tfile=" << plan.file << "\tvalues=" << item.values
			<< "\trows=" << item.rows << "\tpatches=" << item.patches
			<< (item.synthesis.empty() ? std::string() : "\tsynthesis=" + item.synthesis) << '\n';
		out.push_back(std::move(item));
	}
	return out;
}

void run_tape(const std::vector<ExternalPackage>& inputs, const std::filesystem::path& plan_path, const std::filesystem::path& work,
	const std::filesystem::path& corpus)
{
	std::shared_ptr<const packages::Snapshot> snapshot;
	const auto views = scan_external(inputs, work, snapshot);
	check(views.size() == inputs.size(), "tape: every package has a settings view");
	std::ifstream input(plan_path, std::ios::binary);
	check(static_cast<bool>(input), "tape: the plan is readable");
	std::vector<std::vector<std::string>> operations, expectations;
	std::string line;
	while (std::getline(input, line))
	{
		if (!line.empty() && line.back() == '\r') line.pop_back();
		const auto fields = tape::split_tabs(line);
		if (fields.empty() || fields[0].empty()) continue;
		if (fields[0] == "STAGE" || fields[0] == "ACT") operations.push_back(fields);
		else if (fields[0] == "EXPECTFILE" || fields[0] == "EXPECTROW" || fields[0] == "EXPECTPLAN") expectations.push_back(fields);
	}
	Session session;
	std::map<std::string, std::string> last; // page id -> page text at the previous step
	std::map<std::pair<std::size_t, std::string>, Page> at_step;
	const auto dump = [&](std::size_t step)
	{
		const auto current = overlay(session, views);
		for (const auto& [id, page] : reachable_pages(current, "root"))
		{
			const auto text = tape::page_text(page);
			at_step[{step, id}] = page;
			if (last[id] == text) continue;
			last[id] = text;
			std::cout << "TAPEPAGE\t" << step << '\t' << id << "\ttitle=" << page.title << "\tempty=" << page.empty_message << '\n';
			for (const auto& row : page.rows) print_row("TAPEROW\t" + std::to_string(step) + '\t' + id, row);
		}
	};
	dump(0);
	std::size_t step = 0;
	for (const auto& operation : operations)
	{
		++step;
		if (operation[0] == "STAGE" && operation.size() == 5)
		{
			StagedValue value;
			if (operation[2] == "bool") value = StagedValue::of_bool(operation[3] == "true");
			else if (operation[2] == "number") value = StagedValue::of_number(std::stod(operation[3]));
			else value = StagedValue::of_text(operation[3]);
			const auto reason = stage(session, views, operation[1], value,
				operation[4] == "click" ? StageSource::Click : StageSource::Restage);
			std::cout << "TAPEOP\t" << step << "\tstage " << operation[1] << " = " << operation[3] << " (" << operation[4] << ") -> "
				<< (reason.empty() ? std::string("accepted") : "REJECT " + reason) << '\n';
		}
		else if (operation[0] == "ACT" && operation.size() == 2)
		{
			const auto& action = operation[1];
			const auto colon = action.find(':');
			const bool staged = colon != std::string::npos && reset(session, views, std::string_view(action).substr(colon + 1));
			std::cout << "TAPEOP\t" << step << "\tact " << action << " -> " << (staged ? "reset" : "REJECT") << '\n';
		}
		dump(step);
	}
	std::cout << "TAPESTEPS\t" << step << '\n';
	const auto applied = settings_ui::apply(session, views);
	std::vector<TapePlan> plans;
	for (const auto& package : applied.packages)
	{
		const auto* scanned = snapshot ? find_package(*snapshot, package.folder) : nullptr;
		if (scanned == nullptr) continue;
		const auto found = tape_plans(*scanned, settings::write_values_file(package.state, package.declarations), corpus);
		plans.insert(plans.end(), found.begin(), found.end());
	}
	for (const auto& expectation : expectations)
	{
		if (expectation[0] == "EXPECTPLAN")
		{
			const auto plan = std::find_if(plans.begin(), plans.end(), [&](const TapePlan& item)
				{
					return expectation.size() == 6 && item.folder == expectation[1] && item.key == expectation[2];
				});
			const bool ok = plan != plans.end() && "values=" + plan->values == expectation[3] && "rows=" + plan->rows == expectation[4]
				&& "patches=" + std::to_string(plan->patches) == expectation[5]
				&& (plan->synthesis.empty() || plan->synthesis.rfind("pass", 0) == 0);
			check(ok, "tape: the written values file resolves to the synthesis plan " + (expectation.size() > 2 ? expectation[2] : std::string())
				+ " " + (expectation.size() > 5 ? expectation[3] + " " + expectation[4] + " " + expectation[5] : std::string())
				+ (plan == plans.end() ? " (no plan)" : " (plan values=" + plan->values + " rows=" + plan->rows + " patches="
					+ std::to_string(plan->patches) + (plan->synthesis.empty() ? std::string(", no corpus") : ", synthesis " + plan->synthesis) + ")"));
			continue;
		}
		if (expectation[0] == "EXPECTROW" && expectation.size() == 5)
		{
			const auto key = std::make_pair(static_cast<std::size_t>(std::stoul(expectation[1])), expectation[2]);
			const auto page = at_step.find(key);
			const Row* row = page == at_step.end() ? nullptr : row_by(page->second, expectation[3]);
			check(row != nullptr && row->label == expectation[4], "tape step " + expectation[1] + ": page " + expectation[2] + " row "
				+ expectation[3] + " reads '" + expectation[4] + "'" + (row != nullptr ? " (reads '" + row->label + "')" : " (missing)"));
			continue;
		}
		if (expectation.size() == 3 && expectation[2] == "file=unchanged")
		{
			check(std::none_of(applied.packages.begin(), applied.packages.end(),
					[&](const AppliedPackage& package) { return package.folder == expectation[1]; }),
				"tape: Settings/" + expectation[1] + ".json is not written");
			continue;
		}
		bool found = false, enabled = false;
		double value = 0;
		for (const auto& package : applied.packages)
		{
			if (expectation.size() != 5 || package.folder != expectation[1]) continue;
			const auto text = settings::write_values_file(package.state, package.declarations);
			settings::UserState reread;
			if (!settings::parse_values_file(text, package.state.package, reread).empty()) continue;
			const auto entry = reread.values.find(expectation[2]);
			if (entry == reread.values.end()) continue;
			found = true;
			enabled = entry->second.enabled;
			value = entry->second.value;
		}
		const bool want_enabled = expectation.size() == 5 && expectation[3] == "enabled=1";
		const double want_value = expectation.size() == 5 && expectation[4].rfind("value=", 0) == 0 ? std::stod(expectation[4].substr(6)) : -1;
		check(found && enabled == want_enabled && value == want_value, "tape: Settings/" + (expectation.size() > 1 ? expectation[1] : std::string())
			+ ".json holds " + (expectation.size() > 2 ? expectation[2] : std::string()) + " " + (expectation.size() > 3 ? expectation[3] : std::string())
			+ " " + (expectation.size() > 4 ? expectation[4] : std::string()));
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
	if (argc < 3)
	{
		std::cerr << "usage: verify_addon_settings <work dir> <phase2i fixture dir>"
			" [--package <folder> [--settings <file>]]... [--tape <plan>] [--corpus <stock dir>]\n";
		return 2;
	}
	std::vector<ExternalPackage> packages_in;
	std::filesystem::path plan, corpus;
	for (int index = 3; index < argc; ++index)
	{
		const std::string_view flag = argv[index];
		if (flag == "--package" && index + 1 < argc) packages_in.push_back(ExternalPackage{long_path(argv[++index]), {}});
		else if (flag == "--settings" && index + 1 < argc && !packages_in.empty() && packages_in.back().values.empty())
			packages_in.back().values = long_path(argv[++index]);
		else if (flag == "--tape" && index + 1 < argc) plan = long_path(argv[++index]);
		else if (flag == "--corpus" && index + 1 < argc) corpus = long_path(argv[++index]);
		else if (flag == "--script-states" && index + 1 < argc)
		{
			settings::json::Value root;
			const auto error = settings::json::parse(read_text(long_path(argv[++index])), root);
			const auto* scripts = error.empty() && root.is_object() ? root.find("scripts") : nullptr;
			if (scripts == nullptr || !scripts->is_object())
			{
				std::cerr << "--script-states: not a ScriptStates.json (" << error << ")\n";
				return 2;
			}
			for (const auto& [id, value] : scripts->members)
				if (value.is_bool()) gate::external_policy[id] = value.boolean;
			gate::external_policy_loaded = true;
		}
		else
		{
			std::cerr << "unknown or misplaced argument: " << flag << '\n';
			return 2;
		}
	}
	if (!plan.empty() && packages_in.empty())
	{
		std::cerr << "--tape needs --package\n";
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
	if (!packages_in.empty() && plan.empty()) external_packages(packages_in, work / "external");
	if (!plan.empty()) run_tape(packages_in, plan, work / "tape", corpus);
	std::cout << (pass ? "ADDON SETTINGS PASS" : "ADDON SETTINGS FAIL") << '\n';
	return pass ? 0 : 1;
}
