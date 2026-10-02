# Contract R19 (2026-10-02): Railjack encounter goals at the engine writer — gate only, no runtime change

- **Build:** client 44.0.2 (`2026.09.28.13.06`), `Warframe.x64.exe` `0124f0b9…7d33`.
- **Branch:** `fix/r19-railjack-engine-owner-2026-10-02` from R17 `45ed7b0` (worktree `repos/runtime/bootstrapper-runtime-wt-r19`).
- **Producer:** ability editor `fix/missions-r19-railjack-engine-owner-2026-10-02` (from R18 `3475602`),
  `RESEARCH/MISSIONS_R19_RAILJACK_ENGINE_OWNER_2026-10-02`. Research: `work/research/railjack-kill-goals-r19-2026-10-02/README.md`.
- **Status:** every build-listed gate PASS, private build warnings=0 errors=0 (see Gates). **Nothing is live.** Staged
  `work/staging/combined-r19/`. Nothing deployed or pushed.

## Live evidence that led here (read-only, session pid 7128, installed R17 DLL `304b57de…`)

- `RENOVICE ENGINE_PARAM SKIP reason=module-identity-unknown hash=288044d3 key=0000000000000000 … proto=0x1eec490ab40 index=0..5`
  and the same for `e290a5e6` (renovice_source.log L45012-45023): the engine writer pushing the Grineer KillFighters goal lists
  (function slot = KillFighters P9, bytecode id 9, 126 instruction words, ADDON_TRACE L44376-44386), before the entry hook
  (L45024-45025). The R17 recipe named the Corpus patrol module (`0a6394a10884c38a`) for these hashes, not KillFighters, so
  KillFighters was never recorded (`module_wanted` false) and the write stayed stock by design.
- The addon's R10 entry write of the same lists (EE 1218.260) did not reach the objective's goal (research H1c/H1d).

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| B1 | Encounter-loaded scripts are not mapped to their content key (a runtime mapping defect). | **FALSE** | The natural-load path (`loader_detour_owned`, `inspect_target_load` -> `remember_engine_param_module`) recorded `feb4ca192ef69f0a`/`e773280ca7743441` as target modules in every run (`target module identity PASS`); the engine-param record runs in the same branch for any recipe module. Only the recipe membership was missing. Gate E1/E3. |
| B2 | The R17 runtime owns the two Grineer rows once the recipe names their modules (no DLL change). | **TRUE (offline)** | Gate E2/E4/E5 on the production `classify` / `module_of` / `apply_pushed` / `resolve_entries` / `withhold`, with the real stock entry prototypes. |
| B3 | One parameter name in two modules (`minorKillGoals` in KillFighters and BasicRailJackPatrol) gets the right value in each. | **TRUE (offline)** | Gate E2: plan keyed by (exact content key, hash); x0.1 and x0.5 in the same plan. |

## Change

- `RENOVICE_TOOLCHAIN/engine_params/verify_engine_params.cpp`: section R19 (E1-E5, 16 checks; total 115); the model frame can
  hold a real prototype (code words and bytecode id).
- `RENOVICE_TOOLCHAIN/engine_params/verify_engine_params.ps1`: the R19 fixtures are required.
- Fixture `fixtures/MissionsR19/`: `engine_params.json` (`eafd2ddf…`) and `package.json` (`150c0d16…`) of the R19 build;
  `encounter_entry_protos.txt` = the stock code of KillFighters P9, KillCrewShips P9 and BasicRailJackPatrol P15
  (generator `tools/encounter_entry_protos.py` in the ability-editor record).
- No file under `renovice/` or `main.cpp` changed.

## Gates

| Gate | Result |
|---|---|
| `verify_engine_params.ps1` | PASS, 115 checks (R19: E1 recipe names every Railjack encounter module, natural loads wanted, RailjackPatrol not; E2 live Steel Path lists through the writer on KillFighters P9 / KillCrewShips P9: {2/4/6/7/9/10}, {4/6/9/9/10/11}, 5, 6, {1/1/1/1/1/1}, 1, one stock push per value, the installed values give a plan of 10 overrides, shared hash routed per module, withholding keeps the master; E3 the R17 live state reproduced: 12 writes stock with module-identity-unknown key=0; E4 8 reloads kept, newest attributed, freed reused load stock; E5 master alone, master at stock (no override), row wins) |
| `build_private.ps1` (every build-listed gate, then the private build) | PASS: every build-listed gate (`verify_engine_params` then 114 checks; re-run alone with the added E2 plan-size check: 115), `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`, 6,051,328 B, SHA-256 `ceab0d449b53908309dc18d13047a3ce6fa8a3e0681de3a6ea0dc11e2aa03371`. **Not shipped:** no runtime source changed since R17 `45ed7b0` (only this gate, its script and fixtures); the build is not byte-reproducible (section layout and stamps differ from `304b57de`), so the installed R17 DLL `304b57de…` stays. |
| Installed-state replay (`verify_addon_settings.ps1 -Package` R19 Missions, read-only copies of the installed values files and ScriptStates.json) | ADDON SETTINGS GATES PASS; Missions `declarations=508 rejected=0 unknown_entries=6 members_staged=1/1`, delivery `values=4` (no hook in the gate: survival, master, fighters, crewships); `ENGINE PARAMS RECIPE ACCEPT … overrides=17 modules=8 values=11`; `LIVE LITERALS RECIPE ACCEPT … values=135 plans=2`; every delivered value reaches a staged member (Missions, Frost, Octavia) |

## Limits (exact)

- **Nothing is live.** Pending: `RENOVICE ENGINE_PARAM MODULE key=feb4ca192ef69f0a` / `key=e773280ca7743441` at the mission load,
  `RENOVICE ENGINE_PARAM APPLY … parameter=minorKillGoals … written=…` and the HUD goal.
- The writer model is byte-exact for the registered frame; the DE VM does not run in the gate. Why the R10 entry write did not
  reach the goal is unresolved (research H1d); if the writer's stored lists also do not reach it, the readers take the value
  from another source and a reader-side owner is the next step.
