# Arsenal Warframe Search Crash — 2026-09-02

## Reproduction boundary

- Opening the Arsenal and browsing the unfiltered Warframe list succeeds.
- Typing a Warframe name such as `Limbo` or `Khora` crashes the client.
- Removing all user Lua add-ons and replacements does not change the crash.
- The V19 runtime explicitly leaves the stock `TopMenu` intact when the internal
  NAMECALL bridge is absent.

## Hypotheses and results

### A specific Limbo, Khora, inventory, or loadout record is malformed

**Result: false.**

- All 131 owned suit item types resolve in the current public export and local
  metadata snapshot.
- Their shared field shapes are valid.
- Limbo's saved helmet resolves exactly.
- The existing targeted account migration is idempotent and proposes zero
  actions.
- No inventory or loadout entry was deleted, merged, or sanitized.

### A RENOVICE Lua add-on or replacement causes the crash

**Result: false.**

- The crash remains with all injected/replacement scripts removed.
- The runtime log reports zero configured add-ons/replacements and preserves the
  stock pause-menu UI.

### The shared stock Warframe search path is the trigger

**Result: true at the behavioral boundary; exact failing instruction pending.**

- Multiple Warframe names reproduce the same crash.
- Empty/unfiltered browsing succeeds.
- Current `LoadOutRedux.lua_B` prototype 267 is the common additional-filter
  callback. It invokes `string.find(v0.SearchCache, searchableLabel, 1, true)`
  without a nil guard.
- Item population initializes `SearchCache` and later replaces it with the
  result of `LoadoutUtilities.GetSearchString`. A nil result for any suit card
  is therefore a concrete candidate, but this is not yet proof of the native
  null call shown in `EE.log`.

## Exact current-client artifacts

- `LoadOutRedux.lua_B`: 579045 bytes,
  SHA-256 `997ce718b3a63a3704d0c80e1263e4202000fd0548df017674ebc26e287d7b93`
- `LoadOutRedux.swf`: 31830 bytes,
  SHA-256 `1205fe20def180ebae0824026ce926bd9d0ead1a76ab0a99f8de528f7cdcd8b5`
- `LoadoutUtilities.lua_B`: 73243 bytes,
  SHA-256 `a15465c81f2837337406af44eb6bb4ee85817d89144d06c1026d2ed5fe6ecac7`

Extracted copies and decompiler outputs are under `artifacts/`.

## V20 diagnostic deployment

V20 installs a non-swallowing vectored exception observer. It records only
null/near-null access violations, writes the register state and raw stack with
module-relative addresses, and always returns `EXCEPTION_CONTINUE_SEARCH`.
It does not recover from, suppress, or otherwise change the game's exception.

Output after launch:

`Warframe/OpenWF/CustomScripts/renovice_fault.log`

Build validation:

- Private build: pass
- Warnings: 0
- Errors: 0
- Architecture: x64
- Existing runtime, API, script-UI, archive, and migration checks: pass
- DLL SHA-256:
  `48da4a02d6ab5e40fa532a9039059fef24d6abd46b9cb0f0bffbb603c2738c99`

The next required evidence is one reproduction with V20. The first relevant
stack word for a null indirect call should identify the exact caller in
`Warframe.x64.exe`; only then should the stock filter or another shared path be
patched.

## V20 live result

**The null-SearchCache hypothesis is false as the direct crash cause.**

V20 captured an execute access violation at address zero:

- Exception: `0xC0000005`
- Operation: `8` (execute)
- Immediate return address: `Warframe.x64.exe+0x19815C9`
- Null indirect call instruction: `Warframe.x64.exe+0x19815C7`
- Calling thread's `RBX` and `RCX`: the same live `luau_State*`

Disassembly proves that the VM loaded the current C closure's continuation from
`closure+0x20` and called it without a null check. That field was zero. The
surrounding routine matches Luau's `resume_continue`: release builds assert the
invariant only in source and then invoke `cl->c.cont(L, 0)`.

The behavioral transition is also narrower than text filtering:

- `limb` leaves multiple/non-exact results and does not crash.
- `limbo` enters single/exact-result selection.
- The client then spot-loads Limbo's suit/ability graph, rebuilds the loadout,
  and resumes a UI coroutine.
- That coroutine contains a C frame with an invalid null continuation.

This is a Luau call-stack/continuation invariant failure. The remaining question
is which C binding owns that frame and why it yielded without a continuation.

## V21 full diagnostic deployment

V21 extends the non-swallowing fault observer with:

- decoded `luau_State` pointers and bounds;
- up to 32 live `CallInfo` frames;
- every function TValue tag and closure address;
- C function, continuation, and remote debug-name fields;
- Lua proto identities;
- the native register/raw stack trace from V20;
- a Windows minidump with thread, handle, unloaded-module, indirect-memory, and
  full-memory-map information.

Outputs:

- `Warframe/OpenWF/CustomScripts/renovice_fault.log`
- `Warframe/OpenWF/CustomScripts/renovice_fault.dmp`

V21 build SHA-256:
`d69ac9a0cbf2f4bd10878ef00518729df5bd96f76fb27516b5b10c42a1b0f509`

Private build passed with zero warnings and zero errors. This deployment still
does not swallow, recover from, or modify the fault.

## V21 live result and exact call-site identification

**The specific suit data, search string, and user-script hypotheses are false.**

V21 reproduced the execute-at-zero fault and wrote a 67,428,714-byte minidump
(SHA-256
`9b8fec4e4fa3120c496827386cc37ce5814ce48c6313ccde8ad0f5aa66694e0f`).
The active frame is the generic SWIG/namecall C dispatcher at
`Warframe.x64.exe+0x197BBF0`; its continuation is null. The native return site
remains `Warframe.x64.exe+0x19815C9`.

A focused masked-bytecode matcher parsed all 5,386 current stock corpus files.
It found exactly one match for the recovered instruction sequence:

- module: `/Lotus/Interface/PostCameraUpdateHud.lua`
- prototype: 46
- code offset: `0xAC`
- first native call: `u4:Name__02395800(mMovie)`
- second native call: `u4:UpdateFlashMarkers(u5, u6, v0)`

The latest `EE.log` call stack independently ends in
`PostCameraUpdateHud.lua Update`, after two `ContextAction.lua Update` frames.
Ember and Excalibur complete the same loadout rebuild normally; exact Limbo and
Khora filtering can expose the fault without a corresponding bad asset record.

## Root cause

**Hypothesis: the always-on OpenWF background status collector unsafely re-enters
the HUD while the engine is already executing `UpdateFlashMarkers`.**

**Result: true at the architectural and fault-site boundary. Live V22
confirmation remains required.**

The proxy replaces the native `UpdateFlashMarkers` method-table entry and uses
that call as its script tick. Before invoking the original method, the embedded
`OpenWF/bgscript.pluto` coroutine ran every 40 ms and called:

- `gRegion:GetLocalPlayer()`;
- local-player camera/avatar accessors;
- `GetHudStatus():GetFlashMarkers()`;
- `baseMarkerInfo:GetPosition()` for every marker.

That is recursive HUD/game-API work from inside the live DE-Luau native
namecall. A nested native operation can suspend the VM while the outer generic
C closure has no continuation, matching the dump's exact invariant failure.
It also explains why removing every user add-on/replacement does not help and
why the crash depends on the UI transition rather than one specific frame.

## V22 correction

V22 removes only the unconditional 25 Hz player/camera/HUD-marker telemetry
poll. The web dashboard receives a stable empty status snapshot until telemetry
is moved to a genuine engine-frame callback outside the Lua namecall stack.
The following remain unchanged:

- F9 reload;
- replacements and managed add-ons;
- hotkeys and ordinary scripts;
- explicit freecam, camera-lock, game-camera, and teleport commands;
- server messages, tunables, updates, and script-log broadcasts.

The V21 diagnostics remain armed, with deployed function tag 8 now decoded as a
closure in the text report. Source build validation passed with zero warnings
and zero errors; the x64 single-DLL artifact has no companion import.

## V22 live result

