$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$source = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$authority = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority.cpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $startIndex = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($startIndex -lt 0) {
        throw "ADDON LIFECYCLE RAW PROTECTION FAIL: missing $Description start"
    }
    $endIndex = $Text.IndexOf(
        $End, $startIndex + $Start.Length, [StringComparison]::Ordinal)
    if ($endIndex -le $startIndex) {
        throw "ADDON LIFECYCLE RAW PROTECTION FAIL: missing $Description end"
    }
    $Text.Substring($startIndex, $endIndex - $startIndex)
}

function Require-Contains {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Marker,
        [Parameter(Mandatory)][string]$Description
    )
    if ($Text.IndexOf($Marker, [StringComparison]::Ordinal) -lt 0) {
        throw "ADDON LIFECYCLE RAW PROTECTION FAIL: $Description"
    }
}

foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<RunResult>);',
    'static_assert(std::is_trivially_copyable_v<GuardedRunLeafContext>);',
    'static_assert(std::is_trivially_copyable_v<GuardRegistryRecoveryContext>);',
    'static_assert(std::is_trivially_copyable_v<LifecycleLeafContext>);'
)) {
    Require-Contains $source $marker "POD constraint missing: $marker"
}

$runLeaf = Get-Region $source `
    '// BEGIN GUARDED_RUN_PROTECTED_LEAF' `
    '// END GUARDED_RUN_PROTECTED_LEAF' `
    'guarded module-load leaf'
foreach ($marker in @(
    'void run_guarded_protected_leaf(luau_State* state, void* raw_context) noexcept',
    'check_stack(state, 8)',
    'capture_guard_outer_error_jump(state)',
    'restore_guard_outer_error_jump_after_fault()',
    'ProtectedStockLoaderContext loader_context{};',
    'protected_stock_loader_leaf(state, &loader_context);',
    'loader_context.returned && loader_context.value',
    'protected_call(state, 1, 1, 0)',
    'protected_call(state, 0, 0, 0)',
    'context->returned = true;'
)) {
    Require-Contains $runLeaf $marker "module-load leaf marker missing: $marker"
}
if ($runLeaf.IndexOf('invoke_stock_loader_protected(', [StringComparison]::Ordinal) -ge 0) {
    throw 'ADDON LIFECYCLE RAW PROTECTION FAIL: module-load leaf nests a second raw VM boundary'
}

$lifecycleLeaf = Get-Region $source `
    '// BEGIN LIFECYCLE_OPERATION_PROTECTED_LEAF' `
    '// END LIFECYCLE_OPERATION_PROTECTED_LEAF' `
    'lifecycle leaf'
foreach ($marker in @(
    'void lifecycle_operation_protected_leaf(',
    'check_stack(state, 4)',
    'capture_guard_outer_error_jump(state)',
    'restore_guard_outer_error_jump_after_fault()',
    'set_registry_nil(state, guard_base(), context->registry_key)',
    'getfield(state, -10000, context->registry_key)',
    'protected_call(state, 0, 0, 0)',
    'context->success = true;',
    'context->returned = true;'
)) {
    Require-Contains $lifecycleLeaf $marker "lifecycle leaf marker missing: $marker"
}

foreach ($leaf in @(
    @{ Name = 'module-load'; Text = $runLeaf },
    @{ Name = 'lifecycle'; Text = $lifecycleLeaf }
)) {
    foreach ($forbidden in @(
        'std::string', 'std::vector', 'std::deque', 'std::lock_guard',
        'std::shared_ptr', 'std::unique_ptr', 'ScopedVmApiFrame',
        'ScopedExecutionDepth', 'require_stack(', 'prepare_stack_write(',
        'std::ostringstream', 'config::', 'conout', 'catch (',
        ' new ', ' delete '
    )) {
        if ([string]$leaf.Text -like "*$forbidden*") {
            throw "ADDON LIFECYCLE RAW PROTECTION FAIL: $($leaf.Name) leaf owns/calls forbidden construct: $forbidden"
        }
    }
    if ([regex]::IsMatch([string]$leaf.Text, '(?m)^\s*throw\b')) {
        throw "ADDON LIFECYCLE RAW PROTECTION FAIL: $($leaf.Name) leaf throws a C++ exception"
    }
}

