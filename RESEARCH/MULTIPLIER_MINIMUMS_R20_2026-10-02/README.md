# R20 multiplier minimums: 0.001 through SCRIPT SETTINGS (gate only, 2026-10-02)

- **Branch:** `fix/r20-multiplier-minimums-2026-10-02` (worktree `repos/runtime/bootstrapper-runtime-wt-r19`), from R19
  `7dcd7a9` (runtime = R17 `45ed7b0`). Producer: ability editor `fix/missions-r20-multiplier-minimums-2026-10-02`, record
  `RESEARCH/MISSIONS_R20_MULTIPLIER_MINIMUMS_2026-10-02/README.md` there. Contract: `CONTRACT_PHASE1.md` R20.
- **No runtime change.** The installed R17 DLL `304b57de…` stays; nothing under `renovice/`, `owf_*` or the bridge changed.
- **Status:** gate PASS offline. Nothing is live, nothing deployed, nothing pushed.

## Hypothesis

The SCRIPT SETTINGS host and bridge accept, show and store a minimum of 0.001 without rounding (no 2-decimal formatting).
**Result: True** (static source reading and the render gate below).

| Step | Code (unchanged) | 0.001 |
|---|---|---|
| Declaration parse | `renovice/settings_core.hpp` `parse_value`: `std::from_chars` into double | exact |
| Validation | `validate_value`: `value < minimum` (double) | accepted; 0.0009 refused |
| Row text | `renovice/settings_ui_core.hpp` `display_number`: whole numbers without a point, else `%.6g` | "0.001x" |
| INPUTBOX content | `json::number_text`: shortest round trip (`std::to_chars`) | "0.001" |
| Bridge validator | `ScriptSettingsBridgeV1.luau` `textValidator`: `tonumber(text) < spec.minimum`; `SettingsRowView.minimum` is float32 and DE VM numbers are float32, so both sides are float32(0.001) | valid |
| Values file | `write_values_file` -> `number_text`; re-read with `from_chars` | 0.001 exactly |
| Engine writer | `engine_params_core.hpp` `override_number` (float32) | n x 0.001f, n / 0.001f, scale_count at least 1 |

## Change (gate only)

- `RENOVICE_TOOLCHAIN/scripts_ui/verify_script_settings_render.ps1` section **1e** and `Invoke-Harness -R20`.
- `RENOVICE_TOOLCHAIN/scripts_ui/settings_render/harness_driver.luau`: `HARNESS_R20` walk (type a value into the stock INPUTBOX,
  Confirm, check the row, reopen and check the field text; a value under a floor: Back, stock message, row unchanged).
- `RENOVICE_TOOLCHAIN/scripts_ui/settings_render/fixtures/r20/`: the R20 Missions `package.json` (`acc2256e…`) and
  `literals.json` (`96a97899…`), the build's `Settings/Missions.json`, the 35 target keys.

## Gate result (`verify_script_settings_render.ps1`, whole gate PASS)

- Fixture: the 51 "x" values are fractional and accept 0.001 except the five recorded floors.
- Host tape (exact C++ page model, staging, values-file writer, live-literal synthesis with the U44 stock corpus): 0.001 staged
  as typed text for Railjack fighters (`value:`), the Railjack master kept number (`stored:`), the Exterminate master kept
  number (scale_inverse), Void Flood capacity (scale_count), Kela health duo (live literal number constant) and Capture solo
  (int before R20) -> accepted; Void orb value 0.001 -> `REJECT outside-min-max` (floor 0.06). Values file holds exactly 0.001
  (`EXPECTFILE ... value=0.001`, exact double compare after write and re-read); the Kela plan synthesizes (`synthesis=pass`).
- Bridge through the stock ThemedGenericSettings render: 7 planned host calls exactly; each row reads "<row>: 0.001x" after
  Confirm; the reopened page shows "0.001" in the INPUTBOX (content and the drawn field text); the floor value shows the stock
  message on Back and the row keeps "x1 (5-60) (default)".
- Installed-state replay (`verify_addon_settings.ps1 -Package <R20 Missions>;<installed Frost>;<installed Octavia> -Settings
  ... -ScriptStates ...`, read-only copies): ADDON SETTINGS GATES PASS, Missions `declarations=508 rejected=0 effective=6`.

## Limits

The harness runs the bridge in plain Luau (double numbers); the float32 equality of the bridge comparison is reasoned from the
VM number type and the float32 `SettingsRowView`, not run in the game VM. Nothing is live.
