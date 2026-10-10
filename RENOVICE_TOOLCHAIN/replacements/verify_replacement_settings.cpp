// Deterministic gate for REPLACEMENT_SETTINGS_V1 (2026-09-30).
//
// Part 1: pure rules (renovice/replacement_settings_core.hpp): which members
//         receive a delivery, key argument parsing, call-key resolution, the
//         accessor slot/install decision, the DE native-name hash.
// Part 2: the accessor global name against the known-name base: no known name
//         hashes to the same key with the build seed (no stock global can be
//         shadowed or overwritten), and the key equals the hash the U44
//         compiler emitted into the real fixture.
// Part 3: the exact renovice/packages.cpp scanner plus
//         renovice/replacement_settings.cpp end to end (stub config and policy
//         providers) with the real compiled U44 replacement fixture: delivery
//         for a replacement member, values file variants, fail-closed cases,
//         disabled package/member, loose files, literal-only replacements
//         unchanged, mixed literal+addon members, committed-snapshot log lines.
//
// Part 4: SCRIPT SETTINGS for a replacement member in the nested layout (the
//         R5 default): top page -> package page (member switch with the
//         replacement tooltip) -> section page -> value page, then a staged
//         edit through the host model, the values-file writer, a rescan and
//         the committed snapshot the accessor reads.
//
// Usage: verify_replacement_settings <work dir> <fixture dir> <fixture.lua_B>
//            <compiled accessor hash hex> <namebase.tsv>
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdio>
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
#include "../../renovice/replacement_settings.hpp"
#include "../../renovice/replacement_settings_core.hpp"
#include "../../renovice/script_control.hpp"
#include "../../renovice/settings_ui_core.hpp"

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
constexpr std::uint32_t u44_seed = 0x768E5ED0u;
constexpr std::uint32_t u43_seed = 0x7E5AF8E9u;
constexpr std::uint64_t fixture_key = 0xfb346b59e2b7687aull;
const std::string example_folder = "HijackSettingsExample";
const std::string example_member = "fb346b59e2b7687a (hijack payload health from settings).lua_B";

void check(bool result, const std::string& name)
{
	std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
	pass &= result;
}

std::vector<unsigned char> read_bytes(const std::filesystem::path& path)
{
	std::ifstream input(path, std::ios::binary);
	return std::vector<unsigned char>(std::istreambuf_iterator<char>(input), {});
}