$recoveryLeaf = Get-Region $source `
    '// BEGIN GUARDED_RUN_RECOVERY_LEAF' `
    '// END GUARDED_RUN_RECOVERY_LEAF' `
    'guarded registry recovery leaf'
foreach ($marker in @(
    'check_stack(state, 2)',
    '*base = guard.borrowed_original;',
    'guard.setfield(state, -10000, guard.key);',
    '"RENOVICE.guarded-module-original"',
    'guard.setfield(state, -10000, context->lifecycle_key);',
    'context->lifecycle_root_cleared = true;',
    'context->completed = context->target_restored'
)) {
    Require-Contains $recoveryLeaf $marker "registry recovery marker missing: $marker"
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::lock_guard', 'Scoped',
    'require_stack(', 'prepare_stack_write(', 'config::', 'conout',
    'catch (', ' new ', ' delete '
)) {
    if ($recoveryLeaf.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
        throw "ADDON LIFECYCLE RAW PROTECTION FAIL: recovery leaf owns/calls forbidden construct: $forbidden"
    }
}
if ([regex]::IsMatch($recoveryLeaf, '(?m)^\s*throw\b')) {
    throw 'ADDON LIFECYCLE RAW PROTECTION FAIL: recovery leaf throws a C++ exception'
}

$runOuter = Get-Region $source `
    'RunResult run_guarded(' `
    'enum class LifecycleLeafFailure' `
    'guarded module-load orchestrator'
foreach ($marker in @(
    'de_vm_authority::run_current_vm_protected(',
    'state, &run_guarded_protected_leaf, &context)',
    'settle_guard_after_protected_exit(',
    '|| !context.result.completed));',
    '!protected_result.restored || protected_result.status != 0',
    'result.registry_restored = registry_safe;'
)) {
    Require-Contains $runOuter $marker "module-load orchestrator marker missing: $marker"
}

$lifecycleOuter = Get-Region $source `
    'bool lifecycle_operation(luau_State* state, const AddonRecord& addon, const char* field)' `
    'bool read_loader_name_handle(' `
    'lifecycle orchestrator'
foreach ($marker in @(
    'std::lock_guard execution_lock(lua_execution_mutex);',
    'ScopedExecutionDepth execution_depth;',
    'de_vm_authority::run_current_vm_protected(',
    'state, &lifecycle_operation_protected_leaf, &context)',
    'abandon_guard_without_vm_access();',
    '!protected_result.restored',
    'protected_result.status != 0 || !context.returned'
)) {
    Require-Contains $lifecycleOuter $marker "lifecycle orchestrator marker missing: $marker"
}
foreach ($forbidden in @(
    'getfield(', 'setfield(', 'protected_call(', 'check_stack(',
    'require_stack(', 'prepare_stack_write('
)) {
    if ($lifecycleOuter.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
        throw "ADDON LIFECYCLE RAW PROTECTION FAIL: lifecycle outer performs a DE mutation: $forbidden"
    }
}

$runMatches = [regex]::Matches($source, '(?m)^bool run_chunk\(')
if ($runMatches.Count -lt 2) {
    throw 'ADDON LIFECYCLE RAW PROTECTION FAIL: run_chunk definition not found'
}
$runStart = $runMatches[$runMatches.Count - 1].Index
$runEnd = $source.IndexOf(
    'bool activate_target_addons_locked(', $runStart, [StringComparison]::Ordinal)
if ($runEnd -le $runStart) {
    throw 'ADDON LIFECYCLE RAW PROTECTION FAIL: run_chunk definition end not found'
}
$runChunk = $source.Substring($runStart, $runEnd - $runStart)
foreach ($marker in @(
    'std::lock_guard execution_lock(lua_execution_mutex);',
    'ScopedExecutionDepth execution_depth;',
    'const auto result = run_guarded(',
    'result.completed && result.registry_restored'
)) {
    Require-Contains $runChunk $marker "run_chunk preservation marker missing: $marker"
}
foreach ($forbidden in @(
    'getfield(', 'setfield(', 'protected_call(', 'check_stack(',
    'require_stack(', 'prepare_stack_write('
)) {
    if ($runChunk.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
        throw "ADDON LIFECYCLE RAW PROTECTION FAIL: run_chunk owns a direct DE mutation: $forbidden"
    }
}

foreach ($marker in @(
    'RawVmFrameSnapshot frame_snapshot{};',
    'capture_raw_vm_frame(state, frame_snapshot)',
    'raw_protected_run(state, body, context)',
    'result.restored = restore_raw_vm_frame(state, frame_snapshot);'
)) {
    Require-Contains $authority $marker "authority exact-frame marker missing: $marker"
}

Write-Host 'ADDON LIFECYCLE RAW PROTECTION PASS module-load=POD-raw lifecycle=POD-raw registry-recovery=protected run-chunk=outer-owned exact-frame=restored'
