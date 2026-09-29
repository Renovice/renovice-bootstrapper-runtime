#include "script_control.hpp"

#include "config.hpp"
#include "injection_core.hpp"
#include "packages.hpp"
#include "replacements_core.hpp"

#include <algorithm>
#include <fstream>
#include <limits>
#include <mutex>
#include <optional>
#include <unordered_map>

#include <winsock2.h>
#include <windows.h>

#include <json.hpp>

#include "../owf_console.hpp"

namespace renovice::script_control
{
namespace
{
using State = std::unordered_map<std::string, bool>;
constexpr std::uintmax_t maximum_state_size = 256ull * 1024ull;

std::mutex state_mutex;
State active_state;
std::optional<State> prepared_state;
State requested_state;

std::filesystem::path state_path()
{
	return config::custom_scripts_directory() / L"ScriptStates.json";
}

bool read_state(State& output)
{
	output.clear();
	const auto path = state_path();
	std::error_code ec;
	if (!std::filesystem::exists(path, ec)) return !ec;
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || size > maximum_state_size
		|| size > static_cast<std::uintmax_t>((std::numeric_limits<std::streamsize>::max)()))
	{
		return false;
	}
	std::string bytes(static_cast<std::size_t>(size), '\0');
	std::ifstream input(path, std::ios::binary);
	if (!input || (size != 0 && !input.read(bytes.data(), static_cast<std::streamsize>(size))))
	{
		return false;
	}
	if (bytes.empty()) return false;
	auto root = soup::json::decode(bytes.data(), bytes.size());
	if (!root || !root->isObj()) return false;
	auto& object = root->reinterpretAsObj();
	if (object.children.size() != 2) return false;
	bool saw_schema = false;
	bool saw_scripts = false;
	for (const auto& [key, value] : object.children)
	{
		if (!key->isStr()) return false;
		const auto& name = key->reinterpretAsStr().value;
		if (name == "schema")
		{
			if (saw_schema || !value->isInt() || value->asInt().value != 1) return false;
			saw_schema = true;
		}
		else if (name == "scripts")
		{
			if (saw_scripts || !value->isObj()) return false;
			saw_scripts = true;
		}
		else
		{
			return false;
		}
	}
	if (!saw_schema || !saw_scripts) return false;
	auto* scripts = object.find("scripts");
	if (scripts == nullptr || !scripts->isObj()) return false;
	for (const auto& [key, value] : scripts->reinterpretAsObj().children)
	{
		if (!key->isStr() || !value->isBool()) return false;
		const auto& id = key->reinterpretAsStr().value;
		if (!valid_state_id(id) || !output.emplace(id, value->asBool().value).second)
		{
			return false;
		}
	}
	return true;
}

bool write_state(const State& state, std::string& error)
{
	soup::JsonObject root;
	root.add("schema", 1);
	auto scripts = soup::make_unique<soup::JsonObject>();
	std::vector<std::pair<std::string, bool>> ordered(state.begin(), state.end());
	std::sort(ordered.begin(), ordered.end());
	for (const auto& [id, enabled] : ordered) scripts->add(id, enabled);
	root.add("scripts", std::move(scripts));
	std::string bytes;
	root.encodePrettyAndAppendTo(bytes);
	bytes += "\r\n";

	const auto path = state_path();
	const auto temporary = path.parent_path() /
		(L".ScriptStates." + std::to_wstring(GetCurrentProcessId()) + L".tmp");
	{
		std::ofstream output(temporary, std::ios::binary | std::ios::trunc);
		if (!output || !output.write(bytes.data(), static_cast<std::streamsize>(bytes.size()))
			|| !output.flush())
		{
			error = "unable to write temporary state file";
			std::error_code ignored;
			std::filesystem::remove(temporary, ignored);
			return false;
		}
	}
	if (!MoveFileExW(temporary.c_str(), path.c_str(),
		MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH))
	{
		error = "atomic ScriptStates.json replacement failed with Win32 error "
			+ std::to_string(GetLastError());
		std::error_code ignored;
		std::filesystem::remove(temporary, ignored);
		return false;
	}
	return true;
}

bool state_enabled(const State& state, std::string_view id)
{
	const auto found = state.find(std::string(id));
	return found == state.end() || found->second;
}

Kind injection_kind(injection::ScriptKind kind)
{
	switch (kind)
	{
	case injection::ScriptKind::ManagedAddon: return Kind::Addon;
	case injection::ScriptKind::TargetManagedAddon: return Kind::TargetAddon;
	case injection::ScriptKind::Ordinary: return Kind::OneShot;
	case injection::ScriptKind::ExperimentalPersistent:
	case injection::ScriptKind::ExperimentalSpawn: return Kind::OneShot;
	}
	return Kind::OneShot;
}

void discover_directory(
	const std::filesystem::path& directory,
	bool replacements,
	const State& policy,
	const State& requested,
	std::vector<ScriptInfo>& output
)
{
	std::error_code ec;
	for (std::filesystem::directory_iterator it(directory, ec), end;
		!ec && it != end; it.increment(ec))
	{
		if (!it->is_regular_file(ec))
		{
			if (ec) break;
			continue;
		}
		const auto path = it->path();
		if (!injection::is_lua_bytecode_extension(path.extension().string())) continue;
		ScriptInfo info;
		info.filename = path.filename().string();
		if (!replacements && injection::is_internal_infrastructure(info.filename))
		{
			continue;
		}
		if (replacements)
		{
			if (is_internal_hook_shim(info.filename))
			{
				// Required module instrumentation is owned by the bootstrapper and
				// must never appear as a user-toggleable feature.
				continue;
			}
			info.kind = Kind::Replacement;
			std::uint64_t key = 0;
			info.valid = replacements::parse_filename_key(path.stem().string(), key);
			if (info.valid)
			{
				char target[17]{};
				snprintf(target, sizeof(target), "%016llx", static_cast<unsigned long long>(key));
				info.target = target;
			}
		}
		else
		{
			const auto classified = injection::classify_script(info.filename);
			info.kind = injection_kind(classified);
			if (classified == injection::ScriptKind::ExperimentalPersistent
				|| classified == injection::ScriptKind::ExperimentalSpawn)
			{
				info.valid = false;
			}
			if (injection::is_multi_target_addon(info.filename))
			{
				// One file, one row, one policy: summarize the declared targets
				// from the same string-pool inventory the loader uses.
				const char* reason = injection::multi_target_filename_error(info.filename);
				std::vector<std::uint64_t> keys;
				if (reason == nullptr)
				{
					std::error_code size_error;
					const auto size = std::filesystem::file_size(path, size_error);
					std::vector<unsigned char> bytes;
					if (size_error || !injection::valid_chunk_size(size))
					{
						reason = "unreadable-empty-or-oversized";
					}
					else
					{
						bytes.resize(static_cast<std::size_t>(size));
						std::ifstream input(path, std::ios::binary);
						if (!input || !input.read(reinterpret_cast<char*>(bytes.data()),
							static_cast<std::streamsize>(bytes.size())))
						{
							reason = "unreadable-empty-or-oversized";
						}
						else
						{
							reason = injection::discover_multi_target_keys(
								bytes.data(), bytes.size(), keys);
						}
					}
				}
				info.valid = reason == nullptr;
				info.target = info.valid
					? std::to_string(keys.size()) + " modules"
					: std::string("invalid: ") + reason;
			}
			else if (classified == injection::ScriptKind::TargetManagedAddon)
			{
				std::uint64_t key = 0;
				info.valid = injection::target_addon_key(info.filename, key);
				if (info.valid)
				{
					char target[17]{};
					snprintf(target, sizeof(target), "%016llx", static_cast<unsigned long long>(key));
					info.target = target;
				}
			}
		}
		info.id = stable_id(info.kind, info.filename);
		info.enabled = state_enabled(policy, info.id);
		if (const auto pending = requested.find(info.id); pending != requested.end()
			&& pending->second != info.enabled)
		{
			info.enabled = pending->second;
			info.pending = true;
		}
		info.status = !info.valid ? "INVALID"
			: (info.pending ? "PENDING F9" : (info.enabled ? "ENABLED" : "DISABLED"));
		output.emplace_back(std::move(info));
	}
}

// One row per package folder, one policy ID `package:<folder lowercased>`.
// Validity, conflicts and the member summary come from the same static rules
// the loader applies (packages::inventory, a quiet scan without replacement
// bytes). A conflicted package stays toggleable so the player can resolve it.
void discover_packages(
	const State& policy,
	const State& requested,
	std::vector<ScriptInfo>& output
)
{
	const auto inventory = packages::inventory();
	for (const auto& package : inventory->packages)
	{
		ScriptInfo info;
		info.kind = Kind::Package;
		info.filename = package.folder;
		info.id = package.id;
		info.valid = package.structurally_valid;
		info.label = packages::menu_label(package.folder,
			package.display == package.folder ? std::string_view{} : std::string_view{package.display});
		std::vector<std::pair<std::string, std::string>> members;
		members.reserve(package.members.size());
		for (const auto& member : package.members)
			members.emplace_back(member.filename, member.label);
		info.target = info.valid ? packages::members_summary(members) : std::string{};
		info.detail = packages::truncate_display(
			packages::sanitize_display(package.description),
			packages::maximum_tooltip_description_length);
		info.enabled = state_enabled(policy, info.id);
		if (const auto pending = requested.find(info.id); pending != requested.end()
			&& pending->second != info.enabled)
		{
			info.enabled = pending->second;
			info.pending = true;
		}
		if (!info.valid) info.status = "INVALID: " + package.reason;
		else if (info.pending) info.status = "PENDING F9";
		else if (!info.enabled) info.status = "DISABLED";
		else if (!package.accepted) info.status = "BLOCKED: " + package.reason;
		else info.status = "ENABLED";
		output.emplace_back(std::move(info));
	}
}
}

