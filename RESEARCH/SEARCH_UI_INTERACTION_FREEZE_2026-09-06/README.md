# Search UI interaction freeze investigation — 2026-09-06

## Scope and change boundary

The initial investigation was read-only with respect to the installed Warframe/OpenWF runtime. The later authorized A/B renamed only the Scripts settings bridge while the game was closed, captured the recurrence, and restored the exact bridge bytes. A V35 native bootstrapper candidate was subsequently built in the RENOVICE deployment workspace and deployed only after `Warframe.x64.exe` exited. No game Lua module or `ScriptStates.json` was changed.

The reported symptom is an intermittent searchable card/selection menu that remains visible while its search field and cards stop accepting interaction. The game itself continues running. This is distinct from the earlier fatal exact-search crash involving inputs such as `Limbo` and `00`.

## Current conclusion

An exact Lua error occurred in the same kind of search UI described by the report:

```text
14902.862 Script [Error]: Script Error: /Lotus/Interface/Background.lua:5698: attempt to concatenate boolean with string: In /Lotus/Interface/Background.lua::SearchAndSortSearchBoxTextInput(5698) originating from /Lotus/Interface/GenericVendor.lua::SearchAndSortSearchBoxTextInput
```

The game continued after the error and `Background.lua` continued updating. This strongly fits a callback abort that can strand the currently open vendor/search movie without stopping the game process.

A second, explicitly marked live reproduction was captured at `2026-09-06T19:53:30Z`. It confirms the wider failure class: while `LoadOutRedux` was open, five different UI producers failed through the same `Background.lua:5698` boundary. The visible movie later closed, while input continued behaving as if a menu owned it.

The bridge-disabled A/B reproduced the fault again at `2026-09-06T21:45:39Z`. The current runtime generation explicitly logged `Scripts UI disabled`, yet the Upgrade Cards transition stopped after its resource load and before movie creation. Therefore the V10 bridge, SCRIPTS row, and TopMenu attachment path are not required for this failure.

A third recurrence was captured at `2026-09-06T21:59:05Z` after the exact bridge was restored. Adding the final character in `limb` -> `Limbo` produced the reported repeatable hitch, and `EE.log` recorded a table entering `Background::LeftPanelInventorySelectorSearchTextInput`. The current RENOVICE generation contains no F9 request or post-startup reload. This proves that an explicit reload and a replacement of the stock search modules are not required.

Source audit then identified two native correctness failures. V34 runs `_T` generation maintenance every 100 ms with no reload request, even though a VM execute return can still be nested inside a native Lua C call such as `RunScript`. It also captured raw stack pointers before `check_stack()` in guarded loader/lifecycle paths even though stack growth may relocate those pointers. V35 removed the idle work inside `injection::drain()` and fixed those pointer lifetimes, but the same UI freeze recurred.

The V35 recurrence exposed the remaining scheduler path. A live CDB capture found the primary game thread in Pluto coroutine yield/unwind frames reached from `bgscript->tick()`. The exact return address is `WTSAPI32+0x2C3FE`; disassembly of the pinned V35 DLL shows that address is the instruction immediately after the background-script tick call. V35 had made `drain()` idle, but the enclosing callback still replaced DE VM handlers and ticked the background and ordinary Pluto scripts after every accepted DE interpreter return. V36 removed that scheduler from the DE return callback, and the user reported that the menu freeze no longer recurred in the isolation run. V36 was not a complete fix because it also paused original OpenWF Pluto behavior.

Comparison against upstream OpenWF explains why Pluto had been clocked by `UpdateFlashMarkers`, but V37 disproved that placement for the pinned U43 client. V37 restored working dashboard/background/autostart behavior, then exact `Limbo` reproduced the old execute-at-zero crash at 38.812 seconds with `c.cont=0x0`. V23 and V37 together establish that the method-table replacement itself must remain absent. V38 instead ticks the full Pluto scheduler after the pinned native Application frame call returns, with exact UI owner-thread and idle-`base_ci` gates; RENOVICE transactions remain on the separate pending-only DE callback.

