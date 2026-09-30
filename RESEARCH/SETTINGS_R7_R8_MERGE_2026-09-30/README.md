# SCRIPT SETTINGS R7 + live literals R8 merged (contract R9, 2026-09-30)

- Branch `feat/settings-r7-r8-merged-2026-09-30` = `feat/settings-r7-hierarchy-2026-09-30` (`6227cc0`) merged with
  `feat/live-literals-2026-09-30` (`0b95779`). Both lines start at `feat/replacement-settings-2026-09-30` `b5a120b`, which
  contains Settings R5 (`0afb9cd`: F9 Riven gate, tick/refresh) and REPLACEMENT_SETTINGS_V1.
- Client 44.0.2 (`2026.09.28.13.06`). Contract: `work/research/universal-mission-editor-2026-09-29/CONTRACT_PHASE1.md`
  Revision R9. Producer: ability-editor `feat/missions-r7-r8-merged-2026-09-30`
  (`RESEARCH/MISSION_SETTINGS_R7_R8_MERGE_2026-09-30.md`).
- Scope: repository and `work/` only. No game, OpenWF server or `renovice.cfg` file was written (installed files were read
  and hashed only). Nothing was pushed.
- Status: offline gates and the zero-warning private build **PASS**. **Every live check is pending.**

## Hypotheses and results

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| G1 | The only overlap that needs a decision is the three R8 lines in `settings_ui_core.hpp` plus `ValueDecl` in `settings_core.hpp`; `packages.*`, `replacements.cpp`, `injection.*`, `build_private.ps1` and the gate scripts merge textually. | `git merge` conflicted only in `settings_core.hpp` (both sides appended to `ValueDecl`) and `settings_ui_core.hpp` (R8's three lines sat inside code R7 rewrote; the rest of the R8 side in that hunk was R5 page code R7 removed). All other shared files auto-merged; their R8 source pins (`verify_live_literals.ps1` section 3) pass unchanged. | **TRUE** |
| G2 | R8's "a value at its default adds no patch" and R7's `enabled = value != default` are the same rule when a live literal's default is its stock. | R7 `default` is addon-lane only (parser reject `default-only-for-addon-lane`), so `default_of(d)` of a recipe value is `stock`. Gate chain: stage 20, then apply, values file `{true, 20}`, one plan; stage 80 gives `{false, 80}` and no plan; Reset to default gives `{false, 80}` and no plan. | **TRUE (gate)** |
| G3 | A live literal can use the R7 editor unchanged once the literal branches ask "baked literal?" instead of "literal lane?". | `baked_literal(d)` = literal lane and not `live_literal`. It guards the R7 built-choice/legacy-switch code paths: `entry_applies`, `current_value`, `editor_tooltip`, the value page switch, the `active:` legacy switch and the `value:` read-only reject. `settings::editable_in_game(d)` guards the Quick settings target (`qval:`), the kept-value page and `stored:`. The editor is locked only for metadata values and baked non-enum literals. | **TRUE (gate)** |
| G4 | The render harness can walk the real merged package to the Mobile Defense value and prove the written file's synthesis plan. | `verify_script_settings_render.ps1` section 1c now serves the real merged Missions `package.json` + `literals.json` (23 target keys) through the exact scanner and page model. The walk goes Missions → Mobile Defense → Timers → "Time per terminal: 60-80 s (default)" → stepper 20 → Confirm, then back up. The rows read "Time per terminal: 20 s", "Timers: 1 changed" and "Mobile Defense: 1 changed". The tape's new `EXPECTPLAN` resolves the written file (`a807aae359ffc1eb`, both total-time rows 60, 2 patches). With the U44 corpus it synthesizes `fff653e0…`, the baked Mobile Defense 20 s replacement. | **TRUE (gate)** |
| G5 | The user's installed values files stay valid under the merged package. | `verify_addon_settings.ps1 -Package` (merged Missions, R7 Frost/Octavia manifests with the installed addons) with read-only copies of the installed `Missions.json` `1100cee1…`, `Frost.json` `27b0e3fe…` and `Octavia.json` `485fa612…`: 209/209, 0 rejected. Missions: 6 unknown entries ignored (hidden treasure Demolyst tier, five Five Fates Steel Path timers); `plans=1` (Void Flood 4 now through synthesis). Same result with the generated values file and with none. | **TRUE (gate)** |

## Conflict resolutions

- `renovice/settings_core.hpp`: `ValueDecl` keeps the R7 fields (`path`, `row`, `default_declared`/`default_value`,
  `default_label`, `quick`) **and** R8's `live_literal`; `editable_in_game()` and `default_of()` both kept.
- `renovice/settings_ui_core.hpp`: the R7 file is kept. R8's R5-era helpers (`custom_label`, `editor_label`,
  `value_tooltip`, `custom_count`, `summary`) stay removed. R8's three behaviours are re-expressed in the R7 model:
  1. tooltip: `editor_tooltip` takes the baked branch ("Built into the mission script") only for `baked_literal`. A live
     literal gets "Default `<d>`. Range a to b. Applies at the next mission." (recipe values have `stock_check` none);
  2. lock: `editor.locked = metadata || (baked_literal && !enum)`;
  3. stage: `value:`/`stored:` refuse only metadata and baked non-enum literals; `stored:` and `qval:` admit
     `editable_in_game` values (live literal quick values keep a number); the `active:` legacy switch is only for baked
     literals.
  `entry_applies`/`current_value` treat a live literal like an addon value (valid number required; the row shows the value
  or the default).
