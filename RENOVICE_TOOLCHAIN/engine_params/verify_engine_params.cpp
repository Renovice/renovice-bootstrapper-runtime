// Deterministic gate for ENGINE_PARAM_OVERRIDE (contract R16, 2026-10-01).
//
// Built with MSVC /W4 /WX together with the exact renovice/packages.cpp,
// live_literals.cpp and engine_params.cpp (RENOVICE_PACKAGES_OFFLINE_GATE; stub
// config and policy providers below) by verify_engine_params.ps1. Offline only.
//
//   A. Pure rules (engine_params_core.hpp): name hash, override arithmetic,
//      recipe parser and validation, plan resolution, delivery withholding,
//      plan snapshot, identity records.
//   B. The hook decision on a byte-exact model of the writer's frame: the
//      production classify / module_of / apply_pushed around a model of the
//      registered stock push, in the detour's order. Every path calls the stock
//      push exactly once. Includes the engine re-write order (apply, entry,
//      re-apply x3) for every R16 row against the R10 entry-write baseline.
//   C. The package scan end to end (production packages.cpp + engine_params.cpp)
//      on a temporary CustomScripts tree: not installed, installed, F9
//      prepare/discard/commit, broken recipe, wrong hash, package conflict.
//   D. The registered byte ranges against every given executable whose digest is
//      registered (the client and the native-update reference images), mapped
//      like the loader maps it (read-only; skipped when no image is given; an
//      unregistered image installs nothing and is reported, not failed).
//
// Usage: verify_engine_params <work dir> <fixture dir> <exe path|-> <exe sha256|-> [<exe> <sha256>]...
#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <map>
#include <memory>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

#include "../../renovice/config.hpp"
#include "../../renovice/engine_params.hpp"
#include "../../renovice/packages.hpp"
#include "../../renovice/script_control.hpp"

