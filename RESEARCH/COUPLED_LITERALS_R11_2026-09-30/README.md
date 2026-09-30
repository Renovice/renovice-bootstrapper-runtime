# Contract R11: coupled live-literal sites (`value_offset`) and the R11 Missions package (2026-09-30)

- **Branch:** `feat/settings-r11-coupled-literals-2026-09-30`, from `feat/settings-r10-param-env-2026-09-30` `d250e11`.
- **Client:** 44.0.2 (`2026.09.28.13.06`).
- **Contract:** `work/research/universal-mission-editor-2026-09-29/CONTRACT_PHASE1.md`, Revision R11.
- **Producer:** ability editor `feat/missions-r11-railjack-2026-09-30`
  (`RESEARCH/MISSIONS_R11_RAILJACK_OROKIN_2026-09-30/README.md`).
- **Scope:** repository and `work/` only. No game, OpenWF server or `renovice.cfg` file was written; the installed files
  were read and hashed only. Nothing was pushed.
- **Status:** offline gates and the zero-warning private build **PASS** (hash in the Gates table). **Every live check is
  pending.**

## Why

Orokin Sabotage (`SabotageOrokin` prototype 17, `SabotageGatewayDevice`) sets the escape countdown with two literals:
`saved = GetNetVar(..., 10000); timer = (saved <= 27) and saved + 3 or 30`. The 27 is the host-migration restore threshold
(30 - 3). A plain live literal on the 30 would leave the threshold at 27 and make the restored timer inconsistent with an
edited value (R10 excluded the row for that reason). One row must move both literals together, each with its own preimage
check.

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| C1 | A coupled site needs only a fixed offset added to the row value. | **TRUE** | The stock relation is `threshold = timer - 3`; `operand = (value + value_offset) x numerator / denominator` with `value_offset = -3` encodes it. |
| C2 | The shared core change is small and keeps every plain site identical. | **TRUE** | `renovice/live_literal_patch_core.hpp`: `Site::value_offset` (default 0) and `operand()`; 4 code lines plus the header note. Byte-identical with the ability-editor copy; pinned SHA-256 `2fdda7b84c966250d3718da4391a1145981734d6774cb62cce02e7e099ba9be8` (`verify_live_literals.ps1` here, `live-literal-core` in the generator). `value_offset = 0` gives exactly the R8 operand. |
| C3 | The recipe format needs only an optional site field. | **TRUE** | `renovice/live_literals_core.hpp`: `value_offset` added to the site field allow-list, parsed as a finite number (`site-value_offset-invalid` otherwise), and compared in the row-agreement check (`recipe-row-sites-disagree`). The preimage check (`stock_error`) applies it through the core. The generator emits the field only when it is not 0, so every R10 recipe value is the same JSON. |
| C4 | The runtime synthesizes the coupled row correctly from the real stock bytes. | **TRUE (offline)** | Render gate 1c tape: `TAPEPLAN Missions a0cea91cc0ac3b31 file=Lotus_Scripts_SabotageOrokin.lua_B values=sabotage.orokin_escape_timer rows=sabotage.orokin_escape_timer=45 patches=2 synthesis=pass sha256=7d0f2a08041c5ed2`. An independent byte patch of the U44 stock (LOADN 45 at 14959, LOADN 42 at 14947) gives the same SHA-256 prefix. |
| C5 | Older DLLs fail closed on an R11 recipe. | **TRUE (static)** | The R10 parser rejects unknown site fields (`site-unknown-field=value_offset`), so the whole `literals.json` is refused and every typeable fixed number stays stock. The R11 package therefore needs this DLL. |

## Changes

- `renovice/live_literal_patch_core.hpp`: coupled site (shared, byte-identical).
- `renovice/live_literals_core.hpp`: optional `value_offset` in the recipe site.
- `RENOVICE_TOOLCHAIN/replacements/verify_live_literals.cpp/.ps1`: core pin; coupled-site core checks (30 → 27 stock, 45 →
  LOADN 42, domain 3 rejected / 4 accepted); recipe checks on the real fixture (an offset that breaks the preimage is
  rejected, an offset with the matching stock parses and encodes, a non-number is rejected).
- `RENOVICE_TOOLCHAIN/scripts_ui/verify_script_settings_render.ps1`, `settings_render/harness_driver.luau`, fixture
  `settings_render/fixtures/r7/Missions/{package.json,literals.json}` and `Missions.target_keys.txt` (the real R11
  package, 34 target keys): the Quick settings page holds 15 entries (Railjack: fighters to kill); new walks
  Missions → Railjack → Fighters to kill → 0.5 ("Fighters to kill: 0.5x", "Railjack: 1 changed") and Missions → Sabotage →
  Timers → Orokin: escape timer → 45 ("Orokin: escape timer: 45 s", "Timers: 1 changed", "Sabotage: 1 changed"); the
  written file holds both values; the Orokin plan synthesizes (C4). Page ids and step numbers after the new Railjack page
  (30) moved by one.

No mission, ability or target name is in shared runtime code.

## Gates

| Gate | Result |
|---|---|
| `build_private.ps1` (38 build-listed gates, MSVC `/W4 /WX` checkers) | every gate PASS, incl. `LIVE LITERALS GATES PASS`, `ADDON SETTINGS GATES PASS`, render gate R7/R9/R10/R11 |
| Private build | `PRIVATE BUILD PASS flavor=main warnings=0 errors=0 x64=yes companion_import=no bytes=5903360 sha256=b729b2e141df38cfc5502f078ee68492a9a60341a5f77ea6a9e60ccb3914b295` |
| `verify_addon_settings.ps1 -Package` (staged R11 Missions + installed Frost/Octavia, installed values files) | PASS; `LIVE LITERALS RECIPE ACCEPT ... modules=42 values=122`; Missions `declarations=490 rejected=0 unknown_entries=6`; `target_keys=34` |

Logs: `work/staging/combined-r11/evidence/bootstrapper/`.

Build notes for a fresh worktree (no source change): the submodules were populated from the local clones
(`git -c protocol.file.allow=always submodule update`), the ignored `OpenWF/cert/*.pem` were copied from the main checkout
(same SHA-256 as the R10 worktree's), `modules/Soup/soup/soup.lib` was built once with Sun before the gates (the
relocatability gate reads it in place), and `tools/` (tracked `pluto.exe`) is on PATH for `archive.php`, as in the earlier
settings builds.

## Limits

- Nothing is live. The Orokin timer and the host-migration restore path need a real Orokin Sabotage (and a migration for
  the second).
- A coupled site keeps its own LOADN domain: the row's minimum (4) is the smallest value whose coupled operand (1) fits.
