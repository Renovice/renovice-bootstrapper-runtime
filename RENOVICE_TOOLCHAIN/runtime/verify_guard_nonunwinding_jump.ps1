# Gate (2026-10-08): the native fault guard must jump back without unwinding.
# Live: an F9 module refresh faulted inside the stock loader; the guard's CRT std::longjmp unwound the
# noexcept leaves between its setjmp and the fault, std::terminate -> abort -> 0xC0000409 in this DLL.
# Part A (source): the guard buffer is the __builtin jump buffer and every guard setjmp/longjmp is the
#   non-unwinding builtin.
# Part B (toolchain): guard_jump_probe.cpp built with the certified clang for x86_64-pc-windows-msvc at -O3:
#   CRT jump across noexcept frames aborts with 0xC0000409 (the hazard is real on this toolchain), and the
#   builtin jump recovers across the same noexcept frames (and across ordinary frames).
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp')).Replace("`r`n", "`n")

function Require([bool]$ok, [string]$what) {
    if (-not $ok) { throw "GUARD NONUNWINDING JUMP FAIL: $what" }
}

# Part A
Require ($injection.Contains("struct GuardState`n{") -and $injection.Contains('void* jump[5]{};')) 'guard jump buffer is void* jump[5]'
Require (-not $injection.Contains('std::jmp_buf jump;')) 'no CRT jmp_buf in the guard'
Require (-not $injection.Contains('std::longjmp(guard.jump')) 'no CRT std::longjmp(guard.jump'
Require ($injection.Contains('__builtin_longjmp(guard.jump, 1);')) 'fault handler uses __builtin_longjmp'
$plain = [regex]::Matches($injection, '(?<!__builtin_)setjmp\(guard\.jump\)').Count
$builtin = [regex]::Matches($injection, '__builtin_setjmp\(guard\.jump\)').Count
Require ($plain -eq 0) "no CRT setjmp(guard.jump) (found $plain)"
Require ($builtin -ge 3) "three guard sites use __builtin_setjmp (found $builtin)"

# Part B (the VS developer environment is restored afterwards: build_private.ps1 runs every gate in one
# session, and an accumulated PATH breaks the later archive step with "The input line is too long")
$savedEnvironment = @{}
Get-ChildItem Env: | ForEach-Object { $savedEnvironment[$_.Name] = $_.Value }
try {
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath = (& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
Import-Module (Join-Path $vsPath 'Common7\Tools\Microsoft.VisualStudio.DevShell.dll')
Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
$env:PATH = "C:\msys64\ucrt64\bin;$env:PATH"
$clang = 'C:\msys64\ucrt64\bin\clang++.exe'
Require ((& $clang --version | Select-Object -First 1) -match '20\.1\.8') 'certified clang 20.1.8'
$bin = Join-Path $repo 'RENOVICE_TOOLCHAIN\bin\runtime'
New-Item -ItemType Directory -Path $bin -Force | Out-Null
$source = Join-Path $PSScriptRoot 'guard_jump_probe.cpp'

function Run-Probe([int]$builtin, [int]$middleNoexcept) {
    $exe = Join-Path $bin "guard_jump_probe_b${builtin}_n${middleNoexcept}.exe"
    $out = Join-Path $bin "guard_jump_probe_b${builtin}_n${middleNoexcept}.txt"
    & $clang --target=x86_64-pc-windows-msvc -std=c++20 -O3 -fuse-ld=lld "-DBUILTIN_JUMP=$builtin" "-DMIDDLE_NOEXCEPT=$middleNoexcept" -o $exe $source
    if ($LASTEXITCODE -ne 0) { throw "GUARD NONUNWINDING JUMP FAIL: probe build b=$builtin n=$middleNoexcept" }
    $process = Start-Process -FilePath $exe -NoNewWindow -Wait -PassThru -RedirectStandardOutput $out
    $text = (Get-Content $out -Raw)
    if ($null -eq $text) { $text = '' }
    return [pscustomobject]@{ Exit = ('0x{0:X8}' -f $process.ExitCode); Recovered = $text.Contains('RECOVERED') }
}

$hazard = Run-Probe 0 1
Require ($hazard.Exit -eq '0xC0000409' -and -not $hazard.Recovered) "CRT jump across noexcept aborts (got $($hazard.Exit))"
$crtPlain = Run-Probe 0 0
Require ($crtPlain.Exit -eq '0x00000000' -and $crtPlain.Recovered) "CRT jump across ordinary frames recovers (got $($crtPlain.Exit))"
$fixed = Run-Probe 1 1
Require ($fixed.Exit -eq '0x00000000' -and $fixed.Recovered) "builtin jump across noexcept recovers (got $($fixed.Exit))"
$fixedPlain = Run-Probe 1 0
Require ($fixedPlain.Exit -eq '0x00000000' -and $fixedPlain.Recovered) "builtin jump across ordinary frames recovers (got $($fixedPlain.Exit))"

} finally {
    foreach ($name in @(Get-ChildItem Env: | ForEach-Object { $_.Name })) {
        if (-not $savedEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" -ErrorAction SilentlyContinue }
    }
    foreach ($entry in $savedEnvironment.GetEnumerator()) { Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value }
}

Write-Output "GUARD NONUNWINDING JUMP PASS source_sites=$builtin crt_noexcept=$($hazard.Exit) builtin_noexcept=$($fixed.Exit)"
