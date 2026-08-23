#include "config.hpp"

#include <array>
#include <fstream>
#include <limits>
#include <mutex>
#include <string>

#include <winsock2.h>
#include <windows.h>

#include "../owf_console.hpp"

namespace renovice::config
{
namespace
{
constexpr std::uintmax_t maximum_config_size = 64ull * 1024ull;

std::filesystem::path scripts_directory;
std::filesystem::path inject_directory;
std::filesystem::path log_path;
Flags active_flags;
std::mutex state_mutex;

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
	log_path = scripts_directory / L"renovice_source.log";

	if (!reload())
	{
		conout << "RENOVICE configuration failed closed: renovice.cfg is unreadable or oversized" << std::endl;
		return false;
	}
	conout << "RENOVICE configuration enabled: CustomScripts="
		<< scripts_directory.string()
		<< " Logging=" << active_flags.logging
		<< " Verbose=" << active_flags.verbose
		<< " AutoSpawn=" << active_flags.auto_spawn << std::endl;
	return true;
}

bool reload()
{
	Flags parsed;
	if (scripts_directory.empty()
		|| !read_config_file(scripts_directory / L"renovice.cfg", parsed))
	{
		return false;
	}
	{
		std::lock_guard lock(state_mutex);
		active_flags = parsed;
	}
	return true;
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

void log(std::string_view message) noexcept
{
	std::lock_guard lock(state_mutex);
	if (!active_flags.logging || log_path.empty()) return;
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

void verbose_log(std::string_view message) noexcept
{
	{
		std::lock_guard lock(state_mutex);
		if (!active_flags.verbose) return;
	}
	log(message);
}
}
