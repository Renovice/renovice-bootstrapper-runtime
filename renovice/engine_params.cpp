#include "engine_params.hpp"

#include "config.hpp"

#include <algorithm>
#include <atomic>
#include <cstring>
#include <exception>
#include <fstream>
#include <mutex>
#include <sstream>
#include <type_traits>
#include <utility>

// The offline gates (verify_engine_params.ps1 and every gate that builds
// packages.cpp) compile this file with RENOVICE_PACKAGES_OFFLINE_GATE: the
// plan, recipe and withholding rules are the production code; the native
// install, the detour and the loaded-image reads are left out there and are
// exercised through engine_params_core.hpp and the image byte gate instead.
#ifndef RENOVICE_PACKAGES_OFFLINE_GATE
#include "../owf_console.hpp"
#include "de_proto_graph_u43.hpp"
#include "diagnostic_read_probe.hpp"
#include <DetourHook.hpp>
#include <Module.hpp>
#include <winsock2.h>
#include <windows.h>
#endif

namespace renovice::engine_params
{
namespace
{
std::mutex state_mutex;
std::string executable_digest;
std::atomic<const BuildRegistration*> registration = nullptr;   // set once, before `installed_flag`
std::atomic_bool installed_flag = false;
// Generation-owned plan the hook reads; `armed` is the lock-free fast gate.
std::atomic<std::shared_ptr<const PlanSnapshot>> active_plan{std::make_shared<const PlanSnapshot>()};
std::shared_ptr<const PlanSnapshot> prepared_plan;   // guarded by state_mutex
std::atomic_bool armed = false;
// Process-owned module identities and the modules any recipe has named.
std::atomic<std::shared_ptr<const IdentitySnapshot>> identities{std::make_shared<const IdentitySnapshot>()};
std::atomic<std::shared_ptr<const std::vector<std::uint64_t>>> wanted_modules{
	std::make_shared<const std::vector<std::uint64_t>>()};
std::atomic<std::uint64_t> identity_sequence = 0;
// Bounded diagnostics (Diagnostics=false: nothing below is formatted).
constexpr std::uint64_t maximum_apply_lines = 64;
constexpr std::uint64_t maximum_skip_lines = 16;
std::atomic<std::uint64_t> apply_lines = 0, skip_lines = 0;
std::atomic_bool apply_suppressed_reported = false, skip_suppressed_reported = false;

void report(const std::string& message)
{
#ifndef RENOVICE_PACKAGES_OFFLINE_GATE
	conout << message << std::endl;
#endif
	config::log(message);
}

bool read_recipe(const std::filesystem::path& path, std::string& text)
{
	text.clear();
	std::error_code ec;
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || size == 0 || size > maximum_recipe_bytes) return false;
	text.resize(static_cast<std::size_t>(size));
	std::ifstream input(path, std::ios::binary);
	return input && static_cast<bool>(input.read(text.data(), static_cast<std::streamsize>(text.size())));
}

void remember_wanted(const std::vector<std::uint64_t>& modules)
{
	if (modules.empty()) return;
	std::lock_guard lock(state_mutex);
	const auto current = wanted_modules.load(std::memory_order_acquire);
	std::vector<std::uint64_t> next = *current;
	next.insert(next.end(), modules.begin(), modules.end());
	std::sort(next.begin(), next.end());
	next.erase(std::unique(next.begin(), next.end()), next.end());
	if (next.size() == current->size()) return;
	wanted_modules.store(std::make_shared<const std::vector<std::uint64_t>>(std::move(next)), std::memory_order_release);
}

void set_active(std::shared_ptr<const PlanSnapshot> plan)
{
	if (!plan) plan = std::make_shared<const PlanSnapshot>();
	const bool any = !plan->entries.empty();
	active_plan.store(std::move(plan), std::memory_order_release);
	apply_lines.store(0, std::memory_order_relaxed);
	skip_lines.store(0, std::memory_order_relaxed);
	apply_suppressed_reported.store(false, std::memory_order_relaxed);
	skip_suppressed_reported.store(false, std::memory_order_relaxed);
	armed.store(any && installed_flag.load(std::memory_order_acquire), std::memory_order_release);
}

void log_plan(const PlanSnapshot& plan, const char* trigger)
{
	if (trigger == nullptr) return;
	std::ostringstream line;
	line << "RENOVICE ENGINE PARAMS PLAN trigger=" << trigger << " installed=" << (installed() ? 1 : 0)
		<< " overrides=" << plan.entries.size() << " hashes=" << plan.hashes.size()
		<< " modules=" << plan.modules.size() << " identity=" << plan.identity.substr(0, 33);
	report(line.str());
}

#ifndef RENOVICE_PACKAGES_OFFLINE_GATE
// ---------------------------------------------------------------------------
// Native hook (process-owned).
// ---------------------------------------------------------------------------
using PushValue = void (*)(void* state, void* instance, const void* record, std::intptr_t index);
soup::DetourHook push_value_hook;
std::atomic<PushValue> push_value_original = nullptr;

// Stack slots, the state and the record are owned by the engine frame that
// called the writer; heap objects (closure, prototype, code) are probed.
struct LiveMemory
{
	bool read(std::uintptr_t address, void* out, std::size_t size) const noexcept
	{
		if (address < 0x10000) return false;
		std::memcpy(out, reinterpret_cast<const void*>(address), size);
		return true;
	}
	bool read_checked(std::uintptr_t address, void* out, std::size_t size) const noexcept
	{
		if (address < 0x10000 || diagnostics::bad_read_ptr(reinterpret_cast<const void*>(address), size)) return false;
		std::memcpy(out, reinterpret_cast<const void*>(address), size);
		return true;
	}
	void write(std::uintptr_t address, const void* in, std::size_t size) const noexcept
	{
		std::memcpy(reinterpret_cast<void*>(address), in, size);
	}
};

bool diagnostics_on() noexcept
{
	return config::diagnostics_mode() >= config::DiagnosticsMode::battle;
}

void report_skip(const Candidate& candidate, std::uint64_t key) noexcept
{
	if (!diagnostics_on()) return;
	try
	{
		if (skip_lines.fetch_add(1, std::memory_order_relaxed) >= maximum_skip_lines)
		{
			if (!skip_suppressed_reported.exchange(true))
				config::diagnostic_log("RENOVICE ENGINE_PARAM SKIP suppressed=1 limit=" + std::to_string(maximum_skip_lines),
					config::DiagnosticsMode::battle);
			return;
		}
		std::ostringstream line;
		line << "RENOVICE ENGINE_PARAM SKIP reason=" << skip_label(candidate.skip) << " hash=" << hex32(candidate.hash)
			<< " key=" << hex64(key) << " vm=0x" << std::hex << candidate.vm << " proto=0x" << candidate.proto << std::dec
			<< " index=" << candidate.index << " thread=" << GetCurrentThreadId() << " stock=kept";
		config::diagnostic_log(line.str(), config::DiagnosticsMode::battle);
	}
	catch (...)
	{
	}
}

// POD decision taken before the stock push. Nothing with a destructor is
// alive across the stock call (a DE error longjmp out of a non-number push
// must not skip a C++ destructor), so the plan reference is released first.
struct Decision
{
	bool matched = false;
	Candidate candidate;
	std::uint64_t key = 0;
	Mode mode = Mode::Absolute;
	float value = 0.0f;
};
static_assert(std::is_trivially_copyable_v<Decision>);

void report_apply(const Decision& decision, const Applied& applied) noexcept
{
	if (!diagnostics_on()) return;
	try
	{
		if (apply_lines.fetch_add(1, std::memory_order_relaxed) >= maximum_apply_lines)
		{
			if (!apply_suppressed_reported.exchange(true))
				config::diagnostic_log("RENOVICE ENGINE_PARAM APPLY suppressed=1 limit=" + std::to_string(maximum_apply_lines),
					config::DiagnosticsMode::battle);
			return;
		}
		// Names for the line come from the plan committed now (display only).
		const auto plan = active_plan.load(std::memory_order_acquire);
		const PlanEntry* entry = plan ? plan->find(decision.key, decision.candidate.hash) : nullptr;
		std::ostringstream line;
		line.precision(9);
		line << "RENOVICE ENGINE_PARAM " << (applied.skip == Skip::None ? "APPLY" : "SKIP")
			<< " key=" << hex64(decision.key) << " hash=" << hex32(decision.candidate.hash)
			<< " parameter=" << (entry ? entry->parameter : std::string("?"))
			<< " value_id=" << (entry ? entry->value_id : std::string("?")) << " mode=" << mode_label(decision.mode)
			<< " value=" << decision.value << " stock=" << applied.stock
			<< " written=" << (applied.skip == Skip::None ? applied.written : applied.stock)
			<< " index=" << decision.candidate.index << " vm=0x" << std::hex << decision.candidate.vm << std::dec
			<< " thread=" << GetCurrentThreadId() << " plan=" << (plan ? plan->identity.substr(0, 33) : std::string("?"));
		if (applied.skip != Skip::None) line << " reason=" << skip_label(applied.skip);
		config::diagnostic_log(line.str(), config::DiagnosticsMode::battle);
	}
	catch (...)
	{
	}
}

Decision decide(const BuildRegistration& build, void* state, const void* record, std::intptr_t index) noexcept
{
	Decision decision;
	try
	{
		const auto plan = active_plan.load(std::memory_order_acquire);
		if (!plan || plan->entries.empty()) return decision;
		LiveMemory memory;
		decision.candidate = classify(build.layout, memory, reinterpret_cast<std::uintptr_t>(state),
			reinterpret_cast<std::uintptr_t>(record), index, *plan);
		if (decision.candidate.skip == Skip::None)
		{
			const auto known = identities.load(std::memory_order_acquire);
			decision.key = known ? module_of(build.layout, memory, *known, decision.candidate.vm, decision.candidate.proto) : 0;
			const PlanEntry* entry = decision.key != 0 ? plan->find(decision.key, decision.candidate.hash) : nullptr;
			if (decision.key == 0) decision.candidate.skip = Skip::ModuleUnknown;
			else if (entry == nullptr) decision.candidate.skip = Skip::OverrideNotDeclared;
			else
			{
				decision.mode = entry->mode;
				decision.value = entry->value;
				decision.matched = true;
			}
		}
		// Only a declared parameter name can be worth a line; everything
		// before the hash check is the ordinary stock path.
		if (!decision.matched && decision.candidate.skip > Skip::HashNotDeclared) report_skip(decision.candidate, decision.key);
	}
	catch (...)
	{
		decision.matched = false;
	}
	return decision;
}

// The stock push runs exactly once with the original arguments on every path.
void push_value_detour(void* state, void* instance, const void* record, std::intptr_t index)
{
	const auto stock = push_value_original.load(std::memory_order_acquire);
	if (!armed.load(std::memory_order_acquire))
	{
		stock(state, instance, record, index);
		return;
	}
	const BuildRegistration* build = registration.load(std::memory_order_acquire);
	const Decision decision = build != nullptr ? decide(*build, state, record, index) : Decision{};
	stock(state, instance, record, index);
	if (!decision.matched) return;
	try
	{
		LiveMemory memory;
		const auto applied = apply_pushed(build->layout, memory, reinterpret_cast<std::uintptr_t>(state), decision.candidate,
			decision.mode, decision.value);
		report_apply(decision, applied);
	}
	catch (...)
	{
	}
}

const char* install(const BuildRegistration*& admitted)
{
	admitted = nullptr;
	std::string digest;
	{
		std::lock_guard lock(state_mutex);
		digest = executable_digest;
	}
	if (digest.empty()) return "executable-digest-unavailable";
	const auto* build = registration_for_digest(digest);
	if (build == nullptr) return "unregistered-executable";
	const auto range = soup::Module(nullptr).range;
	if (const char* reason = admit_image(*build, range.base.as<const std::uint8_t*>(), range.size)) return reason;
	auto* target = range.base.add(build->push_value_rva).as<void*>();
	try
	{
		push_value_hook.target = target;
		push_value_hook.detour = reinterpret_cast<void*>(&push_value_detour);
		push_value_hook.create();
		if (!push_value_hook.isCreated() || push_value_hook.original == nullptr) return "trampoline-creation";
		push_value_original.store(reinterpret_cast<PushValue>(push_value_hook.original), std::memory_order_release);
		registration.store(build, std::memory_order_release);
		push_value_hook.enable();
	}
	catch (...)
	{
		if (push_value_hook.isCreated())
		{
			push_value_hook.disable();
			push_value_hook.destroy();
		}
		registration.store(nullptr, std::memory_order_release);
		return "trampoline-exception";
	}
	admitted = build;
	return nullptr;
}

bool any_recipe_present()
{
	std::error_code ec;
	const auto root = packages::directory();
	if (!std::filesystem::is_directory(root, ec)) return false;
	for (std::filesystem::directory_iterator it(root, ec), end; !ec && it != end; it.increment(ec))
	{
		if (!it->is_directory(ec)) continue;
		if (std::filesystem::is_regular_file(it->path() / std::filesystem::path(std::string(recipe_filename)), ec))
			return true;
		ec.clear();
	}
	return false;
}
#endif
}

