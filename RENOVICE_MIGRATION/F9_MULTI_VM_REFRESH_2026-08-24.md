# F9 per-VM loaded-module refresh

Date: 2026-08-24

Feature: `LR-005` / `TG-007`

## Outcome

The Arsenal ability-card test proved that F9 committed the replacement map but
only re-executed module environments owned by the HUD drain's DE Luau
`global_state`. The Arsenal/UI environment belonged to another VM, so it stayed
stale until a process restart. Reporting that transaction as a complete PASS
was false.

The source bootstrapper now treats a changed loaded module as per-context work:

1. F9 atomically commits the validated replacement generation once.
2. Every captured `(module key, environment, VM, manager)` receives one pending
   refresh carrying the newest replacement or captured stock bytes.
3. Work for the HUD drain's own VM executes immediately.
4. Work for another VM remains queued.
5. The next ordinary loader boundary in that exact VM and owner thread drains
   its queue using the captured module environment, manager, and loader-name
   handle.
6. A later F9 supersedes an older queued job for the same module environment;
   stale generations are not replayed first.
7. A natural load of that exact module/environment satisfies the queued job so
   its top-level chunk is not executed twice.

There is no directory watcher or frame-by-frame filesystem scan. With no queued
work, the loader path performs one atomic zero-count check and returns.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| Executing an Arsenal environment from the HUD VM is safe. | The environments have different `global_state` identities, and the DE registry/stack belongs to the current VM. | **FALSE; prohibited** |
| Cross-VM work can be retained until that VM reaches its own safe point. | Pending identities are keyed by module, environment, and VM; the verifier delivers HUD work first and Arsenal work only at the Arsenal boundary. | **TRUE offline** |
| Repeated F9 presses should queue every intermediate generation. | Replaying stale module top-level code can duplicate side effects. The queue replaces an existing identity with the newest generation. | **FALSE; newest wins** |
| A nested loader call inside an injected script is an independent safe point. | The guarded stack/registry transaction is still active and uses a single fault guard. | **FALSE; re-entry blocked** |
| This adds idle filesystem or compilation cost. | Folder reads and compilation remain F9-only; the empty pending path is an atomic count check at module-load boundaries. | **FALSE** |
| Offline tests alone prove Arsenal hot refresh in the live game. | VM scheduling and Arsenal redraw behavior require the real client. | **FALSE; live gate remains** |

## Safety rules preserved

- No cross-`global_state` execution.
- No cross-owner-thread execution.
- Lua execution is serialized around the shared exception/registry guard.
- Nested module loads cannot recursively start another refresh transaction.
- Active casts and yielded closures retain their old code; future exported
  function lookups use the refreshed definitions.
- A missing captured environment or stock body remains fail-closed and applies
  only on a later natural load.
- The log reports `INCOMPLETE` while any other VM still has pending work.

## Offline gates

- Manifest: PASS, 44 features / 41 required / 24 critical.
- Dependencies: PASS at certified source commit
  `756bdc17aa9edf61df8204f901cdfff37b47db57`.
- Replacement verifier: PASS, including staged HUD then Arsenal delivery,
  owner-thread rejection, latest-generation supersession, and four active
  replacement filenames.
- Injection verifier: PASS, including nested-loader re-entry rejection.
- Config, SWF, Riven, and U43 exact-client signature verifiers: PASS.
- Private x64 build: warnings 0, errors 0, no companion DLL import.
- Built DLL: 4,037,632 bytes; SHA-256
  `6F491139887F558D0DE99ABD37ECC6F2F8D46331A577B2ED149DEFD74335D023`.

## Required live acceptance

The verified DLL was deployed while Warframe was closed on 2026-08-24. The
installed file is 4,037,632 bytes and its SHA-256 matches the staged artifact:
`6F491139887F558D0DE99ABD37ECC6F2F8D46331A577B2ED149DEFD74335D023`.
The prior installed DLL is preserved as
`RENOVICE_DEPLOYMENTS/F9_MULTI_VM_2026-08-24/wtsapi32.before_multi_vm.dll`
(SHA-256 `B4B2AD2D9817DAFBB539E065029FDFA15B18D256D087E2078C14244695A2A4A9`).

1. Start Warframe with the deployed DLL.
2. Start the client and open Octavia's Mallet ability card once so the module
   environment is captured.
3. Change only an obvious card label or numeric display value in the Mallet
   replacement and rebuild that `.lua_B`.
4. Press F9.
5. Reselect Mallet or leave and reopen the ability screen, causing an ordinary
   Arsenal/UI VM loader boundary and redraw without restarting the process.
6. Confirm the log contains a VM-local PASS and ends with `pending=0`.
7. Restore the production Mallet replacement, press F9 again, and confirm the
   card restores without restarting.
8. Cast Mallet once to ensure gameplay remained intact.

Do not call this live-complete until that sequence passes. If Arsenal produces
no loader boundary during step 5, the next engineering step is a separately
verified Arsenal-frame safe-point hook; cross-VM execution from the HUD thread
must not be used as a shortcut.

## First live result: cached-loader false completion

The first multi-VM live test changed Mallet's replacement body from the native
row `Overguard Damage Gain = 10%` to `Damage To Overguard = 1%`. F9 detected
the changed file and reported `module_refresh=INCOMPLETE`, but leaving and
reopening the Arsenal still displayed the complete old row. A later unchanged
F9 incorrectly reported `PASS`.

