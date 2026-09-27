# V109 DE VM authority transaction research

Date: 2026-09-19
Status: `DEPLOYED_OFFLINE_VERIFIED_LIVE_ACCEPTANCE_PENDING`
Scope: DE-Luau/Pluto ownership, the latest Arsenal/loadout failure chain, and the
minimum universal runtime correction. Earlier intermediate candidates remain
invalid historical evidence. The final V109 candidate passed the complete
private build, was packaged with the exact V108 rollback, and was installed as
the sole changed game file. This document does not claim startup or in-game
acceptance until the fresh-process test below is completed.

## Result

The old UI corrections are still present. Current source leaves
`UpdateFlashMarkers` stock, keeps periodic Pluto work out of the broad DE
interpreter-return callback, and retains the native Application-frame boundary
as the scheduler clock. The latest V108 Arsenal failure therefore does not show
that those corrections were removed.

The missing invariant is stronger: a safe clock location does not itself grant
authority to mutate DE's process-owned Luau state. DE serializes ScriptMgr
execution, resume, reset, and garbage collection with one engine critical
section and invokes Lua/C work through a protected host frame. The V38-V108
Application scheduler checked thread, VM, stack, and idle `CallInfo`, but it did
not acquire that ScriptMgr lock and raw `ivkr_call` could jump directly into a
game C function. Those paths could still race or violate DE's call-frame
contract during UI and inventory transitions.

V109 is intended to complete that ownership boundary without removing Pluto,
Inject, Replacement, target addons, ability cards, the SCRIPTS UI, F9, or F10:

1. the Application hook remains only the clock and physical hotkey-edge source;
2. every Pluto-to-DE operation enters one ScriptMgr-owned transaction;
3. Pluto is hosted by DE's protected call path while that transaction is held;
4. a `gFlashMgr` generation opens only after stock publication and closes before
   stock Flash shutdown;
5. `ivkr_call` uses the protected DE call path and rejects retired generations;
6. the V108 process-wide call observer may mutate arguments only after strict
   live module, environment, prototype, and provider admission checks.

The first implementation audit found additional reachable ownership
violations. Those paths were repaired before the final candidate was built;
the complete private build and installation audits now pass. Live gameplay
acceptance remains separate.

## Reopened longjmp and stack-boundary audit

DE Lua errors use native `longjmp`; they do not run C++ destructors. The first
V109 build still let stock or allocating DE calls cross C++ mutexes, generation
leases, scoped TLS flags, strings, and vectors. A caught script error could
therefore leave RENOVICE ownership poisoned even while Warframe continued. That
is a direct architectural match for a responsive game trapped between two UI
screens and for a later unrelated-looking fault.

The audit uses a strict rule: a call which can raise a DE Lua error is either
inside the exact DE protected boundary with a destructor-free POD leaf, or its
stock invocation is naked and every RENOVICE-owned C++ object has ended first.
The following results are pinned before any new live claim:

| Hypothesis | Result | Evidence / action |
| --- | --- | --- |
| Physical free stack space alone proves a safe host call | **False** | The current `CallInfo::top` is a second independent limit. Host closure, copied arguments, and scratch space now require both `stack_last` and `ci->top` capacity. |
| DE's raw protected runner restores the full VM frame | **False** | RVA `0x4E5430` restores the prior error-jump link and returns status only. The shared wrapper now relocation-safely snapshots and restores `ci`, `ci->top`, `intop`, and `outtop`. |
| The registry pseudo-index is `-10002` | **False** | This client uses `-10000`; host-closure publication and lookup were corrected and exact readback-gated. |
| The stock VM execute hook may retain a generation lease or TLS owner | **False after source repair** | Stock VM execution is now naked. Optional work finishes first, and cleanup/control work resumes only at an exact base-`CallInfo` idle return. |
| `RunScript`, `PushFloatArg`, `SetSourceObject`, and `SetDamageCallback` may lend RAII ownership to stock | **False after source repair** | Each now uses prepare, a trivially-copyable/self-validating boundary, naked stock invocation, and post-return generation re-admission. Exact-idle recovery clears a boundary skipped by longjmp. |
| The generic `native_call_adapter` is already safe | **False in the first candidate; repaired in final V109** | The final path performs provider work in a destructor-free protected leaf, invokes stock exactly once without C++ owners crossing the boundary, and resumes same-generation post-processing only after protected return. |
| Loader failures are bool-only | **False** | Undump/checkstack failures are internally protected and converted to bool, but later setfield/metamethod or allocation errors can escape by DE longjmp. Loader calls require a protected stock boundary plus exact rethrow after C++ cleanup. |
| An exact rethrow primitive is unavailable | **False** | Exact-build RVA `0x991C90` has ABI `[[noreturn]] void(luau_State*, int)` and rethrows the unchanged raw-protected status into the restored outer DE error handler. |
| Raw numeric and pop/top OpenWF bridge exports are bounded by the active frame | **False in the first candidate** | Numeric pushes must use the same protected dispatcher; raw top/base/pop and typed-pop exports require full `stack <= intop <= outtop <= ci->top <= stack_last` validation and underflow rejection. |

