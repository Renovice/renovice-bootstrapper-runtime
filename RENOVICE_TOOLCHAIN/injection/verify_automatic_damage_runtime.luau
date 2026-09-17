local null = {}

function IsNull(value)
    return value == nil or value == null
end

local function upgraded(value)
    return {
        GetModifiedValue = function()
            return value
        end,
    }
end

local state = {
    health = 1000,
    shield = 100,
    overguard = 50,
    statuses = { [4] = 6 },
    fractions = { [4] = 1 },
}

local damageControl = {}
function damageControl:GetShield() return state.shield end
function damageControl:GetMaxShield() return 100 end
function damageControl:GetOverguardAmount() return state.overguard end
function damageControl:GetArmourRating() return 300 end
function damageControl:Name__ff67e37d(index) return state.statuses[index] or 0 end

local target = {}
function target:DamageControl() return damageControl end
function target:GetHealth() return state.health end
function target:GetMaxHealth() return 1000 end
function target:IsKilled() return state.health <= 0 end
function target:IsDead() return state.health <= 0 end
function target:GetRagdoll() return nil end
function target:GetType() return "AvatarType" end

local packet = {}
local packetRaw = 200
local packetNumeric = false
function packet:GetBaseAmount()
    if packetNumeric then return packetRaw end
    return upgraded(packetRaw)
end
function packet:GetDamagePct(index) return state.fractions[index] or 0 end