## Hypothesis ledger

| ID | Hypothesis | Evidence | Result |
| --- | --- | --- | --- |
| H1 | The old `UpdateFlashMarkers` bootstrapper hook returned and caused this regression. | Current `renovice/injection.cpp` and `renovice/injection_core.hpp` contain zero `UpdateFlashMarkers` or legacy HUD-detour matches. The runtime log says `safe runtime tick registered: outer VM return; HUD method untouched`. The live DLL matches documented V34 identity. | **False for the inspected build.** |
| H2 | `ScriptsSettingsBridgeV10` itself remained open or failed and captured UI input. | The captured runtime session has repeated `open PASS`, `elements PASS`, and `close PASS` lifecycles. The relevant opens end with `close-no-changes staged-cleared`. | **False for the captured lifecycles.** |
| H3 | A non-string argument reached the stock `Background.lua` cross-screen argument formatter. | `EE.log` records boolean, table, and `nil` concatenation failures at `Background.lua:5698`. Decompiled stock bytecode builds an argument string with `buffer = buffer .. "," .. argument`, without validation or conversion. | **True.** |
| H4 | The boolean failure occurred through the vendor search callback while `GenericVendor.swf` was open. | `GenericVendor.swf` was created at log line 66243. At line 66255, `GenericVendor.lua::SearchAndSortSearchBoxTextInput` originated the boolean-concatenation error in `Background.lua::SearchAndSortSearchBoxTextInput`. | **True.** |
| H5 | The shared `Background.lua:5698` failure occurs during the reported intermittent UI freeze. | The marked live capture recorded five failures at this boundary while the user observed the frozen loadout UI and stale menu-style input. | **True for the marked reproduction.** |
| H6 | Globally coercing every forwarded argument with `tostring` is a justified fix. | The same formatter also received tables and `nil`, and a different occurrence attempted to call a string. Coercion would hide contract violations and could send incorrect serialized values to unrelated screen methods. | **False.** |
| H7 | The marked reproduction was only waiting for large card/loadout resources to finish. | The large loadout resource operations completed by approximately 73.3 seconds. The shared `Background` failures began later, at 79.9 seconds, and continued through 91.5 seconds. | **False.** |
| H8 | Opening the custom SCRIPTS settings screen directly triggered the marked reproduction. | The current runtime generation contains no SCRIPTS settings `open`, `elements`, `completion`, or `close` event, and no TopMenu attach/row-append event. | **False for this reproduction.** |
| H9 | An always-active UI/VM integration boundary remains a viable cause. | The original reproduction had the bridge and target-addon observer active. The bridge-disabled recurrence removed the bridge but retained the target addon and native `RunScript` observer. | **True as a narrowed boundary, not yet a root-cause attribution.** |
| H10 | The V10 bridge or SCRIPTS/TopMenu attachment feature is required for the freeze. | The bridge-disabled generation logged `Scripts UI disabled: required NAMECALL bridge absent; stock TopMenu preserved`, then reproduced the same failure class during `LoadOutRedux` → `UpgradeCards`. | **False.** |
| H11 | An explicit F9/SCRIPTS reload is required for the exact-search hitch. | The third generation has startup and target activation records but no F9 request, reload queue, or later generation commit before `Background::LeftPanelInventorySelectorSearchTextInput` received a table. | **False for the third recurrence.** |
| H12 | V34 performs unsolicited Luau work while otherwise idle. | `drain()` called `maintain_current_vm_generation(state)` every 100 ms when both reload and startup were false. That routine reads `_T`, checks the bridge, and can queue/rebind target addons. | **True in V34 source.** |
| H13 | Every return accepted by the V34 VM hook is proven to be outside a native Lua caller. | The hook hard-codes `outer_interpreter_return=true`. A `RunScript` native call may invoke the interpreter and receive control back before the native call itself returns to its Lua caller; `ci == base_ci` was deliberately not required. | **False; the claimed boundary proof is incomplete.** |
| H14 | Native guarded loader/lifecycle code remains valid if `check_stack()` relocates the VM stack. | V34 saved `guard.base = state->outtop` before `check_stack()` and later restored/wrote through that raw pointer. The dormant global wrapper had the same ordering. | **False in V34 source; corrected in V35 candidate.** |
| H15 | Making `injection::drain()` idle and rebasing raw stack pointers fixes the live freeze. | The user reproduced the same stuck searchable-menu/input state under the pinned V35 process after repeated menu transitions and typing `codha`. | **False.** |
| H16 | The complete V35 DE-return callback is idle when no RENOVICE transaction is pending. | Source shows `drain()` returns, after which the callback still swaps `luau_L`, replaces DE panic/error handlers, polls legacy hotkeys, and ticks `bgscript` plus ordinary Pluto scripts. CDB caught the primary thread returning from `bgscript->tick()` during the freeze. | **False.** |
| H17 | Periodic OpenWF/Pluto work from the DE interpreter-return callback is required for the delayed UI corruption. | V36 removed the scheduler from that boundary while retaining pending RENOVICE transactions, and the user reported that the freeze disappeared during the isolation run. | **Supported as a boundary result; V36 lacks Pluto parity and is not a completed fix.** |
| H18 | Original OpenWF requires the Pluto scheduler to run in the UI VM. | Upstream OpenWF `0.13.6-hotfix-2` and the U43 source branch both hook `UpdateFlashMarkers`, set the active Pluto state, and tick the background and ordinary Pluto coroutines there. | **True.** |
| H19 | Restoring upstream UI-VM Pluto while excluding RENOVICE drain work from that hook preserves Pluto behavior and the V36 menu result together. | V37 restored dashboard/background/autostart behavior, then typing exact `Limbo` crashed at 38.812 seconds. The native fault dump has the same null-continuation family as V21/V22. | **False live.** |
| H20 | Full Pluto can run after the native Application frame returns while the Lua method table and broad DE-return scheduler remain untouched. | The exact executable hash is pinned; the main-loop pattern is unique; the resolved vtable call contains the complete UI/Lua stack seen in the V37 crash. V38 requires the captured UI owner thread and idle `ci == base_ci`; all offline gates pass. The live V38 process serves the dashboard and reports the configured `Chat Commands.pluto` autostart coroutine as running with no native fault during the initial watch. | **Pluto startup true live; exact-search and transition acceptance pending.** |

