-- RENOVICE_NAME_HASH_SEED: 768e5ed0
-- Internal RENOVICE population probe (V1), 2026-10-30.
--
-- Optional diagnostics infrastructure. The host admits this chunk only when
-- Logs.cfg has Diagnostics=true and DiagnosticsPopulation=true; it is loaded
-- after the managed-addon transaction commits and its absence or failure
-- disables only the population channel.
--
-- samplePopulation() reads the stock AI director through the same calls stock
-- Lua makes (ImGuiLib ShowEnemyInformation, 44.0.2). The live-enemy count has
-- no recovered name: it is called by its exact U44 method hash fec81f3e (the
-- seed directive above makes the U44 compiler pass Name__<hex> through
-- verbatim). Each getter is isolated in pcall so one failure reports
-- "<field>=err" without aborting the sample. It writes nothing and keeps no
-- state; the host formats, deduplicates and bounds the output.

local function read(director, getter)
    local ok, value = pcall(getter, director)
    if ok then
        return tostring(value)
    end
    return "err"
end

local function alive(d) return d:Name__fec81f3e() end
local function aliveCapped(d) return d:Name__fec81f3e(true) end
local function hardCap(d) return d:GetNpcHardCap() end
local function roomTillHardCap(d) return d:GetRoomTillHardCap() end
local function populationRemaining(d) return d:GetPopulationRemaining() end
local function currentTier(d) return d:GetCurrentTier() end
local function minLevel(d) return d:GetMinEnemyLevel() end
local function maxLevel(d) return d:GetMaxEnemyLevel() end

local function findDirector()
    local region = gRegion
    if not region then return nil end
    local npcMgr = region:GetNpcMgr()
    if not npcMgr then return nil end
    return npcMgr:GetAiDirector()
end

local function samplePopulation()
    local found, director = pcall(findDirector)
    if not found then
        return "director=err"
    end
    if not director then
        return "director=nil"
    end
    return "alive=" .. read(director, alive)
        .. " alive_capped=" .. read(director, aliveCapped)
        .. " hardcap=" .. read(director, hardCap)
        .. " room=" .. read(director, roomTillHardCap)
        .. " budget=" .. read(director, populationRemaining)
        .. " tier=" .. read(director, currentTier)
        .. " lvl=" .. read(director, minLevel) .. "-" .. read(director, maxLevel)
end

return {
    activate = function() end,
    cleanup = function() end,
    hooks = {
        samplePopulation = samplePopulation,
    },
}