The deployed DLL was built only after every row above was repaired and the
focused longjmp, UI, lifecycle, generation, and bridge gates passed.

## Pinned latest crash evidence

Evidence directory:

`C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\work\diagnostics\ARSENAL_LOADOUT_UI_REGRESSION_2026-09-19_172339`

The capture manifest identifies the installed V108 DLL:

- bytes: `4,790,784`;
- SHA-256:
  `82D34D2321667909E11327535A33B1D4E71130F6C9AB31A9C9DB255CAA676227`;
- `EE.log` SHA-256:
  `915A421E3266F02FAE70C2A66141CA06A285CC4635460314ABFF8801D0BD630E`.

The exact visible failure chain in `relevant_ee_excerpt.txt` is:

1. At 33.133 seconds, `LoadOutRedux.swf` begins opening. Stock reports three
   unknown-clip callback warnings and begins a 1,737-item resource load.
2. At 63.876 seconds, `LotusUtilities.lua::Update(9761)` fails while called from
   `ItemInfoPopup.lua::Update(3189)`. The accumulated application error list also
   names `DiegeticUpgradeCards`, `ImeTip`, `ThemedContextMenu`, and
   `ItemInfoPopup`.
3. At 82.510-82.513 seconds, `DiegeticUpgradeCards` requests the previous screen,
   `Background` pushes `LoadOut`, and `LoadOutRedux` begins another initialize.
4. At 82.520 seconds, `LoadOutRedux.lua::Initialize(14719)` raises
   `attempt to index nil with number`, reached through lines 14765, 16094, 16196,
   and 18439 and reported through `Background.lua::Update`.
5. The engine nevertheless creates `LoadOutRedux.swf` and subscribes
   `LoadoutReduxInputFilter`. This directly explains the half-transition: the
   intended screen did not initialize, while its movie/input owner remained
   active.
6. At 100.208 seconds, the process records a GPF at `0x239228e2e08` after more
   script application errors.

The crash capture's saved configuration says `Logging=false`,
`Diagnostics=false`, and `DiagnosticsMaxEvents=32768`. Its RENOVICE source and
fault logs were last written on 2026-09-17, two days before this crash, so they
cannot identify the exact V108 observer call or native instruction that first
corrupted state. The EE sequence proves the immediate UI failure and stale input
ownership. It does not prove the upstream native writer.

## Hypothesis ledger