- Kept from both lines: R7 page tree, Quick settings, value/default model, no switch rows; R8 recipe parse/merge/plan,
  undump synthesis, F9 plan snapshot, fail-closed checks, R5-C refresh identity; R5 fixes (F9 Riven gate absent-file,
  tick/refresh) and the R4 row rules (no INPUTCOUNT or locked row on recycled lists, search off) through the unchanged
  gates; REPLACEMENT_SETTINGS_V1. R3/R4 page code stays retired (R7 removed it; the R8 side's copies were dropped).

## Gate changes (merged branch)

- `verify_live_literals.cpp` part 5 rewritten for R7/R9 (value page, stepper, range row, typed 20 → file → plan →
  synthesis `fff653e0`, typed default and Reset give no plan, Quick kept value, baked literal read-only). Fixtures
  regenerated from the merged generator. `expected_order.txt` holds the merged declaration order (timers, objectives,
  enemies). Output is unbuffered, so a crash never hides the last checks. Section 3 UI pin updated to the merged predicates.
- `verify_addon_settings.cpp` tape: `EXPECTPLAN <folder> <key> values=… rows=… patches=…` (runtime resolution of the
  written file) and `--corpus` / `-Corpus` (synthesis from the stock bytes).
- `verify_script_settings_render.ps1` / `harness_driver.luau`: section 1c fixture = the real merged Missions package
  (plus `literals.json`, 23 target keys); node ids updated for the merged tree; walk (g) and the R9 requirement lines;
  21 planned host calls.

## Build

`RENOVICE_TOOLCHAIN/build_private.ps1`: 37 gate scripts, `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`,
main DLL `39853b5f8159f589bde2f519a594c0c273f865e0f3a8bb5d5362650296b10d8e` (5,903,360 B). Bridge unchanged from R7: `_RENOVICE_INTERNAL_ScriptSettingsBridgeV1.lua_B` `5635b1e2f54f55b7fe87a027195d844c3ad0e011f15b460cc5802f37762cbabe` (8,769 B). Build environment (new worktree): pinned submodules
initialised from the local clones; `soup.lib`, `Pluto.lib` and the git-ignored `OpenWF/cert/*.pem` copied from
`bootstrapper-runtime-wt-settings-r7` (never committed); `NoDefaultCurrentDirectoryInExePath` unset; git on PATH.

Staged: `work/staging/combined-r7-r8/` (one set: DLL, bridge, full Missions package, Frost/Octavia manifests, README with
install, delete, rollback and live test).

## Limits (exact)

- Every live point is pending: startup `RECIPE ACCEPT` with the R7 package, the page tree look with 412 values, the MD
  stepper and "60-80 s (default)", `SYNTHESIZE PASS` at the next Mobile Defense load, Quick settings on a live literal,
  R5-C with the merged addon.
- A master's row shows the typed number, not the per-row result (R9-4). Typing the master's stock number means "default"
  (the range), not a flat stock value.
- As in R8: values apply at the next load of the module; a module owned by another byte replacement keeps that owner.
