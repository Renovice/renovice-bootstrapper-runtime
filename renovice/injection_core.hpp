#pragma once

#include <cctype>
#include <cstdint>
#include <string_view>

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

enum class ScriptKind
{
	Ordinary,
	ExperimentalPersistent,
	ExperimentalSpawn,
};

inline ScriptKind classify_script(std::string_view filename) noexcept
{
	if (filename.find(".spawn") != std::string_view::npos)
	{
		return ScriptKind::ExperimentalSpawn;
	}
	if (filename.find(".persist") != std::string_view::npos)
	{
		return ScriptKind::ExperimentalPersistent;
	}
	return ScriptKind::Ordinary;
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
}
