#pragma once

// ENGINE_PARAM_OVERRIDE (contract R16, 2026-10-01): a declared level/encounter
// script parameter keeps the configured value through every engine write.
//
// Why. A level ScriptTrigger or encounter parameter `_name=value` is written
// by the engine's own parameter writer (44.0.2 apply_param 0x181CAE0:
// `getfenv(fn)[hash(name)] = typed value`) into the script instance's
// environment, and several engine paths call it again on an existing
// instance (R15 research record, native evidence of 2026-10-01). A
// one-time Lua write at the entry (R10 SCRIPT_PARAM_GLOBAL_AT_ENTRY) is
// therefore not the owner: the next engine write puts the level value back.
// The authoritative boundary is the writer itself.
//
// Mechanism. A process-owned detour on the writer's value push (push_value,
// engine_params_builds.hpp) calls the stock push exactly once with the
// original arguments and, when the parameter (module key + name hash) matches
// a declared override of the committed generation, replaces the number it
// just pushed (stock x value, stock / value, value, or the R11 count rule)
// before the engine stores it. No Lua runs, no VM API is called, no Lua
// object is retained: the hook reads the four stack slots the writer owns and
// rewrites the one number slot the stock push created.
//
// Declarations. A package may ship `engine_params.json` next to package.json:
// {
//   "format": "RENOVICE_ENGINE_PARAMS_V1",
//   "package": "package:<folder lower>",
//   "build": "<client build>",                 // equals package.json settings.build
//   "member": "<addon member filename>",       // whose ADDON_SETTINGS_V1 values drive the overrides
//   "overrides": [ { "value": "<value id>", "module": "<16 hex stock content key>",
//                    "parameter": "<name without _>", "hash": "<8 hex U44 name hash>",
//                    "mode": "scale" | "scale_inverse" | "absolute" | "scale_count" } ]
// }
// The value is an addon-lane int/float value of `member`. Its delivered value
// (the exact number the addon would get in context.settings) drives the
// override. When the native lane is installed, every value the recipe names
// is WITHHELD from the member's context.settings, so the addon's own R10 Lua
// write for it stays off (no double application). Without the lane (older
// DLL: the file is ignored; unregistered build or a hook failure: nothing is
// withheld) the R10 Lua lane keeps the value: backward compatible.
//
// Everything here is pure and deterministic; the offline gate
// (RENOVICE_TOOLCHAIN/engine_params/verify_engine_params.ps1) runs these exact
// rules. Nothing names a mission, a module or a value.

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <initializer_list>
#include <map>
#include <memory>
#include <set>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "engine_params_builds.hpp"
#include "settings_core.hpp"

