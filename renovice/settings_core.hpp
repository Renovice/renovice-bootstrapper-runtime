#pragma once

// ADDON_SETTINGS_V1: generic, generation-owned script settings (2026-09-30).
//
// Contract: work/research/universal-mission-editor-2026-09-29/INGAME_EDITOR_DESIGN.md
// sections 3.2-3.4 and 5. Three stores, three owners:
//   - declarations: package.json `settings` (top level) and
//     `members["<file>"].settings` (per member). Authored by a generator,
//     read-only at runtime, covered by the package folder;
//   - enable policy: ScriptStates.json (`package:` and the new `member:` ids);
//   - user values: CustomScripts\Settings\<package folder>.json.
//
// Everything in this header is pure and deterministic so the offline gate
// (RENOVICE_TOOLCHAIN/settings/verify_addon_settings.ps1) exercises the exact
// rules the DLL uses. Nothing here names a mission, an ability or a file: the
// primitive is target-agnostic.
//
// Failure boundaries (capability-local):
//   - invalid declarations reject ONLY the settings capability of that
//     package: its members load with their compiled defaults and receive
//     `context.settings = nil` (exactly as today);
//   - a malformed values file reverts ONLY that package to stock: its addon
//     members receive an empty settings table and its literal (replacement)
//     members stay out of the generation;
//   - an invalid value entry reverts ONLY that value to stock.
// Every rejection carries an exact, stable reason.

#include <algorithm>
#include <array>
#include <charconv>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <map>
#include <memory>
#include <optional>
#include <set>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

namespace renovice::settings
{
inline constexpr std::string_view declaration_format = "RENOVICE_SETTINGS_DECL_V1";
inline constexpr std::string_view values_format = "RENOVICE_SCRIPT_SETTINGS_V1";
inline constexpr std::string_view directory_name = "Settings";
inline constexpr std::size_t maximum_values_per_package = 4096;
inline constexpr std::size_t maximum_groups_per_package = 256;
inline constexpr std::size_t maximum_aliases_per_group = 1024;
inline constexpr std::size_t maximum_text_length = 64;
inline constexpr std::size_t maximum_scope_length = 256;
inline constexpr std::size_t maximum_unit_length = 16;
inline constexpr std::size_t maximum_value_id_length = 128;
inline constexpr std::size_t maximum_group_id_length = 64;
inline constexpr std::size_t maximum_enum_options = 64;
inline constexpr std::size_t maximum_values_file_bytes = 1024u * 1024u;
inline constexpr std::size_t maximum_json_depth = 32;
inline constexpr std::size_t maximum_json_nodes = 262144;
// Numbers reach DE Luau as 32-bit floats; integers are exact up to 2^24.
inline constexpr double maximum_exact_integer = 16777216.0;
inline constexpr std::size_t maximum_logged_value_rejections = 16;

// ---------------------------------------------------------------------------
// Minimal strict JSON DOM (RFC 8259, optional UTF-8 BOM, duplicate keys and
// trailing data rejected, bounded depth and node count).
// ---------------------------------------------------------------------------
namespace json
{
struct Value
{
	enum class Kind { Null, Bool, Number, String, Array, Object };
	Kind kind = Kind::Null;
	bool boolean = false;
	double number = 0.0;
	bool integral_literal = false; // no fraction/exponent in the literal
	std::string text;
	std::vector<Value> items;
	std::vector<std::pair<std::string, Value>> members;

