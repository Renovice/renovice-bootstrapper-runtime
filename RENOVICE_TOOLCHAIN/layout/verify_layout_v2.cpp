// Offline gate for the script folder layout V2 (2026-10-10): Config/ScriptStates.json schema 2 helpers
// (raw value spans, composition, escaping, exact number text, idempotence) and package auto-join.
#include "../../renovice/packages_core.hpp"
#include "../../renovice/script_control_core.hpp"

#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

namespace
{
int failures = 0;
int checks = 0;

void check(bool condition, const std::string& label)
{
	++checks;
	if (condition) std::cout << "PASS " << label << '\n';
	else
	{
		std::cerr << "FAIL " << label << '\n';
		++failures;
	}
}

// JSON text with every whitespace character outside strings removed (structure + exact token text).
std::string tokens(std::string_view text)
{
	std::string out;
	bool in_string = false;
	for (std::size_t i = 0; i < text.size(); ++i)
	{
		const char c = text[i];
		if (in_string)
		{
			out += c;
			if (c == '\\' && i + 1 < text.size()) out += text[++i];
			else if (c == '"') in_string = false;
			continue;
		}
		if (c == '"') { in_string = true; out += c; continue; }
		if (c == ' ' || c == '\t' || c == '\r' || c == '\n') continue;
		out += c;
	}
	return out;
}
}