namespace renovice::engine_params
{
inline constexpr std::string_view recipe_filename = "engine_params.json";
inline constexpr std::string_view recipe_format = "RENOVICE_ENGINE_PARAMS_V1";
inline constexpr std::size_t maximum_recipe_bytes = 256u * 1024u;
inline constexpr std::size_t maximum_overrides = 256;
inline constexpr std::size_t maximum_identities_per_module = 8;
inline constexpr std::size_t maximum_code_bytes = 4u * 1024u * 1024u;

enum class Mode : std::uint8_t { Scale, ScaleInverse, Absolute, ScaleCount };

inline const char* mode_label(Mode mode) noexcept
{
	switch (mode)
	{
	case Mode::Scale: return "scale";
	case Mode::ScaleInverse: return "scale_inverse";
	case Mode::Absolute: return "absolute";
	case Mode::ScaleCount: return "scale_count";
	}
	return "unknown";
}

inline bool parse_mode(std::string_view text, Mode& mode) noexcept
{
	if (text == "scale") mode = Mode::Scale;
	else if (text == "scale_inverse") mode = Mode::ScaleInverse;
	else if (text == "absolute") mode = Mode::Absolute;
	else if (text == "scale_count") mode = Mode::ScaleCount;
	else return false;
	return true;
}

// U44 name hash (44.0.2 RVA 0x131C120): FNV-1a 32 from the build's seed, then
// not, then rotate left 17. Same rule as the generator's de_name_hash.
inline std::uint32_t name_hash(std::string_view name, std::uint32_t seed) noexcept
{
	std::uint32_t hash = seed;
	for (const unsigned char c : name)
	{
		hash ^= c;
		hash *= 0x01000193u;
	}
	hash = ~hash;
	return (hash << 17) | (hash >> 15);
}

// The R10/R11 SCRIPT_PARAM_GLOBAL_AT_ENTRY arithmetic, in the DE VM's float32
// numbers (the delivered value and the parameter are both float32):
//   scale          current x value
//   scale_inverse  current / value
//   absolute       value
//   scale_count    n < 1 stays n; otherwise floor(n x value + 0.5), at least 1
// false: leave the stock number (non-finite input or result, value 0 for an
// inverse).
inline bool override_number(Mode mode, float current, float value, float& out) noexcept
{
	if (!std::isfinite(current) || !std::isfinite(value)) return false;
	switch (mode)
	{
	case Mode::Absolute:
		out = value;
		break;
	case Mode::Scale:
		out = current * value;
		break;
	case Mode::ScaleInverse:
		if (value == 0.0f) return false;
		out = current / value;
		break;
	case Mode::ScaleCount:
		if (current < 1.0f)
		{
			out = current;
			break;
		}
		{
			float rounded = current * value + 0.5f;
			rounded = std::floor(rounded);
			out = rounded < 1.0f ? 1.0f : rounded;
		}
		break;
	default:
		return false;
	}
	return std::isfinite(out);
}

// ---------------------------------------------------------------------------
// Recipe
// ---------------------------------------------------------------------------
struct OverrideDecl
{
	std::string value;
	std::uint64_t module = 0;
	std::string parameter;
	std::uint32_t hash = 0;
	Mode mode = Mode::Absolute;
};

struct Recipe
{
	std::string package;
	std::string build;
	std::string member;
	std::vector<OverrideDecl> overrides;   // file order
	[[nodiscard]] std::set<std::string> value_ids() const
	{
		std::set<std::string> ids;
		for (const auto& item : overrides) ids.insert(item.value);
		return ids;
	}
	[[nodiscard]] std::vector<std::uint64_t> modules() const
	{
		std::vector<std::uint64_t> keys;
		for (const auto& item : overrides) keys.push_back(item.module);
		std::sort(keys.begin(), keys.end());
		keys.erase(std::unique(keys.begin(), keys.end()), keys.end());
		return keys;
	}
};

inline std::string hex64(std::uint64_t value)
{
	static constexpr char digits[] = "0123456789abcdef";
	std::string text(16, '0');
	for (int i = 15; i >= 0; --i)
	{
		text[static_cast<std::size_t>(i)] = digits[value & 0xFu];
		value >>= 4;
	}
	return text;
}

inline std::string hex32(std::uint32_t value)
{
	static constexpr char digits[] = "0123456789abcdef";
	std::string text(8, '0');
	for (int i = 7; i >= 0; --i)
	{
		text[static_cast<std::size_t>(i)] = digits[value & 0xFu];
		value >>= 4;
	}
	return text;
}

namespace detail
{
inline bool parse_hex_word(std::string_view text, std::size_t digits, std::uint64_t& out) noexcept
{
	if (text.size() != digits) return false;
	std::uint64_t value = 0;
	for (const char c : text)
	{
		int digit = -1;
		if (c >= '0' && c <= '9') digit = c - '0';
		else if (c >= 'a' && c <= 'f') digit = c - 'a' + 10;
		else return false; // lower-case only: one spelling per key
		value = (value << 4) | static_cast<std::uint64_t>(digit);
	}
	out = value;
	return true;
}

inline bool identifier(std::string_view text) noexcept
{
	if (text.empty() || text.size() > 64) return false;
	const auto alpha = [](char c) { return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_'; };
	if (!alpha(text.front())) return false;
	for (const char c : text)
		if (!alpha(c) && !(c >= '0' && c <= '9')) return false;
	return true;
}

inline bool only_fields(const settings::json::Value& object, std::initializer_list<std::string_view> allowed, std::string& unknown)
{
	for (const auto& [key, field] : object.members)
	{
		(void)field;
		if (std::find(allowed.begin(), allowed.end(), key) == allowed.end())
		{
			unknown = key;
			return false;
		}
	}
	return true;
}
}

// Parses engine_params.json. Empty string on success, otherwise the exact
// reason that rejects ONLY this package's engine-parameter capability.
inline std::string parse_recipe(std::string_view text, std::string_view expected_package, Recipe& out)
{
	out = Recipe{};
	if (text.size() > maximum_recipe_bytes) return "recipe-too-large";
	settings::json::Value root;
	if (auto error = settings::json::parse(text, root); !error.empty()) return "recipe-" + error;
	if (!root.is_object()) return "recipe-not-object";
	std::string unknown;
	if (!detail::only_fields(root, {"format", "package", "build", "member", "overrides"}, unknown))
		return "recipe-unknown-field=" + unknown;
	const auto* format = root.find("format");
	if (format == nullptr || !format->is_string() || format->text != recipe_format)
		return "recipe-format-not-RENOVICE_ENGINE_PARAMS_V1";
	const auto* package = root.find("package");
	if (package == nullptr || !package->is_string()) return "recipe-package-missing";
	if (package->text != expected_package)
		return "recipe-package-mismatch expected=" + std::string(expected_package) + " found=" + package->text;
	out.package = package->text;
	const auto* build = root.find("build");
	if (build == nullptr || !build->is_string() || !settings::valid_text(build->text, settings::maximum_text_length, false))
		return "recipe-build-invalid";
	out.build = build->text;
	const auto* member = root.find("member");
	if (member == nullptr || !member->is_string() || !settings::valid_text(member->text, 128, false))
		return "recipe-member-invalid";
	out.member = member->text;
	const auto* overrides = root.find("overrides");
	if (overrides == nullptr || !overrides->is_array() || overrides->items.empty()) return "recipe-overrides-invalid";
	if (overrides->items.size() > maximum_overrides) return "recipe-too-many-overrides";
	std::set<std::pair<std::uint64_t, std::uint32_t>> seen;
	for (const auto& item : overrides->items)
	{
		if (!item.is_object()) return "recipe-override-not-object";
		if (!detail::only_fields(item, {"value", "module", "parameter", "hash", "mode"}, unknown))
			return "recipe-override-unknown-field=" + unknown;
		OverrideDecl decl;
		const auto* value = item.find("value");
		if (value == nullptr || !value->is_string() || !settings::valid_value_id(value->text)) return "recipe-override-value-invalid";
		decl.value = value->text;
		const std::string where = " value=" + decl.value;
		const auto* module = item.find("module");
		std::uint64_t key = 0;
		if (module == nullptr || !module->is_string() || !detail::parse_hex_word(module->text, 16, key) || key == 0)
			return "recipe-override-module-invalid" + where;
		decl.module = key;
		const auto* parameter = item.find("parameter");
		if (parameter == nullptr || !parameter->is_string() || !detail::identifier(parameter->text))
			return "recipe-override-parameter-invalid" + where;
		decl.parameter = parameter->text;
		const auto* hash = item.find("hash");
		std::uint64_t hash_value = 0;
		if (hash == nullptr || !hash->is_string() || !detail::parse_hex_word(hash->text, 8, hash_value))
			return "recipe-override-hash-invalid" + where;
		decl.hash = static_cast<std::uint32_t>(hash_value);
		const auto* mode = item.find("mode");
		if (mode == nullptr || !mode->is_string() || !parse_mode(mode->text, decl.mode))
			return "recipe-override-mode-invalid" + where;
		if (!seen.emplace(decl.module, decl.hash).second)
			return "recipe-override-duplicate module=" + hex64(decl.module) + " hash=" + hex32(decl.hash);
		out.overrides.push_back(std::move(decl));
	}
	return {};
}

// Checks the recipe against the package's parsed declarations and the running
// build's name-hash seed. Empty string on success.
inline std::string validate_recipe(const Recipe& recipe, const settings::Declarations& declarations, std::uint32_t seed,
	bool check_hashes = true)
{
	if (!declarations.build.empty() && declarations.build != recipe.build)
		return "recipe-build-mismatch declarations=" + declarations.build + " recipe=" + recipe.build;
	for (const auto& item : recipe.overrides)
	{
		const std::string where = " value=" + item.value;
		const auto* value = declarations.value(item.value);
		if (value == nullptr) return "recipe-value-not-declared" + where;
		if (value->lane != settings::Lane::Addon || value->live_literal) return "recipe-value-not-addon-lane" + where;
		if (value->member != recipe.member) return "recipe-value-member-mismatch" + where;
		if (value->type == settings::ValueType::Enum) return "recipe-value-enum-not-supported" + where;
		if (item.mode != Mode::Absolute && (value->stock != 1.0 || !(value->minimum > 0.0)))
			return "recipe-scaled-value-needs-stock-1-and-positive-minimum" + where;
		if (item.mode == Mode::ScaleInverse && !(value->minimum > 0.0))
			return "recipe-inverse-value-needs-positive-minimum" + where;
		if (check_hashes && name_hash(item.parameter, seed) != item.hash)
			return "recipe-hash-is-not-the-name-hash parameter=" + item.parameter + where;
	}
	return {};
}

// ---------------------------------------------------------------------------
// Plan (committing scans) and delivery withholding
// ---------------------------------------------------------------------------
struct PlanEntry
{
	std::uint64_t module = 0;
	std::uint32_t hash = 0;
	Mode mode = Mode::Absolute;
	float value = 0.0f;
	std::string value_id;
	std::string parameter;
};

inline bool entry_less(const PlanEntry& lhs, const PlanEntry& rhs) noexcept
{
	return lhs.module != rhs.module ? lhs.module < rhs.module : lhs.hash < rhs.hash;
}

// The delivered value (exact float the addon would receive) of every override
// whose value is delivered. Values that are off (not delivered) add nothing.
inline std::vector<PlanEntry> resolve_entries(const Recipe& recipe, const settings::MemberDelivery* delivery)
{
	std::vector<PlanEntry> entries;
	if (delivery == nullptr) return entries;
	for (const auto& item : recipe.overrides)
	{
		const auto found = std::find_if(delivery->values.begin(), delivery->values.end(),
			[&](const settings::DeliveredValue& value) { return value.id == item.value; });
		if (found == delivery->values.end() || !std::isfinite(found->value)) continue;
		entries.push_back(PlanEntry{item.module, item.hash, item.mode, found->value, item.value, item.parameter});
	}
	std::sort(entries.begin(), entries.end(), entry_less);
	return entries;
}

// The member's delivery without the values the native lane owns. A value id
// the recipe names is never delivered to the addon while the lane is
// installed, so the addon keeps its R10 write off for it.
inline std::shared_ptr<const settings::MemberDelivery> withhold(
	const settings::MemberDelivery& delivery, const std::set<std::string>& owned)
{
	auto result = std::make_shared<settings::MemberDelivery>();
	for (const auto& value : delivery.values)
		if (owned.count(value.id) == 0) result->values.push_back(value);
	result->identity = settings::delivery_identity(result->values);
	return result;
}

inline std::string plan_identity(const std::vector<PlanEntry>& entries)
{
	std::string canonical = "ENGINE_PARAMS_V1\n";
	for (const auto& entry : entries)
	{
		char value[32]{};
		std::snprintf(value, sizeof(value), "%.9g", static_cast<double>(entry.value));
		canonical += hex64(entry.module) + ":" + hex32(entry.hash) + ":" + mode_label(entry.mode) + ":" + value + ":"
			+ entry.value_id + "\n";
	}
	return "engine-params-v1:" + settings::sha256_hex(canonical).substr(0, 32);
}

// Generation-owned plan of one committed (or prepared) scan.
struct PlanSnapshot
{
	std::vector<PlanEntry> entries;          // sorted by (module, hash), unique
	std::vector<std::uint32_t> hashes;       // sorted, unique
	std::vector<std::uint64_t> modules;      // modules whose natural load is recorded (all recipe modules)
	std::string identity;

