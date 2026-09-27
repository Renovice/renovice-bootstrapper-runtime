$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$sourcePath = Join-Path $repo 'renovice\injection.cpp'
$source = [System.IO.File]::ReadAllText($sourcePath)

function Get-Section {
    param(
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End
    )
    $startIndex = $source.IndexOf($Start, [StringComparison]::Ordinal)
    if ($startIndex -lt 0) { throw "STOCK LONGJMP FAIL: missing start marker: $Start" }
    $endIndex = $source.IndexOf($End, $startIndex + $Start.Length, [StringComparison]::Ordinal)
    if ($endIndex -lt 0) { throw "STOCK LONGJMP FAIL: missing end marker after $Start`: $End" }
    return $source.Substring($startIndex, $endIndex - $startIndex)
}

function Require-Contains {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Marker,
        [Parameter(Mandatory)][string]$Description
    )
    if ($Text.IndexOf($Marker, [StringComparison]::Ordinal) -lt 0) {
        throw "STOCK LONGJMP FAIL: $Description"
    }
}

function Require-Single-Stock-Call {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Name
    )
    $calls = [regex]::Matches($Text, '\boriginal\(state\)').Count
    if ($calls -ne 1) {
        throw "STOCK LONGJMP FAIL: $Name must call stock exactly once (found $calls)"
    }
}

$setSource = Get-Section "int set_source_object_adapter(luau_State* state)`n{" "int set_damage_callback_adapter(luau_State* state)`n{"
$setDamage = Get-Section "int set_damage_callback_adapter(luau_State* state)`n{" "bool same_lua_value("
$pushFloat = Get-Section "int push_float_arg_adapter(luau_State* state)`n{" "int run_script_observer_adapter(luau_State* state)`n{"
$runScript = Get-Section "int run_script_observer_adapter(luau_State* state)`n{" "bool ensure_run_script_observer()"
$nativeCall = Get-Section "int native_call_adapter(luau_State* state, std::size_t slot)`n{" "template <std::size_t Slot>"
$nativeProvider = Get-Section "enum class NativeCallPhaseLeafStage" "bool automatic_damage_runtime_method("
$nativeProviderLeaf = Get-Section '// BEGIN NATIVE_CALL_PHASE_PROTECTED_LEAF' '// END NATIVE_CALL_PHASE_PROTECTED_LEAF'
$nativeObserver = Get-Section 'enum class NativeObserverProtectedKind' '// Bounded native getter evidence'
$nativeObserverLeaf = Get-Section '// BEGIN NATIVE_OBSERVER_PROTECTED_LEAF' '// END NATIVE_OBSERVER_PROTECTED_LEAF'

foreach ($entry in @(
    @{ Name = 'set_source_object_adapter'; Text = $setSource },
    @{ Name = 'set_damage_callback_adapter'; Text = $setDamage },
    @{ Name = 'push_float_arg_adapter'; Text = $pushFloat },
    @{ Name = 'run_script_observer_adapter'; Text = $runScript }
)) {
    $entryText = [string]$entry['Text']
    $entryName = [string]$entry['Name']
    Require-Single-Stock-Call -Text $entryText -Name $entryName
    Require-Contains -Text $entryText -Marker 'generation_dispatch_gate.try_dispatch()' -Description "$entryName has no bounded generation phase"
}

Require-Contains $source 'static_assert(std::is_trivially_copyable_v<ActiveRunScriptBoundary>);' 'RunScript boundary is not POD'
Require-Contains $source 'static_assert(std::is_trivially_copyable_v<ActiveStockNativeFinalize>);' 'native finalize boundary is not POD'
Require-Contains $source 'static_assert(std::is_trivially_copyable_v<ActiveNativeCallBoundary>);' 'generic native-call boundary is not POD'
Require-Contains $runScript 'static_assert(std::is_trivially_copyable_v<RunScriptOriginalPlan>);' 'RunScript stock plan is not POD'
Require-Contains $source 'static_assert(std::is_trivially_copyable_v<NativeCallOriginalPlan>);' 'generic native-call stock plan is not POD'
Require-Contains $nativeProvider 'static_assert(std::is_trivially_copyable_v<NativeCallPhaseLeafContext>);' 'nativeCalls provider leaf context is not POD'
Require-Contains $nativeObserver 'static_assert(std::is_trivially_copyable_v<NativeObserverProtectedContext>);' 'native observer leaf context is not POD'

