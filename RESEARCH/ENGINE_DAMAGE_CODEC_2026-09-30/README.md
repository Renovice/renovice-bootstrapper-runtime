# ENGINE_DAMAGE per-build codec and layout (44.0.2), 2026-09-30

Branch `fix/engine-damage-codec-44.0.2-2026-09-30`, from `fb9655e` (staged R2 DLL `7594fbf2…`).
Spec: `work/temp/ability-editor-settings-consumer/RESEARCH/MALLET_OVERGUARD_PROPORTIONALITY_2026-09-30/README.md` section 4.
Offline only: no game-folder write, no deploy, no push. The installed 44.0.2 executable was read, never written.

## Defect (from the Mallet note, live pid 15124)

8,069/8,069 `ENGINE_DAMAGE` end records on 44.0.2 (9 target types) had null health/shield/Overguard before
and after, and a garbage `ObservedRaw`. `engine_damage.cpp` had 44.0.x handler RVAs but kept the U43 accessor
key `0xC55198A3`, the U43 float codec `rol30 / 0x635BF253` and the U43 slots. The integer accessor shape check
therefore always failed (null pools) and the float decode was applied blindly with the stale key (garbage).
The 44.0.0 registration had the same stale values.

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| H1 | 44.0.x integer fields (health, shield, Overguard) use `rol 19 / 0xAC7E8740`. | **TRUE** | 25 exact accessors (`add rcx,imm; mov eax,[rcx]; rol eax,19; sar rcx,3; xor eax,ecx; xor eax,0xAC7E8740; ret`) in each 44.0.x image, and 25 with the U43 key in 43. The accessors at the registered slots of every DamageControl vtable and of 126 avatar vtables use it. 0 U43-key accessors in 44.0.x. |
| H2 | 44.0.x float fields use `rol 17 / 0x8637D1B6`. | **TRUE** (with a correction) | The UpgradedValue evaluator that handler0 calls on `packet+0x60` (44.0.2 `0xaab090`, 44.0.0 `0xb6f850`) decodes with `rol ecx,0x11; …; xor ecx,0x8637D1B6`. **The rotate changed too**: U43 used `rol 30` (`0x1876bb0`), so a key-only fix would still have produced garbage. |
| H3 | The U43 slots still apply on 44.0.x. | **FALSE** | Lua bindings: 44.0.x `GetHealth` → `call [rdx+0x350]`, `GetShield` → `[rdx+0x2c8]`, `GetOverguardAmount` → `[rdx+0x338]` (43: `0x340 / 0x2b8 / 0x328`). The bindings were found by their name hash (seed `0x768E5ED0` for 44, `0x7E5AF8E9` for 43). |
| H4 | The other layout values (`control+0x28`, packet `+0x60` UpgradedValue with `+0x0c/+0x14/+0x24/+0x30`, flag `0x20`, fractions at `+0`) carried over from U43 are still right. | **TRUE** | handler0 (`0x7267c0`): `mov r12,rcx`, `mov r14,rdx`, `mov rcx,[r12+0x28]` → virtual call, `lea rcx,[r14+0x60]; call 0xaab090`, five `movups [r14+0x00..0x40]` (20 floats), pointer at `+0x50`. The evaluator reads flags `+0x30`, override flag `0x10` → `+0x20`, cached flag `0x20` → `+0x24`, encoded `+0x0c`, addition `+0x14`. Same in 43 and 44.0.0. |
| H5 | The old `base_amount` matched the evaluator. | **PARTIALLY TRUE** | The evaluator also has an override flag `0x10` that returns `+0x20` whole. The old observer ignored it. It now reports `ObservedRaw:null` with `RawReason:"value-override-flag-set"` in that case, never the base. |

Field offsets read by the accessors (for reference, not registered: the observer reads them from the accessor
itself). 44.0.x DamageControl shield `+0x1e54`, Overguard `+0x1ea4` (43: `+0x1e34`, `+0x1e84`). Avatar health
by class: `+0x50c` (62 vtables), `+0x68c` (31), `+0xba4` (29), `+0xa04` (3), `+0x4bc` (1).

Full derivation per image: `evidence/layout_derivation.json` (`tools/derive_engine_damage_layout.py`, capstone +
pefile, read-only; exit 0 = every value derived from game code equals the production registration).