void set_executable_digest(std::string_view digest) noexcept
{
	try
	{
		std::lock_guard lock(state_mutex);
		executable_digest.assign(digest);
	}
	catch (...)
	{
	}
}

bool initialise()
{
#ifdef RENOVICE_PACKAGES_OFFLINE_GATE
	return installed();
#else
	try
	{
		if (installed()) return true;
		if (!any_recipe_present())
		{
			config::log("RENOVICE ENGINE PARAMS hook=not-installed reason=no-package-declares-engine_params.json");
			return false;
		}
		const BuildRegistration* build = nullptr;
		if (const char* reason = install(build))
		{
			report(std::string("RENOVICE ENGINE PARAMS hook=FAIL reason=") + reason
				+ " scope=capability-local values=addon-lua-lane");
			return false;
		}
		installed_flag.store(true, std::memory_order_release);
		report("RENOVICE ENGINE PARAMS hook=PASS build=\"" + std::string(build->label) + "\" target=push_value rva=0x"
			+ hex32(static_cast<std::uint32_t>(build->push_value_rva)) + " checks=" + std::to_string(build->checks.size())
			+ " lifecycle=process-owned");
		return true;
	}
	catch (...)
	{
		config::log("RENOVICE ENGINE PARAMS hook=FAIL reason=native-exception scope=capability-local values=addon-lua-lane");
		return false;
	}
#endif
}