std::string read_text(const std::filesystem::path& path)
{
	const auto bytes = read_bytes(path);
	return std::string(bytes.begin(), bytes.end());
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

bool logged(std::string_view needle)
{
	return std::any_of(gate::log_lines.begin(), gate::log_lines.end(),
		[&](const std::string& line) { return line.find(needle) != std::string::npos; });
}

bool logged_prefix(std::string_view prefix)
{
	return std::any_of(gate::log_lines.begin(), gate::log_lines.end(),
		[&](const std::string& line) { return line.rfind(prefix, 0) == 0; });
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

settings::Declarations parse_or_die(std::string_view top, const std::vector<std::pair<std::string, std::string>>& members)
{
	settings::Declarations declarations;
	const auto error = settings::parse_declarations(top, members, declarations);
	if (!error.empty()) std::cout << "declaration parse error: " << error << '\n';
	return declarations;
}

const char* group_top =
	"{ \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\","
	" \"groups\": [ { \"id\": \"g\", \"label\": \"G\", \"order\": 1 } ] }";

std::string value_json(std::string_view id, std::string_view lane)
{
	return "\"" + std::string(id) + "\": { \"group\": \"g\", \"label\": \"L\", \"type\": \"int\","
		" \"stock\": 10, \"min\": 0, \"max\": 100, \"lane\": \"" + std::string(lane) + "\" }";
}

void pure_rules()
{
	const auto declarations = parse_or_die(group_top, {
		{"aaaaaaaaaaaaaaaa (literal only).lua_B", "{ \"values\": { " + value_json("lit.only", "literal") + " } }"},
		{"bbbbbbbbbbbbbbbb (reads).lua_B", "{ \"values\": { " + value_json("rep.read", "addon") + " } }"},
		{"cccccccccccccccc (mixed).lua_B", "{ \"values\": { " + value_json("mix.lit", "literal") + ", "
			+ value_json("mix.read", "addon") + " } }"},
		{"Addon.targets.addon.lua_B", "{ \"values\": { " + value_json("addon.lit", "literal") + " } }"},
	});
	check(declarations.values.size() == 5, "fixture declarations parse (5 values)");
	check(!replacement_settings::member_receives_delivery(true, declarations, "aaaaaaaaaaaaaaaa (literal only).lua_B"),
		"a replacement with literal values only receives no delivery (packages written before this primitive are unchanged)");
	check(replacement_settings::member_receives_delivery(true, declarations, "bbbbbbbbbbbbbbbb (reads).lua_B"),
		"a replacement that declares an addon-lane value receives a delivery");
	check(replacement_settings::member_receives_delivery(true, declarations, "cccccccccccccccc (mixed).lua_B"),
		"a mixed literal+addon replacement receives a delivery");
	check(replacement_settings::member_receives_delivery(false, declarations, "Addon.targets.addon.lua_B")
			== settings::member_declares_values(declarations, "Addon.targets.addon.lua_B"),
		"addon members keep the ADDON_SETTINGS_V1 rule exactly");
	check(!replacement_settings::member_receives_delivery(true, declarations, "dddddddddddddddd (none).lua_B"),
		"a replacement without declarations receives nothing");

	std::uint64_t key = 0;
	check(replacement_settings::parse_key_argument("fb346b59e2b7687a", key) && key == fixture_key,
		"key argument: 16 lowercase hex digits");
	check(replacement_settings::parse_key_argument("FB346B59E2B7687A", key) && key == fixture_key,
		"key argument: uppercase accepted");
	check(!replacement_settings::parse_key_argument("fb346b59e2b7687", key) && key == 0,
		"key argument: 15 digits rejected");
	check(!replacement_settings::parse_key_argument("fb346b59e2b7687a0", key),
		"key argument: 17 characters rejected (no filename annotation)");
	check(!replacement_settings::parse_key_argument("fb346b59e2b7687g", key),
		"key argument: non-hex rejected");
	check(!replacement_settings::parse_key_argument("0000000000000000", key),
		"key argument: zero key rejected");

	using replacement_settings::ArgumentKind;
	using replacement_settings::CallKeySource;
	constexpr std::uint64_t other_key = 0x1111111111111111ull;
	auto plan = replacement_settings::plan_call(fixture_key, ArgumentKind::Absent, false, 0, 0, ArgumentKind::Absent, 0);
	check(plan.source == CallKeySource::Bound && plan.key == fixture_key && !plan.has_known_serial, "call(): the bound key, no cache check");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::Nil, false, 0, 0, ArgumentKind::Absent, 0);
	check(plan.source == CallKeySource::Bound && !plan.has_known_serial, "call(nil): first call of a cache (no known serial yet)");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::Number, false, 0, 7, ArgumentKind::Absent, 0);
	check(plan.source == CallKeySource::Bound && plan.has_known_serial && plan.known_serial == 7.0, "call(serial): bound key with a cache check");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::String, true, other_key, 0, ArgumentKind::Absent, 0);
	check(plan.source == CallKeySource::Argument && plan.key == other_key && !plan.has_known_serial, "call(key): an explicit valid key overrides the bound key");
	plan = replacement_settings::plan_call(0, ArgumentKind::String, true, other_key, 0, ArgumentKind::Number, 3);
	check(plan.source == CallKeySource::Argument && plan.key == other_key && plan.has_known_serial && plan.known_serial == 3.0,
		"call(key, serial): explicit key with a cache check (works on an unbound accessor)");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::String, false, 0, 0, ArgumentKind::Absent, 0);
	check(plan.source == CallKeySource::None, "call(bad string): resolves to nothing, never to the bound key");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::String, true, other_key, 0, ArgumentKind::Other, 0);
	check(plan.source == CallKeySource::None, "call(key, non-number): resolves to nothing");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::Other, false, 0, 0, ArgumentKind::Absent, 0);
	check(plan.source == CallKeySource::None, "call(table): resolves to nothing");
	plan = replacement_settings::plan_call(0, ArgumentKind::Absent, false, 0, 0, ArgumentKind::Absent, 0);
	check(plan.source == CallKeySource::None, "call() on an unbound accessor resolves to nothing");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::Number, false, 0, 5, ArgumentKind::Absent, 0);
	check(replacement_settings::caller_is_current(plan, 5) && !replacement_settings::caller_is_current(plan, 6),
		"cache check: the table is skipped only for the exact committed serial");
	plan = replacement_settings::plan_call(fixture_key, ArgumentKind::Absent, false, 0, 0, ArgumentKind::Absent, 0);
	check(!replacement_settings::caller_is_current(plan, 5), "no known serial: the table is always built");
	check(replacement_settings::serial_number(16777215) == 16777215.0f && replacement_settings::serial_number(1) == 1.0f,
		"serial is exact in a DE float (up to 2^24 - 1 commits)");

	using replacement_settings::InstallAction;
	using replacement_settings::SlotState;
	check(replacement_settings::install_action(SlotState::Empty) == InstallAction::Install, "slot empty -> install");
	check(replacement_settings::install_action(SlotState::OwnSameKey) == InstallAction::Keep, "own accessor, same key -> keep (no VM write)");
	check(replacement_settings::install_action(SlotState::OwnUnbound) == InstallAction::Keep, "own unbound accessor -> keep");
	check(replacement_settings::install_action(SlotState::OwnOtherKey) == InstallAction::RebindUnbound,
		"own accessor for another key (shared environment) -> unbound, explicit keys only");
	check(replacement_settings::install_action(SlotState::Foreign) == InstallAction::RejectForeign,
		"foreign value under the name -> never overwritten (fail closed)");

	check(replacement_settings::native_name_hash("GetConfigBool", u43_seed) == 0x4aec2dacu,
		"native-name hash reproduces the toolchain self-test (GetConfigBool, U43 seed)");

	// build_snapshot filters and uniqueness.
	packages::Snapshot source;
	const auto delivery = std::make_shared<settings::MemberDelivery>();
	delivery->identity = "settings-v1:x";
	auto make = [&](std::string folder, bool accepted, packages::MemberKind kind, std::uint64_t member_key,
		bool staged, bool with_delivery)
	{
		packages::Package package;
		package.folder = std::move(folder);
		package.accepted = accepted;
		packages::Member member;
		member.filename = "m.lua_B";
		member.kind = kind;
		member.key = member_key;
		member.staged = staged;
		if (with_delivery) member.delivery = delivery;
		package.members.push_back(member);
		source.packages.push_back(package);
	};
	make("A", true, packages::MemberKind::Replacement, 0x30, true, true);
	make("B", false, packages::MemberKind::Replacement, 0x40, true, true);
	make("C", true, packages::MemberKind::Replacement, 0x50, false, true);
	make("D", true, packages::MemberKind::Replacement, 0x60, true, false);
	make("E", true, packages::MemberKind::TargetAddon, 0x70, true, true);
	make("F", true, packages::MemberKind::Replacement, 0x10, true, true);
	make("G", true, packages::MemberKind::Replacement, 0x20, true, true);
	make("H", true, packages::MemberKind::Replacement, 0x20, true, true);
	const auto built = replacement_settings::build_snapshot(&source, 7);
	check(built.serial == 7 && built.entries.size() == 2 && built.entries[0].key == 0x10 && built.entries[1].key == 0x30
		&& built.find(0x30) != nullptr && built.find(0x30)->package == "A",
		"snapshot: only accepted, staged replacement members with a delivery; sorted by key");
	check(built.find(0x40) == nullptr && built.find(0x50) == nullptr && built.find(0x60) == nullptr && built.find(0x70) == nullptr,
		"snapshot: rejected/disabled package, held-back member, no delivery and addon members are absent");
	check(built.find(0x20) == nullptr, "snapshot: a duplicated key (scanner defect) drops both claimants (fail closed)");
	check(replacement_settings::build_snapshot(nullptr, 1).entries.empty(), "snapshot: no package snapshot -> empty");
}

