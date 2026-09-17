[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest
$repo=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$vswhere="${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath=(& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
$vsId=(& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
if(-not $vsPath -or -not $vsId){throw 'Missing certified x64 MSVC tools'}
Import-Module (Join-Path $vsPath 'Common7/Tools/Microsoft.VisualStudio.DevShell.dll')
Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
$output=Join-Path $repo 'RENOVICE_TOOLCHAIN/bin/diagnostics'
New-Item -ItemType Directory -Force -Path $output | Out-Null
$binary=Join-Path $output 'verify_native_damage.exe'
$object=Join-Path $output 'verify_native_damage.obj'
& cl /nologo /std:c++20 /W4 /WX /EHsc /O2 /I (Join-Path $repo 'modules/Soup/soup') /I $repo /Fo:$object /Fe:$binary (Join-Path $PSScriptRoot 'verify_native_damage.cpp')
if($LASTEXITCODE){throw 'Native observer harness compilation failed'}
$log=Join-Path $output 'native-observer.actual-capture.log'
& $binary $log
if($LASTEXITCODE){throw "Native observer harness failed: $LASTEXITCODE"}
$json=Join-Path $output 'native-observer.actual-capture.json'
& (Join-Path $repo 'RENOVICE_SCRIPTING/DIAGNOSTICS/AnalyzeCombatBattleLog.ps1') -Quiet -LogPath $log -OutputPath $json
$report=Get-Content -LiteralPath $json -Raw | ConvertFrom-Json
if($report.TransactionCount -ne 2 -or $report.CompleteCount -ne 2 -or
    @($report.Transactions | Where-Object HealthLoss -eq 133).Count -ne 2){throw 'Production native records did not survive analyzer roundtrip'}
Write-Output 'NATIVE OBSERVER ANALYZER PASS two real observer transactions, separate targets, 133 damage each'
