param(
    [switch]$InstallLlvm
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent $PSScriptRoot
$downloads = Join-Path $PSScriptRoot "downloads"
$bin = Join-Path $PSScriptRoot "bin"
New-Item -ItemType Directory -Path $downloads -Force | Out-Null
New-Item -ItemType Directory -Path $bin -Force | Out-Null

function Ensure-Archive {
    param(
        [string]$Url,
        [string]$Path,
        [string]$Sha256
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        Invoke-WebRequest -Uri $Url -OutFile $Path
    }
    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
    if ($actual -ne $Sha256) {
        throw "Archive hash mismatch: $Path expected=$Sha256 actual=$actual"
    }
}

$sunZip = Join-Path $downloads "Sun-0.5.0-Windows.X64.zip"
Ensure-Archive `
    -Url "https://github.com/calamity-inc/Sun/releases/download/0.5.0/Windows.X64.zip" `
    -Path $sunZip `
    -Sha256 "3c2c83ed03e3bb3eeebeb39d556e7e5a258815c998f740c85af7ecb5600f083e"
$sunDir = Join-Path $bin "Sun-0.5.0"
$sunExe = Join-Path $sunDir "Sun.exe"
if (-not (Test-Path -LiteralPath $sunExe)) {
    New-Item -ItemType Directory -Path $sunDir -Force | Out-Null
    Expand-Archive -LiteralPath $sunZip -DestinationPath $sunDir -Force
}
if ((Get-FileHash -Algorithm SHA256 -LiteralPath $sunExe).Hash.ToLowerInvariant() -ne
    "79e2178af1b27f3daa09909a5776920db82715ca1f1c32b11457363ccbdb8b00") {
    throw "Sun.exe hash mismatch"
}

$phpZip = Join-Path $downloads "php-8.0.30-nts-Win32-vs16-x64.zip"
Ensure-Archive `
    -Url "https://windows.php.net/downloads/releases/archives/php-8.0.30-nts-Win32-vs16-x64.zip" `
    -Path $phpZip `
    -Sha256 "dfb70498ffa2c617f2f655a155564697e3c9cca41709938fd1a5997d1d5b0785"
$phpDir = Join-Path $bin "PHP-8.0.30"
$phpExe = Join-Path $phpDir "php.exe"
if (-not (Test-Path -LiteralPath $phpExe)) {
    New-Item -ItemType Directory -Path $phpDir -Force | Out-Null
    Expand-Archive -LiteralPath $phpZip -DestinationPath $phpDir -Force
}
if ((Get-FileHash -Algorithm SHA256 -LiteralPath $phpExe).Hash.ToLowerInvariant() -ne
    "5f545f6578a3c9b094b5f0b3b9deb96941d4db21358b37acd673a1245eb15801") {
    throw "php.exe hash mismatch"
}

$bash = "C:\msys64\usr\bin\bash.exe"
if (-not (Test-Path -LiteralPath $bash)) {
    throw "MSYS2 is required at C:\msys64"
}
if ($InstallLlvm) {
    & $bash -lc "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-clang mingw-w64-ucrt-x86_64-lld mingw-w64-ucrt-x86_64-llvm"
    if ($LASTEXITCODE -ne 0) {
        throw "MSYS2 LLVM installation failed: $LASTEXITCODE"
    }
}

$requiredPackages = @(
    "mingw-w64-ucrt-x86_64-clang 20.1.8-2",
    "mingw-w64-ucrt-x86_64-clang-libs 20.1.8-2",
    "mingw-w64-ucrt-x86_64-llvm 20.1.8-2",
    "mingw-w64-ucrt-x86_64-llvm-libs 20.1.8-2",
    "mingw-w64-ucrt-x86_64-llvm-tools 20.1.8-2",
    "mingw-w64-ucrt-x86_64-lld 20.1.8-2"
)
$installed = @(& $bash -lc "pacman -Q mingw-w64-ucrt-x86_64-clang mingw-w64-ucrt-x86_64-clang-libs mingw-w64-ucrt-x86_64-llvm mingw-w64-ucrt-x86_64-llvm-libs mingw-w64-ucrt-x86_64-llvm-tools mingw-w64-ucrt-x86_64-lld" 2>$null)
foreach ($package in $requiredPackages) {
    if ($installed -notcontains $package) {
        throw "Required certified package missing or version changed: $package. Run this script with -InstallLlvm."
    }
}

Write-Host "TOOLCHAIN PASS Sun=0.5.0 PHP=8.0.30 LLVM=20.1.8-2"
