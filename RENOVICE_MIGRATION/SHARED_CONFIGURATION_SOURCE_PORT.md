# RENOVICE shared configuration source port

## Scope

This slice ports `CFG-001` and the configuration-reading portion of `CFG-002`
from the legacy companion into the authoritative bootstrapper source. It does
not deploy the new DLL or perform a live game test.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The legacy fallback really selected LocalAppData whenever the game directory was not writable. | The old source fell back only for `ERROR_PATH_NOT_FOUND`; access denied and other write failures did not trigger it. | **FALSE** |
| A single source-owned path can serve replacements, injection, configuration, logs, SWFs, and Riven gating. | `renovice::config` resolves and verifies one writable directory before any RENOVICE hook is installed; replacement and injection scanners now consume that path. | **TRUE (offline)** |
| F9 can reread configuration without any idle filesystem polling. | The existing F9 edge latch calls `config::reload()` only while draining an actual reload request. | **TRUE (offline)** |
| The three legacy flags can be parsed deterministically without accidental matches in comments or partial key names. | `verify_config_core` covers case, whitespace, aliases, comments, partial keys, duplicate keys, false values, and missing content with `/W4 /WX`. | **TRUE** |
| `AutoSpawn` already had a safe source-native behavior. | It referred to the retired fabricated scheduler. The managed addon slice now maps it to safe region-generation reapplication instead. | **FALSE historically / replaced offline** |

## Runtime contract

1. Resolve `<Warframe executable directory>\OpenWF\CustomScripts`.
2. Create it when missing and prove it is writable with a delete-on-close probe.
3. If that fails, resolve `%LOCALAPPDATA%\WarframeRedirect` and prove that
   directory writable instead.
4. Fail all RENOVICE custom systems closed if neither directory is usable.
5. Resolve `Inject`, `renovice.cfg`, and `renovice_source.log` beneath that one
   directory.
6. Parse only exact `Logging`, `Verbose`, and `AutoSpawn` assignments. Accepted
   true values are `true`, `1`, `on`, and `yes`, case-insensitively. Missing or
   other values are false. A later duplicate exact key wins.
7. Reread the file on an F9 edge. No watcher, timer, or filesystem polling is
   added to the idle path.

`Logging` and `Verbose` are available through the source-owned logging API.
Subsystem-specific migration slices use that API instead of recreating a
second log/config implementation. `AutoSpawn` now controls managed Inject
generation reapplication on region transitions; it never enables the unsafe
legacy scheduler.

## Offline gates

- dependency manifest: pass;
- custom feature manifest: pass;
- config parser: 7 checks, 0 failures;
- replacement core: pass;
- injection core: pass;
- exact installed U43 client scan: pass;
- private x64 build: warnings 0, errors 0, no companion import;
- built SHA-256: `5febe1fb0fab7b10e89baa561acb2615f031325adbb0e08ff6bb2f731e614c2e`.

Live writable-primary/fallback selection and live F9 flag application remain in
the final user-authorized test phase.
