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
-- Automatic scripted-damage observer. The native host invokes this only for
-- the exact synchronous DamageDD receiver/packet boundary. It never mutates
-- the packet, target, results, or any gameplay-owned value.
-- Universal caster observations, V86. The host invokes these at existing
-- SetSource, DamageDD, RadialDamage and upgrade-calculation boundaries.
-- Snapshot IDs come from a process-monotonic host counter, never a Lua root
-- address or an ability-specific global. Associations are weak and wrapper-
-- exact: an unrecognized wrapper is explicitly unavailable.
local casterSources = setmetatable({}, { __mode = "k" })
local casterPending = {}
-- Bounded transition fingerprints. These retain no engine userdata and have a
-- fixed number of keys. Repeated HUD polls still execute stock getters, but an
-- unchanged observation does not rebuild/transport another JSON event.
local lastBuffFingerprints = {}
local lastBuffOwnerFingerprint = nil

local function casterJson(value)
    if value == nil then return "null" end
    if type(value) == "number" then
        if value ~= value or value - value ~= 0 then return "null" end
        return tostring(value)
    end
    if type(value) == "boolean" then return value and "true" or "false" end
    local text = tostring(value)
    text = string.gsub(text, "\\", "\\\\")
    text = string.gsub(text, '"', '\\"')
    text = string.gsub(text, "\n", "\\n")
    text = string.gsub(text, "\r", "\\r")
    text = string.gsub(text, "\t", "\\t")
    return '"' .. text .. '"'
end

local function casterNumber(callback)
    local ok, value = pcall(callback)
    if ok and type(value) == "number" and value == value and value - value == 0 then
        return value
    end
    return nil
end

local function casterValue(value)
    if type(value) == "number" then return casterNumber(function() return value end) end
    return casterNumber(function() return value:GetModifiedValue() end)
end

local function casterObject(callback)
    local ok, value = pcall(callback)
    if not ok or value == nil then return nil end
    if type(IsNull) == "function" then
        local nullOk, isNull = pcall(IsNull, value)
        if not nullOk or isNull then return nil end
    end
    return value
end

