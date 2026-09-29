#pragma once

// Optional folder script packages (2026-09-29).
//
// A package is one folder `CustomScripts\Packages\<Name>\` that bundles
// several ordinary members (exact root replacements, single-key and
// multi-target addons) into ONE Scripts row and ONE enable/disable policy.
// Packages are opt-in: loose files in `CustomScripts\` and `CustomScripts\Inject\`
// are discovered, keyed and executed exactly as before, and the loose scanners
// never descend into subfolders, so a package member is never seen twice.
//
// Everything in this header is pure and deterministic so the offline gates can
// exercise the exact rules the DLL uses: folder names, member classification,
// the strict bounded `package.json` parser, manifest/disk reconciliation and
// conflict resolution between sources.

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <map>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "injection_core.hpp"
#include "replacements_core.hpp"
#include "script_control_core.hpp"
#include "settings_core.hpp"

namespace renovice::packages
{
inline constexpr std::string_view directory_name = "Packages";
inline constexpr std::string_view manifest_filename = "package.json";
inline constexpr std::size_t maximum_packages = 256;
inline constexpr std::size_t maximum_members = 256;
// 512 KiB (2026-09-30, CONTRACT_PHASE1 item 12): a package that declares all
// 289 addon-lane mission values is about 127 KiB (129,775 bytes measured); the
// full 594-row registry would be about 260 KiB. 512 KiB keeps a 2x margin over
// that while staying a hard, bounded read (JSON depth 32, 4,096 values).
inline constexpr std::size_t maximum_manifest_bytes = 512u * 1024u;
inline constexpr std::size_t maximum_folder_name_length = 64;
inline constexpr std::size_t maximum_display_name_length = 64;
inline constexpr std::size_t maximum_description_length = 1024;
inline constexpr std::size_t maximum_label_length = 128;
inline constexpr std::size_t maximum_json_depth = 32;
inline constexpr std::size_t maximum_summary_length = 480;
inline constexpr std::size_t maximum_tooltip_description_length = 240;
// Replacement members use the replacement lane's own size bound.
inline constexpr std::uintmax_t maximum_replacement_bytes = 1ull << 28;

enum class MemberKind
{
	Replacement,
	TargetAddon,
	MultiTargetAddon,
};

inline const char* member_kind_label(MemberKind kind) noexcept
{
	switch (kind)
	{
	case MemberKind::Replacement: return "replacement";
	case MemberKind::TargetAddon: return "target-addon";
	case MemberKind::MultiTargetAddon: return "multi-target-addon";
	}
	return "unknown";
}

inline std::string state_id(std::string_view folder)
{
	return script_control::stable_id(script_control::Kind::Package, folder);
}

inline std::string chunk_name(std::string_view folder, std::string_view filename)
{
	// Unique across the generation: loose Inject names never contain '/'.
	std::string name;
	name.reserve(directory_name.size() + folder.size() + filename.size() + 2);
	name.append(directory_name);
	name.push_back('/');
	name.append(folder);
	name.push_back('/');
	name.append(filename);
	return name;
}

// Deterministic source order: loose files are the baseline and sort before
// every package; packages sort by lowercase folder name (ordinal tie-break).
inline bool package_order_less(std::string_view lhs, std::string_view rhs)
{
	const auto lower_lhs = script_control::ascii_lower(lhs);
	const auto lower_rhs = script_control::ascii_lower(rhs);
	if (lower_lhs != lower_rhs) return lower_lhs < lower_rhs;
	return lhs < rhs;
}

inline bool ascii_iequal(std::string_view lhs, std::string_view rhs) noexcept
{
	if (lhs.size() != rhs.size()) return false;
	for (std::size_t i = 0; i != lhs.size(); ++i)
	{
		const auto a = static_cast<unsigned char>(lhs[i]);
		const auto b = static_cast<unsigned char>(rhs[i]);
		const auto la = (a >= 'A' && a <= 'Z') ? a + 32u : static_cast<unsigned>(a);
		const auto lb = (b >= 'A' && b <= 'Z') ? b + 32u : static_cast<unsigned>(b);
		if (la != lb) return false;
	}
	return true;
}

// Folder names become the policy ID and part of every log line, so keep them
// to a small printable ASCII alphabet.
inline const char* folder_name_error(std::string_view name) noexcept
{
	if (name.empty()) return "package-folder-name-empty";
	if (name.size() > maximum_folder_name_length) return "package-folder-name-too-long";
	if (name.front() == '.' || name.front() == ' ' || name.back() == ' ' || name.back() == '.')
		return "package-folder-name-invalid-edge";
	for (const char c : name)
	{
		const bool ok = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
			|| (c >= '0' && c <= '9') || c == ' ' || c == '_' || c == '-'
			|| c == '.' || c == '(' || c == ')';
		if (!ok) return "package-folder-name-invalid-character";
	}
	return nullptr;
}

inline bool has_lua_bytecode_extension(std::string_view filename) noexcept
{
	return filename.size() > 6
		&& injection::is_lua_bytecode_extension(filename.substr(filename.size() - 6));
}

// Classifies one `.lua_B` file inside a package folder. Returns nullptr and
// fills kind/key for an admissible member; otherwise an exact, stable reason.
// Only lanes whose failure stays local to the package are admissible:
// - an ordinary one-shot Inject chunk has side effects that cannot be undone;
// - an untargeted managed addon (`*.addon.lua_B`) is staged and activated in the
//   one generation-wide managed transaction (apply_generation ->
//   commit_addon_generation), where any member failure rolls back every loose
//   managed addon too. It is rejected until a package-scoped managed
//   transaction exists. Target addons bind per exact key and are admissible.
inline const char* classify_member(
	std::string_view filename,
	MemberKind& kind,
	std::uint64_t& key
) noexcept
{
	key = 0;
	kind = MemberKind::Replacement;
	if (!has_lua_bytecode_extension(filename)) return "member-not-lua_B";
	if (injection::is_internal_infrastructure(filename)
		|| script_control::is_internal_hook_shim(filename))
	{
		return "member-is-bootstrapper-infrastructure";
	}
	switch (injection::classify_script(filename))
	{
	case injection::ScriptKind::ExperimentalSpawn:
	case injection::ScriptKind::ExperimentalPersistent:
		return "member-spawn-or-persist-name-rejected";
	case injection::ScriptKind::TargetManagedAddon:
		if (injection::is_multi_target_addon(filename))
		{
			if (const char* error = injection::multi_target_filename_error(filename))
				return error;
			kind = MemberKind::MultiTargetAddon;
			return nullptr;
		}
		if (!injection::target_addon_key(filename, key))
			return "target-addon-requires-nonzero-16-hex-key-prefix";
		kind = MemberKind::TargetAddon;
		return nullptr;
	case injection::ScriptKind::ManagedAddon:
		return "managed-addon-member-unsupported-generation-wide-transaction";
	case injection::ScriptKind::Ordinary:
		if (!replacements::parse_filename_key(filename, key))
			return "one-shot-inject-not-allowed-in-package";
		kind = MemberKind::Replacement;
		return nullptr;
	}
	return "member-unclassified";
}

// ---------------------------------------------------------------------------
// Strict, bounded JSON reader for package.json. It accepts RFC 8259 JSON with an
// optional UTF-8 BOM, rejects duplicate keys and trailing data, and only
// materializes the fields the runtime reads. `settings` (top level and per
// member) is syntax-checked here and captured verbatim; its declaration schema
// (ADDON_SETTINGS_V1, settings_core.hpp) is validated separately so that a bad
// declaration rejects only the settings capability, never the package bytes.
// ---------------------------------------------------------------------------
namespace json_detail
{
struct Cursor
{
	std::string_view text;
	std::size_t pos = 0;
	std::size_t depth = 0;
};

inline void skip_ws(Cursor& c) noexcept
{
	while (c.pos < c.text.size())
	{
		const char ch = c.text[c.pos];
		if (ch != ' ' && ch != '\t' && ch != '\n' && ch != '\r') break;
		++c.pos;
	}
}

inline bool peek(Cursor& c, char expected) noexcept
{
	skip_ws(c);
	return c.pos < c.text.size() && c.text[c.pos] == expected;
}

inline bool consume(Cursor& c, char expected) noexcept
{
	if (!peek(c, expected)) return false;
	++c.pos;
	return true;
}

inline int hex_value(char ch) noexcept
{
	if (ch >= '0' && ch <= '9') return ch - '0';
	if (ch >= 'a' && ch <= 'f') return ch - 'a' + 10;
	if (ch >= 'A' && ch <= 'F') return ch - 'A' + 10;
	return -1;
}

inline bool read_hex4(Cursor& c, std::uint32_t& value) noexcept
{
	if (c.text.size() - c.pos < 4) return false;
	value = 0;
	for (int i = 0; i != 4; ++i)
	{
		const int digit = hex_value(c.text[c.pos++]);
		if (digit < 0) return false;
		value = (value << 4) | static_cast<std::uint32_t>(digit);
	}
	return true;
}

inline void append_utf8(std::string& out, std::uint32_t cp)
{
	if (cp < 0x80u) out.push_back(static_cast<char>(cp));
	else if (cp < 0x800u)
	{
		out.push_back(static_cast<char>(0xC0u | (cp >> 6)));
		out.push_back(static_cast<char>(0x80u | (cp & 0x3Fu)));
	}
	else if (cp < 0x10000u)
	{
		out.push_back(static_cast<char>(0xE0u | (cp >> 12)));
		out.push_back(static_cast<char>(0x80u | ((cp >> 6) & 0x3Fu)));
		out.push_back(static_cast<char>(0x80u | (cp & 0x3Fu)));
	}
	else
	{
		out.push_back(static_cast<char>(0xF0u | (cp >> 18)));
		out.push_back(static_cast<char>(0x80u | ((cp >> 12) & 0x3Fu)));
		out.push_back(static_cast<char>(0x80u | ((cp >> 6) & 0x3Fu)));
		out.push_back(static_cast<char>(0x80u | (cp & 0x3Fu)));
	}
}

inline bool parse_string(Cursor& c, std::string& out)
{
	out.clear();
	if (!consume(c, '"')) return false;
	while (c.pos < c.text.size())
	{
		const auto ch = static_cast<unsigned char>(c.text[c.pos++]);
		if (ch == '"') return true;
		if (ch < 0x20u) return false;
		if (ch != '\\')
		{
			out.push_back(static_cast<char>(ch));
			continue;
		}
		if (c.pos >= c.text.size()) return false;
		const char escape = c.text[c.pos++];
		switch (escape)
		{
		case '"': out.push_back('"'); break;
		case '\\': out.push_back('\\'); break;
		case '/': out.push_back('/'); break;
		case 'b': out.push_back('\b'); break;
		case 'f': out.push_back('\f'); break;
		case 'n': out.push_back('\n'); break;
		case 'r': out.push_back('\r'); break;
		case 't': out.push_back('\t'); break;
		case 'u':
		{
			std::uint32_t cp = 0;
			if (!read_hex4(c, cp)) return false;
			if (cp >= 0xD800u && cp <= 0xDBFFu)
			{
				std::uint32_t low = 0;
				if (c.text.size() - c.pos < 2 || c.text[c.pos] != '\\' || c.text[c.pos + 1] != 'u')
					return false;
				c.pos += 2;
				if (!read_hex4(c, low) || low < 0xDC00u || low > 0xDFFFu) return false;
				cp = 0x10000u + ((cp - 0xD800u) << 10) + (low - 0xDC00u);
			}
			else if (cp >= 0xDC00u && cp <= 0xDFFFu) return false;
			append_utf8(out, cp);
			break;
		}
		default: return false;
		}
	}
	return false;
}

inline bool parse_number(Cursor& c, std::string_view& literal) noexcept
{
	skip_ws(c);
	const std::size_t start = c.pos;
	const auto digit = [&](std::size_t at) noexcept
	{
		return at < c.text.size() && c.text[at] >= '0' && c.text[at] <= '9';
	};
	if (c.pos < c.text.size() && c.text[c.pos] == '-') ++c.pos;
	if (!digit(c.pos)) return false;
	if (c.text[c.pos] == '0') ++c.pos;
	else while (digit(c.pos)) ++c.pos;
	if (c.pos < c.text.size() && c.text[c.pos] == '.')
	{
		++c.pos;
		if (!digit(c.pos)) return false;
		while (digit(c.pos)) ++c.pos;
	}
	if (c.pos < c.text.size() && (c.text[c.pos] == 'e' || c.text[c.pos] == 'E'))
	{
		++c.pos;
		if (c.pos < c.text.size() && (c.text[c.pos] == '+' || c.text[c.pos] == '-')) ++c.pos;
		if (!digit(c.pos)) return false;
		while (digit(c.pos)) ++c.pos;
	}
	literal = c.text.substr(start, c.pos - start);
	return true;
}

inline bool parse_literal(Cursor& c, std::string_view word) noexcept
{
	skip_ws(c);
	if (c.text.substr(c.pos, word.size()) != word) return false;
	c.pos += word.size();
	return true;
}

// Validates and skips any JSON value (used for the reserved `settings`).
inline bool skip_value(Cursor& c)
{
	skip_ws(c);
	if (c.pos >= c.text.size()) return false;
	const char ch = c.text[c.pos];
	if (ch == '"')
	{
		std::string ignored;
		return parse_string(c, ignored);
	}
	if (ch == '{' || ch == '[')
	{
		if (++c.depth > maximum_json_depth) return false;
		const char close = ch == '{' ? '}' : ']';
		++c.pos;
		if (consume(c, close))
		{
			--c.depth;
			return true;
		}
		std::vector<std::string> keys;
		for (;;)
		{
			if (ch == '{')
			{
				std::string key;
				if (!parse_string(c, key) || !consume(c, ':')) return false;
				if (std::find(keys.begin(), keys.end(), key) != keys.end()) return false;
				keys.push_back(std::move(key));
			}
			if (!skip_value(c)) return false;
			if (consume(c, ',')) continue;
			if (!consume(c, close)) return false;
			--c.depth;
			return true;
		}
	}
	if (ch == 't') return parse_literal(c, "true");
	if (ch == 'f') return parse_literal(c, "false");
	if (ch == 'n') return parse_literal(c, "null");
	std::string_view literal;
	return parse_number(c, literal);
}
}

struct ManifestMember
{
	std::string filename;
	std::string label;
	// Raw JSON text of `members[f].settings`; empty when absent.
	std::string settings_json;
};

struct Manifest
{
	bool present = false;
	std::string name;
	std::string description;
	bool members_declared = false;
	std::vector<ManifestMember> members;
	bool settings_present = false;
	// Raw JSON text of the top-level `settings`; empty when absent.
	std::string settings_json;
};

inline bool printable_text(std::string_view text) noexcept
{
	for (const char ch : text)
	{
		const auto c = static_cast<unsigned char>(ch);
		if (c < 0x20u || c == 0x7Fu) return false;
	}
	return true;
}

inline bool valid_text_field(std::string_view text, std::size_t maximum, bool allow_empty) noexcept
{
	if (!allow_empty && text.empty()) return false;
	return text.size() <= maximum && printable_text(text);
}

// Descriptions may span lines; the tooltip renders line breaks as spaces.
inline bool valid_description(std::string_view text) noexcept
{
	if (text.size() > maximum_description_length) return false;
	for (const char ch : text)
	{
		const auto c = static_cast<unsigned char>(ch);
		if ((c < 0x20u && c != 0x0Au && c != 0x0Du && c != 0x09u) || c == 0x7Fu) return false;
	}
	return true;
}

// Parses package.json. Returns an empty string on success, otherwise an exact
// reason. Schema (all fields optional):
//   { "schema": 1, "name": "...", "description": "...",
//     "members": { "<member filename>": { "label": "...", "settings": <any> } },
//     "settings": <any> }
// `settings` (top level and per member) is reserved for the in-game editor.
// A per-member `enabled` field is reserved for future per-member toggles and is
// rejected today so a manifest never claims a capability the runtime lacks.
inline std::string parse_manifest(std::string_view text, Manifest& manifest)
{
	manifest = Manifest{};
	manifest.present = true;
	if (text.size() > maximum_manifest_bytes) return "manifest-too-large";
	if (text.size() >= 3 && static_cast<unsigned char>(text[0]) == 0xEFu
		&& static_cast<unsigned char>(text[1]) == 0xBBu
		&& static_cast<unsigned char>(text[2]) == 0xBFu)
	{
		text.remove_prefix(3);
	}
	json_detail::Cursor c{text};
	if (!json_detail::consume(c, '{')) return "manifest-not-a-json-object";
	std::vector<std::string> seen;
	if (!json_detail::consume(c, '}'))
	{
		for (;;)
		{
			std::string field;
			if (!json_detail::parse_string(c, field) || !json_detail::consume(c, ':'))
				return "manifest-invalid-json";
			if (std::find(seen.begin(), seen.end(), field) != seen.end())
				return "manifest-duplicate-field=" + field;
			seen.push_back(field);
			if (field == "schema")
			{
				std::string_view literal;
				if (!json_detail::parse_number(c, literal)) return "manifest-schema-not-number";
				if (literal != "1") return "manifest-schema-unsupported";
			}
			else if (field == "name")
			{
				if (!json_detail::parse_string(c, manifest.name)
					|| !valid_text_field(manifest.name, maximum_display_name_length, false))
				{
					return "manifest-name-invalid";
				}
			}
			else if (field == "description")
			{
				if (!json_detail::parse_string(c, manifest.description)
					|| !valid_description(manifest.description))
				{
					return "manifest-description-invalid";
				}
			}
			else if (field == "settings")
			{
				json_detail::skip_ws(c);
				const std::size_t settings_start = c.pos;
				if (!json_detail::skip_value(c)) return "manifest-settings-invalid-json";
				manifest.settings_present = true;
				manifest.settings_json = std::string(
					c.text.substr(settings_start, c.pos - settings_start));
			}
			else if (field == "members")
			{
				manifest.members_declared = true;
				if (!json_detail::consume(c, '{')) return "manifest-members-not-object";
				if (!json_detail::consume(c, '}'))
				{
					for (;;)
					{
						ManifestMember member;
						if (!json_detail::parse_string(c, member.filename)
							|| !json_detail::consume(c, ':'))
						{
							return "manifest-invalid-json";
						}
						if (!has_lua_bytecode_extension(member.filename)
							|| !printable_text(member.filename))
						{
							return "manifest-member-name-not-lua_B=" + member.filename;
						}
						for (const auto& existing : manifest.members)
						{
							if (ascii_iequal(existing.filename, member.filename))
								return "manifest-member-duplicate=" + member.filename;
						}
						if (manifest.members.size() >= maximum_members)
							return "manifest-too-many-members";
						if (!json_detail::consume(c, '{'))
							return "manifest-member-entry-not-object=" + member.filename;
						std::vector<std::string> member_fields;
						if (!json_detail::consume(c, '}'))
						{
							for (;;)
							{
								std::string member_field;
								if (!json_detail::parse_string(c, member_field)
									|| !json_detail::consume(c, ':'))
								{
									return "manifest-invalid-json";
								}
								if (std::find(member_fields.begin(), member_fields.end(), member_field)
									!= member_fields.end())
								{
									return "manifest-member-duplicate-field=" + member_field;
								}
								member_fields.push_back(member_field);
								if (member_field == "label")
								{
									if (!json_detail::parse_string(c, member.label)
										|| !valid_text_field(member.label, maximum_label_length, true))
									{
										return "manifest-member-label-invalid=" + member.filename;
									}
								}
								else if (member_field == "settings")
								{
									json_detail::skip_ws(c);
									const std::size_t settings_start = c.pos;
									if (!json_detail::skip_value(c))
										return "manifest-member-settings-invalid-json=" + member.filename;
									member.settings_json = std::string(
										c.text.substr(settings_start, c.pos - settings_start));
								}
								else
								{
									return "manifest-member-unknown-field=" + member_field;
								}
								if (json_detail::consume(c, ',')) continue;
								if (!json_detail::consume(c, '}')) return "manifest-invalid-json";
								break;
							}
						}
						manifest.members.push_back(std::move(member));
						if (json_detail::consume(c, ',')) continue;
						if (!json_detail::consume(c, '}')) return "manifest-invalid-json";
						break;
					}
				}
			}
			else
			{
				return "manifest-unknown-field=" + field;
			}
			if (json_detail::consume(c, ',')) continue;
			if (!json_detail::consume(c, '}')) return "manifest-invalid-json";
			break;
		}
	}
	json_detail::skip_ws(c);
	if (c.pos != c.text.size()) return "manifest-trailing-data";
	return {};
}

// When the manifest declares `members`, the on-disk member set must match it
// exactly (case-insensitive, like the Windows filesystem). A partially copied
// package therefore fails as a whole instead of loading half of its members.
inline std::string reconcile_manifest_members(
	const Manifest& manifest,
	const std::vector<std::string>& disk_members
)
{
	if (!manifest.members_declared) return {};
	for (const auto& declared : manifest.members)
	{
		const bool found = std::any_of(disk_members.begin(), disk_members.end(),
			[&](const std::string& disk) { return ascii_iequal(disk, declared.filename); });
		if (!found) return "manifest-member-missing-on-disk=" + declared.filename;
	}
	for (const auto& disk : disk_members)
	{
		const bool found = std::any_of(manifest.members.begin(), manifest.members.end(),
			[&](const ManifestMember& declared) { return ascii_iequal(disk, declared.filename); });
		if (!found) return "member-not-declared-in-manifest=" + disk;
	}
	return {};
}

inline std::string manifest_label(const Manifest& manifest, std::string_view filename)
{
	for (const auto& member : manifest.members)
	{
		if (ascii_iequal(member.filename, filename)) return member.label;
	}
	return {};
}

// ---------------------------------------------------------------------------
// Conflicts. Two sources that would both apply the same exact replacement key,
// or both bind addons to the same exact target key, conflict when at least one
// of them is a package. Loose-vs-loose behavior is left exactly as it was. The
// later-sorted source (always the package; for two packages the later folder)
// fails closed as a whole; the earlier source keeps working. A rejected
// package's claims are not recorded, so it never blocks a third source.
// Only enabled, structurally valid sources claim keys.
// ---------------------------------------------------------------------------
struct SourceClaims
{
	std::string source; // "loose:<filename>" or "package:<folder>"
	std::vector<std::uint64_t> replacement_keys;
	std::vector<std::uint64_t> target_keys;
};

struct ConflictDecision
{
	bool accepted = true;
	bool replacement = false;
	std::uint64_t key = 0;
	std::string holder;
	std::string reason;
};

inline std::string key_text(std::uint64_t key)
{
	char text[17]{};
	injection::format_target_key_text(key, text);
	return std::string(text);
}

inline std::vector<ConflictDecision> resolve_conflicts(
	std::vector<SourceClaims> loose,
	const std::vector<SourceClaims>& packages
)
{
	std::sort(loose.begin(), loose.end(), [](const SourceClaims& lhs, const SourceClaims& rhs)
	{
		return lhs.source < rhs.source;
	});
	std::map<std::uint64_t, std::string> replacement_holders;
	std::map<std::uint64_t, std::string> target_holders;
	for (const auto& source : loose)
	{
		for (const auto key : source.replacement_keys) replacement_holders.emplace(key, source.source);
		for (const auto key : source.target_keys) target_holders.emplace(key, source.source);
	}
	std::vector<ConflictDecision> decisions(packages.size());
	for (std::size_t i = 0; i != packages.size(); ++i)
	{
		auto replacement_keys = packages[i].replacement_keys;
		auto target_keys = packages[i].target_keys;
		std::sort(replacement_keys.begin(), replacement_keys.end());
		replacement_keys.erase(std::unique(replacement_keys.begin(), replacement_keys.end()),
			replacement_keys.end());
		std::sort(target_keys.begin(), target_keys.end());
		target_keys.erase(std::unique(target_keys.begin(), target_keys.end()), target_keys.end());
		auto& decision = decisions[i];
		for (const auto key : replacement_keys)
		{
			if (const auto holder = replacement_holders.find(key); holder != replacement_holders.end())
			{
				decision.accepted = false;
				decision.replacement = true;
				decision.key = key;
				decision.holder = holder->second;
				break;
			}
		}
		if (decision.accepted)
		{
			for (const auto key : target_keys)
			{
				if (const auto holder = target_holders.find(key); holder != target_holders.end())
				{
					decision.accepted = false;
					decision.replacement = false;
					decision.key = key;
					decision.holder = holder->second;
					break;
				}
			}
		}
		if (!decision.accepted)
		{
			decision.reason = std::string("conflict kind=")
				+ (decision.replacement ? "replacement" : "target")
				+ " key=" + key_text(decision.key)
				+ " holder=" + decision.holder
				+ " resolution=later-sorted-source-fails-closed";
			continue;
		}
		for (const auto key : replacement_keys) replacement_holders.emplace(key, packages[i].source);
		for (const auto key : target_keys) target_holders.emplace(key, packages[i].source);
	}
	return decisions;
}

// ---------------------------------------------------------------------------
// Presentation: one row per package, `[PACKAGE] <name>`, with a bounded member
// summary for the tooltip.
// ---------------------------------------------------------------------------
inline std::string sanitize_display(std::string_view text)
{
	std::string output;
	output.reserve(text.size());
	for (const char ch : text)
	{
		const auto c = static_cast<unsigned char>(ch);
		output.push_back(c < 0x20u || c == 0x7Fu ? ' ' : ch);
	}
	return output;
}

// Bounds tooltip text without splitting a UTF-8 sequence.
inline std::string truncate_display(std::string text, std::size_t maximum)
{
	if (maximum < 4 || text.size() <= maximum) return text;
	std::size_t cut = maximum - 3;
	while (cut != 0 && (static_cast<unsigned char>(text[cut]) & 0xC0u) == 0x80u) --cut;
	text.resize(cut);
	text += "...";
	return text;
}

inline std::string menu_label(std::string_view folder, std::string_view manifest_name)
{
	return std::string("[PACKAGE] ")
		+ sanitize_display(manifest_name.empty() ? folder : manifest_name);
}

inline std::string members_summary(
	const std::vector<std::pair<std::string, std::string>>& filename_and_label
)
{
	std::string output = std::to_string(filename_and_label.size())
		+ (filename_and_label.size() == 1 ? " member: " : " members: ");
	std::size_t shown = 0;
	for (const auto& [filename, label] : filename_and_label)
	{
		std::string item = label.empty()
			? sanitize_display(filename)
			: sanitize_display(label) + " (" + sanitize_display(filename) + ")";
		if (shown != 0) item.insert(0, ", ");
		if (output.size() + item.size() > maximum_summary_length)
		{
			output += ", +" + std::to_string(filename_and_label.size() - shown) + " more";
			return output;
		}
		output += item;
		++shown;
	}
	return output;
}
}
