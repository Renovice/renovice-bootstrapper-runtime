# Frost Ice Wave Cold-stack damage evidence

Date: 2026-09-13

## Requested behavior

For each target hit by Frost's Ice Wave, multiply that target's stock Ice Wave
damage by the number of Cold stacks already present on that target. Zero and
one pre-existing stack retain stock damage. Ten pre-existing stacks produce
ten times the stock damage.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| Ice Wave has one target-specific damage boundary suitable for an addon. | In hash-pinned `Lotus_Powersuits_Frost_Abilities_IceSpike.lua_B`, prototype 7 constructs `Engine.DamageData`, sets its base amount, Cold distribution, Cold proc count, source, and source object, then calls `target:DamageDD(packet)` at instruction 64. | **TRUE.** |
| The amount at that boundary already includes stock rank and Ability Strength calculations. | The caller passes the calculated damage value into prototype 7 before `SetBaseAmount`; the target-specific packet uses that value unchanged. | **TRUE.** |
| `DamageData:GetBaseAmount()` returns a plain Lua number. | The live exact Ice Wave provider recorded `stockType=userdata`. The stock corpus repeatedly follows `GetBaseAmount()` with `GetModifiedValue()` and also mutates the returned object with `AddModifier`. | **FALSE. It returns an `UpgradedValue` wrapper on this path.** |
| `UpgradedValue:GetModifiedValue()` returns the final numeric packet amount. | Independent stock damage consumers call this exact sequence and use its result arithmetically. | **TRUE.** |
| Exact native hash `ff67e37d` returns the current per-damage-type proc stack count. | Stock Frost Avalanche obtains the target's `DamageControl`, calls the hash with type 4, subtracts the returned number from a desired Cold proc count, and applies only the difference. Independently, HUD Redux calls the same hash by damage type and puts the result in `mBuffDataExtra` for the stack display. | **TRUE.** |
| The human-readable native name is known. | No authoritative symbol name exists in the SDK or corpus. | **FALSE. Keep `Name__ff67e37d`; do not invent a name.** |
| Type 4 is Cold in this path. | Ice Wave's same stock packet calls `SetDamagePct(4, 1)` and `SetProcCount(4, 6)`. | **TRUE.** |
| Reading inside `DamageDD.before` observes the stacks that existed before this Ice Wave hit. | The packet has only configured new procs at that point; `DamageDD` has not yet applied the packet to the target. | **TRUE for the stock call order.** |

## Exact boundaries

- Stock module: `Lotus_Powersuits_Frost_Abilities_IceSpike.lua_B`
- Stock SHA-256: `5C657567B9471A46E78603D4DA2F8D2C792A5BA18C4DACB4609D59D423A6FC69`
- Stock FNV-1a-64 body key: `f62b70b45fc7fdf9`
- Hooks: `hooks.nativeCalls.DamageDD.before/after`
- Prototype/instruction: `7:64`
- Arguments: target at index 1; the exact stock `DamageData` packet at index 2
- Transaction: read `GetBaseAmount():GetModifiedValue()`, save the exact original UpgradedValue, multiply the numeric result by the pre-hit Cold stacks, pass the multiplied wrapper through `SetBaseAmount` immediately before `DamageDD`, then restore the original wrapper immediately after that one call

The addon does not replace Ice Wave, poll targets, calculate a second hit, or
change Cold procs, range, animation, line of sight, augments, source ownership,
or card values. It edits the existing stock packet immediately before the
existing engine damage call and restores the original UpgradedValue immediately
after that one call returns.

## Evidence files

- `ice_wave_damage_packet_excerpt.txt`: exact stock packet construction and hit
  dispatch.
- `avalanche_current_cold_stack_excerpt.txt`: independent stock gameplay use
  of the current per-type stack count.
- `hud_status_stack_excerpt.txt`: independent stock UI use of the same result
  as displayed stack data.
- `exact_callsites.tsv`: instruction-addressed Ice Wave and hash-census rows.

Offline compilation, exact DE-container roundtrip, Semantic Plan, Semantic IR,
strict API checking, and a deterministic behavior harness are package gates.
Actual damage numbers remain a separate in-game acceptance gate.