The defect was in `complete_module_load`: merely returning from the module
loader erased the matching pending job. Warframe may return an already cached
module without calling the undump routine, so loader entry/exit did not prove
that the new bytecode executed. The pending Arsenal job was erased immediately
before `drain_pending_for_vm` could execute it.

The correction records a nested, thread-local loader frame and lets the undump
detour mark that exact frame only after the replacement body is actually
consumed. A natural load satisfies pending work only with this positive undump
evidence and exact module/environment/VM/owner-thread identity. A cached lookup
does not satisfy the job; it remains queued and the VM-local drain executes it
at the same safe loader boundary.

Offline result: replacement verifier PASS including positive-undump, cached
lookup negative control, and wrong-thread negative control; all configuration,
SWF, Riven, injection, manifest, dependency, and exact-client gates PASS;
private x64 build warnings 0, errors 0, no companion import. Staged DLL:
4,039,680 bytes, SHA-256
`E3CFD7E2CC97543B1A7383C1429BE688C26B780D96C14E35DACC3D167FCC9B8F`.
Live deployment and repetition of the same Mallet F9 test remain required.

## Second live result: target context was never captured

The cached-loader correction was deployed and the identical `10%` to `1%`
Mallet test was repeated. The Arsenal card still showed the entire old native
row (`Overguard Damage Gain = 10%`). The log recorded the changed generation as
`module_refresh=INCOMPLETE`, but recorded no VM-local or natural replacement
delivery. A single physical F9 press also produced many later F9 generations.

These observations disprove the hypothesis that only cached-load completion
was dropping the work. The loader descriptor may not expose its environment at
loader entry; the environment is populated by the loader. The old capture path
therefore discarded the target before the post-loader safe point. It then
cleared the changed-key list, so a later valid UI boundary had no unresolved
work to deliver. Separately, treating `GetAsyncKeyState`'s low bit as an
ordinary held-key signal allowed key-repeat events to create duplicate F9
transactions.

The source correction now:

1. records the module identity, manager, name handle, stock body, VM, and owner
   thread before the loader without requiring an environment;
2. reads and validates the environment again after the loader returns;
3. preserves changed keys whose contexts are not available yet;
4. converts unresolved work into a pending VM-local job as soon as that
   module's post-load context becomes available;
5. never reports a generation complete while unresolved or cross-VM work
   remains;
6. writes changed, queued, unavailable, unresolved, and pending counts to the
   persistent RENOVICE log; and
7. accepts the low F9 bit only for a complete tap observed while the key is up,
   preventing a held-key repeat storm.

Offline result: all replacement, injection, configuration, SWF, Riven,
manifest, dependency, and exact-client gates PASS. The private x64 build has
warnings 0, errors 0, and no companion import. Staged DLL: 4,047,360 bytes;
SHA-256
`BED0F6716C893543313CA49221337D74304F8EF5225155E9A4F50B977BE13127`.
The remaining gate is the same live Arsenal test after deploying this DLL while
Warframe is closed.

## Third live result: module environment model disproven

The post-load-context DLL was deployed and the same controlled `10%` to `1%`
test failed again. The card retained the entire old row. This is not a redraw
or timing failure. Persistent counters reported:

```text
changed=1 queued=0 unavailable=1 unresolved=1 pending_other_vm=0
```

Every configured replacement also reported `target context unavailable after
load`. Exact disassembly then proved the architectural assumption itself was
wrong: the current U43 loader never reads descriptor `+0x58`, so that field is
not a retrievable module environment. The old code fabricated a new descriptor
and therefore could not match the existing UI/gameplay script objects retained
by Warframe.

The exact loader instead:

1. consumes bytecode from the descriptor's `+0x38/+0x40` fields;
2. iterates loaded objects owned by the manager;
3. compares each object's retained descriptor with the exact input descriptor;
4. refreshes matching objects through the native object-update path; and
5. returns a Boolean success result.

The source now captures the original descriptor identity and, at the owning
VM/thread boundary, feeds the changed bytecode through that same descriptor.
Warframe—not RENOVICE—performs the object/cache refresh. The loader detour ABI
was also corrected from `void` to `bool`. Descriptor `+0x58` and fabricated
descriptor re-execution are removed from the full-replacement refresh path.

This native-descriptor design is supported by exact-client disassembly and all
offline gates, but remains explicitly **not live-proven** until the controlled
Mallet Arsenal test passes.

## Native-descriptor live acceptance

The native-descriptor DLL was deployed while Warframe was closed. Mallet began
from the verified `Overguard Damage Gain = 10%` bytecode. While the same client
process remained running, the live file was replaced with the verified
`Damage To Overguard = 1%` candidate and F9 was pressed once. After leaving and
reopening the ability screen, the user confirmed the card showed the new row.

This proves the full chain in the real client:

- F9 detected and committed the changed replacement;
- the owning VM/thread accepted the job;
- the original descriptor reached Warframe's native object-refresh path;
- the already-existing Arsenal/UI object stopped using its old module; and
- a native `GetAbilityUpgradeLevelInfo` label/value change became visible
  without restarting Warframe.

Result: **TRUE LIVE** for the controlled Mallet full-module/UI refresh. This is
not yet a claim that every arbitrary module is safely hot-reloadable; the same
manager/descriptor/VM/thread checks remain mandatory.
