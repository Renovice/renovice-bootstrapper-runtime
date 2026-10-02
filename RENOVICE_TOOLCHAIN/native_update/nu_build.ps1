# Rebuild step of the native update tool (update resilience, native side).
#
# Prepares the build environment of a bootstrapper worktree and runs the unchanged
# RENOVICE_TOOLCHAIN\build_private.ps1 (every gate + the zero-warning private MSVC
# build), then stages the DLL and the matching Hotfix.owf with SHA256SUMS.txt.
#
#   - NoDefaultCurrentDirectoryInExePath is removed for this process only
#     (archive.php runs `pluto` after chdir("tools")).
#   - <repo>\tools (pluto.exe) and the Visual Studio Installer folder (vswhere.exe)
#     are put on PATH.
#   - Missing submodules are checked out at their pinned commits from the main
#     checkout's modules (local clone, no network); untracked build inputs
#     (soup.lib, Pluto.lib, OpenWF\cert\*) are COPIED from the main checkout when
#     missing. They are ignored by git and never committed.
#   - -ClientExe sets RENOVICE_GATE_CLIENT_EXE, the client image the per-build gates
#     check (default: the installed Warframe.x64.exe), read only.
#
# Never writes the game folder. Output line: NATIVE UPDATE STAGE PASS ... or a thrown error.
param(
    [Parameter(Mandatory = $true)][string]$Repo,
    [Parameter(Mandatory = $true)][string]$Stage,
    [string]$InputsFrom,
    [string]$ClientExe
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Windows PowerShell 5.1 turns a native command's stderr into a terminating error under
# 'Stop' (git prints progress there); run native commands with 'Continue' and judge them
# by their exit code only.
function Invoke-Native([scriptblock]$Command) {
    $saved = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $output = & $Command 2>&1 | ForEach-Object { $_.ToString() } }
    finally { $ErrorActionPreference = $saved }
    return @{ Exit = $LASTEXITCODE; Output = @($output) }
}

$Repo = (Resolve-Path -LiteralPath $Repo).Path
if (-not $InputsFrom) {
    $workspace = $Repo
    while (-not (Test-Path -LiteralPath (Join-Path $workspace 'WORKSPACE.json') -PathType Leaf)) {
        $parent = Split-Path -Parent $workspace
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $workspace) { throw 'NATIVE UPDATE BUILD FAIL: WORKSPACE.json not found' }
        $workspace = $parent
    }
    $ws = Get-Content -LiteralPath (Join-Path $workspace 'WORKSPACE.json') -Raw | ConvertFrom-Json
    $InputsFrom = Join-Path $workspace ([string]$ws.repos.bootstrapper_runtime)
}
$InputsFrom = (Resolve-Path -LiteralPath $InputsFrom).Path
$steam = Join-Path ${env:ProgramFiles(x86)} 'Steam\steamapps\common\Warframe'
foreach ($path in @($Repo, $Stage)) {
    if ([IO.Path]::GetFullPath($path).StartsWith([IO.Path]::GetFullPath($steam), [StringComparison]::OrdinalIgnoreCase)) {
        throw "NATIVE UPDATE BUILD FAIL: refusing to build or stage inside the game folder: $path"
    }
}

# 1. Environment (this process and the build child only).
Remove-Item -LiteralPath 'Env:NoDefaultCurrentDirectoryInExePath' -ErrorAction SilentlyContinue
$installer = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer'
$env:PATH = "$(Join-Path $Repo 'tools');$installer;$env:PATH"
if ($ClientExe) {
    $env:RENOVICE_GATE_CLIENT_EXE = (Resolve-Path -LiteralPath $ClientExe).Path
    Write-Output "NATIVE UPDATE BUILD client image $env:RENOVICE_GATE_CLIENT_EXE"
}