	[[nodiscard]] const Value* find(std::string_view key) const noexcept
	{
		for (const auto& [name, value] : members)
			if (name == key) return &value;
		return nullptr;
	}
	[[nodiscard]] bool is_object() const noexcept { return kind == Kind::Object; }
	[[nodiscard]] bool is_array() const noexcept { return kind == Kind::Array; }
	[[nodiscard]] bool is_string() const noexcept { return kind == Kind::String; }
	[[nodiscard]] bool is_number() const noexcept { return kind == Kind::Number; }
	[[nodiscard]] bool is_bool() const noexcept { return kind == Kind::Bool; }
};

namespace detail
{
struct Cursor
{
	std::string_view text;
	std::size_t pos = 0;
	std::size_t depth = 0;
	std::size_t nodes = 0;
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

inline bool consume(Cursor& c, char expected) noexcept
{
	skip_ws(c);
	if (c.pos < c.text.size() && c.text[c.pos] == expected)
	{
		++c.pos;
		return true;
	}
	return false;
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

inline bool parse_number(Cursor& c, double& value, bool& integral) noexcept
{
	skip_ws(c);
	const std::size_t start = c.pos;
	const auto digit = [&](std::size_t at) noexcept
	{
		return at < c.text.size() && c.text[at] >= '0' && c.text[at] <= '9';
	};
	integral = true;
	if (c.pos < c.text.size() && c.text[c.pos] == '-') ++c.pos;
	if (!digit(c.pos)) return false;
	if (c.text[c.pos] == '0') ++c.pos;
	else while (digit(c.pos)) ++c.pos;
	if (c.pos < c.text.size() && c.text[c.pos] == '.')
	{
		integral = false;
		++c.pos;
		if (!digit(c.pos)) return false;
		while (digit(c.pos)) ++c.pos;
	}
	if (c.pos < c.text.size() && (c.text[c.pos] == 'e' || c.text[c.pos] == 'E'))
	{
		integral = false;
		++c.pos;
		if (c.pos < c.text.size() && (c.text[c.pos] == '+' || c.text[c.pos] == '-')) ++c.pos;
		if (!digit(c.pos)) return false;
		while (digit(c.pos)) ++c.pos;
	}
	const char* first = c.text.data() + start;
	const char* last = c.text.data() + c.pos;
	const auto result = std::from_chars(first, last, value);
	return result.ec == std::errc{} && result.ptr == last && std::isfinite(value);
}

inline bool parse_value(Cursor& c, Value& out)
{
	skip_ws(c);
	if (c.pos >= c.text.size() || ++c.nodes > maximum_json_nodes) return false;
	const char ch = c.text[c.pos];
	if (ch == '"')
	{
		out.kind = Value::Kind::String;
		return parse_string(c, out.text);
	}
	if (ch == '{' || ch == '[')
	{
		if (++c.depth > maximum_json_depth) return false;
		++c.pos;
		const bool object = ch == '{';
		out.kind = object ? Value::Kind::Object : Value::Kind::Array;
		const char close = object ? '}' : ']';
		if (consume(c, close))
		{
			--c.depth;
			return true;
		}
		for (;;)
		{
			if (object)
			{
				std::string key;
				if (!parse_string(c, key) || !consume(c, ':')) return false;
				if (out.find(key) != nullptr) return false; // duplicate key
				Value child;
				if (!parse_value(c, child)) return false;
				out.members.emplace_back(std::move(key), std::move(child));
			}
			else
			{
				Value child;
				if (!parse_value(c, child)) return false;
				out.items.push_back(std::move(child));
			}
			if (consume(c, ',')) continue;
			if (!consume(c, close)) return false;
			--c.depth;
			return true;
		}
	}
	if (c.text.substr(c.pos, 4) == "true")
	{
		c.pos += 4;
		out.kind = Value::Kind::Bool;
		out.boolean = true;
		return true;
	}
	if (c.text.substr(c.pos, 5) == "false")
	{
		c.pos += 5;
		out.kind = Value::Kind::Bool;
		out.boolean = false;
		return true;
	}
	if (c.text.substr(c.pos, 4) == "null")
	{
		c.pos += 4;
		out.kind = Value::Kind::Null;
		return true;
	}
	out.kind = Value::Kind::Number;
	return parse_number(c, out.number, out.integral_literal);
}
}

// Returns an empty string on success, otherwise an exact reason.
inline std::string parse(std::string_view text, Value& out)
{
	out = Value{};
	if (text.size() >= 3 && static_cast<unsigned char>(text[0]) == 0xEFu
		&& static_cast<unsigned char>(text[1]) == 0xBBu
		&& static_cast<unsigned char>(text[2]) == 0xBFu)
	{
		text.remove_prefix(3);
	}
	detail::Cursor cursor{text};
	try
	{
		if (!detail::parse_value(cursor, out)) return "invalid-json";
	}
	catch (...)
	{
		return "invalid-json";
	}
	detail::skip_ws(cursor);
	if (cursor.pos != cursor.text.size()) return "trailing-data";
	return {};
}

inline std::string quote(std::string_view text)
{
	std::string out;
	out.reserve(text.size() + 2);
	out.push_back('"');
	for (const char raw : text)
	{
		const auto ch = static_cast<unsigned char>(raw);
		switch (ch)
		{
		case '"': out += "\\\""; break;
		case '\\': out += "\\\\"; break;
		case '\n': out += "\\n"; break;
		case '\r': out += "\\r"; break;
		case '\t': out += "\\t"; break;
		default:
			if (ch < 0x20u)
			{
				static constexpr char digits[] = "0123456789abcdef";
				out += "\\u00";
				out.push_back(digits[ch >> 4]);
				out.push_back(digits[ch & 0xFu]);
			}
			else out.push_back(raw);
		}
	}
	out.push_back('"');
	return out;
}

// Shortest round-trip text; whole numbers are written without a fraction.
inline std::string number_text(double value)
{
	if (std::floor(value) == value && std::fabs(value) < 9.0e15)
		return std::to_string(static_cast<long long>(value));
	char buffer[64]{};
	const auto result = std::to_chars(buffer, buffer + sizeof(buffer), value);
	return result.ec == std::errc{} ? std::string(buffer, result.ptr) : std::string("0");
}
}

// ---------------------------------------------------------------------------
// Declarations (design section 3.2).
// ---------------------------------------------------------------------------
enum class ValueType { Int, Float, Enum };
enum class Lane { Addon, Literal, Metadata };
enum class Applies { LiveNextRead, NextInstance, NextMission, Restart };

inline const char* value_type_label(ValueType type) noexcept
{
	switch (type)
	{
	case ValueType::Int: return "int";
	case ValueType::Float: return "float";
	case ValueType::Enum: return "enum";
	}
	return "unknown";
}

inline const char* lane_label(Lane lane) noexcept
{
	switch (lane)
	{
	case Lane::Addon: return "addon";
	case Lane::Literal: return "literal";
	case Lane::Metadata: return "metadata";
	}
	return "unknown";
}

inline const char* applies_label(Applies applies) noexcept
{
	switch (applies)
	{
	case Applies::LiveNextRead: return "live_next_read";
	case Applies::NextInstance: return "next_instance";
	case Applies::NextMission: return "next_mission";
	case Applies::Restart: return "restart";
	}
	return "unknown";
}

struct EnumOption
{
	std::string label;
	double value = 0.0;
};

struct GroupDecl
{
	std::string id;
	std::string label;
	long long order = 0;
	std::vector<std::string> aliases;
};

struct ValueDecl
{
	std::string id;
	std::string member; // declaring member filename (exact manifest spelling)
	std::string group;
	std::string label;
	std::string unit;
	std::string scope;
	ValueType type = ValueType::Int;
	double stock = 0.0;
	double minimum = 0.0;
	double maximum = 0.0;
	Lane lane = Lane::Addon;
	Applies applies = Applies::LiveNextRead;
	std::vector<EnumOption> options;
};

struct Declarations
{
	std::string build;
	std::vector<GroupDecl> groups;  // declaration order
	std::vector<ValueDecl> values;  // sorted by member, then declaration order

