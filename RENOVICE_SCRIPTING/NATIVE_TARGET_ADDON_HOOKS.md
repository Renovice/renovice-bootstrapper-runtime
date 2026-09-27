> **CURRENT V110 DAMAGE-TARGET CONTRACT (2026-09-20):** Target ownership at
> `SetSourceObject` first requires the strict live closure, environment, VM, and
> current-generation prototype identity. DE can execute the same published
> prototype through a different closure environment; V109 then rejected a real
> Mallet call even though the exact prototype and saved instruction were already
> known to the native-call bus. V110 admits that existing exact callsite proof as
> a fallback. Ambiguity always rejects, and no non-exact, stale, cross-VM, or
> foreign prototype can attach a callback. The rule is universal and contains
> no ability body key. Once associated, the existing callback composer installs
> `SetDamageCallback` on the exact `RadialDamageData` packet and dispatches each
> positive engine result immediately to `afterDamage`; there is no radial
> batching, polling, queue, or per-frame enforcement.
>
> **CURRENT V107 LUA-CALL CONTRACT (2026-09-19):** The V49 generic
> `hooks.nativeCalls[method].before/after` contract remains current. V107 exposes
> `hooks.luaCalls[prototype].before` for an exact prototype in the
> body-keyed target module. The host rejects missing or duplicate prototype
> matches before committing the addon generation. The callback receives
> `(prototype, arguments, upvalues, hostTrace)`. In V62, a successful `before` callback may
> replace an argument only with a finite number when the original is a number,
> or a boolean when the original is a boolean. Referenced table/object upvalues stay live, and the host copies back
> only same-type finite number or boolean upvalues. GC identity replacement is
> rejected. V107 observes DE raw CALL `0x54` through an original-first detour of
> callback `0x197EC80`; it no longer infers nested calls from VM entry. Every
> `luaCalls.after` declaration rejects because complete return/yield/error and
> record-cleanup retirement is not yet implemented. V69 appends the runtime-owned diagnostic trace
> closure to Lua and native callbacks. It is nil when trace diagnostics do not
> select this target. Existing callbacks remain compatible because Lua ignores
> extra final arguments.
> V60 is rejected live because it dispatched `after` on suspended Survival
> prototype 64 and the later resume crashed. V61/V62 retained before-only
> source compatibility but still observed VM entry rather than every nested
> CALL. V107 replaces that admission boundary and retains no per-call root. Its
> first scalar-copyback user is the
> Mallet addon: `luaCalls[18].before` changes argument 3 to `5`, leaving the
> stock `SetThreatLevel` Lua body and its native call authoritative. V107 is an
> offline candidate; live Mallet/Survival/Interception acceptance remains open.

## Current exact Lua prototype before calls

A standalone target addon may declare:

```lua
return {
    activate = function() end,
    cleanup = function() end,
    hooks = {
        luaCalls = {
            [64] = {
                before = function(prototype, arguments, upvalues, hostTrace) end,
            },
        },
    },
}
```

The numeric key is the exact zero-based prototype identity in the target
module's verified prototype graph. Each declaration must have at least one
callable `before` or `after` member. Duplicate keys, nonnumeric keys,
out-of-range keys, malformed phase values, a missing prototype, or more than one
matching prototype, a missing `before`, or any `after` member reject the staged
addon generation before commit.

The callback arguments are:

| Value | Contract |
|---|---|
| `prototype` | Exact numeric prototype ID that matched the declaration. |
| `arguments` | One-based current arguments. Finite same-tag number or boolean replacements are copied to the running call after the callback succeeds. Every other replacement is rejected and the stock value remains. |
| `upvalues` | One-based view of the exact closure captures. Referenced tables and userdata retain their native identity, so ordinary field edits affect the original object. |
| `hostTrace` | Optional host-owned bounded diagnostic closure. V69 passes it directly because a borrowed module environment may not resolve `_T`; nil means diagnostics are dormant. |

After a successful callback, the host copies an edited upvalue slot back only
when the original and new values are both numbers or both booleans. Numbers must
be finite. Strings, tables, functions, threads, userdata, vectors, and every
other GC-backed identity cannot replace an upvalue through this interface. This
restriction preserves the VM write-barrier boundary. A rejected mutation or
callback error is logged and stock execution continues with the original slot.
Argument copyback applies the same finite number/boolean and same-tag rule, only
during `before`. The host validates the exact live argument count and every
candidate mutation before changing any argument, so a malformed callback cannot
partially rewrite a call.

