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
--
-- R7 (2026-09-30): the host pages are a tree (package -> mission type ->
-- category -> set -> value page) with one row per value; value pages hold the
-- editor and "Reset to default" (action reset:, closes the page without
-- restaging the old value); every list page ends with "Reset all to defaults"
-- (action resetall:, re-reads the page in place). The bridge renders whatever
-- rows the host sends; it names no page, package or value.

local lotusUtilities = require("Lotus.Interface.LotusUtilities")
-- Stock message box (ThemedGenericSettings shows its validator text with
-- EE.Interface.Utilities.ShowMessage, 44.0.2 render L205-212).
local eeUtilities = require("EE.Interface.Utilities")

-- Stock scroll contract (ThemedGenericSettings Update, 44.0.2 render
-- L4740-4880): the list attaches its scroll bar, smooth scroll and mouse wheel
-- only when every row has the same height and no row is an INPUTBOX. TITLE
-- (stock 24) and SPACER (stock 8) therefore take the 44 px default of
-- CHECKBOX, TOGGLE, BUTTON and INPUTCOUNT; the host keeps INPUTBOX rows on
-- their own one-value pages.
local UNIFORM_ROW_HEIGHT = 44

-- Stock list recycling (R4). With the scroll bar attached (uniform rows, more
-- than 14 of them, no INPUTBOX) the stock List draws 14 clips and moves the
-- row tables through them. Stock rebuilds the CHECKBOX and TOGGLE widgets on
-- every scrolled draw (element draw callback, 44.0.2 source lines 878-880 and
-- 927-929: `if list.mScroll ~= nil then element.Checkbox = nil end`), but
-- builds the INPUTCOUNT Minus/Count/Plus widgets once per row table, bound to
-- the clip of its first draw (source lines 1081-1152, `if mButtonInfo == nil`).
-- A scrolled INPUTCOUNT row therefore shows an uninitialised count field in
-- its new clip, its old widgets keep writing into a clip another row now owns,
-- and the per-frame count poll (Update, source line 1627 -> 1474) indexes a
-- row copy that has no mCountButton. A locked row also dims its clip's Label
-- (source line 1304, alpha 60) and nothing restores it for the next row. On a
-- recycled page the bridge therefore renders no INPUTCOUNT and no locked row:
-- an INPUTCOUNT becomes a BUTTON that opens a one-row page holding the stock
-- INPUTCOUNT; a locked row becomes an unlocked BUTTON that shows its value.
local STOCK_VISIBLE_ROWS = 14

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

