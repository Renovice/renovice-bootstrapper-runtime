-- SCRIPT SETTINGS render harness, driver (R3, extended R4, 2026-09-30).
--
-- Opens the flat SCRIPT SETTINGS page through the bridge under test, lets the
-- stock screen populate it (Initialize -> interpolation -> populate -> List
-- Redraw -> element draw callback -> layout), then scrolls through every
-- position with the stock List.ScrollValueChangedCallback and the stock
-- mouse-wheel handler, running one stock Update (the engine frame) after every
-- step. After every step each visible clip must show its own row: the stock
-- frame for its type, its own label, the background recoloured, no leftover
-- sub-label, the row type's widgets built on THIS clip since its last frame
-- change (CHECKBOX, TOGGLE, INPUTCOUNT Minus/Count/Plus), no Label left dimmed
-- by a locked row, and no widget writing into a clip that changed frame.
--
-- R4 flows: every BUTTON that opens a page is pressed through the stock
-- selection callback and its one-row page is populated, polled for frames and
-- confirmed; the stock search filter is driven by typing into the stock search
-- box and clearing it; every close route (Confirm, Cancel/Exit, Close) must
-- reach the bridge's completion callback and close the movie.
--
-- Page data: HARNESS_PAGE_DATA (set by the gate from verify_addon_settings
-- ROW/VALROW lines of a real package) or the built-in mixed fixture.

