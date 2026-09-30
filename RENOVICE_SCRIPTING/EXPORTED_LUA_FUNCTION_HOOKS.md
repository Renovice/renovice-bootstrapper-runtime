# Exported Lua function hooks

> **2026-09-11 live correction:** A target addon cannot currently claim that a
> normal authored global such as `SetThreatLevel` resolves a stock module export
> whose DE bytecode uses a hashed global. The Mallet wrapper compiled and loaded,
> but `activate()` was repeatedly rejected and the target generation rolled
> back. The general template below remains an offline pattern for exports that
> are demonstrably reachable in the addon environment. It is not live proof for
> DE hashed exports. For an exact nested function that the runtime can identify,
> use `hooks.luaCalls[prototype].before`; V107 observes the natural DE CALL
> boundary and permits bounded scalar argument edits. Lua `after` declarations
> fail closed until exact return/yield/error/cleanup retirement exists. The
> optional host-owned diagnostic trace closure follows the existing
> `(prototype, arguments, upvalues)` values. Contract R10 (2026-09-30) appends a
> fifth argument, the called closure's environment table (nil when unavailable):
> `before(prototype, arguments, upvalues, trace, environment)`. Level and
> encounter script parameters are globals of that table (see
> `RESEARCH/LUA_CALL_ENVIRONMENT_R10_2026-09-30/README.md`).

Target addons already support additive Lua wrappers around exported functions
such as `ActivateAbility`. This path uses the target module's exact closure
environment and the existing managed lifecycle transaction. It does not add an
ability-specific native branch, a base-script replacement, a shim, a polling
loop, or another installed support script.

## What is proven by the host

The runtime matches the target filename's 16-hex body key to a natural module
load, validates and roots the complete prototype graph, loads the addon chunk
with that module closure's exact environment, and calls `activate()` only after
the candidate generation is complete. On F9, old `cleanup()` runs before the
new generation's `activate()`. A failed lifecycle operation rejects or rolls
back the transaction.

When a live fixture proves that a direct global such as `ActivateAbility`
resolves to the target module's actual exported field, the template stores that
closure, installs one Lua wrapper, verifies the assignment by identity, calls
the original closure directly, and restores it only if the wrapper still owns
the field. Borrowing the target environment alone does not prove this lookup.

Use the validated source template:

`RENOVICE_SCRIPTING/TEMPLATES/TargetActivateAbilityHook.target.addon.luau`

The current deterministic verifier compiles that template twice to the same
1,264-byte DE chunk with SHA-256
`8ACEA576731655C59414D2B3735D0E0EFCA26F4832934D1F25C8DF48D7A3D96D`.
All 9/9 prototypes pass full-body DE recompile round-trip, semantic-plan, and
Semantic IR verification. The source-only runtime fixture passes stock-call
composition, varargs and nil positions, coroutine yield, stock-error
propagation, wrapper reassignment, and callback isolation. A generated
lifecycle fixture additionally passes installation, idempotent activation,
ownership-conflict rejection, exact cleanup, and the same yield/result/error
cases through the actual template. A live exported-function fixture remains a
separate acceptance gate.

Compile it with the normal DE pipeline and name the output:

```powershell
& "C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\toolchains\de-luau-toolchain\bin\derecomp.exe" recompile `
  .\TargetActivateAbilityHook.target.addon.luau `
  .\<exact-16-hex-body-key>.MyAbilityHook.target.addon.lua_B
```

The exact body key and entry export are available in
`work/ability-behavior/current/ability-behavior-catalog.json`. All 248 current
ability entries resolve to an exact entry prototype in that pinned catalog.

## Call behavior

The wrapper runs:

```text
protected addon before callback
  -> original exported Lua closure
     -> protected addon after callback
        -> original return values
```

The original closure remains the authority. It is invoked directly in Lua, so
its normal arguments, yields, errors, nil return values, and result count are
preserved. If the original errors, the error propagates and the after callback
does not run, matching ordinary Lua call behavior. Addon before/after errors are
reported through the optional V58 trace bridge and do not suppress the stock
call or its results.

`activate()` and `cleanup()` must not yield. Keep spawned objects, callbacks,
and registrations owned by the addon and undo them in `cleanup()`.

## Exact boundary

This is an export hook, not a claim that every prototype is dynamically
replaceable. It applies when the game reaches the function through the target
module's exported environment field after addon activation. A native caller
that cached the old closure before the addon installed cannot be claimed
intercepted without live evidence.

An unnamed local closure has no environment field to replace. Use an exact
`hooks.nativeCalls[method].before/after` boundary when the desired behavior is
already expressed by a stock native call. Change the full module when the
original Lua control flow itself must change. A future true prototype
entry/return hook would require a separately proven VM call/return boundary;
the current outer `vm_execute` detour does not by itself prove nested Lua
function entry and return.

Multiple addons must not independently wrap the same export. The template
fails cleanup if another owner replaced its field because silently restoring a
stale closure would corrupt the newer owner. Use one addon as the composition
owner for that export until a shared export-provider bus is implemented and
tested.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| Borrowing a target module environment proves that a normally named addon global resolves a DE hashed export. | The Mallet `SetThreatLevel` wrapper loaded but every live `activate()` was rejected and rolled back. | **FALSE.** |
| A demonstrably reachable environment export can be wrapped without a base replacement. | The lifecycle and ownership fixture preserves calls, results, yields, errors, and exact cleanup. | **TRUE offline; requires an export-specific live lookup fixture.** |
| Direct Lua composition preserves yields, varargs, nil returns, and stock errors. | The embedded callback-runtime semantic test exercises the same `finish(original(...))` pattern, including coroutine yield, nil positions, and failure propagation. | **TRUE offline.** |
| An outer VM execute hook proves every nested prototype entry/return. | The current hook observes an interpreter boundary and active `CallInfo`; no exact nested call/return detour has been identified. | **FALSE.** |
| This template hooks unnamed local closures. | Locals are not addressable through the module environment. | **FALSE.** |
| The template is a universal multiple-provider export bus. | Independent wrapper cleanup order can retain a stale wrapper. The template deliberately rejects changed ownership. | **FALSE.** |

Run the deterministic verifier after changing this contract or template:

```powershell
& "C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\runtime\bootstrapper-runtime\RENOVICE_TOOLCHAIN\injection\verify_target_export_hook.ps1"
```
