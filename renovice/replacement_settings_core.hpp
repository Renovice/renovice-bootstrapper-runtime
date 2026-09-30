#pragma once

// REPLACEMENT_SETTINGS_V1 (2026-09-30): SCRIPT SETTINGS values for exact
// content-key replacement members of a script package.
//
// ADDON_SETTINGS_V1 delivers a package's values to its addon members through
// activate(context). A full replacement has no lifecycle, so this primitive
// gives it a read-only accessor instead:
//
//   RENOVICE_SCRIPT_SETTINGS([key]) -> { [id] = { enabled = true, value, stock } } | nil
//
// Ownership:
//   - declarations, user values and their evaluation: unchanged
//     (settings_core.hpp / packages.cpp). A replacement member that declares
//     addon-lane values gets the same MemberDelivery an addon member gets;
//   - the committed Snapshot below: process-owned, immutable, swapped
//     atomically at the startup package scan and at every F9 commit (a
//     SCRIPT SETTINGS apply is an F9). An accessor call keeps its own
//     shared_ptr copy for the duration of the call (in-flight rule);
//   - the accessor: one C closure per (VM, module load environment), created
//     by the host at the replacement's natural load, rooted only by that
//     environment table. Its single upvalue is the content key as plain bits
//     (light userdata), never a pointer. Native code retains no Lua object;
//   - every returned table is fresh, built in the calling VM and owned by the
//     caller. Mutating it changes nothing else.
//
// Everything in this header is pure and deterministic so the offline gate
// (RENOVICE_TOOLCHAIN/replacements/verify_replacement_settings.ps1) exercises
// the exact rules the DLL uses. Nothing here names a mission, ability or file.

#include "packages.hpp"
#include "replacements_core.hpp"
#include "settings_core.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

namespace renovice::replacement_settings
{
// The documented global. It is stored under the DE native-name hash of this
// exact spelling (the same key class the compiler emits for a global read),
// so a replacement reads it with a plain global access.
inline constexpr const char* accessor_global_name = "RENOVICE_SCRIPT_SETTINGS";
inline constexpr std::string_view contract_name = "REPLACEMENT_SETTINGS_V1";
inline constexpr std::size_t maximum_logged_call_failures = 16;

// packages.cpp: which members receive a settings delivery. Addon members keep
// the ADDON_SETTINGS_V1 rule (any declared value). A replacement member gets a
// delivery only when it declares at least one addon-lane value; a replacement
// with literal values only keeps the literal-lane gate and receives nothing,
// so every package written before this primitive is unchanged.
inline bool member_declares_readable_values(
	const settings::Declarations& declarations, std::string_view member)
{
	return std::any_of(declarations.values.begin(), declarations.values.end(),
		[&](const settings::ValueDecl& value)
		{
			return value.member == member && value.lane == settings::Lane::Addon;
		});
}

inline bool member_receives_delivery(
	bool replacement_member,
	const settings::Declarations& declarations,
	std::string_view member)
{
	return replacement_member
		? member_declares_readable_values(declarations, member)
		: settings::member_declares_values(declarations, member);
}

struct Entry
{
	std::uint64_t key = 0;
	std::string package;
	std::string member;
	std::shared_ptr<const settings::MemberDelivery> delivery;
};

struct Snapshot
{
	std::uint64_t serial = 0;
	std::vector<Entry> entries; // sorted by key, keys unique

