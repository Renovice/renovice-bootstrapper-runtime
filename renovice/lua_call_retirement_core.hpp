#pragma once

// Generic "retire after use" for target-addon luaCalls.before hooks
// (2026-09-30). Pure model, unit-tested by
// RENOVICE_TOOLCHAIN/injection/verify_lua_call_retirement.ps1. No module-,
// mission- or ability-specific rule lives here.
//
// Signal. A luaCalls.before callback returns the exact string
// lua_call_retire_sentinel ("RENOVICE_RETIRE"). Any other return value,
// including none, keeps the hook armed, so existing addons are unchanged.
// A (key, VM, prototype) slot with several providers retires only when every
// provider invoked in the same successful dispatch returned the sentinel.
//
// Scope. One ledger per (committed generation, target key, VM, binding set).
// A module instance is one observed root execution of the module in that VM,
// identified by the environment its closures were created in. A slot is
// retired while every instance the ledger knows about has signalled for that
// prototype. Instances are learned at the natural VM-execute entry of the
// module's recorded root prototype (re-arm), and the entry environment is
// replaced by the environment the root published into at its normal return.
// Instances that existed before the ledger was created are represented by one
// "untracked" member per prototype, served by the first signal for that
// prototype. Only prototypes whose parent is the module root (their closures
// are created only by a root execution) can retire.
//
// Re-arm. A new root entry (new instance), a new committed generation (F9), a
// changed provider binding set (rebind, enable/disable) or changed prototype
// set creates or re-arms the ledger. Re-arming is always safe: the addon is
// dispatched again and signals again.
//
// R4 (2026-09-30) adds three generic refinements; none names a module.
//
// S4 dormant re-arm. A ledger that replaces an earlier ledger of the same
// (key, VM) starts the untracked member DORMANT for every slot declared only
// by retire-aware addons (addons, by name, that returned a sentinel for this
// (key, VM) in an earlier ledger). A dormant slot counts as served: it holds
// neither a claim nor the process gate open. It is woken, never guessed, by
// execution evidence: a natural VM-execute entry whose Lua call chain holds a
// closure of that module (not its root; a root entry is a new instance and
// re-arms through on_root_entry). Slots of addons that never signalled start
// armed exactly as in R3, so pre-R3 addons are unchanged.
//
// S5 retire-all. A callback returns "RENOVICE_RETIRE_ALL" (alone, or as the
// second result after "RENOVICE_RETIRE", which a pre-R4 runtime reads as a
// plain R3 retire). Same unanimity, scope and fail-closed rules as R3; the
// signalling prototype must be a retirable root child. It serves, for the
// calling instance (and the untracked member, as R3 does), every retirable
// slot declared only by addons that returned retire-all in that dispatch.
//
// S2 armed-prototype prefilter. LuaCallAddressSet holds the prototype
// addresses of every armed slot. The interrupt observer checks the callee's
// prototype against it before any IsBadReadPtr probe, snapshot lease or owner
// search; a definite miss returns, anything else takes the unchanged,
// fully validated path.

#include <algorithm>
#include <array>
#include <atomic>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <string>
#include <string_view>
#include <vector>

#include "injection_core.hpp"