void name_hash(const std::string& compiled_hash_hex, const std::filesystem::path& namebase)
{
	const auto expected = replacement_settings::native_name_hash(replacement_settings::accessor_global_name, u44_seed);
	std::uint32_t compiled = 0;
	try { compiled = static_cast<std::uint32_t>(std::stoul(compiled_hash_hex, nullptr, 16)); } catch (...) {}
	char text[9]{};
	std::snprintf(text, sizeof(text), "%08x", expected);
	std::cout << "INFO\taccessor " << replacement_settings::accessor_global_name << " hash(U44)=" << text << '\n';
	check(compiled == expected,
		"the host key (wf_fnv_2, seed 768e5ed0) equals the global hash the U44 compiler emitted in the fixture");
	std::ifstream input(namebase, std::ios::binary);
	std::size_t names = 0;
	std::vector<std::string> collisions;
	std::string line;
	while (std::getline(input, line))
	{
		if (!line.empty() && line.back() == '\r') line.pop_back();
		const auto tab = line.find('\t');
		if (tab == std::string::npos) continue;
		const auto name = std::string_view(line).substr(tab + 1);
		++names;
		if (name != replacement_settings::accessor_global_name
			&& replacement_settings::native_name_hash(name, u44_seed) == expected)
		{
			collisions.emplace_back(name);
		}
	}
	std::cout << "INFO\tnamebase names=" << names << " collisions=" << collisions.size() << '\n';
	check(names > 900000 && collisions.empty(),
		"no known name (verified namebase) hashes to the accessor key with the U44 seed");
}

std::string example_values(std::string_view entries, bool use_stock = false)
{
	return "{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:hijacksettingsexample\","
		" \"build\": \"2026.09.28.13.06\", \"use_stock\": " + std::string(use_stock ? "true" : "false")
		+ ", \"groups\": { \"hijack\": true }, \"values\": { " + std::string(entries) + " } }";
}

