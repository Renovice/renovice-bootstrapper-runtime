# Deterministic gates for ENGINE_PARAM_OVERRIDE (contract R16, 2026-10-01; R17 masters; R19 Railjack encounter modules;
# R21 Spy and Sabotage level-trigger parameters):
# a declared level/encounter script parameter keeps its configured value
# through every engine write (native hook on the engine's parameter writer).
#
# Offline only. The installed executable is READ (SHA-256 and byte ranges) when
# present; nothing is written to a game or server folder.
#   1. MSVC /W4 /WX checker (verify_engine_params.cpp) with the exact
#      packages.cpp, live_literals.cpp and engine_params.cpp: pure rules, the
#      hook decision on a byte-exact model of the writer's frame (engine
#      re-write order for every R16 row), the package scan end to end, and the
#      registered byte ranges against every registered client / native-update reference image (gate_paths.ps1
#      Get-GateClientImages; an unregistered image installs nothing and is reported).
#   2. Source pins: hook order (stock push exactly once), no Lua API and no
#      logging in the hook unless Diagnostics is on, startup/F9 integration,
#      module identity at the natural load and the F9 refresh, no target names
#      in the primitive.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$gateDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $gateDir
$repo = Split-Path -Parent $toolchainDir
. (Join-Path $toolchainDir 'gate_paths.ps1')
$scratch = Get-GateScratch $repo 'engine-params'
$fixtureDir = Join-Path $gateDir 'fixtures'

function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "ENGINE PARAMS GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Read-Lf([string]$Path) { return [IO.File]::ReadAllText($Path).Replace("`r`n", "`n") }
function Count([string]$Text, [string]$Needle) { return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }
function Index([string]$Text, [string]$Needle) { return $Text.IndexOf($Needle, [StringComparison]::Ordinal) }
function Between([string]$Text, [string]$Start, [string]$End) {
    $from = Index $Text $Start
    if ($from -lt 0) { throw "ENGINE PARAMS GATE FAIL: source anchor not found: $Start" }
    $to = $Text.IndexOf($End, $from + $Start.Length, [StringComparison]::Ordinal)
    if ($to -lt 0) { throw "ENGINE PARAMS GATE FAIL: source anchor not found: $End" }
    return $Text.Substring($from, $to - $from)
}

foreach ($name in @('package.json', 'engine_params.json')) {
    Require (Test-Path -LiteralPath (Join-Path $fixtureDir "Missions\$name") -PathType Leaf) "fixture Missions\$name present"
    Require (Test-Path -LiteralPath (Join-Path $fixtureDir "MissionsR17\$name") -PathType Leaf) "fixture MissionsR17\$name present (contract R17)"
    Require (Test-Path -LiteralPath (Join-Path $fixtureDir "MissionsR19\$name") -PathType Leaf) "fixture MissionsR19\$name present (contract R19)"
    Require (Test-Path -LiteralPath (Join-Path $fixtureDir "MissionsR21\$name") -PathType Leaf) "fixture MissionsR21\$name present (contract R21)"
}
Require (Test-Path -LiteralPath (Join-Path $fixtureDir 'MissionsR19\encounter_entry_protos.txt') -PathType Leaf) 'fixture MissionsR19\encounter_entry_protos.txt present (contract R19: real entry prototypes of the Railjack encounter modules)'
Require (Test-Path -LiteralPath (Join-Path $fixtureDir 'MissionsR21\trigger_entry_protos.txt') -PathType Leaf) 'fixture MissionsR21\trigger_entry_protos.txt present (contract R21: real entry prototypes of the Intel and Sabotage trigger modules)'
Write-Output "INFO`tR19 fixture engine_params.json sha256=$((Get-FileHash -LiteralPath (Join-Path $fixtureDir 'MissionsR19\engine_params.json') -Algorithm SHA256).Hash)"
Write-Output "INFO`tR21 fixture engine_params.json sha256=$((Get-FileHash -LiteralPath (Join-Path $fixtureDir 'MissionsR21\engine_params.json') -Algorithm SHA256).Hash)"
Write-Output "INFO`tfixture engine_params.json sha256=$((Get-FileHash -LiteralPath (Join-Path $fixtureDir 'Missions\engine_params.json') -Algorithm SHA256).Hash)"
Write-Output "INFO`tfixture package.json sha256=$((Get-FileHash -LiteralPath (Join-Path $fixtureDir 'Missions\package.json') -Algorithm SHA256).Hash)"

