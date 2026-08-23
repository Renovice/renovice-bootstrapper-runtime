#pragma once

#include <cstddef>
#include <cstdint>
#include <string>
#include <string_view>

namespace renovice::replacements
{
inline constexpr std::uint64_t deployed_body_key_basis = 1469598103934665603ull;
inline constexpr std::uint64_t body_key_prime = 1099511628211ull;

// This deliberately uses the non-standard basis from the deployed custom
// loader. Existing replacement filenames depend on this exact value.
inline std::uint64_t body_key(std::string_view bytes) noexcept
{
	std::uint64_t hash = deployed_body_key_basis;
	for (const unsigned char byte : bytes)
	{
		hash ^= byte;
		hash *= body_key_prime;
	}
	return hash;
}

// The deployed convention permits a human-readable annotation after the first
// sixteen hex digits, e.g. "08fa...058f (Mallet edit).lua_B".
inline bool parse_filename_key(std::string_view stem, std::uint64_t& key) noexcept
{
	if (stem.size() < 16)
	{
		return false;
	}
	std::uint64_t value = 0;
	for (std::size_t i = 0; i != 16; ++i)
	{
		const char c = stem[i];
		std::uint8_t digit;
		if (c >= '0' && c <= '9') digit = static_cast<std::uint8_t>(c - '0');
		else if (c >= 'a' && c <= 'f') digit = static_cast<std::uint8_t>(c - 'a' + 10);
		else if (c >= 'A' && c <= 'F') digit = static_cast<std::uint8_t>(c - 'A' + 10);
		else return false;
		value = (value << 4) | digit;
	}
	if (value == 0)
	{
		return false;
	}
	key = value;
	return true;
}

// Fallback RVAs are keyed by the exact 16-byte executable ProductVersion,
// rather than the broader OpenWF game-version family. This prevents one U43
// hotfix from inheriting another U43 binary's address.
inline std::string fallback_tunable_name(std::string_view exact_build)
{
	std::string name = "renovice_undump_rva_";
	name.reserve(name.size() + exact_build.size());
	for (const char c : exact_build)
	{
		name.push_back(c == '.' ? '_' : c);
	}
	return name;
}
}
