# In-game settings editor: Phase 0 probe, ADDON_SETTINGS_V1 and SCRIPT SETTINGS (2026-09-30)

Contract: `work/research/universal-mission-editor-2026-09-29/INGAME_EDITOR_DESIGN.md`, plus the Phase 1 producer notes
`CONTRACT_PHASE1.md` (ability-editor `07d3196`). Target client: Steam `2026.09.28.13.06` (44.0.2).
Branch `feat/ingame-settings-editor-2026-09-30` from `3ca9564` (deployed DLL `6f100ebc…`).

| Commit | Content | Artifact |
|---|---|---|
| `3230368` | Phase 0 probe build + optional internal bridges + second pause-menu row | probe DLL `1a40ecaa7d9b9823a15f3b2335a0262c8d463f5f41420d755e3482a25ba73a0d` (5,110,272 B) |
| `c6ceec4` | Phase 2 ADDON_SETTINGS_V1, `member:` states; Phase 3 SCRIPT SETTINGS | main DLL `d2f2265071ea18caeccdde53a66aa4c6d16c387121d541bad20e23305b724372` (5,562,368 B) |
| follow-up after `7028479` | R1: `stock_check` tooltip, `verify_addon_settings -Package/-Settings`, long-path-safe gates (section "Follow-up R1") | main DLL `ed2a996d92b4b73ef2567945ecb0d709241e0d7746902079ad982a270e6eddb5` (5,562,880 B); bridge unchanged `9c1450ed…` |

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

## Follow-up R1 (2026-09-30): tooltip from the declaration, real-package verification, long-path-safe gates

Trigger: the second-consumer note (ability-editor `feat/settings-second-consumer-2026-09-30` `a32e4ab`,
`RESEARCH/SETTINGS_SECOND_CONSUMER_2026-09-30/README.md`, "Limitations and follow-ups") found three owner issues here.
Offline only; nothing was deployed, pushed or written to a game folder.

