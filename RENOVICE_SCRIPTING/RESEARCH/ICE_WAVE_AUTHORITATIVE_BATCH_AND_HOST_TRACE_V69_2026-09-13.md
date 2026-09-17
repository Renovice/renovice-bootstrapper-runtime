# Ice Wave authoritative helper batch and host trace, V69

Date: 2026-09-13

## Scope

V69 corrects Ice Wave's remaining multi-target multiplier shuffle and makes the
central diagnostic closure available to addon callbacks without depending on a
borrowed module environment's global lookup. It changes the generic callback
ABI and the standalone Ice Wave addon. It does not change stock Frost bytecode,
Pluto, the server, another addon, or a replacement script.

## Hypotheses and results

| Hypothesis | Result | Evidence |
|---|---|---|
| V68 eliminated unbounded compounding. | **TRUE by user observation** | Million-scale and extreme overdamage stopped after V68. |
| V68 assigns every target its own visible Cold multiplier. | **FALSE by user observation** | A visible zero-stack target occasionally received about 10x while a visible ten-stack target received a smaller value. |
| Stock constructs one `DamageData` outside the target loop. | **FALSE by exact stock raw source** | Prototype 7 lines 388-469 reset the local to nil and call `Engine.DamageData()` inside every loop iteration before `SetBaseAmount(c8v2)` and `DamageDD`. |
| Native pointer equality identifies one logical damage packet. | **FALSE by stock source and live trace together** | Consecutive targets at tick 17870828 have different target addresses and the same packet address. Since stock allocates per target, the allocator reused the address. |
| Prototype 7 argument 3 owns the common stock damage. | **TRUE by exact stock raw source** | Every per-target packet receives `c8v2` through `SetBaseAmount`; `c8v2` is the helper's third argument. |
| Addon `_T` lookup is a valid diagnostic transport in every borrowed environment. | **FALSE live** | V68 logged complete native provider calls and an installed bridge but produced zero `COMBAT_*` records. |
| The host can pass its exact owned bridge directly. | **TRUE offline and by runtime ownership proof** | V69 resolves `_T` through the host's proven hashed-global path, accepts only its own C closure, and appends that TValue to the callback ABI. |

## Authoritative hook

`luaCalls[7].before` captures argument 3 and resolves its modified numeric value.
The paired `after` ends the synchronous helper scope. While that scope is
active, only native `DamageDD` at prototype 7 instruction 64 is changed.

For each target:

1. Read Cold stacks from that target's `DamageControl` status index 4.
2. Clamp the stack count to 10 and use `max(1, stacks)`.
3. Install `helper argument 3 x target multiplier` for the exact native call.
4. Restore the exact base object that this target's `DamageData` held on entry.

No packet pointer, target pointer, prior target amount, per-frame loop, polling,
or repeated enforcement participates in the calculation.

## Diagnostic transport

V69 appends the host-owned trace closure as the final optional callback value:

- `luaCalls`: `(prototype, arguments, upvalues, hostTrace)`;
- `nativeCalls.before`: `(prototype, instruction, arguments, hostTrace)`;
- `nativeCalls.after`: `(prototype, instruction, arguments, results, hostTrace)`.

Existing Lua functions remain compatible because extra arguments are ignored.
The host supplies a closure only when trace diagnostics select the target, the
method/addon filters are blank, and `_T.RENOVICE_TRACE` is the exact C closure
owned by the runtime. Otherwise it supplies nil.

## Verification

- Ice Wave V69 Luau harness: **PASS** for 0, 1, 6, 10, and capped-above-10
  status inputs; cross-target address reuse; contaminated observed packet
  values; exact object restoration; wrong-scope inactivity; direct host trace;
  and dormant diagnostics.
- Addon deterministic compile/reparse: **PASS**, 6,109 bytes, 29 prototypes,
  no hashed globals or fields.
- DE-container self-roundtrip: **PASS 29/29**.
- Semantic Plan: **PASS 29/29**.
- Semantic IR: **PASS 29/29**.
- Strict API check: **PASS**, zero violations and zero unknown calls.
- Generic injection verifier: **PASS**, including exact callback counts and
  trace argument indices.
- Safe runtime source verifier: **PASS**.
- Private x64 build: **PASS**, 4,597,760 bytes, zero warnings and zero errors,
  SHA-256 `53370FED9AA6843BB01CF80ECBEB57266CF71AFF39D6344383C1F39B99DD7451`.
- Deployment: **PASS** with the exact game process stopped. The installed V69
  runtime is 4,597,760 bytes with SHA-256
  `53370FED9AA6843BB01CF80ECBEB57266CF71AFF39D6344383C1F39B99DD7451`;
  the installed addon is 6,109 bytes with SHA-256
  `4939AEF25C10FAC7C187EF475518D2AAC3D76091CA1709556739FCE3FAE34A6B`.
  The complete non-log CustomScripts inventory changed exactly that addon;
  26 other files, `renovice.cfg`, and `ScriptStates.json` remained identical.
- Gameplay: **PENDING** after a full restart because the DLL changed.

## Evidence boundary

The exact stock source and live address reuse falsify the V68 identity model.
The offline harness proves the V69 calculation and restoration under that
failure case, and deployment proves exact artifact placement without unrelated
script drift. Only the next in-game multi-target test can accept the observed
damage-number behavior. Combat Meter V4 records the exact inputs and outputs
needed if a mismatch remains.
