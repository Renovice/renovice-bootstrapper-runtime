# V58 reusable diagnostics and 225/175 API catalog

Date: 2026-09-08; updated with live acceptance and final catalog 2026-09-09

Scope: reusable runtime diagnostics and an evidence-backed API catalog
expansion. Ability Studio generation is deliberately deferred.

## Hypothesis H1

One diagnostics switch can remain dormant during normal gameplay and still
provide strong reusable evidence without changing addon behavior.

### Evidence

- `DiagnosticsMode=off` is an atomic fast-path check before flags are copied,
  arguments are rendered, a sequence is incremented, or a file write is
  attempted.
- `DiagnosticsMode=errors` admits only event names containing `error`, `reject`,
  or `failed`.
- `DiagnosticsMode=trace` admits the full selected event stream.
- Diagnostic output uses its own mode gate and therefore works when ordinary
  `Logging=false`.
- The event limit defaults to 4,096, clamps to 1..65,536, and emits one
  suppression record.
- The bridge callback independently checks for trace mode before formatting, so
  a physically reachable bridge in a second VM remains dormant after an off or
  errors config commit.

### Result: TRUE LIVE for the tested modes

PID 2932 loaded V58 in legacy `Diagnostics=true` trace mode. F9 then committed
`DiagnosticsMode=errors` and `DiagnosticsMode=off`. Trace mode recorded the
selected events; errors mode emitted zero normal addon traces after its commit;
off mode emitted zero addon traces and zero explicit errors. The user observed
no behavior, menu, or performance regression. Exact filters and the maximum
suppression boundary retain their offline proof only.

## Hypothesis H2

F9 can switch the diagnostic mode and reconcile the optional Lua trace bridge
without overwriting another script's `_T.RENOVICE_TRACE` value.

### Evidence

The initial V58 implementation exposed a config-order defect: managed addons
were applied before the prepared config became active. An `off -> trace` F9
transaction could therefore enable native host tracing but leave the Lua bridge
absent until a later target reload.

The corrected implementation reconciles the bridge after the prepared config
commits at the exact current VM/owner-thread boundary. The state classifier now
proves all cases:

- absent plus requested: install;
- exact RENOVICE closure plus requested: retain;
- foreign value plus requested: reject collision;
- exact RENOVICE closure plus disabled: remove and verify nil by readback;
- foreign value plus disabled: leave untouched;
- missing mutation primitives: reject explicitly.

### Result: TRUE OFFLINE; partial live transition coverage

The full injection verifier passes. Live `trace -> errors -> off` F9 transitions
completed cleanly. A live `off -> trace` transition, which is the direction
that installs the optional Lua bridge, was not exercised and remains a separate
live fixture.

## Hypothesis H3

Strong native-call diagnostics can identify an exact callsite and provider
without inventing receiver or parameter semantics.

### Evidence

Trace mode records the target body key, VM/thread, method, exact DE prototype,
zero-based instruction, fixed argument/result counts, up to eight rendered
values, provider addon filename, lifecycle registry root, phase, return, and
failure. The native vector uses `arg0` for the receiver; the public Lua callback
uses `arguments[1]` for that same value. Provider failure restores stock
arguments or retains stock results.

### Result: TRUE OFFLINE

The logging schema and fallback paths build with zero warnings. The semantic
meaning of an unknown argument remains unresolved until separate stock, native,
or live evidence proves it.

## Hypothesis H4

The authoring catalog can grow from 150 core / 100 high-confidence to exactly
225 core / 175 high-confidence without lowering its evidence standard.

### Evidence

The first 50 new methods were admitted only when the audited stock corpus
showed:

- one method name/hash identity;
- one exact visible argument width at every observed site;
- zero results at every observed site;
- at least ten observed sites;
- no inferred receiver or parameter names.

That slice covers 1,902 audited callsites. Forty-nine rows remain owned by
`UnresolvedReceiver` and have `OBSERVED_STABLE_SHAPE`; the existing
`Avatar:AddGravityMultiplier` deep live contract accounts for the remaining
row. All 50 return families are `ignored`, and none has a nonzero result shape.

The subsequent 25-row expansion admits only structurally stable identities and
keeps uncertain owners and semantic names unresolved. Eight stock value-flow
proofs add exact receiver, argument, and return contracts for `HasArgs`,
`EnableJump`, `EnableCrouch`, `SetForceWalk`, `SetStopMovement`,
`SetWeaponsEnabled`, `SetAbilitiesEnabled`, and `RemoveAllProcs`. They do not
claim live side effects or multiplayer authority.

### Result: TRUE

`wf_api_catalog` reports exactly:

```text
CATALOG PASS rows=200 core=200 high_confidence=150 supported=200 deep_contracts=21 census_rows=55709
```

The final expansion reports:

```text
CATALOG PASS rows=225 core=225 high_confidence=175 supported=225 deep_contracts=30 census_rows=55709
```

