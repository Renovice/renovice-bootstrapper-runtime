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
