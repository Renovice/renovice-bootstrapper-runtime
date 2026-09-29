#pragma once

#include <cctype>
#include <cstddef>
#include <charconv>
#include <cstdint>
#include <string>
#include <string_view>

namespace renovice::config
{
enum class DiagnosticsMode : std::uint8_t
{
	off = 0,
	errors = 1,
	battle = 2,
	trace = 3,
};

enum class DamageCaptureMode : std::uint8_t
{
	off = 0,
	scripted = 1,
	engine = 2,
};

inline constexpr std::uint64_t default_diagnostics_max_events = 4096;
inline constexpr std::uint64_t maximum_diagnostics_max_events = 65536;

struct Flags
{
	bool operator==(const Flags&) const = default;
	bool logging = false;
	bool verbose = false;
	bool auto_spawn = false;
	// Diagnostics is the optional master switch. When the key is absent, the
	// detailed legacy keys retain their exact behavior for research packages.
	// When present, true selects every bounded diagnostic lane and false masks
	// every lane without destroying its filters.
	bool diagnostics_master_set = false;
	bool diagnostics_master_enabled = false;
	// Compatibility/effective mirror: true only when full trace mode is active.
	bool diagnostics = false;
	DiagnosticsMode diagnostics_mode = DiagnosticsMode::off;
	std::uint64_t diagnostics_max_events = default_diagnostics_max_events;
	bool diagnostics_target_filter_set = false;
	bool diagnostics_target_filter_valid = true;
	std::uint64_t diagnostics_target_key = 0;
	std::string diagnostics_method;
	std::string diagnostics_addon;
	DamageCaptureMode diagnostics_damage_capture = DamageCaptureMode::off;
	bool diagnostics_caster_stats = false;
	bool diagnostics_buffs = false;
	bool diagnostics_memory = false;
	std::string diagnostics_damage_source;
	std::string diagnostics_damage_target_type;
	bool diagnostics_damage_type_filter_set = false;
	bool diagnostics_damage_type_filter_valid = true;
	std::int32_t diagnostics_damage_type = -1;
	// SCRIPT SETTINGS layout (2026-09-30). false (default): the proven-safe
	// single flat GenericSettings list with TITLE sections. true: nested
	// package -> section pages pushed from BUTTON rows; enable only after the
	// Phase 0 probe proves gate N-1 (nested GenericSettings) live.
	bool settings_menu_nested = false;
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

inline DiagnosticsMode diagnostics_mode_value(std::string_view value) noexcept
{
	if (value == "trace" || enabled_value(value)) return DiagnosticsMode::trace;
	if (value == "battle" || value == "combat") return DiagnosticsMode::battle;
	if (value == "errors" || value == "error") return DiagnosticsMode::errors;
	return DiagnosticsMode::off;
}

inline DamageCaptureMode damage_capture_mode_value(std::string_view value) noexcept
{
	if (value == "engine" || value == "native" || value == "all") return DamageCaptureMode::engine;
	return value == "scripted" || value == "lua" || value == "luau"
		|| value == "all-scripted" || enabled_value(value)
		? DamageCaptureMode::scripted : DamageCaptureMode::off;
}

inline bool diagnostics_capture_enabled(const Flags& flags) noexcept
{
	return flags.diagnostics_mode != DiagnosticsMode::off
		|| flags.diagnostics_damage_capture != DamageCaptureMode::off
		|| flags.diagnostics_caster_stats
		|| flags.diagnostics_buffs
		|| flags.diagnostics_memory;
}

inline void apply_diagnostics_master(Flags& flags) noexcept
{
	if (flags.diagnostics_master_set)
	{
		if (flags.diagnostics_master_enabled)
		{
			flags.diagnostics_mode = DiagnosticsMode::trace;
			flags.diagnostics_damage_capture = DamageCaptureMode::engine;
			flags.diagnostics_caster_stats = true;
			flags.diagnostics_buffs = true;
			flags.diagnostics_memory = true;
		}
		else
		{
			flags.diagnostics_mode = DiagnosticsMode::off;
			flags.diagnostics_damage_capture = DamageCaptureMode::off;
			flags.diagnostics_caster_stats = false;
			flags.diagnostics_buffs = false;
			flags.diagnostics_memory = false;
		}
	}
	flags.diagnostics = flags.diagnostics_mode == DiagnosticsMode::trace;
}

inline void set_diagnostics_damage_type_filter(
	Flags& flags, std::string_view value) noexcept
{
	flags.diagnostics_damage_type_filter_set = !value.empty();
	flags.diagnostics_damage_type_filter_valid = true;
	flags.diagnostics_damage_type = -1;
	if (value.empty()) return;
	std::int32_t parsed = -1;
	const auto conversion = std::from_chars(
		value.data(), value.data() + value.size(), parsed, 10);
	flags.diagnostics_damage_type_filter_valid = conversion.ec == std::errc{}
		&& conversion.ptr == value.data() + value.size()
		&& parsed >= 0 && parsed <= 19;
	if (flags.diagnostics_damage_type_filter_valid)
		flags.diagnostics_damage_type = parsed;
}

inline std::uint64_t diagnostics_event_limit_value(std::string_view value) noexcept
{
	std::uint64_t parsed = 0;
	const auto conversion = std::from_chars(
		value.data(), value.data() + value.size(), parsed, 10);
	if (conversion.ec != std::errc{} || conversion.ptr != value.data() + value.size())
	{
		return default_diagnostics_max_events;
	}
	if (parsed == 0) return 1;
	return parsed > maximum_diagnostics_max_events
		? maximum_diagnostics_max_events : parsed;
}

inline void set_diagnostics_target_filter(Flags& flags, std::string_view value) noexcept
{
	flags.diagnostics_target_filter_set = !value.empty();
	flags.diagnostics_target_filter_valid = true;
	flags.diagnostics_target_key = 0;
	if (value.empty()) return;
	if (value.size() > 2 && value[0] == '0' && value[1] == 'x') value.remove_prefix(2);
	if (value.empty() || value.size() > 16)
	{
		flags.diagnostics_target_filter_valid = false;
		return;
	}
	const auto conversion = std::from_chars(
		value.data(), value.data() + value.size(), flags.diagnostics_target_key, 16);
	flags.diagnostics_target_filter_valid = conversion.ec == std::errc{}
		&& conversion.ptr == value.data() + value.size()
		&& flags.diagnostics_target_key != 0;
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
				else if (key == "diagnostics")
				{
					result.diagnostics_master_set = true;
					result.diagnostics_master_enabled = enabled_value(value);
				}
				else if (key == "diagnosticsmode")
				{
					result.diagnostics_mode = diagnostics_mode_value(value);
					result.diagnostics = result.diagnostics_mode == DiagnosticsMode::trace;
				}
				else if (key == "diagnosticsmaxevents")
				{
					result.diagnostics_max_events = diagnostics_event_limit_value(value);
				}
				else if (key == "diagnosticstarget")
				{
					set_diagnostics_target_filter(result, value);
				}
				else if (key == "diagnosticsmethod") result.diagnostics_method = value;
				else if (key == "diagnosticsaddon") result.diagnostics_addon = value;
				else if (key == "diagnosticsdamagecapture")
				{
					result.diagnostics_damage_capture = damage_capture_mode_value(value);
				}
				else if (key == "diagnosticsdamagesource")
				{
					result.diagnostics_damage_source = value;
				}
				else if (key == "diagnosticscasterstats") result.diagnostics_caster_stats = enabled_value(value);
				else if (key == "diagnosticsbuffs") result.diagnostics_buffs = enabled_value(value);
				else if (key == "diagnosticsmemory") result.diagnostics_memory = enabled_value(value);
				else if (key == "diagnosticsdamagetargettype")
				{
					result.diagnostics_damage_target_type = value;
				}
				else if (key == "diagnosticsdamagetype")
				{
					set_diagnostics_damage_type_filter(result, value);
				}
				else if (key == "settingsmenunested") result.settings_menu_nested = enabled_value(value);
			}
		}
		if (line_end == std::string_view::npos) break;
		offset = line_end + 1;
		if (offset < text.size() && text[line_end] == '\r' && text[offset] == '\n') ++offset;
	}
	apply_diagnostics_master(result);
	return result;
}

