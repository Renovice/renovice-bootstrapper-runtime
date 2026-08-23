#include <filesystem>
#include <iostream>
#include <string>
#include <string_view>

#include "../../renovice/injection_core.hpp"

int main(int argc, char** argv)
{
	using namespace renovice::injection;
	bool pass = true;
	const auto check = [&](bool result, const std::string& name)
	{
		std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
		pass &= result;
	};

	check(classify_script("damage_hook.lua_B") == ScriptKind::Ordinary,
		"ordinary one-shot classification");
	check(classify_script("state.persist.lua_B") == ScriptKind::ExperimentalPersistent,
		"persistent experiment classification");
	check(classify_script("loop.spawn.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn experiment classification");
	check(classify_script("both.persist.spawn.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn takes precedence like deployed runner");
	check(is_lua_bytecode_extension(".lua_B") && is_lua_bytecode_extension(".LUA_b")
		&& !is_lua_bytecode_extension(".lua"), "case-insensitive bytecode extension");
	check(valid_chunk_size(1) && valid_chunk_size((1ull << 20) - 1)
		&& !valid_chunk_size(0) && !valid_chunk_size(1ull << 20), "chunk size boundaries");

	if (argc == 2)
	{
		std::error_code ec;
		std::size_t ordinary = 0;
		std::size_t unsupported = 0;
		for (std::filesystem::directory_iterator it(argv[1], ec), end; !ec && it != end; it.increment(ec))
		{
			if (!it->is_regular_file(ec))
			{
				if (ec) break;
				continue;
			}
			const auto path = it->path();
			if (!is_lua_bytecode_extension(path.extension().string())) continue;
			const bool valid_size = valid_chunk_size(std::filesystem::file_size(path, ec));
			const bool supported = classify_script(path.filename().string()) == ScriptKind::Ordinary;
			check(valid_size && supported && !ec, path.filename().string());
			ordinary += supported ? 1 : 0;
			unsupported += supported ? 0 : 1;
			if (ec) break;
		}
		check(!ec, "Inject directory readable");
		check(unsupported == 0, "no unsupported experimental modules staged");
		std::cout << "INFO\tordinary_chunks=" << ordinary
			<< " unsupported_chunks=" << unsupported << '\n';
	}

	std::cout << (pass ? "INJECTION CORE PASS" : "INJECTION CORE FAIL") << '\n';
	return pass ? 0 : 1;
}
