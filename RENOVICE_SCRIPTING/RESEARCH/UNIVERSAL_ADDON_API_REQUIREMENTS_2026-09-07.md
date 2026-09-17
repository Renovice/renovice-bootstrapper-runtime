# Universal DE Luau addon API requirements

User-directed reset, 2026-09-07. Governs the next implementation and tests.

1. One standalone authored addon file declares a target and callbacks; the host
   supplies general attachment and lifecycle handling for any supported target.
   No ability-specific native branches, base-script shims, or extra support
   scripts. Existing full replacements retain their separate contract.
2. DE VM internals are in scope. Read/reverse/debug/fix the actual VM integration
   as necessary. Avoiding VM work is not a solution to missing attachment.
3. Logging is a prerequisite to further trial builds: correlated start/end
   records, exact identity and rejection reasons, callback arguments, decoded
   errors, and explicit limits. Reuse previous negative evidence.
4. Raw DE Luau injection and OpenWF's separate Pluto runtime must not be
   conflated. This work concerns the DE injector.
5. Generic host architecture is different from universal live validation.
   Require an unrelated target test as well as Mallet and lifecycle checks.
6. "Universal" means the host implements each event contract once and any
   content-keyed addon may consume it. A supported ability addon needs one
   `<body-key>.<name>.target.addon.lua_B` file in `Inject`, with no base-script
   shim, support script, or ability-specific native branch. It does not mean
   every imaginable game event is already in the hook catalog.
7. For resolved damage, `afterDamage` receives the engine-reported calculated
   damage value. This may include overkill and is intentionally not target HP,
   shields, or effective-health loss.

## Current evidence

V43 gameplay is FALSE by user report and captured source log
`RENOVICE_DEPLOYMENTS/ACTIVE_CALL_STACK_V43_2026-09-07/captures/20260907-021336-456Z`.
The hook ran; the active stack had three frames; target matching returned
missing. No callback install or afterDamage followed.

The loaded root was `000001B9C3400D80`. The Lua caller had prototype
`000001B9C34010F0` and a different instance environment. This disproves the
root-or-template-environment matcher for that caller.

Read-only memory from a second V43 process (PID 28048) showed a root at
`0000028D6CFA06D0` with 21 direct children and 22 total prototypes. Its child
16 was `0000028D6CFA0A40` (981 instructions). The root had 159 instructions.
Observed layout: prototype tag 12; children pointer +0x18; code size +0x88;
child count +0x8c; bytecode ID +0xa8; allocated prototype stride 0xb0.

Correction to earlier commentary: the matching relative allocation distance
in two processes supports the child-16 hypothesis but does NOT prove the old
caller's ancestry. The old process had exited before memory could be read;
the copied fault dump predates that test and is not its crash evidence.
The next trace must show same-session exact membership in the collected
prototype graph. Never use pointer distance or bytecode ID as ownership.

Subsequent captured evidence from the second V43 session resolves that narrower
question: its source hook logged caller `0000028D6CFA0A40`, exactly the child-16
pointer read from that same session's root graph. This is preserved in the V44
predeployment capture `captures/20260907-023535-154Z/renovice_source.log` under
`RENOVICE_DEPLOYMENTS/PROTO_FAMILY_TRACE_V44_2026-09-07`. Thus same-session
descendant ownership is confirmed for the second V43 run. The matching defect
is established; callback installation and addon effect remain separate tests.

## Next acceptance sequence

Exact content-key load -> complete validated prototype graph -> native hook
entry -> same-session exact prototype/VM match -> callback installation ->
callback entry with actual argument values -> addon dispatch enter/return or
decoded failure -> visible effect. Card evidence is recorded separately.

An unchanged addon may still have downstream errors after attachment is fixed.
Do not label the whole gameplay feature fixed merely because matching starts
working. An afterDamage adapter is also only one general event, not complete
coverage of every event an eventual modding API can support.

## 2026-09-07 session closeout

The universal attachment architecture is accepted for the hook types currently
implemented: lifecycle activation/cleanup, ability-card augmentation, resolved
damage callbacks, and instruction-addressed float-argument transformation.
These are host contracts, not Mallet-specific native code. New kinds of addon
behavior may require another generic event contract once; they must not require
one support script or C++ branch per ability.

V48 proved standalone addon loading and all four native adapters at startup,
then granted Overguard in gameplay. Its `RadialDamage` batching policy failed
the timing requirement: the user observed real Overguard increments continuing
for roughly 1.5 seconds after the enemy died. The pre-universal working script
converted each reported damage result immediately and did not exhibit that
delay.

Next accepted behavior:

```text
exact target module associates the Mallet source
  -> each positive resolved damage callback arrives
  -> afterDamage(sourceAbility, reportedDamage) runs immediately
  -> addon grants reportedDamage * configured fraction immediately
```

Do not clamp the reported value to target health or effective health. Do not
use the `RadialDamage` call lifetime to defer the effect. Before changing code,
capture one delayed V48 cast if a reproducible trace is still available and
classify the delayed event as a later radial batch or an out-of-batch callback.

## V49 implementation

V49 implements the accepted immediate callback behavior and removes the
`RadialDamage` detour and batch state. It also generalizes the former one-off
`PushFloatArg` transform into `hooks.nativeCalls[method].before/after`, with
exact target-body, VM, prototype, and instruction ownership. The method name,
argument mutations, result mutations, and callsite selection live in the
standalone addon. The host has no Mallet-specific branch.

Mallet's 15,000 base Overguard cap now uses stock upgrade operation 10 for both
gameplay and the modded card, matching the PagemasterLife evidence. Package,
build, roundtrip, Semantic IR, strict API, call-map, and mock behavior checks
pass. Deployment and live gameplay remain separate evidence until observed.
