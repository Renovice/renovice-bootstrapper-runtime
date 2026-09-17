# RENOVICE runtime performance audit — 2026-08-28

> **Resolution update (2026-09-02):** Event-driven V18 implemented the P0/P1
> architecture corrections identified here: fake region detection and its
> generation reloads were removed; stale environment probing was removed;
> unrelated VM returns now use an atomic exact-root rejection; native trace is
> diagnostics-only. See `EVENT_DRIVEN_SCRIPT_RUNTIME_V18_2026-09-02.md`.

## Scope and conclusion

This audit investigates the user's intermittent hitch without assuming that
Octavia Mallet's native gameplay is the cause. It covers the complete RENOVICE
execution path: global Luau hooks, the HUD-tick injector drain, automatic
generation reloads, target-addons, diagnostic logging, and SCRIPTS UI state.

Three implementation-level performance risks are confirmed:

1. **P0 — exact-pipeline diagnostic tracing is still active in the deployed
   gameplay build.** A Mallet callback can cross from Luau into C++ several
   times, format each event, synchronously open/write/close the log, and take a
   global configuration mutex. The latest process exhausted the full 4,096
   event trace budget.
2. **P0 — `AutoSpawn` uses arbitrary bytecode-undump timing as a fake region
   detector.** Any module load after a 1.5-second quiet gap is classified as a
   region transition. The latest process completed 58 generation reloads
   labelled `trigger=region`.
3. **P1 — the SCRIPTS UI fallback is installed as a process-wide VM detour.**
   Every game Luau executor invocation performs RENOVICE inspection and
   mutex-protected identity work, although only TopMenu needs decoration. The
   latest process reached at least 677,920 same-VM returns and 10,624 actual
   fallback attachment attempts before its last sampled attempt.

These findings establish avoidable work in RENOVICE itself. They do **not** yet
measure the exact frame-time contribution of each path, so the statement that
one specific path is the sole cause of the visible hitch remains unproven.

No gameplay behavior, live configuration, DLL, script bytecode, or deployment
was changed during this audit.

## Evidence snapshot

The inspected live files were:

- `OpenWF/CustomScripts/renovice.cfg`
- `OpenWF/CustomScripts/renovice_source.log`
- `OpenWF/CustomScripts/ScriptStates.json`

The live flags were:

```text
Logging=true
Verbose=true
AutoSpawn=true
```

The append-only live log contained 34,188 lines and 4,914,469 bytes. Historical
counts are not treated as one play session. The latest process was isolated at
its last `RENOVICE Scripts UI VM execute hook ENTRY` marker and contained:

| Latest-process observation | Count/evidence |
|---|---:|
| Exact diagnostic trace events written | 4,096, followed by `TRACE SUPPRESSED` |
| `trigger=region` generation reload passes | 58 |
| Logged environment-attach attempt samples | 170 |
| Actual attempt counter at last sample | 10,624 |
| Same-VM return counter at last sample | 677,920 |
| Exact TopMenu runtime-root decoration passes | 11 |
| Latest-process log lines | 4,651 |

The 170 logged attachment lines understate the work. The code probes densely
for the first 32 returns, then once every 64 returns, and logs only the first
four attempts plus every 64th *attempt*. The live `attempt=10624` and
`vm_returns=677920` values are the relevant counters.

## Hypothesis ledger