## Evidence

### Installed runtime identity

- Live `wtsapi32.dll`: 4,391,424 bytes, SHA-256 `DE997709FBB54795318AF5EA33AEA14C9AEE7161EFDFC365A5D66CCE44934C34`.
- Live `_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B`: 1,111 bytes, SHA-256 `153E5E580FB0D98DDD63C0DE92D46398F6B87B721E69B51885719B50EEF04C82`.
- No `Background.lua_B` or `GenericVendor.lua_B` replacement exists in the active `CustomScripts` root or `Inject` folder.
- The only active injected modules are the internal settings bridge and the Mallet target addon. The root contains the Octavia Amp replacement, Riven lock script, and Octavia Metronome replacement. `Diagnostics/TopMenu.current.lua_B` is diagnostic output, not an active root or Inject module.

The full identity inventory, including the pinned corpus inputs and decompiler used for this investigation, is in [`artifacts/identity.sha256.tsv`](artifacts/identity.sha256.tsv).

### Runtime bridge state

The captured session initialized the outer-VM-return scheduler with the HUD method untouched, injected the bridge successfully, and completed multiple settings lifecycles cleanly. The selected exact log rows are in [`artifacts/renovice_bridge_clean_lifecycle.txt`](artifacts/renovice_bridge_clean_lifecycle.txt).

This evidence rules out a bridge failure for those specific opens. It cannot rule out every future timing or focus failure.

### Engine log state

The relevant sequence is preserved in [`artifacts/ee_generic_vendor_failure_context.txt`](artifacts/ee_generic_vendor_failure_context.txt):

