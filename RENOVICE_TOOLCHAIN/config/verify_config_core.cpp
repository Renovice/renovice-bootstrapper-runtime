#include <iostream>
#include <string>
#include <string_view>

#include "../../renovice/config_core.hpp"

namespace
{
int failures = 0;

void check(bool condition, std::string_view label)
{
	std::cout << (condition ? "PASS\t" : "FAIL\t") << label << '\n';
	if (!condition) ++failures;
}
}

int main()
{
    using renovice::config::parse;
    using namespace renovice::config;
    check(!parse("").diagnostics_memory, "lightweight memory evidence defaults off");
    const auto memory_only = parse("Logging=true\nDiagnosticsMode=off\nDiagnosticsMemory=true\n");
    check(memory_only.logging && memory_only.diagnostics_memory
        && memory_only.diagnostics_mode == renovice::config::DiagnosticsMode::off
        && !memory_only.diagnostics_caster_stats && !memory_only.diagnostics_buffs
        && memory_only.diagnostics_damage_capture == renovice::config::DamageCaptureMode::off,
        "memory evidence runs while every battle observer stays off");
    check(!parse("DiagnosticsMemory=true\nDiagnosticsMemory=false\n").diagnostics_memory,
        "explicit memory off survives the config parser");
	const auto master_on = parse(
		"Diagnostics=true\nDiagnosticsMode=off\nDiagnosticsDamageCapture=off\n"
		"DiagnosticsCasterStats=false\nDiagnosticsBuffs=false\nDiagnosticsMemory=false\n");
	check(master_on.diagnostics_master_set && master_on.diagnostics_master_enabled
		&& master_on.diagnostics
		&& master_on.diagnostics_mode == renovice::config::DiagnosticsMode::trace
		&& master_on.diagnostics_damage_capture == renovice::config::DamageCaptureMode::engine
		&& master_on.diagnostics_caster_stats && master_on.diagnostics_buffs
		&& master_on.diagnostics_memory
		&& renovice::config::diagnostics_capture_enabled(master_on),
		"Diagnostics=true enables every bounded diagnostic lane");
	const auto master_off = parse(
		"Diagnostics=false\nDiagnosticsMode=trace\nDiagnosticsDamageCapture=engine\n"
		"DiagnosticsCasterStats=true\nDiagnosticsBuffs=true\nDiagnosticsMemory=true\n");
	check(master_off.diagnostics_master_set && !master_off.diagnostics_master_enabled
		&& !master_off.diagnostics
		&& master_off.diagnostics_mode == renovice::config::DiagnosticsMode::off
		&& master_off.diagnostics_damage_capture == renovice::config::DamageCaptureMode::off
		&& !master_off.diagnostics_caster_stats && !master_off.diagnostics_buffs
		&& !master_off.diagnostics_memory
		&& !renovice::config::diagnostics_capture_enabled(master_off),
		"Diagnostics=false masks every diagnostic lane regardless of detailed keys");
    check(!parse("").diagnostics_buffs, "native buff diagnostics default off");
    check(parse("DiagnosticsBuffs=TRUE\n").diagnostics_buffs,
        "exact native buff toggle enables observations");
    check(!parse("DiagnosticsBuffs=true\nDiagnosticsBuffs=false\n").diagnostics_buffs,
        "native buff toggle last key wins and false disables");

	const auto normal = parse(
		"# comment mentioning Logging=true must not enable it\r\n"
		"Logging = YES\r\nVerbose=on\r\nAutoSpawn=1\r\nDiagnostics=true\r\n");
	check(normal.logging, "Logging accepts YES case-insensitively");
	check(normal.verbose, "Verbose accepts on");
	check(normal.auto_spawn, "AutoSpawn accepts 1");
	check(normal.diagnostics
		&& normal.diagnostics_mode == renovice::config::DiagnosticsMode::trace,
		"Diagnostics=true selects the full trace profile");

	const auto filtered = parse(
		"DiagnosticsMode=errors\n"
		"DiagnosticsMaxEvents=2000\n"
		"DiagnosticsTarget=0x08FAF07B504D058F\n"
		"DiagnosticsMethod=PushFloatArg\n"
		"DiagnosticsAddon=Mallet.Target.Addon.lua_B\n");
	check(!filtered.diagnostics
		&& filtered.diagnostics_mode == renovice::config::DiagnosticsMode::errors,
		"errors mode does not install full trace bridges");
	const auto battle = parse("DiagnosticsMode=combat\nDiagnosticsMaxEvents=8192\n");
	check(!battle.diagnostics
		&& battle.diagnostics_mode == renovice::config::DiagnosticsMode::battle
		&& battle.diagnostics_max_events == 8192,
		"combat alias selects bounded battle records without legacy full trace");
	const auto automatic_damage = parse(
		"DiagnosticsMode=battle\n"
		"DiagnosticsDamageCapture=scripted\n"
		"DiagnosticsDamageSource=Lotus/Powersuits/Frost/IceSpike\n"
		"DiagnosticsDamageTargetType=Avatar\n"
		"DiagnosticsDamageType=4\n");
	check(automatic_damage.diagnostics_damage_capture
			== renovice::config::DamageCaptureMode::scripted
		&& automatic_damage.diagnostics_damage_source
			== "lotus/powersuits/frost/icespike"
		&& automatic_damage.diagnostics_damage_target_type == "avatar"
		&& automatic_damage.diagnostics_damage_type_filter_set
		&& automatic_damage.diagnostics_damage_type_filter_valid
		&& automatic_damage.diagnostics_damage_type == 4,
		"automatic scripted damage capture and exact isolation filters parse");
	const auto engine = parse("DiagnosticsMode=battle\nDiagnosticsDamageCapture=engine\n");
	check(engine.diagnostics_damage_capture == renovice::config::DamageCaptureMode::engine,
		"native engine damage capture is an explicit configuration mode");
	const auto invalid_damage_type = parse(
		"DiagnosticsMode=battle\nDiagnosticsDamageCapture=true\n"
		"DiagnosticsDamageType=20\n");
	check(invalid_damage_type.diagnostics_damage_capture
			== renovice::config::DamageCaptureMode::scripted
		&& invalid_damage_type.diagnostics_damage_type_filter_set
		&& !invalid_damage_type.diagnostics_damage_type_filter_valid,
		"damage type isolation fails closed outside the proven numeric 0-19 range");
	check(filtered.diagnostics_max_events == 2000,
		"diagnostic event budget parses exactly");
	check(filtered.diagnostics_target_filter_set
		&& filtered.diagnostics_target_filter_valid
		&& filtered.diagnostics_target_key == 0x08faf07b504d058full,
		"diagnostic target accepts an exact 64-bit body key");
	check(filtered.diagnostics_method == "pushfloatarg"
		&& filtered.diagnostics_addon == "mallet.target.addon.lua_b",
		"diagnostic method and addon filters normalize case");

	const auto bounded = parse(
		"DiagnosticsMode=trace\nDiagnosticsMaxEvents=999999\nDiagnosticsTarget=not-hex\n");
	check(bounded.diagnostics
		&& bounded.diagnostics_max_events == renovice::config::maximum_diagnostics_max_events,
		"trace mode clamps its event budget");
	check(bounded.diagnostics_target_filter_set
		&& !bounded.diagnostics_target_filter_valid,
		"invalid target filters fail closed");

	const auto disabled = parse(
		"Logging=false\nVerbose=0\nAutoSpawn=off\nDiagnostics=no\n");
	check(!disabled.logging && !disabled.verbose && !disabled.auto_spawn
		&& !disabled.diagnostics,
		"documented false values disable all flags");

	const auto comments = parse("# Logging=true\n;Verbose=true\nnotLogging=true\n");
	check(!comments.logging && !comments.verbose && !comments.auto_spawn
		&& !comments.diagnostics,
		"comments and partial keys cannot enable flags");

	const auto duplicate = parse("Logging=true\nLogging=false\n");
	check(!duplicate.logging, "last exact key wins deterministically");
	const auto diagnostic_duplicate = parse(
		"Diagnostics=true\nDiagnosticsMode=errors\nDiagnostics=false\nDiagnosticsMode=trace\n");
	check(!diagnostic_duplicate.diagnostics
		&& !diagnostic_duplicate.diagnostics_master_enabled
		&& diagnostic_duplicate.diagnostics_mode == renovice::config::DiagnosticsMode::off,
		"last master value deterministically overrides detailed diagnostic keys");

	const auto missing = parse("");
	check(!missing.diagnostics_caster_stats, "caster snapshots default off");
	check(parse("DiagnosticsCasterStats=true\n").diagnostics_caster_stats,
		"exact caster snapshot toggle enables observations");
	check(!parse("DiagnosticsCasterStats=true\nDiagnosticsCasterStats=false\n").diagnostics_caster_stats,
		"caster snapshot last key wins and false disables");
	check(!missing.logging && !missing.verbose && !missing.auto_spawn
		&& !missing.diagnostics,
		"missing file contents default every flag off");

	// Source-log buffering policy (2026-09-29 Mallet lag audit).
	check(source_log_buffer_bytes == 64u * 1024u && source_log_flush_interval_ms == 250,
		"source log buffer is bounded to 64 KiB with a 250 ms flush cadence");
	check(source_log_flush_due(false, 10, 65536, 1000, 1000, 250),
		"operational lines are written through immediately");
	check(!source_log_flush_due(true, 10, 65536, 1100, 1000, 250),
		"diagnostic lines inside the cadence stay buffered");
	check(source_log_flush_due(true, 10, 65536, 1250, 1000, 250),
		"buffered diagnostics flush once the cadence elapses");
	check(source_log_flush_due(true, 65536, 65536, 1001, 1000, 250),
		"a full buffer flushes");
	check(source_log_flush_due(true, 10, 65536, 5, 1000, 250),
		"a tick counter that moves backwards forces a flush");
	check(source_log_line_fits_buffer(0, 65536, 65536)
		&& !source_log_line_fits_buffer(1, 65536, 65536)
		&& !source_log_line_fits_buffer(0, 65537, 65536)
		&& source_log_line_fits_buffer(65000, 536, 65536),
		"line admission never overflows the buffer");
	check(!source_log_rotation_required(100, 10, 10, 1000)
		&& source_log_rotation_required(990, 5, 10, 1000)
		&& source_log_rotation_required(1001, 0, 0, 1000)
		&& !source_log_rotation_required(990, 0, 10, 1000),
		"rotation uses the in-memory size plus buffered and incoming bytes");


	// Population channel (2026-10-30).
	{
		using namespace renovice::population;
		const auto pop_none = parse("");
		check(!pop_none.diagnostics_population && pop_none.diagnostics_population_interval_ms == 5000,
			"population channel defaults off with a 5000 ms interval");
		check(parse("Diagnostics=true\nDiagnosticsPopulation=true\n").diagnostics_population,
			"DiagnosticsPopulation=true with Diagnostics=true enables the channel");
		check(!parse("Diagnostics=false\nDiagnosticsPopulation=true\n").diagnostics_population,
			"Diagnostics=false masks the population channel");
		check(!parse("DiagnosticsMode=trace\nDiagnosticsPopulation=true\n").diagnostics_population,
			"population needs the explicit Diagnostics=true master");
		check(!parse("Diagnostics=true\n").diagnostics_population,
			"Diagnostics=true alone never forces the population channel on");
		check(parse("DiagnosticsPopulationIntervalMs=250\n").diagnostics_population_interval_ms == 1000
			&& parse("DiagnosticsPopulationIntervalMs=999999\n").diagnostics_population_interval_ms == 60000
			&& parse("DiagnosticsPopulationIntervalMs=2500\n").diagnostics_population_interval_ms == 2500
			&& parse("DiagnosticsPopulationIntervalMs=abc\n").diagnostics_population_interval_ms == 5000
			&& parse("DiagnosticsPopulationIntervalMs=-5\n").diagnostics_population_interval_ms == 5000,
			"population interval parses and clamps to 1000..60000 (invalid -> default)");
		check(sample_due(false, 0, 0, 5000) && !sample_due(true, 4999, 0, 5000)
			&& sample_due(true, 5000, 0, 5000) && sample_due(true, 10, 1000, 5000),
			"population cadence: first sample, interval, backwards tick admits");

		Tracker pop_tracker(100);
		const char* pop_a = "alive=10 alive_capped=10 hardcap=40 room=30 budget=200 tier=1 lvl=5-10";
		const char* pop_b = "alive=20 alive_capped=18 hardcap=50 room=30 budget=150 tier=2 lvl=5-10";
		auto pop_lines = pop_tracker.sample("director=nil", 0);
		check(pop_lines.size() == 1 && pop_lines[0] == "RENOVICE POPULATION t=0 director=nil",
			"first probe line is emitted with t relative to the first sample");
		check(pop_tracker.sample("director=nil", 5000).empty(), "an identical probe is collapsed");
		pop_lines = pop_tracker.sample(pop_a, 10000);
		check(pop_lines.size() == 2 && pop_lines[0] == "RENOVICE POPULATION t=10 repeat=1"
			&& pop_lines[1] == std::string("RENOVICE POPULATION t=10 ") + pop_a,
			"a change emits the pending repeat counter, then the new probe");
		check(pop_tracker.mission_active(), "a director starts a mission");
		check(pop_tracker.sample(pop_a, 15000).empty(), "repeat within a mission is collapsed");
		pop_lines = pop_tracker.sample(pop_b, 20000);
		check(pop_lines.size() == 2 && pop_lines[0] == "RENOVICE POPULATION t=20 repeat=1",
			"mission change flushes its repeat counter");
		pop_lines = pop_tracker.sample("director=nil", 30000);
		check(pop_lines.size() == 2 && pop_lines[0] == "RENOVICE POPULATION t=30 director=nil"
			&& pop_lines[1] == "RENOVICE POPULATION SUMMARY samples=3 peak_alive=20 avg_alive=13 peak_hardcap=50 duration_s=10"
			&& !pop_tracker.mission_active(),
			"director non-nil -> nil emits one mission summary");
		pop_lines = pop_tracker.sample("alive=err alive_capped=err hardcap=7 room=1 budget=1 tier=0 lvl=1-1", 40000);
		check(pop_tracker.mission_active() && pop_lines.size() == 1, "a new director resets the mission");
		pop_tracker.sample("alive=err alive_capped=err hardcap=7 room=1 budget=1 tier=0 lvl=1-1", 45000);
		pop_lines = pop_tracker.flush(50000);
		check(pop_lines.size() == 2 && pop_lines[0] == "RENOVICE POPULATION t=50 repeat=1"
			&& pop_lines[1] == "RENOVICE POPULATION SUMMARY samples=2 peak_alive=0 avg_alive=0 peak_hardcap=7 duration_s=5",
			"flush emits the pending repeat and the open mission summary; err fields are skipped");
		check(pop_tracker.flush(60000).empty(), "a second flush has nothing pending");

		Tracker pop_bounded(2);
		std::size_t pop_total = 0;
		for (int i = 0; i != 10; ++i)
			pop_total += pop_bounded.sample("alive=" + std::to_string(i), i * 1000ull).size();
		check(pop_total == 3, "population output is pop_bounded by DiagnosticsMaxEvents plus one limit notice");
		check(Tracker(10).sample(std::string(2000, 'x'), 0)[0].size()
			== std::string("RENOVICE POPULATION t=0 ").size() + maximum_probe_text,
			"an oversized probe string is truncated");
		std::int64_t pop_v = 0;
		check(field_value("alive=5 alive_capped=3", "alive_capped", pop_v) && pop_v == 3
			&& field_value("alive_capped=3 alive=5", "alive", pop_v) && pop_v == 5
			&& !field_value("alive=err", "alive", pop_v),
			"probe field parsing matches whole keys only");
	}


	std::cout << "CONFIG CORE RESULT failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
