[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest
$toolchain=Split-Path -Parent $PSScriptRoot
$repo=Split-Path -Parent $toolchain
. (Join-Path $toolchain 'gate_paths.ps1')
# cl.exe compiles short copies in the gate scratch folder (the repository may be deeper than MAX_PATH).
$output=Get-GateScratch $repo 'native-damage'
$mirror=Copy-GateSources $repo $output @('renovice','RENOVICE_TOOLCHAIN\diagnostics\verify_native_damage.cpp')
$source=Join-Path $mirror 'RENOVICE_TOOLCHAIN\diagnostics\verify_native_damage.cpp'
$originalEnvironment=@{}
foreach($entry in Get-ChildItem Env:){$originalEnvironment[$entry.Name]=$entry.Value}
try {
    $vswhere="${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath=(& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
    $vsId=(& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
    if(-not $vsPath -or -not $vsId){throw 'Missing certified x64 MSVC tools'}
    Import-Module (Join-Path $vsPath 'Common7/Tools/Microsoft.VisualStudio.DevShell.dll')
    Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
    $binary=Join-Path $output 'verify_native_damage.exe'
    $object=Join-Path $output 'verify_native_damage.obj'
    & cl /nologo /std:c++20 /W4 /WX /EHsc /O2 /Fo:$object /Fe:$binary $source
    if($LASTEXITCODE){throw 'Native observer harness compilation failed'}
    $log=Join-Path $output 'native-observer.actual-capture.log'
    & $binary $log
    if($LASTEXITCODE){throw "Native observer harness failed: $LASTEXITCODE"}
}
finally {
    foreach($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)){
        if(-not $originalEnvironment.ContainsKey($name)){Remove-Item -LiteralPath "Env:$name"}
    }
    foreach($entry in $originalEnvironment.GetEnumerator()){Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value}
}
$json=Join-Path $output 'native-observer.actual-capture.json'
& (Join-Path $repo 'RENOVICE_SCRIPTING/DIAGNOSTICS/AnalyzeCombatBattleLog.ps1') -Quiet -LogPath $log -OutputPath $json
$report=Get-Content -LiteralPath $json -Raw | ConvertFrom-Json
if($report.TransactionCount -ne 2 -or $report.CompleteCount -ne 2 -or
    @($report.Transactions | Where-Object { $_.HealthLoss -eq 133 -and $_.OverguardLoss -eq 40 -and $_.VisiblePoolLoss -eq 173 -and $_.ObservedRaw -eq 502.5 -and $_.DecodeLayout -eq '44.0.2 2026.09.28.13.06' }).Count -ne 2){
    throw 'Production native records did not survive analyzer roundtrip'
}
Write-Output 'NATIVE OBSERVER ANALYZER PASS two real 44.0.2 observer transactions, separate targets, 133 HP + 40 Overguard, raw 502.5'
