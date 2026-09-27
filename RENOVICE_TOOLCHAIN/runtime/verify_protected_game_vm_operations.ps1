$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$bridge = [IO.File]::ReadAllText((Join-Path $repo 'owf_scripting.cpp'))
$header = [IO.File]::ReadAllText((Join-Path $repo 'owf_scripting.hpp'))
$main = [IO.File]::ReadAllText((Join-Path $repo 'main.cpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $startIndex = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($startIndex -lt 0) { throw "PROTECTED GAME VM OPERATIONS FAIL: missing $Description start" }
    $endIndex = $Text.IndexOf($End, $startIndex + $Start.Length, [StringComparison]::Ordinal)
    if ($endIndex -le $startIndex) { throw "PROTECTED GAME VM OPERATIONS FAIL: missing $Description end" }
    $Text.Substring($startIndex, $endIndex - $startIndex)
}

foreach ($marker in @(
    'enum class ProtectedGameVmOperationKind',
    'thread_local ProtectedGameVmOperation* active_protected_game_vm_operation',
    'bool run_protected_game_vm_operation(',
    'renovice::de_vm_authority::push_host_closure(state)',
    'renovice::de_vm_authority::protected_call(',
    'active_protected_game_vm_operation = &operation;',
    'active_protected_game_vm_operation = nullptr;',
    'copy_protected_game_vm_error(',
    'dispatch_openwf_protected_game_vm_operation('
)) {
    if (-not $bridge.Contains($marker)) {
        throw "PROTECTED GAME VM OPERATIONS FAIL: bridge marker missing: $marker"
    }
}
if (-not $header.Contains('dispatch_openwf_protected_game_vm_operation(')) {
    throw 'PROTECTED GAME VM OPERATIONS FAIL: dispatcher is not declared in owf_scripting.hpp'
}

$dispatcher = Get-Region $bridge `
    'int dispatch_openwf_protected_game_vm_operation(' `
    'std::size_t drain_deferred_game_registry_releases(' `
    'C-only local dispatcher'
foreach ($marker in @(
    'ProtectedGameVmOperationKind::append_value',
    'ProtectedGameVmOperationKind::push_pseudo_index',
    'ProtectedGameVmOperationKind::push_string',
    'ProtectedGameVmOperationKind::push_pointer',
    'ProtectedGameVmOperationKind::push_object',
    'ProtectedGameVmOperationKind::push_closure',
    'ProtectedGameVmOperationKind::push_callback',
    'ProtectedGameVmOperationKind::next',
    'ProtectedGameVmOperationKind::gettable',
    'ProtectedGameVmOperationKind::newtable',
    'ProtectedGameVmOperationKind::settable',
    'ProtectedGameVmOperationKind::chat_redux',
    'ProtectedGameVmOperationKind::release_registry'
)) {
    if (-not $dispatcher.Contains($marker)) {
        throw "PROTECTED GAME VM OPERATIONS FAIL: dispatcher operation missing: $marker"
    }
}
foreach ($forbidden in @('std::lock_guard', 'std::string', 'std::vector',
    'std::deque', 'ObfusString')) {
    if ($dispatcher.Contains($forbidden)) {
        throw "PROTECTED GAME VM OPERATIONS FAIL: longjmp-exposed dispatcher owns C++ state: $forbidden"
    }
}

# Throwing DE APIs may occur only in the tiny dispatcher, where the immediately
# surrounding DE protected call catches their longjmp before control returns to
# any Pluto/C++ bridge frame.
$outsideDispatcher = $bridge.Remove(
    $bridge.IndexOf('int dispatch_openwf_protected_game_vm_operation(', [StringComparison]::Ordinal),
    $dispatcher.Length)
foreach ($call in @(
    'renovice::injection::reserve_game_vm_stack\s*\(',
    'renovice::injection::append_game_vm_stack_value\s*\(',
    'renovice::injection::push_game_vm_stack_index\s*\(',
    '\bluau_pushstring\s*\(',
    '\bluau_pushpointer\s*\(',
    '\bluau_pushobject\s*\(',
    '\bluau_pushcclosurek\s*\(',
    '\bluau_next\s*\(',
    '\bluau_gettable\s*\(',
    '\bluau_createtable\s*\(',
    '\bluau_settable\s*\('
)) {
    if ([regex]::IsMatch($outsideDispatcher, $call)) {
        throw "PROTECTED GAME VM OPERATIONS FAIL: throwing DE call remains outside dispatcher: $call"
    }
}
if ($bridge.Contains('catch (const int&)') -or $bridge.Contains('catch (const int&)')) {
    throw 'PROTECTED GAME VM OPERATIONS FAIL: C++ catch is still used as a DE longjmp boundary'
}
foreach ($unsafeFormat in @(
    'luaL_error\(L,\s*[A-Za-z_][A-Za-z0-9_]*\.c_str\(\)\s*\)',
    'luaL_error\(L,\s*[A-Za-z_][A-Za-z0-9_]*\.what\(\)\s*\)'
)) {
    if ([regex]::IsMatch($bridge, $unsafeFormat)) {
        throw "PROTECTED GAME VM OPERATIONS FAIL: dynamic luaL_error format remains: $unsafeFormat"
    }
}

foreach ($marker in @(
    'operation.kind = ProtectedGameVmOperationKind::push_string;',
    'operation.kind = ProtectedGameVmOperationKind::push_pointer;',
    'operation.kind = ProtectedGameVmOperationKind::push_object;',
    'operation.kind = ProtectedGameVmOperationKind::push_callback;',
    'operation.kind = ProtectedGameVmOperationKind::next;',
    'operation.kind = ProtectedGameVmOperationKind::push_closure;',
    'operation.kind = ProtectedGameVmOperationKind::gettable;',
    'operation.kind = ProtectedGameVmOperationKind::newtable;',
    'operation.kind = ProtectedGameVmOperationKind::settable;',
    'operation.kind = ProtectedGameVmOperationKind::chat_redux;',
    'operation.kind = ProtectedGameVmOperationKind::release_registry;'
)) {
    if (-not $bridge.Contains($marker)) {
        throw "PROTECTED GAME VM OPERATIONS FAIL: protected callsite missing: $marker"
    }
}

$declaration = $main.IndexOf('static int tick_openwf_scripts_at_native_frame', [StringComparison]::Ordinal)
$definition = $main.IndexOf('static int tick_openwf_scripts_at_native_frame',
    $declaration + 1, [StringComparison]::Ordinal)
$tickEnd = $main.IndexOf('struct OpenWfFrameTransaction', $definition, [StringComparison]::Ordinal)
if ($definition -lt 0 -or $tickEnd -le $definition) {
    throw 'PROTECTED GAME VM OPERATIONS FAIL: protected host callback is missing'
}
$tick = $main.Substring($definition, $tickEnd - $definition)
$dispatchAt = $tick.IndexOf('dispatch_openwf_protected_game_vm_operation(L);', [StringComparison]::Ordinal)
$profileAt = $tick.IndexOf('#if PROFILE_SCRIPT_TICKING', [StringComparison]::Ordinal)
$restoreAt = $tick.IndexOf('struct VmContextRestore', [StringComparison]::Ordinal)
$drainAt = $tick.IndexOf('drain_deferred_game_registry_releases(L);', [StringComparison]::Ordinal)
$lockAt = $tick.IndexOf('std::lock_guard mtx(running_scripts_mtx);', [StringComparison]::Ordinal)
if ($dispatchAt -lt 0 -or $profileAt -lt 0 -or $restoreAt -lt 0 -or
    $drainAt -lt 0 -or $lockAt -lt 0 -or $dispatchAt -gt $profileAt -or
    $dispatchAt -gt $restoreAt -or $drainAt -gt $lockAt) {
    throw 'PROTECTED GAME VM OPERATIONS FAIL: host-dispatch/drain lifetime ordering changed'
}
if (-not $tick.Contains('if (protected_operation_results >= 0) return protected_operation_results;')) {
    throw 'PROTECTED GAME VM OPERATIONS FAIL: local operation can fall through into the Pluto scheduler'
}

Write-Host 'PROTECTED GAME VM OPERATIONS PASS dispatcher=C-only local-pcall=yes direct-throwing-bridge-calls=0 dynamic-error-format=literal drain=owner-transaction'
