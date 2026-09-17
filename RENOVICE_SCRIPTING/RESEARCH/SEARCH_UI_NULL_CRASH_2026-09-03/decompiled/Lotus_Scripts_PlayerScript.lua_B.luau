  local v0, v1, v2, v3, v4, v5
  v0 = require
  v1 = "Lotus.Interface.LotusUtilities"
  v0 = v0(v1)
  v1 = Symbol
  v2 = "BattleBegins"
  v1 = v1(v2)
  v2 = Symbol
  v3 = "BattleConcluded"
  v2 = v2(v3)
  v3 = require
  v4 = "Lotus.Interface.TransmissionUtilities"
  v3 = v3(v4)
  v4 = function(c1v0)
    local c1v1, c1v2, c1v3, c1v4, c1v5
    c1v1 = c1v0:InventoryControl()
    c1v1 = c1v1:GetActivePowerSuit()
    c1v2 = IsNull
    c1v2 = c1v2(c1v1)
    if not c1v2 then
      c1v2 = gGameConfig
      c1v4 = c1v1:GetMaxLevel()
      c1v2 = c1v2:Name__a534be9c(c1v4, c1v1:GetType())
      c1v3 = c1v1:GetXP()
      if c1v3 < c1v2 then
        c1v5 = c1v2 - c1v3
        c1v1:Name__6de778ba(c1v5)
        do return end
      end
      c1v1:SetXP(c1v2)
    end
    do return end
  end
  v5 = function(c2v0, c2v1)
    local c2v2, c2v3, c2v4, c2v5, c2v6, c2v7, c2v8, c2v9, c2v10, c2v11
    c2v2 = gRegion
    c2v2 = c2v2:GetLocalPlayerAvatar()
    c2v3 = IsNull
    c2v3 = c2v3(c2v2)
    if c2v3 then
      do return end
    end
    c2v3 = nil
    c2v5 = gPlayerProfileMgr
    c2v7 = 0
    c2v4 = IsNull
    c2v4 = c2v4(c2v5:GetPlayerProfile(c2v7))
    if c2v4 then
      do return end
    end
    c2v4 = gPlayerProfileMgr
    c2v6 = 0
    c2v4 = c2v4:GetPlayerProfile(c2v6)
    c2v3 = c2v4:GetGameSpecificData()
    c2v4 = false
    c2v5 = string.find
    c2v7 = "Combat"
    c2v5 = c2v5(c2v0, c2v7)
    if c2v5 ~= nil then
      c2v5 = string.find
      c2v7 = "Fallback"
      c2v5 = c2v5(c2v1, c2v7)
      if c2v5 ~= nil then
        c2v4 = false
      else
        c2v4 = true
      end
    end
    c2v5 = false
    c2v6 = string.find
    c2v8 = "Combat"
    c2v6 = c2v6(c2v1, c2v8)
    if c2v6 ~= nil then
      c2v6 = string.find
      c2v8 = "Fallback"
      c2v6 = c2v6(c2v1, c2v8)
      if c2v6 ~= nil then
        c2v5 = false
      else
        c2v5 = true
      end
    end
    c2v6 = not c2v4
    c2v7 = not c2v5
    c2v8 = nil
    if (c2v4 and c2v7) then
      c2v9 = print
      c2v10 = "Combat -> idle"
      c2v9(c2v10)
      c2v9 = v3
      c2v11 = v2
      c2v8 = c2v9:GetTransmissionResponse(c2v11, c2v3, c2v2)
    else
      if (c2v5 and c2v6) then
        c2v9 = print
        c2v10 = "Idle -> combat"
        c2v9(c2v10)
        c2v9 = v3
        c2v11 = v1
        c2v8 = c2v9:GetTransmissionResponse(c2v11, c2v3, c2v2)
      end
    end
    c2v9 = IsNull
    c2v9 = c2v9(c2v8)
    if not c2v9 then
      c2v2:GiveTransmissionAsync(c2v8)
    end
    do return end
  end
  DynMusicStateChanged = v5
  v5 = function(c3v0, c3v1, c3v2)
    local c3v3, c3v4, c3v5, c3v6, c3v7, c3v8, c3v9
    c3v3 = IsNull
    c3v3 = c3v3(c3v0)
    if c3v3 then
      do return end
    end
    c3v5 = 0
    c3v3 = c3v0:GetPlayerAvatar(c3v5)
    c3v4 = IsNull
    c3v4 = c3v4(c3v3)
    if c3v4 then
      do return end
    end
    c3v4 = false
    c3v5 = string.find
    c3v7 = "Combat"
    c3v5 = c3v5(c3v1, c3v7)
    if c3v5 ~= nil then
      c3v5 = string.find
      c3v7 = "Fallback"
      c3v5 = c3v5(c3v2, c3v7)
      if c3v5 ~= nil then
        c3v4 = false
      else
        c3v4 = true
      end
    end
    c3v5 = false
    c3v6 = string.find
    c3v8 = "Combat"
    c3v6 = c3v6(c3v2, c3v8)
    if c3v6 ~= nil then
      c3v6 = string.find
      c3v8 = "Fallback"
      c3v6 = c3v6(c3v2, c3v8)
      if c3v6 ~= nil then
        c3v5 = false
      else
        c3v5 = true
      end
    end
    c3v6 = not c3v4
    c3v7 = not c3v5
    if (c3v4 and c3v7) then
      c3v8 = c3v3:DamageControl()
      c3v9 = false
      c3v8:NotifyCombat(c3v9)
      do return end
    end
    if (c3v5 and c3v6) then
      c3v8 = c3v3:DamageControl()
      c3v9 = true
      c3v8:NotifyCombat(c3v9)
    end
    do return end
  end
  MasterMusicStateChanged = v5
  v5 = function()
    local c4v0
    c4v0 = _T.HideWeaponPanel
    c4v0()
    do return end
  end
  HideHudWeaponPanel = v5
  v5 = function()
    local c5v0
    c5v0 = _T.ShowWeaponPanel
    c5v0()
    do return end
  end
  ShowHudWeaponPanel = v5
  v5 = function()
    local c6v0
    c6v0 = _T.HideAbilityPanel
    c6v0()
    do return end
  end
  HideHudAbilityPanel = v5
  v5 = function()
    local c7v0
    c7v0 = _T.ShowAbilityPanel
    c7v0()
    do return end
  end
  ShowHudAbilityPanel = v5
  v5 = function(c8v0)
    local c8v1, c8v2, c8v3, c8v4, c8v5, c8v6, c8v7, c8v8, c8v9
    while true do
      c8v1 = IsNull
      c8v1 = c8v1(c8v0)
      if c8v1 then break end
      c8v1 = c8v0:GetPosture()
      c8v2 = 2
      if c8v1 == c8v2 then
        c8v2 = gRegion
        c8v2 = c8v2:GetNpcMgr()
        c8v4 = 2
        c8v5 = 6
        c8v6 = c8v0:GetPosition()
        c8v7 = innerRadius
        c8v8 = outerRadius
        c8v9 = true
        c8v2:SendPerception(c8v4, c8v5, c8v6, c8v0, c8v7, c8v8, c8v9)
      end
      c8v2 = Random
      c8v3 = intervalMin
      c8v4 = intervalMax
      c8v2 = c8v2(c8v3, c8v4)
      c8v3 = Sleep
      c8v3(c8v2)
    end
    do return end
  end
  ReportSoundPerceptionOnMove = v5
  v5 = function(c9v0)
    local c9v1, c9v2, c9v3, c9v4, c9v5, c9v6, c9v7, c9v8, c9v9, c9v10
    c9v1 = Sleep
    c9v2 = 1
    c9v1(c9v2)
    c9v1 = v0
    c9v1 = c9v1.GetUIMode
    c9v1 = c9v1()
    c9v2 = v0
    c9v2 = c9v2.UI_MODE_IN_GAME
    if c9v1 ~= c9v2 then
      c9v2 = v0
      c9v2 = c9v2.UI_MODE_IN_DOJO
      if c9v1 ~= c9v2 then
        do return end
      end
    end
    c9v2 = IsNull
    c9v2 = c9v2(c9v0)
    if not c9v2 then
      c9v2 = c9v0:Layertrackers()
      if not c9v2 then
        c9v2 = c9v0:IsMaster()
        if not c9v2 then
          do return end
        end
      end
      c9v2 = maxLevel
      if c9v2 then
        c9v2 = gRegion
        c9v2 = c9v2:IsMaster()
        if c9v2 then
          c9v2 = v4
          c9v2(c9v0)
        end
      end
      c9v2 = _T.MusicStateChangeRegistered
      if not c9v2 then
        c9v3 = gGameRules
        c9v2 = IsNull
        c9v2 = c9v2(c9v3)
        if not c9v2 then
          c9v2 = gGameRules
          c9v2 = c9v2:GetDynamicMusicMgr()
          c9v3 = IsNull
          c9v3 = c9v3(c9v2)
          if not c9v3 then
            c9v5 = "DynMusicStateChanged"
            c9v2:Name__d4ea3d03(c9v5)
            c9v3 = _T
            c9v4 = true
            c9v3.MusicStateChangeRegistered = c9v4
          end
        end
      end
      c9v3 = hudOverride
      c9v2 = IsNull
      c9v2 = c9v2(c9v3)
      if not c9v2 then
        c9v2 = true
        c9v3 = checkPreferDefaultHud
        if c9v3 then
          c9v3 = gPlayerProfileMgr
          c9v5 = 0
          c9v3 = c9v3:GetPlayerProfile(c9v5)
          c9v4 = IsNull
          c9v4 = c9v4(c9v3)
          if not c9v4 then
            c9v4 = c9v3:Settings()
            c9v5 = IsNull
            c9v5 = c9v5(c9v4)
            if not c9v5 then
              c9v5 = c9v4:PreferDuviriDefaultHud()
              c9v2 = not c9v5
            end
          end
        end
        if c9v2 then
          c9v4 = gGameData
          c9v3 = IsNull
          c9v3 = c9v3(c9v4)
          if not c9v3 then
            c9v3 = IsNull
            c9v3 = c9v3(c9v0)
            if not c9v3 then
              c9v3 = c9v0:Name__ad7b05b3()
              if c9v3 then
                c9v3 = _T
                c9v4 = true
                c9v3.ShouldSaveHudTrackers = c9v4
                c9v3 = gGameData
                c9v5 = hudOverride
                c9v6 = true
                c9v3:Name__8c0fe29a(c9v5, c9v6)
                c9v3 = _T
                c9v4 = nil
                c9v3.ShouldSaveHudTrackers = c9v4
              end
            end
          end
        end
      end
      c9v2 = doReportSoundPerceptionOnMov
      if c9v2 then
        c9v2 = gRegion
        c9v2 = c9v2:IsMaster()
        if c9v2 then
          c9v4 = Symbol
          c9v5 = "ReportSoundPerceptionOnMove"
          c9v4 = c9v4(c9v5)
          c9v5 = false
          c9v0:Name__a50e34c3(c9v4, c9v5)
        end
      end
      c9v2 = 0
      while true do
        c9v3 = IsNull
        c9v3 = c9v3(c9v0)
        if c9v3 then break end
        c9v3 = v0
        c9v3 = c9v3.UpdateHeadTracking
        c9v5 = true
        c9v3(c9v0, c9v5)
        c9v3 = gRegion
        c9v3 = c9v3:IsMaster()
        if c9v3 then
          c9v3 = DeltaTime
          c9v3 = c9v3()
          c9v2 = c9v2 - c9v3
          c9v3 = 0
          if c9v2 <= c9v3 then
            c9v2 = 0.5
            c9v3 = c9v0:DamageControl()
            c9v6 = gLotusDamageControllerType
            c9v4 = c9v3:IsA(c9v6)
            if c9v4 then
              c9v4 = c9v0:InventoryControl()
              c9v7 = 141
              c9v8 = nil
              c9v9 = nil
              c9v5 = c9v4:HasUpgrade(c9v7, c9v8, c9v9)
              if c9v5 then
                c9v7 = 141
                c9v8 = 4
                c9v9 = 0.8
                c9v4:RemoveUpgrade(c9v7, c9v8, c9v9)
              end
              c9v7 = true
              c9v5 = c9v3:GetShieldRechargeDelay(c9v7)
              c9v6 = 0.8
              if c9v5 < c9v6 then
                repeat
                  c9v6 = _T.ArcaneAegis
                  if c9v6 ~= nil then
                    c9v7 = _T.ArcaneAegis
                    c9v8 = c9v0:GetInstance()
                    c9v6 = c9v7[c9v8]
                    if c9v6 ~= nil then break end
                  end
                  c9v8 = 141
                  c9v9 = 4
                  c9v10 = 0.8
                  c9v4:AddUpgrade(c9v8, c9v9, c9v10)
                until true
              end
            end
          end
        end
        c9v3 = Sleep
        c9v4 = 0
        c9v3(c9v4)
      end
      do return end
    end
    do return end
  end
  Update = v5
  do return end