| ID | Hypothesis | Result | Evidence |
| --- | --- | --- | --- |
| H1 | The exact `Limbo` text, frame data, or stock search comparison was the root cause of the historical search crash. | **FALSE, live.** | V23 changed only the native `UpdateFlashMarkers` replacement boundary and the exact search completed. V37/V104 restored that boundary and reproduced the same null-continuation crash family. |
| H2 | The SCRIPTS menu bridge is required for the searchable-menu/half-transition failure. | **FALSE, live A/B.** | The historical bridge-disabled generation reproduced the wider `LoadOutRedux` to `UpgradeCards` failure class. |
| H3 | V108 restored the rejected `UpdateFlashMarkers` method-table hook. | **FALSE, source.** | `verify_safe_runtime_tick.ps1` rejects both `UpdateFlashMarkers` markers in `main.cpp`, and the current source passes that gate. |
| H4 | V108 returned ordinary Pluto/background ticks to the broad DE interpreter-return callback. | **FALSE, source.** | The current callback is pending-only; the gate rejects `bgscript`, ordinary scripts, `luau_L` switching, hotkeys, and error-handler work there. |
| H5 | Diagnostics caused the latest V108 Arsenal reproduction. | **FALSE for this reproduction.** | The captured configuration had `Diagnostics=false` and the diagnostic logs predate the crash. |
| H6 | `ci == base_ci`, valid stack bounds, the owner thread, and a returned Application frame are sufficient authority to mutate DE's Luau state. | **FALSE, static native contract.** | DE uses the ScriptMgr critical section for reset, execution/resume, root/error handling, and GC. A state that appears idle is not necessarily exclusively owned. |
| H7 | DE has a protected host-call path that RENOVICE can reuse. | **TRUE, static native contract.** | The pinned executable exposes a ScriptMgr-locked synchronous dispatcher and a public protected-call boundary. V109 resolves and cross-checks those primitives uniquely. |
| H8 | Raw `f(luau_L)` or `luauD_call` is equivalent to DE's protected host frame. | **FALSE.** | It bypasses DE's protected call-frame/error path. V109's source gate rejects both raw borrowed-state routes. |
| H9 | A non-null cached `gFlashMgr` pointer proves the UI subsystem remains live. | **FALSE.** | Stock shutdown releases Flash resources without proving that every published reference was cleared. Liveness requires an explicit generation opened by publication and closed before shutdown. |
| H10 | The V108 process-wide Lua-call observer is already restricted to a provably live target closure. | **FALSE for V108; TRUE in V109 source by construction.** | V109 requires the exact VM, module environment, rooted prototype graph, live prototype fields, exact provider prototype, and an admitted immutable generation before it can touch VM tops. Live acceptance is still pending. |
| H11 | The V108 observer caused the exact latest Arsenal crash. | **UNRESOLVED.** | It was a new process-wide surface and its prior identity test was too weak, but this capture has no current observer event tying it to the first bad write. |
| H12 | V109 is now proven to fix the Arsenal/search crashes. | **UNRESOLVED / NOT YET TESTED.** | Static contracts and source gates pass. No V109 gameplay run exists in this document. |
| H13 | V109 requires deleting or disabling Pluto, addons, replacements, SCRIPTS, F9, or F10. | **FALSE by source design.** | Those feature paths remain present. V109 changes their authority boundary and fails the DE bridge closed when ownership cannot be proven. Gameplay acceptance remains pending. |
| H14 | The public protected-call wrapper can protect creation of the first DE host closure. | **FALSE.** | That wrapper requires a callable closure already on the DE stack. The former publication path called `luau_pushcclosurek`, string interning, and registry table APIs directly from the detour frame. |
| H15 | The pinned client exposes an engine-owned raw protected runner suitable for the non-yielding publication batch. | **TRUE in exact-build static evidence.** | RVA `0x4E5430` has ABI `int(luau_State*, void(*)(luau_State*, void*), void*)`, saves/restores the prior error-jump record, and returns the protected status. Its 36-byte relocation-tolerant signature has one match in executable SHA-256 `CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93`. |
| H16 | A DE error during host-closure allocation or registry publication can still longjmp through the C++ publication/detour frame. | **FALSE in V109 candidate source.** | The entire allocation/intern/set/readback batch now runs as a C-only callback under the exact raw protected runner. The caller restores `outtop` by relocation-safe offset before testing status. |
| H17 | Every invocation of the exact Flash shutdown entry tears down the published manager. | **FALSE in exact-build static evidence; the complete branch is now mirrored.** | Stock requires both a live internal owner at object `+0xC8` and either the null sentinel at object `+0x10` or an unsigned reference count below `2` at resource `+0x0C`. The `JA` at RVA `0x5101B7` skips the entire teardown body when the latter count is above `1`. V109 resolves the RIP-relative sentinel from shutdown `+0x2A`, performs bounded reads, and retires only when the complete stock conjunction is true. |
| H18 | A transaction body can retire its own Flash generation yet still return `executed=true`. | **FALSE in V109 candidate source.** | Result publication now occurs only after a post-body generation, state, global-state, and owner-thread validation. A retired body returns `executed=false`. |
| H19 | Static object identity proves that every future stock shutdown `this` is the same address captured from `gFlashMgr`. | **UNRESOLVED / REQUIRES RUNTIME READ PROOF.** | The source requires exact pointer equality and therefore fails closed for mismatches, but the address relationship has not yet been observed across live initialize/shutdown/reinitialize transitions. |

