#pragma once

#include <algorithm>
#include <cctype>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

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

// Per-member id inside a folder package (2026-09-30):
// `member:<package folder>/<member filename>`, lowercased like every other ID.
// Member rows never appear in the SCRIPTS menu. Contract R13 (2026-10-01): the
// member enable policy is retired (no UI has owned it since Settings R7); a
// stored entry stays valid in ScriptStates.json but the loader reports it and
// stages the member with its package (packages.cpp).
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
// ---------------------------------------------------------------------------
// LAYOUT_V2 (2026-10-10): Config/ScriptStates.json schema 2 =
//   { "schema": 2, "scripts": { <id>: <bool>, ... }, "values": { <package id>: <settings object>, ... } }
// Each `values` entry is the former Settings/<Package>.json object, kept as its exact JSON text so the
// existing settings parser reads it unchanged and no number is ever re-formatted. These helpers locate
// raw value spans and compose the file; JSON validity of the whole file is checked by the caller.
// ---------------------------------------------------------------------------
inline constexpr int state_schema_v2 = 2;

inline void json_skip_ws(std::string_view t, std::size_t& i) noexcept
{
	while (i < t.size() && (t[i] == ' ' || t[i] == '\t' || t[i] == '\r' || t[i] == '\n')) ++i;
}

// Skips one JSON string starting at t[i] == '"'; on success i is past the closing quote and `out`
// holds the unescaped text (\" \ \/ \b \f \n \r \t; \u escapes are kept verbatim, ids never use them).
inline bool json_read_string(std::string_view t, std::size_t& i, std::string& out)
{
	if (i >= t.size() || t[i] != '"') return false;
	out.clear();
	for (++i; i < t.size(); ++i)
	{
		const char c = t[i];
		if (c == '"') { ++i; return true; }
		if (c != '\\') { out += c; continue; }
		if (++i >= t.size()) return false;
		switch (t[i])
		{
		case '"': out += '"'; break;
		case '\\': out += '\\'; break;
		case '/': out += '/'; break;
		case 'b': out += '\b'; break;
		case 'f': out += '\f'; break;
		case 'n': out += '\n'; break;
		case 'r': out += '\r'; break;
		case 't': out += '\t'; break;
		case 'u': out += "\\u"; break;
		default: return false;
		}
	}
	return false;
}

// Skips one JSON value of any kind (structure only; numbers and literals by their character class).
inline bool json_skip_value(std::string_view t, std::size_t& i)
{
	json_skip_ws(t, i);
	if (i >= t.size()) return false;
	std::string scratch;
	if (t[i] == '"') return json_read_string(t, i, scratch);
	if (t[i] == '{' || t[i] == '[')
	{
		const char close = t[i] == '{' ? '}' : ']';
		const bool object = t[i] == '{';
		++i;
		json_skip_ws(t, i);
		if (i < t.size() && t[i] == close) { ++i; return true; }
		while (true)
		{
			if (object)
			{
				json_skip_ws(t, i);
				if (!json_read_string(t, i, scratch)) return false;
				json_skip_ws(t, i);
				if (i >= t.size() || t[i] != ':') return false;
				++i;
			}
			if (!json_skip_value(t, i)) return false;
			json_skip_ws(t, i);
			if (i < t.size() && t[i] == ',') { ++i; continue; }
			if (i < t.size() && t[i] == close) { ++i; return true; }
			return false;
		}
	}
	const std::size_t start = i;
	while (i < t.size() && (std::isalnum(static_cast<unsigned char>(t[i])) || t[i] == '-' || t[i] == '+' || t[i] == '.'))
		++i;
	return i > start;
}

