# Deterministic gates for the generic luaCalls.before retire-after-use
# primitive (2026-09-30). Offline only: compiles the probe fixture with the DE
# Luau toolchain, runs the pure model self-tests and micro-benchmark, and pins
# the runtime integration in injection.cpp. It never reads or writes a game
# folder.
param(
    # Optional: copy the compiled probe here (for staging an opt-in live test).
    [string]$EmitProbe = ""
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$injectionDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $injectionDir
$repo = Split-Path -Parent $toolchainDir
$deToolchain = [IO.Path]::GetFullPath((Join-Path $repo '..\..\toolchains\de-luau-toolchain\bin'))
. (Join-Path $toolchainDir 'gate_paths.ps1')
$scratch = Get-GateScratch $repo 'lua-retire'

function Get-Region([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "LUA CALL RETIRE GATE FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "LUA CALL RETIRE GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Before([string]$Text, [string]$First, [string]$Second) {
    $a = $Text.IndexOf($First, [StringComparison]::Ordinal)
    $b = if ($a -ge 0) { $Text.IndexOf($Second, $a + $First.Length, [StringComparison]::Ordinal) } else { -1 }
    return $a -ge 0 -and $b -gt $a
}

# 1. Real DE fixture (also the opt-in live probe).
$fixtureSource = Copy-GateInput (Join-Path $injectionDir 'fixtures\RetireProbe.targets.addon.luau') $scratch
$fixture = Join-Path $scratch 'RetireProbe.targets.addon.lua_B'
& (Join-Path $deToolchain 'derecomp.exe') recompile-u44 $fixtureSource $fixture
if ($LASTEXITCODE) { throw 'LUA CALL RETIRE GATE FAIL: fixture U44 compilation failed' }
& (Join-Path $deToolchain 'derecomp.exe') de-roundtrip $fixture
if ($LASTEXITCODE) { throw 'LUA CALL RETIRE GATE FAIL: fixture container roundtrip failed' }

# 2. Pure model self-tests and micro-benchmark.
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
    $mirror = Copy-GateSources $repo $scratch @('renovice', 'RENOVICE_TOOLCHAIN\injection\verify_lua_call_retirement.cpp')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\injection\verify_lua_call_retirement.cpp'
    $binary = Join-Path $scratch 'verify_lua_call_retirement.exe'
    $object = Join-Path $scratch 'verify_lua_call_retirement.obj'
    $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fo:$object /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $output | Write-Output
    if ($LASTEXITCODE -ne 0) { throw "LUA CALL RETIRE GATE FAIL: checker compilation failed: $LASTEXITCODE" }
    & $binary $fixture
    if ($LASTEXITCODE -ne 0) { throw "LUA CALL RETIRE GATE FAIL: model checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 3. Source invariants of the runtime integration.
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))

$interruptEnd = $injection.LastIndexOf('void vm_execute_detour(')
$interruptStart = $injection.LastIndexOf('std::uint32_t de_luau_interrupt_increment_detour(', $interruptEnd)
$interrupt = $injection.Substring($interruptStart, $interruptEnd - $interruptStart)
Require (Before $interrupt 'if (!lua_before_provider_fast_gate.load(std::memory_order_acquire))' 'exact_current_lua_instruction(') 'fast path: the atomic gate is the first observer check, before any decode, lease, Lua entry or allocation'

$claims = Get-Region $injection 'bool target_provider_claims_lua_before(' 'bool any_target_provider_claims_native_method(' 'claim check'
Require ($claims.Contains('entry.lua_before_retire->slot_retired(index)')) 'fast path: a retired slot is rejected in the claim check (lock-free), when another slot keeps the gate open'
Require (Before $interrupt 'target_provider_claims_lua_before(' 'struct ScopedObserverStack') 'fast path: the claim check runs before any VM-top write'
Require (Before $interrupt 'struct ScopedObserverStack' 'dispatch_lua_call_phase(') 'fast path: no dispatch before the claim check admits the slot'

$publish = Get-Region $injection 'void publish_target_execution_snapshot_locked()' 'struct TargetExecutionLease' 'publish'
Require (Before $publish 'bind_lua_call_retire_ledgers_locked(*snapshot);' 'published_target_execution_snapshot.store(') 'publication binds ledgers before the snapshot becomes visible'
Require (Before $publish 'published_target_execution_snapshot.store(' 'refresh_lua_before_provider_fast_gate();') 'the gate is recomputed from the published snapshot after every publication'
Require ($publish.Contains('!snapshot->roots.empty() || !snapshot->instance_roots.empty()')) 'root watch covers retry roots and instance roots'

$bind = Get-Region $injection 'void bind_lua_call_retire_ledgers_locked(TargetExecutionSnapshot& snapshot)' 'void refresh_lua_before_provider_fast_gate_locked() noexcept' 'ledger binding'
Require ($bind.Contains('ledger->same_identity(snapshot.generation, provider.key,') -and $bind.Contains('lua_call_retire_binding_fingerprint(registry_keys)')) 'F9/rebind: ledgers are reused only for the same generation, key, VM, prototypes, root children and binding set'
Require ($bind.Contains('prototype.parent == root')) 'scope: only direct children of the module root are retirable'
Require ($bind.Contains('lua_call_retire_ledgers = std::move(bound);')) 'superseded ledgers are unregistered at publication'

$refresh = Get-Region $injection 'void refresh_lua_before_provider_fast_gate_locked() noexcept' 'void refresh_lua_before_provider_fast_gate() noexcept' 'gate refresh'
Require ($refresh.Contains('published_target_execution_snapshot.load(') -and $refresh.Contains('lua_call_before_slot_armed(')) 'gate: open while any admitted slot of the published providers is armed'

$retire = Get-Region $injection 'void retire_lua_call_slot(' 'void publish_target_execution_snapshot_locked()' 'retire_lua_call_slot'
Require ($retire.Contains('ignored-superseded-generation-or-binding') -and $retire.Contains('ignored-cross-vm')) 'fail closed: dead-generation, superseded-binding and cross-VM signals change nothing'
Require (Before $retire 'std::lock_guard retire_lock(lua_call_retire_mutex);' 'refresh_lua_before_provider_fast_gate_locked();') 'retire updates the ledger and the gate under the retire mutex'
Require (Before $retire 'if (config::diagnostics_mode() == config::DiagnosticsMode::off) return;' 'log_lua_call_retire_event(') 'diagnostics off: nothing is formatted or logged for a retirement'
Require (Before $retire 'view = ledger->view(call.callsite.prototype);' 'if (config::diagnostics_mode() == config::DiagnosticsMode::off) return;') 'diagnostics: the ledger view is copied under the retire mutex; formatting happens after unlock'
foreach ($forbidden in @('getfield', 'setfield', 'protected_call', 'generation_mutex', 'lua_execution_mutex', 'config::log(')) {
    Require ($retire.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "retire bookkeeping performs no VM work and takes no generation lock: no $forbidden"
}

$entry = Get-Region $injection 'void note_lua_call_instance_entry(' 'void note_lua_call_instance_settled(' 'instance entry'
Require (Before $entry 'ledger->on_root_entry(environment, serial);' 'refresh_lua_before_provider_fast_gate_locked();') 're-arm: a root entry reopens the gate before the root runs'
Require (Before $entry 'config::diagnostics_mode() != config::DiagnosticsMode::off' 'log_lua_call_retire_event(') 'diagnostics off: re-arm formats nothing'
Require ($entry.Contains('view = ledger->view(-1);') -and $entry.Contains('outcome == LuaCallRearmOutcome::overflow && !overflow_before')) 'diagnostics: re-arm copies the view under the mutex and reports an overflow only once'
foreach ($forbidden in @('getfield', 'setfield', 'protected_call', 'generation_mutex', 'acquire_target_execution_snapshot')) {
    Require ($entry.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "re-arm performs no VM work and takes no generation lock: no $forbidden"
}

$inspect = Get-Region $injection 'TargetRootEntry inspect_target_root_entry(luau_State* state) noexcept' 'TargetRootEntry settle_target_root_return(' 'inspect'
Require ($inspect.Contains('execution.snapshot->instance_roots') -and $inspect.Contains('note_lua_call_instance_entry(entry.target_key, state->global_state, closure->env);')) 're-arm: every natural VM-execute entry of a watched root is a new instance'

$detour = Get-Region $injection "void vm_execute_detour(luau_State* state)`n{" 'void maybe_poll_runtime_controls() noexcept' 'vm_execute_detour'
Require (Before $detour 'const auto target_root = inspect_target_root_entry(state);' 'reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);') 're-arm happens before the naked stock VM execute'
Require (Before $detour 'reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);' 'note_lua_call_instance_settled(settled_root);') 'the published environment is recorded only after a normal root return'

$leaf = Get-Region $injection '// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF' '// END LUA_CALL_BEFORE_PROTECTED_LEAF' 'luaCalls.before leaf'
Require ($leaf.Contains('protected_call(state, 4, 1, 0)') -and -not $leaf.Contains('protected_call(state, 4, 0, 0)')) 'signal: the callback result is read (one result, nil when nothing is returned)'
Require (Before $leaf 'context->callback_status == 0' 'lua_call_before_leaf_is_retire_signal(*(state->outtop - 1))') 'signal: only a successful callback can signal'
Require (Before $leaf 'lua_call_before_leaf_is_retire_signal(*(state->outtop - 1))' 'state->outtop = luau_restorestack(state, callback_base_offset);') 'signal: the result is read before the stack is restored'
Require ($leaf.Contains('++context->invoked_count;')) 'signal: invoked providers are counted'
$helper = Get-Region $injection 'bool lua_call_before_leaf_is_retire_signal(const luau_TValue& value) noexcept' '// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF' 'sentinel helper'
foreach ($forbidden in @('std::string', 'std::vector', 'ostringstream', 'throw', ' new ', 'config::')) {
    Require ($helper.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "signal: the sentinel read is destructor-free: no $forbidden"
}

$dispatch = Get-Region $injection 'bool dispatch_lua_call_phase(' 'enum class NativeCallPhaseLeafStage' 'dispatch'
Require (Before $dispatch 'live_argument_base[index] = candidate_arguments[index];' 'retire_lua_call_slot(state, call, providers.execution.snapshot.get());') 'retire only after the committed copy-back'
Require ($dispatch.Contains('context.retire_signals != 0') -and $dispatch.Contains('context.retire_signals == context.invoked_count')) 'every invoked provider must signal'
Require (Before $dispatch 'restore_stock();' 'retire_lua_call_slot(') 'a failed or rejected dispatch returns before retirement'

# Other hook kinds are untouched: nativeCalls, damage and lifecycle leaves do
# not interpret the sentinel.
$native = Get-Region $injection 'enum class NativeCallPhaseLeafStage' 'bool dispatch_native_call_phase(' 'nativeCalls leaf'
Require ($native.IndexOf('lua_call_before_leaf_is_retire_signal', [StringComparison]::Ordinal) -lt 0 -and $native.IndexOf('retire_signals', [StringComparison]::Ordinal) -lt 0) 'other hooks: the nativeCalls leaf does not interpret the sentinel'
Require ([regex]::Matches($injection, [regex]::Escape('retire_lua_call_slot(state, call,')).Count -eq 1) 'other hooks: retirement is reachable only from the luaCalls.before dispatch'

if (-not [string]::IsNullOrWhiteSpace($EmitProbe)) {
    New-Item -ItemType Directory -Path $EmitProbe -Force | Out-Null
    Copy-Item -LiteralPath $fixture -Destination (Join-Path $EmitProbe 'RetireProbe.targets.addon.lua_B') -Force
    Write-Output "PROBE EMITTED $(Join-Path $EmitProbe 'RetireProbe.targets.addon.lua_B')"
}

Write-Output "LUA CALL RETIREMENT GATES PASS"
