[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repo = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$toolchain = [IO.Path]::GetFullPath((Join-Path $repo '..\..\toolchains\de-luau-toolchain\bin'))
$compiler = Join-Path $toolchain 'derecomp.exe'
$source = Join-Path $repo 'RENOVICE_SCRIPTING\TEMPLATES\TargetActivateAbilityHook.target.addon.luau'
$generated = Join-Path $PSScriptRoot 'generated'
$first = Join-Path $generated 'TargetActivateAbilityHook.template.first.lua_B'
$second = Join-Path $generated 'TargetActivateAbilityHook.template.second.lua_B'

New-Item -ItemType Directory -Path $generated -Force | Out-Null

& $compiler recompile $source $first
if ($LASTEXITCODE -ne 0) { throw 'First target export-hook compilation failed.' }
& $compiler recompile $source $second
if ($LASTEXITCODE -ne 0) { throw 'Second target export-hook compilation failed.' }

$firstHash = (Get-FileHash -LiteralPath $first -Algorithm SHA256).Hash
$secondHash = (Get-FileHash -LiteralPath $second -Algorithm SHA256).Hash
if ($firstHash -cne $secondHash) {
    throw "Target export-hook compilation is nondeterministic: $firstHash / $secondHash"
}

foreach ($mode in @('de-roundtrip', 'plan-verify', 'semantic-ir-verify')) {
    & $compiler $mode $first
    if ($LASTEXITCODE -ne 0) { throw "Target export-hook $mode failed." }
}

# This existing fixture executes the same direct-Lua
# finish(original(...)) composition with varargs, nil returns, coroutine yield,
# reassignment, isolation, and stock-error propagation.
& (Join-Path $toolchain 'luau.exe') (Join-Path $PSScriptRoot 'verify_callback_runtime.luau')
if ($LASTEXITCODE -ne 0) { throw 'Direct Lua wrapper semantic fixture failed.' }

$text = [IO.File]::ReadAllText($source)
foreach ($required in @(
    'originalActivateAbility = ActivateAbility',
    'ActivateAbility = wrappedActivateAbility',
    'if ActivateAbility ~= wrappedActivateAbility then',
    'ActivateAbility = originalActivateAbility',
    'return finishActivateAbility(originalActivateAbility(...))'
)) {
    if ($text.IndexOf($required, [StringComparison]::Ordinal) -lt 0) {
        throw "Target export-hook source is missing required ownership marker: $required"
    }
}

# Execute the template's exact function bodies in one standalone Luau chunk.
# Only the terminal module return is rebound to a local so the harness can call
# the lifecycle table directly.
$normalized = $text.Replace("`r`n", "`n")
$returnPattern = 'return \{\n    activate = activate,\n    cleanup = cleanup,\n\}\n?$'
$testable = [regex]::Replace(
    $normalized,
    $returnPattern,
    "local lifecycle = {`n    activate = activate,`n    cleanup = cleanup,`n}`n"
)
if ($testable -ceq $normalized) {
    throw 'Target export-hook lifecycle return could not be isolated for execution.'
}
$prelude = @'
_T = {}
local original = function(first, second)
    coroutine.yield("stock-paused")
    return first + second, nil, "stock-result", nil
end
ActivateAbility = original
'@
$tests = @'
local firstWrapper = nil
lifecycle.activate()
firstWrapper = ActivateAbility
assert(firstWrapper ~= original)
lifecycle.activate()
assert(ActivateAbility == firstWrapper)

local thread = coroutine.create(ActivateAbility)
local paused = table.pack(coroutine.resume(thread, 2, 3))
assert(paused.n == 2 and paused[1] == true and paused[2] == "stock-paused")
local completed = table.pack(coroutine.resume(thread))
assert(completed.n == 5 and completed[1] == true)
assert(completed[2] == 5 and completed[3] == nil)
assert(completed[4] == "stock-result" and completed[5] == nil)

lifecycle.cleanup()
assert(ActivateAbility == original)
lifecycle.cleanup()
assert(ActivateAbility == original)

ActivateAbility = function() error("stock failure") end
local failingOriginal = ActivateAbility
lifecycle.activate()
assert(not pcall(ActivateAbility))
lifecycle.cleanup()
assert(ActivateAbility == failingOriginal)

ActivateAbility = original
lifecycle.activate()
local ownedWrapper = ActivateAbility
local foreignWrapper = function() end
ActivateAbility = foreignWrapper
assert(not pcall(lifecycle.cleanup))
assert(ActivateAbility == foreignWrapper)
ActivateAbility = ownedWrapper
lifecycle.cleanup()
assert(ActivateAbility == original)

ActivateAbility = 7
assert(not pcall(lifecycle.activate))
assert(ActivateAbility == 7)
print("TARGET EXPORT HOOK LIFECYCLE PASS install, idempotence, yield, varargs, nil returns, stock error, ownership conflict, cleanup")
'@
$harness = Join-Path $generated 'verify_target_export_hook.generated.luau'
[IO.File]::WriteAllText(
    $harness,
    $prelude + "`n" + $testable + "`n" + $tests + "`n",
    [Text.UTF8Encoding]::new($false)
)
& (Join-Path $toolchain 'luau.exe') $harness
if ($LASTEXITCODE -ne 0) { throw 'Target export-hook lifecycle execution failed.' }

Write-Output "TARGET EXPORT HOOK PASS bytes=$((Get-Item -LiteralPath $first).Length) sha256=$firstHash deterministic=yes roundtrip=yes plan=yes semantic_ir=yes direct_lua_semantics=yes lifecycle_execution=yes live_fixture=pending"
