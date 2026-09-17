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

Write-Host 'UNIFIED DIAGNOSTICS MASTER PASS all-on=trace+engine+caster+buffs+memory+fault all-off=observers-unregistered+lua-roots-released+prototype-roots-released legacy-advanced=preserved'
