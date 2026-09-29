#include <iostream>
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

	std::cout << "CONFIG CORE RESULT failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
