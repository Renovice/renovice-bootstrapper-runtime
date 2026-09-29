-- RENOVICE Phase 0 UI probe bridge (DIAGNOSTIC BUILD ONLY), 2026-09-30.
--
-- Loaded only by a DLL built with build_private.ps1 -SettingsProbeP0. Any other
-- build ignores this reserved `_RENOVICE_INTERNAL_` file. It opens a static
-- demo stack in DE's own GenericSettings screen to answer the in-game editor
-- design's Phase 0 gates (N-1, R-1, V-1, I-1, S-1, P-1, H-1, H-2, plus R-2 =
-- FinishSelection from a BUTTON). It writes no file, stages nothing and never
-- touches an addon, a package or a generation. Every observation is reported
-- through the host `log` native as one "RENOVICE SETTINGS PROBE ..." line.

local lotusUtilities = require("Lotus.Interface.LotusUtilities")

local log = nil
local settingsResource = nil
local pageSerial = 0

local function say(text)
    if log ~= nil then
        log(text)
    end
end

local function describe(value)
    local kind = type(value)
    if kind == "string" then
        return "string:" .. value
    end
    if kind == "number" or kind == "boolean" then
        return kind .. ":" .. tostring(value)
    end
    return kind
end

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
    local names = { "TITLE", "SPACER", "CHECKBOX", "INPUTCOUNT", "INPUTBOX", "TOGGLE", "BUTTON" }
    for i = 1, #names do
        if type(types[names[i]]) ~= "number" then
            say("constants FAIL missing=" .. names[i])
            return nil
        end
    end
    say("constants PASS TITLE=" .. tostring(types.TITLE) .. " SPACER=" .. tostring(types.SPACER)
        .. " CHECKBOX=" .. tostring(types.CHECKBOX) .. " INPUTCOUNT=" .. tostring(types.INPUTCOUNT)
        .. " INPUTBOX=" .. tostring(types.INPUTBOX) .. " TOGGLE=" .. tostring(types.TOGGLE)
        .. " BUTTON=" .. tostring(types.BUTTON))
    return types
end