// ---------------------------------------------------------------------------
// Source-log buffering policy (2026-09-29). Pure so the offline gate can pin it.
// Diagnostic lines are buffered in a bounded buffer and flushed when full or
// after the interval; operational lines always flush (write-through).
// ---------------------------------------------------------------------------
inline constexpr std::size_t source_log_buffer_bytes = 64u * 1024u;
inline constexpr std::uint64_t source_log_flush_interval_ms = 250;

inline constexpr bool source_log_line_fits_buffer(
	std::size_t buffered, std::size_t line_bytes, std::size_t capacity) noexcept
{
	return line_bytes <= capacity && buffered <= capacity - line_bytes;
}

inline constexpr bool source_log_flush_due(
	bool buffered_line,
	std::size_t buffered,
	std::size_t capacity,
	std::uint64_t now_ms,
	std::uint64_t last_flush_ms,
	std::uint64_t interval_ms) noexcept
{
	return !buffered_line || buffered >= capacity
		|| now_ms < last_flush_ms || now_ms - last_flush_ms >= interval_ms;
}

inline constexpr bool source_log_rotation_required(
	std::uint64_t file_size,
	std::size_t buffered,
	std::size_t incoming,
	std::uint64_t maximum) noexcept
{
	const std::uint64_t pending = file_size + buffered;
	return pending < file_size || pending > maximum || incoming > maximum - pending;
}
}
