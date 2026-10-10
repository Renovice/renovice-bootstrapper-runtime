#include "replacements.hpp"

#include "config.hpp"
#include "injection.hpp"
#include "live_literals.hpp"
#include "packages.hpp"
#include "replacement_settings.hpp"
#include "script_control.hpp"

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
#include "diagnostic_read_probe.hpp"

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
using KeySet = std::unordered_set<std::uint64_t>;
std::atomic<std::shared_ptr<Snapshot>> active_replacements{std::make_shared<Snapshot>()};
std::atomic<std::shared_ptr<KeySet>> available_replacement_keys{std::make_shared<KeySet>()};
std::shared_ptr<Snapshot> prepared_replacements;
std::shared_ptr<KeySet> prepared_available_replacement_keys;
std::atomic_bool subsystem_enabled = false;

struct LoadedContext
{
	void* manager = nullptr;
	void* descriptor = nullptr;
	luau_GlobalState* global_state = nullptr;
	std::uint32_t name_handle[2]{};
	std::uint32_t owner_thread = 0;
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
std::unordered_map<std::uint64_t, std::uint64_t> unresolved_refreshes;

struct PendingRefresh
{
	PendingRefreshIdentity identity;
	void* manager = nullptr;
	std::uint32_t name_handle[2]{};
	std::shared_ptr<const std::vector<unsigned char>> bytes;
	bool restoring_stock = false;
	std::uint64_t generation = 0;
};

std::vector<PendingRefresh> pending_refreshes;
std::atomic_size_t pending_refresh_count = 0;
std::uint64_t next_refresh_generation = 1;
thread_local bool pending_drain_active = false;

struct ActiveModuleLoad
{
	void* descriptor = nullptr;
	void* manager = nullptr;
	PendingRefreshIdentity identity;
	std::uint32_t name_handle[2]{};
	std::vector<unsigned char> original;
	bool target_valid = false;
	bool replacement_undumped = false;
};

// Loader calls may nest when a module requires another module. A stack keeps
// positive undump evidence attached to the exact outer/inner loader call.
thread_local std::vector<ActiveModuleLoad> active_module_loads;

// REPLACEMENT_SETTINGS_V1: the natural load that completed last on this
// thread, when its undump consumed replacement bytes. The loader detour reads
// it only after the stock Loader returned successfully (never after a stock
// error, when no VM operation is allowed) to attach the settings accessor.
struct CompletedReplacementLoad
{
	void* descriptor = nullptr;
	std::uint64_t key = 0;
	std::uint32_t name_handle[2]{};
};
thread_local CompletedReplacementLoad completed_replacement_load_record;

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

// Optional folder packages (CustomScripts\Packages\<Name>\). The loose loop
// above is unchanged and never descends into subfolders. Package members come
// from the one package snapshot of this transaction (packages::candidate()),
// which the Inject scanner consumes too, so a package's replacements and addons
// enter or leave the generation together. Every structurally valid package
// inventories its keys even while disabled, exactly like a disabled loose file,
// so a later enable can refresh a module that already loaded.
bool merge_package_replacements(
	std::unordered_map<std::uint64_t, std::vector<unsigned char>>& snapshot,
	KeySet* available_keys
)
{
	const auto package_snapshot = packages::candidate();
	if (!package_snapshot) return true;
	for (const auto& package : package_snapshot->packages)
	{
		if (!package.structurally_valid) continue;
		for (const auto& member : package.members)
		{
			if (member.kind != packages::MemberKind::Replacement) continue;
			if (available_keys != nullptr) available_keys->emplace(member.key);
			if (!package.accepted) continue;
			// `member:` policy or the literal settings gate held it back.
			if (!member.staged) continue;
			if (member.bytes.empty())
			{
				conout << "RENOVICE replacement rejected: package member bytes missing package="
					<< package.folder << " member=" << member.filename << std::endl;
				return false;
			}
			if (!snapshot.emplace(member.key, member.bytes).second)
			{
				// Conflicts were resolved against the loose files the package scan
				// saw. A loose file that appeared between the two reads of this
				// same transaction rejects the whole reload; nothing is applied.
				conout << "RENOVICE replacement rejected: duplicate content key package="
					<< package.folder << " member=" << member.filename << std::endl;
				return false;
			}
		}
	}
	return true;
}

bool load_snapshot(
	const std::filesystem::path& directory,
	std::unordered_map<std::uint64_t, std::vector<unsigned char>>& snapshot,
	KeySet* available_keys = nullptr
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
		if (available_keys != nullptr) available_keys->emplace(key);
		const auto script_id = script_control::stable_id(
			script_control::Kind::Replacement, path.filename().string());
		const bool infrastructure = script_control::is_internal_hook_shim(
			path.filename().string());
		if (!infrastructure && !script_control::candidate_enabled(script_id)) continue;
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
	return merge_package_replacements(snapshot, available_keys);
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

// LIVE_LITERALS_V1: the plan snapshot of this transaction. Recipe keys join the
// available keys (stock body and loader context are captured at the natural
// load); a module owned by a byte replacement keeps that owner.
std::shared_ptr<const live_literals::PlanSnapshot> build_literal_plans(
	const Snapshot& bytes, KeySet* available_keys, const char* trigger)
{
	const auto package_snapshot = packages::candidate();
	auto plans = live_literals::build_snapshot(package_snapshot.get(),
		[&](std::uint64_t key) { return bytes.find(key) != bytes.end(); }, trigger);
	if (available_keys != nullptr)
		for (const auto key : plans->recipe_keys) available_keys->emplace(key);
	return plans;
}

// The replacement bytes of `key` in this generation: a byte replacement, else
// the module synthesized from its captured stock body (nullptr: stock).
std::shared_ptr<const std::vector<unsigned char>> effective_replacement(
	const Snapshot& bytes, const live_literals::PlanSnapshot& plans, std::uint64_t key,
	const std::vector<unsigned char>& original, const char* source)
{
	if (const auto found = bytes.find(key); found != bytes.end())
		return std::make_shared<const std::vector<unsigned char>>(found->second);
	if (original.empty()) return nullptr;
	return live_literals::synthesized(plans, key, original.data(), original.size(), source);
}

bool read_name_handle(void* descriptor, std::uint32_t (&output)[2]) noexcept
{
	if (descriptor == nullptr || diagnostics::bad_read_ptr(descriptor, 0x60)) return false;
	void* name_object = *reinterpret_cast<void**>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x08);
	if (name_object == nullptr || diagnostics::bad_read_ptr(name_object, 0x30)) return false;
	void** first_pointer = reinterpret_cast<void**>(
		reinterpret_cast<unsigned char*>(name_object) + 0x10);
	auto* second = reinterpret_cast<std::uint32_t*>(
		reinterpret_cast<unsigned char*>(name_object) + 0x2c);
	if (diagnostics::bad_read_ptr(first_pointer, sizeof(*first_pointer))
		|| *first_pointer == nullptr
		|| diagnostics::bad_read_ptr(*first_pointer, sizeof(std::uint32_t))
		|| diagnostics::bad_read_ptr(second, sizeof(*second)))
	{
		return false;
	}
	output[0] = *reinterpret_cast<std::uint32_t*>(*first_pointer);
	output[1] = *second;
	return true;
}

void enqueue_pending_locked(PendingRefresh pending)
{
	const auto existing = std::find_if(
		pending_refreshes.begin(), pending_refreshes.end(),
		[&](const PendingRefresh& current)
		{
			return same_pending_refresh(current.identity, pending.identity);
		});
	if (existing == pending_refreshes.end())
	{
		pending_refreshes.emplace_back(std::move(pending));
		pending_refresh_count.fetch_add(1, std::memory_order_release);
	}
	else *existing = std::move(pending);
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
	const auto original = reinterpret_cast<Undump>(undump_hook.original);
	const auto snapshot = active_replacements.load(std::memory_order_acquire);
	const auto literal_plans = live_literals::active();
	if ((!snapshot->empty() || !literal_plans->plans.empty()) && body != nullptr && body_size > 0
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
			const auto result = original(
				state,
				arg2,
				arg3,
				arg4,
				replacement->second.data(),
				static_cast<long long>(replacement->second.size()),
				mode
			);
			if (!active_module_loads.empty())
			{
				auto& active = active_module_loads.back();
				if (active.target_valid && active.identity.key == key)
				{
					active.replacement_undumped = true;
				}
			}
			return result;
		}
		// LIVE_LITERALS_V1: this undump consumes the stock body of a module with
		// a committed plan; synthesize from exactly these bytes (stock size,
		// SHA-256 and every preimage verified; any failure: stock bytes).
		if (const auto synthesized = live_literals::synthesized(
			*literal_plans, key, body, static_cast<std::size_t>(body_size), "undump"))
		{
			const auto result = original(
				state,
				arg2,
				arg3,
				arg4,
				const_cast<unsigned char*>(synthesized->data()),
				static_cast<long long>(synthesized->size()),
				mode
			);
			if (!active_module_loads.empty())
			{
				auto& active = active_module_loads.back();
				if (active.target_valid && active.identity.key == key)
				{
					active.replacement_undumped = true;
				}
			}
			return result;
		}
	}
	return original(state, arg2, arg3, arg4, body, body_size, mode);
}
}

