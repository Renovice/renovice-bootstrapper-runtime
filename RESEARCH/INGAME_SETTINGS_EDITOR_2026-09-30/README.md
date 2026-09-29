# In-game settings editor: Phase 0 probe, ADDON_SETTINGS_V1 and SCRIPT SETTINGS (2026-09-30)

Contract: `work/research/universal-mission-editor-2026-09-29/INGAME_EDITOR_DESIGN.md`, plus the Phase 1 producer notes
`CONTRACT_PHASE1.md` (ability-editor `07d3196`). Target client: Steam `2026.09.28.13.06` (44.0.2).
Branch `feat/ingame-settings-editor-2026-09-30` from `3ca9564` (deployed DLL `6f100ebc…`).

| Commit | Content | Artifact |
|---|---|---|
| `3230368` | Phase 0 probe build + optional internal bridges + second pause-menu row | probe DLL `1a40ecaa7d9b9823a15f3b2335a0262c8d463f5f41420d755e3482a25ba73a0d` (5,110,272 B) |
| `c6ceec4` | Phase 2 ADDON_SETTINGS_V1, `member:` states; Phase 3 SCRIPT SETTINGS | main DLL `d2f2265071ea18caeccdde53a66aa4c6d16c387121d541bad20e23305b724372` (5,562,368 B) |

Both builds: `build_private.ps1` (probe: `-SettingsProbeP0`), 0 warnings, 0 errors, every gate PASS. Staged in
`work/staging/editor-phase0-probe/` (with `PROBE_CHECKLIST.md`) and `work/staging/editor-phase2-3/` (with the install
and test plan). **Nothing was deployed. Every live result below is pending.**

## Hypotheses and results

| ID | Hypothesis | Result | Evidence |
|---|---|---|---|
| H1 | An optional internal bridge can be loaded without joining the managed-addon transaction, so its failure removes only its own row | TRUE (offline) | `reconcile_optional_bridges_locked` runs after `active_chunks = candidate` in `apply_generation`; failures release the bridge's own root and log `scope=capability-local generation=continues`; gate `verify_script_settings_bridges.ps1` pins the order |
| H2 | A second TopMenu row can be added without changing SCRIPTS | TRUE (offline) | separate protected leaf after the SCRIPTS PASS; SCRIPTS leaf, label, callback and log line unchanged; `verify_ui_vm_raw_protection` still PASS |
| T-1 | The U14/U58 TopMenu builder contract holds on 44.0.2 | TRUE (static + existing live log) | the live 44.0.2 capture `Diagnostics/TopMenu.current.lua_B` (159,243 B, `59c87286…`, key `ee5220bab21a9a8a`) passes `verify_scripts_ui_core` (77/77); live session pid 11584 (2026-09-29) logged `Scripts UI attach PASS … Initialize.U14.Builder.U58` and `row append PASS`. The second row itself is pending live |
| P2-1 | Declarations can be strictly parsed while a bad declaration only disables settings | TRUE (offline) | `settings::parse_declarations`; package keeps `accepted`, members staged, `delivery=nullptr` (= `context.settings = nil`); exact `RENOVICE SETTINGS DECLARATIONS REJECT … scope=settings-capability-local members=compiled-defaults` |
| P2-2 | A bad values file can revert only its package to stock | TRUE (offline) | `FileStatus::Malformed` → empty delivery, literal members held back, F9 never rejected; exact `RENOVICE SETTINGS FILE REJECT …` |
| P2-3 | Settings-only changes must re-activate unchanged bytes | TRUE (offline) | SHA-256 delivery identity joins the target-addon reuse identity (`settings::target_addon_binding_reusable`); gate case 4 |
| P2-4 | The generator contract (phase2i) is accepted byte for byte | TRUE (offline) | fixtures `RENOVICE_TOOLCHAIN/settings/fixtures/phase2i/`; only `survival.reward_interval` (150, stock 300) is delivered; Void Flood literal stays staged; real bytes admitted by `verify_script_packages -AdmitPackage` (targets=3) |
| P2-5 | 64 KiB is enough for package.json | FALSE | CONTRACT_PHASE1 item 12: a 289-row package is ~127 KiB. Raised to 512 KiB (bounded, gated) |
| N-1, R-1, R-2, V-1, I-1, S-1, P-1, H-1, H-2 | Stock GenericSettings behaviours the editor would rely on | UNRESOLVED | answered by the Phase 0 probe session (`PROBE_CHECKLIST.md`) |
| U-1 | ADDON_SETTINGS_V1 is universal | UNRESOLVED | the primitive names no target (gated), but only the Missions addon consumes it; a second unrelated live consumer is required before calling it universal |

## Implementation

**Reserved namespace.** `_RENOVICE_INTERNAL_*` names are infrastructure: V10 keeps its path; `ScriptSettingsBridgeV1`
(always) and `ScriptSettingsProbeP0` (probe build only) are optional bridges; any other reserved name is logged
`internal chunk IGNORED` and never runs, never lists in SCRIPTS and is never a package member.

