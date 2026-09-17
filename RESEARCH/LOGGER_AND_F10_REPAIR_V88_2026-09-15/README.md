# Logger and OpenWF F10 bridge repair, V88

**DEPLOYED2026-09-15T20:11:15.6381609Z.** DLL/F10 script pair verified, immutable
package43artifacts/all20 prior gameplay-script/config entries PASS. Source log
baseline164973905. Existing Hotkeys/O/config unchanged. Fresh startup, F10
native entry, caster-at-hit, F9/off PENDING LIVE. First installer refused old
PID1932 before any write; after repeated user game-closed/install instruction
the exact old game process was stopped and installation passed. Rejected attempt
log preserved. Rollback is paired V87 DLL/oldF10 script, not a gameplay disable.

Package [receipt](../../RENOVICE_DEPLOYMENTS/LOGGER_AND_F10_REPAIR_V88_2026-09-15/evidence/deployment-receipt.json)
and [read-only verifier](../../RENOVICE_DEPLOYMENTS/LOGGER_AND_F10_REPAIR_V88_2026-09-15/tools/verify_package.ps1)
are separate from fresh live evidence. Use -Installed after deployment.

Built candidate2026-09-15. User explicitly requested both fixes. This candidate
changes existing game-tag translation and diagnostic observation; no parallel
Lua runtime, repeated gameplay setter, polling addon or ability-specific C++.
Raw DE injection/replacements/Mallet/Ice Wave formulas remain unchanged.

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| Numeric121 fully fixes F10 | False live in V87 | User still reports no entry after reload. Script log empty; harmless print-only /start_script_inline probe remains queued without executing. The scheduler is not running scripts, beyond the confirmed string-parser defect. |
| Old OpenWF UI capture recognizes current userdata | False in source/current tag evidence | owf_luau.hpp legacy userdata8 versus established deployed_userdata_tag9 and observed V87 GetHudStatus tag9. handle_set_global rejects tag9 gFlashMgr and clears openwf_ui_state. |
| Changing only the userdata capture comparison repairs all game API bridging | False in source | The old public bridge also reads/writes string5/table6/function7/userdata8 and exposes those to Pluto. Current certified layout is6/7/8/9. Translate all39 old public tag references in main.cpp/owf_scripting.cpp; retain canonical enum and injector's established dual-layout handling. |
| Unknown game layouts may be assumed current | False | Profile selected only after existing U43 build-label/executable-hash certification. Legacy supported versions retain original tags; unknown/new builds retain existing startup rejection. |
| Pickup calculations starve combat stats | True in V87 |1024 operation203 calls/unknown snapshots exhaust shared1024 budget before hits. V88 has independent calculation256/combat1024 limits at32768 configured events; HUD queues use neither counter. Existing F9 resets both. |
| Scalar calculation overloads warrant unknown stat/buff snapshots | False | No caster exists for that overload. Retain stock calculation before/after; omit manufactured all-unavailable snapshots/failed nil-caster buff calls. Actual source/damage known-caster observations remain. |
| Actual generic owner JSON is parsed | False before / true after offline | Typed-only parser misses345 raw owner records. V88 accepts exact TRACE event/id/terminal JSON, validates schema/id, preserves raw line and source filters; replay recovers all345. No nearest-time joins. |

The UI-state gate, owner thread, base-ci idle check, native Application boundary,
panic/stack restoration, F9 transaction boundary and ordinary Pluto scheduler
remain intact. `/status` now exposes current userdata tag, captured UI state/
owner, native-frame hook/first-pass, and original input-filter permission. These
are reads of existing state rather than a new per-frame logger. F10 emits three
bounded operation-phase messages in the existing OpenWF script log, or entry/
login-required when logged out. Numeric121/O/other config are preserved.

Tests: production budget/type helper with legacy/current layouts; actual Lua
observer flood256 scalar calculations then known SetSource/DamageDD snapshots;
observer semantics +DE roundtrip/SIR; existing analyzer cases; generic JSON
escaped strings/identity rejection; old fixed V87 capture reanalysis345 owners;
exact F10 Lua source replay. F10 replay uses mocked Luau, not live Pluto/Engine.
Build4722176 bytes, SHA
6628199831653EB028F81B75EC7AC4B76AC406050CE777E7C458BB2005C9E175,
zero warnings/errors/private x64. Observer20825 bytes SHA
ED98D24840C50B07FF2625AB6B3F3B5E108D39D64959DBB9967C05EDC63F541E.

First build rejected: Sun accidentally discovered backup injection.cpp under
source-before/renovice, failed missing relative include and duplicate object
warning. Backup C++ files retain bytes with .cpp.before suffix; clean rebuild
removed duplicate. Second build rejected Git CRLF-to-LF warnings; changed public
bridge source normalized to repository LF conventions, clean third build passes.
Both rejected logs retained under evidence; no rejected DLL deployed. A fixture
initially assumed analyzer returned an object; corrected to read its OutputPath.

Source-before stores exact prior files (C++ snapshot extensions intentionally
noncompileable), V87 DLL and current session's status/queued probe evidence.
Deployment package preserves DLL/F10 script pair and all20 existing custom
scripts/config. Fresh startup, actual F10 entry, effective combat stats and F9/
off remain **PENDING LIVE**. Direct NameTag/full mod/shard/buff contribution
enumeration is not implemented or inferred; actual type paths/timers remain
valid evidence. Do not claim V88 fixed these unrelated limitations.
