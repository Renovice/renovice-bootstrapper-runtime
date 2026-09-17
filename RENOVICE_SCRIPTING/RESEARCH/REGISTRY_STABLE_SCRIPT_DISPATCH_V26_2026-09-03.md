# Registry-Stable Script Dispatch V26

## Scope

Restore two regressions reported against V25:

1. SCRIPTS opens once but cannot reopen after Generic Settings closes.
2. Mallet's card describes Overguard, but Mallet damage does not grant it.

The correction must preserve script toggle state, F9 reload, stock TopMenu/HUD
code, and the already working ability-card projection.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| Generic Settings itself cannot reopen. | The first open completed, while every later click reached the native callback and failed specifically with `lua-namecall-bridge-missing`. | **FALSE** |
| The SCRIPTS row or click callback disappeared. | Later clicks continued to emit the exact bridge-missing failure. | **FALSE** |
| V25's maintenance callback ran repeatedly. | Each process logged `safe runtime tick FIRST PASS`, but the affected session showed one initial bridge rebind, one successful open, then only bridge-missing failures after `_T` changed. No later rebind/generation-change event occurred. | **FALSE** |
| Requiring `ci == base_ci` after the outer interpreter returned was a valid recurrence test. | DE may return to the native host with `ci` left on a suspended Lua host frame. V25 therefore accepted startup but rejected later otherwise-safe outer returns. | **FALSE** |
| The working card proves Mallet's damage handler is reachable. | Card projection is dispatched from the native lifecycle registry. The BardMusic damage shim instead looked up `RENOVICE_AFTER_MALLET_DAMAGE` in volatile `_T`. | **FALSE** |
| A VM-registry lifecycle hook remains available when DE replaces `_T`. | Managed/target add-on lifecycle tables are already rooted by registry keys and validated in the exact VM. | **TRUE** |

## Correction

- A safe runtime tick is eligible after every exact captured-VM outer
  interpreter return on the captured owner thread. It still rejects nested or
  re-entrant RENOVICE execution and remains rate-limited to 100 ms.
- The internal SCRIPTS bridge is now a real managed add-on. Its
  `openScriptsSettings` hook is resolved from the VM registry. Its old `_T`
  field remains only as a compatibility fallback.
- A generic `_RENOVICETargetHookV26(targetKey, hookName, ...)` dispatcher is
  installed in the VM global namespace. It resolves the active target add-on's
  hook from the native registry.
- BardMusic uses the generic dispatcher for `afterMalletDamage`; the old `_T`
  damage handler remains a compatibility fallback for older runtimes.
- No game HUD method or stock `UpdateFlashMarkers` closure is replaced.
- `ScriptStates.json` is not changed.

## Performance boundary

There is no directory scan or add-on recompile per frame. The scheduler checks
an in-memory 100 ms deadline after an outer VM return. Filesystem scans and
reload transactions remain startup, Confirm, or F9 work. Mallet performs one
registry lookup only when its actual radial-damage callback fires.

## Offline validation

- SCRIPTS UI core: 70/70 checks pass.
- Injection core: all checks pass.
- Bridge, BardMusic, and target add-on: deterministic recompile and exact
  de-roundtrip pass.
- Semantic ownership plans: 36/36 prototypes pass with zero failures.
- Semantic IR: 36/36 prototypes verified with zero adapter/verifier failures.
- Focused API checks: no violations; bridge and add-on have zero unknown calls.
- Private x64 build: zero warnings and zero errors.
- Legacy companion import: absent.

## Live acceptance still required

1. Open SCRIPTS, close it, and open it again twice.
2. In a mission, let Mallet deal positive damage and confirm Overguard rises.
3. Press F9 and confirm queue, drain, and commit messages appear.
4. Search exact frame names such as `limbo` and `khora` to retain the Arsenal
   crash regression gate.
