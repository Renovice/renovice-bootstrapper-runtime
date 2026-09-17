-- Embedded in the injector DLL. No ability names, gameplay behavior, globals
-- published into stock modules, or additional installed script files.
local bindings = setmetatable({}, { __mode = "k" })
local originals = setmetatable({}, { __mode = "k" })

local function compose(dispatch, original)
    if dispatch == nil then
        return original
    end
    if original == nil then
        return function(...)
            return dispatch(...)
        end
    end
    return function(target, damage, ...)
        -- Call the stock Lua closure directly, preserving yielding, extra
        -- arguments and all return values (including nils).
        local function finish(...)
            dispatch(target, damage)
            return ...
        end
        return finish(original(target, damage, ...))
    end
end

return {
    activate = function() end,
    cleanup = function() end,
    prepareSource = function(receiver, dispatch)
        return compose(dispatch, originals[receiver])
    end,
    commitSource = function(receiver, dispatch)
        bindings[receiver] = dispatch
    end,
    prepareOriginal = function(receiver, original)
        return compose(bindings[receiver], original)
    end,
    commitOriginal = function(receiver, original)
        originals[receiver] = original
    end,
}