namespace renovice::injection
{
inline constexpr char lua_call_retire_sentinel[] = "RENOVICE_RETIRE";
inline constexpr std::size_t lua_call_retire_sentinel_length =
	sizeof(lua_call_retire_sentinel) - 1;
// Retirable prototype slots per (key, VM): one bit each. Prototypes beyond
// this bound stay armed (fail closed).
inline constexpr std::size_t lua_call_retire_max_prototypes = 64;
// Tracked instances per ledger. When full, members that served every slot
// signalled so far are evicted (their other slots fold into the untracked
// member); if none can be evicted the ledger overflows and every slot stays
// armed (fail closed) until the ledger is replaced.
inline constexpr std::size_t lua_call_retire_max_instances = 16;

// `text` must point at least lua_call_retire_sentinel_length + 1 readable
// bytes (DE strings are NUL-terminated). Exact, case-sensitive match.
inline bool is_lua_call_retire_sentinel_bytes(const char* text) noexcept
{
	return text != nullptr
		&& std::memcmp(text, lua_call_retire_sentinel,
			lua_call_retire_sentinel_length + 1) == 0;
}

// S5. "RENOVICE_RETIRE_ALL": the R3 sentinel followed by "_ALL", so byte 15
// ('_' here, NUL in the R3 sentinel) tells the two apart after one 16-byte
// read, and a pre-R4 runtime never mistakes it for the R3 sentinel.
inline constexpr char lua_call_retire_all_sentinel[] = "RENOVICE_RETIRE_ALL";
inline constexpr std::size_t lua_call_retire_all_sentinel_length =
	sizeof(lua_call_retire_all_sentinel) - 1;
static_assert(lua_call_retire_all_sentinel_length == lua_call_retire_sentinel_length + 4);

// `text` must point at least lua_call_retire_all_sentinel_length + 1 readable
// bytes. Exact, case-sensitive match including the terminator.
inline bool is_lua_call_retire_all_sentinel_bytes(const char* text) noexcept
{
	return text != nullptr
		&& std::memcmp(text, lua_call_retire_all_sentinel,
			lua_call_retire_all_sentinel_length + 1) == 0;
}

enum class LuaCallRetireSignal : std::uint8_t
{
	none,
	retire,      // R3: this prototype, this instance
	retire_all,  // S5: every retirable slot of the signalling addons, this instance
};

// The callback's first two results (`first`, `second`), each already
// classified by the caller. Accepted forms:
//   return "RENOVICE_RETIRE"                        -> retire
//   return "RENOVICE_RETIRE_ALL"                    -> retire_all
//   return "RENOVICE_RETIRE", "RENOVICE_RETIRE_ALL" -> retire_all (a pre-R4
//       runtime reads one result and sees a plain R3 retire)
// Anything else, including a retire-all second result after any other first
// value, is no signal.
inline LuaCallRetireSignal combine_lua_call_retire_results(
	LuaCallRetireSignal first,
	LuaCallRetireSignal second) noexcept
{
	if (first == LuaCallRetireSignal::retire_all) return LuaCallRetireSignal::retire_all;
	if (first != LuaCallRetireSignal::retire) return LuaCallRetireSignal::none;
	return second == LuaCallRetireSignal::retire_all
		? LuaCallRetireSignal::retire_all : LuaCallRetireSignal::retire;
}

// S5 scope with several addons on one (key, VM): the slots declared by the
// addons in `retire_all_addons` (bit i = addons[i]) and by no other addon.
// A slot shared with an addon that did not return retire-all stays armed.
// Addons at index >= 64 cannot be in the set (fail closed).
inline std::uint64_t lua_call_retire_all_exclusive_mask(
	const std::vector<std::uint64_t>& addon_slots,
	std::uint64_t retire_all_addons) noexcept
{
	std::uint64_t mine = 0;
	std::uint64_t others = 0;
	for (std::size_t index = 0; index != addon_slots.size(); ++index)
	{
		const bool in_set = index < 64 && ((retire_all_addons >> index) & 1ull) != 0;
		(in_set ? mine : others) |= addon_slots[index];
	}
	return mine & ~others;
}

// S4 dormant start: the retirable slots declared only by retire-aware addons.
// `aware[i]` says whether addons[i] signalled for this (key, VM) before. A
// slot declared by any addon that never signalled starts armed (R3).
inline std::uint64_t lua_call_retire_dormant_mask(
	std::uint64_t retirable,
	const std::vector<std::uint64_t>& addon_slots,
	const std::vector<bool>& aware) noexcept
{
	std::uint64_t aware_slots = 0;
	std::uint64_t unaware_slots = 0;
	for (std::size_t index = 0; index != addon_slots.size(); ++index)
	{
		const bool is_aware = index < aware.size() && aware[index];
		(is_aware ? aware_slots : unaware_slots) |= addon_slots[index];
	}
	return retirable & aware_slots & ~unaware_slots;
}

// FNV-1a-64 over the provider registry keys of one (key, VM). Any rebind
// allocates new registry keys, so the fingerprint changes and re-arms.
inline std::uint64_t lua_call_retire_binding_fingerprint(
	const std::vector<std::string_view>& registry_keys) noexcept
{
	std::uint64_t hash = 0xcbf29ce484222325ull;
	for (const auto key : registry_keys)
	{
		for (const char c : key)
		{
			hash ^= static_cast<unsigned char>(c);
			hash *= 0x100000001b3ull;
		}
		hash ^= 0xffu;
		hash *= 0x100000001b3ull;
	}
	return hash;
}

enum class LuaCallRetireOutcome : std::uint8_t
{
	retired,             // this signal retired the slot
	served,              // instance served; another instance keeps the slot armed
	no_change,           // already served for this instance (repeat signal)
	not_root_child,      // prototype is not a direct child of the module root
	unknown_prototype,   // not a declared slot or beyond the retirable bound
	overflow,            // instance ledger overflowed: retirement disabled
};

enum class LuaCallRearmOutcome : std::uint8_t
{
	new_instance,        // an unseen environment became a pending instance
	reset_instance,      // a pending instance with this environment was reset
	overflow,            // too many pending instances: retirement disabled
};

inline const char* lua_call_retire_outcome_label(LuaCallRetireOutcome outcome) noexcept
{
	switch (outcome)
	{
	case LuaCallRetireOutcome::retired: return "retired";
	case LuaCallRetireOutcome::served: return "served-still-armed";
	case LuaCallRetireOutcome::no_change: return "no-change";
	case LuaCallRetireOutcome::not_root_child: return "ignored-prototype-not-root-child";
	case LuaCallRetireOutcome::unknown_prototype: return "ignored-prototype-not-retirable";
	case LuaCallRetireOutcome::overflow: return "ignored-instance-overflow";
	}
	return "unknown";
}

// POD copy of a ledger's state for a diagnostic line, taken under the owner's
// mutex so formatting happens after the lock is released.
struct LuaCallRetireView
{
	std::uint64_t target_key = 0;
	const void* vm = nullptr;
	std::uint64_t generation = 0;
	std::uint64_t binding = 0;
	std::uint64_t retired = 0;
	std::uint64_t untracked_pending = 0;
	std::uint64_t untracked_dormant = 0;
	std::uint64_t dispatches_total = 0;
	std::uint64_t slot_dispatches = 0;
	std::size_t pending_instances = 0;
	bool overflow = false;
};

// Owned by the runtime through shared_ptr. Identity fields are immutable after
// construction. The mutable members are guarded by the owner's mutex; only
// `retired` is read lock-free on the hot path.
class LuaCallRetireLedger
{
public:
	struct Instance
	{
		const void* environment = nullptr;
		std::uint64_t served = 0;
		std::uint64_t serial = 0;
	};