# 2. Submodules at their pinned commits, from the main checkout (no network).
$modules = @(
    @{ Name = 'Pluto'; Path = 'modules/Pluto' },
    @{ Name = 'Soup'; Path = 'modules/Soup' },
    @{ Name = 'ee-notation-parser'; Path = 'modules/ee-notation-parser' },
    @{ Name = 'Translations'; Path = 'modules/owf-translations' },
    @{ Name = 'warframe-cache-tools'; Path = 'modules/warframe-cache-tools' }
)
foreach ($m in $modules) {
    $target = Join-Path $Repo $m.Path
    if (Test-Path -LiteralPath (Join-Path $target '.git')) { continue }
    $source = Join-Path $InputsFrom $m.Path
    if (-not (Test-Path -LiteralPath (Join-Path $source '.git'))) { throw "NATIVE UPDATE BUILD FAIL: submodule source missing: $source" }
    $url = $source.Replace('\', '/')
    $r = Invoke-Native { git -C $Repo -c protocol.file.allow=always -c "submodule.$($m.Name).url=$url" submodule update --init -- $m.Path }
    if ($r.Exit -ne 0) { $r.Output | Write-Output; throw "NATIVE UPDATE BUILD FAIL: submodule $($m.Path) checkout failed" }
    Write-Output "NATIVE UPDATE BUILD submodule $($m.Path) checked out from $source"
}

# 3. Untracked build inputs, copied (never moved, never committed).
foreach ($relative in @('modules\Soup\soup\soup.lib', 'modules\Pluto\src\Pluto.lib', 'OpenWF\cert\cert.pem', 'OpenWF\cert\key.pem')) {
    $to = Join-Path $Repo $relative
    if (Test-Path -LiteralPath $to -PathType Leaf) { continue }
    $from = Join-Path $InputsFrom $relative
    if (-not (Test-Path -LiteralPath $from -PathType Leaf)) { throw "NATIVE UPDATE BUILD FAIL: untracked build input missing in $InputsFrom`: $relative" }
    New-Item -ItemType Directory -Path (Split-Path -Parent $to) -Force | Out-Null
    Copy-Item -LiteralPath $from -Destination $to
    Write-Output "NATIVE UPDATE BUILD copied untracked input $relative"
}
$tracked = @((Invoke-Native { git -C $Repo ls-files -- 'OpenWF/cert' 'modules/Soup/soup/soup.lib' 'modules/Pluto/src/Pluto.lib' }).Output | Where-Object { $_ })
if ($tracked.Count -ne 0) { throw "NATIVE UPDATE BUILD FAIL: an untracked build input is tracked: $($tracked -join ', ')" }

# 4. Build (unchanged build_private.ps1: every gate, then the private MSVC build).
$buildScript = Join-Path $Repo 'RENOVICE_TOOLCHAIN\build_private.ps1'
$saved = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try { & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $buildScript 2>&1 | ForEach-Object { $_.ToString() } }
finally { $ErrorActionPreference = $saved }
if ($LASTEXITCODE -ne 0) { throw "NATIVE UPDATE BUILD FAIL: build_private.ps1 exit $LASTEXITCODE" }

# 5. Stage the DLL and the matching Hotfix.owf.
$dll = Join-Path $Repo 'wtsapi32.dll'
$hotfix = Join-Path $Repo 'Hotfix.owf'
foreach ($file in @($dll, $hotfix)) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "NATIVE UPDATE BUILD FAIL: build output missing: $file" }
}
New-Item -ItemType Directory -Path (Join-Path $Stage 'OpenWF') -Force | Out-Null
Copy-Item -LiteralPath $dll -Destination (Join-Path $Stage 'wtsapi32.dll') -Force
Copy-Item -LiteralPath $hotfix -Destination (Join-Path $Stage 'OpenWF\Hotfix.owf') -Force
$lines = foreach ($relative in @('wtsapi32.dll', 'OpenWF/Hotfix.owf')) {
    $hash = (Get-FileHash -LiteralPath (Join-Path $Stage $relative) -Algorithm SHA256).Hash.ToLowerInvariant()
    "$hash  $relative"
}
[IO.File]::WriteAllText((Join-Path $Stage 'SHA256SUMS.txt'), (($lines -join "`n") + "`n"), [Text.UTF8Encoding]::new($false))
$dllHash = ($lines[0] -split '\s+')[0]
$hotfixHash = ($lines[1] -split '\s+')[0]
$bytes = (Get-Item -LiteralPath (Join-Path $Stage 'wtsapi32.dll')).Length
$commit = ((Invoke-Native { git -C $Repo rev-parse HEAD }).Output -join '').Trim()
Write-Output "NATIVE UPDATE STAGE PASS dll_sha256=$dllHash dll_bytes=$bytes hotfix_sha256=$hotfixHash commit=$commit stage=$Stage"
