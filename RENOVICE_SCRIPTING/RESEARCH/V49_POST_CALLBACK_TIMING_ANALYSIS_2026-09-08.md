# V49 post-callback timing analysis

Date: 2026-09-08

Feature: `LI-013` universal target-addon hook bus

Target body key: `08faf07b504d058f`

## Observed result

The user reports that V49 works in gameplay, including Mallet damage producing
Overguard, but an intermittent timing defect remains: occasionally the visible
damage/death occurs and one or two Overguard increments become observable a
fraction of a second later. The user explicitly distinguishes the real frame
state from a delayed HUD popup.

## Hypotheses and results

### H1: V49 queues positive damage inside the injector

**FALSE.** `addon_damage_callback_wrapper` checks callback argument 2 and calls
`dispatch_target_hook(..., "afterDamage", ...)` directly on the callback stack.
There is no pending list, deferred drain, radial batch, timer, polling loop, or
worker queue between callback entry and the addon.

The retained V49 log contains 73 two-second performance windows. The measured
host path averaged about 92 microseconds per window maximum and its largest
single recorded maximum was 1,554.2 microseconds. No V49 dispatch error was
recorded. These measurements begin when the engine has already invoked the Lua
damage callback, so they rule out an injector-side half-second backlog but do
not measure engine delivery time before callback entry.

### H2: a yielding stock callback postpones the Mallet addon

**FALSE for stock BardMusic.** The generic embedded callback composer preserves
an existing Lua callback by running it before the addon dispatcher. Stock
BardMusic, however, creates `RadialDamageData`, assigns its source and source
object, and calls `gRegion:RadialDamage` without calling `SetDamageCallback`.
For this receiver `originals[receiver]` is nil and `prepareSource` returns the
addon dispatcher alone. Changing the generic stock/addon order would therefore
not change Mallet timing and would alter unrelated callback composition without
evidence.

### H3: the addon waits after receiving a positive result

**FALSE structurally and by measured runtime.** `afterMalletDamage` reads the
current pool, computes the Strength-scaled fraction and cap, and calls
`SetOverguardAmount` on the same Lua invocation. Notification calls follow the
setter. There is no addon-side wait. The V49 performance maximum above includes
the complete provider dispatch.

### H4: the remaining delay occurs before or after the exact setter boundary

**UNRESOLVED; narrowed to the engine boundary.** The current trace begins at
the engine's resolved-damage callback and ends after the addon returns. It does
not timestamp the engine's visible damage/death publication, identify callback
argument 1's target, or independently observe when the new Overguard state is
published to the player. Two explanations remain compatible with the evidence:

1. the engine publishes damage/death before it invokes the per-target result
   callback or before the setter becomes observable to the client; or
2. a later positive callback belongs to another target or another already
   emitted damage instance and visually resembles a post-death grant from the
   target being watched.

## Comparison with historical Mallet edits

The historical numeric-callback replacement also installed
`SetDamageCallback` on each outgoing Mallet packet and called
`SetOverguardAmount` inside that callback. V49 adds a measured synchronous
dispatcher, not a scheduled effect.

An older `BardMusic_overguard_maxthreat.lua` experiment is not an equivalent
timing reference: it granted from the outgoing `UpgradedValue` after
`RadialDamage` returned, once per pulse, rather than from each engine-reported
per-target result. It could look more tightly aligned while using different
damage semantics.

## Decision

Do not add a dead-target filter, timer, accumulator, repeated setter, or raw
pulse-damage substitute. Each would either discard a valid positive Mallet
result or change the requested reported-damage formula.

If the remaining fraction-of-a-second defect must be removed, the next bounded
diagnostic is to retain callback argument 1 as target context and timestamp the
native damage-result invocation, `afterDamage` entry, and exact
`SetOverguardAmount` call. That experiment must preserve current gameplay and
must distinguish per-target engine delivery from Overguard state publication
before changing behavior.

## V50 bounded diagnostic implementation

V50 implements that diagnostic without changing behavior. The generic native
callback closure now retains the exact `RadialDamageData` receiver as an opaque
damage-packet identity and passes five arguments to `afterDamage`: source
ability, reported damage, callback argument 1, packet identity, and a monotonic
correlation ID. Existing providers remain compatible because Lua ignores extra
arguments. The runtime remains ability-agnostic.

With `Diagnostics=true`, each positive callback records
`damage.timing.receive` immediately before provider dispatch and
`damage.timing.after-addon` immediately after it. The diagnostic Mallet source
records `mallet.timing.before-set`, then reads the pool back immediately after
the existing setter and records `mallet.timing.after-set`. All records contain
`tick_ms`; matching correlation IDs and packet identities join the four
boundaries. Zero and negative callbacks do not create timing records.