1. The `Crafting_Favors` conversation option is selected.
2. `GenericVendor.swf` is created.
3. Vendor resources finish loading.
4. `GenericVendor.lua::SearchAndSortSearchBoxTextInput` originates a call into `Background.lua::SearchAndSortSearchBoxTextInput`.
5. `Background.lua` attempts to concatenate a boolean with a string.
6. The process continues, and later `Background.lua` updates are logged.

All nine captured `Background.lua:5698` errors are in [`artifacts/ee_background_5698_errors.txt`](artifacts/ee_background_5698_errors.txt). They include boolean, table, and `nil` concatenation failures plus attempts to call a string. This wider set is why a global conversion patch is not justified by the evidence.

### Marked live reproduction

The raw marked capture is under [`captures/20260906-195330-036Z`](captures/20260906-195330-036Z). Its manifest records the user's observed state and hashes the copied logs. The condensed loadout timeline is in [`artifacts/live_repro_loadout_freeze_timeline.txt`](artifacts/live_repro_loadout_freeze_timeline.txt), and the supplied visual state is preserved as [`artifacts/live-repro-stale-ui-input-ownership-20260906.png`](artifacts/live-repro-stale-ui-input-ownership-20260906.png).

The captured sequence is:

1. `LoadOutRedux.swf` opens at 70.030 seconds and subscribes to `LoadoutReduxInputFilter` at 70.088 seconds.
2. Initial resource work completes. The later loadout rebuild completes by 73.278 seconds.
3. `Background.lua:5698` fails from `ImeTip::Update` at 79.910 seconds with `nil`.
4. The same boundary fails from `Notifications::Update` at 81.017 seconds with a boolean.
5. It fails from `ThemedContextMenu::Update` at 85.253 seconds with `nil`.
6. It fails from front-end `OnUpdate` at 89.220 seconds with `nil`.
7. It fails from `ItemInfoPopup::Update` at 91.518 seconds while attempting to call a string.
8. The pod/movie closes at 94.319 seconds. The user reports that movement input still drives menu-style pointer navigation against an invisible/stale UI owner.

The current RENOVICE generation started successfully and registered the bridge, but it never logged a TopMenu attach, SCRIPTS row append, or SCRIPTS settings open before the reproduction. That narrows the next test to always-active integration, rather than the custom settings form itself.

### Bridge-disabled A/B recurrence

The raw A/B capture is under [`captures/20260906-214539-483Z`](captures/20260906-214539-483Z). Its manifest records the symptom and hashes `EE.log` as `F036FB6057CB6BDC747FA7D4EEC25EB9E5B5CD931AFECAF90A701212D3986AEB`. The condensed proof is in [`artifacts/bridge_disabled_recurrence_timeline.txt`](artifacts/bridge_disabled_recurrence_timeline.txt).

The exact transition boundary is stronger than the earlier capture:

1. Current-generation runtime line 37602 proves that the bridge was absent and stock TopMenu was preserved.
2. `DiegeticUpgradeCards.swf` finished loading at 275.371 seconds.
3. `LoadOutRedux` requested `GoToScreen(screenName=UpgradeCards)` at 275.373 seconds.
4. The HUD was hidden and input returned to `MenuInputFilter` by 275.636 seconds.
5. No Upgrade Cards movie creation or `ScreenOpened` event followed through the end of the captured log. The game remained responsive.

Before the failed transition, `Background.lua:5698` again received invalid values from unrelated producers: boolean, `nil`, userdata, and a string used as a function. `ImeTip`, `ThemedContextMenu`, `ChatRedux`, `ItemInfoPopup`, and `Notifications` overlap the producer set in the earlier reproduction. This repeated cross-producer signature is evidence of shared execution-state damage or exposure; it is not proof that any one producer owns the fault.

### Exact-match hitch recurrence after bridge restoration

