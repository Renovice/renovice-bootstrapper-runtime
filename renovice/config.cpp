#include "config.hpp"

#include <array>
#include <atomic>
#include <fstream>
#include <limits>
#include <mutex>
#include <optional>
#include <sstream>
#include <string>

#include <winsock2.h>
#include <windows.h>

#include "../owf_console.hpp"

namespace renovice::config
{
namespace
{
constexpr std::uintmax_t maximum_config_size = 64ull * 1024ull;
constexpr std::uintmax_t maximum_source_log_size = 64ull * 1024ull * 1024ull;
constexpr unsigned int retained_source_logs = 3;

std::filesystem::path scripts_directory;
std::filesystem::path inject_directory;
std::filesystem::path log_path;
std::filesystem::path memory_log_path;
bool memory_log_failure_reported = false;
Flags active_flags;
std::optional<Flags> prepared_flags;
std::mutex state_mutex;
std::atomic<DiagnosticsMode> active_diagnostics_mode = DiagnosticsMode::off;
std::atomic_bool active_diagnostics = false;
std::atomic_bool active_memory_diagnostics = false;

void rotate_source_log_unlocked(std::size_t incoming_bytes) noexcept
{
	if (log_path.empty()) return;
	std::error_code ec;
	const auto current_size = std::filesystem::file_size(log_path, ec);
	if (ec || current_size <= maximum_source_log_size
		&& incoming_bytes <= maximum_source_log_size - current_size)
	{
		return;
	}
	for (unsigned int index = retained_source_logs; index > 1; --index)
	{
		auto source = log_path;
		source += L"." + std::to_wstring(index - 1);
		auto destination = log_path;
		destination += L"." + std::to_wstring(index);
		MoveFileExW(source.c_str(), destination.c_str(),
			MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH);
	}
	auto first = log_path;
	first += L".1";
	MoveFileExW(log_path.c_str(), first.c_str(),
		MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH);
}

const char* diagnostics_mode_name(DiagnosticsMode mode) noexcept
{
	switch (mode)
	{
	case DiagnosticsMode::errors: return "errors";
	case DiagnosticsMode::battle: return "battle";
	case DiagnosticsMode::trace: return "trace";
	default: return "off";
	}
}

const char* damage_capture_mode_name(DamageCaptureMode mode) noexcept
{
	if (mode == DamageCaptureMode::engine) return "engine";
	return mode == DamageCaptureMode::scripted ? "scripted" : "off";
}

void write_log_unlocked(std::string_view message) noexcept
{
	if (log_path.empty()) return;
	rotate_source_log_unlocked(message.size() + 2);
	const auto handle = CreateFileW(
		log_path.c_str(),
		FILE_APPEND_DATA,
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		nullptr,
		OPEN_ALWAYS,
		FILE_ATTRIBUTE_NORMAL,
		nullptr);
	if (handle == INVALID_HANDLE_VALUE) return;
	DWORD written = 0;
	WriteFile(handle, message.data(), static_cast<DWORD>(message.size()), &written, nullptr);
	static constexpr char newline[] = "\r\n";
	WriteFile(handle, newline, 2, &written, nullptr);
	CloseHandle(handle);
}

bool ensure_writable_directory(const std::filesystem::path& directory)
{
	std::error_code ec;
	std::filesystem::create_directories(directory, ec);
	if (ec || !std::filesystem::is_directory(directory, ec) || ec)
	{
		return false;
	}

	const auto probe = directory / (
		".renovice-write-probe-" + std::to_string(GetCurrentProcessId()) + ".tmp");
	const auto handle = CreateFileW(
		probe.c_str(),
		GENERIC_WRITE,
		FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
		nullptr,
		CREATE_ALWAYS,
		FILE_ATTRIBUTE_TEMPORARY | FILE_FLAG_DELETE_ON_CLOSE,
		nullptr);
	if (handle == INVALID_HANDLE_VALUE)
	{
		return false;
	}
	CloseHandle(handle);
	return true;
}

std::filesystem::path executable_directory()
{
	std::array<wchar_t, 32768> buffer{};
	const auto length = GetModuleFileNameW(nullptr, buffer.data(), static_cast<DWORD>(buffer.size()));
	if (length == 0 || length >= buffer.size())
	{
		return {};
	}
	return std::filesystem::path(std::wstring_view(buffer.data(), length)).parent_path();
}

std::filesystem::path local_appdata_fallback()
{
	std::array<wchar_t, 32768> buffer{};
	const auto length = GetEnvironmentVariableW(
		L"LOCALAPPDATA", buffer.data(), static_cast<DWORD>(buffer.size()));
	if (length == 0 || length >= buffer.size())
	{
		return {};
	}
	return std::filesystem::path(std::wstring_view(buffer.data(), length)) / L"WarframeRedirect";
}

bool read_config_file(const std::filesystem::path& path, Flags& parsed)
{
	std::error_code ec;
	if (!std::filesystem::exists(path, ec))
	{
		parsed = {};
		return !ec;
	}
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || size > maximum_config_size
		|| size > static_cast<std::uintmax_t>((std::numeric_limits<std::streamsize>::max)()))
	{
		return false;
	}
	std::string text(static_cast<std::size_t>(size), '\0');
	std::ifstream input(path, std::ios::binary);
	if (!input || (size != 0 && !input.read(text.data(), static_cast<std::streamsize>(size))))
	{
		return false;
	}
	parsed = parse(text);
	return true;
}
}

