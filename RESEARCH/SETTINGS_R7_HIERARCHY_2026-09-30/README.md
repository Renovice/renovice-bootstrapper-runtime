# SCRIPT SETTINGS R7: page tree, value/default model, Quick settings (2026-09-30)

Client 44.0.2 (`2026.09.28.13.06`). Branch `feat/settings-r7-hierarchy-2026-09-30` from `b5a120b` (R5 nested layout and
apply fixes, R6 replacement-settings accessor). Contract: `work/research/universal-mission-editor-2026-09-29/CONTRACT_PHASE1.md`
Revision R7. Producer: ability-editor `feat/mission-settings-r7-2026-09-30` (Missions) and
`feat/settings-second-consumer-2026-09-30` (Frost and Octavia manifests).

Offline only. No game or server folder was written (the installed packages, values files and logs were only read), nothing
was pushed. The parallel R8 work (`feat/live-literals-2026-09-30`) is not in this branch; merge notes are in the contract.

## Live feedback addressed

1. The Missions package page was a flat list of section buttons with broken titles ("Control Area: 1 value" twice,
   "Disruption::", "Shrine Defense::", "Colonist Door::"), "X: advanced" next to "X" and scattered Descendia modes.
2. Tooltips listed node names and MT codes.
3. Every value took two rows ("Custom X" and "X: value").
4. SCRIPT SETTINGS showed package, member and "Use stock values" switches; enabling scripts belongs to SCRIPTS.
5. "Restore stock values" did not seem to work.
6. The Ice Wave bonus needed "Custom" ticked for the card to show it; defaults did not match what the player sees.
7. A simple Quick settings page with one on/off per headline value that keeps the typed number.

## Hypotheses and results

| ID | Hypothesis | Result | Evidence |
|---|---|---|---|
| R7-1 | The double colons and duplicate titles are produced by the page model, not by the Missions data | **TRUE** | `button_label` (R3) cut "<section label>" to fit "<label>: N values - M custom" in 40 characters: "Disruption: advanced" + ": 12 values - 0 custom" became "Disruption:: 12 values ..."; "Control Area (Plains)" and "Control Area (Cambion Drift)" both became "Control Area: 1 value - 0 custom". R7 lists mission types (no summary longer than "N changed"), and `fit_words` never leaves a trailing colon. |
| R7-2 | The node lists in tooltips come from the group aliases | **TRUE** | `build_package_page` (R5) appended "Also: <aliases>" (search-only data: MT codes, node names). R7 never shows aliases. |
| R7-3 | "Restore stock values" failed to apply | **FALSE (mechanically it applied)** | Live log pid 13196: `action PASS restore:Frost staged=restore` three times, `apply PASS ... restores=3`, then `SETTINGS DELIVERY ... package=Frost ... values=0` and `F9 COMMITTED`. What the player saw did not change: Restore only unticked "Custom" and **kept the number**, so the row still read "Bonus per Cold stack: 50x"; the page closed to the root with no feedback; and for Frost the stock is 0x, so the addon went inert instead of back to its 50x. |
| R7-4 | With `context.settings` present and no Frost entry the addon applies 0, so the author's default must be delivered by the host | **TRUE** | ability-editor `src/ice-wave-settings.u44.luau` L1238-1251 (`bonus = 0` once `context.settings` is a table). Mallet keeps the dynamic level (L245-255). R7 `default` is always delivered (gate: "declared default: delivered at 50 ..."; `-Package` without values files: `DELIVER ... ice_wave.bonus_per_cold_stack ... value = 50, stock = 0` and `mallet.threat_level ... value = 5`, `defaults=1` each). |
| R7-5 | A reset on a value page must not be undone by the page's own completion restage | **TRUE** | The stock close runs the bridge completion, which restages the editor's old value after the reset. The host replays operations in order, so that restage would win. The bridge now skips the restage after `reset:` (`context.skipRestage`); render gate: the planned call list has no restage after `ACT reset:...` and the file holds the default. |
| R7-6 | "Reset all to defaults" can refresh its own page in place without re-opening it | **TRUE (offline)** | The R5 parent refresh (`refreshRows`) works on the page's own context from a BUTTON callback; render gate: Missions "Life support" and Frost pages stay open and their drawn rows show "(default)" at once (`inplace=2`). |
| R7-7 | The stock checkbox reports a click once | **FALSE (harness)** | The first click on a freshly drawn Quick settings page reached the bridge's value-changed callback twice; the second identical stage is no operation in the host. The plan records both calls. |
| R7-8 | Value ids and the user's installed values file stay valid | **TRUE** | `-Package` with read-only copies of the installed `Missions.json` (`1100cee1…`), `Frost.json`, `Octavia.json`: 209/209, no rejected entry; 14 entries of values not declared in this build are ignored (`unknown_entries=14`). |

