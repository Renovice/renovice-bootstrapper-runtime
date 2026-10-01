param(
    # Phase 0 in-game settings editor UI probe: builds the clearly labelled
    # diagnostic DLL (RENOVICE_SETTINGS_PROBE_P0) from _renovice_private_msvc_probe.sun.
    [switch]$SettingsProbeP0
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent $PSScriptRoot
& (Join-Path $PSScriptRoot "bootstrap_tools.ps1")
& (Join-Path $repo "RENOVICE_MIGRATION\verify_dependencies.ps1")
& (Join-Path $repo "RENOVICE_MIGRATION\verify_manifest.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\version44\verify_game_string.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\injection\build_callback_runtime.ps1") -VerifyOnly
& (Join-Path $repo "RENOVICE_TOOLCHAIN\injection\build_automatic_damage_runtime.ps1") -VerifyOnly
& (Join-Path $repo "RENOVICE_TOOLCHAIN\scripts_ui\verify_scripts_ui_bridge.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\scripts_ui\verify_scripts_ui_core.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\scripts_ui\verify_script_settings_bridges.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\scripts_ui\verify_script_settings_render.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\injection\verify_injection_core.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\config\verify_config_core.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\riven\verify_riven_core.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\diagnostics\verify_native_damage.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\diagnostics\verify_engine_damage_codec.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\injection\verify_multi_target_addon.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\injection\verify_lua_call_retirement.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\injection\verify_lua_call_environment.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_lua_call_raw_protection.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\injection\verify_script_packages.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\settings\verify_addon_settings.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\replacements\verify_replacement_settings.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\replacements\verify_live_literals.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\engine_params\verify_engine_params.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_target_root_binding.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_safe_runtime_tick.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_detour_relocatability.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_openwf_game_vm_bridge.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_unified_diagnostics_master.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_generation_ownership.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_stock_longjmp_boundaries.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_shared_callback_raw_protection.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_ui_vm_raw_protection.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_stock_loader_protection.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_addon_lifecycle_raw_protection.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_deferred_registry_release.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_hotkey_latching.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_de_vm_authority.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_protected_game_vm_operations.ps1")
& (Join-Path $repo "RENOVICE_TOOLCHAIN\runtime\verify_openwf_bridge_bounds.ps1")

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path -LiteralPath $vswhere)) {
    throw "Visual Studio vswhere.exe was not found"
}
$vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
$vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
    throw "Visual Studio 2022 with x64 C++ tools was not found"
}
Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null

$sunExe = Join-Path $PSScriptRoot "bin\Sun-0.5.0\Sun.exe"
$phpExe = Join-Path $PSScriptRoot "bin\PHP-8.0.30\php.exe"
$env:PATH = "C:\msys64\ucrt64\bin;$(Split-Path -Parent $phpExe);$(Split-Path -Parent $sunExe);$env:PATH"

foreach ($tool in @("clang", "llvm-ar", "lld-link", "cl", "dumpbin")) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        throw "Required build tool is missing: $tool"
    }
}
if ((clang --version | Select-Object -First 1) -notmatch "20\.1\.8") {
    throw "Certified Clang 20.1.8 is not active"
}

$evidence = Join-Path $repo "RENOVICE_MIGRATION\evidence"
New-Item -ItemType Directory -Path $evidence -Force | Out-Null
$archiveLog = Join-Path $evidence "private_archive_output.txt"
$buildLog = Join-Path $evidence "private_msvc_build_output.txt"