InitialiseResult initialise(std::string_view exact_build, bool observe_undumps)
{
	std::unordered_map<std::uint64_t, std::vector<unsigned char>> snapshot;
	auto available_keys = std::make_shared<KeySet>();
	if (!load_snapshot(config::replacements_directory(), snapshot, available_keys.get()))
	{
		return InitialiseResult::Failed;
	}
	auto literal_plans = build_literal_plans(snapshot, available_keys.get(), "startup");
	if (snapshot.empty() && literal_plans->recipe_keys.empty() && !observe_undumps)
	{
		conout << "RENOVICE Lua replacements disabled: no .lua_B files found" << std::endl;
		return InitialiseResult::Disabled;
	}

	// Exact deployed undump prologue, with only the RIP displacement wildcarded.
	// Verified unique on the certified June, July, and August U43 executables.
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
	available_replacement_keys.store(std::move(available_keys), std::memory_order_release);
	live_literals::publish(std::move(literal_plans));
	undump_hook.detour = reinterpret_cast<void*>(&undump_detour);
	undump_hook.target = target;
	try
	{
		undump_hook.create();
	}
	catch (const std::exception& ex)
	{
		active_replacements.store(std::make_shared<Snapshot>(), std::memory_order_release);
		live_literals::publish(nullptr);
		conout << "RENOVICE Lua replacement hook failed closed: " << ex.what() << std::endl;
		return InitialiseResult::Failed;
	}
	if (!undump_hook.isCreated())
	{
		active_replacements.store(std::make_shared<Snapshot>(), std::memory_order_release);
		live_literals::publish(nullptr);
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
	auto available_keys = std::make_shared<KeySet>();
	if (!load_snapshot(
		config::replacements_directory(), *candidate, available_keys.get())) return false;
	auto literal_plans = build_literal_plans(*candidate, available_keys.get(), "F9");
	const auto previous = active_replacements.load(std::memory_order_acquire);
	prepared_changed_keys = changed_keys(*previous, *candidate);
	{
		// LIVE_LITERALS_V1: a changed plan is a changed replacement key.
		const auto literal_changed = live_literals::changed_keys(*live_literals::active(), *literal_plans);
		prepared_changed_keys.insert(prepared_changed_keys.end(), literal_changed.begin(), literal_changed.end());
		std::sort(prepared_changed_keys.begin(), prepared_changed_keys.end());
		prepared_changed_keys.erase(
			std::unique(prepared_changed_keys.begin(), prepared_changed_keys.end()), prepared_changed_keys.end());
	}
	if (!subsystem_enabled.load(std::memory_order_acquire))
	{
		if (candidate->empty() && literal_plans->plans.empty())
		{
			prepared_replacements = std::move(candidate);
			prepared_available_replacement_keys = std::move(available_keys);
			live_literals::prepare(std::move(literal_plans));
			return true;
		}
		conout << "RENOVICE Lua replacement reload rejected: enabling undump hook requires restart" << std::endl;
		return false;
	}
	prepared_replacements = std::move(candidate);
	prepared_available_replacement_keys = std::move(available_keys);
	live_literals::prepare(std::move(literal_plans));
	return true;
}

void commit_prepared_reload()
{
	if (!prepared_replacements) return;
	active_replacements.store(std::move(prepared_replacements), std::memory_order_release);
	if (prepared_available_replacement_keys)
	{
		available_replacement_keys.store(
			std::move(prepared_available_replacement_keys), std::memory_order_release);
	}
	committed_changed_keys = std::move(prepared_changed_keys);
	live_literals::commit_prepared();
}

void discard_prepared_reload()
{
	prepared_replacements.reset();
	prepared_available_replacement_keys.reset();
	prepared_changed_keys.clear();
	live_literals::discard_prepared();
}

void begin_module_load(void* manager, void* descriptor, std::uint64_t observed_body_key)
{
	if (!subsystem_enabled.load(std::memory_order_acquire)) return;
	active_module_loads.push_back(ActiveModuleLoad{descriptor});
	auto& active = active_module_loads.back();
	if (manager == nullptr || descriptor == nullptr
		|| diagnostics::bad_read_ptr(manager, 0x28) || diagnostics::bad_read_ptr(descriptor, 0x60))
	{
		return;
	}
	auto* state = *reinterpret_cast<luau_State**>(
		reinterpret_cast<unsigned char*>(manager) + 0x20);
	auto* body = *reinterpret_cast<unsigned char**>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x38);
	const auto size = *reinterpret_cast<std::uint32_t*>(
		reinterpret_cast<unsigned char*>(descriptor) + 0x40);
	std::uint32_t name_handle[2]{};
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr || body == nullptr || size == 0
		|| size >= maximum_replacement_size || diagnostics::bad_read_ptr(body, size)
		|| !read_name_handle(descriptor, name_handle))
	{
		return;
	}
	const auto key = observed_body_key != 0 ? observed_body_key : body_key(std::string_view(
		reinterpret_cast<const char*>(body), size));
	const auto snapshot = active_replacements.load(std::memory_order_acquire);
	const auto available = available_replacement_keys.load(std::memory_order_acquire);
	const bool available_replacement = available != nullptr
		&& available->find(key) != available->end();
	const bool active_replacement = snapshot->find(key) != snapshot->end();
	bool previously_loaded = false;
	bool unresolved_refresh = false;
	{
		std::lock_guard lock(loaded_targets_mutex);
		previously_loaded = loaded_targets.find(key) != loaded_targets.end();
		unresolved_refresh = unresolved_refreshes.find(key)
			!= unresolved_refreshes.end();
	}
	const bool known_target = should_capture_module_load(
		available_replacement,
		active_replacement, previously_loaded, unresolved_refresh);
	if (!known_target) return;
	active.manager = manager;
	active.identity = {
		key,
		manager,
		descriptor,
		state->global_state,
		static_cast<std::uint32_t>(GetCurrentThreadId()),
	};
	active.name_handle[0] = name_handle[0];
	active.name_handle[1] = name_handle[1];
	active.original.assign(body, body + size);
	active.target_valid = true;
}

