#pragma once

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <span>
#include <string_view>

#include "replacements_core.hpp"

namespace renovice::swf
{
inline constexpr char signature_oodle_decompress[] =
	"40 55 53 56 57 41 54 41 55 41 56 41 57 48 81 EC C8 00 00 00 "
	"48 8D 6C 24 60 48 C7 45 40 FE FF FF FF 48 8B 05";
inline constexpr char signature_parser_u44[] = "48 89 5C 24 18 55 56 57 48 81 EC 80 00 00 00 48 89 91 68 01 00 00 48 8B F9 48 8B 42 30";
inline constexpr char signature_parser[] =
	"48 89 5C 24 20 55 56 57 48 81 EC 90 00 00 00 48 8B 05 ? ? ? ? "
	"48 33 C4 48 89 84 24 88 00 00 00 48 89 91 68 01 00 00 48 8B F9 "
	"48 8B 42 30 48";

struct TocRule
{
	std::uint64_t cache_offset = 0;
	std::uint32_t compressed_size = 0;
	std::uint32_t stock_decompressed_size = 0;
	std::uint32_t replacement_capacity = 0;
};

inline bool is_fws(std::span<const unsigned char> bytes) noexcept
{
	return bytes.size() >= 8 && bytes[0] == 'F' && bytes[1] == 'W' && bytes[2] == 'S';
}

inline std::uint32_t little_u32(const unsigned char* bytes) noexcept
{
	std::uint32_t value;
	std::memcpy(&value, bytes, sizeof(value));
	return value;
}

inline bool valid_replacement(std::span<const unsigned char> bytes) noexcept
{
	return is_fws(bytes)
		&& little_u32(bytes.data() + 4) == bytes.size()
		&& bytes.size() <= 16ull * 1024ull * 1024ull;
}

inline bool patch_toc_buffer(std::span<unsigned char> bytes, const TocRule& rule) noexcept
{
	if (rule.cache_offset == 0 || rule.compressed_size == 0
		|| rule.stock_decompressed_size == 0
		|| rule.replacement_capacity <= rule.stock_decompressed_size)
	{
		return false;
	}
	for (std::size_t offset = 0; offset + 24 <= bytes.size(); offset += 4)
	{
		std::uint64_t cache_offset;
		std::uint32_t compressed;
		std::uint32_t decompressed;
		std::memcpy(&cache_offset, bytes.data() + offset, sizeof(cache_offset));
		std::memcpy(&compressed, bytes.data() + offset + 16, sizeof(compressed));
		std::memcpy(&decompressed, bytes.data() + offset + 20, sizeof(decompressed));
		if (cache_offset == rule.cache_offset
			&& compressed == rule.compressed_size
			&& decompressed == rule.stock_decompressed_size)
		{
			std::memcpy(bytes.data() + offset + 20,
				&rule.replacement_capacity, sizeof(rule.replacement_capacity));
			return true;
		}
	}
	return false;
}

inline bool parse_key(std::string_view filename_stem, std::uint64_t& key) noexcept
{
	return replacements::parse_filename_key(filename_stem, key);
}
}