| Hypothesis | Result | Evidence |
|---|---|---|
| The SCRIPTS menu continuously scans `CustomScripts` every frame. | **FALSE BY IMPLEMENTATION** | `script_control::snapshot()` performs directory discovery when the submenu builds or a requested change is validated. It is not called from the HUD tick or VM executor. |
| `ScriptStates.json` is continuously rewritten. | **FALSE BY IMPLEMENTATION** | The atomic temporary-file write occurs on an explicit requested batch/confirmation path, not per frame. |
| RENOVICE does continuous work even while no toggle is being changed. | **TRUE** | The process-wide VM/protected-call detours and the HUD update detour remain installed. `drain`, focus detection, F9 polling, script ticking, and pause-identity inspection remain active. |
| `AutoSpawn` observes a real mission/region identity. | **FALSE** | `notify_undump()` records only `GetTickCount64()`. A gap greater than 1,500 ms sets `region_pending=true`; it never reads a region, mission, level, session, or VM identity. |
| A quiet-gap module load can cause a managed generation reload. | **TRUE** | `undump_detour` calls `notify_undump()` for every DE bytecode undump. HUD `drain()` consumes `region_pending`; when `AutoSpawn=true`, it scans enabled injected bytecode and calls `apply_generation`. |
| Only F9/Confirm reloads scripts in the current build. | **FALSE LIVE** | The latest process logged 58 completed `RENOVICE RELOAD PASS trigger=region` transactions. |
| The deployed Mallet path is a production trace-free path. | **FALSE LIVE** | The shim traces callback entry, handler lookup, and handler pass/fail; the addon traces entry/rejection/mutation stages. The latest process reached the 4,096-event bridge budget. |
| `Verbose=false` alone disables exact-pipeline trace cost. | **FALSE** | `diagnostic_trace_bridge()` calls `config::log()` directly rather than `verbose_log()`. The bridge is installed as part of target-addon activation. |
| `Logging=false` removes all exact-pipeline trace overhead. | **FALSE** | It prevents the file write inside `config::log()`, but the Luau-to-C call, atomic sequence increment, and pre-log stream/argument formatting still execute for the first 4,096 events. |
| The global VM fallback stops affecting execution once SCRIPTS has appeared. | **FALSE BY IMPLEMENTATION** | Every VM execute increments an atomic counter and calls `inspect_pause_vm_root_execution()`. Non-root executions then call `pending_pause_environment_candidates()`. Both candidate paths use `generation_mutex`; exact TopMenu roots are intentionally revalidated for fresh ESC movie instances. |
| Disabling the VM hook permanently after one successful ESC open is safe. | **FALSE** | Closing and reopening ESC creates a fresh environment and `Initialize` closure. The exact TopMenu root still needs decoration for each new instance. Optimization must use a cheap exact-owner fast filter, not retire the feature globally. |
| The HUD tick performs no RENOVICE work while reload is idle. | **FALSE** | It calls `injection::drain`, obtains the foreground window/process, polls F9 with `GetAsyncKeyState`, takes `running_scripts_mtx`, checks hotkeys, and ticks the background/running scripts. `drain` also takes `generation_mutex` to recompute addon adapter requirements. |
| Mallet's native gameplay is proven to be the sole cause. | **FALSE / NOT ESTABLISHED** | RENOVICE has multiple global and intermittent costs. No controlled stock-versus-custom frame-time capture has isolated native Mallet itself. |

## Finding 1 — production diagnostic tracing is on the gameplay hot path

The current explicit Mallet replacement performs these trace calls for a normal
damage callback:

1. `mallet.base.callback.enter`
2. `mallet.base.handler.lookup`
3. addon `mallet.addon.damage.enter`
4. addon rejection or mutation-stage trace(s)
5. `mallet.base.handler.pass` or `.fail`

The live tail shows this five-event pattern repeated for `damage-nonpositive`
callbacks. Successful mutations can emit more stages.

`diagnostic_trace_bridge()` then:

- atomically increments a global sequence;
- allocates/formats an `std::ostringstream`;
- walks and formats every Luau argument;
- calls `config::log()`.

`config::log()` takes `state_mutex`, calls `CreateFileW(OPEN_ALWAYS)`, performs
two synchronous `WriteFile` calls, and closes the handle for **every event**.
This occurs on the caller's thread. A 4,096-event cap prevents an unbounded log,
but it does not make the first 4,096 events inexpensive. After suppression, the
Lua code still looks up and invokes the bridge, which still crosses into C++ and
increments/checks the atomic counter.

### Result

**TRUE: deployed diagnostic machinery adds substantial avoidable per-callback
work.** Its exact millisecond cost remains to be measured, but this is already
incorrect for a normal production gameplay build.

## Finding 2 — `AutoSpawn` is a module-load quiet-gap heuristic

The active interception chain is:

```text
any game Luau bytecode undump
  -> replacements::undump_detour
  -> injection::notify_undump
  -> gap since previous undump > 1500 ms
  -> region_pending = true
  -> next HUD drain
  -> scan_snapshot
  -> apply_generation(..., "region")
```

This signal does not distinguish a real mission transition from ordinary lazy
module loading. With `AutoSpawn=true`, the latest process completed 58 such
reloads. Each generation rescans the Inject directory, reads enabled bytecode,
reruns the internal SCRIPTS bridge one-shot, and reconciles target-addon state.
Even a generation containing no target addon still reruns the one-shot bridge.

The enabled Inject payload is currently small (the internal bridge plus one
target-addon), so raw disk volume is not the main concern. The issue is doing a
complete lifecycle transaction at arbitrary game module-load boundaries and
potentially touching target-addon state while gameplay is active.

### Result

**TRUE: the current region detector can create intermittent RENOVICE reload
spikes unrelated to an actual region change.** The label `trigger=region` in the
log means the quiet-gap heuristic fired; it is not proof that the game changed
regions.

## Finding 3 — SCRIPTS UI discovery is process-wide instead of owner-fast

`install_loader_hook()` installs and enables all three detours together:

- module loader;
- every game-owned protected Luau call;
- the global Luau VM executor.

For every VM executor invocation, `vm_execute_detour()`:

1. increments `vm_execute_entry_sequence` atomically;
2. validates the current state/call frame and closure;
3. takes `generation_mutex` and scans `pause_menu_identities` looking for an
   exact TopMenu root;
4. when it is not a root, calls `pending_pause_environment_candidates()`, which
   takes the same mutex and scans/mutates identity counters;