-- Observe any script-owned numeric/boolean state, without naming an ability or
-- treating a blackboard as a complete list of engine upgrades. Traversal and
-- output are bounded across the entire tree; no userdata is dereferenced here.
local function casterBlackboard(caster)
    local ok, board = pcall(function() return caster:GetScriptBlackboard() end)
    if not ok or type(board) ~= "table" then
        return '{"available":false,"reason":"getter-unavailable-or-not-table"}'
    end
    local remaining, truncated, omitted = 32, false, 0
    local seen = {}
    local function tree(value, depth)
        seen[value] = true
        local fields = {}
        for key, child in pairs(value) do
            if remaining == 0 then truncated = true; break end
            remaining = remaining - 1
            local encoded = nil
            if type(key) == "string" and #key <= 96 and not string.find(key, "%c") then
                if type(child) == "number" then
                    local number = casterNumber(function() return child end)
                    if number ~= nil then encoded = casterJson(number) end
                elseif type(child) == "boolean" then encoded = casterJson(child)
                elseif type(child) == "table" and depth < 2 and not seen[child] then
                    encoded = tree(child, depth + 1)
                end
            end
            if encoded ~= nil then fields[#fields + 1] = casterJson(key) .. ':' .. encoded
            else omitted = omitted + 1 end
        end
        return '{' .. table.concat(fields, ",") .. '}'
    end
    local data = tree(board, 0)
    return '{"available":true,"origin":"Avatar.GetScriptBlackboard"'
        .. ',"Scope":"script-state-numeric-and-boolean-fields-only","Data":' .. data
        .. ',"Truncated":' .. casterJson(truncated) .. ',"Omitted":' .. casterJson(omitted) .. '}'
end

-- Universal native HUD notifications. The stock Avatar list is used by HUD
-- rebuilds; HudStatus returns queued additions/removals. Keep both observations
-- separate. Never clear a queue, retain native notifications or maintain buffs.
local function buffRead(callback)
    local ok, value = pcall(callback)
    if ok then return value end
    return nil
end

local function buffText(value, maximum)
    if value == nil then return nil end
    local ok, text = pcall(tostring, value)
    if not ok or #text > maximum or string.find(text, "%c") then return nil end
    return text
end

local function buffBoolean(value)
    if type(value) == "boolean" then return value end
    return nil
end

local function buffRecord(notification, ordinal)
    local kind = buffRead(function() return notification.abilityType end)
    local resource = casterObject(function() return WeakResource(kind) end)
    local fullName = buffText(buffRead(function() return resource:GetFullName() end), 192)
    local nameTag = buffText(buffRead(function() return resource:GetLocalizeTag() end), 192)
    local rawType = casterNumber(function() return notification.buffType end)
    local data = casterNumber(function() return notification.buffData end)
    local extra = casterNumber(function() return notification.buffDataExtra end)
    local timer = buffBoolean(buffRead(function() return Lotus_Game.IsTimerBuff(rawType) end))
    local fields = {}
    local function field(key, value)
        fields[#fields + 1] = casterJson(key) .. ':' .. casterJson(value)
    end
    field("Ordinal", ordinal)
    field("AbilityType", fullName)
    field("AbilityTypeIdentity", fullName == nil and buffText(kind, 96) or nil)
    field("NameTag", nameTag)
    field("NameAvailable", nameTag ~= nil)
    field("Instigator", buffText(buffRead(function() return notification.instigator end), 96))
    field("AugmentType", casterNumber(function() return notification.augmentType end))
    field("BuffType", rawType)
    field("BuffData", data)
    field("BuffDataExtra", extra)
    field("AddBuff", buffBoolean(buffRead(function() return notification.addBuff end)))
    field("IsDebuff", buffBoolean(buffRead(function() return notification.isDebuff end)))
    field("EffectIsPaused", buffBoolean(buffRead(function() return notification.effectIsPaused end)))
    field("TintIcon", buffBoolean(buffRead(function() return notification.tintIcon end)))
    field("IsTimerBuff", timer)
    -- Stock HudRedux's generic display branches. These describe HUD units,
    -- not which stat an effect modifies or the number of upgrade instances.
    field("HudPercent", ((rawType == 2 or rawType == 4) and data)
        or ((rawType == 3 or rawType == 8 or rawType == 9 or rawType == 11) and extra) or nil)
    field("HudNumericValue", ((rawType == 5 or rawType == 8 or rawType == 9 or rawType == 11) and data)
        or (rawType == 7 and extra) or (rawType == 15 and extra) or nil)
    field("HudMultiplier", ((rawType == 6 or rawType == 12) and data)
        or ((rawType == 13 or rawType == 14) and extra)
        or (rawType == 16 and extra ~= nil and extra / 100) or nil)
    field("TimerSeconds", timer == true and data ~= nil and data >= 0 and data or nil)
    field("TimerInfinite", timer == true and data ~= nil and data < 0)
    field("StackCount", nil)
    field("StackCountReason", "HUD-count-is-not-proven-upgrade-stack-count")
    local affected = buffRead(function() return notification.affected end)
    local avatars = {}
    if type(affected) == "table" then
        for i = 1, #affected do
            if i > 4 then break end
            avatars[#avatars + 1] = casterJson(buffText(affected[i], 96))
        end
    end
    fields[#fields + 1] = '"Affected":[' .. table.concat(avatars, ",") .. ']'
    field("AffectedAvailable", type(affected) == "table")
    field("AffectedTruncated", type(affected) == "table" and #affected > 4)
    return '{' .. table.concat(fields, ",") .. '}'
end

local function buffError(value)
    if value == nil then return nil end
    local ok, text = pcall(tostring, value)
    if not ok then return "error-text-unavailable" end
    text = string.gsub(text, "%c", " ")
    if #text > 256 then text = string.sub(text, 1, 256) end
    return text
end

local function buffList(trace, id, receiver, notifications, origin, skipEmpty, getterSucceeded, getterError)
    if trace == nil then return 0 end
    if getterSucceeded == nil then getterSucceeded = true end
    local returnType = type(notifications)
    -- Current executable's two SWIG getters push nil for zero native records,
    -- and create an array table for populated records. Nil is not a read error.
    local available = getterSucceeded and (returnType == "table" or returnType == "nil")
    local nativeCount = nil
    if available then nativeCount = notifications == nil and 0 or #notifications end
    local reason = nil
    if not getterSucceeded then reason = "getter-failed"
    elseif not available then reason = "unsupported-return-type" end
    if skipEmpty and nativeCount == 0 then return 0 end
    local captured = nativeCount ~= nil and nativeCount or 0
    if captured > 32 then captured = 32 end
    local records = {}
    for i = 1, captured do
        records[i] = buffRecord(notifications[i], i)
    end
    local receiverType = buffText(buffRead(function() return receiver:GetType() end), 192)
    local getterErrorText = buffError(getterError)
    local fingerprint = table.concat({
        tostring(origin), tostring(available), tostring(reason),
        tostring(getterSucceeded), tostring(returnType), tostring(getterErrorText),
        tostring(nativeCount), tostring(captured), tostring(receiverType),
        table.concat(records, "\30"),
    }, "\31")
    if lastBuffFingerprints[origin] == fingerprint then return 0 end
    lastBuffFingerprints[origin] = fingerprint
    local chunks = 1
    if captured > 0 then chunks = 0; for i = 1, captured, 2 do chunks = chunks + 1 end end
    local emitted = 0
    for chunk = 1, chunks do
        local chunkRecords = {}
        for i = (chunk - 1) * 2 + 1, chunk * 2 do
            if i > captured then break end
            chunkRecords[#chunkRecords + 1] = records[i]
        end
        local json = '{"Schema":1,"Snapshot":' .. casterJson(id)
            .. ',"Method":"GetBuffNotifications","ObservedAt":' .. casterJson(origin)
            .. ',"Receiver":' .. casterJson(buffText(receiver, 96))
            .. ',"ReceiverType":' .. casterJson(receiverType)
            .. ',"Available":' .. casterJson(available)
            .. ',"Reason":' .. casterJson(reason)
            .. ',"GetterSucceeded":' .. casterJson(getterSucceeded)
            .. ',"ReturnType":' .. casterJson(returnType)
            .. ',"GetterError":' .. casterJson(getterErrorText)
            .. ',"EmptyNativeList":' .. casterJson(available and nativeCount == 0)
            .. ',"NativeCount":' .. casterJson(nativeCount)
            .. ',"CapturedCount":' .. casterJson(captured)
            .. ',"Truncated":' .. casterJson(nativeCount ~= nil and nativeCount > captured)
            .. ',"Chunk":' .. casterJson(chunk) .. ',"Chunks":' .. casterJson(chunks)
            .. ',"CompleteContributorList":false,"Records":[' .. table.concat(chunkRecords, ",") .. ']}'
        -- Two entries per record and bounded identities stay below the host's
        -- 8192-byte structured transport. No notification userdata is retained.
        pcall(trace, "BUFF_LIST", id, json)
        emitted = emitted + 1
    end
    return emitted
end


local function casterSnapshot(trace, id, method, caster, assignment, captureBuffs)
    local parts = {}
    local function stat(name, callback, origin)
        local value = casterNumber(callback)
        parts[#parts + 1] = casterJson(name) .. ':{"value":' .. casterJson(value)
            .. ',"available":' .. casterJson(value ~= nil)
            .. ',"origin":' .. casterJson(origin)
            .. ',"reason":' .. casterJson(value == nil and "getter-unavailable-or-failed" or nil) .. '}'
        return value
    end
    local inventory = casterObject(function() return caster:InventoryControl() end)
    local suit = casterObject(function() return inventory:GetActivePowerSuit() end)
    local suitType = casterObject(function() return suit:GetType() end)
    local control = casterObject(function() return caster:DamageControl() end)
    stat("health", function() return caster:GetHealth() end, "Avatar.GetHealth")
    stat("maxHealth", function() return caster:GetMaxHealth() end, "Avatar.GetMaxHealth")
    stat("shield", function() return control:GetShield() end, "DamageControl.GetShield")
    stat("maxShield", function() return control:GetMaxShield() end, "DamageControl.GetMaxShield")
    stat("overguard", function() return control:GetOverguardAmount() end, "DamageControl.GetOverguardAmount")
    stat("armor", function() return control:GetArmourRating() end, "DamageControl.GetArmourRating")
    stat("energy", function() return suit:GetCurEnergy() end, "PowerSuit.GetCurEnergy")
    stat("maxEnergy", function() return suit:GetMaxEnergy() end, "PowerSuit.GetMaxEnergy")
    -- Same operation/context as stock Frost and Mallet. Only the freshly
    -- constructed diagnostic unit is modified; no gameplay value is written.
    stat("strength", function()
        local unit = Engine.UpgradedValue(1)
        inventory:ModifyValue(unit, 10, suitType, suit)
        return unit:GetModifiedValue()
    end, "InventoryControl.ModifyValue(unit=1,operation=10,suitType,suit)")
    stat("range", function() return inventory:GetUpgradeModifiedValue(1, 9, suitType, suit) end,
        "InventoryControl.GetUpgradeModifiedValue(unit=1,operation=9,suitType,suit)")
    stat("duration", function() return inventory:GetUpgradeModifiedValue(1, 3, suitType, suit) end,
        "InventoryControl.GetUpgradeModifiedValue(unit=1,operation=3,suitType,suit)")
    -- Stock AlchemistDistill prototype 12 NAMECALL 45 uses this exact unit,
    -- operation and active-suit context; both shipped enum indices name ID 4.
    -- A named enum export was unavailable in the V83 live VM. This records the
    -- raw upgrade factor, not a claim about the cost of every channelled ability.
    local efficiency = stat("efficiencyUpgradeFactor", function()
        return inventory:GetUpgradeModifiedValue(1, 4, suitType, suit)
    end, "InventoryControl.GetUpgradeModifiedValue(unit=1,operation=4,suitType,suit)")
    stat("efficiencyPercent", function()
        if efficiency ~= nil then return efficiency * 100 end
        return nil
    end, "100 * observed efficiencyUpgradeFactor; unclamped upgrade percentage")
    local velocity = casterObject(function() return caster:GetVelocity() end)
    stat("velocityX", function() return velocity.x end, "Avatar.GetVelocity.x")
    stat("velocityY", function() return velocity.y end, "Avatar.GetVelocity.y")
    stat("velocityZ", function() return velocity.z end, "Avatar.GetVelocity.z")
    local status = nil
    if control ~= nil then
        local ok, result = pcall(battleLogStatusProfile, control)
        if ok then status = result end
    end
    local json = '{"Schema":1,"Snapshot":' .. casterJson(id)
        .. ',"Method":' .. casterJson(method) .. ',"Caster":' .. casterJson(caster)
        .. ',"CasterKnown":' .. casterJson(caster ~= nil)
        .. ',"SuitType":' .. casterJson(suitType)
        .. ',"SourceAssignmentSnapshot":' .. casterJson(assignment)
        .. ',"Stage":"dispatch-or-calculation","IsCastSnapshot":false'
        .. ',"Base":{"available":false,"reason":"rank-aware-unmodified-baseline-not-verified"}'
        .. ',"Loadout":{"available":false,"reason":"permanent-versus-temporary-upgrade-separation-not-verified"}'
        .. ',"ContributorBreakdown":{"available":false,"reason":"individual-mod-shard-and-buff-attribution-not-verified"}'
        .. ',"ScriptBlackboard":' .. casterBlackboard(caster)
        .. ',"Live":{' .. table.concat(parts, ",") .. '},"StatusProfile":' .. casterJson(status) .. '}'
    pcall(trace, "CASTER_STATS", id, json)
    if captureBuffs then
        local ok, notifications = pcall(function() return caster:GetBuffNotifications() end)
        local errorValue = nil
        if not ok then errorValue = notifications; notifications = nil end
        buffList(trace, id, caster, notifications, "caster-combat-boundary", false, ok, errorValue)
        -- HudRedux gets its HUD owner from mMovie:GetInstigator(), not this
        -- InventoryControl. Observe that exact stock getter/return below rather
        -- than guessing another combat receiver or maintaining a queue cache.
    end
end

local function casterBefore(trace, id, method, arguments, captureBuffs)
    if trace == nil or type(arguments) ~= "table" then return 0 end
    if method == "GetBuffNotifications" or method == "GetHudStatus" then
        -- Root receiver and bridge in the existing managed module before stock
        -- can replace the argument frame. No new registry or buff ledger.
        casterPending[id] = { trace = trace, method = method, receiver = arguments[1] }
        return id
    end
    local packet = arguments[1]
    local caster = nil
    local assignment = nil
    if method == "SetSource" then
        caster = arguments[2]
    elseif method == "DamageDD" or method == "RadialDamage" then
        packet = arguments[2]
        local source = packet ~= nil and casterSources[packet] or nil
        if source ~= nil then caster, assignment = source.caster, source.assignment end
    elseif method == "ModifyValue" or method == "GetUpgradeModifiedValue" then
        -- The four-argument stock form has a suit object in argument 5.
        -- Other overloads are observed without assuming their receiver context.
        if #arguments == 5 then
            caster = casterObject(function() return arguments[5]:GetAvatarOwner() end)
        end
    else return 0 end
    caster = casterObject(function() return caster end)
    -- Scalar getter overloads have no caster. Retain their stock calculation,
    -- without manufacturing an all-unavailable stat/buff snapshot.
    if caster ~= nil then
        casterSnapshot(trace, id, method, caster, assignment, captureBuffs)
    end
    casterPending[id] = {
        trace = trace, method = method, packet = packet, caster = caster,
        beforeValue = casterValue(arguments[2]), operation = arguments[3],
        valueObject = arguments[2],
    }
    return id
end

local function casterAfter(id, results)
    local pending = casterPending[id]
    if pending == nil then return end
    if pending.method == "GetBuffNotifications" then
        local returned = nil
        if type(results) == "table" then returned = results[1] end
        buffList(pending.trace, id, pending.receiver, returned,
            "stock-native-getter-return", true)
        casterPending[id] = nil
        return
    end
    if pending.method == "GetHudStatus" then
        casterPending[id] = nil
        local hud = nil
        if type(results) == "table" then hud = results[1] end
        local owner = buffText(hud,96)
        local ownerReturnType = type(hud)
        local ownerFingerprint = table.concat({
            tostring(hud ~= nil), tostring(owner), tostring(ownerReturnType),
            tostring(hud ~= nil),
        }, "\31")
        local ownerChanged = lastBuffOwnerFingerprint ~= ownerFingerprint
        lastBuffOwnerFingerprint = ownerFingerprint
        local ownerJson = '{"Schema":1,"Snapshot":' .. casterJson(id)
            .. ',"Method":"GetHudStatus","Receiver":' .. casterJson(buffText(pending.receiver,96))
            .. ',"ObservedAt":"stock-hud-owner-getter-return","OwnerAvailable":' .. casterJson(hud ~= nil)
            .. ',"Owner":' .. casterJson(owner)
            .. ',"OwnerReturnType":' .. casterJson(ownerReturnType)
            .. ',"QueueGetterAttempted":' .. casterJson(hud ~= nil) .. '}'
        if ownerChanged then pcall(pending.trace,"BUFF_OWNER",id,ownerJson) end
        -- This is the actual stock return in the HUD owner context. Do not
        -- clear its queue, load resources or infer a permanent contributor list.
        if hud ~= nil then
            local ok, queue = pcall(function() return hud:GetBuffNotifications() end)
            local err = nil
            if not ok then err = queue; queue = nil end
            buffList(pending.trace, id, hud, queue,
                "stock-hud-owner-getter-return", false, ok, err)
        end
        return
    end
    casterPending[id] = nil
    if pending.method == "SetSource" then
        if pending.packet ~= nil then
            casterSources[pending.packet] = pending.caster ~= nil
                and { caster = pending.caster, assignment = id } or nil
        end
    elseif pending.method == "ModifyValue" or pending.method == "GetUpgradeModifiedValue" then
        local after = pending.method == "ModifyValue" and casterValue(pending.valueObject)
            or (type(results) == "table" and casterValue(results[1]) or nil)
        local json = '{"Schema":1,"Snapshot":' .. casterJson(id)
            .. ',"Method":' .. casterJson(pending.method)
            .. ',"Operation":' .. casterJson(pending.operation)
            .. ',"Before":' .. casterJson(pending.beforeValue)
            .. ',"After":' .. casterJson(after)
            .. ',"CalculationKnown":' .. casterJson(pending.beforeValue ~= nil and after ~= nil)
            .. ',"Stage":"stock-calculation","IsCastSnapshot":false}'
        pcall(pending.trace, "CASTER_CALCULATION", id, json)
    end
end

local automaticDamagePending = {}
local automaticDamagePendingDepth = 0

local function automaticDamageObject(value)
    if value == nil then return false end
    if type(IsNull) ~= "function" then return true end
    local ok, isNull = pcall(IsNull, value)
    return ok and isNull == false
end

local function automaticDamageUpgradedValueNumber(value)
    local result = value
    if type(value) ~= "number" then
        if not automaticDamageObject(value) then return nil end
        local ok, modified = pcall(function()
            return value:GetModifiedValue()
        end)
        if not ok or type(modified) ~= "number" then return nil end
        result = modified
    end
    -- DE does not guarantee math.huge in a module's restricted environment.
    -- Finite numbers subtract from themselves to zero; infinities do not.
    if result ~= result or result - result ~= 0 then return nil end
    return result
end

local function automaticDamageTrace(trace, ...)
    if trace ~= nil then pcall(trace, ...) end
end

local function automaticDamageBefore(
    hostTrace, prototype, instruction, arguments, damageTypeFilter)
    if hostTrace == nil or type(arguments) ~= "table" then return 0 end
    local target = arguments[1]
    local damageData = arguments[2]
    if not automaticDamageObject(target) or not automaticDamageObject(damageData) then
        automaticDamageTrace(hostTrace, "AUTO_DAMAGE_SKIP", "reason", "missing-target-or-packet")
        return 0
    end

    if type(damageTypeFilter) == "number" then
        local fraction, fractionOk = battleLogProtectedNumber(function()
            return damageData:GetDamagePct(damageTypeFilter)
        end)
        if not fractionOk then
            automaticDamageTrace(hostTrace, "AUTO_DAMAGE_SKIP", "reason", "damage-type-unreadable",
                "damageType", damageTypeFilter)
            return 0
        end
        if fraction == 0 then return 0 end
    end

    local controlOk, damageControl = pcall(function()
        return target:DamageControl()
    end)
    if not controlOk or not automaticDamageObject(damageControl) then
        automaticDamageTrace(hostTrace, "AUTO_DAMAGE_SKIP", "reason", "damage-control-unavailable",
            "target", target, "damageData", damageData)
        return 0
    end

    local rawOk, rawValue = pcall(function()
        return damageData:GetBaseAmount()
    end)
    local observedRaw = rawOk and automaticDamageUpgradedValueNumber(rawValue) or nil
    local targetType = nil
    local targetTypeOk, targetTypeResult = pcall(function()
        return target:GetType()
    end)
    if targetTypeOk then targetType = targetTypeResult end

    automaticDamagePendingDepth = automaticDamagePendingDepth + 1
    local beginOk, transaction = pcall(battleLogBegin, hostTrace, {
        label = "AUTO_SCRIPTED_DAMAGE_DD",
        prototype = prototype,
        instruction = instruction,
        target = target,
        damageData = damageData,
        damageControl = damageControl,
        source = nil,
        sourceKnown = false,
        sourceAbility = nil,
        sourceAbilityKnown = false,
        stockRaw = observedRaw,
        multiplier = 1,
        requestedRaw = observedRaw,
        observedRaw = observedRaw,
        batchId = 0,
        targetOrdinal = 0,
        pendingDepth = automaticDamagePendingDepth,
        calculation = "observed-DamageData-before-DamageDD",
        modifierName = "none",
        modifierValue = 1,
    })
    if not beginOk or transaction == nil then
        automaticDamagePendingDepth = automaticDamagePendingDepth - 1
        automaticDamageTrace(hostTrace, "AUTO_DAMAGE_SKIP", "reason", "battle-begin-failed")
        return 0
    end

    automaticDamagePending[transaction.id] = {
        transaction = transaction,
        observedRaw = observedRaw,
    }
    automaticDamageTrace(hostTrace, "AUTO_DAMAGE_IDENTITY", transaction.id,
        "target", target, "targetType", targetType,
        "damageData", damageData, "sourceIdentity", "caller-module")
    return transaction.id
end

local function automaticDamageAfter(transactionId, results)
    if type(transactionId) ~= "number" or transactionId <= 0 then return end
    local pending = automaticDamagePending[transactionId]
    if pending == nil then return end
    automaticDamagePending[transactionId] = nil
    if automaticDamagePendingDepth > 0 then
        automaticDamagePendingDepth = automaticDamagePendingDepth - 1
    end
    pcall(battleLogFinish, pending.transaction, {
        results = results,
        installedRaw = pending.observedRaw,
        restoredRaw = pending.observedRaw,
        reportedRaw = nil,
    })
end

local function automaticDamageReset()
    casterSources = setmetatable({}, { __mode = "k" })
    casterPending = {}
    automaticDamagePending = {}
    automaticDamagePendingDepth = 0
    lastBuffFingerprints = {}
    lastBuffOwnerFingerprint = nil
    battleLogReset()
end

-- The embedded table uses the existing managed-chunk registry lifecycle.
-- Initialization and cleanup only release diagnostic transaction state.
return {
    activate = automaticDamageReset,
    cleanup = automaticDamageReset,
    before = automaticDamageBefore,
    after = automaticDamageAfter,
    reset = automaticDamageReset,
    casterBefore = casterBefore,
    casterAfter = casterAfter,
}
