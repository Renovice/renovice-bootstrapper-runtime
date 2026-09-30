-- Opt-in live probe and gate fixture for the luaCalls.before retire-after-use
-- primitive (2026-09-30). Compiled by verify_lua_call_retirement.ps1.
--
-- Target: 44.0.2 SurvivalMission (f10a043e7f825db2). Prototypes 67 and 68 are
-- the hot functions from the 2026-09-29 live run (more than 262,144 calls in
-- about 200 s); both are created directly by the module root.
--
-- It changes no game value. Each hook marks the instance it sees (keyed by the
-- first upvalue's identity when it is a table, weakly) and returns the retire
-- sentinel, so every hook dispatches about once per mission instance and is
-- then rejected before any Lua entry. With Diagnostics on, the log shows one
-- LUACALL_RETIRE event=retire line per prototype and instance.
local RETIRE = "RENOVICE_RETIRE"
local seen = setmetatable({}, { __mode = "k" })

local function probe(prototype, args, upvalues)
	local owner = upvalues and upvalues[1]
	if type(owner) == "table" then
		seen[owner] = true
	end
	return RETIRE
end

return {
	targets = {
		["f10a043e7f825db2"] = {
			hooks = {
				luaCalls = {
					[67] = { before = probe },
					[68] = { before = probe },
				},
			},
		},
	},
}