void complete_module_load(void* manager, void* descriptor)
{
	if (!subsystem_enabled.load(std::memory_order_acquire)) return;
	if (active_module_loads.empty())
	{
		conout << "RENOVICE F9 natural-load evidence mismatch: completion without begin" << std::endl;
		return;
	}
	auto active = active_module_loads.back();
	active_module_loads.pop_back();
	completed_replacement_load_record = {};
	if (active.descriptor == descriptor && active.target_valid && active.replacement_undumped)
	{
		completed_replacement_load_record.descriptor = descriptor;
		completed_replacement_load_record.key = active.identity.key;
		completed_replacement_load_record.name_handle[0] = active.name_handle[0];
		completed_replacement_load_record.name_handle[1] = active.name_handle[1];
	}
	if (active.descriptor != descriptor)
	{
		conout << "RENOVICE F9 natural-load evidence mismatch: nested descriptor order" << std::endl;
		return;
	}
	if (!active.target_valid)
	{
		return;
	}
	std::size_t satisfied = 0;
	bool captured_new = false;
	bool queued_unresolved = false;
	std::uint64_t unresolved_generation = 0;
	{
		std::lock_guard lock(loaded_targets_mutex);
		auto& target = loaded_targets[active.identity.key];
		if (target.original.empty()) target.original = active.original;
		else if (target.original != active.original)
		{
			conout << "RENOVICE hot target rejected: body-key collision key="
				<< active.identity.key << std::endl;
			return;
		}
		const auto duplicate = std::find_if(
			target.contexts.begin(), target.contexts.end(),
			[&](const LoadedContext& context)
			{
				return context.manager == active.manager
					&& context.descriptor == active.descriptor
					&& context.global_state == active.identity.global_state;
			});
		LoadedContext context;
		context.manager = active.manager;
		context.descriptor = active.descriptor;
		context.global_state = const_cast<luau_GlobalState*>(
			static_cast<const luau_GlobalState*>(active.identity.global_state));
		context.name_handle[0] = active.name_handle[0];
		context.name_handle[1] = active.name_handle[1];
		context.owner_thread = active.identity.owner_thread;
		if (duplicate == target.contexts.end())
		{
			target.contexts.push_back(context);
			captured_new = true;
		}
		else *duplicate = context;

		if (const auto unresolved = unresolved_refreshes.find(active.identity.key);
			unresolved != unresolved_refreshes.end())
		{
			unresolved_generation = unresolved->second;
			bool literal_held_stock = false;
			if (!active.replacement_undumped)
			{
				const auto snapshot = active_replacements.load(std::memory_order_acquire);
				const auto literal_plans = live_literals::active();
				const auto replacement = effective_replacement(
					*snapshot, *literal_plans, active.identity.key, target.original, "refresh");
				// LIVE_LITERALS_V1: a plan whose synthesis failed closed leaves the
				// stock body that this load just undumped; no stock refresh is due.
				literal_held_stock = replacement == nullptr
					&& literal_plans->plans.count(active.identity.key) != 0;
				const auto payload = literal_held_stock ? HotReloadPayload::None
					: select_hot_reload_payload(true, replacement != nullptr, !target.original.empty());
				if (payload != HotReloadPayload::None)
				{
					PendingRefresh pending;
					pending.identity = active.identity;
					pending.manager = active.manager;
					pending.name_handle[0] = active.name_handle[0];
					pending.name_handle[1] = active.name_handle[1];
					pending.restoring_stock = payload == HotReloadPayload::Original;
					pending.bytes = pending.restoring_stock
						? std::make_shared<const std::vector<unsigned char>>(target.original) : replacement;
					pending.generation = unresolved_generation;
					enqueue_pending_locked(std::move(pending));
					queued_unresolved = true;
				}
			}
			if (active.replacement_undumped || queued_unresolved || literal_held_stock)
			{
				unresolved_refreshes.erase(unresolved);
			}
		}

		for (auto current = pending_refreshes.begin(); current != pending_refreshes.end();)
		{
			if (!natural_replacement_load_satisfies_pending(
				current->identity, active.identity, active.replacement_undumped))
			{
				++current;
				continue;
			}
			current = pending_refreshes.erase(current);
			++satisfied;
		}
		if (satisfied != 0)
		{
			pending_refresh_count.fetch_sub(satisfied, std::memory_order_release);
		}
	}
	if (captured_new || queued_unresolved)
	{
		std::ostringstream message;
		message << "RENOVICE F9 post-load context key=" << active.identity.key
			<< " captured=" << captured_new
			<< " queued_unresolved=" << queued_unresolved
			<< " generation=" << unresolved_generation;
		conout << message.str() << std::endl;
		config::log(message.str());
	}
	if (satisfied != 0)
	{
		std::ostringstream message;
		message << "RENOVICE F9 natural replacement delivery key="
			<< active.identity.key << " contexts=" << satisfied
			<< " pending=" << pending_refresh_count.load(std::memory_order_acquire);
		conout << message.str() << std::endl;
		config::log(message.str());
	}
}

