#include "packages.hpp"

#include "config.hpp"
#include "engine_params.hpp"
#include "live_literals.hpp"
#include "replacement_settings_core.hpp"
#include "script_control.hpp"

#include <algorithm>
#include <exception>
#include <fstream>
#include <limits>
#include <mutex>
#include <sstream>
#include <utility>

// The offline gate (RENOVICE_TOOLCHAIN/injection/verify_script_packages.ps1)
// compiles this exact file with stub config/policy providers; only the OpenWF
// console sink is left out there. Every line still reaches config::log.
#ifndef RENOVICE_PACKAGES_OFFLINE_GATE
#include "../owf_console.hpp"
#endif

namespace renovice::packages
{
namespace
{
std::mutex snapshot_mutex;
std::shared_ptr<const Snapshot> active_snapshot = std::make_shared<Snapshot>();
std::shared_ptr<const Snapshot> prepared_snapshot;

void report(const std::string& message)
{
#ifndef RENOVICE_PACKAGES_OFFLINE_GATE
	conout << message << std::endl;
#endif
	config::log(message);
}

bool safe_filename(const std::filesystem::path& path, std::string& output) noexcept
{
	try
	{
		output = path.filename().string();
		return true;
	}
	catch (...)
	{
		output.clear();
		return false;
	}
}

bool read_bounded(
	const std::filesystem::path& path,
	std::uintmax_t maximum,
	std::vector<unsigned char>& bytes
)
{
	bytes.clear();
	std::error_code ec;
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || size == 0 || size >= maximum
		|| size > static_cast<std::uintmax_t>((std::numeric_limits<std::streamsize>::max)()))
	{
		return false;
	}
	bytes.resize(static_cast<std::size_t>(size));
	std::ifstream input(path, std::ios::binary);
	return input && static_cast<bool>(input.read(
		reinterpret_cast<char*>(bytes.data()), static_cast<std::streamsize>(bytes.size())));
}

bool size_admissible(const std::filesystem::path& path, std::uintmax_t maximum)
{
	std::error_code ec;
	const auto size = std::filesystem::file_size(path, ec);
	return !ec && size != 0 && size < maximum;
}

// Loose claims mirror the unchanged loose lanes exactly: a root replacement
// claims its filename key when enabled (bootstrapper hook shims always); an
// enabled loose target addon claims its filename key or its declared keys.
std::vector<SourceClaims> gather_loose_claims()
{
	std::vector<SourceClaims> claims;
	std::error_code ec;
	for (std::filesystem::directory_iterator it(config::replacements_directory(), ec), end;
		!ec && it != end; it.increment(ec))
	{
		if (!it->is_regular_file(ec)) { if (ec) break; continue; }
		std::string name;
		if (!safe_filename(it->path(), name) || !has_lua_bytecode_extension(name)) continue;
		std::uint64_t key = 0;
		if (!replacements::parse_filename_key(name, key)) continue;
		const bool infrastructure = script_control::is_internal_hook_shim(name);
		if (!infrastructure && !script_control::candidate_enabled(
			script_control::stable_id(script_control::Kind::Replacement, name)))
		{
			continue;
		}
		claims.push_back(SourceClaims{"loose:" + name, {key}, {}});
	}
	ec.clear();
	for (std::filesystem::directory_iterator it(config::injection_directory(), ec), end;
		!ec && it != end; it.increment(ec))
	{
		if (!it->is_regular_file(ec)) { if (ec) break; continue; }
		std::string name;
		if (!safe_filename(it->path(), name) || !has_lua_bytecode_extension(name)) continue;
		if (injection::is_internal_infrastructure(name)) continue;
		if (injection::runtime_script_kind(name) != injection::ScriptKind::TargetManagedAddon) continue;
		if (!script_control::candidate_enabled(
			script_control::stable_id(script_control::Kind::TargetAddon, name)))
		{
			continue;
		}
		SourceClaims source{"loose:Inject/" + name, {}, {}};
		if (injection::is_multi_target_addon(name))
		{
			std::vector<unsigned char> bytes;
			std::vector<std::uint64_t> declared;
			if (injection::multi_target_filename_error(name) != nullptr
				|| !read_bounded(it->path(), 1ull << 20, bytes)
				|| injection::discover_multi_target_keys(bytes.data(), bytes.size(), declared) != nullptr)
			{
				continue; // The loose lane rejects this file locally; it binds nothing.
			}
			source.target_keys = std::move(declared);
		}
		else
		{
			std::uint64_t key = 0;
			if (!injection::target_addon_key(name, key)) continue;
			source.target_keys.push_back(key);
		}
		claims.push_back(std::move(source));
	}
	return claims;
}

// Static validation of one package folder. Never throws past its caller's
// boundary; every failure becomes an exact package-local reason.
void scan_package(const std::filesystem::path& folder_path, Package& package, bool committing)
{
	package.structurally_valid = false;
	if (const char* error = folder_name_error(package.folder))
	{
		package.reason = error;
		return;
	}
	std::vector<std::pair<std::string, std::filesystem::path>> files;
	std::filesystem::path manifest_path;
	bool manifest_found = false;
	std::filesystem::path recipe_path; // LIVE_LITERALS_V1 literals.json (optional)
	std::filesystem::path engine_recipe_path; // ENGINE_PARAM_OVERRIDE engine_params.json (optional, R16)
	std::error_code ec;
	for (std::filesystem::directory_iterator it(folder_path, ec), end; !ec && it != end; it.increment(ec))
	{
		if (!it->is_regular_file(ec)) { if (ec) break; continue; }
		std::string name;
		if (!safe_filename(it->path(), name))
		{
			package.reason = "member-filename-not-representable";
			return;
		}
		if (ascii_iequal(name, manifest_filename))
		{
			manifest_found = true;
			manifest_path = it->path();
		}
		else if (has_lua_bytecode_extension(name))
		{
			files.emplace_back(std::move(name), it->path());
		}
		else if (ascii_iequal(name, live_literals::recipe_filename))
		{
			recipe_path = it->path();
		}
		else if (ascii_iequal(name, engine_params::recipe_filename))
		{
			engine_recipe_path = it->path();
		}
		// Any other file (README, SHA256SUMS, ...) is documentation and ignored.
	}
	if (ec)
	{
		package.reason = "package-folder-unreadable";
		return;
	}
	std::sort(files.begin(), files.end(), [](const auto& lhs, const auto& rhs)
	{
		return package_order_less(lhs.first, rhs.first);
	});
	if (files.empty())
	{
		package.reason = "package-has-no-lua_B-members";
		return;
	}
	if (files.size() > maximum_members)
	{
		package.reason = "package-has-too-many-members";
		return;
	}

	Manifest manifest;
	if (manifest_found)
	{
		std::vector<unsigned char> bytes;
		if (!read_bounded(manifest_path, maximum_manifest_bytes + 1, bytes))
		{
			package.reason = "manifest-unreadable-empty-or-too-large";
			return;
		}
		const auto error = parse_manifest(std::string_view(
			reinterpret_cast<const char*>(bytes.data()), bytes.size()), manifest);
		if (!error.empty())
		{
			package.reason = error;
			return;
		}
		std::vector<std::string> disk_members;
		disk_members.reserve(files.size());
		for (const auto& file : files) disk_members.push_back(file.first);
		if (const auto mismatch = reconcile_manifest_members(manifest, disk_members); !mismatch.empty())
		{
			package.reason = mismatch;
			return;
		}
		package.auto_joined = auto_joined_members(manifest, disk_members);
		if (!manifest.name.empty()) package.display = manifest.name;
		package.description = manifest.description;
	}

	// ADDON_SETTINGS_V1 declarations. A bad declaration rejects only the
	// settings capability of this package (members keep compiled defaults).
	{
		std::vector<std::pair<std::string, std::string>> member_jsons;
		for (const auto& declared : manifest.members)
		{
			if (!declared.settings_json.empty())
				member_jsons.emplace_back(declared.filename, declared.settings_json);
		}
		if (settings::declarations_present(manifest.settings_json, member_jsons))
		{
			auto declarations = std::make_shared<settings::Declarations>();
			auto error = settings::parse_declarations(
				manifest.settings_json.empty() ? std::string_view("{}") : std::string_view(manifest.settings_json),
				member_jsons, *declarations);
			if (error.empty()) package.declarations = std::move(declarations);
			else package.settings_reason = std::move(error);
		}
	}
	if (!recipe_path.empty()) live_literals::attach_recipes(package, recipe_path);
	if (!engine_recipe_path.empty()) engine_params::attach_recipe(package, engine_recipe_path);

	std::vector<std::uint64_t> replacement_keys;
	for (const auto& [name, path] : files)
	{
		Member member;
		member.filename = name;
		member.label = manifest_label(manifest, name);
		member.state_id = script_control::member_state_id(package.folder, name);
		// Contract R13: the package row owns enablement; a stored member
		// `false` has no owner since Settings R7 and is reported, not applied.
		member.enabled = true;
		member.policy_off_ignored = !script_control::candidate_enabled(member.state_id);
		if (const char* error = classify_member(name, member.kind, member.key))
		{
			package.reason = "member=" + name + " " + error;
			return;
		}
		if (member.kind == MemberKind::Replacement)
		{
			if (std::find(replacement_keys.begin(), replacement_keys.end(), member.key)
				!= replacement_keys.end())
			{
				package.reason = "member=" + name + " duplicate-replacement-key-in-package key="
					+ key_text(member.key);
				return;
			}
			replacement_keys.push_back(member.key);
			const bool keep = committing && package.enabled;
			if (keep ? !read_bounded(path, maximum_replacement_bytes, member.bytes)
				: !size_admissible(path, maximum_replacement_bytes))
			{
				package.reason = "member=" + name + " unreadable-empty-or-oversized";
				return;
			}
		}
		else
		{
			if (!read_bounded(path, 1ull << 20, member.bytes))
			{
				package.reason = "member=" + name + " unreadable-empty-or-oversized";
				return;
			}
			if (member.kind == MemberKind::MultiTargetAddon)
			{
				if (const char* error = injection::discover_multi_target_keys(
					member.bytes.data(), member.bytes.size(), member.target_keys))
				{
					package.reason = "member=" + name + " " + error;
					return;
				}
			}
			else if (member.kind == MemberKind::TargetAddon)
			{
				member.target_keys.push_back(member.key);
			}
			if (!(committing && package.enabled))
			{
				member.bytes.clear();
				member.bytes.shrink_to_fit();
			}
		}
		package.members.push_back(std::move(member));
	}
	package.structurally_valid = true;
}

SourceClaims package_claims(const Package& package)
{
	SourceClaims claims{"package:" + package.folder, {}, {}};
	for (const auto& member : package.members)
	{
		// Contract R13: members follow their package row (always enabled);
		// the check stays so a future owner of member policy keeps the
		// loose-file rule (a disabled member claims nothing).
		if (!member.enabled) continue;
		if (member.kind == MemberKind::Replacement) claims.replacement_keys.push_back(member.key);
		claims.target_keys.insert(
			claims.target_keys.end(), member.target_keys.begin(), member.target_keys.end());
	}
	return claims;
}

void log_package(const Package& package, const char* trigger)
{
	std::ostringstream line;
	if (!package.structurally_valid || (package.enabled && !package.accepted))
	{
		line << "RENOVICE PACKAGE REJECT trigger=" << trigger
			<< " package=" << package.folder << " id=" << package.id
			<< " enabled=" << (package.enabled ? 1 : 0)
			<< " reason=" << package.reason
			<< " scope=package-local generation=continues";
		report(line.str());
		return;
	}
	std::size_t replacements = 0, target_addons = 0, declared = 0;
	for (const auto& member : package.members)
	{
		if (member.kind == MemberKind::Replacement) ++replacements;
		else ++target_addons;
		declared += member.target_keys.size();
	}
	line << "RENOVICE PACKAGE " << (package.accepted ? "ACCEPT" : "DISABLED")
		<< " trigger=" << trigger
		<< " package=" << package.folder << " id=" << package.id
		<< " members=" << package.members.size()
		<< " replacements=" << replacements
		<< " target_addons=" << target_addons
		<< " target_keys=" << declared
		<< (package.accepted ? " lanes=replacement+inject" : " inventory-only=1")
		<< " auto_joined=" << package.auto_joined.size();
	report(line.str());
	for (const auto& name : package.auto_joined)
	{
		report("RENOVICE PACKAGE MEMBER AUTO-JOIN trigger=" + std::string(trigger)
			+ " package=" + package.folder + " member=" + name
			+ " reason=not-listed-in-package.json label=from-filename");
	}
}

// ---------------------------------------------------------------------------
// ADDON_SETTINGS_V1 + member policy (2026-09-30). Runs after the package's
// acceptance is known. Every decision is local to this package.
// ---------------------------------------------------------------------------
std::filesystem::path settings_file_path(std::string_view folder)
{
	return config::settings_directory()
		/ std::filesystem::path(settings::values_file_name(folder));
}

// Returns false when the file is absent. On a read or parse failure it returns
// true with a non-empty error (the package reverts to stock).
bool read_values_file(
	const Package& package, settings::UserState& state, std::string& error)
{
	error.clear();
	if (config::layout_v2())
	{
		// LAYOUT_V2: the values entry `package.id` of Config/ScriptStates.json, same parser.
		std::string text;
		bool present = false;
		if (!script_control::read_package_values(package.id, text, present, error)) return false;
		if (!error.empty()) return true;
		if (text.size() > settings::maximum_values_file_bytes)
		{
			error = "values-file-unreadable-empty-or-too-large";
			return true;
		}
		error = settings::parse_values_file(text, package.id, state);
		return true;
	}
	const auto path = settings_file_path(package.folder);
	std::error_code ec;
	if (!std::filesystem::exists(path, ec))
	{
		if (ec) error = "values-file-unreadable";
		return !error.empty();
	}
	std::vector<unsigned char> bytes;
	if (!read_bounded(path, settings::maximum_values_file_bytes + 1, bytes))
	{
		error = "values-file-unreadable-empty-or-too-large";
		return true;
	}
	error = settings::parse_values_file(std::string_view(
		reinterpret_cast<const char*>(bytes.data()), bytes.size()), package.id, state);
	return true;
}

std::string short_identity(const std::string& identity)
{
	const auto colon = identity.find(':');
	const auto hex = colon == std::string::npos ? identity : identity.substr(colon + 1);
	return hex.substr(0, 16);
}

void apply_member_policy_and_settings(Package& package, bool committing, const char* trigger)
{
	for (auto& member : package.members) member.staged = package.accepted && member.enabled;
	if (trigger != nullptr && package.accepted)
	{
		for (const auto& member : package.members)
		{
			if (!member.policy_off_ignored) continue;
			report("RENOVICE PACKAGE MEMBER POLICY IGNORED trigger=" + std::string(trigger)
				+ " package=" + package.folder + " member=" + member.filename
				+ " id=" + member.state_id + " stored=false reason=member-switch-retired-R13"
				+ " owner=" + package.id + " file=unchanged");
		}
	}
	if (!package.settings_reason.empty() && trigger != nullptr)
	{
		report("RENOVICE SETTINGS DECLARATIONS REJECT trigger=" + std::string(trigger)
			+ " package=" + package.folder + " reason=" + package.settings_reason
			+ " scope=settings-capability-local members=compiled-defaults");
	}
	if (!package.declarations || !committing)
	{
		if (committing) live_literals::resolve_package_plans(package, nullptr, settings::PackageEvaluation{}, trigger);
		return;
	}
	const auto& declarations = *package.declarations;
	settings::UserState state;
	std::string file_error;
	const bool present = read_values_file(package, state, file_error);
	const auto evaluation = settings::evaluate(
		declarations, present && file_error.empty() ? &state : nullptr, file_error);
	const settings::UserState* usable = evaluation.file == settings::FileStatus::Valid ? &state : nullptr;
	std::size_t staged = 0;
	for (auto& member : package.members)
	{
		if (member.kind == MemberKind::Replacement)
		{
			if (member.staged && !settings::literal_member_admitted(
				declarations, usable, evaluation, member.filename))
			{
				member.staged = false;
				if (trigger != nullptr)
				{
					report("RENOVICE SETTINGS LITERAL MEMBER STOCK trigger=" + std::string(trigger)
						+ " package=" + package.folder + " member=" + member.filename
						+ " reason=literal-values-not-enabled scope=member-local");
				}
			}
		}
		// REPLACEMENT_SETTINGS_V1: a replacement member that declares addon-lane
		// values also gets a delivery (read through RENOVICE_SCRIPT_SETTINGS);
		// addon members keep the ADDON_SETTINGS_V1 rule unchanged.
		if (replacement_settings::member_receives_delivery(
			member.kind == MemberKind::Replacement, declarations, member.filename))
		{
			member.delivery = settings::member_delivery(
				declarations, usable, evaluation, member.filename);
		}
		if (member.staged) ++staged;
	}
	live_literals::resolve_package_plans(package, usable, evaluation, trigger);
	// ENGINE_PARAM_OVERRIDE (R16): the plan comes from the member's delivery
	// (the exact values the addon would get); the owned values are withheld
	// from that delivery while the native hook is installed.
	engine_params::resolve_package(package, trigger);
	if (trigger == nullptr) return;
	if (evaluation.file == settings::FileStatus::Malformed)
	{
		report("RENOVICE SETTINGS FILE REJECT trigger=" + std::string(trigger)
			+ " package=" + package.folder + " file=" + (config::layout_v2()
				? "Config/ScriptStates.json#" + package.id
				: "Settings/" + settings::values_file_name(package.folder))
			+ " reason=" + evaluation.file_reason + " scope=package-local values=stock");
	}
	std::size_t logged = 0;
	for (const auto& rejection : evaluation.rejections)
	{
		if (logged++ == settings::maximum_logged_value_rejections) break;
		report("RENOVICE SETTINGS VALUE REJECT trigger=" + std::string(trigger)
			+ " package=" + package.folder + " id=" + rejection.id
			+ " reason=" + rejection.reason + " scope=value-local value="
			+ (evaluation.defaulted.count(rejection.id) != 0 ? "default" : "stock"));
	}
	if (evaluation.rejections.size() > settings::maximum_logged_value_rejections)
	{
		report("RENOVICE SETTINGS VALUE REJECT trigger=" + std::string(trigger)
			+ " package=" + package.folder + " suppressed="
			+ std::to_string(evaluation.rejections.size() - settings::maximum_logged_value_rejections));
	}
	std::ostringstream summary;
	summary << "RENOVICE SETTINGS PACKAGE trigger=" << trigger
		<< " package=" << package.folder
		<< " declarations=" << declarations.values.size()
		<< " groups=" << declarations.groups.size()
		<< " file=" << settings::file_status_label(evaluation.file)
		<< " use_stock=" << (evaluation.use_stock ? 1 : 0)
		<< " effective=" << evaluation.effective.size();
	// R7: declared defaults delivered without a file entry (field only when used,
	// so V1 packages keep the exact line).
	if (!evaluation.defaulted.empty()) summary << " defaults=" << evaluation.defaulted.size();
	summary
		<< " rejected=" << evaluation.rejections.size()
		<< " unknown_entries=" << evaluation.unknown_entries
		<< " members_staged=" << staged << "/" << package.members.size();
	report(summary.str());
	for (const auto& member : package.members)
	{
		if (!member.delivery) continue;
		report("RENOVICE SETTINGS DELIVERY trigger=" + std::string(trigger)
			+ " package=" + package.folder + " member=" + member.filename
			+ " values=" + std::to_string(member.delivery->values.size())
			+ " identity=" + short_identity(member.delivery->identity)
			+ " staged=" + (member.staged ? "1" : "0"));
	}
}

// Returns false only when the Packages root exists but cannot be enumerated.
bool scan(Snapshot& output, bool committing, const char* trigger)
{
	output.packages.clear();
	const auto root = directory();
	std::error_code ec;
	if (!std::filesystem::is_directory(root, ec))
	{
		// Absent (the normal case) or not a folder: packages are optional.
		return true;
	}
	std::vector<std::pair<std::string, std::filesystem::path>> folders;
	std::size_t unrepresentable = 0;
	for (std::filesystem::directory_iterator it(root, ec), end; !ec && it != end; it.increment(ec))
	{
		if (!it->is_directory(ec)) { if (ec) break; continue; }
		std::string name;
		if (!safe_filename(it->path(), name))
		{
			++unrepresentable;
			continue;
		}
		folders.emplace_back(std::move(name), it->path());
	}
	if (ec)
	{
		if (trigger != nullptr)
			report("RENOVICE PACKAGES scan FAIL reason=packages-root-unreadable error=" + ec.message());
		return false;
	}
	if (unrepresentable != 0 && trigger != nullptr)
	{
		report("RENOVICE PACKAGE REJECT trigger=" + std::string(trigger)
			+ " folders=" + std::to_string(unrepresentable)
			+ " reason=package-folder-name-not-representable scope=package-local generation=continues");
	}
	std::sort(folders.begin(), folders.end(), [](const auto& lhs, const auto& rhs)
	{
		return package_order_less(lhs.first, rhs.first);
	});

	for (std::size_t i = 0; i != folders.size(); ++i)
	{
		Package package;
		package.folder = folders[i].first;
		package.id = state_id(package.folder);
		package.display = package.folder;
		package.enabled = script_control::candidate_enabled(package.id);
		if (i >= maximum_packages)
		{
			package.reason = "too-many-packages";
		}
		else
		{
			try
			{
				scan_package(folders[i].second, package, committing);
			}
			catch (const std::exception&)
			{
				package.members.clear();
				package.structurally_valid = false;
				package.reason = "package-scan-exception";
			}
		}
		output.packages.push_back(std::move(package));
	}

	std::vector<SourceClaims> eligible_claims;
	std::vector<std::size_t> eligible_index;
	for (std::size_t i = 0; i != output.packages.size(); ++i)
	{
		const auto& package = output.packages[i];
		if (!package.structurally_valid || !package.enabled) continue;
		eligible_claims.push_back(package_claims(package));
		eligible_index.push_back(i);
	}
	if (!eligible_claims.empty())
	{
		const auto decisions = resolve_conflicts(gather_loose_claims(), eligible_claims);
		for (std::size_t j = 0; j != decisions.size(); ++j)
		{
			auto& package = output.packages[eligible_index[j]];
			package.accepted = decisions[j].accepted;
			if (!decisions[j].accepted) package.reason = decisions[j].reason;
		}
	}
	for (auto& package : output.packages)
	{
		if (package.structurally_valid) apply_member_policy_and_settings(package, committing, trigger);
	}
	if (committing) engine_params::resolve_conflicts(output, trigger);

	std::size_t accepted = 0, disabled = 0, rejected = 0;
	for (auto& package : output.packages)
	{
		if (!package.accepted)
		{
			// Only accepted, enabled packages keep bytes; keys stay for inventory.
			for (auto& member : package.members)
			{
				member.bytes.clear();
				member.bytes.shrink_to_fit();
			}
		}
		else
		{
			// A member held back by its policy or the literal settings gate keeps
			// its keys (inventory) but no bytes can enter a lane.
			for (auto& member : package.members)
			{
				if (member.staged) continue;
				member.bytes.clear();
				member.bytes.shrink_to_fit();
			}
		}
		if (package.accepted) ++accepted;
		else if (package.structurally_valid && !package.enabled) ++disabled;
		else ++rejected;
		if (trigger != nullptr) log_package(package, trigger);
	}
	if (trigger != nullptr && !output.packages.empty())
	{
		report("RENOVICE PACKAGES scan PASS trigger=" + std::string(trigger)
			+ " packages=" + std::to_string(output.packages.size())
			+ " accepted=" + std::to_string(accepted)
			+ " disabled=" + std::to_string(disabled)
			+ " rejected=" + std::to_string(rejected));
	}
	return true;
}
}