Callbacks run under the target generation, Lua mutex, exact VM/owner-thread,
and recursion-depth guards. `before` runs at the exact DE CALL instruction,
before stock creates/enters the child frame. The host derives the function and
argument window from the caller's A/B operands. It retains no CallInfo token or
argument registry root after the callback returns. The runtime contains no
per-ability logic: body-key filename, prototype declaration, validation, and
addon Lua own the behavior. F9 may publish a new generation for later calls;
installing a new DLL version still requires a process restart. Lua `after`
remains unavailable until every natural retirement owner is implemented.
>
> **V49 EXECUTION CONTRACT (2026-09-07):** `afterDamage` now dispatches every
> positive engine-reported damage result directly from the installed source
> callback. `RadialDamage` is no longer hooked, accumulated, or used as an
> effect boundary. The low-level API is `hooks.nativeCalls[method].before/after`.
> The host resolves each declared SWIG method once, installs a compact native
> detour, requires an exact target-body/VM/prototype/instruction caller, and
> passes mutable one-based argument and result tables. Invalid declarations,
> missing or ambiguous native implementations, alias collisions, callback
> errors, and partial detour bundles fail closed; stock arguments or results
> are retained on callback failure. The V49 Mallet addon declares
> `nativeCalls.PushFloatArg.before` for prototype 16 instruction 596, so threat
> 5 is addon data rather than a C++ ability branch. Its Overguard cap uses the
> stock Pagemaster operation-10 Strength path for both gameplay and card rows.
> Package/offline verification passed. PID 23868 then accepted the exact target
> graph, addon, damage transport, and one generic native method with the
> corrected `build=V49` marker. Live gameplay remains a separate gate.
>
> V48 closeout (2026-09-07): callback argument 2 is the engine-reported
> calculated damage result. It may include overkill and is not target health,
> shields, or effective health removed. That calculated value is the accepted
> feature input. V48 proved standalone addon loading, visible Overguard, and
> installation of all four generic adapters, but its `RadialDamage` batching
> failed live timing: real Overguard increments continued for roughly 1.5
> seconds after the enemy died. This was not a HUD-only delay. The accepted
> successor must dispatch each positive resolved damage callback immediately;
> `RadialDamage` must not control when the gameplay effect is applied.
> `transformFloatArgument(prototype, instruction, stockValue) -> number` is the
> first instruction-addressed native argument contract. It is opt-in, uses the
> validated target prototype graph plus `CallInfo.savedpc`, and leaves every
> unrelated call unchanged. V47's first live launch exited during unhandled
> ordinary-detour creation.
> V48 uses separate compact hooks for the two new native wrappers, catches and
> records hook-construction failures, and restores target bytes before freeing
> trampolines. PID 26948 passed startup with all four adapters installed. See
> RESEARCH/V48_COMPACT_NATIVE_HOOK_RECOVERY_2026-09-07.md and
> RESEARCH/V47_EXACT_DAMAGE_BATCH_AND_THREAT_CALLSITE_2026-09-07.md.
> 2026-09-07 correction: V44 target-family matching succeeded live, but passing
> a C closure to SetDamageCallback aborted stock BoxLoop with `expected lua
> function (not c)`. V45 embeds a universal DE Lua callback constructor and
> protects native installation. Stock callbacks compose in Lua; source is
> observed from SetSourceObject, never guessed from stock upvalue zero.
> See RESEARCH/V44_CALLBACK_ABI_FAILURE_2026-09-07.md and deployment V45.
> Threat 5 remains a separate live acceptance gate. See
> RESEARCH/V48_GAMEPLAY_TIMING_CLOSEOUT_2026-09-07.md. Older implementation
> descriptions below are historical evidence.
# Native target-addon hook bus

Date: 2026-08-24

Feature: `LI-013`

