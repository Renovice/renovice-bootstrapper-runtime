# Contract R13: luaCalls.before at native entries, member policy retired (2026-10-01)

- **Branch:** `fix/r13-native-entry-member-policy-2026-10-01`, from `feat/settings-r11-coupled-literals-2026-09-30` `0cb0182`.
- **Client:** 44.0.2 (`2026.09.28.13.06`), `Warframe.x64.exe` SHA-256 `0124f0b93516e60ae362c59090809de24a42551143a6adf84963bd2120ab7d33`.
- **Trigger:** live report 2026-10-01: SCRIPT SETTINGS Missions → Defense → "Waves per reward" = 1, but the Defense mission
  (Corpus ship, L4 crewmen) still had no rotation checkpoint after waves 1 and 2.
- **Scope:** repository and `work/` only. The game folder was read with shared access (logs, ScriptStates.json, settings,
  packages, `Warframe.x64.exe`); nothing was written there. Nothing was pushed.
- **Status:** offline gates and the zero-warning private build PASS. **Every live check is pending.**

## Live evidence (read-only)

| Source | Finding |
|---|---|
| `EE.log`, session pid 19676 (10:50) | `Defense wave: 1`, `_SleepBetweenWaves(6)`, `Defense wave: 2`, `_SleepBetweenWaves(6)`, `Defense wave: 3`; no checkpoint after wave 1 or 2 (stock interval 3). No `RENOVICE Missions:` line at all. The defense target died in wave 3. |
| `renovice_source.log` (same session) | `PACKAGE MEMBER DISABLED trigger=startup package=Missions member=Missions.targets.addon.lua_B id=member:missions/missions.targets.addon.lua_b`; `SETTINGS PACKAGE ... package=Missions ... effective=3 ... members_staged=0/1`; `SETTINGS DELIVERY ... values=2 ... staged=0`. WaveDefend (`1a1354d153712f9d`) was loaded (`module.graph.ready`, 62 prototypes) but there is no `TARGET ADDON PASS` and no luaCalls dispatch for it. |
| `ScriptStates.json` (mtime 2026-09-30 19:24) | `"member:missions/missions.targets.addon.lua_b": false` (and three stale `member:` entries of exact-replacement members that no longer exist). |
| `renovice_source.log.2` line 51782 | Written by the R5/R6 SCRIPT SETTINGS member switches: `Script Settings apply PASS route=close files=0 ... policy=4`, then four `PACKAGE MEMBER DISABLED trigger=F9` lines. Every Missions session since then reports `members_staged=0/...` and `staged=0`. Whether the four switches were clicked on purpose cannot be determined from the log (R5 logs no click). |
| Settings R7 (`6227cc0`) | Removed every package/member switch from SCRIPT SETTINGS ("enabling a package or member is only in SCRIPTS"), but SCRIPTS has never had member rows (`member:` ids "are never Scripts-menu rows"). Since R7 nothing can show or change a stored member state. |

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| N1 | The Missions addon never ran in the failing session. | **TRUE** | `members_staged=0/1`, `DELIVERY ... staged=0`, no `TARGET ADDON PASS key=1a1354d153712f9d`, no `RENOVICE Missions:` print. Cause: the stored `member:` false (above). It also disabled every other addon-lane Missions value since 2026-09-30 19:24 (the player's `survival.reward_interval` 150 included). The live-literal value (Void Flood 4) is a package recipe, not the member, and kept working (`LIVE LITERALS PLAN ... void_flood`). |
| N2 | Settings were applied after mission start without a re-arm. | **FALSE** | `Settings/Missions.json` mtime 10:46, process start 10:50; the startup scan already reads `values=2` (defense 1, survival 150). |
| N3 | With the member enabled, the R11 runtime would dispatch the `WaveDefense` entry hook (P50). | **FALSE (static, code + data)** | The luaCalls.before observer (`de_luau_interrupt_increment_detour`) dispatches only when the current instruction decodes as a Lua CALL whose function register holds the armed closure (`exact_current_lua_instruction` + `decode_de_lua_call_instruction`). `WaveDefense` is called by its level ScriptTrigger (`functions: [WaveDefend.lua, WaveDefense]`, 50 triggers in 4,599 levels). No Lua body of the 5,473 installed references the global: the U44 name hash `f531ec5d` occurs nowhere, the string `WaveDefense` only in WaveDefend and LoopDefend themselves, and the closure `frame_61[210]` is only published (`WaveDefense = frame_61[210]`), never captured or called. So the entry runs on a fresh frame entered by native code (luau_execute starts at `ci->savedpc`, 44.0.2 RVA `0x192A5DD`) and never executes a CALL that the observer can see. Live confirmation is pending (no R10-R12 entry row has ever been dispatched live; the Missions member was disabled for all of them). |
| N4 | The same applies to every R10-R12 entry-template row. | **TRUE (static)** | All 22 entry rows (14 `SCRIPT_PARAM_GLOBAL_AT_ENTRY`, 8 `MISSION_INFO_FIELD_AT_ENTRY`) hook 21 entry functions with 18 distinct names (`DefendStart`, `WaveDefense` x2, `Excavation`, `ExcavationHUD`, `ExcavatorAvatar`, `killCounter`, `Territory`, `TerritoryHUD`, `OnEnemyCaptured`, `EnemyPatrol`, `KillCrewShipsExterminateObjective`, `KillFightersExterminateObjective`, `SabotageMission`, `reactorDestroyedFunction` (`ReactorDestroyed`), `VaultAlarmTriggered`, `SetupSpy`, `IntelHUD`, `Mission` x3). Their U44 hashes occur in no Lua body; in their modules each closure is only published as a global (`OnEnemyCaptured` is registered with the engine by name). Affected rows: Defense waves per reward and waves to finish, Mirror Defense phases, Interception round timer/rounds/score goal/scoring speed, Exterminate kills and Archwing kill multiplier, Railjack fighter/crewship/Corpus fighter goals, Sabotage hack time and random extraction timer, Spy vault alarm and vaults required, Deepmines hold time and bonus threshold, Excavation excavators, Survival fixed length, Void Cascade exolizers, Void Flood tanks. The root-table rows (for example Survival reward interval, Defense max enemies) hook Lua-called prototypes and are not affected. |
| N5 | The level parameter is cached before the entry hook can change it (GETIMPORT import cache). | **FALSE (native code)** | 44.0.2 GETIMPORT handler (U44 opcode `0x35`, RVA `0x192B1A7`) takes the constant only when `K[D]` is non-nil **and** `cl->env->safeenv`; otherwise it calls `luaV_getimport` (RVA `0x5303E0`, the only caller), which reads the closure environment and never writes `K`. `luau_load` (RVA `0x191B080`) resolves an import constant at load time against `L->gt` (the VM globals, through the resolver at RVA `0x191C420`), not against the per-trigger environment (`TARGET ROOT RETURN` shows load_env != runtime_env), so a level parameter is nil there and every read goes through the live environment. The note in `luau-imports-and-mallet-follow` that the first execution writes the result back into `K` does not match this build's code. |
| N6 | `minWavesToComplete` is not what drives the checkpoint on Corpus ship maps. | **FALSE** | The level census (`outputs/levels.txt`) has 3 on all 28 regular maps including Corpus; the checkpoint at P48 L9228-9240 reads only that global and the two arena flags; the EE.log wave loop is the regular `WaveDefend.lua` path. |
| N7 | A native-entry dispatch can reuse the whole luaCalls.before path unchanged. | **TRUE (offline)** | At the natural VM-execute entry (`vm_execute_detour`, before the naked stock execute) the entered frame is current, `L->top == ci->top` above its registers, the fixed parameters are `base[0, numparams)` (DE prototype byte `+0x04`, luau_load RVA `0x191B40A`), and `dispatch_lua_call_phase` already restores ci, ci->top and both tops and verifies them. Re-entrancy is the existing `lua_call_hook_running` guard; `lua_execution_mutex` is recursive. |

## Change

1. **`luaCalls.before` at native entries** (`renovice/lua_call_retirement_core.hpp`, `renovice/injection.cpp`).
   - New unit-tested rule `lua_call_entry_prefilter`: the entered frame holds a Lua closure; it is **fresh**
     (`ci->savedpc == proto->code`, DE prototype `+0x10`; a resumed coroutine is mid-function); the **CALL observer does not
     own it** (the parent is not a Lua frame whose current instruction is a CALL of this exact closure, so a Lua-to-Lua call
     is still dispatched once, by the interrupt observer); the prototype may be armed (the S2 set). Unproven shapes are
     `undecided` and take the full validated path.
   - `observe_native_entry_lua_call` (called once, in `vm_execute_detour` after the S4 dormant wake and before the naked
     stock execute): fast gate, re-entrancy, the rule, probes, fresh-frame re-check, snapshot lease, exact published-closure
     identity, the lock-free claim check, then the unchanged `dispatch_lua_call_phase` (protected leaf, five arguments
     including the R10 environment, finite same-tag copy-back of the fixed parameters, R3/R4 retirement). Every object it
     owns is released before the stock execute. Log: `native hook PASS ... event=luaCalls.<P>.before.native-entry` (once),
     startup line `RENOVICE luaCalls before native-entry boundary contract=R13 ...`.
   - Lua code entered from a C function (pcall, metamethods, iterators) is now dispatched too; a Lua CALL is not dispatched
     twice.
2. **Member policy retired** (`renovice/packages.cpp`, `packages.hpp`, `script_control_core.hpp` comments).
   - The package row in SCRIPTS is the only enable owner. A member is always enabled; a stored `member:` `false` is reported
     once per scan: `RENOVICE PACKAGE MEMBER POLICY IGNORED trigger=... package=... member=... id=... stored=false
     reason=member-switch-retired-R13 owner=package:<folder> file=unchanged`. ScriptStates.json is not rewritten (rollback to
     an older DLL restores the old behaviour exactly).
   - Rejected alternatives: re-adding member switches (contradicts the R7 direction "no switches in SCRIPT SETTINGS; one
     SCRIPTS row per package"); member rows in SCRIPTS (one Missions row was the explicit goal); keeping the policy and only
     logging it (the player still could not fix it in game).
   - Capability change, stated: hand-editing `member:` to disable one member of a package no longer works. Disable the
     package in SCRIPTS or remove the member file instead.

## Gates

| Gate | Result |
|---|---|
| `verify_lua_call_retirement.ps1` section 15 (new): native-entry rule on synthetic frames, U43 and U44 opcode maps: engine entry is a candidate and invisible to the CALL observer (the defect), unarmed skip, coroutine resume not fresh, C frame and non-function skips, Lua CALL owned by the interrupt observer (exactly one dispatch), Lua → pcall → Lua dispatched at entry, metamethod parent, parent CALL of another closure, undecided shapes, DE offsets `+0x10`/`+0x04` | PASS |
| `verify_lua_call_retirement.ps1` source pins (new): gate first, re-entrancy, rule before probes and lease, fresh re-check, fixed-parameter bound, claim before any VM-top write, shared dispatch, no lock/VM call/retire path of its own, one call site, after the S4 wake, before the naked stock execute | PASS |
| `verify_addon_settings.ps1` case 7 (changed) and 7b (new): stored `member:` false → member staged, `POLICY IGNORED` line, no `MEMBER DISABLED`; the live state end to end (stored false + enabled value) → delivery `staged=1`, never `members_staged=0/` | PASS |
| `verify_addon_settings.ps1 -Package ... -Settings ... -ScriptStates` (new switch): the installed Missions/Frost/Octavia packages, values files and **ScriptStates.json** (read-only copies, SHA-256 in the staging README) → `members_staged=1/1`, Missions delivery `values=2 staged=1`, "every delivered value reaches a staged member" for all three packages. With R11 the same replay is the live `members_staged=0/1`. | PASS |
| Ability editor `test_entry_native_harness.py` (branch `feat/missions-r13-native-entry-harness-2026-10-01`): the real generated R12 addon (rebuilt byte-identical to the installed `8e0e1871`) in plain Luau, called as the R13 runtime calls it at a native entry, for all 22 entry rows (113 checks), plus the stock Defense checkpoint rule | PASS |
| `verify_replacement_settings.ps1` case 7 (changed): a stored member false on a replacement member is ignored; the member stays staged with its settings entry | PASS |
| `build_private.ps1` (every build-listed gate, `/W4 /WX`) | `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`, DLL `e5d9b61b40fa66baf79a78f89be53b8e45e09b27027c0f60eedc84ccabbe1914` (5,907,456 B). Staged `work/staging/combined-r13/`. |

## Limits (exact)

- N3/N4 are static (code + level data + corpus scan). The first live run must show
  `native hook PASS key=1a1354d153712f9d event=luaCalls.50.before.native-entry` and the EE.log line
  `RENOVICE Missions: defense.waves_per_reward minWavesToComplete 3 -> 1`.
- The Defense checkpoint transcription in the harness is the decompiled reader, not DE bytecode running in the game VM.
- Performance: while any luaCalls slot is armed, every natural VM-execute entry runs the allocation-free rule (closure
  header, prototype code pointer, one parent instruction, the S2 set). Not benchmarked live.
- Whether the four 2026-09-30 member switches were clicked on purpose is unknown (R5 did not log clicks).
