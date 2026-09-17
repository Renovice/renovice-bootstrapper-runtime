  local v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, v60, v61, v62, v63, v64, v65, v66, v67, v68, v69, v70, v71, v72, v73, v74, v75, v76, v77, v78, v79, v80, v81, v82, v83, v84, v85, v86, v87, v88, v89, v90, v91, v92, v93, v94, v95, v96, v97, v98, v99, v100, v101, v102, v103, v104, v105, v106, v107, v108, v109, v110, v111, v112, v113, v114, v115, v116, v117, v118, v119, v120, v121, v122, v123, v124, v125, v126, v127, v128, v129, v130, v131, v132, v133, v134, v135, v136, v137, v138, v139
  v0 = require
  v1 = "Lotus.Interface.UIUtilities"
  v0 = v0(v1)
  v1 = require
  v2 = "EE.Interface.Utilities"
  v1 = v1(v2)
  v2 = require
  v3 = "Lotus.Interface.CrossPlatformUtilities"
  v2 = v2(v3)
  v3 = require
  v4 = "Lotus.Interface.LotusUtilities"
  v3 = v3(v4)
  v4 = require
  v5 = "Lotus.Scripts.Libs.IntrinsicsSkillSymbolsLib"
  v4 = v4(v5)
  v5 = require
  v6 = "EE.Interface.AnchorMgr"
  v5 = v5(v6)
  v6 = require
  v7 = "Lotus.Powersuits.Operator.OperatorLib"
  v6 = v6(v7)
  v7 = require
  v8 = "Lotus.Scripts.Libs.ObjectiveText"
  v7 = v7(v8)
  v8 = require
  v9 = "Lotus.Scripts.Libs.ChoirUtilsLib"
  v8 = v8(v9)
  v9 = Type
  v10 = "/Lotus/Types/Game/HealthShieldDisplay"
  v9 = v9(v10)
  v10 = WeakResource
  v11 = "/Lotus/Types/Game/Hints/HealthBarAnchor"
  v10 = v10(v11)
  v11 = WeakResource
  v12 = "/Lotus/Types/Restoratives/Consumable/Scanner"
  v11 = v11(v12)
  v12 = WeakResource
  v13 = "/Lotus/Types/Restoratives/Consumable/LibraryScanner"
  v12 = v12(v13)
  v13 = WeakResource
  v14 = "/Lotus/Powersuits/Khora/Kavat/KhoraKavatAvatar"
  v13 = v13(v14)
  v14 = WeakResource
  v15 = "/Lotus/Types/Game/MarkerInfos/AreaExtractionMarker"
  v14 = v14(v15)
  v15 = WeakResource
  v16 = "/Lotus/Types/Game/QuadRobotDamageController"
  v15 = v15(v16)
  v16 = WeakResource
  v17 = "/Lotus/Types/Gameplay/Nightwave/CephalonMaze/GlassmakerDamageController"
  v16 = v16(v17)
  v17 = WeakResource
  v18 = "/Lotus/Types/Enemies/Tau/Monolyst/MonolystAvatar"
  v17 = v17(v18)
  v18 = WeakResource
  v19 = "/Lotus/Types/Enemies/Duviri/Dragon/Ground/GroundDragonBossAvatar"
  v18 = v18(v19)
  v19 = WeakResource
  v20 = "/Lotus/Types/Enemies/Infested/InfestedMicroplanet/Oni/InfestedOniAvatar"
  v19 = v19(v20)
  v20 = WeakResource
  v21 = "/Lotus/Types/Game/MarkerInfos/SpaceEnemyCrewShipMarkerInfo"
  v20 = v20(v21)
  v21 = WeakResource
  v22 = "/Lotus/Types/Game/MarkerInfos/SpaceTurretMarkerInfo"
  v21 = v21(v22)
  v23 = "UIMaterial_SpaceMarker"
  v24 = "UIMaterial_SpaceMarkerCrewShip"
  v25 = "UIMaterial_SpaceMarkerCircle"
  v22 = {v23, v24, v25}
  v23 = WeakResource
  v24 = "/Lotus/Types/Friendly/Pets/ZanukaPets/ZanukaPetAvatarBase"
  v23 = v23(v24)
  v24 = WeakResource
  v25 = "/Lotus/Types/Enemies/Orokin/Entrati/EntratiTech/EntratiTechAvatar"
  v24 = v24(v25)
  v25 = WeakResource
  v26 = "/Lotus/Types/Enemies/Orokin/Entrati/EntratiTech/NechroTech/NechroTechDamageController"
  v25 = v25(v26)
  v26 = WeakResource
  v27 = "/Lotus/Types/Game/MarkerInfos/PreDeathMarkerInfo"
  v26 = v26(v27)
  v27 = WeakResource
  v28 = "/Lotus/Types/Friendly/PlayerControllable/ControllableDuviriDrifterTennoAvatar"
  v27 = v27(v28)
  v28 = Symbol
  v29 = "SecondChance"
  v28 = v28(v29)
  v29 = false
  v30 = 30
  v31 = function(...)
    local c1v0, c1v1, c1v2, c1v3, c1v4
    c1v0 = {}
    c1v1 = ipairs
    c1v2 = {...}
    c1v1, c1v2, c1v3 = c1v1(c1v2)
    for __renovice_for_0_0, __renovice_for_0_1 in c1v1, c1v2, c1v3 do
      c1v4 = { Raw = nil }
      c1v4.Raw = __renovice_for_0_1
      c1v0[__renovice_for_0_0] = c1v4
    end
    do return c1v0 end
  end
  v33 = "DT_IMPACT"
  v34 = "DT_PUNCTURE"
  v35 = "DT_SLASH"
  v36 = "DT_FIRE"
  v37 = "DT_FREEZE"
  v38 = "DT_ELECTRICITY"
  v39 = "DT_POISON"
  v40 = "DT_EXPLOSION"
  v41 = "DT_RADIATION"
  v42 = "DT_GAS"
  v43 = "DT_MAGNETIC"
  v44 = "DT_VIRAL"
  v45 = "DT_CORROSIVE"
  v46 = "DT_RADIANT"
  v47 = "DT_SENTIENT"
  v32 = v31(v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47)
  v33 = nil
  v34 = false
  v35 = false
  v36 = false
  v37 = false
  v38 = nil
  v39 = nil
  v40 = nil
  v41 = nil
  v42 = nil
  v43 = nil
  v44 = nil
  v45 = nil
  v46 = {}
  v47 = false
  v48 = 0
  v49 = 0
  v50 = -1
  v51 = -1
  v52 = 1280
  v53 = 720
  v54 = 1
  v56 = 0
  v57 = 0
  v55 = {v56, v57}
  v56 = 1
  v57 = 1
  v58 = 0
  v59 = 0
  v60 = {}
  v61 = {}
  v62 = {}
  v63 = {}
  v64 = true
  v65 = {}
  v66 = {}
  v67 = {}
  v68 = 1
  v69 = false
  v70 = true
  v71 = true
  v72 = nil
  v73 = {}
  v74 = {}
  v75 = {}
  v76 = nil
  v77 = nil
  v78 = { segmentBaseId = 900, showBossStatus = false, showEnergy = false, bossStatusStack = nil }
  v79 = {}
  v78.bossStatusStack = v79
  v79 = { segmentBaseId = 12100, showBossStatus = false, showEnergy = false, bossStatusStack = nil }
  v80 = {}
  v79.bossStatusStack = v80
  v80 = {}
  v81 = {}
  v82 = {}
  v83 = {}
  v84 = false
  v85 = false
  v86 = false
  v87 = 0
  v88 = false
  v89 = nil
  v90 = nil
  v91 = 0.3
  v92 = true
  v93 = 0
  v94 = 0
  v95 = nil
  v96 = nil
  v97 = nil
  v98 = WeakResource
  v99 = "/Lotus/Types/Keys/NewPlayerQuest/NewPlayerQuestKeyChain"
  v98 = v98(v99)
  v99 = WeakResource
  v100 = "/Lotus/Types/Keys/VorsPrize/VorsPrizeQuestKeyChain"
  v99 = v99(v100)
  v100 = WeakResource
  v101 = "/Lotus/Types/Keys/GlassQuest/GlassQuestKeyChain"
  v100 = v100(v101)
  v101 = WeakResource
  v102 = "/Lotus/Types/Keys/ModQuest/ModQuestKeyChain"
  v101 = v101(v102)
  v102 = function(c2v0, c2v1, c2v2)
    local c2v3, c2v4, c2v5, c2v6, c2v7, c2v8, c2v9
    c2v4 = c2v1 - c2v0
    c2v3 = c2v4 * c2v2
    c2v7 = c2v3.x
    c2v8 = c2v3.x
    c2v6 = c2v7 * c2v8
    c2v8 = c2v3.y
    c2v9 = c2v3.y
    c2v7 = c2v8 * c2v9
    c2v5 = c2v6 + c2v7
    c2v7 = c2v3.z
    c2v8 = c2v3.z
    c2v6 = c2v7 * c2v8
    c2v4 = c2v5 + c2v6
    do return c2v4 end
  end
  v103 = function(c3v0)
    local c3v1, c3v2, c3v3, c3v4, c3v5
    c3v1 = IsNull
    c3v1 = c3v1(c3v0)
    if not c3v1 then
      c3v1 = v2
      c3v1 = c3v1.GetCrossPlatformUniquePlayerName
      c3v2 = c3v0:GetPlayerName()
      c3v3 = v60
      c3v4 = nil
      c3v5 = true
      do return c3v1(c3v2, c3v3, c3v4, c3v5) end
    end
    c3v1 = ""
    do return c3v1 end
  end
  v104 = function(c4v0)
    local c4v1, c4v2, c4v3, c4v4
    local __renovice_state_0 = 0
    c4v1 = mMovie
    c4v3 = "_initialY"
    c4v1 = c4v1:GetVariable(c4v0, c4v3)
    c4v2 = IsNull
    c4v2 = c4v2(c4v1)
    if c4v2 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c4v2 = tostring
      c4v2 = c4v2(c4v1)
      if c4v2 ~= "undefined" then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c4v2 = mMovie
      c4v4 = 1
      c4v1 = c4v2:GetNumberVariable(c4v0, c4v4)
      c4v2 = mMovie
      c4v4 = "_initialY"
      c4v2:SetVariable(c4v0, c4v4, c4v1)
      __renovice_state_0 = 3
    end
    if __renovice_state_0 == 3 then
      c4v2 = tonumber
      c4v2 = c4v2(c4v1)
      do return c4v2 end
    end
    do return end
  end
  v105 = function()
    local c5v0, c5v1, c5v2, c5v3
    c5v0 = v0
    c5v0 = c5v0.HandleHudScale
    c5v1 = mMovie
    c5v2 = v54
    c5v3 = v33
    c5v0 = c5v0(c5v1, c5v2, c5v3)
    v55 = c5v0
    do return end
  end
  v106 = function(c6v0)
    v95 = c6v0
    do return end
  end
  v107 = function()
    local c7v0, c7v1, c7v2, c7v3, c7v4, c7v5, c7v6
    c7v1 = mMovie
    c7v0 = IsNull
    c7v0 = c7v0(c7v1)
    if c7v0 then
      do return end
    end
    c7v0 = nil
    v95 = c7v0
    c7v0 = v33
    c7v2 = mMovie
    c7v3 = "HintMessage"
    c7v0:Unregister(c7v2, c7v3)
    c7v0 = mMovie
    c7v2 = "HintMessage"
    c7v3 = 0
    c7v4 = v93
    c7v0:SetNumberVariable(c7v2, c7v3, c7v4)
    c7v0 = mMovie
    c7v2 = "HintMessage"
    c7v3 = 1
    c7v4 = v94
    c7v0:SetNumberVariable(c7v2, c7v3, c7v4)
    c7v0 = v33
    c7v2 = mMovie
    c7v3 = "HintMessage"
    c7v5 = v33
    c7v5 = c7v5.ANCHOR_V_CENTRE
    c7v6 = v33
    c7v6 = c7v6.ANCHOR_H_CENTRE
    c7v4 = {c7v5, c7v6}
    c7v0:Register(c7v2, c7v3, c7v4)
    do return end
  end
  v108 = function(c8v0, c8v1, c8v2, c8v3, c8v4, c8v5)
    local c8v6, c8v7
    c8v7 = mMovie
    c8v6 = IsNull
    c8v6 = c8v6(c8v7)
    if c8v6 then
      do return end
    end
    c8v6 = { text = nil, replace = nil, xAnchor = nil, xOffsetRatio = nil, yAnchor = nil, yOffsetRatio = nil }
    c8v6.text = c8v0
    c8v6.replace = c8v1
    c8v6.xAnchor = c8v2
    c8v6.xOffsetRatio = c8v3
    c8v6.yAnchor = c8v4
    c8v6.yOffsetRatio = c8v5
    v96 = c8v6
    do return end
  end
  v109 = function(c10v0)
    local c10v1, c10v2, c10v3, c10v4, c10v5, c10v6, c10v7, c10v8, c10v9, c10v10, c10v11
    c10v1 = v71
    if c10v1 then
      do return end
    end
    c10v1 = v104
    c10v2 = "TargetStatus1"
    c10v1 = c10v1(c10v2)
    c10v2 = mMovie
    c10v4 = "TargetStatus1"
    c10v2:EnablePfdeco(c10v4)
    c10v3 = v1
    c10v3 = c10v3.Ternary
    c10v5 = 100
    c10v6 = 0
    c10v3 = c10v3(c10v0, c10v5, c10v6)
    c10v2 = c10v1 + c10v3
    c10v3 = v33
    c10v5 = "TargetStatus1"
    c10v3 = c10v3:GetOriginalCoords(c10v5)
    c10v3 = c10v3.y
    c10v4 = function(c9v0)
      local c9v1, c9v2, c9v3, c9v4, c9v5, c9v6, c9v7, c9v8, c9v9
      c9v1 = v33
      c9v2 = "TargetStatus1"
      c9v3 = nil
      c9v5 = c10v3
      c9v8 = c10v2
      c9v9 = c10v3
      c9v7 = c9v8 - c9v9
      c9v6 = c9v7 * c9v0
      c9v4 = c9v5 + c9v6
      c9v1:ChangeOriginalCoords(c9v2, c9v3, c9v4)
      c9v1 = v33
      c9v2 = mMovie
      c9v2 = c9v2:GetViewportWidth()
      c9v3 = mMovie
      c9v3 = c9v3:GetViewportHeight()
      c9v4 = true
      c9v5 = v55
      c9v1:Update(c9v2, c9v3, c9v4, c9v5)
      do return end
    end
    c10v5 = FlashInterpolate
    c10v6 = mMovie
    c10v7 = "TargetStatus1"
    c10v8 = 2
    c10v9 = {c10v4}
    c10v11 = 1
    c10v10 = {c10v11}
    c10v11 = 0.25
    c10v5(c10v6, c10v7, c10v8, c10v9, c10v10, c10v11)
    do return end
  end
  v110 = function(c11v0)
    local c11v1, c11v2, c11v3
    c11v2 = v78
    c11v1 = IsNull
    c11v1 = c11v1(c11v2)
    if not c11v1 then
      c11v1 = v78
      c11v1 = c11v1.bossStatus
      if c11v0 ~= true then
        c11v3 = false
      else
        c11v3 = true
      end
      c11v1:Name__b6611d80(c11v3)
    end
    do return end
  end
  v111 = function(c13v0, c13v1, c13v2, c13v3, c13v4, c13v5, c13v6, c13v7, c13v8, c13v9)
    local c13v10, c13v11, c13v12, c13v13, c13v14, c13v15, c13v16, c13v17, c13v18, c13v19, c13v20, c13v21, c13v22, c13v23, c13v24, c13v25, c13v26, c13v27, c13v28, c13v29, c13v30, c13v31
    c13v11 = mMovie
    c13v10 = IsNull
    c13v10 = c13v10(c13v11)
    if c13v10 then
      do return end
    end
    c13v10 = c13v0.bossStatus
    c13v11 = c13v0.bossImmunityList
    c13v12 = c13v0.clipName
    if c13v1 == nil then
      c13v13 = {}
      c13v0.bossStatusStack = c13v13
    end
    c13v15 = -1
    c13v10:SetHealthOverride(c13v15)
    c13v15 = -1
    c13v10:Name__341d2196(c13v15)
    c13v15 = -1
    c13v10:SetShieldOverride(c13v15)
    c13v15 = -1
    c13v10:Name__9e7298f9(c13v15)
    if c13v6 ~= true then
      c13v15 = false
    else
      c13v15 = true
    end
    c13v10:HideInvulnerableState(c13v15)
    c13v15 = 1
    c13v16 = v32
    c13v13 = #c13v16
    c13v14 = 1
    for __renovice_for_0_0 = c13v15, c13v13, c13v14 do
      c13v16 = c13v11.mActiveImmunities
      c13v17 = 0
      c13v16[__renovice_for_0_0] = c13v17
    end
    c13v15 = true
    c13v16 = true
    c13v11:RemoveElements(c13v15, c13v16)
    c13v15 = nil
    c13v16 = true
    c13v17 = true
    c13v11:Redraw(c13v15, c13v16, c13v17)
    c13v13 = IsNull
    c13v13 = c13v13(c13v1)
    if c13v13 then
      c13v14 = _T.SetImpactMessageDeltaY
      c13v13 = IsNull
      c13v13 = c13v13(c13v14)
      if not c13v13 then
        c13v13 = _T.SetImpactMessageDeltaY
        c13v13()
      end
      c13v13 = FlashInterpolate
      c13v14 = mMovie
      c13v16 = 0
      c13v18 = 12
      c13v17 = {c13v18}
      c13v19 = 0
      c13v18 = {c13v19}
      c13v19 = 0.25
      c13v20 = 1
      c13v21 = function()
        local c12v0, c12v1
        c12v0 = v109
        c12v1 = false
        c12v0(c12v1)
        do return end
      end
      c13v13(c13v14, c13v12, c13v16, c13v17, c13v18, c13v19, c13v20, c13v21)
      c13v13 = false
      c13v0.showBossStatus = c13v13
      c13v13 = nil
      c13v0.bossAvatar = c13v13
      c13v13 = nil
      c13v0.bossSuit = c13v13
      c13v13 = false
      c13v0.showEnergy = c13v13
      c13v13 = nil
      c13v0.damageController = c13v13
      c13v13 = nil
      c13v0.levelOverride = c13v13
      c13v13 = nil
      c13v0.currentBossLevel = c13v13
      do return end
    end
    if not c13v9 then
      c13v14 = c13v0.bossStatusStack
      c13v15 = { StatusElement = nil, Avatar = nil, NumSegments = nil, LevelOverride = nil, HideLevel = nil, ShowEnergy = nil, HideInvuln = nil, SideBySideLayout = nil, HideSecondName = nil }
      c13v15.StatusElement = c13v0
      c13v15.Avatar = c13v1
      c13v15.NumSegments = c13v2
      c13v15.LevelOverride = c13v3
      c13v15.HideLevel = c13v4
      c13v15.ShowEnergy = c13v5
      c13v15.HideInvuln = c13v6
      c13v15.SideBySideLayout = c13v7
      c13v15.HideSecondName = c13v8
      c13v13 = table.insert
      c13v13(c13v14, c13v15)
    end
    c13v13 = 22
    if c13v5 then
      c13v14 = c13v1:InventoryControl()
      c13v15 = IsNull
      c13v15 = c13v15(c13v14)
      if not c13v15 then
        c13v15 = c13v14:GetActivePowerSuit()
        c13v0.bossSuit = c13v15
        c13v16 = IsNull
        c13v16 = c13v16(c13v15)
        if not c13v16 then
          c13v16 = c13v15:GetMaxEnergy()
          c13v17 = 0
          if c13v17 < c13v16 then
            c13v16 = true
            c13v0.showBossEnergy = c13v16
            c13v13 = c13v13 + 20
          end
        end
      end
    end
    c13v14 = c13v1:DamageControl()
    if c13v2 == nil then
      repeat
        c13v15 = IsNull
        c13v15 = c13v15(c13v14)
        if not c13v15 then
          c13v17 = gLotusDamageControllerType
          c13v15 = c13v14:IsA(c13v17)
          if c13v15 then
            c13v2 = c13v14:Name__15edf672()
            break
          end
        end
        c13v2 = 1
      until true
    end
    c13v15 = Engine.IsMobile
    c13v15 = c13v15()
    if (c13v15 and c13v12 == "BossStatus") then
      c13v16 = v60
      c13v15 = IsNull
      c13v15 = c13v15(c13v16)
      if not c13v15 then
        c13v16 = v60
        c13v15 = #c13v16
        c13v16 = 1
        if c13v16 < c13v15 then
          c13v15 = mMovie
          c13v17 = "BossStatus"
          c13v18 = 1
          c13v19 = 150
          c13v15:SetNumberVariable(c13v17, c13v18, c13v19)
        end
      end
    end
    c13v15 = c13v0.bossSegments
    c13v18 = #c13v15
    c13v16 = math.max
    c13v16 = c13v16(c13v2, c13v18)
    c13v20 = c13v2 - 1
    c13v19 = c13v20 * 10
    c13v18 = 508 - c13v19
    c13v17 = c13v18 / c13v2
    c13v18 = {}
    c13v21 = 1
    c13v19 = c13v16
    c13v20 = 1
    for __renovice_for_1_0 = c13v21, c13v19, c13v20 do
      c13v22 = c13v15[__renovice_for_1_0]
      if c13v22 == nil then
        c13v22 = { mClipName = nil }
        c13v25 = ".Segment"
        c13v23 = c13v12 .. c13v25 .. __renovice_for_1_0
        c13v22.mClipName = c13v23
        c13v15[__renovice_for_1_0] = c13v22
        c13v22 = FlashMethod
        c13v23 = mMovie
        c13v26 = ".Segment.duplicateMovieClip"
        c13v24 = c13v12 .. c13v26
        c13v26 = "Segment"
        c13v25 = c13v26 .. __renovice_for_1_0
        c13v27 = c13v0.segmentBaseId
        c13v26 = c13v27 + __renovice_for_1_0
        c13v22(c13v23, c13v24, c13v25, c13v26)
      end
      c13v22 = c13v15[__renovice_for_1_0]
      c13v22 = c13v22.mClipName
      c13v23 = mMovie
      c13v25 = c13v22
      c13v26 = 13
      if not (__renovice_for_1_0 <= c13v2) then
        c13v27 = false
      else
        c13v27 = true
      end
      c13v23:Name__d9713943(c13v25, c13v26, c13v27)
      if not (__renovice_for_1_0 <= c13v2) then
        continue
      end
      c13v23 = table.insert
      c13v23(c13v18, c13v22)
      c13v23 = mMovie
      c13v26 = 0
      c13v28 = -254
      c13v30 = __renovice_for_1_0 - 1
      c13v31 = c13v17 + 10
      c13v29 = c13v30 * c13v31
      c13v27 = c13v28 + c13v29
      c13v23:SetNumberVariable(c13v22, c13v26, c13v27)
      c13v23 = mMovie
      c13v26 = "Trough"
      c13v27 = 14
      c13v23:Name__52c1b74e(c13v22, c13v26, c13v27, c13v17)
      c13v23 = mMovie
      c13v26 = "RightCap"
      c13v27 = 0
      c13v28 = c13v17 - 3
      c13v23:Name__52c1b74e(c13v22, c13v26, c13v27, c13v28)
    end
    c13v21 = ".ShieldBar"
    c13v19 = c13v12 .. c13v21
    c13v20 = mMovie
    c13v23 = 0
    c13v24 = -254
    c13v20:SetNumberVariable(c13v19, c13v23, c13v24)
    c13v20 = mMovie
    c13v23 = "Trough"
    c13v24 = 14
    c13v25 = 508
    c13v20:Name__52c1b74e(c13v19, c13v23, c13v24, c13v25)
    c13v20 = mMovie
    c13v23 = "RightCap"
    c13v24 = 0
    c13v25 = 505
    c13v20:Name__52c1b74e(c13v19, c13v23, c13v24, c13v25)
    c13v22 = ".ProtectedHealth"
    c13v20 = c13v12 .. c13v22
    c13v21 = mMovie
    c13v24 = 14
    c13v25 = 504
    c13v21:SetNumberVariable(c13v20, c13v24, c13v25)
    c13v21 = mMovie
    c13v24 = 0
    c13v25 = 0
    c13v21:SetNumberVariable(c13v20, c13v24, c13v25)
    c13v21 = mMovie
    c13v24 = "Icon"
    c13v25 = 5
    c13v26 = 100
    c13v21:Name__52c1b74e(c13v20, c13v24, c13v25, c13v26)
    c13v21 = mMovie
    c13v24 = "TopFrame"
    c13v25 = 0
    c13v26 = 0
    c13v21:Name__52c1b74e(c13v12, c13v24, c13v25, c13v26)
    c13v21 = mMovie
    c13v24 = "TopFrame"
    c13v25 = 14
    c13v26 = 512
    c13v21:Name__52c1b74e(c13v12, c13v24, c13v25, c13v26)
    c13v21 = mMovie
    c13v24 = "TopFrame"
    c13v25 = 15
    c13v26 = 32
    c13v21:Name__52c1b74e(c13v12, c13v24, c13v25, c13v26)
    if c13v4 then
      c13v21 = mMovie
      c13v24 = "Level"
      c13v25 = 13
      c13v26 = false
      c13v21:Makeposshield(c13v12, c13v24, c13v25, c13v26)
      c13v21 = mMovie
      c13v24 = "LevelFrame"
      c13v25 = 13
      c13v26 = false
      c13v21:Makeposshield(c13v12, c13v24, c13v25, c13v26)
    end
    c13v21 = c13v0.showEnergy
    c13v23 = c13v14:GetMaxShield()
    c13v24 = 0
    if not (c13v24 < c13v23) then
      c13v22 = false
    else
      c13v22 = true
    end
    c13v23 = mMovie
    c13v26 = "ShieldBar"
    c13v27 = 13
    c13v23:Makeposshield(c13v12, c13v26, c13v27, c13v22)
    c13v23 = mMovie
    c13v26 = "EnergyBar"
    c13v27 = 13
    c13v23:Makeposshield(c13v12, c13v26, c13v27, c13v21)
    c13v23 = mMovie
    c13v25 = c13v12
    c13v26 = "EnergyBar"
    c13v27 = 1
    if c13v22 then
      c13v28 = 23
    else
      c13v28 = 5
    end
    c13v23:Name__52c1b74e(c13v25, c13v26, c13v27, c13v28)
    c13v23 = mMovie
    c13v25 = c13v12
    c13v26 = "LevelFrame"
    c13v27 = 1
    if c13v22 then
      c13v29 = 17
    else
      c13v29 = -1
    end
    if c13v21 then
      c13v30 = 16
    else
      c13v30 = 0
    end
    c13v28 = c13v29 + c13v30
    c13v23:Name__52c1b74e(c13v25, c13v26, c13v27, c13v28)
    c13v23 = mMovie
    c13v25 = c13v12
    c13v26 = "Level"
    c13v27 = 1
    if c13v22 then
      c13v29 = 23
    else
      c13v29 = 5
    end
    if c13v21 then
      c13v30 = 16
    else
      c13v30 = 0
    end
    c13v28 = c13v29 + c13v30
    c13v23:Name__52c1b74e(c13v25, c13v26, c13v27, c13v28)
    c13v23 = mMovie
    c13v26 = "Status"
    c13v27 = 36
    c13v28 = ""
    c13v23:Name__f4a9016a(c13v12, c13v26, c13v27, c13v28)
    c13v23 = mMovie
    c13v25 = c13v12
    c13v26 = "Status"
    c13v27 = 1
    if c13v22 then
      c13v29 = 53
    else
      c13v29 = 35
    end
    if c13v21 then
      c13v30 = 16
    else
      c13v30 = 0
    end
    c13v28 = c13v29 + c13v30
    c13v23:Name__52c1b74e(c13v25, c13v26, c13v27, c13v28)
    c13v23 = mMovie
    c13v26 = "Status"
    c13v27 = 0
    c13v28 = -100
    c13v23:Name__52c1b74e(c13v12, c13v26, c13v27, c13v28)
    if c13v22 then
      c13v13 = c13v13 + 20
    end
    c13v10:SetAvatar(c13v1)
    c13v0.bossAvatar = c13v1
    c13v23 = c13v1:DamageControl()
    c13v0.damageController = c13v23
    c13v23 = _T.SetupBossAvatarHealthColor
    if c13v23 ~= nil then
      c13v25 = _T.SetupBossAvatarHealthColor
      c13v10:Name__87819f00(c13v25)
      c13v23 = _T
      c13v24 = nil
      c13v23.SetupBossAvatarHealthColor = c13v24
    end
    c13v10:Initialize()
    c13v28 = 508
    c13v10:Name__ee043c87(c13v18, c13v19, c13v17, c13v28)
    c13v0.levelOverride = c13v3
    c13v23 = string.upper
    c13v23 = c13v23(c13v1:GetUIName())
    c13v25 = _T.OverrideBossNameTag
    c13v24 = IsNull
    c13v24 = c13v24(c13v25)
    if not c13v24 then
      c13v24 = _T.OverrideBossNameTagArgs
      if c13v24 then
        c13v24 = string.upper
        c13v25 = mMovie
        c13v27 = _T.OverrideBossNameTag
        c13v28 = false
        c13v29 = _T.OverrideBossNameTagArgs
        c13v23 = c13v24(c13v25:GetLocalized(c13v27, c13v28, c13v29))
        c13v24 = _T
        c13v25 = nil
        c13v24.OverrideBossNameTagArgs = c13v25
      else
        c13v24 = string.upper
        c13v25 = mMovie
        c13v27 = _T.OverrideBossNameTag
        c13v28 = false
        c13v23 = c13v24(c13v25:GetLocalized(c13v27, c13v28))
      end
      c13v24 = _T
      c13v25 = nil
      c13v24.OverrideBossNameTag = c13v25
    end
    c13v0.currentBossLevel = c13v3
    c13v24 = mMovie
    c13v27 = "Name"
    c13v28 = 0
    c13v29 = -127
    c13v24:Name__52c1b74e(c13v12, c13v27, c13v28, c13v29)
    c13v24 = mMovie
    c13v27 = "NameDropShadow"
    c13v28 = 0
    c13v29 = -127
    c13v24:Name__52c1b74e(c13v12, c13v27, c13v28, c13v29)
    c13v24 = mMovie
    c13v27 = "Name"
    c13v28 = 36
    c13v24:Name__f4a9016a(c13v12, c13v27, c13v28, c13v23)
    c13v24 = FlashMethod
    c13v25 = mMovie
    c13v28 = ".Name.setVertexColors"
    c13v26 = c13v12 .. c13v28
    c13v27 = 16114605
    c13v28 = 16114605
    c13v29 = 11112774
    c13v30 = 11112774
    c13v24(c13v25, c13v26, c13v27, c13v28, c13v29, c13v30)
    c13v24 = mMovie
    c13v27 = "NameDropShadow"
    c13v28 = 36
    c13v24:Name__f4a9016a(c13v12, c13v27, c13v28, c13v23)
    c13v24 = mMovie
    c13v27 = "Level"
    c13v28 = 44
    c13v29 = 16114605
    c13v24:Name__52c1b74e(c13v12, c13v27, c13v28, c13v29)
    if c13v3 == nil then
      c13v24 = c13v1:GetCurrentLevel()
      c13v0.currentBossLevel = c13v24
    end
    c13v24 = mMovie
    c13v27 = "Name"
    c13v28 = 40
    c13v24 = c13v24:Name__46690123(c13v12, c13v27, c13v28)
    c13v25 = mMovie
    c13v28 = "ArmorStatus"
    c13v29 = 0
    c13v31 = c13v24 / 2
    c13v30 = c13v31 + 20
    c13v25:Name__52c1b74e(c13v12, c13v28, c13v29, c13v30)
    c13v25 = mMovie
    c13v28 = "Level"
    c13v29 = 36
    c13v30 = c13v0.currentBossLevel
    c13v25:Name__f4a9016a(c13v12, c13v28, c13v29, c13v30)
    c13v25 = FlashInterpolate
    c13v26 = mMovie
    c13v28 = 0
    c13v30 = 12
    c13v29 = {c13v30}
    c13v31 = 100
    c13v30 = {c13v31}
    c13v31 = 0.25
    c13v25(c13v26, c13v12, c13v28, c13v29, c13v30, c13v31)
    c13v25 = v109
    c13v26 = true
    c13v25(c13v26)
    c13v26 = _T.SetImpactMessageDeltaY
    c13v25 = IsNull
    c13v25 = c13v25(c13v26)
    if not c13v25 then
      c13v25 = _T.SetImpactMessageDeltaY
      c13v25(c13v13)
    end
    c13v25 = true
    c13v0.showBossStatus = c13v25
    do return end
  end
  v112 = function(c14v0, c14v1, c14v2, c14v3, c14v4, c14v5, c14v6)
    local c14v7, c14v8, c14v9, c14v10
    c14v7 = v111
    c14v8 = v78
    c14v9 = false
    c14v10 = false
    c14v7(c14v8, c14v0, c14v1, c14v2, c14v3, c14v4, c14v5, c14v9, c14v10, c14v6)
    do return end
  end
  v113 = function(c16v0, c16v1)
    local c16v2, c16v3, c16v4, c16v5, c16v6, c16v7, c16v8, c16v9, c16v10, c16v11, c16v12, c16v13, c16v14, c16v15, c16v16, c16v17, c16v18, c16v19, c16v20, c16v21, c16v22
    repeat
      c16v2 = c16v0.bossStatus
      c16v2:Update(c16v1)
      c16v3 = c16v0.clipName
      c16v4 = c16v0.damageController
      c16v5 = c16v2:GetDisplayHealth()
      c16v6 = 0
      if not (c16v5 <= c16v6) then
        c16v7 = c16v0.bossAvatar
        c16v6 = IsNull
        c16v6 = c16v6(c16v7)
        if not c16v6 then
          c16v7 = c16v0.bossAvatar
          c16v6 = IsNull
          c16v6 = c16v6(c16v7)
          if not c16v6 then
            c16v6 = c16v0.bossAvatar
            c16v7 = c16v0.bossLevelOverride
            if c16v7 == nil then
              c16v7 = c16v6:GetCurrentLevel()
              c16v8 = c16v0.currentBossLevel
              if c16v7 ~= c16v8 then
                c16v0.currentBossLevel = c16v7
                c16v8 = mMovie
                c16v11 = "Level"
                c16v12 = 36
                c16v8:Name__f4a9016a(c16v3, c16v11, c16v12, c16v7)
              end
            end
            c16v7 = ""
            c16v8 = GetConfigBool
            c16v9 = "HUD.UseAlternateHud"
            c16v8 = c16v8(c16v9)
            if not c16v8 then
              c16v10 = 1
              c16v11 = v32
              c16v8 = #c16v11
              c16v9 = 1
              for __renovice_for_0_0 = c16v10, c16v8, c16v9 do
                c16v13 = __renovice_for_0_0 - 1
                c16v11 = c16v4:Name__ff67e37d(c16v13)
                c16v12 = 0
                if not (c16v12 < c16v11) then
                  continue
                end
                c16v12 = v32[__renovice_for_0_0]
                if c16v12 == nil then
                  continue
                end
                if c16v7 == "" then
                  c16v12 = v32[__renovice_for_0_0]
                  c16v12 = c16v12.Icon
                  c16v7 = c16v12 .. c16v11
                  continue
                end
                c16v13 = " "
                c16v14 = v32[__renovice_for_0_0]
                c16v14 = c16v14.Icon
                c16v7 = c16v7 .. c16v13 .. c16v14 .. c16v11
              end
            end
            local __renovice_state_0 = -1
            c16v8 = mMovie
            c16v11 = "Status"
            c16v12 = 36
            c16v8:Name__f4a9016a(c16v3, c16v11, c16v12, c16v7)
            c16v10 = v15
            c16v8 = c16v4:IsA(c16v10)
            if c16v8 then
              __renovice_state_0 = -1
            else
              __renovice_state_0 = 1
            end
            if __renovice_state_0 == 1 then
              c16v10 = v18
              c16v8 = c16v6:IsA(c16v10)
              if c16v8 then
                __renovice_state_0 = -1
              else
                __renovice_state_0 = 2
              end
            end
            if __renovice_state_0 == 2 then
              c16v10 = v17
              c16v8 = c16v6:IsA(c16v10)
              if not c16v8 then
                __renovice_state_0 = 3
              else
                __renovice_state_0 = -1
              end
            end
            if __renovice_state_0 == 3 then
              c16v10 = v16
              c16v8 = c16v4:IsA(c16v10)
              if not c16v8 then
                __renovice_state_0 = 6
              else
                __renovice_state_0 = 4
              end
            end
            if __renovice_state_0 == 4 then
              c16v9 = _T.GetCurrentShardStage
              c16v8 = IsNull
              c16v8 = c16v8(c16v9)
              if c16v8 then
                __renovice_state_0 = 6
              else
                __renovice_state_0 = 5
              end
            end
            if __renovice_state_0 == 5 then
              c16v8 = c16v4:Name__15edf672()
              c16v9 = _T.GetCurrentShardStage
              c16v9 = c16v9()
              c16v12 = c16v8 - c16v9
              c16v13 = c16v6:GetMaxHealth()
              c16v11 = c16v12 * c16v13
              c16v12 = c16v6:GetHealth()
              c16v10 = c16v11 + c16v12
              c16v2:SetHealthOverride(c16v10)
              c16v14 = c16v6:GetMaxHealth()
              c16v13 = c16v8 * c16v14
              c16v2:Name__341d2196(c16v13)
              c16v11 = mMovie
              c16v14 = "ShieldBar"
              c16v15 = 13
              c16v16 = false
              c16v11:Makeposshield(c16v3, c16v14, c16v15, c16v16)
              __renovice_state_0 = 6
            end
            if __renovice_state_0 ~= 6 then
              c16v2:SetHealthOverride(c16v6:GetHealth())
              c16v2:Name__341d2196(c16v6:GetMaxHealth())
              c16v10 = c16v6:DamageControl()
              c16v2:SetShieldOverride(c16v10:GetShield())
              c16v10 = c16v6:DamageControl()
              c16v2:Name__9e7298f9(c16v10:GetMaxShield())
            end
          end
          break
        end
      end
      c16v6 = FlashInterpolate
      c16v7 = mMovie
      c16v9 = 0
      c16v11 = 12
      c16v10 = {c16v11}
      c16v12 = 0
      c16v11 = {c16v12}
      c16v12 = 0.25
      c16v13 = 1
      c16v14 = function()
        local c15v0, c15v1
        c15v0 = v109
        c15v1 = false
        c15v0(c15v1)
        do return end
      end
      c16v6(c16v7, c16v3, c16v9, c16v10, c16v11, c16v12, c16v13, c16v14)
      c16v6 = false
      c16v0.showBossStatus = c16v6
      c16v6 = nil
      c16v0.bossLevelOverride = c16v6
      c16v6 = nil
      c16v0.currentBossLevel = c16v6
      c16v6 = c16v0.bossStatusStack
      c16v7 = #c16v6
      c16v8 = 0
      if c16v8 < c16v7 then
        c16v7 = table.remove
        c16v9 = #c16v6
        c16v7(c16v6, c16v9)
      end
      c16v7 = #c16v6
      c16v8 = 0
      if c16v8 < c16v7 then
        c16v7 = #c16v6
        c16v10 = c16v7
        c16v8 = 1
        c16v9 = -1
        for __renovice_for_1_0 = c16v10, c16v8, c16v9 do
          c16v11 = c16v6[__renovice_for_1_0]
          c16v13 = c16v11.Avatar
          c16v12 = IsNull
          c16v12 = c16v12(c16v13)
          if not c16v12 then
            c16v12 = c16v11.Avatar
            c16v12 = c16v12:IsKilled()
            if not c16v12 then
              c16v12 = v111
              c16v14 = c16v11.Avatar
              c16v15 = c16v11.NumSegments
              c16v16 = c16v11.LevelOverride
              c16v17 = c16v11.HideLevel
              c16v18 = c16v11.ShowEnergy
              c16v19 = c16v11.HideInvuln
              c16v20 = c16v11.SideBySideLayout
              c16v21 = c16v11.HideSecondName
              c16v22 = true
              c16v12(c16v0, c16v14, c16v15, c16v16, c16v17, c16v18, c16v19, c16v20, c16v21, c16v22)
              break
            end
          end
          c16v12 = table.remove
          c16v14 = #c16v6
          c16v12(c16v6, c16v14)
        end
      end
    until true
    c16v6 = c16v0.bossSuit
    c16v7 = c16v0.showBossEnergy
    if c16v7 then
      c16v7 = IsNull
      c16v7 = c16v7(c16v6)
      if not c16v7 then
        c16v7 = c16v6:GetMaxEnergy()
        c16v8 = c16v6:GetCurEnergy()
        c16v9 = c16v8 / c16v7
        c16v10 = mMovie
        c16v13 = "EnergyBar.FillMask"
        c16v14 = 14
        c16v16 = 0.01
        c16v17 = c16v9 * 440
        c16v15 = math.max
        c16v15 = c16v15(c16v16, c16v17)
        c16v10:Name__52c1b74e(c16v3, c16v13, c16v14, c16v15)
      end
    end
    local __renovice_state_1 = -1
    c16v7 = IsNull
    c16v7 = c16v7(c16v4)
    if c16v7 then
      __renovice_state_1 = -1
    else
      __renovice_state_1 = 1
    end
    if __renovice_state_1 == 1 then
      c16v9 = gLotusDamageControllerType
      c16v7 = c16v4:IsA(c16v9)
      if not c16v7 then
        __renovice_state_1 = -1
      else
        __renovice_state_1 = 2
      end
    end
    if __renovice_state_1 == 2 then
      c16v7 = false
      c16v8 = c16v4:PrerequisiteForest()
      c16v9 = c16v0.bossMaxArmour
      if c16v8 == c16v9 then
        __renovice_state_1 = 4
      else
        __renovice_state_1 = 3
      end
    end
    if __renovice_state_1 == 3 then
      c16v0.bossMaxArmour = c16v8
      c16v7 = true
      __renovice_state_1 = 4
    end
    if __renovice_state_1 == 4 then
      c16v9 = 0
      if not (c16v9 < c16v8) then
        __renovice_state_1 = 31
      else
        __renovice_state_1 = 5
      end
    end
    if __renovice_state_1 == 5 then
      c16v9 = c16v4:GetArmourRating()
      c16v10 = c16v0.currArmour
      if c16v9 == c16v10 then
        __renovice_state_1 = 7
      else
        __renovice_state_1 = 6
      end
    end
    if __renovice_state_1 == 6 then
      c16v0.currArmour = c16v9
      c16v7 = true
      __renovice_state_1 = 7
    end
    if __renovice_state_1 == 7 then
      if not c16v7 then
        __renovice_state_1 = 25
      else
        __renovice_state_1 = 8
      end
    end
    if __renovice_state_1 == 8 then
      c16v10 = c16v9 / c16v8
      c16v12 = 0.34
      c16v13 = c16v10 * 0.31
      c16v11 = c16v12 + c16v13
      c16v12 = mMovie
      c16v16 = ".ArmorStatus.Fill"
      c16v14 = c16v3 .. c16v16
      c16v15 = "VisibilitySize"
      c16v17 = 0
      c16v18 = 0
      c16v19 = 0
      c16v12:Name__e243d995(c16v14, c16v15, c16v11, c16v17, c16v18, c16v19)
      c16v12 = c16v0.bossArmorTracerFill
      c16v12:SetTargetVal(c16v11)
      c16v12 = mMovie
      c16v14 = c16v3
      c16v15 = "ArmorStatus.FillLine"
      c16v16 = 13
      c16v17 = false
      c16v18 = 0
      if not (c16v18 < c16v10) then
        __renovice_state_1 = 12
      else
        __renovice_state_1 = 9
      end
    end
    if __renovice_state_1 == 9 then
      c16v18 = 0.1
      if c16v10 < c16v18 then
        __renovice_state_1 = 11
      else
        __renovice_state_1 = 10
      end
    end
    if __renovice_state_1 == 10 then
      c16v17 = false
      __renovice_state_1 = 12
    end
    if __renovice_state_1 == 11 then
      c16v17 = true
      __renovice_state_1 = 12
    end
    if __renovice_state_1 == 12 then
      c16v12:Makeposshield(c16v14, c16v15, c16v16, c16v17)
      c16v12 = mMovie
      c16v15 = "ArmorStatus.ArmorStatus.FillLine"
      c16v16 = 1
      c16v18 = c16v10 * 23
      c16v17 = 13 - c16v18
      c16v12:Name__52c1b74e(c16v3, c16v15, c16v16, c16v17)
      c16v12 = mMovie
      c16v14 = c16v3
      c16v15 = "ArmorStatus.ArmorTwo"
      c16v16 = 13
      c16v18 = 500
      if c16v18 < c16v9 then
        __renovice_state_1 = 14
      else
        __renovice_state_1 = 13
      end
    end
    if __renovice_state_1 == 13 then
      c16v17 = false
      __renovice_state_1 = 15
    end
    if __renovice_state_1 == 14 then
      c16v17 = true
      __renovice_state_1 = 15
    end
    if __renovice_state_1 == 15 then
      c16v12:Makeposshield(c16v14, c16v15, c16v16, c16v17)
      c16v12 = mMovie
      c16v14 = c16v3
      c16v15 = "ArmorStatus.ArmorThree"
      c16v16 = 13
      c16v18 = 2700
      if c16v18 < c16v9 then
        __renovice_state_1 = 17
      else
        __renovice_state_1 = 16
      end
    end
    if __renovice_state_1 == 16 then
      c16v17 = false
      __renovice_state_1 = 18
    end
    if __renovice_state_1 == 17 then
      c16v17 = true
      __renovice_state_1 = 18
    end
    if __renovice_state_1 == 18 then
      c16v12:Makeposshield(c16v14, c16v15, c16v16, c16v17)
      c16v12 = mMovie
      c16v15 = "ArmorStatus"
      c16v16 = 13
      c16v17 = true
      c16v12:Makeposshield(c16v3, c16v15, c16v16, c16v17)
      c16v12 = mMovie
      c16v14 = c16v3
      c16v15 = "ArmorStatus"
      c16v16 = 12
      c16v17 = v1
      c16v17 = c16v17.Ternary
      c16v19 = 0
      if c16v19 < c16v10 then
        __renovice_state_1 = 20
      else
        __renovice_state_1 = 19
      end
    end
    if __renovice_state_1 == 19 then
      c16v18 = false
      __renovice_state_1 = 21
    end
    if __renovice_state_1 == 20 then
      c16v18 = true
      __renovice_state_1 = 21
    end
    if __renovice_state_1 == 21 then
      c16v19 = 100
      c16v20 = 10
      c16v12:Name__52c1b74e(c16v14, c16v15, c16v16, c16v17(c16v18, c16v19, c16v20))
      if c16v10 ~= 0 then
        __renovice_state_1 = 25
      else
        __renovice_state_1 = 22
      end
    end
    if __renovice_state_1 == 22 then
      c16v13 = c16v0.bossArmorBreakFx
      c16v12 = IsNull
      c16v12 = c16v12(c16v13)
      if c16v12 then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 23
      end
    end
    if __renovice_state_1 == 23 then
      c16v13 = c16v0.bossArmorBreakFx
      c16v13 = c16v13.mInstance
      c16v12 = IsNull
      c16v12 = c16v12(c16v13)
      if not c16v12 then
        __renovice_state_1 = 25
      else
        __renovice_state_1 = 24
      end
    end
    if __renovice_state_1 == 24 then
      c16v12 = v1
      c16v12 = c16v12.CreateUIParticles
      c16v13 = mMovie
      c16v16 = ".ArmorStatus"
      c16v14 = c16v3 .. c16v16
      c16v15 = armorBreakFx
      c16v12 = c16v12(c16v13, c16v14, c16v15)
      c16v0.bossArmorBreakFx = c16v12
      __renovice_state_1 = 25
    end
    if __renovice_state_1 == 25 then
      c16v10 = c16v0.bossArmorTracerFill
      c16v10:Update(c16v1)
      c16v10 = mMovie
      c16v14 = ".ArmorStatus.FillTracer"
      c16v12 = c16v3 .. c16v14
      c16v13 = "VisibilitySize"
      c16v14 = c16v0.bossArmorTracerFill
      c16v14 = c16v14:GetVal()
      c16v15 = 0
      c16v16 = 0
      c16v17 = 0
      c16v10:Name__e243d995(c16v12, c16v13, c16v14, c16v15, c16v16, c16v17)
      c16v10 = mMovie
      c16v13 = 12
      c16v10 = c16v10:GetNumberVariable(c16v3, c16v13)
      c16v11 = mMovie
      c16v13 = c16v3
      c16v14 = "ArmorStatus.FillTracer"
      c16v15 = 13
      c16v17 = 90
      if c16v17 < c16v10 then
        __renovice_state_1 = 27
      else
        __renovice_state_1 = 26
      end
    end
    if __renovice_state_1 == 26 then
      c16v16 = false
      __renovice_state_1 = 28
    end
    if __renovice_state_1 == 27 then
      c16v16 = true
      __renovice_state_1 = 28
    end
    if __renovice_state_1 == 28 then
      c16v11:Makeposshield(c16v13, c16v14, c16v15, c16v16)
      c16v12 = c16v0.bossArmorBreakFx
      c16v11 = IsNull
      c16v11 = c16v11(c16v12)
      if c16v11 then
        __renovice_state_1 = 33
      else
        __renovice_state_1 = 29
      end
    end
    if __renovice_state_1 == 29 then
      c16v12 = c16v0.bossArmorBreakFx
      c16v12 = c16v12.mInstance
      c16v11 = IsNull
      c16v11 = c16v11(c16v12)
      if c16v11 then
        __renovice_state_1 = 33
      else
        __renovice_state_1 = 30
      end
    end
    if __renovice_state_1 == 30 then
      c16v11 = c16v0.bossArmorBreakFx
      c16v11:Update(c16v1)
      __renovice_state_1 = 33
    end
    if __renovice_state_1 == 31 then
      if not c16v7 then
        __renovice_state_1 = 33
      else
        __renovice_state_1 = 32
      end
    end
    if __renovice_state_1 == 32 then
      c16v9 = mMovie
      c16v12 = "ArmorStatus"
      c16v13 = 13
      c16v14 = false
      c16v9:Makeposshield(c16v3, c16v12, c16v13, c16v14)
      __renovice_state_1 = 33
    end
    if __renovice_state_1 ~= 33 then
      c16v7 = mMovie
      c16v10 = "ArmorStatus"
      c16v11 = 13
      c16v12 = false
      c16v7:Makeposshield(c16v3, c16v10, c16v11, c16v12)
    end
    c16v7 = IsNull
    c16v7 = c16v7(c16v4)
    if not c16v7 then
      c16v7 = false
      c16v8 = c16v0.bossImmunityList
      c16v11 = gSentientDamageControllerType
      c16v9 = c16v4:IsA(c16v11)
      if c16v9 then
        c16v9 = false
        c16v12 = 1
        c16v13 = c16v8.mActiveImmunities
        c16v10 = #c16v13
        c16v11 = 1
        for __renovice_for_2_0 = c16v12, c16v10, c16v11 do
          c16v13 = v1
          c16v13 = c16v13.Ternary
          c16v16 = __renovice_for_2_0 - 1
          c16v14 = c16v4:IsResistant(c16v16)
          c16v15 = 1
          c16v16 = 0
          c16v9 = c16v13(c16v14, c16v15, c16v16)
          c16v14 = c16v8.mActiveImmunities
          c16v13 = c16v14[__renovice_for_2_0]
          if c16v13 == c16v9 then
            continue
          end
          c16v13 = c16v8.mActiveImmunities
          c16v13[__renovice_for_2_0] = c16v9
          c16v7 = true
        end
        if c16v7 then
          c16v12 = true
          c16v13 = true
          c16v8:RemoveElements(c16v12, c16v13)
          c16v10 = mMovie
          c16v13 = "ArmorStatus"
          c16v14 = 13
          c16v10 = c16v10:Name__5882fa12(c16v3, c16v13, c16v14)
          c16v11 = mMovie
          c16v14 = "ArmorStatus"
          c16v15 = 0
          c16v11 = c16v11:Name__46690123(c16v3, c16v14, c16v15)
          c16v12 = mMovie
          c16v15 = "Resistances"
          c16v16 = 0
          c16v17 = v1
          c16v17 = c16v17.Ternary
          c16v19 = c16v11 + 8
          c16v20 = c16v11 - 16
          c16v12:Name__52c1b74e(c16v3, c16v15, c16v16, c16v17(c16v10, c16v19, c16v20))
          c16v12 = pairs
          c16v13 = c16v8.mActiveImmunities
          c16v12, c16v13, c16v14 = c16v12(c16v13)
          for __renovice_for_3_0, __renovice_for_3_1 in c16v12, c16v13, c16v14 do
            c16v17 = 0
            if not (c16v17 < __renovice_for_3_1) then
              continue
            end
            c16v19 = { StatusIndex = nil, IsVulnerability = false }
            c16v19.StatusIndex = __renovice_for_3_0
            c16v20 = true
            c16v8:AddElement(c16v19, c16v20)
          end
          c16v14 = nil
          c16v15 = true
          c16v16 = true
          c16v8:Redraw(c16v14, c16v15, c16v16)
        end
      else
        c16v11 = gLotusDamageControllerType
        c16v9 = c16v4:IsA(c16v11)
        if c16v9 then
          c16v9 = c16v4:GetDamageModifiers()
          c16v10 = {}
          c16v13 = 1
          c16v11 = #c16v9
          c16v12 = 1
          for __renovice_for_4_0 = c16v13, c16v11, c16v12 do
            c16v14 = c16v9[__renovice_for_4_0]
            c16v14 = c16v14.damageType
            c16v15 = 25
            if c16v14 == c16v15 then
              continue
            end
            c16v15 = c16v9[__renovice_for_4_0]
            c16v15 = c16v15.showInHUD
            if not c16v15 then
              continue
            end
            c16v15 = c16v9[__renovice_for_4_0]
            c16v15 = c16v15.multiplier
            if c16v15 == 1 then
              continue
            end
            c16v16 = v32
            c16v17 = c16v14 + 1
            c16v15 = c16v16[c16v17]
            if c16v15 == nil then
              continue
            end
            c16v16 = v32
            c16v17 = c16v14 + 1
            c16v15 = c16v16[c16v17]
            c16v15 = c16v15.Icon
            if c16v15 == nil then
              continue
            end
            c16v15 = c16v9[__renovice_for_4_0]
            c16v15 = c16v15.multiplier
            c16v16 = 1
            if c16v16 < c16v15 then
              c16v15 = c16v14 + 1
              c16v16 = 2
              c16v10[c16v15] = c16v16
              continue
            end
            c16v15 = c16v14 + 1
            c16v16 = 1
            c16v10[c16v15] = c16v16
          end
          c16v11 = c16v0.bossAvatar
          c16v12 = IsNull
          c16v12 = c16v12(c16v11)
          if not c16v12 then
            c16v12 = c16v11:GetScriptBlackboard()
            c16v13 = c16v12.overrideDamageUI
            if c16v13 ~= nil then
              c16v13 = c16v12.overrideDamageUI
              c16v14 = nil
              c16v15 = nil
              for __renovice_for_5_0, __renovice_for_5_1 in c16v13, c16v14, c16v15 do
                c16v18 = __renovice_for_5_0 + 1
                c16v10[c16v18] = __renovice_for_5_1
              end
            end
          end
          c16v14 = 1
          c16v15 = c16v8.mActiveImmunities
          c16v12 = #c16v15
          c16v13 = 1
          for __renovice_for_6_0 = c16v14, c16v12, c16v13 do
            c16v16 = c16v8.mActiveImmunities
            c16v15 = c16v16[__renovice_for_6_0]
            c16v16 = c16v10[__renovice_for_6_0]
            if c16v15 == c16v16 then
              continue
            end
            c16v15 = c16v8.mActiveImmunities
            c16v16 = v1
            c16v16 = c16v16.Ternary
            c16v18 = c16v10[__renovice_for_6_0]
            if c16v18 ~= nil then
              c16v17 = false
            else
              c16v17 = true
            end
            c16v18 = 0
            c16v19 = c16v10[__renovice_for_6_0]
            c16v16 = c16v16(c16v17, c16v18, c16v19)
            c16v15[__renovice_for_6_0] = c16v16
            c16v7 = true
          end
          if c16v7 then
            c16v14 = true
            c16v15 = true
            c16v8:RemoveElements(c16v14, c16v15)
            c16v12 = mMovie
            c16v15 = "ArmorStatus"
            c16v16 = 13
            c16v12 = c16v12:Name__5882fa12(c16v3, c16v15, c16v16)
            c16v13 = mMovie
            c16v16 = "ArmorStatus"
            c16v17 = 0
            c16v13 = c16v13:Name__46690123(c16v3, c16v16, c16v17)
            c16v14 = mMovie
            c16v17 = "Resistances"
            c16v18 = 0
            c16v19 = v1
            c16v19 = c16v19.Ternary
            c16v21 = c16v13 + 8
            c16v22 = c16v13 - 16
            c16v14:Name__52c1b74e(c16v3, c16v17, c16v18, c16v19(c16v12, c16v21, c16v22))
            c16v14 = pairs
            c16v15 = c16v8.mActiveImmunities
            c16v14, c16v15, c16v16 = c16v14(c16v15)
            for __renovice_for_7_0, __renovice_for_7_1 in c16v14, c16v15, c16v16 do
              if __renovice_for_7_1 == 2 then
                c16v19 = vulnerabilityIcons[__renovice_for_7_0]
                if c16v19 ~= nil then
                  c16v21 = { StatusIndex = nil, IsVulnerability = true }
                  c16v21.StatusIndex = __renovice_for_7_0
                  c16v22 = true
                  c16v8:AddElement(c16v21, c16v22)
                end
                continue
              end
              c16v19 = 0
              if not (c16v19 < __renovice_for_7_1) then
                continue
              end
              c16v21 = { StatusIndex = nil, IsVulnerability = false }
              c16v21.StatusIndex = __renovice_for_7_0
              c16v22 = true
              c16v8:AddElement(c16v21, c16v22)
            end
            c16v16 = nil
            c16v17 = true
            c16v18 = true
            c16v8:Redraw(c16v16, c16v17, c16v18)
          end
        end
      end
    end
    do return end
  end
  v114 = function(c17v0)
    v78.bossSuit = c17v0
    do return end
  end
  v115 = function(c20v0, c20v1)
    local c20v2, c20v3, c20v4, c20v5, c20v6, c20v7, c20v8, c20v9, c20v10, c20v11
    c20v2 = 3
    c20v3 = gRegion
    c20v3 = c20v3:IsMaster()
    if not c20v3 then
      c20v2 = 4
    end
    c20v3 = mMovie
    c20v6 = "Segment"
    c20v7 = 13
    c20v8 = false
    c20v3:Makeposshield(c20v1, c20v6, c20v7, c20v8)
    c20v3 = gRegion
    c20v5 = v9
    c20v6 = nil
    c20v3 = c20v3:CreateObject(c20v5, c20v6, c20v2)
    c20v6 = mMovie
    c20v7 = nil
    c20v8 = 508
    c20v10 = ""
    c20v3:Setup(c20v6, c20v7, c20v8, c20v1, c20v10)
    c20v6 = true
    c20v3:SetTrackArmor(c20v6)
    c20v6 = false
    c20v3:SetRightAligned(c20v6)
    c20v6 = true
    c20v3:Name__aad6d7a6(c20v6)
    c20v6 = true
    c20v3:SetDotPreview(c20v6)
    c20v6 = true
    c20v3:Name__2c47a195(c20v6)
    c20v4 = require
    c20v5 = "EE.Interface.Components.List"
    c20v4 = c20v4(c20v5)
    c20v5 = c20v4.CreateList
    c20v6 = mMovie
    c20v9 = ".Resistances.Resistance1"
    c20v7 = c20v1 .. c20v9
    c20v5 = c20v5(c20v6, c20v7)
    c20v6 = 0
    c20v5.mForcedVerticalSeparation = c20v6
    c20v6 = 20
    c20v5.mForcedHorizontalSeparation = c20v6
    c20v6 = {}
    c20v5.mActiveImmunities = c20v6
    c20v6 = function(c18v0)
      local c18v1, c18v2, c18v3, c18v4, c18v5
      c18v2 = resistanceMaterial
      c18v1 = IsNull
      c18v1 = c18v1(c18v2)
      if not c18v1 then
        c18v1 = mMovie
        c18v5 = ".Icon"
        c18v3 = c18v0 .. c18v5
        c18v4 = resistanceMaterial
        c18v1:OverrideMaterial(c18v3, c18v4)
      end
      do return end
    end
    c20v5.mClipCreatedCallback = c20v6
    c20v6 = function(c19v0)
      local c19v1, c19v2, c19v3, c19v4, c19v5, c19v6, c19v7, c19v8
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "Backer"
      c19v5 = 13
      c19v6 = false
      c19v1:Makeposshield(c19v3, c19v4, c19v5, c19v6)
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "VulnerableBacker"
      c19v5 = 13
      c19v6 = false
      c19v1:Makeposshield(c19v3, c19v4, c19v5, c19v6)
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "ExclusiveBacker"
      c19v5 = 13
      c19v6 = false
      c19v1:Makeposshield(c19v3, c19v4, c19v5, c19v6)
      c19v1 = c19v0.IsExclusive
      if c19v1 then
        c19v1 = mMovie
        c19v4 = c19v0.mClipName
        c19v5 = ".Icon"
        c19v3 = c19v4 .. c19v5
        c19v5 = vulnerabilityIcons
        c19v6 = c19v0.StatusIndex
        c19v4 = c19v5[c19v6]
        c19v1:OverrideTexture(c19v3, c19v4)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "Icon"
        c19v5 = 14
        c19v6 = 24
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "Icon"
        c19v5 = 15
        c19v6 = 24
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "ExclusiveBacker"
        c19v5 = 13
        c19v6 = true
        c19v1:Makeposshield(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "ExclusiveBacker"
        c19v5 = 12
        c19v6 = 0
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "VulnerableBacker"
        c19v5 = 11
        c19v6 = _G
        c19v6 = c19v6.UIColor_Black
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "VulnerableBacker"
        c19v5 = 13
        c19v6 = true
        c19v1:Makeposshield(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "Icon"
        c19v5 = 11
        c19v7 = vulnerabilityIconColors
        c19v8 = c19v0.StatusIndex
        c19v6 = c19v7[c19v8]
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6:GetUInt())
        c19v1 = c20v5
        c19v2 = c19v0.mClipName
        c19v1.mExclusiveDamageIndicatorClipName = c19v2
        c19v1 = c20v5
        c19v2 = c19v0.DamageTypeForExclusive
        c19v1.mExclusiveDamageType = c19v2
        do return end
      end
      c19v1 = c19v0.IsVulnerability
      if c19v1 then
        c19v1 = mMovie
        c19v4 = c19v0.mClipName
        c19v5 = ".Icon"
        c19v3 = c19v4 .. c19v5
        c19v5 = vulnerabilityIcons
        c19v6 = c19v0.StatusIndex
        c19v4 = c19v5[c19v6]
        c19v1:OverrideTexture(c19v3, c19v4)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "VulnerableBacker"
        c19v5 = 11
        c19v6 = _G
        c19v6 = c19v6.UIColor_Black
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "VulnerableBacker"
        c19v5 = 13
        c19v6 = true
        c19v1:Makeposshield(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "Icon"
        c19v5 = 14
        c19v6 = 24
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "Icon"
        c19v5 = 15
        c19v6 = 24
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
        c19v1 = mMovie
        c19v3 = c19v0.mClipName
        c19v4 = "Icon"
        c19v5 = 11
        c19v7 = vulnerabilityIconColors
        c19v8 = c19v0.StatusIndex
        c19v6 = c19v7[c19v8]
        c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6:GetUInt())
        do return end
      end
      c19v1 = mMovie
      c19v4 = c19v0.mClipName
      c19v5 = ".Icon"
      c19v3 = c19v4 .. c19v5
      c19v5 = resistanceIcons
      c19v6 = c19v0.StatusIndex
      c19v4 = c19v5[c19v6]
      c19v1:OverrideTexture(c19v3, c19v4)
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "Backer"
      c19v5 = 11
      c19v6 = v73
      c19v6 = c19v6.Armor
      c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "Backer"
      c19v5 = 13
      c19v6 = true
      c19v1:Makeposshield(c19v3, c19v4, c19v5, c19v6)
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "Icon"
      c19v5 = 14
      c19v6 = 16
      c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "Icon"
      c19v5 = 15
      c19v6 = 16
      c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
      c19v1 = mMovie
      c19v3 = c19v0.mClipName
      c19v4 = "Icon"
      c19v5 = 11
      c19v6 = 16777215
      c19v1:Name__52c1b74e(c19v3, c19v4, c19v5, c19v6)
      do return end
    end
    c20v5.mElementDrawCallback = c20v6
    c20v8 = 1
    c20v9 = v32
    c20v6 = #c20v9
    c20v7 = 1
    for __renovice_for_0_0 = c20v8, c20v6, c20v7 do
      c20v9 = c20v5.mActiveImmunities
      c20v10 = 0
      c20v9[__renovice_for_0_0] = c20v10
    end
    c20v6 = mMovie
    c20v9 = "ShieldBar"
    c20v10 = 0
    c20v11 = -254
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "ShieldBar.Trough"
    c20v10 = 14
    c20v11 = 508
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "ShieldBar.RightCap"
    c20v10 = 0
    c20v11 = 505
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "ProtectedHealth"
    c20v10 = 14
    c20v11 = 508
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = FlashMethod
    c20v7 = mMovie
    c20v10 = ".ProtectedHealth.swapDepths"
    c20v8 = c20v1 .. c20v10
    c20v9 = 1322
    c20v6(c20v7, c20v8, c20v9)
    c20v6 = mMovie
    c20v9 = "EnergyBar"
    c20v10 = 0
    c20v11 = -254
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.DetailRight"
    c20v10 = 0
    c20v11 = 444
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.TroughRight"
    c20v10 = 0
    c20v11 = 459
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.TroughMid"
    c20v10 = 14
    c20v11 = 410
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.BgFillRight"
    c20v10 = 0
    c20v11 = 459
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.BgFillMid"
    c20v10 = 14
    c20v11 = 410
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.FillRight"
    c20v10 = 0
    c20v11 = 459
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.FillMid"
    c20v10 = 14
    c20v11 = 410
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v9 = "EnergyBar.FillMask"
    c20v10 = 14
    c20v11 = 440
    c20v6:Name__52c1b74e(c20v1, c20v9, c20v10, c20v11)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.BgFillLeft"
    c20v8 = c20v1 .. c20v10
    c20v9 = 12
    c20v10 = 20
    c20v6:SetNumberVariable(c20v8, c20v9, c20v10)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.BgFillMid"
    c20v8 = c20v1 .. c20v10
    c20v9 = 12
    c20v10 = 20
    c20v6:SetNumberVariable(c20v8, c20v9, c20v10)
    c20v6 = mMovie
    c20v10 = "EnergyBar.BgFillRight"
    c20v8 = c20v1 .. c20v10
    c20v9 = 12
    c20v10 = 20
    c20v6:SetNumberVariable(c20v8, c20v9, c20v10)
    c20v6 = mMovie
    c20v9 = _G
    c20v9 = c20v9.UIMaterial_Plain
    c20v6:OverrideMaterial(c20v1, c20v9)
    c20v6 = mMovie
    c20v10 = ".LevelFrame"
    c20v8 = c20v1 .. c20v10
    c20v9 = _G
    c20v9 = c20v9.UIMaterial_Plain
    c20v6:OverrideMaterial(c20v8, c20v9)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.BgFillLeft"
    c20v8 = c20v1 .. c20v10
    c20v9 = _G
    c20v9 = c20v9.UIMaterial_Plain
    c20v6:OverrideMaterial(c20v8, c20v9)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.BgFillMid"
    c20v8 = c20v1 .. c20v10
    c20v9 = _G
    c20v9 = c20v9.UIMaterial_Plain
    c20v6:OverrideMaterial(c20v8, c20v9)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.BgFillRight"
    c20v8 = c20v1 .. c20v10
    c20v9 = _G
    c20v9 = c20v9.UIMaterial_Plain
    c20v6:OverrideMaterial(c20v8, c20v9)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.FillLeft"
    c20v8 = c20v1 .. c20v10
    c20v9 = bossEnergyMaterial
    c20v6:OverrideMaterial(c20v8, c20v9)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.FillMid"
    c20v8 = c20v1 .. c20v10
    c20v9 = bossEnergyMaterial
    c20v6:OverrideMaterial(c20v8, c20v9)
    c20v6 = mMovie
    c20v10 = ".EnergyBar.FillRight"
    c20v8 = c20v1 .. c20v10
    c20v9 = bossEnergyMaterial
    c20v6:OverrideMaterial(c20v8, c20v9)
    c20v6 = mMovie
    c20v9 = "Resistances.VoidIndicator"
    c20v10 = 13
    c20v11 = false
    c20v6:Makeposshield(c20v1, c20v9, c20v10, c20v11)
    c20v0.clipName = c20v1
    c20v0.bossStatus = c20v3
    c20v0.bossImmunityList = c20v5
    c20v6 = {}
    c20v0.bossSegments = c20v6
    c20v6 = SmoothFloat
    c20v7 = 0
    c20v8 = 0.25
    c20v6 = c20v6(c20v7, c20v8)
    c20v0.bossArmorTracerFill = c20v6
    c20v6 = {}
    c20v0.bossStatusStack = c20v6
    do return end
  end
  v116 = function()
    local c23v0, c23v1, c23v2, c23v3, c23v4, c23v5, c23v6, c23v7, c23v8, c23v9, c23v10, c23v11, c23v12, c23v13, c23v14, c23v15
    c23v2 = 1
    c23v3 = v75
    c23v0 = #c23v3
    c23v1 = 1
    for __renovice_for_0_0 = c23v2, c23v0, c23v1 do
      c23v3 = mMovie
      c23v5 = v75[__renovice_for_0_0]
      c23v5 = c23v5.mClipName
      c23v6 = 12
      c23v7 = 0
      c23v3:SetNumberVariable(c23v5, c23v6, c23v7)
    end
    c23v0 = GetConfigBool
    c23v1 = "HUD.UseAlternateHud"
    c23v0 = c23v0(c23v1)
    if not c23v0 then
      c23v0 = GetConfigBool
      c23v1 = "HUD.HideStatusBars"
      c23v0 = c23v0(c23v1)
      if not c23v0 then
        c23v0 = {}
        v75 = c23v0
        c23v0 = 3
        c23v1 = gRegion
        c23v1 = c23v1:IsMaster()
        if not c23v1 then
          c23v0 = 4
        end
        c23v1 = v1
        c23v1 = c23v1.Ternary
        c23v2 = v71
        c23v3 = 3
        c23v4 = 1
        c23v1 = c23v1(c23v2, c23v3, c23v4)
        c23v2 = require
        c23v3 = "EE.Interface.Components.List"
        c23v2 = c23v2(c23v3)
        c23v5 = 1
        c23v3 = c23v1
        c23v4 = 1
        for __renovice_for_1_0 = c23v5, c23v3, c23v4 do
          c23v7 = "TargetStatus"
          c23v6 = c23v7 .. __renovice_for_1_0
          c23v7 = mMovie
          c23v7 = c23v7:HasVariable(c23v6)
          if not c23v7 then
            c23v7 = FlashMethod
            c23v8 = mMovie
            c23v9 = "TargetStatus1.duplicateMovieClip"
            c23v11 = __renovice_for_1_0 + 11000
            c23v7(c23v8, c23v9, c23v6, c23v11)
          end
          c23v7 = {}
          c23v7.mClipName = c23v6
          c23v8 = false
          c23v7.mActive = c23v8
          c23v8 = nil
          c23v7.mPtr = c23v8
          c23v8 = nil
          c23v7.mDeco = c23v8
          c23v8 = nil
          c23v7.mAvatar = c23v8
          c23v8 = nil
          c23v7.mHitProxy = c23v8
          c23v8 = 0
          c23v7.mPersist = c23v8
          c23v8 = {}
          c23v7.mActiveProcs = c23v8
          c23v8 = {}
          c23v7.mActiveImmunities = c23v8
          c23v10 = 1
          c23v11 = v32
          c23v8 = #c23v11
          c23v9 = 1
          for __renovice_for_2_0 = c23v10, c23v8, c23v9 do
            c23v11 = c23v7.mActiveProcs
            c23v12 = 0
            c23v11[__renovice_for_2_0] = c23v12
            c23v11 = c23v7.mActiveImmunities
            c23v12 = 0
            c23v11[__renovice_for_2_0] = c23v12
          end
          c23v8 = c23v2.CreateList
          c23v9 = mMovie
          c23v11 = c23v7.mClipName
          c23v12 = ".Resistances.Resistance1"
          c23v10 = c23v11 .. c23v12
          c23v8 = c23v8(c23v9, c23v10)
          c23v7.mImmunityList = c23v8
          c23v8 = c23v7.mImmunityList
          c23v9 = 0
          c23v8.mForcedVerticalSeparation = c23v9
          c23v8 = c23v7.mImmunityList
          c23v9 = 20
          c23v8.mForcedHorizontalSeparation = c23v9
          c23v8 = c23v7.mImmunityList
          c23v9 = function(c21v0)
            local c21v1, c21v2, c21v3, c21v4, c21v5
            c21v2 = resistanceMaterial
            c21v1 = IsNull
            c21v1 = c21v1(c21v2)
            if not c21v1 then
              c21v1 = mMovie
              c21v5 = ".Icon"
              c21v3 = c21v0 .. c21v5
              c21v4 = resistanceMaterial
              c21v1:OverrideMaterial(c21v3, c21v4)
            end
            do return end
          end
          c23v8.mClipCreatedCallback = c23v9
          c23v8 = c23v7.mImmunityList
          c23v9 = function(c22v0)
            local c22v1, c22v2, c22v3, c22v4, c22v5, c22v6, c22v7, c22v8
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "Backer"
            c22v5 = 13
            c22v6 = false
            c22v1:Makeposshield(c22v3, c22v4, c22v5, c22v6)
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "VulnerableBacker"
            c22v5 = 13
            c22v6 = false
            c22v1:Makeposshield(c22v3, c22v4, c22v5, c22v6)
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "ExclusiveBacker"
            c22v5 = 13
            c22v6 = false
            c22v1:Makeposshield(c22v3, c22v4, c22v5, c22v6)
            c22v1 = c22v0.IsExclusive
            if c22v1 then
              c22v1 = mMovie
              c22v4 = c22v0.mClipName
              c22v5 = ".Icon"
              c22v3 = c22v4 .. c22v5
              c22v5 = vulnerabilityIcons
              c22v6 = c22v0.StatusIndex
              c22v4 = c22v5[c22v6]
              c22v1:OverrideTexture(c22v3, c22v4)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "Icon"
              c22v5 = 14
              c22v6 = 24
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "Icon"
              c22v5 = 15
              c22v6 = 24
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "ExclusiveBacker"
              c22v5 = 13
              c22v6 = true
              c22v1:Makeposshield(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "ExclusiveBacker"
              c22v5 = 12
              c22v6 = 0
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "VulnerableBacker"
              c22v5 = 11
              c22v6 = _G
              c22v6 = c22v6.UIColor_Black
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "VulnerableBacker"
              c22v5 = 13
              c22v6 = true
              c22v1:Makeposshield(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "Icon"
              c22v5 = 11
              c22v7 = vulnerabilityIconColors
              c22v8 = c22v0.StatusIndex
              c22v6 = c22v7[c22v8]
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6:GetUInt())
              c22v1 = c23v7
              c22v2 = c22v0.mClipName
              c22v1.mExclusiveDamageIndicatorClipName = c22v2
              c22v1 = c23v7
              c22v2 = c22v0.DamageTypeForExclusive
              c22v1.mExclusiveDamageType = c22v2
              do return end
            end
            c22v1 = c22v0.IsVulnerability
            if c22v1 then
              c22v1 = mMovie
              c22v4 = c22v0.mClipName
              c22v5 = ".Icon"
              c22v3 = c22v4 .. c22v5
              c22v5 = vulnerabilityIcons
              c22v6 = c22v0.StatusIndex
              c22v4 = c22v5[c22v6]
              c22v1:OverrideTexture(c22v3, c22v4)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "VulnerableBacker"
              c22v5 = 11
              c22v6 = _G
              c22v6 = c22v6.UIColor_Black
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "VulnerableBacker"
              c22v5 = 13
              c22v6 = true
              c22v1:Makeposshield(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "Icon"
              c22v5 = 14
              c22v6 = 24
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "Icon"
              c22v5 = 15
              c22v6 = 24
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
              c22v1 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = "Icon"
              c22v5 = 11
              c22v7 = vulnerabilityIconColors
              c22v8 = c22v0.StatusIndex
              c22v6 = c22v7[c22v8]
              c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6:GetUInt())
              do return end
            end
            c22v1 = mMovie
            c22v4 = c22v0.mClipName
            c22v5 = ".Icon"
            c22v3 = c22v4 .. c22v5
            c22v5 = resistanceIcons
            c22v6 = c22v0.StatusIndex
            c22v4 = c22v5[c22v6]
            c22v1:OverrideTexture(c22v3, c22v4)
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "Backer"
            c22v5 = 11
            c22v6 = v73
            c22v6 = c22v6.Armor
            c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "Backer"
            c22v5 = 13
            c22v6 = true
            c22v1:Makeposshield(c22v3, c22v4, c22v5, c22v6)
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "Icon"
            c22v5 = 14
            c22v6 = 16
            c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "Icon"
            c22v5 = 15
            c22v6 = 16
            c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
            c22v1 = mMovie
            c22v3 = c22v0.mClipName
            c22v4 = "Icon"
            c22v5 = 11
            c22v6 = 16777215
            c22v1:Name__52c1b74e(c22v3, c22v4, c22v5, c22v6)
            do return end
          end
          c23v8.mElementDrawCallback = c23v9
          c23v8 = 110
          c23v7.mHpShieldDisplayWidth = c23v8
          c23v8 = gRegion
          c23v10 = v9
          c23v11 = nil
          c23v8 = c23v8:CreateObject(c23v10, c23v11, c23v0)
          c23v7.mHpShieldDisplay = c23v8
          c23v8 = c23v7.mHpShieldDisplay
          c23v10 = mMovie
          c23v11 = nil
          c23v12 = c23v7.mHpShieldDisplayWidth
          c23v15 = ".Target"
          c23v13 = c23v6 .. c23v15
          c23v14 = ""
          c23v8:Setup(c23v10, c23v11, c23v12, c23v13, c23v14)
          c23v8 = c23v7.mHpShieldDisplay
          c23v10 = true
          c23v8:Realitydy(c23v10)
          c23v8 = c23v7.mHpShieldDisplay
          c23v10 = true
          c23v8:Name__2c47a195(c23v10)
          c23v8 = c23v7.mHpShieldDisplay
          c23v10 = true
          c23v8:SetDotPreview(c23v10)
          c23v8 = SmoothFloat
          c23v9 = 0
          c23v10 = 0.25
          c23v8 = c23v8(c23v9, c23v10)
          c23v7.mArmourTracerFill = c23v8
          c23v8 = mMovie
          c23v10 = c23v7.mClipName
          c23v11 = "Name"
          c23v12 = 46
          c23v13 = "bottom"
          c23v8:Name__f4a9016a(c23v10, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = c23v7.mClipName
          c23v12 = ".Name"
          c23v10 = c23v11 .. c23v12
          c23v11 = 36
          c23v12 = ""
          c23v8:SetStringVariable(c23v10, c23v11, c23v12)
          c23v8 = Engine.IsMobile
          c23v8 = c23v8()
          if c23v8 then
            c23v8 = mMovie
            c23v11 = c23v7.mClipName
            c23v12 = ".Name"
            c23v10 = c23v11 .. c23v12
            c23v11 = 1
            c23v8 = c23v8:GetNumberVariable(c23v10, c23v11)
            c23v9 = mMovie
            c23v12 = c23v7.mClipName
            c23v13 = ".Name"
            c23v11 = c23v12 .. c23v13
            c23v12 = 1
            c23v13 = c23v8 - 10
            c23v9:SetNumberVariable(c23v11, c23v12, c23v13)
          end
          c23v8 = mMovie
          c23v11 = c23v7.mClipName
          c23v12 = ".Immunities"
          c23v10 = c23v11 .. c23v12
          c23v11 = 36
          c23v12 = ""
          c23v8:SetStringVariable(c23v10, c23v11, c23v12)
          c23v8 = mMovie
          c23v10 = c23v7.mClipName
          c23v11 = "Immunities"
          c23v12 = 88
          c23v13 = true
          c23v8:Makeposshield(c23v10, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = "Name"
          c23v12 = 44
          c23v13 = v73
          c23v13 = c23v13.Text
          c23v8:Name__52c1b74e(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = "Level"
          c23v12 = 44
          c23v13 = v73
          c23v13 = c23v13.Text
          c23v8:Name__52c1b74e(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = "UnderLotus"
          c23v12 = 11
          c23v13 = v73
          c23v13 = c23v13.Text
          c23v8:Name__52c1b74e(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v12 = ".ArmorStatus.Fill"
          c23v10 = c23v6 .. c23v12
          c23v11 = armorStatusMaterial
          c23v8:OverrideMaterial(c23v10, c23v11)
          c23v8 = mMovie
          c23v11 = "ArmorStatus.Fill"
          c23v12 = 11
          c23v13 = v73
          c23v13 = c23v13.Armor
          c23v8:Name__52c1b74e(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v12 = ".ArmorStatus.FillTracer"
          c23v10 = c23v6 .. c23v12
          c23v11 = armorStatusMaterial
          c23v8:OverrideMaterial(c23v10, c23v11)
          c23v8 = mMovie
          c23v11 = "ArmorStatus.FillTracer"
          c23v12 = 11
          c23v13 = v73
          c23v13 = c23v13.Health
          c23v8:Name__52c1b74e(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = "ArmorStatus.ArmorTwo"
          c23v12 = 11
          c23v13 = v73
          c23v13 = c23v13.Text
          c23v8:Name__52c1b74e(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = "ArmorStatus.ArmorThree"
          c23v12 = 11
          c23v13 = v73
          c23v13 = c23v13.Text
          c23v8:Name__52c1b74e(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = "ArmorStatus"
          c23v12 = 13
          c23v13 = false
          c23v8:Makeposshield(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = "Resistances.VoidIndicator"
          c23v12 = 13
          c23v13 = false
          c23v8:Makeposshield(c23v6, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v10 = "BossStatus.ArmorStatus.Fill"
          c23v11 = armorStatusMaterial
          c23v8:OverrideMaterial(c23v10, c23v11)
          c23v8 = mMovie
          c23v10 = "BossStatus.ArmorStatus.Fill"
          c23v11 = 11
          c23v12 = v73
          c23v12 = c23v12.Armor
          c23v8:SetNumberVariable(c23v10, c23v11, c23v12)
          c23v8 = mMovie
          c23v10 = "BossStatus.ArmorStatus.FillTracer"
          c23v11 = armorStatusMaterial
          c23v8:OverrideMaterial(c23v10, c23v11)
          c23v8 = mMovie
          c23v10 = "BossStatus.ArmorStatus.FillTracer"
          c23v11 = 11
          c23v12 = v73
          c23v12 = c23v12.Health
          c23v8:SetNumberVariable(c23v10, c23v11, c23v12)
          c23v8 = mMovie
          c23v10 = "BossStatus.ArmorStatus.ArmorTwo"
          c23v11 = 11
          c23v12 = v73
          c23v12 = c23v12.Text
          c23v8:SetNumberVariable(c23v10, c23v11, c23v12)
          c23v8 = mMovie
          c23v10 = "BossStatus.ArmorStatus.ArmorThree"
          c23v11 = 11
          c23v12 = v73
          c23v12 = c23v12.Text
          c23v8:SetNumberVariable(c23v10, c23v11, c23v12)
          c23v8 = mMovie
          c23v10 = "BossStatus.ArmorStatus"
          c23v11 = 13
          c23v12 = false
          c23v8:Name__d9713943(c23v10, c23v11, c23v12)
          c23v8 = c23v7.mHpShieldDisplay
          c23v10 = false
          c23v8:SetRightAligned(c23v10)
          c23v8 = mMovie
          c23v10 = c23v7.mClipName
          c23v11 = "Target"
          c23v12 = 0
          c23v14 = c23v7.mHpShieldDisplayWidth
          c23v13 = c23v14 * -0.5
          c23v8:Name__52c1b74e(c23v10, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v11 = 12
          c23v12 = 0
          c23v8:SetNumberVariable(c23v6, c23v11, c23v12)
          c23v8 = mMovie
          c23v10 = c23v6
          c23v11 = "Target"
          c23v12 = 13
          c23v14 = v35
          c23v15 = v3
          c23v15 = c23v15.UI_MODE_IN_SPACE_HUB
          if c23v14 == c23v15 then
            c23v13 = false
          else
            c23v13 = true
          end
          c23v8:Makeposshield(c23v10, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v10 = c23v7.mClipName
          c23v11 = "Target.Right"
          c23v12 = 0
          c23v13 = c23v7.mHpShieldDisplayWidth
          c23v8:Name__52c1b74e(c23v10, c23v11, c23v12, c23v13)
          c23v8 = mMovie
          c23v10 = c23v7.mClipName
          c23v11 = "ArmorStatus"
          c23v12 = 0
          c23v15 = c23v7.mHpShieldDisplayWidth
          c23v14 = c23v15 * 0.5
          c23v13 = c23v14 + 16
          c23v8:Name__52c1b74e(c23v10, c23v11, c23v12, c23v13)
          c23v9 = v75
          c23v8 = table.insert
          c23v8(c23v9, c23v7)
        end
        c23v3 = v33
        if c23v3 ~= nil then
          c23v3 = v33
          c23v5 = mMovie
          c23v6 = "TargetStatus1"
          c23v3:Unregister(c23v5, c23v6)
          c23v3 = v71
          if not c23v3 then
            c23v3 = v104
            c23v4 = "TargetStatus1"
            c23v3 = c23v3(c23v4)
            c23v4 = mMovie
            c23v6 = "TargetStatus1"
            c23v7 = 0
            c23v9 = mMovie
            c23v9 = c23v9:GetMovieWidth()
            c23v8 = c23v9 * 0.5
            c23v4:SetNumberVariable(c23v6, c23v7, c23v8)
            c23v4 = mMovie
            c23v6 = "TargetStatus1"
            c23v7 = 1
            c23v4:SetNumberVariable(c23v6, c23v7, c23v3)
            c23v4 = v33
            c23v6 = mMovie
            c23v7 = "TargetStatus1"
            c23v9 = v33
            c23v9 = c23v9.ANCHOR_V_TOP
            c23v10 = v33
            c23v10 = c23v10.ANCHOR_H_CENTRE
            c23v8 = {c23v9, c23v10}
            c23v4:Register(c23v6, c23v7, c23v8)
            c23v4 = v33
            c23v6 = mMovie
            c23v6 = c23v6:GetViewportWidth()
            c23v7 = mMovie
            c23v7 = c23v7:GetViewportHeight()
            c23v8 = true
            c23v9 = v55
            c23v4:Update(c23v6, c23v7, c23v8, c23v9)
          end
        end
        do return end
      end
    end
    do return end
  end
  v117 = function()
    local c24v0, c24v1, c24v2, c24v3, c24v4, c24v5, c24v6
    c24v0 = v79
    c24v0 = c24v0.clipName
    c24v1 = mMovie
    c24v4 = "EnergyBar.DetailLeft"
    c24v5 = 11
    c24v6 = 16114605
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "EnergyBar.DetailRight"
    c24v5 = 11
    c24v6 = 16114605
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "EnergyBar.FillLeft"
    c24v5 = 11
    c24v6 = v73
    c24v6 = c24v6.Energy
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "EnergyBar.FillMid"
    c24v5 = 11
    c24v6 = v73
    c24v6 = c24v6.Energy
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "EnergyBar.FillRight"
    c24v5 = 11
    c24v6 = v73
    c24v6 = c24v6.Energy
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "ArmorStatus.Fill"
    c24v5 = 11
    c24v6 = v73
    c24v6 = c24v6.Armor
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "ArmorStatus.FillTracer"
    c24v5 = 11
    c24v6 = v73
    c24v6 = c24v6.Health
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "ArmorStatus.ArmorTwo"
    c24v5 = 11
    c24v6 = v73
    c24v6 = c24v6.Text
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v1 = mMovie
    c24v4 = "ArmorStatus.ArmorThree"
    c24v5 = 11
    c24v6 = v73
    c24v6 = c24v6.Text
    c24v1:Name__52c1b74e(c24v0, c24v4, c24v5, c24v6)
    c24v2 = v79
    c24v2 = c24v2.bossImmunityList
    c24v1 = IsNull
    c24v1 = c24v1(c24v2)
    if not c24v1 then
      c24v1 = v79
      c24v1 = c24v1.bossImmunityList
      c24v3 = nil
      c24v4 = true
      c24v5 = true
      c24v1:Redraw(c24v3, c24v4, c24v5)
    end
    do return end
  end
  v118 = function(c26v0, c26v1, c26v2, c26v3, c26v4, c26v5, c26v6, c26v7, c26v8)
    local c26v9, c26v10, c26v11, c26v12, c26v13, c26v14, c26v15, c26v16
    c26v10 = v79
    c26v10 = c26v10.bossStatus
    c26v9 = IsNull
    c26v9 = c26v9(c26v10)
    if c26v9 then
      c26v9 = FlashMethod
      c26v10 = mMovie
      c26v11 = "BossStatus.duplicateMovieClip"
      c26v12 = "BossStatus2"
      c26v13 = 12000
      c26v9(c26v10, c26v11, c26v12, c26v13)
      c26v9 = v33
      c26v11 = mMovie
      c26v12 = "BossStatus2"
      c26v14 = v33
      c26v14 = c26v14.ANCHOR_V_TOP
      c26v15 = v33
      c26v15 = c26v15.ANCHOR_H_CENTRE
      c26v13 = {c26v14, c26v15}
      c26v9:Register(c26v11, c26v12, c26v13)
      c26v9 = v33
      c26v11 = "BossStatus2"
      c26v12 = nil
      c26v13 = 58
      c26v9:ChangeOriginalCoords(c26v11, c26v12, c26v13)
      c26v9 = v33
      c26v11 = mMovie
      c26v11 = c26v11:GetViewportWidth()
      c26v12 = mMovie
      c26v12 = c26v12:GetViewportHeight()
      c26v13 = true
      c26v14 = v55
      c26v9:Update(c26v11, c26v12, c26v13, c26v14)
      c26v9 = v115
      c26v10 = v79
      c26v11 = "BossStatus2"
      c26v9(c26v10, c26v11)
      c26v9 = v117
      c26v9()
    end
    c26v9 = v111
    c26v10 = v79
    c26v9(c26v10, c26v0, c26v1, c26v2, c26v3, c26v4, c26v5, c26v6, c26v7, c26v8)
    if c26v6 then
      c26v9 = true
      if c26v7 then
        c26v10 = mMovie
        c26v12 = "BossStatus2"
        c26v13 = "Name"
        c26v14 = 13
        c26v15 = false
        c26v10:Makeposshield(c26v12, c26v13, c26v14, c26v15)
        c26v10 = mMovie
        c26v12 = "BossStatus2"
        c26v13 = "NameDropShadow"
        c26v14 = 13
        c26v15 = false
        c26v10:Makeposshield(c26v12, c26v13, c26v14, c26v15)
        c26v9 = false
      end
      c26v10 = function(c25v0, c25v1, c25v2, c25v3, c25v4)
        local c25v5, c25v6, c25v7, c25v8, c25v9, c25v10, c25v11, c25v12, c25v13, c25v14, c25v15, c25v16, c25v17, c25v18, c25v19, c25v20, c25v21, c25v22
        c25v5 = c25v0.bossSegments
        c25v6 = #c25v5
        c25v9 = 2 * c25v2
        c25v11 = c25v6 - 1
        c25v10 = c25v11 * 10
        c25v8 = c25v9 - c25v10
        c25v7 = c25v8 / c25v6
        c25v8 = {}
        c25v11 = 1
        c25v9 = c25v6
        c25v10 = 1
        for __renovice_for_0_0 = c25v11, c25v9, c25v10 do
          c25v12 = c25v5[__renovice_for_0_0]
          c25v12 = c25v12.mClipName
          c25v13 = table.insert
          c25v13(c25v8, c25v12)
          c25v13 = mMovie
          c25v16 = 0
          c25v19 = -c25v2
          c25v21 = __renovice_for_0_0 - 1
          c25v22 = c25v7 + 10
          c25v20 = c25v21 * c25v22
          c25v18 = c25v19 + c25v20
          c25v17 = c25v18 + c25v1
          c25v13:SetNumberVariable(c25v12, c25v16, c25v17)
          c25v13 = mMovie
          c25v16 = "Trough"
          c25v17 = 14
          c25v13:Name__52c1b74e(c25v12, c25v16, c25v17, c25v7)
          c25v13 = mMovie
          c25v16 = "RightCap"
          c25v17 = 0
          c25v18 = c25v7 - 3
          c25v13:Name__52c1b74e(c25v12, c25v16, c25v17, c25v18)
        end
        c25v9 = c25v0.clipName
        c25v12 = ".ShieldBar"
        c25v10 = c25v9 .. c25v12
        c25v11 = mMovie
        c25v14 = 0
        c25v11:SetNumberVariable(c25v10, c25v14, c25v3)
        c25v11 = mMovie
        c25v14 = "Trough"
        c25v15 = 14
        c25v11:Name__52c1b74e(c25v10, c25v14, c25v15, c25v7)
        c25v11 = mMovie
        c25v14 = "RightCap"
        c25v15 = 0
        c25v16 = c25v7 - 3
        c25v11:Name__52c1b74e(c25v10, c25v14, c25v15, c25v16)
        c25v12 = 2 * c25v2
        c25v11 = c25v12 / 504
        c25v12 = 0
        if c25v12 < c25v11 then
          c25v14 = ".ProtectedHealth"
          c25v12 = c25v9 .. c25v14
          c25v13 = mMovie
          c25v16 = 14
          c25v17 = 2 * c25v2
          c25v13:SetNumberVariable(c25v12, c25v16, c25v17)
          c25v13 = mMovie
          c25v16 = 0
          c25v13:SetNumberVariable(c25v12, c25v16, c25v1)
          c25v13 = mMovie
          c25v16 = "Icon"
          c25v17 = 5
          c25v19 = 1 / c25v11
          c25v18 = c25v19 * 100
          c25v13:Name__52c1b74e(c25v12, c25v16, c25v17, c25v18)
          c25v13 = FlashMethod
          c25v14 = mMovie
          c25v17 = ".swapDepths"
          c25v15 = c25v12 .. c25v17
          c25v16 = 13050
          c25v13(c25v14, c25v15, c25v16)
        end
        c25v12 = mMovie
        c25v15 = "Status"
        c25v16 = 0
        c25v17 = c25v1 - 100
        c25v12:Name__52c1b74e(c25v9, c25v15, c25v16, c25v17)
        c25v12 = mMovie
        c25v15 = "TopFrame"
        c25v16 = 0
        c25v12:Name__52c1b74e(c25v9, c25v15, c25v16, c25v1)
        c25v13 = c25v2 * 2
        c25v12 = c25v13 + 2
        c25v13 = mMovie
        c25v16 = "TopFrame"
        c25v17 = 14
        c25v13:Name__52c1b74e(c25v9, c25v16, c25v17, c25v12)
        c25v13 = mMovie
        c25v16 = "TopFrame"
        c25v17 = 15
        c25v18 = c25v12 / 16
        c25v13:Name__52c1b74e(c25v9, c25v16, c25v17, c25v18)
        if c25v4 then
          c25v13 = mMovie
          c25v16 = "Name"
          c25v17 = 0
          c25v13:Name__52c1b74e(c25v9, c25v16, c25v17, c25v3)
          c25v13 = mMovie
          c25v16 = "NameDropShadow"
          c25v17 = 0
          c25v13:Name__52c1b74e(c25v9, c25v16, c25v17, c25v3)
          c25v13 = mMovie
          c25v16 = "Name"
          c25v17 = 40
          c25v13 = c25v13:Name__46690123(c25v9, c25v16, c25v17)
          c25v14 = mMovie
          c25v17 = "ArmorStatus"
          c25v18 = 0
          c25v21 = c25v13 / 2
          c25v20 = c25v21 + 20
          c25v19 = c25v1 + c25v20
          c25v14:Name__52c1b74e(c25v9, c25v17, c25v18, c25v19)
        end
        c25v13 = c25v0.bossStatus
        c25v13:Name__ee043c87(c25v8, c25v10, c25v7, c25v7)
        do return end
      end
      c26v11 = mMovie
      c26v13 = v78
      c26v13 = c26v13.clipName
      c26v14 = 1
      c26v11 = c26v11:GetNumberVariable(c26v13, c26v14)
      c26v12 = mMovie
      c26v14 = v79
      c26v14 = c26v14.clipName
      c26v15 = 1
      c26v12:SetNumberVariable(c26v14, c26v15, c26v11)
      c26v13 = v78
      c26v14 = -137
      c26v15 = 127
      c26v16 = -264
      c26v10(c26v13, c26v14, c26v15, c26v16, c26v9)
      c26v13 = v79
      c26v14 = 137
      c26v15 = 127
      c26v16 = 10
      c26v10(c26v13, c26v14, c26v15, c26v16, c26v9)
    end
    do return end
  end
  v119 = function()
    local c27v0, c27v1, c27v2, c27v3, c27v4
    c27v1 = mMovie
    c27v3 = "_root"
    c27v4 = 5
    c27v1 = c27v1:GetNumberVariable(c27v3, c27v4)
    c27v0 = 100 / c27v1
    v56 = c27v0
    c27v1 = mMovie
    c27v3 = "_root"
    c27v4 = 6
    c27v1 = c27v1:GetNumberVariable(c27v3, c27v4)
    c27v0 = 100 / c27v1
    v57 = c27v0
    c27v0 = mMovie
    c27v2 = "_root"
    c27v3 = 0
    c27v0 = c27v0:GetNumberVariable(c27v2, c27v3)
    c27v1 = mMovie
    c27v3 = "_root"
    c27v4 = 1
    c27v1 = c27v1:GetNumberVariable(c27v3, c27v4)
    c27v3 = v56
    c27v2 = c27v0 * c27v3
    v58 = c27v2
    c27v3 = v57
    c27v2 = c27v1 * c27v3
    v59 = c27v2
    do return end
  end
  v120 = function(c28v0)
    local c28v1, c28v2, c28v3, c28v4, c28v5
    c28v1 = mMovie
    c28v3 = "Fill"
    c28v4 = 11
    c28v5 = v73
    c28v5 = c28v5.Health
    c28v1:Name__52c1b74e(c28v0, c28v3, c28v4, c28v5)
    c28v1 = mMovie
    c28v4 = ".Backer"
    c28v2 = c28v0 .. c28v4
    c28v3 = reviveProgressBacker
    c28v1:OverrideTexture(c28v2, c28v3)
    c28v1 = mMovie
    c28v3 = "Backer"
    c28v4 = 11
    c28v5 = _G
    c28v5 = c28v5.UIColor_Black
    c28v1:Name__52c1b74e(c28v0, c28v3, c28v4, c28v5)
    c28v1 = mMovie
    c28v3 = "Pct"
    c28v4 = 44
    c28v5 = v73
    c28v5 = c28v5.Text
    c28v1:Name__52c1b74e(c28v0, c28v3, c28v4, c28v5)
    do return end
  end
  v121 = function(c29v0)
    local c29v1, c29v2, c29v3, c29v4, c29v5, c29v6, c29v7, c29v8, c29v9, c29v10, c29v11
    c29v1 = IsNull
    c29v1 = c29v1(c29v0)
    if c29v1 then
      c29v1 = gPlayerProfileMgr
      c29v3 = 0
      c29v1 = c29v1:GetPlayerProfile(c29v3)
      c29v2 = IsNull
      c29v2 = c29v2(c29v1)
      if c29v2 then
        do return end
      end
      c29v0 = c29v1:Settings()
      c29v2 = IsNull
      c29v2 = c29v2(c29v0)
      if c29v2 then
        do return end
      end
    end
    c29v1 = v73
    c29v4 = 22
    c29v2 = c29v0:GetHudColor(c29v4)
    c29v1.Text = c29v2
    c29v1 = v73
    c29v4 = 24
    c29v2 = c29v0:GetHudColor(c29v4)
    c29v1.Health = c29v2
    c29v1 = v73
    c29v4 = 1
    c29v2 = c29v0:GetHudColor(c29v4)
    c29v1.Armor = c29v2
    c29v1 = v73
    c29v4 = 39
    c29v2 = c29v0:GetHudColor(c29v4)
    c29v1.DecoHealth = c29v2
    c29v1 = v73
    c29v4 = 17
    c29v2 = c29v0:GetHudColor(c29v4)
    c29v1.Energy = c29v2
    c29v1 = mMovie
    c29v3 = "HintMessage"
    c29v4 = 44
    c29v5 = v73
    c29v5 = c29v5.Text
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.EnergyBar.DetailLeft"
    c29v4 = 11
    c29v5 = 16114605
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.EnergyBar.DetailRight"
    c29v4 = 11
    c29v5 = 16114605
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.EnergyBar.FillLeft"
    c29v4 = 11
    c29v5 = v73
    c29v5 = c29v5.Energy
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.EnergyBar.FillMid"
    c29v4 = 11
    c29v5 = v73
    c29v5 = c29v5.Energy
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.EnergyBar.FillRight"
    c29v4 = 11
    c29v5 = v73
    c29v5 = c29v5.Energy
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.ArmorStatus.Fill"
    c29v4 = 11
    c29v5 = v73
    c29v5 = c29v5.Armor
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.ArmorStatus.FillTracer"
    c29v4 = 11
    c29v5 = v73
    c29v5 = c29v5.Health
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.ArmorStatus.ArmorTwo"
    c29v4 = 11
    c29v5 = v73
    c29v5 = c29v5.Text
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v1 = mMovie
    c29v3 = "BossStatus.ArmorStatus.ArmorThree"
    c29v4 = 11
    c29v5 = v73
    c29v5 = c29v5.Text
    c29v1:SetNumberVariable(c29v3, c29v4, c29v5)
    c29v2 = v78
    c29v2 = c29v2.bossImmunityList
    c29v1 = IsNull
    c29v1 = c29v1(c29v2)
    if not c29v1 then
      c29v1 = v78
      c29v1 = c29v1.bossImmunityList
      c29v3 = nil
      c29v4 = true
      c29v5 = true
      c29v1:Redraw(c29v3, c29v4, c29v5)
    end
    c29v1 = v79
    c29v1 = c29v1.clipName
    if c29v1 then
      c29v1 = v117
      c29v1()
    end
    c29v3 = 1
    c29v4 = v75
    c29v1 = #c29v4
    c29v2 = 1
    for __renovice_for_0_0 = c29v3, c29v1, c29v2 do
      c29v4 = mMovie
      c29v6 = v75[__renovice_for_0_0]
      c29v6 = c29v6.mClipName
      c29v7 = "Name"
      c29v8 = 44
      c29v9 = v73
      c29v9 = c29v9.Text
      c29v4:Name__52c1b74e(c29v6, c29v7, c29v8, c29v9)
      c29v4 = mMovie
      c29v6 = v75[__renovice_for_0_0]
      c29v6 = c29v6.mClipName
      c29v7 = "Level"
      c29v8 = 44
      c29v9 = v73
      c29v9 = c29v9.Text
      c29v4:Name__52c1b74e(c29v6, c29v7, c29v8, c29v9)
      c29v4 = mMovie
      c29v6 = v75[__renovice_for_0_0]
      c29v6 = c29v6.mClipName
      c29v7 = "UnderLotus"
      c29v8 = 11
      c29v9 = v73
      c29v9 = c29v9.Text
      c29v4:Name__52c1b74e(c29v6, c29v7, c29v8, c29v9)
      c29v4 = mMovie
      c29v6 = v75[__renovice_for_0_0]
      c29v6 = c29v6.mClipName
      c29v7 = "ArmorStatus.Fill"
      c29v8 = 11
      c29v9 = v73
      c29v9 = c29v9.Armor
      c29v4:Name__52c1b74e(c29v6, c29v7, c29v8, c29v9)
      c29v4 = mMovie
      c29v6 = v75[__renovice_for_0_0]
      c29v6 = c29v6.mClipName
      c29v7 = "ArmorStatus.FillTracer"
      c29v8 = 11
      c29v9 = v73
      c29v9 = c29v9.Health
      c29v4:Name__52c1b74e(c29v6, c29v7, c29v8, c29v9)
      c29v4 = mMovie
      c29v6 = v75[__renovice_for_0_0]
      c29v6 = c29v6.mClipName
      c29v7 = "ArmorStatus.ArmorTwo"
      c29v8 = 11
      c29v9 = v73
      c29v9 = c29v9.Text
      c29v4:Name__52c1b74e(c29v6, c29v7, c29v8, c29v9)
      c29v4 = mMovie
      c29v6 = v75[__renovice_for_0_0]
      c29v6 = c29v6.mClipName
      c29v7 = "ArmorStatus.ArmorThree"
      c29v8 = 11
      c29v9 = v73
      c29v9 = c29v9.Text
      c29v4:Name__52c1b74e(c29v6, c29v7, c29v8, c29v9)
      c29v4 = v75[__renovice_for_0_0]
      c29v4 = c29v4.mImmunityList
      c29v6 = nil
      c29v7 = true
      c29v8 = true
      c29v4:Redraw(c29v6, c29v7, c29v8)
    end
    c29v1 = v67
    if c29v1 ~= nil then
      c29v3 = 1
      c29v1 = 8
      c29v2 = 1
      for __renovice_for_1_0 = c29v3, c29v1, c29v2 do
        c29v4 = v67[__renovice_for_1_0]
        if c29v4 == nil then
          continue
        end
        c29v4 = v67[__renovice_for_1_0]
        c29v4 = c29v4.Player
        c29v4 = c29v4.clipName
        c29v5 = v67[__renovice_for_1_0]
        c29v5 = c29v5.Kubrow
        c29v5 = c29v5.clipName
        c29v6 = mMovie
        c29v9 = "Name"
        c29v10 = 44
        c29v11 = v73
        c29v11 = c29v11.Text
        c29v6:Name__52c1b74e(c29v4, c29v9, c29v10, c29v11)
        c29v6 = mMovie
        c29v9 = "Range"
        c29v10 = 44
        c29v11 = v73
        c29v11 = c29v11.Text
        c29v6:Name__52c1b74e(c29v4, c29v9, c29v10, c29v11)
        c29v6 = v120
        c29v9 = ".Progress"
        c29v7 = c29v4 .. c29v9
        c29v6(c29v7)
        c29v6 = mMovie
        c29v9 = "Name"
        c29v10 = 44
        c29v11 = v73
        c29v11 = c29v11.Text
        c29v6:Name__52c1b74e(c29v5, c29v9, c29v10, c29v11)
        c29v6 = mMovie
        c29v9 = "Range"
        c29v10 = 44
        c29v11 = v73
        c29v11 = c29v11.Text
        c29v6:Name__52c1b74e(c29v5, c29v9, c29v10, c29v11)
        c29v6 = v120
        c29v9 = ".Progress"
        c29v7 = c29v5 .. c29v9
        c29v6(c29v7)
      end
    end
    do return end
  end
  v122 = function(c30v0)
    local c30v1, c30v2, c30v3, c30v4, c30v5, c30v6
    c30v1 = gPlayerProfileMgr
    c30v1 = c30v1:IsLoggedIn()
    if not c30v1 then
      do return end
    end
    c30v1 = gPlayerProfileMgr
    c30v3 = 0
    c30v1 = c30v1:GetPlayerProfile(c30v3)
    c30v2 = IsNull
    c30v2 = c30v2(c30v1)
    if c30v2 then
      do return end
    end
    c30v2 = c30v1:Settings()
    c30v3 = IsNull
    c30v3 = c30v3(c30v2)
    if not c30v3 then
      local __renovice_state_0 = 5
      c30v3 = v121
      c30v3()
      c30v3 = c30v2:HUDScale()
      v54 = c30v3
      c30v3 = c30v2:GetShowTeammateLabels()
      v69 = c30v3
      c30v3 = v71
      c30v4 = c30v2:GetShowHealthBarOverEnemies()
      v71 = c30v4
      if c30v0 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
      if __renovice_state_0 == 6 then
        c30v4 = v71
        if c30v3 == c30v4 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        c30v4 = v116
        c30v4()
        __renovice_state_0 = 8
      end
      if __renovice_state_0 == 8 then
        c30v4 = c30v2:GetShowEnemyNames()
        v70 = c30v4
      end
    end
    c30v3 = v0
    c30v3 = c30v3.HandleHudScale
    c30v4 = mMovie
    c30v5 = v54
    c30v6 = v33
    c30v3 = c30v3(c30v4, c30v5, c30v6)
    v55 = c30v3
    c30v3 = v119
    c30v3()
    do return end
  end
  v123 = function()
    local c31v0, c31v1, c31v2, c31v3, c31v4, c31v5, c31v6, c31v7
    c31v0 = {}
    v67 = c31v0
    c31v2 = 1
    c31v0 = 8
    c31v1 = 1
    for __renovice_for_0_0 = c31v2, c31v0, c31v1 do
      c31v3 = v67
      c31v4 = {}
      c31v3[__renovice_for_0_0] = c31v4
      c31v3 = v67[__renovice_for_0_0]
      c31v4 = { clipName = nil, isPredeath = false }
      c31v6 = "Teammate"
      c31v5 = c31v6 .. __renovice_for_0_0
      c31v4.clipName = c31v5
      c31v3.Player = c31v4
      c31v3 = v67[__renovice_for_0_0]
      c31v4 = { clipName = nil, isPredeath = false }
      c31v6 = "Teammate"
      c31v7 = "Kubrow"
      c31v5 = c31v6 .. __renovice_for_0_0 .. c31v7
      c31v4.clipName = c31v5
      c31v3.Kubrow = c31v4
    end
    do return end
  end
  v124 = function()
    local c32v0, c32v1, c32v2, c32v3, c32v4, c32v5, c32v6, c32v7, c32v8
    c32v2 = 1
    c32v3 = v32
    c32v0 = #c32v3
    c32v1 = 1
    for __renovice_for_0_0 = c32v2, c32v0, c32v1 do
      c32v3 = v32[__renovice_for_0_0]
      c32v4 = mMovie
      c32v6 = "/Lotus/Language/Game/"
      c32v7 = v32[__renovice_for_0_0]
      c32v7 = c32v7.Raw
      c32v8 = "_NoIcon"
      c32v5 = c32v6 .. c32v7 .. c32v8
      c32v6 = false
      c32v4 = c32v4:GetLocalized(c32v5, c32v6)
      c32v3.NameTag = c32v4
      c32v3 = v32[__renovice_for_0_0]
      c32v4 = mMovie
      c32v6 = "<"
      c32v7 = v32[__renovice_for_0_0]
      c32v7 = c32v7.Raw
      c32v8 = ">"
      c32v5 = c32v6 .. c32v7 .. c32v8
      c32v6 = true
      c32v4 = c32v4:GetLocalized(c32v5, c32v6)
      c32v3.Icon = c32v4
    end
    do return end
  end
  v125 = function()
    local c33v0, c33v1, c33v2, c33v3, c33v4, c33v5
    c33v2 = 1
    c33v3 = v67
    c33v0 = #c33v3
    c33v1 = 1
    for __renovice_for_0_0 = c33v2, c33v0, c33v1 do
      c33v4 = v67[__renovice_for_0_0]
      c33v4 = c33v4.Player
      c33v4 = c33v4.HealthAndShield
      c33v3 = IsNull
      c33v3 = c33v3(c33v4)
      if not c33v3 then
        c33v3 = gRegion
        c33v5 = v67[__renovice_for_0_0]
        c33v5 = c33v5.Player
        c33v5 = c33v5.HealthAndShield
        c33v3:DestroyObject(c33v5)
      end
      c33v4 = v67[__renovice_for_0_0]
      c33v4 = c33v4.Kubrow
      c33v4 = c33v4.HealthAndShield
      c33v3 = IsNull
      c33v3 = c33v3(c33v4)
      if c33v3 then
        continue
      end
      c33v3 = gRegion
      c33v5 = v67[__renovice_for_0_0]
      c33v5 = c33v5.Kubrow
      c33v5 = c33v5.HealthAndShield
      c33v3:DestroyObject(c33v5)
    end
    c33v2 = 1
    c33v3 = v75
    c33v0 = #c33v3
    c33v1 = 1
    for __renovice_for_1_0 = c33v2, c33v0, c33v1 do
      c33v4 = v75[__renovice_for_1_0]
      c33v4 = c33v4.mHpShieldDisplay
      c33v3 = IsNull
      c33v3 = c33v3(c33v4)
      if c33v3 then
        continue
      end
      c33v3 = gRegion
      c33v5 = v75[__renovice_for_1_0]
      c33v5 = c33v5.mHpShieldDisplay
      c33v3:DestroyObject(c33v5)
    end
    c33v1 = v78
    c33v1 = c33v1.bossStatusStack
    c33v0 = #c33v1
    c33v1 = 0
    if c33v1 < c33v0 then
      c33v0 = _T
      c33v1 = v78
      c33v1 = c33v1.bossStatusStack
      c33v0.BossStatusStack = c33v1
    end
    c33v1 = v79
    c33v1 = c33v1.bossStatusStack
    c33v0 = #c33v1
    c33v1 = 0
    if c33v1 < c33v0 then
      c33v0 = _T
      c33v1 = v79
      c33v1 = c33v1.bossStatusStack
      c33v0.SecondBossStatusStack = c33v1
    end
    c33v0 = _T
    c33v1 = nil
    c33v0.ResetHudHintPos = c33v1
    c33v0 = _T
    c33v1 = nil
    c33v0.SetHudHintPosWorld = c33v1
    c33v0 = _T
    c33v1 = nil
    c33v0.SetHudHintMessage = c33v1
    c33v0 = _T
    c33v1 = nil
    c33v0.SetupBossAvatar = c33v1
    c33v0 = _T
    c33v1 = nil
    c33v0.SetupSecondBossAvatar = c33v1
    c33v0 = _T
    c33v1 = nil
    c33v0.ForceBossInvulnerableHealthDisplay = c33v1
    c33v0 = _T
    c33v1 = nil
    c33v0.UpdateBossSuit = c33v1
    do return end
  end
  Shutdown = v125
  v125 = function()
    local c34v0, c34v1, c34v2, c34v3, c34v4, c34v5, c34v6, c34v7, c34v8, c34v9, c34v10, c34v11, c34v12, c34v13, c34v14, c34v15, c34v16, c34v17
    c34v0 = gGameRules
    v44 = c34v0
    c34v0 = v44
    c34v2 = gLotusBasePvpGameRulesType
    c34v0 = c34v0:IsA(c34v2)
    v36 = c34v0
    c34v0 = v44
    c34v2 = Name__4710a87d
    c34v0 = c34v0:IsA(c34v2)
    v37 = c34v0
    c34v0 = v3
    c34v0 = c34v0.GetUIMode
    c34v0 = c34v0()
    v35 = c34v0
    c34v0 = mMovie
    c34v0 = c34v0:GetParent()
    v45 = c34v0
    c34v0 = mMovie
    c34v0 = c34v0:GetMovieWidth()
    v52 = c34v0
    c34v0 = mMovie
    c34v0 = c34v0:GetMovieHeight()
    v53 = c34v0
    c34v0 = mMovie
    c34v0 = c34v0:GetViewportWidth()
    v50 = c34v0
    c34v0 = mMovie
    c34v0 = c34v0:GetViewportHeight()
    v51 = c34v0
    c34v2 = v50
    c34v3 = v51
    c34v1 = math.min
    c34v1 = c34v1(c34v2, c34v3)
    c34v0 = c34v1 * 0.15
    v87 = c34v0
    c34v0 = mMovie
    c34v2 = "HintMessage"
    c34v3 = 0
    c34v0 = c34v0:GetNumberVariable(c34v2, c34v3)
    v93 = c34v0
    c34v0 = mMovie
    c34v2 = "HintMessage"
    c34v3 = 1
    c34v0 = c34v0:GetNumberVariable(c34v2, c34v3)
    v94 = c34v0
    c34v0 = v5
    c34v0 = c34v0.Create
    c34v1 = mMovie
    c34v0 = c34v0(c34v1)
    v33 = c34v0
    c34v0 = v33
    c34v2 = mMovie
    c34v3 = "HintMessage"
    c34v5 = v33
    c34v5 = c34v5.ANCHOR_V_CENTRE
    c34v6 = v33
    c34v6 = c34v6.ANCHOR_H_CENTRE
    c34v4 = {c34v5, c34v6}
    c34v0:Register(c34v2, c34v3, c34v4)
    c34v0 = v33
    c34v2 = mMovie
    c34v3 = "BossStatus"
    c34v5 = v33
    c34v5 = c34v5.ANCHOR_V_TOP
    c34v6 = v33
    c34v6 = c34v6.ANCHOR_H_CENTRE
    c34v4 = {c34v5, c34v6}
    c34v0:Register(c34v2, c34v3, c34v4)
    c34v0 = v33
    c34v2 = mMovie
    c34v2 = c34v2:GetViewportWidth()
    c34v3 = mMovie
    c34v3 = c34v3:GetViewportHeight()
    c34v4 = true
    c34v5 = v55
    c34v0:Update(c34v2, c34v3, c34v4, c34v5)
    c34v0 = _G
    c34v0 = c34v0.UIColor_Shield
    if c34v0 ~= nil then
      c34v0 = v1
      c34v0 = c34v0.ConvertColorNumberToProceduralRGB
      c34v1 = _G
      c34v1 = c34v1.UIColor_Shield
      c34v0 = c34v0(c34v1)
      v89 = c34v0
      c34v0 = v1
      c34v0 = c34v0.ConvertColorNumberToProceduralRGB
      c34v1 = _G
      c34v1 = c34v1.UIColor_Overshield
      c34v0 = c34v0(c34v1)
      v90 = c34v0
      c34v0 = true
      v88 = c34v0
    else
      c34v0 = v1
      c34v0 = c34v0.ConvertColorNumberToProceduralRGB
      c34v1 = 16777215
      c34v0 = c34v0(c34v1)
      v89 = c34v0
      c34v0 = v1
      c34v0 = c34v0.ConvertColorNumberToProceduralRGB
      c34v1 = 16777215
      c34v0 = c34v0(c34v1)
      v90 = c34v0
    end
    c34v0 = v124
    c34v0()
    c34v0 = v104
    c34v1 = "TargetStatus1"
    c34v0(c34v1)
    c34v0 = v122
    c34v1 = true
    c34v0(c34v1)
    c34v0 = gPlayerProfileMgr
    c34v0 = c34v0:IsLoggedIn()
    if c34v0 then
      c34v0 = ObjectPortHandler
      c34v1 = gPlayerProfileMgr
      c34v3 = 0
      c34v1 = c34v1:GetPlayerProfile(c34v3)
      c34v1 = c34v1:GetGameSpecificData()
      c34v2 = "OnProfileSaved"
      c34v0(c34v1, c34v2)
    end
    c34v0 = mMovie
    c34v2 = "TargetStatus1"
    c34v3 = 12
    c34v4 = 0
    c34v0:SetNumberVariable(c34v2, c34v3, c34v4)
    c34v0 = mMovie
    c34v2 = "Marker1"
    c34v3 = 12
    c34v4 = 0
    c34v0:SetNumberVariable(c34v2, c34v3, c34v4)
    c34v0 = v123
    c34v0()
    c34v0 = mMovie
    c34v2 = "Teammate1"
    c34v3 = 13
    c34v4 = false
    c34v0:Name__d9713943(c34v2, c34v3, c34v4)
    c34v0 = mMovie
    c34v2 = "HintMessage"
    c34v3 = 12
    c34v4 = 0
    c34v0:SetNumberVariable(c34v2, c34v3, c34v4)
    c34v0 = mMovie
    c34v2 = "BossStatus"
    c34v3 = 12
    c34v4 = 0
    c34v0:SetNumberVariable(c34v2, c34v3, c34v4)
    c34v0 = v115
    c34v1 = v78
    c34v2 = "BossStatus"
    c34v0(c34v1, c34v2)
    c34v0 = v3
    c34v0 = c34v0.GetUIMode
    c34v0 = c34v0()
    c34v1 = v3
    c34v1 = c34v1.UI_MODE_IN_SPACE_SHIP
    if c34v0 == c34v1 then
      c34v1 = hudMaterial
      c34v3 = Lotus_Game.WIPE_DISTORT
      c34v4 = 0
      c34v1:SetParam(c34v3, c34v4)
      c34v1 = hudMaterial
      c34v3 = Lotus_Game.WIPE_SPEED
      c34v4 = 0
      c34v1:SetParam(c34v3, c34v4)
      c34v1 = hudFontMaterial
      c34v3 = Lotus_Game.WIPE_DISTORT
      c34v4 = 0
      c34v1:SetParam(c34v3, c34v4)
      c34v1 = hudFontMaterial
      c34v3 = Lotus_Game.WIPE_SPEED
      c34v4 = 0
      c34v1:SetParam(c34v3, c34v4)
    end
    c34v1 = v121
    c34v1()
    c34v2 = _T.BossStatusStack
    c34v1 = #c34v2
    c34v2 = 0
    if c34v2 < c34v1 then
      c34v1 = ipairs
      c34v2 = _T.BossStatusStack
      c34v1, c34v2, c34v3 = c34v1(c34v2)
      for __renovice_for_0_0, __renovice_for_0_1 in c34v1, c34v2, c34v3 do
        c34v6 = __renovice_for_0_1.Avatar
        c34v7 = __renovice_for_0_1.NumSegments
        c34v8 = __renovice_for_0_1.LevelOverride
        c34v9 = __renovice_for_0_1.HideLevel
        c34v10 = __renovice_for_0_1.ShowEnergy
        c34v11 = __renovice_for_0_1.HideInvuln
        c34v12 = v111
        c34v13 = v78
        c34v15 = false
        c34v16 = false
        c34v17 = nil
        c34v12(c34v13, c34v6, c34v7, c34v8, c34v9, c34v10, c34v11, c34v15, c34v16, c34v17)
      end
      c34v1 = _T
      c34v2 = nil
      c34v1.BossStatusStack = c34v2
    end
    c34v2 = _T.SecondBossStatusStack
    c34v1 = #c34v2
    c34v2 = 0
    if c34v2 < c34v1 then
      c34v1 = ipairs
      c34v2 = _T.SecondBossStatusStack
      c34v1, c34v2, c34v3 = c34v1(c34v2)
      for __renovice_for_1_0, __renovice_for_1_1 in c34v1, c34v2, c34v3 do
        c34v6 = v118
        c34v7 = __renovice_for_1_1.Avatar
        c34v8 = __renovice_for_1_1.NumSegments
        c34v9 = __renovice_for_1_1.LevelOverride
        c34v10 = __renovice_for_1_1.HideLevel
        c34v11 = __renovice_for_1_1.ShowEnergy
        c34v12 = __renovice_for_1_1.HideInvuln
        c34v13 = __renovice_for_1_1.SideBySideLayout
        c34v14 = __renovice_for_1_1.HideSecondName
        c34v6(c34v7, c34v8, c34v9, c34v10, c34v11, c34v12, c34v13, c34v14)
      end
      c34v1 = _T
      c34v2 = nil
      c34v1.SecondBossStatusStack = c34v2
    end
    c34v1 = _T
    c34v2 = v107
    c34v1.ResetHudHintPos = c34v2
    c34v1 = _T
    c34v2 = v106
    c34v1.SetHudHintPosWorld = c34v2
    c34v1 = _T
    c34v2 = v108
    c34v1.SetHudHintMessage = c34v2
    c34v1 = _T
    c34v2 = v112
    c34v1.SetupBossAvatar = c34v2
    c34v1 = _T
    c34v2 = v118
    c34v1.SetupSecondBossAvatar = c34v2
    c34v1 = _T
    c34v2 = v110
    c34v1.ForceBossInvulnerableHealthDisplay = c34v2
    c34v1 = _T
    c34v2 = v114
    c34v1.UpdateBossSuit = c34v2
    do return end
  end
  Initialize = v125
  v125 = function()
    local c35v0, c35v1
    c35v0 = v3
    c35v0 = c35v0.IsInHub
    c35v0 = c35v0()
    if c35v0 then
      c35v0 = true
      do return c35v0 end
    end
    c35v0 = v3
    c35v0 = c35v0.IsInGamePlay
    c35v0 = c35v0()
    if not c35v0 then
      c35v0 = true
      do return c35v0 end
    end
    local __renovice_local_0 = gGameRules
    c35v0 = IsNull
    c35v0 = c35v0(__renovice_local_0)
    if not c35v0 then
      local __renovice_state_0 = 4
      c35v0 = gGameRules
      c35v0 = c35v0:GetMission()
      __renovice_local_0 = c35v0.keyChainName
      c35v1 = v98
      if __renovice_local_0 == c35v1 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 5
      end
      if __renovice_state_0 == 5 then
        __renovice_local_0 = c35v0.keyChainName
        c35v1 = v99
        if __renovice_local_0 == c35v1 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        __renovice_local_0 = c35v0.keyChainName
        c35v1 = v101
        if __renovice_local_0 == c35v1 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        __renovice_local_0 = c35v0.keyChainName
        c35v1 = v100
        if __renovice_local_0 ~= c35v1 then
        else
          __renovice_state_0 = 8
        end
      end
      if __renovice_state_0 == 8 then
        __renovice_local_0 = true
        do return __renovice_local_0 end
      end
    end
    c35v0 = false
    do return c35v0 end
  end
  v126 = function()
    local c37v0, c37v1, c37v2, c37v3, c37v4, c37v5, c37v6, c37v7, c37v8, c37v9, c37v10, c37v11, c37v12, c37v13
    c37v0 = v42
    c37v0 = c37v0:GetFlashMarkers()
    v46 = c37v0
    c37v0 = v46[1]
    c37v1 = mMovie
    c37v3 = "Marker1"
    c37v1 = c37v1:GetMemberIndex(c37v3)
    c37v0.clipIndex = c37v1
    c37v2 = 1
    c37v3 = v46
    c37v0 = #c37v3
    c37v1 = 1
    for __renovice_for_0_0 = c37v2, c37v0, c37v1 do
      c37v4 = "Marker"
      c37v5 = tostring
      c37v5 = c37v5(__renovice_for_0_0)
      c37v3 = c37v4 .. c37v5
      c37v4 = 1
      if c37v4 < __renovice_for_0_0 then
        c37v4 = FlashMethod
        c37v5 = mMovie
        c37v6 = "Marker1.duplicateMovieClip"
        c37v8 = __renovice_for_0_0 + 50
        c37v4(c37v5, c37v6, c37v3, c37v8)
      end
      c37v4 = v82
      c37v5 = { LastArrowScreenX = -1, LastArrowScreenY = -1, Shape = 1, LastDamageFactor = 0 }
      c37v4[c37v3] = c37v5
      c37v4 = mMovie
      c37v4 = c37v4:GetMemberIndex(c37v3)
      c37v5 = v46[__renovice_for_0_0]
      c37v5.clipName = c37v3
      c37v5 = v81
      c37v6 = {}
      c37v5[c37v3] = c37v6
      c37v5 = v46[__renovice_for_0_0]
      c37v5.clipIndex = c37v4
      c37v5 = v46[__renovice_for_0_0]
      c37v6 = mMovie
      c37v10 = ".Marker.arrow"
      c37v8 = c37v3 .. c37v10
      c37v6 = c37v6:GetMemberIndex(c37v8)
      c37v5.arrowClipIndex = c37v6
      c37v5 = v46[__renovice_for_0_0]
      c37v6 = mMovie
      c37v10 = ".Marker.arrow.ArrowGraphic"
      c37v8 = c37v3 .. c37v10
      c37v6 = c37v6:GetMemberIndex(c37v8)
      c37v5.arrowImageClipIndex = c37v6
      c37v5 = v46[__renovice_for_0_0]
      c37v6 = mMovie
      c37v10 = ".Marker.ScanRange"
      c37v8 = c37v3 .. c37v10
      c37v6 = c37v6:GetMemberIndex(c37v8)
      c37v5.scanRangeClipIndex = c37v6
      c37v5 = v46[__renovice_for_0_0]
      c37v8 = ".Marker.Label.text"
      c37v6 = c37v3 .. c37v8
      c37v5.labelVarName = c37v6
      c37v5 = v46[__renovice_for_0_0]
      c37v6 = true
      c37v5.isNew = c37v6
      c37v5 = mMovie
      c37v8 = "Marker.StackCount"
      c37v9 = 12
      c37v10 = 0
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = "Marker.StackCountBackground"
      c37v9 = 13
      c37v10 = false
      c37v5:Makeposshield(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = "Marker.arrowOutline"
      c37v9 = 13
      c37v10 = false
      c37v5:Makeposshield(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = "Marker.MarkerOutline"
      c37v9 = 13
      c37v10 = false
      c37v5:Makeposshield(c37v3, c37v8, c37v9, c37v10)
      c37v5 = Engine.IsMobile
      c37v5 = c37v5()
      if c37v5 then
        c37v5 = v125
        c37v5 = c37v5()
        if c37v5 then
          c37v5 = mMovie
          c37v8 = "Marker"
          c37v9 = 5
          c37v10 = 175
          c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
          c37v5 = mMovie
          c37v8 = "Marker"
          c37v9 = 6
          c37v10 = 175
          c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
          c37v5 = mMovie
          c37v8 = "Marker.arrowOutline"
          c37v9 = 5
          c37v10 = 175
          c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
          c37v5 = mMovie
          c37v8 = "Marker.arrowOutline"
          c37v9 = 6
          c37v10 = 175
          c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
          c37v5 = mMovie
          c37v8 = "Marker.arrow"
          c37v9 = 5
          c37v10 = 175
          c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
          c37v5 = mMovie
          c37v8 = "Marker.arrow"
          c37v9 = 6
          c37v10 = 175
          c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
        end
      end
      c37v5 = v83.StackCount
      if c37v5 == nil then
        c37v5 = v83
        c37v6 = mMovie
        c37v10 = ".Marker.StackCount"
        c37v8 = c37v3 .. c37v10
        c37v9 = 1
        c37v6 = c37v6:GetNumberVariable(c37v8, c37v9)
        c37v5.StackCount = c37v6
        c37v5 = v83
        c37v6 = mMovie
        c37v10 = ".Marker.StackCountBackground"
        c37v8 = c37v3 .. c37v10
        c37v9 = 1
        c37v6 = c37v6:GetNumberVariable(c37v8, c37v9)
        c37v5.StackCountBackground = c37v6
        c37v5 = v83
        c37v6 = mMovie
        c37v10 = ".Marker.Label"
        c37v8 = c37v3 .. c37v10
        c37v9 = 1
        c37v6 = c37v6:GetNumberVariable(c37v8, c37v9)
        c37v5.Label = c37v6
        c37v5 = v83
        c37v6 = mMovie
        c37v10 = ".Marker.arrow.ArrowGraphic"
        c37v8 = c37v3 .. c37v10
        c37v9 = 1
        c37v6 = c37v6:GetNumberVariable(c37v8, c37v9)
        c37v5.ArrowGraphic = c37v6
      end
      c37v5 = mMovie
      c37v9 = ".Marker.CustomIcon"
      c37v7 = c37v3 .. c37v9
      c37v8 = markerIconMask
      c37v5:OverrideMaterial(c37v7, c37v8)
      c37v5 = mMovie
      c37v9 = ".NewBounds.Backer"
      c37v7 = c37v3 .. c37v9
      c37v9 = _G
      c37v9 = c37v9.UIMaterial_SpaceMarker
      c37v8 = c37v9[1]
      c37v5:OverrideMaterial(c37v7, c37v8)
      c37v5 = mMovie
      c37v8 = "NewBounds.Backer"
      c37v9 = 11
      c37v10 = v1
      c37v10 = c37v10.InterpolateColors
      c37v11 = _G
      c37v11 = c37v11.UIColor_Health
      c37v12 = _G
      c37v12 = c37v12.UIColor_Black
      c37v13 = 0.9
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10(c37v11, c37v12, c37v13))
      c37v5 = mMovie
      c37v8 = "NewBounds.Backer"
      c37v9 = 12
      c37v10 = enemyMarkerBackerAlpha
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v9 = ".NewBounds.Fill"
      c37v7 = c37v3 .. c37v9
      c37v9 = _G
      c37v9 = c37v9.UIMaterial_SpaceMarker
      c37v8 = c37v9[2]
      c37v5:OverrideMaterial(c37v7, c37v8)
      c37v5 = mMovie
      c37v8 = "NewBounds.Fill"
      c37v9 = 11
      c37v10 = _G
      c37v10 = c37v10.UIColor_White
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = "NewBounds.Fill"
      c37v9 = 12
      c37v10 = enemyMarkerFillAlpha
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v9 = ".NewBounds.Focused"
      c37v7 = c37v3 .. c37v9
      c37v9 = _G
      c37v9 = c37v9.UIMaterial_SpaceMarker
      c37v8 = c37v9[3]
      c37v5:OverrideMaterial(c37v7, c37v8)
      c37v5 = mMovie
      c37v9 = ".NewBounds.HitPulse"
      c37v7 = c37v3 .. c37v9
      c37v9 = _G
      c37v9 = c37v9.UIMaterial_SpaceMarker
      c37v8 = c37v9[2]
      c37v5:OverrideMaterial(c37v7, c37v8)
      c37v5 = mMovie
      c37v8 = "NewBounds.HitPulse"
      c37v9 = 11
      c37v10 = _G
      c37v10 = c37v10.UIColor_White
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = "NewBounds.HitPulse"
      c37v9 = 12
      c37v10 = 0
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v9 = ".NewBounds.HitPulse2"
      c37v7 = c37v3 .. c37v9
      c37v9 = _G
      c37v9 = c37v9.UIMaterial_SpaceMarker
      c37v8 = c37v9[2]
      c37v5:OverrideMaterial(c37v7, c37v8)
      c37v5 = mMovie
      c37v8 = "NewBounds.HitPulse2"
      c37v9 = 11
      c37v10 = _G
      c37v10 = c37v10.UIColor_White
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = "NewBounds.HitPulse2"
      c37v9 = 12
      c37v10 = 0
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = "EnemyStatus"
      c37v9 = 12
      c37v10 = 0
      c37v5:Name__52c1b74e(c37v3, c37v8, c37v9, c37v10)
      c37v5 = mMovie
      c37v8 = 13
      c37v9 = true
      c37v5:Name__378cc5c5(c37v4, c37v8, c37v9)
      c37v5 = ResetLineCount
      c37v6 = 0
      c37v5(c37v6)
    end
    c37v0 = _T
    c37v1 = function(c36v0)
      local c36v1, c36v2, c36v3, c36v4
      c36v3 = 1
      c36v4 = v46
      c36v1 = #c36v4
      c36v2 = 1
      for __renovice_for_0_0 = c36v3, c36v1, c36v2 do
        c36v4 = v46[__renovice_for_0_0]
        c36v4 = c36v4:Name__f90dc2bb()
        if c36v4 ~= c36v0 then
          continue
        end
        c36v4 = v46[__renovice_for_0_0]
        do return c36v4 end
      end
      do return end
    end
    c37v0.GetFlashMarker = c37v1
    do return end
  end
  v127 = function()
    local c38v0, c38v1, c38v2, c38v3
    local __renovice_state_0 = 0
    local __renovice_local_0 = v39
    c38v0 = IsNull
    c38v0 = c38v0(__renovice_local_0)
    if not c38v0 then
      __renovice_state_0 = 5
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c38v0 = mMovie
      c38v0 = c38v0:GetInstigator()
      v39 = c38v0
      __renovice_local_0 = v39
      c38v0 = IsNull
      c38v0 = c38v0(__renovice_local_0)
      if not c38v0 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c38v0 = false
      do return c38v0 end
    end
    if __renovice_state_0 == 3 then
      c38v0 = v39
      c38v0 = c38v0:GetMiniMap()
      v43 = c38v0
      __renovice_local_0 = v43
      c38v0 = IsNull
      c38v0 = c38v0(__renovice_local_0)
      if not c38v0 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c38v0 = nil
      v39 = c38v0
      c38v0 = false
      do return c38v0 end
    end
    if __renovice_state_0 == 5 then
      __renovice_local_0 = v38
      c38v0 = IsNull
      c38v0 = c38v0(__renovice_local_0)
      if not c38v0 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c38v0 = v39
      c38v0 = c38v0:CameraControl()
      v38 = c38v0
      __renovice_state_0 = 7
    end
    if __renovice_state_0 == 7 then
      c38v0 = nil
      c38v1 = v38
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v1)
      if __renovice_local_0 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      __renovice_local_0 = v38
      __renovice_local_0 = __renovice_local_0:Name__82f3f389()
      if not __renovice_local_0 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c38v1 = v38
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v1:GetCameraTarget())
      if __renovice_local_0 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      __renovice_local_0 = v38
      c38v0 = __renovice_local_0:GetCameraTarget()
      __renovice_local_0 = true
      v34 = __renovice_local_0
      __renovice_state_0 = 16
    end
    if __renovice_state_0 == 11 then
      __renovice_local_0 = v34
      if __renovice_local_0 then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      c38v1 = v40
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v1)
      if not __renovice_local_0 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      __renovice_local_0 = v39
      c38v0 = __renovice_local_0:GetAvatar()
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v0)
      if __renovice_local_0 then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      __renovice_local_0 = false
      v34 = __renovice_local_0
      __renovice_state_0 = 16
    end
    if __renovice_state_0 == 15 then
      __renovice_local_0 = v3
      __renovice_local_0 = __renovice_local_0.GetPlayerAvatar
      c38v1 = v39
      c38v2 = v40
      c38v0 = __renovice_local_0(c38v1, c38v2)
      __renovice_state_0 = 16
    end
    if __renovice_state_0 == 16 then
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v0)
      if not __renovice_local_0 then
        __renovice_state_0 = 18
      else
        __renovice_state_0 = 17
      end
    end
    if __renovice_state_0 == 17 then
      __renovice_local_0 = false
      do return __renovice_local_0 end
    end
    if __renovice_state_0 == 18 then
      __renovice_local_0 = v34
      if not __renovice_local_0 then
        __renovice_state_0 = 20
      else
        __renovice_state_0 = 19
      end
    end
    if __renovice_state_0 == 19 then
      c38v1 = v39
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v1:GetAvatar())
      if not __renovice_local_0 then
        __renovice_state_0 = 24
      else
        __renovice_state_0 = 20
      end
    end
    if __renovice_state_0 == 20 then
      __renovice_local_0 = v34
      if __renovice_local_0 then
        __renovice_state_0 = 34
      else
        __renovice_state_0 = 21
      end
    end
    if __renovice_state_0 == 21 then
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v0)
      if __renovice_local_0 then
        __renovice_state_0 = 34
      else
        __renovice_state_0 = 22
      end
    end
    if __renovice_state_0 == 22 then
      c38v1 = v40
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c38v1)
      if __renovice_local_0 then
        __renovice_state_0 = 24
      else
        __renovice_state_0 = 23
      end
    end
    if __renovice_state_0 == 23 then
      __renovice_local_0 = v40
      if __renovice_local_0 == c38v0 then
        __renovice_state_0 = 34
      else
        __renovice_state_0 = 24
      end
    end
    if __renovice_state_0 == 24 then
      __renovice_local_0 = c38v0:InventoryControl()
      c38v1 = IsNull
      c38v1 = c38v1(__renovice_local_0)
      if c38v1 then
        __renovice_state_0 = 27
      else
        __renovice_state_0 = 25
      end
    end
    if __renovice_state_0 == 25 then
      c38v3 = gLotusInventoryControllerType
      c38v1 = __renovice_local_0:IsA(c38v3)
      if not c38v1 then
        __renovice_state_0 = 27
      else
        __renovice_state_0 = 26
      end
    end
    if __renovice_state_0 == 26 then
      v41 = __renovice_local_0
      __renovice_state_0 = 27
    end
    if __renovice_state_0 == 27 then
      c38v2 = v41
      c38v1 = IsNull
      c38v1 = c38v1(c38v2)
      if not c38v1 then
        __renovice_state_0 = 29
      else
        __renovice_state_0 = 28
      end
    end
    if __renovice_state_0 == 28 then
      c38v1 = false
      do return c38v1 end
    end
    if __renovice_state_0 == 29 then
      c38v2 = v42
      c38v1 = IsNull
      c38v1 = c38v1(c38v2)
      if not c38v1 then
        __renovice_state_0 = 33
      else
        __renovice_state_0 = 30
      end
    end
    if __renovice_state_0 == 30 then
      c38v1 = v39
      c38v1 = c38v1:GetHudStatus()
      v42 = c38v1
      c38v2 = v42
      c38v1 = IsNull
      c38v1 = c38v1(c38v2)
      if not c38v1 then
        __renovice_state_0 = 32
      else
        __renovice_state_0 = 31
      end
    end
    if __renovice_state_0 == 31 then
      c38v1 = false
      do return c38v1 end
    end
    if __renovice_state_0 == 32 then
      c38v1 = v126
      c38v1()
      __renovice_state_0 = 33
    end
    if __renovice_state_0 == 33 then
      v40 = c38v0
      c38v2 = v40
      c38v2 = c38v2:GetMeshScale()
      c38v1 = 1 / c38v2
      v68 = c38v1
      __renovice_state_0 = 34
    end
    if __renovice_state_0 == 34 then
      __renovice_local_0 = mMovie
      __renovice_local_0 = __renovice_local_0:GetMovieWidth()
      v50 = __renovice_local_0
      __renovice_local_0 = mMovie
      __renovice_local_0 = __renovice_local_0:GetMovieHeight()
      v51 = __renovice_local_0
      __renovice_local_0 = Engine.IsConsole
      __renovice_local_0 = __renovice_local_0()
      if __renovice_local_0 then
        __renovice_state_0 = 36
      else
        __renovice_state_0 = 35
      end
    end
    if __renovice_state_0 == 35 then
      __renovice_local_0 = mMovie
      __renovice_local_0 = __renovice_local_0:GetViewportWidth()
      v50 = __renovice_local_0
      __renovice_local_0 = mMovie
      __renovice_local_0 = __renovice_local_0:GetViewportHeight()
      v51 = __renovice_local_0
      __renovice_state_0 = 36
    end
    if __renovice_state_0 == 36 then
      c38v1 = v60
      __renovice_local_0 = #c38v1
      if __renovice_local_0 ~= 0 then
        __renovice_state_0 = 39
      else
        __renovice_state_0 = 37
      end
    end
    if __renovice_state_0 == 37 then
      __renovice_local_0 = gRegion
      __renovice_local_0 = __renovice_local_0:GetHumanPlayers()
      v60 = __renovice_local_0
      __renovice_local_0 = {}
      v61 = __renovice_local_0
      c38v1 = v60
      __renovice_local_0 = #c38v1
      if __renovice_local_0 == 0 then
        __renovice_state_0 = 39
      else
        __renovice_state_0 = 38
      end
    end
    if __renovice_state_0 == 38 then
      __renovice_local_0 = gRegion
      c38v2 = "OnPlayersChanged"
      __renovice_local_0:Name__f3e0f198(c38v2)
      __renovice_state_0 = 39
    end
    if __renovice_state_0 == 39 then
      __renovice_local_0 = true
      do return __renovice_local_0 end
    end
    do return end
  end
  v128 = function()
    local c39v0, c39v1, c39v2, c39v3, c39v4, c39v5, c39v6, c39v7
    c39v1 = v41
    c39v0 = IsNull
    c39v0 = c39v0(c39v1)
    if c39v0 then
      c39v0 = false
      do return c39v0 end
    end
    c39v2 = 1
    c39v3 = v41
    c39v5 = 0
    c39v0 = c39v3:Name__d89f5371(c39v5)
    c39v1 = 1
    for __renovice_for_0_0 = c39v2, c39v0, c39v1 do
      c39v3 = v41
      c39v5 = __renovice_for_0_0 - 1
      c39v6 = 0
      c39v3 = c39v3:GetConsumableItem(c39v5, c39v6)
      c39v4 = IsNull
      c39v4 = c39v4(c39v3)
      if c39v4 then
        continue
      end
      c39v6 = v11
      c39v4 = c39v3:IsA(c39v6)
      if not c39v4 then
        c39v6 = v12
        c39v4 = c39v3:IsA(c39v6)
        if not c39v4 then
          continue
        end
      end
      c39v4 = v41
      c39v6 = __renovice_for_0_0 - 1
      c39v7 = 0
      c39v4 = c39v4:Name__dbeaa7d4(c39v6, c39v7)
      c39v5 = 0
      if not (c39v5 < c39v4) then
        continue
      end
      c39v5 = true
      do return c39v5 end
    end
    c39v0 = false
    do return c39v0 end
  end
  v129 = function(c40v0)
    local c40v1, c40v2, c40v3, c40v4, c40v5, c40v6, c40v7
    c40v1 = c40v0.arrowWasVisible
    c40v2 = c40v0.arrowVisible
    if c40v1 == c40v2 then
      c40v1 = c40v0.isNew
      if not c40v1 then
        do return end
      end
    end
    c40v1 = c40v0:Name__f90dc2bb()
    c40v2 = IsNull
    c40v2 = c40v2(c40v1)
    if c40v2 then
      do return end
    end
    c40v2 = c40v0.arrowWasVisible
    c40v3 = c40v0.arrowVisible
    if c40v2 == c40v3 then
      c40v2 = c40v1:IsClientVisible()
      if not c40v2 then
        do return end
      end
    end
    c40v2 = nil
    c40v3 = c40v0.arrowVisible
    if c40v3 then
      c40v2 = c40v1:Name__6078af56()
    else
      c40v2 = c40v1:Name__fe3dc951()
    end
    c40v3 = c40v0.pos
    c40v4 = gRegion
    c40v4 = c40v4:GetLocalPlayerAvatar()
    c40v5 = IsNull
    c40v5 = c40v5(c40v4)
    if not c40v5 then
      c40v5 = c40v4:InventoryControl()
      c40v6 = IsNull
      c40v6 = c40v6(c40v5)
      if not c40v6 then
        c40v6 = c40v5:GetOnBoardShip()
        c40v7 = IsNull
        c40v7 = c40v7(c40v6)
        if not c40v7 then
          c40v3 = c40v6:Name__d78eb127(c40v3)
        end
      end
    end
    c40v5 = v1
    c40v5 = c40v5.PlaySound
    c40v5(c40v2, c40v3)
    do return end
  end
  v130 = function(c41v0, c41v1, c41v2)
    local c41v3, c41v4, c41v5, c41v6, c41v7, c41v8, c41v9, c41v10
    c41v3 = true
    c41v4 = c41v0.markerType
    c41v5 = 37
    if c41v4 ~= c41v5 then
      c41v3 = c41v0.showBoundingArrows
    end
    c41v5 = c41v0.markerType
    c41v6 = 105
    if c41v5 ~= c41v6 then
      c41v4 = false
    else
      c41v4 = true
    end
    if c41v1 == nil then
      c41v5 = v82
      c41v6 = c41v0.clipName
      c41v1 = c41v5[c41v6]
    end
    if c41v2 == nil then
      c41v5 = v41
      c41v5 = c41v5:GetOnBoardShip()
      c41v7 = IsNull
      c41v7 = c41v7(c41v5)
      c41v6 = not c41v7
      if c41v6 then
        c41v8 = v40
        c41v9 = true
        c41v10 = false
        c41v6 = c41v5:IsUsingShipEmplacement(c41v8, c41v9, c41v10)
      end
      c41v2 = c41v6
    end
    c41v5 = true
    if c41v3 then
      c41v6 = c41v1.IsEmplacementMarker
      if c41v6 then
        c41v7 = v40
        c41v6 = IsNull
        c41v6 = c41v6(c41v7)
        if not c41v6 then
          c41v6 = v40
          c41v6 = c41v6:IsAttached()
          if c41v6 then
            c41v5 = not c41v2
          end
        end
      end
    end
    if c41v4 then
      c41v8 = v40
      c41v7 = IsNull
      c41v7 = c41v7(c41v8)
      c41v6 = not c41v7
      if c41v6 then
        c41v6 = v40
        c41v8 = v4
        c41v8 = c41v8.sSkillLootPOIMarker
        c41v6 = c41v6:Name__5fc56f80(c41v8)
        if c41v6 then
          c41v7 = v40
          c41v7 = c41v7:InventoryControl()
          c41v7 = c41v7:Name__fc529b76()
          c41v6 = c41v7 or c41v2
        end
      end
      c41v5 = c41v6
    end
    do return c41v5 end
  end
  v131 = function(c46v0)
    local c46v1, c46v2, c46v3, c46v4, c46v5, c46v6, c46v7, c46v8, c46v9, c46v10, c46v11, c46v12, c46v13, c46v14, c46v15, c46v16, c46v17, c46v18, c46v19, c46v20, c46v21, c46v22, c46v23, c46v24, c46v25, c46v26, c46v27, c46v28, c46v29, c46v30, c46v31, c46v32, c46v33, c46v34, c46v35, c46v36, c46v37, c46v38, c46v39, c46v40, c46v41, c46v42, c46v43, c46v44, c46v45, c46v46, c46v47, c46v48, c46v49, c46v50, c46v51, c46v52, c46v53, c46v54, c46v55, c46v56, c46v57, c46v58, c46v59, c46v60
    c46v19 = nil
    c46v20 = c46v19.garbage
    c46v21 = c46v19.clipName
    c46v20 = IsNull
    c46v20 = c46v20(c46v21)
    c46v22 = v82
    c46v23 = c46v19.clipName
    c46v21 = c46v22[c46v23]
    c46v20 = IsNull
    c46v20 = c46v20(c46v21)
    c46v30 = true
    v47 = c46v30
    c46v24 = c46v19:Name__f90dc2bb()
    c46v30 = IsNull
    c46v30 = c46v30(c46v24)
    c46v25 = not c46v30
    c46v23.markerWPtr = c46v24
    c46v30 = c46v24:GetAttachParent()
    c46v31 = IsNull
    c46v31 = c46v31(c46v30)
    c46v33 = gBaseAvatarType
    c46v31 = c46v30:IsA(c46v33)
    c46v23.parentAvatar = c46v30
    c46v26 = c46v30
    c46v27 = true
    c46v29 = false
    c46v28 = nil
    c46v31 = nil
    c46v23.parentDeco = c46v31
    c46v33 = v26
    c46v31 = c46v24:IsA(c46v33)
    c46v32 = v39
    c46v31 = IsNull
    c46v31 = c46v31(c46v32)
    c46v31 = IsNull
    c46v31 = c46v31(c46v30)
    c46v33 = gLotusSentinelAvatarType
    c46v31 = c46v30:IsA(c46v33)
    c46v31 = c46v30:GetCreatorAvatar()
    c46v32 = IsNull
    c46v32 = c46v32(c46v31)
    c46v32 = v39
    c46v32 = c46v32:GetOwnedPowerSuitAvatar()
    c46v24:Disable()
    c46v30 = c46v26:Name__da68be10()
    c46v32 = false
    c46v26:Name__f4fd6ad6(c46v32)
    c46v24 = c46v23.markerWPtr
    c46v30 = IsNull
    c46v30 = c46v30(c46v24)
    c46v25 = not c46v30
    c46v26 = c46v23.parentAvatar
    c46v30 = IsNull
    c46v30 = c46v30(c46v26)
    c46v27 = not c46v30
    c46v28 = c46v23.parentDeco
    c46v30 = IsNull
    c46v30 = c46v30(c46v28)
    c46v29 = not c46v30
    c46v30 = v130
    c46v14 = nil
    c46v30 = c46v30(c46v19, c46v23, c46v14)
    c46v31 = v129
    c46v31(c46v19)
    c46v36 = c46v23.LastArrowScreenX
    c46v7 = nil
    c46v35 = c46v36 - c46v7
    c46v34 = math.abs
    c46v34 = c46v34(c46v35)
    c46v35 = 0.75
    c46v36 = c46v23.LastArrowScreenY
    c46v8 = nil
    c46v35 = c46v36 - c46v8
    c46v34 = math.abs
    c46v34 = c46v34(c46v35)
    c46v35 = 0.75
    c46v34 = v1
    c46v34 = c46v34.GetAngleBetweenPoints
    c46v9 = nil
    c46v10 = nil
    c46v3 = c46v34(c46v9, c46v8, c46v7, c46v10)
    c46v34 = mMovie
    c46v36 = c46v19.arrowClipIndex
    c46v37 = 16
    c46v38 = v1
    c46v38 = c46v38.ToDeg
    c46v34:SetNumberMember(c46v36, c46v37, c46v38(c46v3))
    c46v34 = mMovie
    c46v37 = "Marker.arrowOutline"
    c46v38 = 16
    local __renovice_local_0 = v1
    __renovice_local_0 = __renovice_local_0.ToDeg
    c46v34:Name__52c1b74e(c46v22, c46v37, c46v38, __renovice_local_0(c46v3))
    c46v23.LastArrowScreenX = c46v7
    c46v23.LastArrowScreenY = c46v8
    c46v36 = c46v24:IsClientVisible()
    c46v36 = c46v19.stackCount
    c46v37 = 0
    c46v38 = mMovie
    local __renovice_local_1 = "Marker.StackCount"
    c46v39 = 36
    c46v41 = "x"
    c46v42 = c46v19.stackCount
    c46v40 = c46v41 .. c46v42
    c46v38:Name__f4a9016a(c46v22, __renovice_local_1, c46v39, c46v40)
    c46v38 = mMovie
    __renovice_local_1 = "Marker.StackCount"
    c46v39 = 12
    c46v40 = 100
    c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
    local __renovice_state_0 = 1
    c46v38 = c46v19.stackCount
    __renovice_local_0 = 1
    for __renovice_for_0_0 = __renovice_state_0, c46v38, __renovice_local_0 do
      c46v39 = "StackBacker"
      __renovice_local_1 = c46v39 .. __renovice_for_0_0
      c46v39 = c46v36.Stacks
      if c46v39 <= __renovice_for_0_0 then
        c46v39 = FlashMethod
        c46v40 = mMovie
        c46v43 = ".Marker.marker.duplicateMovieClip"
        c46v41 = c46v22 .. c46v43
        c46v43 = __renovice_for_0_0 + 1
        c46v39(c46v40, c46v41, __renovice_local_1, c46v43)
        c46v39 = FlashMethod
        c46v40 = mMovie
        c46v43 = ".Marker.CustomIcon.swapDepths"
        c46v41 = c46v22 .. c46v43
        c46v42 = 150
        c46v39(c46v40, c46v41, c46v42)
        c46v39 = c46v19.stackCount
        if __renovice_for_0_0 == c46v39 then
          c46v39 = __renovice_for_0_0 - 1
          c46v35 = c46v39 * -3
        end
      end
      c46v39 = mMovie
      c46v43 = ".Marker."
      c46v41 = c46v22 .. c46v43 .. __renovice_local_1
      c46v42 = 1
      c46v44 = __renovice_for_0_0 - 1
      c46v43 = c46v44 * -3
      c46v39:SetNumberVariable(c46v41, c46v42, c46v43)
    end
    c46v38 = -3
    __renovice_state_0 = c46v36.Stacks
    __renovice_local_0 = __renovice_state_0 - 1
    c46v35 = c46v38 * __renovice_local_0
    c46v38 = mMovie
    __renovice_local_1 = "Marker.CustomIcon"
    c46v39 = 1
    c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v35)
    __renovice_local_0 = c46v24:Name__31380224()
    __renovice_local_0 = mMovie
    __renovice_local_1 = c46v19.clipIndex
    c46v39 = 12
    c46v40 = 0
    __renovice_local_0:SetNumberMember(__renovice_local_1, c46v39, c46v40)
    __renovice_local_0 = false
    c46v19.clientWasVisible = __renovice_local_0
    __renovice_local_0 = v48
    __renovice_state_0 = v49
    __renovice_local_0 = c46v19.isNew
    __renovice_local_0 = c46v19.clientWasVisible
    __renovice_local_0 = c46v23.BaseAlpha
    __renovice_local_0 = mMovie
    __renovice_local_1 = c46v19.clipIndex
    c46v39 = 12
    c46v41 = v1
    c46v41 = c46v41.Ternary
    c46v42 = c46v19.visibleWhileAiming
    c46v43 = 1
    c46v44 = v48
    c46v41 = c46v41(c46v42, c46v43, c46v44)
    c46v40 = c46v38 * c46v41
    __renovice_local_0:SetNumberMember(__renovice_local_1, c46v39, c46v40)
    c46v23.BaseAlpha = c46v38
    __renovice_local_0 = true
    c46v19.clientWasVisible = __renovice_local_0
    __renovice_local_0 = mMovie
    __renovice_local_1 = c46v19.clipIndex
    __renovice_local_0:Name__b01aaf6c(__renovice_local_1, c46v7, c46v8)
    __renovice_local_0 = mMovie
    __renovice_local_1 = c46v19.clipIndex
    __renovice_local_0:Name__b01aaf6c(__renovice_local_1, c46v7, c46v8)
    __renovice_local_0 = v48
    __renovice_state_0 = v49
    __renovice_local_0 = c46v19.isNew
    __renovice_local_0 = c46v19.clientWasVisible
    __renovice_local_0 = c46v23.BaseAlpha
    __renovice_local_0 = mMovie
    __renovice_local_1 = c46v19.clipIndex
    c46v39 = 12
    c46v41 = v1
    c46v41 = c46v41.Ternary
    c46v42 = c46v19.visibleWhileAiming
    c46v43 = 1
    c46v44 = v48
    c46v41 = c46v41(c46v42, c46v43, c46v44)
    c46v40 = c46v38 * c46v41
    __renovice_local_0:SetNumberMember(__renovice_local_1, c46v39, c46v40)
    c46v23.BaseAlpha = c46v38
    __renovice_local_0 = true
    c46v19.clientWasVisible = __renovice_local_0
    c46v36 = false
    c46v19.clientWasVisible = c46v36
    c46v36 = mMovie
    c46v38 = c46v19.clipIndex
    __renovice_local_0 = 12
    __renovice_state_0 = 0
    c46v36:SetNumberMember(c46v38, __renovice_local_0, __renovice_state_0)
    c46v38 = c46v24:GetShowDistance()
    c46v38 = c46v23.ShowingStatus
    c46v38 = c46v19.isNew
    c46v38 = 1
    c46v23.Shape = c46v38
    c46v38 = c46v24:IsScannerRequired()
    c46v38 = v128
    c46v38 = c46v38()
    c46v38 = mMovie
    __renovice_state_0 = c46v19.labelVarName
    __renovice_local_1 = "/Lotus/Language/Game/ScannerRequired"
    c46v39 = true
    c46v38:SetLocalized(__renovice_state_0, __renovice_local_1, c46v39)
    c46v38 = mMovie
    __renovice_state_0 = c46v19.labelVarName
    __renovice_local_1 = c46v19.labelLocTag
    c46v39 = true
    c46v38:SetLocalized(__renovice_state_0, __renovice_local_1, c46v39)
    c46v2 = c46v19:GetContextIcon()
    c46v38 = IsNull
    c46v38 = c46v38(c46v2)
    local __renovice_local_2 = c46v19.markerType
    c46v38 = 6
    c46v2 = forcedMarkerIcons[1]
    c46v38 = 7
    c46v38 = 12
    c46v2 = forcedMarkerIcons[2]
    c46v38 = v7
    c46v38 = c46v38.GetObjProgressBarTracker
    c46v38 = c46v38()
    __renovice_local_0 = c46v38.Data
    __renovice_local_0 = __renovice_local_0.Progress
    c46v2 = markerExtractionEnemiesIcon
    __renovice_local_1 = 2
    c46v24:Name__d2a7f80e(__renovice_local_1)
    c46v24:StopPulseColor()
    __renovice_local_1 = 18
    c46v24:Name__d2a7f80e(__renovice_local_1)
    c46v38 = 0
    c46v2 = c46v24:GetFillIcon()
    c46v1 = c46v2
    c46v1 = c46v19:GetBackerIcon()
    __renovice_local_1 = playerMarkerType
    __renovice_local_0 = c46v24:IsA(__renovice_local_1)
    __renovice_local_0 = c46v24:GetOwnerPlayer()
    __renovice_state_0 = v39
    __renovice_state_0 = c46v24:MarkerType()
    __renovice_local_1 = ipairs
    c46v39 = playerMarkerBackerWhitelist
    __renovice_local_1, c46v39, c46v40 = __renovice_local_1(c46v39)
    __renovice_local_1 = v20
    __renovice_local_0 = c46v24:IsA(__renovice_local_1)
    __renovice_local_0 = 2
    c46v23.Shape = __renovice_local_0
    __renovice_local_1 = v21
    __renovice_local_0 = c46v24:IsA(__renovice_local_1)
    __renovice_local_0 = 3
    c46v23.Shape = __renovice_local_0
    __renovice_local_0 = 1
    c46v23.Shape = __renovice_local_0
    __renovice_local_1 = ""
    c46v39 = c46v24:Name__6b7fc60e()
    c46v40 = mMovie
    c46v43 = "Bounds.FillContainer.Fill"
    c46v44 = 11
    c46v40:Name__52c1b74e(c46v22, c46v43, c46v44, c46v39)
    c46v40 = mMovie
    c46v43 = "Bounds.FillContainer.Fill"
    c46v44 = 12
    c46v45 = 75
    c46v40:Name__52c1b74e(c46v22, c46v43, c46v44, c46v45)
    c46v40 = mMovie
    c46v44 = ".Bounds.FillContainer.Fill"
    c46v42 = c46v22 .. c46v44
    c46v43 = "AlphaTestThreshold"
    c46v44 = 1
    c46v45 = 0
    c46v46 = 0
    c46v47 = 0
    c46v40:Name__e243d995(c46v42, c46v43, c46v44, c46v45, c46v46, c46v47)
    c46v40 = _T.HideEnemyLevelsInHUD
    c46v40 = c46v26:GetCurrentLevel()
    c46v41 = mMovie
    c46v45 = ".EnemyStatus.Name"
    c46v43 = c46v22 .. c46v45
    c46v44 = 1
    c46v45 = -34
    c46v41:SetNumberVariable(c46v43, c46v44, c46v45)
    c46v41 = mMovie
    c46v45 = ".EnemyStatus.LevelStatus.Level"
    c46v43 = c46v22 .. c46v45
    c46v44 = 36
    c46v41:SetStringVariable(c46v43, c46v44, c46v40)
    c46v41 = mMovie
    c46v45 = ".EnemyStatus.LevelStatus"
    c46v43 = c46v22 .. c46v45
    c46v44 = 13
    c46v45 = true
    c46v41:Name__d9713943(c46v43, c46v44, c46v45)
    c46v40 = mMovie
    c46v44 = ".EnemyStatus.LevelStatus"
    c46v42 = c46v22 .. c46v44
    c46v43 = 13
    c46v44 = false
    c46v40:Name__d9713943(c46v42, c46v43, c46v44)
    c46v40 = mMovie
    c46v44 = ".EnemyStatus.Name"
    c46v42 = c46v22 .. c46v44
    c46v43 = 36
    c46v40:SetStringVariable(c46v42, c46v43, __renovice_local_1)
    __renovice_local_1 = mMovie
    c46v42 = ".Bounds.FillContainer.Fill"
    c46v40 = c46v22 .. c46v42
    c46v41 = "RectEdgeColor"
    c46v42 = _G
    c46v42 = c46v42.UIColorObject_White
    c46v42 = c46v42.r
    c46v43 = _G
    c46v43 = c46v43.UIColorObject_White
    c46v43 = c46v43.g
    c46v44 = _G
    c46v44 = c46v44.UIColorObject_White
    c46v44 = c46v44.b
    c46v45 = 0.75
    __renovice_local_1:Name__e243d995(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45)
    __renovice_local_1 = mMovie
    c46v42 = ".Bounds.FillContainerInner.Fill"
    c46v40 = c46v22 .. c46v42
    c46v41 = "RectEdgeColor"
    c46v42 = _G
    c46v42 = c46v42.UIColorObject_White
    c46v42 = c46v42.r
    c46v43 = _G
    c46v43 = c46v43.UIColorObject_White
    c46v43 = c46v43.g
    c46v44 = _G
    c46v44 = c46v44.UIColorObject_White
    c46v44 = c46v44.b
    c46v45 = 0.75
    __renovice_local_1:Name__e243d995(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45)
    __renovice_local_1 = nil
    c46v23.FillPct = __renovice_local_1
    __renovice_local_1 = nil
    c46v23.PrevProgress = __renovice_local_1
    __renovice_local_1 = nil
    c46v23.LastHealthPct = __renovice_local_1
    __renovice_local_1 = nil
    c46v23.LastLockOnFrame = __renovice_local_1
    __renovice_local_1 = nil
    c46v23.PrevAwareness = __renovice_local_1
    __renovice_local_1 = nil
    c46v23.ShowingStatus = __renovice_local_1
    c46v31 = true
    __renovice_local_0 = mMovie
    c46v39 = "Marker.CustomIcon"
    c46v40 = 12
    c46v41 = 100
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.MarkerOutline"
    c46v40 = 12
    c46v41 = 100
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.marker"
    c46v40 = 12
    c46v41 = 100
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = 0
    c46v23.LastDamageFactor = __renovice_local_0
    __renovice_local_0 = nil
    c46v23.Color = __renovice_local_0
    __renovice_local_0 = mMovie
    c46v39 = "Marker.CustomIcon"
    c46v40 = 0
    c46v41 = 0
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.CustomIcon"
    c46v40 = 1
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v38)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.MarkerOutline"
    c46v40 = 0
    c46v41 = 0
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.MarkerOutline"
    c46v40 = 1
    c46v41 = 0
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v40 = ".Marker.CustomIcon"
    __renovice_local_1 = c46v22 .. c46v40
    c46v39 = "AlphaTestThreshold"
    c46v40 = 1
    c46v41 = 0
    c46v42 = 0
    c46v43 = 0
    __renovice_local_0:Name__e243d995(__renovice_local_1, c46v39, c46v40, c46v41, c46v42, c46v43)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.marker"
    c46v40 = 0
    c46v41 = 0
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.marker"
    c46v40 = 1
    c46v41 = 0
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.ScanRange"
    c46v40 = 0
    c46v41 = -40
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.ScanRange"
    c46v40 = 1
    c46v41 = v1
    c46v41 = c46v41.Ternary
    c46v43 = 30
    c46v44 = 17
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41(c46v21, c46v43, c46v44))
    __renovice_local_0 = v1
    __renovice_local_0 = __renovice_local_0.Ternary
    __renovice_state_0 = c46v19.arrowVisible
    __renovice_local_1 = v1
    __renovice_local_1 = __renovice_local_1.Ternary
    c46v40 = fillMarkerAlpha
    c46v41 = 100
    __renovice_local_1 = __renovice_local_1(c46v33, c46v40, c46v41)
    c46v39 = 0
    __renovice_local_0 = __renovice_local_0(__renovice_state_0, __renovice_local_1, c46v39)
    __renovice_state_0 = mMovie
    c46v39 = c46v19.arrowClipIndex
    c46v40 = 12
    __renovice_state_0:SetNumberMember(c46v39, c46v40, __renovice_local_0)
    __renovice_state_0 = mMovie
    c46v40 = "Marker.arrowOutline"
    c46v41 = 12
    __renovice_state_0:Name__52c1b74e(c46v22, c46v40, c46v41, __renovice_local_0)
    __renovice_state_0 = false
    c46v19.isNew = __renovice_state_0
    c46v44 = c46v23.LastShieldPct
    c46v44 = c46v23.LastRatio
    c46v44 = c46v23.LastShieldPct
    c46v44 = 1
    c46v44 = c46v23.LastShieldPct
    c46v45 = 1
    c46v44 = 1
    c46v44 = c46v23.LastShieldPct
    c46v45 = 1
    __renovice_local_1 = ""
    c46v40 = v76
    c46v39 = IsNull
    c46v39 = c46v39(c46v40)
    c46v40 = v75
    c46v41 = v76
    c46v39 = c46v40[c46v41]
    c46v39 = c46v39.mAvatar
    c46v39 = c46v23.ShowingStatus
    c46v39 = c46v26:Name__da68be10()
    c46v39 = true
    c46v23.ShowingStatus = c46v39
    c46v39 = mMovie
    c46v43 = ".EnemyStatus"
    c46v41 = c46v22 .. c46v43
    c46v39:EnablePfdeco(c46v41)
    c46v39 = mMovie
    c46v42 = "EnemyStatus"
    c46v43 = 12
    c46v44 = 100
    c46v39:Name__52c1b74e(c46v22, c46v42, c46v43, c46v44)
    c46v40 = v75
    c46v41 = v76
    c46v39 = c46v40[c46v41]
    c46v39 = c46v39.mDeco
    c46v39 = c46v28:IsAttached()
    c46v39 = c46v23.ShowingStatus
    c46v39 = c46v28:Name__55580a2e()
    c46v39 = true
    c46v23.ShowingStatus = c46v39
    c46v39 = mMovie
    c46v43 = ".EnemyStatus"
    c46v41 = c46v22 .. c46v43
    c46v39:EnablePfdeco(c46v41)
    c46v39 = mMovie
    c46v42 = "EnemyStatus"
    c46v43 = 12
    c46v44 = 100
    c46v39:Name__52c1b74e(c46v22, c46v42, c46v43, c46v44)
    c46v39 = v70
    __renovice_local_1 = c46v26:GetUIName()
    c46v39 = c46v26:DamageControl()
    c46v42 = 1
    c46v43 = v32
    c46v40 = #c46v43
    c46v41 = 1
    __renovice_local_0 = c46v19.stackCount
    __renovice_state_0 = 0
    __renovice_local_0 = c46v24:HasMarkerSpawnEffect()
    __renovice_local_0 = c46v24:IsClientVisible()
    __renovice_local_0 = v7
    __renovice_local_0 = __renovice_local_0.GetObjProgressBarTracker
    __renovice_local_0 = __renovice_local_0()
    __renovice_state_0 = __renovice_local_0.Data
    __renovice_state_0 = __renovice_state_0.Progress
    __renovice_local_1 = c46v19.screenSquare
    c46v39 = 0
    c46v40 = 0
    c46v41 = c46v19.screenSpacePos
    c46v41 = c46v41.z
    c46v42 = 0
    c46v41 = c46v19.showBoundingArrows
    c46v41 = gRegion
    c46v41 = c46v41:GetGameCamera()
    c46v42 = v1
    c46v42 = c46v42.GetScreenParticlesCoord
    c46v43 = mMovie
    c46v44 = c46v7 + c46v39
    c46v46 = c46v8 + c46v35
    c46v45 = c46v46 + c46v40
    c46v42, c46v43 = c46v42(c46v43, c46v44, c46v45, c46v41)
    c46v44 = v80[c46v22]
    c46v46 = Vector
    c46v48 = v54
    c46v47 = c46v42 * c46v48
    c46v49 = v54
    c46v48 = c46v43 * c46v49
    c46v49 = 1
    c46v46 = c46v46(c46v47, c46v48, c46v49)
    c46v47 = ZERO_ROTATION
    c46v44:Name__967d219d(c46v46, c46v47)
    c46v31 = IsNull
    c46v31 = c46v31(c46v30)
    if not c46v31 then
      c46v33 = gDecorationType
      c46v31 = c46v30:IsA(c46v33)
      if c46v31 then
        c46v23.parentDeco = c46v30
        c46v28 = c46v30
        c46v29 = true
        c46v27 = false
        c46v26 = nil
        c46v31 = nil
        c46v23.parentAvatar = c46v31
      end
    end
    if c46v29 then
      c46v30 = c46v28:Name__55580a2e()
      if not c46v30 then
        c46v32 = true
        c46v28:Name__4dc57d05(c46v32)
      end
    end
    c46v38 = c46v23.DistanceToEye
    if c46v38 ~= -1 then
      c46v38 = mMovie
      __renovice_state_0 = c46v19.scanRangeClipIndex
      __renovice_local_1 = 36
      c46v39 = ""
      c46v38:SetStringMember(__renovice_state_0, __renovice_local_1, c46v39)
      c46v38 = mMovie
      __renovice_local_1 = "EnemyStatus.Distance"
      c46v39 = 36
      c46v40 = ""
      c46v38:Name__f4a9016a(c46v22, __renovice_local_1, c46v39, c46v40)
      c46v38 = -1
      c46v23.DistanceToEye = c46v38
    end
    c46v38 = 11
    if __renovice_local_2 == c46v38 then
      c46v2 = forcedMarkerIcons[3]
    else
      c46v38 = 4
      if __renovice_local_2 == c46v38 then
        c46v2 = forcedMarkerIcons[4]
      end
    end
    if c46v29 then
      c46v40 = v70
      if c46v40 then
        c46v40 = mMovie
        c46v44 = ".EnemyStatus.LevelStatus"
        c46v42 = c46v22 .. c46v44
        c46v43 = 13
        c46v44 = false
        c46v40:Name__d9713943(c46v42, c46v43, c46v44)
        c46v40 = mMovie
        c46v44 = ".EnemyStatus.Name"
        c46v42 = c46v22 .. c46v44
        c46v43 = 1
        c46v44 = -18
        c46v40:SetNumberVariable(c46v42, c46v43, c46v44)
        c46v40 = mMovie
        c46v42 = c46v28:GetLocTag()
        c46v42 = c46v42:c_str()
        c46v43 = false
        __renovice_local_1 = c46v40:GetLocalized(c46v42, c46v43)
        c46v40 = mMovie
        c46v44 = ".EnemyStatus.Name"
        c46v42 = c46v22 .. c46v44
        c46v43 = 46
        c46v44 = "bottom"
        c46v40:SetStringVariable(c46v42, c46v43, c46v44)
      end
    end
    __renovice_local_1 = c46v24:GetProgress()
    c46v39 = c46v23.PrevProgress
    if __renovice_local_1 ~= c46v39 then
      c46v23.PrevProgress = __renovice_local_1
      c46v39 = mMovie
      c46v43 = ".NewBounds.Fill"
      c46v41 = c46v22 .. c46v43
      c46v42 = "SectionPointsBase"
      c46v44 = 1
      c46v45 = 1
      c46v46 = 0
      c46v39:Name__e243d995(c46v41, c46v42, __renovice_local_1, c46v44, c46v45, c46v46)
      c46v39 = mMovie
      c46v42 = "Marker.MarkerOutline"
      c46v43 = 11
      c46v39:Name__52c1b74e(c46v22, c46v42, c46v43, __renovice_local_0)
      c46v39 = mMovie
      c46v42 = "Marker.marker"
      c46v43 = 11
      c46v39:Name__52c1b74e(c46v22, c46v42, c46v43, __renovice_local_0)
      c46v39 = mMovie
      c46v42 = "NewBounds.Fill"
      c46v43 = 11
      c46v39:Name__52c1b74e(c46v22, c46v42, c46v43, __renovice_local_0)
    end
    c46v44 = c46v23.LastDamageFactor
    if c46v43 ~= c46v44 then
      c46v23.LastDamageFactor = c46v43
    end
    c46v39 = c46v23.ShowingStatus
    if c46v39 then
      c46v40 = v75
      c46v41 = v76
      c46v39 = c46v40[c46v41]
      c46v39 = c46v39.mAvatar
      if c46v39 ~= c46v26 then
        c46v40 = v75
        c46v41 = v76
        c46v39 = c46v40[c46v41]
        c46v39 = c46v39.mDeco
        if c46v39 ~= c46v28 then
          c46v39 = false
          c46v23.ShowingStatus = c46v39
          c46v39 = FlashInterpolate
          c46v40 = mMovie
          c46v43 = ".EnemyStatus"
          c46v41 = c46v22 .. c46v43
          c46v42 = 0
          c46v44 = 12
          c46v43 = {c46v44}
          c46v45 = 0
          c46v44 = {c46v45}
          c46v45 = 1
          c46v46 = 0.3
          c46v47 = function()
            local c42v0, c42v1
            c42v0 = c46v23
            c42v1 = nil
            c42v0.ShowingStatus = c42v1
            do return end
          end
          c46v39(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45, c46v46, c46v47)
        end
      end
    end
    c46v39 = c46v23.ShowingStatus
    if c46v39 then
      c46v39 = false
      c46v23.ShowingStatus = c46v39
      c46v39 = FlashInterpolate
      c46v40 = mMovie
      c46v43 = ".EnemyStatus"
      c46v41 = c46v22 .. c46v43
      c46v42 = 0
      c46v44 = 12
      c46v43 = {c46v44}
      c46v45 = 0
      c46v44 = {c46v45}
      c46v45 = 1
      c46v46 = 0.3
      c46v47 = function()
        local c43v0, c43v1
        c43v0 = c46v23
        c43v1 = nil
        c43v0.ShowingStatus = c43v1
        do return end
      end
      c46v39(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45, c46v46, c46v47)
    end
    c46v41 = IsNull
    c46v41 = c46v41(c46v24:GetAttachParent())
    if not c46v41 then
      c46v41 = Clamp
      c46v44 = __renovice_local_1:MinX()
      c46v43 = c46v44 - c46v7
      c46v42 = c46v43 * 1.4
      c46v43 = -64
      c46v44 = -10
      c46v41 = c46v41(c46v42, c46v43, c46v44)
      c46v42 = Clamp
      c46v45 = __renovice_local_1:MinY()
      c46v44 = c46v45 - c46v8
      c46v43 = c46v44 * 1.4
      c46v44 = -64
      c46v45 = -10
      c46v42 = c46v42(c46v43, c46v44, c46v45)
      c46v43 = Clamp
      c46v46 = __renovice_local_1:MaxX()
      c46v45 = c46v46 - c46v7
      c46v44 = c46v45 * 1.4
      c46v45 = 10
      c46v46 = 64
      c46v43 = c46v43(c46v44, c46v45, c46v46)
      c46v44 = Clamp
      c46v47 = __renovice_local_1:MaxY()
      c46v46 = c46v47 - c46v8
      c46v45 = c46v46 * 1.4
      c46v46 = 10
      c46v47 = 64
      c46v44 = c46v44(c46v45, c46v46, c46v47)
      c46v47 = math.abs
      c46v47 = c46v47(c46v41)
      c46v46 = c46v43 + c46v47
      c46v45 = c46v46 / 2
      c46v39 = c46v43 - c46v45
      c46v47 = math.abs
      c46v47 = c46v47(c46v42)
      c46v46 = c46v44 + c46v47
      c46v45 = c46v46 / 2
      c46v40 = c46v44 - c46v45
    end
    __renovice_local_1 = v80[c46v22]
    if __renovice_local_1 ~= nil then
      __renovice_local_1 = v80
      c46v39 = nil
      __renovice_local_1[c46v22] = c46v39
    end
    c46v15 = nil
    c46v16 = nil
    c46v17 = nil
    for __renovice_for_1_0, __renovice_for_1_1 in c46v15, c46v16, c46v17 do
      do return end
    end
    c46v20 = true
    c46v21 = c46v19.markerType
    c46v22 = 37
    if c46v21 ~= c46v22 then
      c46v20 = c46v19.showBoundingArrows
    end
    c46v21 = c46v19.isProgressMarker
    c46v22 = c46v19.clipName
    c46v23 = v82[c46v22]
    c46v24 = nil
    c46v25 = nil
    c46v26 = nil
    c46v27 = nil
    c46v28 = nil
    c46v29 = nil
    c46v30 = c46v19.isNew
    c46v31 = false
    c46v32 = nil
    c46v33 = c46v25
    if c46v33 then
      c46v33 = c46v24:UseFillIcon()
    end
    c46v34 = c46v19:ScreenX()
    c46v7 = c46v34 / 1
    c46v34 = c46v19:ScreenY()
    c46v8 = c46v34 / 1
    c46v34 = c46v19.arrowVisible
    if c46v37 then
      c46v38 = mMovie
      __renovice_local_1 = "Marker.StackCount"
      c46v39 = 12
      c46v40 = 0
      c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
      __renovice_state_0 = 1
      c46v38 = c46v36.Stacks
      __renovice_local_0 = 1
      for __renovice_for_2_0 = __renovice_state_0, c46v38, __renovice_local_0 do
        __renovice_local_1 = FlashMethod
        c46v39 = mMovie
        c46v42 = ".Marker.StackBacker"
        c46v44 = ".removeMovieClip"
        c46v40 = c46v22 .. c46v42 .. __renovice_for_2_0 .. c46v44
        __renovice_local_1(c46v39, c46v40)
      end
      c46v38 = mMovie
      __renovice_local_1 = "Marker.marker"
      c46v39 = 13
      c46v41 = c46v24:GetShowIconBacker()
      c46v40 = c46v41 or c46v33
      c46v38:Makeposshield(c46v22, __renovice_local_1, c46v39, c46v40)
      c46v38 = mMovie
      __renovice_local_1 = "Marker.CustomIcon"
      c46v39 = 1
      c46v40 = 0
      c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
      c46v38 = mMovie
      __renovice_local_1 = "Marker.StackCountBackground"
      c46v39 = 13
      c46v40 = false
      c46v38:Makeposshield(c46v22, __renovice_local_1, c46v39, c46v40)
      c46v38 = mMovie
      __renovice_local_1 = "Marker.Label"
      c46v39 = 1
      c46v40 = v83.Label
      c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
      c46v38 = mMovie
      __renovice_local_1 = "Marker.arrow"
      c46v39 = 1
      c46v40 = 0
      c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
      c46v38 = mMovie
      __renovice_local_1 = "Marker.arrow.ArrowGraphic"
      c46v39 = 1
      c46v40 = v83.ArrowGraphic
      c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
    end
    c46v38 = mMovie
    __renovice_local_1 = "Marker.StackCount"
    c46v39 = 1
    c46v41 = v83.StackCount
    c46v40 = c46v35 + c46v41
    c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
    c46v38 = mMovie
    __renovice_local_1 = "Marker.StackCountBackground"
    c46v39 = 1
    c46v41 = v83.StackCountBackground
    c46v40 = c46v35 + c46v41
    c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
    c46v38 = mMovie
    __renovice_local_1 = "Marker.Label"
    c46v39 = 1
    c46v41 = v83.Label
    c46v40 = c46v35 + c46v41
    c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
    c46v38 = mMovie
    __renovice_local_1 = "Marker.arrow"
    c46v39 = 1
    c46v40 = c46v35 / 2
    c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
    c46v38 = mMovie
    __renovice_local_1 = "Marker.arrow.ArrowGraphic"
    c46v39 = 1
    c46v41 = c46v35 / 2
    c46v42 = v83.ArrowGraphic
    c46v40 = c46v41 + c46v42
    c46v38:Name__52c1b74e(c46v22, __renovice_local_1, c46v39, c46v40)
    __renovice_local_1 = c46v19.stackCount
    __renovice_state_0 = __renovice_local_1 + 1
    c46v38 = c46v36.Stacks
    __renovice_local_0 = 1
    for __renovice_for_3_0 = __renovice_state_0, c46v38, __renovice_local_0 do
      __renovice_local_1 = FlashMethod
      c46v39 = mMovie
      c46v42 = ".Marker.StackBacker"
      c46v44 = ".removeMovieClip"
      c46v40 = c46v22 .. c46v42 .. __renovice_for_3_0 .. c46v44
      __renovice_local_1(c46v39, c46v40)
    end
    c46v38 = mMovie
    __renovice_local_1 = "Marker.marker"
    c46v39 = 13
    c46v40 = false
    c46v38:Makeposshield(c46v22, __renovice_local_1, c46v39, c46v40)
    c46v38 = mMovie
    __renovice_local_1 = "Marker.StackCountBackground"
    c46v39 = 13
    c46v40 = true
    c46v38:Makeposshield(c46v22, __renovice_local_1, c46v39, c46v40)
    c46v40 = v70
    if c46v40 then
      __renovice_local_1 = c46v26:GetUIName()
      c46v40 = mMovie
      c46v44 = ".EnemyStatus.Name"
      c46v42 = c46v22 .. c46v44
      c46v43 = 46
      c46v44 = "bottom"
      c46v40:SetStringVariable(c46v42, c46v43, c46v44)
    end
    c46v40 = c46v26:ShowLevelInHud()
    c46v38 = 0
    if c46v25 then
      __renovice_local_0 = c46v24:IsDistanceScaling()
      if __renovice_local_0 then
        __renovice_local_0 = c46v24:Name__a892798f()
        __renovice_state_0 = c46v24:GetDisplayRange()
        c46v43 = c46v19.distanceToEye
        c46v39 = __renovice_state_0:Name__b77b22a6(__renovice_state_0:Clamp(c46v43))
        __renovice_local_1 = 1 - c46v39
        c46v38 = __renovice_local_0:MapToRange(__renovice_local_1)
        c46v39 = mMovie
        c46v42 = 5
        c46v43 = c46v38 * 100
        c46v39:SetNumberVariable(c46v22, c46v42, c46v43)
        c46v39 = mMovie
        c46v42 = 6
        c46v43 = c46v38 * 100
        c46v39:SetNumberVariable(c46v22, c46v42, c46v43)
      end
    end
    __renovice_local_1 = c46v26:GetMaxHealth()
    c46v39 = c46v26:DamageControl()
    c46v39 = c46v39:GetMaxShield()
    c46v41 = c46v39 + __renovice_local_1
    c46v40 = __renovice_local_1 / c46v41
    c46v42 = c46v26:GetHealth()
    c46v41 = c46v42 / __renovice_local_1
    c46v42 = 0
    c46v43 = c46v26:Name__487bff54()
    c46v44 = 0
    if c46v44 < c46v39 then
      c46v44 = c46v26:DamageControl()
      c46v44 = c46v44:GetShield()
      c46v42 = c46v44 / c46v39
    end
    c46v44 = c46v23.LastHealthPct
    c46v44 = v1
    c46v44 = c46v44.Ternary
    c46v46 = 1
    if not (c46v46 < c46v42) then
      c46v45 = false
    else
      c46v45 = true
    end
    c46v46 = v90
    c46v47 = v89
    c46v32 = c46v44(c46v45, c46v46, c46v47)
    if (c46v20 and c46v29) then
      __renovice_local_1 = c46v28:GetDefaultHealth()
      c46v39 = 1
      if __renovice_local_1 ~= 0 then
        c46v40 = c46v28:GetHealth()
        c46v39 = c46v40 / __renovice_local_1
      end
      c46v40 = c46v23.LastHealthPct
      if c46v39 ~= c46v40 then
        c46v23.LastHealthPct = c46v39
        c46v40 = mMovie
        c46v44 = ".NewBounds.Fill"
        c46v42 = c46v22 .. c46v44
        c46v43 = "SectionPointsBase"
        c46v45 = 1
        c46v46 = 1
        c46v47 = 0
        c46v40:Name__e243d995(c46v42, c46v43, c46v39, c46v45, c46v46, c46v47)
        c46v31 = true
      end
    end
    c46v45 = c46v42 - 1
    c46v43 = c46v39:Name__ff67e37d(c46v45)
    c46v44 = 0
    if c46v44 < c46v43 then
      c46v44 = v32[c46v42]
      if c46v44 ~= nil then
        c46v44 = v1
        c46v44 = c46v44.Ternary
        c46v46 = 1
        if not (c46v46 < c46v43) then
          c46v45 = false
        else
          c46v45 = true
        end
        c46v47 = ""
        c46v44 = c46v44(c46v45, c46v43, c46v47)
        c46v45 = v32[c46v42]
        c46v45 = c46v45.Icon
        if c46v45 ~= nil then
          c46v46 = " "
          c46v47 = v32[c46v42]
          c46v47 = c46v47.Icon
          __renovice_local_1 = __renovice_local_1 .. c46v46 .. c46v47 .. c46v44
        end
      end
    end
    c46v39 = mMovie
    c46v43 = ".EnemyStatus.Name"
    c46v41 = c46v22 .. c46v43
    c46v42 = 36
    c46v39:SetStringVariable(c46v41, c46v42, __renovice_local_1)
    c46v39 = c46v19.markerType
    c46v40 = 85
    if c46v39 == c46v40 then
      c46v40 = c46v24:GetFillValue()
      c46v39 = c46v40 * 0.8
      c46v40 = mMovie
      c46v44 = ".Marker.CustomIcon"
      c46v42 = c46v22 .. c46v44
      c46v43 = 15
      c46v40 = c46v40:GetNumberVariable(c46v42, c46v43)
      if not c46v40 then
        c46v40 = 64
      end
      c46v41 = v1
      c46v41 = c46v41.GetVisibilitySize
      c46v42 = mMovie
      c46v44 = c46v40 * c46v39
      c46v43 = c46v44 * c46v38
      c46v41 = c46v41(c46v42, c46v43)
      c46v42 = mMovie
      c46v46 = ".Marker.CustomIcon"
      c46v44 = c46v22 .. c46v46
      c46v45 = "VisibilitySize"
      c46v47 = 0
      c46v48 = 0
      c46v49 = 0
      c46v42:Name__e243d995(c46v44, c46v45, c46v41, c46v47, c46v48, c46v49)
      c46v42 = mMovie
      c46v46 = ".Marker.CustomIcon"
      c46v44 = c46v22 .. c46v46
      c46v45 = "VisibilityFadeSize"
      c46v46 = 0
      c46v47 = 0
      c46v48 = 0
      c46v49 = 0
      c46v42:Name__e243d995(c46v44, c46v45, c46v46, c46v47, c46v48, c46v49)
      c46v42 = mMovie
      c46v46 = ".Marker.CustomIcon"
      c46v44 = c46v22 .. c46v46
      c46v45 = "VisibilityCenter"
      c46v48 = 16 * c46v38
      c46v47 = c46v8 + c46v48
      c46v48 = v51
      c46v46 = c46v47 / c46v48
      c46v47 = 0
      c46v48 = 0
      c46v49 = 0
      c46v42:Name__e243d995(c46v44, c46v45, c46v46, c46v47, c46v48, c46v49)
    end
    c46v31 = c46v19.clientWasVisible
    if c46v31 then
      c46v31 = false
      c46v19.clientWasVisible = c46v31
      c46v31 = mMovie
      c46v33 = c46v19.clipIndex
      c46v34 = 12
      c46v35 = 0
      c46v31:SetNumberMember(c46v33, c46v34, c46v35)
    end
    c46v31 = c46v19.isNew
    if c46v31 then
      c46v31 = false
      c46v19.isNew = c46v31
    end
    c46v9 = mMovie
    c46v9 = c46v9:GetMovieWidth()
    c46v10 = mMovie
    c46v10 = c46v10:GetMovieHeight()
    c46v9 = c46v9 * 0.5
    c46v10 = c46v10 * 0.5
    c46v13 = v44
    c46v12 = IsNull
    c46v12 = c46v12(c46v13)
    c46v11 = not c46v12
    if c46v11 then
      c46v12 = v44
      c46v12 = c46v12:GetCurrentMissionType()
      c46v13 = 1
      do
        local __renovice_unused_condition_0 = c46v12 == c46v13
      end
    end
    c46v14 = v44
    c46v13 = IsNull
    c46v13 = c46v13(c46v14)
    c46v12 = not c46v13
    if c46v12 then
      c46v12 = Lotus_Game.IsEndless
      c46v13 = v44
      c46v12 = c46v12(c46v13:GetCurrentMissionType())
    end
    c46v13 = v41
    c46v13 = c46v13:GetOnBoardShip()
    c46v15 = IsNull
    c46v15 = c46v15(c46v13)
    c46v14 = not c46v15
    if c46v14 then
      c46v16 = v40
      c46v17 = true
      c46v18 = false
      c46v14 = c46v13:IsUsingShipEmplacement(c46v16, c46v17, c46v18)
    end
    c46v15 = pairs
    c46v16 = v46
    c46v15, c46v16, c46v17 = c46v15(c46v16)
    c46v30 = c46v25
    if c46v30 then
      c46v30 = c46v24:HasCrewshipEmplacementView()
    end
    c46v23.IsEmplacementMarker = c46v30
    c46v30 = c46v23.IsEmplacementMarker
    if (c46v30 and c46v14) then
      c46v30 = false
      c46v19.isNew = c46v30
    end
    c46v36 = v81[c46v22]
    c46v37 = c46v36.Stacks
    if c46v37 == nil then
      c46v37 = 0
      c46v36.Stacks = c46v37
    end
    c46v38 = c46v36.Stacks
    __renovice_local_0 = c46v19.stackCount
    do
      local __renovice_unused_condition_1 = c46v38 ~= __renovice_local_0
    end
    c46v38 = c46v19.stackCount
    c46v38 = c46v19.stackCount
    c46v36.Stacks = c46v38
    c46v38 = 100
    if c46v25 then
      __renovice_local_0 = c46v24:Name__e8142e91()
      __renovice_state_0 = 0
      if __renovice_state_0 < __renovice_local_0 then
        __renovice_state_0 = c46v19.distanceToEye
        if __renovice_state_0 < __renovice_local_0 then
          __renovice_local_1 = 50
          c46v41 = c46v19.distanceToEye
          c46v40 = c46v41 / __renovice_local_0
          c46v39 = c46v40 * c46v38
          __renovice_state_0 = math.max
          c46v38 = __renovice_state_0(__renovice_local_1, c46v39)
        end
      end
      __renovice_state_0 = c46v24:GetAlphaMultiplier()
      c46v38 = c46v38 * __renovice_state_0
    end
    __renovice_local_0 = c46v19.constrainPosition
    if __renovice_local_0 then
      __renovice_local_0 = c46v19:ScreenZ()
      __renovice_state_0 = 0
      do
        local __renovice_unused_condition_2 = __renovice_state_0 <= __renovice_local_0
      end
    else
      __renovice_local_0 = v40
      c46v4 = __renovice_local_0:IsFacing(c46v24)
    end
    c46v36 = true
    c46v37 = v36
    if c46v37 then
      c46v37 = c46v19.markerType
      c46v38 = 49
      if c46v38 <= c46v37 then
        c46v37 = c46v19.markerType
        c46v38 = 52
        if c46v37 <= c46v38 then
          c46v37 = gRegion
          c46v37 = c46v37:GetLocalPlayer()
          c46v37 = c46v37:GetTeam()
          c46v38 = c46v19.team
          if c46v37 ~= c46v38 then
            c46v36 = false
          end
        end
      end
    end
    c46v37 = false
    c46v38 = c46v19.distanceToEye
    __renovice_local_0 = 0
    if __renovice_local_0 <= c46v38 then
      c46v37 = c46v25
      if c46v37 then
        c46v37 = c46v24:Name__2bc8d3c5()
      end
    end
    if c46v37 then
      __renovice_state_0 = v50
      __renovice_local_0 = __renovice_state_0 / 2
      c46v38 = c46v7 - __renovice_local_0
      __renovice_local_1 = v51
      __renovice_state_0 = __renovice_local_1 / 2
      __renovice_local_0 = c46v8 - __renovice_state_0
      c46v39 = c46v38 * c46v38
      c46v40 = __renovice_local_0 * __renovice_local_0
      __renovice_local_1 = c46v39 + c46v40
      __renovice_state_0 = math.sqrt
      __renovice_state_0 = __renovice_state_0(__renovice_local_1)
      __renovice_local_1 = v87
      if __renovice_local_1 < __renovice_state_0 then
        c46v37 = false
      end
    end
    c46v38 = c46v19.distanceToEye
    __renovice_local_0 = 0
    c46v38 = c46v19.distanceToEye
    __renovice_local_0 = c46v23.DistanceToEye
    if c46v38 ~= __renovice_local_0 then
      c46v38 = v84
      if (c46v38 and not c46v20) then
        c46v38 = mMovie
        __renovice_local_1 = "Marker.ScanRange"
        c46v39 = 13
        c46v40 = true
        c46v38:Makeposshield(c46v22, __renovice_local_1, c46v39, c46v40)
      end
      c46v38 = c46v23.ShowingStatus
      if c46v38 ~= nil then
        c46v38 = mMovie
        __renovice_local_1 = "EnemyStatus.Distance"
        c46v39 = 36
        c46v40 = mMovie
        c46v42 = "/Lotus/Language/Game/UNIT_METER"
        c46v43 = false
        c46v44 = { COUNT = nil }
        c46v45 = c46v19.distanceToEye
        c46v44.COUNT = c46v45
        c46v38:Name__f4a9016a(c46v22, __renovice_local_1, c46v39, c46v40:GetLocalized(c46v42, c46v43, c46v44))
        c46v38 = mMovie
        __renovice_state_0 = c46v19.scanRangeClipIndex
        __renovice_local_1 = 36
        c46v39 = ""
        c46v38:SetStringMember(__renovice_state_0, __renovice_local_1, c46v39)
      else
        c46v38 = mMovie
        __renovice_state_0 = c46v19.scanRangeClipIndex
        __renovice_local_1 = 36
        c46v39 = mMovie
        c46v41 = "/Lotus/Language/Game/UNIT_METER"
        c46v42 = false
        c46v43 = { COUNT = nil }
        c46v44 = c46v19.distanceToEye
        c46v43.COUNT = c46v44
        c46v38:SetStringMember(__renovice_state_0, __renovice_local_1, c46v39:GetLocalized(c46v41, c46v42, c46v43))
      end
      c46v38 = c46v19.distanceToEye
      c46v23.DistanceToEye = c46v38
    end
    c46v44 = IsNull
    c46v44 = c46v44(__renovice_local_0)
    if not c46v44 then
      c46v43 = v2
      c46v43 = c46v43.GetCrossPlatformUniquePlayerName
      c46v44 = __renovice_local_0:GetPlayerName()
      c46v45 = v60
      c46v46 = nil
      c46v47 = true
      c46v43 = c46v43(c46v44, c46v45, c46v46, c46v47)
    else
      c46v43 = ""
    end
    c46v44 = v65[c46v43]
    if c46v44 == nil then
      c46v44 = gGameData
      c46v44 = c46v44:Name__51ebbe84(c46v43)
      c46v45 = gGameData
      c46v45 = c46v45:Name__10fa7df8(c46v43)
      if (c46v45 and c46v44) then
        c46v46 = v65
        c46v47 = 3
        c46v46[c46v43] = c46v47
      else
        if c46v45 then
          c46v46 = v65
          c46v47 = 1
          c46v46[c46v43] = c46v47
        else
          if c46v44 then
            c46v46 = v65
            c46v47 = 2
            c46v46[c46v43] = c46v47
          else
            c46v46 = v65
            c46v47 = 0
            c46v46[c46v43] = c46v47
          end
        end
      end
    end
    c46v44 = v65[c46v43]
    if c46v44 ~= 0 then
      c46v1 = playerMarkerBackerOverrides[c46v44]
      c46v45 = 2
      if c46v45 <= c46v44 then
        c46v38 = -3
      else
        if c46v44 == 1 then
          c46v38 = -2
        end
      end
    end
    __renovice_local_0 = v1
    __renovice_local_0 = __renovice_local_0.Ternary
    __renovice_state_0 = c46v19.arrowVisible
    if not __renovice_state_0 then
      __renovice_state_0 = c46v19.showIconWithBounds
      if not __renovice_state_0 then
        __renovice_state_0 = c46v21
      end
    end
    __renovice_local_1 = v1
    __renovice_local_1 = __renovice_local_1.Ternary
    c46v40 = fillMarkerAlpha
    c46v41 = 100
    __renovice_local_1 = __renovice_local_1(c46v33, c46v40, c46v41)
    c46v39 = 0
    __renovice_local_0 = __renovice_local_0(__renovice_state_0, __renovice_local_1, c46v39)
    __renovice_state_0 = v1
    __renovice_state_0 = __renovice_state_0.Ternary
    __renovice_local_1 = c46v19.arrowVisible
    if __renovice_local_1 then
      __renovice_local_1 = not c46v21
    end
    c46v39 = 0
    c46v40 = 100
    __renovice_state_0 = __renovice_state_0(__renovice_local_1, c46v39, c46v40)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.Backer"
    c46v40 = c46v22 .. c46v42
    c46v43 = _G
    c46v45 = v22
    c46v46 = c46v23.Shape
    c46v44 = c46v45[c46v46]
    c46v42 = c46v43[c46v44]
    c46v41 = c46v42[1]
    __renovice_local_1:OverrideMaterial(c46v40, c46v41)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.Fill"
    c46v40 = c46v22 .. c46v42
    c46v43 = _G
    c46v45 = v22
    c46v46 = c46v23.Shape
    c46v44 = c46v45[c46v46]
    c46v42 = c46v43[c46v44]
    c46v41 = c46v42[2]
    __renovice_local_1:OverrideMaterial(c46v40, c46v41)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.Focused"
    c46v40 = c46v22 .. c46v42
    c46v43 = _G
    c46v45 = v22
    c46v46 = c46v23.Shape
    c46v44 = c46v45[c46v46]
    c46v42 = c46v43[c46v44]
    c46v41 = c46v42[3]
    __renovice_local_1:OverrideMaterial(c46v40, c46v41)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.HitPulse"
    c46v40 = c46v22 .. c46v42
    c46v43 = _G
    c46v45 = v22
    c46v46 = c46v23.Shape
    c46v44 = c46v45[c46v46]
    c46v42 = c46v43[c46v44]
    c46v41 = c46v42[2]
    __renovice_local_1:OverrideMaterial(c46v40, c46v41)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.HitPulse2"
    c46v40 = c46v22 .. c46v42
    c46v43 = _G
    c46v45 = v22
    c46v46 = c46v23.Shape
    c46v44 = c46v45[c46v46]
    c46v42 = c46v43[c46v44]
    c46v41 = c46v42[2]
    __renovice_local_1:OverrideMaterial(c46v40, c46v41)
    __renovice_local_1 = mMovie
    c46v41 = "Marker.CustomIcon"
    c46v42 = 12
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, __renovice_local_0)
    __renovice_local_1 = mMovie
    c46v41 = "Marker.MarkerOutline"
    c46v42 = 12
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, __renovice_local_0)
    __renovice_local_1 = mMovie
    c46v41 = "Marker.marker"
    c46v42 = 12
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, __renovice_local_0)
    __renovice_local_1 = mMovie
    c46v41 = "Bounds"
    c46v42 = 12
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, __renovice_state_0)
    __renovice_local_1 = mMovie
    c46v41 = "NewBounds"
    c46v42 = 12
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, __renovice_state_0)
    __renovice_local_1 = mMovie
    c46v41 = "NewBounds.Fill"
    c46v42 = 12
    c46v43 = enemyMarkerFillAlpha
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
    __renovice_local_1 = mMovie
    c46v41 = "NewBounds.HitPulse"
    c46v42 = 12
    c46v43 = 0
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.HitPulse"
    c46v40 = c46v22 .. c46v42
    c46v41 = "SectionPointsBase"
    c46v42 = 1
    c46v43 = 1
    c46v44 = 1
    c46v45 = 0
    __renovice_local_1:Name__e243d995(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.HitPulse"
    c46v40 = c46v22 .. c46v42
    c46v41 = "SectionEndGlowLength"
    c46v42 = 0
    c46v43 = 0
    c46v44 = 0
    c46v45 = 0
    __renovice_local_1:Name__e243d995(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45)
    __renovice_local_1 = mMovie
    c46v41 = "NewBounds.HitPulse2"
    c46v42 = 12
    c46v43 = 0
    __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.HitPulse2"
    c46v40 = c46v22 .. c46v42
    c46v41 = "SectionPointsBase"
    c46v42 = 1
    c46v43 = 1
    c46v44 = 1
    c46v45 = 0
    __renovice_local_1:Name__e243d995(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45)
    __renovice_local_1 = mMovie
    c46v42 = ".NewBounds.HitPulse2"
    c46v40 = c46v22 .. c46v42
    c46v41 = "SectionEndGlowLength"
    c46v42 = 0
    c46v43 = 0
    c46v44 = 0
    c46v45 = 0
    __renovice_local_1:Name__e243d995(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45)
    if c46v21 then
      __renovice_local_1 = mMovie
      c46v41 = "NewBounds.Focused"
      c46v42 = 12
      c46v43 = 0
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
      __renovice_local_1 = mMovie
      c46v41 = "NewBounds.Fill"
      c46v42 = 12
      c46v43 = 100
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
    end
    __renovice_local_1 = mMovie
    c46v42 = ".Bounds.FillContainer.Fill"
    c46v40 = c46v22 .. c46v42
    c46v43 = _G
    c46v45 = v22
    c46v46 = c46v23.Shape
    c46v44 = c46v45[c46v46]
    c46v42 = c46v43[c46v44]
    c46v41 = c46v42[4]
    __renovice_local_1:OverrideMaterial(c46v40, c46v41)
    __renovice_state_0 = c46v24:Name__3cd4efcc()
    __renovice_local_1 = 0
    if __renovice_local_1 < __renovice_state_0 then
      __renovice_local_1 = v85
      if not __renovice_local_1 then
        __renovice_local_1 = c46v24:Name__f1ea072b()
        __renovice_local_1 = __renovice_local_1 - c46v0
        c46v39 = 0
        if __renovice_local_1 <= c46v39 then
          __renovice_local_1 = c46v24:Name__2a2e4d04()
          c46v41 = __renovice_state_0 - 1
          c46v24:Name__24dd1e9f(c46v41)
          c46v39 = v80
          c46v40 = v1
          c46v40 = c46v40.CreateScreenParticles
          c46v41 = mMovie
          c46v42 = c46v24:GetMarkerSpawnEffect()
          c46v43 = 0
          c46v44 = 0
          c46v40 = c46v40(c46v41, c46v42, c46v43, c46v44)
          c46v39[c46v22] = c46v40
        end
        c46v24:Name__4ee23812(__renovice_local_1)
      end
    end
    c46v39 = v80[c46v22]
    __renovice_local_1 = IsNull
    __renovice_local_1 = __renovice_local_1(c46v39)
    c46v34 = c46v19.arrowWasVisible
    c46v35 = c46v19.arrowVisible
    if c46v34 ~= c46v35 then
      c46v34 = c46v19.arrowVisible
      c46v19.arrowWasVisible = c46v34
      c46v31 = true
      c46v34 = v1
      c46v34 = c46v34.Ternary
      c46v35 = c46v19.arrowVisible
      c46v36 = v1
      c46v36 = c46v36.Ternary
      c46v38 = fillMarkerAlpha
      __renovice_local_0 = 100
      c46v36 = c46v36(c46v33, c46v38, __renovice_local_0)
      c46v37 = 0
      c46v34 = c46v34(c46v35, c46v36, c46v37)
      c46v35 = mMovie
      c46v37 = c46v19.arrowClipIndex
      c46v38 = 12
      c46v35:SetNumberMember(c46v37, c46v38, c46v34)
      c46v35 = mMovie
      c46v38 = "Marker.arrowOutline"
      __renovice_local_0 = 12
      c46v35:Name__52c1b74e(c46v22, c46v38, __renovice_local_0, c46v34)
      if c46v20 then
        c46v35 = c46v19.arrowVisible
        if c46v35 then
          c46v35 = mMovie
          c46v38 = "Marker.CustomIcon"
          __renovice_local_0 = 0
          __renovice_state_0 = 0
          c46v35:Name__52c1b74e(c46v22, c46v38, __renovice_local_0, __renovice_state_0)
          c46v35 = mMovie
          c46v38 = "Marker.CustomIcon"
          __renovice_local_0 = 1
          __renovice_state_0 = 0
          c46v35:Name__52c1b74e(c46v22, c46v38, __renovice_local_0, __renovice_state_0)
          c46v35 = mMovie
          c46v38 = "Marker.MarkerOutline"
          __renovice_local_0 = 0
          __renovice_state_0 = 0
          c46v35:Name__52c1b74e(c46v22, c46v38, __renovice_local_0, __renovice_state_0)
          c46v35 = mMovie
          c46v38 = "Marker.MarkerOutline"
          __renovice_local_0 = 1
          __renovice_state_0 = 0
          c46v35:Name__52c1b74e(c46v22, c46v38, __renovice_local_0, __renovice_state_0)
          c46v35 = c46v23.IconScale
          if c46v35 ~= nil then
            c46v35 = mMovie
            __renovice_local_0 = ".Marker.CustomIcon"
            c46v37 = c46v22 .. __renovice_local_0
            c46v38 = "AlphaTestThreshold"
            __renovice_local_0 = 0
            __renovice_state_0 = 0
            __renovice_local_1 = 0
            c46v39 = 0
            c46v35:Name__e243d995(c46v37, c46v38, __renovice_local_0, __renovice_state_0, __renovice_local_1, c46v39)
          end
          c46v35 = mMovie
          c46v38 = "Marker.marker"
          __renovice_local_0 = 0
          __renovice_state_0 = 0
          c46v35:Name__52c1b74e(c46v22, c46v38, __renovice_local_0, __renovice_state_0)
          c46v35 = mMovie
          c46v38 = "Marker.marker"
          __renovice_local_0 = 1
          __renovice_state_0 = 0
          c46v35:Name__52c1b74e(c46v22, c46v38, __renovice_local_0, __renovice_state_0)
        end
        c46v35 = v1
        c46v35 = c46v35.Ternary
        c46v36 = c46v19.arrowVisible
        if not c46v36 then
          c46v36 = c46v19.showIconWithBounds
        end
        c46v37 = v1
        c46v37 = c46v37.Ternary
        __renovice_local_0 = fillMarkerAlpha
        __renovice_state_0 = 100
        c46v37 = c46v37(c46v33, __renovice_local_0, __renovice_state_0)
        c46v38 = 0
        c46v35 = c46v35(c46v36, c46v37, c46v38)
        c46v36 = v1
        c46v36 = c46v36.Ternary
        c46v37 = c46v19.arrowVisible
        c46v38 = 0
        __renovice_local_0 = 100
        c46v36 = c46v36(c46v37, c46v38, __renovice_local_0)
        c46v37 = mMovie
        __renovice_state_0 = "Marker.CustomIcon"
        __renovice_local_1 = 12
        c46v37:Name__52c1b74e(c46v22, __renovice_state_0, __renovice_local_1, c46v35)
        c46v37 = mMovie
        __renovice_state_0 = "Marker.MarkerOutline"
        __renovice_local_1 = 12
        c46v37:Name__52c1b74e(c46v22, __renovice_state_0, __renovice_local_1, c46v35)
        c46v37 = mMovie
        __renovice_state_0 = "Marker.marker"
        __renovice_local_1 = 12
        c46v37:Name__52c1b74e(c46v22, __renovice_state_0, __renovice_local_1, c46v35)
        c46v37 = mMovie
        __renovice_state_0 = "Bounds"
        __renovice_local_1 = 12
        c46v37:Name__52c1b74e(c46v22, __renovice_state_0, __renovice_local_1, c46v36)
        c46v37 = mMovie
        __renovice_state_0 = "NewBounds"
        __renovice_local_1 = 12
        c46v37:Name__52c1b74e(c46v22, __renovice_state_0, __renovice_local_1, c46v36)
        c46v37 = mMovie
        __renovice_state_0 = "Marker.ScanRange"
        __renovice_local_1 = 0
        c46v39 = -40
        c46v37:Name__52c1b74e(c46v22, __renovice_state_0, __renovice_local_1, c46v39)
        c46v37 = mMovie
        __renovice_state_0 = "Marker.ScanRange"
        __renovice_local_1 = 1
        c46v39 = 18
        c46v37:Name__52c1b74e(c46v22, __renovice_state_0, __renovice_local_1, c46v39)
        c46v37 = mMovie
        __renovice_state_0 = "Marker.ScanRange"
        __renovice_local_1 = 13
        c46v40 = c46v19.arrowVisible
        c46v39 = not c46v40
        c46v37:Makeposshield(c46v22, __renovice_state_0, __renovice_local_1, c46v39)
        c46v37 = v84
        if not c46v37 then
          c46v37 = c46v19.arrowVisible
          if c46v37 then
            c46v37 = true
            v84 = c46v37
          end
        end
      end
    end
    if c46v20 then
      c46v34 = c46v19.arrowVisible
      if c46v34 then
        if c46v33 then
          c46v5 = 200
          c46v6 = 1.5
        else
          c46v34 = Clamp
          c46v36 = 100
          c46v38 = c46v19.distanceToEye
          c46v37 = 200 - c46v38
          c46v35 = c46v36 + c46v37
          c46v36 = 50
          c46v37 = 200
          c46v5 = c46v34(c46v35, c46v36, c46v37)
          c46v6 = 2
        end
        c46v34 = mMovie
        c46v36 = c46v19.arrowImageClipIndex
        c46v38 = v1
        c46v38 = c46v38.Ternary
        __renovice_state_0 = c46v5 / c46v6
        c46v34:SetMemberScale(c46v36, c46v5, c46v38(c46v33, __renovice_state_0, c46v5))
        c46v34 = mMovie
        c46v37 = "Marker.arrowOutline.ArrowGraphic"
        c46v38 = 5
        c46v34:Name__52c1b74e(c46v22, c46v37, c46v38, c46v5)
        c46v34 = mMovie
        c46v37 = "Marker.arrowOutline.ArrowGraphic"
        c46v38 = 6
        __renovice_local_0 = v1
        __renovice_local_0 = __renovice_local_0.Ternary
        __renovice_local_1 = c46v5 / c46v6
        c46v34:Name__52c1b74e(c46v22, c46v37, c46v38, __renovice_local_0(c46v33, __renovice_local_1, c46v5))
      end
    end
    c46v34 = true
    c46v35 = c46v19.markerType
    c46v36 = 11
    if c46v35 ~= c46v36 then
      c46v34 = false
      c46v35 = c46v19.markerType
      c46v36 = 75
      if c46v35 == c46v36 then
        c46v34 = c46v25
        if c46v34 then
          c46v36 = v14
          c46v34 = c46v24:IsA(c46v36)
        end
      end
    end
    c46v35 = 0
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c46v1)
    if __renovice_local_0 then
      c46v1 = forcedMarkerBackerIcon
    end
    __renovice_local_0 = mMovie
    c46v40 = ".Marker.CustomIcon"
    __renovice_local_1 = c46v22 .. c46v40
    __renovice_local_0:OverrideTexture(__renovice_local_1, c46v2)
    __renovice_local_0 = mMovie
    c46v40 = ".Marker.marker.CustomBackerIcon"
    __renovice_local_1 = c46v22 .. c46v40
    __renovice_local_0:OverrideTexture(__renovice_local_1, c46v1)
    __renovice_local_0 = mMovie
    c46v39 = 5
    c46v40 = 100
    __renovice_local_0:SetNumberVariable(c46v22, c46v39, c46v40)
    __renovice_local_0 = mMovie
    c46v39 = 6
    c46v40 = 100
    __renovice_local_0:SetNumberVariable(c46v22, c46v39, c46v40)
    __renovice_local_0 = c46v19.markerType
    __renovice_state_0 = 66
    if __renovice_local_0 == __renovice_state_0 then
      __renovice_local_0 = mMovie
      __renovice_local_1 = c46v19.arrowImageClipIndex
      c46v39 = 15
      c46v40 = 96
      __renovice_local_0:SetNumberMember(__renovice_local_1, c46v39, c46v40)
      __renovice_local_0 = mMovie
      __renovice_local_1 = c46v19.arrowImageClipIndex
      c46v39 = 14
      c46v40 = 96
      __renovice_local_0:SetNumberMember(__renovice_local_1, c46v39, c46v40)
      __renovice_local_0 = mMovie
      c46v40 = ".Marker.arrow.ArrowGraphic"
      __renovice_local_1 = c46v22 .. c46v40
      c46v39 = lunaroArrow
      __renovice_local_0:OverrideTexture(__renovice_local_1, c46v39)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.CustomIcon"
      c46v40 = 13
      c46v41 = false
      __renovice_local_0:Makeposshield(c46v22, c46v39, c46v40, c46v41)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.arrow.ArrowGraphic"
      c46v40 = 12
      c46v41 = 100
      __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
      __renovice_local_0 = mMovie
      c46v40 = ".Marker.arrow.ArrowGraphic"
      __renovice_local_1 = c46v22 .. c46v40
      c46v39 = standardMaterial
      __renovice_local_0:OverrideMaterial(__renovice_local_1, c46v39)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.MarkerOutline"
      c46v40 = 13
      c46v41 = false
      __renovice_local_0:Makeposshield(c46v22, c46v39, c46v40, c46v41)
    else
      __renovice_local_0 = mMovie
      __renovice_local_1 = c46v19.arrowImageClipIndex
      c46v39 = 15
      c46v40 = 16
      __renovice_local_0:SetNumberMember(__renovice_local_1, c46v39, c46v40)
      __renovice_local_0 = mMovie
      __renovice_local_1 = c46v19.arrowImageClipIndex
      c46v39 = 14
      c46v40 = 11.5
      __renovice_local_0:SetNumberMember(__renovice_local_1, c46v39, c46v40)
      __renovice_local_0 = mMovie
      c46v40 = ".Marker.arrow.ArrowGraphic"
      __renovice_local_1 = c46v22 .. c46v40
      c46v39 = nil
      __renovice_local_0:OverrideTexture(__renovice_local_1, c46v39)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.CustomIcon"
      c46v40 = 13
      c46v41 = true
      __renovice_local_0:Makeposshield(c46v22, c46v39, c46v40, c46v41)
      __renovice_local_0 = mMovie
      c46v40 = ".Marker.arrow.ArrowGraphic"
      __renovice_local_1 = c46v22 .. c46v40
      c46v39 = nil
      __renovice_local_0:OverrideMaterial(__renovice_local_1, c46v39)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.arrowOutline.ArrowGraphic"
      c46v40 = 15
      c46v41 = 16
      __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.arrowOutline.ArrowGraphic"
      c46v40 = 14
      c46v41 = 11.5
      __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.MarkerOutline"
      c46v40 = 13
      __renovice_local_0:Makeposshield(c46v22, c46v39, c46v40, c46v33)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.arrowOutline"
      c46v40 = 11
      c46v41 = _G
      c46v41 = c46v41.UIColor_White
      __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    end
    if c46v25 then
      __renovice_local_0 = c46v24:GetMaterial()
      __renovice_state_0 = IsNull
      __renovice_state_0 = __renovice_state_0(__renovice_local_0)
      if not __renovice_state_0 then
        __renovice_state_0 = mMovie
        c46v41 = ".Marker.CustomIcon"
        c46v39 = c46v22 .. c46v41
        __renovice_state_0:OverrideMaterial(c46v39, __renovice_local_0)
        __renovice_state_0 = true
        c46v23.HasMaterialOverride = __renovice_state_0
      else
        __renovice_state_0 = c46v23.HasMaterialOverride
        if __renovice_state_0 then
          __renovice_state_0 = mMovie
          c46v41 = ".Marker.CustomIcon"
          c46v39 = c46v22 .. c46v41
          c46v40 = markerIconMask
          __renovice_state_0:OverrideMaterial(c46v39, c46v40)
          __renovice_state_0 = nil
          c46v23.HasMaterialOverride = __renovice_state_0
        end
      end
      __renovice_state_0 = mMovie
      c46v40 = 13
      __renovice_state_0:Name__d9713943(c46v22, c46v40, c46v36)
      __renovice_state_0 = mMovie
      c46v40 = "Marker.marker"
      c46v41 = 13
      c46v43 = c46v24:GetShowIconBacker()
      c46v42 = c46v43 or c46v33
      __renovice_state_0:Makeposshield(c46v22, c46v40, c46v41, c46v42)
      __renovice_state_0 = c46v24:GetBackerIconScale()
      __renovice_local_1 = mMovie
      c46v41 = "Marker.marker"
      c46v42 = 5
      c46v44 = __renovice_state_0.x
      c46v43 = c46v44 * 100
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
      __renovice_local_1 = mMovie
      c46v41 = "Marker.marker"
      c46v42 = 6
      c46v44 = __renovice_state_0.y
      c46v43 = c46v44 * 100
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
      if c46v33 then
        __renovice_local_1 = mMovie
        c46v42 = ".Marker.arrow.ArrowGraphic"
        c46v40 = c46v22 .. c46v42
        c46v41 = offScreenMarkerArrow
        __renovice_local_1:OverrideTexture(c46v40, c46v41)
        __renovice_local_1 = mMovie
        c46v42 = ".Marker.arrowOutline.ArrowGraphic"
        c46v40 = c46v22 .. c46v42
        c46v41 = offScreenMarkerArrowOutline
        __renovice_local_1:OverrideTexture(c46v40, c46v41)
        __renovice_local_1 = mMovie
        c46v42 = ".Marker.MarkerOutline"
        c46v40 = c46v22 .. c46v42
        __renovice_local_1:OverrideTexture(c46v40, c46v24:GetFillOutline())
        __renovice_local_1 = mMovie
        c46v41 = "Marker.arrowOutline"
        c46v42 = 13
        c46v43 = true
        __renovice_local_1:Makeposshield(c46v22, c46v41, c46v42, c46v43)
      else
        __renovice_local_1 = mMovie
        c46v42 = ".Marker.arrow.ArrowGraphic"
        c46v40 = c46v22 .. c46v42
        c46v41 = nil
        __renovice_local_1:OverrideTexture(c46v40, c46v41)
        __renovice_local_1 = mMovie
        c46v41 = "Marker.arrowOutline"
        c46v42 = 13
        c46v43 = false
        __renovice_local_1:Makeposshield(c46v22, c46v41, c46v42, c46v43)
      end
    else
      __renovice_local_0 = c46v23.HasMaterialOverride
      if __renovice_local_0 then
        __renovice_local_0 = mMovie
        c46v40 = ".Marker.CustomIcon"
        __renovice_local_1 = c46v22 .. c46v40
        c46v39 = markerIconMask
        __renovice_local_0:OverrideMaterial(__renovice_local_1, c46v39)
        __renovice_local_0 = nil
        c46v23.HasMaterialOverride = __renovice_local_0
      end
      __renovice_local_0 = mMovie
      c46v40 = ".Marker.arrow.ArrowGraphic"
      __renovice_local_1 = c46v22 .. c46v40
      c46v39 = nil
      __renovice_local_0:OverrideTexture(__renovice_local_1, c46v39)
      __renovice_local_0 = mMovie
      c46v39 = "Marker.arrowOutline"
      c46v40 = 13
      c46v41 = false
      __renovice_local_0:Makeposshield(c46v22, c46v39, c46v40, c46v41)
    end
    __renovice_local_0 = c46v19.markerType
    __renovice_state_0 = 85
    if __renovice_local_0 == __renovice_state_0 then
      __renovice_local_0 = mMovie
      c46v40 = ".Marker.CustomIcon"
      __renovice_local_1 = c46v22 .. c46v40
      c46v39 = "VisibilitySize"
      c46v40 = 0
      c46v41 = 0
      c46v42 = 0
      c46v43 = 0
      __renovice_local_0:Name__e243d995(__renovice_local_1, c46v39, c46v40, c46v41, c46v42, c46v43)
      __renovice_local_0 = mMovie
      c46v40 = ".Marker.CustomIcon"
      __renovice_local_1 = c46v22 .. c46v40
      c46v39 = "VisibilityFadeSize"
      c46v40 = 0
      c46v41 = 0
      c46v42 = 0
      c46v43 = 0
      __renovice_local_0:Name__e243d995(__renovice_local_1, c46v39, c46v40, c46v41, c46v42, c46v43)
    end
    __renovice_local_0 = mMovie
    c46v39 = "Bounds"
    c46v40 = 13
    __renovice_local_0:Makeposshield(c46v22, c46v39, c46v40, c46v20)
    __renovice_local_0 = mMovie
    c46v39 = "NewBounds"
    c46v40 = 13
    c46v41 = c46v20 or c46v21
    __renovice_local_0:Makeposshield(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v39 = "Marker.arrow.ArrowGraphic"
    c46v40 = 1
    c46v42 = v83.ArrowGraphic
    c46v43 = v1
    c46v43 = c46v43.Ternary
    c46v45 = -10
    c46v46 = 0
    c46v43 = c46v43(c46v21, c46v45, c46v46)
    c46v41 = c46v42 + c46v43
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = mMovie
    c46v40 = ".EnemyStatus"
    __renovice_local_1 = c46v22 .. c46v40
    __renovice_local_0:EnablePfdeco(__renovice_local_1)
    __renovice_local_0 = mMovie
    c46v39 = "EnemyStatus"
    c46v40 = 12
    c46v41 = 0
    __renovice_local_0:Name__52c1b74e(c46v22, c46v39, c46v40, c46v41)
    __renovice_local_0 = nil
    if c46v33 then
      __renovice_state_0 = c46v24:GetFillValue()
      if __renovice_state_0 == 0 then
        c46v40 = 0
        __renovice_local_0 = c46v24:Name__b85925e6(c46v40)
      else
        __renovice_local_1 = 1
        if __renovice_local_1 <= __renovice_state_0 then
          c46v40 = 2
          __renovice_local_0 = c46v24:Name__b85925e6(c46v40)
        else
          c46v40 = 1
          __renovice_local_0 = c46v24:Name__b85925e6(c46v40)
        end
      end
    else
      __renovice_local_0 = c46v24:Name__dabde46e()
    end
    __renovice_state_0 = c46v23.Color
    if __renovice_local_0 ~= __renovice_state_0 then
      if not c46v33 then
        __renovice_state_0 = mMovie
        c46v40 = "Marker.marker"
        c46v41 = 11
        __renovice_state_0:Name__52c1b74e(c46v22, c46v40, c46v41, __renovice_local_0)
        c46v39 = 1
        __renovice_state_0 = c46v19.stackCount
        __renovice_local_1 = 1
        for __renovice_for_4_0 = c46v39, __renovice_state_0, __renovice_local_1 do
          c46v40 = mMovie
          c46v44 = ".Marker.StackBacker"
          c46v42 = c46v22 .. c46v44 .. __renovice_for_4_0
          c46v43 = 11
          c46v40:SetNumberVariable(c46v42, c46v43, __renovice_local_0)
        end
      end
      __renovice_state_0 = mMovie
      c46v40 = "Marker.CustomIcon"
      c46v41 = 11
      __renovice_state_0:Name__52c1b74e(c46v22, c46v40, c46v41, __renovice_local_0)
      __renovice_state_0 = mMovie
      c46v40 = "Marker.arrow"
      c46v41 = 11
      __renovice_state_0:Name__52c1b74e(c46v22, c46v40, c46v41, __renovice_local_0)
      __renovice_state_0 = mMovie
      c46v40 = "Marker.ScanRange"
      c46v41 = 11
      __renovice_state_0:Name__52c1b74e(c46v22, c46v40, c46v41, __renovice_local_0)
      __renovice_state_0 = mMovie
      c46v40 = "Marker.StackCount"
      c46v41 = 11
      __renovice_state_0:Name__52c1b74e(c46v22, c46v40, c46v41, __renovice_local_0)
      if c46v21 then
        __renovice_state_0 = mMovie
        c46v40 = "NewBounds.Fill"
        c46v41 = 11
        __renovice_state_0:Name__52c1b74e(c46v22, c46v40, c46v41, __renovice_local_0)
      end
      c46v31 = true
      c46v23.Color = __renovice_local_0
    end
    __renovice_state_0 = c46v24:GetIconScale()
    __renovice_local_1 = c46v23.IconScale
    if __renovice_state_0 ~= __renovice_local_1 then
      c46v23.IconScale = __renovice_state_0
      __renovice_local_1 = mMovie
      c46v41 = "Marker.CustomIcon"
      c46v42 = 5
      c46v44 = c46v23.IconScale
      c46v44 = c46v44.x
      c46v43 = c46v44 * 100
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
      __renovice_local_1 = mMovie
      c46v41 = "Marker.CustomIcon"
      c46v42 = 6
      c46v44 = c46v23.IconScale
      c46v44 = c46v44.y
      c46v43 = c46v44 * 100
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
      __renovice_local_1 = mMovie
      c46v41 = "Marker.MarkerOutline"
      c46v42 = 5
      c46v44 = c46v23.IconScale
      c46v44 = c46v44.x
      c46v43 = c46v44 * 50
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
      __renovice_local_1 = mMovie
      c46v41 = "Marker.MarkerOutline"
      c46v42 = 6
      c46v44 = c46v23.IconScale
      c46v44 = c46v44.y
      c46v43 = c46v44 * 50
      __renovice_local_1:Name__52c1b74e(c46v22, c46v41, c46v42, c46v43)
    end
    c46v46 = ".NewBounds.HitPulse"
    c46v44 = c46v22 .. c46v46
    c46v45 = c46v23.AlternateHitPulse
    if c46v45 then
      c46v46 = "2"
      c46v44 = c46v44 .. c46v46
    end
    c46v45 = c46v23.LastHealthPct
    if c46v45 ~= nil then
      c46v45 = c46v23.LastShieldPct
      if c46v45 ~= nil then
        c46v45 = c46v23.LastDamageFactor
        if c46v45 <= c46v43 then
          c46v45 = 0
          if c46v45 < c46v43 then
            c46v46 = c46v23.AlternateHitPulse
            c46v45 = not c46v46
            c46v23.AlternateHitPulse = c46v45
            c46v46 = c46v23.LastHealthPct
            c46v45 = c46v46 - c46v41
            c46v47 = c46v23.LastShieldPct
            c46v46 = c46v47 - c46v42
            if c46v45 ~= 0 then
              c46v49 = 0.015
              c46v47 = math.max
              c46v45 = c46v47(c46v45, c46v49)
              c46v49 = 0.015
              c46v47 = math.max
              c46v46 = c46v47(c46v46, c46v49)
              c46v48 = c46v41 * c46v40
              c46v47 = c46v40 - c46v48
              c46v48 = mMovie
              c46v51 = "SectionPointsBase"
              c46v52 = c46v45 * c46v40
              c46v56 = 1 - c46v40
              c46v55 = c46v46 * c46v56
              c46v54 = c46v47 + c46v55
              c46v55 = c46v41 * c46v40
              c46v48:Name__e243d995(c46v44, c46v51, c46v52, c46v47, c46v54, c46v55)
            else
              c46v49 = 0.015
              c46v47 = math.max
              c46v46 = c46v47(c46v46, c46v49)
              c46v47 = mMovie
              c46v50 = "SectionPointsBase"
              c46v51 = 0
              c46v52 = 0
              c46v54 = 1 - c46v40
              c46v53 = c46v46 * c46v54
              c46v56 = 1 - c46v40
              c46v55 = c46v42 * c46v56
              c46v54 = c46v40 + c46v55
              c46v47:Name__e243d995(c46v44, c46v50, c46v51, c46v52, c46v53, c46v54)
            end
            c46v47 = mMovie
            c46v47:EnablePfdeco(c46v44)
            c46v47 = mMovie
            c46v50 = 12
            c46v51 = 75
            c46v47:SetNumberVariable(c46v44, c46v50, c46v51)
            c46v47 = mMovie
            c46v50 = 5
            c46v51 = 753
            c46v47:SetNumberVariable(c46v44, c46v50, c46v51)
            c46v47 = mMovie
            c46v50 = 6
            c46v51 = 753
            c46v47:SetNumberVariable(c46v44, c46v50, c46v51)
            c46v47 = 0.485
            c46v48 = 0.275
            c46v49 = 0
            c46v50 = c46v23.Shape
            if c46v50 == 2 then
              c46v48 = 0.325
              c46v49 = -0.75
            else
              c46v50 = c46v23.Shape
              if c46v50 == 3 then
                c46v47 = 0.42
                c46v48 = 0.18
                c46v49 = 1
              end
            end
            c46v50 = mMovie
            c46v53 = "CircleSettings"
            c46v56 = 0
            c46v50:Name__e243d995(c46v44, c46v53, c46v47, c46v48, c46v56, c46v49)
            c46v50 = 0
            c46v51 = function(c44v0)
              local c44v1, c44v2, c44v3, c44v4, c44v5, c44v6, c44v7, c44v8, c44v9
              c44v1 = mMovie
              c44v2 = c46v44
              c44v3 = "CircleSettings"
              c44v4 = c46v47
              c44v6 = c46v48
              c44v9 = c46v50
              c44v8 = c44v9 + c44v0
              c44v7 = c44v8 * 2.5
              c44v5 = c44v6 + c44v7
              c44v6 = 0
              c44v7 = c46v49
              c44v1:Name__e243d995(c44v2, c44v3, c44v4, c44v5, c44v6, c44v7)
              do return end
            end
            c46v52 = FlashInterpolate
            c46v53 = mMovie
            c46v55 = 0
            c46v58 = 5
            c46v59 = 6
            c46v56 = {c46v51, c46v58, c46v59}
            c46v58 = 0.5
            c46v59 = 1053
            c46v60 = 1053
            c46v57 = {c46v58, c46v59, c46v60}
            c46v58 = 0.125
            c46v59 = 0
            c46v60 = function()
              local c45v0, c45v1, c45v2, c45v3, c45v4, c45v5, c45v6, c45v7, c45v8, c45v9
              c45v0 = 0.5
              c46v50 = c45v0
              c45v0 = FlashInterpolate
              c45v1 = mMovie
              c45v2 = c46v44
              c45v3 = 2
              c45v5 = c46v51
              c45v6 = 5
              c45v7 = 6
              c45v8 = 12
              c45v4 = {c45v5, c45v6, c45v7, c45v8}
              c45v6 = 0.5
              c45v7 = 1253
              c45v8 = 1253
              c45v9 = 0
              c45v5 = {c45v6, c45v7, c45v8, c45v9}
              c45v6 = 0.125
              c45v7 = 0
              c45v0(c45v1, c45v2, c45v3, c45v4, c45v5, c45v6, c45v7)
              do return end
            end
            c46v52(c46v53, c46v44, c46v55, c46v56, c46v57, c46v58, c46v59, c46v60)
          end
        end
      end
    end
    c46v23.LastHealthPct = c46v41
    c46v23.LastShieldPct = c46v42
    c46v23.LastRatio = c46v40
    c46v45 = mMovie
    c46v49 = ".NewBounds.Fill"
    c46v47 = c46v22 .. c46v49
    c46v48 = "SectionPointsBase"
    c46v49 = c46v41 * c46v40
    c46v54 = 1
    c46v53 = math.min
    c46v53 = c46v53(c46v54, c46v42)
    c46v54 = 1 - c46v40
    c46v52 = c46v53 * c46v54
    c46v51 = c46v40 + c46v52
    c46v52 = 0
    c46v45:Name__e243d995(c46v47, c46v48, c46v49, c46v40, c46v51, c46v52)
    c46v31 = true
    if c46v20 then
      __renovice_local_0 = c46v19.arrowVisible
      if (not __renovice_local_0 or c46v33) then
        __renovice_local_0 = false
        __renovice_state_0 = c46v23.FillPct
        if __renovice_state_0 == nil then
          __renovice_state_0 = SmoothFloat
          __renovice_local_1 = 0
          c46v39 = 0.1
          __renovice_state_0 = __renovice_state_0(__renovice_local_1, c46v39)
          c46v23.FillPct = __renovice_state_0
          __renovice_local_0 = true
        end
        if c46v25 then
          __renovice_state_0 = 0
          __renovice_local_1 = c46v23.PrevAwareness
          if c46v27 then
            __renovice_local_1 = c46v26:GetAwareness()
          end
          if __renovice_local_1 == nil then
            __renovice_local_1 = 1
          end
          c46v39 = 2
          if __renovice_local_1 == c46v39 then
            c46v39 = c46v24:GetFillValue()
            __renovice_state_0 = c46v39 * 1.1
            c46v39 = c46v31
            if not c46v39 then
              c46v40 = c46v23.PrevFillPct
              if __renovice_state_0 == c46v40 then
                c46v39 = false
              else
                c46v39 = true
              end
            end
            c46v31 = c46v39
          else
            c46v39 = 3
            if __renovice_local_1 == c46v39 then
              __renovice_state_0 = 1.1
            end
            c46v39 = c46v31
            if not c46v39 then
              c46v40 = c46v23.PrevAwareness
              if __renovice_local_1 == c46v40 then
                c46v39 = false
              else
                c46v39 = true
              end
            end
            c46v31 = c46v39
            __renovice_local_0 = true
          end
          if __renovice_local_0 then
            c46v39 = c46v23.FillPct
            c46v39:Name__3f96e89a(__renovice_state_0)
          else
            c46v39 = c46v23.FillPct
            c46v39:SetTargetVal(__renovice_state_0)
          end
          c46v39 = c46v23.FillPct
          c46v39:Update(c46v0)
          if c46v31 then
            c46v39 = c46v23.FillPct
            c46v39 = c46v39:GetVal()
            c46v23.PrevFillPct = c46v39
            c46v23.PrevAwareness = __renovice_local_1
            if c46v33 then
              c46v39 = c46v23.IconScale
              if c46v39 ~= nil then
                c46v39 = mMovie
                c46v43 = ".Marker.CustomIcon"
                c46v41 = c46v22 .. c46v43
                c46v42 = "AlphaTestThreshold"
                c46v43 = c46v23.PrevFillPct
                c46v44 = 0
                c46v45 = 0
                c46v46 = 0
                c46v39:Name__e243d995(c46v41, c46v42, c46v43, c46v44, c46v45, c46v46)
              end
            end
            c46v39 = nil
            c46v40 = nil
            c46v41 = nil
            c46v42 = nil
            if c46v29 then
              c46v39 = v73.DecoHealth
              c46v40 = c46v39
              c46v41 = c46v39
              c46v42 = c46v39
            else
              c46v43 = 3
              if __renovice_local_1 == c46v43 then
                c46v39 = c46v24:Name__b77a7529()
                c46v40 = c46v39
                c46v41 = 2427145
                c46v42 = 2427145
                if c46v27 then
                  c46v43 = c46v26:DamageControl()
                  c46v43 = c46v43:GetMaxShield()
                  c46v44 = 0
                  c46v45 = 0
                  if c46v45 < c46v43 then
                    c46v45 = c46v26:DamageControl()
                    c46v45 = c46v45:GetShield()
                    c46v44 = c46v45 / c46v43
                  end
                  c46v45 = v1
                  c46v45 = c46v45.Ternary
                  c46v47 = 1
                  if not (c46v47 < c46v44) then
                    c46v46 = false
                  else
                    c46v46 = true
                  end
                  c46v47 = v90
                  c46v48 = v89
                  c46v32 = c46v45(c46v46, c46v47, c46v48)
                end
              else
                c46v43 = 2
                if __renovice_local_1 == c46v43 then
                  c46v39 = c46v24:Name__6b7fc60e()
                  c46v40 = c46v24:Name__df97624e()
                  c46v43 = v1
                  c46v43 = c46v43.ConvertColorNumberToProceduralRGB
                  c46v44 = v1
                  c46v44 = c46v44.InterpolateColors
                  c46v46 = _G
                  c46v46 = c46v46.UIColor_White
                  c46v47 = 0.15
                  c46v32 = c46v43(c46v44(c46v40, c46v46, c46v47))
                  c46v41 = 7343875
                  c46v42 = 16777215
                else
                  c46v39 = c46v24:Name__8837ead8()
                  c46v40 = c46v39
                  c46v43 = v1
                  c46v43 = c46v43.ConvertColorNumberToProceduralRGB
                  c46v44 = v1
                  c46v44 = c46v44.InterpolateColors
                  c46v46 = _G
                  c46v46 = c46v46.UIColor_White
                  c46v47 = 0.15
                  c46v32 = c46v43(c46v44(c46v40, c46v46, c46v47))
                  c46v41 = 0
                  c46v42 = 16777215
                end
              end
            end
            c46v43 = mMovie
            c46v46 = "Marker.MarkerOutline"
            c46v47 = 11
            c46v43:Name__52c1b74e(c46v22, c46v46, c46v47, c46v41)
            c46v43 = mMovie
            c46v46 = "Marker.arrowOutline"
            c46v47 = 11
            c46v43:Name__52c1b74e(c46v22, c46v46, c46v47, c46v41)
            c46v43 = mMovie
            c46v46 = "Marker.marker"
            c46v47 = 11
            c46v43:Name__52c1b74e(c46v22, c46v46, c46v47, c46v42)
            c46v43 = mMovie
            c46v46 = "NewBounds.Focused"
            c46v47 = 11
            c46v43:Name__52c1b74e(c46v22, c46v46, c46v47, c46v39)
            c46v43 = mMovie
            c46v46 = "NewBounds.Fill"
            c46v47 = 11
            c46v43:Name__52c1b74e(c46v22, c46v46, c46v47, c46v40)
            c46v43 = mMovie
            c46v46 = "NewBounds.HitPulse"
            c46v47 = 11
            c46v43:Name__52c1b74e(c46v22, c46v46, c46v47, c46v40)
            c46v43 = mMovie
            c46v46 = "NewBounds.HitPulse2"
            c46v47 = 11
            c46v43:Name__52c1b74e(c46v22, c46v46, c46v47, c46v40)
            if c46v32 ~= nil then
              c46v43 = mMovie
              c46v47 = ".NewBounds.Fill"
              c46v45 = c46v22 .. c46v47
              c46v46 = "SectionTwoColor"
              c46v47 = c46v32.r
              c46v48 = c46v32.g
              c46v49 = c46v32.b
              c46v50 = 1
              c46v43:Name__e243d995(c46v45, c46v46, c46v47, c46v48, c46v49, c46v50)
              c46v43 = mMovie
              c46v47 = ".NewBounds.HitPulse"
              c46v45 = c46v22 .. c46v47
              c46v46 = "SectionTwoColor"
              c46v47 = c46v32.r
              c46v48 = c46v32.g
              c46v49 = c46v32.b
              c46v50 = 1
              c46v43:Name__e243d995(c46v45, c46v46, c46v47, c46v48, c46v49, c46v50)
              c46v43 = mMovie
              c46v47 = ".NewBounds.HitPulse2"
              c46v45 = c46v22 .. c46v47
              c46v46 = "SectionTwoColor"
              c46v47 = c46v32.r
              c46v48 = c46v32.g
              c46v49 = c46v32.b
              c46v50 = 1
              c46v43:Name__e243d995(c46v45, c46v46, c46v47, c46v48, c46v49, c46v50)
            end
          end
        end
        __renovice_state_0 = c46v19.arrowVisible
        if not __renovice_state_0 then
          __renovice_state_0 = c46v23.FillPct
          __renovice_state_0 = __renovice_state_0:GetVal()
          __renovice_local_1 = v42
          c46v40 = mMovie
          c46v41 = c46v22
          c46v42 = c46v19
          c46v43 = c46v7
          c46v44 = c46v8
          c46v45 = Clamp
          c46v47 = 0
          c46v48 = 1
          c46v45 = c46v45(__renovice_state_0, c46v47, c46v48)
          c46v46 = Clamp
          c46v48 = 10.000000000000009
          c46v49 = __renovice_state_0 - 1
          c46v47 = c46v48 * c46v49
          c46v48 = 0
          c46v49 = 1
          c46v46 = c46v46(c46v47, c46v48, c46v49)
          c46v47 = 0
          c46v48 = nil
          c46v50 = c46v23.Shape
          if c46v50 ~= 2 then
            c46v49 = false
          else
            c46v49 = true
          end
          c46v50 = 1
          __renovice_local_1:Name__b77ce959(c46v40, c46v41, c46v42, c46v43, c46v44, c46v45, c46v46, c46v47, c46v48, c46v49, c46v50)
        end
      end
    end
    if ((c46v25 and not c46v12) and c46v34) then
      __renovice_local_0 = c46v24:HasMarkerSpawnEffect()
      if __renovice_local_0 then
        __renovice_state_0 = v30
        if not __renovice_state_0 then
          __renovice_state_0 = 30
        end
        __renovice_local_0 = __renovice_state_0 + c46v0
        v30 = __renovice_local_0
        __renovice_local_0 = v30
        __renovice_state_0 = 30
        if __renovice_state_0 <= __renovice_local_0 then
          __renovice_local_0 = 0
          v30 = __renovice_local_0
          __renovice_local_1 = 17
          c46v24:Name__24dd1e9f(__renovice_local_1)
        end
      end
    end
    do return end
  end
  v132 = function(c47v0)
    local c47v1, c47v2, c47v3, c47v4
    local __renovice_state_0 = 0
    c47v2 = v40
    c47v1 = IsNull
    c47v1 = c47v1(c47v2)
    if not c47v1 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      do return end
    end
    if __renovice_state_0 == 2 then
      c47v1 = GetConfigBool
      c47v2 = "HUD.UseAlternateHud"
      c47v1 = c47v1(c47v2)
      if not c47v1 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      do return end
    end
    if __renovice_state_0 == 4 then
      c47v1 = v48
      v49 = c47v1
      c47v1 = v40
      c47v3 = 0
      c47v1 = c47v1:HasPostureModifier(c47v3)
      if not c47v1 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c47v1 = v41
      c47v1 = c47v1:IsSpaceMode()
      if c47v1 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c47v2 = v48
      c47v1 = c47v2 - c47v0
      v48 = c47v1
      __renovice_state_0 = 8
    end
    if __renovice_state_0 == 7 then
      c47v2 = v48
      c47v1 = c47v2 + c47v0
      v48 = c47v1
      __renovice_state_0 = 8
    end
    if __renovice_state_0 == 8 then
      c47v1 = Clamp
      c47v2 = v48
      c47v3 = 0
      c47v4 = 1
      c47v1 = c47v1(c47v2, c47v3, c47v4)
      v48 = c47v1
      c47v1 = v42
      c47v3 = mMovie
      c47v1:Name__02395800(c47v3)
      c47v1 = v42
      c47v3 = v39
      c47v4 = v43
      c47v1 = c47v1:UpdateFlashMarkers(c47v3, c47v4, c47v0)
      if c47v1 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      do return end
    end
    if __renovice_state_0 == 10 then
      c47v1 = v131
      c47v1(c47v0)
      do return end
    end
    do return end
  end
  v133 = function()
    local c48v0
    c48v0 = true
    v64 = c48v0
    do return end
  end
  OnPlayersChanged = v133
  v133 = function()
    local c49v0, c49v1, c49v2, c49v3, c49v4, c49v5, c49v6, c49v7, c49v8, c49v9, c49v10, c49v11, c49v12, c49v13, c49v14
    c49v0 = false
    v64 = c49v0
    c49v1 = v44
    c49v0 = IsNull
    c49v0 = c49v0(c49v1)
    if not c49v0 then
      c49v0 = v44
      c49v2 = gLotusBaseGameRulesType
      c49v0 = c49v0:IsA(c49v2)
      if c49v0 then
        c49v0 = v44
        c49v0 = c49v0:MissionCompleted()
        if not c49v0 then
          c49v0 = GetConfigBool
          c49v1 = "HUD.UseAlternateHud"
          c49v0 = c49v0(c49v1)
          if not c49v0 then
            c49v0 = GetConfigBool
            c49v1 = "HUD.HideStatusBars"
            c49v0 = c49v0(c49v1)
            if not c49v0 then
              c49v1 = v67
              c49v0 = #c49v1
              if c49v0 == 0 then
                c49v0 = v123
                c49v0()
              end
              c49v0 = gRegion
              c49v0 = c49v0:GetHumanPlayers()
              v60 = c49v0
              c49v0 = {}
              v61 = c49v0
              c49v0 = {}
              v62 = c49v0
              c49v0 = {}
              v63 = c49v0
              c49v0 = ipairs
              c49v1 = C1EB
              c49v0, c49v1, c49v2 = c49v0(c49v1)
              for __renovice_for_0_0, __renovice_for_0_1 in c49v0, c49v1, c49v2 do
                c49v5 = gRegion
                c49v5 = c49v5:FindAll(__renovice_for_0_1)
                c49v6 = ipairs
                c49v6, c49v7, c49v8 = c49v6(c49v5)
                for __renovice_for_1_0, __renovice_for_1_1 in c49v6, c49v7, c49v8 do
                  c49v12 = v63
                  c49v11 = table.insert
                  c49v11(c49v12, __renovice_for_1_1)
                end
              end
              c49v0 = 1
              c49v3 = 1
              c49v1 = 8
              c49v2 = 1
              for __renovice_for_2_0 = c49v3, c49v1, c49v2 do
                local __renovice_state_0 = -1
                c49v5 = nil
                c49v6 = nil
                c49v4 = {c49v5, c49v6}
                c49v6 = v60[__renovice_for_2_0]
                c49v5 = IsNull
                c49v5 = c49v5(c49v6)
                if c49v5 then
                  __renovice_state_0 = -1
                else
                  __renovice_state_0 = 1
                end
                if __renovice_state_0 == 1 then
                  c49v5 = v60[__renovice_for_2_0]
                  c49v5 = c49v5:IsGhost()
                  if c49v5 then
                    __renovice_state_0 = -1
                  else
                    __renovice_state_0 = 2
                  end
                end
                if __renovice_state_0 == 2 then
                  c49v5 = v61
                  c49v6 = v60[__renovice_for_2_0]
                  c49v6 = c49v6:GetAvatar()
                  c49v5[__renovice_for_2_0] = c49v6
                  c49v5 = v60[__renovice_for_2_0]
                  c49v5 = c49v5:IsLocal()
                  if c49v5 then
                    __renovice_state_0 = 7
                  else
                    __renovice_state_0 = 3
                  end
                end
                if __renovice_state_0 == 3 then
                  c49v6 = v60[__renovice_for_2_0]
                  c49v7 = IsNull
                  c49v7 = c49v7(c49v6)
                  if c49v7 then
                    __renovice_state_0 = 5
                  else
                    __renovice_state_0 = 4
                  end
                end
                if __renovice_state_0 == 4 then
                  c49v7 = v2
                  c49v7 = c49v7.GetCrossPlatformUniquePlayerName
                  c49v8 = c49v6:GetPlayerName()
                  c49v9 = v60
                  c49v10 = nil
                  c49v11 = true
                  c49v5 = c49v7(c49v8, c49v9, c49v10, c49v11)
                  __renovice_state_0 = 6
                end
                if __renovice_state_0 == 5 then
                  c49v5 = ""
                  __renovice_state_0 = 6
                end
                if __renovice_state_0 == 6 then
                  c49v4[1] = c49v5
                  c49v5 = v62
                  c49v6 = c49v4[1]
                  c49v5[__renovice_for_2_0] = c49v6
                  __renovice_state_0 = 7
                end
                if __renovice_state_0 == 7 then
                  c49v6 = v61[__renovice_for_2_0]
                  c49v5 = IsNull
                  c49v5 = c49v5(c49v6)
                  if c49v5 then
                    __renovice_state_0 = 14
                  else
                    __renovice_state_0 = 8
                  end
                end
                if __renovice_state_0 == 8 then
                  c49v6 = v61[__renovice_for_2_0]
                  c49v5 = IsNull
                  c49v5 = c49v5(c49v6:InventoryControl())
                  if c49v5 then
                    __renovice_state_0 = 14
                  else
                    __renovice_state_0 = 9
                  end
                end
                if __renovice_state_0 == 9 then
                  c49v5 = v61[__renovice_for_2_0]
                  c49v5 = c49v5:InventoryControl()
                  c49v5 = c49v5:GetSentinel()
                  c49v6 = IsNull
                  c49v6 = c49v6(c49v5)
                  if c49v6 then
                    __renovice_state_0 = 14
                  else
                    __renovice_state_0 = 10
                  end
                end
                if __renovice_state_0 == 10 then
                  c49v6 = v60[__renovice_for_2_0]
                  c49v6 = c49v6:Name__9069c7b8()
                  if not c49v6 then
                    __renovice_state_0 = 12
                  else
                    __renovice_state_0 = 11
                  end
                end
                if __renovice_state_0 == 11 then
                  c49v6 = v60[__renovice_for_2_0]
                  c49v6 = c49v6:GetLoadOut()
                  c49v6 = c49v6.mKubrowPetDetails
                  c49v6 = c49v6.mName
                  c49v4[2] = c49v6
                  __renovice_state_0 = 14
                end
                if __renovice_state_0 == 12 then
                  c49v6 = v60[__renovice_for_2_0]
                  c49v6 = c49v6:Name__6af7fedc()
                  if not c49v6 then
                    __renovice_state_0 = 14
                  else
                    __renovice_state_0 = 13
                  end
                end
                if __renovice_state_0 == 13 then
                  c49v6 = c49v5:GetUIName()
                  c49v4[2] = c49v6
                  __renovice_state_0 = 14
                end
                if __renovice_state_0 ~= 14 then
                  c49v6 = v63[c49v0]
                  c49v5 = IsNull
                  c49v5 = c49v5(c49v6)
                  if not c49v5 then
                    c49v5 = v63[c49v0]
                    c49v6 = c49v5:GetUIName()
                    c49v4[1] = c49v6
                    c49v0 = c49v0 + 1
                  end
                  c49v5 = v61
                  c49v6 = nil
                  c49v5[__renovice_for_2_0] = c49v6
                end
                c49v7 = 1
                c49v5 = 2
                c49v6 = 1
                for __renovice_for_3_0 = c49v7, c49v5, c49v6 do
                  c49v8 = v1
                  c49v8 = c49v8.Ternary
                  if __renovice_for_3_0 ~= 1 then
                    c49v9 = false
                  else
                    c49v9 = true
                  end
                  c49v10 = v67[__renovice_for_2_0]
                  c49v10 = c49v10.Player
                  c49v11 = v67[__renovice_for_2_0]
                  c49v11 = c49v11.Kubrow
                  c49v8 = c49v8(c49v9, c49v10, c49v11)
                  c49v9 = c49v8.clipName
                  c49v10 = c49v4[__renovice_for_3_0]
                  if (c49v10 == nil and c49v9 ~= "Teammate1") then
                    c49v10 = mMovie
                    c49v10 = c49v10:HasVariable(c49v9)
                    if not c49v10 then
                      continue
                    end
                    c49v10 = FlashMethod
                    c49v11 = mMovie
                    c49v13 = c49v8.clipName
                    c49v14 = ".removeMovieClip"
                    c49v12 = c49v13 .. c49v14
                    c49v10(c49v11, c49v12)
                    c49v10 = nil
                    c49v8.IsVisible = c49v10
                    c49v10 = nil
                    c49v8.IsLiteMode = c49v10
                    c49v10 = nil
                    c49v8.LastDisplayName = c49v10
                    c49v10 = false
                    c49v8.HasClip = c49v10
                  end
                end
              end
              do return end
            end
          end
          do return end
        end
      end
    end
    do return end
  end
  v134 = function(c50v0)
    local c50v1, c50v2, c50v3, c50v4, c50v5
    c50v2 = v40
    c50v1 = IsNull
    c50v1 = c50v1(c50v2)
    if not c50v1 then
      c50v2 = v74
      c50v2 = c50v2.DuviriCaveZones
      c50v1 = IsNull
      c50v1 = c50v1(c50v2)
      if not c50v1 then
        c50v1 = c50v0:GetZone()
        c50v2 = ipairs
        c50v3 = v74
        c50v3 = c50v3.DuviriCaveZones
        c50v2, c50v3, c50v4 = c50v2(c50v3)
        for __renovice_for_0_0, __renovice_for_0_1 in c50v2, c50v3, c50v4 do
          if __renovice_for_0_1 ~= c50v1 then
            continue
          end
          c50v5 = true
          do return c50v5 end
        end
        c50v2 = false
        do return c50v2 end
      end
    end
    c50v1 = false
    do return c50v1 end
  end
  v135 = Vector
  v135 = v135()
  v136 = function(c51v0)
    local c51v1, c51v2, c51v3, c51v4, c51v5, c51v6, c51v7, c51v8, c51v9, c51v10, c51v11, c51v12, c51v13, c51v14, c51v15, c51v16, c51v17, c51v18, c51v19, c51v20, c51v21, c51v22, c51v23, c51v24, c51v25, c51v26, c51v27, c51v28, c51v29, c51v30, c51v31, c51v32, c51v33
    c51v4 = nil
    c51v7 = v63[c51v4]
    c51v6 = IsNull
    c51v6 = c51v6(c51v7)
    c51v6 = v63[c51v4]
    c51v8 = v40
    c51v7 = IsNull
    c51v7 = c51v7(c51v8)
    c51v7 = Lotus_Game.SpawnIncarnonPost
    c51v8 = v40
    c51v7 = c51v7(c51v8, c51v6)
    c51v5 = nil
    c51v7 = v66[c51v5]
    c51v8 = ""
    c51v7.name = c51v8
    c51v7 = v66[c51v5]
    c51v8 = nil
    c51v7.avatar = c51v8
    c51v7 = v66[c51v5]
    c51v8 = nil
    c51v7.petName = c51v8
    c51v7 = v66[c51v5]
    c51v8 = nil
    c51v7.petAvatar = c51v8
    c51v1 = nil
    c51v5 = c51v4 + c51v1
    c51v6 = v66[c51v5]
    if c51v6 == nil then
      c51v6 = v66
      c51v7 = { name = "", avatar = nil, petName = "", petAvatar = nil }
      c51v6[c51v5] = c51v7
    end
    c51v6 = 8
    c51v7 = c51v6:IsPreDeath()
    if c51v7 then
      c51v7 = v66[c51v5]
      c51v8 = c51v6:GetUIName()
      c51v7.name = c51v8
    else
      c51v7 = v66[c51v5]
      c51v8 = ""
      c51v7.name = c51v8
    end
    c51v7 = v66[c51v5]
    c51v7.avatar = c51v6
    c51v6 = v60[c51v4]
    c51v5 = IsNull
    c51v5 = c51v5(c51v6)
    c51v5 = v60[c51v4]
    c51v6 = nil
    c51v7 = c51v5:IsLocal()
    c51v7 = c51v5:IsGhost()
    c51v7 = IsNull
    c51v7 = c51v7(c51v6)
    c51v7 = Lotus_Game.SpawnIncarnonPost
    c51v8 = v40
    c51v7 = c51v7(c51v8, c51v6)
    c51v7 = v37
    c51v8 = v40
    c51v9 = v40
    local __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c51v9)
    c51v9 = v74
    c51v9 = c51v9.DuviriCaveZones
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c51v9)
    c51v7 = false
    __renovice_local_0 = c51v8:GetZone()
    c51v9 = ipairs
    c51v10 = v74
    c51v10 = c51v10.DuviriCaveZones
    c51v9, c51v10, c51v11 = c51v9(c51v10)
    for __renovice_for_0_0, __renovice_for_0_1 in c51v9, c51v10, c51v11 do
      c51v7 = true
      c51v7 = false
      __renovice_local_0 = c51v6
      c51v10 = v40
      c51v9 = IsNull
      c51v9 = c51v9(c51v10)
      c51v10 = v74
      c51v10 = c51v10.DuviriCaveZones
      c51v9 = IsNull
      c51v9 = c51v9(c51v10)
      c51v8 = false
      c51v9 = __renovice_local_0:GetZone()
      c51v10 = ipairs
      c51v11 = v74
      c51v11 = c51v11.DuviriCaveZones
      c51v10, c51v11, __renovice_for_0_0 = c51v10(c51v11)
      c51v8 = true
      c51v8 = false
      v61[c51v4] = c51v6
      c51v7 = IsNull
      c51v7 = c51v7(c51v6)
      c51v7 = v66[c51v4]
      c51v8 = v62[c51v4]
      c51v7.name = c51v8
      c51v7 = v66[c51v4]
      c51v7.avatar = c51v6
      c51v7 = v66[c51v4]
      c51v7 = c51v7.status
      c51v8 = IsNull
      c51v8 = c51v8(c51v7)
      c51v8 = c51v7.mVisible
      c51v8 = c51v7.mHpShieldDisplayAvatar
      __renovice_local_0 = c51v7.mDamageControl
      c51v8 = IsNull
      c51v8 = c51v8(__renovice_local_0)
      c51v9 = 1
      c51v10 = c51v7.mActiveProcs
      c51v8 = #c51v10
      __renovice_local_0 = 1
      c51v8 = v66[c51v4]
      __renovice_local_0 = nil
      c51v8.status = __renovice_local_0
      c51v6 = nil
      c51v7 = v66[c51v4]
      c51v8 = ""
      c51v7.name = c51v8
      c51v7 = v66[c51v4]
      c51v8 = nil
      c51v7.avatar = c51v8
      c51v7 = c51v5:Name__9069c7b8()
      c51v7 = c51v5:Name__6af7fedc()
      c51v7 = c51v6:InventoryControl()
      c51v8 = c51v7:GetSentinel()
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c51v8)
      __renovice_local_0 = c51v8:IsVisible()
      __renovice_local_0 = c51v7:Name__fc529b76()
      __renovice_local_0 = c51v5:Name__9069c7b8()
      __renovice_local_0 = v66[c51v4]
      __renovice_local_0 = __renovice_local_0.petName
      __renovice_local_0 = v66[c51v4]
      __renovice_local_0.petAvatar = c51v8
      __renovice_local_0 = v66[c51v4]
      c51v9 = nil
      __renovice_local_0.petName = c51v9
      __renovice_local_0 = v66[c51v4]
      c51v9 = nil
      __renovice_local_0.petAvatar = c51v9
      c51v7 = v66[c51v4]
      c51v7 = c51v7.avatar
      c51v8 = IsNull
      c51v8 = c51v8(c51v7)
      c51v7 = c51v5:GetOwnedPowerSuitAvatar()
      __renovice_local_0 = c51v5:IsLocal()
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c51v7)
      __renovice_local_0 = c51v7:IsPreDeath()
      __renovice_local_0 = v66[c51v4]
      __renovice_local_0.avatar = c51v7
      c51v7 = v66[c51v4]
      c51v7 = c51v7.avatar
      if c51v7 ~= nil then
        c51v7 = v66[c51v4]
        c51v8 = ""
        c51v7.name = c51v8
        c51v7 = v66[c51v4]
        c51v8 = nil
        c51v7.avatar = c51v8
      end
      __renovice_local_0 = c51v5:Name__6af7fedc()
      if __renovice_local_0 then
        __renovice_local_0 = v66[c51v4]
        c51v9 = c51v8:GetUIName()
        __renovice_local_0.petName = c51v9
      end
      c51v7 = v66[c51v4]
      c51v7 = c51v7.petAvatar
      if c51v7 ~= nil then
        c51v7 = v66[c51v4]
        c51v8 = nil
        c51v7.petName = c51v8
        c51v7 = v66[c51v4]
        c51v8 = nil
        c51v7.petAvatar = c51v8
      end
      c51v7 = v66[c51v4]
      c51v7 = c51v7.petAvatar
      if c51v7 ~= nil then
        c51v7 = v66[c51v4]
        c51v8 = nil
        c51v7.petName = c51v8
        c51v7 = v66[c51v4]
        c51v8 = nil
        c51v7.petAvatar = c51v8
      end
      c51v2 = v40
      c51v1 = IsNull
      c51v1 = c51v1(c51v2)
      if c51v1 then
        do return end
      end
      c51v2 = v60
      c51v1 = #c51v2
      c51v4 = 1
      c51v2 = c51v1
      c51v3 = 1
      c51v5 = v66[c51v4]
      if c51v5 == nil then
        c51v5 = v66
        c51v6 = { name = "", avatar = nil, petName = nil, petAvatar = nil }
        c51v5[c51v4] = c51v6
      end
      c51v5 = 8
      c51v7 = v3
      c51v7 = c51v7.GetPlayerAvatar
      c51v9 = v61
      __renovice_local_0 = c51v9[c51v4]
      c51v6 = c51v7(c51v5, __renovice_local_0)
      c51v7 = IsNull
      c51v7 = c51v7(c51v6)
      if not c51v7 then
        __renovice_local_0 = gLotusVehicleAvatarType
        c51v7 = c51v6:IsA(__renovice_local_0)
        if c51v7 then
          __renovice_local_0 = v24
          c51v7 = c51v6:IsA(__renovice_local_0)
          if not c51v7 then
            c51v7 = c51v6:GetRider()
            c51v8 = IsNull
            c51v8 = c51v8(c51v7)
            if not c51v8 then
              c51v6 = c51v7
            end
          end
        end
      end
      c51v8 = v40
      c51v7 = IsNull
      c51v7 = c51v7(c51v8)
      c51v11 = c51v7.mActiveProcs
      c51v10 = c51v11[c51v9]
      c51v11 = 0
      if c51v11 < c51v10 then
        __renovice_for_0_0 = v32
        c51v11 = __renovice_for_0_0[c51v9]
        if c51v11 ~= nil then
          __renovice_for_0_0 = v32
          c51v11 = __renovice_for_0_0[c51v9]
          c51v11 = c51v11.Icon
          if c51v11 ~= nil then
            c51v11 = v1
            c51v11 = c51v11.Ternary
            __renovice_for_0_1 = 1
            if not (__renovice_for_0_1 < c51v10) then
              __renovice_for_0_0 = false
            else
              __renovice_for_0_0 = true
            end
            c51v14 = ""
            c51v11 = c51v11(__renovice_for_0_0, c51v10, c51v14)
            __renovice_for_0_1 = v66
            __renovice_for_0_0 = __renovice_for_0_1[c51v4]
            c51v14 = v66[c51v4]
            c51v14 = c51v14.name
            c51v15 = " "
            c51v16 = v32[c51v9]
            c51v16 = c51v16.Icon
            __renovice_for_0_1 = c51v14 .. c51v15 .. c51v16 .. c51v11
            __renovice_for_0_0.name = __renovice_for_0_1
          end
        end
      end
      c51v7 = IsNull
      c51v7 = c51v7(c51v6)
      if c51v7 then
        c51v7 = v3
        c51v7 = c51v7.GetPlayerAvatar
        __renovice_local_0 = v61[c51v4]
        c51v6 = c51v7(c51v5, __renovice_local_0)
        v61[c51v4] = c51v6
      end
      c51v7 = IsNull
      c51v7 = c51v7(c51v6)
      __renovice_local_0 = gLotusOperatorAvatarType
      c51v7 = c51v6:IsA(__renovice_local_0)
      if c51v7 then
        c51v6 = c51v5:GetOwnedPowerSuitAvatar()
      end
      c51v7 = IsNull
      c51v7 = c51v7(c51v6)
      __renovice_local_0 = v66[c51v4]
      __renovice_local_0 = __renovice_local_0.loadoutPetName
      if __renovice_local_0 == nil then
        __renovice_local_0 = c51v5:GetLoadOut()
        c51v9 = v66[c51v4]
        c51v10 = __renovice_local_0.mKubrowPetDetails
        c51v10 = c51v10.mName
        c51v9.loadoutPetName = c51v10
      end
      __renovice_local_0 = v66[c51v4]
      __renovice_local_0 = __renovice_local_0.loadoutPetName
      if __renovice_local_0 == "" then
        __renovice_local_0 = c51v8:InventoryControl()
        c51v9 = IsNull
        c51v9 = c51v9(__renovice_local_0)
        if not c51v9 then
          c51v9 = __renovice_local_0:GetActivePowerSuit()
          c51v10 = IsNull
          c51v10 = c51v10(c51v9)
          if not c51v10 then
            c51v10 = v66[c51v4]
            c51v11 = mMovie
            __renovice_for_0_1 = c51v9:GetLocalizeTag()
            __renovice_for_0_1 = __renovice_for_0_1:c_str()
            c51v14 = false
            c51v11 = c51v11:GetLocalized(__renovice_for_0_1, c51v14)
            c51v10.petName = c51v11
          end
        end
      else
        __renovice_local_0 = v66[c51v4]
        c51v9 = v66[c51v4]
        c51v9 = c51v9.loadoutPetName
        __renovice_local_0.petName = c51v9
      end
      __renovice_local_0 = v6
      __renovice_local_0 = __renovice_local_0.GetUpgradeLevel
      c51v10 = v28
      __renovice_local_0 = __renovice_local_0(c51v7, c51v10)
      c51v9 = 0
      do
        local __renovice_unused_condition_0 = c51v9 < __renovice_local_0
      end
      c51v10 = gLotusOperatorAvatarType
      __renovice_local_0 = c51v7:IsA(c51v10)
    end
    c51v4 = 1
    c51v5 = v63
    c51v2 = #c51v5
    c51v3 = 1
    c51v4 = 1
    c51v6 = v63
    c51v5 = #c51v6
    c51v2 = c51v1 + c51v5
    c51v3 = 1
    if not ((c51v3 > 0 and c51v4 > c51v2) or (c51v3 < 0 and c51v4 < c51v2)) then
      c51v7 = 1
      c51v5 = 2
      c51v6 = 1
      for __renovice_for_1_0 = c51v7, c51v5, c51v6 do
        c51v8 = v66[c51v4]
        __renovice_local_0 = v1
        __renovice_local_0 = __renovice_local_0.Ternary
        if __renovice_for_1_0 ~= 1 then
          c51v9 = false
        else
          c51v9 = true
        end
        c51v10 = c51v8.avatar
        c51v11 = c51v8.petAvatar
        __renovice_local_0 = __renovice_local_0(c51v9, c51v10, c51v11)
        c51v9 = v1
        c51v9 = c51v9.Ternary
        if __renovice_for_1_0 ~= 1 then
          c51v10 = false
        else
          c51v10 = true
        end
        c51v11 = c51v8.name
        c51v12 = c51v8.petName
        c51v9 = c51v9(c51v10, c51v11, c51v12)
        c51v10 = nil
        c51v11 = v67[c51v4]
        if c51v11 ~= nil then
          c51v11 = v1
          c51v11 = c51v11.Ternary
          if __renovice_for_1_0 ~= 1 then
            c51v12 = false
          else
            c51v12 = true
          end
          c51v13 = v67[c51v4]
          c51v13 = c51v13.Player
          c51v14 = v67[c51v4]
          c51v14 = c51v14.Kubrow
          c51v10 = c51v11(c51v12, c51v13, c51v14)
        end
        c51v11 = IsNull
        c51v11 = c51v11(__renovice_local_0)
        c51v11 = __renovice_local_0:DamageControl()
        c51v12 = c51v11:IsPreDeath()
        if c51v12 then
          c51v15 = v25
          c51v13 = c51v11:IsA(c51v15)
          if c51v13 then
            c51v12 = false
          end
        end
        c51v13 = __renovice_local_0:GetHealth()
        c51v14 = v36
        if c51v14 then
          c51v14 = __renovice_local_0:IsAvatarFriendly(c51v0)
        end
        c51v15 = c51v12
        if c51v15 then
          c51v15 = __renovice_local_0:CanBeRevived()
        end
        c51v16 = __renovice_local_0:IsAgentPaused()
        c51v17 = v69
        if c51v17 then
          c51v18 = v35
          c51v19 = v3
          c51v19 = c51v19.UI_MODE_IN_SPACE_HUB
          if c51v18 == c51v19 then
            c51v17 = false
          else
            c51v17 = true
          end
        end
        c51v18 = v36
        if (c51v18 and c51v17) then
          c51v17 = c51v14
        end
        c51v18 = v72
        if (c51v18 ~= nil and c51v17) then
          c51v19 = c51v0:EyePosition()
          c51v20 = __renovice_local_0:GetPosition()
          c51v21 = v68
          c51v23 = c51v20 - c51v19
          c51v22 = c51v23 * c51v21
          c51v25 = c51v22.x
          c51v26 = c51v22.x
          c51v24 = c51v25 * c51v26
          c51v26 = c51v22.y
          c51v27 = c51v22.y
          c51v25 = c51v26 * c51v27
          c51v23 = c51v24 + c51v25
          c51v25 = c51v22.z
          c51v26 = c51v22.z
          c51v24 = c51v25 * c51v26
          c51v18 = c51v23 + c51v24
          c51v19 = v72
          if not (c51v18 < c51v19) then
            c51v17 = false
          else
            c51v17 = true
          end
        end
        c51v18 = c51v10.clipName
        c51v19 = c51v10.HasClip
        if not c51v19 then
          c51v19 = mMovie
          c51v19 = c51v19:HasVariable(c51v18)
          if not c51v19 then
            c51v21 = c51v4 * 2
            c51v22 = 2 - __renovice_for_1_0
            c51v20 = c51v21 - c51v22
            c51v19 = c51v20 + 3000
            c51v20 = FlashMethod
            c51v21 = mMovie
            c51v22 = "Teammate1.duplicateMovieClip"
            c51v20(c51v21, c51v22, c51v18, c51v19)
            c51v20 = v120
            c51v23 = ".Progress"
            c51v21 = c51v18 .. c51v23
            c51v20(c51v21)
            c51v20 = mMovie
            c51v23 = "Name"
            c51v24 = 44
            c51v25 = v73
            c51v25 = c51v25.Text
            c51v20:Name__52c1b74e(c51v18, c51v23, c51v24, c51v25)
            c51v20 = mMovie
            c51v23 = "Range"
            c51v24 = 44
            c51v25 = v73
            c51v25 = c51v25.Text
            c51v20:Name__52c1b74e(c51v18, c51v23, c51v24, c51v25)
            c51v20 = mMovie
            c51v23 = 13
            c51v24 = false
            c51v20:Name__d9713943(c51v18, c51v23, c51v24)
            c51v20 = false
            c51v10.IsVisible = c51v20
          end
          c51v19 = true
          c51v10.HasClip = c51v19
        end
        c51v19 = nil
        c51v20 = 0
        c51v21 = v36
        c51v21 = pairs
        c51v22 = v46
        c51v21, c51v22, c51v23 = c51v21(c51v22)
        c51v26 = c51v25.garbage
        c51v26 = c51v25.markerType
        c51v27 = 4
        c51v26 = c51v25:Name__f90dc2bb()
        c51v27 = IsNull
        c51v27 = c51v27(c51v26)
        c51v27 = c51v26:Name__9aafa382()
        c51v28 = IsNull
        c51v28 = c51v28(c51v27)
        c51v28 = mMovie
        c51v30 = Vector
        c51v31 = c51v25.pos
        c51v31 = c51v31.x
        c51v33 = c51v25.pos
        c51v33 = c51v33.y
        c51v32 = c51v33 + 0.2
        c51v33 = c51v25.pos
        c51v33 = c51v33.z
        c51v19 = c51v28:ProjectPosition(c51v30(c51v31, c51v32, c51v33))
        c51v20 = c51v25.distanceToEye
        if c51v20 == 0 then
          c51v21 = v1
          c51v21 = c51v21.Round
          c51v22 = Distance
          c51v23 = c51v0:EyePosition()
          c51v20 = c51v21(c51v22(c51v23, __renovice_local_0:GetPosition()))
        end
        if c51v19 == nil then
          c51v23 = v135
          c51v24 = 1
          c51v11:Name__d3272b1d(c51v23, c51v24)
          c51v21 = v135
          c51v23 = v135
          c51v23 = c51v23.y
          c51v22 = c51v23 + 0.35
          c51v21.y = c51v22
          c51v23 = gLotusMoaPetAvatarType
          c51v21 = __renovice_local_0:IsA(c51v23)
          if c51v21 then
            c51v23 = v23
            c51v21 = __renovice_local_0:IsA(c51v23)
            if c51v21 then
              c51v21 = v135
              c51v23 = v135
              c51v23 = c51v23.y
              c51v22 = c51v23 - 0.2
              c51v21.y = c51v22
            else
              c51v21 = v135
              c51v23 = v135
              c51v23 = c51v23.y
              c51v22 = c51v23 + 0.25
              c51v21.y = c51v22
            end
          else
            c51v23 = v24
            c51v21 = __renovice_local_0:IsA(c51v23)
            if c51v21 then
              c51v21 = __renovice_local_0:Name__7a4d0a2b()
              v135 = c51v21
            end
          end
          c51v21 = mMovie
          c51v23 = v135
          c51v19 = c51v21:ProjectPosition(c51v23)
        end
        c51v21 = false
        c51v22 = c51v19.z
        c51v23 = 0
        if c51v23 < c51v22 then
          c51v21 = false
          c51v22 = c51v19.z
          c51v23 = 1
          if c51v22 < c51v23 then
            c51v22 = 0
            if not (c51v22 < c51v13) then
              c51v21 = false
            else
              c51v21 = true
            end
          end
        end
        c51v22 = c51v10.IsVisible
        if c51v22 ~= c51v21 then
          c51v22 = mMovie
          c51v25 = 13
          c51v22:Name__d9713943(c51v18, c51v25, c51v21)
          c51v10.IsVisible = c51v21
        end
        c51v22 = c51v10.IsVisible
        c51v22 = mMovie
        c51v25 = 0
        c51v26 = v1
        c51v26 = c51v26.Round
        c51v27 = c51v19.x
        c51v22:SetNumberVariable(c51v18, c51v25, c51v26(c51v27))
        c51v22 = mMovie
        c51v25 = 1
        c51v27 = v1
        c51v27 = c51v27.Round
        c51v28 = c51v19.y
        c51v27 = c51v27(c51v28)
        c51v26 = c51v27 - 32
        c51v22:SetNumberVariable(c51v18, c51v25, c51v26)
        if c51v17 then
          c51v22 = v1
          c51v22 = c51v22.Ternary
          c51v24 = v3
          c51v24 = c51v24.HIDDEN_PLAYER_NAME
          if c51v9 ~= c51v24 then
            c51v23 = false
          else
            c51v23 = true
          end
          c51v24 = ""
          c51v22 = c51v22(c51v23, c51v24, c51v9)
          c51v23 = c51v10.LastDisplayName
          if c51v23 ~= c51v22 then
            c51v23 = mMovie
            c51v27 = ".Name"
            c51v25 = c51v18 .. c51v27
            c51v26 = 36
            c51v23:SetStringVariable(c51v25, c51v26, c51v22)
            c51v10.LastDisplayName = c51v22
          end
        end
        c51v22 = v36
        c51v22 = __renovice_local_0:GetReviveProgress()
        c51v23 = false
        c51v10.IsLiteMode = c51v23
        c51v23 = IsNull
        c51v23 = c51v23(c51v0)
        c51v25 = gLotusAvatarType
        c51v23 = c51v0:IsA(c51v25)
        c51v23 = c51v0:GetReviveTarget()
        c51v25 = v8
        c51v25 = c51v25.EYES_BUFF_SYM
        c51v23 = __renovice_local_0:HasTag(c51v25)
        c51v23 = c51v10.mTrackRevive
        if not c51v23 then
          c51v23 = v1
          c51v23 = c51v23.PlaySound
          c51v24 = allyReviveStartSound
          c51v23(c51v24)
          c51v24 = v97
          c51v23 = IsNull
          c51v23 = c51v23(c51v24)
          if c51v23 then
            c51v23 = v1
            c51v23 = c51v23.PlaySound
            c51v24 = allyReviveLoopSound
            c51v23 = c51v23(c51v24)
            v97 = c51v23
          end
        end
        c51v23 = true
        c51v10.mTrackRevive = c51v23
        c51v23 = c51v10.mTrackRevive
        if c51v23 then
          c51v23 = false
          c51v10.mTrackRevive = c51v23
          c51v24 = v97
          c51v23 = IsNull
          c51v23 = c51v23(c51v24)
          if not c51v23 then
            c51v23 = v97
            c51v25 = false
            c51v23:Stop(c51v25)
            c51v23 = nil
            v97 = c51v23
          end
        end
        c51v23 = c51v10.mTrackRevive
        c51v23 = 0
        c51v23 = v1
        c51v23 = c51v23.Round
        c51v24 = c51v22 * 100
        c51v23 = c51v23(c51v24)
        c51v24 = FlashMethod
        c51v25 = mMovie
        c51v28 = ".Progress.Fill.gotoAndStop"
        c51v26 = c51v18 .. c51v28
        c51v27 = c51v23 + 1
        c51v24(c51v25, c51v26, c51v27)
        c51v24 = mMovie
        c51v27 = "Progress.Pct"
        c51v28 = 36
        c51v32 = v1
        c51v32 = c51v32.FormatNumber
        c51v30 = c51v32(c51v23)
        c51v31 = "%"
        c51v29 = c51v30 .. c51v31
        c51v24:Name__f4a9016a(c51v18, c51v27, c51v28, c51v29)
        c51v24 = mMovie
        c51v27 = "Progress"
        c51v28 = 13
        c51v29 = true
        c51v24:Makeposshield(c51v18, c51v27, c51v28, c51v29)
        c51v24 = mMovie
        c51v27 = "Range"
        c51v28 = 13
        c51v29 = false
        c51v24:Makeposshield(c51v18, c51v27, c51v28, c51v29)
        c51v23 = mMovie
        c51v26 = "Progress"
        c51v27 = 13
        c51v28 = false
        c51v23:Makeposshield(c51v18, c51v26, c51v27, c51v28)
        c51v23 = mMovie
        c51v26 = "Range"
        c51v27 = 36
        c51v28 = mMovie
        c51v30 = "/Lotus/Language/Game/UNIT_METER"
        c51v31 = false
        c51v32 = { COUNT = nil }
        c51v32.COUNT = c51v20
        c51v23:Name__f4a9016a(c51v18, c51v26, c51v27, c51v28:GetLocalized(c51v30, c51v31, c51v32))
        c51v23 = mMovie
        c51v26 = "Range"
        c51v27 = 13
        c51v28 = true
        c51v23:Makeposshield(c51v18, c51v26, c51v27, c51v28)
        c51v23 = c51v10.HealthAndShieldAvatar
        if c51v23 ~= __renovice_local_0 then
          c51v10.HealthAndShieldAvatar = __renovice_local_0
          c51v24 = c51v10.HealthAndShield
          c51v23 = IsNull
          c51v23 = c51v23(c51v24)
          if c51v23 then
            c51v23 = 3
            c51v24 = gRegion
            c51v24 = c51v24:IsMaster()
            if not c51v24 then
              c51v23 = 4
            end
            c51v24 = gRegion
            c51v26 = v9
            c51v27 = nil
            c51v24 = c51v24:CreateObject(c51v26, c51v27, c51v23)
            c51v10.HealthAndShield = c51v24
          end
          c51v23 = c51v10.HealthAndShield
          c51v25 = mMovie
          c51v27 = 100
          c51v30 = ".HealthBar"
          c51v28 = c51v18 .. c51v30
          c51v31 = ".HealthLabel"
          c51v29 = c51v18 .. c51v31
          c51v23:Setup(c51v25, __renovice_local_0, c51v27, c51v28, c51v29)
          c51v23 = c51v10.HealthAndShield
          c51v25 = true
          c51v23:ShowRecoveryArrow(c51v25)
          c51v23 = c51v10.HealthAndShield
          c51v25 = true
          c51v23:Name__82e00447(c51v25)
          c51v23 = c51v10.HealthAndShield
          c51v23:Initialize()
        end
        c51v23 = c51v10.HealthAndShield
        c51v25 = DeltaTime
        c51v23:Update(c51v25())
        c51v23 = mMovie
        c51v26 = "HealthLabel"
        c51v27 = 13
        c51v28 = true
        c51v23:Makeposshield(c51v18, c51v26, c51v27, c51v28)
        c51v22 = c51v10.IsLiteMode
        if (not c51v22 and (c51v14 or c51v17)) then
          c51v22 = mMovie
          c51v25 = "Progress"
          c51v26 = 13
          c51v27 = false
          c51v22:Makeposshield(c51v18, c51v25, c51v26, c51v27)
          c51v22 = mMovie
          c51v25 = "Range"
          c51v26 = 13
          c51v27 = false
          c51v22:Makeposshield(c51v18, c51v25, c51v26, c51v27)
          c51v22 = mMovie
          c51v25 = "HealthLabel"
          c51v26 = 13
          c51v27 = false
          c51v22:Makeposshield(c51v18, c51v25, c51v26, c51v27)
          c51v22 = mMovie
          c51v25 = "HealthBar"
          c51v26 = 13
          c51v27 = false
          c51v22:Makeposshield(c51v18, c51v25, c51v26, c51v27)
          c51v22 = true
          c51v10.IsLiteMode = c51v22
        end
        c51v19 = mMovie
        c51v22 = 13
        c51v23 = false
        c51v19:Name__d9713943(c51v18, c51v22, c51v23)
        c51v19 = false
        c51v10.IsVisible = c51v19
        c51v19 = c51v10.wasBeingRevived
        if not c51v19 then
          c51v19 = __renovice_local_0:IsBeingRevived()
          if c51v19 then
            c51v19 = true
            c51v10.wasBeingRevived = c51v19
          end
        end
        c51v19 = v36
        c51v19 = c51v10.isPredeath
        c51v19 = v3
        c51v19 = c51v19.HIDDEN_PLAYER_NAME
        c51v10.isPredeath = c51v12
        c51v19 = false
        c51v10.mTrackRevive = c51v19
        c51v20 = v97
        c51v19 = IsNull
        c51v19 = c51v19(c51v20)
        if not c51v19 then
          c51v19 = v97
          c51v21 = false
          c51v19:Stop(c51v21)
          c51v19 = nil
          v97 = c51v19
        end
        c51v19 = c51v9
        if c51v19 == "" then
          c51v20 = IsNull
          c51v20 = c51v20(__renovice_local_0)
          if not c51v20 then
            c51v19 = __renovice_local_0:GetUIName()
          end
        end
        c51v20 = IsNull
        c51v20 = c51v20(__renovice_local_0)
        c51v22 = gLotusSentinelAvatarType
        c51v20 = __renovice_local_0:IsA(c51v22)
        c51v20 = __renovice_local_0:GetCreatorAvatar()
        c51v20 = ""
        if c51v12 then
          c51v21 = mMovie
          c51v23 = "/Lotus/Language/Menu/HUD_IsDown"
          c51v24 = false
          c51v25 = { PLAYER = nil }
          c51v25.PLAYER = c51v19
          c51v20 = c51v21:GetLocalized(c51v23, c51v24, c51v25)
        else
          c51v21 = 0
          if c51v21 < c51v13 then
            c51v23 = gLotusSentinelAvatarType
            c51v21 = __renovice_local_0:IsA(c51v23)
            if c51v21 then
              c51v21 = mMovie
              c51v23 = "/Lotus/Language/SystemMessages/HUD_SelfRevived"
              c51v24 = false
              c51v25 = { COMPANION = nil }
              c51v25.COMPANION = c51v19
              c51v20 = c51v21:GetLocalized(c51v23, c51v24, c51v25)
            else
              c51v21 = v1
              c51v21 = c51v21.PlaySound
              c51v22 = allyReviveSuccessSound
              c51v21(c51v22)
              c51v21 = mMovie
              c51v23 = "/Lotus/Language/Menu/HUD_BeenRevived"
              c51v24 = false
              c51v25 = { PLAYER = nil }
              c51v25.PLAYER = c51v19
              c51v20 = c51v21:GetLocalized(c51v23, c51v24, c51v25)
              c51v21 = false
              c51v10.wasBeingRevived = c51v21
              c51v21 = false
              c51v10.showRevived = c51v21
            end
          else
            c51v21 = 0
            if c51v13 <= c51v21 then
              c51v21 = c51v10.wasBeingRevived
              c51v10.showRevived = c51v21
              c51v21 = false
              c51v10.wasBeingRevived = c51v21
              c51v21 = c51v10.showRevived
              if c51v21 then
                c51v21 = mMovie
                c51v23 = "/Lotus/Language/SystemMessages/HUD_SelfRevived"
                c51v24 = false
                c51v25 = { COMPANION = nil }
                c51v25.COMPANION = c51v19
                c51v20 = c51v21:GetLocalized(c51v23, c51v24, c51v25)
              else
                c51v21 = mMovie
                c51v23 = "/Lotus/Language/Menu/HUD_HasDied"
                c51v24 = false
                c51v25 = { PLAYER = nil }
                c51v25.PLAYER = c51v19
                c51v20 = c51v21:GetLocalized(c51v23, c51v24, c51v25)
              end
              c51v21 = false
              c51v10.showRevived = c51v21
            end
          end
        end
        if c51v20 ~= "" then
          c51v22 = v45
          c51v21 = IsNull
          c51v21 = c51v21(c51v22)
          if not c51v21 then
            c51v21 = v45
            c51v23 = "ShowGameplayMessage"
            c51v21:Execute(c51v23, c51v20)
          end
        end
        c51v20 = c51v12
        if c51v20 then
          c51v20 = not c51v16
        end
        c51v21 = mMovie
        c51v25 = ".Name"
        c51v23 = c51v18 .. c51v25
        c51v24 = 36
        c51v21:SetStringVariable(c51v23, c51v24, c51v9)
        c51v21 = c51v10.IsVisible
        if c51v21 ~= c51v20 then
          c51v21 = mMovie
          c51v24 = 13
          c51v21:Name__d9713943(c51v18, c51v24, c51v20)
          c51v10.IsVisible = c51v20
        end
        c51v11 = c51v10.clipName
        c51v12 = c51v10.IsVisible
        if c51v12 == false then
          continue
        end
        c51v12 = mMovie
        c51v15 = 13
        c51v16 = false
        c51v12:Name__d9713943(c51v11, c51v15, c51v16)
        c51v12 = false
        c51v10.IsVisible = c51v12
      end
    end
    do return end
  end
  v137 = function(c53v0)
    local c53v1, c53v2, c53v3, c53v4, c53v5, c53v6, c53v7, c53v8, c53v9, c53v10, c53v11, c53v12, c53v13, c53v14, c53v15
    c53v2 = v75
    c53v1 = #c53v2
    c53v2 = nil
    c53v3 = true
    c53v5 = v40
    c53v4 = IsNull
    c53v4 = c53v4(c53v5)
    if not c53v4 then
      c53v4 = v40
      c53v4 = c53v4:IsKilled()
      if not c53v4 then
        c53v4 = v40
        c53v4 = c53v4:IsPreDeath()
        if not c53v4 then
          c53v6 = 1
          c53v4 = c53v1
          c53v5 = 1
          for __renovice_for_0_0 = c53v6, c53v4, c53v5 do
            c53v8 = v75[__renovice_for_0_0]
            c53v7 = IsNull
            c53v7 = c53v7(c53v8)
            if c53v7 then
              continue
            end
            c53v7 = v75[__renovice_for_0_0]
            c53v7 = c53v7.mAvatar
            if c53v7 ~= c53v0 then
              continue
            end
            c53v7 = v75[__renovice_for_0_0]
            c53v2 = c53v7.mExclusiveDamageIndicatorClipName
            c53v7 = v40
            c53v7 = c53v7:InventoryControl()
            c53v9 = 0
            c53v7 = c53v7:Name__23991ed1(c53v9)
            c53v8 = IsNull
            c53v8 = c53v8(c53v7)
            if c53v8 then
              continue
            end
            c53v8 = c53v7:GetDamageType()
            c53v9 = v75[__renovice_for_0_0]
            c53v9 = c53v9.mExclusiveDamageType
            if c53v8 ~= c53v9 then
              continue
            end
            c53v3 = false
          end
          if (c53v2 ~= nil and c53v3) then
            c53v4 = mMovie
            c53v7 = 13
            c53v4 = c53v4:Name__9d78ed52(c53v2, c53v7)
            if c53v4 then
              c53v5 = c53v0:DamageControl()
              c53v5 = c53v5:Name__aa25fa49()
              c53v6 = IsNull
              c53v6 = c53v6(c53v5)
              if not c53v6 then
                c53v6 = c53v5:GetSource()
                c53v7 = v40
                if c53v6 == c53v7 then
                  c53v7 = FlashInterpolate
                  c53v8 = mMovie
                  c53v11 = ".ExclusiveBacker"
                  c53v9 = c53v2 .. c53v11
                  c53v10 = 0
                  c53v12 = 14
                  c53v13 = 15
                  c53v14 = 12
                  c53v11 = {c53v12, c53v13, c53v14}
                  c53v13 = 40
                  c53v14 = 40
                  c53v15 = 100
                  c53v12 = {c53v13, c53v14, c53v15}
                  c53v13 = 0.2
                  c53v14 = 0
                  c53v15 = function()
                    local c52v0, c52v1, c52v2, c52v3, c52v4, c52v5, c52v6, c52v7, c52v8
                    c52v0 = FlashInterpolate
                    c52v1 = mMovie
                    c52v3 = c53v2
                    c52v4 = ".ExclusiveBacker"
                    c52v2 = c52v3 .. c52v4
                    c52v3 = 0
                    c52v5 = 14
                    c52v6 = 15
                    c52v7 = 12
                    c52v4 = {c52v5, c52v6, c52v7}
                    c52v6 = 32
                    c52v7 = 32
                    c52v8 = 0
                    c52v5 = {c52v6, c52v7, c52v8}
                    c52v6 = 0.2
                    c52v7 = 0
                    c52v8 = nil
                    c52v0(c52v1, c52v2, c52v3, c52v4, c52v5, c52v6, c52v7, c52v8)
                    do return end
                  end
                  c53v7(c53v8, c53v9, c53v10, c53v11, c53v12, c53v13, c53v14, c53v15)
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
  OnDamaged = v137
  v137 = function(c54v0, c54v1)
    local c54v2, c54v3, c54v4, c54v5, c54v6, c54v7, c54v8, c54v9, c54v10, c54v11
    c54v2 = c54v1.mName
    c54v3 = c54v1.mLevel
    local __renovice_local_0 = ""
    c54v1.mName = __renovice_local_0
    __renovice_local_0 = ""
    c54v1.mLevel = __renovice_local_0
    __renovice_local_0 = false
    c54v1.mIsAIEnemyAvatar = __renovice_local_0
    __renovice_local_0 = false
    c54v1.mIsEnemyAvatar = __renovice_local_0
    c54v4 = c54v1.mAvatar
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c54v4)
    if not __renovice_local_0 then
      __renovice_local_0 = c54v1.mAvatar
      c54v4 = __renovice_local_0:GetPlayer()
      c54v5 = IsNull
      c54v5 = c54v5(c54v4)
      if c54v5 then
        c54v5 = IsNull
        c54v5 = c54v5(__renovice_local_0)
        if not c54v5 then
          c54v5 = __renovice_local_0:IsAttached()
          if c54v5 then
            c54v5 = __renovice_local_0:GetAttachParent()
            c54v6 = IsNull
            c54v6 = c54v6(c54v5)
            if not c54v6 then
              c54v8 = gLotusVehicleAvatarType
              c54v6 = c54v5:IsA(c54v8)
              if c54v6 then
                c54v4 = c54v5:GetPlayer()
              end
            end
          end
        end
      end
      c54v5 = IsNull
      c54v5 = c54v5(c54v4)
      if c54v5 then
        local __renovice_state_0 = -1
        c54v5 = v69
        if not c54v5 then
          __renovice_state_0 = -1
        else
          __renovice_state_0 = 1
        end
        if __renovice_state_0 == 1 then
          c54v5 = __renovice_local_0:GetFaction()
          c54v6 = c54v0:GetFaction()
          if c54v5 ~= c54v6 then
            __renovice_state_0 = -1
          else
            __renovice_state_0 = 2
          end
        end
        if __renovice_state_0 == 2 then
          c54v5 = IsNull
          c54v5 = c54v5(__renovice_local_0:GetPlayer())
          if not c54v5 then
            __renovice_state_0 = 6
          else
            __renovice_state_0 = 3
          end
        end
        if __renovice_state_0 == 3 then
          c54v7 = gPetAvatarType
          c54v5 = __renovice_local_0:IsA(c54v7)
          if not c54v5 then
            __renovice_state_0 = 5
          else
            __renovice_state_0 = 4
          end
        end
        if __renovice_state_0 == 4 then
          c54v7 = v13
          c54v5 = __renovice_local_0:IsA(c54v7)
          if not c54v5 then
            __renovice_state_0 = 6
          else
            __renovice_state_0 = 5
          end
        end
        if __renovice_state_0 == 5 then
          c54v7 = gLotusRoboPetAvatarType
          c54v5 = __renovice_local_0:IsA(c54v7)
          if not c54v5 then
            __renovice_state_0 = -1
          else
            __renovice_state_0 = 6
          end
        end
        if __renovice_state_0 == 6 then
          c54v5 = ""
          c54v1.mName = c54v5
          __renovice_state_0 = 7
        end
        if __renovice_state_0 ~= 7 then
          c54v7 = C1EB[1]
          c54v5 = __renovice_local_0:IsA(c54v7)
          if c54v5 then
            c54v5 = __renovice_local_0:GetUIName()
            c54v1.mName = c54v5
          else
            c54v5 = true
            c54v1.mIsAIEnemyAvatar = c54v5
            c54v5 = false
            c54v6 = __renovice_local_0:GetFaction()
            c54v7 = c54v0:GetFaction()
            if c54v6 ~= c54v7 then
              c54v6 = __renovice_local_0:IsFactionFriendly(c54v0:GetFaction())
              c54v5 = not c54v6
            end
            c54v1.mIsEnemyAvatar = c54v5
            c54v5 = v70
            if c54v5 then
              c54v5 = __renovice_local_0:GetUIName()
              c54v1.mName = c54v5
            end
            c54v5 = __renovice_local_0:ShowLevelInHud()
            if c54v5 then
              c54v5 = _T.HideEnemyLevelsInHUD
              if not c54v5 then
                c54v5 = __renovice_local_0:GetCurrentLevel()
                c54v1.mLevel = c54v5
              end
            end
          end
        end
      else
        repeat
          c54v5 = c54v0:IsAvatarFriendly(__renovice_local_0)
          if c54v5 then
            c54v5 = v69
            if c54v5 then
              c54v5 = ipairs
              c54v6 = v66
              c54v5, c54v6, c54v7 = c54v5(c54v6)
              for __renovice_for_0_0, __renovice_for_0_1 in c54v5, c54v6, c54v7 do
                c54v11 = __renovice_for_0_1.avatar
                c54v10 = IsNull
                c54v10 = c54v10(c54v11)
                if c54v10 then
                  continue
                end
                c54v10 = __renovice_for_0_1.avatar
                if __renovice_local_0 ~= c54v10 then
                  continue
                end
                __renovice_for_0_1.status = c54v1
                break
              end
              c54v5 = ""
              c54v1.mName = c54v5
              break
            end
          end
          repeat
            c54v5 = __renovice_local_0:GetFaction()
            c54v6 = c54v0:GetFaction()
            if c54v5 ~= c54v6 then
              c54v5 = v70
              if not c54v5 then
                c54v5 = ""
                c54v1.mName = c54v5
                break
              end
            end
            c54v6 = c54v4
            c54v7 = IsNull
            c54v7 = c54v7(c54v6)
            if not c54v7 then
              c54v7 = v2
              c54v7 = c54v7.GetCrossPlatformUniquePlayerName
              c54v8 = c54v6:GetPlayerName()
              c54v9 = v60
              c54v10 = nil
              c54v11 = true
              c54v5 = c54v7(c54v8, c54v9, c54v10, c54v11)
            else
              c54v5 = ""
            end
            c54v1.mName = c54v5
          until true
        until true
      end
    else
      c54v4 = c54v1.mDeco
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c54v4)
      if not __renovice_local_0 then
        __renovice_local_0 = c54v1.mDeco
        c54v5 = gPickUpType
        __renovice_local_0 = __renovice_local_0:IsA(c54v5)
        if __renovice_local_0 then
          __renovice_local_0 = c54v1.mDeco
          __renovice_local_0 = __renovice_local_0:GetPickUpItem()
          c54v4 = IsNull
          c54v4 = c54v4(__renovice_local_0)
          if not c54v4 then
            c54v4 = mMovie
            c54v6 = __renovice_local_0:GetLocalizeTag()
            c54v6 = c54v6:c_str()
            c54v7 = false
            c54v4 = c54v4:GetLocalized(c54v6, c54v7)
            c54v1.mName = c54v4
          end
        else
          local __renovice_state_1 = -1
          __renovice_local_0 = c54v1.mDeco
          c54v5 = gDecorationType
          __renovice_local_0 = __renovice_local_0:IsA(c54v5)
          if not __renovice_local_0 then
            __renovice_state_1 = -1
          else
            __renovice_state_1 = 1
          end
          if __renovice_state_1 == 1 then
            __renovice_local_0 = c54v1.mDeco
            __renovice_local_0 = __renovice_local_0:IsScannerRequired()
            if not __renovice_local_0 then
              __renovice_state_1 = -1
            else
              __renovice_state_1 = 2
            end
          end
          if __renovice_state_1 == 2 then
            __renovice_local_0 = v128
            __renovice_local_0 = __renovice_local_0()
            if __renovice_local_0 then
              __renovice_state_1 = -1
            else
              __renovice_state_1 = 3
            end
          end
          if __renovice_state_1 == 3 then
            __renovice_local_0 = mMovie
            c54v5 = "/Lotus/Language/Game/ScannerRequired"
            c54v6 = true
            __renovice_local_0 = __renovice_local_0:GetLocalized(c54v5, c54v6)
            c54v1.mName = __renovice_local_0
            __renovice_state_1 = 4
          end
          if __renovice_state_1 ~= 4 then
            __renovice_local_0 = c54v1.mDeco
            __renovice_local_0 = __renovice_local_0:GetLocTag()
            c54v1.mCachedLocTag = __renovice_local_0
            __renovice_local_0 = mMovie
            c54v5 = c54v1.mCachedLocTag
            c54v5 = c54v5:c_str()
            c54v6 = true
            __renovice_local_0 = __renovice_local_0:GetLocalized(c54v5, c54v6)
            c54v1.mName = __renovice_local_0
          end
        end
      end
    end
    __renovice_local_0 = c54v1.mName
    c54v4 = v3
    c54v4 = c54v4.HIDDEN_PLAYER_NAME
    if __renovice_local_0 == c54v4 then
      __renovice_local_0 = mMovie
      c54v6 = c54v1.mClipName
      c54v7 = ".Name"
      c54v5 = c54v6 .. c54v7
      c54v6 = 36
      c54v7 = mMovie
      c54v9 = "/Lotus/Language/Game/Stalker"
      c54v10 = false
      __renovice_local_0:SetStringVariable(c54v5, c54v6, c54v7:GetLocalized(c54v9, c54v10))
      __renovice_local_0 = mMovie
      c54v6 = c54v1.mClipName
      c54v7 = ".Level"
      c54v5 = c54v6 .. c54v7
      c54v6 = 36
      c54v7 = "30"
      __renovice_local_0:SetStringVariable(c54v5, c54v6, c54v7)
      __renovice_local_0 = mMovie
      c54v5 = c54v1.mClipName
      c54v6 = "UnderLotus"
      c54v7 = 13
      c54v8 = true
      __renovice_local_0:Makeposshield(c54v5, c54v6, c54v7, c54v8)
      do return end
    end
    __renovice_local_0 = c54v1.mName
    if __renovice_local_0 ~= c54v2 then
      __renovice_local_0 = mMovie
      c54v6 = c54v1.mClipName
      c54v7 = ".Name"
      c54v5 = c54v6 .. c54v7
      c54v6 = 36
      c54v7 = c54v1.mName
      __renovice_local_0:SetStringVariable(c54v5, c54v6, c54v7)
    end
    __renovice_local_0 = c54v1.mLevel
    if __renovice_local_0 ~= c54v3 then
      __renovice_local_0 = mMovie
      c54v6 = c54v1.mClipName
      c54v7 = ".Level"
      c54v5 = c54v6 .. c54v7
      c54v6 = 36
      c54v7 = c54v1.mLevel
      __renovice_local_0:SetStringVariable(c54v5, c54v6, c54v7)
      __renovice_local_0 = mMovie
      c54v5 = c54v1.mClipName
      c54v6 = "UnderLotus"
      c54v7 = 13
      c54v9 = c54v1.mLevel
      if c54v9 == "" then
        c54v8 = false
      else
        c54v8 = true
      end
      __renovice_local_0:Makeposshield(c54v5, c54v6, c54v7, c54v8)
    end
    do return end
  end
  v138 = function(c55v0, c55v1)
    local c55v2, c55v3, c55v4, c55v5, c55v6, c55v7, c55v8, c55v9, c55v10, c55v11, c55v12, c55v13, c55v14, c55v15, c55v16, c55v17, c55v18, c55v19, c55v20, c55v21, c55v22, c55v23, c55v24, c55v25, c55v26, c55v27, c55v28, c55v29, c55v30, c55v31
    c55v2 = _T.SecretMiniGameActive
    if not c55v2 then
      c55v2 = _T.PvpMode
      c55v3 = 4
      if c55v2 ~= c55v3 then
        c55v3 = v41
        c55v2 = IsNull
        c55v2 = c55v2(c55v3)
        if c55v2 then
          do return end
        end
        local __renovice_state_0 = -1
        c55v3 = v75
        c55v2 = #c55v3
        c55v3 = false
        c55v4 = nil
        c55v5 = v35
        c55v6 = v3
        c55v6 = c55v6.UI_MODE_IN_SPACE_SHIP
        if c55v5 == c55v6 then
          __renovice_state_0 = -1
        else
          __renovice_state_0 = 1
        end
        if __renovice_state_0 == 1 then
          c55v5 = v35
          c55v6 = v3
          c55v6 = c55v6.UI_MODE_IN_DOJO
          if c55v5 ~= c55v6 then
            __renovice_state_0 = 2
          else
            __renovice_state_0 = -1
          end
        end
        if __renovice_state_0 == 2 then
          c55v5 = _T.CustomUpdateTargetStatus
          if c55v5 == nil then
            __renovice_state_0 = 4
          else
            __renovice_state_0 = 3
          end
        end
        if __renovice_state_0 == 3 then
          c55v5 = _T.CustomUpdateTargetStatus
          c55v6 = v40
          c55v7 = v41
          c55v8 = v38
          c55v4 = c55v5(c55v6, c55v7, c55v8)
          __renovice_state_0 = 5
        end
        if __renovice_state_0 == 4 then
          c55v5 = v41
          c55v4 = c55v5:GetAimEndPointEntity()
          __renovice_state_0 = 5
        end
        if __renovice_state_0 ~= 5 then
          c55v5 = v40
          c55v5 = c55v5:Name__cb8bb185()
          c55v5 = c55v5:TrackPartsMISSION()
          c55v6 = IsNull
          c55v6 = c55v6(c55v5)
          if not c55v6 then
            c55v8 = gDecoModeActionType
            c55v6 = c55v5:IsA(c55v8)
            if c55v6 then
              c55v4 = c55v5:Name__2fab1208()
            end
          end
          c55v6 = IsNull
          c55v6 = c55v6(c55v4)
          if c55v6 then
            c55v6 = v41
            c55v4 = c55v6:GetAimEndPointEntity()
          else
            c55v3 = true
          end
        end
        c55v5 = nil
        c55v6 = nil
        c55v7 = nil
        c55v8 = nil
        c55v9 = IsNull
        c55v9 = c55v9(c55v4)
        if not c55v9 then
          c55v9 = v42
          c55v5 = c55v9:FilterStatusEntity(c55v4)
          c55v6 = c55v5.deco
          c55v7 = c55v5.otherAvatar
          c55v10 = IsNull
          c55v10 = c55v10(c55v6)
          c55v9 = not c55v10
          if c55v9 then
            c55v10 = c55v5.isFakeDeco
            c55v9 = not c55v10
            if c55v9 then
              c55v11 = gDecorationType
              c55v9 = c55v6:IsA(c55v11)
              if c55v9 then
                c55v9 = c55v6:AlwaysShowInHud()
                if not c55v9 then
                  c55v9 = c55v3
                  if c55v9 then
                    c55v11 = gDojoPlaceableDecorationType
                    c55v9 = c55v6:IsA(c55v11)
                  end
                end
              end
            end
          end
          local __renovice_state_1 = -1
          c55v11 = IsNull
          c55v11 = c55v11(c55v6)
          if c55v11 then
            __renovice_state_1 = -1
          else
            __renovice_state_1 = 1
          end
          if __renovice_state_1 == 1 then
            if c55v9 then
              __renovice_state_1 = 7
            else
              __renovice_state_1 = 2
            end
          end
          if __renovice_state_1 == 2 then
            c55v11 = c55v6:Name__05c29461()
            if not c55v11 then
              __renovice_state_1 = -1
            else
              __renovice_state_1 = 3
            end
          end
          if __renovice_state_1 == 3 then
            c55v13 = gDojoPlaceableDecorationType
            c55v11 = c55v6:IsA(c55v13)
            if c55v11 then
              __renovice_state_1 = -1
            else
              __renovice_state_1 = 4
            end
          end
          if __renovice_state_1 == 4 then
            c55v11 = c55v5.isFakeDeco
            if c55v11 then
              __renovice_state_1 = 7
            else
              __renovice_state_1 = 5
            end
          end
          if __renovice_state_1 == 5 then
            c55v11 = c55v6:GetDefaultHealth()
            if c55v11 == 0 then
              __renovice_state_1 = 7
            else
              __renovice_state_1 = 6
            end
          end
          if __renovice_state_1 == 6 then
            c55v11 = c55v6:GetHealth()
            c55v12 = 0
            if not (c55v12 < c55v11) then
              __renovice_state_1 = -1
            else
              __renovice_state_1 = 7
            end
          end
          if __renovice_state_1 == 7 then
            c55v10 = c55v5.isFakeDeco
            if c55v10 then
              __renovice_state_1 = 9
            else
              __renovice_state_1 = 8
            end
          end
          if __renovice_state_1 == 8 then
            c55v10 = c55v6:Name__f53ccd3d()
            if c55v10 then
              __renovice_state_1 = 9
            else
              __renovice_state_1 = -1
            end
          end
          if __renovice_state_1 ~= 9 then
            c55v11 = IsNull
            c55v11 = c55v11(c55v7)
            c55v10 = not c55v11
            if c55v10 then
              c55v11 = c55v7:IsKilled()
              c55v10 = not c55v11
              if c55v10 then
                c55v10 = c55v7:Name__05c29461()
                if not c55v10 then
                  c55v12 = gHitProxyType
                  c55v10 = c55v4:IsA(c55v12)
                  if c55v10 then
                    c55v10 = c55v4:IsEnabled()
                  end
                end
              end
            end
          end
          if not c55v10 then
            c55v4 = nil
          end
          c55v11 = IsNull
          c55v11 = c55v11(c55v7)
          if not c55v11 then
            local __renovice_state_2 = -1
            c55v11 = v41
            c55v11 = c55v11:GetSentinel()
            c55v12 = v35
            c55v13 = v3
            c55v13 = c55v13.UI_MODE_IN_SPACE_HUB
            if c55v12 == c55v13 then
              __renovice_state_2 = 2
            else
              __renovice_state_2 = 1
            end
            if __renovice_state_2 == 1 then
              c55v12 = v35
              c55v13 = v3
              c55v13 = c55v13.UI_MODE_IN_DOJO
              if c55v12 ~= c55v13 then
                __renovice_state_2 = 3
              else
                __renovice_state_2 = 2
              end
            end
            if __renovice_state_2 == 2 then
              c55v14 = gLotusSentinelAvatarType
              c55v12 = c55v7:IsA(c55v14)
              if not c55v12 then
                __renovice_state_2 = -1
              else
                __renovice_state_2 = 3
              end
            end
            if __renovice_state_2 == 3 then
              c55v12 = IsNull
              c55v12 = c55v12(c55v11)
              if c55v12 then
                __renovice_state_2 = 6
              else
                __renovice_state_2 = 4
              end
            end
            if __renovice_state_2 == 4 then
              c55v14 = gPetAvatarType
              c55v12 = c55v7:IsA(c55v14)
              if c55v12 then
                __renovice_state_2 = 6
              else
                __renovice_state_2 = 5
              end
            end
            if __renovice_state_2 == 5 then
              c55v14 = gLotusRoboPetAvatarType
              c55v12 = c55v7:IsA(c55v14)
              if (c55v12 or c55v11 ~= c55v7) then
                __renovice_state_2 = 6
              else
                __renovice_state_2 = -1
              end
            end
            if __renovice_state_2 ~= 6 then
              c55v4 = nil
            end
          end
          c55v11 = IsNull
          c55v11 = c55v11(c55v7)
          if not c55v11 then
            repeat
              c55v11 = c55v7:DamageControl()
              c55v12 = c55v7:Name__05c29461()
              if c55v12 then
                c55v12 = IsNull
                c55v12 = c55v12(c55v11)
                if c55v12 then break end
                c55v12 = c55v11:IsPreDeath()
                if not c55v12 then break end
              end
              repeat
                c55v12 = c55v7:GetRagdoll()
                c55v13 = IsNull
                c55v13 = c55v13(c55v12)
                if not c55v13 then
                  c55v13 = c55v12:Name__05c29461()
                  if c55v13 then break end
                end
                c55v4 = nil
              until true
            until true
            c55v12 = IsNull
            c55v12 = c55v12(c55v4)
            if not c55v12 then
              c55v12 = IsNull
              c55v12 = c55v12(c55v0)
              if not c55v12 then
                c55v14 = gLotusVehicleAvatarType
                c55v12 = c55v0:IsA(c55v14)
                if c55v12 then
                  c55v12 = c55v0:GetRider()
                  if c55v12 == c55v7 then
                    c55v4 = nil
                  end
                end
              end
            end
          end
          c55v11 = IsNull
          c55v11 = c55v11(c55v4)
          if not c55v11 then
            c55v11 = IsNull
            c55v11 = c55v11(c55v7)
            if not c55v11 then
              local __renovice_state_3 = -1
              c55v11 = v78
              if c55v11 == nil then
                __renovice_state_3 = -1
              else
                __renovice_state_3 = 1
              end
              if __renovice_state_3 == 1 then
                c55v11 = v78
                c55v11 = c55v11.showBossStatus
                if not c55v11 then
                  __renovice_state_3 = -1
                else
                  __renovice_state_3 = 2
                end
              end
              if __renovice_state_3 == 2 then
                c55v12 = v78
                c55v12 = c55v12.bossStatus
                c55v11 = IsNull
                c55v11 = c55v11(c55v12)
                if c55v11 then
                  __renovice_state_3 = -1
                else
                  __renovice_state_3 = 3
                end
              end
              if __renovice_state_3 == 3 then
                c55v11 = v78
                c55v11 = c55v11.bossStatus
                c55v11 = c55v11:GetAvatar()
                if c55v11 ~= c55v7 then
                  __renovice_state_3 = -1
                else
                  __renovice_state_3 = 4
                end
              end
              if __renovice_state_3 == 4 then
                c55v12 = v78
                c55v12 = c55v12.damageController
                c55v11 = IsNull
                c55v11 = c55v11(c55v12)
                if c55v11 then
                  __renovice_state_3 = 9
                else
                  __renovice_state_3 = 5
                end
              end
              if __renovice_state_3 == 5 then
                c55v11 = v78
                c55v11 = c55v11.damageController
                c55v13 = v15
                c55v11 = c55v11:IsA(c55v13)
                if c55v11 then
                  __renovice_state_3 = 9
                else
                  __renovice_state_3 = 6
                end
              end
              if __renovice_state_3 == 6 then
                c55v13 = v18
                c55v11 = c55v7:IsA(c55v13)
                if c55v11 then
                  __renovice_state_3 = 9
                else
                  __renovice_state_3 = 7
                end
              end
              if __renovice_state_3 == 7 then
                c55v13 = v19
                c55v11 = c55v7:IsA(c55v13)
                if c55v11 then
                  __renovice_state_3 = 9
                else
                  __renovice_state_3 = 8
                end
              end
              if __renovice_state_3 == 8 then
                c55v4 = nil
                c55v8 = v78.damageController
                __renovice_state_3 = 9
              end
              if __renovice_state_3 ~= 9 then
                c55v11 = v79
                if c55v11 ~= nil then
                  c55v11 = v79
                  c55v11 = c55v11.showBossStatus
                  if c55v11 then
                    c55v12 = v79
                    c55v12 = c55v12.bossStatus
                    c55v11 = IsNull
                    c55v11 = c55v11(c55v12)
                    if not c55v11 then
                      c55v11 = v79
                      c55v11 = c55v11.bossStatus
                      c55v11 = c55v11:GetAvatar()
                      if c55v11 == c55v7 then
                        c55v12 = v79
                        c55v12 = c55v12.damageController
                        c55v11 = IsNull
                        c55v11 = c55v11(c55v12)
                        if not c55v11 then
                          c55v11 = v79
                          c55v11 = c55v11.damageController
                          c55v13 = v15
                          c55v11 = c55v11:IsA(c55v13)
                          if not c55v11 then
                            c55v13 = v18
                            c55v11 = c55v7:IsA(c55v13)
                            if not c55v11 then
                              c55v13 = v19
                              c55v11 = c55v7:IsA(c55v13)
                              if not c55v11 then
                                c55v4 = nil
                                c55v8 = v79.damageController
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
          c55v11 = IsNull
          c55v11 = c55v11(c55v7)
          if not c55v11 then
            c55v11 = v78
            if c55v11 ~= nil then
              c55v11 = v78
              c55v11 = c55v11.showBossStatus
              if c55v11 then
                c55v12 = v78
                c55v12 = c55v12.bossStatus
                c55v11 = IsNull
                c55v11 = c55v11(c55v12)
                if not c55v11 then
                  c55v11 = v78
                  c55v11 = c55v11.bossStatus
                  c55v11 = c55v11:GetAvatar()
                  if c55v11 == c55v7 then
                    c55v13 = v17
                    c55v11 = c55v7:IsA(c55v13)
                    if c55v11 then
                      c55v11 = c55v7:Name__664952c9()
                      if c55v11 then
                        c55v12 = v41
                        c55v4 = c55v12:GetAimEndPointEntity()
                        c55v8 = nil
                      else
                        c55v4 = nil
                        c55v8 = v78.damageController
                        c55v12 = v76
                        if c55v12 ~= nil then
                          c55v14 = v75
                          c55v15 = v76
                          c55v13 = c55v14[c55v15]
                          c55v12 = IsNull
                          c55v12 = c55v12(c55v13)
                          if not c55v12 then
                            c55v13 = v75
                            c55v14 = v76
                            c55v12 = c55v13[c55v14]
                            c55v13 = false
                            c55v12.mActive = c55v13
                            c55v13 = v75
                            c55v14 = v76
                            c55v12 = c55v13[c55v14]
                            c55v13 = 0
                            c55v12.mPersist = c55v13
                            c55v12 = mMovie
                            c55v15 = v75
                            c55v16 = v76
                            c55v14 = c55v15[c55v16]
                            c55v14 = c55v14.mClipName
                            c55v15 = 12
                            c55v16 = 0
                            c55v12:SetNumberVariable(c55v14, c55v15, c55v16)
                            c55v12 = nil
                            v76 = c55v12
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
        c55v9 = IsNull
        c55v9 = c55v9(c55v4)
        if c55v9 then
          c55v9 = v76
          if c55v9 ~= nil then
            c55v11 = v75
            c55v12 = v76
            c55v10 = c55v11[c55v12]
            c55v9 = IsNull
            c55v9 = c55v9(c55v10)
            if not c55v9 then
              c55v10 = v75
              c55v11 = v76
              c55v9 = c55v10[c55v11]
              c55v10 = false
              c55v9.mActive = c55v10
              c55v9 = nil
              v76 = c55v9
            end
          end
        else
          c55v9 = v76
          if c55v9 ~= nil then
            c55v11 = v75
            c55v12 = v76
            c55v10 = c55v11[c55v12]
            c55v9 = IsNull
            c55v9 = c55v9(c55v10)
            if not c55v9 then
              c55v10 = v75
              c55v11 = v76
              c55v9 = c55v10[c55v11]
              c55v9 = c55v9.mPtr
              if c55v9 ~= c55v4 then
                c55v10 = v75
                c55v11 = v76
                c55v9 = c55v10[c55v11]
                c55v10 = false
                c55v9.mActive = c55v10
                c55v9 = nil
                v76 = c55v9
              end
            end
          end
          c55v11 = 1
          c55v9 = c55v2
          c55v10 = 1
          for __renovice_for_0_0 = c55v11, c55v9, c55v10 do
            c55v13 = v75[__renovice_for_0_0]
            c55v12 = IsNull
            c55v12 = c55v12(c55v13)
            if c55v12 then
              continue
            end
            c55v12 = v75[__renovice_for_0_0]
            c55v12 = c55v12.mPtr
            if c55v12 ~= c55v4 then
              continue
            end
            local __renovice_state_4 = -1
            c55v13 = v75[__renovice_for_0_0]
            c55v13 = c55v13.mAvatar
            c55v12 = IsNull
            c55v12 = c55v12(c55v13)
            if c55v12 then
              __renovice_state_4 = 2
            else
              __renovice_state_4 = 1
            end
            if __renovice_state_4 == 1 then
              c55v12 = v75[__renovice_for_0_0]
              c55v12 = c55v12.mAvatar
              c55v12 = c55v12:HasDynamicUIName()
              if c55v12 then
                __renovice_state_4 = -1
              else
                __renovice_state_4 = 2
              end
            end
            if __renovice_state_4 == 2 then
              c55v13 = v75[__renovice_for_0_0]
              c55v13 = c55v13.mDeco
              c55v12 = IsNull
              c55v12 = c55v12(c55v13)
              if c55v12 then
                __renovice_state_4 = 5
              else
                __renovice_state_4 = 3
              end
            end
            if __renovice_state_4 == 3 then
              c55v12 = v75[__renovice_for_0_0]
              c55v12 = c55v12.mCachedLocTag
              if c55v12 == nil then
                __renovice_state_4 = 5
              else
                __renovice_state_4 = 4
              end
            end
            if __renovice_state_4 == 4 then
              c55v12 = v75[__renovice_for_0_0]
              c55v12 = c55v12.mCachedLocTag
              c55v13 = v75[__renovice_for_0_0]
              c55v13 = c55v13.mDeco
              c55v13 = c55v13:GetLocTag()
              if c55v12 == c55v13 then
                __renovice_state_4 = 5
              else
                __renovice_state_4 = -1
              end
            end
            if __renovice_state_4 ~= 5 then
              c55v12 = v137
              c55v14 = v75[__renovice_for_0_0]
              c55v12(c55v0, c55v14)
            end
            v76 = __renovice_for_0_0
            c55v12 = v75[__renovice_for_0_0]
            c55v13 = true
            c55v12.mActive = c55v13
            c55v14 = v75[__renovice_for_0_0]
            c55v14 = c55v14.mDeco
            c55v13 = IsNull
            c55v13 = c55v13(c55v14)
            c55v12 = not c55v13
            if c55v12 then
              c55v12 = v75[__renovice_for_0_0]
              c55v12 = c55v12.mDeco
              c55v14 = gDecorationType
              c55v12 = c55v12:IsA(c55v14)
              if c55v12 then
                c55v12 = v75[__renovice_for_0_0]
                c55v12 = c55v12.mDeco
                c55v12 = c55v12:Name__55580a2e()
              end
            end
            c55v13 = v75[__renovice_for_0_0]
            c55v15 = c55v12
            if not c55v15 then
              c55v17 = v75[__renovice_for_0_0]
              c55v17 = c55v17.mAvatar
              c55v16 = IsNull
              c55v16 = c55v16(c55v17)
              c55v15 = not c55v16
              if c55v15 then
                c55v16 = v75[__renovice_for_0_0]
                c55v16 = c55v16.mAvatar
                c55v16 = c55v16:Name__da68be10()
                c55v15 = not c55v16
              end
            end
            c55v14 = not c55v15
            c55v13.mVisible = c55v14
            c55v13 = v75[__renovice_for_0_0]
            c55v14 = 1
            c55v13.mPersist = c55v14
            c55v13 = mMovie
            c55v15 = v75[__renovice_for_0_0]
            c55v15 = c55v15.mClipName
            c55v16 = 12
            c55v17 = v1
            c55v17 = c55v17.Ternary
            c55v18 = v75[__renovice_for_0_0]
            c55v18 = c55v18.mVisible
            c55v19 = 100
            c55v20 = 0
            c55v13:SetNumberVariable(c55v15, c55v16, c55v17(c55v18, c55v19, c55v20))
            break
          end
          c55v9 = v76
          if c55v9 == nil then
            c55v10 = v75
            c55v9 = #c55v10
            c55v10 = 0
            if c55v10 < c55v9 then
              c55v11 = 1
              c55v9 = c55v2
              c55v10 = 1
              for __renovice_for_1_0 = c55v11, c55v9, c55v10 do
                c55v13 = v75[__renovice_for_1_0]
                c55v12 = IsNull
                c55v12 = c55v12(c55v13)
                if c55v12 then
                  continue
                end
                c55v12 = v75[__renovice_for_1_0]
                c55v12 = c55v12.mPersist
                c55v13 = 2
                if not (c55v12 < c55v13) then
                  continue
                end
                v76 = __renovice_for_1_0
                c55v12 = v75[__renovice_for_1_0]
                c55v12 = c55v12.mPersist
                if c55v12 == 0 then break end
              end
              c55v10 = v75
              c55v11 = v76
              c55v9 = c55v10[c55v11]
              c55v10 = 1
              c55v9.mPersist = c55v10
              c55v9.mPtr = c55v4
              c55v9.mDeco = c55v6
              c55v9.mAvatar = c55v7
              c55v10 = true
              c55v9.mActive = c55v10
              c55v12 = c55v9.mDeco
              c55v11 = IsNull
              c55v11 = c55v11(c55v12)
              c55v10 = not c55v11
              if c55v10 then
                c55v10 = c55v9.mDeco
                c55v12 = gDecorationType
                c55v10 = c55v10:IsA(c55v12)
                if c55v10 then
                  c55v10 = c55v9.mDeco
                  c55v10 = c55v10:Name__55580a2e()
                end
              end
              c55v12 = c55v10
              if not c55v12 then
                c55v14 = c55v9.mAvatar
                c55v13 = IsNull
                c55v13 = c55v13(c55v14)
                c55v12 = not c55v13
                if c55v12 then
                  c55v13 = c55v9.mAvatar
                  c55v13 = c55v13:Name__da68be10()
                  c55v12 = not c55v13
                end
              end
              c55v11 = not c55v12
              c55v9.mVisible = c55v11
              c55v11 = c55v5.hitProxy
              c55v9.mHitProxy = c55v11
              c55v11 = nil
              c55v9.mDamageControl = c55v11
              c55v11 = nil
              c55v9.mName = c55v11
              c55v11 = nil
              c55v9.mCachedLocTag = c55v11
              c55v11 = nil
              c55v9.mLevel = c55v11
              c55v11 = true
              c55v9.mNew = c55v11
              c55v13 = 1
              c55v14 = v32
              c55v11 = #c55v14
              c55v12 = 1
              for __renovice_for_2_0 = c55v13, c55v11, c55v12 do
                c55v14 = c55v9.mActiveProcs
                c55v15 = 0
                c55v14[__renovice_for_2_0] = c55v15
                c55v14 = c55v9.mActiveImmunities
                c55v15 = 0
                c55v14[__renovice_for_2_0] = c55v15
              end
              c55v11 = c55v9.mImmunityList
              c55v13 = true
              c55v14 = true
              c55v11:RemoveElements(c55v13, c55v14)
              c55v11 = c55v9.mImmunityList
              c55v13 = nil
              c55v14 = true
              c55v15 = true
              c55v11:Redraw(c55v13, c55v14, c55v15)
              c55v12 = c55v9.mAvatar
              c55v11 = IsNull
              c55v11 = c55v11(c55v12)
              if not c55v11 then
                c55v11 = c55v9.mAvatar
                c55v13 = Symbol
                c55v14 = "StatusDamage"
                c55v13 = c55v13(c55v14)
                c55v14 = "OnDamaged"
                c55v11:Name__a198b3d4(c55v13, c55v14)
                c55v11 = c55v9.mAvatar
                c55v11 = c55v11:DamageControl()
                c55v9.mDamageControl = c55v11
              end
              c55v11 = v137
              c55v11(c55v0, c55v9)
              c55v11 = 100
              c55v12 = mMovie
              c55v14 = c55v9.mClipName
              c55v15 = "Immunities"
              c55v16 = 36
              c55v17 = ""
              c55v12:Name__f4a9016a(c55v14, c55v15, c55v16, c55v17)
              c55v12 = v35
              c55v13 = v3
              c55v13 = c55v13.UI_MODE_IN_SPACE_HUB
              if c55v12 ~= c55v13 then
                c55v12 = c55v9.mHpShieldDisplayAvatar
                c55v13 = c55v9.mAvatar
                if c55v12 ~= c55v13 then
                  c55v12 = c55v9.mAvatar
                  c55v9.mHpShieldDisplayAvatar = c55v12
                  c55v12 = c55v9.mHpShieldDisplay
                  c55v14 = c55v9.mAvatar
                  c55v12:SetAvatar(c55v14)
                end
                c55v13 = c55v9.mAvatar
                c55v12 = IsNull
                c55v12 = c55v12(c55v13)
                if not c55v12 then
                  c55v12 = false
                  c55v13 = v37
                  if c55v13 then
                    c55v14 = c55v9.mIsAiEnemyAvatar
                    c55v13 = not c55v14
                    if c55v13 then
                      c55v13 = c55v9.mAvatar
                      c55v15 = v27
                      c55v13 = c55v13:IsA(c55v15)
                    end
                    c55v12 = c55v13
                  end
                  c55v13 = c55v9.mAvatar
                  c55v13 = c55v13:ShowHealthInHud()
                  if (c55v13 and not c55v12) then
                    c55v13 = nil
                    c55v9.mHpShieldDisplayDeco = c55v13
                    c55v13 = c55v9.mHpShieldDisplay
                    c55v15 = nil
                    c55v13:SetDeco(c55v15)
                    c55v13 = c55v9.mHpShieldDisplay
                    c55v15 = true
                    c55v16 = c55v9.mAvatar
                    c55v16 = c55v16:GetOriginalFaction()
                    c55v17 = c55v0:GetOriginalFaction()
                    if c55v16 == c55v17 then
                      c55v16 = c55v9.mAvatar
                      c55v16 = c55v16:IsHumanPlayer()
                      c55v15 = not c55v16
                    end
                    c55v13:SetTrackArmor(c55v15)
                    c55v13 = c55v9.mHpShieldDisplay
                    c55v15 = 24
                    c55v13:SetHealthColor(c55v15)
                    c55v13 = c55v9.mHpShieldDisplay
                    c55v13:Initialize()
                  else
                    c55v11 = 0
                    c55v13 = nil
                    c55v9.mHpShieldDisplayAvatar = c55v13
                    c55v13 = c55v9.mHpShieldDisplay
                    c55v15 = nil
                    c55v13:SetAvatar(c55v15)
                    c55v13 = nil
                    c55v9.mHpShieldDisplayDeco = c55v13
                    c55v13 = c55v9.mHpShieldDisplay
                    c55v15 = nil
                    c55v13:SetDeco(c55v15)
                  end
                else
                  c55v13 = c55v9.mDeco
                  c55v12 = IsNull
                  c55v12 = c55v12(c55v13)
                  if not c55v12 then
                    c55v12 = c55v9.mHpShieldDisplayDeco
                    c55v13 = c55v9.mDeco
                    if c55v12 ~= c55v13 then
                      c55v12 = c55v9.mDeco
                      c55v9.mHpShieldDisplayDeco = c55v12
                      c55v12 = c55v9.mHpShieldDisplay
                      c55v14 = c55v9.mDeco
                      c55v16 = c55v5.isFakeDeco
                      if c55v16 ~= true then
                        c55v15 = false
                      else
                        c55v15 = true
                      end
                      c55v12:SetDeco(c55v14, c55v15)
                    end
                    repeat
                      c55v12 = c55v9.mDeco
                      c55v14 = gDecorationType
                      c55v12 = c55v12:IsA(c55v14)
                      if c55v12 then
                        c55v12 = c55v9.mDeco
                        c55v12 = c55v12:ShowHealthInHud()
                        if not c55v12 then
                          c55v12 = nil
                          c55v9.mHpShieldDisplayDeco = c55v12
                          c55v12 = c55v9.mHpShieldDisplay
                          c55v14 = nil
                          c55v12:SetDeco(c55v14)
                          break
                        end
                      end
                      c55v12 = c55v9.mHpShieldDisplay
                      c55v14 = 39
                      c55v12:SetHealthColor(c55v14)
                      c55v12 = c55v9.mHpShieldDisplay
                      c55v12:Initialize()
                    until true
                  end
                end
              end
              c55v12 = mMovie
              c55v14 = c55v9.mClipName
              c55v15 = 12
              c55v16 = v1
              c55v16 = c55v16.Ternary
              c55v17 = c55v9.mVisible
              c55v19 = 0
              c55v12:SetNumberVariable(c55v14, c55v15, c55v16(c55v17, c55v11, c55v19))
            end
          end
        end
        c55v9 = nil
        c55v10 = 0
        c55v13 = 1
        c55v11 = c55v2
        c55v12 = 1
        for __renovice_for_3_0 = c55v13, c55v11, c55v12 do
          c55v15 = v75[__renovice_for_3_0]
          c55v14 = IsNull
          c55v14 = c55v14(c55v15)
          if c55v14 then
            continue
          end
          c55v9 = v75[__renovice_for_3_0]
          c55v14 = c55v9.mActive
          if c55v14 then
            c55v15 = c55v9.mPtr
            c55v14 = IsNull
            c55v14 = c55v14(c55v15)
            if c55v14 then
              c55v14 = false
              c55v9.mActive = c55v14
            end
          end
          repeat
            c55v14 = c55v9.mActive
            if not c55v14 then
              c55v14 = c55v9.mPersist
              c55v15 = 0
              if not (c55v15 < c55v14) then break end
            end
            c55v14 = c55v9.mHpShieldDisplay
            c55v14:Update(c55v1)
            c55v14 = c55v9.mActive
            if c55v14 then
              c55v8 = c55v9.mDamageControl
            end
            repeat
              c55v15 = c55v9.mDamageControl
              c55v14 = IsNull
              c55v14 = c55v14(c55v15)
              if not c55v14 then
                c55v14 = c55v9.mHpShieldDisplay
                c55v14 = c55v14:Name__85af2062()
                if not c55v14 then
                  c55v14 = c55v9.mName
                  c55v15 = v3
                  c55v15 = c55v15.HIDDEN_PLAYER_NAME
                  if c55v14 == c55v15 then
                    c55v15 = mMovie
                    c55v17 = "/Lotus/Language/Game/Stalker"
                    c55v18 = false
                    c55v14 = c55v15:GetLocalized(c55v17, c55v18)
                  end
                  c55v15 = false
                  c55v16 = nil
                  c55v19 = 1
                  c55v20 = c55v9.mActiveProcs
                  c55v17 = #c55v20
                  c55v18 = 1
                  for __renovice_for_4_0 = c55v19, c55v17, c55v18 do
                    c55v20 = c55v9.mDamageControl
                    c55v22 = __renovice_for_4_0 - 1
                    c55v10 = c55v20:Name__ff67e37d(c55v22)
                    c55v21 = c55v9.mActiveProcs
                    c55v20 = c55v21[__renovice_for_4_0]
                    if c55v20 ~= c55v10 then
                      c55v20 = c55v9.mActiveProcs
                      c55v20[__renovice_for_4_0] = c55v10
                      c55v15 = true
                    end
                    c55v20 = 0
                    if not (c55v20 < c55v10) then
                      continue
                    end
                    c55v20 = v32[__renovice_for_4_0]
                    if c55v20 == nil then
                      continue
                    end
                    c55v20 = v32[__renovice_for_4_0]
                    c55v20 = c55v20.Icon
                    if c55v20 == nil then
                      continue
                    end
                    c55v20 = v1
                    c55v20 = c55v20.Ternary
                    c55v22 = 1
                    if not (c55v22 < c55v10) then
                      c55v21 = false
                    else
                      c55v21 = true
                    end
                    c55v23 = ""
                    c55v20 = c55v20(c55v21, c55v10, c55v23)
                    if c55v16 == nil then
                      c55v21 = v32[__renovice_for_4_0]
                      c55v21 = c55v21.Icon
                      c55v16 = c55v21 .. c55v20
                      continue
                    end
                    c55v22 = " "
                    c55v23 = v32[__renovice_for_4_0]
                    c55v23 = c55v23.Icon
                    c55v16 = c55v16 .. c55v22 .. c55v23 .. c55v20
                  end
                  if c55v15 then
                    if c55v16 ~= nil then
                      c55v18 = "\r\n"
                      c55v14 = c55v14 .. c55v18 .. c55v16
                    end
                    c55v17 = mMovie
                    c55v20 = c55v9.mClipName
                    c55v21 = ".Name"
                    c55v19 = c55v20 .. c55v21
                    c55v20 = 36
                    c55v17:SetStringVariable(c55v19, c55v20, c55v14)
                  end
                  c55v17 = c55v9.mDamageControl
                  c55v19 = gLotusDamageControllerType
                  c55v17 = c55v17:IsA(c55v19)
                  if c55v17 then
                    c55v15 = false
                    c55v17 = c55v9.mDamageControl
                    c55v17 = c55v17:PrerequisiteForest()
                    c55v18 = c55v9.mMaxArmour
                    if c55v17 ~= c55v18 then
                      c55v9.mMaxArmour = c55v17
                      c55v15 = true
                    end
                    local __renovice_state_5 = -1
                    c55v18 = 0
                    if not (c55v18 < c55v17) then
                      __renovice_state_5 = -1
                    else
                      __renovice_state_5 = 1
                    end
                    if __renovice_state_5 == 1 then
                      c55v18 = c55v9.mIsEnemyAvatar
                      if not c55v18 then
                        __renovice_state_5 = -1
                      else
                        __renovice_state_5 = 2
                      end
                    end
                    if __renovice_state_5 == 2 then
                      c55v18 = c55v9.mDamageControl
                      c55v18 = c55v18:GetArmourRating()
                      c55v19 = c55v9.mArmour
                      if c55v18 == c55v19 then
                        __renovice_state_5 = 4
                      else
                        __renovice_state_5 = 3
                      end
                    end
                    if __renovice_state_5 == 3 then
                      c55v9.mArmour = c55v18
                      c55v15 = true
                      __renovice_state_5 = 4
                    end
                    if __renovice_state_5 == 4 then
                      if not c55v15 then
                        __renovice_state_5 = 27
                      else
                        __renovice_state_5 = 5
                      end
                    end
                    if __renovice_state_5 == 5 then
                      c55v19 = c55v18 / c55v17
                      c55v21 = 0.34
                      c55v22 = c55v19 * 0.31
                      c55v20 = c55v21 + c55v22
                      c55v21 = mMovie
                      c55v24 = c55v9.mClipName
                      c55v25 = ".ArmorStatus.Fill"
                      c55v23 = c55v24 .. c55v25
                      c55v24 = "VisibilitySize"
                      c55v26 = 0
                      c55v27 = 0
                      c55v28 = 0
                      c55v21:Name__e243d995(c55v23, c55v24, c55v20, c55v26, c55v27, c55v28)
                      c55v21 = c55v9.mArmourTracerFill
                      c55v21:SetTargetVal(c55v20)
                      c55v21 = mMovie
                      c55v23 = c55v9.mClipName
                      c55v24 = "ArmorStatus.ArmorTwo"
                      c55v25 = 13
                      c55v27 = 500
                      if c55v27 <= c55v18 then
                        __renovice_state_5 = 7
                      else
                        __renovice_state_5 = 6
                      end
                    end
                    if __renovice_state_5 == 6 then
                      c55v26 = false
                      __renovice_state_5 = 8
                    end
                    if __renovice_state_5 == 7 then
                      c55v26 = true
                      __renovice_state_5 = 8
                    end
                    if __renovice_state_5 == 8 then
                      c55v21:Makeposshield(c55v23, c55v24, c55v25, c55v26)
                      c55v21 = mMovie
                      c55v23 = c55v9.mClipName
                      c55v24 = "ArmorStatus.ArmorThree"
                      c55v25 = 13
                      c55v27 = 2700
                      if c55v27 <= c55v18 then
                        __renovice_state_5 = 10
                      else
                        __renovice_state_5 = 9
                      end
                    end
                    if __renovice_state_5 == 9 then
                      c55v26 = false
                      __renovice_state_5 = 11
                    end
                    if __renovice_state_5 == 10 then
                      c55v26 = true
                      __renovice_state_5 = 11
                    end
                    if __renovice_state_5 == 11 then
                      c55v21:Makeposshield(c55v23, c55v24, c55v25, c55v26)
                      c55v21 = mMovie
                      c55v23 = c55v9.mClipName
                      c55v24 = "ArmorStatus.FillLine"
                      c55v25 = 13
                      c55v26 = false
                      c55v27 = 0
                      if not (c55v27 < c55v19) then
                        __renovice_state_5 = 15
                      else
                        __renovice_state_5 = 12
                      end
                    end
                    if __renovice_state_5 == 12 then
                      c55v27 = 0.1
                      if c55v19 < c55v27 then
                        __renovice_state_5 = 14
                      else
                        __renovice_state_5 = 13
                      end
                    end
                    if __renovice_state_5 == 13 then
                      c55v26 = false
                      __renovice_state_5 = 15
                    end
                    if __renovice_state_5 == 14 then
                      c55v26 = true
                      __renovice_state_5 = 15
                    end
                    if __renovice_state_5 == 15 then
                      c55v21:Makeposshield(c55v23, c55v24, c55v25, c55v26)
                      c55v21 = mMovie
                      c55v23 = c55v9.mClipName
                      c55v24 = "ArmorStatus.FillLine"
                      c55v25 = 1
                      c55v27 = c55v19 * 23
                      c55v26 = 13 - c55v27
                      c55v21:Name__52c1b74e(c55v23, c55v24, c55v25, c55v26)
                      c55v21 = mMovie
                      c55v23 = c55v9.mClipName
                      c55v24 = "Target"
                      c55v25 = 13
                      c55v21 = c55v21:Name__5882fa12(c55v23, c55v24, c55v25)
                      c55v22 = mMovie
                      c55v24 = c55v9.mClipName
                      c55v25 = "ArmorStatus"
                      c55v26 = 13
                      c55v27 = c55v21
                      if not c55v27 then
                        __renovice_state_5 = 19
                      else
                        __renovice_state_5 = 16
                      end
                    end
                    if __renovice_state_5 == 16 then
                      c55v28 = 0
                      if c55v28 < c55v18 then
                        __renovice_state_5 = 18
                      else
                        __renovice_state_5 = 17
                      end
                    end
                    if __renovice_state_5 == 17 then
                      c55v27 = false
                      __renovice_state_5 = 19
                    end
                    if __renovice_state_5 == 18 then
                      c55v27 = true
                      __renovice_state_5 = 19
                    end
                    if __renovice_state_5 == 19 then
                      c55v22:Makeposshield(c55v24, c55v25, c55v26, c55v27)
                      c55v22 = mMovie
                      c55v24 = c55v9.mClipName
                      c55v25 = "ArmorStatus"
                      c55v26 = 12
                      c55v27 = v1
                      c55v27 = c55v27.Ternary
                      c55v29 = 0
                      if c55v29 < c55v19 then
                        __renovice_state_5 = 21
                      else
                        __renovice_state_5 = 20
                      end
                    end
                    if __renovice_state_5 == 20 then
                      c55v28 = false
                      __renovice_state_5 = 22
                    end
                    if __renovice_state_5 == 21 then
                      c55v28 = true
                      __renovice_state_5 = 22
                    end
                    if __renovice_state_5 == 22 then
                      c55v29 = 100
                      c55v30 = 10
                      c55v22:Name__52c1b74e(c55v24, c55v25, c55v26, c55v27(c55v28, c55v29, c55v30))
                      if c55v19 ~= 0 then
                        __renovice_state_5 = 27
                      else
                        __renovice_state_5 = 23
                      end
                    end
                    if __renovice_state_5 == 23 then
                      c55v22 = c55v9.mNew
                      if c55v22 then
                        __renovice_state_5 = 27
                      else
                        __renovice_state_5 = 24
                      end
                    end
                    if __renovice_state_5 == 24 then
                      c55v23 = c55v9.mArmourBreakFx
                      c55v22 = IsNull
                      c55v22 = c55v22(c55v23)
                      if c55v22 then
                        __renovice_state_5 = 26
                      else
                        __renovice_state_5 = 25
                      end
                    end
                    if __renovice_state_5 == 25 then
                      c55v23 = c55v9.mArmourBreakFx
                      c55v23 = c55v23.mInstance
                      c55v22 = IsNull
                      c55v22 = c55v22(c55v23)
                      if not c55v22 then
                        __renovice_state_5 = 27
                      else
                        __renovice_state_5 = 26
                      end
                    end
                    if __renovice_state_5 == 26 then
                      c55v22 = v1
                      c55v22 = c55v22.CreateUIParticles
                      c55v23 = mMovie
                      c55v25 = c55v9.mClipName
                      c55v26 = ".ArmorStatus"
                      c55v24 = c55v25 .. c55v26
                      c55v25 = armorBreakFx
                      c55v22 = c55v22(c55v23, c55v24, c55v25)
                      c55v9.mArmourBreakFx = c55v22
                      __renovice_state_5 = 27
                    end
                    if __renovice_state_5 == 27 then
                      c55v19 = c55v9.mArmourTracerFill
                      c55v19:Update(c55v1)
                      c55v19 = mMovie
                      c55v22 = c55v9.mClipName
                      c55v23 = ".ArmorStatus.FillTracer"
                      c55v21 = c55v22 .. c55v23
                      c55v22 = "VisibilitySize"
                      c55v23 = c55v9.mArmourTracerFill
                      c55v23 = c55v23:GetVal()
                      c55v24 = 0
                      c55v25 = 0
                      c55v26 = 0
                      c55v19:Name__e243d995(c55v21, c55v22, c55v23, c55v24, c55v25, c55v26)
                      c55v19 = mMovie
                      c55v21 = c55v9.mClipName
                      c55v22 = 12
                      c55v19 = c55v19:GetNumberVariable(c55v21, c55v22)
                      c55v20 = mMovie
                      c55v22 = c55v9.mClipName
                      c55v23 = "ArmorStatus.FillTracer"
                      c55v24 = 13
                      c55v26 = 90
                      if c55v26 < c55v19 then
                        __renovice_state_5 = 29
                      else
                        __renovice_state_5 = 28
                      end
                    end
                    if __renovice_state_5 == 28 then
                      c55v25 = false
                      __renovice_state_5 = 30
                    end
                    if __renovice_state_5 == 29 then
                      c55v25 = true
                      __renovice_state_5 = 30
                    end
                    if __renovice_state_5 == 30 then
                      c55v20:Makeposshield(c55v22, c55v23, c55v24, c55v25)
                      c55v21 = c55v9.mArmourBreakFx
                      c55v20 = IsNull
                      c55v20 = c55v20(c55v21)
                      if c55v20 then
                        __renovice_state_5 = 33
                      else
                        __renovice_state_5 = 31
                      end
                    end
                    if __renovice_state_5 == 31 then
                      c55v21 = c55v9.mArmourBreakFx
                      c55v21 = c55v21.mInstance
                      c55v20 = IsNull
                      c55v20 = c55v20(c55v21)
                      if c55v20 then
                        __renovice_state_5 = 33
                      else
                        __renovice_state_5 = 32
                      end
                    end
                    if __renovice_state_5 == 32 then
                      c55v20 = c55v9.mArmourBreakFx
                      c55v20:Update(c55v1)
                      __renovice_state_5 = 33
                    end
                    if (__renovice_state_5 ~= 33 and c55v15) then
                      c55v18 = mMovie
                      c55v20 = c55v9.mClipName
                      c55v21 = "ArmorStatus"
                      c55v22 = 13
                      c55v23 = false
                      c55v18:Makeposshield(c55v20, c55v21, c55v22, c55v23)
                    end
                  else
                    c55v17 = mMovie
                    c55v19 = c55v9.mClipName
                    c55v20 = "ArmorStatus"
                    c55v21 = 13
                    c55v22 = false
                    c55v17:Makeposshield(c55v19, c55v20, c55v21, c55v22)
                  end
                  c55v17 = nil
                  c55v18 = c55v9.mDamageControl
                  c55v20 = gSentientDamageControllerType
                  c55v18 = c55v18:IsA(c55v20)
                  if c55v18 then
                    c55v15 = false
                    c55v18 = false
                    c55v21 = 1
                    c55v22 = c55v9.mActiveImmunities
                    c55v19 = #c55v22
                    c55v20 = 1
                    for __renovice_for_5_0 = c55v21, c55v19, c55v20 do
                      c55v22 = c55v9.mDamageControl
                      c55v24 = __renovice_for_5_0 - 1
                      c55v18 = c55v22:IsResistant(c55v24)
                      c55v23 = c55v9.mActiveImmunities
                      c55v22 = c55v23[__renovice_for_5_0]
                      if c55v22 == c55v18 then
                        continue
                      end
                      c55v22 = c55v9.mActiveImmunities
                      c55v22[__renovice_for_5_0] = c55v18
                      c55v15 = true
                    end
                    if c55v15 then
                      c55v19 = c55v9.mImmunityList
                      c55v21 = true
                      c55v22 = true
                      c55v19:RemoveElements(c55v21, c55v22)
                      c55v19 = mMovie
                      c55v21 = c55v9.mClipName
                      c55v22 = "ArmorStatus"
                      c55v23 = 13
                      c55v19 = c55v19:Name__5882fa12(c55v21, c55v22, c55v23)
                      c55v20 = mMovie
                      c55v22 = c55v9.mClipName
                      c55v23 = "Resistances"
                      c55v24 = 0
                      c55v27 = c55v9.mHpShieldDisplayWidth
                      c55v26 = c55v27 * 0.5
                      c55v27 = v1
                      c55v27 = c55v27.Ternary
                      c55v29 = 24
                      c55v30 = 0
                      c55v27 = c55v27(c55v19, c55v29, c55v30)
                      c55v25 = c55v26 + c55v27
                      c55v20:Name__52c1b74e(c55v22, c55v23, c55v24, c55v25)
                      c55v20 = pairs
                      c55v21 = c55v9.mActiveImmunities
                      c55v20, c55v21, c55v22 = c55v20(c55v21)
                      for __renovice_for_6_0, __renovice_for_6_1 in c55v20, c55v21, c55v22 do
                        if not (__renovice_for_6_1) then
                          continue
                        end
                        c55v25 = c55v9.mImmunityList
                        c55v27 = { StatusIndex = nil, IsVulnerability = false }
                        c55v27.StatusIndex = __renovice_for_6_0
                        c55v28 = true
                        c55v25:AddElement(c55v27, c55v28)
                      end
                      c55v20 = c55v9.mImmunityList
                      c55v22 = nil
                      c55v23 = true
                      c55v24 = true
                      c55v20:Redraw(c55v22, c55v23, c55v24)
                    end
                  else
                    c55v18 = c55v9.mDamageControl
                    c55v20 = gLotusDamageControllerType
                    c55v18 = c55v18:IsA(c55v20)
                    if c55v18 then
                      c55v15 = false
                      c55v18 = c55v9.mDamageControl
                      c55v18 = c55v18:GetDamageModifiers()
                      c55v19 = {}
                      c55v22 = 1
                      c55v20 = #c55v18
                      c55v21 = 1
                      for __renovice_for_7_0 = c55v22, c55v20, c55v21 do
                        c55v23 = c55v18[__renovice_for_7_0]
                        c55v23 = c55v23.damageType
                        c55v24 = 25
                        if c55v23 == c55v24 then
                          continue
                        end
                        c55v24 = c55v18[__renovice_for_7_0]
                        c55v24 = c55v24.multiplier
                        if c55v24 == 1 then
                          continue
                        end
                        c55v25 = v32
                        c55v26 = c55v23 + 1
                        c55v24 = c55v25[c55v26]
                        if c55v24 == nil then
                          continue
                        end
                        c55v25 = v32
                        c55v26 = c55v23 + 1
                        c55v24 = c55v25[c55v26]
                        c55v24 = c55v24.Icon
                        if c55v24 == nil then
                          continue
                        end
                        repeat
                          c55v24 = c55v18[__renovice_for_7_0]
                          c55v24 = c55v24.multiplier
                          c55v25 = 0
                          if c55v24 <= c55v25 then
                            c55v24 = c55v18[__renovice_for_7_0]
                            c55v24 = c55v24.applyToOtherDamageTypes
                            if c55v24 then
                              c55v24 = c55v23 + 1
                              c55v25 = 3
                              c55v19[c55v24] = c55v25
                              c55v17 = c55v23
                              break
                            end
                          end
                          c55v24 = c55v18[__renovice_for_7_0]
                          c55v24 = c55v24.showInHUD
                          if c55v24 then
                            c55v24 = c55v18[__renovice_for_7_0]
                            c55v24 = c55v24.multiplier
                            c55v25 = 1
                            if c55v25 < c55v24 then
                              c55v24 = c55v23 + 1
                              c55v25 = 2
                              c55v19[c55v24] = c55v25
                              continue
                            end
                            c55v24 = c55v23 + 1
                            c55v25 = 1
                            c55v19[c55v24] = c55v25
                          end
                        until true
                      end
                      c55v22 = 1
                      c55v23 = c55v9.mActiveImmunities
                      c55v20 = #c55v23
                      c55v21 = 1
                      for __renovice_for_8_0 = c55v22, c55v20, c55v21 do
                        c55v24 = c55v9.mActiveImmunities
                        c55v23 = c55v24[__renovice_for_8_0]
                        c55v24 = c55v19[__renovice_for_8_0]
                        if c55v23 == c55v24 then
                          continue
                        end
                        c55v23 = c55v9.mActiveImmunities
                        c55v24 = v1
                        c55v24 = c55v24.Ternary
                        c55v26 = c55v19[__renovice_for_8_0]
                        if c55v26 ~= nil then
                          c55v25 = false
                        else
                          c55v25 = true
                        end
                        c55v26 = 0
                        c55v27 = c55v19[__renovice_for_8_0]
                        c55v24 = c55v24(c55v25, c55v26, c55v27)
                        c55v23[__renovice_for_8_0] = c55v24
                        c55v15 = true
                      end
                      if c55v15 then
                        c55v20 = c55v9.mImmunityList
                        c55v22 = true
                        c55v23 = true
                        c55v20:RemoveElements(c55v22, c55v23)
                        c55v20 = mMovie
                        c55v22 = c55v9.mClipName
                        c55v23 = "ArmorStatus"
                        c55v24 = 13
                        c55v20 = c55v20:Name__5882fa12(c55v22, c55v23, c55v24)
                        c55v21 = mMovie
                        c55v23 = c55v9.mClipName
                        c55v24 = "Resistances"
                        c55v25 = 0
                        c55v28 = c55v9.mHpShieldDisplayWidth
                        c55v27 = c55v28 * 0.5
                        c55v28 = v1
                        c55v28 = c55v28.Ternary
                        c55v30 = 24
                        c55v31 = 0
                        c55v28 = c55v28(c55v20, c55v30, c55v31)
                        c55v26 = c55v27 + c55v28
                        c55v21:Name__52c1b74e(c55v23, c55v24, c55v25, c55v26)
                        c55v21 = pairs
                        c55v22 = c55v9.mActiveImmunities
                        c55v21, c55v22, c55v23 = c55v21(c55v22)
                        for __renovice_for_9_0, __renovice_for_9_1 in c55v21, c55v22, c55v23 do
                          if __renovice_for_9_1 == 3 then
                            c55v26 = vulnerabilityIcons[__renovice_for_9_0]
                            if c55v26 ~= nil then
                              c55v26 = c55v9.mImmunityList
                              c55v28 = { StatusIndex = nil, IsVulnerability = false, IsExclusive = true, DamageTypeForExclusive = nil }
                              c55v28.StatusIndex = __renovice_for_9_0
                              c55v28.DamageTypeForExclusive = c55v17
                              c55v29 = true
                              c55v26:AddElement(c55v28, c55v29)
                            end
                            continue
                          end
                          if __renovice_for_9_1 == 2 then
                            c55v26 = vulnerabilityIcons[__renovice_for_9_0]
                            if c55v26 ~= nil then
                              c55v26 = c55v9.mImmunityList
                              c55v28 = { StatusIndex = nil, IsVulnerability = true }
                              c55v28.StatusIndex = __renovice_for_9_0
                              c55v29 = true
                              c55v26:AddElement(c55v28, c55v29)
                            end
                            continue
                          end
                          c55v26 = 0
                          if not (c55v26 < __renovice_for_9_1) then
                            continue
                          end
                          c55v26 = c55v9.mImmunityList
                          c55v28 = { StatusIndex = nil, IsVulnerability = false }
                          c55v28.StatusIndex = __renovice_for_9_0
                          c55v29 = true
                          c55v26:AddElement(c55v28, c55v29)
                        end
                        c55v21 = c55v9.mImmunityList
                        c55v23 = nil
                        c55v24 = true
                        c55v25 = true
                        c55v21:Redraw(c55v23, c55v24, c55v25)
                      end
                    end
                  end
                  c55v18 = gGameRules
                  c55v20 = gLotusPveDeathmatchGameRulesType
                  c55v18 = c55v18:IsA(c55v20)
                  if c55v18 then
                    c55v19 = gGameRules
                    c55v19 = c55v19:GetGameVariant()
                    c55v20 = 1
                    if c55v19 ~= c55v20 then
                      c55v18 = false
                    else
                      c55v18 = true
                    end
                  end
                  if not c55v18 then break end
                  c55v20 = c55v9.mAvatar
                  c55v19 = IsNull
                  c55v19 = c55v19(c55v20)
                  if c55v19 then break end
                  c55v19 = nil
                  c55v20 = c55v9.mAvatar
                  c55v22 = gLotusNpcAvatarType
                  c55v20 = c55v20:IsA(c55v22)
                  if c55v20 then
                    c55v20 = c55v9.mAvatar
                    c55v20 = c55v20:GetAgentType()
                    c55v21 = IsNull
                    c55v21 = c55v21(c55v20)
                    if not c55v21 then
                      c55v19 = c55v20:GetName()
                    end
                  else
                    c55v20 = c55v9.mAvatar
                    c55v19 = c55v20:GetUIName()
                  end
                  if c55v19 == nil then break end
                  c55v20 = gGameRules
                  c55v22 = Symbol
                  c55v20 = c55v20:GetPoints(c55v22(c55v19))
                  c55v21 = 0
                  if not (c55v21 < c55v20) then break end
                  c55v21 = mMovie
                  c55v24 = c55v9.mClipName
                  c55v25 = ".Immunities"
                  c55v23 = c55v24 .. c55v25
                  c55v24 = 36
                  c55v21:SetStringVariable(c55v23, c55v24, c55v20)
                  break
                end
              end
              c55v14 = c55v9.mMaxArmour
              if c55v14 ~= nil then
                c55v14 = c55v9.mMaxArmour
                c55v15 = 0
                if c55v15 < c55v14 then
                  c55v14 = 0
                  c55v9.mMaxArmour = c55v14
                  c55v14 = 0
                  c55v9.mArmour = c55v14
                  c55v14 = mMovie
                  c55v16 = c55v9.mClipName
                  c55v17 = "ArmorStatus"
                  c55v18 = 13
                  c55v19 = false
                  c55v14:Makeposshield(c55v16, c55v17, c55v18, c55v19)
                end
              end
            until true
            c55v14 = c55v9.mActive
            if not c55v14 then
              c55v15 = IsNull
              c55v15 = c55v15(c55v4)
              c55v14 = not c55v15
              if not c55v14 then
                c55v14 = true
                c55v15 = c55v9.mHpShieldDisplay
                c55v15 = c55v15:GetDisplayHealth()
                c55v16 = 0
                if not (c55v15 <= c55v16) then
                  repeat
                    c55v16 = c55v9.mAvatar
                    c55v15 = IsNull
                    c55v15 = c55v15(c55v16)
                    if not c55v15 then
                      c55v15 = c55v9.mAvatar
                      c55v15 = c55v15:Name__05c29461()
                      c55v14 = not c55v15
                      if c55v14 then break end
                    end
                    repeat
                      c55v16 = c55v9.mDeco
                      c55v15 = IsNull
                      c55v15 = c55v15(c55v16)
                      if not c55v15 then
                        c55v15 = c55v9.mDeco
                        c55v15 = c55v15:Name__05c29461()
                        c55v14 = not c55v15
                        if c55v14 then break end
                      end
                      c55v15 = c55v9.mAvatar
                      c55v14 = IsNull
                      c55v14 = c55v14(c55v15)
                      if c55v14 then
                        c55v15 = c55v9.mDeco
                        c55v14 = IsNull
                        c55v14 = c55v14(c55v15)
                      end
                    until true
                  until true
                end
              end
              c55v16 = v1
              c55v16 = c55v16.Ternary
              c55v18 = 6
              c55v21 = 0.8
              c55v22 = c55v9.mPersist
              c55v20 = math.min
              c55v20 = c55v20(c55v21, c55v22)
              c55v19 = 1 - c55v20
              c55v16 = c55v16(c55v14, c55v18, c55v19)
              c55v15 = c55v1 * c55v16
              c55v18 = c55v9.mPersist
              c55v17 = c55v18 - c55v15
              c55v18 = 0
              c55v16 = math.max
              c55v16 = c55v16(c55v17, c55v18)
              c55v9.mPersist = c55v16
              c55v16 = c55v9.mVisible
              if c55v16 then
                c55v16 = mMovie
                c55v18 = c55v9.mClipName
                c55v19 = 12
                c55v22 = 1
                c55v23 = c55v9.mPersist
                c55v21 = math.min
                c55v21 = c55v21(c55v22, c55v23)
                c55v20 = c55v21 * 100
                c55v16:SetNumberVariable(c55v18, c55v19, c55v20)
              end
              c55v16 = c55v9.mPersist
              c55v17 = 0
              if c55v16 <= c55v17 then
                c55v17 = c55v9.mAvatar
                c55v16 = IsNull
                c55v16 = c55v16(c55v17)
                if not c55v16 then
                  c55v16 = c55v9.mAvatar
                  c55v18 = Symbol
                  c55v19 = "StatusDamage"
                  c55v16:Name__eaab1594(c55v18(c55v19))
                end
                c55v16 = nil
                c55v9.mPtr = c55v16
                c55v16 = nil
                c55v9.mDeco = c55v16
                c55v16 = nil
                c55v9.mAvatar = c55v16
                c55v16 = nil
                c55v9.mHitProxy = c55v16
                c55v16 = nil
                c55v9.mDamageControl = c55v16
              end
            end
            c55v14 = v71
            if c55v14 then
              c55v14 = nil
              c55v16 = c55v9.mAvatar
              c55v15 = IsNull
              c55v15 = c55v15(c55v16)
              if not c55v15 then
                c55v15 = c55v9.mAvatar
                c55v14 = c55v15:Name__7a4d0a2b()
              else
                c55v16 = c55v9.mDeco
                c55v15 = IsNull
                c55v15 = c55v15(c55v16)
                if not c55v15 then
                  c55v15 = c55v9.mDeco
                  c55v17 = gDecorationType
                  c55v15 = c55v15:IsA(c55v17)
                  if c55v15 then
                    c55v15 = c55v9.mDeco
                    c55v14 = c55v15:Name__7a4d0a2b()
                  else
                    c55v15 = c55v9.mDeco
                    c55v14 = c55v15:GetPosition()
                  end
                end
              end
              c55v15 = IsNull
              c55v15 = c55v15(c55v14)
              if not c55v15 then
                c55v15 = mMovie
                c55v15 = c55v15:ProjectPosition(c55v14)
                c55v16 = mMovie
                c55v18 = c55v9.mClipName
                c55v19 = 13
                c55v20 = false
                c55v21 = c55v15.z
                c55v22 = 1
                if c55v21 < c55v22 then
                  c55v21 = c55v15.z
                  c55v22 = 0
                  if not (c55v22 < c55v21) then
                    c55v20 = false
                  else
                    c55v20 = true
                  end
                end
                c55v16:Name__d9713943(c55v18, c55v19, c55v20)
                c55v16 = c55v15.z
                c55v17 = 1
                if c55v16 < c55v17 then
                  c55v16 = 0
                  c55v17 = 0
                  c55v19 = c55v9.mAvatar
                  c55v18 = IsNull
                  c55v18 = c55v18(c55v19)
                  if not c55v18 then
                    c55v16 = c55v15.x
                    c55v17 = c55v15.y
                  else
                    c55v18 = false
                    c55v20 = c55v9.mDeco
                    c55v19 = IsNull
                    c55v19 = c55v19(c55v20)
                    if not c55v19 then
                      c55v19 = c55v9.mDeco
                      c55v19 = c55v19:Name__c2c53207()
                      c55v20 = pairs
                      c55v20, c55v21, c55v22 = c55v20(c55v19)
                      for __renovice_for_10_0, __renovice_for_10_1 in c55v20, c55v21, c55v22 do
                        c55v26 = __renovice_for_10_1.mType
                        c55v25 = IsNull
                        c55v25 = c55v25(c55v26)
                        if c55v25 then
                          continue
                        end
                        c55v25 = __renovice_for_10_1.mType
                        c55v27 = v10
                        c55v25 = c55v25:IsA(c55v27)
                        if not c55v25 then
                          continue
                        end
                        c55v26 = __renovice_for_10_1.mInstance
                        c55v25 = IsNull
                        c55v25 = c55v25(c55v26)
                        if c55v25 then break end
                        c55v25 = mMovie
                        c55v27 = __renovice_for_10_1.mInstance
                        c55v25 = c55v25:ProjectPosition(c55v27:GetPosition())
                        c55v16 = c55v25.x
                        c55v17 = c55v25.y
                        c55v18 = true
                        break
                      end
                    end
                    if not c55v18 then
                      c55v19 = v42
                      c55v21 = c55v9.mDeco
                      c55v19 = c55v19:Name__c197b1e5(c55v21)
                      c55v20 = c55v19:MinX()
                      c55v23 = c55v19:MaxX()
                      c55v24 = c55v19:MinX()
                      c55v22 = c55v23 - c55v24
                      c55v21 = c55v22 / 2
                      c55v16 = c55v20 + c55v21
                      c55v20 = v1
                      c55v20 = c55v20.Round
                      c55v20 = c55v20(c55v19:MinY())
                      c55v17 = c55v20 - 20
                    end
                  end
                  c55v18 = c55v9.mLevel
                  if c55v18 == "" then
                    c55v18 = c55v9.mIsAIEnemyAvatar
                    if not c55v18 then
                      c55v17 = c55v17 + 30
                    end
                  end
                  c55v18 = mMovie
                  c55v20 = c55v9.mClipName
                  c55v21 = 0
                  c55v22 = v1
                  c55v22 = c55v22.Round
                  c55v18:SetNumberVariable(c55v20, c55v21, c55v22(c55v16))
                  c55v18 = mMovie
                  c55v20 = c55v9.mClipName
                  c55v21 = 1
                  c55v22 = v1
                  c55v22 = c55v22.Round
                  c55v18:SetNumberVariable(c55v20, c55v21, c55v22(c55v17))
                end
              end
            end
            c55v14 = nil
            c55v9.mNew = c55v14
          until true
        end
        c55v11 = v77
        if c55v8 ~= c55v11 then
          v77 = c55v8
          c55v12 = v42
          c55v11 = IsNull
          c55v11 = c55v11(c55v12)
          if not c55v11 then
            c55v11 = v42
            c55v13 = v77
            c55v11:Name__4c0b297d(c55v13)
          end
        end
        do return end
      end
    end
    do return end
  end
  v139 = function()
    local c56v0, c56v1, c56v2, c56v3, c56v4, c56v5, c56v6, c56v7, c56v8, c56v9, c56v10, c56v11, c56v12, c56v13, c56v14
    c56v1 = mMovie
    c56v0 = IsNull
    c56v0 = c56v0(c56v1)
    if c56v0 then
      do return end
    end
    c56v1 = v44
    c56v0 = IsNull
    c56v0 = c56v0(c56v1)
    if c56v0 then
      c56v0 = gGameRules
      v44 = c56v0
      c56v1 = v44
      c56v0 = IsNull
      c56v0 = c56v0(c56v1)
      if not c56v0 then
        c56v0 = v44
        c56v2 = gLotusBasePvpGameRulesType
        c56v0 = c56v0:IsA(c56v2)
        v36 = c56v0
        c56v0 = v44
        c56v2 = Name__4710a87d
        c56v0 = c56v0:IsA(c56v2)
        v37 = c56v0
      end
      c56v0 = v3
      c56v0 = c56v0.GetUIMode
      c56v0 = c56v0()
      v35 = c56v0
      c56v0 = v74
      c56v1 = nil
      c56v0.DuviriCaveZonesInit = c56v1
    end
    c56v0 = DeltaTime
    c56v0 = c56v0()
    c56v1 = mMovie
    c56v1:Name__b7f5bbc5(c56v0)
    c56v1 = v127
    c56v1 = c56v1()
    if not c56v1 then
      do return end
    end
    c56v1 = v88
    if not c56v1 then
      c56v1 = _G
      c56v1 = c56v1.UIColor_Shield
      if c56v1 ~= nil then
        c56v1 = v1
        c56v1 = c56v1.ConvertColorNumberToProceduralRGB
        c56v2 = _G
        c56v2 = c56v2.UIColor_Shield
        c56v1 = c56v1(c56v2)
        v89 = c56v1
        c56v1 = v1
        c56v1 = c56v1.ConvertColorNumberToProceduralRGB
        c56v2 = _G
        c56v2 = c56v2.UIColor_Overshield
        c56v1 = c56v1(c56v2)
        v90 = c56v1
        c56v1 = true
        v88 = c56v1
      end
    end
    c56v1 = v132
    c56v1(c56v0)
    c56v1 = v35
    c56v2 = v3
    c56v2 = c56v2.UI_MODE_IN_SPACE_SHIP
    if c56v1 ~= c56v2 then
      repeat
        c56v1 = v64
        if not c56v1 then
          c56v1 = _T.CrewHudUpdateRequired
          if not c56v1 then break end
        end
        c56v1 = _T
        c56v2 = nil
        c56v1.CrewHudUpdateRequired = c56v2
        c56v1 = v133
        c56v1()
      until true
      c56v1 = v37
      if c56v1 then
        c56v1 = v74
        c56v1 = c56v1.DuviriCaveZonesInit
        if not c56v1 then
          c56v1 = v74
          c56v2 = true
          c56v1.DuviriCaveZonesInit = c56v2
          c56v1 = gRegion
          c56v3 = Symbol
          c56v4 = "CaveZoneAttribute"
          c56v1 = c56v1:FindTagged(c56v3(c56v4))
          c56v2 = v74
          c56v3 = {}
          c56v2.DuviriCaveZones = c56v3
          c56v2 = ipairs
          c56v2, c56v3, c56v4 = c56v2(c56v1)
          for __renovice_for_0_0, __renovice_for_0_1 in c56v2, c56v3, c56v4 do
            c56v7 = __renovice_for_0_1:GetZone()
            c56v8 = IsNull
            c56v8 = c56v8(c56v7)
            if c56v8 then
              continue
            end
            c56v9 = v74
            c56v9 = c56v9.DuviriCaveZones
            c56v8 = table.insert
            c56v8(c56v9, c56v7)
          end
        end
      end
      c56v1 = v136
      c56v2 = v40
      c56v1(c56v2)
      c56v1 = v138
      c56v2 = v40
      c56v1(c56v2, c56v0)
      c56v1 = v78
      c56v1 = c56v1.showBossStatus
      if c56v1 then
        c56v1 = v113
        c56v2 = v78
        c56v1(c56v2, c56v0)
      end
      c56v1 = v79
      c56v1 = c56v1.showBossStatus
      if c56v1 then
        c56v1 = v113
        c56v2 = v79
        c56v1(c56v2, c56v0)
      end
    end
    c56v2 = v45
    c56v1 = IsNull
    c56v1 = c56v1(c56v2)
    if not c56v1 then
      c56v1 = mMovie
      c56v3 = v45
      c56v1:SetVisible(c56v3:IsVisible())
      c56v1 = _T.RailjackHudVisible
      if c56v1 ~= nil then
        c56v1 = mMovie
        c56v3 = "_root"
        c56v4 = 12
        c56v6 = _T.RailjackHudVisible
        if c56v6 then
          c56v5 = 100
        else
          c56v5 = 0
        end
        c56v1:SetNumberVariable(c56v3, c56v4, c56v5)
      else
        c56v1 = _T.ForcePostCameraAlpha
        if c56v1 ~= nil then
          c56v1 = mMovie
          c56v3 = "_root"
          c56v4 = 12
          c56v5 = _T.ForcePostCameraAlpha
          c56v1:SetNumberVariable(c56v3, c56v4, c56v5)
        else
          c56v1 = mMovie
          c56v3 = "_root"
          c56v4 = 12
          c56v5 = v45
          c56v7 = "_root"
          c56v8 = 12
          c56v1:SetNumberVariable(c56v3, c56v4, c56v5:GetNumberVariable(c56v7, c56v8))
        end
      end
    end
    c56v1 = _T.MinimalHud
    c56v2 = v86
    if c56v2 ~= c56v1 then
      v86 = c56v1
      c56v2 = v1
      c56v2 = c56v2.Ternary
      c56v3 = v86
      c56v4 = 0
      c56v5 = 100
      c56v2 = c56v2(c56v3, c56v4, c56v5)
      c56v5 = 1
      c56v6 = v67
      c56v3 = #c56v6
      c56v4 = 1
      for __renovice_for_1_0 = c56v5, c56v3, c56v4 do
        c56v6 = v67[__renovice_for_1_0]
        if c56v6 ~= nil then
          c56v7 = c56v6.Player
          if c56v7 ~= nil then
            c56v7 = c56v6.Player
            c56v7 = c56v7.clipName
            if c56v7 ~= nil then
              c56v7 = mMovie
              c56v9 = c56v6.Player
              c56v9 = c56v9.clipName
              c56v10 = 12
              c56v7:SetNumberVariable(c56v9, c56v10, c56v2)
            end
          end
        end
        if c56v6 == nil then
          continue
        end
        c56v7 = c56v6.Kubrow
        if c56v7 == nil then
          continue
        end
        c56v7 = c56v6.Kubrow
        c56v7 = c56v7.clipName
        if c56v7 == nil then
          continue
        end
        c56v7 = mMovie
        c56v9 = c56v6.Kubrow
        c56v9 = c56v9.clipName
        c56v10 = 12
        c56v7:SetNumberVariable(c56v9, c56v10, c56v2)
      end
    end
    repeat
      c56v2 = _T.HideMarkers
      c56v3 = v85
      if c56v3 == c56v2 then
        c56v3 = v47
        if not c56v3 then break end
      end
      v85 = c56v2
      c56v3 = false
      v47 = c56v3
      c56v3 = v1
      c56v3 = c56v3.Ternary
      c56v4 = v85
      c56v5 = 0
      c56v6 = 100
      c56v3 = c56v3(c56v4, c56v5, c56v6)
      c56v4 = pairs
      c56v5 = v46
      c56v4, c56v5, c56v6 = c56v4(c56v5)
      for __renovice_for_2_0, __renovice_for_2_1 in c56v4, c56v5, c56v6 do
        c56v9 = __renovice_for_2_1.garbage
        if c56v9 then
          continue
        end
        c56v9 = 0
        c56v10 = __renovice_for_2_1.clientWasVisible
        if c56v10 then
          c56v10 = v130
          c56v10 = c56v10(__renovice_for_2_1)
          if c56v10 then
            c56v9 = 1
          end
        end
        c56v10 = mMovie
        c56v12 = __renovice_for_2_1.clipIndex
        c56v13 = 12
        c56v14 = c56v3 * c56v9
        c56v10:SetNumberMember(c56v12, c56v13, c56v14)
      end
    until true
    c56v4 = v91
    c56v5 = RealDeltaTime
    c56v5 = c56v5()
    c56v3 = c56v4 - c56v5
    v91 = c56v3
    c56v3 = v91
    c56v4 = 0
    if c56v3 <= c56v4 then
      c56v3 = 0.3
      v91 = c56v3
      c56v3 = gFlashMgr
      c56v3 = c56v3:CiphersBEGIN()
      c56v4 = IsNull
      c56v4 = c56v4(c56v3)
      c56v5 = v92
      if c56v5 ~= c56v4 then
        v92 = c56v4
        c56v5 = mMovie
        c56v7 = v92
        c56v5:SetPreDrawUpdate(c56v7)
      end
    end
    c56v3 = v95
    if c56v3 then
      c56v3 = Vector
      c56v3 = c56v3()
      c56v4 = gRegion
      c56v4 = c56v4:GetLocalPlayer()
      c56v5 = IsNull
      c56v5 = c56v5(c56v4)
      if not c56v5 then
        c56v5 = c56v4:GetCamera()
        c56v6 = IsNull
        c56v6 = c56v6(c56v5)
        if not c56v6 then
          c56v6 = mMovie
          c56v9 = v95
          c56v11 = true
          c56v6:Name__075ecf08(c56v3, c56v9, c56v5, c56v11)
          c56v6 = mMovie
          c56v8 = "HintMessage"
          c56v9 = 0
          c56v10 = c56v3.x
          c56v6:SetNumberVariable(c56v8, c56v9, c56v10)
          c56v6 = mMovie
          c56v8 = "HintMessage"
          c56v9 = 1
          c56v10 = c56v3.y
          c56v6:SetNumberVariable(c56v8, c56v9, c56v10)
          c56v6 = mMovie
          c56v8 = "HintMessage"
          c56v9 = 13
          c56v11 = c56v3.z
          c56v12 = 1
          if not (c56v11 < c56v12) then
            c56v10 = false
          else
            c56v10 = true
          end
          c56v6:Name__d9713943(c56v8, c56v9, c56v10)
        end
      end
    end
    c56v3 = v96
    if c56v3 then
      local __renovice_state_0 = -1
      c56v3 = mMovie
      c56v5 = "HintMessage"
      c56v6 = 36
      c56v7 = mMovie
      c56v10 = v96
      c56v10 = c56v10.text
      c56v9 = c56v10 or ""
      c56v10 = true
      c56v11 = v96
      c56v11 = c56v11.replace
      c56v3:SetStringVariable(c56v5, c56v6, c56v7:GetLocalized(c56v9, c56v10, c56v11))
      c56v3 = v96
      c56v3 = c56v3.text
      if not c56v3 then
        __renovice_state_0 = -1
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c56v3 = v96
        c56v3 = c56v3.text
        if c56v3 == "" then
          __renovice_state_0 = -1
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        c56v3 = mMovie
        c56v5 = "HintMessage"
        c56v6 = 12
        c56v7 = 100
        c56v3:SetNumberVariable(c56v5, c56v6, c56v7)
        c56v3 = v95
        if c56v3 then
          __renovice_state_0 = 10
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        c56v3 = v33
        c56v3 = c56v3.ANCHOR_H_CENTRE
        c56v4 = v33
        c56v4 = c56v4.ANCHOR_V_CENTRE
        c56v5 = v93
        c56v6 = v94
        c56v7 = v33
        c56v9 = mMovie
        c56v10 = "HintMessage"
        c56v7:Unregister(c56v9, c56v10)
        c56v7 = v96
        c56v7 = c56v7.xAnchor
        if not c56v7 then
          __renovice_state_0 = 6
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c56v3 = v96.xAnchor
        c56v7 = v96
        c56v7 = c56v7.xOffsetRatio
        if c56v7 == nil then
          __renovice_state_0 = 6
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c56v7 = v96
        c56v7 = c56v7.xOffsetRatio
        c56v8 = mMovie
        c56v8 = c56v8:GetViewportWidth()
        c56v5 = c56v7 * c56v8
        __renovice_state_0 = 6
      end
      if __renovice_state_0 == 6 then
        c56v7 = v96
        c56v7 = c56v7.yAnchor
        if not c56v7 then
          __renovice_state_0 = 9
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        c56v4 = v96.yAnchor
        c56v7 = v96
        c56v7 = c56v7.yOffsetRatio
        if c56v7 == nil then
          __renovice_state_0 = 9
        else
          __renovice_state_0 = 8
        end
      end
      if __renovice_state_0 == 8 then
        c56v7 = v96
        c56v7 = c56v7.yOffsetRatio
        c56v8 = mMovie
        c56v8 = c56v8:GetViewportHeight()
        c56v6 = c56v7 * c56v8
        __renovice_state_0 = 9
      end
      if __renovice_state_0 == 9 then
        c56v7 = mMovie
        c56v9 = "HintMessage"
        c56v10 = 0
        c56v7:SetNumberVariable(c56v9, c56v10, c56v5)
        c56v7 = mMovie
        c56v9 = "HintMessage"
        c56v10 = 1
        c56v7:SetNumberVariable(c56v9, c56v10, c56v6)
        c56v7 = v33
        c56v9 = mMovie
        c56v10 = "HintMessage"
        c56v11 = {c56v4, c56v3}
        c56v7:Register(c56v9, c56v10, c56v11)
        c56v7 = v33
        c56v9 = mMovie
        c56v9 = c56v9:GetViewportWidth()
        c56v10 = mMovie
        c56v10 = c56v10:GetViewportHeight()
        c56v11 = true
        c56v12 = v55
        c56v7:Update(c56v9, c56v10, c56v11, c56v12)
        __renovice_state_0 = 10
      end
      if __renovice_state_0 ~= 10 then
        c56v3 = mMovie
        c56v5 = "HintMessage"
        c56v6 = 12
        c56v7 = 0
        c56v3:SetNumberVariable(c56v5, c56v6, c56v7)
      end
      c56v3 = nil
      v96 = c56v3
    end
    do return end
  end
  Update = v139
  v139 = function()
    local c57v0, c57v1, c57v2, c57v3, c57v4
    c57v0 = gFlashMgr
    c57v2 = v1
    c57v2 = c57v2.GetChatMovie
    c57v0 = c57v0:FindMovie(c57v2())
    c57v1 = IsNull
    c57v1 = c57v1(c57v0)
    if not c57v1 then
      c57v3 = "ToggleFocus"
      c57v4 = ""
      c57v0:Execute(c57v3, c57v4)
      c57v1 = true
      do return c57v1 end
    end
    do return end
  end
  ToggleChatWindow = v139
  v139 = function()
    local c58v0, c58v1, c58v2, c58v3, c58v4
    c58v0 = gFlashMgr
    c58v2 = v1
    c58v2 = c58v2.GetChatMovie
    c58v0 = c58v0:FindMovie(c58v2())
    c58v1 = IsNull
    c58v1 = c58v1(c58v0)
    if not c58v1 then
      c58v3 = "IsMaximized"
      c58v4 = ""
      c58v1 = c58v0:Execute(c58v3, c58v4)
      if c58v1 then
        c58v1 = true
        do return c58v1 end
      end
    end
    c58v1 = false
    do return c58v1 end
  end
  IsChatWindowOpen = v139
  v139 = function()
    local c59v0
    c59v0 = _T.IsButtonBarInputBlocked
    if c59v0 then
      c59v0 = _T.IsButtonBarInputBlocked
      c59v0 = c59v0()
      if c59v0 then
        c59v0 = true
        do return c59v0 end
      end
    end
    c59v0 = false
    do return c59v0 end
  end
  IsButtonBarTransitioning = v139
  v139 = function(c60v0, c60v1, c60v2, c60v3)
    local c60v4, c60v5, c60v6, c60v7, c60v8, c60v9
    c60v4 = v0
    c60v4 = c60v4.HandleHudScale
    c60v5 = mMovie
    c60v6 = v54
    c60v7 = v33
    c60v4 = c60v4(c60v5, c60v6, c60v7)
    v55 = c60v4
    c60v5 = v33
    c60v4 = IsNull
    c60v4 = c60v4(c60v5)
    if not c60v4 then
      c60v4 = v33
      c60v6 = mMovie
      c60v6 = c60v6:GetViewportWidth()
      c60v7 = mMovie
      c60v7 = c60v7:GetViewportHeight()
      c60v8 = true
      c60v9 = v55
      c60v4:Update(c60v6, c60v7, c60v8, c60v9)
    end
    c60v5 = math.min
    c60v5 = c60v5(c60v0, c60v1)
    c60v4 = c60v5 * 0.15
    v87 = c60v4
    c60v4 = v119
    c60v4()
    do return end
  end
  onViewportSizeChanged = v139
  v139 = function()
    local c61v0
    c61v0 = v122
    c61v0()
    do return end
  end
  OnProfileSaved = v139
  v139 = function()
    local c62v0, c62v1, c62v2, c62v3, c62v4, c62v5
    c62v1 = mMovie
    c62v0 = IsNull
    c62v0 = c62v0(c62v1)
    if not c62v0 then
      c62v1 = v33
      c62v0 = IsNull
      c62v0 = c62v0(c62v1)
      if not c62v0 then
        c62v0 = v33
        c62v2 = mMovie
        c62v2 = c62v2:GetViewportWidth()
        c62v3 = mMovie
        c62v3 = c62v3:GetViewportHeight()
        c62v4 = true
        c62v5 = v55
        c62v0:Update(c62v2, c62v3, c62v4, c62v5)
      end
    end
    do return end
  end
  onHudMarginsChanged = v139
  v139 = function(c63v0)
    local c63v1, c63v2, c63v3
    c63v1 = tonumber
    c63v1 = c63v1(c63v0)
    v72 = c63v1
    c63v2 = v72
    c63v3 = v72
    c63v1 = c63v2 * c63v3
    v72 = c63v1
    do return end
  end
  SetMaxDrawDistanceForLabels = v139
  v139 = function(c64v0, c64v1)
    local c64v2, c64v3, c64v4, c64v5, c64v6, c64v7, c64v8, c64v9
    c64v2 = Engine.IsPlayingWithController
    c64v2 = c64v2()
    if c64v2 then
      c64v2 = v3
      c64v2 = c64v2.GetUIMode
      c64v2 = c64v2()
      c64v3 = v3
      c64v3 = c64v3.UI_MODE_IN_SPACE_SHIP
      if c64v2 == c64v3 then
        c64v3 = v41
        c64v2 = IsNull
        c64v2 = c64v2(c64v3)
        if not c64v2 then
          c64v2 = v41
          c64v2 = c64v2:GetActivePowerSuit()
          c64v3 = IsNull
          c64v3 = c64v3(c64v2)
          if not c64v3 then
            c64v3 = false
            c64v4 = c64v2:GetAbilities()
            c64v5 = ipairs
            c64v5, c64v6, c64v7 = c64v5(c64v4)
            for __renovice_for_0_0, __renovice_for_0_1 in c64v5, c64v6, c64v7 do
              c64v9 = __renovice_for_0_1:IsOperatorAbility()
              if not c64v9 then
                continue
              end
              c64v3 = true
              break
            end
            if c64v3 then
              c64v5 = c64v2:Name__2a8fed57()
              c64v6 = IsNull
              c64v6 = c64v6(c64v5)
              if not c64v6 then
                c64v6 = c64v5:IsOperatorAbility()
                if not c64v6 then
                  c64v8 = "NEXT"
                  c64v2:Name__23838fac(c64v8)
                end
              end
            end
          end
        end
      end
    end
    c64v2 = true
    do return c64v2 end
  end
  NotifyAbilityChange = v139
  v139 = function()
    local c65v0
    c65v0 = v124
    c65v0()
    do return end
  end
  IconCacheFlushed = v139
  v139 = function()
    local c66v0
    c66v0 = v29
    do return c66v0 end
  end
  WantsEndOfMatchPreview = v139
  v139 = function()
    local c67v0
    c67v0 = false
    v29 = c67v0
    do return end
  end
  OnEndOfMatchPreviewOpened = v139
  v139 = function()
    local c68v0, c68v1, c68v2
    c68v0 = v0
    c68v0 = c68v0.CanShowEndOfMatchPreview
    c68v0 = c68v0()
    if c68v0 then
      c68v0 = _T.GetScreenRes
      c68v1 = "MissionStats"
      c68v0 = c68v0(c68v1)
      if c68v0 ~= nil then
        c68v1 = true
        v29 = c68v1
        c68v1 = mMovie
        c68v2 = "OnEndOfMatchPreviewOpened"
        c68v1:directionalRetracted(c68v0, c68v2)
      end
    end
    do return end
  end
  ForceOpenEndOfMatch = v139
  do return end
