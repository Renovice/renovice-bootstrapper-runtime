# DE-Luau replacement source port

Updated: 2026-08-23

## Outcome

The proven boot-time full-module replacement path is now implemented directly
in the OpenWF source tree. It no longer depends on MinHook or the companion
proxy in this development build. No DLL was deployed during this work.

This slice originally covered manifest rows `LR-001` through `LR-004`. The
later managed-addon slice added atomic F9 replacement-map refresh while keeping
module-cache semantics explicit.

## Hypotheses and results

### H1: the source bootstrapper already replaces DE bytecode modules

Result: **FALSE**.

The source has its own Pluto scripting VM and several DE-Luau/native hooks, but
it did not intercept the DE bytecode undump function or perform content-keyed
body substitution. A new isolated module now owns that behavior:

- `renovice/replacements_core.hpp`: pure body-key and filename rules;
- `renovice/replacements.cpp`: directory snapshot, undump detour, and lifetime;
- `renovice/replacements.hpp`: narrow host entry point.

### H2: the old companion's MinHook dependency must be retained

Result: **FALSE**.

The restored source already has `soup::DetourHook`. The new module uses it and
the final private DLL still has no `wtsapi32_owf.dll` import.

### H3: ordinary FNV-1a-64 is compatible with deployed filenames

Result: **FALSE**.

The deployed loader uses basis `1469598103934665603`, not the standard basis
`14695981039346656037`; the prime is `1099511628211`. A native `/W4 /WX` unit
gate pins `body_key("abc") == 0xe16801510db89efd` so a future cleanup cannot
silently change every lookup key.

### H4: filenames must contain exactly sixteen hex characters

Result: **FALSE**.

The production convention reads the first sixteen hex characters and permits a
human annotation afterward. All four active files use that convention and pass
the new verifier. Short, non-hex, zero, duplicate, unreadable, and empty
replacement entries fail the snapshot transaction rather than activating a
partial map.

### H5: replacement size must equal original size

Result: **FALSE in the implementation; live execution remains pending**.

The detour forwards the replacement vector's pointer and its own length to the
original undump function. It never reuses the stock length. The map becomes
immutable before the hook is enabled, so pointers remain stable for process
lifetime. A live smaller/larger replacement check is still required before
marking `LR-003` complete.

### H6: hardcoded RVA should remain scattered in C++

Result: **FALSE**.

The unique masked signature is preferred. Fallback RVAs are stored under exact
16-byte build keys in `OpenWF/tunables.json`: June uses `0x197C9F0`, while July
uses `0x197E030`. The lookup constructs the key from the executable's own
ProductVersion; it does not select an address using the broad U43 family. The
exact U43 allowlist prevents unknown U43 binaries from reaching hook setup.
The SHA-gated verifier proves the signature's raw offset `0x197D430` maps to
the July RVA on `2026.07.11.15.28`.

## Offline gates passed

- Replacement core native test: 9 fixed properties pass.
- Active replacement directory: 4 files, 4 unique valid keys.
- Certified U43 undump signature: exactly one match.
- Signature location: raw `0x197D430`, RVA `0x197E030`.
- Full private build: zero warning/error lines, x64, no companion import.

## Explicit boundary

F9 now stages and atomically swaps the complete replacement byte map together
with the other RENOVICE prepared state. The game still caches loaded modules;
a changed body applies on the next matching module load, not retroactively to
already-created closures. The reload status reports that timing rather than
pretending an existing closure was rewritten.

The source-built DLL must still pass an authorized live smoke test using a
recoverable deployment before `LR-001` through `LR-004` can be called live
complete.
