# Private build wrapper Git EOL classification repair

Date: 2026-09-19
Status: `WRAPPER_SOURCE_REPAIRED_EXISTING_DLL_STRUCTURALLY_VERIFIED_FULL_RERUN_PENDING_SOURCE_QUIESCENCE`

## Result

The private V109 DLL compiled and linked successfully. The wrapper's exit code
`1` came from its post-build text classifier, not from PHP archive generation,
Clang, the linker, or the produced PE image.

`archive.php` emitted two standard Git working-tree line-ending notices:

```text
warning: in the working copy of 'RENOVICE_TOOLCHAIN/build_private.ps1', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'RENOVICE_TOOLCHAIN/runtime/verify_safe_runtime_tick.ps1', LF will be replaced by CRLF the next time Git touches it
```

The old gate classified every line containing `warning:` as a build defect.
With `$ErrorActionPreference = "Stop"`, its first `Write-Error` terminated the
wrapper after Sun had already linked `wtsapi32.dll`.

## Hypothesis ledger

| ID | Hypothesis | Result | Evidence |
| --- | --- | --- | --- |
| B1 | Archive generation failed. | **FALSE.** | `private_archive_output.txt` contains the completed file list and final `Hotfix.owf` version message. Its only issue-pattern matches are the two exact Git EOL notices. |
| B2 | Clang or the linker failed. | **FALSE.** | `private_msvc_build_output.txt` reaches `Linking...`, contains `de_vm_authority`, and has zero warning/error/fatal issue matches. |
| B3 | The wrapper failed in its generic post-build issue gate. | **TRUE.** | The former classifier matched both Git lines as fatal `warning:` records after the link. |
| B4 | Ignoring every warning is an acceptable fix. | **FALSE.** | Compiler warnings, other Git warnings, archive warnings, `error:`, `fatal:`, failed-program messages, generated-error summaries, and nonzero process exit codes must remain fatal. |
| B5 | Only the exact Git LF/CRLF working-copy notice can be nonfatal. | **TRUE by policy and synthetic verification.** | Both direction variants are admitted; all other tested issue records remain fatal. |
| B6 | The produced DLL is structurally valid. | **TRUE offline.** | It is a PE x64 DLL, `dumpbin` succeeds, the legacy `wtsapi32_owf.dll` import is absent, and the expected V109 translation unit appears in the successful build log. This is not startup or gameplay proof. |

## Tooling correction

`RENOVICE_TOOLCHAIN/build_private.ps1` now:

1. captures `$LASTEXITCODE` immediately after `archive.php` and Sun return,
   before file writes or any later native command can obscure it;
2. continues to fail immediately on either nonzero exit code;
3. retains the complete original archive and build output in their evidence
   files;
4. recognizes only this exact Git notice family as nonfatal:

   ```text
   warning: in the working copy of '<path>', LF will be replaced by CRLF the next time Git touches it
   warning: in the working copy of '<path>', CRLF will be replaced by LF the next time Git touches it
   ```

5. applies that narrow classification to archive and build logs;
6. prints a visible `GIT EOL NOTICE` count and the per-log partition;
7. continues to fail on every other issue-pattern match.

This is a build-policy correction. No runtime C++ source was changed.

## Existing DLL proof

The DLL produced immediately before the false wrapper failure is:

- path: `wtsapi32.dll`;
- bytes: `4,808,192`;
- SHA-256:
  `0566833BA25FD032DEBFC9FEEB7C160B23562D4F7FFE736114BBFD060B76231D`;
- PE machine: `0x8664` / x64;
- `dumpbin /headers`: exit `0`;
- `dumpbin /dependents`: exit `0`;
- legacy companion import: absent.

Observed imported DLLs:

```text
USER32.dll
WS2_32.dll
ADVAPI32.dll
WINMM.dll
SHELL32.dll
bcrypt.dll
DNSAPI.dll
KERNEL32.dll
GDI32.dll
```

The build log records the V109 unit and final link:

```text
>>> Now compiling wtsapi32
...
de_vm_authority
...
main
Linking...
```

The log contains zero compiler-warning, compiler-error, fatal, failed-program,
or generated-error matches.

## Classifier verification

The updated script parses under PowerShell 7.6.5. Applying its policy to the
current evidence gives:

```text
archive_matches=2
git_eol_notices=2
archive_fatal=0
build_fatal=0
```

The synthetic matrix passed all eight cases:

| Case | Expected |
| --- | --- |
| Git `LF will be replaced by CRLF` notice | nonfatal, retained |
| Git `CRLF will be replaced by LF` notice | nonfatal, retained |
| compiler `warning:` | fatal |
| a different Git `warning:` | fatal |
| compiler `error:` | fatal |
| `fatal:` | fatal |
| `errors generated` | fatal |
| normal `Linking...` line | nonfatal |

## Proof boundary

This evidence proves that the already-produced DLL completed compilation and
linking and passes offline PE/dependency checks. It proves that the repaired
classifier accepts only the two Git EOL notices while retaining the real issue
gate.

A full post-repair invocation of `build_private.ps1` was not started by this
isolated tooling task because other agents were still editing shared runtime
source. Running the clean build during concurrent C++ edits could produce a
mixed-source artifact. Once runtime source is quiescent, the final release build
must run the complete wrapper and end with:

```text
GIT EOL NOTICE count=<n> archive=<n> build=<n> retained_in_evidence=yes fatal=no
PRIVATE BUILD PASS warnings=0 errors=0 x64=yes companion_import=no bytes=<bytes> sha256=<sha256>
```

That future wrapper pass remains separate from deployment, startup signature
resolution, and live gameplay acceptance.
