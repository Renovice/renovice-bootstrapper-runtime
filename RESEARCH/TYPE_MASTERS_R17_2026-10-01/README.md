# Contract R17 (2026-10-01): mission-type masters — page pair, cross-module literal drives, masters on writer-owned rows

- **Build:** client 44.0.2 (`2026.09.28.13.06`), `Warframe.x64.exe` `0124f0b9…7d33`.
- **Branch:** `feat/r17-type-masters-2026-10-01` from R16 `75e47a4` (worktree `repos/runtime/bootstrapper-runtime-wt-r16`; the
  R16 branch is unchanged). Installed DLL before R17: R16 `2758b1ab…` (live 2026-10-01: `ENGINE PARAMS hook=PASS`).
- **Producer:** ability editor `feat/missions-r17-type-masters-2026-10-01` (`RESEARCH/MISSIONS_R17_TYPE_MASTERS_2026-10-01`);
  research `work/research/mission-settings-r17-2026-10-01/README.md`.
- **Status:** every build-listed gate PASS, private build warnings=0 errors=0. **Nothing is live.** Staged
  `work/staging/combined-r17/`. Nothing deployed or pushed.

## Why

The user asked for an "All <mission type> missions" entry at the top of each mission type's page: one value row plus an
on/off switch with the Quick settings semantics (off keeps the typed number), the same value as the Quick settings entry,
driving the type's headline value for all variants. Three gaps:

1. The page model showed the on/off (`active:`) only on the Quick settings page.
2. A live-literal recipe value had one module; the Control Area hold time lives in three location scripts.
3. An `engine_params.json` override took only the row's own value; the Railjack kill-goal master also drives the Corpus
   fighter limit, which the engine writer owns (R16) and whose row value is withheld from the addon.

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| T1 | The pair can be a pure page-model change with no new storage. | **TRUE** | `quick_on_page` renders the existing `quick_switch_row` (`active:`) and `quick_value_row` (`open:qval:`) on the value's own page; staging, the values file and delivery are unchanged. Gate: `verify_addon_settings` R17 cases (stage `stored:` 60 on the page -> Quick settings reads 60; page switch off keeps 60); render gate R17 tape on the real R17 Missions package. |
| T2 | A per-drive module keeps every R8-R11 recipe rule. | **TRUE** | Rows, site overlap and "driven twice" are keyed by (drive module, row); the site extent is checked against the drive's module; a direct value must stay in its own module; plans are built per drive module. Gate: `verify_live_literals` part 6 (master over the fixture's Cambion and Plains rows patches both modules exactly like their rows, precedence, default/off, five rejects). |
| T3 | A master on a writer-owned row needs no Lua and no extra withholding. | **TRUE** | The override carries `master` + `scale` (validated: addon value of the same member, stock x scale = row stock, not itself an override value, one master per row). The plan takes the row's delivered value, else the master's delivered value x scale when it is not at its stock. Only the row is withheld; the master stays delivered (it drives addon rows of other targets); the producer leaves the row out of the addon's master drives. Gate: `verify_engine_params` R17 cases on the R17 fixture. |
| T4 | Older DLLs keep the game stock with an R17 package. | **TRUE (fail closed)** | R16 and before: `unknown-field=quick_on_page` rejects the package's settings capability (members keep compiled values), `drive-unknown-field=module` rejects `literals.json` (stock modules). Producer gate: the R7 bootstrapper `6227cc0` admits the package and rejects the settings (`test_live_literals.py`). |

## Change

- `renovice/settings_core.hpp`: `ValueDecl::quick_on_page` (field `quick_on_page`, bool; `quick_on_page-without-quick`,
  `quick_on_page-invalid`).
- `renovice/settings_ui_core.hpp`: `quick_switch_row` / `quick_value_row` (shared by Quick settings and the page pair),
  `quick_pair_label`, `shows_quick_pair` (typeable values only), `append_value` on list pages and path-less sections.
  Flat layout unchanged.
- `renovice/live_literals_core.hpp`: `Drive::module` (optional `"module"`), per-module rows/drivers/plans,
  `recipe-drive-module-not-declared`, `recipe-drive-module-is-the-value-module`, `recipe-direct-value-in-another-module`.
- `renovice/engine_params_core.hpp`: `OverrideDecl::master/scale`, validation, master fallback in `resolve_entries`,
  `PlanEntry::source` (in the plan identity only when it is not the row).
- Gates: `verify_addon_settings.cpp` (R17 page model; the page rule admits a CHECKBOX only as a pair's on/off; external
  packages count `qval:` openings on value pages), `verify_live_literals.cpp/.ps1` (part 6; UI pin), `verify_engine_params.cpp/.ps1`
  (R17 cases, fixture `fixtures/MissionsR17`), `verify_script_settings_render.ps1` + `harness_driver.luau` (section 1d,
  fixture `settings_render/fixtures/r17`: Missions -> Survival -> "All Survival missions" -> 60 -> back; Quick settings shows 60).

## Gates

| Gate | Result |
|---|---|
| `build_private.ps1` (every build-listed gate, then the private build) | PASS, warnings=0 errors=0, DLL `304b57deae8ef65e0e001f88ff20cd5aa0fec536738493a215ffe461934a0753` (6,051,328 B) |
| `verify_addon_settings`, `verify_live_literals`, `verify_engine_params` (99 checks), `verify_script_settings_render`, `verify_script_packages`, `verify_replacement_settings` (re-run with the final fixtures) | PASS |
| Installed-state replay: R17 Missions + read-only copies of the installed Frost, Octavia, values files and `ScriptStates.json` (`-Package -Settings -ScriptStates`) | ADDON SETTINGS GATES PASS; Missions `declarations=504 rejected=0 unknown_entries=6 members_staged=1/1`; `LIVE LITERALS RECIPE ACCEPT … values=133 plans=2`; `ENGINE PARAMS RECIPE ACCEPT … overrides=9 modules=4 values=7` |

Note: `build_private.ps1` needs `tools\pluto.exe` and `vswhere.exe` on PATH for `archive.php` (environment only).

## Limits (exact)

- **Nothing is live.** Pending: the page pair in the game menu, a cross-module Control Area plan in game, the Railjack
  master through the writer hook.
- A master reaches a writer-owned row only with the R17 hook installed (the producer leaves the row out of the addon's master
  drives).
