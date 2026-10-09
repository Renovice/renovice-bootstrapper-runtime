#pragma once

#include <algorithm>
#include <cctype>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "replacements_core.hpp"
#include "de_opcode_profile.hpp"

namespace renovice::injection
{
inline constexpr char signature_module_loader[] =
	"4C 8B DC 55 53 41 55 49 8D AB 38 FE FF FF 48 81 EC B0 02 00 00 48 8B 05";
inline constexpr char signature_name_key_builder[] =
	"48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 49 8B F0 48 8B FA 48 8B D9 48 83 FA 01 77 ? CD 2C";
inline constexpr char signature_getfield[] =
	"48 89 5C 24 20 55 56 57 48 83 EC 40 48 8B 05 ? ? ? ? 48 33 C4 48 89 44 24 30 F6 41 01 04 49";
inline constexpr char signature_setfield[] =
	"48 89 5C 24 20 55 56 57 48 83 EC 40 48 8B 05 ? ? ? ? 48 33 C4 48 89 44 24 30 49 8B E8 48 8B";
inline constexpr char signature_checkstack[] =
	"48 89 5C 24 08 48 89 74 24 18 57 48 83 EC 20 48 8B D9 BF 01 00 00 00 81";
inline constexpr char signature_game_allocator[] =
	"40 53 56 41 56 48 83 EC 20 8B DA 44 8B F2 41 83 E6 01 83 E3 02 48 83 3D";
inline constexpr char signature_protected_call[] =
	"48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 40 45 33 D2 41 8B F0 44 8B DA";
inline constexpr char signature_vm_execute[] =
	"40 55 41 56 48 8D AC 24 38 FF FF FF 48 81 EC C8 01 00 00 48 8B 05 ? ? ? ? 48 33 C4 48 89 45 38 48 8B 41 20 4C 8B F1 F6 40 24 04";

inline std::uintptr_t relative_jump_destination(
	std::uintptr_t instruction,
	std::int32_t displacement
) noexcept
{
	return instruction + 5u + static_cast<std::intptr_t>(displacement);
}

inline bool exact_relative_jump_to(
	std::uintptr_t instruction,
	std::uint8_t opcode,
	std::int32_t displacement,
	std::uintptr_t expected_destination
) noexcept
{
	return opcode == 0xE9u
		&& relative_jump_destination(instruction, displacement)
			== expected_destination;
}

inline constexpr std::int32_t de_interrupt_limit_u43 = 800000;

template <typename Observer>
inline std::uint32_t preserve_stock_interrupt_result(
	std::uint32_t stock_count,
	Observer&& observer
) noexcept
{
	// The parent DE callback performs a signed `cmp eax, 800000; jg` immediately
	// after this leaf returns. Never run optional addon code before that stock
	// failure path, and never let a C++ observer failure escape through DE.
	if (static_cast<std::int32_t>(stock_count) > de_interrupt_limit_u43)
		return stock_count;
	try
	{
		std::forward<Observer>(observer)();
	}
	catch (...)
	{
	}
	return stock_count;
}

enum class ScriptKind
{
	Ordinary,
	ManagedAddon,
	TargetManagedAddon,
	ExperimentalPersistent,
	ExperimentalSpawn,
};

inline bool ascii_icontains(std::string_view text, std::string_view needle) noexcept
{
	if (needle.empty() || needle.size() > text.size()) return false;
	for (std::size_t offset = 0; offset + needle.size() <= text.size(); ++offset)
	{
		bool equal = true;
		for (std::size_t i = 0; i != needle.size(); ++i)
		{
			if (std::tolower(static_cast<unsigned char>(text[offset + i]))
				!= std::tolower(static_cast<unsigned char>(needle[i])))
			{
				equal = false;
				break;
			}
		}
		if (equal) return true;
	}
	return false;
}

inline ScriptKind classify_script(std::string_view filename) noexcept
{
	if (ascii_icontains(filename, ".spawn"))
	{
		return ScriptKind::ExperimentalSpawn;
	}
	if (ascii_icontains(filename, ".persist"))
	{
		return ScriptKind::ExperimentalPersistent;
	}
	if (ascii_icontains(filename, ".target.addon")
		|| ascii_icontains(filename, ".targets.addon"))
	{
		return ScriptKind::TargetManagedAddon;
	}
	if (ascii_icontains(filename, ".addon"))
	{
		return ScriptKind::ManagedAddon;
	}
	return ScriptKind::Ordinary;
}

// A multi-target addon is one target-managed file that declares several exact
// module content keys. Its runtime lane is the ordinary TargetManagedAddon lane:
// the scanner expands it into one binding per declared key, and every binding
// then uses the unchanged single-key identity, generation, and F9 machinery.
inline bool is_multi_target_addon(std::string_view filename) noexcept
{
	return classify_script(filename) == ScriptKind::TargetManagedAddon
		&& ascii_icontains(filename, ".targets.addon");
}

inline bool target_addon_key(std::string_view filename, std::uint64_t& key) noexcept
{
	return classify_script(filename) == ScriptKind::TargetManagedAddon
		&& !is_multi_target_addon(filename)
		&& replacements::parse_filename_key(filename, key);
}

inline constexpr std::size_t maximum_multi_target_keys = 1024;

// Declared targets are the exact lowercase 16-hex strings in the DE bytecode
// string pool (`09 03 | varint count | {varint length, bytes}...`). The
// `targets` table's constant keys are therefore the single source of truth: no
// sidecar manifest can disagree with the returned table. Uppercase or mixed-case
// 16-hex strings are not declarations. Returns nullptr on success, otherwise an
// exact, stable rejection reason.
inline const char* multi_target_filename_error(std::string_view filename) noexcept
{
	if (!is_multi_target_addon(filename)) return "not-multi-target-filename";
	std::uint64_t prefix = 0;
	if (replacements::parse_filename_key(filename, prefix))
		return "multi-target-filename-has-key-prefix";
	return nullptr;
}

inline bool read_bytecode_varint(
	const unsigned char* body,
	std::size_t size,
	std::size_t& offset,
	std::uint64_t& value
) noexcept
{
	value = 0;
	for (unsigned shift = 0; shift < 35; shift += 7)
	{
		if (offset >= size) return false;
		const unsigned char byte = body[offset++];
		value |= static_cast<std::uint64_t>(byte & 0x7fu) << shift;
		if ((byte & 0x80u) == 0) return true;
	}
	return false;
}

inline bool lowercase_target_key_text(
	const unsigned char* text,
	std::size_t length,
	std::uint64_t& key
) noexcept
{
	if (text == nullptr || length != 16) return false;
	std::uint64_t value = 0;
	for (std::size_t i = 0; i != 16; ++i)
	{
		const unsigned char c = text[i];
		std::uint64_t digit = 0;
		if (c >= '0' && c <= '9') digit = static_cast<std::uint64_t>(c - '0');
		else if (c >= 'a' && c <= 'f') digit = static_cast<std::uint64_t>(c - 'a' + 10);
		else return false;
		value = (value << 4) | digit;
	}
	key = value;
	return true;
}

inline const char* discover_multi_target_keys(
	const unsigned char* body,
	std::size_t size,
	std::vector<std::uint64_t>& keys
)
{
	keys.clear();
	if (body == nullptr || size < 3 || body[0] != 0x09 || body[1] != 0x03)
		return "not-de-bytecode-container";
	std::size_t offset = 2;
	std::uint64_t count = 0;
	if (!read_bytecode_varint(body, size, offset, count))
		return "string-pool-count-truncated";
	if (count > size) return "string-pool-count-implausible";
	for (std::uint64_t i = 0; i != count; ++i)
	{
		std::uint64_t length = 0;
		if (!read_bytecode_varint(body, size, offset, length))
			return "string-pool-length-truncated";
		if (length > size - offset) return "string-pool-entry-truncated";
		std::uint64_t key = 0;
		if (lowercase_target_key_text(body + offset, static_cast<std::size_t>(length), key))
		{
			if (key == 0) return "declared-target-key-zero";
			keys.push_back(key);
		}
		offset += static_cast<std::size_t>(length);
	}
	std::sort(keys.begin(), keys.end());
	keys.erase(std::unique(keys.begin(), keys.end()), keys.end());
	if (keys.empty()) return "no-declared-target-keys";
	if (keys.size() > maximum_multi_target_keys) return "too-many-declared-target-keys";
	return nullptr;
}

inline void format_target_key_text(std::uint64_t key, char (&text)[17]) noexcept
{
	constexpr char digits[] = "0123456789abcdef";
	for (int i = 15; i >= 0; --i)
	{
		text[i] = digits[key & 0xfu];
		key >>= 4;
	}
	text[16] = '\0';
}

// Per-binding selection of `returned.targets["<key>"]` inside the protected
// module-load leaf. Codes are stable diagnostics; zero is success.
enum class MultiTargetSelectFailure : int
{
	none = 0,
	container_not_table = 1,
	container_has_hooks = 2,
	targets_not_table = 3,
	entry_missing = 4,
	entry_not_table = 5,
	activate_missing = 6,
	cleanup_missing = 7,
};

inline const char* multi_target_select_failure_label(int code) noexcept
{
	switch (static_cast<MultiTargetSelectFailure>(code))
	{
	case MultiTargetSelectFailure::none: return "none";
	case MultiTargetSelectFailure::container_not_table: return "returned-value-not-table";
	case MultiTargetSelectFailure::container_has_hooks: return "top-level-hooks-not-allowed-use-targets[key].hooks";
	case MultiTargetSelectFailure::targets_not_table: return "targets-not-table";
	case MultiTargetSelectFailure::entry_missing: return "targets[key]-missing";
	case MultiTargetSelectFailure::entry_not_table: return "targets[key]-not-table";
	case MultiTargetSelectFailure::activate_missing: return "activate-not-a-function-in-entry-or-top-level";
	case MultiTargetSelectFailure::cleanup_missing: return "cleanup-not-a-function-in-entry-or-top-level";
	}
	return "unknown";
}

// An entry lifecycle field wins when it is a function. Only an ABSENT entry
// field inherits the top-level function; a present non-function never does.
inline bool multi_target_lifecycle_resolved(
	bool entry_absent,
	bool entry_is_function,
	bool container_is_function
) noexcept
{
	return entry_is_function || (entry_absent && container_is_function);
}

// Pure model of the selection rules executed on live TValues by the leaf.
// Entry lifecycle functions override top-level defaults; hooks never inherit
// because Lua prototype and callsite identities are module-specific.
inline MultiTargetSelectFailure classify_multi_target_selection(
	bool container_is_table,
	bool container_hooks_absent,
	bool targets_is_table,
	bool entry_absent,
	bool entry_is_table,
	bool entry_activate_absent,
	bool entry_activate_is_function,
	bool container_activate_is_function,
	bool entry_cleanup_absent,
	bool entry_cleanup_is_function,
	bool container_cleanup_is_function
) noexcept
{
	if (!container_is_table) return MultiTargetSelectFailure::container_not_table;
	if (!container_hooks_absent) return MultiTargetSelectFailure::container_has_hooks;
	if (!targets_is_table) return MultiTargetSelectFailure::targets_not_table;
	if (entry_absent) return MultiTargetSelectFailure::entry_missing;
	if (!entry_is_table) return MultiTargetSelectFailure::entry_not_table;
	if (!multi_target_lifecycle_resolved(entry_activate_absent,
			entry_activate_is_function, container_activate_is_function))
		return MultiTargetSelectFailure::activate_missing;
	if (!multi_target_lifecycle_resolved(entry_cleanup_absent,
			entry_cleanup_is_function, container_cleanup_is_function))
		return MultiTargetSelectFailure::cleanup_missing;
	return MultiTargetSelectFailure::none;
}

inline bool target_addon_target_discovery_required(
	ScriptKind kind,
	bool policy_enabled
) noexcept
{
	// Target identity discovery is inventory, not execution. A valid target
	// addon that starts disabled must still make its body key observable so a
	// later live enable can attach to the module that already loaded. Policy
	// continues to decide whether the addon's bytes enter the active generation.
	(void)policy_enabled;
	return kind == ScriptKind::TargetManagedAddon;
}

inline bool is_lua_bytecode_extension(std::string_view extension) noexcept
{
	constexpr std::string_view expected = ".lua_B";
	if (extension.size() != expected.size()) return false;
	for (std::size_t i = 0; i != extension.size(); ++i)
	{
		if (std::tolower(static_cast<unsigned char>(extension[i]))
			!= std::tolower(static_cast<unsigned char>(expected[i])))
		{
			return false;
		}
	}
	return true;
}

inline bool valid_chunk_size(std::uintmax_t size) noexcept
{
	return size != 0 && size < (1ull << 20);
}

inline bool bytecode_contains(
	const unsigned char* body,
	std::size_t size,
	std::string_view needle
) noexcept
{
	if (body == nullptr || needle.empty() || needle.size() > size) return false;
	return std::search(
		body, body + size,
		reinterpret_cast<const unsigned char*>(needle.data()),
		reinterpret_cast<const unsigned char*>(needle.data() + needle.size()))
		!= body + size;
}

inline bool pause_top_menu_signature(
	const unsigned char* body,
	std::size_t size
) noexcept
{
	// Independent semantic exports/rows from the stock pause module. Note that
	// GetMenuEntries belongs to a nested generic-popup path; it is only a module
	// identity marker and is deliberately not treated as the ESC row-builder
	// export. Requiring every marker fails closed when a future client changes
	// the contract.
	return size > 64ull * 1024ull && size < 1024ull * 1024ull
		&& bytecode_contains(body, size, "GetMenuEntries")
		&& bytecode_contains(body, size, "MenuSelectionDone")
		&& bytecode_contains(body, size, "ResumeGameUpperCase")
		&& bytecode_contains(body, size, "MenuAbilities")
		&& bytecode_contains(body, size, "MeleeCombos")
		&& bytecode_contains(body, size, "MenuOptions");
}

// Pinned captured-client ownership contract for Lotus/Interface/TopMenu, per
// exact TopMenu content key: the root creates Initialize with N captures.
// Initialize U<builder> owns the 62-record ESC builder. That builder has 59
// captures and invokes U58 with the completed mMenuOptions array after all
// stock rows are assembled and before the final state-dependent filter
// consumes the array.
// Wrapping that final dispatch boundary consumes the table as a normal Lua
// argument instead of guessing an internal table-owning upvalue.
// Rows (root NEWCLOSURE of Initialize, proto 133, and of the builder, root
// local 144, proto 106; read from the stock bytes of each build):
//   44.1.0 2026.10.06.16.12 ee5220bab21a9a8a: Initialize 23 captures, builder U14.
//   44.1.1 2026.10.08.13.05 9b533c41f2294d14: DE inserted capture 3 (root
//          value 78), Initialize 24 captures, builder U15 (still root local
//          144); the builder is unchanged (59 captures, dispatch U58 = root
//          value 120).
// An unregistered TopMenu key fails closed (no SCRIPTS row).
struct PauseTopMenuLayout {
	std::uint64_t top_menu_key;
	std::size_t initialize_upvalues;
	std::size_t initialize_builder_upvalue;
	std::size_t builder_upvalues;
	std::size_t builder_dispatch_upvalue;
};

inline constexpr PauseTopMenuLayout pause_top_menu_layouts[] = {
	{0xee5220bab21a9a8aull, 23, 14, 59, 58},
	{0x9b533c41f2294d14ull, 24, 15, 59, 58},
};

inline const PauseTopMenuLayout* pause_top_menu_layout(std::uint64_t top_menu_key) noexcept
{
	for (const auto& layout : pause_top_menu_layouts)
	{
		if (layout.top_menu_key == top_menu_key) return &layout;
	}
	return nullptr;
}
inline constexpr std::string_view pause_menu_architecture_marker =
	"TOPMENU_EXACT_ROOT_EVENT_DRIVEN_V27_TARGET_ENV_HOOKS";

inline constexpr std::string_view scripts_ui_bridge_filename =
	"_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B";

inline bool is_internal_scripts_ui_bridge(std::string_view filename) noexcept
{
	return filename == scripts_ui_bridge_filename;
}

// In-game settings editor (2026-09-30). The `_RENOVICE_INTERNAL_` filename
// prefix is reserved for bootstrapper infrastructure:
// - the V10 SCRIPTS bridge keeps its exact managed-generation path;
// - OPTIONAL internal bridges (SCRIPT SETTINGS V1, the Phase 0 diagnostic
//   probe) are staged after, and outside, the managed-addon transaction, so
//   their absence or failure removes only their own menu row;
// - any other reserved name is infrastructure this build does not load. It is
//   never executed as a one-shot, never listed as a player script and never a
//   package member.
inline constexpr std::string_view internal_infrastructure_prefix = "_RENOVICE_INTERNAL_";
inline constexpr std::string_view script_settings_bridge_filename =
	"_RENOVICE_INTERNAL_ScriptSettingsBridgeV1.lua_B";
inline constexpr std::string_view settings_probe_bridge_filename =
	"_RENOVICE_INTERNAL_ScriptSettingsProbeP0.lua_B";

enum class InternalChunk
{
	None,
	ScriptsBridgeV10,
	ScriptSettingsBridgeV1,
	SettingsProbeP0,
	Reserved,
};

inline bool has_internal_infrastructure_prefix(std::string_view filename) noexcept
{
	if (filename.size() < internal_infrastructure_prefix.size()) return false;
	for (std::size_t i = 0; i != internal_infrastructure_prefix.size(); ++i)
	{
		if (std::tolower(static_cast<unsigned char>(filename[i]))
			!= std::tolower(static_cast<unsigned char>(internal_infrastructure_prefix[i])))
		{
			return false;
		}
	}
	return true;
}

inline InternalChunk classify_internal_chunk(std::string_view filename) noexcept
{
	if (is_internal_scripts_ui_bridge(filename)) return InternalChunk::ScriptsBridgeV10;
	if (filename == script_settings_bridge_filename) return InternalChunk::ScriptSettingsBridgeV1;
	if (filename == settings_probe_bridge_filename) return InternalChunk::SettingsProbeP0;
	if (has_internal_infrastructure_prefix(filename)) return InternalChunk::Reserved;
	return InternalChunk::None;
}

inline bool is_internal_infrastructure(std::string_view filename) noexcept
{
	return classify_internal_chunk(filename) != InternalChunk::None;
}

// Only the named optional bridges are loaded, and the diagnostic probe only by
// a build that was compiled for it. Everything else in the reserved namespace
// is inventoried and ignored.
inline bool optional_internal_bridge_admitted(
	InternalChunk kind, bool settings_probe_build) noexcept
{
	return kind == InternalChunk::ScriptSettingsBridgeV1
		|| (kind == InternalChunk::SettingsProbeP0 && settings_probe_build);
}

inline const char* optional_internal_bridge_hook(InternalChunk kind) noexcept
{
	switch (kind)
	{
	case InternalChunk::ScriptSettingsBridgeV1: return "openScriptSettings";
	case InternalChunk::SettingsProbeP0: return "openProbe";
	case InternalChunk::None:
	case InternalChunk::ScriptsBridgeV10:
	case InternalChunk::Reserved:
		break;
	}
	return nullptr;
}

inline ScriptKind runtime_script_kind(std::string_view filename) noexcept
{
	// The UI bridge is infrastructure with a managed lifecycle even though its
	// deliberately stable filename does not expose the user-facing .addon suffix.
	return is_internal_scripts_ui_bridge(filename)
		? ScriptKind::ManagedAddon
		: classify_script(filename);
}

template <typename ChunkRange, typename RootRange>
inline bool unchanged_managed_generation_can_reuse_roots(
	const ChunkRange& active_chunks,
	const ChunkRange& candidate_chunks,
	const RootRange& active_roots
)
{
	// scan_snapshot sorts both generations by filename, and staged lifecycle
	// roots retain that order. Reuse is valid only when every managed filename
	// and every byte are identical and every chunk still owns its expected root.
	// Ordinary and target-managed chunks have independent reload transactions.
	auto active = active_chunks.begin();
	auto candidate = candidate_chunks.begin();
	auto root = active_roots.begin();
	for (;;)
	{
		while (active != active_chunks.end()
			&& active->kind != ScriptKind::ManagedAddon)
		{
			++active;
		}
		while (candidate != candidate_chunks.end()
			&& candidate->kind != ScriptKind::ManagedAddon)
		{
			++candidate;
		}

		const bool active_done = active == active_chunks.end();
		const bool candidate_done = candidate == candidate_chunks.end();
		if (active_done || candidate_done)
		{
			return active_done && candidate_done && root == active_roots.end();
		}
		if (root == active_roots.end()
			|| active->name != candidate->name
			|| active->bytes != candidate->bytes
			|| root->name != active->name)
		{
			return false;
		}
		++active;
		++candidate;
		++root;
	}
}

inline bool scripts_ui_attachment_requested(
	bool subsystem_is_enabled,
	bool bridge_is_configured
) noexcept
{
	// The native TopMenu wrapper cannot open Generic Settings without the
	// Luau NAMECALL bridge.  Treat that bridge as a required part of the UI
	// feature, not as an optional one-shot: an absent bridge must leave the
	// stock TopMenu completely untouched while the injector itself stays live.
	return subsystem_is_enabled && bridge_is_configured;
}

inline bool pause_lua_namecall_bridge_ready(
	bool bridge_is_function,
	bool parent_has_identity,
	bool settings_resource_has_identity
) noexcept
{
	return bridge_is_function && parent_has_identity
		&& settings_resource_has_identity;
}

inline bool pause_toggle_provider_argument_ready(
	std::size_t argument_count,
	bool control_type_is_number
) noexcept
{
	// The bridge resolves LotusUtilities.CHECKBOX, which is the native binary
	// X/check component used by ThemedGenericSettings. Reject a missing or
	// nonnumeric enum at the native boundary instead of rendering fallback rows.
	return argument_count >= 1 && control_type_is_number;
}

inline bool scripts_settings_value_change_ready(
	std::size_t argument_count,
	bool value_is_boolean,
	bool setting_is_string
) noexcept
{
	// ThemedGenericSettings invokes the movie-wide value callback as
	// callback(element.mValue, element.mSetting). Checkbox rows do not dispatch
	// their optional per-row mCallback through this path.
	return argument_count >= 2 && value_is_boolean && setting_is_string;
}

enum class ScriptsSettingsCompletionDecision
{
	Confirm,
	Cancel,
	Reject,
};

inline ScriptsSettingsCompletionDecision classify_scripts_settings_completion(
	std::size_t argument_count,
	bool cancellation_is_nil,
	bool cancellation_is_boolean,
	bool cancellation_value
) noexcept
{
	// Generic Settings' naming is counterintuitive: FinishSelection (the visible
	// Confirm button) closes with (allElements, nil), while ExitScreen (Cancel)
	// closes with (allElements, true). Reject every other shape instead of
	// guessing whether an ABI-drifted completion should persist state.
	if (argument_count < 2) return ScriptsSettingsCompletionDecision::Reject;
	if (cancellation_is_nil) return ScriptsSettingsCompletionDecision::Confirm;
	if (cancellation_is_boolean && cancellation_value)
	{
		return ScriptsSettingsCompletionDecision::Cancel;
	}
	return ScriptsSettingsCompletionDecision::Reject;
}

inline bool scripts_settings_should_apply_on_close(
	ScriptsSettingsCompletionDecision decision,
	std::size_t pending_change_count
) noexcept
{
	// Live Generic Settings evidence shows that a close after a real checkbox
	// edit can arrive through either FinishSelection (nil/Confirm) or
	// ExitScreen (true/Cancel), depending on the UI route that dismissed the
	// child movie. Treat both recognized close routes as one atomic Apply when
	// there are staged edits. Malformed completion shapes remain fail-closed.
	return pending_change_count != 0
		&& (decision == ScriptsSettingsCompletionDecision::Confirm
			|| decision == ScriptsSettingsCompletionDecision::Cancel);
}

inline bool pause_callback_movie_capture_ready(
	bool owner_is_lua,
	bool owner_has_environment,
	bool environment_is_table,
	bool movie_is_userdata
) noexcept
{
	// A C callback does not lexically resolve TopMenu's module-local mMovie.
	// Match a Luau closure by capturing the exact movie from the owning Lua
	// dispatch closure's environment when the SCRIPTS row is constructed.
	return owner_is_lua && owner_has_environment
		&& environment_is_table && movie_is_userdata;
}

inline bool pause_runtime_root_owned(
	const void* recorded_global_state,
	const void* recorded_root_proto,
	const void* runtime_global_state,
	const void* runtime_root_proto,
	const void* runtime_environment
) noexcept
{
	// The loader retains a template closure.  UI instantiation may clone that
	// closure with a per-instance environment, so environment equality is not
	// an ownership condition here.  The exact semantic body already pinned the
	// template proto; runtime ownership is exact VM + exact root proto + a real
	// environment that can receive that instance's SETGLOBAL publications.
	return recorded_global_state != nullptr
		&& recorded_root_proto != nullptr
		&& runtime_environment != nullptr
		&& recorded_global_state == runtime_global_state
		&& recorded_root_proto == runtime_root_proto;
}

inline bool pause_runtime_root_requires_revalidation(
	bool exact_runtime_root_owned,
	bool a_previous_instance_was_attached
) noexcept
{
	// pause_attached describes an earlier movie instance, not the lifetime of
	// the TopMenu bytecode identity.  Every exact root execution must be checked
	// because closing and reopening ESC creates a fresh environment/Initialize
	// closure whose U14/U58 dispatch has not been wrapped yet.
	(void)a_previous_instance_was_attached;
	return exact_runtime_root_owned;
}

inline bool pause_top_menu_closure_contract(
	const PauseTopMenuLayout* layout,
	std::size_t initialize_upvalues,
	std::size_t builder_upvalues
) noexcept
{
	return layout != nullptr
		&& initialize_upvalues == layout->initialize_upvalues
		&& builder_upvalues == layout->builder_upvalues;
}

inline bool pause_global_initialize_owned(
	const PauseTopMenuLayout* layout,
	const void* recorded_environment,
	const void* initialize_environment,
	bool value_is_lua_closure,
	std::size_t initialize_upvalues
) noexcept
{
	// DE's SETGLOBAL/GETGLOBAL path is a VM-global hashed namespace, not an
	// ordinary raw-table field lookup on Closure::env.  The global name alone
	// is insufficient ownership evidence, so require the candidate closure to
	// point back to the exact environment captured from the semantic TopMenu
	// loader identity and to satisfy the pinned Initialize shape.
	return layout != nullptr
		&& recorded_environment != nullptr
		&& recorded_environment == initialize_environment
		&& value_is_lua_closure
		&& initialize_upvalues == layout->initialize_upvalues;
}

inline bool pause_exact_root_published(
	const void* published_global_state,
	const void* published_root_proto,
	const void* runtime_global_state,
	const void* runtime_root_proto
) noexcept
{
	return published_global_state != nullptr
		&& published_root_proto != nullptr
		&& published_global_state == runtime_global_state
		&& published_root_proto == runtime_root_proto;
}

inline bool pause_environment_publication_ready(
	const PauseTopMenuLayout* layout,
	bool menu_options_is_table,
	const void* recorded_environment,
	const void* initialize_environment,
	bool initialize_is_lua_closure,
	std::size_t initialize_upvalues
) noexcept
{
	return menu_options_is_table
		&& pause_global_initialize_owned(
			layout,
			recorded_environment,
			initialize_environment,
			initialize_is_lua_closure,
			initialize_upvalues);
}

inline bool pause_root_decoration_ready(
	bool module_identity_recorded,
	bool exact_root_execution,
	int protected_call_status
) noexcept
{
	// Loading/undumping a closure does not execute its SETGLOBAL instructions.
	// Decoration is valid only after the exact recorded root returns normally.
	return module_identity_recorded && exact_root_execution
		&& protected_call_status == 0;
}

inline bool pause_vm_root_decoration_ready(
	bool exact_module_boundary,
	bool exact_root_closure,
	bool vm_execute_returned
) noexcept
{
	// The interpreter entry is the authoritative lifecycle boundary for Luau
	// bytecode that executes SETGLOBAL internally. Post-execution decoration is
	// permitted only after the exact TopMenu root returns normally.
	return exact_module_boundary && exact_root_closure && vm_execute_returned;
}

inline bool valid_execution_boundary(
	bool manager_state_readable,
	bool boundary_state_readable,
	bool shared_global_state
) noexcept
{
	// The manager state may be a suspended coroutine. It is safe for the engine
	// loader to own that state, but injected Lua calls must execute on the live
	// state supplied by the current DE callback. Registry values are shareable
	// only when both states belong to the same global VM.
	return manager_state_readable && boundary_state_readable && shared_global_state;
}

enum class LuaMutationBoundaryBlocker
{
	Ready,
	ThreadSuspended,
	StackUnavailable,
	StackOrderInvalid,
	CallInfoUnavailable,
	CallInfoBoundsInvalid,
	CurrentFrameInvalid,
	LuaFrameActive,
};

inline LuaMutationBoundaryBlocker lua_mutation_boundary_blocker(
	std::uint8_t status,
	std::uintptr_t stack,
	std::uintptr_t intop,
	std::uintptr_t outtop,
	std::uintptr_t stack_last,
	std::uintptr_t base_ci,
	std::uintptr_t current_ci,
	std::uintptr_t end_ci,
	std::size_t call_info_size,
	bool current_frame_readable,
	bool current_frame_is_function,
	bool current_frame_is_c
) noexcept
{
	// lua_pcall may be entered from an idle base frame or a native host frame.
	// A VM return can also expose a yielded/suspended Lua coroutine whose stack
	// belongs to a future resume. Sharing the GlobalState does not make that
	// coroutine a safe place to push a new protected call.
	if (status != 0) return LuaMutationBoundaryBlocker::ThreadSuspended;
	if (stack == 0 || intop == 0 || outtop == 0 || stack_last == 0)
		return LuaMutationBoundaryBlocker::StackUnavailable;
	if (stack > intop || intop > outtop || outtop > stack_last)
		return LuaMutationBoundaryBlocker::StackOrderInvalid;
	if (base_ci == 0 || current_ci == 0 || end_ci == 0 || call_info_size == 0)
		return LuaMutationBoundaryBlocker::CallInfoUnavailable;
	if (current_ci < base_ci || current_ci >= end_ci
		|| (current_ci - base_ci) % call_info_size != 0)
	{
		return LuaMutationBoundaryBlocker::CallInfoBoundsInvalid;
	}
	if (current_ci == base_ci) return LuaMutationBoundaryBlocker::Ready;
	if (!current_frame_readable || !current_frame_is_function)
		return LuaMutationBoundaryBlocker::CurrentFrameInvalid;
	if (!current_frame_is_c)
		return LuaMutationBoundaryBlocker::LuaFrameActive;
	return LuaMutationBoundaryBlocker::Ready;
}

inline bool safe_runtime_tick_boundary_ready(
	const void* expected_global_state,
	std::uint32_t expected_owner_thread,
	const void* boundary_global_state,
	std::uint32_t boundary_owner_thread,
	std::size_t vm_execution_depth,
	std::size_t renovice_execution_depth,
	bool outer_interpreter_return,
	bool callback_running
) noexcept
{
	// The detour calls this only after the outermost interpreter invocation has
	// returned to its native host. This gate proves VM, thread, and recursion
	// ownership. The separate lua_mutation_boundary_blocker proves that the
	// particular coroutine exposes an idle base frame or a valid native host
	// frame before any stack or protected-call mutation occurs.
	return expected_global_state != nullptr
		&& expected_global_state == boundary_global_state
		&& expected_owner_thread != 0
		&& expected_owner_thread == boundary_owner_thread
		&& vm_execution_depth == 0
		&& renovice_execution_depth == 0
		&& outer_interpreter_return
		&& !callback_running;
}

enum class SafeRuntimeTickBoundaryBlocker
{
	Ready,
	MissingCapturedVm,
	WrongVm,
	MissingOwnerThread,
	WrongOwnerThread,
	VmExecutionActive,
	RenoviceExecutionActive,
	NotOuterInterpreterReturn,
	CallbackActive,
};

inline SafeRuntimeTickBoundaryBlocker safe_runtime_tick_boundary_blocker(
	const void* expected_global_state,
	std::uint32_t expected_owner_thread,
	const void* boundary_global_state,
	std::uint32_t boundary_owner_thread,
	std::size_t vm_execution_depth,
	std::size_t renovice_execution_depth,
	bool outer_interpreter_return,
	bool callback_running
) noexcept
{
	if (expected_global_state == nullptr)
		return SafeRuntimeTickBoundaryBlocker::MissingCapturedVm;
	if (expected_global_state != boundary_global_state)
		return SafeRuntimeTickBoundaryBlocker::WrongVm;
	if (expected_owner_thread == 0)
		return SafeRuntimeTickBoundaryBlocker::MissingOwnerThread;
	if (expected_owner_thread != boundary_owner_thread)
		return SafeRuntimeTickBoundaryBlocker::WrongOwnerThread;
	if (vm_execution_depth != 0)
		return SafeRuntimeTickBoundaryBlocker::VmExecutionActive;
	if (renovice_execution_depth != 0)
		return SafeRuntimeTickBoundaryBlocker::RenoviceExecutionActive;
	if (!outer_interpreter_return)
		return SafeRuntimeTickBoundaryBlocker::NotOuterInterpreterReturn;
	if (callback_running)
		return SafeRuntimeTickBoundaryBlocker::CallbackActive;
	return SafeRuntimeTickBoundaryBlocker::Ready;
}

inline bool safe_runtime_tick_due(
	std::uint64_t now_ms,
	std::uint64_t previous_ms,
	std::uint64_t minimum_interval_ms
) noexcept
{
	// Unsigned subtraction remains correct across the system tick-count wrap.
	return previous_ms == 0 || now_ms - previous_ms >= minimum_interval_ms;
}

inline bool safe_runtime_transaction_should_run(
	bool reload_pending,
	bool startup_pending
) noexcept
{
	// Returning from the DE interpreter does not prove that the native caller
	// which entered it has also returned. Only an explicit RENOVICE transaction
	// may use this boundary. A periodic OpenWF/Pluto scheduler must never be
	// smuggled through it while idle.
	return reload_pending || startup_pending;
}

inline bool idle_vm_generation_work_allowed(
	bool reload_pending,
	bool startup_pending
) noexcept
{
	// A VM execute return can still be nested inside a native Lua C call even
	// when no interpreter invocation remains active. Idle ticks must therefore
	// stay Lua-free. Startup and explicit reload transactions remain authorized
	// to use the captured VM at the existing owner-thread boundary.
	return safe_runtime_transaction_should_run(
		reload_pending, startup_pending);
}

inline bool safe_runtime_control_poll_ready(
	std::uint32_t expected_owner_thread,
	std::uint32_t boundary_owner_thread,
	std::size_t vm_execution_depth,
	std::size_t renovice_execution_depth,
	bool callback_running
) noexcept
{
	// The control poll is deliberately Lua-free: it only latches an OS key edge.
	// It may therefore run after any outer interpreter return on the exact game
	// script thread, even when that return belongs to another DE global state or
	// leaves a suspended Lua host frame. Applying the request remains restricted
	// to safe_runtime_tick_boundary_ready.
	return expected_owner_thread != 0
		&& expected_owner_thread == boundary_owner_thread
		&& vm_execution_depth == 0
		&& renovice_execution_depth == 0
		&& !callback_running;
}

inline bool vm_loader_may_drain_pending(std::size_t renovice_execution_depth) noexcept
{
	// A module loaded by a currently injected chunk is a nested loader boundary,
	// not an independent safe point. Draining there would overwrite the single
	// guarded DE stack/registry transaction that is still active.
	return renovice_execution_depth == 0;
}

inline bool target_addon_may_activate(
	bool loader_passed,
	bool target_boundary_valid,
	std::size_t renovice_execution_depth
) noexcept
{
	return loader_passed && target_boundary_valid
		&& vm_loader_may_drain_pending(renovice_execution_depth);
}

inline bool same_target_addon_context(
	std::uint64_t expected_key,
	const void* expected_global_state,
	std::uint32_t expected_thread,
	std::uint64_t candidate_key,
	const void* candidate_global_state,
	std::uint32_t candidate_thread
) noexcept
{
	return expected_key != 0 && expected_key == candidate_key
		&& expected_global_state != nullptr
		&& expected_global_state == candidate_global_state
		&& expected_thread != 0 && expected_thread == candidate_thread;
}

inline bool same_target_addon_generation(
	std::uint64_t active_content_key,
	std::uintptr_t active_shared_table_identity,
	std::uint64_t desired_content_key,
	std::uintptr_t current_shared_table_identity
) noexcept
{
	// DE can replace `_T` while retaining the same Luau global-state pointer,
	// owner thread, target module key, and addon bytes. Addon closures that
	// captured the old table are no longer attached to gameplay in that case.
	// Treat shared-table identity as part of the generation, not as incidental
	// mutable state hidden behind the VM pointer.
	return active_content_key == desired_content_key
		&& active_shared_table_identity != 0
		&& active_shared_table_identity == current_shared_table_identity;
}

enum class TargetAddonGenerationAction : std::uint8_t
{
	reuse,
	reactivate_roots,
	replace_roots,
};

inline bool target_addon_action_requires_exclusive_mutation(
	bool current_thread_borrows_generation,
	bool target_context_has_active_handlers,
	TargetAddonGenerationAction action
) noexcept
{
	if (!current_thread_borrows_generation || !target_context_has_active_handlers)
		return false;
	// Reuse changes nothing. Root reactivation runs cleanup/activate on the
	// already rooted lifecycle table and never releases a registry key, so the
	// snapshot borrowed by the current VM execution remains valid. Replacing a
	// rooted generation can release keys visible to that snapshot and must wait.
	return action == TargetAddonGenerationAction::replace_roots;
}

inline TargetAddonGenerationAction classify_target_addon_generation_action(
	bool exact_name_and_content_match,
	bool exact_shared_table_match
) noexcept
{
	if (!exact_name_and_content_match)
		return TargetAddonGenerationAction::replace_roots;
	return exact_shared_table_match
		? TargetAddonGenerationAction::reuse
		: TargetAddonGenerationAction::reactivate_roots;
}

inline bool failed_chunk_has_lifecycle_root_to_release(
	bool lifecycle_was_requested,
	bool lifecycle_was_stored
) noexcept
{
	// A protected call can return a non-table before any lifecycle registry root
	// exists. Cleanup must never synthesize a release operation for that case.
	return lifecycle_was_requested && lifecycle_was_stored;
}

inline constexpr std::size_t lua_provider_callback_argument_count() noexcept
{
	// prototype, arguments, upvalues, host diagnostic trace
	return 4;
}

inline constexpr std::size_t lua_provider_trace_argument_index() noexcept
{
	return 3;
}

inline constexpr std::size_t native_provider_callback_argument_count(
	bool after_phase
) noexcept
{
	// before: prototype, instruction, arguments, host diagnostic trace
	// after:  prototype, instruction, arguments, results, host diagnostic trace
	return after_phase ? 5 : 4;
}

inline constexpr std::size_t native_provider_trace_argument_index(
	bool after_phase
) noexcept
{
	return after_phase ? 4 : 3;
}

inline bool target_addon_generation_rebind_required(
	std::size_t desired_count,
	std::size_t active_count,
	bool every_active_generation_uses_current_shared_table
) noexcept
{
	// A file/content comparison alone is not sufficient. DE may replace `_T`
	// without replacing the VM, target module, or addon bytes. In that case the
	// old lifecycle remains registry-rooted but its gameplay/UI fields belong to
	// an unreachable table. Rebind only when membership changed or an active
	// generation is attached to a different exact `_T` object.
	return desired_count != active_count
		|| (desired_count != 0
			&& !every_active_generation_uses_current_shared_table);
}

// ---------------------------------------------------------------------------
// Target module root instances (2026-09-29).
//
// DE loads a module (Loader returns a registry closure whose environment is the
// LOAD environment) and later runs its root prototype in a RUNTIME environment
// that can differ (TopMenu 44.0.2: load ...D8C0, runtime ...2660). Everything the
// root publishes (module globals such as EndlessGetXpForStage) lives in the
// runtime environment, and every closure the root creates inherits it.
//
// Ownership model:
// - Prototype identity is the dispatch authority. A recorded prototype belongs
//   to exactly one loaded module body in one VM and is registry-pinned, so a
//   live closure over it is attributed to that module regardless of which root
//   instance created it. Hooks keyed by prototype therefore dispatch for every
//   instance of the module.
// - Lifecycle binding is made once per VM x module key x generation, like a
//   native modder's hook: normally at the module load. Live run 2026-09-29
//   falsified "follow the most recent root instance": per-instance modules
//   (Frost IceSpike.lua, 3,470 root instances in one session; SurvivalMission,
//   8) paid a clean/load/activate cycle and three log lines per instance, and
//   the cleanup reverted instance state the addon had already applied.
// - A root return is therefore observed only for a module whose desired
//   addons hold NO binding in that VM (for example an activate that needs
//   globals the root publishes, such as Circuit/DuviriUtil). Such a load gets
//   exactly one root-return rebind per generation, in the environment the
//   root published into (see select rule below: the environment of the child
//   closures the root created, else the root closure's environment at return).
//   A bound module is not watched at all: zero per-instance work.
// ---------------------------------------------------------------------------
enum class TargetRootReturnAction : std::uint8_t
{
	not_a_target_root,
	same_environment,
	rebind,
};

// Watch-set and apply-time predicate for the root-return lifecycle retry.
inline constexpr bool target_root_return_watch_required(
	bool desired, bool bound, bool retry_spent_this_generation) noexcept
{
	return desired && !bound && !retry_spent_this_generation;
}

// ---------------------------------------------------------------------------
// Where a module root actually publishes (2026-09-29, fix 3).
//
// Live evidence (44.0.2, pid 23260): DuviriUtil's root calls
// `module(..., package.seeall)`, yet its root closure environment at return was
// the SAME table as at entry (`entry_env == runtime_env`), and an addon bound
// there still read `EndlessGetXpForStage == nil`. So DE's `module` does not
// re-point the root closure's environment; the root's own globals land in the
// table its child functions resolve globals through.
//
// Generic rule, no module-specific branch: every function a root defines is a
// closure over one of the root prototype's direct child prototypes, and Luau
// NEWCLOSURE/DUPCLOSURE give it the environment in force at its creation. The
// module's own code therefore resolves every published global through exactly
// that environment. At the root's normal return its dead register window still
// holds the last closures it created (no GC step can run before the settle), so
// the published environment is the environment those child closures agree on.
// - no child closure in the window: keep the root closure environment;
// - child closures disagree: ambiguous, keep the root closure environment;
// - otherwise: the child-closure environment (it may equal the root one).
// ---------------------------------------------------------------------------
inline constexpr std::size_t de_proto_children_offset = 0x18;    // Proto** p
inline constexpr std::size_t de_proto_child_count_offset = 0x8c; // int sizep
inline constexpr std::size_t maximum_root_child_prototypes = 4096;

enum class RootEnvironmentSource : std::uint8_t
{
	root_closure = 0,
	child_closure = 1,
	ambiguous = 2,
};

inline const char* root_environment_source_label(RootEnvironmentSource source) noexcept
{
	switch (source)
	{
	case RootEnvironmentSource::root_closure: return "root-closure";
	case RootEnvironmentSource::child_closure: return "child-closure";
	case RootEnvironmentSource::ambiguous: return "ambiguous-kept-root-closure";
	}
	return "unknown";
}

struct RootEnvironmentChoice
{
	void* environment = nullptr;
	RootEnvironmentSource source = RootEnvironmentSource::root_closure;
};

// Streaming, allocation-free form used by the settle path: feed each child
// closure environment found in the dead register window.
struct RootEnvironmentAccumulator
{
	void* child_environment = nullptr;
	std::uint32_t child_closures = 0;
	bool disagreement = false;

