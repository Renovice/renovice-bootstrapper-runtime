# V47 exact damage batch and threat callsite findings

> **Superseded live on 2026-09-07.** V47 failed during native-hook startup.
> V48 repaired hook installation and granted Overguard, but live gameplay
> rejected `RadialDamage` batching as the effect-timing boundary. See
> `V48_GAMEPLAY_TIMING_CLOSEOUT_2026-09-07.md`. The accepted damage input is the
> engine-reported calculated value, including overkill; it is not proven target
> health or effective health removed.

## Scope

Investigate the live V46 report that Overguard amounts were correct but their
feedback appeared delayed or continued after a target died, and replace the
damage-hook threat request with the smallest stock-equivalent threat change.
The standalone target addon, target body key and replacement pipeline remain
separate.

## Hypothesis results

### H1: the native host queues positive damage callbacks for seconds

**FALSE.** V46 `damage.performance` windows showed positive callbacks completing
in roughly tens of microseconds, with only rare approximately one millisecond
samples. There is no evidence of a seconds-long host queue. Positive callbacks
arrive at the engine's Mallet pulse cadence.

### H2: callback argument 2 is the engine-reported calculated damage result for one target result

**TRUE.** This was already established by `WF-LIVE-MALLET-2026-08-23` and
`WF-LIVE-MALLET-EXACT-PIPELINE-2026-08-25`. V46 preserved that path. One radial
pulse can issue several positive callbacks with the same pulse time and distinct
target userdata. The value may include overkill and must not be described as a
measured health, shield, or effective-health reduction.

### H3: the apparent delayed gain is caused by repeated addon work and repeated HUD notifications per victim

**FALSE after V48 live gameplay.** V46 called `afterDamage`,
`SetOverguardAmount` and `NotifyOverguardGain` for every damaged target. The
host callback itself was fast, but a pulse with several targets emitted several
presentation notifications. V47 sums only while the exact target module's
`Region:RadialDamage` call is active and dispatches one hook immediately after
that native call returns. The mathematical grant remains
`sum(reportedDamage) * modifiedFraction`, subject to the same 15,000 cap. V48
successfully ran the addon but real Overguard increments continued for roughly
1.5 seconds after the enemy died. The user ruled out HUD-only delay. Immediate
per-result callback dispatch is the accepted successor.

### H4: threat 5 requires a new secondary-script request from the addon

**FALSE.** Stock BardMusic already creates `SecondaryScriptArgs`, pushes its
computed threat and calls `SetThreatLevel`. The old readable modification was
equivalent to changing the computed value to 5. Calling
`ActivateSecondaryScript` again from every damage path duplicated stock work
and coupled threat to whether damage occurred.

### H5: a method-name-only PushFloatArg override is precise

**FALSE.** The schema-2 call map contains five `PushFloatArg` calls in
BardMusic. The threat argument is the single row at prototype 16, instruction
596. V47 resolves the live caller from the target prototype and
`CallInfo.savedpc`; the addon returns 5 only for that pair and returns the stock
value at every other callsite.

### H6: the addon used the complete stock Overguard integration sequence

**FALSE in V46; TRUE in V47 source.** V46 called `SetOverguardAmount` and
`NotifyOverguardGain` but omitted `Lotus.Scripts.Libs.AbilitiesLib`'s
`NotifyGaveOverguard`. Multiple current stock abilities call all three when
granting Overguard. V47 adds the missing helper with caster as receiver and
source, matching self-granting stock examples.

### H7: card percentage and gameplay percentage can drift independently

**FALSE for the V47 addon.** Both paths call `damageToOverguardFraction`. The
base card shows 1%; the modded card and gameplay both use modifier index 10 on
the active suit and cap the result at 5%. Mock verification checks base 1%,
Strength 3 -> 3%, and Strength 100 -> capped 5% gameplay behavior.

## Evidence boundaries

- Compiler/parser, semantic plan, Semantic IR, strict API and mock behavior are
  offline proof.
- A zero-warning x64 build proves the native implementation compiles and links.
- Exact staged/live hashes prove deployment identity.
- Only an in-game cast against one and several targets can accept the visible
  timing, exact gain and threat behavior.