The raw third capture is under [`captures/20260906-215905-851Z`](captures/20260906-215905-851Z). Its manifest preserves the user's exact `limb` -> `Limbo` observation and hashes `EE.log` as `5644CEBA3917DCB72574E4CB401D74D5A014FFDDA681B951D7A1048712212CB7`. The screenshot is preserved as [`artifacts/live-repro-filter-hitch-stale-cards-20260906.png`](artifacts/live-repro-filter-hitch-stale-cards-20260906.png), and the condensed proof is in [`artifacts/exact_match_hitch_native_boundary_timeline.txt`](artifacts/exact_match_hitch_native_boundary_timeline.txt).

The direct sequence is:

1. Startup generation 1 loads the bridge and target addon successfully.
2. Twenty sampled `RunScript` calls pass through with `sync=false`; there is no F9 request or later reload transaction in this generation.
3. Resource and grid work completes between approximately 60 and 63.6 seconds.
4. At 69.404 seconds, `LoadOutRedux::LeftPanelInventorySelectorSearchTextInput` forwards a table into `Background::LeftPanelInventorySelectorSearchTextInput`, whose string packer aborts.
5. At 71.857 seconds, another `Background.lua:5698` call receives `nil` from `AcceptInvitePanel::Update`; the game remains responsive.

The screenshot shows the practical stale state: the left card results and the right equipped/details view no longer represent one visibly completed UI update. The log does not contain the literal search text, so the `Limbo` term is user-observed evidence rather than a recovered log field.

### V35 native runtime candidate

The prepared candidate is [`RENOVICE_DEPLOYMENTS/RUNTIME_IDLE_LUA_FREE_V35_2026-09-07`](../../RENOVICE_DEPLOYMENTS/RUNTIME_IDLE_LUA_FREE_V35_2026-09-07). It preserves startup, F9, SCRIPTS commits, target-module activation, the bridge, and user script policy. When neither startup nor reload is pending, `drain()` now returns without reading or writing the DE VM. Stack-capacity calls also precede stored guard pointers, and pointer users that must survive stack growth are restored by offset.

The private x64 build passed with zero warnings and errors. Candidate DLL: 4,390,912 bytes, SHA-256 `2041C0A7D1B3257E7726FDC98B519D44DCB9F36F11AA007960DC90CA207A429E`. After the reproduction process exited, deployment and live-state verification passed at this exact hash; the bridge remained byte-identical.

### V35 live recurrence and exact native stack

The V35 hypothesis is false. The user switched repeatedly among frame, weapon, upgrade, and searchable-card menus. Typing `codha` in the melee selector displayed the filtered Coda Pathocyst result, then left the menu visible but noninteractive while the rest of the game continued.

The primary-thread CDB stack captured during that state contains Pluto's `lua_resume`, `unroll`, `luaV_execute`, `luaD_precall`, `lua_yieldk`, and `luaD_throw`, followed by `WTSAPI32+0xA3E9E` and `WTSAPI32+0x2C3FE`. Direct disassembly of the exact pinned V35 DLL resolves the latter without relying on a relinked symbol map:

```text
WTSAPI32+0x2C3ED  load bgscript
WTSAPI32+0x2C3F4  test bgscript
WTSAPI32+0x2C3F9  call WTSAPI32+0xA3E80
WTSAPI32+0x2C3FE  test returned boolean
```

Source at the same call site identifies `WTSAPI32+0xA3E80` as `owfScript::tick()` invoked for `bgscript`. The captured return address is therefore the instruction immediately after the background Pluto tick. The raw thread stacks, same-run EE snapshot, and exact V35 disassembly are under [`artifacts/v35-live-freeze-20260907-002605`](artifacts/v35-live-freeze-20260907-002605).

The EE snapshot independently records unrelated UI producers failing through `Background.lua:5698`: `LotusFrontEndGameRules::OnUpdate`, `ImeTip::Update`, `ThemedContextMenu::Update`, `ItemInfoPopup::Update`, `YareliQuest::PlacedComic`, and `LoadOutRedux::ItemFocused`. Errors include nil/table concatenation and attempting to call a string. Resource operations completed and the process continued logging afterward. This again supports shared execution-state corruption rather than six independent UI script defects.