bool initialise()
{
	State loaded;
	if (!read_state(loaded))
	{
		conout << "RENOVICE script control failed closed: ScriptStates.json is invalid" << std::endl;
		return false;
	}
	std::lock_guard lock(state_mutex);
	active_state = std::move(loaded);
	prepared_state.reset();
	requested_state.clear();
	return true;
}

bool prepare_reload()
{
	State loaded;
	if (!read_state(loaded)) return false;
	std::lock_guard lock(state_mutex);
	prepared_state = std::move(loaded);
	return true;
}

void commit_prepared_reload()
{
	std::lock_guard lock(state_mutex);
	if (!prepared_state) return;
	active_state = std::move(*prepared_state);
	prepared_state.reset();
	requested_state.clear();
}

void discard_prepared_reload()
{
	std::lock_guard lock(state_mutex);
	prepared_state.reset();
}

bool displayed_enabled(std::string_view id)
{
	std::lock_guard lock(state_mutex);
	if (const auto requested = requested_state.find(std::string(id)); requested != requested_state.end())
		return requested->second;
	return state_enabled(active_state, id);
}

bool candidate_enabled(std::string_view id)
{
	std::lock_guard lock(state_mutex);
	return state_enabled(prepared_state ? *prepared_state : active_state, id);
}

std::vector<ScriptInfo> snapshot()
{
	State policy;
	State requested;
	{
		std::lock_guard lock(state_mutex);
		policy = active_state;
		requested = requested_state;
	}
	std::vector<ScriptInfo> output;
	discover_directory(config::injection_directory(), false, policy, requested, output);
	discover_directory(config::custom_scripts_directory(), true, policy, requested, output);
	discover_packages(policy, requested, output);
	std::sort(output.begin(), output.end(), [](const ScriptInfo& lhs, const ScriptInfo& rhs)
	{
		if (lhs.kind != rhs.kind) return lhs.kind < rhs.kind;
		return lhs.filename < rhs.filename;
	});
	return output;
}

