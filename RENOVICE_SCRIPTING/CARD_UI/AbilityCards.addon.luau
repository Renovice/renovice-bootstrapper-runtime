-- REJECTED LIVE EXPERIMENT -- DO NOT DEPLOY OR USE AS THE EDITOR ARCHITECTURE.
-- The addon loaded successfully, but its row did not appear in the native
-- bottom ability-stat list. See NATIVE_ABILITY_CARD_ROWS.md. This source is
-- retained only as negative evidence for the cross-VM/global-row hypothesis.
--
-- RENOVICE ability-card registry experiment.
--
-- Edit CARD_ROWS to add fixed or computed rows. Ability replacements that use
-- the shared card hook call RENOVICE_AUGMENT_ABILITY_CARD after generating the
-- stock rows. F9 transactionally replaces this whole addon generation.

local shared = _T
if shared == nil then
    error("RENOVICE_ABILITY_CARDS_SHARED_T_MISSING")
end

local CARD_ROWS = {
    BARD_MUSIC = {
        {
            Id = "mallet_damage_to_overguard",
            Label = "/Renovice/AbilityStats/DamageToOverguard",
            Value = 10,
            ValueUnit = "/Lotus/Language/Game/UNIT_PERCENT",
        },
    },
}

local previousAugment = nil
local previousRows = nil
local active = false

local function copyDisplayRow(definition, query)
    local value = definition.Value
    if type(value) == "function" then
        value = value(query)
    end

    local row = {
        Label = definition.Label,
        Value = value,
    }
    if definition.ValueUnit ~= nil then
        row.ValueUnit = definition.ValueUnit
    end
    if definition.ValueIcon ~= nil then
        row.ValueIcon = definition.ValueIcon
    end
    return row
end

local function augmentAbilityCard(abilityId, outputRows, query)
    -- Preserve an older compatible handler when another subsystem installed
    -- one before this generation. Failure is isolated so our own rows survive.
    if type(previousAugment) == "function" then
        pcall(previousAugment, abilityId, outputRows, query)
    end

    if type(outputRows) ~= "table" then
        return
    end

    local definitions = CARD_ROWS[abilityId]
    if type(definitions) ~= "table" then
        return
    end

    -- Numeric traversal preserves the row order selected by the editor.
    for index = 1, #definitions do
        local definition = definitions[index]
        if type(definition) == "table"
            and type(definition.Label) == "string"
            and definition.Value ~= nil then
            table.insert(outputRows, copyDisplayRow(definition, query))
        end
    end
end

local function activate()
    if active then
        return
    end

    previousAugment = shared.RENOVICE_AUGMENT_ABILITY_CARD
    previousRows = shared.RENOVICE_ABILITY_CARD_ROWS
    shared.RENOVICE_ABILITY_CARD_ROWS = CARD_ROWS
    shared.RENOVICE_AUGMENT_ABILITY_CARD = augmentAbilityCard
    active = true
end

local function cleanup()
    if not active then
        return
    end

    if shared.RENOVICE_AUGMENT_ABILITY_CARD == augmentAbilityCard then
        shared.RENOVICE_AUGMENT_ABILITY_CARD = previousAugment
    end
    if shared.RENOVICE_ABILITY_CARD_ROWS == CARD_ROWS then
        shared.RENOVICE_ABILITY_CARD_ROWS = previousRows
    end
    previousAugment = nil
    previousRows = nil
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
