#include "replacements.hpp"

#include "config.hpp"
#include "injection.hpp"

#include <atomic>
#include <cctype>
#include <exception>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <mutex>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include <DetourHook.hpp>
#include <joaat.hpp>
#include <Module.hpp>
#include <Pattern.hpp>

#include "../owf_console.hpp"
#include "../owf_luau.hpp"
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
using Snapshot = std::unordered_map<std::uint64_t, std::vector<unsigned char>>;
std::atomic<std::shared_ptr<Snapshot>> active_replacements{std::make_shared<Snapshot>()};
std::shared_ptr<Snapshot> prepared_replacements;
std::atomic_bool subsystem_enabled = false;

struct LoadedContext
{
	void* environment = nullptr;
	luau_GlobalState* global_state = nullptr;
};

struct LoadedTarget
{
	std::vector<unsigned char> original;
	std::vector<LoadedContext> contexts;
};

std::mutex loaded_targets_mutex;
std::unordered_map<std::uint64_t, LoadedTarget> loaded_targets;
std::vector<std::uint64_t> prepared_changed_keys;
std::vector<std::uint64_t> committed_changed_keys;

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

std::vector<std::uint64_t> changed_keys(const Snapshot& previous, const Snapshot& next)
{
	std::unordered_set<std::uint64_t> changed;
	for (const auto& [key, bytes] : previous)
	{
		const auto found = next.find(key);
		if (found == next.end() || found->second != bytes) changed.emplace(key);
	}
	for (const auto& [key, bytes] : next)
	{
		const auto found = previous.find(key);
		if (found == previous.end() || found->second != bytes) changed.emplace(key);
	}
	std::vector<std::uint64_t> result(changed.begin(), changed.end());
	std::sort(result.begin(), result.end());
	return result;
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
	const auto snapshot = active_replacements.load(std::memory_order_acquire);
	if (!snapshot->empty() && body != nullptr && body_size > 0
		&& body_size < static_cast<long long>(maximum_replacement_size))
	{
		const auto key = body_key(std::string_view(
			reinterpret_cast<const char*>(body),
			static_cast<std::size_t>(body_size)
		));
		if (const auto replacement = snapshot->find(key); replacement != snapshot->end())
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
	if (!load_snapshot(config::custom_scripts_directory(), snapshot))
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

	active_replacements.store(std::make_shared<Snapshot>(std::move(snapshot)), std::memory_order_release);
	undump_hook.detour = reinterpret_cast<void*>(&undump_detour);
	undump_hook.target = target;
	try
	{
		undump_hook.create();
	}
	catch (const std::exception& ex)
	{
		active_replacements.store(std::make_shared<Snapshot>(), std::memory_order_release);
		conout << "RENOVICE Lua replacement hook failed closed: " << ex.what() << std::endl;
		return InitialiseResult::Failed;
	}
	if (!undump_hook.isCreated())
	{
		active_replacements.store(std::make_shared<Snapshot>(), std::memory_order_release);
		conout << "RENOVICE Lua replacement hook failed closed: trampoline creation failed" << std::endl;
		return InitialiseResult::Failed;
	}
	undump_hook.enable();

	subsystem_enabled.store(true, std::memory_order_release);
	const auto committed = active_replacements.load(std::memory_order_acquire);
	conout << "RENOVICE Lua replacement hook enabled: replacements="
		<< committed->size() << " undump_observer=" << observe_undumps
		<< " target=" << target << std::endl;
	return InitialiseResult::Enabled;
}

bool reload()
{
	if (!prepare_reload()) return false;
	commit_prepared_reload();
	return true;
}

bool prepare_reload()
{
	auto candidate = std::make_shared<Snapshot>();
	if (!load_snapshot(config::custom_scripts_directory(), *candidate)) return false;
	const auto previous = active_replacements.load(std::memory_order_acquire);
	prepared_changed_keys = changed_keys(*previous, *candidate);
	if (!subsystem_enabled.load(std::memory_order_acquire))
	{
		if (candidate->empty())
		{
			prepared_replacements = std::move(candidate);
			return true;
		}
		conout << "RENOVICE Lua replacement reload rejected: enabling undump hook requires restart" << std::endl;
		return false;
	}
	prepared_replacements = std::move(candidate);
	return true;
}

void commit_prepared_reload()
{
	if (!prepared_replacements) return;
	active_replacements.store(std::move(prepared_replacements), std::memory_order_release);
	committed_changed_keys = std::move(prepared_changed_keys);
}

void discard_prepared_reload()
{
	prepared_replacements.reset();
	prepared_changed_keys.clear();
}

void observe_module_load(void* manager, void* descriptor)
{
	if (!subsystem_enabled.load(std::memory_order_acquire)
		|| manager == nullptr || descriptor == nullptr
		|| IsBadReadPtr(manager, 0x28) || IsBadReadPtr(descriptor, 0x60))
	{
		return;
	}
	auto* state = *reinterpret_cast<luau_State**>(
		reinterpret_cast<unsigned char*>(manager) + 0x20);
	auto* body = *reinterpret_cast<unsigned char**>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x38);
	const auto size = *reinterpret_cast<std::uint32_t*>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x40);
	void* environment = *reinterpret_cast<void**>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x58);
	if (state == nullptr || IsBadReadPtr(state, sizeof(luau_State))
		|| state->global_state == nullptr || body == nullptr || size == 0
		|| size >= maximum_replacement_size || IsBadReadPtr(body, size)
		|| environment == nullptr || IsBadReadPtr(environment, 0x10))
	{
		return;
	}
	const auto key = body_key(std::string_view(
		reinterpret_cast<const char*>(body), size));
	const auto snapshot = active_replacements.load(std::memory_order_acquire);
	if (snapshot->find(key) == snapshot->end()) return;

	try
	{
		std::lock_guard lock(loaded_targets_mutex);
		auto& target = loaded_targets[key];
		if (target.original.empty()) target.original.assign(body, body + size);
		else if (target.original.size() != size
			|| !std::equal(target.original.begin(), target.original.end(), body))
		{
			conout << "RENOVICE hot target rejected: body-key collision key=" << key << std::endl;
			return;
		}
		const auto duplicate = std::find_if(
			target.contexts.begin(), target.contexts.end(),
			[&](const LoadedContext& context)
			{
				return context.environment == environment
					&& context.global_state == state->global_state;
			});
		if (duplicate == target.contexts.end())
		{
			target.contexts.push_back({environment, state->global_state});
			conout << "RENOVICE hot target captured key=" << key
				<< " environment=" << environment << std::endl;
		}
	}
	catch (const std::exception& exception)
	{
		conout << "RENOVICE hot target capture failed: " << exception.what() << std::endl;
	}
}

