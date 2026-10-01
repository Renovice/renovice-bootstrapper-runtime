# Deterministic gates for the generic luaCalls.before retire-after-use
# primitive (2026-09-30) and its R4 follow-ups (S2 armed-prototype prefilter,
# S4 dormant re-arm, S5 retire-all). Offline only: compiles the probe fixtures
# with the DE Luau toolchain, runs the pure model self-tests, the prefilter
# equivalence fuzz and the micro-benchmarks, and pins the runtime integration
# in injection.cpp. It never reads or writes a game folder.
param(
    # Optional: copy the compiled probe here (for staging an opt-in live test).
    [string]$EmitProbe = "",
    # Optional: copy the compiled R4 retire-all probe here.
    [string]$EmitRetireAllProbe = ""
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
$allSource = Copy-GateInput (Join-Path $injectionDir 'fixtures\RetireAllProbe.targets.addon.luau') $scratch
$allFixture = Join-Path $scratch 'RetireAllProbe.targets.addon.lua_B'
& (Join-Path $deToolchain 'derecomp.exe') recompile-u44 $allSource $allFixture
if ($LASTEXITCODE) { throw 'LUA CALL RETIRE GATE FAIL: retire-all fixture U44 compilation failed' }
& (Join-Path $deToolchain 'derecomp.exe') de-roundtrip $allFixture
if ($LASTEXITCODE) { throw 'LUA CALL RETIRE GATE FAIL: retire-all fixture container roundtrip failed' }

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
    & $binary $fixture $allFixture
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
# R10 (2026-09-30): five arguments (the callee environment is appended); the two results are unchanged.
Require ($leaf.Contains('protected_call(state, 5, 2, 0)') -and -not $leaf.Contains('protected_call(state, 5, 0, 0)') -and -not $leaf.Contains('protected_call(state, 5, 1, 0)')) 'signal: two callback results are read (nil-padded; R3 form, S5 retire-all alone or second)'
Require (Before $leaf 'context->callback_status == 0' 'lua_call_before_leaf_retire_signal(*(state->outtop - 2))') 'signal: only a successful callback can signal'
Require ($leaf.Contains('combine_lua_call_retire_results(') -and $leaf.Contains('lua_call_before_leaf_retire_signal(*(state->outtop - 1))')) 'S5 signal: first and second results are classified and combined by the unit-tested rule'
Require (Before $leaf 'lua_call_before_leaf_retire_signal(*(state->outtop - 1))' 'state->outtop = luau_restorestack(state, callback_base_offset);') 'signal: the results are read before the stack is restored'
Require ($leaf.Contains('++context->invoked_count;')) 'signal: invoked providers are counted'
Require ($leaf.Contains('context->signal_addons |= 1ull << index;') -and $leaf.Contains('context->retire_all_addons |= 1ull << index;') -and $leaf.Contains('if (index < 64)')) 'S5/S4: signalling and retire-all addons are recorded per provider index (< 64, else plain R3)'
$helper = Get-Region $injection 'LuaCallRetireSignal lua_call_before_leaf_retire_signal(const luau_TValue& value) noexcept' '// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF' 'sentinel helper'
Require (Before $helper 'is_lua_call_retire_sentinel_bytes(text)' 'diagnostics::bad_read_ptr(text, lua_call_retire_all_sentinel_length + 1)') 'S5 signal: the R3 length is probed and matched before the four retire-all bytes are read'
foreach ($forbidden in @('std::string', 'std::vector', 'ostringstream', 'throw', ' new ', 'config::')) {
    Require ($helper.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "signal: the sentinel read is destructor-free: no $forbidden"
}

$dispatch = Get-Region $injection 'bool dispatch_lua_call_phase(' 'enum class NativeCallPhaseLeafStage' 'dispatch'
Require (Before $dispatch 'live_argument_base[index] = candidate_arguments[index];' 'retire_lua_call_slot(state, call, providers.execution.snapshot.get(),') 'retire only after the committed copy-back'
Require ($dispatch.Contains('context.signal_addons, context.retire_all_addons);')) 'S5: the dispatch hands the per-addon signal masks to the retire path'
Require ($dispatch.Contains('context.retire_signals != 0') -and $dispatch.Contains('context.retire_signals == context.invoked_count')) 'every invoked provider must signal'
Require (Before $dispatch 'restore_stock();' 'retire_lua_call_slot(') 'a failed or rejected dispatch returns before retirement'

# Other hook kinds are untouched: nativeCalls, damage and lifecycle leaves do
# not interpret the sentinel.
$native = Get-Region $injection 'enum class NativeCallPhaseLeafStage' 'bool dispatch_native_call_phase(' 'nativeCalls leaf'
Require ($native.IndexOf('lua_call_before_leaf_retire_signal', [StringComparison]::Ordinal) -lt 0 -and $native.IndexOf('retire_signals', [StringComparison]::Ordinal) -lt 0 -and $native.IndexOf('retire_all', [StringComparison]::Ordinal) -lt 0) 'other hooks: the nativeCalls leaf does not interpret either sentinel'
Require ([regex]::Matches($injection, [regex]::Escape('retire_lua_call_slot(state, call,')).Count -eq 1) 'other hooks: retirement is reachable only from the luaCalls.before dispatch'
Require ([regex]::Matches($injection, [regex]::Escape('lua_call_before_prefilter<')).Count -eq 1) 'other hooks: the S2 prefilter is used only by the luaCalls.before interrupt observer'
$nativeDispatch = Get-Region $injection 'bool dispatch_native_call_phase(' 'std::uint32_t de_luau_interrupt_increment_detour(' 'nativeCalls dispatch'
$damageDispatch = Get-Region $injection 'void damage_callback_install_protected_leaf(' 'enum class LuaCallBeforeLeafStage' 'damage callback install and dispatch'
foreach ($forbidden in @('lua_before_armed_prototypes', 'lua_call_dormant', 'lua_call_before_prefilter', 'retire_lua_call_slot', 'lua_before_retire')) {
    Require ($nativeDispatch.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0 -and $damageDispatch.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "other hooks: nativeCalls and damage dispatch do not use R4 retirement state: no $forbidden"
}

# R4 S2: prefilter placement and armed-set publication.
Require (Before $interrupt 'if (!lua_before_provider_fast_gate.load(std::memory_order_acquire))' 'lua_call_before_prefilter<luau_State, luau_Closure>(') 'S2: the prefilter runs only while the gate is open'
Require (Before $interrupt '|| lua_call_hook_running)' 'lua_call_before_prefilter<luau_State, luau_Closure>(') 'S2: the prefilter runs after the re-entrancy check'
Require (Before $interrupt 'lua_call_before_prefilter<luau_State, luau_Closure>(' 'exact_current_lua_instruction(state, raw_instruction)') 'S2: the prefilter runs before the first IsBadReadPtr probe (exact_current_lua_instruction)'
Require (Before $interrupt 'lua_call_before_prefilter<luau_State, luau_Closure>(' 'acquire_target_execution_snapshot()') 'S2: the prefilter runs before the snapshot lease and the owner search'
Require ($interrupt.Contains('if (lua_call_prefilter_skips(')) 'S2: only a proven miss returns early; candidate and undecided continue on the validated path'
Require (Before $refresh 'lua_before_armed_prototypes.begin();' 'lua_before_armed_prototypes.insert(slot.address);') 'S2: the armed set is rebuilt from the published snapshot on every gate refresh'
Require ($refresh.Contains('slot.slot >= lua_call_retire_max_prototypes') -and $refresh.Contains('((retired >> slot.slot) & 1ull) == 0')) 'S2: the set holds every armed or never-retirable declared slot (no false negative)'
Require (Before $refresh 'lua_before_armed_prototypes.commit();' 'lua_before_provider_fast_gate.store(armed, std::memory_order_release);') 'S2: the armed set is committed before the gate store'
$fastPaths = Get-Region $injection 'void open_lua_before_fast_paths() noexcept' 'void refresh_lua_before_provider_fast_gate() noexcept' 'fail-open helper'
Require ($fastPaths.Contains('lua_before_armed_prototypes.disable();') -and $fastPaths.Contains('lua_before_provider_fast_gate.store(true, std::memory_order_release);')) 'S2 fail open: the exception path disables the prefilter and opens the gate'
Require ([regex]::Matches($injection, [regex]::Escape('lua_before_provider_fast_gate.store(true, std::memory_order_release);')).Count -eq 1) 'S2 fail open: every exception path goes through open_lua_before_fast_paths'

# R4 S4: dormant start, execution-evidence wake.
Require ($bind.Contains('registered_lua_call_retire_ledger_locked(') -and $bind.Contains('predecessor->addon_aware(provider.addons[index].name)') -and $bind.Contains('lua_call_retire_dormant_mask(root_children & all,')) 'S4: only a ledger replacing an earlier one of the same (key, VM) starts dormant, for slots of retire-aware addons only'
Require ($bind.Contains('inherit_aware_addons(predecessor->aware_addons())')) 'S4: retire-awareness is inherited across generations by addon name'
Require ($bind.Contains('prototype.address != root') -and $bind.Contains('provider.lua_before_module_prototypes.erase(root);')) 'S4: module roots are never execution evidence (a root entry is a new instance)'
Require (Before $refresh 'lua_call_dormant_prototypes.begin();' 'lua_call_dormant_watch.store(dormant, std::memory_order_release);') 'S4: the dormant-wake set and watch flag follow every gate refresh'
$wake = Get-Region $injection 'void note_lua_call_dormant_execution(luau_State* state) noexcept' '// Generic target-root instance binding (2026-09-29).' 'dormant wake'
Require (Before $wake 'lua_call_dormant_watch.load(std::memory_order_acquire)' 'lua_call_dormant_wake_candidate<luau_State, luau_Closure>(') 'S4: one atomic load when no ledger is dormant'
Require (Before $wake 'lua_call_dormant_wake_candidate<luau_State, luau_Closure>(' 'acquire_target_execution_snapshot()') 'S4: the lease is taken only for a possible match'
Require ($wake.Contains('std::binary_search(provider.lua_before_module_prototypes.begin(),') -and $wake.Contains('provider.lua_before_retire->wake()') -and $wake.Contains('lua_call_retire_ledgers.end(), provider.lua_before_retire)')) 'S4: only a registered ledger whose module owns the exact prototype wakes'
foreach ($forbidden in @('getfield', 'setfield', 'protected_call', 'generation_mutex', 'lua_execution_mutex', 'config::log(')) {
    Require ($wake.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "S4 wake performs no VM work and takes no generation lock: no $forbidden"
}
Require (Before $detour 'const auto target_root = inspect_target_root_entry(state);' 'note_lua_call_dormant_execution(state);') 'S4: a root entry (new instance) is recorded before the execution-evidence check'
Require (Before $detour 'note_lua_call_dormant_execution(state);' 'reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);') 'S4: the wake happens before the naked stock VM execute'

# Contract R13 (2026-10-01): luaCalls.before at a native entry. Regression of
# the live Defense "Waves per reward" defect: WaveDefend `WaveDefense` (P50) is
# entered by its level ScriptTrigger, never by a Lua CALL, so the interrupt
# observer alone could not dispatch any entry-template row.
$nativeEntry = Get-Region $injection 'void observe_native_entry_lua_call(luau_State* state) noexcept' '// S4 execution evidence.' 'native-entry observer'
Require (Before $nativeEntry 'if (!lua_before_provider_fast_gate.load(std::memory_order_acquire)) return;' 'lua_call_entry_prefilter<luau_State, luau_Closure>(') 'R13: the native-entry rule runs only while the gate is open (one atomic load otherwise)'
Require (Before $nativeEntry '|| lua_call_hook_running)' 'lua_call_entry_prefilter<luau_State, luau_Closure>(') 'R13: no dispatch from inside a dispatch (re-entrancy check first)'
Require (Before $nativeEntry 'lua_call_entry_prefilter<luau_State, luau_Closure>(' 'diagnostics::bad_read_ptr(') 'R13: the unit-tested entry rule runs before the first IsBadReadPtr probe'
Require (Before $nativeEntry 'lua_call_entry_prefilter<luau_State, luau_Closure>(' 'acquire_target_execution_snapshot()') 'R13: the entry rule runs before the snapshot lease'
Require ($nativeEntry.Contains('if (reinterpret_cast<std::uintptr_t>(info->savedpc) != code) return;')) 'R13: the fresh-frame proof is repeated after the probes (first instruction only)'
Require ($nativeEntry.Contains('proto_bytes[de_proto_numparams_offset]') -and $nativeEntry.Contains('static_cast<std::size_t>(info->top - info->base)')) 'R13: the arguments are the fixed parameters, bounded by the frame'
Require (Before $nativeEntry 'target_provider_claims_lua_before(' 'struct ScopedObserverStack') 'R13: the claim check runs before any VM-top write'
Require (Before $nativeEntry 'struct ScopedObserverStack' 'dispatch_lua_call_phase(state, call, "before", arguments, info->base)') 'R13: the shared dispatch (identity, protected leaf, copy-back, R3/R4 retirement) is used unchanged'
foreach ($forbidden in @('std::lock_guard', 'std::unique_lock', 'getfield', 'setfield', 'protected_call', 'retire_lua_call_slot', 'lua_call_before_prefilter<')) {
    Require ($nativeEntry.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "R13: the native-entry observer adds no lock, VM call or retirement path of its own: no $forbidden"
}
Require ([regex]::Matches($injection, [regex]::Escape('observe_native_entry_lua_call(state);')).Count -eq 1) 'R13: the native-entry observer has one call site'
Require (Before $detour 'note_lua_call_dormant_execution(state);' 'observe_native_entry_lua_call(state);') 'R13: a dormant ledger is woken before the native-entry dispatch'
Require (Before $detour 'observe_native_entry_lua_call(state);' 'reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);') 'R13: the native-entry dispatch completes before the naked stock VM execute'

# R4 S5: retire-all scope.
Require ($retire.Contains('lua_call_retire_all_exclusive_mask(') -and $retire.Contains('ledger->on_signal_all(call.callsite.prototype, environment, exclusive, serial)')) 'S5: retire-all serves only slots declared exclusively by retire-all addons, through the ledger rule'
Require ($retire.Contains('ledger->note_aware_addon(provider->addons[index].name);')) 'S4: every addon that signalled becomes retire-aware'
Require (Before $retire 'if (!registered) rejected = "ignored-superseded-generation-or-binding";' 'ledger->on_signal_all(') 'S5 fail closed: superseded generation/binding and cross-VM checks precede retire-all'

if (-not [string]::IsNullOrWhiteSpace($EmitProbe)) {
    New-Item -ItemType Directory -Path $EmitProbe -Force | Out-Null
    Copy-Item -LiteralPath $fixture -Destination (Join-Path $EmitProbe 'RetireProbe.targets.addon.lua_B') -Force
    Write-Output "PROBE EMITTED $(Join-Path $EmitProbe 'RetireProbe.targets.addon.lua_B')"
}
if (-not [string]::IsNullOrWhiteSpace($EmitRetireAllProbe)) {
    New-Item -ItemType Directory -Path $EmitRetireAllProbe -Force | Out-Null
    Copy-Item -LiteralPath $allFixture -Destination (Join-Path $EmitRetireAllProbe 'RetireAllProbe.targets.addon.lua_B') -Force
    Write-Output "PROBE EMITTED $(Join-Path $EmitRetireAllProbe 'RetireAllProbe.targets.addon.lua_B')"
}

Write-Output "LUA CALL RETIREMENT GATES PASS"
