#pragma once

#include <algorithm>
#include <cctype>
#include <string>
#include <string_view>

namespace renovice::script_control
{
enum class Kind
{
	OneShot,
	Addon,
	TargetAddon,
	Replacement,
	// A folder under CustomScripts\Packages that bundles several members into
	// one row and one policy. Appended last so every existing kind keeps its
	// ordinal, sort position and stable-ID prefix.
	Package,
};

inline std::string ascii_lower(std::string_view value)
{
	std::string output(value);
	std::transform(output.begin(), output.end(), output.begin(), [](unsigned char c)
	{
		return static_cast<char>(std::tolower(c));
	});
	return output;
}

inline std::string stable_id(Kind kind, std::string_view filename)
{
	const char* prefix = "inject:";
	switch (kind)
	{
	case Kind::OneShot: prefix = "oneshot:"; break;
	case Kind::Addon: prefix = "addon:"; break;
	case Kind::TargetAddon: prefix = "target-addon:"; break;
	case Kind::Replacement: prefix = "replacement:"; break;
	case Kind::Package: prefix = "package:"; break;
	}
	return std::string(prefix) + ascii_lower(filename);
}

// Per-member enable policy inside a folder package (2026-09-30):
// `member:<package folder>/<member filename>`, lowercased like every other ID.
// Member rows never appear in the SCRIPTS menu; they are edited from SCRIPT
// SETTINGS (or by hand) and stored in the same ScriptStates.json authority.
inline constexpr std::string_view member_state_prefix = "member:";

inline std::string member_state_id(std::string_view folder, std::string_view filename)
{
	std::string id(member_state_prefix);
	id += ascii_lower(folder);
	id.push_back('/');
	id += ascii_lower(filename);
	return id;
}

inline bool is_member_state_id(std::string_view id) noexcept
{
	return id.size() > member_state_prefix.size()
		&& id.substr(0, member_state_prefix.size()) == member_state_prefix;
}

inline bool is_internal_hook_shim(std::string_view filename)
{
	// Target-module call edges are bootstrapper infrastructure, not optional
	// player scripts. New shims use the explicit suffix; the legacy Mallet name
	// remains recognized so existing deployments migrate without a file rename.
	const auto lower = ascii_lower(filename);
	return lower.find(".internal-hook-shim.") != std::string::npos
		|| lower.find(" explicit hook shim ") != std::string::npos;
}

inline const char* kind_label(Kind kind) noexcept
{
	switch (kind)
	{
	case Kind::OneShot: return "ONE-SHOT";
	case Kind::Addon: return "ADDON";
	case Kind::TargetAddon: return "TARGET ADDON";
	case Kind::Replacement: return "REPLACEMENT";
	case Kind::Package: return "PACKAGE";
	}
	return "UNKNOWN";
}

inline const char* menu_kind_label(Kind kind) noexcept
{
	switch (kind)
	{
	case Kind::OneShot: return "ONE-SHOT";
	case Kind::Addon:
	case Kind::TargetAddon: return "ADDON";
	case Kind::Replacement: return "REPLACEMENT";
	case Kind::Package: return "PACKAGE";
	}
	return "UNKNOWN";
}

inline bool ascii_hex(char c) noexcept
{
	const auto lower = static_cast<unsigned char>(std::tolower(
		static_cast<unsigned char>(c)));
	return (lower >= '0' && lower <= '9') || (lower >= 'a' && lower <= 'f');
}

inline std::string canonical_display_name(std::string_view generated_name)
{
	// Presentation aliases deliberately do not alter filenames or stable IDs.
	// These five historical scripts predate a display-name convention and contain
	// internal jargon, joined words, and one filename typo. Keep their loader
	// identities intact while giving the native menu one consistent vocabulary.
	const std::string key = ascii_lower(generated_name);
	if (key == "malletoverguardandcard"
		|| key == "mallet overguard and card")
	{
		return "Mallet: Overguard and Ability Card";
	}
	if (key == "mallet explicit hook shim threat5"
		|| key == "mallet explicit hook shim threat 5")
	{
		return "Internal Hook Shim";
	}
	if (key == "octavia amp buff no distance")
	{
		return "Octavia Amp: No Range Limit";
	}
	if (key == "riven lock script")
	{
		return "Riven Rerolls: Stat Locks";
	}
	if (key == "octavia metrone allscript"
		|| key == "octavia metronome all script")
	{
		return "Octavia Metronome: All Rhythm Buffs";
	}
	return std::string(generated_name);
}

inline std::string display_name(std::string_view filename)
{
	std::string value(filename);
	const auto lower = ascii_lower(value);
	for (const std::string_view suffix : {std::string_view{".lua_b"}, std::string_view{".luau"}, std::string_view{".lua"}})
	{
		if (lower.size() >= suffix.size()
			&& lower.compare(lower.size() - suffix.size(), suffix.size(), suffix) == 0)
		{
			value.resize(value.size() - suffix.size());
			break;
		}
	}

	// Replacement and target-addon files conventionally begin with the exact
	// 64-bit script key.  That identifier is useful to the loader, not to the
	// player-facing menu.
	if (value.size() >= 16
		&& std::all_of(value.begin(), value.begin() + 16, ascii_hex))
	{
		value.erase(0, 16);
	}
	while (!value.empty()
		&& (std::isspace(static_cast<unsigned char>(value.front()))
			|| value.front() == '-' || value.front() == '_'))
	{
		value.erase(value.begin());
	}

	std::string output;
	output.reserve(value.size());
	bool new_word = true;
	unsigned char previous = 0;
	for (const unsigned char c : value)
	{
		if (std::isalnum(c))
		{
			if (!new_word && std::isupper(c) && std::islower(previous))
			{
				output.push_back(' ');
				new_word = true;
			}
			output.push_back(static_cast<char>(new_word ? std::toupper(c) : std::tolower(c)));
			new_word = false;
		}
		else if (!output.empty() && output.back() != ' ')
		{
			output.push_back(' ');
			new_word = true;
		}
		previous = c;
	}
	while (!output.empty() && output.back() == ' ') output.pop_back();
	for (const std::string_view suffix : {
		std::string_view{" Targets Addon"}, std::string_view{" Target Addon"},
		std::string_view{" Addon"}})
	{
		if (output.size() >= suffix.size()
			&& output.compare(output.size() - suffix.size(), suffix.size(), suffix) == 0)
		{
			output.resize(output.size() - suffix.size());
			break;
		}
	}
	return output.empty()
		? std::string{"Unnamed Script"}
		: canonical_display_name(output);
}

inline std::string menu_display_name(Kind kind, std::string_view filename)
{
	return std::string{"["} + menu_kind_label(kind) + "] "
		+ display_name(filename);
}

inline const char* toggle_value_label(bool enabled) noexcept
{
	return enabled ? "ON" : "OFF";
}

inline bool valid_state_id(std::string_view id) noexcept
{
	if (id.empty() || id.size() > 512) return false;
	for (const unsigned char c : id)
	{
		if (c < 0x20 || c == 0x7f) return false;
	}
	return true;
}

template <typename State>
inline void overlay_requested(State& effective, const State& requested)
{
	for (const auto& [id, enabled] : requested)
	{
		effective[id] = enabled;
	}
}
}