// REPLACEMENT_SETTINGS_V1: after an F9 commit, attach the accessor to every
// replacement module this VM already loaded whose member now has settings
// (for example declarations added without a byte change). Exact VM and owner
// thread only; contexts of other VMs get it at their next load or refresh.
static void publish_settings_accessors_for_loaded(luau_State* state)
{
	const auto snapshot = replacement_settings::committed();
	if (snapshot == nullptr || snapshot->entries.empty() || state == nullptr
		|| state->global_state == nullptr) return;
	struct Job
	{
		std::uint64_t key = 0;
		std::uint32_t name_handle[2]{};
	};
	std::vector<Job> jobs;
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	{
		std::lock_guard lock(loaded_targets_mutex);
		for (const auto& entry : snapshot->entries)
		{
			const auto target = loaded_targets.find(entry.key);
			if (target == loaded_targets.end()) continue;
			for (const auto& context : target->second.contexts)
			{
				if (context.global_state != state->global_state
					|| context.owner_thread != owner_thread) continue;
				Job job;
				job.key = entry.key;
				job.name_handle[0] = context.name_handle[0];
				job.name_handle[1] = context.name_handle[1];
				jobs.push_back(job);
			}
		}
	}
	for (const auto& job : jobs)
	{
		injection::publish_replacement_settings_accessor(
			state, job.name_handle, job.key, "F9-commit");
	}
}

