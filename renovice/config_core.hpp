#pragma once

#include <cctype>
#include <string>
#include <string_view>

namespace renovice::config
{
struct Flags
{
	bool logging = false;
	bool verbose = false;
	bool auto_spawn = false;
};

inline std::string trim_ascii(std::string_view value)
{
	std::size_t begin = 0;
	while (begin != value.size()
		&& std::isspace(static_cast<unsigned char>(value[begin])))
	{
		++begin;
	}
	std::size_t end = value.size();
	while (end != begin
		&& std::isspace(static_cast<unsigned char>(value[end - 1])))
	{
		--end;
	}
	return std::string(value.substr(begin, end - begin));
}

inline std::string ascii_lower(std::string_view value)
{
	std::string lowered;
	lowered.reserve(value.size());
	for (const auto byte : value)
	{
		lowered.push_back(static_cast<char>(
			std::tolower(static_cast<unsigned char>(byte))));
	}
	return lowered;
}

inline bool enabled_value(std::string_view value) noexcept
{
	return value == "true" || value == "1" || value == "on" || value == "yes";
}

inline Flags parse(std::string_view text)
{
	Flags result;
	std::size_t offset = 0;
	while (offset <= text.size())
	{
		const auto line_end = text.find_first_of("\r\n", offset);
		const auto raw_line = text.substr(
			offset,
			line_end == std::string_view::npos ? text.size() - offset : line_end - offset);
		auto line = trim_ascii(raw_line);
		if (!line.empty() && line.front() != '#' && line.front() != ';')
		{
			const auto equals = line.find('=');
			if (equals != std::string::npos)
			{
				const auto key = ascii_lower(trim_ascii(std::string_view(line).substr(0, equals)));
				const auto value = ascii_lower(trim_ascii(std::string_view(line).substr(equals + 1)));
				if (key == "logging") result.logging = enabled_value(value);
				else if (key == "verbose") result.verbose = enabled_value(value);
				else if (key == "autospawn") result.auto_spawn = enabled_value(value);
			}
		}
		if (line_end == std::string_view::npos) break;
		offset = line_end + 1;
		if (offset < text.size() && text[line_end] == '\r' && text[offset] == '\n') ++offset;
	}
	return result;
}
}
