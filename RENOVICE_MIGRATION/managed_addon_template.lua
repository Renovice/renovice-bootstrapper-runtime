-- Compile this source to <Name>.addon.lua_B with the certified DE-Luau compiler.
-- Staging must have no gameplay side effects. Put those in activate().

local active = false

local function activate()
    if active then
        return
    end
    active = true

    -- Install this generation's native callback/listener/resource here.
end

local function cleanup()
    if not active then
        return
    end

    -- Remove only the callback/listener/resource owned by this generation.
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