> **HISTORICAL V44 STATE, 2026-09-07:** V43's root/environment matcher failed in
> gameplay. V44 publishes the full exact DE prototype graph, roots the original
> closure, and requires same-VM caller membership for native damage attachment.
> All 22 target prototypes registered live at startup; gameplay remains pending.
> Correlated tracing covers source matching through callback dispatch and errors.
> See `RENOVICE_DEPLOYMENTS/PROTO_FAMILY_TRACE_V44_2026-09-07/README.md` and
> `RENOVICE_SCRIPTING/RESEARCH/UNIVERSAL_ADDON_API_REQUIREMENTS_2026-09-07.md`.
> Older implementation descriptions below are historical evidence. The injector
> is raw DE Luau; Pluto is not its execution engine. The general host must support
> standalone authored addons without per-ability native branches or shims.

> **HISTORICAL V42/V43 MODEL — REJECTED IN GAMEPLAY.** The generic host loads a
> content-keyed addon into the exact borrowed target-module environment. Card
> publication matches the queried ability resource. V42 proves that guardless
> card publication works live, but repeats the earlier module-owner failure:
> the borrowed addon environment has no active `mOwner` at `SetSourceObject`.
> The hashed lookup returns nil, so that design is rejected. The shimless V43
> successor identifies ownership from an exact target-module Lua caller on the
> active native-call stack. The walk is bounded and rejects ambiguity.
> `matchesDamageSource` remains an optional explicit fallback. Callback
> attachment, visible Overguard, and threat 5 remain pending live acceptance.
> Historical failed approaches remain below as negative evidence. The
> authoritative pipeline is
> documented in
> `DeNativeDecompiler (use this instead of native)/RESEARCH/ABILITY CARD UI/PIPELINE_AUDIT_2026-08-24/ACTUAL_CARD_PIPELINE.md`.

## Purpose

This is the additive alternative to a full DE Lua replacement. A target addon
is a separate compiled `.lua_B` file. Its filename binds it to the exact stock
module body key, while the stock module bytecode remains untouched.

```text
stock BardMusic module
  + native bootstrapper hook bus
  + 08faf07b504d058f.<name>.target.addon.lua_B
  = stock Mallet behavior plus addon behavior and addon-owned native card rows
```

Full replacements remain supported for edits that must rewrite the original
control flow. Target addons are preferred when an exposed lifecycle or native
callback can express the change without replacing the stock module.

## Current card and gameplay contract

Card selection uses an ability-resource matcher. Gameplay normally uses the
filename's content key and exact module execution identity; an object matcher
is available only as fallback:

```lua
return {
    activate = activate,
    cleanup = cleanup,
    hooks = {
        matchesAbility = matchesAbility,             -- card ability resource
        afterAbilityCard = afterAbilityCard,
        afterDamage = afterDamage,
        nativeCalls = {
            SomeNativeMethod = {
                before = beforeNativeCall,
                after = afterNativeCall,
            },
        },
        -- legacy compatibility only:
        transformFloatArgument = transformFloatArgument,
        -- optional fallback only:
        matchesDamageSource = matchesDamageSource,
    },
}
```

Validation rules:

- `afterAbilityCard` requires `matchesAbility`;
- `afterDamage` opts into native damage adapters and needs no matcher when the
  native call occurs inside the exact target module execution;
- `nativeCalls` opts into exact instruction-addressed native calls. Every key
  must name one unambiguous SWIG method and every value must be a table with a
  `before` function, an `after` function, or both;
- `transformFloatArgument` opts into instruction-addressed float argument
  routing and must return a finite number. It remains for V48-era addon
  compatibility; new addons use `nativeCalls`;
- a card-only or gameplay-only addon is valid;
- `matchesDamageSource` is optional fallback routing for a native call outside
  an exact target module execution;
- `damageSourceAbility`, cross-VM `ObjectType*` equality, borrowed-environment
  `mOwner`, and `SetSource` packet handoffs are retracted and not executed.

For the current Mallet addon:

```lua
local function afterDamage(sourceAbility, reportedDamage)
    local caster = sourceAbility:GetAvatarOwner()
    -- apply addon behavior using the engine-reported calculated damage
end
```

Host flow:

```text
stock SetSourceObject(runtime ability)
  inside exact content-keyed target module execution
  -> stock SetSourceObject returns normally
  -> install additive SetDamageCallback
each positive engine damage callback
  -> afterDamage(runtime ability, reported result) immediately
```

Live V48 rejected the last two lines as the effect-timing contract. The
accepted successor is:

```text
each positive resolved callback for the exact associated target
  -> afterDamage(runtime ability, reported calculated damage) immediately
```

The reported value intentionally retains Warframe's calculated-damage
semantics, including overkill. No health, shield, or effective-health clamp is
part of this feature.

