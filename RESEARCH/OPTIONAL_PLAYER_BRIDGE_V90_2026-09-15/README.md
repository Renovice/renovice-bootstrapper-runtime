# Optional player returns and background status — V90, 2026-09-15

User requested repair of the V89 live nil-avatar error and stack warnings, then
a separate combat/buff/per-target Ice Wave test. This repair belongs to existing
OpenWF utility wrappers. The raw DE Luau injector and damage modifier are distinct.
Feature owners: LI-010/LI-011, existing native-frame OpenWF scheduler; its frame,
UI owner/idle, panic, stack-restoration and pending-only DE transaction gates remain.

**V90_R2 DEPLOYED21:45:12.5322948Z.** Installation verified23package artifacts,
20existing gameplay/config entries and32metadata/hotkey/utility files. The game
process was independently verified absent before the DLL write. Source-log
baseline213916040. Fresh startup/transitions/F9/off/combat acceptance pending.
Read the [dated receipt](evidence/deployment-receipt.json). The initial V90 package
remains a superseded candidate; it was never installed.

## Hypotheses and results

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| Missing local player leaves a native nil on the bridge stack. | TRUE from production source/replay | GetLocalPlayer only consumed non-nil results; 92 absent calls leave 92 nil values and reproduce the PRIVATE warning condition. |
| Missing avatar is rejected after the background conditional can inspect nil. | FALSE | GetAvatar constructs LotusAvatar first. The constructor throws before bgscript:407 can evaluate its conditional. The V89 traceback records this path. |
| Optional return handling can preserve normal objects without masking errors. | TRUE offline | One shared optional userdata reader consumes nil once, preserves normal constructor/registry handling and still rejects wrong non-nil types. |
| Current installed hotfix overrides the repaired runtime. | FALSE | Signature-checked installed Hotfix.owf targets a different bootstrapper title. It is ignored by existing production loadHotfix; no file was removed. |
| Every one of the 92 live stack warnings is proven to have the same cause. | UNPROVEN | The old getter reproduces the exact residual-stack condition; the live warning has no callsite attribution. Residual warnings must still be checked after deployment. |
| Offline replay establishes clean transitions, F9/off or combat acceptance. | FALSE | Those require their separate fresh live runs. |

## Repair

The reusable `ivkr_pop_optional_userdata` handles absent results at their getter
boundary, including zero native results without reading/popping a prior stack
value. Unexpected extra return values are consumed and rejected. Zero-return
handling is a direct-invocation contract safeguard, not a claim that the V89
live trace proved a zero-return case. Player.GetAvatar/GetHudStatus and RegionMgr.GetLocalPlayer/GetGameCamera
use it. GetLocalPlayerAvatar now always invokes the existing ivkr_pop_entity,
whose nil branch already consumes the result. Valid object typing/registration,
wrong-type errors and standard calls are retained. No watchdog, polling system,
replacement background script or retry loop is added. The pinned upstream
bgscript remains byte-identical and the original stack warning check remains.

Production-extracted Pluto replay passes 29 absent/present/absent/sentinel/type/return-count
cases and 1,000 missing-player calls with no residual values. It first reproduces
the old 92 nil values and old LotusAvatar constructor error. The full repaired
runtime parses using Pluto0.12.2. This mocks the native bridge, not the game.

Negative tooling findings: first extraction assumed LF input and rejected CRLF
source; parsing now normalizes line endings while fingerprints retain raw bytes.
The first two private builds correctly rejected Git's CRLF-to-LF warnings in
runtime.pluto and the existing feature manifest. Both were normalized to LF;
the manifest's exact logical content matches its source-before snapshot. Both
rejected logs are retained and neither binary was installed. The subsequent
warning-free initial candidate was packaged and retained without installation.
The final V90_R2 additionally covers zero/multiple native returns. Its clean
build is4,724,736bytes, SHA256
`17414E41548819C7378257D1CCA97DE5B20CCC2472A9F38112055E4215A1DED8`.

## Evidence, deployment and next live check

[Production replay and fingerprints](evidence/verification.json),
[hotfix ownership](evidence/hotfix.json),
[build log](evidence/private-build.log),
[rejected runtime line-ending build](evidence/private-build.rejected-crlf.log),
[rejected manifest line-ending build](evidence/private-build.rejected-manifest-crlf.log).
Source-before snapshots preserve the exact mixed-worktree predecessor.

The separately named deployment package is
`RENOVICE_DEPLOYMENTS/OPTIONAL_PLAYER_BRIDGE_V90_R2_2026-09-15`, with candidate DLL,
V89 rollback, repaired source, before source, fingerprints and preservation checks.
Package creation refuses overwriting. Installed state belongs to the dated receipt;
the package candidate manifest is not live acceptance.

The initial `OPTIONAL_PLAYER_BRIDGE_V90_2026-09-15` package is preserved as a
superseded candidate, not an installed repair. A package verifier initially
assumed archive_all.tmp remained after building; archive.php deletes that
temporary file. The final verifier instead decodes the generated archive,
checks its signature, finds those exact compressed bytes inside the actual
DLL and proves its runtime source equals the repaired file byte-for-byte.

Fresh test must include startup before a local player exists, ordinary gameplay,
F10 travel and return/menu transitions. Check that nil-avatar errors and residual
stack warnings do not recur, while background broadcasts and utilities remain
functional. F9 and diagnostics-off are separate checks. No combat math result is
promoted merely because this return-path repair passes.
