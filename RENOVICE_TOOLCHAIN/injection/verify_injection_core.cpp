#include <filesystem>
#include <atomic>
#include <chrono>
#include <iostream>
#include <string>
#include <string_view>
#include <thread>
#include <vector>

#include "../../renovice/injection_core.hpp"
#include "../../renovice/de_proto_graph_u43.hpp"
#include "../../renovice/addon_transaction.hpp"
#include "../../renovice/addon_trace_policy.hpp"
#include "../../renovice/engine_damage_core.hpp"
#include "../../renovice/injected_interrupt_budget.hpp"
#include "../../renovice/vm_stack_write.hpp"
#include "../../renovice/caster_diagnostic_budget.hpp"
#include "../../renovice/vm_memory_evidence.hpp"
#include "../../renovice/generation_ownership.hpp"

int main(int argc, char** argv)
{
	using namespace renovice::injection;
	bool pass = true;
	const auto check = [&](bool result, const std::string& name)
	{
		std::cout << (result ? "PASS" : "FAIL") << '\t' << name << '\n';
		pass &= result;
	};
	{
        bool bijective = true;
        for (std::uint8_t op = 0; op < 86; ++op)
            bijective &= renovice::bytecode::canonical_opcode(renovice::bytecode::u43_to_u44[op], true) == op;
        check(bijective, "U44 opcode profile is bijective across all 86 instructions");
        DeLuaCallInstruction decoded;
        check(decode_de_lua_call_instruction(0x03030547u, decoded, true)
            && decoded.register_a == 5 && decoded.encoded_arguments_b == 3
            && decoded.encoded_results_c == 3
            && !decode_de_lua_call_instruction(0x0303051bu, decoded, true),
            "U44 CALL operands preserved and U44 RETURN rejected");
        const std::uint32_t code[] = {0x43u, 0x40u, 0x12345678u, 0x47u, 0x43u};
        std::uint32_t instruction = 0;
        check(native_callsite_instruction_from_saved_pc(code, 5, code + 4, instruction, true)
            && instruction == 1
            && !native_callsite_instruction_from_saved_pc(code, 5, code + 3, instruction, true),
            "U44 NAMECALL resolves exact logical callsite and rejects AUX boundary");
    }
	check(select_exact_stack_target(0x11, false, 0x22, true) == 0x11
		&& select_exact_stack_target(0, false, 0x22, true) == 0x22
		&& select_exact_stack_target(0, false, 0x22, false) == 0
		&& select_exact_stack_target(0x11, true, 0x22, true) == 0,
		"native damage target preserves strict identity, admits only exact prototype fallback, and rejects ambiguity");
	{
		GenerationDispatchGate gate;
		auto first = gate.try_dispatch();
		auto nested = gate.try_dispatch();
		check(first && nested && gate.in_flight() == 1,
			"nested host callbacks share one generation borrow");
		std::atomic_bool mutation_entered = false;
		std::atomic_bool release_mutation = false;
		std::atomic_bool mutation_passed = false;
		std::thread mutator([&]
		{
			auto mutation = gate.begin_mutation(std::chrono::seconds(2));
			mutation_passed.store(static_cast<bool>(mutation), std::memory_order_release);
			mutation_entered.store(true, std::memory_order_release);
			while (!release_mutation.load(std::memory_order_acquire))
				std::this_thread::yield();
		});
		for (int wait = 0; wait != 200 && gate.accepting(); ++wait)
			std::this_thread::sleep_for(std::chrono::milliseconds(1));
		std::atomic_bool outsider_admitted = false;
		std::thread outsider([&]
		{
			auto attempt = gate.try_dispatch();
			outsider_admitted.store(static_cast<bool>(attempt), std::memory_order_release);
		});
		outsider.join();
		check(!mutation_entered.load(std::memory_order_acquire) && !gate.accepting()
			&& !outsider_admitted.load(std::memory_order_acquire),
			"generation mutation closes new callback admission and waits for borrowers");
		nested = {};
		check(gate.in_flight() == 1,
			"nested callback release retains the outer generation borrow");
		first = {};
		for (int wait = 0; wait != 200
			&& !mutation_entered.load(std::memory_order_acquire); ++wait)
		{
			std::this_thread::sleep_for(std::chrono::milliseconds(1));
		}
		check(mutation_entered.load(std::memory_order_acquire)
			&& mutation_passed.load(std::memory_order_acquire)
			&& gate.in_flight() == 0 && !gate.accepting() && !gate.try_dispatch(),
			"old generation drains before mutation and stays closed during commit");
		release_mutation.store(true, std::memory_order_release);
		mutator.join();
		auto after = gate.try_dispatch();
		check(after && gate.accepting() && gate.in_flight() == 1,
			"successful generation commit reopens callback admission");
		auto illegal_mutation = gate.begin_mutation(std::chrono::milliseconds(0));
		check(!illegal_mutation && gate.accepting() && gate.in_flight() == 1,
			"callback thread cannot retire the generation it currently borrows");
		check(gate.current_thread_dispatching(),
			"generation owner exposes the current callback borrow for additive binding");
		check(!target_addon_action_requires_exclusive_mutation(
				true, false, TargetAddonGenerationAction::replace_roots)
			&& !target_addon_action_requires_exclusive_mutation(
				true, true, TargetAddonGenerationAction::reuse)
			&& !target_addon_action_requires_exclusive_mutation(
				true, true, TargetAddonGenerationAction::reactivate_roots)
			&& target_addon_action_requires_exclusive_mutation(
				true, true, TargetAddonGenerationAction::replace_roots)
			&& !target_addon_action_requires_exclusive_mutation(
				false, true, TargetAddonGenerationAction::replace_roots),
			"borrowed target loads preserve immediate reuse and root reactivation while destructive replacement waits");
	}
	{
		VmMemorySampleGate gate;
		check(!gate.admit(false, true, 1) && !gate.admit(true, false, 1)
			&& gate.sequence == 0, "memory off or foreign execution admits no reads");
		check(gate.admit(true, true, 1) && !gate.admit(true, true, 5000)
			&& gate.admit(true, true, 5001) && gate.sequence == 2,
			"memory evidence accepts exact five-second boundaries");
		for (std::uint64_t now = 5002; now != 10001; ++now) {
			if (gate.admit(true, true, now)) pass = false;
		}
		check(gate.sequence == 2 && gate.admit(true, true, 10001),
			"4999 VM returns between samples perform no diagnostic work");
		check(!gate.admit(false, true, 10002) && !gate.admit(true, true, 10003)
			&& gate.admit(true, true, 15001),
			"config off performs no work and re-enable respects the five-second limit");
		check(sample_vm_host_error(1) && sample_vm_host_error(8) && !sample_vm_host_error(9)
			&& sample_vm_host_error(16) && !sample_vm_host_error(17) && !sample_vm_host_error(0),
			"host errors are bounded with an explicit suppression boundary");
		check(native_gray_link_offset_u43(7) == 0x28 && native_gray_link_offset_u43(8) == 8
			&& native_gray_link_offset_u43(10) == 0x68 && native_gray_link_offset_u43(12) == 0x80
			&& native_gray_link_offset_u43(9) == -1,
			"native GC queue tags have exact links and unsupported tags reject");
	}
	{
		int observer_calls = 0;
		check(preserve_stock_interrupt_result(800000u, [&] { ++observer_calls; }) == 800000u
			&& observer_calls == 1,
			"interrupt observer admits the exact stock limit and preserves its result");
		check(preserve_stock_interrupt_result(800001u, [&] { ++observer_calls; }) == 800001u
			&& observer_calls == 1,
			"interrupt observer bypasses before the stock over-limit error path");
		check(preserve_stock_interrupt_result(42u, [&]() -> void {
			++observer_calls;
			throw 1;
		}) == 42u && observer_calls == 2,
			"interrupt observer contains C++ failures and preserves the stock result");
	}
	{
		std::uint32_t stock_count = 799999;
		for (int callback = 0; callback != 10000; ++callback) {
			{
				ScopedInjectedInterruptBudget budget(stock_count);
				if (stock_count != 0) { pass = false; break; }
				stock_count += 400;
			}
			if (stock_count != 799999) { pass = false; break; }
		}
		check(stock_count == 799999, "10000 finite callbacks preserve a near-limit stock allowance");
		++stock_count;
		check(stock_count == 800000, "stock consumes its own next interrupt normally");
		bool still_bounded = false;
		try {
			ScopedInjectedInterruptBudget outer(stock_count);
			stock_count = 123;
			{
				ScopedInjectedInterruptBudget inner(stock_count);
				stock_count = 800001;
				still_bounded = stock_count > 800000;
			}
			check(stock_count == 123, "nested callback restores its immediate caller allowance");
			throw 1;
		} catch (int) {}
		check(still_bounded && stock_count == 800000,
			"callback retains watchdog threshold and restores stock count on unwind");
		std::uint32_t other_vm_count = 400;
		{
			ScopedInjectedInterruptBudget budget(other_vm_count);
			other_vm_count = 50;
			check(stock_count == 800000, "another VM's callback cannot change the stock thread");
		}
		check(other_vm_count == 400, "another VM's allowance restores independently");
	}
	{
		struct Stack { std::uint8_t marked; int* outtop; };
		int old_storage[2]{133, 0}, relocated[2]{133, 0};
		Stack stack{4, old_storage};
		int barriers = 0;
		const bool appended = checked_stack_append(stack, *stack.outtop,
			[&](int slots) { stack.outtop = relocated + 1; return slots == 1; },
			[&] { ++barriers; stack.marked &= static_cast<std::uint8_t>(~4u); });
		check(appended && relocated[1] == 133 && stack.outtop == relocated + 2
			&& barriers == 1 && stack.marked == 0,
			"GC stack publication copies the source before reservation relocates the stack");
		Stack other{4, old_storage};
		check(!checked_stack_append(other, 500, [](int) { return false; }, [&] { ++barriers; })
			&& other.outtop == old_storage && old_storage[0] == 133 && other.marked == 4
			&& barriers == 1,
			"failed native reservation preserves stack and collector, independently per VM");
	}
	{
		check(caster_diagnostic_lane("GetHudStatus") == CasterDiagnosticLane::hud
			&& caster_diagnostic_lane("GetBuffNotifications") == CasterDiagnosticLane::hud
			&& caster_diagnostic_limit(CasterDiagnosticLane::hud, 32768) == 32768
			&& caster_diagnostic_limit(CasterDiagnosticLane::combat, 32768) == 1024
			&& caster_diagnostic_limit(CasterDiagnosticLane::calculation, 32768) == 256,
			"HUD observer has a finite independent budget without reducing combat or calculation quotas");
		check(caster_diagnostic_limit(CasterDiagnosticLane::hud, 0) == 1,
			"empty configured budget cannot restore unbounded HUD work");
	}

    {
        // One snapshot writes several records. A snapshot-count limit alone
        // admits expensive work after its output sink has already exhausted.
        std::uint64_t records = 0, observer_allocations = 0, stock_calls = 0;
        for (unsigned call = 0; call != 10000; ++call) {
            const bool admitted = diagnostic_snapshot_work_allowed(
                renovice::config::DiagnosticsMode::battle, records, 32);
            if (admitted) { ++observer_allocations; records += 4; }
            ++stock_calls;
        }
        check(observer_allocations == 8 && records == 32 && stock_calls == 10000,
            "exhausted output budget stops inserted snapshots but preserves every stock call");
        check(!diagnostic_snapshot_work_allowed(renovice::config::DiagnosticsMode::off,0,32)
            && !diagnostic_snapshot_work_allowed(renovice::config::DiagnosticsMode::errors,0,32)
            && diagnostic_snapshot_work_allowed(renovice::config::DiagnosticsMode::trace,31,32)
            && !diagnostic_snapshot_work_allowed(renovice::config::DiagnosticsMode::trace,32,32)
            && !diagnostic_snapshot_work_allowed(renovice::config::DiagnosticsMode::battle,0,0),
            "shared observer admission respects mode, exact exhaustion and empty capacity");
        check(diagnostic_snapshot_work_allowed(renovice::config::DiagnosticsMode::battle,0,32),
            "accepted generation reset reopens the existing output budget");
    }
    {
        renovice::config::Flags flags;
        flags.diagnostics_buffs = true;
        check(!universal_buffs_requested(flags) && !universal_observer_requested(flags),
            "buff capture off performs no observer work");
        flags.diagnostics_mode = renovice::config::DiagnosticsMode::errors;
        check(!universal_buffs_requested(flags), "errors mode does not enable buff formatting");
        flags.diagnostics_mode = renovice::config::DiagnosticsMode::battle;
        check(universal_buffs_requested(flags) && universal_observer_requested(flags)
            && !automatic_scripted_damage_requested(flags),
            "native buff capture works independently of damage capture");
        flags.diagnostics_buffs = false;
        check(!universal_observer_requested(flags)
			&& !diagnostics_claims_native_method(flags, "GetHudStatus")
			&& !diagnostics_claims_native_method(flags, "DamageDD"),
			"diagnostics off leaves installed process hooks with no diagnostic handler work");
		flags.diagnostics_damage_capture = renovice::config::DamageCaptureMode::scripted;
		flags.diagnostics_damage_type_filter_valid = true;
		check(diagnostics_claims_native_method(flags, "DamageDD")
			&& !diagnostics_claims_native_method(flags, "RadialDamage"),
			"scripted diagnostics claims only its active native methods");
		flags.diagnostics_damage_capture = renovice::config::DamageCaptureMode::engine;
		check(diagnostics_claims_native_method(flags, "RadialDamage"),
			"engine diagnostics claims the engine radial-damage ingress");
    }
	{
		using namespace renovice::engine_damage;
		constexpr std::uintptr_t address = 0x21cf2593d5cull;
		const auto encode = [](std::int32_t value, std::uintptr_t location) {
			return std::rotr(std::bit_cast<std::uint32_t>(value)
				^ static_cast<std::uint32_t>(location >> 3) ^ 0xc55198a3u, 19);
		};
		check(decode_integer(encode(1000,address),address) == 1000
			&& decode_integer(encode(867,address),address) == 867
			&& decode_integer(encode(1000,address),address) - decode_integer(encode(867,address),address) == 133
			&& decode_integer(encode(-47,address),address) == -47,
			"native integer getter records 133 damage and negative health without float reinterpretation or thresholds");
		const float base = 500.5f;
		const auto encoded_base = std::rotr(std::bit_cast<std::uint32_t>(base)
			^ static_cast<std::uint32_t>(address >> 3) ^ 0x635bf253u, 30);
		check(decode_float(encoded_base,address) == base,
			"native UpgradedValue decode preserves fractional damage input");
		renovice::config::Flags flags;
		flags.diagnostics_damage_capture = renovice::config::DamageCaptureMode::engine;
		check(!requested(flags), "native diagnostics off performs no capture");
		flags.diagnostics_mode = renovice::config::DiagnosticsMode::battle;
		check(requested(flags) && selected(flags,0,"","","","avatar"),
			"native capture accepts damage without a Lua source or a target addon");
		flags.diagnostics_damage_source = "known.lua";
		check(selected(flags,0,"","Known.lua","RadialDamage","avatar")
			&& !selected(flags,0,"","Other.lua","RadialDamage","avatar"),
			"native source isolation is exact and case insensitive");
		flags.diagnostics_damage_type_filter_valid = false;
		check(!requested(flags), "invalid native damage type filter fails closed");
	}
	{
		constexpr std::uintptr_t function_entry = 0x00007ff66d131890ull;
		constexpr std::uintptr_t code_cave = 0x00007ff66b5f2ff3ull;
		constexpr auto installed_displacement = static_cast<std::int32_t>(
			static_cast<std::int64_t>(code_cave)
			- static_cast<std::int64_t>(function_entry + 5u));
		check(exact_relative_jump_to(
				function_entry, 0xE9u, installed_displacement, code_cave)
			&& exact_relative_jump_to(code_cave, 0xE9u, -5, code_cave)
			&& !exact_relative_jump_to(
				function_entry, 0xE8u, installed_displacement, code_cave),
			"compact hook lifecycle distinguishes the installed target jump from the captured self-loop failure");
	}
	{
		using BridgeAction = DiagnosticBridgeAction;
		check(!diagnostic_bridge_may_format(
				renovice::config::DiagnosticsMode::off)
			&& !diagnostic_bridge_may_format(
				renovice::config::DiagnosticsMode::errors)
			&& diagnostic_bridge_may_format(
				renovice::config::DiagnosticsMode::battle)
			&& diagnostic_bridge_may_format(
				renovice::config::DiagnosticsMode::trace)
			&& classify_diagnostic_bridge_action(false, false, false, true)
				== BridgeAction::leave_absent
			&& classify_diagnostic_bridge_action(false, true, true, true)
				== BridgeAction::remove_owned
			&& classify_diagnostic_bridge_action(false, true, false, true)
				== BridgeAction::leave_foreign_disabled
			&& classify_diagnostic_bridge_action(true, false, false, true)
				== BridgeAction::install
			&& classify_diagnostic_bridge_action(true, true, true, true)
				== BridgeAction::keep_owned
			&& classify_diagnostic_bridge_action(true, true, false, true)
				== BridgeAction::reject_collision
			&& classify_diagnostic_bridge_action(false, true, true, false)
				== BridgeAction::reject_prerequisite
			&& classify_diagnostic_bridge_action(true, false, false, false)
				== BridgeAction::reject_prerequisite,
			"diagnostic bridge formats in battle or trace mode and mutates only its owned field");
	}
	{
		renovice::config::Flags trace_flags;
		trace_flags.diagnostics_mode = renovice::config::DiagnosticsMode::trace;
		trace_flags.diagnostics_target_filter_set = true;
		trace_flags.diagnostics_target_key = 0x08faf07b504d058full;
		trace_flags.diagnostics_method = "pushfloatarg";
		trace_flags.diagnostics_addon = "mallet.target.addon.lua_b";
		check(diagnostic_error_event("native.call.provider.error")
			&& diagnostic_error_event("source.reject")
			&& !diagnostic_error_event("native.call.return"),
			"diagnostic errors mode recognizes only failure outcomes");
		check(!diagnostic_runtime_event_allowed(
				renovice::config::DiagnosticsMode::off, "native.call.provider.error")
			&& diagnostic_runtime_event_allowed(
				renovice::config::DiagnosticsMode::errors, "native.call.provider.error")
			&& !diagnostic_runtime_event_allowed(
				renovice::config::DiagnosticsMode::errors, "native.call.return")
			&& diagnostic_runtime_event_allowed(
				renovice::config::DiagnosticsMode::battle, "source.reject")
			&& !diagnostic_runtime_event_allowed(
				renovice::config::DiagnosticsMode::battle, "native.call.return")
			&& diagnostic_runtime_event_allowed(
				renovice::config::DiagnosticsMode::trace, "native.call.return"),
			"battle mode keeps explicit bridge records and runtime errors without full hook chatter");
		check(diagnostic_trace_selected(
				trace_flags, 0x08faf07b504d058full,
				"native.call.provider.enter",
				"method=PushFloatArg addon=Mallet.Target.Addon.lua_B registry=x")
			&& !diagnostic_trace_selected(
				trace_flags, 0x08faf07b504d058full,
				"native.call.provider.enter",
				"method=SetSourceObject addon=Mallet.Target.Addon.lua_B registry=x")
			&& !diagnostic_trace_selected(
				trace_flags, 0x1111,
				"native.call.provider.enter",
				"method=PushFloatArg addon=Mallet.Target.Addon.lua_B registry=x")
			&& !diagnostic_trace_selected(
				trace_flags, 0x08faf07b504d058full,
				"native.call.provider.enter",
				"method=PushFloatArg addon=Other.lua_B registry=x"),
			"diagnostic target method and addon filters compose exactly");
		trace_flags.diagnostics_addon.clear();
		check(diagnostic_trace_selected(
				trace_flags, 0x08faf07b504d058full,
				"nativeCalls.PushFloatArg.before", {})
			&& !diagnostic_trace_selected(
				trace_flags, 0x08faf07b504d058full,
				"nativeCalls.PushFloatArgument.before", {})
			&& !diagnostic_trace_selected(
				trace_flags, 0x08faf07b504d058full,
				"native.call.provider.enter",
				"notmethod=PushFloatArg addon=x"),
			"diagnostic method filter rejects event prefixes and partial field names");
		trace_flags.diagnostics_target_filter_valid = false;
		check(!diagnostic_trace_selected(
			trace_flags, 0x08faf07b504d058full,
			"native.call.provider.enter",
			"method=PushFloatArg addon=Mallet.Target.Addon.lua_B registry=x"),
			"invalid diagnostic target filter fails closed");
	}
	{
		renovice::config::Flags ingress_flags;
		ingress_flags.diagnostics_mode = renovice::config::DiagnosticsMode::trace;
		ingress_flags.diagnostics_target_filter_set = true;
		ingress_flags.diagnostics_target_filter_valid = true;
		ingress_flags.diagnostics_target_key = 0xf62b70b45fc7fdf9ull;
		ingress_flags.diagnostics_method = "damagedd";
		check(diagnostic_native_ingress_selected(ingress_flags, "DamageDD")
			&& !diagnostic_native_ingress_selected(ingress_flags, "Damage")
			&& sample_native_ingress(1, 4096)
			&& sample_native_ingress(128, 4096)
			&& !sample_native_ingress(129, 4096)
			&& !sample_native_ingress(9, 8),
			"native ingress trace uses exact method selection and the smaller bounded budget");
		ingress_flags.diagnostics_addon = "icewave.target.addon.lua_b";
		check(!diagnostic_native_ingress_selected(ingress_flags, "DamageDD"),
			"native ingress trace rejects an addon filter before provider ownership is known");
		ingress_flags.diagnostics_addon.clear();
		ingress_flags.diagnostics_target_filter_valid = false;
		check(!diagnostic_native_ingress_selected(ingress_flags, "DamageDD"),
			"native ingress trace rejects an invalid target filter");
		ingress_flags.diagnostics_target_filter_valid = true;
		ingress_flags.diagnostics_mode = renovice::config::DiagnosticsMode::errors;
		check(!diagnostic_native_ingress_selected(ingress_flags, "DamageDD"),
			"native ingress trace is disabled outside trace mode");
	}
	{
		std::uint64_t detailed = 0;
		for (std::uint64_t i = 1; i <= 10000; ++i)
			detailed += sample_damage_trace(i, 0, false);
		check(detailed == 22 && sample_damage_trace(50, 1, true)
			&& sample_damage_trace(60, 3, true) && !sample_damage_trace(70, 4, true),
			"ten thousand zero callbacks sample 22 details; first positive results remain visible");
		DamagePerformanceWindow window;
		window.add(false, true, 7, 0);
		window.add(true, false, 29, 1);
		window.add(true, false, 11, 0);
		check(window.calls == 3 && window.positive == 2 && window.zero == 1
			&& window.errors == 1 && window.ticks == 47 && window.maximum_ticks == 29,
			"performance aggregation retains every callback duration and error despite detail sampling");
	}
	{
		// Fake process memory exercises the production reader against a nested
		// graph, shared descendants, corruption, cycles, and traversal budgets.
		std::unordered_map<std::uintptr_t, std::vector<unsigned char>> memory;
		const auto node = [&](std::uintptr_t address, std::vector<std::uint64_t> children)
		{
			auto& bytes = memory[address]; bytes.assign(0xb0, 0);
			bytes[0] = 12;
			std::uint64_t code = 0x90000, array = address + 0x100000;
			std::int32_t instructions = 19, count = static_cast<std::int32_t>(children.size());
			std::memcpy(bytes.data() + 0x10, &code, 8);
			std::memcpy(bytes.data() + 0x18, &array, 8);
			std::memcpy(bytes.data() + 0x88, &instructions, 4);
			std::memcpy(bytes.data() + 0x8c, &count, 4);
			auto& pointers = memory[array]; pointers.resize(children.size() * 8);
			if (!children.empty()) std::memcpy(pointers.data(), children.data(), pointers.size());
		};
		const auto read = [&](std::uintptr_t address, void* output, std::size_t size)
		{
			const auto it = memory.find(address);
			if (it == memory.end() || it->second.size() < size) return false;
			std::memcpy(output, it->second.data(), size); return true;
		};
		node(0x10000, {0x20000, 0x30000});
		node(0x20000, {0x40000}); node(0x30000, {0x40000}); node(0x40000, {});
		auto graph = collect_target_proto_graph_u43(0x10000, read);
		check(!graph.error && graph.records.size() == 4
			&& graph.records[2].address == 0x40000,
			"prototype graph includes grandchildren and shared descendants once");
		node(0x40000, {0x10000});
		graph = collect_target_proto_graph_u43(0x10000, read);
		check(graph.error && std::string_view(graph.error) == "prototype-cycle"
			&& graph.records.empty(), "cyclic prototype graph rejects every partial identity");
		node(0x40000, {}); memory.erase(0x30000);
		graph = collect_target_proto_graph_u43(0x10000, read);
		check(graph.error && graph.records.empty() && graph.error_address == 0x30000,
			"unreadable descendant rejects whole graph with exact failure address");
		node(0x30000, {0x40000}); memory[0x30000][0] = 7;
		graph = collect_target_proto_graph_u43(0x10000, read);
		check(graph.error && graph.records.empty(), "wrong DE prototype tag rejects graph");
		node(0x30000, {0x40000});
		check(collect_target_proto_graph_u43(0x10000, read, 3).error
			&& collect_target_proto_graph_u43(0x10000, read, 4096, 2).error,
			"prototype count and nesting limits reject rather than truncate");
		node(0x40000, {0});
		check(collect_target_proto_graph_u43(0x10000, read).error != nullptr,
			"null child rejects prototype ownership graph");
	}

	check(classify_script("damage_hook.lua_B") == ScriptKind::Ordinary,
		"ordinary one-shot classification");
	check(classify_script("damage_hook.addon.lua_B") == ScriptKind::ManagedAddon,
		"managed addon classification");
	check(classify_script("damage_hook.ADDON.LUA_b") == ScriptKind::ManagedAddon,
		"managed addon marker is case-insensitive");
	check(classify_script("08faf07b504d058f.mallet.target.addon.lua_B")
		== ScriptKind::TargetManagedAddon,
		"target-managed addon takes precedence over the generic addon marker");
	check(classify_script("08FAF07B504D058F.mallet.TARGET.ADDON.LUA_b")
		== ScriptKind::TargetManagedAddon,
		"target-managed addon marker is case-insensitive");
	check(target_addon_target_discovery_required(
			ScriptKind::TargetManagedAddon, true)
		&& target_addon_target_discovery_required(
			ScriptKind::TargetManagedAddon, false)
		&& !target_addon_target_discovery_required(
			ScriptKind::ManagedAddon, true),
		"target body-key discovery is independent of enabled policy");
	{
		std::uint64_t target = 0;
		check(target_addon_key("08faf07b504d058f.mallet.target.addon.lua_B", target)
			&& target == 0x08faf07b504d058full,
			"target-managed addon binds to its exact original-body key");
	}
	{
		std::uint64_t target = 0;
		check(!target_addon_key("not-a-body-key.mallet.target.addon.lua_B", target)
			&& !target_addon_key("08faf07b504d058f.mallet.addon.lua_B", target),
			"target-managed addon rejects invalid keys and generic addon names");
	}
	{
		// Multi-target addon (2026-09-29): one file, several exact module keys.
		std::uint64_t target = 0;
		check(classify_script("Missions.targets.addon.lua_B")
				== ScriptKind::TargetManagedAddon
			&& classify_script("Missions.TARGETS.ADDON.lua_B")
				== ScriptKind::TargetManagedAddon
			&& is_multi_target_addon("Missions.targets.addon.lua_B")
			&& !is_multi_target_addon("f10a043e7f825db2.missions.target.addon.lua_B")
			&& !is_multi_target_addon("Missions.addon.lua_B"),
			"multi-target addon uses the target-managed lane and is distinguished by .targets.addon");
		check(!target_addon_key("Missions.targets.addon.lua_B", target)
			&& !target_addon_key("f10a043e7f825db2.Missions.targets.addon.lua_B", target),
			"multi-target addon never binds through a filename key prefix");
		check(multi_target_filename_error("Missions.targets.addon.lua_B") == nullptr
			&& std::string_view(multi_target_filename_error(
				"f10a043e7f825db2.Missions.targets.addon.lua_B"))
				== "multi-target-filename-has-key-prefix"
			&& std::string_view(multi_target_filename_error(
				"f10a043e7f825db2.missions.target.addon.lua_B"))
				== "not-multi-target-filename",
			"multi-target filename contract rejects an ambiguous key prefix");
		bool legacy = true;
		for (const auto& [name, key] : std::vector<std::pair<const char*, std::uint64_t>>{
			{"64d11e6973afa4b1.EliteSanctuaryNoRank.target.addon.lua_B", 0x64d11e6973afa4b1ull},
			{"8fba3a28f8fef624.IceWaveColdStackDamage.target.addon.lua_B", 0x8fba3a28f8fef624ull},
			{"95ef5b82a8400944.CircuitProgressPreviewX5.target.addon.lua_B", 0x95ef5b82a8400944ull},
			{"ec368d4901690a15.MalletOverguardAndCard.target.addon.lua_B", 0xec368d4901690a15ull},
			{"f10a043e7f825db2.missions.target.addon.lua_B", 0xf10a043e7f825db2ull}})
		{
			std::uint64_t parsed = 0;
			legacy = legacy && classify_script(name) == ScriptKind::TargetManagedAddon
				&& !is_multi_target_addon(name)
				&& target_addon_key(name, parsed) && parsed == key;
		}
		check(legacy, "existing single-key target addons keep their exact filename binding");

		const auto pool = [](const std::vector<std::string>& strings)
		{
			std::vector<unsigned char> bytes{0x09, 0x03};
			const auto varint = [&](std::uint64_t value)
			{
				do
				{
					unsigned char byte = static_cast<unsigned char>(value & 0x7fu);
					value >>= 7;
					if (value != 0) byte |= 0x80u;
					bytes.push_back(byte);
				} while (value != 0);
			};
			varint(strings.size());
			for (const auto& text : strings)
			{
				varint(text.size());
				bytes.insert(bytes.end(), text.begin(), text.end());
			}
			bytes.push_back(0x00);
			return bytes;
		};
		std::vector<std::uint64_t> keys;
		auto bytes = pool({"activate", "f10a043e7f825db2", std::string(200, 'x'),
			"F10A043E7F825DB3", "6fa60841c9e0f207", "0123456789abcdeg",
			"f10a043e7f825db2", "f10a043e7f825db", "targets"});
		check(discover_multi_target_keys(bytes.data(), bytes.size(), keys) == nullptr
			&& keys == std::vector<std::uint64_t>{0x6fa60841c9e0f207ull, 0xf10a043e7f825db2ull},
			"declared keys are exact lowercase 16-hex pool strings, sorted and unique");
		bytes = pool({"activate", "cleanup"});
		check(std::string_view(discover_multi_target_keys(bytes.data(), bytes.size(), keys))
				== "no-declared-target-keys" && keys.empty(),
			"multi-target file without declared keys is rejected");
		bytes = pool({"0000000000000000", "f10a043e7f825db2"});
		check(std::string_view(discover_multi_target_keys(bytes.data(), bytes.size(), keys))
				== "declared-target-key-zero",
			"zero declared key is rejected");
		bytes = pool({"f10a043e7f825db2"});
		bytes[1] = 0x02;
		check(std::string_view(discover_multi_target_keys(bytes.data(), bytes.size(), keys))
				== "not-de-bytecode-container",
			"non-DE container is rejected before pool parsing");
		bytes = pool({"f10a043e7f825db2"});
		bytes.resize(10);
		check(std::string_view(discover_multi_target_keys(bytes.data(), bytes.size(), keys))
				== "string-pool-entry-truncated",
			"truncated pool entry is rejected");
		const unsigned char unterminated[] = {0x09, 0x03, 0x80, 0x80};
		check(std::string_view(discover_multi_target_keys(unterminated, sizeof(unterminated), keys))
				== "string-pool-count-truncated",
			"unterminated pool count varint is rejected");
		std::vector<std::string> many;
		for (std::size_t i = 1; i <= maximum_multi_target_keys + 1; ++i)
		{
			char text[17]{};
			format_target_key_text(i, text);
			many.emplace_back(text);
		}
		bytes = pool(many);
		check(std::string_view(discover_multi_target_keys(bytes.data(), bytes.size(), keys))
				== "too-many-declared-target-keys",
			"declared target count is bounded");
		char text[17]{};
		format_target_key_text(0xf10a043e7f825db2ull, text);
		check(std::string_view(text) == "f10a043e7f825db2",
			"binding selects targets[key] with the exact declared lowercase text");

		using F = MultiTargetSelectFailure;
		check(classify_multi_target_selection(true, true, true, false, true,
				true, false, true, true, false, true) == F::none
			&& classify_multi_target_selection(true, true, true, false, true,
				false, true, false, false, true, false) == F::none,
			"entry lifecycle wins, absent entry lifecycle inherits the top-level function");
		check(classify_multi_target_selection(true, true, true, false, true,
				false, false, true, true, false, true) == F::activate_missing
			&& classify_multi_target_selection(true, true, true, false, true,
				false, true, false, true, false, false) == F::cleanup_missing
			&& classify_multi_target_selection(true, true, true, false, true,
				false, true, false, false, false, true) == F::cleanup_missing,
			"present non-function entry lifecycle never falls back; missing everywhere fails");
		check(classify_multi_target_selection(false, true, true, false, true,
				true, true, true, true, true, true) == F::container_not_table
			&& classify_multi_target_selection(true, false, true, false, true,
				true, true, true, true, true, true) == F::container_has_hooks
			&& classify_multi_target_selection(true, true, false, false, true,
				true, true, true, true, true, true) == F::targets_not_table
			&& classify_multi_target_selection(true, true, true, true, false,
				true, true, true, true, true, true) == F::entry_missing
			&& classify_multi_target_selection(true, true, true, false, false,
				true, true, true, true, true, true) == F::entry_not_table,
			"container, top-level hooks, targets table and entry shape reject exactly");
		bool labels = true;
		for (int code = 1; code <= 7; ++code)
			labels = labels && std::string_view(multi_target_select_failure_label(code)) != "unknown"
				&& std::string_view(multi_target_select_failure_label(code)) != "none";
		check(labels && std::string_view(multi_target_select_failure_label(99)) == "unknown",
			"every multi-target selection failure has an exact label");
	}
	{
		// Target root instances and exact-prototype attribution (2026-09-29).
		struct RootIdentity
		{
			std::uint64_t target_key = 0;
			void* global_state = nullptr;
			void* environment = nullptr;
			void* root_proto = nullptr;
			bool runtime_root = false;
			int tag = 0;
		};
		auto* const vm = reinterpret_cast<void*>(0x1000);
		auto* const other_vm = reinterpret_cast<void*>(0x2000);
		auto* const root = reinterpret_cast<void*>(0x3000);
		auto* const load_env = reinterpret_cast<void*>(0x4000);
		auto* const runtime_env = reinterpret_cast<void*>(0x5000);
		auto* const next_env = reinterpret_cast<void*>(0x6000);
		std::vector<RootIdentity> ids{{0xf10a043e7f825db2ull, vm, load_env, root, false, 1}};
		RootIdentity created{};
		check(record_target_root_return(ids, 0xf10a043e7f825db2ull, vm, root, load_env)
				== TargetRootReturnAction::same_environment && ids.size() == 1,
			"root return in the load environment keeps the loader binding");
		check(record_target_root_return(ids, 0xf10a043e7f825db2ull, vm, root, runtime_env, &created)
				== TargetRootReturnAction::rebind && ids.size() == 2
				&& ids.back().environment == runtime_env && ids.back().runtime_root
				&& created.tag == 1 && ids.front().environment == load_env,
			"root return in a new environment records a runtime identity and requests one rebind");
		check(record_target_root_return(ids, 0xf10a043e7f825db2ull, vm, root, runtime_env)
				== TargetRootReturnAction::same_environment && ids.size() == 2,
			"repeated return of the bound root instance is idempotent");
		check(record_target_root_return(ids, 0xf10a043e7f825db2ull, vm, root, next_env)
				== TargetRootReturnAction::rebind && ids.size() == 2
				&& ids.back().environment == next_env,
			"a later root instance replaces the previous runtime identity (bounded, latest instance binds)");
		check(record_target_root_return(ids, 0xf10a043e7f825db2ull, other_vm, root, runtime_env)
				== TargetRootReturnAction::not_a_target_root
			&& record_target_root_return(ids, 0x95ef5b82a8400944ull, vm, root, runtime_env)
				== TargetRootReturnAction::not_a_target_root
			&& record_target_root_return(ids, 0xf10a043e7f825db2ull, vm,
				reinterpret_cast<void*>(0x3100), runtime_env)
				== TargetRootReturnAction::not_a_target_root
			&& ids.size() == 2,
			"root return never crosses VM, module key or loaded root prototype");
		// Bound once (live run 2026-09-29): IceSpike.lua 3,470 and SurvivalMission 8
		// per-instance rebinds; only an unbound module gets one retry per generation.
		check(!target_root_return_watch_required(true, true, false)
				&& !target_root_return_watch_required(true, true, true),
			"a module whose addons are bound is never watched or rebound at root return");
		check(target_root_return_watch_required(true, false, false)
				&& !target_root_return_watch_required(true, false, true),
			"an unbound module gets exactly one root-return retry per generation");
		check(!target_root_return_watch_required(false, false, false),
			"a module without a desired target addon is never watched");

		// Fix 3 (live 2026-09-29, pid 23260): DuviriUtil's root closure kept its
		// entry environment across module(...); the published environment is the
		// one the root's child closures were created with.
		{
			auto* const root_env = reinterpret_cast<void*>(0x7000);
			auto* const module_env = reinterpret_cast<void*>(0x8000);
			RootEnvironmentAccumulator none;
			const auto kept = none.choose(root_env);
			check(kept.environment == root_env && kept.source == RootEnvironmentSource::root_closure
					&& none.child_closures == 0,
				"no child closure in the dead register window keeps the root closure environment");
			RootEnvironmentAccumulator agree;
			agree.add(module_env);
			agree.add(nullptr);
			agree.add(module_env);
			agree.add(module_env);
			const auto chosen = agree.choose(root_env);
			check(chosen.environment == module_env && chosen.source == RootEnvironmentSource::child_closure
					&& agree.child_closures == 3,
				"child closures that agree select the environment the module's own functions use");
			RootEnvironmentAccumulator split;
			split.add(module_env);
			split.add(next_env);
			const auto ambiguous = split.choose(root_env);
			check(ambiguous.environment == root_env && ambiguous.source == RootEnvironmentSource::ambiguous,
				"disagreeing child closures are ambiguous and keep the root closure environment (fail closed)");
			RootEnvironmentAccumulator same;
			same.add(root_env);
			check(same.choose(root_env).environment == root_env
					&& same.choose(root_env).source == RootEnvironmentSource::child_closure,
				"child closures in the root environment confirm it");
			const void* children[] = {reinterpret_cast<void*>(0x9000), reinterpret_cast<void*>(0x9100)};
			check(proto_is_direct_child(children, 2, reinterpret_cast<void*>(0x9100))
					&& !proto_is_direct_child(children, 2, reinterpret_cast<void*>(0x9200))
					&& !proto_is_direct_child(nullptr, 2, reinterpret_cast<void*>(0x9000))
					&& !proto_is_direct_child(children, 0, reinterpret_cast<void*>(0x9000)),
				"only closures over the root prototype's direct children count");
			check(std::string_view(root_environment_source_label(RootEnvironmentSource::child_closure)) == "child-closure",
				"root environment source label is stable");
		}

		// Diagnostics hot path (Mallet lag audit 2026-09-29).
		{
			auto* const vm_a = reinterpret_cast<void*>(0x1000);
			auto* const vm_b = reinterpret_cast<void*>(0x2000);
			const auto base_identity = native_hook_event_identity("afterDamage", 0xec368d4901690a15ull, vm_a);
			check(base_identity == native_hook_event_identity("afterDamage", 0xec368d4901690a15ull, vm_a)
					&& base_identity != native_hook_event_identity("afterDamage", 0xec368d4901690a15ull, vm_b)
					&& base_identity != native_hook_event_identity("afterDamagf", 0xec368d4901690a15ull, vm_a)
					&& base_identity != native_hook_event_identity("afterDamage", 0x8fba3a28f8fef624ull, vm_a),
				"native hook PASS identity is a cheap exact (event, key, VM) hash");
			check(diagnostic_per_hit_event("damage.callback.enter") && diagnostic_per_hit_event("dispatch.return")
					&& diagnostic_per_hit_event("native.float.transform") && diagnostic_per_hit_event("lua.call.before.reject")
					&& !diagnostic_per_hit_event("module.prototype") && !diagnostic_per_hit_event("source.attach-return"),
				"only per-hit lanes are rate limited; load-time structural events are not");
			DiagnosticEventRateLimiter limiter;
			std::uint32_t admitted = 0;
			for (std::uint32_t i = 0; i != 100; ++i)
				admitted += limiter.admit("damage.callback.enter", 1000 + i).admit ? 1u : 0u;
			check(admitted == diagnostic_rate_lines_per_window,
				"a hot event admits exactly the per-window limit");
			const auto other = limiter.admit("dispatch.enter", 1100);
			check(other.admit && !other.report.pending, "event names are limited independently");
			const auto rolled = limiter.admit("damage.callback.enter", 2000);
			check(rolled.admit && rolled.report.pending
					&& std::string_view(rolled.report.event) == "damage.callback.enter"
					&& rolled.report.admitted == diagnostic_rate_lines_per_window
					&& rolled.report.suppressed == 100 - diagnostic_rate_lines_per_window,
				"a new window reports exactly one suppression summary with admitted and suppressed counts");
			const auto quiet = limiter.admit("damage.callback.enter", 2001);
			check(quiet.admit && !quiet.report.pending, "a summary is reported once (deduplicated)");
			for (std::uint32_t i = 0; i != 40; ++i) (void)limiter.admit("dispatch.enter", 1101 + i);
			const auto expired = limiter.admit("native.float.transform", 3000);
			check(expired.admit && expired.report.pending
					&& std::string_view(expired.report.event) == "dispatch.enter",
				"a window that ended with suppressed lines is reported on the next trace call of any event");
			DiagnosticEventRateLimiter full;
			for (std::size_t i = 0; i != diagnostic_rate_event_slots; ++i)
				(void)full.admit("damage.e" + std::to_string(i), 10);
			const auto dropped = full.admit("damage.overflow", 11);
			check(!dropped.admit && full.untracked_dropped() == 1,
				"events beyond the bounded slot table are dropped and counted");
			full.reset();
			check(full.admit("damage.overflow", 12).admit && full.untracked_dropped() == 0,
				"reset (F9 / bridge change) clears windows and drop counts");
		}

		struct ProtoIdentity
		{
			std::uint64_t target_key = 0;
			void* global_state = nullptr;
			void* environment = nullptr;
			void* root_proto = nullptr;
			std::vector<TargetProtoRecord> prototypes;
		};
		const auto graph = [](std::uintptr_t base, std::int32_t count, std::int32_t root_id)
		{
			std::vector<TargetProtoRecord> records;
			for (std::int32_t id = 0; id != count; ++id)
			{
				records.push_back({base + static_cast<std::uintptr_t>(id) * 0x100,
					id == root_id ? 0 : base + static_cast<std::uintptr_t>(root_id) * 0x100,
					0x900000 + static_cast<std::uintptr_t>(id) * 0x40, 16, id});
			}
			return records;
		};
		constexpr std::uintptr_t survival_base = 0x7000000;
		constexpr std::uintptr_t unrelated_base = 0x9000000;
		std::vector<ProtoIdentity> modules{
			{0xf10a043e7f825db2ull, vm, load_env,
				reinterpret_cast<void*>(survival_base + 90 * 0x100), graph(survival_base, 91, 90)},
			{0x0123456789abcdefull, vm, load_env,
				reinterpret_cast<void*>(unrelated_base + 3 * 0x100), graph(unrelated_base, 4, 3)}};
		const auto always_live = [](const TargetProtoRecord&) { return true; };
		bool survival = true;
		for (const std::int32_t id : {31, 33, 55, 58, 60, 61, 62, 67, 68, 69})
		{
			const auto owner = select_target_prototype_owner(modules, vm, runtime_env,
				survival_base + static_cast<std::uintptr_t>(id) * 0x100, always_live);
			survival = survival && owner.exact && !owner.ambiguous
				&& !owner.strict_environment
				&& owner.target_key == 0xf10a043e7f825db2ull && owner.bytecode_id == id;
		}
		check(survival,
			"SurvivalMission luaCalls prototypes 31/33/55/58/60/61/62/67/68/69 dispatch from a runtime-environment closure");
		const auto unrelated = select_target_prototype_owner(modules, vm, next_env,
			unrelated_base + 2 * 0x100, always_live);
		check(unrelated.exact && unrelated.target_key == 0x0123456789abcdefull
			&& unrelated.bytecode_id == 2,
			"unrelated module attributes by the same generic prototype rule");
		const auto strict = select_target_prototype_owner(modules, vm, load_env,
			survival_base + 61 * 0x100, always_live);
		check(strict.exact && strict.strict_environment && strict.bytecode_id == 61,
			"a load-environment closure still reports the strict environment match");
		check(!select_target_prototype_owner(modules, other_vm, runtime_env,
				survival_base + 61 * 0x100, always_live).exact
			&& !select_target_prototype_owner(modules, vm, runtime_env,
				0x5000000, always_live).exact
			&& !select_target_prototype_owner(modules, vm, runtime_env,
				survival_base + 61 * 0x100,
				[](const TargetProtoRecord& record) { return record.bytecode_id != 61; }).exact
			&& !select_target_prototype_owner(modules, vm, runtime_env,
				survival_base + 61 * 0x100,
				[](const TargetProtoRecord& record) { return record.bytecode_id != 90; }).exact,
			"wrong VM, unknown prototype, dead prototype and dead root all fail closed");
		auto conflicting = modules;
		conflicting.push_back({0x1111111111111111ull, vm, load_env,
			reinterpret_cast<void*>(survival_base + 90 * 0x100), graph(survival_base, 91, 90)});
		const auto ambiguous = select_target_prototype_owner(conflicting, vm, runtime_env,
			survival_base + 61 * 0x100, always_live);
		check(!ambiguous.exact && ambiguous.ambiguous,
			"one prototype claimed by two module keys is rejected as ambiguous");

		char text[lua_error_text_capacity]{};
		const std::string_view error = "Lotus/Scripts/Circuit:12: \"RENOVICE_CIRCUIT_STAGE_XP_GETTER_NOT_FUNCTION\"\n\x01\\";
		sanitize_error_text(error.data(), error.size(), text, sizeof(text));
		check(std::string_view(text)
				== "Lotus/Scripts/Circuit:12: 'RENOVICE_CIRCUIT_STAGE_XP_GETTER_NOT_FUNCTION' ?/",
			"error text keeps printable ASCII and neutralizes quotes, controls and backslashes");
		const std::string long_error(1000, 'x');
		const auto written = sanitize_error_text(long_error.data(), long_error.size(), text, sizeof(text));
		check(written == sizeof(text) - 1 && std::string_view(text).substr(written - 3) == "..."
			&& sanitize_error_text(nullptr, 5, text, sizeof(text)) == 0 && text[0] == '\0',
			"error text is bounded, truncation is marked and null input is empty");
	}
	check(classify_script("state.persist.lua_B") == ScriptKind::ExperimentalPersistent,
		"persistent experiment classification");
	check(classify_script("state.PERSIST.lua_B") == ScriptKind::ExperimentalPersistent,
		"persistent rejection marker is case-insensitive");
	check(classify_script("loop.spawn.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn experiment classification");
	check(classify_script("loop.SPAWN.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn rejection marker is case-insensitive");
	check(classify_script("both.persist.spawn.lua_B") == ScriptKind::ExperimentalSpawn,
		"spawn takes precedence like deployed runner");
	check(is_lua_bytecode_extension(".lua_B") && is_lua_bytecode_extension(".LUA_b")
		&& !is_lua_bytecode_extension(".lua"), "case-insensitive bytecode extension");
	check(valid_chunk_size(1) && valid_chunk_size((1ull << 20) - 1)
		&& !valid_chunk_size(0) && !valid_chunk_size(1ull << 20), "chunk size boundaries");
	check(valid_execution_boundary(true, true, true),
		"live boundary accepted when it shares the captured manager VM");
	check(!valid_execution_boundary(true, false, true)
		&& !valid_execution_boundary(false, true, true)
		&& !valid_execution_boundary(true, true, false),
		"missing or cross-VM execution boundary rejected");
	using MutationBlocker = LuaMutationBoundaryBlocker;
	check(lua_mutation_boundary_blocker(
			0, 0x1000, 0x1100, 0x1120, 0x2000,
			0x3000, 0x3000, 0x3100, 0x28, false, false, false)
			== MutationBlocker::Ready
		&& lua_mutation_boundary_blocker(
			0, 0x1000, 0x1100, 0x1120, 0x2000,
			0x3000, 0x3028, 0x3100, 0x28, true, true, true)
			== MutationBlocker::Ready,
		"reload mutation accepts an idle base frame or an exact native host frame");
	check(lua_mutation_boundary_blocker(
			1, 0x1000, 0x1100, 0x1120, 0x2000,
			0x3000, 0x3028, 0x3100, 0x28, true, true, true)
			== MutationBlocker::ThreadSuspended
		&& lua_mutation_boundary_blocker(
			0, 0x1000, 0x1110, 0x1100, 0x2000,
			0x3000, 0x3028, 0x3100, 0x28, true, true, true)
			== MutationBlocker::StackOrderInvalid
		&& lua_mutation_boundary_blocker(
			0, 0x1000, 0x1100, 0x1120, 0x2000,
			0x3000, 0x3028, 0x3100, 0x28, true, false, false)
			== MutationBlocker::CurrentFrameInvalid
		&& lua_mutation_boundary_blocker(
			0, 0x1000, 0x1100, 0x1120, 0x2000,
			0x3000, 0x3028, 0x3100, 0x28, true, true, false)
			== MutationBlocker::LuaFrameActive,
		"reload mutation rejects the reproduced suspended, inverted-stack, invalid-frame, and active-Lua boundaries");
	check(!safe_runtime_transaction_should_run(false, false)
		&& safe_runtime_transaction_should_run(true, false)
		&& safe_runtime_transaction_should_run(false, true),
		"DE VM return callback runs only for startup or explicit reload work");
	check(!idle_vm_generation_work_allowed(false, false)
		&& idle_vm_generation_work_allowed(true, false)
		&& idle_vm_generation_work_allowed(false, true),
		"idle VM ticks are Lua-free while startup and explicit reload retain VM work");
	check(safe_runtime_tick_boundary_blocker(
		nullptr, 41, nullptr, 41, 0, 0, true, false)
		== SafeRuntimeTickBoundaryBlocker::MissingCapturedVm
		&& safe_runtime_tick_boundary_blocker(
			&pass, 41, &pass, 41, 1, 0, true, false)
			== SafeRuntimeTickBoundaryBlocker::VmExecutionActive
		&& safe_runtime_tick_boundary_blocker(
			&pass, 41, &pass, 41, 0, 0, true, true)
			== SafeRuntimeTickBoundaryBlocker::CallbackActive,
		"blocked reload boundaries expose their exact safety reason");
	check(vm_loader_may_drain_pending(0),
		"ordinary VM-local loader boundary may drain pending refreshes");
	check(!vm_loader_may_drain_pending(1) && !vm_loader_may_drain_pending(2),
		"nested loader cannot re-enter an active RENOVICE VM transaction");
	check(target_addon_may_activate(true, true, 0)
		&& !target_addon_may_activate(false, true, 0)
		&& !target_addon_may_activate(true, false, 0)
		&& !target_addon_may_activate(true, true, 1),
		"target addon activates only after a successful outer natural target load");
	{
		// MSVC /O2 may pool address-only const scalar fixtures. Distinct array
		// elements retain language-guaranteed object identity.
		int vm_identities[2] = {1, 2};
		auto* const hud_vm = &vm_identities[0];
		auto* const arsenal_vm = &vm_identities[1];
		check(same_target_addon_context(
			0x08faf07b504d058full, hud_vm, 17,
			0x08faf07b504d058full, hud_vm, 17)
			&& !same_target_addon_context(
				0x08faf07b504d058full, hud_vm, 17,
				0x08faf07b504d058full, arsenal_vm, 17)
			&& !same_target_addon_context(
				0x08faf07b504d058full, hud_vm, 17,
				0x08faf07b504d058full, hud_vm, 18),
			"target addon generations are isolated by exact module key VM and owner thread");
	}
	check(same_target_addon_generation(11, 0x1000, 11, 0x1000)
		&& !same_target_addon_generation(11, 0x1000, 12, 0x1000)
		&& !same_target_addon_generation(11, 0x1000, 11, 0x2000)
		&& !same_target_addon_generation(11, 0, 11, 0),
		"target addon generation includes exact shared-table identity");
	check(!target_addon_generation_rebind_required(1, 1, true)
		&& target_addon_generation_rebind_required(1, 1, false)
		&& target_addon_generation_rebind_required(1, 0, true)
		&& target_addon_generation_rebind_required(0, 1, true)
		&& !target_addon_generation_rebind_required(0, 0, false),
		"target addon maintenance reacts only to membership or exact _T generation drift");
	check(classify_target_addon_generation_action(true, true)
			== TargetAddonGenerationAction::reuse
		&& classify_target_addon_generation_action(true, false)
			== TargetAddonGenerationAction::reactivate_roots
		&& classify_target_addon_generation_action(false, true)
			== TargetAddonGenerationAction::replace_roots
		&& classify_target_addon_generation_action(false, false)
			== TargetAddonGenerationAction::replace_roots,
		"target addon reload reuses exact roots reactivates them for _T drift and replaces only changed content");
	check(failed_chunk_has_lifecycle_root_to_release(true, true)
		&& !failed_chunk_has_lifecycle_root_to_release(true, false)
		&& !failed_chunk_has_lifecycle_root_to_release(false, true)
		&& !failed_chunk_has_lifecycle_root_to_release(false, false),
		"failed chunk cleanup releases only a lifecycle root that was actually stored");
	check(valid_target_closure_environment(true, true, true)
		&& !valid_target_closure_environment(false, true, true)
		&& !valid_target_closure_environment(true, false, true)
		&& !valid_target_closure_environment(true, true, false),
		"target addon requires the exact readable borrowed module closure environment");
	check(lua_call_request_supported(true, false)
		&& !lua_call_request_supported(true, true)
		&& !lua_call_request_supported(false, true)
		&& !lua_call_request_supported(false, false),
		"nested Lua hook admission supports before-only and rejects after until complete retirement ownership exists");
	{
		// MSVC /O2 may pool address-only const scalar fixtures. Distinct elements
		// of one live array have language-guaranteed distinct addresses.
		int identities[6] = {1, 2, 3, 4, 5, 6};
		auto* const vm_id = &identities[0];
		auto* const other_vm_id = &identities[1];
		auto* const root_proto_id = &identities[2];
		auto* const nested_proto_id = &identities[3];
		auto* const module_environment_id = &identities[4];
		auto* const other_environment_id = &identities[5];
		check(same_target_hook_module(
				vm_id, root_proto_id, module_environment_id,
				vm_id, root_proto_id, other_environment_id)
			&& same_target_hook_module(
				vm_id, root_proto_id, module_environment_id,
				vm_id, nested_proto_id, module_environment_id),
			"target hook accepts the exact module root and nested module closures");
		check(!same_target_hook_module(
				vm_id, root_proto_id, module_environment_id,
				other_vm_id, root_proto_id, module_environment_id)
			&& !same_target_hook_module(
				vm_id, root_proto_id, module_environment_id,
				vm_id, nested_proto_id, other_environment_id),
			"target hook rejects cross-VM and unrelated module closures");
		check(same_target_root_execution(
				vm_id, root_proto_id, module_environment_id,
				vm_id, root_proto_id, module_environment_id)
			&& !same_target_root_execution(
				vm_id, root_proto_id, module_environment_id,
				vm_id, nested_proto_id, module_environment_id)
			&& !same_target_root_execution(
				vm_id, root_proto_id, module_environment_id,
				other_vm_id, root_proto_id, module_environment_id)
			&& !same_target_root_execution(
				vm_id, root_proto_id, module_environment_id,
				vm_id, root_proto_id, other_environment_id),
			"post-execution decorator accepts only exact module root execution");
	}
	check(native_hook_binding_valid(1, 1)
		&& native_hook_binding_valid(4, 1),
		"native hook accepts one implementation with any number of aliases");
	check(!native_hook_binding_valid(0, 0)
		&& !native_hook_binding_valid(2, 0)
		&& !native_hook_binding_valid(2, 2),
		"native hook rejects absent and ambiguous native implementations");
	check(exact_native_call_bindings_valid(1, 1, 0, 32)
		&& exact_native_call_bindings_valid(4, 1, 0, 32)
		&& exact_native_call_bindings_valid(4, 4, 0, 32)
		&& exact_native_call_bindings_valid(4, 4, 28, 32),
		"exact nativeCalls accepts one or several implementations within the hook budget");
	check(!exact_native_call_bindings_valid(0, 0, 0, 32)
		&& !exact_native_call_bindings_valid(2, 0, 0, 32)
		&& !exact_native_call_bindings_valid(2, 3, 0, 32)
		&& !exact_native_call_bindings_valid(4, 4, 29, 32)
		&& !exact_native_call_bindings_valid(1, 1, 33, 32),
		"exact nativeCalls rejects absent, impossible, and over-budget binding sets");
	check(native_detour_bundle_valid(true, true, true, true),
		"native damage adapter enables only when both semantic detours have trampolines");
	check(!native_detour_bundle_valid(false, true, true, true)
		&& !native_detour_bundle_valid(true, false, true, true)
		&& !native_detour_bundle_valid(true, true, false, true)
		&& !native_detour_bundle_valid(true, true, true, false),
		"native damage adapter rejects every partial two-detour bundle");
	check(native_hook_adapter_bundle_valid(
			true, true, true, true, true, true)
		&& native_hook_adapter_bundle_valid(
			true, false, true, true, false, true)
		&& native_hook_adapter_bundle_valid(
			false, true, false, false, true, true)
		&& native_hook_adapter_bundle_valid(
			false, false, false, false, false, true),
		"native adapter bundle accepts every complete requested capability");
	check(!native_hook_adapter_bundle_valid(
			true, false, false, true, false, true)
		&& !native_hook_adapter_bundle_valid(
			true, false, true, false, false, true)
		&& !native_hook_adapter_bundle_valid(
			false, true, false, false, false, true)
		&& !native_hook_adapter_bundle_valid(
			false, false, false, false, false, false),
		"native adapter bundle rejects every missing requested hook");
	{
		const std::vector<std::string> installed{
			"DamageDD", "GetHudStatus", "RadialDamage"};
		check(native_hook_contract_covered(7, installed, 0, {})
			&& native_hook_contract_covered(7, installed, 1, {})
			&& native_hook_contract_covered(7, installed, 4,
				std::vector<std::string>{"DamageDD", "RadialDamage"}),
			"process-owned native hook superset covers dormant and subset handler contracts");
		check(!native_hook_contract_covered(1, installed, 2, {})
			&& !native_hook_contract_covered(7, installed, 4,
				std::vector<std::string>{"SetSource"}),
			"native hook coverage identifies only genuinely missing capabilities");
		check(merge_native_hook_methods(
				installed, std::vector<std::string>{"DamageDD", "SetSource"})
			== std::vector<std::string>({
				"DamageDD", "GetHudStatus", "RadialDamage", "SetSource"}),
			"process-owned native method installation grows monotonically without duplicates");
	}
	check(classify_run_script_observation(
			true, false, 4, true, true, true, true)
			== RunScriptObservationDecision::ObserveAbilityCard,
		"RunScript observer accepts only the synchronous ability-card query shape");
	check(classify_run_script_observation(
			false, false, 4, true, true, true, true)
			== RunScriptObservationDecision::PassThroughDisabled
		&& classify_run_script_observation(
			true, true, 4, true, true, true, true)
			== RunScriptObservationDecision::PassThroughReentry,
		"RunScript observer is transparent while disabled or re-entered");
	check(classify_run_script_observation(
			true, false, 3, true, true, true, true)
			== RunScriptObservationDecision::PassThroughArgumentShape
		&& classify_run_script_observation(
			true, false, 4, false, true, true, true)
			== RunScriptObservationDecision::PassThroughArgumentShape
		&& classify_run_script_observation(
			true, false, 4, true, false, true, true)
			== RunScriptObservationDecision::PassThroughArgumentShape,
		"RunScript observer rejects wrong arity asynchronous and non-boolean calls");
	check(classify_run_script_observation(
			true, false, 4, true, true, false, true)
			== RunScriptObservationDecision::PassThroughQueryShape
		&& classify_run_script_observation(
			true, false, 4, true, true, true, false)
			== RunScriptObservationDecision::PassThroughQueryShape,
		"RunScript observer rejects missing query tables and missing ability identity");
	check(classify_run_script_observation_result(0, true)
			== RunScriptObservationResult::Complete
		&& classify_run_script_observation_result(0, false)
			== RunScriptObservationResult::MissingAbilityCardResult
		&& classify_run_script_observation_result(1, true)
			== RunScriptObservationResult::OriginalResultCountChanged,
		"RunScript observer distinguishes complete missing-result and ABI-drift outcomes");
	check(should_sample_run_script_entry(64, 0, 2, false, false)
		&& !should_sample_run_script_entry(65, 0, 2, false, false)
		&& should_sample_run_script_entry(1000, 256, 4, true, true)
		&& !should_sample_run_script_entry(1000, 257, 4, true, true)
		&& !should_sample_run_script_entry(1000, 1, 4, true, false),
		"RunScript diagnostic sampling is bounded while retaining synchronous candidates");
	check(run_script_target_binding_candidate(true, 4, true, true, 0xABC)
		&& !run_script_target_binding_candidate(false, 4, true, true, 0xABC)
		&& !run_script_target_binding_candidate(true, 3, true, true, 0xABC)
		&& !run_script_target_binding_candidate(true, 4, false, true, 0xABC)
		&& !run_script_target_binding_candidate(true, 4, true, false, 0xABC)
		&& !run_script_target_binding_candidate(true, 4, true, true, 0),
		"target binding observes every exact synchronous RunScript resource shape even before card query globals exist");
	{
		int vm_identities[2] = {1, 2};
		auto* const vm = &vm_identities[0];
		auto* const other_vm = &vm_identities[1];
		check(target_script_binding_capture_allowed(
			0x1234, vm, 17, true, vm, 17, 0xABC)
			&& !target_script_binding_capture_allowed(
				0x1234, vm, 17, false, vm, 17, 0xABC)
			&& !target_script_binding_capture_allowed(
				0x1234, vm, 17, true, other_vm, 17, 0xABC)
			&& !target_script_binding_capture_allowed(
				0x1234, vm, 17, true, vm, 18, 0xABC)
			&& !target_script_binding_capture_allowed(
				0x1234, vm, 17, true, vm, 17, 0),
			"target script binding is captured only inside the exact RunScript VM and thread");
		check(same_target_script_binding(0x1234, vm, 0xABC, 0x1234, vm, 0xABC)
			&& !same_target_script_binding(0x1234, vm, 0xABC, 0x5678, vm, 0xABC)
			&& !same_target_script_binding(0x1234, vm, 0xABC, 0x1234, other_vm, 0xABC)
			&& !same_target_script_binding(0x1234, vm, 0xABC, 0x1234, vm, 0xDEF),
			"target script binding requires exact key VM and base-script resource identity");
	}
	check(valid_target_hook_contract(false, true, true, false, true, false, true, true, true)
		&& valid_target_hook_contract(false, true, true, false, false, true, true, true, true)
		&& valid_target_hook_contract(false, true, false, true, false, true, true, true, true)
		&& valid_target_hook_contract(false, true, false, false, false, true, true, true, true)
		&& valid_target_hook_contract(false, true, true, true, true, true, true, true, true),
		"content-keyed target addon owns afterDamage without an object matcher");
	check(valid_target_hook_contract(true, false, false, false, false, false, true, true, true)
		&& valid_target_hook_contract(false, true, false, false, false, false, true, true, true)
		&& valid_target_hook_contract(false, true, true, false, false, false, true, true, true),
		"target addon accepts lifecycle-only injection with absent or unused optional hooks");
	check(!valid_target_hook_contract(false, false, false, false, false, false, true, true, true)
		&& !valid_target_hook_contract(false, true, false, false, true, false, true, true, true)
		&& !valid_target_hook_contract(false, true, false, false, false, false, false, true, true)
		&& !valid_target_hook_contract(false, true, false, false, false, false, true, false, true)
		&& !valid_target_hook_contract(false, true, false, false, false, false, true, true, false),
		"target addon rejects malformed hooks and unmatched card projections");
	check(valid_lua_call_prototype_id(0.0f)
		&& valid_lua_call_prototype_id(64.0f)
		&& !valid_lua_call_prototype_id(-1.0f)
		&& !valid_lua_call_prototype_id(64.5f)
		&& !valid_lua_call_prototype_id(1048577.0f),
		"Lua call hooks accept only bounded exact prototype IDs");
	check(target_lua_scalar_mutation_allowed(3, 3, true)
		&& target_lua_scalar_mutation_allowed(1, 1, false)
		&& !target_lua_scalar_mutation_allowed(3, 3, false)
		&& !target_lua_scalar_mutation_allowed(3, 1, true)
		&& !target_lua_scalar_mutation_allowed(6, 6, true),
		"Lua call hooks copy back finite same-tag scalar upvalues only");
	check(target_lua_argument_mutation_allowed(true, 3, 3, true)
		&& target_lua_argument_mutation_allowed(true, 1, 1, false)
		&& !target_lua_argument_mutation_allowed(false, 3, 3, true)
		&& !target_lua_argument_mutation_allowed(true, 3, 3, false)
		&& !target_lua_argument_mutation_allowed(true, 3, 1, true)
		&& !target_lua_argument_mutation_allowed(true, 6, 6, true),
		"Lua before hooks copy back finite same-tag scalar arguments only");
	check(target_addon_requires_native_damage_adapters(true, true)
		&& target_addon_requires_native_damage_adapters(false, true)
		&& !target_addon_requires_native_damage_adapters(true, false)
		&& !target_addon_requires_native_damage_adapters(false, false),
		"native damage detours are opt-in only when afterDamage is declared");
	check(target_addon_requires_native_callsite_adapters(true)
		&& !target_addon_requires_native_callsite_adapters(false),
		"instruction-addressed native argument detours require an explicit transform hook");
	check(!target_addon_requires_execution_identity(false, false, false, false)
		&& target_addon_requires_execution_identity(true, false, false, false)
		&& target_addon_requires_execution_identity(false, true, false, false)
		&& target_addon_requires_execution_identity(false, false, true, false)
		&& target_addon_requires_execution_identity(false, false, false, true),
		"every execution-scoped transport publishes the target prototype identity");
	{
		std::uint32_t instruction = 0;
		check(instruction_from_saved_pc(0x100000, 981,
			0x100000 + (596 + 1) * sizeof(std::uint32_t), instruction)
			&& instruction == 596,
			"savedpc resolves to the exact calling instruction");
		check(!instruction_from_saved_pc(0x100000, 981, 0x100000, instruction)
			&& !instruction_from_saved_pc(0x100000, 981,
				0x100000 + 982 * sizeof(std::uint32_t), instruction)
			&& !instruction_from_saved_pc(0x100002, 981,
				0x100000 + sizeof(std::uint32_t), instruction),
			"instruction resolver rejects out-of-range and misaligned program counters");
	}
	{
		constexpr std::uint32_t fixed_call = 0x03030554u; // CALL R5, 2 args, 2 results.
		DeLuaCallInstruction decoded;
		check(decode_de_lua_call_instruction(fixed_call, decoded)
			&& decoded.register_a == 5
			&& decoded.encoded_arguments_b == 3
			&& decoded.encoded_results_c == 3,
			"DE CALL decoder preserves exact A B C operands");
		check(!decode_de_lua_call_instruction(0x03030529u, decoded),
			"DE CALL decoder rejects RETURN and every non-CALL opcode");

		DeLuaCallWindow window;
		check(resolve_de_lua_call_window(
				fixed_call, 0x1100, 0x1300, 0x1120,
				0x1000, 0x1400, 0x10, 256, window)
			&& window.function_slot == 0x1150
			&& window.argument_base == 0x1160
			&& window.argument_count == 2,
			"fixed-arity DE CALL resolves caller base plus A and B minus one arguments");

		constexpr std::uint32_t open_call = 0x01000554u;
		check(resolve_de_lua_call_window(
				open_call, 0x1100, 0x1300, 0x11a0,
				0x1000, 0x1400, 0x10, 256, window)
			&& window.function_slot == 0x1150
			&& window.argument_base == 0x1160
			&& window.argument_count == 4,
			"B zero DE CALL derives open argument count from the live VM top");

		check(!resolve_de_lua_call_window(
				0x01000529u, 0x1100, 0x1300, 0x11a0,
				0x1000, 0x1400, 0x10, 256, window)
			&& !resolve_de_lua_call_window(
				open_call, 0x1100, 0x1300, 0x1150,
				0x1000, 0x1400, 0x10, 256, window)
			&& !resolve_de_lua_call_window(
				0x0103ff54u, 0x1100, 0x1300, 0x1120,
				0x1000, 0x1400, 0x10, 256, window)
			&& !resolve_de_lua_call_window(
				fixed_call, 0x1100, 0x1170, 0x1120,
				0x1000, 0x1400, 0x10, 256, window),
			"nested CALL window fails closed on opcode top register and frame-boundary mismatches");
	}
	{
		// Logical instruction 1 is a two-word NAMECALL; logical instruction 2
		// is its CALL. The live VM savedpc points after CALL, while the API
		// catalog addresses NAMECALL itself.
		const std::uint32_t code[] = {
			0x00000001u,
			0x0000002du, 0x12345678u,
			0x00000054u,
			0x00000001u,
		};
		std::uint32_t instruction = 0;
		check(native_callsite_instruction_from_saved_pc(
				code, 5, code + 4, instruction) && instruction == 1,
			"native savedpc maps CALL back to its catalog NAMECALL instruction");
		check(native_callsite_instruction_from_saved_pc(
				code, 5, code + 1, instruction) && instruction == 0,
			"non-NAMECALL savedpc retains its decoded logical instruction");
		check(!native_callsite_instruction_from_saved_pc(
				code, 5, code + 3, instruction),
			"native instruction resolver rejects a savedpc that lands after an AUX word");
		check(de_instruction_has_aux_word(0x2d)
			&& de_instruction_has_aux_word(0x4a)
			&& !de_instruction_has_aux_word(0x54),
			"runtime uses the certified U43 DE width table");
	}
	{
		int vm_identities[2] = {0, 0};
		auto* const vm = &vm_identities[0];
		auto* const other_vm = &vm_identities[1];
		check(target_execution_scope_matches(0x1234, vm, vm)
			&& !target_execution_scope_matches(0, vm, vm)
			&& !target_execution_scope_matches(0x1234, nullptr, vm)
			&& !target_execution_scope_matches(0x1234, vm, other_vm),
			"target execution scope requires an exact non-null VM and target key");
	}
	{
		std::uint64_t selected = 0;
		check(merge_target_ability_match(0, selected) && selected == 0
			&& merge_target_ability_match(0x1234, selected) && selected == 0x1234
			&& merge_target_ability_match(0x1234, selected) && selected == 0x1234
			&& !merge_target_ability_match(0x5678, selected),
			"ability matcher accepts no match and same-target addons but rejects ambiguity");
	}
	{
		constexpr std::uintptr_t base = 0x100000;
		constexpr std::size_t stride = 0x28;
		check(valid_target_call_stack_bounds(base, base, stride, 4096)
			&& valid_target_call_stack_bounds(base + stride * 31, base, stride, 4096)
			&& !valid_target_call_stack_bounds(0, base, stride, 4096)
			&& !valid_target_call_stack_bounds(base, 0, stride, 4096)
			&& !valid_target_call_stack_bounds(base - stride, base, stride, 4096)
			&& !valid_target_call_stack_bounds(base + 1, base, stride, 4096)
			&& !valid_target_call_stack_bounds(base + stride * 4096, base, stride, 4096),
			"active target call-stack walk accepts aligned bounded CallInfo frames only");
	}
	check(target_addon_refresh_required(true, false)
		&& target_addon_refresh_required(true, true)
		&& target_addon_refresh_required(false, true)
		&& !target_addon_refresh_required(false, false),
		"target refresh covers create replace and deletion cleanup transactions");
	check(sample_repeated_skip_trace(1)
		&& sample_repeated_skip_trace(8)
		&& !sample_repeated_skip_trace(9)
		&& !sample_repeated_skip_trace(255)
		&& sample_repeated_skip_trace(256)
		&& sample_repeated_skip_trace(512),
		"repeated yielded-call diagnostics retain first evidence and sparse recurrence without exhausting the trace budget");
	{
		int vm_identities[2] = {1, 2};
		auto* const vm = &vm_identities[0];
		auto* const other_vm = &vm_identities[1];
		check(target_addon_refresh_ready(vm, 17, vm, 17)
			&& !target_addon_refresh_ready(vm, 17, other_vm, 17)
			&& !target_addon_refresh_ready(vm, 17, vm, 18)
			&& !target_addon_refresh_ready(nullptr, 17, nullptr, 17),
			"target refresh executes only at the exact VM and owner-thread boundary");
	}
	{
		bool was_down = false;
		const bool first = consume_f9_signal(true, false, true, was_down);
		const bool unfocused_release = consume_f9_signal(false, false, false, was_down);
		const bool second = consume_f9_signal(true, false, true, was_down);
		check(first && !unfocused_release && second,
			"F9 release while unfocused rearms the next focused press");
	}
	{
		bool was_down = false;
		const bool unfocused_press = consume_f9_signal(true, true, false, was_down);
		const bool focus_while_held = consume_f9_signal(true, false, true, was_down);
		const bool release = consume_f9_signal(false, false, true, was_down);
		const bool fresh_press = consume_f9_signal(true, false, true, was_down);
		check(!unfocused_press && !focus_while_held && !release && fresh_press,
			"F9 pressed outside Warframe cannot trigger on focus transfer");
	}
	check(lua_provider_callback_argument_count() == 4
		&& lua_provider_trace_argument_index() == 3,
		"luaCalls callback ABI appends the host trace as its fourth argument");
	check(native_provider_callback_argument_count(false) == 4
		&& native_provider_trace_argument_index(false) == 3
		&& native_provider_callback_argument_count(true) == 5
		&& native_provider_trace_argument_index(true) == 4,
		"nativeCalls callback ABI appends the host trace after before and after payloads");
	{
		renovice::config::Flags flags;
		flags.diagnostics_mode = renovice::config::DiagnosticsMode::battle;
		flags.diagnostics_target_filter_set = true;
		flags.diagnostics_target_filter_valid = true;
		flags.diagnostics_target_key = 0xf62b70b45fc7fdf9ull;
		check(preserve_owned_diagnostic_bridge_for_other_target(
				flags, true, false, false)
			&& !preserve_owned_diagnostic_bridge_for_other_target(
				flags, true, false, true),
			"an unrelated target activation preserves the VM-wide trace bridge while global reconciliation owns removal");
		flags.diagnostics_mode = renovice::config::DiagnosticsMode::off;
		check(!preserve_owned_diagnostic_bridge_for_other_target(
				flags, true, false, false),
			"diagnostics off never preserves an owned trace bridge");
		flags.diagnostics_mode = renovice::config::DiagnosticsMode::battle;
		flags.diagnostics_target_filter_valid = false;
		check(!preserve_owned_diagnostic_bridge_for_other_target(
				flags, true, false, false),
			"an invalid diagnostic target cannot preserve an owned trace bridge");
		check(diagnostic_bridge_registry_root_required(true, false)
			&& diagnostic_bridge_registry_root_required(false, true)
			&& diagnostic_bridge_registry_root_required(false, false, true)
			&& !diagnostic_bridge_registry_root_required(false, false),
			"diagnostic trace closure stays GC-rooted for selected, preserved, or automatic capture lifetime");
	}
	{
		renovice::config::Flags flags;
		flags.diagnostics_mode = renovice::config::DiagnosticsMode::battle;
		flags.diagnostics_damage_capture =
			renovice::config::DamageCaptureMode::scripted;
		check(automatic_scripted_damage_requested(flags)
			&& automatic_scripted_damage_selected(
				flags, "DamageDD", 0x1234, "lotus/test", "test", "avatar")
			&& !automatic_scripted_damage_selected(
				flags, "RadialDamage", 0x1234, "lotus/test", "test", "avatar"),
			"automatic damage capture selects only the proven per-target DamageDD boundary");
		flags.diagnostics_target_filter_set = true;
		flags.diagnostics_target_key = 0x1234;
		flags.diagnostics_damage_source = "lotus/test";
		flags.diagnostics_damage_target_type = "avatar";
		check(automatic_scripted_damage_selected(
				flags, "DamageDD", 0x1234, "Lotus/Test", "Test", "Avatar")
			&& !automatic_scripted_damage_selected(
				flags, "DamageDD", 0x5678, "Lotus/Test", "Test", "Avatar")
			&& !automatic_scripted_damage_selected(
				flags, "DamageDD", 0x1234, "Lotus/Other", "Other", "Avatar")
			&& !automatic_scripted_damage_selected(
				flags, "DamageDD", 0x1234, "Lotus/Test", "Test", "Vehicle"),
			"automatic damage source body path and target type filters isolate exact records");
	}
	{
		bool was_down = false;
		const bool quick_tap = consume_f9_signal(false, true, true, was_down);
		const bool idle = consume_f9_signal(false, false, true, was_down);
		check(quick_tap && !idle,
			"latched F9 tap between DE ticks produces exactly one request");
	}
	{
		bool was_down = true;
		const bool repeated_low_bit = consume_f9_signal(true, true, true, was_down);
		check(!repeated_low_bit,
			"held F9 low-bit key repeat cannot create another transaction");
	}
	struct GenerationChunk
	{
		std::string name;
		std::vector<unsigned char> bytes;
		ScriptKind kind;
	};
	struct GenerationRoot { std::string name; };
	{
		const std::vector<GenerationChunk> active{
			{"bridge.lua_B", {1, 2, 3}, ScriptKind::ManagedAddon},
			{"old.target.addon.lua_B", {9}, ScriptKind::TargetManagedAddon},
		};
		const std::vector<GenerationChunk> candidate{
			{"bridge.lua_B", {1, 2, 3}, ScriptKind::ManagedAddon},
			{"new.target.addon.lua_B", {8}, ScriptKind::TargetManagedAddon},
			{"one-shot.lua_B", {7}, ScriptKind::Ordinary},
		};
		const std::vector<GenerationRoot> roots{{"bridge.lua_B"}};
		check(unchanged_managed_generation_can_reuse_roots(
				active, candidate, roots),
			"unchanged managed bytes reuse their exact rooted generation despite unrelated script changes");
		check(!unchanged_managed_generation_can_reuse_roots(
				active, candidate, std::vector<GenerationRoot>{}),
			"managed generation without its exact lifecycle root is never reused");
	}
	{
		const std::vector<GenerationChunk> active{
			{"bridge.lua_B", {1, 2, 3}, ScriptKind::ManagedAddon},
		};
		const std::vector<GenerationRoot> roots{{"bridge.lua_B"}};
		check(!unchanged_managed_generation_can_reuse_roots(
				active,
				std::vector<GenerationChunk>{
					{"bridge.lua_B", {1, 2, 4}, ScriptKind::ManagedAddon}},
				roots)
			&& !unchanged_managed_generation_can_reuse_roots(
				active,
				std::vector<GenerationChunk>{
					{"renamed.lua_B", {1, 2, 3}, ScriptKind::ManagedAddon}},
				roots)
			&& !unchanged_managed_generation_can_reuse_roots(
				active, std::vector<GenerationChunk>{}, roots)
			&& !unchanged_managed_generation_can_reuse_roots(
				active,
				std::vector<GenerationChunk>{
					{"bridge.lua_B", {1, 2, 3}, ScriptKind::ManagedAddon},
					{"second.lua_B", {5}, ScriptKind::ManagedAddon}},
				roots),
			"managed byte rename removal and addition each force the lifecycle transaction");
	}
	{
		bool was_down = false;
		const bool blocked_tap = consume_f9_signal(false, true, false, was_down);
		const bool no_delayed_trigger = consume_f9_signal(false, false, true, was_down);
		check(!blocked_tap && !no_delayed_trigger,
			"latched F9 tap while unauthorized cannot trigger later");
	}

	struct Record { int id; };
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged{{2}, {3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::Committed && active.size() == 2
			&& active[0].id == 2 && order == "C1A2A3R1",
			"managed generation cleanup activate release order");
	}
	{
		std::vector<Record> active{{1}, {2}};
		std::vector<Record> staged{{3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return record.id != 2; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::CleanupRejected && active.size() == 2
			&& staged.empty() && order == "C1C2A1A2R3",
			"cleanup rejection reactivates old generation and releases staged roots");
	}
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged{{2}, {3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return record.id != 3; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::ActivationRejected && active.size() == 1
			&& staged.empty() && order == "C1A2A3C2C3A1R2R3",
			"activation rejection cleans new behavior reactivates old and releases staged roots");
	}
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged;
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::Committed && active.empty()
			&& staged.empty() && order == "C1R1",
			"deleting every addon cleans and releases the old generation");
	}
	{
		std::vector<Record> active{{1}};
		std::vector<Record> staged{{2}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return false; });
		check(result == TransactionResult::ReleaseRejected && active.size() == 1
			&& active[0].id == 2 && staged.empty() && order == "C1A2R1",
			"old-root release rejection reports fatal after new generation takes ownership");
	}
	{
		std::vector<Record> active{{1}, {2}};
		std::vector<Record> staged{{3}};
		std::string order;
		const auto result = commit_addon_generation(active, staged,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return record.id != 2; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return record.id != 1; },
			[&](const Record& record) { order += "R" + std::to_string(record.id); return true; });
		check(result == TransactionResult::RollbackFailed && active.size() == 2
			&& staged.empty() && order == "C1C2A1A2R3",
			"failed old-generation reactivation escalates to rollback fatal");
	}
	{
		std::vector<Record> active{{1}, {2}};
		std::string order;
		const auto result = reactivate_addon_generation(active,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return true; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; });
		check(result == TransactionResult::Committed && active.size() == 2
			&& active[0].id == 1 && active[1].id == 2
			&& order == "C1C2A1A2",
			"unchanged target generation reactivates existing roots without release or replacement");
	}
	{
		std::vector<Record> active{{1}, {2}};
		std::string order;
		const auto result = reactivate_addon_generation(active,
			[&](const Record& record) { order += "C" + std::to_string(record.id); return record.id != 2; },
			[&](const Record& record) { order += "A" + std::to_string(record.id); return true; });
		check(result == TransactionResult::CleanupRejected && active.size() == 2
			&& order == "C1C2A1A2",
			"unchanged target root cleanup rejection restores the prior active generation");
	}

	if (argc == 2)
	{
		std::error_code ec;
		std::size_t supported_count = 0;
		std::size_t unsupported = 0;
		for (std::filesystem::directory_iterator it(argv[1], ec), end; !ec && it != end; it.increment(ec))
		{
			if (!it->is_regular_file(ec))
			{
				if (ec) break;
				continue;
			}
			const auto path = it->path();
			if (!is_lua_bytecode_extension(path.extension().string())) continue;
			const bool valid_size = valid_chunk_size(std::filesystem::file_size(path, ec));
			const auto kind = classify_script(path.filename().string());
			const bool supported = kind == ScriptKind::Ordinary
				|| kind == ScriptKind::ManagedAddon
				|| kind == ScriptKind::TargetManagedAddon;
			check(valid_size && supported && !ec, path.filename().string());
			supported_count += supported ? 1 : 0;
			unsupported += supported ? 0 : 1;
			if (ec) break;
		}
		check(!ec, "Inject directory readable");
		check(unsupported == 0, "no unsupported experimental modules staged");
		std::cout << "INFO\tsupported_chunks=" << supported_count
			<< " unsupported_chunks=" << unsupported << '\n';
	}

	std::cout << (pass ? "INJECTION CORE PASS" : "INJECTION CORE FAIL") << '\n';
	return pass ? 0 : 1;
}
