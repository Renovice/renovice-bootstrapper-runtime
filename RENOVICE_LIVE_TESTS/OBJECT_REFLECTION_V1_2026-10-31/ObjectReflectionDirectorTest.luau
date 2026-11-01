-- RENOVICE_NAME_HASH_SEED: 768e5ed0
-- RENOVICE live test: OBJECT_REFLECTION_V1 (RENOVICE.object), 2026-10-31.
-- Ordinary Inject script. NOT deployed; install only for the live test (README.md).
--
-- Runs once when the generation commits (startup or F9). Inside a mission it
-- finds the stock AI director through the same calls stock Lua makes
-- (gRegion:GetNpcMgr():GetAiDirector()), then:
--   1. fields(): count + first fields with type;
--   2. get(): HardMaxAICap (metadata spelling) and mSpawnTimer (engine spelling);
--   3. dump(): text length + first line;
--   4. set(HardMaxAICap, value - 1) and read back, then set it back to the
--      original value and read back (no lasting change);
--   5. negative controls: unknown field, wrong value type, non-object argument.
-- Every line is printed with the prefix "RENOVICE_OBJECT_TEST".

local function out(text)
    print("RENOVICE_OBJECT_TEST " .. text)
end

local function show(value)
    if type(value) == "table" then
        return "{" .. table.concat(value, ",") .. "}"
    end
    return tostring(value)
end

local api = _T.RENOVICE
if type(api) ~= "table" or type(api.object) ~= "table" then
    out("api=missing")
    return
end
local object = api.object
out("api=present version=" .. tostring(api.version))

local function findDirector()
    local region = gRegion
    if not region then return nil end
    local npcMgr = region:GetNpcMgr()
    if not npcMgr then return nil end
    return npcMgr:GetAiDirector()
end

local found, director = pcall(findDirector)
if not found or not director then
    out("director=" .. (found and "nil (enter a mission, then press F9)" or "error"))
    return
end

local fields, fieldsError = object.fields(director)
if not fields then
    out("fields FAIL " .. tostring(fieldsError))
else
    out("fields count=" .. #fields)
    for index = 1, math.min(#fields, 8) do
        local field = fields[index]
        out("field " .. field.name .. " type=" .. field.type .. " writable=" .. tostring(field.writable))
    end
end

local cap, capError = object.get(director, "HardMaxAICap")
out("get HardMaxAICap=" .. show(cap) .. " err=" .. show(capError))
local timer, timerError = object.get(director, "mSpawnTimer")
out("get mSpawnTimer=" .. show(timer) .. " err=" .. show(timerError))

local text, dumpError = object.dump(director)
if text then
    out("dump bytes=" .. #text .. " first=" .. (string.match(text, "^[^\n]*") or ""))
else
    out("dump FAIL " .. tostring(dumpError))
end

if type(cap) == "number" then
    local changed, setError = object.set(director, "HardMaxAICap", cap - 1)
    local after = object.get(director, "HardMaxAICap")
    out("set HardMaxAICap=" .. (cap - 1) .. " changed=" .. show(changed) .. " err=" .. show(setError) .. " readback=" .. show(after))
    local restored, restoreError = object.set(director, "HardMaxAICap", cap)
    local final = object.get(director, "HardMaxAICap")
    out("restore HardMaxAICap=" .. cap .. " changed=" .. show(restored) .. " err=" .. show(restoreError) .. " readback=" .. show(final))
end

local _, unknownError = object.get(director, "NoSuchFieldRenovice")
out("negative unknown-field err=" .. show(unknownError))
local _, typeError = object.set(director, "HardMaxAICap", true)
out("negative wrong-type err=" .. show(typeError))
local _, objectError = object.dump({})
out("negative not-object err=" .. show(objectError))
out("done")
