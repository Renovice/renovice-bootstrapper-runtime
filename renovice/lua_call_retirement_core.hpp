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

#include <algorithm>
#include <array>
#include <atomic>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <string_view>
#include <vector>

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

	LuaCallRetireLedger(
		std::uint64_t generation,
		std::uint64_t target_key,
		const void* vm,
		std::vector<std::int32_t> prototypes,
		std::uint64_t root_children,
		std::uint64_t binding) noexcept
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
		untracked_pending_ = retirable_;
		instances_.reserve(lua_call_retire_max_instances);
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
		signalled_ever_ |= bit;
		bool changed = false;
		if ((untracked_pending_ & bit) != 0)
		{
			untracked_pending_ &= ~bit;
			changed = true;
		}
		for (auto& instance : instances_)
		{
			if (instance.environment != environment) continue;
			instance_serial_out = instance.serial;
			if ((instance.served & bit) == 0)
			{
				instance.served |= bit;
				changed = true;
			}
			break;
		}
		const auto before = retired_mask();
		publish();
		const auto after = retired_mask();
		if (!changed) return LuaCallRetireOutcome::no_change;
		return ((after & bit) != 0 && (before & bit) == 0)
			? LuaCallRetireOutcome::retired : LuaCallRetireOutcome::served;
	}

private:
	void publish() noexcept
	{
		std::uint64_t mask = overflow_ ? 0 : (retirable_ & ~untracked_pending_);
		for (const auto& instance : instances_) mask &= instance.served;
		retired_.store(mask, std::memory_order_release);
	}

	std::uint64_t generation_ = 0;
	std::uint64_t target_key_ = 0;
	const void* vm_ = nullptr;
	std::vector<std::int32_t> prototypes_;
	std::uint64_t binding_ = 0;
	std::uint64_t retirable_ = 0;
	std::uint64_t untracked_pending_ = 0;
	std::uint64_t signalled_ever_ = 0;
	std::vector<Instance> instances_;
	std::uint64_t next_serial_ = 0;
	bool overflow_ = false;
	std::uint64_t ignored_reported_ = 0;
	bool unknown_reported_ = false;
	std::atomic<std::uint64_t> retired_{0};
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
}
