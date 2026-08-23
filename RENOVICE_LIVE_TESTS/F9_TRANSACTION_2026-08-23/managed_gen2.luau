local global = ...
local token = 202
local active = false

local function activate()
    if active then
        return
    end
    if global.RENOVICE_MANAGED_TEST_TOKEN ~= 0 then
        error("RENOVICE_GEN2_ACTIVATE_CLEANUP_MISSING")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = token
    active = true
end

local function cleanup()
    if not active then
        return
    end
    if global.RENOVICE_MANAGED_TEST_TOKEN ~= token then
        error("RENOVICE_GEN2_CLEANUP_BAD_TOKEN")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = 0
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
