# Script switch apply-on-close V34 - 2026-09-04

## Live evidence from V33

The target-add-on and replacement reload paths are working. The live log showed
Mallet target-addon generations changing between `addons=0` and `addons=1`, and
Amp switching between stock and replacement with `native module refresh PASS`.
Every reported retry instead correlated with a changed checkbox followed by
`flag_tag=1 decision=cancel`; that path discarded the staged batch before any
reload request existed.

## Hypothesis results

| Hypothesis | Evidence | Result |
|---|---|---|
| The Mallet target-addon loader randomly fails. | Accepted closes immediately produced the requested target generation and `TARGET ADDON PASS`. | **False live.** |
| The replacement refresher randomly loses Amp or Metronome. | Accepted closes immediately produced stock/replacement native module refresh passes. | **False live at delivery.** |
| Generic Settings sometimes dismisses the child through its true/ExitScreen route after a real checkbox edit. | The missed attempts logged a valid staged edit immediately followed by `decision=cancel`; retrying produced nil/Confirm and committed. | **True live.** |
| Amp's active secondary loop is rewritten when its module registration refreshes. | Stock and replacement are the same 13,181-byte module except for one byte at file offset `0x21E8`, changing one branch operand in `AmplifierLoop`. An already-running closure retains the old prototype. | **False structurally.** |

## Shared correction

The checkbox UI remains transactional: row clicks only stage changes and one
close applies the whole batch. A nonempty valid batch now commits through
either recognized Generic Settings close route. Empty closes do nothing;
malformed callback shapes still reject and clear staging. This avoids Lua/VM
reload work while the child movie is open and removes the ambiguous route that
made switches snap back or require two attempts.

## Amp lifecycle boundary

The Amp replacement is not missing from the module map. The current replacement
changes exactly one `AmplifierLoop` branch operand; native refresh changes which
prototype future loop instances receive. A loop already running on an existing
Amp entity cannot have its instruction pointer/prototype rewritten safely.
Recast after the prior Amp expires, or respawn/reload the mission object. A
future universal active-instance hook would need an explicit engine lifecycle
event and cleanup contract; it must not be implemented as Amp-specific
bootstrapper code.

## Offline validation

- migration manifest and dependency gates: pass before editing;
- SCRIPTS UI core: 74/74 pass, including both recognized close routes, empty
  closes, and malformed completion rejection;
- internal bridge compile/reparse, byte-exact roundtrip, ownership plan,
  Semantic IR, and API contract checks: pass;
- safe-runtime tick source gate: pass;
- full private x64 build: pass with zero warnings and zero errors;
- V34 DLL: 4,391,424 bytes, SHA-256
  `DE997709FBB54795318AF5EA33AEA14C9AEE7161EFDFC365A5D66CCE44934C34`;
- deployment to the correct stopped OneDrive game folder: pass;
- V33 DLL and bridge preserved together as the V34 rollback pair;
- same-process live toggle and search acceptance: pending user test.