## What changed

**Declarations (`settings_core.hpp`).** Optional `path`, `row`, `default` (addon lane), `default_label`, `quick` with exact
rejects (contract R7-1). `default_of()`. `evaluate` adds `defaulted` (declared defaults delivered without an applying
entry, not on `use_stock`, section off or a malformed file); `member_delivery` delivers them, also when the file is absent.
`packages.cpp`: ` defaults=<n>` on the summary line only when used; a rejected entry of a declared-default value logs
`value=default`.

**Page model (`settings_ui_core.hpp`, rewritten).**
- Tree from `path` (values in section order, then declaration order; first appearance decides a page's order); page ids
  `root`, `flat`, `pkg:`, `node:<Folder>/<i.j>`, `quick:`, `val:`, `qval:`; `select_page` (the host calls it).
- One BUTTON row per value ("Time between rewards: 60 s", "... 300 s (default)", `default_label` for ranges); child pages
  with "N changed"; "Reset all to defaults" on every list page; value page = editor + "Reset to default: <default>".
- Packages without `path` render their values on the package page (TITLE per section when there are several).
- Quick settings: CHECKBOX `active:` + BUTTON to `qval:` (kept number) or the literal value page.
- Removed: package, member, "Use stock values", section and "Custom" rows, the "Sections" title, alias tooltips,
  `build_group_page`, `member_row_label`, `member_tooltip`, `Session::implied_custom`/`restores`.
- Staging: ordered operations (`value:`, `stored:`, `active:`, reset); an unchanged stage is no operation; literal enum
  choices; legacy literal switch; write normalization (use_stock off, sections on, waiting entries off).
- Tooltips: value rows show the producer's sentence; the editor says "Default <d>. Range a to b. Applies ..." and, for
  `stock_check` live, "A changed value applies only where the game still uses its default." The word "stock" is gone from
  the menu.

**Host (`injection.cpp`).** `select_script_settings_page` delegates to `settings_ui::select_page`; the action native accepts
`reset:`, `resetall:` and `restore:` (one reset each; `action REJECT ... reason=unknown-scope` for an unknown scope); the
apply line reports `resets=` and `operations=` instead of `restores=`/`edited_custom=`. No policy batch is produced any more
(SCRIPTS keeps owning `package:`/`member:`).

**Bridge (`ScriptSettingsBridgeV1.luau`, same name and host contract).** `resetall:` stages and re-reads the page in place;
`reset:` stages, closes through Confirm and skips the completion restage; `restore:` unchanged. Bytes `299cac5e…` →
`5635b1e2f54f55b7fe87a027195d844c3ad0e011f15b460cc5802f37762cbabe` (8,769 B).

## Gates

| Gate | Result |
|---|---|
| `verify_addon_settings.ps1` | 169 checks + 14 integration pins. New: R7 parser fields and 12 rejects; phase2i (no path) flat-per-section package page; synthetic R7 set: root, package, mission type, category and set pages with exact row texts, value pages (INPUTBOX, INPUTCOUNT, TOGGLE with the default marked, negative int, literal choice), Quick settings, the stock row rules on every reachable page, value/default staging, Reset to default, Reset all per page, edits after a reset, legacy prefixes refused, use_stock normalization, declared-default delivery (absent file, disabled entry, enabled entry, use_stock, malformed). |
| `verify_addon_settings.ps1 -Package` (repeatable) | Staged Missions + Frost + Octavia with the installed values files, the staged ones and none: 209/209 each; 415 reachable pages (117 list, 298 value), every declared value exactly one row, no switch row, all pages within the stock row rules. Prints `PAGEDUMP`/`PAGEROW`, `TREE`, the flat page. |
| `verify_addon_settings.ps1 -Tape <plan>` | Host side of the render gate: pages after each of the 20 planned calls (464 page versions), 7 EXPECTROW and 5 EXPECTFILE checks. |
| `verify_script_settings_render.ps1` | R2/R3/R4 negative controls and R5 flows unchanged; new section 1c (R7): the bridge under test walks the real host pages of the fixture packages (`settings_render/fixtures/r7`, the staged package.json files with synthetic members) through the stock screen: Missions → Mirror Defense → Enemies → Max enemies at once → Squad (depth 6), edit, back up with Confirm, Close and Back; Quick settings off, kept value 45, on; Survival reward 60 then "Reset to default"; Life support "Reset all to defaults" in place; Frost 250 on Back (stock message), 60, Reset all in place; Octavia open and Close. Exactly the 20 planned host calls, 18 returns, 14 refresh checks, 0 switch rows. Section 2 now accepts value pages with the editor plus its reset BUTTON. |
| `verify_replacement_settings.ps1` | Package page without member switch, value row "Payload health: 20000 HP", value page with "Reset to default: 10000 HP"; pinned rows file regenerated; the edit-to-accessor chain unchanged. REPLACEMENT SETTINGS GATES PASS. |
| `verify_script_settings_bridges.ps1` | Pins updated: pages served by `settings_ui::select_page`, reset actions. |
| `verify_script_packages.ps1 -AdmitPackage` (staged Missions) | `PACKAGE ACCEPT ... members=6 replacements=5 target_addons=1 target_keys=21`. |
| `build_private.ps1` | 36 gate scripts PASS; `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`, 5,707,776 B, `76f8d852ce17d25fc7cae710a9d6a0255b0873150d60be37552cdae0401603b0`. |

Build environment notes (new worktree): `modules/Soup/soup/soup.lib` (build product of the pinned Soup `b02796b`, byte
identical in the other worktrees) and the git-ignored `OpenWF/cert/*.pem` were copied from the sibling worktree; `git` must
be on PATH for `archive.php`; `NoDefaultCurrentDirectoryInExePath` unset.

## Limits (exact)

- Every live result is pending: the page tree look, in-place Reset all, the value page reset, Quick settings, Frost's 50x
  default on the card without a values file entry.
- The harness simulates the engine (Flash, timers, widgets); the stock screen logic is real.
- A value typed on a value page shows on the parent row after the page closes (R5 refresh); the page's own editor is not
  re-read while it is open.
- A hand-edited `use_stock: true` or a section switched off in `Settings/<pkg>.json` still applies until the first SCRIPT
  SETTINGS change of that package; rows show defaults meanwhile.
- A range default ("7-10") is shown as text; typing the number the declaration uses as stock (the upper end) counts as "at
  default".
- R8 recipe values (typeable literals) render as the legacy switch in this branch until the merge (contract R7 notes).

Rejected: keeping a "Use stock values" master at the bottom (the same as turning the package off in SCRIPTS, per the user);
re-opening the page after "Reset all" (it would fire the page's completion and, at depth 1, apply and end the session);
a separate `set` declaration field for player-count sets (`group` already names the section; a set is one more `path`
level).