The complete V42 hypotheses, exact staged hashes, rollback, and live procedure
are in
`../RENOVICE_DEPLOYMENTS/HASHED_MODULE_OWNER_V42_2026-09-07/README.md`.

## Addon contract

The filename begins with the exact 16-hex original-body key and ends with
`.target.addon.lua_B`. The chunk returns one lifecycle table:

```lua
return {
    activate = function() end,
    cleanup = function() end,
    hooks = {
        matchesAbility = function(ability) return false end,
        afterAbilityCard = function(rows, query) return rows end,
        matchesDamageSource = function(sourceAbility) return false end,
        afterDamage = function(sourceAbility, actualDamage) end,
        nativeCalls = {
            MethodName = {
                before = function(prototype, instruction, arguments, hostTrace) end,
                after = function(prototype, instruction, arguments, results, hostTrace) end,
            },
        },
        -- legacy compatibility only:
        transformFloatArgument = function(prototype, instruction, value)
            return value
        end,
    },
}
```

`activate` and `cleanup` are mandatory and idempotent. `hooks` is optional for
a lifecycle-only target addon. When present, it must be a table containing at
least one supported behavior callback. Only `afterAbilityCard` requires its
projection matcher. The current native bus exposes:

- `matchesAbility(ability) -> boolean`: declares which base ability resource
  owns this addon's card contribution. The dispatcher calls it only at actual
  card queries and rejects ambiguous claims by different target keys.

- `afterAbilityCard(rows, query) -> rows`: runs after the stock target module's
  `GetAbilityUpgradeLevelInfo` and receives its real native row array and query
  parameters. It must return a table. Providers are chained in deterministic
  addon-name order; the host publishes the final table back to
  `_T.AbilityUpgradeLevelInfo` and verifies exact readback identity. A nil,
  non-table, exception, or failed readback leaves the stock result unpublished
  and emits an explicit failure.
- `matchesDamageSource(sourceAbility) -> boolean`: optional fallback when a
  native `SetSourceObject` call cannot be attributed to an exact target module
  execution. Ambiguous claims are rejected.
- `afterDamage(sourceAbility, reportedDamage)`: receives the exact source
  ability and engine-reported calculated damage. V49 dispatches each positive
  resolved result immediately from that callback and does not wait for or hook
  `RadialDamage`.
  The value may include overkill; it is not a target-pool delta and is never
  incoming damage absorbed by Mallet. The source ability can recover its caster
  through its stock API, such as `GetAvatarOwner()`.
- `transformFloatArgument(prototype, instruction, stockValue) -> number`: runs
  only for `PushFloatArg` calls whose Lua caller belongs to the exact target
  body key and VM. Prototype is DE's bytecode ID and instruction is the zero
  based calling instruction resolved from `savedpc - 1`. Return the stock value
  for every callsite the addon does not own. Invalid, nonnumeric and nonfinite
  results preserve the stock argument and emit an error.
- `nativeCalls[method].before(prototype, instruction, arguments, hostTrace)`: runs before
  the declared native method only when the active Lua caller belongs to the
  exact target body and VM. `arguments` is a mutable one-based table containing
  the receiver at index 1 followed by the native arguments. V49 preserves the
  original argument count. Providers compose in deterministic addon order.
  `hostTrace` is the optional V69 runtime-owned bounded trace closure.
- `nativeCalls[method].after(prototype, instruction, arguments, results, hostTrace)`: runs
  after the original native method. `results` is a mutable one-based table with
  exactly the result count returned by the native function. Callback failure
  retains the stock results. `hostTrace` is the same optional closure and is
  placed after `results`. The current host supports up to 32 distinct
  declared native methods and rejects native aliases that resolve to the same
  implementation because their call identity would be ambiguous.

The host can trace this contract without changing an addon. Use
`DiagnosticsMode=trace` with `DiagnosticsTarget`, `DiagnosticsMethod`, and
`DiagnosticsAddon` as needed. The direct callback closure used by embedded
diagnostics currently requires blank method and addon filters; target filtering
remains supported. The native trace uses `arg0` for the receiver;
the Lua callback's one-based table uses `arguments[1]` for that same receiver.
The complete configuration and evidence boundary are in
`DIAGNOSTICS_CONFIG.md`.

