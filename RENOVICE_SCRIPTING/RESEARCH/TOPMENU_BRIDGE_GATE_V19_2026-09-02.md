# TopMenu bridge gate V19 — 2026-09-02

## Scope

This pass isolates the native SCRIPTS-menu extension from the Lua injector. It
does not change replacement matching, additive script loading, F9 reloads, or
target-addon's gameplay adapters.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The removed Lua replacement/addon bodies caused the latest crash. | The latest process reported `target_addons=0` and `one_shots=0`. | **FALSE for that process.** |
| The native `RunScript` ability-card observer caused the latest crash. | No `RunScript observer PASS` occurred in either no-script launch. | **FALSE for that process.** |
| TopMenu was still modified without the required internal settings bridge. | The runtime attached the TopMenu wrapper and appended the SCRIPTS row, then repeatedly logged `lua-namecall-bridge-missing`. The engine log ended mid-TopMenu update. | **TRUE.** |

The correlation does not prove that TopMenu caused every earlier Limbo crash.
It does prove a broken invariant: the runtime exposed a menu command whose
required Luau NAMECALL bridge did not exist.

## V19 invariant

The exact file
`_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B` is now a hard UI feature
prerequisite. When it is absent:

- `TopMenu` is not fingerprinted, recorded, decorated, or dumped;
- no SCRIPTS row or native callback is installed;
- the process-wide VM hook immediately rejects pause-menu work;
- the injector, replacements, target addons, and F9 remain enabled.

The builder wrapper and open callback also recheck the bridge-backed feature
flag. This covers an F9 removal after a TopMenu instance was already created.

## Offline evidence

- SCRIPTS UI core: **64/64 PASS**.
- Injection core: **PASS**.
- Replacement, Riven, SWF, and config cores: **PASS**.
- Current U43 client signature/compatibility scan: **PASS**.
- Private x64 build: **PASS**, zero warning/error gate failures.
- Built DLL SHA-256:
  `b00a90305acbc97b42a9ad00c3b2dccc0af5221238345b8a5524019c2ba30eb9`.

## Live gate

With the user intentionally leaving the Inject folder empty, the next launch
must log `Scripts UI disabled: required NAMECALL bridge absent; stock TopMenu
preserved`. The exact Arsenal search for `limbo` is the required runtime test.
If that still crashes, the TopMenu hypothesis is false and investigation moves
to the Limbo/loadout data path without re-enabling UI instrumentation.
