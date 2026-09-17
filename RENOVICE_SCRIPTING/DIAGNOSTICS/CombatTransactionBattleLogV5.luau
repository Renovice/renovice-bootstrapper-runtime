-- RENOVICE reusable combat transaction battle log, version 5.
--
-- Call battleLogBegin immediately before one authoritative native combat
-- transaction and battleLogFinish immediately afterward. The caller supplies
-- the host trace closure as the first argument. When diagnostics are disabled
-- the closure is nil, begin returns before any engine state or profile read,
-- and gameplay follows the same path without diagnostic work.
--
-- This component records observable inputs and outputs. It does not invent a
-- native damage formula. Damage-type and status identifiers remain numeric;
-- raw packet damage, visible pool loss, and their difference are reported as
-- separate measurements because armor, resistances, attenuation, weak points,
-- invulnerability, critical logic, and other native rules can intervene.

local BATTLE_LOG_FIRST_TYPE = 0
local BATTLE_LOG_LAST_TYPE = 19
local battleLogCorrelation = 0

local function battleLogProtectedNumber(callback)
    local ok, value = pcall(callback)
    if ok and type(value) == "number" then return value, true end
    return nil, false
end

local function battleLogProtectedBoolean(callback)
    local ok, value = pcall(callback)
    if ok and type(value) == "boolean" then return value, true end
    return nil, false
end

local function battleLogProtectedObjectPresence(callback)
    local ok, value = pcall(callback)
    if not ok then return nil, false end
    if value == nil then return false, true end
    local nullOk, isNull = pcall(IsNull, value)
    if not nullOk or type(isNull) ~= "boolean" then return nil, false end
    return not isNull, true
end

local function battleLogTargetState(target, damageControl)
    local health, healthOk = battleLogProtectedNumber(function()
        return target:GetHealth()
    end)
    local maxHealth, maxHealthOk = battleLogProtectedNumber(function()
        return target:GetMaxHealth()
    end)
    local shield, shieldOk = battleLogProtectedNumber(function()
        return damageControl:GetShield()
    end)
    local maxShield, maxShieldOk = battleLogProtectedNumber(function()
        return damageControl:GetMaxShield()
    end)
    local overguard, overguardOk = battleLogProtectedNumber(function()
        return damageControl:GetOverguardAmount()
    end)
    local armour, armourOk = battleLogProtectedNumber(function()
        return damageControl:GetArmourRating()
    end)
    local killed, killedOk = battleLogProtectedBoolean(function()
        return target:IsKilled()
    end)
    local dead, deadOk = battleLogProtectedBoolean(function()
        return target:IsDead()
    end)
    local ragdollPresent, ragdollOk = battleLogProtectedObjectPresence(function()
        return target:GetRagdoll()
    end)

    return {
        health = health,
        healthOk = healthOk,
        maxHealth = maxHealth,
        maxHealthOk = maxHealthOk,
        shield = shield,
        shieldOk = shieldOk,
        maxShield = maxShield,
        maxShieldOk = maxShieldOk,
        overguard = overguard,
        overguardOk = overguardOk,
        armour = armour,
        armourOk = armourOk,
        killed = killed,
        killedOk = killedOk,
        dead = dead,
        deadOk = deadOk,
        ragdollPresent = ragdollPresent,
        ragdollOk = ragdollOk,
    }
end

