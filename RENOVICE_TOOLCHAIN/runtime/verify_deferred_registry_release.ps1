$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$runtimePath = Join-Path $repo 'OpenWF\runtime.pluto'
$bridgePath = Join-Path $repo 'owf_scripting.cpp'
$mainPath = Join-Path $repo 'main.cpp'

$runtime = [System.IO.File]::ReadAllText($runtimePath)
$bridge = [System.IO.File]::ReadAllText($bridgePath)
$main = [System.IO.File]::ReadAllText($mainPath)

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $startIndex = $Text.IndexOf($Start, [System.StringComparison]::Ordinal)
    if ($startIndex -lt 0) { throw "DEFERRED REGISTRY RELEASE FAIL: missing $Description start" }
    $endIndex = $Text.IndexOf($End, $startIndex + $Start.Length, [System.StringComparison]::Ordinal)
    if ($endIndex -le $startIndex) { throw "DEFERRED REGISTRY RELEASE FAIL: missing $Description end" }
    return $Text.Substring($startIndex, $endIndex - $startIndex)
}

$gc = Get-Region $runtime 'function __gc()' 'function pushToIvkr()' 'owfUserdata finalizer'
if (-not $gc.Contains('ivkr_defer_registry_release(tostring(self), self.__ivkr_registry_owner)')) {
    throw 'DEFERRED REGISTRY RELEASE FAIL: finalizer does not queue its exact construction owner'
}
foreach ($forbidden in @('ivkr_push_string(', 'ivkr_push_nil(', 'ivkr_settable(', 'ivkr_gettable(')) {
    if ($gc.Contains($forbidden)) {
        throw "DEFERRED REGISTRY RELEASE FAIL: finalizer still mutates the cached DE VM through $forbidden"
    }
}

$registryWrites = [regex]::Matches($runtime, 'ivkr_settable\(-10002\)').Count
$ownerCaptures = [regex]::Matches($runtime, 'self\.__ivkr_registry_owner\s*=\s*ivkr_registry_owner\(\)').Count
if ($registryWrites -ne 3 -or $ownerCaptures -ne $registryWrites) {
    throw "DEFERRED REGISTRY RELEASE FAIL: every registry-root creator must capture an owner (writes=$registryWrites owners=$ownerCaptures)"
}

$queue = Get-Region $bridge 'bool queue_deferred_game_registry_release(' 'int dispatch_openwf_protected_game_vm_operation(' 'deferred queue'
foreach ($forbidden in @('luau_pushstring', 'luau_settable', 'reserve_game_vm_stack', 'luau_L->outtop')) {
    if ($queue.Contains($forbidden)) {
        throw "DEFERRED REGISTRY RELEASE FAIL: queue path touches the DE VM through $forbidden"
    }
}
foreach ($required in @(
    'maximum_deferred_registry_release_count',
    'key_size > maximum_deferred_registry_key_bytes',
    'global_state == nullptr',
    'std::lock_guard lock(deferred_game_registry_releases_mutex)'
)) {
    if (-not $queue.Contains($required)) {
        throw "DEFERRED REGISTRY RELEASE FAIL: bounded queue invariant missing: $required"
    }
}

$drain = Get-Region $bridge 'std::size_t drain_deferred_game_registry_releases(' 'static uint32_t wf_fnv_1' 'owned drain'
foreach ($required in @(
    'iterator->global_state == state->global_state',
    'maximum_registry_releases_per_drain',
    'operation.kind = ProtectedGameVmOperationKind::release_registry',
    'operation.text = pending.key.c_str()',
    'run_protected_game_vm_operation(',
    'state, operation, 0, nullptr, 2)',
    'deferred_game_registry_releases.push_front(std::move(pending))'
)) {
    if (-not $drain.Contains($required)) {
        throw "DEFERRED REGISTRY RELEASE FAIL: owned drain invariant missing: $required"
    }
}

$deferBinding = Get-Region $bridge 'OWF_SET_GLOBAL(L, "ivkr_registry_owner");' 'OWF_SET_GLOBAL(L, "ivkr_push_pointer");' 'Pluto ownership bindings'
foreach ($required in @(
    'lua_touserdata(L, 2)',
    'queue_deferred_game_registry_release(',
    'owner, key, key_size'
)) {
    if (-not $deferBinding.Contains($required)) {
        throw "DEFERRED REGISTRY RELEASE FAIL: owner-token binding missing: $required"
    }
}
if ($deferBinding -match '(?s)ivkr_defer_registry_release.*?luau_L->global_state') {
    throw 'DEFERRED REGISTRY RELEASE FAIL: finalization uses the later current VM instead of the construction owner'
}

$nativeFrameDeclaration = $main.IndexOf('static int tick_openwf_scripts_at_native_frame')
$nativeFrameDefinition = $main.IndexOf('static int tick_openwf_scripts_at_native_frame', $nativeFrameDeclaration + 1)
$nativeFrameEnd = $main.IndexOf('struct OpenWfFrameTransaction', $nativeFrameDefinition)
if ($nativeFrameDefinition -lt 0 -or $nativeFrameEnd -le $nativeFrameDefinition) {
    throw 'DEFERRED REGISTRY RELEASE FAIL: protected Application-frame host definition is missing'
}
$nativeFrame = $main.Substring($nativeFrameDefinition, $nativeFrameEnd - $nativeFrameDefinition)
foreach ($required in @(
    'dispatch_openwf_protected_game_vm_operation(L);',
    'if (protected_operation_results >= 0) return protected_operation_results;',
    'luau_L = L;',
    'drain_deferred_game_registry_releases(L);'
)) {
    if (-not $nativeFrame.Contains($required)) {
        throw "DEFERRED REGISTRY RELEASE FAIL: protected owner transaction is missing $required"
    }
}
$dispatchAt = $nativeFrame.IndexOf('dispatch_openwf_protected_game_vm_operation(L);')
$restoreAt = $nativeFrame.IndexOf('struct VmContextRestore')
$lockAt = $nativeFrame.IndexOf('std::lock_guard mtx(running_scripts_mtx);')
$drainAt = $nativeFrame.IndexOf('drain_deferred_game_registry_releases(L);')
if ($dispatchAt -lt 0 -or $restoreAt -lt 0 -or $lockAt -lt 0 -or $drainAt -lt 0 -or
    $dispatchAt -gt $restoreAt -or $drainAt -gt $lockAt) {
    throw 'DEFERRED REGISTRY RELEASE FAIL: local dispatcher/drain ordering can cross C++ lifetime ownership'
}
if ([regex]::Matches($main, 'drain_deferred_game_registry_releases\(L\);').Count -ne 1) {
    throw 'DEFERRED REGISTRY RELEASE FAIL: cleanup drain must exist only in the admitted owner transaction'
}

$dispatcher = Get-Region $bridge 'int dispatch_openwf_protected_game_vm_operation(' 'std::size_t drain_deferred_game_registry_releases(' 'protected dispatcher'
foreach ($required in @(
    'case ProtectedGameVmOperationKind::release_registry:',
    'luau_pushstring(state, operation->text);',
    'state->outtop->type = owf_game_tag(LUAU_NIL);',
    'luau_settable(state, -10002);',
    'operation->succeeded = true;'
)) {
    if (-not $dispatcher.Contains($required)) {
        throw "DEFERRED REGISTRY RELEASE FAIL: protected dispatcher is missing $required"
    }
}

Write-Host 'DEFERRED REGISTRY RELEASE PASS finalizer=queue-only owner=construction-global-state drain=owner-transaction local-pcall=yes bounded=yes'
