-- Internal RENOVICE SCRIPT SETTINGS bridge (V1), 2026-09-30.
--
-- Optional bootstrapper infrastructure, loaded after the managed-addon
-- transaction commits; its absence or failure removes only the SCRIPT
-- SETTINGS pause-menu row (SCRIPTS, Inject, target addons, Replacement and F9
-- are unaffected). It is never a player-toggleable script.
--
-- It renders host-provided page descriptors with DE's own GenericSettings
-- screen and the stock row types TITLE, SPACER, CHECKBOX, INPUTCOUNT, INPUTBOX,
-- TOGGLE and BUTTON, exactly like the shipped SCRIPTS bridge (V10): NAMECALLs on
-- engine userdata stay in bytecode; every value change is only STAGED in the
-- host; the root page close applies one batch through the ordinary F9
-- transaction. This file holds no state between sessions beyond the natives
-- of the current open.

local lotusUtilities = require("Lotus.Interface.LotusUtilities")

local host = {
    resource = nil,
    getPage = nil,
    stage = nil,
    done = nil,
    act = nil,
}
local pageSerial = 0

local function resolveTypes()
    local types = {
        TITLE = lotusUtilities.TITLE,
        SPACER = lotusUtilities.SPACER,
        CHECKBOX = lotusUtilities.CHECKBOX,
        INPUTCOUNT = lotusUtilities.INPUTCOUNT,
        INPUTBOX = lotusUtilities.INPUTBOX,
        TOGGLE = lotusUtilities.TOGGLE,
        BUTTON = lotusUtilities.BUTTON,
    }
    -- Fail closed on enum drift: every constant must be a number.
    if type(types.TITLE) ~= "number" or type(types.SPACER) ~= "number"
        or type(types.CHECKBOX) ~= "number" or type(types.INPUTCOUNT) ~= "number"
        or type(types.INPUTBOX) ~= "number" or type(types.TOGGLE) ~= "number"
        or type(types.BUTTON) ~= "number" then
        return nil
    end
    return types
end

local openPage -- forward

-- The native validator runs only on Confirm for changed rows; the host
-- re-validates every staged value as the second line of defence.
local function countValidator(row, spec)
    return function()
        local value = row.mCount
        if value == nil or value < spec.minimum or value > spec.maximum or value % 1 ~= 0 then
            return false, spec.invalid
        end
        return true
    end
end

local function textValidator(row, spec)
    return function()
        local value = tonumber(row.mContent)
        if value == nil or value ~= value or value < spec.minimum or value > spec.maximum then
            return false, spec.invalid
        end
        if spec.integer == true and value % 1 ~= 0 then
            return false, spec.invalid
        end
        return true
    end
end

local function buildRow(spec, types, movie, depth)
    local kind = spec.kind
    local row = nil
    if kind == "TITLE" then
        row = { mLabel = spec.label, mType = types.TITLE }
    elseif kind == "SPACER" then
        row = { mLabel = "", mType = types.SPACER, mHeight = 32 }
    elseif kind == "CHECKBOX" then
        row = {
            mLabel = spec.label,
            mType = types.CHECKBOX,
            mValue = spec.value == true,
            mSetting = spec.setting,
            mTooltip = spec.tooltip,
            mLocked = spec.locked == true,
        }
    elseif kind == "INPUTCOUNT" then
        row = {
            mLabel = spec.label,
            mType = types.INPUTCOUNT,
            mSetting = spec.setting,
            mCount = spec.count,
            mMinCount = spec.minimum,
            mMaxCount = spec.maximum,
            mTooltip = spec.tooltip,
            mLocked = spec.locked == true,
        }
        if spec.validate == true then
            row.mOnValidateSetting = countValidator(row, spec)
        end
    elseif kind == "INPUTBOX" then
        row = {
            mLabel = spec.label,
            mType = types.INPUTBOX,
            mSetting = spec.setting,
            mContent = spec.content,
            mMaxChars = 16,
            mMultiLine = false,
            mSkipAutoFocus = true,
            mTooltip = spec.tooltip,
            mLocked = spec.locked == true,
        }
        if spec.validate == true then
            row.mOnValidateSetting = textValidator(row, spec)
        end
    elseif kind == "TOGGLE" then
        local values = {}
        local options = spec.options
        if options ~= nil then
            for i = 1, #options do
                values[i] = { Label = options[i].label, Value = options[i].value }
            end
        end
        row = {
            mLabel = spec.label,
            mType = types.TOGGLE,
            mSetting = spec.setting,
            mValue = spec.number,
            mToggleValues = values,
            mWrapAround = true,
            mTooltip = spec.tooltip,
            mLocked = spec.locked == true,
        }
    elseif kind == "BUTTON" then
        local action = spec.action
        row = {
            mLabel = spec.label,
            mType = types.BUTTON,
            mSetting = spec.setting,
            mSubLabel = spec.subLabel,
            mTooltip = spec.tooltip,
            mCallback = function()
                if action == nil then
                    return
                end
                if string.sub(action, 1, 5) == "open:" then
                    openPage(movie, string.sub(action, 6), depth + 1)
                elseif string.sub(action, 1, 8) == "restore:" then
                    -- Stage the restore, then close through the stock Confirm
                    -- route; the batch applies with the root page.
                    host.act(action)
                    movie:Execute("FinishSelection", "")
                end
            end,
        }
    end
    if row ~= nil and spec.setting ~= nil and spec.locked ~= true
        and (kind == "CHECKBOX" or kind == "INPUTCOUNT" or kind == "INPUTBOX" or kind == "TOGGLE") then
        -- Marks the rows the completion pass restages (copies made by the
        -- stock search filter keep these fields).
        row.mRenoviceStage = true
        row.mRenoviceKind = kind
    end
    return row