5. calls the original VM executor;
6. occasionally attempts environment decoration and logging.

The protected-call detour separately inspects every protected Luau call and
takes `generation_mutex` for valid Lua closures.

The exact-root revalidation is semantically necessary because each reopened ESC
movie has a new runtime environment. The expensive part is making unrelated VM
executions pay the full ownership/mutex path. At least 677,920 VM returns were
observed in the latest process before the final logged fallback sample.

### Result

**TRUE: the SCRIPTS UI architecture introduces continuous process-wide work.**
The absolute frame-time impact is not yet measured, but the scope is much wider
than the feature requires.

## Finding 4 — HUD-tick injector bookkeeping recomputes stable state

`lua_LotusHudStatus_UpdateFlashMarkers_detour()` calls `injection::drain(L)` on
every HUD flash-marker update. It then saves/restores VM state, locks
`running_scripts_mtx`, queries foreground ownership through two Win32 calls,
polls F9, checks registered hotkeys, and ticks the background/running OpenWF
scripts.

Before `drain()` checks whether a reload or region event exists, it can acquire
`generation_mutex` to answer questions that normally change only when a
generation changes:

- whether a target addon is configured;
- whether native damage adapters are requested.

### Result

**TRUE: small but unnecessary work is repeated at HUD frequency.** There is no
evidence that this alone causes the visible hitch, but these checks should be
cached atomically when a generation commits rather than recomputed per tick.

## Finding 5 — generic native callback dispatch copies and sorts per event

The generic native damage wrapper allocates a `std::vector<luau_TValue>` to copy
the callback arguments. `dispatch_target_hook()` then calls
`hook_addons_snapshot()`, which locks `generation_mutex`, copies matching
`AddonRecord` strings, and sorts them for every dispatch.

The currently deployed explicit Mallet damage shim calls the shared Luau handler
directly, so this generic C++ dispatcher is not proven to be the direct cost of
the observed Mallet hitch. It remains a general scaling defect for addons that
use the native `afterDamage` contract.

### Result

**TRUE as a general implementation inefficiency; NOT PROVEN as the current
Mallet hitch source.**

## Prioritized correction plan

The safest order preserves exact gameplay and UI behavior:

1. **Remove exact tracing from production gameplay paths.** Make trace bridge
   installation explicitly diagnostic-only. Build the deployed shim/addon with
   no per-callback trace calls when diagnostics are off. A configuration flag
   checked after formatting is insufficient.
2. **Replace fake region detection.** Use an actual region/session/VM lifecycle
   identity and require an identity change. Skip generation apply when enabled
   script content and target VM ownership are unchanged. Until that exists,
   `AutoSpawn=true` should not be considered reliable production behavior.
3. **Add an owner-fast VM filter.** Preserve redecoration for every fresh
   TopMenu instance, but reject unrelated VMs/prototypes before mutex acquisition
   and before fallback-candidate work. The loader can publish a compact atomic
   set/snapshot of known TopMenu `(global_state, root_proto)` identities.
4. **Move stable adapter decisions out of the HUD tick.** Compute target-addon
   presence and native-adapter demand during generation commit and publish them
   as atomics.
5. **Cache callback dispatch plans.** Publish an immutable, already-sorted hook
   list per `(target_key, global_state, generation)` and avoid heap allocation for
   small callback argument arrays.
6. **Profile with aggregation, not event logging.** Use in-memory counters and
   `QueryPerformanceCounter` totals/maximums for the trace bridge, VM detour,
   drain, reload transaction, and addon callback. Flush one summary on demand or
   process shutdown, never one file open per gameplay event.

## Required acceptance test after optimization

1. Use the same solo Simulacrum/mission, enemy count, graphics state, and Mallet
   placement for every run.
2. Capture frametime percentiles and worst-frame time for:
   stock scripts disabled, SCRIPTS UI only, shim only, addon only, and full
   shim+addon.
3. Confirm zero `trigger=region` transactions without a real region identity
   change.
4. Confirm zero trace-bridge invocations in a production configuration.
5. Confirm SCRIPTS appears after every ESC close/reopen and all five toggle states
   still persist after Confirm and process restart.
6. Confirm exact Overguard math and ability-card output are unchanged.
7. Treat any new warning, failed hook, rollback, missing handler, or UI attach
   failure as a failed optimization, not as an acceptable performance trade.

## Final classification

- **The user's broader implementation concern:** TRUE.
- **A continuous directory-refresh loop:** FALSE.
- **Avoidable continuous global-hook overhead:** TRUE.
- **Avoidable intermittent automatic reload work:** TRUE and live-observed.
- **Avoidable per-Mallet diagnostic work:** TRUE and live-observed.
- **Mallet native gameplay as the sole culprit:** NOT PROVEN.
- **Exact performance improvement after fixes:** PENDING controlled A/B profiling.