bool reexecute_changed_loaded(luau_State* state)
{
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr)
	{
		return false;
	}
	std::size_t changed = 0;
	std::size_t queued = 0;
	std::size_t unavailable = 0;
	std::size_t unresolved = 0;
	std::uint64_t generation = 0;
	const auto snapshot = active_replacements.load(std::memory_order_acquire);
	const auto literal_plans = live_literals::active();
	{
		std::lock_guard lock(loaded_targets_mutex);
		generation = next_refresh_generation++;
		changed = committed_changed_keys.size();
		for (const auto key : committed_changed_keys)
		{
			const auto target = loaded_targets.find(key);
			if (target == loaded_targets.end())
			{
				unresolved_refreshes[key] = generation;
				++unavailable;
				continue;
			}
			const auto replacement = effective_replacement(
				*snapshot, *literal_plans, key, target->second.original, "refresh");
			const auto payload = select_hot_reload_payload(
				true,
				replacement != nullptr,
				!target->second.original.empty());
			if (payload == HotReloadPayload::None)
			{
				++unavailable;
				continue;
			}
			const bool restoring = payload == HotReloadPayload::Original;
			auto bytes = restoring
				? std::make_shared<const std::vector<unsigned char>>(target->second.original) : replacement;
			if (target->second.contexts.empty())
			{
				unresolved_refreshes[key] = generation;
				++unavailable;
				continue;
			}
			for (const auto& context : target->second.contexts)
			{
				PendingRefresh pending;
				pending.identity = {
					key,
					context.manager,
					context.descriptor,
					context.global_state,
					context.owner_thread,
				};
				pending.manager = context.manager;
				pending.name_handle[0] = context.name_handle[0];
				pending.name_handle[1] = context.name_handle[1];
				pending.bytes = bytes;
				pending.restoring_stock = restoring;
				pending.generation = generation;
				enqueue_pending_locked(std::move(pending));
				++queued;
			}
			unresolved_refreshes.erase(key);
		}
		committed_changed_keys.clear();
		unresolved = unresolved_refreshes.size();
	}

	const bool immediate_pass = drain_pending_for_vm(state);
	publish_settings_accessors_for_loaded(state);
	std::size_t pending = 0;
	{
		std::lock_guard lock(loaded_targets_mutex);
		pending = pending_refreshes.size();
	}
	std::ostringstream refresh_summary;
	refresh_summary << "RENOVICE F9 module refresh summary generation=" << generation
		<< " changed=" << changed
		<< " queued=" << queued
		<< " unavailable=" << unavailable
		<< " unresolved=" << unresolved
		<< " pending_other_vm=" << pending;
	conout << refresh_summary.str() << std::endl;
	config::log(refresh_summary.str());
	return hot_reload_complete(
		immediate_pass && unavailable == 0 && unresolved == 0, pending);
}

