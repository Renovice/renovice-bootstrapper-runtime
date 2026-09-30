-- RENOVICE_NAME_HASH_SEED: 768e5ed0
-- RENOVICE_HASH_GLOBAL: Name__f49faa77
-- RENOVICE_HASH_FIELD: AvatarFade
-- RENOVICE_HASH_FIELD: PlayGlobalTransmission
-- RENOVICE_HASH_FIELD: RemoveByElement
-- RENOVICE_HASH_FIELD: SetPrimaryObjText
-- RENOVICE_HASH_FIELD: SetupMissionTransmissionSet
-- RENOVICE_HASH_FIELD: Ternary
-- RENOVICE_HASH_FIELD: UpdateAlignments
-- RENOVICE_IMPORT_CLASS: backColor.alpha=HS
-- RENOVICE_IMPORT_CLASS: backColor.blue=HS
-- RENOVICE_IMPORT_CLASS: backColor.green=HS
-- RENOVICE_IMPORT_CLASS: backColor.red=HS
-- RENOVICE_IMPORT_CLASS: startColor.alpha=HS
-- RENOVICE_IMPORT_CLASS: startColor.blue=HS
-- RENOVICE_IMPORT_CLASS: startColor.green=HS
-- RENOVICE_IMPORT_CLASS: startColor.red=HS
-- RENOVICE_IMPORT_CLASS: stoppedColor.alpha=HS
-- RENOVICE_IMPORT_CLASS: stoppedColor.blue=HS
-- RENOVICE_IMPORT_CLASS: stoppedColor.green=HS
-- RENOVICE_IMPORT_CLASS: stoppedColor.red=HS
-- RENOVICE_IMPORT_CLASS: unlockedTint.alpha=HS
-- RENOVICE_IMPORT_CLASS: unlockedTint.blue=HS
-- RENOVICE_IMPORT_CLASS: unlockedTint.green=HS
-- RENOVICE_IMPORT_CLASS: unlockedTint.red=HS
  local v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40
  v1 = 14
  v2 = 12
  v3 = 10
  v4 = 6
  v5 = 0
  v6 = 0
  v7 = 0
  v8 = 0
  v0 = {v1, v2, v3, v4, v5, v6, v7, v8}
  v2 = 180
  v3 = 180
  v4 = 180
  v5 = 180
  v6 = 180
  v7 = 180
  v8 = 180
  v9 = 180
  v1 = {v2, v3, v4, v5, v6, v7, v8, v9}
  v3 = 275
  v4 = 275
  v5 = 275
  v6 = 275
  v7 = 275
  v8 = 275
  v9 = 275
  v10 = 275
  v2 = {v3, v4, v5, v6, v7, v8, v9, v10}
  v4 = 275
  v5 = 275
  v6 = 275
  v7 = 275
  v8 = 275
  v9 = 275
  v10 = 275
  v11 = 275
  v3 = {v4, v5, v6, v7, v8, v9, v10, v11}
  v5 = 0.25
  v6 = 0.45
  v7 = 0.7
  v4 = {v5, v6, v7}
  v5 = 10000
  do
    -- REPLACEMENT_SETTINGS_V1 fixture: the only change against stock.
    local renovice_accessor = RENOVICE_SCRIPT_SETTINGS
    if renovice_accessor ~= nil then
      local renovice_settings = renovice_accessor()
      local renovice_entry = renovice_settings ~= nil and renovice_settings["hijack.payload_health"] or nil
      if renovice_entry ~= nil and renovice_entry.enabled == true and renovice_entry.stock == 10000 and renovice_entry.value ~= nil then
        v5 = renovice_entry.value
      end
    end
  end
  v6 = require
  v7 = "Lotus.Scripts.Libs.TableLib"
  v6 = v6(v7)
  v7 = require
  v8 = "EE.Interface.Utilities"
  v7 = v7(v8)
  v8 = require
  v9 = "Lotus.Interface.LotusUtilities"
  v8 = v8(v9)
  v9 = require
  v10 = "Lotus.Scripts.PostProcess.BasePostProcessFade"
  v9 = v9(v10)
  v10 = require
  v11 = "Lotus.Scripts.Libs.TransmissionSet"
  v10 = v10(v11)
  v11 = require
  v12 = "Lotus.Scripts.Libs.ObjectiveText"
  v11 = v11(v12)
  v12 = {}
  v13 = Symbol
  v14 = "PayloadAvatar"
  v13 = v13(v14)
  v14 = Symbol
  v15 = "PayloadMover"
  v14 = v14(v15)
  v15 = Symbol
  v16 = "PayloadDoor"
  v15 = v15(v16)
  v16 = Symbol
  v17 = "PayloadPassTrigger"
  v16 = v16(v17)
  v17 = Symbol
  v18 = "DoorControl"
  v17 = v17(v18)
  v18 = Symbol
  v19 = "ATVTreads"
  v18 = v18(v19)
  v19 = Symbol
  v20 = "ATVTreadsFx"
  v19 = v19(v20)
  v20 = Symbol
  v21 = "DoorControlObjective"
  v20 = v20(v21)
  v21 = Symbol
  v22 = "SpawnedMultiBoss"
  v21 = v21(v22)
  v22 = Symbol
  v23 = "RetrievalEventScore"
  v22 = v22(v23)
  v23 = Symbol
  v24 = "RetrievalEventHasMovedBackwards"
  v23 = v23(v24)
  v24 = Symbol
  v25 = "TargetHijacked"
  v24 = v24(v25)
  v25 = Symbol
  v26 = "MultiDefendDM"
  v25 = v25(v26)
  v26 = _T
  v27 = "FORWARD"
  v26.moverState = v27
  v26 = gRegion
  v26 = v26:IsMaster()
  v27 = gRegion
  v27 = v27:GetNpcMgr()
  v28 = v27:GetAiDirector()
  v29 = Type
  v30 = "/Lotus/Fx/Explosions/DefaultExplosion"
  v29 = v29(v30)
  v30 = nil
  v31 = Type
  v32 = "/Lotus/Types/Gameplay/Hijack/NullifyShieldBubbleDeco"
  v31 = v31(v32)
  v32 = Type
  v33 = "/Lotus/Types/Gameplay/Hijack/PowerCoreNullifyShieldBubbleDeco"
  v32 = v32(v33)
  v33 = WeakResource
  v34 = "/Lotus/Types/Friendly/Agents/PayloadATVAvatar"
  v33 = v33(v34)
  v34 = nil
  v35 = _T
  v36 = false
  v35.retrievalComplete = v36
  v35 = _T
  v36 = false
  v35.shouldPlayNightmareHackDoor = v36
  v35 = function()
    local c1v0, c1v1, c1v2, c1v3, c1v4, c1v5, c1v6, c1v7, c1v8
    local __renovice_state_0 = 0
    c1v0 = gGameRules
    c1v0 = c1v0:GetMission()
    c1v1 = c1v0.minEnemyLevel
    c1v2 = c1v0.maxEnemyLevel
    c1v3 = gGameRules
    c1v3 = c1v3:IsNightmareMode()
    c1v4 = 1
    if not (c1v1 <= c1v4) then
      __renovice_state_0 = 4
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c1v4 = 1
      if (not (c1v2 <= c1v4) or c1v3 ~= true) then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c1v1 = 17
      c1v2 = 22
      __renovice_state_0 = 7
    end
    if __renovice_state_0 == 4 then
      c1v4 = 1
      if not (c1v1 <= c1v4) then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c1v4 = 1
      if not (c1v2 <= c1v4) then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c1v1 = 8
      c1v2 = 12
      __renovice_state_0 = 7
    end
    if __renovice_state_0 == 7 then
      c1v4 = gRegion
      c1v4 = c1v4:GetHumanPlayerAvatars()
      c1v5 = #c1v4
      c1v6 = 4
      if not (c1v6 <= c1v5) then
        __renovice_state_0 = 9
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      c1v5 = v28
      c1v7 = c1v1 + 7
      c1v8 = c1v2 + 8
      c1v5:Name__a4aee1b4(c1v7, c1v8)
      do return end
    end
    if __renovice_state_0 == 9 then
      c1v5 = #c1v4
      c1v6 = 3
      if not (c1v6 <= c1v5) then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      c1v5 = v28
      c1v7 = c1v1 + 4
      c1v8 = c1v2 + 5
      c1v5:Name__a4aee1b4(c1v7, c1v8)
      do return end
    end
    if __renovice_state_0 == 11 then
      c1v5 = #c1v4
      c1v6 = 2
      if not (c1v6 <= c1v5) then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      c1v5 = v28
      c1v7 = c1v1 + 2
      c1v8 = c1v2 + 3
      c1v5:Name__a4aee1b4(c1v7, c1v8)
      do return end
    end
    if __renovice_state_0 == 13 then
      c1v5 = #c1v4
      c1v6 = 1
      if not (c1v6 <= c1v5) then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c1v5 = v28
      c1v5:Name__a4aee1b4(c1v1, c1v2)
      __renovice_state_0 = 15
    end
    if __renovice_state_0 == 15 then
      do return end
    end
    do return end
  end
  v36 = function(c2v0, c2v1)
    local c2v2, c2v3, c2v4, c2v5, c2v6, c2v7
    c2v2 = 99999999
    c2v3 = nil
    c2v6 = 1
    c2v4 = #c2v0
    c2v5 = 1
    for __renovice_for_0_0 = c2v6, c2v4, c2v5 do
      c2v7 = c2v0[__renovice_for_0_0]
      c2v7 = c2v7:DistanceToPoint(c2v1)
      if not (c2v7 < c2v2) then
        continue
      end
      c2v2 = c2v7
      c2v3 = c2v0[__renovice_for_0_0]
    end
    do return c2v3 end
  end
  v37 = function(c3v0)
    local c3v1, c3v2, c3v3, c3v4, c3v5, c3v6, c3v7, c3v8, c3v9, c3v10, c3v11, c3v12, c3v13, c3v14, c3v15, c3v16
    c3v1 = gRegion
    c3v3 = Symbol
    c3v4 = "PayloadLensflare"
    c3v1 = c3v1:FindTagged(c3v3(c3v4))
    c3v2 = nil
    c3v3 = IsNull
    c3v3 = c3v3(c3v1)
    if not c3v3 then
      c3v2 = c3v1[1]
    end
    c3v3 = IsNull
    c3v3 = c3v3(c3v2)
    if c3v3 then
      c3v3 = gRegion
      c3v5 = Symbol
      c3v6 = "PayloadAvatar"
      c3v3 = c3v3:FindTagged(c3v5(c3v6))
      c3v2 = c3v3[1]
    end
    c3v3 = nil
    c3v4 = false
    c3v5 = gGameRules
    c3v5 = c3v5:GetMissionType()
    c3v6 = 18
    if c3v5 == c3v6 then
      c3v4 = gGameRules
      c3v4 = c3v4:IsNightmareMode()
    end
    c3v5 = 0
    while true do
      c3v6 = beamDelay
      if not (c3v5 < c3v6) then break end
      c3v6 = IsNull
      c3v6 = c3v6(c3v2)
      if c3v6 then break end
      c3v7 = _T.gHitTrap
      c3v6 = IsNull
      c3v6 = c3v6(c3v7)
      if not c3v6 then break end
      if c3v4 then
        c3v6 = c3v0:GetAttachParent()
        c3v7 = IsNull
        c3v7 = c3v7(c3v6)
        if not c3v7 then
          c3v7 = c3v6:DamageControl()
          c3v7 = c3v7:GetShield()
          if c3v7 == 0 then break end
        end
      end
      c3v3 = c3v2:GetPosition()
      c3v0:SetEndPoint(c3v3)
      c3v6 = DeltaTime
      c3v6 = c3v6()
      c3v5 = c3v5 + c3v6
      c3v6 = Sleep
      c3v7 = 0
      c3v6(c3v7)
    end
    c3v6 = IsNull
    c3v6 = c3v6(c3v0)
    if not c3v6 then
      c3v0:Destroy()
    end
    c3v6 = c3v0:GetAttachParent()
    c3v8 = _T.gHitTrap
    c3v7 = IsNull
    c3v7 = c3v7(c3v8)
    if not c3v7 then
      c3v7 = IsNull
      c3v7 = c3v7(c3v6)
      if not c3v7 then
        c3v7 = c3v6:DamageControl()
        c3v9 = 0
        c3v10 = false
        c3v7:SetShield(c3v9, c3v10)
      end
    end
    if c3v4 then
      repeat
        c3v8 = _T.NoShieldCooldown
        c3v7 = IsNull
        c3v7 = c3v7(c3v8)
        if not c3v7 then
          c3v7 = _T.NoShieldCooldown
          c3v8 = 0
          if not (c3v7 <= c3v8) then break end
        end
        c3v7 = c3v6:DamageControl()
        c3v7 = c3v7:GetShield()
        if c3v7 == 0 then
          c3v7 = _T
          c3v8 = 15
          c3v7.NoShieldCooldown = c3v8
          c3v7 = Engine.DamageData
          c3v7 = c3v7()
          v30 = c3v7
          c3v7 = v30
          c3v8 = 200
          c3v7.baseAmount = c3v8
          c3v7 = v30
          c3v9 = 19
          c3v10 = true
          c3v7:SetProc(c3v9, c3v10)
          c3v7 = gRegion
          c3v7 = c3v7:GetHumanPlayerAvatars()
          c3v8 = c3v6:GetPosition()
          c3v9 = ipairs
          c3v9, c3v10, c3v11 = c3v9(c3v7)
          for __renovice_for_0_0, __renovice_for_0_1 in c3v9, c3v10, c3v11 do
            c3v14 = __renovice_for_0_1:DistanceToPoint(c3v8)
            c3v15 = 10
            if not (c3v14 <= c3v15) then
              continue
            end
            c3v15 = __renovice_for_0_1:GetPosition()
            c3v14 = c3v15 - c3v8
            c3v15 = v30
            c3v16 = c3v14 * 100
            c3v15:SetImpulse(c3v16)
            c3v16 = v30
            __renovice_for_0_1:DamageDD(c3v16)
          end
          c3v9 = gRegion
          c3v11 = v29
          c3v12 = c3v6:GetPosition()
          c3v13 = ZERO_ROTATION
          c3v9:CreateEntity(c3v11, c3v12, c3v13)
        end
      until true
    end
    do return end
  end
  UpdatePayloadBeam = v37
  v37 = function(c4v0)
    local c4v1, c4v2, c4v3, c4v4, c4v5, c4v6
    c4v1 = gRegion
    c4v3 = Symbol
    c4v4 = "PayloadCineAttach"
    c4v1 = c4v1:FindTagged(c4v3(c4v4))
    c4v2 = IsNull
    c4v2 = c4v2(c4v1)
    if c4v2 then
      do return end
    end
    c4v3 = gRegion
    c4v5 = Symbol
    c4v6 = "PayloadCineAttach"
    c4v3 = c4v3:FindTagged(c4v5(c4v6))
    c4v2 = c4v3[1]
    c4v3 = nil
    while true do
      c4v4 = IsNull
      c4v4 = c4v4(c4v2)
      if c4v4 then break end
      c4v6 = shipBone
      c4v3 = c4v2:GetBonePosition(c4v6)
      c4v0:SetEndPoint(c4v3)
      c4v4 = Sleep
      c4v5 = 0
      c4v4(c4v5)
    end
    c4v4 = IsNull
    c4v4 = c4v4(c4v0)
    if not c4v4 then
      c4v0:Destroy()
    end
    do return end
  end
  UpdateCinematicBeam = v37
  v37 = function(c5v0)
    local c5v1
    c5v1 = IsNull
    c5v1 = c5v1(c5v0)
    if not c5v1 then
      c5v0:Disable()
    end
    do return end
  end
  v38 = function(c6v0)
    local c6v1
    c6v1 = IsNull
    c6v1 = c6v1(c6v0)
    if not c6v1 then
      c6v0:Enable()
    end
    do return end
  end
  v39 = function(c7v0)
    local c7v1, c7v2, c7v3, c7v4, c7v5, c7v6, c7v7, c7v8, c7v9, c7v10, c7v11, c7v12, c7v13, c7v14, c7v15, c7v16, c7v17, c7v18, c7v19, c7v20, c7v21, c7v22, c7v23, c7v24, c7v25, c7v26, c7v27, c7v28, c7v29, c7v30, c7v31, c7v32, c7v33, c7v34, c7v35, c7v36, c7v37, c7v38, c7v39, c7v40, c7v41, c7v42, c7v43, c7v44, c7v45, c7v46, c7v47, c7v48
    c7v1 = 0
    c7v2 = 0
    c7v3 = 0
    c7v4 = 0
    c7v5 = 0
    c7v6 = 0
    c7v7 = Sleep
    c7v8 = 0
    c7v7(c7v8)
    c7v7 = gRegion
    c7v9 = v14
    c7v7 = c7v7:FindTagged(c7v9)
    while true do
      if c7v7 ~= nil then break end
      c7v10 = gRegion
      c7v10 = c7v10:IsMaster()
      c7v9 = not c7v10
      c7v8 = assert
      c7v8(c7v9)
      c7v8 = Sleep
      c7v9 = 0
      c7v8(c7v9)
      c7v8 = gRegion
      c7v10 = v14
      c7v7 = c7v8:FindTagged(c7v10)
    end
    c7v8 = c7v7[1]
    c7v11 = payloadLightType
    c7v9 = c7v0:GetAttachment(c7v11)
    c7v10 = gRegion
    c7v12 = Symbol
    c7v13 = "PayloadAttachedDeco"
    c7v10 = c7v10:FindFirstTagged(c7v12(c7v13))
    c7v11 = nil
    c7v12 = IsNull
    c7v12 = c7v12(c7v10)
    if not c7v12 then
      c7v14 = projType
      c7v15 = EMPTY_SYMBOL
      c7v11 = c7v10:Attach(c7v14, c7v15)
    else
      c7v10 = c7v8
      c7v14 = projType
      c7v15 = EMPTY_SYMBOL
      c7v11 = c7v8:Attach(c7v14, c7v15)
    end
    c7v12 = gRegion
    c7v14 = Symbol
    c7v15 = "PayloadLensflare"
    c7v12 = c7v12:FindFirstTagged(c7v14(c7v15))
    c7v15 = shieldDrainSeqType
    c7v13 = c7v0:GetAttachment(c7v15)
    c7v16 = coreReverseSeqType
    c7v14 = c7v0:GetAttachment(c7v16)
    c7v15 = gRegion
    c7v17 = v15
    c7v15 = c7v15:FindTagged(c7v17)
    v12 = c7v15
    c7v15 = gRegion
    c7v17 = v18
    c7v15 = c7v15:FindFirstTagged(c7v17)
    c7v16 = IsNull
    c7v16 = c7v16(c7v15)
    if not c7v16 then
      c7v18 = true
      c7v19 = true
      c7v15:SetVisibility(c7v18, c7v19)
    end
    c7v16 = gRegion
    c7v18 = v19
    c7v16 = c7v16:FindTagged(c7v18)
    c7v17 = ObjectPortHandler
    c7v19 = "OnDone"
    c7v17(c7v8, c7v19)
    c7v19 = 1
    c7v20 = v12
    c7v17 = #c7v20
    c7v18 = 1
    for __renovice_for_0_0 = c7v19, c7v17, c7v18 do
      c7v20 = ObjectPortHandler
      c7v21 = v12[__renovice_for_0_0]
      c7v22 = "OnDone"
      c7v20(c7v21, c7v22)
    end
    c7v17 = Sleep
    c7v18 = 0
    c7v17(c7v18)
    c7v17 = IsNull
    c7v17 = c7v17(c7v0)
    if not c7v17 then
      c7v17 = v26
      if c7v17 then
        c7v20 = Symbol
        c7v0:Name__1d1bbf9c(c7v8, c7v20())
        c7v19 = false
        c7v0:Name__33e52783(c7v19)
        c7v17 = c7v0:DamageControl()
        c7v19 = v25
        c7v17:RemoveDamageModifier(c7v19)
        c7v17 = c7v0:DamageControl()
        c7v19 = 0
        c7v17:SetShield(c7v19)
        c7v17 = gGameRules
        c7v17:Name__b2dacfd1(c7v0)
      end
    end
    while true do
      c7v18 = _T.AddHudTracker
      c7v17 = IsNull
      c7v17 = c7v17(c7v18)
      if not c7v17 then break end
      c7v17 = Sleep
      c7v18 = 0
      c7v17(c7v18)
    end
    while true do
      c7v17 = _T.RetrievalMissionDelay
      if not c7v17 then break end
      c7v17 = Sleep
      c7v18 = 0
      c7v17(c7v18)
    end
    c7v17 = _T.AddHudTracker
    c7v18 = "RMHealthTracker"
    c7v19 = v8
    c7v19 = c7v19.HT_HEALTH_TRACKER
    c7v20 = 0.5
    c7v21 = false
    c7v22 = false
    c7v17 = c7v17(c7v18, c7v19, c7v20, c7v21, c7v22)
    v34 = c7v17
    c7v17 = v34
    c7v17 = c7v17.SetTarget
    c7v17(c7v0)
    c7v17 = v34
    c7v17 = c7v17.SetHealthWarningThreshold
    c7v18 = 20
    c7v17(c7v18)
    c7v17 = v11
    c7v17 = c7v17.UpdateAlignments
    c7v19 = v34
    c7v18 = {c7v19}
    c7v17(c7v18)
    c7v17 = gRegion
    c7v17 = c7v17:IsMaster()
    if c7v17 then
      c7v17 = gGameRules
      c7v19 = v23
      c7v20 = 2
      c7v17 = c7v17:GetNetPersistentVar(c7v19, c7v20)
      if c7v17 == 2 then
        c7v17 = gGameRules
        c7v19 = v23
        c7v20 = 0
        c7v17:SetNetPersistentVar(c7v19, c7v20)
      end
    end
    c7v17 = nil
    c7v18 = gGameRules
    c7v18 = c7v18:GetMissionType()
    c7v19 = 18
    if c7v18 == c7v19 then
      c7v19 = 0
      c7v20 = 0
      c7v21 = 0
      c7v22 = 0
      c7v23 = 0
      c7v24 = 0
      c7v25 = 0
      c7v26 = 0
      c7v18 = {c7v19, c7v20, c7v21, c7v22, c7v23, c7v24, c7v25, c7v26}
      v0 = c7v18
      c7v20 = gDamageTriggerType
      c7v17 = c7v0:GetAttachment(c7v20)
      c7v18 = gGameRules
      c7v20 = "Fomorian Core Found"
      c7v18:AddRaidProgressTag(c7v20)
    end
    c7v18 = print
    c7v19 = "Retrieval Mission: Avatar Initialized"
    c7v18(c7v19)
    c7v18 = "STOPPED"
    c7v19 = _T
    c7v20 = nil
    c7v19.gHitTrap = c7v20
    c7v19 = false
    c7v20 = gRegion
    c7v22 = Symbol
    c7v23 = "AutoAdvanceWaypoint"
    c7v20 = c7v20:FindTagged(c7v22(c7v23))
    while true do
      c7v21 = _T.RetrievalMissionDelay
      if not c7v21 then break end
      c7v21 = Sleep
      c7v22 = 0
      c7v21(c7v22)
    end
    while true do
      c7v21 = IsNull
      c7v21 = c7v21(c7v8)
      if c7v21 then break end
      c7v21 = IsNull
      c7v21 = c7v21(c7v0)
      if c7v21 then break end
      c7v21 = _T.retrievalComplete
      if c7v21 then break end
      c7v21 = gRegion
      c7v21 = c7v21:GetHumanPlayerAvatars()
      c7v22 = #c7v21
      c7v23 = 0
      c7v24 = gRegion
      c7v24 = c7v24:IsMaster()
      v26 = c7v24
      c7v24 = false
      c7v25 = true
      c7v26 = true
      c7v27 = 0
      c7v28 = c7v8:GetDelta()
      c7v29 = 0
      c7v30 = c7v0:GetHealth()
      c7v31 = customOffset
      if c7v31 ~= 0 then
        c7v33 = Vector
        c7v34 = 0
        c7v35 = customOffset
        c7v36 = 0
        c7v33 = c7v33(c7v34, c7v35, c7v36)
        c7v34 = ZERO_ROTATION
        c7v0:Name__a983787e(c7v33, c7v34)
      end
      c7v33 = 1
      c7v31 = #c7v21
      c7v32 = 1
      for __renovice_for_1_0 = c7v33, c7v31, c7v32 do
        c7v34 = c7v21[__renovice_for_1_0]
        c7v36 = gLotusOperatorAvatarType
        c7v34 = c7v34:IsA(c7v36)
        if c7v34 then
          continue
        end
        c7v34 = c7v21[__renovice_for_1_0]
        c7v34 = c7v34:IsKilled()
        if c7v34 then
          continue
        end
        c7v34 = c7v21[__renovice_for_1_0]
        c7v34 = c7v34:IsPreDeath()
        if c7v34 then
          continue
        end
        c7v35 = c7v21[__renovice_for_1_0]
        c7v35 = c7v35:DistanceToEntity(c7v0)
        c7v36 = retrievalPushRadius
        if not (c7v35 < c7v36) then
          c7v34 = false
        else
          c7v34 = true
        end
        if c7v34 then
          c7v24 = c7v24 or c7v34
          c7v35 = c7v21[__renovice_for_1_0]
          c7v35 = c7v35:DamageControl()
          c7v35 = c7v35:GetShield()
          c7v36 = c7v21[__renovice_for_1_0]
          c7v36 = c7v36:DamageControl()
          c7v36 = c7v36:GetMaxShield()
          c7v37 = c7v21[__renovice_for_1_0]
          c7v37 = c7v37:GetHealth()
          c7v38 = 0
          if c7v38 < c7v35 then
            c7v23 = c7v23 + 1
            c7v27 = c7v27 + c7v35
          else
            if c7v36 == 0 then
              c7v38 = 0
              if c7v38 < c7v37 then
                c7v23 = c7v23 + 1
                c7v27 = c7v27 + c7v37
              end
            end
          end
        end
        c7v35 = c7v24
        if c7v35 then
          c7v36 = 0
          if not (c7v36 < c7v27) then
            c7v35 = false
          else
            c7v35 = true
          end
        end
        c7v24 = c7v35
      end
      c7v31 = c7v8:GetPosition()
      c7v32 = false
      c7v33 = v36
      c7v34 = v12
      c7v33 = c7v33(c7v34, c7v31)
      c7v34 = IsNull
      c7v34 = c7v34(c7v33)
      if not c7v34 then
        c7v34 = c7v33:GetIsMoving()
        c7v36 = c7v33:DistanceToEntity(c7v0)
        c7v37 = 6
        if not (c7v36 < c7v37) then
          c7v35 = false
        else
          c7v35 = true
        end
        if (c7v35 or c7v34) then
          c7v25 = false
          c7v32 = true
        end
      end
      c7v34 = _T.RetrievalMissionScriptedStop
      if c7v34 then
        c7v26 = false
      end
      c7v34 = false
      c7v35 = autoAdvanceThroughDoors
      if c7v35 then
        c7v35 = c7v0:GetPosition()
        c7v36 = v36
        c7v36 = c7v36(c7v20, c7v35)
        c7v38 = c7v36:DistanceToPoint(c7v35)
        c7v37 = math.abs
        c7v37 = c7v37(c7v38)
        c7v38 = autoAdvanceWpDistCheck
        if c7v37 <= c7v38 then
          c7v34 = true
        end
      end
      c7v35 = v4[3]
      if c7v35 < c7v28 then
        c7v29 = v4[3]
      else
        c7v35 = v4[2]
        if c7v35 < c7v28 then
          c7v29 = v4[2]
        else
          c7v35 = v4[1]
          if c7v35 < c7v28 then
            c7v29 = v4[1]
          else
            c7v29 = 0
          end
        end
      end
      if not c7v19 then
        c7v35 = gGameRules
        c7v35 = c7v35:GetMissionType()
        c7v36 = 18
        if c7v35 == c7v36 then
          c7v35 = 0.5
          if c7v35 < c7v28 then
            c7v35 = gGameRules
            c7v37 = "Fomorian Core Transport"
            c7v35:AddRaidProgressTag(c7v37)
            c7v19 = true
          end
        end
      end
      c7v36 = _T.gTestingRaidPerf
      c7v35 = IsNull
      c7v35 = c7v35(c7v36)
      if c7v35 then
        c7v35 = _T
        c7v36 = false
        c7v35.gTestingRaidPerf = c7v36
      end
      c7v36 = _T.NoShieldCooldown
      c7v35 = IsNull
      c7v35 = c7v35(c7v36)
      if not c7v35 then
        c7v35 = _T.NoShieldCooldown
        c7v36 = 0
        if c7v36 < c7v35 then
          c7v35 = _T
          c7v37 = _T.NoShieldCooldown
          c7v38 = Name__f3c503f8
          c7v38 = c7v38()
          c7v36 = c7v37 - c7v38
          c7v35.NoShieldCooldown = c7v36
        end
      end
      if c7v34 then
        c7v35 = _T
        c7v36 = "FORWARD"
        c7v35.moverState = c7v36
        c7v38 = v1[1]
        c7v37 = c7v38 / 2
        c7v8:SetAnimationTime(c7v37)
      else
        if c7v22 == 0 then
        else
          local __renovice_state_0 = -1
          if ((not c7v24 or not c7v25) or not c7v26) then
            __renovice_state_0 = 3
          else
            __renovice_state_0 = 1
          end
          if __renovice_state_0 == 1 then
            c7v35 = 0
            if not (c7v35 < c7v23) then
              __renovice_state_0 = 3
            else
              __renovice_state_0 = 2
            end
          end
          if __renovice_state_0 == 2 then
            c7v36 = _T.gHitTrap
            c7v35 = IsNull
            c7v35 = c7v35(c7v36)
            if c7v35 then
              __renovice_state_0 = -1
            else
              __renovice_state_0 = 3
            end
          end
          if __renovice_state_0 == 3 then
            c7v35 = _T.gTestingRaidPerf
            if not c7v35 then
              __renovice_state_0 = 5
            else
              __renovice_state_0 = 4
            end
          end
          if __renovice_state_0 == 4 then
            c7v35 = 0.15
            if not (c7v28 < c7v35) then
              __renovice_state_0 = 5
            else
              __renovice_state_0 = -1
            end
          end
          if __renovice_state_0 == 5 then
            c7v36 = _T.gHitTrap
            c7v35 = IsNull
            c7v35 = c7v35(c7v36)
            if c7v35 then
              __renovice_state_0 = 10
            else
              __renovice_state_0 = 6
            end
          end
          if __renovice_state_0 == 6 then
            c7v37 = trapFx
            c7v35 = c7v10:HasAttachment(c7v37)
            if c7v35 then
              __renovice_state_0 = 10
            else
              __renovice_state_0 = 7
            end
          end
          if __renovice_state_0 == 7 then
            c7v35 = _T.gTestingRaidPerf
            if c7v35 then
              __renovice_state_0 = 10
            else
              __renovice_state_0 = 8
            end
          end
          if __renovice_state_0 == 8 then
            c7v35 = _T
            c7v36 = "STOPPED"
            c7v35.moverState = c7v36
            c7v8:StopMovement()
            c7v37 = trapFx
            c7v38 = EMPTY_SYMBOL
            c7v10:Attach(c7v37, c7v38)
            c7v37 = trapFx
            c7v38 = EMPTY_SYMBOL
            c7v8:Attach(c7v37, c7v38)
            c7v35 = IsNull
            c7v35 = c7v35(c7v17)
            if c7v35 then
              __renovice_state_0 = 26
            else
              __renovice_state_0 = 9
            end
          end
          if __renovice_state_0 == 9 then
            c7v17:Enable()
            __renovice_state_0 = 26
          end
          if __renovice_state_0 == 10 then
            c7v36 = _T.gHitTrap
            c7v35 = IsNull
            c7v35 = c7v35(c7v36)
            if c7v35 then
              __renovice_state_0 = 18
            else
              __renovice_state_0 = 11
            end
          end
          if __renovice_state_0 == 11 then
            c7v35 = _T.gHitTrap
            c7v35 = c7v35:IsEnabled()
            if c7v35 then
              __renovice_state_0 = 18
            else
              __renovice_state_0 = 12
            end
          end
          if __renovice_state_0 == 12 then
            c7v35 = _T
            c7v36 = nil
            c7v35.gHitTrap = c7v36
            c7v37 = trapFx
            c7v35 = c7v10:GetAttachment(c7v37)
            c7v36 = IsNull
            c7v36 = c7v36(c7v35)
            if c7v36 then
              __renovice_state_0 = 14
            else
              __renovice_state_0 = 13
            end
          end
          if __renovice_state_0 == 13 then
            c7v35:Destroy()
            __renovice_state_0 = 14
          end
          if __renovice_state_0 == 14 then
            c7v38 = trapFx
            c7v35 = c7v8:GetAttachment(c7v38)
            c7v36 = IsNull
            c7v36 = c7v36(c7v35)
            if c7v36 then
              __renovice_state_0 = 16
            else
              __renovice_state_0 = 15
            end
          end
          if __renovice_state_0 == 15 then
            c7v35:Destroy()
            __renovice_state_0 = 16
          end
          if __renovice_state_0 == 16 then
            c7v36 = IsNull
            c7v36 = c7v36(c7v17)
            if c7v36 then
              __renovice_state_0 = 26
            else
              __renovice_state_0 = 17
            end
          end
          if __renovice_state_0 == 17 then
            c7v17:Disable()
            __renovice_state_0 = 26
          end
          if __renovice_state_0 == 18 then
            c7v35 = Name__0082a838
            if not c7v35 then
              __renovice_state_0 = 25
            else
              __renovice_state_0 = 19
            end
          end
          if __renovice_state_0 == 19 then
            c7v35 = v0[c7v22]
            if not (c7v35 < c7v1) then
              __renovice_state_0 = 25
            else
              __renovice_state_0 = 20
            end
          end
          if __renovice_state_0 == 20 then
            c7v35 = 0.17
            if (not (c7v35 < c7v28) or c7v32) then
              __renovice_state_0 = 25
            else
              __renovice_state_0 = 21
            end
          end
          if __renovice_state_0 == 21 then
            c7v35 = _T.gHitTrap
            if c7v35 then
              __renovice_state_0 = 25
            else
              __renovice_state_0 = 22
            end
          end
          if __renovice_state_0 == 22 then
            c7v35 = v26
            if not c7v35 then
              __renovice_state_0 = 24
            else
              __renovice_state_0 = 23
            end
          end
          if __renovice_state_0 == 23 then
            c7v35 = gGameRules
            c7v37 = v23
            c7v38 = 1
            c7v35:SetNetPersistentVar(c7v37, c7v38)
            __renovice_state_0 = 24
          end
          if __renovice_state_0 == 24 then
            c7v35 = _T
            c7v36 = "BACKWARD"
            c7v35.moverState = c7v36
            c7v37 = v3[c7v22]
            c7v8:SetAnimationTime(c7v37)
            c7v8:StartMovement()
            c7v8:Name__d84e370b()
            __renovice_state_0 = 26
          end
          if __renovice_state_0 == 25 then
            c7v35 = _T
            c7v36 = "STOPPED"
            c7v35.moverState = c7v36
            c7v8:StopMovement()
            __renovice_state_0 = 26
          end
          if __renovice_state_0 ~= 26 then
            c7v35 = _T
            c7v36 = "FORWARD"
            c7v35.moverState = c7v36
            c7v36 = c7v22 - c7v23
            c7v35 = c7v36 + 1
            c7v36 = c7v0:DamageControl()
            c7v39 = 4
            c7v37 = c7v36:IsProcActive(c7v39)
            if c7v37 then
              c7v39 = v2[c7v35]
              c7v8:SetAnimationTime(c7v39)
            else
              c7v39 = v1[c7v35]
              c7v8:SetAnimationTime(c7v39)
            end
            c7v8:StartForwardMovement()
            c7v1 = 0
          end
        end
      end
      c7v35 = IsNull
      c7v35 = c7v35(c7v10)
      if c7v35 then
        c7v37 = gRegion
        c7v37 = c7v37:IsMaster()
        c7v36 = not c7v37
        c7v35 = assert
        c7v35(c7v36)
      else
        c7v35 = _T.moverState
        if c7v35 == "FORWARD" then
          c7v35 = IsNull
          c7v35 = c7v35(c7v9)
          if not c7v35 then
            c7v37 = startColor
            c7v9:SetColor(c7v37)
          end
          c7v35 = IsNull
          c7v35 = c7v35(c7v12)
          if not c7v35 then
            c7v37 = startColor
            c7v12:SetTint(c7v37)
          end
          c7v35 = IsNull
          c7v35 = c7v35(c7v11)
          if not c7v35 then
            c7v37 = payloadProjColor
            c7v39 = startColor.red
            c7v38 = c7v39 / 255
            c7v40 = startColor.green
            c7v39 = c7v40 / 255
            c7v41 = startColor.blue
            c7v40 = c7v41 / 255
            c7v42 = startColor.alpha
            c7v41 = c7v42 / 255
            c7v11:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
          end
          c7v37 = Lotus_Game.TINT_COLOR
          c7v39 = startColor.red
          c7v38 = c7v39 / 255
          c7v40 = startColor.green
          c7v39 = c7v40 / 255
          c7v41 = startColor.blue
          c7v40 = c7v41 / 255
          c7v42 = startColor.alpha
          c7v41 = c7v42 / 255
          c7v10:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
          c7v37 = Lotus_Game.EMISSIVE_TINT_COLOR
          c7v39 = startColor.red
          c7v38 = c7v39 / 255
          c7v40 = startColor.green
          c7v39 = c7v40 / 255
          c7v41 = startColor.blue
          c7v40 = c7v41 / 255
          c7v42 = startColor.alpha
          c7v41 = c7v42 / 255
          c7v10:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
          c7v35 = IsNull
          c7v35 = c7v35(c7v14)
          if not c7v35 then
            c7v14:Disable()
          end
          c7v35 = IsNull
          c7v35 = c7v35(c7v13)
          if not c7v35 then
            c7v13:Enable()
          end
        else
          c7v35 = _T.moverState
          if c7v35 == "BACKWARD" then
            c7v35 = IsNull
            c7v35 = c7v35(c7v9)
            if not c7v35 then
              c7v37 = backColor
              c7v9:SetColor(c7v37)
            end
            c7v35 = IsNull
            c7v35 = c7v35(c7v12)
            if not c7v35 then
              c7v37 = backColor
              c7v12:SetTint(c7v37)
            end
            c7v35 = IsNull
            c7v35 = c7v35(c7v11)
            if not c7v35 then
              c7v37 = payloadProjColor
              c7v39 = backColor.red
              c7v38 = c7v39 / 255
              c7v40 = backColor.green
              c7v39 = c7v40 / 255
              c7v41 = backColor.blue
              c7v40 = c7v41 / 255
              c7v42 = backColor.alpha
              c7v41 = c7v42 / 255
              c7v11:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
            end
            c7v37 = Lotus_Game.TINT_COLOR
            c7v39 = backColor.red
            c7v38 = c7v39 / 255
            c7v40 = backColor.green
            c7v39 = c7v40 / 255
            c7v41 = backColor.blue
            c7v40 = c7v41 / 255
            c7v42 = backColor.alpha
            c7v41 = c7v42 / 255
            c7v10:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
            c7v37 = Lotus_Game.EMISSIVE_TINT_COLOR
            c7v39 = backColor.red
            c7v38 = c7v39 / 255
            c7v40 = backColor.green
            c7v39 = c7v40 / 255
            c7v41 = backColor.blue
            c7v40 = c7v41 / 255
            c7v42 = backColor.alpha
            c7v41 = c7v42 / 255
            c7v10:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
            c7v35 = IsNull
            c7v35 = c7v35(c7v13)
            if not c7v35 then
              c7v13:Disable()
            end
          else
            c7v35 = _T.moverState
            if c7v35 == "STOPPED" then
              c7v35 = IsNull
              c7v35 = c7v35(c7v9)
              if not c7v35 then
                c7v37 = stoppedColor
                c7v9:SetColor(c7v37)
              end
              c7v35 = IsNull
              c7v35 = c7v35(c7v12)
              if not c7v35 then
                c7v37 = stoppedColor
                c7v12:SetTint(c7v37)
              end
              c7v35 = IsNull
              c7v35 = c7v35(c7v11)
              if not c7v35 then
                c7v37 = payloadProjColor
                c7v39 = stoppedColor.red
                c7v38 = c7v39 / 255
                c7v40 = stoppedColor.green
                c7v39 = c7v40 / 255
                c7v41 = stoppedColor.blue
                c7v40 = c7v41 / 255
                c7v42 = stoppedColor.alpha
                c7v41 = c7v42 / 255
                c7v11:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
              end
              c7v37 = Lotus_Game.TINT_COLOR
              c7v39 = stoppedColor.red
              c7v38 = c7v39 / 255
              c7v40 = stoppedColor.green
              c7v39 = c7v40 / 255
              c7v41 = stoppedColor.blue
              c7v40 = c7v41 / 255
              c7v42 = stoppedColor.alpha
              c7v41 = c7v42 / 255
              c7v10:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
              c7v37 = Lotus_Game.EMISSIVE_TINT_COLOR
              c7v39 = stoppedColor.red
              c7v38 = c7v39 / 255
              c7v40 = stoppedColor.green
              c7v39 = c7v40 / 255
              c7v41 = stoppedColor.blue
              c7v40 = c7v41 / 255
              c7v42 = stoppedColor.alpha
              c7v41 = c7v42 / 255
              c7v10:SetMaterialParam(c7v37, c7v38, c7v39, c7v40, c7v41)
              c7v35 = IsNull
              c7v35 = c7v35(c7v14)
              if not c7v35 then
                c7v14:Disable()
              end
              c7v35 = IsNull
              c7v35 = c7v35(c7v13)
              if not c7v35 then
                c7v13:Disable()
              end
            end
          end
        end
      end
      c7v35 = IsNull
      c7v35 = c7v35(c7v15)
      if not c7v35 then
        c7v35 = _T.moverState
        if c7v35 == "FORWARD" then
          c7v37 = 0
          c7v38 = atvTreadsAnimRate
          c7v15:SetAnimRate(c7v37, c7v38)
        else
          c7v35 = _T.moverState
          if c7v35 == "BACKWARD" then
            c7v37 = 0
            c7v39 = atvTreadsAnimRate
            c7v38 = c7v39 * -1
            c7v15:SetAnimRate(c7v37, c7v38)
          else
            c7v35 = _T.moverState
            if c7v35 == "STOPPED" then
              c7v37 = 0
              c7v38 = 0.001
              c7v15:SetAnimRate(c7v37, c7v38)
            end
          end
        end
      end
      c7v35 = IsNull
      c7v35 = c7v35(c7v16)
      if not c7v35 then
        c7v37 = 1
        c7v35 = #c7v16
        c7v36 = 1
        for __renovice_for_2_0 = c7v37, c7v35, c7v36 do
          c7v38 = _T.moverState
          if c7v38 == "FORWARD" then
            c7v38 = c7v16[__renovice_for_2_0]
            c7v38:Enable()
            continue
          end
          c7v38 = c7v16[__renovice_for_2_0]
          c7v38:Disable()
        end
      end
      c7v36 = beamType
      c7v35 = IsNull
      c7v35 = c7v35(c7v36)
      if not c7v35 then
        c7v37 = 1
        c7v35 = #c7v21
        c7v36 = 1
        for __renovice_for_3_0 = c7v37, c7v35, c7v36 do
          c7v39 = c7v21[__renovice_for_3_0]
          c7v39 = c7v39:DistanceToEntity(c7v0)
          c7v40 = retrievalPushRadius
          if not (c7v39 < c7v40) then
            c7v38 = false
          else
            c7v38 = true
          end
          c7v39 = c7v21[__renovice_for_3_0]
          c7v39 = c7v39:DamageControl()
          c7v40 = c7v21[__renovice_for_3_0]
          c7v40 = c7v40:GetHealth()
          c7v41 = c7v39:GetShield()
          c7v42 = c7v39:GetMaxShield()
          if ((c7v38 and c7v25) and c7v26) then
            c7v44 = c7v21[__renovice_for_3_0]
            c7v46 = beamType
            c7v43 = IsNull
            c7v43 = c7v43(c7v44:GetAttachment(c7v46))
            if not c7v43 then
              continue
            end
            c7v43 = c7v21[__renovice_for_3_0]
            c7v43 = c7v43:Name__7f7b27a9()
            if not c7v43 then
              continue
            end
            c7v44 = _T.gHitTrap
            c7v43 = IsNull
            c7v43 = c7v43(c7v44)
            if not c7v43 then
              continue
            end
            c7v43 = c7v21[__renovice_for_3_0]
            c7v45 = gLotusOperatorAvatarType
            c7v43 = c7v43:IsA(c7v45)
            if c7v43 then
              continue
            end
            c7v43 = c7v21[__renovice_for_3_0]
            c7v43 = c7v43:IsKilled()
            if c7v43 then
              continue
            end
            c7v43 = c7v21[__renovice_for_3_0]
            c7v43 = c7v43:IsPreDeath()
            if c7v43 then
              continue
            end
            repeat
              c7v43 = 0
              if not (c7v43 < c7v41) then
                if c7v42 ~= 0 then break end
                c7v43 = 0
                if not (c7v43 < c7v40) then break end
              end
              c7v45 = 0
              c7v43 = c7v39:Name__ccefdb4a(c7v45)
              c7v44 = c7v21[__renovice_for_3_0]
              c7v46 = beamType
              c7v44:Attach(c7v46, c7v43)
              c7v44 = c7v21[__renovice_for_3_0]
              c7v46 = avProjType
              c7v47 = EMPTY_SYMBOL
              c7v44:Attach(c7v46, c7v47)
            until true
          end
        end
      end
      c7v35 = Name__f49faa77
      c7v36 = 0
      if c7v36 < c7v35 then
        c7v35 = 0.2
        if c7v35 <= c7v3 then
          c7v35 = 0
          if c7v35 < c7v23 then
            c7v37 = 1
            c7v35 = #c7v21
            c7v36 = 1
            for __renovice_for_4_0 = c7v37, c7v35, c7v36 do
              c7v41 = Name__f49faa77
              c7v40 = c7v41 * 0.2
              c7v39 = c7v40 / c7v23
              c7v38 = c7v39 + c7v5
              c7v40 = 4 / c7v23
              c7v39 = c7v40 + c7v6
              c7v42 = 1
              c7v40 = math.max
              c7v38 = c7v40(c7v38, c7v42)
              c7v42 = 1
              c7v40 = math.max
              c7v39 = c7v40(c7v39, c7v42)
              c7v41 = c7v21[__renovice_for_4_0]
              c7v41 = c7v41:DistanceToEntity(c7v0)
              c7v42 = retrievalPushRadius
              if not (c7v41 < c7v42) then
                c7v40 = false
              else
                c7v40 = true
              end
              if ((c7v40 and c7v25) and c7v26) then
                c7v42 = _T.gHitTrap
                c7v41 = IsNull
                c7v41 = c7v41(c7v42)
                if not c7v41 then
                  continue
                end
                c7v41 = c7v21[__renovice_for_4_0]
                c7v43 = gLotusOperatorAvatarType
                c7v41 = c7v41:IsA(c7v43)
                if c7v41 then
                  continue
                end
                c7v41 = c7v21[__renovice_for_4_0]
                c7v41 = c7v41:DamageControl()
                c7v42 = c7v41:GetShield()
                c7v43 = c7v21[__renovice_for_4_0]
                c7v43 = c7v43:GetHealth()
                c7v44 = c7v41:GetMaxShield()
                c7v45 = 0
                if c7v45 < c7v42 then
                  c7v47 = math.floor
                  c7v47 = c7v47(c7v38)
                  c7v46 = c7v42 - c7v47
                  c7v47 = 0
                  c7v45 = math.max
                  c7v48 = c7v45(c7v46, c7v47)
                  c7v41:SetShield(c7v48)
                  c7v46 = math.floor
                  c7v46 = c7v46(c7v38)
                  c7v5 = c7v38 - c7v46
                end
                if c7v44 ~= 0 then
                  continue
                end
                c7v45 = 100
                if not (c7v45 < c7v43) then
                  continue
                end
                c7v47 = math.floor
                c7v47 = c7v47(c7v39)
                c7v46 = c7v43 - c7v47
                c7v47 = 0
                c7v45 = math.max
                c7v45 = c7v45(c7v46, c7v47)
                c7v46 = c7v21[__renovice_for_4_0]
                c7v46:SetHealth(c7v45)
                c7v46 = math.floor
                c7v46 = c7v46(c7v39)
                c7v6 = c7v39 - c7v46
              end
            end
            c7v3 = c7v3 - 0.2
          end
        end
      end
      c7v35 = Name__93fc1a44
      c7v36 = 0
      if c7v36 < c7v35 then
        c7v35 = 1
        if c7v35 < c7v4 then
          c7v37 = Name__93fc1a44
          c7v36 = c7v30 - c7v37
          c7v37 = 0
          c7v35 = math.max
          c7v38 = c7v35(c7v36, c7v37)
          c7v0:SetHealth(c7v38)
          c7v36 = v34
          if c7v36 then
            c7v36 = v34
            c7v36 = c7v36.ShowLostHealthMsg
            c7v38 = "-"
            c7v39 = Name__93fc1a44
            c7v37 = c7v38 .. c7v39
            c7v36(c7v37)
          end
          c7v4 = 0
        end
        c7v35 = Name__f3c503f8
        c7v35 = c7v35()
        c7v4 = c7v4 + c7v35
      end
      c7v35 = Name__f3c503f8
      c7v35 = c7v35()
      c7v1 = c7v1 + c7v35
      c7v35 = Name__f3c503f8
      c7v35 = c7v35()
      c7v2 = c7v2 + c7v35
      c7v35 = 0
      if c7v35 < c7v23 then
        c7v35 = Name__f3c503f8
        c7v35 = c7v35()
        c7v3 = c7v3 + c7v35
      end
      c7v35 = _T.moverState
      if c7v18 ~= c7v35 then
        c7v35 = print
        c7v37 = "Retrieval Mission: Movement Changed from "
        c7v39 = " to "
        c7v40 = _T.moverState
        c7v41 = " | Mover Delta: "
        c7v36 = c7v37 .. c7v18 .. c7v39 .. c7v40 .. c7v41 .. c7v28
        c7v35(c7v36)
      end
      c7v35 = 0.99
      if c7v35 < c7v28 then
        c7v35 = print
        c7v37 = "Retrieval Mission: Mover Delta near the end "
        c7v36 = c7v37 .. c7v28
        c7v35(c7v36)
      end
      c7v18 = _T.moverState
      c7v35 = Sleep
      c7v36 = 0
      c7v35(c7v36)
    end
    c7v21 = IsNull
    c7v21 = c7v21(c7v10)
    if not c7v21 then
      c7v21 = gGameRules
      c7v21 = c7v21:GetMissionType()
      c7v22 = 18
      if c7v21 ~= c7v22 then
        c7v23 = false
        c7v24 = true
        c7v10:SetVisibility(c7v23, c7v24)
        c7v10:Destroy()
      end
    end
    c7v21 = IsNull
    c7v21 = c7v21(c7v0)
    if not c7v21 then
      c7v21 = IsNull
      c7v21 = c7v21(c7v13)
      if not c7v21 then
        c7v13:Disable()
      end
      c7v21 = IsNull
      c7v21 = c7v21(c7v14)
      if not c7v21 then
        c7v14:Disable()
      end
      c7v21 = IsNull
      c7v21 = c7v21(c7v11)
      if not c7v21 then
        c7v11:Destroy()
      end
    end
    do return end
  end
  RetrievalAvatar = v39
  v39 = function(c8v0)
    local c8v1, c8v2, c8v3, c8v4
    local __renovice_local_0 = print
    c8v2 = "Retrieval Mission: "
    c8v3 = c8v0:GetFullName()
    c8v4 = " Mover Done"
    c8v1 = c8v2 .. c8v3 .. c8v4
    __renovice_local_0(c8v1)
    __renovice_local_0 = c8v0:GetTag()
    c8v1 = v15
    if __renovice_local_0 == c8v1 then
      __renovice_local_0 = v6
      __renovice_local_0 = __renovice_local_0.RemoveByElement
      c8v1 = v12
      __renovice_local_0(c8v1, c8v0)
    end
    __renovice_local_0 = c8v0:GetTag()
    c8v1 = v14
    if __renovice_local_0 == c8v1 then
      c8v2 = WeakResource
      c8v3 = "/Lotus/Types/Game/MarkerInfos/PayloadObjectiveMarkerInfo"
      __renovice_local_0 = c8v0:GetAttachment(c8v2(c8v3))
      c8v1 = IsNull
      c8v1 = c8v1(__renovice_local_0)
      if not c8v1 then
        __renovice_local_0:Disable()
      end
      c8v1 = _T
      c8v2 = true
      c8v1.retrievalComplete = c8v2
    end
    do return end
  end
  OnDone = v39
  v39 = function()
    local c9v0, c9v1, c9v2, c9v3, c9v4, c9v5, c9v6, c9v7, c9v8, c9v9, c9v10, c9v11, c9v12
    c9v0 = print
    c9v1 = "G3 spawn script started"
    c9v0(c9v1)
    c9v0 = gGameRules
    c9v2 = v21
    c9v0 = c9v0:GetNetPersistentVar(c9v2)
    if c9v0 ~= 0 then
      c9v0 = print
      c9v1 = "G3 already spawned, don't try and spawn again."
      c9v0(c9v1)
      do return end
    end
    c9v0 = gGameRules
    c9v0 = c9v0:GetMission()
    c9v1 = c9v0.vipAgent
    c9v2 = v28
    c9v2 = c9v2:GetMaxEnemyLevel()
    c9v4 = _T.gTestingRaidPerf
    c9v3 = IsNull
    c9v3 = c9v3(c9v4)
    if not c9v3 then
      c9v3 = _T.gTestingRaidPerf
      if c9v3 then
        c9v4 = perfSpawns
        c9v3 = #c9v4
        c9v4 = 0
        if c9v4 < c9v3 then
          c9v4 = gRegion
          c9v6 = Symbol
          c9v7 = "RaidBossSpawn"
          c9v4 = c9v4:FindTagged(c9v6(c9v7))
          c9v3 = c9v4[1]
          c9v6 = Symbol
          c9v3:SetTag(c9v6())
          c9v5 = c9v3:GetSpawnPoints()
          c9v4 = c9v5[1]
          c9v7 = Symbol
          c9v4:SetTag(c9v7())
          c9v5 = gRegion
          c9v7 = Symbol
          c9v8 = "G3Spawn"
          c9v5 = c9v5:FindTagged(c9v7(c9v8))
          c9v6 = c9v5[1]
          c9v8 = Symbol
          c9v6:SetTag(c9v8())
          c9v6 = c9v5[2]
          c9v8 = Symbol
          c9v6:SetTag(c9v8())
          c9v6 = c9v5[3]
          c9v8 = Symbol
          c9v6:SetTag(c9v8())
          c9v6 = perfSpawns[1]
          c9v8 = Symbol
          c9v9 = "RaidBossSpawn"
          c9v6:SetTag(c9v8(c9v9))
          c9v7 = perfSpawns[1]
          c9v7 = c9v7:GetSpawnPoints()
          c9v6 = c9v7[1]
          c9v8 = Symbol
          c9v9 = "HekSpawn"
          c9v6:SetTag(c9v8(c9v9))
          c9v8 = 2
          c9v6 = 4
          c9v7 = 1
          for __renovice_for_0_0 = c9v8, c9v6, c9v7 do
            c9v9 = perfSpawns[__renovice_for_0_0]
            c9v11 = Symbol
            c9v12 = "G3Spawn"
            c9v9:SetTag(c9v11(c9v12))
          end
        end
      end
    end
    c9v3 = IsNull
    c9v3 = c9v3(c9v1)
    if not c9v3 then
      c9v3 = print
      c9v4 = "Trying to spawn G3"
      c9v3(c9v4)
      c9v3 = Type
      c9v3 = c9v3(c9v1)
      c9v5 = gRegion
      c9v7 = Symbol
      c9v8 = "RaidBossSpawn"
      c9v5 = c9v5:FindTagged(c9v7(c9v8))
      c9v4 = c9v5[1]
      c9v5 = IsNull
      c9v5 = c9v5(c9v4)
      if c9v5 then
        c9v5 = print
        c9v6 = "The spawncontrol was null!"
        c9v5(c9v6)
      else
        c9v5 = print
        c9v6 = "Found spawncontrol for G3"
        c9v5(c9v6)
        c9v4:Name__1760c74f(c9v3)
        c9v4:Name__5db0ecd0(c9v2)
        c9v4:SpawnAgent()
      end
      c9v5 = Sleep
      c9v6 = 0.1
      c9v5(c9v6)
      c9v5 = WeakResource
      c9v6 = "/Lotus/Types/Enemies/Grineer/DeathSquad/Avatars/DeathSquadFullRaidAvatar"
      c9v5 = c9v5(c9v6)
      c9v6 = gRegion
      c9v6 = c9v6:FindAll(c9v5)
      c9v7 = IsNull
      c9v7 = c9v7(c9v6)
      if c9v7 then
        c9v7 = print
        c9v8 = "Can't find the death squad avatar!"
        c9v7(c9v8)
      else
        c9v7 = print
        c9v8 = "The Death squad avatar was spawned!"
        c9v7(c9v8)
      end
      c9v7 = gRegion
      c9v9 = v13
      c9v7 = c9v7:FindFirstTagged(c9v9)
      c9v8 = gGameRules
      c9v10 = "The Grustrag Three"
      c9v8:AddRaidProgressTag(c9v10)
      c9v8 = IsNull
      c9v8 = c9v8(c9v7)
      if not c9v8 then
        c9v10 = true
        c9v7:Name__33e52783(c9v10)
        do return end
      end
    else
      c9v3 = print
      c9v4 = "The VIPSpawn was null!"
      c9v3(c9v4)
    end
    do return end
  end
  SpawnDeathSquad = v39
  v39 = function()
    local c10v0, c10v1, c10v2, c10v3, c10v4, c10v5, c10v6, c10v7
    c10v1 = moverDoor
    c10v0 = IsNull
    c10v0 = c10v0(c10v1)
    if not c10v0 then
      c10v0 = moverDoor
      c10v2 = Lotus_Game.EMISSIVE_TINT_COLOR
      c10v4 = unlockedTint.red
      c10v3 = c10v4 / 255
      c10v5 = unlockedTint.green
      c10v4 = c10v5 / 255
      c10v6 = unlockedTint.blue
      c10v5 = c10v6 / 255
      c10v7 = unlockedTint.alpha
      c10v6 = c10v7 / 255
      c10v0:SetMaterialParam(c10v2, c10v3, c10v4, c10v5, c10v6)
    end
    c10v1 = doorFrameA
    c10v0 = IsNull
    c10v0 = c10v0(c10v1)
    if not c10v0 then
      c10v0 = doorFrameA
      c10v2 = Lotus_Game.EMISSIVE_TINT_COLOR
      c10v4 = unlockedTint.red
      c10v3 = c10v4 / 255
      c10v5 = unlockedTint.green
      c10v4 = c10v5 / 255
      c10v6 = unlockedTint.blue
      c10v5 = c10v6 / 255
      c10v7 = unlockedTint.alpha
      c10v6 = c10v7 / 255
      c10v0:SetMaterialParam(c10v2, c10v3, c10v4, c10v5, c10v6)
    end
    do return end
  end
  PayloadDoor = v39
  v39 = {}
  v40 = function()
    local c11v0
    c11v0 = gRegion
    c11v0 = c11v0:GetHumanPlayers()
    v39 = c11v0
    do return end
  end
  OnPlayersChanged = v40
  v40 = function()
    local c12v0, c12v1, c12v2, c12v3, c12v4, c12v5, c12v6, c12v7, c12v8, c12v9, c12v10, c12v11, c12v12, c12v13, c12v14, c12v15, c12v16, c12v17, c12v18, c12v19, c12v20, c12v21, c12v22, c12v23, c12v24, c12v25, c12v26, c12v27, c12v28, c12v29, c12v30, c12v31, c12v32
    c12v0 = gRegion
    c12v2 = "OnPlayersChanged"
    c12v0:Name__cd2a30ea(c12v2)
    c12v0 = gRegion
    c12v0 = c12v0:GetHumanPlayers()
    v39 = c12v0
    c12v0 = Sleep
    c12v1 = 1
    c12v0(c12v1)
    c12v1 = _T.RaidPuzzleComplete
    c12v0 = IsNull
    c12v0 = c12v0(c12v1)
    if not c12v0 then
      while true do
        c12v0 = _T.RaidPuzzleComplete
        if c12v0 then break end
        c12v0 = Sleep
        c12v1 = 0
        c12v0(c12v1)
      end
    end
    c12v0 = gGameRules
    c12v0 = c12v0:GetMissionType()
    c12v1 = v10
    c12v1 = c12v1.SetupMissionTransmissionSet
    c12v2 = transmissionSet
    c12v1(c12v2)
    c12v1 = gPromotedToHost
    if not c12v1 then
      c12v1 = 18
      if c12v0 ~= c12v1 then
        c12v1 = v10
        c12v1 = c12v1.PlayGlobalTransmission
        c12v2 = _T.MissionTransmissionSet
        c12v3 = Symbol
        c12v4 = "ObjectiveStart"
        c12v1(c12v2, c12v3(c12v4))
        c12v1 = v11
        c12v1 = c12v1.SetPrimaryObjText
        c12v3 = hijackTargetText
        c12v2 = tostring
        c12v2 = c12v2(c12v3)
        c12v1(c12v2)
      end
    end
    c12v1 = gPromotedToHost
    if not c12v1 then
      c12v2 = startSwitch
      c12v1 = IsNull
      c12v1 = c12v1(c12v2)
      if not c12v1 then
        c12v1 = startSwitch
        c12v1:Enable()
      end
    end
    c12v1 = Sleep
    c12v2 = 1
    c12v1(c12v2)
    c12v1 = gRegion
    c12v3 = v13
    c12v1 = c12v1:FindTagged(c12v3)
    c12v3 = gRegion
    c12v5 = v14
    c12v3 = c12v3:FindTagged(c12v5)
    c12v2 = c12v3[1]
    c12v3 = gRegion
    c12v5 = v15
    c12v3 = c12v3:FindTagged(c12v5)
    v12 = c12v3
    c12v3 = gRegion
    c12v5 = v16
    c12v3 = c12v3:FindTagged(c12v5)
    c12v4 = gRegion
    c12v6 = v17
    c12v4 = c12v4:FindTagged(c12v6)
    c12v5 = gGameRules
    c12v5 = c12v5:IsNightmareMode()
    c12v7 = gGameRules
    c12v7 = c12v7:GetMission()
    c12v7 = c12v7.sortieId
    if c12v7 == "" then
      c12v6 = false
    else
      c12v6 = true
    end
    c12v7 = 0
    c12v8 = 0
    c12v9 = 0
    c12v10 = 0
    c12v11 = 0
    c12v12 = 0
    c12v15 = 1
    c12v16 = v12
    c12v13 = #c12v16
    c12v14 = 1
    for __renovice_for_0_0 = c12v15, c12v13, c12v14 do
      c12v16 = ObjectPortHandler
      c12v17 = v12[__renovice_for_0_0]
      c12v18 = "OnDone"
      c12v16(c12v17, c12v18)
    end
    c12v13 = ObjectPortHandler
    c12v15 = "OnDone"
    c12v13(c12v2, c12v15)
    if c12v5 then
      c12v15 = 1
      c12v13 = #c12v3
      c12v14 = 1
      for __renovice_for_1_0 = c12v15, c12v13, c12v14 do
        c12v16 = c12v3[__renovice_for_1_0]
        c12v16:Disable()
      end
    end
    c12v13 = v28
    c12v15 = true
    c12v13:Enable(c12v15)
    c12v13 = v28
    c12v13:SetObjective(c12v2)
    c12v13 = print
    c12v14 = "Retrieval Mission: Initialization Completed. Waiting for Avatar to spawn"
    c12v13(c12v14)
    while true do
      c12v13 = IsNull
      c12v13 = c12v13(c12v1)
      if not c12v13 then break end
      c12v13 = gRegion
      c12v15 = v13
      c12v1 = c12v13:FindTagged(c12v15)
      c12v13 = 75
      if c12v13 < c12v9 then
        c12v13 = v10
        c12v13 = c12v13.PlayGlobalTransmission
        c12v14 = _T.MissionTransmissionSet
        c12v15 = Symbol
        c12v16 = "BossTaunt"
        c12v13(c12v14, c12v15(c12v16))
        c12v9 = 0
      end
      c12v13 = DeltaTime
      c12v13 = c12v13()
      c12v9 = c12v9 + c12v13
      c12v13 = Sleep
      c12v14 = 0
      c12v13(c12v14)
    end
    c12v13 = print
    c12v14 = "Retrieval Mission: Avatar Spawned and found"
    c12v13(c12v14)
    c12v13 = gGameRules
    c12v15 = true
    c12v13:HideGameSession(c12v15)
    if not c12v6 then
      if c12v5 then
        c12v13 = v10
        c12v13 = c12v13.PlayGlobalTransmission
        c12v14 = _T.MissionTransmissionSet
        c12v15 = Symbol
        c12v16 = "BossCoreStolenNightmare"
        c12v13(c12v14, c12v15(c12v16))
      else
        c12v13 = v10
        c12v13 = c12v13.PlayGlobalTransmission
        c12v14 = _T.MissionTransmissionSet
        c12v15 = Symbol
        c12v16 = "BossCoreStolen"
        c12v13(c12v14, c12v15(c12v16))
      end
    end
    c12v13 = Sleep
    c12v14 = 0.5
    c12v13(c12v14)
    c12v13 = v11
    c12v13 = c12v13.SetPrimaryObjText
    c12v15 = defendTargetText
    c12v14 = tostring
    c12v14 = c12v14(c12v15)
    c12v15 = 5
    c12v13(c12v14, c12v15)
    c12v13 = gRegion
    c12v15 = Symbol
    c12v16 = "ExitMarker"
    c12v13 = c12v13:FindFirstTagged(c12v15(c12v16))
    c12v14 = IsNull
    c12v14 = c12v14(c12v13)
    if not c12v14 then
      c12v14 = v28
      c12v14:SetObjective(c12v13)
    end
    c12v14 = v28
    c12v14:Name__f1362431()
    c12v14 = v28
    c12v16 = 20
    c12v17 = 150
    c12v18 = 0
    c12v19 = 3
    c12v20 = true
    c12v21 = false
    c12v22 = true
    c12v23 = false
    c12v14:Name__fb8a0817(c12v16, c12v17, c12v18, c12v19, c12v20, c12v21, c12v22, c12v23)
    c12v14 = v28
    c12v16 = true
    c12v14:Name__a920a795(c12v16)
    c12v14 = v28
    c12v16 = true
    c12v14:SetLevelAlert(c12v16)
    c12v14 = v35
    c12v14()
    c12v14 = gGameRules
    c12v14 = c12v14:GetMissionType()
    c12v15 = 18
    if c12v14 == c12v15 then
      c12v14 = v7
      c12v14 = c12v14.Ternary
      c12v15 = gGameRules
      c12v15 = c12v15:IsNightmareMode()
      c12v16 = 60
      c12v17 = 30
      c12v14 = c12v14(c12v15, c12v16, c12v17)
      Name__f49faa77 = c12v14
    end
    c12v1 = c12v1[1]
    c12v14 = gGameRules
    c12v14 = c12v14:GetMission()
    c12v14 = c12v14.sortieId
    if c12v14 ~= "" then
      c12v16 = v33
      c12v14 = c12v1:IsA(c12v16)
      if c12v14 then
        c12v16 = v31
        c12v17 = EMPTY_SYMBOL
        c12v1:Attach(c12v16, c12v17)
      else
        c12v16 = v32
        c12v17 = EMPTY_SYMBOL
        c12v18 = Vector
        c12v19 = 0
        c12v20 = 1.75
        c12v21 = 0
        c12v1:Attach(c12v16, c12v17, c12v18(c12v19, c12v20, c12v21))
      end
    end
    c12v14 = gPromotedToHost
    if not c12v14 then
      c12v14 = gGameRules
      c12v14 = c12v14:GetMission()
      c12v15 = c12v14.tier
      c12v16 = 0
      if c12v16 < c12v15 then
        c12v15 = v28
        c12v15 = c12v15:GetMaxEnemyLevel()
        c12v17 = v5
        c12v18 = c12v15 ^ 0.36
        c12v16 = c12v17 * c12v18
        v5 = c12v16
      end
      c12v15 = v7
      c12v15 = c12v15.Ternary
      c12v17 = c12v14.goalId
      if c12v17 ~= "" then
        c12v16 = false
      else
        c12v16 = true
      end
      c12v17 = v5
      c12v18 = 3000
      c12v15 = c12v15(c12v16, c12v17, c12v18)
      c12v18 = c12v15
      c12v19 = true
      c12v1:SetMaxHealth(c12v18, c12v19)
      c12v19 = true
      c12v1:SetHealth(c12v15, c12v19)
    end
    c12v14 = false
    c12v15 = false
    c12v16 = false
    c12v17 = false
    c12v18 = false
    c12v19 = false
    c12v20 = true
    c12v21 = true
    c12v22 = v10
    c12v22 = c12v22.PlayGlobalTransmission
    c12v23 = _T.MissionTransmissionSet
    c12v24 = Symbol
    local __renovice_local_0 = "ConsoleActivated"
    c12v22(c12v23, c12v24(__renovice_local_0))
    c12v22 = Sleep
    c12v23 = 1
    c12v22(c12v23)
    if c12v5 then
      c12v22 = v10
      c12v22 = c12v22.PlayGlobalTransmission
      c12v23 = _T.MissionTransmissionSet
      c12v24 = Symbol
      __renovice_local_0 = "NightmareHackDoor"
      c12v22(c12v23, c12v24(__renovice_local_0))
      c12v22 = Sleep
      c12v23 = 1
      c12v22(c12v23)
      c12v22 = v10
      c12v22 = c12v22.PlayGlobalTransmission
      c12v23 = _T.MissionTransmissionSet
      c12v24 = Symbol
      __renovice_local_0 = "NightmareMines"
      c12v22(c12v23, c12v24(__renovice_local_0))
      c12v24 = 1
      c12v22 = #c12v4
      c12v23 = 1
      for __renovice_for_2_0 = c12v24, c12v22, c12v23 do
        __renovice_local_0 = c12v4[__renovice_for_2_0]
        __renovice_local_0:Enable()
      end
    end
    c12v22 = print
    c12v23 = "Retrieval Mission: Pre-Mission Update"
    c12v22(c12v23)
    c12v22 = nil
    c12v23 = gGameRules
    __renovice_local_0 = v24
    c12v25 = 1
    c12v23:SetNetPersistentVar(__renovice_local_0, c12v25)
    while true do
      c12v23 = IsNull
      c12v23 = c12v23(c12v1)
      if c12v23 then break end
      c12v23 = c12v1:GetHealth()
      c12v24 = 0
      if not (c12v24 < c12v23) then break end
      c12v23 = _T.retrievalComplete
      if c12v23 then break end
      c12v23 = c12v1:GetHealthPercentage()
      c12v24 = c12v2:GetDelta()
      c12v25 = intensityDeltas
      __renovice_local_0 = #c12v25
      c12v25 = 0
      if c12v25 < __renovice_local_0 then
        __renovice_local_0 = intensityDeltas[1]
        if __renovice_local_0 < c12v24 then
          __renovice_local_0 = v28
          c12v26 = true
          __renovice_local_0:ResetIntensity(c12v26)
          __renovice_local_0 = table.remove
          c12v25 = intensityDeltas
          c12v26 = 1
          __renovice_local_0(c12v25, c12v26)
        end
      end
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c12v22)
      if __renovice_local_0 then
        __renovice_local_0 = ipairs
        c12v25 = v39
        __renovice_local_0, c12v25, c12v26 = __renovice_local_0(c12v25)
        for __renovice_for_3_0, __renovice_for_3_1 in __renovice_local_0, c12v25, c12v26 do
          c12v29 = __renovice_for_3_1:GetAvatar()
          c12v30 = IsNull
          c12v30 = c12v30(c12v29)
          if c12v30 then
            continue
          end
          c12v30 = c12v29:DistanceToEntity(c12v1)
          c12v31 = 15
          if not (c12v30 < c12v31) then
            continue
          end
          c12v22 = c12v29
          c12v30 = v28
          c12v30:Name__f05f0d69(c12v22)
          break
        end
      else
        __renovice_local_0 = c12v22:DistanceToEntity(c12v1)
        c12v25 = 25
        if c12v25 < __renovice_local_0 then
          c12v22 = nil
          __renovice_local_0 = v28
          __renovice_local_0:Name__f05f0d69(c12v22)
        end
      end
      __renovice_local_0 = 0.25
      if (c12v23 < __renovice_local_0 and not c12v16) then
        __renovice_local_0 = v10
        __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
        c12v25 = _T.MissionTransmissionSet
        c12v26 = Symbol
        c12v27 = "DamagedCritical"
        __renovice_local_0(c12v25, c12v26(c12v27))
        c12v16 = true
      else
        __renovice_local_0 = 0.5
        if (c12v23 < __renovice_local_0 and not c12v15) then
          __renovice_local_0 = v10
          __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
          c12v25 = _T.MissionTransmissionSet
          c12v26 = Symbol
          c12v27 = "DamagedMedium"
          __renovice_local_0(c12v25, c12v26(c12v27))
          c12v15 = true
        else
          __renovice_local_0 = 0.75
          if (c12v23 < __renovice_local_0 and not c12v14) then
            __renovice_local_0 = v10
            __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
            c12v25 = _T.MissionTransmissionSet
            c12v26 = Symbol
            c12v27 = "DamagedLight"
            __renovice_local_0(c12v25, c12v26(c12v27))
            c12v14 = true
          end
        end
      end
      __renovice_local_0 = v4[1]
      if (__renovice_local_0 < c12v24 and not c12v17) then
        __renovice_local_0 = v10
        __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
        c12v25 = _T.MissionTransmissionSet
        c12v26 = Symbol
        c12v27 = "CheckpointA"
        __renovice_local_0(c12v25, c12v26(c12v27))
        c12v17 = true
      else
        __renovice_local_0 = v4[2]
        if (__renovice_local_0 < c12v24 and not c12v18) then
          __renovice_local_0 = v10
          __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
          c12v25 = _T.MissionTransmissionSet
          c12v26 = Symbol
          c12v27 = "CheckpointB"
          __renovice_local_0(c12v25, c12v26(c12v27))
          c12v18 = true
        else
          __renovice_local_0 = v4[3]
          if (__renovice_local_0 < c12v24 and not c12v19) then
            __renovice_local_0 = v10
            __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
            c12v25 = _T.MissionTransmissionSet
            c12v26 = Symbol
            c12v27 = "CheckpointC"
            __renovice_local_0(c12v25, c12v26(c12v27))
            c12v19 = true
          end
        end
      end
      repeat
        if c12v21 then
          __renovice_local_0 = _T.moverState
          if __renovice_local_0 == "BACKWARD" then
            __renovice_local_0 = v10
            __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
            c12v25 = _T.MissionTransmissionSet
            c12v26 = Symbol
            c12v27 = "CoreRetreat"
            __renovice_local_0(c12v25, c12v26(c12v27))
            c12v11 = 0
            c12v21 = false
            break
          end
        end
        repeat
          if c12v20 then
            __renovice_local_0 = _T.moverState
            if __renovice_local_0 == "STOPPED" then
              __renovice_local_0 = v10
              __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
              c12v25 = _T.MissionTransmissionSet
              c12v26 = Symbol
              c12v27 = "CoreStopped"
              __renovice_local_0(c12v25, c12v26(c12v27))
              c12v12 = 0
              c12v20 = false
              break
            end
          end
          __renovice_local_0 = _T.moverState
          if __renovice_local_0 == "FORWARD" then
            __renovice_local_0 = Sleep
            c12v25 = 0
            __renovice_local_0(c12v25)
          end
        until true
      until true
      __renovice_local_0 = _T.shouldPlayNightmareHackDoor
      if __renovice_local_0 then
        __renovice_local_0 = v10
        __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
        c12v25 = _T.MissionTransmissionSet
        c12v26 = Symbol
        c12v27 = "NightmareHackDoor"
        __renovice_local_0(c12v25, c12v26(c12v27))
        __renovice_local_0 = _T
        c12v25 = false
        __renovice_local_0.shouldPlayNightmareHackDoor = c12v25
      end
      __renovice_local_0 = 10
      if __renovice_local_0 < c12v11 then
        c12v21 = true
      end
      __renovice_local_0 = 10
      if __renovice_local_0 < c12v12 then
        c12v20 = true
      end
      __renovice_local_0 = 75
      if __renovice_local_0 < c12v10 then
        if not c12v6 then
          __renovice_local_0 = RandomInt
          c12v25 = 0
          c12v26 = 1
          __renovice_local_0 = __renovice_local_0(c12v25, c12v26)
          if __renovice_local_0 == 0 then
            __renovice_local_0 = v10
            __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
            c12v25 = _T.MissionTransmissionSet
            c12v26 = Symbol
            c12v27 = "BossStopThem"
            __renovice_local_0(c12v25, c12v26(c12v27))
          else
            __renovice_local_0 = v10
            __renovice_local_0 = __renovice_local_0.PlayGlobalTransmission
            c12v25 = _T.MissionTransmissionSet
            c12v26 = Symbol
            c12v27 = "BossTaunt"
            __renovice_local_0(c12v25, c12v26(c12v27))
          end
        end
        c12v10 = 0
      end
      __renovice_local_0 = Name__f3c503f8
      __renovice_local_0 = __renovice_local_0()
      c12v10 = c12v10 + __renovice_local_0
      __renovice_local_0 = Name__f3c503f8
      __renovice_local_0 = __renovice_local_0()
      c12v11 = c12v11 + __renovice_local_0
      __renovice_local_0 = Name__f3c503f8
      __renovice_local_0 = __renovice_local_0()
      c12v12 = c12v12 + __renovice_local_0
      __renovice_local_0 = Name__f3c503f8
      __renovice_local_0 = __renovice_local_0()
      c12v8 = c12v8 + __renovice_local_0
      __renovice_local_0 = Name__f3c503f8
      __renovice_local_0 = __renovice_local_0()
      c12v7 = c12v7 + __renovice_local_0
      __renovice_local_0 = Sleep
      c12v25 = 0
      __renovice_local_0(c12v25)
      __renovice_local_0 = v28
      __renovice_local_0:Name__09354ea7()
    end
    c12v23 = print
    c12v24 = "Retrieval Mission: End Mission Detected"
    c12v23(c12v24)
    c12v23 = _T.retrievalComplete
    c12v24 = _T.RetrievalEndMissionOverride
    if c12v24 then
      c12v24 = _T.RetrievalEndMissionOverride
      c12v24(c12v23)
      do return end
    end
    c12v24 = gGameRules
    c12v24 = c12v24:GetMission()
    __renovice_local_0 = c12v24.vipAgent
    if c12v23 then
      c12v26 = gRegion
      c12v28 = Symbol
      c12v29 = "RetrievalDialog"
      c12v26 = c12v26:FindTagged(c12v28(c12v29))
      c12v25 = c12v26[1]
      c12v27 = gRegion
      c12v29 = Symbol
      c12v30 = "AchievementTrigger"
      c12v27 = c12v27:FindTagged(c12v29(c12v30))
      c12v26 = c12v27[1]
      c12v29 = "Execute"
      c12v26:FirePort(c12v29)
      c12v27 = IsNull
      c12v27 = c12v27(__renovice_local_0)
      if c12v27 then
        c12v27 = gRegion
        c12v29 = Symbol
        c12v30 = "HijackCinematic"
        c12v27 = c12v27:FindFirstTagged(c12v29(c12v30))
        c12v28 = IsNull
        c12v28 = c12v28(c12v27)
        if not c12v28 then
          c12v30 = "StartPlaying"
          c12v27:FirePort(c12v30)
        end
      else
        c12v28 = gRegion
        c12v30 = Symbol
        c12v31 = "HijackRaidCinematic"
        c12v28 = c12v28:FindTagged(c12v30(c12v31))
        c12v27 = c12v28[1]
        c12v28 = v10
        c12v28 = c12v28.PlayGlobalTransmission
        c12v29 = _T.MissionTransmissionSet
        c12v30 = Symbol
        c12v31 = "RaidSuccess"
        c12v28(c12v29, c12v30(c12v31))
        c12v28 = gGameRules
        c12v30 = "Fomorian Core Extraction"
        c12v28:AddRaidProgressTag(c12v30)
        c12v28 = Sleep
        c12v29 = 5
        c12v28(c12v29)
        c12v30 = "StartPlaying"
        c12v27:FirePort(c12v30)
        c12v28 = gRegion
        c12v30 = Symbol
        c12v31 = "PayloadAttachedDeco"
        c12v28 = c12v28:FindFirstTagged(c12v30(c12v31))
        c12v29 = IsNull
        c12v29 = c12v29(c12v28)
        if not c12v29 then
          c12v31 = false
          c12v32 = true
          c12v28:SetVisibility(c12v31, c12v32)
          c12v28:Destroy()
        end
      end
      c12v27 = 0
      c12v28 = IsNull
      c12v28 = c12v28(c12v1)
      if not c12v28 then
        c12v27 = c12v1:GetHealth()
        c12v1:Destroy()
      end
      c12v28 = 0
      if c12v5 == true then
        c12v30 = c12v27 / 3.33
        c12v29 = math.floor
        c12v28 = c12v29(c12v30)
      else
        c12v30 = c12v27 / 10
        c12v29 = math.floor
        c12v28 = c12v29(c12v30)
      end
      c12v31 = 0
      c12v29 = math.max
      c12v28 = c12v29(c12v28, c12v31)
      c12v29 = gGameRules
      c12v29 = c12v29:GetMissionType()
      c12v30 = 18
      if c12v29 ~= c12v30 then
        c12v29 = gGameRules
        c12v31 = v22
        c12v29:SetNetPersistentVar(c12v31, c12v28)
      end
      c12v29 = Sleep
      c12v30 = 4
      c12v29(c12v30)
      c12v29 = IsNull
      c12v29 = c12v29(__renovice_local_0)
      if c12v29 then
        c12v31 = "Open"
        c12v25:FirePort(c12v31)
        do return end
      end
    else
      c12v25 = IsNull
      c12v25 = c12v25(c12v1)
      if not c12v25 then
        c12v1:Destroy()
      end
      c12v25 = v10
      c12v25 = c12v25.PlayGlobalTransmission
      c12v26 = _T.MissionTransmissionSet
      c12v27 = Symbol
      c12v28 = "MissionFailed"
      c12v25(c12v26, c12v27(c12v28))
      c12v25 = Sleep
      c12v26 = 1
      c12v25(c12v26)
      c12v25 = gGameRules
      c12v27 = 0
      c12v28 = 0
      c12v25:EndGame(c12v27, c12v28)
    end
    do return end
  end
  Retrieval = v40
  v40 = function()
    local c13v0, c13v1, c13v2, c13v3, c13v4, c13v5
    c13v0 = gGameRules
    c13v2 = v23
    c13v3 = 2
    c13v0 = c13v0:GetNetPersistentVar(c13v2, c13v3)
    if c13v0 == 0 then
      c13v1 = gRegion
      c13v1 = c13v1:GetLocalPlayer()
      c13v2 = IsNull
      c13v2 = c13v2(c13v1)
      if not c13v2 then
        c13v2 = gChallengeMgr
        c13v4 = Symbol
        c13v5 = "MISSION_PERFECT_RETRIEVAL"
        c13v2:NotifyTag(c13v1, c13v4(c13v5))
      end
    end
    do return end
  end
  CheckAchievements = v40
  v40 = function()
    local c14v0, c14v1, c14v2, c14v3, c14v4, c14v5, c14v6, c14v7, c14v8, c14v9, c14v10, c14v11, c14v12, c14v13, c14v14
    while true do
      c14v1 = gGameRules
      c14v0 = IsNull
      c14v0 = c14v0(c14v1)
      if not c14v0 then break end
      c14v0 = Sleep
      c14v1 = 0.1
      c14v0(c14v1)
    end
    c14v0 = gGameRules
    c14v0 = c14v0:Name__41b79d13()
    if c14v0 == nil then
      do return end
    end
    c14v1 = Sleep
    c14v2 = 1
    c14v1(c14v2)
    while true do
      c14v2 = gRegion
      c14v1 = IsNull
      c14v1 = c14v1(c14v2:GetLocalPlayerAvatar())
      if not c14v1 then
        c14v2 = gRegion
        c14v1 = IsNull
        c14v1 = c14v1(c14v2:GetLocalPlayer())
        if not c14v1 then break end
      end
      c14v1 = Sleep
      c14v2 = 0
      c14v1(c14v2)
    end
    c14v1 = gRegion
    c14v1 = c14v1:GetLocalPlayer()
    c14v2 = gRegion
    c14v2 = c14v2:GetLocalPlayerAvatar()
    c14v3 = c14v1:GetMiniMap()
    c14v4 = gRegion
    c14v6 = v20
    c14v4 = c14v4:FindTagged(c14v6)
    c14v5 = nil
    while true do
      c14v6 = IsNull
      c14v6 = c14v6(c14v5)
      if not c14v6 then break end
      c14v6 = gRegion
      c14v8 = v13
      c14v5 = c14v6:FindTagged(c14v8)
      c14v6 = Sleep
      c14v7 = 0
      c14v6(c14v7)
    end
    c14v5 = c14v5[1]
    c14v6 = IsNull
    c14v6 = c14v6(c14v3)
    if not c14v6 then
      c14v8 = false
      c14v3:Name__34319118(c14v8)
    end
    c14v6 = 0
    c14v7 = gGameRules
    c14v7 = c14v7:IsNightmareMode()
    while true do
      c14v8 = _T.retrievalComplete
      if c14v8 then break end
      c14v8 = IsNull
      c14v8 = c14v8(c14v5)
      if c14v8 then break end
      c14v8 = IsNull
      c14v8 = c14v8(c14v2)
      if not c14v8 then
        c14v8 = c14v2:GetPosition()
        c14v9 = c14v5:GetPosition()
        c14v10 = c14v2:DamageControl()
        c14v10 = c14v10:GetShield()
        c14v11 = 0
        if c14v10 <= c14v11 then
          c14v10 = Distance
          c14v10 = c14v10(c14v8, c14v9)
          c14v11 = retrievalPushRadius
          if c14v10 < c14v11 then
            c14v10 = Sleep
            c14v11 = 0
            c14v10(c14v11)
          end
        end
      else
        c14v8 = gRegion
        c14v2 = c14v8:GetLocalPlayerAvatar()
      end
      if c14v7 then
        c14v8 = IsNull
        c14v8 = c14v8(c14v5)
        if not c14v8 then
          c14v8 = #c14v4
          c14v9 = 0
          if c14v9 < c14v8 then
            c14v8 = v36
            c14v8 = c14v8(c14v4, c14v5:GetPosition())
            c14v9 = c14v8:IsEnabled()
            if not c14v9 then
              c14v9 = c14v8:DistanceToEntity(c14v5)
              c14v10 = 30
              if c14v9 < c14v10 then
                c14v9 = _T
                c14v10 = true
                c14v9.shouldPlayNightmareHackDoor = c14v10
                c14v8:Enable()
                c14v9 = v6
                c14v9 = c14v9.RemoveByElement
                c14v9(c14v4, c14v8)
              end
            end
          end
        end
      end
      c14v8 = Name__f3c503f8
      c14v8 = c14v8()
      c14v6 = c14v6 + c14v8
      c14v8 = Sleep
      c14v9 = 0
      c14v8(c14v9)
    end
    c14v8 = IsNull
    c14v8 = c14v8(c14v1)
    if c14v8 then
      do return end
    end
    c14v8 = IsNull
    c14v8 = c14v8(c14v5)
    if c14v8 then
      c14v8 = _T.retrievalComplete
      if not c14v8 then
        c14v8 = gGameRules
        c14v8 = c14v8:GetMissionType()
        c14v9 = 18
        if c14v8 ~= c14v9 then
          c14v8 = gRegion
          c14v10 = coreRumbleSound
          c14v11 = Vector
          c14v11 = c14v11()
          c14v12 = false
          c14v8:PlaySound(c14v10, c14v11, c14v12)
          c14v8 = v9
          c14v8 = c14v8.AvatarFade
          c14v10 = 0
          c14v11 = -1
          c14v12 = 4.5
          c14v13 = 0
          c14v14 = 6
          c14v8(c14v2, c14v10, c14v11, c14v12, c14v13, c14v14)
        end
      end
    end
    c14v8 = IsNull
    c14v8 = c14v8(c14v3)
    if not c14v8 then
      c14v10 = true
      c14v3:Name__34319118(c14v10)
    end
    do return end
  end
  RetrievalHud = v40
  v40 = function(c15v0)
    local c15v1, c15v2, c15v3, c15v4, c15v5, c15v6, c15v7, c15v8, c15v9, c15v10, c15v11, c15v12, c15v13, c15v14
    c15v1 = Sleep
    c15v2 = 20
    c15v1(c15v2)
    c15v1 = gGameRules
    c15v1 = c15v1:IsNightmareMode()
    c15v2 = IsNull
    c15v2 = c15v2(c15v0)
    if (c15v2 or c15v1 == false) then
      do return end
    end
    c15v2 = RandomInt
    c15v3 = 3
    c15v4 = 8
    c15v2 = c15v2(c15v3, c15v4)
    c15v3 = Random
    c15v4 = 0.015
    c15v5 = 0.025
    c15v3 = c15v3(c15v4, c15v5)
    c15v4 = 1 / c15v2
    c15v5 = c15v3 + c15v4
    c15v8 = 1
    c15v6 = c15v2
    c15v7 = 1
    for __renovice_for_0_0 = c15v8, c15v6, c15v7 do
      c15v11 = c15v5 * 175
      c15v9 = c15v0:Name__9ae7e882(c15v11)
      c15v12 = c15v5 * 175
      c15v10 = c15v0:Name__90f19823(c15v12)
      c15v12 = c15v10.bank
      c15v11 = c15v12 - 180
      c15v10.bank = c15v11
      c15v12 = c15v9.y
      c15v11 = c15v12 + 0.35
      c15v9.y = c15v11
      c15v11 = gRegion
      c15v13 = MineType
      c15v11:CreateEntity(c15v13, c15v9, c15v10)
      c15v11 = c15v5 + c15v4
      c15v12 = Random
      c15v13 = -0.015
      c15v14 = 0.025
      c15v12 = c15v12(c15v13, c15v14)
      c15v5 = c15v11 + c15v12
      c15v11 = 1
      if not (c15v11 < c15v5) then
        continue
      end
      do return end
    end
    do return end
  end
  MinePlacer = v40
  v40 = function(c16v0)
    local c16v1, c16v2, c16v3, c16v4
    c16v1 = Sleep
    c16v2 = 20
    c16v1(c16v2)
    c16v1 = gGameRules
    c16v1 = c16v1:IsNightmareMode()
    c16v2 = IsNull
    c16v2 = c16v2(c16v0)
    if (c16v2 or c16v1 == false) then
      do return end
    end
    c16v3 = materialSlot
    c16v4 = coreSkinAlt
    c16v0:SetOverrideMaterial(c16v3, c16v4)
    c16v3 = fxType
    c16v4 = EMPTY_SYMBOL
    c16v0:Attach(c16v3, c16v4)
    do return end
  end
  Core = v40
  v40 = function(c17v0)
    local c17v1, c17v2, c17v3, c17v4, c17v5, c17v6, c17v7
    c17v1 = c17v0:GetAttachParent()
    c17v2 = IsNull
    c17v2 = c17v2(c17v1)
    if not c17v2 then
      c17v2 = c17v0:GetInstigator()
      c17v3 = IsNull
      c17v3 = c17v3(c17v2)
      if not c17v3 then
        c17v4 = 1500
        c17v5 = 7
        c17v6 = 0
        c17v7 = 0
        c17v2:DamageEx(c17v4, c17v5, c17v6, c17v7, c17v0, c17v0)
      end
      c17v1:Destroy()
    end
    do return end
  end
  Mine = v40
  v40 = function(c18v0)
    local c18v1, c18v2
    local __renovice_state_0 = 0
    c18v2 = _T.gTestingRaidPerf
    c18v1 = IsNull
    c18v1 = c18v1(c18v2)
    if c18v1 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c18v1 = _T.gTestingRaidPerf
      if c18v1 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      _T.gHitTrap = c18v0
      __renovice_state_0 = 3
    end
    if __renovice_state_0 == 3 then
      do return end
    end
    do return end
  end
  OnTouched = v40
  v40 = function(c19v0)
    local c19v1, c19v2, c19v3
    c19v1 = ObjectPortHandler
    c19v3 = "OnTouched"
    c19v1(c19v0, c19v3)
    while true do
      c19v1 = Sleep
      c19v2 = 0
      c19v1(c19v2)
    end
    do return end
  end
  RaidTrap = v40
  v40 = function(c20v0)
    local c20v1, c20v2, c20v3, c20v4, c20v5
    c20v1 = gRegion
    c20v3 = Symbol
    c20v4 = "PayloadAvatar"
    c20v1 = c20v1:FindTagged(c20v3(c20v4))
    c20v2 = IsNull
    c20v2 = c20v2(c20v1)
    if not c20v2 then
      c20v1 = c20v1[1]
    end
    c20v5 = Symbol
    c20v0:Name__7552af37(c20v1, c20v5())
    do return end
  end
  RaidDamageBeam = v40
  do return end
