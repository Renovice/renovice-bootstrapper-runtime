# DE_VM_AUTHORITY ScriptMgr lock identity on Hotfix 44.0.2 (2026-09-29)

## Build and scope

- Client: `2026.09.28.13.06` (Hotfix 44.0.2), installed sideloadified
  `Warframe.x64.exe` SHA256 `0124f0b93516e60ae362c59090809de24a42551143a6adf84963bd2120ab7d33`
  (45,518,472 B). Read-only.
- Failing DLL: `a5508daebb21b89739102266775c3db94a676c4aea818e75fb66eccc34f88bbf`
  (4,884,480 B, repo `3d3a2f9`).
- Reference clients (read-only): U44.0.0 sideloadified `87fc60ce…`
  (`Warframe Ice blade of narin 28.09.2026`), U43 `cca46d60…`
  (`work/native-analysis/inputs/wf-2026.08.19.11.06-cca46d60`).

## Symptom (live, Logging=true)

```
RENOVICE DE_VM_AUTHORITY resolve FAIL primitive=lock-enter matches=0
RENOVICE DE_VM_AUTHORITY resolve FAIL primitive=lock-leave matches=0
RENOVICE DE_VM_AUTHORITY FAIL reason=one or more primitives were not unique
```

No `safe runtime tick VM captured`, no `RELOAD PASS`, no Inject/TARGET ADDON
lines; Scripts menu absent. The Replacement lane is initialised separately
(`replacements::initialise`) and is unaffected, consistent with the Riven lock
replacement still working.

## Hypothesis

H1: the ScriptMgr lock primitives still exist unchanged in 44.0.2; only the
`_u44` signatures fail because they extend past the primitive into bytes the
linker does not keep stable.

**Result: TRUE.**

## Evidence

The lock primitives are two identical-code-folded MSVC thunks

```
48 8B 09        mov rcx,[rcx]
48 8B 09        mov rcx,[rcx]
48 FF 25 rel32  jmp qword ptr [rip+IAT]
```

The pattern `48 8B 09 48 8B 09 48 FF 25 ? ? ? ?` has exactly 3 hits in every
certified build; the third jumps through `KERNEL32!WakeConditionVariable`.

| build | Enter thunk (IAT slot) | Leave thunk (IAT slot) | locked dispatcher | dispatcher +40 call | dispatcher +0x133 tail-jmp |
|---|---|---|---|---|---|
| U43 `cca46d60` | `0x829a30` (`0x20292b8`) | `0x4de3b0` (`0x20292c0`) | `0xc8c2a0` | `0x829a30` | `0x4de3b0` |
| U44.0.0 `87fc60ce` | `0xa6d950` (`0x1ff42a8`) | `0x9897c0` (`0x1ff42b0`) | `0xd18cd0` | `0xa6d950` | `0x9897c0` |
| U44.0.2 `0124f0b9` | `0x14c580` (`0x1ff52a8`) | `0x18d2670` (`0x1ff52b0`) | `0xe35b20` | `0x14c580` | `0x18d2670` |

