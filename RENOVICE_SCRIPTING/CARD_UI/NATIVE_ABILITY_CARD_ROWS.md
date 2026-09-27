# Native ability-card rows — non-negotiable editor contract

## Current production contract, 2026-09-16

The universal native RunScript result adapter is implemented. Production target
addons declare matchesAbility and afterAbilityCard, append ordinary rows to the
exact stock array in the same UI VM, return that array and receive readback
verification before stock RunScript returns. Mallet addon rows are live-proven;
Ice Wave V91 extends the same mechanism and is built/installed, with fresh card
rendering pending. The August cached-environment/decorator/global registry
experiments below are rejected historical evidence, not current architecture.
See [current recipe and evidence](../../../../../Documentation/02-API-and-Addons/Native-Ability-Card-Extensions-2026-09-16.md)
and NATIVE_TARGET_ADDON_HOOKS.md for the production bus contract.

Card generation is owned by registry membership, not a cached gameplay active
flag. Preserve the native array, stock row references, native behavior/metatable
and Modded flag. New values use the current query.Avatar; never a cached mission
caster. One authored base and verified modifier helper drive card and gameplay.
Ice Wave's additional multiplier is per existing Cold stack, base1x and at300%
Strength3x, giving total1+6*3=19x for six stacks. The shared operation10 unit
ModifyValue helper feeds both consumers; stock damage keeps vanilla scaling.

Exact Ice Wave tag is IceWaveAbilityName/Desc, despite IceSpike.lua's filename.
UNIT_MULTIPLIER is proven in stock BardMusic's native card row. Literal new
labels are supported; CAT replacement overrides an existing description key
but does not register arbitrary new localization paths. The CAT map is cached
at OpenWF label-module initialization: restart for description changes; DE F9
addon reload alone does not reload that independent map. Source-before snapshot
is retained at RESEARCH/NATIVE_ABILITY_CARD_ROWS_PRE_V91_2026-09-16.md.

## User intent

> **2026-08-24 architecture correction.** Direct rows in a full BardMusic
> replacement remain live-proven. The later cached-environment target-addon
> decorator is now live-refuted: it produced neither rows nor gameplay. The
> actual UI pipeline and corrected same-state `RunScript` result-adapter design
> are authoritative in
> `DeNativeDecompiler (use this instead of native)/RESEARCH/ABILITY CARD UI/PIPELINE_AUDIT_2026-08-24/ACTUAL_CARD_PIPELINE.md`.

The editor does not invent custom UI elements. It adds ordinary native entries
to the bottom stat list Warframe already renders beneath the ability
description. These are the same native rows used for Drain, Damage Multiplier,
Radius, Duration, and other stock ability statistics.

For Mallet the requested result is conceptually:

```text
Drain                              25
Damage Multiplier                2.5x
Radius                            10m
Duration                      20 -> 32s
Overguard Cap                   15000
Overguard From Damage              1%  (base; Strength-scaled, cap 5%)
```

## Authoritative producer

Each ability module owns `GetAbilityUpgradeLevelInfo`. It reads
`_T.AbilityLevelQueryParms`, creates a row array, sets the array's `Modded`
member, and publishes it as `_T.AbilityUpgradeLevelInfo`.

The editor must ensure additional native row tables are inserted into that
array. It can do this through a native replacement or the implemented
target-keyed addon afterAbilityCard callback in the same UI VM after the stock
producer runs. Supported stock fields are:

| Field | Purpose |
|---|---|
| `Label` | Left-hand text. Existing game localization paths work; literal text is the current supported form for new RENOVICE labels. |
| `Value` | Current base or modded numeric/string value. |
| `ValueUnit` | Existing native unit localization path such as percent, meter, second, or multiplier. |
| `ValueIcon` | Optional existing native inline icon token. |

No RENOVICE-specific bookkeeping field should be passed to the UI array.

## Custom-label localization boundary

Live testing proved that adding a new path to `Label Replacements.cat.txt` does
not register that path in the game's localization database. A row whose label
was `/Renovice/AbilityStats/OverguardCap` rendered the normalized unresolved
path `/Renovice/Abilitystats/Overguardcap`. The replacement callback can
override an existing game key, as it does for Mallet's description, but it does
not make an unknown key resolvable.

Until the bootstrapper has an explicit custom-key registration layer, newly
authored native rows must use clean literal labels such as `Overguard Cap` and
`Overguard From Damage`. Existing `/Lotus/...` label and unit keys
remain appropriate where the game already defines them. Do not emit a new
`/Renovice/...` path and assume the CAT replacement file registers it.

## Current F9 behavior — live proven

The old environment-reexecution model is retired. Exact U43 disassembly proved
that descriptor `+0x58` is not a module environment and is not read by the
current loader. RENOVICE now retains each replacement's original native
descriptor and supplies changed bytecode through that same descriptor at its
owning manager/VM/thread boundary. Warframe's loader then refreshes the existing
gameplay and UI objects itself.

This path is live proven. In one running client, F9 changed Mallet's already
loaded native card row twice without a restart:

1. `Overguard Damage Gain = 10%` to `Damage To Overguard = 1%`;
2. `Damage To Overguard` to `Overguard From Damage`.