**Hypothesis: the unconditional 25 Hz player/camera/HUD-marker telemetry is the
required cause.**

**Result: false.**

V22 was loaded from the expected SHA-256 and the exact `limbo` search reproduced
the crash after that telemetry was removed. The new capture is again an execute
access violation at zero with return site `Warframe.x64.exe+0x19815C9` and the
same stock application stack. The corrected closure decoder proves frame zero
is the generic SWIG/namecall C closure at
`Warframe.x64.exe+0x197BBF0`, with `c.cont=0`.

This run also records zero generic add-ons, target add-ons, and one-shot scripts.
The internal NAMECALL bridge is absent, so the RENOVICE SCRIPTS UI is disabled
and the stock TopMenu is preserved. The custom pause-menu row is therefore not
the active crash source.

V22 minidump:

- 67,443,482 bytes
- SHA-256:
  `8708FD43709125709FBD20D1234912208D10EDC8ACB278ACC7F33A49752D8AF3`

## V23 decisive hook isolation

V23 does not replace the `UpdateFlashMarkers` native method-table entry at all.
The fault observer remains enabled and now records each Lua CallInfo's base,
top, proto, saved program counter, and twelve surrounding bytecode words. This
creates a binary result from one reproduction:

- no crash: the legacy OpenWF `UpdateFlashMarkers` script-tick hook is required
  for the corruption;
- same crash: the fault is independent of that hook, and the expanded frame
  bytecode identifies the remaining stock/private-server path directly.

This diagnostic boundary temporarily pauses the legacy per-frame Pluto/F9 tick.
It does not remove scripts or alter account, inventory, metadata, server, or
stock UI data.

## V23 live result

**Hypothesis: replacing the native `UpdateFlashMarkers` method-table entry is
the required cause of the Lua continuation corruption.**

**Result: true, live.**

With V23 loaded, the same exact Arsenal search completed normally. The user
confirmed that the previously crashing path now worked. V23 changed only this
hook boundary; its fault logger, replacement loader, account data, metadata,
server, and stock search code were unchanged. This rules out Limbo/Khora data,
the search text comparison, the removed 25 Hz telemetry, user scripts, and the
private-server account as the required cause.

The permanent correction must therefore keep `UpdateFlashMarkers` completely
stock. Merely reducing the work inside that native call is not sufficient.

## V24 safe scheduler architecture

V24 removes the legacy HUD method hook from source and moves the OpenWF
scheduler to the already-resolved Luau interpreter boundary. The callback runs
only after the original VM execute routine returns and all of these conditions
are true:

- the state belongs to the exact global VM captured from the natural module
  loader;
- execution is on that VM's captured owner thread;
- the current `CallInfo` is the base host frame, not a suspended Lua/C frame;
- both the process-wide VM depth and RENOVICE injection depth are zero;
- no scheduler callback is already running;
- at least 8 ms passed since the previous accepted boundary on that thread.

The callback has unconditional RAII restoration for the DE stack, panic/error
handlers, temporary native error bridge, and the global `luau_L` pointer. A
nested VM entry caused by a user script cannot recursively tick the scheduler.
The first accepted live boundary writes a one-time `FIRST PASS` record with its
thread, VM, `ci`, and `base_ci` identities.

### V24 hypotheses before live testing

| Hypothesis | Offline evidence | Result |
|---|---|---|
| The old HUD method can no longer be replaced accidentally. | The hook function, original pointer, feature macro, hash lookup, and method-table write were removed. A build gate rejects their return. | **True offline** |
| The scheduler cannot run inside the suspended namecall frame that crashed V21/V22. | The boundary requires `ci == base_ci`, zero VM depth after return, exact VM/thread ownership, and a recursion guard. | **True offline** |
| Startup injection, F9, hotkeys, background Pluto, and ordinary script ticks are restored. | Their existing scheduler body is registered as the new callback without changing its transaction logic. | **True by implementation; live proof required** |
| Exact Arsenal searches remain stable with the scheduler active. | The specific corrupting method-table hook is absent, but only an in-game run can prove interaction with the current client. | **Live proof required** |
