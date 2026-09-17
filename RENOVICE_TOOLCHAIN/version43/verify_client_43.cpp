#include <array>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include "../../renovice/injection_core.hpp"
#include "../../renovice/vm_stack_write.hpp"
#include "../../renovice/riven_core.hpp"
#include "../../renovice/swf_core.hpp"

namespace
{
struct Pattern
{
	std::vector<std::uint8_t> bytes;
	std::vector<bool> wildcard;
};

Pattern parse_pattern(std::string_view text)
{
	Pattern out;
	for (std::size_t pos = 0; pos < text.size();)
	{
		while (pos < text.size() && text[pos] == ' ')
		{
			++pos;
		}
		if (pos == text.size())
		{
			break;
		}
		const auto end = text.find(' ', pos);
		const auto token = text.substr(pos, end == std::string_view::npos ? text.size() - pos : end - pos);
		if (token == "?" || token == "??")
		{
			out.bytes.push_back(0);
			out.wildcard.push_back(true);
		}
		else
		{
			if (token.size() != 2)
			{
				throw std::runtime_error("invalid pattern token");
			}
			const auto nibble = [](char c) -> std::uint8_t
			{
				if (c >= '0' && c <= '9') return static_cast<std::uint8_t>(c - '0');
				if (c >= 'A' && c <= 'F') return static_cast<std::uint8_t>(c - 'A' + 10);
				if (c >= 'a' && c <= 'f') return static_cast<std::uint8_t>(c - 'a' + 10);
				throw std::runtime_error("invalid pattern hex digit");
			};
			out.bytes.push_back(static_cast<std::uint8_t>((nibble(token[0]) << 4) | nibble(token[1])));
			out.wildcard.push_back(false);
		}
		pos = end == std::string_view::npos ? text.size() : end + 1;
	}
	return out;
}

std::vector<std::size_t> scan(const std::vector<std::uint8_t>& data, const Pattern& pattern)
{
	std::vector<std::size_t> hits;
	if (pattern.bytes.empty() || pattern.bytes.size() > data.size())
	{
		return hits;
	}
	for (std::size_t pos = 0; pos <= data.size() - pattern.bytes.size(); ++pos)
	{
		std::size_t i = 0;
		for (; i != pattern.bytes.size(); ++i)
		{
			if (!pattern.wildcard[i] && data[pos + i] != pattern.bytes[i])
			{
				break;
			}
		}
		if (i == pattern.bytes.size())
		{
			hits.push_back(pos);
		}
	}
	return hits;
}

std::uint32_t rol32(std::uint32_t value, unsigned bits)
{
	return static_cast<std::uint32_t>((value << bits) | (value >> (32 - bits)));
}

std::uint32_t wf_hash(std::string_view name)
{
	std::uint32_t hash = 0x7e5af8e9u;
	for (const unsigned char c : name)
	{
		hash ^= c;
		hash *= 16777619u;
	}
	return rol32(~hash, 17);
}

std::string native_pattern(std::string_view name)
{
	const auto hash = wf_hash(name);
	char text[24]{};
	std::snprintf(
		text,
		sizeof(text),
		"%02X %02X %02X %02X 00 00 00 00",
		hash & 0xffu,
		(hash >> 8) & 0xffu,
		(hash >> 16) & 0xffu,
		(hash >> 24) & 0xffu
	);
	return text;
}

bool expect_matches(
	const std::vector<std::uint8_t>& data,
	std::string_view name,
	std::string_view pattern,
	std::size_t minimum,
	std::size_t maximum
)
{
	const auto hits = scan(data, parse_pattern(pattern));
	const bool pass = hits.size() >= minimum && hits.size() <= maximum;
	std::cout << (pass ? "PASS" : "FAIL") << '\t' << name << "\tmatches=" << hits.size();
	if (!hits.empty())
	{
		std::cout << " first_raw=0x" << std::hex << hits.front() << std::dec;
	}
	std::cout << '\n';
	return pass;
}

std::uint32_t read_u32(const std::vector<std::uint8_t>& data, std::size_t offset)
{
	if (offset + sizeof(std::uint32_t) > data.size())
	{
		throw std::runtime_error("read outside executable");
	}
	std::uint32_t value;
	std::memcpy(&value, data.data() + offset, sizeof(value));
	return value;
}
}

