# Reusable battle log V5 findings — 2026-09-14

## Goal

Record one exact combat transaction per target so ability changes can be
checked with engine inputs and immediate target state rather than inferred from
floating damage numbers.

## Hypothesis results

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| The existing full trace is sufficient as a practical battle log. | **False.** | The V72 Ice Wave session emitted thousands of routine `ADDON_TRACE` records but no addon combat records. Exact callbacks ran, yet the borrowed callback environment did not receive a usable host trace value. |
| A cached runtime-owned bridge value can be transported directly to target callbacks without a support addon. | **True offline.** | V74 builds the bridge in the exact VM, caches the verified closure TValue, appends it to callback arguments, rejects stale or nonclosure cached values, and passes the zero-warning x64 build plus injection policy tests. Live startup remains separate. |
| A quiet mode can preserve battle records without full hook chatter. | **True offline.** | Config and injection policy tests prove `battle` or `combat` installs the bridge, permits explicit trace formatting, suppresses routine successful runtime events, and retains exact failures. |
| All desired enemy fields can be named and read with equal confidence. | **False.** | Current armor is stock-proven as `DamageControl:GetArmourRating()`. Maximum armor has no proven getter. Life and ragdoll methods are cataloged but may be absent on a callback wrapper, so every read needs its own availability flag. |
| Raw damage can be equated to health removed. | **False.** | Native armor, resistances, attenuation, invulnerability, weak points, and other rules can intervene. V5 reports raw values and visible pool loss separately and does not label their difference as one specific hidden mechanic. |
| One transaction can safely describe a multi-target cast. | **False.** | The Ice Wave investigation proved that target-local state must be isolated. V5 creates one correlation for each exact target `DamageDD` call. |
| Diagnostics can remain completely dormant during ordinary play. | **True offline.** | With a nil host trace, `battleLogBegin` returns before all health, armor, status, damage-profile, life, and ragdoll reads; the working V73 gameplay path remains unchanged. |

## Exact stock armor evidence

The pinned raw stock body
`Lotus_Interface_PostCameraUpdateHud.raw.luau` obtains the target avatar's
`mDamageControl`, verifies it against `gLotusDamageControllerType`, then calls
`GetArmourRating()` with zero explicit arguments at line 9763. The detailed API
contract is recorded as `WF-STOCK-CURRENT-ARMOUR-RATING-2026-09-14`.

This proves the current armor getter and arity used by stock UI code. It does
not prove a maximum-armor getter or that armor alone explains the result of a
damage transaction.

## V5 event contract

A complete transaction has exactly nine records:
`BATTLE_TX_BEGIN`, `BATTLE_STATE_BEGIN`, `BATTLE_LIFE_BEGIN`,
`BATTLE_STATUS_BEGIN`, `BATTLE_DAMAGE_INPUT`, `BATTLE_STATE_END`,
`BATTLE_LIFE_END`, `BATTLE_STATUS_END`, and `BATTLE_MATH`.

The analyzer groups by process, VM, and correlation to prevent unrelated runs
from merging. Missing records remain visible as an incomplete transaction.
Status and damage-type indices stay numeric. Source and ability objects are
optional with explicit known flags.

## Verification

- private x64 V74 build: **PASS**, zero warnings and zero errors;
- config parser and runtime policy: **PASS**;
- Ice Wave live-alias and target-local harness: **PASS**;
- health, shields, Overguard, current armor, status, life, ragdoll, missing
  getter, and dormant-path fixtures: **PASS**;
- deterministic DE compile: **PASS**;
- exact self-roundtrip: **33/33**;
- Semantic Plan: **33/33**;
- Semantic IR: **33/33**;
- strict API: **30 calls, zero violations, zero unknowns**;
- Windows PowerShell 5.1 analyzer fixture: **PASS**, nine records and one
  complete transaction.

V74 deployment is **PASS**: exactly the runtime DLL, Ice Wave addon, and
diagnostic configuration match their candidate hashes. Bridge startup, real
`BATTLE_*` output, and in-game transaction values remain live acceptance gates.
