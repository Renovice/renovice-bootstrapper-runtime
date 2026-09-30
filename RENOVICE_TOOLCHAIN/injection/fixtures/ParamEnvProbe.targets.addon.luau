-- RENOVICE_HASH_FIELD: scoreGoal
-- Gate fixture and opt-in live probe for contract R10 (2026-09-30): a
-- luaCalls[P].before callback receives the called closure's environment table
-- as its fifth argument. Compiled and executed by
-- RENOVICE_TOOLCHAIN/injection/verify_lua_call_environment.ps1.
--
-- Target: 44.0.2 Modes.TerritoryMission (c9605470a8c47d8d), prototype 35
-- (Territory, the Interception level trigger, a direct child of the module
-- root). The level trigger passes `_scoreGoal` (1450 on most decoded maps).
-- That parameter is a global of the CALLING instance's environment; this
-- addon's own global `scoreGoal` is nil (live 2026-09-11, finding PG-1).
--
-- The directive above makes `environment.scoreGoal` a hashed field read and
-- write (native-name hash 3a44eae1 with the U44 seed), the same key the stock
-- GETGLOBAL scoreGoal reads from that environment.
--
-- Per instance (the environment is the instance identity):
--   first entry: record the observed number, write observed x SCALE;
--   later entries: the written value is still there -> skip; the observed
--   value is back (the parameters were applied again) -> write again;
--   anything else -> leave it alone (drift, fail closed).
-- cleanup restores the observed value in every live instance that still holds
-- the written one. A runtime without R10 passes no fifth argument: nothing is
-- written. The probe is not part of any package.
local SCALE = 2
local records = setmetatable({}, { __mode = "k" }) -- environment -> record, or false (unsupported or drifted)
local active = false

local function before(prototype, arguments, upvalues, trace, environment)
	if not active then return end
	if type(environment) ~= "table" then return end
	local record = records[environment]
	local current = environment.scoreGoal
	if record == nil then
		if type(current) ~= "number" then
			records[environment] = false
			return
		end
		local written = current * SCALE
		environment.scoreGoal = written
		records[environment] = { observed = current, written = written }
		return
	end
	if record == false then return end
	if current == record.written then return end
	if current == record.observed then
		environment.scoreGoal = record.written
		return
	end
	records[environment] = false
end

local function cleanup()
	active = false
	for environment, record in pairs(records) do
		if record and environment.scoreGoal == record.written then
			environment.scoreGoal = record.observed
		end
		records[environment] = nil
	end
end

return {
	targets = {
		["c9605470a8c47d8d"] = {
			activate = function() active = true end,
			cleanup = cleanup,
			hooks = {
				luaCalls = {
					[35] = { before = before },
				},
			},
		},
	},
}
