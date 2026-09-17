# Script Type And Clear Names V17
Date: 2026-08-28

## Scope

This revision changes only how scripts are named in the native `SCRIPTS` menu.
It does not rename files, change stable script IDs, retarget replacements, alter
addon callbacks, or change the requested enable policy.

## Hypotheses and results

### H1: Physical script files must be renamed to improve the menu

**Result: FALSE.**

The loader uses filenames and lower-cased, kind-prefixed stable IDs as script
identity. Renaming those files would make an unnecessary functional change.
The menu already has a presentation-only alias layer, so clearer names belong
there.

### H2: Addons and replacements can be distinguished without changing behavior

**Result: TRUE.**

The native row label now uses a visible type prefix generated from the existing
`Kind` value:

- `[ADDON]` for ordinary and target-specific addons
- `[REPLACEMENT]` for target replacements
- `[ONE-SHOT]` for one-shot injected scripts

`TARGET ADDON` remains available in the detailed tooltip. The shorter visible
type answers the player-facing question without exposing loader jargon.

### H3: The five current script names can be made clear without changing identity

**Result: TRUE.**

The presentation aliases are:

- `[ADDON] Mallet: Overguard and Ability Card`
- `[REPLACEMENT] Mallet: Enables Addon Hooks`
- `[REPLACEMENT] Octavia Amp: No Range Limit`
- `[REPLACEMENT] Riven Rerolls: Stat Locks`
- `[REPLACEMENT] Octavia Metronome: All Rhythm Buffs`

The original filenames and stable IDs remain unchanged.

### H4: The SCRIPTS menu scans and rebuilds its rows every frame while closed

**Result: FALSE.**

The folder snapshot is requested when the Generic Settings submenu asks for
its elements, when a checkbox change is validated, and when a confirmed batch
is validated. Closing the submenu does not leave a row-builder or directory
scanner running every frame.

### H5: No RENOVICE infrastructure runs continuously when the menu is closed

**Result: FALSE.**

The broader runtime still owns global VM-execution and HUD-update integration
points. Those are separate from the SCRIPTS directory scan and native row
construction. Their possible overhead is documented in
`RENOVICE_SCRIPTING/RESEARCH/RUNTIME_PERFORMANCE_AUDIT_2026-08-28.md` and must
be optimized with behavior-preserving equivalence tests.

## Behavior-preservation rule

Performance work is accepted only when the same script targets, callbacks,
state transitions, values, save policy, and visible results are preserved.
Reducing scans, logging, lock contention, or unnecessary dispatch work is in
scope; changing Overguard math, Octavia buffs, Riven behavior, or replacement
semantics is not.
