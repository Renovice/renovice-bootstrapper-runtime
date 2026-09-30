-- Plain-Luau harness for ParamEnvProbe.targets.addon.luau (contract R10).
-- The gate prepends `PARAM_ENV_MODULE = function(...) <fixture source> end`.
-- It plays the host: activate, then luaCalls[35].before called exactly as the
-- R10 runtime calls it (prototype, arguments, upvalues, trace, environment),
-- then cleanup. Plain Luau keys `environment.scoreGoal` by string; the gate
-- checks the hashed-key class on the compiled DE bytes separately.
local failures = 0
local function check(condition, label)
	if condition then
		print("ok   " .. label)
	else
		failures = failures + 1
		print("FAIL " .. label)
	end
end

local addon = PARAM_ENV_MODULE()
local target = addon.targets["c9605470a8c47d8d"]
check(type(target) == "table", "target c9605470a8c47d8d declared")
local before = target.hooks.luaCalls[35].before
check(type(before) == "function", "luaCalls[35].before declared")

local first = { scoreGoal = 1450 }
before(35, {}, {}, nil, first)
check(first.scoreGoal == 1450, "inactive addon writes nothing")

target.activate({})
before(35, {}, {}, nil, first)
check(first.scoreGoal == 2900, "first entry: observed 1450 -> written 2900")
before(35, {}, {}, nil, first)
check(first.scoreGoal == 2900, "second entry: written value kept (no compounding)")
first.scoreGoal = 1450
before(35, {}, {}, nil, first)
check(first.scoreGoal == 2900, "observed value back: written again")

local second = { scoreGoal = 180 }
before(35, {}, {}, nil, second)
check(second.scoreGoal == 360, "second instance: its own map value 180 -> 360")
check(first.scoreGoal == 2900, "second instance leaves the first instance unchanged")

first.scoreGoal = 7
before(35, {}, {}, nil, first)
check(first.scoreGoal == 7, "drifted value: left alone (fail closed)")
first.scoreGoal = 1450
before(35, {}, {}, nil, first)
check(first.scoreGoal == 1450, "after drift the instance stays unowned")

local missing = {}
before(35, {}, {}, nil, missing)
check(missing.scoreGoal == nil, "instance without the parameter: nothing written")

local old = { scoreGoal = 1450 }
before(35, {}, {}, nil)
before(35, {}, {}, nil, nil)
check(old.scoreGoal == 1450, "runtime without R10 (no fifth argument): nothing written")

target.cleanup()
check(second.scoreGoal == 180, "cleanup restores the observed value where the written one is still there")
check(first.scoreGoal == 1450, "cleanup leaves a drifted instance alone")
before(35, {}, {}, nil, second)
check(second.scoreGoal == 180, "after cleanup nothing is written")

if failures == 0 then
	print("PARAM ENV HARNESS PASS checks=16")
else
	print("PARAM ENV HARNESS FAIL failures=" .. failures)
end