Both changed-module transactions recorded native refresh PASS, one VM-local
delivery, zero failures, zero pending work, and a committed module-refresh
PASS. A card redraw displayed the new module both times. Active yielded
functions may still
finish on their old generation; native refresh governs existing module objects
and subsequent calls, not time travel inside a currently executing closure.

## Single source of truth for scaling

The editor must not maintain unrelated gameplay and card numbers. Each custom
stat has one definition containing:

1. stable stat ID;
2. base value;
3. mod-affinity rule (`NONE`, `STRENGTH`, `DURATION`, `RANGE`, `EFFICIENCY`, or
   an explicit custom formula);
4. gameplay expression;
5. native card-row expression;
6. label, unit, icon, rounding, and row order.

The generated gameplay code and `GetAbilityUpgradeLevelInfo` code derive from
that same definition. Consequently:

- base-card mode displays the base value;
- modded-card mode displays the actual gameplay value after applicable mods;
- a stat configured as `NONE` remains identical in both modes;
- the UI never reports scaling that gameplay does not implement;
- changing a value in the future editor updates both consumers together.

For current Mallet behavior, the base Overguard cap is `15000` and uses the
stock Strength modifier in both card and gameplay. Damage conversion is stored canonically as the fraction `0.01`,
uses the stock Mallet Strength-affinity path, and clamps after modification to
`0.05`. The card multiplies the fraction by 100 only at its percent-display
boundary. Gameplay consumes the fraction directly.

## Canonical DE normalization and scaling recipe

### 1. Normalize the authored value once

Store values in the units gameplay actually consumes:

| Kind | Canonical authored value | Native row boundary |
|---|---:|---:|
| Percentage/fraction | `0.01` for one percent | multiply by `100`, use `UNIT_PERCENT` |
| Duration | seconds | numeric seconds, use `UNIT_SECOND` |
| Radius/range | meters | numeric meters, use `UNIT_METER` |
| Multiplier | raw multiplier such as `2.5` | numeric multiplier, use the stock multiplier unit/icon |
| Cap/count/flat amount | raw amount such as `15000` | same number unless the design explicitly gives it mod affinity |

Do not store `1` as both “one percent” and “one raw unit.” Do not pre-format a
number into a string merely to add `%`, `m`, or `s`; give the renderer a numeric
`Value` and an existing native `ValueUnit`. This lets Warframe retain its own
locale formatting, comparison arrows, and green/red modded presentation.

### 2. Build an `Engine.UpgradedValue` from the base

Mallet's live-proven Strength-scaled conversion uses:

```lua
local OVERGUARD_CAP = 15000
local DAMAGE_TO_OVERGUARD_BASE = 0.01
local DAMAGE_TO_OVERGUARD_CAP = 0.05

local function getDamageToOverguardFraction(avatar)
    local value = Engine.UpgradedValue(DAMAGE_TO_OVERGUARD_BASE)

    if not IsNull(avatar) then
        local inventory = avatar:InventoryControl()
        local suit = inventory:GetActivePowerSuit()

        if not IsNull(suit) then
            inventory:ModifyValue(value, 10, suit:GetType(), suit)
        end
    end

    return math.min(
        DAMAGE_TO_OVERGUARD_CAP,
        math.max(0, value:GetModifiedValue())
    )
end
```

The modifier selector `10` is evidence-backed for this Mallet Strength path:
the stock module uses the same `ModifyValue(..., 10, suit:GetType(), suit)`
shape for its native damage multiplier. It must **not** be copied blindly into
Duration, Range, Efficiency, or another ability. For a new stat, reuse a stock
modifier path from the same ability or another verified equivalent. If no
evidence-backed path exists, mark the stat affinity `NONE` until it is known.

### 3. Use the same helper in gameplay

Compute the modified fraction from the real caster/avatar and capture that
value for the actual damage callback:

```lua
local caster = malletCaster
local fraction = getDamageToOverguardFraction(caster)

damageData:SetDamageCallback(function(_, actualDamage)
    if type(actualDamage) ~= "number" or actualDamage <= 0 then
        return
    end

    local granted = actualDamage * fraction
    local newAmount = math.min(
        OVERGUARD_CAP,
        damageControl:GetOverguardAmount() + granted
    )
    -- Apply the delta through the verified DamageControl/notification path.
end)
```

Apply the cap after mod scaling and after calculating the gameplay result. Do
not separately multiply by Strength in Lua after `ModifyValue`; that would
double-apply the modifier.

### 4. Respect DE's base-versus-modded card query

`GetAbilityUpgradeLevelInfo` receives its UI context through
`_T.AbilityLevelQueryParms`:

```lua
local query = _T.AbilityLevelQueryParms
local percent = DAMAGE_TO_OVERGUARD_BASE * 100

if query.Modded == true then
    percent = getDamageToOverguardFraction(query.Avatar) * 100
end

table.insert(rows, {
    Label = "Overguard From Damage",
    Value = percent,
    ValueUnit = "/Lotus/Language/Game/UNIT_PERCENT",
})

rows.Modded = query.Modded
_T.AbilityUpgradeLevelInfo = rows
```