	void add(void* environment) noexcept
	{
		if (environment == nullptr) return;
		++child_closures;
		if (child_environment == nullptr) child_environment = environment;
		else if (child_environment != environment) disagreement = true;
	}

	RootEnvironmentChoice choose(void* root_closure_environment) const noexcept
	{
		if (child_closures == 0)
			return {root_closure_environment, RootEnvironmentSource::root_closure};
		if (disagreement)
			return {root_closure_environment, RootEnvironmentSource::ambiguous};
		return {child_environment, RootEnvironmentSource::child_closure};
	}
};

inline bool proto_is_direct_child(
	const void* const* children,
	std::size_t count,
	const void* candidate) noexcept
{
	if (children == nullptr || candidate == nullptr) return false;
	for (std::size_t i = 0; i != count; ++i)
	{
		if (children[i] == candidate) return true;
	}
	return false;
}

// Pure model of the identity update performed at an observed root return.
// Identity must expose: target_key, global_state, environment, root_proto,
// runtime_root. `latest` is the reverse-search result used by activation.
template <typename Identity>
inline TargetRootReturnAction record_target_root_return(
	std::vector<Identity>& identities,
	std::uint64_t target_key,
	const void* global_state,
	const void* root_proto,
	void* runtime_environment,
	Identity* created = nullptr)
{
	if (target_key == 0 || global_state == nullptr || root_proto == nullptr
		|| runtime_environment == nullptr)
	{
		return TargetRootReturnAction::not_a_target_root;
	}
	const Identity* latest = nullptr;
	const Identity* load = nullptr;
	for (auto it = identities.rbegin(); it != identities.rend(); ++it)
	{
		if (it->target_key != target_key || it->global_state != global_state)
			continue;
		if (latest == nullptr) latest = &*it;
		if (load == nullptr && !it->runtime_root && it->root_proto == root_proto)
			load = &*it;
	}
	if (load == nullptr) return TargetRootReturnAction::not_a_target_root;
	if (latest != nullptr && latest->root_proto == root_proto
		&& latest->environment == runtime_environment)
	{
		return TargetRootReturnAction::same_environment;
	}
	Identity runtime = *load;
	runtime.environment = runtime_environment;
	runtime.runtime_root = true;
	identities.erase(std::remove_if(identities.begin(), identities.end(),
		[&](const Identity& candidate)
		{
			return candidate.runtime_root && candidate.target_key == target_key
				&& candidate.global_state == global_state
				&& candidate.root_proto == root_proto;
		}), identities.end());
	identities.push_back(runtime);
	if (created != nullptr) *created = runtime;
	return TargetRootReturnAction::rebind;
}

struct TargetPrototypeOwner
{
	std::uint64_t target_key = 0;
	std::int32_t bytecode_id = -1;
	bool exact = false;
	bool strict_environment = false;
	bool ambiguous = false;
};

// Attribute a live Lua closure to a target module by exact prototype identity.
// A strict environment match is preferred (and reported); otherwise the exact
// prototype of the same VM is accepted. Different keys claiming the closure
// reject as ambiguous. `live(record)` must prove the recorded prototype is still
// the same live prototype (code pointer, instruction count and bytecode id).
template <typename Identity, typename Live>
inline TargetPrototypeOwner select_target_prototype_owner(
	const std::vector<Identity>& identities,
	const void* global_state,
	const void* closure_environment,
	std::uintptr_t closure_proto,
	Live&& live)
{
	TargetPrototypeOwner strict;
	TargetPrototypeOwner exact;
	if (global_state == nullptr || closure_proto == 0) return {};
	const auto find = [](const auto& records, std::uintptr_t address)
		-> decltype(&*records.begin())
	{
		const auto found = std::lower_bound(records.begin(), records.end(), address,
			[](const auto& candidate, std::uintptr_t value)
			{
				return candidate.address < value;
			});
		return found != records.end() && found->address == address ? &*found : nullptr;
	};
	for (auto it = identities.rbegin(); it != identities.rend(); ++it)
	{
		if (it->target_key == 0 || it->global_state != global_state
			|| it->root_proto == nullptr)
		{
			continue;
		}
		const auto* const root = find(it->prototypes,
			reinterpret_cast<std::uintptr_t>(it->root_proto));
		const auto* const prototype = find(it->prototypes, closure_proto);
		if (root == nullptr || root->parent != 0 || prototype == nullptr
			|| !live(*root) || (prototype != root && !live(*prototype)))
		{
			continue;
		}
		auto& slot = (closure_environment != nullptr
			&& it->environment == closure_environment) ? strict : exact;
		if (slot.exact && slot.target_key != it->target_key)
		{
			slot.ambiguous = true;
			continue;
		}
		slot.target_key = it->target_key;
		slot.bytecode_id = prototype->bytecode_id;
		slot.exact = true;
	}
	if (strict.exact && !strict.ambiguous)
	{
		if (exact.exact && exact.target_key != strict.target_key) return {0, -1, false, false, true};
		strict.strict_environment = true;
		return strict;
	}
	if (strict.ambiguous || exact.ambiguous) return {0, -1, false, false, true};
	return exact;
}

// Bounded operational copy of a Lua error string for logs. Printable ASCII is
// kept; quotes/backslashes become apostrophes/slashes; control and non-ASCII
// bytes become '?'. Always NUL-terminates and marks truncation with "...".
inline std::size_t sanitize_error_text(
	const char* text,
	std::size_t length,
	char* output,
	std::size_t capacity) noexcept
{
	if (output == nullptr || capacity == 0) return 0;
	output[0] = '\0';
	if (text == nullptr || capacity < 4) return 0;
	const std::size_t room = capacity - 1;
	const bool truncated = length > room;
	const std::size_t kept = truncated ? room - 3 : length;
	for (std::size_t i = 0; i != kept; ++i)
	{
		const auto c = static_cast<unsigned char>(text[i]);
		char mapped = '?';
		if (c == '"') mapped = '\'';
		else if (c == '\\') mapped = '/';
		else if (c == '\n' || c == '\r' || c == '\t') mapped = ' ';
		else if (c >= 0x20 && c < 0x7f) mapped = static_cast<char>(c);
		output[i] = mapped;
	}
	std::size_t written = kept;
	if (truncated)
	{
		output[written++] = '.';
		output[written++] = '.';
		output[written++] = '.';
	}
	output[written] = '\0';
	return written;
}

inline constexpr std::size_t lua_error_text_capacity = 192;

inline bool valid_target_closure_environment(
	bool borrowed_value_is_function,
	bool closure_readable,
	bool environment_readable
) noexcept
{
	return borrowed_value_is_function && closure_readable && environment_readable;
}

inline bool same_target_hook_module(
	const void* expected_global_state,
	const void* expected_root_proto,
	const void* expected_environment,
	const void* candidate_global_state,
	const void* candidate_proto,
	const void* candidate_environment
) noexcept
{
	// A target hook belongs to one natural module load inside one DE VM.  The
	// root closure is identified by its exact proto; nested callbacks inherit
	// the module environment.  Neither identity is allowed to cross a VM.
	return expected_global_state != nullptr
		&& expected_global_state == candidate_global_state
		&& ((expected_root_proto != nullptr
				&& expected_root_proto == candidate_proto)
			|| (expected_environment != nullptr
				&& expected_environment == candidate_environment));
}

inline bool lua_call_request_supported(
	bool before,
	bool after
) noexcept
{
	// Exact CALL admission can run a before provider without retaining any VM
	// roots or generation state. An after provider needs the complete RETURN,
	// yield, protected-error, resume-error and record-cleanup retirement map.
	// Reject it as a declaration until every owner is implemented and tested.
	return before && !after;
}

inline bool same_target_root_execution(
	const void* expected_global_state,
	const void* expected_root_proto,
	const void* expected_environment,
	const void* candidate_global_state,
	const void* candidate_proto,
	const void* candidate_environment
) noexcept
{
	// Post-initialization export decoration must run only for the exact module
	// root. Nested ability callbacks intentionally share the environment and are
	// accepted by same_target_hook_module, but they are not initialization.
	return expected_global_state != nullptr
		&& expected_global_state == candidate_global_state
		&& expected_root_proto != nullptr
		&& expected_root_proto == candidate_proto
		&& expected_environment != nullptr
		&& expected_environment == candidate_environment;
}

inline bool native_hook_binding_valid(
	std::size_t candidate_entries,
	std::size_t distinct_original_functions
) noexcept
{
	// Multiple SWIG aliases are safe only when they all resolve to the same
	// native implementation.  Ambiguity fails closed instead of guessing.
	return candidate_entries != 0 && distinct_original_functions == 1;
}

inline bool exact_native_call_bindings_valid(
	std::size_t candidate_entries,
	std::size_t distinct_original_functions,
	std::size_t already_planned_hooks,
	std::size_t maximum_hooks
) noexcept
{
	// Generic nativeCalls are dispatched only after the target body, VM,
	// prototype, and instruction have matched. It is therefore valid to detour
	// every distinct SWIG implementation of one method hash and let the exact
	// callsite select the provider. Semantic/global adapters do not use this
	// rule; native_hook_binding_valid above still rejects their ambiguity.
	return candidate_entries != 0
		&& distinct_original_functions != 0
		&& distinct_original_functions <= candidate_entries
		&& already_planned_hooks <= maximum_hooks
		&& distinct_original_functions <= maximum_hooks - already_planned_hooks;
}

inline bool native_detour_bundle_valid(
	bool damage_callback_created,
	bool damage_callback_trampoline,
	bool source_object_created,
	bool source_object_trampoline
) noexcept
{
	// SetSourceObject carries the real source ability and is therefore the
	// complete semantic boundary: target matching and callback installation both
	// happen there. SetSource and Lua-stack ownership are intentionally absent.
	return damage_callback_created && damage_callback_trampoline
		&& source_object_created && source_object_trampoline;
}

inline bool native_hook_adapter_bundle_valid(
	bool damage_requested,
	bool callsite_requested,
	bool damage_callback_created,
	bool source_object_created,
	bool push_float_argument_created,
	bool native_call_hooks_created
) noexcept
{
	// Damage is dispatched by the callback itself, so registration and source
	// association are the complete transport. Exact native-call transforms use
	// their separately declared detour set. The legacy PushFloatArg callback is
	// retained as an independent compatibility path.
	return (!damage_requested || (damage_callback_created
			&& source_object_created))
		&& (!callsite_requested || push_float_argument_created)
		&& native_call_hooks_created;
}

inline bool native_hook_contract_covered(
	unsigned int installed_mask,
	const std::vector<std::string>& installed_methods,
	unsigned int requested_mask,
	const std::vector<std::string>& requested_methods) noexcept
{
	if ((installed_mask & requested_mask) != requested_mask) return false;
	return std::all_of(
		requested_methods.begin(), requested_methods.end(),
		[&](const std::string& method)
		{
			return std::binary_search(
				installed_methods.begin(), installed_methods.end(), method);
		});
}

inline std::vector<std::string> merge_native_hook_methods(
	std::vector<std::string> installed,
	const std::vector<std::string>& requested)
{
	installed.insert(installed.end(), requested.begin(), requested.end());
	std::sort(installed.begin(), installed.end());
	installed.erase(std::unique(installed.begin(), installed.end()), installed.end());
	return installed;
}

enum class RunScriptObservationDecision
{
	PassThroughDisabled,
	PassThroughReentry,
	PassThroughArgumentShape,
	PassThroughQueryShape,
	ObserveAbilityCard,
};

inline RunScriptObservationDecision classify_run_script_observation(
	bool enabled,
	bool reentrant,
	std::size_t argument_count,
	bool synchronous_flag_is_boolean,
	bool synchronous_flag,
	bool query_is_table,
	bool query_has_ability
) noexcept
{
	// The current ability-card caller has the corpus-proven four-argument
	// RunScript shape and requests synchronous execution.  The _T query table is
	// the semantic discriminator; unrelated RunScript calls remain untouched.
	if (!enabled) return RunScriptObservationDecision::PassThroughDisabled;
	if (reentrant) return RunScriptObservationDecision::PassThroughReentry;
	if (argument_count != 4 || !synchronous_flag_is_boolean || !synchronous_flag)
	{
		return RunScriptObservationDecision::PassThroughArgumentShape;
	}
	if (!query_is_table || !query_has_ability)
	{
		return RunScriptObservationDecision::PassThroughQueryShape;
	}
	return RunScriptObservationDecision::ObserveAbilityCard;
}

enum class RunScriptObservationResult
{
	OriginalResultCountChanged,
	MissingAbilityCardResult,
	Complete,
};

inline bool should_sample_run_script_entry(
	std::size_t entry_sequence,
	std::size_t synchronous_candidate_sequence,
	std::size_t argument_count,
	bool synchronous_flag_is_boolean,
	bool synchronous_flag
) noexcept
{
	return entry_sequence <= 64
		|| (argument_count == 4
			&& synchronous_flag_is_boolean
			&& synchronous_flag
			&& synchronous_candidate_sequence <= 256);
}

inline RunScriptObservationResult classify_run_script_observation_result(
	int original_result_count,
	bool result_is_table
) noexcept
{
	// All seven current corpus RunScript sites discard its return.  A changed C
	// result count is recorded as an ABI warning even if a result table exists.
	if (original_result_count != 0)
	{
		return RunScriptObservationResult::OriginalResultCountChanged;
	}
	return result_is_table
		? RunScriptObservationResult::Complete
		: RunScriptObservationResult::MissingAbilityCardResult;
}

inline bool run_script_target_binding_candidate(
	bool enabled,
	std::size_t argument_count,
	bool synchronous_flag_is_boolean,
	bool synchronous_flag,
	std::uintptr_t script_resource_identity
) noexcept
{
	// Ownership discovery intentionally does not require the card query table.
	// The game may load the target script in a preceding synchronous RunScript
	// call and populate _T only in the later card-provider call.
	return enabled
		&& argument_count == 4
		&& synchronous_flag_is_boolean
		&& synchronous_flag
		&& script_resource_identity != 0;
}

inline bool target_script_binding_capture_allowed(
	std::uint64_t target_key,
	const void* loader_global_state,
	std::uint32_t loader_thread,
	bool run_script_boundary_active,
	const void* boundary_global_state,
	std::uint32_t boundary_thread,
	std::uintptr_t script_resource_identity
) noexcept
{
	// A target body key becomes associated with a DE script resource only while
	// that resource's synchronous RunScript transaction is actively causing the
	// natural module load. This is base-module ownership, not object-instance
	// discovery and not a timing heuristic.
	return target_key != 0
		&& loader_global_state != nullptr
		&& run_script_boundary_active
		&& loader_global_state == boundary_global_state
		&& loader_thread != 0
		&& loader_thread == boundary_thread
		&& script_resource_identity != 0;
}

inline bool same_target_script_binding(
	std::uint64_t expected_target_key,
	const void* expected_global_state,
	std::uintptr_t expected_script_resource,
	std::uint64_t candidate_target_key,
	const void* candidate_global_state,
	std::uintptr_t candidate_script_resource
) noexcept
{
	return expected_target_key != 0
		&& expected_target_key == candidate_target_key
		&& expected_global_state != nullptr
		&& expected_global_state == candidate_global_state
		&& expected_script_resource != 0
		&& expected_script_resource == candidate_script_resource;
}

inline bool valid_target_hook_contract(
	bool hooks_is_absent,
	bool hooks_is_table,
	bool matches_ability_is_function,
	bool matches_damage_source_is_function,
	bool after_card_is_function,
	bool after_damage_is_function,
	bool transform_float_argument_is_absent_or_function,
	bool native_calls_is_absent_or_table,
	bool lua_calls_is_absent_or_table
) noexcept
{
	// A target addon is first and foremost an arbitrary lifecycle chunk loaded
	// into the exact target module environment.  The native card/damage bus is
	// optional infrastructure, not a prerequisite for target injection.
	if (hooks_is_absent) return true;
	if (!hooks_is_table || !transform_float_argument_is_absent_or_function
		|| !native_calls_is_absent_or_table || !lua_calls_is_absent_or_table)
		return false;

	// Card queries use matchesAbility because the central RunScript boundary can
	// serve many abilities. Native damage ownership is already supplied by the
	// content-keyed target module and its exact hashed mOwner identity;
	// matchesDamageSource remains an optional fallback.
	(void)matches_damage_source_is_function;
	(void)after_damage_is_function;
	return !after_card_is_function || matches_ability_is_function;
}

inline bool valid_lua_call_prototype_id(
	float value,
	std::int32_t maximum = 1 << 20
) noexcept
{
	if (!(value >= 0.0f) || value > static_cast<float>(maximum)) return false;
	const auto integral = static_cast<std::int32_t>(value);
	return static_cast<float>(integral) == value;
}

inline bool target_lua_scalar_mutation_allowed(
	std::uint32_t original_type,
	std::uint32_t candidate_type,
	bool candidate_number_is_finite
) noexcept
{
	// Only same-tag numeric and boolean values can be copied into a live closure.
	// Tables and other GC values remain usable by reference, but replacing their
	// identity here would require the VM's private write barrier.
	constexpr std::uint32_t boolean_type = 1;
	constexpr std::uint32_t number_type = 3;
	return original_type == candidate_type
		&& (original_type == boolean_type
			|| (original_type == number_type && candidate_number_is_finite));
}

inline bool target_lua_argument_mutation_allowed(
	bool before_phase,
	std::uint32_t original_type,
	std::uint32_t candidate_type,
	bool candidate_number_is_finite
) noexcept
{
	// Function arguments can affect stock execution only at the exact entry
	// boundary. Keep the same scalar-only rule as closure upvalues so no GC
	// reference is installed without the VM's private write barrier.
	return before_phase && target_lua_scalar_mutation_allowed(
		original_type, candidate_type, candidate_number_is_finite);
}

inline bool target_addon_requires_native_callsite_adapters(
	bool transform_float_argument_is_function
) noexcept
{
	return transform_float_argument_is_function;
}

inline bool target_addon_requires_execution_identity(
	bool requires_native_damage_adapters,
	bool requires_native_callsite_adapters,
	bool requires_lua_call_hooks,
	bool has_native_call_requests
) noexcept
{
	// All four transports resolve ownership through the target's published
	// prototype graph. nativeCalls is independent of the legacy
	// transformFloatArgument hook and must publish the graph on its own.
	return requires_native_damage_adapters
		|| requires_native_callsite_adapters
		|| requires_lua_call_hooks
		|| has_native_call_requests;
}

inline bool instruction_from_saved_pc(
	std::uintptr_t code,
	std::int32_t instruction_count,
	std::uintptr_t saved_pc,
	std::uint32_t& instruction
) noexcept
{
	instruction = 0;
	if (code < 0x10000 || code % sizeof(std::uint32_t) != 0
		|| instruction_count <= 0 || saved_pc <= code
		|| saved_pc % sizeof(std::uint32_t) != 0)
	{
		return false;
	}
	const auto byte_count = static_cast<std::uintptr_t>(instruction_count)
		* sizeof(std::uint32_t);
	if (code > (std::numeric_limits<std::uintptr_t>::max)() - byte_count
		|| saved_pc > code + byte_count)
	{
		return false;
	}
	const auto next_instruction = (saved_pc - code) / sizeof(std::uint32_t);
	if (next_instruction == 0 || next_instruction >
		static_cast<std::uintptr_t>(instruction_count))
	{
		return false;
	}
	instruction = static_cast<std::uint32_t>(next_instruction - 1);
	return true;
}

struct DeLuaCallInstruction
{
	std::uint8_t register_a = 0;
	std::uint8_t encoded_arguments_b = 0;
	std::uint8_t encoded_results_c = 0;
};

inline bool decode_de_lua_call_instruction(
	std::uint32_t raw,
	DeLuaCallInstruction& decoded,
	bool u44 = false
) noexcept
{
	decoded = {};
	if (renovice::bytecode::canonical_opcode(static_cast<std::uint8_t>(raw), u44) != 0x54u) return false;
	decoded.register_a = static_cast<std::uint8_t>(raw >> 8);
	decoded.encoded_arguments_b = static_cast<std::uint8_t>(raw >> 16);
	decoded.encoded_results_c = static_cast<std::uint8_t>(raw >> 24);
	return true;
}

struct DeLuaCallWindow
{
	std::uintptr_t function_slot = 0;
	std::uintptr_t argument_base = 0;
	std::size_t argument_count = 0;
};

inline bool resolve_de_lua_call_window(
	std::uint32_t raw,
	std::uintptr_t frame_base,
	std::uintptr_t frame_limit,
	std::uintptr_t live_top,
	std::uintptr_t stack_begin,
	std::uintptr_t stack_end,
	std::size_t value_size,
	std::size_t maximum_arguments,
	DeLuaCallWindow& window,
	bool u44 = false
) noexcept
{
	window = {};
	DeLuaCallInstruction decoded;
	if (!decode_de_lua_call_instruction(raw, decoded, u44)
		|| value_size == 0 || maximum_arguments == 0
		|| stack_begin == 0 || stack_end <= stack_begin
		|| frame_base < stack_begin || frame_base >= stack_end
		|| frame_limit <= frame_base || frame_limit > stack_end
		|| live_top < frame_base || live_top > frame_limit
		|| (frame_base - stack_begin) % value_size != 0
		|| (frame_limit - stack_begin) % value_size != 0
		|| (live_top - stack_begin) % value_size != 0)
	{
		return false;
	}

	const auto a_bytes = static_cast<std::uintptr_t>(decoded.register_a)
		* static_cast<std::uintptr_t>(value_size);
	if (frame_base > (std::numeric_limits<std::uintptr_t>::max)() - a_bytes)
		return false;
	window.function_slot = frame_base + a_bytes;
	if (window.function_slot >= frame_limit
		|| window.function_slot > (std::numeric_limits<std::uintptr_t>::max)()
			- static_cast<std::uintptr_t>(value_size))
	{
		window = {};
		return false;
	}
	window.argument_base = window.function_slot + value_size;

	std::uintptr_t argument_end = 0;
	if (decoded.encoded_arguments_b == 0)
	{
		if (live_top < window.argument_base)
		{
			window = {};
			return false;
		}
		argument_end = live_top;
	}
	else
	{
		window.argument_count = static_cast<std::size_t>(
			decoded.encoded_arguments_b - 1u);
		if (window.argument_count > maximum_arguments
			|| window.argument_count > (std::numeric_limits<std::uintptr_t>::max)()
				/ value_size)
		{
			window = {};
			return false;
		}
		const auto argument_bytes = static_cast<std::uintptr_t>(
			window.argument_count * value_size);
		if (window.argument_base > (std::numeric_limits<std::uintptr_t>::max)()
			- argument_bytes)
		{
			window = {};
			return false;
		}
		argument_end = window.argument_base + argument_bytes;
	}

	if (argument_end > frame_limit || argument_end > stack_end
		|| (argument_end - window.argument_base) % value_size != 0)
	{
		window = {};
		return false;
	}
	if (decoded.encoded_arguments_b == 0)
	{
		window.argument_count = static_cast<std::size_t>(
			(argument_end - window.argument_base) / value_size);
		if (window.argument_count > maximum_arguments)
		{
			window = {};
			return false;
		}
	}
	return true;
}

inline bool de_instruction_has_aux_word(std::uint8_t opcode) noexcept
{
	// U43 DE opcode widths, shared with the certified compiler's
	// tc::is_de_width8 table. The VM program counter advances over raw 32-bit
	// words, while the API catalog numbers decoded instructions.
	switch (opcode)
	{
	case 0x02: case 0x03: case 0x0c: case 0x0f: case 0x15: case 0x17:
	case 0x1c: case 0x1e: case 0x20: case 0x21: case 0x23: case 0x26:
	case 0x27: case 0x2c: case 0x2d: case 0x33: case 0x34: case 0x36:
	case 0x37: case 0x3a: case 0x3d: case 0x3f: case 0x41: case 0x43:
	case 0x46: case 0x4a:
		return true;
	default:
		return false;
	}
}

inline bool native_callsite_instruction_from_saved_pc(
	const std::uint32_t* code,
	std::int32_t raw_word_count,
	const std::uint32_t* saved_pc,
	std::uint32_t& instruction,
	bool u44 = false
) noexcept
{
	instruction = 0;
	if (code == nullptr || saved_pc == nullptr || raw_word_count <= 0)
		return false;

	std::uint32_t calling_word = 0;
	if (!instruction_from_saved_pc(
			reinterpret_cast<std::uintptr_t>(code), raw_word_count,
			reinterpret_cast<std::uintptr_t>(saved_pc), calling_word))
	{
		return false;
	}

	std::uint32_t raw_word = 0;
	std::uint32_t logical_instruction = 0;
	std::uint8_t previous_opcode = 0;
	bool has_previous = false;
	while (raw_word < static_cast<std::uint32_t>(raw_word_count))
	{
		if (raw_word == calling_word)
		{
			const auto opcode = renovice::bytecode::canonical_opcode(static_cast<std::uint8_t>(code[raw_word]), u44);
			// The catalog addresses the NAMECALL that names the native method.
			// At native C-function entry savedpc points immediately after the
			// following CALL, so map that pair back to the catalog instruction.
			if (opcode == 0x54 && has_previous && previous_opcode == 0x2d)
			{
				instruction = logical_instruction - 1;
				return true;
			}
			instruction = logical_instruction;
			return true;
		}

		const auto opcode = renovice::bytecode::canonical_opcode(static_cast<std::uint8_t>(code[raw_word]), u44);
		const std::uint32_t width = de_instruction_has_aux_word(opcode) ? 2u : 1u;
		if (raw_word > static_cast<std::uint32_t>(raw_word_count) - width)
			return false;
		previous_opcode = opcode;
		has_previous = true;
		raw_word += width;
		++logical_instruction;
		if (raw_word > calling_word)
			return false; // savedpc resolved to an AUX word, not an instruction.
	}
	return false;
}

inline bool target_addon_requires_native_damage_adapters(
	bool matches_damage_source_is_function,
	bool after_damage_is_function
) noexcept
{
	// Card-only target addons do not alter the native damage path. afterDamage is
	// the explicit opt-in; matchesDamageSource is an optional fallback for calls
	// that cannot be attributed to the exact target module execution scope.
	(void)matches_damage_source_is_function;
	return after_damage_is_function;
}

inline bool target_execution_scope_matches(
	std::uint64_t target_key,
	const void* execution_global_state,
	const void* callback_global_state
) noexcept
{
	return target_key != 0
		&& execution_global_state != nullptr
		&& execution_global_state == callback_global_state;
}

inline bool merge_target_ability_match(
	std::uint64_t candidate_target_key,
	std::uint64_t& selected_target_key
) noexcept
{
	if (candidate_target_key == 0) return true;
	if (selected_target_key == 0)
	{
		selected_target_key = candidate_target_key;
		return true;
	}
	return selected_target_key == candidate_target_key;
}

inline std::uint64_t select_exact_stack_target(
	std::uint64_t strict_closure_target,
	bool strict_closure_ambiguous,
	std::uint64_t exact_prototype_target,
	bool exact_prototype_callsite
) noexcept
{
	// Ambiguity always wins. Otherwise preserve the stronger closure/environment
	// match and admit the prototype route only when the current saved PC proves
	// one exact current-generation target.
	if (strict_closure_ambiguous) return 0;
	if (strict_closure_target != 0) return strict_closure_target;
	return exact_prototype_callsite ? exact_prototype_target : 0;
}

inline bool valid_target_call_stack_bounds(
	std::uintptr_t current_call,
	std::uintptr_t base_call,
	std::size_t call_info_size,
	std::size_t maximum_frames
) noexcept
{
	if (current_call == 0 || base_call == 0 || call_info_size == 0
		|| maximum_frames == 0 || current_call < base_call)
	{
		return false;
	}
	const auto distance = current_call - base_call;
	return distance % call_info_size == 0
		&& distance / call_info_size < maximum_frames;
}

inline bool target_addon_refresh_required(
	bool desired_generation_exists,
	bool active_generation_exists
) noexcept
{
	// Creation, replacement, and deletion are all transactions.  Deletion still
	// needs a VM-local pass so cleanup runs and the registry root is released.
	return desired_generation_exists || active_generation_exists;
}

inline bool target_addon_refresh_ready(
	const void* expected_global_state,
	std::uint32_t expected_owner_thread,
	const void* boundary_global_state,
	std::uint32_t boundary_owner_thread
) noexcept
{
	return expected_global_state != nullptr
		&& expected_global_state == boundary_global_state
		&& expected_owner_thread != 0
		&& expected_owner_thread == boundary_owner_thread;
}

inline bool consume_f9_signal(
	bool down,
	bool pressed_since_poll,
	bool allow_reload,
	bool& was_down
) noexcept
{
	// GetAsyncKeyState's low bit preserves a quick tap that begins and ends
	// between two DE script ticks. The high-bit transition remains the fallback
	// for held keys. Both are reduced to one pending transaction.
	// A held key may continue setting GetAsyncKeyState's low bit through OS key
	// repeat. Use that bit only for a complete tap observed while currently up;
	// the high-bit edge owns ordinary presses.
	const bool pressed = allow_reload
		&& ((down && !was_down) || (!down && pressed_since_poll));
	// Always record both press and release, including while Warframe is not the
	// foreground window. Otherwise an alt-tab after F9 can leave the latch stuck
	// in the down state and silently suppress the next legitimate press.
	was_down = down;
	return pressed;
}
}
