# Contract R10: the callee environment as the fifth `luaCalls.before` argument (2026-09-30)

- **Branch:** `feat/settings-r10-param-env-2026-09-30`, from `feat/settings-r7-r8-merged-2026-09-30` `c2909f2`.
- **Client:** 44.0.2 (`2026.09.28.13.06`).
- **Contract:** `work/research/universal-mission-editor-2026-09-29/CONTRACT_PHASE1.md`, Revision R10.
- **Producer:** ability editor `feat/missions-r10-owners-2026-09-30`
  (`RESEARCH/MISSION_OWNERS_R10_2026-09-30/README.md`).
- **Scope:** repository and `work/` only. No game, OpenWF server or `renovice.cfg` file was written; the installed files
  were read and hashed only. Nothing was pushed.
- **Status:** offline gates and the zero-warning private build **PASS**. **Every live check is pending.**

## Why

Level ScriptTrigger and encounter parameters (`_scoreGoal=1450`, `_metersPerEnemy=15`, `_defendTime=90`) are globals of the
*calling* script instance's environment. A `luaCalls.before` callback runs in its addon's own environment, so the addon's
global `scoreGoal` is nil (live 2026-09-11, `INTERCEPTION_SCORING_RECOVERY`; research finding PG-1 in
`work/research/mission-owners-2026-09-30/README.md`). The runtime already tracks that environment per module instance
(`note_lua_call_instance_entry`, the R3 retire ledger), but the callback received only
`(prototype, arguments, upvalues, trace)`.

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| E1 | Passing `call.closure->env` as an appended fifth argument is backward compatible. | **TRUE** | Lua ignores extra arguments: every existing addon declares at most four parameters. The four earlier arguments, the two results (R3/R4 sentinels) and the copy-back are unchanged. `verify_lua_call_retirement.ps1` and `verify_lua_call_raw_protection.ps1` pass with the pin updated to `protected_call(state, 5, 2, 0)`. |
| E2 | The argument can be prepared without any work inside the raw leaf. | **TRUE** | `dispatch_lua_call_phase` fills `LuaCallBeforeLeafContext::environment` (a POD `luau_TValue`) before `run_current_vm_protected`: nil by default; the GC header byte is read only after `diagnostics::bad_read_ptr`; the unit-tested rule `lua_call_environment::classify` decides table or nil. The leaf only copies the value into the argument slot (gate: no probe, no classification, no allocation in the leaf). |
| E3 | The table is safe to hand out for the callback's duration. | **TRUE (by construction)** | It is referenced by the closure being called (live on the stack) and by the callback argument slot. The contract lets an addon keep it only as a weak key; native code keeps no reference. |
| E4 | An addon compiled on the generator path can address a parameter as a field of that table with the same key the stock `GETGLOBAL` reads. | **TRUE (offline)** | Fixture `ParamEnvProbe.targets.addon.luau` with `-- RENOVICE_HASH_FIELD: scoreGoal`, compiled by `recompile-u44` + alias map: CONST-ID against the directive-free control shows only `FIELD S:scoreGoal` → `FIELD H:3a44eae1`; the decompile renders every read and write hashed; the stock TerritoryMission contains the same hash. |
| E5 | The write-once-per-instance rule works against the R10 call shape. | **TRUE (plain Luau)** | `param_env_harness.luau`: 16 checks (write, no compounding, rewrite when the level value returns, per-instance, drift left alone, missing parameter, no fifth argument, cleanup restore). |

## Change

- `renovice/lua_call_environment_core.hpp` (new): `before_callback_argument_count = 5`, `environment_argument_index = 4`,
  `classify(present, readable, header_is_table)`; static asserts.
- `renovice/injection.cpp`: context field `environment`; dispatch prepares it; leaf appends it and calls
  `protected_call(state, 5, 2, 0)`.
- Gates: new `RENOVICE_TOOLCHAIN/injection/verify_lua_call_environment.ps1` (+ `.cpp`, fixture, harness) in the build
  list; `verify_lua_call_retirement.ps1` and `verify_lua_call_raw_protection.ps1` pins updated.
- Render gate: section 1c now serves the real R10 Missions package (486 values, 31 target keys) and walks
  **Missions → Defense → Objectives → Waves to finish → 3** (walk h: "Waves to finish: 3", "Objectives: 1 changed",
  "Defense: 1 changed", values file `{ enabled: true, value: 3 }`). The quick page has 14 entries (28 rows), so the harness
  scrolls a switch into view with the stock scroll bar before clicking it, as a player does. Page ids updated
  (Mirror Defense 23, Mobile Defense 24, Survival 35).
- `R3/R4` retirement (sentinels, unanimity, root-child rule, dormant re-arm) and the S2 prefilter are untouched.

## Build

`RENOVICE_TOOLCHAIN/build_private.ps1`: 38 gate scripts, `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`, main DLL
`86408429caa72943820f2047964f10118cdb7ef69cab26ac9f3da419742071be` (5,903,872 B). Bridge unchanged:
`_RENOVICE_INTERNAL_ScriptSettingsBridgeV1.lua_B` `5635b1e2…cbabe` (8,769 B). Build environment: pinned submodules
initialised from the local clones; `soup.lib`, `Pluto.lib`, `OpenWF/cert/*.pem` and the git-ignored tool folders copied
from `bootstrapper-runtime-wt-r7r8-merged` (never committed); git on PATH for `archive.php`.

Compatibility with the installed values files (`verify_addon_settings.ps1 -Package` with read-only copies of
`Missions.json` `1100cee1…`, `Frost.json` `27b0e3fe…`, `Octavia.json` `485fa612…`): 486 Missions declarations, 0 rejected,
6 unknown entries ignored (as in R9), `plans=1` (Void Flood 4), Frost and Octavia unchanged.

Staged: `work/staging/combined-r10/`.

## Limits (exact)

- Live pending: that the environment reaches the addon in the game (`print` lines "RENOVICE Missions: … -> …" in EE.log),
  that a level parameter written at the trigger entry is read by the trigger (static proof only), and host migration.
- The argument is nil for a C closure or an unreadable environment; addons must keep the stock value then.