## First live result and runtime ownership

The first V63 test produced stock Ice Wave damage. The runtime log makes the
failure boundary exact:

- target identity `f62b70b45fc7fdf9`: **PASS**;
- addon compile/load/lifecycle result: **PASS**;
- native method resolution: four `DamageDD` entries and four distinct native
  functions;
- V63 generic native adapter commit: **REJECTED**;
- callback entry: **absent**;
- gameplay multiplier: **absent, as expected after commit rejection**.

Therefore the stack-count and packet hypotheses were never exercised in game.
V64 adds a generic rule specifically for exact-callsite `nativeCalls`: install
one captured-target detour for every distinct native implementation of the
method hash, then dispatch only when the active target body, VM, prototype, and
instruction match. Calls outside that exact ownership boundary invoke their
original implementation without addon dispatch. The single-implementation
fail-closed rule remains unchanged for global semantic hooks where no exact
callsite contract exists.

## V64 live result and V65 diagnostic boundary

The V64 retest still dealt stock Ice Wave damage. This rejects V64 gameplay
acceptance, while narrowing the cause:

- the exact Ice Wave target and addon loaded;
- all four `DamageDD` implementations installed;
- live process-memory reads after the hit showed all four owned E9 detours and
  four separate adapter slots still intact;
- zero `native.call` events appeared because the former diagnostic began only
  after exact callsite ownership.

V65 is deployed with a trace-only, exact-method `NATIVE_INGRESS` observation
before that ownership gate. It is capped at 128 selected entries and eight Luau
frames. The addon bytecode and gameplay path are unchanged. The next single
retest will distinguish an unbound live native implementation from a bound
implementation whose active stack cannot yet resolve prototype 7, instruction
64. See
`RENOVICE_DEPLOYMENTS/NATIVE_INGRESS_CALLSITE_DIAGNOSTICS_V65_2026-09-13`.

## V65 live result and V66 correction

V65 again produced stock damage, so gameplay remains rejected. Its ingress
trace proved Ice Wave reaches installed `DamageDD` slot 2 and that the Lua
caller is exact target prototype 7. Exact ownership failed for three generic
runtime reasons: native-call-only addons were omitted from the published
prototype snapshot, `CallInfo.savedpc` was declared at +0x20 instead of the
live-proven +0x18, and the raw VM word index was compared with the decoded API
catalog instruction.

The live 119-word prototype walks exactly under the certified U43 width table:
raw word 82 is logical `CALL` 65 and immediately follows logical `NAMECALL
DamageDD` 64. V66 fixes all three generic boundaries and leaves this addon's
bytecode unchanged. V66 is offline/package/deployment **PASS**; its Ice Wave
damage behavior is pending a fresh process test. See
`RENOVICE_DEPLOYMENTS/EXACT_CALLINFO_AND_NATIVE_IDENTITY_V66_2026-09-13`.

## V67 live value result and UpgradedValue correction

V67 proves the generic hook path now works: the exact Ice Wave target resolves
to prototype 7, instruction 64; the `DamageDD.before` provider enters with two
native userdata arguments. The bounded provider report then recorded
`coldType=number cold=0 stockType=userdata`. This falsifies the addon's former
plain-number assumption and explains why its eligibility guard never reached
the setter.

The stock corpus independently shows that `DamageData:GetBaseAmount()` returns
an `UpgradedValue`: numeric consumers call `GetModifiedValue()`, while other
damage paths call `AddModifier()` directly on the returned wrapper. The staged
and deployed addon in
`RENOVICE_DEPLOYMENTS/ICE_WAVE_UPGRADED_VALUE_FIX_2026-09-13` now follows the
stock wrapper contract. Offline/package/deployment gates pass. A two-hit
stacked-target gameplay comparison after F9 remains pending.

## V67 live multiplication result and per-call restoration

The UpgradedValue correction reached gameplay. The user observed approximately
177 stock damage becoming approximately 1,770 at ten Cold stacks, which accepts
the intended stack read and arithmetic. Some later hits reached approximately
1.1 million, rejecting the persistent packet mutation.