foreach ($marker in @(
    'owner_call_info',
    'owner_function_identity',
    'valid_target_call_stack_bounds(',
    'active_run_script_boundary.owner_call_info == state->ci',
    'active_stock_native_finalize.owner_call_info == state->ci'
)) {
    Require-Contains $source $marker "self-validating CallInfo marker missing: $marker"
}

foreach ($marker in @(
    'argument_base_offset',
    'luau_savestack(state, state->intop)',
    'stock_native_finalize_arguments(plan, state, arguments)',
    'active_generation != plan.generation'
)) {
    Require-Contains $source $marker "native finalize argument/generation marker missing: $marker"
}

Require-Contains $pushFloat 'Intentionally naked: no RENOVICE lease, snapshot, TLS guard, string,' 'PushFloatArg naked-call boundary missing'
Require-Contains $setSource 'Intentionally naked: stock errors propagate with no RENOVICE lease,' 'SetSourceObject naked-call boundary missing'
Require-Contains $setDamage 'leave this callback installed. This call is intentionally naked.' 'SetDamageCallback naked-call boundary missing'
Require-Contains $runScript 'Intentionally naked. Only the trivially-copyable plan and the' 'RunScript naked-call boundary missing'

Require-Single-Stock-Call -Text $nativeCall -Name 'native_call_adapter'
Require-Contains $nativeCall 'Intentionally naked. Every mutex, generation lease, vector, string,' 'generic native-call naked stock boundary missing'
Require-Contains $nativeCall 'engine_damage::publish_source(&native_source)' 'generic native-call source is not explicitly published'
Require-Contains $nativeCall 'engine_damage::clear_source();' 'generic native-call source is not explicitly cleared after stock'
Require-Contains $nativeCall 'const bool result_count_available = result_count >= 0' 'generic native-call stock result count is not bounded'
Require-Contains $nativeCall 'const bool result_window_live = result_count_available' 'generic native-call stock result window is not proven live'
if ($nativeCall.IndexOf('engine_damage::SourceScope', [StringComparison]::Ordinal) -ge 0 -or
    $nativeCall.IndexOf('ScopedNativeCallHook', [StringComparison]::Ordinal) -ge 0 -or
    $nativeCall.IndexOf('std::unique_lock', [StringComparison]::Ordinal) -ge 0) {
    throw 'STOCK LONGJMP FAIL: generic native-call retains destructor ownership across stock'
}
$nativeStock = $nativeCall.IndexOf('const int result_count = original(state);', [StringComparison]::Ordinal)
$nativePreBorrow = $nativeCall.LastIndexOf('generation_dispatch_gate.try_dispatch()', $nativeStock, [StringComparison]::Ordinal)
$nativePostBorrow = $nativeCall.IndexOf('generation_dispatch_gate.try_dispatch()', $nativeStock, [StringComparison]::Ordinal)
$nativeSourcePublish = $nativeCall.LastIndexOf('engine_damage::publish_source(&native_source)', $nativeStock, [StringComparison]::Ordinal)
$nativeSourceClear = $nativeCall.IndexOf('engine_damage::clear_source();', $nativeStock, [StringComparison]::Ordinal)
if ($nativeStock -lt 0 -or $nativePreBorrow -lt 0 -or
    $nativePreBorrow -gt $nativeStock -or $nativePostBorrow -lt $nativeStock -or
    $nativeSourcePublish -lt 0 -or $nativeSourcePublish -gt $nativeStock -or
    $nativeSourceClear -lt $nativeStock) {
    throw 'STOCK LONGJMP FAIL: generic native-call pre/stock/post transaction ordering is not proven'
}

foreach ($marker in @(
    '// BEGIN NATIVE_CALL_PHASE_PROTECTED_LEAF',
    '// END NATIVE_CALL_PHASE_PROTECTED_LEAF',
    'de_vm_authority::run_current_vm_protected(',
    '!protected_result.admitted || !protected_result.restored',
    'protected_result.status != 0 || !context.completed',
    'stock-retained=1'
)) {
    Require-Contains $nativeProvider $marker "nativeCalls provider protected phase marker missing: $marker"
}
if ($nativeProviderLeaf.IndexOf('std::string', [StringComparison]::Ordinal) -ge 0 -or
    $nativeProviderLeaf.IndexOf('std::vector', [StringComparison]::Ordinal) -ge 0 -or
    $nativeProviderLeaf.IndexOf('std::lock_guard', [StringComparison]::Ordinal) -ge 0) {
    throw 'STOCK LONGJMP FAIL: nativeCalls protected leaf still owns provider strings'
}

