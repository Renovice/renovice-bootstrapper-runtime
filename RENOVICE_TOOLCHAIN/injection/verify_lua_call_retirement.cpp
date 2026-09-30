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