	// `dormant` (S4): slots whose untracked member starts dormant instead of
	// pending (see the header comment). 0 keeps the R3 start (fully armed).
	LuaCallRetireLedger(
		std::uint64_t generation,
		std::uint64_t target_key,
		const void* vm,
		std::vector<std::int32_t> prototypes,
		std::uint64_t root_children,
		std::uint64_t binding,
		std::uint64_t dormant = 0) noexcept
		: generation_(generation), target_key_(target_key), vm_(vm),
		  prototypes_(std::move(prototypes)), binding_(binding)
	{
		std::sort(prototypes_.begin(), prototypes_.end());
		prototypes_.erase(std::unique(prototypes_.begin(), prototypes_.end()),
			prototypes_.end());
		const auto slots = (std::min)(prototypes_.size(), lua_call_retire_max_prototypes);
		const std::uint64_t all = slots >= 64 ? ~0ull : ((1ull << slots) - 1ull);
		retirable_ = root_children & all;
		// Instances that existed before this ledger: one untracked member.
		untracked_dormant_ = retirable_ & dormant;
		untracked_pending_ = retirable_ & ~untracked_dormant_;
		instances_.reserve(lua_call_retire_max_instances);
		publish();
	}

	std::uint64_t generation() const noexcept { return generation_; }
	std::uint64_t target_key() const noexcept { return target_key_; }
	const void* vm() const noexcept { return vm_; }
	std::uint64_t binding() const noexcept { return binding_; }
	std::uint64_t retirable() const noexcept { return retirable_; }
	const std::vector<std::int32_t>& prototypes() const noexcept { return prototypes_; }
	bool overflow() const noexcept { return overflow_; }
	std::size_t pending_instances() const noexcept { return instances_.size(); }
	std::uint64_t untracked_pending() const noexcept { return untracked_pending_; }
	std::uint64_t untracked_dormant() const noexcept { return untracked_dormant_; }
	// Lock-free hint for the execution-evidence watch (S4).
	bool dormant_hint() const noexcept
	{
		return dormant_hint_.load(std::memory_order_acquire);
	}

	// S4: execution evidence for the module in this ledger's VM (a VM-execute
	// entry with one of its non-root closures on the Lua call chain). The
	// dormant untracked slots become pending (armed) again. Caller holds the
	// owner's mutex. Returns true when a slot changed.
	bool wake() noexcept
	{
		if (untracked_dormant_ == 0) return false;
		untracked_pending_ |= untracked_dormant_;
		untracked_dormant_ = 0;
		publish();
		return true;
	}

	// S4 retire-awareness: addon names (stable across F9, unlike registry
	// keys) that returned a sentinel for this (key, VM). Inherited by the
	// next ledger of the same (key, VM). Caller holds the owner's mutex.
	bool addon_aware(std::string_view name) const noexcept
	{
		return std::find(aware_addons_.begin(), aware_addons_.end(), name)
			!= aware_addons_.end();
	}
	void note_aware_addon(std::string_view name)
	{
		if (!addon_aware(name)) aware_addons_.emplace_back(name);
	}
	void inherit_aware_addons(const std::vector<std::string>& names)
	{
		for (const auto& name : names) note_aware_addon(name);
	}
	const std::vector<std::string>& aware_addons() const noexcept { return aware_addons_; }

	bool same_identity(
		std::uint64_t generation,
		std::uint64_t target_key,
		const void* vm,
		const std::vector<std::int32_t>& sorted_prototypes,
		std::uint64_t root_children,
		std::uint64_t binding) const noexcept
	{
		const auto slots = (std::min)(sorted_prototypes.size(), lua_call_retire_max_prototypes);
		const std::uint64_t all = slots >= 64 ? ~0ull : ((1ull << slots) - 1ull);
		return generation_ == generation && target_key_ == target_key && vm_ == vm
			&& binding_ == binding && prototypes_ == sorted_prototypes
			&& retirable_ == (root_children & all);
	}

	// Slot index of `prototype`, or -1 when it is not a declared slot.
	int index_of(std::int32_t prototype) const noexcept
	{
		const auto found = std::lower_bound(prototypes_.begin(), prototypes_.end(), prototype);
		if (found == prototypes_.end() || *found != prototype) return -1;
		return static_cast<int>(found - prototypes_.begin());
	}

