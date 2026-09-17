function IsNull(value)
    return value == nil
end

local addon = (function()
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

end)()
local after = addon.hooks.nativeCalls.BuildMissionForLocation.after

local inactive = { maxSuitReq = true }
after(25, 10, {}, { inactive })
assert(inactive.maxSuitReq == true, "Inactive addon must preserve the mission descriptor")

addon.activate()

local elite = { maxSuitReq = true }
after(25, 10, {}, { elite })
assert(elite.maxSuitReq == false, "TryLaunchOnslaught descriptor must clear the suit-rank requirement")

local wrongPrototype = { maxSuitReq = true }
after(24, 10, {}, { wrongPrototype })
assert(wrongPrototype.maxSuitReq == true, "Unrelated prototype must be unchanged")

local wrongInstruction = { maxSuitReq = true }
after(25, 11, {}, { wrongInstruction })
assert(wrongInstruction.maxSuitReq == true, "Unrelated instruction must be unchanged")

after(25, 10, {}, {})
after(25, 10, {}, nil)

addon.cleanup()
local cleaned = { maxSuitReq = true }
after(25, 10, {}, { cleaned })
assert(cleaned.maxSuitReq == true, "Cleanup must disable the mutation")

print("ESO CALLSITE ADDON PASS exact 25:10 BuildMissionForLocation, maxSuitReq false, no Symbol/string guess")