## Preserved UI invariants

These are existing corrections, not new V109 claims.

### `UpdateFlashMarkers` remains stock

V21/V22 captured the generic SWIG/namecall closure with a null continuation.
V23 stopped replacing the native `UpdateFlashMarkers` method-table entry, after
which the exact previously failing Arsenal search completed. V37 and V104 later
restored execution inside that method and reproduced the same failure family.

The permanent invariant is therefore unchanged:

- do not replace `UpdateFlashMarkers`;
- do not use a HUD/native namecall as a general script clock;
- do not run recursive Pluto game-API work inside that live stock C/namecall
  frame.

Current `verify_safe_runtime_tick.ps1` rejects any return of that hook.

### The DE interpreter-return path remains pending-only

The V35 debugger capture stopped immediately after `bgscript->tick()` in the DE
VM return callback during the intermittent UI freeze. V36 removed ordinary
Pluto work from that route. It retained RENOVICE startup, explicit F9/SCRIPTS
reload, replacements, target addons, and the SCRIPTS bridge.

V109 preserves the same split:

- DE interpreter return: explicit RENOVICE pending transaction only;
- Application frame: OS hotkey-edge sampling and a request to run a Pluto frame;
- DE state mutation: the new ScriptMgr-owned protected transaction.

### The Application hook remains a clock, not authority

V38 correctly moved periodic Pluto work until after the original native
Application frame returned. V109 keeps that successful placement. The
correction is that the clock now asks `de_vm_authority::transact` to obtain the
actual DE ownership contract; the Application callback no longer invokes the
Pluto tick directly.

## V109 intended architecture

### 1. Exact ScriptMgr ownership

`renovice/de_vm_authority.cpp` resolves six build-specific primitives:

- ScriptMgr lock enter;
- ScriptMgr lock leave;
- the stock locked dispatcher, used to cross-check the lock holder and enter
  function;
- DE's protected call boundary;
- DE's raw protected runner for non-yielding API batches that must allocate the
  first callable closure;
- FlashMgr shutdown.

Initialization fails closed unless every pattern is unique, the dispatcher
cross-checks the resolved lock primitive, the lock holder is readable, and the
shutdown detour installs. A failed authority initialization leaves the
Pluto-to-game bridge dormant; it does not alter stock UI execution.

`transact` then:

1. enters the exact ScriptMgr critical section;
2. validates the admitted state, `GlobalState`, owner thread, and generation;
3. for the Application scheduler, additionally requires the idle base
   `CallInfo` and ordered stack bounds;
4. acquires an in-flight generation lease;
5. installs a thread-local transaction token;
6. invokes the transaction body;
7. releases the generation lease and ScriptMgr lock through RAII on every
   return path.

Native DE callbacks may enter with `require_idle=false` because a valid
game-owned C `CallInfo` is expected to be active. They still require the same
state, owner thread, generation, and ScriptMgr transaction.

### 2. Flash generation ownership

Both hashed and named `gFlashMgr` setters capture the proposed object, call the
stock setter first, and commit the publication only after stock returns. A valid
publication records:

- the exact DE state;
- its `GlobalState`;
- the Flash object;
- the owner thread;
- a monotonically increasing generation;
- whether new work is admitted;
- the current in-flight count.

The FlashMgr shutdown detour closes admission and invalidates the published
state before calling stock shutdown only when the exact published object also
passes stock's complete outer teardown predicate: the internal owner at object
`+0xC8` must contain a non-null owned pointer, and the resource at object
`+0x10` must be the resolved null sentinel or have unsigned reference count
below `2` at resource `+0x0C`. A stock no-op shutdown does not retire an
otherwise live generation. The detour does not wait inside shutdown, because
shutdown may be nested on the same owner thread. Operations already in progress
retain a lease and must detect generation retirement before returning results
to Pluto.

