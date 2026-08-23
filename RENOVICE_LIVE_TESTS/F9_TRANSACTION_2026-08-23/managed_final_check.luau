local global = ...
local token = 404
local active = false

local function activate()
    if active then
        return
    end
    if global.RENOVICE_MANAGED_TEST_TOKEN ~= 0 then
        error("RENOVICE_FINAL_ACTIVATE_DELETE_CLEANUP_MISSING")
    end
    if global.RENOVICE_ORDINARY_TEST_TOKEN ~= 4004 then
        error("RENOVICE_FINAL_ACTIVATE_DELETE_VERIFIER_MISSING")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = token
    active = true
end

local function cleanup()
    if not active then
        return
    end
    if global.RENOVICE_MANAGED_TEST_TOKEN ~= token then
        error("RENOVICE_FINAL_CLEANUP_BAD_TOKEN")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = 0
    global.RENOVICE_ORDINARY_TEST_TOKEN = 0
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