	[[nodiscard]] const Entry* find(std::uint64_t key) const noexcept
	{
		const auto found = std::lower_bound(entries.begin(), entries.end(), key,
			[](const Entry& entry, std::uint64_t value) { return entry.key < value; });
		return found != entries.end() && found->key == key ? &*found : nullptr;
	}
};

// Only a member that actually enters the replacement lane in this generation
// (package accepted, member enabled, literal gate passed) and carries a
// delivery is readable. A loose replacement file is never a package member, so
// it never has an entry. Package conflict rules already make a replacement key
// unique across accepted packages; a duplicate here would be a scanner defect,
// so both claimants are dropped (fail closed) rather than one chosen.
inline Snapshot build_snapshot(const packages::Snapshot* source, std::uint64_t serial)
{
	Snapshot snapshot;
	snapshot.serial = serial;
	if (source == nullptr) return snapshot;
	for (const auto& package : source->packages)
	{
		if (!package.accepted) continue;
		for (const auto& member : package.members)
		{
			if (member.kind != packages::MemberKind::Replacement || !member.staged
				|| !member.delivery || member.key == 0)
			{
				continue;
			}
			snapshot.entries.push_back(Entry{member.key, package.folder, member.filename, member.delivery});
		}
	}
	std::sort(snapshot.entries.begin(), snapshot.entries.end(),
		[](const Entry& lhs, const Entry& rhs) { return lhs.key < rhs.key; });
	std::vector<Entry> unique;
	unique.reserve(snapshot.entries.size());
	for (std::size_t i = 0; i != snapshot.entries.size();)
	{
		std::size_t j = i + 1;
		while (j != snapshot.entries.size() && snapshot.entries[j].key == snapshot.entries[i].key) ++j;
		if (j == i + 1) unique.push_back(std::move(snapshot.entries[i]));
		i = j;
	}
	snapshot.entries = std::move(unique);
	return snapshot;
}

// Optional explicit argument: exactly sixteen hex digits (either case), the
// replacement's content key as in its filename. Anything else is invalid.
inline bool parse_key_argument(std::string_view text, std::uint64_t& key) noexcept
{
	key = 0;
	return text.size() == 16 && replacements::parse_filename_key(text, key);
}

enum class CallKeySource { Bound, Argument, None };

struct CallKey
{
	std::uint64_t key = 0;
	CallKeySource source = CallKeySource::None;
};

// A call with a string argument names its key explicitly (an invalid string
// resolves to nothing, never to the bound key). A call without an argument
// uses the key the accessor was bound to at install; an unbound accessor
// (shared environment, see install_action) resolves to nothing.
inline CallKey resolve_call_key(
	std::uint64_t bound_key,
	bool has_string_argument,
	bool argument_valid,
	std::uint64_t argument_key) noexcept
{
	if (has_string_argument)
	{
		return argument_valid && argument_key != 0
			? CallKey{argument_key, CallKeySource::Argument}
			: CallKey{};
	}
	return bound_key != 0 ? CallKey{bound_key, CallKeySource::Bound} : CallKey{};
}

// What the environment slot named accessor_global_name holds at install time.
enum class SlotState
{
	Empty,       // nil: nothing visible under that name
	OwnSameKey,  // our accessor, bound to this replacement's key
	OwnOtherKey, // our accessor, bound to another replacement's key
	OwnUnbound,  // our accessor, bound to no key
	Foreign,     // any other value: a stock or third-party global
};

enum class InstallAction
{
	Install,       // new accessor bound to this key
	Keep,          // already correct; no VM write
	RebindUnbound, // two replacements share one environment: explicit keys only
	RejectForeign, // never overwrite a value we do not own (fail closed)
};

inline InstallAction install_action(SlotState state) noexcept
{
	switch (state)
	{
	case SlotState::Empty: return InstallAction::Install;
	case SlotState::OwnSameKey: return InstallAction::Keep;
	case SlotState::OwnOtherKey: return InstallAction::RebindUnbound;
	case SlotState::OwnUnbound: return InstallAction::Keep;
	case SlotState::Foreign: return InstallAction::RejectForeign;
	}
	return InstallAction::RejectForeign;
}

inline const char* install_action_label(InstallAction action) noexcept
{
	switch (action)
	{
	case InstallAction::Install: return "installed";
	case InstallAction::Keep: return "kept";
	case InstallAction::RebindUnbound: return "rebound-unbound-shared-environment";
	case InstallAction::RejectForeign: return "rejected-foreign-value";
	}
	return "unknown";
}

// DE native-name hash (FNV-1a variant with the build seed, then complement and
// rotate left 17). Mirrors owf_scripting.cpp wf_fnv_2 so the offline gate can
// prove the host key equals the key the U44 compiler emits for the global.
inline std::uint32_t native_name_hash(std::string_view name, std::uint32_t seed) noexcept
{
	std::uint32_t hash = seed;
	for (const char ch : name)
	{
		hash ^= static_cast<std::uint8_t>(ch);
		hash *= 16777619u;
	}
	hash = ~hash;
	return (hash << 17) | (hash >> 15);
}
}
