#include "replacements.hpp"

#include "injection.hpp"

#include <cctype>
#include <exception>
#include <filesystem>
#include <fstream>
#include <limits>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#include <DetourHook.hpp>
#include <joaat.hpp>
#include <Module.hpp>
#include <Pattern.hpp>

#include "../owf_console.hpp"
#include "../owf_structs.hpp"
#include "../owf_tunables.hpp"

namespace renovice::replacements
{
namespace
{
using Undump = long long(*)(
	void* state,
	void* arg2,
	void* arg3,
	void* arg4,
	unsigned char* body,
	long long body_size,
	int mode
);

constexpr std::uintmax_t maximum_replacement_size = 1ull << 28;

soup::DetourHook undump_hook;
std::unordered_map<std::uint64_t, std::vector<unsigned char>> active_replacements;

bool ascii_iequals(std::string_view lhs, std::string_view rhs) noexcept
{
	if (lhs.size() != rhs.size())
	{
		return false;
	}
	for (std::size_t i = 0; i != lhs.size(); ++i)
	{
		if (std::tolower(static_cast<unsigned char>(lhs[i]))
			!= std::tolower(static_cast<unsigned char>(rhs[i])))
		{
			return false;
		}
	}
	return true;
}

bool read_file(const std::filesystem::path& path, std::vector<unsigned char>& bytes)
{
	std::error_code ec;
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || size == 0 || size >= maximum_replacement_size
		|| size > static_cast<std::uintmax_t>((std::numeric_limits<std::streamsize>::max)()))
	{
		return false;
	}
	bytes.resize(static_cast<std::size_t>(size));
	std::ifstream input(path, std::ios::binary);
	return input
		&& static_cast<bool>(input.read(
			reinterpret_cast<char*>(bytes.data()),
			static_cast<std::streamsize>(bytes.size())
		));
}

bool load_snapshot(
	const std::filesystem::path& directory,
	std::unordered_map<std::uint64_t, std::vector<unsigned char>>& snapshot
)
{
	std::error_code ec;
	std::filesystem::create_directories(directory, ec);
	if (ec)
	{
		conout << "RENOVICE replacement directory error: " << ec.message() << std::endl;
		return false;
	}

	for (std::filesystem::directory_iterator it(directory, ec), end; !ec && it != end; it.increment(ec))
	{
		if (!it->is_regular_file(ec))
		{
			if (ec) break;
			continue;
		}
		const auto path = it->path();
		if (!ascii_iequals(path.extension().string(), ".lua_B"))
		{
			continue;
		}

		std::uint64_t key;
		if (!parse_filename_key(path.stem().string(), key))
		{
			conout << "RENOVICE replacement rejected: invalid content key in " << path.filename().string() << std::endl;
			return false;
		}
		std::vector<unsigned char> bytes;
		if (!read_file(path, bytes))
		{
			conout << "RENOVICE replacement rejected: unreadable or invalid size " << path.filename().string() << std::endl;
			return false;
		}
		if (!snapshot.emplace(key, std::move(bytes)).second)
		{
			conout << "RENOVICE replacement rejected: duplicate content key " << path.filename().string() << std::endl;
			return false;
		}
	}
	if (ec)
	{
		conout << "RENOVICE replacement scan error: " << ec.message() << std::endl;
		return false;
	}
	return true;
}

long long undump_detour(
	void* state,
	void* arg2,
	void* arg3,
	void* arg4,
	unsigned char* body,
	long long body_size,
	int mode
)
{
	injection::notify_undump();
	const auto original = reinterpret_cast<Undump>(undump_hook.original);
	if (!active_replacements.empty()
		&& body != nullptr && body_size > 0
		&& body_size < static_cast<long long>(maximum_replacement_size))
	{
		const auto key = body_key(std::string_view(
			reinterpret_cast<const char*>(body),
			static_cast<std::size_t>(body_size)
		));
		if (const auto replacement = active_replacements.find(key); replacement != active_replacements.end())
		{
			conout << "RENOVICE Lua replacement matched key=" << key
				<< " original_bytes=" << body_size
				<< " replacement_bytes=" << replacement->second.size() << std::endl;
			return original(
				state,
				arg2,
				arg3,
				arg4,
				replacement->second.data(),
				static_cast<long long>(replacement->second.size()),
				mode
			);
		}
	}
	return original(state, arg2, arg3, arg4, body, body_size, mode);
}
}

InitialiseResult initialise(std::string_view exact_build, bool observe_undumps)
{
	std::unordered_map<std::uint64_t, std::vector<unsigned char>> snapshot;
	if (!load_snapshot(std::filesystem::path("OpenWF") / "CustomScripts", snapshot))
	{
		return InitialiseResult::Failed;
	}
	if (snapshot.empty() && !observe_undumps)
	{
		conout << "RENOVICE Lua replacements disabled: no .lua_B files found" << std::endl;
		return InitialiseResult::Disabled;
	}

	// Exact deployed undump prologue, with only the RIP displacement wildcarded.
	// Verified unique on the certified June and July U43 executables.
	const soup::Pattern signature(
		"40 53 55 56 57 41 55 41 56 41 57 48 81 EC F0 01 00 00 "
		"48 8B 05 ? ? ? ? 48 33"
	);
	const soup::Module game(nullptr);
	auto target = game.range.scan(signature).as<void*>();
	if (target == nullptr)
	{
		const auto fallback_name = fallback_tunable_name(exact_build);
		const auto fallback_rva = g_client_tunables.getInt(soup::joaat::hash(fallback_name));
		if (fallback_rva == 0 || fallback_rva >= game.size())
		{
			conout << "RENOVICE Lua replacement hook failed closed: undump signature and exact-build RVA unavailable" << std::endl;
			return InitialiseResult::Failed;
		}
		target = game.base().add(fallback_rva).as<void*>();
		conout << "RENOVICE Lua replacement hook warning: using certified exact-build undump RVA" << std::endl;
	}

	active_replacements = std::move(snapshot);
	undump_hook.detour = reinterpret_cast<void*>(&undump_detour);
	undump_hook.target = target;
	try
	{
		undump_hook.create();
	}
	catch (const std::exception& ex)
	{
		active_replacements.clear();
		conout << "RENOVICE Lua replacement hook failed closed: " << ex.what() << std::endl;
		return InitialiseResult::Failed;
	}
	if (!undump_hook.isCreated())
	{
		active_replacements.clear();
		conout << "RENOVICE Lua replacement hook failed closed: trampoline creation failed" << std::endl;
		return InitialiseResult::Failed;
	}
	undump_hook.enable();

	conout << "RENOVICE Lua replacement hook enabled: replacements="
		<< active_replacements.size() << " undump_observer=" << observe_undumps
		<< " target=" << target << std::endl;
	return InitialiseResult::Enabled;
}
}
