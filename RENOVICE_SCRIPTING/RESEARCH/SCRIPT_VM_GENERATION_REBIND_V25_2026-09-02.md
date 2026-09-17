# Script VM Generation Rebind V25
## Scope

Restore the complete SCRIPTS workflow after V24 removed the crashing native
`UpdateFlashMarkers` scheduler replacement: Generic Settings toggles, Confirm
persistence, F9 mid-process reload, and the Mallet explicit-hook add-on.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The SCRIPTS row itself failed to attach. | The live V24 log contains `Scripts UI row append PASS`. | **FALSE** |
| The submenu failed because its Lua NAMECALL bridge was absent from the table used by the current UI instance. | Every click reached the native callback and failed specifically with `lua-namecall-bridge-missing`; the bridge one-shot had previously reported a successful load. | **TRUE** |
| The Mallet card proves the gameplay handler is attached. | Card publication uses the native `RunScript` projection, while the deployed explicit BardMusic shim reads `RENOVICE_AFTER_MALLET_DAMAGE` from the current `_T`. The card continued to work while gameplay Overguard did not. | **FALSE** |
| DE can replace `_T` without replacing the Luau global-state pointer. | This was already live-proven by the exact Mallet pipeline trace; V24 had no real table-generation maintenance after retiring the false time-gap region reload. | **TRUE** |
| F9 must execute Lua work at every VM return. | Only the key edge must be observed immediately. The transaction can remain queued until the exact safe VM boundary. | **FALSE** |

## Correction

- The exact current `_T` identity is sampled at most once per 100 ms, and only
  while the SCRIPTS bridge or a target add-on is enabled.
- A missing internal SCRIPTS bridge is re-executed in that same VM and accepted
  only after exact field readback from the same `_T` object.
- A target add-on whose active lifecycle records a different `_T` identity is
  refreshed through the existing cleanup, stage, activate, and release
  transaction. This restores the Mallet handler without editing its behavior.
- The Lua-free F9 edge poll runs after outer VM returns on the exact captured
  game script thread, independent of which DE global state returned. It does no
  filesystem work and cannot execute Lua. The queued refresh still drains only
  at the guarded `ci == base_ci` VM boundary.
- The stock `UpdateFlashMarkers` method remains untouched.

## Performance boundary

This is not a frame-by-frame directory scan. The 100 ms maintenance path reads
one existing VM global/table field and returns immediately when identities are
current. Filesystem scanning, bytecode staging, lifecycle transactions, and
replacement refreshes remain startup, explicit F9/Confirm, or exact identity-
change work.

## Validation

- Injection verifier including live Inject directory: pass.
- SCRIPTS UI core: 69 checks pass.
- Internal UI bridge: byte-exact round trip, verified Semantic IR, and API
  contract pass.
- Clean private x64 build: zero warnings and zero errors.
- Legacy companion import: absent.
- Legacy `UpdateFlashMarkers` scheduler hook: absent by source gate.
- Built/deployed SHA-256:
  `8FB33100EDBA5EB55E7A373FD699422D3BB6BAB4BD119EB7E55C9CD8EFB5BB36`.

## Live acceptance

The client must still prove the engine-facing results:

1. Open SCRIPTS and confirm all user script toggles render.
2. Flip one toggle, Confirm, reopen, and confirm persistence.
3. Press F9 and confirm `F9 QUEUED`, `F9 DRAIN`, and `F9 COMMITTED` appear.
4. Cast Mallet and confirm its damage grants Overguard.
5. Search exact `limbo` and `khora` again to retain the V23 crash gate.