| Build | Digests | Handlers | Evaluator | Integer codec | Float codec | Health / shield / Overguard slots |
|---|---|---|---|---|---|---|
| 43 2026.08.19.11.06 | `cca46d60…` | `1ee140 c60240 a255b0` | `1876bb0` | rol19 / `C55198A3` | rol30 / `635BF253` | `340 / 2b8 / 328` |
| 44.0.0 2026.09.24.13.29 | `45fa6ad0…`, `87fc60ce…` | `d2cb0 a10cf0 7088a0` | `b6f850` | rol19 / `AC7E8740` | rol17 / `8637D1B6` | `350 / 2c8 / 338` |
| 44.0.2 2026.09.28.13.06 | `00cf8761…`, `0124f0b9…` | `7267c0 fb24b0 1f5d80` | `aab090` | rol19 / `AC7E8740` | rol17 / `8637D1B6` | `350 / 2c8 / 338` |

Images checked: 43 `work/native-analysis/inputs/wf-2026.08.19.11.06-cca46d60`, 44.0.0 Steam copy
`work/research/U44-2026-09-27/client-before`, 44.0.2 installed sideloadified `0124f0b9…`. The 44.0.0
sideloadified and 44.0.2 Steam digests share code with the checked images (Sideloadify 1.1.0); they were not
hashed here.

## Implementation

- `renovice/engine_damage_builds.hpp` (new): one `BuildRegistration` per exact build with digests, handler RVAs,
  evaluator RVA, integer and float codec (rotate + key) and every layout value. No default entry and no
  fallback: an unknown digest installs nothing (unchanged). Also the exact accessor and evaluator byte shapes
  and `admit_codec()`.
- `engine_damage_core.hpp`: `decode_integer`/`decode_float` take the registered codec; no built-in key.
- `engine_damage.cpp`:
  - every read uses the running build's layout and codec;
  - per read, the accessor at the slot must match the registered codec byte for byte, else null plus a reason
    (`accessor-shape-mismatch`, `accessor-unreadable`, `field-unreadable`, …);
  - at `install()`, `admit_codec()` checks the loaded image. An exact registered-codec integer accessor must
    exist, and the evaluator at the registered RVA must match the registered float codec and layout. On
    failure it logs one line, `RENOVICE ENGINE_DAMAGE build=V80 event=degraded reason=<…> layout="<build>"
    decoded-fields=null records=kept`, and every decoded field is null with that reason. Correlation, target,
    source, fractions and the hooks are kept;
  - records carry `"Build":"V82-codec"`, `"Layout"`, `"RawReason"`, `"HealthReason"`, `"ShieldReason"` and
    `"OverguardReason"` (null when the value decoded). The install line reports `layout=` and `codec=`.
- `AnalyzeCombatBattleLog.ps1` passes the new fields through as `DecodeLayout`, `RawReason`, `HealthReason`,
  `ShieldReason` and `OverguardReason` (null for older records).

### Per-hit addon results (spec items 6 and 7)

- `dispatch.results` (afterDamage only) has its own lane in `trace_addon`:
  - its own limiter, 1,024 lines per second instead of the generic 32 per event per second;
  - its own event budget, `DiagnosticsMaxEvents`, separate from the shared trace budget;
  - one `trace.rate-limited … lane=hit-results` summary per window that dropped lines, and one
    `trace.suppressed reason=hit-result-budget-exhausted`;
  - it resets at the same three F9 and bridge boundaries as the shared budget.
- **`DiagnosticsMode=battle` now emits `dispatch.results`.** The per-hit addon value is battle data. Trace mode
  adds every other dispatch, native and Lua line, which the measurement does not need and which competes for
  the shared budget. Errors and off modes emit none, and `Diagnostics=false` still formats nothing.
- Callback result capacity and the traced result count go from 8 to 12 (bounded). An addon can return, for
  example, `overguardBefore` and `overguardAfter` as results 8 and 9. The Mallet addon itself is unchanged;
  returning those values is an addon-source change.

## Regression gates (all PASS)