bool installed() noexcept
{
	return installed_flag.load(std::memory_order_acquire) && registration.load(std::memory_order_acquire) != nullptr;
}

#ifdef RENOVICE_PACKAGES_OFFLINE_GATE
void gate_set_installed(const BuildRegistration* build) noexcept
{
	registration.store(build, std::memory_order_release);
	installed_flag.store(build != nullptr, std::memory_order_release);
}
#endif

void attach_recipe(packages::Package& package, const std::filesystem::path& path)
{
	package.engine_recipe.reset();
	package.engine_params_reason.clear();
	try
	{
		std::string text;
		if (!read_recipe(path, text))
		{
			package.engine_params_reason = "recipe-unreadable-empty-or-too-large";
			return;
		}
		auto recipe = std::make_shared<Recipe>();
		if (auto error = parse_recipe(text, package.id, *recipe); !error.empty())
		{
			package.engine_params_reason = std::move(error);
			return;
		}
		remember_wanted(recipe->modules());
		package.engine_recipe = std::move(recipe);
	}
	catch (const std::exception&)
	{
		package.engine_recipe.reset();
		package.engine_params_reason = "recipe-exception";
	}
}

void resolve_package(packages::Package& package, const char* trigger)
{
	package.engine_plan.clear();
	package.engine_full_delivery.reset();
	if (!package.engine_recipe && package.engine_params_reason.empty()) return;
	std::string reason = package.engine_params_reason;
	const Recipe* recipe = package.engine_recipe.get();
	const BuildRegistration* build = registration.load(std::memory_order_acquire);
	packages::Member* member = nullptr;
	if (reason.empty())
	{
		for (auto& candidate : package.members)
			if (candidate.filename == recipe->member) member = &candidate;
		if (member == nullptr) reason = "recipe-member-not-in-package";
		else if (!package.declarations) reason = "package-settings-declarations-rejected";
	}
	// Declarations are always checked; the name hashes need the running
	// build's seed and are checked whenever the hook is installed.
	if (reason.empty())
		reason = validate_recipe(*recipe, *package.declarations, build != nullptr ? build->name_hash_seed : 0, build != nullptr);
	if (!reason.empty())
	{
		package.engine_params_reason = reason;
		if (trigger != nullptr)
			report("RENOVICE ENGINE PARAMS RECIPE REJECT trigger=" + std::string(trigger) + " package=" + package.folder
				+ " reason=" + reason + " scope=recipe-local values=addon-lua-lane");
		return;
	}
	const bool lane = installed() && package.accepted && member->staged && member->delivery != nullptr;
	if (lane)
	{
		package.engine_plan = resolve_entries(*recipe, member->delivery.get());
		package.engine_full_delivery = member->delivery;   // kept to restore on a conflict
		member->delivery = withhold(*member->delivery, recipe->value_ids());
	}
	if (trigger == nullptr) return;
	std::ostringstream line;
	line << "RENOVICE ENGINE PARAMS RECIPE ACCEPT trigger=" << trigger << " package=" << package.folder
		<< " member=" << recipe->member << " overrides=" << recipe->overrides.size()
		<< " modules=" << recipe->modules().size() << " values=" << recipe->value_ids().size()
		<< " lane=" << (lane ? "native" : (installed() ? "inactive" : "addon-lua-not-installed"))
		<< " applying=" << package.engine_plan.size();
	if (lane) line << " withheld_from_addon=" << recipe->value_ids().size();
	report(line.str());
	std::size_t logged = 0;
	for (const auto& entry : package.engine_plan)
	{
		if (logged++ == 32) break;
		std::ostringstream item;
		item.precision(9);
		item << "RENOVICE ENGINE PARAMS OVERRIDE trigger=" << trigger << " package=" << package.folder
			<< " key=" << hex64(entry.module) << " hash=" << hex32(entry.hash) << " parameter=" << entry.parameter
			<< " value_id=" << entry.value_id << " mode=" << mode_label(entry.mode) << " value=" << entry.value;
		report(item.str());
	}
}