	[[nodiscard]] bool wants_hash(std::uint32_t hash) const noexcept
	{
		return std::binary_search(hashes.begin(), hashes.end(), hash);
	}
	[[nodiscard]] const PlanEntry* find(std::uint64_t module, std::uint32_t hash) const noexcept
	{
		PlanEntry probe;
		probe.module = module;
		probe.hash = hash;
		const auto found = std::lower_bound(entries.begin(), entries.end(), probe, entry_less);
		return found != entries.end() && found->module == module && found->hash == hash ? &*found : nullptr;
	}
};

inline std::shared_ptr<const PlanSnapshot> make_snapshot(std::vector<PlanEntry> entries, std::vector<std::uint64_t> modules)
{
	auto snapshot = std::make_shared<PlanSnapshot>();
	std::sort(entries.begin(), entries.end(), entry_less);
	for (const auto& entry : entries) snapshot->hashes.push_back(entry.hash);
	std::sort(snapshot->hashes.begin(), snapshot->hashes.end());
	snapshot->hashes.erase(std::unique(snapshot->hashes.begin(), snapshot->hashes.end()), snapshot->hashes.end());
	std::sort(modules.begin(), modules.end());
	modules.erase(std::unique(modules.begin(), modules.end()), modules.end());
	snapshot->modules = std::move(modules);
	snapshot->identity = plan_identity(entries);
	snapshot->entries = std::move(entries);
	return snapshot;
}

// ---------------------------------------------------------------------------
// Module identity (process-owned, recorded at each natural load of a recipe
// module): prototype address -> stock content key, re-verified at every match
// against the live prototype (GC tag, code pointer, instruction count,
// bytecode id) and the FNV-64 of its code, so a freed and reused address can
// never be attributed to another module.
// ---------------------------------------------------------------------------
struct ProtoIdentity
{
	std::uintptr_t address = 0;
	std::uintptr_t code = 0;
	std::int32_t instructions = 0;
	std::int32_t bytecode_id = 0;
	std::uint64_t code_hash = 0;
};

struct ModuleIdentity
{
	std::uint64_t key = 0;
	std::uintptr_t vm = 0;
	std::uintptr_t root = 0;
	std::uint64_t sequence = 0;               // load order (oldest dropped first)
	std::vector<ProtoIdentity> prototypes;    // sorted by address
};

struct IdentitySnapshot
{
	std::vector<ModuleIdentity> modules;
};

inline std::uint64_t code_hash(const std::uint8_t* bytes, std::size_t size) noexcept
{
	std::uint64_t hash = 1469598103934665603ull;
	for (std::size_t i = 0; i != size; ++i)
	{
		hash ^= bytes[i];
		hash *= 1099511628211ull;
	}
	return hash;
}

// Adds (or replaces, same vm + root) one module load; keeps at most
// maximum_identities_per_module loads per (key, vm).
inline std::shared_ptr<const IdentitySnapshot> with_module(const IdentitySnapshot& current, ModuleIdentity module)
{
	auto next = std::make_shared<IdentitySnapshot>();
	for (const auto& existing : current.modules)
		if (!(existing.vm == module.vm && existing.root == module.root)) next->modules.push_back(existing);
	std::sort(module.prototypes.begin(), module.prototypes.end(),
		[](const ProtoIdentity& lhs, const ProtoIdentity& rhs) { return lhs.address < rhs.address; });
	next->modules.push_back(std::move(module));
	const auto& added = next->modules.back();
	std::size_t same = 0;
	for (const auto& existing : next->modules)
		if (existing.key == added.key && existing.vm == added.vm) ++same;
	while (same > maximum_identities_per_module)
	{
		auto oldest = next->modules.end();
		for (auto it = next->modules.begin(); it != next->modules.end(); ++it)
		{
			if (it->key != added.key || it->vm != added.vm) continue;
			if (oldest == next->modules.end() || it->sequence < oldest->sequence) oldest = it;
		}
		next->modules.erase(oldest);
		--same;
	}
	return next;
}

// ---------------------------------------------------------------------------
// Hook decision (hot path). `Memory` supplies
//   bool read(uintptr_t address, void* out, size_t size)          engine-owned state, record and stack slots
//   bool read_checked(uintptr_t address, void* out, size_t size)  heap objects (closure, prototype, code)
//   void write(uintptr_t address, const void* in, size_t size)    the one pushed number slot
// ---------------------------------------------------------------------------
enum class Skip : std::uint8_t
{
	None,
	ParameterTypeNotNumber,   // bool, string, enum, vector, object ...: untouched
	IndexInvalid,
	StackShape,               // not [.., function, env, key(, table)]
	KeyNotHash,
	HashNotDeclared,          // the common fast exit
	EnvNotTable,
	FunctionNotLuaClosure,
	ClosureEnvMismatch,       // getfenv(function) is not the table being written
	ModuleUnknown,            // no live identity records this prototype
	OverrideNotDeclared,      // declared hash, other module
	PushShape,                // the stock push did not leave exactly one number
	ValueNotOverridden,       // override_number refused (non-finite, inverse of 0)
};

inline const char* skip_label(Skip skip) noexcept
{
	switch (skip)
	{
	case Skip::None: return "none";
	case Skip::ParameterTypeNotNumber: return "parameter-type-not-number";
	case Skip::IndexInvalid: return "index-invalid";
	case Skip::StackShape: return "stack-shape-not-function-env-key";
	case Skip::KeyNotHash: return "key-not-hashed-name";
	case Skip::HashNotDeclared: return "hash-not-declared";
	case Skip::EnvNotTable: return "env-not-table";
	case Skip::FunctionNotLuaClosure: return "function-not-lua-closure";
	case Skip::ClosureEnvMismatch: return "closure-env-is-not-the-written-table";
	case Skip::ModuleUnknown: return "module-identity-unknown";
	case Skip::OverrideNotDeclared: return "no-override-for-module";
	case Skip::PushShape: return "push-did-not-leave-one-number";
	case Skip::ValueNotOverridden: return "override-refused-non-finite";
	}
	return "unknown";
}

struct Candidate
{
	Skip skip = Skip::None;
	std::uint32_t hash = 0;
	std::uintptr_t vm = 0;
	std::uintptr_t proto = 0;
	std::uintptr_t top = 0;        // L->top before the stock push
	std::intptr_t index = -1;
};

template <class Memory>
Candidate classify(const Layout& layout, Memory& memory, std::uintptr_t state, std::uintptr_t record,
	std::intptr_t index, const PlanSnapshot& plan)
{
	Candidate result;
	result.index = index;
	std::uint8_t type = 0xff;
	if (!memory.read(record + layout.record_type, &type, 1)) { result.skip = Skip::ParameterTypeNotNumber; return result; }
	if (type != layout.number_types[0] && type != layout.number_types[1])
	{
		result.skip = Skip::ParameterTypeNotNumber;
		return result;
	}
	std::uintptr_t top = 0, stack = 0, vm = 0;
	if (!memory.read(state + layout.state_top, &top, sizeof(top)) || !memory.read(state + layout.state_stack, &stack, sizeof(stack))
		|| !memory.read(state + layout.state_global, &vm, sizeof(vm)))
	{
		result.skip = Skip::StackShape;
		return result;
	}
	result.top = top;
	result.vm = vm;
	const std::uintptr_t size = layout.value_size;
	if (stack == 0 || top <= stack || (top - stack) % size != 0)
	{
		result.skip = Skip::StackShape;
		return result;
	}
	const auto tag_at = [&](std::uintptr_t slot, std::uint32_t& tag) {
		return memory.read(slot + layout.value_tag, &tag, sizeof(tag));
	};
	std::uintptr_t key = 0;
	if (index == -1)
	{
		key = top - size;
	}
	else if (index >= 0)
	{
		std::uint8_t array = 0;
		std::uint32_t bytes = 0;
		if (!memory.read(record + layout.record_array, &array, 1) || array == 0
			|| !memory.read(record + layout.record_element_bytes, &bytes, sizeof(bytes))
			|| static_cast<std::uint64_t>(index) >= bytes / layout.element_stride)
		{
			result.skip = Skip::IndexInvalid;
			return result;
		}
		key = top - 2 * size;
		std::uint32_t table_tag = 0;
		if (top - stack < 4 * size || !tag_at(top - size, table_tag) || table_tag != layout.tag_table)
		{
			result.skip = Skip::StackShape;
			return result;
		}
	}
	else
	{
		result.skip = Skip::IndexInvalid;
		return result;
	}
	if (top - stack < 3 * size || key < stack + 2 * size)
	{
		result.skip = Skip::StackShape;
		return result;
	}
	std::uint32_t key_tag = 0, hash = 0;
	if (!tag_at(key, key_tag) || key_tag != layout.tag_hash_key || !memory.read(key, &hash, sizeof(hash)))
	{
		result.skip = Skip::KeyNotHash;
		return result;
	}
	result.hash = hash;
	if (!plan.wants_hash(hash))
	{
		result.skip = Skip::HashNotDeclared;
		return result;
	}
	const std::uintptr_t env_slot = key - size, function_slot = key - 2 * size;
	std::uint32_t env_tag = 0, function_tag = 0;
	std::uintptr_t env = 0, closure = 0;
	if (!tag_at(env_slot, env_tag) || env_tag != layout.tag_table || !memory.read(env_slot, &env, sizeof(env)) || env == 0)
	{
		result.skip = Skip::EnvNotTable;
		return result;
	}
	if (!tag_at(function_slot, function_tag) || function_tag != layout.tag_function
		|| !memory.read(function_slot, &closure, sizeof(closure)) || closure == 0)
	{
		result.skip = Skip::FunctionNotLuaClosure;
		return result;
	}
	std::uint8_t is_c = 1;
	std::uintptr_t closure_env = 0, proto = 0;
	if (!memory.read_checked(closure + layout.closure_is_c, &is_c, 1) || is_c != 0
		|| !memory.read_checked(closure + layout.closure_proto, &proto, sizeof(proto)) || proto == 0)
	{
		result.skip = Skip::FunctionNotLuaClosure;
		return result;
	}
	if (!memory.read_checked(closure + layout.closure_env, &closure_env, sizeof(closure_env)) || closure_env != env)
	{
		result.skip = Skip::ClosureEnvMismatch;
		return result;
	}
	result.proto = proto;
	return result;
}

// Stock content key of the module that owns `proto` in `vm`, or 0. Every
// candidate record is re-verified against the live prototype and its code.
template <class Memory>
std::uint64_t module_of(const Layout& layout, Memory& memory, const IdentitySnapshot& identities,
	std::uintptr_t vm, std::uintptr_t proto)
{
	std::uint64_t matched = 0;
	for (const auto& module : identities.modules)
	{
		if (module.vm != vm) continue;
		const auto found = std::lower_bound(module.prototypes.begin(), module.prototypes.end(), proto,
			[](const ProtoIdentity& record, std::uintptr_t value) { return record.address < value; });
		if (found == module.prototypes.end() || found->address != proto) continue;
		std::uint8_t tag = 0;
		std::uintptr_t code = 0;
		std::int32_t instructions = 0, bytecode_id = -1;
		if (!memory.read_checked(proto, &tag, 1) || tag != layout.proto_gc_tag
			|| !memory.read_checked(proto + layout.proto_code, &code, sizeof(code)) || code != found->code
			|| !memory.read_checked(proto + layout.proto_instructions, &instructions, sizeof(instructions))
			|| instructions != found->instructions
			|| !memory.read_checked(proto + layout.proto_bytecode_id, &bytecode_id, sizeof(bytecode_id))
			|| bytecode_id != found->bytecode_id)
		{
			continue;
		}
		const auto bytes = static_cast<std::size_t>(instructions) * 4u;
		if (instructions <= 0 || bytes > maximum_code_bytes) continue;
		std::vector<std::uint8_t> live(bytes);
		if (!memory.read_checked(code, live.data(), bytes) || code_hash(live.data(), bytes) != found->code_hash) continue;
		if (matched != 0 && matched != module.key) return 0;   // ambiguous: fail closed
		matched = module.key;
	}
	return matched;
}

struct Applied
{
	Skip skip = Skip::None;
	float stock = 0.0f;
	float written = 0.0f;
};

// After the single stock push: exactly one new slot, a number; replace it.
template <class Memory>
Applied apply_pushed(const Layout& layout, Memory& memory, std::uintptr_t state, const Candidate& candidate,
	Mode mode, float value)
{
	Applied result;
	std::uintptr_t top = 0;
	std::uint32_t tag = 0;
	if (!memory.read(state + layout.state_top, &top, sizeof(top)) || top != candidate.top + layout.value_size
		|| !memory.read(candidate.top + layout.value_tag, &tag, sizeof(tag)) || tag != layout.tag_number
		|| !memory.read(candidate.top, &result.stock, sizeof(result.stock)))
	{
		result.skip = Skip::PushShape;
		return result;
	}
	if (!override_number(mode, result.stock, value, result.written))
	{
		result.skip = Skip::ValueNotOverridden;
		return result;
	}
	memory.write(candidate.top, &result.written, sizeof(result.written));
	return result;
}

template <class Memory>
Applied apply_pushed(const Layout& layout, Memory& memory, std::uintptr_t state, const Candidate& candidate,
	const PlanEntry& entry)
{
	return apply_pushed(layout, memory, state, candidate, entry.mode, entry.value);
}
}