bool initialise()
{
	const auto executable = executable_directory();
	const auto primary = executable.empty()
		? std::filesystem::path{}
		: executable / L"OpenWF" / L"CustomScripts";
	if (!primary.empty() && ensure_writable_directory(primary))
	{
		scripts_directory = primary;
	}
	else
	{
		const auto fallback = local_appdata_fallback();
		if (fallback.empty() || !ensure_writable_directory(fallback))
		{
			conout << "RENOVICE configuration failed closed: neither primary nor LocalAppData CustomScripts directory is writable" << std::endl;
			return false;
		}
		scripts_directory = fallback;
		conout << "RENOVICE configuration warning: using LocalAppData fallback directory" << std::endl;
	}

	inject_directory = scripts_directory / L"Inject";
	if (!ensure_writable_directory(inject_directory))
	{
		conout << "RENOVICE configuration failed closed: Inject directory is not writable" << std::endl;
		return false;
	}
	const auto logs_directory = scripts_directory / L"Logs";
	if (!ensure_writable_directory(logs_directory))
	{
		conout << "RENOVICE configuration failed closed: Logs directory is not writable" << std::endl;
		return false;
	}
	const auto diagnostics_directory = scripts_directory / L"Diagnostics";
	if (!ensure_writable_directory(diagnostics_directory))
	{
		conout << "RENOVICE configuration failed closed: Diagnostics directory is not writable" << std::endl;
		return false;
	}
	log_path = logs_directory / L"renovice_source.log";
	SYSTEMTIME utc{};
	GetSystemTime(&utc);
	std::ostringstream memory_name;
	memory_name << "renovice_memory_" << utc.wYear << '-'
		<< utc.wMonth << '-' << utc.wDay << 'T' << utc.wHour << '-'
		<< utc.wMinute << '-' << utc.wSecond << "Z_" << GetCurrentProcessId() << ".log";
	memory_log_path = logs_directory / memory_name.str();

	if (!reload())
	{
		conout << "RENOVICE configuration failed closed: renovice.cfg is unreadable or oversized" << std::endl;
		return false;
	}
	conout << "RENOVICE configuration enabled: CustomScripts="
		<< scripts_directory.string()
		<< " Logging=" << active_flags.logging
		<< " Verbose=" << active_flags.verbose
		<< " AutoSpawn=" << active_flags.auto_spawn << " (compatibility-only)"
		<< " Diagnostics=" << (active_flags.diagnostics_master_set
			? (active_flags.diagnostics_master_enabled ? "all" : "off") : "advanced")
		<< " DiagnosticsMode=" << diagnostics_mode_name(active_flags.diagnostics_mode)
		<< " DiagnosticsMaxEvents=" << active_flags.diagnostics_max_events
		<< " DiagnosticsTarget=" << (active_flags.diagnostics_target_filter_set
			? (active_flags.diagnostics_target_filter_valid ? "filtered" : "invalid") : "all")
		<< " DiagnosticsMethod=" << (active_flags.diagnostics_method.empty()
			? "all" : active_flags.diagnostics_method)
		<< " DiagnosticsAddon=" << (active_flags.diagnostics_addon.empty()
			? "all" : active_flags.diagnostics_addon)
		<< " DiagnosticsDamageCapture="
		<< damage_capture_mode_name(active_flags.diagnostics_damage_capture)
		<< " DiagnosticsCasterStats=" << active_flags.diagnostics_caster_stats
		<< " DiagnosticsBuffs=" << active_flags.diagnostics_buffs
		<< " DiagnosticsMemory=" << active_flags.diagnostics_memory
		<< " DiagnosticsDamageSource="
		<< (active_flags.diagnostics_damage_source.empty()
			? "all" : active_flags.diagnostics_damage_source)
		<< " DiagnosticsDamageTargetType="
		<< (active_flags.diagnostics_damage_target_type.empty()
			? "all" : active_flags.diagnostics_damage_target_type)
		<< " DiagnosticsDamageType="
		<< (active_flags.diagnostics_damage_type_filter_set
			? (active_flags.diagnostics_damage_type_filter_valid
				? std::to_string(active_flags.diagnostics_damage_type)
				: "invalid")
			: "all") << std::endl;
	log("RENOVICE source configuration initialized");
	return true;
}

