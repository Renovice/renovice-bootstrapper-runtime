# Script Display Name Standard V16

Date: 2026-08-27

## Scope

Standardize the five player-facing names in Esc -> SCRIPTS without renaming a
script file, changing a stable script ID, changing its kind, or modifying its
persisted enabled state.

## Hypotheses and results

| Hypothesis | Result | Evidence |
|---|---|---|
| The visible row name is independent metadata | **FALSE** | `injection.cpp` calls `script_control::display_name(script.filename)` for every row. |
| Renaming the files is required | **FALSE** | The renderer accepts an arbitrary presentation label after inventory discovery. |
| Renaming files would be behavior-neutral | **FALSE** | Stable state IDs include the lower-cased filename, so a rename could orphan the existing `ScriptStates.json` selection and may disturb loader conventions. |
| A presentation-only alias layer is sufficient | **TRUE** | `canonical_display_name` runs only after suffix/key cleanup and never feeds loader identity or state persistence. |
| Unknown future scripts still need automatic names | **TRUE** | Names without a canonical alias retain the existing generic filename normalization. |

## Canonical labels

| Existing generated label | V16 label |
|---|---|
| `Mallet Overguard And Card` | `Mallet: Overguard and Ability Card` |
| `Mallet Explicit Hook Shim Threat5` | `Mallet: Explicit Hook Shim (Threat 5)` |
| `Octavia Amp Buff No Distance` | `Octavia Amp: No Distance Limit` |
| `Riven Lock Script` | `Riven Lock` |
| `Octavia Metrone Allscript` | `Octavia Metronome: All-in-One` |

The convention is ASCII `Feature: Description`, sentence-style conjunctions,
separated revision numbers, no redundant `Script` suffix, and corrected legacy
spelling. ASCII punctuation avoids relying on an unproven Unicode conversion
path in the native menu bridge.

## Verification

- All five exact legacy filenames map to their canonical labels: **PASS**.
- Uppercase and camel-case target-addon spellings map identically: **PASS**.
- An unknown future addon still receives generic normalization: **PASS**.
- Focused Scripts UI suite: **PASS, 59 checks**.
- Private x64 build: **PASS, zero warnings and zero errors**.
- The focused API check reports zero violations. Its three pre-existing catalog
  gaps are `Close`, `Execute`, and `PushChildMovie`; none was added or modified
  by V16, and all are already live-exercised by the accepted native menu.

## Conclusion

The display names can be standardized without mutating script identity. The
alias layer is the safe boundary: presentation changes while discovery,
loading, state persistence, and current switch values remain unchanged.