bool reexecute_changed_loaded(luau_State* state)
{
	if (state == nullptr || IsBadReadPtr(state, sizeof(luau_State))
		|| state->global_state == nullptr)
	{
		return false;
	}
	struct Job
	{
		std::uint64_t key;
		void* environment;
		std::vector<unsigned char> bytes;
		bool restoring_stock;
	};
	std::vector<Job> jobs;
	std::size_t deferred = 0;
	const auto snapshot = active_replacements.load(std::memory_order_acquire);
	{
		std::lock_guard lock(loaded_targets_mutex);
		for (const auto key : committed_changed_keys)
		{
			const auto target = loaded_targets.find(key);
			if (target == loaded_targets.end())
			{
				++deferred;
				continue;
			}
			const auto replacement = snapshot->find(key);
			const auto payload = select_hot_reload_payload(
				true,
				replacement != snapshot->end(),
				!target->second.original.empty());
			if (payload == HotReloadPayload::None)
			{
				++deferred;
				continue;
			}
			const bool restoring = payload == HotReloadPayload::Original;
			const auto& bytes = restoring ? target->second.original : replacement->second;
			bool matched_vm = false;
			for (const auto& context : target->second.contexts)
			{
				if (!compatible_hot_reload_vm(state->global_state, context.global_state)) continue;
				matched_vm = true;
				jobs.push_back({key, context.environment, bytes, restoring});
			}
			if (!matched_vm) ++deferred;
		}
		committed_changed_keys.clear();
	}

	bool pass = true;
	for (const auto& job : jobs)
	{
		std::ostringstream name;
		name << "hot-reload-" << std::hex << job.key
			<< (job.restoring_stock ? "-stock" : "-replacement");
		const bool current = injection::execute_module_refresh(
			name.str(), job.bytes, job.environment, state);
		conout << "RENOVICE F9 module refresh " << (current ? "PASS" : "FAIL")
			<< " key=" << job.key
			<< " mode=" << (job.restoring_stock ? "stock" : "replacement")
			<< std::endl;
		pass = current && pass;
	}
	conout << "RENOVICE F9 module refresh summary changed="
		<< (jobs.size() + deferred) << " executed=" << jobs.size()
		<< " deferred=" << deferred << std::endl;
	return pass;
}
}
