#include "config.hpp"

#include <array>
#include <atomic>
#include <cstring>
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

// Source-log writer (2026-09-29, Mallet lag audit). The previous writer ran
// CreateFileW + 2x WriteFile + CloseHandle for EVERY line on the game thread;
// a traced Mallet fight wrote thousands of lines in 20 s. Now:
// - one append handle stays open (reopened after rotation, retried at most
//   once per second after an open failure);
// - the file size is tracked in memory, so rotation needs no per-line stat;
// - diagnostic lines go to a bounded 64 KiB buffer that is flushed when full,
//   at least every 250 ms (checked on each write), before every operational
//   line (ordering is preserved), on process detach and from the near-null
//   fault recorder (try-lock, best effort);
// - operational lines (config::log) are written through immediately, so load,
//   F9 and error evidence is never held in memory.
// Pure policy: config_core.hpp (SourceLogBufferPolicy).
HANDLE log_handle = INVALID_HANDLE_VALUE;
std::uint64_t log_file_size = 0;
ULONGLONG log_open_retry_ms = 0;
ULONGLONG log_last_flush_ms = 0;
std::array<char, source_log_buffer_bytes> log_buffer{};
std::size_t log_buffered = 0;

void close_log_handle_unlocked() noexcept
{
	if (log_handle != INVALID_HANDLE_VALUE)
	{
		CloseHandle(log_handle);
		log_handle = INVALID_HANDLE_VALUE;
	}
}

bool open_log_handle_unlocked() noexcept
{
	if (log_handle != INVALID_HANDLE_VALUE) return true;
	if (log_path.empty()) return false;
	const auto now = GetTickCount64();
	if (log_open_retry_ms != 0 && now < log_open_retry_ms) return false;
	log_handle = CreateFileW(
		log_path.c_str(),
		FILE_APPEND_DATA,
		FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
		nullptr,
		OPEN_ALWAYS,
		FILE_ATTRIBUTE_NORMAL,
		nullptr);
	if (log_handle == INVALID_HANDLE_VALUE)
	{
		log_open_retry_ms = now + 1000;
		return false;
	}
	log_open_retry_ms = 0;
	LARGE_INTEGER size{};
	log_file_size = GetFileSizeEx(log_handle, &size)
		? static_cast<std::uint64_t>(size.QuadPart) : 0;
	return true;
}

void write_raw_unlocked(const char* data, std::size_t size) noexcept
{
	if (size == 0 || !open_log_handle_unlocked()) return;
	DWORD written = 0;
	if (WriteFile(log_handle, data, static_cast<DWORD>(size), &written, nullptr))
		log_file_size += written;
}

void flush_log_unlocked() noexcept
{
	if (log_buffered != 0)
	{
		write_raw_unlocked(log_buffer.data(), log_buffered);
		log_buffered = 0;
	}
	log_last_flush_ms = GetTickCount64();
}

void rotate_open_log_unlocked(std::size_t incoming_bytes) noexcept
{
	if (!source_log_rotation_required(
		log_file_size, log_buffered, incoming_bytes, maximum_source_log_size))
	{
		return;
	}
	flush_log_unlocked();
	close_log_handle_unlocked();
	rotate_source_log_unlocked(incoming_bytes);
	log_file_size = 0;
}

void write_log_unlocked(std::string_view message, bool buffered = false) noexcept
{
	if (log_path.empty()) return;
	if (log_handle == INVALID_HANDLE_VALUE && !open_log_handle_unlocked()) return;
	const auto line_bytes = message.size() + 2;
	rotate_open_log_unlocked(line_bytes);
	static constexpr char newline[] = "\r\n";
	if (!source_log_line_fits_buffer(log_buffered, line_bytes, log_buffer.size()))
	{
		flush_log_unlocked();
	}
	if (line_bytes > log_buffer.size())
	{
		// Oversized line: write it directly after the flushed buffer.
		write_raw_unlocked(message.data(), message.size());
		write_raw_unlocked(newline, 2);
		log_last_flush_ms = GetTickCount64();
		return;
	}
	std::memcpy(log_buffer.data() + log_buffered, message.data(), message.size());
	log_buffered += message.size();
	std::memcpy(log_buffer.data() + log_buffered, newline, 2);
	log_buffered += 2;
	if (source_log_flush_due(buffered, log_buffered, log_buffer.size(),
		GetTickCount64(), log_last_flush_ms, source_log_flush_interval_ms))
	{
		flush_log_unlocked();
	}
}

// Flushes buffered diagnostics when the DLL detaches (normal process exit).
struct SourceLogShutdown
{
	~SourceLogShutdown() noexcept
	{
		flush_log_unlocked();
		close_log_handle_unlocked();
	}
} source_log_shutdown;

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
	write_log_unlocked(message, true);
}

void flush_log() noexcept
{
	std::lock_guard lock(state_mutex);
	flush_log_unlocked();
}

void flush_log_for_fault() noexcept
{
	// Best effort from an exception handler: never wait for a lock the
	// faulting thread may already hold.
	std::unique_lock lock(state_mutex, std::try_to_lock);
	if (!lock.owns_lock()) return;
	flush_log_unlocked();
}
}
