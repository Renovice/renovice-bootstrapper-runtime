# CustomScripts layout audit — 2026-09-09

Audited directory:
`C:/Users/Bartek/OneDrive/Dokumenter/Warframe/OpenWF/CustomScripts`

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The three root `.lua_B` files are disposable clutter. | Each has the required 16-hex replacement key and a matching enabled `replacement:` policy: Octavia Amp `4d3bae2a1db4f2e6`, Riven Lock `75904fc0ab2857a7`, and Octavia Metronome `fe3e36bc752a06cc`. | **FALSE** |
| The two `Inject` bytecode files are disposable. | The V10 file is the exact hidden Scripts-menu bridge; the other is the accepted V57 Mallet target addon. Both retain pinned hashes. | **FALSE** |
| `renovice.cfg`, `riven_lock.cfg`, or `ScriptStates.json` are logs. | They own runtime flags, Riven UI enablement, and per-script policy. | **FALSE** |
| All root log-like files are current runtime inputs. | `renovice_source.log`, `renovice_fault.log`, and the dump are generated outputs. The `wf_*` files are historical writers, and zero-byte `DEBUG_LOG` has no active source reference. | **FALSE** |
| The missing historical Mallet hook-shim policy still controls behavior. | No matching replacement file exists; removing only that stale JSON entry leaves the three present replacements and current Mallet addon enabled. | **FALSE** |
| Cleanup requires deleting evidence or changing gameplay scripts. | All generated output was moved with matching hashes; no `.lua_B`, config, bridge, or addon bytes changed. | **FALSE** |

## Final layout

- Root: three full replacements, `renovice.cfg`, `riven_lock.cfg`, cleaned
  `ScriptStates.json`, `HOW_TO_ADD_SCRIPTS.md`, and Windows `desktop.ini`.
- `Inject`: Scripts bridge V10 and Mallet target addon.
- `Logs`: current `renovice_source.log` and `renovice_fault.log`.
- `Logs/Legacy`: `wf_lua_redirect.log`, `wf_swf_probe.log`, and empty
  `DEBUG_LOG` retained as old evidence.
- `Diagnostics`: `renovice_fault.dmp` and the existing
  `TopMenu.current.lua_B` diagnostic capture.

## Pinned functional hashes

| File | Bytes | SHA-256 |
|---|---:|---|
| `4d3bae2a1db4f2e6 (Octavia Amp buff-no-distance).lua_B` | 13,181 | `98C807964BA2DAB40FB3A91F307B6D9E30C6D536B8A0ABCA0F0D93BE1E6605C7` |
| `75904fc0ab2857a7 (Riven Lock script).lua_B` | 31,594 | `9FBFF2A5A83EE4DA76EB08E79D145FF28D971E9184D223D9D0CB51148693AC6F` |
| `fe3e36bc752a06cc (Octavia Metrone allscript).lua_B` | 28,385 | `551AAF2FC2AD0AA93AC4A55329CD1290A404510A75FF993A9A022D8FD81CF580` |
| `Inject/_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B` | 1,111 | `153E5E580FB0D98DDD63C0DE92D46398F6B87B721E69B51885719B50EEF04C82` |
| `Inject/08faf07b504d058f.MalletOverguardAndCard.target.addon.lua_B` | 2,732 | `36D2E3EC21E5879FBC0129A82139CF35E53D5FC95C8A82443D106EFF6FBDF049` |
| `renovice.cfg` | 254 | `4FBB8F24B0C0677DEAB3670283DF0109906BB4546F650CBD15521E2564CCBF70` |
| `ScriptStates.json` | 368 | `04490B5BDA30A18FA047D56ADFEA710FEAC98B58B2EABF31D2131BD29613B1D3` |

## Proof boundary

V59 package and deployed-state verification pass with zero root generated
files. V58 remains the last live-accepted gameplay baseline. V59 startup and
gameplay remain unobserved until the user launches the game once.
