-- RENOVICE reusable combat transaction meter, version 4.
--
-- Embed this source block in a target addon and call combatMeterBegin directly
-- before the native combat call, then combatMeterFinish directly afterward.
-- The runtime passes its centralized trace closure directly through the hook
-- callback ABI. When that closure is absent, begin returns immediately and
-- performs none of the expensive reads. The protected _T lookup remains only
-- as backwards compatibility for runtimes older than V69.
-- Damage and status identifiers remain numeric because their human names are
-- not proven for every current and future game build. Version 4 records the
-- authoritative Lua batch and target-local order separately from the native
-- DamageData identity, so native allocator address reuse cannot imply identity.

local COMBAT_METER_FIRST_TYPE = 0
local COMBAT_METER_LAST_TYPE = 19
local combatMeterCorrelation = 0

local function combatMeterTrace(hostTrace)
    if hostTrace ~= nil then return hostTrace end
    -- Backwards-compatible fallback. DE exposes the shared table and installed
    -- native closure through VM-owned proxy values whose Lua `type` result is
    -- not a reliable capability test, so probe the field under pcall.
    local ok, trace = pcall(function()
        return _T.RENOVICE_TRACE
    end)
    if not ok or trace == nil then return nil end
    return trace
end

local function combatMeterProtectedNumber(callback)
    local ok, value = pcall(callback)
    if ok and type(value) == "number" then
        return value, true
    end
    return nil, false
end

local function combatMeterTargetState(target, damageControl)
    local health, healthOk = combatMeterProtectedNumber(function()
        return target:GetHealth()
    end)
    local maxHealth, maxHealthOk = combatMeterProtectedNumber(function()
        return target:GetMaxHealth()
    end)
    local shield, shieldOk = combatMeterProtectedNumber(function()
        return damageControl:GetShield()
    end)
    local maxShield, maxShieldOk = combatMeterProtectedNumber(function()
        return damageControl:GetMaxShield()
    end)
    local overguard, overguardOk = combatMeterProtectedNumber(function()
        return damageControl:GetOverguardAmount()
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
    }
end

local function combatMeterStatusProfile(damageControl)
    local parts = {}
    local succeeded = 0
    local failed = 0
    for damageType = COMBAT_METER_FIRST_TYPE, COMBAT_METER_LAST_TYPE do
        local count, ok = combatMeterProtectedNumber(function()
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
        .. ";nonzero=" .. nonzero
end

local function combatMeterDamageProfile(damageData, requestedRaw)
    local parts = {}
    local succeeded = 0
    local failed = 0
    for damageType = COMBAT_METER_FIRST_TYPE, COMBAT_METER_LAST_TYPE do
        local fraction, ok = combatMeterProtectedNumber(function()
            return damageData:GetDamagePct(damageType)
        end)
        if ok then
            succeeded = succeeded + 1
            if fraction ~= 0 then
                parts[#parts + 1] = tostring(damageType)
                    .. ":" .. tostring(fraction)
                    .. ":" .. tostring(requestedRaw * fraction)
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

local function combatMeterPositiveLoss(before, after)
    if type(before) ~= "number" or type(after) ~= "number" then return nil end
    if before <= after then return 0 end
    return before - after
end

local function combatMeterBegin(hostTrace, label, prototype, instruction, target,
        damageData, damageControl, stockRaw, multiplier, requestedRaw, batchId,
        targetOrdinal, observedRaw, coldStacks, pendingDepth)
    local trace = combatMeterTrace(hostTrace)
    if trace == nil then return nil end

    combatMeterCorrelation = combatMeterCorrelation + 1
    local state = combatMeterTargetState(target, damageControl)
    local transaction = {
        id = combatMeterCorrelation,
        trace = trace,
        label = label,
        prototype = prototype,
        instruction = instruction,
        target = target,
        damageData = damageData,
        damageControl = damageControl,
        before = state,
        stockRaw = stockRaw,
        multiplier = multiplier,
        requestedRaw = requestedRaw,
        batchId = batchId,
        targetOrdinal = targetOrdinal,
        observedRaw = observedRaw,
        coldStacks = coldStacks,
        pendingDepth = pendingDepth,
    }

    trace("COMBAT_BEGIN_STATE", transaction.id, label, prototype, instruction,
        target, damageData,
        "health", state.health, state.healthOk, state.maxHealth, state.maxHealthOk,
        "shield", state.shield, state.shieldOk, state.maxShield, state.maxShieldOk,
        "overguard", state.overguard, state.overguardOk,
        "damage", stockRaw, multiplier, requestedRaw,
        "batchContext", batchId, targetOrdinal, observedRaw, coldStacks, pendingDepth,
        "traceTransport", type(hostTrace), type(trace))
    trace("COMBAT_BEGIN_PROFILE", transaction.id, label,
        combatMeterDamageProfile(damageData, requestedRaw),
        combatMeterStatusProfile(damageControl))
    return transaction
end

local function combatMeterFinish(transaction, results, installedRaw, restoredRaw)
    if transaction == nil then return end

    local after = combatMeterTargetState(transaction.target, transaction.damageControl)
    local healthLoss = combatMeterPositiveLoss(transaction.before.health, after.health)
    local shieldLoss = combatMeterPositiveLoss(transaction.before.shield, after.shield)
    local overguardLoss = combatMeterPositiveLoss(transaction.before.overguard, after.overguard)
    local effectivePoolLoss = 0
    if type(healthLoss) == "number" then effectivePoolLoss = effectivePoolLoss + healthLoss end
    if type(shieldLoss) == "number" then effectivePoolLoss = effectivePoolLoss + shieldLoss end
    if type(overguardLoss) == "number" then effectivePoolLoss = effectivePoolLoss + overguardLoss end

    transaction.trace("COMBAT_END_STATE", transaction.id, transaction.label,
        transaction.prototype, transaction.instruction,
        transaction.target, transaction.damageData,
        "health", transaction.before.health, after.health, healthLoss,
        "shield", transaction.before.shield, after.shield, shieldLoss,
        "overguard", transaction.before.overguard, after.overguard, overguardLoss,
        "effectivePoolLoss", effectivePoolLoss,
        "installedRaw", installedRaw,
        "restoredRaw", restoredRaw,
        "results", results)
    transaction.trace("COMBAT_END_PROFILE", transaction.id, transaction.label,
        combatMeterStatusProfile(transaction.damageControl))
end

local function combatMeterReset()
    combatMeterCorrelation = 0
end
