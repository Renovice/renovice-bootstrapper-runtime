#include <cstdint>
#include <filesystem>
#include <iostream>
#include <set>
#include <string_view>

#include "../../renovice/replacements_core.hpp"

int main(int argc, char** argv)
{
	using namespace renovice::replacements;
	bool pass = true;
	const auto check = [&](bool result, const char* name)
	{
		std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
		pass &= result;
	};

	check(body_key("abc") == 0xe16801510db89efdull, "deployed non-standard FNV basis");
	check(body_key("") == deployed_body_key_basis, "empty body key basis");

	std::uint64_t key = 0;
	check(parse_filename_key("08faf07b504d058f", key) && key == 0x08faf07b504d058full,
		"plain sixteen-hex filename");
	check(parse_filename_key("08faf07b504d058f (Mallet edit)", key) && key == 0x08faf07b504d058full,
		"annotated deployed filename");
	check(parse_filename_key("A8FAF07B504D058F note", key) && key == 0xa8faf07b504d058full,
		"uppercase filename key");
	check(!parse_filename_key("08faf07b504d058", key), "short key rejected");
	check(!parse_filename_key("08faf07b504d058z note", key), "non-hex key rejected");
	check(!parse_filename_key("0000000000000000", key), "zero key rejected");
	check(fallback_tunable_name("2026.07.11.15.28")
		== "renovice_undump_rva_2026_07_11_15_28", "exact-build fallback key");

	check(select_hot_reload_payload(false, true, true) == HotReloadPayload::None,
		"unchanged replacement is not reexecuted");
	check(select_hot_reload_payload(true, true, true) == HotReloadPayload::Replacement,
		"changed replacement selects new bytecode");
	check(select_hot_reload_payload(true, false, true) == HotReloadPayload::Original,
		"removed replacement restores captured stock bytecode");
	check(select_hot_reload_payload(true, false, false) == HotReloadPayload::None,
		"removed replacement without captured stock fails closed");
	const int vm_a = 1;
	const int vm_b = 2;
	check(compatible_hot_reload_vm(&vm_a, &vm_a), "same DE VM accepts hot refresh");
	check(!compatible_hot_reload_vm(&vm_a, &vm_b), "cross-VM hot refresh rejected");
	check(!compatible_hot_reload_vm(nullptr, nullptr), "null VM identity rejected");

	if (argc == 2)
	{
		std::error_code ec;
		std::set<std::uint64_t> keys;
		std::size_t files = 0;
		for (std::filesystem::directory_iterator it(argv[1], ec), end; !ec && it != end; it.increment(ec))
		{
			if (!it->is_regular_file(ec))
			{
				if (ec) break;
				continue;
			}
			const auto path = it->path();
			if (path.extension().string() != ".lua_B")
			{
				continue;
			}
			std::uint64_t file_key = 0;
			const bool valid = parse_filename_key(path.stem().string(), file_key)
				&& std::filesystem::file_size(path, ec) > 0
				&& keys.emplace(file_key).second;
			check(valid && !ec, path.filename().string().c_str());
			++files;
			if (ec) break;
		}
		check(!ec, "active replacement directory readable");
		check(files != 0, "active replacement set is non-empty");
		std::cout << "INFO\tactive replacement files=" << files << " unique_keys=" << keys.size() << '\n';
	}

	std::cout << (pass ? "REPLACEMENT CORE PASS" : "REPLACEMENT CORE FAIL") << '\n';
	return pass ? 0 : 1;
}