int main(int argc, char** argv)
{
	using namespace renovice;
	using namespace renovice::script_control;

	const std::string missions =
		"{\n  \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\",\n  \"package\": \"package:missions\",\n"
		"  \"build\": \"2026.10.08.13.05\",\n  \"use_stock\": false,\n  \"groups\": {\n    \"survival\": true\n  },\n"
		"  \"values\": {\n    \"disruption.icebind_goal\": { \"enabled\": true, \"value\": 4 },\n"
		"    \"capture.target_health_player_mult.p1\": { \"enabled\": true, \"value\": 0.001 },\n"
		"    \"x.sci\": { \"enabled\": false, \"value\": 1e-3, \"note\": \"a \\\"quoted\\\" , } { text\" }\n  }\n}\n";
	const std::string octavia =
		"{\n  \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\",\n  \"package\": \"package:octavia\",\n  \"values\": {}\n}";
	const std::vector<std::pair<std::string, bool>> switches = {
		{"package:missions", true},
		{"member:icebindsolo/59bb8fd0ab33eadc (icebind solo cryobell refresh).lua_b", false},
		{"replacement:odd \"quote\" \\ name.lua_b", true},
	};
	const std::string file = compose_state_file_v2(switches, {{"package:octavia", octavia}, {"package:missions", missions}});

	std::vector<std::pair<std::string, std::string_view>> spans;
	check(state_values_spans(file, spans) && spans.size() == 2, "composed file: two values entries found");
	check(spans.size() == 2 && spans[0].first == "package:missions" && spans[1].first == "package:octavia",
		"values entries sorted by package id");
	check(spans.size() == 2 && tokens(spans[0].second) == tokens(missions) && tokens(spans[1].second) == tokens(octavia),
		"each values entry keeps its exact tokens (structure, strings, numbers)");
	check(spans.size() == 2 && std::string(spans[0].second).find("\"value\": 0.001") != std::string::npos
			&& std::string(spans[0].second).find("1e-3") != std::string::npos,
		"number text is never re-formatted (0.001, 1e-3 verbatim)");
	check(spans.size() == 2 && std::string(spans[0].second).find("a \\\"quoted\\\" , } { text") != std::string::npos,
		"string escapes and braces inside strings survive");

	std::vector<std::pair<std::string, std::string_view>> top;
	check(json_object_members(file, 0, top) && top.size() == 3 && top[0].first == "schema" && top[0].second == "2"
			&& top[1].first == "scripts" && top[2].first == "values",
		"top level: schema 2, scripts, values");
	std::vector<std::pair<std::string, std::string_view>> scripts;
	check(top.size() == 3 && json_object_members(top[1].second, 0, scripts) && scripts.size() == 3,
		"scripts section: three switches");
	bool ids_round_trip = scripts.size() == 3;
	for (const auto& [id, enabled] : switches)
	{
		bool found = false;
		for (const auto& [key, raw] : scripts) found |= key == id && raw == (enabled ? "true" : "false");
		ids_round_trip &= found;
	}
	check(ids_round_trip, "switch ids with quotes, backslashes, spaces and brackets round-trip");

	std::vector<std::pair<std::string, std::string>> carried;
	for (const auto& [key, raw] : spans) carried.emplace_back(key, std::string(raw));
	check(compose_state_file_v2(switches, carried) == file, "re-composing a composed file is byte-identical (idempotent)");

	std::vector<std::pair<std::string, std::string>> replaced = carried;
	replaced[1].second = "{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:octavia\", \"values\": { \"mallet.threat_level\": { \"enabled\": true, \"value\": 3 } } }";
	const std::string updated = compose_state_file_v2(switches, replaced);
	std::vector<std::pair<std::string, std::string_view>> after;
	check(state_values_spans(updated, after) && after.size() == 2 && tokens(after[0].second) == tokens(missions)
			&& std::string(after[1].second).find("\"value\": 3") != std::string::npos,
		"replacing one package's values keeps the other package's values exactly");

	const std::string empty = compose_state_file_v2({}, {});
	std::vector<std::pair<std::string, std::string_view>> none;
	check(state_values_spans(empty, none) && none.empty() && json_object_members(empty, 0, top) && top.size() == 3,
		"empty switches and values compose valid JSON");
	const std::string v1 = "{\r\n  \"schema\": 1,\r\n  \"scripts\": {\r\n    \"package:missions\": true\r\n  }\r\n}\r\n";
	check(state_values_spans(v1, none) && none.empty(), "a schema-1 file has no values entries");
	check(!state_values_spans("{\"values\": {\"a\": {\"b\": 1}", none), "truncated JSON is rejected");

	// Package auto-join.
	packages::Manifest declared;
	(void)packages::parse_manifest("{\"members\": {\"A.lua_B\": {}}}", declared);
	check(packages::reconcile_manifest_members(declared, {"a.lua_B", "new.targets.addon.lua_B"}).empty(),
		"auto-join: an unlisted member does not fail the package");
	check(packages::auto_joined_members(declared, {"a.lua_B", "new.targets.addon.lua_B"})
			== std::vector<std::string>{"new.targets.addon.lua_B"},
		"auto-join: the unlisted member is reported");
	check(packages::reconcile_manifest_members(declared, {"other.lua_B"}) == "manifest-member-missing-on-disk=A.lua_B",
		"auto-join: a listed member missing on disk still fails the package");
	packages::Manifest no_list;
	check(packages::auto_joined_members(no_list, {"x.lua_B"}).empty(),
		"auto-join: without a members list nothing is reported (every file is a member)");

	// Optional: a ScriptStates.json written by migrate_layout_v2.py must be exactly what the loader writes
	// for the same switches and values (Python and C++ composition agree byte for byte).
	if (argc > 1)
	{
		std::ifstream input(argv[1], std::ios::binary);
		const std::string external((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
		std::vector<std::pair<std::string, std::string_view>> parts, scripts_part, value_parts;
		std::vector<std::pair<std::string, bool>> read_switches;
		std::vector<std::pair<std::string, std::string>> read_values;
		bool parsed = !external.empty() && json_object_members(external, 0, parts) && parts.size() == 3
			&& json_object_members(parts[1].second, 0, scripts_part) && state_values_spans(external, value_parts);
		for (const auto& [key, raw] : scripts_part)
		{
			parsed &= raw == "true" || raw == "false";
			read_switches.emplace_back(key, raw == "true");
		}
		for (const auto& [key, raw] : value_parts) read_values.emplace_back(key, std::string(raw));
		check(parsed, "external state file parses (schema 2: scripts + values)");
		check(parsed && compose_state_file_v2(read_switches, read_values) == external,
			"external state file is byte-identical to the loader's own composition");
	}

	std::cout << "LAYOUT V2 GATE " << (failures == 0 ? "PASS" : "FAIL") << " checks=" << checks
		<< " failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
