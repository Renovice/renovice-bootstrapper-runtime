# Version 43 compatibility slice

Updated: 2026-08-23

## Scope and certified input

This is the first production migration slice from the patched companion into
the restored OpenWF source. It changes no game files and does not deploy the
new DLL.

Certified executable:

- product version: `2026.07.11.15.28`;
- size: `45,591,160` bytes;
- SHA-256: `87d3c0f946d6fff8b95567b2fce396d407721bc86cafabdafc44ee8f60fb92b0`;
- cache manifest hash: `7fwjVVacxcBzO-xahK2RZg`;
- OpenWF game family: `43.0.0`.

## Hypotheses and results

### H1: the two old crash bypasses represent two independently broken scans

Result: **FALSE**.

Assembly around patched companion offsets `0x1fc15` and `0x209cf` identifies
the guarded targets as the native-name lookups for `UpdateFlashMarkers` and
`GetStringVariable`. Both use the build-dependent Warframe native hash rather
than independent byte signatures.

### H2: the U42 seed caused both U43 lookup failures

Result: **TRUE**.

The U43 seed was independently recovered from the certified executable as
`0x7e5af8e9`. Under this seed:

- `UpdateFlashMarkers` hashes to `0xa6bdc33f` and has one native-table match;
- `GetStringVariable` hashes to `0x50cbd5f4` and has one match;
- `OpenWebBrowser` hashes to `0x0e480398` and has one match;
- `excludedFromSimulacrum` hashes to `0xad347897` and has one match;
- the combined `GetConfigBool` / `SetConfigBool` lookup has two valid table
  matches.

Therefore no raw jump-over-crash patch is present in the source solution. The
missing datum is supplied through `OpenWF/vv/wf_fnv_2_initial.json`.

### H3: raising the family cutoff alone is safe

Result: **FALSE**.

`game_versions.json` classifies every build from the U43 boundary until the
next known boundary as `43.0.0`. A blind cutoff change would also accept an
unknown later U43 binary. `supported_builds_43` now allowlists the exact
certified June and July builds; an unknown U43 build is rejected before hooks
are created. The coarse `toonew` boundary is raised to `44.0.0` only in
combination with that exact U43 gate.

### H4: current source signatures still cover the July executable

Result: **TRUE for the offline-scanned compatibility set**.

Unique matches were found for the Game HTTP caller, encrypted-string append
and discharge paths, Curl resolver, SSL verification caller, Curl host
verification, worldstate verification, Lua global setters, pause check, and
profile-dir function. The profile displacement at `match + 0x27` is `0x2c8`.

The register-enum signature has 26 callsites rather than one, but every match
calls the same single target. This is not an ambiguity in the resolved hook
target; the verifier asserts target identity so future drift cannot silently
change that property.

The older encrypted-string fallback signature has zero matches. This is
expected because the primary newer signature has exactly one match and is the
branch the source tries first.

## Reproducible gates

Run the native offline client verifier:

```powershell
RENOVICE_TOOLCHAIN\version43\verify_client_43.ps1 `
  -ExePath 'C:\path\to\Warframe.x64.exe'
```

The wrapper SHA-gates the executable, compiles the scanner with `/W4 /WX`,
checks the source version data, and proves that a synthetic unknown U43 build
is absent from the exact-build allowlist.

Then run:

```powershell
RENOVICE_MIGRATION\verify_dependencies.ps1
RENOVICE_MIGRATION\verify_manifest.ps1
RENOVICE_TOOLCHAIN\build_private.ps1
```

Current result: dependency and manifest gates pass; the edited private build
has zero warning/error lines, is x64, and does not import `wtsapi32_owf.dll`.

## Remaining boundary

Offline evidence proves that the source can resolve the certified U43 build.
It does not prove live DLL initialization, login, mission entry, or interaction
with the still-unported custom loader. The known-good two-DLL setup remains the
recovery baseline until an explicitly authorized isolated live smoke test.
