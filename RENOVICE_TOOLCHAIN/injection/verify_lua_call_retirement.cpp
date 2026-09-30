// Deterministic self-tests and micro-benchmark for the generic luaCalls.before
// retire-after-use primitive (2026-09-30). Drives the same pure model the
// runtime uses (renovice/lua_call_retirement_core.hpp) and the same stock
// interrupt wrapper (injection_core.hpp preserve_stock_interrupt_result).
// Optional argument: a DE-compiled fixture whose string pool must hold the
// sentinel and exactly the declared target keys.
#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <string>
#include <string_view>
#include <vector>

#define NOMINMAX
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include "../../renovice/generation_ownership.hpp"
#include "../../renovice/injection_core.hpp"
#include "../../renovice/lua_call_retirement_core.hpp"

namespace
{
using namespace renovice::injection;

const void* env(std::uintptr_t value) { return reinterpret_cast<const void*>(value); }

// Mirrors the runtime's per-provider claim check (target_provider_claims_lua_before).
struct ProviderModel
{
	std::vector<std::int32_t> prototypes;
	std::shared_ptr<LuaCallRetireLedger> ledger;
	bool claims(std::int32_t prototype) const noexcept
	{
		const auto found = std::lower_bound(prototypes.begin(), prototypes.end(), prototype);
		if (found == prototypes.end() || *found != prototype) return false;
		const auto index = static_cast<int>(found - prototypes.begin());
		return ledger == nullptr || !ledger->slot_retired(index);
	}
};

std::uint64_t all_bits(std::size_t count)
{
	return count >= 64 ? ~0ull : ((1ull << count) - 1ull);
}

// Mirrors the runtime rule in dispatch_lua_call_phase: retire only when
// every invoked provider returned the sentinel.
bool dispatch_retires(std::size_t invoked, std::size_t signals)
{
	return signals != 0 && signals == invoked;
}

// R4 S2/S4: test mirrors of the runtime luau types. The prefilter and the
// wake scan are templates over these member names, so the gate runs the
// exact runtime code on synthetic frames.
struct MValue { std::uintptr_t as_uintptr = 0; };
struct MTValue
{
	MValue value;
	std::uint32_t pad = 0;
	std::uint32_t type = 0;
};
static_assert(sizeof(MTValue) == 16);
struct MCallInfo
{
	MTValue* base = nullptr;
	MTValue* func = nullptr;
	MTValue* top = nullptr;
	const std::uint32_t* savedpc = nullptr;
	int nresults = 0;
	unsigned flags = 0;
};
struct MState
{
	MCallInfo* ci = nullptr;
	MTValue* stack_last = nullptr;
	MTValue* stack = nullptr;
	MCallInfo* end_ci = nullptr;
	MCallInfo* base_ci = nullptr;
	std::uint64_t pad[13]{};   // the runtime probes sizeof(luau_State) == 0x90
};
struct MClosure
{
	std::uint8_t tt = 0, marked = 0, memcat = 0, isC = 0;
	std::uint8_t nupvalues = 0, stacksize = 0, preload = 0, pad = 0;
	void* gclist = nullptr;
	void* env = nullptr;
	struct { void* p = nullptr; MTValue uprefs[1]{}; } l;
};
constexpr std::uint32_t function_tag = 8;
bool mirror_is_function(int tag) { return tag == 7 || tag == 8; }

// Reference for the runtime's full, validated path (the parts that decide a
// rejection on a well-formed frame): exact instruction, DE CALL decode, call
// window, Lua closure, then the claim (armed prototype address).
bool reference_full_path_claims(const MState& state, bool u44,
	const std::vector<std::uintptr_t>& claimable)
{
	const auto* ci = state.ci;
	const auto raw = *(ci->savedpc - 1);
	DeLuaCallWindow window;
	if (!resolve_de_lua_call_window(raw,
			reinterpret_cast<std::uintptr_t>(ci->base), reinterpret_cast<std::uintptr_t>(ci->top),
			reinterpret_cast<std::uintptr_t>(ci->top),
			reinterpret_cast<std::uintptr_t>(state.stack), reinterpret_cast<std::uintptr_t>(state.stack_last),
			sizeof(MTValue), 256, window, u44))
	{
		return false;
	}
	const auto& function = *reinterpret_cast<const MTValue*>(window.function_slot);
	if (!mirror_is_function(static_cast<int>(function.type)) || function.value.as_uintptr == 0) return false;
	const auto* closure = reinterpret_cast<const MClosure*>(function.value.as_uintptr);
	if (closure->isC) return false;
	return std::find(claimable.begin(), claimable.end(),
		reinterpret_cast<std::uintptr_t>(closure->l.p)) != claimable.end();
}

std::uint8_t raw_call_opcode(bool u44)
{
	for (unsigned op = 0; op != 256; ++op)
		if (renovice::bytecode::canonical_opcode(static_cast<std::uint8_t>(op), u44) == 0x54u)
			return static_cast<std::uint8_t>(op);
	return 0xff;
}
}

