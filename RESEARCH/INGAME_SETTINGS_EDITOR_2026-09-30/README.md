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

## Follow-up R3 (2026-09-30): BUTTON rows crashed the stock draw; stock-render regression harness

Trigger: live session on DLL `731fdb11…` (branch `feat/lua-call-retire-r4-2026-09-30` `e935739`, includes R2 `fb9655e`) and
bridge `2e337a43…`, with the full Missions package (`package.json` `abf62770…`, 281 values), Octavia and Frost installed.
SCRIPT SETTINGS opened (`page PASS id=flat rows=627 search=1 uniform=1 scroll=1`). The search box sat above the panel,
every float BUTTON row showed a white bar "OPTION <value>", rows were stale and out of order, and the game raised a
script error. Offline only; nothing was deployed, pushed or written to a game folder. Branch
`fix/settings-r3-button-render-2026-09-30` from `e935739`.

EE.log (session of 2026-09-30 12:10): `ThemedGenericSettings.lua:991: attempt to perform arithmetic (sub) on nil and
number`, first at 190.088 on open (stack 991, 724, 948, 1722, 1770, native call, 1599), again at 191.119 on scroll (991,
724, 948, 1048, 1075, 161, 169, 384, 1751). `renovice_fault.log` holds only the armed line; there is no crash dump and no
`Diagnostics\` record. The failure is the stock script error (EE "Application error messages"), not a native fault.

Stock evidence: 44.0.2 `Lotus_Interface_ThemedGenericSettings.lua_B` (`397f46de…2d3d`) and
`EE_Interface_Components_List.lua_B` (`2f5237c6…345c`), rendered with `derecomp decompile-mod-u44` (derecomp
`54cab5a8…`). Source lines were mapped through the bytecode line table (per-prototype `lineinfo`/`abslineinfo`) to
prototypes and word PCs, then to `derecomp ir-u44` and the render. Render closure `cN` is prototype `N-1`.

| Stock line | File | Prototype (render) | What it is |
|---|---|---|---|
| 991 | ThemedGenericSettings | 46 (`c47`, the list `mElementDrawCallback`), word PCs 775-786 | BUTTON branch: `SetMemberNumber(clip, "SubLabel", 0, element.mButtonWidth - Ternary(mSubLabelOffset ~= nil, mSubLabelOffset, 100))` (render L2542-2567) |
| 724 | List | 45 (`OnDraw`) | calls the element draw callback |
| 948 | List | 54 (`Redraw`) | per-element draw loop |
| 1722 | ThemedGenericSettings | 62 (populate, render L4698-4913) | `list:Redraw()`; the next statement `v49()` is the panel layout |
| 1770 / 1599 | ThemedGenericSettings | 65 (interpolation end) / 59 (`Update`) | open path: `Update` -> movie tick -> populate |
| 1048 / 1075 | List | 62 (`ScrollValueChangedCallback`) / 64 (scroll-bar closure in `AttachScrollBar`) | scroll path |

| ID | Hypothesis | Result | Evidence |
|---|---|---|---|
| R3-1 | The nil operand at line 991 is `mButtonWidth` of a BUTTON row with `mSubLabel` | **TRUE** | The only arithmetic in PCs 775-786 is `SUB R7 = R8 (mButtonWidth) - R1`. ThemedGenericSettings never assigns `mButtonWidth`; the caller must. The only stock user of a BUTTON `mSubLabel` sets it (ThemedTennoCustomization `mButtonWidth = 400`). R2 made every float value a BUTTON with `mSubLabel = "<value>"` and no width |
| R3-2 | The white "OPTION" bar is the aborted draw, not a wrong frame or type | **TRUE** | Frame `button` is set first (render L2513-2519) and the sub-label text just before the error (L2549). The label text (L3728-3744), the `.Btn` id and callbacks and the `Bg` `RectInnerColor` (L3688-3719) come after the type branch and never ran. "OPTION" is the SWF default label |
| R3-3 | Stale rows are recycled clips whose draw was aborted | **TRUE** | One error aborts the whole `Redraw` loop: rows after the first BUTTON keep the previous owner's label and position, and a clip re-used by a BUTTON keeps its old label ("Frost package" with "1.75x"). The harness negative control reproduces both ("shows label 'Custom value 1' instead of its own", "background was never recoloured") |
| R3-4 | The search box is outside the panel because the layout never ran | **TRUE (static)** | Populate is `v59(); list:Redraw(); v49()`. Only `v49` sizes `Container.BgFill`, positions `Container` and sets `Container.SearchBox` x = panel width - (200 + 2). The error inside `Redraw` skipped it on open |
| R3-5 | "SetCallbacks on unknown clip …MenuEntryN.Btn" is caused by our rows | **FALSE** | Stock List `Redraw` duplicates a clip (`duplicateMovieClip`) and binds its `.Btn` callbacks in the same call (List render L2127-2150). The same warnings appear at 70.1 s and 81.8 s in the same session on opens without any error. `MenuEntry18…115` are the clips duplicated while scrolling. Benign and unchanged |
| R3-6 | BUTTON rows cannot coexist with a scrolled uniform list | **FALSE** | Without `mSubLabel` the BUTTON branch runs no arithmetic (its `else` hides `SubLabel`). The harness scrolls 60 mixed rows (12 BUTTONs) through every position without an error |
| R3-7 | The host scrambled the section order | **FALSE** | The page-model order is unchanged (packages, then ordered groups). The order on screen came from clips left at old positions by the aborted redraws |

**Fix.**
- Bridge (`ScriptSettingsBridgeV1.luau`, same name and host contract): it never builds `mSubLabel`. `buttonLabel(spec)`
  folds a host `subLabel` into the label (`"<label>: <detail>"`), so the bridge alone is safe with DLL `731fdb11` and
  older. Bytes `2e337a43…` -> `739d8177…` (5,572 B).
- Page model (`settings_ui_core.hpp`) and host (`injection.cpp`): `Row::sub_label` and the `subLabel` descriptor field
  are removed. `button_label(label, detail)` gives `"<label>: <detail>"` within 40 characters and cuts the label at a
  word, never the detail; a detail that cannot fit opens the tooltip. Value BUTTONs use `value_button_label`:
  `"Reward interval: 150 s (stock 300 s)"`, else `"<label>: <value>"` (the tooltip already starts with the stock value).
  The value page INPUTBOX keeps `editor_label`. The nested root, package and group BUTTONs use the same rule.
- Floats stay on their one-value INPUTBOX page (R2). The scroll bar, wheel and uniform heights are unchanged.

**Gates.**
- New `RENOVICE_TOOLCHAIN/scripts_ui/verify_script_settings_render.ps1` (in the `build_private.ps1` list). It runs the
  bridge under test through the real stock renders (`settings_render/stock/*.u44.luau`, hashes in `STOCK_INPUTS.txt`,
  re-rendered and compared when the corpus is present) with a recording Flash movie and engine stubs
  (`settings_render/harness_*.luau`).
  - Page: 60 rows (TITLE, CHECKBOX, INPUTCOUNT, TOGGLE, locked, 12 BUTTONs, two of them with a legacy `subLabel`).
  - Flow: `PushChildMovie` -> `Initialize` -> the bridge's `Execute` calls -> `Update` ticks -> populate -> `Redraw` ->
    draw -> layout. Then every scroll-bar position both ways (`ScrollValueChangedCallback`, the live crash path) and
    the stock wheel handler.
  - Checks: no Lua error; the stock list holds every row; `UniformElementHeights`, 14 visible rows and the scroll bar;
    the layout ran (search box x inside the panel width); per drawn clip the stock frame for its type, its own label,
    the background recoloured, no leftover sub-label, no clip shared. 8,825 checks PASS.
  - Negative control: the R2 bridge source (`fixtures/ScriptSettingsBridgeV1.r2-2e337a43.luau`, which compiles to the
    installed bytes) must fail with `attempt to perform arithmetic (sub) on nil and number` at render line 2566 (stock
    line 991, the `mButtonWidth - offset` statement). It also shows the live symptoms: label never set ("OPTION"),
    stale labels, no background.
  - Harness-only render corrections (the fixtures stay the exact derecomp output; each patch must match exactly once):
    (1) List `CreateList` pc 143 `SETLIST A=3 B=4 C=2` rendered as `c87v3 = {c87v4}` (a fresh table) instead of an
    append; (2) List `Redraw` pc 308-311 by-value `CAPTURE` of R19/R21 rendered as shared locals the loop overwrites;
    (3) DE VM `LENGTH` of nil emulated as 0 (`__de_len`): stock evaluates `#element.mAlignment` for every drawn TITLE,
    and stock AllianceView draws TITLE rows without `mAlignment`, so the live VM cannot raise there. (1) and (2) are
    toolchain defects, reported for a separate fix.
- `verify_addon_settings.ps1`: 147 -> 149 regression checks (the BUTTON label rule; the value BUTTON label with and
  without the stock suffix; D1, phase2i, value-page and nested checks updated). `-Package` with the installed packages
  (read-only copies): Missions 165/165 (613 rows, 78 value BUTTONs, longest label 40), Frost 165/165 ("Bonus per Cold
  stack: 50x (stock 0x)"), Octavia 165/165.

**Limits (exact).**
- The harness simulates the engine (Flash members, timers, the scroll-bar component, themed widgets). The stock script
  logic is real. Passing it does not prove the live look.
- R3-4 is static; the live search-box position after the layout runs is pending.
- DE `#nil` = 0 is inferred from stock usage, not measured.
- The Phase 0 probe bridge (`ScriptSettingsProbeP0.luau`, probe builds only) still builds BUTTONs with `mSubLabel` and no
  `mButtonWidth`, so it would hit the same error. It is not part of the main build and was left unchanged.
- Live checks pending: open SCRIPT SETTINGS; scroll to the end with the bar and the wheel; every row shows its own label;
  float BUTTONs read "<label>: <value> (stock …)"; no Script Error in EE.log; the search box sits inside the panel; the
  value page opens from a float BUTTON.