`damageSourceAbility`, UI-to-gameplay type identity, and bounded ancestor-stack
ownership are rejected historical contracts. They are not accepted by current
schema validation. Gameplay does not require a prior card query.

The runtime stores lifecycle roots in the DE registry and dispatches hooks by
module key. It does not exchange handler functions through `_T`, does not scan
ability instances, and does not modify the stock BardMusic bytecode.

## Current card attachment model

The native `RunScript` observer reads the real `_T.AbilityLevelQueryParms`
before the stock provider runs and the real `_T.AbilityUpgradeLevelInfo` after
it returns. It then passes the query's `Ability` resource to each loaded target
addon's `matchesAbility` predicate. Only the unambiguous matching target key may
receive `afterAbilityCard(rows, query)`.

The callback appends native row-shaped entries to the exact stock table and
returns that same table. Live testing proved generic table cloning discards
DE-owned row behavior. The host writes the returned table to the same `_T` slot
the UI reads before `RunScript` returns and verifies identity by readback.
Registry membership, rather than a private Lua `active` flag, is the sole
generation-activation authority.

## Current gameplay attachment model

Stock BardMusic proves the source object and owner relationship directly:

```text
malletCreatorAbility = malletAvatar:GetCreator()
caster = malletCreatorAbility:GetAvatarOwner()
RadialDamageData:SetSourceObject(malletCreatorAbility)
gRegion:RadialDamage(packet)
```

The host resolves the unique native implementations behind
`SetSourceObject` and `SetDamageCallback` for the damage transport, plus every
opt-in `nativeCalls` method. It then installs native entry-point detours. Native
detours remain necessary because cached callers can bypass later SWIG
method-table mutation.

At `SetSourceObject`, the host inspects only active content-keyed target addons
that declare `afterDamage`. The exact same-VM Lua caller must belong to the
target's complete validated prototype graph. That identity installs the
applied-damage callback and captures the source ability. If no exact module
caller is available, the optional `matchesDamageSource` fallback may claim the
source. The card matcher, Arsenal VM, and `SetSource` do not participate.

V49 invokes `afterDamage` at each resolved positive callback. The rejected V48
`RadialDamage` accumulator and detour have been removed, so an enclosing native
area call cannot defer the addon effect.

This is event routing, not instance scanning: no spawned Mallet list, timer,
polling loop, active-frame scan, retained packet table, or object patch exists.
F9 swaps the registry-rooted addon generation without replacing the stock
ability module.

The current Mallet addon uses only the card predicate. Gameplay ownership comes
from the content-keyed module's validated prototype graph and exact same-VM
active `CallInfo` membership. Borrowed-environment `mOwner` is rejected:

```lua
local MALLET_LOCALIZE_TAG = "/Lotus/Language/Suits/BardMusicAbilityName"
local function matchesAbility(ability)
    if IsNull(ability) then
        return false
    end
    return ability:GetLocalizeTag():c_str() == MALLET_LOCALIZE_TAG
end
```

The canonical editor identity remains the resource path
`/Lotus/Powersuits/Bard/Abilities/BardMusicAbility`; generated addons may use a
verified card predicate; gameplay ownership comes from the filename's exact
original-body key and natural module identity.

## Attachment model

**Historical rejected design follows.** It is retained to explain the live
failures and must not be treated as the current implementation plan.

The bootstrapper remembers a natural module load as:

```text
original body key + DE global_state + root proto + module environment
                  + manager + loader name handle + owner thread
```

It then installs two transparent native adapters:

1. After the natural target load returns, the bootstrapper reads the registry-
   rooted module closure, obtains its proven environment table, retrieves
   `GetAbilityUpgradeLevelInfo`, replaces that exact environment field with a
   wrapper, and reads the field back to verify installation. The wrapper calls
   the stock function first, then dispatches `afterAbilityCard` for the active
   addon generation. This does not depend on a Lua C API setter: the VM's
   `SETGLOBAL` bytecode executes internally and does not call the public
   `lua_setglobal` function that OpenWF hooks for engine-originated writes.
2. Stock BardMusic does **not** call `SetDamageCallback`; that method existed
   only in the previously edited full replacement. The hook bus therefore
   adapts `SetSource` only on the exact `RadialDamageData` type discovered from
   its unique `SetDamageCallback` binding. When target BardMusic assigns the
   caster as damage source, the adapter preserves the stock call and installs
   an addon-owned native damage callback on that same damage packet. The later
   stock `RadialDamage` call invokes it once for each applied damage result.