void end_to_end(const std::filesystem::path& work, const std::filesystem::path& fixture_dir,
	const std::filesystem::path& fixture_bytes_path)
{
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);
	gate::policy.clear();
	const auto bytes = read_bytes(fixture_bytes_path);
	check(bytes.size() > 16 && bytes[0] == 0x09 && bytes[1] == 0x03, "the compiled fixture is a DE 09 03 container");
	const auto manifest = read_text(fixture_dir / example_folder / "package.json");
	const auto values_file = read_text(fixture_dir / "Settings" / (example_folder + ".json"));
	const auto package_dir = gate::root / "Packages" / example_folder;
	const auto settings_path = gate::root / "Settings" / (example_folder + ".json");
	write_bytes(package_dir / example_member, bytes);
	write_text(package_dir / "package.json", manifest);

	// 1. Declarations, no values file: member staged, empty delivery, entry with 0 values.
	gate::log_lines.clear();
	check(packages::initialise(), "startup scan PASS (example package, no values file)");
	auto snapshot = packages::candidate();
	auto* package = find_package(*snapshot, example_folder);
	auto* member = find_member(package, example_member);
	check(package != nullptr && package->accepted && package->declarations != nullptr
		&& member != nullptr && member->kind == packages::MemberKind::Replacement && member->key == fixture_key
		&& member->staged && member->bytes == bytes && member->delivery != nullptr && member->delivery->values.empty(),
		"example: replacement member staged with its exact bytes and an empty delivery (no values file = stock)");
	check(logged("RENOVICE SETTINGS DELIVERY trigger=startup package=" + example_folder + " member=" + example_member
			+ " values=0 identity=") && logged(" staged=1"),
		"example: the existing DELIVERY operational line now also covers the replacement member");
	replacement_settings::commit(snapshot, "startup");
	auto committed = replacement_settings::committed();
	check(committed != nullptr && committed->entries.size() == 1 && committed->find(fixture_key) != nullptr
		&& committed->find(fixture_key)->delivery->values.empty(),
		"committed snapshot: one entry, zero values (accessor returns an empty table)");
	check(logged("RENOVICE REPLACEMENT SETTINGS ENTRY trigger=startup key=fb346b59e2b7687a package=" + example_folder
			+ " member=" + example_member + " values=0 identity=")
		&& logged("accessor=RENOVICE_SCRIPT_SETTINGS")
		&& logged("RENOVICE REPLACEMENT SETTINGS COMMIT trigger=startup serial=")
		&& logged(" entries=1 previous_entries=0 contract=REPLACEMENT_SETTINGS_V1"),
		"committed snapshot: ENTRY and COMMIT operational lines");
	const auto first_serial = committed->serial;

	// 2. The example values file: value delivered with its declared stock.
	write_text(settings_path, values_file);
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS (example values file)");
	snapshot = packages::candidate();
	member = find_member(find_package(*snapshot, example_folder), example_member);
	check(member != nullptr && member->staged && member->delivery != nullptr && member->delivery->values.size() == 1
		&& member->delivery->values[0].id == "hijack.payload_health"
		&& member->delivery->values[0].value == 20000.0f && member->delivery->values[0].stock == 10000.0f,
		"example values file: hijack.payload_health = 20000 (stock 10000) delivered");
	const auto prepared_identity = member->delivery->identity;
	// The accessor only ever reads a committed snapshot: prepare alone changes nothing.
	check(replacement_settings::committed()->serial == first_serial
		&& replacement_settings::committed()->find(fixture_key)->delivery->values.empty(),
		"a prepared (uncommitted) F9 is invisible to the accessor");
	packages::commit_prepared_reload();
	replacement_settings::commit(packages::candidate(), "F9");
	committed = replacement_settings::committed();
	check(committed->serial > first_serial && committed->find(fixture_key) != nullptr
		&& committed->find(fixture_key)->delivery->values.size() == 1
		&& committed->find(fixture_key)->delivery->identity == prepared_identity,
		"after the F9 commit the accessor reads the new values (new serial)");

	// 3. use_stock: an empty table (the replacement keeps its compiled values).
	write_text(settings_path, example_values("\"hijack.payload_health\": { \"enabled\": true, \"value\": 20000 }", true));
	check(packages::prepare_reload(), "F9 prepare PASS (use_stock)");
	member = find_member(find_package(*packages::candidate(), example_folder), example_member);
	check(member != nullptr && member->staged && member->delivery != nullptr && member->delivery->values.empty(),
		"use_stock: the replacement loads, its settings table is empty");
	packages::discard_prepared_reload();

	// 4. A disabled or out-of-range value is absent.
	write_text(settings_path, example_values("\"hijack.payload_health\": { \"enabled\": false, \"value\": 20000 }"));
	check(packages::prepare_reload(), "F9 prepare PASS (value switched off)");
	member = find_member(find_package(*packages::candidate(), example_folder), example_member);
	check(member != nullptr && member->delivery != nullptr && member->delivery->values.empty(),
		"a switched-off value is absent");
	packages::discard_prepared_reload();
	write_text(settings_path, example_values("\"hijack.payload_health\": { \"enabled\": true, \"value\": 999999 }"));
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS (value out of range)");
	member = find_member(find_package(*packages::candidate(), example_folder), example_member);
	check(member != nullptr && member->delivery != nullptr && member->delivery->values.empty()
		&& logged("RENOVICE SETTINGS VALUE REJECT trigger=F9 package=" + example_folder
			+ " id=hijack.payload_health reason=outside-min-max scope=value-local value=stock"),
		"an out-of-range value reverts only itself (exact VALUE REJECT line)");
	packages::discard_prepared_reload();

	// 5. Malformed values file: package-local stock (empty table), replacement still loads.
	write_text(settings_path, "{ \"format\": ");
	check(packages::prepare_reload(), "F9 prepare PASS with a malformed values file (never rejects the transaction)");
	member = find_member(find_package(*packages::candidate(), example_folder), example_member);
	check(member != nullptr && member->staged && member->bytes == bytes && member->delivery != nullptr
		&& member->delivery->values.empty(),
		"fail-closed: malformed values file -> replacement loads with an empty table (compiled values)");
	packages::discard_prepared_reload();
	write_text(settings_path, values_file);

	// 6. Invalid declarations: settings capability off, replacement still loads, no entry (accessor -> nil).
	std::string broken = manifest;
	const auto stock_at = broken.find("\"stock\": 10000");
	broken.replace(stock_at, std::string("\"stock\": 10000").size(), "\"stock\": 500");
	write_text(package_dir / "package.json", broken);
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS with invalid declarations");
	package = find_package(*packages::candidate(), example_folder);
	member = find_member(package, example_member);
	check(package != nullptr && package->accepted && !package->declarations && member != nullptr && member->staged
		&& member->bytes == bytes && !member->delivery,
		"fail-closed: invalid declarations -> replacement staged, no delivery");
	check(logged("RENOVICE SETTINGS DECLARATIONS REJECT trigger=F9 package=" + example_folder)
		&& logged("stock-outside-min-max scope=settings-capability-local members=compiled-defaults"),
		"fail-closed: exact DECLARATIONS REJECT line");
	check(replacement_settings::build_snapshot(packages::candidate().get(), 1).find(fixture_key) == nullptr,
		"fail-closed: no entry -> the accessor returns nil and the host never touches the module environment");
	packages::discard_prepared_reload();
	write_text(package_dir / "package.json", manifest);

	// 7. Package disabled: stock module, no entry. Contract R13: a stored
	// member `false` is ignored (the package row owns enablement), so the
	// member is staged and keeps its entry exactly as with no stored state.
	gate::policy["package:hijacksettingsexample"] = false;
	check(packages::prepare_reload(), "F9 prepare PASS (package disabled)");
	package = find_package(*packages::candidate(), example_folder);
	member = find_member(package, example_member);
	check(package != nullptr && !package->accepted && member != nullptr && !member->staged
		&& replacement_settings::build_snapshot(packages::candidate().get(), 1).entries.empty(),
		"package disabled: not staged, no entry");
	packages::discard_prepared_reload();
	gate::policy.clear();
	gate::policy["member:hijacksettingsexample/" + std::string("fb346b59e2b7687a (hijack payload health from settings).lua_b")] = false;
	check(packages::prepare_reload(), "F9 prepare PASS (stored member false)");
	member = find_member(find_package(*packages::candidate(), example_folder), example_member);
	check(member != nullptr && member->staged && member->policy_off_ignored && member->bytes == bytes
		&& replacement_settings::build_snapshot(packages::candidate().get(), 1).find(fixture_key) != nullptr,
		"R13 stored member false: ignored, the replacement is staged and keeps its settings entry");
	check(logged("RENOVICE PACKAGE MEMBER POLICY IGNORED trigger=F9 package=" + example_folder),
		"R13 stored member false: exact POLICY IGNORED line");
	packages::discard_prepared_reload();
	gate::policy.clear();

	// 8. Package without declarations: byte-for-byte as before (no delivery, no settings lines, no entry).
	std::string plain = "{ \"schema\": 1, \"name\": \"Hijack Settings Example\", \"members\": { \""
		+ example_member + "\": { \"label\": \"Hijack (script replacement)\" } }, \"settings\": {} }";
	write_text(package_dir / "package.json", plain);
	gate::log_lines.clear();
	check(packages::prepare_reload(), "F9 prepare PASS (package without declarations)");
	member = find_member(find_package(*packages::candidate(), example_folder), example_member);
	check(member != nullptr && member->staged && member->bytes == bytes && !member->delivery
		&& !logged("RENOVICE SETTINGS")
		&& replacement_settings::build_snapshot(packages::candidate().get(), 1).entries.empty(),
		"regression: a replacement without declarations has no delivery, no settings lines and no entry");
	packages::commit_prepared_reload();
	gate::log_lines.clear();
	replacement_settings::commit(packages::candidate(), "F9");
	check(replacement_settings::committed()->entries.empty()
		&& logged(" entries=0 previous_entries=1 contract=REPLACEMENT_SETTINGS_V1"),
		"removing the last entry is logged once");
	gate::log_lines.clear();
	replacement_settings::commit(packages::candidate(), "F9");
	check(gate::log_lines.empty(), "no entries before and after: the commit writes no line (logs unchanged)");

	// 9. Loose replacement file: never a package member, never an entry.
	std::filesystem::remove_all(gate::root / "Packages", ec);
	std::filesystem::remove(settings_path, ec);
	write_bytes(gate::root / "fb346b59e2b7687a (loose copy).lua_B", bytes);
	check(packages::prepare_reload(), "F9 prepare PASS (loose replacement only)");
	check(replacement_settings::build_snapshot(packages::candidate().get(), 1).entries.empty(),
		"a loose replacement gets no settings (accessor returns nil; compiled values)");
	packages::discard_prepared_reload();
	std::filesystem::remove(gate::root / "fb346b59e2b7687a (loose copy).lua_B", ec);

	// 10. Literal-only replacement (Missions shape) unchanged; mixed member follows the literal gate.
	const std::string literal_member = "fc711ff621a75552 (missions_exact-replacement).lua_B";
	const auto missions_dir = gate::root / "Packages" / "Missions";
	write_bytes(missions_dir / literal_member, bytes);
	const std::string literal_manifest =
		"{ \"schema\": 1, \"members\": { \"" + literal_member + "\": { \"settings\": { \"values\": {"
		" \"void_flood.fractures_per_round.normal\": { \"group\": \"void_flood\", \"label\": \"Fractures per round\","
		" \"type\": \"int\", \"stock\": 3, \"min\": 1, \"max\": 10, \"lane\": \"literal\", \"applies\": \"next_mission\" }"
		"%EXTRA% } } } }, \"settings\": { \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\","
		" \"groups\": [ { \"id\": \"void_flood\", \"label\": \"Void Flood\", \"order\": 20 } ] } }";
	auto manifest_for = [&](std::string_view extra)
	{
		std::string text = literal_manifest;
		text.replace(text.find("%EXTRA%"), 7, extra);
		return text;
	};
	const auto missions_settings = gate::root / "Settings" / "Missions.json";
	const std::string literal_on =
		"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"use_stock\": false,"
		" \"values\": { \"void_flood.fractures_per_round.normal\": { \"enabled\": true, \"value\": 4 }%EXTRA% } }";
	auto values_for = [&](std::string_view extra)
	{
		std::string text = literal_on;
		text.replace(text.find("%EXTRA%"), 7, extra);
		return text;
	};
	write_text(missions_dir / "package.json", manifest_for(""));
	write_text(missions_settings, values_for(""));
	check(packages::prepare_reload(), "F9 prepare PASS (literal-only replacement)");
	member = find_member(find_package(*packages::candidate(), "Missions"), literal_member);
	check(member != nullptr && member->staged && !member->delivery
		&& replacement_settings::build_snapshot(packages::candidate().get(), 1).entries.empty(),
		"literal-only replacement: literal gate unchanged, no delivery, no entry");
	packages::discard_prepared_reload();
	const std::string mixed_value =
		", \"void_flood.round_bonus\": { \"group\": \"void_flood\", \"label\": \"Round bonus\", \"type\": \"float\","
		" \"stock\": 1.5, \"min\": 0, \"max\": 10, \"lane\": \"addon\", \"applies\": \"next_mission\" }";
	write_text(missions_dir / "package.json", manifest_for(mixed_value));
	write_text(missions_settings, values_for(", \"void_flood.round_bonus\": { \"enabled\": true, \"value\": 2.5 }"));
	check(packages::prepare_reload(), "F9 prepare PASS (mixed literal+addon replacement)");
	member = find_member(find_package(*packages::candidate(), "Missions"), literal_member);
	const auto mixed = replacement_settings::build_snapshot(packages::candidate().get(), 1);
	check(member != nullptr && member->staged && member->delivery != nullptr && member->delivery->values.size() == 1
		&& member->delivery->values[0].id == "void_flood.round_bonus" && member->delivery->values[0].value == 2.5f
		&& mixed.find(0xfc711ff621a75552ull) != nullptr,
		"mixed member: staged by the literal gate, only its addon-lane value is readable");
	packages::discard_prepared_reload();
	write_text(missions_settings,
		"{ \"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"use_stock\": false,"
		" \"values\": { \"void_flood.fractures_per_round.normal\": { \"enabled\": false, \"value\": 4 },"
		" \"void_flood.round_bonus\": { \"enabled\": true, \"value\": 2.5 } } }");
	check(packages::prepare_reload(), "F9 prepare PASS (mixed member, literal value off)");
	member = find_member(find_package(*packages::candidate(), "Missions"), literal_member);
	check(member != nullptr && !member->staged
		&& replacement_settings::build_snapshot(packages::candidate().get(), 1).entries.empty(),
		"mixed member with its literal switched off stays stock: not staged, no entry");
	packages::discard_prepared_reload();
}