bool request_enabled(std::string_view id, bool enabled, std::string& error)
{
	return request_enabled_batch({{std::string(id), enabled}}, error);
}

bool request_enabled_batch(
	const std::vector<std::pair<std::string, bool>>& requests,
	std::string& error
)
{
	if (requests.empty()) return true;
	for (const auto& [id, enabled] : requests)
	{
		(void)enabled;
		if (!valid_state_id(id))
		{
			error = "invalid script id";
			return false;
		}
	}
	const auto inventory = snapshot();
	std::shared_ptr<const packages::Snapshot> package_inventory;
	for (const auto& [id, enabled] : requests)
	{
		(void)enabled;
		if (is_member_state_id(id))
		{
			// `member:` ids are never Scripts-menu rows; they must name a member
			// of a structurally valid package on disk.
			if (!package_inventory) package_inventory = packages::inventory();
			bool known = false;
			for (const auto& package : package_inventory->packages)
			{
				if (!package.structurally_valid) continue;
				for (const auto& member : package.members) known |= member.state_id == id;
			}
			if (!known)
			{
				error = "package member does not exist or its package is invalid: " + id;
				return false;
			}
			continue;
		}
		if (std::none_of(inventory.begin(), inventory.end(), [&](const ScriptInfo& info)
			{ return info.id == id && info.valid; }))
		{
			error = "script does not exist or is invalid: " + id;
			return false;
		}
	}
	State next;
	{
		std::lock_guard lock(state_mutex);
		next = active_state;
		overlay_requested(next, requested_state);
		for (const auto& [id, enabled] : requests) next[id] = enabled;
	}
	if (!write_state(next, error)) return false;
	{
		std::lock_guard lock(state_mutex);
		for (const auto& [id, enabled] : requests) requested_state[id] = enabled;
	}
	return true;
}
}