After this run exited, an exploratory symbol-map relink accidentally replaced the on-disk live DLL with rejected hash `EDDA4DE50D4AA9F44971B59A7B64A00DF1D2EC93048222A378D6AD2C500286EF`. The log capture was preserved without falsely labeling that post-exit disk state as V35. The game DLL was then restored from the pinned V35 staging artifact and verified at `2041C0A7D1B3257E7726FDC98B519D44DCB9F36F11AA007960DC90CA207A429E` before the V36 deployment was prepared. No Lua file or script policy changed during the incident.

### V36 pending-only DE transaction isolation

V36 changes the authorization boundary, not the game scripts. `maybe_run_safe_runtime_tick()` returns before any callback when neither startup nor reload is pending. Its registered callback contains only `injection::drain(state)`. It no longer swaps `luau_L`, replaces DE panic/error handlers, checks OpenWF script hotkeys, or ticks background/ordinary Pluto coroutines.

This deliberately pauses periodic legacy OpenWF `.pluto` behavior during the cause-isolation run. The RENOVICE `.lua_B` replacement/addon snapshot, target observer, F9 queue, SCRIPTS bridge, and `ScriptStates.json` policy remain. The deployment changes only `Warframe/wtsapi32.dll`.

V36 candidate: 4,382,720 bytes, SHA-256 `CFBFB916C6449DF6A083609F3145E510750B75B9D4694777177E0E49B2A162CD`. Build, source, core, package, import, and deployment gates passed with zero warnings/errors. The user then reported that the freeze appeared fixed. This is positive isolation evidence against the mixed DE-return scheduler, but it cannot establish runtime parity because the original Pluto clock was absent.

### V37 upstream UI-VM Pluto restoration

V37 corrects the architectural overreach in V36. The original OpenWF
`UpdateFlashMarkers` hook is restored for its intended UI-VM work: Pluto
hotkeys, the background script, and ordinary running Pluto scripts. The hook
does not call `renovice::injection::drain()`, poll RENOVICE F9, or request a
RENOVICE reload. Startup and explicit F9/SCRIPTS work remain on the separate
pending-only DE transaction callback.

The embedded background source matches upstream OpenWF 0.13.6 content and the
repository LF form at SHA-256
`DC072A9E16937160A4F7DD6AB9A8B89077E3BE137362263ABF813282A2FDD015`.
The first V37 build was rejected because Git reported a CRLF conversion
warning. The source was normalized to LF and the final private x64 build passed
with zero warnings and zero errors.

V37 DLL: 4,390,912 bytes, SHA-256
`D110B8C0973E5F9CD5A4AA9F255EBAF6E71AABF47AD5F3288D9F7E0CAD1C19D9`.
Deployment replaced only the closed game's `wtsapi32.dll`. A before/after
SHA-256 inventory of all 16 live `OpenWF/CustomScripts` files reported zero
changes; the bridge remains
`153E5E580FB0D98DDD63C0DE92D46398F6B87B721E69B51885719B50EEF04C82`.

V37 is rejected live. It brought up the OpenWF dashboard at HTTP 200, listened
on port 6900, accepted its loopback connection, and started the configured
autostart Pluto script. Exact `Limbo` then crashed at 38.812 seconds. The
preserved `renovice_fault.dmp` is 67,459,507 bytes with SHA-256
`CE8029E8F43BE22692914CA752E802A121B25B18BBFB9761A9F9CE2A409A9C0D`.
The live DLL was restored to exact V36 afterward.

### V38 native Application-frame Pluto candidate

V38 removes every `UpdateFlashMarkers` reference and method-table write from
`main.cpp`. The broad DE VM return callback remains pending-only and contains
no Pluto scheduler work. The exact U43 executable has one match for the native
Application main-loop sequence at raw file offset `0xE6DEDD`; its virtual
`vtable[2]` frame call contains the full UI/Lua stack observed in the V37 dump.
V38 calls the original method first, then ticks Pluto only on the captured UI
owner thread when the saved UI state is idle at `ci == base_ci` with valid
stack bounds. Context restoration is scope-bound for exception paths.