| ID | Hypothesis | Result | Evidence |
|---|---|---|---|
| R1-1 | The fixed tooltip sentence "Custom value applies only where the live value equals stock" can be derived from the declaration without changing Missions behaviour | TRUE (offline) | New optional per-value `stock_check: "live" \| "none"` (addon lane only; absent = `live`). phase2i rows keep the exact text (gate); a `none` declaration omits it; delivery identities unchanged (`fee07438…`, `6f4414d1…` with and without the field) |
| R1-2 | `verify_addon_settings` can run a real package and values file through the exact scanner, evaluation, deliveries and page model | TRUE | `-Package <dir> -Settings <file>`: Missions phase2i, Octavia and Frost each 150/150 PASS (137 base + 13 external) |
| R1-3 | The gate scripts fail only because native tools and checkers see paths over MAX_PATH | TRUE | Baseline at a 213-character repository path: cl `C1083` / "The directory name is invalid" (CreateProcess cwd), derecomp/luau/g++ "Error opening". After R1: every gate that failed for path length PASSes at 213 characters |
| R1-4 | MSVC `std::filesystem` handles `\\?\` paths for create/copy/iterate/remove | TRUE | probe: a 541-character tree created, written, copied, iterated and removed |
| R1-5 | cl.exe accepts `\\?\` source paths | FALSE | `C1083: Cannot open source file: '\\verify_addon_settings.cpp'`; hence short copies for native tools |

**1. `stock_check` (display only).** `settings_core.hpp`: `StockCheck { Live, None }`, strict parse
(`stock_check-invalid[=<text>]`, `stock_check-only-for-addon-lane`), `stock_check_declared` for reports.
`settings_ui_core.hpp` `value_tooltip`: addon rows append `live_stock_sentence` only for `Live`. The host enforces
nothing and delivers nothing new; the addon keeps its own rule (CONTRACT_PHASE1 item 11). A DLL before R1 (e.g.
`d2f22650`) rejects the field as `unknown-field=stock_check`, i.e. that package's settings capability only (compiled
values). Generator change (not made here; ability-editor owner): `CONTRACT_PHASE1.md` "Revision R1".

**2. `verify_addon_settings.ps1 -Package <folder> [-Settings <file>]`.** Runs the regression (phase2i fixtures), then
copies the folder into an empty `CustomScripts\Packages\<folder>` and the file to `Settings\<folder>.json`, scans with
the exact `packages.cpp`, and prints `LOG` (operational lines), `DECL` (with `stock_check`), `REJECT`, `MEMBER`,
`DELIVER` (`context.settings[...]`) and every `ROW` with its tooltip. Checks: accepted, declarations accepted, file
found and valid, no value rejected, a delivery for every addon member that declares values, labels/tooltips within
budget, and the live-stock sentence exactly on addon rows with `stock_check` live.

**3. Long paths.** `RENOVICE_TOOLCHAIN/gate_paths.ps1` (dot-sourced): `Get-GateScratch` (`%TEMP%\rnvg\<8 hex of the
repo path>\<gate>`, recreated per run, refuses reparse points), `Copy-GateSources` (mirror with the same relative
layout so `#include "../../renovice/..."` and `require("./...")` resolve), `Copy-GateInput`, `ConvertTo-GateLongPath`.
Applied to every gate that runs a native tool on repository paths: `verify_addon_settings`, `verify_script_packages`,
`verify_multi_target_addon`, `verify_injection_core`, `verify_config_core`, `verify_target_root_binding`,
`verify_detour_relocatability` (checker only), `verify_scripts_ui_core`, `verify_scripts_ui_bridge`,
`verify_script_settings_bridges`, `build_callback_runtime`, `build_automatic_damage_runtime`. The two C++ checkers
with work trees also use `\\?\`. Tool outputs of record (bridge `.lua_B`, semantic render, `injection/generated/*`)
are copied back byte for byte; `git status` shows none of them changed after the full gate run. Gate binaries no
longer land in `RENOVICE_TOOLCHAIN\bin\{settings,injection,config,runtime}`.

**Gates and build.** Full `build_private.ps1` gate list 29/29 PASS at the repository path (99 characters). Same list
from a `git ls-files` copy at a 213-character path: 27/29, all path failures gone; the two remaining
(`verify_dependencies`, `verify_manifest`) need `.git` and the legacy archive, which the copy does not carry (not path
related). Release build `build_private.ps1`: `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`, 5,562,880 B,
`ed2a996d92b4b73ef2567945ecb0d709241e0d7746902079ad982a270e6eddb5`. The V1 bridge is byte-identical
(`9c1450ed…`). Staged in `work/staging/editor-phase2-3/` (previous `d2f22650` files in `older/`).

**Limits (exact).** `verify_detour_relocatability` still reads the Soup headers and `soup.lib` (17 MB build
product) in place, so it holds up to a repository path of about 200 characters. `verify_dependencies`/`verify_manifest`
were not tested beyond MAX_PATH (git-based). `%TEMP%` itself must be short (it is 34 characters here). The Release
build (Sun/clang under `int\`) was not made long-path safe; it is not a gate. U-1 stays UNRESOLVED (live).

## Follow-up R2 (2026-09-30): stock scroll contract, one-value pages, member labels

Trigger: live feedback on DLL `ed2a996d…` + bridge `9c1450ed…` (installed; rows render natively, settings load).
(1) The flat list had no scroll bar, ran off the bottom of the screen and ignored the mouse wheel. (2) Member switches
read "Exact replacement:" and "Mission tunables: Purgatory,". (3) A tooltip overlapped the next TITLE. (4) The Survival
reward interval (150) and Lantern tier-up (90) showed an INPUTBOX, the warrior level an INPUTCOUNT. Offline only;
nothing was deployed, pushed or written to a game folder.

Stock evidence: 44.0.2 `Lotus_Interface_ThemedGenericSettings.lua_B` (`397f46de…2d3d`) rendered with
`derecomp decompile-mod-u44` (`a788f061…`), render `aaaf0132…e767`; `LotusUtilities` (`236b511d…c106`) for the type
enum. Pre-44 NSTM render (`RENOVICE_SCRIPTING/RESEARCH/NATIVE_SETTINGS_TOGGLE_MAP_2026-08-27/decompiled/…`,
L4880-4940) has the same logic. Excerpt with line numbers: `evidence-r2/ThemedGenericSettings_44.0.2_scroll_contract_excerpt.luau`.

| ID | Hypothesis | Result | Evidence (44.0.2 render lines) |
|---|---|---|---|
| R2-1 | The scroll bar needs uniform row heights and no INPUTBOX; our mixed rows (TITLE 24, SPACER 32, INPUTBOX 108, others 44) and the INPUTBOX editors switch it off | **TRUE** | `Update` (L4705-4880): `uniform = true`; per element `h = mHeight or v47[mType]` with `v47 = {44,44,44,44,24,108,8,44,87,84,44}` (L96-114; types from `LotusUtilities` L311-336: 5 = TITLE, 6 = INPUTBOX, 7 = SPACER). The flag stays true only while `h` equals the previous height and the row is neither INPUTBOX nor multi-line. Only when `UniformElementHeights` is true and there are more than 14 rows does it set `mVisibleElements = 14`, `AttachScrollBar("Container.ScrollBar", -5)`, `EnableSmoothScroll()` and the 600 px mask. Otherwise it hides the scroll bar and sets the mask to `GetMovieHeight()`. The layout (L1116-1146) then sizes the panel from the sum of every row height, so it runs off screen. The wheel handler `onKeyDown_MENU_MOUSE_Z` (L5523-5540) scrolls only when `mScrollBar` exists. |
| R2-2 | The 560 px row fit is what decides overflow | FALSE | The `< 560` visible-count loop runs only in the non-uniform branch (L4823-4845), and its result is never used to attach the scroll bar. Non-uniform `CalculateY`/`CalculateScrollBarHeight` overrides exist (L4072-4145) but are unreachable from `Update`. |
| R2-3 | The child-movie open bypasses the container sizing | FALSE | `Update` runs the same decision for every open; the bridge sets title, callbacks and the elements function exactly like V10. |
| R2-4 | The element count is below a threshold | FALSE | The phase2i page had 21 rows (> 14); the count is only read after the uniform test. |
| R2-5 | The search box changes the layout decision | FALSE | `ShowHideSearchBox` toggles the box; `Update` never reads it. |
| R2-6 | No stock row type edits a float inside a uniform list | TRUE | GenericSettings has no SLIDER branch (design table); INPUTCOUNT steps by 1 and floors typed text (L4285-4320, L5560-5620); INPUTBOX always breaks uniformity. |
| R2-7 | Member labels are cut by the page model, not the loader | TRUE | `append_package_switches` used `fit_words(label, 40)`; the loader allows 128. |
| R2-8 | The tooltip overlap is stock | TRUE (static) | GenericSettings only sets `_T.gToolTip = mTooltip` on focus (L1692-1697); the shared tooltip owner (used by 20+ stock screens) draws it. No per-row layout exists to change; left as is. |
| R2-9 | The two timers show INPUTBOX because the registry types them float | TRUE | Registry `survival.reward_interval` and `lantern.tier_up_interval`: `limits.integer=false`, `ui.type=float`, `ui.editor=INPUTBOX` (engine seconds, fractions valid). Per the design, float → INPUTBOX, int ≥ 0 → INPUTCOUNT; the generator is correct. Retyping them to int would remove a valid capability, so they stay float and now open a value page. |

**Fix (native, no fake scrolling).**
- Bridge (`ScriptSettingsBridgeV1.luau`, same name and host contract): `UNIFORM_ROW_HEIGHT = 44`; TITLE and SPACER get
  `mHeight = 44`, the stock default of CHECKBOX, TOGGLE, BUTTON and INPUTCOUNT. BUTTON rows carry `mLocked` (the stock list
  `mOnSelectedCallback` returns before `mCallback` for a locked row, L1905-1928). Bytes `9c1450ed…` → `2e337a43…` (5,441 B).
- Page model (`settings_ui_core.hpp`): a float or negative-int value is a BUTTON with the editor label
  (`Reward interval (stock 300 s)`), its current value as the sub-label (`150 s`) and action
  `open:val:<Folder>/<id>`. That opens a one-value page `val:<Folder>/<id>` holding only the validated INPUTBOX. It
  opens through the existing nested open path (`openPage`, depth + 1), its close only stages, and the root close still
  applies. Int ≥ 0 (INPUTCOUNT) and enum (TOGGLE) stay inline. The flat page drops SPACER rows (each row now takes one
  of the 14 visible 43 px slots, and every section starts with a TITLE). `stock_row_height`, `stock_uniform_heights`
  and `stock_scroll_attached` model the stock decision. The host logs `page PASS … uniform=<0|1> scroll=<0|1>`.
- Member switches: `member_row_label` keeps a label that fits. A longer one is cut at a word without trailing
  `, ; : ( - /`. `member_tooltip` = full label, "Replaces a stock script." for replacements, the Off sentence, the file,
  then `Sections: <label> (<n>), …` from the member's own declarations (compact `Sections: N (M values).` over budget).
  There is no manifest schema change, so older DLLs accept the same packages.
- Producer rule, now gated: member labels ≤ 40 (ability-editor Phase 2j, below).

**Gates.**
- `verify_addon_settings.ps1`: 137 → 147 regression checks. New: the stock scroll model; flat/root/package/group pages
  uniform; phase2i flat page (19 rows) scrolls; float and negative-int BUTTONs and their one-row value pages; value
  pages only for INPUTBOX values; flat BUTTONs only `open:val:`; member label cut and tooltip.
- `-Package` adds 3 checks and prints `VALPAGE` and `SCROLL` lines: the flat page is uniform, every value BUTTON opens
  exactly one INPUTBOX with the same label, and member labels fit 40.
  - Missions phase2j: 163/163.
  - Octavia and Frost (staged): 163/163 each. Frost's float now opens a value page.
  - The old phase2i package fails only the member-label rule (negative control, expected).
- `verify_script_settings_bridges.ps1`: pins the uniform heights, the `val:` page route and the log fields.
- Full `build_private.ps1`: 29/29 gates. `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`, 5,581,824 B,
  `7594fbf2ad2b29bea6cd1b828c76c80573185914208afa725a263e7d6114c439`.

**Limits (exact).**
- The value BUTTON's sub-label shows the value as of the page build. The stock list is built once per open, so after
  editing on the value page the root row keeps the old text until the next open (the staged value applies).
- The one-value page uses the nested child open, which N-1 has not proven live. If a nested push fails, `openPage`
  returns false and only float editing is unavailable.
- Every row is a 43 px slot, so TITLE rows sit in a taller slot than stock's 24 px.
- Live checks pending:
  - the scroll bar, wheel and stick on the Missions page;
  - the value page open, Confirm and staging;
  - the look at 1080p and 1440p.
