-- Opt-in live probe and gate fixture for the R4 retire-all signal (S5,
-- 2026-09-30). Compiled by verify_lua_call_retirement.ps1.
--
-- Target: 44.0.2 SurvivalMission (f10a043e7f825db2). Prototypes 31, 61, 67,
-- 68 and 69 are all created directly by the module root (frame_79); 31 and 69
-- are engine callbacks that may not fire early in a mission.
--
-- It changes no game value. Whichever hook runs first returns the two-value
-- form. An R4 runtime retires every hook of this addon for the mission
-- instance at once (one LUACALL_RETIRE event=retire-all line, then no further
-- dispatch and, with no other armed hook, a closed fast gate). An R3 runtime
-- reads only the first value and retires just the calling hook; a pre-R3
-- runtime ignores both.
local RETIRE = "RENOVICE_RETIRE"
local RETIRE_ALL = "RENOVICE_RETIRE_ALL"

local function idle(prototype, args, upvalues)
	return RETIRE, RETIRE_ALL
end

return {
	targets = {
		["f10a043e7f825db2"] = {
			hooks = {
				luaCalls = {
					[31] = { before = idle },
					[61] = { before = idle },
					[67] = { before = idle },
					[68] = { before = idle },
					[69] = { before = idle },
				},
			},
		},
	},
}
