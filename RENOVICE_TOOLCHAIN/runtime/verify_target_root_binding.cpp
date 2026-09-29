// Real-module fixture for generic target-root instance binding and exact
// prototype attribution (2026-09-29). Reads current 44.0.2 stock modules from
// the shared corpus (read-only) and drives the same core selection code the
// runtime uses. Addresses are synthetic; module keys and prototype counts are
// taken from the real bytecode.
#include <cstdint>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <string_view>
#include <vector>

#include "../../renovice/injection_core.hpp"
#include "../../renovice/de_proto_graph_u43.hpp"

namespace
{
bool read_varint(const std::vector<unsigned char>& b, std::size_t& o, std::uint64_t& v)
{
	return renovice::injection::read_bytecode_varint(b.data(), b.size(), o, v);
}

// DE `09 03` container: string pool, name-table flag, prototype count.
bool prototype_count(const std::vector<unsigned char>& b, std::uint64_t& count)
{
	if (b.size() < 3 || b[0] != 0x09 || b[1] != 0x03) return false;
	std::size_t o = 2;
	std::uint64_t strings = 0;
	if (!read_varint(b, o, strings)) return false;
	for (std::uint64_t i = 0; i != strings; ++i)
	{
		std::uint64_t length = 0;
		if (!read_varint(b, o, length) || length > b.size() - o) return false;
		o += static_cast<std::size_t>(length);
	}
	if (o >= b.size()) return false;
	if (b[o++] != 0)
	{
		for (;;)
		{
			std::uint64_t ignored = 0;
			if (!read_varint(b, o, ignored) || o >= b.size()) return false;
			if (b[o++] == 0) break;
		}
	}
	return read_varint(b, o, count);
}

struct Identity
{
	std::uint64_t target_key = 0;
	void* global_state = nullptr;
	void* environment = nullptr;
	void* root_proto = nullptr;
	std::vector<renovice::injection::TargetProtoRecord> prototypes;
	bool runtime_root = false;
};

Identity make_identity(std::uint64_t key, void* vm, void* env,
	std::uintptr_t base, std::int32_t count)
{
	// Luau places the main prototype last; parents are otherwise irrelevant to
	// attribution, which only requires the recorded root to have no parent.
	Identity identity;
	identity.target_key = key;
	identity.global_state = vm;
	identity.environment = env;
	const auto root_id = count - 1;
	identity.root_proto = reinterpret_cast<void*>(base + static_cast<std::uintptr_t>(root_id) * 0x100);
	for (std::int32_t id = 0; id != count; ++id)
	{
		identity.prototypes.push_back({base + static_cast<std::uintptr_t>(id) * 0x100,
			id == root_id ? 0 : reinterpret_cast<std::uintptr_t>(identity.root_proto),
			0x40000000 + static_cast<std::uintptr_t>(id) * 0x40, 8, id});
	}
	return identity;
}
}

int main(int argc, char** argv)
{
	using namespace renovice::injection;
	bool pass = true;
	const auto check = [&](bool result, const std::string& name)
	{
		std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
		pass &= result;
	};
	if (argc != 3)
	{
		std::cerr << "usage: verify_target_root_binding <SurvivalMission.lua_B> <unrelated.lua_B>\n";
		return 2;
	}
	const auto load = [](const char* path)
	{
		std::ifstream input(path, std::ios::binary);
		return std::vector<unsigned char>(
			(std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
	};
	const auto survival = load(argv[1]);
	const auto unrelated = load(argv[2]);
	const auto survival_key = renovice::replacements::body_key(std::string_view(
		reinterpret_cast<const char*>(survival.data()), survival.size()));
	const auto unrelated_key = renovice::replacements::body_key(std::string_view(
		reinterpret_cast<const char*>(unrelated.data()), unrelated.size()));
	std::uint64_t survival_count = 0;
	std::uint64_t unrelated_count = 0;
	check(survival_key == 0xf10a043e7f825db2ull,
		"fixture is the current 44.0.2 SurvivalMission body f10a043e7f825db2");
	check(unrelated_key != 0 && unrelated_key != survival_key,
		"second fixture is an unrelated module body");
	check(prototype_count(survival, survival_count) && survival_count > 69
		&& prototype_count(unrelated, unrelated_count) && unrelated_count > 1,
		"prototype counts parsed from the real DE containers");

	auto* const vm = reinterpret_cast<void*>(0x10000);
	auto* const load_env = reinterpret_cast<void*>(0x20000);
	auto* const runtime_env = reinterpret_cast<void*>(0x30000);
	std::vector<Identity> identities{
		make_identity(survival_key, vm, load_env, 0x1000000, static_cast<std::int32_t>(survival_count)),
		make_identity(unrelated_key, vm, load_env, 0x8000000, static_cast<std::int32_t>(unrelated_count))};

	// Live run 2026-09-29: SurvivalMission's addon bound at load, then 8 root
	// instances each forced clean/load/activate. A bound module is not watched.
	check(!target_root_return_watch_required(true, true, false),
		"bound SurvivalMission addon: later root instances are not rebound");
	// Root instance of an UNBOUND module: the loader env differs from the env
	// the root ran in, so its one root-return retry rebinds there.
	check(target_root_return_watch_required(true, false, false)
		&& record_target_root_return(identities, survival_key, vm,
			identities[0].root_proto, runtime_env) == TargetRootReturnAction::rebind
		&& identities.back().runtime_root && identities.back().environment == runtime_env,
		"SurvivalMission root return in its runtime environment requests one rebind");
	check(record_target_root_return(identities, unrelated_key, vm,
			identities[1].root_proto, runtime_env) == TargetRootReturnAction::rebind,
		"unrelated module root return uses the same generic rule");

	const auto live = [](const TargetProtoRecord&) { return true; };
	bool all = true;
	for (const std::int32_t id : {31, 33, 55, 58, 60, 61, 62, 67, 68, 69})
	{
		const auto owner = select_target_prototype_owner(identities, vm,
			reinterpret_cast<void*>(0x40000),
			0x1000000 + static_cast<std::uintptr_t>(id) * 0x100, live);
		all = all && owner.exact && !owner.ambiguous
			&& owner.target_key == survival_key && owner.bytecode_id == id;
	}
	check(all, "luaCalls.before prototypes 31/33/55/58/60/61/62/67/68/69 attribute to SurvivalMission from any root instance");
	const auto other = select_target_prototype_owner(identities, vm, runtime_env,
		0x8000000 + 0x100, live);
	check(other.exact && other.strict_environment && other.target_key == unrelated_key
		&& other.bytecode_id == 1,
		"unrelated module closure in the bound runtime environment is a strict match");
	check(!select_target_prototype_owner(identities, reinterpret_cast<void*>(0x50000),
			runtime_env, 0x1000000 + 61 * 0x100, live).exact,
		"another VM never matches");
	std::cout << "INFO\tsurvival_protos=" << survival_count
		<< " unrelated_key=" << std::hex << unrelated_key << std::dec
		<< " unrelated_protos=" << unrelated_count << '\n';
	std::cout << (pass ? "TARGET ROOT FIXTURE PASS" : "TARGET ROOT FIXTURE FAIL") << '\n';
	return pass ? 0 : 1;
}
