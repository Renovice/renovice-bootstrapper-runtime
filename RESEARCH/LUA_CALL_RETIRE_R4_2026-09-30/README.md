# R4 follow-ups to retire-after-use: S2 armed-prototype prefilter, S4 dormant re-arm, S5 retire-all (2026-09-30)

- Branch `feat/lua-call-retire-r4-2026-09-30`, from `feat/lua-call-retire-2026-09-30` `f3a3303` (DLL `372a9eea…`, the
  installed build; its hash was checked read-only in the game folder on 2026-09-30).
- Client: 44.0.2 (`2026.09.28.13.06`). No signature, RVA, offset or build registration changed.
- Specs: ability-editor `RESEARCH/UNIVERSAL_MISSION_REGISTRY_2026-09-29.md`, Phase 2k and 2k-R3b (`1792e23`), and
  `work/research/universal-mission-editor-2026-09-29/CONTRACT_PHASE1.md`. The contract for S5 is Revision R4 there.
- Scope: repository only. No game-folder or OpenWF-server write, no deploy, no push.
- Status: offline gates and the zero-warning private build **PASS**. **Every live check is pending.**
- Earlier record: [R3](../LUA_CALL_RETIRE_AFTER_USE_2026-09-30/README.md). Its design is unchanged except where noted
  below.

## Why

- **S4.** Module identities are never erased (`remember_target_module_identity`), and every F9 or settings apply creates
  new, fully armed ledgers (R3: the untracked member starts pending). A module that ran earlier in the session but is not
  in the current mission therefore held the process fast gate open after any apply, until it ran again (2k-10).
- **S5.** With R3 the gate stays open from a mission's root entry until each hooked prototype has run once. It never
  closes for an engine callback that does not fire (Survival 31, 69; 19 of the package's 64 hooks are engine-called with
  no static first-call time, 2k-11), even when the mission has nothing enabled.
- **S2.** While the gate is open, every Lua CALL and loop back-edge in the VM paid the pre-claim path: about a dozen
  `IsBadReadPtr` probes (one over the whole caller code range), a generation lease, an atomic `shared_ptr` load and an
  owner search over every published identity.

## Hypotheses and results

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| R4-1 | A VM-execute entry whose Lua call chain holds a non-root closure of a module is generic evidence that an instance of that module is running. | `vm_execute_detour` sees every C-to-Lua entry, including coroutine resumes (the resumed frame is the Lua caller of the yielding C function). 44.0.2 `SurvivalMission` `Mission` (proto 70) is a `while true` loop that calls the global `Sleep` (`frame_70[139] = Sleep`), so each resume enters with a Survival frame; 31 and 69 are engine callbacks. Prototype addresses are registry-pinned for the session, so there is no address reuse. | **TRUE (static)**, live pending |
| R4-2 | Waking only on that evidence is backward compatible for every addon. | A library module called Lua-to-Lua from other modules' frames is never entered from C with its own frame on the chain. A pre-R3 addon on such a module would lose dispatches after F9 until the module's next root entry. | **FALSE for all addons.** Restricted: only slots declared exclusively by *retire-aware* addons (addons, by name, that returned a sentinel for that (key, VM) before) start dormant. |
| R4-3 | Slot-level awareness would be enough. | Survival 69 may never fire in a mission, so it never signals; after the next apply it would start armed and hold the gate open during a different mission. | **FALSE.** Awareness is per addon (name) for the (key, VM). |
| R4-4 | Retire-all can reuse R3's scope and unanimity rule without new fail-closed cases. | The ledger serves a mask instead of one bit, through the same `serve` rule. Several addons on one key: only slots declared by retire-all addons and by no other addon are served. | **TRUE (gate)** |
| R4-5 | A retire-all form exists that degrades to R3 on the installed `372a9eea`. | `372a9eea` calls `protected_call(state, 4, 1, 0)`: Luau truncates results to one. `return "RENOVICE_RETIRE", "RENOVICE_RETIRE_ALL"` is therefore a plain R3 retire there. `"RENOVICE_RETIRE_ALL"` alone differs from the R3 sentinel at byte 15 (`'_'` vs NUL), so R3 never mistakes it. | **TRUE (source + gate)** |
| R4-6 | The callee prototype can be read at the interrupt with no probe, from memory the interpreter itself uses there. | The current CallInfo (range-checked in `[base_ci, end_ci)`), the word before `savedpc` (the same word `exact_current_lua_instruction` decodes), one register inside `[ci->base, ci->top)` within the stack, and the header of the closure in that register (the function the VM calls next). | **TRUE (static)**; equivalence gate below |
| R4-7 | A prefilter miss never hides a call the full path would claim. | Set = every published address of a declared slot that is armed or never retirable; a candidate or an unproven frame takes the unchanged path. Fuzz: 400,000 random frames (U43 and U44 opcodes), 28,206 full-path claims, 0 prefilter skips of a claimed call. | **TRUE (gate)** |

