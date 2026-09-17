# Addon attachment architecture audit — 2026-08-25

## Conclusion

The current target-addon build does **not** attach gameplay code to Mallet.
It loads and roots an addon closure, and its independent native card-result
adapter can append UI rows, but no verified edge in BardMusic's gameplay call
graph invokes the addon's Overguard callback.

The central rejected assumption was:

> Loading an addon in the target module's VM/environment makes that addon part
> of the target module's execution.

That is false. Co-location is not interception, wrapping, or dispatch.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| A target-addon `PASS` proves gameplay attachment. | The log proves compilation, execution, lifecycle rooting, and registration only. It contains no Mallet callback or Overguard event. | **FALSE live** |
| Borrowing the BardMusic environment exposes the active module owner. | Live `SetSourceObject` observation reported `status=missing-owner`, `owner_tag=0`, and `owner_object=0`. | **FALSE live** |
| Same VM plus same environment automatically joins another module's call graph. | Luau script environments isolate globals unless the host explicitly shares them; an executed closure is called only through an actual reference/call edge. | **FALSE structurally** |
| The card adapter proves the gameplay adapter. | The card adapter intercepts a separate synchronous native `RunScript` result boundary. Its success says nothing about Mallet casts or damage. | **FALSE live** |
| The historical 30,000-Overguard addon independently hooked stock Mallet. | The accompanying BardMusic replacement explicitly called `_T.RENOVICE_AFTER_MALLET_CAST`; the addon only registered that handler. | **FALSE; historical record corrected** |
| A stable explicit dispatch point can support removable F9 addons. | The modified BardMusic dispatch plus `_T` handler was live-tested: F9 add/cast/cleanup worked and granted exactly 30,000 Overguard. | **TRUE live** |
| Unmodified stock BardMusic currently exposes an equivalent addon event. | No such event or exported hook was identified, and the current addon receives no gameplay call. | **FALSE for the current implementation** |

## Decisive local evidence

### Current failed target-addon build

The current live sequence records:

```text
RENOVICE Inject PASS ... exact_env=1
RENOVICE TARGET ADDON PASS key=8faf07b504d058f
RENOVICE native hook PASS key=0 event=SetSourceObject.detour-entry
RENOVICE module owner identity OBSERVE ... status=missing-owner owner_tag=0 owner_object=0
RENOVICE native hook PASS key=0 event=SetSourceObject.target.missing
```

This proves that the native packet method was observed, but the loader-owned
addon closure did not contain the active BardMusic `mOwner`. Consequently, the
host could not associate the packet with the addon and never installed the
damage callback.

### Historical working pair

The known-good base script contains this explicit call edge:

```lua
local handler = _T.RENOVICE_AFTER_MALLET_CAST
if type(handler) == "function" then
    handler(caster, ability, projectile)
end
```

The separate addon registers `afterMalletCast` in that exact `_T` slot. The
addon lifecycle was removable, but the dispatch point was an intentional,
minimal BardMusic instrumentation. The addon did not attach itself to an
untouched base module.

## External implementation evidence

- Luau's embedding documentation explains that hosts commonly give each
  script a new global table and that scripts remain isolated unless the host
  explicitly exposes shared globals: <https://luau.org/sandbox/>.
- Luau documents `getfenv`/`setfenv` as environment mutation tools for cases
  such as custom module systems and mocks, not an automatic function-hook or
  event-composition mechanism: <https://github.com/luau-lang/rfcs/blob/master/docs/deprecate-getfenv-setfenv.md>.
- Upstream OpenWF's `owfScript` constructor calls `luaL_newstate()` for each
  Pluto script. That standalone scripting system is a distinct VM unless the
  host explicitly bridges a call: <https://raw.githubusercontent.com/Sainan/warframe-dll/refs/heads/senpai/owf_scripting.cpp>.

## Correct architecture

An addon system requires a verified attachment edge. There are two valid
implementation families:

1. **Generated hook shim — preferred first implementation.** Start from the
   verified stock module, add small protected dispatch calls at semantic events
   such as `afterMalletCast`, `afterMalletDamage`, and
   `afterAbilityUpgradeInfo`, and keep all custom behavior in removable addon
   files. Stock behavior remains authoritative. F9 swaps addon generations;
   the inert shim remains. This is the architecture already live-proven by the
   30,000-Overguard experiment and can be generated automatically by the
   decompiler/editor instead of maintained as a manual per-ability rewrite.
