# Native update resilience (steps 2 and 4, native side), 2026-10-02

- Branch `feat/native-update-resilience-2026-10-02` from `main` `f97215c` (R21; runtime source identical to the installed R17
  DLL `304b57de…`). Offline only: the game folder was read, never written; nothing deployed, nothing pushed.
- Client: 44.0.2 `2026.09.28.13.06`, installed sideloadified `Warframe.x64.exe` `0124f0b9…7d33` (45,518,472 B).
- Interface for the script side: `work/research/update-resilience/NATIVE_INTERFACE.md` (workspace).
- Maintenance procedure: `Documentation/10-Tools-and-Workflows/Maintaining-After-a-Warframe-Update.md`, section
  "Native side".

## Problem

After a Warframe update every native fact the bootstrapper relies on can move or change: 95 active hex signatures, the
DE_VM_AUTHORITY lock identity, the luaCalls boundary, the per-build tables (`engine_damage_builds.hpp`,
`engine_params_builds.hpp`), the allowlists (`OpenWF/tunables.json`, shipped in `Hotfix.owf`; the certified table of
`verify_client_44.ps1`). Until now each update was re-verified by hand (44.0.2: two lock signatures broke on neighbour
bytes; a stale `Hotfix.owf` made the DLL refuse the client as "too new"; the ENGINE_DAMAGE codec stayed on U43 keys).

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| N1 | Every native dependency can be enumerated from the source tree alone (no hand list). | **TRUE** | Census of every hex literal in `main.cpp`, `renovice/*.{cpp,hpp}` and the active `OpenWF/vv/sig` entries (150 rows; ids equal to the step-1 check's baseline, 0 missing / 0 extra), plus the named identity and table facts read from their headers. |
| N2 | A relink moves code without changing it, and the moved code can be re-found by identity without guessing: masking only rel32 / RIP-relative / switch-table operand fields, then verifying every other byte and every masked target's identity. | **TRUE (synthetic)** | `shift` case: 0xF0 bytes inserted at 0x800168, 446,907 code operands + 7,290 switch entries + 151,691 `.reloc` pointers + 119,971 `.pdata` entries re-pointed. 62 moved signatures re-found exactly +0xF0, a deliberately tightened literal (undump RIP displacement) re-found by the masked strategy and relaxed, ENGINE_DAMAGE re-derived, ENGINE_PARAM's 8 ranges relocated (switch-table entries re-read), 0 review. |
| N3 | The 44.0.2 lock-stub case (a stub relocated next to different neighbours) is handled without a source change. | **TRUE (synthetic)** | `neighbour` case: LeaveCriticalSection thunk 0x18d2670 -> 0x10049c2, 247 rel32 references re-pointed; import identity resolves it uniquely and the dispatcher cross-check passes. A test-only signature that runs past its leaf into the changed next prologue is trimmed at the function end and stays unique. |
| N4 | A codec key change is mechanical when the accessor and evaluator shapes are unchanged. | **TRUE (synthetic)** | `codec` case: keys rotated in .text (1,714 / 3,548 occurrences); the derivation reads rol19/0x5A17C3E1 from the accessors at the Lua-binding slots of all 29 DamageControl vtables and rol17/0x2B9D04F7 from the evaluator; layout unchanged. |
| N5 | A real code change inside a matched pattern is never auto-applied. | **TRUE (synthetic)** | `instr` (Riven SetStringVariable frame +0x10): review, closest candidate named through the function's string anchor, nothing applied; Riven fails closed, the rest of the build is allowlisted. `process` (also a `main.cpp` signature): review with scope `process`, the build stays off the allowlist (the DLL refuses the client). |
| N6 | On the installed client nothing changes. | **TRUE** | 121 unchanged, 0 auto, 0 review, 57 inactive; allowlist `already`. |

## Tool (`RENOVICE_TOOLCHAIN/native_update/`)

| File | Role |
|---|---|
| `renovice_native_update.py` / `.ps1` | Entry point: report, `--apply`, `--build`, reference snapshot. |
| `nu_image.py` | Section-mapped PE32+ image, scans, capstone decode with volatile operand fields, imports, xrefs, ProductVersion. |
| `nu_source.py` | Census rows with source spans, table parsers, tunables / seeds / game versions, certified clients. |
| `nu_reloc.py` | Relocation engine (strategies and strict verification below). |
| `nu_checks.py` | Every dependency kind; classification and scope. |
| `nu_engine_damage.py` | ENGINE_DAMAGE registration derived from code (the codec research method, from scratch). |
| `nu_engine_params.py` | ENGINE_PARAM registration relocated by identity (8 ranges, anchors, switch table, writer contract). |
| `nu_apply.py` | Writes auto items into the tree. |
| `nu_build.ps1` | Build environment + `build_private.ps1` + staging with `SHA256SUMS.txt`. |
| `synthetic/make_synthetic.py`, `test_native_update.py`, `verify_native_update.ps1` | Synthetic builds and the regression test. |

### Dependencies (44.0.2: 121 active, 57 inactive, 178 items)

| Kind | Active | What |
|---|---:|---|
| signature | 95 (+55 inactive) | 56 `main.cpp` + 3 `OpenWF/vv/sig` (scope `process`, first-match at run time), 36 `renovice/*` (scope `feature`, unique-or-refuse at run time). Inactive = version-gated, legacy or commented rows with 0 matches on the reference. |
| identity | 5 | DE_VM_AUTHORITY lock-enter / lock-leave (import identity), locked-dispatcher cross-check, luaCalls owner callback calls the interrupt leaf, OpenWF frame profile (`current_u43` unique, legacy 0). |
| byte-range | 8 | ENGINE_PARAM `admit_image` ranges. |
| table | 2 | `engine_damage_builds.hpp` (3 handlers, evaluator, 2 codecs, 13 layout values) and `engine_params_builds.hpp` (push_value, seed, layout, 8 ranges). |
| seed | 1 | Name-hash seed from the hash function (= `wf_fnv_2_initial.json` for the game version). Scope `process`. |
| native-name | 5 (+2) | Method-table rows of the names the runtime resolves by hash (RunScript, PushFloatArg, SetDamageCallback, SetSourceObject, Initialize). |
| imports | 1 | WTSAPI32 imports of the client covered by the reference (proxy exports). Scope `process`. |
| verifier-row | 2 | Undump raw/RVA for the certified table; `verify_client_44.cpp` profile-dir pin 0x2B8. |
| build | 1 | ProductVersion -> game version, U44 family, below `toonew`. |
| label | 1 | Cosmetic: the luaCalls log line prints fixed U43 RVAs (resolution is by signature). |

### Re-find strategies (`nu_reloc.py`)

1. **exact**: the source pattern (its own wildcards) is unique.
2. **masked**: every volatile operand field of the reference code is wildcarded (rel32 branch targets, RIP-relative
   displacements, absolute switch-table RVAs); never an opcode, register, immediate or frame size.
3. **trimmed**: a pattern that runs past its function's end (ret/jmp + int3 padding) into a neighbour is cut at that
   boundary, then 1-2 again (the 44.0.2 lock-signature defect).
4. **identity** (named facts): lock thunks by `jmp [rip+IAT]` to the slot bound by name to KERNEL32!Enter/
   LeaveCriticalSection; ENGINE_DAMAGE from the handler signatures, `lea rcx,[r14+X]; call evaluator`, Lua-binding slots
   by name hash, DamageControl vtables; ENGINE_PARAM ranges anchored on each other (a rel32 target that is another range
   start must hit that range's new start), switch tables through the indexing instruction, writer contract (push_value
   reached only by its two CALLs inside apply_param, no JMP/LEA/absolute pointer).
5. **anchors** (review evidence only): functions of the new image that reference the reference function's string
   constants; the closest alignment and the differing instructions are reported, never applied.

**Strict verification** of every candidate, instruction by instruction: same boundaries, sizes and mnemonics; every
non-volatile byte equal; every volatile field of the same kind and identity (import -> same DLL!function; string /
constant -> same bytes; code -> in .text, and the exact new anchor when it is one; writable global -> volatile).
Several passing candidates are separated by callee-prologue identity or left for review.

A relaxed signature is applied only if it is unique on the new image and on every stored reference image at its own site
(the runtime scans `main.cpp` and `vv/sig` patterns first-match).

### Classification and fail-closed rules

- `unchanged` same RVA and bytes; `auto` re-found by identity (`edit`: `none` = the runtime re-finds it itself,
  `signature` = literal relaxed, `table` = new row); `review` nothing applied; `inactive` not used on this family.
- A review item fails closed in its feature: the old signature stays (0 matches -> the runtime refuses that feature), no
  table row (ENGINE_DAMAGE / ENGINE_PARAM_OVERRIDE install nothing on that digest).
- A review item of scope `process` (`main.cpp`/`vv/sig` signature, seed, WTS imports, build identity) keeps the build off
  `supported_builds_44` / `supported_client_sha256_44` and the certified verifier table: the DLL refuses the client.
- The DE Luau / parameter-record layout of a new ENGINE_PARAM row is carried over (reported); the byte ranges cover the
  record type byte, the float push (tag 3, size 0x10, top +0x08), the key push (tag 1) and getfenv (env +0x10, tag 7).

## Gate changes (this branch)

- `gate_paths.ps1 Get-GateClientImages`: the client (`RENOVICE_GATE_CLIENT_EXE`, else the installed exe) and every
  reference image in `work/native-update/reference`.
- `verify_engine_damage_codec`: default images include those; an unregistered image is `SKIP` (installs nothing), not a
  failure; every registration must still be covered by an image.
- `verify_engine_params`: part D checks every given image whose digest is registered (any number of `<exe> <sha>`
  pairs); an unregistered one is INFO; the source pin accepts appended rows (44.0.2 first, keyed by exact digests).
- Reference store seeded: `2026.09.28.13.06_0124f0b93516` (44.0.2) and `2026.09.24.13.29_45fa6ad0769c` (44.0.0 Steam).

## Regression (`verify_native_update.ps1` / `test_native_update.py`)

Synthetic builds from a COPY of the certified 44.0.2 image (`work/temp/native-update-synthetic/images/<case>`), each
with a new ProductVersion `2026.10.06.12.0x`; the tool runs with `--apply` on a scratch copy of the source facts, then
`verify_client_44.ps1` is compiled from the APPLIED headers and run on the synthetic image. No old real build is used.

| Case | Expected and observed |
|---|---|
| unchanged | exit 0; 0 signatures moved; new rows equal the 44.0.2 values (new digest); allowlist add; verifier PASS |
| shift | exit 0; 62 signatures +0xF0; tightened undump literal relaxed in place (masked); push_value 0x191a010 -> 0x191a100, ranges moved exactly as their code; switch table re-read; handlers/evaluator re-derived; lock-leave by identity; verifier PASS |
| neighbour | exit 0; lock-leave thunk re-found by identity; dispatcher cross-check PASS; run-past signature trimmed; verifier PASS |
| codec | exit 0; new ENGINE_DAMAGE row with rol19/0x5A17C3E1 and rol17/0x2B9D04F7; verifier PASS |
| instr | exit 1; only the Riven signature review (candidate named), nothing applied for it; allowlist add; verifier fails exactly that row |
| process | exit 1; `main.cpp` + Riven review; allowlist refused; verifier refuses the uncertified image |

Result: `NATIVE UPDATE REGRESSION PASS checks=64 failures=0` (`verify_native_update.ps1`, about 2.5 min). With
`-Build <worktree>` the shift case is also rebuilt in full (19 checks PASS; see "Build").

## Build

- **This branch on the installed 44.0.2** (`renovice_native_update.py --apply --build`; nothing to apply, 121 unchanged):
  `nu_build.ps1` -> `build_private.ps1` every build-listed gate PASS, `PRIVATE BUILD PASS warnings=0 errors=0`,
  main DLL `6a5aebb2ab15db81f36fb31790c4da8aad88df8bed299c06af333551a2032ea7` (6,051,328 B), Hotfix.owf
  `047cfc23d52ab612849b1f962ad085447f2278bdae4a49f40fa76d62ea3f1842` (79,149 B), 331 s. Staged
  `work/staging/native-update-2026-10-02/stage/` with `SHA256SUMS.txt`; report beside it. Runtime source = R17; the
  Hotfix.owf carries the same allowlist as the installed one (the archive is time-stamped, so hashes differ per build).
- **Synthetic proof build** (shift case applied by the tool to a scratch worktree at `85befb2`, then
  `nu_build.ps1 -ClientExe <synthetic>`): every gate PASS with the synthetic image as client
  (`ENGINE_DAMAGE CODEC GATE PASS registered=4 covered=4`, ENGINE_PARAM part D admits the synthetic row and the 44.0.2
  row from the reference store), `PRIVATE BUILD PASS warnings=0 errors=0`, DLL `427344bcb336b1c2…` (6,052,352 B),
  Hotfix.owf `b2e18f9866088d0c…` listing the synthetic build. Applied diff kept as
  `work/temp/native-update-synthetic/out/build-shift/applied.diff`; the worktree was removed (a synthetic registration
  must never be committed). The ability editor's step-1 parsers read the appended rows (4 / 2 registrations, 5 certified
  clients).

## Limits (exact)

- The real next build does not exist yet; every relocation claim is proven on synthetic builds derived from 44.0.2.
  A real relink also changes code generation (register allocation, inlining); those differences land in `review`, by
  design.
- The DE Luau layout of ENGINE_PARAM rows is carried over, not derived; a VM layout change also breaks the injection
  signatures that embed those offsets (they would be review items).
- Native-name counts are reported, not enforced (the runtime resolves names by hash; only a vanished name is review).
- A new major version (seed change, game version outside 44.x) is review by design: `game_versions.json`,
  `wf_fnv_2_initial.json`, the toolchain seed and `toonew` need a reviewed update.
- The luaCalls log label keeps its fixed U43 text (cosmetic, reported).
- Live: nothing here is live; the DLL built from this branch has the same runtime source as R17.

## Rejected designs

- Per-build `_u44_x` signatures: repeats the 44.0.2 defect (neighbour bytes) for every hotfix.
- Copying RVAs by a constant delta: code moves non-uniformly; every value is re-found by identity instead.
- Applying an anchor-search candidate: it is evidence for a person, never a fact.
- Failing the gates on an unregistered client image: it would block building the DLL whenever a feature needs review;
  the feature fails closed at run time instead, and the tool's report owns the question.