- `RENOVICE_TOOLCHAIN/diagnostics/verify_engine_damage_codec.ps1` (new, in `build_private.ps1`): the offline
  key-presence check per registered build. For each image it matches the digest to its registration, then
  checks:
  - the production `admit_codec()` passes;
  - the registered keys occur, and there are 0 accessors with any other registered integer codec;
  - all 29 DamageControl vtables that hold handler0 at `+0xf8` have registered-codec accessors at the shield
    and Overguard slots;
  - registered-codec accessors exist at the health slot (125 vtables in 43, 126 in 44.x).

  Every registration must be covered by an image, or the gate fails. Result: covered 3/3.
- Negative control (`tools/negative_control_prefix_registration.ps1`, `evidence/codec_gate_negative_control.txt`):
  the pre-fix values on the 44.0.2 image fail every check (exit 1).
- `verify_native_damage.ps1` (now long-path safe and in `build_private.ps1`): the harness check that decoded
  samples match expected values.
  - Known-answer vectors were computed independently in Python. The 44.0.2 integer codec decodes `0xa5e76646`
    at `0x21cf2593d5c` to 36816, and the float codec decodes `0x530eae73` to 1234.5. The stale U43 codec does
    not.
  - For every registered build it runs the production observer on a fixture built with that build's accessor
    bytes, slots and field offsets. Health goes 1000 → 867 (−133), shield stays 250, Overguard goes
    36816 → 36776 (−40), `VisiblePoolLoss` is 173 and the encoded raw is 502.5, all with null reasons.
  - It also covers the override flag, `admit_codec()` on a synthetic 44.0.2 image (U43 is refused with exact
    reasons, and a one-bit key change fails), degraded records and the per-read accessor mismatch.
  - The 44.0.2 records survive the analyzer round trip.
- `verify_injection_core.ps1`:
  - per-build decode;
  - the 44.0.2 registration values, with no fallback for an unknown or empty digest;
  - `dispatch.results` is admitted in battle and trace but not in errors or off;
  - the hit-result limiter bound and its summary;
  - a Mallet-rate run (40 hits per beat, 2 beats per second) loses none.
- `verify_unified_diagnostics_master.ps1`: the hit-result lane is rate-limited before its own budget and is reset
  at all 3 boundaries.
- `verify_battle_log_analyzer.ps1`: all 23 existing analyzer cases and 5 summaries PASS, unchanged.

## Build and staging

- `build_private.ps1`: 31/31 gates PASS (29 before, plus `verify_native_damage.ps1` and
  `verify_engine_damage_codec.ps1`). `PRIVATE BUILD PASS flavor=main warnings=0 errors=0`.
- Main DLL `9e44f885ab891eb76273cc4162129ab69ab481b20dbc6d081d8dc3df23cf3aab`, 5,601,280 B.
- SCRIPT SETTINGS bridge rebuilt byte-identical: `2e337a43…`, 5,441 B.
- Staged in `work/staging/editor-phase2-3/`; the previous R2 set `7594fbf2…` is in `older/r2-7594fbf2/`.
- Evidence: `evidence/codec_gate_pass.txt` and `evidence/harness_and_build_summary.txt`.
- Per the repository `.gitignore`, only this README is tracked. `tools/` and `evidence/` stay beside it on
  disk and are copied into the staging `evidence/` folder.

## Limits and pending live checks

- Static evidence: exact-image disassembly plus a fixture harness. **No live 44.0.2 record has been decoded yet.**
- **Live acceptance check (required):** for one hit on a non-lethal enemy target, the native slot-0 end record
  must satisfy `HealthLoss + ShieldLoss + OverguardLoss` = that hit's addon-reported damage (Mallet
  `dispatch.results` `result3`, same target and burst). Also check `Layout:"44.0.2 2026.09.28.13.06"`, the
  install line `codec=registered-and-present`, no `event=degraded`, and null reasons.
- Native handler1 can see the same target with no immediate pool loss (V80 note). Pair with the record that has
  the loss, and never add both.
- Life, armor and status reads are still unavailable. Complete coverage of every native subtype is not claimed.

## Superseded

- The hardcoded U43 keys in `engine_damage_core.hpp` and the digest `if/else` RVA table in `install()` are
  replaced by the registration table. `RESEARCH/NATIVE_DAMAGE_BOUNDARY_2026-09-15/tools/inspect_damage_boundary.py`
  stays a 43-only historical tool; `tools/derive_engine_damage_layout.py` replaces its `--verify-contract` role.
