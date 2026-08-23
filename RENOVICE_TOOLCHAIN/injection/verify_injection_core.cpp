#include <filesystem>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

#include "../../renovice/injection_core.hpp"
#include "../../renovice/addon_transaction.hpp"

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
	check(classify_script("damage_hook.addon.lua_B") == ScriptKind::ManagedAddon,
		"managed addon classification");
	check(classify_script("damage_hook.ADDON.LUA_b") == ScriptKind::ManagedAddon,
		"managed addon marker is case-insensitive");
	check(classify_script("state.persist.lua_B") == ScriptKind::ExperimentalPersistent,
		"persistent experiment classification");
	check(classify_script("state.PERSIST.lua_B") == ScriptKind::ExperimentalPersistent,
		"persistent rejection marker is case-insensitive");
	check(classify_script("loop.spawn.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn experiment classification");
	check(classify_script("loop.SPAWN.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn rejection marker is case-insensitive");
	check(classify_script("both.persist.spawn.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn takes precedence like deployed runner");
	check(is_lua_bytecode_extension(".lua_B") && is_lua_bytecode_extension(".LUA_b")
		&& !is_lua_bytecode_extension(".lua"), "case-insensitive bytecode extension");
	check(valid_chunk_size(1) && valid_chunk_size((1ull << 20) - 1)
		&& !valid_chunk_size(0) && !valid_chunk_size(1ull << 20), "chunk size boundaries");
	check(valid_execution_boundary(true, true, true),
		"live boundary accepted when it shares the captured manager VM");
	check(!valid_execution_boundary(true, false, true)
		&& !valid_execution_boundary(false, true, true)
		&& !valid_execution_boundary(true, true, false),
		"missing or cross-VM execution boundary rejected");

	struct Record { int id; };
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged{{2}, {3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::Committed && active.size() == 2
			&& active[0].id == 2 && order == "C1A2A3R1",
			"managed generation cleanup activate release order");
	}
	{
		std::vector<Record> active{{1}, {2}};
		std::vector<Record> staged{{3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return record.id != 2; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::CleanupRejected && active.size() == 2
			&& staged.empty() && order == "C1C2A1A2R3",
			"cleanup rejection reactivates old generation and releases staged roots");
	}
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged{{2}, {3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return record.id != 3; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::ActivationRejected && active.size() == 1
			&& staged.empty() && order == "C1A2A3C2C3A1R2R3",
			"activation rejection cleans new behavior reactivates old and releases staged roots");
	}
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged;
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::Committed && active.empty()
			&& staged.empty() && order == "C1R1",
			"deleting every addon cleans and releases the old generation");
	}
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged{{2}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return false; });
		check(result == TransactionResult::ReleaseRejected && active.size() == 1
			&& active[0].id == 2 && staged.empty() && order == "C1A2R1",
			"old-root release rejection reports fatal after new generation takes ownership");
	}
	{
		std::vector<Record> active{{1}, {2}};
		std::vector<Record> staged{{3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return record.id != 2; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return record.id != 1; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::RollbackFailed && active.size() == 2
			&& staged.empty() && order == "C1C2A1A2R3",
			"failed old-generation reactivation escalates to rollback fatal");
	}

	if (argc == 2)
	{
		std::error_code ec;
		std::size_t supported_count = 0;
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
			const auto kind = classify_script(path.filename().string());
			const bool supported = kind == ScriptKind::Ordinary || kind == ScriptKind::ManagedAddon;
			check(valid_size && supported && !ec, path.filename().string());
			supported_count += supported ? 1 : 0;
			unsupported += supported ? 0 : 1;
			if (ec) break;
		}
		check(!ec, "Inject directory readable");
		check(unsupported == 0, "no unsupported experimental modules staged");
		std::cout << "INFO\tsupported_chunks=" << supported_count
			<< " unsupported_chunks=" << unsupported << '\n';
	}

	std::cout << (pass ? "INJECTION CORE PASS" : "INJECTION CORE FAIL") << '\n';
	return pass ? 0 : 1;
}
