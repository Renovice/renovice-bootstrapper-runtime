$ErrorActionPreference='Stop'
$repo=Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$vswhere="${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath=(& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
Import-Module (Join-Path $vsPath 'Common7\Tools\Microsoft.VisualStudio.DevShell.dll')
Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
$bin=Join-Path $repo 'RENOVICE_TOOLCHAIN\bin\version44'
New-Item -ItemType Directory -Path $bin -Force | Out-Null
# Compile the actual GameString declaration, without unrelated reverse-engineered
# native object layouts that generate offsetof/padding warnings in a standalone TU.
$sourceText=Get-Content (Join-Path $repo 'owf_structs.hpp') -Raw
$start=$sourceText.IndexOf('union GameString')
$end=$sourceText.IndexOf('union LegacyGameString')
if($start -lt 0 -or $end -le $start){throw 'GameString declaration boundaries missing'}
$header="#define SOUP_BITS 64`n#define GV(a,b,c) ((a)*10000+(b)*100+(c))`ninline uint32_t game_version;`n"+$sourceText.Substring($start,$end-$start)
[IO.File]::WriteAllText((Join-Path $bin 'game_string_under_test.hpp'),$header)
$env:PATH="C:\msys64\ucrt64\bin;$env:PATH"
& 'C:\msys64\ucrt64\bin\clang++.exe' -std=c++20 -O2 -Wall -Wextra -Werror -I $bin -o "$bin\verify_game_string.exe" (Join-Path $PSScriptRoot 'verify_game_string.cpp')
if($LASTEXITCODE -ne 0){throw 'GameString verifier build failed'}
& "$bin\verify_game_string.exe"
if($LASTEXITCODE -ne 0){throw 'GameString verifier failed'}
