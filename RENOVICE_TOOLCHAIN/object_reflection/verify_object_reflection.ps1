# OBJECT_REFLECTION_V1 gates (RENOVICE.object, 2026-10-31).
#   1. MSVC /W4 /WX checker of the pure core (renovice/object_reflection_core.hpp): engine
#      field-name normalisation, value-to-text, top-level text parser, change diff, probe
#      call association, and the per-build resolver run on every client image
#      (Get-GateClientImages: installed client + native-update reference images, READ ONLY).
#   2. Independent exe-structural gate (verify_object_reflection_exe.py, capstone) per image:
#      re-finds the metadata reader chain and writer sequence, checks the normaliser rule and
#      decodes NpcAiDirector fields without an address (HardMaxAICap int, SpawnTimer float...).
#   3. Source pins: resolution before the Metadata Patches hook, publication before the
#      generation's members run, capability-local failure, no new setjmp site, no code patching.
# Nothing is written to a game or server folder.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$gateDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $gateDir
$repo = Split-Path -Parent $toolchainDir
. (Join-Path $toolchainDir 'gate_paths.ps1')
$scratch = Get-GateScratch $repo 'object-reflection'

function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "OBJECT REFLECTION GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Read-Lf([string]$Path) { return [IO.File]::ReadAllText($Path).Replace("`r`n", "`n") }
function Index([string]$Text, [string]$Needle) { return $Text.IndexOf($Needle, [StringComparison]::Ordinal) }
function Count([string]$Text, [string]$Needle) { return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }
function Between([string]$Text, [string]$Start, [string]$End) {
    $from = Index $Text $Start
    if ($from -lt 0) { throw "OBJECT REFLECTION GATE FAIL: source anchor not found: $Start" }
    $to = $Text.IndexOf($End, $from + $Start.Length, [StringComparison]::Ordinal)
    if ($to -lt 0) { throw "OBJECT REFLECTION GATE FAIL: source anchor not found: $End" }
    return $Text.Substring($from, $to - $from)
}

$images = @(Get-GateClientImages $repo)
foreach ($exe in $images) {
    Write-Output "INFO`texecutable $exe sha256=$((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant()) (read-only)"
}
if ($images.Count -eq 0) { Write-Output "INFO`tno client executable; the resolver and exe gates are not run" }

# 1. Core checker.
$originalEnvironment = @{}
foreach ($entry in Get-ChildItem Env:) { $originalEnvironment[$entry.Name] = $entry.Value }
$resolvedLines = @()
try {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
    $vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
    if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) { throw "Visual Studio 2022 x64 C++ tools were not found" }
    Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
    Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
    $mirror = Copy-GateSources $repo $scratch @('renovice\object_reflection_core.hpp', 'RENOVICE_TOOLCHAIN\object_reflection\verify_object_reflection_core.cpp')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\object_reflection\verify_object_reflection_core.cpp'
    $binary = Join-Path $scratch 'verify_object_reflection_core.exe'
    $objects = Join-Path $scratch 'obj'
    New-Item -ItemType Directory -Path $objects -Force | Out-Null
    Push-Location $objects
    try {
        $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
        $compileExit = $LASTEXITCODE
    }
    finally { Pop-Location }
    $output | Write-Output
    if ($compileExit -ne 0) { throw "OBJECT REFLECTION GATE FAIL: checker compilation failed: $compileExit" }
    $run = @(& $binary @images 2>&1 | ForEach-Object { $_.ToString() })
    $runExit = $LASTEXITCODE
    $run | Write-Output
    if ($runExit -ne 0) { throw "OBJECT REFLECTION GATE FAIL: core checker failed: $runExit" }
    $resolvedLines = @($run | Where-Object { $_.StartsWith('RESOLVED ') })
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}
Require ($resolvedLines.Count -eq $images.Count) "resolver: every client image resolved ($($resolvedLines.Count)/$($images.Count))"

# 2. Independent exe-structural gate.
if ($images.Count -ne 0) {
    # The build shell puts MSYS2 first on PATH; pick the first interpreter that has capstone and pefile.
    $python = $null
    foreach ($candidate in @(Get-Command python, py, python3 -All -ErrorAction SilentlyContinue)) {
        $savedEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try { & $candidate.Source -c "import capstone, pefile" 2>&1 | Out-Null } finally { $ErrorActionPreference = $savedEap }
        if ($LASTEXITCODE -eq 0) { $python = $candidate; break }
    }
    Require ($null -ne $python) 'python with capstone and pefile available for the exe-structural gate'
    Write-Output "INFO`tpython $($python.Source)"
    $script = Join-Path $gateDir 'verify_object_reflection_exe.py'
    for ($i = 0; $i -lt $images.Count; $i++) {
        $line = $resolvedLines | Where-Object { $_.EndsWith(" image=$($images[$i])") } | Select-Object -First 1
        Require ($null -ne $line) "resolver line for $($images[$i])"
        $savedEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try { $exeOutput = @(& $python.Source $script $images[$i] $line 2>&1 | ForEach-Object { $_.ToString() }) }
        finally { $ErrorActionPreference = $savedEap }
        $exeExit = $LASTEXITCODE
        $exeOutput | Write-Output
        Require ($exeExit -eq 0) "exe-structural gate PASS for $($images[$i])"
    }
}

