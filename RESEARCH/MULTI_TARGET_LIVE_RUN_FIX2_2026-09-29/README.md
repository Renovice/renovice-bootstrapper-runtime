# First live run of the multi-target bootstrapper, and fix 2 (2026-09-29)

- Build under test: `wtsapi32.dll` `83e74faf…51a9`, branch `feat/multi-target-addon`, commit `67cd256`.
- Client: 44.0.2 (`2026.09.28.13.06`), process 32336. Diagnostics, Logging and Verbose were true; `renovice.cfg` was not touched.
- Fix branch: `fix/multi-target-live-run-2026-09-29`, from `67cd256`.
- Scope: repository only. Nothing was written to the game folder or the OpenWF server.
- Evidence: read-only copies of `renovice_source.log` (+ `.1`, `.2`), `renovice_memory_2026-9-29T18-12-53Z_32336.log`, `renovice_fault.log` and `EE.log`, taken while the game was still running.
  - The rotated logs also contain two older sessions (pids 29384 and 13964).
  - The current session starts at the `configuration reloaded` line immediately before the first `pid=32336` record; it is 164,529 lines long.

## Results

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| S1 | Survival gave no second reward because of hook failures or cleanup. | EE.log: `Gave reward tier 1 at 150.33` (2116.29), then `CmdShowPauseMenu` at 2142.99, a paused solo game until 2873, and `Gave reward tier 2 at 300.02` at 2998.59. Proto 33 computes `tier = floor(elapsed / interval)`, so tier 2 at 300 s requires `interval == 150` at that moment. | **FALSE.** The second reward arrived on time. The 730 s gap was the pause menu. |
| S2 | `stage=read-upvalue index=0` (protos 67/68/69) and `mutation rejected … prototype=61 upvalue=1 candidate_tag=0` are one runtime bug in the luaCalls.before read-back, not addon faults. | `lua_call_before_protected_leaf` (since `98b9a18`): the argument read-back set `outtop = arguments_table + 1`, which is the **upvalue view table's slot**, then pushed the key there and `gettable` wrote `args[i]` into it. The upvalue read-back then indexed the last argument instead of the view. SurvivalMission: 61 = `function(p61_0, p61_1)` (last argument a table, so `t[1]` is nil, giving candidate nil vs stock table tag 7); 67/68/69 = `function(pN_0)` (a non-table argument, so `gettable` raises a DE error, `raw_status=2`); 33/55 = `function()` and 62 was called with 0 arguments, so they PASS. `callback_status=0` in every FAIL line: the addon callback itself ran and succeeded before the read-back failed. | **TRUE (source + log).** Fixed. |
| S3 | The failures cancelled the 150 s change. | Table writes (`owner.interval = 150`) happen inside the callback and are not rolled back by `restore_stock()`, which restores only argument and upvalue slots. The first reward at 150.33 and the second at 300.02 confirm this. | **FALSE.** |
| S4 | The 8 Survival `TARGET ROOT RETURN … rebind-queued` lines are correct. | Each one ran cleanup (the old addon restored `interval` to 300 when it read 150), re-ran the chunk and activated; the next hook call wrote 150 again. It worked only because proto 33 re-binds before every reward check. | **FALSE as a design** (churn, and a transient revert). Replaced by bind-once. |
| R1 | The `lua.call.before.reject` stream is diagnostics-only and bounded. | `trace_addon` returns immediately when `Diagnostics=off` and is capped by `DiagnosticsMaxEvents=32768`. However, the call site built a `std::string` from a 48-character literal on every reject, even with diagnostics off, and 28,576 identical, uncorrelated lines (no prototype, no reason) used up the shared trace budget. From the sampled FAIL counter, at least 262,144 rejects occurred. | **PARTIALLY TRUE.** Fixed: the diagnostics-mode check now comes before any work; the stream is sampled (1–8, then powers of two); each line carries prototype and occurrence. |
| I1 | Ice Wave rebinds were "about 28, per cast". | 3,470 `TARGET ROOT RETURN key=8fba3a28f8fef624` with 3,245 distinct runtime environments, in bursts of up to 37 per second that coincide with IceSpike `SetSource`/`DamageDD` hook bursts. `IceSpike.lua` is a per-instance ability script, so its root runs at least once per cast and often several times. | **PARTIALLY TRUE.** It is per ability instance, not 28. Each instance paid cleanup, a 13.6 KB chunk run, activate, a registry root, and 3 log lines. |
| I2 | The Ice Wave ability still worked and nothing leaked. | 542 `BATTLE_TX_BEGIN … FROST_ICE_WAVE_DAMAGE`; nativeCalls PASS; 0 `nativeCalls protected leaf FAIL`. Old registry roots are released by `commit_addon_generation`, and runtime identities are replaced, not appended. Each cleanup reset the addon's per-cast stack tables (`v13/v14/v15`) mid-combat. | **TRUE for function and no-leak (log).** The per-instance reset is **UNRESOLVED as a gameplay effect** (no user report). Removed by bind-once. |
| C1 | Circuit still fails because the root-return rebind used the wrong environment. | The stock DuviriUtil root begins `module(..., package.seeall)` (`Name__190fd70f` = hash("module")), which re-points the running root closure's environment to the module table, and the root then assigns `EndlessGetXpForStage`/`ENDLESS_BONUS_STAGE_XP` into that table. `67cd256` captured `closure->env` at VM execute **entry**, before `module()` ran, and rebound there (log: `runtime_env=…ECF0`, the same error again). | **TRUE (static + log).** Fixed: the environment is re-read from the same root closure at its normal return. Live confirmation is pending. |
| C2 | Activation happens before the root returns. | The load-time activation fails once, as designed, then the retry happens at the root return. | **TRUE, expected.** |
| M1 | Mallet still fails with `native-adapter-commit`. | That line (all-log line 62,974) belongs to the previous session (pid 13964). In pid 32336: `TARGET ADDON PASS key=ec368d4901690a15`, and after F9's `_T` change, `REBIND PASS`. Mallet was not cast this session. | **FALSE for this build** (load and bind PASS). Gameplay is unverified. |
| W1 | `EndOfMatch: WRONG NUM REWARDS` is caused by the Survival change. | Stock `EndOfMatch` compares `#server MissionRewards` with `#client mCollectedStoreItems` (after removing product category 35) and only prints. The same line appears on 2026-09-06 (build 2026.08.19, Nemesis missions, no mission addon), 3 times in that capture, and in the 09-16 captures. The server granted 2 rotation-A drops for `rewardQualifications '11'`, which matches 2 client reward tiers. | **FALSE.** It is a pre-existing OpenWF server/client reward-list mismatch, cosmetic, and not ours. |
| F1 | F9 at the end of the session was rejected for a known reason. | `F9 ROLLBACK before addon staging`, with no reason in the file log: the member rejections were written to the console only. | **UNRESOLVED.** Now logged: every prepared-member and Inject-scan rejection also goes to `renovice_source.log`. |

