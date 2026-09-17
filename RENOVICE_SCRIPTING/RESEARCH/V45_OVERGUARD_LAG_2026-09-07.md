# V45 Overguard success and lag investigation

User confirms visible Overguard but severe lag. V45 process 14856; saved capture
`RENOVICE_DEPLOYMENTS/LUA_CALLBACK_ABI_V45_2026-09-07/captures/20260907-025858-171Z`.

| Hypothesis | Result |
|---|---|
| V45 installs and executes a genuine Lua damage callback. | TRUE live. Factory and protected setter succeed, then callback and addon return. User confirms Overguard. |
| V45 changed the damage conversion formula from the earlier working addon. | FALSE in reviewed source. Actual reflected damage times Strength-modified 1 percent, capped at 5 percent; Overguard cap 15,000. |
| Every native callback represents positive damage. | FALSE. First captured 1,333 callbacks include 1,188 zero results and 145 positive results. |
| Repeated diagnostic writes occur in the gameplay path. | TRUE. 8,193 trace records reach the budget in approximately eight seconds. Each config::log opens the file, makes two synchronous WriteFile calls, and closes it. |
| Threat dispatch targets the correct resource. | FALSE live. 158 EE.log errors report failed SetThreatLevel activation against /Lotus/Powersuits/Bard/OctaviaPrime. |
| The old addon issued threat commands for each enemy hit. | FALSE. Earlier stock-derived code changed threat only when its requested level changed. V45 requested it on every positive callback. |
| There is duplicate provider dispatch per native callback in this captured interval. | No evidence. The captured callbacks each have one provider and one dispatch return; this does not exclude duplication elsewhere after trace suppression. |
| These measured inefficiencies explain all reported lag. | UNPROVEN. V45 did not measure callback duration; logging stopped at its cap but other work continued. V46 adds timing summaries to locate any remaining cost. |

Stock source evidence in
`RENOVICE_DEPLOYMENTS/NATIVE_HOOK_BUS_MALLET_POC_2026-08-24/verification/stock_BardMusic.verifier-render.luau`:
SpawnBox lines 902/912 obtains the active suit then GetAbilityByIndex(0).
BoxLoop lines 1969-1970 captures mOwner:GetType, and lines 2493-2496 supplies
that ability type to the creator's ActivateSecondaryScript. Source:GetType
instead identifies the suit, as confirmed by the failing EE.log resource path.

V46 changes: sampled callback/source details, unsampled error and two-second
host timing/count summaries; immutable provider lists built at generation
publication instead of copying/sorting/locking per damage event. Every damage
event still dispatches, including zero. Existing two-argument addons continue
working; an optional third opaque registration token lets an addon group
results from one installed damage callback without retaining its packet.

Mallet's standalone addon selects and verifies ability slot 0, uses its type
for threat dispatch, and requests threat 5 once per batch per source suit.
The conversion formula, cap and card values are unchanged. The old replacement
had a stronger stock-loop threat override; V46 does not claim identical timing
or permanent threat 5 until the live native behavior is checked.

Validation: actual addon code executed against mocks for numeric conversion,
Strength and Overguard caps, notifications, zero/negative/null input, type
selection, batching, caster isolation, and card rows. These are offline tests,
not engine behavior proof. Callback policy tests preserve initial positive
evidence and aggregate all events while sampling details. DLL builds without
warnings/errors. Source reproduction, 8/8 DE roundtrip, Semantic IR and strict
API checks pass. Runtime cost reductions and threat behavior need live testing.