foreach ($marker in @(
    '// BEGIN NATIVE_OBSERVER_PROTECTED_LEAF',
    '// END NATIVE_OBSERVER_PROTECTED_LEAF',
    'context->runtime_registry_key',
    'context->callback_method',
    '!injected_interrupt_contract_ready',
    'protected_call(',
    'ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);',
    'result.admitted && result.restored && result.status == 0',
    'context.completed && context.passed'
)) {
    Require-Contains $nativeObserver $marker "native observer protected phase marker missing: $marker"
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::deque', 'std::lock_guard',
    'std::shared_ptr', 'std::unique_ptr', 'ScopedVmApiFrame',
    'ScopedExecutionDepth', 'require_stack(', 'prepare_stack_write(',
    'std::ostringstream', 'config::', 'conout', 'catch (', ' new ', ' delete '
)) {
    if ($nativeObserverLeaf.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
        throw "STOCK LONGJMP FAIL: native observer protected leaf owns/calls forbidden construct: $forbidden"
    }
}
if ([regex]::IsMatch($nativeObserverLeaf, '(?m)^\s*throw\b')) {
    throw 'STOCK LONGJMP FAIL: native observer protected leaf throws a C++ exception'
}

if ($source.IndexOf('ScopedRunScriptBoundary', [StringComparison]::Ordinal) -ge 0 -or
    $source.IndexOf('run_script_observer_active', [StringComparison]::Ordinal) -ge 0) {
    throw 'STOCK LONGJMP FAIL: destructor-dependent RunScript ownership remains'
}

foreach ($entry in @(
    @{ Name = 'set_source_object_adapter'; Text = $setSource; Finish = 'finish_stock_native_finalize(' },
    @{ Name = 'set_damage_callback_adapter'; Text = $setDamage; Finish = 'finish_stock_native_finalize(' },
    @{ Name = 'run_script_observer_adapter'; Text = $runScript; Finish = 'finish_run_script_boundary(' }
)) {
    $entryText = [string]$entry['Text']
    $entryName = [string]$entry['Name']
    $finishMarker = [string]$entry['Finish']
    $stock = $entryText.IndexOf('original(state)', [StringComparison]::Ordinal)
    $finish = $entryText.IndexOf($finishMarker, $stock, [StringComparison]::Ordinal)
    $postBorrow = $entryText.IndexOf('generation_dispatch_gate.try_dispatch()', $stock, [StringComparison]::Ordinal)
    if ($stock -lt 0 -or $finish -lt $stock -or $postBorrow -lt $finish) {
        throw "STOCK LONGJMP FAIL: $entryName does not clear POD ownership before post-phase borrowing"
    }
}

$pushStock = $pushFloat.IndexOf('original(state)', [StringComparison]::Ordinal)
$pushLastBorrow = $pushFloat.LastIndexOf('generation_dispatch_gate.try_dispatch()', $pushStock, [StringComparison]::Ordinal)
$pushNaked = $pushFloat.IndexOf('Intentionally naked:', [StringComparison]::Ordinal)
if ($pushLastBorrow -lt 0 -or $pushNaked -lt $pushLastBorrow -or $pushStock -lt $pushNaked) {
    throw 'STOCK LONGJMP FAIL: PushFloatArg ownership is not closed before stock'
}

$idleGate = Get-Section 'const bool exact_idle_return = state != nullptr' 'if (target_addon_refresh_pending.load('
Require-Contains $idleGate 'if (!exact_idle_return) return;' 'exact-idle rejection gate missing'
Require-Contains $idleGate 'clear_run_script_boundary_at_exact_idle(state);' 'RunScript exact-idle recovery missing'
Require-Contains $idleGate 'clear_stock_native_finalize_at_exact_idle(state);' 'native finalize exact-idle recovery missing'
Require-Contains $idleGate 'clear_native_call_boundary_at_exact_idle(state);' 'generic native-call exact-idle recovery missing'

Write-Host 'STOCK LONGJMP BOUNDARIES PASS adapters=5 stock_calls=5 pod_boundaries=5 protected_native_provider=1 protected_native_observer=1 exact_idle_recovery=3'
