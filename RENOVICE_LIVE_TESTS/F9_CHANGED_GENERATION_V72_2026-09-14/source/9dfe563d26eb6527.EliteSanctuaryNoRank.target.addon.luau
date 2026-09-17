-- Sanctuary Onslaught: remove only the Warframe-rank requirement from the
-- mission descriptor produced inside TryLaunchOnslaught.
-- Exact target: Lotus.Interface.MissionRequirementUtilities
-- Stock body key: 9dfe563d26eb6527
-- Exact BuildMissionForLocation call: prototype 25, instruction 10
-- Prototype 25 is TryLaunchOnslaught and is shared only by its normal/elite
-- node selection. No runtime Symbol/string conversion is used.

local active = false

local function afterBuildMissionForLocation(prototype, instruction, arguments, results)
    if not active then return end
    if prototype ~= 25 or instruction ~= 10 then return end
    if type(results) ~= "table" then return end

    local mission = results[1]
    if IsNull(mission) then return end
    mission.maxSuitReq = false
end

return {
    generationProbe = "F9_CHANGED_GENERATION_V72",
    activate = function()
        active = true
    end,
    cleanup = function()
        active = false
    end,
    hooks = {
        nativeCalls = {
            BuildMissionForLocation = {
                after = afterBuildMissionForLocation,
            },
        },
    },
}