	// True once per ledger and prototype slot (an unknown prototype uses one
	// shared report): bounds repeated "ignored" diagnostics.
	bool first_ignored_report(std::int32_t prototype) noexcept
	{
		const int index = index_of(prototype);
		const std::uint64_t bit = (index >= 0
			&& static_cast<std::size_t>(index) < lua_call_retire_max_prototypes)
			? (1ull << index) : 0;
		if (bit == 0)
		{
			if (unknown_reported_) return false;
			unknown_reported_ = true;
			return true;
		}
		if ((ignored_reported_ & bit) != 0) return false;
		ignored_reported_ |= bit;
		return true;
	}

	// Committed dispatches (diagnostic evidence; relaxed counters, lock-free).
	// A retired slot is rejected before dispatch, so the total stops growing
	// while every slot is retired.
	void count_dispatch(std::int32_t prototype) noexcept
	{
		dispatches_.fetch_add(1, std::memory_order_relaxed);
		const int index = index_of(prototype);
		if (index >= 0 && static_cast<std::size_t>(index) < lua_call_retire_max_prototypes)
			slot_dispatches_[static_cast<std::size_t>(index)].fetch_add(1, std::memory_order_relaxed);
	}
	std::uint64_t dispatches() const noexcept
	{
		return dispatches_.load(std::memory_order_relaxed);
	}
	std::uint64_t slot_dispatches(std::int32_t prototype) const noexcept
	{
		const int index = index_of(prototype);
		return (index >= 0 && static_cast<std::size_t>(index) < lua_call_retire_max_prototypes)
			? slot_dispatches_[static_cast<std::size_t>(index)].load(std::memory_order_relaxed)
			: 0;
	}

	// Caller holds the owner's mutex.
	LuaCallRetireView view(std::int32_t prototype) const noexcept
	{
		LuaCallRetireView result;
		result.target_key = target_key_;
		result.vm = vm_;
		result.generation = generation_;
		result.binding = binding_;
		result.retired = retired_mask();
		result.untracked_pending = untracked_pending_;
		result.untracked_dormant = untracked_dormant_;
		result.dispatches_total = dispatches();
		result.slot_dispatches = prototype >= 0 ? slot_dispatches(prototype) : 0;
		result.pending_instances = instances_.size();
		result.overflow = overflow_;
		return result;
	}

	// Lock-free hot-path read.
	std::uint64_t retired_mask() const noexcept
	{
		return retired_.load(std::memory_order_acquire);
	}
	bool slot_retired(int index) const noexcept
	{
		return index >= 0 && static_cast<std::size_t>(index) < lua_call_retire_max_prototypes
			&& ((retired_mask() >> index) & 1ull) != 0;
	}

	// Natural root entry of the module in this ledger's VM. Always re-arms.
	LuaCallRearmOutcome on_root_entry(const void* environment, std::uint64_t& serial_out) noexcept
	{
		serial_out = 0;
		if (overflow_) { publish(); return LuaCallRearmOutcome::overflow; }
		for (auto& instance : instances_)
		{
			if (instance.environment == environment)
			{
				instance.served = 0;
				instance.serial = ++next_serial_;
				serial_out = instance.serial;
				publish();
				return LuaCallRearmOutcome::reset_instance;
			}
		}
		if (instances_.size() >= lua_call_retire_max_instances)
		{
			// Capacity pressure: evict members that have served every
			// prototype any instance has signalled so far. Their remaining
			// (never signalled) slots fold into the untracked member, which
			// the next signal for that slot serves.
			for (auto it = instances_.begin(); it != instances_.end();)
			{
				if (signalled_ever_ != 0
					&& (it->served & signalled_ever_) == signalled_ever_)
				{
					untracked_pending_ |= retirable_ & ~it->served;
					it = instances_.erase(it);
				}
				else ++it;
			}
		}
		if (instances_.size() >= lua_call_retire_max_instances)
		{
			overflow_ = true;
			publish();
			return LuaCallRearmOutcome::overflow;
		}
		instances_.push_back({environment, 0, ++next_serial_});
		serial_out = next_serial_;
		publish();
		return LuaCallRearmOutcome::new_instance;
	}

	// Normal root return: the instance's closures carry the environment the
	// root published into, which can differ from the entry environment.
	void on_root_settled(const void* entry_environment, const void* settled_environment) noexcept
	{
		if (entry_environment == settled_environment) return;
		auto entry = std::find_if(instances_.begin(), instances_.end(),
			[&](const Instance& i) { return i.environment == entry_environment; });
		if (entry == instances_.end()) return;
		auto existing = std::find_if(instances_.begin(), instances_.end(),
			[&](const Instance& i) { return i.environment == settled_environment; });
		if (existing != instances_.end())
		{
			// Two pending members now name one instance: keep the conservative
			// (intersection) served set and drop the entry member.
			existing->served &= entry->served;
			existing->serial = (std::max)(existing->serial, entry->serial);
			instances_.erase(entry);
		}
		else
		{
			entry->environment = settled_environment;
		}
		publish();
	}