local lists = {}
do
    local listModule = BASE_ENV.require("EE.Interface.Components.List")
    local create = listModule.CreateList
    listModule.CreateList = function(movie, ...)
        local list = create(movie, ...)
        lists[#lists + 1] = { list = list, movie = movie }
        return list
    end
end

local function listOf(instance)
    for index = #lists, 1, -1 do
        if lists[index].movie == instance.movie then
            return lists[index].list
        end
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Page data
-- ---------------------------------------------------------------------------
local VALUE_BUTTONS = {
    { label = "Bonus per Cold stack: 50x (stock 0x)", action = "open:val:Frost/cold.bonus" },
    { label = "Reward interval (stock 300 s)", subLabel = "150 s", action = "open:val:Missions/survival.reward_interval" },
    { label = "Pickup multiplier: 2.5x (stock 1.5x)", action = "open:val:Missions/survival.pickup_multiplier" },
    { label = "Level up enrage time: 1020 s (stock 1020 s)", action = "open:val:Missions/survival.level_up_enrage.enrageTime" },
}

local function fixturePage()
    local rows = {}
    local function add(spec) rows[#rows + 1] = spec end
    -- Header block as the live flat page starts (Frost, then Missions, then
    -- the first Missions section): more than 15 rows before the first
    -- INPUTCOUNT, so the stock redraw after a search filter (14 rows plus
    -- the smooth-scroll buffer) draws no INPUTCOUNT (live 2026-09-30).
    add({ kind = "TITLE", label = "FROST" })
    add({ kind = "CHECKBOX", label = "Frost package", setting = "package:frost", value = true })
    add({ kind = "CHECKBOX", label = "Use stock values", setting = "stock:frost", value = false })
    add({ kind = "TITLE", label = "ICE WAVE" })
    add({ kind = "CHECKBOX", label = "Custom Ice Wave values", setting = "group:frost/ice_wave", value = true })
    add({ kind = "CHECKBOX", label = "Custom Bonus per Cold stack", setting = "custom:frost/cold.bonus", value = true })
    add({ kind = "BUTTON", label = "Bonus per Cold stack: 50x (stock 0x)", action = "open:val:Frost/cold.bonus",
        setting = "action:open:val:Frost/cold.bonus", tooltip = "Stock 0x." })
    add({ kind = "TITLE", label = "MISSIONS" })
    add({ kind = "CHECKBOX", label = "Missions package", setting = "package:missions", value = true })
    add({ kind = "CHECKBOX", label = "Use stock values", setting = "stock:missions", value = false })
    add({ kind = "CHECKBOX", label = "Void Flood (script replacement)", setting = "member:missions/flood", value = true })
    add({ kind = "CHECKBOX", label = "Mission values: 22 sections", setting = "member:missions/values", value = true })
    add({ kind = "TITLE", label = "CAPTURE" })
    add({ kind = "CHECKBOX", label = "Custom Capture values", setting = "group:missions/capture", value = true })
    add({ kind = "CHECKBOX", label = "Custom Target health/shield mult. 1P", setting = "custom:missions/capture.p1", value = false })
    add({ kind = "CHECKBOX", label = "Custom Target health/shield mult. 2P", setting = "custom:missions/capture.p2", value = false })
    local buttonIndex = 0
    local function valueButton(locked)
        buttonIndex = buttonIndex % #VALUE_BUTTONS + 1
        local template = VALUE_BUTTONS[buttonIndex]
        add({ kind = "BUTTON", label = template.label, subLabel = template.subLabel, action = template.action,
            setting = "action:" .. template.action, tooltip = "Stock value first.", locked = locked == true })
    end
    for section = 1, 6 do
        add({ kind = "TITLE", label = "SECTION " .. tostring(section) })
        add({ kind = "CHECKBOX", label = "Package " .. tostring(section), setting = "package:p" .. section, value = true })
        add({ kind = "CHECKBOX", label = "Use stock values", setting = "stock:p" .. section, value = false })
        add({ kind = "CHECKBOX", label = "Custom value " .. section, setting = "custom:p" .. section .. "/a", value = true })
        valueButton(false)
        add({ kind = "CHECKBOX", label = "Custom count " .. section, setting = "custom:p" .. section .. "/b", value = false })
        -- Inline INPUTCOUNT rows as hosts before R4 (DLL a578bb78) send them.
        add({ kind = "INPUTCOUNT", label = "Level up enrage time (stock 1020 s)", setting = "value:p" .. section .. "/b",
            count = 1020 + section, minimum = 0, maximum = 102000, validate = true, invalid = "Enter 0 to 102000.",
            tooltip = "Stock 1020 s." })
        add({ kind = "TOGGLE", label = "Spawn mode (stock Normal)", setting = "value:p" .. section .. "/c",
            number = 1, options = { { label = "Normal", value = 1 }, { label = "Fast", value = 2 } } })
        valueButton(section % 2 == 0)
        add({ kind = "CHECKBOX", label = "Locked metadata " .. section, setting = "custom:p" .. section .. "/d",
            value = false, locked = true })
        add({ kind = "INPUTCOUNT", label = "Locked literal count", setting = "value:p" .. section .. "/e",
            count = 5, minimum = 0, maximum = 50, locked = true })
        add({ kind = "TOGGLE", label = "Locked mode", setting = "value:p" .. section .. "/f",
            number = 2, locked = true, options = { { label = "Normal", value = 1 }, { label = "Fast", value = 2 } } })
    end
    local valpages = {}
    valpages["open:val:Frost/cold.bonus"] = { title = "BONUS PER COLD STACK", rows = {
        { kind = "INPUTBOX", label = "Bonus per Cold stack (stock 0x)", setting = "value:frost/cold.bonus", content = "50",
            minimum = 0, maximum = 1000, validate = true, invalid = "Enter 0 to 1000." } } }
    valpages["open:val:Missions/survival.reward_interval"] = { title = "REWARD INTERVAL", rows = {
        { kind = "INPUTBOX", label = "Reward interval (stock 300 s)", setting = "value:missions/survival.reward_interval",
            content = "150", minimum = 1, maximum = 3600, validate = true, invalid = "Enter 1 to 3600." } } }
    valpages["open:val:Missions/survival.pickup_multiplier"] = { title = "PICKUP MULTIPLIER", rows = {
        { kind = "INPUTBOX", label = "Pickup multiplier (stock 1.5x)", setting = "value:missions/survival.pickup_multiplier",
            content = "2.5", minimum = 0, maximum = 10, validate = true, invalid = "Enter 0 to 10." } } }
    valpages["open:val:Missions/survival.level_up_enrage.enrageTime"] = { title = "LEVEL UP ENRAGE TIME", rows = {
        { kind = "INPUTCOUNT", label = "Level up enrage time (stock 1020 s)",
            setting = "value:missions/survival.level_up_enrage.enrageTime", count = 1020, minimum = 0, maximum = 102000,
            validate = true, invalid = "Enter 0 to 102000." } } }
    return { title = "SCRIPT SETTINGS", empty = "NO PACKAGE SETTINGS FOUND", search = true, rows = rows, valpages = valpages,
        source = "fixture" }
end

local PAGE = HARNESS_PAGE_DATA or fixturePage()
PAGE.empty = PAGE.empty or "NO PACKAGE SETTINGS FOUND"

-- ---------------------------------------------------------------------------
-- Host stand-in
-- ---------------------------------------------------------------------------
local staged = {}
local doneCalls = {}
local function getPage(pageId)
    if pageId == "flat" then return PAGE end
    local page = PAGE.valpages["open:" .. pageId]
    if page ~= nil then
        return { title = page.title, empty = "NO SETTINGS", search = false, rows = page.rows }
    end
    return nil
end
local function stage(value, setting) staged[#staged + 1] = { setting = setting, value = value } end
local function done(depth, elements, flag) doneCalls[#doneCalls + 1] = { depth = depth, elements = elements, flag = flag } end
local function act() end

local bridgeEnv, bridge = instantiate("bridge")
local parent = Movie.new("TopMenu")

local function step(name, fn)
    local ok, message = xpcall(fn, debug.traceback)
    if not ok then
        HARNESS.errors[#HARNESS.errors + 1] = name .. ": " .. tostring(message)
    end
    return ok
end

local function tick(instance, frames)
    for frame = 1, frames or 1 do
        step("Update " .. rawget(instance.movie, "_name"), function() instance.env.Update() end)
    end
end

local FRAME_BY_TYPE = {
    [LOTUS_UTILITIES.TITLE] = "Title",
    [LOTUS_UTILITIES.SPACER] = "Title",
    [LOTUS_UTILITIES.CHECKBOX] = "Checkbox",
    [LOTUS_UTILITIES.TOGGLE] = "Toggle",
    [LOTUS_UTILITIES.BUTTON] = "button",
    [LOTUS_UTILITIES.INPUTCOUNT] = "InputCount",
    [LOTUS_UTILITIES.INPUTBOX] = "Inputbox",
}

-- The row type's widget must be built on this clip since its last frame change.
local function checkWidget(context, element, clip, widget, childName, movie)
    local path = clip .. "." .. childName
    local bound = widget ~= nil and widget.mClipName == path
    harnessCheck(bound, context .. ": row " .. tostring(element.Id) .. " (" .. tostring(element.mLabel) .. ") "
        .. childName .. " widget is bound to " .. tostring(widget and widget.mClipName) .. ", not to its drawn clip " .. path
        .. " (the clip shows the uninitialised SWF " .. childName .. ")", "widget-unbound")
    if bound then
        harnessCheck(rawget(widget, "_serial") == clipSerial(movie, clip), context .. ": row " .. tostring(element.Id)
            .. " " .. childName .. " widget predates the clip's last frame change (stale SWF defaults shown)", "widget-unbound")
    end
end

local staleReported = 0
local function checkStaleWrites(context)
    if #HARNESS.staleWrites > staleReported then
        harnessFail(context .. ": " .. tostring(#HARNESS.staleWrites - staleReported)
            .. " widget writes into a row clip that changed frame (first: " .. HARNESS.staleWrites[staleReported + 1] .. ")",
            "stale-widget-write")
        staleReported = #HARNESS.staleWrites
    end
end

local function verifyVisible(context, instance, recycled)
    local list = listOf(instance)
    if list == nil then
        harnessFail(context .. ": no stock GenericSettings list", "no-list")
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
        harnessCheck(clipOwner[clip] == nil, context .. ": clip " .. tostring(clip) .. " is shared by two visible rows", "clip-shared")
        clipOwner[clip] = element.Id
        harnessCheck(state.frame == expectedFrame, context .. ": row " .. tostring(element.Id) .. " clip " .. tostring(clip)
            .. " frame " .. tostring(state.frame) .. " expected " .. tostring(expectedFrame), "frame")
        harnessCheck(state.text.Label == element.mLabel, context .. ": row " .. tostring(element.Id)
            .. " shows label '" .. tostring(state.text.Label) .. "' instead of its own '" .. tostring(element.mLabel) .. "'", "label")
        harnessCheck(state.colors["Bg:RectInnerColor"] == true, context .. ": row " .. tostring(element.Id)
            .. " background was never recoloured (draw did not complete)", "draw-aborted")
        if element.mType ~= LOTUS_UTILITIES.BUTTON or element.mSubLabel == nil then
            harnessCheck(state.visible.SubLabel ~= true, context .. ": row " .. tostring(element.Id)
                .. " shows a leftover sub-label '" .. tostring(state.text.SubLabel) .. "'", "sublabel")
        end
        if element.mType == LOTUS_UTILITIES.CHECKBOX then
            checkWidget(context, element, clip, element.Checkbox, "Checkbox", movie)
        elseif element.mType == LOTUS_UTILITIES.TOGGLE then
            checkWidget(context, element, clip, element.Toggle, "Toggle", movie)
        elseif element.mType == LOTUS_UTILITIES.INPUTCOUNT then
            local info = element.mButtonInfo
            harnessCheck(info ~= nil and #info == 3, context .. ": INPUTCOUNT row " .. tostring(element.Id)
                .. " has no Minus/Count/Plus widgets", "widget-unbound")
            if info ~= nil then
                for index = 1, #info do
                    checkWidget(context, element, clip, info[index].Button, info[index].Name, movie)
                end
            end
            harnessCheck(element.mCountButton ~= nil and element.mCountButton.mClipName == clip .. ".Count",
                context .. ": INPUTCOUNT row " .. tostring(element.Id) .. " count field is not the one on its clip",
                "widget-unbound")
        end
        -- Stock dims a locked row's Label (alpha 60, source line 1304) and
        -- never restores it; any other row drawn into that clip stays dim.
        if element.mLocked ~= true then
            local alpha = movie:_var(clip .. ".Label")[12]
            harnessCheck(alpha ~= 60, context .. ": row " .. tostring(element.Id) .. " (" .. tostring(element.mLabel)
                .. ") keeps the Label alpha 60 of a locked row drawn earlier in " .. clip, "locked-dim-leak")
        end
        if recycled then
            harnessCheck(element.mType ~= LOTUS_UTILITIES.INPUTCOUNT, context .. ": row " .. tostring(element.Id)
                .. " is a stock INPUTCOUNT on a recycled list", "inputcount-on-recycled-list")
            harnessCheck(element.mLocked ~= true, context .. ": row " .. tostring(element.Id)
                .. " is locked on a recycled list", "locked-on-recycled-list")
        end
    end)
    checkStaleWrites(context)
    return seen
end

local function newestInstance()
    return HARNESS.instances[#HARNESS.instances]
end

local function openFlat(context)
    local before = #HARNESS.instances
    local opened = false
    step(context .. " open", function()
        opened = bridge.hooks.openScriptSettings(parent, "resource", "flat", getPage, stage, done, act)
    end)
    harnessCheck(opened == true and #HARNESS.instances == before + 1, context .. ": bridge opened the flat page", "open")
    local instance = newestInstance()
    tick(instance, 3)
    return instance
end

local function searchBoxOf(instance)
    for index = #HARNESS.components, 1, -1 do
        local component = HARNESS.components[index]
        if component.mMovie == instance.movie and component.mClipName == "Container.SearchBox" then
            return component
        end
    end
    return nil
end

local function countMatching(list, term)
    local count = 0
    local pattern = string.gsub(string.lower(term), "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    for index = 1, #list.mUnfilteredElements do
        local element = list.mUnfilteredElements[index]
        if element.mSearchTerm ~= nil and string.find(element.mSearchTerm, pattern) then
            count = count + 1
        end
    end
    return count
end

-- Closes the page through one stock route and requires the completion
-- callback plus the movie close.
local function closeRoute(instance, route, depth)
    local calls = #doneCalls
    step(route, function()
        if route == "Confirm" then instance.env.FinishSelection()
        elseif route == "Exit" then instance.env.ExitScreen()
        else instance.env.Close() end
    end)
    tick(instance, 3)
    harnessCheck(#doneCalls == calls + 1 and doneCalls[#doneCalls].depth == depth,
        route .. ": the bridge completion callback ran once for depth " .. tostring(depth), "close")
    harnessCheck(rawget(instance.movie, "_closed") == true, route .. ": the stock screen closed its movie", "close")
end

-- ---------------------------------------------------------------------------
-- 1. Open, populate, scroll, wheel.
-- ---------------------------------------------------------------------------
local report = { source = PAGE.source or "package", rows = #PAGE.rows, pages = 0, searchSteps = 0 }
local main = openFlat("main")
local list = listOf(main)
local recycled = false
if list ~= nil then
    local rows = list:GetHowManyElements()
    recycled = list.UniformElementHeights == true and list.mVisibleElements == 14 and list.mScrollBar ~= nil
    harnessCheck(rows == #PAGE.rows, "stock list holds every row (" .. tostring(rows) .. "/" .. #PAGE.rows .. ")", "rows")
    harnessCheck(list.UniformElementHeights == true, "stock populate keeps UniformElementHeights", "scroll")
    harnessCheck(recycled == (rows > 14), "stock populate attaches the scroll bar (14 visible) exactly when the page has more than 14 rows", "scroll")
    local buttons = 0
    list:RunForAllElements(function(element)
        if element.mType == LOTUS_UTILITIES.BUTTON then
            buttons = buttons + 1
            harnessCheck(element.mSubLabel == nil or element.mButtonWidth ~= nil,
                "row " .. tostring(element.Id) .. ": BUTTON mSubLabel without mButtonWidth (stock L991 nil arithmetic)", "sublabel")
        end
        harnessCheck(element.mHeight == nil or element.mHeight == 44, "row " .. tostring(element.Id) .. ": uniform 44 px height", "scroll")
    end)
    report.buttons = buttons
    local searchX = main.movie:_var("Container.SearchBox")[0]
    local panelWidth = main.movie:_var("Container.BgFill")[14]
    harnessCheck(type(searchX) == "number" and type(panelWidth) == "number" and searchX < panelWidth,
        "stock layout ran after the redraw: search box placed inside the panel (x=" .. tostring(searchX)
            .. " width=" .. tostring(panelWidth) .. ")", "layout")
    verifyVisible("open", main, recycled)

    local positions = recycled and rows - 14 or -1
    for position = 0, positions do
        step("scrollbar " .. position, function() list.mScrollBar:SetValue(position / positions) end)
        tick(main)
        verifyVisible("scrollbar " .. position, main, recycled)
    end
    for position = positions, 0, -3 do
        step("scrollbar back " .. position, function() list.mScrollBar:SetValue(position / positions) end)
        tick(main)
        verifyVisible("scrollbar back " .. position, main, recycled)
    end
    for wheel = 1, (recycled and positions + 2 or 0) do
        step("wheel down " .. wheel, function() main.env.onKeyDown_MENU_MOUSE_Z(0, "1") end)
        tick(main)
        verifyVisible("wheel down " .. wheel, main, recycled)
    end
    for wheel = 1, (recycled and 5 or 0) do
        step("wheel up " .. wheel, function() main.env.onKeyDown_MENU_MOUSE_Z(0, "-1") end)
        tick(main)
        verifyVisible("wheel up " .. wheel, main, recycled)
    end
    if recycled then
        step("scroll home", function() list.mScrollBar:SetValue(0) end)
    end
    tick(main, 2)

    -- -----------------------------------------------------------------------
    -- 2. Every page a BUTTON opens (value pages, R4 one-row pages): press it
    -- through the stock selection callback, populate, poll, confirm.
    -- -----------------------------------------------------------------------
    local openers = {}
    list:RunForAllElements(function(element)
        if element.mType == LOTUS_UTILITIES.BUTTON and element.mLocked ~= true then
            openers[#openers + 1] = element
        end
    end)
    for index = 1, #openers do
        local element = openers[index]
        local before = #HARNESS.instances
        step("press " .. tostring(element.mLabel), function() list.mOnSelectedCallback(element) end)
        if #HARNESS.instances == before + 1 then
            local child = newestInstance()
            report.pages = report.pages + 1
            tick(child, 3)
            local childList = listOf(child)
            harnessCheck(childList ~= nil and childList:GetHowManyElements() == 1,
                "page from '" .. tostring(element.mLabel) .. "' holds exactly one row", "value-page")
            if childList ~= nil then
                childList:RunForAllElements(function(row)
                    harnessCheck(row.mType == LOTUS_UTILITIES.INPUTCOUNT or row.mType == LOTUS_UTILITIES.INPUTBOX,
                        "page from '" .. tostring(element.mLabel) .. "' holds a stock INPUTCOUNT or INPUTBOX", "value-page")
                end)
            end
            verifyVisible("page " .. tostring(element.mLabel), child, false)
            tick(child, 5)
            verifyVisible("page after poll " .. tostring(element.mLabel), child, false)
            closeRoute(child, "Confirm", 2)
        end
    end

    -- -----------------------------------------------------------------------
    -- 3. Stock search: the bridge under test must keep the box hidden; the
    -- stock filter is then driven directly (type, extend, clear) to prove the
    -- rows survive it, and every close route still works afterwards.
    -- -----------------------------------------------------------------------
    local executed = rawget(main.movie, "_executed")
    local shown = false
    for index = 1, #executed do
        shown = shown or executed[index] == "ShowHideSearchBox"
    end
    report.searchShown = shown
    local box = searchBoxOf(main)
    harnessCheck(box ~= nil, "the stock search box exists", "search")
end

local function driveSearch(instance, context)
    local box = searchBoxOf(instance)
    local target = listOf(instance)
    if box == nil or target == nil then return end
    local total = #target.mUnfilteredElements
    local previous = ""
    for _, term in ipairs({ "e", "en", "enr", "en", "", "custom", "" }) do
        -- Stock filter (source lines 685-709): when the new term is part of
        -- the previous one (a deleted character) it only removes rows from
        -- the current list; otherwise it rebuilds from the populate copies.
        local narrowing = previous ~= "" and term ~= ""
            and string.find(string.lower(previous), string.lower(term), 1, true) ~= nil
        local expected = nil
        if narrowing then
            expected = 0
            target:RunForAllElements(function(element)
                if element.mSearchTerm ~= nil and string.find(element.mSearchTerm, string.lower(term), 1, true) then
                    expected = expected + 1
                end
            end)
        end
        step(context .. " type '" .. term .. "'", function() box:InputFieldTextChanged(term) end)
        tick(instance, 3)
        report.searchSteps = report.searchSteps + 1
        previous = term
        expected = expected or (term == "" and total or countMatching(target, term))
        local shownRows = target:GetHowManyElements()
        harnessCheck(shownRows == expected, context .. " '" .. term .. "': the filter shows " .. tostring(shownRows)
            .. " rows, expected " .. tostring(expected), "search")
        if term ~= "" then
            local pattern = string.gsub(string.lower(term), "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
            target:RunForAllElements(function(element)
                harnessCheck(element.mSearchTerm ~= nil and string.find(element.mSearchTerm, pattern) ~= nil,
                    context .. " '" .. term .. "': row '" .. tostring(element.mLabel) .. "' does not match", "search")
            end)
        end
        verifyVisible(context .. " '" .. term .. "'", instance, recycled)
    end
end

if list ~= nil then
    driveSearch(main, "search")
    closeRoute(main, "Confirm", 1)
    for _, route in ipairs({ "Exit", "Close" }) do
        local instance = openFlat(route)
        driveSearch(instance, route .. " search")
        closeRoute(instance, route, 1)
    end

    -- Stock property that keeps the search box hidden: the filter re-adds the
    -- copies taken at populate, so a CHECKBOX changed before typing shows its
    -- old value again and the completion pass would stage that old value.
    local probe = openFlat("snapshot")
    local probeList = listOf(probe)
    local target = nil
    if probeList ~= nil then
        probeList:RunForAllVisibleElements(function(element)
            if target == nil and element.mType == LOTUS_UTILITIES.CHECKBOX and element.mLocked ~= true
                and element.Checkbox ~= nil then
                target = element
            end
        end)
    end
    if target ~= nil then
        local original = target.mValue
        step("snapshot focus", function() probeList.mOnFocusedCallback(target) end)
        step("snapshot toggle", function()
            target.Checkbox.mChecked = not original
            target.Checkbox.ValueChanged(target.Checkbox)
        end)
        local label = string.lower(target.mLabel)
        step("snapshot type", function() searchBoxOf(probe):InputFieldTextChanged(label) end)
        tick(probe, 3)
        local copy = nil
        probeList:RunForAllElements(function(element)
            if copy == nil and element.mSetting == target.mSetting then copy = element end
        end)
        report.snapshotRevert = copy ~= nil and copy.mValue == original and target.mValue ~= original
    end
    closeRoute(probe, "Exit", 1)
end

-- ---------------------------------------------------------------------------
-- 4. R5 (HARNESS_R5, current bridge only): nested navigation (packages ->
-- package -> section -> value page, depth 4) with every close route, value
-- edits on INPUTBOX and INPUTCOUNT pages, the parent refresh on return, the
-- Back-route validation message, an explicit switch click and a Restore.
-- The host stand-in below keeps a small model with the R5 staging rules so
-- the pages the bridge re-reads show the staged edits; every host stage call
-- is printed (STAGELOG) and the gate replays it through the real C++ host
-- model and values-file writer (verify_addon_settings -Replay).
-- ---------------------------------------------------------------------------
local r5Report = { sessions = 0, returns = 0, refreshed = 0, messages = 0, stockMessages = 0, maxDepth = 0 }
if HARNESS_R5 == true then
    local messages = {}
    rawset(UTIL, "ShowMessage", function(message) messages[#messages + 1] = tostring(message) end)

    local MODEL = {
        { folder = "Frost", key = "frost", members = 1, groups = { { id = "ice_wave", label = "Ice Wave" } },
          values = {
            { id = "ice_wave.bonus_per_cold_stack", group = "ice_wave", label = "Bonus per Cold stack", unit = "x",
              kind = "float", stock = 0, min = 0, max = 100, enabled = true, value = 50 } } },
        { folder = "Missions", key = "missions", members = 2,
          groups = { { id = "survival", label = "Survival" }, { id = "purgatory", label = "Purgatory" } },
          values = {
            { id = "survival.reward_interval", group = "survival", label = "Reward interval", unit = " s",
              kind = "float", stock = 300, min = 1, max = 32767, enabled = true, value = 150 },
            { id = "survival.alert_interval", group = "survival", label = "Seconds per reward rotation", unit = " s",
              kind = "float", stock = 600, min = 1, max = 60000, enabled = false, value = 600 },
            { id = "purgatory.difficulty1.warrior_level", group = "purgatory", label = "Difficulty 1 warrior level", unit = "",
              kind = "int", stock = 10, min = 1, max = 1000, enabled = false, value = 10 } } },
    }
    local session = nil
    local r5Done = {}

    local function newSession(name)
        session = { name = name, value = {}, custom = {}, implied = {}, restores = {} }
        r5Report.sessions = r5Report.sessions + 1
        print("STAGELOG\tSESSION\t" .. name)
    end
    local function findValue(key, id)
        for _, package in ipairs(MODEL) do
            if package.key == key then
                for _, value in ipairs(package.values) do
                    if value.id == id then return package, value end
                end
            end
        end
        return nil, nil
    end
    local function restored(package, value)
        return session.restores[package.folder] == true or session.restores[package.folder .. "/" .. value.group] == true
    end
    local function current(value)
        local staged = session.value[value.id]
        if staged ~= nil then return staged end
        return value.value
    end
    local function enabledOf(package, value)
        local enabled = value.enabled
        if session.custom[value.id] ~= nil then enabled = session.custom[value.id] end
        if session.implied[value.id] == true then enabled = true end
        if restored(package, value) then enabled = false end
        return enabled
    end
    local function valueLabel(value)
        return value.label .. ": " .. tostring(current(value)) .. value.unit
    end
    local function summary(package, group)
        local count, custom = 0, 0
        for _, value in ipairs(package.values) do
            if group == nil or value.group == group then
                count = count + 1
                if enabledOf(package, value) then custom = custom + 1 end
            end
        end
        return tostring(count) .. (count == 1 and " value - " or " values - ") .. tostring(custom) .. " custom"
    end
    local function button(label, action)
        return { kind = "BUTTON", label = label, action = action, setting = "action:" .. action }
    end
    local function r5GetPage(pageId)
        if pageId == "root" then
            local rows = {}
            for _, package in ipairs(MODEL) do
                rows[#rows + 1] = button(package.folder .. ": " .. summary(package, nil), "open:pkg:" .. package.folder)
            end
            return { title = "SCRIPT SETTINGS", empty = "NO PACKAGE SETTINGS FOUND", rows = rows }
        end
        for _, package in ipairs(MODEL) do
            if pageId == "pkg:" .. package.folder then
                local rows = {
                    { kind = "CHECKBOX", label = package.folder .. " package", setting = "package:" .. package.key, value = true },
                    { kind = "CHECKBOX", label = "Use stock values", setting = "stock:" .. package.key, value = false },
                }
                if package.members > 1 then
                    for member = 1, package.members do
                        rows[#rows + 1] = { kind = "CHECKBOX", label = "Member " .. member, setting = "member:" .. package.key .. "/m" .. member, value = true }
                    end
                end
                rows[#rows + 1] = { kind = "SPACER" }
                rows[#rows + 1] = { kind = "TITLE", label = "SECTIONS" }
                for _, group in ipairs(package.groups) do
                    rows[#rows + 1] = button(group.label .. ": " .. summary(package, group.id), "open:grp:" .. package.folder .. "/" .. group.id)
                end
                rows[#rows + 1] = { kind = "SPACER" }
                rows[#rows + 1] = button("Restore all stock values", "restore:" .. package.folder)
                return { title = string.upper(package.folder), empty = "NO SETTINGS", rows = rows }
            end
            for _, group in ipairs(package.groups) do
                if pageId == "grp:" .. package.folder .. "/" .. group.id then
                    local rows = { { kind = "CHECKBOX", label = "Custom " .. group.label .. " values", setting = "group:" .. package.key .. "/" .. group.id, value = true } }
                    for _, value in ipairs(package.values) do
                        if value.group == group.id then
                            rows[#rows + 1] = { kind = "CHECKBOX", label = "Custom " .. value.label,
                                setting = "custom:" .. package.key .. "/" .. value.id, value = enabledOf(package, value) }
                            rows[#rows + 1] = button(valueLabel(value), "open:val:" .. package.folder .. "/" .. value.id)
                        end
                    end
                    rows[#rows + 1] = { kind = "SPACER" }
                    rows[#rows + 1] = button("Restore " .. group.label .. " stock values", "restore:" .. package.folder .. "/" .. group.id)
                    return { title = string.upper(group.label), empty = "NO SETTINGS", rows = rows }
                end
            end
            for _, value in ipairs(package.values) do
                if pageId == "val:" .. package.folder .. "/" .. value.id then
                    local row = { label = value.label, setting = "value:" .. package.key .. "/" .. value.id,
                        minimum = value.min, maximum = value.max, validate = true,
                        invalid = value.label .. ": enter a number from " .. tostring(value.min) .. " to " .. tostring(value.max) .. "." }
                    if value.kind == "int" then
                        row.kind = "INPUTCOUNT"
                        row.count = current(value)
                        row.integer = true
                    else
                        row.kind = "INPUTBOX"
                        row.content = tostring(current(value))
                    end
                    return { title = string.upper(value.label), empty = "NO SETTINGS", rows = { row } }
                end
            end
        end
        return nil
    end
    local function r5Stage(value, setting, source)
        local kind = type(value) == "boolean" and "bool" or (type(value) == "number" and "number" or "text")
        local flag = source == "click" and "click" or "restage"
        print("STAGELOG\tSTAGE\t" .. tostring(setting) .. "\t" .. kind .. "\t" .. tostring(value) .. "\t" .. flag)
        local prefix, key, id = string.match(tostring(setting), "^(%a+):([^/]+)/(.+)$")
        local package, entry = findValue(key, id)
        if entry == nil then return end
        if prefix == "value" then
            local number = tonumber(value)
            if number == nil or number < entry.min or number > entry.max or (entry.kind == "int" and number % 1 ~= 0) then
                return
            end
            session.value[entry.id] = number
            session.implied[entry.id] = (number ~= entry.value) or nil
        elseif prefix == "custom" then
            session.custom[entry.id] = value == true
            if flag == "click" then session.implied[entry.id] = nil end
        end
    end
    local function r5DoneFn(depth, elements, flag)
        r5Done[#r5Done + 1] = { depth = depth, flag = flag }
    end
    local function r5Act(action)
        print("STAGELOG\tRESTORE\t" .. string.sub(action, 9))
        session.restores[string.sub(action, 9)] = true
    end

    local function elementBy(instance, predicate)
        local found = nil
        local target = listOf(instance)
        if target == nil then return nil end
        target:RunForAllElements(function(element)
            if found == nil and predicate(element) then found = element end
        end)
        return found
    end
    local function bySetting(instance, setting)
        return elementBy(instance, function(element) return element.mSetting == setting end)
    end
    -- Presses a BUTTON through the stock selection callback; returns the page it opened.
    local function press(instance, setting, context, depth)
        local element = bySetting(instance, setting)
        harnessCheck(element ~= nil, context .. ": row " .. setting .. " exists", "r5-nav")
        if element == nil then return nil end
        local before = #HARNESS.instances
        step(context .. " press " .. setting, function() listOf(instance).mOnSelectedCallback(element) end)
        if #HARNESS.instances ~= before + 1 then
            harnessFail(context .. ": " .. setting .. " opened no page", "r5-nav")
            return nil
        end
        local child = newestInstance()
        tick(child, 3)
        r5Report.maxDepth = math.max(r5Report.maxDepth, depth)
        harnessCheck(listOf(child) ~= nil and listOf(child):GetHowManyElements() >= 1,
            context .. ": the page opened by " .. setting .. " populates (depth " .. depth .. ")", "r5-nav")
        verifyVisible(context .. " depth " .. depth, child, false)
        return child
    end
    -- Closes a page through one stock route; it must reach the bridge once,
    -- close its movie and return to its still open, intact parent.
    local function closeR5(instance, route, depth, parent, context)
        local calls = #r5Done
        step(context .. " " .. route, function()
            if route == "Confirm" then instance.env.FinishSelection()
            elseif route == "Exit" then instance.env.ExitScreen()
            else instance.env.Close() end
        end)
        tick(instance, 3)
        harnessCheck(#r5Done == calls + 1 and r5Done[#r5Done].depth == depth,
            context .. " " .. route .. ": the bridge completion ran once for depth " .. depth, "r5-close")
        harnessCheck(rawget(instance.movie, "_closed") == true, context .. " " .. route .. ": the page closed its movie", "r5-close")
        if parent ~= nil then
            harnessCheck(rawget(parent.movie, "_closed") ~= true and listOf(parent) ~= nil,
                context .. " " .. route .. ": returned to the open parent page (depth " .. (depth - 1) .. ")", "r5-close")
            tick(parent, 2)
            verifyVisible(context .. " back at depth " .. (depth - 1), parent, false)
            r5Report.returns = r5Report.returns + 1
        end
    end
    local function typeInto(instance, text)
        local element = elementBy(instance, function(row) return row.mType == LOTUS_UTILITIES.INPUTBOX end)
        harnessCheck(element ~= nil and element.InputField ~= nil, "value page holds a stock INPUTBOX with its input field", "r5-edit")
        if element ~= nil and element.InputField ~= nil then
            instance.movie:SetStringVariable(element.InputField.mLabelClipName, 36, text)
            element.mChanged = true
        end
    end
    local function setCount(instance, count)
        local element = elementBy(instance, function(row) return row.mType == LOTUS_UTILITIES.INPUTCOUNT end)
        harnessCheck(element ~= nil, "value page holds a stock INPUTCOUNT", "r5-edit")
        if element ~= nil then
            element.mCount = count
            element.mChanged = true
        end
    end
    local function openRoot(context)
        local before = #HARNESS.instances
        local opened = false
        step(context .. " open", function()
            opened = bridge.hooks.openScriptSettings(parent, "resource", "nested", r5GetPage, r5Stage, r5DoneFn, r5Act)
        end)
        harnessCheck(opened == true and #HARNESS.instances == before + 1, context .. ": the nested root page opened", "r5-nav")
        local root = newestInstance()
        tick(root, 3)
        local rows = listOf(root)
        harnessCheck(rows ~= nil and rows:GetHowManyElements() == #MODEL, context .. ": the top page lists only the packages ("
            .. tostring(rows and rows:GetHowManyElements()) .. " rows)", "r5-nav")
        verifyVisible(context .. " root", root, false)
        return root
    end
    local function expectRow(instance, setting, context, label, value)
        local element = bySetting(instance, setting)
        local ok = element ~= nil and (label == nil or element.mLabel == label) and (value == nil or element.mValue == value)
            -- A drawn switch must also show it (its stock widget state).
            and (value == nil or element.mClipName == nil or element.Checkbox == nil or element.Checkbox.mChecked == value)
        harnessCheck(ok, context .. ": after the return, row " .. setting .. " shows '" .. tostring(label) .. "'"
            .. (value ~= nil and (" and value " .. tostring(value)) or "") .. " (it shows '" .. tostring(element and element.mLabel)
            .. "', value " .. tostring(element and element.mValue) .. ")", "r5-refresh")
        if ok then r5Report.refreshed = r5Report.refreshed + 1 end
    end

    -- Missions: the Survival "Seconds per reward rotation" (the live edit),
    -- through every close route at every level.
    for _, route in ipairs({ "Confirm", "Exit", "Close" }) do
        local name = "missions_alert_" .. string.lower(route)
        newSession(name)
        local root = openRoot(name)
        local pkg = root and press(root, "action:open:pkg:Missions", name, 2)
        local grp = pkg and press(pkg, "action:open:grp:Missions/survival", name, 3)
        local val = grp and press(grp, "action:open:val:Missions/survival.alert_interval", name, 4)
        if val ~= nil then
            typeInto(val, "60")
            closeR5(val, route, 4, grp, name)
            if route ~= "Close" then
                expectRow(grp, "custom:missions/survival.alert_interval", name, "Custom Seconds per reward rotation", true)
                expectRow(grp, "action:open:val:Missions/survival.alert_interval", name, "Seconds per reward rotation: 60 s", nil)
            else
                expectRow(grp, "action:open:val:Missions/survival.alert_interval", name, "Seconds per reward rotation: 600 s", nil)
            end
            closeR5(grp, route, 3, pkg, name)
            expectRow(pkg, "action:open:grp:Missions/survival", name,
                route ~= "Close" and "Survival: 2 values - 2 custom" or "Survival: 2 values - 1 custom", nil)
            closeR5(pkg, route, 2, root, name)
            expectRow(root, "action:open:pkg:Missions", name,
                route ~= "Close" and "Missions: 3 values - 2 custom" or "Missions: 3 values - 1 custom", nil)
            closeR5(root, route, 1, nil, name)
        end
    end

    -- Frost: an out-of-range value on Back shows the row's own stock message
    -- and keeps 50; on Confirm the stock validator keeps the page open; 100
    -- then applies.
    do
        local name = "frost_invalid_then_valid"
        newSession(name)
        local root = openRoot(name)
        local pkg = root and press(root, "action:open:pkg:Frost", name, 2)
        local grp = pkg and press(pkg, "action:open:grp:Frost/ice_wave", name, 3)
        local val = grp and press(grp, "action:open:val:Frost/ice_wave.bonus_per_cold_stack", name, 4)
        if val ~= nil then
            local before = #messages
            typeInto(val, "250")
            closeR5(val, "Exit", 4, grp, name)
            harnessCheck(#messages == before + 1 and messages[#messages] == "Bonus per Cold stack: enter a number from 0 to 100.",
                name .. ": Back with 250 shows the row's stock message once (got " .. tostring(#messages - before) .. ": "
                    .. tostring(messages[#messages]) .. ")", "r5-validate")
            r5Report.messages = r5Report.messages + (#messages - before)
            expectRow(grp, "action:open:val:Frost/ice_wave.bonus_per_cold_stack", name, "Bonus per Cold stack: 50x", nil)
            val = press(grp, "action:open:val:Frost/ice_wave.bonus_per_cold_stack", name, 4)
            if val ~= nil then
                typeInto(val, "250")
                local calls = #r5Done
                local shown = #messages
                step(name .. " Confirm 250", function() val.env.FinishSelection() end)
                tick(val, 3)
                harnessCheck(#r5Done == calls and rawget(val.movie, "_closed") ~= true and #messages == shown + 1,
                    name .. ": Confirm with 250 runs the stock validator, shows its message and keeps the page open", "r5-validate")
                r5Report.stockMessages = r5Report.stockMessages + (#messages - shown)
                typeInto(val, "100")
                closeR5(val, "Confirm", 4, grp, name)
                expectRow(grp, "action:open:val:Frost/ice_wave.bonus_per_cold_stack", name, "Bonus per Cold stack: 100x", nil)
                expectRow(grp, "custom:frost/ice_wave.bonus_per_cold_stack", name, nil, true)
            end
            closeR5(grp, "Exit", 3, pkg, name)
            closeR5(pkg, "Exit", 2, root, name)
            closeR5(root, "Confirm", 1, nil, name)
        end
    end

    -- An explicit click on the ticked switch after the edit turns it off.
    do
        local name = "missions_click_off"
        newSession(name)
        local root = openRoot(name)
        local pkg = root and press(root, "action:open:pkg:Missions", name, 2)
        local grp = pkg and press(pkg, "action:open:grp:Missions/survival", name, 3)
        local val = grp and press(grp, "action:open:val:Missions/survival.alert_interval", name, 4)
        if val ~= nil then
            typeInto(val, "60")
            closeR5(val, "Confirm", 4, grp, name)
            local switch = bySetting(grp, "custom:missions/survival.alert_interval")
            harnessCheck(switch ~= nil and switch.Checkbox ~= nil, name .. ": the Custom switch has its stock checkbox widget", "r5-click")
            if switch ~= nil and switch.Checkbox ~= nil then
                -- A click focuses the row first; the stock value-changed
                -- dispatch reports the focused element.
                step(name .. " focus", function() listOf(grp).mOnFocusedCallback(switch) end)
                step(name .. " click", function()
                    switch.Checkbox.mChecked = false
                    switch.Checkbox.ValueChanged(switch.Checkbox)
                end)
            end
            closeR5(grp, "Confirm", 3, pkg, name)
            closeR5(pkg, "Confirm", 2, root, name)
            closeR5(root, "Confirm", 1, nil, name)
        end
    end

    -- INPUTCOUNT value page (int) and a section Restore.
    do
        local name = "purgatory_int_and_survival_restore"
        newSession(name)
        local root = openRoot(name)
        local pkg = root and press(root, "action:open:pkg:Missions", name, 2)
        local grp = pkg and press(pkg, "action:open:grp:Missions/purgatory", name, 3)
        local val = grp and press(grp, "action:open:val:Missions/purgatory.difficulty1.warrior_level", name, 4)
        if val ~= nil then
            setCount(val, 25)
            closeR5(val, "Confirm", 4, grp, name)
            expectRow(grp, "action:open:val:Missions/purgatory.difficulty1.warrior_level", name, "Difficulty 1 warrior level: 25", nil)
            expectRow(grp, "custom:missions/purgatory.difficulty1.warrior_level", name, nil, true)
            closeR5(grp, "Exit", 3, pkg, name)
            local survival = press(pkg, "action:open:grp:Missions/survival", name, 3)
            if survival ~= nil then
                local calls = #r5Done
                local element = bySetting(survival, "action:restore:Missions/survival")
                step(name .. " restore", function() listOf(survival).mOnSelectedCallback(element) end)
                tick(survival, 3)
                harnessCheck(#r5Done == calls + 1 and r5Done[#r5Done].depth == 3 and rawget(survival.movie, "_closed") == true,
                    name .. ": Restore stages and closes its section page through Confirm", "r5-close")
                tick(pkg, 2)
                r5Report.returns = r5Report.returns + 1
                expectRow(pkg, "action:open:grp:Missions/survival", name, "Survival: 2 values - 0 custom", nil)
            end
            closeR5(pkg, "Confirm", 2, root, name)
            closeR5(root, "Confirm", 1, nil, name)
        end
    end
end

for index = 1, #HARNESS.errors do
    print("ERROR\t" .. HARNESS.errors[index])
end
local shownFailures = 0
for index = 1, #HARNESS.failures do
    if shownFailures < 40 then print("FAIL\t" .. HARNESS.failures[index]) end
    shownFailures = shownFailures + 1
end
local categories = {}
for name in pairs(HARNESS.categories) do categories[#categories + 1] = name end
table.sort(categories)
for index = 1, #categories do
    print("CATEGORY\t" .. categories[index] .. "\t" .. tostring(HARNESS.categories[categories[index]]))
end
print("REPORT\tsource=" .. tostring(report.source) .. " rows=" .. tostring(report.rows) .. " buttons=" .. tostring(report.buttons)
    .. " pages=" .. tostring(report.pages) .. " search_steps=" .. tostring(report.searchSteps)
    .. " search_shown=" .. tostring(report.searchShown) .. " snapshot_revert=" .. tostring(report.snapshotRevert)
    .. " stale_writes=" .. tostring(#HARNESS.staleWrites) .. " instances=" .. tostring(#HARNESS.instances)
    .. " r5_sessions=" .. tostring(r5Report.sessions) .. " r5_returns=" .. tostring(r5Report.returns)
    .. " r5_refreshed=" .. tostring(r5Report.refreshed) .. " r5_back_messages=" .. tostring(r5Report.messages)
    .. " r5_stock_messages=" .. tostring(r5Report.stockMessages) .. " r5_max_depth=" .. tostring(r5Report.maxDepth))
if #HARNESS.errors == 0 and #HARNESS.failures == 0 then
    print("SCRIPT SETTINGS RENDER HARNESS PASS checks=" .. tostring(HARNESS.checks) .. " rows=" .. tostring(#PAGE.rows))
else
    print("SCRIPT SETTINGS RENDER HARNESS FAIL errors=" .. tostring(#HARNESS.errors) .. " failures=" .. tostring(#HARNESS.failures)
        .. " checks=" .. tostring(HARNESS.checks))
end
