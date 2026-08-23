local global = ...
local token = 303
local active = false

local function activate()
    if active then
        return
    end
    if global.RENOVICE_MANAGED_TEST_TOKEN ~= 0 then
        error("RENOVICE_GEN3_ACTIVATE_ROLLBACK_OR_CLEANUP_BAD")
    end
    if global.RENOVICE_ORDINARY_TEST_TOKEN ~= 2002 then
        error("RENOVICE_GEN3_ACTIVATE_ORDINARY_GEN2_MISSING")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = token
    active = true
end

local function cleanup()
    if not active then
        return
    end
    if global.RENOVICE_MANAGED_TEST_TOKEN ~= token then
        error("RENOVICE_GEN3_CLEANUP_BAD_TOKEN")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = 0
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
