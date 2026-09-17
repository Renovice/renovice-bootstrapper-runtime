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

return {
    activate = activate,
    cleanup = cleanup,
}
