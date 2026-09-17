#include <algorithm>
#include <cstdint>
#include <filesystem>
#include <iostream>
#include <set>
#include <string_view>
#include <vector>

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
	check(should_capture_module_load(true, false, false, false),
		"available disabled replacement captures its stock module");
	check(should_capture_module_load(false, true, false, false),
		"active replacement module is captured");
	check(should_capture_module_load(false, false, true, false),
		"previously loaded module remains tracked");
	check(should_capture_module_load(false, false, false, true),
		"unresolved refresh target is captured on its next natural load");
	check(!should_capture_module_load(false, false, false, false),
		"unrelated module without a replacement file is skipped");
	const int vm_a = 1;
	const int vm_b = 2;
	check(compatible_hot_reload_vm(&vm_a, &vm_a), "same DE VM accepts hot refresh");
	check(!compatible_hot_reload_vm(&vm_a, &vm_b), "cross-VM hot refresh rejected");
	check(!compatible_hot_reload_vm(nullptr, nullptr), "null VM identity rejected");
	check(hot_reload_complete(true, 0), "all executed contexts report complete");
	check(!hot_reload_complete(true, 1), "deferred VM context reports incomplete");
	check(!hot_reload_complete(false, 0), "failed execution reports incomplete");

	int manager_a = 3;
	int manager_b = 4;
	int descriptor_hud = 5;
	int descriptor_arsenal = 6;
	PendingRefreshIdentity hud{0x11, &manager_a, &descriptor_hud, &vm_a, 100};
	PendingRefreshIdentity arsenal{0x11, &manager_b, &descriptor_arsenal, &vm_b, 100};
	PendingRefreshIdentity arsenal_new_generation{0x11, &manager_b, &descriptor_arsenal, &vm_b, 200};
	PendingRefreshIdentity other_module{0x12, &manager_b, &descriptor_arsenal, &vm_b, 100};
	check(pending_refresh_ready(hud, &vm_a, 100),
		"HUD refresh is ready only at its VM and owner-thread boundary");
	check(!pending_refresh_ready(arsenal, &vm_a, 100),
		"Arsenal refresh remains queued at the HUD VM boundary");
	check(pending_refresh_ready(arsenal, &vm_b, 100),
		"Arsenal refresh becomes ready at its own VM loader boundary");
	check(!pending_refresh_ready(arsenal, &vm_b, 200),
		"cross-thread Arsenal execution is rejected");
	check(same_pending_refresh(arsenal, arsenal_new_generation),
		"new generation supersedes the same native module descriptor even if delivery thread metadata changes");
	check(!same_pending_refresh(arsenal, other_module),
		"different module keys remain independent pending jobs");
	check(!same_pending_refresh(
		PendingRefreshIdentity{0x11, nullptr, &descriptor_arsenal, &vm_b, 100}, arsenal),
		"null manager cannot alias a pending job");
	check(!same_pending_refresh(
		PendingRefreshIdentity{0x11, &manager_b, nullptr, &vm_b, 100}, arsenal),
		"null original descriptor cannot alias a pending job");
	check(natural_replacement_load_satisfies_pending(arsenal, arsenal, true),
		"positive replacement-undump evidence satisfies the exact pending job");
	check(!natural_replacement_load_satisfies_pending(arsenal, arsenal, false),
		"cached loader lookup cannot falsely satisfy a pending refresh");
	check(!natural_replacement_load_satisfies_pending(
		arsenal,
		PendingRefreshIdentity{0x11, &manager_b, &descriptor_arsenal, &vm_b, 200},
		true),
		"natural replacement load on the wrong thread cannot satisfy pending work");
	std::vector<PendingRefreshIdentity> pending{hud, arsenal};
	const auto deliver = [&](const void* vm, std::uint32_t thread)
	{
		std::size_t delivered = 0;
		for (auto current = pending.begin(); current != pending.end();)
		{
			if (!pending_refresh_ready(*current, vm, thread))
			{
				++current;
				continue;
			}
			current = pending.erase(current);
			++delivered;
		}
		return delivered;
	};
	check(deliver(&vm_a, 100) == 1 && pending.size() == 1
		&& same_pending_refresh(pending.front(), arsenal),
		"F9 HUD boundary executes HUD work and preserves Arsenal work");
	check(deliver(&vm_b, 100) == 1 && pending.empty(),
		"later Arsenal loader boundary drains the remaining VM-local work");
	pending.push_back(arsenal);
	const auto superseded = std::find_if(pending.begin(), pending.end(),
		[&](const PendingRefreshIdentity& current)
		{
			return same_pending_refresh(current, arsenal_new_generation);
		});
	if (superseded != pending.end()) *superseded = arsenal_new_generation;
	check(pending.size() == 1 && pending.front().owner_thread == 200,
		"second F9 generation replaces rather than duplicates deferred Arsenal work");

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