Offline result: **PASS**. The addon behavior test verifies the before/after
readback values and opaque identities. DE recompile/reparse, full-body
roundtrip, semantic plan, Semantic IR, strict API, injection core, safe runtime,
Scripts UI, x64, and import gates pass. The private build reported zero warnings
and zero errors. The live deployment changed only the DLL, Mallet addon, and
diagnostics config, preserved 14 other custom files by hash, and retained the
exact Scripts bridge and script policy. The game remained stopped afterward.
Startup and gameplay timing remain **PENDING** until the user runs the game and
reproduces the intermittent event with V50.

## V50 live capture result

The user reproduced the real post-death Overguard increment in PID 27616. The
process loaded the pinned V50 DLL with SHA-256
`E82EA6287B9F5E0571D0D92C2A5545B6CB8BF2E51AEF1DDB84DAF1571A720C6B`.
The target module graph contained 22 prototypes, the target addon passed, and
the callback/runtime hooks reported no error.

The capture contains 21 positive callbacks from tick 42,044,390 through
42,054,390. Every successive callback arrived exactly 500 ms after the prior
callback. Each one entered the single addon provider immediately and returned
from the complete provider dispatch in 0 or 16 wall-clock milliseconds. The
high-resolution performance windows measured a largest single complete
host/provider duration of 2,152.1 microseconds and zero dispatch errors.

After the final positive callback, the next performance window contained three
positive results and one zero result; every following two-second window
contained 28 zero results and no positive result. The observed late Overguard
therefore did not come from an earlier callback waiting in RENOVICE. A later
Mallet beat delivered a new positive numeric result to the engine callback,
and the addon consumed that result synchronously.

Both opaque values changed on every positive callback: callback argument 1 and
the `RadialDamageData` receiver. The receiver change is consistent with stock
BardMusic constructing a new outgoing damage packet per beat. The callback
registry still defines argument 1 as `target_or_context:unknown`; this capture
does not justify calling it the damaged enemy or adding an alive/dead test to
it.

The optional Lua-side `mallet.timing.before-set` and
`mallet.timing.after-set` records did not appear. There was no hook/provider
error, but the diagnostic `_T.RENOVICE_TRACE` bridge was not visible to this
addon closure. This is a negative diagnostic result and the analyzer now
reports the 21 groups as `native-complete`, not `setter-complete`. It does not
weaken the queue conclusion because native `dispatch.enter` and
`dispatch.return` bracket the entire synchronous addon invocation, including
the existing setter.

### Updated hypothesis results

- Injector/provider backlog after callback receipt: **FALSE**.
- Delayed HUD-only observation: **FALSE by user observation**.
- A later 500 ms Mallet beat supplies a fresh positive callback that causes the
  later grant: **TRUE for this capture**.
- Callback argument 1 is the damaged enemy and can be filtered with an alive
  predicate: **UNPROVEN**.

Do not change the damage formula, reintroduce radial batching, or add a timer.
The next behavior change requires proving callback argument 1's native type and
lifetime. Only if it is the actual victim should the addon reject a callback
whose authoritative game object is already dead. Otherwise the correct hook is
the engine's applied-damage result boundary that owns a proven victim identity.

## V51 callback object identity gate

The V50 process had exited before its transient callback userdata wrappers
could be inspected through `ReadProcessMemory`. That retrospective probe is
therefore **INCONCLUSIVE**, rather than evidence for or against a target type.
Its read-only tool is retained under
`RESEARCH/MALLET DAMAGE CALLBACK RE/TOOLS/V51_ARGUMENT1_IDENTITY/`.

The exact-build Ghidra project is pinned to executable SHA-256
`CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93`,
but it does not define a function start at the runtime binding RVA
`0x1A11200`. The older-build setter decompilation proves the callback-handle
store at RadialDamageData `+0xE4`; it does not prove the invocation's first
argument. Unrelated `+0xE4` field readers were rejected as type evidence.

V51 therefore observes the value synchronously at the already-proven callback
boundary. It applies the runtime's existing GV >= 38.5 userdata unwrap and logs
the source ability, callback argument 1, and RadialDamageData packet as raw
userdata, unwrapped engine `Object*`, `Object::type`, object/type handles, and
resolved type path/name. It changes no addon bytecode or gameplay calculation.

Offline result:

- private DLL build: **PASS**, zero warnings/errors, x64, no companion import;
- package gate: **PASS**;
- deployment: **PASS**, DLL only, all 16 CustomScripts files hash-preserved;
- V51 DLL SHA-256:
  `978FC0302698C4A8612EAE6E5D4CF3E3625A63C827965AA1921E712472F4BC2B`;
- gameplay/type conclusion: **PASS for the reproduced Mallet path**.

The saved post-boundary capture contains 45 positive callbacks. All 45 callback
argument-1 values unwrap to the
`/Lotus/Types/Enemies/Grineer/Forest/Avatars/RifleLancerAvatar` type. The
changing Lua userdata wrappers resolve to one stable engine object for
correlations 1-22 and a second stable engine object for the later target
sequence. The source remains one OctaviaPrime ability object. The packet
userdata does not use the engine `Object` wrapper layout; the analyzer now
records that as `packet_engine_objects=0` rather than incorrectly requiring a
packet type.