V38 DLL: 4,394,496 bytes, SHA-256
`5D26AC989A9155B788BB5979093CE58DACAF5732000D33BFCEDE89143F12D61A`.
The private build completed with zero warnings and zero errors. Package,
executable-boundary, dependency, manifest, injection, SCRIPTS UI, config,
replacement, Riven, SWF, bridge, semantic/API, x64, and import gates pass.

V38 is deployed in the correct live game as the exact pinned DLL. The current
PID 7388 serves `http://127.0.0.1:6900/status` and reports both the configured
`samples/Chat Commands.pluto` autostart entry and the running
`OpenWF/Scripts/samples/Chat Commands.pluto` coroutine. Two status reads kept
the same running script, a 45-second process watch stayed responsive with CPU
advancing, and `renovice_fault.log` remained 90 bytes. This proves V38 Pluto
startup and scheduling reached the persistent script coroutine. It does not
yet prove the exact `Limbo` interaction or the longer repeated-transition gate.

### Decompiled stock bytecode

Pinned corpus identities:

- `Lotus_Interface_Background.lua_B`: 259,639 bytes, SHA-256 `2B0592CD09C75312D81B4EEB8E221EBB269C5C2E9237F14C057D124C4E2125F1`.
- `Lotus_Interface_GenericVendor.lua_B`: 71,797 bytes, SHA-256 `A7C854461D0E7740E9C65E269B73C7F1B9125D55BFD70F9B5957BAE79184DD94`.
- Decompiler `bin/derecomp.exe`: 7,067,929 bytes, SHA-256 `60157E2FD66E884E089AA7762AA7C5CD79C67748A502B7885FF6FEAE5AB46D6C`.

The reconstructed `Background` helper at [`artifacts/Lotus_Interface_Background.decompile-mod.luau`](artifacts/Lotus_Interface_Background.decompile-mod.luau) resolves a target movie and packs every variadic argument this way:

```lua
c190v4 = ""
c190v6 = {...}
for _, argument in ipairs(c190v6) do
  c190v4 = c190v4 .. "," .. argument
end
return targetMovie:Execute(methodName, c190v4)
```

`CallMethodOnScreen` and `CallMethodOnTopScreen` both reach this helper. Its closure/capture extraction completed with 281 prototypes, 280 sites, 476 captures, and zero failures; see [`artifacts/Lotus_Interface_Background.closure-map.tsv`](artifacts/Lotus_Interface_Background.closure-map.tsv).

The reconstructed `GenericVendor` input-field override at [`artifacts/Lotus_Interface_GenericVendor.decompile-mod.luau`](artifacts/Lotus_Interface_GenericVendor.decompile-mod.luau) forwards its callback argument to the base input handler and redraws the grid when the label changes. No direct `CallMethodOnTopScreen` literal appears in that module, so the exact internal route from the vendor callback to the `Background` helper remains unproven by static evidence.

The source reconstruction is evidence about the pinned current corpus. This investigation did not dump and hash the exact `Background.lua_B` instance loaded by the live game process, so it does not claim live module-byte identity.

## Safe next proof

When the UI becomes stuck again, exit the game and run [`tools/capture_search_freeze_logs.ps1`](tools/capture_search_freeze_logs.ps1) before launching the game again, because `EE.log` is replaced or rotated on later launches. Include the exact menu and last action in `-Note`, for example:

```powershell
& '.\RESEARCH\SEARCH_UI_INTERACTION_FREEZE_2026-09-06\tools\capture_search_freeze_logs.ps1' -Note 'Entrati vendor; clicked search; typed first character; cards stopped responding'
```

The resulting capture preserves both full logs, hashes them, and extracts the relevant search/background/vendor events.

The bridge-disabled A/B is complete and its required-cause hypothesis is false. The exact bridge bytes were restored at 2026-09-06T21:49:11Z, and the live verifier returned `PASS state=ACTIVE` with the disabled filename absent.

