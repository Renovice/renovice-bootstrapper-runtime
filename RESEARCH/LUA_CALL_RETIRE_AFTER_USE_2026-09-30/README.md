# Retire after use for target-addon `luaCalls.before` hooks (2026-09-30)

- Branch `feat/lua-call-retire-2026-09-30`, from `47a3c92` (`fix/engine-damage-codec-44.0.2-2026-09-30`, staged DLL
  `9e44f885…`, which the coordinator reports as installed).
- Client: 44.0.2 (`2026.09.28.13.06`). No signature, RVA or build registration changed.
- Scope: repository only. No game-folder or OpenWF-server write, no deploy, no push.
- Status: offline gates and the zero-warning private build **PASS**. **The live check is pending.**

## Why

Fix-2 live run (pid 32336, Survival): hooked SurvivalMission protos 67/68 ran more than 262,144 times in about 200 s. The
generated Missions hook binds the root table on first sight and writes one value, idempotently per table (weak-keyed set).
After the first call per mission every further call still paid a full dispatch: decode, lease, owner search, a protected
leaf that builds argument and upvalue view tables (the proto-67 hook addresses upvalue 70), a Lua call and a read-back.
While any `luaCalls.before` provider is admitted, every Lua call and loop back-edge in the VM also pays the observer's
decode and owner search, because the interrupt leaf observes all of them.

## Hypotheses and results

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| R1 | A `before` callback's return value can carry a retire signal without changing existing addons. | The leaf called `protected_call(state, 4, 0, 0)`: results were discarded. With `nresults = 1`, a callback that returns nothing yields one nil, which is not the sentinel. Pre-R3 DLLs keep discarding it. | **TRUE (source + gate)** |
| R2 | "Captured-upvalue identity" (the exact closure) is a sound retirement scope. | Luau size-class free lists reuse a freed closure's address for the next closure of the same size (same prototype), so a retired address can come back as the next mission's closure (ABA). Its UpVal cells and environment table can be reused the same way. Pinning the closure would keep a finished mission's state alive. | **FALSE as the sole scope.** Rejected. |
| R3 | "Module instance" can be observed generically at the module root's natural VM-execute entry, and a closure's instance is its environment. | The existing root watch already matches exact VM + recorded root prototype at VM-execute entry, and settles the environment the root published into at its normal return (fix 3 child-closure rule). Luau `NEWCLOSURE`/`DUPCLOSURE` give a closure the creating function's environment. Fix-2 log: 8 SurvivalMission root instances, each with a new runtime environment (`record_target_root_return` logged a change each time); IceSpike 3,245 distinct environments in 3,470 roots. | **TRUE (source + prior logs)**, live pending |
| R4 | Only a prototype created by the root itself can be re-armed by a root entry. | A nested prototype's closures are created by its parent function at any time, without a root entry. 44.0.2 SurvivalMission 61/67/68/69 are assigned in `frame_79` (the root) of the canonical decompile (`frame_79[304] = function(p61_0, p61_1)`, `[310]` p67, `[311]` p68, `[312]` p69). | **TRUE (static).** Enforced: only `parent == root` prototypes are retirable. |
| R5 | A per-prototype retired flag can close the existing process-wide fast gate. | The gate was `any admitted provider`. It is now `any admitted slot not retired`, recomputed from the published snapshot under one mutex after every publication, retirement and re-arm. Model: gate-closed observer 0.85–1.12 ns net per call. | **TRUE (gate)** |
| R6 | Overlapping instances (per-cast ability scripts) break per-prototype retirement. | Instance A starts, instance B starts, B retires: A's first call would be skipped. | **TRUE for a naive flag.** Fixed: the slot retires only when every known instance signalled it; each root entry adds a pending instance. |

## Design (generic; no module, mission or ability rule)

### Signal