void resolve_conflicts(packages::Snapshot& snapshot, const char* trigger)
{
	std::map<std::pair<std::uint64_t, std::uint32_t>, std::string> owners;
	for (auto& package : snapshot.packages)
	{
		if (!package.engine_recipe || !package.engine_full_delivery) continue;
		std::string holder;
		for (const auto& item : package.engine_recipe->overrides)
		{
			const auto found = owners.find({item.module, item.hash});
			if (found != owners.end()) { holder = found->second; break; }
		}
		if (holder.empty())
		{
			for (const auto& item : package.engine_recipe->overrides) owners.emplace(std::make_pair(item.module, item.hash), package.folder);
			continue;
		}
		for (auto& member : package.members)
			if (member.filename == package.engine_recipe->member) member.delivery = package.engine_full_delivery;
		package.engine_plan.clear();
		package.engine_full_delivery.reset();
		if (trigger != nullptr)
			report("RENOVICE ENGINE PARAMS RECIPE REJECT trigger=" + std::string(trigger) + " package=" + package.folder
				+ " reason=parameter-owned-by holder=package:" + holder + " scope=recipe-local values=addon-lua-lane");
	}
}

std::shared_ptr<const PlanSnapshot> build_snapshot(const packages::Snapshot* snapshot)
{
	std::vector<PlanEntry> entries;
	std::vector<std::uint64_t> modules;
	if (snapshot != nullptr)
	{
		for (const auto& package : snapshot->packages)
		{
			if (!package.engine_recipe) continue;
			const auto keys = package.engine_recipe->modules();
			modules.insert(modules.end(), keys.begin(), keys.end());
			if (!package.accepted) continue;
			entries.insert(entries.end(), package.engine_plan.begin(), package.engine_plan.end());
		}
	}
	return make_snapshot(std::move(entries), std::move(modules));
}