This is DE's native presentation contract:

- `Modded == false` or **Show Base Stats** displays the authored base (`1%`);
- `Modded == true` obtains the Avatar/suit and displays the same modified value
  gameplay uses;
- the conversion is capped at `5%` after modifiers;
- `rows.Modded` tells the native UI which comparison presentation is active;
- assigning the completed array to `_T.AbilityUpgradeLevelInfo` publishes it.

Do not mutate `_T.AbilityLevelQueryParms`, and do not use a gameplay caster
captured from an old mission inside the Arsenal query. The card must use the
query's current `Avatar`.

### 5. Prefer existing computed stock values when available

If `GetAbilityUpgradeLevelInfo` already computes the ability's modded Radius,
Duration, Strength result, or multiplier, insert the custom row using that
existing value instead of independently recreating the modifier formula. This
preserves augments, special upgrade rules, Helminth adjustments, and any
ability-specific normalization already owned by DE.

Only introduce a new `Engine.UpgradedValue` helper when the new gameplay stat
also uses that helper. UI-only scaling is forbidden because the card would
advertise behavior the ability does not perform.

### 6. Formatting and label rules

- Keep `Value` numeric whenever the stock renderer can format it.
- Use existing `/Lotus/Language/Game/UNIT_*` paths for units.
- Use an existing `ValueIcon` only when its meaning matches.
- Use literal labels for new RENOVICE rows until custom localization-key
  registration exists. `Label Replacements.cat.txt` can override an existing
  key but cannot register an unknown `/Renovice/...` key.
- Keep the upper description colloquial and number-free; exact values belong
  in native rows.
- Choose short labels that fit the stock card. `Overguard From Damage` is the
  current live-proven Mallet label.

### 7. Required validation

For each authored stat:

1. source recompiles and reparses;
2. `plan-verify` has zero failures for every prototype;
3. `de-roundtrip` reports an identical full body;
4. focused API checking reports zero violations in the intentional edit;
5. base card shows the base value;
6. modded card shows the expected changed value;
7. the gameplay result changes by the same factor and respects the same cap;
8. F9 reports native module refresh PASS, zero failures, and zero pending work;
9. one adjacent stock row and one normal cast still work.

The current Mallet label and full-module F9 path are **TRUE LIVE**. The exact
Power Strength value progression still requires an explicit in-game modded
versus base-stat comparison before it should be labeled live-certified rather
than implementation-verified.

## Rejected experiment and proposed infrastructure conclusion — August history

The first experiment installed `_T.RENOVICE_AUGMENT_ABILITY_CARD` through a
managed Inject addon and called it from the ability module. F9 reported
`addons=1` and `module_refresh=PASS`, but the live screenshot showed only the
four original bottom rows. The description changed because it uses the separate
localization system; the expected addon-generated stat row did not appear.

Therefore:

- Do not cache `_T` during early target-addon activation. Warframe can rebind
  the table before a later ability-card or gameplay instance uses the module.
- Direct `RENOVICE_*` bridge symbols in a borrowed module environment were also
  insufficient in the live POC: neither gameplay nor card behavior appeared.
  That hypothesis is rejected, not retained as the production design.
- The later cached-environment/root-export decorator is also rejected. Its
  target/addon loads passed, but it produced neither gameplay nor card output.
  Module loading and cached-export ownership are not the card query boundary.

- a cross-VM/global addon registry is not the ability-card architecture;
- `AbilityCards.addon.luau` is rejected evidence, not a production API;
- at the time of this August experiment, direct insertion in the ability's
  `GetAbilityUpgradeLevelInfo` was the only live-proven path;
- this failure does **not** prove that addon-owned rows are impossible;
- the actual central builder calls `avatar:RunScript(script,
  GetAbilityUpgradeLevelInfo, true)` twice and immediately reads
  `_T.AbilityUpgradeLevelInfo` in that same UI state;
- the proposed addon bridge therefore wraps the real native/SWIG `RunScript`
  transaction: inspect the current query, call stock, append validated addon
  rows to the result in the same state, then return to the stock builder;
- the provider must emit identical row IDs/order for base and modded queries;
- the bridge must commit/remove providers transactionally on F9, preserve the
  stock result on any failure, and perform no polling or instance scanning;
- **Historical August status:** the corrected bridge was then only an audited
  proposal and direct native projection was the compatibility path. This is
  superseded by the current production contract at the top of this file: the
  same-VM RunScript result adapter is implemented, Mallet is live-proven on it,
  and Ice Wave uses the same mechanism with fresh rendering tracked separately.

## Description remains separate

The paragraph above the native stat list is metadata/localization driven. The
editor changes it through the ability's `LocalizeDescTag` and OpenWF label
replacement data. It must not place numeric stat information in the paragraph
as a substitute for native rows.

Mallet's current description therefore explains the behavior colloquially and
leaves the exact `15000` cap and `1%` base-to-`5%` modified conversion
exclusively in the native rows:

> Rhythmically beats reflected damage into nearby enemies and draws their
> fire. Its reflected damage reinforces Octavia with Overguard.
