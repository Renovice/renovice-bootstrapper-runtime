$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$sourcePath = Join-Path $repoRoot 'renovice\injection.cpp'
$headerPath = Join-Path $repoRoot 'renovice\generation_ownership.hpp'
$source = Get-Content -LiteralPath $sourcePath -Raw
$header = Get-Content -LiteralPath $headerPath -Raw

function Require-Match {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Pattern,
        [Parameter(Mandatory)][string]$Description
    )
    if ($Text -notmatch $Pattern) {
        throw "GENERATION OWNERSHIP FAIL: $Description"
    }
}

Require-Match $header 'class\s+GenerationDispatchGate' 'dispatch gate is missing'
Require-Match $header 'accepting_\.store\(false' 'mutation does not close callback admission'
Require-Match $header 'in_flight_\.load[^\r\n]+==\s*0' 'mutation does not wait for old callbacks'
Require-Match $header 'dispatch_depth_\s*!=\s*0\)\s*return\s+Mutation\(this,\s*false\)' 'callback thread can mutate its borrowed generation'
Require-Match $header 'current_thread_dispatching' 'target activation cannot distinguish its owned generation borrow'

Require-Match $source 'std::atomic<std::shared_ptr<const TargetExecutionSnapshot>>\s*published_target_execution_snapshot' 'published handler snapshot is not lifetime managed'
Require-Match $source 'result\.dispatch\s*=\s*generation_dispatch_gate\.try_dispatch\(\)' 'snapshot reads do not borrow a generation'
Require-Match $source 'auto\s+generation_mutation\s*=\s*generation_dispatch_gate\.begin_mutation' 'reload does not close and drain handler admission'

$fullEntryPoints = @(
    'target_hook_registry_dispatcher',
    'ability_card_wrapper',
    'addon_damage_callback_wrapper',
    'set_source_object_adapter',
    'set_damage_callback_adapter',
    'native_call_adapter',
    'push_float_arg_adapter',
    'run_script_observer_adapter'
)
foreach ($name in $fullEntryPoints) {
    $pattern = '(?s)(?:int|bool|void)\s+' + [regex]::Escape($name) + '\s*\([^)]*\)\s*\{.{0,1800}?generation_dispatch_gate\.try_dispatch\(\)'
    Require-Match $source $pattern "$name does not retain one generation for its complete handler call"
}
Require-Match $source '(?s)void\s+vm_execute_detour\s*\([^)]*\)\s*\{.{0,1200}?generation_dispatch_gate\.try_dispatch\(\)' 'VM before/after handler phases do not share one generation'
Require-Match $source 'generation_dispatch\s*=\s*\{\};\s*\r?\n\s*if\s*\(target_addon_refresh_pending' 'deferred target binding does not wait for the VM generation borrow to end'
Require-Match $source 'target_addon_action_requires_exclusive_mutation' 'target binding does not classify root-preserving versus destructive generation changes'
Require-Match $source 'reason=destructive-generation-replacement' 'destructive target replacement is not deferred until callback release'
Require-Match $source 'reason=destructive-generation-removal' 'destructive target removal is not deferred until callback release'
Require-Match $source 'RENOVICE TARGET ADDON DEFER key=' 'borrowed rebind has no explicit deferred evidence'

Require-Match $source 'native_hook_contract_covered' 'native detours are not checked as a process-owned superset'
Require-Match $source 'merge_native_hook_methods' 'new generations cannot extend the process-owned detour set monotonically'
$disableCalls = [regex]::Matches($source, 'disable_native_hook_adapters\s*\(').Count
if ($disableCalls -ne 2) {
    throw "GENERATION OWNERSHIP FAIL: native adapter teardown has live call sites (expected declaration plus definition only, got $disableCalls matches)"
}

Require-Match $source 'RemoveVectoredExceptionHandler' 'diagnostics-off cannot remove the process fault observer'
Require-Match $source 'process_fault_diagnostics_in_flight' 'fault observer resources can be closed while a callback is still running'
Require-Match $source 'clear_automatic_damage_runtime' 'diagnostics-off cannot release the embedded Lua observer root'
Require-Match $source 'clear_diagnostic_module_roots_for_vm' 'diagnostics-off cannot release diagnostic prototype registry roots'
Require-Match $source 'diagnostics_claims_native_method' 'installed diagnostic detours cannot pass directly to stock while disabled'

Write-Host ('GENERATION OWNERSHIP PASS entrypoints={0} snapshot=leased native_hooks=process-owned diagnostics_off=unregistered' -f ($fullEntryPoints.Count + 1))