- A `luaCalls[P].before` callback returns the exact string `"RENOVICE_RETIRE"` (15 bytes plus NUL, case-sensitive).
- The leaf reads one result after a **successful** protected call, before it restores the stack
  (`lua_call_before_leaf_is_retire_signal`: tag string, `+0x18` text, bounded probe, `memcmp` including the terminator).
  It counts `invoked_count` and `retire_signals`.
- `dispatch_lua_call_phase` retires only after the committed copy-back, and only when
  `retire_signals != 0 && retire_signals == invoked_count`: every provider that ran for that prototype agreed. A failed
  dispatch returns earlier and never retires. The retiring call's own mutations are delivered.

### Scope

One `LuaCallRetireLedger` (`renovice/lua_call_retirement_core.hpp`) per **(committed generation, target key, VM, binding
fingerprint)**, with one bit per declared prototype (≤ 64; FNV-1a-64 over the providers' registry keys, which change on
every rebind).

- **Instance.** One observed root execution of the module in that VM, identified by the environment its closures carry.
  `inspect_target_root_entry` matches `snapshot->instance_roots` (the recorded root prototypes of every (key, VM) with a
  ledger) and calls `note_lua_call_instance_entry` **before** the naked stock VM execute. At the normal return,
  `note_lua_call_instance_settled` replaces the entry environment with the settled environment.
- **Retired.** Slot *i* is retired when it is a root child, no untracked member is pending for it, the ledger has not
  overflowed, and every tracked instance has served it.
- **Untracked member.** A new ledger starts with all retirable slots pending in one untracked member: instances that existed
  before the ledger (F9 mid-mission). The first signal for a slot serves it. Overlapping instances that all predate the
  ledger therefore count as one (documented limit).
- **Bound.** At most 16 tracked instances. When full, members that served every slot signalled so far are evicted; their
  never-signalled slots fold into the untracked member. If nothing can be evicted, the ledger overflows and every slot
  stays armed until the ledger is replaced.

### Re-arm

- **New instance:** every natural root entry re-opens the module's slots before the root runs.
- **F9:** every F9 runs `apply_generation`, which commits a new generation and republishes; a ledger is reused only for the
  identical generation, key, VM, prototype set, root-child set and binding fingerprint.
- **Rebind, enable, disable:** new registry keys change the fingerprint; a removed provider drops its ledger.

### Fail closed

- Retirement requires the ledger the dispatch ran under to still be **registered** (dead generation or superseded binding:
  `ignored-superseded-generation-or-binding`) and to own the calling VM (`ignored-cross-vm`).
- An ambiguous owner never dispatches (`select_target_prototype_owner`), so it cannot retire.
- A non-root-child prototype, an undeclared prototype, a slot beyond 64 or an overflowed ledger never retires.
- Any exception on the ledger path stores the gate open (dispatch continues).

### Hot path

- **Every admitted slot retired:** the interrupt observer returns after one atomic load (`lua_before_provider_fast_gate`),
  the same code path as "no provider".
- **Another slot still armed:** the call pays the existing pre-claim work (instruction decode, window, lease, owner
  selection) that every Lua call pays while the gate is open, then `target_provider_claims_lua_before` rejects the retired
  slot with a lock-free atomic read, before any VM-top write, Lua entry, allocation or formatting.
- Root entries of watched modules take one small mutex-guarded ledger update (no Lua, no VM write).

### Diagnostics (Diagnostics on only; nothing is formatted when off)

`RENOVICE LUACALL_RETIRE event=retire|rearm|ignored key=… vm=… generation=… binding=… prototype=… slot_dispatches=N
dispatches_total=M instance=K instance_env=… outcome=… retired_mask=0x… pending_instances=… untracked_pending=0x…
overflow=0|1`.

- `retire`: one line per (target, prototype, instance) state change.
- `rearm`: one line per root entry that re-opened a retired slot.
- `ignored`: once per ledger and prototype.
- `slot_dispatches` / `dispatches_total` are relaxed counters of committed dispatches. They are the live evidence that
  nothing is dispatched while a slot is retired.

