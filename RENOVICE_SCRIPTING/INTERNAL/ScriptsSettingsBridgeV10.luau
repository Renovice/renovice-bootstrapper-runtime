-- Internal RENOVICE UI bridge. This is compiled to DE-Luau bytecode and
-- installed beside user Inject scripts, but it is runtime infrastructure and
-- must not appear as a user-toggleable script.

local lotusUtilities = require("Lotus.Interface.LotusUtilities")

local function openScriptsSettings(parentMovie, settingsResource, elementsFunctionName, valueChangedFunctionName, doneFunctionName)
    if IsNull(parentMovie) or IsNull(settingsResource) then
        return false
    end

    -- Keep engine userdata dispatch in actual Luau bytecode. DE's VM resolves
    -- these NAMECALLs differently from the public C getfield/gettable helpers.
    local child = parentMovie:PushChildMovie(settingsResource)
    if IsNull(child) then
        return false
    end

    local nativeElements = _T._RENOVICEScriptsNativeElementsV10
    if nativeElements == nil then
        child:Close()
        return false
    end

    -- The stock binary-enable control is LotusUtilities.CHECKBOX. The prior
    -- child.TOGGLE interpretation came from an ambiguous decompiler alias and
    -- is false live: that userdata field remains nil. Resolve the same native
    -- enum module used by ThemedGenericSettings and fail closed on drift.
    local checkboxType = lotusUtilities.CHECKBOX
    if type(checkboxType) ~= "number" then
        child:Close()
        return false
    end

    _T[elementsFunctionName] = function()
        return nativeElements(checkboxType)
    end

    child:Execute("SetTitle", "SCRIPTS")
    child:Execute("SetNoElementsMessage", "NO SCRIPTS FOUND")
    -- Match stock settings: keep Confirm rendered while the form is clean,
    -- and keep the stock Confirm action active. Live evidence showed that an
    -- inactive-but-visible control can close later through ExitScreen and
    -- report Cancel even after the player selected Confirm.
    child:Execute("SetConfirmButtonVisibleWhenInactive", "true")
    child:Execute("SetConfirmButtonActive", "true")
    child:Execute("SetCallBack", doneFunctionName)
    child:Execute("SetValueChangedCallBack", valueChangedFunctionName)
    child:Execute("SetElementsFunction", elementsFunctionName)
    return true
end

_T._RENOVICEScriptsOpenBridgeV10 = openScriptsSettings

-- V26 roots this lifecycle table in the VM registry. `_T` is deliberately
-- retained above as a compatibility path, but the native menu now resolves
-- this hook from the registry so closing/reopening TopMenu or replacing `_T`
-- cannot orphan the opener.
return {
    activate = function()
        _T._RENOVICEScriptsOpenBridgeV10 = openScriptsSettings
    end,
    cleanup = function()
        if _T._RENOVICEScriptsOpenBridgeV10 == openScriptsSettings then
            _T._RENOVICEScriptsOpenBridgeV10 = nil
        end
    end,
    hooks = {
        openScriptsSettings = openScriptsSettings,
    },
}