-- BUTTON label (R3). The stock draw callback (ThemedGenericSettings 44.0.2,
-- source line 991) places a BUTTON's mSubLabel at `mButtonWidth -
-- (mSubLabelOffset or 100)`; stock screens that use a sub-label always set
-- mButtonWidth (ThemedTennoCustomization: 400). Without it the draw raises a
-- nil arithmetic error, which aborts the List redraw and the panel layout. The
-- bridge therefore never builds mSubLabel: the host's value text (hosts before
-- R3 still send `subLabel`) is part of the label, and the SubLabel clip stays
-- hidden by the stock `else` branch.
local function buttonLabel(spec)
    local label = spec.label or ""
    local detail = spec.subLabel
    if type(detail) == "string" and detail ~= "" then
        return label .. ": " .. detail
    end
    return label
end

-- True when the stock screen will attach its scroll bar to this page and
-- recycle its clips (ThemedGenericSettings Update, source lines 1656-1712:
-- uniform heights, no INPUTBOX, more than 14 rows).
local function recycledPage(specs)
    if specs == nil or #specs <= STOCK_VISIBLE_ROWS then
        return false
    end
    for i = 1, #specs do
        if specs[i].kind == "INPUTBOX" then
            return false
        end
    end
    return true
end

-- The text a recycled-page BUTTON shows for a row it stands in for.
local function valueText(spec)
    local kind = spec.kind
    if kind == "INPUTCOUNT" then
        return tostring(spec.count)
    elseif kind == "CHECKBOX" then
        if spec.value == true then
            return "On"
        end
        return "Off"
    elseif kind == "TOGGLE" then
        local options = spec.options
        if options ~= nil then
            for i = 1, #options do
                if options[i].value == spec.number then
                    return options[i].label
                end
            end
        end
        return tostring(spec.number)
    end
    return nil
end

local openRowPage -- forward

-- `context` is the page's own record (see configure): its refresh function is
-- handed to every page this page opens, so a child close updates this page.
local function buildRow(spec, types, movie, depth, recycled, context)
    local kind = spec.kind
    local row = nil
    if recycled == true and (kind == "INPUTCOUNT" or (spec.locked == true
        and (kind == "CHECKBOX" or kind == "TOGGLE" or kind == "BUTTON"))) then
        -- R4: stand-in BUTTON on a recycled page (see STOCK_VISIBLE_ROWS). It
        -- is never locked; an INPUTCOUNT opens its own one-row page (which
        -- keeps the row's lock), a locked BUTTON keeps its action (the page it
        -- opens holds the locked editor), a locked CHECKBOX or TOGGLE only
        -- shows its value.
        local label = spec.label or ""
        local detail = valueText(spec)
        if kind == "BUTTON" then
            label = buttonLabel(spec)
        elseif detail ~= nil and detail ~= "" then
            label = label .. ": " .. detail
        end
        local action = nil
        if kind == "BUTTON" then
            action = spec.action
        end
        row = {
            mLabel = label,
            mType = types.BUTTON,
            mSetting = "action:",
            mTooltip = spec.tooltip,
            mLocked = false,
            mRenoviceSpec = spec,
        }
        local standIn = row
        row.mCallback = function()
            if kind == "INPUTCOUNT" then
                openRowPage(movie, standIn.mRenoviceSpec, depth + 1, context.refresh)
            elseif action ~= nil and string.sub(action, 1, 5) == "open:" then
                openPage(movie, string.sub(action, 6), depth + 1, context.refresh)
            end
        end
        return row
    end
    if kind == "TITLE" then
        row = { mLabel = spec.label, mType = types.TITLE, mHeight = UNIFORM_ROW_HEIGHT }
    elseif kind == "SPACER" then
        row = { mLabel = "", mType = types.SPACER, mHeight = UNIFORM_ROW_HEIGHT }
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
            mLabel = buttonLabel(spec),
            mType = types.BUTTON,
            mSetting = spec.setting,
            mTooltip = spec.tooltip,
            mLocked = spec.locked == true,
            mCallback = function()
                if action == nil then
                    return
                end
                if string.sub(action, 1, 5) == "open:" then
                    openPage(movie, string.sub(action, 6), depth + 1, context.refresh)
                elseif string.sub(action, 1, 9) == "resetall:" then
                    -- R7 "Reset all to defaults" on a list page: stage the
                    -- reset, then re-read this page in place, so the rows
                    -- show their defaults at once (the page stays open; its
                    -- parent refreshes when it closes).
                    host.act(action)
                    context.refresh()
                elseif string.sub(action, 1, 6) == "reset:" then
                    -- R7 "Reset to default" on a value page: stage the reset
                    -- and close through the stock Confirm route. The close
                    -- must not restage the editor's old value over the reset.
                    host.act(action)
                    context.skipRestage = true
                    movie:Execute("FinishSelection", "")
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

-- R5: validation on the Back route. The stock screen runs a row's
-- mOnValidateSetting only on Confirm (render L185-215: validators run only
-- when the close flag is nil); Back (ExitScreen, flag true) closes without
-- them, and the host then rejected the value without a word (live
-- 2026-09-30: "stage REJECT ... reason=outside-min-max value=kept"). Show the
-- same stock message box with the row's own text; the previous value stays.
local function reportInvalid(elements)
    for i = 1, #elements do
        local element = elements[i]
        if element ~= nil and element.mRenoviceStage == true and element.mOnValidateSetting ~= nil then
            local valid, message = element.mOnValidateSetting()
            if not valid and message ~= nil then
                eeUtilities.ShowMessage(message)
                return
            end
        end
    end
end

-- The key a fresh host row and a built row share: the action of a BUTTON,
-- else the row setting. TITLE and SPACER rows have neither.
local function rowKey(spec)
    if spec.action ~= nil and spec.action ~= "" then
        return "action:" .. spec.action
    end
    if spec.setting ~= nil and spec.setting ~= "" then
        return "setting:" .. spec.setting
    end
    return nil
end

-- R5: after a page this page opened closes, re-read this page from the host
-- (its model already holds the staged edits) and update the labels and switch
-- values of the rows the stock list holds: a value edited on its page shows
-- its new value, and its "Custom" switch is ticked. The stock list draws the
-- row tables themselves, so the next draw shows the update, and the
-- completion pass restages what the rows now hold. Only fields the bridge
-- itself sets are written (mLabel; mValue of an editable CHECKBOX/TOGGLE).
local function refreshRows(context)
    if context.pageId == nil or host.getPage == nil then
        return
    end
    local fresh = host.getPage(context.pageId)
    if fresh == nil or fresh.rows == nil then
        return
    end
    local byKey = {}
    for i = 1, #fresh.rows do
        local key = rowKey(fresh.rows[i])
        if key ~= nil then
            byKey[key] = fresh.rows[i]
        end
    end
    for i = 1, #context.built do
        local entry = context.built[i]
        local key = rowKey(entry.spec)
        local spec = nil
        if key ~= nil then
            spec = byKey[key]
        end
        if spec ~= nil and spec.kind == entry.spec.kind then
            local updated = buildRow(spec, context.types, context.movie, context.depth, context.recycled, context)
            local row = entry.row
            if updated ~= nil and updated.mType == row.mType then
                local labelChanged = row.mLabel ~= updated.mLabel
                row.mLabel = updated.mLabel
                if row.mRenoviceSpec ~= nil then
                    row.mRenoviceSpec = spec
                end
                local checkbox = row.mRenoviceStage == true and row.mRenoviceKind == "CHECKBOX"
                if row.mRenoviceStage == true and (row.mRenoviceKind == "CHECKBOX" or row.mRenoviceKind == "TOGGLE") then
                    row.mValue = updated.mValue
                end
                entry.spec = spec
                -- The stock list redraws only on scroll, so a row drawn right
                -- now gets the stock draw's own two writes on its own clip
                -- (the List clears mClipName of every row it does not draw):
                -- the label text (ThemedGenericSettings element draw,
                -- SetLocalized(<clip>.Label.text, mLabel)) and the checkbox
                -- widget state (mChecked, as its ValueChanged reads it) with
                -- the widget's own Redraw.
                local clip = row.mClipName
                if clip ~= nil then
                    if labelChanged then
                        context.movie:SetLocalized(clip .. ".Label.text", row.mLabel)
                    end
                    if checkbox and row.Checkbox ~= nil and row.Checkbox.mChecked ~= row.mValue then
                        row.Checkbox.mChecked = row.mValue
                        row.Checkbox:Redraw()
                    end
                end
            end
        end
    end
end

local function configure(child, page, depth, types, pageId, onClosed)
    pageSerial = pageSerial + 1
    local suffix = tostring(depth) .. "_" .. tostring(pageSerial)
    local elementsName = "_RENOVICEScriptSettingsElementsV1_" .. suffix
    local changedName = "_RENOVICEScriptSettingsChangedV1_" .. suffix
    local doneName = "_RENOVICEScriptSettingsDoneV1_" .. suffix
    local stage = host.stage
    local done = host.done
    local context = {
        pageId = pageId,
        types = types,
        movie = child,
        depth = depth,
        recycled = false,
        built = {},
        refresh = nil,
        skipRestage = false,
    }
    context.refresh = function()
        refreshRows(context)
    end

    _T[elementsName] = function()
        local rows = {}
        local specs = page.rows
        local recycled = recycledPage(specs)
        context.recycled = recycled
        context.built = {}
        if specs ~= nil then
            for i = 1, #specs do
                local row = buildRow(specs[i], types, child, depth, recycled, context)
                if row ~= nil then
                    rows[#rows + 1] = row
                    context.built[#context.built + 1] = { spec = specs[i], row = row }
                end
            end
        end
        return rows
    end
    -- R5: a value-changed callback is a player's click; the host lets it
    -- decide a "Custom" switch that an edit on the value page turned on.
    _T[changedName] = function(value, setting)
        stage(value, setting, "click")
    end
    _T[doneName] = function(elements, flag)
        if elements ~= nil and context.skipRestage ~= true then
            pcall(stageVisible, elements)
            if flag ~= nil then
                pcall(reportInvalid, elements)
            end
        end
        _T[elementsName] = nil
        _T[changedName] = nil
        _T[doneName] = nil
        done(depth, elements, flag)
        if onClosed ~= nil then
            pcall(onClosed)
        end
    end

    child:Execute("SetTitle", page.title)
    child:Execute("SetNoElementsMessage", page.empty)
    -- R4: the stock search box stays hidden (page.search is ignored). The
    -- stock filter (source lines 685-709) rebuilds the list from copies taken
    -- when the page was populated (source lines 1656-1678), so a row edited
    -- before typing shows its old value again, and the completion pass would
    -- stage that old value; with an INPUTCOUNT on the page the per-frame count
    -- poll then raised "attempt to index nil with 'mClipName'" (source line
    -- 1474, live EE.log 2026-09-30) and the screen could not be left.
    child:Execute("SetConfirmButtonVisibleWhenInactive", "true")
    child:Execute("SetConfirmButtonActive", "true")
    child:Execute("SetCallBack", doneName)
    child:Execute("SetValueChangedCallBack", changedName)
    child:Execute("SetElementsFunction", elementsName)
end

local function pushPage(parentMovie, page, depth, pageId, onClosed)
    local types = resolveTypes()
    if types == nil or page == nil then
        return false
    end
    local child = parentMovie:PushChildMovie(host.resource)
    if IsNull(child) then
        return false
    end
    configure(child, page, depth, types, pageId, onClosed)
    return true
end

openPage = function(parentMovie, pageId, depth, onClosed)
    return pushPage(parentMovie, host.getPage(pageId), depth, pageId, onClosed)
end

-- R4: one-row page for a row a recycled page cannot hold (an INPUTCOUNT).
-- The row keeps its setting, bounds, validator and lock; its close only
-- stages (depth > 1), exactly like a host value page.
openRowPage = function(parentMovie, spec, depth, onClosed)
    return pushPage(parentMovie, { title = spec.label or "", empty = "", rows = { spec } }, depth, nil, onClosed)
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
