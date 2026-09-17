  local v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42
  v0 = module
  v1 = ...
  v2 = package.seeall
  v0(v1, v2)
  v0 = 5
  MIN_RANGE_NO_LOS = v0
  v0 = require
  v1 = "EE.Interface.Utilities"
  v0 = v0(v1)
  v1 = require
  v2 = "Lotus.Interface.LotusUtilities"
  v1 = v1(v2)
  v2 = require
  v3 = "Lotus.Scripts.Libs.CloakAccessibilityLib"
  v2 = v2(v3)
  v3 = require
  v4 = "Lotus.Powersuits.PowersuitAbilities.PVPLib"
  v3 = v3(v4)
  v4 = Symbol
  v5 = "RJSubMissionStarted"
  v4 = v4(v5)
  v5 = Symbol
  v6 = "CrpAirlockFull"
  v5 = v5(v6)
  v6 = WeakResource
  v7 = "/Lotus/Types/Player/TennoMainMenuAvatar"
  v6 = v6(v7)
  v7 = WeakResource
  v8 = "/Lotus/Characters/Tenno/Accessory/DecalProjector/ClanEmblemDeco"
  v7 = v7(v8)
  v8 = WeakResource
  v9 = "/Lotus/Fx/Levels/Tutorial/VorBrandingEffectDeco"
  v8 = v8(v9)
  v9 = WeakResource
  v10 = "/Lotus/Characters/Grineer/BrandingDevice/GrineerBrandingDeviceHoloDeco"
  v9 = v9(v10)
  v10 = Symbol
  v11 = "EffectsDeco"
  v10 = v10(v11)
  v11 = Symbol
  v12 = "DefaultCloakOverride"
  v11 = v11(v12)
  v12 = WeakResource
  v13 = "/Lotus/Types/GameRules/LotusPveWaterFightGameRules"
  v12 = v12(v13)
  v13 = WeakResource
  v14 = "/Lotus/Fx/Gameplay/BaseCloakProj"
  v13 = v13(v14)
  v14 = Type
  v15 = "/Lotus/Fx/PowersuitAbilities/Loki/Cloak"
  v14 = v14(v15)
  v15 = function(c1v0)
    local c1v1, c1v2, c1v3, c1v4
    c1v1 = v2
    c1v1 = c1v1.GetCloakEffect
    c1v1 = c1v1(c1v0)
    c1v2 = IsNull
    c1v2 = c1v2(c1v1)
    if not c1v2 then
      do return c1v1 end
    end
    c1v2 = c1v0:InventoryControl()
    c1v2 = c1v2:GetActivePowerSuit()
    c1v3 = IsNull
    c1v3 = c1v3(c1v2)
    if not c1v3 then
      c1v3 = c1v2:GetCloakEffect()
      c1v4 = IsNull
      c1v4 = c1v4(c1v3)
      if not c1v4 then
        do return c1v3 end
      end
    end
    c1v3 = v14
    do return c1v3 end
  end
  v16 = function(c2v0, c2v1)
    local c2v2
    c2v2 = v11
    c2v0:SetBlackboardFloat(c2v2, c2v1)
    do return end
  end
  OverrideDefaultCloakingMode = v16
  v16 = function(c3v0)
    local c3v1, c3v2
    c3v1 = IsNull
    c3v1 = c3v1(c3v0)
    if not c3v1 then
      c3v2 = v11
      c3v1 = c3v0:HasBlackboardValue(c3v2)
      if c3v1 then
        c3v2 = v11
        do return c3v0:GetBlackboardFloat(c3v2) end
      end
    end
    c3v1 = v2
    c3v1 = c3v1.CLOAK_MODES
    c3v1 = c3v1.DEFAULT
    do return c3v1 end
  end
  v17 = function(c4v0, c4v1)
    local c4v2, c4v3, c4v4, c4v5, c4v6
    c4v2 = c4v0:Name__d5d128c8()
    if (c4v2 and c4v1) then
      c4v3 = v2
      c4v3 = c4v3.GetCloakSetting
      c4v3 = c4v3()
    else
      c4v3 = v2
      c4v3 = c4v3.CLOAK_MODES
      c4v3 = c4v3.DEFAULT
    end
    c4v4 = v2
    c4v4 = c4v4.CLOAK_MODES
    c4v4 = c4v4.DEFAULT
    if c4v3 == c4v4 then
      local __renovice_state_0 = 5
      c4v4 = IsNull
      c4v4 = c4v4(c4v0)
      if c4v4 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 6
      end
      if __renovice_state_0 == 6 then
        c4v6 = v11
        c4v4 = c4v0:HasBlackboardValue(c4v6)
        if not c4v4 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        c4v5 = v11
        c4v3 = c4v0:GetBlackboardFloat(c4v5)
      end
      if __renovice_state_0 == 8 then
        c4v3 = v2
        c4v3 = c4v3.CLOAK_MODES
        c4v3 = c4v3.DEFAULT
      end
    end
    c4v4 = v2
    c4v4 = c4v4.SetupCloakModeFor
    c4v4(c4v0, c4v3)
    do return end
  end
  v18 = function(c5v0, c5v1)
    if c5v1 then
      c5v0:Name__206475a7()
      do return end
    end
    c5v0:Name__67d76229()
    do return end
  end
  v19 = function(c6v0, c6v1)
    if c6v1 then
      c6v0:Name__400e09b9()
      do return end
    end
    c6v0:Name__a6603c27()
    do return end
  end
  v20 = function(c7v0, c7v1, c7v2)
    local c7v3, c7v4, c7v5, c7v6, c7v7, c7v8, c7v9, c7v10, c7v11, c7v12, c7v13, c7v14, c7v15, c7v16, c7v17, c7v18, c7v19, c7v20, c7v21
    c7v3 = v17
    c7v5 = true
    c7v3(c7v0, c7v5)
    c7v5 = gEntityType
    c7v3 = c7v0:GetAllAttachments(c7v5)
    c7v4 = WeakResource
    c7v5 = "/Lotus/Types/Game/LotusWeaponAttachments/ArrowWeaponAttachment"
    c7v4 = c7v4(c7v5)
    c7v5 = WeakResource
    c7v6 = "/Lotus/Powersuits/Frumentarius/ExaltedSniperBase"
    c7v5 = c7v5(c7v6)
    c7v6 = Symbol
    c7v7 = "ManageVisibilityOnEquipmentChange"
    c7v6 = c7v6(c7v7)
    c7v10 = EMPTY_SYMBOL
    c7v7 = c7v0:Attach(c7v1, c7v10)
    c7v9 = IsNull
    c7v9 = c7v9(c7v7)
    c7v8 = not c7v9
    if c7v8 then
      c7v10 = gDynamicProjectorType
      c7v8 = c7v7:IsA(c7v10)
    end
    c7v11 = 1
    c7v9 = #c7v3
    c7v10 = 1
    for __renovice_for_0_0 = c7v11, c7v9, c7v10 do
      c7v12 = c7v3[__renovice_for_0_0]
      c7v13 = c7v12:GetMesh()
      c7v14 = IsNull
      c7v14 = c7v14(c7v13)
      if c7v14 then
        continue
      end
      repeat
        c7v16 = gWeaponAttachmentType
        c7v14 = c7v12:IsA(c7v16)
        c7v15 = false
        if not c7v14 then
          c7v16 = c7v12:GetAttachParent()
          if not c7v16 then break end
          c7v16 = c7v12:GetAttachParent()
          c7v18 = gWeaponAttachmentType
          c7v16 = c7v16:IsA(c7v18)
          if not c7v16 then break end
        end
        c7v16 = nil
        if c7v14 then
          c7v16 = c7v12:GetWeapon()
        else
          c7v17 = c7v12:GetAttachParent()
          c7v16 = c7v17:GetWeapon()
        end
        c7v14 = true
        c7v17 = IsNull
        c7v17 = c7v17(c7v16)
        if not c7v17 then
          repeat
            c7v17 = c7v16:IsHeavyWeapon()
            if not c7v17 then
              c7v17 = c7v16:IsA(c7v5)
              if not c7v17 then break end
            end
            c7v15 = true
          until true
        end
      until true
      c7v18 = v7
      c7v16 = c7v12:IsA(c7v18)
      if not c7v16 then
        c7v18 = v8
        c7v16 = c7v12:IsA(c7v18)
        if not c7v16 then
          c7v18 = v9
          c7v16 = c7v12:IsA(c7v18)
          if not c7v16 then
            c7v18 = v10
            c7v16 = c7v12:HasTag(c7v18)
            if (not c7v16 and not c7v15) then
              c7v18 = Name__ed5a00b7
              c7v16 = c7v12:IsA(c7v18)
              if not c7v16 then
                c7v16 = c7v12:AcceptsDynamicProjectors()
                if c7v16 then
                  if c7v8 then
                    c7v16 = 1
                    if c7v16 < __renovice_for_0_0 then
                      c7v19 = EMPTY_SYMBOL
                      c7v7:AddProjectorToEntity(c7v12, c7v19)
                    end
                  end
                  c7v16 = c7v12:IsA(c7v4)
                  if c7v16 then
                    c7v18 = gLotusAvatarType
                    c7v16 = c7v0:IsA(c7v18)
                    if c7v16 then
                      c7v16 = c7v0:InventoryControl()
                      c7v18 = 0
                      c7v16 = c7v16:GetWeaponInHand(c7v18)
                      c7v17 = IsNull
                      c7v17 = c7v17(c7v16)
                      if not c7v17 then
                        c7v19 = WeakResource
                        c7v20 = "/Lotus/Weapons/Tenno/Bows/LotusBow"
                        c7v17 = c7v16:IsA(c7v19(c7v20))
                        if not c7v17 then
                          c7v17 = c7v12:GetAttachment(c7v1)
                          c7v18 = IsNull
                          c7v18 = c7v18(c7v17)
                          if not c7v18 then
                            c7v20 = false
                            c7v21 = true
                            c7v17:SetVisibility(c7v20, c7v21)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      if (c7v14 and not c7v15) then
        c7v16 = c7v12:GetAttachment(c7v1)
        if not c7v16 then
          if c7v8 then
            c7v17 = c7v12:AcceptsDynamicProjectors()
            if c7v17 then
              c7v20 = EMPTY_SYMBOL
              c7v7:AddProjectorToEntity(c7v12, c7v20)
            end
          end
          c7v16 = c7v12:GetAttachment(c7v1)
        end
        if not c7v16 then
          continue
        end
        c7v19 = false
        c7v16:Name__f8f31f5a(c7v19)
        c7v16:SetTag(c7v6)
        c7v17 = c7v3[__renovice_for_0_0]
        c7v17 = c7v17:IsVisible()
        if c7v17 then
          continue
        end
        c7v19 = false
        c7v20 = true
        c7v16:SetVisibility(c7v19, c7v20)
      end
    end
    do return end
  end
  v21 = function(c8v0)
    local c8v1, c8v2, c8v3, c8v4, c8v5, c8v6, c8v7, c8v8, c8v9, c8v10, c8v11, c8v12
    c8v3 = gLotusAvatarType
    c8v1 = c8v0:IsA(c8v3)
    if c8v1 then
      c8v2 = v17
      c8v4 = false
      c8v2(c8v0, c8v4)
    end
    c8v4 = gEntityType
    c8v2 = c8v0:GetAllAttachments(c8v4)
    c8v5 = 1
    c8v3 = #c8v2
    c8v4 = 1
    for __renovice_for_0_0 = c8v5, c8v3, c8v4 do
      c8v6 = c8v2[__renovice_for_0_0]
      c8v7 = c8v6:GetMesh()
      c8v8 = IsNull
      c8v8 = c8v8(c8v7)
      if c8v8 then
        continue
      end
      c8v10 = v7
      c8v8 = c8v6:IsA(c8v10)
      if c8v8 then
        continue
      end
      c8v10 = v8
      c8v8 = c8v6:IsA(c8v10)
      if c8v8 then
        continue
      end
      c8v10 = v9
      c8v8 = c8v6:IsA(c8v10)
      if c8v8 then
        continue
      end
      c8v10 = v10
      c8v8 = c8v6:HasTag(c8v10)
      if c8v8 then
        continue
      end
      c8v10 = v13
      c8v8 = c8v6:GetAttachment(c8v10)
      c8v9 = IsNull
      c8v9 = c8v9(c8v8)
      if (not c8v9 and not c8v1) then
        c8v9 = c8v8:IsVisible()
        if c8v9 then
          continue
        end
        c8v11 = false
        c8v12 = true
        c8v6:SetVisibility(c8v11, c8v12)
      end
    end
    c8v5 = v13
    c8v3 = c8v0:GetAttachment(c8v5)
    c8v4 = IsNull
    c8v4 = c8v4(c8v3)
    if not c8v4 then
      c8v3:Destroy()
    end
    do return end
  end
  v22 = function(c9v0, c9v1)
    local c9v2
    c9v2 = v21
    c9v2(c9v0)
    c9v2 = v20
    c9v2(c9v0, c9v1)
    do return end
  end
  v23 = function(c10v0, c10v1, c10v2)
    local c10v3, c10v4, c10v5, c10v6, c10v7, c10v8, c10v9, c10v10, c10v11, c10v12, c10v13, c10v14, c10v15, c10v16, c10v17, c10v18, c10v19, c10v20
    c10v3 = c10v0:Name__0aac1de9()
    if not c10v3 then
      c10v3 = c10v0:Name__e0a3c2e0()
    end
    if c10v2 then
      c10v0:Name__206475a7()
    else
      c10v0:Name__67d76229()
    end
    c10v6 = gLotusAvatarType
    c10v4 = c10v0:GetAllAttachments(c10v6)
    c10v5 = ipairs
    c10v5, c10v6, c10v7 = c10v5(c10v4)
    for __renovice_for_0_0, __renovice_for_0_1 in c10v5, c10v6, c10v7 do
      if __renovice_for_0_1 == c10v0 then
        continue
      end
      if c10v2 then
        __renovice_for_0_1:Name__206475a7()
        continue
      end
      __renovice_for_0_1:Name__67d76229()
    end
    c10v5 = _T.infestedCritter
    if c10v5 then
      c10v6 = _T.infestedCritter
      c10v7 = c10v0:GetInstance()
      c10v5 = c10v6[c10v7]
      c10v6 = IsNull
      c10v6 = c10v6(c10v5)
      if not c10v6 then
        c10v6 = v23
        c10v8 = v15
        c10v8 = c10v8(c10v5)
        c10v6(c10v5, c10v8, c10v2)
      end
    end
    c10v7 = v13
    c10v5 = c10v0:GetAttachment(c10v7)
    if c10v5 then
      c10v6 = c10v5:GetType()
    else
      c10v6 = nil
    end
    c10v7 = c10v1:GetType()
    c10v8 = print
    c10v10 = "ABLIB: ApplyInvis "
    c10v20 = tostring
    c10v11 = c10v20(c10v0:GetFullName())
    c10v12 = " -- Active Cloak: "
    c10v20 = IsNull
    c10v20 = c10v20(c10v6)
    if c10v20 then
      c10v13 = "None"
    else
      c10v20 = tostring
      c10v13 = c10v20(c10v6:GetFullName())
    end
    c10v14 = " | Expected cloak"
    c10v20 = IsNull
    c10v20 = c10v20(c10v7)
    if c10v20 then
      c10v15 = "None"
    else
      c10v20 = tostring
      c10v15 = c10v20(c10v7:GetFullName())
    end
    c10v16 = ", was invis: "
    c10v20 = tostring
    c10v17 = c10v20(c10v3)
    c10v18 = ", isLocal: "
    c10v19 = tostring
    c10v19 = c10v19(c10v2)
    c10v9 = c10v10 .. c10v11 .. c10v12 .. c10v13 .. c10v14 .. c10v15 .. c10v16 .. c10v17 .. c10v18 .. c10v19
    c10v8(c10v9)
    if (c10v3 and c10v6 == c10v7) then
      c10v8 = v17
      c10v10 = true
      c10v8(c10v0, c10v10)
      do return end
    end
    c10v8 = v21
    c10v8(c10v0)
    c10v8 = v20
    c10v8(c10v0, c10v1)
    do return end
  end
  v24 = function(c11v0, c11v1)
    local c11v2, c11v3, c11v4, c11v5, c11v6
    c11v2 = false
    c11v5 = gLotusAvatarType
    c11v3 = c11v0:IsA(c11v5)
    if c11v3 then
      if c11v1 then
        c11v0:Name__400e09b9()
      else
        c11v0:Name__a6603c27()
      end
      c11v3 = c11v0:Name__0aac1de9()
      if not c11v3 then
        c11v3 = c11v0:Name__e0a3c2e0()
      end
      c11v2 = c11v3
      c11v3 = _T.infestedCritter
      if c11v3 then
        c11v4 = _T.infestedCritter
        c11v5 = c11v0:GetInstance()
        c11v3 = c11v4[c11v5]
        c11v4 = IsNull
        c11v4 = c11v4(c11v3)
        if not c11v4 then
          c11v4 = v24
          c11v4(c11v3, c11v1)
        end
      end
    else
      c11v5 = gRagdollType
      c11v3 = c11v0:IsA(c11v5)
      if c11v3 then
        c11v3 = c11v0:GetAvatarOwner()
        c11v4 = IsNull
        c11v4 = c11v4(c11v3)
        if not c11v4 then
          repeat
            c11v4 = c11v3:Name__0aac1de9()
            if not c11v4 then
              c11v4 = c11v3:Name__e0a3c2e0()
              if not c11v4 then break end
            end
            c11v2 = true
          until true
        end
      end
    end
    c11v3 = print
    c11v5 = "ABLIB: RemoveInvis "
    c11v6 = tostring
    c11v6 = c11v6(c11v0:GetFullName())
    c11v4 = c11v5 .. c11v6
    c11v3(c11v4)
    c11v5 = gLotusAvatarType
    c11v3 = c11v0:GetAllAttachments(c11v5)
    c11v4 = ipairs
    c11v4, c11v5, c11v6 = c11v4(c11v3)
    for __renovice_for_0_0, __renovice_for_0_1 in c11v4, c11v5, c11v6 do
      if __renovice_for_0_1 == c11v0 then
        continue
      end
      if c11v1 then
        __renovice_for_0_1:Name__400e09b9()
        continue
      end
      __renovice_for_0_1:Name__a6603c27()
    end
    if c11v2 then
      do return end
    end
    c11v4 = v21
    c11v4(c11v0)
    do return end
  end
  v25 = function(c12v0)
    local c12v1, c12v2, c12v3, c12v4, c12v5, c12v6
    c12v1 = c12v0:Name__0aac1de9()
    if not c12v1 then
      c12v1 = c12v0:Name__e0a3c2e0()
    end
    if not c12v1 then
      do return end
    end
    c12v2 = v15
    c12v2 = c12v2(c12v0)
    c12v5 = v13
    c12v3 = c12v0:GetAttachment(c12v5)
    if c12v3 == nil then
      do return end
    end
    c12v4 = c12v3:GetType()
    c12v5 = c12v2:GetType()
    if c12v4 == c12v5 then
      c12v4 = v17
      c12v6 = true
      c12v4(c12v0, c12v6)
      do return end
    end
    c12v4 = v21
    c12v4(c12v0)
    c12v4 = v20
    c12v4(c12v0, c12v2)
    do return end
  end
  RefreshInvisibilityFx = v25
  v25 = function(c13v0)
    local c13v1, c13v2, c13v3, c13v4, c13v5
    c13v1 = c13v0:Name__2d897740()
    c13v2 = IsNull
    c13v2 = c13v2(c13v1)
    if c13v2 then
      c13v2 = nil
      do return c13v2 end
    end
    c13v2 = c13v1:GetOwnedPowerSuitAvatar()
    c13v3 = IsNull
    c13v3 = c13v3(c13v2)
    if c13v3 then
      c13v3 = nil
      do return c13v3 end
    end
    c13v3 = c13v2:InventoryControl()
    c13v3 = c13v3:GetSentinel()
    c13v4 = IsNull
    c13v4 = c13v4(c13v3)
    if c13v4 then
      c13v4 = nil
      do return c13v4 end
    end
    c13v5 = gPetAvatarType
    c13v4 = c13v3:IsA(c13v5)
    if not c13v4 then
      c13v5 = gLotusRoboPetAvatarType
      c13v4 = c13v3:IsA(c13v5)
      if not c13v4 then
        c13v4 = nil
        do return c13v4 end
      end
    end
    do return c13v3 end
  end
  v26 = function(c14v0)
    local c14v1, c14v2, c14v3, c14v4, c14v5
    c14v1 = c14v0:GetInstance()
    c14v4 = gLotusOperatorAvatarType
    c14v2 = c14v0:IsA(c14v4)
    if c14v2 then
      c14v2 = c14v0:Name__2d897740()
      c14v3 = IsNull
      c14v3 = c14v3(c14v2)
      if c14v3 then
        c14v3 = nil
        do return c14v3 end
      end
      c14v5 = 0
      c14v3 = c14v2:GetPlayerAvatar(c14v5)
      c14v4 = IsNull
      c14v4 = c14v4(c14v3)
      if c14v4 then
        c14v4 = nil
        do return c14v4 end
      end
      c14v1 = c14v3:GetInstance()
    end
    c14v3 = _T.khoraKavat
    c14v2 = IsNull
    c14v2 = c14v2(c14v3)
    if not c14v2 then
      c14v4 = _T.khoraKavat
      c14v3 = c14v4[c14v1]
      c14v2 = IsNull
      c14v2 = c14v2(c14v3)
      if not c14v2 then
        c14v4 = _T.khoraKavat
        c14v3 = c14v4[c14v1]
        c14v3 = c14v3.avatar
        c14v2 = IsNull
        c14v2 = c14v2(c14v3)
        if not c14v2 then
          c14v3 = _T.khoraKavat
          c14v2 = c14v3[c14v1]
          c14v2 = c14v2.avatar
          do return c14v2 end
        end
      end
    end
    c14v2 = nil
    do return c14v2 end
  end
  v27 = function(c15v0, c15v1)
    local c15v2, c15v3, c15v4
    c15v2 = IsNull
    c15v2 = c15v2(c15v0)
    if not c15v2 then
      c15v2 = IsNull
      c15v2 = c15v2(c15v1)
      if not c15v2 then
        c15v2 = c15v0:GetScriptBlackboard()
        c15v3 = c15v2.AdditionalInvisibilityEntities
        if not c15v3 then
          c15v3 = {}
          c15v2.AdditionalInvisibilityEntities = c15v3
        end
        c15v4 = c15v2.AdditionalInvisibilityEntities
        c15v3 = table.insert
        c15v3(c15v4, c15v1)
        do return end
      end
    end
    do return end
  end
  AddAdditionalInvisibilityEntity = v27
  v27 = function(c16v0, c16v1)
    local c16v2, c16v3, c16v4, c16v5, c16v6, c16v7
    c16v2 = IsNull
    c16v2 = c16v2(c16v0)
    if not c16v2 then
      c16v2 = IsNull
      c16v2 = c16v2(c16v1)
      if not c16v2 then
        c16v2 = c16v0:GetScriptBlackboard()
        c16v3 = c16v2.AdditionalInvisibilityEntities
        if not c16v3 then
          do return end
        end
        c16v3 = c16v2.AdditionalInvisibilityEntities
        c16v4 = nil
        c16v5 = nil
        for __renovice_for_0_0, __renovice_for_0_1 in c16v3, c16v4, c16v5 do
          if __renovice_for_0_1 ~= c16v1 then
            continue
          end
          c16v6 = table.remove
          c16v7 = c16v2.AdditionalInvisibilityEntities
          c16v6(c16v7, __renovice_for_0_0)
          break
        end
        c16v4 = c16v2.AdditionalInvisibilityEntities
        c16v3 = #c16v4
        if c16v3 == 0 then
          c16v3 = nil
          c16v2.AdditionalInvisibilityEntities = c16v3
        end
        do return end
      end
    end
    do return end
  end
  RemoveAdditionalInvisibilityEntity = v27
  v27 = function(c17v0, c17v1)
    local c17v2, c17v3, c17v4, c17v5, c17v6, c17v7, c17v8, c17v9
    if c17v1 == nil then
      c17v1 = false
    end
    c17v2 = v23
    c17v4 = v15
    c17v4 = c17v4(c17v0)
    c17v2(c17v0, c17v4, c17v1)
    c17v3 = _T.sentinelInvisibilityActive
    c17v2 = IsNull
    c17v2 = c17v2(c17v3)
    if c17v2 then
      c17v2 = _T
      c17v3 = {}
      c17v2.sentinelInvisibilityActive = c17v3
    end
    c17v2 = _T.sentinelInvisibilityActive
    c17v3 = c17v0:GetInstance()
    c17v4 = true
    c17v2[c17v3] = c17v4
    c17v2 = c17v0:InventoryControl()
    c17v2 = c17v2:GetSentinel()
    c17v3 = IsNull
    c17v3 = c17v3(c17v2)
    if c17v3 then
      c17v3 = v25
      c17v2 = c17v3(c17v0)
    end
    c17v3 = IsNull
    c17v3 = c17v3(c17v2)
    if not c17v3 then
      c17v3 = v23
      c17v5 = v15
      c17v5 = c17v5(c17v2)
      c17v3(c17v2, c17v5, c17v1)
    end
    c17v3 = v26
    c17v3 = c17v3(c17v0)
    c17v4 = IsNull
    c17v4 = c17v4(c17v3)
    if not c17v4 then
      c17v4 = v23
      c17v6 = v15
      c17v6 = c17v6(c17v3)
      c17v4(c17v3, c17v6)
    end
    c17v4 = c17v0:GetScriptBlackboard()
    c17v5 = c17v4.AdditionalInvisibilityEntities
    if c17v5 then
      c17v5 = c17v4.AdditionalInvisibilityEntities
      c17v6 = nil
      c17v7 = nil
      for __renovice_for_0_0, __renovice_for_0_1 in c17v5, c17v6, c17v7 do
        c17v8 = IsNull
        c17v8 = c17v8(__renovice_for_0_1)
        if c17v8 then
          continue
        end
        c17v8 = v23
        c17v9 = v15
        c17v9 = c17v9(__renovice_for_0_1)
        c17v8(__renovice_for_0_1, c17v9, c17v1)
      end
    end
    do return end
  end
  ApplyLotusInvisibility = v27
  v27 = function(c18v0, c18v1, c18v2)
    local c18v3
    if c18v2 == nil then
      c18v2 = false
    end
    if c18v1 == nil then
      c18v3 = v15
      c18v1 = c18v3(c18v0)
    end
    c18v3 = v23
    c18v3(c18v0, c18v1, c18v2)
    do return end
  end
  ApplyLotusInvisibilityNoSentinel = v27
  v27 = function(c19v0, c19v1)
    local c19v2, c19v3, c19v4, c19v5, c19v6, c19v7, c19v8, c19v9, c19v10
    if c19v1 == nil then
      c19v1 = false
    end
    c19v2 = v24
    c19v2(c19v0, c19v1)
    c19v2 = IsNull
    c19v2 = c19v2(c19v0:GetRagdoll())
    if not c19v2 then
      c19v2 = v24
      c19v3 = c19v0:GetRagdoll()
      c19v2(c19v3, c19v1)
    end
    c19v3 = _T.sentinelInvisibilityActive
    c19v2 = IsNull
    c19v2 = c19v2(c19v3)
    if c19v2 then
      c19v2 = _T
      c19v3 = {}
      c19v2.sentinelInvisibilityActive = c19v3
    end
    c19v2 = _T.sentinelInvisibilityActive
    c19v3 = c19v0:GetInstance()
    c19v4 = false
    c19v2[c19v3] = c19v4
    c19v2 = c19v0:InventoryControl()
    c19v2 = c19v2:GetSentinel()
    c19v3 = IsNull
    c19v3 = c19v3(c19v2)
    if c19v3 then
      c19v3 = v25
      c19v2 = c19v3(c19v0)
    end
    c19v3 = IsNull
    c19v3 = c19v3(c19v2)
    if not c19v3 then
      c19v3 = v24
      c19v3(c19v2, c19v1)
      c19v3 = IsNull
      c19v3 = c19v3(c19v2:GetRagdoll())
      if not c19v3 then
        c19v3 = v24
        c19v4 = c19v2:GetRagdoll()
        c19v3(c19v4, c19v1)
      end
    end
    c19v3 = v26
    c19v3 = c19v3(c19v0)
    c19v4 = IsNull
    c19v4 = c19v4(c19v3)
    if not c19v4 then
      c19v4 = v24
      c19v4(c19v3, c19v1)
      c19v4 = IsNull
      c19v4 = c19v4(c19v3:GetRagdoll())
      if not c19v4 then
        c19v4 = v24
        c19v5 = c19v3:GetRagdoll()
        c19v4(c19v5, c19v1)
      end
    end
    c19v4 = c19v0:GetScriptBlackboard()
    c19v5 = c19v4.AdditionalInvisibilityEntities
    if c19v5 then
      c19v5 = c19v4.AdditionalInvisibilityEntities
      c19v6 = nil
      c19v7 = nil
      for __renovice_for_0_0, __renovice_for_0_1 in c19v5, c19v6, c19v7 do
        c19v8 = IsNull
        c19v8 = c19v8(__renovice_for_0_1)
        if c19v8 then
          continue
        end
        c19v8 = v24
        c19v8(__renovice_for_0_1, c19v1)
        c19v10 = gBaseAvatarType
        c19v8 = __renovice_for_0_1:IsA(c19v10)
        if not c19v8 then
          continue
        end
        c19v8 = IsNull
        c19v8 = c19v8(__renovice_for_0_1:GetRagdoll())
        if c19v8 then
          continue
        end
        c19v8 = v24
        c19v9 = __renovice_for_0_1:GetRagdoll()
        c19v8(c19v9, c19v1)
      end
    end
    do return end
  end
  RemoveLotusInvisibility = v27
  v27 = function(c20v0, c20v1)
    local c20v2, c20v3
    if c20v1 == nil then
      c20v1 = false
    end
    c20v2 = v24
    c20v2(c20v0, c20v1)
    c20v2 = IsNull
    c20v2 = c20v2(c20v0:GetRagdoll())
    if not c20v2 then
      c20v2 = v24
      c20v3 = c20v0:GetRagdoll()
      c20v2(c20v3, c20v1)
    end
    do return end
  end
  RemoveLotusInvisibilityNoSentinel = v27
  v27 = function(c21v0)
    local c21v1, c21v2
    c21v1 = IsNull
    c21v1 = c21v1(c21v0)
    if c21v1 then
      do return end
    end
    c21v1 = c21v0:GetScriptBlackboard()
    local __renovice_local_0 = c21v1.forceWalkCounter
    if __renovice_local_0 == nil then
      __renovice_local_0 = 0
      c21v1.forceWalkCounter = __renovice_local_0
    end
    __renovice_local_0 = c21v1.forceWalkCounter
    if __renovice_local_0 == 0 then
      __renovice_local_0 = c21v0:MotionControl()
      c21v2 = true
      __renovice_local_0:SetForceWalk(c21v2)
    end
    __renovice_local_0 = c21v1.forceWalkCounter
    __renovice_local_0 = __renovice_local_0 + 1
    c21v1.forceWalkCounter = __renovice_local_0
    do return end
  end
  ApplyForceWalk = v27
  v27 = function(c22v0)
    local c22v1, c22v2
    c22v1 = IsNull
    c22v1 = c22v1(c22v0)
    if c22v1 then
      do return end
    end
    c22v1 = c22v0:GetScriptBlackboard()
    local __renovice_local_0 = c22v1.forceWalkCounter
    if __renovice_local_0 == nil then
      do return end
    end
    __renovice_local_0 = c22v1.forceWalkCounter
    __renovice_local_0 = __renovice_local_0 - 1
    c22v1.forceWalkCounter = __renovice_local_0
    __renovice_local_0 = c22v1.forceWalkCounter
    if __renovice_local_0 == 0 then
      __renovice_local_0 = c22v0:MotionControl()
      c22v2 = false
      __renovice_local_0:SetForceWalk(c22v2)
      __renovice_local_0 = nil
      c22v1.forceWalkCounter = __renovice_local_0
    end
    do return end
  end
  RemoveForceWalk = v27
  v27 = function(c23v0, c23v1)
    local c23v2
    if c23v1 == true then
      c23v2 = ApplyForceWalk
      c23v2(c23v0)
      do return end
    end
    c23v2 = RemoveForceWalk
    c23v2(c23v0)
    do return end
  end
  SetForceWalk = v27
  v27 = function(c24v0, c24v1, c24v2, c24v3, c24v4, c24v5, c24v6, c24v7, c24v8)
    local c24v9, c24v10, c24v11, c24v12, c24v13, c24v14, c24v15, c24v16, c24v17, c24v18
    local __renovice_state_0 = 0
    c24v9 = IsNull
    c24v9 = c24v9(c24v0)
    if not c24v9 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c24v9 = 0
      do return c24v9 end
    end
    if __renovice_state_0 == 2 then
      c24v9 = c24v0:GetAvatarOwner()
      c24v10 = IsNull
      c24v10 = c24v10(c24v9)
      if not c24v10 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c24v10 = 0
      do return c24v10 end
    end
    if __renovice_state_0 == 4 then
      c24v10 = v3
      c24v10 = c24v10.IsFightingGame
      c24v10 = c24v10()
      if not c24v10 then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c24v5 = true
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 6 then
      c24v10 = c24v9:InventoryControl()
      c24v12 = 1
      c24v13 = 28
      c24v14 = c24v0:GetType()
      c24v10 = c24v10:GetUpgradeModifiedValue(c24v12, c24v13, c24v14, c24v0)
      c24v11 = v3
      c24v11 = c24v11.IsPvpEnabled
      c24v11 = c24v11()
      if (not c24v11 or c24v6 == nil) then
        __renovice_state_0 = 9
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      c24v10 = c24v10 * c24v6
      __renovice_state_0 = 9
    end
    if __renovice_state_0 == 9 then
      if (c24v7 == nil or not (c24v7 < c24v10)) then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c24v10 = c24v7
      __renovice_state_0 = 12
    end
    if __renovice_state_0 == 12 then
      c24v13 = nil
      c24v14 = false
      c24v15 = 0
      c24v16 = 0
      c24v17 = false
      c24v18 = false
      c24v9:Name__c6bd3fe3(c24v13, c24v14, c24v15, c24v16, c24v17, c24v18)
      c24v12 = IsNull
      c24v12 = c24v12(c24v1)
      if c24v12 then
        __renovice_state_0 = 14
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      c24v11 = c24v1:Name__783c7a90()
      if c24v11 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c24v11 = 0
      __renovice_state_0 = 15
    end
    if __renovice_state_0 == 15 then
      if not c24v8 then
        __renovice_state_0 = 20
      else
        __renovice_state_0 = 16
      end
    end
    if __renovice_state_0 == 16 then
      c24v12 = 0
      if (not (c24v12 < c24v10) or c24v10 == 1) then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 18
      end
    end
    if __renovice_state_0 == 18 then
      c24v12 = c24v9:PlayAnimation(c24v1, c24v2, c24v3, c24v4, c24v5, c24v10)
      c24v11 = c24v11 + c24v12
      do return c24v11 end
    end
    if __renovice_state_0 == 19 then
      c24v12 = c24v9:PlayAnimation(c24v1, c24v2, c24v3, c24v4, c24v5)
      c24v11 = c24v11 + c24v12
      do return c24v11 end
    end
    if __renovice_state_0 == 20 then
      c24v12 = 0
      if (not (c24v12 < c24v10) or c24v10 == 1) then
        __renovice_state_0 = 23
      else
        __renovice_state_0 = 22
      end
    end
    if __renovice_state_0 == 22 then
      c24v12 = c24v9:PlayNonReplicatedAnimation(c24v1, c24v2, c24v3, c24v4, c24v5, c24v10)
      c24v11 = c24v11 + c24v12
      do return c24v11 end
    end
    if __renovice_state_0 == 23 then
      c24v12 = c24v9:PlayNonReplicatedAnimation(c24v1, c24v2, c24v3, c24v4, c24v5)
      c24v11 = c24v11 + c24v12
      do return c24v11 end
    end
    do return end
  end
  v28 = function(c25v0, c25v1, c25v2, c25v3, c25v4, c25v5, c25v6, c25v7)
    local c25v8
    c25v8 = v27
    c25v8 = c25v8(c25v0, c25v1, c25v2, c25v3, c25v4, c25v5, c25v6, c25v7)
    do return c25v8 end
  end
  PlayAnim = v28
  v28 = function(c26v0, c26v1, c26v2, c26v3, c26v4, c26v5, c26v6, c26v7)
    local c26v8, c26v9
    c26v8 = v27
    c26v9 = true
    c26v8 = c26v8(c26v0, c26v1, c26v2, c26v3, c26v4, c26v5, c26v6, c26v7, c26v9)
    do return c26v8 end
  end
  PlayReplicatedAnim = v28
  v28 = function(c27v0, c27v1, c27v2, c27v3, c27v4, c27v5, c27v6, c27v7, c27v8)
    local c27v9, c27v10, c27v11
    c27v9 = v27
    c27v9 = c27v9(c27v0, c27v1, c27v3, c27v4, c27v5, c27v6, c27v7, c27v8)
    c27v10 = 0
    if ((c27v10 < c27v9 and c27v2 ~= nil) and c27v2 ~= "") then
      c27v10 = c27v0:GetAvatarOwner()
      c27v11 = IsNull
      c27v11 = c27v11(c27v10)
      if not c27v11 then
        c27v10:SuspendScriptUntilAnimEvent(c27v2, c27v9)
      end
    end
    do return c27v9 end
  end
  PlayAnimAndSuspendUntilEvent = v28
  v28 = function(c28v0, c28v1, c28v2, c28v3, c28v4, c28v5)
    local c28v6, c28v7, c28v8, c28v9, c28v10, c28v11, c28v12
    c28v6 = IsNull
    c28v6 = c28v6(c28v0)
    if c28v6 then
      c28v6 = 0
      do return c28v6 end
    end
    c28v6 = c28v0:GetAvatarOwner()
    c28v7 = IsNull
    c28v7 = c28v7(c28v6)
    if c28v7 then
      c28v7 = 0
      do return c28v7 end
    end
    c28v7 = v3
    c28v7 = c28v7.IsFightingGame
    c28v7 = c28v7()
    if c28v7 then
      c28v5 = true
    end
    c28v7 = c28v6:InventoryControl()
    c28v9 = 1
    c28v10 = 28
    c28v11 = c28v0:GetType()
    c28v7 = c28v7:GetUpgradeModifiedValue(c28v9, c28v10, c28v11, c28v0)
    c28v8 = 0
    if (c28v8 < c28v7 and c28v7 ~= 1) then
      c28v12 = false
      do return c28v6:Name__c6bd3fe3(c28v1, c28v2, c28v3, c28v4, c28v5, c28v12, c28v7) end
    end
    c28v12 = false
    do return c28v6:Name__c6bd3fe3(c28v1, c28v2, c28v3, c28v4, c28v5, c28v12) end
  end
  v29 = function(c29v0, c29v1, c29v2, c29v3, c29v4, c29v5)
    local c29v6
    c29v6 = v28
    do return c29v6(c29v0, c29v1, c29v2, c29v3, c29v4, c29v5) end
  end
  PlayUpperBodyAnim = v29
  v29 = function(c30v0, c30v1, c30v2, c30v3, c30v4, c30v5, c30v6)
    local c30v7, c30v8, c30v9
    c30v7 = v28
    c30v7 = c30v7(c30v0, c30v1, c30v3, c30v4, c30v5, c30v6)
    c30v8 = 0
    if ((c30v8 < c30v7 and c30v2 ~= nil) and c30v2 ~= "") then
      c30v8 = c30v0:GetAvatarOwner()
      c30v9 = IsNull
      c30v9 = c30v9(c30v8)
      if not c30v9 then
        c30v8:SuspendScriptUntilAnimEvent(c30v2, c30v7)
      end
    end
    do return end
  end
  PlayUpperBodyAnimAndSuspendUntilEvent = v29
  v29 = function(c31v0)
    local c31v1, c31v2
    c31v2 = type
    c31v2 = c31v2(c31v0)
    if c31v2 == "string" then
      do return c31v0 end
    end
    c31v2 = IsNull
    c31v2 = c31v2(c31v0)
    if not c31v2 then
      c31v2 = c31v0:GetType()
      c31v1 = c31v2:GetName()
    end
    do return c31v1 end
  end
  v30 = function(c32v0, c32v1, c32v2)
    local c32v3, c32v4, c32v5, c32v6
    if not c32v0 then
      do return end
    end
    c32v4 = nil
    c32v5 = type
    c32v5 = c32v5(c32v1)
    if c32v5 == "string" then
      c32v4 = c32v1
    else
      c32v5 = IsNull
      c32v5 = c32v5(c32v1)
      if not c32v5 then
        c32v5 = c32v1:GetType()
        c32v4 = c32v5:GetName()
      end
    end
    c32v3 = c32v4
    if c32v3 == nil then
      do return end
    end
    c32v4 = _T.abilityStats
    if not c32v4 then
      c32v4 = _T
      c32v5 = { byUserdata = nil, byKey = nil }
      c32v6 = {}
      c32v5.byUserdata = c32v6
      c32v6 = {}
      c32v5.byKey = c32v6
      c32v4.abilityStats = c32v5
    end
    c32v4 = type
    c32v4 = c32v4(c32v0)
    if c32v4 == "userdata" then
      c32v4 = pairs
      c32v5 = _T.abilityStats.byUserdata
      c32v4, c32v5, c32v6 = c32v4(c32v5)
      for __renovice_for_0_0, __renovice_for_0_1 in c32v4, c32v5, c32v6 do
        if __renovice_for_0_0 ~= c32v0 then
          continue
        end
        __renovice_for_0_1[c32v3] = c32v2
        do return end
      end
      c32v4 = _T.abilityStats.byUserdata
      c32v5 = {}
      c32v5[c32v3] = c32v2
      c32v4[c32v0] = c32v5
      do return end
    end
    c32v4 = _T.abilityStats.byKey
    c32v5 = {}
    c32v5[c32v3] = c32v2
    c32v4[c32v0] = c32v5
    do return end
  end
  SetAbilityStats = v30
  v30 = function(c33v0, c33v1, c33v2)
    local c33v3, c33v4, c33v5, c33v6, c33v7
    local __renovice_local_0 = _T.abilityStats
    if __renovice_local_0 == nil then
      __renovice_local_0 = nil
      do return __renovice_local_0 end
    end
    if not c33v0 then
      __renovice_local_0 = nil
      do return __renovice_local_0 end
    end
    c33v3 = nil
    c33v4 = type
    c33v4 = c33v4(c33v1)
    if c33v4 == "string" then
      c33v3 = c33v1
    else
      c33v4 = IsNull
      c33v4 = c33v4(c33v1)
      if not c33v4 then
        c33v4 = c33v1:GetType()
        c33v3 = c33v4:GetName()
      end
    end
    __renovice_local_0 = c33v3
    if __renovice_local_0 == nil then
      c33v3 = nil
      do return c33v3 end
    end
    c33v3 = type
    c33v3 = c33v3(c33v0)
    if c33v3 == "userdata" then
      c33v3 = pairs
      c33v4 = _T.abilityStats.byUserdata
      c33v3, c33v4, c33v5 = c33v3(c33v4)
      for __renovice_for_0_0, __renovice_for_0_1 in c33v3, c33v4, c33v5 do
        if __renovice_for_0_0 ~= c33v0 then
          continue
        end
        c33v6 = __renovice_for_0_1[__renovice_local_0]
        if c33v2 then
          c33v7 = nil
          __renovice_for_0_1[__renovice_local_0] = c33v7
        end
        do return c33v6 end
      end
      c33v3 = nil
      do return c33v3 end
    end
    c33v4 = _T.abilityStats.byKey
    c33v3 = c33v4[c33v0]
    if c33v3 == nil then
      c33v4 = nil
      do return c33v4 end
    end
    c33v4 = c33v3[__renovice_local_0]
    if c33v2 then
      c33v5 = nil
      c33v3[__renovice_local_0] = c33v5
    end
    do return c33v4 end
  end
  v31 = function(c34v0, c34v1, c34v2)
    local c34v3
    c34v3 = v30
    c34v3 = c34v3(c34v0, c34v1, c34v2)
    do return c34v3 end
  end
  GetAbilityStats = v31
  v31 = function(c35v0, c35v1, c35v2, c35v3)
    local c35v4, c35v5, c35v6
    if c35v0 then
      while true do
        c35v4 = 0
        if not (c35v4 < c35v2) then break end
        c35v4 = v30
        c35v4 = c35v4(c35v0, c35v1, c35v3)
        if c35v4 then
          do return c35v4 end
        end
        c35v5 = Sleep
        c35v6 = 0
        c35v5(c35v6)
        c35v5 = DeltaTime
        c35v5 = c35v5()
        c35v2 = c35v2 - c35v5
      end
      c35v4 = nil
      do return c35v4 end
    end
    c35v4 = nil
    do return c35v4 end
  end
  WaitForAbilityStats = v31
  v31 = function(c36v0, c36v1)
    local c36v2, c36v3, c36v4, c36v5
    local __renovice_local_0 = _T.abilityStats
    if __renovice_local_0 == nil then
      do return end
    end
    if not c36v0 then
      do return end
    end
    c36v2 = nil
    c36v3 = type
    c36v3 = c36v3(c36v1)
    if c36v3 == "string" then
      c36v2 = c36v1
    else
      c36v3 = IsNull
      c36v3 = c36v3(c36v1)
      if not c36v3 then
        c36v3 = c36v1:GetType()
        c36v2 = c36v3:GetName()
      end
    end
    __renovice_local_0 = c36v2
    if __renovice_local_0 == nil then
      do return end
    end
    c36v2 = type
    c36v2 = c36v2(c36v0)
    if c36v2 == "userdata" then
      c36v2 = pairs
      c36v3 = _T.abilityStats.byUserdata
      c36v2, c36v3, c36v4 = c36v2(c36v3)
      for __renovice_for_0_0, __renovice_for_0_1 in c36v2, c36v3, c36v4 do
        if __renovice_for_0_0 ~= c36v0 then
          continue
        end
        c36v5 = nil
        __renovice_for_0_1[__renovice_local_0] = c36v5
        do return end
      end
      do return end
    end
    c36v3 = _T.abilityStats.byKey
    c36v2 = c36v3[c36v0]
    if c36v2 == nil then
      do return end
    end
    c36v3 = nil
    c36v2[__renovice_local_0] = c36v3
    do return end
  end
  ClearAbilityStats = v31
  v31 = function(c37v0)
    local c37v1, c37v2, c37v3
    c37v3 = c37v0:GetMeshScale()
    c37v2 = c37v3 / 0.25
    c37v1 = math.sqrt
    c37v1 = c37v1(c37v2)
    do return c37v1 end
  end
  GetArchwingScaleMultiplier = v31
  v31 = function(c38v0)
    local c38v1, c38v2, c38v3
    c38v2 = 0.25 / c38v0
    c38v3 = 0.6666666666666666
    c38v1 = math.pow
    c38v1 = c38v1(c38v2, c38v3)
    do return c38v1 end
  end
  v32 = function(c39v0)
    local c39v1, c39v2, c39v3, c39v4, c39v5
    c39v2 = c39v0:GetMeshScale()
    c39v4 = 0.25 / c39v2
    c39v5 = 0.6666666666666666
    c39v3 = math.pow
    c39v1 = c39v3(c39v4, c39v5)
    do return c39v1 end
  end
  GetArchwingRangeMultiplier = v32
  v32 = function(c40v0)
    local c40v1, c40v2, c40v3, c40v4, c40v5, c40v6, c40v7
    c40v1 = 0.25
    c40v2 = IsNull
    c40v2 = c40v2(c40v0)
    if not c40v2 then
      c40v2 = v1
      c40v2 = c40v2.GetUIMode
      c40v2 = c40v2()
      c40v3 = v1
      c40v3 = c40v3.UI_MODE_IN_GAME
      if c40v2 == c40v3 then
        c40v1 = c40v0:GetMeshScale()
      end
    end
    c40v4 = c40v1
    c40v6 = 0.25 / c40v4
    c40v7 = 0.6666666666666666
    c40v5 = math.pow
    c40v3 = c40v5(c40v6, c40v7)
    c40v2 = c40v3 / c40v1
    do return c40v2 end
  end
  GetArchwingUIRangeMultiplier = v32
  v32 = function(c41v0, c41v1)
    local c41v2, c41v3, c41v4, c41v5, c41v6
    c41v2 = IsNull
    c41v2 = c41v2(c41v0)
    if not c41v2 then
      c41v2 = c41v0:GetInstance()
      if c41v1 then
        c41v4 = _T.preventEnergyGain
        c41v3 = IsNull
        c41v3 = c41v3(c41v4)
        if c41v3 then
          c41v3 = _T
          c41v4 = {}
          c41v3.preventEnergyGain = c41v4
        end
        c41v5 = _T.preventEnergyGain
        c41v4 = c41v5[c41v2]
        c41v3 = IsNull
        c41v3 = c41v3(c41v4)
        if c41v3 then
          c41v3 = _T.preventEnergyGain
          c41v4 = 1
          c41v3[c41v2] = c41v4
          do return end
        end
        c41v3 = _T.preventEnergyGain
        c41v6 = _T.preventEnergyGain
        c41v5 = c41v6[c41v2]
        c41v4 = c41v5 + 1
        c41v3[c41v2] = c41v4
        do return end
      end
      c41v4 = _T.preventEnergyGain
      c41v3 = IsNull
      c41v3 = c41v3(c41v4)
      if not c41v3 then
        c41v5 = _T.preventEnergyGain
        c41v4 = c41v5[c41v2]
        c41v3 = IsNull
        c41v3 = c41v3(c41v4)
        if not c41v3 then
          c41v3 = _T.preventEnergyGain
          c41v6 = _T.preventEnergyGain
          c41v5 = c41v6[c41v2]
          c41v4 = c41v5 - 1
          c41v3[c41v2] = c41v4
          c41v4 = _T.preventEnergyGain
          c41v3 = c41v4[c41v2]
          c41v4 = 0
          if c41v3 <= c41v4 then
            c41v3 = _T.preventEnergyGain
            c41v4 = nil
            c41v3[c41v2] = c41v4
          end
        end
      end
    end
    do return end
  end
  PreventEnergyGain = v32
  v32 = function(c42v0)
    local c42v1, c42v2, c42v3, c42v4
    c42v1 = IsNull
    c42v1 = c42v1(c42v0)
    if not c42v1 then
      c42v2 = _T.preventEnergyGain
      c42v1 = IsNull
      c42v1 = c42v1(c42v2)
      if not c42v1 then
        c42v1 = c42v0:GetInstance()
        c42v3 = _T.preventEnergyGain
        c42v2 = c42v3[c42v1]
        if c42v2 ~= nil then
          c42v4 = _T.preventEnergyGain
          c42v3 = c42v4[c42v1]
          c42v4 = 0
          if not (c42v4 < c42v3) then
            c42v2 = false
            do return c42v2 end
          end
          c42v2 = true
          do return c42v2 end
        end
      end
    end
    c42v1 = false
    do return c42v1 end
  end
  EnergyGainPrevented = v32
  v32 = function(c43v0, c43v1)
    local c43v2, c43v3, c43v4, c43v5, c43v6
    c43v2 = IsNull
    c43v2 = c43v2(c43v0)
    if not c43v2 then
      c43v2 = IsNull
      c43v2 = c43v2(c43v1)
      if not c43v2 then
        c43v2 = c43v1:GetPowerIdentifiers()
        c43v3 = pairs
        c43v3, c43v4, c43v5 = c43v3(c43v2)
        for __renovice_for_0_0, __renovice_for_0_1 in c43v3, c43v4, c43v5 do
          c43v6 = c43v0:IsAbilityImmune(__renovice_for_0_1)
          if not c43v6 then
            continue
          end
          c43v6 = true
          do return c43v6 end
        end
        c43v3 = false
        do return c43v3 end
      end
    end
    c43v2 = false
    do return c43v2 end
  end
  IsImmuneToAbility = v32
  v32 = function(c44v0)
    local c44v1, c44v2, c44v3, c44v4
    while true do
      c44v1 = _T.inSeamlessTransition
      if not c44v1 then break end
      c44v1 = Sleep
      c44v2 = 0
      c44v1(c44v2)
    end
    c44v2 = gGameRules
    c44v1 = IsNull
    c44v1 = c44v1(c44v2)
    if not c44v1 then
      c44v1 = gGameRules
      c44v3 = gLotusHubGameRulesType
      c44v1 = c44v1:IsA(c44v3)
      if not c44v1 then
        c44v1 = gGameRules
        c44v3 = gLotusFightingGameRulesType
        c44v1 = c44v1:IsA(c44v3)
        if not c44v1 then
          c44v1 = gGameRules
          c44v3 = v12
          c44v1 = c44v1:IsA(c44v3)
          if not c44v1 then
            c44v1 = gGameRules
            c44v3 = gLotusObstacleCourseGameRulesType
            c44v1 = c44v1:IsA(c44v3)
            if not c44v1 then
              c44v1 = v3
              c44v1 = c44v1.DisablePassives
              c44v1 = c44v1()
              if not c44v1 then
                c44v1 = _T.ForceDisablePassives
                if not c44v1 then
                  c44v1 = IsNull
                  c44v1 = c44v1(c44v0)
                  if not c44v1 then
                    c44v1 = c44v0:GetAvatarOwner()
                    c44v2 = IsNull
                    c44v2 = c44v2(c44v1)
                    if not c44v2 then
                      c44v2 = c44v1:GetRegionMgr()
                      c44v2 = c44v2:IsBackgroundRegion()
                      if not c44v2 then
                        c44v4 = v6
                        c44v2 = c44v1:IsA(c44v4)
                        if not c44v2 then
                          c44v1 = false
                          do return c44v1 end
                        end
                      end
                    end
                    c44v2 = true
                    do return c44v2 end
                  end
                  c44v1 = false
                  do return c44v1 end
                end
              end
            end
          end
        end
      end
    end
    c44v1 = true
    do return c44v1 end
  end
  DisablePassives = v32
  v32 = function(c45v0)
    local c45v1, c45v2, c45v3, c45v4, c45v5, c45v6, c45v7, c45v8, c45v9, c45v10
    c45v1 = gRegion
    c45v1 = c45v1:IsMaster()
    if not c45v1 then
      do return end
    end
    c45v1 = _T.SlowCheckLoop
    if not c45v1 then
      c45v1 = _T
      c45v2 = {}
      c45v1.SlowCheckLoop = c45v2
    end
    c45v1 = c45v0:GetInstance()
    c45v3 = _T.SlowCheckLoop
    c45v2 = c45v3[c45v1]
    if c45v2 then
      do return end
    end
    c45v2 = _T.SlowCheckLoop
    c45v3 = true
    c45v2[c45v1] = c45v3
    c45v2 = c45v0:InventoryControl()
    c45v3 = c45v2:GetActivePowerSuit()
    c45v4 = 1
    c45v5 = IsNull
    c45v5 = c45v5(c45v3)
    if not c45v5 then
      c45v5 = c45v3:GetMovementSpeedMultiplier()
      c45v4 = c45v4 * c45v5
    end
    while true do
      c45v5 = _T.blockProcs
      if not c45v5 then break end
      c45v6 = _T.blockProcs
      c45v5 = c45v6[c45v1]
      if not c45v5 then break end
      c45v5 = IsNull
      c45v5 = c45v5(c45v0)
      if c45v5 then break end
      c45v5 = c45v0:IsKilled()
      if c45v5 then break end
      c45v2 = c45v0:InventoryControl()
      c45v5 = c45v2:GetActivePowerSuit()
      if c45v5 ~= c45v3 then break end
      c45v7 = 1
      c45v8 = 96
      c45v5 = c45v2:GetUpgradeModifiedValue(c45v7, c45v8)
      if c45v5 < c45v4 then
        c45v6 = Engine.DamageData
        c45v6 = c45v6()
        c45v7 = 0
        c45v6.baseAmount = c45v7
        c45v9 = 19
        c45v10 = true
        c45v6:SetProc(c45v9, c45v10)
        c45v0:DamageDD(c45v6)
        c45v7 = Sleep
        c45v8 = 5
        c45v7(c45v8)
        continue
      end
      c45v6 = Sleep
      c45v7 = 0.5
      c45v6(c45v7)
    end
    c45v5 = _T.SlowCheckLoop
    c45v6 = nil
    c45v5[c45v1] = c45v6
    c45v5 = next
    c45v6 = _T.SlowCheckLoop
    c45v5 = c45v5(c45v6)
    if c45v5 == nil then
      c45v5 = _T
      c45v6 = nil
      c45v5.SlowCheckLoop = c45v6
    end
    do return end
  end
  SlowCheckLoop = v32
  v32 = function(c46v0, c46v1)
    local c46v2, c46v3, c46v4, c46v5, c46v6, c46v7
    c46v2 = c46v0:GetInstance()
    if c46v1 then
      c46v3 = _T.blockProcs
      if c46v3 == nil then
        c46v3 = _T
        c46v4 = {}
        c46v3.blockProcs = c46v4
      end
      c46v4 = _T.blockProcs
      c46v3 = c46v4[c46v2]
      if c46v3 == nil then
        c46v3 = _T.blockProcs
        c46v4 = 0
        c46v3[c46v2] = c46v4
        c46v3 = gRegion
        c46v3 = c46v3:IsMaster()
        if c46v3 then
          c46v3 = c46v0:InventoryControl()
          c46v5 = 83
          c46v6 = 4
          c46v7 = 1
          c46v3:AddUpgrade(c46v5, c46v6, c46v7)
          c46v3 = c46v0:InventoryControl()
          c46v5 = 149
          c46v6 = 4
          c46v7 = 1
          c46v3:AddUpgrade(c46v5, c46v6, c46v7)
        end
      end
      c46v3 = _T.blockProcs
      c46v6 = _T.blockProcs
      c46v5 = c46v6[c46v2]
      c46v4 = c46v5 + 1
      c46v3[c46v2] = c46v4
      c46v3 = c46v0:DamageControl()
      c46v5 = 0
      c46v3:Name__24dadbcc(c46v5)
      do return end
    end
    c46v3 = _T.blockProcs
    if c46v3 ~= nil then
      c46v4 = _T.blockProcs
      c46v3 = c46v4[c46v2]
      if c46v3 then
        c46v3 = _T.blockProcs
        c46v6 = _T.blockProcs
        c46v5 = c46v6[c46v2]
        c46v4 = c46v5 - 1
        c46v3[c46v2] = c46v4
        c46v4 = _T.blockProcs
        c46v3 = c46v4[c46v2]
        if c46v3 == 0 then
          c46v3 = c46v0:DamageControl()
          c46v5 = 16
          c46v3:Name__24dadbcc(c46v5)
          c46v3 = gRegion
          c46v3 = c46v3:IsMaster()
          if c46v3 then
            c46v3 = c46v0:InventoryControl()
            c46v5 = 83
            c46v6 = 4
            c46v7 = 1
            c46v3:RemoveUpgrade(c46v5, c46v6, c46v7)
            c46v3 = c46v0:InventoryControl()
            c46v5 = 149
            c46v6 = 4
            c46v7 = 1
            c46v3:RemoveUpgrade(c46v5, c46v6, c46v7)
          end
          c46v3 = _T.blockProcs
          c46v4 = nil
          c46v3[c46v2] = c46v4
          c46v3 = next
          c46v4 = _T.blockProcs
          c46v3 = c46v3(c46v4)
          if c46v3 == nil then
            c46v3 = _T
            c46v4 = nil
            c46v3.blockProcs = c46v4
          end
        end
      end
    end
    do return end
  end
  BlockProcs = v32
  v32 = function(c47v0)
    local c47v1, c47v2, c47v3, c47v4, c47v5
    c47v1 = _T.shieldGated
    if c47v1 == nil then
      c47v1 = _T
      c47v2 = {}
      c47v1.shieldGated = c47v2
    end
    c47v1 = c47v0:GetInstance()
    c47v3 = _T.shieldGated
    c47v2 = c47v3[c47v1]
    if c47v2 ~= nil then
      c47v2 = _T.shieldGated
      c47v5 = _T.shieldGated
      c47v4 = c47v5[c47v1]
      c47v3 = c47v4 + 1
      c47v2[c47v1] = c47v3
      do return end
    end
    c47v2 = c47v0:DamageControl()
    c47v5 = gLotusDamageControllerType
    c47v3 = c47v2:IsA(c47v5)
    if c47v3 then
      c47v5 = 3.5
      c47v2:SetFullShieldGateDuration(c47v5)
    end
    c47v3 = _T.shieldGated
    c47v4 = 1
    c47v3[c47v1] = c47v4
    do return end
  end
  EnableShieldGating = v32
  v32 = function(c48v0)
    local c48v1, c48v2, c48v3, c48v4, c48v5
    c48v1 = _T.shieldGated
    if c48v1 == nil then
      do return end
    end
    c48v1 = c48v0:GetInstance()
    c48v3 = _T.shieldGated
    c48v2 = c48v3[c48v1]
    if c48v2 == nil then
      do return end
    end
    c48v2 = _T.shieldGated
    c48v5 = _T.shieldGated
    c48v4 = c48v5[c48v1]
    c48v3 = c48v4 - 1
    c48v2[c48v1] = c48v3
    c48v3 = _T.shieldGated
    c48v2 = c48v3[c48v1]
    c48v3 = 0
    if c48v2 <= c48v3 then
      c48v2 = c48v0:DamageControl()
      c48v5 = gLotusDamageControllerType
      c48v3 = c48v2:IsA(c48v5)
      if c48v3 then
        c48v5 = Resource
        c48v5 = c48v5(c48v2:GetType())
        c48v2:SetFullShieldGateDuration(c48v5:GetFullShieldGateDuration())
      end
      c48v3 = _T.shieldGated
      c48v4 = nil
      c48v3[c48v1] = c48v4
      c48v3 = next
      c48v4 = _T.shieldGated
      c48v3 = c48v3(c48v4)
      if c48v3 == nil then
        c48v3 = _T
        c48v4 = nil
        c48v3.shieldGated = c48v4
      end
    end
    do return end
  end
  DisableShieldGating = v32
  v32 = function(c49v0, c49v1, c49v2, c49v3)
    local c49v4, c49v5, c49v6, c49v7, c49v8
    c49v4 = c49v1:GetInstance()
    c49v5 = nil
    c49v6 = type
    c49v6 = c49v6(c49v2)
    if c49v6 == "string" then
      c49v5 = c49v2
    else
      c49v6 = c49v2:GetType()
      c49v5 = c49v6:GetName()
    end
    if c49v3 then
      c49v6 = _T[c49v0]
      if not c49v6 then
        c49v6 = _T
        c49v7 = {}
        c49v6[c49v0] = c49v7
      end
      c49v7 = _T[c49v0]
      c49v6 = c49v7[c49v4]
      if not c49v6 then
        c49v6 = _T[c49v0]
        c49v7 = {}
        c49v6[c49v4] = c49v7
      end
      c49v7 = _T[c49v0]
      c49v6 = c49v7[c49v4]
      c49v7 = true
      c49v6[c49v5] = c49v7
      do return c49v3 end
    end
    c49v6 = _T[c49v0]
    if c49v6 then
      c49v7 = _T[c49v0]
      c49v6 = c49v7[c49v4]
      if c49v6 then
        c49v7 = nil
        c49v6[c49v5] = c49v7
        c49v7 = next
        c49v7 = c49v7(c49v6)
        if c49v7 then
          c49v7 = true
          do return c49v7 end
        end
        c49v7 = _T[c49v0]
        c49v8 = nil
        c49v7[c49v4] = c49v8
      end
    end
    do return c49v3 end
  end
  v33 = function(c50v0, c50v1, c50v2, c50v3)
    local c50v4, c50v5, c50v6, c50v7, c50v8, c50v9, c50v10, c50v11, c50v12, c50v13
    c50v4 = IsNull
    c50v4 = c50v4(c50v0)
    if c50v4 then
      c50v4 = false
      do return c50v4 end
    end
    c50v4 = c50v0:InventoryControl()
    c50v5 = c50v4:IsFiringEnabled()
    c50v7 = v32
    c50v8 = "Abilities_FiringDisabled"
    c50v11 = not c50v2
    c50v7 = c50v7(c50v8, c50v0, c50v1, c50v11)
    c50v6 = not c50v7
    c50v4:EnableWeaponFiring(c50v6)
    if c50v3 == nil then
      c50v3 = false
    end
    if ((c50v3 and c50v5 ~= c50v2) and c50v6 == c50v2) then
      c50v9 = 0
      c50v7 = c50v4:Name__23991ed1(c50v9)
      c50v8 = IsNull
      c50v8 = c50v8(c50v7)
      if not c50v8 then
        c50v8 = Lotus_Game.Name__04f5c294
        c50v11 = false
        c50v8(c50v7, c50v2, c50v11)
        c50v7:EnableElementalEffects(c50v2)
      end
    end
    if c50v6 then
      c50v7 = c50v0:Layertrackers()
      if c50v7 then
        c50v9 = 0
        c50v7 = c50v4:Name__23991ed1(c50v9)
        c50v8 = IsNull
        c50v8 = c50v8(c50v7)
        if not c50v8 then
          c50v8 = c50v7:Name__c49f8ec1()
          c50v10 = c50v8:Name__0641d38c()
          c50v9 = not c50v10
          if c50v9 then
            c50v9 = c50v8:IsAutomatic()
          end
          c50v10 = c50v9
          if not c50v10 then
            c50v11 = gGameData
            c50v10 = IsNull
            c50v10 = c50v10(c50v11)
            if c50v10 then
              c50v10 = gGameData
              c50v10 = c50v10:Name__c8c7a03f()
            end
          end
          c50v9 = c50v10
          c50v12 = 0
          c50v10 = c50v4:Name__9acc2fce(c50v12)
          c50v11 = c50v0:InputControl()
          c50v11 = c50v11:Name__38cd3ce9()
          if (c50v11 and c50v9) then
            c50v13 = true
            c50v4:Name__f2f11d03(c50v13, c50v10)
          end
        end
      end
    end
    do return c50v6 end
  end
  EnableWeaponFiring = v33
  v33 = function(c51v0, c51v1, c51v2)
    local c51v3, c51v4
    c51v3 = IsNull
    c51v3 = c51v3(c51v0)
    if c51v3 then
      c51v3 = false
      do return c51v3 end
    end
    c51v3 = v32
    c51v4 = "Abilities_Immortality"
    c51v3 = c51v3(c51v4, c51v0, c51v1, c51v2)
    c51v4 = c51v0:DamageControl()
    c51v4:SetImmortal(c51v3)
    do return c51v3 end
  end
  EnableImmortality = v33
  v33 = function()
    local c52v0, c52v1, c52v2, c52v3
    c52v0 = _T.globalAbilityTimerId
    if c52v0 == nil then
      c52v0 = _T
      c52v1 = 1
      c52v0.globalAbilityTimerId = c52v1
    else
      c52v0 = _T
      c52v3 = _T.globalAbilityTimerId
      c52v2 = c52v3 % 1000000
      c52v1 = c52v2 + 1
      c52v0.globalAbilityTimerId = c52v1
    end
    c52v0 = _T.globalAbilityTimerId
    do return c52v0 end
  end
  GetUniqueAbilityId = v33
  v33 = function(c53v0, c53v1)
    local c53v2, c53v3, c53v4, c53v5, c53v6, c53v7, c53v8
    c53v2 = gRegion
    c53v2 = c53v2:IsMaster()
    if c53v2 then
      c53v2 = IsNull
      c53v2 = c53v2(c53v0)
      if not c53v2 then
        c53v2 = c53v0:GetAgent()
        c53v3 = IsNull
        c53v3 = c53v3(c53v2)
        if c53v3 then
          c53v3 = nil
          do return c53v3 end
        end
        c53v3 = true
        if c53v1 then
          c53v4 = _T.aiDirTrackAgent
          if c53v4 ~= nil then
            c53v4 = c53v0:GetInstance()
            c53v6 = _T.aiDirTrackAgent
            c53v5 = c53v6[c53v4]
            if c53v5 ~= nil then
              c53v5 = _T.aiDirTrackAgent
              c53v8 = _T.aiDirTrackAgent
              c53v7 = c53v8[c53v4]
              c53v6 = c53v7 - 1
              c53v5[c53v4] = c53v6
              c53v6 = _T.aiDirTrackAgent
              c53v5 = c53v6[c53v4]
              c53v6 = 0
              if c53v5 <= c53v6 then
                c53v5 = gRegion
                c53v5 = c53v5:GetNpcMgr()
                c53v5 = c53v5:GetAiDirector()
                c53v5:TrackAgent(c53v2)
                c53v5 = _T.aiDirTrackAgent
                c53v6 = nil
                c53v5[c53v4] = c53v6
              end
            end
            c53v5 = next
            c53v6 = _T.aiDirTrackAgent
            c53v5 = c53v5(c53v6)
            if c53v5 == nil then
              c53v5 = _T
              c53v6 = nil
              c53v5.aiDirTrackAgent = c53v6
            end
          else
            c53v4 = c53v2:IsIgnoredByAiDirector()
            if c53v4 then
              c53v4 = gRegion
              c53v4 = c53v4:GetNpcMgr()
              c53v4 = c53v4:GetAiDirector()
              c53v4:TrackAgent(c53v2)
            end
          end
          c53v3 = c53v2:IsIgnoredByAiDirector()
          do return c53v3 end
        end
        c53v3 = c53v2:IsIgnoredByAiDirector()
        c53v4 = _T.aiDirTrackAgent
        if c53v4 == nil then
          c53v4 = _T
          c53v5 = {}
          c53v4.aiDirTrackAgent = c53v5
        end
        c53v4 = c53v0:GetInstance()
        c53v6 = _T.aiDirTrackAgent
        c53v5 = c53v6[c53v4]
        if c53v5 == nil then
          if c53v3 then
            c53v5 = _T.aiDirTrackAgent
            c53v6 = 1
            c53v5[c53v4] = c53v6
          else
            c53v5 = _T.aiDirTrackAgent
            c53v6 = 0
            c53v5[c53v4] = c53v6
          end
          c53v5 = gRegion
          c53v5 = c53v5:GetNpcMgr()
          c53v5 = c53v5:GetAiDirector()
          c53v5:UntrackAgent(c53v2)
        end
        c53v5 = _T.aiDirTrackAgent
        c53v8 = _T.aiDirTrackAgent
        c53v7 = c53v8[c53v4]
        c53v6 = c53v7 + 1
        c53v5[c53v4] = c53v6
        do return c53v3 end
      end
    end
    c53v2 = nil
    do return c53v2 end
  end
  AIDirTrackAgent = v33
  v33 = function(c54v0, c54v1, c54v2, c54v3)
    local c54v4, c54v5, c54v6, c54v7, c54v8, c54v9, c54v10, c54v11, c54v12, c54v13, c54v14, c54v15
    local __renovice_state_0 = 0
    c54v4 = c54v0:GetAgent()
    c54v5 = IsNull
    c54v5 = c54v5(c54v4)
    if c54v5 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c54v5 = c54v4:GetType()
      if c54v5 ~= c54v1 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c54v5 = false
      do return c54v5 end
    end
    if __renovice_state_0 == 3 then
      c54v5 = c54v4:GetTypeRes()
      c54v6 = c54v0:GetDropTable()
      c54v7 = c54v4:IsIgnoredByAiDirector()
      c54v11 = c54v4:GetTeam()
      c54v12 = c54v0:GetOriginalFaction()
      c54v13 = false
      c54v0:ChangeAgent(c54v1, c54v11, c54v12, c54v13)
      c54v8 = c54v0:GetAgent()
      c54v9 = IsNull
      c54v9 = c54v9(c54v8)
      if not c54v9 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c54v9 = false
      do return c54v9 end
    end
    if __renovice_state_0 == 5 then
      c54v8:Name__58be31f8(c54v5)
      c54v0:SetDropTable(c54v6)
      c54v9 = c54v0:Name__fb8802b7()
      if (c54v9 or not c54v3) then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c54v12 = false
      c54v13 = 3
      c54v14 = 1
      c54v15 = true
      c54v0:Name__22f58ffd(c54v3, c54v12, c54v13, c54v14, c54v15)
      __renovice_state_0 = 8
    end
    if __renovice_state_0 == 8 then
      c54v9 = c54v0:InventoryControl()
      c54v9:RemoveAllItems()
      c54v9 = c54v0:IsHumanPlayer()
      if c54v9 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c54v11 = true
      c54v0:Name__ad4cecd5(c54v11)
      __renovice_state_0 = 10
    end
    if __renovice_state_0 == 10 then
      c54v9 = c54v0:GetDisarmWeapon()
      if c54v9 == nil then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c54v13 = true
      c54v0:GiveItem(c54v9, c54v13)
      __renovice_state_0 = 13
    end
    if __renovice_state_0 == 12 then
      c54v13 = true
      c54v0:GiveItem(c54v2, c54v13)
      __renovice_state_0 = 13
    end
    if __renovice_state_0 == 13 then
      c54v8:RefreshWeapon()
      c54v10 = c54v0:GetInstance()
      c54v11 = _T.aiDirTrackAgent
      if not c54v11 then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c54v12 = _T.aiDirTrackAgent
      c54v11 = c54v12[c54v10]
      if not c54v11 then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 15
      end
    end
    if __renovice_state_0 == 15 then
      c54v11 = gRegion
      c54v11 = c54v11:GetNpcMgr()
      c54v11 = c54v11:GetAiDirector()
      c54v11:UntrackAgent(c54v8)
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 16 then
      if not c54v7 then
        __renovice_state_0 = 18
      else
        __renovice_state_0 = 17
      end
    end
    if __renovice_state_0 == 17 then
      c54v13 = true
      c54v0:Name__da8f6dab(c54v13)
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 18 then
      c54v11 = true
      do return c54v11 end
    end
    do return end
  end
  ChangeAgent = v33
  v33 = function(c55v0, c55v1, c55v2)
    local c55v3, c55v4, c55v5, c55v6, c55v7, c55v8, c55v9, c55v10, c55v11, c55v12
    c55v3 = c55v0:DamageControl()
    c55v5 = 0
    c55v3 = c55v3:GetPartPosition(c55v5)
    c55v5 = c55v3.y
    c55v7 = c55v0:GetHeight()
    c55v6 = c55v7 * 0.5
    c55v4 = c55v5 - c55v6
    c55v3.y = c55v4
    c55v4 = Vector
    c55v4 = c55v4()
    c55v5 = gRegion
    c55v9 = c55v2 * c55v1
    c55v8 = c55v3 + c55v9
    c55v10 = nil
    c55v11 = true
    c55v12 = true
    c55v5 = c55v5:Raycast(c55v3, c55v8, c55v0, c55v10, c55v4, c55v11, c55v12)
    if c55v5 then
      c55v5 = Distance
      do return c55v5(c55v3, c55v4) end
    end
    c55v5 = 3.4028234663852886e+38
    do return c55v5 end
  end
  v34 = function(c56v0, c56v1, c56v2, c56v3, c56v4, c56v5, c56v6, c56v7)
    local c56v8, c56v9, c56v10, c56v11, c56v12, c56v13, c56v14, c56v15, c56v16, c56v17, c56v18, c56v19, c56v20, c56v21, c56v22, c56v23, c56v24, c56v25, c56v26, c56v27, c56v28, c56v29, c56v30, c56v31, c56v32, c56v33, c56v34, c56v35, c56v36, c56v37, c56v38
    c56v8 = c56v0:InventoryControl()
    c56v8 = c56v8:GetActivePowerSuit()
    c56v9 = IsNull
    c56v9 = c56v9(c56v8)
    if c56v9 then
      do return end
    end
    if not c56v5 then
      c56v5 = 4
    end
    if not c56v6 then
      c56v6 = 1
    end
    if c56v7 == nil then
      c56v7 = true
    end
    c56v9 = c56v8:Name__2a8fed57()
    c56v10 = c56v0:InventoryControl()
    c56v12 = 1
    c56v13 = 28
    c56v14 = c56v8:GetType()
    c56v10 = c56v10:GetUpgradeModifiedValue(c56v12, c56v13, c56v14, c56v8)
    c56v11 = 0
    c56v12 = IsNull
    c56v12 = c56v12(c56v1)
    c56v12 = v27
    c56v15 = false
    c56v16 = 2
    c56v17 = 3
    c56v18 = true
    c56v11 = c56v12(c56v8, c56v1, c56v15, c56v16, c56v17, c56v18)
    c56v12 = pairs
    c56v12, c56v13, c56v14 = c56v12(c56v4)
    for __renovice_for_0_0, __renovice_for_0_1 in c56v12, c56v13, c56v14 do
      c56v17 = IsNull
      c56v17 = c56v17(__renovice_for_0_0)
      if c56v17 then
        continue
      end
      c56v19 = __renovice_for_0_1[1]
      __renovice_for_0_0:Name__ab8ba30b(c56v19)
      c56v19 = false
      c56v20 = false
      c56v21 = false
      __renovice_for_0_0:TriggerAnimation(c56v19, c56v20, c56v21, c56v10)
    end
    for __renovice_for_1_0, __renovice_for_1_1 in c56v12, c56v13, c56v14 do
    end
    c56v12 = false
    c56v13 = 0
    c56v14 = IsNull
    c56v14 = c56v14(c56v2)
    if not c56v14 then
      c56v14 = c56v2:GetAnimationLength(c56v0:GetCinematicID())
      c56v17 = Symbol
      c56v15 = c56v2:GetEventTime(c56v17(c56v3))
      c56v13 = c56v14 * c56v15
      c56v14 = 0
      if c56v14 < c56v10 then
        c56v13 = c56v13 / c56v10
      end
    end
    c56v14 = c56v0:IsFalling()
    if c56v14 then
      local __renovice_state_0 = -1
      repeat
        c56v14 = c56v0:Name__ad7b05b3()
        c56v15 = c56v0:MotionControl()
        c56v16 = c56v0:GetCameraView()
        c56v18 = c56v16.pitch
        c56v19 = 40
        c56v17 = math.max
        c56v17 = c56v17(c56v18, c56v19)
        c56v16.pitch = c56v17
        c56v17 = AngleToDirection
        c56v17 = c56v17(c56v16)
        c56v18 = 10
        c56v19 = 0
        c56v20 = 0.4
        c56v21 = 0
        c56v22 = false
        c56v23 = Symbol
        c56v24 = "ABILITY_SLAM"
        c56v23 = c56v23(c56v24)
        c56v24 = 1
        c56v25 = c56v0:GetSimPosition()
        c56v25 = c56v25.y
        c56v26 = 0
        c56v27 = require
        c56v28 = "Lotus.Scripts.Libs.EasingLib"
        c56v27 = c56v27(c56v28)
        c56v30 = Rotation
        c56v31 = c56v16.heading
        c56v32 = 0
        c56v33 = 0
        c56v15:SetTorsoFromView(c56v30(c56v31, c56v32, c56v33))
        c56v30 = true
        c56v0:SetDisableGravity(c56v30)
        c56v28 = IsNull
        c56v28 = c56v28(c56v0)
        if c56v28 then
          __renovice_state_0 = 48
          break
        end
        c56v28 = c56v0:IsKilled()
        if c56v28 then
          __renovice_state_0 = 48
          break
        end
        c56v28 = c56v0:IsPreDeath()
        if c56v28 then
          __renovice_state_0 = 48
          break
        end
        c56v28 = c56v0:IsFalling()
        if not c56v28 then
          __renovice_state_0 = 48
          break
        end
        c56v28 = IsNull
        c56v28 = c56v28(c56v9)
        if c56v28 then
          __renovice_state_0 = 48
          break
        end
        c56v28 = c56v9:IsAbilityActivationBlocked()
        if c56v28 then
          __renovice_state_0 = 48
          break
        end
        if c56v12 then
          __renovice_state_0 = 33
          break
        end
        c56v28 = Sleep
        c56v29 = 0
        c56v28(c56v29)
        c56v28 = IsNull
        c56v28 = c56v28(c56v0)
        c56v28 = c56v0:GetSimPosition()
        c56v28 = c56v28.y
        c56v26 = c56v26 + 1
        c56v29 = 2
        if c56v29 < c56v26 then
          __renovice_state_0 = 48
          break
        end
        c56v26 = 0
        c56v25 = c56v28
        c56v28 = DeltaTime
        c56v28 = c56v28()
        c56v11 = c56v11 - c56v28
        c56v28 = IsNull
        c56v28 = c56v28(c56v2)
        if not c56v28 then
          c56v28 = c56v18 * c56v13
          c56v29 = v33
          c56v29 = c56v29(c56v0, c56v28, c56v17)
          c56v29 = v27
          c56v32 = false
          c56v29(c56v8, c56v2, c56v32, c56v5, c56v6, c56v7)
          c56v29 = pairs
          c56v29, c56v30, c56v31 = c56v29(c56v4)
          for __renovice_for_2_0, __renovice_for_2_1 in c56v29, c56v30, c56v31 do
            c56v34 = IsNull
            c56v34 = c56v34(__renovice_for_2_0)
            if c56v34 then
              continue
            end
            c56v36 = __renovice_for_2_1[2]
            __renovice_for_2_0:Name__ab8ba30b(c56v36)
            c56v36 = false
            c56v37 = false
            c56v38 = false
            __renovice_for_2_0:TriggerAnimation(c56v36, c56v37, c56v38, c56v10)
            c56v36 = false
            __renovice_for_2_0:PlayTriggeredFade(c56v36)
          end
          if __renovice_state_0 ~= -1 then break end
          c56v11 = c56v13
          c56v12 = true
          for __renovice_for_3_0, __renovice_for_3_1 in c56v29, c56v30, c56v31 do
          end
          if __renovice_state_0 ~= -1 then break end
        end
        c56v28 = 0
        if c56v28 < c56v20 then
          c56v30 = DeltaTime
          c56v30 = c56v30()
          c56v29 = c56v19 + c56v30
          c56v30 = 0.2
          c56v28 = math.min
          c56v19 = c56v28(c56v29, c56v30)
          c56v29 = 80
          c56v32 = 1
          c56v34 = c56v27.inQuad
          c56v36 = 0
          c56v37 = 10
          c56v38 = 0.2
          c56v34 = c56v34(c56v19, c56v36, c56v37, c56v38)
          c56v35 = DeltaTime
          c56v35 = c56v35()
          c56v33 = c56v34 * c56v35
          c56v31 = c56v32 + c56v33
          c56v30 = c56v18 * c56v31
          c56v28 = math.min
          c56v18 = c56v28(c56v29, c56v30)
          c56v28 = DeltaTime
          c56v28 = c56v28()
          c56v20 = c56v20 - c56v28
        else
          if not c56v22 then
            c56v30 = false
            c56v0:SetDisableGravity(c56v30)
            c56v22 = true
          end
          c56v32 = -1
          c56v0:AddGravityMultiplier(c56v23, c56v24, c56v32)
          c56v29 = DeltaTime
          c56v29 = c56v29()
          c56v28 = c56v29 * 0.3
          c56v24 = c56v24 + c56v28
          c56v30 = DeltaTime
          c56v30 = c56v30()
          c56v29 = c56v21 + c56v30
          c56v30 = 0.2
          c56v28 = math.min
          c56v21 = c56v28(c56v29, c56v30)
          c56v29 = 0
          c56v33 = c56v27.outQuad
          c56v35 = 0
          c56v36 = 0.7
          c56v37 = 0.2
          c56v33 = c56v33(c56v21, c56v35, c56v36, c56v37)
          c56v34 = DeltaTime
          c56v34 = c56v34()
          c56v32 = c56v33 * c56v34
          c56v31 = 1 - c56v32
          c56v30 = c56v18 * c56v31
          c56v28 = math.max
          c56v18 = c56v28(c56v29, c56v30)
        end
        if c56v14 then
          c56v30 = c56v17 * c56v18
          c56v15:SetPushVelocity(c56v30)
        end
        c56v28 = 0
        break
      until true
      do
        local __renovice_unused_condition_0 = __renovice_state_0 == 33
      end
      if c56v14 then
        c56v28 = IsNull
        c56v28 = c56v28(c56v15)
        if not c56v28 then
          c56v30 = ZERO_VECTOR
          c56v15:SetPushVelocity(c56v30)
        end
      end
      c56v28 = IsNull
      c56v28 = c56v28(c56v9)
      if not c56v28 then
        c56v28 = c56v9:IsAbilityActivationBlocked()
        if c56v28 then
          if c56v14 then
            c56v8:DeactivateAbility(c56v9:GetType())
          end
          c56v28 = false
          do return c56v28 end
        end
      end
      c56v28 = IsNull
      c56v28 = c56v28(c56v0)
      if not c56v28 then
        c56v28 = IsInTeleportVolume
        c56v28 = c56v28(c56v0)
        if c56v28 then
          c56v28 = false
          do return c56v28 end
        end
      end
    end
    c56v14 = 0
    if c56v14 < c56v11 then
      c56v14 = Sleep
      c56v14(c56v11)
    end
    if not c56v12 then
      c56v14 = IsNull
      c56v14 = c56v14(c56v2)
      c56v14 = v27
      c56v17 = false
      c56v14(c56v8, c56v2, c56v17, c56v5, c56v6, c56v7)
      c56v14 = pairs
      c56v14, c56v15, c56v16 = c56v14(c56v4)
      for __renovice_for_4_0, __renovice_for_4_1 in c56v14, c56v15, c56v16 do
        c56v19 = IsNull
        c56v19 = c56v19(__renovice_for_4_0)
        if c56v19 then
          continue
        end
        c56v21 = __renovice_for_4_1[2]
        __renovice_for_4_0:Name__ab8ba30b(c56v21)
        c56v21 = false
        c56v22 = false
        c56v23 = false
        __renovice_for_4_0:TriggerAnimation(c56v21, c56v22, c56v23, c56v10)
        c56v21 = false
        __renovice_for_4_0:PlayTriggeredFade(c56v21)
      end
      c56v14 = Sleep
      c56v14(c56v13)
      for __renovice_for_5_0, __renovice_for_5_1 in c56v14, c56v15, c56v16 do
      end
    end
    c56v14 = true
    do return c56v14 end
  end
  SlamToGround = v34
  v34 = function(c57v0, c57v1, c57v2, c57v3, c57v4, c57v5, c57v6)
    local c57v7, c57v8, c57v9, c57v10, c57v11, c57v12, c57v13
    c57v7 = IsNull
    c57v7 = c57v7(c57v0)
    if c57v7 then
      do return end
    end
    if not c57v5 then
      c57v5 = 1
    end
    if c57v6 == nil then
      c57v6 = true
    end
    if not c57v4 then
      c57v4 = 4
    end
    c57v7 = c57v0:Name__ad7b05b3()
    if c57v7 then
      c57v7 = c57v0:MotionControl()
      c57v9 = ZERO_VECTOR
      c57v7:SetPushVelocity(c57v9)
    end
    c57v9 = Symbol
    c57v10 = "ABILITY_SLAM"
    c57v0:RemoveGravityMultiplier(c57v9(c57v10))
    c57v9 = false
    c57v0:SetDisableGravity(c57v9)
    c57v7 = c57v0:InventoryControl()
    c57v7 = c57v7:GetActivePowerSuit()
    c57v8 = IsNull
    c57v8 = c57v8(c57v7)
    if not c57v8 then
      c57v8 = IsNull
      c57v8 = c57v8(c57v1)
      if not c57v8 then
        repeat
          c57v8 = c57v0:IsAnimationStarting(c57v1)
          if not c57v8 then
            c57v11 = true
            c57v8 = c57v0:IsPlayingAnimation(c57v1, c57v11)
            if not c57v8 then break end
          end
          c57v8 = IsNull
          c57v8 = c57v8(c57v2)
          if not c57v8 then
            c57v8 = c57v0:IsAnimationStarting(c57v2)
            if not c57v8 then
              c57v8 = c57v0:IsPlayingAnimation(c57v2)
              if not c57v8 then
                c57v8 = v27
                c57v11 = false
                c57v8(c57v7, c57v2, c57v11, c57v4, c57v5, c57v6)
                c57v8 = ipairs
                c57v8, c57v9, c57v10 = c57v8(c57v3)
                for __renovice_for_0_0, __renovice_for_0_1 in c57v8, c57v9, c57v10 do
                  c57v12 = IsNull
                  c57v12 = c57v12(__renovice_for_0_1)
                  if c57v12 then
                    continue
                  end
                  __renovice_for_0_1:Name__f0d1f54b()
                  c57v12 = __renovice_for_0_1:IsTriggeredFadePlaying()
                  if c57v12 then
                    continue
                  end
                  c57v13 = false
                  __renovice_for_0_1:PlayTriggeredFade(c57v13)
                end
              end
            end
          end
        until true
      end
    end
    do return end
  end
  StopSlamToGround = v34
  v34 = function(c58v0, c58v1, c58v2)
    local c58v3, c58v4, c58v5, c58v6, c58v7, c58v8
    c58v3 = IsNull
    c58v3 = c58v3(c58v1)
    if not c58v3 then
      c58v3 = IsNull
      c58v3 = c58v3(c58v2)
      if not c58v3 then
        c58v3 = _T.AllyBuffs
        if c58v3 then
          c58v3 = c58v1:GetInstance()
          c58v5 = _T.AllyBuffs
          c58v4 = c58v5[c58v3]
          if c58v4 then
            c58v5 = type
            c58v5 = c58v5(c58v0)
            if c58v5 ~= "string" then
              c58v0 = c58v0:c_str()
            end
            c58v6 = c58v4.buffs
            c58v5 = c58v6[c58v0]
            if c58v5 then
              c58v8 = c58v2:GetInstance()
              c58v7 = c58v5[c58v8]
              if c58v7 == nil then
                c58v6 = false
                do return c58v6 end
              end
              c58v6 = true
              do return c58v6 end
            end
          end
        end
        c58v3 = false
        do return c58v3 end
      end
    end
    c58v3 = false
    do return c58v3 end
  end
  v35 = function(c59v0, c59v1, c59v2)
    local c59v3
    c59v3 = v34
    c59v3 = c59v3(c59v0, c59v1, c59v2)
    do return c59v3 end
  end
  IsBuffTracked = v35
  v35 = function(c60v0, c60v1, c60v2)
    local c60v3, c60v4, c60v5, c60v6
    c60v3 = gRegion
    c60v3 = c60v3:IsMaster()
    if c60v3 then
      c60v3 = IsNull
      c60v3 = c60v3(c60v1)
      if not c60v3 then
        c60v3 = IsNull
        c60v3 = c60v3(c60v2)
        if not c60v3 then
          c60v3 = IsNull
          c60v3 = c60v3(c60v2:Name__2d897740())
          if not c60v3 then
            c60v3 = c60v1:Name__4276cc23(c60v2)
            if c60v3 then
              c60v3 = _T.AllyBuffs
              if not c60v3 then
                c60v3 = _T
                c60v4 = {}
                c60v3.AllyBuffs = c60v4
              end
              c60v3 = c60v1:GetInstance()
              c60v5 = _T.AllyBuffs
              c60v4 = c60v5[c60v3]
              if not c60v4 then
                c60v5 = { source = nil, buffs = nil }
                c60v5.source = c60v1
                c60v6 = {}
                c60v5.buffs = c60v6
                c60v4 = c60v5
                c60v5 = _T.AllyBuffs
                c60v5[c60v3] = c60v4
              end
              c60v5 = type
              c60v5 = c60v5(c60v0)
              if c60v5 ~= "string" then
                c60v0 = c60v0:c_str()
              end
              c60v6 = c60v4.buffs
              c60v5 = c60v6[c60v0]
              if not c60v5 then
                c60v5 = {}
                c60v6 = c60v4.buffs
                c60v6[c60v0] = c60v5
              end
              c60v6 = c60v2:GetInstance()
              c60v5[c60v6] = c60v2
              do return end
            end
          end
        end
      end
    end
    do return end
  end
  v36 = function(c61v0, c61v1, c61v2)
    local c61v3
    c61v3 = v35
    c61v3(c61v0, c61v1, c61v2)
    do return end
  end
  TrackBuff = v36
  v36 = function(c62v0, c62v1, c62v2)
    local c62v3, c62v4, c62v5, c62v6, c62v7, c62v8, c62v9, c62v10, c62v11, c62v12, c62v13, c62v14
    c62v3 = gRegion
    c62v3 = c62v3:IsMaster()
    if c62v3 then
      c62v3 = _T.AllyBuffs
      if c62v3 then
        c62v3 = pairs
        c62v4 = _T.AllyBuffs
        c62v3, c62v4, c62v5 = c62v3(c62v4)
        for __renovice_for_0_0, __renovice_for_0_1 in c62v3, c62v4, c62v5 do
          c62v9 = __renovice_for_0_1.source
          c62v8 = IsNull
          c62v8 = c62v8(c62v9)
          if c62v8 then
            c62v8 = _T.AllyBuffs
            c62v9 = nil
            c62v8[__renovice_for_0_0] = c62v9
            continue
          end
          c62v8 = pairs
          c62v9 = __renovice_for_0_1.buffs
          c62v8, c62v9, c62v10 = c62v8(c62v9)
          for __renovice_for_1_0, __renovice_for_1_1 in c62v8, c62v9, c62v10 do
            c62v11 = pairs
            c62v11, c62v12, c62v13 = c62v11(__renovice_for_1_1)
            for __renovice_for_2_0, __renovice_for_2_1 in c62v11, c62v12, c62v13 do
              repeat
                c62v14 = IsNull
                c62v14 = c62v14(__renovice_for_2_1)
                if not c62v14 then
                  c62v14 = __renovice_for_2_1:IsKilled()
                  if not c62v14 then break end
                end
                c62v14 = nil
                __renovice_for_1_1[__renovice_for_2_0] = c62v14
              until true
            end
            c62v11 = next
            c62v11 = c62v11(__renovice_for_1_1)
            if c62v11 then
              continue
            end
            c62v11 = __renovice_for_0_1.buffs
            c62v12 = nil
            c62v11[__renovice_for_1_0] = c62v12
          end
          c62v8 = next
          c62v9 = __renovice_for_0_1.buffs
          c62v8 = c62v8(c62v9)
          if c62v8 then
            continue
          end
          c62v8 = _T.AllyBuffs
          c62v9 = nil
          c62v8[__renovice_for_0_0] = c62v9
        end
        c62v3 = IsNull
        c62v3 = c62v3(c62v1)
        if not c62v3 then
          c62v3 = IsNull
          c62v3 = c62v3(c62v2)
          if not c62v3 then
            c62v3 = c62v1:GetInstance()
            c62v5 = _T.AllyBuffs
            c62v4 = c62v5[c62v3]
            if not c62v4 then
              do return end
            end
            c62v5 = type
            c62v5 = c62v5(c62v0)
            if c62v5 ~= "string" then
              c62v0 = c62v0:c_str()
            end
            c62v6 = c62v4.buffs
            c62v5 = c62v6[c62v0]
            if not c62v5 then
              do return end
            end
            c62v6 = c62v2:GetInstance()
            c62v7 = nil
            c62v5[c62v6] = c62v7
            c62v6 = next
            c62v6 = c62v6(c62v5)
            if not c62v6 then
              c62v6 = c62v4.buffs
              c62v7 = nil
              c62v6[c62v0] = c62v7
              c62v6 = next
              c62v7 = c62v4.buffs
              c62v6 = c62v6(c62v7)
              if not c62v6 then
                c62v6 = _T.AllyBuffs
                c62v7 = nil
                c62v6[c62v3] = c62v7
                c62v6 = next
                c62v7 = _T.AllyBuffs
                c62v6 = c62v6(c62v7)
                if not c62v6 then
                  c62v6 = _T
                  c62v7 = nil
                  c62v6.AllyBuffs = c62v7
                end
              end
            end
            do return end
          end
        end
        do return end
      end
    end
    do return end
  end
  v37 = function(c63v0, c63v1, c63v2)
    local c63v3
    c63v3 = v36
    c63v3(c63v0, c63v1, c63v2)
    do return end
  end
  UntrackBuff = v37
  v37 = function(c64v0, c64v1)
    local c64v2, c64v3, c64v4, c64v5
    c64v2 = _T.AllyBuffs
    if c64v2 then
      c64v2 = IsNull
      c64v2 = c64v2(c64v1)
      if not c64v2 then
        c64v2 = c64v1:GetInstance()
        c64v4 = _T.AllyBuffs
        c64v3 = c64v4[c64v2]
        if not c64v3 then
          do return end
        end
        c64v4 = type
        c64v4 = c64v4(c64v0)
        if c64v4 ~= "string" then
          c64v0 = c64v0:c_str()
        end
        c64v4 = c64v3.buffs
        c64v5 = nil
        c64v4[c64v0] = c64v5
        c64v4 = next
        c64v5 = c64v3.buffs
        c64v4 = c64v4(c64v5)
        if not c64v4 then
          c64v4 = _T.AllyBuffs
          c64v5 = nil
          c64v4[c64v2] = c64v5
          c64v4 = next
          c64v5 = _T.AllyBuffs
          c64v4 = c64v4(c64v5)
          if not c64v4 then
            c64v4 = _T
            c64v5 = nil
            c64v4.AllyBuffs = c64v5
          end
        end
        do return end
      end
    end
    do return end
  end
  ClearTrackedBuffs = v37
  v37 = function(c65v0, c65v1, c65v2, c65v3, c65v4, c65v5, c65v6, c65v7)
    local c65v8, c65v9, c65v10, c65v11, c65v12, c65v13, c65v14, c65v15, c65v16, c65v17, c65v18, c65v19, c65v20, c65v21, c65v22, c65v23, c65v24, c65v25, c65v26, c65v27, c65v28, c65v29, c65v30, c65v31
    local __renovice_state_0 = -1
    c65v8 = c65v1:GetUniquePowerIdentifier()
    c65v9 = c65v1:GetSuit()
    c65v9 = c65v9:GetAvatarOwner()
    c65v11 = c65v8:c_str()
    c65v13 = "_"
    c65v10 = c65v11 .. c65v2 .. c65v13
    c65v11 = c65v0:InventoryControl()
    c65v13 = 0
    c65v14 = 1
    c65v15 = 5
    c65v16 = 7
    c65v12 = {c65v13, c65v14, c65v15, c65v16}
    c65v13 = {}
    c65v14 = 357
    c65v15 = 3
    if c65v2 == c65v15 then
      __renovice_state_0 = -1
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c65v15 = 4
      if c65v2 == c65v15 then
        __renovice_state_0 = -1
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c65v15 = 5
      if c65v2 == c65v15 then
        __renovice_state_0 = -1
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c65v15 = 6
      if c65v2 ~= c65v15 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = -1
      end
    end
    if __renovice_state_0 ~= 4 then
      c65v14 = 358
    end
    c65v15 = v35
    c65v15(c65v8, c65v9, c65v0)
    c65v16 = c65v0:IsHumanPlayer()
    c65v15 = not c65v16
    if c65v15 then
      c65v17 = gLotusNpcAvatarType
      c65v15 = c65v0:IsA(c65v17)
      if c65v15 then
        c65v16 = IsNull
        c65v16 = c65v16(c65v0:Name__657ea90f())
        c65v15 = not c65v16
      end
    end
    c65v16 = ipairs
    c65v16, c65v17, c65v18 = c65v16(c65v12)
    for __renovice_for_0_0, __renovice_for_0_1 in c65v16, c65v17, c65v18 do
      c65v21 = c65v11:GetWeaponInSlot(__renovice_for_0_1)
      c65v22 = IsNull
      c65v22 = c65v22(c65v21)
      if c65v22 then
        continue
      end
      c65v22 = c65v21:IsAbilityWeapon()
      if (not c65v22 or c65v15) then
        c65v22 = c65v21:GetType()
        c65v23 = Symbol
        c65v24 = c65v10 .. __renovice_for_0_0
        c65v23 = c65v23(c65v24)
        c65v26 = { sym = nil, type = nil }
        c65v26.sym = c65v23
        c65v26.type = c65v22
        c65v24 = table.insert
        c65v24(c65v13, c65v26)
        c65v28 = 0
        c65v31 = nil
        c65v11:Name__90fde101(c65v23, c65v14, c65v28, c65v3, c65v22, c65v31, c65v2)
      end
    end
    repeat
      c65v19 = Symbol
      c65v20 = "GAME_R1_WEAPON1"
      c65v16 = c65v0:Attach(c65v5, c65v19(c65v20))
      c65v17 = Lotus_Game.BuffNotification
      c65v17 = c65v17()
      c65v18 = c65v1:GetSuit()
      c65v18 = c65v18:GetAvatarOwner()
      c65v17.instigator = c65v18
      c65v18 = {c65v0}
      c65v17.affected = c65v18
      if c65v6 then
        c65v18 = c65v6
        if c65v18 then break end
      end
      c65v18 = c65v1:GetType()
    until true
    c65v17.abilityType = c65v18
    c65v18 = 3
    c65v17.buffType = c65v18
    c65v17.buffData = c65v4
    if not c65v6 then
      c65v18 = 1
      c65v17.augmentType = c65v18
    end
    c65v18 = c65v3 * 100
    c65v17.buffDataExtra = c65v18
    c65v17.buffDesc = c65v7
    c65v21 = true
    c65v22 = true
    c65v0:ProcessBuffNotification(c65v17, c65v21, c65v22)
    while true do
      c65v18 = 0
      if not (c65v18 < c65v4) then break end
      c65v18 = IsNull
      c65v18 = c65v18(c65v0)
      if c65v18 then break end
      c65v18 = c65v0:IsKilled()
      if c65v18 then break end
      c65v18 = IsNull
      c65v18 = c65v18(c65v1)
      if c65v18 then break end
      c65v18 = c65v1:IsAvatarBlocked(c65v0)
      if c65v18 then break end
      c65v18 = Sleep
      c65v19 = 0
      c65v18(c65v19)
      c65v18 = DeltaTime
      c65v18 = c65v18()
      c65v4 = c65v4 - c65v18
    end
    c65v18 = IsNull
    c65v18 = c65v18(c65v0)
    if not c65v18 then
      c65v18 = 0
      if c65v18 < c65v4 then
        c65v21 = false
        c65v22 = true
        c65v0:ProcessBuffNotification(c65v17, c65v21, c65v22)
      end
      c65v18 = ipairs
      c65v18, c65v19, c65v20 = c65v18(c65v13)
      for __renovice_for_1_0, __renovice_for_1_1 in c65v18, c65v19, c65v20 do
        c65v25 = __renovice_for_1_1.sym
        c65v27 = 0
        c65v29 = __renovice_for_1_1.type
        c65v30 = nil
        c65v11:Name__1747aac8(c65v25, c65v14, c65v27, c65v3, c65v29, c65v30, c65v2)
      end
      c65v18 = IsNull
      c65v18 = c65v18(c65v16)
      if not c65v18 then
        c65v16:Destroy()
      end
      c65v18 = v36
      c65v18(c65v8, c65v9, c65v0)
    end
    do return end
  end
  DoElementAugment = v37
  v37 = function(c66v0, c66v1, c66v2)
    local c66v3, c66v4, c66v5, c66v6, c66v7, c66v8, c66v9, c66v10, c66v11, c66v12, c66v13, c66v14, c66v15, c66v16, c66v17, c66v18
    c66v3 = c66v0:GetSuit()
    c66v4 = c66v3:GetAvatarOwner()
    c66v5 = c66v4:DamageControl()
    c66v6 = {}
    c66v9 = 1
    c66v7 = 4
    c66v8 = 1
    for __renovice_for_0_0 = c66v9, c66v7, c66v8 do
      c66v12 = { time = 0, health = 1 }
      c66v10 = table.insert
      c66v10(c66v6, c66v12)
    end
    c66v7 = nil
    c66v8 = nil
    c66v9 = nil
    c66v10 = nil
    c66v11 = nil
    c66v12 = nil
    while true do
      c66v13 = IsNull
      c66v13 = c66v13(c66v3)
      if c66v13 then break end
      c66v13 = IsNull
      c66v13 = c66v13(c66v0)
      if c66v13 then break end
      c66v13 = c66v4:IsKilled()
      if c66v13 then break end
      c66v13 = c66v0:IsActive()
      if not c66v13 then
        c66v13 = c66v4:GetMaxHealth()
        c66v14 = c66v5:GetMaxShield()
        c66v8 = c66v13 + c66v14
        c66v13 = c66v4:GetHealth()
        c66v14 = c66v5:GetShield()
        c66v7 = c66v13 + c66v14
        c66v9 = c66v7 / c66v8
        c66v13 = Time
        c66v10 = c66v13()
        c66v11 = c66v10 - 2
        c66v15 = 4
        c66v13 = 1
        c66v14 = -1
        for __renovice_for_1_0 = c66v15, c66v13, c66v14 do
          c66v12 = c66v6[__renovice_for_1_0]
          c66v16 = c66v12.time
          if c66v16 < c66v11 then
            break
          else
            c66v17 = c66v12.health
            c66v16 = c66v17 - c66v9
            c66v17 = 0.1
            if not (c66v17 <= c66v16) then
              continue
            end
            c66v16 = { time = nil, health = nil }
            c66v16.time = c66v10
            c66v16.health = c66v9
            c66v6[4] = c66v16
            c66v18 = 0
            c66v0:SetCooldownTime(c66v18)
            break
          end
        end
        c66v14 = c66v6[4]
        c66v14 = c66v14.time
        c66v13 = c66v14 + 1
        if c66v13 < c66v10 then
          c66v13 = table.remove
          c66v15 = 1
          c66v13(c66v6, c66v15)
          c66v15 = { time = nil, health = nil }
          c66v15.time = c66v10
          c66v15.health = c66v9
          c66v13 = table.insert
          c66v13(c66v6, c66v15)
        end
      end
      c66v13 = Sleep
      c66v14 = 0.1
      c66v13(c66v14)
    end
    do return end
  end
  ClearCooldownOnDamage = v37
  v37 = function(c67v0, c67v1)
    local c67v2, c67v3, c67v4, c67v5, c67v6, c67v7, c67v8, c67v9, c67v10, c67v11
    c67v2 = c67v0:InventoryControl()
    c67v5 = 0
    c67v6 = 14
    c67v3 = c67v6 - 1
    c67v4 = 1
    for __renovice_for_0_0 = c67v5, c67v3, c67v4 do
      c67v6 = c67v2:GetWeaponInSlot(__renovice_for_0_0)
      c67v7 = IsNull
      c67v7 = c67v7(c67v6)
      if c67v7 then
        continue
      end
      c67v9 = 1
      c67v10 = 0
      c67v7 = c67v6:GetAttachmentEntity(c67v9, c67v10)
      c67v8 = IsNull
      c67v8 = c67v8(c67v7)
      if not c67v8 then
        c67v7:SetPhysicsEnabled(c67v1)
      end
      c67v10 = 1
      c67v11 = 1
      c67v8 = c67v6:GetAttachmentEntity(c67v10, c67v11)
      c67v9 = IsNull
      c67v9 = c67v9(c67v8)
      if c67v9 then
        continue
      end
      c67v8:SetPhysicsEnabled(c67v1)
    end
    do return end
  end
  EnableWeaponAttachmentPhysics = v37
  v37 = function(c68v0, c68v1, c68v2, c68v3, c68v4)
    local c68v5
    c68v5 = v1
    c68v5 = c68v5.GiveEnergy
    c68v5(c68v0, c68v1, c68v2, c68v3, c68v4)
    do return end
  end
  GiveEnergy = v37
  v37 = function(c69v0, c69v1, c69v2, c69v3, c69v4)
    local c69v5
    c69v5 = v1
    c69v5 = c69v5.HealShield
    c69v5(c69v0, c69v1, c69v2, c69v3, c69v4)
    do return end
  end
  HealShield = v37
  v37 = function(c70v0, c70v1, c70v2)
    local c70v3, c70v4, c70v5, c70v6, c70v7, c70v8
    c70v3 = 0
    if not (c70v1 <= c70v3) then
      c70v3 = IsNull
      c70v3 = c70v3(c70v0)
      if not c70v3 then
        c70v3 = true
        c70v4 = c70v0:IsHumanPlayer()
        if not c70v4 then
          c70v0 = c70v0:GetSpawnedByAvatar()
          if c70v2 ~= true then
            c70v3 = false
          else
            c70v3 = true
          end
        end
        c70v4 = IsNull
        c70v4 = c70v4(c70v0)
        if not c70v4 then
          c70v4 = c70v0:IsHumanPlayer()
          if c70v4 then
            c70v4 = c70v0:GetPlayer()
            c70v5 = c70v4:GetStats()
            c70v6 = IsNull
            c70v6 = c70v6(c70v5)
            if not c70v6 then
              c70v5:Name__6818735f(c70v1)
            end
            if c70v3 then
              c70v6 = gChallengeMgr
              c70v7 = Symbol
              c70v8 = "HEALED_ABILITY"
              c70v6:Name__1240e42e(c70v4, c70v7(c70v8))
            end
          end
        end
        do return end
      end
    end
    do return end
  end
  NotifyHeal = v37
  v37 = function(c71v0, c71v1, c71v2, c71v3)
    local c71v4, c71v5, c71v6, c71v7, c71v8, c71v9, c71v10, c71v11, c71v12, c71v13
    c71v4 = c71v1:GetPosition()
    c71v5 = gRegion
    c71v9 = ZERO_ROTATION
    c71v5 = c71v5:CreateEntity(c71v0, c71v4, c71v9)
    c71v5:Name__f0ee782a(c71v1)
    c71v5:SetSourceObject(c71v2)
    c71v6 = c71v3
    c71v7 = IsNull
    c71v7 = c71v7(c71v6)
    if c71v7 then
      c71v7 = Vector
      c71v9 = Random
      c71v10 = 0
      c71v11 = 2
      c71v9 = c71v9(c71v10, c71v11)
      c71v8 = c71v9 - 1
      c71v9 = 0
      c71v11 = Random
      c71v12 = 0
      c71v13 = 2
      c71v11 = c71v11(c71v12, c71v13)
      c71v10 = c71v11 - 1
      c71v7 = c71v7(c71v8, c71v9, c71v10)
      c71v8 = Normalize
      c71v8(c71v7)
      c71v9 = Vector
      c71v10 = 0
      c71v11 = 1
      c71v12 = 0
      c71v9 = c71v9(c71v10, c71v11, c71v12)
      c71v10 = Random
      c71v11 = 5
      c71v12 = 10
      c71v10 = c71v10(c71v11, c71v12)
      c71v8 = c71v9 * c71v10
      c71v10 = Random
      c71v11 = 1
      c71v12 = 2
      c71v10 = c71v10(c71v11, c71v12)
      c71v9 = c71v7 * c71v10
      c71v6 = c71v8 + c71v9
    end
    c71v10 = 2
    c71v5:ApplyForce(c71v6, c71v10)
    c71v5:SetInitialVelocity(c71v6)
    do return c71v5 end
  end
  CreatePickup = v37
  v37 = function(c72v0)
    local c72v1, c72v2, c72v3, c72v4, c72v5, c72v6, c72v7, c72v8, c72v9, c72v10, c72v11
    c72v1 = 0
    c72v2 = 0
    c72v3 = {}
    c72v4 = Engine.Name__47432c06
    c72v4 = c72v4()
    if c72v4 then
      c72v4 = IsNull
      c72v4 = c72v4(c72v0)
      if not c72v4 then
        c72v4 = c72v0:GetAvatarOwner()
        c72v5 = IsNull
        c72v5 = c72v5(c72v4)
        if not c72v5 then
          c72v5 = c72v4:GetNextShotDamageBonus(c72v0:IsMeleeWeapon())
          c72v6 = c72v5.mAmount
          c72v7 = 0
          if c72v7 < c72v6 then
            c72v6 = table.insert
            c72v6(c72v3, c72v5)
          end
          c72v6 = c72v4:Name__0f8285ad()
          c72v2 = c72v2 + c72v6
          c72v7 = c72v4:GetNextShotDamageMultiplier(c72v0:IsMeleeWeapon())
          c72v6 = c72v7 - 1
          c72v1 = c72v1 + c72v6
        end
        c72v5 = c72v0:GetFiringAvatar()
        c72v6 = IsNull
        c72v6 = c72v6(c72v5)
        if (not c72v6 and c72v5 ~= c72v4) then
          c72v6 = c72v5:GetNextShotDamageBonus(c72v0:IsMeleeWeapon())
          c72v7 = c72v6.mAmount
          c72v8 = 0
          if c72v8 < c72v7 then
            c72v7 = table.insert
            c72v7(c72v3, c72v6)
          end
          c72v7 = c72v5:Name__0f8285ad()
          c72v2 = c72v2 + c72v7
          c72v8 = c72v5:GetNextShotDamageMultiplier(c72v0:IsMeleeWeapon())
          c72v7 = c72v8 - 1
          c72v1 = c72v1 + c72v7
        end
        c72v6 = c72v0:Name__966adec2()
        c72v7 = ipairs
        c72v7, c72v8, c72v9 = c72v7(c72v6)
        for __renovice_for_0_0, __renovice_for_0_1 in c72v7, c72v8, c72v9 do
          c72v10 = __renovice_for_0_1.mAmount
          c72v11 = 0
          if not (c72v11 < c72v10) then
            continue
          end
          c72v10 = table.insert
          c72v10(c72v3, __renovice_for_0_1)
        end
        c72v8 = c72v0:GetNextShotDamageMultiplier()
        c72v7 = c72v8 - 1
        c72v1 = c72v1 + c72v7
      end
    end
    c72v4 = Engine.UpgradedValue
    c72v5 = 0
    c72v4 = c72v4(c72v5)
    c72v7 = 3
    c72v4:AddModifier(c72v7, c72v1)
    do return c72v4, c72v2, c72v3 end
  end
  GetNextShotBonusesAndMultipliers = v37
  v37 = function(c73v0)
    local c73v1, c73v2, c73v3
    c73v1 = IsNull
    c73v1 = c73v1(c73v0)
    if c73v1 then
      c73v1 = false
      do return c73v1 end
    end
    c73v3 = c73v0.Ability
    c73v2 = IsNull
    c73v2 = c73v2(c73v3)
    c73v1 = not c73v2
    if c73v1 then
      c73v1 = c73v0.Ability
      c73v1 = c73v1:IsAbilityOverride()
      if not c73v1 then
        c73v1 = c73v0.ForceOverride
      end
    end
    do return c73v1 end
  end
  IsAbilityOverridden = v37
  v37 = function(c74v0)
    local c74v1, c74v2, c74v3, c74v4, c74v5, c74v6, c74v7
    c74v1 = IsNull
    c74v1 = c74v1(c74v0)
    if not c74v1 then
      c74v1 = c74v0:GetInstance()
      c74v2 = _T.FreeAbilityCasts
      if c74v2 ~= nil then
        c74v3 = _T.FreeAbilityCasts
        c74v2 = c74v3[c74v1]
        if c74v2 ~= nil then
          c74v2 = pairs
          c74v5 = _T.FreeAbilityCasts
          c74v3 = c74v5[c74v1]
          c74v3 = c74v3.FreeCasts
          c74v2, c74v3, c74v4 = c74v2(c74v3)
          for __renovice_for_0_0, __renovice_for_0_1 in c74v2, c74v3, c74v4 do
            c74v6 = __renovice_for_0_1.Count
            c74v7 = 0
            if not (c74v7 < c74v6) then
              continue
            end
            c74v6 = true
            do return c74v6 end
          end
        end
      end
    end
    c74v1 = false
    do return c74v1 end
  end
  IsFreeCast = v37
  v37 = function(c75v0)
    local c75v1, c75v2, c75v3, c75v4, c75v5, c75v6
    c75v1 = IsNull
    c75v1 = c75v1(c75v0)
    if c75v1 then
      c75v1 = false
      do return c75v1 end
    end
    c75v1 = c75v0:GetPlayer()
    c75v3 = IsNull
    c75v3 = c75v3(c75v1)
    c75v2 = not c75v3
    if c75v2 then
      c75v4 = _T.SecondChanceProgress
      c75v3 = IsNull
      c75v3 = c75v3(c75v4)
      c75v2 = not c75v3
      if c75v2 then
        c75v5 = _T.SecondChanceProgress
        c75v6 = c75v1:GetPlayerID()
        c75v4 = c75v5[c75v6]
        c75v3 = IsNull
        c75v3 = c75v3(c75v4)
        c75v2 = not c75v3
      end
    end
    do return c75v2 end
  end
  IsInSecondChance = v37
  v37 = function(c76v0)
    local c76v1, c76v2, c76v3, c76v4, c76v5, c76v6, c76v7, c76v8, c76v9, c76v10, c76v11, c76v12
    local __renovice_state_0 = 0
    c76v1 = WeakResource
    c76v2 = "/Lotus/Powersuits/Pacifist/PacifistBaseSuit"
    c76v1 = c76v1(c76v2)
    c76v2 = WeakResource
    c76v3 = "/Lotus/Powersuits/Runner/RunnerBaseSuit"
    c76v2 = c76v2(c76v3)
    c76v3 = WeakResource
    c76v4 = "/Lotus/Powersuits/Infestation/InfestationBaseSuit"
    c76v3 = c76v3(c76v4)
    c76v4 = WeakResource
    c76v5 = "/Lotus/Powersuits/Wraith/WraithBaseSuit"
    c76v4 = c76v4(c76v5)
    c76v5 = c76v0:IsA(c76v1)
    if not c76v5 then
      __renovice_state_0 = 6
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c76v5 = _T.PACIFIST_AddEdge
      if not c76v5 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c76v5 = c76v0:GetAvatarOwner()
      c76v6 = c76v5:GetInstance()
      c76v8 = _T.pacifistPassive
      if not c76v8 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c76v8 = _T.pacifistPassive
      c76v7 = c76v8[c76v6]
      if c76v7 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c76v7 = 0
      __renovice_state_0 = 5
    end
    if __renovice_state_0 == 5 then
      c76v8 = _T.PACIFIST_AddEdge
      c76v12 = _T.PACIFIST_MaxEdge
      c76v11 = c76v12 * 0.5
      c76v10 = c76v11 - c76v7
      c76v8(c76v5, c76v10)
      do return end
    end
    if __renovice_state_0 == 6 then
      c76v5 = c76v0:IsA(c76v2)
      if not c76v5 then
        __renovice_state_0 = 9
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c76v5 = _T.RUNNER_IncreaseGauge
      if not c76v5 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      c76v5 = _T.RUNNER_GetGauge
      c76v7 = true
      c76v5 = c76v5(c76v0, c76v7)
      c76v6 = _T.RUNNER_IncreaseGauge
      c76v8 = 0.5 - c76v5
      c76v9 = true
      c76v6(c76v0, c76v8, c76v9)
      do return end
    end
    if __renovice_state_0 == 9 then
      c76v5 = c76v0:IsA(c76v3)
      if not c76v5 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      c76v5 = _T.INFESTED_AddStacks
      if not c76v5 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c76v5 = _T.INFESTED_GetMaxStacks
      c76v5 = c76v5(c76v0)
      c76v6 = _T.INFESTED_GetStacks
      c76v6 = c76v6(c76v0)
      c76v7 = _T.INFESTED_AddStacks
      c76v12 = c76v5 * 0.5
      c76v11 = c76v12 + 0.5
      c76v10 = math.floor
      c76v10 = c76v10(c76v11)
      c76v9 = c76v10 - c76v6
      c76v7(c76v0, c76v9)
      do return end
    end
    if __renovice_state_0 == 12 then
      c76v5 = c76v0:IsA(c76v4)
      if not c76v5 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      c76v5 = _T.WRAITH_AddMeter
      if not c76v5 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c76v5 = _T.WRAITH_GetMeter
      c76v5 = c76v5(c76v0)
      c76v6 = _T.WRAITH_AddMeter
      c76v8 = 0.5 - c76v5
      c76v6(c76v0, c76v8)
      __renovice_state_0 = 15
    end
    if __renovice_state_0 == 15 then
      do return end
    end
    do return end
  end
  GiveAbilityResources = v37
  v37 = function(c77v0, c77v1)
    local c77v2, c77v3, c77v4, c77v5, c77v6, c77v7, c77v8, c77v9, c77v10, c77v11, c77v12, c77v13, c77v14, c77v15, c77v16, c77v17, c77v18, c77v19, c77v20, c77v21, c77v22, c77v23, c77v24, c77v25, c77v26, c77v27, c77v28
    c77v3 = -1
    c77v4 = AngleToDirection
    c77v4 = c77v4(c77v1)
    c77v2 = c77v3 * c77v4
    c77v3 = {c77v0}
    c77v5 = 1
    c77v4 = {c77v5}
    c77v6 = c77v2 * 4
    c77v5 = c77v0 - c77v6
    c77v7 = gBaseAvatarType
    c77v8 = gHitProxyPhysicsType
    c77v9 = gRagdollType
    c77v10 = gPickUpType
    c77v6 = {c77v7, c77v8, c77v9, c77v10}
    c77v7 = gRegion
    c77v12 = nil
    c77v7:RaycastIgnoreTypes(c77v0, c77v5, c77v6, c77v12, c77v5)
    c77v7 = Distance
    c77v7 = c77v7(c77v5, c77v0)
    c77v8 = 1e-05
    if c77v8 < c77v7 then
      repeat
        c77v8 = CrossProduct
        c77v9 = c77v2
        c77v12 = c77v2.x
        c77v11 = math.abs
        c77v11 = c77v11(c77v12)
        c77v12 = 0.9
        if c77v11 <= c77v12 then
          c77v10 = Vector
          c77v11 = 1
          c77v12 = 0
          c77v13 = 0
          c77v10 = c77v10(c77v11, c77v12, c77v13)
          if c77v10 then break end
        end
        c77v10 = Vector
        c77v11 = 0
        c77v12 = 1
        c77v13 = 0
        c77v10 = c77v10(c77v11, c77v12, c77v13)
      until true
      c77v8 = c77v8(c77v9, c77v10)
      c77v9 = CrossProduct
      c77v9 = c77v9(c77v2, c77v8)
      c77v10 = RotateTowards
      c77v13 = 45
      c77v10 = c77v10(c77v8, c77v9, c77v13)
      c77v11 = RotateTowards
      c77v14 = -1
      c77v13 = c77v14 * c77v9
      c77v14 = 45
      c77v11 = c77v11(c77v8, c77v13, c77v14)
      c77v15 = -1
      c77v14 = c77v15 * c77v8
      c77v17 = -1
      c77v16 = c77v17 * c77v9
      c77v19 = -1
      c77v18 = c77v19 * c77v10
      c77v21 = -1
      c77v20 = c77v21 * c77v11
      c77v12 = {c77v8, c77v14, c77v9, c77v16, c77v10, c77v18, c77v11, c77v20}
      c77v13 = 0
      c77v16 = 1
      c77v14 = 2
      c77v15 = 1
      for __renovice_for_0_0 = c77v16, c77v14, c77v15 do
        c77v19 = 1
        c77v17 = __renovice_for_0_0 * 4
        c77v18 = 1
        for __renovice_for_1_0 = c77v19, c77v17, c77v18 do
          c77v20 = c77v12[__renovice_for_1_0]
          c77v23 = 1.5 * c77v7
          c77v24 = RotateTowards
          c77v25 = __renovice_for_0_0 * 15
          c77v24 = c77v24(c77v2, c77v20, c77v25)
          c77v22 = c77v23 * c77v24
          c77v21 = c77v5 + c77v22
          c77v23 = gRegion
          c77v25 = nil
          c77v26 = nil
          c77v27 = false
          c77v28 = true
          c77v22 = IsNull
          c77v22 = c77v22(c77v23:Name__f9073259(c77v5, c77v21, c77v25, c77v6, c77v26, c77v21, c77v1, c77v27, c77v28))
          if c77v22 then
            continue
          end
          c77v22 = Distance
          c77v22 = c77v22(c77v0, c77v21)
          c77v23 = math.max
          c77v13 = c77v23(c77v13, c77v22)
          c77v23 = table.insert
          c77v23(c77v3, c77v21)
        end
      end
      c77v16 = 2
      c77v14 = #c77v3
      c77v15 = 1
      for __renovice_for_2_0 = c77v16, c77v14, c77v15 do
        c77v18 = c77v3[__renovice_for_2_0]
        c77v19 = c77v3[1]
        c77v17 = c77v18 - c77v19
        c77v19 = Dot
        c77v19 = c77v19(c77v2, c77v17)
        c77v18 = math.abs
        c77v18 = c77v18(c77v19)
        c77v19 = Distance
        c77v21 = c77v3[__renovice_for_2_0]
        c77v19 = c77v19(c77v0, c77v21)
        c77v23 = c77v18 / c77v19
        c77v22 = 1 - c77v23
        c77v20 = table.insert
        c77v20(c77v4, c77v22)
      end
      c77v14 = FORCEorigin
      c77v14 = c77v14(c77v3, c77v4)
      c77v15 = Dot
      c77v15 = c77v15(c77v14, c77v2)
      c77v16 = 0
      if c77v16 < c77v15 then
        c77v14 = c77v14 * -1
      end
      c77v15 = LookTo
      c77v16 = ZERO_VECTOR
      c77v1 = c77v15(c77v16, c77v14)
    end
    do return c77v1 end
  end
  SampleFacing = v37
  v37 = function(c78v0)
    local c78v1, c78v2
    c78v1 = _T.CrewShipAbility
    if c78v1 then
      c78v2 = _T.CrewShipAbility
      c78v1 = c78v2[c78v0]
      if c78v1 then
        c78v1 = true
        do return c78v1 end
      end
    end
    c78v1 = _T
    c78v2 = _T.CrewShipAbility
    if not c78v2 then
      c78v2 = {}
    end
    c78v1.CrewShipAbility = c78v2
    c78v1 = _T.CrewShipAbility
    c78v2 = true
    c78v1[c78v0] = c78v2
    c78v1 = false
    do return c78v1 end
  end
  CrewShipAbilityLock = v37
  v37 = function(c79v0)
    local c79v1, c79v2
    c79v1 = _T.CrewShipAbility
    if c79v1 then
      c79v1 = _T.CrewShipAbility
      c79v2 = nil
      c79v1[c79v0] = c79v2
    end
    do return end
  end
  CrewShipAbilityUnlock = v37
  v37 = function(c80v0)
    local c80v1, c80v2, c80v3, c80v4
    c80v2 = _T.railjackRecall
    c80v1 = not c80v2
    if not c80v1 then
      c80v3 = _T.railjackRecall
      c80v4 = c80v0:GetInstance()
      c80v2 = c80v3[c80v4]
      c80v1 = not c80v2
    end
    do return c80v1 end
  end
  CanRailjackRecall = v37
  v37 = function(c81v0, c81v1, c81v2, c81v3, c81v4, c81v5, c81v6, c81v7, c81v8, c81v9)
    local c81v10, c81v11, c81v12, c81v13, c81v14, c81v15, c81v16, c81v17, c81v18, c81v19, c81v20, c81v21, c81v22, c81v23
    c81v10 = c81v0:Layertrackers()
    c81v14 = false
    c81v15 = 0
    c81v16 = true
    c81v0:PlaySound(c81v9, c81v14, c81v15, c81v16)
    c81v11 = c81v0:InventoryControl()
    c81v11 = c81v11:Name__fc529b76()
    if c81v11 then
      c81v14 = EMPTY_SYMBOL
      c81v0:Attach(c81v5, c81v14)
    else
      c81v14 = EMPTY_SYMBOL
      c81v0:Attach(c81v4, c81v14)
    end
    c81v11 = nil
    c81v12 = 0
    if (c81v12 < c81v2 and c81v10) then
      c81v12 = _T.AddHudTracker
      c81v13 = "RecallTracker"
      c81v14 = v1
      c81v14 = c81v14.HT_TIMER
      c81v15 = nil
      c81v16 = nil
      c81v17 = false
      c81v11 = c81v12(c81v13, c81v14, c81v15, c81v16, c81v17)
      c81v12 = c81v11.SetLabel
      c81v12(c81v3)
      c81v12 = c81v11.StartTimer
      c81v14 = false
      c81v12(c81v2, c81v14)
    end
    c81v12 = false
    c81v13 = false
    c81v14 = c81v0:CameraControl()
    c81v15 = gRegion
    c81v15 = c81v15:GetLevelInfo()
    c81v16 = 0
    c81v18 = 1
    c81v17 = math.max
    c81v17 = c81v17(c81v18, c81v2)
    while true do
      c81v18 = IsNull
      c81v18 = c81v18(c81v0)
      if c81v18 then break end
      c81v18 = v1
      c81v18 = c81v18.AvatarHasActiveActions
      c81v20 = true
      c81v21 = false
      c81v18 = c81v18(c81v0, c81v20, c81v21)
      if not c81v18 then break end
      c81v19 = 0
      c81v21 = DeltaTime
      c81v21 = c81v21()
      c81v20 = c81v17 - c81v21
      c81v18 = math.max
      c81v17 = c81v18(c81v19, c81v20)
      c81v18 = Sleep
      c81v19 = 0
      c81v18(c81v19)
      if c81v10 then
        c81v18 = 4
        if (c81v17 <= c81v18 and not c81v13) then
          c81v21 = false
          c81v22 = 0
          c81v23 = true
          c81v0:PlaySound(c81v8, c81v21, c81v22, c81v23)
          c81v13 = true
        end
      end
      c81v18 = 0
      if (c81v17 <= c81v18 and not c81v12) then
        c81v21 = false
        c81v22 = 0
        c81v23 = true
        c81v0:PlaySound(c81v7, c81v21, c81v22, c81v23)
        c81v12 = true
      end
      c81v18 = IsNull
      c81v18 = c81v18(c81v14)
      if (not c81v18 and c81v10) then
        c81v18 = 1
        if c81v17 <= c81v18 then
          c81v21 = c81v16 * c81v16
          c81v20 = c81v21 + 1
          c81v14:AttenuateFOV(c81v20)
          c81v19 = DeltaTime
          c81v19 = c81v19()
          c81v18 = c81v19 * 2
          c81v16 = c81v16 + c81v18
          c81v20 = c81v0:EyePosition()
          c81v21 = -1
          c81v22 = c81v16 * 2
          c81v23 = 0
          c81v14:ShakeView(c81v20, c81v21, c81v22, c81v23)
          c81v18 = 0.25
          if c81v17 <= c81v18 then
            c81v18 = IsNull
            c81v18 = c81v18(c81v15)
            if not c81v18 then
              c81v20 = c81v16 + 0
              c81v15:SetFade(c81v20)
            end
          end
        end
      end
      c81v18 = 0
    end
    if not c81v11 then
      c81v1()
    end
    c81v18 = IsNull
    c81v18 = c81v18(c81v14)
    if not c81v18 then
      c81v20 = 1
      c81v14:AttenuateFOV(c81v20)
    end
    c81v18 = IsNull
    c81v18 = c81v18(c81v15)
    if not c81v18 then
      c81v20 = 0
      c81v15:SetFade(c81v20)
    end
    c81v18 = IsNull
    c81v18 = c81v18(c81v11)
    if not c81v18 then
      c81v18 = _T.RemoveHudTracker
      c81v18(c81v11)
    end
    do return end
  end
  v38 = function(c83v0, c83v1, c83v2, c83v3, c83v4, c83v5, c83v6)
    local c83v7, c83v8, c83v9, c83v10, c83v11, c83v12, c83v13, c83v14, c83v15, c83v16, c83v17
    c83v7 = gGameRules
    c83v7 = c83v7:GetCrewShipManager()
    c83v8 = IsNull
    c83v8 = c83v8(c83v7)
    if c83v8 then
      do return end
    end
    c83v8 = c83v7:GetPlayerShip()
    c83v9 = IsNull
    c83v9 = c83v9(c83v8)
    if c83v9 then
      do return end
    end
    c83v9 = gGameRules
    c83v11 = v4
    c83v12 = 0
    c83v9 = c83v9:GetNetPersistentVar(c83v11, c83v12)
    c83v10 = gGameRules
    c83v12 = v5
    c83v13 = 0
    c83v10 = c83v10:GetNetPersistentVar(c83v12, c83v13)
    if (c83v9 ~= 1 and c83v10 ~= 1) then
      c83v11 = _T.DisableRailjackRecall
      if not c83v11 then
        c83v11 = _T.railjackRecall
        if not c83v11 then
          c83v11 = _T
          c83v12 = {}
          c83v11.railjackRecall = c83v12
        end
        c83v11 = c83v0:GetInstance()
        c83v12 = _T.railjackRecall
        c83v13 = true
        c83v12[c83v11] = c83v13
        c83v12 = c83v8:GetAvatarOwner()
        c83v13 = function()
          local c82v0, c82v1, c82v2, c82v3, c82v4
          c82v0 = c83v12
          c82v2 = c83v0
          c82v3 = 4
          c82v0:BoardShipScript(c82v2, c82v3)
          c82v0 = c83v0
          c82v0 = c82v0:InventoryControl()
          c82v0 = c82v0:GetSentinel()
          c82v1 = IsNull
          c82v1 = c82v1(c82v0)
          if not c82v1 then
            c82v1 = c83v12
            c82v4 = 4
            c82v1:BoardShipScript(c82v0, c82v4)
          end
          do return end
        end
        c83v14 = Localize
        c83v15 = "/Lotus/Language/CrewShip/Tool_RecallToRailjack"
        c83v16 = {}
        c83v14 = c83v14(c83v15, c83v16)
        c83v15 = v37
        c83v17 = 5
        c83v15(c83v0, c83v13, c83v17, c83v14, c83v1, c83v2, c83v3, c83v4, c83v5, c83v6)
        c83v16 = _T.railjackRecall
        c83v15 = IsNull
        c83v15 = c83v15(c83v16)
        if not c83v15 then
          c83v15 = _T.railjackRecall
          c83v16 = nil
          c83v15[c83v11] = c83v16
          c83v15 = next
          c83v16 = _T.railjackRecall
          c83v15 = c83v15(c83v16)
          if c83v15 == nil then
            c83v15 = _T
            c83v16 = nil
            c83v15.railjackRecall = c83v16
          end
        end
        do return end
      end
    end
    c83v11 = c83v0:Layertrackers()
    if c83v11 then
      c83v11 = _T.ShowImpactMessage
      if c83v11 then
        c83v11 = _T.ShowImpactMessage
        c83v12 = "/Lotus/Language/CrewShip/Tool_RecallToRailjackFail"
        c83v13 = 3
        c83v14 = true
        c83v15 = nil
        c83v16 = false
        c83v11(c83v12, c83v13, c83v14, c83v15, c83v16)
        c83v14 = EMPTY_SYMBOL
        c83v0:Attach(c83v3, c83v14)
      end
    end
    do return end
  end
  RailjackRecall = v38
  v38 = function(c85v0, c85v1, c85v2, c85v3, c85v4, c85v5, c85v6, c85v7, c85v8, c85v9, c85v10)
    local c85v11, c85v12
    c85v11 = function()
      local c84v0, c84v1, c84v2
      c84v0 = c85v0
      c84v1 = c85v1
      c84v2 = c85v2
      c84v0:Teleport(c84v1, c84v2)
      do return end
    end
    c85v12 = v37
    c85v12(c85v0, c85v11, c85v3, c85v4, c85v5, c85v6, c85v7, c85v8, c85v9, c85v10)
    do return end
  end
  TeleportWarp = v38
  v38 = function(c86v0, c86v1)
    local c86v2, c86v3, c86v4, c86v5
    c86v2 = IsNull
    c86v2 = c86v2(c86v0)
    if c86v2 then
      do return c86v1 end
    end
    c86v3 = c86v0:GetOwnedPowerSuitAvatar()
    c86v3 = c86v3:InventoryControl()
    c86v4 = 1
    c86v5 = 419
    c86v3 = c86v3:GetUpgradeModifiedValue(c86v4, c86v5)
    c86v2 = c86v1 * c86v3
    do return c86v2 end
  end
  ApplyTacmapCooldownIntrinsic = v38
  v38 = function(c87v0, c87v1)
    local c87v2, c87v3, c87v4, c87v5
    c87v2 = IsNull
    c87v2 = c87v2(c87v0)
    if c87v2 then
      do return c87v1 end
    end
    c87v3 = c87v0:GetOwnedPowerSuitAvatar()
    c87v3 = c87v3:InventoryControl()
    c87v4 = 1
    c87v5 = 420
    c87v3 = c87v3:GetUpgradeModifiedValue(c87v4, c87v5)
    c87v2 = 2 - c87v3
    c87v3 = c87v1 * c87v2
    do return c87v3 end
  end
  ApplyTacmapEfficiencyIntrinsic = v38
  v38 = function(c88v0)
    do return end
  end
  BlockEnergyGain = v38
  v38 = function(c89v0)
    local c89v1, c89v2, c89v3, c89v4, c89v5, c89v6, c89v7, c89v8, c89v9, c89v10, c89v11
    c89v1 = IsNull
    c89v1 = c89v1(c89v0)
    if not c89v1 then
      c89v1 = c89v0:GetCooldownDuration()
      c89v2 = 0
      if not (c89v2 < c89v1) then
        c89v1 = c89v0:GetSuit()
        c89v2 = IsNull
        c89v2 = c89v2(c89v1)
        if c89v2 then
          do return end
        end
        c89v2 = c89v1:GetAvatarOwner()
        c89v3 = IsNull
        c89v3 = c89v3(c89v2)
        if c89v3 then
          do return end
        end
        c89v3 = _T.RailJackAbilityHeat
        if not c89v3 then
          c89v3 = _T
          c89v4 = {}
          c89v3.RailJackAbilityHeat = c89v4
        end
        c89v3 = c89v2:GetInstance()
        c89v4 = c89v1:GetAbilityIndex(c89v0)
        c89v6 = _T.RailJackAbilityHeat
        c89v5 = c89v6[c89v3]
        if not c89v5 then
          c89v5 = _T.RailJackAbilityHeat
          c89v6 = {}
          c89v5[c89v3] = c89v6
        end
        c89v7 = _T.RailJackAbilityHeat
        c89v6 = c89v7[c89v3]
        c89v5 = c89v6[c89v4]
        if not c89v5 then
          c89v6 = _T.RailJackAbilityHeat
          c89v5 = c89v6[c89v3]
          c89v6 = { pct = 0 }
          c89v5[c89v4] = c89v6
        end
        c89v7 = _T.RailJackAbilityHeat
        c89v6 = c89v7[c89v3]
        c89v5 = c89v6[c89v4]
        c89v6 = Resource
        c89v6 = c89v6(c89v0:GetType())
        c89v8 = false
        c89v6 = c89v6:GetActivationEnergyCost(c89v8)
        c89v10 = false
        c89v8 = c89v0:GetActivationEnergyCost(c89v10)
        c89v10 = 1
        c89v9 = math.max
        c89v9 = c89v9(c89v10, c89v1:ShieldEnergyCostMult())
        c89v7 = c89v8 * c89v9
        c89v10 = c89v7 / 200
        c89v9 = math.ceil
        c89v9 = c89v9(c89v10)
        c89v8 = c89v9 + 1
        c89v5.delay = c89v8
        c89v9 = c89v5.pct
        c89v10 = c89v6 / 200
        c89v8 = c89v9 + c89v10
        c89v5.pct = c89v8
        c89v8 = c89v5.draining
        if not c89v8 then
          c89v8 = true
          c89v5.draining = c89v8
          c89v10 = Symbol
          c89v11 = "HeatDrain"
          c89v10 = c89v10(c89v11)
          c89v11 = false
          c89v2:Name__a50e34c3(c89v10, c89v11)
        end
        do return end
      end
    end
    do return end
  end
  ApplyRailJackAbilityHeat = v38
  v38 = function(c90v0)
    local c90v1, c90v2, c90v3, c90v4, c90v5, c90v6, c90v7, c90v8, c90v9, c90v10, c90v11, c90v12, c90v13, c90v14, c90v15, c90v16, c90v17
    c90v1 = IsNull
    c90v1 = c90v1(c90v0)
    if not c90v1 then
      c90v1 = c90v0:GetCooldownDuration()
      c90v2 = 0
      if not (c90v2 < c90v1) then
        c90v1 = c90v0:GetSuit()
        c90v2 = IsNull
        c90v2 = c90v2(c90v1)
        if c90v2 then
          do return end
        end
        c90v2 = c90v1:GetAvatarOwner()
        c90v3 = IsNull
        c90v3 = c90v3(c90v2)
        if c90v3 then
          do return end
        end
        c90v3 = c90v2:GetInstance()
        c90v4 = c90v1:GetAbilityIndex(c90v0)
        c90v5 = _T.RailJackAbilityHeat
        if c90v5 then
          c90v6 = _T.RailJackAbilityHeat
          c90v5 = c90v6[c90v3]
          if c90v5 then
            c90v7 = _T.RailJackAbilityHeat
            c90v6 = c90v7[c90v3]
            c90v5 = c90v6[c90v4]
            if c90v5 then
              c90v7 = _T.RailJackAbilityHeat
              c90v6 = c90v7[c90v3]
              c90v5 = c90v6[c90v4]
              c90v6 = Resource
              c90v6 = c90v6(c90v0:GetType())
              c90v8 = false
              c90v6 = c90v6:GetActivationEnergyCost(c90v8)
              c90v9 = false
              c90v7 = c90v0:GetActivationEnergyCost(c90v9)
              c90v9 = 1
              c90v8 = math.max
              c90v8 = c90v8(c90v9, c90v1:ShieldEnergyCostMult())
              while true do
                c90v9 = IsNull
                c90v9 = c90v9(c90v0)
                if c90v9 then break end
                c90v9 = c90v5.pct
                c90v10 = 0
                if not (c90v10 < c90v9) then break end
                c90v0:Name__fd3aedec(c90v7)
                c90v9 = c90v5.delay
                c90v10 = 0
                if c90v10 < c90v9 then
                  c90v10 = c90v5.delay
                  c90v11 = DeltaTime
                  c90v11 = c90v11()
                  c90v9 = c90v10 - c90v11
                  c90v5.delay = c90v9
                else
                  c90v10 = 0
                  c90v12 = c90v5.pct
                  c90v17 = c90v7 * c90v8
                  c90v16 = c90v17 / 500
                  c90v15 = math.ceil
                  c90v15 = c90v15(c90v16)
                  c90v14 = 0.25 / c90v15
                  c90v15 = DeltaTime
                  c90v15 = c90v15()
                  c90v13 = c90v14 * c90v15
                  c90v11 = c90v12 - c90v13
                  c90v9 = math.max
                  c90v9 = c90v9(c90v10, c90v11)
                  c90v5.pct = c90v9
                end
                c90v10 = c90v5.pct
                c90v9 = c90v10 + 1
                c90v7 = c90v6 * c90v9
                c90v9 = Sleep
                c90v10 = 0
                c90v9(c90v10)
              end
              c90v9 = IsNull
              c90v9 = c90v9(c90v0)
              if not c90v9 then
                c90v0:Name__fd3aedec(c90v6)
              end
              c90v9 = _T.RailJackAbilityHeat
              if c90v9 then
                c90v10 = _T.RailJackAbilityHeat
                c90v9 = c90v10[c90v3]
                if c90v9 then
                  c90v10 = _T.RailJackAbilityHeat
                  c90v9 = c90v10[c90v3]
                  c90v10 = nil
                  c90v9[c90v4] = c90v10
                  c90v9 = next
                  c90v11 = _T.RailJackAbilityHeat
                  c90v10 = c90v11[c90v3]
                  c90v9 = c90v9(c90v10)
                  if not c90v9 then
                    c90v9 = _T.RailJackAbilityHeat
                    c90v10 = nil
                    c90v9[c90v3] = c90v10
                    c90v9 = next
                    c90v10 = _T.RailJackAbilityHeat
                    c90v9 = c90v9(c90v10)
                    if not c90v9 then
                      c90v9 = _T
                      c90v10 = nil
                      c90v9.RailJackAbilityHeat = c90v10
                    end
                  end
                end
              end
              do return end
            end
          end
        end
        do return end
      end
    end
    do return end
  end
  RailjackAbilityHeatDrain = v38
  v38 = function(c91v0)
    local c91v1, c91v2, c91v3, c91v4
    c91v1 = IsNull
    c91v1 = c91v1(c91v0)
    if c91v1 then
      c91v1 = false
      do return c91v1 end
    end
    c91v1 = c91v0:GetInstance()
    c91v2 = false
    c91v3 = _T.exaltedAbility
    if c91v3 ~= nil then
      c91v4 = _T.exaltedAbility
      c91v3 = c91v4[c91v1]
      if c91v3 == nil then
        c91v2 = false
        do return c91v2 end
      end
      c91v2 = true
    end
    do return c91v2 end
  end
  IsExaltedActive = v38
  v38 = function(c92v0)
    local c92v1, c92v2, c92v3, c92v4, c92v5, c92v6, c92v7, c92v8, c92v9, c92v10, c92v11, c92v12, c92v13
    local __renovice_state_0 = 0
    c92v1 = c92v0.suit
    c92v2 = IsNull
    c92v2 = c92v2(c92v1)
    if not c92v2 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      do return end
    end
    if __renovice_state_0 == 2 then
      c92v2 = c92v1:GetAvatarOwner()
      c92v3 = IsNull
      c92v3 = c92v3(c92v2)
      if c92v3 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c92v3 = c92v2:IsKilled()
      if c92v3 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c92v3 = c92v2:IsPreDeath()
      if not c92v3 then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      do return end
    end
    if __renovice_state_0 == 6 then
      c92v3 = c92v2:InventoryControl()
      c92v6 = false
      c92v3:Name__33ea4d3c(c92v6)
      c92v6 = false
      c92v3:EnableWeaponFiring(c92v6)
      c92v4 = c92v2:Name__ad7b05b3()
      if not c92v4 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c92v7 = c92v0.ability
      c92v8 = Symbol
      c92v9 = "GiveWeapon"
      c92v8 = c92v8(c92v9)
      c92v9 = Lotus_Game.SecondaryScriptArgs
      c92v10 = false
      c92v1:ActivateSecondaryScriptEx(c92v7, c92v8, c92v9(c92v10))
      __renovice_state_0 = 8
    end
    if __renovice_state_0 == 8 then
      c92v5 = c92v0.weaponType
      c92v6 = nil
    end
    while true do
      c92v7 = IsNull
      c92v7 = c92v7(c92v2)
      if c92v7 then break end
      c92v7 = c92v2:IsKilled()
      if c92v7 then break end
      c92v7 = c92v2:IsPreDeath()
      if c92v7 then break end
      c92v9 = 0
      c92v6 = c92v3:Name__23991ed1(c92v9)
      c92v7 = IsNull
      c92v7 = c92v7(c92v6)
      if not c92v7 then
        c92v7 = c92v6:GetType()
        if c92v7 == c92v5 then
          c92v7 = c92v6:GetState()
          c92v8 = 15
          if c92v7 ~= c92v8 then
            c92v7 = c92v0.damageAmount
            if c92v7 ~= nil then
              c92v7 = c92v0.damageType
              if c92v7 ~= nil then
                c92v7 = c92v0.procChance
                if c92v7 ~= nil then
                  c92v8 = c92v0.damageAmount
                  c92v7 = type
                  c92v7 = c92v7(c92v8)
                  if c92v7 == "userdata" then
                    c92v10 = 0
                    c92v8 = c92v6:GetImpactBehavior(c92v10)
                    c92v10 = c92v0.damageAmount
                    c92v10 = c92v10:GetBaseValue()
                    c92v11 = c92v0.damageType
                    c92v12 = c92v0.procChance
                    c92v8:Name__6e2a05b1(c92v10, c92v11, c92v12)
                    c92v8 = gRegion
                    c92v8 = c92v8:IsMaster()
                    if c92v8 then
                      c92v8 = v0
                      c92v8 = c92v8.Ternary
                      c92v9 = c92v6:IsMeleeWeapon()
                      c92v10 = 325
                      c92v11 = 253
                      c92v11 = c92v8(c92v9, c92v10, c92v11)
                      c92v12 = c92v0.damageAmount
                      c92v13 = c92v6:GetType()
                      c92v3:AddUpgrades(c92v11, c92v12, c92v13, c92v6)
                    end
                  else
                    c92v10 = 0
                    c92v8 = c92v6:GetImpactBehavior(c92v10)
                    c92v10 = c92v0.damageAmount
                    c92v11 = c92v0.damageType
                    c92v12 = c92v0.procChance
                    c92v8:Name__6e2a05b1(c92v10, c92v11, c92v12)
                  end
                end
              end
            end
            c92v6:SetDamageSource(c92v1)
            c92v7 = c92v0.weaponEquippedFnc
            if c92v7 ~= nil then
              c92v7 = c92v0.weaponEquippedFnc
              c92v7(c92v1, c92v2, c92v6)
            end
            c92v7 = v1
            c92v7 = c92v7.IsNoModsMode
            c92v7 = c92v7()
            if c92v7 then
              c92v7 = v1
              c92v7 = c92v7.RemoveModsFromWeapon
              c92v9 = true
              c92v7(c92v6, c92v9)
            end
            c92v9 = true
            c92v3:Name__33ea4d3c(c92v9)
            c92v9 = true
            c92v3:EnableWeaponFiring(c92v9)
            c92v7 = c92v2:Layertrackers()
            if c92v7 then
              c92v7 = c92v0.abilityActiveAnim
              if c92v7 == true then
                c92v7 = _T.SetAbilityActiveAnim
                c92v10 = c92v0.ability
                c92v8 = c92v1:GetAbilityIndex(c92v10)
                c92v9 = true
                c92v7(c92v8, c92v9)
              end
            end
            do return end
          end
        end
      end
      c92v7 = Sleep
      c92v8 = 0
      c92v7(c92v8)
    end
    do return end
  end
  ActivateExalted = v38
  v38 = function(c93v0)
    local c93v1, c93v2, c93v3, c93v4, c93v5, c93v6, c93v7, c93v8, c93v9, c93v10, c93v11, c93v12, c93v13, c93v14, c93v15
    c93v9 = nil
    local __renovice_local_0 = c93v9:GetType()
    c93v10 = c93v0.weaponType
    __renovice_local_0 = c93v9:GetActiveImpactBehavior()
    c93v11 = true
    __renovice_local_0:ResetCombo(c93v11)
    c93v11 = 0
    __renovice_local_0 = 3
    c93v10 = 1
    for __renovice_for_0_0 = c93v11, __renovice_local_0, c93v10 do
      c93v14 = 1
      c93v12 = c93v9:GetAttachmentEntity(c93v14, __renovice_for_0_0)
      c93v13 = IsNull
      c93v13 = c93v13(c93v12)
      if c93v13 then
        continue
      end
      c93v15 = true
      c93v12:Soulout(c93v15)
    end
    c93v1 = c93v0.suit
    while true do
      c93v2 = IsNull
      c93v2 = c93v2(c93v1)
      if c93v2 then break end
      c93v2 = c93v1:Name__51c47a27()
      if not c93v2 then break end
      c93v2 = Sleep
      c93v3 = 0
      c93v2(c93v3)
    end
    c93v2 = IsNull
    c93v2 = c93v2(c93v1)
    if c93v2 then
      do return end
    end
    c93v2 = c93v1:GetAvatarOwner()
    c93v3 = IsNull
    c93v3 = c93v3(c93v2)
    if c93v3 then
      do return end
    end
    c93v3 = c93v0.preRemoveFnc
    if c93v3 ~= nil then
      c93v3 = c93v0.preRemoveFnc
      c93v3(c93v1, c93v2)
      c93v3 = IsNull
      c93v3 = c93v3(c93v2)
      if c93v3 then
        do return end
      end
    end
    c93v3 = c93v2:ReplicaLocallyAuthoritative()
    if c93v3 then
      c93v3 = c93v0.abilityActiveAnim
      if c93v3 == true then
        c93v3 = _T.SetAbilityActiveAnim
        c93v6 = c93v0.ability
        c93v4 = c93v1:GetAbilityIndex(c93v6)
        c93v5 = false
        c93v3(c93v4, c93v5)
      end
    end
    c93v3 = c93v2:InventoryControl()
    c93v3:StopMelee()
    c93v6 = false
    c93v3:EnableWeaponFiring(c93v6)
    c93v4 = c93v2:Name__ad7b05b3()
    c93v5 = c93v2:GetInstance()
    c93v6 = c93v0.weaponSlot
    c93v7 = c93v3:Name__d147ac90()
    c93v8 = c93v0.hideWeaponAttachments
    if not c93v8 then
      c93v9 = c93v0.hideWeaponAttachments
      do
        local __renovice_unused_condition_0 = c93v9 == nil
      end
    end
    c93v9 = c93v3:GetWeaponInSlot(c93v6)
    __renovice_local_0 = gRegion
    __renovice_local_0 = __renovice_local_0:IsMaster()
    if __renovice_local_0 then
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c93v9)
      if not __renovice_local_0 then
        __renovice_local_0 = c93v9:GetType()
        c93v10 = c93v0.weaponType
        if __renovice_local_0 == c93v10 then
          __renovice_local_0 = c93v0.damageAmount
          if __renovice_local_0 then
            c93v10 = c93v0.damageAmount
            __renovice_local_0 = type
            __renovice_local_0 = __renovice_local_0(c93v10)
            if __renovice_local_0 == "userdata" then
              __renovice_local_0 = v0
              __renovice_local_0 = __renovice_local_0.Ternary
              c93v10 = c93v9:IsMeleeWeapon()
              c93v11 = 325
              c93v12 = 253
              c93v12 = __renovice_local_0(c93v10, c93v11, c93v12)
              c93v13 = c93v0.damageAmount
              c93v14 = c93v9:GetType()
              c93v3:RemoveUpgrades(c93v12, c93v13, c93v14, c93v9)
            end
          end
        end
      end
    end
    if c93v4 then
      c93v11 = c93v0.ability
      c93v12 = Symbol
      c93v13 = "RemoveWeapon"
      c93v12 = c93v12(c93v13)
      c93v13 = Lotus_Game.SecondaryScriptArgs
      c93v14 = false
      c93v1:ActivateSecondaryScriptEx(c93v11, c93v12, c93v13(c93v14))
    end
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c93v9)
    __renovice_local_0 = gRegion
    __renovice_local_0 = __renovice_local_0:IsMaster()
    if __renovice_local_0 then
      __renovice_local_0 = _T.exaltedAbility
      if __renovice_local_0 ~= nil then
        c93v10 = _T.exaltedAbility
        __renovice_local_0 = c93v10[c93v5]
        if __renovice_local_0 ~= nil then
          while true do
            __renovice_local_0 = IsNull
            __renovice_local_0 = __renovice_local_0(c93v2)
            if __renovice_local_0 then break end
            __renovice_local_0 = c93v3:Name__fb8798e5()
            if __renovice_local_0 then break end
            c93v10 = _T.exaltedAbility
            __renovice_local_0 = c93v10[c93v5]
            __renovice_local_0 = __renovice_local_0.activated
            if not __renovice_local_0 then break end
            __renovice_local_0 = Sleep
            c93v10 = 0
            __renovice_local_0(c93v10)
          end
        end
      end
    end
    while true do
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c93v2)
      if __renovice_local_0 then break end
      __renovice_local_0 = c93v2:IsKilled()
      if __renovice_local_0 then break end
      __renovice_local_0 = c93v2:IsPreDeath()
      if __renovice_local_0 then break end
      __renovice_local_0 = c93v3:Name__fb8798e5()
      if __renovice_local_0 then break end
      c93v11 = 0
      __renovice_local_0 = c93v3:Name__23991ed1(c93v11)
      c93v10 = IsNull
      c93v10 = c93v10(__renovice_local_0)
      if c93v10 then break end
      c93v10 = __renovice_local_0:GetType()
      c93v11 = c93v0.weaponType
      if c93v10 ~= c93v11 then break end
      c93v10 = gRegion
      c93v10 = c93v10:IsMaster()
      c93v10 = __renovice_local_0:GetState()
      c93v11 = 15
      if c93v10 == c93v11 then break end
      c93v10 = IsNull
      c93v10 = c93v10(c93v2:GetPlayer())
      c93v10 = IsNull
      c93v10 = c93v10(c93v2:Name__2d897740())
      if not c93v10 then break end
      c93v10 = Sleep
      c93v11 = 0
      c93v10(c93v11)
    end
    do
      local __renovice_unused_condition_1 = __renovice_local_0 ~= c93v10
    end
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c93v2)
    if not __renovice_local_0 then
      c93v11 = c93v0.weaponType
      c93v10 = IsNull
      c93v10 = c93v10(c93v11)
      __renovice_local_0 = not c93v10
      if __renovice_local_0 then
        __renovice_local_0 = c93v0.weaponType
        c93v11 = gLotusMeleeWeaponType
        __renovice_local_0 = __renovice_local_0:IsA(c93v11)
      end
      if __renovice_local_0 then
        c93v12 = Symbol
        c93v13 = "RevertFinishers"
        c93v12 = c93v12(c93v13)
        c93v13 = false
        c93v2:Name__a50e34c3(c93v12, c93v13)
      end
    end
    while true do
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c93v2)
      if __renovice_local_0 then break end
      __renovice_local_0 = c93v2:IsKilled()
      if __renovice_local_0 then break end
      __renovice_local_0 = c93v2:IsPreDeath()
      if __renovice_local_0 then break end
      __renovice_local_0 = c93v3:Name__fb8798e5()
      if __renovice_local_0 then break end
      c93v11 = 0
      __renovice_local_0 = c93v3:Name__23991ed1(c93v11)
      c93v10 = IsNull
      c93v10 = c93v10(__renovice_local_0)
      if c93v10 then break end
      c93v10 = __renovice_local_0:GetState()
      c93v11 = 15
      c93v10 = __renovice_local_0:GetState()
      c93v11 = 17
      if c93v10 ~= c93v11 then break end
      c93v10 = Sleep
      c93v11 = 0
      c93v10(c93v11)
    end
    local __renovice_state_0 = 65
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c93v2)
    if __renovice_local_0 then
      __renovice_state_0 = 73
    else
      __renovice_state_0 = 66
    end
    if __renovice_state_0 == 66 then
      c93v11 = 3
      __renovice_local_0 = c93v3:GetItemVisibility(c93v11)
      c93v10 = 0
      if __renovice_local_0 ~= c93v10 then
        __renovice_state_0 = 70
      else
        __renovice_state_0 = 67
      end
    end
    if __renovice_state_0 == 67 then
      c93v11 = 3
      __renovice_local_0 = c93v3:GetWeaponInHand(c93v11)
      c93v10 = IsNull
      c93v10 = c93v10(__renovice_local_0)
      if c93v10 then
        __renovice_state_0 = 69
      else
        __renovice_state_0 = 68
      end
    end
    if __renovice_state_0 == 68 then
      c93v10 = __renovice_local_0:HasRotationSimple()
      if c93v10 then
        __renovice_state_0 = 70
      else
        __renovice_state_0 = 69
      end
    end
    if __renovice_state_0 == 69 then
      c93v12 = 3
      c93v13 = 2
      c93v3:SetItemVisibility(c93v12, c93v13)
      __renovice_state_0 = 70
    end
    if __renovice_state_0 == 70 then
      c93v11 = true
      c93v3:EnableWeaponFiring(c93v11)
      c93v3:Name__33ea4d3c(c93v7)
      c93v11 = 0
      __renovice_local_0 = c93v3:GetWeaponInHand(c93v11)
      c93v10 = IsNull
      c93v10 = c93v10(__renovice_local_0)
      if c93v10 then
        __renovice_state_0 = 73
      else
        __renovice_state_0 = 71
      end
    end
    if __renovice_state_0 == 71 then
      c93v12 = 0
      c93v10 = c93v3:GetItemVisibility(c93v12)
      c93v11 = 2
      if c93v10 ~= c93v11 then
        __renovice_state_0 = 73
      else
        __renovice_state_0 = 72
      end
    end
    if __renovice_state_0 == 72 then
      c93v12 = 0
      c93v13 = 0
      c93v3:SetItemVisibility(c93v12, c93v13)
      __renovice_state_0 = 73
    end
    if __renovice_state_0 == 73 then
      __renovice_local_0 = _T.exaltedAbility
      if __renovice_local_0 == nil then
        __renovice_state_0 = 76
      else
        __renovice_state_0 = 74
      end
    end
    if __renovice_state_0 == 74 then
      __renovice_local_0 = _T.exaltedAbility
      c93v10 = nil
      __renovice_local_0[c93v5] = c93v10
      __renovice_local_0 = next
      c93v10 = _T.exaltedAbility
      __renovice_local_0 = __renovice_local_0(c93v10)
      if __renovice_local_0 ~= nil then
        __renovice_state_0 = 76
      else
        __renovice_state_0 = 75
      end
    end
    if __renovice_state_0 == 75 then
      __renovice_local_0 = _T
      c93v10 = nil
      __renovice_local_0.exaltedAbility = c93v10
      __renovice_state_0 = 76
    end
    if __renovice_state_0 == 76 then
      do return end
    end
    do return end
  end
  DeactivateExalted = v38
  v38 = function(c94v0, c94v1, c94v2, c94v3, c94v4, c94v5, c94v6, c94v7)
    local c94v8, c94v9, c94v10, c94v11, c94v12, c94v13, c94v14, c94v15, c94v16, c94v17, c94v18, c94v19, c94v20, c94v21
    c94v8 = c94v6
    if not c94v8 then
      c94v8 = 0
    end
    c94v6 = c94v8
    c94v8 = IsNull
    c94v8 = c94v8(c94v2)
    if c94v8 then
      do return end
    end
    c94v8 = c94v2:GetInstance()
    while true do
      c94v10 = _T.exaltedAbility
      c94v9 = IsNull
      c94v9 = c94v9(c94v10)
      if c94v9 then break end
      c94v10 = _T.exaltedAbility
      c94v9 = c94v10[c94v8]
      if c94v9 == nil then break end
      c94v9 = Sleep
      c94v10 = 0
      c94v9(c94v10)
    end
    c94v9 = IsNull
    c94v9 = c94v9(c94v2)
    if not c94v9 then
      c94v9 = IsNull
      c94v9 = c94v9(c94v0)
      if not c94v9 then
        c94v9 = _T.exaltedAbility
        if c94v9 == nil then
          c94v9 = _T
          c94v10 = {}
          c94v9.exaltedAbility = c94v10
        end
        c94v10 = _T.exaltedAbility
        c94v9 = c94v10[c94v8]
        if c94v9 == nil then
          c94v9 = _T.exaltedAbility
          c94v10 = {}
          c94v9[c94v8] = c94v10
        end
        c94v10 = _T.exaltedAbility
        c94v9 = c94v10[c94v8]
        c94v10 = true
        c94v9.activated = c94v10
        c94v9 = c94v2:InventoryControl()
        c94v10 = c94v9:WeaponDisabled(c94v4)
        if c94v10 then
          c94v9:SetWeaponEnabled(c94v4)
          c94v11 = 5
          if c94v4 ~= c94v11 then
            c94v13 = 7
            c94v9:SetWeaponDisabled(c94v13)
          end
        end
        c94v11 = v3
        c94v11 = c94v11.IsPvpEnabled
        c94v11 = c94v11()
        if c94v11 then
          c94v12 = 0
          if c94v6 == c94v12 then
            c94v6 = 3
          end
        end
        c94v12 = c94v2:GetPlayer()
        c94v13 = IsNull
        c94v13 = c94v13(c94v12)
        if c94v13 then
          c94v15 = gLotusNpcAvatarType
          c94v13 = c94v2:IsA(c94v15)
          if c94v13 then
            c94v13 = c94v2:GetSpawnedByAvatar()
            c94v14 = IsNull
            c94v14 = c94v14(c94v13)
            if not c94v14 then
              c94v12 = c94v13:GetPlayer()
            end
          end
        end
        if not c94v7 then
          c94v13 = IsNull
          c94v13 = c94v13(c94v12)
          if not c94v13 then
            c94v13 = c94v12:GetLoadOut()
            c94v14 = c94v13:GetWeaponInfo(c94v6, c94v5)
            c94v14 = c94v14.mItemType
            c94v15 = IsNull
            c94v15 = c94v15(c94v14)
            if (not c94v15 and c94v14 == c94v3) then
              c94v20 = false
              c94v9:BuildItemInLoadOutSlot(c94v13, c94v6, c94v5, c94v20)
            end
          end
        end
        local __renovice_state_0 = -1
        c94v15 = 7
        c94v13 = c94v9:GetWeaponInSlot(c94v15)
        c94v14 = IsNull
        c94v14 = c94v14(c94v13)
        if c94v14 then
          __renovice_state_0 = -1
        else
          __renovice_state_0 = 1
        end
        if __renovice_state_0 == 1 then
          c94v14 = c94v13:GetType()
          if c94v14 == c94v3 then
            __renovice_state_0 = 2
          else
            __renovice_state_0 = -1
          end
        end
        if __renovice_state_0 == 2 then
          c94v16 = c94v0:GetAbilityIndex(c94v1)
          c94v17 = 1
          c94v14 = c94v0:Name__0f88464a(c94v16, c94v17)
          c94v15 = gGameConfig
          c94v15 = c94v15:Name__a534be9c(c94v14, c94v0:GetType())
          c94v16 = c94v0:GetXP()
          c94v21 = false
          c94v17 = c94v9:RefreshLifeScanner(c94v6, c94v5, c94v21)
          c94v20 = c94v16 - c94v15
          c94v18 = math.min
          c94v18 = c94v18(c94v17, c94v20)
          c94v19 = 0
          if not (c94v19 < c94v18) then
            __renovice_state_0 = 4
          else
            __renovice_state_0 = 3
          end
        end
        if __renovice_state_0 == 3 then
          c94v13:Name__6de778ba(c94v18)
          __renovice_state_0 = 4
        end
        if __renovice_state_0 ~= 4 then
          c94v14 = print
          c94v16 = "AbilitiesLib.lua: Failed to build "
          c94v17 = c94v3:GetName()
          c94v18 = " giving temp weapon"
          c94v15 = c94v16 .. c94v17 .. c94v18
          c94v14(c94v15)
          c94v17 = false
          c94v13 = c94v2:GiveItem(c94v3, c94v17)
          c94v14 = IsNull
          c94v14 = c94v14(c94v13)
          if not c94v14 then
            c94v13:SetXP(c94v0:GetXP())
          end
        end
        c94v16 = true
        c94v9:Name__33ea4d3c(c94v16)
        c94v16 = 0
        c94v14 = c94v9:GetWeaponInHand(c94v16)
        c94v15 = IsNull
        c94v15 = c94v15(c94v14)
        if not c94v15 then
          c94v16 = _T.exaltedAbility
          c94v15 = c94v16[c94v8]
          c94v16 = c94v14:GetType()
          c94v15.lastWeaponType = c94v16
        end
        c94v18 = 7
        c94v9:Name__f59a18b6(c94v4, c94v18)
        c94v17 = gLotusInventoryControllerType
        c94v15 = c94v9:IsA(c94v17)
        if c94v15 then
          c94v9:Name__4530a0a8()
        end
        c94v18 = 0
        c94v19 = 2
        c94v9:Equip(c94v4, c94v18, c94v19)
        c94v17 = 3
        c94v18 = 2
        c94v9:Unequip(c94v17, c94v18)
        c94v17 = false
        c94v9:Name__33ea4d3c(c94v17)
        if c94v10 then
          repeat
            c94v15 = _T.exaltedAbility
            if c94v15 ~= nil then
              c94v16 = _T.exaltedAbility
              c94v15 = c94v16[c94v8]
              if (c94v15 ~= nil and not c94v11) then
                c94v16 = _T.exaltedAbility
                c94v15 = c94v16[c94v8]
                c94v16 = true
                c94v15.disableSlot = c94v16
                break
              end
            end
            c94v15 = 5
            if c94v4 == c94v15 then
              c94v17 = 5
              c94v9:SetWeaponDisabled(c94v17)
            end
          until true
        end
        c94v15 = c94v2:GetAgent()
        c94v16 = IsNull
        c94v16 = c94v16(c94v15)
        if not c94v16 then
          c94v15:RefreshWeapon()
        end
        do return end
      end
    end
    do return end
  end
  GiveWeapon = v38
  v38 = function(c95v0, c95v1, c95v2, c95v3, c95v4)
    local c95v5, c95v6, c95v7, c95v8, c95v9, c95v10, c95v11, c95v12, c95v13, c95v14, c95v15, c95v16, c95v17
    c95v5 = IsNull
    c95v5 = c95v5(c95v0)
    if c95v5 then
      do return end
    end
    if c95v4 == nil then
      c95v4 = true
    end
    c95v5 = c95v0:InventoryControl()
    c95v6 = c95v0:GetInstance()
    c95v7 = c95v5:GetWeaponInSlot(c95v2)
    c95v8 = IsNull
    c95v8 = c95v8(c95v7)
    if not c95v8 then
      local __renovice_state_0 = 5
      c95v8 = c95v7:GetType()
      if c95v8 ~= c95v1 then
      else
        __renovice_state_0 = 6
      end
      if __renovice_state_0 == 6 then
        c95v10 = 0
        c95v8 = c95v5:Name__23991ed1(c95v10)
        c95v11 = true
        c95v5:Name__33ea4d3c(c95v11)
        c95v11 = 7
        c95v5:Name__f59a18b6(c95v11, c95v2)
        if c95v3 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        c95v0:RemoveItem(c95v1)
        __renovice_state_0 = 8
      end
      if __renovice_state_0 == 8 then
        c95v9 = IsNull
        c95v9 = c95v9(c95v8)
        if c95v9 then
          __renovice_state_0 = 10
        else
          __renovice_state_0 = 9
        end
      end
      if __renovice_state_0 == 9 then
        c95v9 = c95v8:Name__d7270796()
        if c95v9 == c95v2 then
          __renovice_state_0 = 12
        else
          __renovice_state_0 = 10
        end
      end
      if __renovice_state_0 == 10 then
        c95v9 = c95v5:Name__fb8798e5()
        if not c95v9 then
          __renovice_state_0 = 13
        else
          __renovice_state_0 = 11
        end
      end
      if __renovice_state_0 == 11 then
        c95v9 = IsNull
        c95v9 = c95v9(c95v8)
        if not c95v9 then
          __renovice_state_0 = 13
        else
          __renovice_state_0 = 12
        end
      end
      if __renovice_state_0 == 12 then
        c95v12 = 0
        c95v13 = 2
        c95v5:Equip(c95v2, c95v12, c95v13)
        __renovice_state_0 = 13
      end
      if __renovice_state_0 == 13 then
        c95v9 = c95v5:Name__fb8798e5()
        if c95v9 then
        else
          __renovice_state_0 = 14
        end
      end
      if __renovice_state_0 == 14 then
        c95v11 = gLotusMeleeWeaponType
        c95v9 = c95v7:IsA(c95v11)
        if not c95v9 then
          __renovice_state_0 = 16
        else
          __renovice_state_0 = 15
        end
      end
      if __renovice_state_0 == 15 then
        c95v11 = false
        c95v7:SetChanneling(c95v11)
        c95v11 = false
        c95v7:Name__bd2fd61d(c95v11)
        c95v11 = true
        c95v12 = true
        c95v5:HideMeleeWeapon(c95v11, c95v12)
        __renovice_state_0 = 16
      end
      if __renovice_state_0 == 16 then
        c95v9 = c95v5:WeaponDisabled(c95v2)
        if not c95v9 then
          __renovice_state_0 = 18
        else
          __renovice_state_0 = 17
        end
      end
      if __renovice_state_0 == 17 then
        c95v5:SetWeaponEnabled(c95v2)
        __renovice_state_0 = 18
      end
      if __renovice_state_0 == 18 then
        c95v5:StopMelee()
        if c95v8 ~= c95v7 then
          __renovice_state_0 = 31
        else
          __renovice_state_0 = 19
        end
      end
      if __renovice_state_0 == 19 then
        c95v10 = false
        c95v11 = _T.exaltedAbility
        if not c95v11 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 20
        end
      end
      if __renovice_state_0 == 20 then
        c95v12 = _T.exaltedAbility
        c95v11 = c95v12[c95v6]
        if not c95v11 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 21
        end
      end
      if __renovice_state_0 == 21 then
        c95v12 = _T.exaltedAbility
        c95v11 = c95v12[c95v6]
        c95v11 = c95v11.lastWeaponType
        if (not c95v11 or not c95v4) then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 23
        end
      end
      if __renovice_state_0 == 23 then
        c95v12 = _T.exaltedAbility
        c95v11 = c95v12[c95v6]
        c95v11 = c95v11.lastWeaponType
        c95v12 = c95v5:Name__9bbc85aa(c95v11)
        c95v13 = IsNull
        c95v13 = c95v13(c95v12)
        if c95v13 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 24
        end
      end
      if __renovice_state_0 == 24 then
        c95v13 = c95v12:GetType()
        c95v15 = _T.exaltedAbility
        c95v14 = c95v15[c95v6]
        c95v14 = c95v14.lastWeaponType
        if c95v13 ~= c95v14 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 25
        end
      end
      if __renovice_state_0 == 25 then
        c95v13 = c95v12:Name__d7270796()
        c95v14 = 14
        if c95v13 == c95v14 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 26
        end
      end
      if __renovice_state_0 == 26 then
        c95v16 = 0
        c95v17 = 0
        c95v10 = c95v5:Equip(c95v13, c95v16, c95v17)
        __renovice_state_0 = 27
      end
      if __renovice_state_0 == 27 then
        if c95v10 then
          __renovice_state_0 = 31
        else
          __renovice_state_0 = 28
        end
      end
      if __renovice_state_0 == 28 then
        c95v11 = IsNull
        c95v11 = c95v11(c95v5:GetWeaponInSlot(c95v2))
        if not c95v11 then
          __renovice_state_0 = 30
        else
          __renovice_state_0 = 29
        end
      end
      if __renovice_state_0 == 29 then
        c95v13 = false
        c95v14 = false
        c95v15 = true
        c95v5:EquipBestWeapon(c95v13, c95v14, c95v15)
        __renovice_state_0 = 31
      end
      if __renovice_state_0 == 30 then
        c95v14 = 0
        c95v15 = 0
        c95v5:Equip(c95v2, c95v14, c95v15)
        __renovice_state_0 = 31
      end
      if __renovice_state_0 == 31 then
        c95v10 = _T.IsWeaponStolen
        if not c95v10 then
          __renovice_state_0 = 34
        else
          __renovice_state_0 = 32
        end
      end
      if __renovice_state_0 == 32 then
        c95v11 = _T.IsWeaponStolen
        c95v10 = c95v11[c95v6]
        if not c95v10 then
          __renovice_state_0 = 34
        else
          __renovice_state_0 = 33
        end
      end
      if __renovice_state_0 == 33 then
        c95v12 = _T.IsWeaponStolen
        c95v11 = c95v12[c95v6]
        c95v10 = c95v11[c95v2]
        __renovice_state_0 = 34
      end
      if __renovice_state_0 == 34 then
        if (not c95v9 and not c95v10) then
        else
          __renovice_state_0 = 36
        end
      end
      if __renovice_state_0 == 36 then
        c95v5:SetWeaponDisabled(c95v2)
      end
    end
    c95v8 = _T.exaltedAbility
    if c95v8 ~= nil then
      c95v9 = _T.exaltedAbility
      c95v8 = c95v9[c95v6]
      if c95v8 ~= nil then
        c95v9 = _T.exaltedAbility
        c95v8 = c95v9[c95v6]
        c95v9 = nil
        c95v8.activated = c95v9
        c95v9 = _T.exaltedAbility
        c95v8 = c95v9[c95v6]
        c95v8 = c95v8.disableSlot
        if c95v8 == true then
          c95v5:SetWeaponDisabled(c95v2)
          c95v9 = _T.exaltedAbility
          c95v8 = c95v9[c95v6]
          c95v9 = nil
          c95v8.disableSlot = c95v9
        end
      end
    end
    c95v10 = 7
    c95v5:SetWeaponDisabled(c95v10)
    c95v8 = c95v0:GetAgent()
    c95v9 = IsNull
    c95v9 = c95v9(c95v8)
    if not c95v9 then
      c95v8:RefreshWeapon()
    end
    do return end
  end
  RemoveWeapon = v38
  v38 = function(c96v0, c96v1, c96v2)
    local c96v3, c96v4, c96v5, c96v6, c96v7, c96v8, c96v9, c96v10, c96v11, c96v12, c96v13, c96v14, c96v15, c96v16, c96v17, c96v18, c96v19, c96v20, c96v21, c96v22, c96v23
    c96v3 = WeakResource
    c96v4 = "/Lotus/Types/Player/TennoAvatarArsenal"
    c96v3 = c96v3(c96v4)
    c96v4 = 7
    c96v5 = c96v1:GetSpecialSlotItem(c96v2)
    c96v5 = c96v5.mItemType
    c96v6 = c96v0:IsA(c96v3)
    if c96v6 then
      c96v6 = Sleep
      c96v7 = 0
      c96v6(c96v7)
      c96v6 = c96v0:HasItem(c96v5)
      if c96v6 then
        do return end
      end
    end
    c96v6 = c96v0:InventoryControl()
    c96v7 = c96v0:Name__2d897740()
    c96v8 = c96v0:IsMaster()
    if not c96v8 then
      c96v8 = c96v0:IsClientOnly()
    end
    if c96v8 then
      c96v11 = gGameRules
      c96v10 = IsNull
      c96v10 = c96v10(c96v11)
      c96v9 = not c96v10
      if c96v9 then
        c96v9 = gGameRules
        c96v11 = gLotusAttractModeGameRulesType
        c96v9 = c96v9:IsA(c96v11)
      end
      while true do
        c96v10 = Sleep
        c96v11 = 0
        c96v10(c96v11)
        c96v10 = IsNull
        c96v10 = c96v10(c96v7)
        if c96v10 then break end
        c96v10 = c96v7:Name__3e1ef941()
        if (c96v10 or c96v9) then break end
      end
      c96v10 = IsNull
      c96v10 = c96v10(c96v0)
      if c96v10 then
        do return end
      end
      local __renovice_state_0 = -1
      c96v10 = nil
      c96v11 = nil
      if c96v9 then
        __renovice_state_0 = -1
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c96v12 = c96v0:IsA(c96v3)
        if not c96v12 then
          __renovice_state_0 = 2
        else
          __renovice_state_0 = -1
        end
      end
      if __renovice_state_0 == 2 then
        c96v12 = IsNull
        c96v12 = c96v12(c96v7)
        if c96v12 then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        c96v10 = c96v7:GetLoadOut()
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 4 then
        c96v13 = gGameRules
        c96v12 = IsNull
        c96v12 = c96v12(c96v13)
        if c96v12 then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c96v12 = gGameRules
        c96v14 = gLotusHubGameRulesType
        c96v12 = c96v12:IsA(c96v14)
        if not c96v12 then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        c96v12 = gGameRules
        c96v12 = c96v12:GetAccountFromAvatar(c96v0)
        c96v13 = gGameRules
        c96v10 = c96v13:Name__0a508693(c96v12)
        __renovice_state_0 = 7
      end
      if __renovice_state_0 ~= 7 then
        c96v12 = gPlayerProfileMgr
        c96v14 = 0
        c96v12 = c96v12:GetPlayerProfile(c96v14)
        c96v13 = IsNull
        c96v13 = c96v13(c96v12)
        if not c96v13 then
          c96v13 = c96v12:GetGameSpecificData()
          c96v10 = c96v13:GetLoadOut()
        end
      end
      if c96v10 ~= nil then
        c96v12 = 0
        c96v13 = v3
        c96v13 = c96v13.IsPvpEnabled
        c96v13 = c96v13()
        if c96v13 then
          c96v12 = 3
        end
        c96v13 = c96v10:GetWeaponInfo(c96v12, c96v2)
        c96v13 = c96v13.mItemType
        c96v14 = IsNull
        c96v14 = c96v14(c96v13)
        if (not c96v14 and c96v13 == c96v5) then
          c96v14 = c96v6:GetWeaponInSlot(c96v4)
          c96v15 = nil
          c96v16 = IsNull
          c96v16 = c96v16(c96v14)
          if not c96v16 then
            c96v15 = {}
            c96v18 = 0
            c96v16 = 3
            c96v17 = 1
            for __renovice_for_0_0 = c96v18, c96v16, c96v17 do
              c96v19 = c96v14:Name__d3164b88(__renovice_for_0_0)
              if not c96v19 then
                continue
              end
              c96v22 = 0
              c96v19 = c96v14:GetNetPersistentVar(__renovice_for_0_0, c96v22)
              c96v15[__renovice_for_0_0] = c96v19
            end
          end
          c96v21 = false
          c96v6:BuildItemInLoadOutSlot(c96v10, c96v12, c96v2, c96v21)
          c96v11 = c96v6:GetWeaponInSlot(c96v4)
          c96v16 = IsNull
          c96v16 = c96v16(c96v11)
          if not c96v16 then
            c96v18 = 3
            c96v19 = 1
            c96v16 = c96v1:Name__0f88464a(c96v18, c96v19)
            c96v17 = gGameConfig
            c96v17 = c96v17:Name__a534be9c(c96v16, c96v1:GetType())
            c96v18 = c96v1:GetXP()
            c96v23 = false
            c96v19 = c96v6:RefreshLifeScanner(c96v12, c96v2, c96v23)
            c96v22 = c96v18 - c96v17
            c96v20 = math.min
            c96v20 = c96v20(c96v19, c96v22)
            c96v21 = 0
            if c96v21 < c96v20 then
              c96v11:Name__6de778ba(c96v20)
            end
            if c96v15 ~= nil then
              c96v21 = c96v15
              c96v22 = nil
              c96v23 = nil
              for __renovice_for_1_0, __renovice_for_1_1 in c96v21, c96v22, c96v23 do
                c96v11:SetNetPersistentVar(__renovice_for_1_0, __renovice_for_1_1)
              end
            end
          end
        end
      end
      c96v12 = IsNull
      c96v12 = c96v12(c96v11)
      if c96v12 then
        c96v12 = IsNull
        c96v12 = c96v12(c96v5)
        if not c96v12 then
          c96v12 = print
          c96v14 = "Abilities.lua: Failed to build "
          c96v15 = c96v5:GetName()
          c96v16 = " giving temp weapon"
          c96v13 = c96v14 .. c96v15 .. c96v16
          c96v12(c96v13)
          c96v14 = Type
          c96v14 = c96v14(c96v5)
          c96v15 = false
          c96v11 = c96v0:GiveItem(c96v14, c96v15)
          c96v12 = IsNull
          c96v12 = c96v12(c96v11)
          if not c96v12 then
            c96v11:SetXP(c96v1:GetXP())
          end
        end
      end
      c96v12 = IsNull
      c96v12 = c96v12(c96v11)
      if not c96v12 then
        c96v11:SetDamageSource(c96v1)
      end
    end
    do return end
  end
  InitializePersistentExalted = v38
  v38 = function(c97v0, c97v1, c97v2)
    local c97v3, c97v4, c97v5
    c97v3 = IsNull
    c97v3 = c97v3(c97v0)
    if c97v3 then
      do return end
    end
    c97v3 = c97v0:InventoryControl()
    c97v3 = c97v3:GetActivePowerSuit()
    c97v4 = IsNull
    c97v4 = c97v4(c97v3)
    if not c97v4 then
      c97v4 = c97v3:GetNumAbilities()
      if not (c97v4 <= c97v2) then
        c97v5 = 3
        c97v1:InitializeFromFingerprint(c97v1:Name__65a6ff3f(c97v5))
        c97v1:InitializeAttacks()
        do return end
      end
    end
    do return end
  end
  UpgradeMeleeTree = v38
  v38 = function(c98v0)
    local c98v1, c98v2, c98v3, c98v4, c98v5
    c98v1 = c98v0:InventoryControl()
    while true do
      c98v2 = IsNull
      c98v2 = c98v2(c98v1)
      if c98v2 then break end
      c98v5 = 7
      c98v2 = IsNull
      c98v2 = c98v2(c98v1:GetWeaponInSlot(c98v5))
      if c98v2 then break end
      c98v2 = Sleep
      c98v3 = 0
      c98v2(c98v3)
    end
    c98v2 = IsNull
    c98v2 = c98v2(c98v1)
    if c98v2 then
      do return end
    end
    c98v4 = 5
    c98v2 = c98v1:GetWeaponInSlot(c98v4)
    c98v3 = IsNull
    c98v3 = c98v3(c98v2)
    if not c98v3 then
      c98v5 = gLotusMeleeWeaponType
      c98v3 = c98v2:IsA(c98v5)
      if c98v3 then
        c98v2:SetupFinishers()
        do return end
      end
    end
    c98v0:Name__7b089449()
    do return end
  end
  RevertFinishers = v38
  v38 = function(c99v0, c99v1, c99v2)
    local c99v3, c99v4, c99v5, c99v6
    c99v3 = gRegion
    c99v3 = c99v3:IsMaster()
    if c99v3 then
      c99v3 = c99v0:InventoryControl()
      c99v4 = c99v3:GetWeaponInSlot(c99v2)
      c99v5 = IsNull
      c99v5 = c99v5(c99v4)
      if not c99v5 then
        c99v5 = c99v4:GetType()
        if c99v5 == c99v1 then
          c99v0:RemoveItem(c99v1)
          c99v6 = 7
          c99v3:Name__f59a18b6(c99v2, c99v6)
        end
      end
    end
    do return end
  end
  RemoveWeaponPostMigration = v38
  v38 = function(c100v0, c100v1)
    local c100v2, c100v3, c100v4, c100v5, c100v6, c100v7
    c100v2 = IsNull
    c100v2 = c100v2(c100v0)
    if not c100v2 then
      c100v2 = IsNull
      c100v2 = c100v2(c100v1)
      if not c100v2 then
        c100v2 = c100v1:GetCustomization()
        c100v5 = 0
        c100v3 = c100v2:GetColors(c100v5)
        c100v4 = Color
        c100v4 = c100v4()
        c100v6 = c100v4
        c100v7 = false
        c100v5 = c100v0:GetEnergyColor(c100v6, c100v7)
        if c100v5 then
          c100v3.mEnergyColor = c100v4
          c100v6 = 6
          c100v7 = true
          c100v3:SetInitialized(c100v6, c100v7)
        else
          c100v6 = 6
          c100v7 = false
          c100v3:SetInitialized(c100v6, c100v7)
        end
        c100v7 = true
        c100v5 = c100v0:GetEnergyColor(c100v4, c100v7)
        if c100v5 then
          c100v3.mEnergyColor1 = c100v4
          c100v6 = 7
          c100v7 = true
          c100v3:SetInitialized(c100v6, c100v7)
        else
          c100v6 = 7
          c100v7 = false
          c100v3:SetInitialized(c100v6, c100v7)
        end
        c100v6 = 0
        c100v2:SetColors(c100v6, c100v3)
        c100v1:SetCustomization(c100v2)
        do return end
      end
    end
    do return end
  end
  InitializeEnergyColor = v38
  v38 = function(c101v0, c101v1, c101v2, c101v3, c101v4, c101v5, c101v6)
    local c101v7, c101v8, c101v9, c101v10, c101v11, c101v12, c101v13, c101v14, c101v15, c101v16, c101v17, c101v18, c101v19, c101v20, c101v21, c101v22, c101v23, c101v24, c101v25, c101v26, c101v27, c101v28, c101v29
    c101v26 = false
    c101v29 = gPickUpType
    c101v25 = nil
    c101v27 = c101v25:IsA(c101v29)
    c101v28 = IsNull
    c101v10 = nil
    c101v28 = c101v28(c101v10)
    c101v27 = c101v25:Name__16fe790d(c101v10)
    c101v27 = c101v25:Name__9e567fe5()
    c101v26 = c101v27
    c101v29 = RemovePLACEMENTHelp
    c101v27 = c101v25:IsA(c101v29)
    if c101v27 then
      c101v26 = c101v25:IsEnabled()
    end
    if c101v26 then
      c101v27 = c101v0:OIEXTRACT(c101v25)
      c101v12 = nil
      if c101v27 < c101v12 then
        c101v11 = c101v25
        c101v12 = c101v27
      end
    end
    local __renovice_state_0 = 32
    __renovice_state_0 = 33
    if __renovice_state_0 == 33 then
      c101v15 = ipairs
      c101v15, c101v16, c101v17 = c101v15(c101v5)
      __renovice_state_0 = 39
    end
    if __renovice_state_0 == 34 then
      c101v20 = gRegion
      c101v24 = 0
      c101v8 = nil
      c101v19 = nil
      c101v20 = c101v20:FindAll(c101v19, c101v8, c101v24, c101v1)
      c101v21 = ipairs
      c101v21, c101v22, c101v23 = c101v21(c101v20)
      __renovice_state_0 = 38
    end
    if __renovice_state_0 == 35 then
      c101v26 = c101v25:GetHealth()
      c101v27 = 0
      if not (c101v27 < c101v26) then
        __renovice_state_0 = 38
      else
        __renovice_state_0 = 36
      end
    end
    if __renovice_state_0 == 36 then
      c101v26 = c101v0:OIEXTRACT(c101v25)
      if not (c101v26 < c101v12) then
        __renovice_state_0 = 38
      else
        __renovice_state_0 = 37
      end
    end
    if __renovice_state_0 == 37 then
      c101v11 = c101v25
      c101v12 = c101v26
      __renovice_state_0 = 38
    end
    if __renovice_state_0 == 38 then
      __renovice_state_0 = 39
    end
    if __renovice_state_0 == 39 then
      __renovice_state_0 = 40
    end
    if __renovice_state_0 == 40 then
      c101v15 = IsNull
      c101v9 = nil
      c101v15 = c101v15(c101v9)
      if c101v15 then
        __renovice_state_0 = 48
      else
        __renovice_state_0 = 41
      end
    end
    if __renovice_state_0 == 41 then
      c101v15 = ipairs
      c101v15, c101v16, c101v17 = c101v15(c101v6)
      __renovice_state_0 = 47
    end
    if __renovice_state_0 == 42 then
      c101v20 = gRegion
      c101v24 = 0
      c101v20 = c101v20:FindAll(c101v19, c101v8, c101v24, c101v1)
      c101v21 = ipairs
      c101v21, c101v22, c101v23 = c101v21(c101v20)
      __renovice_state_0 = 46
    end
    if __renovice_state_0 == 43 then
      c101v26 = c101v9:CanScan(c101v25)
      c101v27 = 8
      if c101v26 ~= c101v27 then
        __renovice_state_0 = 46
      else
        __renovice_state_0 = 44
      end
    end
    if __renovice_state_0 == 44 then
      c101v26 = c101v0:OIEXTRACT(c101v25)
      if not (c101v26 < c101v12) then
        __renovice_state_0 = 46
      else
        __renovice_state_0 = 45
      end
    end
    if __renovice_state_0 == 45 then
      c101v11 = c101v25
      c101v12 = c101v26
      __renovice_state_0 = 46
    end
    if __renovice_state_0 == 46 then
      __renovice_state_0 = 47
    end
    if __renovice_state_0 == 47 then
      __renovice_state_0 = 48
    end
    if __renovice_state_0 == 48 then
      c101v15 = Symbol
      c101v16 = "secretroomentrance"
      c101v15 = c101v15(c101v16)
      if not c101v3 then
        __renovice_state_0 = 56
      else
        __renovice_state_0 = 49
      end
    end
    if __renovice_state_0 == 49 then
      c101v16 = IsNull
      c101v16 = c101v16(c101v11)
      if c101v16 then
        __renovice_state_0 = 56
      else
        __renovice_state_0 = 50
      end
    end
    if __renovice_state_0 == 50 then
      c101v16 = IsNull
      c101v7 = nil
      c101v16 = c101v16(c101v7)
      if c101v16 then
        __renovice_state_0 = 56
      else
        __renovice_state_0 = 51
      end
    end
    if __renovice_state_0 == 51 then
      c101v16 = c101v7:FindFullPath(c101v8, c101v11:GetPosition())
      c101v17 = IsNull
      c101v17 = c101v17(c101v16)
      if c101v17 then
        __renovice_state_0 = 53
      else
        __renovice_state_0 = 52
      end
    end
    if __renovice_state_0 == 52 then
      c101v17 = #c101v16
      if c101v17 ~= 0 then
        __renovice_state_0 = 56
      else
        __renovice_state_0 = 53
      end
    end
    if __renovice_state_0 == 53 then
      c101v17 = gRegion
      c101v17 = c101v17:FindNearestTagged(c101v15, c101v8)
      c101v18 = IsNull
      c101v18 = c101v18(c101v17)
      if not c101v18 then
        __renovice_state_0 = 55
      else
        __renovice_state_0 = 54
      end
    end
    if __renovice_state_0 == 54 then
      c101v18 = print
      c101v19 = "HelminthTreasure having trouble finding a valid path for the treasure destination!"
      c101v18(c101v19)
      __renovice_state_0 = 56
    end
    if __renovice_state_0 == 55 then
      do return c101v11 end
    end
    if __renovice_state_0 == 56 then
      c101v16 = IsNull
      c101v16 = c101v16(c101v11)
      if not c101v16 then
        __renovice_state_0 = 58
      else
        __renovice_state_0 = 57
      end
    end
    if __renovice_state_0 == 57 then
      c101v16 = print
      c101v17 = "HelminthTreasure having trouble finding any treasure to loot!"
      c101v16(c101v17)
      __renovice_state_0 = 58
    end
    if __renovice_state_0 == 58 then
      do return c101v11 end
    end
    c101v20 = gRegion
    c101v24 = 0
    c101v20 = c101v20:FindAll(c101v19, c101v8, c101v24, c101v1)
    c101v21 = ipairs
    c101v21, c101v22, c101v23 = c101v21(c101v20)
    for __renovice_for_0_0, __renovice_for_0_1 in c101v15, c101v16, c101v17 do
      local __renovice_state_1 = 0
      if c101v2 ~= nil then
        __renovice_state_1 = 2
      else
        __renovice_state_1 = 1
      end
      if __renovice_state_1 == 1 then
        c101v2 = c101v0
        __renovice_state_1 = 2
      end
      if __renovice_state_1 == 2 then
        c101v7 = gRegion
        c101v7 = c101v7:GetNpcMgr()
        c101v8 = c101v2:GetPosition()
        c101v9 = IsNull
        c101v9 = c101v9(c101v7)
        if c101v9 then
          __renovice_state_1 = 4
        else
          __renovice_state_1 = 3
        end
      end
      if __renovice_state_1 == 3 then
        c101v12 = 10
        c101v7:Name__4973dd9c(c101v8, c101v12)
        __renovice_state_1 = 4
      end
      if __renovice_state_1 == 4 then
        c101v9 = c101v0:InventoryControl()
        c101v11 = gRegion
        c101v11 = c101v11:IsMaster()
        if not c101v11 then
          __renovice_state_1 = 6
        else
          __renovice_state_1 = 5
        end
      end
      if __renovice_state_1 == 5 then
        c101v10 = c101v0:GetPlayer()
        if c101v10 then
          __renovice_state_1 = 7
        else
          __renovice_state_1 = 6
        end
      end
      if __renovice_state_1 == 6 then
        c101v10 = nil
        __renovice_state_1 = 7
      end
      if __renovice_state_1 == 7 then
        c101v11 = nil
        c101v12 = 3.4028234663852886e+38
        c101v13 = Symbol
        c101v14 = "LootPriorityEntity"
        c101v13 = c101v13(c101v14)
        c101v14 = gRegion
        c101v14 = c101v14:FindNearestTagged(c101v13, c101v8)
        c101v15 = IsNull
        c101v15 = c101v15(c101v14)
        if c101v15 then
          __renovice_state_1 = 10
        else
          __renovice_state_1 = 8
        end
      end
      if __renovice_state_1 == 8 then
        c101v15 = Distance
        c101v16 = c101v14:GetPosition()
        c101v15 = c101v15(c101v16, c101v8)
        if not (c101v15 <= c101v1) then
          __renovice_state_1 = 10
        else
          __renovice_state_1 = 9
        end
      end
      if __renovice_state_1 == 9 then
        c101v11 = c101v14
        c101v12 = c101v15
        __renovice_state_1 = 10
      end
      if __renovice_state_1 == 10 then
        c101v15 = IsNull
        c101v15 = c101v15(c101v11)
        if c101v15 then
          __renovice_state_1 = 19
        else
          __renovice_state_1 = 11
        end
      end
      if __renovice_state_1 == 11 then
        if not c101v3 then
          __renovice_state_1 = 18
        else
          __renovice_state_1 = 12
        end
      end
      if __renovice_state_1 == 12 then
        c101v15 = IsNull
        c101v15 = c101v15(c101v7)
        if c101v15 then
          __renovice_state_1 = 18
        else
          __renovice_state_1 = 13
        end
      end
      if __renovice_state_1 == 13 then
        c101v15 = c101v7:FindFullPath(c101v8, c101v11:GetPosition())
        c101v16 = IsNull
        c101v16 = c101v16(c101v15)
        if c101v16 then
          __renovice_state_1 = 15
        else
          __renovice_state_1 = 14
        end
      end
      if __renovice_state_1 == 14 then
        c101v16 = #c101v15
        if c101v16 ~= 0 then
          __renovice_state_1 = 16
        else
          __renovice_state_1 = 15
        end
      end
      if __renovice_state_1 == 15 then
        c101v11 = nil
        c101v12 = 3.4028234663852886e+38
        __renovice_state_1 = 19
      end
      if __renovice_state_1 == 16 then
        do return c101v11 end
      end
      if __renovice_state_1 == 18 then
        do return c101v11 end
      end
      if __renovice_state_1 ~= 19 then
        continue
      end
      c101v15 = ipairs
      c101v15, c101v16, c101v17 = c101v15(c101v4)
    end
    do return end
  end
  FindClosest = v38
  v38 = function(c102v0, c102v1, c102v2, c102v3, c102v4, c102v5, c102v6)
    local c102v7, c102v8, c102v9, c102v10, c102v11, c102v12, c102v13, c102v14, c102v15, c102v16, c102v17, c102v18, c102v19, c102v20, c102v21, c102v22, c102v23
    c102v22 = IsNull
    c102v11 = nil
    c102v22 = c102v22(c102v11)
    c102v21 = nil
    c102v22 = c102v21:Name__16fe790d(c102v11)
    c102v22 = c102v21:Name__9e567fe5()
    c102v22 = table.insert
    c102v7 = nil
    c102v22(c102v7, c102v21)
    c102v12 = nil
    c102v13 = nil
    c102v14 = nil
    for __renovice_for_0_0, __renovice_for_0_1 in c102v12, c102v13, c102v14 do
      c102v12 = ipairs
      c102v12, c102v13, c102v14 = c102v12(c102v4)
      for __renovice_for_1_0, __renovice_for_1_1 in c102v12, c102v13, c102v14 do
        c102v16 = gRegion
        c102v20 = 0
        c102v9 = nil
        c102v16 = c102v16:FindAll(__renovice_for_1_1, c102v9, c102v20, c102v1)
        c102v17 = ipairs
        c102v17, c102v18, c102v19 = c102v17(c102v16)
        for __renovice_for_2_0, __renovice_for_2_1 in c102v17, c102v18, c102v19 do
          c102v22 = __renovice_for_2_1:GetHealth()
          c102v23 = 0
          if not (c102v23 < c102v22) then
            continue
          end
          c102v22 = table.insert
          c102v22(c102v7, __renovice_for_2_1)
        end
      end
      c102v12 = ipairs
      c102v12, c102v13, c102v14 = c102v12(c102v6)
      for __renovice_for_3_0, __renovice_for_3_1 in c102v12, c102v13, c102v14 do
        c102v16 = gRegion
        c102v20 = 0
        c102v16 = c102v16:FindTaggedInRadius(__renovice_for_3_1, c102v9, c102v20, c102v1)
        c102v17 = ipairs
        c102v17, c102v18, c102v19 = c102v17(c102v16)
        for __renovice_for_4_0, __renovice_for_4_1 in c102v17, c102v18, c102v19 do
          c102v22 = __renovice_for_4_1:IsEnabled()
          if not c102v22 then
            continue
          end
          c102v22 = table.insert
          c102v22(c102v7, __renovice_for_4_1)
        end
      end
      c102v12 = IsNull
      c102v10 = nil
      c102v12 = c102v12(c102v10)
      c102v12 = ipairs
      c102v12, c102v13, c102v14 = c102v12(c102v5)
      for __renovice_for_5_0, __renovice_for_5_1 in c102v12, c102v13, c102v14 do
        c102v16 = gRegion
        c102v20 = 0
        c102v16 = c102v16:FindAll(__renovice_for_5_1, c102v9, c102v20, c102v1)
        c102v17 = ipairs
        c102v17, c102v18, c102v19 = c102v17(c102v16)
        for __renovice_for_6_0, __renovice_for_6_1 in c102v17, c102v18, c102v19 do
          c102v22 = c102v10:CanScan(__renovice_for_6_1)
          c102v23 = 8
          if c102v22 ~= c102v23 then
            continue
          end
          c102v22 = table.insert
          c102v22(c102v7, __renovice_for_6_1)
        end
      end
      for __renovice_for_7_0, __renovice_for_7_1 in c102v12, c102v13, c102v14 do
      end
      do return c102v7 end
    end
    c102v16 = gRegion
    c102v20 = 0
    c102v15 = nil
    c102v16 = c102v16:FindAll(c102v15, c102v9, c102v20, c102v1)
    c102v17 = ipairs
    c102v17, c102v18, c102v19 = c102v17(c102v16)
    for __renovice_for_8_0, __renovice_for_8_1 in c102v12, c102v13, c102v14 do
      local __renovice_state_0 = 0
      if c102v2 ~= nil then
        __renovice_state_0 = 2
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c102v2 = c102v0
        __renovice_state_0 = 2
      end
      if __renovice_state_0 == 2 then
        c102v7 = {}
        c102v8 = gRegion
        c102v8 = c102v8:GetNpcMgr()
        c102v9 = c102v2:GetPosition()
        c102v10 = IsNull
        c102v10 = c102v10(c102v8)
        if c102v10 then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        c102v13 = 10
        c102v8:Name__4973dd9c(c102v9, c102v13)
        __renovice_state_0 = 4
      end
      if __renovice_state_0 == 4 then
        c102v10 = c102v0:InventoryControl()
        c102v12 = gRegion
        c102v12 = c102v12:IsMaster()
        if not c102v12 then
          __renovice_state_0 = 6
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c102v11 = c102v0:GetPlayer()
        if c102v11 then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        c102v11 = nil
        __renovice_state_0 = 7
      end
      if __renovice_state_0 ~= 7 then
        continue
      end
      c102v12 = ipairs
      c102v12, c102v13, c102v14 = c102v12(c102v3)
    end
    do return end
  end
  FindAllInRange = v38
  v38 = function(c104v0, c104v1, c104v2)
    local c104v3, c104v4, c104v5, c104v6, c104v7, c104v8, c104v9, c104v10, c104v11, c104v12, c104v13, c104v14, c104v15, c104v16, c104v17, c104v18, c104v19, c104v20, c104v21, c104v22, c104v23, c104v24, c104v25, c104v26, c104v27
    c104v3 = gRegion
    c104v3 = c104v3:GetNpcMgr()
    c104v4 = Vector
    c104v5 = c104v0.x
    c104v6 = c104v0.y
    c104v7 = c104v0.z
    c104v4 = c104v4(c104v5, c104v6, c104v7)
    c104v5 = Vector
    c104v6 = c104v1.x
    c104v7 = c104v1.y
    c104v8 = c104v1.z
    c104v5 = c104v5(c104v6, c104v7, c104v8)
    c104v6 = gRegion
    c104v9 = Vector
    c104v10 = 0
    c104v11 = 1
    c104v12 = 0
    c104v9 = c104v9(c104v10, c104v11, c104v12)
    c104v8 = c104v4 + c104v9
    c104v10 = Vector
    c104v11 = 0
    c104v12 = 20
    c104v13 = 0
    c104v10 = c104v10(c104v11, c104v12, c104v13)
    c104v9 = c104v4 - c104v10
    c104v10 = nil
    c104v11 = nil
    c104v13 = true
    c104v6:Raycast(c104v8, c104v9, c104v10, c104v11, c104v4, c104v13)
    c104v9 = 25
    c104v10 = 0
    c104v11 = -25
    c104v3:Name__4973dd9c(c104v4, c104v9, c104v10, c104v11)
    c104v9 = 25
    c104v10 = 0
    c104v11 = -25
    c104v3:Name__4973dd9c(c104v5, c104v9, c104v10, c104v11)
    c104v10 = false
    c104v6 = c104v3:FindFullPath(c104v4, c104v5, c104v10)
    c104v7 = #c104v6
    c104v8 = 2
    if c104v7 < c104v8 then
      c104v6 = {c104v0, c104v1}
    else
      c104v7 = #c104v6
      c104v8 = 0
      if c104v8 < c104v7 then
        c104v7 = Distance
        c104v9 = #c104v6
        c104v8 = c104v6[c104v9]
        c104v7 = c104v7(c104v8, c104v1)
        c104v8 = 2
        if c104v8 < c104v7 then
          c104v7 = table.insert
          c104v7(c104v6, c104v1)
        end
      end
    end
    c104v6[1] = c104v0
    c104v7 = #c104v6
    c104v8 = 2
    if c104v8 < c104v7 then
      c104v7 = Dot
      c104v9 = c104v6[2]
      c104v8 = c104v9 - c104v0
      c104v10 = c104v6[3]
      c104v9 = c104v10 - c104v0
      c104v7 = c104v7(c104v8, c104v9)
      c104v8 = 0
      if c104v7 < c104v8 then
        c104v7 = table.remove
        c104v9 = 2
        c104v7(c104v6, c104v9)
      end
    end
    c104v7 = {}
    while true do
      c104v8 = #c104v6
      c104v9 = 3
      if not (c104v9 <= c104v8) then
        c104v8 = #c104v6
        c104v9 = 1
        if c104v9 < c104v8 then
          c104v10 = { p1 = nil, p2 = nil, d = nil }
          c104v11 = c104v6[1]
          c104v10.p1 = c104v11
          c104v11 = c104v6[2]
          c104v10.p2 = c104v11
          c104v11 = Distance
          c104v12 = c104v6[1]
          c104v13 = c104v6[2]
          c104v11 = c104v11(c104v12, c104v13)
          c104v10.d = c104v11
          c104v8 = table.insert
          c104v8(c104v7, c104v10)
        end
        c104v8 = 1
        c104v9 = 0
        c104v10 = Vector
        c104v10 = c104v10()
        c104v11 = c104v6[1]
        c104v12 = function(c103v0)
          local c103v1, c103v2, c103v3, c103v4, c103v5, c103v6, c103v7, c103v8, c103v9, c103v10, c103v11, c103v12
          c103v2 = c104v2
          c103v3 = DeltaTime
          c103v3 = c103v3()
          c103v1 = c103v2 * c103v3
          while true do
            c103v2 = c104v8
            c103v4 = c104v7
            c103v3 = #c103v4
            if not (c103v2 <= c103v3) then break end
            c103v2 = 1e-05
            if not (c103v2 < c103v1) then break end
            c103v3 = c104v7
            c103v4 = c104v8
            c103v2 = c103v3[c103v4]
            c103v4 = 1
            c103v6 = c104v9
            c103v8 = c103v2.d
            c103v7 = c103v1 / c103v8
            c103v5 = c103v6 + c103v7
            c103v3 = math.min
            c103v3 = c103v3(c103v4, c103v5)
            c103v6 = c104v9
            c103v5 = c103v3 - c103v6
            c103v6 = c103v2.d
            c103v4 = c103v5 * c103v6
            c103v1 = c103v1 - c103v4
            c104v9 = c103v3
            c103v4 = c103v2.c
            if c103v4 then
              c103v5 = c103v2.c
              c103v7 = RotateTowards
              c103v8 = c103v2.r1
              c103v9 = c103v2.r2
              c103v11 = c104v9
              c103v12 = c103v2.theta
              c103v10 = c103v11 * c103v12
              c103v7 = c103v7(c103v8, c103v9, c103v10)
              c103v8 = c103v2.r
              c103v6 = c103v7 * c103v8
              c103v4 = c103v5 + c103v6
              c104v0 = c103v4
            else
              c103v4 = LerpVector
              c103v5 = c103v2.p1
              c103v6 = c103v2.p2
              c103v7 = c104v9
              c103v4 = c103v4(c103v5, c103v6, c103v7)
              c104v0 = c103v4
            end
            c103v4 = c104v9
            c103v5 = 1
            if not (c103v5 <= c103v4) then
              continue
            end
            c103v5 = c104v8
            c103v4 = c103v5 + 1
            c104v8 = c103v4
            c103v4 = 0
            c104v9 = c103v4
          end
          c103v2 = c104v10
          c103v4 = c104v0
          c103v4 = c103v4.x
          c103v6 = Noise
          c103v8 = Time
          c103v8 = c103v8()
          c103v7 = c103v8 * 0.25
          c103v6 = c103v6(c103v7)
          c103v5 = c103v6 * 1.5
          c103v3 = c103v4 + c103v5
          c103v2.x = c103v3
          c103v2 = c104v10
          c103v5 = c104v0
          c103v5 = c103v5.y
          c103v4 = c103v5 + 1
          c103v6 = Noise
          c103v8 = Time
          c103v8 = c103v8()
          c103v7 = c103v8 * 1
          c103v6 = c103v6(c103v7)
          c103v5 = c103v6 * 0.35
          c103v3 = c103v4 + c103v5
          c103v2.y = c103v3
          c103v2 = c104v10
          c103v4 = c104v0
          c103v4 = c103v4.z
          c103v6 = Noise
          c103v8 = Time
          c103v8 = c103v8()
          c103v7 = c103v8 * 0.35
          c103v6 = c103v6(c103v7)
          c103v5 = c103v6 * 1.5
          c103v3 = c103v4 + c103v5
          c103v2.z = c103v3
          c103v2 = IsNull
          c103v2 = c103v2(c103v0)
          if not c103v2 then
            c103v4 = c104v10
            c103v0:SetPosition(c103v4)
            c103v4 = LookTo
            c103v5 = c104v11
            c103v6 = c104v0
            c103v0:SetRotation(c103v4(c103v5, c103v6))
          end
          c103v2 = c104v0
          c104v11 = c103v2
          c103v3 = c104v8
          c103v5 = c104v7
          c103v4 = #c103v5
          if not (c103v3 <= c103v4) then
            c103v2 = false
            do return c103v2 end
          end
          c103v2 = true
          do return c103v2 end
        end
        do return c104v12 end
      end
      c104v8 = c104v6[1]
      c104v9 = c104v6[2]
      c104v10 = c104v6[3]
      c104v11 = table.remove
      c104v13 = 2
      c104v11(c104v6, c104v13)
      c104v11 = c104v9 - c104v8
      c104v12 = c104v10 - c104v9
      c104v13 = Length
      c104v13 = c104v13(c104v11)
      c104v14 = Length
      c104v14 = c104v14(c104v12)
      c104v16 = math.min
      c104v16 = c104v16(c104v13, c104v14)
      c104v15 = c104v16 / 2
      c104v18 = c104v15 / c104v13
      c104v17 = c104v11 * c104v18
      c104v16 = c104v9 - c104v17
      c104v19 = c104v15 / c104v14
      c104v18 = c104v12 * c104v19
      c104v17 = c104v9 + c104v18
      c104v18 = c104v11.z
      c104v19 = 0
      c104v21 = c104v11.x
      c104v20 = -c104v21
      c104v11.x = c104v18
      c104v11.y = c104v19
      c104v11.z = c104v20
      c104v18 = c104v12.z
      c104v19 = 0
      c104v21 = c104v12.x
      c104v20 = -c104v21
      c104v12.x = c104v18
      c104v12.y = c104v19
      c104v12.z = c104v20
      c104v18 = Normalize
      c104v18(c104v11)
      c104v18 = Normalize
      c104v18(c104v12)
      c104v19 = Dot
      c104v19 = c104v19(c104v11, c104v12)
      c104v18 = math.abs
      c104v18 = c104v18(c104v19)
      c104v19 = 0.99
      c104v18 = Length
      c104v18 = c104v18(c104v11)
      c104v19 = 0
      c104v18 = Length
      c104v18 = c104v18(c104v12)
      c104v19 = 0
      c104v24 = c104v16.z
      c104v25 = c104v17.z
      c104v23 = c104v24 - c104v25
      c104v24 = c104v12.x
      c104v22 = c104v23 * c104v24
      c104v25 = c104v16.x
      c104v26 = c104v17.x
      c104v24 = c104v25 - c104v26
      c104v25 = c104v12.z
      c104v23 = c104v24 * c104v25
      c104v21 = c104v22 - c104v23
      c104v20 = c104v11 * c104v21
      c104v23 = c104v11.x
      c104v24 = c104v12.z
      c104v22 = c104v23 * c104v24
      c104v24 = c104v11.z
      c104v25 = c104v12.x
      c104v23 = c104v24 * c104v25
      c104v21 = c104v22 - c104v23
      c104v19 = c104v20 / c104v21
      c104v18 = c104v16 + c104v19
      c104v21 = c104v16.y
      c104v22 = c104v17.y
      c104v20 = c104v21 + c104v22
      c104v19 = c104v20 / 2
      c104v18.y = c104v19
      c104v19 = c104v16 - c104v18
      c104v20 = c104v17 - c104v18
      c104v22 = 1
      c104v23 = Length
      c104v21 = math.max
      c104v21 = c104v21(c104v22, c104v23(c104v19))
      c104v19 = c104v19 / c104v21
      c104v20 = c104v20 / c104v21
      c104v22 = AngleBetween
      c104v22 = c104v22(c104v19, c104v20)
      c104v25 = { p1 = nil, p2 = nil, d = nil }
      c104v25.p1 = c104v8
      c104v25.p2 = c104v16
      c104v26 = Distance
      c104v26 = c104v26(c104v8, c104v16)
      c104v25.d = c104v26
      c104v23 = table.insert
      c104v23(c104v7, c104v25)
      c104v25 = { p1 = nil, p2 = nil, d = nil, r1 = nil, r2 = nil, r = nil, theta = nil, c = nil }
      c104v25.p1 = c104v16
      c104v25.p2 = c104v17
      c104v27 = math.rad
      c104v27 = c104v27(c104v22)
      c104v26 = c104v21 * c104v27
      c104v25.d = c104v26
      c104v25.r1 = c104v19
      c104v25.r2 = c104v20
      c104v25.r = c104v21
      c104v25.theta = c104v22
      c104v25.c = c104v18
      c104v23 = table.insert
      c104v23(c104v7, c104v25)
      c104v23 = table.remove
      c104v25 = 1
      c104v23(c104v6, c104v25)
      c104v6[1] = c104v17
      c104v20 = { p1 = nil, p2 = nil, d = nil }
      c104v20.p1 = c104v8
      c104v20.p2 = c104v9
      c104v21 = Distance
      c104v21 = c104v21(c104v8, c104v9)
      c104v20.d = c104v21
      c104v18 = table.insert
      c104v18(c104v7, c104v20)
      c104v20 = { p1 = nil, p2 = nil, d = nil }
      c104v20.p1 = c104v9
      c104v20.p2 = c104v10
      c104v21 = Distance
      c104v21 = c104v21(c104v9, c104v10)
      c104v20.d = c104v21
      c104v18 = table.insert
      c104v18(c104v7, c104v20)
      c104v18 = table.remove
      c104v20 = 1
      c104v18(c104v6, c104v20)
      c104v18 = table.remove
      c104v20 = 1
      c104v18(c104v6, c104v20)
    end
    do return end
  end
  CreatePathHelper = v38
  v38 = function(c105v0, c105v1)
    local c105v2, c105v3, c105v4, c105v5, c105v6, c105v7, c105v8, c105v9, c105v10, c105v11
    c105v2 = IsNull
    c105v2 = c105v2(c105v0)
    if not c105v2 then
      c105v2 = IsNull
      c105v2 = c105v2(c105v1)
      if not c105v2 then
        c105v2 = c105v1:GetPlayerName()
        c105v3 = c105v0:InventoryControl()
        c105v3 = c105v3:GetActivePowerSuit()
        c105v4 = IsNull
        c105v4 = c105v4(c105v3)
        if not c105v4 then
          c105v4 = c105v3:GetAbilities()
          c105v5 = {}
          c105v6 = ipairs
          c105v6, c105v7, c105v8 = c105v6(c105v4)
          for __renovice_for_0_0, __renovice_for_0_1 in c105v6, c105v7, c105v8 do
            c105v9 = IsNull
            c105v9 = c105v9(__renovice_for_0_1)
            if c105v9 then
              continue
            end
            c105v9 = __renovice_for_0_1:GetCooldownTime()
            c105v10 = 0
            if not (c105v10 < c105v9) then
              continue
            end
            c105v10 = gGameRules
            c105v10 = c105v10:GetCurrentGameTime()
            c105v11 = __renovice_for_0_1:GetCooldownTime()
            c105v9 = c105v10 + c105v11
            c105v10 = __renovice_for_0_1:GetType()
            c105v10 = c105v10:GetName()
            c105v5[c105v10] = c105v9
          end
          c105v6 = next
          c105v6 = c105v6(c105v5)
          if c105v6 then
            c105v6 = _T.drifterHorseCooldowns
            if not c105v6 then
              c105v6 = _T
              c105v7 = {}
              c105v6.drifterHorseCooldowns = c105v7
            end
            c105v6 = _T.drifterHorseCooldowns
            c105v6[c105v2] = c105v5
          end
        end
        do return end
      end
    end
    do return end
  end
  CacheHorseAbilitiesCooldowns = v38
  v38 = function(c106v0, c106v1)
    local c106v2, c106v3, c106v4, c106v5, c106v6, c106v7, c106v8, c106v9, c106v10, c106v11, c106v12
    c106v2 = IsNull
    c106v2 = c106v2(c106v0)
    if not c106v2 then
      c106v4 = gLotusVehicleAvatarType
      c106v2 = c106v0:IsA(c106v4)
      if not c106v2 then
        do return end
      end
      c106v2 = IsNull
      c106v2 = c106v2(c106v1)
      if c106v2 then
        do return end
      end
      c106v2 = c106v0:InventoryControl()
      c106v2 = c106v2:GetActivePowerSuit()
      while true do
        c106v3 = IsNull
        c106v3 = c106v3(c106v2)
        if not c106v3 then break end
        c106v3 = Sleep
        c106v4 = 0
        c106v3(c106v4)
        c106v3 = IsNull
        c106v3 = c106v3(c106v0)
        if c106v3 then
          do return end
        end
        c106v3 = c106v0:InventoryControl()
        c106v2 = c106v3:GetActivePowerSuit()
      end
      c106v3 = c106v1:GetPlayerName()
      c106v5 = _T.drifterHorseCooldowns
      c106v4 = IsNull
      c106v4 = c106v4(c106v5)
      if not c106v4 then
        c106v6 = _T.drifterHorseCooldowns
        c106v5 = c106v6[c106v3]
        c106v4 = IsNull
        c106v4 = c106v4(c106v5)
        if not c106v4 then
          c106v4 = c106v2:GetAbilities()
          c106v6 = _T.drifterHorseCooldowns
          c106v5 = c106v6[c106v3]
          c106v6 = ipairs
          c106v6, c106v7, c106v8 = c106v6(c106v4)
          for __renovice_for_0_0, __renovice_for_0_1 in c106v6, c106v7, c106v8 do
            c106v9 = IsNull
            c106v9 = c106v9(__renovice_for_0_1)
            if c106v9 then
              continue
            end
            c106v12 = __renovice_for_0_1:GetType()
            c106v12 = c106v12:GetName()
            c106v11 = c106v5[c106v12]
            c106v10 = c106v11 or 0
            c106v11 = gGameRules
            c106v11 = c106v11:GetCurrentGameTime()
            c106v9 = c106v10 - c106v11
            c106v10 = 0
            if not (c106v10 < c106v9) then
              continue
            end
            __renovice_for_0_1:SetCooldownTime(c106v9)
          end
          c106v6 = _T.drifterHorseCooldowns
          c106v7 = nil
          c106v6[c106v3] = c106v7
          c106v6 = next
          c106v7 = _T.drifterHorseCooldowns
          c106v6 = c106v6(c106v7)
          if not c106v6 then
            c106v6 = _T
            c106v7 = nil
            c106v6.drifterHorseCooldowns = c106v7
          end
          do return end
        end
      end
      do return end
    end
    do return end
  end
  ApplyCachedHorseAbilitiesCooldowns = v38
  v38 = function(c107v0, c107v1, c107v2)
    local c107v3, c107v4, c107v5, c107v6, c107v7, c107v8, c107v9
    local __renovice_state_0 = 0
    c107v3 = IsNull
    c107v3 = c107v3(c107v0)
    if c107v3 then
      __renovice_state_0 = 3
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c107v3 = IsNull
      c107v3 = c107v3(c107v1)
      if c107v3 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c107v3 = IsNull
      c107v3 = c107v3(c107v1:GetLoadOut())
      if not c107v3 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      do return end
    end
    if __renovice_state_0 == 4 then
      c107v3 = c107v1:GetLoadOut()
      c107v6 = 6
      c107v7 = 3
      c107v4 = c107v3:GetWeaponInfo(c107v6, c107v7)
      c107v5 = IsNull
      c107v5 = c107v5(c107v4)
      if c107v5 then
        __renovice_state_0 = 14
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c107v5 = c107v4:GetCustomization()
      c107v6 = IsNull
      c107v6 = c107v6(c107v2)
      if not c107v6 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c107v8 = gBaseAvatarType
      c107v6 = c107v0:IsA(c107v8)
      if not c107v6 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c107v6 = c107v0:InventoryControl()
      c107v9 = 3
      c107v2 = c107v6:GetWeaponInSlot(c107v9)
      __renovice_state_0 = 8
    end
    if __renovice_state_0 == 8 then
      c107v6 = IsNull
      c107v6 = c107v6(c107v2)
      if c107v6 then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c107v2:SetCustomizationEntity(c107v0)
      c107v2:SetCustomization(c107v5)
      c107v2:ApplyCustomizationAttachments(c107v5)
      c107v2:CreateUpgradeAttachments()
      c107v7 = c107v4.mItemName
      if c107v7 == "" then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      c107v6 = c107v4.mItemName
      if c107v6 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c107v6 = "/Lotus/Language/Duviri/Horse"
      __renovice_state_0 = 12
    end
    if __renovice_state_0 == 12 then
      c107v9 = Symbol
      c107v2:SetLocalizeTag(c107v9(c107v6))
      __renovice_state_0 = 13
    end
    if __renovice_state_0 == 13 then
      c107v5:ApplyCustomization(c107v0)
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 14 then
      do return end
    end
    do return end
  end
  SetupHorseCustomization = v38
  v39 = gBaseAvatarType
  v40 = gHitProxyPhysicsType
  v41 = gRagdollType
  v42 = gPickUpType
  v38 = {v39, v40, v41, v42}
  v39 = function(c108v0, c108v1, c108v2, c108v3)
    local c108v4, c108v5, c108v6, c108v7, c108v8, c108v9, c108v10, c108v11, c108v12
    c108v4 = v38
    if c108v2 then
      c108v5 = type
      c108v5 = c108v5(c108v2)
      if c108v5 == "table" then
        c108v5 = pairs
        c108v5, c108v6, c108v7 = c108v5(c108v2)
        for __renovice_for_0_0, __renovice_for_0_1 in c108v5, c108v6, c108v7 do
          c108v10 = table.insert
          c108v10(c108v4, __renovice_for_0_1)
        end
      else
        c108v5 = table.insert
        c108v5(c108v4, c108v2)
      end
    end
    c108v5 = gRegion
    c108v10 = nil
    c108v11 = Vector
    c108v5 = c108v5:RaycastIgnoreTypes(c108v0, c108v1, c108v4, c108v10, c108v11())
    if c108v3 then
      repeat
        c108v7 = IsNull
        c108v7 = c108v7(c108v5)
        if c108v7 then
          c108v6 = Color
          c108v7 = 0
          c108v8 = 255
          c108v9 = 0
          c108v6 = c108v6(c108v7, c108v8, c108v9)
          if c108v6 then break end
        end
        c108v6 = Color
        c108v7 = 255
        c108v8 = 0
        c108v9 = 0
        c108v6 = c108v6(c108v7, c108v8, c108v9)
      until true
      c108v7 = gRegion
      c108v12 = 3
      c108v7:Name__aae5e771(c108v0, c108v1, c108v6, c108v12)
    end
    do return c108v5 end
  end
  v40 = function(c109v0, c109v1, c109v2, c109v3, c109v4)
    local c109v5, c109v6, c109v7, c109v8, c109v9, c109v10, c109v11
    c109v5 = IsNull
    c109v5 = c109v5(c109v1)
    if c109v5 then
      c109v5 = false
      do return c109v5 end
    end
    c109v5 = IsNull
    c109v5 = c109v5(c109v2)
    if not c109v5 then
      c109v5 = Distance
      c109v5 = c109v5(c109v0, c109v1:GetPosition())
      if c109v5 <= c109v2 then
        c109v5 = true
        do return c109v5 end
      end
    end
    c109v5 = c109v1:GetCenter()
    c109v6 = Vector
    c109v7 = c109v5.x
    c109v8 = c109v1:GetBoundsMax()
    c109v8 = c109v8.y
    c109v9 = c109v5.z
    c109v6 = c109v6(c109v7, c109v8, c109v9)
    c109v7 = Vector
    c109v8 = c109v5.x
    c109v9 = c109v1:GetBoundsMin()
    c109v9 = c109v9.y
    c109v10 = c109v5.z
    c109v7 = c109v7(c109v8, c109v9, c109v10)
    c109v10 = gLotusAvatarType
    c109v8 = c109v1:IsA(c109v10)
    if c109v8 then
      c109v1:GetCapsule(c109v6, c109v7)
    end
    c109v8 = v39
    c109v8 = c109v8(c109v0, c109v5, c109v3, c109v4)
    c109v9 = IsNull
    c109v9 = c109v9(c109v8)
    if (c109v9 or c109v8 == c109v1) then
      c109v9 = true
      do return c109v9 end
    end
    c109v9 = v39
    c109v9 = c109v9(c109v0, c109v6, c109v3, c109v4)
    c109v10 = IsNull
    c109v10 = c109v10(c109v9)
    if (c109v10 or c109v9 == c109v1) then
      c109v10 = true
      do return c109v10 end
    end
    c109v10 = v39
    c109v10 = c109v10(c109v0, c109v7, c109v3, c109v4)
    c109v11 = IsNull
    c109v11 = c109v11(c109v10)
    if (c109v11 or c109v10 ~= c109v1) then
      c109v11 = false
      do return c109v11 end
    end
    c109v11 = true
    do return c109v11 end
  end
  PositionHasLOSToEntity = v40
  v40 = function(c110v0, c110v1, c110v2, c110v3, c110v4, c110v5)
    local c110v6, c110v7, c110v8, c110v9, c110v10, c110v11, c110v12
    local __renovice_state_0 = 0
    c110v6 = IsNull
    c110v6 = c110v6(c110v0)
    if c110v6 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c110v6 = IsNull
      c110v6 = c110v6(c110v1)
      if not c110v6 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c110v6 = print
      c110v7 = "Attempted to evaluate line of sight between null entities"
      c110v6(c110v7)
      do return end
    end
    if __renovice_state_0 == 3 then
      c110v6 = IsNull
      c110v6 = c110v6(c110v2)
      if c110v6 then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c110v6 = c110v0:DistanceToEntity(c110v1)
      if not (c110v6 <= c110v2) then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c110v6 = true
      do return c110v6 end
    end
    if __renovice_state_0 == 6 then
      if not c110v5 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c110v6 = type
      c110v6 = c110v6(c110v5)
      if c110v6 == "number" then
        __renovice_state_0 = 9
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      c110v5 = 0.5
      __renovice_state_0 = 9
    end
    if __renovice_state_0 == 9 then
      c110v6 = c110v0:IsHumanPlayer()
      if not c110v6 then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      c110v6 = c110v0:Name__40b06462(c110v1)
      c110v7 = 0
      if not (c110v7 < c110v6) then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c110v6 = c110v0:Layertrackers()
      if not c110v6 then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      c110v6 = true
      do return c110v6 end
    end
    if __renovice_state_0 == 13 then
      c110v8 = gBaseAvatarType
      c110v6 = c110v1:IsA(c110v8)
      if not c110v6 then
        __renovice_state_0 = 20
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c110v11 = 0.25
      c110v9 = math.max
      c110v9 = c110v9(c110v5, c110v11)
      do return c110v0:Name__11ff07ac(c110v1, c110v9) end
    end
    if __renovice_state_0 == 16 then
      c110v6 = c110v0:GetAgent()
      c110v7 = IsNull
      c110v7 = c110v7(c110v6)
      if c110v7 then
        __renovice_state_0 = 20
      else
        __renovice_state_0 = 17
      end
    end
    if __renovice_state_0 == 17 then
      c110v9 = gBaseAvatarType
      c110v7 = c110v1:IsA(c110v9)
      if not c110v7 then
        __renovice_state_0 = 20
      else
        __renovice_state_0 = 18
      end
    end
    if __renovice_state_0 == 18 then
      c110v12 = 0.25
      c110v10 = math.max
      c110v10 = c110v10(c110v5, c110v12)
      c110v7 = c110v6:Name__11ff07ac(c110v1, c110v10)
      if not c110v7 then
        __renovice_state_0 = 20
      else
        __renovice_state_0 = 19
      end
    end
    if __renovice_state_0 == 19 then
      c110v7 = true
      do return c110v7 end
    end
    if __renovice_state_0 == 20 then
      c110v6 = c110v0:EyePosition()
      c110v7 = c110v6
      c110v8 = c110v0:DamageControl()
      c110v10 = 1
      c110v8 = c110v8:GetPartPosition(c110v10)
      c110v10 = c110v6.y
      c110v11 = c110v8.y
      if not (c110v11 <= c110v10) then
        __renovice_state_0 = 22
      else
        __renovice_state_0 = 21
      end
    end
    if __renovice_state_0 == 21 then
      c110v9 = c110v6
      if c110v9 then
        __renovice_state_0 = 23
      else
        __renovice_state_0 = 22
      end
    end
    if __renovice_state_0 == 22 then
      c110v9 = c110v8
      __renovice_state_0 = 23
    end
    if __renovice_state_0 == 23 then
      c110v7 = c110v9
      c110v9 = PositionHasLOSToEntity
      do return c110v9(c110v7, c110v1, c110v2, c110v3, c110v4) end
    end
    do return end
  end
  HasLOS = v40
  v40 = function(c111v0, c111v1)
    local c111v2, c111v3, c111v4, c111v5, c111v6, c111v7
    c111v2 = IsNull
    c111v2 = c111v2(c111v1)
    if c111v2 then
      c111v1 = c111v0
    end
    c111v2 = c111v0:Name__2d897740()
    c111v3 = IsNull
    c111v3 = c111v3(c111v2)
    if c111v3 then
      do return end
    end
    c111v3 = c111v1:Name__2d897740()
    c111v4 = IsNull
    c111v4 = c111v4(c111v3)
    if c111v4 then
      c111v4 = c111v1:GetSpawnedByAvatar()
      c111v5 = IsNull
      c111v5 = c111v5(c111v4)
      if not c111v5 then
        c111v3 = c111v4:Name__2d897740()
        c111v5 = IsNull
        c111v5 = c111v5(c111v3)
        if c111v5 then
          c111v3 = c111v2
        end
      else
        c111v3 = c111v2
      end
    end
    if c111v3 ~= c111v2 then
      c111v4 = false
    else
      c111v4 = true
    end
    c111v5 = c111v0:GetInstance()
    c111v6 = _T.BlockGainEnergyFromOverguard
    if c111v6 == nil then
      c111v6 = _T
      c111v7 = {}
      c111v6.BlockGainEnergyFromOverguard = c111v7
    end
    c111v6 = _T.BlockGainEnergyFromOverguard
    c111v6[c111v5] = c111v4
    do return end
  end
  NotifyGaveOverguard = v40
  v40 = function(c112v0, c112v1)
    local c112v2, c112v3, c112v4, c112v5, c112v6, c112v7, c112v8, c112v9, c112v10, c112v11, c112v12, c112v13
    c112v2 = c112v0:DamageControl()
    c112v5 = false
    c112v3 = c112v2:GetResistances(c112v5)
    c112v4 = 0
    c112v5 = c112v2:GetOverguardAmount()
    c112v6 = 0
    if c112v6 < c112v5 then
      c112v7 = #c112v3
      c112v6 = c112v7 * 3
      c112v5 = c112v6 / 5
      c112v4 = c112v5 + 1
    else
      c112v5 = c112v2:Name__96409a03()
      c112v6 = 18
      if c112v6 < c112v5 then
        c112v7 = #c112v3
        c112v6 = c112v7 * 4
        c112v5 = c112v6 / 5
        c112v4 = c112v5 + 1
      else
        c112v5 = c112v2:GetShield()
        c112v6 = 0
        if c112v6 < c112v5 then
          c112v4 = 1
        else
          c112v5 = c112v2:GetArmourRating()
          c112v6 = 0
          if c112v6 < c112v5 then
            c112v6 = #c112v3
            c112v5 = c112v6 / 5
            c112v4 = c112v5 + 1
          else
            c112v7 = #c112v3
            c112v6 = c112v7 * 2
            c112v5 = c112v6 / 5
            c112v4 = c112v5 + 1
          end
        end
      end
    end
    c112v5 = 3.4028234663852886e+38
    c112v6 = {}
    c112v9 = 1
    c112v10 = 12
    c112v7 = c112v10 + 1
    c112v8 = 1
    for __renovice_for_0_0 = c112v9, c112v7, c112v8 do
      c112v12 = c112v4 + __renovice_for_0_0
      c112v11 = c112v12 - 1
      c112v10 = c112v3[c112v11]
      if c112v10 < c112v5 then
        c112v6 = {}
        c112v11 = table.insert
        c112v11(c112v6, __renovice_for_0_0)
        c112v5 = c112v10
        continue
      end
      if c112v10 ~= c112v5 then
        continue
      end
      c112v11 = table.insert
      c112v11(c112v6, __renovice_for_0_0)
    end
    c112v8 = #c112v6
    c112v7 = c112v6[c112v8]
    if c112v1 == nil then
      c112v8 = c112v7 - 1
      do return c112v8 end
    end
    c112v8 = -1
    c112v11 = #c112v6
    c112v9 = 1
    c112v10 = -1
    for __renovice_for_1_0 = c112v11, c112v9, c112v10 do
      c112v12 = c112v6[__renovice_for_1_0]
      c112v13 = c112v1[c112v12]
      if c112v13 == nil then
        continue
      end
      c112v13 = c112v1[c112v12]
      if not (c112v8 < c112v13) then
        continue
      end
      c112v8 = c112v1[c112v12]
      c112v7 = c112v12
    end
    c112v9 = c112v7 - 1
    do return c112v9 end
  end
  GetElementalWeakness = v40
  v40 = function(c113v0)
    local c113v1, c113v2, c113v3, c113v4, c113v5
    c113v3 = 1
    c113v1 = c113v0:GetPart(c113v3)
    c113v2 = IsNull
    c113v2 = c113v2(c113v1)
    if c113v2 then
      c113v4 = 0
      c113v2 = 11
      c113v3 = 1
      for __renovice_for_0_0 = c113v4, c113v2, c113v3 do
        c113v1 = c113v0:GetPart(__renovice_for_0_0)
        c113v5 = IsNull
        c113v5 = c113v5(c113v1)
        if c113v5 then
          continue
        end
        do return c113v1 end
      end
    end
    do return c113v1 end
  end
  GetBestRagdollPart = v40
  v40 = function()
    local c114v0, c114v1, c114v2
    c114v1 = gGameRules
    c114v1 = c114v1:GetMissionType()
    c114v2 = 39
    if c114v1 ~= c114v2 then
      c114v0 = false
      do return c114v0 end
    end
    c114v0 = true
    do return c114v0 end
  end
  v41 = function(c115v0)
    local c115v1, c115v2, c115v3, c115v4
    c115v2 = gGameRules
    c115v2 = c115v2:GetMissionType()
    c115v3 = 39
    if c115v2 ~= c115v3 then
      c115v1 = false
    else
      c115v1 = true
    end
    if not c115v1 then
      c115v1 = false
      do return c115v1 end
    end
    c115v1 = IsNull
    c115v1 = c115v1(c115v0)
    if c115v1 then
      c115v1 = false
      do return c115v1 end
    end
    c115v3 = gMoverType
    c115v1 = c115v0:IsA(c115v3)
    if not c115v1 then
      c115v1 = false
      do return c115v1 end
    end
    c115v3 = Symbol
    c115v4 = "MainElevator"
    c115v1 = c115v0:HasTag(c115v3(c115v4))
    if not c115v1 then
      c115v3 = Symbol
      c115v4 = "AssaultElevator"
      c115v1 = c115v0:HasTag(c115v3(c115v4))
    end
    do return c115v1 end
  end
  IsValidMover = v41
  v41 = function(c116v0, c116v1)
    local c116v2, c116v3, c116v4, c116v5, c116v6, c116v7, c116v8, c116v9, c116v10, c116v11
    c116v3 = gGameRules
    c116v3 = c116v3:GetMissionType()
    c116v4 = 39
    if c116v3 ~= c116v4 then
      c116v2 = false
    else
      c116v2 = true
    end
    if not c116v2 then
      c116v2 = nil
      do return c116v2 end
    end
    c116v2 = Vector
    c116v2 = c116v2()
    c116v1 = c116v1 or 5
    c116v4 = gBaseAvatarType
    c116v5 = gPickUpType
    c116v6 = gRagdollType
    c116v7 = gHitProxyType
    c116v3 = {c116v4, c116v5, c116v6, c116v7}
    c116v4 = gRegion
    c116v8 = Vector
    c116v9 = 0
    c116v10 = -c116v1
    c116v11 = 0
    c116v8 = c116v8(c116v9, c116v10, c116v11)
    c116v7 = c116v0 + c116v8
    c116v9 = nil
    c116v4 = c116v4:RaycastIgnoreTypes(c116v0, c116v7, c116v3, c116v9, c116v2)
    c116v5 = IsValidMover
    c116v5 = c116v5(c116v4)
    if c116v5 then
      do return c116v4, c116v2 end
    end
    c116v5 = IsNull
    c116v5 = c116v5(c116v4)
    if not c116v5 then
      c116v7 = gMoverType
      c116v5 = c116v4:IsA(c116v7)
      if not c116v5 then
        c116v5 = GetParentMover
        c116v5 = c116v5(c116v4)
        c116v6 = IsNull
        c116v6 = c116v6(c116v5)
        if not c116v6 then
          c116v7 = c116v0.y
          c116v8 = c116v5:GetPosition()
          c116v8 = c116v8.y
          c116v6 = c116v7 - c116v8
          c116v7 = 0
          if (c116v7 <= c116v6 and c116v6 <= c116v1) then
            do return c116v5, c116v2 end
          end
        end
      end
    end
    c116v5 = nil
    do return c116v5 end
  end
  CheckForValidMover = v41
  v41 = function(c117v0, c117v1)
    local c117v2, c117v3, c117v4, c117v5, c117v6, c117v7, c117v8, c117v9, c117v10, c117v11, c117v12, c117v13, c117v14
    c117v2 = c117v0
    c117v1 = c117v1 or 2
    c117v3 = Vector
    c117v4 = 0
    c117v6 = 0
    c117v3 = c117v3(c117v4, c117v1, c117v6)
    c117v4 = CheckForValidMover
    c117v5 = c117v0 + c117v3
    c117v4 = c117v4(c117v5)
    c117v5 = IsNull
    c117v5 = c117v5(c117v4)
    if not c117v5 then
      c117v5 = Vector
      c117v5 = c117v5()
      c117v7 = gBaseAvatarType
      c117v8 = gPickUpType
      c117v9 = gRagdollType
      c117v10 = gHitProxyType
      c117v6 = {c117v7, c117v8, c117v9, c117v10}
      c117v7 = gRegion
      c117v9 = c117v2 + c117v3
      c117v11 = Vector
      c117v12 = 0
      c117v13 = 5
      c117v14 = 0
      c117v11 = c117v11(c117v12, c117v13, c117v14)
      c117v10 = c117v2 - c117v11
      c117v12 = nil
      c117v7 = c117v7:RaycastIgnoreTypes(c117v9, c117v10, c117v6, c117v12, c117v5)
      if c117v7 then
        c117v8 = c117v5.y
        c117v7 = c117v8 + 0.1
        c117v5.y = c117v7
        c117v2 = c117v5
      end
    end
    do return c117v2 end
  end
  AdjustPositionToMover = v41
  v41 = function(c118v0, c118v1, c118v2, c118v3, c118v4, c118v5)
    local c118v6, c118v7, c118v8, c118v9, c118v10, c118v11, c118v12, c118v13, c118v14, c118v15
    c118v7 = gGameRules
    c118v7 = c118v7:GetMissionType()
    c118v8 = 39
    if c118v7 ~= c118v8 then
      c118v6 = false
    else
      c118v6 = true
    end
    if not c118v6 then
      do return end
    end
    if not c118v5 then
      c118v5 = ZERO_VECTOR
    end
    c118v6 = CheckForValidMover
    c118v6, c118v7 = c118v6(c118v1, c118v3)
    c118v8 = IsNull
    c118v8 = c118v8(c118v6)
    if not c118v8 then
      if c118v2 then
        c118v8 = c118v6:GetInstance()
        c118v9 = _T.MoverInfo
        if not c118v9 then
          c118v9 = _T
          c118v10 = {}
          c118v9.MoverInfo = c118v10
        end
        c118v10 = _T.MoverInfo
        c118v9 = c118v10[c118v8]
        if not c118v9 then
          c118v9 = _T.MoverInfo
          c118v10 = {}
          c118v9[c118v8] = c118v10
        end
        c118v10 = _T.MoverInfo
        c118v9 = c118v10[c118v8]
        c118v9 = c118v9.entities
        if not c118v9 then
          c118v10 = _T.MoverInfo
          c118v9 = c118v10[c118v8]
          c118v10 = {}
          c118v9.entities = c118v10
        end
        c118v9 = type
        c118v9 = c118v9(c118v0)
        if c118v9 == "table" then
          c118v9 = ipairs
          c118v9, c118v10, c118v11 = c118v9(c118v0)
          for __renovice_for_0_0, __renovice_for_0_1 in c118v9, c118v10, c118v11 do
            c118v13 = IsNull
            c118v13 = c118v13(__renovice_for_0_1)
            if c118v13 then
              continue
            end
            c118v15 = _T.MoverInfo
            c118v14 = c118v15[c118v8]
            c118v14 = c118v14.entities
            c118v13 = table.insert
            c118v13(c118v14, __renovice_for_0_1)
          end
          do return c118v6 end
        end
        c118v9 = IsNull
        c118v9 = c118v9(c118v0)
        if not c118v9 then
          c118v11 = _T.MoverInfo
          c118v10 = c118v11[c118v8]
          c118v10 = c118v10.entities
          c118v9 = table.insert
          c118v9(c118v10, c118v0)
          do return c118v6 end
        end
      else
        c118v8 = type
        c118v8 = c118v8(c118v0)
        if c118v8 == "table" then
          c118v8 = pairs
          c118v8, c118v9, c118v10 = c118v8(c118v0)
          for __renovice_for_1_0, __renovice_for_1_1 in c118v8, c118v9, c118v10 do
            c118v12 = IsNull
            c118v12 = c118v12(__renovice_for_1_1)
            if c118v12 then
              continue
            end
            if c118v4 then
              c118v14 = c118v7 + c118v5
              __renovice_for_1_1:Teleport(c118v14, __renovice_for_1_1:GetSimRotation())
            end
            c118v15 = EMPTY_SYMBOL
            __renovice_for_1_1:Name__4cc50a85(c118v6, c118v15)
          end
          do return c118v6 end
        end
        c118v8 = IsNull
        c118v8 = c118v8(c118v0)
        if not c118v8 then
          if c118v4 then
            c118v10 = c118v7 + c118v5
            c118v0:Teleport(c118v10, c118v0:GetSimRotation())
          end
          c118v11 = EMPTY_SYMBOL
          c118v0:Name__4cc50a85(c118v6, c118v11)
        end
      end
      do return c118v6 end
    end
    do return end
  end
  AttachToMover = v41
  v41 = function(c119v0)
    local c119v1, c119v2, c119v3, c119v4, c119v5, c119v6, c119v7, c119v8, c119v9, c119v10, c119v11, c119v12, c119v13, c119v14
    c119v1 = IsNull
    c119v1 = c119v1(c119v0)
    if c119v1 then
      do return end
    end
    c119v1 = c119v0:GetInstance()
    c119v2 = _T.MoverInfo
    if not c119v2 then
      c119v2 = _T
      c119v3 = {}
      c119v2.MoverInfo = c119v3
    end
    c119v3 = _T.MoverInfo
    c119v2 = c119v3[c119v1]
    if c119v2 then
      c119v3 = _T.MoverInfo
      c119v2 = c119v3[c119v1]
      c119v2 = c119v2.hasLoop
      if c119v2 then
        do return end
      end
    end
    c119v3 = _T.MoverInfo
    c119v2 = c119v3[c119v1]
    if not c119v2 then
      c119v2 = _T.MoverInfo
      c119v3 = {}
      c119v2[c119v1] = c119v3
      c119v3 = _T.MoverInfo
      c119v2 = c119v3[c119v1]
      c119v3 = {}
      c119v2.entities = c119v3
      c119v3 = _T.MoverInfo
      c119v2 = c119v3[c119v1]
      c119v2.mover = c119v0
    end
    c119v3 = _T.MoverInfo
    c119v2 = c119v3[c119v1]
    c119v3 = true
    c119v2.hasLoop = c119v3
    c119v2 = c119v0:GetPosition()
    c119v4 = _T.MoverInfo
    c119v3 = c119v4[c119v1]
    c119v3 = c119v3.entities
    while true do
      c119v4 = IsNull
      c119v4 = c119v4(c119v0)
      if c119v4 then break end
      c119v4 = _T.MoverInfo
      if not c119v4 then break end
      c119v5 = _T.MoverInfo
      c119v4 = c119v5[c119v1]
      if not c119v4 then break end
      c119v5 = _T.MoverInfo
      c119v4 = c119v5[c119v1]
      c119v4 = c119v4.entities
      if not c119v4 then break end
      c119v4 = c119v0:GetIsMoving()
      if c119v4 then
        c119v5 = _T.MoverInfo
        c119v4 = c119v5[c119v1]
        c119v3 = c119v4.entities
        c119v6 = #c119v3
        c119v4 = 1
        c119v5 = -1
        for __renovice_for_0_0 = c119v6, c119v4, c119v5 do
          c119v8 = c119v3[__renovice_for_0_0]
          c119v7 = IsNull
          c119v7 = c119v7(c119v8)
          if not c119v7 then
            continue
          end
          c119v7 = table.remove
          c119v7(c119v3, __renovice_for_0_0)
        end
        c119v4 = c119v0:GetPosition()
        c119v6 = c119v4.y
        c119v7 = c119v2.y
        c119v5 = c119v6 - c119v7
        if c119v5 ~= 0 then
          c119v6 = ipairs
          c119v6, c119v7, c119v8 = c119v6(c119v3)
          for __renovice_for_1_0, __renovice_for_1_1 in c119v6, c119v7, c119v8 do
            c119v9 = IsNull
            c119v9 = c119v9(__renovice_for_1_1)
            if c119v9 then
              continue
            end
            c119v11 = __renovice_for_1_1:GetPosition()
            c119v12 = Vector
            c119v13 = 0
            c119v14 = 0
            c119v12 = c119v12(c119v13, c119v5, c119v14)
            c119v10 = c119v11 + c119v12
            __renovice_for_1_1:Teleport(c119v10, __renovice_for_1_1:GetRotation())
          end
        end
        c119v2 = c119v4
      end
      c119v4 = Sleep
      c119v5 = 0
      c119v4(c119v5)
    end
    c119v4 = _T.MoverInfo
    if c119v4 then
      c119v5 = _T.MoverInfo
      c119v4 = c119v5[c119v1]
      if c119v4 then
        c119v4 = _T.MoverInfo
        c119v5 = nil
        c119v4[c119v1] = c119v5
        c119v4 = next
        c119v5 = _T.MoverInfo
        c119v4 = c119v4(c119v5)
        if c119v4 == nil then
          c119v4 = _T
          c119v5 = nil
          c119v4.MoverInfo = c119v5
        end
      end
    end
    do return end
  end
  MoverLoop = v41
  v41 = function(c120v0)
    local c120v1, c120v2, c120v3, c120v4, c120v5, c120v6, c120v7, c120v8
    c120v1 = IsNull
    c120v1 = c120v1(c120v0)
    if c120v1 then
      c120v1 = nil
      do return c120v1 end
    end
    c120v1 = c120v0:GetAttachParent()
    c120v2 = IsNull
    c120v2 = c120v2(c120v1)
    if not c120v2 then
      c120v4 = gMoverType
      c120v2 = c120v1:IsA(c120v4)
      if c120v2 then
        do return c120v1 end
      end
    end
    c120v2 = _T.MoverInfo
    if c120v2 then
      c120v2 = pairs
      c120v3 = _T.MoverInfo
      c120v2, c120v3, c120v4 = c120v2(c120v3)
      for __renovice_for_0_0, __renovice_for_0_1 in c120v2, c120v3, c120v4 do
        c120v5 = ipairs
        c120v6 = __renovice_for_0_1.entities
        c120v5, c120v6, c120v7 = c120v5(c120v6)
        for __renovice_for_1_0, __renovice_for_1_1 in c120v5, c120v6, c120v7 do
          if __renovice_for_1_1 ~= c120v0 then
            continue
          end
          c120v8 = __renovice_for_0_1.mover
          do return c120v8 end
        end
      end
    end
    c120v2 = nil
    do return c120v2 end
  end
  GetParentMover = v41
  v41 = function(c121v0)
    local c121v1, c121v2, c121v3
    c121v3 = GetParentMover
    c121v2 = IsNull
    c121v2 = c121v2(c121v3(c121v0))
    c121v1 = not c121v2
    do return c121v1 end
  end
  IsAttachedToMover = v41
  v41 = function(c122v0)
    local c122v1, c122v2, c122v3
    c122v1 = IsNull
    c122v1 = c122v1(c122v0)
    if c122v1 then
      do return end
    end
    c122v1 = _T.LastPseudoExaltedUsedTimes
    if c122v1 == nil then
      c122v1 = _T
      c122v2 = {}
      c122v1.LastPseudoExaltedUsedTimes = c122v2
    end
    c122v1 = _T.LastPseudoExaltedUsedTimes
    c122v2 = c122v0:GetInstance()
    c122v3 = Time
    c122v3 = c122v3()
    c122v1[c122v2] = c122v3
    do return end
  end
  TrackPseudoExaltedLastUsed = v41
  v41 = function(c123v0)
    local c123v1, c123v2, c123v3
    c123v1 = IsNull
    c123v1 = c123v1(c123v0)
    if not c123v1 then
      c123v1 = _T.LastPseudoExaltedUsedTimes
      if c123v1 ~= nil then
        c123v2 = _T.LastPseudoExaltedUsedTimes
        c123v3 = c123v0:GetInstance()
        c123v1 = c123v2[c123v3]
        if c123v1 ~= nil then
          c123v2 = _T.LastPseudoExaltedUsedTimes
          c123v3 = c123v0:GetInstance()
          c123v1 = c123v2[c123v3]
          do return c123v1 end
        end
      end
    end
    c123v1 = -1
    do return c123v1 end
  end
  GetPseudoExaltedLastUsed = v41
  v41 = function(c124v0, c124v1)
    local c124v2, c124v3, c124v4, c124v5, c124v6, c124v7, c124v8, c124v9, c124v10, c124v11, c124v12
    c124v2 = IsNull
    c124v2 = c124v2(c124v0)
    if c124v2 then
      do return end
    end
    c124v2 = c124v0:GetActiveImpactBehavior()
    c124v3 = IsNull
    c124v3 = c124v3(c124v2)
    if c124v3 then
      do return end
    end
    c124v5 = false
    c124v6 = true
    c124v3 = c124v2:Name__2732526b(c124v5, c124v6)
    if c124v3 then
      c124v2:TrackComboHit()
      do return end
    end
    c124v3 = c124v0:GetAvatarOwner()
    c124v4 = c124v1 or 20
    c124v5 = IsNull
    c124v5 = c124v5(c124v3)
    if not c124v2 then
      c124v5 = c124v3:InventoryControl()
      c124v7 = 1
      c124v8 = 317
      c124v9 = c124v0:GetType()
      c124v5 = c124v5:GetUpgradeModifiedValue(c124v7, c124v8, c124v9, c124v0)
      c124v6 = math.floor
      c124v6 = c124v6(c124v5)
      c124v7 = c124v5 - c124v6
      c124v8 = Random
      c124v9 = 0
      c124v10 = 1
      c124v8 = c124v8(c124v9, c124v10)
      if c124v8 <= c124v7 then
        c124v6 = c124v6 + 1
      end
      c124v8 = c124v3:InventoryControl()
      c124v10 = 1
      c124v11 = 318
      c124v12 = c124v0:GetType()
      c124v8 = c124v8:GetUpgradeModifiedValue(c124v10, c124v11, c124v12, c124v0)
      c124v8 = c124v8 * c124v6
      c124v9 = c124v8 - 1
      c124v4 = c124v4 + c124v9
    end
    c124v5 = c124v2:GetComboHits()
    c124v8 = c124v5 + c124v4
    c124v2:SetComboHits(c124v8)
    do return end
  end
  TrackPseudoExaltedComboHit = v41
  v41 = function(c125v0, c125v1, c125v2)
    local c125v3, c125v4, c125v5, c125v6, c125v7
    c125v3 = IsNull
    c125v3 = c125v3(c125v1)
    if c125v3 then
      do return c125v0 end
    end
    c125v3 = c125v1:GetAvatarOwner()
    c125v4 = IsNull
    c125v4 = c125v4(c125v3)
    if c125v4 then
      do return c125v0 end
    end
    c125v4 = c125v1:GetSpecialSlotItem(c125v2)
    c125v4 = c125v4.mItemType
    c125v5 = c125v3:InventoryControl()
    c125v7 = 7
    c125v5 = c125v5:GetWeaponInSlot(c125v7)
    c125v6 = IsNull
    c125v6 = c125v6(c125v5)
    if not c125v6 then
      c125v6 = c125v5:GetType()
      if c125v6 == c125v4 then
        c125v6 = c125v5:Name__ec99d38d()
        c125v7 = IsNull
        c125v7 = c125v7(c125v6)
        if not c125v7 then
          c125v7 = c125v6:GetWeaponRange()
          c125v0 = c125v0 + c125v7
        end
      end
    end
    do return c125v0 end
  end
  ScaleValueWithWeaponRange = v41
  v41 = function(c126v0, c126v1)
    local c126v2, c126v3, c126v4, c126v5, c126v6, c126v7, c126v8, c126v9, c126v10
    c126v2 = IsNull
    c126v2 = c126v2(c126v0)
    if c126v2 then
      do return end
    end
    c126v2 = {}
    c126v3 = pairs
    c126v3, c126v4, c126v5 = c126v3(c126v1)
    for __renovice_for_0_0, __renovice_for_0_1 in c126v3, c126v4, c126v5 do
      repeat
        c126v8 = 1
        c126v6 = c126v0:adRECEIVE(c126v8, __renovice_for_0_1)
        c126v8 = IsNull
        c126v8 = c126v8(c126v6)
        if not c126v8 then
          c126v7 = c126v6:GetInstance()
          if c126v7 then break end
        end
        c126v7 = nil
      until true
      c126v8 = IsNull
      c126v8 = c126v8(c126v6)
      if not c126v8 then
        c126v9 = { instance = nil, type = nil, bone = nil, position = nil, rotation = nil, hand = nil }
        c126v9.instance = c126v7
        c126v10 = c126v6.mType
        c126v9.type = c126v10
        c126v10 = c126v6.mBoneName
        c126v9.bone = c126v10
        c126v10 = c126v6:GetLocalPosition()
        c126v9.position = c126v10
        c126v10 = c126v6:GetLocalRotation()
        c126v9.rotation = c126v10
        c126v9.hand = __renovice_for_0_1
        c126v8 = table.insert
        c126v8(c126v2, c126v9)
        continue
      end
      c126v9 = nil
      c126v8 = table.insert
      c126v8(c126v2, c126v9)
    end
    do return c126v2 end
  end
  GetExaltedAttachments = v41
  v41 = function(c127v0, c127v1, c127v2, c127v3, c127v4, c127v5, c127v6, c127v7, c127v8, c127v9)
    local c127v10, c127v11, c127v12, c127v13, c127v14, c127v15, c127v16, c127v17, c127v18, c127v19, c127v20, c127v21, c127v22, c127v23, c127v24, c127v25, c127v26, c127v27, c127v28, c127v29, c127v30, c127v31
    c127v10 = gRegion
    c127v10 = c127v10:IsMaster()
    if c127v10 then
      c127v10 = IsNull
      c127v10 = c127v10(c127v0)
      if not c127v10 then
        c127v10 = c127v0:GetAvatarOwner()
        c127v11 = IsNull
        c127v11 = c127v11(c127v10)
        if c127v11 then
          do return end
        end
        c127v11 = c127v6
        if not c127v11 then
          c127v11 = 0
        end
        c127v6 = c127v11
        c127v7 = c127v7 or 0
        c127v11 = c127v5
        if not c127v11 then
          c127v12 = gRegion
          c127v12 = c127v12:GetNpcMgr()
          c127v12 = c127v12:GetAiDirector()
          c127v12 = c127v12:GetMaxEnemyLevel()
          c127v11 = math.max
          c127v11 = c127v11(c127v12, c127v0:GetLevel())
        end
        c127v12 = gRegion
        c127v12 = c127v12:GetNpcMgr()
        c127v17 = EMPTY_SYMBOL
        c127v19 = true
        c127v12 = c127v12:CreateAgentAtPosition(c127v2, c127v3, c127v4, c127v17, c127v11, c127v19, c127v6, c127v7, c127v8)
        c127v13 = IsNull
        c127v13 = c127v13(c127v12)
        if c127v13 then
          do return end
        end
        c127v15 = false
        c127v12:Name__8b8f409e(c127v15)
        c127v12:SetCombatAwareness()
        c127v13 = c127v12:GetAvatar()
        c127v14 = IsNull
        c127v14 = c127v14(c127v13)
        if c127v14 then
          do return end
        end
        c127v13:SetFaction(c127v10:GetOriginalFaction())
        c127v13:Name__38c006f7(c127v10)
        c127v13:SetSpawnedByAvatar(c127v10)
        c127v13:StopSCALEnil(c127v1)
        c127v16 = nil
        c127v13:SetDropTable(c127v16)
        c127v14 = c127v13:GetPosition()
        c127v15 = gRegion
        c127v15 = c127v15:GetNpcMgr()
        c127v18 = 10
        c127v19 = -2
        c127v20 = 487
        c127v15:Name__6258004f(c127v14, c127v18, c127v19, c127v20)
        c127v13:Teleport(c127v14)
        c127v15 = IsNull
        c127v15 = c127v15(c127v9)
        if c127v15 then
          c127v9 = true
        end
        if c127v9 then
          c127v15 = c127v10:InventoryControl()
          c127v16 = c127v13:InventoryControl()
          c127v19 = 0
          c127v17 = 15
          c127v18 = 1
          for __renovice_for_0_0 = c127v19, c127v17, c127v18 do
            c127v22 = 0
            c127v23 = 114
            c127v24 = nil
            c127v25 = nil
            c127v26 = 25
            c127v27 = EMPTY_SYMBOL
            c127v28 = false
            c127v20 = c127v15:GetUpgradeModifiedValue(c127v22, c127v23, c127v24, c127v25, c127v26, c127v27, c127v28, __renovice_for_0_0)
            c127v21 = 0
            if c127v21 < c127v20 then
              c127v23 = 114
              c127v24 = 0
              c127v26 = nil
              c127v27 = nil
              c127v28 = 25
              c127v29 = EMPTY_SYMBOL
              c127v30 = false
              c127v16:AddUpgrade(c127v23, c127v24, c127v20, c127v26, c127v27, c127v28, c127v29, c127v30, __renovice_for_0_0)
            end
            c127v23 = 0
            c127v24 = 367
            c127v25 = nil
            c127v26 = nil
            c127v27 = 25
            c127v28 = EMPTY_SYMBOL
            c127v29 = false
            c127v21 = c127v15:GetUpgradeModifiedValue(c127v23, c127v24, c127v25, c127v26, c127v27, c127v28, c127v29, __renovice_for_0_0)
            c127v22 = 0
            if not (c127v22 < c127v21) then
              continue
            end
            c127v24 = 367
            c127v25 = 0
            c127v27 = nil
            c127v28 = nil
            c127v29 = 25
            c127v30 = EMPTY_SYMBOL
            c127v31 = false
            c127v16:AddUpgrade(c127v24, c127v25, c127v21, c127v27, c127v28, c127v29, c127v30, c127v31, __renovice_for_0_0)
          end
        end
        do return c127v12 end
      end
    end
    do return end
  end
  CreateAbilitySummonAgent = v41
  v41 = function(c128v0)
    local c128v1, c128v2, c128v3, c128v4, c128v5, c128v6, c128v7
    c128v3 = gLotusSentinelAvatarType
    c128v1 = c128v0:IsA(c128v3)
    if c128v1 then
      c128v1 = c128v0:GetCreatorAvatar()
      c128v2 = IsNull
      c128v2 = c128v2(c128v1)
      if not c128v2 then
        c128v2 = c128v1:Name__2d897740()
        c128v3 = 4
        c128v4 = WeakResource
        c128v5 = "/Lotus/Powersuits/Khora/Kavat/KhoraKavatAvatar"
        c128v7 = c128v4(c128v5)
        c128v5 = c128v0:IsA(c128v7)
        if c128v5 then
          c128v3 = c128v3 * 2
        end
        c128v5 = IsNull
        c128v5 = c128v5(c128v2)
        if not c128v5 then
          c128v6 = c128v2:GetPlayerID()
          c128v5 = c128v6 + c128v3
          do return c128v5 end
        end
      end
    end
    c128v1 = c128v0:Name__2d897740()
    c128v2 = IsNull
    c128v2 = c128v2(c128v1)
    if c128v2 then
      c128v2 = c128v0:GetScriptBlackboard()
      c128v1 = c128v2.OwningPlayer
    end
    c128v2 = IsNull
    c128v2 = c128v2(c128v1)
    if not c128v2 then
      do return c128v1:GetPlayerID() end
    end
    c128v2 = 255
    do return c128v2 end
  end
  GetHudBuffNotificationID = v41
  v41 = function(c129v0)
    local c129v1, c129v2, c129v3, c129v4
    c129v1 = _T.TeleportAndFadeEntities
    if not c129v1 then
      c129v1 = false
      do return c129v1 end
    end
    c129v1 = ipairs
    c129v2 = _T.TeleportAndFadeEntities
    c129v1, c129v2, c129v3 = c129v1(c129v2)
    for __renovice_for_0_0, __renovice_for_0_1 in c129v1, c129v2, c129v3 do
      if c129v0 ~= __renovice_for_0_1 then
        continue
      end
      c129v4 = true
      do return c129v4 end
    end
    c129v1 = false
    do return c129v1 end
  end
  IsInTeleportVolume = v41
  v41 = function(c130v0, c130v1)
    local c130v2, c130v3, c130v4, c130v5, c130v6
    if c130v0 then
      c130v2 = IsNull
      c130v2 = c130v2(c130v0)
      if not c130v2 then
        c130v4 = Symbol
        c130v5 = "GAME_C1_SPINE1"
        c130v2 = c130v0:GetBonePosition(c130v4(c130v5))
        c130v3 = gRegion
        c130v3 = c130v3:GetNpcMgr()
        if not c130v3 then
          do return c130v2 end
        end
        c130v4 = c130v3:GetAiDirector()
        if not c130v4 then
          do return c130v2 end
        end
        c130v5 = c130v4:Name__2d759819(c130v0)
        c130v6 = c130v5 * c130v1
        c130v2 = c130v2 + c130v6
        do return c130v2 end
      end
    end
    c130v2 = Vector
    c130v3 = 0
    c130v4 = 0
    c130v5 = 0
    do return c130v2(c130v3, c130v4, c130v5) end
  end
  LeadTarget = v41
  v41 = function(c131v0, c131v1, c131v2)
    local c131v3, c131v4, c131v5, c131v6
    c131v3 = IsNull
    c131v3 = c131v3(c131v0)
    if c131v3 then
      c131v3 = 0
      do return c131v3 end
    end
    c131v3 = c131v0:Name__b1572999(c131v1)
    c131v6 = c131v3
    c131v4 = c131v0:GetAbilityAugmentLevel(c131v6)
    c131v5 = c131v0:GetAbilityAugmentType(c131v3)
    if c131v5 == c131v2 then
      do return c131v4 end
    end
    c131v6 = 0
    do return c131v6 end
  end
  GetAugmentLevel = v41
  v41 = function(c132v0, c132v1)
    local c132v2, c132v3, c132v4, c132v5, c132v6
    c132v2 = IsNull
    c132v2 = c132v2(c132v0)
    if c132v2 then
      do return end
    end
    if c132v1 == nil then
      c132v1 = true
    end
    c132v2 = c132v0:Name__2d897740()
    c132v3 = IsNull
    c132v3 = c132v3(c132v2)
    if (not c132v3 and c132v1) then
      c132v5 = 0
      c132v3 = c132v2:GetPlayerAvatar(c132v5)
      c132v4 = IsNull
      c132v4 = c132v4(c132v3)
      if not c132v4 then
        c132v0 = c132v3
      end
    end
    c132v3 = c132v0:InventoryControl()
    c132v3 = c132v3:GetActivePowerSuit()
    c132v4 = IsNull
    c132v4 = c132v4(c132v3)
    if c132v4 then
      do return end
    end
    c132v6 = 5
    c132v3:DeactivateAbilities(c132v6)
    c132v6 = 4
    c132v3:DeactivateAbilities(c132v6)
    do return end
  end
  DeactivateStateChangingAbilities = v41
  v41 = function(c133v0)
    local c133v1, c133v2, c133v3, c133v4, c133v5, c133v6, c133v7, c133v8, c133v9, c133v10, c133v11, c133v12, c133v13, c133v14, c133v15
    c133v1 = IsNull
    c133v1 = c133v1(c133v0)
    if not c133v1 then
      c133v3 = gEntityType
      c133v1 = c133v0:IsA(c133v3)
      if c133v1 then
        c133v1 = c133v0:GetMesh()
        c133v2 = c133v0:GetMeshScale()
        c133v3 = IsNull
        c133v3 = c133v3(c133v1)
        if not c133v3 then
          c133v3 = c133v1:GetBoundsMax()
          c133v3 = c133v3.y
          c133v4 = c133v1:GetBoundsMin()
          c133v4 = c133v4.y
          c133v5 = c133v1:GetBoundsMax()
          c133v5 = c133v5.x
          c133v6 = c133v1:GetBoundsMin()
          c133v6 = c133v6.x
          c133v7 = c133v1:GetBoundsMax()
          c133v7 = c133v7.z
          c133v8 = c133v1:GetBoundsMin()
          c133v8 = c133v8.z
          c133v9 = c133v3 - c133v4
          c133v10 = c133v5 - c133v6
          c133v11 = c133v7 - c133v8
          c133v15 = c133v9 + c133v10
          c133v14 = c133v15 + c133v11
          c133v13 = c133v14 / 3
          c133v12 = c133v13 * c133v2
          do return c133v12 end
        end
      end
    end
    c133v1 = 0
    do return c133v1 end
  end
  GetCapsuleRadius = v41
  v41 = function(c134v0, c134v1, c134v2, c134v3, c134v4, c134v5, c134v6)
    local c134v7, c134v8, c134v9, c134v10, c134v11, c134v12, c134v13, c134v14, c134v15, c134v16, c134v17, c134v18, c134v19, c134v20, c134v21, c134v22, c134v23, c134v24, c134v25, c134v26, c134v27, c134v28, c134v29, c134v30
    if (not c134v2 or c134v2 == 0) then
      c134v2 = 1
    end
    c134v7 = true
    c134v8 = c134v1
    c134v9 = Vector
    c134v9 = c134v9()
    c134v10 = Rotation
    c134v10 = c134v10()
    c134v11 = nil
    c134v12 = Vector
    c134v13 = 0
    c134v14 = 1
    c134v15 = 0
    c134v12 = c134v12(c134v13, c134v14, c134v15)
    c134v13 = CrossProduct
    c134v13 = c134v13(c134v3, c134v12)
    c134v14 = { front = nil, back = nil, left = nil, right = nil }
    c134v14.front = c134v3
    c134v15 = c134v3 * -1
    c134v14.back = c134v15
    c134v14.left = c134v13
    c134v15 = c134v13 * -1
    c134v14.right = c134v15
    c134v16 = Vector
    c134v17 = 0
    c134v18 = 0.5
    c134v19 = 0
    c134v16 = c134v16(c134v17, c134v18, c134v19)
    c134v15 = c134v8 + c134v16
    c134v16 = pairs
    c134v16, c134v17, c134v18 = c134v16(c134v14)
    for __renovice_for_0_0, __renovice_for_0_1 in c134v16, c134v17, c134v18 do
      c134v22 = gLotusSentinelAvatarType
      c134v23 = gPickUpType
      c134v24 = gLotusHitProxyShieldType
      c134v21 = {c134v22, c134v23, c134v24}
      c134v22 = gRegion
      c134v26 = __renovice_for_0_1 * c134v2
      c134v25 = c134v15 + c134v26
      c134v28 = nil
      c134v11 = c134v22:Name__f9073259(c134v15, c134v25, c134v0, c134v21, c134v28, c134v9, c134v10)
      if c134v6 then
        c134v22 = gRegion
        c134v26 = __renovice_for_0_1 * c134v2
        c134v25 = c134v15 + c134v26
        c134v26 = Color
        c134v27 = 0
        c134v28 = 255
        c134v29 = 0
        c134v26 = c134v26(c134v27, c134v28, c134v29)
        c134v27 = 3
        c134v22:Name__aae5e771(c134v15, c134v25, c134v26, c134v27)
      end
      c134v22 = IsNull
      c134v22 = c134v22(c134v11)
      if c134v22 then
        continue
      end
      if c134v6 then
        c134v22 = gRegion
        c134v25 = 0.1
        c134v26 = Color
        c134v27 = 255
        c134v28 = 0
        c134v29 = 0
        c134v26 = c134v26(c134v27, c134v28, c134v29)
        c134v27 = 3
        c134v22:Name__881d74db(c134v9, c134v25, c134v26, c134v27)
      end
      c134v24 = gHitProxyPhysicsType
      c134v22 = c134v11:IsA(c134v24)
      if c134v22 then
        c134v11 = c134v11:GetAvatarOwner()
      end
      repeat
        c134v22 = IsNull
        c134v22 = c134v22(c134v11)
        if not c134v22 then
          c134v24 = gBaseAvatarType
          c134v22 = c134v11:IsA(c134v24)
          if c134v22 then
            c134v8 = c134v11:GetPosition()
            break
          end
        end
        c134v23 = AngleToDirection
        c134v23 = c134v23(c134v10)
        c134v22 = c134v23 * c134v2
        c134v8 = c134v9 + c134v22
      until true
      if not c134v6 then
        continue
      end
      c134v22 = gRegion
      c134v25 = 0.1
      c134v26 = Color
      c134v27 = 255
      c134v28 = 255
      c134v29 = 0
      c134v26 = c134v26(c134v27, c134v28, c134v29)
      c134v27 = 3
      c134v22:Name__881d74db(c134v8, c134v25, c134v26, c134v27)
    end
    c134v17 = gBaseAvatarType
    c134v18 = gHitProxyPhysicsType
    c134v19 = gRagdollType
    c134v20 = gPickUpType
    c134v16 = {c134v17, c134v18, c134v19, c134v20}
    c134v15 = c134v8
    c134v17 = c134v2 * 0.8
    c134v18 = gRegion
    c134v22 = c134v14.left
    c134v21 = c134v22 * c134v17
    c134v20 = c134v15 + c134v21
    c134v23 = c134v14.right
    c134v22 = c134v23 * c134v17
    c134v21 = c134v15 + c134v22
    c134v24 = nil
    c134v27 = true
    c134v28 = true
    c134v18 = c134v18:Name__f9073259(c134v20, c134v21, c134v0, c134v16, c134v24, c134v9, c134v10, c134v27, c134v28)
    c134v19 = gRegion
    c134v23 = c134v14.back
    c134v22 = c134v23 * c134v17
    c134v21 = c134v15 + c134v22
    c134v24 = c134v14.front
    c134v23 = c134v24 * c134v17
    c134v22 = c134v15 + c134v23
    c134v25 = nil
    c134v28 = true
    c134v29 = true
    c134v19 = c134v19:Name__f9073259(c134v21, c134v22, c134v0, c134v16, c134v25, c134v9, c134v10, c134v28, c134v29)
    if c134v6 then
      c134v20 = gRegion
      c134v24 = c134v14.left
      c134v23 = c134v24 * c134v17
      c134v22 = c134v15 + c134v23
      c134v25 = c134v14.right
      c134v24 = c134v25 * c134v17
      c134v23 = c134v15 + c134v24
      c134v24 = Color
      c134v25 = 0
      c134v26 = 0
      c134v27 = 255
      c134v24 = c134v24(c134v25, c134v26, c134v27)
      c134v25 = 3
      c134v20:Name__aae5e771(c134v22, c134v23, c134v24, c134v25)
      c134v20 = gRegion
      c134v24 = c134v14.back
      c134v23 = c134v24 * c134v17
      c134v22 = c134v15 + c134v23
      c134v25 = c134v14.front
      c134v24 = c134v25 * c134v17
      c134v23 = c134v15 + c134v24
      c134v24 = Color
      c134v25 = 0
      c134v26 = 0
      c134v27 = 255
      c134v24 = c134v24(c134v25, c134v26, c134v27)
      c134v25 = 3
      c134v20:Name__aae5e771(c134v22, c134v23, c134v24, c134v25)
    end
    repeat
      c134v20 = IsNull
      c134v20 = c134v20(c134v18)
      if c134v20 then
        c134v20 = IsNull
        c134v20 = c134v20(c134v19)
        if c134v20 then break end
      end
      c134v7 = false
      if c134v5 then
        c134v20 = gRegion
        c134v20 = c134v20:GetNpcMgr()
        c134v20 = c134v20:GetAiDirector()
        c134v23 = 5
        c134v24 = 1
        c134v8 = c134v20:GetClosestWorldPointOnNavMeshScript(c134v8, c134v23, c134v24)
      end
    until true
    c134v20 = gRegion
    c134v24 = c134v12 * c134v2
    c134v23 = c134v8 + c134v24
    c134v26 = nil
    c134v29 = false
    c134v30 = false
    c134v11 = c134v20:Name__f9073259(c134v8, c134v23, c134v0, c134v16, c134v26, c134v9, c134v10, c134v29, c134v30)
    if c134v6 then
      c134v20 = gRegion
      c134v24 = c134v12 * c134v2
      c134v23 = c134v8 + c134v24
      c134v24 = Color
      c134v25 = 0
      c134v26 = 255
      c134v27 = 0
      c134v24 = c134v24(c134v25, c134v26, c134v27)
      c134v25 = 3
      c134v20:Name__aae5e771(c134v8, c134v23, c134v24, c134v25)
    end
    c134v20 = IsNull
    c134v20 = c134v20(c134v11)
    if not c134v20 then
      c134v7 = false
      if c134v6 then
        c134v20 = gRegion
        c134v23 = 0.1
        c134v24 = Color
        c134v25 = 255
        c134v26 = 255
        c134v27 = 0
        c134v24 = c134v24(c134v25, c134v26, c134v27)
        c134v25 = 3
        c134v20:Name__881d74db(c134v9, c134v23, c134v24, c134v25)
      end
      if c134v5 then
        c134v20 = gRegion
        c134v20 = c134v20:GetNpcMgr()
        c134v20 = c134v20:GetAiDirector()
        c134v23 = 5
        c134v24 = 1
        c134v8 = c134v20:GetClosestWorldPointOnNavMeshScript(c134v8, c134v23, c134v24)
      end
    end
    if c134v4 then
      c134v20 = gRegion
      c134v23 = Vector
      c134v24 = 0
      c134v25 = 0.1
      c134v26 = 0
      c134v23 = c134v23(c134v24, c134v25, c134v26)
      c134v22 = c134v8 + c134v23
      c134v24 = Vector
      c134v25 = 0
      c134v26 = 40
      c134v27 = 0
      c134v24 = c134v24(c134v25, c134v26, c134v27)
      c134v23 = c134v8 - c134v24
      c134v26 = nil
      c134v29 = false
      c134v30 = false
      c134v11 = c134v20:Name__f9073259(c134v22, c134v23, c134v0, c134v16, c134v26, c134v9, c134v10, c134v29, c134v30)
      c134v20 = IsNull
      c134v20 = c134v20(c134v11)
      if not c134v20 then
        c134v8 = c134v9
      end
    end
    do return c134v8, c134v7 end
  end
  GetBestSpawnPos = v41
  do return end
