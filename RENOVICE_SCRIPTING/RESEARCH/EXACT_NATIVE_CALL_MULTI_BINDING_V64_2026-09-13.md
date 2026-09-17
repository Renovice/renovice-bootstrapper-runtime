# Exact native-call multi-binding V64

Date: 2026-09-13

## Question

Why did the Frost Ice Wave Cold-stack addon load successfully but deal only
stock damage, and how can the generic native-call API support this method
without weakening target ownership or adding Frost-specific runtime code?

## Live V63 evidence

The reproduced log established this sequence:

1. target module identity PASS for body `f62b70b45fc7fdf9`;
2. addon bytecode injection PASS;
3. target addon lifecycle PASS;
4. `DamageDD` lookup found four registry entries and four distinct native
   implementations;
5. the V63 single-implementation guard rejected the binding set;
6. the target addon transaction failed with `native-adapter-commit`.

Therefore the callback never ran. The live result says nothing yet about the
correctness of the Cold-stack native, damage packet mutation, or final damage
because execution stopped earlier.

## Architecture result

**Hypothesis:** a method hash with several implementations can be supported by
detouring each implementation while retaining exact instruction ownership.

**Result: TRUE at source/offline level.** Each planned implementation receives
its own adapter slot and its own captured stock trampoline. On entry, the
adapter walks the active DE Lua frames. If it cannot prove the target body and
VM, it immediately invokes that implementation's stock trampoline. Provider
dispatch additionally matches the requested method, prototype, and instruction.
The Ice Wave provider can therefore run only at `f62b70b45fc7fdf9`, prototype
7, instruction 64, `DamageDD`.

This rule belongs only to `hooks.nativeCalls`, whose contract is explicitly
instruction-addressed. Global semantic adapters keep the V63 ambiguity guard
and still reject more than one distinct implementation. Different method names
that resolve to the same implementation also reject because the adapter could
not prove which name supplied the call.

## Limits and evidence state

- Total distinct exact native-call hooks are capped at 32.
- Empty, impossible, ambiguous-name, reserved-name, and over-budget sets reject.
- V63 captured-target teardown is retained for every compact hook.
- Unit, config, replacement, runtime, dependency, manifest, and zero-warning
  private build gates pass.
- V64 deployment passed with repository, staged, and installed DLL SHA-256
  `6AD53FC39C58956AD1D20404640C32C327046884F0C35CBA195C7C83286B1A08`.
  The Ice Wave addon and `ScriptStates.json` remained byte-identical. A bounded
  target/method trace is enabled for the next run.
- Ice Wave damage scaling remains a live gameplay gate and must not be inferred
  from the offline or deployment result.

## Live result: rejected

The 2026-09-13 Frost test still dealt stock Ice Wave damage. The runtime loaded
the exact target addon and installed four distinct `DamageDD` bindings. A
post-test process-memory read showed all four function entries still held their
owned E9 detours and each cave still targeted a separate adapter slot. The
configured trace recorded zero `native.call` events. V64 therefore fixed the
multi-binding installation failure, but did not deliver the exact callback.
The evidence is preserved under
`evidence/live-rejected-20260913-134655`. V65 adds bounded native-ingress
observation before callsite ownership; it does not alter gameplay behavior.