V35 and V37 are complete and false. V36 produced a clean user isolation result but intentionally lacked Pluto parity. V38 from [`RENOVICE_DEPLOYMENTS/NATIVE_FRAME_PLUTO_V38_2026-09-07`](../../RENOVICE_DEPLOYMENTS/NATIVE_FRAME_PLUTO_V38_2026-09-07) is deployed and its dashboard/background/autostart Pluto path is live. Test `Limbo`, `00`, `codha`, exact names, and repeated transitions across frames, all weapon categories, upgrades, and searchable card menus. A failure in either half falsifies H20. Thirty clean UI cycles with working Pluto support it but do not establish universal behavior.

## Validation performed

- `RENOVICE_MIGRATION/verify_manifest.ps1`: `MANIFEST PASS features=47 required=43 deployed=33 experimental=7 disabled=2 patched_companion=5 critical=27 targets=12`.
- `RENOVICE_MIGRATION/verify_dependencies.ps1`: `DEPENDENCY PASS submodules=5 source_commit=756bdc17aa9edf61df8204f901cdfff37b47db57`.
- Current log search: no bridge `FAIL`, `ERROR`, `WARN`, or `REJECT` was found in the inspected lifecycle.
- The evidence-capture helper completed an end-to-end baseline run and produced copied logs, hashes, and filtered event files.
- The bridge-disabled recurrence capture passed both log-hash capture and live `DISABLED_FOR_AB` verification before restoration.
- Post-test restoration passed with the exact 1,111-byte bridge hash and final state `ACTIVE`.
- Third-capture log hashes and the supplied screenshot hash were preserved before further testing.
- V35 dependency, manifest, injection-core, SCRIPTS-core, safe-runtime source, bridge roundtrip/Semantic IR/API, warning, error, architecture, and companion-import gates passed.
- The V35 live deployment was deferred while `Warframe.x64.exe` was running, then completed after the process exited. Live DLL and bridge hashes passed; no script policy changed.
- V35 live result: false; the `codha`/menu-transition sequence reproduced the stuck UI and the live debugger caught the primary game thread returning from `bgscript->tick()`.
- The rejected relinked DLL found on disk after the process exited was documented, excluded from labeled V35 capture identity, and replaced with the pinned V35 artifact before further deployment.
- V36 dependency, manifest, injection-core, SCRIPTS-core, runtime source, config, replacement, Riven, SWF, bridge, warning/error, x64, companion-import, package-hash, and deployment gates passed.
- V36 live isolation result: the user reported that the freeze appeared fixed; Pluto parity was absent by construction.
- V37 restored upstream UI-VM Pluto, excluded RENOVICE transaction work from that hook, and retained the pending-only DE transaction callback.
- V37 dependency, manifest, core, bridge, runtime-source, exact background-source, zero-warning/error, x64, companion-import, and package-hash gates passed.
- V37 live state: `PASS state=V37_TEST`, DLL SHA-256 `D110B8C0973E5F9CD5A4AA9F255EBAF6E71AABF47AD5F3288D9F7E0CAD1C19D9`; all 16 live CustomScripts files and the bridge were unchanged by deployment.
- V37 live result: false; exact `Limbo` reproduced the old execute-at-zero/null-continuation crash after Pluto functionality came up.
- V37 crash capture, minidump, CDB analysis, and exact hashes are preserved; live state was restored to V36.
- V38 removes the rejected Lua method hook, keeps the DE callback pending-only, and clocks full Pluto after the pinned native Application frame return.
- V38 private build and all offline/package gates pass with zero final warnings or errors.
- V38 live identity passes with DLL SHA-256 `5D26AC989A9155B788BB5979093CE58DACAF5732000D33BFCEDE89143F12D61A`; the bridge remains exact and all 16 CustomScripts files were unchanged by deployment.
- V38 Pluto startup passes live: HTTP status, available scripts, configured autostart, and running `Chat Commands.pluto` are present; PID 7388 remained responsive and the fault log stayed unchanged during the initial watch. Exact-search and repeated-transition acceptance remain pending.