(RVAs. IAT slots named via each image's import-name table.)

The removed signatures were the 13 thunk bytes + `CC CC CC` + the prologue of
whichever unrelated function followed the thunk:

- U43 enter/leave: `… CC CC CC 48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20` /
  `… CC CC CC 40 57 48 81 EC C0 00 00 00`
- U44 enter/leave: `… CC CC CC 48 89 5C 24 18 48 89 6C 24 20 56 57 41 55` /
  `… CC CC CC 48 83 EC 28 E8 ? ? ? ? 48 8B 08 48 8B 91 30 09 00 00`

44.0.2 relocated both thunks (`0xa6d950 -> 0x14c580`, `0x9897c0 -> 0x18d2670`),
so the neighbour prologues changed and both scans returned 0. The thunk bodies,
their import targets and the locked dispatcher (still unique, still calling
Enter at +40 and tail-jumping to Leave at +0x133) are unchanged.

## Fix (branch `fix/44.0.2-de-vm-authority-lock-identity`)

- New `renovice/de_vm_authority_core.hpp` (no `<windows.h>`, shared with the
  verifier): `signature_lock_thunk`, `lock_import_module = "KERNEL32.dll"`,
  `signature_lock_enter_import = "EnterCriticalSection"`,
  `signature_lock_leave_import = "LeaveCriticalSection"`, the locked-dispatcher
  signature and a bounded epilogue signature `48 83 C4 50 5F E9 ? ? ? ?`
  (window 0x200), plus `find_import_slot_rva()`: a bounds-checked PE32+ import
  directory walk that returns the IAT slot bound *by name* (import-name table,
  never the slot's runtime value; missing, ordinal-only or duplicate => 0).
- `renovice/de_vm_authority.cpp`: `resolve_lock_thunk()` scans the thunk
  pattern (capacity 16; a full buffer fails closed) and accepts exactly one
  thunk whose `jmp [rip+x]` target is that import slot. New cross-check: the
  dispatcher epilogue tail-jump must equal the resolved Leave thunk (Enter
  cross-check at +40 unchanged). Failure logs
  `resolve FAIL primitive=lock-enter matches=N thunks=M import=KERNEL32.dll!EnterCriticalSection import_slot=unique|missing`.
  Success adds one operational line
  `RENOVICE DE_VM_AUTHORITY lock identity enter_rva=0x… leave_rva=0x… dispatcher_rva=0x… import=KERNEL32.dll`.
  The version-gated `GV(44,0,0)` selection and all four neighbour-byte
  signatures are removed. Protected-call, raw-protected-run, vm-throw and
  flash-shutdown signatures are byte-identical and stay in the .cpp (pinned by
  the stock-loader/longjmp source gates).
- Build validation is unchanged: `initialise(false)` still rejects any
  executable not on the exact allowlist; every primitive must be unique; any
  cross-check failure rolls back to the all-null state.
- No Pluto file, OpenWF data file, addon, Replacement or hotkey code changed.

## Regression gates

- `RENOVICE_TOOLCHAIN/version44/verify_client_44.cpp` now mirrors the lock
  resolution on a section-mapped image (`DE_VM_AUTHORITY lock-enter`,
  `lock-leave`, `locked-dispatcher` rows). The previous certification ran this
  verifier, which did not cover DE_VM_AUTHORITY; that gap is why 44.0.2 was
  certified while the authority failed.
- `verify_de_vm_authority.ps1`: requires the identity data and resolver, and
  forbids `48 FF 25 ? ? ? ? CC` / `_u44` lock signatures.
- Offline resolution result: U43, U44.0.0 and U44.0.2 each resolve Enter/Leave
  with matches=1, thunks=3 and both dispatcher cross-checks passing; on U43
  and U44.0.0 the identity reproduces exactly the addresses of the old per-build
  signatures.

## Signature census (U43 / U44.0.0 / U44.0.2 match counts)

`signature_census_u43_u44.0.0_u44.0.2.tsv` covers all 147 hex-pattern literals
in `main.cpp` and `renovice/*.{cpp,hpp}` (including version-gated, legacy and
commented rows), produced by `tools/census.py` on the section-mapped images
(TSV and tools kept beside this note, untracked per the RESEARCH `.gitignore`
policy).

- The **only** rows whose count differs between U44.0.0 and U44.0.2 are the two
  removed `_u44` lock signatures (1 -> 0).
- Every renovice-owned signature active on U44 is unique on 44.0.2:
  injection_core 8/8, vm_memory_evidence 5/5, riven_core 5 (U44 set), swf_core
  2 (U44 set), engine_damage 3/3, injected_interrupt_budget 2/2,
  vm_stack_write 2/2, application_frame 1 (U44 set), replacements undump 1,
  DE_VM_AUTHORITY dispatcher/protected-call/raw-protected-run/vm-throw/
  flash-shutdown 5/5.
- main.cpp multi-hit first-match rows used on U44 were checked for identity:
  `parse_arguments_callsite` (2 hits) first hit is the same site (`0x8a242`);
  `string_pool_insn` (2 hits) both hits reference the same global. Other
  multi-hit rows are iterated (`register-enum` 26 -> 1 target, 355, 11, 2),
  commented out, or gated to older versions.
- Versioned `OpenWF/vv/sig/*.json` (highest key <= 44): Curl_ossl_verifyhost
  41.0.0 = 1, ssl_verify_internal_caller 41.0.0 = 1, verify_worldstate_integrity
  40.00.0 = 1. `check_string_substitutions` 42.0.0 and `irc_send_raw` 42.00.0
  are **0 on both U44.0.0 and U44.0.2** (pre-existing U44 gap, not a 44.0.2
  regression; those optional OpenWF paths skip when unresolved).
- Native-name hash rows, undump and exact damage RVAs: `verify_client_44.ps1`
  V44 COMPATIBILITY PASS on 44.0.2.

## Build

`RENOVICE_TOOLCHAIN/build_private.ps1` (all source gates + clean private MSVC
build): `PRIVATE BUILD PASS warnings=0 errors=0 x64=yes companion_import=no
bytes=4890112 sha256=15daf981af6ad7a358500f36084c9c23a94f4e9ac0881184bd29a118a7b73cea`.
Staged (not deployed) at
`work/staging/bootstrapper-44.0.2-vmauthority/wtsapi32.dll`.

Build-environment note: in the agent shell, `NoDefaultCurrentDirectoryInExePath`
prevents `archive.php` from finding `tools\pluto.exe` after `chdir("tools")`;
the build was run with `tools` and the VS Installer directory prepended to PATH.
Windows PowerShell 5.1 also turns git's LF/CRLF notices on stderr into a
terminating error under `$ErrorActionPreference='Stop'`, so edited files must
match `.gitattributes` line endings before building.

## Hotfix.owf

The rebuilt `Hotfix.owf` differs from the deployed/repo `C080B92C…` only in the
archive build timestamp: header (title hash, hotfix 3) and the entire deflate
payload + signature (54,301 bytes) are byte-identical. `loadHotfix` checks only
the title hash. **The deployed `OpenWF/Hotfix.owf` does not need to change.**

## Limitations / pending live checks

- Offline only. Pending: fresh-process log shows `lock identity …` then
  `DE_VM_AUTHORITY PASS`, VM capture, `RELOAD PASS trigger=startup`,
  Scripts menu, Inject/managed/target addons, F9, F10/Pluto, Replacement.
- The Steam (non-sideloadified) 44.0.2 executable was not available on disk;
  it is allowlisted with identical code, and the resolver reads the import
  table by name, which Sideloadify's added import does not affect.

## Rejected designs

- Adding `_u44_2` neighbour-byte signatures: repeats the defect; the next
  relink breaks it again, and `game_version` does not separate 44.0.0/44.0.2.
- Resolving by the IAT slot's current *value* (`GetProcAddress` compare):
  sensitive to IAT hooks and forwarders; rejected for the import-name identity.
- Raw RVA table keyed by executable digest: works but needs a new entry per
  build for a primitive whose identity is build-independent.
