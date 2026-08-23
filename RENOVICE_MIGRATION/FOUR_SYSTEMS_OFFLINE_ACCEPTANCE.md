# Four-system source-port acceptance

Updated: 2026-08-23

## Outcome

The remaining four custom systems are present in the source-built bootstrapper
and ready for the user-authorized live-test phase. Nothing was deployed to the
installed game during this phase.

| System | Source result | Live result |
|---|---|---|
| Shared CustomScripts/config paths | Writable-primary probe, LocalAppData fallback, cached exact flags, and F9 staging implemented | Pending |
| Content-keyed SWF replacement | Strict FWS validation, immutable snapshot, optional size-changing TOC metadata, exact U43 signatures, and empty-folder fast path implemented | Pending |
| Riven lock UI | Cached file gate, strict URL parser, asynchronous configured-server request, and deferred script-thread UI refresh implemented | Pending |
| Managed addons and F9 | Registry-rooted lifecycle tables, cleanup/activate rollback, full-folder staging, cross-system prepare/commit, region policy, and replacement-map refresh implemented | Pending |

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The companion DLL is still required to carry these systems. | Each system now builds inside the restored OpenWF source, and the output import table has no companion DLL dependency. | **FALSE offline** |
| F9 requires continuous folder polling. | Filesystem reads happen while handling a latched F9/region request; idle work is only the existing key edge check and undump timestamp update. | **FALSE offline** |
| A failed addon edit may publish new config or replacement state first. | Every source-owned candidate is prepared before addon activation and discarded if staging or activation rejects. | **FALSE offline** |
| The legacy fabricated scheduler is necessary for persistent behavior. | Managed chunks return idempotent lifecycle closures rooted in DE's registry; `.persist` and `.spawn` remain fail-closed. | **FALSE offline** |
| Offline tests prove live DE-VM parity. | They prove parsing, signatures, state-machine ordering, builds, and static integration, but not game callback/GC/UI behavior. | **FALSE** |

## Test boundary

Do not mark these systems complete from build success alone. On the user's test
signal, preserve the known-good DLL pair, deploy the new single DLL, and execute
the live checklist in `MIGRATION_STATUS.md`. Any live failure belongs to this
source tree and must be fixed here rather than patched back into the companion.

## Final offline gate

- manifest: 43 features, 40 parity-required, pass;
- dependency pins: 5 submodules at source commit `756bdc17...`, pass;
- config core: 7/7, pass;
- SWF core: 9/9, pass;
- Riven core: 9/9, pass;
- replacement core: 10 fixed checks plus 4/4 active files and directory gates,
  pass;
- injection core: 16 fixed checks plus active-directory gates, pass;
- exact installed U43 client: all mandatory signatures unique and all 8
  exact-build compatibility checks pass;
- private DLL: 3,998,208 bytes, x64, warnings 0, errors 0, no companion import,
  SHA-256 `2bcb2b12d2daf8c307878196bb3f8f4037f265b2b3ce89c69dba5cf9ce8b1c03`.
