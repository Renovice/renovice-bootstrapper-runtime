# Additive DE-Luau injection source port

Updated: 2026-08-23

## Outcome

The ordinary one-shot `CustomScripts/Inject/*.lua_B` path is now implemented
directly in the restored OpenWF source. The implementation is offline-built and
signature-verified against the exact installed `2026.07.11.15.28` executable.
It has not been deployed or claimed live-complete.

The experimental `.persist` and `.spawn` routes are deliberately excluded from
this production slice. Their old code fabricates a script resource, scheduler
instance, vtable, locks, and coroutine enrollment state. Treating that research
as ordinary addon parity would reintroduce the unstable architecture that this
source migration is intended to remove.

## Hypotheses and results

### H1: additive injection is just another full-module replacement

Result: **FALSE**.

A replacement waits for a stock module body and substitutes bytes before DE
undumps it. Additive injection must instead capture a real script manager and
module name handle, fabricate a temporary loader descriptor, register a new
closure, execute it, and restore the registry entry it borrowed. These are
different lifecycle and ownership problems.

### H2: the old `SetStringVariable` detour must be copied

Result: **FALSE**.

OpenWF source already owns the `UpdateFlashMarkers` native callback and uses it
as its DE-Luau script-thread tick. The source port drains pending injection work
there. This preserves the proven thread boundary without installing a second
UI-string detour or coupling addon execution to riven rendering.

### H3: F9 needs another permanent 30 ms polling thread

Result: **FALSE**.

OpenWF already performs edge-triggered hotkey checks from its script tick. The
source port adds one `VK_F9` edge check to that existing foreground-window
path. It performs no directory scan while idle. F9 merely latches a request;
the next safe script tick reads the complete current folder once.

### H4: a reload may partially accept the readable files

Result: **FALSE**.

Startup, region, and F9 scans build a temporary, deterministically sorted
snapshot. Empty, unreadable, oversized, or currently unsupported experimental
entries reject the candidate. The active snapshot changes only after every
entry validates, so a bad F9 edit retains the previous generation.

### H5: a protected Lua call alone contains every failure

Result: **FALSE**.

The native DE loader and fabricated descriptor can fault before Lua's protected
call exists. The source port retains a thread-gated vectored exception guard,
restores the VM stack top, and restores the borrowed module-registry entry. It
also improves the deployed guard: if a native fault happens after the loader
may have shadowed the registry entry, the fault path makes one separately
guarded restoration attempt before returning.

### H6: the old `.persist` and `.spawn` experiments are ready for production

Result: **FALSE**.

They depend on generation-suffixed names, fabricated resource/scheduler
structures, several hardcoded layout fields, manual lock unwinding, and
coroutine enrollment. Files using those markers currently fail the whole
candidate snapshot with an explicit diagnostic. This is fail-closed and keeps
the proven ordinary one-shot path separate.

### H7: every U43 injector ABI fact is fully settled offline

Result: **FALSE**.

Seven required native functions have unique signatures in the exact installed
executable: module loader, name-key builder, getfield, setfield, checkstack,
game allocator, and protected call. Descriptor offsets are preserved from the
deployed working injector. One historical discrepancy remains: the deployed
runner recorded table/function tags `7/8`, while OpenWF's restored ABI header
names them `6/7`. The source safely accepts either only in contexts where the
value must be `_G` or a closure. A live diagnostic will determine the exact
current tags before narrowing the rule.

## Offline gates passed

- Injection core native test: 6 fixed classification/size/extension properties.
- Active Inject directory: readable, 0 ordinary chunks, 0 unsupported chunks.
- Exact July executable: all 7 injector signatures match exactly once.
- Full private source build: zero warning/error lines, x64, no companion import.
- Full-module replacement gate remains active; with injection enabled, the
  undump hook acts as a low-frequency region observer even when there are zero
  replacement bodies.

## Runtime behavior

```text
module load -> capture real manager/name/environment once
DE undump burst after quiet gap -> latch region request
F9 edge -> latch reload request
UpdateFlashMarkers script tick -> scan complete Inject folder transactionally
                              -> keep old snapshot or commit all of new snapshot
                              -> allocate/copy each chunk with DE allocator
                              -> load + execute under guarded protected call
                              -> restore borrowed registry entry and VM top
```

The folder is not polled or continuously hashed. Runtime idle work is limited
to the already-existing script tick's F9 edge check and one timestamp update on
DE module loads.

## Live boundary

The current installed Inject folder is empty, so the offline build proves
resolution, construction, and disabled-state behavior but cannot prove an
actual addon call. Before marking `LI-001` through `LI-007` live-complete, use a
small reversible fixture that returns a visible/loggable value, then perform a
second F9 generation and a deliberate fault fixture to confirm both rollback
and continued VM health. No installed game file was changed in this slice.