std::filesystem::path settings_values_path(std::string_view folder)
{
	return settings_file_path(folder);
}

bool read_settings_values(const Package& package, settings::UserState& state, std::string& error)
{
	return read_values_file(package, state, error);
}

std::filesystem::path directory()
{
	return config::packages_directory();
}

bool initialise()
{
	auto snapshot = std::make_shared<Snapshot>();
	const bool scanned = scan(*snapshot, true, "startup");
	std::lock_guard lock(snapshot_mutex);
	// A root I/O error at startup fails closed for packages only: no package
	// member enters any lane, every loose script is unaffected.
	active_snapshot = scanned ? std::shared_ptr<const Snapshot>(std::move(snapshot))
		: std::make_shared<Snapshot>();
	prepared_snapshot.reset();
	// ENGINE_PARAM_OVERRIDE (R16): the startup plan is the committed generation.
	engine_params::publish(engine_params::build_snapshot(active_snapshot.get()), "startup");
	return scanned;
}

bool prepare_reload()
{
	auto snapshot = std::make_shared<Snapshot>();
	if (!scan(*snapshot, true, "F9")) return false;
	// ENGINE_PARAM_OVERRIDE (R16): prepared with the package snapshot; the hook
	// sees it only after the F9 commit.
	engine_params::prepare(engine_params::build_snapshot(snapshot.get()));
	std::lock_guard lock(snapshot_mutex);
	prepared_snapshot = std::move(snapshot);
	return true;
}

void commit_prepared_reload()
{
	std::lock_guard lock(snapshot_mutex);
	if (!prepared_snapshot) return;
	active_snapshot = std::move(prepared_snapshot);
	prepared_snapshot.reset();
	engine_params::commit_prepared("F9");
}

void discard_prepared_reload()
{
	std::lock_guard lock(snapshot_mutex);
	prepared_snapshot.reset();
	engine_params::discard_prepared();
}

std::shared_ptr<const Snapshot> candidate()
{
	std::lock_guard lock(snapshot_mutex);
	return prepared_snapshot ? prepared_snapshot : active_snapshot;
}

std::shared_ptr<const Snapshot> inventory()
{
	auto snapshot = std::make_shared<Snapshot>();
	try
	{
		(void)scan(*snapshot, false, nullptr);
	}
	catch (const std::exception&)
	{
		snapshot->packages.clear();
	}
	return snapshot;
}
}