3. If a target module explicitly registers its own `SetDamageCallback`, that
   binding remains decorated too: the original callback executes first and the
   current addon generation runs afterward.

Multiple SWIG aliases are accepted only when every alias points to the same
original native function. Missing or ambiguous bindings fail closed.

Native-call ownership is resolved by walking the bounded active Luau call-info
array from the current frame toward `base_ci`, accepting only function slots
inside the live Lua stack and only closures matching the exact target VM plus
module environment/root proto. This matters because `SetSource` is a C/SWIG
frame; the owning BardMusic closure is an ancestor, not the adapter itself.

Wrappers capture only the stock function and target key. They do not capture an
addon generation. This is what lets F9 replace or remove addon code without
rewriting the stock module again: each call resolves the currently committed
registry generation.

## F9 and performance

There is no filesystem watcher and no per-frame directory scan. F9 reads the
current folder once, validates the complete generation, stages the target
addon, cleans the previous generation, activates the new generation, and
commits only after the lifecycle transaction succeeds.

Target refresh is VM-local and owner-thread-local. Known target contexts are
queued, the current VM is updated immediately at its safe boundary, and other
VMs consume their newest pending generation at their next safe loader
boundary. Deleting the addon is also a transaction: cleanup runs and the
registry root is released. Existing wrappers then become transparent stock
pass-throughs.

VM identity alone is insufficient. Live BardMusic evidence showed DE replacing
`_T` three times while retaining the same global-state pointer, thread, and
module environment. Target generations therefore also own the exact current
`_T` table identity. A changed table forces cleanup, restaging, activation, and
old-root release even when addon bytes are unchanged. This prevents an addon
closure from retaining a handler in an obsolete table while gameplay reads the
replacement table.

Idle cost is zero filesystem work. Runtime cost exists only at an attached
card function or attached damage callback: one stock call, a small registry
lookup, and the active addon callback.

## Mallet proof-of-concept

**Historical rejected POC.** The tested addon attempted to own both changes in
one separate file:

- grant Octavia Overguard equal to the Strength-modified percentage of actual
  Mallet damage, with `1%` base, `5%` cap, and `15,000` Overguard cap;
- append `Overguard Cap` and `Overguard From Damage` through the stock native
  ability-card row array.

The deployment deliberately contained no `08faf07b504d058f` full replacement.
That made the live negative result conclusive for this attachment model: no
fallback replacement could have supplied either missing behavior or rows.

## Hypotheses and status

| Hypothesis | Evidence | Result |
|---|---|---|
| A VM-global `_T` handler is sufficient attachment. | It loaded but produced neither Overguard nor card rows. | **FALSE live** |
| Editing or scanning every Mallet instance is the right addon model. | The desired ownership is the base module and all future calls, not individual objects. | **FALSE by design** |
| Decorating stock `SetDamageCallback` is enough for Mallet. | Untouched BardMusic contains `SetSource` and `RadialDamage` but no `SetDamageCallback`. | **FALSE offline** |
| A module-keyed native decorator can leave stock bytecode unchanged. | The corrected exact-type `SetSource` adapter installs the damage callback without editing BardMusic; native hook identity, schema, alias ambiguity, VM/thread isolation, create/replace/delete refresh, deterministic addon compilation, Semantic IR, and zero-warning DLL build gates pass. | **TRUE offline** |
| Treating the current `SETGLOBAL` helper frame as the ability-card owner works. | The target and addon loaded, but no card-attach/dispatch event appeared. The assigned export closure is the actual module-owned value. | **FALSE live** |
| A 24-byte partial `CallInfo` declaration can be used for `ci - 1`. | The corresponding Luau VM source defines a 48-byte record. Pointer arithmetic landed 24 bytes into the current frame, so no target Lua caller could be found. | **FALSE structurally** |
| The corrected 48-byte ABI plus validated active-frame walk routes both hooks. | Static ABI assertions, bounded-chain tests, all injection tests, deterministic addon compilation, six-prototype Semantic IR, and a zero-warning DLL build pass. | **TRUE offline; PENDING live** |
| A VM `SETGLOBAL` opcode reaches the hooked public Lua C API setter. | Three clean launches produced no attach event despite exact target/load/addon evidence; static bytecode shows `SETGLOBAL`, while the detours wrap the public API helpers. The interpreter handles the opcode internally. | **FALSE structurally and live** |
| A successful module-loader return proves the module root has executed. | The environment existed, but direct lookup returned no function; stock bytecode proves the export is a normal string-key `SETGLOBAL`. The replacement subsystem independently distinguishes load from execution. | **FALSE structurally and live** |
| Decorating after the exact root protected call is the correct base-module boundary. | The detector requires exact VM, root proto, and environment identity; nested/cross-VM/unrelated cases fail deterministic tests. The stock call completes before decoration and immediate readback remains mandatory. | **TRUE offline; PENDING live** |
| The POC works in gameplay and Arsenal. | The final root-execution/cached-environment build loaded its target and addon but produced neither Overguard nor card rows. | **FALSE live** |
| F9 add/change/remove works in every encountered VM. | Per-VM transactional queue is implemented and offline-gated; UI/gameplay live sequence is still required. | **PENDING live** |