	[[nodiscard]] const GroupDecl* group(std::string_view id) const noexcept
	{
		for (const auto& group : groups)
			if (group.id == id) return &group;
		return nullptr;
	}
	[[nodiscard]] const ValueDecl* value(std::string_view id) const noexcept
	{
		for (const auto& value : values)
			if (value.id == id) return &value;
		return nullptr;
	}
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

inline bool valid_text(std::string_view text, std::size_t maximum, bool allow_empty) noexcept
{
	return (allow_empty || !text.empty()) && text.size() <= maximum && printable_text(text);
}

inline bool valid_group_id(std::string_view id) noexcept
{
	if (id.empty() || id.size() > maximum_group_id_length) return false;
	for (const char c : id)
	{
		if (!((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_')) return false;
	}
	return true;
}

inline bool valid_value_id(std::string_view id) noexcept
{
	if (id.empty() || id.size() > maximum_value_id_length) return false;
	for (const char c : id)
	{
		if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')
			|| c == '_' || c == '.'))
		{
			return false;
		}
	}
	return true;
}

inline bool whole(double value) noexcept
{
	return std::isfinite(value) && std::floor(value) == value;
}

inline bool empty_object_text(std::string_view text)
{
	json::Value value;
	return json::parse(text, value).empty() && value.is_object() && value.members.empty();
}

// A package has declarations when its top-level `settings` or any member
// `settings` is a non-empty object. `"settings": {}` (today's generator
// output) means "no declarations": the package behaves exactly as before.
inline bool declarations_present(
	std::string_view top_level_json,
	const std::vector<std::pair<std::string, std::string>>& member_jsons)
{
	if (!top_level_json.empty() && !empty_object_text(top_level_json)) return true;
	for (const auto& [member, text] : member_jsons)
	{
		(void)member;
		if (!text.empty() && !empty_object_text(text)) return true;
	}
	return false;
}

namespace detail
{
inline std::string parse_group(const json::Value& value, GroupDecl& group)
{
	if (!value.is_object()) return "group-not-object";
	for (const auto& [key, field] : value.members)
	{
		(void)field;
		if (key != "id" && key != "label" && key != "order" && key != "aliases")
			return "group-unknown-field=" + key;
	}
	const auto* id = value.find("id");
	if (id == nullptr || !id->is_string() || !valid_group_id(id->text)) return "group-id-invalid";
	group.id = id->text;
	const auto* label = value.find("label");
	if (label == nullptr || !label->is_string() || !valid_text(label->text, maximum_text_length, false))
		return "group-label-invalid=" + group.id;
	group.label = label->text;
	const auto* order = value.find("order");
	if (order == nullptr || !order->is_number() || !whole(order->number)
		|| std::fabs(order->number) > 1.0e9)
	{
		return "group-order-invalid=" + group.id;
	}
	group.order = static_cast<long long>(order->number);
	if (const auto* aliases = value.find("aliases"))
	{
		if (!aliases->is_array() || aliases->items.size() > maximum_aliases_per_group)
			return "group-aliases-invalid=" + group.id;
		for (const auto& alias : aliases->items)
		{
			if (!alias.is_string() || !valid_text(alias.text, maximum_text_length, false))
				return "group-alias-invalid=" + group.id;
			group.aliases.push_back(alias.text);
		}
	}
	return {};
}

inline std::string parse_value_decl(
	const std::string& id, const json::Value& value, const std::string& member,
	const std::vector<GroupDecl>& groups, ValueDecl& out)
{
	const std::string where = "value=" + id;
	if (!valid_value_id(id)) return "value-id-invalid=" + id;
	if (!value.is_object()) return where + " declaration-not-object";
	static constexpr std::array<std::string_view, 11> fields{
		"group", "label", "unit", "type", "stock", "min", "max", "scope", "lane", "applies", "options"};
	for (const auto& [key, field] : value.members)
	{
		(void)field;
		if (std::find(fields.begin(), fields.end(), key) == fields.end())
			return where + " unknown-field=" + key;
	}
	out.id = id;
	out.member = member;
	const auto* group = value.find("group");
	if (group == nullptr || !group->is_string()) return where + " group-missing";
	if (std::none_of(groups.begin(), groups.end(),
		[&](const GroupDecl& declared) { return declared.id == group->text; }))
	{
		return where + " group-not-declared=" + group->text;
	}
	out.group = group->text;
	const auto* label = value.find("label");
	if (label == nullptr || !label->is_string() || !valid_text(label->text, maximum_text_length, false))
		return where + " label-invalid";
	out.label = label->text;
	if (const auto* unit = value.find("unit"))
	{
		if (!unit->is_string() || !valid_text(unit->text, maximum_unit_length, true))
			return where + " unit-invalid";
		out.unit = unit->text;
	}
	if (const auto* scope = value.find("scope"))
	{
		if (!scope->is_string() || !valid_text(scope->text, maximum_scope_length, true))
			return where + " scope-invalid";
		out.scope = scope->text;
	}
	const auto* type = value.find("type");
	if (type == nullptr || !type->is_string()) return where + " type-missing";
	if (type->text == "int") out.type = ValueType::Int;
	else if (type->text == "float") out.type = ValueType::Float;
	else if (type->text == "enum") out.type = ValueType::Enum;
	else return where + " type-invalid=" + type->text;
	const auto* stock = value.find("stock");
	const auto* minimum = value.find("min");
	const auto* maximum = value.find("max");
	if (stock == nullptr || !stock->is_number()) return where + " stock-not-number";
	if (minimum == nullptr || !minimum->is_number()) return where + " min-not-number";
	if (maximum == nullptr || !maximum->is_number()) return where + " max-not-number";
	out.stock = stock->number;
	out.minimum = minimum->number;
	out.maximum = maximum->number;
	if (out.minimum > out.maximum) return where + " min-greater-than-max";
	if (out.stock < out.minimum || out.stock > out.maximum) return where + " stock-outside-min-max";
	if (out.type == ValueType::Int)
	{
		if (!whole(out.stock) || !whole(out.minimum) || !whole(out.maximum))
			return where + " int-has-fraction";
		if (std::fabs(out.minimum) > maximum_exact_integer || std::fabs(out.maximum) > maximum_exact_integer)
			return where + " int-bound-not-exact-in-float32";
	}
	if (const auto* lane = value.find("lane"))
	{
		if (!lane->is_string()) return where + " lane-invalid";
		if (lane->text == "addon") out.lane = Lane::Addon;
		else if (lane->text == "literal") out.lane = Lane::Literal;
		else if (lane->text == "metadata") out.lane = Lane::Metadata;
		else return where + " lane-invalid=" + lane->text;
	}
	if (const auto* applies = value.find("applies"))
	{
		if (!applies->is_string()) return where + " applies-invalid";
		if (applies->text == "live_next_read") out.applies = Applies::LiveNextRead;
		else if (applies->text == "next_instance") out.applies = Applies::NextInstance;
		else if (applies->text == "next_mission") out.applies = Applies::NextMission;
		else if (applies->text == "restart") out.applies = Applies::Restart;
		else return where + " applies-invalid=" + applies->text;
	}
	const auto* options = value.find("options");
	if (out.type == ValueType::Enum)
	{
		if (options == nullptr || !options->is_array() || options->items.empty()
			|| options->items.size() > maximum_enum_options)
		{
			return where + " enum-options-invalid";
		}
		bool stock_listed = false;
		for (const auto& option : options->items)
		{
			if (!option.is_object() || option.members.size() != 2) return where + " enum-option-invalid";
			const auto* option_label = option.find("label");
			const auto* option_value = option.find("value");
			if (option_label == nullptr || !option_label->is_string()
				|| !valid_text(option_label->text, maximum_text_length, false)
				|| option_value == nullptr || !option_value->is_number())
			{
				return where + " enum-option-invalid";
			}
			for (const auto& existing : out.options)
				if (existing.value == option_value->number) return where + " enum-option-duplicate-value";
			out.options.push_back(EnumOption{option_label->text, option_value->number});
			stock_listed |= option_value->number == out.stock;
		}
		if (!stock_listed) return where + " enum-stock-not-an-option";
	}
	else if (options != nullptr)
	{
		return where + " options-only-for-enum";
	}
	return {};
}
}

// Parses the declarations of one package. `top_level_json` is the raw
// top-level `settings` value; `member_jsons` pairs each member filename with its
// raw `settings` value (members without one are omitted). Returns an empty
// string on success, otherwise the exact reason that rejects ONLY the settings
// capability of this package.
inline std::string parse_declarations(
	std::string_view top_level_json,
	const std::vector<std::pair<std::string, std::string>>& member_jsons,
	Declarations& out)
{
	out = Declarations{};
	json::Value top;
	if (const auto error = json::parse(top_level_json, top); !error.empty())
		return "settings-" + error;
	if (!top.is_object()) return "settings-not-object";
	for (const auto& [key, value] : top.members)
	{
		(void)value;
		if (key != "format" && key != "build" && key != "groups") return "settings-unknown-field=" + key;
	}
	const auto* format = top.find("format");
	if (format == nullptr || !format->is_string() || format->text != declaration_format)
		return "settings-format-not-RENOVICE_SETTINGS_DECL_V1";
	const auto* build = top.find("build");
	if (build == nullptr || !build->is_string() || !valid_text(build->text, maximum_text_length, false))
		return "settings-build-invalid";
	out.build = build->text;
	const auto* groups = top.find("groups");
	if (groups == nullptr || !groups->is_array()) return "settings-groups-not-array";
	if (groups->items.size() > maximum_groups_per_package) return "settings-too-many-groups";
	for (const auto& item : groups->items)
	{
		GroupDecl group;
		if (auto error = detail::parse_group(item, group); !error.empty()) return error;
		if (out.group(group.id) != nullptr) return "group-duplicate=" + group.id;
		out.groups.push_back(std::move(group));
	}
	for (const auto& [member, text] : member_jsons)
	{
		json::Value settings;
		if (const auto error = json::parse(text, settings); !error.empty())
			return "member=" + member + " settings-" + error;
		if (!settings.is_object()) return "member=" + member + " settings-not-object";
		if (settings.members.empty()) continue;
		if (settings.members.size() != 1 || settings.members.front().first != "values"
			|| !settings.members.front().second.is_object())
		{
			return "member=" + member + " settings-must-be-exactly-values-object";
		}
		for (const auto& [id, value] : settings.members.front().second.members)
		{
			if (out.value(id) != nullptr) return "value-duplicate-in-package=" + id;
			if (out.values.size() >= maximum_values_per_package) return "settings-too-many-values";
			ValueDecl declaration;
			if (auto error = detail::parse_value_decl(id, value, member, out.groups, declaration);
				!error.empty())
			{
				return "member=" + member + " " + error;
			}
			out.values.push_back(std::move(declaration));
		}
	}
	return {};
}

// ---------------------------------------------------------------------------
// User values file (design section 3.3).
// ---------------------------------------------------------------------------
struct UserValue
{
	bool shape_valid = true;
	std::string shape_reason;
	bool enabled = false;
	bool has_value = false;
	double value = 0.0;
	bool has_stock = false;
	double stock = 0.0;
};

struct UserState
{
	std::string package;
	std::string build;
	bool use_stock = false;
	std::map<std::string, bool> groups;
	std::map<std::string, UserValue> values;
};

inline std::string values_file_name(std::string_view folder)
{
	return std::string(folder) + ".json";
}

// Returns an empty string on success. A non-empty reason means the file is
// malformed and the WHOLE package reverts to stock. Entry-level shape problems
// are recorded per value (shape_valid=false) and revert only that value.
inline std::string parse_values_file(
	std::string_view text, std::string_view expected_package_id, UserState& out)
{
	out = UserState{};
	if (text.size() > maximum_values_file_bytes) return "values-file-too-large";
	json::Value root;
	if (const auto error = json::parse(text, root); !error.empty()) return "values-file-" + error;
	if (!root.is_object()) return "values-file-not-object";
	for (const auto& [key, value] : root.members)
	{
		(void)value;
		if (key != "format" && key != "package" && key != "build" && key != "use_stock"
			&& key != "groups" && key != "values")
		{
			return "values-file-unknown-field=" + key;
		}
	}
	const auto* format = root.find("format");
	if (format == nullptr || !format->is_string() || format->text != values_format)
		return "values-file-format-not-RENOVICE_SCRIPT_SETTINGS_V1";
	const auto* package = root.find("package");
	if (package == nullptr || !package->is_string()) return "values-file-package-missing";
	if (package->text != expected_package_id)
		return "values-file-package-mismatch expected=" + std::string(expected_package_id)
			+ " found=" + package->text;
	out.package = package->text;
	if (const auto* build = root.find("build"))
	{
		if (!build->is_string() || !valid_text(build->text, maximum_text_length, true))
			return "values-file-build-invalid";
		out.build = build->text;
	}
	if (const auto* use_stock = root.find("use_stock"))
	{
		if (!use_stock->is_bool()) return "values-file-use_stock-not-boolean";
		out.use_stock = use_stock->boolean;
	}
	if (const auto* groups = root.find("groups"))
	{
		if (!groups->is_object()) return "values-file-groups-not-object";
		for (const auto& [id, enabled] : groups->members)
		{
			if (!enabled.is_bool()) return "values-file-group-not-boolean=" + id;
			out.groups[id] = enabled.boolean;
		}
	}
	if (const auto* values = root.find("values"))
	{
		if (!values->is_object()) return "values-file-values-not-object";
		if (values->members.size() > maximum_values_per_package * 2)
			return "values-file-too-many-values";
		for (const auto& [id, entry] : values->members)
		{
			UserValue value;
			if (!entry.is_object())
			{
				value.shape_valid = false;
				value.shape_reason = "entry-not-object";
			}
			else
			{
				for (const auto& [key, field] : entry.members)
				{
					if (key == "enabled")
					{
						if (!field.is_bool()) { value.shape_valid = false; value.shape_reason = "enabled-not-boolean"; }
						else value.enabled = field.boolean;
					}
					else if (key == "value")
					{
						if (!field.is_number()) { value.shape_valid = false; value.shape_reason = "value-not-number"; }
						else { value.has_value = true; value.value = field.number; }
					}
					else if (key == "stock")
					{
						if (!field.is_number()) { value.shape_valid = false; value.shape_reason = "stock-not-number"; }
						else { value.has_stock = true; value.stock = field.number; }
					}
					else
					{
						value.shape_valid = false;
						value.shape_reason = "entry-unknown-field=" + key;
					}
				}
				if (value.shape_valid && entry.find("enabled") == nullptr)
				{
					value.shape_valid = false;
					value.shape_reason = "enabled-missing";
				}
			}
			out.values[id] = std::move(value);
		}
	}
	return {};
}

// Deterministic, pretty values file. `stock` is recorded per value so a later
// client build can prove the declared stock is unchanged before carrying a
// value over (design section 3.4 step 1).
inline std::string write_values_file(
	const UserState& state, const Declarations* declarations)
{
	std::string out;
	out += "{\n";
	out += "  \"format\": " + json::quote(values_format) + ",\n";
	out += "  \"package\": " + json::quote(state.package) + ",\n";
	out += "  \"build\": " + json::quote(state.build) + ",\n";
	out += std::string("  \"use_stock\": ") + (state.use_stock ? "true" : "false") + ",\n";
	out += "  \"groups\": {";
	bool first = true;
	for (const auto& [id, enabled] : state.groups)
	{
		out += first ? "\n" : ",\n";
		first = false;
		out += "    " + json::quote(id) + ": " + (enabled ? "true" : "false");
	}
	out += first ? "},\n" : "\n  },\n";
	out += "  \"values\": {";
	first = true;
	for (const auto& [id, value] : state.values)
	{
		out += first ? "\n" : ",\n";
		first = false;
		out += "    " + json::quote(id) + ": { \"enabled\": " + (value.enabled ? "true" : "false");
		if (value.has_value) out += ", \"value\": " + json::number_text(value.value);
		const ValueDecl* declaration = declarations != nullptr ? declarations->value(id) : nullptr;
		if (declaration != nullptr) out += ", \"stock\": " + json::number_text(declaration->stock);
		else if (value.has_stock) out += ", \"stock\": " + json::number_text(value.stock);
		out += " }";
	}
	out += first ? "}\n" : "\n  }\n";
	out += "}\n";
	return out;
}

// ---------------------------------------------------------------------------
// Validation of one value against its declaration. Empty = valid.
// ---------------------------------------------------------------------------
inline std::string validate_value(const ValueDecl& declaration, double value)
{
	if (!std::isfinite(value)) return "not-finite";
	if (value < declaration.minimum || value > declaration.maximum) return "outside-min-max";
	if (declaration.type == ValueType::Int)
	{
		if (!whole(value)) return "int-has-fraction";
		if (std::fabs(value) > maximum_exact_integer) return "int-not-exact-in-float32";
	}
	if (declaration.type == ValueType::Enum
		&& std::none_of(declaration.options.begin(), declaration.options.end(),
			[&](const EnumOption& option) { return option.value == value; }))
	{
		return "enum-value-not-an-option";
	}
	return {};
}

// ---------------------------------------------------------------------------
// SHA-256 (FIPS 180-4) for the settings identity digest.
// ---------------------------------------------------------------------------
inline std::string sha256_hex(std::string_view data)
{
	static constexpr std::uint32_t k[64] = {
		0x428a2f98u, 0x71374491u, 0xb5c0fbcfu, 0xe9b5dba5u, 0x3956c25bu, 0x59f111f1u, 0x923f82a4u, 0xab1c5ed5u,
		0xd807aa98u, 0x12835b01u, 0x243185beu, 0x550c7dc3u, 0x72be5d74u, 0x80deb1feu, 0x9bdc06a7u, 0xc19bf174u,
		0xe49b69c1u, 0xefbe4786u, 0x0fc19dc6u, 0x240ca1ccu, 0x2de92c6fu, 0x4a7484aau, 0x5cb0a9dcu, 0x76f988dau,
		0x983e5152u, 0xa831c66du, 0xb00327c8u, 0xbf597fc7u, 0xc6e00bf3u, 0xd5a79147u, 0x06ca6351u, 0x14292967u,
		0x27b70a85u, 0x2e1b2138u, 0x4d2c6dfcu, 0x53380d13u, 0x650a7354u, 0x766a0abbu, 0x81c2c92eu, 0x92722c85u,
		0xa2bfe8a1u, 0xa81a664bu, 0xc24b8b70u, 0xc76c51a3u, 0xd192e819u, 0xd6990624u, 0xf40e3585u, 0x106aa070u,
		0x19a4c116u, 0x1e376c08u, 0x2748774cu, 0x34b0bcb5u, 0x391c0cb3u, 0x4ed8aa4au, 0x5b9cca4fu, 0x682e6ff3u,
		0x748f82eeu, 0x78a5636fu, 0x84c87814u, 0x8cc70208u, 0x90befffau, 0xa4506cebu, 0xbef9a3f7u, 0xc67178f2u};
	std::uint32_t h[8] = {0x6a09e667u, 0xbb67ae85u, 0x3c6ef372u, 0xa54ff53au,
		0x510e527fu, 0x9b05688cu, 0x1f83d9abu, 0x5be0cd19u};
	const auto rotr = [](std::uint32_t x, int n) { return (x >> n) | (x << (32 - n)); };
	std::vector<unsigned char> message(data.begin(), data.end());
	const std::uint64_t bit_length = static_cast<std::uint64_t>(data.size()) * 8u;
	message.push_back(0x80u);
	while (message.size() % 64 != 56) message.push_back(0);
	for (int i = 7; i >= 0; --i) message.push_back(static_cast<unsigned char>(bit_length >> (i * 8)));
	for (std::size_t chunk = 0; chunk != message.size(); chunk += 64)
	{
		std::uint32_t w[64];
		for (int i = 0; i != 16; ++i)
		{
			w[i] = (static_cast<std::uint32_t>(message[chunk + i * 4]) << 24)
				| (static_cast<std::uint32_t>(message[chunk + i * 4 + 1]) << 16)
				| (static_cast<std::uint32_t>(message[chunk + i * 4 + 2]) << 8)
				| static_cast<std::uint32_t>(message[chunk + i * 4 + 3]);
		}
		for (int i = 16; i != 64; ++i)
		{
			const std::uint32_t s0 = rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
			const std::uint32_t s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
			w[i] = w[i - 16] + s0 + w[i - 7] + s1;
		}
		std::uint32_t a = h[0], b = h[1], c = h[2], d = h[3], e = h[4], f = h[5], g = h[6], hh = h[7];
		for (int i = 0; i != 64; ++i)
		{
			const std::uint32_t s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
			const std::uint32_t ch = (e & f) ^ (~e & g);
			const std::uint32_t t1 = hh + s1 + ch + k[i] + w[i];
			const std::uint32_t s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
			const std::uint32_t maj = (a & b) ^ (a & c) ^ (b & c);
			const std::uint32_t t2 = s0 + maj;
			hh = g; g = f; f = e; e = d + t1; d = c; c = b; b = a; a = t1 + t2;
		}
		h[0] += a; h[1] += b; h[2] += c; h[3] += d; h[4] += e; h[5] += f; h[6] += g; h[7] += hh;
	}
	static constexpr char digits[] = "0123456789abcdef";
	std::string out;
	out.reserve(64);
	for (const std::uint32_t word : h)
	{
		for (int shift = 28; shift >= 0; shift -= 4) out.push_back(digits[(word >> shift) & 0xFu]);
	}
	return out;
}

// ---------------------------------------------------------------------------
// Effective settings and delivery (design section 3.4).
// ---------------------------------------------------------------------------
struct DeliveredValue
{
	std::string id;
	float value = 0.0f;
	float stock = 0.0f;
};

// Generation-owned delivery for ONE addon member. The host turns it into a
// fresh `context.settings = { [id] = { enabled = true, value, stock } }` in the
// committing VM for every activate(context) of this member. Only effective
// (enabled, valid, in an enabled group, master off) addon-lane values appear:
// a disabled value is simply absent, so the addon writes nothing and stock
// stays. `identity` joins the target-addon reuse identity, so a settings-only
// change forces cleanup + activate even though the bytes are unchanged.
struct MemberDelivery
{
	std::vector<DeliveredValue> values; // sorted by id
	std::string identity;
};

struct ValueRejection
{
	std::string id;
	std::string reason;
};

enum class FileStatus { Absent, Valid, Malformed };

inline const char* file_status_label(FileStatus status) noexcept
{
	switch (status)
	{
	case FileStatus::Absent: return "absent";
	case FileStatus::Valid: return "valid";
	case FileStatus::Malformed: return "malformed";
	}
	return "unknown";
}

struct PackageEvaluation
{
	FileStatus file = FileStatus::Absent;
	std::string file_reason;
	bool use_stock = false;
	std::set<std::string> effective;        // effective value ids (all lanes)
	std::vector<ValueRejection> rejections; // invalid entries (value reverts to stock)
	std::size_t unknown_entries = 0;        // entries without a declaration (ignored)
};

inline std::uint32_t float_bits(float value) noexcept
{
	std::uint32_t bits = 0;
	std::memcpy(&bits, &value, sizeof(bits));
	return bits;
}

inline std::string canonical_delivery(const std::vector<DeliveredValue>& values)
{
	std::string canonical = "ADDON_SETTINGS_V1\n";
	static constexpr char digits[] = "0123456789abcdef";
	const auto hex32 = [&](std::uint32_t value)
	{
		std::string text(8, '0');
		for (int i = 7; i >= 0; --i) { text[static_cast<std::size_t>(i)] = digits[value & 0xFu]; value >>= 4; }
		return text;
	};
	for (const auto& value : values)
	{
		canonical += value.id;
		canonical += '\x1f';
		canonical += hex32(float_bits(value.value));
		canonical += '\x1f';
		canonical += hex32(float_bits(value.stock));
		canonical += '\n';
	}
	return canonical;
}

inline std::string delivery_identity(const std::vector<DeliveredValue>& values)
{
	return "settings-v1:" + sha256_hex(canonical_delivery(values));
}

// state == nullptr: the file is absent (everything stock). file_error non-empty:
// the file is malformed (everything stock, reason reported once).
inline PackageEvaluation evaluate(
	const Declarations& declarations,
	const UserState* state,
	const std::string& file_error)
{
	PackageEvaluation result;
	if (!file_error.empty())
	{
		result.file = FileStatus::Malformed;
		result.file_reason = file_error;
		return result;
	}
	if (state == nullptr) return result;
	result.file = FileStatus::Valid;
	result.use_stock = state->use_stock;
	const bool build_changed = !state->build.empty() && !declarations.build.empty()
		&& state->build != declarations.build;
	for (const auto& [id, entry] : state->values)
	{
		const ValueDecl* declaration = declarations.value(id);
		if (declaration == nullptr)
		{
			++result.unknown_entries;
			continue;
		}
		if (!entry.shape_valid)
		{
			result.rejections.push_back({id, entry.shape_reason});
			continue;
		}
		if (!entry.enabled) continue;
		if (!entry.has_value)
		{
			result.rejections.push_back({id, "value-missing"});
			continue;
		}
		if (auto reason = validate_value(*declaration, entry.value); !reason.empty())
		{
			result.rejections.push_back({id, reason});
			continue;
		}
		if (build_changed && (!entry.has_stock || entry.stock != declaration->stock))
		{
			result.rejections.push_back({id, "build-mismatch-stock-unverified"});
			continue;
		}
		if (entry.has_stock && entry.stock != declaration->stock)
		{
			result.rejections.push_back({id, "recorded-stock-differs-from-declaration"});
			continue;
		}
		if (state->use_stock) continue;
		const auto group = state->groups.find(declaration->group);
		if (group != state->groups.end() && !group->second) continue; // section switch off
		result.effective.insert(id);
	}
	return result;
}

inline std::shared_ptr<const MemberDelivery> member_delivery(
	const Declarations& declarations,
	const UserState* state,
	const PackageEvaluation& evaluation,
	std::string_view member)
{
	auto delivery = std::make_shared<MemberDelivery>();
	if (state != nullptr && evaluation.file == FileStatus::Valid)
	{
		for (const auto& declaration : declarations.values)
		{
			if (declaration.member != member || declaration.lane != Lane::Addon
				|| evaluation.effective.count(declaration.id) == 0)
			{
				continue;
			}
			const auto entry = state->values.find(declaration.id);
			if (entry == state->values.end()) continue;
			delivery->values.push_back(DeliveredValue{
				declaration.id,
				static_cast<float>(entry->second.value),
				static_cast<float>(declaration.stock)});
		}
	}
	std::sort(delivery->values.begin(), delivery->values.end(),
		[](const DeliveredValue& lhs, const DeliveredValue& rhs) { return lhs.id < rhs.id; });
	delivery->identity = delivery_identity(delivery->values);
	return delivery;
}

inline bool member_declares_values(const Declarations& declarations, std::string_view member)
{
	return std::any_of(declarations.values.begin(), declarations.values.end(),
		[&](const ValueDecl& value) { return value.member == member; });
}

// Literal-lane gate for a replacement member whose bytes embed custom values
// (design section 5). A replacement member without literal declarations is
// unaffected. With literal declarations it is staged only when the values file
// is valid, the master switch is off and at least one of its literal values is
// enabled (for a member that holds exactly one value this is that value's
// per-value switch). The value numbers themselves are fixed in the bytes.
inline bool literal_member_admitted(
	const Declarations& declarations,
	const UserState* state,
	const PackageEvaluation& evaluation,
	std::string_view member)
{
	bool has_literal = false;
	bool any_enabled = false;
	for (const auto& declaration : declarations.values)
	{
		if (declaration.member != member || declaration.lane != Lane::Literal) continue;
		has_literal = true;
		if (state == nullptr || evaluation.file != FileStatus::Valid || state->use_stock) continue;
		const auto group = state->groups.find(declaration.group);
		if (group != state->groups.end() && !group->second) continue;
		const auto entry = state->values.find(declaration.id);
		if (entry != state->values.end() && entry->second.shape_valid && entry->second.enabled)
			any_enabled = true;
	}
	return !has_literal || any_enabled;
}

// Target-addon reuse identity (design section 3.4 step 2). A binding is reused
// only when the name, content, bound environment AND settings identity match;
// an addon without declarations has an empty settings identity.
inline bool target_addon_binding_reusable(
	bool same_name,
	bool same_content,
	bool same_environment,
	std::string_view current_settings_identity,
	std::string_view desired_settings_identity) noexcept
{
	return same_name && same_content && same_environment
		&& current_settings_identity == desired_settings_identity;
}
}
