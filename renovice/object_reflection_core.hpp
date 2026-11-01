#pragma once
// OBJECT_REFLECTION_V1 (2026-10-31): pure, offline-testable core of RENOVICE.object.
//
// The engine has no stored field-descriptor table. Every engine object has a
// field-visit virtual (vtable +0x50, "Serialise") that hands each field to an
// archive object: archive->vt[name slot](NameRecord*) then
// archive->vt[typed slot](&this->field). The engine's own text reader applies
// "Name=value" text through that visit (the metadata-patch path); the engine's
// own text writer produces the object's text. This header holds everything
// that does not touch the process: the engine's field-name normalisation, the
// value-to-text rules, the top-level text parser, the change diff, a PE image
// view and the per-build function resolver (byte-structural, no RVAs).
//
// Evidence (44.1.3, Warframe.x64.exe c1ae12fb...): RESEARCH/OBJECT_REFLECTION_V1_2026-10-31.md.
#include <algorithm>
#include <array>
#include <charconv>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <map>
#include <optional>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

namespace renovice::object_reflection
{
// ---------------------------------------------------------------- field types

enum class FieldType : std::uint8_t
{
	float32,   // archive float slot: 4-byte float
	boolean,   // archive bool slot: 1 byte, text "0"/"1"
	int32,     // archive int32 slot: 4-byte int
	int_wide,  // archive integer slot that widens through the int32 slot (8-byte field, low dword = value)
	symbol,    // archive symbol slot: interned name id; text is a quoted name
	other,     // composite / custom / unrecognised: read-only, value only as dump text
};

inline const char* field_type_label(FieldType type) noexcept
{
	switch (type)
	{
	case FieldType::float32: return "float";
	case FieldType::boolean: return "bool";
	case FieldType::int32: return "int";
	case FieldType::int_wide: return "int";
	case FieldType::symbol: return "symbol";
	case FieldType::other: return "other";
	}
	return "other";
}

inline bool field_type_writable(FieldType type) noexcept
{
	return type != FieldType::other;
}

// Archive interface slot layout. Versioned data: every slot is structurally
// re-validated on the running image before use (resolve() below); a build
// whose archive bodies do not match fails closed with the exact slot.
struct ArchiveSlots
{
	std::uint32_t name = 0;
	std::uint32_t float32 = 0;
	std::uint32_t boolean = 0;
	std::uint32_t int32 = 0;
	std::uint32_t int_wide = 0;
	std::uint32_t symbol = 0;
	std::uint32_t is_reading_mode_byte = 0; // archive byte that equals 1 for a reader
};
inline constexpr ArchiveSlots archive_slots_u44{0x138, 0xc0, 0xd0, 0x108, 0x110, 0x120, 0x0a};
inline constexpr std::uint32_t object_field_visit_slot = 0x50; // obj->vt[+0x50](obj, archive)
inline constexpr int writer_flags = 3;                          // as 21 engine writer sites (bit0 set, bit2 clear)

inline FieldType classify_slot(const ArchiveSlots& slots, std::uint32_t slot) noexcept
{
	if (slot == slots.float32) return FieldType::float32;
	if (slot == slots.boolean) return FieldType::boolean;
	if (slot == slots.int32) return FieldType::int32;
	if (slot == slots.int_wide) return FieldType::int_wide;
	if (slot == slots.symbol) return FieldType::symbol;
	return FieldType::other;
}

// ------------------------------------------------------ field-name normalisation

// Engine rule (name normaliser called by both the reader and the writer name
// slot, 0x1413dbd90 on 44.1.3) for a raw name record (tag 0xa000000000000000):
//   1. drop everything up to and including the last '.' or '>' ("this->mX");
//   2. drop a leading 'm', 's' or 'g' when the next character is 'A'..'Z'.
// "mSpawnRate" -> "SpawnRate"; "mbFoo" stays "mbFoo"; "gX" -> "X".
// The engine compares the result case-sensitively with the text key.
inline std::string normalise_field_name(std::string_view raw)
{
	std::size_t start = 0;
	for (std::size_t i = 0; i != raw.size(); ++i)
	{
		if (raw[i] == '.' || raw[i] == '>') start = i + 1;
	}
	std::string_view name = raw.substr(start);
	if (name.size() >= 2 && (name[0] == 'm' || name[0] == 's' || name[0] == 'g')
		&& name[1] >= 'A' && name[1] <= 'Z')
	{
		name.remove_prefix(1);
	}
	return std::string(name);
}

inline constexpr std::uint64_t name_record_tag_mask = 0xe000000000000000ull;
inline constexpr std::uint64_t name_record_raw_tag = 0xa000000000000000ull;

// A field key accepted from Lua: 1..128 of [A-Za-z0-9_] (after normalisation),
// so a key can never inject another line or nesting into the reader text.
inline bool valid_field_key(std::string_view key) noexcept
{
	if (key.empty() || key.size() > 128) return false;
	for (const char c : key)
	{
		const bool ok = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
			|| (c >= '0' && c <= '9') || c == '_';
		if (!ok) return false;
	}
	return true;
}

// The Lua spelling may be the engine member name or the metadata/text key.
inline std::string normalise_lua_key(std::string_view key)
{
	return normalise_field_name(key);
}

// ------------------------------------------------------------ value to text

struct LuaScalar
{
	enum class Kind : std::uint8_t { number, boolean, string, unsupported } kind = Kind::unsupported;
	double number = 0.0;
	bool boolean = false;
	std::string text;
};

struct Formatted
{
	std::string text;            // the value part of "Name=value"
	const char* reason = nullptr; // non-null: rejected, nothing is applied
};

inline bool valid_symbol_text(std::string_view text) noexcept
{
	if (text.empty() || text.size() > 256) return false;
	for (const char c : text)
	{
		const bool ok = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
			|| (c >= '0' && c <= '9') || c == '_' || c == '/' || c == '.'
			|| c == ':' || c == '-';
		if (!ok) return false;
	}
	return true;
}

inline std::string format_float(double value)
{
	// Shortest text that round-trips the 32-bit float the field stores
	// (plain notation; the field range is checked by the caller).
	const float narrowed = static_cast<float>(value);
	char buffer[128]{};
	const auto result = std::to_chars(buffer, buffer + sizeof(buffer) - 1, narrowed, std::chars_format::fixed);
	if (result.ec != std::errc{}) return "0";
	return std::string(buffer, result.ptr);
}

inline Formatted format_value(FieldType type, const LuaScalar& value)
{
	switch (type)
	{
	case FieldType::float32:
		if (value.kind != LuaScalar::Kind::number) return {{}, "value-type-mismatch expected=number"};
		if (!std::isfinite(value.number)
			|| std::fabs(value.number) > 3.4028234663852886e38) return {{}, "value-not-finite"};
		return {format_float(value.number), nullptr};
	case FieldType::int32:
	case FieldType::int_wide:
	{
		if (value.kind != LuaScalar::Kind::number) return {{}, "value-type-mismatch expected=number"};
		if (!std::isfinite(value.number) || std::floor(value.number) != value.number)
			return {{}, "value-not-integer"};
		if (value.number < -2147483648.0 || value.number > 2147483647.0)
			return {{}, "value-out-of-int32-range"};
		char buffer[32]{};
		std::snprintf(buffer, sizeof(buffer), "%lld", static_cast<long long>(value.number));
		return {buffer, nullptr};
	}
	case FieldType::boolean:
		if (value.kind != LuaScalar::Kind::boolean) return {{}, "value-type-mismatch expected=boolean"};
		return {value.boolean ? "1" : "0", nullptr};
	case FieldType::symbol:
		if (value.kind != LuaScalar::Kind::string) return {{}, "value-type-mismatch expected=string"};
		if (!valid_symbol_text(value.text)) return {{}, "value-invalid-symbol"};
		return {"\"" + value.text + "\"", nullptr};
	case FieldType::other:
		break;
	}
	return {{}, "field-type-not-writable"};
}

// Text limits for RENOVICE.object.apply.
inline constexpr std::size_t apply_text_limit = 65536;

inline const char* validate_apply_text(std::string_view text) noexcept
{
	if (text.empty()) return "text-empty";
	if (text.size() > apply_text_limit) return "text-too-long";
	if (text.find('\0') != std::string_view::npos) return "text-contains-nul";
	return nullptr;
}

// ----------------------------------------------------- top-level text parser

// The engine text (EE notation, same as metadata): "Key=Value" per line,
// objects "Key={ ... }" and arrays "Key={a,b}" spanning lines, quoted strings
// "...". Only depth-0 keys are returned; a nested value is kept as raw text.
struct TextEntry
{
	std::string name;
	std::string value;
};

inline std::string_view trim_view(std::string_view text) noexcept
{
	while (!text.empty() && (text.front() == ' ' || text.front() == '\t'
		|| text.front() == '\r' || text.front() == '\n')) text.remove_prefix(1);
	while (!text.empty() && (text.back() == ' ' || text.back() == '\t'
		|| text.back() == '\r' || text.back() == '\n')) text.remove_suffix(1);
	return text;
}

struct ParsedText
{
	std::vector<TextEntry> entries;
	const char* reason = nullptr;
};

inline ParsedText parse_top_level(std::string_view text)
{
	ParsedText parsed;
	int depth = 0;
	bool in_string = false;
	bool have_key = false;
	std::string key;
	std::string buffer;
	auto finish_line = [&]()
	{
		if (have_key)
		{
			const auto name = trim_view(key);
			if (!name.empty())
				parsed.entries.push_back({std::string(name), std::string(trim_view(buffer))});
		}
		have_key = false;
		key.clear();
		buffer.clear();
	};
	for (const char c : text)
	{
		if (in_string)
		{
			buffer.push_back(c);
			if (c == '"') in_string = false;
			continue;
		}
		if (c == '"')
		{
			in_string = true;
			buffer.push_back(c);
			continue;
		}
		if (c == '{') ++depth;
		if (c == '}')
		{
			if (depth == 0)
			{
				parsed.reason = "dump-text-unbalanced";
				return parsed;
			}
			--depth;
		}
		if (depth == 0 && c == '=' && !have_key)
		{
			have_key = true;
			key = buffer;
			buffer.clear();
			continue;
		}
		if (depth == 0 && c == '\n')
		{
			finish_line();
			continue;
		}
		buffer.push_back(c);
	}
	if (in_string || depth != 0)
	{
		parsed.reason = "dump-text-unbalanced";
		return parsed;
	}
	finish_line();
	return parsed;
}

inline const TextEntry* find_entry(const std::vector<TextEntry>& entries, std::string_view name) noexcept
{
	for (const auto& entry : entries)
		if (entry.name == name) return &entry;
	return nullptr;
}

inline std::string unquote(std::string_view value)
{
	if (value.size() >= 2 && value.front() == '"' && value.back() == '"')
		return std::string(value.substr(1, value.size() - 2));
	return std::string(value);
}

// Names whose depth-0 text differs between two dumps (added, removed or changed),
// in "after" order, then names only present before.
inline std::vector<std::string> changed_names(
	const std::vector<TextEntry>& before, const std::vector<TextEntry>& after)
{
	std::vector<std::string> changed;
	for (const auto& entry : after)
	{
		const auto* old = find_entry(before, entry.name);
		if (old == nullptr || old->value != entry.value) changed.push_back(entry.name);
	}
	for (const auto& entry : before)
	{
		if (find_entry(after, entry.name) == nullptr) changed.push_back(entry.name);
	}
	return changed;
}

// ------------------------------------------------- probe field association

// One archive call observed by the recording writer vtable.
struct NameCall
{
	std::string name;                 // normalised
	std::uintptr_t container = 0;     // writer current-node pointer at the call
	std::uintptr_t return_address = 0;
};

// Binding rule for a typed slot call to the preceding name call: the typed
// call must come from the same field-visit body, right after the name call
// (0 < distance <= 0x40), and the instruction before its return address must
// be the exact virtual call of that slot ("FF /2 disp32" or "FF /2 disp8",
// optional REX). A typed call made inside a helper or inside another archive
// slot (e.g. the widening integer slot calling the int32 slot) fails this rule.
inline bool call_site_encodes_slot(const std::uint8_t* before_return, std::size_t available,
	std::uint32_t slot) noexcept
{
	if (available >= 6)
	{
		const auto* p = before_return - 6;
		if (p[0] == 0xFF && (p[1] & 0xF8) == 0x90 && (p[1] & 7) != 4)
		{
			std::uint32_t displacement = 0;
			std::memcpy(&displacement, p + 2, 4);
			if (displacement == slot) return true;
		}
	}
	if (available >= 3 && slot < 0x80)
	{
		const auto* p = before_return - 3;
		if (p[0] == 0xFF && (p[1] & 0xF8) == 0x50 && (p[1] & 7) != 4 && p[2] == slot) return true;
	}
	return false;
}

inline constexpr std::uintptr_t typed_call_window = 0x40;

inline bool typed_call_follows_name(std::uintptr_t name_return, std::uintptr_t typed_return) noexcept
{
	return typed_return > name_return && typed_return - name_return <= typed_call_window;
}

// ------------------------------------------------------------- PE image view

struct Section
{
	std::uint64_t begin = 0; // VA
	std::uint64_t end = 0;
	bool executable = false;
	bool writable = false;
};

struct ImageView
{
	std::uint64_t base = 0;              // VA of byte 0
	const std::uint8_t* bytes = nullptr; // image laid out by RVA
	std::size_t size = 0;                // SizeOfImage
	std::vector<Section> sections;