## Measured cost (`verify_lua_call_retirement.ps1`, x64 `/O2`, this machine)

| Path | ns per call |
|---|---|
| Loop baseline | 0.26–0.28 |
| Interrupt observer with the gate closed (`preserve_stock_interrupt_result` + atomic load) | 1.13–1.39 (net 0.85–1.12) |
| Claim check that rejects a retired slot (8 declared prototypes) | 3.48–3.72 (net 3.21–3.46) |
| Reference: one single-page `IsBadReadPtr` probe (the open-gate pre-claim path uses about a dozen, some over whole code ranges) | 2.09–2.45 |

Not measured offline: the open-gate pre-claim path and a full dispatch; both need a live VM. The live plan below compares
dispatch counts instead.

## Gates

- New `RENOVICE_TOOLCHAIN/injection/verify_lua_call_retirement.ps1` (in the build):
  - model self-tests: signal, backward compatibility, retire, fast-path rejection, re-arm on a new instance, overlap,
    settle, F9 and rebind identity, fail-closed boundaries, bound and eviction, independence of other targets and VMs;
  - micro-benchmark;
  - DE-compiled probe fixture (`derecomp recompile-u44` + `de-roundtrip`): the sentinel is a pool string and not a declared
    key;
  - source invariants for the gate order, claim check, publication, ledger binding, retire, re-arm, leaf, dispatch
    ordering, and the absence of the sentinel from the nativeCalls leaf.
- `verify_lua_call_raw_protection.ps1` (now in the build): pins `protected_call(state, 4, 1, 0)` instead of `4, 0, 0`.
- `verify_target_root_binding.ps1`: the return path now settles once, queues only retry-watched roots, and notes instance
  roots.
- Every other build-listed gate: unchanged and PASS.

## Build

`RENOVICE_TOOLCHAIN/build_private.ps1` (shell with `NoDefaultCurrentDirectoryInExePath` unset): 33/33 build-listed gates
PASS, then `PRIVATE BUILD PASS flavor=main warnings=0 errors=0 x64=yes companion_import=no bytes=5619200
sha256=372a9eeafd796227f2a55550efe77e20f5f3b64d85d88b0ca0a60ac63f4918c7`. The archive is time-versioned, so the hash is
specific to this build instance. Bridge `2e337a43…` unchanged. Staged in `work/staging/editor-phase2-3/` with the opt-in
probe `live-test-retire/OpenWF/CustomScripts/Inject/RetireProbe.targets.addon.lua_B` (built from
`RENOVICE_TOOLCHAIN/injection/fixtures/RetireProbe.targets.addon.luau`); the `9e44f885` set moved to
`older/codec-9e44f885/`.

## Limitations (exact)

- A root invoked by a Lua-to-Lua call (no VM-execute entry) is not observed as a new instance. Module roots are called by
  the loader from C; the existing root-return retry relies on the same fact.
- An instance is identified by its closures' environment. Overlapping instances that share one environment count as one.
- Instances that predate a ledger count as one (see the untracked member).
- If a module replaces the table a retired hook wrote into (a later assignment to the same root local), the hook does not
  see the new table until the next re-arm. The generator must not retire such hooks (contract R3).
- Retirement exists only for `luaCalls.before`. `nativeCalls`, damage and lifecycle hooks are unchanged.

## Rejected designs

- **Closure-address retirement:** ABA through Luau free lists (R2).
- **Pinning retired closures in the registry:** keeps a finished instance alive; it changes game object lifetime.
- **A single per-prototype flag re-armed only at root entry:** misses overlapping instances (R6).
- **Lazy instance tracking from the first signal:** collapses every instance that existed before the first signal; eager
  tracking costs one mutex-guarded update per root entry of a watched module only.

## Live check (pending; the user runs it)

See the handoff entry in `RENOVICE_SCRIPTING/CURRENT_BOOTSTRAPPER_STATE.md` and `work/staging/editor-phase2-3/README.md`.
