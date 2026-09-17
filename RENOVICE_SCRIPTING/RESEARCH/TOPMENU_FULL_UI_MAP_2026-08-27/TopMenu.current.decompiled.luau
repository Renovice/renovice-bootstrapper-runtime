  local vT = {}
  vT[0] = require
  vT[1] = "EE.Interface.Utilities"
  vT[0] = vT[0](vT[1])
  vT[1] = require
  vT[2] = "Lotus.Interface.LotusUtilities"
  vT[1] = vT[1](vT[2])
  vT[2] = require
  vT[3] = "Lotus.Interface.UIStyleUtilities"
  vT[2] = vT[2](vT[3])
  vT[3] = require
  vT[4] = "Lotus.Interface.LotusNetworkUtilities"
  vT[3] = vT[3](vT[4])
  vT[4] = require
  vT[5] = "Lotus.Scripts.SimulacrumUtilities"
  vT[4] = vT[4](vT[5])
  vT[5] = require
  vT[6] = "Lotus.Interface.UIUtilities"
  vT[5] = vT[5](vT[6])
  vT[6] = require
  vT[7] = "Lotus.Interface.Libs.DuviriUtil"
  vT[6] = vT[6](vT[7])
  vT[7] = require
  vT[8] = "Lotus.Interface.FastTravelUtilities"
  vT[7] = vT[7](vT[8])
  vT[8] = require
  vT[9] = "Lotus.Scripts.Libs.QuestMissionLib"
  vT[8] = vT[8](vT[9])
  vT[9] = require
  vT[10] = "Lotus.Scripts.1999.SeasonLevelLib"
  vT[9] = vT[9](vT[10])
  vT[10] = require
  vT[11] = "Lotus.Scripts.Tutorials.NewPlayerTutorialMasteryRank"
  vT[10] = vT[10](vT[11])
  vT[11] = require
  vT[12] = "Lotus.Interface.InventoryUtilities"
  vT[11] = vT[11](vT[12])
  vT[12] = nil
  vT[13] = true
  vT[14] = false
  vT[15] = nil
  vT[16] = false
  vT[17] = nil
  vT[18] = nil
  vT[19] = 0
  vT[20] = false
  vT[21] = false
  vT[22] = nil
  vT[23] = {}
  mMenuOptions = vT[23]
  vT[23] = nil
  vT[24] = nil
  vT[25] = nil
  vT[26] = nil
  vT[27] = nil
  vT[28] = { pulsingTimer = nil }
  vT[29] = nil
  vT[30] = nil
  vT[31] = false
  vT[32] = false
  vT[33] = false
  vT[34] = false
  vT[35] = {}
  vT[36] = { x = nil, y = nil, width = nil, height = nil }
  vT[37] = SmoothFloat
  vT[38] = 0
  vT[39] = 0.95
  vT[37] = vT[37](vT[38], vT[39])
  vT[36].x = vT[37]
  vT[37] = SmoothFloat
  vT[38] = 0
  vT[39] = 0.95
  vT[37] = vT[37](vT[38], vT[39])
  vT[36].y = vT[37]
  vT[37] = SmoothFloat
  vT[38] = 10
  vT[39] = 0.95
  vT[37] = vT[37](vT[38], vT[39])
  vT[36].width = vT[37]
  vT[37] = SmoothFloat
  vT[38] = 10
  vT[39] = 0.95
  vT[37] = vT[37](vT[38], vT[39])
  vT[36].height = vT[37]
  vT[37] = { x = 20, y = 20, width = 10, height = 10 }
  vT[38] = { x = 0, y = 0, width = 50, height = 50 }
  vT[39] = false
  vT[40] = false
  vT[41] = false
  vT[42] = nil
  vT[43] = nil
  vT[44] = nil
  vT[45] = nil
  vT[46] = 0.0001
  vT[47] = {}
  vT[48] = 0
  vT[49] = nil
  vT[50] = nil
  vT[51] = true
  vT[52] = false
  vT[53] = true
  vT[54] = false
  vT[55] = nil
  vT[56] = false
  vT[57] = nil
  vT[58] = Engine.STACKSFollies
  vT[58] = vT[58]()
  vT[59] = {}
  vT[60] = false
  vT[61] = false
  vT[62] = false
  vT[63] = nil
  vT[64] = {}
  vT[65] = {}
  vT[66] = Symbol
  vT[67] = "RelayReconstruction"
  vT[66] = vT[66](vT[67])
  vT[67] = Symbol
  vT[68] = "IronwakeHUB3"
  vT[67] = vT[67](vT[68])
  vT[68] = nil
  vT[69] = { uiScale = nil, MOVIE_SCALE = 1.2, isIpad = false, marketHighlightMovie = nil }
  vT[70] = { x = 1, y = 1 }
  vT[69].uiScale = vT[70]
  vT[70] = function(c1v0, c1v1, c1v2)
    local c1v3, c1v4, c1v5, c1v6, c1v7, c1v8, c1v9, c1v10, c1v11, c1v12, c1v13, c1v14, c1v15, c1v16
    c1v4 = gGameData
    c1v3 = IsNull
    c1v3 = c1v3(c1v4)
    if not c1v3 then
      c1v3 = vT[7]
      c1v3 = c1v3.HasClan
      c1v3 = c1v3()
      if c1v3 then
        if c1v0 == "nil" then
          c1v0 = nil
        end
        c1v3 = vT[1]
        c1v3 = c1v3.GetUnclaimedClanReward
        c1v4 = gGameData
        c1v3 = c1v3(c1v4)
        if c1v1 ~= nil then
          if c1v1 ~= "true" then
            c1v3 = false
          else
            c1v3 = true
          end
        end
        c1v4 = mMovie
        c1v6 = "/Lotus/Language/Menu/MenuCommunication"
        c1v7 = false
        c1v4 = c1v4:GetLocalized(c1v6, c1v7)
        c1v5 = mMovie
        c1v7 = "/Lotus/Language/Menu/Profile_Clan"
        c1v8 = false
        c1v5 = c1v5:GetLocalized(c1v7, c1v8)
        c1v6 = nil
        c1v7 = false
        if c1v0 ~= "nil" then
          c1v8 = c1v0.Name
          if c1v8 ~= c1v4 then
            c1v8 = c1v0.Name
            if c1v8 ~= c1v5 then
              do return end
            end
          end
          c1v6 = c1v0.mClipName
          c1v8 = c1v0.Name
          if c1v8 ~= c1v4 then
            c1v7 = false
          else
            c1v7 = true
          end
        else
          if c1v2 == "true" then
            c1v6 = "MenuItem2"
            c1v7 = true
          else
            c1v6 = "MenuItem7"
          end
        end
        c1v10 = ".NewIndicator"
        c1v8 = c1v6 .. c1v10
        c1v9 = mMovie
        c1v12 = 13
        c1v9:Name__d9713943(c1v8, c1v12, c1v3)
        if not c1v3 then
          do return end
        end
        c1v10 = claimRewardIcon
        c1v9 = IsNull
        c1v9 = c1v9(c1v10)
        if not c1v9 then
          c1v9 = mMovie
          c1v13 = ".Icon"
          c1v11 = c1v8 .. c1v13
          c1v12 = claimRewardIcon
          c1v9:OverrideTexture(c1v11, c1v12)
          c1v9 = mMovie
          c1v13 = ".Icon"
          c1v11 = c1v8 .. c1v13
          c1v12 = 11
          c1v13 = vT[2]
          c1v13 = c1v13.GetColor
          c1v14 = 9
          c1v15 = true
          c1v9:SetNumberVariable(c1v11, c1v12, c1v13(c1v14, c1v15))
        end
        c1v9 = mMovie
        c1v12 = "Backer"
        c1v13 = 14
        c1v9 = c1v9:Name__46690123(c1v6, c1v12, c1v13)
        c1v10 = mMovie
        c1v13 = "Backer"
        c1v14 = 15
        c1v10 = c1v10:Name__46690123(c1v6, c1v13, c1v14)
        c1v11 = mMovie
        c1v14 = 14
        c1v15 = 32
        c1v11:SetNumberVariable(c1v8, c1v14, c1v15)
        c1v11 = mMovie
        c1v14 = 15
        c1v15 = 32
        c1v11:SetNumberVariable(c1v8, c1v14, c1v15)
        c1v11 = mMovie
        c1v14 = 0
        c1v16 = -c1v9
        c1v15 = c1v16 - 35
        c1v11:SetNumberVariable(c1v8, c1v14, c1v15)
        if c1v7 then
          c1v11 = mMovie
          c1v14 = 1
          c1v15 = c1v10 - 8
          c1v11:SetNumberVariable(c1v8, c1v14, c1v15)
          do return end
        end
        c1v11 = mMovie
        c1v14 = 1
        c1v15 = c1v10 + 3
        c1v11:SetNumberVariable(c1v8, c1v14, c1v15)
        do return end
      end
    end
    do return end
  end
  UpdateUnclaimedClanReward = vT[70]
  vT[70] = function(c10v0)
    local c10v1, c10v2, c10v3, c10v4, c10v5, c10v6, c10v7, c10v8, c10v9, c10v10, c10v11, c10v12, c10v13, c10v14, c10v15
    c10v1 = Engine.IsMobile
    c10v1 = c10v1()
    if not c10v1 then
      do return end
    end
    c10v2 = c10v0.mClipName
    c10v3 = ".NewIndicator"
    c10v1 = c10v2 .. c10v3
    c10v2 = vT[1]
    c10v2 = c10v2.IsInGamePlay
    c10v2 = c10v2()
    if c10v2 then
      c10v3 = gGameRules
      c10v2 = IsNull
      c10v2 = c10v2(c10v3)
      if not c10v2 then
        c10v2 = gGameRules
        c10v2 = c10v2:GetMission()
        c10v3 = c10v2.keyChainName
        c10v4 = WeakResource
        c10v5 = "/Lotus/Types/Keys/NewPlayerQuest/NewPlayerQuestKeyChain"
        c10v4 = c10v4(c10v5)
        if c10v3 == c10v4 then
          c10v3 = mMovie
          c10v6 = 13
          c10v7 = false
          c10v3:Name__d9713943(c10v1, c10v6, c10v7)
          do return end
        end
      end
    end
    c10v2 = function(c2v0)
      local c2v1, c2v2, c2v3, c2v4, c2v5, c2v7, c2v8
      c2v1 = mMovie
      c2v3 = "/Lotus/Language/MasteryTest/MenuRankUp"
      c2v4 = false
      c2v1 = c2v1:GetLocalized(c2v3, c2v4)
      c2v2 = string.gsub
      c2v4 = "^<[^>]*>"
      c2v5 = ""
      c2v2 = c2v2(c2v1, c2v4, c2v5)
      c2v4 = string.find
      c2v7 = 1
      c2v8 = true
      c2v4 = c2v4(c2v0, c2v2, c2v7, c2v8)
      if c2v4 == nil then
        c2v3 = false
      else
        c2v3 = true
      end
      do return c2v3 end
    end
    c10v3 = function(c3v0)
      local c3v1, c3v2, c3v4, c3v5
      c3v2 = mMovie
      c3v4 = "/Lotus/Language/Menu/Store_Extras"
      c3v5 = true
      c3v2 = c3v2:GetLocalized(c3v4, c3v5)
      if c3v0 ~= c3v2 then
        c3v1 = false
      else
        c3v1 = true
      end
      do return c3v1 end
    end
    c10v4 = function(c4v0)
      local c4v1, c4v2, c4v4, c4v5
      c4v2 = mMovie
      c4v4 = "/Lotus/Language/Menu/MenuLoadout"
      c4v5 = true
      c4v2 = c4v2:GetLocalized(c4v4, c4v5)
      if c4v0 ~= c4v2 then
        c4v1 = false
      else
        c4v1 = true
      end
      do return c4v1 end
    end
    c10v5 = function(c5v0)
      local c5v1, c5v2, c5v4, c5v5
      c5v2 = mMovie
      c5v4 = "/Lotus/Language/Menu/ShowCollection"
      c5v5 = true
      c5v2 = c5v2:GetLocalized(c5v4, c5v5)
      if c5v0 ~= c5v2 then
        c5v1 = false
      else
        c5v1 = true
      end
      do return c5v1 end
    end
    c10v6 = function(c6v0)
      local c6v1, c6v2, c6v4, c6v5
      c6v2 = mMovie
      c6v4 = "/Lotus/Language/Menu/MenuCommunication"
      c6v5 = true
      c6v2 = c6v2:GetLocalized(c6v4, c6v5)
      if c6v0 ~= c6v2 then
        c6v1 = false
      else
        c6v1 = true
      end
      do return c6v1 end
    end
    c10v7 = function(c7v0)
      local c7v1, c7v2, c7v4, c7v5
      c7v2 = mMovie
      c7v4 = "/Lotus/Language/Menu/Mailbox_Inbox"
      c7v5 = true
      c7v2 = c7v2:GetLocalized(c7v4, c7v5)
      if c7v0 ~= c7v2 then
        c7v1 = false
      else
        c7v1 = true
      end
      do return c7v1 end
    end
    c10v8 = function(c8v0)
      local c8v1, c8v2, c8v3, c8v5, c8v6
      c8v2 = string.upper
      c8v3 = mMovie
      c8v5 = "/Lotus/Language/Menu/Codex_Quests"
      c8v6 = true
      c8v2 = c8v2(c8v3:GetLocalized(c8v5, c8v6))
      if c8v0 ~= c8v2 then
        c8v1 = false
      else
        c8v1 = true
      end
      do return c8v1 end
    end
    c10v9 = function(c9v0)
      local c9v1, c9v2, c9v3, c9v4, c9v5, c9v6, c9v7, c9v8, c9v9
      c9v1 = c10v2
      c9v1 = c9v1(c9v0)
      if c9v1 then
        c9v2 = gGameData
        c9v2 = c9v2:Name__927457bb()
        c9v3 = 0
        if c9v3 < c9v2 then
          c9v1 = false
        else
          c9v1 = true
        end
        do return c9v1 end
      end
      c9v1 = c10v3
      c9v1 = c9v1(c9v0)
      if not c9v1 then
        c9v2 = vT[1]
        c9v2 = c9v2.IsInEntratiHub
        c9v2 = c9v2()
        if c9v2 then
          c9v1 = "ArsenalLab"
        else
          c9v1 = "Arsenal"
        end
        c9v2 = gRegion
        c9v4 = Symbol
        c9v2 = c9v2:FindFirstTagged(c9v4(c9v1))
        c9v3 = vT[65]
        c9v3 = c9v3.HasArsenalFeature
        if c9v3 then
          c9v4 = IsNull
          c9v4 = c9v4(c9v2)
          c9v3 = not c9v4
          if c9v3 then
            c9v3 = c9v2:IsEnabled()
          end
        end
        c9v4 = c9v3
        if c9v4 then
          c9v4 = vT[11]
          c9v4 = c9v4.HasNewItems
          c9v5 = vT[11]
          c9v5 = c9v5.BREADCRUMBING_ARSENAL_CATEGORIES
          c9v4 = c9v4(c9v5)
        end
        c9v5 = vT[11]
        c9v5 = c9v5.HasNewUpgradesToEquippedItems
        c9v6 = 0
        c9v5 = c9v5(c9v6)
        c9v6 = gRegion
        c9v8 = Symbol
        c9v9 = "Mods"
        c9v6 = c9v6:FindFirstTagged(c9v8(c9v9))
        c9v7 = vT[65]
        c9v7 = c9v7.HasModsFeature
        if c9v7 then
          c9v8 = IsNull
          c9v8 = c9v8(c9v6)
          c9v7 = not c9v8
          if c9v7 then
            c9v7 = c9v6:IsEnabled()
          end
        end
        c9v8 = c9v7
        if c9v8 then
          c9v8 = vT[11]
          c9v8 = c9v8.HasNewModsInModScreen
          c9v8 = c9v8()
        end
        c9v9 = c9v4
        if not c9v9 then
          c9v9 = c9v5
          if not c9v9 then
            c9v9 = c9v8
          end
        end
        do return c9v9 end
      end
      c9v1 = c10v4
      c9v1 = c9v1(c9v0)
      if c9v1 then
        c9v1 = vT[11]
        c9v1 = c9v1.HasNewItems
        c9v2 = vT[11]
        c9v2 = c9v2.BREADCRUMBING_ARSENAL_CATEGORIES
        c9v1 = c9v1(c9v2)
        c9v2 = vT[11]
        c9v2 = c9v2.HasNewUpgradesToEquippedItems
        c9v3 = 0
        c9v2 = c9v2(c9v3)
        c9v3 = c9v1 or c9v2
        do return c9v3 end
      end
      c9v1 = c10v5
      c9v1 = c9v1(c9v0)
      if not c9v1 then
        c9v1 = gRegion
        c9v3 = Symbol
        c9v4 = "Mods"
        c9v1 = c9v1:FindFirstTagged(c9v3(c9v4))
        c9v2 = vT[65]
        c9v2 = c9v2.HasModsFeature
        if c9v2 then
          c9v3 = IsNull
          c9v3 = c9v3(c9v1)
          c9v2 = not c9v3
          if c9v2 then
            c9v2 = c9v1:IsEnabled()
          end
        end
        c9v3 = c9v2
        if c9v3 then
          c9v3 = vT[11]
          c9v3 = c9v3.HasNewModsInModScreen
          c9v3 = c9v3()
        end
        do return c9v3 end
      end
      c9v1 = c10v6
      c9v1 = c9v1(c9v0)
      if not c9v1 then
        c9v1 = c10v7
        c9v1 = c9v1(c9v0)
        if not c9v1 then
          c9v1 = c10v8
          c9v1 = c9v1(c9v0)
          if c9v1 then
            c9v1 = vT[11]
            c9v1 = c9v1.HasNewAvailableQuests
            do return c9v1() end
          end
          c9v1 = false
          do return c9v1 end
        end
      end
      c9v2 = vT[1]
      c9v2 = c9v2.GetUnreadMessageCount
      c9v2 = c9v2()
      c9v3 = 0
      if c9v2 <= c9v3 then
        c9v1 = false
      else
        c9v1 = true
      end
      do return c9v1 end
    end
    c10v11 = c10v0.Name
    c10v10 = c10v9(c10v11)
    c10v11 = mMovie
    c10v14 = 13
    c10v11:Name__d9713943(c10v1, c10v14, c10v10)
    if c10v10 then
      c10v11 = vT[5]
      c10v11 = c10v11.StartPulsingAnimation
      c10v12 = mMovie
      c10v13 = vT[28]
      c10v13 = c10v13.pulsingTimer
      c10v15 = { fadeOutDuration = 0.6, fadeInDuration = 0.6, holdDuration = 0, loopDelay = 0, minAlpha = 50 }
      c10v11(c10v12, c10v13, c10v1, c10v15)
    end
    do return end
  end
  vT[69].UpdateBreadcrumb = vT[70]
  vT[70] = function(c12v0, c12v1)
    local c12v2, c12v3, c12v4
    c12v2 = Engine.IsMobile
    c12v2 = c12v2()
    if c12v2 then
      c12v3 = vT[22]
      c12v2 = IsNull
      c12v2 = c12v2(c12v3)
      if not c12v2 then
        c12v2 = vT[22]
        c12v4 = function(c11v0)
          local c11v1
          c11v1 = vT[69]
          c11v1 = c11v1.UpdateBreadcrumb
          c11v1(c11v0)
          do return end
        end
        c12v2:RunForAllElements(c12v4)
      end
    end
    do return end
  end
  OnInboxSync = vT[70]
  vT[70] = function(c13v0, c13v1)
    local c13v2, c13v3
    c13v2 = Engine.IsMobile
    c13v2 = c13v2()
    if c13v2 then
      c13v3 = gGameData
      c13v2 = IsNull
      c13v2 = c13v2(c13v3)
      if not c13v2 then
        c13v3 = vT[28]
        c13v3 = c13v3.pulsingTimer
        c13v2 = IsNull
        c13v2 = c13v2(c13v3)
        if not c13v2 then
          c13v2 = vT[28]
          c13v2 = c13v2.pulsingTimer
          c13v2:ClearTimers()
        end
      end
    end
    do return end
  end
  OnInboxClosed = vT[70]
  vT[70] = function(c14v0)
    local c14v1, c14v2
    if not c14v0 then
      c14v1 = print
      c14v2 = "Photobooth session hosting failed"
      c14v1(c14v2)
    end
    do return end
  end
  OnLobbyReady = vT[70]
  vT[70] = function()
    local c15v0, c15v1, c15v2, c15v3, c15v4, c15v5
    c15v0 = Engine.IsMobile
    c15v0 = c15v0()
    if not c15v0 then
      do return end
    end
    c15v0 = vT[69]
    c15v1 = vT[5]
    c15v1 = c15v1.GetMovieScale
    c15v2 = mMovie
    c15v3 = vT[69]
    c15v3 = c15v3.MOVIE_SCALE
    c15v4 = true
    c15v1 = c15v1(c15v2, c15v3, c15v4)
    c15v0.uiScale = c15v1
    c15v0 = mMovie
    c15v2 = "_root"
    c15v3 = 5
    c15v5 = vT[69]
    c15v5 = c15v5.uiScale
    c15v5 = c15v5.x
    c15v4 = c15v5 * 100
    c15v0:SetNumberVariable(c15v2, c15v3, c15v4)
    c15v0 = mMovie
    c15v2 = "_root"
    c15v3 = 6
    c15v5 = vT[69]
    c15v5 = c15v5.uiScale
    c15v5 = c15v5.y
    c15v4 = c15v5 * 100
    c15v0:SetNumberVariable(c15v2, c15v3, c15v4)
    do return end
  end
  HandleIpadScaleIOS = vT[70]
  vT[70] = function()
    local c16v0, c16v1, c16v2, c16v3
    c16v0 = WeakResource
    c16v1 = "/Lotus/Types/Keys/SimulacrumTestKey"
    c16v0 = c16v0(c16v1)
    c16v3 = gGameData
    c16v2 = IsNull
    c16v2 = c16v2(c16v3)
    c16v1 = not c16v2
    if c16v1 then
      c16v1 = gGameData
      c16v1 = c16v1:GetInventory()
      c16v1 = c16v1:Name__6b7a5eec(c16v0)
    end
    do return c16v1 end
  end
  vT[71] = function()
    local c17v0
    c17v0 = vT[4]
    c17v0 = c17v0.SelectDangerRoom
    c17v0()
    do return end
  end
  vT[72] = function()
    local c18v0, c18v1, c18v2, c18v3
    c18v1 = gFlashMgr
    c18v3 = inspectorMovie
    c18v0 = IsNull
    c18v0 = c18v0(c18v1:FindMovie(c18v3))
    if c18v0 then
      c18v0 = gFlashMgr
      c18v2 = inspectorMovie
      c18v0:PushMovie(c18v2)
    end
    do return end
  end
  vT[73] = function()
    do return end
  end
  GiveAcceptInviteFocus = vT[73]
  vT[73] = function()
    do return end
  end
  RemoveInput = vT[73]
  vT[73] = function(c21v0)
    do return end
  end
  GiveFocus = vT[73]
  vT[73] = function()
    local c22v0
    c22v0 = true
    do return c22v0 end
  end
  SupportsThemes = vT[73]
  vT[73] = function()
    local c23v0, c23v1, c23v2, c23v3, c23v4
    c23v0 = vT[47]
    c23v1 = vT[2]
    c23v1 = c23v1.GetColor
    c23v2 = 9
    c23v3 = true
    c23v1 = c23v1(c23v2, c23v3)
    c23v0.Title = c23v1
    c23v0 = vT[47]
    c23v1 = vT[2]
    c23v1 = c23v1.GetColor
    c23v2 = 10
    c23v3 = true
    c23v1 = c23v1(c23v2, c23v3)
    c23v0.TitleHighlight = c23v1
    c23v0 = vT[47]
    c23v1 = vT[2]
    c23v1 = c23v1.GetColor
    c23v2 = 6
    c23v3 = true
    c23v1 = c23v1(c23v2, c23v3)
    c23v0.Subtitle = c23v1
    c23v0 = vT[47]
    c23v1 = vT[0]
    c23v1 = c23v1.ConvertColorNumberToProceduralRGB
    c23v2 = vT[2]
    c23v2 = c23v2.GetColor
    c23v3 = 2
    c23v4 = true
    c23v1 = c23v1(c23v2(c23v3, c23v4))
    c23v0.Backer = c23v1
    c23v0 = vT[47]
    c23v1 = vT[0]
    c23v1 = c23v1.ConvertColorNumberToProceduralRGB
    c23v2 = vT[47]
    c23v2 = c23v2.Title
    c23v1 = c23v1(c23v2)
    c23v0.Border = c23v1
    c23v0 = vT[47]
    c23v1 = vT[0]
    c23v1 = c23v1.ConvertColorNumberToProceduralRGB
    c23v2 = vT[47]
    c23v2 = c23v2.TitleHighlight
    c23v1 = c23v1(c23v2)
    c23v0.BorderHighlight = c23v1
    do return end
  end
  vT[74] = function()
    local c25v0, c25v1, c25v2
    c25v0 = vT[73]
    c25v0()
    c25v1 = vT[22]
    c25v0 = IsNull
    c25v0 = c25v0(c25v1)
    if not c25v0 then
      c25v0 = vT[22]
      c25v2 = function(c24v0)
        local c24v1
        c24v1 = vT[22]
        c24v1 = c24v1.mElementDrawCallback
        c24v1(c24v0)
        do return end
      end
      c25v0:RunForAllElements(c25v2)
    end
    do return end
  end
  OnStyleChangedCallback = vT[74]
  vT[74] = function(c28v0, c28v1)
    local c28v2, c28v3, c28v4, c28v5, c28v6, c28v7, c28v8, c28v9, c28v10, c28v11, c28v12
    c28v2 = function(c26v0)
      local c26v1, c26v2, c26v3, c26v6, c26v7, c26v8, c26v9, c26v10
      c26v1 = ipairs
      c26v2 = vT[59]
      c26v1, c26v2, c26v3 = c26v1(c26v2)
      for c26v4, c26v5 in c26v1, c26v2, c26v3 do
        c26v7 = c26v5.Attachment
        c26v6 = IsNull
        c26v6 = c26v6(c26v7)
        if not c26v6 then
          c26v6 = c26v5.Attachment
          c26v8 = Lerp
          c26v9 = c26v5.CurrentDissolve
          c26v10 = c28v0
          c26v6:SetDissolve(c26v8(c26v9, c26v10, c26v0))
        end
      end
      do return end
    end
    c28v3 = FlashInterpolate
    c28v4 = mMovie
    c28v5 = "Tile._parent"
    c28v6 = 2
    c28v7 = {c28v2}
    c28v9 = 1
    c28v8 = {c28v9}
    c28v9 = vT[0]
    c28v9 = c28v9.Ternary
    c28v11 = 0
    c28v12 = 0.25
    c28v9 = c28v9(c28v1, c28v11, c28v12)
    c28v10 = 0
    c28v11 = function()
      local c27v0, c27v1, c27v2, c27v3, c27v4
      c27v2 = 1
      c27v3 = vT[59]
      c27v0 = #c27v3
      c27v1 = 1
      for c27v2 = c27v2, c27v0, c27v1 do
        c27v4 = vT[59]
        c27v3 = c27v4[c27v2]
        c27v4 = c28v0
        c27v3.CurrentDissolve = c27v4
      end
      do return end
    end
    c28v3(c28v4, c28v5, c28v6, c28v7, c28v8, c28v9, c28v10, c28v11)
    do return end
  end
  vT[75] = function()
    local c29v0, c29v1, c29v2
    c29v0 = vT[0]
    c29v0 = c29v0.GetEntityFromTag
    c29v1 = "CloseCurrentConsole"
    c29v0 = c29v0(c29v1)
    c29v1 = IsNull
    c29v1 = c29v1(c29v0)
    if c29v1 then
      c29v1 = print
      c29v2 = " TopMenu - ERROR: Could not find CloseCurrentConsole script."
      c29v1(c29v2)
      do return end
    end
    c29v0:RunScripts()
    do return end
  end
  vT[76] = function()
    local c30v0, c30v1, c30v2
    c30v0 = vT[54]
    if c30v0 then
      do return end
    end
    c30v0 = EndAvatarDrawOnTop
    c30v0()
    c30v0 = vT[1]
    c30v0 = c30v0.IsInGamePlay
    c30v0 = c30v0()
    if c30v0 then
      c30v1 = gGameRules
      c30v0 = IsNull
      c30v0 = c30v0(c30v1)
      if not c30v0 then
        c30v0 = gGameRules
        c30v0:Name__1671b2a0()
      end
    end
    c30v0 = _T.SetButtons
    if c30v0 then
      c30v0 = _T.SetButtons
      c30v1 = mMovie
      c30v2 = nil
      c30v0(c30v1, c30v2)
    end
    c30v1 = gChallengeMgr
    c30v0 = IsNull
    c30v0 = c30v0(c30v1)
    if not c30v0 then
      c30v0 = gChallengeMgr
      c30v0:ClearChallengeQueue()
    end
    c30v0 = true
    vT[54] = c30v0
    do return end
  end
  vT[77] = function(c31v0)
    local c31v1, c31v2, c31v3, c31v4, c31v5, c31v7, c31v8
    c31v2 = 0
    c31v4 = vT[19]
    c31v5 = vT[0]
    c31v5 = c31v5.Ternary
    c31v7 = 1
    c31v8 = -1
    c31v5 = c31v5(c31v0, c31v7, c31v8)
    c31v3 = c31v4 + c31v5
    c31v1 = math.max
    c31v1 = c31v1(c31v2, c31v3)
    vT[19] = c31v1
    do return end
  end
  vT[78] = function()
    local c32v0, c32v1, c32v2, c32v3, c32v4, c32v5, c32v6, c32v7
    c32v0 = vT[5]
    c32v0 = c32v0.ProfileIconDeselect
    c32v0()
    c32v0 = _T
    c32v1 = false
    c32v0.TopMenuOpen = c32v1
    c32v0 = _T
    c32v1 = nil
    c32v0.ClosingTopMenu = c32v1
    c32v0 = _T
    c32v1 = nil
    c32v0.OpeningMailbox = c32v1
    c32v0 = _T
    c32v1 = nil
    c32v0.ForceOpenScreen = c32v1
    c32v0 = Engine.IsMobile
    c32v0 = c32v0()
    if c32v0 then
      c32v0 = _T
      c32v1 = nil
      c32v0.LastClickedPlayerId = c32v1
    end
    c32v1 = vT[50]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = vT[48]
      if c32v0 ~= 0 then
        c32v0 = vT[50]
        c32v2 = "_root"
        c32v3 = 12
        c32v4 = 100
        c32v0:SetNumberVariable(c32v2, c32v3, c32v4)
      end
    end
    c32v1 = gRegion
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    c32v0 = ipairs
    c32v1 = vT[35]
    c32v0, c32v1, c32v2 = c32v0(c32v1)
    for c32v3, c32v4 in c32v0, c32v1, c32v2 do
      c32v5 = gRegion
      c32v5:DestroyObject(c32v4)
    end
    c32v0 = gRegion
    c32v2 = vT[45]
    c32v0:DestroyObject(c32v2)
    for c32v3, c32v4 in c32v0, c32v1, c32v2 do
    end
    c32v0 = vT[74]
    c32v1 = 0
    c32v2 = true
    c32v0(c32v1, c32v2)
    c32v1 = vT[25]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = vT[25]
      c32v0:Destroy()
    end
    c32v1 = vT[24]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if c32v0 then
      c32v1 = gRegion
      c32v0 = IsNull
      c32v0 = c32v0(c32v1)
      if not c32v0 then
        c32v0 = gRegion
        c32v0 = c32v0:GetLocalPlayers()
        c32v1 = #c32v0
        c32v2 = 0
        if c32v2 < c32v1 then
          c32v1 = c32v0[1]
          c32v2 = IsNull
          c32v2 = c32v2(c32v1)
          if not c32v2 then
            c32v2 = c32v1:GetAvatar()
            vT[24] = c32v2
          end
        end
      end
    end
    c32v0 = vT[76]
    c32v0()
    c32v1 = vT[24]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = vT[51]
      if c32v0 then
        c32v0 = vT[24]
        c32v0 = c32v0:CameraControl()
        c32v1 = IsNull
        c32v1 = c32v1(c32v0)
        if not c32v1 then
          c32v2 = vT[26]
          c32v1 = IsNull
          c32v1 = c32v1(c32v2)
          if not c32v1 then
            c32v3 = nil
            c32v4 = 0
            c32v0:SetCameraSpot(c32v3, c32v4)
          end
          c32v3 = vT[26]
          c32v4 = vT[0]
          c32v4 = c32v4.Ternary
          c32v6 = vT[26]
          c32v5 = IsNull
          c32v5 = c32v5(c32v6)
          c32v6 = 0
          c32v7 = 0.25
          c32v0:SetCameraSpot(c32v3, c32v4(c32v5, c32v6, c32v7))
        end
      end
      c32v0 = vT[60]
      if c32v0 then
        c32v0 = vT[24]
        c32v2 = nil
        c32v3 = false
        c32v0:PlayNonReplicatedAnimation(c32v2, c32v3)
      end
      c32v0 = vT[61]
      if c32v0 then
        c32v1 = vT[24]
        c32v0 = IsNull
        c32v0 = c32v0(c32v1)
        if not c32v0 then
          c32v0 = vT[7]
          c32v0 = c32v0.OpenDecorationMode
          c32v1 = vT[62]
          c32v2 = paintBotDecoType
          c32v0(c32v1, c32v2)
          c32v0 = false
          vT[61] = c32v0
          c32v0 = false
          vT[62] = c32v0
        end
      end
    end
    c32v0 = vT[32]
    if c32v0 then
      c32v1 = gRegion
      c32v0 = IsNull
      c32v0 = c32v0(c32v1)
      if not c32v0 then
        c32v1 = gGameRules
        c32v0 = IsNull
        c32v0 = c32v0(c32v1)
        if not c32v0 then
          c32v0 = gGameRules
          c32v0:RequestPause()
          c32v0 = false
          vT[32] = c32v0
          c32v0 = vT[33]
          if c32v0 then
            c32v1 = gGameRules
            c32v0 = IsNull
            c32v0 = c32v0(c32v1)
            if not c32v0 then
              c32v0 = gGameRules
              c32v0 = c32v0:Paused()
              if c32v0 then
                c32v0 = _T
                c32v1 = false
                c32v0.Transmissions_Visible = c32v1
              end
            end
          end
        end
      end
    end
    c32v1 = gRegion
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      local p140 = 36
      if p140 == 36 then
        c32v0 = vT[41]
        if c32v0 then
        else
          p140 = 37
        end
      end
      if p140 == 37 then
        c32v0 = vT[1]
        c32v0 = c32v0.IsInGamePlay
        c32v0 = c32v0()
        if not c32v0 then
        else
          p140 = 38
        end
      end
      if p140 == 38 then
        c32v0 = gGameRules
        c32v2 = gLotusPhotoBoothGameRulesType
        c32v0 = c32v0:IsA(c32v2)
        if c32v0 then
        else
          p140 = 39
        end
      end
      if p140 == 39 then
        c32v0 = gMatchingService
        c32v0 = c32v0:IsHost()
        if not c32v0 then
          p140 = 41
        else
          p140 = 40
        end
      end
      if p140 == 40 then
        c32v0 = gGameRules
        c32v2 = gLotusDuelGameRulesType
        c32v0 = c32v0:IsA(c32v2)
        if c32v0 then
        else
          p140 = 41
        end
      end
      if p140 == 41 then
        c32v0 = gGameRules
        c32v0:RequestUnpause()
        c32v0 = vT[33]
        if not c32v0 then
        else
          p140 = 42
        end
      end
      if p140 == 42 then
        c32v1 = gGameRules
        c32v0 = IsNull
        c32v0 = c32v0(c32v1)
        if c32v0 then
        else
          p140 = 43
        end
      end
      if p140 == 43 then
        c32v0 = gGameRules
        c32v0 = c32v0:Paused()
        if c32v0 then
        else
          p140 = 44
        end
      end
      if p140 == 44 then
        c32v0 = _T
        c32v1 = true
        c32v0.Transmissions_Visible = c32v1
      end
    end
    c32v0 = vT[19]
    c32v1 = 0
    if c32v1 < c32v0 then
      c32v1 = _T.BackgroundMovie
      c32v0 = IsNull
      c32v0 = c32v0(c32v1)
      if not c32v0 then
        c32v0 = _T.BackgroundMovie
        c32v2 = "ShowBlockingMessage"
        c32v3 = "0"
        c32v0:Execute(c32v2, c32v3)
      end
      c32v1 = gFlashMgr
      c32v0 = IsNull
      c32v0 = c32v0(c32v1)
      if not c32v0 then
        c32v0 = gFlashMgr
        c32v0:Name__c2ba371a()
      end
    end
    c32v1 = vT[15]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = vT[15]
      c32v2 = "IgnoreParentCloseRequest"
      c32v3 = ""
      c32v0 = c32v0:Execute(c32v2, c32v3)
      if not c32v0 then
        c32v0 = vT[15]
        c32v0:Close()
      end
    end
    c32v1 = vT[17]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = vT[17]
      c32v0:Close()
    end
    c32v1 = vT[18]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = vT[18]
      c32v0:Close()
    end
    c32v1 = vT[12]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = vT[12]
      c32v0:Close()
    end
    c32v0 = Engine.IsMobile
    c32v0 = c32v0()
    if c32v0 then
      c32v1 = vT[69]
      c32v1 = c32v1.marketHighlightMovie
      c32v0 = IsNull
      c32v0 = c32v0(c32v1)
      if not c32v0 then
        c32v0 = vT[69]
        c32v0 = c32v0.marketHighlightMovie
        c32v0:Close()
      end
    end
    c32v0 = Engine.IsMobile
    c32v0 = c32v0()
    if c32v0 then
      c32v1 = vT[28]
      c32v1 = c32v1.pulsingTimer
      c32v0 = IsNull
      c32v0 = c32v0(c32v1)
      if not c32v0 then
        c32v0 = vT[28]
        c32v0 = c32v0.pulsingTimer
        c32v0:ClearTimers()
      end
    end
    c32v0 = _T
    c32v1 = nil
    c32v0.DiegeticPosition = c32v1
    c32v0 = vT[40]
    if not c32v0 then
      c32v0 = vT[41]
      if not c32v0 then
        c32v1 = _T.DisableUIInput
        c32v0 = IsNull
        c32v0 = c32v0(c32v1)
        if not c32v0 then
          c32v0 = _T.DisableUIInput
          c32v0()
        end
      end
    end
    c32v1 = vT[63]
    c32v0 = IsNull
    c32v0 = c32v0(c32v1)
    if not c32v0 then
      c32v0 = gFlashMgr
      c32v2 = vT[63]
      c32v3 = "OnQueueMovieLoaded"
      c32v0:Name__3e528491(c32v2, c32v3)
    end
    c32v0 = gFlashMgr
    c32v2 = boonsActiveMovie
    c32v0 = c32v0:FindMovie(c32v2)
    c32v1 = IsNull
    c32v1 = c32v1(c32v0)
    if not c32v1 then
      c32v0:Close()
    end
    do return end
  end
  Shutdown = vT[78]
  vT[78] = function()
    local c33v0, c33v1, c33v2, c33v3
    c33v0 = vT[51]
    if not c33v0 then
      c33v0 = false
      do return c33v0 end
    end
    c33v1 = vT[24]
    c33v0 = IsNull
    c33v0 = c33v0(c33v1)
    if c33v0 then
      c33v0 = false
      do return c33v0 end
    end
    c33v0 = vT[24]
    c33v0 = c33v0:Name__cb6ef4d3()
    if c33v0 then
      c33v0 = false
      do return c33v0 end
    end
    c33v0 = vT[24]
    c33v2 = Symbol
    c33v3 = "Kneel"
    c33v0 = c33v0:IsPlayingAction(c33v2(c33v3))
    if c33v0 then
      c33v0 = false
      do return c33v0 end
    end
    c33v0 = true
    do return c33v0 end
  end
  vT[79] = function(c34v0)
    local c34v1, c34v2, c34v3, c34v4
    c34v1 = true
    vT[13] = c34v1
    c34v1 = _T
    c34v2 = true
    c34v1.TopMenuCancelled = c34v2
    if not c34v0 then
      c34v2 = vT[24]
      c34v1 = IsNull
      c34v1 = c34v1(c34v2)
      if not c34v1 then
        c34v1 = vT[78]
        c34v1 = c34v1()
        if c34v1 then
          c34v1 = false
          vT[60] = c34v1
          c34v1 = vT[24]
          c34v3 = nil
          c34v4 = false
          c34v1:PlayNonReplicatedAnimation(c34v3, c34v4)
        end
      end
    end
    c34v1 = vT[76]
    c34v1()
    if c34v0 then
      c34v1 = nil
      vT[25] = c34v1
    end
    c34v1 = Engine.IsPlayingWithTouchscreen
    c34v1 = c34v1()
    if c34v1 then
      c34v1 = _T.ChatMaximized
      if c34v1 then
        c34v2 = _T.MinimizeChat
        c34v1 = IsNull
        c34v1 = c34v1(c34v2)
        if not c34v1 then
          c34v1 = _T.MinimizeChat
          c34v1()
        end
      end
    end
    c34v1 = mMovie
    c34v1:Close()
    do return end
  end
  vT[80] = function()
    local c35v0
    vT[26] = c35v0
    c35v0 = vT[79]
    c35v0()
    do return end
  end
  vT[81] = function(c38v0, c38v1, c38v2, c38v3, c38v4, c38v5)
    local c38v6, c38v7, c38v8, c38v9, c38v11, c38v12, c38v13, c38v15
    c38v6 = function(c36v0)
      local c36v1, c36v3, c36v4, c36v5
      c36v1 = vT[36]
      c36v1 = c36v1.x
      c36v3 = Lerp
      c36v4 = c38v0
      c36v4 = c36v4.x
      c36v5 = c38v1
      c36v5 = c36v5.x
      c36v1:Name__3f96e89a(c36v3(c36v4, c36v5, c36v0))
      c36v1 = vT[36]
      c36v1 = c36v1.y
      c36v3 = Lerp
      c36v4 = c38v0
      c36v4 = c36v4.y
      c36v5 = c38v1
      c36v5 = c36v5.y
      c36v1:Name__3f96e89a(c36v3(c36v4, c36v5, c36v0))
      c36v1 = vT[36]
      c36v1 = c36v1.width
      c36v3 = Lerp
      c36v4 = c38v0
      c36v4 = c36v4.width
      c36v5 = c38v1
      c36v5 = c36v5.width
      c36v1:Name__3f96e89a(c36v3(c36v4, c36v5, c36v0))
      c36v1 = vT[36]
      c36v1 = c36v1.height
      c36v3 = Lerp
      c36v4 = c38v0
      c36v4 = c36v4.height
      c36v5 = c38v1
      c36v5 = c36v5.height
      c36v1:Name__3f96e89a(c36v3(c36v4, c36v5, c36v0))
      do return end
    end
    c38v8 = 0
    c38v6(c38v8)
    c38v7 = FlashInterpolate
    c38v8 = mMovie
    c38v9 = "Tile"
    c38v11 = {c38v6}
    c38v13 = 1
    c38v12 = {c38v13}
    c38v15 = function()
      local c37v0
      c37v0 = c38v5
      if c37v0 ~= nil then
        c37v0 = c38v5
        c37v0()
      end
      do return end
    end
    c38v7(c38v8, c38v9, c38v2, c38v11, c38v12, c38v3, c38v4, c38v15)
    do return end
  end
  vT[82] = function()
    local c41v0, c41v1, c41v2, c41v3, c41v4, c41v5, c41v6, c41v7, c41v8, c41v9
    c41v0 = vT[0]
    c41v0 = c41v0.PlaySound
    c41v1 = _G
    c41v1 = c41v1.UISound_Close
    c41v0(c41v1)
    c41v0 = true
    vT[13] = c41v0
    c41v0 = _T
    c41v1 = true
    c41v0.TopMenuCancelled = c41v1
    c41v0 = _T
    c41v1 = nil
    c41v0.InfoPopup_Data = c41v1
    c41v0 = 0
    c41v1 = vT[22]
    c41v3 = function(c39v0)
      local c39v1, c39v2, c39v3, c39v4, c39v5, c39v6, c39v7, c39v8, c39v9, c39v10
      c39v1 = IsNull
      c39v1 = c39v1(c39v0)
      if not c39v1 then
        c39v2 = c39v0.mClipName
        c39v1 = IsNull
        c39v1 = c39v1(c39v2)
        if not c39v1 then
          c39v1 = FlashInterpolate
          c39v2 = mMovie
          c39v3 = c39v0.mClipName
          c39v4 = 2
          c39v6 = 12
          c39v7 = 4
          c39v8 = 0
          c39v5 = {c39v6, c39v7, c39v8}
          c39v7 = 0
          c39v8 = -3000
          c39v10 = vT[22]
          c39v10 = c39v10.mInitialX
          c39v9 = c39v10 + 100
          c39v6 = {c39v7, c39v8, c39v9}
          c39v7 = 0.25
          c39v8 = c41v0
          c39v1(c39v2, c39v3, c39v4, c39v5, c39v6, c39v7, c39v8)
          c39v2 = c41v0
          c39v1 = c39v2 + 0.05
          c41v0 = c39v1
        end
      end
      do return end
    end
    c41v1:RunForAllVisibleElements(c41v3)
    c41v1 = ipairs
    c41v2 = vT[35]
    c41v1, c41v2, c41v3 = c41v1(c41v2)
    for c41v4, c41v5 in c41v1, c41v2, c41v3 do
      c41v6 = IsNull
      c41v6 = c41v6(c41v5)
      if not c41v6 then
        c41v8 = gLensFlareType
        c41v6 = c41v5:GetAttachment(c41v8)
        c41v7 = IsNull
        c41v7 = c41v7(c41v6)
        if not c41v7 then
          c41v9 = 0.35
          c41v6:Name__a245a81b(c41v9)
        end
      end
    end
    c41v1 = vT[27]
    c41v3 = 0.2
    c41v4 = function()
      local c40v0, c40v1
      c40v0 = vT[74]
      c40v1 = 0
      c40v0(c40v1)
      do return end
    end
    c41v1:AddTimer(c41v3, c41v4)
    c41v1 = FlashInterpolate
    c41v2 = mMovie
    c41v3 = "_root"
    c41v4 = 0
    c41v6 = 12
    c41v5 = {c41v6}
    c41v7 = 0
    c41v6 = {c41v7}
    c41v7 = 0.45
    c41v8 = 0.15
    c41v1(c41v2, c41v3, c41v4, c41v5, c41v6, c41v7, c41v8)
    c41v1 = {}
    c41v2 = vT[36]
    c41v2 = c41v2.x
    c41v2 = c41v2:GetVal()
    c41v1.x = c41v2
    c41v2 = vT[36]
    c41v2 = c41v2.y
    c41v2 = c41v2:GetVal()
    c41v1.y = c41v2
    c41v2 = vT[36]
    c41v2 = c41v2.width
    c41v2 = c41v2:GetVal()
    c41v1.width = c41v2
    c41v2 = vT[36]
    c41v2 = c41v2.height
    c41v2 = c41v2:GetVal()
    c41v1.height = c41v2
    c41v2 = vT[81]
    c41v4 = vT[37]
    c41v5 = 2
    c41v6 = 0.25
    c41v7 = 0.15
    c41v8 = vT[79]
    c41v2(c41v1, c41v4, c41v5, c41v6, c41v7, c41v8)
    c41v2 = vT[68]
    for c41v4, c41v5 in c41v1, c41v2, c41v3 do
      c41v2 = pairs
      c41v3 = vT[68]
      c41v3 = c41v3.decos
      c41v2, c41v3, c41v4 = c41v2(c41v3)
      for c41v5, c41v6 in c41v2, c41v3, c41v4 do
        c41v7 = gRegion
        c41v7:DestroyObject(c41v6)
      end
      c41v2 = nil
      vT[68] = c41v2
      c41v2 = _T
      c41v3 = nil
      c41v2.gToolTip = c41v3
    end
    c41v2 = gFlashMgr
    c41v4 = boonsActiveMovie
    c41v2 = c41v2:FindMovie(c41v4)
    c41v3 = IsNull
    c41v3 = c41v3(c41v2)
    if not c41v3 then
      c41v5 = "TransitionOut"
      c41v6 = "true"
      c41v2:Execute(c41v5, c41v6)
    end
    c41v4 = vT[15]
    c41v3 = IsNull
    c41v3 = c41v3(c41v4)
    if not c41v3 then
      c41v3 = vT[15]
      c41v5 = "IgnoreParentCloseRequest"
      c41v6 = ""
      c41v3 = c41v3:Execute(c41v5, c41v6)
      if not c41v3 then
        c41v3 = vT[15]
        c41v5 = "TransitionOut"
        c41v7 = 0.45
        c41v8 = ","
        c41v9 = 0.15
        c41v6 = c41v7 .. c41v8 .. c41v9
        c41v3:Execute(c41v5, c41v6)
      end
    end
    c41v4 = vT[17]
    c41v3 = IsNull
    c41v3 = c41v3(c41v4)
    if not c41v3 then
      c41v3 = vT[17]
      c41v5 = "TransitionOut"
      c41v7 = 0.45
      c41v8 = ","
      c41v9 = 0.15
      c41v6 = c41v7 .. c41v8 .. c41v9
      c41v3:Execute(c41v5, c41v6)
    end
    do return end
  end
  vT[83] = function()
    local c42v0
    c42v0 = vT[82]
    c42v0()
    do return end
  end
  TransitionOut = vT[83]
  vT[83] = function()
    local c43v0, c43v1, c43v2, c43v3
    c43v1 = _T.MenuSelectedIndex
    c43v0 = #c43v1
    c43v1 = 0
    if c43v1 < c43v0 then
      c43v0 = table.remove
      c43v1 = _T.MenuSelectedIndex
      c43v3 = _T.MenuSelectedIndex
      c43v2 = #c43v3
      c43v0(c43v1, c43v2)
      c43v0 = vT[29]
      c43v0()
      do return end
    end
    c43v0 = vT[82]
    c43v0()
    do return end
  end
  vT[84] = function()
    local c44v0
    c44v0 = vT[83]
    c44v0()
    do return end
  end
  GoBack = vT[84]
  vT[84] = function()
    local c45v0, c45v1
    while true do
      c45v1 = _T.MenuSelectedIndex
      c45v0 = #c45v1
      c45v1 = 0
      if c45v0 <= c45v1 then break end
      c45v0 = vT[83]
      c45v0()
    end
    c45v0 = vT[83]
    c45v0()
    do return end
  end
  vT[85] = function()
    local c47v0, c47v1, c47v2, c47v3
    c47v1 = masteryRankUpMovie
    c47v0 = IsNull
    c47v0 = c47v0(c47v1)
    if not c47v0 then
      c47v0 = mMovie
      c47v2 = masteryRankUpMovie
      c47v0 = c47v0:PushChildMovie(c47v2)
      vT[15] = c47v0
      c47v0 = _T
      c47v1 = function(c46v0)
        local c46v1, c46v2, c46v3
        c46v1 = _T
        c46v2 = nil
        c46v1.MasteryRankUpChoice = c46v2
        c46v1 = mMovie
        c46v3 = "LevelUpConfirm"
        c46v1:Execute(c46v3, c46v0)
        do return end
      end
      c47v0.MasteryRankUpChoice = c47v1
      c47v0 = vT[15]
      c47v2 = "SetCallBack"
      c47v3 = "MasteryRankUpChoice"
      c47v0:Execute(c47v2, c47v3)
    end
    do return end
  end
  vT[86] = function(c48v0)
    local c48v1, c48v2, c48v3, c48v4
    c48v1 = tonumber
    c48v1 = c48v1(c48v0)
    c48v2 = 4
    if c48v1 == c48v2 then
      c48v1 = _T.BackgroundMovie
      if c48v1 then
        c48v1 = _T.BackgroundMovie
        c48v3 = "LevelUp"
        c48v4 = ""
        c48v1:Execute(c48v3, c48v4)
      end
    end
    do return end
  end
  vT[87] = function(c49v0)
    local c49v1
    c49v1 = vT[86]
    c49v1(c49v0)
    do return end
  end
  LevelUpConfirm = vT[87]
  vT[87] = function()
    local c50v0
    c50v0 = vT[83]
    c50v0()
    do return end
  end
  vT[88] = function()
    local c51v0, c51v1
    c51v0 = Engine.Disconnect
    c51v1 = false
    c51v0(c51v1)
    c51v0 = vT[83]
    c51v0()
    do return end
  end
  vT[89] = function(c52v0, c52v1)
    local c52v2, c52v3, c52v4, c52v5, c52v6, c52v7, c52v8, c52v10, c52v11, c52v12, c52v13
    local p24 = 0
    if p24 == 0 then
      c52v2 = print
      c52v3 = "DbUpdateComplete, disconnecting"
      c52v2(c52v3)
      c52v2 = gGameRules
      c52v2 = c52v2:Name__21fcd57b()
      if not c52v2 then
        p24 = 3
      else
        p24 = 1
      end
    end
    if p24 == 1 then
      c52v3 = gGameData
      c52v2 = IsNull
      c52v2 = c52v2(c52v3)
      if c52v2 then
        p24 = 3
      else
        p24 = 2
      end
    end
    if p24 == 2 then
      c52v2 = gGameData
      c52v2:Name__9b87fe57()
      p24 = 14
    end
    if p24 == 3 then
      if not ((not c52v0 or not c52v1)) then
        c52v3 = gGameData
        c52v2 = IsNull
        c52v2 = c52v2(c52v3)
        if not c52v2 then
          c52v2 = gRegion
          c52v2 = c52v2:IsMaster()
          if not c52v2 then
            c52v2 = gGameRules
            c52v4 = Symbol
            c52v5 = "RJMissionComplete"
            c52v4 = c52v4(c52v5)
            c52v5 = 0
            c52v2 = c52v2:GetNetPersistentVar(c52v4, c52v5)
            c52v3 = 0
            if c52v3 < c52v2 then
              c52v2 = cjson.decode
              c52v2 = c52v2(c52v1)
              c52v3 = c52v2.MissionRewards
              c52v3 = ipairs
              c52v4 = c52v2.MissionRewards
              c52v3, c52v4, c52v5 = c52v3(c52v4)
              for c52v6, c52v7 in c52v3, c52v4, c52v5 do
                c52v8 = c52v7.credits
                if c52v8 == nil then
                  c52v8 = gGameData
                  c52v10 = Resource
                  c52v11 = c52v7.StoreItem
                  c52v10 = c52v10(c52v11)
                  c52v12 = c52v7.UpgradeLevel
                  c52v11 = c52v12 or 0
                  c52v12 = true
                  c52v13 = c52v7.ItemCount
                  c52v8:Name__d0a40370(c52v10, c52v11, c52v12, c52v13)
                end
              end
              for c52v6, c52v7 in c52v3, c52v4, c52v5 do
              end
              c52v3 = gGameRules
              c52v3:Name__1bb76070()
            end
          end
        end
      end
      p24 = 14
    end
    if p24 == 14 then
      c52v2 = vT[88]
      c52v2()
      do return end
    end
  end
  DbUpdateComplete = vT[89]
  vT[89] = function()
    local c53v0, c53v2
    c53v0 = gFlashMgr
    c53v2 = cmdQuit
    c53v0:ExecuteToolMenuCommand(c53v2)
    do return end
  end
  DbUpdateCompleteQuitGame = vT[89]
  vT[89] = function()
    local c54v0, c54v1, c54v2, c54v3
    c54v0 = print
    c54v1 = "MainMenuConfirm_LeftSquad"
    c54v0(c54v1)
    c54v0 = _T.BackgroundMovie
    c54v2 = "ShowBlockingMessage"
    c54v3 = "0"
    c54v0:Execute(c54v2, c54v3)
    c54v0 = vT[88]
    c54v0()
    do return end
  end
  MainMenuConfirm_LeftSquad = vT[89]
  vT[89] = function()
    local c55v0, c55v1, c55v2, c55v3
    c55v0 = gGameRules
    c55v2 = gLotusGameRulesType
    c55v0 = c55v0:IsA(c55v2)
    if c55v0 then
      c55v0 = true
      c55v1 = gGameRules
      c55v1 = c55v1:GetMission()
      c55v1 = c55v1.location
      c55v2 = Symbol
      c55v3 = "CrewBattleNode557"
      c55v2 = c55v2(c55v3)
      if c55v1 ~= c55v2 then
        c55v1 = gGameRules
        c55v1 = c55v1:GetMission()
        c55v1 = c55v1.location
        c55v2 = Symbol
        c55v3 = "CrewBattleNode558"
        c55v2 = c55v2(c55v3)
        if c55v1 ~= c55v2 then
          c55v0 = false
        else
          c55v0 = true
        end
      end
    end
    do return c55v0 end
  end
  vT[90] = function(c56v0)
    local c56v1, c56v2, c56v3, c56v4, c56v5, c56v6, c56v7
    local p94 = 0
    if p94 == 0 then
      c56v1 = tonumber
      c56v1 = c56v1(c56v0)
      c56v2 = 4
      if c56v1 ~= c56v2 then
        p94 = 56
      else
        p94 = 1
      end
    end
    if p94 == 1 then
      c56v2 = gGameRules
      c56v1 = IsNull
      c56v1 = c56v1(c56v2)
      if c56v1 then
        p94 = 6
      else
        p94 = 2
      end
    end
    if p94 == 2 then
      c56v1 = gGameRules
      c56v3 = gLotusFightingGameRulesType
      c56v1 = c56v1:IsA(c56v3)
      if not c56v1 then
        p94 = 6
      else
        p94 = 3
      end
    end
    if p94 == 3 then
      c56v2 = gGameData
      c56v1 = IsNull
      c56v1 = c56v1(c56v2)
      if c56v1 then
        p94 = 5
      else
        p94 = 4
      end
    end
    if p94 == 4 then
      c56v1 = gGameData
      c56v1:Name__64edf2fc()
      p94 = 5
    end
    if p94 == 5 then
      c56v1 = Engine.Disconnect
      c56v2 = true
      c56v1(c56v2)
      do return end
    end
    if p94 == 6 then
      c56v1 = _T.AbortMissionCallback
      if c56v1 == nil then
        p94 = 8
      else
        p94 = 7
      end
    end
    if p94 == 7 then
      c56v1 = _T.AbortMissionCallback
      c56v1()
      c56v1 = _T
      c56v2 = nil
      c56v1.AbortMissionCallback = c56v2
      p94 = 8
    end
    if p94 == 8 then
      c56v2 = gGameData
      c56v1 = IsNull
      c56v1 = c56v1(c56v2)
      if c56v1 then
        p94 = 12
      else
        p94 = 9
      end
    end
    if p94 == 9 then
      c56v1 = vT[1]
      c56v1 = c56v1.IsInHub
      c56v1 = c56v1()
      if c56v1 then
        p94 = 11
      else
        p94 = 10
      end
    end
    if p94 == 10 then
      c56v1 = gGameRules
      c56v1 = c56v1:IsPvpEnabled()
      if not c56v1 then
        p94 = 12
      else
        p94 = 11
      end
    end
    if p94 == 11 then
      c56v1 = gGameData
      c56v1:Name__5e9effab()
      p94 = 12
    end
    if p94 == 12 then
      c56v1 = gMatchingService
      c56v1 = c56v1:GetSession()
      c56v2 = vT[1]
      c56v2 = c56v2.IsInHub
      c56v2 = c56v2()
      if not c56v2 then
        p94 = 18
      else
        p94 = 13
      end
    end
    if p94 == 13 then
      c56v2 = print
      c56v3 = "Abort: in hub (1)"
      c56v2(c56v3)
      c56v2 = gGameRules
      c56v4 = 2
      c56v5 = 0
      c56v2:EndGame(c56v4, c56v5)
      c56v3 = gGameData
      c56v2 = IsNull
      c56v2 = c56v2(c56v3)
      if c56v2 then
        p94 = 17
      else
        p94 = 14
      end
    end
    if p94 == 14 then
      c56v2 = gGameRules
      c56v2 = c56v2:IsTradeHub()
      if not c56v2 then
        p94 = 16
      else
        p94 = 15
      end
    end
    if p94 == 15 then
      c56v2 = gGameData
      c56v4 = 6
      c56v2:SetHubSpawnLocation(c56v4)
      p94 = 17
    end
    if p94 == 16 then
      c56v2 = gGameData
      c56v4 = 0
      c56v2:SetHubSpawnLocation(c56v4)
      p94 = 17
    end
    if p94 == 17 then
      c56v2 = vT[83]
      c56v2()
      do return end
    end
    if p94 == 18 then
      c56v2 = IsNull
      c56v2 = c56v2(c56v1)
      if c56v2 then
        p94 = 20
      else
        p94 = 19
      end
    end
    if p94 == 19 then
      c56v2 = gGameRules
      c56v2 = c56v2:InDojo()
      if c56v2 then
        p94 = 23
      else
        p94 = 20
      end
    end
    if p94 == 20 then
      c56v2 = GetConfigBool
      c56v3 = "LotusGameRules.DemoMode"
      c56v2 = c56v2(c56v3)
      if c56v2 then
        p94 = 23
      else
        p94 = 21
      end
    end
    if p94 == 21 then
      c56v2 = vT[1]
      c56v2 = c56v2.IsApartmentLevel
      c56v2 = c56v2()
      if c56v2 then
        p94 = 23
      else
        p94 = 22
      end
    end
    if p94 == 22 then
      c56v2 = vT[1]
      c56v2 = c56v2.IsTailorShopLevel
      c56v2 = c56v2()
      if not c56v2 then
        p94 = 26
      else
        p94 = 23
      end
    end
    if p94 == 23 then
      c56v2 = gMatchingService
      c56v2 = c56v2:IsHost()
      if c56v2 then
        p94 = 25
      else
        p94 = 24
      end
    end
    if p94 == 24 then
      c56v2 = print
      c56v3 = "TopMenu - leave squad"
      c56v2(c56v3)
      c56v2 = _T.BackgroundMovie
      c56v4 = "ShowBlockingMessage"
      c56v5 = "1"
      c56v2:Execute(c56v4, c56v5)
      c56v2 = gMatchingService
      c56v4 = "MainMenuConfirm_LeftSquad"
      c56v2:LeaveSquad(c56v4)
      do return end
    end
    if p94 == 25 then
      c56v2 = vT[88]
      c56v2()
      do return end
    end
    if p94 == 26 then
      c56v2 = gGameRules
      c56v4 = gLotusBaseGameRulesType
      c56v2 = c56v2:IsA(c56v4)
      if not c56v2 then
        p94 = 29
      else
        p94 = 27
      end
    end
    if p94 == 27 then
      c56v2 = gGameRules
      c56v2 = c56v2:MissionCompleted()
      if not c56v2 then
        p94 = 29
      else
        p94 = 28
      end
    end
    if p94 == 28 then
      c56v2 = vT[0]
      c56v2 = c56v2.ShowMessage
      c56v3 = "/Lotus/Language/Menu/CouldNotAbortAlreadyCompleted"
      c56v2 = c56v2(c56v3)
      vT[15] = c56v2
      do return end
    end
    if p94 == 29 then
      c56v2 = gGameRules
      c56v4 = gLotusBaseGameRulesType
      c56v2 = c56v2:IsA(c56v4)
      if not c56v2 then
        p94 = 32
      else
        p94 = 30
      end
    end
    if p94 == 30 then
      c56v2 = gGameRules
      c56v2 = c56v2:MissionFailed()
      if not c56v2 then
        p94 = 32
      else
        p94 = 31
      end
    end
    if p94 == 31 then
      c56v2 = vT[0]
      c56v2 = c56v2.ShowMessage
      c56v3 = "/Lotus/Language/Menu/CouldNotAbortAlreadyFailed"
      c56v2 = c56v2(c56v3)
      vT[15] = c56v2
      do return end
    end
    if p94 == 32 then
      c56v2 = gGameRules
      c56v4 = gLotusGameRulesType
      c56v2 = c56v2:IsA(c56v4)
      if not c56v2 then
        p94 = 40
      else
        p94 = 33
      end
    end
    if p94 == 33 then
      c56v2 = false
      c56v3 = gGameRules
      c56v3 = c56v3:GetMission()
      c56v3 = c56v3.missionType
      c56v4 = 32
      if c56v3 ~= c56v4 then
        p94 = 40
      else
        p94 = 34
      end
    end
    if p94 == 34 then
      c56v4 = gGameData
      c56v3 = IsNull
      c56v3 = c56v3(c56v4)
      c56v2 = not c56v3
      if not c56v2 then
        p94 = 40
      else
        p94 = 35
      end
    end
    if p94 == 35 then
      c56v2 = gGameData
      c56v2 = c56v2:HasDojoKey()
      if not c56v2 then
        p94 = 40
      else
        p94 = 36
      end
    end
    if p94 == 36 then
      c56v3 = vT[89]
      c56v3 = c56v3()
      c56v2 = not c56v3
      if not c56v2 then
        p94 = 40
      else
        p94 = 37
      end
    end
    if p94 == 37 then
      c56v3 = _T.RailjackOverride
      if c56v3 == nil then
        p94 = 39
      else
        p94 = 38
      end
    end
    if p94 == 38 then
      c56v2 = false
      p94 = 40
    end
    if p94 == 39 then
      c56v2 = true
      p94 = 40
    end
    if p94 == 40 then
      c56v3 = gRegion
      c56v3 = c56v3:IsMaster()
      if c56v3 then
        p94 = 43
      else
        p94 = 41
      end
    end
    if p94 == 41 then
      c56v3 = gMatchingService
      c56v3 = c56v3:IsHost()
      if (c56v3 ~= true or not c56v2) then
        p94 = 48
      else
        p94 = 43
      end
    end
    if p94 == 43 then
      c56v3 = gGameRules
      c56v3 = c56v3:IsPvpEnabled()
      if c56v3 then
        p94 = 48
      else
        p94 = 44
      end
    end
    if p94 == 44 then
      c56v3 = print
      c56v4 = "Abort: host/no session"
      c56v3(c56v4)
      if not c56v2 then
        p94 = 46
      else
        p94 = 45
      end
    end
    if p94 == 45 then
      c56v3 = print
      c56v4 = "Abort mission: ReturnToDojo'"
      c56v3(c56v4)
      c56v3 = vT[1]
      c56v3 = c56v3.ReturnToDojo
      c56v4 = true
      c56v3(c56v4)
      p94 = 47
    end
    if p94 == 46 then
      c56v3 = gGameRules
      c56v5 = 2
      c56v6 = 0
      c56v3:EndGame(c56v5, c56v6)
      p94 = 47
    end
    if p94 == 47 then
      c56v3 = vT[83]
      c56v3()
      do return end
    end
    if p94 == 48 then
      c56v3 = print
      c56v4 = "Abort: client/session/PVP"
      c56v3(c56v4)
      c56v3 = gGameRules
      c56v3 = c56v3:IsPvpEnabled()
      if not c56v3 then
        p94 = 55
      else
        p94 = 49
      end
    end
    if p94 == 49 then
      c56v3 = false
      c56v4 = gRegion
      c56v4 = c56v4:GetLocalPlayerAvatar()
      c56v5 = IsNull
      c56v5 = c56v5(c56v4)
      if c56v5 then
        p94 = 52
      else
        p94 = 50
      end
    end
    if p94 == 50 then
      c56v5 = IsNull
      c56v5 = c56v5(c56v4:GetPlayer())
      if c56v5 then
        p94 = 52
      else
        p94 = 51
      end
    end
    if p94 == 51 then
      c56v5 = gChallengeMgr
      c56v3 = c56v5:REVERBJSON(c56v4:GetPlayer())
      p94 = 52
    end
    if p94 == 52 then
      if c56v3 then
        p94 = 54
      else
        p94 = 53
      end
    end
    if p94 == 53 then
      c56v5 = vT[88]
      c56v5()
      do return end
    end
    if p94 == 54 then
      c56v5 = gGameRules
      c56v7 = "DbUpdateComplete"
      c56v5:OnPlayerQuitting(c56v7)
      c56v5 = Engine.Disconnect
      c56v6 = false
      c56v5(c56v6)
      c56v5 = vT[83]
      c56v5()
      do return end
    end
    if p94 == 55 then
      c56v3 = gGameRules
      c56v5 = "DbUpdateComplete"
      c56v3:OnPlayerQuitting(c56v5)
      p94 = 56
    end
    if p94 == 56 then
      do return end
    end
  end
  MainMenuConfirm = vT[90]
  vT[90] = function()
    local c57v0, c57v1, c57v2, c57v3, c57v4, c57v5
    c57v0 = _T.RestartMissionKey
    c57v1 = print
    c57v3 = "Restarting quest mission "
    c57v4 = tostring
    c57v4 = c57v4(c57v0)
    c57v2 = c57v3 .. c57v4
    c57v1(c57v2)
    c57v1 = _T.RestartMissionKeyLayerIdx
    if c57v1 then
      c57v1 = vT[3]
      c57v1 = c57v1.GetMissionOpenLevelArgs
      c57v2 = Symbol
      c57v4 = c57v0:GetFullName()
      c57v5 = vT[1]
      c57v5 = c57v5.KEY_TAG
      c57v3 = c57v4 .. c57v5
      c57v2 = c57v2(c57v3)
      c57v3 = c57v0:GetMission()
      c57v1 = c57v1(c57v2, c57v3, c57v0)
      c57v2 = _T.RestartMissionKeyLayerIdx
      c57v1.streamingLayer = c57v2
      c57v2 = Engine.OpenLevel
      c57v2(c57v1)
      do return end
    end
    c57v1 = vT[8]
    c57v1 = c57v1.LoadMissionKey
    c57v1(c57v0)
    do return end
  end
  vT[91] = function(c59v0)
    local c59v1, c59v2, c59v3, c59v4, c59v5, c59v6, c59v7, c59v8
    local p89 = 0
    if p89 == 0 then
      c59v1 = _G
      c59v1 = c59v1.StalkerAssistMode
      if not c59v1 then
        p89 = 14
      else
        p89 = 1
      end
    end
    if p89 == 1 then
      c59v1 = _T.StalkerDbUpdateActive
      if not c59v1 then
        p89 = 3
      else
        p89 = 2
      end
    end
    if p89 == 2 then
      c59v1 = vT[79]
      c59v2 = false
      c59v1(c59v2)
      p89 = 3
    end
    if p89 == 3 then
      c59v1 = print
      c59v2 = "local stalker manually aborting mission"
      c59v1(c59v2)
      c59v1 = _G
      c59v2 = nil
      c59v1.StalkerMode = c59v2
      c59v1 = _G
      c59v2 = nil
      c59v1.StalkerAssistMode = c59v2
      c59v1 = _G
      c59v2 = false
      c59v1.TempStalker = c59v2
      c59v1 = _T
      c59v2 = true
      c59v1.StalkerDbUpdateActive = c59v2
      c59v2 = _T.BackgroundMovie
      c59v1 = IsNull
      c59v1 = c59v1(c59v2)
      if c59v1 then
        p89 = 5
      else
        p89 = 4
      end
    end
    if p89 == 4 then
      c59v1 = _T.BackgroundMovie
      c59v3 = "ShowBlockingMessage"
      c59v4 = "1"
      c59v1:Execute(c59v3, c59v4)
      p89 = 5
    end
    if p89 == 5 then
      c59v1 = Symbol
      c59v2 = "StlkDone"
      c59v1 = c59v1(c59v2)
      c59v3 = gGameRules
      c59v6 = 0
      c59v3 = c59v3:GetNetPersistentVar(c59v1, c59v6)
      if c59v3 == 1 then
        p89 = 7
      else
        p89 = 6
      end
    end
    if p89 == 6 then
      c59v2 = false
      p89 = 8
    end
    if p89 == 7 then
      c59v2 = true
      p89 = 8
    end
    if p89 == 8 then
      c59v4 = gGameRules
      c59v3 = IsNull
      c59v3 = c59v3(c59v4)
      if c59v3 then
        p89 = 11
      else
        p89 = 9
      end
    end
    if p89 == 9 then
      c59v3 = gGameRules
      c59v5 = gLotusGameRulesType
      c59v3 = c59v3:IsA(c59v5)
      if not c59v3 then
        p89 = 11
      else
        p89 = 10
      end
    end
    if p89 == 10 then
      c59v3 = gGameRules
      c59v6 = nil
      c59v7 = function(c58v0)
        local c58v1, c58v2, c58v3, c58v4, c58v5, c58v6, c58v7, c58v8
        c58v1 = print
        c58v3 = "db update finished missionCompleted="
        c58v8 = c59v2
        c58v7 = tostring
        c58v4 = c58v7(c58v8)
        c58v5 = ", success="
        c58v6 = tostring
        c58v6 = c58v6(c58v0)
        c58v2 = c58v3 .. c58v4 .. c58v5 .. c58v6
        c58v1(c58v2)
        c58v1 = gGameRules
        c58v1:Name__1bb76070()
        c58v2 = gGameData
        c58v1 = IsNull
        c58v1 = c58v1(c58v2)
        if not c58v1 then
          c58v1 = gGameData
          c58v3 = false
          c58v1:SetStalkerLoadout(c58v3)
        end
        c58v1 = Engine.Disconnect
        c58v2 = true
        c58v1(c58v2)
        do return end
      end
      c59v3:Name__8910beee(c59v2, c59v6, c59v7)
      do return end
    end
    if p89 == 11 then
      c59v4 = gGameData
      c59v3 = IsNull
      c59v3 = c59v3(c59v4)
      if c59v3 then
        p89 = 13
      else
        p89 = 12
      end
    end
    if p89 == 12 then
      c59v3 = gGameData
      c59v5 = false
      c59v3:SetStalkerLoadout(c59v5)
      p89 = 13
    end
    if p89 == 13 then
      c59v3 = Engine.Disconnect
      c59v4 = true
      c59v3(c59v4)
      do return end
    end
    if p89 == 14 then
      c59v1 = _G
      c59v1 = c59v1.StalkerMode
      if not c59v1 then
        p89 = 21
      else
        p89 = 15
      end
    end
    if p89 == 15 then
      c59v2 = _T.StalkerPlayerAvatar
      c59v1 = IsNull
      c59v1 = c59v1(c59v2)
      if c59v1 then
        p89 = 18
      else
        p89 = 16
      end
    end
    if p89 == 16 then
      c59v1 = vT[23]
      c59v2 = vT[1]
      c59v2 = c59v2.UI_MODE_IN_SPACE_SHIP
      if c59v1 == c59v2 then
        p89 = 18
      else
        p89 = 17
      end
    end
    if p89 == 17 then
      c59v1 = _T.StalkerPlayerAvatar
      c59v4 = _T.StalkerPlayerAvatar
      c59v4 = c59v4:GetHealth()
      c59v3 = c59v4 + 1
      c59v4 = 20
      c59v5 = 0
      c59v6 = 0
      c59v7 = _T.StalkerPlayerAvatar
      c59v8 = _T.StalkerPlayerAvatar
      c59v1:DamageEx(c59v3, c59v4, c59v5, c59v6, c59v7, c59v8)
      c59v1 = vT[79]
      c59v2 = false
      c59v1(c59v2)
      do return end
    end
    if p89 == 18 then
      c59v1 = vT[23]
      c59v2 = vT[1]
      c59v2 = c59v2.UI_MODE_IN_SPACE_SHIP
      if c59v1 ~= c59v2 then
        p89 = 20
      else
        p89 = 19
      end
    end
    if p89 == 19 then
      c59v1 = _G
      c59v2 = false
      c59v1.StalkerMode = c59v2
      c59v1 = _G
      c59v2 = false
      c59v1.TempStalker = c59v2
      c59v1 = gGameData
      c59v3 = false
      c59v1:SetStalkerLoadout(c59v3)
      c59v1 = WeakResource
      c59v2 = "/Lotus/Levels/Proc/PlayerShip"
      c59v1 = c59v1(c59v2)
      c59v2 = gGameConfig
      c59v2:Name__4d0d3bf1(c59v1)
      c59v2 = Engine.OpenLevelArgs
      c59v2 = c59v2()
      c59v3 = gGameData
      c59v6 = ""
      c59v3:SetReturnToLobbyLevelArgs(c59v2, c59v6)
      p89 = 20
    end
    if p89 == 20 then
      c59v1 = Engine.Disconnect
      c59v2 = false
      c59v1(c59v2)
      do return end
    end
    if p89 == 21 then
      c59v1 = gRegion
      c59v1 = c59v1:GetLocalPlayer()
      c59v1 = c59v1:Name__8760e086()
      if not c59v1 then
        p89 = 23
      else
        p89 = 22
      end
    end
    if p89 == 22 then
      c59v1 = vT[79]
      c59v2 = false
      c59v1(c59v2)
      do return end
    end
    if p89 == 23 then
      c59v3 = gGameRules
      c59v2 = IsNull
      c59v2 = c59v2(c59v3)
      c59v1 = not c59v2
      if not c59v1 then
        p89 = 26
      else
        p89 = 24
      end
    end
    if p89 == 24 then
      c59v2 = gGameRules
      c59v4 = gLotusPhotoBoothGameRulesType
      c59v2 = c59v2:IsA(c59v4)
      if not c59v2 then
        p89 = 26
      else
        p89 = 25
      end
    end
    if p89 == 25 then
      c59v0 = "/Lotus/Language/Photobooth/ExitPhotoboothConfirm"
      p89 = 61
    end
    if p89 == 26 then
      if not c59v1 then
        p89 = 31
      else
        p89 = 27
      end
    end
    if p89 == 27 then
      c59v2 = gGameRules
      c59v4 = Name__4710a87d
      c59v2 = c59v2:IsA(c59v4)
      if not c59v2 then
        p89 = 31
      else
        p89 = 28
      end
    end
    if p89 == 28 then
      c59v2 = gGameRules
      c59v4 = duviriEndlessGameRules
      c59v2 = c59v2:IsA(c59v4)
      if not c59v2 then
        p89 = 30
      else
        p89 = 29
      end
    end
    if p89 == 29 then
      c59v0 = "/Lotus/Language/Duviri/AbortMissionConfirmCircuit"
      p89 = 61
    end
    if p89 == 30 then
      c59v0 = "/Lotus/Language/Duviri/AbortMissionConfirm"
      p89 = 61
    end
    if p89 == 31 then
      c59v3 = vT[49]
      c59v2 = IsNull
      c59v2 = c59v2(c59v3)
      if c59v2 then
        p89 = 38
      else
        p89 = 32
      end
    end
    if p89 == 32 then
      c59v2 = vT[49]
      c59v2 = c59v2:Name__0b653596()
      if c59v2 == "" then
        p89 = 38
      else
        p89 = 33
      end
    end
    if p89 == 33 then
      c59v2 = vT[1]
      c59v2 = c59v2.IsInEntratiHub
      c59v2 = c59v2()
      if not c59v2 then
        p89 = 35
      else
        p89 = 34
      end
    end
    if p89 == 34 then
      c59v0 = "/Lotus/Language/Entrati/ExitSanctumAnatomicaConfirm"
      p89 = 61
    end
    if p89 == 35 then
      c59v2 = vT[1]
      c59v2 = c59v2.IsSayasVision
      c59v2 = c59v2()
      if not c59v2 then
        p89 = 37
      else
        p89 = 36
      end
    end
    if p89 == 36 then
      c59v0 = "/Lotus/Language/Menu/AbortMissionConfirm"
      p89 = 61
    end
    if p89 == 37 then
      c59v2 = vT[49]
      c59v0 = c59v2:Name__0b653596()
      p89 = 61
    end
    if p89 == 38 then
      c59v2 = vT[23]
      c59v3 = vT[1]
      c59v3 = c59v3.UI_MODE_IN_DOJO
      if c59v2 ~= c59v3 then
        p89 = 49
      else
        p89 = 39
      end
    end
    if p89 == 39 then
      if not c59v1 then
        p89 = 42
      else
        p89 = 40
      end
    end
    if p89 == 40 then
      c59v2 = string.find
      c59v3 = gGameRules
      c59v3 = c59v3:GetFullName()
      c59v4 = "LotusConclaveGameRules"
      c59v2 = c59v2(c59v3, c59v4)
      if c59v2 == nil then
        p89 = 42
      else
        p89 = 41
      end
    end
    if p89 == 41 then
      c59v0 = "/Lotus/Language/Menu/ExitArenaConfirm"
      p89 = 61
    end
    if p89 == 42 then
      if not c59v1 then
        p89 = 45
      else
        p89 = 43
      end
    end
    if p89 == 43 then
      c59v2 = gGameRules
      c59v4 = gLotusObstacleCourseGameRulesType
      c59v2 = c59v2:IsA(c59v4)
      if not c59v2 then
        p89 = 45
      else
        p89 = 44
      end
    end
    if p89 == 44 then
      c59v0 = "/Lotus/Language/Menu/ExitDojoObstacleCourseConfirm"
      p89 = 61
    end
    if p89 == 45 then
      if not c59v1 then
        p89 = 48
      else
        p89 = 46
      end
    end
    if p89 == 46 then
      c59v2 = gGameRules
      c59v4 = gLotusDuelGameRulesType
      c59v2 = c59v2:IsA(c59v4)
      if not c59v2 then
        p89 = 48
      else
        p89 = 47
      end
    end
    if p89 == 47 then
      c59v0 = "/Lotus/Language/Menu/ExitDojoDuelConfirm"
      p89 = 61
    end
    if p89 == 48 then
      c59v0 = "/Lotus/Language/Menu/ExitDojoConfirm"
      p89 = 61
    end
    if p89 == 49 then
      c59v2 = vT[23]
      c59v3 = vT[1]
      c59v3 = c59v3.UI_MODE_IN_SPACE_HUB
      if c59v2 ~= c59v3 then
        p89 = 51
      else
        p89 = 50
      end
    end
    if p89 == 50 then
      c59v0 = "/Lotus/Language/Menu/ExitHubConfirm"
      p89 = 61
    end
    if p89 == 51 then
      if not c59v1 then
        p89 = 54
      else
        p89 = 52
      end
    end
    if p89 == 52 then
      c59v2 = gGameRules
      c59v2 = c59v2:GetMission()
      c59v2 = c59v2.missionType
      c59v3 = 23
      if c59v2 ~= c59v3 then
        p89 = 54
      else
        p89 = 53
      end
    end
    if p89 == 53 then
      c59v0 = "/Lotus/Language/Menu/ExitJunctionConfirm"
      c59v2 = gGameData
      c59v2:Name__64edf2fc()
      p89 = 61
    end
    if p89 == 54 then
      c59v2 = _T.InSimulacrum
      if not c59v2 then
        p89 = 56
      else
        p89 = 55
      end
    end
    if p89 == 55 then
      c59v0 = "/Lotus/Language/Menu/ExitSimulacrumConfirm"
      p89 = 61
    end
    if p89 == 56 then
      if not c59v1 then
        p89 = 59
      else
        p89 = 57
      end
    end
    if p89 == 57 then
      c59v2 = gGameRules
      c59v2 = c59v2:Name__219789ed()
      if not c59v2 then
        p89 = 59
      else
        p89 = 58
      end
    end
    if p89 == 58 then
      c59v0 = "/Lotus/Language/Menu/AbortMissionConfirmKey"
      p89 = 61
    end
    if p89 == 59 then
      if c59v0 then
        p89 = 61
      else
        p89 = 60
      end
    end
    if p89 == 60 then
      c59v0 = "/Lotus/Language/Menu/AbortMissionConfirm"
      p89 = 61
    end
    if p89 == 61 then
      c59v2 = vT[0]
      c59v2 = c59v2.ShowYesOrNoMessage
      c59v4 = "MainMenuConfirm"
      c59v2 = c59v2(c59v0, c59v4)
      vT[15] = c59v2
      do return end
    end
  end
  vT[92] = function()
    local c61v0, c61v1
    c61v0 = _T
    c61v1 = function()
      local c60v0, c60v1, c60v2, c60v3, c60v4, c60v5, c60v6, c60v7, c60v9, c60v10, c60v11, c60v12
      c60v0 = _T.IsSquadPairInitializationDone
      if c60v0 then
        c60v0 = _T
        c60v1 = true
        c60v0.AbortingMissionSkipSquadPairReconnection = c60v1
      end
      c60v0 = nil
      c60v2 = gGameRules
      c60v1 = IsNull
      c60v1 = c60v1(c60v2)
      if not c60v0 then
        c60v1 = gGameRules
        c60v3 = Name__4710a87d
        c60v1 = c60v1:IsA(c60v3)
        if c60v1 then
          c60v1 = vT[6]
          c60v1 = c60v1.ReturnToApartment
          c60v2 = false
          c60v1(c60v2)
          do return end
        end
        c60v1 = gGameRules
        c60v3 = gLotusBaseGameRulesType
        c60v1 = c60v1:IsA(c60v3)
        if not c60v1 then
          c60v1 = gGameRules
          c60v1 = c60v1:GetMission()
          c60v0 = c60v1.hubLevelTag
        else
          local p38 = 7
          if p38 == 7 then
            c60v1 = gGameRules
            c60v3 = gLotusAttractModeGameRulesType
            c60v1 = c60v1:IsA(c60v3)
            if not c60v1 then
              p38 = 10
            else
              p38 = 8
            end
          end
          if p38 == 8 then
            c60v1 = gGameRules
            c60v1 = c60v1:Name__736fe82d()
            c60v2 = 2
            if c60v1 ~= c60v2 then
              p38 = 10
            else
              p38 = 9
            end
          end
          if p38 == 9 then
            c60v1 = Symbol
            c60v2 = "ZarimanHub"
            c60v0 = c60v1(c60v2)
          end
          if p38 == 10 then
            c60v1 = gGameRules
            c60v3 = gLotusAttractModeGameRulesType
            c60v1 = c60v1:IsA(c60v3)
            if not c60v1 then
            else
              p38 = 11
            end
          end
          if p38 == 11 then
            c60v1 = gGameRules
            c60v1 = c60v1:Name__736fe82d()
            c60v2 = 3
            if c60v1 ~= c60v2 then
            else
              p38 = 12
            end
          end
          if p38 == 12 then
            c60v1 = Symbol
            c60v2 = "1999Hub"
            c60v0 = c60v1(c60v2)
          end
        end
      end
      c60v1 = c60v0:IsValid()
      if c60v1 then
        c60v1 = vT[1]
        c60v1 = c60v1.GetStarChart
        c60v1 = c60v1()
        c60v2 = c60v1:BuildMissionForLocation(c60v0)
        c60v2 = c60v2:Copy()
        c60v3 = IsNull
        c60v3 = c60v3(c60v2)
        if not c60v3 then
          c60v3 = vT[9]
          c60v3 = c60v3.IsSeasonalSector
          c60v3 = c60v3(c60v0:c_str())
          if c60v3 then
            c60v3 = vT[9]
            c60v3 = c60v3.ApplyMissionOverrides
            c60v4 = c60v0:c_str()
            c60v3(c60v4, c60v2)
          end
          c60v3 = vT[1]
          c60v3 = c60v3.ApplyPostNewWarMissionOverrides
          c60v3(c60v2)
          c60v3 = Engine.OpenLevelArgs
          c60v3 = c60v3()
          c60v4 = c60v2.levelOverride
          c60v3.level = c60v4
          c60v4 = true
          c60v3.isAutonomous = c60v4
          c60v4 = c60v2.gameRules
          c60v3.gameRules = c60v4
          c60v4 = Symbol
          c60v5 = "EntratiLabHub"
          c60v4 = c60v4(c60v5)
          if c60v0 == c60v4 then
            c60v4 = Symbol
            c60v5 = "DeimosHub"
            c60v4 = c60v4(c60v5)
            c60v2.location = c60v4
          end
          c60v4 = c60v2:EncodeAsString()
          c60v5 = {}
          c60v3.contextTags = c60v5
          c60v3:AddContextTag(c60v4)
          c60v5 = {}
          c60v3.levelTags = c60v5
          c60v3:AddLevelTag(c60v2:GetMissionTypeTag())
          c60v7 = c60v2.location
          c60v5 = c60v1:DisableCheckZone(c60v7)
          c60v6 = IsNull
          c60v6 = c60v6(c60v5)
          if not c60v6 then
            c60v3:AddLevelTag(c60v5:GetLevelTag())
          end
          c60v6 = vT[1]
          c60v6 = c60v6.SetLevelStreamingArgs
          c60v6(c60v0, c60v3)
          c60v6 = gGameData
          c60v12 = tostring
          c60v10 = c60v12(c60v0)
          c60v11 = vT[1]
          c60v11 = c60v11.HUB_TAG
          c60v9 = c60v10 .. c60v11
          c60v6:SetReturnToLobbyLevelArgs(c60v3, c60v9)
          do return end
        end
      end
      c60v1 = gGameData
      c60v1:TrackDDMBad()
      do return end
    end
    c61v0.AbortMissionCallback = c61v1
    c61v0 = vT[91]
    c61v0()
    do return end
  end
  vT[93] = function()
    local c63v0, c63v1
    c63v0 = _T
    c63v1 = function()
      local c62v0, c62v1, c62v2
      c62v0 = _T.IsSquadPairInitializationDone
      if c62v0 then
        c62v0 = _T
        c62v1 = true
        c62v0.AbortingMissionSkipSquadPairReconnection = c62v1
      end
      c62v0 = gGameData
      c62v0:TrackDDMBad()
      c62v0 = gGameData
      c62v2 = 0
      c62v0:SetHubSpawnLocation(c62v2)
      do return end
    end
    c63v0.AbortMissionCallback = c63v1
    c63v0 = vT[91]
    c63v0()
    do return end
  end
  vT[94] = function()
    local c64v0, c64v2
    c64v0 = gGameData
    c64v2 = 0
    c64v0:SetHubSpawnLocation(c64v2)
    c64v0 = vT[93]
    c64v0()
    do return end
  end
  vT[95] = function()
    local c65v0, c65v1, c65v2
    c65v0 = _T
    c65v1 = nil
    c65v0.AbortMissionCallback = c65v1
    c65v0 = gGameData
    c65v2 = 5
    c65v0:SetHubSpawnLocation(c65v2)
    c65v0 = vT[91]
    c65v0()
    do return end
  end
  vT[96] = function(c66v0, c66v1, c66v2)
    local c66v3, c66v4, c66v5, c66v6, c66v7, c66v8, c66v9, c66v10, c66v11
    if c66v0 == nil then
      c66v3 = vT[0]
      c66v3 = c66v3.ShowMessage
      c66v4 = "/Lotus/Language/Dojo/ReduceGuildTier_UnknownError"
      c66v3(c66v4)
      do return end
    end
    if c66v0 == -1 then
      c66v3 = vT[0]
      c66v3 = c66v3.ShowMessage
      c66v4 = "/Lotus/Language/Dojo/Generic_INVALID_PERMISSION"
      c66v3(c66v4)
      do return end
    end
    if c66v0 == -2 then
      c66v3 = vT[0]
      c66v3 = c66v3.ShowMessage
      c66v4 = "/Lotus/Language/Dojo/ReduceGuildTier_GUILD_TOO_LARGE"
      c66v3(c66v4)
      do return end
    end
    if c66v0 == -3 then
      c66v3 = Localize
      c66v4 = "/Lotus/Language/Dojo/ReduceGuildTier_INSUFFICIENT_BARRACKS"
      c66v5 = { NEW_TIER_NAME = nil }
      c66v6 = Localize
      c66v8 = "/Lotus/Language/Clan/Tier"
      c66v11 = gGameData
      c66v11 = c66v11:GetGuildTier()
      c66v9 = c66v11 - 1
      c66v10 = "Name"
      c66v7 = c66v8 .. c66v9 .. c66v10
      c66v8 = {}
      c66v6 = c66v6(c66v7, c66v8)
      c66v5.NEW_TIER_NAME = c66v6
      c66v3 = c66v3(c66v4, c66v5)
      c66v4 = vT[0]
      c66v4 = c66v4.ShowMessage
      c66v4(c66v3)
      do return end
    end
    if c66v0 == -4 then
      c66v3 = Localize
      c66v4 = "/Lotus/Language/Dojo/ReduceGuildTier_TOO_MANY_BARRACKS"
      c66v5 = { NEW_TIER_NAME = nil }
      c66v6 = Localize
      c66v8 = "/Lotus/Language/Clan/Tier"
      c66v11 = gGameData
      c66v11 = c66v11:GetGuildTier()
      c66v9 = c66v11 - 1
      c66v10 = "Name"
      c66v7 = c66v8 .. c66v9 .. c66v10
      c66v8 = {}
      c66v6 = c66v6(c66v7, c66v8)
      c66v5.NEW_TIER_NAME = c66v6
      c66v3 = c66v3(c66v4, c66v5)
      c66v4 = vT[0]
      c66v4 = c66v4.ShowMessage
      c66v4(c66v3)
      do return end
    end
    if c66v0 == -5 then
      c66v3 = vT[0]
      c66v3 = c66v3.ShowMessage
      c66v4 = "/Lotus/Language/Dojo/ReduceGuildTier_ROOM_IN_PROGRES"
      c66v3(c66v4)
      do return end
    end
    if c66v0 == -6 then
      c66v3 = "/Lotus/Language/Isleweaver/DuviriMurmurEventTitle"
      if c66v1 then
        c66v4 = c66v1.mDesc
        if c66v4 then
          c66v3 = c66v1.mDesc
        end
      end
      c66v4 = Localize
      c66v6 = nil
      c66v4 = c66v4(c66v3, c66v6)
      c66v5 = Localize
      c66v6 = "/Lotus/Language/Dojo/ReduceGuildTier_EVENT_IN_PROGRESS"
      c66v7 = { EVENT_NAME = nil }
      c66v7.EVENT_NAME = c66v4
      c66v5 = c66v5(c66v6, c66v7)
      c66v6 = vT[0]
      c66v6 = c66v6.ShowMessage
      c66v6(c66v5)
      do return end
    end
    c66v3 = vT[0]
    c66v3 = c66v3.ShowMessage
    c66v4 = "/Lotus/Language/Dojo/ReduceGuildTier_Success"
    c66v3(c66v4)
    c66v4 = gGameRules
    c66v3 = IsNull
    c66v3 = c66v3(c66v4)
    if not c66v3 then
      c66v3 = gGameRules
      c66v5 = gLotusDojoGameRulesType
      c66v3 = c66v3:IsA(c66v5)
      if c66v3 then
        c66v3 = {}
        c66v4 = ""
        c66v5 = cjson.decode
        c66v5 = c66v5(c66v2)
        c66v6 = c66v5.DirtyComponentsIds
        if c66v6 ~= nil then
          c66v3 = c66v5.DirtyComponentsIds
          c66v6 = _T.DojoMgr
          c66v9 = true
          c66v6:RefreshComponents(c66v2, c66v9)
          c66v6 = c66v5.ContentURL
          if c66v6 ~= nil then
            c66v4 = c66v5.ContentURL
          end
        end
        c66v6 = gGameRules
        c66v6:OnGuildTierReduced(c66v3, c66v4)
      end
    end
    do return end
  end
  vT[97] = function(c67v0, c67v1)
    local c67v2, c67v3, c67v4
    if c67v0 then
      c67v2 = vT[96]
      c67v3 = 0
      c67v4 = nil
      c67v2(c67v3, c67v4, c67v1)
      do return end
    end
    c67v2 = vT[96]
    c67v3 = tonumber
    c67v3 = c67v3(c67v1)
    c67v2(c67v3)
    do return end
  end
  OnGuildTierReduced = vT[97]
  vT[97] = function()
    local c68v0, c68v1, c68v2, c68v3, c68v4, c68v5, c68v6, c68v7
    c68v1 = #c68v0
    c68v2 = 0
    c68v3 = 1
    c68v1 = #c68v0
    c68v2 = 1
    for c68v3 = c68v3, c68v1, c68v2 do
      c68v4 = gGameData
      c68v6 = c68v3 - 1
      c68v4 = c68v4:IsGoalVisible(c68v6)
      if c68v4 then
        c68v4 = c68v0[c68v3]
        c68v4 = c68v4.mScoreTagBlocksGuildTierChanges
        if c68v4 then
          c68v5 = c68v0[c68v3]
          c68v5 = c68v5.mClanGoal
          c68v4 = #c68v5
          c68v5 = 0
          if c68v5 < c68v4 then break end
          if c68v5 < c68v4 then
            c68v4 = vT[96]
            c68v5 = -6
            c68v6 = c68v0[c68v3]
            c68v4(c68v5, c68v6)
            do return end
          end
        end
      end
    end
    c68v0 = vT[1]
    c68v0 = c68v0.IsWarlordRank
    c68v1 = gGameData
    c68v0 = c68v0(c68v1:GetGuildRank())
    if not c68v0 then
      c68v0 = vT[96]
      c68v1 = -1
      c68v0(c68v1)
      do return end
    end
    c68v0 = gGameData
    c68v0 = c68v0:GetWorldState()
    c68v0 = c68v0.mGoals
    c68v2 = gGameData
    c68v2 = c68v2:GetGuildTier()
    c68v1 = c68v2 - 1
    c68v2 = gGameConfig
    c68v2 = c68v2:Name__55bcce29(c68v1)
    c68v3 = gGameData
    c68v3 = c68v3:Name__cf4d2230()
    if c68v2 < c68v3 then
      c68v4 = vT[96]
      c68v5 = -2
      c68v4(c68v5)
      do return end
    end
    c68v4 = _T.DojoMgr
    c68v4 = c68v4:HasRoomsCollectingMaterials()
    if c68v4 then
      c68v4 = vT[96]
      c68v5 = -5
      c68v4(c68v5)
      do return end
    end
    c68v4 = _T.DojoMgr
    c68v4 = c68v4:GetMaxBarracksTier()
    c68v5 = 1
    if not ((c68v1 <= c68v5 or c68v1 <= c68v4)) then
      c68v5 = vT[96]
      c68v6 = -3
      c68v5(c68v6)
      do return end
    end
    if c68v1 < c68v4 then
      c68v5 = vT[96]
      c68v6 = -4
      c68v5(c68v6)
      do return end
    end
    c68v5 = vT[0]
    c68v5 = c68v5.ShowYesOrNoMessage
    c68v6 = "/Lotus/Language/Dojo/ReduceGuildTier_Confirm"
    c68v7 = "ReduceGuildTierConfirm"
    c68v5(c68v6, c68v7)
    do return end
  end
  vT[98] = function(c69v0)
    local c69v1, c69v2, c69v5
    c69v1 = tonumber
    c69v1 = c69v1(c69v0)
    c69v2 = 4
    if c69v1 == c69v2 then
      c69v2 = gGameData
      c69v2 = c69v2:GetGuildTier()
      c69v1 = c69v2 - 1
      c69v2 = gGameData
      c69v5 = "OnGuildTierReduced"
      c69v2:ReduceGuildTier(c69v1, c69v5)
    end
    do return end
  end
  ReduceGuildTierConfirm = vT[98]
  vT[98] = function(c70v0, c70v1)
    local c70v2, c70v3
    if c70v0 then
      c70v2 = _T
      c70v3 = false
      c70v2.VaultDeco = c70v3
      c70v2 = _T
      c70v3 = false
      c70v2.ShowShipDecos = c70v3
      c70v2 = gRegion
      c70v2 = c70v2:GetLocalPlayerAvatar()
      c70v3 = IsNull
      c70v3 = c70v3(c70v2)
      if not c70v3 then
        c70v3 = true
        vT[61] = c70v3
        c70v3 = true
        vT[62] = c70v3
      end
      c70v3 = vT[84]
      c70v3()
    end
    do return end
  end
  OnPaintBotLoaded = vT[98]
  vT[98] = function()
    local c71v0, c71v1, c71v2, c71v3, c71v4, c71v5, c71v6, c71v7, c71v8, c71v10
    c71v1 = vT[24]
    c71v0 = IsNull
    c71v0 = c71v0(c71v1)
    c71v1 = vT[24]
    c71v0 = IsNull
    c71v0 = c71v0(c71v1:GetZone())
    c71v0 = vT[24]
    c71v0 = c71v0:GetZone()
    c71v0 = c71v0:GetAttribs()
    c71v1 = _T.DojoMgr
    c71v1 = c71v1:BuildComponentParams(c71v0)
    c71v2 = _T.DojoMgr.mDojo
    c71v4 = c71v1.id
    c71v2 = c71v2:GetComponent(c71v4)
    c71v3 = c71v2.placedDecos
    c71v6 = 1
    c71v4 = #c71v3
    c71v5 = 1
    for c71v6 = c71v6, c71v4, c71v5 do
      c71v7 = c71v3[c71v6]
      c71v7 = c71v7.decoType
      c71v8 = IsNull
      c71v8 = c71v8(c71v7)
      if not c71v8 then
        c71v10 = paintBotDecoType
        c71v8 = c71v7:IsA(c71v10)
        if c71v8 then break end
        if c71v8 then
          c71v8 = c71v3[c71v6]
          do return c71v8 end
        end
      end
    end
    if c71v0 then
      do return end
    end
    c71v4 = nil
    do return c71v4 end
  end
  vT[99] = function()
    local c72v0, c72v1, c72v2, c72v3, c72v4
    c72v1 = vT[24]
    c72v0 = IsNull
    c72v0 = c72v0(c72v1)
    if not c72v0 then
      c72v1 = vT[24]
      c72v0 = IsNull
      c72v0 = c72v0(c72v1:GetZone())
      if not c72v0 then
        c72v1 = _T.DojoMgr
        c72v0 = IsNull
        c72v0 = c72v0(c72v1)
        if not c72v0 then
          c72v0 = vT[24]
          c72v0 = c72v0:GetZone()
          c72v0 = c72v0:GetAttribs()
          c72v1 = _T.DojoMgr
          c72v1 = c72v1:BuildComponentParams(c72v0)
          c72v2 = _T.DojoMgr.mDojo
          c72v4 = c72v1.id
          c72v2 = c72v2:GetComponent(c72v4)
          c72v3 = _T.DojoMgr
          c72v3 = c72v3:IsDuviriIsle(c72v2)
          if c72v3 then
            c72v3 = false
            do return c72v3 end
          end
          c72v4 = vT[98]
          c72v4 = c72v4()
          if c72v4 ~= nil then
            c72v3 = false
          else
            c72v3 = true
          end
          do return c72v3 end
        end
      end
    end
    do return end
  end
  vT[100] = function()
    local c73v0, c73v1
    c73v0 = vT[98]
    c73v0 = c73v0()
    if c73v0 ~= nil then
      c73v1 = c73v0:IsCollectingMaterials()
      do return c73v1 end
    end
    c73v1 = false
    do return c73v1 end
  end
  vT[101] = function()
    local c74v0, c74v1, c74v2, c74v3, c74v4, c74v5, c74v6
    c74v0 = vT[24]
    c74v0 = c74v0:GetZone()
    c74v0 = c74v0:GetAttribs()
    c74v1 = _T.DojoMgr
    c74v1 = c74v1:BuildComponentParams(c74v0)
    c74v2 = vT[1]
    c74v2 = c74v2.HasDojoArchitectPermission
    c74v3 = true
    c74v4 = c74v1.id
    c74v2 = c74v2(c74v3, c74v4)
    if not c74v2 then
      c74v3 = vT[0]
      c74v3 = c74v3.ShowMessage
      c74v4 = "/Lotus/Language/Dojo/PaintBotNoPermission"
      c74v3(c74v4)
      do return end
    end
    c74v3 = _T.DojoMgr.mGameRules
    c74v5 = paintBotDecoType
    c74v5 = c74v5:GetFullName()
    c74v6 = "OnPaintBotLoaded"
    c74v3:RequestResource(c74v5, c74v6)
    do return end
  end
  vT[102] = function(c75v0)
    local c75v1, c75v2
    c75v1 = 0
    if c75v0 == c75v1 then
      c75v1 = vT[0]
      c75v1 = c75v1.ShowMessage
      c75v2 = "/Lotus/Language/Menu/RemovePaintBotSuccess"
      c75v1(c75v2)
      do return end
    end
    c75v1 = vT[0]
    c75v1 = c75v1.ShowMessage
    c75v2 = "/Lotus/Language/Menu/RemovePaintBotFailure"
    c75v1(c75v2)
    do return end
  end
  vT[103] = function(c76v0)
    local c76v1, c76v2, c76v3, c76v4, c76v5, c76v6, c76v7, c76v8, c76v9
    local p6 = 0
    if p6 == 0 then
      c76v1 = tonumber
      c76v1 = c76v1(c76v0)
      c76v2 = 4
      if c76v1 ~= c76v2 then
        p6 = 5
      else
        p6 = 1
      end
    end
    if p6 == 1 then
      c76v1 = vT[24]
      c76v1 = c76v1:GetZone()
      c76v1 = c76v1:GetAttribs()
      c76v2 = _T.DojoMgr
      c76v2 = c76v2:BuildComponentParams(c76v1)
      c76v3 = vT[98]
      c76v3 = c76v3()
      c76v4 = IsNull
      c76v4 = c76v4(c76v3)
      if c76v4 then
        p6 = 4
      else
        p6 = 2
      end
    end
    if p6 == 2 then
      c76v4 = IsNull
      c76v4 = c76v4(c76v2)
      if c76v4 then
        p6 = 4
      else
        p6 = 3
      end
    end
    if p6 == 3 then
      c76v4 = _T.DojoMgr
      c76v6 = c76v3.decoType
      c76v7 = c76v3:GetID()
      c76v8 = c76v2.id
      c76v9 = vT[102]
      c76v4:AbortDecorationByID(c76v6, c76v7, c76v8, c76v9)
      p6 = 5
    end
    if p6 == 4 then
      c76v4 = print
      c76v5 = "unable to abort deco, paintbot or parms are nil"
      c76v4(c76v5)
      c76v4 = vT[0]
      c76v4 = c76v4.ShowMessage
      c76v5 = "/Lotus/Language/Menu/RemovePaintBotFailure"
      c76v4(c76v5)
      p6 = 5
    end
    if p6 == 5 then
      c76v1 = vT[84]
      c76v1()
      do return end
    end
  end
  RemovePaintBotConfirm = vT[103]
  vT[103] = function()
    local c77v0, c77v1, c77v2, c77v3, c77v4, c77v5
    c77v0 = vT[24]
    c77v0 = c77v0:GetZone()
    c77v0 = c77v0:GetAttribs()
    c77v1 = _T.DojoMgr
    c77v1 = c77v1:BuildComponentParams(c77v0)
    c77v2 = vT[1]
    c77v2 = c77v2.HasDojoArchitectPermission
    c77v3 = true
    c77v4 = c77v1.id
    c77v2 = c77v2(c77v3, c77v4)
    if not c77v2 then
      c77v3 = vT[0]
      c77v3 = c77v3.ShowMessage
      c77v4 = "/Lotus/Language/Dojo/PaintBotNoPermission"
      c77v3(c77v4)
      do return end
    end
    c77v3 = vT[0]
    c77v3 = c77v3.ShowConfirmMessage
    c77v4 = "/Lotus/Language/Menu/RemovePaintBotConfirm"
    c77v5 = "RemovePaintBotConfirm"
    c77v3(c77v4, c77v5)
    do return end
  end
  vT[104] = function(c78v0)
    local c78v1, c78v2
    c78v1 = _T
    c78v1.ShowShipDecos = c78v0
    c78v1 = gRegion
    c78v1 = c78v1:GetLocalPlayerAvatar()
    c78v2 = IsNull
    c78v2 = c78v2(c78v1)
    if not c78v2 then
      c78v2 = true
      vT[61] = c78v2
    end
    c78v2 = vT[84]
    c78v2()
    do return end
  end
  vT[105] = function()
    local c79v0, c79v1
    c79v0 = vT[104]
    c79v1 = true
    c79v0(c79v1)
    do return end
  end
  vT[106] = function()
    local c80v0, c80v1
    c80v0 = vT[104]
    c80v1 = false
    c80v0(c80v1)
    do return end
  end
  vT[107] = function()
    local c81v0, c81v1
    c81v0 = _T
    c81v1 = nil
    c81v0.gPreviewMode = c81v1
    c81v0 = vT[84]
    c81v0()
    do return end
  end
  vT[108] = function()
    local c82v0, c82v1, c82v2, c82v3
    c82v1 = vT[15]
    c82v0 = IsNull
    c82v0 = c82v0(c82v1)
    if not c82v0 then
      c82v0 = vT[15]
      c82v2 = "OpenedFromPauseMenu"
      c82v3 = ""
      c82v0:Execute(c82v2, c82v3)
    end
    do return end
  end
  vT[109] = function(c83v0)
    local c83v1, c83v2, c83v4, c83v5
    c83v2 = shipCustomizationMovie
    c83v1 = IsNull
    c83v1 = c83v1(c83v2)
    if not c83v1 then
      c83v1 = nil
      if c83v0 then
        c83v2 = mMovie
        c83v4 = shipCustomizationMovie
        c83v1 = c83v2:PushChildMovie(c83v4)
      else
        c83v2 = gFlashMgr
        c83v4 = shipCustomizationMovie
        c83v1 = c83v2:GotoMovie(c83v4)
      end
      c83v2 = IsNull
      c83v2 = c83v2(c83v1)
      if not c83v2 then
        c83v4 = "SetIsCustomizingExterior"
        c83v5 = tostring
        c83v5 = c83v5(c83v0)
        c83v1:Execute(c83v4, c83v5)
      end
      if not c83v0 then
        c83v2 = vT[75]
        c83v2()
        c83v2 = vT[84]
        c83v2()
        do return end
      end
      vT[15] = c83v1
      c83v2 = vT[108]
      c83v2()
    end
    do return end
  end
  vT[110] = function()
    local c84v0, c84v1
    c84v0 = vT[109]
    c84v1 = true
    c84v0(c84v1)
    do return end
  end
  vT[111] = function()
    local c85v0, c85v1
    c85v0 = vT[109]
    c85v1 = false
    c85v0(c85v1)
    do return end
  end
  vT[112] = function()
    local c86v0, c86v1, c86v2, c86v3
    c86v1 = _T.BackgroundMovie
    c86v0 = IsNull
    c86v0 = c86v0(c86v1)
    if not c86v0 then
      c86v0 = _T.BackgroundMovie
      c86v2 = "QuitGame"
      c86v3 = ""
      c86v0:Execute(c86v2, c86v3)
    end
    c86v0 = true
    do return c86v0 end
  end
  vT[113] = function(c87v0)
    local c87v1, c87v2, c87v3, c87v4
    c87v1 = tonumber
    c87v1 = c87v1(c87v0)
    c87v2 = 4
    if c87v1 == c87v2 then
      c87v1 = gRegion
      c87v1:Name__7b5a2933()
      c87v1 = Engine.Name__3d4ef9f7
      c87v1 = c87v1()
      if c87v1 then
        c87v2 = gGameData
        c87v1 = IsNull
        c87v1 = c87v1(c87v2)
        if not c87v1 then
          c87v1 = gGameData
          c87v1:UploadChallengeProgress()
        end
      end
      c87v1 = vT[79]
      c87v2 = true
      c87v1(c87v2)
    end
    c87v1 = _T.BackgroundMovie
    c87v3 = "ConfirmLogoff"
    c87v4 = {c87v0}
    c87v1:Name__8b1f0505(c87v3, c87v4)
    c87v1 = true
    do return c87v1 end
  end
  LogOutConfirm = vT[113]
  vT[113] = function(c88v0, c88v1)
    local c88v2, c88v3, c88v4, c88v5, c88v6, c88v8
    local p17 = 0
    if p17 == 0 then
      if c88v1 == nil then
        p17 = 4
      else
        p17 = 1
      end
    end
    if p17 == 1 then
      c88v4 = gGameData
      c88v3 = IsNull
      c88v3 = c88v3(c88v4)
      if c88v3 then
        p17 = 4
      else
        p17 = 2
      end
    end
    if p17 == 2 then
      c88v4 = gameExitSurveyMovie
      c88v3 = IsNull
      c88v3 = c88v3(c88v4)
      if c88v3 then
        p17 = 4
      else
        p17 = 3
      end
    end
    if p17 == 3 then
      c88v3 = gGameData
      c88v2 = c88v3:GetSurveys()
      p17 = 4
    end
    if p17 == 4 then
      c88v4 = gGameData
      c88v3 = IsNull
      c88v3 = c88v3(c88v4)
      if c88v3 then
        p17 = 10
      else
        p17 = 5
      end
    end
    if p17 == 5 then
      c88v3 = gGameData
      c88v3 = c88v3:GetSubscribedToSurveys()
      if not c88v3 then
        p17 = 10
      else
        p17 = 6
      end
    end
    if p17 == 6 then
      c88v3 = #c88v2
      c88v4 = 0
      if c88v3 <= c88v4 then
        p17 = 10
      else
        p17 = 7
      end
    end
    if p17 == 7 then
      c88v3 = c88v2[1]
      c88v3 = c88v3.mSurveyLocation
      if c88v3 ~= "EXIT" then
        p17 = 10
      else
        p17 = 8
      end
    end
    if p17 == 8 then
      c88v3 = mMovie
      c88v5 = gameExitSurveyMovie
      c88v3 = c88v3:PushChildMovie(c88v5)
      vT[15] = c88v3
      c88v4 = vT[15]
      c88v3 = IsNull
      c88v3 = c88v3(c88v4)
      if c88v3 then
        p17 = 11
      else
        p17 = 9
      end
    end
    if p17 == 9 then
      c88v3 = vT[15]
      c88v5 = "OnLogout"
      c88v8 = ",LogOutConfirm"
      c88v6 = c88v1 .. c88v8
      c88v3:Execute(c88v5, c88v6)
      do return end
    end
    if p17 == 10 then
      c88v3 = vT[0]
      c88v3 = c88v3.ShowYesOrNoMessage
      c88v5 = "LogOutConfirm"
      c88v3 = c88v3(c88v0, c88v5)
      vT[15] = c88v3
      p17 = 11
    end
    if p17 == 11 then
      do return end
    end
  end
  vT[114] = function()
    local c89v0, c89v1, c89v2
    c89v0 = vT[113]
    c89v1 = "/Lotus/Language/Menu/Popup_ProfileSwitchConfirm"
    c89v2 = "/Lotus/Language/Menu/NavBar_SwitchProfileToolTip"
    c89v0(c89v1, c89v2)
    do return end
  end
  vT[115] = function()
    local c90v0, c90v1
    c90v0 = vT[0]
    c90v0 = c90v0.DoOpenWebBrowser
    c90v1 = "http://support.warframe.com"
    c90v0(c90v1)
    do return end
  end
  vT[116] = function()
    local c91v0, c91v1, c91v2
    c91v0 = vT[113]
    c91v1 = "/Lotus/Language/Menu/MainMenu_LogoffConfirm"
    c91v2 = "/Lotus/Language/Menu/NavBar_LogoutToolTip"
    c91v0(c91v1, c91v2)
    do return end
  end
  vT[117] = function()
    local c92v0, c92v2, c92v3
    c92v0 = _T.BackgroundMovie
    c92v2 = "InitiateAccountRename"
    c92v3 = "false"
    c92v0:Execute(c92v2, c92v3)
    do return end
  end
  vT[118] = function()
    local c93v0, c93v1
    c93v0 = gPlayerProfileMgr
    c93v0:Name__94169df4()
    c93v0 = vT[79]
    c93v1 = false
    c93v0(c93v1)
    do return end
  end
  vT[119] = function()
    local c94v0, c94v1, c94v2, c94v3
    c94v0 = vT[5]
    c94v0 = c94v0.ProfileIconSelect
    c94v1 = mMovie
    c94v2 = premiumCategoryIcon
    c94v3 = profileIconChangedFx
    c94v0(c94v1, c94v2, c94v3)
    c94v0 = _T
    c94v1 = false
    c94v0.TopMenuOpen = c94v1
    do return end
  end
  vT[120] = function()
    local c95v0
    c95v0 = vT[119]
    c95v0()
    do return end
  end
  ShowGlyphSelect = vT[120]
  vT[120] = function(c96v0)
    local c96v1, c96v2, c96v3, c96v4, c96v5
    c96v1 = #c96v0
    c96v2 = 0
    while true do
      if c96v1 <= c96v2 then
        do return end
      end
      c96v2 = c96v2 + 1
      c96v3 = c96v0[c96v2]
      c96v3 = c96v3.DisplayIn
      c96v3 = vT[0]
      c96v3 = c96v3.IsValueInTable
      c96v4 = c96v0[c96v2]
      c96v4 = c96v4.DisplayIn
      c96v5 = vT[23]
      c96v3 = c96v3(c96v4, c96v5)
      c96v3 = c96v0[c96v2]
      c96v3 = c96v3.ShouldDisplay
      c96v3 = c96v0[c96v2]
      c96v3 = c96v3.ShouldDisplay
      c96v3 = c96v3()
      c96v3 = table.remove
      c96v3(c96v0, c96v2)
      c96v1 = c96v1 - 1
      c96v2 = c96v2 - 1
      c96v3 = c96v0[c96v2]
      c96v3 = c96v3.Menu
      if c96v3 ~= nil then
        c96v3 = vT[120]
        c96v4 = c96v0[c96v2]
        c96v4 = c96v4.Menu
        c96v3(c96v4)
      end
    end
  end
  vT[121] = function(c97v0, c97v1)
    local c97v2, c97v3, c97v4, c97v7, c97v8
    c97v2 = ipairs
    c97v2, c97v3, c97v4 = c97v2(c97v0)
    for c97v5, c97v6 in c97v2, c97v3, c97v4 do
      c97v7 = c97v6.Menu
      if c97v7 ~= nil then
        c97v7 = vT[121]
        c97v8 = c97v6.Menu
        c97v7 = c97v7(c97v8, c97v1)
        if c97v7 ~= nil then
          do return c97v7 end
        end
      else
        c97v7 = c97v6.Name
        if c97v7 == c97v1 then
          do return c97v6 end
        end
      end
    end
    c97v2 = nil
    do return c97v2 end
  end
  vT[122] = function()
    local c98v0, c98v1, c98v2, c98v3
    c98v0 = vT[30]
    if c98v0 then
      c98v0 = vT[30]
      c98v0 = c98v0:IsLoading()
      if c98v0 then
        c98v0 = vT[30]
        c98v0 = c98v0:LoadingComplete()
        if c98v0 then
          c98v0 = vT[30]
          c98v0:FinishLoad()
          c98v0 = nil
          vT[30] = c98v0
          c98v0 = _T.BackgroundMovie
          c98v2 = "LoadStarChart"
          c98v3 = ""
          c98v0:Execute(c98v2, c98v3)
          c98v0 = _T.GoToScreen
          c98v1 = "MissionDeck"
          c98v0(c98v1)
        end
      end
    end
    do return end
  end
  vT[123] = function(c99v0)
    local c99v1, c99v2, c99v3
    c99v1 = vT[7]
    c99v1 = c99v1.SetupTargetConsole
    c99v2 = { TargetConsole = nil }
    c99v2.TargetConsole = c99v0
    c99v3 = vT[64]
    c99v1 = c99v1(c99v2, c99v3)
    if c99v1 then
      c99v1 = vT[80]
      c99v1()
    end
    do return end
  end
  TriggerConsole = vT[123]
  vT[123] = function()
    local c100v0
    c100v0 = vT[0]
    c100v0 = c100v0.DoShowPlatformHelp
    c100v0()
    do return end
  end
  vT[124] = function()
    local c101v0, c101v1, c101v2, c101v3, c101v4, c101v5
    c101v0 = vT[1]
    c101v0 = c101v0.GetMeleeStanceUpgradeInfo
    c101v0 = c101v0()
    c101v1 = IsNull
    c101v1 = c101v1(c101v0)
    if not c101v1 then
      c101v1 = vT[1]
      c101v1 = c101v1.ShowCombos
      c101v2 = mMovie
      c101v1 = c101v1(c101v2, c101v0)
      vT[15] = c101v1
      do return end
    end
    c101v1 = mMovie
    c101v3 = "/Lotus/Language/Items/NoStanceInstalled"
    c101v4 = true
    c101v1 = c101v1:GetLocalized(c101v3, c101v4)
    c101v2 = mMovie
    c101v4 = "/Lotus/Language/Items/NoStanceInstalledDetails"
    c101v5 = true
    c101v2 = c101v2:GetLocalized(c101v4, c101v5)
    c101v4 = "\r\n\r\n"
    c101v2 = c101v1 .. c101v4 .. c101v2
    c101v3 = vT[0]
    c101v3 = c101v3.ShowMessage
    c101v3 = c101v3(c101v2)
    vT[15] = c101v3
    do return end
  end
  vT[125] = function()
    local c102v0, c102v1, c102v2, c102v3, c102v4, c102v5, c102v7
    c102v0 = 0
    c102v1 = gRegion
    c102v3 = Symbol
    c102v4 = "Syndicates"
    c102v1 = c102v1:FindTagged(c102v3(c102v4))
    c102v4 = 1
    c102v2 = #c102v1
    c102v3 = 1
    for c102v4 = c102v4, c102v2, c102v3 do
      c102v5 = c102v1[c102v4]
      c102v7 = gUIConsoleTriggerType
      c102v5 = c102v5:IsA(c102v7)
      if c102v5 then break end
      if c102v5 then
        c102v5 = c102v1[c102v4]
        c102v0 = c102v5:GetPlayerLevelRequirement()
      end
    end
    c102v4 = gGameData
    c102v3 = IsNull
    c102v3 = c102v3(c102v4)
    c102v2 = not c102v3
    if c102v2 then
      c102v3 = gGameData
      c102v3 = c102v3:Name__1d1bb34a()
      if c102v3 < c102v0 then
        c102v2 = false
      else
        c102v2 = true
      end
    end
    do return c102v2 end
  end
  vT[126] = function()
    do return end
  end
  OnUpdateSessionSettings = vT[126]
  vT[126] = function()
    local c104v0, c104v1, c104v2
    c104v0 = vT[7]
    c104v0 = c104v0.ExecuteAction
    c104v1 = Symbol
    c104v2 = "RailJackTube"
    c104v0(c104v1(c104v2))
    c104v0 = mMovie
    c104v0:Close()
    do return end
  end
  vT[127] = function()
    local c105v0, c105v1, c105v2
    c105v0 = vT[7]
    c105v0 = c105v0.ExecuteAction
    c105v1 = Symbol
    c105v2 = "OrbiterTube"
    c105v0(c105v1(c105v2))
    c105v0 = mMovie
    c105v0:Close()
    do return end
  end
  vT[128] = function()
    local c115v0, c115v1, c115v2, c115v3, c115v4, c115v5
    local p9 = 0
    if p9 == 0 then
      c115v0 = vT[1]
      c115v0 = c115v0.IsDevServer
      c115v0 = c115v0()
      if c115v0 then
        p9 = 3
      else
        p9 = 1
      end
    end
    if p9 == 1 then
      c115v0 = vT[1]
      c115v0 = c115v0.IsTestServer
      c115v0 = c115v0()
      if c115v0 then
        p9 = 3
      else
        p9 = 2
      end
    end
    if p9 == 2 then
      c115v0 = vT[1]
      c115v0 = c115v0.IsLocalServer
      c115v0 = c115v0()
      if not c115v0 then
        p9 = 5
      else
        p9 = 3
      end
    end
    if p9 == 3 then
      c115v0 = gRegion
      c115v0 = c115v0:IsMaster()
      if not c115v0 then
        p9 = 5
      else
        p9 = 4
      end
    end
    if p9 == 4 then
      c115v0 = vT[70]
      c115v0 = c115v0()
      if c115v0 then
        p9 = 6
      else
        p9 = 5
      end
    end
    if p9 == 5 then
      do return end
    end
    if p9 == 6 then
      c115v0 = mMovie
      c115v2 = genericMenuMovie
      c115v0 = c115v0:PushChildMovie(c115v2)
      c115v3 = "SetTitle"
      c115v4 = "Launch Mission Key"
      c115v0:Execute(c115v3, c115v4)
      c115v1 = _T
      c115v1.KeyLauncherMovie = c115v0
      c115v1 = _T
      c115v2 = nil
      c115v1.KeyLauncherEnterCustomFingerprint = c115v2
      c115v1 = _T
      c115v2 = function(c106v0)
        local c106v1, c106v2, c106v3, c106v4, c106v6, c106v7, c106v9
        c106v1 = _T
        c106v2 = nil
        c106v1.GetComponents = c106v2
        c106v1 = _T
        c106v2 = nil
        c106v1.ResetSelectionDone = c106v2
        c106v1 = false
        vT[1] = c106v1
        c106v1 = nil
        c115v0 = c106v1
        c106v1 = c106v0[1]
        if c106v1 ~= nil then
          c106v1 = c106v0[1]
          c106v1 = c106v1.mKeyName
          c106v3 = _T.KeyLauncherSteelPathMode
          if c106v3 then
            c106v2 = vT[1]
            c106v2 = c106v2.HARD_MODE_TAG
          else
            c106v2 = ""
          end
          c106v4 = _T.KeyLauncherEnterCustomFingerprint
          if c106v4 then
            c106v3 = _T.KeyLauncherEnterCustomFingerprint
          else
            c106v3 = ""
          end
          c106v4 = _T.BackgroundMovie
          c106v6 = "DebugLoadMission"
          c106v9 = ""
          c106v7 = {c106v1, c106v9, c106v2, c106v3}
          c106v4:Name__8b1f0505(c106v6, c106v7)
        end
        do return end
      end
      c115v1.MenuSelectionDone = c115v2
      c115v3 = "SetCallBack"
      c115v4 = "MenuSelectionDone"
      c115v0:Execute(c115v3, c115v4)
      c115v1 = _T
      c115v2 = function()
        local c109v0, c109v1, c109v2, c109v3, c109v4, c109v5, c109v6, c109v7, c109v8, c109v9, c109v10, c109v11, c109v12, c109v13, c109v14, c109v15, c109v16, c109v17
        c109v0 = {}
        c109v2 = "/Lotus/Types/Keys/"
        c109v1 = string.len
        c109v1 = c109v1(c109v2)
        c109v2 = {}
        c109v3 = gGameConfig
        c109v3 = c109v3:Name__8ba81c46()
        c109v4 = pairs
        c109v4, c109v5, c109v6 = c109v4(c109v3)
        for c109v7, c109v8 in c109v4, c109v5, c109v6 do
          c109v9 = tostring
          c109v10 = c109v9(c109v8:GetFullName())
          c109v11 = string.find
          c109v13 = "/Lotus/Types/Keys/"
          c109v11 = c109v11(c109v10, c109v13)
          if c109v11 then
            c109v14 = c109v11 + c109v1
            c109v15 = string.len
            c109v15 = c109v15(c109v10)
            c109v12 = string.sub
            c109v10 = c109v12(c109v10, c109v14, c109v15)
          end
          c109v14 = { mName = nil, mKeyName = nil }
          c109v14.mName = c109v10
          c109v14.mKeyName = c109v9
          c109v12 = table.insert
          c109v12(c109v2, c109v14)
        end
        c109v4 = table.sort
        c109v6 = function(c107v0, c107v1)
          local c107v2, c107v3, c107v4
          c107v3 = c107v0.mKeyName
          c107v4 = c107v1.mKeyName
          if c107v4 <= c107v3 then
            c107v2 = false
          else
            c107v2 = true
          end
          do return c107v2 end
        end
        c109v4(c109v2, c109v6)
        c109v4 = pairs
        c109v4, c109v5, c109v6 = c109v4(c109v2)
        for c109v7, c109v8 in c109v4, c109v5, c109v6 do
          c109v9 = table.insert
          c109v9(c109v0, c109v8)
        end
        c109v4 = vT[1]
        c109v4 = c109v4.GetStarChartNodes
        c109v4 = c109v4()
        c109v5 = {}
        c109v6 = c109v4
        c109v7 = nil
        c109v8 = nil
        for c109v9, c109v10 in c109v6, c109v7, c109v8 do
          c109v13 = { name = nil, loc = nil }
          c109v15 = c109v10.name
          c109v14 = tostring
          c109v14 = c109v14(c109v15)
          c109v13.name = c109v14
          c109v14 = Localize
          c109v16 = c109v10.locTag
          c109v15 = tostring
          c109v15 = c109v15(c109v16)
          c109v16 = {}
          c109v14 = c109v14(c109v15, c109v16)
          c109v13.loc = c109v14
          c109v11 = table.insert
          c109v11(c109v5, c109v13)
        end
        c109v6 = table.sort
        c109v8 = function(c108v0, c108v1)
          local c108v2, c108v3, c108v4
          c108v3 = c108v0.name
          c108v4 = c108v1.name
          if c108v4 <= c108v3 then
            c108v2 = false
          else
            c108v2 = true
          end
          do return c108v2 end
        end
        c109v6(c109v5, c109v8)
        c109v6 = c109v5
        c109v7 = nil
        c109v8 = nil
        for c109v9, c109v10 in c109v6, c109v7, c109v8 do
          c109v13 = { mName = nil, mKeyName = nil }
          c109v15 = c109v10.name
          c109v16 = " - "
          c109v17 = c109v10.loc
          c109v14 = c109v15 .. c109v16 .. c109v17
          c109v13.mName = c109v14
          c109v14 = c109v10.name
          c109v13.mKeyName = c109v14
          c109v11 = table.insert
          c109v11(c109v0, c109v13)
        end
        do return c109v0 end
      end
      c115v1.GetMenuEntries = c115v2
      c115v1 = _T
      c115v2 = function()
        local c110v0, c110v1, c110v2, c110v3
        c110v0 = _T
        c110v2 = _T.KeyLauncherSteelPathMode
        if c110v2 then
          c110v1 = false
        else
          c110v1 = true
        end
        c110v0.KeyLauncherSteelPathMode = c110v1
        c110v0 = _T.KeyLauncherMovie
        c110v2 = "UpdateButtons"
        c110v3 = ""
        c110v0:Execute(c110v2, c110v3)
        do return end
      end
      c115v1.KeyLauncherToggleSteelPathMode = c115v2
      c115v1 = _T
      c115v2 = function()
        local c111v0, c111v1, c111v2, c111v3, c111v4, c111v5, c111v6, c111v7
        c111v0 = vT[1]
        c111v0 = c111v0.ShowInputDialog
        c111v1 = c115v0
        c111v2 = "Enter proc level fingerprint"
        c111v3 = ""
        c111v4 = 1000
        c111v5 = "KeyLauncherLoadCustomMission"
        c111v6 = "KeyLauncherLoadCustomMissionOSK"
        c111v7 = { isMultiline = false }
        c111v0(c111v1, c111v2, c111v3, c111v4, c111v5, c111v6, c111v7)
        c111v0 = _T.KeyLauncherMovie
        c111v2 = false
        c111v0:SetVisible(c111v2)
        do return end
      end
      c115v1.KeyLauncherEnterCustomMission = c115v2
      c115v1 = _T
      c115v2 = function(c112v0)
        local c112v1, c112v2, c112v3, c112v4
        c112v1 = {}
        c112v2 = { Label = nil, CallBack = "KeyLauncherToggleSteelPathMode", CallOut = "MENU_GENERIC1" }
        c112v4 = _T.KeyLauncherSteelPathMode
        if c112v4 then
          c112v3 = "<CHECKMARK> Steel Path"
        else
          c112v3 = "<CHECKMARK_OUTLINE> Steel Path"
        end
        c112v2.Label = c112v3
        c112v3 = { Label = "Fingerprint", CallBack = "KeyLauncherEnterCustomMission", CallOut = "MENU_GENERIC2" }
        c112v1 = {c112v2, c112v3}
        do return c112v1 end
      end
      c115v1.GetButtons = c115v2
      c115v1 = getfenv
      c115v2 = 0
      c115v1 = c115v1(c115v2)
      c115v2 = function(c113v0, c113v1, c113v2)
        local c113v3, c113v4, c113v5, c113v6, c113v7
        c113v3 = _T.KeyLauncherMovie
        c113v5 = true
        c113v3:SetVisible(c113v5)
        c113v3 = IsNull
        c113v3 = c113v3(c113v2)
        if not c113v3 then
          c113v3 = tonumber
          c113v3 = c113v3(c113v2)
          c113v4 = 4
          if c113v3 == c113v4 then
            c113v3 = _T
            c113v3.KeyLauncherEnterCustomFingerprint = c113v0
            c113v3 = c115v0
            c113v5 = "SetTitle"
            c113v7 = "Using Fingerprint "
            c113v6 = c113v7 .. c113v0
            c113v3:Execute(c113v5, c113v6)
          end
        end
        do return end
      end
      c115v1.KeyLauncherLoadCustomMission = c115v2
      c115v2 = function(c114v0, c114v1)
        local c114v2, c114v4, c114v5, c114v6
        c114v2 = _T.KeyLauncherMovie
        c114v4 = true
        c114v2:SetVisible(c114v4)
        if not c114v0 then
          c114v2 = _T
          c114v2.KeyLauncherEnterCustomFingerprint = c114v1
          c114v2 = c115v0
          c114v4 = "SetTitle"
          c114v6 = "Using Fingerprint "
          c114v5 = c114v6 .. c114v1
          c114v2:Execute(c114v4, c114v5)
        end
        do return end
      end
      c115v1.KeyLauncherLoadCustomMissionOSK = c115v2
      c115v4 = "SetElementsFunction"
      c115v5 = "GetMenuEntries"
      c115v0:Execute(c115v4, c115v5)
      c115v4 = "SetGetButtonsFunction"
      c115v5 = "GetButtons"
      c115v0:Execute(c115v4, c115v5)
      c115v4 = "EnableSearchBox"
      c115v5 = ""
      c115v0:Execute(c115v4, c115v5)
      c115v4 = "SetTitleCaseText"
      c115v5 = "false, true"
      c115v0:Execute(c115v4, c115v5)
      c115v4 = true
      c115v0:SetPreDrawUpdate(c115v4)
      do return end
    end
  end
  vT[129] = function()
    do return end
  end
  vT[130] = function(c117v0)
    local c117v1, c117v2, c117v3, c117v4, c117v5, c117v6
    c117v1 = Resource
    c117v2 = _T.CheatMenuSelectedCommand
    c117v1 = c117v1(c117v2)
    if not c117v0 then
      c117v0 = ""
    end
    c117v2 = Broadcast
    c117v4 = "Executed cheat: "
    c117v5 = _T.CheatMenuSelectedCommand
    c117v6 = " "
    c117v3 = c117v4 .. c117v5 .. c117v6 .. c117v0
    c117v2(c117v3)
    c117v2 = gFlashMgr
    c117v2:ExecuteToolMenuCommand(c117v1, c117v0)
    do return end
  end
  vT[131] = function(c118v0)
    local c118v1
    c118v1 = vT[130]
    c118v1(c118v0)
    do return end
  end
  CheatMenuParamCallback = vT[131]
  vT[131] = function(c119v0, c119v1)
    local c119v2
    if not c119v0 then
      c119v2 = vT[130]
      c119v2(c119v1)
    end
    do return end
  end
  OSKCheatMenuParamCallback = vT[131]
  vT[131] = function(c120v0)
    local c120v1, c120v2, c120v3, c120v4
    c120v1 = _T.BackgroundMovie
    c120v3 = "ShowBlockingMessage"
    c120v4 = "0"
    c120v1:Execute(c120v3, c120v4)
    if not c120v0 then
      c120v1 = _G
      c120v2 = false
      c120v1.StalkerMode = c120v2
      c120v1 = _G
      c120v2 = false
      c120v1.TempStalker = c120v2
      c120v1 = gGameData
      c120v3 = false
      c120v1:SetStalkerLoadout(c120v3)
      c120v1 = vT[0]
      c120v1 = c120v1.ShowMessage
      c120v2 = "/Lotus/Language/JadeShadows/StalkerJoinSessionFailed"
      c120v1(c120v2)
    end
    do return end
  end
  vT[132] = function(c121v0)
    local c121v1
    c121v1 = vT[131]
    c121v1(c121v0)
    do return end
  end
  OnJoinStalkerSessionComplete = vT[132]
  vT[132] = function(c122v0)
    local c122v1, c122v2, c122v3, c122v4, c122v5, c122v6, c122v7, c122v8, c122v9, c122v10
    c122v1 = gMatchingService
    c122v1 = c122v1:GetSearchResults()
    c122v2 = IsNull
    c122v2 = c122v2(c122v1)
    c122v2 = _G
    c122v3 = true
    c122v2.StalkerMode = c122v3
    c122v2 = _G
    c122v3 = true
    c122v2.TempStalker = c122v3
    c122v2 = gGameData
    c122v4 = true
    c122v2:SetStalkerLoadout(c122v4)
    c122v4 = 1
    c122v2 = #c122v1
    c122v3 = 1
    for c122v4 = c122v4, c122v2, c122v3 do
      c122v5 = c122v1[c122v4]
      c122v6 = c122v5:GetSettings()
      c122v6 = c122v6.gameModeId
      c122v7 = c122v5:GetSettings()
      c122v7 = c122v7.hasStarted
      if c122v7 then
        c122v7 = vT[1]
        c122v7 = c122v7.IsPvpGameModeId
        c122v7 = c122v7(c122v6)
        if not c122v7 then
          c122v7 = vT[1]
          c122v7 = c122v7.IsHubGameModeId
          c122v7 = c122v7(c122v6)
          if not c122v7 then
            c122v7 = vT[1]
            c122v7 = c122v7.IsClanDojoGameModeId
            c122v7 = c122v7(c122v6)
            if not c122v7 then
              c122v7 = vT[1]
              c122v7 = c122v7.IsDojoDuelGameModeId
              c122v7 = c122v7(c122v6)
              if not c122v7 then
                c122v7 = vT[1]
                c122v7 = c122v7.IsSimulacrumGameModeId
                c122v7 = c122v7(c122v6)
                if not c122v7 then
                  c122v7 = vT[1]
                  c122v7 = c122v7.IsPhotoboothGameModeId
                  c122v7 = c122v7(c122v6)
                  if not c122v7 then break end
                  if not c122v7 then
                    c122v7 = print
                    c122v9 = "joining "
                    c122v10 = c122v5:GetHostName()
                    c122v8 = c122v9 .. c122v10
                    c122v7(c122v8)
                    c122v7 = vT[3]
                    c122v7 = c122v7.JoinLobby
                    c122v8 = "OnJoinStalkerSessionComplete"
                    c122v7(c122v8, c122v5)
                    do return end
                  end
                end
              end
            end
          end
        end
      end
    end
    c122v2 = vT[131]
    c122v3 = false
    c122v2(c122v3)
    do return end
  end
  OnFindStalkerSessions = vT[132]
  vT[132] = function()
    local c123v0, c123v1, c123v2, c123v3, c123v4, c123v5, c123v6, c123v7, c123v8, c123v9
    c123v1 = gGameRules
    c123v0 = IsNull
    c123v0 = c123v0(c123v1)
    if not c123v0 then
      c123v1 = gGameRules
      c123v0 = IsNull
      c123v0 = c123v0(c123v1:GetMission())
      if not c123v0 then
        c123v0 = ""
        c123v1 = ""
        c123v2 = "/Lotus/Language/Menu/MenuReturnToShipDescription"
        c123v3 = true
        c123v4 = gGameRules
        c123v4 = c123v4:GetMission()
        c123v4 = c123v4.location
        c123v5 = gGameRules
        c123v5 = c123v5:GetMission()
        c123v6 = vT[1]
        c123v6 = c123v6.PLAINS_NODE_TAG
        if c123v4 ~= c123v6 then
          c123v6 = vT[1]
          c123v6 = c123v6.SAYAS_VISION_NODE_TAG
          if c123v4 ~= c123v6 then
            c123v6 = vT[1]
            c123v6 = c123v6.ORB_VALLIS_NODE_TAG
            if c123v4 ~= c123v6 then
              c123v6 = vT[1]
              c123v6 = c123v6.NOKKO_COLONY_NODE_TAG
              if c123v4 ~= c123v6 then
                c123v6 = vT[1]
                c123v6 = c123v6.ENTRATI_LANDSCAPE_NODE_TAG
                if c123v4 == c123v6 then
                  c123v0 = "/Lotus/Language/InfestedMicroplanet/ReturnToHubEntrati"
                  c123v1 = "/Lotus/Language/InfestedMicroplanet/MenuReturnToHubEntratiDescription"
                  c123v6 = vT[1]
                  c123v6 = c123v6.CanAccessDeimosHub
                  c123v3 = c123v6()
                  do return c123v0, c123v1, c123v2, c123v3 end
                end
                c123v6 = vT[1]
                c123v6 = c123v6.IsDuviriNode
                c123v7 = tostring
                c123v7 = c123v7(c123v4)
                c123v6 = c123v6(c123v7)
                if c123v4 ~= c123v6 then
                  c123v0 = "/Lotus/Language/Duviri/ReturnToDormizone"
                  c123v6 = gGameRules
                  c123v8 = duviriEndlessGameRules
                  c123v6 = c123v6:IsA(c123v8)
                  if c123v6 then
                    c123v1 = "/Lotus/Language/Duviri/MenuCircuitAbortToDormizone"
                    c123v2 = "/Lotus/Language/Duviri/MenuCircuitAbortToOrbiter"
                  else
                    c123v1 = "/Lotus/Language/Duviri/MenuAbortToDormizone"
                    c123v2 = "/Lotus/Language/Duviri/MenuAbortToOrbiter"
                  end
                  c123v6 = vT[1]
                  c123v6 = c123v6.IsParadoxPath
                  c123v7 = gGameData
                  c123v6 = c123v6(c123v7)
                  if not c123v6 then
                    c123v6 = vT[1]
                    c123v6 = c123v6.HasCompletedQuest
                    c123v7 = zarimanQuestKeyChain
                    c123v6 = c123v6(c123v7)
                  end
                  do return c123v0, c123v1, c123v2, c123v6 end
                end
                c123v6 = vT[1]
                c123v6 = c123v6.IsVaniaNode
                c123v7 = tostring
                c123v7 = c123v7(c123v4)
                c123v6 = c123v6(c123v7)
                if c123v6 then
                  c123v0 = "/Lotus/Language/1999/1999HubName"
                  c123v1 = "/Lotus/Language/1999/MenuReturnToHubDescription"
                  c123v6 = vT[1]
                  c123v6 = c123v6.HasCompletedQuest
                  c123v7 = hexQuestKeyChain
                  c123v3 = c123v6(c123v7)
                  do return c123v0, c123v1, c123v2, c123v3 end
                end
                c123v6 = vT[1]
                c123v6 = c123v6.GetNodeInfo
                c123v7 = tostring
                c123v7 = c123v7(c123v4)
                c123v6 = c123v6(c123v7)
                if c123v6 ~= nil then
                  c123v7 = c123v6.region
                  c123v9 = vT[1]
                  c123v9 = c123v9.REGION_ID_ZARIMAN
                  c123v8 = c123v9 - 1
                  if c123v7 == c123v8 then
                    c123v0 = "/Lotus/Language/Zariman/ReturnToHubZariman"
                    c123v1 = "/Lotus/Language/Zariman/MenuReturnToHubZarimanDescription"
                    do return c123v0, c123v1, c123v2, c123v3 end
                  end
                end
                if c123v6 == nil then
                  c123v3 = false
                end
                do return c123v0, c123v1, c123v2, c123v3 end
              end
            end
            c123v0 = "/Lotus/Language/Menu/ReturnToHubVenus"
            c123v1 = "/Lotus/Language/Menu/MenuReturnToHubVenusDescription"
            do return c123v0, c123v1, c123v2, c123v3 end
          end
        end
        c123v0 = "/Lotus/Language/Menu/ReturnToHub"
        c123v1 = "/Lotus/Language/Menu/MenuReturnToHubDescription"
        do return c123v0, c123v1, c123v2, c123v3 end
      end
    end
    c123v0 = ""
    c123v1 = ""
    c123v2 = true
    do return c123v0, c123v1, c123v2 end
  end
  vT[133] = function(c124v0)
    local c124v1, c124v2, c124v3, c124v4
    c124v1 = vT[23]
    c124v2 = vT[1]
    c124v2 = c124v2.UI_MODE_IN_DOJO
    if c124v1 ~= c124v2 then
      c124v1 = true
      do return c124v1 end
    end
    c124v2 = vT[24]
    c124v1 = IsNull
    c124v1 = c124v1(c124v2)
    if not c124v1 then
      c124v1 = vT[1]
      c124v1 = c124v1.GetDojoConsole
      c124v3 = vT[24]
      c124v3 = c124v3:GetPosition()
      c124v4 = true
      c124v1 = c124v1(c124v0, c124v3, c124v4)
      c124v3 = IsNull
      c124v3 = c124v3(c124v1)
      c124v2 = not c124v3
      do return c124v2 end
    end
    c124v1 = false
    do return c124v1 end
  end
  vT[134] = function()
    local c125v0, c125v1, c125v2, c125v3
    c125v0 = gRegion
    c125v0 = c125v0:GetLocalPlayer()
    c125v2 = IsNull
    c125v2 = c125v2(c125v0)
    c125v1 = not c125v2
    if c125v1 then
      c125v2 = gGameRules
      c125v2 = c125v2:IsMaster()
      c125v3 = c125v0:IsMaster()
      if c125v2 ~= c125v3 then
        c125v1 = false
      else
        c125v1 = true
      end
    end
    do return c125v1 end
  end
  vT[135] = function()
    local c126v0, c126v1, c126v2, c126v3, c126v4, c126v5
    c126v1 = vT[17]
    c126v0 = IsNull
    c126v0 = c126v0(c126v1)
    if c126v0 then
      c126v1 = mMovie
      c126v0 = IsNull
      c126v0 = c126v0(c126v1)
      if not c126v0 then
        c126v0 = mMovie
        c126v2 = taskMovie
        c126v0 = c126v0:PushChildMovie(c126v2)
        vT[17] = c126v0
        c126v0 = vT[17]
        c126v2 = "SetTitle"
        c126v3 = "/Lotus/Language/Menu/Challenges"
        c126v0:Execute(c126v2, c126v3)
        c126v0 = _T.TaskListSetChallenges
        c126v1 = _T.CurrentYareliChallenges
        c126v2 = "_Description"
        c126v3 = nil
        c126v4 = "_Details"
        c126v0(c126v1, c126v2, c126v3, c126v4)
        c126v0 = vT[17]
        c126v2 = "Panel"
        c126v3 = 14
        c126v0 = c126v0:GetNumberVariable(c126v2, c126v3)
        c126v1 = vT[17]
        c126v3 = "SetInMission"
        c126v4 = "true"
        c126v1:Execute(c126v3, c126v4)
        c126v3 = vT[17]
        c126v3 = c126v3:GetMovieWidth()
        c126v2 = c126v3 * 0.95
        c126v1 = c126v2 - c126v0
        c126v2 = vT[17]
        c126v4 = "SetPositionX"
        c126v2:Execute(c126v4, c126v1)
        c126v2 = vT[17]
        c126v4 = "SetCenterY"
        c126v5 = "false"
        c126v2:Execute(c126v4, c126v5)
        c126v2 = vT[17]
        c126v4 = "ShowTaskList"
        c126v5 = "0.5"
        c126v2:Execute(c126v4, c126v5)
      end
    end
    do return end
  end
  vT[136] = function()
    local c127v0, c127v1
    c127v0 = _T.HideYareliChallenges
    if c127v0 ~= nil then
      c127v0 = _T
      c127v1 = nil
      c127v0.HideYareliChallenges = c127v1
    else
      c127v0 = _T
      c127v1 = true
      c127v0.HideYareliChallenges = c127v1
    end
    c127v0 = ShouldShowYareliChallenges
    c127v0 = c127v0()
    if c127v0 then
      c127v0 = vT[135]
      c127v0()
    end
    do return end
  end
  vT[137] = function()
    local c128v0
    c128v0 = _T.RestartRace
    c128v0()
    c128v0 = vT[83]
    c128v0()
    do return end
  end
  vT[138] = function()
    local c130v0, c130v1, c130v2
    c130v0 = function(c129v0)
      local c129v1, c129v2
      c129v1 = tonumber
      c129v1 = c129v1(c129v0)
      c129v2 = 4
      if c129v1 == c129v2 then
        c129v1 = _T.QuitRace
        c129v1()
        c129v1 = vT[83]
        c129v1()
        do return end
      end
      c129v1 = vT[83]
      c129v1()
      do return end
    end
    c130v1 = vT[0]
    c130v1 = c130v1.ShowYesOrNoMessage
    c130v2 = "/Lotus/Language/OlliesCrashCourse/PauseMenu_OlliesCrashCourseQuit"
    c130v1 = c130v1(c130v2, c130v0)
    vT[15] = c130v1
    do return end
  end
  vT[139] = function()
    local c131v0, c131v1, c131v2
    c131v0 = vT[1]
    c131v0 = c131v0.GetActiveQuest
    c131v1 = gGameData
    c131v0 = c131v0(c131v1)
    c131v2 = IsNull
    c131v2 = c131v2(c131v0)
    c131v1 = not c131v2
    if c131v1 then
      c131v2 = hexQuestKeyChain
      if c131v0 ~= c131v2 then
        c131v1 = false
      else
        c131v1 = true
      end
    end
    do return c131v1 end
  end
  vT[140] = function()
    local c132v0
    c132v0 = _G
    c132v0 = c132v0.PlayingMiniGame
    if c132v0 == "OlliesCrashCourse" then
      c132v0 = true
      do return c132v0 end
    end
    c132v0 = false
    do return c132v0 end
  end
  vT[141] = function()
    local c133v0, c133v1, c133v2, c133v3, c133v4
    c133v0 = WeakResource
    c133v1 = "/Lotus/Levels/Proc/Vania/Quest/Stage11MissionThree"
    c133v0 = c133v0(c133v1)
    c133v1 = gGameRules
    c133v1 = c133v1:GetMission()
    c133v2 = vT[139]
    c133v2 = c133v2()
    if c133v2 then
      c133v3 = IsNull
      c133v3 = c133v3(c133v1)
      c133v2 = not c133v3
      if c133v2 then
        c133v4 = c133v1.levelOverride
        c133v3 = IsNull
        c133v3 = c133v3(c133v4)
        c133v2 = not c133v3
        if c133v2 then
          c133v3 = c133v1.levelOverride
          if c133v3 ~= c133v0 then
            c133v2 = false
          else
            c133v2 = true
          end
        end
      end
    end
    do return c133v2 end
  end
  vT[142] = function()
    local c134v0, c134v1, c134v2, c134v3
    c134v1 = gGameData
    c134v0 = IsNull
    c134v0 = c134v0(c134v1)
    if c134v0 then
      c134v0 = false
      do return c134v0 end
    end
    c134v0 = gGameData
    c134v0 = c134v0:GetLoadOut()
    c134v2 = c134v0.mOperatorType
    c134v3 = 4
    if c134v2 ~= c134v3 then
      c134v1 = false
    else
      c134v1 = true
    end
    do return c134v1 end
  end
  vT[143] = function()
    local c135v0, c135v1, c135v2, c135v3, c135v4, c135v5, c135v6
    c135v0 = mMovie
    c135v2 = "/Lotus/Language/Titles/TitleSelect_TitleShort"
    c135v3 = false
    c135v0 = c135v0:GetLocalized(c135v2, c135v3)
    c135v1 = vT[5]
    c135v1 = c135v1.HasNewTitles
    c135v1 = c135v1()
    if c135v1 then
      c135v1 = vT[0]
      c135v1 = c135v1.Ternary
      c135v2 = Engine.IsMobile
      c135v2 = c135v2()
      c135v3 = "<NEW_MOBILE>"
      c135v4 = "<NEW>"
      c135v1 = c135v1(c135v2, c135v3, c135v4)
      c135v3 = mMovie
      c135v6 = " "
      c135v5 = c135v6 .. c135v1
      c135v6 = true
      c135v3 = c135v3:GetLocalized(c135v5, c135v6)
      c135v0 = c135v0 .. c135v3
    end
    do return c135v0 end
  end
  vT[144] = function()
    local c293v0, c293v1, c293v2, c293v3, c293v4, c293v5, c293v6, c293v7, c293v8, c293v9, c293v10, c293v11, c293v12, c293v13, c293v14, c293v15, c293v16, c293v17, c293v18, c293v19, c293v20, c293v21, c293v22, c293v23, c293v24, c293v25, c293v26, c293v27, c293v28, c293v29, c293v30, c293v31, c293v32, c293v33, c293v34, c293v35, c293v36, c293v37, c293v38, c293v39, c293v40, c293v41, c293v42, c293v43, c293v44, c293v45, c293v46, c293v47
    c293v1 = gRegion
    c293v0 = IsNull
    c293v0 = c293v0(c293v1)
    if not c293v0 then
      c293v1 = gGameRules
      c293v0 = IsNull
      c293v0 = c293v0(c293v1)
      if not c293v0 then
        c293v0 = vT[7]
        c293v0 = c293v0.GetFastTravelRestrictions
        c293v1 = vT[24]
        c293v0 = c293v0(c293v1)
        vT[65] = c293v0
        c293v0 = { FishmongerName = "/Lotus/Language/Actions/OstronFishmonger", FishmongerDesc = "/Lotus/Language/OstronCrafting/FishmongerDescription", JewelerName = "/Lotus/Language/Actions/OstronProspector", JewelerDesc = "/Lotus/Language/Menu/MenuGoToJewelerDescription", QuestGiverName = "/Lotus/Language/Actions/Konzu", QuestGiverDesc = "/Lotus/Language/Menu/MenuGoToQuestGiverDescription", WeaponSmithName = "/Lotus/Language/Actions/OstronWeaponSmith", WeaponSmithDesc = "/Lotus/Language/Menu/MenuGoToWeaponSmithDescription", MaskVendorName = "/Lotus/Language/Actions/OstronMaskSalesman", MaskVendorDesc = "/Lotus/Language/Menu/MenuGoToMaskDescription", BeastMasterName = "/Lotus/Language/Actions/OstronPetVendor", BeastMasterDesc = "/Lotus/Language/Menu/MenuGoToBeastMasterDescription", MissionSelectName = "/Lotus/Language/Zariman/MissionSelectName", MissionSelectDesc = "/Lotus/Language/Zariman/MissionSelectDescription", MissionSelectTag = "MissionSelect" }
        c293v1 = "/Lotus/Language/Menu/ExitHubUpperCase"
        c293v2 = vT[0]
        c293v2 = c293v2.Ternary
        c293v3 = vT[65]
        c293v3 = c293v3.IsWarframeAvatar
        c293v4 = "CaveWaypoint"
        c293v5 = "OperatorAmpAction"
        c293v2 = c293v2(c293v3, c293v4, c293v5)
        c293v3 = vT[0]
        c293v3 = c293v3.Ternary
        c293v4 = vT[65]
        c293v4 = c293v4.IsWarframeAvatar
        c293v5 = "HeistRoomWaypoint"
        c293v6 = "LDVendor"
        c293v3 = c293v3(c293v4, c293v5, c293v6)
        c293v4 = "Arsenal"
        c293v6 = vT[1]
        c293v6 = c293v6.IsTailorShopLevel
        c293v6 = c293v6()
        if c293v6 then
          c293v5 = "ArthurComputerAction"
        else
          c293v5 = "1999"
        end
        c293v6 = vT[140]
        c293v6 = c293v6()
        c293v7 = false
        c293v8 = vT[142]
        c293v8 = c293v8()
        c293v10 = vT[24]
        c293v9 = IsNull
        c293v9 = c293v9(c293v10)
        if not c293v9 then
          c293v9 = vT[24]
          c293v9 = c293v9:InventoryControl()
          c293v9 = c293v9:GetMeleeWeapon()
          c293v10 = IsNull
          c293v10 = c293v10(c293v9)
          if not c293v10 then
            c293v10 = c293v9:GetType()
            c293v10 = c293v10:GetFullName()
            if c293v10 ~= "/Lotus/Weapons/Tenno/Melee/PoolNoodle/PoolNoodleWeapon" then
              c293v7 = true
            end
          end
        end
        c293v9 = vT[23]
        c293v10 = vT[1]
        c293v10 = c293v10.UI_MODE_IN_SPACE_HUB
        if not c293v6 then
          c293v9 = ""
          c293v11 = vT[49]
          c293v10 = IsNull
          c293v10 = c293v10(c293v11)
          if not c293v10 then
            c293v10 = vT[1]
            c293v10 = c293v10.IsInEntratiHub
            c293v10 = c293v10()
            if c293v10 then
              c293v9 = "/Lotus/Language/Entrati/ExitSanctumAnatomica"
              c293v4 = "ArsenalLab"
            else
              c293v10 = vT[49]
              c293v9 = c293v10:Name__413127cd()
            end
          end
          if c293v9 ~= "" then
            c293v1 = c293v9
          else
            c293v10 = _T.HubLocationDesc
            if c293v10 ~= nil then
              c293v10 = _T.HubLocationDesc
              if c293v10 ~= "" then
                c293v10 = mMovie
                c293v12 = "/Lotus/Language/Menu/ExitSpecificHubUpperCase"
                c293v13 = false
                c293v14 = { NAME = nil }
                c293v15 = string.upper
                c293v16 = _T.HubLocationDesc
                c293v15 = c293v15(c293v16)
                c293v14.NAME = c293v15
                c293v1 = c293v10:GetLocalized(c293v12, c293v13, c293v14)
              end
            end
          end
          c293v10 = vT[65]
          c293v10 = c293v10.InFortunaTown
          if c293v10 then
            c293v10 = "/Lotus/Language/SolarisVenus/FishmongerName"
            c293v0.FishmongerName = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/MenuGoToFishmongerDescriptionSV"
            c293v0.FishmongerDesc = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/ProspectorName"
            c293v0.JewelerName = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/Eudico"
            c293v0.QuestGiverName = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/MenuGoToQuestGiverDescriptionSV"
            c293v0.QuestGiverDesc = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/WeaponsmithName"
            c293v0.WeaponSmithName = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/MenuGoToWeaponSmithDescriptionSV"
            c293v0.WeaponSmithDesc = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/StockbrokerName"
            c293v0.MaskVendorName = c293v10
            c293v10 = "/Lotus/Language/SolarisVenus/MenuGoToStockbrokerDescriptionSV"
            c293v0.MaskVendorDesc = c293v10
          else
            c293v10 = vT[65]
            c293v10 = c293v10.InZarimanTown
            if c293v10 then
              c293v10 = "/Lotus/Language/Zariman/Hombask"
              c293v0.JewelerName = c293v10
              c293v10 = "/Lotus/Language/Zariman/ApartmentVendorDescription"
              c293v0.JewelerDesc = c293v10
              c293v10 = "/Lotus/Language/Zariman/Quinn"
              c293v0.QuestGiverName = c293v10
              c293v10 = "/Lotus/Language/Zariman/QuestGiverDescription"
              c293v0.QuestGiverDesc = c293v10
              c293v10 = "/Lotus/Language/Zariman/Cavalero"
              c293v0.WeaponSmithName = c293v10
              c293v10 = "/Lotus/Language/Zariman/WeaponsmithDescription"
              c293v0.WeaponSmithDesc = c293v10
            else
              c293v10 = vT[65]
              c293v10 = c293v10.In1999Town
              if c293v10 then
                c293v10 = "/Lotus/Language/OstronCrafting/JobBoard_Title"
                c293v0.QuestGiverName = c293v10
                c293v10 = "/Lotus/Language/1999/JobBoard_Desc"
                c293v0.QuestGiverDesc = c293v10
                c293v10 = "/Lotus/Language/CharacterIntro/EleanorName"
                c293v0.WeaponSmithName = c293v10
                c293v10 = "/Lotus/Language/FastTravel/NyxDesc"
                c293v0.WeaponSmithDesc = c293v10
                c293v10 = "/Lotus/Language/CharacterIntro/AoiName"
                c293v0.JewelerName = c293v10
                c293v10 = "/Lotus/Language/FastTravel/MagDesc"
                c293v0.JewelerDesc = c293v10
                c293v10 = "/Lotus/Language/CharacterIntro/LettieName"
                c293v0.BeastMasterName = c293v10
                c293v10 = "/Lotus/Language/FastTravel/TrinityDesc"
                c293v0.BeastMasterDesc = c293v10
                c293v10 = "/Lotus/Language/CharacterIntro/QuincyName"
                c293v0.FishmongerName = c293v10
                c293v10 = "/Lotus/Language/FastTravel/CyteDesc"
                c293v0.FishmongerDesc = c293v10
                c293v10 = "/Lotus/Language/CharacterIntro/AmirName"
                c293v0.MaskVendorName = c293v10
                c293v10 = "/Lotus/Language/FastTravel/VoltDesc"
                c293v0.MaskVendorDesc = c293v10
                c293v10 = "/Lotus/Language/FastTravel/1999MissionSelectName"
                c293v0.MissionSelectName = c293v10
                c293v10 = "/Lotus/Language/FastTravel/1999MissionSelectDesc"
                c293v0.MissionSelectDesc = c293v10
                c293v10 = "GarageComputer"
                c293v0.MissionSelectTag = c293v10
              else
                c293v10 = vT[65]
                c293v10 = c293v10.CompletedSayasVigil
                if c293v10 then
                  c293v10 = "/Lotus/Language/Npcs/KonzuAndSaya"
                  c293v0.QuestGiverName = c293v10
                end
              end
            end
          end
        else
          c293v9 = vT[65]
          c293v9 = c293v9.IsStalkerHideout
          if c293v9 then
            c293v9 = mMovie
            c293v11 = "/Lotus/Language/Menu/ExitSpecificHubUpperCase"
            c293v12 = false
            c293v13 = { NAME = "" }
            c293v1 = c293v9:GetLocalized(c293v11, c293v12, c293v13)
          else
            c293v9 = vT[65]
            c293v9 = c293v9.IsApartment
            if c293v9 then
              c293v9 = mMovie
              c293v11 = "/Lotus/Language/Menu/ExitSpecificHubUpperCase"
              c293v12 = false
              c293v13 = { NAME = nil }
              c293v14 = Localize
              c293v15 = "/Lotus/Language/Zariman/ZarimanApartment"
              c293v16 = {}
              c293v14 = c293v14(c293v15, c293v16)
              c293v13.NAME = c293v14
              c293v1 = c293v9:GetLocalized(c293v11, c293v12, c293v13)
            else
              c293v9 = vT[65]
              c293v9 = c293v9.IsTailorShop
              if c293v9 then
                c293v9 = mMovie
                c293v11 = "/Lotus/Language/Menu/ExitSpecificHubUpperCase"
                c293v12 = false
                c293v13 = { NAME = nil }
                c293v14 = Localize
                c293v15 = "/Lotus/Language/1999/1999PlayerHomeName"
                c293v16 = {}
                c293v14 = c293v14(c293v15, c293v16)
                c293v13.NAME = c293v14
                c293v1 = c293v9:GetLocalized(c293v11, c293v12, c293v13)
              end
            end
          end
        end
        c293v9 = ""
        c293v10 = ""
        c293v11 = ""
        c293v12 = true
        c293v13 = vT[65]
        c293v13 = c293v13.IsInPlainsOrZarimanMission
        if c293v13 then
          c293v13 = vT[132]
          c293v9, c293v10, c293v11, c293v12 = c293v13()
        else
          c293v13 = vT[65]
          c293v13 = c293v13.IsEntratiLabMission
          if c293v13 then
            c293v9 = "/Lotus/Language/Entrati/SolarMapEntratiLabsShortcut"
            c293v10 = "/Lotus/Language/Entrati/MenuReturnToEntratiLabHubDescription"
            c293v11 = "/Lotus/Language/Menu/MenuReturnToShipDescription"
            c293v13 = _T.gQuestMission
            c293v12 = not c293v13
          else
            c293v13 = vT[65]
            c293v13 = c293v13.IsApartment
            if c293v13 then
              c293v9 = "/Lotus/Language/Zariman/ReturnToHubZariman"
              c293v10 = "/Lotus/Language/Zariman/ApartmentReturnToHubZarimanDescription"
              c293v11 = "/Lotus/Language/Menu/MenuReturnToShipDescription"
              c293v13 = vT[1]
              c293v13 = c293v13.HasCompletedQuest
              c293v14 = zarimanQuestKeyChain
              c293v12 = c293v13(c293v14)
            else
              c293v13 = vT[65]
              c293v13 = c293v13.IsTailorShop
              if c293v13 then
                c293v9 = "/Lotus/Language/1999/1999HubName"
                c293v10 = "/Lotus/Language/1999Quest/ObjReturnToMall"
                c293v11 = "/Lotus/Language/Menu/MenuReturnToShipDescription"
                c293v13 = vT[1]
                c293v13 = c293v13.HasCompletedQuest
                c293v14 = hexQuestKeyChain
                c293v12 = c293v13(c293v14)
              end
            end
          end
        end
        c293v13 = ""
        c293v14 = 0
        c293v16 = gGameData
        c293v15 = IsNull
        c293v15 = c293v15(c293v16)
        if not c293v15 then
          c293v15 = gGameData
          c293v13 = c293v15:Name__35e757e1()
          c293v15 = gGameData
          c293v17 = true
          c293v15 = c293v15:GetPlayerShip(c293v17)
          c293v14 = c293v15.mBootLocation
        end
        c293v15 = "/Lotus/Language/Game/RaceOrbiterName"
        c293v16 = 2
        if c293v14 == c293v16 then
          c293v15 = "/Lotus/Language/Zariman/ZarimanApartment"
        else
          c293v16 = 3
          if c293v14 == c293v16 then
            c293v15 = "/Lotus/Language/1999/1999PlayerHomeName"
          end
        end
        c293v16 = string.upper
        c293v17 = mMovie
        c293v20 = false
        c293v15 = c293v16(c293v17:GetLocalized(c293v15, c293v20))
        c293v17 = { Name = nil, Description = "/Lotus/Language/MasteryTest/MenuRankUpDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil, IsEnabled = nil, Update = nil }
        c293v18 = vT[0]
        c293v18 = c293v18.Ternary
        c293v19 = vT[21]
        c293v20 = "/Lotus/Language/MasteryTest/MenuRankUp"
        c293v21 = "/Lotus/Language/MasteryTest/MenuRankUpUnavailable"
        c293v18 = c293v18(c293v19, c293v20, c293v21)
        c293v17.Name = c293v18
        c293v19 = vT[1]
        c293v19 = c293v19.UI_MODE_IN_SPACE_SHIP
        c293v20 = vT[1]
        c293v20 = c293v20.UI_MODE_IN_SPACE_HUB
        c293v18 = {c293v19, c293v20}
        c293v17.DisplayIn = c293v18
        c293v18 = function()
          local c136v0, c136v1, c136v2
          c136v0 = vT[20]
          if c136v0 then
            c136v0 = _T.TennoConHubActive
            if not c136v0 then
              c136v0 = vT[65]
              c136v0 = c136v0.IsApartment
              if not c136v0 then
                c136v0 = _T.InQuestHub
                if not c136v0 then
                  c136v0 = vT[1]
                  c136v0 = c136v0.HasCompletedVorsPrize
                  c136v0 = c136v0()
                  if not c136v0 then
                    c136v0 = false
                    do return c136v0 end
                  end
                  c136v0 = gGameRules
                  c136v2 = gLotusBaseGameRulesType
                  c136v0 = c136v0:IsA(c136v2)
                  if not c136v0 then
                    c136v1 = vT[65]
                    c136v1 = c136v1.QuestCommitment
                    c136v0 = not c136v1
                    do return c136v0 end
                  end
                  c136v0 = gGameRules
                  c136v0 = c136v0:GetMission()
                  c136v0 = c136v0.location
                  c136v1 = vT[67]
                  if c136v0 ~= c136v1 then
                    c136v0 = gGameRules
                    c136v0 = c136v0:GetMission()
                    c136v0 = c136v0.location
                    c136v1 = vT[1]
                    c136v1 = c136v1.SCENARIO_EVENT_HUB_TAG
                    if c136v0 ~= c136v1 then
                      c136v0 = true
                      do return c136v0 end
                    end
                  end
                end
              end
            end
          end
          c136v0 = false
          do return c136v0 end
        end
        c293v17.ShouldDisplay = c293v18
        c293v18 = vT[85]
        c293v17.CallBack = c293v18
        c293v18 = function(c137v0)
          local c137v1
          c137v1 = vT[21]
          do return c137v1 end
        end
        c293v17.IsEnabled = c293v18
        c293v18 = function(c138v0)
          local c138v1, c138v2, c138v3, c138v4, c138v5, c138v6
          c138v1 = vT[21]
          if not c138v1 then
            c138v1 = c138v0.LastCheck
            if c138v1 == nil then
              c138v1 = 0
              c138v0.LastCheck = c138v1
            end
            c138v2 = c138v0.LastCheck
            c138v3 = DeltaTime
            c138v3 = c138v3()
            c138v1 = c138v2 - c138v3
            c138v0.LastCheck = c138v1
            c138v1 = c138v0.LastCheck
            c138v2 = 0
            if c138v1 <= c138v2 then
              c138v1 = 1
              c138v0.LastCheck = c138v1
              c138v2 = gGameData
              c138v1 = IsNull
              c138v1 = c138v1(c138v2)
              if not c138v1 then
                c138v1 = vT[1]
                c138v1 = c138v1.SecondsToFormattedTime
                c138v2 = mMovie
                c138v3 = gGameData
                c138v1 = c138v1(c138v2, c138v3:Name__927457bb())
                c138v2 = mMovie
                c138v5 = c138v0.mClipName
                c138v6 = ".Description.text"
                c138v4 = c138v5 .. c138v6
                c138v5 = "/Lotus/Language/MasteryTest/MenuRankUpUnavailableDescription"
                c138v6 = { TIME = nil }
                c138v6.TIME = c138v1
                c138v2:SetLocalized(c138v4, c138v5, c138v6)
              end
            end
          end
          do return end
        end
        c293v17.Update = c293v18
        c293v18 = { Name = "/Lotus/Language/YareliQuest/MenuTitle", Description = "/Lotus/Language/YareliQuest/MenuDesc", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v20 = vT[1]
        c293v20 = c293v20.UI_MODE_IN_GAME
        c293v19 = {c293v20}
        c293v18.DisplayIn = c293v19
        c293v19 = vT[136]
        c293v18.CallBack = c293v19
        c293v19 = CanShowYareliChallenges
        c293v18.ShouldDisplay = c293v19
        c293v19 = { Name = "/Lotus/Language/Menu/ResumeGameUpperCase", Description = "/Lotus/Language/Menu/ResumeGameDescription", DisplayIn = nil, CallBack = nil }
        c293v21 = vT[1]
        c293v21 = c293v21.UI_MODE_IN_GAME
        c293v20 = {c293v21}
        c293v19.DisplayIn = c293v20
        c293v20 = vT[87]
        c293v19.CallBack = c293v20
        c293v20 = { Name = "/Lotus/Language/OlliesCrashCourse/UI_OlliesCrashCourseMenuRestart", Description = "/Lotus/Language/OlliesCrashCourse/UI_OlliesCrashCourseMenuRestartDesc", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v22 = vT[1]
        c293v22 = c293v22.UI_MODE_IN_GAME
        c293v21 = {c293v22}
        c293v20.DisplayIn = c293v21
        c293v21 = vT[137]
        c293v20.CallBack = c293v21
        c293v21 = function()
          local c139v0
          c139v0 = c293v6
          do return c139v0 end
        end
        c293v20.ShouldDisplay = c293v21
        c293v21 = { Name = "/Lotus/Language/SystemMessages/Challenges_Title", Description = "/Lotus/Language/SystemMessages/Challenges_Desc", DisplayIn = nil, TargetMovie = "Challenges", ShouldDisplay = nil }
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_GAME
        c293v22 = {c293v23}
        c293v21.DisplayIn = c293v22
        c293v22 = function()
          local c140v0, c140v1, c140v3
          c140v1 = vT[65]
          c140v1 = c140v1.QuestCommitment
          c140v0 = not c140v1
          if c140v0 then
            c140v1 = vT[31]
            c140v0 = not c140v1
            if c140v0 then
              c140v1 = vT[24]
              c140v3 = gOrokinGoldenMawAvatarType
              c140v1 = c140v1:IsA(c140v3)
              c140v0 = not c140v1
              if c140v0 then
                c140v1 = _G
                c140v1 = c140v1.StalkerMode
                c140v0 = not c140v1
                if c140v0 then
                  c140v1 = gGameRules
                  c140v3 = gLotusFightingGameRulesType
                  c140v1 = c140v1:IsA(c140v3)
                  c140v0 = not c140v1
                  if c140v0 then
                    c140v1 = c293v6
                    c140v0 = not c140v1
                  end
                end
              end
            end
          end
          do return c140v0 end
        end
        c293v21.ShouldDisplay = c293v22
        c293v22 = { Name = "/Lotus/Language/Menu/MenuAbilities", Description = "/Lotus/Language/Menu/ViewAbilitiesDescription", DisplayIn = nil, TargetMovie = "AbilityProgression", ShouldDisplay = nil }
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_GAME
        c293v23 = {c293v24}
        c293v22.DisplayIn = c293v23
        c293v23 = function()
          local c141v0, c141v1, c141v2, c141v3
          local p11 = 0
          if p11 == 0 then
            c141v1 = vT[65]
            c141v1 = c141v1.IsWarframeAvatar
            if c141v1 then
              p11 = 3
            else
              p11 = 1
            end
          end
          if p11 == 1 then
            c141v1 = vT[141]
            c141v3 = gLotusOperatorAvatarType
            c141v1 = c141v1:IsA(c141v3)
            if c141v1 then
              p11 = 3
            else
              p11 = 2
            end
          end
          if p11 == 2 then
            c141v0 = vT[141]
            c141v2 = Name__e47a507c
            c141v0 = c141v0:IsA(c141v2)
            if not c141v0 then
              p11 = 7
            else
              p11 = 3
            end
          end
          if p11 == 3 then
            c141v1 = _G
            c141v1 = c141v1.StalkerMode
            c141v0 = not c141v1
            if not c141v0 then
              p11 = 7
            else
              p11 = 4
            end
          end
          if p11 == 4 then
            c141v1 = _T.BlockAbilityView
            c141v0 = not c141v1
            if not c141v0 then
              p11 = 7
            else
              p11 = 5
            end
          end
          if p11 == 5 then
            c141v1 = vT[141]
            c141v1 = c141v1()
            c141v0 = not c141v1
            if not c141v0 then
              p11 = 7
            else
              p11 = 6
            end
          end
          if p11 == 6 then
            c141v1 = c293v6
            c141v0 = not c141v1
            p11 = 7
          end
          if p11 == 7 then
            do return c141v0 end
          end
        end
        c293v22.ShouldDisplay = c293v23
        c293v23 = { Name = "/Lotus/Language/Menu/MeleeCombos", Description = "/Lotus/Language/Menu/MeleeCombosDescription", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_GAME
        c293v24 = {c293v25}
        c293v23.DisplayIn = c293v24
        c293v24 = vT[124]
        c293v23.CallBack = c293v24
        c293v24 = function()
          local c142v0, c142v1, c142v3
          c142v0 = vT[65]
          c142v0 = c142v0.IsWarframeAvatar
          if c142v0 then
            c142v0 = c293v7
            if c142v0 then
              c142v1 = _G
              c142v1 = c142v1.StalkerMode
              c142v0 = not c142v1
              if c142v0 then
                c142v1 = gGameRules
                c142v3 = gLotusFightingGameRulesType
                c142v1 = c142v1:IsA(c142v3)
                c142v0 = not c142v1
              end
            end
          end
          do return c142v0 end
        end
        c293v23.ShouldDisplay = c293v24
        c293v24 = { Name = "/Lotus/Language/Menu/MenuStarChart", Description = "/Lotus/Language/Menu/MenuStarChartDescription", DisplayIn = nil, TargetConsole = "SolarMapOrigin", ShouldDisplay = nil }
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_SPACE_SHIP
        c293v27 = vT[1]
        c293v27 = c293v27.UI_MODE_IN_DOJO
        c293v25 = {c293v26, c293v27}
        c293v24.DisplayIn = c293v25
        c293v25 = function()
          local c143v0, c143v1, c143v2, c143v3
          c143v0 = vT[65]
          c143v0 = c143v0.CanFastTravelToConsole
          c143v1 = "SolarMapOrigin"
          c143v2 = vT[65]
          c143v3 = vT[24]
          c143v0 = c143v0(c143v1, c143v2, c143v3)
          do return c143v0 end
        end
        c293v24.ShouldDisplay = c293v25
        c293v25 = { Name = "/Lotus/Language/FastTravel/1999GenericComputerName", Description = "/Lotus/Language/FastTravel/1999HomeComputerDesc", DisplayIn = nil, TargetConsole = nil, ShouldDisplay = nil }
        c293v27 = vT[1]
        c293v27 = c293v27.UI_MODE_IN_SPACE_SHIP
        c293v26 = {c293v27}
        c293v25.DisplayIn = c293v26
        c293v25.TargetConsole = c293v5
        c293v26 = function()
          local c144v0, c144v1, c144v2, c144v3
          c144v0 = c293v5
          c144v0 = c144v0.CanFastTravelToConsole
          c144v1 = c293v5
          c144v2 = vT[65]
          c144v3 = vT[24]
          c144v0 = c144v0(c144v1, c144v2, c144v3)
          do return c144v0 end
        end
        c293v25.ShouldDisplay = c293v26
        c293v26 = { Name = "/Lotus/Language/TauPrequel/TauPrequelFinal/TauMissionSelectAction", Description = "/Lotus/Language/FastTravel/DarkRefractoryDesc", DisplayIn = nil, QueueMovie = "TauMissionSelect", ShouldDisplay = nil }
        c293v28 = vT[1]
        c293v28 = c293v28.UI_MODE_IN_SPACE_SHIP
        c293v27 = {c293v28}
        c293v26.DisplayIn = c293v27
        c293v27 = function()
          local c145v0, c145v1, c145v2, c145v3
          c145v0 = vT[65]
          c145v0 = c145v0.CanFastTravelToConsole
          c145v1 = "SolarMapOrigin"
          c145v2 = vT[65]
          c145v3 = vT[24]
          c145v0 = c145v0(c145v1, c145v2, c145v3)
          if c145v0 then
            c145v0 = vT[1]
            c145v0 = c145v0.HasCompletedOldPeace
            c145v0 = c145v0()
            if not c145v0 then
              c145v2 = gGameData
              c145v1 = IsNull
              c145v1 = c145v1(c145v2)
              c145v0 = not c145v1
              if c145v0 then
                c145v0 = gGameData
                c145v2 = Symbol
                c145v3 = "TauNavOverride"
                c145v0 = c145v0:HasCompletedNodeIntro(c145v2(c145v3))
              end
            end
          end
          do return c145v0 end
        end
        c293v26.ShouldDisplay = c293v27
        c293v27 = { Name = "/Lotus/Language/Menu/MenuFastTravel", DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_DOJO
        c293v28 = {c293v29}
        c293v27.DisplayIn = c293v28
        c293v28 = function()
          local c146v0
          c146v0 = gGameRules
          c146v0 = c146v0:InDojo()
          if c146v0 then
            c146v0 = vT[65]
            c146v0 = c146v0.HaveDojoFastTravelOptions
          end
          do return c146v0 end
        end
        c293v27.ShouldDisplay = c293v28
        c293v29 = { Name = "/Lotus/Language/Dojo/ResearchLabCorpusName", Description = "/Lotus/Language/Dojo/ResearchLabCorpusDescription", TargetConsole = "EnergyLabSpawn", IsADojoConsole = true, ShouldDisplay = nil }
        c293v30 = function()
          local c147v0, c147v1, c147v2, c147v3
          c147v0 = vT[65]
          c147v0 = c147v0.CanFastTravelToConsole
          c147v1 = "EnergyLabSpawn"
          c147v2 = vT[65]
          c147v3 = vT[24]
          c147v0 = c147v0(c147v1, c147v2, c147v3)
          do return c147v0 end
        end
        c293v29.ShouldDisplay = c293v30
        c293v30 = { Name = "/Lotus/Language/Dojo/ResearchLabGrineerName", Description = "/Lotus/Language/Dojo/ResearchLabGrineerDescription", TargetConsole = "ChemLabSpawn", IsADojoConsole = true, ShouldDisplay = nil }
        c293v31 = function()
          local c148v0, c148v1, c148v2, c148v3
          c148v0 = vT[65]
          c148v0 = c148v0.CanFastTravelToConsole
          c148v1 = "ChemLabSpawn"
          c148v2 = vT[65]
          c148v3 = vT[24]
          c148v0 = c148v0(c148v1, c148v2, c148v3)
          do return c148v0 end
        end
        c293v30.ShouldDisplay = c293v31
        c293v31 = { Name = "/Lotus/Language/Dojo/ResearchLabInfestedName", Description = "/Lotus/Language/Dojo/ResearchLabInfestedDescription", TargetConsole = "BioLabSpawn", IsADojoConsole = true, ShouldDisplay = nil }
        c293v32 = function()
          local c149v0, c149v1, c149v2, c149v3
          c149v0 = vT[65]
          c149v0 = c149v0.CanFastTravelToConsole
          c149v1 = "BioLabSpawn"
          c149v2 = vT[65]
          c149v3 = vT[24]
          c149v0 = c149v0(c149v1, c149v2, c149v3)
          do return c149v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v32 = { Name = "/Lotus/Language/Dojo/ResearchLabTennoName", Description = "/Lotus/Language/Dojo/ResearchLabTennoDescription", TargetConsole = "TennoLabSpawn", IsADojoConsole = true, ShouldDisplay = nil }
        c293v33 = function()
          local c150v0, c150v1, c150v2, c150v3
          c150v0 = vT[65]
          c150v0 = c150v0.CanFastTravelToConsole
          c150v1 = "TennoLabSpawn"
          c150v2 = vT[65]
          c150v3 = vT[24]
          c150v0 = c150v0(c150v1, c150v2, c150v3)
          do return c150v0 end
        end
        c293v32.ShouldDisplay = c293v33
        c293v33 = { Name = "/Lotus/Language/Dojo/ResearchLabOrokinName", Description = "/Lotus/Language/Dojo/ResearchLabOrokinDescription", TargetConsole = "OrokinLabSpawn", IsADojoConsole = true, ShouldDisplay = nil }
        c293v34 = function()
          local c151v0, c151v1, c151v2, c151v3
          c151v0 = vT[65]
          c151v0 = c151v0.CanFastTravelToConsole
          c151v1 = "OrokinLabSpawn"
          c151v2 = vT[65]
          c151v3 = vT[24]
          c151v0 = c151v0(c151v1, c151v2, c151v3)
          do return c151v0 end
        end
        c293v33.ShouldDisplay = c293v34
        c293v34 = { Name = "/Lotus/Language/Dojo/VaultTitle", Description = "/Lotus/Language/Dojo/VaultDescription", TargetConsole = "DojoVault", IsADojoConsole = true, ShouldDisplay = nil }
        c293v35 = function()
          local c152v0, c152v1, c152v2, c152v3
          c152v0 = vT[65]
          c152v0 = c152v0.CanFastTravelToConsole
          c152v1 = "DojoVault"
          c152v2 = vT[65]
          c152v3 = vT[24]
          c152v0 = c152v0(c152v1, c152v2, c152v3)
          do return c152v0 end
        end
        c293v34.ShouldDisplay = c293v35
        c293v35 = { Name = "/Lotus/Language/Dojo/DojoRailjackHangarName", Description = "/Lotus/Language/Dojo/DojoRailjackHangarDesc", TargetConsole = "CrewshipLoadout", IsADojoConsole = true, ActionTag = "ConsoleTeleport", ShouldDisplay = nil }
        c293v36 = function()
          local c153v0, c153v1, c153v2, c153v3
          c153v0 = vT[65]
          c153v0 = c153v0.CanFastTravelToConsole
          c153v1 = "CrewshipLoadout"
          c153v2 = vT[65]
          c153v3 = vT[24]
          c153v0 = c153v0(c153v1, c153v2, c153v3)
          do return c153v0 end
        end
        c293v35.ShouldDisplay = c293v36
        c293v36 = { Name = "/Lotus/Language/Dojo/DojoVentKidsRoomName", Description = "/Lotus/Language/Dojo/DojoVentKidsRoomDescriptionShort", TargetConsole = "VentKidsLabSpawn", IsADojoConsole = true, ShouldDisplay = nil }
        c293v37 = function()
          local c154v0, c154v1, c154v2, c154v3
          c154v0 = vT[65]
          c154v0 = c154v0.CanFastTravelToConsole
          c154v1 = "VentKidsLabSpawn"
          c154v2 = vT[65]
          c154v3 = vT[24]
          c154v0 = c154v0(c154v1, c154v2, c154v3)
          do return c154v0 end
        end
        c293v36.ShouldDisplay = c293v37
        c293v37 = { Name = "/Lotus/Language/Dojo/DojoDagathLabName", Description = "/Lotus/Language/Dojo/DojoDagathLabDesc", TargetConsole = "DagathLabSpawn", IsADojoConsole = true, ShouldDisplay = nil }
        c293v38 = function()
          local c155v0, c155v1, c155v2, c155v3
          c155v0 = vT[65]
          c155v0 = c155v0.CanFastTravelToConsole
          c155v1 = "DagathLabSpawn"
          c155v2 = vT[65]
          c155v3 = vT[24]
          c155v0 = c155v0(c155v1, c155v2, c155v3)
          do return c155v0 end
        end
        c293v37.ShouldDisplay = c293v38
        c293v28 = {c293v29, c293v30, c293v31, c293v32, c293v33, c293v34, c293v35, c293v36, c293v37}
        c293v27.Menu = c293v28
        c293v28 = { Name = "/Lotus/Language/Menu/MenuFastTravel", DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_SPACE_HUB
        c293v29 = {c293v30}
        c293v28.DisplayIn = c293v29
        c293v29 = function()
          local c156v0, c156v1
          c156v0 = vT[65]
          c156v0 = c156v0.CanShowHubFTSubMenu
          c156v1 = vT[65]
          c156v0 = c156v0(c156v1)
          do return c156v0 end
        end
        c293v28.ShouldDisplay = c293v29
        c293v30 = { Name = "/Lotus/Language/Menu/MenuStarChart", Description = "/Lotus/Language/Menu/MenuStarChartDescription", TargetConsole = "SolarMapOrigin", ShouldDisplay = nil }
        c293v31 = function()
          local c157v0, c157v1
          c157v1 = vT[65]
          c157v1 = c157v1.InTown
          c157v0 = not c157v1
          if c157v0 then
            c157v0 = vT[65]
            c157v0 = c157v0.HasStarChartFeature
          end
          do return c157v0 end
        end
        c293v30.ShouldDisplay = c293v31
        c293v31 = { Name = "/Lotus/Language/JadeShadows/OrdisOwl", Description = "/Lotus/Language/JadeShadows/JadeShadowsEventNoClanDesc", TargetConsole = "OwlOrdisTalkAction", ShouldDisplay = nil }
        c293v32 = function()
          local c158v0, c158v1, c158v2, c158v3
          c158v0 = vT[65]
          c158v0 = c158v0.CanFastTravelToConsole
          c158v1 = "OwlOrdisTalkAction"
          c158v2 = vT[65]
          c158v3 = vT[24]
          c158v0 = c158v0(c158v1, c158v2, c158v3)
          do return c158v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v32 = { Name = "/Lotus/Language/Game/Teshin", Description = "/Lotus/Language/Menu/MenuConclaveDescription", TargetConsole = "ConclaveSpawn", ShouldDisplay = nil }
        c293v33 = function()
          local c159v0, c159v1, c159v2, c159v3
          c159v0 = vT[65]
          c159v0 = c159v0.CanFastTravelToConsole
          c159v1 = "ConclaveSpawn"
          c159v2 = vT[65]
          c159v3 = vT[24]
          c159v0 = c159v0(c159v1, c159v2, c159v3)
          do return c159v0 end
        end
        c293v32.ShouldDisplay = c293v33
        c293v33 = { Name = "/Lotus/Language/Menu/MenuGotoSimaris", Description = "/Lotus/Language/Menu/MenuGotoSimarisDescription", TargetConsole = "LibrarySpawn", ShouldDisplay = nil }
        c293v34 = function()
          local c160v0, c160v1, c160v2, c160v3
          c160v0 = vT[65]
          c160v0 = c160v0.CanFastTravelToConsole
          c160v1 = "LibrarySpawn"
          c160v2 = vT[65]
          c160v3 = vT[24]
          c160v0 = c160v0(c160v1, c160v2, c160v3)
          do return c160v0 end
        end
        c293v33.ShouldDisplay = c293v34
        c293v34 = { Name = "/Lotus/Language/Menu/DarvoDeal_Title", Description = "/Lotus/Language/Menu/MenuGotoDarvoDescription", TargetConsole = "DarvoStoreAction", ShouldDisplay = nil }
        c293v35 = function()
          local c161v0, c161v1, c161v2, c161v3
          c161v0 = vT[65]
          c161v0 = c161v0.CanFastTravelToConsole
          c161v1 = "DarvoStoreAction"
          c161v2 = vT[65]
          c161v3 = vT[24]
          c161v0 = c161v0(c161v1, c161v2, c161v3)
          do return c161v0 end
        end
        c293v34.ShouldDisplay = c293v35
        c293v35 = { Name = "/Lotus/Language/Dojo/DojoRailjackHangarName", Description = "/Lotus/Language/Dojo/DojoRailjackHangarDesc", TargetConsole = "CrewshipLoadout", ActionTag = "ConsoleTeleport", ShouldDisplay = nil }
        c293v36 = function()
          local c162v0, c162v1, c162v2, c162v4, c162v5
          c162v1 = vT[65]
          c162v1 = c162v1.InTown
          c162v0 = not c162v1
          if c162v0 then
            c162v2 = gRegion
            c162v4 = Symbol
            c162v5 = "CrewshipLoadout"
            c162v1 = IsNull
            c162v1 = c162v1(c162v2:FindFirstTagged(c162v4(c162v5)))
            c162v0 = not c162v1
          end
          do return c162v0 end
        end
        c293v35.ShouldDisplay = c293v36
        c293v36 = { Name = nil, Description = nil, TargetConsole = nil, PreConsoleCallback = nil, ShouldDisplay = nil }
        c293v37 = c293v0.MissionSelectName
        c293v36.Name = c293v37
        c293v37 = c293v0.MissionSelectDesc
        c293v36.Description = c293v37
        c293v37 = c293v0.MissionSelectTag
        c293v36.TargetConsole = c293v37
        c293v37 = function(c163v0)
          local c163v1
          c163v1 = vT[65]
          c163v1 = c163v1.InZarimanTown
          if c163v1 then
            c163v1 = vT[7]
            c163v1 = c163v1.ZarimanNavPreCallback
            c163v1(c163v0)
          end
          do return end
        end
        c293v36.PreConsoleCallback = c293v37
        c293v37 = function()
          local c164v0, c164v1, c164v2, c164v3
          c164v0 = c293v0
          c164v0 = c164v0.CanFastTravelToConsole
          c164v1 = c293v0
          c164v1 = c164v1.MissionSelectTag
          c164v2 = vT[65]
          c164v3 = vT[24]
          c164v0 = c164v0(c164v1, c164v2, c164v3)
          do return c164v0 end
        end
        c293v36.ShouldDisplay = c293v37
        c293v37 = { Name = "/Lotus/Language/FastTravel/1999TailorShopName", Description = "/Lotus/Language/FastTravel/1999TailorShopDesc", TargetConsole = "PersonalQuarterEntrance", ActionTag = "ConsoleTeleport", ShouldDisplay = nil }
        c293v38 = function()
          local c165v0, c165v1, c165v2, c165v3
          c165v0 = vT[65]
          c165v0 = c165v0.CanFastTravelToConsole
          c165v1 = "PersonalQuarterEntrance"
          c165v2 = vT[65]
          c165v3 = vT[24]
          c165v0 = c165v0(c165v1, c165v2, c165v3)
          do return c165v0 end
        end
        c293v37.ShouldDisplay = c293v38
        c293v38 = { Name = "/Lotus/Language/FastTravel/1999FnFName", Description = "/Lotus/Language/FastTravel/1999FnFDesc", TargetConsole = "FablesEntrance", ActionTag = "ConsoleTeleport", ShouldDisplay = nil }
        c293v39 = function()
          local c166v0, c166v1, c166v2, c166v3
          c166v0 = vT[65]
          c166v0 = c166v0.CanFastTravelToConsole
          c166v1 = "FablesEntrance"
          c166v2 = vT[65]
          c166v3 = vT[24]
          c166v0 = c166v0(c166v1, c166v2, c166v3)
          do return c166v0 end
        end
        c293v38.ShouldDisplay = c293v39
        c293v39 = { Name = "/Lotus/Language/CharacterIntro/ArthurName", Description = "/Lotus/Language/FastTravel/ExcaliburDesc", TargetConsole = "SyndicateConversation", ShouldDisplay = nil }
        c293v40 = function()
          local c167v0, c167v1, c167v2, c167v3
          c167v0 = vT[65]
          c167v0 = c167v0.CanFastTravelToConsole
          c167v1 = "SyndicateConversation"
          c167v2 = vT[65]
          c167v3 = vT[24]
          c167v0 = c167v0(c167v1, c167v2, c167v3)
          do return c167v0 end
        end
        c293v39.ShouldDisplay = c293v40
        c293v40 = { Name = nil, Description = nil, TargetConsole = "QuestGiverConversation", ShouldDisplay = nil }
        c293v41 = c293v0.QuestGiverName
        c293v40.Name = c293v41
        c293v41 = c293v0.QuestGiverDesc
        c293v40.Description = c293v41
        c293v41 = function()
          local c168v0, c168v1, c168v2, c168v3
          c168v0 = vT[65]
          c168v0 = c168v0.CanFastTravelToConsole
          c168v1 = "QuestGiverConversation"
          c168v2 = vT[65]
          c168v3 = vT[24]
          c168v0 = c168v0(c168v1, c168v2, c168v3)
          do return c168v0 end
        end
        c293v40.ShouldDisplay = c293v41
        c293v41 = { Name = nil, Description = nil, TargetConsole = "WeaponSmithConversation", ShouldDisplay = nil }
        c293v42 = c293v0.WeaponSmithName
        c293v41.Name = c293v42
        c293v42 = c293v0.WeaponSmithDesc
        c293v41.Description = c293v42
        c293v42 = function()
          local c169v0, c169v1, c169v2, c169v3
          c169v0 = vT[65]
          c169v0 = c169v0.CanFastTravelToConsole
          c169v1 = "WeaponSmithConversation"
          c169v2 = vT[65]
          c169v3 = vT[24]
          c169v0 = c169v0(c169v1, c169v2, c169v3)
          do return c169v0 end
        end
        c293v41.ShouldDisplay = c293v42
        c293v42 = { Name = nil, Description = nil, TargetConsole = "FishmongerConversation", ShouldDisplay = nil }
        c293v43 = c293v0.FishmongerName
        c293v42.Name = c293v43
        c293v43 = c293v0.FishmongerDesc
        c293v42.Description = c293v43
        c293v43 = function()
          local c170v0, c170v1, c170v2, c170v3
          c170v0 = vT[65]
          c170v0 = c170v0.CanFastTravelToConsole
          c170v1 = "FishmongerConversation"
          c170v2 = vT[65]
          c170v3 = vT[24]
          c170v0 = c170v0(c170v1, c170v2, c170v3)
          do return c170v0 end
        end
        c293v42.ShouldDisplay = c293v43
        c293v43 = { Name = nil, Description = nil, TargetConsole = nil, ShouldDisplay = nil }
        c293v44 = c293v0.JewelerName
        c293v43.Name = c293v44
        c293v44 = c293v0.JewelerDesc
        c293v43.Description = c293v44
        c293v44 = vT[0]
        c293v44 = c293v44.Ternary
        c293v45 = vT[65]
        c293v45 = c293v45.InZarimanTown
        c293v46 = "ApartmentConversation"
        c293v47 = "JewelerConversation"
        c293v44 = c293v44(c293v45, c293v46, c293v47)
        c293v43.TargetConsole = c293v44
        c293v44 = function()
          local c171v0, c171v1, c171v2, c171v3
          c171v0 = vT[65]
          c171v0 = c171v0.CanFastTravelToConsole
          c171v1 = "JewelerConversation"
          c171v2 = vT[65]
          c171v3 = vT[24]
          c171v0 = c171v0(c171v1, c171v2, c171v3)
          do return c171v0 end
        end
        c293v43.ShouldDisplay = c293v44
        c293v44 = { Name = nil, Description = nil, TargetConsole = "MaskVendor", ShouldDisplay = nil }
        c293v45 = c293v0.MaskVendorName
        c293v44.Name = c293v45
        c293v45 = c293v0.MaskVendorDesc
        c293v44.Description = c293v45
        c293v45 = function()
          local c172v0, c172v1, c172v2, c172v3
          c172v0 = vT[65]
          c172v0 = c172v0.CanFastTravelToConsole
          c172v1 = "MaskVendor"
          c172v2 = vT[65]
          c172v3 = vT[24]
          c172v0 = c172v0(c172v1, c172v2, c172v3)
          do return c172v0 end
        end
        c293v44.ShouldDisplay = c293v45
        c293v45 = { Name = "/Lotus/Language/Zariman/Yonta", Description = "/Lotus/Language/Zariman/CurrenyExchangeDescription", TargetConsole = "ZarimanArchimedeanNPCTalkAction", ShouldDisplay = nil }
        c293v46 = function()
          local c173v0, c173v1, c173v2, c173v3
          c173v0 = vT[65]
          c173v0 = c173v0.CanFastTravelToConsole
          c173v1 = "ZarimanArchimedeanNPCTalkAction"
          c173v2 = vT[65]
          c173v3 = vT[24]
          c173v0 = c173v0(c173v1, c173v2, c173v3)
          do return c173v0 end
        end
        c293v45.ShouldDisplay = c293v46
        c293v29 = {c293v30, c293v31, c293v32, c293v33, c293v34, c293v35, c293v36, c293v37, c293v38, c293v39, c293v40, c293v41, c293v42, c293v43, c293v44, c293v45}
        c293v30 = { Name = nil, Description = nil, TargetConsole = "BeastMasterVendor", ShouldDisplay = nil }
        c293v31 = c293v0.BeastMasterName
        c293v30.Name = c293v31
        c293v31 = c293v0.BeastMasterDesc
        c293v30.Description = c293v31
        c293v31 = function()
          local c174v0, c174v1, c174v2, c174v3
          c174v0 = vT[65]
          c174v0 = c174v0.CanFastTravelToConsole
          c174v1 = "BeastMasterVendor"
          c174v2 = vT[65]
          c174v3 = vT[24]
          c174v0 = c174v0(c174v1, c174v2, c174v3)
          do return c174v0 end
        end
        c293v30.ShouldDisplay = c293v31
        c293v31 = { Name = "/Lotus/Language/1999Echoes/KayaName", Description = "/Lotus/Language/FastTravel/1999KayaDesc", TargetConsole = "KayaConversation", ShouldDisplay = nil }
        c293v32 = function()
          local c175v0, c175v1, c175v2, c175v3
          c175v0 = vT[65]
          c175v0 = c175v0.CanFastTravelToConsole
          c175v1 = "KayaConversation"
          c175v2 = vT[65]
          c175v3 = vT[24]
          c175v0 = c175v0(c175v1, c175v2, c175v3)
          do return c175v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v32 = { Name = "/Lotus/Language/1999Echoes/MinervaVelemirDuoName", Description = "/Lotus/Language/FastTravel/1999MnVDesc", TargetConsole = "MnVConversation", ShouldDisplay = nil }
        c293v33 = function()
          local c176v0, c176v1, c176v2, c176v3
          c176v0 = vT[65]
          c176v0 = c176v0.CanFastTravelToConsole
          c176v1 = "MnVConversation"
          c176v2 = vT[65]
          c176v3 = vT[24]
          c176v0 = c176v0(c176v1, c176v2, c176v3)
          do return c176v0 end
        end
        c293v32.ShouldDisplay = c293v33
        c293v33 = { Name = "/Lotus/Language/1999Echoes/MinervaVelemirDuoName", Description = "/Lotus/Language/FastTravel/1999MnVDesc", TargetConsole = "MnVConversationRomance", ShouldDisplay = nil }
        c293v34 = function()
          local c177v0, c177v1, c177v2, c177v3
          c177v0 = vT[65]
          c177v0 = c177v0.CanFastTravelToConsole
          c177v1 = "MnVConversationRomance"
          c177v2 = vT[65]
          c177v3 = vT[24]
          c177v0 = c177v0(c177v1, c177v2, c177v3)
          do return c177v0 end
        end
        c293v33.ShouldDisplay = c293v34
        c293v34 = { Name = "/Lotus/Language/1999Echoes/FlareName", Description = "/Lotus/Language/FastTravel/1999FlareDesc", TargetConsole = "FlareConversation", ShouldDisplay = nil }
        c293v35 = function()
          local c178v0, c178v1, c178v2, c178v3
          c178v0 = vT[65]
          c178v0 = c178v0.CanFastTravelToConsole
          c178v1 = "FlareConversation"
          c178v2 = vT[65]
          c178v3 = vT[24]
          c178v0 = c178v0(c178v1, c178v2, c178v3)
          do return c178v0 end
        end
        c293v34.ShouldDisplay = c293v35
        c293v35 = { Name = "/Lotus/Language/Actions/EidolonHunter", Description = "/Lotus/Language/Menu/MenuGoToQuillDescription", TargetConsole = nil, ShouldDisplay = nil }
        c293v35.TargetConsole = c293v2
        c293v36 = function()
          local c179v0, c179v1, c179v2, c179v3
          c179v0 = vT[65]
          c179v0 = c179v0.CanFastTravelToConsole
          c179v1 = "CaveWaypoint"
          c179v2 = vT[65]
          c179v3 = vT[24]
          c179v0 = c179v0(c179v1, c179v2, c179v3)
          do return c179v0 end
        end
        c293v35.ShouldDisplay = c293v36
        c293v36 = { Name = "/Lotus/Language/Actions/MoaPetVendor", Description = "/Lotus/Language/SolarisVenus/MenuGoToMoaVendorDescriptionSV", TargetConsole = "MoaPetVendorConversation", ShouldDisplay = nil }
        c293v37 = function()
          local c180v0, c180v1, c180v2, c180v3
          c180v0 = vT[65]
          c180v0 = c180v0.CanFastTravelToConsole
          c180v1 = "MoaPetVendorConversation"
          c180v2 = vT[65]
          c180v3 = vT[24]
          c180v0 = c180v0(c180v1, c180v2, c180v3)
          do return c180v0 end
        end
        c293v36.ShouldDisplay = c293v37
        c293v37 = { Name = "/Lotus/Language/Actions/KDriveVendor", Description = "/Lotus/Language/SolarisVenus/MenuGoToKDriveVendorDescriptionSV", TargetConsole = "KDrive Vendor", ShouldDisplay = nil }
        c293v38 = function()
          local c181v0, c181v1, c181v2, c181v3
          c181v0 = vT[65]
          c181v0 = c181v0.CanFastTravelToConsole
          c181v1 = "KDrive Vendor"
          c181v2 = vT[65]
          c181v3 = vT[24]
          c181v0 = c181v0(c181v1, c181v2, c181v3)
          do return c181v0 end
        end
        c293v37.ShouldDisplay = c293v38
        c293v38 = { Name = "/Lotus/Language/NokkoColony/NokkoVendorName", Description = "/Lotus/Language/NokkoColony/NokkoVendorFastTravelDesc", TargetConsole = "NokkoVendorConversation", ShouldDisplay = nil }
        c293v39 = function()
          local c182v0, c182v1, c182v2, c182v3
          c182v0 = vT[65]
          c182v0 = c182v0.CanFastTravelToConsole
          c182v1 = "NokkoVendorConversation"
          c182v2 = vT[65]
          c182v3 = vT[24]
          c182v0 = c182v0(c182v1, c182v2, c182v3)
          do return c182v0 end
        end
        c293v38.ShouldDisplay = c293v39
        c293v39 = { Name = "/Lotus/Language/FiveFates/KoumeiStatueHubName", Description = "/Lotus/Language/FiveFates/KoumeiStatueFastTravelText", TargetConsole = "KoumeiAction", ShouldDisplay = nil }
        c293v40 = function()
          local c183v0, c183v1, c183v2, c183v3
          c183v0 = vT[65]
          c183v0 = c183v0.CanFastTravelToConsole
          c183v1 = "KoumeiAction"
          c183v2 = vT[65]
          c183v3 = vT[24]
          c183v0 = c183v0(c183v1, c183v2, c183v3)
          do return c183v0 end
        end
        c293v39.ShouldDisplay = c293v40
        c293v40 = { Name = "/Lotus/Language/Syndicates/Palladino", Description = "/Lotus/Language/FastTravel/PalladinoFastTravelText", TargetConsole = "PalladinoTalk", ShouldDisplay = nil }
        c293v41 = function()
          local c184v0, c184v1, c184v2, c184v3
          c184v0 = vT[65]
          c184v0 = c184v0.CanFastTravelToConsole
          c184v1 = "PalladinoTalk"
          c184v2 = vT[65]
          c184v3 = vT[24]
          c184v0 = c184v0(c184v1, c184v2, c184v3)
          do return c184v0 end
        end
        c293v40.ShouldDisplay = c293v41
        c293v41 = { Name = "/Lotus/Language/RelayReconstruction/ContribRecieverName", Description = "/Lotus/Language/FastTravel/SteelMeridianFastTravelText", TargetConsole = "LaunchSteelMeridianScreen", ShouldDisplay = nil }
        c293v42 = function()
          local c185v0, c185v1, c185v2, c185v3
          c185v0 = vT[65]
          c185v0 = c185v0.CanFastTravelToConsole
          c185v1 = "LaunchSteelMeridianScreen"
          c185v2 = vT[65]
          c185v3 = vT[24]
          c185v0 = c185v0(c185v1, c185v2, c185v3)
          if c185v0 then
            c185v0 = vT[65]
            c185v0 = c185v0.InIronWake
          end
          do return c185v0 end
        end
        c293v41.ShouldDisplay = c293v42
        c293v42 = { Name = "/Lotus/Language/Game/ClemAvatarTitle", Description = "/Lotus/Language/FastTravel/ClemFastTravelText", TargetConsole = "ClemFort", ActionTag = "ConsoleTeleport", ShouldDisplay = nil }
        c293v43 = function()
          local c186v0, c186v1, c186v2, c186v3
          c186v0 = vT[65]
          c186v0 = c186v0.CanFastTravelToConsole
          c186v1 = "ClemFort"
          c186v2 = vT[65]
          c186v3 = vT[24]
          c186v0 = c186v0(c186v1, c186v2, c186v3)
          do return c186v0 end
        end
        c293v42.ShouldDisplay = c293v43
        c293v43 = { Name = "/Lotus/Language/Shadowgrapher/ZorbaName", Description = "/Lotus/Language/FastTravel/ZorbaVendorDesc", TargetConsole = "ZorbaVendorTalkAction", ShouldDisplay = nil }
        c293v44 = function()
          local c187v0, c187v1, c187v2, c187v3
          c187v0 = vT[65]
          c187v0 = c187v0.CanFastTravelToConsole
          c187v1 = "ZorbaVendorTalkAction"
          c187v2 = vT[65]
          c187v3 = vT[24]
          c187v0 = c187v0(c187v1, c187v2, c187v3)
          do return c187v0 end
        end
        c293v43.ShouldDisplay = c293v44
        c293v44 = { Name = "/Lotus/Language/JadeShadowsPart2Mission/JS2MHunhowName", Description = "/Lotus/Language/JadeShadowsPart2Mission/JS2MHunhowDesc", TargetConsole = "HunhowConversation", ShouldDisplay = nil }
        c293v45 = function()
          local c188v0, c188v1, c188v2, c188v3
          c188v0 = vT[65]
          c188v0 = c188v0.CanFastTravelToConsole
          c188v1 = "HunhowConversation"
          c188v2 = vT[65]
          c188v3 = vT[24]
          c188v0 = c188v0(c188v1, c188v2, c188v3)
          do return c188v0 end
        end
        c293v44.ShouldDisplay = c293v45
        c293v45 = { Name = "/Lotus/Language/JadeShadowsPart2Mission/AllyWithRyoku", Description = "/Lotus/Language/JadeShadowsPart2Mission/AllyWithRyokuDesc", TargetConsole = "RyokuConversation", ShouldDisplay = nil }
        c293v46 = function()
          local c189v0, c189v1, c189v2, c189v3
          c189v0 = vT[65]
          c189v0 = c189v0.CanFastTravelToConsole
          c189v1 = "RyokuConversation"
          c189v2 = vT[65]
          c189v3 = vT[24]
          c189v0 = c189v0(c189v1, c189v2, c189v3)
          do return c189v0 end
        end
        c293v45.ShouldDisplay = c293v46
        c293v29[17] = c293v30
        c293v29[18] = c293v31
        c293v29[19] = c293v32
        c293v29[20] = c293v33
        c293v29[21] = c293v34
        c293v29[22] = c293v35
        c293v29[23] = c293v36
        c293v29[24] = c293v37
        c293v29[25] = c293v38
        c293v29[26] = c293v39
        c293v29[27] = c293v40
        c293v29[28] = c293v41
        c293v29[29] = c293v42
        c293v29[30] = c293v43
        c293v29[31] = c293v44
        c293v29[32] = c293v45
        c293v30 = { Name = "/Lotus/Language/JadeShadowsPart2Mission/AllyWithVena", Description = "/Lotus/Language/JadeShadowsPart2Mission/AllyWithVenaDesc", TargetConsole = "VenaConversation", ShouldDisplay = nil }
        c293v46 = function()
          local c190v0, c190v1, c190v2, c190v3
          c190v0 = vT[65]
          c190v0 = c190v0.CanFastTravelToConsole
          c190v1 = "VenaConversation"
          c190v2 = vT[65]
          c190v3 = vT[24]
          c190v0 = c190v0(c190v1, c190v2, c190v3)
          do return c190v0 end
        end
        c293v30.ShouldDisplay = c293v46
        c293v29[33] = c293v30
        c293v28.Menu = c293v29
        c293v29 = { Name = "/Lotus/Language/Entrati/FastTravelMenuNecralisk", DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_SPACE_HUB
        c293v30 = {c293v31}
        c293v29.DisplayIn = c293v30
        c293v30 = function()
          local c191v0, c191v1
          c191v0 = vT[65]
          c191v0 = c191v0.CanShowNecraliskSubMenu
          c191v1 = vT[65]
          c191v0 = c191v0(c191v1)
          do return c191v0 end
        end
        c293v29.ShouldDisplay = c293v30
        c293v31 = { Name = "/Lotus/Language/InfestedMicroplanet/HivemindFishmonger", Description = "/Lotus/Language/InfestedMicroplanet/HivemindFishmongerDescription", TargetConsole = "FishmongerConversation" }
        c293v32 = { Name = "/Lotus/Language/InfestedMicroplanet/HivemindProspector", Description = "/Lotus/Language/Menu/MenuGoToJewelerDescription", TargetConsole = "JewelerConversation" }
        c293v33 = { Name = "/Lotus/Language/InfestedMicroplanet/HivemindBounties", Description = "/Lotus/Language/InfestedMicroplanet/HivemindBountiesDescription", TargetConsole = "QuestGiverConversation" }
        c293v34 = { Name = "/Lotus/Language/InfestedMicroplanet/HivemindGunsmith", Description = "/Lotus/Language/InfestedMicroplanet/HivemindGunsmithDescription", TargetConsole = "WeaponSmithConversation" }
        c293v35 = { Name = "/Lotus/Language/InfestedMicroplanet/HivemindTokenVendor", Description = "/Lotus/Language/InfestedMicroplanet/HivemindTokenVendorDescription", TargetConsole = "HivemindTokenVendor" }
        c293v36 = { Name = "/Lotus/Language/InfestedMicroplanet/HivemindPetVendor", Description = "/Lotus/Language/Menu/MenuGoToBeastMasterDescription", TargetConsole = "HivemindPetVendor" }
        c293v37 = { Name = "/Lotus/Language/InfestedMicroplanet/HivemindMechs", Description = "/Lotus/Language/InfestedMicroplanet/HivemindMechsDescription", TargetConsole = "NecraloidSyndicateConversation", ShouldDisplay = nil }
        c293v38 = function()
          local c192v0, c192v1, c192v2, c192v3
          c192v0 = vT[65]
          c192v0 = c192v0.CanFastTravelToConsole
          c192v1 = "NecraloidSyndicateConversation"
          c192v2 = vT[65]
          c192v3 = vT[24]
          c192v0 = c192v0(c192v1, c192v2, c192v3)
          do return c192v0 end
        end
        c293v37.ShouldDisplay = c293v38
        c293v30 = {c293v31, c293v32, c293v33, c293v34, c293v35, c293v36, c293v37}
        c293v29.Menu = c293v30
        c293v30 = { Name = "/Lotus/Language/Entrati/FastTravelMenuSanctum", DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_SPACE_HUB
        c293v31 = {c293v32}
        c293v30.DisplayIn = c293v31
        c293v31 = function()
          local c193v0, c193v1
          c193v0 = vT[65]
          c193v0 = c193v0.CanShowEntratiLabSubMenu
          c193v1 = vT[65]
          c193v0 = c193v0(c193v1)
          do return c193v0 end
        end
        c293v30.ShouldDisplay = c293v31
        c293v32 = { Name = "/Lotus/Language/Entrati/Fibonacci", Description = "/Lotus/Language/Entrati/FibonacciFastTravelDesc", TargetConsole = "FibinacciQuestGiverConversation" }
        c293v33 = { Name = "/Lotus/Language/Entrati/Tagfer", Description = "/Lotus/Language/Entrati/TagferFastTravelDesc", TargetConsole = "TagferTalkAction" }
        c293v34 = { Name = "/Lotus/Language/Entrati/Bird3", Description = "/Lotus/Language/Entrati/Bird3FastTravelDesc", TargetConsole = "EntratiLabBird3TalkAction" }
        c293v35 = { Name = "/Lotus/Language/EntratiLab/EntratiGeneral/HumanLoid", Description = "/Lotus/Language/Entrati/LoidFastTravelDesc", TargetConsole = "EntratiLabLoidTalkAction" }
        c293v36 = { Name = "/Lotus/Language/Bosses/Necraloid", Description = "/Lotus/Language/Entrati/NecraloidFastTravelDesc", TargetConsole = "EntratiLabNecraloidTalkAction", ShouldDisplay = nil }
        c293v37 = function()
          local c194v0, c194v1, c194v2, c194v3
          c194v0 = vT[65]
          c194v0 = c194v0.CanFastTravelToConsole
          c194v1 = "EntratiLabNecraloidTalkAction"
          c194v2 = vT[65]
          c194v3 = vT[24]
          c194v0 = c194v0(c194v1, c194v2, c194v3)
          do return c194v0 end
        end
        c293v36.ShouldDisplay = c293v37
        c293v37 = { Name = "/Lotus/Language/TauPrequel/TauPrequelFinal/TauMissionSelectAction", Description = "/Lotus/Language/Entrati/DarkRefractoryFastTravelDesc", TargetConsole = "Tau", ShouldDisplay = nil }
        c293v38 = function()
          local c195v0, c195v1, c195v2, c195v3
          c195v0 = vT[65]
          c195v0 = c195v0.CanFastTravelToConsole
          c195v1 = "Tau"
          c195v2 = vT[65]
          c195v3 = vT[24]
          c195v0 = c195v0(c195v1, c195v2, c195v3)
          do return c195v0 end
        end
        c293v37.ShouldDisplay = c293v38
        c293v31 = {c293v32, c293v33, c293v34, c293v35, c293v36, c293v37}
        c293v30.Menu = c293v31
        c293v31 = { Name = "/Lotus/Language/CircleOfHell/FastTravelMenuCathedrale", DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_SPACE_HUB
        c293v32 = {c293v33}
        c293v31.DisplayIn = c293v32
        c293v32 = function()
          local c196v0, c196v1
          c196v0 = vT[65]
          c196v0 = c196v0.CanShowEntratiLabSubMenu
          c196v1 = vT[65]
          c196v0 = c196v0(c196v1)
          if c196v0 then
            c196v0 = vT[1]
            c196v0 = c196v0.HasCompletedOldPeace
            c196v0 = c196v0()
          end
          do return c196v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v33 = { Name = "/Lotus/Language/CircleOfHell/LaCathedraleFastTravelTitle", Description = "/Lotus/Language/CircleOfHell/LaCathedraleFastTravelDesc", TargetConsole = "CathedraleEntrance", ActionTag = "ConsoleTeleport", ShouldDisplay = nil }
        c293v34 = function()
          local c197v0, c197v1, c197v2, c197v3
          c197v0 = vT[65]
          c197v0 = c197v0.CanFastTravelToConsole
          c197v1 = "CathedraleEntrance"
          c197v2 = vT[65]
          c197v3 = vT[24]
          c197v0 = c197v0(c197v1, c197v2, c197v3)
          do return c197v0 end
        end
        c293v33.ShouldDisplay = c293v34
        c293v34 = { Name = "/Lotus/Language/CircleOfHell/MarieName", Description = "/Lotus/Language/CircleOfHell/MarieFastTravelDesc", TargetConsole = nil, CallBack = nil }
        c293v35 = vT[0]
        c293v35 = c293v35.Ternary
        c293v37 = "MarieNpcTalkAction"
        c293v38 = nil
        c293v35 = c293v35(c293v8, c293v37, c293v38)
        c293v34.TargetConsole = c293v35
        c293v35 = vT[0]
        c293v35 = c293v35.Ternary
        c293v37 = nil
        c293v38 = function()
          local c198v0, c198v1
          c198v0 = vT[0]
          c198v0 = c198v0.ShowMessage
          c198v1 = "/Lotus/Language/OldPeace/CathedralTeleportOperatorBlocked"
          c198v0(c198v1)
          do return end
        end
        c293v35 = c293v35(c293v8, c293v37, c293v38)
        c293v34.CallBack = c293v35
        c293v35 = { Name = "/Lotus/Language/CircleOfHell/LyonName", Description = "/Lotus/Language/CircleOfHell/LyonFastTravelDesc", TargetConsole = nil, CallBack = nil }
        c293v36 = vT[0]
        c293v36 = c293v36.Ternary
        c293v38 = "LyonNpcTalkAction"
        c293v39 = nil
        c293v36 = c293v36(c293v8, c293v38, c293v39)
        c293v35.TargetConsole = c293v36
        c293v36 = vT[0]
        c293v36 = c293v36.Ternary
        c293v38 = nil
        c293v39 = function()
          local c199v0, c199v1
          c199v0 = vT[0]
          c199v0 = c199v0.ShowMessage
          c199v1 = "/Lotus/Language/OldPeace/CathedralTeleportOperatorBlocked"
          c199v0(c199v1)
          do return end
        end
        c293v36 = c293v36(c293v8, c293v38, c293v39)
        c293v35.CallBack = c293v36
        c293v36 = { Name = "/Lotus/Language/CircleOfHell/RoatheName", Description = "/Lotus/Language/CircleOfHell/RoatheFastTravelDesc", TargetConsole = nil, CallBack = nil }
        c293v37 = vT[0]
        c293v37 = c293v37.Ternary
        c293v39 = "RoatheNpcTalkAction"
        c293v40 = nil
        c293v37 = c293v37(c293v8, c293v39, c293v40)
        c293v36.TargetConsole = c293v37
        c293v37 = vT[0]
        c293v37 = c293v37.Ternary
        c293v39 = nil
        c293v40 = function()
          local c200v0, c200v1
          c200v0 = vT[0]
          c200v0 = c200v0.ShowMessage
          c200v1 = "/Lotus/Language/OldPeace/CathedralTeleportOperatorBlocked"
          c200v0(c200v1)
          do return end
        end
        c293v37 = c293v37(c293v8, c293v39, c293v40)
        c293v36.CallBack = c293v37
        c293v32 = {c293v33, c293v34, c293v35, c293v36}
        c293v31.Menu = c293v32
        c293v32 = { Name = nil, Description = nil, DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v33 = mMovie
        c293v35 = "/Lotus/Language/FastTravel/HostShipReturnToBoot"
        c293v36 = false
        c293v37 = { BOOT = nil }
        c293v37.BOOT = c293v15
        c293v33 = c293v33:GetLocalized(c293v35, c293v36, c293v37)
        c293v32.Name = c293v33
        c293v33 = mMovie
        c293v35 = "/Lotus/Language/FastTravel/HostShipReturnToBoot"
        c293v36 = false
        c293v37 = { BOOT = nil }
        c293v37.BOOT = c293v15
        c293v33 = c293v33:GetLocalized(c293v35, c293v36, c293v37)
        c293v32.Description = c293v33
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_SPACE_SHIP
        c293v33 = {c293v34}
        c293v32.DisplayIn = c293v33
        c293v33 = function()
          local c201v0
          c201v0 = vT[65]
          c201v0 = c201v0.OnHostsShip
          do return c201v0 end
        end
        c293v32.ShouldDisplay = c293v33
        c293v33 = function()
          local c202v0, c202v1
          c202v0 = Engine.Disconnect
          c202v1 = true
          c202v0(c202v1)
          do return end
        end
        c293v32.CallBack = c293v33
        c293v16 = {c293v17, c293v18, c293v19, c293v20, c293v21, c293v22, c293v23, c293v24, c293v25, c293v26, c293v27, c293v28, c293v29, c293v30, c293v31, c293v32}
        c293v17 = { Name = "/Lotus/Language/Menu/MenuLoadout", Description = "/Lotus/Language/Menu/MenuLoadoutDescription", DisplayIn = nil, TargetConsole = "Arsenal", ShouldDisplay = nil }
        c293v19 = vT[1]
        c293v19 = c293v19.UI_MODE_IN_GAME
        c293v18 = {c293v19}
        c293v17.DisplayIn = c293v18
        c293v18 = function()
          local c203v0, c203v1, c203v2, c203v3
          c203v1 = gGameRules
          c203v0 = IsNull
          c203v0 = c203v0(c203v1)
          if not c203v0 then
            c203v0 = gGameRules
            c203v2 = WeakResource
            c203v3 = "/Lotus/Types/GameRules/KahlPhotoBoothGameRules"
            c203v0 = c203v0:IsA(c203v2(c203v3))
            if not c203v0 then
              c203v0 = Engine.IsMobile
              c203v0 = c203v0()
              if not c203v0 then
                c203v0 = _T.InSimulacrum
                if c203v0 then
                  c203v1 = _T.ArsenalOverride
                  if c203v1 ~= nil then
                    c203v0 = false
                  else
                    c203v0 = true
                  end
                end
                do return c203v0 end
              end
              c203v0 = gRegion
              c203v2 = Symbol
              c203v3 = c293v4
              c203v0 = c203v0:FindFirstTagged(c203v2(c203v3))
              c203v1 = vT[65]
              c203v1 = c203v1.HasArsenalFeature
              if c203v1 then
                c203v2 = IsNull
                c203v2 = c203v2(c203v0)
                c203v1 = not c203v2
                if c203v1 then
                  c203v1 = c203v0:IsEnabled()
                end
              end
              c203v2 = c203v1
              if c203v2 then
                c203v2 = _T.InSimulacrum
                if c203v2 then
                  c203v3 = _T.ArsenalOverride
                  if c203v3 ~= nil then
                    c203v2 = false
                  else
                    c203v2 = true
                  end
                end
              end
              do return c203v2 end
            end
          end
          c203v0 = false
          do return c203v0 end
        end
        c293v17.ShouldDisplay = c293v18
        c293v18 = { Name = "/Lotus/Language/Menu/MenuOperator", Description = "/Lotus/Language/Menu/MenuFocusDescription", DisplayIn = nil, TargetConsole = "TennoWay", ActionTag = "ConsoleActivate", ForceOperator = true, ShouldDisplay = nil }
        c293v20 = vT[1]
        c293v20 = c293v20.UI_MODE_IN_GAME
        c293v19 = {c293v20}
        c293v18.DisplayIn = c293v19
        c293v19 = function()
          local c204v0, c204v1, c204v2, c204v3
          c204v1 = gGameRules
          c204v0 = IsNull
          c204v0 = c204v0(c204v1)
          if not c204v0 then
            c204v0 = gGameRules
            c204v2 = WeakResource
            c204v3 = "/Lotus/Types/GameRules/KahlPhotoBoothGameRules"
            c204v0 = c204v0:IsA(c204v2(c204v3))
            if not c204v0 then
              c204v0 = _T.InSimulacrum
              if c204v0 then
                c204v1 = _T.ArsenalOverride
                if c204v1 ~= nil then
                  c204v0 = false
                else
                  c204v0 = true
                end
              end
              do return c204v0 end
            end
          end
          c204v0 = false
          do return c204v0 end
        end
        c293v18.ShouldDisplay = c293v19
        c293v19 = { Name = "/Lotus/Language/Veilbreaker/KahlCustomizations", DisplayIn = nil, TargetConsole = "Arsenal", ShouldDisplay = nil }
        c293v21 = vT[1]
        c293v21 = c293v21.UI_MODE_IN_GAME
        c293v20 = {c293v21}
        c293v19.DisplayIn = c293v20
        c293v20 = function()
          local c205v0, c205v1, c205v2, c205v3
          c205v1 = gGameRules
          c205v0 = IsNull
          c205v0 = c205v0(c205v1)
          if not c205v0 then
            c205v0 = gGameRules
            c205v2 = WeakResource
            c205v3 = "/Lotus/Types/GameRules/KahlPhotoBoothGameRules"
            c205v0 = c205v0:IsA(c205v2(c205v3))
            if c205v0 then
              c205v0 = _T.InSimulacrum
              do return c205v0 end
            end
          end
          c205v0 = false
          do return c205v0 end
        end
        c293v19.ShouldDisplay = c293v20
        c293v20 = { Name = "/Lotus/Language/Menu/Store_Extras", DisplayIn = nil, Menu = nil, ShouldDisplay = nil }
        c293v22 = vT[1]
        c293v22 = c293v22.UI_MODE_IN_SPACE_SHIP
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_DOJO
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_SPACE_HUB
        c293v21 = {c293v22, c293v23, c293v24}
        c293v20.DisplayIn = c293v21
        c293v21 = {}
        c293v22 = { Name = "/Lotus/Language/Menu/MenuLoadout", Description = "/Lotus/Language/Menu/MenuLoadoutDescription", DisplayIn = nil, TargetConsole = nil, ShouldDisplay = nil }
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_SPACE_SHIP
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_SPACE_HUB
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_DOJO
        c293v23 = {c293v24, c293v25, c293v26}
        c293v22.DisplayIn = c293v23
        c293v22.TargetConsole = c293v4
        c293v23 = function()
          local c206v0, c206v1, c206v2, c206v3, c206v4, c206v5
          c206v0 = Engine.IsMobile
          c206v0 = c206v0()
          if not c206v0 then
            c206v0 = vT[7]
            c206v0 = c206v0.CanFastTravelToConsole
            c206v1 = c293v4
            c206v2 = vT[65]
            c206v3 = vT[24]
            c206v0 = c206v0(c206v1, c206v2, c206v3)
            do return c206v0 end
          end
          c206v0 = gRegion
          c206v2 = Symbol
          c206v3 = c293v4
          c206v0 = c206v0:FindFirstTagged(c206v2(c206v3))
          c206v1 = vT[65]
          c206v1 = c206v1.HasArsenalFeature
          if c206v1 then
            c206v2 = IsNull
            c206v2 = c206v2(c206v0)
            c206v1 = not c206v2
            if c206v1 then
              c206v1 = c206v0:IsEnabled()
            end
          end
          c206v2 = c206v1
          if c206v2 then
            c206v2 = vT[7]
            c206v2 = c206v2.CanFastTravelToConsole
            c206v3 = c293v4
            c206v4 = vT[65]
            c206v5 = vT[24]
            c206v2 = c206v2(c206v3, c206v4, c206v5)
          end
          do return c206v2 end
        end
        c293v22.ShouldDisplay = c293v23
        c293v23 = { Name = "/Lotus/Language/Menu/MenuLoadout", Description = "/Lotus/Language/Menu/MenuLoadoutDescription", DisplayIn = nil, TargetConsole = "ArsenalRelay", ShouldDisplay = nil }
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_SPACE_HUB
        c293v24 = {c293v25}
        c293v23.DisplayIn = c293v24
        c293v24 = function()
          local c207v0, c207v1, c207v2, c207v3
          c207v0 = Engine.IsMobile
          c207v0 = c207v0()
          if not c207v0 then
            c207v0 = vT[65]
            c207v0 = c207v0.HasArsenalFeature
            if c207v0 then
              c207v0 = gMatchingService
              c207v0 = c207v0:Name__4673aca8()
            end
            do return c207v0 end
          end
          c207v0 = gRegion
          c207v2 = Symbol
          c207v3 = c293v4
          c207v0 = c207v0:FindFirstTagged(c207v2(c207v3))
          c207v1 = vT[65]
          c207v1 = c207v1.HasArsenalFeature
          if c207v1 then
            c207v2 = IsNull
            c207v2 = c207v2(c207v0)
            c207v1 = not c207v2
            if c207v1 then
              c207v1 = c207v0:IsEnabled()
            end
          end
          c207v2 = c207v1
          if c207v2 then
            c207v2 = gMatchingService
            c207v2 = c207v2:Name__4673aca8()
          end
          do return c207v2 end
        end
        c293v23.ShouldDisplay = c293v24
        c293v24 = { Name = "/Lotus/Language/Menu/MenuOperator", Description = "/Lotus/Language/Menu/MenuFocusDescription", DisplayIn = nil, TargetConsole = "TennoWay", ActionTag = "ConsoleActivate", ForceOperator = true, ShouldDisplay = nil }
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_SPACE_HUB
        c293v27 = vT[1]
        c293v27 = c293v27.UI_MODE_IN_SPACE_SHIP
        c293v25 = {c293v26, c293v27}
        c293v24.DisplayIn = c293v25
        c293v25 = function()
          local c208v0, c208v1
          local p4 = 0
          if p4 == 0 then
            c208v1 = vT[65]
            c208v1 = c208v1.InTown
            if c208v1 then
              p4 = 2
            else
              p4 = 1
            end
          end
          if p4 == 1 then
            c208v0 = vT[65]
            c208v0 = c208v0.IsApartment
            if not c208v0 then
              p4 = 3
            else
              p4 = 2
            end
          end
          if p4 == 2 then
            c208v0 = vT[1]
            c208v0 = c208v0.HasCompletedQuest
            c208v1 = secondDreamQuest
            c208v0 = c208v0(c208v1)
            p4 = 3
          end
          if p4 == 3 then
            do return c208v0 end
          end
        end
        c293v24.ShouldDisplay = c293v25
        c293v25 = { Name = "/Lotus/Language/Menu/MenuFoundry", Description = "/Lotus/Language/Menu/MenuFoundryDescription", DisplayIn = nil, TargetConsole = "Crafting", ShouldDisplay = nil }
        c293v27 = vT[1]
        c293v27 = c293v27.UI_MODE_IN_SPACE_SHIP
        c293v26 = {c293v27}
        c293v25.DisplayIn = c293v26
        c293v26 = function()
          local c209v0, c209v1, c209v2, c209v3
          c209v0 = vT[65]
          c209v0 = c209v0.CanFastTravelToConsole
          c209v1 = "Crafting"
          c209v2 = vT[65]
          c209v3 = vT[24]
          c209v0 = c209v0(c209v1, c209v2, c209v3)
          do return c209v0 end
        end
        c293v25.ShouldDisplay = c293v26
        c293v26 = { Name = "/Lotus/Language/Menu/GeneticLab", Description = "/Lotus/Language/Menu/GeneticLabDescription", DisplayIn = nil, TargetConsole = "GeneticLab", ShouldDisplay = nil }
        c293v28 = vT[1]
        c293v28 = c293v28.UI_MODE_IN_SPACE_SHIP
        c293v27 = {c293v28}
        c293v26.DisplayIn = c293v27
        c293v27 = function()
          local c210v0, c210v1
          c210v0 = vT[65]
          c210v0 = c210v0.HasGeneticFoundryFeature
          if c210v0 then
            c210v1 = vT[65]
            c210v1 = c210v1.IsApartment
            c210v0 = not c210v1
          end
          do return c210v0 end
        end
        c293v26.ShouldDisplay = c293v27
        c293v27 = { Name = "/Lotus/Language/Alchemy/HelminthSquadTitle", Description = "/Lotus/Language/Alchemy/FastTravelDesc", DisplayIn = nil, PreConsoleCallback = nil, TargetConsole = "HelminthChair", ShouldDisplay = nil }
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_SPACE_SHIP
        c293v28 = {c293v29}
        c293v27.DisplayIn = c293v28
        c293v28 = function(c211v0)
          local c211v1, c211v2
          c211v1 = _T
          c211v2 = true
          c211v1.SkipCystOption = c211v2
          do return end
        end
        c293v27.PreConsoleCallback = c293v28
        c293v28 = function()
          local c212v0, c212v1, c212v2, c212v3
          c212v0 = vT[65]
          c212v0 = c212v0.CanFastTravelToConsole
          c212v1 = "HelminthChair"
          c212v2 = vT[65]
          c212v3 = vT[24]
          c212v0 = c212v0(c212v1, c212v2, c212v3)
          do return c212v0 end
        end
        c293v27.ShouldDisplay = c293v28
        c293v28 = { Name = "/Lotus/Language/Menu/Loadout_Inventory", Description = "/Lotus/Language/Menu/MenuInventoryDescription", DisplayIn = nil, QueueMovie = "Inventory" }
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_SPACE_SHIP
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_DOJO
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_SPACE_HUB
        c293v29 = {c293v30, c293v31, c293v32}
        c293v28.DisplayIn = c293v29
        c293v29 = { Name = "/Lotus/Language/Relics/Menu_Projections", Description = "/Lotus/Language/Relics/ProjectionManager_Desc", DisplayIn = nil, TargetConsole = "Projections", ShouldDisplay = nil }
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_SPACE_SHIP
        c293v30 = {c293v31}
        c293v29.DisplayIn = c293v30
        c293v30 = function()
          local c213v0, c213v1, c213v2, c213v3
          c213v0 = vT[65]
          c213v0 = c213v0.CanFastTravelToConsole
          c213v1 = "Projections"
          c213v2 = vT[65]
          c213v3 = vT[24]
          c213v0 = c213v0(c213v1, c213v2, c213v3)
          do return c213v0 end
        end
        c293v29.ShouldDisplay = c293v30
        c293v30 = { Name = "/Lotus/Language/Menu/ShowCollection", Description = "/Lotus/Language/Menu/ModDescription", DisplayIn = nil, TargetConsole = "Mods", ShouldDisplay = nil }
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_SPACE_SHIP
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_SPACE_HUB
        c293v31 = {c293v32, c293v33}
        c293v30.DisplayIn = c293v31
        c293v31 = function()
          local c214v0, c214v1, c214v2, c214v3
          c214v0 = vT[65]
          c214v0 = c214v0.CanFastTravelToConsole
          c214v1 = "Mods"
          c214v2 = vT[65]
          c214v3 = vT[24]
          c214v0 = c214v0(c214v1, c214v2, c214v3)
          do return c214v0 end
        end
        c293v30.ShouldDisplay = c293v31
        c293v31 = { Name = "/Lotus/Language/Menu/FoundryEnhancements", Description = "/Lotus/Language/Arcanes/ArcaneDescription", DisplayIn = nil, TargetConsole = "ArcaneConsole", ShouldDisplay = nil }
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_SPACE_SHIP
        c293v32 = {c293v33}
        c293v31.DisplayIn = c293v32
        c293v32 = function()
          local c215v0
          c215v0 = vT[65]
          c215v0 = c215v0.ArcaneConsoleEnabled
          do return c215v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v32 = { Name = "/Lotus/Language/Menu/FoundryEnhancements", Description = "/Lotus/Language/Arcanes/ArcaneDescription", DisplayIn = nil, TargetMovie = "ArcaneManager", ShouldDisplay = nil }
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_SPACE_HUB
        c293v35 = vT[1]
        c293v35 = c293v35.UI_MODE_IN_DOJO
        c293v33 = {c293v34, c293v35}
        c293v32.DisplayIn = c293v33
        c293v33 = function()
          local c216v0, c216v1, c216v2
          c216v0 = vT[1]
          c216v0 = c216v0.PlayerOwnsArcanes
          c216v1 = WeakResource
          c216v2 = "/Lotus/Types/Game/BaseCosmeticEnhancer"
          c216v0 = c216v0(c216v1(c216v2))
          if not c216v0 then
            c216v0 = vT[1]
            c216v0 = c216v0.PlayerOwnsArcanes
            c216v1 = WeakResource
            c216v2 = "/Lotus/Types/Game/OperatorCosmeticEnhancer"
            c216v0 = c216v0(c216v1(c216v2))
          end
          do return c216v0 end
        end
        c293v32.ShouldDisplay = c293v33
        c293v33 = { Name = "/Lotus/Language/Menu/ShowCollection", Description = "/Lotus/Language/Menu/ModDescription", DisplayIn = nil, QueueMovie = "DiegeticArtifactCards", ShouldDisplay = nil }
        c293v35 = vT[1]
        c293v35 = c293v35.UI_MODE_IN_DOJO
        c293v34 = {c293v35}
        c293v33.DisplayIn = c293v34
        c293v34 = function()
          local c217v0
          c217v0 = vT[65]
          c217v0 = c217v0.HasModsFeature
          do return c217v0 end
        end
        c293v33.ShouldDisplay = c293v34
        c293v34 = { Name = "/Lotus/Language/Menu/MenuAbilities", Description = "/Lotus/Language/Menu/ViewAbilitiesDescription", DisplayIn = nil, TargetMovie = "AbilityProgression", ShouldDisplay = nil }
        c293v36 = vT[1]
        c293v36 = c293v36.UI_MODE_IN_SPACE_SHIP
        c293v37 = vT[1]
        c293v37 = c293v37.UI_MODE_IN_SPACE_HUB
        c293v35 = {c293v36, c293v37}
        c293v34.DisplayIn = c293v35
        c293v35 = function()
          local c218v0
          c218v0 = vT[65]
          c218v0 = c218v0.IsWarframeAvatar
          do return c218v0 end
        end
        c293v34.ShouldDisplay = c293v35
        c293v35 = { Name = "/Lotus/Language/Menu/Loadout_Spectres", Description = "/Lotus/Language/Menu/SpectresDescription", DisplayIn = nil, TargetMovie = "Spectres", ShouldDisplay = nil }
        c293v37 = vT[1]
        c293v37 = c293v37.UI_MODE_IN_SPACE_SHIP
        c293v38 = vT[1]
        c293v38 = c293v38.UI_MODE_IN_SPACE_HUB
        c293v36 = {c293v37, c293v38}
        c293v35.DisplayIn = c293v36
        c293v36 = function()
          local c219v0
          c219v0 = vT[65]
          c219v0 = c219v0.HasArsenalFeature
          if c219v0 then
            c219v0 = gGameData
            c219v0 = c219v0:Name__f0be5f72()
          end
          do return c219v0 end
        end
        c293v35.ShouldDisplay = c293v36
        c293v36 = { Name = nil, Description = nil, DisplayIn = nil, Menu = nil, ShouldDisplay = nil }
        c293v38 = vT[65]
        c293v38 = c293v38.IsTailorShop
        if c293v38 then
          c293v37 = "/Lotus/Language/1999/1999PlayerHomeName"
        else
          c293v37 = "/Lotus/Language/Menu/DecorateShip"
        end
        c293v36.Name = c293v37
        c293v38 = vT[65]
        c293v38 = c293v38.IsTailorShop
        if c293v38 then
          c293v37 = "/Lotus/Language/1999/DecorateTailorShopDescription"
        else
          c293v37 = "/Lotus/Language/Menu/MenuDecorateShipDescription"
        end
        c293v36.Description = c293v37
        c293v38 = vT[1]
        c293v38 = c293v38.UI_MODE_IN_SPACE_SHIP
        c293v37 = {c293v38}
        c293v36.DisplayIn = c293v37
        c293v37 = {}
        c293v38 = { Name = "/Lotus/Language/Dojo/DecorationMode", Description = "/Lotus/Language/Dojo/DecorationModeDesc", CallBack = nil }
        c293v39 = vT[105]
        c293v38.CallBack = c293v39
        c293v39 = { Name = nil, Description = nil, CallBack = nil }
        c293v41 = vT[65]
        c293v41 = c293v41.IsTailorShop
        if c293v41 then
          c293v40 = "/Lotus/Language/1999/CustomizeTailorShopTitle"
        else
          c293v40 = "/Lotus/Language/Menu/CustomizeOrbiterTitle"
        end
        c293v39.Name = c293v40
        c293v41 = vT[65]
        c293v41 = c293v41.IsTailorShop
        if c293v41 then
          c293v40 = "/Lotus/Language/1999/CustomizeTailorShopDesc"
        else
          c293v40 = "/Lotus/Language/Menu/CustomizeShipInteriorDesc"
        end
        c293v39.Description = c293v40
        c293v40 = vT[111]
        c293v39.CallBack = c293v40
        c293v40 = { Name = "/Lotus/Language/Menu/Global_ProductCategory_Ships", Description = "/Lotus/Language/Menu/CustomizeShipExteriorDesc", CallBack = nil }
        c293v41 = vT[110]
        c293v40.CallBack = c293v41
        c293v37 = {c293v38, c293v39, c293v40}
        c293v36.Menu = c293v37
        c293v37 = function()
          local c220v0, c220v1
          c220v0 = vT[65]
          c220v0 = c220v0.CanShowDecorateSubMenu
          c220v1 = vT[65]
          c220v0 = c220v0(c220v1)
          do return c220v0 end
        end
        c293v36.ShouldDisplay = c293v37
        c293v21 = {c293v22, c293v23, c293v24, c293v25, c293v26, c293v27, c293v28, c293v29, c293v30, c293v31, c293v32, c293v33, c293v34, c293v35, c293v36}
        c293v20.Menu = c293v21
        c293v21 = function()
          local c221v0, c221v1, c221v2
          c221v0 = Engine.IsMobile
          c221v0 = c221v0()
          if not c221v0 then
            c221v0 = vT[65]
            c221v0 = c221v0.CanShowEquipmentSubMenu
            c221v1 = vT[65]
            c221v2 = vT[24]
            c221v0 = c221v0(c221v1, c221v2)
            do return c221v0 end
          end
          c221v0 = vT[65]
          c221v0 = c221v0.CanShowEquipmentSubMenu
          c221v1 = vT[65]
          c221v2 = vT[24]
          c221v0 = c221v0(c221v1, c221v2)
          if c221v0 then
            c221v2 = _T.HasTouchFeatureFlag
            c221v1 = IsNull
            c221v1 = c221v1(c221v2)
            c221v0 = not c221v1
            if c221v0 then
              c221v0 = _T.HasTouchFeatureFlag
              c221v1 = "InVorsShowUI"
              c221v0 = c221v0(c221v1)
            end
          end
          do return c221v0 end
        end
        c293v20.ShouldDisplay = c293v21
        c293v21 = { Name = "/Lotus/Language/Dojo/DecorationMode", Description = "/Lotus/Language/Dojo/DecorationModeDesc", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_SPACE_SHIP
        c293v22 = {c293v23}
        c293v21.DisplayIn = c293v22
        c293v22 = vT[105]
        c293v21.CallBack = c293v22
        c293v22 = function()
          local c222v0, c222v1, c222v2
          c222v1 = Engine.IsMobile
          c222v1 = c222v1()
          c222v0 = not c222v1
          if c222v0 then
            c222v0 = vT[65]
            c222v0 = c222v0.IsApartment
            if c222v0 then
              c222v1 = vT[65]
              c222v1 = c222v1.OnHostsShip
              c222v0 = not c222v1
              if c222v0 then
                c222v1 = vT[65]
                c222v1 = c222v1.ActiveQuest
                c222v2 = zarimanQuestKeyChain
                if c222v1 == c222v2 then
                  c222v0 = false
                else
                  c222v0 = true
                end
              end
            end
          end
          do return c222v0 end
        end
        c293v21.ShouldDisplay = c293v22
        c293v22 = { Name = nil, Description = "/Lotus/Language/Menu/MenuFocusDescription", DisplayIn = nil, TargetConsole = "TennoWay", ShouldDisplay = nil }
        c293v24 = vT[65]
        c293v24 = c293v24.IsTailorShop
        if c293v24 then
          c293v23 = "/Lotus/Language/Labels/NewWarOperatorAdult"
        else
          c293v23 = "/Lotus/Language/Menu/MenuOperator"
        end
        c293v22.Name = c293v23
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_SPACE_SHIP
        c293v23 = {c293v24}
        c293v22.DisplayIn = c293v23
        c293v23 = function()
          local c223v0, c223v1, c223v2, c223v3
          c223v1 = vT[65]
          c223v1 = c223v1.IsApartment
          c223v0 = not c223v1
          if c223v0 then
            c223v0 = vT[7]
            c223v0 = c223v0.CanFastTravelToConsole
            c223v1 = "TennoWay"
            c223v2 = vT[65]
            c223v3 = vT[24]
            c223v0 = c223v0(c223v1, c223v2, c223v3)
          end
          do return c223v0 end
        end
        c293v22.ShouldDisplay = c293v23
        c293v23 = { Name = "/Lotus/Language/Menu/MenuStore", Description = "/Lotus/Language/Menu/MenuStoreDescription", DisplayIn = nil, TargetConsole = "Market", ShouldDisplay = nil }
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_SPACE_SHIP
        c293v24 = {c293v25}
        c293v23.DisplayIn = c293v24
        c293v24 = function()
          local c224v0, c224v1, c224v2, c224v3
          c224v0 = Engine.IsMobile
          c224v0 = c224v0()
          if not c224v0 then
            c224v0 = vT[65]
            c224v0 = c224v0.CanFastTravelToConsole
            c224v1 = "Market"
            c224v2 = vT[65]
            c224v3 = vT[24]
            c224v0 = c224v0(c224v1, c224v2, c224v3)
            do return c224v0 end
          end
          c224v0 = vT[65]
          c224v0 = c224v0.CanFastTravelToConsole
          c224v1 = "Market"
          c224v2 = vT[65]
          c224v3 = vT[24]
          c224v0 = c224v0(c224v1, c224v2, c224v3)
          if c224v0 then
            c224v2 = _T.HasTouchFeatureFlag
            c224v1 = IsNull
            c224v1 = c224v1(c224v2)
            c224v0 = not c224v1
            if c224v0 then
              c224v0 = _T.HasTouchFeatureFlag
              c224v1 = "InVorsShowUI"
              c224v0 = c224v0(c224v1)
            end
          end
          do return c224v0 end
        end
        c293v23.ShouldDisplay = c293v24
        c293v24 = { Name = "/Lotus/Language/Menu/MenuCommunication", DisplayIn = nil, Menu = nil, ShouldDisplay = nil }
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_SPACE_SHIP
        c293v27 = vT[1]
        c293v27 = c293v27.UI_MODE_IN_SPACE_HUB
        c293v28 = vT[1]
        c293v28 = c293v28.UI_MODE_IN_DOJO
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_GAME
        c293v25 = {c293v26, c293v27, c293v28, c293v29}
        c293v24.DisplayIn = c293v25
        c293v26 = { Name = "/Lotus/Language/Menu/FriendsUpperCase", Description = "/Lotus/Language/Menu/MenuFriendsDescription", DisplayIn = nil, TargetMovie = "Friends", ShouldDisplay = nil }
        c293v28 = vT[1]
        c293v28 = c293v28.UI_MODE_IN_SPACE_SHIP
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_SPACE_HUB
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_DOJO
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_GAME
        c293v27 = {c293v28, c293v29, c293v30, c293v31}
        c293v26.DisplayIn = c293v27
        c293v27 = function()
          local c225v0, c225v1, c225v2, c225v3
          c225v0 = vT[65]
          c225v0 = c225v0.CanFastTravelToConsole
          c225v1 = "Friends"
          c225v2 = vT[65]
          c225v3 = vT[24]
          c225v0 = c225v0(c225v1, c225v2, c225v3)
          do return c225v0 end
        end
        c293v26.ShouldDisplay = c293v27
        c293v27 = { Name = "/Lotus/Language/Menu/Profile_Clan", Description = "/Lotus/Language/Menu/MenuClanDescription", DisplayIn = nil, TargetContextMovie = nil, ShouldDisplay = nil }
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_SPACE_SHIP
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_SPACE_HUB
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_DOJO
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_GAME
        c293v28 = {c293v29, c293v30, c293v31, c293v32}
        c293v27.DisplayIn = c293v28
        c293v28 = function()
          local c226v0, c226v1, c226v2, c226v3
          c226v0 = vT[0]
          c226v0 = c226v0.Ternary
          c226v1 = vT[7]
          c226v1 = c226v1.HasClan
          c226v1 = c226v1()
          c226v2 = "Clan"
          c226v3 = "ClanSearch"
          c226v0 = c226v0(c226v1, c226v2, c226v3)
          do return c226v0 end
        end
        c293v27.TargetContextMovie = c293v28
        c293v28 = function()
          local c227v0, c227v1, c227v2, c227v3
          c227v0 = vT[65]
          c227v0 = c227v0.CanFastTravelToConsole
          c227v1 = "Clan"
          c227v2 = vT[65]
          c227v3 = vT[24]
          c227v0 = c227v0(c227v1, c227v2, c227v3)
          do return c227v0 end
        end
        c293v27.ShouldDisplay = c293v28
        c293v28 = { Name = "/Lotus/Language/Menu/Mailbox_Inbox", Description = "/Lotus/Language/Menu/MenuInboxDescription", DisplayIn = nil, TargetMovie = "Inbox" }
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_SPACE_SHIP
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_SPACE_HUB
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_DOJO
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_GAME
        c293v29 = {c293v30, c293v31, c293v32, c293v33}
        c293v28.DisplayIn = c293v29
        c293v25 = {c293v26, c293v27, c293v28}
        c293v24.Menu = c293v25
        c293v25 = function()
          local c228v0, c228v1, c228v2
          c228v0 = Engine.IsMobile
          c228v0 = c228v0()
          if not c228v0 then
            c228v0 = vT[65]
            c228v0 = c228v0.CanShowCommunicationsSubMenu
            c228v1 = vT[65]
            c228v0 = c228v0(c228v1)
            if c228v0 then
              c228v1 = c293v6
              c228v0 = not c228v1
            end
            do return c228v0 end
          end
          c228v0 = vT[65]
          c228v0 = c228v0.CanShowCommunicationsSubMenu
          c228v1 = vT[65]
          c228v0 = c228v0(c228v1)
          if c228v0 then
            c228v1 = c293v6
            c228v0 = not c228v1
            if c228v0 then
              c228v2 = _T.HasTouchFeatureFlag
              c228v1 = IsNull
              c228v1 = c228v1(c228v2)
              c228v0 = not c228v1
              if c228v0 then
                c228v0 = _T.HasTouchFeatureFlag
                c228v1 = "InVorsShowUI"
                c228v0 = c228v0(c228v1)
              end
            end
          end
          do return c228v0 end
        end
        c293v24.ShouldDisplay = c293v25
        c293v25 = { Name = "/Lotus/Language/Menu/Codex_Quests", Description = "/Lotus/Language/Menu/MenuQuestsDescription", DisplayIn = nil, ShouldDisplay = nil, TargetConsole = "Codex", PreConsoleCallback = nil }
        c293v27 = vT[1]
        c293v27 = c293v27.UI_MODE_IN_SPACE_SHIP
        c293v26 = {c293v27}
        c293v25.DisplayIn = c293v26
        c293v26 = function()
          local c229v0, c229v1, c229v2
          c229v0 = Engine.IsMobile
          c229v0 = c229v0()
          if not c229v0 then
            c229v0 = vT[65]
            c229v0 = c229v0.HasSocialMenuFeature
            if c229v0 then
              c229v1 = _G
              c229v1 = c229v1.StalkerMode
              c229v0 = not c229v1
              if c229v0 then
                c229v1 = vT[65]
                c229v1 = c229v1.OnHostsShip
                c229v0 = not c229v1
                if c229v0 then
                  c229v1 = vT[65]
                  c229v1 = c229v1.IsQuestDrifterCamp
                  c229v0 = not c229v1
                  if c229v0 then
                    c229v1 = vT[65]
                    c229v1 = c229v1.IsQuestTailorShop
                    c229v0 = not c229v1
                    if c229v0 then
                      c229v1 = vT[65]
                      c229v1 = c229v1.IsApartment
                      c229v0 = not c229v1
                    end
                  end
                end
              end
            end
            do return c229v0 end
          end
          c229v0 = vT[65]
          c229v0 = c229v0.HasSocialMenuFeature
          if c229v0 then
            c229v1 = _G
            c229v1 = c229v1.StalkerMode
            c229v0 = not c229v1
            if c229v0 then
              c229v1 = vT[65]
              c229v1 = c229v1.OnHostsShip
              c229v0 = not c229v1
              if c229v0 then
                c229v1 = vT[65]
                c229v1 = c229v1.IsQuestDrifterCamp
                c229v0 = not c229v1
                if c229v0 then
                  c229v1 = vT[65]
                  c229v1 = c229v1.IsQuestTailorShop
                  c229v0 = not c229v1
                  if c229v0 then
                    c229v1 = vT[65]
                    c229v1 = c229v1.IsApartment
                    c229v0 = not c229v1
                    if c229v0 then
                      c229v2 = _T.HasTouchFeatureFlag
                      c229v1 = IsNull
                      c229v1 = c229v1(c229v2)
                      c229v0 = not c229v1
                      if c229v0 then
                        c229v0 = _T.HasTouchFeatureFlag
                        c229v1 = "InVorsShowUI"
                        c229v0 = c229v0(c229v1)
                      end
                    end
                  end
                end
              end
            end
          end
          do return c229v0 end
        end
        c293v25.ShouldDisplay = c293v26
        c293v26 = function(c230v0)
          local c230v1, c230v2
          c230v1 = _T
          c230v2 = 1
          c230v1.ForceCodexStartingTab = c230v2
          do return end
        end
        c293v25.PreConsoleCallback = c293v26
        c293v26 = { Name = "/Lotus/Language/Menu/RailjackTitle", DisplayIn = nil, Menu = nil, ShouldDisplay = nil }
        c293v28 = vT[1]
        c293v28 = c293v28.UI_MODE_IN_SPACE_SHIP
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_SPACE_HUB
        c293v27 = {c293v28, c293v29}
        c293v26.DisplayIn = c293v27
        c293v28 = { Name = "/Lotus/Language/Railjack/BoardRailjack", Description = "/Lotus/Language/Railjack/BoardRailjackDesc", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_SPACE_SHIP
        c293v29 = {c293v30}
        c293v28.DisplayIn = c293v29
        c293v29 = vT[126]
        c293v28.CallBack = c293v29
        c293v29 = function()
          local c231v0, c231v1, c231v2, c231v3
          c231v0 = vT[65]
          c231v0 = c231v0.CanFastTravelToConsole
          c231v1 = "RailJackTube"
          c231v2 = vT[65]
          c231v3 = vT[24]
          c231v0 = c231v0(c231v1, c231v2, c231v3)
          do return c231v0 end
        end
        c293v28.ShouldDisplay = c293v29
        c293v29 = { Name = "/Lotus/Language/Railjack/Plexus", Description = "/Lotus/Language/Railjack/Loadout_ConsoleInLiset", DisplayIn = nil, TargetConsole = "CrewshipLoadout", ShouldDisplay = nil }
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_SPACE_SHIP
        c293v30 = {c293v31}
        c293v29.DisplayIn = c293v30
        c293v30 = function()
          local c232v0, c232v1, c232v2
          c232v0 = vT[0]
          c232v0 = c232v0.GetEntityFromTag
          c232v1 = "CrewshipLoadout"
          c232v0 = c232v0(c232v1)
          c232v2 = IsNull
          c232v2 = c232v2(c232v0)
          c232v1 = not c232v2
          if c232v1 then
            c232v1 = c232v0:IsEnabled()
          end
          do return c232v1 end
        end
        c293v29.ShouldDisplay = c293v30
        c293v30 = { Name = "/Lotus/Language/Intrinsics/Intrinsics", Description = "/Lotus/Language/Intrinsics/IntrinsicsDesc", DisplayIn = nil, TargetMovie = "Intrinsics" }
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_SPACE_SHIP
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_SPACE_HUB
        c293v31 = {c293v32, c293v33}
        c293v30.DisplayIn = c293v31
        c293v27 = {c293v28, c293v29, c293v30}
        c293v26.Menu = c293v27
        c293v27 = function()
          local c233v0, c233v1, c233v2
          c233v0 = Engine.IsMobile
          c233v0 = c233v0()
          if not c233v0 then
            c233v0 = vT[65]
            c233v0 = c233v0.CanShowRailjackSubMenu
            c233v1 = vT[65]
            c233v0 = c233v0(c233v1)
            do return c233v0 end
          end
          c233v0 = vT[65]
          c233v0 = c233v0.CanShowRailjackSubMenu
          c233v1 = vT[65]
          c233v0 = c233v0(c233v1)
          if c233v0 then
            c233v2 = _T.HasTouchFeatureFlag
            c233v1 = IsNull
            c233v1 = c233v1(c233v2)
            c233v0 = not c233v1
            if c233v0 then
              c233v0 = _T.HasTouchFeatureFlag
              c233v1 = "InVorsShowUI"
              c233v0 = c233v0(c233v1)
            end
          end
          do return c233v0 end
        end
        c293v26.ShouldDisplay = c293v27
        c293v27 = { Name = "/Lotus/Language/Menu/HostShipReturnToShip", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_SPACE_SHIP
        c293v28 = {c293v29}
        c293v27.DisplayIn = c293v28
        c293v28 = vT[127]
        c293v27.CallBack = c293v28
        c293v28 = function()
          local c234v0, c234v1, c234v2, c234v3
          c234v0 = vT[65]
          c234v0 = c234v0.CanFastTravelToConsole
          c234v1 = "OrbiterTube"
          c234v2 = vT[65]
          c234v3 = vT[24]
          c234v0 = c234v0(c234v1, c234v2, c234v3)
          do return c234v0 end
        end
        c293v27.ShouldDisplay = c293v28
        c293v28 = { Name = "/Lotus/Language/Veilbreaker/KahlCampFastTravelName", Description = "/Lotus/Language/Veilbreaker/KahlCampFastTravelDesc", DisplayIn = nil, ShouldDisplay = nil, TargetConsole = "KahlCamp" }
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_SPACE_SHIP
        c293v29 = {c293v30}
        c293v28.DisplayIn = c293v29
        c293v29 = function()
          local c235v0, c235v1
          c235v0 = vT[65]
          c235v0 = c235v0.ActiveQuest
          c235v1 = newWarQuestKeychain
          if c235v0 == c235v1 then
            c235v0 = false
            do return c235v0 end
          end
          c235v0 = vT[65]
          c235v0 = c235v0.InCamp
          if c235v0 then
            c235v0 = vT[65]
            c235v0 = c235v0.CompletedVeilbreaker
          end
          do return c235v0 end
        end
        c293v28.ShouldDisplay = c293v29
        c293v29 = { Name = "/Lotus/Language/Menu/MenuProfile", DisplayIn = nil, Menu = nil, ShouldDisplay = nil }
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_SPACE_SHIP
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_SPACE_HUB
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_DOJO
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_GAME
        c293v30 = {c293v31, c293v32, c293v33, c293v34}
        c293v29.DisplayIn = c293v30
        c293v31 = { Name = "/Lotus/Language/Menu/Profile_Intel", Description = "/Lotus/Language/Menu/MenuIntelDescription", DisplayIn = nil, ShouldDisplay = nil, TargetConsole = "Codex", PreConsoleCallback = nil }
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_SPACE_SHIP
        c293v32 = {c293v33}
        c293v31.DisplayIn = c293v32
        c293v32 = function()
          local c236v0, c236v1, c236v2, c236v3
          c236v0 = vT[65]
          c236v0 = c236v0.CanFastTravelToConsole
          c236v1 = "Codex"
          c236v2 = vT[65]
          c236v3 = vT[24]
          c236v0 = c236v0(c236v1, c236v2, c236v3)
          do return c236v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v32 = function(c237v0)
          local c237v1, c237v2
          c237v1 = _T
          c237v2 = 2
          c237v1.ForceCodexStartingTab = c237v2
          do return end
        end
        c293v31.PreConsoleCallback = c293v32
        c293v32 = { Name = "/Lotus/Language/Menu/MenuMyProfile", Description = "/Lotus/Language/Menu/MenuMyProfileDescription", DisplayIn = nil, TargetMovie = "Profile", PreAction = nil }
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_SPACE_SHIP
        c293v35 = vT[1]
        c293v35 = c293v35.UI_MODE_IN_SPACE_HUB
        c293v36 = vT[1]
        c293v36 = c293v36.UI_MODE_IN_DOJO
        c293v37 = vT[1]
        c293v37 = c293v37.UI_MODE_IN_GAME
        c293v33 = {c293v34, c293v35, c293v36, c293v37}
        c293v32.DisplayIn = c293v33
        c293v33 = function()
          local c238v0, c238v1
          c238v0 = _T
          c238v1 = nil
          c238v0.SelectedProfileName = c238v1
          c238v0 = _T
          c238v1 = nil
          c238v0.SelectedProfileId = c238v1
          c238v0 = _T
          c238v1 = nil
          c238v0.SelectedProfileImage = c238v1
          do return end
        end
        c293v32.PreAction = c293v33
        c293v33 = { Name = "/Lotus/Language/Menu/Menu_Syndicates", Description = "/Lotus/Language/Menu/MenuSyndicatesDescription", DisplayIn = nil, TargetConsole = "Syndicates", ShouldDisplay = nil }
        c293v35 = vT[1]
        c293v35 = c293v35.UI_MODE_IN_SPACE_SHIP
        c293v34 = {c293v35}
        c293v33.DisplayIn = c293v34
        c293v34 = function()
          local c239v0, c239v1
          c239v1 = vT[65]
          c239v1 = c239v1.QuestCommitment
          c239v0 = not c239v1
          if c239v0 then
            c239v0 = vT[125]
            c239v0 = c239v0()
            if c239v0 then
              c239v1 = vT[65]
              c239v1 = c239v1.IsApartment
              c239v0 = not c239v1
            end
          end
          do return c239v0 end
        end
        c293v33.ShouldDisplay = c293v34
        c293v34 = { Name = "/Lotus/Language/Menu/Profile_Leaderboards", Description = "/Lotus/Language/Menu/MenuProfileDescription", DisplayIn = nil, TargetMovie = "Leaderboards", ShouldDisplay = nil }
        c293v36 = vT[1]
        c293v36 = c293v36.UI_MODE_IN_SPACE_SHIP
        c293v37 = vT[1]
        c293v37 = c293v37.UI_MODE_IN_SPACE_HUB
        c293v35 = {c293v36, c293v37}
        c293v34.DisplayIn = c293v35
        c293v35 = function()
          local c240v0, c240v1
          c240v1 = _T.TennoConHubActive
          c240v0 = not c240v1
          do return c240v0 end
        end
        c293v34.ShouldDisplay = c293v35
        c293v35 = { Name = "/Lotus/Language/Menu/Profile_ChangeAvatarImage", Description = "/Lotus/Language/Menu/MenuChangeAvatarDescription", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v37 = vT[1]
        c293v37 = c293v37.UI_MODE_IN_SPACE_SHIP
        c293v38 = vT[1]
        c293v38 = c293v38.UI_MODE_IN_SPACE_HUB
        c293v36 = {c293v37, c293v38}
        c293v35.DisplayIn = c293v36
        c293v36 = vT[119]
        c293v35.CallBack = c293v36
        c293v36 = function()
          local c241v0, c241v1
          c241v1 = _T.TennoConHubActive
          c241v0 = not c241v1
          do return c241v0 end
        end
        c293v35.ShouldDisplay = c293v36
        c293v36 = { Name = nil, Description = "/Lotus/Language/Titles/TitleSelect_Desc", DisplayIn = nil, TargetMovie = "TitleSelect" }
        c293v37 = vT[143]
        c293v37 = c293v37()
        c293v36.Name = c293v37
        c293v38 = vT[1]
        c293v38 = c293v38.UI_MODE_IN_SPACE_SHIP
        c293v39 = vT[1]
        c293v39 = c293v39.UI_MODE_IN_SPACE_HUB
        c293v37 = {c293v38, c293v39}
        c293v36.DisplayIn = c293v37
        c293v37 = { Name = "/Lotus/Language/Mobile/NavBar_CustomerSupport", Description = "/Lotus/Language/Mobile/MenuCustomerSupportDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v39 = vT[1]
        c293v39 = c293v39.UI_MODE_IN_SPACE_SHIP
        c293v40 = vT[1]
        c293v40 = c293v40.UI_IN_SPACE_HUB
        c293v38 = {c293v39, c293v40}
        c293v37.DisplayIn = c293v38
        c293v38 = function()
          local c242v0
          c242v0 = Engine.IsMobile
          c242v0 = c242v0()
          do return c242v0 end
        end
        c293v37.ShouldDisplay = c293v38
        c293v38 = vT[115]
        c293v37.CallBack = c293v38
        c293v38 = { Name = "/Lotus/Language/Menu/NavBar_LogoutToolTip", Description = "/Lotus/Language/Menu/MenuLogoutDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v40 = vT[1]
        c293v40 = c293v40.UI_MODE_IN_SPACE_SHIP
        c293v41 = vT[1]
        c293v41 = c293v41.UI_IN_SPACE_HUB
        c293v39 = {c293v40, c293v41}
        c293v38.DisplayIn = c293v39
        c293v39 = function()
          local c243v0, c243v1
          c243v1 = Engine.IsConsole
          c243v1 = c243v1()
          c243v0 = not c243v1
          do return c243v0 end
        end
        c293v38.ShouldDisplay = c293v39
        c293v39 = vT[116]
        c293v38.CallBack = c293v39
        c293v39 = { Name = "/Lotus/Language/Menu/NavBar_SwitchProfileToolTip", Description = "/Lotus/Language/Menu/MenuSwitchProfileDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v41 = vT[1]
        c293v41 = c293v41.UI_MODE_IN_SPACE_SHIP
        c293v42 = vT[1]
        c293v42 = c293v42.UI_IN_SPACE_HUB
        c293v40 = {c293v41, c293v42}
        c293v39.DisplayIn = c293v40
        c293v40 = function()
          local c244v0
          c244v0 = Engine.Name__3d4ef9f7
          c244v0 = c244v0()
          do return c244v0 end
        end
        c293v39.ShouldDisplay = c293v40
        c293v40 = vT[114]
        c293v39.CallBack = c293v40
        c293v40 = { Name = "/Lotus/Language/Menu/Profile_AccountRename", Description = "/Lotus/Language/Menu/Profile_AccountRenameDesc", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v42 = vT[1]
        c293v42 = c293v42.UI_MODE_IN_SPACE_SHIP
        c293v41 = {c293v42}
        c293v40.DisplayIn = c293v41
        c293v41 = function()
          local c245v0, c245v1, c245v2
          local p7 = 0
          if p7 == 0 then
            c245v0 = gPlayerProfileMgr
            c245v2 = 0
            c245v0 = c245v0:GetPlayerProfile(c245v2)
            c245v2 = vT[58]
            if c245v2 then
              p7 = 3
            else
              p7 = 1
            end
          end
          if p7 == 1 then
            c245v2 = Engine.IsNintendo
            c245v2 = c245v2()
            if c245v2 then
              p7 = 3
            else
              p7 = 2
            end
          end
          if p7 == 2 then
            c245v1 = Engine.IsMobile
            c245v1 = c245v1()
            if not c245v1 then
              p7 = 5
            else
              p7 = 3
            end
          end
          if p7 == 3 then
            c245v1 = c245v0
            if not c245v1 then
              p7 = 5
            else
              p7 = 4
            end
          end
          if p7 == 4 then
            c245v1 = c245v0:Name__087b8946()
            p7 = 5
          end
          if p7 == 5 then
            do return c245v1 end
          end
        end
        c293v40.ShouldDisplay = c293v41
        c293v41 = vT[117]
        c293v40.CallBack = c293v41
        c293v41 = { Name = "/Lotus/Language/SystemMessages/Switch_WebAuth", Description = "/Lotus/Language/SystemMessages/Switch_WebAuthDesc", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v43 = vT[1]
        c293v43 = c293v43.UI_MODE_IN_SPACE_SHIP
        c293v44 = vT[1]
        c293v44 = c293v44.UI_MODE_IN_SPACE_HUB
        c293v45 = vT[1]
        c293v45 = c293v45.UI_MODE_IN_DOJO
        c293v46 = vT[1]
        c293v46 = c293v46.UI_MODE_IN_GAME
        c293v42 = {c293v43, c293v44, c293v45, c293v46}
        c293v41.DisplayIn = c293v42
        c293v42 = function()
          local c246v0, c246v1, c246v2
          c246v0 = gPlayerProfileMgr
          c246v2 = 0
          c246v0 = c246v0:GetPlayerProfile(c246v2)
          c246v1 = Engine.IsNintendo
          c246v1 = c246v1()
          if c246v1 then
            c246v1 = c246v0
            if c246v1 then
              c246v1 = false
              c246v2 = c246v0:Name__e9b1e2e8()
              if c246v2 == "" then
                c246v2 = c246v0:IsCrossSave()
                c246v1 = not c246v2
              end
            end
          end
          do return c246v1 end
        end
        c293v41.ShouldDisplay = c293v42
        c293v42 = vT[118]
        c293v41.CallBack = c293v42
        c293v30 = {c293v31, c293v32, c293v33, c293v34, c293v35, c293v36, c293v37, c293v38, c293v39, c293v40, c293v41}
        c293v29.Menu = c293v30
        c293v30 = function()
          local c247v0, c247v1, c247v2
          c247v0 = Engine.IsMobile
          c247v0 = c247v0()
          if not c247v0 then
            c247v0 = vT[65]
            c247v0 = c247v0.CanShowProfileSubMenu
            c247v1 = vT[65]
            c247v0 = c247v0(c247v1)
            if c247v0 then
              c247v1 = _T.JSCookingMiniGame
              c247v0 = not c247v1
            end
            do return c247v0 end
          end
          c247v0 = vT[65]
          c247v0 = c247v0.CanShowProfileSubMenu
          c247v1 = vT[65]
          c247v0 = c247v0(c247v1)
          if c247v0 then
            c247v2 = _T.HasTouchFeatureFlag
            c247v1 = IsNull
            c247v1 = c247v1(c247v2)
            c247v0 = not c247v1
            if c247v0 then
              c247v0 = _T.HasTouchFeatureFlag
              c247v1 = "InVorsShowUI"
              c247v0 = c247v0(c247v1)
              if c247v0 then
                c247v1 = _T.JSCookingMiniGame
                c247v0 = not c247v1
              end
            end
          end
          do return c247v0 end
        end
        c293v29.ShouldDisplay = c293v30
        c293v30 = { Name = "/Lotus/Language/Menu/MenuOptions", Description = "/Lotus/Language/Menu/MenuOptionsDescription", DisplayIn = nil, TargetMovie = "Settings", ShouldDisplay = nil }
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_GAME
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_SPACE_SHIP
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_SPACE_HUB
        c293v35 = vT[1]
        c293v35 = c293v35.UI_MODE_IN_DOJO
        c293v31 = {c293v32, c293v33, c293v34, c293v35}
        c293v30.DisplayIn = c293v31
        c293v31 = function()
          local c248v0, c248v1
          c248v1 = _T.isStreamingLevel
          c248v0 = not c248v1
          if c248v0 then
            c248v1 = _T.JSCookingMiniGame
            c248v0 = not c248v1
          end
          do return c248v0 end
        end
        c293v30.ShouldDisplay = c293v31
        c293v31 = { Name = "/Lotus/Language/OlliesCrashCourse/UI_OlliesCrashCourseMenuQuit", Description = "/Lotus/Language/OlliesCrashCourse/UI_OlliesCrashCourseMenuQuitDesc", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_GAME
        c293v32 = {c293v33}
        c293v31.DisplayIn = c293v32
        c293v32 = vT[138]
        c293v31.CallBack = c293v32
        c293v32 = function()
          local c249v0
          c249v0 = c293v6
          do return c249v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v32 = { Name = "/Lotus/Language/Menu/ViewMissionProgress", Description = "/Lotus/Language/Menu/ViewMissionProgressDescription", DisplayIn = nil, TargetMovie = "MissionStats", ShouldDisplay = nil }
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_GAME
        c293v33 = {c293v34}
        c293v32.DisplayIn = c293v33
        c293v33 = function()
          local c250v0, c250v1, c250v3
          c250v1 = vT[65]
          c250v1 = c250v1.QuestCommitment
          c250v0 = not c250v1
          if c250v0 then
            c250v0 = gGameRules
            c250v0 = c250v0:ShowMissionProgress()
            if c250v0 then
              c250v1 = vT[31]
              c250v0 = not c250v1
              if c250v0 then
                c250v1 = vT[24]
                c250v3 = gOrokinGoldenMawAvatarType
                c250v1 = c250v1:IsA(c250v3)
                c250v0 = not c250v1
                if c250v0 then
                  c250v1 = _G
                  c250v1 = c250v1.StalkerMode
                  c250v0 = not c250v1
                  if c250v0 then
                    c250v1 = gGameRules
                    c250v3 = gLotusFightingGameRulesType
                    c250v1 = c250v1:IsA(c250v3)
                    c250v0 = not c250v1
                    if c250v0 then
                      c250v1 = c293v6
                      c250v0 = not c250v1
                    end
                  end
                end
              end
            end
          end
          do return c250v0 end
        end
        c293v32.ShouldDisplay = c293v33
        c293v16[17] = c293v17
        c293v16[18] = c293v18
        c293v16[19] = c293v19
        c293v16[20] = c293v20
        c293v16[21] = c293v21
        c293v16[22] = c293v22
        c293v16[23] = c293v23
        c293v16[24] = c293v24
        c293v16[25] = c293v25
        c293v16[26] = c293v26
        c293v16[27] = c293v27
        c293v16[28] = c293v28
        c293v16[29] = c293v29
        c293v16[30] = c293v30
        c293v16[31] = c293v31
        c293v16[32] = c293v32
        c293v17 = { Name = "/Lotus/Language/Menu/ViewLastMissionStats", Description = "/Lotus/Language/Menu/ViewLastMissionDescription", DisplayIn = nil, TargetMovie = "MissionStats", ShouldDisplay = nil }
        c293v19 = vT[1]
        c293v19 = c293v19.UI_MODE_IN_SPACE_SHIP
        c293v20 = vT[1]
        c293v20 = c293v20.UI_MODE_IN_SPACE_HUB
        c293v21 = vT[1]
        c293v21 = c293v21.UI_MODE_IN_DOJO
        c293v18 = {c293v19, c293v20, c293v21}
        c293v17.DisplayIn = c293v18
        c293v18 = function()
          local c251v0, c251v1
          c251v0 = vT[5]
          c251v0 = c251v0.CanShowEndOfMatchPreview
          c251v0 = c251v0()
          if c251v0 then
            c251v1 = vT[65]
            c251v1 = c251v1.IsQuestTailorShop
            c251v0 = not c251v1
          end
          do return c251v0 end
        end
        c293v17.ShouldDisplay = c293v18
        c293v18 = { Name = "/Lotus/Language/Dojo/Decorations", Description = "/Lotus/Language/Dojo/DecorationsDecription", DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v20 = vT[1]
        c293v20 = c293v20.UI_MODE_IN_DOJO
        c293v19 = {c293v20}
        c293v18.DisplayIn = c293v19
        c293v19 = function()
          local c252v0, c252v1, c252v2
          c252v0 = vT[65]
          c252v0 = c252v0.CanShowDojoDecorateSubMenu
          c252v1 = vT[65]
          c252v2 = vT[24]
          c252v0 = c252v0(c252v1, c252v2)
          do return c252v0 end
        end
        c293v18.ShouldDisplay = c293v19
        c293v20 = { Name = "/Lotus/Language/Dojo/DecorationMode", Description = "/Lotus/Language/Dojo/DecorationModeDesc", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v22 = vT[1]
        c293v22 = c293v22.UI_MODE_IN_DOJO
        c293v21 = {c293v22}
        c293v20.DisplayIn = c293v21
        c293v21 = function()
          local c253v0, c253v1, c253v2, c253v3
          c253v0 = vT[65]
          c253v0 = c253v0.CanFastTravelToConsole
          c253v1 = "Decorate"
          c253v2 = vT[65]
          c253v3 = vT[24]
          c253v0 = c253v0(c253v1, c253v2, c253v3)
          do return c253v0 end
        end
        c293v20.ShouldDisplay = c293v21
        c293v21 = vT[106]
        c293v20.CallBack = c293v21
        c293v21 = { Name = "/Lotus/Language/Dojo/DecorationModePersonal", Description = "/Lotus/Language/Dojo/DecorationModeDesc", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_DOJO
        c293v22 = {c293v23}
        c293v21.DisplayIn = c293v22
        c293v22 = function()
          local c254v0, c254v1, c254v2
          c254v0 = vT[24]
          c254v0 = c254v0.CanPlaceDojoDecorations
          c254v1 = vT[24]
          c254v2 = true
          c254v0 = c254v0(c254v1, c254v2)
          if c254v0 then
            c254v1 = _T.gPreviewMode
            if c254v1 ~= nil then
              c254v0 = false
            else
              c254v0 = true
            end
          end
          do return c254v0 end
        end
        c293v21.ShouldDisplay = c293v22
        c293v22 = vT[105]
        c293v21.CallBack = c293v22
        c293v22 = { Name = "/Lotus/Language/Dojo/CancelPreviewDecorations", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_DOJO
        c293v23 = {c293v24}
        c293v22.DisplayIn = c293v23
        c293v23 = function()
          local c255v0, c255v1
          c255v1 = _T.gPreviewMode
          if c255v1 == nil then
            c255v0 = false
          else
            c255v0 = true
          end
          do return c255v0 end
        end
        c293v22.ShouldDisplay = c293v23
        c293v23 = vT[107]
        c293v22.CallBack = c293v23
        c293v23 = { Name = "/Lotus/Language/Menu/TintDojo", Description = "/Lotus/Language/Menu/TintDojoDes", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_DOJO
        c293v24 = {c293v25}
        c293v23.DisplayIn = c293v24
        c293v24 = function()
          local c256v0
          c256v0 = vT[99]
          c256v0 = c256v0()
          do return c256v0 end
        end
        c293v23.ShouldDisplay = c293v24
        c293v24 = vT[101]
        c293v23.CallBack = c293v24
        c293v24 = { Name = "/Lotus/Language/Menu/RemovePaintBot", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_DOJO
        c293v25 = {c293v26}
        c293v24.DisplayIn = c293v25
        c293v25 = function()
          local c257v0
          c257v0 = vT[100]
          c257v0 = c257v0()
          do return c257v0 end
        end
        c293v24.ShouldDisplay = c293v25
        c293v25 = vT[103]
        c293v24.CallBack = c293v25
        c293v19 = {c293v20, c293v21, c293v22, c293v23, c293v24}
        c293v18.Menu = c293v19
        c293v19 = { Name = "/Lotus/Language/Dojo/ReduceGuildTier", Description = nil, DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v20 = Localize
        c293v21 = "/Lotus/Language/Dojo/ReduceGuildTierDesc"
        c293v22 = { OLD_TIER_NAME = nil, NEW_TIER_NAME = nil }
        c293v23 = Localize
        c293v25 = "/Lotus/Language/Clan/Tier"
        c293v26 = vT[65]
        c293v26 = c293v26.GuildTier
        c293v27 = "Name"
        c293v24 = c293v25 .. c293v26 .. c293v27
        c293v25 = {}
        c293v23 = c293v23(c293v24, c293v25)
        c293v22.OLD_TIER_NAME = c293v23
        c293v23 = Localize
        c293v25 = "/Lotus/Language/Clan/Tier"
        c293v28 = vT[65]
        c293v28 = c293v28.GuildTier
        c293v29 = 1
        c293v26 = c293v28 - c293v29
        c293v27 = "Name"
        c293v24 = c293v25 .. c293v26 .. c293v27
        c293v25 = {}
        c293v23 = c293v23(c293v24, c293v25)
        c293v22.NEW_TIER_NAME = c293v23
        c293v20 = c293v20(c293v21, c293v22)
        c293v19.Description = c293v20
        c293v21 = vT[1]
        c293v21 = c293v21.UI_MODE_IN_DOJO
        c293v20 = {c293v21}
        c293v19.DisplayIn = c293v20
        c293v20 = function()
          local c258v0, c258v1, c258v2
          c258v2 = gGameData
          c258v1 = IsNull
          c258v1 = c258v1(c258v2)
          c258v0 = not c258v1
          if c258v0 then
            c258v0 = gGameRules
            c258v2 = gLotusDojoGameRulesType
            c258v0 = c258v0:IsA(c258v2)
            if c258v0 then
              c258v0 = false
              c258v1 = gGameRules
              c258v1 = c258v1:GetGuildId()
              c258v2 = gGameData
              c258v2 = c258v2:GetGuildId()
              if c258v1 == c258v2 then
                c258v1 = vT[65]
                c258v1 = c258v1.GuildTier
                c258v2 = 1
                if c258v1 <= c258v2 then
                  c258v0 = false
                else
                  c258v0 = true
                end
              end
            end
          end
          do return c258v0 end
        end
        c293v19.ShouldDisplay = c293v20
        c293v20 = vT[97]
        c293v19.CallBack = c293v20
        c293v20 = { Name = "KEY LAUNCHER", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v22 = vT[1]
        c293v22 = c293v22.UI_MODE_IN_GAME
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_SPACE_SHIP
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_SPACE_HUB
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_DOJO
        c293v21 = {c293v22, c293v23, c293v24, c293v25}
        c293v20.DisplayIn = c293v21
        c293v21 = vT[128]
        c293v20.CallBack = c293v21
        c293v21 = function()
          local c259v0, c259v1
          local p7 = 0
          if p7 == 0 then
            c259v1 = vT[1]
            c259v1 = c259v1.IsDevServer
            c259v1 = c259v1()
            if c259v1 then
              p7 = 3
            else
              p7 = 1
            end
          end
          if p7 == 1 then
            c259v1 = vT[1]
            c259v1 = c259v1.IsTestServer
            c259v1 = c259v1()
            if c259v1 then
              p7 = 3
            else
              p7 = 2
            end
          end
          if p7 == 2 then
            c259v0 = vT[1]
            c259v0 = c259v0.IsLocalServer
            c259v0 = c259v0()
            if not c259v0 then
              p7 = 5
            else
              p7 = 3
            end
          end
          if p7 == 3 then
            c259v0 = gRegion
            c259v0 = c259v0:IsMaster()
            if not c259v0 then
              p7 = 5
            else
              p7 = 4
            end
          end
          if p7 == 4 then
            c259v0 = vT[70]
            c259v0 = c259v0()
            p7 = 5
          end
          if p7 == 5 then
            do return c259v0 end
          end
        end
        c293v20.ShouldDisplay = c293v21
        c293v21 = { Name = nil, Description = nil, DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v23 = vT[65]
        c293v23 = c293v23.IsDuviriEndless
        if c293v23 then
          c293v22 = "/Lotus/Language/Duviri/MenuCircuitAbort"
        else
          c293v23 = vT[65]
          c293v23 = c293v23.InDuviri
          if c293v23 then
            c293v22 = "/Lotus/Language/Duviri/MenuAbortMission"
          else
            c293v22 = "/Lotus/Language/Menu/AbortMissionUpperCase"
          end
        end
        c293v21.Name = c293v22
        c293v23 = vT[65]
        c293v23 = c293v23.InDuviri
        if c293v23 then
          c293v23 = vT[65]
          c293v23 = c293v23.IsDuviriEndless
          if c293v23 then
            c293v22 = "/Lotus/Language/Duviri/MenuCircuitAbortMissionDescription"
          else
            c293v22 = "/Lotus/Language/Duviri/MenuAbortMissionDescription"
          end
        else
          c293v22 = "/Lotus/Language/Menu/MenuAbortMissionDescription"
        end
        c293v21.Description = c293v22
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_GAME
        c293v22 = {c293v23}
        c293v21.DisplayIn = c293v22
        c293v22 = function()
          local c260v0, c260v1, c260v2, c260v3
          local p18 = 0
          if p18 == 0 then
            c260v1 = vT[65]
            c260v1 = c260v1.QuestCommitment
            c260v0 = not c260v1
            if not c260v0 then
              p18 = 11
            else
              p18 = 1
            end
          end
          if p18 == 1 then
            c260v1 = vT[65]
            c260v1 = c260v1.IsStreamingLevel
            c260v0 = not c260v1
            if not c260v0 then
              p18 = 11
            else
              p18 = 2
            end
          end
          if p18 == 2 then
            c260v1 = vT[65]
            c260v1 = c260v1.IsInPlainsOrZarimanMission
            if c260v1 then
              p18 = 4
            else
              p18 = 3
            end
          end
          if p18 == 3 then
            c260v0 = vT[65]
            c260v0 = c260v0.IsEntratiLabMission
            if not c260v0 then
              p18 = 11
            else
              p18 = 4
            end
          end
          if p18 == 4 then
            c260v1 = gGameRules
            c260v1 = c260v1:Name__2d7d1da2()
            c260v0 = not c260v1
            if not c260v0 then
              p18 = 11
            else
              p18 = 5
            end
          end
          if p18 == 5 then
            c260v1 = vT[31]
            c260v0 = not c260v1
            if not c260v0 then
              p18 = 11
            else
              p18 = 6
            end
          end
          if p18 == 6 then
            c260v0 = false
            c260v1 = gGameRules
            c260v1 = c260v1:GetMission()
            c260v1 = c260v1.missionType
            c260v2 = 23
            if c260v1 == c260v2 then
              p18 = 11
            else
              p18 = 7
            end
          end
          if p18 == 7 then
            c260v1 = gGameRules
            c260v3 = gLotusPhotoBoothGameRulesType
            c260v1 = c260v1:IsA(c260v3)
            c260v0 = not c260v1
            if not c260v0 then
              p18 = 11
            else
              p18 = 8
            end
          end
          if p18 == 8 then
            c260v1 = _T.InSimulacrum
            c260v0 = not c260v1
            if not c260v0 then
              p18 = 11
            else
              p18 = 9
            end
          end
          if p18 == 9 then
            c260v1 = vT[65]
            c260v1 = c260v1.IsRailjackReturnToDojoAvailable
            c260v0 = not c260v1
            if not c260v0 then
              p18 = 11
            else
              p18 = 10
            end
          end
          if p18 == 10 then
            c260v1 = vT[65]
            c260v1 = c260v1.IsRailjackClientLeaveMissionAvailable
            c260v0 = not c260v1
            p18 = 11
          end
          if p18 == 11 then
            do return c260v0 end
          end
        end
        c293v21.ShouldDisplay = c293v22
        c293v23 = { Name = nil, Description = nil, DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v23.Name = c293v9
        c293v23.Description = c293v10
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_GAME
        c293v24 = {c293v25}
        c293v23.DisplayIn = c293v24
        c293v24 = vT[92]
        c293v23.CallBack = c293v24
        c293v24 = function()
          local c261v0
          c261v0 = c293v12
          do return c261v0 end
        end
        c293v23.ShouldDisplay = c293v24
        c293v24 = { Name = "/Lotus/Language/Menu/ReturnToShip", Description = nil, DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v24.Description = c293v11
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_GAME
        c293v25 = {c293v26}
        c293v24.DisplayIn = c293v25
        c293v25 = vT[93]
        c293v24.CallBack = c293v25
        c293v25 = function()
          local c262v0, c262v1, c262v2
          c262v1 = gGameData
          c262v0 = IsNull
          c262v0 = c262v0(c262v1)
          if c262v0 then
            c262v0 = false
            do return c262v0 end
          end
          c262v0 = true
          c262v1 = gGameData
          c262v1 = c262v1:GetStoryModeChoice()
          c262v2 = 2
          if c262v1 == c262v2 then
            c262v0 = gGameData
            c262v0 = c262v0:Name__fda0d70d()
          end
          do return c262v0 end
        end
        c293v24.ShouldDisplay = c293v25
        c293v22 = {c293v23, c293v24}
        c293v21.Menu = c293v22
        c293v22 = { Name = "/Lotus/Language/Menu/AbortMissionUpperCase", Description = "/Lotus/Language/Menu/MenuAbortMissionDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_GAME
        c293v23 = {c293v24}
        c293v22.DisplayIn = c293v23
        c293v23 = function()
          local c263v0, c263v1, c263v2, c263v3
          c263v1 = vT[65]
          c263v1 = c263v1.QuestCommitment
          c263v0 = not c263v1
          if c263v0 then
            c263v1 = vT[65]
            c263v1 = c263v1.IsInPlainsOrZarimanMission
            c263v0 = not c263v1
            if c263v0 then
              c263v1 = vT[65]
              c263v1 = c263v1.IsEntratiLabMission
              c263v0 = not c263v1
              if c263v0 then
                c263v1 = gGameRules
                c263v1 = c263v1:Name__2d7d1da2()
                c263v0 = not c263v1
                if c263v0 then
                  c263v0 = false
                  c263v1 = gGameRules
                  c263v1 = c263v1:GetMission()
                  c263v1 = c263v1.missionType
                  c263v2 = 23
                  if c263v1 ~= c263v2 then
                    c263v1 = gGameRules
                    c263v3 = gLotusPhotoBoothGameRulesType
                    c263v1 = c263v1:IsA(c263v3)
                    c263v0 = not c263v1
                    if c263v0 then
                      c263v1 = _T.InSimulacrum
                      c263v0 = not c263v1
                      if c263v0 then
                        c263v1 = gGameRules
                        c263v3 = gLotusLocalFightingGameRulesType
                        c263v1 = c263v1:IsA(c263v3)
                        c263v0 = not c263v1
                        if c263v0 then
                          c263v1 = vT[65]
                          c263v1 = c263v1.IsRailjackReturnToDojoAvailable
                          c263v0 = not c263v1
                          if c263v0 then
                            c263v1 = vT[65]
                            c263v1 = c263v1.IsRailjackClientLeaveMissionAvailable
                            c263v0 = not c263v1
                            if c263v0 then
                              c263v1 = c293v6
                              c263v0 = not c263v1
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
          do return c263v0 end
        end
        c293v22.ShouldDisplay = c293v23
        c293v23 = vT[91]
        c293v22.CallBack = c293v23
        c293v23 = { Name = "/Lotus/Language/Menu/RestartLevelUpperCase", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_GAME
        c293v24 = {c293v25}
        c293v23.DisplayIn = c293v24
        c293v24 = function()
          local c264v0, c264v1
          c264v1 = _T.RestartMissionKey
          if c264v1 == nil then
            c264v0 = false
          else
            c264v0 = true
          end
          do return c264v0 end
        end
        c293v23.ShouldDisplay = c293v24
        c293v24 = vT[90]
        c293v23.CallBack = c293v24
        c293v24 = { Name = "/Lotus/Language/Menu/RetunToDojoUpperCase", Description = "/Lotus/Language/Menu/MenuAbortMissionDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_GAME
        c293v25 = {c293v26}
        c293v24.DisplayIn = c293v25
        c293v25 = function()
          local c265v0, c265v1
          c265v0 = vT[65]
          c265v0 = c265v0.IsRailjackReturnToDojoAvailable
          if c265v0 then
            c265v1 = vT[65]
            c265v1 = c265v1.InHyperdrive
            c265v0 = not c265v1
            if c265v0 then
              c265v1 = vT[65]
              c265v1 = c265v1.IsRailjackMissionComplete
              c265v0 = not c265v1
            end
          end
          do return c265v0 end
        end
        c293v24.ShouldDisplay = c293v25
        c293v25 = vT[91]
        c293v24.CallBack = c293v25
        c293v25 = { Name = "/Lotus/Language/Menu/RetunToDojoUpperCase", Description = "/Lotus/Language/Menu/ExitDojoDuelDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil, CallBackParam = "/Lotus/Language/Menu/AbortCompletedRailjackMissionHostConfirm" }
        c293v27 = vT[1]
        c293v27 = c293v27.UI_MODE_IN_GAME
        c293v26 = {c293v27}
        c293v25.DisplayIn = c293v26
        c293v26 = function()
          local c266v0, c266v1
          c266v0 = vT[65]
          c266v0 = c266v0.IsRailjackReturnToDojoAvailable
          if c266v0 then
            c266v1 = vT[65]
            c266v1 = c266v1.InHyperdrive
            c266v0 = not c266v1
            if c266v0 then
              c266v0 = vT[65]
              c266v0 = c266v0.IsRailjackMissionComplete
            end
          end
          do return c266v0 end
        end
        c293v25.ShouldDisplay = c293v26
        c293v26 = vT[91]
        c293v25.CallBack = c293v26
        c293v26 = { Name = "/Lotus/Language/Menu/AbortPermaDeathMission", Description = "/Lotus/Language/Menu/ExitDojoDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil, CallBackParam = "/Lotus/Language/Menu/AbortPermaDeathMissionConfirm" }
        c293v28 = vT[1]
        c293v28 = c293v28.UI_MODE_IN_GAME
        c293v27 = {c293v28}
        c293v26.DisplayIn = c293v27
        c293v27 = function()
          local c267v0
          c267v0 = vT[65]
          c267v0 = c267v0.IsRailjackClientLeaveMissionAvailable
          do return c267v0 end
        end
        c293v26.ShouldDisplay = c293v27
        c293v27 = vT[91]
        c293v26.CallBack = c293v27
        c293v27 = { Name = "/Lotus/Language/Menu/ExitJunction", Description = "/Lotus/Language/Menu/ExitDojoDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_GAME
        c293v28 = {c293v29}
        c293v27.DisplayIn = c293v28
        c293v28 = function()
          local c268v0, c268v1, c268v2
          c268v0 = gGameRules
          c268v2 = gLotusBaseGameRulesType
          c268v0 = c268v0:IsA(c268v2)
          if c268v0 then
            c268v1 = gGameRules
            c268v1 = c268v1:GetMission()
            c268v1 = c268v1.missionType
            c268v2 = 23
            if c268v1 ~= c268v2 then
              c268v0 = false
            else
              c268v0 = true
            end
          end
          do return c268v0 end
        end
        c293v27.ShouldDisplay = c293v28
        c293v28 = vT[91]
        c293v27.CallBack = c293v28
        c293v28 = { Name = "/Lotus/Language/Photobooth/ExitPhotobooth", Description = "/Lotus/Language/Menu/ExitDojoDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_GAME
        c293v29 = {c293v30}
        c293v28.DisplayIn = c293v29
        c293v29 = function()
          local c269v0, c269v2
          c269v0 = gGameRules
          c269v2 = gLotusPhotoBoothGameRulesType
          c269v0 = c269v0:IsA(c269v2)
          do return c269v0 end
        end
        c293v28.ShouldDisplay = c293v29
        c293v29 = vT[91]
        c293v28.CallBack = c293v29
        c293v29 = { Name = "/Lotus/Language/Menu/ExitSimulacrum", Description = "/Lotus/Language/Menu/ExitSimulacrumDesc", DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_GAME
        c293v30 = {c293v31}
        c293v29.DisplayIn = c293v30
        c293v30 = function()
          local c270v0, c270v1, c270v2, c270v3
          c270v0 = false
          c270v1 = c293v13
          if c270v1 ~= "" then
            c270v0 = gGameRules
            c270v2 = gLotusSandBoxGameRulesType
            c270v0 = c270v0:IsA(c270v2)
            if c270v0 then
              c270v1 = gGameRules
              c270v3 = gLotusPhotoBoothGameRulesType
              c270v1 = c270v1:IsA(c270v3)
              c270v0 = not c270v1
            end
          end
          do return c270v0 end
        end
        c293v29.ShouldDisplay = c293v30
        c293v31 = { Name = "/Lotus/Language/Menu/Chat_HubTitleUpperCase", Description = "/Lotus/Language/Menu/ExitSimulacrumDesc", DisplayIn = nil, CallBack = nil }
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_GAME
        c293v32 = {c293v33}
        c293v31.DisplayIn = c293v32
        c293v32 = vT[95]
        c293v31.CallBack = c293v32
        c293v32 = { Name = "/Lotus/Language/Menu/ReturnToShip", Description = "/Lotus/Language/Menu/MenuReturnToShipDescription", DisplayIn = nil, CallBack = nil }
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_GAME
        c293v33 = {c293v34}
        c293v32.DisplayIn = c293v33
        c293v33 = vT[94]
        c293v32.CallBack = c293v33
        c293v30 = {c293v31, c293v32}
        c293v29.Menu = c293v30
        c293v30 = { Name = "/Lotus/Language/Menu/ExitSimulacrum", Description = "/Lotus/Language/Menu/MenuReturnToShipDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_GAME
        c293v31 = {c293v32}
        c293v30.DisplayIn = c293v31
        c293v31 = function()
          local c271v0, c271v1, c271v2, c271v3
          c271v0 = false
          c271v1 = c293v13
          if c271v1 == "" then
            c271v0 = gGameRules
            c271v2 = gLotusSandBoxGameRulesType
            c271v0 = c271v0:IsA(c271v2)
            if c271v0 then
              c271v1 = gGameRules
              c271v3 = gLotusPhotoBoothGameRulesType
              c271v1 = c271v1:IsA(c271v3)
              c271v0 = not c271v1
            end
          end
          do return c271v0 end
        end
        c293v30.ShouldDisplay = c293v31
        c293v31 = vT[94]
        c293v30.CallBack = c293v31
        c293v31 = { Name = "/Lotus/Language/Menu/ExitArenaUpperCase", Description = "/Lotus/Language/Menu/MenuExitArenaDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_DOJO
        c293v32 = {c293v33}
        c293v31.DisplayIn = c293v32
        c293v32 = function()
          local c272v0, c272v1, c272v2, c272v3
          c272v1 = string.find
          c272v2 = gGameRules
          c272v2 = c272v2:GetFullName()
          c272v3 = "LotusConclaveGameRules"
          c272v1 = c272v1(c272v2, c272v3)
          if c272v1 == nil then
            c272v0 = false
          else
            c272v0 = true
          end
          do return c272v0 end
        end
        c293v31.ShouldDisplay = c293v32
        c293v32 = vT[91]
        c293v31.CallBack = c293v32
        c293v32 = { Name = "/Lotus/Language/Menu/ExitDojoUpperCase", Description = "/Lotus/Language/Menu/ExitDojoDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_DOJO
        c293v33 = {c293v34}
        c293v32.DisplayIn = c293v33
        c293v33 = function()
          local c273v0, c273v2
          c273v0 = gGameRules
          c273v2 = gLotusDojoGameRulesType
          c273v0 = c273v0:IsA(c273v2)
          do return c273v0 end
        end
        c293v32.ShouldDisplay = c293v33
        c293v33 = vT[91]
        c293v32.CallBack = c293v33
        c293v16[33] = c293v17
        c293v16[34] = c293v18
        c293v16[35] = c293v19
        c293v16[36] = c293v20
        c293v16[37] = c293v21
        c293v16[38] = c293v22
        c293v16[39] = c293v23
        c293v16[40] = c293v24
        c293v16[41] = c293v25
        c293v16[42] = c293v26
        c293v16[43] = c293v27
        c293v16[44] = c293v28
        c293v16[45] = c293v29
        c293v16[46] = c293v30
        c293v16[47] = c293v31
        c293v16[48] = c293v32
        c293v17 = { Name = "/Lotus/Language/Menu/RetunToDojoUpperCase", Description = "/Lotus/Language/Menu/ExitDojoDuelDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v19 = vT[1]
        c293v19 = c293v19.UI_MODE_IN_DOJO
        c293v18 = {c293v19}
        c293v17.DisplayIn = c293v18
        c293v18 = function()
          local c274v0, c274v2
          c274v0 = gGameRules
          c274v2 = gLotusDuelGameRulesType
          c274v0 = c274v0:IsA(c274v2)
          do return c274v0 end
        end
        c293v17.ShouldDisplay = c293v18
        c293v18 = vT[91]
        c293v17.CallBack = c293v18
        c293v18 = { Name = nil, Description = "/Lotus/Language/Menu/ExitDojoDescription", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v18.Name = c293v1
        c293v20 = vT[1]
        c293v20 = c293v20.UI_MODE_IN_SPACE_HUB
        c293v21 = vT[1]
        c293v21 = c293v21.UI_MODE_IN_SPACE_SHIP
        c293v19 = {c293v20, c293v21}
        c293v18.DisplayIn = c293v19
        c293v19 = vT[91]
        c293v18.CallBack = c293v19
        c293v19 = function()
          local c275v0, c275v1, c275v2
          local p11 = 0
          if p11 == 0 then
            c275v0 = vT[134]
            c275v0 = c275v0()
            if not c275v0 then
              p11 = 8
            else
              p11 = 1
            end
          end
          if p11 == 1 then
            c275v1 = vT[139]
            c275v1 = c275v1()
            c275v0 = not c275v1
            if not c275v0 then
              p11 = 8
            else
              p11 = 2
            end
          end
          if p11 == 2 then
            c275v1 = vT[65]
            c275v1 = c275v1.IsStalkerHideout
            if c275v1 then
              p11 = 4
            else
              p11 = 3
            end
          end
          if p11 == 3 then
            c275v0 = true
            c275v1 = vT[23]
            c275v2 = vT[1]
            c275v2 = c275v2.UI_MODE_IN_SPACE_HUB
            if c275v1 == c275v2 then
              p11 = 8
            else
              p11 = 4
            end
          end
          if p11 == 4 then
            c275v0 = vT[65]
            c275v0 = c275v0.IsStalkerHideout
            if not c275v0 then
              p11 = 8
            else
              p11 = 5
            end
          end
          if p11 == 5 then
            c275v1 = vT[23]
            c275v2 = vT[1]
            c275v2 = c275v2.UI_MODE_IN_SPACE_SHIP
            if c275v1 == c275v2 then
              p11 = 7
            else
              p11 = 6
            end
          end
          if p11 == 6 then
            c275v0 = false
            p11 = 8
          end
          if p11 == 7 then
            c275v0 = true
            p11 = 8
          end
          if p11 == 8 then
            do return c275v0 end
          end
        end
        c293v18.ShouldDisplay = c293v19
        c293v19 = { Name = nil, DisplayIn = nil, ShouldDisplay = nil, Menu = nil }
        c293v19.Name = c293v1
        c293v21 = vT[1]
        c293v21 = c293v21.UI_MODE_IN_SPACE_SHIP
        c293v20 = {c293v21}
        c293v19.DisplayIn = c293v20
        c293v20 = function()
          local c276v0, c276v1, c276v2
          local p7 = 0
          if p7 == 0 then
            c276v1 = vT[65]
            c276v1 = c276v1.IsApartment
            if c276v1 then
              p7 = 3
            else
              p7 = 1
            end
          end
          if p7 == 1 then
            c276v0 = vT[65]
            c276v0 = c276v0.IsTailorShop
            if not c276v0 then
              p7 = 5
            else
              p7 = 2
            end
          end
          if p7 == 2 then
            c276v0 = false
            c276v1 = vT[65]
            c276v1 = c276v1.PlayerBootLocation
            c276v2 = 3
            if c276v1 == c276v2 then
              p7 = 5
            else
              p7 = 3
            end
          end
          if p7 == 3 then
            c276v1 = vT[139]
            c276v1 = c276v1()
            c276v0 = not c276v1
            if not c276v0 then
              p7 = 5
            else
              p7 = 4
            end
          end
          if p7 == 4 then
            c276v1 = vT[65]
            c276v1 = c276v1.IsParadoxPath
            c276v0 = not c276v1
            p7 = 5
          end
          if p7 == 5 then
            do return c276v0 end
          end
        end
        c293v19.ShouldDisplay = c293v20
        c293v21 = { Name = nil, Description = nil, DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v21.Name = c293v9
        c293v21.Description = c293v10
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_SPACE_SHIP
        c293v22 = {c293v23}
        c293v21.DisplayIn = c293v22
        c293v22 = vT[92]
        c293v21.CallBack = c293v22
        c293v22 = function()
          local c277v0
          c277v0 = c293v12
          do return c277v0 end
        end
        c293v21.ShouldDisplay = c293v22
        c293v22 = { Name = "/Lotus/Language/Menu/ReturnToShip", Description = nil, DisplayIn = nil, CallBack = nil }
        c293v22.Description = c293v11
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_SPACE_SHIP
        c293v23 = {c293v24}
        c293v22.DisplayIn = c293v23
        c293v23 = vT[93]
        c293v22.CallBack = c293v23
        c293v20 = {c293v21, c293v22}
        c293v19.Menu = c293v20
        c293v20 = { Name = "/Lotus/Language/Menu/QuitGameUpperCase", Description = "/Lotus/Language/Menu/MenuQuitGameDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v22 = vT[1]
        c293v22 = c293v22.UI_MODE_IN_SPACE_HUB
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_GAME
        c293v21 = {c293v22, c293v23}
        c293v20.DisplayIn = c293v21
        c293v21 = function()
          local c278v0, c278v1
          c278v1 = Engine.IsConsole
          c278v1 = c278v1()
          if not c278v1 then
            c278v1 = Engine.IsMobile
            c278v1 = c278v1()
          end
          c278v0 = not c278v1
          if c278v0 then
            c278v0 = vT[139]
            c278v0 = c278v0()
          end
          do return c278v0 end
        end
        c293v20.ShouldDisplay = c293v21
        c293v21 = vT[112]
        c293v20.CallBack = c293v21
        c293v21 = { Name = "/Lotus/Language/Menu/QuitGameUpperCase", Description = "/Lotus/Language/Menu/MenuQuitGameDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v23 = vT[1]
        c293v23 = c293v23.UI_MODE_IN_SPACE_SHIP
        c293v22 = {c293v23}
        c293v21.DisplayIn = c293v22
        c293v22 = function()
          local c279v0, c279v1
          c279v1 = Engine.IsConsole
          c279v1 = c279v1()
          if not c279v1 then
            c279v1 = Engine.IsMobile
            c279v1 = c279v1()
          end
          c279v0 = not c279v1
          if c279v0 then
            c279v1 = vT[65]
            c279v1 = c279v1.IsApartment
            c279v0 = not c279v1
            if not c279v0 then
              c279v0 = vT[65]
              c279v0 = c279v0.IsParadoxPath
            end
          end
          do return c279v0 end
        end
        c293v21.ShouldDisplay = c293v22
        c293v22 = vT[112]
        c293v21.CallBack = c293v22
        c293v22 = { Name = "/Lotus/Language/Menu/QuitGameUpperCase", Description = "/Lotus/Language/Menu/MenuQuitGameDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v24 = vT[1]
        c293v24 = c293v24.UI_MODE_IN_GAME
        c293v23 = {c293v24}
        c293v22.DisplayIn = c293v23
        c293v23 = function()
          local c280v0, c280v1, c280v2, c280v3, c280v4, c280v5, c280v7
          local c28 = -1
          repeat
            c280v1 = newWarQuestKeychain
            c280v2 = jadeShadowQuestKeyChain
            c280v3 = jadeShadow2QuestKeyChain
            c280v0 = {c280v1, c280v2, c280v3}
            c280v1 = false
            c280v2 = pairs
            c280v2, c280v3, c280v4 = c280v2(c280v0)
            for c280v5, c280v6 in c280v2, c280v3, c280v4 do
              c280v7 = vT[65]
              c280v7 = c280v7.ActiveQuest
              if c280v7 == c280v6 then
                c28 = 2
                break
              end
            end
            if c28 ~= -1 then break end
            break
          until true
          if c28 == 2 then
            c280v1 = true
          end
          if not c280v1 then
            c280v2 = false
            do return c280v2 end
          end
          c280v2 = nil
          c280v3 = vT[1]
          c280v3 = c280v3.IsInMission
          c280v3 = c280v3()
          if not c280v3 then
            c280v3 = false
            do return c280v3 end
          end
          c280v3 = gGameRules
          c280v3 = c280v3:GetMission()
          c280v2 = c280v3.keyChainName
          c280v3 = IsNull
          c280v3 = c280v3(c280v2)
          if c280v3 then
            c280v3 = false
            do return c280v3 end
          end
          c280v1 = false
          c280v3 = pairs
          c280v3, c280v4, c280v5 = c280v3(c280v0)
          if c280v2 == c280v7 then
            c280v1 = true
          end
          c280v5 = Engine.IsConsole
          c280v5 = c280v5()
          if not c280v5 then
            c280v5 = Engine.IsMobile
            c280v5 = c280v5()
          end
          c280v4 = not c280v5
          c280v3 = c280v4 and c280v1
          do return c280v3 end
        end
        c293v22.ShouldDisplay = c293v23
        c293v23 = vT[112]
        c293v22.CallBack = c293v23
        c293v23 = { Name = "/Lotus/Language/Menu/QuitGameUpperCase", Description = "/Lotus/Language/Menu/MenuQuitGameDescription", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v25 = vT[1]
        c293v25 = c293v25.UI_MODE_IN_GAME
        c293v24 = {c293v25}
        c293v23.DisplayIn = c293v24
        c293v24 = function()
          local c281v0, c281v1, c281v2, c281v3, c281v4
          c281v1 = vT[1]
          c281v1 = c281v1.IsInMission
          c281v1 = c281v1()
          if not c281v1 then
            c281v1 = false
            do return c281v1 end
          end
          c281v1 = gGameRules
          c281v1 = c281v1:GetMission()
          c281v0 = c281v1.keyChainName
          c281v2 = IsNull
          c281v2 = c281v2(c281v0)
          c281v1 = not c281v2
          if not c281v1 then
            c281v2 = modQuestKeyChain
            if c281v0 ~= c281v2 then
              c281v1 = false
            else
              c281v1 = true
            end
          end
          c281v2 = _T.InSimulacrum
          if c281v2 then
            c281v2 = _T.ArsenalOverride
          end
          c281v4 = Engine.IsConsole
          c281v4 = c281v4()
          if not c281v4 then
            c281v4 = Engine.IsMobile
            c281v4 = c281v4()
          end
          c281v3 = not c281v4
          if c281v3 then
            c281v3 = c281v1
            if c281v3 then
              c281v3 = c281v2
            end
          end
          do return c281v3 end
        end
        c293v23.ShouldDisplay = c293v24
        c293v24 = vT[112]
        c293v23.CallBack = c293v24
        c293v24 = { Name = "SIMULACRUM [TEST]", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v26 = vT[1]
        c293v26 = c293v26.UI_MODE_IN_SPACE_SHIP
        c293v25 = {c293v26}
        c293v24.DisplayIn = c293v25
        c293v25 = vT[71]
        c293v24.CallBack = c293v25
        c293v25 = function()
          local c282v0, c282v1
          local p7 = 0
          if p7 == 0 then
            c282v1 = vT[1]
            c282v1 = c282v1.IsDevServer
            c282v1 = c282v1()
            if c282v1 then
              p7 = 3
            else
              p7 = 1
            end
          end
          if p7 == 1 then
            c282v1 = vT[1]
            c282v1 = c282v1.IsTestServer
            c282v1 = c282v1()
            if c282v1 then
              p7 = 3
            else
              p7 = 2
            end
          end
          if p7 == 2 then
            c282v0 = vT[1]
            c282v0 = c282v0.IsLocalServer
            c282v0 = c282v0()
            if not c282v0 then
              p7 = 5
            else
              p7 = 3
            end
          end
          if p7 == 3 then
            c282v0 = gRegion
            c282v0 = c282v0:IsMaster()
            if not c282v0 then
              p7 = 5
            else
              p7 = 4
            end
          end
          if p7 == 4 then
            c282v0 = vT[70]
            c282v0 = c282v0()
            p7 = 5
          end
          if p7 == 5 then
            do return c282v0 end
          end
        end
        c293v24.ShouldDisplay = c293v25
        c293v25 = { Name = "UI Tools [TEST]", Description = "Tools for debugging UI issues on dev and test, but not retail", ShouldDisplay = nil, Menu = nil }
        c293v26 = function()
          local c283v0, c283v1
          local p7 = 0
          if p7 == 0 then
            c283v1 = vT[1]
            c283v1 = c283v1.IsDevServer
            c283v1 = c283v1()
            if c283v1 then
              p7 = 3
            else
              p7 = 1
            end
          end
          if p7 == 1 then
            c283v1 = vT[1]
            c283v1 = c283v1.IsTestServer
            c283v1 = c283v1()
            if c283v1 then
              p7 = 3
            else
              p7 = 2
            end
          end
          if p7 == 2 then
            c283v0 = vT[1]
            c283v0 = c283v0.IsLocalServer
            c283v0 = c283v0()
            if not c283v0 then
              p7 = 5
            else
              p7 = 3
            end
          end
          if p7 == 3 then
            c283v0 = gRegion
            c283v0 = c283v0:IsMaster()
            if not c283v0 then
              p7 = 5
            else
              p7 = 4
            end
          end
          if p7 == 4 then
            c283v0 = vT[70]
            c283v0 = c283v0()
            p7 = 5
          end
          if p7 == 5 then
            do return c283v0 end
          end
        end
        c293v25.ShouldDisplay = c293v26
        c293v27 = { Name = "UI Inspector", Description = "Detailed information on individual clips", CallBack = nil }
        c293v28 = vT[72]
        c293v27.CallBack = c293v28
        c293v26 = {c293v27}
        c293v25.Menu = c293v26
        c293v26 = { Name = "/Lotus/Language/Menu/RestartLevel", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v28 = vT[1]
        c293v28 = c293v28.UI_MODE_IN_GAME
        c293v27 = {c293v28}
        c293v26.DisplayIn = c293v27
        c293v27 = function()
          local c284v0, c284v1
          c284v0 = gRegion
          c284v0 = c284v0:GetLevelArgs()
          c284v1 = true
          c284v0.restartLevel = c284v1
          c284v1 = Engine.OpenLevel
          c284v1(c284v0)
          do return end
        end
        c293v26.CallBack = c293v27
        c293v27 = function()
          local c285v0, c285v2
          c285v0 = gGameRules
          c285v2 = gLotusLocalFightingGameRulesType
          c285v0 = c285v0:IsA(c285v2)
          do return c285v0 end
        end
        c293v26.ShouldDisplay = c293v27
        c293v27 = { Name = nil, DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v29 = "INIT SQUAD LINK ["
        c293v32 = GetConfigString
        c293v33 = "Relay.ScenarioOverride"
        c293v30 = c293v32(c293v33)
        c293v31 = "]"
        c293v28 = c293v29 .. c293v30 .. c293v31
        c293v27.Name = c293v28
        c293v29 = vT[1]
        c293v29 = c293v29.UI_MODE_IN_GAME
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_SPACE_SHIP
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_SPACE_HUB
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_DOJO
        c293v28 = {c293v29, c293v30, c293v31, c293v32}
        c293v27.DisplayIn = c293v28
        c293v28 = function()
          local c286v0
          c286v0 = false
          do return c286v0 end
        end
        c293v27.ShouldDisplay = c293v28
        c293v28 = function()
          local c287v0, c287v1, c287v2, c287v3, c287v4
          c287v3 = GetConfigString
          c287v4 = "Relay.ScenarioOverride"
          c287v1 = c287v3(c287v4)
          c287v2 = vT[1]
          c287v2 = c287v2.SCENARIO_BEACON_TAG
          c287v0 = c287v1 .. c287v2
          c287v1 = gGameRules
          c287v3 = Symbol
          c287v1:Name__83844de4(c287v3(c287v0))
          c287v1 = cjson.encode
          c287v2 = { scenarioLocation = nil }
          c287v3 = _T.PendingScenarioHubName
          c287v2.scenarioLocation = c287v3
          c287v1 = c287v1(c287v2)
          c287v2 = gMatchingService
          c287v2:SendSquadJsonMessage(c287v1)
          c287v2 = vT[83]
          c287v2()
          do return end
        end
        c293v27.CallBack = c293v28
        c293v28 = { Name = "SQUAD LINK DEBUG MENU", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v30 = vT[1]
        c293v30 = c293v30.UI_MODE_IN_GAME
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_SPACE_SHIP
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_SPACE_HUB
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_DOJO
        c293v29 = {c293v30, c293v31, c293v32, c293v33}
        c293v28.DisplayIn = c293v29
        c293v29 = function()
          local c288v0
          c288v0 = false
          do return c288v0 end
        end
        c293v28.ShouldDisplay = c293v29
        c293v29 = function()
          local c289v0
          c289v0 = _T.ShowScenarioDebugControls
          if c289v0 then
            c289v0 = _T.ShowScenarioDebugControls
            c289v0()
          end
          c289v0 = vT[83]
          c289v0()
          do return end
        end
        c293v28.CallBack = c293v29
        c293v29 = { Name = "TERMINATE SQUAD LINK", DisplayIn = nil, ShouldDisplay = nil, CallBack = nil }
        c293v31 = vT[1]
        c293v31 = c293v31.UI_MODE_IN_GAME
        c293v32 = vT[1]
        c293v32 = c293v32.UI_MODE_IN_SPACE_SHIP
        c293v33 = vT[1]
        c293v33 = c293v33.UI_MODE_IN_SPACE_HUB
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_DOJO
        c293v30 = {c293v31, c293v32, c293v33, c293v34}
        c293v29.DisplayIn = c293v30
        c293v30 = function()
          local c290v0
          c290v0 = false
          do return c290v0 end
        end
        c293v29.ShouldDisplay = c293v30
        c293v30 = function()
          local c291v0, c291v2
          c291v0 = gGameRules
          c291v2 = true
          c291v0:Name__9b0ffdbd(c291v2)
          c291v0 = vT[83]
          c291v0()
          do return end
        end
        c293v29.CallBack = c293v30
        c293v30 = { Name = "CHEAT MENU [DEV MODE]", DisplayIn = nil, CallBack = nil, ShouldDisplay = nil }
        c293v34 = vT[1]
        c293v34 = c293v34.UI_MODE_IN_GAME
        c293v35 = vT[1]
        c293v35 = c293v35.UI_MODE_IN_SPACE_SHIP
        c293v36 = vT[1]
        c293v36 = c293v36.UI_MODE_IN_SPACE_HUB
        c293v37 = vT[1]
        c293v37 = c293v37.UI_MODE_IN_DOJO
        c293v33 = {c293v34, c293v35, c293v36, c293v37}
        c293v30.DisplayIn = c293v33
        c293v33 = vT[129]
        c293v30.CallBack = c293v33
        c293v33 = function()
          local c292v0
          c292v0 = false
          do return c292v0 end
        end
        c293v30.ShouldDisplay = c293v33
        c293v16[49] = c293v17
        c293v16[50] = c293v18
        c293v16[51] = c293v19
        c293v16[52] = c293v20
        c293v16[53] = c293v21
        c293v16[54] = c293v22
        c293v16[55] = c293v23
        c293v16[56] = c293v24
        c293v16[57] = c293v25
        c293v16[58] = c293v26
        c293v16[59] = c293v27
        c293v16[60] = c293v28
        c293v16[61] = c293v29
        c293v16[62] = c293v30
        mMenuOptions = c293v16
        c293v16 = vT[120]
        c293v17 = mMenuOptions
        c293v16(c293v17)
        do return end
      end
    end
    do return end
  end
  vT[145] = function()
    local c294v0, c294v1
    c294v0 = _T
    c294v1 = false
    c294v0.UpdateHistory_FromLogin = c294v1
    c294v0 = updateHistoryMovie
    vT[63] = c294v0
    c294v0 = vT[84]
    c294v0()
    do return end
  end
  OpenUpdateHistory = vT[145]
  vT[145] = function()
    local c295v0, c295v1, c295v2, c295v3, c295v4, c295v5, c295v6, c295v7, c295v9, c295v10
    c295v0 = {}
    c295v3 = _T.MenuSelectedIndex
    c295v2 = #c295v3
    c295v3 = 0
    if c295v2 <= c295v3 then
      c295v1 = false
    else
      c295v1 = true
    end
    c295v4 = { Label = nil, CallBack = nil, CallOut = "MENU_CANCEL" }
    c295v6 = "/Lotus/Language/Menu/"
    c295v7 = vT[0]
    c295v7 = c295v7.Ternary
    c295v9 = "Global_Back"
    c295v10 = "Exit"
    c295v7 = c295v7(c295v1, c295v9, c295v10)
    c295v5 = c295v6 .. c295v7
    c295v4.Label = c295v5
    c295v5 = vT[83]
    c295v4.CallBack = c295v5
    c295v2 = table.insert
    c295v2(c295v0, c295v4)
    c295v2 = _T.SetButtons
    if c295v2 then
      c295v2 = _T.SetButtons
      c295v3 = mMovie
      c295v5 = getfenv
      c295v6 = 1
      c295v2(c295v3, c295v0, c295v5(c295v6))
    end
    do return end
  end
  vT[146] = function(c296v0)
    local c296v1, c296v2, c296v3, c296v4, c296v5, c296v6, c296v7, c296v9
    if c296v0 == nil then
      c296v0 = 0
    end
    c296v3 = vT[22]
    c296v3 = c296v3:GetHowManyElements()
    c296v2 = c296v3 - 1
    c296v3 = vT[22]
    c296v3 = c296v3.mForcedVerticalSeparation
    c296v1 = c296v2 * c296v3
    c296v3 = vT[43]
    c296v4 = vT[42]
    c296v2 = c296v3 - c296v4
    c296v1 = c296v1 + c296v2
    c296v1 = c296v1 + 100
    c296v2 = { x = 0, y = 0, width = 1680, height = 10 }
    vT[38] = c296v2
    c296v2 = vT[38]
    c296v3 = 20
    c296v2.y = c296v3
    c296v2 = vT[38]
    c296v4 = vT[22]
    c296v4 = c296v4.mInitialY
    c296v3 = c296v1 + c296v4
    c296v2.height = c296v3
    c296v2 = {}
    c296v3 = vT[36]
    c296v3 = c296v3.x
    c296v3 = c296v3:GetVal()
    c296v2.x = c296v3
    c296v3 = vT[36]
    c296v3 = c296v3.y
    c296v3 = c296v3:GetVal()
    c296v2.y = c296v3
    c296v3 = vT[36]
    c296v3 = c296v3.width
    c296v3 = c296v3:GetVal()
    c296v2.width = c296v3
    c296v3 = vT[36]
    c296v3 = c296v3.height
    c296v3 = c296v3:GetVal()
    c296v2.height = c296v3
    c296v3 = vT[81]
    c296v5 = vT[38]
    c296v6 = 0
    c296v7 = 0.15
    c296v9 = OnTransitionFrameCompleted
    c296v3(c296v2, c296v5, c296v6, c296v7, c296v0, c296v9)
    do return end
  end
  vT[147] = function()
    local c297v0, c297v1, c297v2, c297v3, c297v4
    c297v0 = Engine.IsMobile
    c297v0 = c297v0()
    if not c297v0 then
      do return end
    end
    c297v0 = gFlashMgr
    c297v2 = vT[0]
    c297v2 = c297v2.GetChatMovie
    c297v0 = c297v0:FindMovie(c297v2())
    c297v1 = IsNull
    c297v1 = c297v1(c297v0)
    if not c297v1 then
      c297v3 = "RefreshChatScale"
      c297v4 = ""
      c297v0:Execute(c297v3, c297v4)
    end
    do return end
  end
  OnTransitionFrameCompleted = vT[147]
  vT[147] = function(c298v0)
    do return end
  end
  OnQueueMovieLoaded = vT[147]
  vT[147] = function(c299v0)
    local c299v1, c299v2, c299v3, c299v4
    c299v1 = vT[77]
    c299v2 = false
    c299v1(c299v2)
    c299v1 = print
    c299v2 = "TopMenu: MovieLoaded"
    c299v1(c299v2)
    c299v2 = _T.BackgroundMovie
    c299v1 = IsNull
    c299v1 = c299v1(c299v2)
    if not c299v1 then
      c299v1 = _T.BackgroundMovie
      c299v3 = "ShowBlockingMessage"
      c299v4 = "0"
      c299v1:Execute(c299v3, c299v4)
    end
    c299v1 = IsNull
    c299v1 = c299v1(c299v0)
    if not c299v1 then
      vT[15] = c299v0
      c299v1 = vT[108]
      c299v1()
    end
    do return end
  end
  MovieLoaded = vT[147]
  vT[147] = function(c300v0)
    local c300v1, c300v2, c300v3, c300v4, c300v5, c300v6, c300v7, c300v8
    local p34 = 0
    if p34 == 0 then
      c300v2 = c300v0.RawName
      if c300v2 == nil then
        p34 = 2
      else
        p34 = 1
      end
    end
    if p34 == 1 then
      c300v1 = c300v0.RawName
      p34 = 8
    end
    if p34 == 2 then
      c300v2 = c300v0.Name
      if c300v2 == nil then
        p34 = 5
      else
        p34 = 3
      end
    end
    if p34 == 3 then
      c300v2 = string.match
      c300v3 = c300v0.Name
      c300v4 = "/Lotus/"
      c300v2 = c300v2(c300v3, c300v4)
      if not c300v2 then
        p34 = 5
      else
        p34 = 4
      end
    end
    if p34 == 4 then
      c300v1 = c300v0.Name
      p34 = 8
    end
    if p34 == 5 then
      c300v2 = c300v0.Description
      if c300v2 == nil then
        p34 = 8
      else
        p34 = 6
      end
    end
    if p34 == 6 then
      c300v2 = string.match
      c300v3 = c300v0.Description
      c300v4 = "/Lotus/"
      c300v2 = c300v2(c300v3, c300v4)
      if not c300v2 then
        p34 = 8
      else
        p34 = 7
      end
    end
    if p34 == 7 then
      c300v1 = c300v0.Description
      p34 = 8
    end
    if p34 == 8 then
      if c300v1 == nil then
        p34 = 22
      else
        p34 = 9
      end
    end
    if p34 == 9 then
      c300v2 = vT[23]
      c300v3 = string.gsub
      c300v5 = "/Lotus/Language/"
      c300v6 = ""
      c300v3 = c300v3(c300v1, c300v5, c300v6)
      c300v4 = ""
      c300v5 = vT[1]
      c300v5 = c300v5.UI_MODE_IN_GAME
      if c300v2 ~= c300v5 then
        p34 = 11
      else
        p34 = 10
      end
    end
    if p34 == 10 then
      c300v5 = "GAME_"
      c300v4 = c300v5 .. c300v3
      p34 = 20
    end
    if p34 == 11 then
      c300v5 = vT[1]
      c300v5 = c300v5.UI_MODE_IN_SPACE_SHIP
      if c300v2 ~= c300v5 then
        p34 = 15
      else
        p34 = 12
      end
    end
    if p34 == 12 then
      c300v5 = vT[65]
      c300v5 = c300v5.InCrewShip
      if c300v5 then
        p34 = 14
      else
        p34 = 13
      end
    end
    if p34 == 13 then
      c300v5 = "ORBITER_"
      c300v4 = c300v5 .. c300v3
      p34 = 20
    end
    if p34 == 14 then
      c300v5 = "RAILJACK_"
      c300v4 = c300v5 .. c300v3
      p34 = 20
    end
    if p34 == 15 then
      c300v5 = vT[1]
      c300v5 = c300v5.UI_MODE_IN_SPACE_HUB
      if c300v2 ~= c300v5 then
        p34 = 17
      else
        p34 = 16
      end
    end
    if p34 == 16 then
      c300v5 = "SPACE_HUB_"
      c300v4 = c300v5 .. c300v3
      p34 = 20
    end
    if p34 == 17 then
      c300v5 = vT[1]
      c300v5 = c300v5.UI_MODE_IN_DOJO
      if c300v2 ~= c300v5 then
        p34 = 19
      else
        p34 = 18
      end
    end
    if p34 == 18 then
      c300v5 = "DOJO_"
      c300v4 = c300v5 .. c300v3
      p34 = 20
    end
    if p34 == 19 then
      c300v4 = c300v3
      p34 = 20
    end
    if p34 == 20 then
      c300v6 = gGameStatsMgr
      c300v5 = IsNull
      c300v5 = c300v5(c300v6)
      if c300v5 then
        p34 = 22
      else
        p34 = 21
      end
    end
    if p34 == 21 then
      c300v5 = gGameStatsMgr
      c300v7 = Symbol
      c300v8 = "MENU_OPTION"
      c300v7 = c300v7(c300v8)
      c300v5:AddEvent(c300v7, c300v4)
      p34 = 22
    end
    if p34 == 22 then
      do return end
    end
  end
  vT[148] = function(c307v0, c307v1)
    local c307v2, c307v3
    c307v2 = c307v0.CallBack
    c307v3 = c307v0.CallBack
    if c307v3 ~= nil then
      c307v2 = function()
        local c301v0, c301v1
        c301v0 = c307v0
        c301v0 = c301v0.CallBack
        c301v1 = c307v0
        c301v1 = c301v1.CallBackParam
        c301v0(c301v1)
        c301v0 = vT[147]
        c301v1 = c307v0
        c301v0(c301v1)
        do return end
      end
    end
    c307v3 = c307v0.Menu
    if c307v3 ~= nil then
      c307v2 = function()
        local c302v0, c302v1, c302v2
        c302v1 = _T.MenuSelectedIndex
        c302v2 = c307v1
        c302v0 = table.insert
        c302v0(c302v1, c302v2)
        c302v0 = vT[29]
        c302v0()
        do return end
      end
      do return c307v2 end
    end
    c307v3 = c307v0.TargetMovie
    if c307v3 ~= nil then
      c307v2 = function()
        local c303v0, c303v1, c303v2, c303v3, c303v4
        c303v1 = _T.GetScreenRes
        c303v0 = IsNull
        c303v0 = c303v0(c303v1)
        if c303v0 then
          do return end
        end
        c303v0 = vT[147]
        c303v1 = 0
        if c303v1 < c303v0 then
          c303v0 = print
          c303v2 = "TopMenu: Tried to start async loading "
          c303v3 = c307v0
          c303v3 = c303v3.TargetMovie
          c303v4 = " while another movie is being loaded. Ignoring."
          c303v1 = c303v2 .. c303v3 .. c303v4
          c303v0(c303v1)
          do return end
        end
        c303v0 = _T.GetScreenRes
        c303v1 = c307v0
        c303v1 = c303v1.TargetMovie
        c303v0 = c303v0(c303v1)
        if c303v0 ~= nil then
          c303v2 = _T.BackgroundMovie
          c303v1 = IsNull
          c303v1 = c303v1(c303v2)
          if not c303v1 then
            c303v1 = _T.BackgroundMovie
            c303v3 = "ShowBlockingMessage"
            c303v4 = "1"
            c303v1:Execute(c303v3, c303v4)
          end
          c303v1 = vT[147]
          c303v2 = true
          c303v1(c303v2)
          c303v1 = print
          c303v3 = "TopMenu: Loading "
          c303v4 = c303v0:GetFullName()
          c303v2 = c303v3 .. c303v4
          c303v1(c303v2)
          c303v1 = mMovie
          c303v4 = "MovieLoaded"
          c303v1:directionalRetracted(c303v0, c303v4)
          c303v1 = c307v0
          c303v1 = c303v1.TargetMovieCallBack
          if c303v1 ~= nil then
            c303v1 = c307v0
            c303v1 = c303v1.TargetMovieCallBack
            c303v1()
          end
        end
        c303v1 = vT[147]
        c303v2 = c307v0
        c303v1(c303v2)
        do return end
      end
      do return c307v2 end
    end
    c307v3 = c307v0.QueueMovie
    if c307v3 ~= nil then
      c307v2 = function()
        local c304v0, c304v1, c304v2, c304v3, c304v4
        c304v1 = _T.GetScreenRes
        c304v0 = IsNull
        c304v0 = c304v0(c304v1)
        if c304v0 then
          do return end
        end
        c304v0 = _T.GetScreenRes
        c304v1 = c307v0
        c304v1 = c304v1.QueueMovie
        c304v0 = c304v0(c304v1)
        if c304v0 ~= nil then
          c304v1 = print
          c304v3 = "TopMenu: Queuing "
          c304v4 = c304v0:GetFullName()
          c304v2 = c304v3 .. c304v4
          c304v1(c304v2)
          vT[63] = c304v0
          c304v1 = vT[84]
          c304v1()
        end
        c304v1 = vT[147]
        c304v2 = c307v0
        c304v1(c304v2)
        do return end
      end
      do return c307v2 end
    end
    c307v3 = c307v0.TargetConsole
    if c307v3 ~= nil then
      c307v2 = function()
        local c305v0, c305v1, c305v2
        c305v0 = vT[147]
        c305v1 = c307v0
        c305v0(c305v1)
        c305v0 = vT[7]
        c305v0 = c305v0.SetupTargetConsole
        c305v1 = c307v0
        c305v2 = vT[64]
        c305v0 = c305v0(c305v1, c305v2)
        if c305v0 then
          c305v0 = vT[80]
          c305v0()
        end
        do return end
      end
      do return c307v2 end
    end
    c307v3 = c307v0.TargetContextMovie
    if c307v3 ~= nil then
      c307v2 = function()
        local c306v0, c306v1, c306v2
        c306v1 = _T.GetScreenRes
        c306v0 = IsNull
        c306v0 = c306v0(c306v1)
        if not c306v0 then
          c306v0 = c307v0
          c306v0 = c306v0.TargetContextMovie
          c306v0 = c306v0()
          c306v1 = _T.GetScreenRes
          c306v1 = c306v1(c306v0)
          if c306v1 ~= nil then
            c306v2 = mMovie
            c306v2 = c306v2:PushChildMovie(c306v1)
            vT[15] = c306v2
          end
        end
        c306v0 = vT[147]
        c306v1 = c307v0
        c306v0(c306v1)
        do return end
      end
    end
    do return c307v2 end
  end
  vT[29] = function()
    local c311v0, c311v1, c311v2, c311v3, c311v4, c311v5, c311v6, c311v7, c311v8, c311v9, c311v10, c311v11, c311v12, c311v13, c311v14, c311v15, c311v16, c311v17, c311v18, c311v19
    c311v0 = true
    vT[13] = c311v0
    c311v0 = vT[22]
    c311v0 = c311v0:GetHowManyElements()
    c311v1 = 0
    if c311v1 < c311v0 then
      c311v0 = vT[22]
      c311v2 = true
      c311v3 = true
      c311v0:RemoveElements(c311v2, c311v3)
    end
    c311v0 = mMenuOptions
    c311v1 = ipairs
    c311v2 = _T.MenuSelectedIndex
    c311v1, c311v2, c311v3 = c311v1(c311v2)
    for c311v4, c311v5 in c311v1, c311v2, c311v3 do
      c311v6 = c311v0[c311v5]
      c311v0 = c311v6.Menu
    end
    c311v1 = ipairs
    c311v1, c311v2, c311v3 = c311v1(c311v0)
    for c311v4, c311v5 in c311v1, c311v2, c311v3 do
      c311v6 = vT[148]
      c311v6 = c311v6(c311v5, c311v4)
      c311v8 = c311v5.Menu
      if c311v8 == nil then
        c311v7 = false
      else
        c311v7 = true
      end
      c311v8 = c311v5.Description
      c311v8 = ""
      c311v9 = ipairs
      c311v10 = c311v5.Menu
      c311v9, c311v10, c311v11 = c311v9(c311v10)
      for c311v12, c311v13 in c311v9, c311v10, c311v11 do
        c311v14 = 1
        if c311v14 < c311v12 then
          c311v15 = " / "
          c311v8 = c311v8 .. c311v15
        end
        c311v15 = mMovie
        c311v17 = c311v13.Name
        c311v18 = true
        c311v15 = c311v15:GetLocalized(c311v17, c311v18)
        c311v8 = c311v8 .. c311v15
      end
      for c311v12, c311v13 in c311v9, c311v10, c311v11 do
      end
      c311v9 = string.upper
      c311v10 = mMovie
      c311v12 = c311v5.Name
      c311v13 = true
      c311v9 = c311v9(c311v10:GetLocalized(c311v12, c311v13))
      c311v10 = Name__5699d9fb
      c311v12 = 1
      c311v10 = c311v10(c311v9, c311v12)
      if c311v10 == 3 then
        c311v14 = 1
        c311v12 = string.byte
        c311v12 = c311v12(c311v9, c311v14)
        c311v11 = c311v12 * 256
        c311v14 = 2
        c311v12 = string.byte
        c311v12 = c311v12(c311v9, c311v14)
        c311v10 = c311v11 + c311v12
        c311v11 = 57344
        if c311v11 <= c311v10 then
          c311v11 = 63743
          if c311v10 <= c311v11 then
            c311v11 = "<p><font ><font size=\"37\">"
            c311v18 = 1
            c311v19 = 3
            c311v16 = string.sub
            c311v12 = c311v16(c311v9, c311v18, c311v19)
            c311v13 = "</font>"
            c311v18 = 4
            c311v16 = string.sub
            c311v14 = c311v16(c311v9, c311v18)
            c311v15 = "</font></p>"
            c311v9 = c311v11 .. c311v12 .. c311v13 .. c311v14 .. c311v15
          end
        end
      end
      c311v10 = vT[22]
      c311v12 = { Name = nil, mHasSubSections = nil, Icon = nil, Description = nil, CallBack = nil, PreAction = nil, IsEnabled = nil, Update = nil }
      c311v12.Name = c311v9
      c311v12.mHasSubSections = c311v7
      c311v13 = c311v5.Icon
      c311v12.Icon = c311v13
      c311v13 = string.upper
      c311v14 = mMovie
      c311v17 = true
      c311v13 = c311v13(c311v14:GetLocalized(c311v8, c311v17))
      c311v12.Description = c311v13
      c311v12.CallBack = c311v6
      c311v13 = c311v5.PreAction
      c311v12.PreAction = c311v13
      c311v13 = c311v5.IsEnabled
      c311v12.IsEnabled = c311v13
      c311v13 = c311v5.Update
      c311v12.Update = c311v13
      c311v13 = true
      c311v10:AddElement(c311v12, c311v13)
    end
    c311v1 = print
    c311v2 = " ORIGINAL HEIGHT "
    c311v3 = vT[44]
    c311v1(c311v2, c311v3)
    c311v1 = vT[22]
    c311v1 = c311v1:GetHowManyElements()
    c311v2 = Clamp
    c311v5 = c311v1 - 10
    c311v4 = c311v5 * 7
    c311v3 = 100 - c311v4
    c311v4 = 50
    c311v5 = 100
    c311v2 = c311v2(c311v3, c311v4, c311v5)
    c311v3 = Engine.IsMobile
    c311v3 = c311v3()
    if c311v3 then
      c311v3 = vT[0]
      c311v3 = c311v3.Ternary
      c311v5 = 10
      if c311v1 <= c311v5 then
        c311v4 = false
      else
        c311v4 = true
      end
      c311v5 = 100
      c311v6 = 120
      c311v2 = c311v3(c311v4, c311v5, c311v6)
    end
    c311v3 = vT[44]
    vT[42] = c311v3
    c311v5 = vT[42]
    c311v6 = mMovie
    c311v8 = "MenuItem.Description"
    c311v9 = 41
    c311v6 = c311v6:GetNumberVariable(c311v8, c311v9)
    c311v4 = c311v5 + c311v6
    c311v3 = c311v4 + 3
    vT[43] = c311v3
    if c311v2 ~= 100 then
      c311v3 = vT[0]
      c311v3 = c311v3.Round
      c311v5 = vT[42]
      c311v6 = c311v2 / 100
      c311v4 = c311v5 * c311v6
      c311v3 = c311v3(c311v4)
      vT[42] = c311v3
      c311v3 = vT[0]
      c311v3 = c311v3.Round
      c311v5 = vT[43]
      c311v6 = c311v2 / 100
      c311v4 = c311v5 * c311v6
      c311v3 = c311v3(c311v4)
      vT[43] = c311v3
    end
    c311v3 = print
    c311v4 = " Unfocused height HEIGHT "
    c311v5 = vT[42]
    c311v3(c311v4, c311v5)
    c311v3 = vT[22]
    c311v3.mScale = c311v2
    c311v3 = vT[22]
    c311v5 = vT[42]
    c311v7 = 10
    c311v8 = c311v2 / 100
    c311v6 = c311v7 * c311v8
    c311v4 = c311v5 + c311v6
    c311v3.mForcedVerticalSeparation = c311v4
    c311v3 = print
    c311v4 = " Vertical separation "
    c311v5 = vT[22]
    c311v5 = c311v5.mForcedVerticalSeparation
    c311v3(c311v4, c311v5)
    c311v3 = vT[39]
    if c311v3 then
      c311v3 = vT[0]
      c311v3 = c311v3.PlaySound
      c311v4 = _G
      c311v4 = c311v4.UISound_GridOpen
      c311v3(c311v4)
    end
    c311v3 = vT[146]
    c311v3()
    c311v3 = vT[22]
    c311v3 = c311v3.mElementTransitionTime
    c311v4 = vT[22]
    c311v4 = c311v4.mElementDelayTime
    c311v5 = vT[55]
    if c311v5 ~= nil then
      c311v5 = vT[22]
      c311v6 = 0.01
      c311v5.mElementTransitionTime = c311v6
      c311v5 = vT[22]
      c311v6 = 0
      c311v5.mElementDelayTime = c311v6
    end
    c311v5 = vT[22]
    c311v7 = function()
      local c310v0, c310v1, c310v2, c310v3, c310v4
      c310v0 = vT[145]
      c310v2 = true
      c310v0:RepositionButtons(c310v2)
      c310v0 = vT[145]
      c310v2 = function(c308v0)
        local c308v1, c308v3, c308v4, c308v5
        if c308v0 ~= nil then
          c308v1 = c308v0.mClipName
          if c308v1 ~= nil then
            c308v1 = mMovie
            c308v3 = c308v0.mClipName
            c308v4 = 67
            c308v5 = true
            c308v1:Name__d9713943(c308v3, c308v4, c308v5)
          end
        end
        do return end
      end
      c310v0:RunForAllElements(c310v2)
      c310v0 = vT[145]
      c310v0()
      c310v0 = vT[55]
      if c310v0 ~= nil then
        c310v0 = vT[27]
        c310v2 = 0.3
        c310v3 = function()
          local c309v0, c309v1, c309v2
          c309v1 = vT[15]
          c309v0 = IsNull
          c309v0 = c309v0(c309v1)
          if not c309v0 then
            c309v0 = true
            vT[56] = c309v0
            c309v0 = vT[27]
            c309v2 = vT[57]
            c309v0:RemoveTimer(c309v2)
            c309v0 = nil
            vT[57] = c309v0
          end
          do return end
        end
        c310v4 = true
        c310v0 = c310v0:AddTimer(c310v2, c310v3, c310v4)
        vT[57] = c310v0
        c310v0 = vT[145]
        c310v2 = vT[55]
        c310v0:SelectElement(c310v2)
        c310v0 = vT[145]
        c310v1 = c311v3
        c310v0.mElementTransitionTime = c310v1
        c310v0 = vT[145]
        c310v1 = c311v4
        c310v0.mElementDelayTime = c310v1
        c310v0 = nil
        vT[55] = c310v0
      end
      do return end
    end
    c311v5:Redraw(c311v7)
    c311v5 = ShouldShowYareliChallenges
    c311v5 = c311v5()
    if c311v5 then
      c311v5 = vT[135]
      c311v5()
    end
    c311v5 = vT[1]
    c311v5 = c311v5.GetUIMode
    c311v5 = c311v5()
    c311v7 = gGameData
    c311v6 = IsNull
    c311v6 = c311v6(c311v7)
    for c311v4, c311v5 in c311v1, c311v2, c311v3 do
      local p80 = 36
      if p80 == 36 then
        c311v6 = vT[1]
        c311v6 = c311v6.UI_MODE_IN_SPACE_SHIP
        if c311v5 == c311v6 then
          p80 = 38
        else
          p80 = 37
        end
      end
      if p80 == 37 then
        c311v6 = vT[1]
        c311v6 = c311v6.UI_MODE_IN_SPACE_HUB
        if c311v5 ~= c311v6 then
        else
          p80 = 38
        end
      end
      if p80 == 38 then
        c311v6 = gGameData
        c311v6 = c311v6:Name__927457bb()
        c311v7 = 0
        if c311v7 < c311v6 then
        else
          p80 = 39
        end
      end
      if p80 == 39 then
        c311v6 = gGameData
        c311v8 = Symbol
        c311v9 = "MasteryRankTutorial"
        c311v6 = c311v6:HasCompletedNodeIntro(c311v8(c311v9))
        if c311v6 then
        else
          p80 = 40
        end
      end
      if p80 == 40 then
        c311v6 = vT[1]
        c311v6 = c311v6.HasCompletedVorsPrize
        c311v6 = c311v6()
        if not c311v6 then
        else
          p80 = 41
        end
      end
      if p80 == 41 then
        c311v6 = gGameData
        c311v6 = c311v6:Name__1d1bb34a()
        c311v7 = 1
        if c311v7 < c311v6 then
        else
          p80 = 42
        end
      end
      if p80 == 42 then
        c311v6 = vT[10]
        c311v6 = c311v6.StartTutorial
        c311v6()
      end
    end
    c311v6 = false
    vT[13] = c311v6
    do return end
  end
  vT[149] = function()
    local c312v0, c312v1, c312v3
    c312v0 = vT[56]
    if not c312v0 then
      c312v1 = vT[57]
      if c312v1 == nil then
        c312v0 = false
      else
        c312v0 = true
      end
    end
    c312v1 = false
    vT[56] = c312v1
    c312v1 = vT[57]
    if c312v1 ~= nil then
      c312v1 = vT[27]
      c312v3 = vT[57]
      c312v1:RemoveTimer(c312v3)
      c312v1 = nil
      vT[57] = c312v1
    end
    do return c312v0 end
  end
  DisableCloseWhenChildMovieIsDone = vT[149]
  vT[149] = function()
    local c313v0, c313v1, c313v2, c313v3, c313v4, c313v5, c313v6, c313v7, c313v8
    c313v0 = mMovie
    c313v2 = "ExitMenuTap"
    c313v3 = nil
    c313v4 = nil
    c313v5 = "ExitMenuReleaseCallback"
    c313v6 = nil
    c313v0:SetCallbacks(c313v2, c313v3, c313v4, c313v5, c313v6)
    c313v0 = mMovie
    c313v2 = "ExitMenuTap"
    c313v3 = "ExitMenuReleaseCallback"
    c313v0:SetReleaseOutsideCallback(c313v2, c313v3)
    c313v0 = { x = 0.8, y = 2.3 }
    c313v1 = vT[0]
    c313v1 = c313v1.TransformViewportToPixelCoordinates
    c313v2 = mMovie
    c313v3 = { x = 0.5, y = 0.1 }
    c313v1 = c313v1(c313v2, c313v3)
    c313v2 = mMovie
    c313v4 = "ExitMenuTap"
    c313v5 = 0
    c313v6 = c313v1.x
    c313v2:SetNumberVariable(c313v4, c313v5, c313v6)
    c313v2 = mMovie
    c313v4 = "ExitMenuTap"
    c313v5 = 1
    c313v6 = c313v1.y
    c313v2:SetNumberVariable(c313v4, c313v5, c313v6)
    c313v2 = mMovie
    c313v4 = "ExitMenuTap"
    c313v5 = 14
    c313v7 = mMovie
    c313v7 = c313v7:GetViewportWidth()
    c313v8 = c313v0.x
    c313v6 = c313v7 * c313v8
    c313v2:SetNumberVariable(c313v4, c313v5, c313v6)
    c313v2 = mMovie
    c313v4 = "ExitMenuTap"
    c313v5 = 15
    c313v7 = mMovie
    c313v7 = c313v7:GetViewportHeight()
    c313v8 = c313v0.y
    c313v6 = c313v7 * c313v8
    c313v2:SetNumberVariable(c313v4, c313v5, c313v6)
    do return end
  end
  vT[150] = function()
    local c326v0, c326v1, c326v2, c326v3, c326v4, c326v5, c326v6, c326v7, c326v8, c326v9
    c326v1 = mMovie
    c326v3 = "MenuItem.Label"
    c326v4 = 41
    c326v1 = c326v1:GetNumberVariable(c326v3, c326v4)
    c326v0 = c326v1 + 7
    vT[44] = c326v0
    c326v0 = require
    c326v1 = "EE.Interface.Components.List"
    c326v0 = c326v0(c326v1)
    c326v1 = c326v0.CreateList
    c326v2 = mMovie
    c326v3 = "MenuItem"
    c326v1 = c326v1(c326v2, c326v3)
    vT[22] = c326v1
    c326v1 = mMovie
    c326v3 = "ExitMenuTap"
    c326v4 = 67
    c326v5 = Engine.IsMobile
    c326v1:Name__d9713943(c326v3, c326v4, c326v5())
    c326v1 = Engine.IsMobile
    c326v1 = c326v1()
    if c326v1 then
      c326v1 = vT[5]
      c326v1 = c326v1.GetMovieAspectRatio
      c326v2 = mMovie
      c326v1 = c326v1(c326v2)
      c326v2 = 1.7
      if c326v1 <= c326v2 then
        c326v1 = vT[22]
        c326v2 = c326v1.mInitialX
        c326v2 = c326v2 + 280
        c326v1.mInitialX = c326v2
      end
      c326v1 = vT[22]
      c326v2 = c326v1.mInitialY
      c326v2 = c326v2 - 160
      c326v1.mInitialY = c326v2
      c326v1 = vT[149]
      c326v1()
    else
      c326v1 = vT[22]
      c326v3 = vT[22]
      c326v3 = c326v3.mInitialY
      c326v2 = c326v3 + 10
      c326v1.mInitialY = c326v2
    end
    c326v1 = vT[22]
    c326v2 = 0
    c326v1.mTransitionInDeltaY = c326v2
    c326v1 = vT[22]
    c326v2 = 0
    c326v1.mTransitionOutDeltaY = c326v2
    c326v1 = vT[22]
    c326v2 = 0.03
    c326v1.mElementDelayTime = c326v2
    c326v1 = vT[22]
    c326v2 = false
    c326v1.mWrapAroundNavigation = c326v2
    c326v1 = vT[22]
    c326v2 = 0
    c326v1.mForcedVerticalSeparation = c326v2
    c326v1 = vT[22]
    c326v3 = "MenuItemPressed"
    c326v4 = "MenuItemFocused"
    c326v5 = "MenuItemUnfocused"
    c326v6 = "MenuItemPressedDown"
    c326v7 = nil
    c326v8 = nil
    c326v9 = "MenuItemReleasedOutside"
    c326v1:SetCallbacks(c326v3, c326v4, c326v5, c326v6, c326v7, c326v8, c326v9)
    c326v1 = vT[22]
    c326v2 = function(c314v0)
      local c314v1, c314v2, c314v3, c314v4, c314v5, c314v6
      c314v1 = mMovie
      c314v4 = "Description"
      c314v5 = 14
      c314v6 = 1200
      c314v1:Name__52c1b74e(c314v0, c314v4, c314v5, c314v6)
      c314v1 = vT[0]
      c314v1 = c314v1.SetFitText
      c314v2 = mMovie
      c314v5 = ".Description"
      c314v3 = c314v0 .. c314v5
      c314v4 = "..."
      c314v1(c314v2, c314v3, c314v4)
      c314v1 = mMovie
      c314v5 = ".NewIndicator"
      c314v3 = c314v0 .. c314v5
      c314v4 = 13
      c314v5 = false
      c314v1:Name__d9713943(c314v3, c314v4, c314v5)
      do return end
    end
    c326v1.mClipCreatedCallback = c326v2
    c326v1 = vT[22]
    c326v2 = function(c315v0)
      local c315v1, c315v2, c315v3, c315v4, c315v5, c315v6, c315v7, c315v8, c315v9, c315v10
      c315v1 = vT[22]
      c315v1 = c315v1.PlaySound
      c315v2 = _G
      c315v2 = c315v2.UISound_Focus
      c315v1(c315v2)
      c315v1 = true
      c315v2 = c315v0.IsEnabled
      if c315v2 ~= nil then
        c315v1 = c315v0:IsEnabled()
      end
      if c315v1 then
        c315v2 = mMovie
        c315v4 = c315v0.mClipName
        c315v5 = "Label"
        c315v6 = 44
        c315v7 = vT[47]
        c315v7 = c315v7.TitleHighlight
        c315v2:Name__52c1b74e(c315v4, c315v5, c315v6, c315v7)
      end
      c315v2 = mMovie
      c315v5 = c315v0.mClipName
      c315v6 = ".Btn"
      c315v4 = c315v5 .. c315v6
      c315v5 = "RectEdgeColor"
      c315v6 = vT[47]
      c315v6 = c315v6.BorderHighlight
      c315v6 = c315v6.r
      c315v7 = vT[47]
      c315v7 = c315v7.BorderHighlight
      c315v7 = c315v7.g
      c315v8 = vT[47]
      c315v8 = c315v8.BorderHighlight
      c315v8 = c315v8.b
      c315v9 = 1
      c315v2:Name__e243d995(c315v4, c315v5, c315v6, c315v7, c315v8, c315v9)
      c315v2 = FlashInterpolate
      c315v3 = mMovie
      c315v5 = c315v0.mClipName
      c315v6 = ".Btn"
      c315v4 = c315v5 .. c315v6
      c315v5 = 2
      c315v7 = 14
      c315v8 = 15
      c315v6 = {c315v7, c315v8}
      c315v8 = c315v0.mFocusedBgWidth
      c315v9 = vT[43]
      c315v7 = {c315v8, c315v9}
      c315v8 = 0.25
      c315v2(c315v3, c315v4, c315v5, c315v6, c315v7, c315v8)
      c315v2 = FlashInterpolate
      c315v3 = mMovie
      c315v5 = c315v0.mClipName
      c315v6 = ".Description"
      c315v4 = c315v5 .. c315v6
      c315v5 = 2
      c315v7 = 12
      c315v8 = 1
      c315v6 = {c315v7, c315v8}
      c315v8 = 100
      c315v10 = vT[42]
      c315v9 = c315v10 - 3
      c315v7 = {c315v8, c315v9}
      c315v8 = 0.25
      c315v2(c315v3, c315v4, c315v5, c315v6, c315v7, c315v8)
      c315v2 = vT[22]
      c315v3 = c315v0.Id
      c315v2.FocusedId = c315v3
      c315v2 = vT[22]
      c315v2:RepositionButtons()
      do return end
    end
    c326v1.mOnFocusedCallback = c326v2
    c326v1 = vT[22]
    c326v2 = function(c316v0, c316v1)
      local c316v2, c316v3, c316v4, c316v5, c316v6, c316v7, c316v8, c316v9, c316v10, c316v11, c316v12
      c316v2 = vT[0]
      c316v2 = c316v2.Ternary
      c316v4 = 0
      c316v5 = 0.25
      c316v2 = c316v2(c316v1, c316v4, c316v5)
      c316v3 = true
      c316v4 = c316v0.IsEnabled
      if c316v4 ~= nil then
        c316v3 = c316v0:IsEnabled()
      end
      c316v5 = c316v0.mClipName
      c316v4 = IsNull
      c316v4 = c316v4(c316v5)
      if c316v4 then
        do return end
      end
      if c316v3 then
        c316v4 = mMovie
        c316v6 = c316v0.mClipName
        c316v7 = "Label"
        c316v8 = 44
        c316v9 = vT[47]
        c316v9 = c316v9.Title
        c316v4:Name__52c1b74e(c316v6, c316v7, c316v8, c316v9)
      end
      c316v4 = mMovie
      c316v7 = c316v0.mClipName
      c316v8 = ".Btn"
      c316v6 = c316v7 .. c316v8
      c316v7 = "RectEdgeColor"
      c316v8 = vT[47]
      c316v8 = c316v8.Border
      c316v8 = c316v8.r
      c316v9 = vT[47]
      c316v9 = c316v9.Border
      c316v9 = c316v9.g
      c316v10 = vT[47]
      c316v10 = c316v10.Border
      c316v10 = c316v10.b
      c316v11 = 0.2
      c316v4:Name__e243d995(c316v6, c316v7, c316v8, c316v9, c316v10, c316v11)
      c316v4 = FlashInterpolate
      c316v5 = mMovie
      c316v7 = c316v0.mClipName
      c316v8 = ".Btn"
      c316v6 = c316v7 .. c316v8
      c316v7 = 2
      c316v9 = 14
      c316v10 = 15
      c316v8 = {c316v9, c316v10}
      c316v10 = c316v0.mUnfocusedBgWidth
      c316v11 = vT[42]
      c316v9 = {c316v10, c316v11}
      c316v10 = 0.25
      c316v4(c316v5, c316v6, c316v7, c316v8, c316v9, c316v10)
      c316v4 = FlashInterpolate
      c316v5 = mMovie
      c316v7 = c316v0.mClipName
      c316v8 = ".Description"
      c316v6 = c316v7 .. c316v8
      c316v7 = 2
      c316v9 = 12
      c316v10 = 1
      c316v8 = {c316v9, c316v10}
      c316v10 = 0
      c316v12 = vT[42]
      c316v11 = c316v12 - 17
      c316v9 = {c316v10, c316v11}
      c316v4(c316v5, c316v6, c316v7, c316v8, c316v9, c316v2)
      c316v4 = vT[22]
      c316v5 = nil
      c316v4.FocusedId = c316v5
      if not c316v1 then
        c316v4 = _T.TopMenuCancelled
        if not c316v4 then
          c316v4 = vT[22]
          c316v4:RepositionButtons()
        end
      end
      do return end
    end
    c326v1.mOnUnfocusedCallback = c326v2
    c326v1 = vT[22]
    c326v2 = function(c317v0)
      local c317v1, c317v2, c317v3, c317v4
      c317v1 = vT[0]
      c317v1 = c317v1.isDragging
      if c317v1 then
        do return end
      end
      c317v2 = c317v0.CallBack
      c317v1 = IsNull
      c317v1 = c317v1(c317v2)
      if not c317v1 then
        c317v1 = c317v0.IsEnabled
        if c317v1 ~= nil then
          c317v1 = c317v0:IsEnabled()
          if not c317v1 then
            c317v1 = vT[0]
            c317v1 = c317v1.PlaySound
            c317v2 = _G
            c317v2 = c317v2.UISound_Error
            c317v1(c317v2)
            do return end
          end
        end
        c317v2 = vT[15]
        c317v1 = IsNull
        c317v1 = c317v1(c317v2)
        if not c317v1 then
          c317v1 = vT[15]
          c317v3 = "IgnoreParentCloseRequest"
          c317v4 = ""
          c317v1 = c317v1:Execute(c317v3, c317v4)
          if not c317v1 then
            c317v1 = vT[15]
            c317v1:Close()
          end
        end
        c317v2 = vT[17]
        c317v1 = IsNull
        c317v1 = c317v1(c317v2)
        if not c317v1 then
          c317v1 = vT[17]
          c317v3 = "IgnoreParentCloseRequest"
          c317v4 = ""
          c317v1 = c317v1:Execute(c317v3, c317v4)
          if not c317v1 then
            c317v1 = vT[17]
            c317v1:Close()
          end
        end
        c317v1 = vT[0]
        c317v1 = c317v1.PlaySound
        c317v2 = _G
        c317v2 = c317v2.UISound_Select
        c317v1(c317v2)
        c317v1 = vT[0]
        c317v1 = c317v1.PlaySound
        c317v2 = _G
        c317v2 = c317v2.UISound_ButtonSelect
        c317v1(c317v2)
        c317v2 = c317v0.PreAction
        c317v1 = IsNull
        c317v1 = c317v1(c317v2)
        if not c317v1 then
          c317v1 = c317v0.PreAction
          c317v1()
        end
        c317v1 = c317v0.CallBack
        c317v2 = c317v0.CallBackParam
        c317v1(c317v2)
      end
      do return end
    end
    c326v1.mOnSelectedCallback = c326v2
    c326v1 = vT[22]
    c326v2 = function(c318v0)
      local c318v1, c318v2, c318v3, c318v4, c318v5, c318v6, c318v7, c318v8
      c318v1 = mMovie
      c318v3 = c318v0.mClipName
      c318v4 = "Label"
      c318v5 = 44
      c318v6 = vT[47]
      c318v6 = c318v6.Title
      c318v1:Name__52c1b74e(c318v3, c318v4, c318v5, c318v6)
      c318v1 = mMovie
      c318v3 = c318v0.mClipName
      c318v4 = "Description"
      c318v5 = 44
      c318v6 = vT[47]
      c318v6 = c318v6.Subtitle
      c318v1:Name__52c1b74e(c318v3, c318v4, c318v5, c318v6)
      c318v1 = mMovie
      c318v4 = c318v0.mClipName
      c318v5 = ".Btn"
      c318v3 = c318v4 .. c318v5
      c318v4 = "RectInnerColor"
      c318v5 = vT[47]
      c318v5 = c318v5.Backer
      c318v5 = c318v5.r
      c318v6 = vT[47]
      c318v6 = c318v6.Backer
      c318v6 = c318v6.g
      c318v7 = vT[47]
      c318v7 = c318v7.Backer
      c318v7 = c318v7.b
      c318v8 = 0.6
      c318v1:Name__e243d995(c318v3, c318v4, c318v5, c318v6, c318v7, c318v8)
      c318v1 = mMovie
      c318v4 = c318v0.mClipName
      c318v5 = ".Label.text"
      c318v3 = c318v4 .. c318v5
      c318v4 = c318v0.Name
      c318v1:SetLocalized(c318v3, c318v4)
      c318v1 = mMovie
      c318v4 = c318v0.mClipName
      c318v5 = ".Description.text"
      c318v3 = c318v4 .. c318v5
      c318v4 = c318v0.Description
      c318v1:SetLocalized(c318v3, c318v4)
      c318v1 = mMovie
      c318v3 = c318v0.mClipName
      c318v4 = "Label"
      c318v5 = 5
      c318v6 = vT[22]
      c318v6 = c318v6.mScale
      c318v1:Name__52c1b74e(c318v3, c318v4, c318v5, c318v6)
      c318v1 = mMovie
      c318v3 = c318v0.mClipName
      c318v4 = "Label"
      c318v5 = 6
      c318v6 = vT[22]
      c318v6 = c318v6.mScale
      c318v1:Name__52c1b74e(c318v3, c318v4, c318v5, c318v6)
      c318v1 = mMovie
      c318v3 = c318v0.mClipName
      c318v4 = "Description"
      c318v5 = 5
      c318v6 = vT[22]
      c318v6 = c318v6.mScale
      c318v1:Name__52c1b74e(c318v3, c318v4, c318v5, c318v6)
      c318v1 = mMovie
      c318v3 = c318v0.mClipName
      c318v4 = "Description"
      c318v5 = 6
      c318v6 = vT[22]
      c318v6 = c318v6.mScale
      c318v1:Name__52c1b74e(c318v3, c318v4, c318v5, c318v6)
      c318v1 = Engine.IsMobile
      c318v1 = c318v1()
      if c318v1 then
        c318v1 = vT[69]
        c318v1 = c318v1.UpdateBreadcrumb
        c318v1(c318v0)
      end
      c318v1 = UpdateUnclaimedClanReward
      c318v1(c318v0)
      c318v2 = mMovie
      c318v5 = c318v0.mClipName
      c318v6 = ".Label"
      c318v4 = c318v5 .. c318v6
      c318v5 = 40
      c318v2 = c318v2:GetNumberVariable(c318v4, c318v5)
      c318v1 = c318v2 + 16
      c318v0.mUnfocusedBgWidth = c318v1
      c318v2 = c318v0.mUnfocusedBgWidth
      c318v4 = mMovie
      c318v7 = c318v0.mClipName
      c318v8 = ".Description"
      c318v6 = c318v7 .. c318v8
      c318v7 = 40
      c318v4 = c318v4:GetNumberVariable(c318v6, c318v7)
      c318v3 = c318v4 + 24
      c318v1 = math.max
      c318v1 = c318v1(c318v2, c318v3)
      c318v0.mFocusedBgWidth = c318v1
      c318v1 = vT[22]
      c318v1 = c318v1.mScale
      if c318v1 ~= 100 then
        c318v1 = vT[51]
        c318v1 = c318v1.Round
        c318v3 = c318v0.mUnfocusedBgWidth
        c318v5 = vT[22]
        c318v5 = c318v5.mScale
        c318v4 = c318v5 / 100
        c318v2 = c318v3 * c318v4
        c318v1 = c318v1(c318v2)
        c318v0.mUnfocusedBgWidth = c318v1
        c318v1 = vT[51]
        c318v1 = c318v1.Round
        c318v3 = c318v0.mFocusedBgWidth
        c318v5 = vT[22]
        c318v5 = c318v5.mScale
        c318v4 = c318v5 / 100
        c318v2 = c318v3 * c318v4
        c318v1 = c318v1(c318v2)
        c318v0.mFocusedBgWidth = c318v1
      end
      c318v1 = vT[22]
      c318v1 = c318v1.mOnUnfocusedCallback
      c318v3 = true
      c318v1(c318v0, c318v3)
      c318v1 = mMovie
      c318v4 = c318v0.mClipName
      c318v5 = ".Btn"
      c318v3 = c318v4 .. c318v5
      c318v4 = vT[51]
      c318v4 = c318v4.Ternary
      c318v5 = vT[51]
      c318v6 = _G
      c318v6 = c318v6.UIMaterial_Rectangle
      c318v7 = _G
      c318v7 = c318v7.UIMaterial_RectangleNoDepth
      c318v1:OverrideMaterial(c318v3, c318v4(c318v5, c318v6, c318v7))
      do return end
    end
    c326v1.mElementDrawCallback = c326v2
    c326v1 = vT[22]
    c326v2 = function(c319v0, c319v1)
      local c319v2, c319v4, c319v5, c319v6, c319v7
      c319v2 = mMovie
      c319v4 = c319v1.mClipName
      c319v5 = 0
      c319v7 = c319v0.mInitialX
      c319v6 = c319v7 + 100
      c319v2:SetNumberVariable(c319v4, c319v5, c319v6)
      c319v2 = mMovie
      c319v4 = c319v1.mClipName
      c319v5 = 4
      c319v6 = -2000
      c319v2:SetNumberVariable(c319v4, c319v5, c319v6)
      do return end
    end
    c326v1.SetupPreInterpolationValues = c326v2
    c326v1 = vT[22]
    c326v2 = function(c320v0, c320v1)
      local c320v2, c320v3, c320v4, c320v5, c320v6
      c320v3 = 12
      c320v4 = 0
      c320v5 = 4
      c320v2 = {c320v3, c320v4, c320v5}
      c320v4 = 100
      c320v5 = c320v0.mInitialX
      c320v6 = 0
      c320v3 = {c320v4, c320v5, c320v6}
      do return c320v2, c320v3 end
    end
    c326v1.GetInterpolationProperties = c326v2
    c326v1 = vT[22]
    c326v2 = function(c323v0, c323v1)
      local c323v2, c323v3, c323v4, c323v5
      c323v2 = vT[0]
      c323v2 = c323v2.Ternary
      c323v4 = 0
      c323v5 = 0.25
      c323v2 = c323v2(c323v1, c323v4, c323v5)
      c323v3 = vT[22]
      c323v5 = function(c322v0)
        local c322v1, c322v2, c322v3, c322v4, c322v5, c322v6, c322v7, c322v8, c322v9, c322v10
        c322v1 = c322v0.mClipName
        if c322v1 ~= nil then
          c322v1 = mMovie
          c322v3 = c322v0.mClipName
          c322v4 = 1
          c322v1 = c322v1:GetNumberVariable(c322v3, c322v4)
          c322v2 = c323v2
          c322v2 = c322v2:CalculateY(c322v0)
          c322v3 = function(c321v0)
            local c321v1, c321v3, c321v4, c321v5, c321v6, c321v7
            c321v1 = c322v0
            c321v1 = c321v1.mClipName
            if c321v1 ~= nil then
              c321v1 = mMovie
              c321v3 = c322v0
              c321v3 = c321v3.mClipName
              c321v4 = 1
              c321v5 = Lerp
              c321v6 = c322v1
              c321v7 = c322v2
              c321v1:SetNumberVariable(c321v3, c321v4, c321v5(c321v6, c321v7, c321v0))
            end
            do return end
          end
          c322v4 = FlashInterpolate
          c322v5 = mMovie
          c322v7 = c322v0.mClipName
          c322v8 = ".Label"
          c322v6 = c322v7 .. c322v8
          c322v7 = 2
          c322v8 = {c322v3}
          c322v10 = 1
          c322v9 = {c322v10}
          c322v10 = c323v2
          c322v4(c322v5, c322v6, c322v7, c322v8, c322v9, c322v10)
        end
        do return end
      end
      c323v3:RunForAllElements(c323v5)
      do return end
    end
    c326v1.RepositionButtons = c326v2
    c326v1 = vT[22]
    c326v2 = vT[22]
    c326v2 = c326v2.CalculateY
    c326v1._LoadOutList_CalculateY = c326v2
    c326v1 = vT[22]
    c326v2 = function(c324v0, c324v1)
      local c324v2, c324v3, c324v4, c324v5
      c324v2 = c324v0:_LoadOutList_CalculateY(c324v1)
      c324v3 = vT[43]
      c324v3 = c324v3.FocusedId
      if c324v3 ~= nil then
        c324v3 = c324v1.Id
        c324v4 = vT[43]
        c324v4 = c324v4.FocusedId
        if c324v4 < c324v3 then
          c324v4 = vT[43]
          c324v5 = vT[42]
          c324v3 = c324v4 - c324v5
          c324v2 = c324v2 + c324v3
        end
      end
      c324v3 = c324v2 + 1
      do return c324v3 end
    end
    c326v1.CalculateY = c326v2
    c326v1 = vT[22]
    c326v2 = function(c325v0, c325v1)
      local c325v2, c325v4, c325v5, c325v6
      c325v2 = mMovie
      c325v4 = c325v1.mClipName
      c325v5 = 67
      c325v6 = false
      c325v2:Name__d9713943(c325v4, c325v5, c325v6)
      do return end
    end
    c326v1.OnElementTransitionStarted = c326v2
    do return end
  end
  vT[151] = function()
    local c327v0, c327v1, c327v2, c327v3, c327v4, c327v5
    local p8 = 0
    if p8 == 0 then
      c327v0 = vT[24]
      if not c327v0 then
        p8 = 7
      else
        p8 = 1
      end
    end
    if p8 == 1 then
      c327v0 = vT[78]
      c327v0 = c327v0()
      if not c327v0 then
        p8 = 7
      else
        p8 = 2
      end
    end
    if p8 == 2 then
      c327v0 = true
      vT[60] = c327v0
      c327v0 = vT[24]
      c327v0 = c327v0:InventoryControl()
      c327v0:StopWeapons()
      c327v0 = vT[24]
      c327v0 = c327v0:InventoryControl()
      c327v0:StopMelee()
      c327v0 = vT[24]
      c327v0 = c327v0:InputControl()
      c327v2 = 118
      c327v0:ClearMelee(c327v2)
      c327v0 = vT[24]
      c327v0 = c327v0:InputControl()
      c327v2 = 259
      c327v0:ClearMelee(c327v2)
      c327v0 = vT[24]
      c327v2 = avatarAnimation
      c327v3 = true
      c327v4 = 2
      c327v5 = 3
      c327v0:PlayNonReplicatedAnimation(c327v2, c327v3, c327v4, c327v5)
      c327v0 = _T.TopMenuCancelled
      if c327v0 then
        p8 = 5
      else
        p8 = 3
      end
    end
    if p8 == 3 then
      c327v0 = _T.TopMenuOpen
      if not c327v0 then
        p8 = 5
      else
        p8 = 4
      end
    end
    if p8 == 4 then
      c327v1 = vT[24]
      c327v0 = IsNull
      c327v0 = c327v0(c327v1)
      if not c327v0 then
        p8 = 6
      else
        p8 = 5
      end
    end
    if p8 == 5 then
      do return end
    end
    if p8 == 6 then
      c327v0 = vT[24]
      c327v2 = avatarAnimationLoop
      c327v3 = false
      c327v4 = 2
      c327v5 = 2
      c327v0:PlayNonReplicatedAnimation(c327v2, c327v3, c327v4, c327v5)
      p8 = 7
    end
    if p8 == 7 then
      do return end
    end
  end
  TransitionAnims = vT[151]
  vT[151] = function(c328v0)
    local c328v1, c328v2, c328v4, c328v5, c328v6, c328v7, c328v8
    c328v2 = vT[35]
    c328v1 = c328v2[1]
    c328v2 = IsNull
    c328v2 = c328v2(c328v1)
    if c328v2 then
      do return end
    end
    c328v4 = Lotus_Game.EMISSIVE_MAP_ATTEN
    c328v5 = c328v0 * 10
    c328v6 = 0
    c328v7 = 0
    c328v8 = 0
    c328v1:SetMaterialParam(c328v4, c328v5, c328v6, c328v7, c328v8)
    do return end
  end
  vT[152] = function(c329v0)
    local c329v1, c329v2, c329v3, c329v4, c329v5, c329v6, c329v7, c329v8, c329v9, c329v10, c329v11, c329v12, c329v13
    c329v1 = vT[14]
    if not c329v1 then
      do return end
    end
    c329v1 = RealDeltaTime
    c329v0 = c329v1()
    c329v1 = vT[36]
    c329v1 = c329v1.x
    c329v1:Update(c329v0)
    c329v1 = vT[36]
    c329v1 = c329v1.y
    c329v1:Update(c329v0)
    c329v1 = vT[36]
    c329v1 = c329v1.width
    c329v1:Update(c329v0)
    c329v1 = vT[36]
    c329v1 = c329v1.height
    c329v1:Update(c329v0)
    c329v2 = vT[36]
    c329v2 = c329v2.x
    c329v2 = c329v2:GetVal()
    c329v4 = vT[36]
    c329v4 = c329v4.x
    c329v4 = c329v4:GetVal()
    c329v5 = vT[36]
    c329v5 = c329v5.width
    c329v5 = c329v5:GetVal()
    c329v3 = c329v4 + c329v5
    c329v5 = vT[36]
    c329v5 = c329v5.x
    c329v5 = c329v5:GetVal()
    c329v4 = c329v5 + 320
    c329v1 = {c329v2, c329v3, c329v4}
    c329v3 = vT[36]
    c329v3 = c329v3.y
    c329v3 = c329v3:GetVal()
    c329v4 = vT[36]
    c329v4 = c329v4.y
    c329v4 = c329v4:GetVal()
    c329v6 = vT[36]
    c329v6 = c329v6.y
    c329v6 = c329v6:GetVal()
    c329v7 = vT[36]
    c329v7 = c329v7.height
    c329v7 = c329v7:GetVal()
    c329v5 = c329v6 + c329v7
    c329v2 = {c329v3, c329v4, c329v5}
    c329v3 = nil
    c329v6 = vT[35]
    c329v5 = c329v6[1]
    c329v4 = IsNull
    c329v4 = c329v4(c329v5)
    if not c329v4 then
      c329v4 = Clamp
      c329v6 = vT[46]
      c329v7 = c329v0 * 3
      c329v5 = c329v6 + c329v7
      c329v6 = 0
      c329v7 = 1
      c329v4 = c329v4(c329v5, c329v6, c329v7)
      vT[46] = c329v4
    end
    c329v6 = 1
    c329v4 = 3
    c329v5 = 1
    for c329v6 = c329v6, c329v4, c329v5 do
      c329v9 = vT[35]
      c329v8 = c329v9[c329v6]
      c329v7 = IsNull
      c329v7 = c329v7(c329v8)
      if not c329v7 then
        c329v7 = mMovie
        c329v10 = c329v1[c329v6]
        c329v12 = math.random
        c329v12 = c329v12()
        c329v11 = c329v12 * 0.1
        c329v9 = c329v10 + c329v11
        c329v10 = c329v2[c329v6]
        c329v3 = c329v7:Name__3565d54e(c329v9, c329v10)
        c329v8 = vT[35]
        c329v7 = c329v8[c329v6]
        c329v7:SetPosition(c329v3)
        c329v8 = vT[35]
        c329v7 = c329v8[c329v6]
        c329v9 = vT[46]
        c329v7:SetMeshScale(c329v9)
      end
    end
    c329v5 = vT[36]
    c329v5 = c329v5.height
    c329v5 = c329v5:GetVal()
    c329v6 = mMovie
    c329v6 = c329v6:GetMovieHeight()
    c329v4 = c329v5 / c329v6
    c329v7 = vT[36]
    c329v7 = c329v7.y
    c329v7 = c329v7:GetVal()
    c329v8 = mMovie
    c329v8 = c329v8:GetMovieHeight()
    c329v6 = c329v7 / c329v8
    c329v7 = c329v4 / 2
    c329v5 = c329v6 + c329v7
    c329v6 = mMovie
    c329v8 = "Tile"
    c329v9 = "VisibilityCenter"
    c329v11 = 0
    c329v12 = 0
    c329v13 = 0
    c329v6:Name__e243d995(c329v8, c329v9, c329v5, c329v11, c329v12, c329v13)
    c329v6 = mMovie
    c329v8 = "BlackBacker"
    c329v9 = "VisibilityCenter"
    c329v11 = 0
    c329v12 = 0
    c329v13 = 0
    c329v6:Name__e243d995(c329v8, c329v9, c329v5, c329v11, c329v12, c329v13)
    c329v6 = mMovie
    c329v8 = "Tile"
    c329v9 = "VisibilitySize"
    c329v11 = 0
    c329v12 = 0
    c329v13 = 0
    c329v6:Name__e243d995(c329v8, c329v9, c329v4, c329v11, c329v12, c329v13)
    c329v6 = mMovie
    c329v8 = "BlackBacker"
    c329v9 = "VisibilitySize"
    c329v11 = 0
    c329v12 = 0
    c329v13 = 0
    c329v6:Name__e243d995(c329v8, c329v9, c329v4, c329v11, c329v12, c329v13)
    do return end
  end
  vT[153] = function()
    local c330v0, c330v1, c330v2, c330v3, c330v4, c330v5, c330v6, c330v7, c330v8, c330v9, c330v10, c330v11, c330v12, c330v13, c330v14
    c330v0 = vT[24]
    c330v2 = holoProjectorType
    c330v1 = IsNull
    c330v1 = c330v1(c330v2)
    if not c330v1 then
      c330v2 = vT[35]
      c330v1 = #c330v2
      if c330v1 == 0 then
        c330v1 = c330v0:GetView()
        c330v3 = c330v1.heading
        c330v2 = c330v3 + 200
        c330v1.heading = c330v2
        c330v2 = vT[24]
        c330v4 = Symbol
        c330v5 = "GAME_L1_WEAPON1"
        c330v2 = c330v2:GetBonePosition(c330v4(c330v5))
        c330v5 = 1
        c330v3 = 3
        c330v4 = 1
        for c330v5 = c330v5, c330v3, c330v4 do
          c330v6 = gRegion
          c330v8 = vT[0]
          c330v8 = c330v8.Ternary
          if c330v5 ~= 1 then
            c330v9 = false
          else
            c330v9 = true
          end
          c330v10 = holoProjectorTypeBottom
          c330v11 = vT[0]
          c330v11 = c330v11.Ternary
          if c330v5 ~= 2 then
            c330v12 = false
          else
            c330v12 = true
          end
          c330v13 = holoProjectorTypeTopRight
          c330v14 = holoProjectorType
          c330v8 = c330v8(c330v9, c330v10, c330v11(c330v12, c330v13, c330v14))
          c330v11 = vT[24]
          c330v6 = c330v6:CreateEntity(c330v8, c330v2, c330v1, c330v11)
          c330v8 = c330v2.y
          c330v7 = c330v8 + 0.05
          c330v2.y = c330v7
          c330v7 = IsNull
          c330v7 = c330v7(c330v6)
          if not c330v7 then
            c330v9 = true
            c330v6:SetDrawOnTop(c330v9)
            c330v9 = 0.0001
            c330v6:SetMeshScale(c330v9)
            c330v8 = vT[35]
            c330v7 = table.insert
            c330v7(c330v8, c330v6)
          end
        end
        c330v3 = vT[24]
        c330v5 = Symbol
        c330v6 = "GAME_L1_WEAPON1"
        c330v1 = c330v3:GetBoneRotation(c330v5(c330v6))
        c330v3 = vT[24]
        c330v5 = Symbol
        c330v6 = "GAME_L1_WEAPON1"
        c330v3 = c330v3:GetBonePosition(c330v5(c330v6))
        c330v4 = RotateVector
        c330v5 = Vector
        c330v6 = 0.12
        c330v7 = 0
        c330v8 = 0
        c330v5 = c330v5(c330v6, c330v7, c330v8)
        c330v4 = c330v4(c330v5, c330v1)
        c330v2 = c330v3 + c330v4
        c330v3 = vT[24]
        c330v5 = handProjectionEffect
        c330v6 = Symbol
        c330v7 = "GAME_L1_WEAPON1"
        c330v3 = c330v3:Attach(c330v5, c330v6(c330v7))
        vT[45] = c330v3
      end
    end
    do return end
  end
  vT[154] = function()
    local c335v0, c335v1, c335v2, c335v3, c335v4
    c335v0 = mMovie
    c335v2 = "_root"
    c335v3 = 12
    c335v4 = 0
    c335v0:SetNumberVariable(c335v2, c335v3, c335v4)
    c335v0 = function(c331v0)
      local c331v1, c331v2, c331v3, c331v4, c331v5, c331v6, c331v7, c331v8, c331v9
      c331v1 = c331v0
      c331v4 = 0.001
      c331v2 = math.max
      c331v1 = c331v2(c331v1, c331v4)
      c331v2 = Name__1058e7b6
      c331v3 = 4
      c331v4 = 1
      c331v6 = Time
      c331v6 = c331v6()
      c331v5 = c331v6 * 0.2
      c331v6 = 0.5
      c331v2 = c331v2(c331v3, c331v4, c331v5, c331v6)
      c331v3 = math.abs
      c331v3 = c331v3(c331v2)
      c331v4 = 1 - c331v0
      c331v2 = c331v3 * c331v4
      c331v4 = _G
      c331v4 = c331v4.UIMaterial_Diegetic
      c331v3 = IsNull
      c331v3 = c331v3(c331v4)
      if not c331v3 then
        c331v3 = _G
        c331v3 = c331v3.UIMaterial_Diegetic
        c331v5 = Symbol
        c331v6 = "PixelateBias"
        c331v5 = c331v5(c331v6)
        c331v6 = 1
        c331v9 = 0.5
        c331v7 = math.pow
        c331v7 = c331v7(c331v0, c331v9)
        c331v8 = 1
        c331v9 = c331v2 * 0.1
        c331v3:SetParam(c331v5, c331v6, c331v7, c331v8, c331v9)
      end
      c331v4 = _G
      c331v4 = c331v4.UIMaterial_SmoothEdge
      c331v3 = IsNull
      c331v3 = c331v3(c331v4)
      if not c331v3 then
        c331v3 = _G
        c331v3 = c331v3.UIMaterial_SmoothEdge
        c331v5 = Symbol
        c331v6 = "PixelateBias"
        c331v5 = c331v5(c331v6)
        c331v6 = 1
        c331v9 = 0.5
        c331v7 = math.pow
        c331v7 = c331v7(c331v0, c331v9)
        c331v8 = 1
        c331v9 = c331v2 * 0.1
        c331v3:SetParam(c331v5, c331v6, c331v7, c331v8, c331v9)
      end
      do return end
    end
    c335v1 = vT[27]
    c335v3 = 0.01
    c335v4 = function()
      local c334v0, c334v1, c334v2, c334v3, c334v4, c334v5, c334v6, c334v7, c334v8
      c334v0 = c335v0
      if c334v0 then
        c334v0 = c335v0
        c334v0()
      end
      c334v0 = FlashInterpolate
      c334v1 = mMovie
      c334v2 = "_root"
      c334v3 = 2
      c334v5 = 12
      c334v6 = c335v0
      c334v4 = {c334v5, c334v6}
      c334v6 = 100
      c334v7 = 1
      c334v5 = {c334v6, c334v7}
      c334v6 = 0
      c334v7 = 0.25
      c334v8 = function()
        local c332v0, c332v2, c332v3, c332v4, c332v5, c332v6
        c332v0 = vT[29]
        c332v0()
        c332v0 = _G
        c332v0 = c332v0.UIMaterial_SmoothEdge
        c332v2 = Symbol
        c332v3 = "PixelateBias"
        c332v2 = c332v2(c332v3)
        c332v3 = 1
        c332v4 = 1
        c332v5 = 1
        c332v6 = 0
        c332v0:SetParam(c332v2, c332v3, c332v4, c332v5, c332v6)
        c332v0 = true
        vT[39] = c332v0
        do return end
      end
      c334v0(c334v1, c334v2, c334v3, c334v4, c334v5, c334v6, c334v7, c334v8)
      c334v0 = vT[27]
      c334v2 = 0.1
      c334v3 = function()
        local c333v0, c333v1
        c333v0 = vT[0]
        c333v0 = c333v0.PlaySound
        c333v1 = _G
        c333v1 = c333v1.UISound_Open
        c333v0(c333v1)
        do return end
      end
      c334v0:AddTimer(c334v2, c334v3)
      do return end
    end
    c335v1:AddTimer(c335v3, c335v4)
    do return end
  end
  vT[155] = function()
    local c337v0, c337v1, c337v2, c337v3, c337v4, c337v5, c337v6, c337v7, c337v8, c337v9, c337v10, c337v11, c337v12, c337v13, c337v14, c337v15, c337v16, c337v17, c337v18, c337v19
    c337v0 = false
    vT[39] = c337v0
    c337v0 = _T
    c337v1 = nil
    c337v0.TopMenuCancelled = c337v1
    c337v0 = {}
    vT[59] = c337v0
    c337v0 = vT[24]
    c337v0 = c337v0:InventoryControl()
    c337v2 = vT[24]
    c337v1 = IsNull
    c337v1 = c337v1(c337v2)
    c337v1 = c337v0:GetActivePowerSuit()
    c337v2 = IsNull
    c337v2 = c337v2(c337v1)
    c337v2 = ipairs
    c337v3 = largeWarframes
    c337v2, c337v3, c337v4 = c337v2(c337v3)
    for c337v5, c337v6 in c337v2, c337v3, c337v4 do
      c337v7 = c337v1:IsA(c337v6)
    end
    if c337v1 then
      c337v7 = ipairs
      c337v8 = attachmentsToDissolve
      c337v7, c337v8, c337v9 = c337v7(c337v8)
      for c337v10, c337v11 in c337v7, c337v8, c337v9 do
        c337v12 = vT[24]
        c337v12 = c337v12:GetAllAttachments(c337v11)
        c337v15 = 1
        c337v13 = #c337v12
        c337v14 = 1
        for c337v15 = c337v15, c337v13, c337v14 do
          c337v17 = vT[59]
          c337v18 = { Attachment = nil, InitialDissolve = nil, CurrentDissolve = nil }
          c337v19 = c337v12[c337v15]
          c337v18.Attachment = c337v19
          c337v19 = c337v12[c337v15]
          c337v19 = c337v19:GetDissolve()
          c337v18.InitialDissolve = c337v19
          c337v19 = c337v12[c337v15]
          c337v19 = c337v19:GetDissolve()
          c337v18.CurrentDissolve = c337v19
          c337v16 = table.insert
          c337v16(c337v17, c337v18)
        end
      end
    end
    if c337v1 then
      c337v2 = ipairs
      c337v3 = attachmentsToDissolveOnAll
      c337v2, c337v3, c337v4 = c337v2(c337v3)
      for c337v5, c337v6 in c337v2, c337v3, c337v4 do
        c337v7 = vT[24]
        c337v7 = c337v7:GetAllAttachments(c337v6)
        c337v10 = 1
        c337v8 = #c337v7
        c337v9 = 1
        for c337v10 = c337v10, c337v8, c337v9 do
          c337v12 = vT[59]
          c337v13 = { Attachment = nil, InitialDissolve = nil, CurrentDissolve = nil }
          c337v14 = c337v7[c337v10]
          c337v13.Attachment = c337v14
          c337v14 = c337v7[c337v10]
          c337v14 = c337v14:GetDissolve()
          c337v13.InitialDissolve = c337v14
          c337v14 = c337v7[c337v10]
          c337v14 = c337v14:GetDissolve()
          c337v13.CurrentDissolve = c337v14
          c337v11 = table.insert
          c337v11(c337v12, c337v13)
        end
      end
    end
    local p61 = 14
    if p61 == 14 then
      c337v1 = vT[74]
      c337v2 = 1
      c337v1(c337v2)
      c337v2 = avatarAnimation
      c337v1 = IsNull
      c337v1 = c337v1(c337v2)
      if c337v1 then
        p61 = 26
      else
        p61 = 15
      end
    end
    if p61 == 15 then
      c337v1 = vT[51]
      if not c337v1 then
        p61 = 19
      else
        p61 = 16
      end
    end
    if p61 == 16 then
      c337v1 = vT[24]
      c337v3 = Symbol
      c337v4 = "TransitionAnims"
      c337v3 = c337v3(c337v4)
      c337v4 = false
      c337v1:Name__a50e34c3(c337v3, c337v4)
      c337v1 = vT[24]
      c337v1 = c337v1:GetDrawOnTop()
      if not c337v1 then
        p61 = 18
      else
        p61 = 17
      end
    end
    if p61 == 17 then
      c337v1 = _T.LoginDrawingOnTop
      if not c337v1 then
        p61 = 19
      else
        p61 = 18
      end
    end
    if p61 == 18 then
      c337v1 = vT[24]
      c337v3 = true
      c337v1:SetDrawOnTop(c337v3)
      c337v1 = true
      vT[52] = c337v1
      c337v1 = _T
      c337v2 = nil
      c337v1.LoginDrawingOnTop = c337v2
      p61 = 19
    end
    if p61 == 19 then
      c337v1 = vT[1]
      c337v1 = c337v1.IsInGamePlay
      c337v1 = c337v1()
      if not c337v1 then
        p61 = 25
      else
        p61 = 20
      end
    end
    if p61 == 20 then
      c337v3 = gGameRules
      c337v2 = IsNull
      c337v2 = c337v2(c337v3)
      c337v1 = not c337v2
      if not c337v1 then
        p61 = 25
      else
        p61 = 21
      end
    end
    if p61 == 21 then
      c337v2 = gGameRules
      c337v4 = gLotusPhotoBoothGameRulesType
      c337v2 = c337v2:IsA(c337v4)
      c337v1 = not c337v2
      if not c337v1 then
        p61 = 25
      else
        p61 = 22
      end
    end
    if p61 == 22 then
      c337v2 = gMatchingService
      c337v2 = c337v2:IsHost()
      if not c337v2 then
        p61 = 24
      else
        p61 = 23
      end
    end
    if p61 == 23 then
      c337v2 = gGameRules
      c337v4 = gLotusDuelGameRulesType
      c337v2 = c337v2:IsA(c337v4)
      p61 = 24
    end
    if p61 == 24 then
      c337v1 = not c337v2
      p61 = 25
    end
    if p61 == 25 then
      vT[32] = c337v1
      c337v1 = vT[27]
      c337v3 = vT[0]
      c337v3 = c337v3.Ternary
      c337v4 = vT[51]
      c337v5 = 0.8
      c337v6 = 0.1
      c337v3 = c337v3(c337v4, c337v5, c337v6)
      c337v4 = function()
        local c336v0, c336v1
        c336v0 = vT[32]
        if c336v0 then
          c336v0 = gGameRules
          c336v0:RequestPause()
          c336v0 = false
          vT[32] = c336v0
          c336v0 = vT[33]
          if c336v0 then
            c336v1 = gGameRules
            c336v0 = IsNull
            c336v0 = c336v0(c336v1)
            if not c336v0 then
              c336v0 = gGameRules
              c336v0 = c336v0:Paused()
              if c336v0 then
                c336v0 = _T
                c336v1 = false
                c336v0.Transmissions_Visible = c336v1
              end
            end
          end
        end
        do return end
      end
      c337v1:AddTimer(c337v3, c337v4)
      p61 = 26
    end
    if p61 == 26 then
      c337v2 = cameraSpot
      c337v1 = IsNull
      c337v1 = c337v1(c337v2)
      if c337v1 then
        p61 = 39
      else
        p61 = 27
      end
    end
    if p61 == 27 then
      c337v2 = vT[24]
      c337v1 = IsNull
      c337v1 = c337v1(c337v2)
      if c337v1 then
        p61 = 39
      else
        p61 = 28
      end
    end
    if p61 == 28 then
      c337v1 = vT[51]
      if not c337v1 then
        p61 = 39
      else
        p61 = 29
      end
    end
    if p61 == 29 then
      c337v1 = vT[24]
      c337v1 = c337v1:CameraControl()
      c337v2 = vT[23]
      c337v3 = vT[1]
      c337v3 = c337v3.UI_MODE_IN_SPACE_SHIP
      if c337v2 == c337v3 then
        p61 = 31
      else
        p61 = 30
      end
    end
    if p61 == 30 then
      c337v2 = vT[23]
      c337v3 = vT[1]
      c337v3 = c337v3.UI_MODE_IN_SPACE_HUB
      if c337v2 ~= c337v3 then
        p61 = 33
      else
        p61 = 31
      end
    end
    if p61 == 31 then
      c337v2 = c337v1:GetCameraSpot()
      vT[26] = c337v2
      c337v3 = vT[26]
      c337v2 = IsNull
      c337v2 = c337v2(c337v3)
      if c337v2 then
        p61 = 33
      else
        p61 = 32
      end
    end
    if p61 == 32 then
      c337v4 = nil
      c337v5 = 0
      c337v1:SetCameraSpot(c337v4, c337v5)
      p61 = 33
    end
    if p61 == 33 then
      c337v2 = IsNull
      c337v2 = c337v2(c337v1)
      if c337v2 then
        p61 = 39
      else
        p61 = 34
      end
    end
    if p61 == 34 then
      c337v2 = vT[24]
      c337v2 = c337v2:InventoryControl()
      c337v2 = c337v2:IsSpaceMode()
      if not c337v2 then
        p61 = 36
      else
        p61 = 35
      end
    end
    if p61 == 35 then
      c337v2 = vT[24]
      c337v4 = vT[24]
      c337v4 = c337v4:GetPosition()
      c337v5 = Rotation
      c337v6 = -55
      c337v7 = -2
      c337v8 = 0
      c337v2:Teleport(c337v4, c337v5(c337v6, c337v7, c337v8))
      p61 = 36
    end
    if p61 == 36 then
      c337v2 = vT[24]
      c337v4 = cameraSpot
      c337v5 = EMPTY_SYMBOL
      c337v6 = Vector
      c337v7 = -0.75
      c337v8 = 1.65
      c337v9 = -0.22
      c337v6 = c337v6(c337v7, c337v8, c337v9)
      c337v7 = Rotation
      c337v8 = 55
      c337v9 = 2
      c337v10 = 0
      c337v2 = c337v2:Attach(c337v4, c337v5, c337v6, c337v7(c337v8, c337v9, c337v10))
      vT[25] = c337v2
      c337v2 = 1
      c337v4 = gGameRules
      c337v3 = IsNull
      c337v3 = c337v3(c337v4)
      if c337v3 then
        p61 = 38
      else
        p61 = 37
      end
    end
    if p61 == 37 then
      c337v3 = gGameRules
      c337v2 = c337v3:GetCurrentSlomoMultiplier()
      p61 = 38
    end
    if p61 == 38 then
      c337v5 = vT[25]
      c337v6 = c337v2 * 0.1
      c337v1:SetCameraSpot(c337v5, c337v6)
      p61 = 39
    end
    if p61 == 39 then
      c337v1 = vT[154]
      c337v1()
      c337v1 = vT[145]
      c337v1()
      do return end
    end
  end
  vT[156] = function()
    local c338v0
    c338v0 = mMovie
    c338v0:Close()
    do return end
  end
  HideForBigPic = vT[156]
  vT[156] = function(c339v0)
    local c339v1, c339v2, c339v3, c339v4, c339v5
    c339v1 = tonumber
    c339v1 = c339v1(c339v0)
    c339v2 = 4
    if c339v1 == c339v2 then
      c339v1 = Script.GetStatsMgr
      c339v1 = c339v1()
      c339v3 = "Frame"
      c339v4 = "Up"
      c339v5 = false
      c339v1:SetStatVisibility(c339v3, c339v4, c339v5)
      c339v1 = gPlayerProfileMgr
      c339v1:LogOut()
      c339v1 = Engine.Disconnect
      c339v2 = true
      c339v1(c339v2)
    end
    c339v1 = mMovie
    c339v1:Close()
    do return end
  end
  MainMenuConfirmBasic = vT[156]
  vT[156] = function(c340v0)
    local c340v1, c340v2
    vT[18] = c340v0
    c340v1 = vT[77]
    c340v2 = false
    c340v1(c340v2)
    do return end
  end
  StatusMovieLoaded = vT[156]
  vT[156] = function(c341v0)
    local c341v1, c341v2, c341v3, c341v4, c341v5
    c341v1 = WeakResource
    c341v2 = "/Lotus/Powersuits/Yareli/YareliBaseSuit"
    c341v1 = c341v1(c341v2)
    c341v2 = WeakResource
    c341v3 = "/Lotus/Powersuits/Yareli/Abilities/YareliBoardAbility"
    c341v2 = c341v2(c341v3)
    c341v3 = IsNull
    c341v3 = c341v3(c341v0)
    if not c341v3 then
      c341v3 = c341v0:InventoryControl()
      c341v4 = IsNull
      c341v4 = c341v4(c341v3)
      if not c341v4 then
        c341v4 = c341v3:GetActivePowerSuit()
        c341v5 = IsNull
        c341v5 = c341v5(c341v4)
        if not c341v5 then
          c341v5 = c341v4:IsA(c341v1)
          if c341v5 then
            c341v5 = IsNull
            c341v5 = c341v5(c341v4:Name__d95ac037(c341v2))
            if not c341v5 then
              c341v5 = true
              do return c341v5 end
            end
          end
        end
      end
    end
    c341v3 = false
    do return c341v3 end
  end
  vT[157] = function()
    local c342v0, c342v1, c342v2, c342v3, c342v4, c342v5, c342v6, c342v7
    c342v2 = _T.MenuSelectedIndex
    c342v1 = #c342v2
    c342v2 = 0
    if c342v1 <= c342v2 then
      c342v0 = false
    else
      c342v0 = true
    end
    if c342v0 then
      c342v1 = false
      do return c342v1 end
    end
    c342v1 = vT[1]
    c342v1 = c342v1.GetActiveQuest
    c342v2 = gGameData
    c342v1 = c342v1(c342v2)
    c342v2 = IsNull
    c342v2 = c342v2(c342v1)
    if c342v2 < c342v1 then
      c342v4 = yareliQuest
      c342v2 = c342v1:IsA(c342v4)
      if c342v2 then
        c342v3 = vT[23]
        c342v4 = vT[1]
        c342v4 = c342v4.UI_MODE_IN_SPACE_SHIP
        if c342v3 ~= c342v4 then
          c342v2 = false
        else
          c342v2 = true
        end
        c342v3 = vT[23]
        c342v4 = vT[1]
        c342v4 = c342v4.UI_MODE_IN_GAME
        if c342v3 == c342v4 then
          c342v4 = gGameRules
          c342v3 = IsNull
          c342v3 = c342v3(c342v4)
          if not c342v3 then
            c342v3 = _T.InSimulacrum
            if not c342v3 then
              c342v3 = gGameRules
              c342v3 = c342v3:GetMission()
              c342v3 = c342v3.location
              c342v4 = gRegion
              c342v4 = c342v4:GetLocalPlayer()
              c342v5 = c342v4:GetAvatar()
              c342v6 = vT[156]
              c342v6 = c342v6(c342v5)
              if not c342v6 then
                c342v6 = true
                c342v7 = vT[1]
                c342v7 = c342v7.PLAINS_NODE_TAG
                if c342v3 ~= c342v7 then
                  c342v6 = true
                  c342v7 = vT[1]
                  c342v7 = c342v7.ORB_VALLIS_NODE_TAG
                  if c342v3 ~= c342v7 then
                    c342v7 = vT[1]
                    c342v7 = c342v7.ENTRATI_LANDSCAPE_NODE_TAG
                    if c342v3 ~= c342v7 then
                      c342v6 = false
                    else
                      c342v6 = true
                    end
                  end
                end
              end
              c342v2 = c342v6
            end
          end
        end
        c342v3 = false
        c342v4 = _T.CurrentYareliChallenges
        if c342v4 ~= nil then
          c342v3 = c342v2
        end
        do return c342v3 end
      end
    end
    do return end
  end
  CanShowYareliChallenges = vT[157]
  vT[157] = function()
    local c343v0
    c343v0 = _T.HideYareliChallenges
    if c343v0 ~= nil then
      c343v0 = false
      do return c343v0 end
    end
    c343v0 = CanShowYareliChallenges
    c343v0 = c343v0()
    do return c343v0 end
  end
  ShouldShowYareliChallenges = vT[157]
  vT[157] = function(c344v0)
    local c344v1, c344v2
    vT[12] = c344v0
    c344v1 = vT[77]
    c344v2 = false
    c344v1(c344v2)
    do return end
  end
  EpisodeStatusLoaded = vT[157]
  vT[157] = function()
    local c345v0, c345v1, c345v2, c345v3, c345v4, c345v5, c345v6, c345v7, c345v8, c345v9
    c345v0 = false
    vT[13] = c345v0
    c345v0 = ShouldShowYareliChallenges
    c345v0 = c345v0()
    if c345v0 then
      c345v0 = vT[135]
      c345v0()
    end
    c345v0 = true
    vT[14] = c345v0
    c345v1 = _G
    c345v1 = c345v1.UIMovie_SolarMap
    c345v0 = IsNull
    c345v0 = c345v0(c345v1)
    if not c345v0 then
      c345v0 = gFlashMgr
      c345v2 = _G
      c345v2 = c345v2.UIMovie_SolarMap
      c345v0 = c345v0:FindMovie(c345v2)
      c345v1 = IsNull
      c345v1 = c345v1(c345v0)
      if not c345v1 then
        c345v3 = "OnTopMenuOpened"
        c345v4 = ""
        c345v0:Execute(c345v3, c345v4)
      end
    end
    c345v0 = mMovie
    c345v0 = c345v0:GetViewportWidth()
    c345v1 = mMovie
    c345v1 = c345v1:GetViewportHeight()
    c345v2 = c345v0 / c345v1
    c345v3 = Engine.IsMobile
    c345v3 = c345v3()
    if c345v3 then
      c345v3 = 1.6
      if c345v2 < c345v3 then
        c345v3 = HandleIpadScaleIOS
        c345v3()
      end
      c345v3 = vT[23]
      c345v4 = vT[1]
      c345v4 = c345v4.UI_MODE_IN_SPACE_SHIP
      if c345v3 == c345v4 then
        c345v3 = vT[1]
        c345v3 = c345v3.HasCompletedVorsPrize
        c345v3 = c345v3()
        if c345v3 then
          c345v4 = mMenuOptions
          c345v3 = IsNull
          c345v3 = c345v3(c345v4)
          if not c345v3 then
            c345v3 = _T.OpeningMailbox
            if not c345v3 then
              c345v3 = vT[121]
              c345v4 = mMenuOptions
              c345v5 = "/Lotus/Language/Menu/MenuStore"
              c345v3 = c345v3(c345v4, c345v5)
              c345v4 = IsNull
              c345v4 = c345v4(c345v3)
              if not c345v4 then
                c345v4 = vT[77]
                c345v5 = true
                c345v4(c345v5)
                c345v4 = mMovie
                c345v6 = marketHighlightMovieRes
                c345v7 = "MarketingHighlightMovieLoaded"
                c345v4:directionalRetracted(c345v6, c345v7)
              end
            end
          end
        end
      end
    end
    c345v3 = vT[23]
    c345v4 = vT[1]
    c345v4 = c345v4.UI_MODE_IN_GAME
    if c345v3 == c345v4 then
      c345v3 = gRegion
      c345v3 = c345v3:GetLocalPlayer()
      c345v4 = IsNull
      c345v4 = c345v4(c345v3)
      if not c345v4 then
        c345v5 = c345v3:GetLoadOut()
        c345v5 = c345v5.mActiveBoons
        c345v4 = #c345v5
        c345v5 = 0
        if c345v5 < c345v4 then
          c345v5 = gFlashMgr
          c345v7 = boonsActiveMovie
          c345v5 = c345v5:FindMovie(c345v7)
          c345v6 = IsNull
          c345v6 = c345v6(c345v5)
          if not c345v6 then
            c345v5:Close()
          end
          c345v7 = mMovie
          c345v6 = IsNull
          c345v6 = c345v6(c345v7)
          if not c345v6 then
            c345v6 = mMovie
            c345v8 = boonsActiveMovie
            c345v5 = c345v6:PushChildMovie(c345v8)
            c345v6 = IsNull
            c345v6 = c345v6(c345v5)
            if not c345v6 then
              c345v8 = "FromPause"
              c345v9 = ""
              c345v5:Execute(c345v8, c345v9)
            end
          end
        end
      end
    end
    do return end
  end
  FinishInitialize = vT[157]
  vT[157] = function()
    local c347v0, c347v1, c347v2, c347v3, c347v4, c347v5, c347v6, c347v7, c347v8, c347v9, c347v10, c347v11, c347v12, c347v13, c347v14, c347v16, c347v17
    c347v10 = gGameRules
    c347v9 = IsNull
    c347v9 = c347v9(c347v10)
    c347v9 = gGameRules
    c347v9 = c347v9:GetMission()
    c347v8 = c347v9.keyChainName
    c347v10 = c347v9.levelKeyName
    c347v11 = IsNull
    c347v11 = c347v11(c347v10)
    c347v11 = ipairs
    c347v12 = demoKeys
    c347v11, c347v12, c347v13 = c347v11(c347v12)
    for c347v14, c347v15 in c347v11, c347v12, c347v13 do
      c347v0 = _T.MuseumCloseCallback
      if c347v0 then
        c347v0 = _T.MuseumCloseCallback
        c347v0()
        c347v0 = mMovie
        c347v0:Close()
        do return end
      end
      c347v0 = _T.CancelReplay
      if c347v0 then
        c347v0 = _T.CancelReplay
        c347v0 = c347v0()
        if c347v0 then
          c347v0 = mMovie
          c347v0:Close()
          do return end
        end
      end
      c347v0 = vT[73]
      c347v0()
      c347v0 = _T
      c347v1 = mMovie
      c347v0.TopMenuMovie = c347v1
      c347v0 = _T
      c347v1 = true
      c347v0.TopMenuOpen = c347v1
      c347v0 = Engine.IsMobile
      c347v0 = c347v0()
      if c347v0 then
        c347v0 = _T
        c347v1 = 3
        c347v0.CloseSquadPanelTimer = c347v1
        c347v0 = _T
        c347v1 = true
        c347v0.SquadPanelOpen = c347v1
        c347v0 = _T
        c347v1 = true
        c347v0.IsFirstRollout = c347v1
        c347v0 = _T
        c347v1 = mMovie
        c347v1 = c347v1:GetMovieType()
        c347v0.TopMenuMovieType = c347v1
      end
      c347v2 = 1
      c347v3 = moviesToClose
      c347v0 = #c347v3
      c347v1 = 1
      for c347v2 = c347v2, c347v0, c347v1 do
        c347v3 = gFlashMgr
        c347v6 = moviesToClose
        c347v5 = c347v6[c347v2]
        c347v3 = c347v3:FindMovie(c347v5)
        c347v4 = IsNull
        c347v4 = c347v4(c347v3)
        if not c347v4 then
          c347v6 = "Close"
          c347v7 = ""
          c347v3:Execute(c347v6, c347v7)
        end
      end
      c347v0 = _T
      c347v1 = {}
      c347v0.MenuSelectedIndex = c347v1
      c347v1 = gRegion
      c347v0 = IsNull
      c347v0 = c347v0(c347v1)
      if not c347v0 then
        local p167 = 12
        if p167 == 12 then
          c347v0 = gRegion
          c347v0 = c347v0:GetLevelInfo()
          vT[49] = c347v0
          c347v0 = gRegion
          c347v0 = c347v0:GetLocalPlayerAvatar()
          vT[24] = c347v0
          c347v1 = vT[24]
          c347v0 = IsNull
          c347v0 = c347v0(c347v1)
          if c347v0 then
            p167 = 18
          else
            p167 = 13
          end
        end
        if p167 == 13 then
          c347v0 = vT[24]
          c347v2 = gLotusAvatarType
          c347v0 = c347v0:IsA(c347v2)
          if not c347v0 then
            p167 = 18
          else
            p167 = 14
          end
        end
        if p167 == 14 then
          c347v1 = gMatchingService
          c347v1 = c347v1:Name__9d854eed()
          c347v0 = not c347v1
          if c347v0 then
            p167 = 16
          else
            p167 = 15
          end
        end
        if p167 == 15 then
          c347v2 = vT[24]
          c347v1 = IsNull
          c347v1 = c347v1(c347v2:GetCurrentEmote())
          c347v0 = not c347v1
          p167 = 16
        end
        if p167 == 16 then
          if not c347v0 then
          else
            p167 = 17
          end
        end
        if p167 == 17 then
          c347v1 = vT[24]
          c347v3 = nil
          c347v1:PlayEmote(c347v3)
        end
        if p167 == 18 then
          c347v0 = mMovie
          c347v2 = "_root"
          c347v3 = 12
          c347v4 = 0
          c347v0:SetNumberVariable(c347v2, c347v3, c347v4)
          c347v0 = vT[0]
          c347v0 = c347v0.ShowYesOrNoMessage
          c347v1 = "/Lotus/Language/Menu/MainMenuConfirm"
          c347v2 = "MainMenuConfirmBasic"
          c347v0 = c347v0(c347v1, c347v2)
          vT[15] = c347v0
          do return end
        end
      end
      c347v0 = mMovie
      c347v3 = _T.RadialSolarMapOpen
      if c347v3 ~= true then
        c347v2 = false
      else
        c347v2 = true
      end
      c347v0:SetPreDrawUpdate(c347v2)
      c347v1 = vT[24]
      c347v0 = IsNull
      c347v0 = c347v0(c347v1)
      if c347v3 == true then
        c347v1 = _T.inSeamlessTransition
        c347v0 = not c347v1
        if c347v0 then
          c347v0 = vT[5]
          c347v0 = c347v0.CanPlayAnim
          c347v1 = vT[24]
          c347v0 = c347v0(c347v1)
        end
        vT[51] = c347v0
        c347v0 = vT[51]
        if c347v0 then
          c347v0 = vT[24]
          c347v0 = c347v0:Name__cb8bb185()
          c347v0 = c347v0:TrackPartsMISSION()
          c347v1 = IsNull
          c347v1 = c347v1(c347v0)
          if not c347v1 then
            c347v3 = gEmplacementType
            c347v1 = c347v0:IsA(c347v3)
            if c347v1 then
              c347v1 = print
              c347v2 = "it'll mess up!"
              c347v1(c347v2)
              c347v1 = false
              vT[51] = c347v1
            end
          end
        end
      end
      c347v0 = mMovie
      c347v2 = vT[51]
      c347v0:Name__cfb45c10(c347v2)
      c347v0 = require
      c347v1 = "Lotus.Interface.Libs.TimerMgr"
      c347v0 = c347v0(c347v1)
      c347v1 = c347v0.CreateTimerMgr
      c347v1 = c347v1()
      vT[27] = c347v1
      c347v1 = Engine.IsMobile
      c347v1 = c347v1()
      if c347v1 then
        c347v1 = vT[28]
        c347v2 = c347v0.CreateTimerMgr
        c347v2 = c347v2()
        c347v1.pulsingTimer = c347v2
      end
      c347v1 = vT[51]
      if c347v1 then
        c347v2 = vT[24]
        c347v1 = IsNull
        c347v1 = c347v1(c347v2)
        if not c347v1 then
          c347v1 = mMovie
          c347v3 = vT[24]
          c347v4 = Vector
          c347v5 = 1.56
          c347v6 = 3.04
          c347v7 = 1.3
          c347v4 = c347v4(c347v5, c347v6, c347v7)
          c347v5 = Rotation
          c347v6 = 14
          c347v7 = 0
          c347v8 = 2
          c347v5 = c347v5(c347v6, c347v7, c347v8)
          c347v6 = Vector
          c347v7 = 0.46
          c347v8 = 0.52
          c347v9 = 1
          c347v1:AttachToEntity(c347v3, c347v4, c347v5, c347v6(c347v7, c347v8, c347v9))
        end
      end
      c347v1 = mMovie
      c347v3 = vT[0]
      c347v3 = c347v3.Ternary
      c347v4 = vT[51]
      c347v5 = 0
      c347v6 = 2
      c347v1:SetViewportBehaviour(c347v3(c347v4, c347v5, c347v6))
      c347v1 = vT[1]
      c347v1 = c347v1.GetUIMode
      c347v1 = c347v1()
      vT[23] = c347v1
      c347v1 = gRegion
      c347v1 = c347v1:GetLevelArgs()
      c347v1 = c347v1.level
      c347v2 = gGameConfig
      c347v2 = c347v2:IsTutorialLevel(c347v1)
      vT[31] = c347v2
      c347v2 = vT[23]
      c347v3 = vT[1]
      c347v3 = c347v3.UI_MODE_IN_GAME
      if c347v2 ~= c347v3 then
        c347v3 = attachmentsToDissolveOnAll
        c347v4 = WeakResource
        c347v5 = "/Lotus/Fx/PowersuitAbilities/CustomEffects/CupidWingsDecoA"
        c347v2 = table.insert
        c347v2(c347v3, c347v4(c347v5))
        c347v3 = attachmentsToDissolveOnAll
        c347v4 = WeakResource
        c347v5 = "/Lotus/Characters/Tenno/Accessory/Ephemeras/BatWingsEphemeraDeco"
        c347v2 = table.insert
        c347v2(c347v3, c347v4(c347v5))
      end
      c347v2 = vT[1]
      c347v2 = c347v2.IsInGamePlay
      c347v2 = c347v2()
      if c347v2 then
        c347v3 = gGameRules
        c347v2 = IsNull
        c347v2 = c347v2(c347v3)
        if not c347v2 then
          c347v2 = gGameRules
          c347v2:HideLevelMap()
        end
      end
      c347v3 = gGameData
      c347v2 = IsNull
      c347v2 = c347v2(c347v3)
      if not c347v2 then
        c347v2 = gGameData
        c347v2 = c347v2:Name__1d1bb34a()
        c347v3 = gGameData
        c347v3 = c347v3:GetPlayerXP()
        c347v4 = gGameData
        c347v6 = c347v2 + 1
        c347v4 = c347v4:Name__6208410b(c347v6)
        c347v5 = false
        if c347v4 <= c347v3 then
          c347v6 = _G
          c347v6 = c347v6.StalkerMode
          c347v5 = not c347v6
        end
        vT[20] = c347v5
        c347v6 = gGameData
        c347v6 = c347v6:Name__927457bb()
        c347v7 = 0
        if c347v7 < c347v6 then
          c347v5 = false
        else
          c347v5 = true
        end
        vT[21] = c347v5
      end
      c347v2 = vT[144]
      c347v2()
      c347v2 = _T.ForceOpenScreen
      if c347v2 ~= nil then
        c347v2 = function(c346v0, c346v1)
          local c346v2, c346v3, c346v4, c346v5, c346v6, c346v7, c346v8, c346v9, c346v10, c346v11, c346v12, c346v13
          local c20 = -1
          repeat
            c346v3 = ipairs
            c346v4 = mMenuOptions
            c346v3, c346v4, c346v5 = c346v3(c346v4)
            for c346v6, c346v7 in c346v3, c346v4, c346v5 do
              c346v8 = c346v7.Name
              c346v2 = c346v6
              c346v8 = ipairs
              c346v9 = c346v7.Menu
              c346v8, c346v9, c346v10 = c346v8(c346v9)
              c346v13 = c346v12.Name
              vT[55] = c346v11
              c346v8 = vT[55]
              if c346v8 ~= nil then
                c20 = 12
                break
              end
              c346v8 = c346v7.Name
              if c346v8 == c346v0 then
                c20 = 10
                break
              end
            end
            if c20 ~= -1 then break end
            break
          until true
          if c20 == 10 then
            vT[55] = c346v6
          end
          c346v3 = vT[55]
          if c346v3 ~= nil then
            c346v3 = mMovie
            c346v5 = "_root"
            c346v6 = 13
            c346v7 = false
            c346v3:Name__d9713943(c346v5, c346v6, c346v7)
            if c346v2 ~= nil then
              c346v4 = _T.MenuSelectedIndex
              c346v3 = table.insert
              c346v3(c346v4, c346v2)
            end
          end
          do return end
        end
        c347v3 = _T.ForceOpenScreen
        if c347v3 == "Inbox" then
          c347v4 = "/Lotus/Language/Menu/Mailbox_Inbox"
          c347v5 = "/Lotus/Language/Menu/MenuCommunication"
          c347v2(c347v4, c347v5)
        else
          c347v3 = _T.ForceOpenScreen
          if c347v3 == "Foundry" then
            c347v4 = "/Lotus/Language/Menu/MenuFoundry"
            c347v5 = "/Lotus/Language/Menu/Store_Extras"
            c347v2(c347v4, c347v5)
          else
            c347v3 = _T.ForceOpenScreen
            if c347v3 == "Market" then
              c347v4 = "/Lotus/Language/Menu/MenuStore"
              c347v2(c347v4)
            else
              c347v3 = _T.ForceOpenScreen
              if c347v3 == "Friend" then
                c347v4 = "/Lotus/Language/Menu/FriendsUpperCase"
                c347v5 = "/Lotus/Language/Menu/MenuCommunication"
                c347v2(c347v4, c347v5)
              else
                c347v3 = _T.ForceOpenScreen
                if c347v3 == "EndOfMatch" then
                  c347v4 = "/Lotus/Language/Menu/ViewMissionProgress"
                  c347v2(c347v4)
                else
                  c347v3 = _T.ForceOpenScreen
                  if c347v3 == "TennoWay" then
                    c347v3 = c347v2
                    c347v5 = vT[65]
                    c347v5 = c347v5.IsTailorShop
                    if c347v5 then
                      c347v4 = "/Lotus/Language/Labels/NewWarOperatorAdult"
                    else
                      c347v4 = "/Lotus/Language/Menu/MenuOperator"
                    end
                    c347v3(c347v4)
                  else
                    c347v3 = _T.ForceOpenScreen
                    if c347v3 == "Arsenal" then
                      c347v4 = "/Lotus/Language/Menu/MenuLoadout"
                      c347v5 = "/Lotus/Language/Menu/Store_Extras"
                      c347v2(c347v4, c347v5)
                    end
                  end
                end
              end
            end
          end
        end
        c347v3 = _T
        c347v4 = nil
        c347v3.ForceOpenScreen = c347v4
      end
      c347v2 = vT[150]
      c347v2()
      c347v2 = vT[0]
      c347v2 = c347v2.Ternary
      c347v3 = vT[51]
      c347v4 = tileFadeMaterial
      c347v5 = tileFadeMaterialNoDepthTest
      c347v2 = c347v2(c347v3, c347v4, c347v5)
      c347v3 = vT[0]
      c347v3 = c347v3.Ternary
      c347v4 = vT[51]
      c347v5 = verticalFade
      c347v6 = verticalFadeNoDepthTest
      c347v3 = c347v3(c347v4, c347v5, c347v6)
      c347v4 = mMovie
      c347v6 = "Tile"
      c347v4:OverrideMaterial(c347v6, c347v2)
      c347v4 = mMovie
      c347v6 = "BlackBacker"
      c347v4:OverrideMaterial(c347v6, c347v3)
      c347v4 = mMovie
      c347v6 = "Tile"
      c347v7 = "VisibilityFadeSize"
      c347v8 = 0.015
      c347v9 = 0
      c347v10 = 0
      c347v11 = 0
      c347v4:Name__e243d995(c347v6, c347v7, c347v8, c347v9, c347v10, c347v11)
      c347v4 = mMovie
      c347v6 = "BlackBacker"
      c347v7 = "VisibilityFadeSize"
      c347v8 = 0.015
      c347v9 = 0
      c347v10 = 0
      c347v11 = 0
      c347v4:Name__e243d995(c347v6, c347v7, c347v8, c347v9, c347v10, c347v11)
      c347v4 = mMovie
      c347v6 = "Tile"
      c347v7 = 12
      c347v8 = 100
      c347v4:SetNumberVariable(c347v6, c347v7, c347v8)
      c347v4 = mMovie
      c347v6 = "BlackBacker"
      c347v7 = 12
      c347v8 = 80
      c347v4:SetNumberVariable(c347v6, c347v7, c347v8)
      c347v4 = mMovie
      c347v6 = "BlackBacker"
      c347v7 = 11
      c347v8 = 0
      c347v4:SetNumberVariable(c347v6, c347v7, c347v8)
      c347v4 = vT[155]
      c347v4()
      c347v5 = _T.ForegroundMovie
      c347v4 = IsNull
      c347v4 = c347v4(c347v5)
      if not c347v4 then
        c347v4 = _T.ForegroundMovie
        c347v6 = "TogglePlayTypeDropDown"
        c347v7 = "false"
        c347v4:Execute(c347v6, c347v7)
        c347v4 = _T
        c347v5 = false
        c347v4.CanShowPlayTypeDropDown = c347v5
      end
      c347v4 = vT[1]
      c347v4 = c347v4.GetActiveQuest
      c347v5 = gGameData
      c347v4, c347v5, c347v6 = c347v4(c347v5)
      c347v7 = true
      c347v8 = nil
      c347v9 = vT[1]
      c347v9 = c347v9.IsInMission
      c347v9 = c347v9()
    end
    if c347v9 then
      c347v16 = _T
      c347v17 = true
      c347v16.JustMissionInfo = c347v17
    end
    local p170 = 74
    if p170 == 74 then
      c347v9 = false
      c347v10 = _T.InQuestHub
      if c347v10 then
        p170 = 87
      else
        p170 = 75
      end
    end
    if p170 == 75 then
      c347v10 = newWarQuestKeychain
      if c347v4 ~= c347v10 then
        p170 = 80
      else
        p170 = 76
      end
    end
    if p170 == 76 then
      c347v10 = 5
      if c347v10 <= c347v5 then
        p170 = 79
      else
        p170 = 77
      end
    end
    if p170 == 77 then
      c347v10 = IsNull
      c347v10 = c347v10(c347v8)
      if c347v10 then
        p170 = 80
      else
        p170 = 78
      end
    end
    if p170 == 78 then
      c347v10 = newWarQuestKeychain
      if c347v8 ~= c347v10 then
        p170 = 80
      else
        p170 = 79
      end
    end
    if p170 == 79 then
      c347v10 = 13
      if c347v5 <= c347v10 then
        p170 = 87
      else
        p170 = 80
      end
    end
    if p170 == 80 then
      c347v10 = IsNull
      c347v10 = c347v10(c347v8)
      if c347v10 then
        p170 = 84
      else
        p170 = 81
      end
    end
    if p170 == 81 then
      c347v10 = newPlayerQuestKeyChain
      if c347v8 ~= c347v10 then
        p170 = 84
      else
        p170 = 82
      end
    end
    if p170 == 82 then
      c347v11 = gGameData
      c347v10 = IsNull
      c347v10 = c347v10(c347v11)
      if c347v10 then
        p170 = 87
      else
        p170 = 83
      end
    end
    if p170 == 83 then
      c347v10 = gGameData
      c347v10 = c347v10:Name__fda0d70d()
      if not c347v10 then
        p170 = 87
      else
        p170 = 84
      end
    end
    if p170 == 84 then
      c347v7 = false
      c347v10 = newWarQuestKeychain
      if c347v4 == c347v10 then
        p170 = 87
      else
        p170 = 85
      end
    end
    if p170 == 85 then
      c347v10 = gFlashMgr
      c347v12 = episodeStatusMovie
      c347v10 = c347v10:FindMovie(c347v12)
      c347v11 = IsNull
      c347v11 = c347v11(c347v10)
      if not c347v11 then
        p170 = 87
      else
        p170 = 86
      end
    end
    if p170 == 86 then
      c347v9 = true
      p170 = 87
    end
    if p170 == 87 then
      c347v10 = vT[1]
      c347v10 = c347v10.IsInMission
      c347v10 = c347v10()
      if not c347v10 then
        p170 = 90
      else
        p170 = 88
      end
    end
    if p170 == 88 then
      c347v10 = vT[1]
      c347v10 = c347v10.IsTransmissionPlaying
      c347v10 = c347v10()
      if not c347v10 then
        p170 = 90
      else
        p170 = 89
      end
    end
    if p170 == 89 then
      c347v10 = true
      vT[33] = c347v10
      p170 = 90
    end
    if p170 == 90 then
      c347v10 = _T.UIInputEnabled
      vT[40] = c347v10
      c347v10 = vT[40]
      if c347v10 then
        p170 = 93
      else
        p170 = 91
      end
    end
    if p170 == 91 then
      c347v10 = _T.EnableUIInput
      if not c347v10 then
        p170 = 93
      else
        p170 = 92
      end
    end
    if p170 == 92 then
      c347v10 = _T.EnableUIInput
      c347v10(c347v7)
      p170 = 93
    end
    if p170 == 93 then
      c347v10 = vT[23]
      c347v11 = vT[1]
      c347v11 = c347v11.UI_MODE_IN_GAME
      if c347v10 ~= c347v11 then
        p170 = 97
      else
        p170 = 94
      end
    end
    if p170 == 94 then
      c347v10 = gFlashMgr
      c347v12 = statusInfoMovie
      c347v10 = c347v10:FindMovie(c347v12)
      c347v11 = IsNull
      c347v11 = c347v11(c347v10)
      if not c347v11 then
        p170 = 96
      else
        p170 = 95
      end
    end
    if p170 == 95 then
      c347v11 = vT[77]
      c347v12 = true
      c347v11(c347v12)
      c347v11 = mMovie
      c347v13 = statusInfoMovie
      c347v14 = "StatusMovieLoaded"
      c347v11:directionalRetracted(c347v13, c347v14)
      p170 = 97
    end
    if p170 == 96 then
      vT[18] = c347v10
      p170 = 97
    end
    if p170 == 97 then
      c347v10 = Engine.IsMobile
      c347v10 = c347v10()
      if not c347v10 then
        p170 = 99
      else
        p170 = 98
      end
    end
    if p170 == 98 then
      c347v10 = mMovie
      c347v12 = true
      c347v10:Name__f7d22364(c347v12)
      p170 = 99
    end
    if p170 == 99 then
      if not c347v9 then
        p170 = 101
      else
        p170 = 100
      end
    end
    if p170 == 100 then
      c347v10 = vT[77]
      c347v11 = true
      c347v10(c347v11)
      c347v10 = mMovie
      c347v12 = episodeStatusMovie
      c347v13 = "EpisodeStatusLoaded"
      c347v10:directionalRetracted(c347v12, c347v13)
      p170 = 101
    end
    if p170 == 101 then
      c347v10 = FinishInitialize
      c347v10()
      do return end
    end
  end
  Initialize = vT[157]
  vT[157] = function()
    local c349v0, c349v1, c349v2, c349v3, c349v4, c349v5, c349v6, c349v7, c349v8, c349v9, c349v10, c349v11
    local c126 = -1
    repeat
      c349v5 = _T
      c349v6 = nil
      c349v5.gToolTip = c349v6
      c349v5 = pairs
      c349v6 = vT[68]
      c349v6 = c349v6.hitboxes
      c349v5, c349v6, c349v7 = c349v5(c349v6)
      for c349v8, c349v9 in c349v5, c349v6, c349v7 do
        c349v10 = c349v9.left
        c349v10 = c349v9.right
        c349v10 = c349v9.top
        c349v10 = c349v9.bottom
        if c349v4 <= c349v10 then
          c126 = 52
          break
        end
        c349v1 = mMovie
        c349v0 = IsNull
        c349v0 = c349v0(c349v1)
        c349v0 = vT[14]
        vT[53] = c349v0
        c349v3 = 1
        c349v1 = 3
        c349v2 = 1
        for c349v3 = c349v3, c349v1, c349v2 do
          c349v6 = vT[35]
          c349v5 = c349v6[c349v3]
          c349v4 = IsNull
          c349v4 = c349v4(c349v5)
          if not c349v4 then
            c349v5 = vT[35]
            c349v4 = c349v5[c349v3]
            c349v6 = vT[53]
            c349v4:SetVisibility(c349v6)
          end
        end
        if c126 ~= -1 then break end
        c349v0 = vT[56]
        if c349v0 then
          c349v1 = vT[15]
          c349v0 = IsNull
          c349v0 = c349v0(c349v1)
          if c349v0 then
            c349v0 = false
            vT[56] = c349v0
            c349v0 = vT[27]
            c349v2 = 0.01
            c349v3 = vT[79]
            c349v0:AddTimer(c349v2, c349v3)
          end
        end
        c349v1 = vT[22]
        c349v0 = IsNull
        c349v0 = c349v0(c349v1)
        if not c349v0 then
          c349v0 = vT[22]
          c349v2 = RealDeltaTime
          c349v2 = c349v2()
          c349v3 = nil
          c349v0:Update(c349v2, c349v3)
          c349v0 = vT[22]
          c349v2 = nil
          c349v3 = false
          c349v4 = true
          c349v0:Redraw(c349v2, c349v3, c349v4)
        end
        c349v1 = vT[24]
        c349v0 = IsNull
        c349v0 = c349v0(c349v1)
        if c349v0 then
          c349v0 = mMovie
          c349v0:Close()
          do return end
        end
        c349v0 = vT[51]
        if c349v0 then
          c349v0 = vT[24]
          c349v0 = c349v0:Name__bed50257()
          if c349v0 then
            c349v0 = mMovie
            c349v0:PeerLittle()
            c349v0 = mMovie
            c349v2 = 2
            c349v0:SetViewportBehaviour(c349v2)
            c349v0 = mMovie
            c349v2 = "Tile"
            c349v3 = tileFadeMaterialNoDepthTest
            c349v0:OverrideMaterial(c349v2, c349v3)
            c349v0 = mMovie
            c349v2 = "BlackBacker"
            c349v3 = verticalFadeNoDepthTest
            c349v0:OverrideMaterial(c349v2, c349v3)
            c349v0 = false
            vT[51] = c349v0
          end
        end
        c349v0 = mMovie
        c349v0 = c349v0:IsVisible()
        c349v1 = vT[53]
        if c349v0 then
          do return end
        end
        if c349v0 then
          c349v2 = vT[45]
          c349v1 = IsNull
          c349v1 = c349v1(c349v2)
          if not c349v1 then
            c349v1 = vT[45]
            c349v3 = vT[53]
            c349v1:SetVisibility(c349v3)
          end
        end
        c349v2 = vT[49]
        c349v1 = IsNull
        c349v1 = c349v1(c349v2)
        if c349v1 then
          c349v2 = gRegion
          c349v1 = IsNull
          c349v1 = c349v1(c349v2)
          if not c349v1 then
            c349v1 = gRegion
            c349v1 = c349v1:GetLevelInfo()
            vT[49] = c349v1
          end
        end
        c349v1 = 0
        c349v3 = vT[49]
        c349v2 = IsNull
        c349v2 = c349v2(c349v3)
        if not c349v2 then
          c349v2 = vT[49]
          c349v1 = c349v2:GetFade()
        end
        c349v3 = vT[50]
        c349v2 = IsNull
        c349v2 = c349v2(c349v3)
        if c349v2 then
          c349v3 = _T.GetScreenRes
          c349v2 = IsNull
          c349v2 = c349v2(c349v3)
          if not c349v2 then
            c349v2 = _T.GetScreenRes
            c349v3 = "SquadOverlay"
            c349v2 = c349v2(c349v3)
            c349v3 = IsNull
            c349v3 = c349v3(c349v2)
            if not c349v3 then
              c349v3 = gFlashMgr
              c349v3 = c349v3:FindMovie(c349v2)
              vT[50] = c349v3
            end
          end
        end
        c349v2 = vT[48]
        if c349v2 ~= c349v1 then
          vT[48] = c349v1
          c349v4 = Abs
          c349v5 = vT[48]
          c349v4 = c349v4(c349v5)
          c349v3 = 1 - c349v4
          c349v2 = c349v3 * 100
          c349v3 = mMovie
          c349v5 = "_root"
          c349v6 = 12
          c349v3:SetNumberVariable(c349v5, c349v6, c349v2)
          c349v4 = vT[50]
          c349v3 = IsNull
          c349v3 = c349v3(c349v4)
          if not c349v3 then
            c349v3 = vT[50]
            c349v5 = "_root"
            c349v6 = 12
            c349v3:SetNumberVariable(c349v5, c349v6, c349v2)
          end
        end
        c349v4 = vT[15]
        c349v3 = IsNull
        c349v3 = c349v3(c349v4)
        c349v2 = not c349v3
        c349v3 = vT[16]
        if c349v3 ~= c349v2 then
          vT[16] = c349v2
          c349v4 = vT[18]
          c349v3 = IsNull
          c349v3 = c349v3(c349v4)
          if not c349v3 then
            c349v3 = vT[18]
            c349v5 = "SetDesiredTopMenuVisibility"
            c349v8 = vT[16]
            c349v7 = not c349v8
            c349v6 = tostring
            c349v6 = c349v6(c349v7)
            c349v3:Execute(c349v5, c349v6)
          end
          c349v3 = vT[16]
          if not c349v3 then
            c349v3 = ShouldShowYareliChallenges
            c349v3 = c349v3()
            if c349v3 then
              c349v3 = vT[135]
              c349v3()
            end
          end
        end
        c349v3 = vT[33]
        if c349v3 then
          c349v3 = _T.Transmissions_Visible
          if c349v3 ~= false then
            c349v4 = gGameRules
            c349v3 = IsNull
            c349v3 = c349v3(c349v4)
            if not c349v3 then
              c349v3 = gGameRules
              c349v3 = c349v3:Paused()
              if c349v3 then
                c349v3 = _T
                c349v4 = false
                c349v3.Transmissions_Visible = c349v4
              end
            end
          end
        end
        c349v3 = mMovie
        c349v3 = c349v3:GetCursorX()
        c349v4 = mMovie
        c349v4 = c349v4:GetCursorY()
        c349v5 = -1000
        if c349v5 < c349v3 then
          c349v5 = -1000
          if c349v5 < c349v4 then
            c349v5 = _T
            c349v6 = mMovie
            c349v6 = c349v6:Name__9cc9bac5()
            c349v5.DiegeticPosition = c349v6
          end
        end
        c349v5 = vT[68]
        if not c349v5 then
          c126 = 54
          break
        end
      end
      if c126 ~= -1 then break end
      break
    until true
    if c126 == 52 then
      c349v10 = _T
      c349v11 = c349v9.desc
      c349v10.gToolTip = c349v11
    end
    c349v5 = vT[23]
    c349v6 = vT[1]
    c349v6 = c349v6.UI_MODE_IN_SPACE_SHIP
    if c349v5 ~= c349v6 then
      c349v5 = vT[1]
      c349v5 = c349v5.UpdateHeadTracking
      c349v6 = vT[24]
      c349v5(c349v6)
    end
    c349v5 = mMovie
    c349v7 = RealDeltaTime
    c349v5:Name__b7f5bbc5(c349v7())
    c349v6 = vT[27]
    c349v5 = IsNull
    c349v5 = c349v5(c349v6)
    if not c349v5 then
      c349v5 = vT[27]
      c349v7 = RealDeltaTime
      c349v5:Update(c349v7())
    end
    c349v5 = Engine.IsMobile
    c349v5 = c349v5()
    if c349v5 then
      c349v6 = vT[28]
      c349v6 = c349v6.pulsingTimer
      c349v5 = IsNull
      c349v5 = c349v5(c349v6)
      if not c349v5 then
        c349v5 = vT[28]
        c349v5 = c349v5.pulsingTimer
        c349v7 = RealDeltaTime
        c349v5:Update(c349v7())
      end
    end
    c349v5 = vT[122]
    c349v5()
    c349v5 = vT[152]
    c349v6 = RealDeltaTime
    c349v5(c349v6())
    c349v5 = vT[22]
    if c349v5 ~= nil then
      c349v5 = vT[22]
      c349v7 = function(c348v0)
        local c348v1
        c348v1 = c348v0.Update
        if c348v1 ~= nil then
          c348v0:Update()
        end
        do return end
      end
      c349v5:RunForAllElements(c349v7)
    end
    c349v5 = vT[64]
    c349v5 = c349v5.WaitingOnInventoryForConsole
    if c349v5 then
      c349v5 = vT[7]
      c349v5 = c349v5.TriggerConsole
      c349v6 = vT[64]
      c349v5 = c349v5(c349v6)
      if c349v5 then
        c349v5 = vT[80]
        c349v5()
      end
    end
    c349v5 = _T.ClosingTopMenu
    if c349v5 then
      c349v5 = _T
      c349v6 = nil
      c349v5.ClosingTopMenu = c349v6
      c349v5 = mMovie
      c349v7 = "Close"
      c349v8 = ""
      c349v5:Execute(c349v7, c349v8)
    end
    do return end
  end
  Update = vT[157]
  vT[157] = function()
    local c350v0, c350v1
    c350v1 = vT[17]
    c350v0 = IsNull
    c350v0 = c350v0(c350v1)
    if not c350v0 then
      c350v0 = vT[17]
      c350v0:Close()
    end
    do return end
  end
  OnProfileOpened = vT[157]
  vT[157] = function()
    local c351v0
    c351v0 = ShouldShowYareliChallenges
    c351v0 = c351v0()
    if c351v0 then
      c351v0 = vT[135]
      c351v0()
    end
    do return end
  end
  OnProfileClosed = vT[157]
  vT[157] = function()
    local c352v0
    c352v0 = true
    vT[20] = c352v0
    c352v0 = vT[29]
    c352v0()
    do return end
  end
  DebugEnableLevelUp = vT[157]
  vT[157] = function()
    local c353v0, c353v1, c353v2, c353v3
    c353v1 = _T.AcceptInvitePanel
    c353v0 = IsNull
    c353v0 = c353v0(c353v1)
    if not c353v0 then
      c353v0 = _T.AcceptInvitePanel
      c353v2 = "HasFocus"
      c353v3 = ""
      c353v0 = c353v0:Execute(c353v2, c353v3)
      if c353v0 then
        do return end
      end
    end
    c353v0 = vT[13]
    if not c353v0 then
      c353v0 = vT[22]
      c353v0:SelectCurrentElement()
      c353v0 = true
      do return c353v0 end
    end
    c353v0 = false
    do return c353v0 end
  end
  onKeyUp_MENU_SELECT = vT[157]
  vT[157] = function()
    local c354v0
    c354v0 = vT[13]
    if not c354v0 then
      c354v0 = vT[39]
      if c354v0 then
        c354v0 = vT[83]
        c354v0()
        c354v0 = true
        do return c354v0 end
      end
    end
    c354v0 = false
    do return c354v0 end
  end
  onKeyDown_MENU_CANCEL = vT[157]
  vT[157] = function()
    local c355v0
    c355v0 = vT[13]
    if not c355v0 then
      c355v0 = vT[123]
      c355v0()
      c355v0 = true
      do return c355v0 end
    end
    c355v0 = false
    do return c355v0 end
  end
  onKeyDown_SHOW_HELP = vT[157]
  vT[157] = function(c356v0)
    local c356v1, c356v2, c356v3
    c356v1 = vT[13]
    if not c356v1 then
      c356v2 = vT[22]
      c356v1 = IsNull
      c356v1 = c356v1(c356v2)
      if not c356v1 then
        c356v1 = vT[22]
        c356v3 = tonumber
        c356v3 = c356v3(c356v0)
        c356v1:FocusElementById(c356v3)
        c356v1 = vT[151]
        c356v2 = 1
        c356v1(c356v2)
      end
    end
    do return end
  end
  MenuItemFocused = vT[157]
  vT[157] = function(c357v0)
    local c357v1, c357v2, c357v3
    c357v2 = vT[22]
    c357v1 = IsNull
    c357v1 = c357v1(c357v2)
    if not c357v1 then
      c357v1 = vT[22]
      c357v3 = tonumber
      c357v3 = c357v3(c357v0)
      c357v1:UnfocusElementById(c357v3)
      c357v1 = vT[151]
      c357v2 = 0
      c357v1(c357v2)
    end
    do return end
  end
  MenuItemUnfocused = vT[157]
  vT[157] = function(c358v0)
    local c358v1, c358v2, c358v3
    c358v1 = print
    c358v2 = "Menu Item Pressed "
    c358v1(c358v2)
    c358v1 = vT[13]
    if not c358v1 then
      c358v2 = vT[22]
      c358v1 = IsNull
      c358v1 = c358v1(c358v2)
      if not c358v1 then
        c358v1 = vT[22]
        c358v1:StopScrollDrag()
        c358v1 = vT[22]
        c358v3 = tonumber
        c358v3 = c358v3(c358v0)
        c358v1:SelectElementById(c358v3)
        c358v1 = vT[151]
        c358v2 = 2
        c358v1(c358v2)
      end
    end
    do return end
  end
  MenuItemPressed = vT[157]
  vT[157] = function(c359v0)
    local c359v1, c359v2, c359v3
    c359v1 = print
    c359v2 = "Menu Item Pressed "
    c359v1(c359v2)
    c359v2 = vT[22]
    c359v1 = IsNull
    c359v1 = c359v1(c359v2)
    if not c359v1 then
      c359v1 = vT[22]
      c359v3 = tonumber
      c359v3 = c359v3(c359v0)
      c359v1:StartScrollDrag(c359v3)
    end
    do return end
  end
  MenuItemPressedDown = vT[157]
  vT[157] = function(c360v0)
    local c360v1, c360v2
    c360v2 = vT[22]
    c360v1 = IsNull
    c360v1 = c360v1(c360v2)
    if not c360v1 then
      c360v1 = vT[22]
      c360v1:StopScrollDrag()
    end
    do return end
  end
  MenuItemReleasedOutside = vT[157]
  vT[157] = function(c361v0)
    local c361v1, c361v2, c361v3, c361v4
    c361v1 = Engine.IsMobile
    c361v1 = c361v1()
    if not c361v1 then
      do return end
    end
    c361v2 = vT[69]
    c361v2 = c361v2.marketHighlightMovie
    c361v1 = IsNull
    c361v1 = c361v1(c361v2)
    if not c361v1 then
      c361v1 = vT[69]
      c361v1 = c361v1.marketHighlightMovie
      c361v3 = "IsFocused"
      c361v4 = ""
      c361v1 = c361v1:Execute(c361v3, c361v4)
      if c361v1 then
        do return end
      end
    end
    c361v2 = vT[12]
    c361v1 = IsNull
    c361v1 = c361v1(c361v2)
    if not c361v1 then
      c361v1 = vT[12]
      c361v3 = "IsFocused"
      c361v4 = ""
      c361v1 = c361v1:Execute(c361v3, c361v4)
      if c361v1 then
        do return end
      end
    end
    c361v1 = GoBack
    c361v1()
    do return end
  end
  ExitMenuReleaseCallback = vT[157]
  vT[157] = function()
    local c362v0, c362v1, c362v2, c362v3
    c362v0 = vT[1]
    c362v0 = c362v0.IsInGamePlay
    c362v0 = c362v0()
    if c362v0 then
      c362v0 = _T
      c362v1 = true
      c362v0.TopMenuCancelled = c362v1
      c362v0 = vT[79]
      c362v1 = false
      c362v0(c362v1)
      do return end
    end
    c362v0 = _T.CloseScreen
    c362v1 = "Menu"
    c362v0(c362v1)
    c362v1 = _T.BackgroundMovie
    c362v0 = IsNull
    c362v0 = c362v0(c362v1)
    if not c362v0 then
      c362v0 = _T.BackgroundMovie
      c362v2 = "CallMethodOnScreen"
      c362v3 = "ProfileBar,TransitionOut,"
      c362v0:Execute(c362v2, c362v3)
    end
    do return end
  end
  vT[158] = function()
    local c363v0
    c363v0 = vT[157]
    c363v0()
    do return end
  end
  ForceClose = vT[158]
  vT[158] = function()
    local c364v0
    c364v0 = vT[157]
    c364v0()
    do return end
  end
  Close = vT[158]
  vT[158] = function()
    local c365v0
    c365v0 = vT[157]
    c365v0()
    do return end
  end
  OnLevelStreaming = vT[158]
  vT[158] = function(c366v0)
    local c366v1
    if c366v0 ~= "true" then
      c366v1 = false
    else
      c366v1 = true
    end
    vT[41] = c366v1
    do return end
  end
  SkipDisableInputOnClose = vT[158]
  vT[158] = function()
    local c367v0, c367v1, c367v2
    c367v1 = vT[24]
    c367v0 = IsNull
    c367v0 = c367v0(c367v1)
    if not c367v0 then
      c367v0 = vT[52]
      if c367v0 then
        c367v0 = vT[24]
        c367v2 = false
        c367v0:SetDrawOnTop(c367v2)
        c367v0 = false
        vT[52] = c367v0
      end
    end
    do return end
  end
  EndAvatarDrawOnTop = vT[158]
  vT[158] = function()
    local c368v0, c368v1, c368v2
    c368v2 = vT[15]
    c368v1 = IsNull
    c368v1 = c368v1(c368v2)
    c368v0 = not c368v1
    do return c368v0 end
  end
  HasChildMovie = vT[158]
  vT[158] = function(c369v0)
    local c369v1, c369v2, c369v3, c369v4
    c369v2 = vT[15]
    c369v1 = IsNull
    c369v1 = c369v1(c369v2)
    if not c369v1 then
      if not ((c369v0 == nil or c369v0 ~= "true")) then
        c369v1 = vT[15]
        c369v1:Close()
      else
        c369v1 = vT[15]
        c369v3 = "TransitionOut"
        c369v4 = ""
        c369v1:Execute(c369v3, c369v4)
      end
    end
    c369v1 = nil
    vT[15] = c369v1
    do return end
  end
  CloseChildMovie = vT[158]
  vT[158] = function(c370v0)
    local c370v1, c370v2
    c370v1 = _T.GetScreenRes
    c370v1 = c370v1(c370v0)
    if c370v1 ~= nil then
      c370v2 = mMovie
      c370v2 = c370v2:PushChildMovie(c370v1)
      vT[15] = c370v2
    end
    do return end
  end
  OpenChildMovie = vT[158]
  vT[158] = function()
    local c371v0
    c371v0 = vT[13]
    do return c371v0 end
  end
  IsInputBlocked = vT[158]
  vT[158] = function(c372v0)
    local c372v1
    if c372v0 ~= "true" then
      c372v1 = false
    else
      c372v1 = true
    end
    vT[13] = c372v1
    do return end
  end
  SetInputBlocked = vT[158]
  vT[158] = function()
    local c373v0
    c373v0 = vT[51]
    do return c373v0 end
  end
  IsAttachedToAvatar = vT[158]
  vT[158] = function(c374v0)
    local c374v1, c374v2, c374v3, c374v4
    c374v1 = _T.TopMenuCancelled
    if c374v1 then
      do return end
    end
    c374v2 = vT[22]
    c374v1 = IsNull
    c374v1 = c374v1(c374v2)
    if not c374v1 then
      c374v1 = vT[22]
      c374v1 = c374v1.mElementTransitionTime
      c374v2 = vT[22]
      c374v2 = c374v2.mElementDelayTime
      c374v3 = vT[22]
      c374v4 = 0.01
      c374v3.mElementTransitionTime = c374v4
      c374v3 = vT[22]
      c374v4 = 0
      c374v3.mElementDelayTime = c374v4
      c374v3 = vT[29]
      c374v3()
      c374v3 = vT[22]
      c374v3.mElementTransitionTime = c374v1
      c374v3 = vT[22]
      c374v3.mElementDelayTime = c374v2
    end
    do return end
  end
  OnGamepadTransition = vT[158]
  vT[158] = function(c375v0)
    local c375v1
    if c375v0 ~= "true" then
      c375v1 = false
    else
      c375v1 = true
    end
    vT[40] = c375v1
    do return end
  end
  SetWasUIEnabled = vT[158]
  vT[158] = function(c376v0)
    local c376v1, c376v2, c376v3, c376v4, c376v5
    c376v2 = vT[15]
    c376v1 = IsNull
    c376v1 = c376v1(c376v2)
    if not c376v1 then
      c376v1 = vT[15]
      c376v3 = "TransitionOut"
      c376v4 = ""
      c376v1:Execute(c376v3, c376v4)
    end
    c376v1 = ""
    if c376v0 == "Inbox" then
      c376v1 = "/Lotus/Language/Menu/Mailbox_Inbox"
    else
      if c376v0 == "Foundry" then
        c376v1 = "/Lotus/Language/Menu/MenuFoundry"
      else
        if c376v0 == "Market" then
          c376v1 = "/Lotus/Language/Menu/MenuStore"
        else
          if c376v0 == "Friend" then
            c376v1 = "/Lotus/Language/Menu/FriendsUpperCase"
          else
            if c376v0 == "Settings" then
              c376v1 = "/Lotus/Language/Menu/MenuOptions"
            else
              if c376v0 == "TennoWay" then
                c376v2 = vT[65]
                c376v2 = c376v2.IsTailorShop
                if c376v2 then
                  c376v1 = "/Lotus/Language/Labels/NewWarOperatorAdult"
                else
                  c376v1 = "/Lotus/Language/Menu/MenuOperator"
                end
              else
                if c376v0 == "Profile" then
                  c376v1 = "/Lotus/Language/Menu/MenuMyProfile"
                else
                  if c376v0 == "Clan" then
                    c376v1 = "/Lotus/Language/Menu/Profile_Clan"
                  end
                end
              end
            end
          end
        end
      end
    end
    c376v2 = vT[121]
    c376v3 = mMenuOptions
    c376v2 = c376v2(c376v3, c376v1)
    if c376v1 then
      local p46 = 21
      if p46 == 21 then
        c376v3 = c376v2.ShouldDisplay
        if c376v3 == nil then
          p46 = 23
        else
          p46 = 22
        end
      end
      if p46 == 22 then
        c376v3 = c376v2.ShouldDisplay
        c376v3 = c376v3()
        if not c376v3 then
        else
          p46 = 23
        end
      end
      if p46 == 23 then
        c376v3 = vT[22]
        if c376v3 == nil then
        else
          p46 = 24
        end
      end
      if p46 == 24 then
        c376v3 = vT[148]
        c376v3 = c376v3(c376v2)
        c376v4 = IsNull
        c376v4 = c376v4(c376v3)
        if c376v4 then
        else
          p46 = 25
        end
      end
      if p46 == 25 then
        c376v5 = c376v2.PreAction
        c376v4 = IsNull
        c376v4 = c376v4(c376v5)
        if (c376v4 or c376v0 == "Profile") then
          p46 = 28
        else
          p46 = 27
        end
      end
      if p46 == 27 then
        c376v4 = c376v2.PreAction
        c376v4()
        p46 = 28
      end
      if p46 == 28 then
        c376v3()
      end
    end
    do return end
  end
  AutoSelectElement = vT[158]
  vT[158] = function(c377v0)
    local c377v1, c377v3
    if c377v0 ~= "true" then
      c377v0 = false
    else
      c377v0 = true
    end
    if c377v0 == "true" then
      c377v1 = vT[51]
      if not c377v1 then
        c377v1 = mMovie
        c377v1 = c377v1:IsVisible()
        if c377v1 then
          c377v1 = mMovie
          c377v3 = false
          c377v1:SetVisible(c377v3)
          do return end
        end
        c377v1 = true
        vT[34] = c377v1
        do return end
      end
    end
    if not c377v0 then
      c377v1 = vT[34]
      if c377v1 then
        c377v1 = false
        vT[34] = c377v1
        do return end
      end
      c377v1 = mMovie
      c377v3 = true
      c377v1:SetVisible(c377v3)
    end
    do return end
  end
  HideScreenForPlatPurchase = vT[158]
  vT[158] = function(c378v0, c378v1, c378v2)
    local c378v3, c378v4, c378v5, c378v6, c378v7, c378v8, c378v9, c378v10, c378v11, c378v12, c378v13, c378v14, c378v15, c378v16, c378v17, c378v18, c378v19, c378v20
    c378v3 = Engine.IsMobile
    c378v3 = c378v3()
    c378v4 = vT[51]
    c378v5 = mMovie
    c378v5 = c378v5:GetCursorX()
    c378v6 = mMovie
    c378v6 = c378v6:GetViewportWidth()
    c378v4 = c378v5 / c378v6
    c378v6 = mMovie
    c378v6 = c378v6:GetCursorY()
    c378v7 = mMovie
    c378v7 = c378v7:GetViewportHeight()
    c378v5 = c378v6 / c378v7
    c378v6 = string.find
    c378v8 = "MOUSE_B0"
    c378v6 = c378v6(c378v1, c378v8)
    c378v6 = print
    c378v7 = "HEALTH"
    c378v6(c378v7, c378v3)
    c378v6 = mMovie
    c378v6 = c378v6:GetCursorY()
    c378v7 = mMovie
    c378v7 = c378v7:GetCursorX()
    c378v8 = vT[22]
    c378v8 = c378v8:GetHowManyElements()
    c378v9 = -1
    c378v12 = 1
    c378v10 = c378v8
    c378v11 = 1
    for c378v12 = c378v12, c378v10, c378v11 do
      c378v17 = c378v16.y
      c378v17 = 0.5
      if c378v4 < c378v17 then break end
      c378v14 = "MenuItem"
      c378v13 = c378v14 .. c378v12
      c378v15 = "MenuItem"
      c378v16 = c378v12 + 1
      c378v14 = c378v15 .. c378v16
      c378v15 = { x = nil, y = nil }
      c378v16 = mMovie
      c378v19 = 2
      c378v16 = c378v16:GetNumberVariable(c378v13, c378v19)
      c378v15.x = c378v16
      c378v16 = mMovie
      c378v19 = 3
      c378v16 = c378v16:GetNumberVariable(c378v13, c378v19)
      c378v15.y = c378v16
      c378v16 = vT[0]
      c378v16 = c378v16.TransformPixelToViewportCoordinates
      c378v17 = mMovie
      c378v15 = c378v16(c378v17, c378v15)
      c378v16 = { x = nil, y = nil }
      c378v17 = mMovie
      c378v20 = 2
      c378v17 = c378v17:GetNumberVariable(c378v14, c378v20)
      c378v16.x = c378v17
      c378v17 = mMovie
      c378v20 = 3
      c378v17 = c378v17:GetNumberVariable(c378v14, c378v20)
      c378v16.y = c378v17
      c378v17 = vT[0]
      c378v17 = c378v17.TransformPixelToViewportCoordinates
      c378v18 = mMovie
      c378v16 = c378v17(c378v18, c378v16)
      if c378v12 == c378v8 then
        c378v17 = 1
        c378v16.y = c378v17
      end
      c378v17 = c378v15.y
    end
    c378v4 = vT[24]
    c378v3 = IsNull
    c378v3 = c378v3(c378v4)
    if c378v3 then
      do return end
    end
    c378v3 = _T.CustomHudHealth
    if not c378v3 then
      c378v4 = 0
      c378v5 = vT[24]
      c378v3 = math.max
      c378v3 = c378v3(c378v4, c378v5:GetUIHealth())
    end
    c378v4 = 0
    if not c378v3 then
      do return end
    end
    if not c378v3 then
      c378v9 = c378v12
    end
    if not c378v3 then
      if not ((c378v2 ~= "1" or c378v9 == -1)) then
        c378v10 = MenuItemFocused
        c378v10(c378v9)
        do return end
      end
      if not ((c378v2 ~= "0" or c378v9 == -1)) then
        c378v10 = MenuItemPressed
        c378v10(c378v9)
      end
    end
    do return end
  end
  onRawInputEvent = vT[158]
  vT[158] = function(c379v0)
    local c379v1, c379v2
    c379v1 = vT[77]
    c379v2 = false
    c379v1(c379v2)
    c379v1 = vT[69]
    c379v1.marketHighlightMovie = c379v0
    do return end
  end
  MarketingHighlightMovieLoaded = vT[158]
  vT[158] = function()
    local c380v0, c380v1, c380v2, c380v3, c380v4, c380v5, c380v6
    c380v6 = c380v5.TargetMovie
    c380v6 = c380v5.TargetMovie
    c380v0 = mMenuOptions
    c380v1 = ipairs
    c380v2 = _T.MenuSelectedIndex
    c380v1, c380v2, c380v3 = c380v1(c380v2)
    for c380v4, c380v5 in c380v1, c380v2, c380v3 do
      c380v6 = c380v0[c380v5]
      c380v0 = c380v6.Menu
    end
    c380v1 = ipairs
    c380v1, c380v2, c380v3 = c380v1(c380v0)
    for c380v4, c380v5 in c380v1, c380v2, c380v3 do
    end
    if c380v6 == nil then
      c380v6 = vT[143]
      c380v6 = c380v6()
      c380v5.Name = c380v6
    end
    c380v1 = vT[29]
    c380v1()
    do return end
  end
  OnNewItemsChanged = vT[158]
  do return end

