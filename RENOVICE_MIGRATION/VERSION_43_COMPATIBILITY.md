# Version 43 compatibility slice

Updated: 2026-08-27

## Scope and certified input

This is the first production migration slice from the patched companion into
the restored OpenWF source. It changes no game files and does not deploy the
new DLL.

Originally certified executable:

- product version: `2026.07.11.15.28`;
- size: `45,591,160` bytes;
- SHA-256: `87d3c0f946d6fff8b95567b2fce396d407721bc86cafabdafc44ee8f60fb92b0`;
- cache manifest hash: `7fwjVVacxcBzO-xahK2RZg`;
- OpenWF game family: `43.0.0`.

Current Amir's Shockwave live-reference executable:

- product version: `2026.08.19.11.06`;
- SHA-256: `cca46d604a498cd95f0d28e3e8f3eee8833f5d362666a8e5c820c535f7c2af93`;
- DE Luau undump raw/RVA: `0x197f210` / `0x197fe10`;
- result: all 32 signature, native-name, displacement, proxy-export, and
  call-target checks pass.

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
unknown later U43 binary. The initial fix allowlisted ProductVersion labels,
but the Amir's Shockwave update proved that ProductVersion is not a unique
executable identity: its binary changed while retaining `2026.08.19.11.06`.
The runtime now requires both a certified label and a certified whole-file
SHA-256 before creating U43 hooks. `supported_client_sha256_43` contains only
independently scanned binaries. The runtime renders the digest with lowercase
hexadecimal before performing the case-sensitive tunables lookup; the verifier
asserts this normalization so an uppercase display digest cannot reject a
correctly certified client. The coarse `toonew` boundary is raised to
`44.0.0` only in combination with those two exact U43 gates.

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
  -ExePath 'C:\path\to\Warframe.x64.exe' `
  -ProxyDllPath '.\wtsapi32.dll'
```

The wrapper selects a certification record by both ProductVersion and SHA-256,
compiles the scanner with `/W4 /WX`,
checks the source version data, proves that a synthetic unknown U43 build is
absent from the exact-build allowlist, reads the executable's WTS import table,
and fails unless every imported WTS entry point is exported by the proxy DLL.
This last gate was added after the August executable introduced
`WTSQuerySessionInformationW`; signature/RVA compatibility alone could not
detect a Windows-loader export failure.

Then run:

```powershell
RENOVICE_MIGRATION\verify_dependencies.ps1
RENOVICE_MIGRATION\verify_manifest.ps1
RENOVICE_TOOLCHAIN\build_private.ps1
```

Current result: the Amir's Shockwave reference passes all 32 executable checks;
dependency and manifest gates pass; the edited private build
has zero warning/error lines, is x64, does not import `wtsapi32_owf.dll`, and
exports all four WTS names imported by the certified August client.

## Remaining boundary

Offline evidence proves that Windows can resolve the certified U43 executable's
WTS imports and that the source can resolve its hook signatures. It does not by
itself prove live DLL initialization, login, mission entry, or gameplay. The
single-DLL Renovice source port is now the active architecture; each certified
game update still requires an explicit live smoke test after the offline gates.