	// A successful dispatch in which every invoked provider returned the
	// sentinel. `environment` is the called closure's environment.
	LuaCallRetireOutcome on_signal(
		std::int32_t prototype,
		const void* environment,
		std::uint64_t& instance_serial_out) noexcept
	{
		instance_serial_out = 0;
		const int index = index_of(prototype);
		if (index < 0 || static_cast<std::size_t>(index) >= lua_call_retire_max_prototypes)
			return LuaCallRetireOutcome::unknown_prototype;
		const std::uint64_t bit = 1ull << index;
		if ((retirable_ & bit) == 0) return LuaCallRetireOutcome::not_root_child;
		if (overflow_) return LuaCallRetireOutcome::overflow;
		return serve(bit, environment, instance_serial_out);
	}

	// S5: a successful dispatch in which every invoked provider signalled and
	// the addons in the set returned retire-all. `exclusive` is
	// lua_call_retire_all_exclusive_mask for those addons. The calling
	// prototype must itself be a retirable slot (as for R3); then the calling
	// slot and every retirable slot in `exclusive` are served for this
	// instance and the untracked member. Non-root-child, undeclared or
	// beyond-64 slots in `exclusive` stay armed.
	LuaCallRetireOutcome on_signal_all(
		std::int32_t prototype,
		const void* environment,
		std::uint64_t exclusive,
		std::uint64_t& instance_serial_out) noexcept
	{
		instance_serial_out = 0;
		const int index = index_of(prototype);
		if (index < 0 || static_cast<std::size_t>(index) >= lua_call_retire_max_prototypes)
			return LuaCallRetireOutcome::unknown_prototype;
		const std::uint64_t bit = 1ull << index;
		if ((retirable_ & bit) == 0) return LuaCallRetireOutcome::not_root_child;
		if (overflow_) return LuaCallRetireOutcome::overflow;
		return serve((exclusive | bit) & retirable_, environment, instance_serial_out);
	}

private:
	// R3 serving rule for a set of retirable bits: the first signal serves the
	// untracked member (pending or dormant), and the tracked instance with this
	// environment, if any.
	LuaCallRetireOutcome serve(
		std::uint64_t bits,
		const void* environment,
		std::uint64_t& instance_serial_out) noexcept
	{
		signalled_ever_ |= bits;
		bool changed = false;
		if (((untracked_pending_ | untracked_dormant_) & bits) != 0)
		{
			untracked_pending_ &= ~bits;
			untracked_dormant_ &= ~bits;
			changed = true;
		}
		for (auto& instance : instances_)
		{
			if (instance.environment != environment) continue;
			instance_serial_out = instance.serial;
			if ((instance.served & bits) != bits)
			{
				instance.served |= bits;
				changed = true;
			}
			break;
		}
		const auto before = retired_mask();
		publish();
		const auto after = retired_mask();
		if (!changed) return LuaCallRetireOutcome::no_change;
		return ((after & ~before & bits) != 0)
			? LuaCallRetireOutcome::retired : LuaCallRetireOutcome::served;
	}

	void publish() noexcept
	{
		std::uint64_t mask = overflow_ ? 0 : (retirable_ & ~untracked_pending_);
		for (const auto& instance : instances_) mask &= instance.served;
		retired_.store(mask, std::memory_order_release);
		dormant_hint_.store(!overflow_ && untracked_dormant_ != 0, std::memory_order_release);
	}

	std::uint64_t generation_ = 0;
	std::uint64_t target_key_ = 0;
	const void* vm_ = nullptr;
	std::vector<std::int32_t> prototypes_;
	std::uint64_t binding_ = 0;
	std::uint64_t retirable_ = 0;
	std::uint64_t untracked_pending_ = 0;
	std::uint64_t untracked_dormant_ = 0;
	std::uint64_t signalled_ever_ = 0;
	std::vector<Instance> instances_;
	std::vector<std::string> aware_addons_;
	std::uint64_t next_serial_ = 0;
	bool overflow_ = false;
	std::uint64_t ignored_reported_ = 0;
	bool unknown_reported_ = false;
	std::atomic<std::uint64_t> retired_{0};
	std::atomic<bool> dormant_hint_{false};
	std::atomic<std::uint64_t> dispatches_{0};
	std::array<std::atomic<std::uint64_t>, lua_call_retire_max_prototypes> slot_dispatches_{};
};

// Gate rule: the process-wide luaCalls.before fast gate is open while at
// least one admitted prototype slot of any published provider is armed.
// `admitted` holds the slots whose prototype exists in a published execution
// identity; `unretirable_admitted` reports an admitted prototype beyond the
// retirable bound.
inline bool lua_call_before_slot_armed(
	std::uint64_t admitted,
	std::uint64_t retired,
	bool unretirable_admitted) noexcept
{
	return unretirable_admitted || (admitted & ~retired) != 0;
}

// Lock-free set of prototype addresses (S2 armed set, S4 dormant-wake set).
// Open addressing, one writer at a time (the owner's mutex), any number of
// readers. A reader's answer is exact only for a stable, published,
// unsaturated table; in every other case may_contain() answers "maybe" (true),
// which sends the caller down its unchanged, fully validated path. A "no" is
// therefore always a proven miss. Allocation-free.
class LuaCallAddressSet
{
public:
	static constexpr std::size_t capacity = 1024;              // power of two
	static constexpr std::size_t maximum_entries = capacity / 2;