## Design (generic; no module, mission or ability rule)

### S4: dormant re-arm after F9 or settings apply

- `bind_lua_call_retire_ledgers_locked` creates a new ledger as before. If it replaces a **registered** ledger of the same
  (key, VM) (the predecessor), it inherits the predecessor's retire-aware addon names. Its untracked member starts
  **dormant** for `lua_call_retire_dormant_mask`: the retirable slots that only retire-aware addons declare.
- The first ledger of a (key, VM) (the module has just loaded) has no predecessor and starts fully armed, as in R3.
- A dormant slot counts as served: it is in the published retired mask, so the claim check rejects it lock-free and it
  does not hold the fast gate open.
- **Wake.** `note_lua_call_dormant_execution` runs at every natural VM-execute entry, before the naked stock execute.
  - It returns after one atomic load when no ledger is dormant.
  - Otherwise `lua_call_dormant_wake_candidate` walks the entered frame and up to 7 callers, and looks each Lua closure's
    prototype up in the dormant-wake set. The set holds the non-root prototypes of every module whose ledger is dormant.
  - A possible match takes the lease and wakes each registered dormant ledger of that VM whose module owns the exact
    prototype. Its untracked slots become pending again, and the gate refresh opens the gate.
  - No Lua runs and nothing is written to the VM. The lease and the mutex are released before the stock execute.
- **Roots are excluded.** A root entry is a new instance and re-arms through `on_root_entry`, as in R3. The old untracked
  member stays dormant; the new instance's first signal serves it (R3 rule).
- **Awareness** is recorded under the retire mutex for every addon index in the dispatch's signal mask
  (`LuaCallRetireLedger::note_aware_addon`, by `AddonRecord::name`, which is stable across F9, unlike registry keys).
- **Overflow** still arms every slot and clears the dormant hint (fail closed).

### S5: retire-all

- **Forms.** `return "RENOVICE_RETIRE_ALL"`, or `return "RENOVICE_RETIRE", "RENOVICE_RETIRE_ALL"`
  (`combine_lua_call_retire_results`). A retire-all second value after anything other than the R3 sentinel is no signal.
- **Leaf.** The leaf reads two results (`protected_call(state, 4, 2, 0)`, nil-padded).
  `lua_call_before_leaf_retire_signal` probes and compares the 16 bytes of the R3 sentinel first. Only a string whose
  byte 15 is `'_'` probes 4 more bytes. The leaf sets bit *i* of `signal_addons` (any sentinel) and `retire_all_addons`
  (retire-all) for provider *i* < 64. A provider at index ≥ 64 counts as a plain R3 signal.
- **Rule.** Unchanged unanimity: nothing retires unless every provider invoked in the committed dispatch returned a
  sentinel. With at least one retire-all, `on_signal_all` serves the calling slot and every retirable slot in
  `lua_call_retire_all_exclusive_mask`. That mask holds the slots declared by the retire-all addons and by no other addon
  of that (key, VM). They are served for the calling instance and for the untracked member, exactly as R3 serves one bit.
