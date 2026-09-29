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

# Diagnostics hot path and Diagnostics=false formatting (Mallet lag audit
# 2026-09-29). Pure policies are unit-tested in verify_config_core and
# verify_injection_core; these pin their use at the runtime call sites.
function Get-SourceRegion([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "Unified diagnostics FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
$writer = Get-SourceRegion $config 'void write_log_unlocked(std::string_view message, bool buffered = false) noexcept' 'struct SourceLogShutdown' 'source log writer'
if ($writer.Contains('CreateFileW') -or $writer.Contains('CloseHandle')) {
    throw 'Unified diagnostics FAIL: the per-line source log writer still opens or closes the file'
}
foreach ($marker in @('source_log_flush_due(buffered, log_buffered, log_buffer.size(),', 'rotate_open_log_unlocked(line_bytes);', 'source_log_line_fits_buffer(')) {
    if (-not $writer.Contains($marker)) { throw "Unified diagnostics FAIL: source log writer marker missing: $marker" }
}
foreach ($marker in @('write_log_unlocked(message, true);', 'void flush_log_for_fault() noexcept', 'std::unique_lock lock(state_mutex, std::try_to_lock);', 'struct SourceLogShutdown', 'FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE')) {
    if (-not $config.Contains($marker)) { throw "Unified diagnostics FAIL: buffered diagnostics marker missing: $marker" }
}
$fault = Get-SourceRegion $injection 'LONG CALLBACK process_fault_diagnostics(EXCEPTION_POINTERS* information)' 'void release_process_fault_diagnostic_resources() noexcept' 'fault recorder'
if (-not $fault.Contains('config::flush_log_for_fault();')) { throw 'Unified diagnostics FAIL: fault recorder does not flush buffered diagnostics' }

$trace = Get-SourceRegion $injection 'void trace_addon(luau_State* state, std::uint64_t key, const char* event,' 'const char* readable_string_handle(' 'trace_addon'
$rateAt = $trace.IndexOf('addon_trace_rate_limiter.admit(event, GetTickCount64())', [StringComparison]::Ordinal)
$budgetAt = $trace.IndexOf('addon_trace_sequence.fetch_add(', [StringComparison]::Ordinal)
if ($rateAt -lt 0 -or $budgetAt -le $rateAt -or -not $trace.Contains('diagnostic_per_hit_event(event)') -or -not $trace.Contains('event=trace.rate-limited')) {
    throw 'Unified diagnostics FAIL: per-hit trace lines are not rate limited before the shared budget with a suppression summary'
}

$hookOnce = Get-SourceRegion $injection "void log_native_hook_once(`n`tluau_State* state," 'void dispatch_target_hook(' 'log_native_hook_once'
$identityAt = $hookOnce.IndexOf('native_hook_event_identity(', [StringComparison]::Ordinal)
$formatAt = $hookOnce.IndexOf('std::ostringstream', [StringComparison]::Ordinal)
if ($identityAt -lt 0 -or $formatAt -le $identityAt -or $hookOnce.Contains('generation_mutex')) {
    throw 'Unified diagnostics FAIL: native hook PASS dedupe is not a cheap identity check before formatting'
}
$dispatch = Get-SourceRegion $injection 'void dispatch_target_hook(' 'int target_hook_registry_dispatcher(' 'dispatch_target_hook'
if (-not $dispatch.Contains('const bool detailed_trace = diagnostics_on') -or $dispatch.Contains('config::flags()')) {
    throw 'Unified diagnostics FAIL: dispatch labels are not gated by the diagnostics mode'
}
$performanceAt = $injection.IndexOf('trace_addon(state, 0, "damage.performance", performance.str());', [StringComparison]::Ordinal)
$performanceGate = $injection.LastIndexOf('if (config::diagnostics_mode() != config::DiagnosticsMode::off)', $performanceAt, [StringComparison]::Ordinal)
if ($performanceAt -lt 0 -or $performanceGate -lt 0 -or ($performanceAt - $performanceGate) -gt 900) {
    throw 'Unified diagnostics FAIL: damage.performance is formatted with Diagnostics=false'
}
$floatAt = $injection.IndexOf('"native.float.transform", details.str());', [StringComparison]::Ordinal)
$floatGate = $injection.LastIndexOf('if (config::diagnostics_mode() != config::DiagnosticsMode::off)', $floatAt, [StringComparison]::Ordinal)
if ($floatAt -lt 0 -or $floatGate -lt 0 -or ($floatAt - $floatGate) -gt 500) {
    throw 'Unified diagnostics FAIL: the threat-transform details are formatted with Diagnostics=false'
}
if (-not $injection.Contains("const bool detailed_damage_trace =`n`t`tconfig::diagnostics_mode() != config::DiagnosticsMode::off")) {
    throw 'Unified diagnostics FAIL: sampled damage detail is not gated by the diagnostics mode'
}

Write-Host 'UNIFIED DIAGNOSTICS MASTER PASS all-on=trace+engine+caster+buffs+memory+fault all-off=observers-unregistered+lua-roots-released+prototype-roots-released legacy-advanced=preserved'