	bool contains(std::uint64_t va, std::size_t length) const noexcept
	{
		return va >= base && length <= size && va - base <= size - length;
	}
	const std::uint8_t* at(std::uint64_t va, std::size_t length) const noexcept
	{
		return contains(va, length) ? bytes + (va - base) : nullptr;
	}
	bool in_executable(std::uint64_t va) const noexcept
	{
		for (const auto& s : sections)
			if (s.executable && va >= s.begin && va < s.end) return true;
		return false;
	}
	bool in_readonly_data(std::uint64_t va) const noexcept
	{
		for (const auto& s : sections)
			if (!s.executable && !s.writable && va >= s.begin && va < s.end) return true;
		return false;
	}
	std::optional<std::uint64_t> u64(std::uint64_t va) const noexcept
	{
		const auto* p = at(va, 8);
		if (p == nullptr) return std::nullopt;
		std::uint64_t value = 0;
		std::memcpy(&value, p, 8);
		return value;
	}
};

// Parses the section table of an image laid out by RVA (a loaded module or a
// file mapped with map_file_image). Returns false on a malformed header.
inline bool parse_sections(ImageView& image) noexcept
{
	image.sections.clear();
	const auto* b = image.bytes;
	if (b == nullptr || image.size < 0x400 || b[0] != 'M' || b[1] != 'Z') return false;
	std::uint32_t pe = 0;
	std::memcpy(&pe, b + 0x3c, 4);
	if (pe > image.size - 0x108 || std::memcmp(b + pe, "PE\0\0", 4) != 0) return false;
	std::uint16_t count = 0, optional_size = 0;
	std::memcpy(&count, b + pe + 6, 2);
	std::memcpy(&optional_size, b + pe + 20, 2);
	const std::size_t table = pe + 24 + optional_size;
	if (count == 0 || count > 96 || table + std::size_t{count} * 40 > image.size) return false;
	for (std::uint16_t i = 0; i != count; ++i)
	{
		const auto* s = b + table + std::size_t{i} * 40;
		std::uint32_t virtual_size = 0, rva = 0, characteristics = 0;
		std::memcpy(&virtual_size, s + 8, 4);
		std::memcpy(&rva, s + 12, 4);
		std::memcpy(&characteristics, s + 36, 4);
		Section section;
		section.begin = image.base + rva;
		section.end = section.begin + virtual_size;
		section.executable = (characteristics & 0x20000000u) != 0;
		section.writable = (characteristics & 0x80000000u) != 0;
		image.sections.push_back(section);
	}
	return true;
}

// Lays out a PE file by RVA (offline gates read the client executable).
inline bool map_file_image(const std::vector<std::uint8_t>& file, std::vector<std::uint8_t>& mapped,
	std::uint64_t& image_base) noexcept
{
	if (file.size() < 0x400 || file[0] != 'M' || file[1] != 'Z') return false;
	std::uint32_t pe = 0;
	std::memcpy(&pe, file.data() + 0x3c, 4);
	if (pe > file.size() - 0x108) return false;
	std::uint16_t count = 0, optional_size = 0;
	std::memcpy(&count, file.data() + pe + 6, 2);
	std::memcpy(&optional_size, file.data() + pe + 20, 2);
	std::uint32_t size_of_image = 0, size_of_headers = 0;
	std::memcpy(&image_base, file.data() + pe + 24 + 24, 8);
	std::memcpy(&size_of_image, file.data() + pe + 24 + 56, 4);
	std::memcpy(&size_of_headers, file.data() + pe + 24 + 60, 4);
	if (size_of_image == 0 || size_of_image > (1u << 30) || size_of_headers > file.size()) return false;
	try { mapped.assign(size_of_image, 0); }
	catch (...) { return false; }
	std::memcpy(mapped.data(), file.data(), (std::min)(std::size_t{size_of_headers}, mapped.size()));
	const std::size_t table = pe + 24 + optional_size;
	for (std::uint16_t i = 0; i != count; ++i)
	{
		const auto* s = file.data() + table + std::size_t{i} * 40;
		std::uint32_t virtual_size = 0, rva = 0, raw_size = 0, raw_offset = 0;
		std::memcpy(&virtual_size, s + 8, 4);
		std::memcpy(&rva, s + 12, 4);
		std::memcpy(&raw_size, s + 16, 4);
		std::memcpy(&raw_offset, s + 20, 4);
		const std::size_t length = (std::min)(raw_size, virtual_size);
		if (rva > mapped.size() || length > mapped.size() - rva
			|| raw_offset > file.size() || length > file.size() - raw_offset) return false;
		std::memcpy(mapped.data() + rva, file.data() + raw_offset, length);
	}
	return true;
}

// --------------------------------------------------------- byte matching

// Pattern "41 B1 03 ? E8" (? = any byte).
inline std::vector<int> compile_pattern(std::string_view pattern)
{
	std::vector<int> out;
	std::size_t i = 0;
	while (i < pattern.size())
	{
		while (i < pattern.size() && pattern[i] == ' ') ++i;
		if (i >= pattern.size()) break;
		if (pattern[i] == '?')
		{
			out.push_back(-1);
			while (i < pattern.size() && pattern[i] == '?') ++i;
			continue;
		}
		auto hex = [](char c) -> int
		{
			if (c >= '0' && c <= '9') return c - '0';
			if (c >= 'a' && c <= 'f') return c - 'a' + 10;
			if (c >= 'A' && c <= 'F') return c - 'A' + 10;
			return -1;
		};
		const int high = hex(pattern[i]);
		const int low = i + 1 < pattern.size() ? hex(pattern[i + 1]) : -1;
		if (high < 0 || low < 0) return {};
		out.push_back(high * 16 + low);
		i += 2;
	}
	return out;
}

inline bool match_at(const std::uint8_t* p, const std::vector<int>& pattern) noexcept
{
	for (std::size_t i = 0; i != pattern.size(); ++i)
		if (pattern[i] >= 0 && p[i] != pattern[i]) return false;
	return true;
}

// Every match of a pattern in the executable sections.
inline std::vector<std::uint64_t> scan_executable(const ImageView& image, std::string_view text)
{
	const auto pattern = compile_pattern(text);
	std::vector<std::uint64_t> hits;
	if (pattern.empty()) return hits;
	for (const auto& s : image.sections)
	{
		if (!s.executable || s.end <= s.begin) continue;
		const auto* begin = image.at(s.begin, 1);
		if (begin == nullptr) continue;
		const std::size_t length = static_cast<std::size_t>(
			(std::min)(s.end, image.base + image.size) - s.begin);
		if (length < pattern.size()) continue;
		const int first = pattern[0];
		for (std::size_t i = 0; i + pattern.size() <= length; ++i)
		{
			if (first >= 0 && begin[i] != first) continue;
			if (match_at(begin + i, pattern)) hits.push_back(s.begin + i);
		}
	}
	return hits;
}

// Finds a pattern inside [va, va + window) and returns the first match.
inline std::optional<std::uint64_t> find_in(const ImageView& image, std::uint64_t va,
	std::size_t window, std::string_view text)
{
	const auto pattern = compile_pattern(text);
	const auto* p = image.at(va, window);
	if (p == nullptr || pattern.empty() || window < pattern.size()) return std::nullopt;
	for (std::size_t i = 0; i + pattern.size() <= window; ++i)
		if (match_at(p + i, pattern)) return va + i;
	return std::nullopt;
}

inline std::optional<std::int32_t> i32_at(const ImageView& image, std::uint64_t va) noexcept
{
	const auto* p = image.at(va, 4);
	if (p == nullptr) return std::nullopt;
	std::int32_t value = 0;
	std::memcpy(&value, p, 4);
	return value;
}

// E8 rel32 at va -> call target.
inline std::optional<std::uint64_t> call_target(const ImageView& image, std::uint64_t va) noexcept
{
	const auto* p = image.at(va, 5);
	if (p == nullptr || p[0] != 0xE8) return std::nullopt;
	std::int32_t rel = 0;
	std::memcpy(&rel, p + 1, 4);
	return va + 5 + static_cast<std::int64_t>(rel);
}

// "lea rcx/rdx, [rbp|rsp + disp]" (disp8 or disp32) at va.
struct LeaFrame
{
	bool rsp = false;
	std::int32_t displacement = 0;
	std::size_t length = 0;
	int reg = 0; // 1 = rcx, 2 = rdx
};

inline std::optional<LeaFrame> decode_lea_frame(const ImageView& image, std::uint64_t va) noexcept
{
	const auto* p = image.at(va, 8);
	if (p == nullptr || p[0] != 0x48 || p[1] != 0x8D) return std::nullopt;
	const std::uint8_t modrm = p[2];
	const int mod = modrm >> 6, reg = (modrm >> 3) & 7, rm = modrm & 7;
	if (reg != 1 && reg != 2) return std::nullopt;
	LeaFrame lea;
	lea.reg = reg;
	if (rm == 5 && (mod == 1 || mod == 2))
	{
		lea.rsp = false;
		if (mod == 1) { lea.displacement = static_cast<std::int8_t>(p[3]); lea.length = 4; }
		else { std::memcpy(&lea.displacement, p + 3, 4); lea.length = 7; }
		return lea;
	}
	if (rm == 4 && p[3] == 0x24 && (mod == 1 || mod == 2))
	{
		lea.rsp = true;
		if (mod == 1) { lea.displacement = static_cast<std::int8_t>(p[4]); lea.length = 5; }
		else { std::memcpy(&lea.displacement, p + 4, 4); lea.length = 8; }
		return lea;
	}
	return std::nullopt;
}

inline bool same_frame(const LeaFrame& a, const LeaFrame& b) noexcept
{
	return a.rsp == b.rsp && a.displacement == b.displacement;
}

// "lea rcx,[frame]; call X" starting exactly at va.
struct FrameCall
{
	LeaFrame frame;
	std::uint64_t call_va = 0;
	std::uint64_t target = 0;
};

inline std::optional<FrameCall> frame_call_at(const ImageView& image, std::uint64_t va) noexcept
{
	const auto lea = decode_lea_frame(image, va);
	if (!lea || lea->reg != 1) return std::nullopt;
	const auto target = call_target(image, va + lea->length);
	if (!target) return std::nullopt;
	return FrameCall{*lea, va + lea->length, *target};
}

// --------------------------------------------------------------- resolver

struct Resolution
{
	const char* reason = nullptr; // null = complete
	std::string detail;
	std::uint64_t metadata_site = 0;
	// Reader (metadata text apply path).
	std::uint64_t reader_ctor = 0, reader_vtable = 0, text_load = 0, apply = 0, reader_dtor = 0;
	std::int32_t reader_post_load_flag = -1; // byte cleared after the load, before apply
	std::int32_t reader_status = -1;         // byte compared with reader_error_status after apply
	std::uint8_t reader_error_status = 0;
	std::uint64_t name_normaliser = 0;
	// Writer (engine text writer).
	std::uint64_t writer_ctor = 0, writer_vtable = 0, writer_begin = 0, writer_end = 0, writer_dtor = 0;
	std::uint32_t writer_vtable_slots = 0;
	std::int32_t writer_output = -1;       // GameString with the produced text
	std::int32_t writer_flags_offset = -1;
	std::int32_t writer_current_node = -1; // current container node pointer
	std::uint32_t writer_sites = 0;        // engine sites that agree on the writer sequence
	ArchiveSlots slots = archive_slots_u44;
	std::size_t reader_frame_size = 0;     // bytes the reader ctor touches (heap block must exceed)
	std::size_t writer_frame_size = 0;
};

inline constexpr const char* metadata_site_pattern =
	"41 B1 03 48 8D 55 ? 45 33 C0 48 8D 8D ? ? ? ? E8";

// Largest "[reg + disp32]" store displacement inside a constructor body,
// so the runtime can size its heap block with margin.
inline std::size_t ctor_extent(const ImageView& image, std::uint64_t ctor, std::size_t window)
{
	const auto* p = image.at(ctor, window);
	if (p == nullptr) return 0;
	std::size_t extent = 0;
	for (std::size_t i = 0; i + 7 <= window; ++i)
	{
		// mov [rbx|rdi + disp32], r  (48 89 83/BB/... ) or byte/word/dword stores: take any
		// ModRM with mod=2 and rm=rbx(3)/rdi(7) after an 89/88/C6/C7 opcode.
		const std::uint8_t op = p[i];
		if (op != 0x89 && op != 0x88 && op != 0xC6 && op != 0xC7) continue;
		const std::uint8_t modrm = p[i + 1];
		if ((modrm >> 6) != 2 || ((modrm & 7) != 3 && (modrm & 7) != 7)) continue;
		std::int32_t displacement = 0;
		std::memcpy(&displacement, p + i + 2, 4);
		if (displacement > 0 && displacement < 0x10000)
			extent = (std::max)(extent, static_cast<std::size_t>(displacement) + 8);
	}
	return extent;
}

// Validates a vtable and returns its slot count (consecutive executable entries).
inline std::uint32_t vtable_slot_count(const ImageView& image, std::uint64_t vtable, std::uint32_t maximum = 128)
{
	if (!image.in_readonly_data(vtable)) return 0;
	std::uint32_t count = 0;
	while (count < maximum)
	{
		const auto entry = image.u64(vtable + std::uint64_t{count} * 8);
		if (!entry || !image.in_executable(*entry)) break;
		++count;
	}
	return count;
}

// Name slot body: "cmp qword ptr [rdx], 0" then a call to the normaliser.
inline std::optional<std::uint64_t> name_slot_normaliser(const ImageView& image, std::uint64_t slot_function)
{
	const auto compare = find_in(image, slot_function, 0x30, "48 83 3A 00");
	if (!compare) return std::nullopt;
	const auto call = find_in(image, *compare, 0x20, "E8 ? ? ? ?");
	if (!call) return std::nullopt;
	return call_target(image, *call);
}

inline Resolution resolve(const ImageView& image)
{
	Resolution r;
	auto fail = [&](const char* reason, std::string detail = {})
	{
		r.reason = reason;
		r.detail = std::move(detail);
		return r;
	};
	// 1. The metadata text apply site (same signature the Metadata Patches hook uses).
	const auto sites = scan_executable(image, metadata_site_pattern);
	if (sites.size() != 1) return fail("metadata-site-not-unique", "count=" + std::to_string(sites.size()));
	const auto s = sites[0];
	r.metadata_site = s;
	const auto frame_displacement = i32_at(image, s + 13);
	const auto load = call_target(image, s + 17);
	if (!frame_displacement || !load || !image.in_executable(*load)) return fail("text-load-call-invalid");
	r.text_load = *load;
	const LeaFrame reader_frame{false, *frame_displacement, 7, 1};

	// 2. Reader ctor: the last call before the site preceded (within 16 bytes;
	// the compiler may schedule one unrelated store in between) by
	// "lea rcx,[rbp+D]". Its body must store the reader vtable (checked below).
	for (std::uint64_t va = s - 0x40; va + 5 <= s; ++va)
	{
		const auto target = call_target(image, va);
		if (!target || !image.in_executable(*target)) continue;
		for (std::uint64_t p = va - 16; p < va; ++p)
		{
			const auto lea = decode_lea_frame(image, p);
			if (lea && lea->reg == 1 && same_frame(*lea, reader_frame) && p + lea->length <= va)
				r.reader_ctor = *target;
		}
	}
	if (r.reader_ctor == 0 || !image.in_executable(r.reader_ctor)) return fail("reader-ctor-not-found");
	{
		const auto vt_store = find_in(image, r.reader_ctor, 0x30, "48 8D 05 ? ? ? ? 48 89 03");
		const auto rel = vt_store ? i32_at(image, *vt_store + 3) : std::nullopt;
		if (!rel) return fail("reader-ctor-shape", "no vtable store");
		r.reader_vtable = *vt_store + 7 + static_cast<std::int64_t>(*rel);
		if (vtable_slot_count(image, r.reader_vtable) * 8u <= r.slots.name)
			return fail("reader-vtable-invalid");
		r.reader_frame_size = ctor_extent(image, r.reader_ctor, 0x80);
	}

	// 3. Apply: "mov r8b,1; ... call" after the load, with "lea rdx,[rbp+D]" between.
	std::uint64_t apply_call = 0;
	{
		const auto flag = find_in(image, s + 22, 0x80, "41 B0 01");
		if (!flag) return fail("apply-call-not-found", "no lock flag");
		const auto call = find_in(image, *flag, 0x10, "E8 ? ? ? ?");
		if (!call) return fail("apply-call-not-found", "no call");
		bool archive_argument = false;
		for (std::uint64_t va = s + 22; va < *call; ++va)
		{
			const auto lea = decode_lea_frame(image, va);
			if (lea && lea->reg == 2 && same_frame(*lea, reader_frame)) archive_argument = true;
		}
		if (!archive_argument) return fail("apply-call-not-found", "archive argument");
		r.apply = *call_target(image, *call);
		apply_call = *call;
		if (!image.in_executable(r.apply)
			|| !find_in(image, r.apply, 0x100, "FF 50 50")       // obj->vt[+0x50](obj, archive)
			|| !find_in(image, r.apply, 0x100, "66 89 43 24"))   // stamps object+0x24
			return fail("apply-shape");
	}

	// 4. Post-load flag store "mov byte [rbp+D+k], 0" between the load and apply.
	for (std::uint64_t va = s + 22; va + 7 <= apply_call; ++va)
	{
		const auto* p = image.at(va, 7);
		if (p == nullptr || p[0] != 0xC6 || p[1] != 0x85 || p[6] != 0x00) continue;
		std::int32_t d = 0;
		std::memcpy(&d, p + 2, 4);
		const std::int64_t k = std::int64_t{d} - *frame_displacement;
		if (k >= 0 && k < 0x40) r.reader_post_load_flag = static_cast<std::int32_t>(k);
	}
	if (r.reader_post_load_flag < 0) return fail("reader-post-load-flag-not-found");

	// 5. Reader dtor: next "lea rcx,[rbp+D]; call" after apply; then the status byte read.
	std::uint64_t dtor_end = 0;
	for (std::uint64_t va = apply_call + 5; va < apply_call + 0x30; ++va)
	{
		const auto fc = frame_call_at(image, va);
		if (fc && same_frame(fc->frame, reader_frame))
		{
			r.reader_dtor = fc->target;
			dtor_end = fc->call_va + 5;
			break;
		}
	}
	if (r.reader_dtor == 0 || !image.in_executable(r.reader_dtor)) return fail("reader-dtor-not-found");
	{
		// "movzx eax, byte [rbp+D+s]" then (one unrelated instruction may be
		// scheduled between) "cmp al, imm8".
		const auto status = find_in(image, dtor_end, 0x20, "0F B6 85 ? ? ? ?");
		const auto d = status ? i32_at(image, *status + 3) : std::nullopt;
		const auto compare = status ? find_in(image, *status + 7, 8, "3C ?") : std::nullopt;
		const auto* code = compare ? image.at(*compare + 1, 1) : nullptr;
		if (!d || code == nullptr) return fail("reader-status-not-found");
		const std::int64_t k = std::int64_t{*d} - *frame_displacement;
		if (k < 0 || k >= 0x40) return fail("reader-status-not-found", "offset");
		r.reader_status = static_cast<std::int32_t>(k);
		r.reader_error_status = *code;
	}

	// 6. Name normaliser (reader name slot) and its raw-tag constant.
	{
		const auto slot = image.u64(r.reader_vtable + r.slots.name);
		const auto normaliser = slot ? name_slot_normaliser(image, *slot) : std::nullopt;
		if (!normaliser || !find_in(image, *normaliser, 0x40, "48 B9 00 00 00 00 00 00 00 A0"))
			return fail("name-normaliser-shape");
		r.name_normaliser = *normaliser;
	}

	// 7. Writer: engine sites "ctor(w); begin(w); apply(obj, w, 1); end(w); ... dtor(w)".
	struct Vote { std::uint64_t ctor, begin, end; std::uint32_t count; std::map<std::uint64_t, std::uint32_t> dtor; };
	std::vector<Vote> votes;
	const auto apply_callers = [&]()
	{
		std::vector<std::uint64_t> callers;
		for (const auto& section : image.sections)
		{
			if (!section.executable) continue;
			const auto* begin = image.at(section.begin, 1);
			if (begin == nullptr) continue;
			const std::size_t length = static_cast<std::size_t>(
				(std::min)(section.end, image.base + image.size) - section.begin);
			for (std::size_t i = 0; i + 5 <= length; ++i)
			{
				if (begin[i] != 0xE8) continue;
				std::int32_t rel = 0;
				std::memcpy(&rel, begin + i + 1, 4);
				if (section.begin + i + 5 + static_cast<std::int64_t>(rel) == r.apply)
					callers.push_back(section.begin + i);
			}
		}
		return callers;
	}();
	for (const auto caller : apply_callers)
	{
		// begin: "lea rcx,[W]; call B" ending within 0x40 bytes before the apply call,
		// directly preceded by "lea rcx,[W]; call C".
		std::optional<FrameCall> begin_call, ctor_call;
		for (std::uint64_t va = caller - 0x40; va < caller; ++va)
		{
			const auto fc = frame_call_at(image, va);
			if (!fc || fc->call_va + 5 > caller) continue;
			for (std::size_t back = 4; back <= 8; ++back)
			{
				const auto previous = frame_call_at(image, va - 5 - back);
				if (previous && previous->call_va + 5 == va && same_frame(previous->frame, fc->frame))
				{
					begin_call = fc;
					ctor_call = previous;
				}
			}
		}
		if (!begin_call || ctor_call->target == r.reader_ctor) continue;
		std::optional<FrameCall> end_call;
		for (std::uint64_t va = caller + 5; va < caller + 0x20 && !end_call; ++va)
		{
			const auto fc = frame_call_at(image, va);
			if (fc && same_frame(fc->frame, begin_call->frame)) end_call = fc;
		}
		if (!end_call) continue;
		std::optional<std::uint64_t> dtor;
		for (std::uint64_t va = end_call->call_va + 5; va < end_call->call_va + 0x100 && !dtor; ++va)
		{
			const auto fc = frame_call_at(image, va);
			if (fc && same_frame(fc->frame, begin_call->frame) && fc->target != end_call->target
				&& fc->target != begin_call->target && fc->target != ctor_call->target) dtor = fc->target;
		}
		auto found = std::find_if(votes.begin(), votes.end(), [&](const Vote& v)
		{
			return v.ctor == ctor_call->target && v.begin == begin_call->target && v.end == end_call->target;
		});
		if (found == votes.end())
		{
			votes.push_back({ctor_call->target, begin_call->target, end_call->target, 0, {}});
			found = votes.end() - 1;
		}
		++found->count;
		if (dtor) ++found->dtor[*dtor];
	}
	std::sort(votes.begin(), votes.end(), [](const Vote& a, const Vote& b) { return a.count > b.count; });
	for (const auto& vote : votes)
	{
		if (vote.count < 2) break;
		// Writer ctor shape: vtable store, flags store, output GameString init.
		const auto vt_store = find_in(image, vote.ctor, 0x40, "48 8D 05 ? ? ? ? 48 89 07");
		const auto flags_store = find_in(image, vote.ctor, 0x80, "89 9F ? ? ? ?");
		const auto output_init = find_in(image, vote.ctor, 0x80, "88 87 ? ? ? ?");
		if (!vt_store || !flags_store || !output_init) continue;
		const auto vt_rel = i32_at(image, *vt_store + 3);
		const auto flags_offset = i32_at(image, *flags_store + 2);
		const auto output_offset = i32_at(image, *output_init + 2);
		if (!vt_rel || !flags_offset || !output_offset) continue;
		// "mov word [rdi+O+0xf], 0xf": empty inline GameString.
		std::array<std::uint8_t, 4> inv{};
		const std::int32_t inv_offset = *output_offset + 0xf;
		std::memcpy(inv.data(), &inv_offset, 4);
		char inv_pattern[64]{};
		std::snprintf(inv_pattern, sizeof(inv_pattern), "66 C7 87 %02X %02X %02X %02X 0F 00",
			inv[0], inv[1], inv[2], inv[3]);
		if (!find_in(image, vote.ctor, 0x80, inv_pattern)) continue;
		const std::uint64_t vtable = *vt_store + 7 + static_cast<std::int64_t>(*vt_rel);
		const auto slots = vtable_slot_count(image, vtable);
		if (slots * 8u <= r.slots.name) continue;
		// Writer name slot: same normaliser as the reader, and the current-node pointer.
		const auto name_slot = image.u64(vtable + r.slots.name);
		const auto normaliser = name_slot ? name_slot_normaliser(image, *name_slot) : std::nullopt;
		if (!normaliser || *normaliser != r.name_normaliser) continue;
		const auto node_load = find_in(image, *name_slot, 0x60, "4C 8B 87 ? ? ? ?");
		const auto node_offset = node_load ? i32_at(image, *node_load + 3) : std::nullopt;
		if (!node_offset || *node_offset <= 0 || *node_offset >= 0x10000) continue;
		r.writer_ctor = vote.ctor;
		r.writer_begin = vote.begin;
		r.writer_end = vote.end;
		r.writer_vtable = vtable;
		r.writer_vtable_slots = slots;
		r.writer_flags_offset = *flags_offset;
		r.writer_output = *output_offset;
		r.writer_current_node = *node_offset;
		r.writer_sites = vote.count;
		r.writer_frame_size = ctor_extent(image, vote.ctor, 0x90);
		std::uint32_t best = 0;
		for (const auto& [target, count] : vote.dtor)
		{
			if (count > best) { best = count; r.writer_dtor = target; }
		}
		if (best < 2) r.writer_dtor = 0;
		break;
	}
	if (r.writer_ctor == 0) return fail("writer-sequence-not-found", "candidates=" + std::to_string(votes.size()));
	if (r.writer_dtor == 0 || !image.in_executable(r.writer_dtor)) return fail("writer-dtor-not-found");

	// 8. Typed writer slots: each body loads the current node and has the slot's
	// own value access. A mismatch names the slot that this build changed.
	std::array<std::uint8_t, 4> node{};
	std::memcpy(node.data(), &r.writer_current_node, 4);
	char node_pattern[64]{};
	std::snprintf(node_pattern, sizeof(node_pattern), "4C 8B 83 %02X %02X %02X %02X",
		node[0], node[1], node[2], node[3]);
	struct SlotShape { std::uint32_t slot; const char* access; const char* label; bool needs_node; };
	const SlotShape shapes[]{
		{r.slots.float32, "F3 0F 10 0E", "float32", true},          // movss xmm1, [rsi]
		{r.slots.boolean, "80 3E 00", "boolean", true},             // cmp byte [rsi], 0
		{r.slots.int32, "8B 16", "int32", true},                    // mov edx, [rsi]
		{r.slots.int_wide, "FF 90 08 01 00 00", "int_wide", false}, // widens through vt[+0x108]
		{r.slots.symbol, "41 B1 22", "symbol", true},               // quoted symbol text
	};
	for (const auto& shape : shapes)
	{
		if ((shape.slot + 8) / 8 > r.writer_vtable_slots) return fail("writer-slot-shape", shape.label);
		const auto function = image.u64(r.writer_vtable + shape.slot);
		if (!function || !find_in(image, *function, 0xC0, shape.access)
			|| (shape.needs_node && !find_in(image, *function, 0x40, node_pattern)))
			return fail("writer-slot-shape", shape.label);
	}
	if (r.slots.int_wide != 0)
	{
		char wide_pattern[32]{};
		std::snprintf(wide_pattern, sizeof(wide_pattern), "FF 90 %02X %02X 00 00",
			r.slots.int32 & 0xff, (r.slots.int32 >> 8) & 0xff);
		const auto function = image.u64(r.writer_vtable + r.slots.int_wide);
		if (!function || !find_in(image, *function, 0x80, wide_pattern)) return fail("writer-slot-shape", "int_wide->int32");
	}
	if (r.reader_frame_size == 0 || r.writer_frame_size == 0) return fail("archive-size-unknown");
	return r;
}

// Heap block size for an archive object: the largest offset its ctor or the
// resolver touched, rounded up with a fixed margin.
inline std::size_t archive_block_size(std::size_t touched) noexcept
{
	const std::size_t padded = touched + 0x1000;
	return (padded + 0xfff) & ~std::size_t{0xfff};
}
}
