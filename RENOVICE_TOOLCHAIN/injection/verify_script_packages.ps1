# Deterministic gates for optional folder script packages (2026-09-29).
# Offline only: compiles the real multi-target fixture with the DE Luau
# toolchain, builds the exact renovice/packages.cpp scanner with stub providers
# and runs it on a temporary CustomScripts tree in the gate scratch folder
# (gate_paths.ps1, long-path safe), then pins the source-level integration and
# the unchanged loose-file lanes. It never reads or writes a game folder.
param(
    # Optional: also admit a real package folder (for example generator output)
    # through the exact loader scanner and print its members.
    [string]$AdmitPackage = ''
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$injectionDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $injectionDir
$repo = Split-Path -Parent $toolchainDir
$deToolchain = [IO.Path]::GetFullPath((Join-Path $repo '..\..\toolchains\de-luau-toolchain\bin'))
. (Join-Path $toolchainDir 'gate_paths.ps1')
$scratch = Get-GateScratch $repo 'script-packages'

function Get-Region([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "SCRIPT PACKAGES GATE FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "SCRIPT PACKAGES GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Index([string]$Text, [string]$Needle) {
    return $Text.IndexOf($Needle, [StringComparison]::Ordinal)
}

# 1. Real DE bytecode fixture (same source as the multi-target gate).
# derecomp.exe reads a short copy (the repository may be deeper than MAX_PATH).
$fixtureSource = Copy-GateInput (Join-Path $injectionDir 'fixtures\MultiTargetFixture.targets.addon.luau') $scratch
$fixture = Join-Path $scratch 'PackageFixture.targets.addon.u44.lua_B'
& (Join-Path $deToolchain 'derecomp.exe') recompile-u44 $fixtureSource $fixture
if ($LASTEXITCODE) { throw 'SCRIPT PACKAGES GATE FAIL: fixture U44 compilation failed' }
& (Join-Path $deToolchain 'derecomp.exe') de-roundtrip $fixture
if ($LASTEXITCODE) { throw 'SCRIPT PACKAGES GATE FAIL: fixture container roundtrip failed' }

# 2. Pure rules + the real scanner end to end.
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
    # cl.exe compiles short copies (the repository may be deeper than MAX_PATH).
    $mirror = Copy-GateSources $repo $scratch @('renovice', 'RENOVICE_TOOLCHAIN\injection\verify_script_packages.cpp')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\injection\verify_script_packages.cpp'
    $scanner = Join-Path $mirror 'renovice\packages.cpp'
    $literals = Join-Path $mirror 'renovice\live_literals.cpp' # LIVE_LITERALS_V1: packages.cpp attaches recipes
    $engineParams = Join-Path $mirror 'renovice\engine_params.cpp' # R16: packages.cpp attaches engine_params.json
    $binary = Join-Path $scratch 'verify_script_packages.exe'
    # Two translation units: compile inside a dedicated object folder so no
    # /Fo directory argument (with a trailing backslash) is needed.
    $objects = Join-Path $scratch 'obj'
    New-Item -ItemType Directory -Path $objects -Force | Out-Null
    Push-Location $objects
    try {
        $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /DRENOVICE_PACKAGES_OFFLINE_GATE /Fe:$binary $source $scanner $literals $engineParams 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
        $compileExit = $LASTEXITCODE
    }
    finally { Pop-Location }
    $output | Write-Output
    if ($compileExit -ne 0) { throw "SCRIPT PACKAGES GATE FAIL: checker compilation failed: $compileExit" }
    if ([string]::IsNullOrWhiteSpace($AdmitPackage)) { & $binary $fixture $work }
    else { & $binary $fixture $work --admit (ConvertTo-GateLongPath $AdmitPackage) }
    if ($LASTEXITCODE -ne 0) { throw "SCRIPT PACKAGES GATE FAIL: checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 3. Source invariants of the loader integration.
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$replacements = [IO.File]::ReadAllText((Join-Path $repo 'renovice\replacements.cpp'))
$scriptControl = [IO.File]::ReadAllText((Join-Path $repo 'renovice\script_control.cpp'))
$packagesSource = [IO.File]::ReadAllText((Join-Path $repo 'renovice\packages.cpp'))
$main = [IO.File]::ReadAllText((Join-Path $repo 'main.cpp'))

foreach ($pair in @(@('injection.cpp', $injection), @('replacements.cpp', $replacements), @('script_control.cpp', $scriptControl), @('packages.cpp', $packagesSource))) {
    Require ((Index $pair[1] 'recursive_directory_iterator') -lt 0) "$($pair[0]) never enumerates recursively, so loose scanners cannot pick up package members"
}

# Loose loops are unchanged: the regular-file, non-recursive enumeration stays.
$scan = Get-Region $injection 'bool scan_snapshot(' 'template <typename Function>' 'Inject scanner'
Require ($scan.Contains('for (std::filesystem::directory_iterator it(directory, ec), end; !ec && it != end; it.increment(ec))') -and $scan.Contains('if (!it->is_regular_file(ec))')) 'loose Inject loop is the unchanged non-recursive regular-file scan'
$appendCall = Index $scan 'append_package_chunks(snapshot, target_keys);'
Require ($appendCall -gt (Index $scan 'report_scan_rejection("RENOVICE Inject scan error: "') -and $appendCall -lt (Index $scan 'std::sort(snapshot.begin(), snapshot.end()')) 'package chunks join after the loose loop and before the deterministic sort'
$append = Get-Region $injection '// BEGIN PACKAGE_INJECT_MEMBERS' '// END PACKAGE_INJECT_MEMBERS' 'package Inject members'
Require ($append.Contains('packages::candidate()')) 'Inject lane consumes the one package snapshot of the transaction'
Require ((Index $append 'target_keys.insert(') -lt (Index $append 'if (!package.accepted')) 'package target keys are inventoried before the accepted/enabled filter (like disabled loose target addons)'
Require ($append.Contains('chunk.multi_target = member.kind == packages::MemberKind::MultiTargetAddon;') -and $append.Contains('chunk.kind = ScriptKind::TargetManagedAddon;')) 'package members enter the ordinary target lane with the ordinary Chunk shape'
Require ((Index $append 'ScriptKind::ManagedAddon') -lt 0 -and (Index $append 'ScriptKind::Ordinary') -lt 0) 'no managed or one-shot chunk is created from a package'

$load = Get-Region $replacements 'bool load_snapshot(' 'std::vector<std::uint64_t> changed_keys(' 'replacement snapshot loader'
Require ($load.Contains('if (!parse_filename_key(path.stem().string(), key))') -and $load.Contains('conout << "RENOVICE replacement rejected: duplicate content key " << path.filename().string() << std::endl;')) 'loose replacement loop and its duplicate-key rule are unchanged'
Require ($load.Contains('return merge_package_replacements(snapshot, available_keys);')) 'package replacements merge after the loose loop'
$merge = Get-Region $replacements 'bool merge_package_replacements(' 'bool load_snapshot(' 'package replacement merge'
Require ((Index $merge 'available_keys->emplace(member.key)') -lt (Index $merge 'if (!package.accepted) continue;')) 'package replacement keys are inventoried even while disabled'
Require ($merge.Contains('packages::candidate()')) 'replacement lane consumes the same package snapshot as the Inject lane'

$drainPrepare = Get-Region $injection 'if (!config::prepare_reload())' 'if (!transaction_valid) discard_prepared();' 'F9 prepare sequence'
$policy = Index $drainPrepare 'script_control::prepare_reload()'
$pkg = Index $drainPrepare 'packages::prepare_reload()'
Require ($policy -ge 0 -and $pkg -gt $policy -and $pkg -lt (Index $drainPrepare 'replacements::prepare_reload()') -and $pkg -lt (Index $drainPrepare 'scan_snapshot(candidate, candidate_target_keys, candidate_optional_bridges)')) 'F9 scans packages once, after the prepared policy and before both consuming lanes'
Require ($drainPrepare.Contains('reject_prepared_member("RENOVICE F9 package reload rejected: previous snapshot retained");')) 'an unreadable Packages root rejects F9 with an exact logged reason'
$discard = Get-Region $injection 'auto discard_prepared = []' '};' 'F9 discard'
Require ($discard.Contains('packages::discard_prepared_reload();')) 'F9 rollback discards the prepared package snapshot'
$commit = Get-Region $injection 'reconcile_native_hook_contract("F9-commit-reconcile");' '};' 'F9 commit'
Require ($commit.Contains('packages::commit_prepared_reload();') -and (Index $commit 'packages::commit_prepared_reload();') -lt (Index $commit 'replacements::commit_prepared_reload();')) 'F9 commit publishes the package snapshot with the replacement map'

$startupPolicy = Index $main 'renovice::script_control::initialise()'
$startupPackages = Index $main 'renovice::packages::initialise()'
Require ($startupPackages -gt $startupPolicy -and $startupPackages -lt (Index $main 'renovice::injection::initialise()') -and $startupPackages -lt (Index $main 'renovice::replacements::initialise(')) 'startup scans packages after the policy and before both consuming lanes'
Require ($main.Contains('RENOVICE script packages failed closed; loose scripts are unaffected.')) 'a startup package failure is local to packages'

Require ($scriptControl.Contains('discover_packages(policy, requested, output);') -and $scriptControl.Contains('packages::inventory()')) 'Scripts menu lists one row per package from the loader rules'
Require ($injection.Contains(': script.label;') -and $injection.Contains('if (script.kind == script_control::Kind::Package)')) 'menu rows use the package label and member tooltip; loose rows are unchanged'
Require ($packagesSource.Contains('scope=package-local generation=continues')) 'package rejection is logged as package-local'

Write-Output "SCRIPT PACKAGES GATES PASS"
