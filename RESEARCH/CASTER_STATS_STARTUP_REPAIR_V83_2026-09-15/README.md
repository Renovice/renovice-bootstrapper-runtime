# Caster diagnostics startup repair V83, 2026-09-15

## Evidence and hypothesis verdicts

- Installed V82 fingerprint was 8E3797124EBBF951499892A61CDC86E03604235C6E9C47344858A4454E24CF91.
  The previous deployment's config and all existing script hashes still matched.
  Hypothesis: changed ability scripts caused this startup failure. REJECTED as an
  explanation of this deployment delta; V81 itself is unchanged and live math remains pending.
- New capture bytes 76242984..76311475 contain embedded module load rejection,
  fault_stage=0, closure_tag=8, pcall=-1, result_tag=8, registry_restored=1,
  followed by 593 repeated automatic-runtime FAIL rows. Internal V79 text was
  a stale module label; DLL size/hash identify V82. REPEATED RETRY hypothesis TRUE.
- EE.log ends at game time 8.111 with GPF 0x7ff7a244a141. The archived mini-dump
  reports c0000005 at Warframe+0xf9a141: table insertion tests byte [r8+1], with
  r8=800269e56c97e2b3, a noncanonical pointer. TValue at r12 has type 8 and that
  same invalid pointer. Its caller reaches WTSAPI32+0x48a3e via setfield(-10000)
  from remember_diagnostic_module_identity; diagnostic registry publication is
  the observed crashing boundary. This is not a source-level DE crash symbol.
- Hypothesis: reserving stack capacity once makes guard.base valid through later
  loader/pcall/lifecycle execution. FALSE. The actual preserved V82 production
  function fails forced loader/pcall relocation with simulated GC disabled.
- Hypothesis: a copied C++ borrowed_original keeps the displaced closure alive
  while the loader overwrites its ordinary registry key. FALSE. The actual V82
  production function restores a simulated dead closure under forced collection.
- V83 extracts and runs the real production guard, normal/fault recovery and
  cleanup functions: 20/20 success, loader rejection, pcall rejection, loader
  fault and pcall fault cases pass across all four movement combinations.
  These establish the repaired invariants. They cannot prove which invariant
  failed first in the live V82 session; successful startup remains a separate gate.

## Repair and preservation

The shared guard stores a stack-relative byte offset and recomputes every access
against the current state->stack. The displaced original has a transient root in
the existing Lua registry for the shadow/restore transaction; it is released after
the original is restored. All consumers, including lifecycle and native module
refresh recovery, use the same offset accessor. Execution remains serialized by
the existing Lua execution mutex. No second runtime or support addon is introduced.

Failed automatic observer loads are attempted once per VM per accepted generation.
The existing explicit F9 configuration commit clears the failed-VM latch; a failure
is logged without an unbounded retry loop. Caster queries, exact source/snapshot
joins, gameplay addons, replacement files, server and metadata are preserved.

Private build initially rejected an obsolete source-shape test requiring a raw
pointer, then rejected Git's CRLF conversion warning. The source-shape requirement
now demands the stronger offset+GC-root invariants and the changed C++/test files
use expected LF line endings. Neither warning/error was bypassed. The final x64
build passes with zero warnings/errors; canonical 66/66 bytecode/IR observer,
injection/lifecycle/safe-point/UI and 15 analyzer checks pass.

V83 DLL: F99A5D11F818A9A40A71B9C72D101ECFE382C569DABCED323847CBE8E82E5028,
4695552 bytes. Deployment receipt baseline 76311475. Config remains
9CAD4B843E5D915B777729A84FB83A2B44E1EAB70FE70741F57EE925763939AD, including
DiagnosticsCasterStats=true. V81 Ice Wave addon remains
47BE0645CE804BA565DE4B0021CFD46BE452B22908B5C0092C900C62CA6E3E02.

V83 package: RENOVICE_DEPLOYMENTS/CASTER_STATS_GUARDED_LOADER_REPAIR_V83_2026-09-15.
V82 is preserved as crash-rejected rollback; V80 is preserved as last live-accepted
recovery. The startup/caster/Strength/Arcane buff gates are PENDING. No named buff
activation or contributor attribution is claimed. Dedicated tools and generated
mock artifacts are confined to this research directory.

Debugger's checksum warning comes from absent private DLL symbols. It does not
invalidate the direct installed/package SHA256 checks; private DE symbols are
unavailable, so function names beyond independently matched runtime code remain
unresolved. Two helper setup/parser failures and wrong path lookups were corrected
before execution; no game/source mutation occurred in those rejected commands.