**Phase 0 probe** (`RENOVICE_SETTINGS_PROBE_P0` only). `SETTINGS PROBE` row after SCRIPTS; static L1/L2/L3 and a
1,342-row page built in compiled DE Luau (`RENOVICE_SCRIPTING/INTERNAL/ScriptSettingsProbeP0.luau`); F12 is latched
Lua-free like F9 and the open runs at the pending-only safe tick (never periodic work). Writes nothing.

**ADDON_SETTINGS_V1** (`renovice/settings_core.hpp`, `packages.cpp`, `injection.cpp`).
- `package.json` `settings` is captured verbatim and parsed strictly (design §3.2; value ids `[A-Za-z0-9_.]`, group ids
  `[a-z0-9_]`, 4,096 values, 64-char labels, 256-char scope, 1,024 aliases per group, int bounds exact in float32).
- `CustomScripts/Settings/<package folder>.json` (design §3.3) is read at every startup/F9 package scan. A value is
  effective when the file is valid, `use_stock` is false, its group is not switched off (a missing group entry means
  on), `enabled` is true and the value passes type/range/enum/float32 checks. A build change keeps a value only if its
  recorded stock equals the declared stock. Unknown ids are ignored.
- Each addon member that declares values gets a delivery (effective addon-lane values, sorted, value and declared stock
  as float32) and an identity `settings-v1:<sha256>`. `activate(context)` receives a fresh table built in the committing
  VM inside the protected lifecycle leaf: `context.settings[id] = { enabled = true, value, stock }`. A disabled value is
  absent. Loose files and members without declarations still get plain `activate()`.
- Literal (replacement) members with literal declarations are staged only when the file is valid, the master is off and
  at least one of their literal values is enabled.
- `member:<folder>/<file>` in `ScriptStates.json`: a disabled member is still validated and inventoried, claims no keys,
  never enters a lane. Member ids are admitted into a policy batch only for existing members.
- Operational lines (not diagnostics): `RENOVICE SETTINGS PACKAGE|DELIVERY|FILE REJECT|VALUE REJECT (≤16 + suppressed)|
  DECLARATIONS REJECT|LITERAL MEMBER STOCK`, `RENOVICE PACKAGE MEMBER DISABLED`.

**SCRIPT SETTINGS** (`renovice/settings_ui_core.hpp`, host block in `injection.cpp`,
`RENOVICE_SCRIPTING/INTERNAL/ScriptSettingsBridgeV1.luau`).
- Row after SCRIPTS only when the V1 bridge is committed and a valid package declares settings (active snapshot, no I/O).
- Default layout = the design's fallback: one flat list, TITLE per package and section, stock search box, no
  navigation or FinishSelection buttons. `SettingsMenuNested=true` (renovice.cfg, re-read by F9) switches to
  packages → package → section pages with Restore buttons; keep it off until N-1/R-2 pass.
- Rows: package, `Use stock values`, member switches (if >1), `Custom <section> values`, then per value
  `Custom <label>` + INPUTCOUNT (int ≥ 0) / validated INPUTBOX (float, negative int) / TOGGLE (enum). Literal and
  metadata editors are locked. Labels follow CONTRACT_PHASE1 D1 (stock suffix only within 40 chars; tooltip starts with
  the stock value).
- Clicks call the host `stage` native only (re-validated host side). The completion pass restages every visible
  editable row (INPUTBOX text only exists there). Only the ROOT close applies: atomic `Settings/<pkg>.json` write,
  one `ScriptStates.json` batch, `request_reload("Script settings applied")`. Opening and closing with no real change is
  a no-op. A VM change or malformed completion discards the session.

## Gates added

- `RENOVICE_TOOLCHAIN/settings/verify_addon_settings.ps1` (MSVC `/W4 /WX`, 122 checks): parser rejects, values file,
  per-value/section/master, build rule, literal gate, identity-includes-settings, `member:` states, fail-closed
  (malformed file, invalid declarations), package regression (`settings: {}` unchanged, ACCEPT line unchanged),
  phase2i contract, UI page model (stock types only, label budget, staging, apply, restore, no-op close) and source pins.
- `RENOVICE_TOOLCHAIN/scripts_ui/verify_script_settings_bridges.ps1`: U44 compile + byte-exact round trip + API
  contract check of both bridges, runtime pins (capability-local, probe-only admission, page leaf destructor-free).
- `verify_config_core`: `SettingsMenuNested` default off. `verify_script_packages`: 512 KiB manifest bound.

## Limitations and rejected options

- Rejected: user state in `package.json` or in `ScriptStates.json` (design §3.1); optional bridges inside the managed
  transaction (would make their failure generation-wide, V107 counterexample); per-row reset BUTTONs (R-1 unproven).
- The native validator runs only on Confirm and validates the row table it captured; rows copied by the stock search
  filter are covered by the host re-validation (rejected values are kept at their previous value and logged).
- Hotkey (`SettingsMenuKey`), token search page and the status channel are Phase 4, not built.
- Live evidence still required: N-1…H-2 (probe), Phase 2 Survival 150 s → `use_stock` 300 s, SCRIPT SETTINGS §4.6 look,
  and a second unrelated addon consuming `context.settings`.