Publication itself explicitly reacquires the recursive ScriptMgr critical
section. Closure allocation, registry-key interning, registry mutation, and
exact readback run inside the raw protected runner at RVA `0x4E5430`. That
callback owns no non-trivial C++ automatic objects; if DE raises an error, the
engine returns a nonzero status and the caller restores the DE stack by saved
byte offset. Admission opens only after status zero and exact registry
readback.

This generation is a subsystem-liveness token. It is not a replacement for the
separate addon/F9 handler generation.

### 3. DE-protected Pluto host frame

The native Application detour first calls the original frame function and polls
physical F9/F10 edges. It then requests an idle authority transaction.

Inside that transaction, `run_openwf_frame_transaction`:

- revalidates the idle UI state and active authority token;
- reserves the DE VM stack;
- saves `outtop` and `intop` as relocatable offsets;
- pushes `tick_openwf_scripts_at_native_frame` as a DE C closure;
- invokes it through `de_vm_authority::protected_call`;
- restores both stack tops unconditionally.

The Application detour contains no direct call to the Pluto tick. This ensures
that Pluto execution has a DE-created/protected host frame while the ScriptMgr
lock and Flash generation lease remain owned.

### 4. Protected `ivkr_call`

The prior bridge could directly call a borrowed game function. V109 instead
requires an active authority transaction, validates the argument count and
stack capacity, pushes the requested C function as a DE closure, relocates the
arguments behind that function slot, and invokes the call through DE's protected
boundary.

After return it verifies both protected status and that the authority generation
is still live. Failure clears the partial result range and reports an error to
the owning Pluto call. The source verifier rejects direct `f(luau_L)` and
`luauD_call(luau_L)` paths.

Synchronous game-to-Pluto callbacks re-enter the same authority transaction,
hold `running_scripts_mtx`, install the owning script's callback context, and
restore `luau_L` and callback state on exit.

### 5. V108 observer gating

The process-owned interrupt-counter-leaf observer remains installed so generic
`luaCalls.before` addons continue to work. V109 narrows the mutation admission
path before it saves or writes any VM top:

1. a generation-dispatch lease and immutable execution snapshot must exist;
2. the live closure must be Lua, readable, and belong to the exact DE
   `GlobalState`;
3. its environment must equal the captured target module environment;
4. the recorded root must still be a root prototype (`parent == 0`);
5. both root and selected prototype must retain the captured address, code
   pointer, instruction count, and bytecode ID, with readable code bytes;
6. the immutable provider snapshot must explicitly admit
   `luaCalls.before` for that exact target key, VM, and prototype;
7. ambiguous matches reject the dispatch;
8. only after those checks may the observer copy arguments and dispatch the
   provider; `intop` and `outtop` are restored by scope exit.

Unrelated UI/interpreter calls take the read-only rejection path. This is a
universal target identity gate, not an Ice Wave, Mallet, or UI-specific branch.

One boundary remains explicit: strict live-prototype gating does not implement
the full stock-record retirement model described in
`TARGET_MODULE_IDENTITY_LIFETIME.md`. Binding every identity to the complete
stock record set and retiring RENOVICE roots at stock record cleanup remains
separate work. V109 must not be described as proving that lifetime problem
complete.

## Capability preservation

V109 changes the ownership boundary rather than removing features. Current
source still contains:

- upstream Pluto background/dashboard and ordinary `.pluto` coroutine ticks;
- RENOVICE raw Inject and Replacement initialization;
- target addons, native hooks, ability-card hooks, and immutable handler
  snapshots;
- SCRIPTS UI generation and persisted script states;
- pending-only startup and F9 generation commits;
- process-frame F9/F10 edge latching;
- the F10 Simulacrum request;
- existing deferred registry release handling;
- stock `UpdateFlashMarkers` behavior.

This is source reachability, not live behavior proof. The supported-build
authority deliberately fails closed if the required engine primitives or
generation cannot be proven.

