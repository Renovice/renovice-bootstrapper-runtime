# SCRIPTS menu bridge restore — V24 — 2026-09-02

## Hypothesis and result

**Hypothesis:** The SCRIPTS row is absent because the crash-isolation removal
also removed the exact hidden NAMECALL bridge.

**Result: true.**

- The live `CustomScripts/Inject` directory contained no files.
- The live log explicitly reported `Scripts UI disabled: required NAMECALL
  bridge absent; stock TopMenu preserved`.
- The certified bridge still existed in the runtime source tree and passed the
  complete private-build verification immediately before restoration.
- V24 independently logged `safe runtime tick FIRST PASS
  mode=outer-vm-return`, proving the replacement scheduler is active without
  the removed HUD hook.

## Correction

Restore only:

`_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B`

The exact filename is a runtime capability gate and the file is hidden from
the user-facing script list. No gameplay scripts are restored and
`ScriptStates.json` is not rewritten. On the next natural TopMenu load the
runtime can attach the SCRIPTS row and use the bridge to open Generic Settings.