int main(int argc, char** argv)
{
	bool pass = true;
	const auto check = [&](bool result, const std::string& name)
	{
		std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
		pass &= result;
	};

	// 1. Signal.
	{
		const char exact[] = "RENOVICE_RETIRE";
		const char longer[] = "RENOVICE_RETIRED";
		const char lower[] = "renovice_retire\0";
		const char shorter[] = "RENOVICE_RETIR\0\0";
		check(is_lua_call_retire_sentinel_bytes(exact)
			&& !is_lua_call_retire_sentinel_bytes(longer)
			&& !is_lua_call_retire_sentinel_bytes(lower)
			&& !is_lua_call_retire_sentinel_bytes(shorter)
			&& !is_lua_call_retire_sentinel_bytes(nullptr),
			"signal: only the exact NUL-terminated string RENOVICE_RETIRE is the sentinel");
		check(dispatch_retires(1, 1) && dispatch_retires(2, 2)
			&& !dispatch_retires(1, 0) && !dispatch_retires(2, 1) && !dispatch_retires(0, 0),
			"signal: a slot retires only when every invoked provider returned the sentinel");
		check(lua_call_retire_sentinel_length == 15, "signal: sentinel length is 15 bytes");
	}

	// 2. Backward compatibility: no signal, nothing changes.
	{
		LuaCallRetireLedger ledger(7, 0xf10a043e7f825db2ull, env(0x1000), {61, 67, 68, 69}, 0xF, 0x55);
		std::uint64_t serial = 0;
		ledger.on_root_entry(env(0xA), serial);
		ProviderModel provider{{61, 67, 68, 69}, nullptr};
		check(ledger.retired_mask() == 0
			&& lua_call_before_slot_armed(0xF, ledger.retired_mask(), false)
			&& provider.claims(61) && provider.claims(67) && provider.claims(68) && provider.claims(69),
			"backward compatibility: without a signal every slot stays armed and claimed");
		check(lua_call_before_slot_armed(0x1, 0, false) == true
			&& lua_call_before_slot_armed(0x0, 0, false) == false,
			"backward compatibility: gate equals the old any-admitted-provider rule when nothing is retired");
	}

	// 3. Retire signal and fast-path rejection.
	{
		auto ledger = std::make_shared<LuaCallRetireLedger>(
			7, 0xf10a043e7f825db2ull, env(0x1000), std::vector<std::int32_t>{67}, 0x1, 0x55);
		std::uint64_t serial = 0;
		check(ledger->on_root_entry(env(0xA), serial) == LuaCallRearmOutcome::new_instance && serial == 1,
			"instance: first root entry creates pending instance 1");
		std::uint64_t instance = 0;
		ledger->count_dispatch(67);
		const auto outcome = ledger->on_signal(67, env(0xA), instance);
		check(outcome == LuaCallRetireOutcome::retired && instance == 1
			&& ledger->retired_mask() == 0x1 && ledger->slot_retired(0),
			"retire: the signal of the only instance retires prototype 67");
		check(!lua_call_before_slot_armed(0x1, ledger->retired_mask(), false),
			"fast path: the process gate closes when every admitted slot is retired");
		ProviderModel provider{{67}, ledger};
		check(!provider.claims(67), "fast path: a retired slot is rejected by the claim check (no Lua entry)");
		check(ledger->on_signal(67, env(0xA), instance) == LuaCallRetireOutcome::no_change,
			"retire: a repeated signal is idempotent and logs nothing");
		check(ledger->dispatches() == 1 && ledger->slot_dispatches(67) == 1,
			"evidence: the dispatch counter records the one dispatch before retirement");
		const auto view = ledger->view(67);
		check(view.target_key == 0xf10a043e7f825db2ull && view.generation == 7 && view.retired == 0x1
			&& view.slot_dispatches == 1 && view.dispatches_total == 1 && view.pending_instances == 1
			&& !view.overflow && view.untracked_pending == 0,
			"diagnostics: the POD view copies the ledger state for formatting outside the lock");

		// Interrupt observer with the gate closed: stock count preserved, the
		// observer body beyond the gate never runs.
		std::atomic_bool gate = lua_call_before_slot_armed(0x1, ledger->retired_mask(), false);
		std::uint64_t body = 0;
		const auto result = preserve_stock_interrupt_result(1234u, [&]
		{
			if (!gate.load(std::memory_order_acquire)) return;
			++body;
		});
		check(result == 1234u && body == 0,
			"fast path: closed gate returns the stock interrupt count before any observer work");
	}

	// 4. Re-arm on a new instance (next mission), overlap and settle.
	{
		LuaCallRetireLedger ledger(7, 0xf10a043e7f825db2ull, env(0x1000), {67, 68}, 0x3, 0x55);
		std::uint64_t serial = 0, instance = 0;
		ledger.on_root_entry(env(0xA), serial);
		ledger.on_signal(67, env(0xA), instance);
		check(ledger.retired_mask() == 0x1, "other hooks: retiring 67 leaves 68 armed");
		check(lua_call_before_slot_armed(0x3, ledger.retired_mask(), false),
			"other hooks: the gate stays open while 68 is armed");
		ledger.on_signal(68, env(0xA), instance);
		check(ledger.retired_mask() == 0x3, "retire: both prototypes retired for instance 1");
		check(ledger.on_root_entry(env(0xB), serial) == LuaCallRearmOutcome::new_instance
			&& ledger.retired_mask() == 0 && serial == 2,
			"re-arm: a new root instance re-arms every slot before its root runs");
		check(ledger.on_signal(67, env(0xA), instance) == LuaCallRetireOutcome::no_change
			&& ledger.retired_mask() == 0,
			"overlap: a signal from the old instance cannot retire for the new one");
		check(ledger.on_signal(67, env(0xB), instance) == LuaCallRetireOutcome::retired
			&& instance == 2 && ledger.retired_mask() == 0x1,
			"re-arm: the new instance's own signal retires again");
		check(ledger.on_root_entry(env(0xB), serial) == LuaCallRearmOutcome::reset_instance
			&& ledger.retired_mask() == 0,
			"re-arm: a root entry with an already pending environment resets that instance");

		LuaCallRetireLedger overlap(7, 1, env(0x1000), {67}, 0x1, 0x55);
		overlap.on_root_entry(env(0xA), serial);
		overlap.on_root_entry(env(0xB), serial);
		check(overlap.on_signal(67, env(0xB), instance) == LuaCallRetireOutcome::served
			&& overlap.retired_mask() == 0,
			"overlap: with two live instances one signal keeps the slot armed");
		check(overlap.on_signal(67, env(0xA), instance) == LuaCallRetireOutcome::retired
			&& overlap.retired_mask() == 0x1,
			"overlap: the slot retires when both instances signalled");

		LuaCallRetireLedger settled(7, 1, env(0x1000), {67}, 0x1, 0x55);
		settled.on_root_entry(env(0xE1), serial);
		settled.on_root_settled(env(0xE1), env(0xE2));
		check(settled.on_signal(67, env(0xE2), instance) == LuaCallRetireOutcome::retired,
			"settle: closures carrying the root's published environment serve the instance");
	}

	// 5. F9 / generation and binding re-arm; identity isolation.
	{
		auto first = std::make_shared<LuaCallRetireLedger>(7, 1, env(0x1000), std::vector<std::int32_t>{67}, 0x1, 0x55);
		std::uint64_t serial = 0, instance = 0;
		first->on_root_entry(env(0xA), serial);
		first->on_signal(67, env(0xA), instance);
		const std::vector<std::int32_t> prototypes{67};
		check(first->same_identity(7, 1, env(0x1000), prototypes, 0x1, 0x55)
			&& !first->same_identity(8, 1, env(0x1000), prototypes, 0x1, 0x55)
			&& !first->same_identity(7, 1, env(0x1000), prototypes, 0x1, 0x56)
			&& !first->same_identity(7, 1, env(0x2000), prototypes, 0x1, 0x55)
			&& !first->same_identity(7, 2, env(0x1000), prototypes, 0x1, 0x55)
			&& !first->same_identity(7, 1, env(0x1000), std::vector<std::int32_t>{67, 68}, 0x1, 0x55),
			"F9: a new generation, binding set, VM, key or prototype set never reuses a ledger");
		LuaCallRetireLedger next(8, 1, env(0x1000), {67}, 0x1, 0x55);
		check(next.retired_mask() == 0 && next.untracked_pending() == 0x1
			&& lua_call_before_slot_armed(0x1, next.retired_mask(), false),
			"F9: a fresh ledger starts fully armed, with the live instance untracked");
		check(next.on_signal(67, env(0xA), instance) == LuaCallRetireOutcome::retired,
			"F9: after re-arm the existing instance's next signal retires again");
		const std::vector<std::string_view> a{"__RENOVICE_TARGET_ADDON_1"};
		const std::vector<std::string_view> b{"__RENOVICE_TARGET_ADDON_2"};
		const std::vector<std::string_view> ab{"__RENOVICE_TARGET_ADDON_1", "__RENOVICE_TARGET_ADDON_2"};
		check(lua_call_retire_binding_fingerprint(a) != lua_call_retire_binding_fingerprint(b)
			&& lua_call_retire_binding_fingerprint(a) != lua_call_retire_binding_fingerprint(ab)
			&& lua_call_retire_binding_fingerprint(a) == lua_call_retire_binding_fingerprint(a),
			"rebind: a new provider binding (new registry key) changes the fingerprint");
	}

	// 6. Fail-closed boundaries.
	{
		LuaCallRetireLedger ledger(7, 1, env(0x1000), {61, 67}, 0x2, 0x55);
		std::uint64_t serial = 0, instance = 0;
		ledger.on_root_entry(env(0xA), serial);
		check(ledger.on_signal(61, env(0xA), instance) == LuaCallRetireOutcome::not_root_child
			&& ledger.retired_mask() == 0,
			"fail closed: a prototype that is not a direct root child never retires");
		check(ledger.on_signal(99, env(0xA), instance) == LuaCallRetireOutcome::unknown_prototype,
			"fail closed: an undeclared prototype never retires");
		check(ledger.first_ignored_report(61) && !ledger.first_ignored_report(61)
			&& ledger.first_ignored_report(99) && !ledger.first_ignored_report(98),
			"diagnostics: an ignored signal is reported once per ledger and prototype");

		std::vector<std::int32_t> many;
		for (std::int32_t p = 0; p != 70; ++p) many.push_back(p);
		LuaCallRetireLedger wide(7, 1, env(0x1000), many, ~0ull, 0x55);
		wide.on_root_entry(env(0xA), serial);
		check(wide.on_signal(65, env(0xA), instance) == LuaCallRetireOutcome::unknown_prototype
			&& lua_call_before_slot_armed(0, ~0ull, true),
			"fail closed: prototypes beyond the 64 retirable slots stay armed and keep the gate open");

		LuaCallRetireLedger full(7, 1, env(0x1000), {67, 68}, 0x3, 0x55);
		for (std::uintptr_t i = 0; i != lua_call_retire_max_instances; ++i)
			full.on_root_entry(env(0x100 + i), serial);
		check(full.on_root_entry(env(0x999), serial) == LuaCallRearmOutcome::overflow
			&& full.overflow()
			&& full.on_signal(67, env(0x100), instance) == LuaCallRetireOutcome::overflow
			&& full.retired_mask() == 0,
			"fail closed: more pending instances than the bound disables retirement (every slot armed)");

		LuaCallRetireLedger evict(7, 1, env(0x1000), {67, 68}, 0x3, 0x55);
		for (std::uintptr_t i = 0; i != lua_call_retire_max_instances; ++i)
		{
			evict.on_root_entry(env(0x100 + i), serial);
			evict.on_signal(67, env(0x100 + i), instance);  // 68 is never signalled
		}
		check(evict.on_root_entry(env(0x999), serial) == LuaCallRearmOutcome::new_instance
			&& !evict.overflow() && evict.pending_instances() == 1
			&& evict.untracked_pending() == 0x2,
			"bound: members that served every signalled slot are evicted; their unsignalled slots stay pending");
		check(evict.on_signal(67, env(0x999), instance) == LuaCallRetireOutcome::retired
			&& (evict.retired_mask() & 0x2) == 0,
			"bound: 67 retires for the new instance while never-signalled 68 stays armed");
	}

	// 7. Unrelated ledgers are independent (other target, other VM).
	{
		LuaCallRetireLedger survival(7, 0xf10a043e7f825db2ull, env(0x1000), {67}, 0x1, 0x55);
		LuaCallRetireLedger other(7, 0x2c6c686109fb50ecull, env(0x1000), {67}, 0x1, 0x66);
		LuaCallRetireLedger other_vm(7, 0xf10a043e7f825db2ull, env(0x2000), {67}, 0x1, 0x77);
		std::uint64_t serial = 0, instance = 0;
		survival.on_root_entry(env(0xA), serial);
		other.on_root_entry(env(0xA), serial);
		other_vm.on_root_entry(env(0xA), serial);
		survival.on_signal(67, env(0xA), instance);
		check(survival.retired_mask() == 1 && other.retired_mask() == 0 && other_vm.retired_mask() == 0,
			"other hooks: retiring one (key, VM) leaves other targets and other VMs armed");
	}

	// 10. R4 S5: retire-all signal forms and backward compatibility.
	{
		const char all[] = "RENOVICE_RETIRE_ALL";
		const char all_longer[] = "RENOVICE_RETIRE_ALLX";
		const char all_lower[] = "renovice_retire_all\0";
		const char all_shorter[] = "RENOVICE_RETIRE_AL\0\0";
		check(is_lua_call_retire_all_sentinel_bytes(all)
			&& !is_lua_call_retire_all_sentinel_bytes(all_longer)
			&& !is_lua_call_retire_all_sentinel_bytes(all_lower)
			&& !is_lua_call_retire_all_sentinel_bytes(all_shorter)
			&& !is_lua_call_retire_all_sentinel_bytes(nullptr)
			&& lua_call_retire_all_sentinel_length == 19,
			"S5 signal: only the exact NUL-terminated RENOVICE_RETIRE_ALL is the retire-all sentinel");
		check(!is_lua_call_retire_sentinel_bytes(all) && all[lua_call_retire_sentinel_length] == '_',
			"S5 backward compatibility: an R3 runtime (16-byte compare) never reads RETIRE_ALL as RETIRE");
		using S = LuaCallRetireSignal;
		check(combine_lua_call_retire_results(S::retire_all, S::none) == S::retire_all
			&& combine_lua_call_retire_results(S::retire, S::retire_all) == S::retire_all
			&& combine_lua_call_retire_results(S::retire, S::none) == S::retire
			&& combine_lua_call_retire_results(S::retire, S::retire) == S::retire
			&& combine_lua_call_retire_results(S::none, S::retire_all) == S::none
			&& combine_lua_call_retire_results(S::none, S::none) == S::none
			&& combine_lua_call_retire_results(S::retire_all, S::retire) == S::retire_all,
			"S5 forms: ALL alone, or RETIRE then ALL; ALL after anything else is no signal");
		// An R3 runtime reads one result: the two-value form degrades to R3.
		check(combine_lua_call_retire_results(S::retire, S::none) == S::retire,
			"S5 backward compatibility: return RETIRE, RETIRE_ALL is a plain R3 retire on a one-result runtime");
	}

	// 11. R4 S5: retire-all scope in the ledger.
	{
		// SurvivalMission-like: 31, 61, 67, 69 root children; 34 nested.
		const std::vector<std::int32_t> protos{31, 34, 61, 67, 69};
		const std::uint64_t root_children = 0b11101;   // 31, 61, 67, 69
		LuaCallRetireLedger ledger(7, 0xf10a043e7f825db2ull, env(0x1000), protos, root_children, 0x55);
		std::uint64_t serial = 0, instance = 0;
		ledger.on_root_entry(env(0xA), serial);
		check(ledger.on_signal_all(67, env(0xA), 0b11111, instance) == LuaCallRetireOutcome::retired
			&& ledger.retired_mask() == root_children && instance == 1,
			"S5: one retire-all from 67 retires every root-child slot, including 31/69 that never fired");
		check(!lua_call_before_slot_armed(root_children, ledger.retired_mask(), false),
			"S5: an idle mission's first dispatch closes the gate when only root children are admitted");
		check(lua_call_before_slot_armed(0b11111, ledger.retired_mask(), false),
			"S5 fail closed: a nested (non-root-child) slot stays armed and keeps the gate open");
		check(ledger.on_root_entry(env(0xB), serial) == LuaCallRearmOutcome::new_instance
			&& ledger.retired_mask() == 0,
			"S5 re-arm: the next root entry (new instance) re-arms every retired-all slot");

		LuaCallRetireLedger overlap(7, 1, env(0x1000), protos, root_children, 0x55);
		overlap.on_root_entry(env(0xA), serial);
		overlap.on_root_entry(env(0xB), serial);
		overlap.on_signal_all(67, env(0xB), root_children, instance);
		check(overlap.retired_mask() == 0,
			"S5 per instance: instance B's retire-all keeps every slot armed for live instance A");
		overlap.on_signal(61, env(0xA), instance);
		check(overlap.retired_mask() == 0b00100,
			"S5 per instance: a slot retires once A has also served it");

		LuaCallRetireLedger nested(7, 1, env(0x1000), protos, root_children, 0x55);
		nested.on_root_entry(env(0xA), serial);
		check(nested.on_signal_all(34, env(0xA), root_children, instance) == LuaCallRetireOutcome::not_root_child
			&& nested.retired_mask() == 0,
			"S5 fail closed: retire-all from a nested prototype is ignored entirely");
		check(nested.on_signal_all(99, env(0xA), root_children, instance) == LuaCallRetireOutcome::unknown_prototype
			&& nested.retired_mask() == 0,
			"S5 fail closed: retire-all from an undeclared prototype is ignored");

		LuaCallRetireLedger full(7, 1, env(0x1000), protos, root_children, 0x55);
		for (std::uintptr_t i = 0; i != lua_call_retire_max_instances + 1; ++i)
			full.on_root_entry(env(0x100 + i), serial);
		check(full.overflow()
			&& full.on_signal_all(67, env(0x100), root_children, instance) == LuaCallRetireOutcome::overflow
			&& full.retired_mask() == 0,
			"S5 fail closed: an overflowed ledger retires nothing");

		// F9 mid-instance: the untracked member (the live instance) is served.
		LuaCallRetireLedger fresh(8, 1, env(0x1000), protos, root_children, 0x55);
		check(fresh.on_signal_all(67, env(0xA), root_children, instance) == LuaCallRetireOutcome::retired
			&& fresh.retired_mask() == root_children,
			"S5 after F9: the live (untracked) instance's retire-all retires every root-child slot");

		// Several addons on one key: only slots no non-ALL addon declares.
		const std::vector<std::uint64_t> addon_slots{0b00101, 0b01100, 0b10000};
		check(lua_call_retire_all_exclusive_mask(addon_slots, 0b001) == 0b00001
			&& lua_call_retire_all_exclusive_mask(addon_slots, 0b011) == 0b01101
			&& lua_call_retire_all_exclusive_mask(addon_slots, 0b111) == 0b11101
			&& lua_call_retire_all_exclusive_mask(addon_slots, 0) == 0,
			"S5 other addons: a slot shared with an addon that did not return retire-all stays armed");
		std::vector<std::uint64_t> many(70, 0);
		many[65] = 0b1;
		check(lua_call_retire_all_exclusive_mask(many, ~0ull) == 0,
			"S5 fail closed: an addon beyond index 64 cannot join retire-all (its slots stay armed)");
		LuaCallRetireLedger shared(7, 1, env(0x1000), protos, root_children, 0x55);
		shared.on_root_entry(env(0xA), serial);
		shared.on_signal_all(67, env(0xA), lua_call_retire_all_exclusive_mask(addon_slots, 0b001), instance);
		check(shared.retired_mask() == 0b01001,
			"S5 other addons: the calling slot and the exclusive slots retire; other addons' slots stay armed");
		LuaCallRetireLedger other_key(7, 2, env(0x1000), protos, root_children, 0x66);
		other_key.on_root_entry(env(0xA), serial);
		check(other_key.retired_mask() == 0,
			"S5 other hooks: another target key's ledger is untouched");
	}

	// 12. R4 S4: dormant re-arm after F9/apply.
	{
		const std::vector<std::int32_t> protos{31, 61, 67, 69};
		const std::uint64_t root_children = 0xF;
		const std::vector<std::uint64_t> addon_slots{0xF};   // one Missions addon
		// Session: Survival ran and retired; the addon became retire-aware.
		auto first = std::make_shared<LuaCallRetireLedger>(7, 0xf10a043e7f825db2ull, env(0x1000),
			protos, root_children, 0x55);
		std::uint64_t serial = 0, instance = 0;
		first->on_root_entry(env(0xA), serial);
		first->on_signal_all(67, env(0xA), root_children, instance);
		first->note_aware_addon("Missions.targets.addon.lua_B");
		check(first->addon_aware("Missions.targets.addon.lua_B") && !first->addon_aware("Other"),
			"S4 awareness: an addon that signalled is recorded by name for this (key, VM)");
		// F9 / settings apply in another mission: fresh ledger, dormant.
		const std::vector<bool> aware{first->addon_aware("Missions.targets.addon.lua_B")};
		const auto dormant = lua_call_retire_dormant_mask(root_children, addon_slots, aware);
		LuaCallRetireLedger next(8, 0xf10a043e7f825db2ull, env(0x1000), protos, root_children, 0x56, dormant);
		next.inherit_aware_addons(first->aware_addons());
		check(dormant == 0xF && next.retired_mask() == 0xF && next.untracked_pending() == 0
			&& next.untracked_dormant() == 0xF && next.dormant_hint()
			&& !lua_call_before_slot_armed(0xF, next.retired_mask(), false),
			"S4: after F9 a module that is not running holds no slot and no gate open (dormant)");
		ProviderModel dormant_provider{protos, nullptr};
		auto next_shared = std::make_shared<LuaCallRetireLedger>(8, 0xf10a043e7f825db2ull, env(0x1000),
			protos, root_children, 0x56, dormant);
		dormant_provider.ledger = next_shared;
		check(!dormant_provider.claims(67) && !dormant_provider.claims(31),
			"S4: a dormant slot is rejected by the lock-free claim check");
		// Mid-mission F9: the running mission's code enters the VM -> wake.
		check(next_shared->wake() && next_shared->retired_mask() == 0 && !next_shared->dormant_hint()
			&& lua_call_before_slot_armed(0xF, next_shared->retired_mask(), false)
			&& dormant_provider.claims(67),
			"S4 mid-mission F9: execution evidence wakes the ledger; every slot is armed again");
		check(!next_shared->wake(), "S4: a second wake changes nothing");
		check(next_shared->on_signal(67, env(0xA), instance) == LuaCallRetireOutcome::retired
			&& next_shared->retired_mask() == 0x4,
			"S4 mid-mission F9: the re-armed hook dispatches, applies the new values and retires again");
		// A new root entry while dormant: new instance armed, old member stays dormant.
		LuaCallRetireLedger entry(8, 1, env(0x1000), protos, root_children, 0x56, dormant);
		entry.on_root_entry(env(0xB), serial);
		check(entry.retired_mask() == 0 && entry.untracked_dormant() == 0xF,
			"S4: a new root entry arms the new instance; the old untracked member stays dormant");
		entry.on_signal(67, env(0xB), instance);
		check((entry.retired_mask() & 0x4) != 0 && (entry.untracked_dormant() & 0x4) == 0,
			"S4: the new instance's signal retires the slot (untracked member served, R3 rule)");
		// Backward compatibility: an addon that never signalled starts armed.
		const auto unaware = lua_call_retire_dormant_mask(root_children, addon_slots, {false});
		LuaCallRetireLedger legacy(8, 1, env(0x1000), protos, root_children, 0x56, unaware);
		check(unaware == 0 && legacy.retired_mask() == 0 && legacy.untracked_pending() == 0xF
			&& !legacy.dormant_hint(),
			"S4 backward compatibility: slots of an addon that never signalled start armed (R3)");
		// Mixed addons: a slot shared with a never-signalling addon stays armed.
		const auto mixed = lua_call_retire_dormant_mask(root_children, {0b0111, 0b0100}, {true, false});
		check(mixed == 0b0011,
			"S4 backward compatibility: a slot also declared by a never-signalling addon starts armed");
		check(lua_call_retire_dormant_mask(0b0011, {0b1111}, {true}) == 0b0011,
			"S4: nested (non-root-child) slots are never dormant");
		// No predecessor (first load) => dormant = 0 => fully armed (R3).
		LuaCallRetireLedger first_load(7, 1, env(0x1000), protos, root_children, 0x55);
		check(first_load.retired_mask() == 0 && !first_load.dormant_hint(),
			"S4: the first ledger of a (key, VM) (module just loaded) starts fully armed");
		// Overflow is never dormant.
		LuaCallRetireLedger over(8, 1, env(0x1000), protos, root_children, 0x56, 0xF);
		for (std::uintptr_t i = 0; i != lua_call_retire_max_instances + 1; ++i)
			over.on_root_entry(env(0x100 + i), serial);
		check(over.overflow() && over.retired_mask() == 0 && !over.dormant_hint(),
			"S4 fail closed: an overflowed ledger arms every slot and stops the dormant watch");
		const auto view = next_shared->view(-1);
		check(view.untracked_dormant == 0 && view.generation == 8,
			"S4 diagnostics: the view carries the dormant mask");
	}

	// 13. R4 S2: armed-prototype set and prefilter equivalence.
	{
		LuaCallAddressSet set;
		check(set.may_contain(0x1234560),
			"S2 set: an unpublished set answers maybe (full path) for every address");
		set.begin();
		for (std::uintptr_t i = 1; i <= 100; ++i) set.insert(0x7ff600000000ull + i * 0x90);
		set.commit();
		bool all_found = true, none_false = true;
		for (std::uintptr_t i = 1; i <= 100; ++i)
			all_found &= set.may_contain(0x7ff600000000ull + i * 0x90);
		for (std::uintptr_t i = 101; i <= 5000; ++i)
			none_false &= !set.may_contain(0x7ff600000000ull + i * 0x90);
		check(all_found && none_false && set.size() == 100,
			"S2 set: exact membership for a published table (no false negative, no false positive)");
		set.begin();
		check(set.may_contain(0x7ff600000000ull + 5000 * 0x90),
			"S2 set: while a writer is rebuilding, every query answers maybe");
		set.commit();
		check(!set.may_contain(0x7ff600000000ull + 5 * 0x90) && set.size() == 0,
			"S2 set: a rebuild clears retired addresses");
		set.begin();
		for (std::uintptr_t i = 1; i <= LuaCallAddressSet::maximum_entries + 1; ++i)
			set.insert(0x10000000ull + i * 0x40);
		set.commit();
		check(set.saturated() && set.may_contain(0xdeadbee0ull),
			"S2 set fail open: a saturated table answers maybe for everything");
		set.begin();
		set.insert(0x5550);
		set.commit();
		set.disable();
		check(set.disabled() && set.may_contain(0x6660),
			"S2 set fail open: a disabled table (exception path) answers maybe forever");

		// Synthetic VM: stack, frames, closures, prototypes.
		std::vector<MTValue> stack(512);
		std::vector<MCallInfo> frames(16);
		std::vector<MClosure> closures(40);
		std::vector<std::array<unsigned char, 0xb0>> protos(32);
		std::vector<std::uint32_t> code(64, 0);
		for (std::size_t i = 0; i != closures.size(); ++i)
		{
			closures[i].isC = i >= 32 ? 1 : 0;
			closures[i].l.p = protos[i % protos.size()].data();
		}
		std::vector<std::uintptr_t> armed_addresses;
		LuaCallAddressSet armed;
		armed.begin();
		for (std::size_t i = 0; i < protos.size(); i += 2)
		{
			armed_addresses.push_back(reinterpret_cast<std::uintptr_t>(protos[i].data()));
			armed.insert(armed_addresses.back());
		}
		armed.commit();
		MState state;
		state.stack = stack.data();
		state.stack_last = stack.data() + stack.size() - 5;
		state.base_ci = frames.data();
		state.end_ci = frames.data() + frames.size();
		std::uint64_t seed = 0x9E3779B97F4A7C15ull;
		const auto next = [&]() { seed ^= seed << 13; seed ^= seed >> 7; seed ^= seed << 17; return seed; };
		std::size_t false_negatives = 0, candidates = 0, skips = 0, claimed = 0;
		for (int u = 0; u != 2; ++u)
		{
			const bool u44 = u == 1;
			const auto call = raw_call_opcode(u44);
			for (int trial = 0; trial != 200000; ++trial)
			{
				auto& frame = frames[1 + next() % 8];
				frame.base = stack.data() + 8 + next() % 64;
				frame.top = frame.base + 1 + next() % 24;
				const auto a = static_cast<std::uint8_t>(next() % 28);
				const auto b = static_cast<std::uint8_t>(next() % 6);
				const auto op = (next() % 4 == 0) ? static_cast<std::uint8_t>(next() & 0xff) : call;
				const std::size_t at = 1 + next() % 60;
				code[at - 1] = op | (static_cast<std::uint32_t>(a) << 8) | (static_cast<std::uint32_t>(b) << 16);
				frame.savedpc = code.data() + at;
				state.ci = &frame;
				for (auto* slot = frame.base; slot != frame.top + 4 && slot < stack.data() + stack.size(); ++slot)
				{
					const auto kind = next() % 5;
					slot->type = kind == 0 ? 6u : kind == 1 ? 0u : function_tag;
					slot->value.as_uintptr = slot->type == function_tag
						? reinterpret_cast<std::uintptr_t>(&closures[next() % closures.size()]) : 0x1000;
				}
				const auto verdict = lua_call_before_prefilter<MState, MClosure>(
					&state, u44, mirror_is_function, armed);
				const bool reference = reference_full_path_claims(state, u44, armed_addresses);
				claimed += reference ? 1u : 0u;
				if (lua_call_prefilter_skips(verdict)) { ++skips; if (reference) ++false_negatives; }
				else ++candidates;
			}
		}
		std::cout << "INFO\tS2 prefilter fuzz: claimed=" << claimed << " candidates=" << candidates
			<< " skips=" << skips << " false_negatives=" << false_negatives << '\n';
		check(false_negatives == 0 && claimed != 0 && skips != 0,
			"S2 equivalence: across 400,000 random frames (U43 and U44 opcodes) the prefilter never skips a call the full path would claim");
		// Edge shapes are undecided (full path), never skipped.
		MCallInfo outside{};
		state.ci = &outside;
		check(lua_call_before_prefilter<MState, MClosure>(&state, false, mirror_is_function, armed)
				== LuaCallPrefilterVerdict::undecided,
			"S2 fail open: a CallInfo outside [base_ci, end_ci) is undecided (validated path)");
		frames[3].base = stack.data() + 8;
		frames[3].top = stack.data() + 10;
		code[9] = raw_call_opcode(false) | (5u << 8);
		frames[3].savedpc = code.data() + 10;
		state.ci = &frames[3];
		check(lua_call_before_prefilter<MState, MClosure>(&state, false, mirror_is_function, armed)
				== LuaCallPrefilterVerdict::undecided,
			"S2 fail open: a function register beyond ci->top is undecided (validated path)");
		frames[3].savedpc = reinterpret_cast<const std::uint32_t*>(std::uintptr_t{0x10002});
		check(lua_call_before_prefilter<MState, MClosure>(&state, false, mirror_is_function, armed)
				== LuaCallPrefilterVerdict::undecided,
			"S2 fail open: an unaligned or low savedpc is undecided (validated path)");
		// A retired slot leaves the set: its calls skip; re-arm puts it back.
		frames[3].top = stack.data() + 16;
		code[9] = raw_call_opcode(false) | (2u << 8);
		frames[3].savedpc = code.data() + 10;
		stack[10].type = function_tag;
		stack[10].value.as_uintptr = reinterpret_cast<std::uintptr_t>(&closures[0]);
		std::uintptr_t callee = 0;
		const auto armed_verdict = lua_call_before_prefilter<MState, MClosure>(
			&state, false, mirror_is_function, armed, &callee);
		armed.begin();
		armed.commit();
		const auto retired_verdict = lua_call_before_prefilter<MState, MClosure>(
			&state, false, mirror_is_function, armed);
		armed.begin();
		armed.insert(reinterpret_cast<std::uintptr_t>(protos[0].data()));
		armed.commit();
		check(armed_verdict == LuaCallPrefilterVerdict::candidate
			&& callee == reinterpret_cast<std::uintptr_t>(protos[0].data())
			&& retired_verdict == LuaCallPrefilterVerdict::skip_not_armed
			&& lua_call_before_prefilter<MState, MClosure>(&state, false, mirror_is_function, armed)
				== LuaCallPrefilterVerdict::candidate,
			"S2: an armed callee is a candidate, a retired one is skipped, a re-armed one is a candidate again");

		// S4 wake scan: module prototype on the chain, root excluded, depth bound.
		LuaCallAddressSet wake;
		wake.begin();
		wake.insert(reinterpret_cast<std::uintptr_t>(protos[5].data()));
		wake.commit();
		for (auto& frame : frames) { frame.func = nullptr; }
		for (std::size_t i = 0; i != frames.size(); ++i)
		{
			stack[200 + i].type = function_tag;
			stack[200 + i].value.as_uintptr = reinterpret_cast<std::uintptr_t>(&closures[6 + (i % 2) * 2]);
			frames[i].func = &stack[200 + i];
		}
		stack[203].value.as_uintptr = reinterpret_cast<std::uintptr_t>(&closures[5]);
		state.ci = &frames[7];
		check(lua_call_dormant_wake_candidate<MState, MClosure>(&state, mirror_is_function, wake)
				== reinterpret_cast<std::uintptr_t>(protos[5].data()),
			"S4 wake scan: a module closure four frames down the chain is execution evidence");
		state.ci = &frames[12];
		check(lua_call_dormant_wake_candidate<MState, MClosure>(&state, mirror_is_function, wake) == 0,
			"S4 wake scan: the chain walk is bounded (8 frames)");
		stack[203].value.as_uintptr = reinterpret_cast<std::uintptr_t>(&closures[37]);   // C closure
		state.ci = &frames[7];
		check(lua_call_dormant_wake_candidate<MState, MClosure>(&state, mirror_is_function, wake) == 0,
			"S4 wake scan: C closures and unrelated Lua closures are not evidence");
		stack[200].value.as_uintptr = reinterpret_cast<std::uintptr_t>(&closures[5]);
		state.ci = &frames[2];
		check(lua_call_dormant_wake_candidate<MState, MClosure>(&state, mirror_is_function, wake)
				== reinterpret_cast<std::uintptr_t>(protos[5].data()),
			"S4 wake scan: the base frame is checked and the walk stops there");
	}

	// 14. R4 S2 before/after (reported; loosely bounded). An unrelated Lua
	// CALL while another slot keeps the gate open.
	//   before: the pre-R4 open-gate path up to its first rejection, with the
	//           runtime's probe sizes (exact_current_lua_instruction: state,
	//           CallInfo, function TValue, closure prefix, prototype prefix,
	//           whole caller code range; call window: function slot, argument
	//           range; generation lease + atomic snapshot load; closure probes
	//           in target_lua_call_for_published_closure; owner search over the
	//           published identities with the real select_target_prototype_owner).
	//   after:  the R4 prefilter (real lua_call_before_prefilter) on the same
	//           frame; a miss returns before all of the above.
	{
		struct Proto
		{
			std::array<unsigned char, 0xb0> prefix{};
			std::vector<std::uint32_t> code;
		};
		struct Identity
		{
			std::uint64_t target_key = 0;
			const void* global_state = nullptr;
			const void* environment = nullptr;
			void* root_proto = nullptr;
			struct Record { std::uintptr_t address = 0, parent = 0; std::int32_t bytecode_id = 0; };
			std::vector<Record> prototypes;
		};
		const auto measure = [&](std::size_t caller_instructions, std::size_t identities_count)
		{
			Proto caller;
			caller.code.assign(caller_instructions, 0);
			caller.prefix[0] = 12;
			const std::uintptr_t code_address = reinterpret_cast<std::uintptr_t>(caller.code.data());
			std::memcpy(caller.prefix.data() + 0x10, &code_address, sizeof(code_address));
			const auto count = static_cast<std::int32_t>(caller_instructions);
			std::memcpy(caller.prefix.data() + 0x88, &count, sizeof(count));
			const std::size_t at = caller_instructions / 2;
			caller.code[at - 1] = raw_call_opcode(false) | (2u << 8) | (3u << 16);   // CALL R2, 2 args
			std::vector<MTValue> stack(256);
			std::array<MCallInfo, 4> frames{};
			std::array<MClosure, 2> closures{};
			std::array<std::array<unsigned char, 0xb0>, 2> callee_protos{};
			closures[0].l.p = caller.prefix.data();
			closures[1].l.p = callee_protos[0].data();     // unrelated callee
			MState state;
			state.stack = stack.data();
			state.stack_last = stack.data() + stack.size() - 5;
			state.base_ci = frames.data();
			state.end_ci = frames.data() + frames.size();
			auto& frame = frames[1];
			stack[4].type = function_tag;
			stack[4].value.as_uintptr = reinterpret_cast<std::uintptr_t>(&closures[0]);
			frame.func = &stack[4];
			frame.base = &stack[5];
			frame.top = &stack[5 + 20];
			frame.savedpc = caller.code.data() + at;
			frame.base[2].type = function_tag;
			frame.base[2].value.as_uintptr = reinterpret_cast<std::uintptr_t>(&closures[1]);
			state.ci = &frame;

			// Published identities (the armed module and others), 120 prototypes each.
			std::vector<Identity> identities(identities_count);
			std::vector<std::vector<std::array<unsigned char, 0xb0>>> storage(identities_count);
			for (std::size_t i = 0; i != identities_count; ++i)
			{
				storage[i].resize(120);
				identities[i].target_key = 0x1000 + i;
				identities[i].global_state = &state;
				identities[i].environment = env(0xE000 + i);
				identities[i].root_proto = storage[i][0].data();
				for (std::size_t p = 0; p != storage[i].size(); ++p)
					identities[i].prototypes.push_back({reinterpret_cast<std::uintptr_t>(storage[i][p].data()),
						p == 0 ? 0u : reinterpret_cast<std::uintptr_t>(storage[i][0].data()),
						static_cast<std::int32_t>(p)});
				std::sort(identities[i].prototypes.begin(), identities[i].prototypes.end(),
					[](const auto& l, const auto& r) { return l.address < r.address; });
			}
			LuaCallAddressSet armed;
			armed.begin();
			for (int p : {31, 61, 67, 69})
				armed.insert(reinterpret_cast<std::uintptr_t>(storage[0][static_cast<std::size_t>(p)].data()));
			armed.commit();
			GenerationDispatchGate gate;
			auto snapshot_holder = std::make_shared<int>(1);
			std::atomic<std::shared_ptr<int>> published(snapshot_holder);

			std::uint64_t rejected_before = 0, rejected_after = 0;
			constexpr std::uint64_t before_iterations = 2'000'000;
			const auto before_start = std::chrono::steady_clock::now();
			for (std::uint64_t i = 0; i != before_iterations; ++i)
			{
				bool reject = false;
				// exact_current_lua_instruction
				reject |= IsBadReadPtr(&state, 0x90) != 0;
				reject |= IsBadReadPtr(state.ci, 0x28) != 0;
				reject |= IsBadReadPtr(state.ci->func, sizeof(MTValue)) != 0;
				const auto* caller_closure = reinterpret_cast<const MClosure*>(state.ci->func->value.as_uintptr);
				reject |= IsBadReadPtr(caller_closure, 0x18) != 0;
				reject |= IsBadReadPtr(caller_closure->l.p, 0xb0) != 0;
				std::array<unsigned char, 0xb0> bytes{};
				std::memcpy(bytes.data(), caller_closure->l.p, bytes.size());
				std::uintptr_t code = 0;
				std::int32_t instructions = 0;
				std::memcpy(&code, bytes.data() + 0x10, sizeof(code));
				std::memcpy(&instructions, bytes.data() + 0x88, sizeof(instructions));
				reject |= IsBadReadPtr(reinterpret_cast<const void*>(code),
					static_cast<std::size_t>(instructions) * 4) != 0;
				std::uint32_t index = 0;
				reject |= !instruction_from_saved_pc(code, instructions,
					reinterpret_cast<std::uintptr_t>(state.ci->savedpc), index);
				const auto raw = reinterpret_cast<const std::uint32_t*>(code)[index];
				DeLuaCallWindow window;
				reject |= !resolve_de_lua_call_window(raw,
					reinterpret_cast<std::uintptr_t>(frame.base), reinterpret_cast<std::uintptr_t>(frame.top),
					reinterpret_cast<std::uintptr_t>(frame.top), reinterpret_cast<std::uintptr_t>(state.stack),
					reinterpret_cast<std::uintptr_t>(state.stack_last), sizeof(MTValue), 256, window, false);
				reject |= IsBadReadPtr(reinterpret_cast<const void*>(window.function_slot), sizeof(MTValue)) != 0;
				reject |= IsBadReadPtr(reinterpret_cast<const void*>(window.argument_base),
					window.argument_count * sizeof(MTValue)) != 0;
				// acquire_target_execution_snapshot
				auto lease = gate.try_dispatch();
				const auto snapshot = published.load(std::memory_order_acquire);
				// target_lua_call_for_published_closure
				const auto& function = *reinterpret_cast<const MTValue*>(window.function_slot);
				const auto* callee = reinterpret_cast<const MClosure*>(function.value.as_uintptr);
				reject |= IsBadReadPtr(callee, 0x18) != 0;
				reject |= IsBadReadPtr(callee, 0x20) != 0;
				const auto owner = select_target_prototype_owner(identities, &state, callee->env,
					reinterpret_cast<std::uintptr_t>(callee->l.p),
					[](const auto&) { return true; });
				reject |= !owner.exact;
				rejected_before += (reject && snapshot != nullptr && lease) ? 1u : 0u;
			}
			const auto before_stop = std::chrono::steady_clock::now();
			constexpr std::uint64_t after_iterations = 50'000'000;
			const auto after_start = std::chrono::steady_clock::now();
			for (std::uint64_t i = 0; i != after_iterations; ++i)
			{
				rejected_after += lua_call_prefilter_skips(lua_call_before_prefilter<MState, MClosure>(
					&state, false, mirror_is_function, armed)) ? 1u : 0u;
			}
			const auto after_stop = std::chrono::steady_clock::now();
			// Armed callee: the prefilter's added cost in front of the full path.
			closures[1].l.p = storage[0][67].data();
			std::uint64_t candidates_after = 0;
			const auto hit_start = std::chrono::steady_clock::now();
			for (std::uint64_t i = 0; i != after_iterations; ++i)
			{
				candidates_after += lua_call_prefilter_skips(lua_call_before_prefilter<MState, MClosure>(
					&state, false, mirror_is_function, armed)) ? 0u : 1u;
			}
			const auto hit_stop = std::chrono::steady_clock::now();
			closures[1].l.p = callee_protos[0].data();
			// S4: dormant-wake scan at a VM-execute entry (8-frame chain, no match).
			LuaCallAddressSet dormant;
			dormant.begin();
			for (std::size_t p = 1; p != 120; ++p)
				dormant.insert(reinterpret_cast<std::uintptr_t>(storage[identities_count - 1][p].data()));
			dormant.commit();
			for (std::size_t f = 0; f != frames.size(); ++f) frames[f].func = &stack[4];
			state.ci = &frames[3];
			std::uint64_t woken = 0;
			const auto wake_start = std::chrono::steady_clock::now();
			for (std::uint64_t i = 0; i != after_iterations; ++i)
				woken += lua_call_dormant_wake_candidate<MState, MClosure>(&state, mirror_is_function, dormant) != 0 ? 1u : 0u;
			const auto wake_stop = std::chrono::steady_clock::now();
			state.ci = &frame;
			const double before_ns = std::chrono::duration<double, std::nano>(before_stop - before_start).count()
				/ static_cast<double>(before_iterations);
			const double after_ns = std::chrono::duration<double, std::nano>(after_stop - after_start).count()
				/ static_cast<double>(after_iterations);
			const double hit_ns = std::chrono::duration<double, std::nano>(hit_stop - hit_start).count()
				/ static_cast<double>(after_iterations);
			const double wake_ns = std::chrono::duration<double, std::nano>(wake_stop - wake_start).count()
				/ static_cast<double>(after_iterations);
			std::cout << std::fixed << std::setprecision(2)
				<< "BENCH\tS2 caller=" << caller_instructions << " instructions identities=" << identities_count
				<< ": before-open-gate-unrelated-call-ns=" << before_ns
				<< " after-prefilter-miss-ns=" << after_ns
				<< " speedup=" << (after_ns > 0 ? before_ns / after_ns : 0.0) << "x"
				<< " prefilter-added-on-armed-hit-ns=" << hit_ns << '\n'
				<< "BENCH\tS4 dormant-wake-scan-per-vm-execute-entry-ns=" << wake_ns
				<< " (4-frame chain, no match; one atomic load when no ledger is dormant)\n";
			check(rejected_before == before_iterations && rejected_after == after_iterations
				&& candidates_after == after_iterations && woken == 0,
				"S2 bench: the old path rejects, the prefilter skips the unrelated call and admits the armed one");
			check(after_ns < before_ns && after_ns < 20.0,
				"S2 bench: the prefilter miss is cheaper than the pre-R4 open-gate path and < 20 ns");
		};
		measure(512, 8);
		measure(4096, 32);
	}

	// 8. Optional real DE fixture: the sentinel is a pool string, not a key.
	if (argc > 1)
	{
		std::ifstream input(argv[1], std::ios::binary);
		const std::vector<unsigned char> bytes(
			(std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
		std::vector<std::uint64_t> keys;
		const char* error = discover_multi_target_keys(bytes.data(), bytes.size(), keys);
		check(error == nullptr && keys.size() == 1 && keys[0] == 0xf10a043e7f825db2ull,
			"fixture: the compiled retire fixture declares exactly its one target key");
		const std::string_view text(reinterpret_cast<const char*>(bytes.data()), bytes.size());
		check(text.find(std::string_view(lua_call_retire_sentinel, lua_call_retire_sentinel_length))
			!= std::string_view::npos,
			"fixture: the sentinel is a plain constant in the DE string pool");
	}
	// R4 S5 fixture (RetireAllProbe): one key, both sentinels in the pool.
	if (argc > 2)
	{
		std::ifstream input(argv[2], std::ios::binary);
		const std::vector<unsigned char> bytes(
			(std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
		std::vector<std::uint64_t> keys;
		const char* error = discover_multi_target_keys(bytes.data(), bytes.size(), keys);
		check(error == nullptr && keys.size() == 1 && keys[0] == 0xf10a043e7f825db2ull,
			"S5 fixture: the compiled retire-all probe declares exactly its one target key");
		const std::string_view text(reinterpret_cast<const char*>(bytes.data()), bytes.size());
		check(text.find(std::string_view(lua_call_retire_all_sentinel, lua_call_retire_all_sentinel_length))
				!= std::string_view::npos
			&& text.find(std::string_view(lua_call_retire_sentinel, lua_call_retire_sentinel_length))
				!= std::string_view::npos,
			"S5 fixture: RENOVICE_RETIRE and RENOVICE_RETIRE_ALL are plain constants in the DE string pool");
	}

	// 9. Micro-benchmark (reported; bounded only loosely so machine noise
	// cannot fail the gate).
	{
		constexpr std::uint64_t iterations = 200'000'000;
		std::atomic_bool gate = false;
		volatile std::uint32_t sink = 0;
		std::uint64_t entered = 0;
		const auto time = [&](auto&& body)
		{
			const auto start = std::chrono::steady_clock::now();
			for (std::uint64_t i = 0; i != iterations; ++i) body(i);
			const auto stop = std::chrono::steady_clock::now();
			return std::chrono::duration<double, std::nano>(stop - start).count()
				/ static_cast<double>(iterations);
		};
		const double baseline = time([&](std::uint64_t i)
		{
			sink = static_cast<std::uint32_t>(i);
		});
		const double closed = time([&](std::uint64_t i)
		{
			sink = preserve_stock_interrupt_result(static_cast<std::uint32_t>(i & 0xffff), [&]
			{
				if (!gate.load(std::memory_order_acquire)) return;
				++entered;
			});
		});
		auto ledger = std::make_shared<LuaCallRetireLedger>(
			7, 1, env(0x1000), std::vector<std::int32_t>{31, 33, 55, 58, 61, 67, 68, 69}, 0xFF, 0x55);
		std::uint64_t serial = 0, instance = 0;
		ledger->on_root_entry(env(0xA), serial);
		ledger->on_signal(67, env(0xA), instance);
		ProviderModel provider{{31, 33, 55, 58, 61, 67, 68, 69}, ledger};
		std::uint64_t claimed = 0;
		const double retired_slot = time([&](std::uint64_t i)
		{
			claimed += provider.claims(67) ? 1u : 0u;
			sink = static_cast<std::uint32_t>(i);
		});
		// Reference for the gate-OPEN path that precedes the claim check in the
		// runtime (instruction decode, window, lease, owner selection): it is
		// dominated by IsBadReadPtr probes (about a dozen per call, some over
		// whole code ranges). One single-page probe:
		static std::array<unsigned char, 256> probe_buffer{};
		std::uint64_t bad = 0;
		constexpr std::uint64_t probe_iterations = 20'000'000;
		const auto probe_start = std::chrono::steady_clock::now();
		for (std::uint64_t i = 0; i != probe_iterations; ++i)
			bad += IsBadReadPtr(probe_buffer.data() + (i & 63), 64) ? 1u : 0u;
		const auto probe_stop = std::chrono::steady_clock::now();
		const double probe_ns = std::chrono::duration<double, std::nano>(
			probe_stop - probe_start).count() / static_cast<double>(probe_iterations);
		const double closed_net = closed > baseline ? closed - baseline : 0.0;
		const double retired_net = retired_slot > baseline ? retired_slot - baseline : 0.0;
		std::cout << std::fixed << std::setprecision(2)
			<< "BENCH\tloop-baseline-ns-per-call=" << baseline << '\n'
			<< "BENCH\tgate-closed-interrupt-observer-ns-per-call=" << closed
			<< " net=" << closed_net << '\n'
			<< "BENCH\tgate-open-retired-slot-claim-check-ns-per-call=" << retired_slot
			<< " net=" << retired_net << " (8 declared prototypes)\n"
			<< "BENCH\treference-IsBadReadPtr-single-page-ns-per-probe=" << probe_ns << '\n';
		check(entered == 0 && claimed == 0 && bad == 0,
			"bench: no observer work and no claim for a retired slot across all iterations");
		check(closed_net < 20.0 && retired_net < 50.0,
			"bench: gate-closed observer < 20 ns and retired-slot claim check < 50 ns per call");
	}

	std::cout << (pass ? "LUA CALL RETIREMENT CORE PASS" : "LUA CALL RETIREMENT CORE FAIL") << '\n';
	return pass ? 0 : 1;
}