`LI-013` remains experimental. Do not continue the cached-environment design or
promote editor-wide support. Implement the separately audited real card and
gameplay boundaries first, then restart live acceptance from observation-only
gates.

## 2026-08-24 semantic publisher live result and correction

The real RunScript card boundary has now produced `target_match=1`,
`card_published=1`, and `afterAbilityCard.publish` for Mallet. The card changed,
but only Drain remained. This is a useful positive/negative split:

- **TRUE live:** the addon reached and controlled the real card result;
- **FALSE live:** copying `1..#rows` into a generic table preserves DE's stock
  row representation;
- **TRUE structurally:** the proven replacement inserts directly into the
  original `GetAbilityUpgradeLevelInfo` table and publishes that same object.

The addon contract therefore requires providers to preserve and return the
exact stock table unless the host later implements a verified native table
clone. The current Mallet provider performs in-place `table.insert` calls and
returns `rows`. Live acceptance requires the observer's `result=` and
`published=` identities to be equal; a new identity is a failed provider.

The missing gameplay callback had a separate object-shape error. Stock
BardMusic passes `p16_0:GetCreator()` to `SetSourceObject`: this is the runtime
ability instance, not the ability resource received by `matchesAbility` in the
card query. Calling localization methods on `sourceObject:GetType()` did not
match live and is rejected.

The first same-table live retest restored every vanilla row and logged equal
stock/published table identities, but the custom rows were still absent. The
paired failure shapes identify a second provider-contract rule: do not
revalidate host-certified DE tables through the borrowed module environment's
`type` global. Returning `{}` behind that guard erased stock rows; returning
`rows` behind the same guard preserved stock rows without running additions.
The host already rejects non-table `rows` and `query` values before dispatch.
Providers must therefore operate directly on those certified arguments. The
current Mallet addon is guardless; its visibility remains pending the next F9
transaction.

The guardless provider subsequently passed live: both addon rows appeared with
the stock rows and the base conversion displayed as 1%. Card augmentation is
therefore accepted. Gameplay still emitted no callback-installation or damage
event. The localization lookup on `sourceObject:GetType()` is rejected by that
negative evidence. Caching the accepted resource in an addon-local closure is
also rejected because F9 and region activation replace that closure.

The provider returns `sourceObject:GetType()` to C++. The host unwraps that DE
userdata and the card query's accepted Ability userdata through OpenWF's
versioned `TValue::getObject()` representation, then compares the resulting
engine objects. The native adapter's numeric callback argument is used directly
rather than rechecked with borrowed `type`.

Two distinct live failures established both required layers. Method-table
mutation entered no gameplay adapter and is rejected; direct native detours
then entered both packet methods but exposed that comparing the two VM-local
userdata wrapper addresses produced a false mismatch. Wrapper identity is
therefore rejected for every cross-VM object association. The current build
uses engine-object identity and logs both wrapper and engine addresses.
Engine-identity gameplay acceptance is **PENDING live**.

## 2026-08-25 engine-object live result and ObjectType correction

The engine-object candidate reached both native detours, but the decisive live
observation was:

```text
expected_object=000001DC120A4620
resolved=00007FF6C34FDB68
resolved_wrapper=000001DC0066EFC0
status=mismatch
```

