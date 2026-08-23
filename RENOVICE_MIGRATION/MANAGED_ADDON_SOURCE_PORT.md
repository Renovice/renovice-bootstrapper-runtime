# RENOVICE managed addon and transactional F9 source port

## Outcome

The source now has a managed, generation-owned addon lifecycle that replaces
the legacy fabricated `.persist`/`.spawn` scheduler experiment. It also stages
configuration, SWF replacements, DE-Luau full replacements, the Riven gate, and
the complete Inject folder before committing an F9 generation.

No DLL was deployed and no live DE-VM test was run. The installed Inject folder
is currently empty, so the lifecycle ABI is offline-built and state-machine
tested but awaits the user-authorized fixture phase.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| A one-shot injected chunk is automatically a persistent managed addon. | It can register callbacks, but the loader has no ownership record or cleanup action for them. | **FALSE** |
| The old fabricated resource, vtable, coroutine, and scheduler enrollment should be promoted. | Cleanup/inverse enrollment was never proven and delayed GC/lock faults remained possible. | **FALSE** |
| A managed addon can be represented without fabricating an engine scheduler object. | The bootstrap chunk returns a DE-Luau table containing rooted `activate` and `cleanup` closures. | **TRUE (offline)** |
| C++ memory alone can retain the returned closures safely. | DE's GC does not scan arbitrary C++ containers. | **FALSE** |
| A unique DE registry key can own each generation's lifecycle table. | The source roots each validated table in the real DE registry and removes the key only after cleanup/commit or rejected staging. | **TRUE (offline)** |
| New behavior should be activated before old cleanup. | For setters such as damage callbacks, old cleanup could erase a newly installed callback. | **FALSE** |
| Cleanup-old then activate-new is recoverable. | Old lifecycle tables remain rooted until all new activations succeed; on failure, partially activated new records are cleaned and every old record is reactivated. | **TRUE under the addon contract** |
| F9 configuration can be committed before script staging. | A later invalid addon would leave flags/SWF/replacements changed while the addon generation rolled back. | **FALSE** |
| All source-owned F9 data can be staged first. | Config flags, SWF map, Lua replacement map, Riven gate, and Inject chunks now have prepare/discard/commit paths; commit operations are no-fail swaps after addon success. | **TRUE (offline)** |

## Addon contract

A managed addon filename contains `.addon` and ends in `.lua_B`, for example:

`MalletOverguard.addon.lua_B`

When loaded, it must perform validation and construct state only. It must not
install gameplay behavior during staging. It returns exactly one table:

```lua
local active = false

local function activate()
    if active then return end
    active = true
    -- Install or restore this addon's native Warframe callback/hook here.
end

local function cleanup()
    if not active then return end
    -- Remove only behavior/resources owned by this addon generation here.
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
```

Both functions must be no-argument, non-yielding, repeatable, and idempotent.
`cleanup()` must tolerate partial activation; `activate()` must tolerate
reactivation during rollback. An addon that needs `SetDamageCallback`, entity
listeners, timers, or spawned objects owns both installation and the exact
inverse operation.

This layer manages lifetime and F9 generation swaps. It does not invent a
universal event that the game does not expose. Event-specific convenience APIs
such as `AfterMalletDamage` can now be built on top of this contract, while
direct native callback installation remains valid.

## F9 transaction

```text
F9 edge (no idle folder watcher)
  -> prepare renovice.cfg flags
  -> prepare all .swf files and optional TOC metadata
  -> prepare all content-keyed full-module .lua_B replacements
  -> prepare riven_lock.cfg gate
  -> prepare complete Inject folder
  -> execute addon bootstraps as side-effect-free staging
  -> validate returned activate/cleanup closures
  -> cleanup old generation
  -> activate new generation
       failure -> cleanup partial new + reactivate old + discard all prepared data
  -> release old registry roots
  -> atomically swap prepared config/SWF/replacement/Riven snapshots
  -> run ordinary one-shot chunks
  -> report RELOAD PASS/ROLLBACK/FATAL and application timing
```

Full DE-Luau replacements are re-read on F9, but an already cached stock module
continues using its current closure. The new body applies on the next matching
module load. Existing entities/closures likewise remain old until their
owning addon cleanup or the next event/spawn, as reported in the reload line.

Ordinary one-shot chunks are intentionally outside reversible addon semantics.
They run only after the managed generation commits; an ordinary chunk failure
is reported explicitly because arbitrary one-shot side effects cannot be
rolled back. Persistent behavior should therefore use `.addon.lua_B`.

## AutoSpawn

`AutoSpawn=true` now means re-stage and reapply the managed Inject generation
after a detected region transition. `AutoSpawn=false` applies the first startup
generation and F9 generations only. The unsafe legacy `.spawn` scheduler path
remains rejected.

## Offline evidence

- script classification includes case-insensitive ordinary, managed addon,
  rejected persistent, and rejected spawn forms;
- managed transaction tests prove successful ordering, full deletion, cleanup
  rejection rollback, activation rejection cleanup/reactivation, old-root
  release escalation, and rollback-failure escalation;
- replacement generations use atomic snapshot swaps, so F9 cannot race the
  undump detour or invalidate replacement byte lifetime;
- config/SWF/replacement/Riven state is prepared before addon staging and
  discarded if staging/activation fails;
- private build: warnings 0, errors 0, x64, no companion import;
- final offline-gate DLL: 3,998,208 bytes, x64, warnings 0, errors 0,
  companion import absent, SHA-256
  `2bcb2b12d2daf8c307878196bb3f8f4037f265b2b3ce89c69dba5cf9ce8b1c03`.

## Live boundary

The final live phase needs one reversible managed addon fixture and one failing
fixture. Required observations are: initial activation, F9 behavior change,
no duplicate old callback, activation rollback, registry cleanup over repeated
reloads, region behavior with AutoSpawn both ways, and a full replacement that
changes on its next module load. Until then, source/offline parity is proven;
live parity is not claimed.