## Diagnostics profile for V109 testing

The V108 crash evidence had diagnostics disabled. At documentation time, the
live test configuration at
`C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\CustomScripts\renovice.cfg`
is:

```text
Logging=true
Verbose=true
AutoSpawn=false
Diagnostics=true
DiagnosticsMaxEvents=32768
```

Its current SHA-256 is
`4668A22DAAB48DFE7F6C34005B08AAEF446074F4A2EFE0E5B60EFB066F1C0AD0`.

`Diagnostics=true` enables the central diagnostic lanes. The configured event
generation is bounded to 32,768 records, and high-frequency diagnostic
producers use the shared budget or their own smaller derived budget. Authority
generation records are transition events rather than frame events. Operational
source logging is separately enabled for startup, loader, ownership, and F9
evidence.

The bound limits diagnostic event production; it is not proof of zero runtime
cost, zero disk growth, or stability. The live test must exercise both
diagnostics enabled and diagnostics disabled. If the enabled run reaches its
budget, suppression/drop counters are evidence and must not be treated as
missing gameplay execution.

## Offline verification completed

The following gates passed against the V109 candidate source on 2026-09-19:

```text
DE VM AUTHORITY PASS clock=Application ownership=ScriptMgr generation=Flash protected-call=DE callback-owner=retained raw-call-paths=none
SAFE RUNTIME TICK SOURCE PASS renovice_pending_only=yes native_application_frame_pluto=yes stock_UpdateFlashMarkers=yes upstream_bgscript_sha256=DC072A9E16937160A4F7DD6AB9A8B89077E3BE137362263ABF813282A2FDD015 renovice_drain_in_pluto_tick=no exact_ui_vm=yes owner_thread=yes idle_base_ci=yes recursion_guard=scoped f9_latch_any_owner_vm=yes explicit_reload_unthrottled=yes blocked_reason_diagnostics=yes exact_T_rebind=yes
DE VM AUTHORITY STRICT SYNTAX PASS warnings=0 errors=0 compiler=clang target=x86_64-pc-windows-msvc standard=c++20
PRIVATE BUILD PASS warnings=0 errors=0 x64=yes companion_import=no bytes=4813824 sha256=fc98b63625abf87956202396e0d2b693c3742c2f79550e8922abeb27267cc169
```

The relevant deterministic gates are:

- `RENOVICE_TOOLCHAIN/runtime/verify_de_vm_authority.ps1`;
- `RENOVICE_TOOLCHAIN/runtime/verify_safe_runtime_tick.ps1`.

The source baseline is Git HEAD
`ee3d97dff09971c73543478ecf96b23c795112d6` plus uncommitted V109 candidate
changes. The files are intentionally identified as mutable candidate source;
any later build or deployment manifest must pin its own final hashes.

## Proof boundary and required live acceptance

### Proven offline

- The pinned U43 native analysis identifies the ScriptMgr lock wrappers, locked
  dispatcher relationship, public protected-call path, raw protected runner,
  and Flash shutdown boundary.
- The raw-runner signature resolves exactly once in the hash-pinned executable;
  its function type and callback ABI match RVA `0x4E5430` pseudocode.
- Current source contains the intended authority transaction, Flash generation,
  protected publication batch, protected Pluto host, protected `ivkr_call`, and
  strict observer admission.
- The old UI invariants remain enforced by deterministic source gates.
- The upstream LF-normalized `OpenWF/bgscript.pluto` identity remains pinned by
  the safe-runtime verifier.
- The complete private build, archive generation, x64 image check, and companion
  import rejection passed with zero warnings and zero errors. The resulting DLL
  is 4,857,344 bytes with SHA-256
  `45B8BDA11BEF71F2873A1DE1E90837A6AAFE7FE4C157ED16CBEE4D6A719F1C69`.
- `Hotfix.owf` is 54,157 bytes with SHA-256
  `E0938CAF65277A52DB23275AEE0CACB985CCBD4895C097A7F2E598A75B49CC0E`.
