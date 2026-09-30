--!nocheck
-- SCRIPT SETTINGS render harness, prelude (R3, 2026-09-30).
--
-- Runs the real 44.0.2 stock ThemedGenericSettings and EE.Interface.Components.List
-- code (derecomp decompile-mod-u44 renders of the stock bytecode, see
-- stock/STOCK_INPUTS.txt) against a recording Flash movie. Only the engine
-- (Flash, timers, the scroll-bar component, themed widgets) is simulated; the
-- element list, the Update/populate path, the per-row draw callback, the list
-- recycling and scroll redraws and the panel layout are the stock functions.
--
-- The gate script concatenates: this prelude, the module wrappers
-- (MODULE_SOURCES[...] = function(...) <source> end) and harness_driver.luau.

local HARNESS = {
    failures = {},
    checks = 0,
    errors = {},
}

local function harnessFail(message)
    HARNESS.failures[#HARNESS.failures + 1] = message
end

local function harnessCheck(condition, message)
    HARNESS.checks = HARNESS.checks + 1
    if not condition then
        harnessFail(message)
    end
    return condition
end

local MODULE_SOURCES = {}

-- ---------------------------------------------------------------------------
-- Recording Flash movie
-- ---------------------------------------------------------------------------
local Movie = {}
local movieSerial = 0

local function newClipState()
    return { frame = nil, text = {}, visible = {}, numbers = {}, colors = {} }
end

function Movie.new(name)
    movieSerial = movieSerial + 1
    local movie = {
        _name = name .. "#" .. tostring(movieSerial),
        _vars = {},
        _clips = {},
        _pendingFrames = {},
        _log = {},
        _instance = nil,
        _created = { ["Container.OptionList.MenuEntry1"] = true },
        _duplicates = 0,
    }
    return setmetatable(movie, Movie)
end

Movie.__index = function(self, key)
    local method = rawget(Movie, key)
    if method ~= nil then
        return method
    end
    -- Any other engine method: accepted and recorded, returns nil.
    return function(this, ...)
        local log = rawget(this, "_log")
        log[#log + 1] = key
        return nil
    end
end

function Movie:_clip(path)
    local clips = rawget(self, "_clips")
    local state = clips[path]
    if state == nil then
        state = newClipState()
        clips[path] = state
    end
    return state
end

function Movie:_var(path)
    local vars = rawget(self, "_vars")
    local entry = vars[path]
    if entry == nil then
        entry = {}
        vars[path] = entry
    end
    return entry
end

local function defaultNumber(property)
    if property == 14 then return 800 end -- width
    if property == 15 then return 40 end  -- height
    if property == 12 then return 100 end -- alpha
    return 0
end

function Movie:SetNumberVariable(path, property, value)
    self:_var(path)[property] = value
end

function Movie:GetNumberVariable(path, property)
    local value = self:_var(path)[property]
    if type(value) == "number" then return value end
    return defaultNumber(property)
end

-- Name__82f6549c(clip, member, property, number): member number setter.
function Movie:Name__82f6549c(clip, member, property, value)
    if type(value) ~= "number" then
        error("SetMemberNumber " .. tostring(clip) .. "." .. tostring(member) .. " prop " .. tostring(property)
            .. " received " .. type(value), 2)
    end
    self:_var(clip .. "." .. member)[property] = value
end

-- Name__fd1f2935(clip, member, property): member number getter.
function Movie:Name__fd1f2935(clip, member, property)
    local value = self:_var(clip .. "." .. member)[property]
    if type(value) == "number" then return value end
    return defaultNumber(property)
end

-- Name__34a7a1c9(clip, member, property, text): member string setter (36 = text).
function Movie:Name__34a7a1c9(clip, member, property, value)
    if property == 36 then
        self:_clip(clip).text[member] = value
    end
end

-- Name__e375fc94(clip, member, property, flag): member bool setter (13 = visible).
function Movie:Name__e375fc94(clip, member, property, value)
    if property == 13 then
        self:_clip(clip).visible[member] = value
    end
end

-- Name__863e56e7(path, property, flag): bool variable.
function Movie:Name__863e56e7(path, property, value)
    self:_var(path)[property] = value
end

function Movie:SetStringVariable(path, property, value)
    self:_var(path)[property] = value
end

function Movie:GetStringVariable(path, property)
    local value = self:_var(path)[property]
    if type(value) == "string" then return value end
    return ""
end

function Movie:SetLocalized(path, text)
    local clip, member = string.match(path, "^(.*)%.([^%.]+)%.text$")
    if clip ~= nil then
        self:_clip(clip).text[member] = text
    end
end

function Movie:GetLocalized(key)
    return key
end

-- Clip existence: the template clips exist; List duplicates the others.
function Movie:HasVariable(path)
    local created = rawget(self, "_created")
    return created[path] == true
end

-- Name__48ecbbab(path, colorName, r, g, b, a): procedural colour.
function Movie:Name__48ecbbab(path, colorName)
    local clip, member = string.match(path, "^(.*)%.([^%.]+)$")
    if clip ~= nil then
        self:_clip(clip).colors[member .. ":" .. tostring(colorName)] = true
    end
end

function Movie:GetMovieHeight() return 1080 end
function Movie:GetMovieWidth() return 1920 end
function Movie:GetViewportWidth() return 1920 end
function Movie:GetViewportHeight() return 1080 end

-- Name__3e8ea7a1(dt): the movie's native tick; runs finished interpolations.
function Movie:Name__3e8ea7a1()
    local pending = rawget(self, "_pendingFrames")
    rawset(self, "_pendingFrames", {})
    for index = 1, #pending do
        pending[index]()
    end
end

function Movie:PushChildMovie(resource)
    return HARNESS.pushGenericSettings(self, resource)
end

function Movie:Execute(name, argument)
    local instance = rawget(self, "_instance")
    if instance == nil then
        error("Execute on a movie without a script: " .. tostring(name), 2)
    end
    local handler = instance.env[name]
    if type(handler) ~= "function" then
        error("Execute: unknown stock function " .. tostring(name), 2)
    end
    return handler(argument)
end

local function flashMethod(movie, path, argument)
    local clip, method = string.match(path, "^(.*)%.([^%.]+)$")
    if method == "gotoAndStop" then
        movie:_clip(clip).frame = argument
    elseif method == "duplicateMovieClip" then
        local parentPath = string.match(clip, "^(.*)%.[^%.]+$") or ""
        local created = rawget(movie, "_created")
        created[parentPath .. "." .. tostring(argument)] = true
        rawset(movie, "_duplicates", rawget(movie, "_duplicates") + 1)
    end
    return nil
end

local function flashInterpolate(movie, path, property, fromValues, toValues, duration, delay, onDone)
    if type(onDone) == "function" then
        local pending = rawget(movie, "_pendingFrames")
        pending[#pending + 1] = onDone
    end
end

-- ---------------------------------------------------------------------------
-- Engine stubs (not stock script logic)
-- ---------------------------------------------------------------------------
local function permissiveTable(name)
    return setmetatable({ _stubName = name }, {
        __index = function(t, key)
            local fn = function() return nil end
            rawset(t, key, fn)
            return fn
        end,
    })
end

-- Themed widget stand-in: data fields (mXxx) are plain values, anything else
-- is a no-op method.
local COMPONENT_DEFAULTS = { mMaxSize = 200, mMinSize = 200, mHeight = 28, mWidth = 200 }
local function newComponent(movie, clip, kind)
    local component = {
        mMovie = movie,
        mClipName = clip,
        mLabel = "",
        mKind = kind,
        TYPE = { PLAIN = 0, PASSWORD = 1, NUMBER = 2 },
    }
    for key, value in pairs(COMPONENT_DEFAULTS) do component[key] = value end
    return setmetatable(component, {
        __index = function(t, key)
            if string.match(key, "^m%u") then return nil end
            local fn = function() return nil end
            rawset(t, key, fn)
            return fn
        end,
    })
end

local function componentModule(kind)
    local module = permissiveTable(kind)
    rawset(module, "Create__e256561c", function(movie, clip, ...)
        return newComponent(movie, clip, kind)
    end)
    rawset(module, "Create", function(movie, clip, ...)
        return newComponent(movie, clip, kind)
    end)
    return module
end

local function newTimerMgr()
    local manager = { timers = {} }
    function manager:AddTimer(delay, callback)
        self.timers[#self.timers + 1] = { remaining = delay, callback = callback }
    end
    function manager:Update(dt)
        local due = {}
        local keep = {}
        for index = 1, #self.timers do
            local timer = self.timers[index]
            timer.remaining = timer.remaining - (dt or 0)
            if timer.remaining <= 0 then
                due[#due + 1] = timer
            else
                keep[#keep + 1] = timer
            end
        end
        self.timers = keep
        for index = 1, #due do
            due[index].callback()
        end
    end
    return setmetatable(manager, {
        __index = function(t, key)
            local fn = function() return nil end
            rawset(t, key, fn)
            return fn
        end,
    })
end

-- Minimal scroll-bar engine component: it only reports value changes to the
-- list exactly like EE.Interface.Components.ScrollBar (callback(value, flag)).
local function newScrollBar(movie, clip)
    local bar = { mMovie = movie, mClipName = clip, mCurrentScroll = 0, mScrollStep = 0.1, mEnabled = true }
    function bar:HookUpCallbacks() end
    function bar:Initialize() end
    function bar:SetEnabled(flag) self.mEnabled = flag end
    function bar:SetHeight() end
    function bar:Update() end
    function bar:SetValue(value)
        self.mCurrentScroll = math.clamp(value, 0, 1)
        self.mScrollValueChangedCallback(self.mCurrentScroll, false)
    end
    function bar:ScrollByStep(steps)
        self:SetValue(self.mCurrentScroll + (tonumber(steps) or 0) * self.mScrollStep)
    end
    return setmetatable(bar, {
        __index = function(t, key)
            local fn = function() return nil end
            rawset(t, key, fn)
            return fn
        end,
    })
end

local UTIL = setmetatable({
    Ternary = function(condition, whenTrue, whenFalse)
        if condition then return whenTrue end
        return whenFalse
    end,
    Round = function(value) return math.floor(value + 0.5) end,
    PlaySound = function() end,
    CopyTable = function(source)
        local copy = {}
        for key, value in pairs(source) do copy[key] = value end
        return setmetatable(copy, getmetatable(source))
    end,
    FormatNumber = function(value) return tostring(value) end,
    GetColor = function() return 0 end,
    ConvertColorNumberToProceduralRGB = function() return { r = 0.5, g = 0.5, b = 0.5 } end,
}, {
    __index = function(t, key)
        local fn = function() return nil end
        rawset(t, key, fn)
        return fn
    end,
})

local LOTUS_UTILITIES = {
    SLIDER = 1, CHECKBOX = 2, TOGGLE = 3, BUTTON = 4, TITLE = 5, INPUTBOX = 6, SPACER = 7,
    INPUTCOUNT = 8, ICONBUTTON = 9, CHOICE = 10, COLOR = 11, IMAGE = 12, CHECKMARK = 13,
}

-- Game-shared _T: only the engine helpers the stock screen calls.
local SHARED_T = { SetButtons = function() end }

local BASE_ENV = {
    print = function() end,
    math = math, string = string, table = table,
    tonumber = tonumber, tostring = tostring, type = type,
    pairs = pairs, ipairs = ipairs, next = next, select = select, unpack = unpack,
    pcall = pcall, error = error, assert = assert,
    setmetatable = setmetatable, getmetatable = getmetatable, rawget = rawget, rawset = rawset,
    _T = SHARED_T,
    -- Engine constants (colours, sounds, textures, materials): opaque numbers.
    _G = setmetatable({}, { __index = function() return 0x808080 end }),
    Engine = setmetatable({}, { __index = function() return function() return false end end }),
    gFlashMgr = setmetatable({}, { __index = function() return function() return nil end end }),
    IsNull = function(value) return value == nil end,
    RealDeltaTime = function() return 1 / 60 end,
    FlashMethod = flashMethod,
    FlashInterpolate = flashInterpolate,
    Clamp = function(value, low, high) return math.clamp(value, low, high) end,
    ToSearchable = function(text) return string.lower(tostring(text)) end,
    ResetLineCount = function() end,
    StringSplit = function(separator, text)
        local parts = {}
        for part in string.gmatch(text, "[^" .. separator:gsub("%p", "%%%0") .. "]+") do
            parts[#parts + 1] = part
        end
        return parts
    end,
    TitleCase = function(text) return text end,
    module = function() end,
    package = { seeall = true },
    -- DE VM: LENGTH of nil yields 0 (see the gate's render rewrite).
    __de_len = function(value)
        if value == nil then return 0 end
        return #value
    end,
}

local loadedModules = {}

local function instantiate(name, extra)
    local body = MODULE_SOURCES[name]
    if body == nil then
        error("harness: no source for module " .. name, 2)
    end
    local env = setmetatable(extra or {}, { __index = BASE_ENV })
    setfenv(body, env)
    local result = body(name)
    return env, result
end

BASE_ENV.require = function(name)
    local cached = loadedModules[name]
    if cached ~= nil then return cached end
    local value
    if name == "Lotus.Interface.LotusUtilities" then
        value = LOTUS_UTILITIES
    elseif name == "EE.Interface.Utilities" then
        value = UTIL
    elseif name == "Lotus.Interface.Libs.TimerMgr" then
        value = { CreateTimerMgr = newTimerMgr }
    elseif name == "Lotus.Interface.UIStyleUtilities" then
        value = permissiveTable(name)
        rawset(value, "GetColor", function() return 0xFFFFFF end)
    elseif name == "EE.Interface.Components.ScrollBar" then
        value = { CreateScrollBar = newScrollBar }
    elseif name == "Lotus.Interface.Components.ThemedCheckbox"
        or name == "Lotus.Interface.Components.ThemedToggle"
        or name == "Lotus.Interface.Components.ThemedInputField"
        or name == "Lotus.Interface.Components.ThemedButton" then
        value = componentModule(name)
    elseif MODULE_SOURCES[name] ~= nil then
        value = (instantiate(name))
    else
        value = permissiveTable(name)
    end
    loadedModules[name] = value
    return value
end

-- A pushed GenericSettings child: a fresh stock ThemedGenericSettings script
-- bound to a fresh movie, initialised like the engine does.
HARNESS.instances = {}
function HARNESS.pushGenericSettings(parentMovie, resource)
    local movie = Movie.new("ThemedGenericSettings")
    local env = instantiate("Lotus.Interface.ThemedGenericSettings", { mMovie = movie })
    local instance = { env = env, movie = movie, parent = parentMovie }
    rawset(movie, "_instance", instance)
    HARNESS.instances[#HARNESS.instances + 1] = instance
    env.Initialize()
    return movie
end