local events = {}
local function trace(...)
    events[#events + 1] = { ... }
end

local runtime = require("./automatic_damage_runtime")
-- DE's restricted math environment need not export upstream math.huge.
-- All closures from the observer module share this environment.
getfenv(runtime.before).math = {}
assert(type(runtime.activate) == "function")
assert(type(runtime.cleanup) == "function")
assert(type(runtime.reset) == "function")
assert(type(runtime.before) == "function" and type(runtime.after) == "function")
runtime.activate()
local transaction = runtime.before(trace, 7, 64, { target, packet }, nil)
if not (type(transaction) == "number" and transaction > 0) then
    print("automatic before failed", transaction, #events,
        events[#events] and events[#events][1],
        events[#events] and events[#events][3])
end
assert(type(transaction) == "number" and transaction > 0)
assert(state.health == 1000 and state.shield == 100 and state.overguard == 50)

state.overguard = 0
state.shield = 0
state.health = 950
runtime.after(transaction, {})
assert(#events == 10)
assert(events[1][1] == "BATTLE_TX_BEGIN")
assert(events[6][1] == "AUTO_DAMAGE_IDENTITY")
assert(events[10][1] == "BATTLE_MATH")

local count = #events
assert(runtime.before(trace, 7, 64, { target, packet }, 1) == 0)
assert(#events == count)

runtime.reset()
local missing = runtime.before(trace, 7, 64, { null, packet }, nil)
assert(missing == 0 and events[#events][1] == "AUTO_DAMAGE_SKIP")

local pending = runtime.before(trace, 7, 64, { target, packet }, nil)
assert(pending > 0)
runtime.cleanup()
local cleanupCount = #events
runtime.after(pending, {})
assert(#events == cleanupCount)
assert(state.health == 950 and state.shield == 0 and state.overguard == 0)

for _, numeric in ipairs({ false, true }) do
    packetNumeric = numeric
    for _, raw in ipairs({ 1 / 0, -1 / 0, 0 / 0 }) do
        packetRaw = raw
        local firstEvent = #events + 1
        local invalidRaw = runtime.before(trace, 7, 64, { target, packet }, nil)
        assert(invalidRaw > 0)
        assert(events[firstEvent + 4][1] == "BATTLE_DAMAGE_INPUT")
        assert(events[firstEvent + 4][5] == nil)
        runtime.after(invalidRaw, {})
        assert(#events == firstEvent + 9)
        assert(state.health == 950 and state.shield == 0 and state.overguard == 0)
    end
end

packetRaw = 200
local firstFiniteEvent = #events + 1
local finite = runtime.before(trace, 7, 64, { target, packet }, nil)
assert(finite > 0 and events[firstFiniteEvent + 4][5] == 200)
runtime.after(finite, {})

print("AUTOMATIC DAMAGE RUNTIME PASS restricted math, finite raw values, managed lifecycle, observation-only transaction, filter, reset, failure record")

local strength, range, duration, efficiency = 3, 1.45, 0.75, 1.7
local blackboard = { NokkoPowerBuff = { buffAmount = 0.54, duration = 5 } }
local inventory, suit, caster = {}, {}, {}
Engine = { UpgradedValue = function(value)
    return { value = value, GetModifiedValue = function(self) return self.value end }
end }
-- Named enum deliberately absent, matching the live V83 failure.
Lotus_Game = {}
getfenv(runtime.casterBefore).Engine = Engine
getfenv(runtime.casterBefore).Lotus_Game = Lotus_Game
function inventory:GetActivePowerSuit() return suit end
function inventory:ModifyValue(value, operation, kind, context)
    assert(operation == 10 and kind == "FrostType" and context == suit)
    value.value = value.value * strength
end
function inventory:GetUpgradeModifiedValue(value, operation, kind, context)
    assert(kind == "FrostType" and context == suit)
    if operation == 9 then return value * range end
    if operation == 3 then return value * duration end
    assert(operation == 4)
    return value * efficiency
end
function suit:GetType() return "FrostType" end
function suit:GetAvatarOwner() return caster end
function suit:GetCurEnergy() return 155 end
function suit:GetMaxEnergy() return 300 end
function caster:InventoryControl() return inventory end
function caster:DamageControl() return damageControl end
function caster:GetHealth() return 250 end
function caster:GetMaxHealth() return 555 end
function caster:GetVelocity() return { x = 2, y = 3, z = 4 } end
function caster:GetScriptBlackboard() return blackboard end

local casterEvents = {}
local function casterTrace(...) casterEvents[#casterEvents + 1] = { ... } end
local function has(text) return string.find(casterEvents[#casterEvents][3], text, 1, true) ~= nil end
assert(runtime.casterBefore(nil, 1, "SetSource", {packet, caster}) == 0)
assert(#casterEvents == 0)
assert(runtime.casterBefore(casterTrace, 1, "SetSource", {packet, caster}) == 1)
runtime.casterAfter(1, {})
assert(has('"strength":{"value":3,"available":true'))
assert(has('"efficiencyUpgradeFactor":{"value":1.7,"available":true'))
assert(has('"efficiencyPercent":{"value":170,"available":true'))
assert(has('"NokkoPowerBuff":{"buffAmount":0.54,"duration":5}')
    or has('"NokkoPowerBuff":{"duration":5,"buffAmount":0.54}'))
assert(has('"Base":{"available":false'))
assert(has('"Loadout":{"available":false'))
assert(has('"IsCastSnapshot":false'))
strength = 1.5
assert(runtime.casterBefore(casterTrace, 2, "DamageDD", {target, packet}) == 2)
assert(has('"strength":{"value":1.5,"available":true'))
assert(has('"SourceAssignmentSnapshot":1'))
runtime.casterAfter(2, {})
assert(runtime.casterBefore(casterTrace, 3, "RadialDamage", {{}, packet}) == 3)
assert(has('"CasterKnown":true'))
runtime.casterAfter(3, {})
local value = Engine.UpgradedValue(100)
assert(runtime.casterBefore(casterTrace, 4, "ModifyValue", {inventory, value, 10, "FrostType", suit}) == 4)
value.value = 1000
runtime.casterAfter(4, {})
assert(casterEvents[#casterEvents][1] == "CASTER_CALCULATION")
assert(has('"Before":100,"After":1000'))
assert(runtime.casterBefore(casterTrace, 5, "GetUpgradeModifiedValue", {inventory, 25, 9, "FrostType", suit}) == 5)
runtime.casterAfter(5, { 36.25 })
assert(has('"Before":25,"After":36.25'))
runtime.cleanup()
local unknownBefore = #casterEvents
assert(runtime.casterBefore(casterTrace, 6, "DamageDD", {target, packet}) == 6)
assert(#casterEvents == unknownBefore) -- no fabricated all-unavailable caster
runtime.casterAfter(6, {})
strength = 1 / 0
assert(runtime.casterBefore(casterTrace, 7, "SetSource", {packet, caster}) == 7)
assert(has('"strength":{"value":null,"available":false'))
runtime.casterAfter(7, {})
for index, value in ipairs({ 1, 0.45, 1.75, 1.9 }) do
    efficiency = value
    local id = 10 + index
    runtime.casterBefore(casterTrace, id, "SetSource", {packet, caster})
    assert(has('"efficiencyUpgradeFactor":{"value":' .. tostring(value) .. ',"available":true'))
    assert(has('"efficiencyPercent":{"value":' .. tostring(value * 100) .. ',"available":true'))
    runtime.casterAfter(id, {})
end
efficiency = 1 / 0
runtime.casterBefore(casterTrace, 20, "SetSource", {packet, caster})
assert(has('"efficiencyUpgradeFactor":{"value":null,"available":false'))
assert(has('"efficiencyPercent":{"value":null,"available":false'))
runtime.casterAfter(20, {})
-- A cycle, unknown userdata-like object and deep/many fields cannot escape the
-- universal blackboard budget or cause writes to game-owned state.
blackboard = { a = { b = { c = { d = 100 } } }, ignored = "string-value" }
blackboard.cycle = blackboard
runtime.casterBefore(casterTrace, 21, "SetSource", {packet, caster})
assert(has('"Truncated":false,"Omitted":3'))
assert(not has('"d":100'))
assert(blackboard.a.b.c.d == 100 and blackboard.cycle == blackboard)
runtime.casterAfter(21, {})
blackboard = {}
for i = 1, 200 do blackboard["stat" .. tostring(i)] = i end
runtime.casterBefore(casterTrace, 22, "SetSource", {packet, caster})
assert(has('"Truncated":true'))
local _, fieldCount = string.gsub(casterEvents[#casterEvents][3], '"stat%d+":', "")
assert(fieldCount == 32)
runtime.casterAfter(22, {})
blackboard = nil
runtime.casterBefore(casterTrace, 23, "SetSource", {packet, caster})
assert(has('"ScriptBlackboard":{"available":false,"reason":"getter-unavailable-or-not-table"}'))
runtime.casterAfter(23, {})
print("CASTER EFFICIENCY/BLACKBOARD PASS absent enum, verified operation/context, unit percentage, nonfinite unavailable, bounded read-only state, cycles, depth, missing table")
print("CASTER STATS RUNTIME PASS source association, changing live Strength, mixed target shared packet, radial dispatch, immutable stock calculation, explicit tier unknowns, cleanup, off, nonfinite failure")

-- Universal buff capture uses the same observer lifecycle for unrelated native
-- resources. Queue reads and combat snapshots preserve all stock objects/data.
local buffEvents, activeBuffs = {}, {}
local nameResources = {}
local function buffTrace(...) buffEvents[#buffEvents + 1] = { ... } end
local function identity(path, tag)
    local kind = {}
    nameResources[kind] = {
        GetFullName = function() return path end,
        GetLocalizeTag = function() return tag end,
    }
    return kind
end
getfenv(runtime.casterBefore).WeakResource = function(kind) return nameResources[kind] end
getfenv(runtime.casterBefore).Lotus_Game = {
    IsTimerBuff = function(kind) return kind == 3 or kind == 7 or kind == 13 end,
}
function caster:GetBuffNotifications() return activeBuffs end
local hudQueue = {}
local hudStatus = { GetType = function() return "HudStatus" end }
function hudStatus:GetBuffNotifications() return hudQueue end
function inventory:GetHudStatus() error("wrong-inventory-owner-called") end
local firstKind = identity("/Lotus/Upgrades/Test/NativeArcane", "/Lotus/Language/Test/NativeArcane")
local secondKind = identity("/Lotus/Powersuits/Test/Ability", "/Lotus/Language/Test/Ability")
activeBuffs = {
    { abilityType=firstKind, augmentType=0, instigator=caster, affected={caster},
      buffType=3, buffData=15, buffDataExtra=40, addBuff=true, isDebuff=false,
      effectIsPaused=false, tintIcon=true },
    { abilityType=secondKind, buffType=7, buffData=5, buffDataExtra=6, addBuff=false },
}
local savedHealth, savedStrength = state.health, strength
runtime.casterBefore(buffTrace, 100, "SetSource", {packet, caster}, true)
runtime.casterAfter(100, {})
assert(buffEvents[1][1] == "CASTER_STATS" and buffEvents[2][1] == "BUFF_LIST")
local json = buffEvents[2][3]
assert(string.find(json, '"ObservedAt":"caster-combat-boundary"', 1, true))
assert(string.find(json, '"NameTag":"/Lotus/Language/Test/NativeArcane"', 1, true))
assert(string.find(json, '"HudPercent":40', 1, true))
assert(string.find(json, '"TimerSeconds":15', 1, true))
assert(string.find(json, '"HudNumericValue":6', 1, true))
assert(string.find(json, '"StackCount":null', 1, true))
assert(state.health == savedHealth and strength == savedStrength)
assert(activeBuffs[1].buffData == 15 and activeBuffs[2].addBuff == false)

local statusReceiver = { GetType = function() return "HudStatus" end }
local args = { statusReceiver }
local beforeCount = #buffEvents
assert(runtime.casterBefore(buffTrace, 101, "GetBuffNotifications", args, false) == 101)
assert(#buffEvents == beforeCount) -- no pre-read or total-stat query
args[1] = nil -- stock is allowed to overwrite its native argument frame
runtime.casterAfter(101, { activeBuffs })
assert(#buffEvents == beforeCount + 1)
assert(string.find(buffEvents[#buffEvents][3], '"ReceiverType":"HudStatus"', 1, true))
assert(string.find(buffEvents[#buffEvents][3], '"ObservedAt":"stock-native-getter-return"', 1, true))
assert(#activeBuffs == 2 and activeBuffs[1].buffDataExtra == 40)
runtime.casterBefore(buffTrace, 102, "GetBuffNotifications", {statusReceiver}, false)
beforeCount = #buffEvents
runtime.casterAfter(102, { {} })
assert(#buffEvents == beforeCount) -- empty queue uses no trace budget
assert(runtime.casterBefore(nil, 103, "GetBuffNotifications", {statusReceiver}, true) == 0)

runtime.casterBefore(buffTrace, 104, "GetBuffNotifications", {statusReceiver}, false)
runtime.cleanup()
beforeCount = #buffEvents
runtime.casterAfter(104, {activeBuffs})
assert(#buffEvents == beforeCount and #activeBuffs == 2)
runtime.casterBefore(buffTrace, 105, "GetBuffNotifications", {statusReceiver}, false)
runtime.casterAfter(105, { "not-a-list" })
assert(string.find(buffEvents[#buffEvents][3], '"Available":false', 1, true))
assert(string.find(buffEvents[#buffEvents][3], '"NativeCount":null', 1, true))

local unknown = { abilityType={}, buffType=999, buffData=1/0, buffDataExtra=4 }
runtime.casterBefore(buffTrace, 106, "GetBuffNotifications", {statusReceiver}, false)
runtime.casterAfter(106, {{unknown}})
json = buffEvents[#buffEvents][3]
assert(string.find(json, '"NameAvailable":false', 1, true))
assert(string.find(json, '"BuffType":999,"BuffData":null,"BuffDataExtra":4', 1, true))
assert(string.find(json, '"HudPercent":null,"HudNumericValue":null,"HudMultiplier":null', 1, true))
local infinite = { abilityType=firstKind, buffType=3, buffData=-1, buffDataExtra=0 }
runtime.casterBefore(buffTrace, 107, "GetBuffNotifications", {statusReceiver}, false)
runtime.casterAfter(107, {{infinite}})
assert(string.find(buffEvents[#buffEvents][3], '"TimerSeconds":null,"TimerInfinite":true', 1, true))
assert(string.find(buffEvents[#buffEvents][3], '"HudPercent":0', 1, true))

local many = {}
for i=1,40 do many[i] = {abilityType=secondKind,buffType=7,buffData=i,buffDataExtra=i} end
beforeCount = #buffEvents
runtime.casterBefore(buffTrace, 108, "GetBuffNotifications", {statusReceiver}, false)
runtime.casterAfter(108, {many})
assert(#buffEvents == beforeCount + 16 and #many == 40)
for i=1,16 do
    local record=buffEvents[beforeCount+i][3]
    assert(string.find(record, '"NativeCount":40,"CapturedCount":32,"Truncated":true',1,true))
    assert(string.find(record, '"Chunk":'..tostring(i)..',"Chunks":16',1,true))
    assert(#record < 8192)
end

-- Quotes/backslashes are escaped, controls and oversize identities are omitted.
local hostile = string.rep('"\\', 96)
local hostileKind=identity(hostile,hostile)
local hostileInstigator=setmetatable({}, {__tostring=function() return string.rep('"\\',48) end})
local worst={abilityType=hostileKind,instigator=hostileInstigator,
    affected={hostileInstigator,hostileInstigator,hostileInstigator,hostileInstigator},
    buffType=3,buffData=999999,buffDataExtra=999999}
runtime.casterBefore(buffTrace,109,"GetBuffNotifications",{statusReceiver},false)
runtime.casterAfter(109,{{worst,worst}})
assert(#buffEvents[#buffEvents][3] < 8192)
local controlKind=identity("too\nshort","tag\1control")
runtime.casterBefore(buffTrace,110,"GetBuffNotifications",{statusReceiver},false)
runtime.casterAfter(110,{{{abilityType=controlKind}}})
assert(string.find(buffEvents[#buffEvents][3], '"NameAvailable":false',1,true))
local getter=caster.GetBuffNotifications
caster.GetBuffNotifications=nil
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,111,"SetSource",{packet,caster},true)
runtime.casterAfter(111,{})
assert(string.find(buffEvents[beforeCount+2][3], '"Available":false',1,true))
assert(string.find(buffEvents[beforeCount+2][3], '"Reason":"getter-failed"',1,true))
assert(string.find(buffEvents[beforeCount+2][3], '"GetterSucceeded":false,"ReturnType":"nil","GetterError":"',1,true))
caster.GetBuffNotifications=getter

-- Executable evidence proves nil is the native zero-record result. A thrown
-- getter, false scalar, or userdata must remain distinct from an empty list.
activeBuffs = nil
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,112,"SetSource",{packet,caster},true)
runtime.casterAfter(112,{})
json = buffEvents[beforeCount+2][3]
assert(string.find(json, '"Available":true,"Reason":null,"GetterSucceeded":true,"ReturnType":"nil","GetterError":null,"EmptyNativeList":true',1,true))
assert(string.find(json, '"NativeCount":0,"CapturedCount":0',1,true))
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,113,"GetBuffNotifications",{statusReceiver},true)
runtime.casterAfter(113,{})
assert(#buffEvents == beforeCount) -- valid empty stock queue omitted
runtime.casterBefore(buffTrace,114,"GetBuffNotifications",{statusReceiver},true)
runtime.casterAfter(114,{false})
assert(string.find(buffEvents[#buffEvents][3], '"Reason":"unsupported-return-type","GetterSucceeded":true,"ReturnType":"boolean"',1,true))
runtime.casterBefore(buffTrace,115,"GetBuffNotifications",{statusReceiver},true)
runtime.casterAfter(115,{newproxy()})
assert(string.find(buffEvents[#buffEvents][3], '"ReturnType":"userdata"',1,true))

caster.GetBuffNotifications=function() error('native-getter-test "quoted"\1control') end
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,116,"SetSource",{packet,caster},true)
runtime.casterAfter(116,{})
json = buffEvents[beforeCount+2][3]
assert(string.find(json, 'native-getter-test \\"quoted\\" control',1,true))
assert(not string.find(json,"\1",1,true))
caster.GetBuffNotifications=getter

-- HUD ownership is obtained from the actual stock getter return. InventoryControl
-- is deliberately an invalid owner; no combat-boundary call may use it.
hudQueue = {{abilityType=firstKind,buffType=3,buffData=12,buffDataExtra=40,addBuff=true},
    {abilityType=secondKind,buffType=7,buffData=1,buffDataExtra=6,addBuff=false}}
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,117,"GetHudStatus",{statusReceiver},true)
runtime.casterAfter(117,{hudStatus})
assert(buffEvents[beforeCount+1][1] == "BUFF_OWNER")
json = buffEvents[beforeCount+2][3]
assert(string.find(json, '"ObservedAt":"stock-hud-owner-getter-return"',1,true))
assert(string.find(json, '"NativeCount":2,"CapturedCount":2',1,true))
assert(string.find(json, '"NameTag":"/Lotus/Language/Test/NativeArcane"',1,true))
assert(string.find(json, '"AddBuff":false',1,true))
assert(hudQueue[1].buffDataExtra == 40 and hudQueue[2].addBuff == false and #hudQueue == 2)
local queueGetter = hudStatus.GetBuffNotifications
hudStatus.GetBuffNotifications = function() error("hud-queue-test-error") end
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,118,"GetHudStatus",{statusReceiver},true)
runtime.casterAfter(118,{hudStatus})
assert(#buffEvents == beforeCount+1) -- unchanged owner suppressed; changed queue result retained
assert(string.find(buffEvents[beforeCount+1][3], 'hud-queue-test-error',1,true))
hudStatus.GetBuffNotifications = queueGetter
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,123,"GetHudStatus",{statusReceiver},true)
runtime.casterAfter(123,{hudStatus})
assert(#buffEvents == beforeCount+1 and buffEvents[#buffEvents][1] == "BUFF_LIST")
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,124,"GetHudStatus",{statusReceiver},true)
runtime.casterAfter(124,{hudStatus})
assert(#buffEvents == beforeCount) -- identical owner/list poll allocates no event payload
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,119,"GetHudStatus",{statusReceiver},true)
runtime.casterAfter(119,{})
assert(#buffEvents == beforeCount+1 and buffEvents[#buffEvents][1] == "BUFF_OWNER")
assert(string.find(buffEvents[#buffEvents][3], '"OwnerReturnType":"nil","QueueGetterAttempted":false',1,true))
runtime.casterBefore(buffTrace,121,"GetHudStatus",{statusReceiver},true)
runtime.casterAfter(121,{false})
assert(string.find(buffEvents[#buffEvents-1][3], '"OwnerReturnType":"boolean","QueueGetterAttempted":true',1,true))
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,122,"SetSource",{packet,caster},true)
runtime.casterAfter(122,{})
assert(#buffEvents == beforeCount+2) -- caster + Avatar list; no guessed HUD owner
beforeCount = #buffEvents
runtime.casterBefore(buffTrace,120,"SetSource",{packet,caster},false)
runtime.casterAfter(120,{})
assert(#buffEvents == beforeCount+1) -- config off adds no getter/list reads
print("V100 BUFF TRANSITION PASS stock HUD owner, typed errors, state transitions, identical-poll suppression, bounded scalar fingerprints, off/root cleanup")
for _,event in ipairs(buffEvents) do
    if event[1]=="BUFF_LIST" then print("BUFF_FIXTURE json="..event[3]) end
    if event[1]=="BUFF_OWNER" then print("BUFF_OWNER_FIXTURE json="..event[3]) end
end
print("UNIVERSAL BUFF RUNTIME PASS unrelated resources, native queue return, combat list, authoritative HUD units, explicit unknowns, rooted pending receiver, empty/off/reset, no mutation, finite values, bounded chunks/identities")