- The finalized package verified the exact V108 rollback, supported game
  executable, diagnostics-on configuration, 90 audited installation files, and
  39 CustomScripts files. Deployment changed only `WTSAPI32.dll`; the installed
  DLL matches the candidate hash above.

### Not proven by this document

- startup resolution of every native signature;
- live status-zero execution of the protected host-publication batch and exact
  registry readback;
- live proof that captured `gFlashMgr` and the relevant shutdown `this` retain
  the same address across every UI generation;
- first successful locked/protected Pluto frame;
- Scripts menu presentation;
- exact `Limbo` and full-name searches;
- repeated Arsenal, inventory, loadout, modding, and menu transitions;
- F9 reload safety or F10 Simulacrum behavior;
- Mallet Overguard/threat/card behavior;
- Ice Wave card and target-local Cold-stack damage;
- Survival, Railjack, mission transitions, long-session memory stability, or
  diagnostics enabled/disabled soak behavior;
- complete target stock-record retirement and registry-root return to baseline.

### Live acceptance sequence

After a separately verified rollback and deployment of the hash-pinned build:

1. Confirm exact V109 startup identity and a unique authority initialization
   pass. Confirm one `OPENWF_FRAME build=V109 event=FIRST_PASS` record with the
   locked/protected boundary.
2. Confirm the Pluto dashboard, background script, ordinary `.pluto` scripts,
   and the SCRIPTS menu all remain functional.
3. Repeat exact `Limbo`, complete Warframe names, `00`, and the prior weapon
   searches several times. Exercise search-result loading, clear/retype, screen
   exit, and immediate entry into another menu.
4. Repeatedly enter and leave Arsenal, loadouts, Upgrade Cards, inventory,
   Archon Shards, Railjack configuration, Navigation, and missions. Reject on
   stale input ownership, a UI-less half-transition, nil/table corruption, or a
   GPF.
5. Confirm Mallet's ability card, Overguard conversion, corpse exclusion, and
   threat behavior. Confirm Ice Wave's card and per-target Cold-stack/Strength
   scaling with multiple enemies.
6. Press F9, verify a generation commit, then repeat both ability tests and the
   UI transition sequence. Press F10 and confirm the Simulacrum transition.
7. Run the sequence once with diagnostics enabled at the bounded profile and
   once with diagnostics disabled. Compare error/suppression/drop counters and
   confirm gameplay behavior is identical.
8. Soak Orbiter, Survival, Railjack, Arsenal/inventory, and repeated mission
   return transitions. A responsive process and passing source gates do not
   replace this soak.

Only those live observations may change the status from
`CANDIDATE_BUILT_OFFLINE_VERIFIED_LIVE_UNPROVEN` to a live-accepted result.

## Evidence index

- Historical exact search crash and V23 live isolation:
  `RESEARCH/ARSENAL_SEARCH_CRASH_2026-09-02/README.md`, especially lines
  136-180 and 226-257.
- Pending-only DE return correction:
  `RENOVICE_DEPLOYMENTS/PENDING_ONLY_DE_TRANSACTION_V36_2026-09-07/README.md`,
  lines 5-30.
- Application-frame Pluto placement and preserved feature list:
  `RENOVICE_DEPLOYMENTS/NATIVE_FRAME_PLUTO_V38_2026-09-07/README.md`, lines
  5-28 and 48-65.
- Rejected V104 reproduction of the same old hook family:
  `RENOVICE_DEPLOYMENTS/PLUTO_RENOVICE_DECOUPLING_V104_2026-09-17/README.md`,
  lines 3-26 and 55-68.
- Native ownership contract:
  `C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\toolchains\native-analysis\RESEARCH\2026-09-19_RUNTIME_SCRIPT_PIPELINE\DE_EXECUTION_BOUNDARIES.md`.
- Target identity lifetime limit:
  `C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\toolchains\native-analysis\RESEARCH\2026-09-19_RUNTIME_SCRIPT_PIPELINE\TARGET_MODULE_IDENTITY_LIFETIME.md`.
- V109 authority implementation:
  `renovice/de_vm_authority.hpp`, `renovice/de_vm_authority.cpp`, `main.cpp`,
  `owf_scripting.cpp`, and `renovice/injection.cpp`.