## Fix (generic; no module-, mission- or ability-specific C++)

1. **luaCalls.before read-back.** `lua_call_before_leaf_get_array_at(table_offset, …)` pushes a copy of the view table, then the key, above a working top that stays directly above **both** view tables. No read can overwrite a view slot. The leaf is still destructor-free and POD, and the ordering (raw run, restore, validate, commit) is unchanged. This fixes 61/67/68/69 and every other luaCalls hook called with one or more arguments.
2. **Bind once, like a native hook.** `publish_target_execution_snapshot_locked` watches a module's root only when `target_root_return_watch_required(desired, bound, retry_spent)` holds: a desired addon, **no** committed binding in that VM, and no retry yet in this generation. `apply_target_root_returns` re-checks the same predicate, consumes the one retry, and only then records the runtime identity. A bound module (Ice Wave, Survival, Mallet, ESO) gets zero per-instance work: no watch match, no queue, no rebind, no log line, no allocation. The exact-prototype luaCalls/nativeCalls attribution from `67cd256` still reaches every instance.
3. **Return-time environment.** `settle_target_root_return` re-reads `env` from the same validated root closure (same proto, Lua closure) right after the naked stock return. It holds no lock, allocates nothing and makes no VM calls. The log line now shows `entry_env=… runtime_env=… reason=unbound retry=once-per-generation`.
4. **Reject trace.** `trace_lua_call_before_reject` is reached only when Diagnostics is on, is sampled, and is correlated.
5. **Operational F9 reasons.** `reject_prepared_member` and `report_scan_rejection` log to the file as well as the console.

The rejected design is `67cd256`'s "lifecycle follows the most recent root instance": it is superseded by the live evidence above. Retained: multi-target files, exact-prototype attribution, error text, and the root-return retry (now bounded to unbound modules).

