#pragma once

#include <cstdint>
#include <filesystem>
#include <string>
#include <string_view>
#include <system_error>

namespace renovice::riven
{
// Presence of the optional gate file CustomScripts/riven_lock.cfg (R5,
// 2026-09-30). Absent is the normal "Riven lock off" state, not an error:
// MSVC std::filesystem::is_regular_file(path, ec) sets ec (ERROR_FILE_NOT_FOUND
// = 2, ERROR_PATH_NOT_FOUND = 3) for a missing file, and the F9 transaction
// treated that as a failed gate read, so every F9 rolled back ("F9 Riven gate
// reload rejected", live 2026-09-30) while riven_lock.cfg was absent.
enum class GateFile { Absent, Present, Unreadable };

inline GateFile classify_gate_file(const std::filesystem::path& path, std::error_code& error)
{
	error.clear();
	const auto status = std::filesystem::status(path, error);
	if (status.type() == std::filesystem::file_type::not_found)
	{
		error.clear();
		return GateFile::Absent;
	}
	if (error) return GateFile::Unreadable;
	return status.type() == std::filesystem::file_type::regular ? GateFile::Present : GateFile::Absent;
}

inline constexpr char signature_gfx_dispatch[] =
	"48 89 5C 24 18 55 56 57 41 54 41 55 41 56 41 57 48 8D AC 24 "
	"E0 FE FF FF 48 81 EC 20 02 00 00 48 8B 05 ? ? ? ? 48 33 C4 48 89 "
	"85 10 01 00 00 80 B9 A5 01 00 00 00 4C";
inline constexpr char signature_set_string_variable[] =
	"48 89 5C 24 08 48 89 74 24 10 48 89 7C 24 18 41 56 48 83 EC 20 "
	"48 8B F1 E8 ? ? ? ? 48 8B CE E8 ? ? ? ? BA 02 00 00 00 48 8B CE "
	"4C 8B F0 E8 ? ? ? ? 4C 8D 05 ? ? ? ? BA 03 00 00 00 48 8B CE 48 "
	"8B F8 E8 ? ? ? ? BA 04 00 00 00 48 8B CE 8B D8 E8 ? ? ? ? 49 8B "
	"0E 4C 8B";
inline constexpr char signature_movie_argument[] =
	"40 53 48 83 EC 20 48 8B 41 10 48 8B D9 48 8B 10 48 8B 42 18 48 "
	"8B 00 48 85 C0 74 ? 48 83 C4 20 5B C3 48 8D 15 ? ? ? ? E8 ? ? ? ? 48 8B";
inline constexpr char signature_string_argument[] =
	"48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 48 8B 41 10 48 8B "
	"D9 48 63 FA 48 8B F7 48 C1 E6 04 48 83 C6 F0 48 03 C6 8B 48 0C "
	"83 F9 06 74 ? 85";
inline constexpr char signature_type_argument_u44[] = "48 89 5C 24 10 48 89 74 24 18 57 48 83 EC 20 48 8B F9 48 63 DA 48 8B CB 49 8B F0 48 03 C9 48 8B 47 10 44 8B 4C C8 FC";
inline constexpr char signature_type_argument[] =
	"40 53 56 57 48 83 EC 40 48 8B 05 ? ? ? ? 48 33 C4 48 89 44 24 "
	"30 48 8B 41 10 49 8B F0 48 83 C0 F0 48 63 FA 4C 8B CF 48 8B D9 "
	"49 C1 E1 04 49";

inline bool parse_lock_href(std::string_view href, unsigned& index) noexcept
{
	constexpr std::string_view prefix = "#onHyperlinkPressed:lock";
	if (!href.starts_with(prefix)) return false;
	auto digits = href.substr(prefix.size());
	if (digits.empty() || digits.size() > 2) return false;
	unsigned value = 0;
	for (const auto byte : digits)
	{
		if (byte < '0' || byte > '9') return false;
		value = value * 10 + static_cast<unsigned>(byte - '0');
	}
	if (value >= 32) return false;
	index = value;
	return true;
}

inline bool is_definite_non_riven(std::string_view text) noexcept
{
	for (const auto token : {
		"Ability", "Armor", "Health", "Shield", "Energy", "Tau", "Railjack",
		"Artillery", "Parkour", "Sprint", "pickups", "Enhance mods"})
	{
		if (text.find(token) != std::string_view::npos) return true;
	}
	return false;
}

inline bool looks_like_riven_stats(std::string_view text) noexcept
{
	if (is_definite_non_riven(text)) return false;
	for (const auto token : {
		":", "Stacks", "chance to", "reveal", "Reveal", "Unveil", "Equip"})
	{
		if (text.find(token) != std::string_view::npos) return false;
	}
	return text.find('%') != std::string_view::npos
		|| text.find("x0") != std::string_view::npos
		|| text.find("x1") != std::string_view::npos
		|| text.find("x2") != std::string_view::npos
		|| text.find("x3") != std::string_view::npos;
}

inline std::string build_wrap(std::string_view input, std::uint32_t locked_mask)
{
	std::string output = "<p><font size=\"19\">";
	output.reserve(input.size() + 512);
	unsigned index = 0;
	bool in_segment = false;
	for (const auto byte : input)
	{
		if (static_cast<unsigned char>(byte) < 0x20)
		{
			if (in_segment)
			{
				output.append("</a>");
				in_segment = false;
			}
			output.push_back(byte);
			continue;
		}
		if (!in_segment)
		{
			const bool locked = index < 32 && ((locked_mask >> index) & 1u) != 0;
			output.append("<a color=\"");
			output.append(locked ? "#FF0000" : "#A785C9");
			output.append("\" hovercolor=\"");
			output.append(locked ? "#FF5555" : "#FFFFFF");
			output.append("\" href=\"#onHyperlinkPressed:lock");
			output.append(std::to_string(index));
			output.append("\">");
			++index;
			in_segment = true;
		}
		output.push_back(byte);
	}
	if (in_segment) output.append("</a>");
	output.append("</font></p>");
	return output;
}

inline std::string locked_indices_json(std::uint32_t mask)
{
	std::string output = "{\"indices\":[";
	bool first = true;
	for (unsigned bit = 0; bit != 32; ++bit)
	{
		if (((mask >> bit) & 1u) == 0) continue;
		if (!first) output.push_back(',');
		output.append(std::to_string(bit));
		first = false;
	}
	output.append("]}");
	return output;
}
}
