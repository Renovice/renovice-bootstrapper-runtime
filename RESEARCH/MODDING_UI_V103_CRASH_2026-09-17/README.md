# V103 modding UI assertion — 2026-09-17

## Conclusion

The reported Arsenal/modding-UI crash reproduced the same engine assertion
address as the earlier V103 Railjack-to-hangar crash:
`Warframe.x64+0x1834116`. The current log ended after repeated
`UpgradeManager::Clear()` and `BuildLoadOut` churn, then printed:

```text
Assertion Failure at 0x7ff6be554116

Application error messages:
AlacrityField.lua
AddUpgrades
TenaciousPartner.lua
AddUpgrades
HijackMatrix.lua
ModApplied
SynthSetMod.lua
UpdateHudBuffs
```

Those names identify the last UI wrapper workload. They do not prove that a
specific mod is corrupt. Heap use immediately before the assertion was about
653–690 MB of a 1.453 GB game heap, diagnostics were disabled, and the process
did not report out-of-memory. The hypotheses that diagnostics or ordinary heap
exhaustion caused this crash are false.

The earlier dump mapped this exact assertion family to:

```text
Pluto collectgarbage("step")
  -> owfUserdata.__gc
  -> ivkr_push_string
  -> game luau_pushstring
  -> Warframe assertion +0x1834116
```

V103 ran Pluto collection from the native Application-frame scheduler against
a cached UI `luau_State*`. Its userdata finalizer then tried to allocate and
mutate the DE Lua registry outside a live game-owned Lua API call boundary.
Repeated Arsenal rebuilds create and retire many wrappers, so they make this
fault easier to reach. They are the trigger workload rather than the ownership
bug itself.

## V105 repair

V105 preserves the strong-registry-root cleanup and all Pluto functionality.
It changes the unsafe operation's ownership:

1. Every registry-rooted wrapper records the exact DE
   `luau_GlobalState*` that owned it at construction.
2. `owfUserdata.__gc` only queues the root key and recorded owner. It performs
   no DE stack allocation or registry mutation.
3. The bounded native queue drains only when that same DE global state enters
   a real game-owned `lua_set_global` or `lua_set_global_by_hash` invocation.
4. The drain checks stack capacity, clears the registry entry, restores the
   original top and processes at most 256 releases per drain invocation.
5. The native Application-frame scheduler never drains the queue.

The queue is capped at 32,768 entries and each key at 256 bytes. An entry that
cannot reserve stack space is requeued rather than partially mutating the DE
VM. Cleanup for one global state cannot run against another.

## Hypothesis ledger

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| Diagnostics caused the latest crash | False | `Diagnostics=false`; assertion stack family is Pluto finalization |
| The game heap exhausted | False | Recent heap samples were well below the 1.453 GB limit; no OOM terminal |
| One named mod is proven corrupt | False | Names are the last UI callback chain; no individual mod appears in the mapped native fault |
| Arsenal/modding activity is a trigger | True | Repeated loadout rebuilds immediately precede the assertion and churn UI wrappers |
| V103 finalizer ownership is invalid | True | Same RVA as the mapped Railjack dump; finalizer mutates DE VM from cached-state scheduler |
| V105 removes cleanup or disables Pluto | False | Finalizer queues the same registry release; owner-matched game API entry performs it |
| V105 is live accepted | Pending | Offline, build, package and installed-byte checks pass; fresh gameplay testing remains |

## Evidence

- `EE.latest.log`: immutable copy of the reported session log.
- `capture-manifest.json`: source, byte count, log hash and installed V103 hash.
- Log SHA-256:
  `D0718903727C89BF3190864A32E4CC9013974922A02EFA02D4D6CEA5EA52419D`.
- V103 DLL SHA-256:
  `738112A1FDE93685B0EBD982243EBBBBBC09E8C29E952FF542CED56BB6EA26BC`.
- V105 DLL SHA-256:
  `F7BB73C6A53718A98E9D7AF87116818D51F57503F0CF65FE0D1954E88D5E60BC`.
- Complete V105 package:
  `RENOVICE_DEPLOYMENTS/DEFERRED_GAME_REGISTRY_RELEASE_V105_2026-09-17`.

## Evidence boundary

V105 fixes the exact registry-finalizer assertion path shared by the Arsenal
and Railjack captures. It does not by itself prove that every other synchronous
`ivkr_*` bridge operation is safe from the cached Application-frame scheduler.
The rejected V104 `UpdateFlashMarkers` restoration remains rejected and was not
reintroduced. A fresh process must still pass Arsenal churn, mission transition,
exact `Limbo` search, F10, F9, Mallet, Ice Wave and a longer Railjack/UI soak.
