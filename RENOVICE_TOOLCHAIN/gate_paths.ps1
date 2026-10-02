# Long-path-safe locations for the offline gates (2026-09-30). Dot-source it.
#
# The repository can sit arbitrarily deep (worktrees, `git archive` exports
# under work\temp). PowerShell reads such paths, but the native tools do not:
#   - cl.exe cannot open a source file over MAX_PATH (C1083);
#   - CreateProcess rejects a working directory over MAX_PATH
#     ("Program 'cl.exe' failed to run: The directory name is invalid");
#   - derecomp.exe and luau.exe cannot open a long input ("Error opening ...").
# Gates therefore hand native tools short COPIES of their repository inputs and
# write build products to a short scratch folder:
#   Get-GateScratch        %TEMP%\rnvg\<8 hex of the repository path>\<name>,
#                          recreated empty for every run;
#   Copy-GateSources       mirrors repository-relative files and folders under
#                          <scratch>\src with the same relative layout, so
#                          relative #include and require() paths still resolve;
#   ConvertTo-GateLongPath the \\?\ form for C++ checkers: MSVC std::filesystem
#                          creates, copies, iterates and removes trees beyond
#                          260 characters through it (probed 2026-09-30, 541
#                          characters).
# The scratch folder holds only copies and build products. Every gate still
# reads and pins the repository files themselves; nothing in scratch is an
# input of record, and nothing is ever written to a game folder.

function Get-GateScratch {
    param(
        [Parameter(Mandatory = $true)][string]$Repo,
        [Parameter(Mandatory = $true)][string]$Name
    )
    if ($Name -notmatch '^[A-Za-z0-9_.-]{1,32}$') { throw "GATE PATHS FAIL: invalid scratch name: $Name" }
    $identity = [IO.Path]::GetFullPath($Repo).TrimEnd('\').ToLowerInvariant()
    $sha = [Security.Cryptography.SHA256]::Create()
    try { $digest = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($identity)) }
    finally { $sha.Dispose() }
    $tag = ($digest[0..3] | ForEach-Object { $_.ToString('x2') }) -join ''
    $scratch = Join-Path (Join-Path (Join-Path ([IO.Path]::GetTempPath()) 'rnvg') $tag) $Name
    if (Test-Path -LiteralPath $scratch) {
        # Only plain folders are ever created here. Refuse to recurse into a
        # reparse point, so a delete can never follow a link out of scratch.
        $links = @(Get-ChildItem -LiteralPath $scratch -Recurse -Force -Attributes ReparsePoint -ErrorAction Stop)
        if ($links.Count -ne 0) { throw "GATE PATHS FAIL: reparse point inside gate scratch: $($links[0].FullName)" }
        Remove-Item -LiteralPath $scratch -Recurse -Force
    }
    New-Item -ItemType Directory -Path $scratch -Force | Out-Null
    return $scratch
}

# Mirrors each repository-relative path (file or folder) to <Scratch>\src\<path>
# and returns <Scratch>\src.
function Copy-GateSources {
    param(
        [Parameter(Mandatory = $true)][string]$Repo,
        [Parameter(Mandatory = $true)][string]$Scratch,
        [Parameter(Mandatory = $true)][string[]]$Paths
    )
    $mirror = Join-Path $Scratch 'src'
    foreach ($relative in $Paths) {
        $from = Join-Path $Repo $relative
        $to = Join-Path $mirror $relative
        if (Test-Path -LiteralPath $from -PathType Container) {
            New-Item -ItemType Directory -Path $to -Force | Out-Null
            Get-ChildItem -LiteralPath $from -Force | Copy-Item -Destination $to -Recurse -Force
        }
        elseif (Test-Path -LiteralPath $from -PathType Leaf) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $to) -Force | Out-Null
            Copy-Item -LiteralPath $from -Destination $to -Force
        }
        else { throw "GATE PATHS FAIL: gate source missing: $from" }
    }
    return $mirror
}

# Copies one input file into <Scratch>\in and returns the short copy.
function Copy-GateInput {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Scratch
    )
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "GATE PATHS FAIL: gate input missing: $Path" }
    $in = Join-Path $Scratch 'in'
    New-Item -ItemType Directory -Path $in -Force | Out-Null
    $to = Join-Path $in (Split-Path -Leaf $Path)
    if (Test-Path -LiteralPath $to) { throw "GATE PATHS FAIL: duplicate gate input name: $to" }
    Copy-Item -LiteralPath $Path -Destination $to
    return $to
}

# Client executables the per-build gates check (native update, 2026-10-02), read
# only: the client under test (RENOVICE_GATE_CLIENT_EXE when set, else the
# installed Steam Warframe.x64.exe when present) and every reference image the
# native update tool stored (<workspace>\work\native-update\reference\*\
# Warframe.x64.exe, the certified builds before the installed one). A registered
# build stays covered after Steam replaces the installed executable.
function Get-GateClientImages {
    param([Parameter(Mandatory = $true)][string]$Repo)
    $images = [System.Collections.Generic.List[string]]::new()
    $client = if ($env:RENOVICE_GATE_CLIENT_EXE) { $env:RENOVICE_GATE_CLIENT_EXE }
              else { Join-Path ${env:ProgramFiles(x86)} 'Steam\steamapps\common\Warframe\Warframe.x64.exe' }
    if ($env:RENOVICE_GATE_CLIENT_EXE -and -not (Test-Path -LiteralPath $client -PathType Leaf)) {
        throw "GATE PATHS FAIL: RENOVICE_GATE_CLIENT_EXE does not exist: $client"
    }
    if (Test-Path -LiteralPath $client -PathType Leaf) { $images.Add([IO.Path]::GetFullPath($client)) }
    $workspace = [IO.Path]::GetFullPath($Repo)
    while ($workspace -and -not (Test-Path -LiteralPath (Join-Path $workspace 'WORKSPACE.json') -PathType Leaf)) {
        $parent = Split-Path -Parent $workspace
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $workspace) { $workspace = $null; break }
        $workspace = $parent
    }
    if ($workspace) {
        $store = Join-Path $workspace 'work\native-update\reference'
        if (Test-Path -LiteralPath $store -PathType Container) {
            foreach ($exe in @(Get-ChildItem -LiteralPath $store -Directory | Sort-Object Name | ForEach-Object {
                        Join-Path $_.FullName 'Warframe.x64.exe' } | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf })) {
                if (-not $images.Contains($exe)) { $images.Add($exe) }
            }
        }
    }
    # Callers wrap the result in @(): the list is unrolled into plain strings.
    return $images.ToArray()
}

function ConvertTo-GateLongPath {
    param([Parameter(Mandatory = $true)][string]$Path)
    $full = [IO.Path]::GetFullPath($Path)
    # A trailing separator would leave the folder name empty for the checker.
    if ($full.Length -gt 3) { $full = $full.TrimEnd('\') }
    if ($full.StartsWith('\\?\')) { return $full }
    if ($full.StartsWith('\\')) { return '\\?\UNC\' + $full.Substring(2) }
    return '\\?\' + $full
}