This is not another cross-VM wrapper failure. The first value is the card
resource's engine `Object*` instance. The second is the native type descriptor
returned by gameplay's `sourceObject:GetType()`. OpenWF's ABI declares the
type descriptor separately as `Object::type`; object-instance and object-type
addresses are different categories and are not expected to match.

The successor removes the Lua resolver from gameplay routing. It unwraps the
card resource and the actual `SetSourceObject` argument to engine `Object*`
values, reads `Object::type` from both, and accepts ownership only when the two
non-null `ObjectType*` values are exactly equal. The historical
`damageSourceAbility` hook field remains accepted but ignored so old compiled
addons do not fail schema validation.

Offline status:

- native implementation and deterministic identity tests: **PASS**;
- complete staged Inject-directory validation: **PASS**;
- private x64 build: **PASS**, warnings=0, errors=0;
- unchanged addon: 8/8 exact DE roundtrip and 8/8 Semantic IR verified;
- staged DLL SHA-256:
  `0C003575F1C58248B68A7D08924EAC04B676EBBA042D2FA06B660E21BF09AADA`.

Exact native `ObjectType*` equality, callback attachment, and visible Overguard
are **PENDING live**. The current experimental implementation also learns the
expected type from a card query; removing that Arsenal-first prerequisite is a
separate generalization step after this ownership comparison is proven.

## Diagnostic extension arguments

The generic `afterDamage` contract keeps source ability and reported damage as
arguments 1 and 2. A diagnostics build may append callback argument 1, the
opaque damage-packet receiver, and a numeric correlation ID as arguments 3
through 5. Providers that need only the stable two-argument behavior require no
change. Diagnostic providers may use the appended values for observation but
must not infer target or ownership semantics from pointer identity alone.

## 2026-08-25 gameplay-predicate failure and module-owner correction

The later native event-bus build removed the Arsenal prerequisite and reached
`SetSourceObject` directly, while the already accepted card publisher continued
to show both addon rows. Gameplay still could not attach its callback because
the addon predicate threw on every attempt:

```text
RENOVICE hook callback FAIL label=matchesDamageSource pcall=2 error_tag=6
RENOVICE native hook PASS key=0 event=SetSourceObject.target.missing
```

The predicate treated `GetUniquePowerIdentifier()` as a string-compatible
object and called `:c_str()`. That assumption is retracted: the Round 5 native
API audit records an opaque unresolved return, the corpus contains no such
conversion, and the live VM rejects it.

The corrected generic association uses the base module rather than a card
resource or a spawned Mallet instance. Every target addon hook is rooted in the
exact environment borrowed from the natural target module. At the native
`SetSourceObject` boundary, the host reads that environment's `mOwner`, unwraps
it and the source argument to same-VM engine `Object*` values, and accepts only
exact non-null equality. This relation is grounded in stock BardMusic: it
directly compares suit abilities to `mOwner`, and its damage loop supplies the
Mallet entity creator to `SetSourceObject`.

The native relation runs before the addon-declared matcher. The matcher remains
a generic fallback and now uses the stock-semantic expression
`sourceAbility == mOwner`; it no longer invents a return type for a native API.
No instance enumeration, card timing, active-stack scan, polling, or cross-VM
wrapper equality participates in this path.

Offline status is fully green: exact-owner deterministic tests, injection core,
dependency and manifest gates, zero-warning x64 build, deterministic addon
recompile, 8/8 exact DE roundtrip, and 8/8 Semantic-IR verification. Live
acceptance is intentionally not claimed until owner match, callback install,
`afterDamage`, and visible Overguard appear in one gameplay session.

## 2026-09-09 Mallet cover-flag addon

Stock BardMusic explicitly sets `RadialDamageData.checkForCover = true` and
`staticCoverOnly = true` immediately before its sole verified
`Region:RadialDamage` call. The callsite inventory identifies that call as
prototype 16, instruction 576, with the packet at one-based `arguments[2]`.

The Mallet addon uses `nativeCalls.RadialDamage.before` at only that
prototype/instruction pair and changes both fields to false on the same packet.
The stock radial-damage call remains authoritative. This use of a `before` hook
does not restore the rejected V47/V48 batching design: it does not aggregate
damage, defer Overguard, or use native return timing as an effect boundary.
The runtime DLL remains the generic V61 build and contains no Mallet-specific
cover behavior. Offline package validation passes; behind-cover gameplay is a
separate live gate.
