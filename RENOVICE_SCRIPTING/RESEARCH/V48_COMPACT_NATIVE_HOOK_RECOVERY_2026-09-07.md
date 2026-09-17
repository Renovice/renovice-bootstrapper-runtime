# V48 compact native hook recovery

## Scope

This note separates the V47 startup failure, the V48 native-hook repair, and
the still-pending gameplay behavior check. The target is exact body key
`08faf07b504d058f`. The replacement loader and every unrelated custom script
remain outside this change.

## Hypotheses and results

### H1: the V47 addon bytecode failed while loading

**FALSE live.** PID 25340 published the 22-node BardMusic prototype graph,
loaded the embedded callback runtime, and logged `TARGET ADDON PASS`. No addon
protected-call failure preceded exit. The process then emitted a Microsoft C++
exception before the combined native-adapter PASS line.

### H2: an exception from native detour construction could escape V47

**TRUE statically, consistent with live timing.** V47 called
`DetourHook::create()` without a `try`/`catch`. Soup throws `soup::Exception`
when the disassembler sees an unsupported instruction or an instruction that
uses the instruction pointer in the required relocation window. The V47
process exited at the first new-hook installation boundary.

V46 had already live-proven the preceding `SetDamageCallback` and
`SetSourceObject` long detours. `RadialDamage` was the next create operation in
V47's short-circuit order, so it is the localized first-new-hook suspect. V47
did not log the hook name or Soup message before the exception; the exact
unsupported instruction is therefore not claimed as directly observed.

### H3: changing the new adapters to compact hooks preserves startup

**TRUE live for startup and installation.** V48 PID 26948 remained running
past the V47 failure interval and logged:

```text
RENOVICE native hook adapter PASS damage=1 callsite=1 SetDamageCallback=1 SetSourceObject=1 RadialDamage=1 PushFloatArg=1 mode=long-callbacks+compact-radial-callsite
```

The same run logged one accepted 22-node graph, zero rejected graphs, and
`TARGET ADDON PASS`. This proves target discovery, addon loading, code-cave
creation, trampoline creation, and enabling all four adapters. It does not by
itself prove a gameplay callback.

### H4: adapter capability changes were transactionally restored before V48

**FALSE in the prior source; TRUE in V48 source and tests.** The old shutdown
function called `destroy()` directly. Soup's destroy frees a trampoline but
does not restore the native target bytes. V48 calls `disable()` before
`destroy()` for all four hooks and resets compact code-cave state. The package
verifier checks the source ordering, and injection-core tests reject every
partial requested bundle.

### H5: V48 contains Mallet-specific native behavior

**FALSE statically.** The runtime source contains no `Mallet`, `BardMusic`,
`Overguard`, or `SetThreatLevel` behavior. It exposes generic exact-target
damage batching and instruction-addressed float-argument transformation. The
single standalone addon contains the Mallet formula, card projection, stock
Overguard integration calls, and exact threat callsite selection. No shim is
installed.

### H6: V48 removes the delayed or trailing Overguard grants

**FALSE live.** The user confirmed that the frame had no Overguard initially
and then received real Overguard increases for as long as roughly 1.5 seconds
after the enemy died. This was explicitly observed in the frame's Overguard
state, not inferred from a delayed HUD notification.

V48 sums callbacks while the synchronous stock `Region:RadialDamage` call is
active and dispatches one addon effect when that call returns. It also directly
dispatches a callback that arrives outside an active radial batch. The current
evidence does not distinguish later Mallet radial calls from callbacks deferred
beyond the original native call; both are testable in the correlated trace.
What is established is that making `RadialDamage` control the addon-effect
boundary did not reproduce the immediate timing of the old pre-universal
script. That timing design is rejected for the Mallet Overguard effect.

### H7: threat 5 is applied through the stock BardMusic call

**PENDING live gameplay; TRUE for exact routing evidence.** The Ability Studio
call map has one `SecondaryScriptArgs:PushFloatArg` row at prototype 16,
instruction 596. V48 resolves the active target `CallInfo.savedpc`; the addon
returns 5 only at that address and returns the stock value for every other
float push. Live execution still requires the corresponding
`PushFloatArg.instruction-transform` trace.

### H8: Overguard should use target health or effective-health loss

**FALSE by accepted feature semantics.** Warframe abilities conventionally
scale from the engine's calculated/reported damage result. The Mallet addon is
intended to convert that reported value, including overkill, rather than clamp
it to health, shields, or theoretical effective health removed. The prior
`actualDamage` identifier means callback-reported damage; it must not be
documented as proof of target-pool loss.

### H9: the accepted successor should dispatch each resolved damage result immediately

**TRUE as the next required behavior; not implemented in V48.** For each
positive damage result produced by the exact Mallet-associated callback, the
host should call the addon's generic `afterDamage` hook immediately. The addon
then applies `reportedDamage * damageToOverguardFraction(caster)`. Stock Mallet
already controls which targets are affected inside its circle, so the addon
does not need an area scan or an effective-health calculation. `RadialDamage`
must not delay or own effect dispatch; it may remain only as optional diagnostic
context if later evidence justifies it.

## Artifacts and proof levels

- V48 DLL: 4,466,176 bytes,
  `041D975199D6C71B47309326C972D23D22D29A62C603213BA994D492BD836BE2`.
- Addon: 1,535 bytes,
  `CABFD1489FE5BF5965BD3DDF174D51C667506960C4C6787595E8A1D60146717B`.
- Exact rollback: V46 DLL and addon.
- Offline package: PASS, including exact source reproduction, 8/8 DE
  roundtrip, 8/8 Semantic IR, strict API, mock behavior, injection/runtime/UI
  gates, complete hook-bundle checks, executable hash, and imports.
- Deployment: PASS; only the DLL and target addon changed, and 15 other custom
  files were preserved by hash.
- Startup: PASS for PID 26948.
- Gameplay effect: TRUE; V48 granted calculated-damage-based Overguard.
- Gameplay timing: FALSE; real Overguard increases continued after the enemy
  died, unlike the old pre-universal implementation.
- Threat value and UI/menu regression: pending separate live checks.
- Session close: PID 26948 exited; the exact V48 DLL and addon remain deployed.