-- Configures one pushed/opened GenericSettings movie exactly like the shipped
-- SCRIPTS bridge (V10): title, Confirm visible and active, completion, value
-- callback and elements provider, each under a page-unique _T name.
local function configure(movie, depth, title, buildRows, withSearch)
    pageSerial = pageSerial + 1
    local suffix = tostring(depth) .. "_" .. tostring(pageSerial)
    local elementsName = "_RENOVICESettingsProbeElementsP0_" .. suffix
    local changedName = "_RENOVICESettingsProbeChangedP0_" .. suffix
    local doneName = "_RENOVICESettingsProbeDoneP0_" .. suffix
    _T[elementsName] = function()
        say("P-1 elements ENTER page=" .. title)
        local rows = buildRows(movie)
        say("P-1 elements RETURN page=" .. title .. " rows=" .. tostring(#rows))
        return rows
    end
    _T[changedName] = function(value, setting)
        say("I-1 changed page=" .. title .. " setting=" .. tostring(setting) .. " value=" .. describe(value))
    end
    _T[doneName] = function(elements, flag)
        local count = -1
        if type(elements) == "table" then
            count = #elements
            for i = 1, count do
                local row = elements[i]
                if type(row) == "table" and row.mSetting == "p0.float" then
                    say("I-1 completion page=" .. title .. " p0.float.mContent=" .. describe(row.mContent))
                end
                if type(row) == "table" and row.mSetting == "p0.count" then
                    say("I-1 completion page=" .. title .. " p0.count.mCount=" .. describe(row.mCount))
                end
            end
        end
        say("N-1 done page=" .. title .. " depth=" .. tostring(depth) .. " flag=" .. describe(flag)
            .. " elements=" .. tostring(count))
        _T[elementsName] = nil
        _T[changedName] = nil
        _T[doneName] = nil
    end
    movie:Execute("SetTitle", title)
    movie:Execute("SetNoElementsMessage", "NO PROBE ROWS")
    if withSearch then
        movie:Execute("ShowHideSearchBox", "true")
    end
    movie:Execute("SetConfirmButtonVisibleWhenInactive", "true")
    movie:Execute("SetConfirmButtonActive", "true")
    movie:Execute("SetCallBack", doneName)
    movie:Execute("SetValueChangedCallBack", changedName)
    movie:Execute("SetElementsFunction", elementsName)
    say("page CONFIGURED title=" .. title .. " depth=" .. tostring(depth) .. " search=" .. tostring(withSearch))
end

local openChild -- forward

local function spacer(types)
    return { mLabel = "", mType = types.SPACER, mHeight = 32 }
end

local function performanceRows(types)
    local rows = {}
    for section = 1, 22 do
        rows[#rows + 1] = { mLabel = "SECTION " .. tostring(section), mType = types.TITLE }
        for item = 1, 30 do
            local id = tostring(section) .. "." .. tostring(item)
            rows[#rows + 1] = {
                mLabel = "Custom value " .. id,
                mType = types.CHECKBOX,
                mValue = false,
                mSetting = "p1.enabled." .. id,
                mTooltip = "Performance row " .. id,
            }
            rows[#rows + 1] = {
                mLabel = "Value " .. id .. " (stock 300 s)",
                mType = types.INPUTCOUNT,
                mSetting = "p1.value." .. id,
                mCount = 300,
                mMinCount = 0,
                mMaxCount = 3600,
            }
        end
    end
    return rows
end

local function level3Rows(movie, types)
    return {
        { mLabel = "LEVEL 3", mType = types.TITLE },
        { mLabel = "Level 3 checkbox", mType = types.CHECKBOX, mValue = true, mSetting = "p0.l3.checkbox" },
        { mLabel = "Survival reward interval", mType = types.CHECKBOX, mValue = false, mSetting = "p0.l3.search1" },
        { mLabel = "Defense wave count", mType = types.CHECKBOX, mValue = false, mSetting = "p0.l3.search2" },
        spacer(types),
        {
            mLabel = "Close this page (FinishSelection)",
            mType = types.BUTTON,
            mSetting = "p0.l3.finish",
            mCallback = function()
                say("R-2 FinishSelection ENTER depth=3")
                movie:Execute("FinishSelection", "")
                say("R-2 FinishSelection RETURN depth=3")
            end,
        },
    }
end

local function level2Rows(movie, types)
    return {
        { mLabel = "LEVEL 2", mType = types.TITLE },
        { mLabel = "Level 2 checkbox", mType = types.CHECKBOX, mValue = false, mSetting = "p0.l2.checkbox" },
        {
            mLabel = "Open level 3",
            mType = types.BUTTON,
            mSetting = "p0.l2.open",
            mSubLabel = "Third GenericSettings",
            mCallback = function()
                openChild(movie, 3, "SETTINGS PROBE L3", level3Rows, true)
            end,
        },
    }
end

local function level1Rows(movie, types)
    local rows = {}
    local function add(row)
        rows[#rows + 1] = row
    end

    add({ mLabel = "NAVIGATION (N-1)", mType = types.TITLE })
    add({
        mLabel = "Open level 2",
        mType = types.BUTTON,
        mSetting = "p0.open.l2",
        mSubLabel = "Nested GenericSettings",
        mTooltip = "Pushes a GenericSettings child from this BUTTON.",
        mCallback = function()
            openChild(movie, 2, "SETTINGS PROBE L2", level2Rows, false)
        end,
    })
    add(spacer(types))

    add({ mLabel = "WIDGETS (V-1, I-1)", mType = types.TITLE })
    add({ mLabel = "Probe checkbox", mType = types.CHECKBOX, mValue = false, mSetting = "p0.checkbox",
        mTooltip = "Toggle, then watch the log for I-1 changed." })
    local count = {
        mLabel = "Probe count (min 5, max 50)",
        mType = types.INPUTCOUNT,
        mSetting = "p0.count",
        mCount = 10,
        mMinCount = 0,
        mMaxCount = 50,
        mTooltip = "Set below 5 and Confirm: the validator must block.",
    }
    count.mOnValidateSetting = function()
        local value = count.mCount
        local ok = type(value) == "number" and value >= 5
        say("V-1 validator setting=p0.count value=" .. describe(value) .. " ok=" .. tostring(ok))
        if ok then
            return true
        end
        return false, "Probe count must be at least 5."
    end
    add(count)
    local box = {
        mLabel = "Probe float (0.5 to 2.5)",
        mType = types.INPUTBOX,
        mSetting = "p0.float",
        mContent = "1.5",
        mMaxChars = 16,
        mMultiLine = false,
        mSkipAutoFocus = true,
        mTooltip = "Type 9 and Confirm: the validator must block.",
    }
    box.mOnValidateSetting = function()
        local value = tonumber(box.mContent)
        local ok = value ~= nil and value >= 0.5 and value <= 2.5
        say("V-1 validator setting=p0.float content=" .. describe(box.mContent) .. " ok=" .. tostring(ok))
        if ok then
            return true
        end
        return false, "Probe float must be between 0.5 and 2.5."
    end
    add(box)
    add({
        mLabel = "Probe toggle",
        mType = types.TOGGLE,
        mSetting = "p0.toggle",
        mValue = 2,
        mWrapAround = true,
        mToggleValues = { { Label = "Low", Value = 1 }, { Label = "Mid", Value = 2 }, { Label = "High", Value = 3 } },
    })
    add({
        mLabel = "Read input rows (I-1)",
        mType = types.BUTTON,
        mSetting = "p0.read",
        mCallback = function()
            say("I-1 read box.mContent=" .. describe(box.mContent) .. " count.mCount=" .. describe(count.mCount))
            local field = box.InputField
            if field ~= nil and field.mLabelClipName ~= nil then
                say("I-1 read flash text=" .. describe(movie:GetStringVariable(field.mLabelClipName, 36)))
            else
                say("I-1 read flash text unavailable: InputField missing")
            end
        end,
    })
    add(spacer(types))

    add({ mLabel = "IN-PLACE UPDATE (R-1, R-2)", mType = types.TITLE })
    local target = {
        mLabel = "Reset target (starts at 42)",
        mType = types.INPUTCOUNT,
        mSetting = "p0.target",
        mCount = 42,
        mMinCount = 0,
        mMaxCount = 100,
    }
    add(target)
    add({
        mLabel = "Set target to 7: field only",
        mType = types.BUTTON,
        mSetting = "p0.r1a",
        mCallback = function()
            target.mCount = 7
            say("R-1a wrote target.mCount=7; check whether the row shows 7")
        end,
    })
    add({
        mLabel = "Set target to 7: field and text",
        mType = types.BUTTON,
        mSetting = "p0.r1b",
        mCallback = function()
            target.mCount = 7
            local field = target.InputField
            if field ~= nil and field.mLabelClipName ~= nil then
                movie:SetStringVariable(field.mLabelClipName, 36, "7")
                say("R-1b wrote mCount=7 and flash text 7 clip=" .. tostring(field.mLabelClipName))
            else
                say("R-1b InputField missing; wrote mCount only")
            end
        end,
    })
    add({
        mLabel = "Close with Confirm (R-2)",
        mType = types.BUTTON,
        mSetting = "p0.r2",
        mCallback = function()
            say("R-2 FinishSelection ENTER depth=1")
            movie:Execute("FinishSelection", "")
            say("R-2 FinishSelection RETURN depth=1")
        end,
    })
    add(spacer(types))

    add({ mLabel = "SEARCH (S-1)", mType = types.TITLE })
    add({
        mLabel = "Log search normalisation",
        mType = types.BUTTON,
        mSetting = "p0.s1",
        mCallback = function()
            say("S-1 search box text=" .. describe(movie:GetStringVariable("Container.SearchBox.Label", 36)))
            local normalise = ToSearchable
            if normalise == nil then
                say("S-1 ToSearchable unavailable in bridge env")
                return
            end
            local samples = {
                "Reward interval (stock 300 s)",
                "Hell-Scrub: Scaldra",
                "UPPER lower MiXeD",
                "dots.dashes-under_scores",
                "Survival · Reward interval",
            }
            for i = 1, #samples do
                say("S-1 ToSearchable [" .. samples[i] .. "] -> [" .. tostring(normalise(samples[i])) .. "]")
            end
        end,
    })
    add({ mLabel = "Survival · Reward interval (stock 300 s)", mType = types.CHECKBOX, mValue = false, mSetting = "p0.s.a" })
    add({ mLabel = "Hell-Scrub: Scaldra", mType = types.CHECKBOX, mValue = false, mSetting = "p0.s.b" })
    add({ mLabel = "Void Flood fractures (stock 3)", mType = types.CHECKBOX, mValue = false, mSetting = "p0.s.c" })
    add({ mLabel = "UPPER lower MiXeD", mType = types.CHECKBOX, mValue = false, mSetting = "p0.s.d" })
    add({ mLabel = "dots.dashes-under_scores", mType = types.CHECKBOX, mValue = false, mSetting = "p0.s.e" })
    add(spacer(types))

    add({ mLabel = "PERFORMANCE (P-1)", mType = types.TITLE })
    add({
        mLabel = "Open 1,342-row page",
        mType = types.BUTTON,
        mSetting = "p0.p1",
        mSubLabel = "22 sections x 61 rows",
        mCallback = function()
            openChild(movie, 2, "SETTINGS PROBE P-1", function(child) return performanceRows(types) end, true)
        end,
    })
    add(spacer(types))
    add({ mLabel = "HOTKEY (H-1): PRESS F12 TO OPEN", mType = types.TITLE })
    return rows
end

openChild = function(parentMovie, depth, title, buildRows, withSearch)
    say("N-1 push ENTER depth=" .. tostring(depth) .. " page=" .. title)
    local types = resolveTypes()
    if types == nil then
        return
    end
    local child = parentMovie:PushChildMovie(settingsResource)
    if IsNull(child) then
        say("N-1 push FAIL depth=" .. tostring(depth) .. " reason=PushChildMovie-null")
        return
    end
    say("N-1 push PASS depth=" .. tostring(depth))
    configure(child, depth, title, function(movie) return buildRows(movie, types) end, withSearch)
end

local function openProbe(parentMovie, resource, logFunction)
    log = logFunction
    settingsResource = resource
    if IsNull(parentMovie) or IsNull(resource) then
        say("open FAIL reason=parent-or-resource-null")
        return false
    end
    local types = resolveTypes()
    if types == nil then
        return false
    end
    local child = parentMovie:PushChildMovie(resource)
    if IsNull(child) then
        say("open FAIL reason=PushChildMovie-null")
        return false
    end
    configure(child, 1, "SETTINGS PROBE", function(movie) return level1Rows(movie, types) end, true)
    return true
end

local function openProbeFromHotkey(resource, logFunction)
    log = logFunction
    settingsResource = resource
    local open = _T.OpenScreen
    if open == nil then
        say("H-1 FAIL reason=_T.OpenScreen-nil")
        return false
    end
    local types = resolveTypes()
    if types == nil then
        return false
    end
    local movie = open("GenericSettings")
    if IsNull(movie) then
        say("H-1 FAIL reason=OpenScreen-null")
        return false
    end
    say("H-1 OpenScreen PASS")
    configure(movie, 1, "SETTINGS PROBE (F12)", function(child) return level1Rows(child, types) end, true)
    return true
end

return {
    activate = function() end,
    cleanup = function() end,
    hooks = {
        openProbe = openProbe,
        openProbeFromHotkey = openProbeFromHotkey,
    },
}