- **Fail closed.** The calling prototype must itself be a retirable root child; otherwise nothing retires (R3 outcomes
  `ignored-prototype-not-root-child` / `ignored-prototype-not-retirable`). Nested slots, slots beyond 64 and slots shared
  with another addon stay armed. The superseded-generation or binding and cross-VM checks run first, and an overflowed
  ledger retires nothing.
- **Re-arm.** Unchanged: a new root entry, F9 (then S4), rebind.

### S2: armed-prototype prefilter

- `LuaCallAddressSet`: a 1,024-slot open-addressing set of prototype addresses (at most 512 entries) behind a seqlock.
  One writer at a time (the retire mutex); readers are lock-free and allocation-free.
  - A reader gets a definite "no" only from a stable, published, unsaturated and not-disabled table.
  - During a rebuild, before the first publication, when saturated, or after `disable()` (every exception path, through
    `open_lua_before_fast_paths`), the answer is "maybe", which means the full path.
- `refresh_lua_before_provider_fast_gate_locked` rebuilds the set from the published snapshot before every gate store:
  every address in `Providers::lua_before_slot_prototypes` whose slot is not retired, or is beyond 64. It rebuilds the
  dormant-wake set and the watch flag in the same pass.
- The interrupt observer (`de_luau_interrupt_increment_detour`) calls `lua_call_before_prefilter` right after the gate and
  the re-entrancy check, before `exact_current_lua_instruction`.
  - `skip_not_a_call`, `skip_not_a_lua_closure` and `skip_not_armed` return at once.
  - `candidate` and `undecided` continue through the unchanged path: every probe, the lease, the owner search, the claim
    check and dispatch.

## Measured cost (`verify_lua_call_retirement.ps1`, x64 `/O2`, this machine)

| Path | ns per call |
|---|---|
| Pre-R4 open-gate path for an unrelated CALL, caller 512 instructions, 8 identities (same probe sizes, real gate lease, real `select_target_prototype_owner`) | 95.3–100.6 |
| Same, caller 4,096 instructions, 32 identities | 312.1–315.1 |
| **R4 prefilter miss** (real `lua_call_before_prefilter`), either case | **3.4–4.4** (28–86× less) |
| Prefilter added in front of the full path for an armed callee | 3.4–3.8 |
| S4 wake scan at a VM-execute entry while a ledger is dormant (4-frame chain, no match) | 7.9–8.2 |
| S4 wake scan when no ledger is dormant | one atomic load |
| Gate closed (unchanged, R3 benchmark) | 0.78–0.87 net |
| Retired-slot claim check (unchanged) | 2.36–2.65 net |

The "before" row models the rejection path offline (synthetic frame, real probe sizes); the live path also reads the
published snapshot through `std::atomic<std::shared_ptr>`, which the model includes. Not measured offline: a live full
dispatch.

## Gates

- `RENOVICE_TOOLCHAIN/injection/verify_lua_call_retirement.ps1` (in the build), extended:
  - **S5:** sentinel bytes and forms; R3-runtime backward compatibility; retire-all serves every root child including
    unfired ones; the gate closes; nested slots stay armed; per-instance scope with overlap; nested and undeclared
    signallers are ignored; overflow; F9 (untracked member); several addons (exclusive mask, index ≥ 64); other keys
    are untouched. A DE-compiled `RetireAllProbe.targets.addon.luau` must hold both sentinels as pool constants and
    exactly one target key.
  - **S4:** awareness by name; dormant after F9 (no claim, no gate); wake re-arms every slot; mid-mission F9 dispatches
    and retires again; a new root entry arms the new instance while the old member stays dormant; addons that never
    signalled start armed (backward compatibility, including a shared slot); nested slots are never dormant; first load
    is armed; overflow is armed with no dormant hint; the wake scan (chain depth 4 found, 8-frame bound, C and unrelated
    closures ignored, base frame checked).
  - **S2:** set semantics (unpublished, exact membership for 100 in and 4,900 out, rebuild, saturation, disable); a
    prefilter equivalence fuzz against a reference model of the full path (0 false negatives); edge shapes are
    undecided; retire and re-arm move a callee out of and back into the set; the before/after benchmark.
  - **Source invariants:** prefilter order (after the gate and re-entrancy check, before the first probe and the lease);
    the set is rebuilt before the gate store; every exception path goes through `open_lua_before_fast_paths`; the
    dormant start comes only from a predecessor with awareness; roots are excluded; the wake runs before the stock
    execute and does no VM work; retire-all runs through the ledger after the registration and VM checks; the
    nativeCalls leaf, nativeCalls dispatch and damage-callback regions use no R4 state.