const settings_ui::Row* find_row(const settings_ui::Page& page, std::string_view setting_or_action)
{
	for (const auto& row : page.rows)
		if (row.setting == setting_or_action || row.action == setting_or_action) return &row;
	return nullptr;
}

// A two-member package: the example replacement (Hijack group) and an addon
// member (another group): two sections on one package page (R7: no member switch).
void nested_pages(const std::filesystem::path& work, const std::filesystem::path& fixture_bytes_path)
{
	using namespace settings_ui;
	std::error_code ec;
	std::filesystem::remove_all(work, ec);
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::create_directories(gate::inject);
	gate::policy.clear();
	const auto bytes = read_bytes(fixture_bytes_path);
	const std::string addon_member = "0123456789abcdef.Extra.target.addon.lua_B";
	const auto package_dir = gate::root / "Packages" / example_folder;
	write_bytes(package_dir / example_member, bytes);
	write_bytes(package_dir / addon_member, {'A', 'D', 'D', 'O', 'N'});
	const std::string manifest =
		"{ \"schema\": 1, \"name\": \"Hijack Settings Example\", \"members\": {"
		" \"" + example_member + "\": { \"label\": \"Hijack (script replacement)\", \"settings\": { \"values\": {"
		"  \"hijack.payload_health\": { \"group\": \"hijack\", \"label\": \"Payload health\", \"unit\": \"HP\", \"type\": \"int\","
		"   \"stock\": 10000, \"min\": 1000, \"max\": 200000, \"scope\": \"Hijack\", \"lane\": \"addon\","
		"   \"applies\": \"next_mission\", \"stock_check\": \"none\" } } } },"
		" \"" + addon_member + "\": { \"label\": \"Extra addon\", \"settings\": { \"values\": {"
		"  \"extra.scale\": { \"group\": \"extra\", \"label\": \"Scale\", \"unit\": \"x\", \"type\": \"float\","
		"   \"stock\": 1, \"min\": 0, \"max\": 10, \"lane\": \"addon\", \"applies\": \"live_next_read\" } } } } },"
		" \"settings\": { \"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\", \"groups\": ["
		"  { \"id\": \"hijack\", \"label\": \"Hijack\", \"order\": 10 }, { \"id\": \"extra\", \"label\": \"Extra\", \"order\": 20 } ] } }";
	write_text(package_dir / "package.json", manifest);
	const auto settings_path = gate::root / "Settings" / (example_folder + ".json");
	write_text(settings_path, example_values("\"hijack.payload_health\": { \"enabled\": true, \"value\": 20000, \"stock\": 10000 }"));
	check(packages::prepare_reload(), "nested: F9 prepare PASS (replacement + addon member)");
	const auto snapshot = packages::candidate();
	const auto* package = find_package(*snapshot, example_folder);
	check(package != nullptr && package->accepted && package->declarations != nullptr, "nested: package accepted with declarations");
	if (package == nullptr || package->declarations == nullptr) return;

	// Same view the host builds (injection.cpp build_script_settings_views).
	PackageView view;
	view.folder = package->folder;
	view.display = package->display;
	view.package_enabled = true;
	view.declarations = package->declarations.get();
	for (const auto& member : package->members)
	{
		view.members.push_back(MemberView{member.filename, member.label, member.state_id, member.enabled,
			member.kind == packages::MemberKind::Replacement});
	}
	std::string error;
	check(packages::read_settings_values(*package, view.state, error) && error.empty(), "nested: values file read");
	const std::vector<PackageView> views{view};

	const auto root = build_root_page(views);
	check(root.rows.size() == 1 && root.rows[0].kind == RowKind::Button
		&& root.rows[0].action == "open:pkg:" + example_folder,
		"nested top page: one package BUTTON opens the package page");
	const auto package_page = build_package_page(view);
	// R7: no member or package switch on any SCRIPT SETTINGS page (the SCRIPTS
	// menu owns enabling); a path-less package lists its values by section.
	check(std::none_of(package_page.rows.begin(), package_page.rows.end(), [](const Row& row)
			{
				return row.kind == RowKind::Checkbox || row.setting.rfind("member:", 0) == 0 || row.setting.rfind("package:", 0) == 0;
			})
		&& package_page.rows.back().action == "resetall:" + example_folder,
		"R7 package page: no member, package or Custom switch; one 'Reset all to defaults' last");
	const auto* value_button = find_row(package_page, "open:val:" + example_folder + "/hijack.payload_health");
	check(value_button != nullptr && value_button->kind == RowKind::Button
		&& value_button->label == "Payload health: 20000 HP" && !value_button->locked,
		"R7 package page: the replacement member's value is one row 'Payload health: 20000 HP' (unlocked, addon lane)");
	const auto value_page = build_value_page(view, "hijack.payload_health");
	check(value_page.rows.size() == 2 && value_page.rows[0].kind == RowKind::InputCount
		&& value_page.rows[0].count == 20000.0 && value_page.rows[0].minimum == 1000.0
		&& value_page.rows[0].maximum == 200000.0 && value_page.rows[0].integer && !value_page.rows[0].locked
		&& value_page.rows[1].label == "Reset to default: 10000 HP",
		"R7 value page: the INPUTCOUNT (20000, 1000..200000, whole numbers, editable) and 'Reset to default: 10000 HP'");

	// Edit in the menu -> values file -> F9 scan -> committed snapshot -> accessor.
	Session session;
	check(settings_ui::stage(session, views, "value:hijacksettingsexample/hijack.payload_health", StagedValue::of_text("999999")) == "outside-min-max",
		"nested edit: an out-of-range value is rejected by the host");
	check(settings_ui::stage(session, views, "value:hijacksettingsexample/hijack.payload_health", StagedValue::of_text("15000")).empty(),
		"nested edit: 15000 accepted by the host re-validation");
	const auto applied = settings_ui::apply(session, views);
	check(applied.packages.size() == 1 && applied.packages[0].folder == example_folder,
		"nested edit: exactly this package's values file is written");
	if (applied.packages.size() != 1) return;
	write_text(settings_path, settings::write_values_file(applied.packages[0].state, applied.packages[0].declarations));
	packages::discard_prepared_reload();
	check(packages::prepare_reload(), "nested edit: F9 prepare PASS after the apply");
	packages::commit_prepared_reload();
	replacement_settings::commit(packages::candidate(), "F9");
	const auto committed = replacement_settings::committed();
	const auto* entry = committed->find(fixture_key);
	check(entry != nullptr && entry->delivery->values.size() == 1 && entry->delivery->values[0].id == "hijack.payload_health"
		&& entry->delivery->values[0].value == 15000.0f && entry->delivery->values[0].stock == 10000.0f
		&& committed->find(0x0123456789abcdefull) == nullptr,
		"nested edit: after the apply's F9 the accessor reads 15000 (the addon member is not a replacement entry)");
}