int main(int argc, char** argv)
{
	if (argc != 4)
	{
		std::cerr << "usage: verify_client_43.exe <Warframe.x64.exe> <undump-raw-hex> <undump-rva-hex>\n";
		return 2;
	}
	const auto expected_undump_raw = static_cast<std::size_t>(std::stoull(argv[2], nullptr, 16));
	const auto expected_undump_rva = static_cast<std::size_t>(std::stoull(argv[3], nullptr, 16));

	std::ifstream stream(argv[1], std::ios::binary);
	if (!stream)
	{
		std::cerr << "unable to open executable\n";
		return 2;
	}
	std::vector<std::uint8_t> data(
		(std::istreambuf_iterator<char>(stream)),
		std::istreambuf_iterator<char>()
	);

	bool pass = true;
	const auto exact = [&](std::string_view name, std::string_view pattern)
	{
		pass &= expect_matches(data, name, pattern, 1, 1);
	};

	exact("GameHttpRequest caller", "48 8D 53 18 E8 ? ? ? ? 48 8D 8B");
	exact("encrypted string append", "40 53 57 41 54 48 83 EC 20 44 8B E2 48 8B F9 48 85 C9");
	exact("encrypted string discharge", "48 8B C4 48 89 50 10 53 55 41 56 48 83 EC 50 48 89 70 18");
	exact("Curl resolver", "48 89 5C 24 20 55 56 57 41 54 41 55 41 56 41 57 48 8D 6C 24 ? 48 81 EC ? ? ? ? 48 8B 05 ? ? ? ? 48 33 C4 48 89 45 0F 48 8B 45 7F 48 8B F9");
	exact("SSL verify caller", "49 8B D5 48 8B CB E8 ? ? ? ? 85 C0 7F");
	exact("Curl verify host", "40 53 55 56 57 41 54 41 55 41 57 48 83 EC 70 48 8B 05 ? ? ? ? 48 33 C4 48 89 44 24 60 49 8B 18 4C 8B F9");
	exact("worldstate integrity", "48 89 5C 24 ? 48 89 74 24 ? 48 89 7C 24 ? 55 41 56 41 57 48 8B EC 48 83 EC ? 48 8B 05 ? ? ? ? 48 33 C4 48 89 45 ? 48 8B F9 84 D2");
	exact("Lua set-global-by-hash", "49 8B 4E 20 BA ? ? ? ? E8 ? ? ? ? 49 8B 4E 20 E8");
	exact("Lua set-global", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 F6 41 01 04 48 8B FA");
	exact("inject module loader", renovice::injection::signature_module_loader);
	exact("inject name-key builder", renovice::injection::signature_name_key_builder);
	exact("inject getfield", renovice::injection::signature_getfield);
	exact("inject setfield", renovice::injection::signature_setfield);
	exact("inject checkstack", renovice::injection::signature_checkstack);
	exact("U43 native stack GC barrier", renovice::injection::signature_gc_barrierback_u43);
	exact("U43 native lua_pushvalue", renovice::injection::signature_lua_pushvalue_u43);
	exact("inject game allocator", renovice::injection::signature_game_allocator);
	exact("inject protected call", renovice::injection::signature_protected_call);
	exact("inject Luau VM execute", renovice::injection::signature_vm_execute);
	exact("SWF Oodle decompressor", renovice::swf::signature_oodle_decompress);
	exact("SWF parser boundary", renovice::swf::signature_parser);
	exact("Riven GFx dispatcher", renovice::riven::signature_gfx_dispatch);
	exact("Riven SetStringVariable", renovice::riven::signature_set_string_variable);
	exact("Riven movie argument", renovice::riven::signature_movie_argument);
	exact("Riven string argument", renovice::riven::signature_string_argument);
	exact("Riven type argument", renovice::riven::signature_type_argument);
	const auto undump_pattern = parse_pattern("40 53 55 56 57 41 55 41 56 41 57 48 81 EC F0 01 00 00 48 8B 05 ? ? ? ? 48 33");
	const auto undump_hits = scan(data, undump_pattern);
	const bool undump_pass = undump_hits.size() == 1 && undump_hits.front() == expected_undump_raw;
	std::cout << (undump_pass ? "PASS" : "FAIL")
		<< "\tDE Luau undump\tmatches=" << undump_hits.size()
		<< " raw_offset=0x" << std::hex << (undump_hits.empty() ? 0 : undump_hits.front())
		<< " expected_raw=0x" << expected_undump_raw
		<< " expected_rva=0x" << expected_undump_rva << std::dec << '\n';
	pass &= undump_pass;
	exact("pause allowed", "48 89 5C 24 10 48 89 74 24 18 57 48 81 EC 80 00 00 00 48 8B 05 ? ? ? ? 48 33 C4 48 89 44 24 ? 48 8B D9 E8 ? ? ? ? 48 8B C8");

	for (const auto name : {
		"UpdateFlashMarkers",
		"GetStringVariable",
		"OpenWebBrowser",
		"excludedFromSimulacrum",
	})
	{
		exact(std::string("native ") + name, native_pattern(name));
	}

	const auto config_pair =
		native_pattern("GetConfigBool")
		+ " ? ? ? ? ? ? ? ? "
		+ native_pattern("SetConfigBool");
	pass &= expect_matches(data, "native GetConfigBool/SetConfigBool pair", config_pair, 1, 8);

	const auto profile_pattern = parse_pattern("40 55 53 56 48 8D AC 24 ? ? ? ? 48 81 EC ? ? ? ? 48 8B 05 ? ? ? ? 48 33 C4 48 89 85 ? ? ? ? 48 8D 99 ? ? ? ? 48 8B F1");
	const auto profile_hits = scan(data, profile_pattern);
	const auto profile_value = profile_hits.size() == 1 ? read_u32(data, profile_hits.front() + 0x27) : 0;
	const bool profile_pass = profile_hits.size() == 1 && profile_value == 0x2c8;
	std::cout << (profile_pass ? "PASS" : "FAIL")
		<< "\tprofile-dir displacement\tmatches=" << profile_hits.size()
		<< " value=0x" << std::hex << profile_value << std::dec << '\n';
	pass &= profile_pass;

	const auto enum_pattern = parse_pattern("49 8D 43 D8 49 89 43 F0 E8 ? ? ? ? 48 8D 0D ? ? ? ? 48 83 C4 58 E9");
	const auto enum_hits = scan(data, enum_pattern);
	bool enum_pass = !enum_hits.empty();
	std::int64_t first_target = -1;
	for (const auto hit : enum_hits)
	{
		const auto rel = static_cast<std::int32_t>(read_u32(data, hit + 9));
		const auto target = static_cast<std::int64_t>(hit + 13) + rel;
		if (first_target == -1)
		{
			first_target = target;
		}
		else if (target != first_target)
		{
			enum_pass = false;
		}
	}
	std::cout << (enum_pass ? "PASS" : "FAIL")
		<< "\tregister-enum callsites\tmatches=" << enum_hits.size()
		<< " unique_targets=" << (enum_pass ? (enum_hits.empty() ? 0 : 1) : 2) << '\n';
	pass &= enum_pass;

	std::cout << (pass ? "V43 CLIENT SCAN PASS" : "V43 CLIENT SCAN FAIL") << '\n';
	return pass ? 0 : 1;
}