2. **True VM call interception — later/general implementation.** Detour the
   DE Luau function invocation boundary or replace/wrap the exact callable
   closure exported by the loaded module, identified by module key plus
   prototype/function identity. The host must prove before/after callback
   execution without relying on globals, card queries, spawned instances, or
   timing. This is substantially more invasive and version-sensitive.

Native method detours such as `SetSourceObject` may still be useful for a
generic engine-event bus, but they are not an ability hook unless the host has
a proven, stable way to associate that native call with a specific base ability.
The current `mOwner`-from-addon-environment method does not provide that proof.

## Required acceptance order

No new gameplay addon is accepted from load logs alone. Acceptance must prove,
in order:

1. base module or exact function identified;
2. hook/dispatch installed at that callable edge;
3. hook entered on the expected cast/damage event;
4. addon callback entered with verified arguments;
5. visible effect occurred;
6. F9 replacement changes the effect;
7. F9 removal restores pure stock behavior;
8. the ability card remains a separate projection of the same addon data.

Until steps 1–5 pass, `TARGET ADDON PASS` means only **loaded and registered**,
not **connected to gameplay**.

## Implemented successor — explicit hook-shim proof

The first corrected implementation is staged and deployed under
`RENOVICE_DEPLOYMENTS/MALLET_EXPLICIT_HOOK_SHIM_2026-08-25`.

It uses the stock-semantic BardMusic module and the already-live-confirmed
outgoing `RadialDamageData:SetDamageCallback` signature. The base module only
dispatches the numeric applied-damage result through
`_T.RENOVICE_AFTER_MALLET_DAMAGE`; the target addon owns registration,
cleanup, Overguard, Strength scaling, cap logic, notification, and card rows.

Offline result: all compile, exact roundtrip, plan, Semantic IR, lifecycle,
injection-core, and replacement-core gates pass. Live gameplay remains pending
and is not inferred from addon load or card success.

## Explicit damage-shim live result and host correction

The first live run of the explicit damage shim was **FALSE** for gameplay.
The result was not a missing addon load or a card failure:

```text
RENOVICE Inject PASS ... exact_env=1
RENOVICE TARGET ADDON PASS key=8faf07b504d058f
RENOVICE native hook PASS key=8faf07b504d058f event=afterAbilityCard.publish
RENOVICE native hook PASS key=0 event=SetDamageCallback.detour-entry
Game [Error]: Script instance 'BardMusic.lua' failed to start for TennoAvatar7!
```

No `SetDamageCallback.attach` or gameplay-dispatch success followed. The host
had installed the older native damage-owner detours merely because a target
addon existed, even though this addon exposes only the card projection and uses
an explicit shared-table gameplay dispatch. That automatic coupling was wrong:
a target addon is a packaging/ownership scope, not permission to detour every
native damage callback in the process.

The corrected rule is now machine-enforced:

- `matchesDamageSource` **and** `afterDamage` together opt into the native
  damage adapters;
- card-only and explicit base-dispatch addons leave the game's native
  `SetSourceObject` and `SetDamageCallback` paths untouched;
- if the last native-damage generation is removed, the host removes those
  detours;
- the `RunScript` card adapter is independent and remains active.

The corrected DLL is deployed under
`RENOVICE_DEPLOYMENTS/TARGET_ADDON_NATIVE_DETOUR_OPT_IN_2026-08-25`.
Offline gates pass with zero build warnings/errors. Visible Overguard is still
the required live acceptance boundary; the correction is not called a live
success before that test.

## Native-detour opt-in live result: necessary correction, incomplete cause

The corrected opt-in build was tested in a fresh client process. Its source log
proved all of the following in the same BardMusic VM:

```text
RENOVICE target module identity PASS key=8faf07b504d058f
RENOVICE Inject PASS ... exact_env=1
RENOVICE TARGET ADDON PASS key=8faf07b504d058f
RENOVICE native hook PASS ... event=afterAbilityCard.publish
```

The new run emitted **none** of the old native damage-adapter lines:

```text
native hook adapter PASS SetDamageCallback
SetSourceObject.detour-entry
SetDamageCallback.detour-entry
```

The user still received no Overguard. Therefore:

| Hypothesis | Result |
|---|---|
| Explicit/card addons must not automatically enable the old process-wide native damage detours. | **TRUE** |
| Those old detours were the complete cause of the missing Overguard. | **FALSE** |
| `TARGET ADDON PASS` proves the gameplay callback ran. | **FALSE** |
| The current evidence identifies whether registration, callback entry, shared lookup, handler execution, or Overguard mutation failed. | **FALSE** |

The old base shim used `pcall(handler, ...)` without recording either returned
status or error. It therefore erased the exact evidence required to distinguish
an uncalled callback from a failing addon handler.

## Exact pipeline trace successor

`RENOVICE_DEPLOYMENTS/MALLET_EXACT_PIPELINE_TRACE_2026-08-25` is the staged
successor. It adds a bounded, observation-only C function at
`_T.RENOVICE_TRACE` in the exact target module environment and instruments both
the base shim and target addon. The next live run records, in order:

1. addon activation and shared-handler installation;
2. `SetDamageCallback` registration begin/end;
3. callback entry and its two actual arguments;
4. shared-handler type/value lookup;
5. protected handler PASS or the captured error value;
6. every rejected precondition or the computed damage/fraction/grant values;
7. completion boundaries after `SetOverguardAmount` and
   `NotifyOverguardGain`.

This instrumentation intentionally changes no gameplay values. The first
missing or failing stage, not another inferred architecture theory, determines
the next code change.

## Exact trace result: volatile `_T` invalidated the addon generation

The second trace attempt successfully installed the bridge, loaded and
activated the addon, registered the base damage callback, and observed repeated
callback entries with numeric damage. A live-memory decoder recovered all eight
DE tag-6 strings with zero unreadable values. The ordered result was:

```text
mallet.addon.activate.enter
mallet.addon.activate.done
mallet.base.callback.register.begin
mallet.base.callback.register.done
mallet.base.callback.enter
mallet.base.handler.lookup  "nil" nil
mallet.base.handler.missing
```

This disproves callback-registration, callback-invocation, and numeric-damage
signature theories. The target addon's handler was installed initially but was
not present in the `_T` table read by gameplay.

Three bridge installations occurred in the same Luau global state and borrowed
module environment. Because an existing bridge is detected and not reinstalled,
this proves that DE replaced the `_T` table object without replacing the VM
pointer. The target-addon manager's unchanged test ignored that table identity,
so it retained closures that captured the obsolete `_T`.

The corrected invariant is:

```text
target addon generation identity
  = target module key
  + Luau global state
  + owner thread
  + addon name/content
  + exact current _T table identity
```

A changed `_T` now forces the ordinary cleanup → stage → activate → release
transaction even when the file content is unchanged. This is a general addon
lifecycle correction: any addon storing dispatch state in `_T` would otherwise
silently detach across region transitions.

## Shared-table generation correction — live PASS

The corrected manager observed three `_T` identities under the same VM and
module environment. It performed two complete old-generation cleanup/new-
generation activation transactions. After the final transition, all 350 damage
callbacks resolved the active function; none reported a missing handler or a
handler error. Eleven positive damage events completed calculation,
`SetOverguardAmount`, and `NotifyOverguardGain`, and the user confirmed the
visible Overguard effect.

This also resolves the apparent contradiction with the historical flat-30,000
cast addon. That test was loaded by F9 and consumed on the next cast without a
subsequent `_T` transition. It proved same-table registration and dispatch, not
cross-region persistence. The damage addon separated registration from later
consumption and therefore encountered the untested table-replacement case.

The corrected interpretation is:

| Earlier statement | Correct scope |
|---|---|
| The 30,000 test proves `_T` dispatch works. | **TRUE within one `_T` generation.** |
| The 30,000 test proves an addon remains attached after region transitions. | **FALSE; that transition was not exercised.** |
| The later missing handler disproves explicit dispatch. | **FALSE; callback dispatch worked, but it read a replacement `_T`.** |
| Exact `_T` identity belongs in target-addon lifecycle state. | **TRUE offline and live.** |