	// Reader. False only when `address` is definitely absent.
	bool may_contain(std::uintptr_t address) const noexcept
	{
		const auto before = sequence_.load(std::memory_order_acquire);
		if ((before & 1u) != 0 || before == 0) return true;   // writing / never published
		if (disabled_.load(std::memory_order_relaxed)
			|| saturated_.load(std::memory_order_relaxed)) return true;
		bool found = false;
		if (address != 0)
		{
			for (std::size_t probe = 0, slot = hash(address); probe != capacity;
				++probe, slot = (slot + 1) & (capacity - 1))
			{
				const auto value = slots_[slot].load(std::memory_order_relaxed);
				if (value == 0) break;
				if (value == address) { found = true; break; }
			}
		}
		std::atomic_thread_fence(std::memory_order_acquire);
		return found || sequence_.load(std::memory_order_relaxed) != before;
	}

	// Writer protocol: begin(), insert()..., commit(). Caller holds the
	// owner's mutex for the whole sequence.
	void begin() noexcept
	{
		const auto sequence = sequence_.load(std::memory_order_relaxed);
		sequence_.store(sequence + 1, std::memory_order_relaxed);   // odd: writing
		std::atomic_thread_fence(std::memory_order_release);
		for (std::size_t index = 0; index != used_count_; ++index)
			slots_[used_[index]].store(0, std::memory_order_relaxed);
		used_count_ = 0;
		saturated_.store(false, std::memory_order_relaxed);
	}
	void insert(std::uintptr_t address) noexcept
	{
		if (address == 0 || saturated_.load(std::memory_order_relaxed)) return;
		std::size_t slot = hash(address);
		for (std::size_t probe = 0; probe != capacity;
			++probe, slot = (slot + 1) & (capacity - 1))
		{
			const auto value = slots_[slot].load(std::memory_order_relaxed);
			if (value == address) return;
			if (value != 0) continue;
			if (used_count_ >= maximum_entries) break;
			slots_[slot].store(address, std::memory_order_relaxed);
			used_[used_count_++] = static_cast<std::uint16_t>(slot);
			return;
		}
		saturated_.store(true, std::memory_order_relaxed);   // fail open: "maybe" for all
	}
	void commit() noexcept
	{
		const auto sequence = sequence_.load(std::memory_order_relaxed);
		sequence_.store(sequence + 1, std::memory_order_release);   // even: stable
	}
	// Sticky: every later query answers "maybe" (the pre-S2 behaviour). Any
	// thread may call it, e.g. from a catch block that lost the mutex.
	void disable() noexcept { disabled_.store(true, std::memory_order_release); }

	std::size_t size() const noexcept { return used_count_; }         // writer side
	bool saturated() const noexcept { return saturated_.load(std::memory_order_relaxed); }
	bool disabled() const noexcept { return disabled_.load(std::memory_order_acquire); }

private:
	static std::size_t hash(std::uintptr_t address) noexcept
	{
		// Prototypes are heap objects aligned to at least 8 bytes.
		return static_cast<std::size_t>(
			(static_cast<std::uint64_t>(address >> 3) * 0x9E3779B97F4A7C15ull) >> 54)
			& (capacity - 1);
	}

