# V49 low-level native calls and immediate Mallet damage

Date: 2026-09-07

Feature: `LI-013` universal target-addon hook bus

Target body key: `08faf07b504d058f`

## Requested behavior

1. Add a reusable low-level layer below the existing lifecycle, card, and
   damage contracts. A standalone content-keyed addon must be able to intercept
   a declared native call at an exact target prototype and instruction without
   adding ability-specific C++ or a support script.
2. Grant Mallet Overguard from every positive engine-reported Mallet damage
   result, including overkill, at the callback boundary rather than at an
   enclosing area-damage return.
3. Scale the 15,000 base Overguard cap with Ability Strength through the same
   stock operation used by Pagemaster/Dante and show that same value on the
   modded ability card.

## Hypotheses and results

### H1: `RadialDamage` is needed to identify or time Mallet damage

**FALSE.** V48 already associated the source ability at `SetSourceObject` and
received the engine-reported result through the installed damage callback.
Live testing showed that waiting for `RadialDamage` to return delayed real
Overguard state changes after the enemy died. V49 removes the radial detour,
batch object, sum, and return-time dispatch. Each positive callback invokes
`afterDamage(sourceAbility, reportedDamage)` immediately.

### H2: one generic exact-callsite native contract can replace the one-off threat transform

**TRUE offline.** V49 accepts:

```lua
hooks = {
    nativeCalls = {
        PushFloatArg = {
            before = function(prototype, instruction, arguments)
                if prototype == 16 and instruction == 596 then
                    arguments[2] = 5
                end
            end,
        },
    },
}
```

The host enumerates the declaration when staging the addon, hashes the method
name, requires one distinct native implementation, and creates a compact
detour. At runtime it accepts only an exact target-body, VM, prototype, and
zero-based saved-PC instruction. The receiver is argument 1. `before` may
mutate the existing arguments; `after` may mutate the original native results.
Argument and result counts remain fixed in V49.

The host supports up to 32 distinct declared methods. Malformed declarations,
missing methods, multiple native implementations, aliases that collapse to one
implementation, and partial hook creation are rejected. A callback error
restores stock arguments or retains stock results. Reentry bypasses addon
callbacks and calls the original trampoline. Native-hook lifecycle is serialized
against generation changes, and logging occurs after releasing that lifecycle
lock to avoid an inverse lock order with generation publication.

`SetDamageCallback`, `SetSourceObject`, and `RunScript` are currently reserved
because the host already owns those entry points for damage transport or card
observation. `PushFloatArg` cannot be declared through both the legacy
`transformFloatArgument` callback and `nativeCalls` in one active generation.
These conflicts fail explicitly; they do not create overlapping detours.

### H3: the cap should use a guessed Strength multiplier

**FALSE.** Current stock PagemasterLife evidence computes its 15,000 Overguard
cap with:

```text
InventoryControl:GetUpgradeModifiedValue(baseCap, 10, suitType, suit)
```

The same helper supplies stock card values and gameplay state. V49 uses that
exact operation for both Mallet's gameplay cap and its modded card row. The
conversion percentage uses the same operation with a 1% base and retains the
requested 5% conversion ceiling.

### H4: the runtime needs Mallet-specific behavior

**FALSE.** `renovice/injection.cpp` and `injection_core.hpp` contain no Mallet,
BardMusic, Overguard, or threat implementation. The target addon owns the
prototype/instruction selection, threat value, conversion, cap, card labels,
and stock Overguard notification calls.

## Proof levels

- C++ build: PASS, x64, zero warnings, no companion DLL import.
- Injection/runtime/UI gates: PASS.
- Addon source reproduction: PASS.
- DE roundtrip: PASS, 10/10 prototypes.
- Semantic plan and Semantic IR: PASS, 10/10 prototypes.
- Strict API check: PASS with no unknown calls.
- Mock behavior: PASS for immediate reported-damage conversion, overkill
  semantics, 1%-to-5% Strength conversion, Strength-scaled cap, shared card
  value, stock notification sequence, and exact threat argument mutation.
- Exact threat callsite evidence: one `PushFloatArg` row at prototype 16,
  instruction 596 in the pinned Ability Studio call map.
- Deployment: PASS. The exact V49 DLL and Mallet addon replaced the exact V48
  pair. Fifteen other custom files, the internal SCRIPTS bridge, and
  `ScriptStates.json` were preserved by hash.
- Startup: PASS in PID 23868. The fresh trace identifies `build=V49`, roots all
  22 BardMusic prototypes, loads the addon in the exact target environment,
  reports `TARGET ADDON PASS`, and accepts both damage transport hooks plus one
  generic `nativeCalls` method. The process remained responsive and the native
  fault log recorded no exception.
- Gameplay: user-observed functional PASS for damage-based Overguard. The user
  reports that V49 otherwise works, but occasionally observes one or two real
  Overguard increments a fraction of a second after the watched enemy dies.
  Injector-side callback execution is synchronous and measured at no more than
  1.5542 ms in the retained V49 trace; the remaining pre-callback engine delivery
  or post-setter publication boundary is unresolved. Strength progression,
  threat, and UI values are not inferred from startup or timing logs. See
  `V49_POST_CALLBACK_TIMING_ANALYSIS_2026-09-08.md`.

## Artifacts

- Package:
  `RENOVICE_DEPLOYMENTS/LOW_LEVEL_NATIVE_HOOKS_IMMEDIATE_DAMAGE_V49_2026-09-07`
- Addon source SHA-256:
  `7EDA3050F142333762606CD4EE22E777D806E6EDB9A28B68CC648F7AB528EA4A`
- Addon bytecode SHA-256:
  `2484605913BF1E1E32849AB7AFEC41BB2E93EB4A24EF711F13476827351AEA0C`
- V49 DLL SHA-256:
  `AA4C712103DCFB2CEB4FD8223B0449D62C81182F755005202EC2BB74204E3267`
- Rollback pair: exact deployed V48 DLL and addon, plus the unchanged script
  policy snapshot.

## Ability Studio integration

The editor's linked damage-to-Overguard template now emits the same V49
architecture. `native_argument_rewrites` records the method, exact prototype,
instruction, one-based argument index, expected value, replacement value, and
evidence ID. Generation produces `hooks.afterDamage` and grouped
`hooks.nativeCalls[method].before` callbacks. The template no longer emits an
`_T` handler slot or requires a target-module shim. Both canonical stats use
`GetUpgradeModifiedValue(..., 10, ...)`, so gameplay and modded card output
share one Strength calculation.

The full Ability Studio build passed: C++ compiled with warnings as errors,
the C++ self-test passed, 82 managed checks passed, and the WPF application
published. A real staged Mallet build passed recompile, 9/9 DE roundtrip,
semantic plan, and focused API gates. The retained
`MODIFIER_LIVE_REMAINING` diagnostic explicitly requires in-game comparison at
base and non-base Power Strength; it is an evidence boundary rather than an
ignored build failure.
