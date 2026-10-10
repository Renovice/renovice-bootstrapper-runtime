// Deterministic gate for optional folder script packages (2026-09-29).
//
// Part 1 exercises the pure rules in renovice/packages_core.hpp.
// Part 2 compiles the exact renovice/packages.cpp scanner (with stub config and
// policy providers, see RENOVICE_PACKAGES_OFFLINE_GATE) and runs it end to end
// on a temporary CustomScripts tree that contains loose files and packages.
// Part 3 pins the loose-file identities (kinds, stable IDs, menu labels) so a
// package change can never silently alter how loose files are keyed.
//
// Usage: verify_script_packages <compiled multi-target fixture.lua_B> <work dir>
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

// ---- stub providers for the offline build of renovice/packages.cpp ----------
namespace gate
{
std::filesystem::path root;
std::filesystem::path inject;
std::vector<std::string> log_lines;
std::map<std::string, bool> policy;
}

#include "../common/layout_v1_gate_stubs.hpp"

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

std::vector<unsigned char> read_all(const std::filesystem::path& path)
{
	std::ifstream input(path, std::ios::binary);
	return std::vector<unsigned char>(
		(std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
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

// Minimal DE container whose string pool declares the given keys. The loader's
// inventory reads only the `09 03 | count | {len, bytes}` pool.
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

const packages::Package* find_package(const packages::Snapshot& snapshot, std::string_view folder)
{
	for (const auto& package : snapshot.packages)
		if (package.folder == folder) return &package;
	return nullptr;
}

bool logged(std::string_view needle)
{
	return std::any_of(gate::log_lines.begin(), gate::log_lines.end(),
		[&](const std::string& line) { return line.find(needle) != std::string::npos; });
}

bool reason_contains(const packages::Package* package, std::string_view needle)
{
	return package != nullptr && package->reason.find(needle) != std::string::npos;
}

// -----------------------------------------------------------------------------
void pure_rules()
{
	using packages::MemberKind;
	MemberKind kind{};
	std::uint64_t key = 0;
	check(packages::classify_member("fc711ff621a75552 (missions_exact-replacement).lua_B", kind, key) == nullptr
		&& kind == MemberKind::Replacement && key == 0xfc711ff621a75552ull,
		"annotated 16-hex file is a replacement member keyed by its prefix");
	check(packages::classify_member("Missions.targets.addon.lua_B", kind, key) == nullptr
		&& kind == MemberKind::MultiTargetAddon && key == 0,
		"<Name>.targets.addon.lua_B is a multi-target member");
	check(packages::classify_member("ec368d4901690a15.Mallet.target.addon.lua_B", kind, key) == nullptr
		&& kind == MemberKind::TargetAddon && key == 0xec368d4901690a15ull,
		"<key>.<Name>.target.addon.lua_B is a single-key target member");
	check(std::string_view(packages::classify_member("Thing.addon.lua_B", kind, key))
			== "managed-addon-member-unsupported-generation-wide-transaction",
		"untargeted managed addon member is rejected with an exact reason");
	check(std::string_view(packages::classify_member("Thing.lua_B", kind, key))
			== "one-shot-inject-not-allowed-in-package",
		"one-shot Inject chunk is not admissible in an all-or-nothing package");
	check(std::string_view(packages::classify_member("Foo.target.addon.lua_B", kind, key))
			== "target-addon-requires-nonzero-16-hex-key-prefix",
		"single-key target member without a key prefix is rejected");
	check(std::string_view(packages::classify_member("9999999999999999.Foo.targets.addon.lua_B", kind, key))
			== "multi-target-filename-has-key-prefix",
		"multi-target member with a key prefix uses the loader's own reason");
	check(std::string_view(packages::classify_member("x.spawn.lua_B", kind, key))
			== "member-spawn-or-persist-name-rejected"
		&& std::string_view(packages::classify_member("x.persist.addon.lua_B", kind, key))
			== "member-spawn-or-persist-name-rejected",
		"retired spawn/persist names are rejected");
	check(std::string_view(packages::classify_member("_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B", kind, key))
			== "member-is-bootstrapper-infrastructure"
		&& std::string_view(packages::classify_member("a.internal-hook-shim.lua_B", kind, key))
			== "member-is-bootstrapper-infrastructure",
		"bootstrapper infrastructure cannot be packaged");
	check(std::string_view(packages::classify_member("0000000000000000 (zero).lua_B", kind, key))
			== "one-shot-inject-not-allowed-in-package",
		"zero key is not a replacement key");
	check(std::string_view(packages::classify_member("readme.txt", kind, key)) == "member-not-lua_B",
		"non-bytecode file is not a member");

	check(packages::folder_name_error("Missions") == nullptr
		&& packages::folder_name_error("Mission Pack (v2)_x-1.0") == nullptr,
		"ordinary folder names are admissible");
	check(packages::folder_name_error("") != nullptr && packages::folder_name_error(".hidden") != nullptr
		&& packages::folder_name_error("trailing.") != nullptr && packages::folder_name_error("Bad!Name") != nullptr
		&& packages::folder_name_error(std::string(65, 'a')) != nullptr,
		"empty, hidden, trailing-dot, special-character and overlong folder names are rejected");

	check(packages::state_id("Missions") == "package:missions", "policy ID is package:<folder lowercased>");
	check(packages::menu_label("Missions", "") == "[PACKAGE] Missions"
		&& packages::menu_label("missions", "Missions (all modes)") == "[PACKAGE] Missions (all modes)",
		"row label is [PACKAGE] <manifest name or folder>");
	check(packages::chunk_name("Missions", "Missions.targets.addon.lua_B")
			== "Packages/Missions/Missions.targets.addon.lua_B",
		"package chunk names cannot collide with loose Inject names");
	check(packages::members_summary({{"a.lua_B", ""}, {"b.lua_B", "B label"}})
			== "2 members: a.lua_B, B label (b.lua_B)",
		"tooltip member summary uses manifest labels");
	{
		std::vector<std::pair<std::string, std::string>> many;
		for (int i = 0; i != 100; ++i) many.emplace_back("member_" + std::to_string(i) + ".lua_B", "");
		const auto summary = packages::members_summary(many);
		check(summary.size() <= packages::maximum_summary_length + 16
			&& summary.find(" more") != std::string::npos,
			"tooltip member summary is bounded and reports the remainder");
	}
	check(packages::truncate_display(std::string(300, 'x'), 240).size() == 240
		&& packages::truncate_display("short", 240) == "short",
		"tooltip description is bounded");
	check(packages::package_order_less("alpha", "Beta") && !packages::package_order_less("beta", "Alpha"),
		"package order is case-insensitive");

	// Manifest parser.
	packages::Manifest manifest;
	auto error = packages::parse_manifest(
		"\xEF\xBB\xBF{ \"schema\": 1, \"name\": \"Missions\", \"description\": \"All mission values\\n\\u00e9\","
		" \"members\": { \"Missions.targets.addon.lua_B\": { \"label\": \"Mission values\", \"settings\": {\"a\": [1, 2.5e3, true, null]} },"
		" \"fc711ff621a75552 (void flood).lua_B\": {} },"
		" \"settings\": { \"survival.reward_interval\": 150, \"nested\": { \"k\": [\"\\ud83d\\ude00\"] } } }",
		manifest);
	check(error.empty() && manifest.present && manifest.name == "Missions"
		&& manifest.description == "All mission values\n\xC3\xA9"
		&& manifest.members_declared && manifest.members.size() == 2
		&& manifest.members[0].label == "Mission values" && manifest.members[1].label.empty()
		&& manifest.settings_present,
		"full manifest with BOM, escapes, labels and reserved settings parses");
	check(packages::parse_manifest("{}", manifest).empty() && !manifest.members_declared,
		"empty manifest object is valid");
	const std::vector<std::pair<std::string, std::string>> rejects{
		{"[]", "manifest-not-a-json-object"},
		{"{\"schema\": 2}", "manifest-schema-unsupported"},
		{"{\"schema\": \"1\"}", "manifest-schema-not-number"},
		{"{\"name\": 5}", "manifest-name-invalid"},
		{"{\"name\": \"\"}", "manifest-name-invalid"},
		{"{\"name\": \"a\\u0001b\"}", "manifest-name-invalid"},
		{"{\"name\": \"a\", \"name\": \"b\"}", "manifest-duplicate-field=name"},
		{"{\"enabled\": true}", "manifest-unknown-field=enabled"},
		{"{\"members\": []}", "manifest-members-not-object"},
		{"{\"members\": {\"a.txt\": {}}}", "manifest-member-name-not-lua_B=a.txt"},
		{"{\"members\": {\"a.lua_B\": {}, \"A.LUA_B\": {}}}", "manifest-member-duplicate=A.LUA_B"},
		{"{\"members\": {\"a.lua_B\": 1}}", "manifest-member-entry-not-object=a.lua_B"},
		{"{\"members\": {\"a.lua_B\": {\"enabled\": false}}}", "manifest-member-unknown-field=enabled"},
		{"{\"members\": {\"a.lua_B\": {\"label\": 3}}}", "manifest-member-label-invalid=a.lua_B"},
		{"{\"settings\": {\"a\": 1,}}", "manifest-settings-invalid-json"},
		{"{\"settings\": {\"a\": 1, \"a\": 2}}", "manifest-settings-invalid-json"},
		{"{\"settings\": \"\\ud800\"}", "manifest-settings-invalid-json"},
		{"{\"settings\": 01}", "manifest-invalid-json"},
		{"{\"description\": \"a\\u0007b\"}", "manifest-description-invalid"},
		{"{} x", "manifest-trailing-data"},
		{"{\"name\": \"a\"", "manifest-invalid-json"},
	};
	for (const auto& [text, expected] : rejects)
	{
		error = packages::parse_manifest(text, manifest);
		check(error == expected, "manifest rejects: " + expected);
	}
	{
		std::string deep = "{\"settings\": ";
		for (int i = 0; i != 40; ++i) deep += "[";
		for (int i = 0; i != 40; ++i) deep += "]";
		deep += "}";
		check(packages::parse_manifest(deep, manifest) == "manifest-settings-invalid-json",
			"manifest nesting deeper than 32 is rejected");
		check(packages::parse_manifest(std::string(packages::maximum_manifest_bytes + 1, ' '), manifest)
				== "manifest-too-large",
			"manifest larger than 512 KiB is rejected");
		check(packages::maximum_manifest_bytes == 512u * 1024u,
			"manifest bound is 512 KiB (a full-registry settings declaration is about 260 KiB)");
		{
			// A 300 KiB manifest (bigger than any generated package) still parses.
			std::string large = "{\"settings\": {\"pad\": \"";
			large.append(300u * 1024u, 'a');
			large += "\"}}";
			check(packages::parse_manifest(large, manifest).empty() && manifest.settings_present,
				"a 300 KiB manifest is admitted and its settings captured");
		}
	}

	// Manifest/disk reconciliation.
	packages::Manifest declared;
	(void)packages::parse_manifest("{\"members\": {\"A.lua_B\": {}, \"b.lua_B\": {}}}", declared);
	check(packages::reconcile_manifest_members(declared, {"a.lua_B", "B.LUA_B"}).empty(),
		"declared members match the disk case-insensitively");
	check(packages::reconcile_manifest_members(declared, {"a.lua_B"}) == "manifest-member-missing-on-disk=b.lua_B",
		"a partially copied package fails as a whole");
	// AUTO-JOIN (LAYOUT_V2, 2026-10-10): an unlisted member joins instead of failing the package.
	check(packages::reconcile_manifest_members(declared, {"a.lua_B", "b.lua_B", "c.lua_B"}).empty()
			&& packages::auto_joined_members(declared, {"a.lua_B", "b.lua_B", "c.lua_B"})
				== std::vector<std::string>{"c.lua_B"},
		"an undeclared extra member auto-joins the package");
	packages::Manifest undeclared;
	check(packages::reconcile_manifest_members(undeclared, {"x.lua_B"}).empty(),
		"without a members list every lua_B file in the folder is a member");

	// Conflict resolution.
	const std::vector<packages::SourceClaims> loose{
		{"loose:1111111111111111 (a).lua_B", {0x1111111111111111ull}, {}},
		{"loose:Inject/2222222222222222.X.target.addon.lua_B", {}, {0x2222222222222222ull}},
		{"loose:Inject/Dup.targets.addon.lua_B", {}, {0x2222222222222222ull}},
	};
	const std::vector<packages::SourceClaims> sorted_packages{
		{"package:A", {0x1111111111111111ull, 0x5555555555555555ull}, {}},
		{"package:B", {}, {0x2222222222222222ull}},
		{"package:C", {0x5555555555555555ull}, {0x7777777777777777ull}},
		{"package:D", {}, {0x7777777777777777ull}},
		{"package:E", {0x9999999999999999ull}, {0x1111111111111111ull}},
	};
	const auto decisions = packages::resolve_conflicts(loose, sorted_packages);
	check(decisions.size() == 5, "one decision per package");
	check(!decisions[0].accepted && decisions[0].replacement && decisions[0].key == 0x1111111111111111ull
		&& decisions[0].holder == "loose:1111111111111111 (a).lua_B"
		&& decisions[0].reason == "conflict kind=replacement key=1111111111111111 holder=loose:1111111111111111 (a).lua_B resolution=later-sorted-source-fails-closed",
		"package vs loose replacement key: the package fails closed with an exact reason");
	check(!decisions[1].accepted && !decisions[1].replacement && decisions[1].key == 0x2222222222222222ull
		&& decisions[1].holder == "loose:Inject/2222222222222222.X.target.addon.lua_B",
		"package vs loose target key: the package fails; the holder is the first loose source by name");
	check(decisions[2].accepted, "a rejected package's claims never block a later package");
	check(!decisions[3].accepted && decisions[3].holder == "package:C",
		"package vs package target key: the later-sorted package fails");
	check(decisions[4].accepted, "replacement and target key spaces are independent");
	check(packages::resolve_conflicts({}, {{"package:X", {1}, {2}}, {"package:Y", {3}, {4}}})[1].accepted,
		"disjoint packages both apply");
}

// -----------------------------------------------------------------------------
void end_to_end(const std::filesystem::path& fixture_path, const std::filesystem::path& work)
{
	const auto fixture = read_all(fixture_path);
	check(fixture.size() > 16 && fixture[0] == 0x09 && fixture[1] == 0x03,
		"real compiled DE multi-target fixture is available");
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);

	// No Packages folder: packages are optional and the scan is a no-op.
	gate::log_lines.clear();
	check(packages::initialise() && packages::candidate()->packages.empty() && gate::log_lines.empty(),
		"absent Packages folder: empty snapshot, no log output");

	const std::vector<unsigned char> blob{'D', 'E', 'b', 'o', 'd', 'y'};
	// Loose files (unchanged lanes).
	write_bytes(gate::root / "1111111111111111 (loose replacement).lua_B", blob);
	write_bytes(gate::root / "2222222222222222 (loose disabled).lua_B", blob);
	write_bytes(gate::inject / "3333333333333333.Loose.target.addon.lua_B", blob);
	write_bytes(gate::inject / "LooseMulti.targets.addon.lua_B", synthetic_pool({"4444444444444444", "HELLO"}));
	write_bytes(gate::inject / "LooseOneShot.lua_B", blob);
	gate::policy["replacement:2222222222222222 (loose disabled).lua_b"] = false;

	const auto packages_dir = gate::root / "Packages";
	const auto missions = packages_dir / "Missions";
	write_bytes(missions / "Missions.targets.addon.lua_B", fixture);
	const std::vector<unsigned char> flood{'F', 'L', 'O', 'O', 'D', '4'};
	write_bytes(missions / "fc711ff621a75552 (missions_exact-replacement).lua_B", flood);
	write_text(missions / "package.json",
		"{\n  \"schema\": 1,\n  \"name\": \"Missions\",\n  \"description\": \"Mission values\",\n"
		"  \"members\": {\n    \"Missions.targets.addon.lua_B\": { \"label\": \"Mission tunables\" },\n"
		"    \"fc711ff621a75552 (missions_exact-replacement).lua_B\": { \"label\": \"Void Flood fractures\" }\n  },\n"
		"  \"settings\": {}\n}\n");
	write_text(missions / "SHA256SUMS.txt", "documentation only");
	write_bytes(packages_dir / "ConflictReplacement" / "1111111111111111 (dup).lua_B", blob);
	write_bytes(packages_dir / "DisabledLooseOk" / "2222222222222222 (pkg).lua_B", blob);
	write_bytes(packages_dir / "ConflictLooseTarget" / "3333333333333333.X.target.addon.lua_B", blob);
	write_bytes(packages_dir / "ConflictLooseMulti" / "M.targets.addon.lua_B", synthetic_pool({"4444444444444444"}));
	write_bytes(packages_dir / "Zeta" / "Zeta.targets.addon.lua_B", synthetic_pool({"f10a043e7f825db2"}));
	write_bytes(packages_dir / "Beta" / "1111111111111111 (b).lua_B", blob);
	write_bytes(packages_dir / "Beta" / "5555555555555555 (b).lua_B", blob);
	write_bytes(packages_dir / "Gamma" / "5555555555555555 (g).lua_B", blob);
	write_bytes(packages_dir / "Disabled" / "abcdefabcdefabcd (d).lua_B", blob);
	write_bytes(packages_dir / "Disabled" / "D.targets.addon.lua_B", synthetic_pool({"dddddddddddddddd"}));
	gate::policy["package:disabled"] = false;
	write_bytes(packages_dir / "OneShot" / "Thing.lua_B", blob);
	write_bytes(packages_dir / "Managed" / "Thing.addon.lua_B", blob);
	write_text(packages_dir / "BadManifest" / "package.json", "{\"name\": 5}");
	write_bytes(packages_dir / "BadManifest" / "6666666666666666 (x).lua_B", blob);
	write_text(packages_dir / "Partial" / "package.json",
		"{\"members\": {\"7777777777777777 (a).lua_B\": {}, \"Missing.targets.addon.lua_B\": {}}}");
	write_bytes(packages_dir / "Partial" / "7777777777777777 (a).lua_B", blob);
	write_text(packages_dir / "Extra" / "package.json", "{\"members\": {\"7777777777777777 (a).lua_B\": {}}}");
	write_bytes(packages_dir / "Extra" / "7777777777777777 (a).lua_B", blob);
	write_bytes(packages_dir / "Extra" / "7777777777777778 (b).lua_B", blob);
	write_text(packages_dir / "Empty" / "README.txt", "no members");
	write_bytes(packages_dir / "Bad!Name" / "8888888888888889 (x).lua_B", blob);
	write_bytes(packages_dir / "DupKey" / "8888888888888888 (a).lua_B", blob);
	write_bytes(packages_dir / "DupKey" / "8888888888888888 (b).lua_B", blob);
	write_bytes(packages_dir / "BadMulti" / "Bad.targets.addon.lua_B", blob);
	write_bytes(packages_dir / "stray.lua_B", blob); // files directly under Packages are ignored

	// The loose scanners use a non-recursive directory_iterator + is_regular_file.
	// Reproduce that exact enumeration: no package member is visible to them.
	bool loose_sees_package = false;
	for (const auto& root : {gate::root, gate::inject})
	{
		for (std::filesystem::directory_iterator it(root, ec), end; !ec && it != end; it.increment(ec))
		{
			if (!it->is_regular_file(ec)) continue;
			const auto name = it->path().filename().string();
			if (name.find("fc711ff621a75552") != std::string::npos
				|| name == "Missions.targets.addon.lua_B")
			{
				loose_sees_package = true;
			}
		}
	}
	check(!loose_sees_package, "loose scanners' non-recursive enumeration never sees package members");

	gate::log_lines.clear();
	check(packages::initialise(), "startup scan PASS with mixed valid/invalid packages");
	const auto startup = packages::candidate();
	const auto* m = find_package(*startup, "Missions");
	check(m != nullptr && m->accepted && m->enabled && m->structurally_valid && m->reason.empty()
		&& m->display == "Missions" && m->description == "Mission values" && m->id == "package:missions",
		"Missions package accepted with manifest name, description and policy ID");
	check(m != nullptr && m->members.size() == 2
		&& m->members[0].filename == "fc711ff621a75552 (missions_exact-replacement).lua_B"
		&& m->members[0].kind == packages::MemberKind::Replacement
		&& m->members[0].key == 0xfc711ff621a75552ull && m->members[0].bytes == flood
		&& m->members[0].label == "Void Flood fractures"
		&& m->members[1].filename == "Missions.targets.addon.lua_B"
		&& m->members[1].kind == packages::MemberKind::MultiTargetAddon
		&& m->members[1].bytes == fixture
		&& m->members[1].target_keys == std::vector<std::uint64_t>{
			0x6fa60841c9e0f207ull, 0xcaec63d8e739b693ull, 0xf10a043e7f825db2ull},
		"Missions members: exact replacement bytes and the real fixture's three declared targets");
	const auto* conflict_replacement = find_package(*startup, "ConflictReplacement");
	check(conflict_replacement != nullptr && conflict_replacement->structurally_valid
		&& !conflict_replacement->accepted
		&& reason_contains(conflict_replacement, "conflict kind=replacement key=1111111111111111 holder=loose:1111111111111111 (loose replacement).lua_B"),
		"package replacement conflicting with an enabled loose replacement fails closed");
	const auto* disabled_loose_ok = find_package(*startup, "DisabledLooseOk");
	check(disabled_loose_ok != nullptr && disabled_loose_ok->accepted,
		"a disabled loose file claims nothing, so the package applies");
	check(reason_contains(find_package(*startup, "ConflictLooseTarget"),
			"conflict kind=target key=3333333333333333 holder=loose:Inject/3333333333333333.Loose.target.addon.lua_B"),
		"package target conflicting with a loose single-key target addon fails closed");
	check(reason_contains(find_package(*startup, "ConflictLooseMulti"),
			"conflict kind=target key=4444444444444444 holder=loose:Inject/LooseMulti.targets.addon.lua_B"),
		"package target conflicting with a loose multi-target addon fails closed");
	check(reason_contains(find_package(*startup, "Zeta"), "conflict kind=target key=f10a043e7f825db2 holder=package:Missions"),
		"later-sorted package conflicting with Missions fails; Missions keeps working");
	check(reason_contains(find_package(*startup, "Beta"), "conflict kind=replacement key=1111111111111111")
		&& find_package(*startup, "Gamma") != nullptr && find_package(*startup, "Gamma")->accepted,
		"a rejected package does not block a later package on its other keys");
	const auto* disabled = find_package(*startup, "Disabled");
	check(disabled != nullptr && disabled->structurally_valid && !disabled->enabled && !disabled->accepted
		&& disabled->members.size() == 2 && disabled->members[0].bytes.empty()
		&& disabled->members[1].bytes.empty()
		&& disabled->members[0].key == 0xabcdefabcdefabcdull
		&& disabled->members[1].target_keys == std::vector<std::uint64_t>{0xddddddddddddddddull},
		"disabled package: keys inventoried, no bytes enter any lane");
	check(reason_contains(find_package(*startup, "OneShot"), "member=Thing.lua_B one-shot-inject-not-allowed-in-package"),
		"one-shot member fails its package with an exact reason");
	check(reason_contains(find_package(*startup, "Managed"),
			"member=Thing.addon.lua_B managed-addon-member-unsupported-generation-wide-transaction"),
		"managed addon member fails its package with an exact reason");
	check(reason_contains(find_package(*startup, "BadManifest"), "manifest-name-invalid"),
		"invalid manifest fails its package");
	check(reason_contains(find_package(*startup, "Partial"), "manifest-member-missing-on-disk=Missing.targets.addon.lua_B"),
		"partially copied package fails as a whole");
	{
		const auto* extra = find_package(*startup, "Extra");
		check(extra != nullptr && extra->structurally_valid && extra->accepted && extra->members.size() == 2
				&& extra->auto_joined == std::vector<std::string>{"7777777777777778 (b).lua_B"}
				&& logged("RENOVICE PACKAGE MEMBER AUTO-JOIN trigger=startup package=Extra member=7777777777777778 (b).lua_B"),
			"undeclared member auto-joins its package (logged)");
	}
	check(reason_contains(find_package(*startup, "Empty"), "package-has-no-lua_B-members"),
		"folder without members is rejected");
	check(reason_contains(find_package(*startup, "Bad!Name"), "package-folder-name-invalid-character"),
		"invalid folder name is rejected");
	check(reason_contains(find_package(*startup, "DupKey"), "duplicate-replacement-key-in-package key=8888888888888888"),
		"two replacement members with one key fail the package");
	check(reason_contains(find_package(*startup, "BadMulti"), "member=Bad.targets.addon.lua_B not-de-bytecode-container"),
		"malformed multi-target member fails its package with the loader's reason");
	for (const auto& package : startup->packages)
	{
		if (package.accepted) continue;
		bool bytes_retained = false;
		for (const auto& member : package.members) bytes_retained |= !member.bytes.empty();
		if (bytes_retained) check(false, "rejected package retained bytes: " + package.folder);
	}
	{
		std::vector<std::string> order;
		for (const auto& package : startup->packages) order.push_back(package.folder);
		check(std::is_sorted(order.begin(), order.end(), [](const std::string& a, const std::string& b)
			{ return packages::package_order_less(a, b); })
			&& std::find(order.begin(), order.end(), "stray.lua_B") == order.end(),
			"packages are evaluated in deterministic case-insensitive order; loose files in Packages are ignored");
	}
	check(logged("RENOVICE PACKAGE ACCEPT trigger=startup package=Missions id=package:missions members=2 replacements=1 target_addons=1 target_keys=3 lanes=replacement+inject"),
		"operational log: exact ACCEPT line");
	check(logged("RENOVICE PACKAGE REJECT trigger=startup package=OneShot id=package:oneshot enabled=1 reason=member=Thing.lua_B one-shot-inject-not-allowed-in-package scope=package-local generation=continues"),
		"operational log: exact package-local REJECT line");
	check(logged("RENOVICE PACKAGE DISABLED trigger=startup package=Disabled"),
		"operational log: disabled package is inventory-only");
	// AUTO-JOIN (2026-10-10): the Extra fixture package is accepted now (3 -> 4).
	check(logged("RENOVICE PACKAGES scan PASS trigger=startup packages=18 accepted=4"),
		"operational log: scan summary");

	// F9: prepare with a new policy, discard, prepare again, commit.
	gate::policy["package:missions"] = false;
	check(packages::prepare_reload(), "F9 package prepare PASS");
	const auto prepared = packages::candidate();
	const auto* prepared_missions = find_package(*prepared, "Missions");
	check(prepared != startup && prepared_missions != nullptr && !prepared_missions->accepted
		&& prepared_missions->structurally_valid && prepared_missions->members.size() == 2
		&& prepared_missions->members[1].target_keys.size() == 3
		&& prepared_missions->members[0].bytes.empty() && prepared_missions->members[1].bytes.empty(),
		"F9 candidate is the prepared snapshot; the disabled package keeps inventory keys only");
	check(find_package(*prepared, "Zeta") != nullptr && find_package(*prepared, "Zeta")->accepted,
		"with Missions disabled it claims nothing, so Zeta applies deterministically");
	packages::discard_prepared_reload();
	check(packages::candidate() == startup, "discard restores the committed snapshot");
	check(packages::prepare_reload(), "F9 package prepare PASS (second)");
	const auto second = packages::candidate();
	packages::commit_prepared_reload();
	check(packages::candidate() == second && !find_package(*second, "Missions")->accepted,
		"commit publishes the prepared snapshot atomically");

	// Deletion is part of the snapshot.
	gate::policy["package:missions"] = true;
	std::filesystem::remove_all(packages_dir / "Zeta");
	check(packages::prepare_reload(), "F9 package prepare PASS after deleting a package");
	check(find_package(*packages::candidate(), "Zeta") == nullptr
		&& find_package(*packages::candidate(), "Missions")->accepted,
		"a deleted package leaves the snapshot on the next F9");
	packages::commit_prepared_reload();

	// Scripts-menu inventory: quiet, no replacement bytes, same decisions.
	gate::log_lines.clear();
	const auto listed = packages::inventory();
	const auto* listed_missions = find_package(*listed, "Missions");
	check(gate::log_lines.empty() && listed_missions != nullptr && listed_missions->accepted
		&& listed_missions->members[0].bytes.empty() && listed_missions->members[1].bytes.empty()
		&& listed_missions->members[1].target_keys.size() == 3,
		"menu inventory is quiet and holds no member bytes");
}

void loose_regression()
{
	using script_control::Kind;
	check(static_cast<int>(Kind::OneShot) == 0 && static_cast<int>(Kind::Addon) == 1
		&& static_cast<int>(Kind::TargetAddon) == 2 && static_cast<int>(Kind::Replacement) == 3
		&& static_cast<int>(Kind::Package) == 4,
		"existing kind ordinals and menu sort positions are unchanged; Package is appended last");
	struct Pin { Kind kind; const char* file; const char* id; const char* label; };
	const Pin pins[] = {
		{Kind::TargetAddon, "Missions.targets.addon.lua_B", "target-addon:missions.targets.addon.lua_b", "[ADDON] Missions"},
		{Kind::TargetAddon, "ec368d4901690a15.Mallet.target.addon.lua_B", "target-addon:ec368d4901690a15.mallet.target.addon.lua_b", "[ADDON] Mallet"},
		{Kind::Replacement, "fc711ff621a75552 (missions_exact-replacement).lua_B", "replacement:fc711ff621a75552 (missions_exact-replacement).lua_b", "[REPLACEMENT] Missions Exact Replacement"},
		{Kind::Addon, "Example.addon.lua_B", "addon:example.addon.lua_b", "[ADDON] Example"},
		{Kind::OneShot, "Riven Lock Script.lua_B", "oneshot:riven lock script.lua_b", "[ONE-SHOT] Riven Rerolls: Stat Locks"},
	};
	for (const auto& pin : pins)
	{
		check(script_control::stable_id(pin.kind, pin.file) == pin.id
			&& script_control::menu_display_name(pin.kind, pin.file) == pin.label,
			std::string("loose identity unchanged: ") + pin.file);
	}
	check(injection::classify_script("Missions.targets.addon.lua_B") == injection::ScriptKind::TargetManagedAddon
		&& injection::classify_script("Example.addon.lua_B") == injection::ScriptKind::ManagedAddon
		&& injection::classify_script("Riven Lock Script.lua_B") == injection::ScriptKind::Ordinary,
		"loose classification unchanged");
}
}

// Optional: admit a real package folder (for example generator output) through
// the exact loader scanner, with no loose files and the default policy.
void admit_external(const std::filesystem::path& package_folder, const std::filesystem::path& work)
{
	std::error_code ec;
	const auto root = work / "admit" / "CustomScripts";
	std::filesystem::remove_all(work / "admit", ec);
	std::filesystem::create_directories(root / "Inject");
	const auto name = package_folder.filename();
	std::filesystem::create_directories(root / "Packages" / name);
	std::filesystem::copy(package_folder, root / "Packages" / name,
		std::filesystem::copy_options::recursive, ec);
	check(!ec, "external package copied into an empty CustomScripts tree");
	gate::root = root;
	gate::inject = root / "Inject";
	gate::policy.clear();
	gate::log_lines.clear();
	check(packages::initialise(), "external package scan PASS");
	const auto snapshot = packages::candidate();
	const auto* package = find_package(*snapshot, name.string());
	check(package != nullptr && package->structurally_valid && package->accepted,
		"external package is accepted by the loader rules: " + name.string()
			+ (package != nullptr && !package->reason.empty() ? " reason=" + package->reason : std::string()));
	if (package == nullptr) return;
	std::cout << "INFO\tpackage=" << package->folder << " id=" << package->id
		<< " row=" << packages::menu_label(package->folder,
			package->display == package->folder ? std::string_view{} : std::string_view{package->display})
		<< " members=" << package->members.size() << '\n';
	for (const auto& member : package->members)
	{
		std::cout << "INFO\tmember=" << member.filename
			<< " kind=" << packages::member_kind_label(member.kind)
			<< " key=" << (member.key != 0 ? packages::key_text(member.key) : std::string("-"))
			<< " targets=" << member.target_keys.size()
			<< " bytes=" << member.bytes.size()
			<< " label=\"" << member.label << "\"\n";
		for (const auto key : member.target_keys) std::cout << "INFO\t  target=" << packages::key_text(key) << '\n';
	}
	for (const auto& line : gate::log_lines) std::cout << "LOG\t" << line << '\n';
}

// \\?\ form: MSVC std::filesystem then creates, copies and removes trees
// beyond MAX_PATH (the repository or the work folder may be deep).
std::filesystem::path long_path(const std::filesystem::path& path)
{
	const std::wstring& native = path.native();
	if (native.rfind(LR"(\\?\)", 0) == 0) return path;
	const std::wstring absolute = std::filesystem::absolute(path).native();
	if (absolute.rfind(LR"(\\)", 0) == 0) return std::filesystem::path(LR"(\\?\UNC\)" + absolute.substr(2));
	return std::filesystem::path(LR"(\\?\)" + absolute);
}

int main(int argc, char** argv)
{
	if (argc != 3 && !(argc == 5 && std::string_view(argv[3]) == "--admit"))
	{
		std::cerr << "usage: verify_script_packages <fixture.lua_B> <work dir> [--admit <package folder>]\n";
		return 2;
	}
	pure_rules();
	end_to_end(long_path(argv[1]), long_path(argv[2]));
	loose_regression();
	if (argc == 5) admit_external(long_path(argv[4]), long_path(argv[2]));
	std::cout << (pass ? "SCRIPT PACKAGES PASS" : "SCRIPT PACKAGES FAIL") << '\n';
	return pass ? 0 : 1;
}
