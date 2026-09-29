-- Opt-in live probe for the RENOVICE multi-target target-addon primitive
-- (2026-09-29). It changes no gameplay: it declares no hooks and its lifecycle
-- functions only flip a local flag. Its only purpose is renovice_source.log
-- evidence that ONE file with ONE Scripts row binds lazily to several
-- unrelated modules:
--   RENOVICE Inject PASS MultiTargetProbe.targets.addon.lua_B target=<key> ...
--   RENOVICE TARGET ADDON PASS key=<key> ...
-- The keys are the 44.0.2 mission modules targeted by the current generated
-- single-key mission addons, so a normal mission run loads at least one.
-- Never install it by default; copy it into CustomScripts\Inject only for the
-- live acceptance test and remove it afterwards.
local active = false

return {
	activate = function()
		active = true
	end,
	cleanup = function()
		active = false
	end,
	targets = {
		["f10a043e7f825db2"] = {},
		["6fa60841c9e0f207"] = {},
		["caec63d8e739b693"] = {},
	},
}