void publish(std::shared_ptr<const PlanSnapshot> snapshot, const char* trigger) noexcept
{
	try
	{
		std::lock_guard lock(state_mutex);
		prepared_plan.reset();
		set_active(snapshot);
		if (snapshot && (!snapshot->modules.empty() || installed())) log_plan(*snapshot, trigger);
	}
	catch (...)
	{
	}
}

void prepare(std::shared_ptr<const PlanSnapshot> snapshot) noexcept
{
	std::lock_guard lock(state_mutex);
	prepared_plan = snapshot ? std::move(snapshot) : std::make_shared<const PlanSnapshot>();
}

void commit_prepared(const char* trigger) noexcept
{
	try
	{
		std::lock_guard lock(state_mutex);
		if (!prepared_plan) return;
		auto plan = std::move(prepared_plan);
		prepared_plan.reset();
		const bool loggable = !plan->modules.empty() || installed();
		set_active(plan);
		if (loggable) log_plan(*plan, trigger);
	}
	catch (...)
	{
	}
}

void discard_prepared() noexcept
{
	std::lock_guard lock(state_mutex);
	prepared_plan.reset();
}

std::shared_ptr<const PlanSnapshot> active() noexcept
{
	return active_plan.load(std::memory_order_acquire);
}

bool observing() noexcept
{
	return installed() && !wanted_modules.load(std::memory_order_acquire)->empty();
}