// Gate model of the accessor's native hot path (a call whose caller already
// holds the current generation's table): committed-snapshot load, key lookup
// among 256 replacement entries, serial comparison. The VM part (two stack
// slots) is not modelled. Reported, with a loose sanity bound only.
void hot_path_benchmark()
{
	packages::Snapshot source;
	for (std::uint64_t i = 1; i <= 256; ++i)
	{
		packages::Package package;
		package.folder = "P" + std::to_string(i);
		package.accepted = true;
		packages::Member member;
		member.filename = "m.lua_B";
		member.kind = packages::MemberKind::Replacement;
		member.key = i * 0x9E3779B97F4A7C15ull;
		member.staged = true;
		auto delivery = std::make_shared<settings::MemberDelivery>();
		for (int v = 0; v != 64; ++v)
			delivery->values.push_back(settings::DeliveredValue{"value." + std::to_string(v), 1.0f, 1.0f});
		member.delivery = delivery;
		package.members.push_back(member);
		source.packages.push_back(package);
	}
	auto shared = std::make_shared<const packages::Snapshot>(source);
	replacement_settings::commit(shared, "benchmark");
	const auto current = replacement_settings::committed();
	const std::uint64_t key = 200 * 0x9E3779B97F4A7C15ull;
	auto plan = replacement_settings::plan_call(key, replacement_settings::ArgumentKind::Number, false, 0,
		replacement_settings::serial_number(current->serial), replacement_settings::ArgumentKind::Absent, 0);
	constexpr int iterations = 2000000;
	std::size_t hits = 0;
	const auto start = std::chrono::steady_clock::now();
	for (int i = 0; i != iterations; ++i)
	{
		const auto snapshot = replacement_settings::committed();
		const auto* entry = snapshot->find(key);
		hits += entry != nullptr && replacement_settings::caller_is_current(plan, snapshot->serial);
	}
	const auto elapsed = std::chrono::duration<double, std::nano>(std::chrono::steady_clock::now() - start).count();
	const double per_call = elapsed / iterations;
	std::printf("INFO\thot path (cached caller, 256 entries x 64 values): %.1f ns per call over %d calls\n", per_call, iterations);
	check(hits == static_cast<std::size_t>(iterations) && per_call < 2000.0,
		"hot path model: cached calls never build a table and stay far below 2 us per call");
	gate::log_lines.clear();
	replacement_settings::commit(nullptr, "benchmark");
}

std::filesystem::path long_path(const std::filesystem::path& path)
{
	const std::wstring& native = path.native();
	if (native.rfind(LR"(\\?\)", 0) == 0) return path;
	const std::wstring absolute = std::filesystem::absolute(path).native();
	if (absolute.rfind(LR"(\\)", 0) == 0) return std::filesystem::path(LR"(\\?\UNC\)" + absolute.substr(2));
	return std::filesystem::path(LR"(\\?\)" + absolute);
}
}

int main(int argc, char** argv)
{
	if (argc != 6)
	{
		std::cerr << "usage: verify_replacement_settings <work dir> <fixture dir> <fixture.lua_B> <compiled hash hex> <namebase.tsv>\n";
		return 2;
	}
	pure_rules();
	name_hash(argv[4], long_path(argv[5]));
	end_to_end(long_path(argv[1]), long_path(argv[2]), long_path(argv[3]));
	nested_pages(long_path(argv[1]) / "nested", long_path(argv[3]));
	hot_path_benchmark();
	std::cout << (pass ? "REPLACEMENT SETTINGS PASS" : "REPLACEMENT SETTINGS FAIL") << '\n';
	return pass ? 0 : 1;
}