local function battleLogStatusProfile(damageControl)
    local parts = {}
    local succeeded = 0
    local failed = 0
    for damageType = BATTLE_LOG_FIRST_TYPE, BATTLE_LOG_LAST_TYPE do
        local count, ok = battleLogProtectedNumber(function()
            return damageControl:Name__ff67e37d(damageType)
        end)
        if ok then
            succeeded = succeeded + 1
            if count ~= 0 then
                parts[#parts + 1] = tostring(damageType) .. ":" .. tostring(count)
            end
        else
            failed = failed + 1
        end
    end
    local nonzero = "none"
    if #parts > 0 then nonzero = table.concat(parts, ",") end
    return "range=0-19;ok=" .. tostring(succeeded)
        .. ";failed=" .. tostring(failed)
        .. ";nonzero=index:count=" .. nonzero
end

local function battleLogDamageProfile(damageData, requestedRaw)
    local parts = {}
    local succeeded = 0
    local failed = 0
    for damageType = BATTLE_LOG_FIRST_TYPE, BATTLE_LOG_LAST_TYPE do
        local fraction, ok = battleLogProtectedNumber(function()
            return damageData:GetDamagePct(damageType)
        end)
        if ok then
            succeeded = succeeded + 1
            if fraction ~= 0 then
                local requestedComponent = "unavailable"
                if type(requestedRaw) == "number" then
                    requestedComponent = tostring(requestedRaw * fraction)
                end
                parts[#parts + 1] = tostring(damageType)
                    .. ":" .. tostring(fraction)
                    .. ":" .. requestedComponent
            end
        else
            failed = failed + 1
        end
    end
    local nonzero = "none"
    if #parts > 0 then nonzero = table.concat(parts, ",") end
    return "range=0-19;ok=" .. tostring(succeeded)
        .. ";failed=" .. tostring(failed)
        .. ";nonzero=index:fraction:requested=" .. nonzero
end

local function battleLogPositiveLoss(before, after)
    if type(before) ~= "number" or type(after) ~= "number" then return nil end
    if before <= after then return 0 end
    return before - after
end

local function battleLogEmit(trace, ...)
    pcall(trace, ...)
end

local function battleLogBegin(hostTrace, context)
    -- This nil check is the complete disabled fast path. Do not add state reads
    -- or shared-table discovery before it.
    if hostTrace == nil then return nil end
    if type(context) ~= "table" then return nil end

    battleLogCorrelation = battleLogCorrelation + 1
    local state = battleLogTargetState(context.target, context.damageControl)
    local statusProfile = battleLogStatusProfile(context.damageControl)
    local damageProfile = battleLogDamageProfile(
        context.damageData, context.requestedRaw)
    local transaction = {
        id = battleLogCorrelation,
        trace = hostTrace,
        context = context,
        before = state,
        statusBefore = statusProfile,
    }

    battleLogEmit(hostTrace, "BATTLE_TX_BEGIN", transaction.id,
        context.label, context.prototype, context.instruction,
        context.target, context.damageData,
        "source", context.source, context.sourceKnown == true,
        "sourceAbility", context.sourceAbility,
        context.sourceAbilityKnown == true,
        "batch", context.batchId, context.targetOrdinal,
        context.pendingDepth,
        "calculation", context.calculation,
        "modifier", context.modifierName, context.modifierValue,
        "modifierScale", context.modifierScaleName, context.modifierScaleValue,
        "baseMultiplier", context.baseMultiplier,
        "bonusPerStack", context.bonusPerStack)
    battleLogEmit(hostTrace, "BATTLE_STATE_BEGIN", transaction.id,
        context.label,
        "health", state.health, state.healthOk,
        state.maxHealth, state.maxHealthOk,
        "shield", state.shield, state.shieldOk,
        state.maxShield, state.maxShieldOk,
        "overguard", state.overguard, state.overguardOk,
        "armour", state.armour, state.armourOk)
    battleLogEmit(hostTrace, "BATTLE_LIFE_BEGIN", transaction.id,
        context.label,
        "killed", state.killed, state.killedOk,
        "dead", state.dead, state.deadOk,
        "ragdollPresent", state.ragdollPresent, state.ragdollOk)
    battleLogEmit(hostTrace, "BATTLE_STATUS_BEGIN", transaction.id,
        context.label, statusProfile)
    battleLogEmit(hostTrace, "BATTLE_DAMAGE_INPUT", transaction.id,
        context.label,
        "stockRaw", context.stockRaw,
        "multiplier", context.multiplier,
        "requestedRaw", context.requestedRaw,
        "observedRaw", context.observedRaw,
        damageProfile)
    return transaction
end

local function battleLogFinish(transaction, outcome)
    if transaction == nil then return end
    if type(outcome) ~= "table" then outcome = {} end

    local context = transaction.context
    local after = battleLogTargetState(context.target, context.damageControl)
    local healthLoss = battleLogPositiveLoss(transaction.before.health, after.health)
    local shieldLoss = battleLogPositiveLoss(transaction.before.shield, after.shield)
    local overguardLoss = battleLogPositiveLoss(
        transaction.before.overguard, after.overguard)
    local visiblePoolLoss = 0
    local visiblePoolLossComplete = true
    if type(healthLoss) == "number" then
        visiblePoolLoss = visiblePoolLoss + healthLoss
    else
        visiblePoolLossComplete = false
    end
    if type(shieldLoss) == "number" then
        visiblePoolLoss = visiblePoolLoss + shieldLoss
    else
        visiblePoolLossComplete = false
    end
    if type(overguardLoss) == "number" then
        visiblePoolLoss = visiblePoolLoss + overguardLoss
    else
        visiblePoolLossComplete = false
    end

    local rawMinusVisiblePoolLoss = nil
    local visibleToInstalledRatio = nil
    if visiblePoolLossComplete and type(outcome.installedRaw) == "number" then
        rawMinusVisiblePoolLoss = outcome.installedRaw - visiblePoolLoss
        if outcome.installedRaw > 0 then
            visibleToInstalledRatio = visiblePoolLoss / outcome.installedRaw
        end
    end
    local statusAfter = battleLogStatusProfile(context.damageControl)

    battleLogEmit(transaction.trace, "BATTLE_STATE_END", transaction.id,
        context.label,
        "health", transaction.before.health, after.health, healthLoss,
        "shield", transaction.before.shield, after.shield, shieldLoss,
        "overguard", transaction.before.overguard, after.overguard,
        overguardLoss,
        "armour", transaction.before.armour, after.armour,
        "visiblePoolLoss", visiblePoolLoss, visiblePoolLossComplete)
    battleLogEmit(transaction.trace, "BATTLE_LIFE_END", transaction.id,
        context.label,
        "killed", transaction.before.killed, after.killed, after.killedOk,
        "dead", transaction.before.dead, after.dead, after.deadOk,
        "ragdollPresent", transaction.before.ragdollPresent,
        after.ragdollPresent, after.ragdollOk)
    battleLogEmit(transaction.trace, "BATTLE_STATUS_END", transaction.id,
        context.label, transaction.statusBefore, statusAfter)
    battleLogEmit(transaction.trace, "BATTLE_MATH", transaction.id,
        context.label,
        "stockRaw", context.stockRaw,
        "multiplier", context.multiplier,
        "requestedRaw", context.requestedRaw,
        "installedRaw", outcome.installedRaw,
        "restoredRaw", outcome.restoredRaw,
        "reportedRaw", outcome.reportedRaw,
        "visiblePoolLoss", visiblePoolLoss,
        "visiblePoolLossComplete", visiblePoolLossComplete,
        "rawMinusVisiblePoolLoss", rawMinusVisiblePoolLoss,
        "visibleToInstalledRatio", visibleToInstalledRatio,
        "results", outcome.results)
end

local function battleLogReset()
    battleLogCorrelation = 0
end