- `RENOVICE_TOOLCHAIN/runtime/verify_lua_call_raw_protection.ps1`: pins `protected_call(state, 4, 2, 0)`.
- Every other build-listed gate: unchanged and PASS (33/33).

## Build

`RENOVICE_TOOLCHAIN/build_private.ps1` (Windows PowerShell 5.1, `NoDefaultCurrentDirectoryInExePath` unset):

- All 33 build-listed gate scripts PASS.
- `PRIVATE BUILD PASS flavor=main warnings=0 errors=0 x64=yes companion_import=no bytes=5628416
  sha256=731fdb112aa0fe74e00788e16359b1ad4a178a503b4ab04466a0d539c29fe1c5`.
- The archive is time-versioned, so the hash is specific to this build instance.
- The bridge `2e337a43…` is unchanged.
- Staged in `work/staging/editor-phase2-3/` with the opt-in probe
  `live-test-retire-all/OpenWF/CustomScripts/Inject/RetireAllProbe.targets.addon.lua_B` (`cd91cc05…`). It is built
  from `RENOVICE_TOOLCHAIN/injection/fixtures/RetireAllProbe.targets.addon.luau`.
- The `372a9eea` set moved to `older/retire-372a9eea/`.

Build note: in Windows PowerShell 5.1 the archive step turns git's stderr "LF will be replaced by CRLF" notice into a
terminating error. Two `.ps1` gate files (`eol=crlf` in `.gitattributes`) had been written with LF and were normalized
to CRLF before the passing build. A second build failure was two stray `/` characters from MSYS argument conversion
(`//` markers) during editing; both were fixed before the passing build.

## Limitations (exact)

- S4 wakes a module only when one of its non-root functions is on the Lua call chain (entered frame plus 7 callers) at a
  natural VM-execute entry. A module whose code runs only from other modules' frames (a library called Lua-to-Lua) is
  woken at its next root entry instead. Addons on such modules should not rely on a mid-mission F9 while they retire.
- S4 dormancy covers slots of retire-aware addons only. An addon that has never signalled for that (key, VM) keeps the
  R3 start (armed after every apply). Awareness is inherited only from the registered predecessor ledger. If an addon is
  removed and added back, awareness starts again.
- A mission that ends while a slot is still armed (for example a callback that never fired) keeps that slot armed until
  the next root entry of that module, the next apply (then dormant), or its signal. There is no generic end-of-instance
  signal. S5 removes the case for idle missions.
- S5 retires only slots declared exclusively by the signalling addons. It serves the untracked member, as R3 does, so
  instances that predate the ledger still count as one.
- The S2 set holds at most 512 addresses. Above that it answers "maybe" for every call (the pre-R4 path, correct but
  slower). The Missions package publishes 64 hook slots per identity.
- The S2 and S4 reads without probes rely on the interpreter's own invariants at the interrupt and at VM-execute entry.
  Every other shape is `undecided` and takes the probed path.

## Rejected designs

- **Dormant start for every slot:** loses dispatches of pre-R3 addons on library-style modules after F9 (R4-2).
- **Slot-level awareness:** a slot that never fired would keep the gate open after the next apply (R4-3).
- **Waking on the first dispatch of a dormant slot:** the gate is closed, so there is no dispatch to observe.
- **Keeping the prefilter set in the snapshot:** every lookup would need the lease that the prefilter exists to avoid.
- **SEH-guarded reads in the prefilter:** a first-chance fault would reach the process fault-diagnostics VEH (dumps).
  The prefilter uses range checks and interpreter invariants instead, and falls back to the probed path.

## Live check (pending; the user runs it)

See `work/staging/editor-phase2-3/README.md`.