bool drain_pending_for_vm(luau_State* state)
{
	if (pending_drain_active) return true;
	if (pending_refresh_count.load(std::memory_order_acquire) == 0) return true;
	if (state == nullptr || diagnostics::bad_read_ptr(state, sizeof(luau_State))
		|| state->global_state == nullptr)
	{
		return false;
	}
	pending_drain_active = true;
	struct ScopedReset
	{
		bool& flag;
		~ScopedReset() { flag = false; }
	} reset{pending_drain_active};

	std::vector<PendingRefresh> jobs;
	const auto owner_thread = static_cast<std::uint32_t>(GetCurrentThreadId());
	{
		std::lock_guard lock(loaded_targets_mutex);
		for (auto current = pending_refreshes.begin(); current != pending_refreshes.end();)
		{
			if (!pending_refresh_ready(current->identity, state->global_state, owner_thread))
			{
				++current;
				continue;
			}
			jobs.emplace_back(std::move(*current));
			current = pending_refreshes.erase(current);
		}
		if (!jobs.empty())
		{
			pending_refresh_count.fetch_sub(jobs.size(), std::memory_order_release);
		}
	}
	if (jobs.empty()) return true;

	std::size_t failures = 0;
	for (const auto& job : jobs)
	{
		std::ostringstream name;
		name << "hot-reload-" << std::hex << job.identity.key
			<< (job.restoring_stock ? "-stock" : "-replacement");
		const bool current = job.bytes != nullptr && injection::execute_native_module_refresh(
			name.str(), *job.bytes, state,
			const_cast<void*>(job.identity.manager),
			const_cast<void*>(job.identity.descriptor));
		conout << "RENOVICE F9 VM-local module refresh " << (current ? "PASS" : "FAIL")
			<< " generation=" << job.generation
			<< " key=" << job.identity.key
			<< " mode=" << (job.restoring_stock ? "stock" : "replacement")
			<< " vm=" << job.identity.global_state
			<< " thread=" << owner_thread
			<< std::endl;
		if (!current) ++failures;
		// LIVE_LITERALS_V1 / R5-C: a refreshed module of a target-addon key gets
		// its new prototype graph registered under the same (stock) key, so the
		// addon's hooks keep matching (no-op for keys no addon targets).
		if (current)
		{
			injection::remember_refreshed_target_module(
				state, const_cast<void*>(job.identity.manager), job.name_handle, job.identity.key);
		}
		// REPLACEMENT_SETTINGS_V1: a refreshed replacement gets the accessor in
		// its load environment before its root can run (no-op without an entry).
		if (current && !job.restoring_stock)
		{
			injection::publish_replacement_settings_accessor(
				state, job.name_handle, job.identity.key, "F9-refresh");
		}
	}

	std::size_t pending = 0;
	{
		std::lock_guard lock(loaded_targets_mutex);
		pending = pending_refreshes.size();
	}
	std::ostringstream summary;
	summary << "RENOVICE F9 VM-local delivery executed=" << jobs.size()
		<< " failures=" << failures << " pending=" << pending;
	conout << summary.str() << std::endl;
	config::log(summary.str());
	return failures == 0;
}

bool completed_replacement_load(
	void* descriptor, std::uint64_t& key, std::uint32_t (&name_handle)[2]) noexcept
{
	const auto& record = completed_replacement_load_record;
	if (descriptor == nullptr || record.descriptor != descriptor || record.key == 0) return false;
	key = record.key;
	name_handle[0] = record.name_handle[0];
	name_handle[1] = record.name_handle[1];
	return true;
}
}