bool module_wanted(std::uint64_t key) noexcept
{
	if (key == 0 || !installed()) return false;
	const auto wanted = wanted_modules.load(std::memory_order_acquire);
	return std::binary_search(wanted->begin(), wanted->end(), key);
}

void record_module(std::uint64_t key, const void* vm, const void* root_proto) noexcept
{
#ifdef RENOVICE_PACKAGES_OFFLINE_GATE
	(void)key;
	(void)vm;
	(void)root_proto;
#else
	if (key == 0 || vm == nullptr || root_proto == nullptr || !module_wanted(key)) return;
	try
	{
		const auto reader = [](std::uintptr_t address, void* output, std::size_t size)
		{
			SIZE_T copied = 0;
			return ReadProcessMemory(GetCurrentProcess(), reinterpret_cast<const void*>(address), output, size, &copied)
				&& copied == size;
		};
		const auto graph = injection::collect_target_proto_graph_u43(reinterpret_cast<std::uintptr_t>(root_proto), reader);
		ModuleIdentity module;
		module.key = key;
		module.vm = reinterpret_cast<std::uintptr_t>(vm);
		module.root = reinterpret_cast<std::uintptr_t>(root_proto);
		module.sequence = identity_sequence.fetch_add(1, std::memory_order_relaxed) + 1;
		const char* failure = graph.error;
		std::vector<std::uint8_t> code;
		for (const auto& record : graph.records)
		{
			if (failure != nullptr) break;
			const auto bytes = static_cast<std::size_t>(record.instructions) * 4u;
			if (record.instructions <= 0 || bytes > maximum_code_bytes) { failure = "prototype-code-size"; break; }
			code.resize(bytes);
			if (!reader(record.code, code.data(), bytes)) { failure = "prototype-code-unreadable"; break; }
			module.prototypes.push_back(ProtoIdentity{record.address, record.code, record.instructions,
				record.bytecode_id, code_hash(code.data(), bytes)});
		}
		if (failure == nullptr && module.prototypes.empty()) failure = "prototype-graph-empty";
		if (failure != nullptr)
		{
			config::log(std::string("RENOVICE ENGINE PARAMS MODULE REJECT key=") + hex64(key) + " reason=" + failure
				+ " scope=module-local values=stock");
			return;
		}
		const auto count = module.prototypes.size();
		{
			std::lock_guard lock(state_mutex);
			identities.store(with_module(*identities.load(std::memory_order_acquire), std::move(module)),
				std::memory_order_release);
		}
		if (config::diagnostics_mode() >= config::DiagnosticsMode::battle)
		{
			std::ostringstream line;
			line << "RENOVICE ENGINE_PARAM MODULE key=" << hex64(key) << " vm=" << vm << " root=" << root_proto
				<< " prototypes=" << count << " thread=" << GetCurrentThreadId();
			config::diagnostic_log(line.str(), config::DiagnosticsMode::battle);
		}
	}
	catch (...)
	{
		config::log("RENOVICE ENGINE PARAMS MODULE REJECT key=" + hex64(key) + " reason=native-exception scope=module-local values=stock");
	}
#endif
}
}