	std::atomic<std::uint64_t> sequence_{0};
	std::atomic<bool> saturated_{false};
	std::atomic<bool> disabled_{false};
	std::array<std::atomic<std::uintptr_t>, capacity> slots_{};
	std::array<std::uint16_t, maximum_entries> used_{};
	std::size_t used_count_ = 0;
};
static_assert(LuaCallAddressSet::capacity == 1024,
	"hash() takes the top 10 bits of the product");

enum class LuaCallPrefilterVerdict : std::uint8_t
{
	skip_not_a_call,          // current instruction is not a DE CALL
	skip_not_a_lua_closure,   // callee slot holds no Lua closure
	skip_not_armed,           // callee prototype is in no armed slot
	candidate,                // callee prototype may be armed: full path
	undecided,                // frame shape not proven: full path
};

inline bool lua_call_prefilter_skips(LuaCallPrefilterVerdict verdict) noexcept
{
	return verdict != LuaCallPrefilterVerdict::candidate
		&& verdict != LuaCallPrefilterVerdict::undecided;
}

// S2 prefilter at the DE interrupt (luaCalls.before observer), before any
// IsBadReadPtr probe, snapshot lease or owner search. Reads only memory the
// interpreter itself dereferences at this interrupt: the current CallInfo
// (range-checked inside [base_ci, end_ci)), the instruction just before
// savedpc (the same word exact_current_lua_instruction decodes), one stack
// slot inside the current frame (range-checked inside [stack, stack_last) and
// below ci->top), and the header of the closure that slot references (the
// function the VM calls next). A "skip" verdict is only returned where the
// full path would also reject; any unproven shape is `undecided`.
// Template parameters are the runtime's luau types (or test mirrors with the
// same member names).
template <typename State, typename Closure, typename IsFunction>
inline LuaCallPrefilterVerdict lua_call_before_prefilter(
	const State* state,
	bool u44,
	IsFunction&& is_function,
	const LuaCallAddressSet& armed,
	std::uintptr_t* callee_proto = nullptr) noexcept
{
	if (callee_proto != nullptr) *callee_proto = 0;
	const auto* const ci = state->ci;
	if (ci == nullptr || state->base_ci == nullptr || state->end_ci == nullptr
		|| ci < state->base_ci || ci >= state->end_ci)
	{
		return LuaCallPrefilterVerdict::undecided;
	}
	const auto pc = reinterpret_cast<std::uintptr_t>(ci->savedpc);
	if (pc < 0x10000 + sizeof(std::uint32_t) || pc % sizeof(std::uint32_t) != 0)
		return LuaCallPrefilterVerdict::undecided;
	const auto raw = *(reinterpret_cast<const std::uint32_t*>(pc) - 1);
	DeLuaCallInstruction decoded;
	if (!decode_de_lua_call_instruction(raw, decoded, u44))
		return LuaCallPrefilterVerdict::skip_not_a_call;
	const auto* const base = ci->base;
	const auto* const top = ci->top;
	if (base == nullptr || top == nullptr || state->stack == nullptr
		|| state->stack_last == nullptr || base < state->stack
		|| top > state->stack_last || base >= top
		|| static_cast<std::size_t>(top - base) <= decoded.register_a)
	{
		return LuaCallPrefilterVerdict::undecided;
	}
	const auto& function = base[decoded.register_a];
	if (!is_function(static_cast<int>(function.type)) || function.value.as_uintptr == 0)
		return LuaCallPrefilterVerdict::skip_not_a_lua_closure;
	const auto* const closure = reinterpret_cast<const Closure*>(function.value.as_uintptr);
	if (closure->isC) return LuaCallPrefilterVerdict::skip_not_a_lua_closure;
	const auto proto = reinterpret_cast<std::uintptr_t>(closure->l.p);
	if (callee_proto != nullptr) *callee_proto = proto;
	return armed.may_contain(proto)
		? LuaCallPrefilterVerdict::candidate : LuaCallPrefilterVerdict::skip_not_armed;
}

// S4 execution evidence at a natural VM-execute entry: the prototype of the
// first Lua closure on the call chain (the entered frame, then up to
// `maximum_frames - 1` callers) that the dormant-wake set may contain, else 0.
// Same memory rules as the prefilter: CallInfo range-checked, function slots
// range-checked inside the stack, closure headers of active frames only.
template <typename State, typename Closure, typename IsFunction>
inline std::uintptr_t lua_call_dormant_wake_candidate(
	const State* state,
	IsFunction&& is_function,
	const LuaCallAddressSet& dormant,
	std::size_t maximum_frames = 8) noexcept
{
	const auto* ci = state->ci;
	if (ci == nullptr || state->base_ci == nullptr || state->end_ci == nullptr
		|| ci < state->base_ci || ci >= state->end_ci
		|| state->stack == nullptr || state->stack_last == nullptr)
	{
		return 0;
	}
	for (std::size_t depth = 0; depth != maximum_frames; ++depth, --ci)
	{
		const auto* const slot = ci->func;
		if (slot != nullptr && slot >= state->stack && slot < state->stack_last
			&& is_function(static_cast<int>(slot->type)) && slot->value.as_uintptr != 0)
		{
			const auto* const closure = reinterpret_cast<const Closure*>(slot->value.as_uintptr);
			if (!closure->isC)
			{
				const auto proto = reinterpret_cast<std::uintptr_t>(closure->l.p);
				if (proto != 0 && dormant.may_contain(proto)) return proto;
			}
		}
		if (ci == state->base_ci) break;
	}
	return 0;
}

// Contract R13 (2026-10-01): luaCalls.before at a native entry. The interrupt
// observer (lua_call_before_prefilter) sees only a Lua CALL instruction, so a
// Lua function that the engine enters directly (a level ScriptTrigger
// function such as WaveDefend `WaveDefense`, an encounter function, a native
// callback, a coroutine start, or a Lua function reached through a C function
// such as pcall) was never dispatched. Those entries all pass through a
// natural VM-execute entry with a fresh frame. This rule decides, at that
// entry, whether the entered frame is such a call:
//   - the entered frame's function slot holds a Lua closure;
//   - the frame is fresh: savedpc is the first instruction of its prototype
//     (a resumed coroutine or any other re-entry is mid-function);
//   - the CALL observer does not own it: the parent frame is not a Lua frame
//     whose current instruction is a CALL of this exact closure (DE runs a
//     Lua-to-Lua CALL inside one VM execute, so this is a guard, not a path);
//   - the prototype may be armed.
// Same memory rules as the other prefilters: CallInfo range-checked, stack
// slots range-checked, closure headers of active frames only, and the code
// pointer at the DE prototype offset the undump writes (+0x10). A "skip" is
// returned only where the full path would also reject; an unproven shape is
// `undecided`, which takes the full, validated path.
inline constexpr std::size_t de_proto_code_offset = 0x10;
// Fixed parameter count byte of a DE prototype (stock Luau layout: nups +3,
// numparams +4, is_vararg +5, maxstacksize +6, flags +7). 44.0.2
// (2026.09.28.13.06) luau_load writes header byte 1 there (RVA 0x191B40A).
inline constexpr std::size_t de_proto_numparams_offset = 0x04;

enum class LuaCallEntryVerdict : std::uint8_t
{
	skip_not_a_lua_closure,   // the entered frame runs no Lua closure
	skip_not_fresh,           // mid-function re-entry (coroutine resume, ...)
	skip_call_observer_owns,  // a Lua CALL of this closure: the interrupt path dispatches it
	skip_not_armed,           // the prototype is in no armed slot
	candidate,                // fresh native entry of a possibly armed prototype
	undecided,                // frame shape not proven: full path
};

inline bool lua_call_entry_prefilter_skips(LuaCallEntryVerdict verdict) noexcept
{
	return verdict != LuaCallEntryVerdict::candidate
		&& verdict != LuaCallEntryVerdict::undecided;
}

template <typename State, typename Closure, typename IsFunction>
inline LuaCallEntryVerdict lua_call_entry_prefilter(
	const State* state,
	bool u44,
	IsFunction&& is_function,
	const LuaCallAddressSet& armed,
	std::uintptr_t* entered_proto = nullptr) noexcept
{
	if (entered_proto != nullptr) *entered_proto = 0;
	const auto* const ci = state->ci;
	if (ci == nullptr || state->base_ci == nullptr || state->end_ci == nullptr
		|| ci < state->base_ci || ci >= state->end_ci
		|| state->stack == nullptr || state->stack_last == nullptr)
	{
		return LuaCallEntryVerdict::undecided;
	}
	const auto* const slot = ci->func;
	if (slot == nullptr || slot < state->stack || slot >= state->stack_last)
		return LuaCallEntryVerdict::undecided;
	if (!is_function(static_cast<int>(slot->type)) || slot->value.as_uintptr == 0)
		return LuaCallEntryVerdict::skip_not_a_lua_closure;
	const auto* const closure = reinterpret_cast<const Closure*>(slot->value.as_uintptr);
	if (closure->isC) return LuaCallEntryVerdict::skip_not_a_lua_closure;
	const auto proto = reinterpret_cast<std::uintptr_t>(closure->l.p);
	if (proto < 0x10000 || proto % sizeof(void*) != 0) return LuaCallEntryVerdict::undecided;
	std::uintptr_t code = 0;
	std::memcpy(&code, reinterpret_cast<const unsigned char*>(proto) + de_proto_code_offset, sizeof(code));
	if (code < 0x10000 || code % sizeof(std::uint32_t) != 0) return LuaCallEntryVerdict::undecided;
	if (reinterpret_cast<std::uintptr_t>(ci->savedpc) != code) return LuaCallEntryVerdict::skip_not_fresh;
	if (ci > state->base_ci)
	{
		const auto* const parent = ci - 1;
		const auto* const parent_slot = parent->func;
		if (parent_slot != nullptr && parent_slot >= state->stack && parent_slot < state->stack_last
			&& is_function(static_cast<int>(parent_slot->type)) && parent_slot->value.as_uintptr != 0
			&& !reinterpret_cast<const Closure*>(parent_slot->value.as_uintptr)->isC)
		{
			// A Lua parent: the CALL observer owns the call exactly when the
			// parent's current instruction is a CALL whose function register
			// holds this closure. Anything else (a metamethod, an iterator)
			// is not a CALL and is dispatched here.
			const auto pc = reinterpret_cast<std::uintptr_t>(parent->savedpc);
			if (pc < 0x10000 + sizeof(std::uint32_t) || pc % sizeof(std::uint32_t) != 0)
				return LuaCallEntryVerdict::undecided;
			const auto raw = *(reinterpret_cast<const std::uint32_t*>(pc) - 1);
			DeLuaCallInstruction decoded;
			if (decode_de_lua_call_instruction(raw, decoded, u44))
			{
				const auto* const base = parent->base;
				const auto* const top = parent->top;
				if (base == nullptr || top == nullptr || base < state->stack
					|| top > state->stack_last || base >= top
					|| static_cast<std::size_t>(top - base) <= decoded.register_a)
				{
					return LuaCallEntryVerdict::undecided;
				}
				const auto& called = base[decoded.register_a];
				if (is_function(static_cast<int>(called.type))
					&& called.value.as_uintptr == slot->value.as_uintptr)
				{
					return LuaCallEntryVerdict::skip_call_observer_owns;
				}
			}
		}
	}
	if (entered_proto != nullptr) *entered_proto = proto;
	return armed.may_contain(proto)
		? LuaCallEntryVerdict::candidate : LuaCallEntryVerdict::skip_not_armed;
}
}