// ---- stub providers for the offline build ------------------------------------
namespace gate
{
std::filesystem::path root;
std::filesystem::path inject;
std::vector<std::string> log_lines;
std::map<std::string, bool> policy;
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

namespace renovice::engine_params
{
void gate_set_installed(const BuildRegistration* build) noexcept;
}

namespace
{
using namespace renovice;
namespace ep = renovice::engine_params;
int failures = 0;
int checks = 0;

void check(bool result, const std::string& name)
{
	++checks;
	std::cout << (result ? "PASS" : "FAIL") << '\t' << name << std::endl;
	if (!result) ++failures;
}

std::string read_text(const std::filesystem::path& path)
{
	std::ifstream input(path, std::ios::binary);
	return std::string((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
}

void write_text(const std::filesystem::path& path, std::string_view text)
{
	std::filesystem::create_directories(path.parent_path());
	std::ofstream output(path, std::ios::binary | std::ios::trunc);
	output.write(text.data(), static_cast<std::streamsize>(text.size()));
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

bool starts(const std::string& text, std::string_view prefix) { return text.rfind(prefix, 0) == 0; }

std::string replace_once(std::string text, std::string_view from, std::string_view to)
{
	const auto at = text.find(from);
	if (at != std::string::npos) text.replace(at, from.size(), to);
	return text;
}

const ep::BuildRegistration& build_44_0_2() { return ep::registered_builds[0]; }
constexpr std::uint32_t seed = 0x768e5ed0u;

// =============================================================================
// A. Pure rules
// =============================================================================
void pure_rules(const std::string& recipe_text, const settings::Declarations& declarations)
{
	const std::pair<const char*, std::uint32_t> hashes[] = {
		{"minWavesToComplete", 0x69d6d911u}, {"scoreGoal", 0x3a44eae1u}, {"metersPerEnemy", 0xbaa888a8u},
		{"roundEndTimer", 0xb68a06b6u}, {"scoreRatePerSecond", 0x5241ca6cu},
		{"spaceBattleKillCountMultiplier", 0xe34f013bu}, {"minorKillGoals", 0x288044d3u}, {"minorKillGoalsMax", 0xe290a5e6u}};
	bool all = true;
	for (const auto& [name, expected] : hashes) all = all && ep::name_hash(name, seed) == expected;
	check(all, "A1 name hash = the U44 rule (seed 768e5ed0, FNV-1a, not, rol 17) for 8 registry parameters");
	check(build_44_0_2().name_hash_seed == seed, "A1 the 44.0.2 registration carries seed 768e5ed0 (also byte-checked in the image)");

	float out = 0.0f;
	check(ep::override_number(ep::Mode::Scale, 1450.0f, 0.5f, out) && out == 725.0f, "A2 scale: 1450 x 0.5 = 725");
	check(ep::override_number(ep::Mode::Scale, 1450.0f, 1.0f, out) && out == 1450.0f, "A2 scale x1 keeps the stock number");
	check(ep::override_number(ep::Mode::ScaleInverse, 12.5f, 0.1f, out) && std::fabs(out - 125.0f) < 1e-3f,
		"A2 scale_inverse: metersPerEnemy 12.5 / 0.1 = 125 (one tenth of the kills)");
	check(ep::override_number(ep::Mode::Absolute, 0.5f, 0.8f, out) && out == 0.8f, "A2 absolute: the value replaces any level number");
	const float lows[] = {20, 35, 55, 85, 110};
	const float halved[] = {10, 18, 28, 43, 55};
	bool counts = true;
	for (std::size_t i = 0; i != 5; ++i) counts = counts && ep::override_number(ep::Mode::ScaleCount, lows[i], 0.5f, out) && out == halved[i];
	check(counts, "A2 scale_count x0.5: {20,35,55,85,110} -> {10,18,28,43,55} (n x v + 0.5, floored; R11 rule)");
	check(ep::override_number(ep::Mode::ScaleCount, 0.5f, 3.0f, out) && out == 0.5f, "A2 scale_count keeps a number below 1");
	check(ep::override_number(ep::Mode::ScaleCount, 20.0f, 0.01f, out) && out == 1.0f, "A2 scale_count result is at least 1");
	// The addon's R10/R11 Lua arithmetic on the same float32 inputs.
	bool same = true;
	for (const float n : {1.0f, 7.0f, 20.0f, 35.0f, 110.0f, 130.0f})
		for (const float v : {0.1f, 0.25f, 0.5f, 1.5f, 2.0f, 10.0f})
		{
			float r = n * v + 0.5f;
			r = r - std::fmod(r, 1.0f);
			if (r < 1.0f) r = 1.0f;
			same = same && ep::override_number(ep::Mode::ScaleCount, n, v, out) && out == r;
			same = same && ep::override_number(ep::Mode::Scale, n, v, out) && out == n * v;
			same = same && ep::override_number(ep::Mode::ScaleInverse, n, v, out) && out == n / v;
		}
	check(same, "A2 equals the generated addon arithmetic (scriptParameter / scaledCount) for 36 float32 pairs");
	check(!ep::override_number(ep::Mode::Scale, NAN, 2.0f, out) && !ep::override_number(ep::Mode::Scale, 2.0f, INFINITY, out)
			&& !ep::override_number(ep::Mode::ScaleInverse, 2.0f, 0.0f, out)
			&& !ep::override_number(ep::Mode::Scale, 3e38f, 1e3f, out),
		"A2 non-finite input, inverse of 0 and an overflowing result leave the stock number");

	ep::Recipe recipe;
	check(ep::parse_recipe(recipe_text, "package:missions", recipe).empty() && recipe.overrides.size() == 7
			&& recipe.value_ids().size() == 6 && recipe.modules().size() == 3 && recipe.member == "Missions.targets.addon.lua_B",
		"A3 the generated engine_params.json parses: 7 overrides, 6 values, 3 modules, member Missions.targets.addon.lua_B");
	check(ep::validate_recipe(recipe, declarations, seed).empty(), "A3 it validates against the package's declarations and the 44.0.2 seed");
	const std::pair<std::string, std::string> negatives[] = {
		{replace_once(recipe_text, "RENOVICE_ENGINE_PARAMS_V1", "RENOVICE_ENGINE_PARAMS_V2"), "recipe-format-not-RENOVICE_ENGINE_PARAMS_V1"},
		{replace_once(recipe_text, "\"format\"", "\"extra\": 1, \"format\""), "recipe-unknown-field=extra"},
		{replace_once(recipe_text, "package:missions", "package:other"), "recipe-package-mismatch"},
		{replace_once(recipe_text, "\"mode\": \"scale_count\"", "\"mode\": \"double\""), "recipe-override-mode-invalid"},
		{replace_once(recipe_text, "0a6394a10884c38a", "0A6394A10884C38A"), "recipe-override-module-invalid"},
		{replace_once(recipe_text, "288044d3", "288044d"), "recipe-override-hash-invalid"},
		{replace_once(recipe_text, "\"parameter\": \"minorKillGoals\"", "\"parameter\": \"1minor\""), "recipe-override-parameter-invalid"},
		{replace_once(recipe_text, "\"hash\": \"e290a5e6\"", "\"hash\": \"288044d3\""), "recipe-override-duplicate"},
		{replace_once(recipe_text, "\"mode\": \"absolute\"", "\"mode\": \"absolute\", \"extra\": 1"), "recipe-override-unknown-field=extra"},
		{"{\"format\": \"RENOVICE_ENGINE_PARAMS_V1\", \"package\": \"package:missions\", \"build\": \"b\", \"member\": \"m\", \"overrides\": []}", "recipe-overrides-invalid"},
		{"not json", "recipe-"}};
	bool rejected = true;
	for (const auto& [text, reason] : negatives)
	{
		ep::Recipe broken;
		const auto error = ep::parse_recipe(text, "package:missions", broken);
		if (!starts(error, reason)) { rejected = false; std::cout << "INFO\tparse " << reason << " got " << error << '\n'; }
	}
	check(rejected, "A3 11 malformed recipes are rejected with their exact reason (recipe-local)");

	auto mutated = recipe;
	mutated.overrides[0].hash ^= 1u;
	check(starts(ep::validate_recipe(mutated, declarations, seed), "recipe-hash-is-not-the-name-hash"), "A4 a hash that is not the parameter's name hash is rejected");
	check(ep::validate_recipe(mutated, declarations, seed, false).empty(), "A4 without the running build's seed only the declarations are checked");
	mutated = recipe;
	mutated.overrides[0].value = "no.such.value";
	check(starts(ep::validate_recipe(mutated, declarations, seed), "recipe-value-not-declared"), "A4 an undeclared value is rejected");
	mutated = recipe;
	mutated.member = "Other.targets.addon.lua_B";
	check(starts(ep::validate_recipe(mutated, declarations, seed), "recipe-value-member-mismatch"), "A4 a value of another member is rejected");
	mutated = recipe;
	mutated.build = "2026.01.01.00.00";
	check(starts(ep::validate_recipe(mutated, declarations, seed), "recipe-build-mismatch"), "A4 another client build is rejected");
	mutated = recipe;
	for (auto& item : mutated.overrides)
		if (item.value == "interception.round_end_timer") item.mode = ep::Mode::Scale;   // stock 15: not a multiplier
	check(starts(ep::validate_recipe(mutated, declarations, seed), "recipe-scaled-value-needs-stock-1-and-positive-minimum"),
		"A4 a scale mode on a value whose stock is not 1 is rejected");

	settings::MemberDelivery delivery;
	delivery.values = {{"capture.target_health_player_mult.p1", 2.0f, 1.0f}, {"exterminate.kills_scale", 0.1f, 1.0f},
		{"interception.score_goal_scale", 0.5f, 1.0f}};
	delivery.identity = settings::delivery_identity(delivery.values);
	const auto entries = ep::resolve_entries(recipe, &delivery);
	check(entries.size() == 2 && entries[0].module == 0xc05987eccd08c1caull && entries[0].hash == 0xbaa888a8u && entries[0].value == 0.1f
			&& entries[0].mode == ep::Mode::ScaleInverse && entries[1].hash == 0x3a44eae1u && entries[1].value == 0.5f,
		"A5 plan = the delivered values only (kills 0.1 scale_inverse, score 0.5 scale); off values add nothing");
	const auto withheld = ep::withhold(delivery, recipe.value_ids());
	check(withheld->values.size() == 1 && withheld->values[0].id == "capture.target_health_player_mult.p1"
			&& withheld->identity == settings::delivery_identity(withheld->values) && withheld->identity != delivery.identity,
		"A5 withheld delivery: every recipe value removed, other values unchanged, identity recomputed");
	const auto snapshot = ep::make_snapshot(entries, recipe.modules());
	check(snapshot->wants_hash(0x3a44eae1u) && !snapshot->wants_hash(0x288044d3u) && snapshot->find(0xc9605470a8c47d8dull, 0x3a44eae1u) != nullptr
			&& snapshot->find(0xc05987eccd08c1caull, 0x3a44eae1u) == nullptr && snapshot->modules.size() == 3
			&& starts(snapshot->identity, "engine-params-v1:"),
		"A6 snapshot: hash filter, exact (module, hash) lookup, all recipe modules, stable identity");
	check(ep::make_snapshot(entries, recipe.modules())->identity == snapshot->identity
			&& ep::make_snapshot({}, recipe.modules())->identity != snapshot->identity,
		"A6 the plan identity is deterministic and changes with the plan");

	ep::IdentitySnapshot identities;
	std::shared_ptr<const ep::IdentitySnapshot> current = std::make_shared<ep::IdentitySnapshot>(identities);
	for (std::uint64_t n = 1; n <= 10; ++n)
	{
		ep::ModuleIdentity module;
		module.key = 7;
		module.vm = 0x1000;
		module.root = 0x5000 + n * 0x100;
		module.sequence = n;
		module.prototypes = {{module.root, 0x9000, 1, 0, 1}};
		current = ep::with_module(*current, std::move(module));
	}
	ep::ModuleIdentity again;
	again.key = 7;
	again.vm = 0x1000;
	again.root = 0x5000 + 10 * 0x100;
	again.sequence = 11;
	current = ep::with_module(*current, again);
	check(current->modules.size() == ep::maximum_identities_per_module && current->modules.front().sequence == 3
			&& current->modules.back().sequence == 11,
		"A7 identities: at most 8 loads per (key, VM), oldest dropped, a reload of the same root replaces its record");
}

// =============================================================================
// B. The hook decision on a byte-exact model of the writer's frame
// =============================================================================
struct Arena
{
	std::vector<std::uint8_t> bytes = std::vector<std::uint8_t>(1 << 16, 0);
	std::size_t used = 64;
	std::uintptr_t alloc(std::size_t size)
	{
		used = (used + 15) & ~std::size_t{15};
		const auto at = reinterpret_cast<std::uintptr_t>(bytes.data() + used);
		used += size;
		if (used > bytes.size()) throw std::runtime_error("arena");
		return at;
	}
	template <class T> void put(std::uintptr_t address, T value) { std::memcpy(reinterpret_cast<void*>(address), &value, sizeof(T)); }
	template <class T> T get(std::uintptr_t address) const { T value{}; std::memcpy(&value, reinterpret_cast<const void*>(address), sizeof(T)); return value; }
};

// Production Memory contract; fault injection for the checked heap reads.
struct ModelMemory
{
	bool fail_checked = false;
	std::size_t writes = 0;
	bool read(std::uintptr_t address, void* out, std::size_t size) const
	{
		if (address < 0x10000) return false;
		std::memcpy(out, reinterpret_cast<const void*>(address), size);
		return true;
	}
	bool read_checked(std::uintptr_t address, void* out, std::size_t size) const
	{
		if (fail_checked) return false;
		return read(address, out, size);
	}
	void write(std::uintptr_t address, const void* in, std::size_t size)
	{
		++writes;
		std::memcpy(reinterpret_cast<void*>(address), in, size);
	}
};

struct Frame
{
	const ep::Layout& layout = build_44_0_2().layout;
	Arena arena;
	std::uintptr_t state = 0, stack = 0, vm = 0, env = 0, closure = 0, proto = 0, code = 0;
	std::vector<std::uint8_t> code_bytes;
	std::int32_t instructions = 37, bytecode_id = 21;
	std::size_t stock_pushes = 0;

	// R19: `entry_code` / `entry_id` model a real prototype (the stock code words and bytecode id of an encounter entry);
	// empty keeps the synthetic 37-instruction prototype of the R16 cases.
	Frame(std::uintptr_t vm_identity = 0x7ff00000, const std::vector<std::uint8_t>& entry_code = {}, std::int32_t entry_id = 21)
	{
		state = arena.alloc(0x90);
		stack = arena.alloc(64 * 16);
		vm = vm_identity;
		env = arena.alloc(0x40);
		if (entry_code.empty())
		{
			code_bytes.resize(4 * 37);
			for (std::size_t i = 0; i != code_bytes.size(); ++i) code_bytes[i] = static_cast<std::uint8_t>(i * 7 + 3);
		}
		else
		{
			code_bytes = entry_code;
			instructions = static_cast<std::int32_t>(entry_code.size() / 4);
			bytecode_id = entry_id;
		}
		code = arena.alloc(code_bytes.size());
		std::memcpy(reinterpret_cast<void*>(code), code_bytes.data(), code_bytes.size());
		proto = arena.alloc(0xb0);
		arena.put<std::uint8_t>(proto, layout.proto_gc_tag);
		arena.put<std::uintptr_t>(proto + layout.proto_code, code);
		arena.put<std::int32_t>(proto + layout.proto_instructions, instructions);
		arena.put<std::int32_t>(proto + layout.proto_bytecode_id, bytecode_id);
		closure = arena.alloc(0x30);
		arena.put<std::uint8_t>(closure + layout.closure_is_c, 0);
		arena.put<std::uintptr_t>(closure + layout.closure_env, env);
		arena.put<std::uintptr_t>(closure + layout.closure_proto, proto);
		arena.put<std::uintptr_t>(state + layout.state_stack, stack);
		arena.put<std::uintptr_t>(state + layout.state_global, vm);
		set_top(stack);
	}
	std::uintptr_t top() const { return arena.get<std::uintptr_t>(state + layout.state_top); }
	void set_top(std::uintptr_t value) { arena.put<std::uintptr_t>(state + layout.state_top, value); }
	void push(std::uint64_t value_bits, std::uint32_t tag)
	{
		const auto slot = top();
		arena.put<std::uint64_t>(slot, value_bits);
		arena.put<std::uint32_t>(slot + layout.value_tag, tag);
		set_top(slot + layout.value_size);
	}
	void push_float(float value, std::uint32_t tag)
	{
		const auto slot = top();
		arena.put<std::uint64_t>(slot, 0);
		arena.put<float>(slot, value);
		arena.put<std::uint32_t>(slot + layout.value_tag, tag);
		set_top(slot + layout.value_size);
	}
	// lua_getfenv(thread, -1) contract: [.., function, env].
	void enter_function()
	{
		set_top(stack);
		push(closure, layout.tag_function);
		push(env, layout.tag_table);
	}
	ep::ModuleIdentity identity(std::uint64_t key) const
	{
		ep::ModuleIdentity module;
		module.key = key;
		module.vm = vm;
		module.root = proto;
		module.sequence = 1;
		module.prototypes = {{proto, code, instructions, bytecode_id, ep::code_hash(code_bytes.data(), code_bytes.size())}};
		return module;
	}
	// The registered stock push (types 0/1 handler): the float at the value slot, tag 3, top += 16.
	void stock_push(std::uintptr_t record, std::intptr_t index)
	{
		++stock_pushes;
		std::uint8_t type = arena.get<std::uint8_t>(record + layout.record_type);
		float value = 0.0f;
		const auto elements = arena.get<std::uintptr_t>(record + layout.record_elements);
		if (index == -1) value = arena.get<float>(record + layout.record_scalar);
		else if (index >= 0 && elements != 0)
			value = arena.get<float>(elements + static_cast<std::uintptr_t>(index) * layout.element_stride);
		// (index < -1 or no elements: shapes the four callers never produce; the model pushes 0)
		if (type == layout.number_types[0] || type == layout.number_types[1]) push_float(value, layout.tag_number);
		else push(1, 1);   // a bool push (tag 1) stands for every non-number type
	}
};

struct Outcome
{
	ep::Skip skip = ep::Skip::None;
	std::uint64_t key = 0;
	ep::Applied applied;
	bool overridden = false;
};

// The detour's order (engine_params.cpp push_value_detour): classify, module,
// plan entry, the ONE stock push, then apply_pushed.
Outcome detour(Frame& frame, ModelMemory& memory, const ep::PlanSnapshot& plan, const ep::IdentitySnapshot& identities,
	std::uintptr_t record, std::intptr_t index)
{
	Outcome outcome;
	const ep::PlanEntry* entry = nullptr;
	auto candidate = ep::classify(frame.layout, memory, frame.state, record, index, plan);
	if (candidate.skip == ep::Skip::None)
	{
		outcome.key = ep::module_of(frame.layout, memory, identities, candidate.vm, candidate.proto);
		if (outcome.key == 0) candidate.skip = ep::Skip::ModuleUnknown;
		else if ((entry = plan.find(outcome.key, candidate.hash)) == nullptr) candidate.skip = ep::Skip::OverrideNotDeclared;
	}
	outcome.skip = candidate.skip;
	frame.stock_push(record, index);
	if (candidate.skip != ep::Skip::None) return outcome;
	outcome.applied = ep::apply_pushed(frame.layout, memory, frame.state, candidate, *entry);
	outcome.skip = outcome.applied.skip;
	outcome.overridden = outcome.applied.skip == ep::Skip::None;
	return outcome;
}

std::uintptr_t scalar_record(Frame& frame, std::uint8_t type, float value)
{
	const auto record = frame.arena.alloc(0x40);
	frame.arena.put<std::uint8_t>(record + frame.layout.record_type, type);
	frame.arena.put<std::uint8_t>(record + frame.layout.record_array, 0);
	frame.arena.put<float>(record + frame.layout.record_scalar, value);
	return record;
}

std::uintptr_t array_record(Frame& frame, const std::vector<float>& values)
{
	const auto record = frame.arena.alloc(0x40);
	const auto elements = frame.arena.alloc(values.size() * frame.layout.element_stride);
	for (std::size_t i = 0; i != values.size(); ++i) frame.arena.put<float>(elements + i * frame.layout.element_stride, values[i]);
	frame.arena.put<std::uint8_t>(record + frame.layout.record_type, 0);
	frame.arena.put<std::uint8_t>(record + frame.layout.record_array, 1);
	frame.arena.put<std::uintptr_t>(record + frame.layout.record_elements, elements);
	frame.arena.put<std::uint32_t>(record + frame.layout.record_element_bytes, static_cast<std::uint32_t>(values.size() * frame.layout.element_stride));
	return record;
}

// apply_param model: env[hash] = value (scalar) or a new list of the pushed elements.
struct Applied
{
	std::vector<float> values;
	std::vector<Outcome> outcomes;
};
Applied apply_param(Frame& frame, ModelMemory& memory, const ep::PlanSnapshot& plan, const ep::IdentitySnapshot& identities,
	std::uintptr_t record, std::uint32_t hash, std::size_t count)
{
	Applied result;
	frame.enter_function();
	frame.push(hash, frame.layout.tag_hash_key);
	if (count == 0)
	{
		result.outcomes.push_back(detour(frame, memory, plan, identities, record, -1));
		result.values.push_back(frame.arena.get<float>(frame.top() - frame.layout.value_size));
		return result;
	}
	frame.push(frame.arena.alloc(0x40), frame.layout.tag_table);
	for (std::size_t i = 0; i != count; ++i)
	{
		result.outcomes.push_back(detour(frame, memory, plan, identities, record, static_cast<std::intptr_t>(i)));
		result.values.push_back(frame.arena.get<float>(frame.top() - frame.layout.value_size));
		frame.set_top(frame.top() - frame.layout.value_size);   // lua_rawseti pops the element
	}
	return result;
}

void hook_decision(const ep::Recipe& recipe)
{
	ModelMemory memory;
	// One plan with every R16 row at the live-test values: Exterminate x0.1, Archwing 0.8, Interception score x0.5,
	// scoring x2, round timer 30, Corpus fighters x0.5.
	settings::MemberDelivery delivery;
	delivery.values = {{"exterminate.kills_scale", 0.1f, 1.0f}, {"exterminate.archwing_kill_mult", 0.8f, 0.5f},
		{"interception.score_goal_scale", 0.5f, 1.0f}, {"interception.scoring_speed", 2.0f, 1.0f},
		{"interception.round_end_timer", 30.0f, 15.0f}, {"railjack.corpus_fighter_limit_scale", 0.5f, 1.0f}};
	const auto plan = ep::make_snapshot(ep::resolve_entries(recipe, &delivery), recipe.modules());
	check(plan->entries.size() == 7, "B0 plan of the six R16 rows = 7 (module, parameter) overrides");

	struct Row { const char* id; std::uint64_t key; std::uint32_t hash; std::vector<float> stock; std::vector<float> expect; };
	const Row rows[] = {
		{"exterminate.kills_scale", 0xc05987eccd08c1caull, 0xbaa888a8u, {12.5f}, {125.0f}},
		{"exterminate.archwing_kill_mult", 0xc05987eccd08c1caull, 0xe34f013bu, {0.5f}, {0.8f}},
		{"interception.score_goal_scale", 0xc9605470a8c47d8dull, 0x3a44eae1u, {1450.0f}, {725.0f}},
		{"interception.scoring_speed", 0xc9605470a8c47d8dull, 0x5241ca6cu, {1.0f}, {2.0f}},
		{"interception.round_end_timer", 0xc9605470a8c47d8dull, 0xb68a06b6u, {15.0f}, {30.0f}},
		{"railjack.corpus_fighter_limit_scale minorKillGoals", 0x0a6394a10884c38aull, 0x288044d3u, {20, 35, 55, 85, 110}, {10, 18, 28, 43, 55}},
		{"railjack.corpus_fighter_limit_scale minorKillGoalsMax", 0x0a6394a10884c38aull, 0xe290a5e6u, {35, 55, 85, 110, 130}, {18, 28, 43, 55, 65}},
	};
	for (const auto& row : rows)
	{
		Frame frame;
		ep::IdentitySnapshot identities;
		identities.modules.push_back(frame.identity(row.key));
		const bool array = row.stock.size() > 1;
		const auto record = array ? array_record(frame, row.stock) : scalar_record(frame, 0, row.stock[0]);
		// Engine re-write order: initial apply, native entry (the addon value is withheld: no Lua write), three re-applies.
		bool survives = true;
		std::size_t pushes_before = frame.stock_pushes;
		for (int pass = 0; pass != 4; ++pass)
		{
			const auto result = apply_param(frame, memory, *plan, identities, record, row.hash, array ? row.stock.size() : 0);
			bool all = result.values.size() == row.expect.size();
			for (std::size_t i = 0; all && i != row.expect.size(); ++i)
				all = std::fabs(result.values[i] - row.expect[i]) < 1e-3f && result.outcomes[i].overridden && result.outcomes[i].key == row.key;
			survives = survives && all;
		}
		check(survives && frame.stock_pushes - pushes_before == 4 * row.stock.size(),
			std::string("B1 ") + row.id + ": the overridden value is what the engine stores on the first write and on 3 re-writes; one stock push per value");
		// R10 baseline: no native owner. The entry write happens once, the next engine write restores the level value.
		const auto empty = ep::make_snapshot({}, {});
		const auto baseline = apply_param(frame, memory, *empty, identities, record, row.hash, array ? row.stock.size() : 0);
		bool restored = baseline.values.size() == row.stock.size();
		for (std::size_t i = 0; restored && i != row.stock.size(); ++i) restored = baseline.values[i] == row.stock[i] && !baseline.outcomes[i].overridden;
		check(restored, std::string("B1 ") + row.id + ": without the hook an engine re-write stores the level value again (the R15 failure shape)");
	}

	// Fail-closed paths (each still pushes exactly once and writes nothing).
	const auto unchanged = [&](const char* label, auto&& setup, ep::Skip expected)
	{
		Frame frame;
		ep::IdentitySnapshot identities;
		identities.modules.push_back(frame.identity(0xc9605470a8c47d8dull));
		ModelMemory local;
		std::uintptr_t record = scalar_record(frame, 0, 1450.0f);
		std::intptr_t index = -1;
		std::uint32_t hash = 0x3a44eae1u;
		setup(frame, identities, local, record, index, hash);
		frame.enter_function();
		frame.push(hash, frame.layout.tag_hash_key);
		const auto before = frame.stock_pushes;
		const auto outcome = detour(frame, local, *plan, identities, record, index);
		const auto pushed = frame.arena.get<std::uint64_t>(frame.top() - frame.layout.value_size);
		const bool untouched = local.writes == 0 && frame.stock_pushes == before + 1;
		check(untouched && outcome.skip == expected && !outcome.overridden,
			std::string("B2 ") + label + " -> " + ep::skip_label(expected) + ", stock pushed once, nothing written");
		(void)pushed;
	};
	using F = Frame;
	using I = ep::IdentitySnapshot;
	using M = ModelMemory;
	unchanged("bool parameter (type 2)", [](F& f, I&, M&, std::uintptr_t& r, std::intptr_t&, std::uint32_t&) { f.arena.put<std::uint8_t>(r + f.layout.record_type, 2); }, ep::Skip::ParameterTypeNotNumber);
	unchanged("string parameter (type 4)", [](F& f, I&, M&, std::uintptr_t& r, std::intptr_t&, std::uint32_t&) { f.arena.put<std::uint8_t>(r + f.layout.record_type, 4); }, ep::Skip::ParameterTypeNotNumber);
	unchanged("enum parameter (type 13, pushes an int)", [](F& f, I&, M&, std::uintptr_t& r, std::intptr_t&, std::uint32_t&) { f.arena.put<std::uint8_t>(r + f.layout.record_type, 13); }, ep::Skip::ParameterTypeNotNumber);
	unchanged("undeclared parameter name", [](F&, I&, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t& h) { h = 0x69d6d911u; }, ep::Skip::HashNotDeclared);
	unchanged("index -2", [](F&, I&, M&, std::uintptr_t&, std::intptr_t& i, std::uint32_t&) { i = -2; }, ep::Skip::IndexInvalid);
	unchanged("element index on a scalar record", [](F&, I&, M&, std::uintptr_t&, std::intptr_t& i, std::uint32_t&) { i = 0; }, ep::Skip::IndexInvalid);
	unchanged("module never loaded (no identity)", [](F&, I& ids, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { ids.modules.clear(); }, ep::Skip::ModuleUnknown);
	unchanged("declared hash in another module", [](F& f, I& ids, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { ids.modules = {f.identity(0xc05987eccd08c1caull)}; }, ep::Skip::OverrideNotDeclared);
	unchanged("another VM", [](F& f, I& ids, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { auto m = f.identity(0xc9605470a8c47d8dull); m.vm = 0x1234; ids.modules = {m}; }, ep::Skip::ModuleUnknown);
	unchanged("reused prototype address (code differs)", [](F& f, I&, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { f.arena.put<std::uint8_t>(f.code, 0xee); }, ep::Skip::ModuleUnknown);
	unchanged("reused prototype address (bytecode id differs)", [](F& f, I&, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { f.arena.put<std::int32_t>(f.proto + f.layout.proto_bytecode_id, 22); }, ep::Skip::ModuleUnknown);
	unchanged("two modules claim the prototype (ambiguous)", [](F& f, I& ids, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { auto m = f.identity(0x1111111111111111ull); m.root = 1; ids.modules.push_back(m); }, ep::Skip::ModuleUnknown);
	unchanged("C function below the env", [](F& f, I&, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { f.arena.put<std::uint8_t>(f.closure + f.layout.closure_is_c, 1); }, ep::Skip::FunctionNotLuaClosure);
	unchanged("getfenv(function) is not the written table", [](F& f, I&, M&, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { f.arena.put<std::uintptr_t>(f.closure + f.layout.closure_env, f.env + 16); }, ep::Skip::ClosureEnvMismatch);
	unchanged("closure unreadable", [](F&, I&, M& m, std::uintptr_t&, std::intptr_t&, std::uint32_t&) { m.fail_checked = true; }, ep::Skip::FunctionNotLuaClosure);

	// Stack shapes the four apply_param callers never produce.
	{
		Frame frame;
		ep::IdentitySnapshot identities;
		identities.modules.push_back(frame.identity(0xc9605470a8c47d8dull));
		ModelMemory local;
		const auto record = scalar_record(frame, 0, 1450.0f);
		frame.set_top(frame.stack);
		frame.push(0x3a44eae1u, frame.layout.tag_hash_key);   // key without function and env below
		auto outcome = detour(frame, local, *plan, identities, record, -1);
		check(outcome.skip == ep::Skip::StackShape && local.writes == 0, "B3 a key with no function/env below it is left alone");
		frame.set_top(frame.stack);
		frame.push(frame.closure, frame.layout.tag_function);
		frame.push(frame.env, frame.layout.tag_table);
		frame.push(0x3a44eae1u, 5);   // not a hashed-name key
		outcome = detour(frame, local, *plan, identities, record, -1);
		check(outcome.skip == ep::Skip::KeyNotHash && local.writes == 0, "B3 a key that is not a hashed name is left alone");
		frame.set_top(frame.stack);
		frame.push(frame.closure, frame.layout.tag_function);
		frame.push(0, 0);   // nil instead of the environment
		frame.push(0x3a44eae1u, frame.layout.tag_hash_key);
		outcome = detour(frame, local, *plan, identities, record, -1);
		check(outcome.skip == ep::Skip::EnvNotTable && local.writes == 0, "B3 a non-table environment slot is left alone");
	}
	// A stock push that did not leave exactly one number (apply_pushed refuses, nothing written).
	{
		Frame frame;
		ep::IdentitySnapshot identities;
		identities.modules.push_back(frame.identity(0xc9605470a8c47d8dull));
		ModelMemory local;
		const auto record = scalar_record(frame, 0, 1450.0f);
		frame.enter_function();
		frame.push(0x3a44eae1u, frame.layout.tag_hash_key);
		auto candidate = ep::classify(frame.layout, local, frame.state, record, -1, *plan);
		const auto* entry = plan->find(0xc9605470a8c47d8dull, 0x3a44eae1u);
		frame.push(1, 1);   // a bool where the number should be
		const auto applied = ep::apply_pushed(frame.layout, local, frame.state, candidate, *entry);
		check(candidate.skip == ep::Skip::None && applied.skip == ep::Skip::PushShape && local.writes == 0,
			"B4 a pushed value that is not a number is not rewritten");
		frame.set_top(frame.top() + frame.layout.value_size);   // two slots instead of one
		const auto twice = ep::apply_pushed(frame.layout, local, frame.state, candidate, *entry);
		check(twice.skip == ep::Skip::PushShape && local.writes == 0, "B4 a push that moved the top by other than one slot is not rewritten");
	}
}

// =============================================================================
// C. Package scan end to end
// =============================================================================
const packages::Package* find_package(const packages::Snapshot& snapshot, std::string_view folder)
{
	for (const auto& package : snapshot.packages)
		if (package.folder == folder) return &package;
	return nullptr;
}

const packages::Member* addon(const packages::Package* package)
{
	if (package == nullptr) return nullptr;
	for (const auto& member : package->members)
		if (member.kind == packages::MemberKind::MultiTargetAddon) return &member;
	return nullptr;
}

bool delivered(const packages::Member* member, std::string_view id, float* value = nullptr)
{
	if (member == nullptr || !member->delivery) return false;
	for (const auto& entry : member->delivery->values)
		if (entry.id == id) { if (value) *value = entry.value; return true; }
	return false;
}

void write_values(const std::filesystem::path& root, float kills, float score)
{
	write_text(root / "Settings" / "Missions.json",
		"{\"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missions\", \"build\": \"2026.09.28.13.06\","
		" \"values\": {\"exterminate.kills_scale\": {\"enabled\": true, \"value\": " + std::to_string(kills) + "},"
		" \"interception.score_goal_scale\": {\"enabled\": true, \"value\": " + std::to_string(score) + "},"
		" \"capture.target_health_player_mult.p1\": {\"enabled\": true, \"value\": 2}}}");
}

void package_scan(const std::filesystem::path& work, const std::filesystem::path& fixtures)
{
	gate::root = work / "CustomScripts";
	gate::inject = gate::root / "Inject";
	std::filesystem::remove_all(gate::root);
	std::filesystem::create_directories(gate::inject);
	const auto missions = gate::root / "Packages" / "Missions";
	std::filesystem::create_directories(missions);
	std::filesystem::copy_file(fixtures / "Missions" / "package.json", missions / "package.json");
	std::filesystem::copy_file(fixtures / "Missions" / "engine_params.json", missions / "engine_params.json");
	const auto pool = synthetic_pool({"c05987eccd08c1ca", "c9605470a8c47d8d", "0a6394a10884c38a"});
	{
		std::ofstream out(missions / "Missions.targets.addon.lua_B", std::ios::binary);
		out.write(reinterpret_cast<const char*>(pool.data()), static_cast<std::streamsize>(pool.size()));
	}
	write_values(gate::root, 0.1f, 0.5f);

	// C1: the hook is not installed (unregistered build, older bootstrapper behaviour): nothing is withheld.
	ep::gate_set_installed(nullptr);
	gate::log_lines.clear();
	check(packages::initialise(), "C1 startup scan passes");
	auto snapshot = packages::candidate();
	const auto* member = addon(find_package(*snapshot, "Missions"));
	check(member != nullptr && delivered(member, "exterminate.kills_scale") && delivered(member, "interception.score_goal_scale")
			&& logged("RENOVICE ENGINE PARAMS RECIPE ACCEPT trigger=startup package=Missions member=Missions.targets.addon.lua_B overrides=7 modules=3 values=6 lane=addon-lua-not-installed applying=0"),
		"C1 hook not installed: the addon keeps every value (R10 Lua lane), recipe accepted as inactive");
	check(ep::active()->entries.empty() && !ep::observing(), "C1 hook not installed: empty plan, no module observation");

	// C2: installed (44.0.2 registration): plan from the delivery, values withheld from the addon.
	ep::gate_set_installed(&build_44_0_2());
	gate::log_lines.clear();
	check(packages::prepare_reload(), "C2 F9 prepare passes");
	check(ep::active()->entries.empty(), "C2 a prepared plan is not visible before the F9 commit");
	packages::commit_prepared_reload();
	snapshot = packages::candidate();
	member = addon(find_package(*snapshot, "Missions"));
	float other = 0.0f;
	check(member != nullptr && !delivered(member, "exterminate.kills_scale") && !delivered(member, "interception.score_goal_scale")
			&& delivered(member, "capture.target_health_player_mult.p1", &other) && other == 2.0f,
		"C2 installed: kills and score are withheld from the addon; an unrelated value is still delivered");
	auto plan = ep::active();
	const auto* kills = plan->find(0xc05987eccd08c1caull, 0xbaa888a8u);
	const auto* score = plan->find(0xc9605470a8c47d8dull, 0x3a44eae1u);
	check(plan->entries.size() == 2 && kills != nullptr && kills->value == 0.1f && score != nullptr && score->value == 0.5f
			&& logged("lane=native applying=2 withheld_from_addon=6") && logged("RENOVICE ENGINE PARAMS PLAN trigger=F9 installed=1 overrides=2")
			&& logged("RENOVICE ENGINE PARAMS OVERRIDE trigger=F9 package=Missions key=c05987eccd08c1ca hash=baa888a8 parameter=metersPerEnemy value_id=exterminate.kills_scale mode=scale_inverse value=0.1"),
		"C2 the committed plan holds the delivered values (kills 0.1, score 0.5) and is logged");
	check(ep::observing() && ep::module_wanted(0xc9605470a8c47d8dull) && !ep::module_wanted(0xfeb4ca192ef69f0aull),
		"C2 natural loads of the three recipe modules are observed; other modules are not");
	check(logged("RENOVICE SETTINGS DELIVERY trigger=F9 package=Missions member=Missions.targets.addon.lua_B values=1"),
		"C2 the delivery line reports what the addon gets (1 value)");

	// C3: F9 discard keeps the committed plan; commit replaces it.
	write_values(gate::root, 0.2f, 0.5f);
	check(packages::prepare_reload(), "C3 F9 prepare with kills 0.2");
	packages::discard_prepared_reload();
	check(ep::active()->find(0xc05987eccd08c1caull, 0xbaa888a8u)->value == 0.1f, "C3 a discarded F9 keeps the committed plan (0.1)");
	check(packages::prepare_reload(), "C3 F9 prepare again");
	packages::commit_prepared_reload();
	check(ep::active()->find(0xc05987eccd08c1caull, 0xbaa888a8u)->value == 0.2f, "C3 the next commit publishes 0.2");

	// C4: a broken recipe is recipe-local: the addon keeps the values.
	write_text(missions / "engine_params.json", replace_once(read_text(fixtures / "Missions" / "engine_params.json"), "\"format\"", "\"oops\": 1, \"format\""));
	gate::log_lines.clear();
	check(packages::prepare_reload(), "C4 F9 prepare with a broken recipe passes (package-local)");
	packages::commit_prepared_reload();
	snapshot = packages::candidate();
	member = addon(find_package(*snapshot, "Missions"));
	check(delivered(member, "exterminate.kills_scale") && ep::active()->entries.empty()
			&& logged("RENOVICE ENGINE PARAMS RECIPE REJECT trigger=F9 package=Missions reason=recipe-unknown-field=oops scope=recipe-local values=addon-lua-lane")
			&& find_package(*snapshot, "Missions")->accepted,
		"C4 broken recipe: rejected alone, the package stays accepted and the addon keeps its values");

	// C5: a wrong hash is caught with the running build's seed.
	write_text(missions / "engine_params.json", replace_once(read_text(fixtures / "Missions" / "engine_params.json"), "baa888a8", "baa888a9"));
	gate::log_lines.clear();
	check(packages::prepare_reload(), "C5 F9 prepare with a wrong hash");
	packages::commit_prepared_reload();
	member = addon(find_package(*packages::candidate(), "Missions"));
	check(delivered(member, "exterminate.kills_scale") && ep::active()->entries.empty()
			&& logged("reason=recipe-hash-is-not-the-name-hash parameter=metersPerEnemy value=exterminate.kills_scale"),
		"C5 wrong name hash: recipe rejected, addon keeps the values");

	// C6: a second package overriding the same (module, parameter) keeps its value on its own addon.
	std::filesystem::copy_file(fixtures / "Missions" / "engine_params.json", missions / "engine_params.json",
		std::filesystem::copy_options::overwrite_existing);
	const auto other_package = gate::root / "Packages" / "MissionsB";
	write_text(other_package / "package.json",
		"{\"schema\": 1, \"name\": \"MissionsB\", \"members\": {\"MissionsB.targets.addon.lua_B\": {\"label\": \"B\", \"settings\": {\"values\": {"
		"\"b.kills\": {\"applies\": \"next_mission\", \"group\": \"b\", \"label\": \"Kills\", \"lane\": \"addon\", \"max\": 10, \"min\": 0.1,"
		" \"stock\": 1, \"stock_check\": \"none\", \"type\": \"float\", \"unit\": \"x\"}}}}},"
		" \"settings\": {\"format\": \"RENOVICE_SETTINGS_DECL_V1\", \"build\": \"2026.09.28.13.06\", \"groups\": [{\"id\": \"b\", \"label\": \"B\", \"order\": 1}]}}");
	write_text(other_package / "engine_params.json",
		"{\"format\": \"RENOVICE_ENGINE_PARAMS_V1\", \"package\": \"package:missionsb\", \"build\": \"2026.09.28.13.06\","
		" \"member\": \"MissionsB.targets.addon.lua_B\", \"overrides\": [{\"value\": \"b.kills\", \"module\": \"c05987eccd08c1ca\","
		" \"parameter\": \"metersPerEnemy\", \"hash\": \"baa888a8\", \"mode\": \"scale_inverse\"}]}");
	const auto other_pool = synthetic_pool({"5555555555555555"});
	{
		std::ofstream out(other_package / "MissionsB.targets.addon.lua_B", std::ios::binary);
		out.write(reinterpret_cast<const char*>(other_pool.data()), static_cast<std::streamsize>(other_pool.size()));
	}
	write_text(gate::root / "Settings" / "MissionsB.json",
		"{\"format\": \"RENOVICE_SCRIPT_SETTINGS_V1\", \"package\": \"package:missionsb\", \"values\": {\"b.kills\": {\"enabled\": true, \"value\": 0.5}}}");
	gate::log_lines.clear();
	check(packages::prepare_reload(), "C6 F9 prepare with two packages");
	packages::commit_prepared_reload();
	snapshot = packages::candidate();
	const auto* second = addon(find_package(*snapshot, "MissionsB"));
	check(find_package(*snapshot, "MissionsB") != nullptr && find_package(*snapshot, "MissionsB")->accepted && delivered(second, "b.kills")
			&& !delivered(addon(find_package(*snapshot, "Missions")), "exterminate.kills_scale")
			&& ep::active()->find(0xc05987eccd08c1caull, 0xbaa888a8u)->value_id == "exterminate.kills_scale"
			&& logged("RENOVICE ENGINE PARAMS RECIPE REJECT trigger=F9 package=MissionsB reason=parameter-owned-by holder=package:Missions"),
		"C6 overlapping parameter: the first package owns it; the second keeps its value on its addon (delivery restored)");
	std::filesystem::remove_all(other_package);
	std::filesystem::remove(gate::root / "Settings" / "MissionsB.json");

	// C7: the package disabled in SCRIPTS: no plan, nothing to withhold.
	gate::policy["package:missions"] = false;
	check(packages::prepare_reload(), "C7 F9 prepare with the package disabled");
	packages::commit_prepared_reload();
	check(ep::active()->entries.empty(), "C7 a disabled package contributes no override");
	gate::policy.clear();
	check(packages::prepare_reload(), "C7 F9 prepare with the package enabled again");
	packages::commit_prepared_reload();
	check(ep::active()->entries.size() == 2, "C7 re-enabled: the plan is back");
}

// =============================================================================
// D. Registered bytes against the installed executable
// =============================================================================
template <class T> T load(const std::vector<std::uint8_t>& bytes, std::size_t at)
{
	T value{};
	if (at + sizeof(T) <= bytes.size()) std::memcpy(&value, bytes.data() + at, sizeof(T));
	return value;
}

void image_bytes(const std::filesystem::path& exe, const std::string& digest)
{
	if (exe.empty() || exe == "-")
	{
		std::cout << "INFO\tno executable given; registered byte ranges not checked here\n";
		return;
	}
	const auto* build = ep::registration_for_digest(digest);
	check(ep::registration_for_digest("00") == nullptr && ep::registration_for_digest("") == nullptr,
		"D1 an unregistered digest selects nothing (fail closed, no fallback)");
	// Native update (2026-10-02): every registered image is checked; an image the
	// native update tool could not register (or has not processed) installs nothing.
	if (build == nullptr)
	{
		std::cout << "INFO\t" << digest << " is not registered: ENGINE_PARAM_OVERRIDE installs nothing on it (fail closed)\n";
		return;
	}
	bool listed = false;
	for (const auto& known : build->digests) listed = listed || (!known.empty() && known == digest);
	check(listed, std::string("D1 the executable's SHA-256 selects its exact registration (") + std::string(build->label) + ")");
	std::ifstream input(exe, std::ios::binary);
	const std::vector<std::uint8_t> file((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
	const auto pe = load<std::uint32_t>(file, 0x3c);
	const auto sections = load<std::uint16_t>(file, pe + 6);
	const auto optional_size = load<std::uint16_t>(file, pe + 20);
	const auto image_size = load<std::uint32_t>(file, pe + 24 + 56);
	std::vector<std::uint8_t> image(image_size, 0);
	const auto table = pe + 24 + optional_size;
	for (std::uint16_t i = 0; i != sections; ++i)
	{
		const auto at = table + i * 40u;
		const auto virtual_address = load<std::uint32_t>(file, at + 12);
		const auto raw_size = load<std::uint32_t>(file, at + 16);
		const auto raw_offset = load<std::uint32_t>(file, at + 20);
		if (raw_offset + raw_size <= file.size() && virtual_address + raw_size <= image.size())
			std::memcpy(image.data() + virtual_address, file.data() + raw_offset, raw_size);
	}
	const char* reason = ep::admit_image(*build, image.data(), image.size());
	check(reason == nullptr, std::string("D2 every registered byte range is present in the mapped image (") + std::to_string(build->checks.size()) + " ranges)");
	bool exact = true;
	for (const auto& range : build->checks)
	{
		auto copy = image;
		copy[range.rva + range.hex.size() / 4] ^= 0x01;
		const char* refused = ep::admit_image(*build, copy.data(), copy.size());
		exact = exact && refused != nullptr && std::string_view(refused) == range.reason;
	}
	check(exact, "D3 one changed byte inside any registered range refuses the install with that range's exact reason");
	check(std::string_view(ep::admit_image(*build, image.data(), 0x1000)) == "registered-range-outside-image", "D3 a truncated image is refused");
}
}

// Contract R17 (2026-10-01): an override may name a master knob (a mission-type
// master: Railjack kill goals over the Corpus fighter limit, which the engine
// writer owns). Fixture: the R17 Missions build (fixtures/MissionsR17).
void r17_masters(const std::filesystem::path& fixtures)
{
	const std::string text = read_text(fixtures / "MissionsR17" / "engine_params.json");
	settings::Declarations declarations;
	{
		packages::Manifest parsed;
		const auto error = packages::parse_manifest(read_text(fixtures / "MissionsR17" / "package.json"), parsed);
		std::vector<std::pair<std::string, std::string>> members;
		for (const auto& member : parsed.members)
			if (!member.settings_json.empty()) members.emplace_back(member.filename, member.settings_json);
		const auto declared = settings::parse_declarations(parsed.settings_json, members, declarations);
		check(error.empty() && declared.empty() && declarations.value("railjack.kill_goals_scale") != nullptr
				&& declarations.value("railjack.kill_goals_scale")->quick_on_page,
			"R17 fixture package.json parses (" + std::to_string(declarations.values.size()) + " declarations, the Railjack master on its page)");
	}
	ep::Recipe recipe;
	const auto parse_error = ep::parse_recipe(text, "package:missions", recipe);
	std::size_t with_master = 0;
	for (const auto& item : recipe.overrides)
		with_master += item.master == "railjack.kill_goals_scale" && item.scale == 1.0 && item.value == "railjack.corpus_fighter_limit_scale" ? 1 : 0;
	check(parse_error.empty() && recipe.overrides.size() == 9 && recipe.value_ids().size() == 7 && recipe.modules().size() == 4
			&& with_master == 2 && ep::validate_recipe(recipe, declarations, seed).empty(),
		"R17 the generated engine_params.json parses and validates: 9 overrides, 7 values, 4 modules; the Corpus fighter "
		"limit names its master (" + parse_error + ")");

	const auto delivery_of = [](std::vector<settings::DeliveredValue> values)
	{
		settings::MemberDelivery delivery;
		delivery.values = std::move(values);
		delivery.identity = settings::delivery_identity(delivery.values);
		return delivery;
	};
	const auto corpus = [](const std::vector<ep::PlanEntry>& entries)
	{
		std::vector<const ep::PlanEntry*> out;
		for (const auto& entry : entries)
			if (entry.module == 0x0a6394a10884c38aull) out.push_back(&entry);
		return out;
	};
	{
		const auto delivery = delivery_of({{"railjack.kill_goals_scale", 0.5f, 1.0f}});
		const auto resolved = ep::resolve_entries(recipe, &delivery);
		const auto entries = corpus(resolved);
		check(entries.size() == 2 && entries[0]->value == 0.5f && entries[1]->value == 0.5f && entries[0]->source == "railjack.kill_goals_scale"
				&& entries[0]->value_id == "railjack.corpus_fighter_limit_scale" && entries[0]->mode == ep::Mode::ScaleCount,
			"R17 the master alone drives the natively owned row: both Corpus parameters at 0.5 (scale_count), source = the master");
		const auto withheld = ep::withhold(delivery, recipe.value_ids());
		check(withheld->values.size() == 1 && withheld->values[0].id == "railjack.kill_goals_scale",
			"R17 the master is never withheld: the addon still gets it for the Grineer fighter and crewship rows");
		float out = 0.0f;
		check(ep::override_number(entries[0]->mode, 110.0f, entries[0]->value, out) && out == 55.0f
				&& ep::override_number(entries[0]->mode, 35.0f, entries[0]->value, out) && out == 18.0f,
			"R17 master 0.5 on the Corpus limits: 110 -> 55, 35 -> 18 (the R11 count rule)");
	}
	{
		const auto delivery = delivery_of({{"railjack.kill_goals_scale", 0.5f, 1.0f}, {"railjack.corpus_fighter_limit_scale", 2.0f, 1.0f}});
		const auto resolved = ep::resolve_entries(recipe, &delivery);
		const auto entries = corpus(resolved);
		check(entries.size() == 2 && entries[0]->value == 2.0f && entries[0]->source == "railjack.corpus_fighter_limit_scale",
			"R17 precedence: the row's own value wins over its master (2, not 0.5)");
	}
	{
		const auto at_stock = delivery_of({{"railjack.kill_goals_scale", 1.0f, 1.0f}});
		const auto none = delivery_of({{"capture.target_health_player_mult.p1", 2.0f, 1.0f}});
		const auto resolved_stock = ep::resolve_entries(recipe, &at_stock);
		const auto resolved_none = ep::resolve_entries(recipe, &none);
		check(corpus(resolved_stock).empty() && corpus(resolved_none).empty(),
			"R17 a master at its stock, or not delivered, adds nothing");
	}
	{
		const auto delivery = delivery_of({{"sabotage.gascity_meltdown_time_scale", 2.0f, 1.0f}});
		const auto entries = ep::resolve_entries(recipe, &delivery);
		float hack = 0.0f, mode_timer = 0.0f;
		const bool both = entries.size() == 2 && entries[0].module == 0x5b59e2968c1ec7bfull && entries[0].mode == ep::Mode::Scale
			&& ep::override_number(entries[0].mode, 10.0f, entries[0].value, hack)
			&& ep::override_number(entries[1].mode, 60.0f, entries[1].value, mode_timer);
		check(both && hack == 20.0f && mode_timer == 120.0f,
			"R17 Gas City meltdown time x2 scales both engine-written parameters (hackTime 10 -> 20, modeTimer 60 -> 120)");
	}
	{
		const auto snapshot_a = ep::make_snapshot(ep::resolve_entries(recipe, nullptr), recipe.modules());
		const auto master = delivery_of({{"railjack.kill_goals_scale", 0.5f, 1.0f}});
		const auto row = delivery_of({{"railjack.corpus_fighter_limit_scale", 0.5f, 1.0f}});
		const auto by_master = ep::make_snapshot(ep::resolve_entries(recipe, &master), recipe.modules());
		const auto by_row = ep::make_snapshot(ep::resolve_entries(recipe, &row), recipe.modules());
		check(snapshot_a->modules.size() == 4 && by_master->identity != by_row->identity && by_master->entries.size() == by_row->entries.size(),
			"R17 the plan identity records the source (master or row) of the same number");
	}
	// Rejects (recipe-local).
	const auto reason_of = [&](const std::string& mutated_text)
	{
		ep::Recipe broken;
		auto error = ep::parse_recipe(mutated_text, "package:missions", broken);
		if (error.empty()) error = ep::validate_recipe(broken, declarations, seed);
		return error;
	};
	const std::pair<std::string, std::string> negatives[] = {
		{replace_once(text, "\"master\": \"railjack.kill_goals_scale\"", "\"master\": \"railjack.no_such_master\""), "recipe-master-not-declared"},
		{replace_once(text, "\"master\": \"railjack.kill_goals_scale\"", "\"master\": \"mobiledefense.time_per_terminal\""),
			"recipe-master-not-declared"},  // a live literal is not in package.json
		{replace_once(text, "\"master\": \"railjack.kill_goals_scale\"", "\"master\": \"survival.reward_interval\""),
			"recipe-master-stock-times-scale-is-not-the-row-stock"},
		{replace_once(text, "\"master\": \"railjack.kill_goals_scale\"", "\"master\": \"exterminate.kills_scale\""),
			"recipe-master-is-an-overridden-value"},
		{replace_once(text, "\"master\": \"railjack.kill_goals_scale\"", "\"master\": \"railjack.corpus_fighter_limit_scale\""),
			"recipe-override-master-invalid"},
		{replace_once(text, "\"scale\": 1", "\"scale\": 0"), "recipe-override-scale-invalid"},
		{replace_once(text, "\"master\": \"railjack.kill_goals_scale\",", ""), "recipe-override-scale-without-master"},
		{replace_once(text, "\"scale\": 1", "\"scale\": 2"), "recipe-master-stock-times-scale-is-not-the-row-stock"},
	};
	bool rejected = true;
	for (const auto& [mutated_text, reason] : negatives)
	{
		const auto error = mutated_text.empty() ? std::string("mutation-not-applied") : reason_of(mutated_text);
		if (!starts(error, reason)) { rejected = false; std::cout << "INFO	R17 " << reason << " got " << error << '\n'; }
	}
	check(rejected, "R17 8 malformed master overrides are rejected with their exact reason (recipe-local)");
}

// Contract R19 (2026-10-02): the Grineer Railjack fighter and crewship goals
// (KillFightersExterminateEncounter / KillCrewShipsExterminateObjective
// encounter parameters) are owned at the writer too. Live session pid 7128
// (R17 DLL 304b57de): the R10 entry write logged {20/35/55/70/85/95} ->
// {2/4/6/7/9/10} and the objective still used a stock-size goal; the writer
// pushed the same parameter into KillFighters P9 and the R17 hook left it
// stock with "module-identity-unknown key=0" because no recipe named that
// module (it was never recorded). Fixture: the R19 Missions build
// (fixtures/MissionsR19) and the real entry prototypes of the three Railjack
// encounter modules (encounter_entry_protos.txt, from the 44.0.2 stock bytes).
struct EntryProto
{
	std::uint64_t key = 0;
	std::string module_sha256;
	std::int32_t bytecode_id = 0;
	std::vector<std::uint8_t> code;
};

std::map<std::uint64_t, EntryProto> read_entry_protos(const std::filesystem::path& path)
{
	std::map<std::uint64_t, EntryProto> protos;
	std::istringstream lines(read_text(path));
	std::string line;
	while (std::getline(lines, line))
	{
		if (line.empty() || line[0] == '#') continue;
		std::istringstream fields(line);
		std::string key, sha, hex;
		std::int32_t id = 0;
		std::size_t words = 0;
		fields >> key >> sha >> id >> words >> hex;
		EntryProto proto;
		proto.key = std::stoull(key, nullptr, 16);
		proto.module_sha256 = sha;
		proto.bytecode_id = id;
		for (std::size_t i = 0; i + 1 < hex.size(); i += 2)
			proto.code.push_back(static_cast<std::uint8_t>(std::stoul(hex.substr(i, 2), nullptr, 16)));
		if (proto.code.size() != words * 4) throw std::runtime_error("encounter_entry_protos.txt: code size of " + key);
		protos[proto.key] = std::move(proto);
	}
	return protos;
}

void r19_railjack_encounters(const std::filesystem::path& fixtures)
{
	constexpr std::uint64_t fighters = 0xfeb4ca192ef69f0aull, crewships = 0xe773280ca7743441ull, corpus = 0x0a6394a10884c38aull;
	constexpr std::uint64_t pontis_ash = 0x434d0132e720ed37ull, pontis_garuda = 0x52145531e84e69caull;
	constexpr std::uint64_t railjack_patrol = 0x96d6dcb371caa708ull;   // Grineer patrols: no kill-goal parameter
	constexpr std::uint32_t minor = 0x288044d3u, minor_max = 0xe290a5e6u, lich_min = 0xd4a29101u, lich_max = 0x1026ad29u;
	constexpr std::uint32_t major = 0x8cf8f4a0u, lich = 0x240bcba8u;
	const auto dir = fixtures / "MissionsR19";
	const std::string text = read_text(dir / "engine_params.json");
	settings::Declarations declarations;
	{
		packages::Manifest parsed;
		const auto error = packages::parse_manifest(read_text(dir / "package.json"), parsed);
		std::vector<std::pair<std::string, std::string>> members;
		for (const auto& member : parsed.members)
			if (!member.settings_json.empty()) members.emplace_back(member.filename, member.settings_json);
		const auto declared = settings::parse_declarations(parsed.settings_json, members, declarations);
		check(error.empty() && declared.empty() && declarations.value("railjack.fighter_kills_scale") != nullptr
				&& declarations.value("railjack.crewship_kills_scale") != nullptr,
			"R19 fixture package.json parses (" + std::to_string(declarations.values.size()) + " declarations)");
	}
	ep::Recipe recipe;
	const auto parse_error = ep::parse_recipe(text, "package:missions", recipe);
	std::size_t railjack = 0, railjack_with_master = 0;
	for (const auto& item : recipe.overrides)
	{
		if (item.value.rfind("railjack.", 0) != 0) continue;
		++railjack;
		railjack_with_master += item.master == "railjack.kill_goals_scale" && item.scale == 1.0 ? 1 : 0;
	}
	const auto modules = recipe.modules();
	const auto names = [&](std::uint64_t key) { return std::find(modules.begin(), modules.end(), key) != modules.end(); };
	check(parse_error.empty() && ep::validate_recipe(recipe, declarations, seed).empty() && recipe.overrides.size() == 17
			&& recipe.value_ids().size() == 11 && modules.size() == 8 && railjack == 10 && railjack_with_master == 10,
		"R19 the generated engine_params.json parses and validates: 17 overrides, 11 values, 8 modules; all 10 Railjack overrides "
		"(Grineer fighters x4, crewships x2, Corpus x2, Pontis x2) name the Railjack master (" + parse_error + ")");

	// E1: the recipe names every Railjack encounter module, so its natural load is recorded (production attach_recipe and
	// module_wanted, hook installed). The R17 recipe named only the Corpus patrol module, which is why the live R17 hook
	// could not attribute the KillFighters writes.
	{
		ep::Recipe r17;
		(void)ep::parse_recipe(read_text(fixtures / "MissionsR17" / "engine_params.json"), "package:missions", r17);
		const auto r17_modules = r17.modules();
		const bool r17_named = std::find(r17_modules.begin(), r17_modules.end(), fighters) != r17_modules.end()
			|| std::find(r17_modules.begin(), r17_modules.end(), crewships) != r17_modules.end();
		ep::gate_set_installed(&build_44_0_2());
		packages::Package package;
		package.id = "package:missions";
		package.folder = "Missions";
		ep::attach_recipe(package, dir / "engine_params.json");
		check(!r17_named && names(fighters) && names(crewships) && names(corpus) && names(pontis_ash) && names(pontis_garuda)
				&& package.engine_recipe != nullptr && ep::module_wanted(fighters) && ep::module_wanted(crewships)
				&& ep::module_wanted(corpus) && !ep::module_wanted(railjack_patrol),
			"R19 E1 the recipe names KillFighters, KillCrewShips, BasicRailJackPatrol and both Pontis modules (the R17 recipe named "
			"neither Grineer module): their natural loads are recorded; RailjackPatrol is not wanted");
		ep::gate_set_installed(nullptr);
	}

	const auto protos = read_entry_protos(dir / "encounter_entry_protos.txt");
	check(protos.size() == 3 && protos.at(fighters).code.size() == 126 * 4 && protos.at(fighters).bytecode_id == 9
			&& protos.at(crewships).bytecode_id == 9 && protos.at(corpus).bytecode_id == 15
			&& starts(protos.at(fighters).module_sha256, "870d531df5117518") && starts(protos.at(crewships).module_sha256, "741a81ad4b150ecd")
			&& starts(protos.at(corpus).module_sha256, "fa1553b18402becc"),
		"R19 the real entry prototypes: KillFighters P9 (126 words, as the live trace recorded it), KillCrewShips P9, "
		"BasicRailJackPatrol P15, from the registered stock modules");

	const auto delivery_of = [](std::vector<settings::DeliveredValue> values)
	{
		settings::MemberDelivery delivery;
		delivery.values = std::move(values);
		delivery.identity = settings::delivery_identity(delivery.values);
		return delivery;
	};
	// The writer model on a frame whose function slot is the real entry prototype of `key`, recorded as a natural load.
	struct Write { std::vector<float> values; bool overridden = true; bool unknown = true; std::uint64_t key = ~0ull; std::size_t pushes = 0; };
	const auto write = [&](const ep::PlanSnapshot& plan, std::uint64_t key, bool recorded, std::uint32_t hash, const std::vector<float>& level)
	{
		Frame frame(0x7ff00000, protos.at(key).code, protos.at(key).bytecode_id);
		ep::IdentitySnapshot identities;
		if (recorded) identities.modules.push_back(frame.identity(key));
		ModelMemory memory;
		const bool array = level.size() > 1;
		const auto record = array ? array_record(frame, level) : scalar_record(frame, 0, level[0]);
		const auto before = frame.stock_pushes;
		const auto result = apply_param(frame, memory, plan, identities, record, hash, array ? level.size() : 0);
		Write out;
		out.values = result.values;
		out.pushes = frame.stock_pushes - before;
		for (const auto& outcome : result.outcomes)
		{
			out.overridden = out.overridden && outcome.overridden;
			out.unknown = out.unknown && outcome.skip == ep::Skip::ModuleUnknown && !outcome.overridden;
			if (out.key == ~0ull) out.key = outcome.key;
			else if (out.key != outcome.key) out.key = 0xbad;
		}
		return out;
	};
	const auto equal = [](const std::vector<float>& a, const std::vector<float>& b)
	{
		if (a.size() != b.size()) return false;
		for (std::size_t i = 0; i != a.size(); ++i)
			if (std::fabs(a[i] - b[i]) > 1e-4f) return false;
		return true;
	};
	// The lists the engine wrote in the live session (Steel Path, six tiers) and the base Corpus list.
	const std::vector<float> sp_minor{20, 35, 55, 70, 85, 95}, sp_minor_max{35, 55, 85, 90, 95, 105}, sp_major{2, 4, 6, 7, 8, 9};
	const std::vector<float> corpus_minor{20, 35, 55, 85, 110};

	// E2: the live settings (master 0.1, fighters 0.1, crewships 0.1) through the writer: exactly the numbers the R10 entry
	// write logged, now stored by the engine itself, one stock push per value, attributed to the exact module.
	{
		const auto live = delivery_of({{"railjack.crewship_kills_scale", 0.1f, 1.0f}, {"railjack.fighter_kills_scale", 0.1f, 1.0f},
			{"railjack.kill_goals_scale", 0.1f, 1.0f}, {"survival.reward_interval", 150.0f, 300.0f}});
		const auto plan = ep::make_snapshot(ep::resolve_entries(recipe, &live), recipe.modules());
		check(plan->entries.size() == 10,
			"R19 E2 the installed values (master, fighters, crewships 0.1) give a plan of 10 overrides: fighters 4 + crewships 2 "
			"(own values) + Corpus 2 + Pontis 2 (master); the startup line reads applying=10 withheld_from_addon=11");
		const auto a = write(*plan, fighters, true, minor, sp_minor);
		const auto b = write(*plan, fighters, true, minor_max, sp_minor_max);
		const auto c = write(*plan, fighters, true, lich_min, {50});
		const auto d = write(*plan, fighters, true, lich_max, {60});
		check(equal(a.values, {2, 4, 6, 7, 9, 10}) && equal(b.values, {4, 6, 9, 9, 10, 11}) && equal(c.values, {5}) && equal(d.values, {6})
				&& a.overridden && b.overridden && c.overridden && d.overridden && a.key == fighters && a.pushes == 6 && c.pushes == 1,
			"R19 E2 KillFighters P9 (recorded): the writer stores {2/4/6/7/9/10}, {4/6/9/9/10/11}, 5, 6 for master 0.1 + fighters 0.1 "
			"(the live entry-write numbers), one stock push per value");
		const auto e = write(*plan, crewships, true, major, sp_major);
		const auto f = write(*plan, crewships, true, lich, {3});
		check(equal(e.values, {1, 1, 1, 1, 1, 1}) && equal(f.values, {1}) && e.overridden && f.overridden && e.key == crewships,
			"R19 E2 KillCrewShips P9 (recorded): crewships 0.1 -> {1/1/1/1/1/1} and Lich 3 -> 1 (at least one)");
		const auto g = write(*plan, corpus, true, minor, corpus_minor);
		check(equal(g.values, {2, 4, 6, 9, 11}) && g.overridden && g.key == corpus,
			"R19 E2 the same parameter name (minorKillGoals 288044d3) in BasicRailJackPatrol P15 gets the Corpus row (master 0.1): "
			"{2/4/6/9/11}; the plan is keyed by (exact content key, hash)");
		const auto withheld = ep::withhold(live, recipe.value_ids());
		check(withheld->values.size() == 2 && withheld->values[0].id == "railjack.kill_goals_scale"
				&& withheld->values[1].id == "survival.reward_interval",
			"R19 E2 with the hook installed the addon gets the master and the other values, never the Grineer rows (no double application)");
	}
	{
		const auto split = delivery_of({{"railjack.corpus_fighter_limit_scale", 0.5f, 1.0f}, {"railjack.fighter_kills_scale", 0.1f, 1.0f}});
		const auto plan = ep::make_snapshot(ep::resolve_entries(recipe, &split), recipe.modules());
		const auto grineer = write(*plan, fighters, true, minor, sp_minor);
		const auto corp = write(*plan, corpus, true, minor, corpus_minor);
		check(equal(grineer.values, {2, 4, 6, 7, 9, 10}) && equal(corp.values, {10, 18, 28, 43, 55}),
			"R19 E2 one hash, two modules, two values: KillFighters x0.1 and BasicRailJackPatrol x0.5 in the same plan");
	}

	// E3: the R17 live state, reproduced: the R17 recipe (the live plan had only the Corpus entries) and a KillFighters module
	// that was never recorded. Every element stays stock with module-identity-unknown (renovice_source.log L45012-45023:
	// hash 288044d3 / e290a5e6, index 0..5). Recorded but not in the R17 plan: no-override-for-module, also stock.
	{
		ep::Recipe r17;
		(void)ep::parse_recipe(read_text(fixtures / "MissionsR17" / "engine_params.json"), "package:missions", r17);
		const auto live = delivery_of({{"railjack.crewship_kills_scale", 0.1f, 1.0f}, {"railjack.fighter_kills_scale", 0.1f, 1.0f},
			{"railjack.kill_goals_scale", 0.1f, 1.0f}});
		const auto plan = ep::make_snapshot(ep::resolve_entries(r17, &live), r17.modules());
		const auto a = write(*plan, fighters, false, minor, sp_minor);
		const auto b = write(*plan, fighters, false, minor_max, sp_minor_max);
		check(plan->entries.size() == 2 && a.unknown && b.unknown && a.key == 0 && equal(a.values, sp_minor) && equal(b.values, sp_minor_max)
				&& a.pushes == 6 && b.pushes == 6,
			"R19 E3 the R17 live state: KillFighters not in the recipe, never recorded -> 12 writes left stock with "
			"module-identity-unknown key=0 (the live SKIP lines)");
		Frame frame(0x7ff00000, protos.at(fighters).code, protos.at(fighters).bytecode_id);
		ep::IdentitySnapshot identities;
		identities.modules.push_back(frame.identity(fighters));
		ModelMemory memory;
		const auto record = array_record(frame, sp_minor);
		const auto result = apply_param(frame, memory, *plan, identities, record, minor, sp_minor.size());
		bool not_declared = true;
		for (const auto& outcome : result.outcomes) not_declared = not_declared && outcome.skip == ep::Skip::OverrideNotDeclared;
		check(not_declared && equal(result.values, sp_minor) && memory.writes == 0,
			"R19 E3 recorded but not in the R17 plan: no-override-for-module, stock kept, nothing written");
	}

	// E4: a module reloaded every mission (a new root each load): the newest load is attributed; a freed older load whose
	// code was reused is not; at most 8 loads per (key, vm) are kept.
	{
		const auto live = delivery_of({{"railjack.fighter_kills_scale", 0.1f, 1.0f}});
		const auto plan = ep::make_snapshot(ep::resolve_entries(recipe, &live), recipe.modules());
		ep::IdentitySnapshot identities;
		std::vector<std::unique_ptr<Frame>> loads;
		for (int load = 0; load != 9; ++load)
		{
			loads.push_back(std::make_unique<Frame>(0x7ff00000, protos.at(fighters).code, protos.at(fighters).bytecode_id));
			auto module = loads.back()->identity(fighters);
			module.sequence = static_cast<std::uint64_t>(load + 1);
			identities = *ep::with_module(identities, module);
		}
		ModelMemory memory;
		Frame& newest = *loads.back();
		const auto record = array_record(newest, sp_minor);
		const auto now = apply_param(newest, memory, *plan, identities, record, minor, sp_minor.size());
		Frame& oldest = *loads.front();
		oldest.arena.put<std::uint8_t>(oldest.code, 0xee);   // the first load was freed and its memory reused
		const auto old_record = array_record(oldest, sp_minor);
		const auto stale = apply_param(oldest, memory, *plan, identities, old_record, minor, sp_minor.size());
		check(identities.modules.size() == 8 && equal(now.values, {2, 4, 6, 7, 9, 10}) && now.outcomes[0].key == fighters
				&& stale.outcomes[0].skip == ep::Skip::ModuleUnknown && equal(stale.values, sp_minor),
			"R19 E4 per-mission reloads: 8 loads kept, the newest is attributed (x0.1), a freed reused one stays stock");
	}

	// E5: master and row precedence, checked on the values the writer actually stores.
	{
		const auto stored = [&](std::vector<settings::DeliveredValue> values, std::uint64_t key, std::uint32_t hash, const std::vector<float>& level)
		{
			const auto delivery = delivery_of(std::move(values));
			const auto plan = ep::make_snapshot(ep::resolve_entries(recipe, &delivery), recipe.modules());
			return write(*plan, key, true, hash, level);
		};
		const auto master_only = stored({{"railjack.kill_goals_scale", 0.1f, 1.0f}}, fighters, minor, sp_minor);
		const auto master_only_crew = stored({{"railjack.kill_goals_scale", 0.1f, 1.0f}}, crewships, major, sp_major);
		check(equal(master_only.values, {2, 4, 6, 7, 9, 10}) && master_only.overridden && equal(master_only_crew.values, {1, 1, 1, 1, 1, 1}),
			"R19 E5 master 0.1 alone (rows off): the writer stores x0.1 for fighters and crewships");
		const auto at_stock = stored({{"railjack.kill_goals_scale", 1.0f, 1.0f}}, crewships, major, sp_major);
		check(equal(at_stock.values, sp_major) && !at_stock.overridden,
			"R19 E5 master on at its stock x1, rows off (the R17 live run 1 settings): no override, {2/4/6/7/8/9} stays");
		const auto row_wins = stored({{"railjack.kill_goals_scale", 0.1f, 1.0f}, {"railjack.crewship_kills_scale", 1.0f, 1.0f}}, crewships, major, sp_major);
		const auto row_half = stored({{"railjack.kill_goals_scale", 0.1f, 1.0f}, {"railjack.crewship_kills_scale", 0.5f, 1.0f}}, crewships, major, sp_major);
		const auto lich_half = stored({{"railjack.crewship_kills_scale", 0.5f, 1.0f}}, crewships, lich, {3});
		check(equal(row_wins.values, sp_major) && row_wins.overridden && equal(row_half.values, {1, 2, 3, 4, 4, 5}) && equal(lich_half.values, {2}),
			"R19 E5 a row that is on wins over the master: crewships x1 keeps {2/4/6/7/8/9}, x0.5 stores {1/2/3/4/4/5}, Lich 3 -> 2");
	}
}

// Contract R21 (2026-10-02): class audit after R19. R19 showed that a level or
// encounter parameter classed REACHES (read inside the entry call, before any
// yield) can still miss the R10 Lua entry write in game. The last two rows on
// that plain entry write are level ScriptTrigger parameters whose only producer
// is the engine writer: Spy "vault alarm time" (Intel P43 VaultAlarmTriggered,
// intelTimerDurationMax/Min, scale) and Sabotage "surprise extraction"
// (Sabotage P11 reactorDestroyedFunction, duration, absolute). Both are owned at
// the writer now. Fixture: the R21 Missions build (fixtures/MissionsR21) and the
// real entry prototypes of both trigger modules (trigger_entry_protos.txt, from
// the 44.0.2 stock bytes). No runtime change: the same primitive as R16-R19.
void r21_level_trigger_params(const std::filesystem::path& fixtures)
{
	constexpr std::uint64_t intel = 0xee15b583788c3e7dull, sabotage = 0x7e0adf2d83f7a086ull;
	constexpr std::uint32_t alarm_max = 0xe7743c68u, alarm_min = 0xb8882841u, duration = 0xf4de5c39u;
	const auto dir = fixtures / "MissionsR21";
	const std::string text = read_text(dir / "engine_params.json");
	settings::Declarations declarations;
	{
		packages::Manifest parsed;
		const auto error = packages::parse_manifest(read_text(dir / "package.json"), parsed);
		std::vector<std::pair<std::string, std::string>> members;
		for (const auto& member : parsed.members)
			if (!member.settings_json.empty()) members.emplace_back(member.filename, member.settings_json);
		const auto declared = settings::parse_declarations(parsed.settings_json, members, declarations);
		check(error.empty() && declared.empty() && declarations.value("spy.vault_alarm_scale") != nullptr
				&& declarations.value("sabotage.random_extraction_timer") != nullptr,
			"R21 fixture package.json parses (" + std::to_string(declarations.values.size()) + " declarations; the R20 package.json)");
	}
	ep::Recipe recipe;
	const auto parse_error = ep::parse_recipe(text, "package:missions", recipe);
	std::size_t spy = 0, extraction = 0, mastered = 0;
	for (const auto& item : recipe.overrides)
	{
		spy += item.value == "spy.vault_alarm_scale" && item.module == intel && item.mode == ep::Mode::Scale ? 1 : 0;
		extraction += item.value == "sabotage.random_extraction_timer" && item.module == sabotage && item.mode == ep::Mode::Absolute ? 1 : 0;
		mastered += (item.value == "spy.vault_alarm_scale" || item.value == "sabotage.random_extraction_timer") && !item.master.empty() ? 1 : 0;
	}
	const auto modules = recipe.modules();
	const auto names = [&](std::uint64_t key) { return std::find(modules.begin(), modules.end(), key) != modules.end(); };
	check(parse_error.empty() && ep::validate_recipe(recipe, declarations, seed).empty() && recipe.overrides.size() == 20
			&& recipe.value_ids().size() == 13 && modules.size() == 10 && spy == 2 && extraction == 1 && mastered == 0,
		"R21 the generated engine_params.json parses and validates: 20 overrides, 13 values, 10 modules; Spy alarm = 2 scale "
		"overrides on Intel, surprise extraction = 1 absolute override on Sabotage, no master on either (" + parse_error + ")");

	// F1: the installed R19/R20 recipe names neither trigger module, so their loads were never recorded and only the R10 Lua
	// entry write could reach them; the R21 recipe names both (production attach_recipe and module_wanted, hook installed).
	{
		ep::Recipe r19;
		(void)ep::parse_recipe(read_text(fixtures / "MissionsR19" / "engine_params.json"), "package:missions", r19);
		const auto r19_modules = r19.modules();
		const bool r19_named = std::find(r19_modules.begin(), r19_modules.end(), intel) != r19_modules.end()
			|| std::find(r19_modules.begin(), r19_modules.end(), sabotage) != r19_modules.end();
		ep::gate_set_installed(&build_44_0_2());
		const bool wanted_before = ep::module_wanted(intel) || ep::module_wanted(sabotage);
		packages::Package package;
		package.id = "package:missions";
		package.folder = "Missions";
		ep::attach_recipe(package, dir / "engine_params.json");
		check(!r19_named && !wanted_before && names(intel) && names(sabotage) && package.engine_recipe != nullptr
				&& ep::module_wanted(intel) && ep::module_wanted(sabotage),
			"R21 F1 the R19/R20 recipe names neither Intel nor Sabotage (never recorded: R10 entry write only); the R21 recipe names "
			"both, so their natural loads are recorded");
		ep::gate_set_installed(nullptr);
	}

	const auto protos = read_entry_protos(dir / "trigger_entry_protos.txt");
	check(protos.size() == 2 && protos.at(intel).bytecode_id == 43 && protos.at(intel).code.size() == 517 * 4
			&& protos.at(sabotage).bytecode_id == 11 && protos.at(sabotage).code.size() == 326 * 4
			&& starts(protos.at(intel).module_sha256, "51b3a553da84d23c") && starts(protos.at(sabotage).module_sha256, "0f1e3d2d0a2becb2"),
		"R21 the real entry prototypes: Intel P43 VaultAlarmTriggered (517 words), Sabotage P11 reactorDestroyedFunction (326 words), "
		"from the registered stock modules");

	const auto delivery_of = [](std::vector<settings::DeliveredValue> values)
	{
		settings::MemberDelivery delivery;
		delivery.values = std::move(values);
		delivery.identity = settings::delivery_identity(delivery.values);
		return delivery;
	};
	struct Write { float value = 0; bool overridden = false; ep::Skip skip = ep::Skip::None; std::uint64_t key = 0; std::size_t pushes = 0; };
	const auto write = [&](Frame& frame, const ep::PlanSnapshot& plan, const ep::IdentitySnapshot& identities, std::uint32_t hash, float level)
	{
		ModelMemory memory;
		const auto record = scalar_record(frame, 0, level);
		const auto before = frame.stock_pushes;
		const auto result = apply_param(frame, memory, plan, identities, record, hash, 0);
		Write out;
		out.value = result.values.at(0);
		out.overridden = result.outcomes.at(0).overridden;
		out.skip = result.outcomes.at(0).skip;
		out.key = result.outcomes.at(0).key;
		out.pushes = frame.stock_pushes - before;
		return out;
	};
	const auto close_to = [](float a, float b) { return std::fabs(a - b) < 1e-3f; };
	const auto recorded = [&](Frame& frame, std::uint64_t key)
	{
		ep::IdentitySnapshot identities;
		identities.modules.push_back(frame.identity(key));
		return identities;
	};

	// F2: the writer's output on the real entry prototypes (recorded natural load): Spy x0.5 on the most common pair 55/35 and
	// the widest pair 120/90, surprise extraction 300 -> 120; one stock push per value; the addon gets neither value.
	const auto live = delivery_of({{"sabotage.random_extraction_timer", 120.0f, 300.0f}, {"spy.vault_alarm_scale", 0.5f, 1.0f},
		{"survival.reward_interval", 150.0f, 300.0f}});
	const auto plan = ep::make_snapshot(ep::resolve_entries(recipe, &live), recipe.modules());
	{
		Frame vault(0x7ff00000, protos.at(intel).code, protos.at(intel).bytecode_id);
		const auto ids = recorded(vault, intel);
		const auto a = write(vault, *plan, ids, alarm_max, 55.0f);
		const auto b = write(vault, *plan, ids, alarm_min, 35.0f);
		const auto c = write(vault, *plan, ids, alarm_max, 120.0f);
		const auto d = write(vault, *plan, ids, alarm_min, 90.0f);
		check(plan->entries.size() == 3 && close_to(a.value, 27.5f) && close_to(b.value, 17.5f) && close_to(c.value, 60.0f) && close_to(d.value, 45.0f)
				&& a.overridden && b.overridden && c.overridden && d.overridden && a.key == intel && a.pushes == 1 && d.pushes == 1,
			"R21 F2 Intel P43 (recorded): Spy alarm x0.5 -> 55/35 stored as 27.5/17.5, 120/90 as 60/45 (per vault), one stock push each");
		Frame trigger(0x7ff00000, protos.at(sabotage).code, protos.at(sabotage).bytecode_id);
		const auto e = write(trigger, *plan, recorded(trigger, sabotage), duration, 300.0f);
		check(close_to(e.value, 120.0f) && e.overridden && e.key == sabotage && e.pushes == 1,
			"R21 F2 Sabotage P11 (recorded): surprise extraction 300 -> 120 (absolute), one stock push");
		const auto withheld = ep::withhold(live, recipe.value_ids());
		check(withheld->values.size() == 1 && withheld->values[0].id == "survival.reward_interval",
			"R21 F2 with the hook installed the addon gets neither R21 value (no double application with the R10 fallback)");
	}

	// F3: the R19 failure order on the writer: the engine writes, the native entry runs (the addon writes nothing: withheld),
	// the engine writes again three times; every stored value is the configured one. Control: the installed R19/R20 recipe on
	// the same frame: neither hash is declared (and the module is never recorded), every write keeps the level value
	// (hash-not-declared, the fast exit), i.e. only the R10 Lua entry write exists, the route R19 refuted live.
	{
		ep::Recipe r19;
		(void)ep::parse_recipe(read_text(fixtures / "MissionsR19" / "engine_params.json"), "package:missions", r19);
		const auto old_plan = ep::make_snapshot(ep::resolve_entries(r19, &live), r19.modules());
		Frame vault(0x7ff00000, protos.at(intel).code, protos.at(intel).bytecode_id);
		Frame trigger(0x7ff00000, protos.at(sabotage).code, protos.at(sabotage).bytecode_id);
		const auto vault_ids = recorded(vault, intel);
		const auto trigger_ids = recorded(trigger, sabotage);
		bool survives = true;
		for (int pass = 0; pass != 4; ++pass)
		{
			const auto a = write(vault, *plan, vault_ids, alarm_max, 55.0f);
			const auto b = write(vault, *plan, vault_ids, alarm_min, 35.0f);
			const auto c = write(trigger, *plan, trigger_ids, duration, 300.0f);
			survives = survives && close_to(a.value, 27.5f) && close_to(b.value, 17.5f) && close_to(c.value, 120.0f) && a.overridden && c.overridden;
		}
		check(survives, "R21 F3 R19 order on the writer: the first write and 3 re-writes all store the configured values (Spy 27.5/17.5, extraction 120)");
		const ep::IdentitySnapshot none;
		const auto x = write(vault, *old_plan, none, alarm_max, 55.0f);
		const auto y = write(trigger, *old_plan, none, duration, 300.0f);
		check(close_to(x.value, 55.0f) && close_to(y.value, 300.0f) && x.skip == ep::Skip::HashNotDeclared && y.skip == ep::Skip::HashNotDeclared
				&& !x.overridden && !y.overridden && x.pushes == 1 && old_plan->entries.empty(),
			"R21 F3 control, the installed R19/R20 recipe: no plan entry for either module, the writer keeps 55 and 300 "
			"(hash-not-declared, one stock push): the R10 entry write was the only owner");
	}

	// F4: the minimums (R20 rule): Spy 0.001 -> 0.055/0.035; surprise extraction at its minimum 1 s.
	{
		const auto low = delivery_of({{"sabotage.random_extraction_timer", 1.0f, 300.0f}, {"spy.vault_alarm_scale", 0.001f, 1.0f}});
		const auto low_plan = ep::make_snapshot(ep::resolve_entries(recipe, &low), recipe.modules());
		Frame vault(0x7ff00000, protos.at(intel).code, protos.at(intel).bytecode_id);
		Frame trigger(0x7ff00000, protos.at(sabotage).code, protos.at(sabotage).bytecode_id);
		const auto a = write(vault, *low_plan, recorded(vault, intel), alarm_max, 55.0f);
		const auto b = write(vault, *low_plan, recorded(vault, intel), alarm_min, 35.0f);
		const auto c = write(trigger, *low_plan, recorded(trigger, sabotage), duration, 300.0f);
		check(std::fabs(a.value - 0.055f) < 1e-5f && std::fabs(b.value - 0.035f) < 1e-5f && close_to(c.value, 1.0f) && a.overridden && c.overridden,
			"R21 F4 at the minimums: Spy 0.001 stores 0.055/0.035, surprise extraction stores 1");
	}
}

int main(int argc, char** argv)
{
	if (argc < 5 || (argc - 3) % 2 != 0)
	{
		std::cerr << "usage: verify_engine_params <work dir> <fixture dir> <exe|-> <sha256|-> [<exe> <sha256>]...\n";
		return 2;
	}
	const std::filesystem::path work = argv[1];
	const std::filesystem::path fixtures = argv[2];
	const std::string recipe_text = read_text(fixtures / "Missions" / "engine_params.json");
	settings::Declarations declarations;
	{
		const auto manifest = read_text(fixtures / "Missions" / "package.json");
		packages::Manifest parsed;
		const auto error = packages::parse_manifest(manifest, parsed);
		std::vector<std::pair<std::string, std::string>> members;
		for (const auto& member : parsed.members)
			if (!member.settings_json.empty()) members.emplace_back(member.filename, member.settings_json);
		const auto declared = settings::parse_declarations(parsed.settings_json, members, declarations);
		check(error.empty() && declared.empty() && declarations.values.size() == 372, "fixture package.json parses (372 declarations)");
	}
	try
	{
		pure_rules(recipe_text, declarations);
		r17_masters(fixtures);  // R17
		ep::Recipe recipe;
		(void)ep::parse_recipe(recipe_text, "package:missions", recipe);
		hook_decision(recipe);
		package_scan(work, fixtures);
		for (int i = 3; i + 1 < argc; i += 2) image_bytes(argv[i], argv[i + 1]);
		// R19 last: its E1 attach adds the Railjack modules to the process-owned wanted set (C2 counts that set).
		r19_railjack_encounters(fixtures);
		// R21 after R19: F1 checks that nothing wanted Intel or Sabotage before the R21 attach.
		r21_level_trigger_params(fixtures);
	}
	catch (const std::exception& error)
	{
		check(false, std::string("exception: ") + error.what());
	}
	std::cout << (failures == 0 ? "ENGINE PARAMS GATES PASS" : "ENGINE PARAMS GATES FAIL") << " checks=" << checks
		<< " failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