# 3. Source pins.
$main = Read-Lf (Join-Path $repo 'main.cpp')
$injection = Read-Lf (Join-Path $repo 'renovice\injection.cpp')
$runtime = Read-Lf (Join-Path $repo 'renovice\object_reflection.cpp')
$core = Read-Lf (Join-Path $repo 'renovice\object_reflection_core.hpp')

$create = Between $main 'static SOUP_FORCEINLINE void create_all_hooks()' 'object_type_serialise_propery_text_hook.create();'
$init = Index $create 'renovice::object_reflection::initialise();'
Require ($init -ge 0 -and $init -lt (Index $create 'SIG_INST("41 B1 03 48 8D 55 ? 45 33 C0 48 8D 8D ? ? ? ? E8");')) 'startup: resolved before the Metadata Patches hook rewrites the text-load call'
Require ((Count $main 'renovice::object_reflection::initialise();') -eq 1) 'startup: resolved exactly once'
Require ((Index $core 'inline constexpr const char* metadata_site_pattern =') -ge 0 -and (Index $core '"41 B1 03 48 8D 55 ? 45 33 C0 48 8D 8D ? ? ? ? E8"') -ge 0) 'resolver: anchored on the Metadata Patches signature (no RVA)'

$generation = Between $injection 'bool apply_generation(' 'reconcile_optional_bridges_locked(state, optional_bridges);'
$publish = Index $generation 'publish_object_api(state);'
Require ($publish -ge 0 -and $publish -lt (Index $generation 'unchanged_managed_generation_can_reuse_roots(') -and $publish -gt (Index $generation 'inspect_lua_mutation_boundary(state)')) 'publication: after the mutation-boundary check, before any generation member runs'
$publishBody = Between $injection 'void publish_object_api(luau_State* state)' '// END OBJECT_REFLECTION_LUA_API'
Require ((Index $publishBody 'return false') -lt 0 -and (Index $publishBody 'subsystem_enabled') -lt 0 -and (Index $publishBody 'scope=capability-local generation=continues') -ge 0) 'publication failure is capability-local (never rolls back or disables the generation)'
$leaf = Between $injection 'void object_api_publish_leaf(' '// END OBJECT_API_PUBLISH_PROTECTED_LEAF'
Require ((Index $leaf 'shared_field_collision') -ge 0 -and (Index $leaf 'same_lua_value(existing, rooted)') -ge 0) 'publication: a foreign _T.RENOVICE is never overwritten'
Require ((Index $leaf 'setfield(state, -10000, object_api_registry_key);') -ge 0) 'publication: the API table is rooted in the DE VM registry'
$push = Between $injection 'int object_api_push(luau_State* state) noexcept' 'int object_api_dispatch('
foreach ($forbidden in @('std::string ', 'std::ostringstream', 'std::vector<', 'config::', 'object_reflection::fields', 'object_reflection::set(')) {
    Require ((Index $push $forbidden) -lt 0) "push phase: no '$forbidden' (destructor-free while Lua may longjmp)"
}
$compute = Between $injection 'void object_api_compute(' 'int object_api_push('
Require ((Index $compute 'captured_owner_thread.load') -ge 0 -and (Index $compute 'readable_engine_object(state->intop[0])') -ge 0) 'calls: owner thread and a genuine engine-object userdata are required'
Require ((Index $compute 'object_reflection::available()') -lt (Index $compute 'captured_owner_thread.load')) 'calls: an unavailable provider returns its exact reason first'
foreach ($forbidden in @('__builtin_setjmp', 'VirtualProtect', 'WriteProcessMemory', 'DetourHook', 'CallsiteHook', 'Pluto', 'pluto')) {
    Require ((Index $runtime $forbidden) -lt 0 -and (Index $core $forbidden) -lt 0) "provider: no '$forbidden' (no new guard site, no code patching, DE VM only)"
}
Require ((Index ($runtime + $core) '0x1409') -lt 0 -and (Index ($runtime + $core) '0x1415a1e50') -lt 0) 'provider: no build addresses in source (all functions resolved per build)'
$armed = Between $runtime 'active_probe = probe;' 'const std::uint8_t error_flag'
Require ((Index $armed 'reinterpret_cast<ApplyArchive>(resolved.apply)(object, writer, true);') -ge 0 -and (Index $armed 'std::memcpy(writer, &engine_vtable, 8);') -gt (Index $armed 'reinterpret_cast<ApplyArchive>(resolved.apply)(object, writer, true);') -and (Index $armed 'std::memcpy(writer, &engine_vtable, 8);') -lt (Index $armed 'reinterpret_cast<ArchiveStep>(resolved.writer_end)(writer);')) 'probe: the recording vtable lives on our writer only between ApplyArchive and end'
foreach ($forbidden in @('mallet', 'icewave', 'aidirector', 'npcaidirector', 'hardmaxaicap')) {
    Require ((Index ($runtime + $core).ToLowerInvariant() $forbidden) -lt 0) "provider: no target name '$forbidden' (universal primitive)"
}
Write-Output 'OBJECT REFLECTION GATES PASS'
