# Deterministic gates for generic target-root instance binding, exact
# prototype attribution of luaCalls, and bounded Lua error text (2026-09-29).
# Offline only. Reads the shared 44.0.2 corpus read-only; never touches a game
# folder.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$runtimeDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $runtimeDir
$repo = Split-Path -Parent $toolchainDir
$corpus = [IO.Path]::GetFullPath((Join-Path $repo '..\..\..\shared\corpus\de-luau-u44.0.2-authoring'))
$survival = Join-Path $corpus 'Lotus_Scripts_Modes_SurvivalMission.lua_B'
$unrelated = Join-Path $corpus 'Lotus_Scripts_Arbitration.lua_B'
foreach ($path in @($survival, $unrelated)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "TARGET ROOT GATE FAIL: fixture missing: $path" }
}
. (Join-Path $toolchainDir 'gate_paths.ps1')
# Native tools read short copies and write to the gate scratch folder (the
# repository may be deeper than MAX_PATH).
$binaryDir = Get-GateScratch $repo 'target-root'
$survival = Copy-GateInput $survival $binaryDir
$unrelated = Copy-GateInput $unrelated $binaryDir

function Get-Region([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "TARGET ROOT GATE FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "TARGET ROOT GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Before([string]$Text, [string]$First, [string]$Second) {
    $a = $Text.IndexOf($First, [StringComparison]::Ordinal)
    $b = $Text.IndexOf($Second, [StringComparison]::Ordinal)
    return $a -ge 0 -and $b -ge 0 -and $a -lt $b
}

# 1. Real-module fixture through the runtime's own core selection code.
$originalEnvironment = @{}
foreach ($entry in Get-ChildItem Env:) { $originalEnvironment[$entry.Name] = $entry.Value }
try {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
    $vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
    if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
        throw "Visual Studio 2022 x64 C++ tools were not found"
    }
    Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
    Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
    $source = Join-Path (Copy-GateSources $repo $binaryDir @('renovice', 'RENOVICE_TOOLCHAIN\runtime\verify_target_root_binding.cpp')) 'RENOVICE_TOOLCHAIN\runtime\verify_target_root_binding.cpp'
    $binary = Join-Path $binaryDir 'verify_target_root_binding.exe'
    $object = Join-Path $binaryDir 'verify_target_root_binding.obj'
    $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fo:$object /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $output | Write-Output
    if ($LASTEXITCODE -ne 0) { throw "TARGET ROOT GATE FAIL: checker compilation failed: $LASTEXITCODE" }
    & $binary $survival $unrelated
    if ($LASTEXITCODE -ne 0) { throw "TARGET ROOT GATE FAIL: fixture checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 2. Source invariants.
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))

$detour = Get-Region $injection "void vm_execute_detour(luau_State* state)`n{" 'void maybe_poll_runtime_controls() noexcept' 'vm_execute_detour'
Require (Before $detour 'const auto target_root = inspect_target_root_entry(state);' 'reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);') 'root instance is identified before the naked stock VM execute'
Require (Before $detour 'reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);' 'queue_target_root_return(settle_target_root_return(state, target_root));') 'root return is recorded only after a normal stock return'
Require (Before $detour 'apply_target_root_returns(state);' 'drain_pending_target_addons_for_vm(state);') 'root rebind is queued at the exact idle return before the refresh drain'
Require (Before $detour 'if (!exact_idle_return) return;' 'apply_target_root_returns(state);') 'identity update runs only at an exact idle return'

$inspect = Get-Region $injection 'TargetRootEntry inspect_target_root_entry(luau_State* state) noexcept' 'void queue_target_root_return(' 'inspect_target_root_entry'
Require ($inspect.Contains('target_root_watch_enabled.load(std::memory_order_acquire)')) 'root watch is a lock-free fast gate when no target addon is enabled'
Require ($inspect.Contains('root.global_state == state->global_state') -and $inspect.Contains('root.root_proto == closure->l.p')) 'root instance matches exact VM and loaded root prototype'
$settle = Get-Region $injection 'TargetRootEntry settle_target_root_return(luau_State* state, TargetRootEntry entry) noexcept' 'void queue_target_root_return(' 'settle_target_root_return'
Require ($settle.Contains('entry.environment = closure->env;') -and $settle.Contains('closure->l.p != entry.root_proto') -and $settle.Contains('offsetof(luau_Closure, l.uprefs)')) 'the root environment is re-read from the same validated root closure at its return (module(...) re-points it)'
foreach ($forbidden in @('getfield', 'lock_guard', 'std::string', 'std::vector', 'ostringstream', 'config::')) {
    Require ($settle.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "return-environment settle performs no VM, lock or allocation work: no $forbidden"
}
Require ($settle.Contains('RootEnvironmentAccumulator accumulator;') -and $settle.Contains('proto_is_direct_child(children, static_cast<std::size_t>(child_count), child->l.p)') -and $settle.Contains('accumulator.choose(closure->env)')) 'fix 3: the published environment is the one the root child closures agree on (unit-tested rule), else the root closure environment'
Require ($settle.Contains('luau_restorestack(state, entry.register_base_offset)') -and $settle.Contains('base + entry.register_count > state->stack_last')) 'fix 3: the dead register window is re-based on the current stack and bounds-checked'
Require ($inspect.Contains('entry.register_base_offset = luau_savestack(state, state->intop);') -and $inspect.Contains('entry.register_count = closure->stacksize;')) 'fix 3: the root register window is captured at entry as a stack offset'
Require ($inspect.Contains('entry.closure = closure;') -and $inspect.Contains('entry.entry_environment = closure->env;')) 'the root closure and its entry environment are captured at VM execute entry'

$publish = Get-Region $injection 'void publish_target_execution_snapshot_locked()' 'TargetExecutionLease acquire_target_execution_snapshot() noexcept' 'publish_target_execution_snapshot_locked'
Require (Before $publish 'target_root_return_watch_required(' 'snapshot->roots.push_back') 'the watch predicate gates root publication'
Require ($publish.Contains('target_root_return_watch_required(') -and $publish.Contains('target_key_bound_locked(identity.target_key, identity.global_state)') -and $publish.Contains('target_root_return_retry_spent(identity, active_generation)')) 'bound once: only a desired, unbound, not-yet-retried module root is watched'
$queue = Get-Region $injection 'void queue_target_root_return(' 'void apply_target_root_returns(' 'queue_target_root_return'
foreach ($forbidden in @('getfield', 'setfield', 'run_chunk', 'lifecycle_operation', 'generation_mutex', 'protected_call')) {
    Require ($queue.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "post-return recording performs no VM or generation work: no $forbidden"
}
Require ($queue.Contains('maximum_pending_root_returns')) 'pending root returns are bounded'
$apply = Get-Region $injection 'void apply_target_root_returns(' 'void vm_execute_detour(' 'apply_target_root_returns'
Require ($apply.Contains('record_target_root_return(') -and $apply.Contains('publish_target_execution_snapshot_locked();')) 'identity update uses the unit-tested model and republishes the execution snapshot'
Require ($apply.Contains('same_target_addon_context(')) 'rebind is queued per VM, module key and owner thread'
Require (Before $apply 'target_root_return_watch_required(' 'record_target_root_return(') 'apply re-checks bound/retry state before touching identities (a bound module never rebinds)'
Require (Before $apply 'load->root_return_retry_spent = true;' 'record_target_root_return(') 'the single root-return retry is consumed before the rebind is queued'
Require ($apply.Contains('reason=unbound retry=once-per-generation')) 'the root-return log line names the unbound reason and the one-retry bound'
Require ($apply.Contains('env_source=') -and $apply.Contains('child_closures=')) 'fix 3: the root-return log names the environment source'

$call = Get-Region $injection 'TargetLuaCall target_lua_call_for_published_closure(' 'std::uint64_t target_key_for_closure_locked(' 'luaCalls attribution'
Require ($call.Contains('select_target_prototype_owner(') -and -not $call.Contains('published_target_closure_is_live(')) 'luaCalls attribute by exact prototype identity, not by the load environment'
Require ($call.Contains('published_target_proto_is_live(record)') -and $call.Contains('owner.ambiguous')) 'luaCalls keep live-prototype validation and fail closed on ambiguity'

$activate = Get-Region $injection "bool activate_target_addons_locked(`n`tstd::uint64_t target_key," 'bool activate_target_addons(' 'activate_target_addons_locked'
Require ($activate.Contains('&& current[i].bound_environment == target_environment;')) 'a new module environment forces a fresh binding instead of root reuse'
Require ($activate.Contains('target_environment, true, manager, name_handle, true,')) 'target chunks execute in the latest module environment'

$leaf = Get-Region $injection '// BEGIN GUARDED_RUN_PROTECTED_LEAF' '// END GUARDED_RUN_PROTECTED_LEAF' 'guarded leaf'
Require ($leaf.Contains('context->exact_environment != nullptr') -and $leaf.Contains('= selected_environment;')) 'guarded load uses the exact runtime environment when supplied'
Require ($leaf.Contains('capture_lua_error_text(*(state->outtop - 1),')) 'chunk errors are captured before registry restoration'

$lifecycle = Get-Region $injection '// BEGIN LIFECYCLE_OPERATION_PROTECTED_LEAF' '// END LIFECYCLE_OPERATION_PROTECTED_LEAF' 'lifecycle leaf'
Require (Before $lifecycle 'capture_lua_error_text(*(state->outtop - 1),' 'context->failure = LifecycleLeafFailure::protected_call_rejected;') 'lifecycle error text is copied before the stack is restored'
$before = Get-Region $injection '// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF' '// END LUA_CALL_BEFORE_PROTECTED_LEAF' 'luaCalls.before leaf'
Require (Before $before 'capture_lua_error_text(*(state->outtop - 1),' 'state->outtop = luau_restorestack(state, callback_base_offset);') 'luaCalls.before error text is copied before the stack is restored'
$capture = Get-Region $injection 'void capture_lua_error_text(' 'void append_error_value(' 'capture_lua_error_text'
Require ($capture.Contains(') noexcept') -and $capture.Contains('sanitize_error_text(')) 'error capture is noexcept and sanitized'
foreach ($forbidden in @('std::string', 'std::ostringstream', 'std::vector', 'throw', ' new ')) {
    Require ($capture.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "error capture is destructor-free: no $forbidden"
}

Write-Output "TARGET ROOT BINDING GATES PASS"