Push-Location $repo
try {
	# Sun 0.5.0's incremental cache does not track C/C++ header dependencies.
	# A header-only change can therefore pass the standalone unit tests while the
	# linked DLL silently reuses an older owning .obj. Private release builds are
	# correctness artifacts, so invalidate only this repo's explicit `int` cache.
	$resolvedRepo = (Resolve-Path -LiteralPath $repo).Path
	$intermediate = Join-Path $resolvedRepo 'int'
	if (Test-Path -LiteralPath $intermediate -PathType Container) {
		$resolvedIntermediate = (Resolve-Path -LiteralPath $intermediate).Path
		if ((Split-Path -Parent $resolvedIntermediate) -ne $resolvedRepo -or
			(Split-Path -Leaf $resolvedIntermediate) -ne 'int') {
			throw "Refusing to clean unexpected intermediate path: $resolvedIntermediate"
		}
		Remove-Item -LiteralPath $resolvedIntermediate -Recurse -Force
		Write-Output "PRIVATE BUILD CACHE CLEAN PASS path=$resolvedIntermediate"
	}

    $archiveOutput = @(& $phpExe archive.php 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $archiveExitCode = $LASTEXITCODE
    [System.IO.File]::WriteAllText(
        $archiveLog,
        (($archiveOutput -join "`n") + "`n"),
        [System.Text.UTF8Encoding]::new($false))
    if ($archiveExitCode -ne 0) {
        throw "Archive generation failed: $archiveExitCode"
    }
    $archiveOutput | Write-Output

    $sunProject = if ($SettingsProbeP0) { "_renovice_private_msvc_probe" } else { "_renovice_private_msvc" }
    Write-Output "PRIVATE BUILD PROJECT $sunProject"
    $buildOutput = @(& $sunExe $sunProject 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $buildExitCode = $LASTEXITCODE
    [System.IO.File]::WriteAllText(
        $buildLog,
        (($buildOutput -join "`n") + "`n"),
        [System.Text.UTF8Encoding]::new($false))
    if ($buildExitCode -ne 0) {
        throw "Private build failed: $buildExitCode"
    }
    $buildOutput | Write-Output
}
finally {
    Pop-Location
}

$patterns = "(?i)(^|\s)(warning|deprecated|error|fatal):|failed to find program|errors? generated"
$gitEolNoticePattern = "(?i)^warning: in the working copy of '.+', (LF will be replaced by CRLF|CRLF will be replaced by LF) the next time Git touches it$"
$archiveMatches = @(Select-String -LiteralPath $archiveLog -Pattern $patterns -CaseSensitive:$false)
$archiveGitEolNotices = @($archiveMatches | Where-Object { $_.Line -match $gitEolNoticePattern })
$archiveIssues = @($archiveMatches | Where-Object { $_.Line -notmatch $gitEolNoticePattern })
$buildMatches = @(Select-String -LiteralPath $buildLog -Pattern $patterns -CaseSensitive:$false)
$buildGitEolNotices = @($buildMatches | Where-Object { $_.Line -match $gitEolNoticePattern })
$buildIssues = @($buildMatches | Where-Object { $_.Line -notmatch $gitEolNoticePattern })
$gitEolNoticeCount = $archiveGitEolNotices.Count + $buildGitEolNotices.Count
if ($gitEolNoticeCount -ne 0) {
    Write-Host "GIT EOL NOTICE count=$gitEolNoticeCount archive=$($archiveGitEolNotices.Count) build=$($buildGitEolNotices.Count) retained_in_evidence=yes fatal=no"
}
if ($archiveIssues.Count -ne 0 -or $buildIssues.Count -ne 0) {
    $archiveIssues | ForEach-Object { Write-Error $_.Line }
    $buildIssues | ForEach-Object { Write-Error $_.Line }
    throw "Build output issue gate failed: archive=$($archiveIssues.Count) build=$($buildIssues.Count)"
}

$dll = Join-Path $repo "wtsapi32.dll"
if (-not (Test-Path -LiteralPath $dll)) {
    throw "Expected wtsapi32.dll was not produced"
}
$headers = @(dumpbin /headers $dll 2>&1)
$dependents = @(dumpbin /dependents $dll 2>&1)
if (-not ($headers -match "8664 machine \(x64\)")) {
    throw "Output DLL is not x64"
}
if ($dependents -match "wtsapi32_owf\.dll") {
    throw "Output unexpectedly imports the legacy companion DLL"
}

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $dll).Hash.ToLowerInvariant()
$size = (Get-Item -LiteralPath $dll).Length
$flavor = if ($SettingsProbeP0) { "settings-probe-p0-DIAGNOSTIC" } else { "main" }
Write-Host "PRIVATE BUILD PASS flavor=$flavor warnings=0 errors=0 x64=yes companion_import=no bytes=$size sha256=$hash"
