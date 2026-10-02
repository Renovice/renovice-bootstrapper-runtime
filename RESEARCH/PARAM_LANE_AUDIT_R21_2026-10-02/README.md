# R21: gate for the Spy and Sabotage level-trigger parameters at the engine writer (no runtime change), 2026-10-02

- **Branch:** `fix/r21-param-lane-audit-2026-10-02`, from R20 `b4a0bfc` (worktree `repos/runtime/bootstrapper-runtime-wt-r19`).
- **Runtime:** unchanged (no file under `renovice/` or `main.cpp` changed); no DLL built. The installed R17 DLL `304b57de…` has
  every primitive used (ENGINE_PARAM_OVERRIDE, R16; module recording for every recipe module, R19 E1).
- **Generator:** ability editor `fix/missions-r21-param-lane-audit-2026-10-02`, record
  `RESEARCH/MISSIONS_R21_PARAM_LANE_AUDIT_2026-10-02/README.md`. Research `work/research/param-lane-audit-r21-2026-10-02/README.md`.
- **Status:** offline gates PASS. Nothing is live, deployed or pushed.

## Hypothesis

The two rows that were still on the plain R10 entry write (Spy vault alarm: Intel `ee15b583788c3e7d` P43
`intelTimerDurationMax/Min`, scale; Sabotage surprise extraction: Sabotage `7e0adf2d83f7a086` P11 `duration`, absolute) are
owned by the R16 writer hook with no runtime change, once the recipe names their modules. **TRUE (offline).**

## Gate (`RENOVICE_TOOLCHAIN/engine_params/verify_engine_params.cpp`, section `r21_level_trigger_params`)

Fixture `fixtures/MissionsR21/`: `engine_params.json` `20323777…` and `package.json` `acc2256e…` (the R21 build; R20 package.json),
`trigger_entry_protos.txt` (real stock code of Intel P43, 517 words, and Sabotage P11, 326 words, from the 44.0.2 corpus; written
by the generator tool `trigger_entry_protos.py`).

| Check | Result |
|---|---|
| The recipe parses and validates with the production parser: 20 overrides, 13 values, 10 modules; Spy = 2 scale overrides on Intel, extraction = 1 absolute override on Sabotage, no master | PASS |
| F1 the installed R19/R20 recipe names neither module (never recorded: only the R10 entry write reached them); R21 names both and `module_wanted` admits them | PASS |
| F2 writer output on the real entry prototypes: Spy x0.5 stores 55/35 -> 27.5/17.5 and 120/90 -> 60/45; extraction 300 -> 120; one stock push per value; the addon gets neither value (withheld) | PASS |
| F3 R19 order on the writer: first write and three re-writes store the configured values; control with the installed R19/R20 recipe: `hash-not-declared`, 55 and 300 kept | PASS |
| F4 at the minimums: Spy 0.001 -> 0.055/0.035; extraction 1 | PASS |

`verify_engine_params.ps1`: fixture presence for `MissionsR21`. Run: `ENGINE PARAMS GATES PASS checks=125 failures=0` (R19: 115);
every source pin unchanged and PASS (no target names in the primitive).

Installed-state replay (`settings/verify_addon_settings.ps1 -Package -Settings -ScriptStates`, R21 Missions + installed
Frost/Octavia, read-only copies of the installed values files and `ScriptStates.json`): `ADDON SETTINGS GATES PASS`,
`ENGINE PARAMS RECIPE ACCEPT … overrides=20 modules=10 values=13`, Missions `declarations=508 rejected=0`.

## Limits

- Offline only. The live proof is `RENOVICE ENGINE_PARAM MODULE key=ee15b583788c3e7d` / `key=7e0adf2d83f7a086` and
  `ENGINE_PARAM APPLY` lines with the timers changed in game.
- The hook overrides number parameters only (types 0/1); both parameters are numbers in the level decode.
