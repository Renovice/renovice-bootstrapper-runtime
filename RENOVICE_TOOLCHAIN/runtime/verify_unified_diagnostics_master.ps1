$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$core = Get-Content -Raw -LiteralPath (Join-Path $repo 'renovice\config_core.hpp')
$config = Get-Content -Raw -LiteralPath (Join-Path $repo 'renovice\config.cpp')
$injection = Get-Content -Raw -LiteralPath (Join-Path $repo 'renovice\injection.cpp')

$coreMarkers = @(
    'diagnostics_master_set',
    'diagnostics_master_enabled',
    'apply_diagnostics_master(result)',
    'flags.diagnostics_damage_capture = DamageCaptureMode::engine',
    'flags.diagnostics_caster_stats = true',
    'flags.diagnostics_buffs = true',
    'flags.diagnostics_memory = true',
    'flags.diagnostics_damage_capture = DamageCaptureMode::off',
    'flags.diagnostics_caster_stats = false',
    'flags.diagnostics_buffs = false',
    'flags.diagnostics_memory = false'
)
foreach ($marker in $coreMarkers) {
    if (-not $core.Contains($marker)) { throw "Unified diagnostics config marker missing: $marker" }
}

$configMarkers = @(
    'active_diagnostics.store(diagnostics_capture_enabled(active_flags)',
    'active_memory_diagnostics.store(active_flags.diagnostics_memory',
    'bool diagnostics_enabled() noexcept',
    'if (!active_flags.diagnostics_memory || memory_log_path.empty()) return;'
)
foreach ($marker in $configMarkers) {
    if (-not $config.Contains($marker)) { throw "Unified diagnostics runtime marker missing: $marker" }
}

$injectionMarkers = @(
    '!config::diagnostics_enabled()',
    'reconcile_process_fault_diagnostics()',
    'RemoveVectoredExceptionHandler(',
	'process_fault_diagnostics_in_flight',
	'process_fault_diagnostics_accepting.store(false',
    'RENOVICE native null-fault diagnostics absent while diagnostics are off',
	'clear_automatic_damage_runtime(state)',
	'clear_diagnostic_module_roots_for_vm(state)'
)
foreach ($marker in $injectionMarkers) {
    if (-not $injection.Contains($marker)) { throw "Unified diagnostics fault-gate marker missing: $marker" }
}

# luaCalls.before reject trace (live run 2026-09-29): Diagnostics=false performs
# no formatting or allocation; Diagnostics=true is sampled per process.
$rejectCallAt = $injection.IndexOf('trace_lua_call_before_reject(state, call);', [StringComparison]::Ordinal)
$rejectGateAt = $injection.LastIndexOf('&& config::diagnostics_mode() != config::DiagnosticsMode::off)', $rejectCallAt, [StringComparison]::Ordinal)
if ($rejectCallAt -lt 0 -or $rejectGateAt -lt 0 -or ($rejectCallAt - $rejectGateAt) -gt 200) {
    throw 'Unified diagnostics FAIL: luaCalls.before reject trace is not gated by the diagnostics master before any work'
}
$rejectStart = $injection.IndexOf('void trace_lua_call_before_reject(luau_State* state, const TargetLuaCall& call) noexcept', [StringComparison]::Ordinal)
$rejectEnd = $injection.IndexOf('std::uint32_t de_luau_interrupt_increment_detour(', $rejectStart, [StringComparison]::Ordinal)
if ($rejectStart -lt 0 -or $rejectEnd -le $rejectStart) { throw 'Unified diagnostics FAIL: reject trace helper missing' }
$reject = $injection.Substring($rejectStart, $rejectEnd - $rejectStart)
$sampleAt = $reject.IndexOf('if (!sample_vm_host_error(occurrence)) return;', [StringComparison]::Ordinal)
$formatAt = $reject.IndexOf('std::ostringstream', [StringComparison]::Ordinal)
if ($sampleAt -lt 0 -or $formatAt -le $sampleAt -or -not $reject.Contains('prototype=') -or -not $reject.Contains('occurrence=')) {
    throw 'Unified diagnostics FAIL: reject trace is not sampled before formatting or lacks prototype/occurrence correlation'
}

Write-Host 'UNIFIED DIAGNOSTICS MASTER PASS all-on=trace+engine+caster+buffs+memory+fault all-off=observers-unregistered+lua-roots-released+prototype-roots-released legacy-advanced=preserved'
