-- RENOVICE_NAME_HASH_SEED: 768e5ed0
-- RENOVICE opt-in test helper (one-shot Inject): travel to Yuvan Peak without the star-chart quest lock.
-- Client 44.1.0 (2026.10.06.16.12). Does exactly what the game does after its node checks pass:
--   MeliciaConvoSetup.MelicaFastTravel (Chrysalith fast travel): SetHubSpawnLocation(0),
--   SendSquadMission(cjson.encode({ name = <node> .. HUB_TAG })), SquadSetCountdownTimer(0.5);
--   EE.log of a normal star-chart trip: Set squad mission: {"difficulty":0.5,"name":"IceBladeHUB_HUB"}.
-- Purpose: reproduce "invited to a friend's Yuvan Peak without Angels of the Zariman" on a test account.
-- Runs only on the ship (LotusUtilities.GetUIMode() == UI_MODE_IN_SPACE_SHIP), so it does nothing at login or in
-- missions. Use: Scripts menu -> enable -> F9 on your ship -> disable again (a one-shot runs after every committed
-- generation). Raw-hash source: engine names hash with the U44 seed as in stock; LotusUtilities members are plain.
local lib = require("Lotus.Interface.LotusUtilities")
local mode = lib.GetUIMode()
if mode ~= lib.UI_MODE_IN_SPACE_SHIP then
    print("RENOVICE Teleport to Yuvan Peak: skipped, not on the ship (UI mode " .. tostring(mode) .. ")")
    return
end
local mission = { name = nil }
mission.name = "IceBladeHUB_HUB"
gGameData:SetHubSpawnLocation(0)
gMatchingService:SendSquadMission(cjson.encode(mission))
gMatchingService:SquadSetCountdownTimer(0.5)
print("RENOVICE Teleport to Yuvan Peak: SendSquadMission IceBladeHUB_HUB")
