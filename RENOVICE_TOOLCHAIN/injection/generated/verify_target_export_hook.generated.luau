_T = {}
local original = function(first, second)
    coroutine.yield("stock-paused")
    return first + second, nil, "stock-result", nil
end
ActivateAbility = original
-- Rename the built file to:
-- <exact-16-hex-body-key>.<name>.target.addon.lua_B
--
-- RENOVICE loads this chunk in the target module's exact closure environment.
-- Global ActivateAbility below therefore refers to that module's real export.

local active = false
local originalActivateAbility = nil
local wrappedActivateAbility = nil

local function reportAddonError(stage, message)
    local trace = _T.RENOVICE_TRACE
    if type(trace) == "function" then
        pcall(trace, stage, message)
    end
end

local function runAddonCallback(stage, callback, ...)
    local passed, message = pcall(callback, ...)
    if not passed then
        reportAddonError(stage, message)
    end
end

local function beforeActivateAbility(...)
    -- Add pre-cast behavior here. The original arguments are passed verbatim.
end

local function afterActivateAbility(...)
    -- Add post-cast behavior here. The original return values are passed
    -- verbatim. Most stock ActivateAbility exports return no values.
end

local function finishActivateAbility(...)
    runAddonCallback(
        "target-export.ActivateAbility.after.error",
        afterActivateAbility,
        ...
    )
    return ...
end

local function activate()
    if active then
        return
    end

    originalActivateAbility = ActivateAbility
    if type(originalActivateAbility) ~= "function" then
        error("RENOVICE_TARGET_EXPORT_ACTIVATEABILITY_NOT_FUNCTION")
    end

    wrappedActivateAbility = function(...)
        runAddonCallback(
            "target-export.ActivateAbility.before.error",
            beforeActivateAbility,
            ...
        )
        -- The stock Lua closure is called directly. Its errors, yields, varargs,
        -- nil results, and result count retain normal Lua behavior.
        return finishActivateAbility(originalActivateAbility(...))
    end

    ActivateAbility = wrappedActivateAbility
    if ActivateAbility ~= wrappedActivateAbility then
        ActivateAbility = originalActivateAbility
        wrappedActivateAbility = nil
        originalActivateAbility = nil
        error("RENOVICE_TARGET_EXPORT_ACTIVATEABILITY_INSTALL_READBACK")
    end
    active = true
end

local function cleanup()
    if not active then
        return
    end
    if ActivateAbility ~= wrappedActivateAbility then
        error("RENOVICE_TARGET_EXPORT_ACTIVATEABILITY_OWNERSHIP_CHANGED")
    end

    ActivateAbility = originalActivateAbility
    if ActivateAbility ~= originalActivateAbility then
        ActivateAbility = wrappedActivateAbility
        error("RENOVICE_TARGET_EXPORT_ACTIVATEABILITY_CLEANUP_READBACK")
    end
    wrappedActivateAbility = nil
    originalActivateAbility = nil
    active = false
end

local lifecycle = {
    activate = activate,
    cleanup = cleanup,
}

local firstWrapper = nil
lifecycle.activate()
firstWrapper = ActivateAbility
assert(firstWrapper ~= original)
lifecycle.activate()
assert(ActivateAbility == firstWrapper)

local thread = coroutine.create(ActivateAbility)
local paused = table.pack(coroutine.resume(thread, 2, 3))
assert(paused.n == 2 and paused[1] == true and paused[2] == "stock-paused")
local completed = table.pack(coroutine.resume(thread))
assert(completed.n == 5 and completed[1] == true)
assert(completed[2] == 5 and completed[3] == nil)
assert(completed[4] == "stock-result" and completed[5] == nil)

lifecycle.cleanup()
assert(ActivateAbility == original)
lifecycle.cleanup()
assert(ActivateAbility == original)

ActivateAbility = function() error("stock failure") end
local failingOriginal = ActivateAbility
lifecycle.activate()
assert(not pcall(ActivateAbility))
lifecycle.cleanup()
assert(ActivateAbility == failingOriginal)

ActivateAbility = original
lifecycle.activate()
local ownedWrapper = ActivateAbility
local foreignWrapper = function() end
ActivateAbility = foreignWrapper
assert(not pcall(lifecycle.cleanup))
assert(ActivateAbility == foreignWrapper)
ActivateAbility = ownedWrapper
lifecycle.cleanup()
assert(ActivateAbility == original)

ActivateAbility = 7
assert(not pcall(lifecycle.activate))
assert(ActivateAbility == 7)
print("TARGET EXPORT HOOK LIFECYCLE PASS install, idempotence, yield, varargs, nil returns, stock error, ownership conflict, cleanup")