# The client executable and the native-update reference images (read-only; Get-GateClientImages); none on another
# machine: the byte gate is skipped there.
$imageArguments = @()
foreach ($exe in @(Get-GateClientImages $repo)) {
    $digest = (Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant()
    $imageArguments += @($exe, $digest)
    Write-Output "INFO`texecutable $exe sha256=$digest (read-only)"
}
if ($imageArguments.Count -eq 0) {
    $imageArguments = @('-', '-')
    Write-Output "INFO`tno client executable; registered byte ranges are not checked"
}

# 1. Checker.
$work = ConvertTo-GateLongPath (Join-Path $scratch 'work')
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
    $mirror = Copy-GateSources $repo $scratch @('renovice', 'RENOVICE_TOOLCHAIN\engine_params\verify_engine_params.cpp')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\engine_params\verify_engine_params.cpp'
    $scanner = Join-Path $mirror 'renovice\packages.cpp'
    $literals = Join-Path $mirror 'renovice\live_literals.cpp'
    $runtime = Join-Path $mirror 'renovice\engine_params.cpp'
    $binary = Join-Path $scratch 'verify_engine_params.exe'
    $objects = Join-Path $scratch 'obj'
    New-Item -ItemType Directory -Path $objects -Force | Out-Null
    Push-Location $objects
    try {
        $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /DRENOVICE_PACKAGES_OFFLINE_GATE /Fe:$binary $source $scanner $literals $runtime 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
        $compileExit = $LASTEXITCODE
    }
    finally { Pop-Location }
    $output | Write-Output
    if ($compileExit -ne 0) { throw "ENGINE PARAMS GATE FAIL: checker compilation failed: $compileExit" }
    & $binary $work (ConvertTo-GateLongPath $fixtureDir) @imageArguments
    if ($LASTEXITCODE -ne 0) { throw "ENGINE PARAMS GATE FAIL: checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 2. Source pins.
$runtimeCpp = Read-Lf (Join-Path $repo 'renovice\engine_params.cpp')
$core = Read-Lf (Join-Path $repo 'renovice\engine_params_core.hpp')
$builds = Read-Lf (Join-Path $repo 'renovice\engine_params_builds.hpp')
$packagesCpp = Read-Lf (Join-Path $repo 'renovice\packages.cpp')
$injection = Read-Lf (Join-Path $repo 'renovice\injection.cpp')
$main = Read-Lf (Join-Path $repo 'main.cpp')

$detour = Between $runtimeCpp 'void push_value_detour(' 'const char* install('
Require ((Count $detour 'stock(state, instance, record, index);') -eq 2) 'hook: the stock push is called on the fast path and once on the full path (same four arguments)'
$fast = Index $detour 'if (!armed.load(std::memory_order_acquire))'
$decide = Index $detour 'decide(*build, state, record, index)'
$stockAt = $detour.LastIndexOf('stock(state, instance, record, index);')
$applyAt = Index $detour 'apply_pushed('
Require ($fast -ge 0 -and $fast -lt $decide -and $decide -lt $stockAt -and $stockAt -lt $applyAt) 'hook order: fast gate, decide (pre-push), one stock push, apply_pushed (the pushed number only)'
Require ((Index $detour 'if (!decision.matched) return;') -gt $stockAt) 'hook: no match returns right after the stock push'
foreach ($forbidden in @('lua_', 'getfield', 'setfield', 'check_stack', 'protected_call', 'config::log(', 'report(', 'conout', 'new ', 'malloc', 'shared_ptr', 'std::string', 'std::vector')) {
    Require ((Index $detour $forbidden) -lt 0) "hook: no '$forbidden' in the detour (no Lua API, no operational logging, nothing with a destructor across the stock push)"
}
Require ((Count $runtimeCpp 'static_assert(std::is_trivially_copyable_v<Decision>);') -eq 1 -and (Index $detour 'const Decision decision =') -ge 0) 'hook: the pre-push decision is a trivially copyable value (a DE error longjmp out of the stock push skips no destructor)'
$decideBody = Between $runtimeCpp 'Decision decide(' "`n}`n"
Require ((Index $decideBody 'active_plan.load(') -ge 0 -and (Index $decideBody 'catch (...)') -ge 0) 'decide: the generation-owned plan is loaded per call and released before the stock push'
foreach ($reporter in @('void report_skip(', 'void report_apply(')) {
    $body = Between $runtimeCpp $reporter "`n}`n"
    Require ((Index $body 'if (!diagnostics_on()) return;') -ge 0 -and (Index $body 'if (!diagnostics_on()) return;') -lt (Index $body 'std::ostringstream')) ("Diagnostics=false: " + $reporter + ") returns before any formatting")
}
Require ((Count $runtimeCpp 'config::diagnostic_log(') -eq 5) 'diagnostic lines: 2 apply, 2 skip, 1 module record (each behind diagnostics_on / the mode check)'
$record = Between $runtimeCpp 'void record_module(' "`n#endif`n}"
Require ((Index $record 'if (config::diagnostics_mode() >= config::DiagnosticsMode::battle)') -lt (Index $record 'RENOVICE ENGINE_PARAM MODULE key=')) 'Diagnostics=false: the module record line is formatted only with Diagnostics on'
Require ((Count $runtimeCpp 'push_value_original.store(') -eq 1 -and (Index $runtimeCpp 'push_value_original.store(') -lt (Index $runtimeCpp 'push_value_hook.enable();')) 'install: the trampoline is published before the detour is enabled'
Require ((Index $runtimeCpp 'registration_for_digest(digest)') -lt (Index $runtimeCpp 'admit_image(*build') -and (Index $runtimeCpp 'admit_image(*build') -lt (Index $runtimeCpp 'push_value_hook.create();')) 'install: exact executable digest, then every registered byte range, then the trampoline (fail closed, no fallback)'
$installBody = Between $runtimeCpp 'const char* install(' 'bool any_recipe_present()'
Require ((Index $installBody 'push_value_hook.disable();') -ge 0 -and (Index $installBody 'push_value_hook.destroy();') -ge 0 -and (Index $installBody 'registration.store(nullptr') -ge 0) 'install failure path removes a created hook and publishes no registration'
Require ((Count $core 'memory.write(') -eq 1) 'core: exactly one write, the number slot the stock push created'
Require (($builds -match 'inline constexpr std::array<BuildRegistration, [1-9][0-9]*> registered_builds\{\{') -and (Index $builds 'registered_builds{{' + "`n" + '    {' + "`n" + '        "44.0.2 2026.09.28.13.06",') -ge 0 -and (Count $builds '"0124f0b93516e60ae362c59090809de24a42551143a6adf84963bd2120ab7d33"') -eq 1) 'registration: 44.0.2 first (the A-C model build), each build keyed by its exact executable digests (rows added by the native update tool follow)'

$scan = Between $packagesCpp 'void scan_package(' 'SourceClaims package_claims('
Require ((Count $scan 'engine_params::attach_recipe(package, engine_recipe_path);') -eq 1) 'package scan: engine_params.json is attached (older DLLs ignore the file: no other parser reads it)'
$apply = Between $packagesCpp 'void apply_member_policy_and_settings(' 'bool scan(Snapshot& output'
Require ((Index $apply 'engine_params::resolve_package(package, trigger);') -gt (Index $apply 'member.delivery = settings::member_delivery(')) 'package scan: the plan is resolved from the finished member delivery'
Require ((Index $apply 'engine_params::resolve_package(package, trigger);') -lt (Index $apply 'RENOVICE SETTINGS DELIVERY')) 'package scan: the DELIVERY line reports the delivery after withholding'
Require ((Count $packagesCpp 'if (committing) engine_params::resolve_conflicts(output, trigger);') -eq 1) 'package scan: one owner per (module, parameter) across packages'
Require ((Count $packagesCpp 'engine_params::publish(engine_params::build_snapshot(active_snapshot.get()), "startup");') -eq 1 -and (Count $packagesCpp 'engine_params::prepare(engine_params::build_snapshot(snapshot.get()));') -eq 1 -and (Count $packagesCpp 'engine_params::commit_prepared("F9");') -eq 1 -and (Count $packagesCpp 'engine_params::discard_prepared();') -eq 1) 'generation: plan published at startup, prepared, committed and discarded with the package snapshot'
$create = Between $main 'static SOUP_FORCEINLINE void create_all_hooks()' 'renovice::replacement_settings::commit('
Require ((Index $create '(void)renovice::engine_params::initialise();') -ge 0 -and (Index $create '(void)renovice::engine_params::initialise();') -lt (Index $create 'renovice::packages::initialise()')) 'startup: the hook is installed (or refused) before the first package scan'
Require ((Count $main 'renovice::engine_params::set_executable_digest(executable_sha256_hex);') -eq 1) 'startup: the build gate hands over the executable digest'
$loader = Between $injection 'LoaderDetourOutcome loader_detour_owned(' 'bool loader_detour(void* manager'
Require ((Index $loader 'remember_engine_param_module(') -gt (Index $loader 'invoke_stock_loader_protected(') -and (Index $loader 'if (result && target_boundary.engine_param_module)') -ge 0) 'natural load: identities are recorded after the stock Loader returned, from the stored closure'
$inspect = Between $injection 'TargetLoadBoundary inspect_target_load(' 'void dump_pause_menu_body_once('
Require ((Index $inspect 'engine_params::observing()') -ge 0 -and (Index $inspect 'boundary.engine_param_module = inspect_engine_params') -gt (Index $inspect 'boundary.key = replacements::body_key(')) 'natural load: the stock content key is hashed from the descriptor body before any undump swap'
$refresh = Between $injection 'void remember_refreshed_target_module(' '// END LIVE_LITERALS_TARGET_REFRESH'
Require ((Index $refresh 'remember_engine_param_module(key, state, name_handle);') -ge 0) 'F9 VM-local refresh: the refreshed closure is recorded too'
$remember = Between $injection 'void remember_engine_param_module(' 'void remember_diagnostic_module_identity('
Require ((Index $remember 'setfield') -lt 0 -and (Index $remember 'prototype-root') -lt 0) 'identity: nothing is pinned or written in the registry (read-only lookup)'

foreach ($file in @('renovice\engine_params_core.hpp', 'renovice\engine_params_builds.hpp', 'renovice\engine_params.hpp', 'renovice\engine_params.cpp')) {
    $text = (Read-Lf (Join-Path $repo $file)).ToLowerInvariant()
    $names = @('exterminate', 'interception', 'railjack', 'territory', 'triggeralarm', 'scoregoal', 'metersperenemy', 'defense', 'missions.', 'c05987eccd08c1ca')
    $hits = @($names | Where-Object { $text.Contains($_) })
    Require ($hits.Count -eq 0) "no target names in $file"
}
Write-Output 'ENGINE PARAMS GATES PASS'
