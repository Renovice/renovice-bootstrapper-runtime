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
	ManagedAddon,
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
	if (ascii_icontains(filename, ".addon"))
	{
		return ScriptKind::ManagedAddon;
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

inline bool consume_f9_edge(bool down, bool allow_reload, bool& was_down) noexcept
{
	const bool pressed = allow_reload && down && !was_down;
	// Always record both press and release, including while Warframe is not the
	// foreground window. Otherwise an alt-tab after F9 can leave the latch stuck
	// in the down state and silently suppress the next legitimate press.
	was_down = down;
	return pressed;
}
}
