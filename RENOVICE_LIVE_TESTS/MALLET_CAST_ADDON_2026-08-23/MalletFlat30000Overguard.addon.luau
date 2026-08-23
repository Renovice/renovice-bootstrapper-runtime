local global, shared = ...
if shared == nil then
    error("RENOVICE_MALLET_ADDON_SHARED_T_MISSING")
end
local previousHandler = nil
local active = false

local function afterMalletCast(caster, _ability, _projectile)
    if IsNull(caster) then
        return
    end

    local damageControl = caster:DamageControl()
    if IsNull(damageControl) then
        return
    end

    local current = damageControl:GetOverguardAmount()
    local target = math.max(current, 30000)
    if current < target then
        damageControl:SetOverguardAmount(target)
        caster:NotifyOverguardGain(caster:GetPlayer(), target - current)
    end
end

local function activate()
    if active then
        return
    end

    previousHandler = shared.RENOVICE_AFTER_MALLET_CAST
    shared.RENOVICE_AFTER_MALLET_CAST = afterMalletCast
    active = true
end

local function cleanup()
    if not active then
        return
    end

    if shared.RENOVICE_AFTER_MALLET_CAST == afterMalletCast then
        shared.RENOVICE_AFTER_MALLET_CAST = previousHandler
    end
    previousHandler = nil
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
