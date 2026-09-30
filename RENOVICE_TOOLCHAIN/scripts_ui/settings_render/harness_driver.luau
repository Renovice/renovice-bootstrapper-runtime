-- SCRIPT SETTINGS render harness, driver (R3, 2026-09-30).
--
-- Opens the flat SCRIPT SETTINGS page through the bridge under test, lets the
-- stock screen populate it (Initialize -> interpolation -> populate -> List
-- Redraw -> element draw callback -> layout), then scrolls through every
-- position with the stock List.ScrollValueChangedCallback (the live crash path
-- ScrollBar -> List L1075 -> L1048 -> Redraw L948 -> OnDraw L724 -> draw L991)
-- and with the stock mouse-wheel handler. After every redraw each visible
-- clip must show its own row: the stock frame for its type, its own label,
-- no leftover sub-label, and the stock background colour.

local lists = {}
do
    local listModule = BASE_ENV.require("EE.Interface.Components.List")
    local create = listModule.CreateList
    listModule.CreateList = function(...)
        local list = create(...)
        lists[#lists + 1] = list
        return list
    end
end

-- Host page: every row kind the host emits, > 14 rows, float values as
-- value-page BUTTONs. Two BUTTON descriptors still carry the pre-R3 host
-- `subLabel` field (DLL 731fdb11 and older send it): the bridge must never
-- turn it into a stock mSubLabel without mButtonWidth.
local VALUE_BUTTONS = {
    { label = "Bonus per Cold stack: 50x (stock 0x)", action = "open:val:Frost/cold.bonus" },
    { label = "Reward interval (stock 300 s)", subLabel = "150 s", action = "open:val:Missions/survival.reward_interval" },
    { label = "Pickup multiplier: 2.5x (stock 1.5x)", action = "open:val:Missions/survival.pickup_multiplier" },
    { label = "Tier-up interval (stock 90 s)", subLabel = "75 s", action = "open:val:Missions/lantern.tier_up_interval" },
}

local function pageRows()
    local rows = {}
    local function add(spec) rows[#rows + 1] = spec end
    local buttonIndex = 0
    local function valueButton()
        buttonIndex = buttonIndex % #VALUE_BUTTONS + 1
        local template = VALUE_BUTTONS[buttonIndex]
        add({ kind = "BUTTON", label = template.label, subLabel = template.subLabel, action = template.action,
            setting = "action:" .. template.action, tooltip = "Stock value first.", locked = false })
    end
    for section = 1, 6 do
        add({ kind = "TITLE", label = "SECTION " .. tostring(section) })
        add({ kind = "CHECKBOX", label = "Package " .. tostring(section), setting = "package:p" .. section, value = true })
        add({ kind = "CHECKBOX", label = "Use stock values", setting = "stock:p" .. section, value = false })
        add({ kind = "CHECKBOX", label = "Custom value " .. section, setting = "custom:p" .. section .. "/a", value = true })
        valueButton()
        add({ kind = "CHECKBOX", label = "Custom count " .. section, setting = "custom:p" .. section .. "/b", value = false })
        add({ kind = "INPUTCOUNT", label = "Enemy level (stock 10)", setting = "value:p" .. section .. "/b",
            count = 12, minimum = 0, maximum = 100, validate = true, invalid = "Enter 0 to 100." })
        add({ kind = "TOGGLE", label = "Spawn mode (stock Normal)", setting = "value:p" .. section .. "/c",
            number = 1, options = { { label = "Normal", value = 1 }, { label = "Fast", value = 2 } } })
        valueButton()
        add({ kind = "CHECKBOX", label = "Locked metadata " .. section, setting = "custom:p" .. section .. "/d",
            value = false, locked = true })
    end
    return rows
end

local PAGE = { title = "SCRIPT SETTINGS", empty = "NO PACKAGE SETTINGS FOUND", search = true, rows = pageRows() }

local staged = {}
local function getPage(pageId)
    if pageId == "flat" then return PAGE end
    return nil
end
local function stage(value, setting) staged[#staged + 1] = { setting = setting, value = value } end
local function done() end
local function act() end

local bridgeEnv, bridge = instantiate("bridge")
local parent = Movie.new("TopMenu")
local opened = false

local function step(name, fn)
    local ok, message = xpcall(fn, debug.traceback)
    if not ok then
        HARNESS.errors[#HARNESS.errors + 1] = name .. ": " .. tostring(message)
    end
    return ok
end

local FRAME_BY_TYPE = {
    [LOTUS_UTILITIES.TITLE] = "Title",
    [LOTUS_UTILITIES.SPACER] = "Title",
    [LOTUS_UTILITIES.CHECKBOX] = "Checkbox",
    [LOTUS_UTILITIES.TOGGLE] = "Toggle",
    [LOTUS_UTILITIES.BUTTON] = "button",
    [LOTUS_UTILITIES.INPUTCOUNT] = "InputCount",
}

local function verifyVisible(context)
    local instance = HARNESS.instances[1]
    local list = lists[1]
    if instance == nil or list == nil then
        harnessFail(context .. ": no stock GenericSettings list")
        return
    end
    local movie = instance.movie
    local seen = 0
    local clipOwner = {}
    list:RunForAllVisibleElements(function(element)
        seen = seen + 1
        local clip = element.mClipName
        local state = movie:_clip(clip)
        local expectedFrame = FRAME_BY_TYPE[element.mType]
        harnessCheck(clipOwner[clip] == nil, context .. ": clip " .. tostring(clip) .. " is shared by two visible rows")
        clipOwner[clip] = element.Id
        harnessCheck(state.frame == expectedFrame, context .. ": row " .. tostring(element.Id) .. " clip " .. tostring(clip)
            .. " frame " .. tostring(state.frame) .. " expected " .. tostring(expectedFrame))
        harnessCheck(state.text.Label == element.mLabel, context .. ": row " .. tostring(element.Id)
            .. " shows label '" .. tostring(state.text.Label) .. "' instead of its own '" .. tostring(element.mLabel) .. "'")
        harnessCheck(state.colors["Bg:RectInnerColor"] == true, context .. ": row " .. tostring(element.Id)
            .. " background was never recoloured (draw did not complete)")
        if element.mType ~= LOTUS_UTILITIES.BUTTON or element.mSubLabel == nil then
            harnessCheck(state.visible.SubLabel ~= true, context .. ": row " .. tostring(element.Id)
                .. " shows a leftover sub-label '" .. tostring(state.text.SubLabel) .. "'")
        end
    end)
    -- 14 visible rows plus the one buffer row the stock smooth scroll draws.
    harnessCheck(seen == 14 or seen == 15, context .. ": " .. tostring(seen) .. " drawn rows, expected the stock 14 (+1 smooth-scroll buffer)")
end

step("open", function()
    opened = bridge.hooks.openScriptSettings(parent, "resource", "flat", getPage, stage, done, act)
end)
harnessCheck(opened == true, "bridge opened the flat page")

-- Engine frames: Update drives the movie tick (interpolation end -> populate).
for frame = 1, 3 do
    local instance = HARNESS.instances[1]
    if instance == nil then break end
    step("frame " .. frame, function() instance.env.Update() end)
end

local list = lists[1]
if list ~= nil then
    local rows = list:GetHowManyElements()
    harnessCheck(rows == #PAGE.rows, "stock list holds every row (" .. tostring(rows) .. "/" .. #PAGE.rows .. ")")
    harnessCheck(list.UniformElementHeights == true, "stock populate keeps UniformElementHeights")
    harnessCheck(list.mVisibleElements == 14 and list.mScrollBar ~= nil, "stock populate attaches the scroll bar (14 visible)")

    -- Every row: its own label; BUTTON rows never carry a stock sub-label
    -- without the mButtonWidth the stock draw subtracts from (L991).
    local buttons = 0
    list:RunForAllElements(function(element)
        if element.mType == LOTUS_UTILITIES.BUTTON then
            buttons = buttons + 1
            harnessCheck(element.mSubLabel == nil or element.mButtonWidth ~= nil,
                "row " .. tostring(element.Id) .. ": BUTTON mSubLabel without mButtonWidth (stock L991 nil arithmetic)")
        end
        harnessCheck(element.mHeight == nil or element.mHeight == 44, "row " .. tostring(element.Id) .. ": uniform 44 px height")
    end)
    harnessCheck(buttons == 12, "12 value BUTTON rows reach the stock list")
    local index = 0
    list:RunForAllElements(function(element)
        index = index + 1
        local spec = PAGE.rows[index]
        if spec.kind == "BUTTON" and spec.subLabel ~= nil then
            harnessCheck(element.mLabel == spec.label .. ": " .. spec.subLabel,
                "row " .. tostring(element.Id) .. ": a legacy subLabel is folded into the label ('" .. tostring(element.mLabel) .. "')")
        elseif spec.label ~= nil and spec.kind ~= "SPACER" then
            harnessCheck(element.mLabel == spec.label, "row " .. tostring(element.Id) .. ": label is the host label")
        end
    end)

    local instance = HARNESS.instances[1]
    local searchX = instance.movie:_var("Container.SearchBox")[0]
    local panelWidth = instance.movie:_var("Container.BgFill")[14]
    harnessCheck(type(searchX) == "number" and type(panelWidth) == "number" and searchX < panelWidth,
        "stock layout ran after the redraw: search box placed inside the panel (x=" .. tostring(searchX)
            .. " width=" .. tostring(panelWidth) .. ")")
    verifyVisible("open")

    -- Scroll-bar drags through every position, both directions.
    local positions = rows - 14
    for position = 0, positions do
        step("scrollbar " .. position, function() list.mScrollBar:SetValue(position / positions) end)
        verifyVisible("scrollbar " .. position)
    end
    for position = positions, 0, -3 do
        step("scrollbar back " .. position, function() list.mScrollBar:SetValue(position / positions) end)
        verifyVisible("scrollbar back " .. position)
    end
    -- Mouse wheel: the stock onKeyDown_MENU_MOUSE_Z handler.
    for tick = 1, positions + 2 do
        step("wheel down " .. tick, function() instance.env.onKeyDown_MENU_MOUSE_Z(0, "1") end)
        verifyVisible("wheel down " .. tick)
    end
    for tick = 1, 5 do
        step("wheel up " .. tick, function() instance.env.onKeyDown_MENU_MOUSE_Z(0, "-1") end)
        verifyVisible("wheel up " .. tick)
    end
end

for index = 1, #HARNESS.errors do
    print("ERROR\t" .. HARNESS.errors[index])
end
local shown = 0
for index = 1, #HARNESS.failures do
    if shown < 40 then print("FAIL\t" .. HARNESS.failures[index]) end
    shown = shown + 1
end
if #HARNESS.errors == 0 and #HARNESS.failures == 0 then
    print("SCRIPT SETTINGS RENDER HARNESS PASS checks=" .. tostring(HARNESS.checks) .. " rows=" .. tostring(#PAGE.rows))
else
    print("SCRIPT SETTINGS RENDER HARNESS FAIL errors=" .. tostring(#HARNESS.errors) .. " failures=" .. tostring(#HARNESS.failures)
        .. " checks=" .. tostring(HARNESS.checks))
end
