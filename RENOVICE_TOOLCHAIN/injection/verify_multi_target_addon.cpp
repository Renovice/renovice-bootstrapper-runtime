// Real-bytecode gate for the multi-target target-addon contract (2026-09-29).
// The fixture is compiled by the DE Luau toolchain from
// fixtures/MultiTargetFixture.targets.addon.luau; this checker runs the exact
// loader discovery code from renovice/injection_core.hpp against those bytes.
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <string_view>
#include <vector>

#include "../../renovice/injection_core.hpp"
#include "../../renovice/script_control_core.hpp"

int main(int argc, char** argv)
{
	using namespace renovice;
	bool pass = true;
	const auto check = [&](bool result, const char* name)
	{
		std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
		pass &= result;
	};
	if (argc != 2)
	{
		std::cerr << "usage: verify_multi_target_addon <fixture.lua_B>\n";
		return 2;
	}
	std::ifstream input(argv[1], std::ios::binary);
	const std::vector<unsigned char> bytes(
		(std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
	check(injection::valid_chunk_size(bytes.size()), "fixture bytecode size admissible");
	std::vector<std::uint64_t> keys;
	const char* error = injection::discover_multi_target_keys(
		bytes.data(), bytes.size(), keys);
	check(error == nullptr, "compiled DE fixture exposes declared keys in its string pool");
	check(keys == std::vector<std::uint64_t>{
			0x6fa60841c9e0f207ull, 0xcaec63d8e739b693ull, 0xf10a043e7f825db2ull},
		"exactly the three targets[] keys are declared; uppercase note text is not");
	const std::string_view name = "MultiTargetFixture.targets.addon.lua_B";
	check(injection::is_multi_target_addon(name)
		&& injection::multi_target_filename_error(name) == nullptr
		&& injection::classify_script(name) == injection::ScriptKind::TargetManagedAddon,
		"fixture filename is an admissible multi-target addon");
	check(script_control::menu_display_name(script_control::Kind::TargetAddon, name)
			== "[ADDON] Multi Target Fixture"
		&& script_control::stable_id(script_control::Kind::TargetAddon, name)
			== "target-addon:multitargetfixture.targets.addon.lua_b",
		"one Scripts row and one policy id for all declared targets");
	std::cout << "INFO\tfixture_bytes=" << bytes.size()
		<< " declared_targets=" << keys.size() << '\n';
	std::cout << (pass ? "MULTI-TARGET ADDON PASS" : "MULTI-TARGET ADDON FAIL") << '\n';
	return pass ? 0 : 1;
}