bool reload()
{
	if (!prepare_reload()) return false;
	commit_prepared_reload();
	return true;
}

bool prepare_reload()
{
	Flags parsed;
	if (scripts_directory.empty()
		|| !read_config_file(scripts_directory / L"renovice.cfg", parsed))
	{
		return false;
	}
	{
		std::lock_guard lock(state_mutex);
		prepared_flags = parsed;
	}
	return true;
}

void commit_prepared_reload()
{
	{
		std::lock_guard lock(state_mutex);
		if (!prepared_flags) return;
		active_flags = *prepared_flags;
		active_diagnostics_mode.store(
			active_flags.diagnostics_mode, std::memory_order_release);
		active_diagnostics.store(diagnostics_capture_enabled(active_flags),
			std::memory_order_release);
		active_memory_diagnostics.store(active_flags.diagnostics_memory,
			std::memory_order_release);
		prepared_flags.reset();
	}
	log("RENOVICE configuration reloaded");
}

void discard_prepared_reload()
{
	std::lock_guard lock(state_mutex);
	prepared_flags.reset();
}

const std::filesystem::path& custom_scripts_directory() noexcept
{
	return scripts_directory;
}

const std::filesystem::path& injection_directory() noexcept
{
	return inject_directory;
}

Flags flags()
{
	std::lock_guard lock(state_mutex);
	return active_flags;
}

DiagnosticsMode diagnostics_mode() noexcept
{
	return active_diagnostics_mode.load(std::memory_order_acquire);
}

bool diagnostics_enabled() noexcept
{
	return active_diagnostics.load(std::memory_order_acquire);
}

bool memory_diagnostics_enabled() noexcept
{
	return active_memory_diagnostics.load(std::memory_order_acquire);
}

void memory_log(std::string_view message) noexcept
{
	std::lock_guard lock(state_mutex);
	if (!active_flags.diagnostics_memory || memory_log_path.empty()) return;
	// Physical append only; no retained queue, Lua allocation or trace bridge.
	bool success = message.size() <= 16384;
	const auto handle = success ? CreateFileW(memory_log_path.c_str(), FILE_APPEND_DATA,
		FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr)
		: INVALID_HANDLE_VALUE;
	if (handle == INVALID_HANDLE_VALUE) success = false;
	else {
		DWORD written = 0;
		success = WriteFile(handle, message.data(), static_cast<DWORD>(message.size()), &written, nullptr)
			&& written == message.size();
		if (success) success = WriteFile(handle, "\r\n", 2, &written, nullptr) && written == 2;
		CloseHandle(handle);
	}
	if (!success && !memory_log_failure_reported) {
		memory_log_failure_reported = true;
		write_log_unlocked("RENOVICE VM_MEMORY build=V96 event=physical-log-write-failed subsequent-failures-suppressed=1");
		conout << "RENOVICE memory evidence error: physical append failed; see Logs directory permissions/space" << std::endl;
	}
}

void log(std::string_view message) noexcept
{
	std::lock_guard lock(state_mutex);
	if (!active_flags.logging) return;
	write_log_unlocked(message);
}

void verbose_log(std::string_view message) noexcept
{
	{
		std::lock_guard lock(state_mutex);
		if (!active_flags.verbose) return;
	}
	log(message);
}

void diagnostic_log(std::string_view message, DiagnosticsMode minimum_mode) noexcept
{
	std::lock_guard lock(state_mutex);
	if (static_cast<unsigned int>(active_flags.diagnostics_mode)
		< static_cast<unsigned int>(minimum_mode))
	{
		return;
	}
	write_log_unlocked(message);
}
}