The positive checker accepts the selected catalog and the deep-contract
fixtures. The negative checker rejects deliberately wrong arities for the same
catalog classes.

## Hypothesis H5

Stable bytecode call shape alone proves receiver class, parameter meaning, side
effects, authority, lifetime, or dynamic return type.

### Result: FALSE

Those claims are deliberately absent. `HIGH_CONFIDENCE` means only that the
recorded identity and structural call evidence satisfy the catalog's pinned
admission rules. Unresolved receiver classes, parameter meanings, authority,
lifetime, and side effects remain explicit unknowns.

## Semantic SDK result

The SDK selftest passes eight checks, including deterministic generation,
exact observed shapes, the 225/175 invariant, the 55,709-site census invariant,
negative finding retention, rejected native type retention, and absence of
guessed native links.

Two consecutive builds produced identical outputs:

```text
BUILD PASS symbols=241 deep=46 catalog=225 sites=37615 native_functions=2 native_types=4
semantic-sdk.json bytes=310573 sha256=DE1BAAB66C873BBAE3408E3997B1114151B488A71201D1C2D59ED6516443B37E
symbols.tsv bytes=50723 sha256=1E409754D9F5127DCD796F84AF1315EDDFA597F96AB26858A82836FF356A78DD
VALIDATE PASS symbols=241 evidence=23 negative=16 explicit_native_links=0
```

The 55,709 figure is the pinned full callsite census. The SDK's 37,615 site
total is the callsite sum represented by the selected 225 catalog symbols.

## Runtime build result

The final V58 private build passed dependency and manifest gates, config and
injection tests, callback-runtime tests, internal SCRIPTS bridge checks, all 74
SCRIPTS UI checks, safe-runtime source checks, API checks, and the zero-warning
x64 build/import boundary.

```text
PRIVATE BUILD PASS warnings=0 errors=0 x64=yes companion_import=no
bytes=4567040
sha256=8DB276C181D24A23423877570EE7DF4E364A7B77B7C9CF070C3337FE4AE40DF9
```

The embedded callback runtime remains 702 bytes with SHA-256
`527D4F4322F51CF6CE2AE4770CD2AEB4CFF616EA2FB77938BFF4DE3FB461E383`.
The internal SCRIPTS bridge remains 1,111 bytes with SHA-256
`153E5E580FB0D98DDD63C0DE92D46398F6B87B721E69B51885719B50EEF04C82`.

## Live result

The exact V58 DLL and preserved V57 Mallet addon started successfully in PID
2932. The runtime captured 22 Mallet prototypes, installed the trace bridge,
and attached the target addon. The preserved trace slice contains 2,700 detail
records, 25 complete Mallet decisions (20 grants and 5 killed-target skips),
21 performance windows, zero provider errors, and a maximum complete
host/provider duration of 1,705.1 microseconds.

Each F9 mode commit produced one or more `RELOAD PASS` records and zero reload
failures. Every mode completed a SCRIPTS open/close path. After the errors-mode
commit, normal addon trace count is zero; the final off-mode slice contains
zero addon trace records and zero explicit errors. The user accepted the
ability card, damage-derived Overguard, Strength-scaled cap, threat behavior,
killed-target filter, SCRIPTS menu, and ordinary performance.

## Artifact hashes

- selection seeds: 31,538 bytes,
  `DCD72493172EE8D1F4D58B6BEB6DE8837DCD2B27A9CCFDA2613DB5F6776305CB`;
- selected catalog: 49,622 bytes,
  `1A3CCF00EA6C147C85B0F73D51C9E06F7AD5DC421C1AF16329A06225AEBC55AF`;
- Semantic SDK JSON: 310,573 bytes,
  `DE1BAAB66C873BBAE3408E3997B1114151B488A71201D1C2D59ED6516443B37E`;
- Semantic SDK compact TSV: 50,723 bytes,
  `1E409754D9F5127DCD796F84AF1315EDDFA597F96AB26858A82836FF356A78DD`;
- runtime DLL: 4,567,040 bytes,
  `8DB276C181D24A23423877570EE7DF4E364A7B77B7C9CF070C3337FE4AE40DF9`.
- accepted final configuration: 254 bytes,
  `4FBB8F24B0C0677DEAB3670283DF0109906BB4546F650CBD15521E2564CCBF70`.

## Acceptance boundary

Catalog generation, checker behavior, SDK determinism, source tests, runtime
build, deployment, startup, F9 `trace -> errors -> off`, SCRIPTS UI, and the
preserved V57 Mallet behavior are accepted. The final live configuration is
`DiagnosticsMode=off`.

Exact target/method/addon filters, the maximum-event suppression record, and an
`off -> trace` bridge-install transition remain offline-verified. The exported
Lua function-hook template also remains offline-verified. None of those should
be represented as live proof.
