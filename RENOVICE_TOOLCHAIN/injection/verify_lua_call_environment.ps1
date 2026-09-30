# Deterministic gates for contract R10 (2026-09-30): luaCalls[P].before
# receives the called closure's environment table as its fifth argument.
# Offline only; it never reads or writes a game folder.
#   1. Real DE fixture (ParamEnvProbe, also an opt-in live probe): compiled
#      with the generator's path (recompile-u44 + the U44 alias map), container
#      round trip. The compiled bytes must hold the parameter as a hashed key
#      (U44 native-name hash of `scoreGoal`, 3a44eae1) and never as a string,
#      and the stock TerritoryMission module (when the U44 corpus is present)
#      must read the same hash, so `environment.scoreGoal` is the key the stock
#      GETGLOBAL reads. The fixture source then runs in plain Luau against the
#      R10 host call shape (write once per instance, skip, rewrite, drift,
#      several instances, runtime without R10, cleanup).
#   2. MSVC /W4 /WX unit checks of renovice/lua_call_environment_core.hpp.
#   3. Source pins: the dispatch prepares the argument through the rule after
#      a readable-pointer probe, the leaf appends it and calls the callback
#      with five arguments and two results, and the R3/R4 retirement and S2
#      prefilter paths are untouched (their own gate runs separately).
param(
    # Optional: copy the compiled probe here (for staging an opt-in live test).
    [string]$EmitProbe = ""
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$injectionDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $injectionDir
$repo = Split-Path -Parent $toolchainDir
$deToolchain = [IO.Path]::GetFullPath((Join-Path $repo '..\..\toolchains\de-luau-toolchain'))
$derecomp = Join-Path $deToolchain 'bin\derecomp.exe'
$aliasMap = Join-Path $deToolchain 'profiles\u44\name-map.tsv'
$luau = Join-Path $deToolchain 'bin\luau.exe'
$stockTerritory = Join-Path $deToolchain 'work\u44-rawhash-2026-09-29\stock\Lotus_Scripts_Modes_TerritoryMission.lua_B'
. (Join-Path $toolchainDir 'gate_paths.ps1')
$scratch = Get-GateScratch $repo 'lua-env'

function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "LUA CALL ENVIRONMENT GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Get-Region([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "LUA CALL ENVIRONMENT GATE FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
function Before([string]$Text, [string]$First, [string]$Second) {
    $a = $Text.IndexOf($First, [StringComparison]::Ordinal)
    $b = if ($a -ge 0) { $Text.IndexOf($Second, $a + $First.Length, [StringComparison]::Ordinal) } else { -1 }
    return $a -ge 0 -and $b -gt $a
}
function Read-Lf([string]$Path) { return [IO.File]::ReadAllText($Path).Replace("`r`n", "`n") }
function Write-Lf([string]$Path, [string]$Text) { [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false)) }
function Invoke-Tool([string]$Exe, [string[]]$Arguments) {
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $output = @(& $Exe @Arguments 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") }); $exit = $LASTEXITCODE }
    finally { $ErrorActionPreference = $previous }
    return [pscustomobject]@{ Exit = $exit; Lines = $output; Text = ($output -join "`n") }
}
function Test-Bytes([byte[]]$Haystack, [byte[]]$Needle) {
    for ($i = 0; $i -le $Haystack.Length - $Needle.Length; ++$i) {
        $match = $true
        for ($j = 0; $j -lt $Needle.Length; ++$j) { if ($Haystack[$i + $j] -ne $Needle[$j]) { $match = $false; break } }
        if ($match) { return $true }
    }
    return $false
}

# 1. Real DE fixture.
$fixtureSource = Copy-GateInput (Join-Path $injectionDir 'fixtures\ParamEnvProbe.targets.addon.luau') $scratch
$fixture = Join-Path $scratch 'ParamEnvProbe.targets.addon.lua_B'
$compile = Invoke-Tool $derecomp @('recompile-u44', $fixtureSource, $fixture, $aliasMap)
$compile.Lines | ForEach-Object { Write-Output "COMPILE`t$_" }
Require ($compile.Exit -eq 0 -and $compile.Text.Contains('re-parses=yes') -and $compile.Text.Contains('hashed-fields=1')) 'fixture compiles on the generator path (recompile-u44 + alias map) with one hashed field name'
$roundtrip = Invoke-Tool $derecomp @('de-roundtrip', $fixture)
Require ($roundtrip.Exit -eq 0 -and $roundtrip.Text.Contains('FULL BODY identical: True')) 'fixture DE 09 03 container round trip is byte-exact'
$bytes = [IO.File]::ReadAllBytes($fixture)
$hash = [byte[]](0xe1, 0xea, 0x44, 0x3a)  # 3a44eae1, little endian
Require (Test-Bytes $bytes $hash) 'fixture: environment.scoreGoal is keyed by the U44 native-name hash 3a44eae1'
# Key class: the same source without the directive keys the parameter by the
# string "scoreGoal" (wrong: the environment holds it under the hash). The
# per-prototype CONST-ID comparison must show exactly that class change and
# nothing else, and the decompiled fixture must render every use (reads and
# writes) hashed (a mixed name would render as scoreGoal__<hash>).
$fixtureText = Read-Lf (Join-Path $injectionDir 'fixtures\ParamEnvProbe.targets.addon.luau')
$directive = "-- RENOVICE_HASH_FIELD: scoreGoal`n"
Require ($fixtureText.StartsWith($directive)) 'fixture: the hashed-field directive is its first line'
$stringSource = Join-Path $scratch 'ParamEnvProbe.string-keyed.luau'
Write-Lf $stringSource $fixtureText.Substring($directive.Length)
$stringFixture = Join-Path $scratch 'ParamEnvProbe.string-keyed.lua_B'
$stringCompile = Invoke-Tool $derecomp @('recompile-u44', $stringSource, $stringFixture, $aliasMap)
Require ($stringCompile.Exit -eq 0 -and $stringCompile.Text.Contains('hashed-fields=0')) 'control: the same source without the directive compiles string-keyed'
$const = Invoke-Tool $derecomp @('const-identity', $stringFixture, $fixture, '--u44')
$const.Lines | ForEach-Object { Write-Output "CONSTID`t$_" }
$keyLines = @($const.Lines | Where-Object { $_ -match '^proto \d+ KEYUSE ' })
Require ($keyLines.Count -ge 1 -and @($keyLines | Where-Object { $_ -notmatch 'KEYUSE only-stock=\[FIELD S:scoreGoal\] only-candidate=\[FIELD H:3a44eae1\]$' }).Count -eq 0) 'CONST-ID: every use of the parameter changes from string key S:scoreGoal to hashed key H:3a44eae1'
Require ($const.Text.Contains("CLASS_SWAPS hash_string_class_swaps=$($keyLines.Count) other_keyuse_differences=0")) 'CONST-ID: the class swap is the only key-use difference'
Require ($const.Text -match 'differing_bytes_by_canonical_op_field=\{3d\.aux:\d+\}') 'CONST-ID: the code differs only in the GETTABLEKS/SETTABLEKS key operand'
$decompiled = Join-Path $scratch 'ParamEnvProbe.decompiled.luau'
$decompile = Invoke-Tool $derecomp @('decompile-mod-u44', $fixture, $decompiled)
$decompiledText = if ($decompile.Exit -eq 0 -and (Test-Path -LiteralPath $decompiled)) { Read-Lf $decompiled } else { '' }
Require ($decompiledText.Contains($directive) -and -not $decompiledText.Contains('scoreGoal__') -and ([regex]::Matches($decompiledText, '\.scoreGoal\b')).Count -ge 5) 'decompile: all reads and writes of the parameter are hashed (no string-keyed scoreGoal__ spelling)'
if (Test-Path -LiteralPath $stockTerritory -PathType Leaf) {
    Require (Test-Bytes ([IO.File]::ReadAllBytes($stockTerritory)) $hash) 'stock TerritoryMission reads the same native-name hash (its GETGLOBAL scoreGoal)'
}
else {
    Write-Output "SKIP`tstock TerritoryMission not present (U44 corpus); hash pinned by the fixture only"
}
Require (Test-Path -LiteralPath $luau -PathType Leaf) 'toolchain luau.exe present'
$harness = Join-Path $scratch 'param_env_run.luau'
Write-Lf $harness ("PARAM_ENV_MODULE = function(...)`n" + (Read-Lf (Join-Path $injectionDir 'fixtures\ParamEnvProbe.targets.addon.luau')) + "`nend`n" + (Read-Lf (Join-Path $injectionDir 'fixtures\param_env_harness.luau')))
$run = Invoke-Tool $luau @($harness)
$run.Lines | ForEach-Object { Write-Output "HARNESS`t$_" }
Require ($run.Exit -eq 0 -and @($run.Lines | Where-Object { $_ -like 'PARAM ENV HARNESS PASS*' }).Count -eq 1 -and @($run.Lines | Where-Object { $_ -like 'FAIL*' }).Count -eq 0) 'harness: write once per instance, skip, rewrite, drift, several instances, no fifth argument, cleanup'

# 2. Unit checks of the pure rule.
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
    $mirror = Copy-GateSources $repo $scratch @('renovice\lua_call_environment_core.hpp', 'RENOVICE_TOOLCHAIN\injection\verify_lua_call_environment.cpp')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\injection\verify_lua_call_environment.cpp'
    $binary = Join-Path $scratch 'verify_lua_call_environment.exe'
    $object = Join-Path $scratch 'verify_lua_call_environment.obj'
    $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fo:$object /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $output | Write-Output
    if ($LASTEXITCODE -ne 0) { throw "LUA CALL ENVIRONMENT GATE FAIL: checker compilation failed: $LASTEXITCODE" }
    & $binary
    if ($LASTEXITCODE -ne 0) { throw "LUA CALL ENVIRONMENT GATE FAIL: unit checks failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 3. Source pins.
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
Require ($injection.Contains('#include "lua_call_environment_core.hpp"')) 'the runtime uses the unit-tested rule header'
$context = Get-Region $injection 'struct LuaCallBeforeLeafContext' 'static_assert(std::is_trivially_copyable_v<LuaCallBeforeLeafContext>);' 'leaf context'
Require ($context.Contains('luau_TValue environment{};')) 'context: the environment argument is a plain value prepared outside the leaf'
$leaf = Get-Region $injection '// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF' '// END LUA_CALL_BEFORE_PROTECTED_LEAF' 'luaCalls.before leaf'
Require ($leaf.Contains('renovice::lua_call_environment::before_callback_argument_count]{};')) 'leaf: the callback argument array has the rule''s argument count'
Require ($leaf.Contains('renovice::lua_call_environment::environment_argument_index] =') -and $leaf.Contains('context->environment;')) 'leaf: the environment is the appended argument'
Require (Before $leaf 'callback_arguments[3] = lua_call_before_leaf_trace(state, context);' 'renovice::lua_call_environment::environment_argument_index] =') 'leaf: the four earlier arguments are unchanged and come first'
Require ($leaf.Contains('protected_call(state, 5, 2, 0)') -and -not $leaf.Contains('protected_call(state, 4, 2, 0)')) 'leaf: five arguments, two results (R3/R4 signal reading unchanged)'
Require ($leaf.Contains('static_assert(renovice::lua_call_environment::before_callback_argument_count == 5);')) 'leaf: the literal argument count is pinned to the rule'
foreach ($forbidden in @('bad_read_ptr', 'lua_call_environment::classify', 'std::string', 'config::')) {
    Require ($leaf.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "leaf: no probing, classification or allocation inside the raw leaf: no $forbidden"
}
$dispatch = Get-Region $injection 'bool dispatch_lua_call_phase(' 'bool dispatch_native_call_phase(' 'luaCalls.before dispatch'
Require (Before $dispatch 'context.environment.type = LUAU_NIL;' 'renovice::lua_call_environment::classify(') 'dispatch: the argument defaults to nil before classification'
Require (Before $dispatch 'const void* const environment = call.closure->env;' '!diagnostics::bad_read_ptr(environment, sizeof(std::uint8_t));') 'dispatch: the environment of the exact called closure is probed'
Require (Before $dispatch '!diagnostics::bad_read_ptr(environment, sizeof(std::uint8_t));' '*static_cast<const std::uint8_t*>(environment)') 'dispatch: the GC header byte is read only after the readable-pointer probe'
Require (Before $dispatch '== renovice::lua_call_environment::Decision::table)' 'context.environment.type = tag;') 'dispatch: only a table decision passes the environment'
Require (Before $dispatch 'context.environment.type = tag;' 'de_vm_authority::run_current_vm_protected(') 'dispatch: the argument is prepared before the protected leaf runs'
Require ([regex]::Matches($injection, [regex]::Escape('renovice::lua_call_environment::classify(')).Count -eq 1) 'only the luaCalls.before dispatch passes an environment (nativeCalls, damage and lifecycle callbacks are unchanged)'
$native = Get-Region $injection 'enum class NativeCallPhaseLeafStage' 'bool dispatch_native_call_phase(' 'nativeCalls leaf'
Require ($native.IndexOf('lua_call_environment', [StringComparison]::Ordinal) -lt 0) 'nativeCalls leaf does not use the environment argument'

if (-not [string]::IsNullOrWhiteSpace($EmitProbe)) {
    New-Item -ItemType Directory -Path $EmitProbe -Force | Out-Null
    Copy-Item -LiteralPath $fixture -Destination (Join-Path $EmitProbe 'ParamEnvProbe.targets.addon.lua_B') -Force
    Write-Output "PROBE EMITTED $(Join-Path $EmitProbe 'ParamEnvProbe.targets.addon.lua_B')"
}

Write-Output "LUA CALL ENVIRONMENT GATES PASS"
