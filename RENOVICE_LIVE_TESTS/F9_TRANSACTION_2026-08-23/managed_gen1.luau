local global = ...
local token = 101
local active = false

local function activate()
    if active then
        return
    end
    local previous = global.RENOVICE_MANAGED_TEST_TOKEN
    if previous ~= nil and previous ~= 0 then
        error("RENOVICE_GEN1_ACTIVATE_BAD_PREVIOUS")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = token
    active = true
end

local function cleanup()
    if not active then
        return
    end
    if global.RENOVICE_MANAGED_TEST_TOKEN ~= token then
        error("RENOVICE_GEN1_CLEANUP_BAD_TOKEN")
    end
    global.RENOVICE_MANAGED_TEST_TOKEN = 0
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