// Members of the JSON object starting at t[i] (after whitespace): (key, exact raw value text).
inline bool json_object_members(std::string_view t, std::size_t i,
	std::vector<std::pair<std::string, std::string_view>>& out)
{
	out.clear();
	json_skip_ws(t, i);
	if (i >= t.size() || t[i] != '{') return false;
	++i;
	json_skip_ws(t, i);
	if (i < t.size() && t[i] == '}') return true;
	while (true)
	{
		json_skip_ws(t, i);
		std::string key;
		if (!json_read_string(t, i, key)) return false;
		json_skip_ws(t, i);
		if (i >= t.size() || t[i] != ':') return false;
		++i;
		json_skip_ws(t, i);
		const std::size_t begin = i;
		if (!json_skip_value(t, i)) return false;
		out.emplace_back(std::move(key), t.substr(begin, i - begin));
		json_skip_ws(t, i);
		if (i < t.size() && t[i] == ',') { ++i; continue; }
		if (i < t.size() && t[i] == '}') return true;
		return false;
	}
}

// The raw `values` entries of a schema-2 state file text (empty when there is no `values` member).
inline bool state_values_spans(std::string_view text,
	std::vector<std::pair<std::string, std::string_view>>& values)
{
	values.clear();
	std::vector<std::pair<std::string, std::string_view>> top;
	if (!json_object_members(text, 0, top)) return false;
	for (const auto& [key, raw] : top)
	{
		if (key != "values") continue;
		return json_object_members(raw, 0, values);
	}
	return true;
}

inline std::string json_quote(std::string_view text)
{
	std::string out = "\"";
	for (const char c : text)
	{
		switch (c)
		{
		case '"': out += "\\\""; break;
		case '\\': out += "\\\\"; break;
		case '\n': out += "\\n"; break;
		case '\r': out += "\\r"; break;
		case '\t': out += "\\t"; break;
		default: out += c;
		}
	}
	return out + "\"";
}

// Composes the schema-2 file: switches sorted by id, values sorted by package id, each value text
// re-indented (continuation lines prefixed) but otherwise byte-identical.
inline std::string compose_state_file_v2(
	std::vector<std::pair<std::string, bool>> switches,
	std::vector<std::pair<std::string, std::string>> values)
{
	std::sort(switches.begin(), switches.end());
	std::sort(values.begin(), values.end(),
		[](const auto& lhs, const auto& rhs) { return lhs.first < rhs.first; });
	std::string out = "{\r\n  \"schema\": 2,\r\n  \"scripts\": {";
	for (std::size_t n = 0; n < switches.size(); ++n)
		out += std::string(n ? ",\r\n    " : "\r\n    ") + json_quote(switches[n].first) + ": "
			+ (switches[n].second ? "true" : "false");
	out += switches.empty() ? "},\r\n" : "\r\n  },\r\n";
	out += "  \"values\": {";
	for (std::size_t n = 0; n < values.size(); ++n)
	{
		std::string body = values[n].second;
		while (!body.empty() && (body.back() == '\n' || body.back() == '\r' || body.back() == ' ')) body.pop_back();
		// Canonical indentation (idempotent): split into lines (JSON strings never contain raw line
		// breaks), remove the continuation lines' common leading spaces, indent them by four, CRLF ends.
		std::vector<std::string> lines(1);
		for (const char c : body)
		{
			if (c == '\r') continue;
			if (c == '\n') lines.emplace_back();
			else lines.back() += c;
		}
		std::size_t common = std::string::npos;
		for (std::size_t k = 1; k < lines.size(); ++k)
		{
			const auto first = lines[k].find_first_not_of(' ');
			if (first != std::string::npos) common = std::min(common, first);
		}
		if (common == std::string::npos) common = 0;
		std::string indented = lines[0];
		for (std::size_t k = 1; k < lines.size(); ++k)
			indented += "\r\n    " + (lines[k].size() >= common ? lines[k].substr(common) : std::string{});
		out += std::string(n ? ",\r\n    " : "\r\n    ") + json_quote(values[n].first) + ": " + indented;
	}
	out += values.empty() ? "}\r\n}\r\n" : "\r\n  }\r\n}\r\n";
	return out;
}
}