Hypothesis results:

- callback argument 1 is the damaged enemy `AvatarOrEntity`: **TRUE for this
  live path**;
- callback argument 1 is a retained packet/context object: **FALSE**;
- calling the stock zero-argument boolean `AvatarOrEntity:IsDead()` during
  the synchronous callback is contract-valid: **TRUE**;
- retaining the callback target after the callback: **UNPROVEN and not used**.

V52 applies the minimum behavior change in the standalone target addon. Before
reading the caster or writing Overguard, it returns only when the non-null
callback target currently reports dead. It preserves the engine-reported
damage formula, Strength-scaled conversion and cap, threat-5 native callsite,
card rows, and universal runtime. There is no timer, batching, polling,
per-frame enforcement, second radius scan, or runtime ability branch.

V52 offline result:

- behavior test with both living and dead callback targets: **PASS**;
- source/staged deterministic compile: **PASS**;
- DE full-body roundtrip: **PASS**, 11/11 prototypes;
- semantic plan and Semantic IR: **PASS**, 11/11 prototypes;
- strict API check: **PASS**, zero violations and zero unverified calls;
- injection, runtime, and Scripts UI regression gates: **PASS**;
- deployment: **PASS**, addon only; V51 DLL and 15 other CustomScripts files
  preserved by hash;
- V52 addon bytecode SHA-256:
  `95A13EDE7B48CBEFD47550D69F34E47DC2E7AF7DC9611BFC17425DE2C650DD64`;
- gameplay: **PENDING**.

### V52 live falsification and V53 fail-open successor

V52 gameplay is **FAIL**. PID 30840 loaded the target addon and produced 16
positive RifleLancerAvatar callback identities, but all 16 `afterDamage`
invocations ended with `attempt to call nil method` and `dispatch.error`.
None reached `dispatch.return`, so the Overguard calculation never ran. The
exact failed capture has SHA-256
`1443E4802E8B1E60BE729A0A23E8724E40150C3DC60B093BADD703547FA43F5C`.

This separates native identity from Lua interface: callback argument 1
unwraps to the damaged Avatar object, but this callback userdata metatable does
not expose `IsDead`. V52 was rolled back immediately to the exact V50 addon,
and the rollback passed the V51 deployed-state gate.

V53 uses the stock `IsKilled()` state method, observed at 1,188 sites across
267 modules and 799 prototypes, behind a short-circuit capability check:
`callbackTarget.IsKilled ~= nil and callbackTarget:IsKilled()`. If the
wrapper does not publish `IsKilled`, the unchanged Overguard path continues.
The mock explicitly verifies living, killed, and methodless targets. Package
and deployed-state gates pass; deployment changed only the addon and preserved
the V51 DLL plus 15 other CustomScripts files. V53 gameplay remains pending.

## V53 live reproduction and V54 state diagnostic

V53 gameplay preserves the working Overguard path, but the late increment is
**still reproducible**. The PID 27052 post-boundary capture contains 104
positive callback identities and 104 successful dispatch returns with zero
errors. Six separate callback engine objects define six combat sequences. Each
object is a RifleLancerAvatar and remains stable within its sequence. The
latest sequence contains 18 positive results from tick 58,810,312 through
58,819,046, normally separated by exactly 500 ms.

The V53 capture therefore supports these results:

- queued or deferred addon grants: **FALSE**;
- each later gain has a new positive native callback value: **TRUE**;
- V53 `IsKilled` rejected any captured callback: **FALSE**;
- whether `IsKilled` was absent or returned false: **UNRESOLVED**, because the
  `_T.RENOVICE_TRACE` bridge was not visible to the target addon closure;
- the prior per-positive identity diagnostic is timing-neutral: **FALSE**.

Correlation 39 spent 437 ms between native receipt and identity completion.
Correlation 91 spent 328 ms in the same observer and returned from the full
callback after 344 ms. Provider execution itself was 0-16 wall-clock ms. These
observer stalls can delay an individual visible grant, so per-positive object
identity logging is removed from the next timing test.

V54 installs the existing observation-only bridge as the direct
`RENOVICE_TRACE` hashed field of the exact borrowed target environment. This
uses the same environment publication mechanism as the proven generic target
dispatcher. Broad native callback details return to their bounded sampler.
The addon emits one correlated `mallet.v54.grant` or
`mallet.v54.skip-killed-target` record containing reported damage,
`IsKilled` capability/result, and `GetHealth` capability/result.

V54 is observation-only with respect to target health: a zero-health target
still follows the V53 behavior. If the user-observed late grants record
`GetHealth() <= 0`, that supplies the missing proof for a single synchronous
pre-setter filter. If they record positive health, the health-filter hypothesis
is false and no such filter should be shipped.
