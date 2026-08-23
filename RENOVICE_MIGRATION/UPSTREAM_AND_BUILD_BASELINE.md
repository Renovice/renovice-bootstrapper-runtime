# Upstream recovery and build baseline

Date: 2026-08-23

## Outcome

The copied OpenWF source is now a reproducible dependency checkout and produces
an unedited private bootstrapper build. Nothing from this repository was
deployed to the game during this work.

Authoritative source:

- repository: `https://github.com/Sainan/warframe-dll`;
- source commit: `756bdc17aa9edf61df8204f901cdfff37b47db57`;
- commit date: 2026-08-05 09:09:20 +02:00;
- version in `main.hpp`: `OpenWF Bootstrapper v0.13.6`.

The five exact dependency commits are recorded in `upstream_submodules.tsv`.
A fresh local `git clone --recurse-submodules` reproduced all five pins with
zero differences.

## Hypotheses and results

### H1: The copied snapshot came from Sainan's public source tree

Result: **TRUE**.

Evidence: both trees contain the same 93 non-submodule files. All files compare
identically after normalizing CRLF/LF. The 23 raw-byte differences were only
line-ending differences; normalized content differences were zero. This binds
the copied snapshot to source commit `756bdc17...` without guessing from the
version string alone.

### H2: `onlyg.it/OpenWF/Bootstrapper` is the C++ source repository

Result: **FALSE**.

Evidence: its `main` tree contains only `.gitattributes`, `Change History.md`,
and `README.md`. It is release/change-history metadata. The C++ source is the
owner's public `Sainan/warframe-dll` GitHub repository.

### H3: The empty dependency folders may be populated from current branch tips

Result: **FALSE**.

Evidence: the source commit contains five Git gitlinks with explicit SHAs.
Those SHAs, not contemporary branch heads, were restored as real submodules.

### H4: The first failed compile indicates broken bootstrapper source

Result: **FALSE**.

Evidence: MSYS2 Clang defaults to the MinGW ABI. That build rejected Microsoft
SEH, Microsoft exports/assembly, and disabled non-MinGW Soup APIs. The failures
are preserved in `evidence/baseline_private_build_output.txt`. They identify a
wrong compiler target, not source defects.

### H5: The source builds under its intended Windows ABI without warnings

Result: **TRUE**.

Evidence: Sun 0.5.0 using Clang/LLVM 20.1.8 with explicit target
`x86_64-pc-windows-msvc`, inside the Visual Studio 2022 x64 developer
environment, completed archive generation, compilation, and linking with exit
code 0. The successful archive and build logs contain zero compiler/runtime
diagnostics (`warning:`, `Deprecated:`, `error:`, `fatal:`, generated-error
summaries, or missing-program failures). The classifier intentionally does not
mistake filenames such as `luau_GlobalState_error_longjump_data.json` for a
compiler error.

PHP 8.0.30 is intentional. PHP 8.4 reports a deprecation when the untouched
source calls `explode` on the null output of an empty `git tag --list`. PHP 8.0
supports every construct used by the script and produces no warning, allowing
the upstream source to remain unedited.

### H6: The output is a valid standalone private proxy DLL

Result: **TRUE for offline PE validation; live parity remains untested**.

Evidence:

- output: `wtsapi32.dll`;
- size: 3,842,560 bytes;
- SHA-256 for this timestamped build:
  `dfc28b9f29a869da96c1efc91679a92ed3e76e0942c15119e7273c344bd13746`;
- PE machine: x64 (`8664`);
- subsystem: Windows GUI;
- export rows: 23;
- import table contains no `wtsapi32_owf.dll` or other companion dependency.

The archive embeds the current time by design, so repeated clean builds are not
expected to have identical artifact hashes. Source, dependencies, tool versions,
exit status, issue census, PE shape, and imports are the reproducibility gates.
A live isolated-client load test is still required before this baseline can be
called runtime-compatible.

## Evidence files

- `baseline_private_archive_output.txt`: successful PHP 8.0 archive generation;
- `baseline_private_msvc_build_output.txt`: successful warning-free build;
- `baseline_private_build_output.txt`: preserved negative MinGW-target attempt;
- `baseline_private_pe_validation.txt`: headers, imports, and exports.

## Reproduction

From the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File RENOVICE_TOOLCHAIN\bootstrap_tools.ps1 -InstallLlvm
powershell -ExecutionPolicy Bypass -File RENOVICE_MIGRATION\verify_dependencies.ps1
powershell -ExecutionPolicy Bypass -File RENOVICE_TOOLCHAIN\build_private.ps1
```

The build script does not copy or deploy the resulting DLL.
