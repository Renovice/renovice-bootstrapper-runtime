-- Deterministic fixture for the RENOVICE multi-target target-addon contract
-- (2026-09-29). It is compiled by verify_multi_target_addon.ps1 and is never
-- deployed. The three keys are the current 44.0.2 mission modules also used by
-- the single-key generated mission addons; any lowercase 16-hex string constant
-- in a `.targets.addon` file is a declared target.
local owned = {}

local function lifecycle(name)
	return function()
		owned[name] = true
	end, function()
		owned[name] = nil
	end
end

local rootActivate, rootCleanup = lifecycle("default")
local tierActivate, tierCleanup = lifecycle("tier")

return {
	-- Defaults inherited by entries that leave activate/cleanup absent.
	activate = rootActivate,
	cleanup = rootCleanup,
	-- Reserved for a future in-game settings overlay; ignored by this runtime.
	label = "Missions fixture",
	-- Uppercase 16-hex text is deliberately NOT a declaration.
	note = "F10A043E7F825DB2",
	targets = {
		["f10a043e7f825db2"] = {
			hooks = { luaCalls = { [19] = { before = function(call) end } } },
		},
		["6fa60841c9e0f207"] = {
			hooks = { luaCalls = { [79] = { before = function(call) end } } },
		},
		["caec63d8e739b693"] = {
			activate = tierActivate,
			cleanup = tierCleanup,
			hooks = { luaCalls = { [75] = { before = function(call) end } } },
		},
	},
}