The provider's bounded report recorded
`cold=6 stock=1771 requested=10626 readback=10626`. These are pre-mitigation
packet values and cannot be compared directly with the approximately 177
displayed damage. The native trace provided the decisive ownership evidence:
it recorded three calls at tick 12112015 with the same DamageData userdata
`0x2439a1f9c40` and different target userdata. Therefore Ice Wave shares its
packet across consecutive target calls and the before-only setter compounded
the multiplier.

`RENOVICE_DEPLOYMENTS/ICE_WAVE_PER_CALL_RESTORE_FIX_2026-09-13` pairs the
existing exact `DamageDD.before` mutation with `DamageDD.after` restoration.
It saves the exact original UpgradedValue, exposes multiplied damage only while
the native call executes, and restores the original object before the stock Lua
continues. The shared-packet harness proves 700 produces 7,000 at ten stacks,
then 4,200 at six, then 7,000 at ten while returning to the same original 700
object after every call. Offline/package/deployment gates pass; corrected live
gameplay is pending F9 and repeated single-target plus multi-target tests.

## Remaining spike and universal combat meter

The user repeated the per-call restoration build and still observed occasional
approximately 195,000 damage. Therefore the shared `DamageData` mutation was a
real compounding defect, but it was not a complete explanation of every large
hit. This live observation supersedes the preceding pending-acceptance sentence
for the restoration package.

The next test uses
`RENOVICE_DEPLOYMENTS/UNIVERSAL_COMBAT_METER_ICE_WAVE_2026-09-13`. Its Ice Wave
behavior preserves the exact per-call restoration. Its embedded generic meter
records baseline and multiplied calls, health/shield/Overguard before and after
the synchronous `DamageDD`, raw requested damage, numeric damage fractions,
numeric status counts, target/packet identity, and restored raw damage. This
will distinguish three causes without guessing: an already-large stock packet,
an incorrect Cold multiplier/requested amount, or a divergence introduced by
the engine after dispatch.

The diagnostics remain controlled by `DiagnosticsMode`. The capture config
uses the exact Ice Wave target and leaves method/addon filters empty because
V67 exposes `_T.RENOVICE_TRACE` only for an unfiltered selected target. The
canonical component and analyzer are documented in
`RENOVICE_SCRIPTING/DIAGNOSTICS_CONFIG.md` and
`RESEARCH/UNIVERSAL_COMBAT_TRANSACTION_METER_2026-09-13.md`.

The deployment then changed exactly the target addon and trace config. V67,
`ScriptStates.json`, every unrelated addon, and every replacement remained
unchanged. Because the game process was not running, the next launch will load
the diagnostic build at startup. Live getter availability and reproduction of
the remaining oversized hit are still unproven.

### 2026-09-13 V1 live-meter failure and V2 correction

The next live run reproduced an approximately two-million hit, but the V1
meter emitted zero `COMBAT_*` records. The same bounded log proves that V67
installed the trace bridge, loaded the Ice Wave addon, reached the exact
prototype-7/instruction-64 `DamageDD` call, and returned from the addon's
before/after providers without an error or reject. V1's combined
`type(_T) == "table"` / `type(trace) == "function"` capability gate is
therefore false in the live DE VM. Because both branches returned silently,
the evidence does not identify which type label failed and does not contain the
numeric cause of that hit.

`CombatTransactionMeterV2.luau` replaces those predicates with a protected
direct read of `_T.RENOVICE_TRACE`. Its regression harness deliberately assigns
nonstandard `userdata` and `cfunction` labels and still recovers one complete
four-record transaction. The compiled V2 addon passes 23/23 container
roundtrip, Semantic Plan, and Semantic IR plus the strict 20/20 API gate. It is
deployed as the only changed script with SHA-256
`75E70E9E015D6448248AC3AD727C479A6D5776956AF201AC0BCBB1A53815D063`.
The live V2 byte boundary is 5,577,510; F9 and a complete oversized-hit
transaction remain the acceptance gates.