end

-- Completion pass: restage every visible editable row from the stock
-- completion array (INPUTBOX text is only collected there), so what the player
-- sees at close is what applies.
local function stageVisible(elements)
    for i = 1, #elements do
        local element = elements[i]
        if element ~= nil and element.mRenoviceStage == true then
            local kind = element.mRenoviceKind
            if kind == "INPUTCOUNT" then
                host.stage(element.mCount, element.mSetting)
            elseif kind == "INPUTBOX" then
                host.stage(element.mContent, element.mSetting)
            else
                host.stage(element.mValue, element.mSetting)
            end
        end
    end
end

local function configure(child, page, depth, types)
    pageSerial = pageSerial + 1
    local suffix = tostring(depth) .. "_" .. tostring(pageSerial)
    local elementsName = "_RENOVICEScriptSettingsElementsV1_" .. suffix
    local changedName = "_RENOVICEScriptSettingsChangedV1_" .. suffix
    local doneName = "_RENOVICEScriptSettingsDoneV1_" .. suffix
    local stage = host.stage
    local done = host.done

    _T[elementsName] = function()
        local rows = {}
        local specs = page.rows
        if specs ~= nil then
            for i = 1, #specs do
                local row = buildRow(specs[i], types, child, depth)
                if row ~= nil then
                    rows[#rows + 1] = row
                end
            end
        end
        return rows
    end
    _T[changedName] = function(value, setting)
        stage(value, setting)
    end
    _T[doneName] = function(elements, flag)
        if elements ~= nil then
            pcall(stageVisible, elements)
        end
        _T[elementsName] = nil
        _T[changedName] = nil
        _T[doneName] = nil
        done(depth, elements, flag)
    end

    child:Execute("SetTitle", page.title)
    child:Execute("SetNoElementsMessage", page.empty)
    if page.search == true then
        child:Execute("ShowHideSearchBox", "true")
    end
    child:Execute("SetConfirmButtonVisibleWhenInactive", "true")
    child:Execute("SetConfirmButtonActive", "true")
    child:Execute("SetCallBack", doneName)
    child:Execute("SetValueChangedCallBack", changedName)
    child:Execute("SetElementsFunction", elementsName)
end

openPage = function(parentMovie, pageId, depth)
    local types = resolveTypes()
    if types == nil then
        return false
    end
    local page = host.getPage(pageId)
    if page == nil then
        return false
    end
    local child = parentMovie:PushChildMovie(host.resource)
    if IsNull(child) then
        return false
    end
    configure(child, page, depth, types)
    return true
end

local function openScriptSettings(parentMovie, resource, layout, getPage, stage, done, act)
    if IsNull(parentMovie) or IsNull(resource) then
        return false
    end
    host.resource = resource
    host.getPage = getPage
    host.stage = stage
    host.done = done
    host.act = act
    local rootPage = "flat"
    if layout == "nested" then
        rootPage = "root"
    end
    return openPage(parentMovie, rootPage, 1)
end

return {
    activate = function() end,
    cleanup = function()
        host.getPage = nil
        host.stage = nil
        host.done = nil
        host.act = nil
        host.resource = nil
    end,
    hooks = {
        openScriptSettings = openScriptSettings,
    },
}