## Gates (all PASS)

- `verify_injection_core.ps1`: 201 PASS lines, including 3 new watch-predicate checks.
- `verify_target_root_binding.ps1`: real 44.0.2 SurvivalMission + Arbitration fixture. New checks: bound module not rebound, unbound module retried once, settle re-read, a no-lock/no-allocation settle region, the watch predicate gating publication, and a re-check before identity mutation.
- `verify_lua_call_raw_protection.ps1`: new checks for non-clobbering read-back markers and for the absence of the former `arguments_table_offset) + 1` top.
- `verify_unified_diagnostics_master.ps1`: new checks that the reject trace is gated before any work and sampled before formatting.
- Existing gates: `verify_multi_target_addon`, `verify_scripts_ui_core` (77), `verify_legacy_ui_vm_boundaries`, `verify_target_export_hook`, and every build-listed gate.
- `build_private.ps1`: `PRIVATE BUILD PASS warnings=0 errors=0 x64=yes companion_import=no bytes=4927488`.
  - Build environment note: this agent shell exports `NoDefaultCurrentDirectoryInExePath=1`, which stops `archive.php` from finding `tools\pluto.exe`. The build was run with that variable unset. No build file was changed.

DLL: `work/staging/bootstrapper-multitarget-fix2/wtsapi32.dll`, 4,927,488 B, SHA-256 `420e10a400d9b7f6fc934639732a5365b0925fa969e91ef0b73612bf1e98f4da`. The archive is time-versioned, so the hash is specific to this build instance.

## Phase 2g `Missions.targets.addon.lua_B` (00DA193D…) against these findings

- Its Survival hooks read `upvalues[27]` (61), `[70]` (67), `[9]` (68) and `[26]` (69). The **addon** reads work; only the runtime copy-back failed. With fix 1 there are no errors, and no generator change is needed for correctness.
- Its weak-keyed per-instance binding is compatible with bind-once. `cleanup` now runs only on disable, F9 or removal, not per root instance.
- Do not install it next to the old per-module `f10a…/caec…/6fa6….missions.target.addon.lua_B` files: both would bind. The second file's stock check (`interval == 300`) then fails on every instance and logs luaCalls FAIL.
- **Recommended generator change (not implemented):** emit, per root table, only the smallest set of hooks whose prototypes read the owned field **before** its first use, preferring low-frequency ones. Drop setter-only or debug prototypes (Survival 60 writes `interval` only under `debugCmd`) and hot per-tick ones. The live counter reached at least 262,144 luaCalls on 67/68 in about 200 s of mission time. Every hooked call costs one protected leaf, which builds argument and upvalue views (the generated proto-67 hook addresses upvalue 70). In the 44.0.2 decompile, protos 31, 33, 55, 58, 67 and 69 read a `.interval` field (of which table is not resolved here); 62 and 68 do not. Proto 33 is the reward check: it reads `interval` right before computing the tier, so a hook on 33 is a likely minimal binding point, but proto 67 (hot) may also read this table. The generator's `ROOT_TABLE_UPVALUE_V1` data flow must confirm table identity per module before any hook is dropped.

## Live checks (pending; the user runs them by hand)

With the game closed, deploy the staged DLL. Keep `83e74faf…` and `15daf981…` as rollbacks. Then check:

1. Survival: zero `luaCalls.before protected leaf FAIL` and zero `luaCalls mutation rejected`; `native hook PASS … luaCalls.61/67/68/69.before` appear; rewards at 150/300 s; **no** `TARGET ROOT RETURN key=f10a…`.
2. Ice Wave: several casts give **no** `TARGET ROOT RETURN key=8fba…` and exactly one `TARGET ADDON PASS key=8fba…` at load; the +cold-stack damage still applies.
3. Circuit: one load-time `addon lifecycle FAIL … GETTER_NOT_FUNCTION`, then `TARGET ROOT RETURN key=95ef… entry_env=A runtime_env=B reason=unbound …` with A ≠ B, then `TARGET ADDON PASS key=95ef…`; the stage preview shows 500/550/625/725/850.
4. Mallet cast, Elite Sanctuary, F9 (any rejection now names its reason in the file log), F10/Pluto, search (`Limbo`, `00`, `codha`), Riven locks.
5. With Diagnostics=true, `lua.call.before.reject` appears at most about 30 times per session, with `prototype=`.
