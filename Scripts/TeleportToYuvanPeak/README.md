# Teleport to Yuvan Peak (opt-in test helper, one-shot Inject)

Client 44.1.0 (2026.10.06.16.12). Travels to Yuvan Peak (`IceBladeHUB_HUB`) without the star chart's quest lock.
It reproduces "a friend invited me to Yuvan Peak" for testing the Icebind's access rules on an account that
lacks Angels of the Zariman.

## What it does

The same three calls the game makes after its own checks pass:

| Call | Where the game makes it |
|---|---|
| `gGameData:SetHubSpawnLocation(0)` | `MeliciaConvoSetup.MelicaFastTravel` (Chrysalith fast travel) |
| `gMatchingService:SendSquadMission(cjson.encode({ name = "IceBladeHUB_HUB" }))` | as above; EE.log of a normal trip: `Set squad mission: {"difficulty":0.5,"name":"IceBladeHUB_HUB"}` |
| `gMatchingService:SquadSetCountdownTimer(0.5)` | as above |

It only acts on your ship (`LotusUtilities.GetUIMode() == UI_MODE_IN_SPACE_SHIP`). Anywhere else it logs
`skipped` and does nothing.

## Build

`derecomp recompile-u44 "Teleport to Yuvan Peak.luau" "Teleport to Yuvan Peak.lua_B"` (raw-hash source; 572 bytes,
re-parses). Name classes match stock:

- **Hashed with seed 768e5ed0, as in MeliciaConvoSetup / LotusUtilities:** require, print, tostring, gGameData,
  gMatchingService, cjson.encode, SetHubSpawnLocation, SendSquadMission, SquadSetCountdownTimer.
- **Plain strings, as stock:** the LotusUtilities members GetUIMode and UI_MODE_IN_SPACE_SHIP, and the `name` field.

## Install

1. Copy `Teleport to Yuvan Peak.lua_B` to `OpenWF\CustomScripts\Inject\`.
2. Keep it disabled in `ScriptStates.json` (`"oneshot:teleport to yuvan peak.lua_b": false`).

## Use

1. On your ship, open SCRIPTS and enable `[ONE-SHOT] Teleport to Yuvan Peak`.
2. Press F9. It runs once.
3. Disable it again, because a one-shot runs after every committed startup / F9.

Not live-tested yet.
