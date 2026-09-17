  local v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, v60, v61, v62, v63, v64, v65, v66, v67, v68, v69, v70, v71, v72, v73, v74, v75, v76, v77, v78, v79, v80, v81, v82, v83, v84, v85, v86, v87, v88, v89, v90, v91, v92, v93, v94, v95, v96, v97, v98, v99, v100, v101, v102, v103, v104, v105, v106, v107, v108, v109, v110, v111, v112, v113, v114, v115, v116, v117, v118, v119, v120, v121, v122, v123, v124, v125, v126, v127, v128, v129, v130, v131, v132, v133, v134, v135, v136, v137, v138, v139, v140, v141, v142, v143, v144, v145, v146, v147, v148, v149, v150, v151, v152, v153, v154, v155, v156, v157, v158, v159, v160, v161, v162, v163, v164, v165, v166, v167, v168, v169, v170, v171, v172, v173, v174, v175, v176, v177, v178, v179, v180, v181, v182, v183
  v0 = false
  v1 = false
  v2 = WeakResource
  v3 = "/Lotus/Types/Game/BaseCosmeticEnhancer"
  v2 = v2(v3)
  v3 = WeakResource
  v4 = "/Lotus/Types/Game/OperatorCosmeticEnhancer"
  v3 = v3(v4)
  v4 = WeakResource
  v5 = "/Lotus/Upgrades/Mods/Railjack/RailjackBaseMod"
  v4 = v4(v5)
  v5 = nil
  v6 = nil
  v7 = nil
  v8 = nil
  v9 = nil
  v10 = nil
  v11 = {}
  v12 = false
  v13 = false
  v14 = false
  v15 = nil
  v16 = 0
  v17 = 20
  v18 = 5000
  v19 = Symbol
  v20 = "AvatarPause"
  v19 = v19(v20)
  v20 = { PauseState = nil, ScreenVis = nil, AvatarDrawOnTop = false, BgInfo = nil }
  v21 = {}
  v20.ScreenVis = v21
  v21 = {}
  v20.BgInfo = v21
  v21 = require
  v22 = "EE.Interface.AnchorMgr"
  v21 = v21(v22)
  v22 = require
  v23 = "Lotus.Interface.StoreItemUtilities"
  v22 = v22(v23)
  v23 = require
  v24 = "Lotus.Interface.LotusUtilities"
  v23 = v23(v24)
  v24 = require
  v25 = "EE.Interface.Utilities"
  v24 = v24(v25)
  v25 = require
  v26 = "Lotus.Interface.UIStyleUtilities"
  v25 = v25(v26)
  v26 = require
  v27 = "Lotus.Interface.UIUtilities"
  v26 = v26(v27)
  v27 = require
  v28 = "Lotus.Interface.CardUtilitiesRedux"
  v27 = v27(v28)
  v28 = require
  v29 = "Lotus.Interface.SyndicateUtilities"
  v28 = v28(v29)
  v29 = require
  v30 = "Lotus.Scripts.Nemesis.NemesisGenerator"
  v29 = v29(v30)
  v30 = require
  v31 = "Lotus.Interface.CodexUtilities"
  v30 = v30(v31)
  v31 = require
  v32 = "Lotus.Interface.Components.ThemedButton"
  v31 = v31(v32)
  v32 = require
  v33 = "Lotus.Interface.Components.ThemedProgressInfo"
  v32 = v32(v33)
  v33 = require
  v34 = "Lotus.Scripts.Libs.StoryLib"
  v33 = v33(v34)
  v34 = require
  v35 = "Lotus.Interface.TouchInterface.FlashMovie"
  v34 = v34(v35)
  v35 = require
  v36 = "Lotus.Interface.TouchInterface.MovieClip"
  v35 = v35(v36)
  v36 = nil
  v37 = nil
  v38 = nil
  v39 = false
  v40 = true
  v41 = false
  v42 = false
  v43 = nil
  v44 = nil
  v45 = nil
  v46 = nil
  v47 = {}
  v48 = nil
  v49 = nil
  v50 = nil
  v51 = false
  v52 = nil
  v53 = nil
  v54 = nil
  v55 = nil
  v56 = nil
  v57 = nil
  v58 = 0
  v59 = ""
  v60 = ""
  v61 = ""
  v62 = false
  v63 = nil
  v64 = false
  v65 = false
  v66 = 0
  v67 = 0
  v68 = false
  v69 = {}
  v70 = false
  v71 = nil
  v72 = nil
  v73 = {}
  v74 = {}
  v75 = { Category = nil, Elements = nil }
  v76 = {}
  v75.Elements = v76
  v76 = {}
  v77 = {}
  v78 = { Elements = nil }
  v79 = {}
  v78.Elements = v79
  v79 = nil
  v80 = 1
  v81 = true
  v82 = nil
  v83 = nil
  v84 = nil
  v85 = false
  v86 = nil
  v87 = true
  v88 = true
  v89 = false
  v90 = nil
  v91 = nil
  v92 = { SyndicateInfo = nil, DailyStandingInfo = nil, mSyndicateStandingBonusOperation = nil, MadeTrade = false }
  v93 = nil
  v94 = { INVENTORY = 1, ENEMIES = 2, FISH = 3, TREASURE = 4, PRIMEPARTS = 5, SHIP_RAW = 6, SHIP_SCRAP = 7, SHIP_PARTS = 8, SHARDS = 9, DECODONATE = 10, RESDONATE = 11, TRADE_ITEMS = 12, TRADE_MODS = 13, SYNDDONATE = 14, ARCANE = 15, MODS_SKIP_LIST = 16 }
  v95 = v94.INVENTORY
  v96 = false
  v97 = false
  v98 = { INVENTORY = 1, SELL = 2 }
  v99 = nil
  v100 = { Materials = nil, Size = 0, YPos = 0 }
  v101 = {}
  v100.Materials = v101
  v101 = 160
  v102 = nil
  v103 = nil
  v104 = WeakResource
  v105 = "/Lotus/Types/Items/SyndicateDogTags/KelaEventDogTag"
  v104 = v104(v105)
  v105 = WeakResource
  v106 = "/Lotus/Interface/StandingGainPopup.swf"
  v105 = v105(v106)
  v106 = Type
  v107 = "/Lotus/Upgrades/Mods/DirectorMods/HardModeEnemyLevelAura"
  v106 = v106(v107)
  v107 = {}
  v108 = 0
  v107.ALL = v108
  v108 = 1
  v107.WARFRAME = v108
  v108 = 2
  v107.WEAPONS = v108
  v108 = 3
  v107.SENTINEL = v108
  v108 = 4
  v107.APPEARANCE = v108
  v108 = 5
  v107.ENHANCEMENTS = v108
  v108 = 6
  v107.FOCUS = v108
  v108 = 7
  v107.DRONES = v108
  v108 = 8
  v107.GEAR = v108
  v108 = 9
  v107.KEYS = v108
  v108 = 10
  v107.RESOURCES = v108
  v108 = 11
  v107.PRIME = v108
  v108 = 12
  v107.ARCHWING = v108
  v108 = 13
  v107.ARCHWINGWEAPONS = v108
  v108 = 14
  v107.MISC = v108
  v108 = 15
  v107.OPERATORAMPS = v108
  v108 = 16
  v107.GRINEER = v108
  v108 = 17
  v107.CORPUS = v108
  v108 = 18
  v107.INFESTED = v108
  v108 = 19
  v107.WILD = v108
  v108 = 20
  v107.OROKIN = v108
  v108 = 21
  v107.SENTIENT = v108
  v108 = 22
  v107.RELICS = v108
  v108 = 23
  v107.RECIPES = v108
  v108 = 24
  v107.PETPRINTS = v108
  v108 = 25
  v107.LICH = v108
  v108 = 26
  v107.AVIONICS = v108
  v108 = 27
  v107.MKI = v108
  v108 = 28
  v107.MKII = v108
  v108 = 29
  v107.MKIII = v108
  v108 = 30
  v107.LAVAN = v108
  v108 = 31
  v107.VIDAR = v108
  v108 = 32
  v107.ZEKTI = v108
  v108 = 33
  v107.SIGMA = v108
  v108 = 34
  v107.MECHS = v108
  v108 = 35
  v107.EMOTE = v108
  v108 = 36
  v107.NARMER = v108
  v108 = 37
  v107.MURMUR = v108
  v108 = 38
  v107.SCALDRA = v108
  v108 = 39
  v107.TECHROT = v108
  v108 = 40
  v107.ANARCH = v108
  v108 = { FISH_SMALL = 16, FISH_MEDIUM = 17, FISH_LARGE = 18 }
  v109 = {}
  v110 = { EXIT = 1, FISH_CATEGORY = 3, SELECT_ALL = 5, TUTORIAL = 6 }
  v111 = nil
  v112 = nil
  v113 = nil
  v114 = nil
  v115 = nil
  v116 = nil
  v117 = nil
  v118 = nil
  v119 = nil
  v120 = nil
  v121 = nil
  v122 = nil
  v123 = { DEFAULT = 0, HIDE_DURING_LONG_PRESS = 1, SHOW_UNTIL_SCROLL_OR_TAP = 2 }
  v124 = { mouseDown = false, mouseDownTime = 0, mouseClickLimit = 0.01, dragStarted = false, dragThreshold = 30, mousePos = nil, focusStartTime = 0, focusStartTimeScroll = 0, popupState = nil, hidePopupScrollThreshold = 0.1 }
  v125 = Vector
  v126 = 0
  v127 = 0
  v128 = 0
  v125 = v125(v126, v127, v128)
  v124.mousePos = v125
  v125 = v123.DEFAULT
  v124.popupState = v125
  v125 = function(c1v0)
    local c1v1, c1v2, c1v3, c1v4, c1v5
    v65 = c1v0
    if c1v0 then
      c1v1 = "On"
    else
      c1v1 = "Off"
    end
    c1v0 = c1v1
    c1v1 = FlashMethod
    c1v2 = mMovie
    c1v3 = "Sellable.Toggle.gotoAndStop"
    c1v1(c1v2, c1v3, c1v0)
    c1v1 = v119
    c1v1()
    c1v1 = v43
    c1v2 = true
    c1v1.mMuteGridOpenSound = c1v2
    c1v1 = v43
    c1v3 = nil
    c1v4 = true
    c1v5 = true
    c1v1:Redraw(c1v3, c1v4, c1v5)
    c1v1 = v43
    c1v2 = false
    c1v1.mMuteGridOpenSound = c1v2
    do return end
  end
  v126 = function()
    local c2v0, c2v1, c2v2
    c2v0 = v125
    c2v2 = v65
    c2v1 = not c2v2
    c2v0(c2v1)
    do return end
  end
  v127 = function()
    local c3v0, c3v1, c3v2, c3v3, c3v4
    c3v1 = v64
    c3v0 = not c3v1
    v64 = c3v0
    c3v0 = v119
    c3v0()
    c3v0 = v43
    c3v1 = true
    c3v0.mMuteGridOpenSound = c3v1
    c3v0 = v43
    c3v2 = nil
    c3v3 = true
    c3v4 = true
    c3v0:Redraw(c3v2, c3v3, c3v4)
    c3v0 = v43
    c3v1 = false
    c3v0.mMuteGridOpenSound = c3v1
    do return end
  end
  v128 = function()
    local c4v0
    c4v0 = true
    v89 = c4v0
    c4v0 = v112
    c4v0()
    c4v0 = false
    v88 = c4v0
    c4v0 = true
    v89 = c4v0
    do return end
  end
  v129 = function()
    local c5v0, c5v1, c5v2
    c5v0 = true
    c5v1 = v95
    c5v2 = v94
    c5v2 = c5v2.TRADE_ITEMS
    if c5v1 ~= c5v2 then
      c5v1 = v95
      c5v2 = v94
      c5v2 = c5v2.TRADE_MODS
      if c5v1 ~= c5v2 then
        c5v0 = false
        do return c5v0 end
      end
      c5v0 = true
    end
    do return c5v0 end
  end
  v119 = function()
    local c6v0, c6v1, c6v2, c6v3, c6v4, c6v5, c6v6, c6v7
    c6v0 = {}
    local __renovice_local_0 = v95
    c6v1 = v94
    c6v1 = c6v1.INVENTORY
    if __renovice_local_0 == c6v1 then
      c6v2 = { Label = nil, Tips = nil, Padding = -10 }
      c6v3 = mMovie
      c6v5 = "<WARNING>"
      c6v6 = true
      c6v3 = c6v3:GetLocalized(c6v5, c6v6)
      c6v2.Label = c6v3
      c6v3 = v26
      c6v3 = c6v3.GetTips
      c6v4 = mMovie
      c6v5 = "/Lotus/Language/WarframeHints/Inventory_"
      c6v3 = c6v3(c6v4, c6v5)
      c6v2.Tips = c6v3
      __renovice_local_0 = table.insert
      __renovice_local_0(c6v0, c6v2)
      c6v2 = { Label = nil, CallBack = nil }
      c6v3 = v24
      c6v3 = c6v3.Ternary
      c6v4 = v65
      c6v5 = "/Lotus/Language/Menu/OnlySellableOn"
      c6v6 = "/Lotus/Language/Menu/OnlySellableOff"
      c6v3 = c6v3(c6v4, c6v5, c6v6)
      c6v2.Label = c6v3
      c6v3 = v126
      c6v2.CallBack = c6v3
      __renovice_local_0 = table.insert
      __renovice_local_0(c6v0, c6v2)
    else
      __renovice_local_0 = v95
      c6v1 = v94
      c6v1 = c6v1.ARCANE
      if __renovice_local_0 == c6v1 then
        c6v2 = { Label = nil, CallBack = nil }
        c6v3 = v24
        c6v3 = c6v3.Ternary
        c6v4 = v64
        c6v5 = "/Lotus/Language/SystemMessages/ShowRankedOn"
        c6v6 = "/Lotus/Language/SystemMessages/ShowRankedOff"
        c6v3 = c6v3(c6v4, c6v5, c6v6)
        c6v2.Label = c6v3
        c6v3 = v127
        c6v2.CallBack = c6v3
        __renovice_local_0 = table.insert
        __renovice_local_0(c6v0, c6v2)
      else
        __renovice_local_0 = v95
        c6v1 = v94
        c6v1 = c6v1.TRADE_MODS
        if __renovice_local_0 == c6v1 then
          c6v2 = { Label = nil, CallBack = nil }
          c6v3 = v24
          c6v3 = c6v3.Ternary
          c6v4 = v87
          c6v5 = "/Lotus/Language/Labels/HideEquippedOn"
          c6v6 = "/Lotus/Language/Labels/HideEquippedOff"
          c6v3 = c6v3(c6v4, c6v5, c6v6)
          c6v2.Label = c6v3
          c6v3 = v128
          c6v2.CallBack = c6v3
          __renovice_local_0 = table.insert
          __renovice_local_0(c6v0, c6v2)
        end
      end
    end
    c6v3 = v47
    c6v2 = #c6v3
    __renovice_local_0 = 1
    c6v1 = -1
    for __renovice_for_0_0 = c6v2, __renovice_local_0, c6v1 do
      c6v3 = v47[__renovice_for_0_0]
      c6v4 = c6v3.mVisible
      if not c6v4 then
        continue
      end
      c6v6 = { Label = nil, CallBack = nil, CallOut = nil }
      c6v7 = c6v3.mLabel
      c6v6.Label = c6v7
      c6v7 = c6v3.mCallback
      c6v6.CallBack = c6v7
      c6v7 = c6v3.mCallout
      c6v6.CallOut = c6v7
      c6v4 = table.insert
      c6v4(c6v0, c6v6)
    end
    c6v1 = _T.SetButtons
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c6v1)
    if not __renovice_local_0 then
      __renovice_local_0 = _T.SetButtons
      c6v1 = mMovie
      c6v3 = getfenv
      c6v4 = 1
      __renovice_local_0(c6v1, c6v0, c6v3(c6v4))
    end
    do return end
  end
  v130 = function()
    local c7v0, c7v1, c7v2, c7v3, c7v4
    local __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.gToolTip = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.InfoPopup_Data = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.InfoPopup_Grid = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.SellingPrimeParts = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.SellingTreasure = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.SellingArcane = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.SelectingFishManifest = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.SelectingEnemies = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.SelectingEnemiesManifest = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.ShowPrimeBucks = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.ShowPrimeTokens = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.ShowFusionPoints = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.InvTradingInfo = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.OnNemesisClosed = c7v0
    __renovice_local_0 = _T
    c7v0 = false
    __renovice_local_0.InventoryScreenOpen = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.xpInfoDictionary = c7v0
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.InvModSkipListSelection = c7v0
    c7v0 = v10
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c7v0)
    if not __renovice_local_0 then
      c7v0 = gPlayerProfileMgr
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c7v0)
      if not __renovice_local_0 then
        c7v0 = _T.SelectedEnemyLevel
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c7v0)
        if not __renovice_local_0 then
          __renovice_local_0 = v10
          c7v2 = _T.SelectedEnemyLevel
          c7v1 = tostring
          c7v1 = c7v1(c7v2)
          __renovice_local_0:Name__f2078c09(c7v1)
        end
        c7v0 = _T.PauseAI
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c7v0)
        if not __renovice_local_0 then
          __renovice_local_0 = v10
          c7v1 = _T.PauseAI
          __renovice_local_0:Name__3194e506(c7v1)
        end
        c7v0 = _T.warframesInvincible
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c7v0)
        if not __renovice_local_0 then
          __renovice_local_0 = v10
          c7v1 = _T.warframesInvincible
          __renovice_local_0:Name__45f44c93(c7v1)
        else
          __renovice_local_0 = v10
          c7v1 = false
          __renovice_local_0:Name__45f44c93(c7v1)
        end
        c7v0 = _T.companionsInvincible
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c7v0)
        if not __renovice_local_0 then
          __renovice_local_0 = v10
          c7v1 = _T.companionsInvincible
          __renovice_local_0:Name__8e321af4(c7v1)
        else
          __renovice_local_0 = v10
          c7v1 = false
          __renovice_local_0:Name__8e321af4(c7v1)
        end
        c7v0 = _T.FriendlyFire
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c7v0)
        if not __renovice_local_0 then
          __renovice_local_0 = v10
          c7v1 = _T.FriendlyFire
          __renovice_local_0:tnbCatalyst(c7v1)
        end
        c7v0 = _T.SimulateHardMode
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c7v0)
        if not __renovice_local_0 then
          __renovice_local_0 = v10
          c7v1 = _T.SimulateHardMode
          __renovice_local_0:Name__37e517cf(c7v1)
        end
        __renovice_local_0 = gPlayerProfileMgr
        c7v1 = 0
        __renovice_local_0:Name__4be6b7ba(c7v1)
      end
    end
    __renovice_local_0 = v20
    __renovice_local_0 = __renovice_local_0.PauseState
    if not __renovice_local_0 then
      c7v0 = gGameRules
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c7v0)
      if not __renovice_local_0 then
        __renovice_local_0 = gGameRules
        c7v1 = false
        __renovice_local_0:SetPauseDisabled(c7v1)
      end
    end
    __renovice_local_0 = v95
    c7v0 = v94
    c7v0 = c7v0.SHIP_SCRAP
    if __renovice_local_0 == c7v0 then
      __renovice_local_0 = v26
      __renovice_local_0 = __renovice_local_0.ToggleScreensToHide
      c7v0 = true
      c7v1 = v20
      c7v1 = c7v1.ScreenVis
      __renovice_local_0(c7v0, c7v1)
    end
    __renovice_local_0 = v95
    c7v0 = v94
    c7v0 = c7v0.TREASURE
    if __renovice_local_0 == c7v0 then
      c7v0 = _T.PlayBackgroundTransmission
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c7v0)
      if not __renovice_local_0 then
        __renovice_local_0 = _T
        c7v0 = _T.MarooDeco
        __renovice_local_0.LypSyncDeco = c7v0
        __renovice_local_0 = _T.PlayBackgroundTransmission
        c7v0 = "TransactionComplete"
        c7v1 = transmissionSet
        c7v2 = 3
        __renovice_local_0(c7v0, c7v1, c7v2)
      end
    end
    __renovice_local_0 = _T
    c7v0 = nil
    __renovice_local_0.MarooDeco = c7v0
    __renovice_local_0 = v23
    __renovice_local_0 = __renovice_local_0.RegisterHideHud
    c7v0 = false
    __renovice_local_0(c7v0)
    __renovice_local_0 = v95
    c7v0 = v94
    c7v0 = c7v0.TRADE_MODS
    if __renovice_local_0 == c7v0 then
      __renovice_local_0 = v26
      __renovice_local_0 = __renovice_local_0.ClearGridModMaterials
      __renovice_local_0()
    end
    c7v0 = v43
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c7v0)
    if not __renovice_local_0 then
      __renovice_local_0 = v43
      __renovice_local_0 = __renovice_local_0:GetSortById()
      c7v0 = IsNull
      c7v0 = c7v0(__renovice_local_0)
      if not c7v0 then
        c7v1 = v46
        c7v0 = IsNull
        c7v0 = c7v0(c7v1)
        if not c7v0 then
          c7v0 = mMovie
          c7v0 = c7v0:GetMovieType()
          c7v1 = v46
          c7v1:Name__226583bc(c7v0, __renovice_local_0)
        end
      end
    end
    __renovice_local_0 = v23
    __renovice_local_0 = __renovice_local_0.GetMainMenuSuitAvatar
    __renovice_local_0 = __renovice_local_0()
    c7v0 = IsNull
    c7v0 = c7v0(__renovice_local_0)
    if not c7v0 then
      c7v0 = gFlashMgr
      c7v2 = tennoWayMovie
      c7v0 = c7v0:FindMovie(c7v2)
      if c7v0 == nil then
        c7v2 = true
        __renovice_local_0:SetVisibility(c7v2)
      end
      c7v0 = v20
      c7v0 = c7v0.AvatarDrawOnTop
      if c7v0 then
        c7v2 = true
        __renovice_local_0:SetDrawOnTop(c7v2)
      end
    end
    c7v0 = v121
    c7v0()
    c7v1 = v84
    c7v0 = IsNull
    c7v0 = c7v0(c7v1)
    if not c7v0 then
      c7v0 = v84
      c7v2 = "_root"
      c7v3 = 13
      c7v4 = true
      c7v0:Name__d9713943(c7v2, c7v3, c7v4)
    end
    c7v1 = _T.SetSquadOverlayTitle
    c7v0 = IsNull
    c7v0 = c7v0(c7v1)
    if not c7v0 then
      c7v0 = _T.SetSquadOverlayTitle
      c7v0()
    end
    c7v1 = v54
    c7v0 = IsNull
    c7v0 = c7v0(c7v1)
    if not c7v0 then
      c7v0 = v54
      c7v0:Close()
    end
    c7v1 = gGameRules
    c7v0 = IsNull
    c7v0 = c7v0(c7v1)
    if not c7v0 then
      c7v1 = gRegion
      c7v0 = IsNull
      c7v0 = c7v0(c7v1)
      if not c7v0 then
        c7v0 = gGameRules
        c7v2 = gLotusPhotoBoothGameRulesType
        c7v0 = c7v0:IsA(c7v2)
        if c7v0 then
          c7v0 = gRegion
          c7v0 = c7v0:IsMaster()
          if c7v0 then
            c7v0 = gGameRules
            c7v0 = c7v0:Paused()
            if c7v0 then
              c7v0 = gGameRules
              c7v0:RequestUnpause()
              c7v0 = gGameRules
              c7v0:RequestPause()
            end
          end
        end
      end
    end
    c7v0 = v36
    if c7v0 then
      c7v0 = v36
      c7v0:Shutdown()
    end
    do return end
  end
  Shutdown = v130
  v130 = function()
    local c8v0, c8v1, c8v2, c8v3
    c8v0 = gPlayerProfileMgr
    c8v2 = 0
    c8v0 = c8v0:GetPlayerProfile(c8v2)
    c8v1 = IsNull
    c8v1 = c8v1(c8v0)
    if not c8v1 then
      c8v1 = c8v0:Settings()
      c8v2 = IsNull
      c8v2 = c8v2(c8v1)
      if not c8v2 then
        c8v3 = v65
        c8v1:Name__e858addf(c8v3)
      end
    end
    do return end
  end
  v121 = function()
    local c9v0, c9v1, c9v2, c9v3, c9v4
    local __renovice_state_0 = 0
    c9v0 = v42
    if not c9v0 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      do return end
    elseif __renovice_state_0 == 2 then
      c9v0 = v41
      if not c9v0 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c9v0 = _T.DisableUIInput
      c9v0()
      __renovice_state_0 = 4
    end
    if __renovice_state_0 == 4 then
      c9v0 = v20
      c9v0 = c9v0.BgInfo
      c9v0 = c9v0.Visible
      if not c9v0 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c9v1 = _T.ShowBackground
      c9v0 = IsNull
      c9v0 = c9v0(c9v1)
      if c9v0 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c9v0 = _T.ShowBackground
      c9v1 = 0
      c9v2 = v20
      c9v2 = c9v2.BgInfo
      c9v2 = c9v2.HighlightOffset
      c9v3 = v20
      c9v3 = c9v3.BgInfo
      c9v3 = c9v3.HighlightOn
      c9v4 = v20
      c9v4 = c9v4.BgInfo
      c9v4 = c9v4.VisRangeInfo
      c9v0(c9v1, c9v2, c9v3, c9v4)
      __renovice_state_0 = 10
    end
    if __renovice_state_0 == 7 then
      c9v1 = _T.HideBackground
      c9v0 = IsNull
      c9v0 = c9v0(c9v1)
      if c9v0 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      c9v0 = v129
      c9v0 = c9v0()
      if c9v0 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c9v0 = _T.HideBackground
      c9v1 = 0.2
      c9v0(c9v1)
      __renovice_state_0 = 10
    end
    if __renovice_state_0 == 10 then
      c9v0 = true
      v42 = c9v0
      do return end
    end
    do return end
  end
  v131 = function()
    local c11v0, c11v1, c11v2, c11v3, c11v4, c11v5, c11v6, c11v7, c11v8, c11v9
    c11v0 = v121
    c11v0()
    c11v0 = v95
    c11v1 = v94
    c11v1 = c11v1.PRIMEPARTS
    if c11v0 == c11v1 then
      c11v1 = _T.InterruptVoidTraderTransmission
      c11v0 = IsNull
      c11v0 = c11v0(c11v1)
      if not c11v0 then
        c11v0 = _T.InterruptVoidTraderTransmission
        c11v0()
      end
    end
    c11v1 = gPlayerProfileMgr
    c11v3 = 0
    c11v0 = IsNull
    c11v0 = c11v0(c11v1:GetPlayerProfile(c11v3))
    if not c11v0 then
      c11v1 = gPlayerProfileMgr
      c11v3 = 0
      c11v1 = c11v1:GetPlayerProfile(c11v3)
      c11v0 = IsNull
      c11v0 = c11v0(c11v1:GetGameSpecificData())
      if not c11v0 then
        c11v0 = gPlayerProfileMgr
        c11v2 = 0
        c11v0 = c11v0:GetPlayerProfile(c11v2)
        c11v0 = c11v0:GetGameSpecificData()
        c11v0:Name__357bf2ea()
      end
    end
    c11v0 = true
    v40 = c11v0
    c11v0 = 0
    c11v1 = gFlashMgr
    c11v3 = tennoWayMovie
    c11v1 = c11v1:FindMovie(c11v3)
    if c11v1 == nil then
      c11v0 = 0.2
    end
    c11v1 = v24
    c11v1 = c11v1.FadeBackground
    c11v2 = mMovie
    c11v3 = 0
    c11v1(c11v2, c11v3, c11v0)
    c11v1 = FlashInterpolate
    c11v2 = mMovie
    c11v3 = "_root"
    c11v4 = 0
    c11v6 = 12
    c11v5 = {c11v6}
    c11v7 = 0
    c11v6 = {c11v7}
    c11v8 = 0
    c11v9 = function()
      local c10v0, c10v1, c10v2, c10v3
      c10v1 = v49
      c10v0 = IsNull
      c10v0 = c10v0(c10v1)
      if not c10v0 then
        c10v2 = _T
        c10v3 = v49
        c10v1 = c10v2[c10v3]
        c10v0 = IsNull
        c10v0 = c10v0(c10v1)
        if not c10v0 then
          c10v1 = _T
          c10v2 = v49
          c10v0 = c10v1[c10v2]
          c10v0()
        end
      end
      c10v0 = mMovie
      c10v0:Close()
      c10v0 = v130
      c10v0()
      do return end
    end
    c11v1(c11v2, c11v3, c11v4, c11v5, c11v6, c11v0, c11v8, c11v9)
    do return end
  end
  v132 = function()
    do return end
  end
  OnUpdateSessionSettings = v132
  v132 = function(c13v0, c13v1)
    local c13v2, c13v3, c13v4
    c13v2 = v23
    c13v2 = c13v2.OnSaveLoadOutCompleteCommon
    c13v3 = "OnUpdateSessionSettings"
    c13v2(c13v3)
    c13v2 = v52
    if c13v2 ~= nil then
      c13v3 = _T
      c13v4 = v52
      c13v2 = c13v3[c13v4]
      c13v3 = true
      c13v2(c13v3)
      c13v2 = nil
      v52 = c13v2
    end
    c13v2 = v131
    c13v2()
    do return end
  end
  OnSaveLoadOutComplete = v132
  v132 = function()
    local c14v0, c14v1, c14v2, c14v3
    c14v0 = true
    v40 = c14v0
    c14v0 = v95
    c14v1 = v94
    c14v1 = c14v1.SYNDDONATE
    if c14v0 == c14v1 then
      c14v0 = v92
      c14v0 = c14v0.MadeTrade
      if not c14v0 then
        c14v1 = _T.SyndicateInvInfo
        c14v0 = IsNull
        c14v0 = c14v0(c14v1)
        if not c14v0 then
          c14v1 = _T.SyndicateInvInfo.Syndicate
          c14v0 = IsNull
          c14v0 = c14v0(c14v1)
          if not c14v0 then
            c14v0 = _T.SyndicateInvInfo.VendorTag
            if c14v0 ~= nil then
              c14v1 = "DogTagExitNoSale"
              c14v2 = EMPTY_SYMBOL
              if c14v0 ~= c14v2 then
                c14v3 = c14v0:c_str()
                c14v1 = c14v1 .. c14v3
              end
              c14v2 = v28
              c14v2 = c14v2.PlaySyndicateTransmission
              c14v3 = _T.SyndicateInvInfo.Syndicate
              c14v2(c14v3, c14v1)
            end
          end
        end
      end
    end
    c14v0 = v51
    if c14v0 then
      c14v0 = false
      v51 = c14v0
    else
      c14v0 = v131
      c14v0()
    end
    c14v0 = gFlashMgr
    c14v2 = "DisplayInWorldText"
    c14v3 = "true"
    c14v0:Name__788d33f3(c14v2, c14v3)
    do return end
  end
  v133 = function()
    local c15v0
    c15v0 = v132
    c15v0()
    do return end
  end
  TransitionOut = v133
  v133 = function(c16v0)
    local c16v1, c16v2, c16v3, c16v4
    if not c16v0 then
      c16v1 = _T.InventoryInfo
      if c16v1 ~= nil then
        c16v1 = _T.InventoryInfo.CancelConfirm
        if c16v1 ~= nil then
          c16v1 = v24
          c16v1 = c16v1.ShowYesOrNoMessage
          c16v2 = _T.InventoryInfo.CancelConfirm
          c16v3 = "OnExitScreenConfirm"
          c16v1(c16v2, c16v3)
          do return end
        end
      end
    end
    c16v1 = v24
    c16v1 = c16v1.PlaySound
    c16v2 = _G
    c16v2 = c16v2.UISound_GridOpenTwo
    c16v1(c16v2)
    c16v1 = v24
    c16v1 = c16v1.PlaySound
    c16v2 = _G
    c16v2 = c16v2.UISound_WindowClose
    c16v1(c16v2)
    c16v1 = v132
    c16v1()
    c16v1 = v95
    c16v2 = v94
    c16v2 = c16v2.MODS_SKIP_LIST
    if c16v1 == c16v2 then
      c16v1 = _T.InvModSkipListSelection
      if c16v1 ~= nil then
        c16v2 = _T
        c16v3 = _T.InvModSkipListSelection.OnExit
        c16v1 = c16v2[c16v3]
        if c16v1 ~= nil then
          c16v2 = _T
          c16v3 = _T.InvModSkipListSelection.OnExit
          c16v1 = c16v2[c16v3]
          c16v1()
        end
      end
    end
    c16v1 = gGameStatsMgr
    if c16v1 ~= nil then
      c16v1 = gGameRules
      c16v3 = gLotusAttractModeGameRulesType
      c16v1 = c16v1:IsA(c16v3)
      if c16v1 then
        c16v1 = v95
        c16v2 = v94
        c16v2 = c16v2.INVENTORY
        if c16v1 == c16v2 then
          c16v1 = gGameStatsMgr
          c16v3 = Symbol
          c16v4 = "IN_SHIP_VIEW_TIME"
          c16v3 = c16v3(c16v4)
          c16v4 = "EQUIPMENT_INVENTORY"
          c16v1:StopTimer(c16v3, c16v4)
        end
      end
    end
    do return end
  end
  v134 = function(c17v0)
    local c17v1, c17v2
    c17v1 = tonumber
    c17v1 = c17v1(c17v0)
    c17v2 = 4
    if c17v1 == c17v2 then
      c17v1 = v133
      c17v2 = true
      c17v1(c17v2)
    end
    do return end
  end
  OnExitScreenConfirm = v134
  v134 = function()
    local c18v0
    c18v0 = v132
    c18v0()
    do return end
  end
  OnTeleportedToConsole = v134
  v134 = function()
    local c19v0, c19v1, c19v2, c19v3, c19v4, c19v5, c19v6, c19v7, c19v8, c19v9
    c19v2 = v45
    c19v2 = c19v2.mElements
    c19v1 = #c19v2
    c19v2 = 0
    if c19v1 <= c19v2 then
      c19v0 = false
    else
      c19v0 = true
    end
    c19v1 = mMovie
    c19v3 = "SellList.Tip"
    c19v4 = 13
    c19v5 = not c19v0
    c19v1:Name__d9713943(c19v3, c19v4, c19v5)
    if c19v0 then
      c19v1 = _T.InventoryInfo
      if c19v1 ~= nil then
        c19v1 = _T.InventoryInfo.MinSellAmount
        if c19v1 ~= nil then
          c19v1 = 0
          c19v4 = 1
          c19v5 = v45
          c19v5 = c19v5.mElements
          c19v2 = #c19v5
          c19v3 = 1
          for __renovice_for_0_0 = c19v4, c19v2, c19v3 do
            c19v6 = v45
            c19v6 = c19v6.mElements
            c19v5 = c19v6[__renovice_for_0_0]
            c19v6 = v24
            c19v6 = c19v6.Ternary
            c19v8 = c19v5.Count
            if c19v8 == nil then
              c19v7 = false
            else
              c19v7 = true
            end
            c19v8 = c19v5.Count
            c19v9 = 1
            c19v6 = c19v6(c19v7, c19v8, c19v9)
            c19v1 = c19v1 + c19v6
          end
          c19v2 = _T.InventoryInfo.MinSellAmount
          if c19v1 < c19v2 then
            c19v0 = false
          else
            c19v0 = true
          end
        end
      end
    end
    c19v1 = v95
    c19v2 = v94
    c19v2 = c19v2.MODS_SKIP_LIST
    if c19v1 == c19v2 then
      c19v0 = true
    end
    c19v2 = v44
    c19v1 = IsNull
    c19v1 = c19v1(c19v2)
    if not c19v1 then
      c19v1 = v44
      c19v1:SetActive(c19v0)
    end
    do return end
  end
  v135 = function(c21v0)
    local c21v1, c21v2, c21v3, c21v4, c21v5, c21v6
    local __renovice_state_0 = 0
    c21v2 = v46
    c21v1 = IsNull
    c21v1 = c21v1(c21v2)
    if c21v1 then
      __renovice_state_0 = 3
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c21v1 = c21v0.UID
      if c21v1 == nil then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c21v1 = v46
      c21v3 = c21v0.UID
      c21v1 = c21v1:IsWeaponLocked(c21v3)
      if not c21v1 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c21v1 = v24
      c21v1 = c21v1.ShowMessage
      c21v2 = "/Lotus/Language/Menu/WeaponLockedUnsellable"
      c21v1(c21v2)
      c21v1 = false
      do return c21v1 end
    elseif __renovice_state_0 == 4 then
      c21v1 = c21v0.Category
      c21v2 = false
      c21v3 = 0
      c21v4 = v43
      c21v6 = function(c20v0)
        local c20v1, c20v2, c20v3
        c20v1 = c20v0.Category
        c20v2 = c21v1
        if c20v1 == c20v2 then
          c20v1 = c20v0.Selected
          if not c20v1 then
            c20v2 = c21v3
            c20v1 = c20v2 + 1
            c21v3 = c20v1
            c20v1 = c20v0.UID
            if c20v1 ~= nil then
              c20v1 = v46
              c20v3 = c20v0.UID
              c20v1 = c20v1:IsWeaponLocked(c20v3)
              if c20v1 then
                c20v1 = true
                c21v2 = c20v1
              end
            end
          end
        end
        do return end
      end
      c21v4:RunForAllElements(c21v6)
      c21v4 = 3
      if (c21v4 <= c21v3 or not c21v2) then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c21v4 = c21v0.Selected
      if c21v4 ~= false then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c21v4 = v24
      c21v4 = c21v4.ShowMessage
      c21v5 = "/Lotus/Language/Menu/LastItemOtherLockedUnsellable"
      c21v4(c21v5)
      c21v4 = false
      do return c21v4 end
    elseif __renovice_state_0 == 8 then
      c21v4 = true
      do return c21v4 end
    end
    do return end
  end
  v136 = function(c22v0)
    local c22v1, c22v2
    c22v2 = c22v0.mClipName
    c22v1 = IsNull
    c22v1 = c22v1(c22v2)
    if not c22v1 then
      c22v1 = v43
      c22v1 = c22v1.mElementDrawCallback
      c22v1(c22v0)
    end
    do return end
  end
  v137 = function(c23v0, c23v1)
    local c23v2, c23v3, c23v4, c23v5
    c23v2 = {}
    c23v3 = pairs
    c23v3, c23v4, c23v5 = c23v3(c23v0)
    for __renovice_for_0_0, __renovice_for_0_1 in c23v3, c23v4, c23v5 do
      c23v2[__renovice_for_0_0] = __renovice_for_0_1
    end
    c23v3 = c23v0.Id
    c23v2.LookupId = c23v3
    c23v3 = nil
    c23v2.Id = c23v3
    c23v3 = true
    c23v2.SellGrid = c23v3
    c23v3 = nil
    c23v2.mIndex = c23v3
    c23v3 = nil
    c23v2.mClipName = c23v3
    c23v3 = nil
    c23v2.mForceRedraw = c23v3
    c23v3 = nil
    c23v2.mInitialized = c23v3
    c23v3 = nil
    c23v2.InitDepth = c23v3
    c23v2.Count = c23v1
    c23v3 = c23v2.Card
    if c23v3 ~= nil then
      c23v3 = true
      c23v2.OverrideCardCount = c23v3
    end
    do return c23v2 end
  end
  v138 = function(c24v0)
    local c24v1
    c24v1 = true
    c24v0.MarkedToSell = c24v1
    c24v1 = v136
    c24v1(c24v0)
    do return end
  end
  v139 = function(c25v0)
    local c25v1, c25v2, c25v3, c25v4, c25v5, c25v6, c25v7, c25v8, c25v9, c25v10, c25v11, c25v12, c25v13, c25v14, c25v15
    local __renovice_state_0 = 0
    c25v2 = v58
    c25v1 = c25v2 + c25v0
    v58 = c25v1
    c25v1 = ""
    c25v2 = ""
    c25v3 = v95
    c25v4 = v94
    c25v4 = c25v4.FISH
    if c25v3 ~= c25v4 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c25v3 = _T.FishInvInfo.ShowRep
      if not c25v3 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c25v3 = v95
      c25v4 = v94
      c25v4 = c25v4.DECODONATE
      if c25v3 == c25v4 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c25v3 = v95
      c25v4 = v94
      c25v4 = c25v4.RESDONATE
      if c25v3 ~= c25v4 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c25v3 = mMovie
      c25v5 = "/Lotus/Language/Menu/ItemInventory_SelectPile"
      c25v6 = false
      c25v1 = c25v3:GetLocalized(c25v5, c25v6)
      __renovice_state_0 = 22
    end
    if __renovice_state_0 == 5 then
      c25v3 = Localize
      c25v4 = v61
      c25v5 = {}
      c25v1 = c25v3(c25v4, c25v5)
      c25v3 = v25
      c25v3 = c25v3.GetColor
      c25v4 = 9
      c25v5 = true
      c25v3 = c25v3(c25v4, c25v5)
      c25v4 = v25
      c25v4 = c25v4.GetColor
      c25v5 = 9
      c25v6 = true
      c25v4 = c25v4(c25v5, c25v6)
      c25v5 = v24
      c25v5 = c25v5.ConvertColorNumberToHex
      c25v3 = c25v5(c25v3)
      c25v5 = v24
      c25v5 = c25v5.ConvertColorNumberToHex
      c25v4 = c25v5(c25v4)
      c25v5 = ""
      c25v6 = v95
      c25v7 = v94
      c25v7 = c25v7.ENEMIES
      if c25v6 ~= c25v7 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c25v9 = v24
      c25v9 = c25v9.FormatNumber
      c25v10 = v58
      c25v6 = c25v9(c25v10)
      c25v7 = "/"
      c25v8 = v24
      c25v8 = c25v8.FormatNumber
      c25v9 = v17
      c25v8 = c25v8(c25v9)
      c25v5 = c25v6 .. c25v7 .. c25v8
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 7 then
      c25v6 = v129
      c25v6 = c25v6()
      if not c25v6 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      c25v6 = 0
      c25v8 = v45
      c25v7 = IsNull
      c25v7 = c25v7(c25v8)
      if c25v7 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c25v7 = v45
      c25v7 = c25v7.mUnfilteredElements
      c25v6 = #c25v7
      __renovice_state_0 = 10
    end
    if __renovice_state_0 == 10 then
      c25v10 = v24
      c25v10 = c25v10.FormatNumber
      c25v7 = c25v10(c25v6)
      c25v8 = "/"
      c25v9 = v24
      c25v9 = c25v9.FormatNumber
      c25v10 = _T.InvTradingInfo.Slots
      c25v9 = c25v9(c25v10)
      c25v5 = c25v7 .. c25v8 .. c25v9
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 11 then
      c25v6 = v95
      c25v7 = v94
      c25v7 = c25v7.MODS_SKIP_LIST
      if c25v6 ~= c25v7 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      c25v6 = 0
      c25v8 = v45
      c25v7 = IsNull
      c25v7 = c25v7(c25v8)
      if c25v7 then
        __renovice_state_0 = 14
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      c25v7 = v45
      c25v7 = c25v7.mElements
      c25v6 = #c25v7
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 14 then
      c25v10 = v24
      c25v10 = c25v10.FormatNumber
      c25v7 = c25v10(c25v6)
      c25v8 = "/"
      c25v9 = v24
      c25v9 = c25v9.FormatNumber
      c25v10 = _T.InvModSkipListSelection.Slots
      c25v9 = c25v9(c25v10)
      c25v5 = c25v7 .. c25v8 .. c25v9
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 15 then
      c25v7 = v59
      c25v6 = #c25v7
      c25v7 = 0
      if c25v6 <= c25v7 then
        __renovice_state_0 = 17
      else
        __renovice_state_0 = 16
      end
    end
    if __renovice_state_0 == 16 then
      c25v6 = mMovie
      c25v8 = v59
      c25v9 = true
      c25v10 = { CURRENCY = nil, PRICE = nil }
      c25v12 = "<"
      c25v15 = v86
      c25v15 = c25v15:GetLongDesc()
      c25v13 = c25v15:c_str()
      c25v14 = ">"
      c25v11 = c25v12 .. c25v13 .. c25v14
      c25v10.CURRENCY = c25v11
      c25v11 = v24
      c25v11 = c25v11.FormatNumber
      c25v12 = v58
      c25v11 = c25v11(c25v12)
      c25v10.PRICE = c25v11
      c25v5 = c25v6:GetLocalized(c25v8, c25v9, c25v10)
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 17 then
      c25v1 = ""
      c25v6 = true
      v97 = c25v6
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 18 then
      c25v7 = "</font><font color=\""
      c25v9 = "\">"
      c25v11 = "</font>"
      c25v6 = c25v7 .. c25v4 .. c25v9 .. c25v5 .. c25v11
      c25v7 = v95
      c25v8 = v94
      c25v8 = c25v8.FISH
      if c25v7 ~= c25v8 then
        __renovice_state_0 = 20
      else
        __renovice_state_0 = 19
      end
    end
    if __renovice_state_0 == 19 then
      c25v6 = c25v5
      c25v7 = "</font><font color=\""
      c25v9 = "\">"
      c25v11 = "</font>"
      c25v2 = c25v7 .. c25v4 .. c25v9 .. c25v6 .. c25v11
      __renovice_state_0 = 21
    end
    if __renovice_state_0 == 20 then
      c25v7 = mMovie
      c25v9 = v60
      c25v10 = false
      c25v11 = { TOTAL = nil }
      c25v11.TOTAL = c25v6
      c25v2 = c25v7:GetLocalized(c25v9, c25v10, c25v11)
      __renovice_state_0 = 21
    end
    if __renovice_state_0 == 21 then
      c25v7 = "<p><font color=\""
      c25v9 = "\">"
      c25v11 = "</p>"
      c25v2 = c25v7 .. c25v3 .. c25v9 .. c25v2 .. c25v11
      __renovice_state_0 = 22
    end
    if __renovice_state_0 == 22 then
      c25v3 = mMovie
      c25v5 = "SellList.Total"
      c25v6 = 36
      c25v3:SetStringVariable(c25v5, c25v6, c25v1)
      c25v3 = mMovie
      c25v5 = "SellList.Amount"
      c25v6 = 36
      c25v3:SetStringVariable(c25v5, c25v6, c25v2)
      do return end
    end
    do return end
  end
  v140 = function(c26v0, c26v1)
    local c26v2, c26v3, c26v4, c26v5, c26v6, c26v7
    c26v2 = IsNull
    c26v2 = c26v2(c26v1)
    if not c26v2 then
      c26v4 = 1
      c26v5 = c26v1.LookupIds
      c26v2 = #c26v5
      c26v3 = 1
      for __renovice_for_0_0 = c26v4, c26v2, c26v3 do
        c26v6 = c26v1.LookupIds
        c26v5 = c26v6[__renovice_for_0_0]
        c26v6 = c26v0.Id
        if c26v5 ~= c26v6 then
          continue
        end
        c26v5 = table.remove
        c26v6 = c26v1.LookupIds
        c26v5(c26v6, __renovice_for_0_0)
        break
      end
      c26v3 = c26v1.LookupIds
      c26v2 = #c26v3
      if c26v2 == 0 then
        c26v2 = nil
        c26v1.MarkedToSell = c26v2
      end
      c26v2 = v136
      c26v2(c26v1)
    end
    c26v2 = v45
    c26v4 = c26v0.mIndex
    c26v2:UnfocusElement(c26v4)
    c26v2 = v129
    c26v2 = c26v2()
    if c26v2 then
      c26v2 = v45
      c26v4 = c26v0.Id
      c26v5 = false
      c26v6 = true
      c26v2:RemoveUnfilteredElementById(c26v4, c26v5, c26v6)
    else
      c26v2 = v45
      c26v4 = c26v0.mIndex
      c26v5 = false
      c26v6 = false
      c26v2:RemoveElement(c26v4, c26v5, c26v6)
    end
    c26v3 = v45
    c26v3 = c26v3.mScrollBar
    c26v2 = IsNull
    c26v2 = c26v2(c26v3)
    if not c26v2 then
      c26v2 = v45
      c26v2 = c26v2.mScrollBar
      c26v4 = v45
      c26v4 = c26v4.mScrollBar
      c26v4 = c26v4.mCurrentScroll
      c26v5 = false
      c26v6 = true
      c26v2:SetScrollValue(c26v4, c26v5, c26v6)
    end
    c26v2 = 0
    c26v3 = c26v0.SellingPrice
    if c26v3 ~= nil then
      c26v4 = v24
      c26v4 = c26v4.Ternary
      c26v6 = c26v0.Count
      c26v5 = IsNull
      c26v5 = c26v5(c26v6)
      c26v6 = 1
      c26v7 = c26v0.Count
      c26v4 = c26v4(c26v5, c26v6, c26v7)
      c26v5 = c26v0.SellingPrice
      c26v3 = c26v4 * c26v5
      c26v2 = -c26v3
    end
    c26v3 = v139
    c26v3(c26v2)
    do return end
  end
  v141 = function(c27v0)
    local c27v1, c27v2, c27v3, c27v4, c27v5, c27v6, c27v7, c27v8
    c27v2 = c27v0.RawItem
    c27v1 = IsNull
    c27v1 = c27v1(c27v2)
    if c27v1 then
      c27v1 = false
      do return c27v1 end
    end
    c27v3 = c27v0.SellingPrice
    c27v2 = IsNull
    c27v2 = c27v2(c27v3)
    c27v1 = not c27v2
    if c27v1 then
      c27v1 = false
      c27v2 = c27v0.SellingPrice
      if c27v2 ~= 0 then
        c27v2 = c27v0.WillExpire
        c27v1 = not c27v2
        if c27v1 then
          c27v2 = c27v0.PreventSelling
          c27v1 = not c27v2
        end
      end
    end
    c27v2 = v5
    c27v4 = c27v0.RawItem
    c27v4 = c27v4.mItemType
    c27v2 = c27v2:GetStoreItem(c27v4)
    c27v3 = v23
    c27v3 = c27v3.IsWeaponMastered
    c27v4 = c27v0.Type
    c27v3 = c27v3(c27v4)
    c27v4 = gGameConfig
    c27v6 = c27v0.Type
    c27v4 = c27v4:GetLevelCap(c27v6)
    if not c27v3 then
      c27v5 = c27v0.Rank
      if c27v4 <= c27v5 then
        c27v3 = true
      end
    end
    c27v5 = c27v0.RawItem
    c27v5 = c27v5.mModularParts
    if c27v5 ~= nil then
      c27v5 = true
      c27v6 = c27v0.Rank
      if c27v6 < c27v4 then
        c27v5 = false
        c27v6 = c27v0.Polarized
        if c27v6 ~= nil then
          c27v6 = c27v0.Polarized
          c27v7 = 0
          if c27v6 <= c27v7 then
            c27v5 = false
          else
            c27v5 = true
          end
        end
      end
      c27v3 = c27v5
    end
    c27v5 = c27v1
    if c27v5 then
      c27v5 = v26
      c27v5 = c27v5.IsRankShowing
      c27v7 = c27v0.MetaData
      c27v5 = c27v5(c27v0, c27v7)
      if c27v5 then
        c27v5 = false
        if c27v2 ~= nil then
          c27v8 = gRecipeStoreItemType
          c27v6 = c27v2:IsA(c27v8)
          c27v5 = not c27v6
          if c27v5 then
            c27v5 = not c27v3
          end
        end
      end
    end
    do return c27v5 end
  end
  v142 = function(c29v0, c29v1, c29v2, c29v3)
    local c29v4, c29v5, c29v6, c29v7, c29v8, c29v9, c29v10, c29v11, c29v12, c29v13, c29v14, c29v15
    local __renovice_local_0 = c29v0.LookupIds
    local __renovice_local_1 = #__renovice_local_0
    c29v7 = v137
    c29v7 = c29v7(c29v0, __renovice_local_1)
    c29v8 = v45
    c29v11 = false
    c29v8:AddElement(c29v7, c29v11)
    c29v9 = c29v0.LookupIds
    c29v10 = c29v7.Id
    c29v8 = table.insert
    c29v8(c29v9, c29v10)
    c29v8 = c29v0.SellingPrice
    if c29v8 ~= nil then
      c29v9 = c29v0.SellingPrice
      c29v8 = __renovice_local_1 * c29v9
      __renovice_local_0 = __renovice_local_0 + c29v8
    end
    __renovice_local_0 = 0
    local __renovice_state_0 = 1
    c29v4 = v129
    c29v4 = c29v4()
    if c29v4 then
      __renovice_state_0 = __renovice_local_1
      __renovice_local_1 = 1
    end
    c29v4 = {}
    c29v0.LookupIds = c29v4
    c29v6 = 1
    c29v4 = __renovice_state_0
    c29v5 = 1
    for __renovice_for_0_0 = c29v6, c29v4, c29v5 do
    end
    __renovice_local_1 = c29v0.Rank
    if __renovice_local_1 ~= nil then
      __renovice_local_1 = v99
      __renovice_local_0 = v98
      __renovice_local_0 = __renovice_local_0.INVENTORY
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_local_1 = c29v0.MarkedToSell
        if not __renovice_local_1 then
          __renovice_local_0 = v5
          __renovice_local_1 = IsNull
          __renovice_local_1 = __renovice_local_1(__renovice_local_0)
          if not __renovice_local_1 then
            __renovice_local_1 = v141
            __renovice_local_1 = __renovice_local_1(c29v0)
            if (__renovice_local_1 and not c29v3) then
              __renovice_local_1 = gGameConfig
              __renovice_state_0 = c29v0.Type
              __renovice_local_1 = __renovice_local_1:GetLevelCap(__renovice_state_0)
              __renovice_local_0 = "/Lotus/Language/Ranks/MaxRank30_SellWarning"
              if __renovice_local_1 == 40 then
                __renovice_local_0 = "/Lotus/Language/Ranks/MaxRank40_SellWarning"
              end
              __renovice_state_0 = c29v0.Id
              v55 = __renovice_state_0
              __renovice_state_0 = mMovie
              c29v6 = false
              c29v7 = { ITEMNAME = nil }
              c29v8 = mMovie
              c29v10 = v5
              c29v12 = c29v0.RawItem
              c29v12 = c29v12.mItemType
              c29v10 = c29v10:GetStoreItem(c29v12)
              c29v10 = c29v10:GetLocalizeTag()
              c29v10 = c29v10:c_str()
              c29v11 = false
              c29v8 = c29v8:GetLocalized(c29v10, c29v11)
              c29v7.ITEMNAME = c29v8
              __renovice_state_0 = __renovice_state_0:GetLocalized(__renovice_local_0, c29v6, c29v7)
              c29v4 = Engine.DialogSettings
              c29v4 = c29v4()
              c29v5 = 1
              c29v4.dialogType = c29v5
              c29v4.locString = __renovice_state_0
              c29v5 = "/Lotus/Language/Menu/ItemSelection_Sell"
              c29v4.firstString = c29v5
              c29v5 = "/Lotus/Language/Labels/ItemSelection_Keep"
              c29v4.secondString = c29v5
              c29v7 = "ConfirmSelection"
              c29v4:SetCallback(c29v7)
              c29v5 = gClient
              c29v5 = c29v5:GetOverlayMgr()
              c29v5:ShowDialog(c29v4)
              do return end
            end
          end
        end
      end
    end
    __renovice_local_1 = v99
    __renovice_local_0 = v98
    __renovice_local_0 = __renovice_local_0.INVENTORY
    local __renovice_state_1 = 10
    __renovice_local_1 = c29v0.MarkedToSell
    if __renovice_local_1 then
    else
      __renovice_state_1 = 11
    end
    if __renovice_state_1 == 11 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.MODS_SKIP_LIST
      if __renovice_local_1 == __renovice_local_0 then
      else
        __renovice_state_1 = 12
      end
    end
    if __renovice_state_1 == 12 then
      __renovice_local_1 = c29v0.Card
      __renovice_local_0 = nil
      __renovice_state_0 = IsNull
      __renovice_state_0 = __renovice_state_0(__renovice_local_1)
      if __renovice_state_0 then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 13
      end
    end
    if __renovice_state_1 == 13 then
      __renovice_state_0 = v87
      if __renovice_state_0 then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 14
      end
    end
    if __renovice_state_1 == 14 then
      __renovice_local_0 = __renovice_local_1.mInstalled
      if __renovice_local_0 == nil then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 15
      end
    end
    if __renovice_state_1 == 15 then
      __renovice_state_0 = __renovice_local_1.mType
      if __renovice_state_0 ~= "AURA" then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 16
      end
    end
    if __renovice_state_1 == 16 then
      c29v4 = v46
      __renovice_state_0 = IsNull
      __renovice_state_0 = __renovice_state_0(c29v4)
      if __renovice_state_0 then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 17
      end
    end
    if __renovice_state_1 == 17 then
      c29v4 = v5
      __renovice_state_0 = IsNull
      __renovice_state_0 = __renovice_state_0(c29v4)
      if __renovice_state_0 then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 18
      end
    end
    if __renovice_state_1 == 18 then
      __renovice_state_0 = nil
      c29v4 = "\r\n"
      c29v5 = v46
      c29v5 = c29v5:GetInventory()
      c29v6 = pairs
      c29v6, c29v7, c29v8 = c29v6(__renovice_local_0)
      __renovice_state_1 = 21
    end
    if __renovice_state_1 == 19 then
      __renovice_state_0 = c29v5:Name__34888a88(c29v9)
      c29v11 = v5
      c29v13 = __renovice_state_0.mItemType
      __renovice_state_0 = c29v11:GetStoreItem(c29v13)
      c29v11 = IsNull
      c29v11 = c29v11(__renovice_state_0)
      if c29v11 then
        __renovice_state_1 = 21
      else
        __renovice_state_1 = 20
      end
    end
    if __renovice_state_1 == 20 then
      c29v12 = "\r\n"
      c29v13 = mMovie
      c29v14 = tostring
      c29v14 = c29v14(__renovice_state_0:GetLocalizeTag())
      c29v15 = false
      c29v13 = c29v13:GetLocalized(c29v14, c29v15)
      c29v4 = c29v4 .. c29v12 .. c29v13
      __renovice_state_1 = 21
    end
    if __renovice_state_1 == 21 then
      __renovice_state_1 = 22
    end
    if __renovice_state_1 == 22 then
      c29v6 = #c29v4
      c29v7 = 0
      if c29v6 <= c29v7 then
        __renovice_state_1 = 24
      else
        __renovice_state_1 = 23
      end
    end
    if __renovice_state_1 == 23 then
      c29v6 = mMovie
      c29v8 = "/Lotus/Language/Dojo/AuraInstalledWarning"
      c29v9 = true
      c29v10 = { MOD = nil, ITEMS = nil }
      c29v11 = __renovice_local_1.mName
      c29v10.MOD = c29v11
      c29v10.ITEMS = c29v4
      c29v6 = c29v6:GetLocalized(c29v8, c29v9, c29v10)
      c29v7 = v24
      c29v7 = c29v7.ShowMessage
      c29v7(c29v6)
      do return end
    elseif __renovice_state_1 == 24 then
      if __renovice_local_0 ~= nil then
        __renovice_state_1 = 27
      else
        __renovice_state_1 = 25
      end
    end
    if __renovice_state_1 == 25 then
      __renovice_state_0 = v95
      c29v4 = v94
      c29v4 = c29v4.TRADE_ITEMS
      if __renovice_state_0 ~= c29v4 then
        __renovice_state_1 = 33
      else
        __renovice_state_1 = 26
      end
    end
    if __renovice_state_1 == 26 then
      __renovice_state_0 = c29v0.mModInstalledTable
      if __renovice_state_0 == nil then
        __renovice_state_1 = 33
      else
        __renovice_state_1 = 27
      end
    end
    if __renovice_state_1 == 27 then
      __renovice_state_0 = v95
      c29v4 = v94
      c29v4 = c29v4.MODS_SKIP_LIST
      if __renovice_state_0 == c29v4 then
        __renovice_state_1 = 33
      else
        __renovice_state_1 = 28
      end
    end
    if __renovice_state_1 == 28 then
      c29v4 = c29v0.Type
      __renovice_state_0 = IsNull
      __renovice_state_0 = __renovice_state_0(c29v4)
      if __renovice_state_0 then
        __renovice_state_1 = 32
      else
        __renovice_state_1 = 29
      end
    end
    if __renovice_state_1 == 29 then
      __renovice_state_0 = c29v0.Type
      c29v5 = v2
      __renovice_state_0 = __renovice_state_0:IsA(c29v5)
      if __renovice_state_0 then
        __renovice_state_1 = 31
      else
        __renovice_state_1 = 30
      end
    end
    if __renovice_state_1 == 30 then
      __renovice_state_0 = c29v0.Type
      c29v5 = v3
      __renovice_state_0 = __renovice_state_0:IsA(c29v5)
      if not __renovice_state_0 then
        __renovice_state_1 = 32
      else
        __renovice_state_1 = 31
      end
    end
    if __renovice_state_1 == 31 then
      __renovice_state_0 = v24
      __renovice_state_0 = __renovice_state_0.ShowMessage
      c29v4 = mMovie
      c29v6 = "/Lotus/Language/Dojo/ArcaneInstalledWarning"
      c29v7 = false
      __renovice_state_0(c29v4:GetLocalized(c29v6, c29v7))
    end
    if __renovice_state_1 == 32 then
      __renovice_state_0 = v24
      __renovice_state_0 = __renovice_state_0.ShowMessage
      c29v4 = mMovie
      c29v6 = "/Lotus/Language/Dojo/ModInstalledWarning"
      c29v7 = false
      __renovice_state_0(c29v4:GetLocalized(c29v6, c29v7))
    end
    if __renovice_state_1 == 33 then
      __renovice_state_0 = c29v0.ArchonShards
      if __renovice_state_0 == nil then
      else
        __renovice_state_1 = 34
      end
    end
    if __renovice_state_1 == 34 then
      __renovice_state_0 = v24
      __renovice_state_0 = __renovice_state_0.ShowMessage
      c29v4 = mMovie
      c29v6 = "/Lotus/Language/Alchemy/ArchonShardsInstalledWarning"
      c29v7 = false
      c29v8 = { COUNT = nil }
      c29v9 = v24
      c29v9 = c29v9.FormatNumber
      c29v10 = c29v0.ArchonShards
      c29v9 = c29v9(c29v10)
      c29v8.COUNT = c29v9
      __renovice_state_0(c29v4:GetLocalized(c29v6, c29v7, c29v8))
    end
    for __renovice_for_1_0, __renovice_for_1_1 in c29v6, c29v7, c29v8 do
    end
    __renovice_local_1 = v95
    __renovice_local_0 = v94
    __renovice_local_0 = __renovice_local_0.ENEMIES
    if __renovice_local_1 == __renovice_local_0 then
      __renovice_local_1 = _T.InfoPopup_Data
      if __renovice_local_1 ~= nil then
        __renovice_local_1 = _T.InfoPopup_Data
        __renovice_local_0 = nil
        __renovice_local_1.TagType = __renovice_local_0
        __renovice_local_1 = _T.InfoPopup_Data
        __renovice_state_0 = v17
        c29v4 = v58
        __renovice_local_0 = __renovice_state_0 - c29v4
        __renovice_local_1.CountOverride = __renovice_local_0
        __renovice_local_1 = v99
        __renovice_local_0 = v98
        __renovice_local_0 = __renovice_local_0.INVENTORY
        if __renovice_local_1 == __renovice_local_0 then
          __renovice_local_1 = _T.InfoPopup_Data.CountOverride
          __renovice_local_0 = 0
          if __renovice_local_1 <= __renovice_local_0 then
            __renovice_local_1 = c29v0.MarkedToSell
            if not __renovice_local_1 then
              __renovice_local_1 = v24
              __renovice_local_1 = __renovice_local_1.ShowErrorMessage
              __renovice_local_0 = "/Lotus/Language/Menu/EnemySelector_MaxCountReached"
              __renovice_local_1(__renovice_local_0)
              __renovice_local_1 = false
              do return __renovice_local_1 end
            end
          end
        end
      end
    else
      local __renovice_state_2 = 42
      __renovice_local_1 = v99
      __renovice_local_0 = v98
      __renovice_local_0 = __renovice_local_0.INVENTORY
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_2 = 63
      else
        __renovice_state_2 = 43
      end
      if __renovice_state_2 == 43 then
        __renovice_local_1 = c29v0.MarkedToSell
        if __renovice_local_1 then
          __renovice_state_2 = 63
        else
          __renovice_state_2 = 44
        end
      end
      if __renovice_state_2 == 44 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.DECODONATE
        if __renovice_local_1 == __renovice_local_0 then
          __renovice_state_2 = 48
        else
          __renovice_state_2 = 45
        end
      end
      if __renovice_state_2 == 45 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.RESDONATE
        if __renovice_local_1 == __renovice_local_0 then
          __renovice_state_2 = 48
        else
          __renovice_state_2 = 46
        end
      end
      if __renovice_state_2 == 46 then
        __renovice_local_1 = v129
        __renovice_local_1 = __renovice_local_1()
        if __renovice_local_1 then
          __renovice_state_2 = 48
        else
          __renovice_state_2 = 47
        end
      end
      if __renovice_state_2 == 47 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.MODS_SKIP_LIST
        if __renovice_local_1 ~= __renovice_local_0 then
          __renovice_state_2 = 63
        else
          __renovice_state_2 = 48
        end
      end
      if __renovice_state_2 == 48 then
        __renovice_local_1 = v129
        __renovice_local_1 = __renovice_local_1()
        if not __renovice_local_1 then
          __renovice_state_2 = 56
        else
          __renovice_state_2 = 49
        end
      end
      if __renovice_state_2 == 49 then
        __renovice_local_0 = v45
        __renovice_local_0 = __renovice_local_0.mUnfilteredElements
        __renovice_local_1 = #__renovice_local_0
        __renovice_local_0 = _T.InvTradingInfo.Slots
        if __renovice_local_1 < __renovice_local_0 then
          __renovice_state_2 = 51
        else
          __renovice_state_2 = 50
        end
      end
      if __renovice_state_2 == 50 then
        __renovice_local_1 = v24
        __renovice_local_1 = __renovice_local_1.ShowErrorMessage
        __renovice_local_0 = "/Lotus/Language/Dojo/Trade_MaxSlotsReached"
        __renovice_local_1(__renovice_local_0)
        do return end
      elseif __renovice_state_2 == 51 then
        __renovice_local_1 = c29v0.RawItem
        if __renovice_local_1 == nil then
        else
          __renovice_state_2 = 52
        end
      end
      if __renovice_state_2 == 52 then
        __renovice_local_0 = c29v0.RawItem
        __renovice_local_0 = __renovice_local_0.Nemesis
        __renovice_local_1 = IsNull
        __renovice_local_1 = __renovice_local_1(__renovice_local_0)
        if __renovice_local_1 then
        else
          __renovice_state_2 = 53
        end
      end
      if __renovice_state_2 == 53 then
        __renovice_local_1 = false
        __renovice_local_0 = v45
        c29v4 = function(c28v0)
          local c28v1, c28v2
          c28v1 = c28v0.RawItem
          if c28v1 ~= nil then
            c28v2 = c28v0.RawItem
            c28v2 = c28v2.Nemesis
            c28v1 = IsNull
            c28v1 = c28v1(c28v2)
            if not c28v1 then
              c28v1 = true
              __renovice_local_1 = c28v1
            end
          end
          do return end
        end
        __renovice_local_0:RunForAllElements(c29v4)
        if not __renovice_local_1 then
          __renovice_state_2 = 55
        else
          __renovice_state_2 = 54
        end
      end
      if __renovice_state_2 == 54 then
        __renovice_local_0 = v24
        __renovice_local_0 = __renovice_local_0.ShowErrorMessage
        __renovice_state_0 = "/Lotus/Language/Dojo/Trade_LichLimit"
        __renovice_local_0(__renovice_state_0)
        do return end
      end
      do
        local __renovice_unused_condition_0 = __renovice_state_2 == 55
      end
      if __renovice_state_2 == 56 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.MODS_SKIP_LIST
        if __renovice_local_1 ~= __renovice_local_0 then
          __renovice_state_2 = 60
        else
          __renovice_state_2 = 57
        end
      end
      if __renovice_state_2 == 57 then
        __renovice_local_0 = v45
        __renovice_local_0 = __renovice_local_0.mElements
        __renovice_local_1 = #__renovice_local_0
        __renovice_local_0 = _T.InvModSkipListSelection.Slots
        if __renovice_local_1 < __renovice_local_0 then
        else
          __renovice_state_2 = 58
        end
      end
      if __renovice_state_2 == 58 then
        do return end
      elseif __renovice_state_2 == 60 then
        __renovice_local_1 = v45
        __renovice_local_1 = __renovice_local_1:GetHowManyElements()
        __renovice_local_0 = 10
        if __renovice_local_1 < __renovice_local_0 then
        else
          __renovice_state_2 = 61
        end
      end
      if __renovice_state_2 == 61 then
        __renovice_local_1 = mMovie
        __renovice_state_0 = "/Lotus/Language/Dojo/VaultContributionDecoTooMany"
        c29v4 = false
        c29v5 = { NUM = nil }
        c29v7 = 10
        c29v6 = tostring
        c29v6 = c29v6(c29v7)
        c29v5.NUM = c29v6
        __renovice_local_1 = __renovice_local_1:GetLocalized(__renovice_state_0, c29v4, c29v5)
        __renovice_local_0 = v24
        __renovice_local_0 = __renovice_local_0.ShowErrorMessage
        __renovice_local_0(__renovice_local_1)
        do return end
      elseif __renovice_state_2 == 63 then
        __renovice_local_1 = v129
        __renovice_local_1 = __renovice_local_1()
        if __renovice_local_1 then
        else
          __renovice_state_2 = 64
        end
      end
      if __renovice_state_2 == 64 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.FISH
        if __renovice_local_1 == __renovice_local_0 then
        else
          __renovice_state_2 = 65
        end
      end
      if __renovice_state_2 == 65 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.DECODONATE
        if __renovice_local_1 == __renovice_local_0 then
        else
          __renovice_state_2 = 66
        end
      end
      if __renovice_state_2 == 66 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.RESDONATE
        if __renovice_local_1 == __renovice_local_0 then
        else
          __renovice_state_2 = 67
        end
      end
      if __renovice_state_2 == 67 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.SHIP_PARTS
        if __renovice_local_1 == __renovice_local_0 then
        else
          __renovice_state_2 = 68
        end
      end
      if __renovice_state_2 == 68 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.MODS_SKIP_LIST
        if __renovice_local_1 == __renovice_local_0 then
        else
          __renovice_state_2 = 69
        end
      end
      if __renovice_state_2 == 69 then
        if c29v0 == nil then
          __renovice_state_2 = 74
        else
          __renovice_state_2 = 70
        end
      end
      if __renovice_state_2 == 70 then
        __renovice_local_1 = c29v0.SellingPrice
        if __renovice_local_1 == nil then
          __renovice_state_2 = 74
        else
          __renovice_state_2 = 71
        end
      end
      if __renovice_state_2 == 71 then
        __renovice_local_1 = c29v0.SellingPrice
        if __renovice_local_1 == 0 then
          __renovice_state_2 = 74
        else
          __renovice_state_2 = 72
        end
      end
      if __renovice_state_2 == 72 then
        __renovice_local_1 = v135
        __renovice_local_1 = __renovice_local_1(c29v0)
        if not __renovice_local_1 then
          __renovice_state_2 = 74
        else
          __renovice_state_2 = 73
        end
      end
      if __renovice_state_2 == 73 then
        __renovice_local_1 = c29v0.PreventSelling
        if __renovice_local_1 ~= true then
          __renovice_state_2 = 75
        else
          __renovice_state_2 = 74
        end
      end
      if __renovice_state_2 == 74 then
        __renovice_local_1 = v24
        __renovice_local_1 = __renovice_local_1.PlaySound
        __renovice_local_0 = _G
        __renovice_local_0 = __renovice_local_0.UISound_Error
        __renovice_local_1(__renovice_local_0)
        do return end
      elseif __renovice_state_2 == 75 then
        __renovice_local_1 = c29v0.Category
        __renovice_local_0 = 18
        if __renovice_local_1 ~= __renovice_local_0 then
          __renovice_state_2 = 80
        else
          __renovice_state_2 = 76
        end
      end
      if __renovice_state_2 == 76 then
        __renovice_local_0 = v46
        __renovice_local_1 = IsNull
        __renovice_local_1 = __renovice_local_1(__renovice_local_0)
        if __renovice_local_1 then
          __renovice_state_2 = 78
        else
          __renovice_state_2 = 77
        end
      end
      if __renovice_state_2 == 77 then
        __renovice_local_1 = v46
        __renovice_state_0 = c29v0.UID
        __renovice_local_1 = __renovice_local_1:IsResourceDroneDeployed(__renovice_state_0)
        if not __renovice_local_1 then
        else
          __renovice_state_2 = 78
        end
      end
      if __renovice_state_2 == 78 then
        __renovice_local_1 = v24
        __renovice_local_1 = __renovice_local_1.ShowMessage
        __renovice_local_0 = "/Lotus/Language/Menu/ItemInventory_ResourceDroneDeployed"
        __renovice_local_1(__renovice_local_0)
        do return end
      elseif __renovice_state_2 == 80 then
        __renovice_local_1 = v99
        __renovice_local_0 = v98
        __renovice_local_0 = __renovice_local_0.INVENTORY
        if __renovice_local_1 ~= __renovice_local_0 then
        else
          __renovice_state_2 = 81
        end
      end
      if __renovice_state_2 == 81 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.ARCANE
        if __renovice_local_1 ~= __renovice_local_0 then
        else
          __renovice_state_2 = 82
        end
      end
      if __renovice_state_2 == 82 then
        __renovice_local_1 = c29v0.MarkedToSell
        if __renovice_local_1 then
        else
          __renovice_state_2 = 83
        end
      end
      if __renovice_state_2 == 83 then
        __renovice_local_1 = c29v0.mInstalled
        if __renovice_local_1 == nil then
        else
          __renovice_state_2 = 84
        end
      end
      if __renovice_state_2 == 84 then
        __renovice_local_1 = c29v0.Count
        if __renovice_local_1 == 1 then
          __renovice_state_2 = 87
        else
          __renovice_state_2 = 85
        end
      end
      if __renovice_state_2 == 85 then
        __renovice_local_1 = c29v0.UID
        if __renovice_local_1 == nil then
        else
          __renovice_state_2 = 86
        end
      end
      if __renovice_state_2 == 86 then
        __renovice_local_1 = c29v0.UID
        if __renovice_local_1 == "" then
        else
          __renovice_state_2 = 87
        end
      end
      if __renovice_state_2 == 87 then
        __renovice_local_1 = c29v0.Category
        __renovice_local_0 = 4
        if __renovice_local_1 == __renovice_local_0 then
          if c29v2 ~= nil then
          else
            __renovice_state_2 = 89
          end
        end
      end
      if __renovice_state_2 == 89 then
        __renovice_local_1 = -1
        __renovice_local_0 = pairs
        __renovice_state_0 = c29v0.mInstalled
        __renovice_local_0, __renovice_state_0, c29v4 = __renovice_local_0(__renovice_state_0)
        __renovice_state_2 = 91
      end
      if __renovice_state_2 == 90 then
        __renovice_local_1 = __renovice_local_1 + 1
        __renovice_state_2 = 91
      end
      if __renovice_state_2 == 91 then
        __renovice_state_2 = 92
      end
      if __renovice_state_2 == 92 then
        __renovice_local_0 = ""
        __renovice_state_0 = 0
        if __renovice_local_1 <= __renovice_state_0 then
          __renovice_state_2 = 94
        else
          __renovice_state_2 = 93
        end
      end
      if __renovice_state_2 == 93 then
        __renovice_state_0 = mMovie
        c29v5 = "/Lotus/Language/SystemMessages/ConfirmDistillInstalledWarningExtra"
        c29v6 = true
        c29v7 = { COUNT = nil }
        c29v7.COUNT = __renovice_local_1
        __renovice_local_0 = __renovice_state_0:GetLocalized(c29v5, c29v6, c29v7)
        __renovice_state_2 = 94
      end
      if __renovice_state_2 == 94 then
        __renovice_state_0 = mMovie
        c29v5 = "/Lotus/Language/SystemMessages/ConfirmDistillInstalledWarning"
        c29v6 = true
        c29v7 = { ITEM = nil, NAME = nil, EXTRA = nil }
        c29v8 = c29v0.Name
        c29v7.ITEM = c29v8
        c29v8 = string.upper
        c29v9 = c29v0.FirstInstalledName
        c29v8 = c29v8(c29v9)
        c29v7.NAME = c29v8
        c29v7.EXTRA = __renovice_local_0
        __renovice_state_0 = __renovice_state_0:GetLocalized(c29v5, c29v6, c29v7)
        c29v4 = c29v0.Id
        v55 = c29v4
        c29v4 = v24
        c29v4 = c29v4.ShowYesOrNoMessage
        c29v6 = "ConfirmSelection"
        c29v4(__renovice_state_0, c29v6)
        do return end
      end
    end
    __renovice_local_1 = v99
    __renovice_local_0 = v98
    __renovice_local_0 = __renovice_local_0.INVENTORY
    __renovice_local_1 = c29v0.MarkedToSell
    if ((not __renovice_local_1 and not c29v1) and not c29v2) then
      local __renovice_state_3 = 99
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.ENEMIES
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_state_3 = 102
      else
        __renovice_state_3 = 100
      end
      if __renovice_state_3 == 100 then
        __renovice_local_1 = c29v0.Count
        if __renovice_local_1 == nil then
        else
          __renovice_state_3 = 101
        end
      end
      if __renovice_state_3 == 101 then
        __renovice_local_1 = c29v0.Count
        __renovice_local_0 = 1
        if __renovice_local_1 <= __renovice_local_0 then
        else
          __renovice_state_3 = 102
        end
      end
      if __renovice_state_3 == 102 then
        __renovice_local_1 = c29v0.Id
        v55 = __renovice_local_1
        __renovice_local_1 = _T.InfoPopup_Data
        if __renovice_local_1 == nil then
          __renovice_state_3 = 121
        else
          __renovice_state_3 = 103
        end
      end
      if __renovice_state_3 == 103 then
        __renovice_local_1 = v95
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.ARCANE
        if __renovice_local_1 ~= __renovice_local_0 then
          __renovice_state_3 = 105
        else
          __renovice_state_3 = 104
        end
      end
      if __renovice_state_3 == 104 then
        __renovice_local_1 = _T.InfoPopup_Data
        __renovice_local_0 = "OKSaveSelectedArcaneCount"
        __renovice_local_1.Callback = __renovice_local_0
        __renovice_state_3 = 106
      end
      if __renovice_state_3 == 105 then
        __renovice_local_1 = _T.InfoPopup_Data
        __renovice_local_0 = "OKSaveSelectedCount"
        __renovice_local_1.Callback = __renovice_local_0
        __renovice_state_3 = 106
      end
      if __renovice_state_3 == 106 then
        __renovice_local_1 = v129
        __renovice_local_1 = __renovice_local_1()
        if not __renovice_local_1 then
          __renovice_state_3 = 108
        else
          __renovice_state_3 = 107
        end
      end
      if __renovice_state_3 == 107 then
        __renovice_local_1 = _T.InfoPopup_Data
        __renovice_state_0 = _T.InfoPopup_Data.Count
        c29v5 = _T.InvTradingInfo.Slots
        c29v7 = v45
        c29v7 = c29v7.mUnfilteredElements
        c29v6 = #c29v7
        c29v4 = c29v5 - c29v6
        __renovice_local_0 = math.min
        __renovice_local_0 = __renovice_local_0(__renovice_state_0, c29v4)
        __renovice_local_1.CountOverride = __renovice_local_0
        __renovice_state_3 = 120
      end
      if __renovice_state_3 == 108 then
        __renovice_local_1 = _T.SyndicateInvInfo
        if __renovice_local_1 == nil then
          __renovice_state_3 = 120
        else
          __renovice_state_3 = 109
        end
      end
      if __renovice_state_3 == 109 then
        __renovice_local_1 = c29v0.SellingPrice
        __renovice_local_0 = 0
        if __renovice_local_1 <= __renovice_local_0 then
          __renovice_state_3 = 120
        else
          __renovice_state_3 = 110
        end
      end
      if __renovice_state_3 == 110 then
        __renovice_local_0 = _T.SyndicateInvInfo.MaxRepInc
        __renovice_state_0 = v58
        __renovice_local_1 = __renovice_local_0 - __renovice_state_0
        __renovice_local_0 = "/Lotus/Language/SystemMessages/SyndicateStandingCapped"
        __renovice_state_0 = {}
        c29v4 = _T.SyndicateInvInfo.Syndicate
        c29v4 = c29v4:StandingBonusesCappedByDailyLimit()
        if not c29v4 then
          __renovice_state_3 = 117
        else
          __renovice_state_3 = 111
        end
      end
      if __renovice_state_3 == 111 then
        c29v4 = _T.SyndicateInvInfo.Syndicate
        c29v4 = c29v4:GetDailyStandingLimitBin()
        c29v5 = 0
        if c29v4 <= c29v5 then
          __renovice_state_3 = 117
        else
          __renovice_state_3 = 112
        end
      end
      if __renovice_state_3 == 112 then
        c29v5 = 15
        if c29v5 <= c29v4 then
          __renovice_state_3 = 117
        else
          __renovice_state_3 = 113
        end
      end
      if __renovice_state_3 == 113 then
        c29v5 = gGameData
        c29v5 = c29v5:GetDailyStandingLimit(c29v4)
        c29v6 = _T.SyndicateInvInfo.MaxRepInc
        if c29v6 ~= c29v5 then
          __renovice_state_3 = 117
        else
          __renovice_state_3 = 114
        end
      end
      if __renovice_state_3 == 114 then
        c29v6 = _T.SyndicateInvInfo.Syndicate
        c29v6 = c29v6:GetUIName()
        c29v6 = c29v6:c_str()
        if c29v6 ~= "/Lotus/Language/Syndicates/CetusName" then
          __renovice_state_3 = 116
        else
          __renovice_state_3 = 115
        end
      end
      if __renovice_state_3 == 115 then
        c29v6 = "/Lotus/Language/Syndicates/CetusNameInline"
        __renovice_state_3 = 116
      end
      if __renovice_state_3 == 116 then
        __renovice_local_0 = "/Lotus/Language/SystemMessages/SyndicateDailyStandingCapped"
        c29v7 = { SYNDICATE = nil }
        c29v8 = Localize
        c29v10 = nil
        c29v8 = c29v8(c29v6, c29v10)
        c29v7.SYNDICATE = c29v8
        __renovice_state_0 = c29v7
        __renovice_state_3 = 117
      end
      if __renovice_state_3 == 117 then
        c29v4 = Localize
        __renovice_local_0 = c29v4(__renovice_local_0, __renovice_state_0)
        c29v6 = c29v0.SellingPrice
        c29v5 = __renovice_local_1 / c29v6
        c29v4 = math.ceil
        c29v4 = c29v4(c29v5)
        c29v5 = 0
        if c29v5 < c29v4 then
          __renovice_state_3 = 119
        else
          __renovice_state_3 = 118
        end
      end
      if __renovice_state_3 == 118 then
        c29v5 = v24
        c29v5 = c29v5.ShowErrorMessage
        c29v6 = mMovie
        c29v9 = false
        c29v5(c29v6:GetLocalized(__renovice_local_0, c29v9))
        c29v5 = v24
        c29v5 = c29v5.BlinkClip
        c29v6 = mMovie
        c29v7 = "SellList.Total"
        c29v5(c29v6, c29v7)
        do return end
      elseif __renovice_state_3 == 119 then
        c29v5 = _T.InfoPopup_Data
        c29v7 = c29v0.Count
        c29v6 = math.min
        c29v6 = c29v6(c29v7, c29v4)
        c29v5.MaxSelectionCount = c29v6
        __renovice_state_3 = 120
      end
      if __renovice_state_3 == 120 then
        __renovice_local_1 = mMovie
        __renovice_state_0 = inputCountDialog
        __renovice_local_1:PushChildMovie(__renovice_state_0)
        __renovice_state_3 = 121
      end
      if __renovice_state_3 == 121 then
        do return end
      end
    end
    __renovice_local_0 = v53
    __renovice_local_1 = IsNull
    __renovice_local_1 = __renovice_local_1(__renovice_local_0)
    if not __renovice_local_1 then
      __renovice_state_0 = _T
      c29v4 = v53
      __renovice_local_0 = __renovice_state_0[c29v4]
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(__renovice_local_0)
      if not __renovice_local_1 then
        __renovice_local_0 = _T
        __renovice_state_0 = v53
        __renovice_local_1 = __renovice_local_0[__renovice_state_0]
        __renovice_local_1(c29v0)
      end
    end
    __renovice_local_1 = c29v0.LookupIds
    __renovice_local_1 = c29v2
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    if (__renovice_local_0 or c29v1) then
      local __renovice_state_4 = 129
      __renovice_local_0 = _T.SyndicateInvInfo
      if __renovice_local_0 == nil then
        __renovice_state_4 = 132
      else
        __renovice_state_4 = 130
      end
      if __renovice_state_4 == 130 then
        __renovice_local_0 = c29v0.SellingPrice
        __renovice_state_0 = 0
        if __renovice_local_0 <= __renovice_state_0 then
          __renovice_state_4 = 132
        else
          __renovice_state_4 = 131
        end
      end
      if __renovice_state_4 == 131 then
        __renovice_state_0 = _T.SyndicateInvInfo.MaxRepInc
        c29v4 = v58
        __renovice_local_0 = __renovice_state_0 - c29v4
        c29v5 = c29v0.SellingPrice
        c29v4 = __renovice_local_0 / c29v5
        __renovice_state_0 = math.ceil
        __renovice_state_0 = __renovice_state_0(c29v4)
        c29v5 = c29v0.Count
        c29v4 = math.min
        __renovice_local_1 = c29v4(c29v5, __renovice_state_0)
      end
      if __renovice_state_4 == 132 then
        __renovice_local_0 = v24
        __renovice_local_0 = __renovice_local_0.Ternary
        c29v4 = v95
        c29v5 = v94
        c29v5 = c29v5.ENEMIES
        if c29v4 == c29v5 then
          __renovice_state_4 = 134
        else
          __renovice_state_4 = 133
        end
      end
      if __renovice_state_4 == 133 then
        __renovice_state_0 = false
        __renovice_state_4 = 135
      end
      if __renovice_state_4 == 134 then
        __renovice_state_0 = true
        __renovice_state_4 = 135
      end
      if __renovice_state_4 == 135 then
        c29v4 = 5
        c29v5 = c29v0.Count
        __renovice_local_1 = __renovice_local_0(__renovice_state_0, c29v4, c29v5)
      end
    end
    __renovice_local_0 = v95
    __renovice_state_0 = v94
    __renovice_state_0 = __renovice_state_0.ENEMIES
    if __renovice_local_0 == __renovice_state_0 then
      c29v5 = v17
      c29v6 = v58
      c29v4 = c29v5 - c29v6
      __renovice_local_0 = math.min
      __renovice_local_1 = __renovice_local_0(__renovice_local_1, c29v4)
    end
    __renovice_local_0 = 0
    if __renovice_local_1 ~= 0 then
      __renovice_local_1 = v140
      __renovice_state_0 = v43
      c29v5 = c29v0.LookupId
      __renovice_local_1(c29v0, __renovice_state_0:GetUnfilteredElementById(c29v5))
      __renovice_local_1 = v24
      __renovice_local_1 = __renovice_local_1.PlaySound
      __renovice_local_0 = _G
      __renovice_local_0 = __renovice_local_0.UISound_Select
      __renovice_local_1(__renovice_local_0)
      __renovice_local_1 = v24
      __renovice_local_1 = __renovice_local_1.PlaySound
      __renovice_local_0 = _G
      __renovice_local_0 = __renovice_local_0.UISound_WindowClose
      __renovice_local_1(__renovice_local_0)
    else
      __renovice_local_0 = v95
      __renovice_state_0 = v94
      __renovice_state_0 = __renovice_state_0.ENEMIES
      if __renovice_local_0 ~= __renovice_state_0 then
        __renovice_local_0 = v24
        __renovice_local_0 = __renovice_local_0.ShowErrorMessage
        __renovice_state_0 = mMovie
        c29v5 = "/Lotus/Language/SystemMessages/SyndicateStandingCapped"
        c29v6 = false
        __renovice_local_0(__renovice_state_0:GetLocalized(c29v5, c29v6))
        __renovice_local_0 = v24
        __renovice_local_0 = __renovice_local_0.BlinkClip
        __renovice_state_0 = mMovie
        c29v4 = "SellList.Total"
        __renovice_local_0(__renovice_state_0, c29v4)
      end
      c29v4 = v129
      c29v4 = c29v4()
      if c29v4 then
        c29v4 = v45
        c29v5 = true
        c29v4.mSortingChanged = c29v5
        c29v4 = v45
        c29v6 = nil
        c29v7 = false
        c29v8 = true
        c29v4:Redraw(c29v6, c29v7, c29v8)
      end
      c29v4 = v139
      c29v4(__renovice_local_0)
      c29v4 = v24
      c29v4 = c29v4.PlaySound
      c29v5 = _G
      c29v5 = c29v5.UISound_ButtonSelect
      c29v4(c29v5)
      c29v4 = v138
      c29v4(c29v0)
      __renovice_local_1 = c29v0.MarkedToSell
      if __renovice_local_1 then
        while true do
          __renovice_local_0 = c29v0.LookupIds
          __renovice_local_1 = #__renovice_local_0
          __renovice_local_0 = 0
          if __renovice_local_1 <= __renovice_local_0 then break end
          __renovice_local_1 = v45
          c29v4 = c29v0.LookupIds
          __renovice_state_0 = c29v4[1]
          __renovice_local_1 = __renovice_local_1:GetElementById(__renovice_state_0)
          __renovice_local_0 = v140
          __renovice_local_0(__renovice_local_1, c29v0)
        end
        __renovice_local_1 = v24
        __renovice_local_1 = __renovice_local_1.PlaySound
        __renovice_local_0 = _G
        __renovice_local_0 = __renovice_local_0.UISound_WindowClose
        __renovice_local_1(__renovice_local_0)
      end
    end
    __renovice_local_1 = v134
    __renovice_local_1()
    __renovice_local_1 = true
    do return __renovice_local_1 end
  end
  v143 = function(c30v0)
    local c30v1, c30v2, c30v3, c30v4
    c30v2 = c30v0.SellGrid
    c30v1 = not c30v2
    if c30v1 then
      c30v1 = false
      c30v2 = c30v0.LookupIds
      if c30v2 ~= nil then
        c30v3 = c30v0.LookupIds
        c30v2 = #c30v3
        c30v3 = 0
        if c30v2 <= c30v3 then
          c30v1 = false
        else
          c30v1 = true
        end
      end
    end
    c30v2 = v95
    c30v3 = v94
    c30v3 = c30v3.MODS_SKIP_LIST
    if c30v2 == c30v3 then
      c30v2 = c30v0.Selected
      if not c30v2 then
        c30v2 = false
        c30v3 = c30v0.LookupIds
        if c30v3 ~= nil then
          c30v4 = c30v0.LookupIds
          c30v3 = #c30v4
          c30v4 = 0
          if c30v3 <= c30v4 then
            c30v2 = false
          else
            c30v2 = true
          end
        end
      end
      c30v1 = c30v2
    end
    do return c30v1 end
  end
  v144 = function(c31v0)
    local c31v1, c31v2, c31v3, c31v4, c31v5, c31v6, c31v7
    c31v1 = c31v0.mClipName
    if c31v1 == nil then
      do return end
    end
    c31v1 = nil
    c31v2 = c31v0.SellGrid
    if c31v2 then
      c31v1 = v45
      c31v2 = v98
      c31v2 = c31v2.SELL
      v99 = c31v2
    else
      c31v1 = v43
      c31v2 = v98
      c31v2 = c31v2.INVENTORY
      v99 = c31v2
    end
    c31v2 = c31v0.Locked
    if c31v2 then
      c31v3 = v95
      c31v4 = v94
      c31v4 = c31v4.ENEMIES
      if c31v3 ~= c31v4 then
        c31v2 = false
      else
        c31v2 = true
      end
    end
    if c31v2 then
      c31v3 = "/Lotus/Language/Menu/EnemySelector_Locked"
      c31v0.ToolTip = c31v3
    end
    c31v3 = { IgnoreCount = nil, IsFocused = true, IsSelected = nil, ShowToolTip = nil, ShowInfoPopup = nil }
    local __renovice_local_0 = v95
    c31v5 = v94
    c31v5 = c31v5.ENEMIES
    if __renovice_local_0 ~= c31v5 then
      c31v4 = false
    else
      c31v4 = true
    end
    c31v3.IgnoreCount = c31v4
    c31v4 = v143
    c31v4 = c31v4(c31v0)
    c31v3.IsSelected = c31v4
    c31v3.ShowToolTip = c31v2
    __renovice_local_0 = c31v2
    if not __renovice_local_0 then
      __renovice_local_0 = c31v0.Hidden
    end
    c31v4 = not __renovice_local_0
    c31v3.ShowInfoPopup = c31v4
    c31v4 = Engine.IsPlayingWithTouchscreen
    c31v4 = c31v4()
    if c31v4 then
      c31v4 = c31v0.SellGrid
      if not c31v4 then
        c31v4 = v46
        c31v4 = c31v4:GetInventory()
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c31v4)
        if not __renovice_local_0 then
          c31v5 = c31v0.RawItem
          __renovice_local_0 = IsNull
          __renovice_local_0 = __renovice_local_0(c31v5)
          if not __renovice_local_0 then
            c31v5 = c31v0.RawItem
            c31v5 = c31v5.mIsNew
            __renovice_local_0 = IsNull
            __renovice_local_0 = __renovice_local_0(c31v5)
            if not __renovice_local_0 then
              __renovice_local_0 = c31v0.RawItem
              c31v5 = false
              __renovice_local_0.mIsNew = c31v5
              c31v6 = c31v0.RawItem
              c31v6 = c31v6.mItemId
              c31v7 = false
              c31v4:Name__09786676(c31v6, c31v7)
              c31v6 = c31v0.RawItem
              c31v6 = c31v6.mItemId
              c31v7 = false
              c31v4:Name__b192667a(c31v6, c31v7)
              __renovice_local_0 = v136
              __renovice_local_0(c31v0)
            end
          end
        end
        __renovice_local_0 = v124
        __renovice_local_0 = __renovice_local_0.popupState
        c31v5 = v123
        c31v5 = c31v5.HIDE_DURING_LONG_PRESS
        if __renovice_local_0 == c31v5 then
          __renovice_local_0 = false
          c31v3.ShowInfoPopup = __renovice_local_0
        else
          __renovice_local_0 = v124
          __renovice_local_0 = __renovice_local_0.popupState
          c31v5 = v123
          c31v5 = c31v5.SHOW_UNTIL_SCROLL_OR_TAP
          if __renovice_local_0 == c31v5 then
            __renovice_local_0 = true
            c31v3.NoAnimationOrSound = __renovice_local_0
          end
        end
      end
    end
    c31v4 = v26
    c31v4 = c31v4.OnGridItemFocusChanged
    __renovice_local_0 = mMovie
    c31v4(__renovice_local_0, c31v1, c31v0, c31v3)
    do return end
  end
  v145 = function(c32v0)
    local c32v1, c32v2, c32v3, c32v4, c32v5, c32v6, c32v7, c32v8, c32v9, c32v10
    c32v1 = c32v0.mClipName
    if c32v1 ~= nil then
      c32v1 = v143
      c32v1 = c32v1(c32v0)
      c32v2 = v24
      c32v2 = c32v2.Ternary
      c32v3 = c32v0.SellGrid
      c32v4 = v45
      c32v5 = v43
      c32v2 = c32v2(c32v3, c32v4, c32v5)
      c32v3 = v26
      c32v3 = c32v3.OnGridItemFocusChanged
      c32v4 = mMovie
      c32v5 = c32v2
      c32v6 = c32v0
      c32v7 = { IgnoreCount = nil, IsFocused = false, IsSelected = nil }
      c32v9 = v95
      c32v10 = v94
      c32v10 = c32v10.ENEMIES
      if c32v9 ~= c32v10 then
        c32v8 = false
      else
        c32v8 = true
      end
      c32v7.IgnoreCount = c32v8
      c32v7.IsSelected = c32v1
      c32v3(c32v4, c32v5, c32v6, c32v7)
    end
    c32v1 = Engine.IsPlayingWithTouchscreen
    c32v1 = c32v1()
    if c32v1 then
      c32v1 = c32v0.SellGrid
      if not c32v1 then
        c32v1 = _T
        c32v2 = nil
        c32v1.InfoPopup_Data = c32v2
        c32v1 = _T
        c32v2 = nil
        c32v1.InfoPopup_Grid = c32v2
        c32v1 = v124
        c32v2 = v123
        c32v2 = c32v2.DEFAULT
        c32v1.popupState = c32v2
      end
    end
    do return end
  end
  v146 = function(c33v0)
    local c33v1, c33v2, c33v3, c33v4
    c33v2 = v54
    c33v1 = IsNull
    c33v1 = c33v1(c33v2)
    if not c33v1 then
      c33v1 = v54
      c33v3 = "TransitionOut"
      c33v4 = ""
      c33v1:Execute(c33v3, c33v4)
    end
    if c33v0 == nil then
      do return end
    end
    if c33v0 then
      c33v1 = v45
      c33v1:RemoveElements()
      c33v1 = v139
      c33v3 = v58
      c33v2 = -c33v3
      c33v1(c33v2)
      c33v1 = v112
      c33v1()
      do return end
    end
    c33v1 = v24
    c33v1 = c33v1.ShowMessage
    c33v2 = "/Lotus/Language/Menu/Global_PurchaseFailed"
    c33v1(c33v2)
    do return end
  end
  v147 = function(c34v0, c34v1)
    local c34v2, c34v3, c34v4, c34v5, c34v6, c34v7
    c34v3 = v54
    c34v2 = IsNull
    c34v2 = c34v2(c34v3)
    if not c34v2 then
      c34v2 = v54
      c34v4 = "TransitionOut"
      c34v5 = ""
      c34v2:Execute(c34v4, c34v5)
    end
    if c34v0 == nil then
    else
      if c34v0 then
        c34v2 = v43
        c34v4 = v93
        c34v2 = c34v2:GetElementById(c34v4)
        c34v3 = IsNull
        c34v3 = c34v3(c34v2)
        if not c34v3 then
          c34v3 = c34v1.mQuantity
          c34v2.Count = c34v3
          c34v3 = v43
          c34v5 = nil
          c34v6 = true
          c34v7 = true
          c34v3:Redraw(c34v5, c34v6, c34v7)
          c34v3 = v142
          c34v5 = true
          c34v3(c34v2, c34v5)
        end
      else
        c34v2 = v24
        c34v2 = c34v2.ShowMessage
        c34v3 = "/Lotus/Language/Menu/Global_PurchaseFailed"
        c34v2(c34v3)
      end
    end
    c34v2 = nil
    v93 = c34v2
    do return end
  end
  v148 = function(c36v0, c36v1, c36v2, c36v3)
    local c36v4, c36v5, c36v6, c36v7
    local __renovice_state_0 = 0
    c36v4 = v24
    c36v4 = c36v4.Ternary
    local __renovice_local_0 = c36v0.SellGrid
    c36v5 = v98
    c36v5 = c36v5.SELL
    c36v6 = v98
    c36v6 = c36v6.INVENTORY
    c36v4 = c36v4(__renovice_local_0, c36v5, c36v6)
    v99 = c36v4
    __renovice_local_0 = c36v0.Locked
    if __renovice_local_0 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c36v4 = c36v0.Hidden
      if not c36v4 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c36v4 = true
      __renovice_local_0 = v95
      c36v5 = v94
      c36v5 = c36v5.ENEMIES
      if __renovice_local_0 ~= c36v5 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      __renovice_local_0 = c36v0.SellGrid
      c36v4 = not __renovice_local_0
      __renovice_state_0 = 4
    end
    if __renovice_state_0 == 4 then
      __renovice_local_0 = c36v0.BuySlot
      if not __renovice_local_0 then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      __renovice_local_0 = _T
      c36v5 = { ITEM = nil, CALLBACK = nil }
      c36v6 = { StoreItem = nil }
      c36v7 = c36v0.StoreItem
      c36v6.StoreItem = c36v7
      c36v5.ITEM = c36v6
      c36v6 = v146
      c36v5.CALLBACK = c36v6
      __renovice_local_0.marketDetailedViewParms = c36v5
      __renovice_local_0 = mMovie
      c36v6 = _G
      c36v6 = c36v6.UIMovie_DetailedPurchaseDialog
      __renovice_local_0 = __renovice_local_0:PushChildMovie(c36v6)
      v54 = __renovice_local_0
      do return end
    elseif __renovice_state_0 == 6 then
      __renovice_local_0 = c36v0.EmptySlot
      if __renovice_local_0 then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      __renovice_local_0 = c36v0.Filler
      if (__renovice_local_0 or c36v4) then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      __renovice_local_0 = c36v0.Plat
      if __renovice_local_0 then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      __renovice_local_0 = v95
      c36v5 = v94
      c36v5 = c36v5.TRADE_ITEMS
      if __renovice_local_0 ~= c36v5 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      __renovice_local_0 = c36v0.Card
      if __renovice_local_0 ~= nil then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      __renovice_local_0 = v95
      c36v5 = v94
      c36v5 = c36v5.TRADE_MODS
      if __renovice_local_0 ~= c36v5 then
        __renovice_state_0 = 14
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      __renovice_local_0 = c36v0.Card
      if __renovice_local_0 == nil then
        __renovice_state_0 = 16
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      __renovice_local_0 = v95
      c36v5 = v94
      c36v5 = c36v5.SYNDDONATE
      if __renovice_local_0 ~= c36v5 then
        __renovice_state_0 = 17
      else
        __renovice_state_0 = 15
      end
    end
    if __renovice_state_0 == 15 then
      __renovice_local_0 = c36v0.ShadowIcon
      if not __renovice_local_0 then
        __renovice_state_0 = 17
      else
        __renovice_state_0 = 16
      end
    end
    if __renovice_state_0 == 16 then
      do return end
    elseif __renovice_state_0 == 17 then
      __renovice_local_0 = v95
      c36v5 = v94
      c36v5 = c36v5.DECODONATE
      if __renovice_local_0 == c36v5 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 18
      end
    end
    if __renovice_state_0 == 18 then
      __renovice_local_0 = v95
      c36v5 = v94
      c36v5 = c36v5.RESDONATE
      if __renovice_local_0 ~= c36v5 then
        __renovice_state_0 = 21
      else
        __renovice_state_0 = 19
      end
    end
    if __renovice_state_0 == 19 then
      __renovice_local_0 = c36v0.Count
      if __renovice_local_0 ~= 0 then
        __renovice_state_0 = 21
      else
        __renovice_state_0 = 20
      end
    end
    if __renovice_state_0 == 20 then
      __renovice_local_0 = c36v0.Id
      v93 = __renovice_local_0
      __renovice_local_0 = _T
      c36v5 = { ITEM = nil, CALLBACK = nil }
      c36v6 = { StoreItem = nil }
      c36v7 = c36v0.StoreItem
      c36v6.StoreItem = c36v7
      c36v5.ITEM = c36v6
      c36v6 = v147
      c36v5.CALLBACK = c36v6
      __renovice_local_0.marketDetailedViewParms = c36v5
      __renovice_local_0 = mMovie
      c36v6 = _G
      c36v6 = c36v6.UIMovie_DetailedPurchaseDialog
      __renovice_local_0 = __renovice_local_0:PushChildMovie(c36v6)
      v54 = __renovice_local_0
      do return end
    elseif __renovice_state_0 == 21 then
      __renovice_local_0 = c36v0.IsPreset
      if not __renovice_local_0 then
        __renovice_state_0 = 23
      else
        __renovice_state_0 = 22
      end
    end
    if __renovice_state_0 == 22 then
      __renovice_local_0 = v122
      c36v5 = true
      __renovice_local_0(c36v5)
      __renovice_local_0 = true
      c36v5 = v43
      c36v7 = function(c35v0)
        local c35v1, c35v2, c35v3, c35v4, c35v5, c35v6, c35v7, c35v8
        c35v1 = __renovice_local_0
        if not c35v1 then
          do return end
        end
        c35v3 = 1
        c35v4 = c36v0
        c35v4 = c35v4.Types
        c35v1 = #c35v4
        c35v2 = 1
        for __renovice_for_0_0 = c35v3, c35v1, c35v2 do
          c35v4 = c35v0.Type
          c35v6 = c36v0
          c35v6 = c35v6.Types
          c35v5 = c35v6[__renovice_for_0_0]
          c35v5 = c35v5.mAvatarType
          if c35v4 ~= c35v5 then
            continue
          end
          c35v4 = v142
          c35v6 = nil
          c35v8 = c36v0
          c35v8 = c35v8.Types
          c35v7 = c35v8[__renovice_for_0_0]
          c35v7 = c35v7.mCount
          c35v4 = c35v4(c35v0, c35v6, c35v7)
          __renovice_local_0 = c35v4
          do return end
        end
        do return end
      end
      c36v5:RunForAllElements(c36v7)
    elseif __renovice_state_0 == 23 then
      __renovice_local_0 = v142
      __renovice_local_0(c36v0, c36v3)
      do return end
    end
    do return end
  end
  v149 = function(c37v0, c37v1)
    local c37v2, c37v3, c37v4
    c37v2 = v26
    c37v2 = c37v2.OnGridItemCreated
    c37v3 = mMovie
    c37v4 = v43
    c37v2(c37v3, c37v4, c37v0)
    if c37v1 ~= nil then
      c37v2 = _T.CheckModInstalled
      if c37v2 ~= nil then
        c37v2 = _T.CheckModInstalled
        c37v2(c37v1)
      end
    end
    do return end
  end
  v150 = function(c38v0, c38v1)
    local c38v2, c38v3, c38v4
    c38v2 = v26
    c38v2 = c38v2.OnGridItemCreated
    c38v3 = mMovie
    c38v4 = v45
    c38v2(c38v3, c38v4, c38v0)
    do return end
  end
  v151 = function(c39v0)
    local c39v1, c39v2, c39v3, c39v4, c39v5, c39v6, c39v7
    local __renovice_state_0 = 0
    c39v1 = c39v0.mClipName
    if c39v1 == nil then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c39v1 = mMovie
      c39v3 = c39v0.mClipName
      c39v1 = c39v1:HasVariable(c39v3)
      if c39v1 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      do return end
    elseif __renovice_state_0 == 3 then
      c39v1 = true
      c39v2 = v45
      c39v2 = c39v2:GetFocusedElement()
      if c39v0 == c39v2 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c39v2 = v43
      c39v2 = c39v2:GetFocusedElement()
      if c39v0 == c39v2 then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c39v1 = false
      __renovice_state_0 = 7
    end
    if __renovice_state_0 == 6 then
      c39v1 = true
      __renovice_state_0 = 7
    end
    if __renovice_state_0 == 7 then
      c39v2 = v143
      c39v2 = c39v2(c39v0)
      c39v3 = { IgnoreCount = nil, HideCountThreshold = 1, IsFiller = nil, IsFocused = nil, IsSelected = nil, IsInventory = true }
      c39v5 = v95
      c39v6 = v94
      c39v6 = c39v6.ENEMIES
      if c39v5 == c39v6 then
        __renovice_state_0 = 9
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      c39v4 = false
      __renovice_state_0 = 10
    end
    if __renovice_state_0 == 9 then
      c39v4 = true
      __renovice_state_0 = 10
    end
    if __renovice_state_0 == 10 then
      c39v3.IgnoreCount = c39v4
      c39v4 = c39v0.Filler
      if c39v4 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c39v4 = c39v0.EmptySlot
      __renovice_state_0 = 12
    end
    if __renovice_state_0 == 12 then
      c39v3.IsFiller = c39v4
      c39v3.IsFocused = c39v1
      c39v3.IsSelected = c39v2
      c39v4 = {}
      c39v3.OwnedInfo = c39v4
      c39v4 = c39v0.BuySlot
      if c39v4 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.ENEMIES
      if c39v4 == c39v5 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.SHARDS
      if c39v4 == c39v5 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 15
      end
    end
    if __renovice_state_0 == 15 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.DECODONATE
      if c39v4 == c39v5 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 16
      end
    end
    if __renovice_state_0 == 16 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.RESDONATE
      if c39v4 == c39v5 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 17
      end
    end
    if __renovice_state_0 == 17 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.SHIP_PARTS
      if c39v4 == c39v5 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 18
      end
    end
    if __renovice_state_0 == 18 then
      c39v4 = {}
      c39v3.SellInfo = c39v4
      __renovice_state_0 = 19
    end
    if __renovice_state_0 == 19 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.PRIMEPARTS
      if c39v4 ~= c39v5 then
        __renovice_state_0 = 21
      else
        __renovice_state_0 = 20
      end
    end
    if __renovice_state_0 == 20 then
      c39v4 = c39v3.SellInfo
      c39v5 = v26
      c39v5 = c39v5.LABEL_TYPE_DUCATS
      c39v4.LabelType = c39v5
      __renovice_state_0 = 27
    end
    if __renovice_state_0 == 21 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.TREASURE
      if c39v4 == c39v5 then
        __renovice_state_0 = 24
      else
        __renovice_state_0 = 22
      end
    end
    if __renovice_state_0 == 22 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.SHIP_SCRAP
      if c39v4 == c39v5 then
        __renovice_state_0 = 24
      else
        __renovice_state_0 = 23
      end
    end
    if __renovice_state_0 == 23 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.SHIP_RAW
      if c39v4 ~= c39v5 then
        __renovice_state_0 = 25
      else
        __renovice_state_0 = 24
      end
    end
    if __renovice_state_0 == 24 then
      c39v4 = c39v3.SellInfo
      c39v5 = v26
      c39v5 = c39v5.LABEL_TYPE_ENDO
      c39v4.LabelType = c39v5
      __renovice_state_0 = 27
    end
    if __renovice_state_0 == 25 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.ARCANE
      if c39v4 ~= c39v5 then
        __renovice_state_0 = 27
      else
        __renovice_state_0 = 26
      end
    end
    if __renovice_state_0 == 26 then
      c39v4 = c39v3.SellInfo
      c39v5 = v26
      c39v5 = c39v5.LABEL_TYPE_ARCANEDUST
      c39v4.LabelType = c39v5
      __renovice_state_0 = 27
    end
    if __renovice_state_0 == 27 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.SYNDDONATE
      if c39v4 ~= c39v5 then
        __renovice_state_0 = 31
      else
        __renovice_state_0 = 28
      end
    end
    if __renovice_state_0 == 28 then
      c39v4 = c39v0.Filler
      if c39v4 then
        __renovice_state_0 = 31
      else
        __renovice_state_0 = 29
      end
    end
    if __renovice_state_0 == 29 then
      c39v4 = c39v3.SellInfo
      c39v5 = v26
      c39v5 = c39v5.LABEL_TYPE_REPUTATION
      c39v4.LabelType = c39v5
      c39v4 = c39v0.RawItem
      c39v4 = c39v4.mStanding
      c39v0.SellingPrice = c39v4
      c39v4 = 0
      c39v3.HideCountThreshold = c39v4
      c39v4 = c39v3.OwnedInfo
      c39v5 = true
      c39v4.mShowOne = c39v5
      c39v4 = c39v0.Count
      if c39v4 ~= 0 then
        __renovice_state_0 = 31
      else
        __renovice_state_0 = 30
      end
    end
    if __renovice_state_0 == 30 then
      c39v4 = true
      c39v0.ShadowIcon = c39v4
      __renovice_state_0 = 31
    end
    if __renovice_state_0 == 31 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.ARCANE
      if c39v4 ~= c39v5 then
        __renovice_state_0 = 33
      else
        __renovice_state_0 = 32
      end
    end
    if __renovice_state_0 == 32 then
      c39v4 = true
      c39v3.FixedSellPrice = c39v4
      __renovice_state_0 = 33
    end
    if __renovice_state_0 == 33 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.FISH
      if c39v4 ~= c39v5 then
        __renovice_state_0 = 38
      else
        __renovice_state_0 = 34
      end
    end
    if __renovice_state_0 == 34 then
      c39v4 = c39v0.Filler
      if c39v4 then
        __renovice_state_0 = 38
      else
        __renovice_state_0 = 35
      end
    end
    if __renovice_state_0 == 35 then
      c39v4 = _T.FishInvInfo.ShowRep
      if not c39v4 then
        __renovice_state_0 = 37
      else
        __renovice_state_0 = 36
      end
    end
    if __renovice_state_0 == 36 then
      c39v4 = c39v3.SellInfo
      c39v5 = v26
      c39v5 = c39v5.LABEL_TYPE_REPUTATION
      c39v4.LabelType = c39v5
      c39v4 = c39v0.StoreItem
      c39v4 = c39v4:GetStandingBonus()
      c39v0.SellingPrice = c39v4
      __renovice_state_0 = 38
    end
    if __renovice_state_0 == 37 then
      c39v4 = nil
      c39v3.SellInfo = c39v4
      __renovice_state_0 = 38
    end
    if __renovice_state_0 == 38 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.DECODONATE
      if c39v4 == c39v5 then
        __renovice_state_0 = 41
      else
        __renovice_state_0 = 39
      end
    end
    if __renovice_state_0 == 39 then
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.RESDONATE
      if c39v4 == c39v5 then
        __renovice_state_0 = 41
      else
        __renovice_state_0 = 40
      end
    end
    if __renovice_state_0 == 40 then
      c39v4 = c39v3.OwnedInfo
      c39v5 = "/Lotus/Language/Menu/Crafting_Owned_Brief"
      c39v4.TagOverride = c39v5
      __renovice_state_0 = 46
    end
    if __renovice_state_0 == 41 then
      c39v4 = false
      c39v5 = c39v0.Count
      if c39v5 == nil then
        __renovice_state_0 = 45
      else
        __renovice_state_0 = 42
      end
    end
    if __renovice_state_0 == 42 then
      c39v5 = c39v0.Count
      c39v6 = 0
      if c39v6 < c39v5 then
        __renovice_state_0 = 44
      else
        __renovice_state_0 = 43
      end
    end
    if __renovice_state_0 == 43 then
      c39v4 = false
      __renovice_state_0 = 45
    end
    if __renovice_state_0 == 44 then
      c39v4 = true
      __renovice_state_0 = 45
    end
    if __renovice_state_0 == 45 then
      c39v3.HidePrice = c39v4
      c39v4 = 0
      c39v3.HideCountThreshold = c39v4
      c39v4 = c39v3.OwnedInfo
      c39v5 = true
      c39v4.mShowOne = c39v5
      __renovice_state_0 = 46
    end
    if __renovice_state_0 == 46 then
      c39v4 = c39v0.EmptySlot
      if not c39v4 then
        __renovice_state_0 = 48
      else
        __renovice_state_0 = 47
      end
    end
    if __renovice_state_0 == 47 then
      c39v4 = mMovie
      c39v6 = "/Lotus/Language/Menu/OpenChamber"
      c39v7 = false
      c39v4 = c39v4:GetLocalized(c39v6, c39v7)
      c39v3.NameOverride = c39v4
      __renovice_state_0 = 48
    end
    if __renovice_state_0 == 48 then
      c39v4 = c39v0.BuySlot
      if not c39v4 then
        __renovice_state_0 = 50
      else
        __renovice_state_0 = 49
      end
    end
    if __renovice_state_0 == 49 then
      c39v4 = 0
      c39v3.HideCountThreshold = c39v4
      c39v4 = c39v3.OwnedInfo
      c39v5 = true
      c39v4.mShowOne = c39v5
      __renovice_state_0 = 50
    end
    if __renovice_state_0 == 50 then
      c39v4 = c39v0.SpecialPrice
      if c39v4 == nil then
        __renovice_state_0 = 52
      else
        __renovice_state_0 = 51
      end
    end
    if __renovice_state_0 == 51 then
      c39v4 = { LabelType = nil, Price = nil }
      c39v5 = c39v0.PriceLabelType
      c39v4.LabelType = c39v5
      c39v5 = c39v0.SpecialPrice
      c39v4.Price = c39v5
      c39v3.SpecialPriceInfo = c39v4
      __renovice_state_0 = 52
    end
    if __renovice_state_0 == 52 then
      c39v4 = c39v0.Locked
      c39v3.Locked = c39v4
      c39v4 = c39v0.HideLockIcon
      c39v3.HideLockIcon = c39v4
      c39v4 = c39v0.LockedMsg
      c39v3.LockedMsg = c39v4
      c39v4 = false
      c39v5 = v95
      c39v6 = v94
      c39v6 = c39v6.TRADE_MODS
      if c39v5 ~= c39v6 then
        __renovice_state_0 = 54
      else
        __renovice_state_0 = 53
      end
    end
    if __renovice_state_0 == 53 then
      c39v5 = v27
      c39v5 = c39v5.IsLegendaryFusion
      c39v6 = c39v0.Card
      c39v5 = c39v5(c39v6)
      c39v4 = not c39v5
      __renovice_state_0 = 54
    end
    if __renovice_state_0 == 54 then
      c39v3.HideOwned = c39v4
      c39v4 = v95
      c39v5 = v94
      c39v5 = c39v5.MODS_SKIP_LIST
      if c39v4 ~= c39v5 then
        __renovice_state_0 = 56
      else
        __renovice_state_0 = 55
      end
    end
    if __renovice_state_0 == 55 then
      c39v4 = true
      c39v3.HidePrice = c39v4
      c39v4 = 0
      c39v3.HideCountThreshold = c39v4
      c39v4 = c39v3.OwnedInfo
      c39v5 = true
      c39v4.mShowOne = c39v5
      c39v4 = nil
      c39v3.SellInfo = c39v4
      c39v4 = true
      c39v3.HideOwned = c39v4
      c39v4 = false
      c39v3.Locked = c39v4
      __renovice_state_0 = 56
    end
    if __renovice_state_0 == 56 then
      c39v4 = v24
      c39v4 = c39v4.Ternary
      c39v5 = c39v0.EmptySlot
      c39v6 = 50
      c39v7 = 100
      c39v4 = c39v4(c39v5, c39v6, c39v7)
      c39v0.NameAlpha = c39v4
      c39v0.MetaData = c39v3
      c39v4 = v24
      c39v4 = c39v4.Ternary
      c39v5 = c39v0.SellGrid
      c39v6 = v45
      c39v7 = v43
      c39v4 = c39v4(c39v5, c39v6, c39v7)
      c39v5 = v26
      c39v5 = c39v5.DrawGridItem
      c39v6 = mMovie
      c39v5(c39v6, c39v4, c39v0, c39v3)
      do return end
    end
    do return end
  end
  v152 = function(c40v0)
    local c40v1
    c40v1 = v26
    c40v1 = c40v1.FitGridToWidth
    c40v1(c40v0)
    do return end
  end
  v153 = function(c41v0)
    local c41v1, c41v2, c41v3, c41v4, c41v5, c41v6, c41v7, c41v8, c41v9, c41v10, c41v11, c41v12, c41v13
    c41v3 = mMovie
    c41v5 = "SellList"
    c41v6 = 0
    c41v3 = c41v3:GetNumberVariable(c41v5, c41v6)
    c41v4 = mMovie
    c41v6 = "InventoryGrid"
    c41v7 = 0
    c41v4 = c41v4:GetNumberVariable(c41v6, c41v7)
    c41v2 = c41v3 - c41v4
    c41v1 = c41v2 - 45
    c41v2 = v43
    c41v2 = c41v2.Width
    if c41v1 ~= c41v2 then
      c41v2 = mMovie
      c41v4 = "InventoryGrid.Bounds"
      c41v5 = 14
      c41v2:SetNumberVariable(c41v4, c41v5, c41v1)
      c41v2 = mMovie
      c41v4 = "InventoryGrid.Bounds"
      c41v5 = 15
      c41v6 = 640
      c41v2:SetNumberVariable(c41v4, c41v5, c41v6)
      c41v2 = mMovie
      c41v4 = "InventoryGrid.Bounds"
      c41v5 = 13
      c41v6 = false
      c41v2:Name__d9713943(c41v4, c41v5, c41v6)
      v43.Width = c41v1
      c41v2 = v152
      c41v3 = v43
      c41v2(c41v3)
      if not c41v0 then
        c41v2 = v43
        c41v4 = nil
        c41v5 = true
        c41v6 = true
        c41v2:Redraw(c41v4, c41v5, c41v6)
      end
    end
    c41v2 = v100
    c41v4 = visibleRangeMat
    c41v5 = rectangleVisibleRangeMat
    c41v6 = textVisibleRangeMat
    c41v7 = flareVisibleRangeMat
    c41v8 = _G
    c41v8 = c41v8.UIMaterial_PigmentVisibilityRange
    c41v10 = _G
    c41v10 = c41v10.UIMaterial_SalvageMaterials
    c41v9 = c41v10[2]
    c41v3 = {c41v4, c41v5, c41v6, c41v7, c41v8, c41v9}
    c41v2.Materials = c41v3
    c41v2 = pairs
    c41v3 = _G
    c41v3 = c41v3.UIMaterial_CosmeticEnhancersStore
    c41v2, c41v3, c41v4 = c41v2(c41v3)
    for __renovice_for_0_0, __renovice_for_0_1 in c41v2, c41v3, c41v4 do
      c41v8 = v100
      c41v8 = c41v8.Materials
      c41v7 = table.insert
      c41v7(c41v8, __renovice_for_0_1)
    end
    c41v2 = pairs
    c41v3 = _G
    c41v3 = c41v3.UIMaterial_FocusLensStore
    c41v2, c41v3, c41v4 = c41v2(c41v3)
    for __renovice_for_1_0, __renovice_for_1_1 in c41v2, c41v3, c41v4 do
      c41v8 = v100
      c41v8 = c41v8.Materials
      c41v7 = table.insert
      c41v7(c41v8, __renovice_for_1_1)
    end
    c41v2 = pairs
    c41v3 = _G
    c41v3 = c41v3.UIMaterial_ArchonShardsStore
    c41v2, c41v3, c41v4 = c41v2(c41v3)
    for __renovice_for_2_0, __renovice_for_2_1 in c41v2, c41v3, c41v4 do
      c41v8 = v100
      c41v8 = c41v8.Materials
      c41v7 = table.insert
      c41v7(c41v8, __renovice_for_2_1)
    end
    repeat
      c41v2 = v95
      c41v3 = v94
      c41v3 = c41v3.TRADE_MODS
      if c41v2 ~= c41v3 then
        c41v2 = v95
        c41v3 = v94
        c41v3 = c41v3.MODS_SKIP_LIST
        if c41v2 ~= c41v3 then break end
      end
      c41v2 = pairs
      c41v3 = _G
      c41v3 = c41v3.UIMaterial_Mods
      c41v2, c41v3, c41v4 = c41v2(c41v3)
      for __renovice_for_3_0, __renovice_for_3_1 in c41v2, c41v3, c41v4 do
        c41v7 = pairs
        c41v7, c41v8, c41v9 = c41v7(__renovice_for_3_1)
        for __renovice_for_4_0, __renovice_for_4_1 in c41v7, c41v8, c41v9 do
          c41v13 = v100
          c41v13 = c41v13.Materials
          c41v12 = table.insert
          c41v12(c41v13, __renovice_for_4_1)
        end
      end
      c41v2 = pairs
      c41v3 = _G
      c41v3 = c41v3.UIMaterial_ModsSyndicateIcons
      c41v2, c41v3, c41v4 = c41v2(c41v3)
      for __renovice_for_5_0, __renovice_for_5_1 in c41v2, c41v3, c41v4 do
        c41v7 = pairs
        c41v7, c41v8, c41v9 = c41v7(__renovice_for_5_1)
        for __renovice_for_6_0, __renovice_for_6_1 in c41v7, c41v8, c41v9 do
          c41v13 = v100
          c41v13 = c41v13.Materials
          c41v12 = table.insert
          c41v12(c41v13, __renovice_for_6_1)
        end
      end
    until true
    c41v2 = ipairs
    c41v3 = _G
    c41v3 = c41v3.UIMaterial_RailjackModStore
    c41v2, c41v3, c41v4 = c41v2(c41v3)
    for __renovice_for_7_0, __renovice_for_7_1 in c41v2, c41v3, c41v4 do
      c41v8 = v100
      c41v8 = c41v8.Materials
      c41v7 = table.insert
      c41v7(c41v8, __renovice_for_7_1)
    end
    c41v2 = mMovie
    c41v2 = c41v2:Name__29315794()
    c41v3 = v100
    c41v4 = v43
    c41v4 = c41v4.Height
    c41v3.Height = c41v4
    c41v3 = v100
    c41v5 = mMovie
    c41v7 = "InventoryGrid"
    c41v8 = 1
    c41v5 = c41v5:GetNumberVariable(c41v7, c41v8)
    c41v7 = v100
    c41v7 = c41v7.Height
    c41v6 = c41v7 / 2
    c41v4 = c41v5 + c41v6
    c41v3.YPos = c41v4
    c41v3 = v24
    c41v3 = c41v3.GetVisibilityCenter
    c41v4 = mMovie
    c41v6 = v100
    c41v6 = c41v6.YPos
    c41v7 = c41v2 / 2
    c41v5 = c41v6 - c41v7
    c41v3 = c41v3(c41v4, c41v5)
    c41v4 = v24
    c41v4 = c41v4.GetVisibilitySize
    c41v5 = mMovie
    c41v6 = v100
    c41v6 = c41v6.Height
    c41v4 = c41v4(c41v5, c41v6)
    c41v5 = v24
    c41v5 = c41v5.GetVisibilityFadeSize
    c41v6 = mMovie
    c41v7 = 5
    c41v5 = c41v5(c41v6, c41v7)
    c41v6 = pairs
    c41v7 = v100
    c41v7 = c41v7.Materials
    c41v6, c41v7, c41v8 = c41v6(c41v7)
    for __renovice_for_8_0, __renovice_for_8_1 in c41v6, c41v7, c41v8 do
      c41v13 = Lotus_Game.VISIBILITY_CENTER
      __renovice_for_8_1:SetParam(c41v13, c41v3)
      c41v13 = Lotus_Game.VISIBILITY_SIZE
      __renovice_for_8_1:SetParam(c41v13, c41v4)
      c41v13 = Lotus_Game.VISIBILITY_FADE_SIZE
      __renovice_for_8_1:SetParam(c41v13, c41v5)
    end
    c41v6 = v24
    c41v6 = c41v6.GetVisibilityCenter
    c41v7 = mMovie
    c41v9 = mMovie
    c41v11 = "SellList.List"
    c41v12 = 3
    c41v9 = c41v9:GetNumberVariable(c41v11, c41v12)
    c41v11 = v66
    c41v10 = c41v11 / 2
    c41v8 = c41v9 + c41v10
    c41v3 = c41v6(c41v7, c41v8)
    c41v6 = v24
    c41v6 = c41v6.GetVisibilitySize
    c41v7 = mMovie
    c41v8 = v66
    c41v4 = c41v6(c41v7, c41v8)
    c41v6 = pairs
    c41v9 = sellListVisibleRangeMaterial
    c41v10 = sellListTextVisibleRangeMaterial
    c41v11 = sellListRectangleVisibleRangeMaterial
    c41v7 = {c41v9, c41v10, c41v11}
    c41v6, c41v7, c41v8 = c41v6(c41v7)
    for __renovice_for_9_0, __renovice_for_9_1 in c41v6, c41v7, c41v8 do
      c41v13 = Lotus_Game.VISIBILITY_CENTER
      __renovice_for_9_1:SetParam(c41v13, c41v3)
      c41v13 = Lotus_Game.VISIBILITY_SIZE
      __renovice_for_9_1:SetParam(c41v13, c41v4)
      c41v13 = Lotus_Game.VISIBILITY_FADE_SIZE
      __renovice_for_9_1:SetParam(c41v13, c41v5)
    end
    do return end
  end
  v154 = function()
    local c42v0, c42v1, c42v2, c42v3, c42v4, c42v5
    c42v1 = v43
    c42v0 = IsNull
    c42v0 = c42v0(c42v1)
    if not c42v0 then
      c42v0 = v40
      if not c42v0 then
        c42v0 = v43
        c42v0 = c42v0:GetFocusedElement()
        c42v1 = IsNull
        c42v1 = c42v1(c42v0)
        if c42v1 then
          do return end
        end
        c42v1 = v143
        c42v1 = c42v1(c42v0)
        c42v2 = v148
        c42v3 = true
        c42v4 = nil
        c42v5 = false
        c42v2(c42v0, c42v3, c42v4, c42v5)
        c42v2 = v143
        c42v2 = c42v2(c42v0)
        if c42v1 == c42v2 then
          c42v2 = v43
          c42v3 = c42v0.Id
          c42v2:UnfocusElementById(c42v3)
        end
        do return end
      end
    end
    do return end
  end
  OnSelectButtonPressed = v154
  v154 = function(c43v0)
    local c43v1, c43v2
    c43v1 = IsNull
    c43v1 = c43v1(c43v0)
    if c43v1 then
      c43v1 = false
      do return c43v1 end
    end
    c43v1 = c43v0:GetFocusedElement()
    c43v2 = IsNull
    c43v2 = c43v2(c43v1)
    if c43v2 then
      do return end
    end
    c43v2 = v143
    do return c43v2(c43v1) end
  end
  v155 = function()
    local c44v0, c44v1, c44v2, c44v3, c44v4, c44v5
    c44v0 = v154
    c44v1 = v43
    c44v0 = c44v0(c44v1)
    c44v2 = "/Lotus/Language/Menu/"
    c44v3 = v24
    c44v3 = c44v3.Ternary
    c44v4 = "Unselect"
    c44v5 = "Select"
    c44v3 = c44v3(c44v0, c44v4, c44v5)
    c44v1 = c44v2 .. c44v3
    c44v2 = mMovie
    c44v4 = false
    do return c44v2:GetLocalized(c44v1, c44v4) end
  end
  v156 = function(c45v0)
    local c45v1, c45v2, c45v3
    c45v1 = IsNull
    c45v1 = c45v1(c45v0)
    if c45v1 then
      c45v1 = false
      do return c45v1 end
    end
    c45v1 = v95
    c45v2 = v94
    c45v2 = c45v2.INVENTORY
    if c45v1 ~= c45v2 then
      c45v1 = true
      do return c45v1 end
    end
    c45v3 = c45v0.SellingPrice
    c45v2 = IsNull
    c45v2 = c45v2(c45v3)
    c45v1 = not c45v2
    if c45v1 then
      c45v1 = false
      c45v2 = c45v0.SellingPrice
      if c45v2 ~= 0 then
        c45v2 = c45v0.WillExpire
        c45v1 = not c45v2
        if c45v1 then
          c45v2 = c45v0.PreventSelling
          c45v1 = not c45v2
        end
      end
    end
    do return c45v1 end
  end
  v157 = function()
    local c46v0, c46v1, c46v2, c46v3, c46v4, c46v5, c46v6
    c46v1 = v43
    c46v0 = IsNull
    c46v0 = c46v0(c46v1)
    if c46v0 then
      do return end
    end
    c46v2 = v43
    c46v2 = c46v2:GetScroll()
    c46v3 = v124
    c46v3 = c46v3.focusStartTimeScroll
    c46v1 = c46v2 - c46v3
    c46v0 = math.abs
    c46v0 = c46v0(c46v1)
    c46v2 = v124
    c46v2 = c46v2.hidePopupScrollThreshold
    if c46v0 <= c46v2 then
      c46v1 = false
    else
      c46v1 = true
    end
    c46v2 = v124
    c46v2 = c46v2.popupState
    c46v3 = v123
    c46v3 = c46v3.HIDE_DURING_LONG_PRESS
    if c46v2 == c46v3 then
      c46v2 = v124
      c46v2 = c46v2.mouseDown
      if (not c46v2 or c46v1) then
        c46v2 = v124
        c46v3 = v123
        c46v3 = c46v3.DEFAULT
        c46v2.popupState = c46v3
        do return end
      end
      c46v2 = Vector
      c46v3 = mMovie
      c46v3 = c46v3:GetCursorX()
      c46v4 = mMovie
      c46v4 = c46v4:GetCursorY()
      c46v5 = 0
      c46v2 = c46v2(c46v3, c46v4, c46v5)
      c46v3 = CalculateDistance3DVector
      c46v5 = v124
      c46v5 = c46v5.mousePos
      c46v3 = c46v3(c46v2, c46v5)
      c46v4 = v124
      c46v4 = c46v4.dragThreshold
      if c46v4 < c46v3 then
        c46v4 = v124
        c46v5 = v123
        c46v5 = c46v5.DEFAULT
        c46v4.popupState = c46v5
        do return end
      end
      c46v5 = RealTime
      c46v5 = c46v5()
      c46v6 = v124
      c46v6 = c46v6.focusStartTime
      c46v4 = c46v5 - c46v6
      c46v5 = 0.5
      if c46v5 < c46v4 then
        c46v4 = v43
        c46v4 = c46v4:GetFocusedElement()
        c46v5 = IsNull
        c46v5 = c46v5(c46v4)
        if not c46v5 then
          c46v5 = v124
          c46v6 = v123
          c46v6 = c46v6.SHOW_UNTIL_SCROLL_OR_TAP
          c46v5.popupState = c46v6
          c46v5 = v144
          c46v5(c46v4)
          do return end
        end
        c46v5 = v124
        c46v6 = v123
        c46v6 = c46v6.DEFAULT
        c46v5.popupState = c46v6
      end
    else
      c46v2 = v124
      c46v2 = c46v2.popupState
      c46v3 = v123
      c46v3 = c46v3.SHOW_UNTIL_SCROLL_OR_TAP
      if (c46v2 == c46v3 and c46v1) then
        c46v2 = v43
        c46v2 = c46v2:GetFocusedElement()
        c46v3 = IsNull
        c46v3 = c46v3(c46v2)
        if not c46v3 then
          c46v3 = v43
          c46v5 = c46v2.Id
          c46v3:UnfocusElementById(c46v5)
        end
      end
    end
    do return end
  end
  v158 = function()
    local c54v0, c54v1, c54v2, c54v3, c54v4, c54v5, c54v6, c54v7, c54v8
    c54v0 = v129
    c54v0 = c54v0()
    c54v0 = require
    c54v1 = "EE.Interface.Components.List"
    c54v0 = c54v0(c54v1)
    c54v1 = c54v0.CreateList
    local __renovice_local_0 = mMovie
    c54v2 = "SellList.List.Item"
    c54v1 = c54v1(__renovice_local_0, c54v2)
    v45 = c54v1
    c54v1 = v45
    __renovice_local_0 = 32
    c54v1.mForcedVerticalSeparation = __renovice_local_0
    c54v1 = v45
    c54v4 = v66
    c54v3 = c54v4 + 10
    c54v4 = v45
    c54v4 = c54v4.mForcedVerticalSeparation
    c54v2 = c54v3 / c54v4
    __renovice_local_0 = math.floor
    __renovice_local_0 = __renovice_local_0(c54v2)
    c54v1.mVisibleElements = __renovice_local_0
    c54v1 = v45
    c54v2 = "SellList.ScrollBar"
    c54v3 = 0
    c54v1:AttachScrollBar(c54v2, c54v3)
    c54v1 = v45
    __renovice_local_0 = 1
    c54v1.mScroll = __renovice_local_0
    c54v1 = v45
    c54v1:EnableSmoothScroll()
    c54v1 = Engine.IsPlayingWithTouchscreen
    c54v1 = c54v1()
    if c54v1 then
      c54v1 = v45
      c54v1:EnableDragScrolling()
    end
    c54v1 = v45
    __renovice_local_0 = mMovie
    c54v4 = v45
    c54v4 = c54v4.mClipName
    c54v5 = ".Bg"
    c54v3 = c54v4 .. c54v5
    c54v4 = 14
    __renovice_local_0 = __renovice_local_0:GetNumberVariable(c54v3, c54v4)
    c54v1.mInitBgWidth = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = mMovie
    c54v4 = v45
    c54v4 = c54v4.mClipName
    c54v5 = ".Bg"
    c54v3 = c54v4 .. c54v5
    c54v4 = 15
    __renovice_local_0 = __renovice_local_0:GetNumberVariable(c54v3, c54v4)
    c54v1.mInitBgHeight = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = function(c47v0, c47v1, c47v2)
      local c47v3, c47v4, c47v5, c47v6, c47v7, c47v8, c47v9, c47v10, c47v11, c47v12
      c47v3 = v25
      c47v3 = c47v3.GetColor
      c47v4 = 6
      c47v5 = true
      c47v3 = c47v3(c47v4, c47v5)
      c47v4 = v25
      c47v4 = c47v4.GetColor
      c47v5 = 7
      c47v6 = true
      c47v4 = c47v4(c47v5, c47v6)
      c47v5 = v25
      c47v5 = c47v5.GetColor
      c47v6 = 9
      c47v7 = true
      c47v5 = c47v5(c47v6, c47v7)
      c47v6 = v25
      c47v6 = c47v6.GetColor
      c47v7 = 10
      c47v8 = true
      c47v6 = c47v6(c47v7, c47v8)
      c47v7 = mMovie
      c47v9 = c47v1.mClipName
      c47v10 = "Cross"
      c47v11 = 44
      c47v12 = v24
      c47v12 = c47v12.Ternary
      c47v7:Name__52c1b74e(c47v9, c47v10, c47v11, c47v12(c47v2, c47v4, c47v3))
      c47v7 = mMovie
      c47v9 = c47v1.mClipName
      c47v10 = "Name"
      c47v11 = 44
      c47v12 = v24
      c47v12 = c47v12.Ternary
      c47v7:Name__52c1b74e(c47v9, c47v10, c47v11, c47v12(c47v2, c47v6, c47v3))
      c47v7 = mMovie
      c47v9 = c47v1.mClipName
      c47v10 = "Price"
      c47v11 = 44
      c47v12 = v24
      c47v12 = c47v12.Ternary
      c47v7:Name__52c1b74e(c47v9, c47v10, c47v11, c47v12(c47v2, c47v6, c47v5))
      c47v7 = mMovie
      c47v9 = c47v1.mClipName
      c47v10 = "CrossBg"
      c47v11 = 11
      c47v7:Name__52c1b74e(c47v9, c47v10, c47v11, c47v5)
      c47v7 = mMovie
      c47v9 = c47v1.mClipName
      c47v10 = "Bg"
      c47v11 = 11
      c47v7:Name__52c1b74e(c47v9, c47v10, c47v11, c47v5)
      c47v7 = c47v1.mButton
      c47v7.mUnfocusedColor = c47v3
      c47v7 = c47v1.mButton
      c47v7:UpdateColors()
      do return end
    end
    c54v1.UpdateColors = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = function(c48v0)
      local c48v1, c48v2, c48v3, c48v4, c48v5, c48v6, c48v7, c48v8, c48v9
      c48v1 = c48v0.mClipName
      if c48v1 == nil then
        do return end
      end
      c48v1 = v98
      c48v1 = c48v1.SELL
      v99 = c48v1
      c48v1 = mMovie
      c48v3 = c48v0.mClipName
      c48v4 = "Cross"
      c48v5 = 13
      c48v6 = true
      c48v1:Makeposshield(c48v3, c48v4, c48v5, c48v6)
      c48v1 = mMovie
      c48v3 = c48v0.mClipName
      c48v4 = "CrossBg"
      c48v5 = 13
      c48v6 = true
      c48v1:Makeposshield(c48v3, c48v4, c48v5, c48v6)
      c48v1 = mMovie
      c48v3 = c48v0.mClipName
      c48v4 = "Bg"
      c48v5 = 13
      c48v6 = true
      c48v1:Makeposshield(c48v3, c48v4, c48v5, c48v6)
      c48v1 = v45
      c48v4 = true
      c48v1:UpdateColors(c48v0, c48v4)
      c48v1 = v26
      c48v1 = c48v1.SetItemInfoPopupRect
      c48v2 = mMovie
      c48v5 = mMovie
      c48v7 = c48v0.mClipName
      c48v8 = 2
      c48v5 = c48v5:GetNumberVariable(c48v7, c48v8)
      c48v7 = c48v0.mButton
      c48v7 = c48v7.mWidth
      c48v6 = c48v7 / 2
      c48v4 = c48v5 + c48v6
      c48v6 = mMovie
      c48v8 = c48v0.mClipName
      c48v9 = 3
      c48v6 = c48v6:GetNumberVariable(c48v8, c48v9)
      c48v8 = c48v0.mButton
      c48v8 = c48v8.mHeight
      c48v7 = c48v8 / 2
      c48v5 = c48v6 + c48v7
      c48v6 = c48v0.mButton
      c48v6 = c48v6.mWidth
      c48v7 = c48v0.mButton
      c48v7 = c48v7.mHeight
      c48v1(c48v2, c48v0, c48v4, c48v5, c48v6, c48v7)
      _T.InfoPopup_Data = c48v0
      c48v1 = _T
      c48v2 = v45
      c48v1.InfoPopup_Grid = c48v2
      do return end
    end
    c54v1.mOnFocusedCallback = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = function(c49v0)
      local c49v1, c49v2, c49v3, c49v4, c49v5, c49v6
      c49v1 = c49v0.mClipName
      if c49v1 == nil then
        do return end
      end
      c49v1 = v98
      c49v1 = c49v1.INVENTORY
      v99 = c49v1
      c49v1 = mMovie
      c49v3 = c49v0.mClipName
      c49v4 = "Cross"
      c49v5 = 13
      c49v6 = false
      c49v1:Makeposshield(c49v3, c49v4, c49v5, c49v6)
      c49v1 = mMovie
      c49v3 = c49v0.mClipName
      c49v4 = "CrossBg"
      c49v5 = 13
      c49v6 = false
      c49v1:Makeposshield(c49v3, c49v4, c49v5, c49v6)
      c49v1 = mMovie
      c49v3 = c49v0.mClipName
      c49v4 = "Bg"
      c49v5 = 13
      c49v6 = false
      c49v1:Makeposshield(c49v3, c49v4, c49v5, c49v6)
      c49v1 = v45
      c49v4 = false
      c49v1:UpdateColors(c49v0, c49v4)
      c49v1 = _T
      c49v2 = nil
      c49v1.InfoPopup_Data = c49v2
      do return end
    end
    c54v1.mOnUnfocusedCallback = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = function(c53v0)
      local c53v1, c53v2, c53v3, c53v4, c53v5, c53v6, c53v7, c53v8, c53v9, c53v10, c53v11, c53v12
      c53v1 = c53v0.mClipName
      if c53v1 == nil then
        do return end
      end
      c53v1 = v45
      c53v1 = c53v1:GetFocusedElement()
      c53v2 = false
      if c53v1 ~= nil then
        c53v3 = c53v1.Id
        c53v4 = c53v0.Id
        if c53v3 ~= c53v4 then
          c53v2 = false
        else
          c53v2 = true
        end
      end
      c53v3 = mMovie
      c53v5 = c53v0.mClipName
      c53v6 = "Cross"
      c53v7 = 36
      c53v8 = "X"
      c53v3:Name__f4a9016a(c53v5, c53v6, c53v7, c53v8)
      c53v3 = ""
      c53v4 = c53v0.SellingPrice
      if c53v4 ~= nil then
        c53v4 = v95
        c53v5 = v94
        c53v5 = c53v5.ENEMIES
        if c53v4 ~= c53v5 then
          c53v4 = v95
          c53v5 = v94
          c53v5 = c53v5.DECODONATE
          if c53v4 ~= c53v5 then
            c53v4 = v95
            c53v5 = v94
            c53v5 = c53v5.RESDONATE
            if c53v4 ~= c53v5 then
              c53v4 = v95
              c53v5 = v94
              c53v5 = c53v5.SHIP_PARTS
              if c53v4 ~= c53v5 then
                c53v4 = v129
                c53v4 = c53v4()
                if not c53v4 then
                  c53v4 = v24
                  c53v4 = c53v4.FormatNumber
                  c53v6 = c53v0.SellingPrice
                  c53v8 = 1
                  c53v9 = c53v0.Count
                  c53v7 = math.max
                  c53v7 = c53v7(c53v8, c53v9)
                  c53v5 = c53v6 * c53v7
                  c53v3 = c53v4(c53v5)
                end
              end
            end
          end
        end
      end
      c53v4 = mMovie
      c53v6 = c53v0.mClipName
      c53v7 = "Price"
      c53v8 = 36
      c53v4:Name__f4a9016a(c53v6, c53v7, c53v8, c53v3)
      c53v4 = mMovie
      c53v7 = c53v0.mClipName
      c53v8 = ".Price"
      c53v6 = c53v7 .. c53v8
      c53v7 = sellListTextVisibleRangeMaterial
      c53v4:OverrideMaterial(c53v6, c53v7)
      c53v4 = mMovie
      c53v7 = c53v0.mClipName
      c53v8 = ".Price"
      c53v6 = c53v7 .. c53v8
      c53v7 = 40
      c53v4 = c53v4:GetNumberVariable(c53v6, c53v7)
      c53v5 = mMovie
      c53v7 = c53v0.mClipName
      c53v8 = "Name"
      c53v9 = 14
      c53v11 = c53v4 + 10
      c53v10 = 345 - c53v11
      c53v5:Name__52c1b74e(c53v7, c53v8, c53v9, c53v10)
      c53v5 = c53v0.Name
      c53v6 = c53v0.Count
      c53v7 = 1
      if c53v7 < c53v6 then
        c53v9 = v24
        c53v9 = c53v9.FormatNumber
        c53v10 = c53v0.Count
        c53v6 = c53v9(c53v10)
        c53v7 = " x "
        c53v5 = c53v6 .. c53v7 .. c53v5
      end
      c53v6 = v26
      c53v6 = c53v6.GetArcaneRankString
      c53v8 = c53v0.ArcaneRank
      c53v9 = c53v0.ArcaneMaxRank
      c53v10 = mMovie
      c53v5 = c53v6(c53v5, c53v8, c53v9, c53v10)
      c53v6 = v31
      c53v6 = c53v6.Create
      c53v7 = mMovie
      c53v9 = c53v0.mClipName
      c53v10 = ".ListBtn"
      c53v8 = c53v9 .. c53v10
      c53v10 = "SellListItemPressed"
      c53v6 = c53v6(c53v7, c53v8, c53v5, c53v10)
      c53v7 = mMovie
      c53v9 = c53v0.mClipName
      c53v10 = "ListBtn.Label"
      c53v11 = 54
      c53v12 = true
      c53v7:Makeposshield(c53v9, c53v10, c53v11, c53v12)
      c53v9 = sellListVisibleRangeMaterial
      c53v10 = sellListTextVisibleRangeMaterial
      c53v11 = sellListRectangleVisibleRangeMaterial
      c53v6:SetVisibleRangeMaterials(c53v9, c53v10, c53v11)
      c53v9 = "left"
      c53v6:SetTextAlignment(c53v9)
      c53v9 = 308
      c53v6:SetWidth(c53v9)
      c53v7 = false
      c53v6.mToUpper = c53v7
      c53v7 = true
      c53v6.mTitleCase = c53v7
      c53v7 = 350
      c53v6.mMinSize = c53v7
      c53v7 = 350
      c53v6.mMaxSize = c53v7
      c53v7 = 0
      c53v6.mInnerAlpha = c53v7
      c53v7 = 4
      c53v6.mTextBuffer = c53v7
      c53v7 = 0
      c53v6.mUnderlineAlpha = c53v7
      c53v7 = "<p><font face=\"Roboto Condensed\">"
      c53v6.mFormatPrefix = c53v7
      c53v7 = "</font></p>"
      c53v6.mFormatSuffix = c53v7
      c53v7 = function()
        local c50v0, c50v1
        c50v0 = v45
        c50v1 = c53v0
        c50v1 = c50v1.Id
        c50v0:FocusElementById(c50v1)
        do return end
      end
      c53v6.mOnFocusedCallback = c53v7
      c53v7 = function()
        local c51v0, c51v1
        c51v0 = v45
        c51v1 = c53v0
        c51v1 = c51v1.Id
        c51v0:UnfocusElementById(c51v1)
        do return end
      end
      c53v6.mOnUnfocusedCallback = c53v7
      c53v7 = function()
        local c52v0, c52v1
        c52v0 = v45
        c52v1 = c53v0
        c52v1 = c52v1.Id
        c52v0:SelectElementById(c52v1)
        do return end
      end
      c53v6.mOnPressedCallback = c53v7
      c53v6:Redraw()
      c53v0.mButton = c53v6
      c53v7 = mMovie
      c53v9 = c53v0.mClipName
      c53v10 = "Cross"
      c53v11 = 13
      c53v7:Makeposshield(c53v9, c53v10, c53v11, c53v2)
      c53v7 = mMovie
      c53v9 = c53v0.mClipName
      c53v10 = "CrossBg"
      c53v11 = 13
      c53v7:Makeposshield(c53v9, c53v10, c53v11, c53v2)
      c53v7 = mMovie
      c53v9 = c53v0.mClipName
      c53v10 = "Bg"
      c53v11 = 13
      c53v7:Makeposshield(c53v9, c53v10, c53v11, c53v2)
      c53v7 = mMovie
      c53v9 = c53v0.mClipName
      c53v10 = "CrossBg"
      c53v11 = 12
      c53v12 = 80
      c53v7:Name__52c1b74e(c53v9, c53v10, c53v11, c53v12)
      c53v7 = mMovie
      c53v9 = c53v0.mClipName
      c53v10 = "Bg"
      c53v11 = 12
      c53v12 = 80
      c53v7:Name__52c1b74e(c53v9, c53v10, c53v11, c53v12)
      c53v7 = v45
      c53v7:UpdateColors(c53v0, c53v2)
      do return end
    end
    c54v1.mElementDrawCallback = __renovice_local_0
    c54v1 = mMovie
    c54v2 = "SellList.ListMask"
    c54v3 = 15
    c54v5 = v45
    c54v5 = c54v5.mVisibleElements
    c54v6 = v45
    c54v6 = c54v6.mForcedVerticalSeparation
    c54v4 = c54v5 * c54v6
    c54v1:SetNumberVariable(c54v2, c54v3, c54v4)
    c54v0 = require
    c54v1 = "Lotus.Interface.Components.CategorizedGrid"
    c54v0 = c54v0(c54v1)
    c54v1 = c54v0.CreateCategorizedGrid
    __renovice_local_0 = mMovie
    c54v2 = "SellList.GridItem"
    c54v3 = 2
    c54v4 = 3
    c54v1 = c54v1(__renovice_local_0, c54v2, c54v3, c54v4)
    v45 = c54v1
    c54v1 = v45
    c54v2 = "SellListItemPressed"
    c54v3 = "SellListItemFocused"
    c54v4 = "SellListItemUnfocused"
    c54v1:SetCallbacks(c54v2, c54v3, c54v4)
    c54v1 = v45
    __renovice_local_0 = 100
    c54v1.mSelectedScale = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = 142
    c54v1.ElementWidth = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = 142
    c54v1.ElementHeight = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = 350
    c54v1.Width = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = 600
    c54v1.Height = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = 25
    c54v1.ElementDimBuffer = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = 24
    c54v1.mHighlightAlphaFocusedOverride = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = true
    c54v1.SkipReinitializePos = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = true
    c54v1.mAddFillerElements = __renovice_local_0
    c54v1 = v26
    c54v1 = c54v1.InitializeGridItem
    __renovice_local_0 = mMovie
    c54v2 = v45
    c54v1(__renovice_local_0, c54v2)
    c54v1 = v45
    __renovice_local_0 = v144
    c54v1.mOnFocusedCallback = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = v145
    c54v1.mOnUnfocusedCallback = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = v151
    c54v1.mElementDrawCallback = __renovice_local_0
    c54v1 = v45
    __renovice_local_0 = v150
    c54v1.mClipCreatedCallback = __renovice_local_0
    c54v1 = _T.InvTradingInfo.Plat
    if c54v1 ~= nil then
      c54v1 = v45
      c54v2 = { SellGrid = true, IconHeight = 80, IconWidth = 80, Plat = true, Count = nil, Name = nil, Icon = nil }
      c54v3 = _T.InvTradingInfo.Plat
      c54v2.Count = c54v3
      c54v3 = mMovie
      c54v5 = "/Lotus/Language/Dojo/TradeTypePlatinum"
      c54v6 = true
      c54v3 = c54v3:GetLocalized(c54v5, c54v6)
      c54v2.Name = c54v3
      c54v3 = _G
      c54v3 = c54v3.UITexture_PlatinumIcon
      c54v2.Icon = c54v3
      c54v3 = true
      c54v1:AddElement(c54v2, c54v3)
    end
    c54v1 = pairs
    __renovice_local_0 = _T.InvTradingInfo.Mods
    c54v1, __renovice_local_0, c54v2 = c54v1(__renovice_local_0)
    for __renovice_for_0_0, __renovice_for_0_1 in c54v1, __renovice_local_0, c54v2 do
      c54v5 = v45
      c54v7 = { SellGrid = true, Card = nil }
      c54v7.Card = __renovice_for_0_1
      c54v8 = true
      c54v5:AddElement(c54v7, c54v8)
    end
    c54v1 = pairs
    __renovice_local_0 = _T.InvTradingInfo.Others
    c54v1, __renovice_local_0, c54v2 = c54v1(__renovice_local_0)
    for __renovice_for_1_0, __renovice_for_1_1 in c54v1, __renovice_local_0, c54v2 do
      c54v5 = true
      __renovice_for_1_1.SellGrid = c54v5
      c54v5 = true
      __renovice_for_1_1.IsOther = c54v5
      c54v5 = v45
      c54v8 = true
      c54v5:AddElement(__renovice_for_1_1, c54v8)
    end
    c54v1 = v45
    c54v2 = nil
    c54v3 = true
    c54v4 = true
    c54v1:Redraw(c54v2, c54v3, c54v4)
    c54v1 = v134
    c54v1()
    c54v1 = mMovie
    c54v2 = "SellList.ScrollBar"
    c54v3 = 13
    c54v4 = false
    c54v1:Name__d9713943(c54v2, c54v3, c54v4)
    for __renovice_for_2_0, __renovice_for_2_1 in c54v1, __renovice_local_0, c54v2 do
    end
    c54v0 = v45
    c54v1 = v148
    c54v0.mOnSelectedCallback = c54v1
    c54v0 = "SellWithManifest"
    c54v1 = "/Lotus/Language/Menu/ItemInventory_SellItems"
    __renovice_local_0 = v95
    c54v2 = v94
    c54v2 = c54v2.FISH
    if __renovice_local_0 == c54v2 then
      c54v0 = "FishFunction"
      c54v1 = _T.FishInvInfo.SellBtnLabel
    else
      local __renovice_state_0 = 15
      __renovice_local_0 = v95
      c54v2 = v94
      c54v2 = c54v2.ENEMIES
      if __renovice_local_0 ~= c54v2 then
        __renovice_state_0 = 17
      else
        __renovice_state_0 = 16
      end
      if __renovice_state_0 == 16 then
        c54v0 = "LoadEnemies"
        c54v1 = "/Lotus/Language/Menu/EnemySelector_SpawnEnemies"
      end
      if __renovice_state_0 == 17 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.TREASURE
        if __renovice_local_0 ~= c54v2 then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 18
        end
      end
      if __renovice_state_0 == 18 then
        c54v1 = "/Lotus/Language/Menu/ItemInventory_ExtractEndo"
      end
      if __renovice_state_0 == 19 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.SHIP_SCRAP
        if __renovice_local_0 == c54v2 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 20
        end
      end
      if __renovice_state_0 == 20 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.SHIP_PARTS
        if __renovice_local_0 == c54v2 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 21
        end
      end
      if __renovice_state_0 == 21 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.SHIP_RAW
        if __renovice_local_0 ~= c54v2 then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 22
        end
      end
      if __renovice_state_0 == 22 then
        c54v1 = "/Lotus/Language/Menu/ItemSelection_SellSalvage"
      end
      if __renovice_state_0 == 23 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.SHARDS
        if __renovice_local_0 ~= c54v2 then
          __renovice_state_0 = 25
        else
          __renovice_state_0 = 24
        end
      end
      if __renovice_state_0 == 24 then
        c54v0 = "ConvertShards"
        c54v1 = "/Lotus/Language/TennoWay/ConvertShardsSellBtn"
      end
      if __renovice_state_0 == 25 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.DECODONATE
        if __renovice_local_0 ~= c54v2 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 26
        end
      end
      if __renovice_state_0 == 26 then
        c54v0 = "DonateDecorations"
        c54v1 = "/Lotus/Language/OstronCrafting/Crafting_Donate"
      end
      if __renovice_state_0 == 27 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.RESDONATE
        if __renovice_local_0 ~= c54v2 then
          __renovice_state_0 = 29
        else
          __renovice_state_0 = 28
        end
      end
      if __renovice_state_0 == 28 then
        c54v0 = "DonateDecorations"
        c54v1 = "/Lotus/Language/OstronCrafting/Crafting_Donate"
      end
      if __renovice_state_0 == 29 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.SYNDDONATE
        if __renovice_local_0 ~= c54v2 then
          __renovice_state_0 = 31
        else
          __renovice_state_0 = 30
        end
      end
      if __renovice_state_0 == 30 then
        c54v0 = "DonateDogTags"
        c54v1 = "/Lotus/Language/Syndicates/Favors_RedeemReward"
      end
      if __renovice_state_0 == 31 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.ARCANE
        if __renovice_local_0 ~= c54v2 then
          __renovice_state_0 = 33
        else
          __renovice_state_0 = 32
        end
      end
      if __renovice_state_0 == 32 then
        c54v1 = "/Lotus/Language/Labels/DistillArcane"
      end
      if __renovice_state_0 == 33 then
        __renovice_local_0 = v129
        __renovice_local_0 = __renovice_local_0()
        if not __renovice_local_0 then
          __renovice_state_0 = 35
        else
          __renovice_state_0 = 34
        end
      end
      if __renovice_state_0 == 34 then
        c54v0 = "TradeItems"
        c54v1 = "/Lotus/Language/Dojo/Trade_Offer"
      end
      if __renovice_state_0 == 35 then
        __renovice_local_0 = v95
        c54v2 = v94
        c54v2 = c54v2.MODS_SKIP_LIST
        if __renovice_local_0 ~= c54v2 then
        else
          __renovice_state_0 = 36
        end
      end
      if __renovice_state_0 == 36 then
        c54v0 = "ModsSkipListSelected"
        c54v1 = "/Lotus/Language/Menu/CodexSelect"
      end
    end
    __renovice_local_0 = v31
    __renovice_local_0 = __renovice_local_0.Create
    c54v2 = mMovie
    c54v3 = "SellList.SellBtn"
    __renovice_local_0 = __renovice_local_0(c54v2, c54v3, c54v1, c54v0)
    v44 = __renovice_local_0
    __renovice_local_0 = v44
    __renovice_local_0:SetSpecialMode()
    __renovice_local_0 = v44
    c54v3 = 280
    __renovice_local_0:SetWidth(c54v3)
    __renovice_local_0 = v44
    c54v3 = false
    __renovice_local_0:SetActive(c54v3)
    __renovice_local_0 = v44
    __renovice_local_0:Redraw()
    do return end
  end
  v159 = function(c55v0)
    local c55v1, c55v2, c55v3
    c55v1 = v83
    c55v2 = c55v0.mItemId
    c55v2 = c55v2.mId
    c55v3 = true
    c55v1[c55v2] = c55v3
    do return end
  end
  v160 = function()
    local c56v0, c56v1, c56v2, c56v3, c56v4, c56v5, c56v6, c56v7, c56v8, c56v9
    c56v0 = {}
    v83 = c56v0
    c56v1 = gGameData
    c56v0 = IsNull
    c56v0 = c56v0(c56v1)
    if c56v0 then
      do return end
    end
    c56v0 = nil
    c56v1 = gGameData
    c56v1 = c56v1:GetInventory()
    c56v2 = c56v1:Name__3c1ac8a6()
    c56v2 = c56v2.mId
    c56v3 = c56v1:GetCrewShips()
    c56v4 = ipairs
    c56v4, c56v5, c56v6 = c56v4(c56v3)
    for __renovice_for_0_0, __renovice_for_0_1 in c56v4, c56v5, c56v6 do
      c56v9 = __renovice_for_0_1.mItemId
      c56v9 = c56v9.mId
      if c56v9 ~= c56v2 then
        continue
      end
      c56v0 = __renovice_for_0_1
      break
    end
    if c56v0 == nil then
      c56v4 = #c56v3
      c56v5 = 0
      if c56v5 < c56v4 then
        c56v0 = c56v3[1]
      end
    end
    c56v4 = IsNull
    c56v4 = c56v4(c56v0)
    if not c56v4 then
      c56v4 = v159
      c56v7 = 0
      c56v8 = 0
      c56v4(c56v0:GetWeapon(c56v7, c56v8))
      c56v4 = v159
      c56v7 = 0
      c56v8 = 2
      c56v4(c56v0:GetWeapon(c56v7, c56v8))
      c56v4 = v159
      c56v7 = 1
      c56v8 = 0
      c56v4(c56v0:GetWeapon(c56v7, c56v8))
      c56v4 = c56v0:GetCustomization()
      c56v5 = v159
      c56v8 = 7
      c56v5(c56v4:GetWeaponSkinInfo(c56v8))
      c56v5 = v159
      c56v8 = 8
      c56v5(c56v4:GetWeaponSkinInfo(c56v8))
      c56v5 = v159
      c56v8 = 10
      c56v5(c56v4:GetWeaponSkinInfo(c56v8))
      c56v5 = v159
      c56v8 = 9
      c56v5(c56v4:GetWeaponSkinInfo(c56v8))
    end
    do return end
  end
  v161 = function()
    local c77v0, c77v1, c77v2, c77v3, c77v4, c77v5, c77v6, c77v7, c77v8, c77v9
    local __renovice_state_0 = 0
    c77v0 = v160
    c77v0()
    c77v0 = mMovie
    c77v1 = "InventoryGrid"
    local __renovice_state_1 = 0
    local __renovice_local_0 = mMovie
    c77v3 = "Categories"
    c77v4 = 0
    __renovice_local_0 = __renovice_local_0:GetNumberVariable(c77v3, c77v4)
    c77v2 = mMovie
    c77v4 = "Categories.Menu"
    c77v5 = 0
    c77v2 = c77v2:GetNumberVariable(c77v4, c77v5)
    local __renovice_local_1 = __renovice_local_0 + c77v2
    c77v0:SetNumberVariable(c77v1, __renovice_state_1, __renovice_local_1)
    c77v0 = require
    local __renovice_local_2 = "Lotus.Interface.Components.CategorizedGrid"
    c77v0 = c77v0(__renovice_local_2)
    __renovice_local_2 = c77v0.CreateCategorizedGrid
    c77v1 = mMovie
    __renovice_state_1 = "InventoryGrid.InventoryItem"
    __renovice_local_1 = 6
    __renovice_local_0 = 4
    c77v2 = "Categories.Menu"
    c77v3 = "SearchAndSort.SortMenu"
    __renovice_local_2 = __renovice_local_2(c77v1, __renovice_state_1, __renovice_local_1, __renovice_local_0, c77v2, c77v3)
    v43 = __renovice_local_2
    __renovice_local_2 = v43
    __renovice_state_1 = "GridItemSelected"
    __renovice_local_1 = "GridItemFocused"
    __renovice_local_0 = "GridItemUnfocused"
    c77v2 = "GridItemPressed"
    __renovice_local_2:SetCallbacks(__renovice_state_1, __renovice_local_1, __renovice_local_0, c77v2)
    __renovice_local_2 = v43
    c77v1 = 100
    __renovice_local_2.mSelectedScale = c77v1
    __renovice_local_2 = v43
    c77v1 = 160
    __renovice_local_2.mColumnSeparation = c77v1
    __renovice_local_2 = v43
    c77v1 = 10
    __renovice_local_2.mRowSeparation = c77v1
    __renovice_local_2 = v43
    c77v1 = 0
    __renovice_local_2.mSmoothScrollExtraSpace = c77v1
    __renovice_local_2 = v43
    c77v1 = true
    __renovice_local_2.mScrollAlwaysVisible = c77v1
    __renovice_local_2 = v43
    __renovice_state_1 = "InventoryGridScrollBar"
    __renovice_local_1 = 1
    __renovice_local_2:AttachScrollBar(__renovice_state_1, __renovice_local_1)
    __renovice_local_2 = v43
    c77v1 = nil
    __renovice_local_2.mScrollBarHorizontalOffset = c77v1
    __renovice_local_2 = v43
    c77v1 = nil
    __renovice_local_2.mSortMenuHorizontalOffset = c77v1
    __renovice_local_2 = v43
    c77v1 = nil
    __renovice_local_2.mSortMenuVerticalOffset = c77v1
    __renovice_local_2 = v43
    __renovice_local_2:EnableSmoothScroll()
    __renovice_local_2 = Engine.IsPlayingWithTouchscreen
    __renovice_local_2 = __renovice_local_2()
    if not __renovice_local_2 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      __renovice_local_2 = v43
      __renovice_local_2:EnableDragScrolling()
      __renovice_local_2 = v43
      c77v1 = false
      __renovice_local_2.mStopDragScrollingOnSelection = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mSortMenu
      c77v1 = 46
      __renovice_local_2.mForcedVerticalSeparation = c77v1
      __renovice_local_2 = mMovie
      __renovice_state_1 = v43
      __renovice_state_1 = __renovice_state_1.mSortMenu
      __renovice_state_1 = __renovice_state_1.mRootClipName
      __renovice_local_1 = "Buttons"
      __renovice_local_0 = 1
      c77v2 = v43
      c77v2 = c77v2.mSortMenu
      c77v2 = c77v2.mForcedVerticalSeparation
      __renovice_local_2:Name__52c1b74e(__renovice_state_1, __renovice_local_1, __renovice_local_0, c77v2)
      __renovice_local_2 = mMovie
      __renovice_state_1 = v43
      __renovice_state_1 = __renovice_state_1.mSortMenu
      __renovice_state_1 = __renovice_state_1.mRootClipName
      __renovice_local_1 = "Backer"
      __renovice_local_0 = 1
      c77v2 = v43
      c77v2 = c77v2.mSortMenu
      c77v2 = c77v2.mForcedVerticalSeparation
      __renovice_local_2:Name__52c1b74e(__renovice_state_1, __renovice_local_1, __renovice_local_0, c77v2)
      __renovice_state_0 = 2
    end
    if __renovice_state_0 == 2 then
      __renovice_local_2 = v43
      c77v1 = false
      __renovice_local_2.mSelectElementsOnFocus = c77v1
      __renovice_local_2 = v43
      c77v1 = 1
      __renovice_local_2.mScroll = c77v1
      __renovice_local_2 = v43
      c77v1 = true
      __renovice_local_2.mSkipRefocusOnScrollRedraw = c77v1
      __renovice_local_2 = v43
      c77v1 = v144
      __renovice_local_2.mOnFocusedCallback = c77v1
      __renovice_local_2 = v43
      c77v1 = v145
      __renovice_local_2.mOnUnfocusedCallback = c77v1
      __renovice_local_2 = v43
      c77v1 = v148
      __renovice_local_2.mOnSelectedCallback = c77v1
      __renovice_local_2 = v43
      c77v1 = v151
      __renovice_local_2.mElementDrawCallback = c77v1
      __renovice_local_2 = v43
      c77v1 = v149
      __renovice_local_2.mClipCreatedCallback = c77v1
      __renovice_local_2 = v43
      c77v1 = rectangleVisibleRangeMat
      __renovice_local_2.RectangleVisibleRangeMaterial = c77v1
      __renovice_local_2 = v43
      c77v1 = visibleRangeMat
      __renovice_local_2.VisibleRangeMaterial = c77v1
      __renovice_local_2 = v43
      c77v1 = textVisibleRangeMat
      __renovice_local_2.TextVisibleRangeMaterial = c77v1
      __renovice_local_2 = v43
      c77v1 = flareVisibleRangeMat
      __renovice_local_2.FlareVisibleRangeMaterial = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mSortMenu
      __renovice_state_1 = 200
      __renovice_local_2:SetWidth(__renovice_state_1)
      __renovice_local_2 = v43
      c77v1 = v101
      __renovice_local_2.ElementWidth = c77v1
      __renovice_local_2 = v43
      c77v1 = v101
      __renovice_local_2.ElementHeight = c77v1
      __renovice_local_2 = v43
      c77v1 = 1000
      __renovice_local_2.Width = c77v1
      __renovice_local_2 = v43
      c77v1 = 650
      __renovice_local_2.Height = c77v1
      __renovice_local_2 = v43
      c77v1 = 10
      __renovice_local_2.ElementDimBuffer = c77v1
      __renovice_local_2 = v43
      c77v1 = 25
      __renovice_local_2.ElementHeightBuffer = c77v1
      __renovice_local_2 = v43
      c77v1 = 24
      __renovice_local_2.mHighlightAlphaFocusedOverride = c77v1
      __renovice_local_2 = v43
      c77v1 = true
      __renovice_local_2.mUseCornerForSelected = c77v1
      __renovice_local_2 = v43
      c77v1 = false
      __renovice_state_1 = v95
      __renovice_local_1 = v94
      __renovice_local_1 = __renovice_local_1.ENEMIES
      if __renovice_state_1 == __renovice_local_1 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c77v1 = false
      __renovice_state_1 = v95
      __renovice_local_1 = v94
      __renovice_local_1 = __renovice_local_1.SHIP_SCRAP
      if __renovice_state_1 == __renovice_local_1 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c77v1 = false
      __renovice_state_1 = v95
      __renovice_local_1 = v94
      __renovice_local_1 = __renovice_local_1.SHIP_PARTS
      if __renovice_state_1 == __renovice_local_1 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      __renovice_state_1 = v95
      __renovice_local_1 = v94
      __renovice_local_1 = __renovice_local_1.SHIP_RAW
      if __renovice_state_1 ~= __renovice_local_1 then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      c77v1 = false
      __renovice_state_0 = 8
    end
    if __renovice_state_0 == 7 then
      c77v1 = true
      __renovice_state_0 = 8
    end
    if __renovice_state_0 == 8 then
      __renovice_local_2.CanPreviewElements = c77v1
      __renovice_local_2 = v95
      c77v1 = v94
      c77v1 = c77v1.SHIP_SCRAP
      if __renovice_local_2 == c77v1 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      __renovice_local_2 = v95
      c77v1 = v94
      c77v1 = c77v1.SHIP_PARTS
      if __renovice_local_2 == c77v1 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      __renovice_local_2 = v95
      c77v1 = v94
      c77v1 = c77v1.SHIP_RAW
      if __renovice_local_2 ~= c77v1 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      __renovice_local_2 = v43
      c77v1 = true
      __renovice_local_2.mShowLabels = c77v1
      __renovice_state_0 = 12
    end
    if __renovice_state_0 == 12 then
      __renovice_local_2 = v26
      __renovice_local_2 = __renovice_local_2.InitializeGridItem
      c77v1 = mMovie
      __renovice_state_1 = v43
      __renovice_local_2(c77v1, __renovice_state_1)
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      if __renovice_local_2 == nil then
        __renovice_state_0 = 14
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      c77v1 = v24
      c77v1 = c77v1.LEFT_ALIGNED
      __renovice_local_2.mAlign = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      c77v1 = true
      __renovice_local_2.mHideEmptyCategories = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      c77v1 = true
      __renovice_local_2.mTryFitToGridWidth = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      c77v1 = 21
      __renovice_local_2.mFitGridWidthPadding = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      c77v1 = 420
      __renovice_local_2.mFitGridWidthReduction = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      c77v1 = v43
      c77v1 = c77v1.mCategoryMenu
      c77v1 = c77v1.mOnSelectedCallback
      __renovice_local_2._InvCatMenu_OnSelectedCallback = c77v1
      __renovice_local_2 = v43
      __renovice_local_2 = __renovice_local_2.mCategoryMenu
      c77v1 = function(c57v0, c57v1)
        local c57v2
        if c57v1 then
          c57v2 = c57v0.Category
          v90 = c57v2
        end
        c57v2 = v43
        c57v2 = c57v2.mCategoryMenu
        c57v2 = c57v2._InvCatMenu_OnSelectedCallback
        c57v2(c57v0, c57v1)
        do return end
      end
      __renovice_local_2.mOnSelectedCallback = c77v1
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 14 then
      __renovice_local_2 = v43
      c77v1 = mMovie
      __renovice_local_1 = "Categories"
      __renovice_local_0 = 1
      c77v1 = c77v1:GetNumberVariable(__renovice_local_1, __renovice_local_0)
      __renovice_local_2.mInitCategoriesYPos = c77v1
      __renovice_local_2 = v43
      c77v1 = mMovie
      __renovice_local_1 = "SearchAndSort"
      __renovice_local_0 = 1
      c77v1 = c77v1:GetNumberVariable(__renovice_local_1, __renovice_local_0)
      __renovice_local_2.mInitSearchSortYPos = c77v1
      __renovice_local_2 = v43
      c77v1 = v43
      c77v1 = c77v1.Redraw
      __renovice_local_2._InventoryGrid_Redraw = c77v1
      __renovice_local_2 = v43
      c77v1 = function(c58v0, c58v1, c58v2, c58v3, c58v4, c58v5)
        local c58v6, c58v7, c58v8, c58v9, c58v10, c58v11, c58v12
        c58v0:_InventoryGrid_Redraw(c58v1, c58v2, c58v3, c58v4, c58v5)
        c58v7 = c58v0.mInitCategoriesYPos
        c58v8 = v24
        c58v8 = c58v8.Ternary
        c58v9 = c58v0.mCategoryMenu
        c58v9 = c58v9.mIsFitToGridWidth
        c58v10 = 5
        c58v11 = 0
        c58v8 = c58v8(c58v9, c58v10, c58v11)
        c58v6 = c58v7 + c58v8
        c58v8 = c58v0.mInitSearchSortYPos
        c58v9 = v24
        c58v9 = c58v9.Ternary
        c58v10 = c58v0.mCategoryMenu
        c58v10 = c58v10.mIsFitToGridWidth
        c58v11 = -30
        c58v12 = 0
        c58v9 = c58v9(c58v10, c58v11, c58v12)
        c58v7 = c58v8 + c58v9
        c58v9 = v38
        c58v8 = IsNull
        c58v8 = c58v8(c58v9)
        if not c58v8 then
          c58v8 = v38
          c58v10 = "Categories"
          c58v11 = nil
          c58v8:ChangeOriginalCoords(c58v10, c58v11, c58v6)
          c58v8 = v38
          c58v10 = "SearchAndSort"
          c58v11 = nil
          c58v8:ChangeOriginalCoords(c58v10, c58v11, c58v7)
          c58v8 = v38
          c58v10 = mMovie
          c58v10 = c58v10:GetViewportWidth()
          c58v11 = mMovie
          c58v8:Update(c58v10, c58v11:GetViewportHeight())
          do return end
        end
        c58v8 = mMovie
        c58v10 = "Categories"
        c58v11 = 1
        c58v8:SetNumberVariable(c58v10, c58v11, c58v6)
        c58v8 = mMovie
        c58v10 = "SearchAndSort"
        c58v11 = 1
        c58v8:SetNumberVariable(c58v10, c58v11, c58v7)
        do return end
      end
      __renovice_local_2.Redraw = c77v1
      __renovice_local_2 = v43
      c77v1 = function(c62v0)
        local c62v1, c62v2, c62v3, c62v4, c62v5
        c62v1 = c62v0:GetFocusedElement()
        local __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c62v1)
        if not __renovice_local_0 then
          c62v2 = mMovie
          __renovice_local_0 = IsNull
          __renovice_local_0 = __renovice_local_0(c62v2)
          if not __renovice_local_0 then
            __renovice_local_0 = c62v1.SortCategory
            c62v2 = 26
            if __renovice_local_0 == c62v2 then
              c62v2 = c62v1.RawItem
              __renovice_local_0 = IsNull
              __renovice_local_0 = __renovice_local_0(c62v2)
              if __renovice_local_0 then
                do return end
              end
              __renovice_local_0 = mMovie
              c62v3 = kubrowPreviewMovie
              __renovice_local_0 = __renovice_local_0:PushChildMovie(c62v3)
              v54 = __renovice_local_0
              __renovice_local_0 = v54
              c62v3 = "SetTitle"
              c62v4 = ""
              __renovice_local_0:Execute(c62v3, c62v4)
              __renovice_local_0 = _T
              c62v2 = function()
                local c59v0, c59v1, c59v2, c59v3
                c59v0 = _T
                c59v1 = nil
                c59v0.OnPreviewClose = c59v1
                c59v0 = _T
                c59v1 = nil
                c59v0.GetAllPrints = c59v1
                c59v0 = true
                v81 = c59v0
                c59v1 = _T.ShowBackground
                c59v0 = IsNull
                c59v0 = c59v0(c59v1)
                if not c59v0 then
                  c59v0 = _T.ShowBackground
                  c59v1 = 0
                  c59v2 = nil
                  c59v3 = false
                  c59v0(c59v1, c59v2, c59v3)
                end
                do return end
              end
              __renovice_local_0.OnPreviewClose = c62v2
              __renovice_local_0 = v54
              c62v3 = "SetOnTransitionOutFunction"
              c62v4 = "OnPreviewClose"
              __renovice_local_0:Execute(c62v3, c62v4)
              __renovice_local_0 = _T
              c62v2 = function()
                local c60v0, c60v1, c60v2, c60v3
                c60v0 = {}
                c60v2 = { Print = nil }
                c60v3 = c62v1
                c60v3 = c60v3.RawItem
                c60v2.Print = c60v3
                c60v1 = table.insert
                c60v1(c60v0, c60v2)
                do return c60v0 end
              end
              __renovice_local_0.GetAllPrints = c62v2
              __renovice_local_0 = v54
              c62v3 = "SetElementsFunction"
              c62v4 = "GetAllPrints"
              __renovice_local_0:Execute(c62v3, c62v4)
              c62v2 = _T.HideBackground
              __renovice_local_0 = IsNull
              __renovice_local_0 = __renovice_local_0(c62v2)
              if not __renovice_local_0 then
                __renovice_local_0 = _T.HideBackground
                __renovice_local_0()
              end
            else
              __renovice_local_0 = c62v1.SortCategory
              if __renovice_local_0 == 100 then
                c62v2 = c62v1.RawItem
                __renovice_local_0 = IsNull
                __renovice_local_0 = __renovice_local_0(c62v2)
                if __renovice_local_0 then
                  do return end
                end
                __renovice_local_0 = c62v1.RawItem
                if __renovice_local_0 ~= nil then
                  c62v2 = c62v1.RawItem
                  c62v2 = c62v2.Nemesis
                  __renovice_local_0 = IsNull
                  __renovice_local_0 = __renovice_local_0(c62v2)
                  if not __renovice_local_0 then
                    __renovice_local_0 = _T
                    c62v2 = c62v1.RawItem
                    c62v2 = c62v2.Nemesis
                    __renovice_local_0.Nemesis_HistoryEntry = c62v2
                  end
                end
                __renovice_local_0 = _T
                c62v2 = function()
                  local c61v0, c61v1, c61v2, c61v3
                  c61v0 = _T
                  c61v1 = nil
                  c61v0.OnNemesisClosed = c61v1
                  c61v0 = true
                  v81 = c61v0
                  c61v1 = _T.ShowBackground
                  c61v0 = IsNull
                  c61v0 = c61v0(c61v1)
                  if not c61v0 then
                    c61v0 = _T.ShowBackground
                    c61v1 = 0
                    c61v2 = nil
                    c61v3 = false
                    c61v0(c61v1, c61v2, c61v3)
                  end
                  do return end
                end
                __renovice_local_0.OnNemesisClosed = c62v2
                __renovice_local_0 = mMovie
                c62v3 = nemesisMovie
                __renovice_local_0 = __renovice_local_0:PushChildMovie(c62v3)
                v54 = __renovice_local_0
                __renovice_local_0 = v54
                c62v3 = "SetCallback"
                c62v4 = "OnNemesisClosed"
                __renovice_local_0:Execute(c62v3, c62v4)
              else
                c62v2 = c62v1.StoreItem
                __renovice_local_0 = IsNull
                __renovice_local_0 = __renovice_local_0(c62v2)
                if __renovice_local_0 then
                  do return end
                end
                __renovice_local_0 = nil
                c62v3 = c62v1.Type
                c62v2 = IsNull
                c62v2 = c62v2(c62v3)
                if not c62v2 then
                  c62v3 = c62v1.RawItem
                  c62v2 = IsNull
                  c62v2 = c62v2(c62v3)
                  if not c62v2 then
                    c62v2 = c62v1.RawItem
                    c62v2 = c62v2.mModularParts
                    if c62v2 ~= nil then
                      c62v2 = { Gild = nil, Parts = nil }
                      c62v3 = c62v1.RawItem
                      c62v5 = 3
                      c62v3 = c62v3:HasFeature(c62v5)
                      c62v2.Gild = c62v3
                      c62v3 = c62v1.RawItem
                      c62v3 = c62v3.mModularParts
                      c62v2.Parts = c62v3
                      __renovice_local_0 = c62v2
                    end
                  end
                end
                c62v2 = _T
                c62v3 = { ITEM = nil }
                c62v4 = { ModularInfo = nil, StoreItem = nil, CanPurchaseOverride = false }
                c62v4.ModularInfo = __renovice_local_0
                c62v5 = c62v1.StoreItem
                c62v4.StoreItem = c62v5
                c62v3.ITEM = c62v4
                c62v2.marketDetailedViewParms = c62v3
                c62v2 = mMovie
                c62v4 = _G
                c62v4 = c62v4.UIMovie_DetailedPurchaseDialog
                c62v2 = c62v2:PushChildMovie(c62v4)
                v54 = c62v2
              end
            end
            __renovice_local_0 = false
            v81 = __renovice_local_0
            do return end
          end
        end
        do return end
      end
      __renovice_local_2.PreviewCallback = c77v1
      __renovice_local_2 = v43
      c77v1 = function(c63v0)
        local c63v1, c63v2, c63v3, c63v4, c63v5
        local __renovice_local_0 = v65
        if __renovice_local_0 then
          __renovice_local_0 = c63v0.SellingPrice
          if not __renovice_local_0 then
            __renovice_local_0 = c63v0.BuySlot
            if not __renovice_local_0 then
              __renovice_local_0 = c63v0.EmptySlot
              if not __renovice_local_0 then
                __renovice_local_0 = true
                do return __renovice_local_0 end
              end
            end
          end
        end
        __renovice_local_0 = v95
        c63v1 = v94
        c63v1 = c63v1.ARCANE
        if __renovice_local_0 == c63v1 then
          __renovice_local_0 = v64
          if not __renovice_local_0 then
            c63v1 = c63v0.ArcaneRank
            __renovice_local_0 = IsNull
            __renovice_local_0 = __renovice_local_0(c63v1)
            if not __renovice_local_0 then
              __renovice_local_0 = c63v0.ArcaneRank
              c63v1 = 0
              if c63v1 < __renovice_local_0 then
                __renovice_local_0 = true
                do return __renovice_local_0 end
              end
            end
          end
        end
        __renovice_local_0 = v43
        __renovice_local_0 = __renovice_local_0.mFilterBy
        c63v1 = v107
        c63v1 = c63v1.ALL
        if __renovice_local_0 == c63v1 then
          __renovice_local_0 = c63v0.BuySlot
          if __renovice_local_0 then
            __renovice_local_0 = true
            do return __renovice_local_0 end
          end
        end
        __renovice_local_0 = v63
        __renovice_local_0 = __renovice_local_0.mLabel
        if __renovice_local_0 ~= nil then
          __renovice_local_0 = v63
          __renovice_local_0 = __renovice_local_0.mLabel
          if __renovice_local_0 ~= "" then
            c63v1 = string.find
            c63v2 = c63v0.SearchCache
            c63v3 = ToSearchable
            c63v4 = v63
            c63v4 = c63v4.mLabel
            c63v3 = c63v3(c63v4)
            c63v4 = 1
            c63v5 = true
            c63v1 = c63v1(c63v2, c63v3, c63v4, c63v5)
            if c63v1 == nil then
              __renovice_local_0 = false
            else
              __renovice_local_0 = true
            end
            c63v1 = not __renovice_local_0
            do return c63v1 end
          end
        end
        __renovice_local_0 = false
        do return __renovice_local_0 end
      end
      __renovice_local_2.AdditionalFilterFunction = c77v1
      __renovice_local_2 = v43
      c77v1 = function(c64v0, c64v1)
        local c64v2
        c64v2 = v43
        c64v2 = c64v2.mScrollBar
        c64v0:UpdateScrollDrag(c64v2)
        do return end
      end
      __renovice_local_2.Update = c77v1
      __renovice_local_2 = v43
      c77v1 = function()
        local c65v0, c65v1, c65v2
        c65v0 = mMovie
        c65v1 = "OnSelectButtonPressed"
        c65v2 = ""
        c65v0:Execute(c65v1, c65v2)
        do return end
      end
      __renovice_local_2.SelectButtonCallback = c77v1
      __renovice_local_2 = v43
      c77v1 = v155
      __renovice_local_2.GetSelectButtonText = c77v1
      __renovice_local_2 = v43
      c77v1 = v156
      __renovice_local_2.ShowSelectButton = c77v1
      __renovice_local_2 = v23
      __renovice_local_2 = __renovice_local_2.HasCompletedQuest
      c77v1 = secondDreamQuest
      __renovice_local_2 = __renovice_local_2(c77v1)
      c77v1 = false
      __renovice_local_1 = v46
      __renovice_state_1 = IsNull
      __renovice_state_1 = __renovice_state_1(__renovice_local_1)
      if __renovice_state_1 then
        __renovice_state_0 = 22
      else
        __renovice_state_0 = 15
      end
    end
    if __renovice_state_0 == 15 then
      __renovice_state_1 = v46
      __renovice_state_1 = __renovice_state_1:GetInventory()
      if __renovice_local_2 then
        __renovice_state_0 = 22
      else
        __renovice_state_0 = 16
      end
    end
    if __renovice_state_0 == 16 then
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(__renovice_state_1)
      if __renovice_local_1 then
        __renovice_state_0 = 22
      else
        __renovice_state_0 = 17
      end
    end
    if __renovice_state_0 == 17 then
      __renovice_local_1 = __renovice_state_1:GetMiscItems()
      c77v3 = 1
      __renovice_local_0 = #__renovice_local_1
      c77v2 = 1
      local __renovice_fornprep_zero_0 = 0
      if __renovice_fornprep_zero_0 < c77v2 then
        if __renovice_local_0 < c77v3 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 18
        end
      else
        __renovice_fornprep_zero_0 = 0
        if c77v2 < __renovice_fornprep_zero_0 then
          if c77v3 < __renovice_local_0 then
            __renovice_state_0 = 22
          else
            __renovice_state_0 = 18
          end
        else
          __renovice_state_0 = 18
        end
      end
    end
    if __renovice_state_0 == 18 then
      c77v4 = __renovice_local_1[c77v3]
      c77v4 = c77v4.mItemType
      c77v6 = gFocusLensType
      c77v4 = c77v4:IsA(c77v6)
      if not c77v4 then
        __renovice_state_0 = 21
      else
        __renovice_state_0 = 19
      end
    end
    if __renovice_state_0 == 19 then
      c77v4 = __renovice_local_1[c77v3]
      c77v4 = c77v4.mItemCount
      c77v5 = 0
      if c77v4 <= c77v5 then
        __renovice_state_0 = 21
      else
        __renovice_state_0 = 20
      end
    end
    if __renovice_state_0 == 20 then
      c77v1 = true
      __renovice_state_0 = 22
    end
    if __renovice_state_0 == 21 then
      __renovice_state_0 = 22
    end
    if __renovice_state_0 == 22 then
      __renovice_state_1 = {}
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.TRADE_MODS
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_state_0 = 24
      else
        __renovice_state_0 = 23
      end
    end
    if __renovice_state_0 == 23 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.MODS_SKIP_LIST
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 25
      else
        __renovice_state_0 = 24
      end
    end
    if __renovice_state_0 == 24 then
      __renovice_local_1 = v27
      __renovice_local_1 = __renovice_local_1.GetCollectionCategories
      __renovice_local_0 = false
      c77v2 = true
      c77v3 = true
      c77v4 = true
      __renovice_state_1 = __renovice_local_1(__renovice_local_0, c77v2, c77v3, c77v4)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 25 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.PRIMEPARTS
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 27
      else
        __renovice_state_0 = 26
      end
    end
    if __renovice_state_0 == 26 then
      c77v2 = { Name = "/Lotus/Language/Categories/PRIME", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AllOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.PRIME
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 27 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.TREASURE
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_state_0 = 29
      else
        __renovice_state_0 = 28
      end
    end
    if __renovice_state_0 == 28 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.SHARDS
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 30
      else
        __renovice_state_0 = 29
      end
    end
    if __renovice_state_0 == 29 then
      c77v2 = { Name = "/Lotus/Language/Categories/MISC", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AllOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.MISC
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 30 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.SHIP_SCRAP
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_state_0 = 33
      else
        __renovice_state_0 = 31
      end
    end
    if __renovice_state_0 == 31 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.SHIP_PARTS
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_state_0 = 33
      else
        __renovice_state_0 = 32
      end
    end
    if __renovice_state_0 == 32 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.SHIP_RAW
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 34
      else
        __renovice_state_0 = 33
      end
    end
    if __renovice_state_0 == 33 then
      c77v2 = { Name = "/Lotus/Language/Menu/CategoryAll", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AllOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ALL
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Categories/CREWSHIP_WEAPONS_MKI", Icon = nil, Category = nil }
      c77v3 = categoryIcons[27]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.MKI
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Categories/CREWSHIP_WEAPONS_MKII", Icon = nil, Category = nil }
      c77v3 = categoryIcons[28]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.MKII
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Categories/CREWSHIP_WEAPONS_MKIII", Icon = nil, Category = nil }
      c77v3 = categoryIcons[29]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.MKIII
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/AP_TACTIC_RAILJACK", Icon = nil, Category = nil }
      c77v3 = categoryIcons[30]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.LAVAN
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/AP_ATTACK_RAILJACK", Icon = nil, Category = nil }
      c77v3 = categoryIcons[31]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.VIDAR
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/AP_DEFENSE_RAILJACK", Icon = nil, Category = nil }
      c77v3 = categoryIcons[32]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ZEKTI
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/AP_UNIVERSAL_RAILJACK", Icon = nil, Category = nil }
      c77v3 = categoryIcons[33]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.SIGMA
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 34 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.FISH
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 36
      else
        __renovice_state_0 = 35
      end
    end
    if __renovice_state_0 == 35 then
      c77v2 = { Name = "/Lotus/Language/Menu/CategoryAll", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AllOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ALL
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/UiElements/SelectAllFishCategorySmall", Icon = nil, Category = nil }
      c77v3 = categoryIcons[17]
      c77v2.Icon = c77v3
      c77v3 = v108
      c77v3 = c77v3.FISH_SMALL
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/UiElements/SelectAllFishCategoryMedium", Icon = nil, Category = nil }
      c77v3 = categoryIcons[18]
      c77v2.Icon = c77v3
      c77v3 = v108
      c77v3 = c77v3.FISH_MEDIUM
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/UiElements/SelectAllFishCategoryLarge", Icon = nil, Category = nil }
      c77v3 = categoryIcons[19]
      c77v2.Icon = c77v3
      c77v3 = v108
      c77v3 = c77v3.FISH_LARGE
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 36 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.ENEMIES
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 38
      else
        __renovice_state_0 = 37
      end
    end
    if __renovice_state_0 == 37 then
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.ALL
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Menu/CategoryAll"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AllOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.GRINEER
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Game/Faction_GrineerUC"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_GrineerOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.CORPUS
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Game/Faction_CorpusUC"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_CorpusOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.INFESTED
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Game/Faction_InfestationUC"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_InfestedOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.WILD
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Game/Faction_WildUC"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_WildOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.OROKIN
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Game/Faction_OrokinUC"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_OrokinOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.SENTIENT
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Game/Faction_SentientUC"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_SentientOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.NARMER
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Factions/Faction_NewWarNarmerUC"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_NarmerOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.MURMUR
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/Entrati/MurmurFactionName"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_MurmurOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.SCALDRA
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/1999/Faction_Scaldra"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_ScaldraOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.TECHROT
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/1999/Faction_Techrot"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_TechrotOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Category = nil, Name = nil, Icon = nil }
      c77v3 = v107
      c77v3 = c77v3.ANARCH
      c77v2.Category = c77v3
      c77v3 = mMovie
      c77v5 = "/Lotus/Language/TauPrequel/TauPrequelFinal/FactionSeparatist"
      c77v6 = false
      c77v3 = c77v3:GetLocalized(c77v5, c77v6)
      c77v2.Name = c77v3
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AnarchOn
      c77v2.Icon = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 38 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.DECODONATE
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 40
      else
        __renovice_state_0 = 39
      end
    end
    if __renovice_state_0 == 39 then
      __renovice_local_1 = v22
      __renovice_local_1 = __renovice_local_1.GetShipDecoCategories
      __renovice_local_0 = true
      __renovice_state_1 = __renovice_local_1(__renovice_local_0)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 40 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.SYNDDONATE
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 42
      else
        __renovice_state_0 = 41
      end
    end
    if __renovice_state_0 == 41 then
      c77v2 = { Name = "/Lotus/Language/Menu/CategoryAll", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AllOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ALL
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 42 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.ARCANE
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 44
      else
        __renovice_state_0 = 43
      end
    end
    if __renovice_state_0 == 43 then
      c77v2 = { Name = "/Lotus/Language/Categories/ENHANCEMENTS", Icon = nil, Category = nil }
      c77v3 = categoryIcons[6]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ENHANCEMENTS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 44 then
      c77v2 = { Name = "/Lotus/Language/Menu/CategoryAll", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_AllOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ALL
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_local_1 = v129
      __renovice_local_1 = __renovice_local_1()
      if __renovice_local_1 then
        __renovice_state_0 = 46
      else
        __renovice_state_0 = 45
      end
    end
    if __renovice_state_0 == 45 then
      c77v2 = { Name = "/Lotus/Language/Menu/Store_Warframes", Icon = nil, Category = nil }
      c77v3 = categoryIcons[2]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.WARFRAME
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 46
    end
    if __renovice_state_0 == 46 then
      c77v2 = { Name = "/Lotus/Language/Menu/ItemInventory_Weapons", Icon = nil, Category = nil }
      c77v3 = categoryIcons[3]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.WEAPONS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/Global_ProductCategory_Robotics", Icon = nil, Category = nil }
      c77v3 = categoryIcons[4]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.SENTINEL
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_local_1 = v129
      __renovice_local_1 = __renovice_local_1()
      if not __renovice_local_1 then
        __renovice_state_0 = 48
      else
        __renovice_state_0 = 47
      end
    end
    if __renovice_state_0 == 47 then
      c77v2 = { Name = "/Lotus/Language/Menu/Archwing_Weapons", Icon = nil, Category = nil }
      c77v3 = categoryIcons[14]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ARCHWINGWEAPONS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 48
    end
    if __renovice_state_0 == 48 then
      c77v2 = { Name = "/Lotus/Language/Categories/APPEARANCE", Icon = nil, Category = nil }
      c77v3 = categoryIcons[5]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.APPEARANCE
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Categories/ENHANCEMENTS", Icon = nil, Category = nil }
      c77v3 = categoryIcons[6]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ENHANCEMENTS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      if (not __renovice_local_2 and not c77v1) then
        __renovice_state_0 = 51
      else
        __renovice_state_0 = 50
      end
    end
    if __renovice_state_0 == 50 then
      c77v2 = { Name = "/Lotus/Language/Menu/Focus", Icon = nil, Category = nil }
      c77v3 = categoryIcons[7]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.FOCUS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 51
    end
    if __renovice_state_0 == 51 then
      c77v2 = { Name = "/Lotus/Language/Categories/GEAR", Icon = nil, Category = nil }
      c77v3 = categoryIcons[9]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.GEAR
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Categories/KEYS", Icon = nil, Category = nil }
      c77v3 = categoryIcons[10]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.KEYS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.RESDONATE
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_state_0 = 53
      else
        __renovice_state_0 = 52
      end
    end
    if __renovice_state_0 == 52 then
      c77v2 = { Name = "/Lotus/Language/Categories/RESOURCES", Icon = nil, Category = nil }
      c77v3 = categoryIcons[11]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.RESOURCES
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 53
    end
    if __renovice_state_0 == 53 then
      c77v2 = { Name = "/Lotus/Language/Categories/PRIME", Icon = nil, Category = nil }
      c77v3 = categoryIcons[12]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.PRIME
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.INVENTORY
      if __renovice_local_1 == __renovice_local_0 then
        __renovice_state_0 = 55
      else
        __renovice_state_0 = 54
      end
    end
    if __renovice_state_0 == 54 then
      __renovice_local_1 = v95
      __renovice_local_0 = v94
      __renovice_local_0 = __renovice_local_0.TRADE_ITEMS
      if __renovice_local_1 ~= __renovice_local_0 then
        __renovice_state_0 = 56
      else
        __renovice_state_0 = 55
      end
    end
    if __renovice_state_0 == 55 then
      c77v2 = { Name = "/Lotus/Language/Menu/ImprintCreator", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_ImprintsOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.PETPRINTS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 56
    end
    if __renovice_state_0 == 56 then
      __renovice_local_1 = v129
      __renovice_local_1 = __renovice_local_1()
      if __renovice_local_1 then
        __renovice_state_0 = 58
      else
        __renovice_state_0 = 57
      end
    end
    if __renovice_state_0 == 57 then
      c77v2 = { Name = "/Lotus/Language/Menu/Loadout_Vehicles", Icon = nil, Category = nil }
      c77v3 = categoryIcons[13]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ARCHWING
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/Archwing_Weapons", Icon = nil, Category = nil }
      c77v3 = categoryIcons[14]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.ARCHWINGWEAPONS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Necromech/MechPluralCategoryName", Icon = nil, Category = nil }
      c77v3 = categoryIcons[34]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.MECHS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Categories/AMPS", Icon = nil, Category = nil }
      c77v3 = categoryIcons[16]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.OPERATORAMPS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 59
    end
    if __renovice_state_0 == 58 then
      c77v2 = { Name = "/Lotus/Language/FusionTreasure/FusionTreasureMgr_Title", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_FusionTreasuresOn
      c77v2.Icon = c77v3
      c77v3 = v109
      c77v3 = c77v3.AYATAN
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/Crafting_Blueprints", Icon = nil, Category = nil }
      c77v3 = _G
      c77v3 = c77v3.UICategoryIcon_RecipesOn
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.RECIPES
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Dojo/Trade_LichCategory", Icon = nil, Category = nil }
      c77v3 = categoryIcons[21]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.LICH
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Railjack/Avionics", Icon = nil, Category = nil }
      c77v3 = categoryIcons[25]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.AVIONICS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Menu/Loadout_Emotes", Icon = nil, Category = nil }
      c77v3 = categoryIcons[35]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.EMOTE
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 59
    end
    if __renovice_state_0 == 59 then
      c77v2 = { Name = "/Lotus/Language/Categories/RELICS", Icon = nil, Category = nil }
      c77v3 = categoryIcons[20]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.RELICS
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      c77v2 = { Name = "/Lotus/Language/Categories/MISC", Icon = nil, Category = nil }
      c77v4 = categoryIcons
      c77v3 = c77v4[15]
      c77v2.Icon = c77v3
      c77v3 = v107
      c77v3 = c77v3.MISC
      c77v2.Category = c77v3
      __renovice_local_1 = table.insert
      __renovice_local_1(__renovice_state_1, c77v2)
      __renovice_state_0 = 60
    end
    if __renovice_state_0 == 60 then
      __renovice_local_1 = ipairs
      __renovice_local_1, __renovice_local_0, c77v2 = __renovice_local_1(__renovice_state_1)
      __renovice_state_0 = 62
    end
    if __renovice_state_0 == 61 then
      c77v5 = string.upper
      c77v6 = mMovie
      c77v8 = c77v4.Name
      c77v9 = false
      c77v5 = c77v5(c77v6:GetLocalized(c77v8, c77v9))
      c77v4.Name = c77v5
      c77v5 = v43
      c77v5:AddCategory(c77v4)
      __renovice_state_0 = 62
    end
    if __renovice_state_0 == 62 then
      __renovice_state_0 = 63
    end
    if __renovice_state_0 == 63 then
      __renovice_local_1 = function(c66v0, c66v1)
        local c66v2, c66v3, c66v4
        c66v2 = c66v0.EmptySlot
        if not c66v2 then
          c66v2 = c66v1.EmptySlot
          if not c66v2 then
            c66v2 = c66v1.BuySlot
            if not c66v2 then
              c66v2 = c66v0.BuySlot
              if not c66v2 then
                c66v2 = c66v0.IsPreset
                if not c66v2 then
                  c66v2 = c66v1.IsPreset
                  if not c66v2 then
                    c66v3 = c66v0.Name
                    c66v2 = #c66v3
                    if c66v2 ~= 0 then
                      c66v3 = c66v1.Name
                      c66v2 = #c66v3
                      if c66v2 ~= 0 then
                        c66v2 = c66v0.SearchRank
                        if c66v2 ~= nil then
                          c66v2 = c66v1.SearchRank
                          if c66v2 ~= nil then
                            c66v2 = c66v0.SearchRank
                            c66v3 = c66v1.SearchRank
                            if c66v2 ~= c66v3 then
                              c66v3 = c66v0.SearchRank
                              c66v4 = c66v1.SearchRank
                              if c66v3 <= c66v4 then
                                c66v2 = false
                                do return c66v2 end
                              end
                              c66v2 = true
                              do return c66v2 end
                            end
                          end
                        end
                        c66v2 = nil
                        do return c66v2 end
                      end
                    end
                    c66v4 = c66v0.Name
                    c66v3 = #c66v4
                    if c66v3 == 0 then
                      c66v2 = false
                      do return c66v2 end
                    end
                    c66v2 = true
                    do return c66v2 end
                  end
                end
                c66v3 = c66v1.IsPreset
                if c66v3 == true then
                  c66v2 = false
                  do return c66v2 end
                end
                c66v2 = true
                do return c66v2 end
              end
            end
            c66v3 = c66v1.BuySlot
            if c66v3 == true then
              c66v2 = false
              do return c66v2 end
            end
            c66v2 = true
            do return c66v2 end
          end
        end
        c66v3 = c66v0.EmptySlot
        if c66v3 == true then
          c66v2 = false
          do return c66v2 end
        end
        c66v2 = true
        do return c66v2 end
      end
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.TRADE_MODS
      if __renovice_local_0 == c77v2 then
        __renovice_state_0 = 65
      else
        __renovice_state_0 = 64
      end
    end
    if __renovice_state_0 == 64 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.MODS_SKIP_LIST
      if __renovice_local_0 ~= c77v2 then
        __renovice_state_0 = 68
      else
        __renovice_state_0 = 65
      end
    end
    if __renovice_state_0 == 65 then
      __renovice_local_0 = v27
      __renovice_local_0 = __renovice_local_0.GetCollectionSortBy
      __renovice_local_0 = __renovice_local_0()
      c77v4 = 1
      c77v2 = #__renovice_local_0
      c77v3 = 1
      local __renovice_fornprep_zero_1 = 0
      if __renovice_fornprep_zero_1 < c77v3 then
        if c77v2 < c77v4 then
          __renovice_state_0 = 69
        else
          __renovice_state_0 = 66
        end
      else
        __renovice_fornprep_zero_1 = 0
        if c77v3 < __renovice_fornprep_zero_1 then
          if c77v4 < c77v2 then
            __renovice_state_0 = 69
          else
            __renovice_state_0 = 66
          end
        else
          __renovice_state_0 = 66
        end
      end
    end
    if __renovice_state_0 == 66 then
      c77v5 = __renovice_local_0[c77v4]
      c77v5 = c77v5.Attribute
      c77v6 = __renovice_local_0[c77v4]
      c77v7 = function(c67v0, c67v1)
        local c67v2, c67v3
        c67v2 = __renovice_local_1
        c67v2 = c67v2(c67v0, c67v1)
        if c67v2 ~= nil then
          do return c67v2 end
        end
        c67v3 = c77v5
        c67v3 = c67v3(c67v0, c67v1)
        do return c67v3 end
      end
      c77v6.Attribute = c77v7
      c77v6 = v43
      c77v8 = __renovice_local_0[c77v4]
      c77v6:AddSortBy(c77v8)
      __renovice_state_0 = 67
    end
    if __renovice_state_0 == 67 then
      __renovice_state_0 = 69
    end
    if __renovice_state_0 == 68 then
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "NAME", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Menu/SortBy_Name"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c68v0, c68v1)
        local c68v2, c68v3, c68v4, c68v5
        c68v2 = __renovice_local_1
        c68v2 = c68v2(c68v0, c68v1)
        if c68v2 ~= nil then
          do return c68v2 end
        end
        c68v4 = c68v0.SearchCache
        c68v5 = c68v1.SearchCache
        if c68v5 <= c68v4 then
          c68v3 = false
          do return c68v3 end
        end
        c68v3 = true
        do return c68v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_state_0 = 69
    end
    if __renovice_state_0 == 69 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.ENEMIES
      if __renovice_local_0 ~= c77v2 then
        __renovice_state_0 = 71
      else
        __renovice_state_0 = 70
      end
    end
    if __renovice_state_0 == 70 then
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "SCAN", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Menu/Scanned"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c69v0, c69v1)
        local c69v2, c69v3, c69v4, c69v5
        c69v2 = __renovice_local_1
        c69v2 = c69v2(c69v0, c69v1)
        if c69v2 ~= nil then
          do return c69v2 end
        end
        c69v3 = c69v0.Locked
        c69v4 = c69v1.Locked
        if c69v3 ~= c69v4 then
          c69v3 = c69v1.Locked
          do return c69v3 end
        end
        c69v4 = c69v0.SearchCache
        c69v5 = c69v1.SearchCache
        if c69v5 <= c69v4 then
          c69v3 = false
          do return c69v3 end
        end
        c69v3 = true
        do return c69v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      do return end
    elseif __renovice_state_0 == 71 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.FISH
      if __renovice_local_0 == c77v2 then
        __renovice_state_0 = 77
      else
        __renovice_state_0 = 72
      end
    end
    if __renovice_state_0 == 72 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.DECODONATE
      if __renovice_local_0 == c77v2 then
        __renovice_state_0 = 77
      else
        __renovice_state_0 = 73
      end
    end
    if __renovice_state_0 == 73 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.RESDONATE
      if __renovice_local_0 == c77v2 then
        __renovice_state_0 = 77
      else
        __renovice_state_0 = 74
      end
    end
    if __renovice_state_0 == 74 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.SYNDDONATE
      if __renovice_local_0 ~= c77v2 then
        __renovice_state_0 = 76
      else
        __renovice_state_0 = 75
      end
    end
    if __renovice_state_0 == 75 then
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "SELL_PRICE", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Labels/SortBy_TradeValue"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c70v0, c70v1)
        local c70v2, c70v3, c70v4, c70v5
        c70v2 = __renovice_local_1
        c70v2 = c70v2(c70v0, c70v1)
        if c70v2 ~= nil then
          do return c70v2 end
        end
        c70v3 = c70v0.SellingPrice
        c70v4 = c70v1.SellingPrice
        if c70v3 == c70v4 then
          c70v4 = c70v0.SearchCache
          c70v5 = c70v1.SearchCache
          if c70v5 <= c70v4 then
            c70v3 = false
            do return c70v3 end
          end
          c70v3 = true
          do return c70v3 end
        end
        c70v3 = c70v0.SellingPrice
        if c70v3 ~= nil then
          c70v3 = c70v1.SellingPrice
          if c70v3 ~= nil then
            c70v4 = c70v0.SellingPrice
            c70v5 = c70v1.SellingPrice
            if c70v4 <= c70v5 then
              c70v3 = false
              do return c70v3 end
            end
            c70v3 = true
            do return c70v3 end
          end
        end
        c70v4 = c70v1.SellingPrice
        if c70v4 ~= nil then
          c70v3 = false
          do return c70v3 end
        end
        c70v3 = true
        do return c70v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_state_0 = 77
    end
    if __renovice_state_0 == 76 then
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "SELL_PRICE", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Menu/SortBy_SellingPrice"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c71v0, c71v1)
        local c71v2, c71v3, c71v4, c71v5
        c71v2 = __renovice_local_1
        c71v2 = c71v2(c71v0, c71v1)
        if c71v2 ~= nil then
          do return c71v2 end
        end
        c71v3 = c71v0.SellingPrice
        c71v4 = c71v1.SellingPrice
        if c71v3 == c71v4 then
          c71v4 = c71v0.SearchCache
          c71v5 = c71v1.SearchCache
          if c71v5 <= c71v4 then
            c71v3 = false
            do return c71v3 end
          end
          c71v3 = true
          do return c71v3 end
        end
        c71v3 = c71v0.SellingPrice
        if c71v3 ~= nil then
          c71v3 = c71v1.SellingPrice
          if c71v3 ~= nil then
            c71v4 = c71v0.SellingPrice
            c71v5 = c71v1.SellingPrice
            if c71v4 <= c71v5 then
              c71v3 = false
              do return c71v3 end
            end
            c71v3 = true
            do return c71v3 end
          end
        end
        c71v4 = c71v1.SellingPrice
        if c71v4 ~= nil then
          c71v3 = false
          do return c71v3 end
        end
        c71v3 = true
        do return c71v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_state_0 = 77
    end
    if __renovice_state_0 == 77 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.SHIP_SCRAP
      if __renovice_local_0 == c77v2 then
        __renovice_state_0 = 80
      else
        __renovice_state_0 = 78
      end
    end
    if __renovice_state_0 == 78 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.SHIP_PARTS
      if __renovice_local_0 == c77v2 then
        __renovice_state_0 = 80
      else
        __renovice_state_0 = 79
      end
    end
    if __renovice_state_0 == 79 then
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "COUNT", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Menu/Store_Owned"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c72v0, c72v1)
        local c72v2, c72v3, c72v4, c72v5
        c72v2 = __renovice_local_1
        c72v2 = c72v2(c72v0, c72v1)
        if c72v2 ~= nil then
          do return c72v2 end
        end
        c72v3 = c72v0.Count
        c72v4 = c72v1.Count
        if c72v3 == c72v4 then
          c72v4 = c72v0.SearchCache
          c72v5 = c72v1.SearchCache
          if c72v5 <= c72v4 then
            c72v3 = false
            do return c72v3 end
          end
          c72v3 = true
          do return c72v3 end
        end
        c72v3 = c72v0.Count
        if c72v3 ~= nil then
          c72v3 = c72v1.Count
          if c72v3 ~= nil then
            c72v4 = c72v0.Count
            c72v5 = c72v1.Count
            if c72v4 <= c72v5 then
              c72v3 = false
              do return c72v3 end
            end
            c72v3 = true
            do return c72v3 end
          end
        end
        c72v4 = c72v1.Count
        if c72v4 ~= nil then
          c72v3 = false
          do return c72v3 end
        end
        c72v3 = true
        do return c72v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_state_0 = 81
    end
    if __renovice_state_0 == 80 then
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "MK_TIER", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Menu/SortBy_Level"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c73v0, c73v1)
        local c73v2, c73v3, c73v4, c73v5
        c73v2 = __renovice_local_1
        c73v2 = c73v2(c73v0, c73v1)
        if c73v2 ~= nil then
          do return c73v2 end
        end
        c73v3 = c73v0.Tier
        c73v4 = c73v1.Tier
        if c73v3 == c73v4 then
          c73v4 = c73v0.SearchCache
          c73v5 = c73v1.SearchCache
          if c73v5 <= c73v4 then
            c73v3 = false
            do return c73v3 end
          end
          c73v3 = true
          do return c73v3 end
        end
        c73v3 = c73v0.Tier
        if c73v3 ~= nil then
          c73v3 = c73v1.Tier
          if c73v3 ~= nil then
            c73v4 = c73v0.Tier
            c73v5 = c73v1.Tier
            if c73v4 <= c73v5 then
              c73v3 = false
              do return c73v3 end
            end
            c73v3 = true
            do return c73v3 end
          end
        end
        c73v3 = false
        c73v4 = c73v0.Tier
        if c73v4 ~= nil then
          c73v4 = c73v1.Tier
          if c73v4 ~= nil then
            c73v3 = false
            do return c73v3 end
          end
          c73v3 = true
        end
        do return c73v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "BRAND", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Menu/SortBy_Type"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c74v0, c74v1)
        local c74v2, c74v3, c74v4, c74v5
        c74v2 = __renovice_local_1
        c74v2 = c74v2(c74v0, c74v1)
        if c74v2 ~= nil then
          do return c74v2 end
        end
        c74v3 = c74v0.Brand
        c74v4 = c74v1.Brand
        if c74v3 == c74v4 then
          c74v4 = c74v0.SearchCache
          c74v5 = c74v1.SearchCache
          if c74v5 <= c74v4 then
            c74v3 = false
            do return c74v3 end
          end
          c74v3 = true
          do return c74v3 end
        end
        c74v3 = c74v0.Brand
        if c74v3 ~= nil then
          c74v3 = c74v1.Brand
          if c74v3 ~= nil then
            c74v4 = c74v0.Brand
            c74v5 = c74v1.Brand
            if c74v5 <= c74v4 then
              c74v3 = false
              do return c74v3 end
            end
            c74v3 = true
            do return c74v3 end
          end
        end
        c74v3 = false
        c74v4 = c74v0.Brand
        if c74v4 ~= nil then
          c74v4 = c74v1.Brand
          if c74v4 ~= nil then
            c74v3 = false
            do return c74v3 end
          end
          c74v3 = true
        end
        do return c74v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_state_0 = 81
    end
    if __renovice_state_0 == 81 then
      __renovice_local_0 = v95
      c77v2 = v94
      c77v2 = c77v2.PRIMEPARTS
      if __renovice_local_0 ~= c77v2 then
        __renovice_state_0 = 83
      else
        __renovice_state_0 = 82
      end
    end
    if __renovice_state_0 == 82 then
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "CRAFTED", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/CraftingComponents/CraftedSingular"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c75v0, c75v1)
        local c75v2, c75v3, c75v4, c75v5
        c75v2 = __renovice_local_1
        c75v2 = c75v2(c75v0, c75v1)
        if c75v2 ~= nil then
          do return c75v2 end
        end
        c75v3 = c75v0.ResultOwned
        c75v4 = c75v1.ResultOwned
        if c75v3 == c75v4 then
          c75v4 = c75v0.SearchCache
          c75v5 = c75v1.SearchCache
          if c75v5 <= c75v4 then
            c75v3 = false
            do return c75v3 end
          end
          c75v3 = true
          do return c75v3 end
        end
        c75v3 = c75v0.ResultOwned
        if c75v3 ~= nil then
          c75v3 = c75v1.ResultOwned
          if c75v3 ~= nil then
            c75v4 = c75v0.ResultOwned
            c75v5 = c75v1.ResultOwned
            if c75v4 <= c75v5 then
              c75v3 = false
              do return c75v3 end
            end
            c75v3 = true
            do return c75v3 end
          end
        end
        c75v3 = false
        c75v4 = c75v0.ResultOwned
        if c75v4 ~= nil then
          c75v4 = c75v1.ResultOwned
          if c75v4 ~= nil then
            c75v3 = false
            do return c75v3 end
          end
          c75v3 = true
        end
        do return c75v3 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_local_0 = v43
      c77v3 = { Name = nil, SortId = "MASTERED", Attribute = nil }
      c77v4 = mMovie
      c77v6 = "/Lotus/Language/Menu/DetailedPurchase_Mastered"
      c77v7 = false
      c77v4 = c77v4:GetLocalized(c77v6, c77v7)
      c77v3.Name = c77v4
      c77v4 = function(c76v0, c76v1)
        local c76v2, c76v3, c76v4, c76v5, c76v6, c76v7, c76v8
        c76v2 = __renovice_local_1
        c76v2 = c76v2(c76v0, c76v1)
        c76v3 = false
        c76v4 = c76v0.Rank
        if c76v4 ~= nil then
          c76v4 = c76v0.Rank
          c76v5 = gGameConfig
          c76v7 = c76v0.Type
          c76v5 = c76v5:GetLevelCap(c76v7)
          if c76v4 < c76v5 then
            c76v3 = false
          else
            c76v3 = true
          end
        end
        c76v4 = false
        c76v5 = c76v1.Rank
        if c76v5 ~= nil then
          c76v5 = c76v1.Rank
          c76v6 = gGameConfig
          c76v8 = c76v1.Type
          c76v6 = c76v6:GetLevelCap(c76v8)
          if c76v5 < c76v6 then
            c76v4 = false
          else
            c76v4 = true
          end
        end
        if c76v2 ~= nil then
          do return c76v2 end
        end
        if c76v3 ~= c76v4 then
          do return c76v3 end
        end
        c76v6 = c76v0.SearchCache
        c76v7 = c76v1.SearchCache
        if c76v7 <= c76v6 then
          c76v5 = false
          do return c76v5 end
        end
        c76v5 = true
        do return c76v5 end
      end
      c77v3.Attribute = c77v4
      __renovice_local_0:AddSortBy(c77v3)
      __renovice_state_0 = 83
    end
    if __renovice_state_0 == 83 then
      do return end
    end
    do return end
  end
  v162 = function(c80v0, c80v1, c80v2)
    local c80v3, c80v4, c80v5, c80v6, c80v7, c80v8, c80v9, c80v10, c80v11, c80v12, c80v13, c80v14, c80v15, c80v16, c80v17, c80v18, c80v19, c80v20
    local __renovice_local_0 = v27
    __renovice_local_0 = __renovice_local_0.CardFromArtifact
    c80v11 = nil
    local __renovice_local_1 = c80v11.RawItem
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    c80v11.Card = __renovice_local_0
    __renovice_local_1 = c80v11.Card
    c80v3 = nil
    c80v3(__renovice_local_1)
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.MODS_SKIP_LIST
    __renovice_local_0 = { Card = nil, Count = 1, Installed = false, SearchCache = nil, Selected = nil }
    __renovice_local_0.Card = c80v11
    c80v15 = ToSearchable
    c80v16 = c80v11.mName
    c80v12 = c80v15(c80v16)
    c80v13 = " "
    c80v14 = ToSearchable
    c80v15 = c80v11.mDesc
    c80v14 = c80v14(c80v15)
    __renovice_local_1 = c80v12 .. c80v13 .. c80v14
    __renovice_local_0.SearchCache = __renovice_local_1
    __renovice_local_1 = c80v11.mSelected
    __renovice_local_0.Selected = __renovice_local_1
    c80v11 = __renovice_local_0
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.TRADE_ITEMS
    __renovice_local_1 = c80v11.Type
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    __renovice_local_0 = c80v11.Type
    c80v12 = v2
    __renovice_local_0 = __renovice_local_0:IsA(c80v12)
    __renovice_local_0 = c80v11.Type
    c80v12 = v3
    __renovice_local_0 = __renovice_local_0:IsA(c80v12)
    __renovice_local_0 = v27
    __renovice_local_0 = __renovice_local_0.CardFromArtifact
    __renovice_local_1 = c80v11.RawItem
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    c80v3(__renovice_local_0)
    __renovice_local_1 = __renovice_local_0.mInstalled
    c80v11.mModInstalledTable = __renovice_local_1
    __renovice_local_1 = c80v11.Type
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    __renovice_local_0 = c80v11.Type
    c80v12 = v4
    __renovice_local_0 = __renovice_local_0:IsA(c80v12)
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.SHIP_SCRAP
    __renovice_local_1 = c80v11.RawItem
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.MODS_SKIP_LIST
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.SHIP_SCRAP
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.SHIP_PARTS
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.SHIP_RAW
    __renovice_local_0 = {c80v1}
    c80v11.Categories = __renovice_local_0
    __renovice_local_0 = v89
    __renovice_local_0 = v129
    __renovice_local_0 = __renovice_local_0()
    __renovice_local_0 = c80v11.EmptySlot
    c80v12 = _T.InvTradingInfo.State
    __renovice_local_1 = c80v12[__renovice_local_0]
    c80v12 = false
    c80v14 = __renovice_local_1.Ids
    c80v13 = #c80v14
    c80v14 = 0
    c80v16 = 1
    c80v17 = __renovice_local_1.Ids
    c80v14 = #c80v17
    c80v15 = 1
    for __renovice_for_0_0 = c80v16, c80v14, c80v15 do
      c80v18 = __renovice_local_1.Ids
      c80v17 = c80v18[__renovice_for_0_0]
      if c80v17 == c80v13 then break end
    end
    c80v17 = v142
    c80v19 = nil
    c80v20 = 1
    c80v17(c80v11, c80v19, c80v20)
    c80v12 = true
    c80v13 = __renovice_local_1.Count
    c80v14 = 0
    c80v14 = c80v11.RawItem
    c80v13 = IsNull
    c80v13 = c80v13(c80v14)
    c80v13 = c80v11.RawItem
    c80v13 = c80v13.mItemId
    c80v13 = c80v11.RawItem
    c80v13 = c80v13.mItemId
    c80v13 = c80v13:IsZero()
    c80v13 = v142
    c80v15 = nil
    c80v16 = __renovice_local_1.Count
    c80v13(c80v11, c80v15, c80v16)
    __renovice_local_1 = c80v11.RawItem
    __renovice_local_1 = __renovice_local_1.mItemId
    __renovice_local_1 = __renovice_local_1.mId
    c80v6 = nil
    __renovice_local_0 = c80v6[__renovice_local_1]
    if __renovice_local_0 then
      __renovice_local_0 = true
      c80v11.Locked = __renovice_local_0
      __renovice_local_0 = "/Lotus/Language/Railjack/WreckageLimit_Repairing"
      c80v11.LockedMsg = __renovice_local_0
    end
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.ARCANE
    if __renovice_local_0 == __renovice_local_1 then
      c80v4 = nil
      c80v4(c80v11)
      __renovice_local_1 = c80v11.mInstalled
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(__renovice_local_1)
      if not __renovice_local_0 then
        __renovice_local_0 = next
        __renovice_local_1 = c80v11.mInstalled
        __renovice_local_0 = __renovice_local_0(__renovice_local_1)
        __renovice_local_1 = gGameData
        __renovice_local_1 = __renovice_local_1:GetInventory()
        __renovice_local_1 = __renovice_local_1:Name__34888a88(__renovice_local_0)
        c80v12 = v5
        c80v14 = __renovice_local_1.mItemType
        c80v12 = c80v12:GetStoreItem(c80v14)
        c80v13 = mMovie
        c80v15 = tostring
        c80v15 = c80v15(c80v12:GetLocalizeTag())
        c80v16 = true
        c80v13 = c80v13:GetLocalized(c80v15, c80v16)
        c80v11.FirstInstalledName = c80v13
      end
    end
    c80v11 = ResetLineCount
    __renovice_local_0 = 0
    c80v11(__renovice_local_0)
    c80v10 = nil
    c80v11 = c80v0[c80v10]
    if c80v11 == nil then
      c80v11 = { EmptySlot = true }
    end
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.TRADE_MODS
    __renovice_local_0 = v27
    __renovice_local_0 = __renovice_local_0.CardFromArtifact
    __renovice_local_1 = c80v11.RawItem
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    c80v3(__renovice_local_0)
    c80v11.Card = __renovice_local_0
    __renovice_local_1 = __renovice_local_0.mDesc
    c80v11.mModDescOverride = __renovice_local_1
    __renovice_local_1 = __renovice_local_0.mInstalled
    c80v11.mModInstalledTable = __renovice_local_1
    __renovice_local_1 = _T.CheckShipModInstalled
    if __renovice_local_1 ~= nil then
      __renovice_local_1 = _T.CheckShipModInstalled
      __renovice_local_1(c80v11)
    end
    __renovice_local_1 = c80v11.Installed
    if __renovice_local_1 then
      __renovice_local_1 = true
      c80v11.Locked = __renovice_local_1
      __renovice_local_1 = true
      c80v11.HideLockIcon = __renovice_local_1
      __renovice_local_1 = c80v11.Count
      c80v12 = 1
      if c80v12 < __renovice_local_1 then
        __renovice_local_1 = mMovie
        c80v13 = "/Lotus/Language/Railjack/Inventory_EquippedWithCount"
        c80v14 = false
        c80v15 = { COUNT = nil }
        c80v16 = v24
        c80v16 = c80v16.FormatNumber
        c80v17 = 1
        c80v16 = c80v16(c80v17)
        c80v15.COUNT = c80v16
        __renovice_local_1 = __renovice_local_1:GetLocalized(c80v13, c80v14, c80v15)
        c80v11.LockedMsg = __renovice_local_1
      else
        __renovice_local_1 = "/Lotus/Language/Menu/ItemSelection_Equipped"
        c80v11.LockedMsg = __renovice_local_1
      end
    end
    __renovice_local_1 = v107
    __renovice_local_1 = __renovice_local_1.ALL
    __renovice_local_0 = {__renovice_local_1}
    c80v11.Categories = __renovice_local_0
    __renovice_local_0 = c80v11.StoreItem
    if __renovice_local_0 ~= nil then
      __renovice_local_0 = v22
      __renovice_local_0 = __renovice_local_0.GetCategoriesForShipPartStoreItem
      __renovice_local_1 = c80v11.StoreItem
      c80v12 = v107
      __renovice_local_0, __renovice_local_1 = __renovice_local_0(__renovice_local_1, c80v12)
      c80v11.Tier = __renovice_local_0
      c80v11.Brand = __renovice_local_1
      __renovice_local_0 = c80v11.Tier
      if __renovice_local_0 ~= nil then
        __renovice_local_1 = c80v11.Categories
        c80v12 = c80v11.Tier
        __renovice_local_0 = table.insert
        __renovice_local_0(__renovice_local_1, c80v12)
      end
      __renovice_local_0 = c80v11.Brand
      if __renovice_local_0 ~= nil then
        __renovice_local_1 = c80v11.Categories
        c80v12 = c80v11.Brand
        __renovice_local_0 = table.insert
        __renovice_local_0(__renovice_local_1, c80v12)
      end
    end
    __renovice_local_0 = c80v11.Type
    __renovice_local_0 = __renovice_local_0:GetFullName()
    __renovice_local_1 = c80v11.SortCategory
    c80v12 = 34
    if __renovice_local_1 == c80v12 then
      __renovice_local_1 = c80v11.RawItem
      __renovice_local_0 = __renovice_local_1:Name__c9974427()
    end
    c80v12 = _T.InvTradingInfo.State
    __renovice_local_1 = c80v12[__renovice_local_0]
    c80v13 = nil
    c80v15 = c80v11.RawItem
    c80v14 = IsNull
    c80v14 = c80v14(c80v15)
    if not c80v14 then
      c80v15 = c80v11.RawItem
      c80v15 = c80v15.Nemesis
      c80v14 = IsNull
      c80v14 = c80v14(c80v15)
      if not c80v14 then
        c80v14 = Name__b7874e81
        c80v15 = c80v11.RawItem
        c80v15 = c80v15.Nemesis
        c80v13 = c80v14(c80v15:GetFingerprint())
      else
        c80v14 = c80v11.RawItem
        c80v14 = c80v14.mItemId
        if c80v14 ~= nil then
          c80v14 = c80v11.RawItem
          c80v14 = c80v14.mItemId
          c80v13 = c80v14.mId
        end
      end
    end
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.MODS_SKIP_LIST
    if __renovice_local_0 == __renovice_local_1 then
      __renovice_local_0 = c80v11.Selected
      if __renovice_local_0 then
        __renovice_local_0 = v142
        c80v12 = nil
        c80v13 = 1
        __renovice_local_0(c80v11, c80v12, c80v13)
        __renovice_local_0 = false
        c80v11.Selected = __renovice_local_0
      end
    end
    __renovice_local_1 = c80v11.StoreItem
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(__renovice_local_1)
    if not __renovice_local_0 then
      __renovice_local_0 = c80v11.Name
      __renovice_local_1 = c80v11.Card
      if __renovice_local_1 ~= nil then
        __renovice_local_1 = c80v11.Card
        __renovice_local_0 = __renovice_local_1.mName
      end
      __renovice_local_1 = v22
      __renovice_local_1 = __renovice_local_1.GetSearchString
      c80v12 = mMovie
      c80v13 = c80v11.StoreItem
      c80v15 = c80v11.SearchTags
      __renovice_local_1 = __renovice_local_1(c80v12, c80v13, __renovice_local_0, c80v15)
      c80v11.SearchCache = __renovice_local_1
      __renovice_local_1 = v95
      c80v12 = v94
      c80v12 = c80v12.TRADE_MODS
      if __renovice_local_1 == c80v12 then
        c80v12 = c80v11.SearchCache
        c80v13 = " "
        c80v14 = ToSearchable
        c80v15 = c80v11.Card
        c80v15 = c80v15.mDesc
        c80v14 = c80v14(c80v15)
        __renovice_local_1 = c80v12 .. c80v13 .. c80v14
        c80v11.SearchCache = __renovice_local_1
      end
    else
      __renovice_local_0 = v95
      __renovice_local_1 = v94
      __renovice_local_1 = __renovice_local_1.MODS_SKIP_LIST
      if __renovice_local_0 ~= __renovice_local_1 then
        __renovice_local_0 = ""
        c80v11.SearchCache = __renovice_local_0
      end
    end
    __renovice_local_0 = v95
    __renovice_local_1 = v94
    __renovice_local_1 = __renovice_local_1.TRADE_MODS
    __renovice_local_0 = c80v11.AdditionalCategories
    __renovice_local_0 = ipairs
    __renovice_local_1 = c80v11.AdditionalCategories
    __renovice_local_0, __renovice_local_1, c80v12 = __renovice_local_0(__renovice_local_1)
    for __renovice_for_1_0, __renovice_for_1_1 in __renovice_local_0, __renovice_local_1, c80v12 do
      c80v16 = c80v11.Categories
      c80v15 = table.insert
      c80v15(c80v16, __renovice_for_1_1)
    end
    for __renovice_for_2_0, __renovice_for_2_1 in __renovice_local_0, __renovice_local_1, c80v12 do
    end
    __renovice_local_0 = true
    __renovice_local_1 = c80v11.SortCategory
    c80v12 = 26
    if __renovice_local_1 ~= c80v12 then
      __renovice_local_0 = true
      __renovice_local_1 = c80v11.SortCategory
      if __renovice_local_1 ~= 100 then
        c80v12 = c80v11.StoreItem
        __renovice_local_1 = IsNull
        __renovice_local_1 = __renovice_local_1(c80v12)
        __renovice_local_0 = not __renovice_local_1
      end
    end
    c80v11.CanPreviewOverride = __renovice_local_0
    __renovice_local_0 = v43
    c80v13 = true
    __renovice_local_0:AddElement(c80v11, c80v13)
    __renovice_local_0 = false
    c80v11.CanPreviewOverride = __renovice_local_0
    __renovice_local_0 = false
    __renovice_local_1 = v95
    c80v12 = v94
    c80v12 = c80v12.TRADE_MODS
    if __renovice_local_1 == c80v12 then
      __renovice_local_1 = v87
      if __renovice_local_1 then
        __renovice_local_1 = false
        c80v12 = c80v11.Card
        if c80v12 ~= nil then
          __renovice_local_1 = c80v11.Card
          __renovice_local_1 = __renovice_local_1.mInstalled
        end
        __renovice_local_0 = __renovice_local_1
        if __renovice_local_0 then
          __renovice_local_1 = c80v11.Count
          c80v12 = 1
          if c80v12 < __renovice_local_1 then
            __renovice_local_1 = c80v11.Count
            __renovice_local_1 = __renovice_local_1 - 1
            c80v11.Count = __renovice_local_1
            __renovice_local_0 = false
          end
        end
      end
    end
    if not __renovice_local_0 then
      __renovice_local_1 = v27
      __renovice_local_1 = __renovice_local_1.AddToCollectionGrid
      c80v12 = v43
      c80v13 = nil
      __renovice_local_1(c80v12, c80v13, c80v11)
    end
    __renovice_local_1 = v88
    if not __renovice_local_1 then
      c80v12 = v87
      __renovice_local_1 = not c80v12
      v87 = __renovice_local_1
      c80v12 = v10
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(c80v12)
      if not __renovice_local_1 then
        __renovice_local_1 = v10
        c80v13 = v87
        __renovice_local_1:SetHideEquippedInTrade(c80v13)
      end
      __renovice_local_1 = v119
      __renovice_local_1()
      __renovice_local_1 = true
      v88 = __renovice_local_1
    end
    c80v3 = v107
    c80v3 = c80v3.WARFRAME
    c80v3 = v107
    c80v3 = c80v3.WEAPONS
    c80v3 = v107
    c80v3 = c80v3.SENTINEL
    c80v3 = v107
    c80v3 = c80v3.ARCHWING
    c80v3 = v107
    c80v3 = c80v3.ARCHWINGWEAPONS
    c80v3 = v107
    c80v3 = c80v3.OPERATORAMPS
    c80v3 = v107
    c80v3 = c80v3.MECHS
    c80v3 = function(c78v0)
      local c78v1, c78v2, c78v3
      c78v1 = c78v0.mUpgrade
      if c78v1 == nil then
        c78v1 = false
        c78v0.mInstalled = c78v1
        do return end
      end
      c78v1 = c78v0.mUpgrade
      c78v1 = c78v1.mItemId
      c78v1 = c78v1:IsZero()
      if not c78v1 then
        c78v2 = v69
        c78v3 = c78v0.mUpgrade
        c78v3 = c78v3.mItemId
        c78v3 = c78v3.mId
        c78v1 = c78v2[c78v3]
        c78v0.mInstalled = c78v1
        do return end
      end
      c78v2 = c78v0.mUpgrade
      c78v2 = c78v2.mItemType
      c78v1 = tostring
      c78v1 = c78v1(c78v2:GetFullName())
      c78v2 = v69[c78v1]
      c78v0.mInstalled = c78v2
      do return end
    end
    c80v4 = function(c79v0)
      local c79v1, c79v2, c79v3
      c79v1 = c79v0.UID
      if c79v1 ~= nil then
        c79v2 = v69
        c79v3 = c79v0.UID
        c79v1 = c79v2[c79v3]
        c79v0.mInstalled = c79v1
        do return end
      end
      c79v2 = v69
      c79v3 = c79v0.FullName
      c79v1 = c79v2[c79v3]
      c79v0.mInstalled = c79v1
      do return end
    end
    c80v5 = nil
    c80v6 = {}
    c80v7 = v95
    c80v8 = v94
    c80v8 = c80v8.SHIP_SCRAP
    c80v7 = gGameData
    c80v5 = c80v7:Name__70dd6cf8()
    c80v9 = 1
    c80v7 = #c80v5
    c80v8 = 1
    for __renovice_for_3_0 = c80v9, c80v7, c80v8 do
      c80v10 = v23
      c80v10 = c80v10.GetResearchProgress
      c80v11 = c80v5[__renovice_for_3_0]
      c80v10 = c80v10(c80v11)
      c80v11 = 0
      if c80v10 <= c80v11 then
        continue
      end
      c80v10 = c80v5[__renovice_for_3_0]
      c80v10 = c80v10.mCategoryItemId
      c80v10 = c80v10.mId
      c80v11 = true
      c80v6[c80v10] = c80v11
    end
    c80v3 = v129
    c80v3 = c80v3()
    if not c80v3 then
      c80v3 = ""
      c80v4 = v107
      c80v4 = c80v4.WARFRAME
      if c80v1 == c80v4 then
        c80v4 = WeakResource
        c80v5 = "/Lotus/Types/StoreItems/SlotItems/SuitSlotItem"
        c80v3 = c80v4(c80v5)
      else
        c80v4 = v107
        c80v4 = c80v4.WEAPONS
        if c80v1 == c80v4 then
          c80v4 = WeakResource
          c80v5 = "/Lotus/Types/StoreItems/SlotItems/TwoWeaponSlotItem"
          c80v3 = c80v4(c80v5)
        else
          c80v4 = v107
          c80v4 = c80v4.SENTINEL
          if c80v1 == c80v4 then
            c80v4 = WeakResource
            c80v5 = "/Lotus/Types/StoreItems/SlotItems/TwoSentinelSlotItem"
            c80v3 = c80v4(c80v5)
          else
            c80v4 = v107
            c80v4 = c80v4.ARCHWING
            if c80v1 == c80v4 then
              c80v4 = WeakResource
              c80v5 = "/Lotus/Types/StoreItems/SlotItems/SpaceSuitSlotItem"
              c80v3 = c80v4(c80v5)
            else
              c80v4 = v107
              c80v4 = c80v4.ARCHWINGWEAPONS
              if c80v1 == c80v4 then
                c80v4 = WeakResource
                c80v5 = "/Lotus/Types/StoreItems/SlotItems/TwoSpaceWeaponSlotItem"
                c80v3 = c80v4(c80v5)
              else
                c80v4 = v107
                c80v4 = c80v4.OPERATORAMPS
                if c80v1 == c80v4 then
                  c80v4 = WeakResource
                  c80v5 = "/Lotus/Types/StoreItems/SlotItems/TwoOperatorWeaponSlotItem"
                  c80v3 = c80v4(c80v5)
                else
                  c80v4 = v107
                  c80v4 = c80v4.MECHS
                  if c80v1 == c80v4 then
                    c80v4 = WeakResource
                    c80v5 = "/Lotus/Types/StoreItems/SlotItems/MechSlotItem"
                    c80v3 = c80v4(c80v5)
                  end
                end
              end
            end
          end
        end
      end
      c80v5 = v5
      c80v4 = IsNull
      c80v4 = c80v4(c80v5)
      if (not c80v4 and c80v2 ~= nil) then
        c80v4 = v5
        c80v4 = c80v4:Name__1dc35bd2(c80v3)
        c80v5 = IsNull
        c80v5 = c80v5(c80v4)
        if not c80v5 then
          c80v5 = v22
          c80v5 = c80v5.GetStoreItemInfo
          c80v6 = mMovie
          c80v5 = c80v5(c80v6, c80v4)
          c80v6 = slotPurchaseTexture
          c80v5.Icon = c80v6
          c80v6 = 9
          c80v5.IconColor = c80v6
          c80v6 = 100
          c80v5.IconWidth = c80v6
          c80v6 = 100
          c80v5.IconHeight = c80v6
          c80v6 = true
          c80v5.BuySlot = c80v6
          c80v5.EmptyCount = c80v2
          c80v5.Count = c80v2
          c80v6 = table.insert
          c80v6(c80v0, c80v5)
          c80v2 = 0
        end
      end
    end
    c80v8 = #c80v0
    c80v9 = v24
    c80v9 = c80v9.Ternary
    if c80v2 ~= nil then
      c80v10 = false
    else
      c80v10 = true
    end
    c80v11 = 0
    c80v9 = c80v9(c80v10, c80v11, c80v2)
    c80v7 = c80v8 + c80v9
    c80v10 = 1
    c80v8 = c80v7
    c80v9 = 1
    do return end
  end
  v163 = function(c81v0)
    local c81v1, c81v2, c81v3, c81v4, c81v5, c81v6, c81v7, c81v8, c81v9, c81v10, c81v11, c81v12, c81v13, c81v14
    local __renovice_local_0 = v95
    c81v2 = v94
    c81v2 = c81v2.SHARDS
    if __renovice_local_0 == c81v2 then
      __renovice_local_0 = _T.GetShards
      c81v1 = __renovice_local_0()
      do return c81v1 end
    end
    __renovice_local_0 = v95
    c81v2 = v94
    c81v2 = c81v2.SYNDDONATE
    if __renovice_local_0 == c81v2 then
      c81v1 = {}
      __renovice_local_0 = _T.SyndicateInvInfo.Syndicate
      __renovice_local_0 = __renovice_local_0:GetStandingBonuses()
      c81v2 = _T.SyndicateInvInfo.VendorTag
      c81v3 = ipairs
      c81v3, c81v4, c81v5 = c81v3(__renovice_local_0)
      for __renovice_for_0_0, __renovice_for_0_1 in c81v3, c81v4, c81v5 do
        repeat
          c81v8 = __renovice_for_0_1.mTag
          c81v9 = EMPTY_SYMBOL
          if c81v8 ~= c81v9 then
            c81v8 = __renovice_for_0_1.mTag
            if c81v8 ~= c81v2 then break end
          end
          c81v8 = table.insert
          c81v8(c81v1, __renovice_for_0_1)
        until true
      end
      do return c81v1 end
    end
    __renovice_local_0 = v95
    c81v2 = v94
    c81v2 = c81v2.SHIP_RAW
    if __renovice_local_0 == c81v2 then
      __renovice_local_0 = v72
      c81v1 = __renovice_local_0:GetCrewShipRawSalvage()
      do return c81v1 end
    end
    __renovice_local_0 = 43
    if c81v0 == __renovice_local_0 then
      __renovice_local_0 = v24
      __renovice_local_0 = __renovice_local_0.Ternary
      c81v3 = v95
      c81v4 = v94
      c81v4 = c81v4.SHIP_SCRAP
      if c81v3 ~= c81v4 then
        c81v2 = false
      else
        c81v2 = true
      end
      c81v3 = v72
      c81v3 = c81v3:GetCrewShipSalvagedWeapons()
      c81v4 = v72
      c81v1 = __renovice_local_0(c81v2, c81v3, c81v4:GetCrewShipWeapons())
      do return c81v1 end
    end
    __renovice_local_0 = 46
    if c81v0 == __renovice_local_0 then
      __renovice_local_0 = v24
      __renovice_local_0 = __renovice_local_0.Ternary
      c81v3 = v95
      c81v4 = v94
      c81v4 = c81v4.SHIP_SCRAP
      if c81v3 ~= c81v4 then
        c81v2 = false
      else
        c81v2 = true
      end
      c81v3 = v72
      c81v3 = c81v3:GetCrewShipSalvagedWeaponSkins()
      c81v4 = v72
      c81v1 = __renovice_local_0(c81v2, c81v3, c81v4:GetCrewShipWeaponSkins())
      do return c81v1 end
    end
    __renovice_local_0 = 0
    if c81v0 == __renovice_local_0 then
      __renovice_local_0 = v72
      c81v1 = __renovice_local_0:GetPistols()
      do return c81v1 end
    end
    __renovice_local_0 = 1
    if c81v0 == __renovice_local_0 then
      __renovice_local_0 = v72
      c81v1 = __renovice_local_0:GetLongGuns()
      do return c81v1 end
    end
    __renovice_local_0 = 2
    if c81v0 == __renovice_local_0 then
      __renovice_local_0 = v72
      c81v1 = __renovice_local_0:GetConsumables()
      do return c81v1 end
    end
    __renovice_local_0 = 3
    if c81v0 == __renovice_local_0 then
      __renovice_local_0 = v72
      c81v1 = __renovice_local_0:GetSuits()
      __renovice_local_0 = v0
      if not __renovice_local_0 then
        c81v3 = #c81v1
        __renovice_local_0 = 1
        c81v2 = -1
        for __renovice_for_1_0 = c81v3, __renovice_local_0, c81v2 do
          c81v4 = c81v1[__renovice_for_1_0]
          c81v5 = c81v4.mItemType
          c81v6 = excaliburUmbraType
          if c81v5 ~= c81v6 then
            continue
          end
          c81v5 = table.remove
          c81v5(c81v1, __renovice_for_1_0)
        end
        do return c81v1 end
      end
    else
      __renovice_local_0 = 5
      if c81v0 == __renovice_local_0 then
        __renovice_local_0 = v72
        c81v1 = __renovice_local_0:GetMelee()
        __renovice_local_0 = v1
        if not __renovice_local_0 then
          c81v3 = #c81v1
          __renovice_local_0 = 1
          c81v2 = -1
          for __renovice_for_2_0 = c81v3, __renovice_local_0, c81v2 do
            c81v4 = c81v1[__renovice_for_2_0]
            c81v5 = c81v4.mItemType
            c81v6 = excaliburUmbraMeleeType
            if c81v5 ~= c81v6 then
              continue
            end
            c81v5 = table.remove
            c81v5(c81v1, __renovice_for_2_0)
          end
          do return c81v1 end
        end
      else
        __renovice_local_0 = 6
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetWeaponSkins()
          do return c81v1 end
        end
        __renovice_local_0 = 11
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v95
          c81v2 = v94
          c81v2 = c81v2.RESDONATE
          if __renovice_local_0 == c81v2 then
            c81v2 = v5
            __renovice_local_0 = IsNull
            __renovice_local_0 = __renovice_local_0(c81v2)
            if not __renovice_local_0 then
              c81v1 = {}
              __renovice_local_0 = v5
              __renovice_local_0 = __renovice_local_0:GetStoreItems()
              c81v2 = v72
              c81v2 = c81v2:GetMiscItems()
              c81v3 = {}
              c81v6 = 1
              c81v4 = #c81v2
              c81v5 = 1
              for __renovice_for_3_0 = c81v6, c81v4, c81v5 do
                c81v7 = c81v2[__renovice_for_3_0]
                c81v8 = c81v7.mItemType
                c81v8 = c81v8:GetFullName()
                c81v9 = true
                c81v3[c81v8] = c81v9
                c81v8 = table.insert
                c81v8(c81v1, c81v7)
              end
              c81v6 = 1
              c81v4 = #__renovice_local_0
              c81v5 = 1
              for __renovice_for_4_0 = c81v6, c81v4, c81v5 do
                c81v7 = __renovice_local_0[__renovice_for_4_0]
                c81v8 = c81v7:ShowInMarket()
                if not c81v8 then
                  continue
                end
                c81v9 = c81v7:GetItem()
                c81v9 = c81v9:GetFullName()
                c81v8 = c81v3[c81v9]
                if c81v8 ~= nil then
                  continue
                end
                c81v10 = Lotus_Game.CountedItem
                c81v11 = c81v7:GetItem()
                c81v12 = 0
                c81v8 = table.insert
                c81v8(c81v1, c81v10(c81v11, c81v12))
              end
              do return c81v1 end
            end
          end
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetMiscItems()
          do return c81v1 end
        end
        __renovice_local_0 = 4
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v95
          c81v2 = v94
          c81v2 = c81v2.MODS_SKIP_LIST
          if __renovice_local_0 == c81v2 then
            c81v1 = _T.InvModSkipListSelection.Elements
            do return c81v1 end
          end
          __renovice_local_0 = v72
          __renovice_local_0 = __renovice_local_0:GetRawUpgrades()
          c81v2 = v72
          c81v2 = c81v2:GetUpgrades()
          c81v1 = {}
          c81v3 = {__renovice_local_0, c81v2}
          c81v6 = 1
          c81v4 = #c81v3
          c81v5 = 1
          for __renovice_for_5_0 = c81v6, c81v4, c81v5 do
            c81v7 = pairs
            c81v8 = c81v3[__renovice_for_5_0]
            c81v7, c81v8, c81v9 = c81v7(c81v8)
            for __renovice_for_6_0, __renovice_for_6_1 in c81v7, c81v8, c81v9 do
              c81v12 = __renovice_for_6_1.mItemType
              c81v14 = v2
              c81v12 = c81v12:IsA(c81v14)
              if not c81v12 then
                c81v12 = __renovice_for_6_1.mItemType
                c81v14 = v3
                c81v12 = c81v12:IsA(c81v14)
              end
              repeat
                c81v13 = v95
                c81v14 = v94
                c81v14 = c81v14.TRADE_MODS
                if (c81v13 ~= c81v14 or c81v12) then
                  c81v13 = v95
                  c81v14 = v94
                  c81v14 = c81v14.TRADE_MODS
                  if (c81v13 == c81v14 or not c81v12) then break end
                end
                c81v13 = table.insert
                c81v13(c81v1, __renovice_for_6_1)
              until true
            end
          end
          do return c81v1 end
        end
        __renovice_local_0 = 13
        if c81v0 == __renovice_local_0 then
          c81v1 = {}
          __renovice_local_0 = v72
          __renovice_local_0 = __renovice_local_0:GetRecipes()
          c81v2 = WeakResource
          c81v3 = "/Lotus/Types/Recipes/AbilityOverrides/BaseAbilityOverrideBlueprint"
          c81v2 = c81v2(c81v3)
          c81v5 = 1
          c81v3 = #__renovice_local_0
          c81v4 = 1
          for __renovice_for_7_0 = c81v5, c81v3, c81v4 do
            c81v6 = __renovice_local_0[__renovice_for_7_0]
            c81v6 = c81v6.mItemType
            c81v6 = c81v6:IsA(c81v2)
            if c81v6 then
              continue
            end
            c81v8 = __renovice_local_0[__renovice_for_7_0]
            c81v6 = table.insert
            c81v6(c81v1, c81v8)
          end
          do return c81v1 end
        end
        __renovice_local_0 = 15
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetSentinels()
          do return c81v1 end
        end
        __renovice_local_0 = 24
        if c81v0 == __renovice_local_0 then
          c81v1 = {}
          __renovice_local_0 = v72
          __renovice_local_0 = __renovice_local_0:GetKubrowPets()
          c81v4 = 1
          c81v2 = #__renovice_local_0
          c81v3 = 1
          for __renovice_for_8_0 = c81v4, c81v2, c81v3 do
            c81v5 = __renovice_local_0[__renovice_for_8_0]
            c81v5 = c81v5.mDetails
            c81v5 = c81v5.mStatus
            c81v6 = 0
            if c81v5 == c81v6 then
              continue
            end
            c81v5 = __renovice_local_0[__renovice_for_8_0]
            c81v5 = c81v5.mDetails
            c81v5 = c81v5.mStatus
            c81v6 = 1
            if c81v5 == c81v6 then
              continue
            end
            c81v7 = __renovice_local_0[__renovice_for_8_0]
            c81v5 = table.insert
            c81v5(c81v1, c81v7)
          end
          do return c81v1 end
        end
        __renovice_local_0 = 16
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetSentinelWeapons()
          do return c81v1 end
        end
        __renovice_local_0 = 17
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetLevelKeys()
          do return c81v1 end
        end
        __renovice_local_0 = 18
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetDrones()
          do return c81v1 end
        end
        __renovice_local_0 = 27
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetSpaceSuits()
          do return c81v1 end
        end
        __renovice_local_0 = 28
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetSpaceGuns()
          do return c81v1 end
        end
        __renovice_local_0 = 29
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetSpaceMelee()
          do return c81v1 end
        end
        __renovice_local_0 = 48
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetMechSuits()
          do return c81v1 end
        end
        __renovice_local_0 = 34
        if c81v0 == __renovice_local_0 then
          c81v1 = {}
          __renovice_local_0 = v22
          __renovice_local_0 = __renovice_local_0.BuildTreasureTable
          c81v2 = v72
          c81v2 = c81v2:GetFusionTreasures()
          c81v3 = mMovie
          c81v4 = v5
          c81v5 = v109
          c81v6 = true
          c81v8 = v95
          c81v9 = v94
          c81v9 = c81v9.TREASURE
          if c81v8 ~= c81v9 then
            c81v7 = false
          else
            c81v7 = true
          end
          __renovice_local_0 = __renovice_local_0(c81v2, c81v3, c81v4, c81v5, c81v6, c81v7)
          c81v2 = pairs
          c81v2, c81v3, c81v4 = c81v2(__renovice_local_0)
          for __renovice_for_9_0, __renovice_for_9_1 in c81v2, c81v3, c81v4 do
            c81v7 = __renovice_for_9_1.Type
            __renovice_for_9_1.mItemType = c81v7
            c81v7 = table.insert
            c81v7(c81v1, __renovice_for_9_1)
          end
          do return c81v1 end
        end
        __renovice_local_0 = 39
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetMoaPets()
          do return c81v1 end
        end
        __renovice_local_0 = 25
        if c81v0 == __renovice_local_0 then
          do return c81v1 end
        end
        __renovice_local_0 = 26
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetKubrowPetPrints()
          do return c81v1 end
        end
        __renovice_local_0 = 37
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetOperatorAmps()
          do return c81v1 end
        end
        __renovice_local_0 = 30
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v22
          __renovice_local_0 = __renovice_local_0.GetShipDecoItems
          c81v2 = mMovie
          c81v3 = gGameData
          c81v4 = false
          c81v5 = true
          c81v1 = __renovice_local_0(c81v2, c81v3, c81v4, c81v5)
          do return c81v1 end
        end
        __renovice_local_0 = 41
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetHoverboards()
          do return c81v1 end
        end
        __renovice_local_0 = 50
        if c81v0 == __renovice_local_0 then
          __renovice_local_0 = v72
          c81v1 = __renovice_local_0:GetHorses()
          do return c81v1 end
        end
        __renovice_local_0 = 10
        if c81v0 == __renovice_local_0 then
          c81v1 = {}
          __renovice_local_0 = v72
          __renovice_local_0 = __renovice_local_0:GetFlavourItems()
          c81v4 = 1
          c81v2 = #__renovice_local_0
          c81v3 = 1
          for __renovice_for_10_0 = c81v4, c81v2, c81v3 do
            c81v5 = __renovice_local_0[__renovice_for_10_0]
            c81v5 = c81v5.mItemType
            c81v7 = gEmoteType
            c81v5 = c81v5:IsA(c81v7)
            if not c81v5 then
              continue
            end
            c81v7 = __renovice_local_0[__renovice_for_10_0]
            c81v5 = table.insert
            c81v5(c81v1, c81v7)
          end
          do return c81v1 end
        end
        if c81v0 == 100 then
          c81v2 = gGameData
          __renovice_local_0 = IsNull
          __renovice_local_0 = __renovice_local_0(c81v2)
          if not __renovice_local_0 then
            __renovice_local_0 = gGameData
            __renovice_local_0 = __renovice_local_0:GetNemesisHistory()
            c81v4 = 1
            c81v2 = #__renovice_local_0
            c81v3 = 1
            for __renovice_for_11_0 = c81v4, c81v2, c81v3 do
              c81v5 = __renovice_local_0[__renovice_for_11_0]
              c81v6 = c81v5.mKilled
              if c81v6 then
                continue
              end
              c81v6 = c81v5.mTraded
              if c81v6 then
                continue
              end
              c81v6 = c81v5.mNumPreviousOwners
              c81v7 = 1
              if c81v7 <= c81v6 then
                continue
              end
              if c81v1 == nil then
                c81v1 = {}
              end
              c81v6 = v29
              c81v6 = c81v6.GenerateProfile
              c81v6 = c81v6(c81v5)
              c81v7 = v29
              c81v7 = c81v7.GetFactionIdFromAgent
              c81v7 = c81v7(c81v6)
              c81v9 = 2
              c81v8 = c81v9 + 1
              if c81v7 == c81v8 then
                c81v8 = v29
                c81v8 = c81v8.GetAgentIdxFromAgent
                c81v8 = c81v8(c81v6)
                c81v11 = { Nemesis = nil, mItemType = nil }
                c81v11.Nemesis = c81v5
                c81v12 = infestedLichItems[c81v8]
                c81v11.mItemType = c81v12
                c81v9 = table.insert
                c81v9(c81v1, c81v11)
                continue
              end
              c81v10 = { Nemesis = nil, mItemType = nil }
              c81v10.Nemesis = c81v5
              c81v11 = lichItems[c81v7]
              c81v10.mItemType = c81v11
              c81v8 = table.insert
              c81v8(c81v1, c81v10)
            end
          end
        end
      end
    end
    do return c81v1 end
  end
  v164 = function(c82v0, c82v1, c82v2)
    local c82v3, c82v4, c82v5
    c82v3 = v74[c82v0]
    if c82v3 == nil then
      c82v3 = v74
      c82v4 = { Category = nil, Elements = nil }
      c82v4.Category = c82v1
      c82v5 = {}
      c82v4.Elements = c82v5
      c82v3[c82v0] = c82v4
    end
    c82v4 = v74[c82v0]
    c82v4 = c82v4.Elements
    c82v3 = table.insert
    c82v3(c82v4, c82v2)
    do return end
  end
  v165 = function()
    local c84v0, c84v1, c84v2, c84v3, c84v4, c84v5, c84v6
    c84v1 = v43
    c84v0 = IsNull
    c84v0 = c84v0(c84v1)
    if not c84v0 then
      c84v1 = gGameData
      c84v0 = IsNull
      c84v0 = c84v0(c84v1)
      if not c84v0 then
        c84v0 = gGameData
        c84v0 = c84v0:GetInventory()
        c84v1 = gGameRules
        c84v1 = c84v1:GetStoreManifest()
        c84v2 = v22
        c84v2 = c84v2.GetPurchasedItems
        c84v4 = nil
        c84v5 = false
        c84v6 = mMovie
        c84v2 = c84v2(c84v1, c84v0, c84v4, c84v5, c84v6)
        c84v3 = v43
        c84v4 = function(c83v0)
          local c83v1, c83v2, c83v3, c83v4, c83v5, c83v6
          c83v2 = c83v0.ArcaneRank
          if c83v2 == nil then
            c83v1 = false
          else
            c83v1 = true
          end
          if c83v1 then
            c83v2 = v23
            c83v2 = c83v2.GetNumOwned
            c83v3 = gGameData
            c83v4 = c84v0
            c83v5 = c83v0.StoreItem
            c83v6 = c84v2
            c83v2 = c83v2(c83v3, c83v4, c83v5, c83v6, c83v1)
            c83v0.CountTable = c83v2
          end
          do return end
        end
        c84v3:RunForAllElements(c84v4)
        do return end
      end
    end
    do return end
  end
  v113 = function()
    local c86v0, c86v1, c86v2, c86v3, c86v4, c86v5, c86v6, c86v7, c86v8, c86v9, c86v10, c86v11, c86v12, c86v13, c86v14
    c86v0 = 0
    c86v1 = nil
    c86v2 = nil
    c86v3 = nil
    local __renovice_local_0 = v71
    __renovice_local_0 = v71
    local __renovice_local_1 = _T.InventorySelection
    local __renovice_local_2 = _T.InventorySelection
    __renovice_local_1 = #__renovice_local_2
    __renovice_local_2 = 0
    __renovice_local_2 = ipairs
    local __renovice_local_3 = v43
    __renovice_local_3 = __renovice_local_3.mElements
    c86v4 = nil
    __renovice_local_2, __renovice_local_3, c86v4 = __renovice_local_2(__renovice_local_3)
    for __renovice_for_0_0, __renovice_for_0_1 in __renovice_local_2, __renovice_local_3, c86v4 do
      c86v9 = 1
      c86v7 = __renovice_local_1
      c86v8 = 1
      c86v10 = __renovice_for_0_1.Type
      c86v12 = _T.InventorySelection
      c86v11 = c86v12[c86v9]
      c86v11 = c86v11.CountedItem
      c86v11 = c86v11.mItemType
      if c86v10 == c86v11 then
        c86v10 = v142
        c86v12 = false
        c86v14 = _T.InventorySelection
        c86v13 = c86v14[c86v9]
        c86v13 = c86v13.NumSelected
        c86v10(__renovice_for_0_1, c86v12, c86v13)
      end
      __renovice_local_0 = v43
      __renovice_local_0 = __renovice_local_0.mSortBy
      local __renovice_state_0 = 244
      __renovice_local_1 = v46
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(__renovice_local_1)
      if __renovice_local_0 then
      else
        __renovice_state_0 = 245
      end
      if __renovice_state_0 == 245 then
        __renovice_local_0 = mMovie
        __renovice_local_0 = __renovice_local_0:GetMovieType()
        __renovice_local_1 = v46
        __renovice_local_1 = __renovice_local_1:Name__88fc5d98(__renovice_local_0)
        __renovice_local_2 = v95
        __renovice_local_3 = v94
        __renovice_local_3 = __renovice_local_3.DECODONATE
        if __renovice_local_2 == __renovice_local_3 then
          __renovice_state_0 = 247
        else
          __renovice_state_0 = 246
        end
      end
      if __renovice_state_0 == 246 then
        __renovice_local_2 = v95
        __renovice_local_3 = v94
        __renovice_local_3 = __renovice_local_3.RESDONATE
        if __renovice_local_2 ~= __renovice_local_3 then
          __renovice_state_0 = 248
        else
          __renovice_state_0 = 247
        end
      end
      if __renovice_state_0 == 247 then
        __renovice_local_1 = "COUNT"
        __renovice_local_2 = v43
        __renovice_local_2:SetSortBy(__renovice_local_1)
      end
      if __renovice_state_0 == 248 then
        __renovice_local_2 = v95
        __renovice_local_3 = v94
        __renovice_local_3 = __renovice_local_3.SYNDDONATE
        if __renovice_local_2 == __renovice_local_3 then
        else
          __renovice_state_0 = 249
        end
      end
      if __renovice_state_0 == 249 then
        __renovice_local_2 = false
        __renovice_for_0_0 = 1
        __renovice_for_0_1 = v43
        __renovice_for_0_1 = __renovice_for_0_1.mSortMenu
        __renovice_local_3 = __renovice_for_0_1:GetHowManyElements()
        c86v4 = 1
        local __renovice_fornprep_zero_0 = 0
        if __renovice_fornprep_zero_0 < c86v4 then
          if __renovice_local_3 < __renovice_for_0_0 then
            __renovice_state_0 = 254
          else
            __renovice_state_0 = 250
          end
        else
          __renovice_fornprep_zero_0 = 0
          if c86v4 < __renovice_fornprep_zero_0 then
            if __renovice_for_0_0 < __renovice_local_3 then
              __renovice_state_0 = 254
            else
              __renovice_state_0 = 250
            end
          else
            __renovice_state_0 = 250
          end
        end
      end
      if __renovice_state_0 == 250 then
        __renovice_for_0_1 = v43
        __renovice_for_0_1 = __renovice_for_0_1.mSortMenu
        __renovice_for_0_1 = __renovice_for_0_1:GetElementInIndex(__renovice_for_0_0)
        c86v7 = IsNull
        c86v7 = c86v7(__renovice_for_0_1)
        if c86v7 then
          __renovice_state_0 = 253
        else
          __renovice_state_0 = 251
        end
      end
      if __renovice_state_0 == 251 then
        c86v7 = __renovice_for_0_1.SortId
        if c86v7 ~= __renovice_local_1 then
          __renovice_state_0 = 253
        else
          __renovice_state_0 = 252
        end
      end
      if __renovice_state_0 == 252 then
        __renovice_local_2 = true
        __renovice_state_0 = 254
      end
      if __renovice_state_0 == 253 then
        __renovice_state_0 = 254
      end
      if __renovice_state_0 == 254 then
        if __renovice_local_2 then
          __renovice_state_0 = 256
        else
          __renovice_state_0 = 255
        end
      end
      if __renovice_state_0 == 255 then
        __renovice_local_1 = "NAME"
        __renovice_state_0 = 256
      end
      if __renovice_state_0 == 256 then
        __renovice_local_3 = v43
        __renovice_local_3:SetSortBy(__renovice_local_1)
      end
      for __renovice_for_1_0 = __renovice_for_0_0, __renovice_local_3, c86v4 do
      end
      __renovice_local_0 = v85
      if not __renovice_local_0 then
        __renovice_local_0 = v95
        __renovice_local_1 = v94
        __renovice_local_1 = __renovice_local_1.ARCANE
        if __renovice_local_0 == __renovice_local_1 then
          __renovice_local_1 = arcaneTransmissionSet
          __renovice_local_0 = IsNull
          __renovice_local_0 = __renovice_local_0(__renovice_local_1)
          if not __renovice_local_0 then
            __renovice_local_1 = _T.PlayBackgroundTransmission
            __renovice_local_0 = IsNull
            __renovice_local_0 = __renovice_local_0(__renovice_local_1)
            if not __renovice_local_0 then
              __renovice_local_1 = v43
              __renovice_local_1 = __renovice_local_1.mUnfilteredElements
              __renovice_local_0 = #__renovice_local_1
              if __renovice_local_0 == 0 then
                __renovice_local_0 = _T.PlayBackgroundTransmission
                __renovice_local_1 = "ArcaneNoValid"
                __renovice_local_2 = arcaneTransmissionSet
                __renovice_local_3 = 3
                __renovice_local_0(__renovice_local_1, __renovice_local_2, __renovice_local_3)
              else
                __renovice_local_0 = _T.PlayBackgroundTransmission
                __renovice_local_1 = "ArcaneSelect"
                __renovice_local_2 = arcaneTransmissionSet
                __renovice_local_3 = 3
                __renovice_local_0(__renovice_local_1, __renovice_local_2, __renovice_local_3)
              end
            end
          end
        end
        __renovice_local_0 = true
        v85 = __renovice_local_0
      end
      __renovice_local_0 = v24
      __renovice_local_0 = __renovice_local_0.Ternary
      __renovice_local_2 = v90
      if __renovice_local_2 ~= nil then
        __renovice_local_1 = false
      else
        __renovice_local_1 = true
      end
      __renovice_local_2 = v107
      __renovice_local_2 = __renovice_local_2.ALL
      __renovice_local_3 = v90
      __renovice_local_0 = __renovice_local_0(__renovice_local_1, __renovice_local_2, __renovice_local_3)
      __renovice_local_1 = v90
      if __renovice_local_1 == nil then
        __renovice_local_1 = _T.InvTest_CatToSelect
        if __renovice_local_1 ~= nil then
          __renovice_local_1 = _T.InvTest_CatToSelect
          if __renovice_local_1 == "LICH" then
            __renovice_local_0 = v107.LICH
          end
          __renovice_local_1 = _T
          __renovice_local_2 = nil
          __renovice_local_1.InvTest_CatToSelect = __renovice_local_2
        end
      end
      v43.mFilterBy = __renovice_local_0
      __renovice_local_1 = v43
      __renovice_local_3 = function()
        local c85v0, c85v1, c85v2
        c85v0 = false
        v40 = c85v0
        local __renovice_local_0 = v47
        c85v1 = v110
        c85v1 = c85v1.TUTORIAL
        c85v0 = __renovice_local_0[c85v1]
        c85v1 = v95
        c85v2 = v94
        c85v2 = c85v2.PRIMEPARTS
        if c85v1 ~= c85v2 then
          __renovice_local_0 = false
        else
          __renovice_local_0 = true
        end
        c85v0.mVisible = __renovice_local_0
        c85v0 = false
        __renovice_local_0 = v95
        c85v1 = v94
        c85v1 = c85v1.FISH
        if __renovice_local_0 == c85v1 then
          c85v1 = v47
          c85v2 = v110
          c85v2 = c85v2.FISH_CATEGORY
          __renovice_local_0 = c85v1[c85v2]
          c85v1 = true
          __renovice_local_0.mVisible = c85v1
          c85v0 = true
        end
        c85v1 = v47
        c85v2 = v110
        c85v2 = c85v2.EXIT
        __renovice_local_0 = c85v1[c85v2]
        __renovice_local_0 = __renovice_local_0.mVisible
        if not __renovice_local_0 then
          c85v1 = v47
          c85v2 = v110
          c85v2 = c85v2.EXIT
          __renovice_local_0 = c85v1[c85v2]
          c85v1 = true
          __renovice_local_0.mVisible = c85v1
          c85v0 = true
        end
        if c85v0 then
          __renovice_local_0 = v119
          __renovice_local_0()
        end
        __renovice_local_0 = v95
        c85v1 = v94
        c85v1 = c85v1.SYNDDONATE
        if __renovice_local_0 == c85v1 then
          __renovice_local_0 = v43
          c85v2 = "SELL_PRICE"
          __renovice_local_0:SetSortBy(c85v2)
        end
        do return end
      end
      c86v4 = true
      __renovice_local_1:Redraw(__renovice_local_3, c86v4)
      __renovice_local_1 = mMovie
      __renovice_local_3 = "SearchAndSort.SearchBox"
      c86v4 = 13
      __renovice_for_0_0 = true
      __renovice_local_1:Name__d9713943(__renovice_local_3, c86v4, __renovice_for_0_0)
      __renovice_local_1 = mMovie
      __renovice_local_3 = v43
      __renovice_local_3 = __renovice_local_3.mCategoryClipName
      c86v4 = 13
      __renovice_for_0_0 = true
      __renovice_local_1:Name__d9713943(__renovice_local_3, c86v4, __renovice_for_0_0)
      __renovice_local_1 = mMovie
      __renovice_local_3 = v43
      __renovice_local_3 = __renovice_local_3.mSortClipName
      c86v4 = 12
      __renovice_for_0_0 = 100
      __renovice_local_1:SetNumberVariable(__renovice_local_3, c86v4, __renovice_for_0_0)
      __renovice_local_1 = v95
      __renovice_local_2 = v94
      __renovice_local_2 = __renovice_local_2.FISH
    end
    if __renovice_local_0 ~= 1 then
      __renovice_local_1 = v165
      __renovice_local_1()
      __renovice_local_1 = v57
      __renovice_local_3 = false
      __renovice_local_1:SetActive(__renovice_local_3)
      __renovice_local_1 = nil
      v71 = __renovice_local_1
      __renovice_local_1 = {}
      v74 = __renovice_local_1
      __renovice_local_1 = print
      __renovice_local_2 = "PopulateGrid complete"
      __renovice_local_1(__renovice_local_2)
      do return end
    end
    __renovice_local_2 = gGameData
    __renovice_local_1 = IsNull
    __renovice_local_1 = __renovice_local_1(__renovice_local_2)
    if not __renovice_local_1 then
      __renovice_local_0 = gGameData
      __renovice_local_0 = __renovice_local_0:Name__1d1bb34a()
    else
      __renovice_local_0 = 1
    end
    while true do
      __renovice_local_1 = 75
      if __renovice_local_1 <= c86v0 then break end
      __renovice_local_2 = v75
      __renovice_local_2 = __renovice_local_2.Elements
      __renovice_local_1 = #__renovice_local_2
      __renovice_local_2 = 0
      __renovice_local_2 = v73
      __renovice_local_1 = #__renovice_local_2
      __renovice_local_2 = 0
      if __renovice_local_1 <= __renovice_local_2 then break end
      __renovice_local_1 = 75
      __renovice_local_1 = ResetLineCount
      __renovice_local_1()
      __renovice_local_1 = table.remove
      __renovice_local_2 = v75
      __renovice_local_2 = __renovice_local_2.Elements
      c86v2 = __renovice_local_1(__renovice_local_2)
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(c86v2)
      c86v0 = c86v0 + 1
      __renovice_local_2 = c86v2.mItemType
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(__renovice_local_2)
      __renovice_local_1 = v129
      __renovice_local_1 = __renovice_local_1()
      __renovice_local_1 = c86v3:IsTradeable()
      __renovice_local_1 = nil
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.MODS_SKIP_LIST
      __renovice_local_1 = c86v2
      __renovice_local_3 = __renovice_local_1.RawItem
      __renovice_local_2 = IsNull
      __renovice_local_2 = __renovice_local_2(__renovice_local_3)
      __renovice_local_2 = __renovice_local_1.RawItem
      __renovice_local_2 = __renovice_local_2.mItemType
      c86v4 = v2
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = __renovice_local_1.RawItem
      __renovice_local_2 = __renovice_local_2.mItemType
      c86v4 = v3
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = __renovice_local_1.Count
      __renovice_local_2 = __renovice_local_1.Count
      __renovice_local_3 = 0
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.DECODONATE
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.RESDONATE
      __renovice_local_2 = 0
      __renovice_local_2 = 1
      __renovice_local_2 = 2
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 27
      __renovice_local_2 = v129
      __renovice_local_2 = __renovice_local_2()
      __renovice_local_2 = _T.InvTradingInfo
      __renovice_local_2 = _T.InvTradingInfo.ForDisplay
      __renovice_local_2 = c86v3:GetRequiredLevel()
      __renovice_local_3 = _T.InvTradingInfo.PartnerMR
      __renovice_local_2 = true
      __renovice_local_1.Locked = __renovice_local_2
      __renovice_local_2 = "/Lotus/Language/Dojo/Trade_PartnerMRLocked"
      __renovice_local_1.LockedMsg = __renovice_local_2
      __renovice_local_2 = 1
      __renovice_local_2 = 4
      __renovice_local_2 = 2
      __renovice_local_3 = __renovice_local_1.RawItem
      __renovice_local_2 = IsNull
      __renovice_local_2 = __renovice_local_2(__renovice_local_3)
      __renovice_local_2 = __renovice_local_1.RawItem
      __renovice_local_2 = __renovice_local_2:CanTrade()
      __renovice_local_2 = true
      __renovice_local_1.Locked = __renovice_local_2
      __renovice_local_2 = "/Lotus/Language/Dojo/Trade_Untradeable"
      __renovice_local_1.LockedMsg = __renovice_local_2
      __renovice_local_2 = 1
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = gLotusSuitCustomizationType
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.TRADE_MODS
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.MODS_SKIP_LIST
      __renovice_local_2 = __renovice_local_1.RawItem
      __renovice_local_2 = __renovice_local_1.RawItem
      __renovice_local_2 = __renovice_local_2:CanTrade()
      __renovice_local_2 = true
      __renovice_local_1.Locked = __renovice_local_2
      __renovice_local_2 = "/Lotus/Language/Dojo/Trade_Untradeable"
      __renovice_local_1.LockedMsg = __renovice_local_2
      __renovice_local_2 = v164
      __renovice_local_3 = "modList"
      c86v4 = v107
      c86v4 = c86v4.MISC
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.SHIP_SCRAP
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.SHIP_PARTS
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.SHIP_RAW
      __renovice_local_2 = v164
      __renovice_local_3 = "miscList"
      c86v4 = v107
      c86v4 = c86v4.MISC
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = v129
      __renovice_local_2 = __renovice_local_2()
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = gRecipeItemType
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v129
      __renovice_local_2 = __renovice_local_2()
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = baseLichItem
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v164
      __renovice_local_3 = "lichList"
      c86v4 = v107
      c86v4 = c86v4.LICH
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = v129
      __renovice_local_2 = __renovice_local_2()
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = gEmoteType
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v164
      __renovice_local_3 = "emoteList"
      c86v4 = v107
      c86v4 = c86v4.EMOTE
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.IsPrimePart
      __renovice_local_2 = v164
      __renovice_local_3 = "primeList"
      c86v4 = v107
      c86v4 = c86v4.PRIME
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = 0
      __renovice_local_2 = v164
      __renovice_local_3 = "warframeList"
      c86v4 = v107
      c86v4 = c86v4.WARFRAME
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = 1
      __renovice_local_2 = v164
      __renovice_local_3 = "weaponList"
      c86v4 = v107
      c86v4 = c86v4.WEAPONS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = 2
      __renovice_local_2 = 3
      __renovice_local_2 = v164
      __renovice_local_3 = "archwingList"
      c86v4 = v107
      c86v4 = c86v4.ARCHWING
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = 10
      __renovice_local_2 = v164
      __renovice_local_3 = "mechList"
      c86v4 = v107
      c86v4 = c86v4.MECHS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 6
      __renovice_local_2 = v164
      __renovice_local_3 = "skinList"
      c86v4 = v107
      c86v4 = c86v4.APPEARANCE
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 18
      __renovice_local_2 = v164
      __renovice_local_3 = "droneList"
      c86v4 = v107
      c86v4 = c86v4.MISC
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 2
      __renovice_local_2 = v164
      __renovice_local_3 = "gearList"
      c86v4 = v107
      c86v4 = c86v4.GEAR
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 17
      __renovice_local_2 = v164
      __renovice_local_3 = "keyList"
      c86v4 = v107
      c86v4 = c86v4.KEYS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 28
      __renovice_local_2 = v164
      __renovice_local_3 = "archwingWeaponList"
      c86v4 = v107
      c86v4 = c86v4.ARCHWINGWEAPONS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 29
      __renovice_local_2 = v164
      __renovice_local_3 = "archwingWeaponList"
      c86v4 = v107
      c86v4 = c86v4.ARCHWINGWEAPONS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.CatItemType
      c86v4 = plantItem
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = __renovice_local_1.CatItemType
      c86v4 = resourceItem
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = __renovice_local_1.CatItemType
      c86v4 = zarimanResourceItem
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v164
      __renovice_local_3 = "materialList"
      c86v4 = v107
      c86v4 = c86v4.RESOURCES
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = v2
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = v3
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v164
      __renovice_local_3 = "enhancementList"
      c86v4 = v107
      c86v4 = c86v4.ENHANCEMENTS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = v4
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v164
      __renovice_local_3 = "avionicsList"
      c86v4 = v107
      c86v4 = c86v4.AVIONICS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = gFocusLensType
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v164
      __renovice_local_3 = "focusLensList"
      c86v4 = v107
      c86v4 = c86v4.FOCUS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 34
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.DECODONATE
      __renovice_local_2 = __renovice_local_1.StoreItem
      __renovice_local_2 = __renovice_local_2:CanPlaceInDojo()
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.DECODONATE
      __renovice_local_2 = v129
      __renovice_local_2 = __renovice_local_2()
      __renovice_local_2 = v109
      __renovice_local_2 = __renovice_local_2.AYATAN
      __renovice_local_1.Category = __renovice_local_2
      __renovice_local_2 = v164
      __renovice_local_3 = "miscList"
      c86v4 = v107
      c86v4 = c86v4.MISC
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 37
      __renovice_local_2 = v164
      __renovice_local_3 = "operatorAmpList"
      c86v4 = v107
      c86v4 = c86v4.OPERATORAMPS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = gVoidProjectionItemType
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = v164
      __renovice_local_3 = "relicsList"
      c86v4 = v107
      c86v4 = c86v4.RELICS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.SortCategory
      __renovice_local_3 = 26
      __renovice_local_2 = v164
      __renovice_local_3 = "imprintList"
      c86v4 = v107
      c86v4 = c86v4.PETPRINTS
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.Type
      __renovice_local_3 = ducatType
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.TREASURE
      __renovice_local_2 = __renovice_local_1.Type
      c86v4 = gFusionTreasureType
      __renovice_local_2 = __renovice_local_2:IsA(c86v4)
      __renovice_local_2 = __renovice_local_1.StoreItem
      __renovice_local_2 = __renovice_local_2:CanPlaceInDojo()
      __renovice_local_2 = v164
      __renovice_local_3 = "miscList"
      c86v4 = v107
      c86v4 = c86v4.MISC
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.RawItem
      __renovice_local_3 = v27
      __renovice_local_3 = __renovice_local_3.GetArcaneRank
      __renovice_local_3, c86v4 = __renovice_local_3(__renovice_local_2)
      __renovice_local_1.ArcaneRank = __renovice_local_3
      __renovice_local_1.ArcaneMaxRank = c86v4
      __renovice_local_1.Arcane = __renovice_local_2
      __renovice_local_3 = v95
      c86v4 = v94
      c86v4 = c86v4.TRADE_ITEMS
      if __renovice_local_3 == c86v4 then
        __renovice_local_3 = __renovice_local_2.mInstance
        __renovice_local_3 = __renovice_local_3:GetRarity()
        if __renovice_local_3 == 3 then
          __renovice_local_3 = 10
          if __renovice_local_0 < __renovice_local_3 then
            __renovice_local_3 = true
            __renovice_local_1.Locked = __renovice_local_3
            __renovice_local_3 = mMovie
            c86v5 = "/Lotus/Language/Dojo/Trade_PlayerLevelReq"
            c86v6 = true
            c86v7 = { RANK = "10" }
            __renovice_local_3 = __renovice_local_3:GetLocalized(c86v5, c86v6, c86v7)
            __renovice_local_1.LockedMsg = __renovice_local_3
          end
        end
      end
      __renovice_local_3 = __renovice_local_1.RawItem
      __renovice_local_2 = IsNull
      __renovice_local_2 = __renovice_local_2(__renovice_local_3)
      if not __renovice_local_2 then
        __renovice_local_2 = __renovice_local_1.RawItem
        __renovice_local_2 = __renovice_local_2:IsTimeLimited()
        if __renovice_local_2 then
          __renovice_local_2 = true
          __renovice_local_1.Locked = __renovice_local_2
          __renovice_local_2 = "/Lotus/Language/Dojo/Trade_Untradeable"
          __renovice_local_1.LockedMsg = __renovice_local_2
        end
      end
      __renovice_local_2 = v75
      __renovice_local_2 = __renovice_local_2.Elements
      __renovice_local_1 = #__renovice_local_2
      if __renovice_local_1 == 0 then
        __renovice_local_1 = v75
        __renovice_local_2 = table.remove
        __renovice_local_3 = v73
        c86v4 = 1
        __renovice_local_2 = __renovice_local_2(__renovice_local_3, c86v4)
        __renovice_local_1.Category = __renovice_local_2
        __renovice_local_1 = v75
        __renovice_local_2 = v163
        __renovice_local_3 = v75
        __renovice_local_3 = __renovice_local_3.Category
        __renovice_local_2 = __renovice_local_2(__renovice_local_3)
        __renovice_local_1.Elements = __renovice_local_2
      end
      __renovice_local_1 = gGameConfig
      __renovice_local_3 = v75
      __renovice_local_3 = __renovice_local_3.Category
      c86v1 = __renovice_local_1:Name__9f88c518(__renovice_local_3)
      __renovice_local_2 = v75
      __renovice_local_2 = __renovice_local_2.Elements
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(__renovice_local_2)
      c86v3 = nil
      __renovice_local_2 = v5
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(__renovice_local_2)
      if not __renovice_local_1 then
        __renovice_local_1 = v5
        __renovice_local_3 = c86v2.mItemType
        c86v3 = __renovice_local_1:Name__1dc35bd2(__renovice_local_3)
        __renovice_local_1 = IsNull
        __renovice_local_1 = __renovice_local_1(c86v3)
        if not __renovice_local_1 then
          __renovice_local_1 = c86v3:ShowInInventory()
          if not __renovice_local_1 then
            c86v3 = nil
          end
        end
      end
      __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(c86v3)
      __renovice_local_2 = __renovice_local_1.IsPrimePart
      if __renovice_local_2 then
        __renovice_local_3 = v107
        __renovice_local_3 = __renovice_local_3.PRIME
        __renovice_local_2 = {__renovice_local_3}
        __renovice_local_1.AdditionalCategories = __renovice_local_2
      end
      __renovice_local_2 = v164
      __renovice_local_3 = "recipeList"
      c86v4 = v107
      c86v4 = c86v4.RECIPES
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = __renovice_local_1.Category
      __renovice_local_3 = 24
      if __renovice_local_2 == __renovice_local_3 then
        __renovice_local_2 = c86v2.mDetails
        __renovice_local_2 = __renovice_local_2.mName
        if __renovice_local_2 ~= "" then
          __renovice_local_2 = c86v2.mDetails
          __renovice_local_2 = __renovice_local_2.mName
          __renovice_local_1.Name = __renovice_local_2
        end
      end
      __renovice_local_2 = v164
      __renovice_local_3 = "sentinelList"
      c86v4 = v107
      c86v4 = c86v4.SENTINEL
      __renovice_local_2(__renovice_local_3, c86v4, __renovice_local_1)
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.DECODONATE
      if __renovice_local_2 == __renovice_local_3 then
        __renovice_local_3 = __renovice_local_1.StoreItem
        __renovice_local_2 = IsNull
        __renovice_local_2 = __renovice_local_2(__renovice_local_3)
        if not __renovice_local_2 then
          __renovice_local_2 = __renovice_local_1.StoreItem
          c86v4 = gShipDecoStoreItemType
          __renovice_local_2 = __renovice_local_2:IsA(c86v4)
          if __renovice_local_2 then
            __renovice_local_2 = v22
            __renovice_local_2 = __renovice_local_2.GetCategoryForShipDeco
            __renovice_local_3 = __renovice_local_1.StoreItem
            __renovice_local_2 = __renovice_local_2(__renovice_local_3:GetDeco())
            __renovice_local_1.Category = __renovice_local_2
          end
        end
      end
      __renovice_local_2 = v95
      __renovice_local_3 = v94
      __renovice_local_3 = __renovice_local_3.DECODONATE
      __renovice_local_3 = __renovice_local_1.RawItem
      __renovice_local_2 = IsNull
      __renovice_local_2 = __renovice_local_2(__renovice_local_3)
      if not __renovice_local_2 then
        __renovice_local_2 = __renovice_local_1.RawItem
        __renovice_local_2 = __renovice_local_2.mItemType
        c86v4 = kubrowPowerSuitType
        __renovice_local_2 = __renovice_local_2:IsA(c86v4)
        if not __renovice_local_2 then
          __renovice_local_2 = v24
          __renovice_local_2 = __renovice_local_2.Ternary
          c86v4 = 1
          if c86v1 ~= c86v4 then
            __renovice_local_3 = false
          else
            __renovice_local_3 = true
          end
          c86v4 = 0
          c86v5 = 7
          __renovice_local_2 = __renovice_local_2(__renovice_local_3, c86v4, c86v5)
          __renovice_local_3 = __renovice_local_1.RawItem
          __renovice_local_3 = __renovice_local_3.mItemType
          c86v5 = catbrowPetSuitType
          __renovice_local_3 = __renovice_local_3:IsA(c86v5)
          if __renovice_local_3 then
            __renovice_local_2 = 9
          end
          __renovice_local_3 = v22
          __renovice_local_3 = __renovice_local_3.GetIconForEquippedSkin
          c86v4 = v5
          c86v5 = v72
          c86v6 = __renovice_local_1.RawItem
          c86v8 = true
          __renovice_local_3, c86v4 = __renovice_local_3(c86v4, c86v5, c86v6, __renovice_local_2, c86v8)
          c86v5 = IsNull
          c86v5 = c86v5(__renovice_local_3)
          if not c86v5 then
            __renovice_local_1.Icon = __renovice_local_3
            __renovice_local_1.Themed = c86v4
          end
        end
      end
      __renovice_local_2 = c86v2.SortCategory
      __renovice_local_3 = 34
      if __renovice_local_2 == __renovice_local_3 then
        __renovice_local_1 = c86v2
      else
        __renovice_local_2 = v22
        __renovice_local_2 = __renovice_local_2.GetStoreItemInfo
        __renovice_local_3 = mMovie
        c86v4 = c86v3
        c86v5 = { SalvageRepaired = nil, GetVisibilityMaterial = true, ItemInfo = nil, Category = nil, GameData = nil, HideRecipesInUse = true, CheckTimeLimited = true, CheckKeyChain = true, UsePrimeBucks = nil, UseFusionPoints = nil, UseFocusPoints = nil, UseDistillPoints = nil }
        c86v7 = v95
        c86v8 = v94
        c86v8 = c86v8.SHIP_PARTS
        if c86v7 ~= c86v8 then
          c86v6 = false
        else
          c86v6 = true
        end
        c86v5.SalvageRepaired = c86v6
        c86v5.ItemInfo = c86v2
        c86v6 = v75
        c86v6 = c86v6.Category
        c86v5.Category = c86v6
        c86v6 = v46
        c86v5.GameData = c86v6
        c86v7 = v95
        c86v8 = v94
        c86v8 = c86v8.PRIMEPARTS
        if c86v7 ~= c86v8 then
          c86v6 = false
        else
          c86v6 = true
        end
        c86v5.UsePrimeBucks = c86v6
        c86v7 = v95
        c86v8 = v94
        c86v8 = c86v8.TREASURE
        if c86v7 ~= c86v8 then
          c86v6 = false
        else
          c86v6 = true
        end
        c86v5.UseFusionPoints = c86v6
        c86v7 = v95
        c86v8 = v94
        c86v8 = c86v8.SHARDS
        if c86v7 ~= c86v8 then
          c86v6 = false
        else
          c86v6 = true
        end
        c86v5.UseFocusPoints = c86v6
        c86v7 = v95
        c86v8 = v94
        c86v8 = c86v8.ARCANE
        if c86v7 ~= c86v8 then
          c86v6 = false
        else
          c86v6 = true
        end
        c86v5.UseDistillPoints = c86v6
        c86v6 = v5
        c86v7 = v72
        c86v8 = true
        __renovice_local_1 = __renovice_local_2(__renovice_local_3, c86v4, c86v5, c86v6, c86v7, c86v8)
        __renovice_local_3 = __renovice_local_1.ResultStoreItem
        __renovice_local_2 = IsNull
        __renovice_local_2 = __renovice_local_2(__renovice_local_3)
        if not __renovice_local_2 then
          __renovice_local_2 = v23
          __renovice_local_2 = __renovice_local_2.GetNumOwned
          __renovice_local_3 = gGameData
          c86v4 = gGameData
          c86v4 = c86v4:GetInventory()
          c86v5 = __renovice_local_1.ResultStoreItem
          c86v6 = v43
          c86v6 = c86v6.PurchasedItems
          __renovice_local_2 = __renovice_local_2(__renovice_local_3, c86v4, c86v5, c86v6)
          __renovice_local_1.ResultOwned = __renovice_local_2
        end
      end
      __renovice_local_3 = v50
      __renovice_local_2 = IsNull
      __renovice_local_2 = __renovice_local_2(__renovice_local_3)
      if not __renovice_local_2 then
        c86v4 = _T
        c86v5 = v50
        __renovice_local_3 = c86v4[c86v5]
        __renovice_local_2 = IsNull
        __renovice_local_2 = __renovice_local_2(__renovice_local_3)
        if not __renovice_local_2 then
          __renovice_local_3 = _T
          c86v4 = v50
          __renovice_local_2 = __renovice_local_3[c86v4]
          __renovice_local_2(__renovice_local_1)
        end
      end
      __renovice_local_3 = v83
      c86v4 = __renovice_local_1.UID
      __renovice_local_2 = __renovice_local_3[c86v4]
      if __renovice_local_2 then
        __renovice_local_2 = true
        __renovice_local_1.Locked = __renovice_local_2
        __renovice_local_2 = mMovie
        c86v4 = "/Lotus/Language/Menu/ItemSelection_Equipped"
        c86v5 = false
        __renovice_local_2 = __renovice_local_2:GetLocalized(c86v4, c86v5)
        __renovice_local_1.LockedMsg = __renovice_local_2
      end
      __renovice_local_1.StoreItem = c86v3
      __renovice_local_2 = c86v2.SpecialPrice
      __renovice_local_1.SpecialPrice = __renovice_local_2
      __renovice_local_2 = c86v2.PriceLabelType
      __renovice_local_1.PriceLabelType = __renovice_local_2
      __renovice_local_3 = __renovice_local_1.ArcaneRank
      __renovice_local_2 = IsNull
      __renovice_local_2 = __renovice_local_2(__renovice_local_3)
    end
    __renovice_local_2 = v73
    __renovice_local_1 = #__renovice_local_2
    if __renovice_local_1 == 0 then
      __renovice_local_2 = v75
      __renovice_local_2 = __renovice_local_2.Elements
      __renovice_local_1 = #__renovice_local_2
      if __renovice_local_1 == 0 then
        __renovice_local_1 = 2
        v71 = __renovice_local_1
        do return end
      end
    end
    __renovice_local_0 = 75
    __renovice_local_1 = v76
    __renovice_local_0 = #__renovice_local_1
    __renovice_local_1 = 0
    __renovice_local_0 = v80
    __renovice_local_2 = v78
    __renovice_local_2 = __renovice_local_2.Elements
    __renovice_local_1 = #__renovice_local_2
    __renovice_local_2 = v129
    __renovice_local_2 = __renovice_local_2()
    __renovice_local_2 = v79
    __renovice_local_2 = __renovice_local_2.Name
    __renovice_local_2 = {}
    c86v5 = v80
    __renovice_local_3 = __renovice_local_1
    c86v4 = 1
    for __renovice_for_2_0 = c86v5, __renovice_local_3, c86v4 do
      c86v7 = v78
      c86v7 = c86v7.Elements
      c86v6 = c86v7[__renovice_for_2_0]
      c86v7 = c86v6.Category
      c86v8 = v129
      c86v8 = c86v8()
      if c86v8 then
        c86v8 = v109
        c86v8 = c86v8.AYATAN
        if c86v7 ~= c86v8 then
          c86v7 = v79.Category
        end
      end
      c86v8 = __renovice_local_2[c86v7]
      if c86v8 == nil then
        c86v8 = {}
        __renovice_local_2[c86v7] = c86v8
      end
      c86v9 = __renovice_local_2[c86v7]
      c86v8 = table.insert
      c86v8(c86v9, c86v6)
    end
    __renovice_local_2 = v95
    __renovice_local_3 = v94
    __renovice_local_3 = __renovice_local_3.FISH
    __renovice_local_2 = v79
    __renovice_local_2 = __renovice_local_2.Name
    __renovice_local_2 = {}
    __renovice_local_3 = {}
    c86v4 = {}
    c86v7 = v80
    c86v5 = __renovice_local_1
    c86v6 = 1
    __renovice_local_2 = v95
    __renovice_local_3 = v94
    __renovice_local_3 = __renovice_local_3.SYNDDONATE
    __renovice_local_2 = {}
    c86v5 = v80
    __renovice_local_3 = __renovice_local_1
    c86v4 = 1
    c86v7 = v78
    c86v7 = c86v7.Elements
    c86v6 = c86v7[c86v5]
    c86v7 = v23
    c86v7 = c86v7.GetNumOwned
    c86v8 = v46
    c86v9 = v72
    c86v10 = c86v6.StoreItem
    c86v11 = v43
    c86v11 = c86v11.PurchasedItems
    c86v7 = c86v7(c86v8, c86v9, c86v10, c86v11)
    c86v6.Count = c86v7
    c86v8 = c86v6.Type
    c86v7 = IsNull
    c86v7 = c86v7(c86v8)
    c86v7 = c86v6.Type
    c86v8 = v104
    c86v7 = c86v6.Count
    c86v8 = 0
    c86v7 = table.insert
    c86v7(__renovice_local_2, c86v6)
    __renovice_local_3 = v162
    c86v5 = 16
    c86v6 = 0
    __renovice_local_3(__renovice_local_2, c86v5, c86v6)
    __renovice_local_3 = __renovice_local_1 + 1
    v80 = __renovice_local_3
    c86v8 = nil
    c86v11 = v78
    c86v11 = c86v11.Elements
    c86v10 = c86v11[c86v7]
    c86v10 = c86v10.StoreItem
    c86v9 = IsNull
    c86v9 = c86v9(c86v10)
    if not c86v9 then
      c86v10 = v78
      c86v10 = c86v10.Elements
      c86v9 = c86v10[c86v7]
      c86v9 = c86v9.StoreItem
      c86v8 = c86v9:Name__4a64e8b1()
      c86v9 = 0
      if c86v8 == c86v9 then
        c86v12 = v78
        c86v12 = c86v12.Elements
        c86v11 = c86v12[c86v7]
        c86v9 = table.insert
        c86v9(__renovice_local_2, c86v11)
      else
        c86v9 = 1
        if c86v8 == c86v9 then
          c86v12 = v78
          c86v12 = c86v12.Elements
          c86v11 = c86v12[c86v7]
          c86v9 = table.insert
          c86v9(__renovice_local_3, c86v11)
        else
          c86v9 = 2
          if c86v8 == c86v9 then
            c86v12 = v78
            c86v12 = c86v12.Elements
            c86v11 = c86v12[c86v7]
            c86v9 = table.insert
            c86v9(c86v4, c86v11)
          end
        end
      end
    end
    c86v5 = v24
    c86v5 = c86v5.Ternary
    c86v7 = v80
    if c86v7 ~= 1 then
      c86v6 = false
    else
      c86v6 = true
    end
    c86v7 = 0
    c86v8 = nil
    c86v5 = c86v5(c86v6, c86v7, c86v8)
    c86v6 = v162
    c86v8 = v108
    c86v8 = c86v8.FISH_SMALL
    c86v6(__renovice_local_2, c86v8, c86v5)
    c86v6 = v162
    c86v8 = v108
    c86v8 = c86v8.FISH_MEDIUM
    c86v6(__renovice_local_3, c86v8, c86v5)
    c86v6 = v162
    c86v8 = v108
    c86v8 = c86v8.FISH_LARGE
    c86v6(c86v4, c86v8, c86v5)
    c86v6 = __renovice_local_1 + 1
    v80 = c86v6
    __renovice_local_0 = v80
    __renovice_local_2 = v78
    __renovice_local_2 = __renovice_local_2.Elements
    __renovice_local_1 = #__renovice_local_2
    if __renovice_local_1 < __renovice_local_0 then
      __renovice_local_1 = v76
      __renovice_local_0 = #__renovice_local_1
      __renovice_local_1 = 0
      if __renovice_local_1 < __renovice_local_0 then
        __renovice_local_0 = table.remove
        __renovice_local_1 = v76
        __renovice_local_0 = __renovice_local_0(__renovice_local_1)
        v79 = __renovice_local_0
        __renovice_local_1 = v74
        __renovice_local_2 = v79
        __renovice_local_2 = __renovice_local_2.Name
        __renovice_local_0 = __renovice_local_1[__renovice_local_2]
        v78 = __renovice_local_0
        __renovice_local_0 = 1
        v80 = __renovice_local_0
      end
    end
    __renovice_local_0 = 0
    __renovice_local_1 = 0
    __renovice_local_2 = v78
    if __renovice_local_2 == nil then
      __renovice_local_2 = { Elements = nil }
      __renovice_local_3 = {}
      __renovice_local_2.Elements = __renovice_local_3
      v78 = __renovice_local_2
    else
      __renovice_local_2 = v78
      __renovice_local_2 = __renovice_local_2.Elements
      __renovice_local_0 = #__renovice_local_2
      c86v7 = v80
      c86v6 = c86v7 + 75
      c86v5 = c86v6 - c86v0
      c86v4 = c86v5 - 1
      __renovice_local_2 = math.min
      __renovice_local_1 = __renovice_local_2(__renovice_local_0, c86v4)
      c86v4 = v80
      __renovice_local_3 = __renovice_local_1 - c86v4
      __renovice_local_2 = __renovice_local_3 + 1
      c86v0 = c86v0 + __renovice_local_2
    end
    __renovice_local_2 = v95
    __renovice_local_3 = v94
    __renovice_local_3 = __renovice_local_3.DECODONATE
    __renovice_local_3 = v24
    __renovice_local_3 = __renovice_local_3.Ternary
    c86v5 = v80
    if c86v5 ~= 1 then
      c86v4 = false
    else
      c86v4 = true
    end
    c86v5 = 0
    c86v6 = nil
    __renovice_local_3 = __renovice_local_3(c86v4, c86v5, c86v6)
    c86v4 = pairs
    c86v4, c86v5, c86v6 = c86v4(__renovice_local_2)
    for __renovice_for_3_0, __renovice_for_3_1 in c86v4, c86v5, c86v6 do
      c86v9 = v162
      c86v9(__renovice_for_3_1, __renovice_for_3_0, __renovice_local_3)
    end
    c86v4 = __renovice_local_1 + 1
    v80 = c86v4
    __renovice_local_2 = {}
    c86v5 = v80
    __renovice_local_3 = __renovice_local_1
    c86v4 = 1
    for __renovice_for_4_0 = c86v5, __renovice_local_3, c86v4 do
      c86v9 = v78
      c86v9 = c86v9.Elements
      c86v8 = c86v9[__renovice_for_4_0]
      c86v6 = table.insert
      c86v6(__renovice_local_2, c86v8)
    end
    __renovice_local_3 = 0
    c86v4 = v79
    c86v4 = c86v4.Bin
    if c86v4 ~= nil then
      __renovice_local_3 = v79.Bin
    end
    c86v4 = v162
    c86v5 = __renovice_local_2
    c86v6 = v79
    c86v6 = c86v6.Category
    c86v7 = v24
    c86v7 = c86v7.Ternary
    c86v9 = v80
    if c86v9 ~= 1 then
      c86v8 = false
    else
      c86v8 = true
    end
    c86v10 = nil
    c86v4(c86v5, c86v6, c86v7(c86v8, __renovice_local_3, c86v10))
    c86v4 = __renovice_local_1 + 1
    v80 = c86v4
    __renovice_local_1 = v76
    __renovice_local_0 = #__renovice_local_1
    if __renovice_local_0 == 0 then
      __renovice_local_0 = v80
      __renovice_local_2 = v78
      __renovice_local_2 = __renovice_local_2.Elements
      __renovice_local_1 = #__renovice_local_2
      if __renovice_local_1 < __renovice_local_0 then
        __renovice_local_0 = 3
        v71 = __renovice_local_0
        do return end
      end
    end
    do return end
  end
  v112 = function()
    local c89v0, c89v1, c89v2, c89v3, c89v4, c89v5, c89v6, c89v7, c89v8, c89v9, c89v10, c89v11, c89v12, c89v13, c89v14, c89v15
    local __renovice_state_0 = 0
    local __renovice_local_0 = print
    c89v0 = "PopulateGrid()"
    __renovice_local_0(c89v0)
    __renovice_local_0 = v43
    c89v1 = true
    c89v2 = true
    __renovice_local_0:RemoveElements(c89v1, c89v2)
    __renovice_local_0 = v95
    c89v0 = v94
    c89v0 = c89v0.ENEMIES
    if __renovice_local_0 ~= c89v0 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      __renovice_local_0 = v111
      __renovice_local_0()
      __renovice_state_0 = 62
    end
    if __renovice_state_0 == 2 then
      __renovice_local_0 = true
      v40 = __renovice_local_0
      __renovice_local_0 = v57
      c89v1 = true
      __renovice_local_0:SetActive(c89v1)
      c89v0 = v46
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c89v0)
      if not __renovice_local_0 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      do return end
    elseif __renovice_state_0 == 4 then
      __renovice_local_0 = v46
      __renovice_local_0 = __renovice_local_0:GetInventory()
      v72 = __renovice_local_0
      c89v0 = v72
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c89v0)
      if not __renovice_local_0 then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      __renovice_local_0 = print
      c89v0 = "ERROR: No inventory!"
      __renovice_local_0(c89v0)
      c89v0 = false
      __renovice_local_0 = assert
      __renovice_local_0(c89v0)
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 6 then
      __renovice_local_0 = v43
      c89v0 = v22
      c89v0 = c89v0.GetPurchasedItems
      c89v1 = v5
      c89v2 = v72
      c89v0 = c89v0(c89v1, c89v2)
      __renovice_local_0.PurchasedItems = c89v0
      __renovice_local_0 = {}
      v73 = __renovice_local_0
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.PRIMEPARTS
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c89v0 = 11
      c89v1 = 13
      __renovice_local_0 = {c89v0, c89v1}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 8 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.TREASURE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c89v0 = 11
      c89v1 = 34
      __renovice_local_0 = {c89v0, c89v1}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 10 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.FISH
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHARDS
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      c89v0 = 11
      __renovice_local_0 = {c89v0}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 13 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SYNDDONATE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c89v0 = 11
      __renovice_local_0 = {c89v0}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 15 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.DECODONATE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 17
      else
        __renovice_state_0 = 16
      end
    end
    if __renovice_state_0 == 16 then
      c89v0 = 30
      c89v1 = 34
      __renovice_local_0 = {c89v0, c89v1}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 17 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.RESDONATE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 18
      end
    end
    if __renovice_state_0 == 18 then
      c89v0 = 11
      __renovice_local_0 = {c89v0}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 19 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.TRADE_MODS
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 21
      else
        __renovice_state_0 = 20
      end
    end
    if __renovice_state_0 == 20 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.MODS_SKIP_LIST
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 22
      else
        __renovice_state_0 = 21
      end
    end
    if __renovice_state_0 == 21 then
      c89v0 = 4
      __renovice_local_0 = {c89v0}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 22 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHIP_RAW
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 24
      else
        __renovice_state_0 = 23
      end
    end
    if __renovice_state_0 == 23 then
      c89v0 = 43
      __renovice_local_0 = {c89v0}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 24 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHIP_SCRAP
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 26
      else
        __renovice_state_0 = 25
      end
    end
    if __renovice_state_0 == 25 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHIP_PARTS
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 27
      else
        __renovice_state_0 = 26
      end
    end
    if __renovice_state_0 == 26 then
      c89v0 = 43
      c89v1 = 46
      __renovice_local_0 = {c89v0, c89v1}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 27 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.ARCANE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 29
      else
        __renovice_state_0 = 28
      end
    end
    if __renovice_state_0 == 28 then
      c89v0 = 4
      __renovice_local_0 = {c89v0}
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 29 then
      c89v0 = 0
      c89v1 = 1
      c89v2 = 3
      c89v3 = 5
      c89v4 = 6
      c89v5 = 13
      c89v6 = 2
      c89v7 = 11
      c89v8 = 4
      c89v9 = 15
      c89v10 = 16
      c89v11 = 17
      c89v12 = 18
      c89v13 = 27
      c89v14 = 28
      c89v15 = 29
      __renovice_local_0 = {c89v0, c89v1, c89v2, c89v3, c89v4, c89v5, c89v6, c89v7, c89v8, c89v9, c89v10, c89v11, c89v12, c89v13, c89v14, c89v15}
      c89v0 = 34
      c89v1 = 24
      c89v2 = 37
      c89v3 = 39
      c89v4 = 41
      c89v5 = 48
      c89v6 = 26
      c89v7 = 50
      __renovice_local_0[17] = c89v0
      __renovice_local_0[18] = c89v1
      __renovice_local_0[19] = c89v2
      __renovice_local_0[20] = c89v3
      __renovice_local_0[21] = c89v4
      __renovice_local_0[22] = c89v5
      __renovice_local_0[23] = c89v6
      __renovice_local_0[24] = c89v7
      v73 = __renovice_local_0
      __renovice_state_0 = 30
    end
    if __renovice_state_0 == 30 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.TRADE_ITEMS
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 34
      else
        __renovice_state_0 = 31
      end
    end
    if __renovice_state_0 == 31 then
      __renovice_local_0 = v96
      if not __renovice_local_0 then
        __renovice_state_0 = 33
      else
        __renovice_state_0 = 32
      end
    end
    if __renovice_state_0 == 32 then
      c89v0 = v73
      c89v1 = 100
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 33
    end
    if __renovice_state_0 == 33 then
      c89v0 = v73
      c89v1 = 10
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 34
    end
    if __renovice_state_0 == 34 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.INVENTORY
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 36
      else
        __renovice_state_0 = 35
      end
    end
    if __renovice_state_0 == 35 then
      __renovice_local_0 = function(c87v0)
        local c87v1, c87v2, c87v3
        c87v2 = 0
        c87v3 = v72
        c87v1 = math.max
        c87v1 = c87v1(c87v2, c87v3:GetBinSlots(c87v0))
        do return c87v1 end
      end
      c89v1 = v76
      c89v2 = { Name = "warframeList", Category = nil, Bin = nil }
      c89v3 = v107
      c89v3 = c89v3.WARFRAME
      c89v2.Category = c89v3
      c89v4 = 0
      c89v3 = __renovice_local_0(c89v4)
      c89v2.Bin = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "weaponList", Category = nil, Bin = nil }
      c89v3 = v107
      c89v3 = c89v3.WEAPONS
      c89v2.Category = c89v3
      c89v4 = 1
      c89v3 = __renovice_local_0(c89v4)
      c89v2.Bin = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "sentinelList", Category = nil, Bin = nil }
      c89v3 = v107
      c89v3 = c89v3.SENTINEL
      c89v2.Category = c89v3
      c89v4 = 2
      c89v3 = __renovice_local_0(c89v4)
      c89v2.Bin = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "skinList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.APPEARANCE
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "enhancementList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.ENHANCEMENTS
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "focusLensList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.FOCUS
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "droneList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.MISC
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "gearList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.GEAR
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "keyList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.KEYS
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "miscList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.MISC
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "relicsList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.RELICS
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "materialList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.RESOURCES
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "imprintList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.PETPRINTS
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "archwingList", Category = nil, Bin = nil }
      c89v3 = v107
      c89v3 = c89v3.ARCHWING
      c89v2.Category = c89v3
      c89v4 = 3
      c89v3 = __renovice_local_0(c89v4)
      c89v2.Bin = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "archwingWeaponList", Category = nil, Bin = nil }
      c89v3 = v107
      c89v3 = c89v3.ARCHWINGWEAPONS
      c89v2.Category = c89v3
      c89v4 = 4
      c89v3 = __renovice_local_0(c89v4)
      c89v2.Bin = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "operatorAmpList", Category = nil, Bin = nil }
      c89v3 = v107
      c89v3 = c89v3.OPERATORAMPS
      c89v2.Category = c89v3
      c89v4 = 8
      c89v3 = __renovice_local_0(c89v4)
      c89v2.Bin = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "avionicsList", Category = nil }
      c89v3 = v107
      c89v3 = c89v3.AVIONICS
      c89v2.Category = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      c89v1 = v76
      c89v2 = { Name = "mechList", Category = nil, Bin = nil }
      c89v3 = v107
      c89v3 = c89v3.MECHS
      c89v2.Category = c89v3
      c89v4 = 10
      c89v3 = __renovice_local_0(c89v4)
      c89v2.Bin = c89v3
      c89v0 = table.insert
      c89v0(c89v1, c89v2)
      __renovice_state_0 = 49
    end
    if __renovice_state_0 == 36 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.TRADE_MODS
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 38
      else
        __renovice_state_0 = 37
      end
    end
    if __renovice_state_0 == 37 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.MODS_SKIP_LIST
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 39
      else
        __renovice_state_0 = 38
      end
    end
    if __renovice_state_0 == 38 then
      c89v0 = v76
      c89v1 = { Name = "modList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.MISC
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 49
    end
    if __renovice_state_0 == 39 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHIP_SCRAP
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 42
      else
        __renovice_state_0 = 40
      end
    end
    if __renovice_state_0 == 40 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHIP_PARTS
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 42
      else
        __renovice_state_0 = 41
      end
    end
    if __renovice_state_0 == 41 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHIP_RAW
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 43
      else
        __renovice_state_0 = 42
      end
    end
    if __renovice_state_0 == 42 then
      c89v0 = v76
      c89v1 = { Name = "miscList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.MISC
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 49
    end
    if __renovice_state_0 == 43 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.TRADE_ITEMS
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 45
      else
        __renovice_state_0 = 44
      end
    end
    if __renovice_state_0 == 44 then
      c89v0 = v76
      c89v1 = { Name = "weaponList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.WEAPONS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "archwingWeaponList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.ARCHWINGWEAPONS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "sentinelList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.SENTINEL
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "skinList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.APPEARANCE
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "enhancementList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.ENHANCEMENTS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "focusLensList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.FOCUS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "gearList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.GEAR
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "keyList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.KEYS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "miscList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.MISC
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "relicsList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.RELICS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "materialList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.RESOURCES
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "recipeList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.RECIPES
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "imprintList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.PETPRINTS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "lichList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.LICH
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "avionicsList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.AVIONICS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "emoteList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.EMOTE
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 49
    end
    if __renovice_state_0 == 45 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.RESDONATE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 47
      else
        __renovice_state_0 = 46
      end
    end
    if __renovice_state_0 == 46 then
      c89v0 = v76
      c89v1 = { Name = "materialList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.RESOURCES
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      c89v0 = v76
      c89v1 = { Name = "miscList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.RESOURCES
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 49
    end
    if __renovice_state_0 == 47 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.ARCANE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 49
      else
        __renovice_state_0 = 48
      end
    end
    if __renovice_state_0 == 48 then
      c89v0 = v76
      c89v1 = { Name = "enhancementList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.ENHANCEMENTS
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 49
    end
    if __renovice_state_0 == 49 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.TREASURE
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 52
      else
        __renovice_state_0 = 50
      end
    end
    if __renovice_state_0 == 50 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.ARCANE
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 52
      else
        __renovice_state_0 = 51
      end
    end
    if __renovice_state_0 == 51 then
      c89v0 = v76
      c89v1 = { Name = "primeList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.PRIME
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 52
    end
    if __renovice_state_0 == 52 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.PRIMEPARTS
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 59
      else
        __renovice_state_0 = 53
      end
    end
    if __renovice_state_0 == 53 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.TREASURE
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 58
      else
        __renovice_state_0 = 54
      end
    end
    if __renovice_state_0 == 54 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.FISH
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 58
      else
        __renovice_state_0 = 55
      end
    end
    if __renovice_state_0 == 55 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SHARDS
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 58
      else
        __renovice_state_0 = 56
      end
    end
    if __renovice_state_0 == 56 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.DECODONATE
      if __renovice_local_0 == c89v0 then
        __renovice_state_0 = 58
      else
        __renovice_state_0 = 57
      end
    end
    if __renovice_state_0 == 57 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SYNDDONATE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 59
      else
        __renovice_state_0 = 58
      end
    end
    if __renovice_state_0 == 58 then
      c89v0 = v76
      c89v1 = { Name = "miscList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.MISC
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 59
    end
    if __renovice_state_0 == 59 then
      __renovice_local_0 = v95
      c89v0 = v94
      c89v0 = c89v0.SYNDDONATE
      if __renovice_local_0 ~= c89v0 then
        __renovice_state_0 = 61
      else
        __renovice_state_0 = 60
      end
    end
    if __renovice_state_0 == 60 then
      c89v0 = v76
      c89v1 = { Name = "materialList", Category = nil }
      c89v2 = v107
      c89v2 = c89v2.RESOURCES
      c89v1.Category = c89v2
      __renovice_local_0 = table.insert
      __renovice_local_0(c89v0, c89v1)
      __renovice_state_0 = 61
    end
    if __renovice_state_0 == 61 then
      __renovice_local_0 = v43
      c89v1 = function()
        local c88v0, c88v1, c88v2, c88v3
        c88v1 = v47
        c88v2 = v110
        c88v2 = c88v2.TUTORIAL
        c88v0 = c88v1[c88v2]
        c88v2 = v95
        c88v3 = v94
        c88v3 = c88v3.PRIMEPARTS
        if c88v2 ~= c88v3 then
          c88v1 = false
        else
          c88v1 = true
        end
        c88v0.mVisible = c88v1
        c88v0 = false
        c88v1 = v95
        c88v2 = v94
        c88v2 = c88v2.FISH
        if c88v1 == c88v2 then
          c88v2 = v47
          c88v3 = v110
          c88v3 = c88v3.FISH_CATEGORY
          c88v1 = c88v2[c88v3]
          c88v2 = true
          c88v1.mVisible = c88v2
          c88v0 = true
        end
        c88v2 = v47
        c88v3 = v110
        c88v3 = c88v3.EXIT
        c88v1 = c88v2[c88v3]
        c88v1 = c88v1.mVisible
        if not c88v1 then
          c88v2 = v47
          c88v3 = v110
          c88v3 = c88v3.EXIT
          c88v1 = c88v2[c88v3]
          c88v2 = true
          c88v1.mVisible = c88v2
          c88v0 = true
        end
        if c88v0 then
          c88v1 = v119
          c88v1()
        end
        do return end
      end
      c89v2 = true
      c89v3 = true
      __renovice_local_0:Redraw(c89v1, c89v2, c89v3)
      __renovice_state_0 = 62
    end
    if __renovice_state_0 == 62 then
      __renovice_local_0 = mMovie
      c89v1 = "SearchAndSort.SearchBox"
      c89v2 = 13
      c89v3 = false
      __renovice_local_0:Name__d9713943(c89v1, c89v2, c89v3)
      __renovice_local_0 = mMovie
      c89v1 = v43
      c89v1 = c89v1.mSortClipName
      c89v2 = 12
      c89v3 = 0
      __renovice_local_0:SetNumberVariable(c89v1, c89v2, c89v3)
      __renovice_local_0 = mMovie
      c89v1 = v43
      c89v1 = c89v1.mCategoryClipName
      c89v2 = 13
      c89v3 = false
      __renovice_local_0:Name__d9713943(c89v1, c89v2, c89v3)
      __renovice_local_0 = v24
      __renovice_local_0 = __renovice_local_0.Ternary
      c89v1 = v95
      c89v2 = v94
      c89v2 = c89v2.ENEMIES
      if c89v1 == c89v2 then
        __renovice_state_0 = 64
      else
        __renovice_state_0 = 63
      end
    end
    if __renovice_state_0 == 63 then
      c89v0 = false
      __renovice_state_0 = 65
    end
    if __renovice_state_0 == 64 then
      c89v0 = true
      __renovice_state_0 = 65
    end
    if __renovice_state_0 == 65 then
      c89v1 = 3
      c89v2 = 1
      __renovice_local_0 = __renovice_local_0(c89v0, c89v1, c89v2)
      v71 = __renovice_local_0
      do return end
    end
    do return end
  end
  v166 = function(c90v0)
    local c90v1, c90v2, c90v3, c90v4, c90v5, c90v6, c90v7, c90v8, c90v9, c90v10
    c90v1 = Clamp
    c90v3 = 0
    c90v4 = 1
    c90v0 = c90v1(c90v0, c90v3, c90v4)
    c90v1 = c90v0 * 100
    c90v2 = FlashInterpolate
    c90v3 = mMovie
    c90v4 = "SellList.Slider.Fill"
    c90v5 = 2
    c90v7 = 5
    c90v6 = {c90v7}
    c90v8 = Clamp
    c90v9 = 0.01
    c90v10 = 100
    c90v7 = {c90v8(c90v1, c90v9, c90v10)}
    c90v8 = 0.1
    c90v2(c90v3, c90v4, c90v5, c90v6, c90v7, c90v8)
    c90v2 = mMovie
    c90v4 = "SellList.SliderValue.Value"
    c90v5 = 36
    c90v6 = string.format
    c90v7 = "%.0f"
    c90v2:SetStringVariable(c90v4, c90v5, c90v6(c90v7, c90v1))
    c90v2 = 142 + c90v1
    c90v3 = v43
    c90v3 = c90v3.ElementWidth
    if c90v2 ~= c90v3 then
      v43.ElementWidth = c90v2
      v43.ElementHeight = c90v2
      c90v3 = v152
      c90v4 = v43
      c90v3(c90v4)
      c90v3 = v43
      c90v3 = c90v3.mElements
      if c90v3 ~= nil then
        c90v4 = v43
        c90v4 = c90v4.mElements
        c90v3 = c90v4[1]
        if c90v3 ~= nil then
          c90v4 = v43
          c90v4 = c90v4.mElements
          c90v3 = c90v4[1]
          c90v3 = c90v3.mClipName
          if c90v3 ~= nil then
            c90v3 = v26
            c90v3 = c90v3.OnGridItemCreated
            c90v4 = mMovie
            c90v5 = v43
            c90v7 = v43
            c90v7 = c90v7.mElements
            c90v6 = c90v7[1]
            c90v6 = c90v6.mClipName
            c90v3(c90v4, c90v5, c90v6)
          end
        end
      end
      c90v3 = v43
      c90v5 = nil
      c90v6 = true
      c90v7 = true
      c90v3:Redraw(c90v5, c90v6, c90v7)
    end
    do return end
  end
  v167 = function()
    local c91v0, c91v1
    c91v0 = v40
    if not c91v0 then
      c91v0 = true
      v68 = c91v0
      c91v0 = v24
      c91v0 = c91v0.PlaySound
      c91v1 = _G
      c91v1 = c91v1.UISound_Select
      c91v0(c91v1)
    end
    do return end
  end
  SliderPress = v167
  v167 = function(c92v0)
    local c92v1
    c92v1 = false
    v68 = c92v1
    do return end
  end
  SliderRelease = v167
  v167 = function()
    local c93v0, c93v1
    local __renovice_local_0 = v124
    __renovice_local_0 = __renovice_local_0.mouseDown
    if __renovice_local_0 == true then
      c93v0 = RealTime
      c93v0 = c93v0()
      c93v1 = v124
      c93v1 = c93v1.mouseDownTime
      __renovice_local_0 = c93v0 - c93v1
      c93v0 = v124
      c93v0 = c93v0.mouseClickLimit
      if c93v0 < __renovice_local_0 then
        __renovice_local_0 = v124
        __renovice_local_0 = __renovice_local_0.dragStarted
        if __renovice_local_0 == false then
          __renovice_local_0 = v43
          __renovice_local_0:StartScrollDrag()
          __renovice_local_0 = v124
          c93v0 = true
          __renovice_local_0.dragStarted = c93v0
        end
      end
    end
    do return end
  end
  v168 = function()
    local c94v0, c94v1, c94v2, c94v3, c94v4
    c94v0 = v39
    if c94v0 then
      c94v1 = mMovie
      c94v0 = IsNull
      c94v0 = c94v0(c94v1)
      if not c94v0 then
        c94v0 = v68
        if c94v0 then
          c94v0 = mMovie
          c94v2 = "SellList.Slider"
          c94v3 = 30
          c94v0 = c94v0:GetNumberVariable(c94v2, c94v3)
          c94v1 = mMovie
          c94v3 = "SellList.Slider.Back"
          c94v4 = 14
          c94v1 = c94v1:GetNumberVariable(c94v3, c94v4)
          if (c94v0 ~= nil and c94v1 ~= nil) then
            c94v2 = v166
            c94v4 = c94v1 - 2
            c94v3 = c94v0 / c94v4
            c94v2(c94v3)
          end
        end
        c94v0 = v81
        if c94v0 then
          c94v0 = false
          c94v1 = gFlashMgr
          c94v3 = _G
          c94v3 = c94v3.UIMovie_DetailedPurchaseDialog
          c94v1 = c94v1:FindMovie(c94v3)
          if c94v1 == nil then
            c94v1 = v70
            c94v0 = not c94v1
            if c94v0 then
              c94v0 = true
              c94v1 = _T.TopMenuOpen
              if c94v1 == true then
                c94v0 = true
                c94v1 = v95
                c94v2 = v94
                c94v2 = c94v2.PRIMEPARTS
                if c94v1 == c94v2 then
                  c94v1 = v95
                  c94v2 = v94
                  c94v2 = c94v2.TREASURE
                  if c94v1 == c94v2 then
                    c94v0 = false
                  else
                    c94v0 = true
                  end
                end
              end
            end
          end
        end
        c94v1 = mMovie
        c94v1:SetVisible(c94v0)
        c94v1 = RealDeltaTime
        c94v1 = c94v1()
        c94v3 = v37
        c94v2 = IsNull
        c94v2 = c94v2(c94v3)
        if not c94v2 then
          c94v2 = v37
          c94v2:Update(c94v1)
        end
        c94v2 = mMovie
        c94v2:Name__b7f5bbc5(c94v1)
        c94v3 = v57
        c94v2 = IsNull
        c94v2 = c94v2(c94v3)
        if not c94v2 then
          c94v2 = v57
          c94v2:Update()
        end
        c94v2 = v71
        if c94v2 ~= nil then
          c94v2 = v113
          c94v2()
        end
        c94v3 = v43
        c94v2 = IsNull
        c94v2 = c94v2(c94v3)
        if not c94v2 then
          c94v2 = v43
          c94v2:Update()
        end
        c94v3 = v5
        c94v2 = IsNull
        c94v2 = c94v2(c94v3)
        if c94v2 then
          c94v3 = v7
          c94v2 = IsNull
          c94v2 = c94v2(c94v3)
          if not c94v2 then
            c94v2 = v7
            c94v2 = c94v2:IsDone()
            if c94v2 then
              c94v2 = Resource
              c94v3 = v6
              c94v2 = c94v2(c94v3)
              v5 = c94v2
              c94v2 = v112
              c94v2()
            end
          end
        end
        c94v2 = v14
        if c94v2 then
          c94v2 = gGameRules
          c94v4 = v15
          c94v2 = c94v2:Name__5253fca9(c94v4)
          if c94v2 then
            c94v2 = false
            v14 = c94v2
            c94v2 = false
            v40 = c94v2
            c94v2 = v57
            c94v4 = false
            c94v2:SetActive(c94v4)
            c94v3 = _T.SpawnEnemies
            c94v2 = IsNull
            c94v2 = c94v2(c94v3)
            if not c94v2 then
              c94v2 = _T.SpawnEnemies
              c94v3 = v45
              c94v3 = c94v3.mElements
              c94v4 = v16
              c94v2(c94v3, c94v4)
              c94v2 = _T
              c94v3 = { enemies = nil, level = nil }
              c94v4 = v45
              c94v4 = c94v4.mElements
              c94v3.enemies = c94v4
              c94v4 = v16
              c94v3.level = c94v4
              c94v2.EnemySpawnerLastSelection = c94v3
              c94v2 = v132
              c94v2()
            end
          end
        end
        c94v2 = Engine.IsMobile
        c94v2 = c94v2()
        if c94v2 then
          c94v2 = v167
          c94v2()
          c94v2 = v157
          c94v2()
        end
        do return end
      end
    end
    do return end
  end
  Update = v168
  v122 = function(c96v0)
    local c96v1, c96v2, c96v3
    c96v1 = v43
    c96v3 = function(c95v0)
      local c95v1, c95v2
      c95v1 = c95v0.LookupIds
      if c95v1 ~= nil then
        c95v2 = c95v0.LookupIds
        c95v1 = #c95v2
        c95v2 = 0
        if c95v2 < c95v1 then
          c95v1 = nil
          c95v0.MarkedToSell = c95v1
          c95v1 = nil
          c95v0.LookupIds = c95v1
          c95v1 = v136
          c95v1(c95v0)
        end
      end
      do return end
    end
    c96v1:RunForAllElements(c96v3)
    c96v1 = v45
    c96v1:RemoveElements(c96v0, c96v0)
    c96v1 = v139
    c96v3 = v58
    c96v2 = -c96v3
    c96v1(c96v2)
    do return end
  end
  v168 = function()
    local c97v0, c97v1, c97v2, c97v3, c97v4, c97v5, c97v6, c97v7, c97v8, c97v9, c97v10, c97v11
    local __renovice_state_0 = 0
    c97v0 = v12
    if c97v0 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c97v0 = gGameData
      c97v0 = c97v0:IsStaff()
      if not c97v0 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c97v0 = 40
      v17 = c97v0
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 3 then
      c97v0 = gGameRules
      c97v2 = gLotusPhotoBoothGameRulesType
      c97v0 = c97v0:IsA(c97v2)
      if not c97v0 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c97v0 = 3
      v17 = c97v0
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 5 then
      c97v0 = 20
      v17 = c97v0
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 6 then
      c97v0 = gRegion
      c97v0 = c97v0:IsMaster()
      if not c97v0 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c97v0 = Symbol
      c97v1 = "TENNO_TEAM"
      c97v0 = c97v0(c97v1)
      c97v1 = Symbol
      c97v2 = "TENNO"
      c97v1 = c97v1(c97v2)
      c97v2 = Symbol
      c97v3 = "Clem"
      c97v2 = c97v2(c97v3)
      c97v3 = 0
      c97v4 = gRegion
      c97v6 = gAvatarType
      c97v4 = c97v4:FindAll(c97v6)
      c97v5 = ipairs
      c97v5, c97v6, c97v7 = c97v5(c97v4)
      __renovice_state_0 = 13
    end
    if __renovice_state_0 == 8 then
      c97v9 = nil
      c97v10 = c97v9:GetAgent()
      c97v11 = IsNull
      c97v11 = c97v11(c97v10)
      if c97v11 then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c97v11 = c97v10:GetTeam()
      if c97v11 == c97v0 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      c97v11 = c97v9:GetOriginalFaction()
      if c97v11 ~= c97v1 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c97v11 = c97v9:GetTag()
      if c97v11 ~= c97v2 then
        __renovice_state_0 = 13
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      c97v3 = c97v3 + 1
      __renovice_state_0 = 13
    end
    if __renovice_state_0 == 13 then
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 14 then
      c97v6 = 0
      c97v8 = v17
      c97v7 = c97v8 - c97v3
      c97v5 = math.max
      c97v5 = c97v5(c97v6, c97v7)
      v17 = c97v5
      __renovice_state_0 = 15
    end
    if __renovice_state_0 == 15 then
      do return end
    end
    do return end
  end
  v169 = function()
    local c98v0, c98v1, c98v2
    c98v0 = require
    c98v1 = "Lotus.Scripts.SimulacrumUtilities"
    c98v0 = c98v0(c98v1)
    c98v1 = c98v0.KillEnemies
    c98v1()
    c98v1 = v168
    c98v1()
    c98v1 = v139
    c98v2 = 0
    c98v1(c98v2)
    do return end
  end
  KillEnemies = v169
  v169 = function()
    local c99v0, c99v1, c99v2, c99v3, c99v4, c99v5
    c99v2 = 1
    c99v3 = v77
    c99v0 = #c99v3
    c99v1 = 1
    for __renovice_for_0_0 = c99v2, c99v0, c99v1 do
      c99v3 = v77[__renovice_for_0_0]
      if c99v3 == nil then
        continue
      end
      c99v4 = c99v3.mButton
      if c99v4 == nil then
        continue
      end
      c99v4 = c99v3.mButton
      c99v5 = c99v3.GetName
      c99v4:SetText(c99v5())
    end
    do return end
  end
  v170 = function()
    local c100v0, c100v1, c100v2, c100v3, c100v4, c100v5
    c100v0 = _T
    c100v1 = { Name = nil, Description = nil, Count = nil, DefaultValue = nil, Callback = "OnEnemyLevelChanged" }
    c100v2 = Localize
    c100v3 = "/Lotus/Language/Menu/EnemySelector_LevelCount"
    c100v4 = {}
    c100v2 = c100v2(c100v3, c100v4)
    c100v1.Name = c100v2
    c100v2 = Localize
    c100v3 = "/Lotus/Language/Menu/EnemySelector_MaxLevel"
    c100v4 = { MAXLEVEL = nil }
    c100v5 = v18
    c100v4.MAXLEVEL = c100v5
    c100v2 = c100v2(c100v3, c100v4)
    c100v1.Description = c100v2
    c100v2 = v18
    c100v1.Count = c100v2
    c100v2 = v16
    c100v1.DefaultValue = c100v2
    c100v0.InfoPopup_Data = c100v1
    c100v0 = mMovie
    c100v2 = inputCountDialog
    c100v0:PushChildMovie(c100v2)
    do return end
  end
  EnemyLevelSelected = v170
  v170 = function(c101v0, c101v1)
    local c101v2, c101v3, c101v4, c101v5
    c101v2 = IsNull
    c101v2 = c101v2(c101v1)
    if not c101v2 then
      c101v2 = tonumber
      c101v2 = c101v2(c101v1)
      if c101v2 == 1 then
        c101v2 = tonumber
        c101v2 = c101v2(c101v0)
        c101v3 = 0
        if c101v3 < c101v2 then
          c101v2 = tonumber
          c101v2 = c101v2(c101v0)
          v16 = c101v2
          c101v2 = _T
          c101v3 = v16
          c101v2.SelectedEnemyLevel = c101v3
          c101v3 = v54
          c101v2 = IsNull
          c101v2 = c101v2(c101v3)
          if not c101v2 then
            c101v2 = v54
            c101v4 = "RefreshMenu"
            c101v5 = ""
            c101v2:Execute(c101v4, c101v5)
          end
        end
      end
    end
    c101v2 = v169
    c101v2()
    do return end
  end
  OnEnemyLevelChanged = v170
  v170 = function()
    local c102v0, c102v1, c102v2
    c102v0 = _T.FriendlyFire
    if c102v0 == nil then
      c102v0 = _T
      c102v1 = true
      c102v0.FriendlyFire = c102v1
    else
      c102v0 = _T
      c102v2 = _T.FriendlyFire
      c102v1 = not c102v2
      c102v0.FriendlyFire = c102v1
    end
    c102v0 = v116
    c102v0()
    c102v0 = v169
    c102v0()
    do return end
  end
  ToggleFriendlyFire = v170
  v170 = function()
    local c103v0, c103v1, c103v2
    c103v0 = _T.SimulateHardMode
    if c103v0 == nil then
      c103v0 = _T
      c103v1 = true
      c103v0.SimulateHardMode = c103v1
    else
      c103v0 = _T
      c103v2 = _T.SimulateHardMode
      c103v1 = not c103v2
      c103v0.SimulateHardMode = c103v1
    end
    c103v0 = v117
    c103v0()
    c103v0 = v169
    c103v0()
    do return end
  end
  ToggleHardMode = v170
  v170 = function()
    local c104v0, c104v1, c104v2
    c104v0 = _T.PauseAI
    if c104v0 == nil then
      c104v0 = _T
      c104v1 = true
      c104v0.PauseAI = c104v1
    else
      c104v0 = _T
      c104v2 = _T.PauseAI
      c104v1 = not c104v2
      c104v0.PauseAI = c104v1
    end
    c104v0 = v115
    c104v0()
    c104v0 = v169
    c104v0()
    do return end
  end
  TogglePauseAI = v170
  v170 = function()
    local c105v0, c105v1
    c105v0 = _T.warframesInvincible
    if c105v0 then
      c105v0 = _T
      c105v1 = false
      c105v0.warframesInvincible = c105v1
    else
      c105v0 = _T
      c105v1 = true
      c105v0.warframesInvincible = c105v1
    end
    c105v0 = v169
    c105v0()
    do return end
  end
  ToggleInvincibility = v170
  v170 = function()
    local c106v0, c106v1
    c106v0 = _T.companionsInvincible
    if c106v0 then
      c106v0 = _T
      c106v1 = false
      c106v0.companionsInvincible = c106v1
    else
      c106v0 = _T
      c106v1 = true
      c106v0.companionsInvincible = c106v1
    end
    c106v0 = v169
    c106v0()
    do return end
  end
  ToggleCompanionInvincibility = v170
  v170 = function()
    local c107v0, c107v1, c107v2
    c107v0 = _T
    c107v2 = _T.SpawnEnemyAtCameraPos
    if c107v2 then
      c107v1 = false
    else
      c107v1 = true
    end
    c107v0.SpawnEnemyAtCameraPos = c107v1
    c107v0 = _T.SpawnEnemyAtCameraPos
    if c107v0 then
      c107v0 = _T
      c107v1 = false
      c107v0.SpawnEnemyAtAimPos = c107v1
    end
    c107v0 = v169
    c107v0()
    do return end
  end
  ToggleSpawnAtCameraPos = v170
  v170 = function()
    local c108v0, c108v1, c108v2
    c108v0 = _T
    c108v2 = _T.SpawnEnemyAtAimPos
    if c108v2 then
      c108v1 = false
    else
      c108v1 = true
    end
    c108v0.SpawnEnemyAtAimPos = c108v1
    c108v0 = _T.SpawnEnemyAtAimPos
    if c108v0 then
      c108v0 = _T
      c108v1 = false
      c108v0.SpawnEnemyAtCameraPos = c108v1
    end
    c108v0 = v169
    c108v0()
    do return end
  end
  ToggleSpawnAtAimPos = v170
  v170 = function()
    local c109v0, c109v1, c109v2
    c109v0 = _T
    c109v2 = _T.SpawnEnemyPursuePlayer
    if c109v2 then
      c109v1 = false
    else
      c109v1 = true
    end
    c109v0.SpawnEnemyPursuePlayer = c109v1
    c109v0 = v169
    c109v0()
    do return end
  end
  ToggleSpawnEnemyPursuePlayer = v170
  v170 = function()
    local c110v0, c110v1, c110v2
    c110v0 = _T
    c110v2 = _T.SpawnEnemyAttackPlayer
    if c110v2 then
      c110v1 = false
    else
      c110v1 = true
    end
    c110v0.SpawnEnemyAttackPlayer = c110v1
    c110v0 = v169
    c110v0()
    do return end
  end
  ToggleSpawnEnemyAttackPlayer = v170
  v170 = function()
    local c112v0, c112v1, c112v2, c112v3, c112v4, c112v5, c112v6, c112v7, c112v8
    c112v0 = false
    v70 = c112v0
    c112v0 = nil
    v54 = c112v0
    c112v0 = function(c111v0)
      local c111v1, c111v2, c111v3, c111v4, c111v5
      c111v2 = _T.ShowBackground
      c111v1 = IsNull
      c111v1 = c111v1(c111v2)
      if not c111v1 then
        c111v1 = 0.66
        c111v2 = 1.3399999999999999 * c111v0
        c111v0 = c111v1 + c111v2
        c111v1 = _T.ShowBackground
        c111v2 = 0.25
        c111v3 = nil
        c111v4 = nil
        c111v5 = { Size = nil, Center = 0, FadeSize = 0.4 }
        c111v5.Size = c111v0
        c111v1(c111v2, c111v3, c111v4, c111v5)
      end
      do return end
    end
    c112v1 = mMovie
    c112v3 = "_root"
    c112v4 = 12
    c112v5 = 0
    c112v1:SetNumberVariable(c112v3, c112v4, c112v5)
    c112v1 = FlashInterpolate
    c112v2 = mMovie
    c112v3 = "_root"
    c112v4 = 8
    c112v6 = 12
    c112v5 = {c112v6, c112v0}
    c112v7 = 100
    c112v8 = 1
    c112v6 = {c112v7, c112v8}
    c112v7 = 0.5
    c112v1(c112v2, c112v3, c112v4, c112v5, c112v6, c112v7)
    do return end
  end
  SyndicateMovieClosed = v170
  v170 = function()
    local c113v0, c113v1, c113v2
    c113v0 = _T.TaggedDialog
    if c113v0 ~= nil then
      c113v1 = _T.TaggedDialog
      c113v0 = c113v1.Recruiter_Syndicate
      if c113v0 ~= nil then
        c113v1 = _T.TaggedDialog
        c113v0 = c113v1.Recruiter_Syndicate
        c113v0 = c113v0.mCallback
        c113v1 = _T.CurrentConversation
        c113v2 = mMovie
        c113v0 = c113v0(c113v1, c113v2)
        v54 = c113v0
        c113v0 = true
        v70 = c113v0
        do return end
      end
    end
    do return end
  end
  OpenSyndicateMovie = v170
  v170 = function()
    local c119v0, c119v1, c119v2, c119v3, c119v4, c119v5
    c119v0 = "/Lotus/Language/Menu/Exit"
    c119v1 = _T.InventoryInfo
    if c119v1 ~= nil then
      c119v1 = _T.InventoryInfo.ExitLabel
      if c119v1 ~= nil then
        c119v0 = _T.InventoryInfo.ExitLabel
      end
    end
    c119v2 = v47
    c119v3 = { mLabel = nil, mVisible = false, mCallback = nil, mCallout = "MENU_CANCEL" }
    c119v3.mLabel = c119v0
    c119v4 = function()
      local c114v0, c114v1, c114v2
      c114v0 = mMovie
      c114v1 = "ExitScreen"
      c114v2 = ""
      c114v0:Execute(c114v1, c114v2)
      do return end
    end
    c119v3.mCallback = c119v4
    c119v1 = table.insert
    c119v1(c119v2, c119v3)
    c119v2 = v47
    c119v3 = { mLabel = "/Lotus/Language/Menu/ItemInventory_SelectAll", mVisible = nil, mCallback = nil, mCallout = "MENU_GENERIC1" }
    local __renovice_local_0 = v95
    c119v5 = v94
    c119v5 = c119v5.FISH
    if __renovice_local_0 ~= c119v5 then
      c119v4 = false
    else
      c119v4 = true
    end
    c119v3.mVisible = c119v4
    c119v4 = function()
      local c115v0, c115v1, c115v2
      c115v0 = mMovie
      c115v1 = "SelectAllCategoryItems"
      c115v2 = ""
      c115v0:Execute(c115v1, c115v2)
      do return end
    end
    c119v3.mCallback = c119v4
    c119v1 = table.insert
    c119v1(c119v2, c119v3)
    c119v2 = v47
    c119v3 = { mLabel = "/Lotus/Language/Menu/Clear", mVisible = nil, mCallback = nil, mCallout = "MENU_RTRIGGER1" }
    __renovice_local_0 = v95
    c119v5 = v94
    c119v5 = c119v5.ENEMIES
    if __renovice_local_0 ~= c119v5 then
      c119v4 = false
    else
      c119v4 = true
    end
    c119v3.mVisible = c119v4
    c119v4 = v122
    c119v3.mCallback = c119v4
    c119v1 = table.insert
    c119v1(c119v2, c119v3)
    c119v2 = v47
    c119v3 = { mLabel = "/Lotus/Language/Menu/Simulacrum_KillEnemies", mVisible = nil, mCallback = nil, mCallout = "MENU_RTHUMB" }
    c119v4 = false
    __renovice_local_0 = v95
    c119v5 = v94
    c119v5 = c119v5.ENEMIES
    if __renovice_local_0 == c119v5 then
      c119v4 = _T.InSimulacrum
      if c119v4 then
        c119v4 = gRegion
        c119v4 = c119v4:IsMaster()
      end
    end
    c119v3.mVisible = c119v4
    c119v4 = function()
      local c116v0, c116v1, c116v2
      c116v0 = mMovie
      c116v1 = "KillEnemies"
      c116v2 = ""
      c116v0:Execute(c116v1, c116v2)
      do return end
    end
    c119v3.mCallback = c119v4
    c119v1 = table.insert
    c119v1(c119v2, c119v3)
    c119v2 = v47
    c119v3 = { mLabel = "/Lotus/Language/Menu/ItemInventory_SelectAll", mVisible = nil, mCallback = nil, mCallout = "MENU_GENERIC1" }
    c119v4 = false
    __renovice_local_0 = v95
    c119v5 = v94
    c119v5 = c119v5.FISH
    if __renovice_local_0 ~= c119v5 then
      c119v4 = false
      __renovice_local_0 = v95
      c119v5 = v94
      c119v5 = c119v5.ENEMIES
      if __renovice_local_0 ~= c119v5 then
        c119v4 = false
        __renovice_local_0 = v95
        c119v5 = v94
        c119v5 = c119v5.SHIP_SCRAP
        if __renovice_local_0 ~= c119v5 then
          c119v4 = false
          __renovice_local_0 = v95
          c119v5 = v94
          c119v5 = c119v5.SHIP_PARTS
          if __renovice_local_0 ~= c119v5 then
            c119v4 = false
            __renovice_local_0 = v95
            c119v5 = v94
            c119v5 = c119v5.SHIP_RAW
            if __renovice_local_0 ~= c119v5 then
              c119v4 = Engine.IsPlayingWithController
              c119v4 = c119v4()
            end
          end
        end
      end
    end
    c119v3.mVisible = c119v4
    c119v4 = v114
    c119v3.mCallback = c119v4
    c119v1 = table.insert
    c119v1(c119v2, c119v3)
    c119v2 = v47
    c119v3 = { mLabel = "/Lotus/Language/Menu/General_Tutorial", mVisible = nil, mCallback = nil, mCallout = "MENU_RTHUMB" }
    __renovice_local_0 = v95
    c119v5 = v94
    c119v5 = c119v5.PRIMEPARTS
    if __renovice_local_0 ~= c119v5 then
      c119v4 = false
    else
      c119v4 = true
    end
    c119v3.mVisible = c119v4
    c119v4 = function()
      local c117v0
      c117v0 = _T.KioskIntroTransmission
      c117v0()
      do return end
    end
    c119v3.mCallback = c119v4
    c119v1 = table.insert
    c119v1(c119v2, c119v3)
    c119v2 = v47
    c119v3 = { mLabel = "/Lotus/Language/Menu/SyndicateMissionName", mVisible = nil, mCallback = nil }
    c119v4 = false
    __renovice_local_0 = v95
    c119v5 = v94
    c119v5 = c119v5.SYNDDONATE
    if __renovice_local_0 == c119v5 then
      c119v4 = false
      __renovice_local_0 = _T.TaggedDialog
      if __renovice_local_0 ~= nil then
        c119v4 = false
        c119v5 = _T.TaggedDialog
        __renovice_local_0 = c119v5.Recruiter_Syndicate
        if __renovice_local_0 ~= nil then
          __renovice_local_0 = _T.DisableSyndicateRankUp
          c119v4 = not __renovice_local_0
        end
      end
    end
    c119v3.mVisible = c119v4
    c119v4 = function()
      local c118v0, c118v1, c118v2
      c118v0 = mMovie
      c118v1 = "OpenSyndicateMovie"
      c118v2 = ""
      c118v0:Execute(c118v1, c118v2)
      do return end
    end
    c119v3.mCallback = c119v4
    c119v1 = table.insert
    c119v1(c119v2, c119v3)
    do return end
  end
  v171 = function(c120v0)
    local c120v1
    c120v1 = v23
    c120v1 = c120v1.HandleInvalidBinErrorResponse
    c120v1(c120v0)
    do return end
  end
  OnInvalidBinError = v171
  v171 = function()
    local c124v0, c124v1, c124v2, c124v3, c124v4, c124v5
    c124v0 = v25
    c124v0 = c124v0.GetColor
    c124v1 = 6
    c124v2 = true
    c124v0 = c124v0(c124v1, c124v2)
    c124v1 = v25
    c124v1 = c124v1.GetColor
    c124v2 = 9
    c124v3 = true
    c124v1 = c124v1(c124v2, c124v3)
    c124v2 = mMovie
    c124v4 = "SellList.Tip"
    c124v5 = 11
    c124v2:SetNumberVariable(c124v4, c124v5, c124v1)
    c124v2 = mMovie
    c124v4 = "SellList.Total"
    c124v5 = 11
    c124v2:SetNumberVariable(c124v4, c124v5, c124v0)
    c124v2 = mMovie
    c124v4 = "SellList.TopLine"
    c124v5 = 11
    c124v2:SetNumberVariable(c124v4, c124v5, c124v1)
    c124v2 = mMovie
    c124v4 = "SellList.BottomLine"
    c124v5 = 11
    c124v2:SetNumberVariable(c124v4, c124v5, c124v1)
    c124v2 = mMovie
    c124v4 = "SellList.BottomLine2"
    c124v5 = 11
    c124v2:SetNumberVariable(c124v4, c124v5, c124v1)
    c124v2 = mMovie
    c124v4 = "SellList.SimulacrumSeparator"
    c124v5 = 11
    c124v2:SetNumberVariable(c124v4, c124v5, c124v1)
    c124v2 = v139
    c124v3 = 0
    c124v2(c124v3)
    c124v3 = v44
    c124v2 = IsNull
    c124v2 = c124v2(c124v3)
    if not c124v2 then
      c124v2 = v44
      c124v2:UpdateColors()
    end
    c124v3 = v63
    c124v2 = IsNull
    c124v2 = c124v2(c124v3)
    if not c124v2 then
      c124v2 = v63
      c124v2:UpdateColors()
    end
    c124v3 = v45
    c124v2 = IsNull
    c124v2 = c124v2(c124v3)
    if not c124v2 then
      c124v3 = v45
      c124v3 = c124v3.mScrollBar
      c124v2 = IsNull
      c124v2 = c124v2(c124v3)
      if not c124v2 then
        c124v2 = v45
        c124v2 = c124v2.mScrollBar
        c124v2:RedrawScrollBar()
      end
      c124v2 = v45
      c124v4 = function(c121v0)
        local c121v1, c121v2, c121v3, c121v4
        c121v1 = v45
        c121v2 = c121v0
        c121v4 = v45
        c121v4 = c121v4:GetFocusedElement()
        if c121v0 ~= c121v4 then
          c121v3 = false
        else
          c121v3 = true
        end
        c121v1:UpdateColors(c121v2, c121v3)
        do return end
      end
      c124v2:RunForAllVisibleElements(c124v4)
    end
    c124v3 = v43
    c124v2 = IsNull
    c124v2 = c124v2(c124v3)
    if not c124v2 then
      c124v2 = v43
      c124v4 = function(c122v0)
        local c122v1, c122v2, c122v3, c122v4
        c122v1 = v43
        c122v2 = c122v0
        c122v4 = v43
        c122v4 = c122v4:GetFocusedElement()
        if c122v0 ~= c122v4 then
          c122v3 = false
        else
          c122v3 = true
        end
        c122v1:UpdateColors(c122v2, c122v3)
        do return end
      end
      c124v2:RunForAllVisibleElements(c124v4)
      c124v3 = v43
      c124v3 = c124v3.mScrollBar
      c124v2 = IsNull
      c124v2 = c124v2(c124v3)
      if not c124v2 then
        c124v2 = v43
        c124v2 = c124v2.mScrollBar
        c124v2:RedrawScrollBar()
      end
      c124v3 = v43
      c124v3 = c124v3.mSortMenu
      c124v2 = IsNull
      c124v2 = c124v2(c124v3)
      if not c124v2 then
        c124v2 = v43
        c124v2 = c124v2.mSortMenu
        c124v2:UpdateColors()
      end
      c124v3 = v43
      c124v3 = c124v3.mCategoryMenu
      c124v2 = IsNull
      c124v2 = c124v2(c124v3)
      if not c124v2 then
        c124v2 = v43
        c124v2 = c124v2.mCategoryMenu
        c124v4 = function(c123v0)
          local c123v1
          c123v1 = v43
          c123v1 = c123v1.mCategoryMenu
          c123v1:UpdateColors(c123v0)
          do return end
        end
        c124v2:RunForAllElements(c124v4)
      end
    end
    do return end
  end
  v172 = function(c125v0)
    local c125v1, c125v2, c125v3, c125v4, c125v5, c125v6
    c125v3 = 1
    c125v1 = #c125v0
    c125v2 = 1
    for __renovice_for_0_0 = c125v3, c125v1, c125v2 do
      c125v4 = v11
      c125v5 = c125v0[__renovice_for_0_0]
      c125v5 = c125v5.type
      c125v5 = c125v5:GetFullName()
      c125v6 = c125v0[__renovice_for_0_0]
      c125v6 = c125v6.scans
      c125v4[c125v5] = c125v6
    end
    do return end
  end
  v115 = function()
    local c126v0, c126v1, c126v2, c126v3, c126v4, c126v5, c126v6, c126v7, c126v8, c126v9, c126v10
    c126v0 = Symbol
    c126v1 = "TENNO_TEAM"
    c126v0 = c126v0(c126v1)
    c126v1 = Symbol
    c126v2 = "TENNO"
    c126v1 = c126v1(c126v2)
    c126v2 = gRegion
    c126v4 = gAvatarType
    c126v2 = c126v2:FindAll(c126v4)
    c126v3 = ipairs
    c126v3, c126v4, c126v5 = c126v3(c126v2)
    for __renovice_for_0_0, __renovice_for_0_1 in c126v3, c126v4, c126v5 do
      c126v6 = __renovice_for_0_1:GetAgent()
      c126v7 = IsNull
      c126v7 = c126v7(c126v6)
      if not c126v7 then
        c126v7 = c126v6:GetTeam()
        if c126v7 ~= c126v0 then
          c126v7 = __renovice_for_0_1:GetFaction()
          if c126v7 ~= c126v1 then
            c126v9 = _T.PauseAI
            c126v10 = v19
            c126v6:SetPaused(c126v9, c126v10)
          end
        end
      end
      c126v7 = __renovice_for_0_1:DamageControl()
      c126v8 = IsNull
      c126v8 = c126v8(c126v7)
      if not c126v8 then
        c126v10 = Name__555ba103
        c126v8 = c126v7:IsA(c126v10)
        if not c126v8 then
          c126v8 = _T.PauseAI
          if c126v8 then
            c126v10 = false
            c126v7:Name__7da00f42(c126v10)
          else
            c126v10 = true
            c126v7:Name__7da00f42(c126v10)
          end
        end
      end
      __renovice_for_0_1 = nil
    end
    c126v3 = _T.PauseAI
    if c126v3 then
      c126v3 = v8
      c126v5 = false
      c126v3:Enable(c126v5)
      do return end
    end
    c126v3 = v8
    c126v5 = true
    c126v3:Enable(c126v5)
    c126v3 = _T.SpawnEnemyPursuePlayer
    if c126v3 then
      c126v3 = v8
      c126v5 = gRegion
      c126v3:Name__89f44a57(c126v5:GetLocalPlayerAvatar())
      do return end
    end
    c126v3 = v8
    c126v5 = gRegion
    c126v3:Name__ae3a6128(c126v5:GetLocalPlayerAvatar())
    do return end
  end
  v116 = function()
    local c127v0, c127v1, c127v2, c127v3, c127v4, c127v5, c127v6, c127v7, c127v8, c127v9, c127v10, c127v11, c127v12
    c127v0 = gRegion
    c127v2 = gLotusAvatarType
    c127v0 = c127v0:FindAll(c127v2)
    c127v1 = 0
    c127v4 = 1
    c127v2 = #c127v0
    c127v3 = 1
    for __renovice_for_0_0 = c127v4, c127v2, c127v3 do
      c127v6 = c127v0[__renovice_for_0_0]
      c127v5 = IsNull
      c127v5 = c127v5(c127v6:Name__2d897740())
      if c127v5 then
        continue
      end
      c127v5 = c127v0[__renovice_for_0_0]
      c127v7 = gLotusOperatorAvatarType
      c127v5 = c127v5:IsA(c127v7)
      if c127v5 then
        continue
      end
      c127v5 = c127v0[__renovice_for_0_0]
      c127v5 = c127v5:Name__2d897740()
      c127v6 = _T.FriendlyFire
      if c127v6 then
        c127v6 = Symbol
        c127v8 = "Enemy"
        c127v9 = tostring
        c127v9 = c127v9(c127v1)
        c127v7 = c127v8 .. c127v9
        c127v6 = c127v6(c127v7)
        c127v7 = c127v0[__renovice_for_0_0]
        c127v7:SetFaction(c127v6)
        c127v9 = 1
        c127v7 = c127v5:GetPlayerAvatar(c127v9)
        c127v8 = IsNull
        c127v8 = c127v8(c127v7)
        if not c127v8 then
          c127v7:SetFaction(c127v6)
        end
        c127v8 = c127v0[__renovice_for_0_0]
        c127v8 = c127v8:InventoryControl()
        c127v9 = IsNull
        c127v9 = c127v9(c127v8)
        if not c127v9 then
          c127v9 = c127v8:GetCompanion()
          c127v10 = IsNull
          c127v10 = c127v10(c127v9)
          if not c127v10 then
            c127v9:SetFaction(c127v6)
          end
        end
        c127v1 = c127v1 + 1
        continue
      end
      c127v6 = c127v0[__renovice_for_0_0]
      c127v8 = Symbol
      c127v9 = "TENNO"
      c127v6:SetFaction(c127v8(c127v9))
      c127v8 = 1
      c127v6 = c127v5:GetPlayerAvatar(c127v8)
      c127v7 = IsNull
      c127v7 = c127v7(c127v6)
      if not c127v7 then
        c127v9 = Symbol
        c127v10 = "TENNO"
        c127v6:SetFaction(c127v9(c127v10))
      end
      c127v7 = c127v0[__renovice_for_0_0]
      c127v7 = c127v7:InventoryControl()
      c127v8 = IsNull
      c127v8 = c127v8(c127v7)
      if c127v8 then
        continue
      end
      c127v8 = c127v7:GetCompanion()
      c127v9 = IsNull
      c127v9 = c127v9(c127v8)
      if c127v9 then
        continue
      end
      c127v11 = Symbol
      c127v12 = "TENNO"
      c127v8:SetFaction(c127v11(c127v12))
    end
    c127v2 = gRegion
    c127v4 = gLotusNpcAvatarType
    c127v2 = c127v2:FindAll(c127v4)
    c127v5 = 1
    c127v3 = #c127v2
    c127v4 = 1
    for __renovice_for_1_0 = c127v5, c127v3, c127v4 do
      c127v6 = c127v2[__renovice_for_1_0]
      c127v6 = c127v6:Name__72b9621b()
      c127v7 = IsNull
      c127v7 = c127v7(c127v6)
      if c127v7 then
        continue
      end
      c127v7 = c127v2[__renovice_for_1_0]
      c127v7:SetFaction(c127v6:GetOriginalFaction())
    end
    do return end
  end
  v117 = function()
    local c128v0, c128v1
    c128v0 = _T.SimulateHardMode
    if c128v0 then
      c128v0 = gGameRules
      c128v1 = v106
      c128v0:AddActiveLevelAuraUpgrade(c128v1)
      do return end
    end
    c128v0 = gGameRules
    c128v1 = v106
    c128v0:RemoveActiveLevelAuraUpgrade(c128v1)
    do return end
  end
  v118 = function()
    do return end
  end
  v173 = function()
    local c140v0, c140v1, c140v2, c140v3, c140v4, c140v5, c140v6, c140v7, c140v8, c140v9, c140v10
    local __renovice_local_0 = gPlayerProfileMgr
    local __renovice_local_1 = IsNull
    __renovice_local_1 = __renovice_local_1(__renovice_local_0)
    if __renovice_local_1 then
      do return end
    end
    __renovice_local_0 = v10
    __renovice_local_1 = IsNull
    __renovice_local_1 = __renovice_local_1(__renovice_local_0)
    if not __renovice_local_1 then
      repeat
        __renovice_local_1 = 50
        v18 = __renovice_local_1
        __renovice_local_1 = v12
        if not __renovice_local_1 then
          __renovice_local_1 = gGameData
          __renovice_local_1 = __renovice_local_1:IsStaff()
          if not __renovice_local_1 then
            __renovice_local_1 = gRegion
            __renovice_local_1 = __renovice_local_1:GetLocalPlayerAvatar()
            __renovice_local_0 = IsNull
            __renovice_local_0 = __renovice_local_0(__renovice_local_1)
            if not __renovice_local_0 then
              __renovice_local_0 = __renovice_local_1:GetPlayer()
              c140v0 = IsNull
              c140v0 = c140v0(__renovice_local_0)
              if not c140v0 then
                c140v1 = 30
                c140v3 = 5
                c140v4 = __renovice_local_0:GetPlayerRank()
                c140v2 = c140v3 * c140v4
                c140v0 = c140v1 + c140v2
                v18 = c140v0
              end
            end
            __renovice_local_0 = v24
            __renovice_local_0 = __renovice_local_0.GetSanitizedLevelName
            c140v0 = gRegion
            c140v0 = c140v0:GetLevel()
            __renovice_local_0 = __renovice_local_0(c140v0:GetFullName())
            if __renovice_local_0 == nil then break end
            c140v0 = ipairs
            c140v1 = simulacrumLevelsToCap
            c140v0, c140v1, c140v2 = c140v0(c140v1)
            for __renovice_for_0_0, __renovice_for_0_1 in c140v0, c140v1, c140v2 do
              c140v5 = IsNull
              c140v5 = c140v5(__renovice_for_0_1)
              if c140v5 then
                continue
              end
              c140v5 = v24
              c140v5 = c140v5.GetSanitizedLevelName
              c140v6 = __renovice_for_0_1:GetFullName()
              c140v7 = true
              c140v5 = c140v5(c140v6, c140v7)
              if __renovice_local_0 ~= c140v5 then
                continue
              end
              c140v5 = v18
              c140v5 = c140v5 + 25
              v18 = c140v5
              break
            end
            break
          end
        end
        __renovice_local_1 = 5000
        v18 = __renovice_local_1
      until true
      __renovice_local_0 = 10
      c140v0 = v18
      __renovice_local_1 = math.max
      __renovice_local_1 = __renovice_local_1(__renovice_local_0, c140v0)
      v18 = __renovice_local_1
      __renovice_local_1 = v10
      __renovice_local_1 = __renovice_local_1:Name__c34e001d()
      __renovice_local_0 = _T
      c140v0 = v24
      c140v0 = c140v0.Ternary
      c140v1 = IsNull
      c140v1 = c140v1(__renovice_local_1)
      if not c140v1 then
        if __renovice_local_1 ~= "" then
          c140v1 = false
        else
          c140v1 = true
        end
      end
      c140v2 = 20
      c140v0 = c140v0(c140v1, c140v2, __renovice_local_1)
      __renovice_local_0.SelectedEnemyLevel = c140v0
      c140v0 = _T.SelectedEnemyLevel
      c140v1 = v18
      __renovice_local_0 = math.min
      __renovice_local_0 = __renovice_local_0(c140v0, c140v1)
      v16 = __renovice_local_0
      __renovice_local_0 = v10
      __renovice_local_0 = __renovice_local_0:Name__c2dcd728()
      c140v0 = _T
      c140v1 = v24
      c140v1 = c140v1.Ternary
      c140v2 = IsNull
      c140v2 = c140v2(__renovice_local_0)
      c140v3 = false
      c140v1 = c140v1(c140v2, c140v3, __renovice_local_0)
      c140v0.PauseAI = c140v1
      c140v0 = v115
      c140v0()
      c140v0 = v10
      c140v0 = c140v0:Name__55bd8feb()
      c140v1 = _T
      c140v2 = v24
      c140v2 = c140v2.Ternary
      c140v3 = IsNull
      c140v3 = c140v3(c140v0)
      c140v4 = false
      c140v2 = c140v2(c140v3, c140v4, c140v0)
      c140v1.warframesInvincible = c140v2
      c140v1 = v10
      c140v1 = c140v1:Name__767bc256()
      c140v2 = _T
      c140v3 = v24
      c140v3 = c140v3.Ternary
      c140v4 = IsNull
      c140v4 = c140v4(c140v1)
      c140v5 = false
      c140v3 = c140v3(c140v4, c140v5, c140v1)
      c140v2.companionsInvincible = c140v3
      c140v2 = v10
      c140v2 = c140v2:Name__29cfa72e()
      c140v3 = _T
      c140v4 = v24
      c140v4 = c140v4.Ternary
      c140v5 = IsNull
      c140v5 = c140v5(c140v2)
      c140v6 = false
      c140v4 = c140v4(c140v5, c140v6, c140v2)
      c140v3.FriendlyFire = c140v4
      c140v3 = v116
      c140v3()
      c140v3 = v10
      c140v3 = c140v3:Name__c0ac032d()
      c140v4 = _T
      c140v5 = v24
      c140v5 = c140v5.Ternary
      c140v6 = IsNull
      c140v6 = c140v6(c140v3)
      c140v7 = false
      c140v5 = c140v5(c140v6, c140v7, c140v3)
      c140v4.SimulateHardMode = c140v5
      c140v4 = v117
      c140v4()
      c140v4 = v10
      c140v4 = c140v4:Name__589556a7()
      c140v5 = IsNull
      c140v5 = c140v5(c140v4)
      if not c140v5 then
        c140v5 = _T
        c140v6 = {}
        c140v5.SpawnedEnemies = c140v6
        c140v7 = 1
        c140v5 = #c140v4
        c140v6 = 1
        for __renovice_for_1_0 = c140v7, c140v5, c140v6 do
          c140v8 = _T.SpawnedEnemies
          c140v9 = { Type = nil, SourceType = nil, Count = nil }
          c140v10 = c140v4[__renovice_for_1_0]
          c140v10 = c140v10.enemyType
          c140v9.Type = c140v10
          c140v10 = c140v4[__renovice_for_1_0]
          c140v10 = c140v10.resourceType
          c140v9.SourceType = c140v10
          c140v10 = c140v4[__renovice_for_1_0]
          c140v10 = c140v10.enemyAmount
          c140v9.Count = c140v10
          c140v8[__renovice_for_1_0] = c140v9
        end
      end
    end
    __renovice_local_0 = v77
    c140v0 = { PressedCallback = "EnemyLevelSelected", GetName = nil }
    c140v1 = function()
      local c130v0, c130v1, c130v2, c130v3, c130v4, c130v5, c130v6
      c130v4 = mMovie
      c130v5 = "/Lotus/Language/Menu/EnemySelector_EnemyLevel"
      c130v6 = false
      c130v1 = c130v4:GetLocalized(c130v5, c130v6)
      c130v2 = " "
      c130v3 = v16
      c130v0 = c130v1 .. c130v2 .. c130v3
      do return c130v0 end
    end
    c140v0.GetName = c140v1
    __renovice_local_1 = table.insert
    __renovice_local_1(__renovice_local_0, c140v0)
    __renovice_local_1 = _T.InSimulacrum
    if __renovice_local_1 then
      __renovice_local_1 = gRegion
      __renovice_local_1 = __renovice_local_1:IsMaster()
      if __renovice_local_1 then
        repeat
          __renovice_local_0 = v77
          c140v0 = { PressedCallback = "TogglePauseAI", GetName = nil }
          c140v1 = function()
            local c131v0, c131v1, c131v2, c131v3
            c131v0 = v24
            c131v0 = c131v0.Ternary
            c131v1 = _T.PauseAI
            c131v2 = "/Lotus/Language/Menu/Simulacrum_PauseAI"
            c131v3 = "/Lotus/Language/Menu/Simulacrum_NoPauseAI"
            do return c131v0(c131v1, c131v2, c131v3) end
          end
          c140v0.GetName = c140v1
          __renovice_local_1 = table.insert
          __renovice_local_1(__renovice_local_0, c140v0)
          __renovice_local_0 = gGameRules
          __renovice_local_1 = IsNull
          __renovice_local_1 = __renovice_local_1(__renovice_local_0)
          if not __renovice_local_1 then
            __renovice_local_1 = gGameRules
            c140v0 = gLotusPhotoBoothGameRulesType
            __renovice_local_1 = __renovice_local_1:IsA(c140v0)
            if __renovice_local_1 then
              __renovice_local_1 = _T.SpawnEnemyPursuePlayer
              if __renovice_local_1 == nil then
                __renovice_local_1 = _T
                __renovice_local_0 = true
                __renovice_local_1.SpawnEnemyPursuePlayer = __renovice_local_0
              end
              __renovice_local_1 = _T.SpawnEnemyAttackPlayer
              if __renovice_local_1 == nil then
                __renovice_local_1 = _T
                __renovice_local_0 = true
                __renovice_local_1.SpawnEnemyAttackPlayer = __renovice_local_0
              end
              __renovice_local_1 = _T.SpawnEnemyAtAimPos
              if __renovice_local_1 == nil then
                __renovice_local_1 = _T
                __renovice_local_0 = true
                __renovice_local_1.SpawnEnemyAtAimPos = __renovice_local_0
              end
              __renovice_local_0 = v77
              c140v0 = { PressedCallback = "ToggleSpawnAtCameraPos", GetName = nil }
              c140v1 = function()
                local c132v0, c132v1, c132v2, c132v3
                c132v0 = v24
                c132v0 = c132v0.Ternary
                c132v1 = _T.SpawnEnemyAtCameraPos
                c132v2 = "/Lotus/Language/Photobooth/PhotoboothSpawnAtCameraPos"
                c132v3 = "/Lotus/Language/Photobooth/PhotoboothSpawnAtCameraPosOff"
                do return c132v0(c132v1, c132v2, c132v3) end
              end
              c140v0.GetName = c140v1
              __renovice_local_1 = table.insert
              __renovice_local_1(__renovice_local_0, c140v0)
              __renovice_local_0 = v77
              c140v0 = { PressedCallback = "ToggleSpawnAtAimPos", GetName = nil }
              c140v1 = function()
                local c133v0, c133v1, c133v2, c133v3
                c133v0 = v24
                c133v0 = c133v0.Ternary
                c133v1 = _T.SpawnEnemyAtAimPos
                c133v2 = "/Lotus/Language/Photobooth/PhotoboothSpawnAtAimPos"
                c133v3 = "/Lotus/Language/Photobooth/PhotoboothSpawnAtAimPosOff"
                do return c133v0(c133v1, c133v2, c133v3) end
              end
              c140v0.GetName = c140v1
              __renovice_local_1 = table.insert
              __renovice_local_1(__renovice_local_0, c140v0)
              __renovice_local_0 = v77
              c140v0 = { PressedCallback = "ToggleSpawnEnemyAttackPlayer", GetName = nil }
              c140v1 = function()
                local c134v0, c134v1, c134v2, c134v3
                c134v0 = v24
                c134v0 = c134v0.Ternary
                c134v1 = _T.SpawnEnemyAttackPlayer
                c134v2 = "/Lotus/Language/Photobooth/PhotoboothSpawnEnemyAttackPlayer"
                c134v3 = "/Lotus/Language/Photobooth/PhotoboothSpawnEnemyAttackPlayerOff"
                do return c134v0(c134v1, c134v2, c134v3) end
              end
              c140v0.GetName = c140v1
              __renovice_local_1 = table.insert
              __renovice_local_1(__renovice_local_0, c140v0)
              __renovice_local_0 = v77
              c140v0 = { PressedCallback = "ToggleSpawnEnemyPursuePlayer", GetName = nil }
              c140v1 = function()
                local c135v0, c135v1, c135v2, c135v3
                c135v0 = v24
                c135v0 = c135v0.Ternary
                c135v1 = _T.SpawnEnemyPursuePlayer
                c135v2 = "/Lotus/Language/Photobooth/PhotoboothSpawnEnemyPursuePlayer"
                c135v3 = "/Lotus/Language/Photobooth/PhotoboothSpawnEnemyPursuePlayerOff"
                do return c135v0(c135v1, c135v2, c135v3) end
              end
              c140v0.GetName = c140v1
              __renovice_local_1 = table.insert
              __renovice_local_1(__renovice_local_0, c140v0)
              break
            end
          end
          local __renovice_state_0 = -1
          __renovice_local_0 = gGameRules
          __renovice_local_1 = IsNull
          __renovice_local_1 = __renovice_local_1(__renovice_local_0)
          if __renovice_local_1 then
            __renovice_state_0 = 2
          else
            __renovice_state_0 = 1
          end
          if __renovice_state_0 == 1 then
            __renovice_local_1 = gGameRules
            c140v0 = gLotusPhotoBoothGameRulesType
            __renovice_local_1 = __renovice_local_1:IsA(c140v0)
            if __renovice_local_1 then
              __renovice_state_0 = -1
            else
              __renovice_state_0 = 2
            end
          end
          if __renovice_state_0 == 2 then
            __renovice_local_0 = v77
            c140v0 = { PressedCallback = "ToggleInvincibility", GetName = nil }
            c140v1 = function()
              local c136v0, c136v1, c136v2, c136v3
              c136v0 = v24
              c136v0 = c136v0.Ternary
              c136v1 = _T.warframesInvincible
              c136v2 = "/Lotus/Language/Menu/Loadout_Simulacrum_Invincibility"
              c136v3 = "/Lotus/Language/Menu/Loadout_Simulacrum_NoInvincibility"
              do return c136v0(c136v1, c136v2, c136v3) end
            end
            c140v0.GetName = c140v1
            __renovice_local_1 = table.insert
            __renovice_local_1(__renovice_local_0, c140v0)
            __renovice_local_0 = v77
            c140v0 = { PressedCallback = "ToggleCompanionInvincibility", GetName = nil }
            c140v1 = function()
              local c137v0, c137v1, c137v2, c137v3
              c137v0 = v24
              c137v0 = c137v0.Ternary
              c137v1 = _T.companionsInvincible
              c137v2 = "/Lotus/Language/Menu/Loadout_Simulacrum_Companion_Invincibility"
              c137v3 = "/Lotus/Language/Menu/Loadout_Simulacrum_Companion_NoInvincibility"
              do return c137v0(c137v1, c137v2, c137v3) end
            end
            c140v0.GetName = c140v1
            __renovice_local_1 = table.insert
            __renovice_local_1(__renovice_local_0, c140v0)
            __renovice_local_0 = v77
            c140v0 = { PressedCallback = "ToggleFriendlyFire", GetName = nil }
            c140v1 = function()
              local c138v0, c138v1, c138v2, c138v3
              c138v0 = v24
              c138v0 = c138v0.Ternary
              c138v1 = _T.FriendlyFire
              c138v2 = "/Lotus/Language/Menu/Simulacrum_FriendlyFire"
              c138v3 = "/Lotus/Language/Menu/Simulacrum_NoFriendlyFire"
              do return c138v0(c138v1, c138v2, c138v3) end
            end
            c140v0.GetName = c140v1
            __renovice_local_1 = table.insert
            __renovice_local_1(__renovice_local_0, c140v0)
            __renovice_local_1 = v23
            __renovice_local_1 = __renovice_local_1.HasUnlockedHardMode
            __renovice_local_1 = __renovice_local_1()
            if not __renovice_local_1 then
              __renovice_state_0 = -1
            else
              __renovice_state_0 = 3
            end
          end
          if __renovice_state_0 == 3 then
            __renovice_local_0 = v77
            c140v0 = { PressedCallback = "ToggleHardMode", GetName = nil }
            c140v1 = function()
              local c139v0, c139v1, c139v2, c139v3
              c139v0 = v24
              c139v0 = c139v0.Ternary
              c139v1 = _T.SimulateHardMode
              c139v2 = "/Lotus/Language/Settings/Simulacrum_HardMode"
              c139v3 = "/Lotus/Language/Settings/Simulacrum_NoHardMode"
              do return c139v0(c139v1, c139v2, c139v3) end
            end
            c140v0.GetName = c140v1
            __renovice_local_1 = table.insert
            __renovice_local_1(__renovice_local_0, c140v0)
            __renovice_state_0 = -1
          end
        until true
      end
    end
    __renovice_local_1 = 475
    c140v1 = 1
    c140v2 = v77
    __renovice_local_0 = #c140v2
    c140v0 = 1
    for __renovice_for_2_0 = c140v1, __renovice_local_0, c140v0 do
      c140v2 = v77[__renovice_for_2_0]
      c140v4 = "SellList.OptionalButton"
      c140v3 = c140v4 .. __renovice_for_2_0
      c140v4 = mMovie
      c140v4 = c140v4:HasVariable(c140v3)
      if not c140v4 then
        c140v4 = FlashMethod
        c140v5 = mMovie
        c140v6 = "SellList.OptionalButton1.duplicateMovieClip"
        c140v8 = "OptionalButton"
        c140v7 = c140v8 .. __renovice_for_2_0
        c140v8 = __renovice_for_2_0 + 6000
        c140v4(c140v5, c140v6, c140v7, c140v8)
      end
      c140v4 = mMovie
      c140v7 = 1
      c140v4:SetNumberVariable(c140v3, c140v7, __renovice_local_1)
      c140v4 = v31
      c140v4 = c140v4.Create
      c140v5 = mMovie
      c140v7 = c140v2.GetName
      c140v7 = c140v7()
      c140v8 = c140v2.PressedCallback
      c140v4 = c140v4(c140v5, c140v3, c140v7, c140v8)
      c140v2.mButton = c140v4
      c140v4 = c140v2.mButton
      c140v6 = "left"
      c140v4:SetTextAlignment(c140v6)
      c140v4 = c140v2.mButton
      c140v6 = 350
      c140v4:SetMinWidth(c140v6)
      __renovice_local_1 = __renovice_local_1 - 32
    end
    __renovice_local_0 = FlashMethod
    c140v0 = mMovie
    c140v1 = "SellList.BottomLine.duplicateMovieClip"
    c140v2 = "SimulacrumSeparator"
    c140v3 = 6000
    __renovice_local_0(c140v0, c140v1, c140v2, c140v3)
    __renovice_local_0 = mMovie
    c140v1 = "SellList.SimulacrumSeparator"
    c140v2 = 1
    c140v3 = __renovice_local_1 + 17
    __renovice_local_0:SetNumberVariable(c140v1, c140v2, c140v3)
    __renovice_local_0 = v26
    __renovice_local_0 = __renovice_local_0.DrawSeparator
    c140v0 = mMovie
    c140v1 = "SellList.SimulacrumSeparator"
    c140v2 = 380
    __renovice_local_0(c140v0, c140v1, c140v2)
    __renovice_local_0 = mMovie
    c140v1 = "SellList.Tip"
    c140v2 = 1
    c140v5 = mMovie
    c140v7 = "SellList.SimulacrumSeparator"
    c140v8 = 1
    c140v5 = c140v5:GetNumberVariable(c140v7, c140v8)
    c140v6 = mMovie
    c140v8 = "SellList.TopLine"
    c140v9 = 1
    c140v6 = c140v6:GetNumberVariable(c140v8, c140v9)
    c140v4 = c140v5 + c140v6
    c140v3 = c140v4 / 2
    __renovice_local_0:SetNumberVariable(c140v1, c140v2, c140v3)
    c140v1 = mMovie
    c140v3 = "SellList.SimulacrumSeparator"
    c140v4 = 1
    c140v1 = c140v1:GetNumberVariable(c140v3, c140v4)
    c140v2 = mMovie
    c140v4 = "SellList.TopLine"
    c140v5 = 1
    c140v2 = c140v2:GetNumberVariable(c140v4, c140v5)
    c140v0 = c140v1 - c140v2
    __renovice_local_0 = c140v0 - 26
    v66 = __renovice_local_0
    do return end
  end
  v174 = function()
    local c143v0, c143v1, c143v2, c143v3, c143v4, c143v5, c143v6, c143v7
    c143v0 = mMovie
    c143v2 = "/Lotus/Language/Menu/SearchPrompt"
    c143v3 = false
    c143v0 = c143v0:GetLocalized(c143v2, c143v3)
    c143v1 = require
    c143v2 = "Lotus.Interface.Components.ThemedInputField"
    c143v1 = c143v1(c143v2)
    c143v2 = c143v1.Create
    c143v3 = mMovie
    c143v4 = "SearchAndSort.SearchBox"
    c143v5 = nil
    c143v6 = nil
    c143v7 = "<MENU_LTHUMB>"
    c143v2 = c143v2(c143v3, c143v4, c143v5, c143v6, c143v7)
    v63 = c143v2
    c143v2 = v63
    c143v4 = v63
    c143v4 = c143v4.TYPE
    c143v4 = c143v4.PLAIN
    c143v2:SetType(c143v4, c143v0, c143v0)
    c143v2 = v63
    c143v3 = 200
    c143v2.mMinSize = c143v3
    c143v2 = v63
    c143v3 = 200
    c143v2.mMaxSize = c143v3
    c143v2 = v63
    c143v3 = 4
    c143v2.mTextBuffer = c143v3
    c143v2 = v63
    c143v3 = _G
    c143v3 = c143v3.UITexture_Search
    c143v2.mAltButtonIcon = c143v3
    c143v2 = v63
    c143v3 = true
    c143v2.mAltButtonVisible = c143v3
    c143v2 = v63
    c143v3 = nil
    c143v2.mUnfocusedUnderlineColorOverride = c143v3
    c143v2 = v63
    c143v3 = v63
    c143v3 = c143v3.InputFieldTextChanged
    c143v2.BaseInputFieldTextChanged = c143v3
    c143v2 = v63
    c143v3 = function(c141v0, c141v1)
      local c141v2, c141v3, c141v4, c141v5, c141v6, c141v7, c141v8, c141v9
      local __renovice_state_0 = 0
      c141v2 = c141v0.mLabel
      c141v3 = _T.CapturaListBindings
      if not c141v3 then
        __renovice_state_0 = 2
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c141v1 = ""
        __renovice_state_0 = 2
      end
      if __renovice_state_0 == 2 then
        c141v0:BaseInputFieldTextChanged(c141v1)
        c141v4 = c141v0.mLabel
        if c141v4 ~= "" then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        c141v3 = _G
        c141v3 = c141v3.UITexture_Search
        if c141v3 then
          __renovice_state_0 = 5
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c141v3 = _G
        c141v3 = c141v3.UITexture_ClearSearch
        __renovice_state_0 = 5
      end
      if __renovice_state_0 == 5 then
        c141v4 = c141v0.mAltButtonicon
        if c141v4 == c141v3 then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        c141v0.mAltButtonicon = c141v3
        c141v4 = c141v0.mMovie
        c141v7 = c141v0.mClipName
        c141v8 = ".BtnAlt"
        c141v6 = c141v7 .. c141v8
        c141v4:OverrideTexture(c141v6, c141v3)
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 7 then
        c141v4 = false
        c141v5 = c141v0.mLabel
        if c141v5 == nil then
          __renovice_state_0 = 11
        else
          __renovice_state_0 = 8
        end
      end
      if __renovice_state_0 == 8 then
        c141v5 = c141v0.mLabel
        if c141v5 ~= "" then
          __renovice_state_0 = 10
        else
          __renovice_state_0 = 9
        end
      end
      if __renovice_state_0 == 9 then
        c141v4 = false
        __renovice_state_0 = 11
      end
      if __renovice_state_0 == 10 then
        c141v4 = true
        __renovice_state_0 = 11
      end
      if __renovice_state_0 == 11 then
        c141v5 = v43
        if c141v5 == nil then
          __renovice_state_0 = 15
        else
          __renovice_state_0 = 12
        end
      end
      if __renovice_state_0 == 12 then
        if not c141v4 then
          __renovice_state_0 = 14
        else
          __renovice_state_0 = 13
        end
      end
      if __renovice_state_0 == 13 then
        c141v5 = v43
        c141v7 = c141v0.mLabel
        c141v5:SetSearchRankOnAllElements(c141v7)
        __renovice_state_0 = 15
      end
      if __renovice_state_0 == 14 then
        c141v5 = v43
        c141v5:ClearSearchRankOnAllElements()
        __renovice_state_0 = 15
      end
      if __renovice_state_0 == 15 then
        c141v5 = v40
        if c141v5 then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 16
        end
      end
      if __renovice_state_0 == 16 then
        c141v5 = c141v0.mLabel
        if c141v2 == c141v5 then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 17
        end
      end
      if __renovice_state_0 == 17 then
        c141v5 = v43
        if c141v5 == nil then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 18
        end
      end
      if __renovice_state_0 == 18 then
        c141v5 = v43
        c141v6 = true
        c141v5.mMuteGridOpenSound = c141v6
        c141v5 = v43
        c141v7 = nil
        c141v8 = true
        c141v9 = true
        c141v5:Redraw(c141v7, c141v8, c141v9)
        c141v5 = v43
        c141v6 = false
        c141v5.mMuteGridOpenSound = c141v6
        __renovice_state_0 = 19
      end
      if __renovice_state_0 == 19 then
        do return end
      end
      do return end
    end
    c143v2.InputFieldTextChanged = c143v3
    c143v2 = v63
    c143v3 = v63
    c143v3 = c143v3.OnGamepadTransition
    c143v2.BaseOnGamepadTransition = c143v3
    c143v2 = v63
    c143v3 = function(c142v0)
      local c142v1, c142v2, c142v3, c142v4, c142v5
      c142v0:BaseOnGamepadTransition()
      c142v2 = Engine.IsPlayingWithController
      c142v2 = c142v2()
      c142v1 = not c142v2
      c142v0.mAltButtonVisible = c142v1
      c142v2 = mMovie
      c142v3 = c142v0.mClipName
      c142v4 = "BtnAlt"
      c142v5 = 13
      c142v2:Makeposshield(c142v3, c142v4, c142v5, c142v1)
      do return end
    end
    c143v2.OnGamepadTransition = c143v3
    c143v2 = v63
    c143v4 = "/Lotus/Language/Menu/SearchPrompt"
    c143v2:SetHint(c143v4)
    c143v2 = v63
    c143v2:Redraw()
    do return end
  end
  v175 = function()
    local c144v0, c144v1, c144v2, c144v3, c144v4, c144v5, c144v6, c144v7
    c144v0 = require
    c144v1 = "Lotus.Interface.Libs.TimerMgr"
    c144v0 = c144v0(c144v1)
    c144v1 = c144v0.CreateTimerMgr
    c144v1 = c144v1()
    v37 = c144v1
    c144v1 = v21
    c144v1 = c144v1.Create
    c144v2 = mMovie
    c144v1 = c144v1(c144v2)
    v38 = c144v1
    c144v1 = v38
    c144v3 = mMovie
    c144v4 = "Categories"
    c144v6 = v38
    c144v6 = c144v6.ANCHOR_V_CENTRE
    c144v7 = v38
    c144v7 = c144v7.ANCHOR_H_LEFT
    c144v5 = {c144v6, c144v7}
    c144v1:Register(c144v3, c144v4, c144v5)
    c144v1 = v38
    c144v3 = mMovie
    c144v4 = "InventoryGrid"
    c144v6 = v38
    c144v6 = c144v6.ANCHOR_V_CENTRE
    c144v7 = v38
    c144v7 = c144v7.ANCHOR_H_LEFT
    c144v5 = {c144v6, c144v7}
    c144v1:Register(c144v3, c144v4, c144v5)
    c144v1 = v38
    c144v3 = mMovie
    c144v4 = "SellList"
    c144v6 = v38
    c144v6 = c144v6.ANCHOR_V_CENTRE
    c144v7 = v38
    c144v7 = c144v7.ANCHOR_H_RIGHT
    c144v5 = {c144v6, c144v7}
    c144v1:Register(c144v3, c144v4, c144v5)
    c144v1 = v38
    c144v3 = mMovie
    c144v4 = "InventoryGridScrollBar"
    c144v6 = v38
    c144v6 = c144v6.ANCHOR_V_CENTRE
    c144v7 = v38
    c144v7 = c144v7.ANCHOR_H_RIGHT
    c144v5 = {c144v6, c144v7}
    c144v1:Register(c144v3, c144v4, c144v5)
    c144v1 = v38
    c144v3 = mMovie
    c144v4 = "SearchAndSort"
    c144v6 = v38
    c144v6 = c144v6.ANCHOR_V_CENTRE
    c144v7 = v38
    c144v7 = c144v7.ANCHOR_H_RIGHT
    c144v5 = {c144v6, c144v7}
    c144v1:Register(c144v3, c144v4, c144v5)
    c144v1 = v38
    c144v3 = mMovie
    c144v3 = c144v3:GetViewportWidth()
    c144v4 = mMovie
    c144v1:Update(c144v3, c144v4:GetViewportHeight())
    do return end
  end
  v176 = function()
    local c145v0, c145v1, c145v2, c145v3, c145v4, c145v5, c145v6, c145v7
    local __renovice_state_0 = 0
    c145v0 = "/Lotus/Language/Menu/ItemInventory_Tip"
    c145v1 = v95
    c145v2 = v94
    c145v2 = c145v2.SHIP_SCRAP
    if c145v1 ~= c145v2 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c145v0 = "/Lotus/Language/Railjack/ItemInventory_SellingShipWreckageTip"
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 2 then
      c145v1 = v95
      c145v2 = v94
      c145v2 = c145v2.SHIP_PARTS
      if c145v1 ~= c145v2 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c145v0 = "/Lotus/Language/Railjack/ItemInventory_SellingShipComponentsTip"
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 4 then
      c145v1 = v95
      c145v2 = v94
      c145v2 = c145v2.SHIP_RAW
      if c145v1 ~= c145v2 then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 5
      end
    end
    if __renovice_state_0 == 5 then
      c145v0 = "/Lotus/Language/Railjack/ItemInventory_SellingShipUnidentifiedTip"
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 6 then
      c145v1 = v95
      c145v2 = v94
      c145v2 = c145v2.MODS_SKIP_LIST
      if c145v1 ~= c145v2 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c145v0 = "/Lotus/Language/ModFusion/ModQuickSelect_SelectSkippedMods"
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 8 then
      c145v1 = v95
      c145v2 = v94
      c145v2 = c145v2.ENEMIES
      if c145v1 ~= c145v2 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c145v0 = "/Lotus/Language/Menu/EnemySelector_Tip"
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 10 then
      c145v1 = v95
      c145v2 = v94
      c145v2 = c145v2.INVENTORY
      if c145v1 == c145v2 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c145v1 = v95
      c145v2 = v94
      c145v2 = c145v2.SHARDS
      if c145v1 ~= c145v2 then
        __renovice_state_0 = 14
      else
        __renovice_state_0 = 12
      end
    end
    if __renovice_state_0 == 12 then
      c145v0 = "/Lotus/Language/Labels/ItemInventory_SellTip"
      c145v1 = Engine.IsPlayingWithTouchscreen
      c145v1 = c145v1()
      if not c145v1 then
        __renovice_state_0 = 14
      else
        __renovice_state_0 = 13
      end
    end
    if __renovice_state_0 == 13 then
      c145v2 = "_Mobile"
      c145v0 = c145v0 .. c145v2
      __renovice_state_0 = 14
    end
    if __renovice_state_0 == 14 then
      c145v1 = mMovie
      c145v3 = "SellList.Tip"
      c145v4 = 36
      c145v5 = string.upper
      c145v6 = mMovie
      c145v7 = true
      c145v1:SetStringVariable(c145v3, c145v4, c145v5(c145v6:GetLocalized(c145v0, c145v7)))
      do return end
    end
    do return end
  end
  v177 = function()
    local c146v0, c146v1, c146v2, c146v3, c146v4, c146v5, c146v6, c146v7, c146v8, c146v9, c146v10, c146v11, c146v12, c146v13, c146v14, c146v15, c146v16, c146v17
    local __renovice_local_0 = v95
    c146v2 = v94
    c146v2 = c146v2.TRADE_ITEMS
    __renovice_local_0 = v95
    c146v2 = v94
    c146v2 = c146v2.ARCANE
    __renovice_local_0 = gGameData
    __renovice_local_0 = __renovice_local_0:GetInventory()
    c146v2 = v27
    c146v2 = c146v2.BuildInstalled
    c146v3 = v69
    c146v5 = 3
    c146v2(c146v3, __renovice_local_0, c146v5)
    c146v2 = v129
    c146v2 = c146v2()
    c146v2 = v22
    c146v2 = c146v2.GetShipDecoCategories
    c146v2 = c146v2()
    v109 = c146v2
    c146v3 = v95
    c146v4 = v94
    c146v4 = c146v4.FISH
    c146v3 = _T.FishInvInfo.ShowRep
    c146v3 = _T.SyndicateInvInfo
    c146v3 = _T.SyndicateInvInfo.Syndicate
    c146v4 = v92
    c146v5 = v32
    c146v5 = c146v5.Create
    c146v6 = mMovie
    local __renovice_local_1 = "SellList.SyndicateInfo"
    c146v7 = ""
    c146v8 = nil
    c146v9 = dailyStandingIcon
    c146v10 = nil
    c146v11 = nil
    c146v12 = nil
    c146v5 = c146v5(c146v6, __renovice_local_1, c146v7, c146v8, c146v9, c146v10, c146v11, c146v12)
    c146v4.SyndicateInfo = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = true
    c146v4.mSkipResize = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 0.15
    c146v4.mVerticalTextOffset = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 0.3
    c146v4.mBackerEdgeAlpha = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = true
    c146v4.mToUpper = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 64
    c146v4.mIconSize = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 80
    c146v4.mIconBorderSize = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = -4
    c146v4.mIconPaddingX = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = -4
    c146v4.mIconPaddingY = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 106
    c146v4.mIconToTextPadding = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 0.3
    c146v4.mBackerIconAlpha = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 0.9
    c146v4.mBackerAlpha = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = 80
    c146v4.mUnfocusedShadeAlpha = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = true
    c146v4.mShowIconHighlight = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v6 = 370
    c146v4:SetWidth(c146v6)
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = true
    c146v4.mExtendedProgressBar = c146v5
    c146v4 = v92
    c146v4 = c146v4.SyndicateInfo
    c146v5 = true
    c146v4.mSeamlessProgressBar = c146v5
    c146v4 = c146v3:GetIconTexture()
    c146v5 = v92
    c146v5 = c146v5.SyndicateInfo
    c146v6 = c146v3:GetLogoColor()
    c146v5.mIconColor = c146v6
    c146v5 = c146v3:GetBackgroundColor()
    c146v6 = v92
    c146v6 = c146v6.SyndicateInfo
    __renovice_local_1 = Color
    c146v8 = c146v5.red
    c146v7 = c146v8 / 1.5
    c146v9 = c146v5.green
    c146v8 = c146v9 / 1.5
    c146v10 = c146v5.blue
    c146v9 = c146v10 / 1.5
    __renovice_local_1 = __renovice_local_1(c146v7, c146v8, c146v9)
    c146v6.mIconBgColor = __renovice_local_1
    c146v6 = v92
    c146v6 = c146v6.SyndicateInfo
    c146v6.mIconBgExtra = c146v4
    c146v6 = v23
    c146v6 = c146v6.GetSyndicateBackgroundAlignments
    c146v6 = c146v6(c146v4:GetFullName())
    __renovice_local_1 = v92
    __renovice_local_1 = __renovice_local_1.SyndicateInfo
    c146v8 = c146v6.Scale
    c146v7 = c146v8 / 6
    __renovice_local_1.mIconBgExtraWidth = c146v7
    __renovice_local_1 = v92
    __renovice_local_1 = __renovice_local_1.SyndicateInfo
    c146v8 = c146v6.Scale
    c146v7 = c146v8 / 6
    __renovice_local_1.mIconBgExtraHeight = c146v7
    __renovice_local_1 = v92
    __renovice_local_1 = __renovice_local_1.SyndicateInfo
    c146v8 = c146v6.X
    c146v7 = c146v8 / 2
    __renovice_local_1.mIconBgExtraOffsetX = c146v7
    __renovice_local_1 = v92
    __renovice_local_1 = __renovice_local_1.SyndicateInfo
    c146v8 = c146v6.Y
    c146v7 = c146v8 / 2
    __renovice_local_1.mIconBgExtraOffsetY = c146v7
    __renovice_local_1 = v92
    __renovice_local_1 = __renovice_local_1.SyndicateInfo
    c146v7 = c146v6.Alpha
    __renovice_local_1.mIconBgExtraAlpha = c146v7
    __renovice_local_1 = v92
    __renovice_local_1 = __renovice_local_1.SyndicateInfo
    __renovice_local_1:SetIcons(c146v4)
    __renovice_local_1 = nil
    c146v7 = ipairs
    c146v7, c146v8, c146v9 = c146v7(c146v3:Name__1518e1cb())
    for __renovice_for_0_0, __renovice_for_0_1 in c146v7, c146v8, c146v9 do
      c146v12 = __renovice_for_0_1.level
      c146v13 = _T.SyndicateInvInfo.Level
      c146v2 = mMovie
      c146v4 = "SellList.OptionalButton1"
      c146v5 = 13
      __renovice_local_1 = v95
      c146v7 = v94
      c146v7 = c146v7.ENEMIES
      if __renovice_local_1 ~= c146v7 then
        c146v6 = false
      else
        c146v6 = true
      end
      c146v2:Name__d9713943(c146v4, c146v5, c146v6)
      c146v2 = mMovie
      c146v4 = "SellList.Total"
      c146v5 = 46
      c146v6 = "center"
      c146v2:SetStringVariable(c146v4, c146v5, c146v6)
      c146v2 = mMovie
      c146v4 = "SellList.Amount"
      c146v5 = 46
      c146v6 = "center"
      c146v2:SetStringVariable(c146v4, c146v5, c146v6)
      c146v2 = mMovie
      c146v4 = "SellList.List.Item"
      c146v5 = 13
      __renovice_local_1 = v129
      __renovice_local_1 = __renovice_local_1()
      c146v6 = not __renovice_local_1
      c146v2:Name__d9713943(c146v4, c146v5, c146v6)
      c146v2 = mMovie
      c146v4 = "SellList.GridItem"
      c146v5 = 13
      c146v6 = v129
      c146v2:Name__d9713943(c146v4, c146v5, c146v6())
      c146v2 = v33
      c146v2 = c146v2.CheckQuestCompletion
      c146v3 = sacrificeKeyChain
      c146v4 = false
      c146v2 = c146v2(c146v3, c146v4)
      c146v4 = _T.Arsenal_ForceUmbraUnlock
      c146v3 = c146v4 or c146v2
      v0 = c146v3
      c146v4 = _T.Arsenal_ForceUmbraSwordUnlock
      c146v3 = c146v4 or c146v2
      v1 = c146v3
      c146v3 = false
      v12 = c146v3
      c146v3 = false
      v13 = c146v3
      c146v3 = mMovie
      c146v5 = 0
      c146v3:SetBackgroundAlpha(c146v5)
      c146v3 = gFlashMgr
      c146v5 = "DisplayInWorldText"
      c146v6 = "false"
      c146v3:Name__788d33f3(c146v5, c146v6)
      c146v3 = v23
      c146v3 = c146v3.CacheWeaponXp
      c146v4 = true
      c146v3(c146v4)
      c146v3 = v95
      c146v4 = v94
      c146v4 = c146v4.SYNDDONATE
      c146v0 = v175
      c146v0()
      c146v0 = v26
      c146v1 = false
      c146v0.DisableTooltips = c146v1
      c146v0 = v34
      __renovice_local_0 = { name = "InventoryTest", instance = nil, anchorMgr = nil }
      c146v2 = mMovie
      __renovice_local_0.instance = c146v2
      c146v2 = v38
      __renovice_local_0.anchorMgr = c146v2
      c146v0 = c146v0:New(__renovice_local_0)
      v36 = c146v0
      c146v0 = v35
      __renovice_local_0 = { clipName = "Categories", movie = nil }
      c146v2 = v36
      __renovice_local_0.movie = c146v2
      c146v0:New(__renovice_local_0)
      c146v0 = v35
      __renovice_local_0 = { clipName = "InventoryGrid", movie = nil }
      c146v2 = v36
      __renovice_local_0.movie = c146v2
      c146v0:New(__renovice_local_0)
      c146v0 = v35
      __renovice_local_0 = { clipName = "SearchAndSort", movie = nil }
      c146v2 = v36
      __renovice_local_0.movie = c146v2
      c146v0 = c146v0:New(__renovice_local_0)
      c146v2 = v35
      c146v4 = { clipName = "SortMenu" }
      c146v0:AddComponent(c146v2:New(c146v4))
      c146v2 = v35
      c146v4 = { clipName = "SearchBox" }
      c146v0:AddComponent(c146v2:New(c146v4))
      c146v1 = v26
      c146v1 = c146v1.GetRegularCreditsStoreItem
      c146v1 = c146v1()
      v86 = c146v1
      c146v1 = "Inventory"
      __renovice_local_0 = _T.SelectingEnemies
      if __renovice_local_0 then
        __renovice_local_0 = v94
        __renovice_local_0 = __renovice_local_0.ENEMIES
        v95 = __renovice_local_0
        c146v1 = "Selecting Enemies"
      else
        c146v2 = _T.SelectingFishManifest
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c146v2)
        if not __renovice_local_0 then
          __renovice_local_0 = v94
          __renovice_local_0 = __renovice_local_0.FISH
          v95 = __renovice_local_0
          c146v1 = "Selecting Fish (Fishmonger)"
        else
          __renovice_local_0 = _T.SellingTreasure
          if __renovice_local_0 then
            __renovice_local_0 = v94
            __renovice_local_0 = __renovice_local_0.TREASURE
            v95 = __renovice_local_0
            c146v1 = "Selling Ayatan Treasures"
          else
            __renovice_local_0 = _T.SellingArcane
            if __renovice_local_0 then
              __renovice_local_0 = v94
              __renovice_local_0 = __renovice_local_0.ARCANE
              v95 = __renovice_local_0
              c146v1 = "Selling Arcanes"
            else
              __renovice_local_0 = _T.SellingShipUnidentified
              if __renovice_local_0 then
                __renovice_local_0 = v94
                __renovice_local_0 = __renovice_local_0.SHIP_RAW
                v95 = __renovice_local_0
                c146v1 = "Selling Railjack Raw"
                __renovice_local_0 = _T
                c146v2 = nil
                __renovice_local_0.SellingShipUnidentified = c146v2
              else
                __renovice_local_0 = _T.SellingShipWreckage
                if __renovice_local_0 then
                  __renovice_local_0 = v94
                  __renovice_local_0 = __renovice_local_0.SHIP_SCRAP
                  v95 = __renovice_local_0
                  c146v1 = "Selling Railjack Wreckage"
                  __renovice_local_0 = _T
                  c146v2 = nil
                  __renovice_local_0.SellingShipWreckage = c146v2
                else
                  __renovice_local_0 = _T.SellingShipComponents
                  if __renovice_local_0 then
                    __renovice_local_0 = v94
                    __renovice_local_0 = __renovice_local_0.SHIP_PARTS
                    v95 = __renovice_local_0
                    c146v1 = "Selling Railjack Parts"
                    __renovice_local_0 = _T
                    c146v2 = nil
                    __renovice_local_0.SellingShipComponents = c146v2
                  else
                    __renovice_local_0 = _T.SellingPrimeParts
                    if __renovice_local_0 then
                      __renovice_local_0 = v94
                      __renovice_local_0 = __renovice_local_0.PRIMEPARTS
                      v95 = __renovice_local_0
                      c146v1 = "Selling Prime Parts"
                    else
                      __renovice_local_0 = _T.InvShardConvertMode
                      if __renovice_local_0 ~= nil then
                        __renovice_local_0 = _T
                        c146v2 = nil
                        __renovice_local_0.InvShardConvertMode = c146v2
                        __renovice_local_0 = v94
                        __renovice_local_0 = __renovice_local_0.SHARDS
                        v95 = __renovice_local_0
                        c146v1 = "Converting Shards"
                      else
                        __renovice_local_0 = _T.InvDecoDonateMode
                        if __renovice_local_0 ~= nil then
                          __renovice_local_0 = _T
                          c146v2 = nil
                          __renovice_local_0.InvDecoDonateMode = c146v2
                          __renovice_local_0 = v94
                          __renovice_local_0 = __renovice_local_0.DECODONATE
                          v95 = __renovice_local_0
                          c146v1 = "Donating Decorations"
                        else
                          __renovice_local_0 = _T.InvResDonateMode
                          if __renovice_local_0 ~= nil then
                            __renovice_local_0 = _T
                            c146v2 = nil
                            __renovice_local_0.InvResDonateMode = c146v2
                            __renovice_local_0 = v94
                            __renovice_local_0 = __renovice_local_0.RESDONATE
                            v95 = __renovice_local_0
                            c146v1 = "Donating Resources"
                          else
                            __renovice_local_0 = _T.InvTradingInfo
                            if __renovice_local_0 ~= nil then
                              __renovice_local_0 = v24
                              __renovice_local_0 = __renovice_local_0.Ternary
                              c146v2 = _T.InvTradingInfo.Items
                              c146v3 = v94
                              c146v3 = c146v3.TRADE_ITEMS
                              c146v4 = v94
                              c146v4 = c146v4.TRADE_MODS
                              __renovice_local_0 = __renovice_local_0(c146v2, c146v3, c146v4)
                              v95 = __renovice_local_0
                              c146v2 = gGameRules
                              __renovice_local_0 = IsNull
                              __renovice_local_0 = __renovice_local_0(c146v2:GetTradingController())
                              if not __renovice_local_0 then
                                __renovice_local_0 = gGameRules
                                __renovice_local_0 = __renovice_local_0:GetTradingController()
                                __renovice_local_0 = __renovice_local_0:IsNemesisTrade()
                                if __renovice_local_0 then
                                  __renovice_local_0 = true
                                  v96 = __renovice_local_0
                                end
                              end
                              c146v1 = "Selecting items to trade"
                            else
                              c146v2 = _T.SyndicateInvInfo
                              __renovice_local_0 = IsNull
                              __renovice_local_0 = __renovice_local_0(c146v2)
                              if not __renovice_local_0 then
                                __renovice_local_0 = v94
                                __renovice_local_0 = __renovice_local_0.SYNDDONATE
                                v95 = __renovice_local_0
                                c146v1 = "Donating for Standing"
                              else
                                __renovice_local_0 = _T.InvModSkipListSelection
                                if __renovice_local_0 ~= nil then
                                  __renovice_local_0 = v94
                                  __renovice_local_0 = __renovice_local_0.MODS_SKIP_LIST
                                  v95 = __renovice_local_0
                                  c146v1 = "Edit Mod Quick select skip list"
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
          end
        end
      end
      __renovice_local_0 = print
      c146v3 = "InventoryTest - CurrMode: "
      c146v2 = c146v3 .. c146v1
      __renovice_local_0(c146v2)
      __renovice_local_0 = Engine.IsPlayingWithTouchscreen
      __renovice_local_0 = __renovice_local_0()
      if __renovice_local_0 then
        __renovice_local_0 = SetTouchLayout
        __renovice_local_0()
      end
      __renovice_local_0 = gFlashMgr
      c146v3 = vendorMovie
      __renovice_local_0 = __renovice_local_0:FindMovie(c146v3)
      v84 = __renovice_local_0
      c146v2 = v84
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c146v2)
      if not __renovice_local_0 then
        __renovice_local_0 = v84
        c146v3 = "_root"
        c146v4 = 13
        c146v5 = false
        __renovice_local_0:Name__d9713943(c146v3, c146v4, c146v5)
      end
      __renovice_local_0 = v20
      c146v2 = v25
      c146v2 = c146v2.GetCurrentBackgroundInfo
      c146v2 = c146v2()
      __renovice_local_0.BgInfo = c146v2
      __renovice_local_0 = v20
      c146v2 = gGameRules
      c146v2 = c146v2:IsPauseDisabled()
      __renovice_local_0.PauseState = c146v2
      __renovice_local_0 = v20
      __renovice_local_0 = __renovice_local_0.PauseState
      if not __renovice_local_0 then
        __renovice_local_0 = gGameRules
        c146v3 = true
        __renovice_local_0:SetPauseDisabled(c146v3)
      end
      __renovice_local_0 = v95
      c146v2 = v94
      c146v2 = c146v2.TRADE_MODS
      __renovice_local_0 = v24
      __renovice_local_0 = __renovice_local_0.PlaySound
      c146v2 = _G
      c146v2 = c146v2.UISound_Select
      __renovice_local_0(c146v2)
      __renovice_local_0 = v24
      __renovice_local_0 = __renovice_local_0.PlaySound
      c146v2 = _G
      c146v2 = c146v2.UISound_DialogOpen
      __renovice_local_0(c146v2)
      __renovice_local_0 = v24
      __renovice_local_0 = __renovice_local_0.PlaySound
      c146v2 = _G
      c146v2 = c146v2.UISound_GridOpen
      __renovice_local_0(c146v2)
      __renovice_local_0 = "/Lotus/Language/Menu/CurrencyWithIcon"
      v59 = __renovice_local_0
      __renovice_local_0 = "/Lotus/Language/Menu/ItemInventory_SellTotal"
      v60 = __renovice_local_0
      __renovice_local_0 = "/Lotus/Language/Menu/Store_Total"
      v61 = __renovice_local_0
      __renovice_local_0 = v95
      c146v2 = v94
      c146v2 = c146v2.FISH
      if __renovice_local_0 == c146v2 then
        __renovice_local_0 = "/Lotus/Language/Menu/ReputationWithIcon"
        v59 = __renovice_local_0
        __renovice_local_0 = _T.FishInvInfo.ShowRep
        if __renovice_local_0 then
          __renovice_local_0 = "/Lotus/Language/OstronCrafting/Fishmonger_StandingTotal"
          v60 = __renovice_local_0
        end
      else
        local __renovice_state_0 = 44
        __renovice_local_0 = v95
        c146v2 = v94
        c146v2 = c146v2.PRIMEPARTS
        if __renovice_local_0 ~= c146v2 then
          __renovice_state_0 = 46
        else
          __renovice_state_0 = 45
        end
        if __renovice_state_0 == 45 then
          __renovice_local_0 = "/Lotus/Language/Menu/PrimeBucksWithIcon"
          v59 = __renovice_local_0
        end
        if __renovice_state_0 == 46 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.TREASURE
          if __renovice_local_0 == c146v2 then
            __renovice_state_0 = 49
          else
            __renovice_state_0 = 47
          end
        end
        if __renovice_state_0 == 47 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.SHIP_SCRAP
          if __renovice_local_0 == c146v2 then
            __renovice_state_0 = 49
          else
            __renovice_state_0 = 48
          end
        end
        if __renovice_state_0 == 48 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.SHIP_RAW
          if __renovice_local_0 ~= c146v2 then
            __renovice_state_0 = 50
          else
            __renovice_state_0 = 49
          end
        end
        if __renovice_state_0 == 49 then
          __renovice_local_0 = "/Lotus/Language/Menu/FusionPointsWithIcon"
          v59 = __renovice_local_0
        end
        if __renovice_state_0 == 50 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.ARCANE
          if __renovice_local_0 ~= c146v2 then
            __renovice_state_0 = 52
          else
            __renovice_state_0 = 51
          end
        end
        if __renovice_state_0 == 51 then
          __renovice_local_0 = "/Lotus/Language/Labels/DistillPointsWithIcon"
          v59 = __renovice_local_0
        end
        if __renovice_state_0 == 52 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.SHIP_PARTS
          if __renovice_local_0 ~= c146v2 then
            __renovice_state_0 = 54
          else
            __renovice_state_0 = 53
          end
        end
        if __renovice_state_0 == 53 then
          __renovice_local_0 = ""
          v59 = __renovice_local_0
        end
        if __renovice_state_0 == 54 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.SHARDS
          if __renovice_local_0 ~= c146v2 then
            __renovice_state_0 = 56
          else
            __renovice_state_0 = 55
          end
        end
        if __renovice_state_0 == 55 then
          __renovice_local_0 = "/Lotus/Language/Menu/FocusPointsWithIcon"
          v59 = __renovice_local_0
        end
        if __renovice_state_0 == 56 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.ENEMIES
          if __renovice_local_0 ~= c146v2 then
            __renovice_state_0 = 58
          else
            __renovice_state_0 = 57
          end
        end
        if __renovice_state_0 == 57 then
          __renovice_local_0 = "/Lotus/Language/Menu/ItemInventory_EnemyTitle"
          v61 = __renovice_local_0
        end
        if __renovice_state_0 == 58 then
          __renovice_local_0 = v95
          c146v2 = v94
          c146v2 = c146v2.SYNDDONATE
          if __renovice_local_0 ~= c146v2 then
            __renovice_state_0 = 60
          else
            __renovice_state_0 = 59
          end
        end
        if __renovice_state_0 == 59 then
          __renovice_local_0 = "/Lotus/Language/Menu/ReputationWithIcon"
          v59 = __renovice_local_0
        end
        if __renovice_state_0 == 60 then
          __renovice_local_0 = v129
          __renovice_local_0 = __renovice_local_0()
          if not __renovice_local_0 then
          else
            __renovice_state_0 = 61
          end
        end
        if __renovice_state_0 == 61 then
          __renovice_local_0 = "/Lotus/Language/Dojo/Trade_OfferedLabel"
          v61 = __renovice_local_0
        end
      end
      __renovice_local_0 = v95
      c146v2 = v94
      c146v2 = c146v2.SHIP_SCRAP
      if __renovice_local_0 == c146v2 then
        __renovice_local_0 = v26
        __renovice_local_0 = __renovice_local_0.ToggleScreensToHide
        c146v2 = false
        c146v3 = v20
        c146v3 = c146v3.ScreenVis
        __renovice_local_0(c146v2, c146v3)
      end
      __renovice_local_0 = v23
      __renovice_local_0 = __renovice_local_0.GetMainMenuSuitAvatar
      __renovice_local_0 = __renovice_local_0()
      c146v2 = IsNull
      c146v2 = c146v2(__renovice_local_0)
      if not c146v2 then
        c146v2 = __renovice_local_0:GetDrawOnTop()
        if c146v2 then
          c146v4 = false
          __renovice_local_0:SetDrawOnTop(c146v4)
          c146v2 = v20
          c146v3 = true
          c146v2.AvatarDrawOnTop = c146v3
        end
      end
      c146v2 = v139
      c146v3 = 0
      c146v2(c146v3)
      c146v2 = v97
      if c146v2 then
        c146v2 = mMovie
        c146v4 = "SellList.BottomLine"
        c146v5 = 1
        c146v6 = 564.5
        c146v2:SetNumberVariable(c146v4, c146v5, c146v6)
      end
      c146v2 = v95
      c146v3 = v94
      c146v3 = c146v3.DECODONATE
    end
    if __renovice_local_0 == c146v2 then
      c146v12 = string.upper
      c146v13 = mMovie
      c146v15 = c146v11.titleLoc
      c146v15 = c146v15:c_str()
      c146v16 = false
      __renovice_local_1 = c146v12(c146v13:GetLocalized(c146v15, c146v16))
    end
    if __renovice_local_0 == c146v2 then
      c146v3 = mMovie
      c146v5 = "SellList.SyndicateRank"
      c146v6 = 13
      __renovice_local_1 = false
      c146v3:Name__d9713943(c146v5, c146v6, __renovice_local_1)
      c146v3 = mMovie
      c146v5 = "SellList.SyndicateInfo"
      c146v6 = 13
      __renovice_local_1 = false
      c146v3:Name__d9713943(c146v5, c146v6, __renovice_local_1)
      c146v3 = mMovie
      c146v5 = "SellList.DailyStandingInfo"
      c146v6 = 13
      __renovice_local_1 = false
      c146v3:Name__d9713943(c146v5, c146v6, __renovice_local_1)
    end
    if __renovice_local_0 == c146v2 then
      local __renovice_state_1 = 83
      if __renovice_local_1 ~= nil then
        __renovice_state_1 = 85
      else
        __renovice_state_1 = 84
      end
      if __renovice_state_1 == 84 then
        c146v7 = mMovie
        c146v9 = "/Lotus/Language/Syndicates/NeutralTitle"
        c146v10 = false
        __renovice_local_1 = c146v7:GetLocalized(c146v9, c146v10)
        __renovice_state_1 = 85
      end
      if __renovice_state_1 == 85 then
        c146v7 = v92
        c146v7 = c146v7.SyndicateInfo
        c146v10 = false
        c146v7:SetText(__renovice_local_1, c146v10)
        c146v7 = v25
        c146v7 = c146v7.GetColor
        c146v8 = 2
        c146v9 = true
        c146v7 = c146v7(c146v8, c146v9)
        c146v8 = v28
        c146v8 = c146v8.DrawRankIndicator
        c146v9 = mMovie
        c146v10 = "SellList.SyndicateRank"
        c146v11 = { Level = nil }
        c146v12 = _T.SyndicateInvInfo.Level
        c146v11.Level = c146v12
        c146v8(c146v9, c146v10, c146v11)
        c146v8 = v92
        c146v8 = c146v8.SyndicateInfo
        c146v8:Redraw()
        c146v8 = v92
        c146v8 = c146v8.SyndicateInfo
        c146v10 = _T.SyndicateInvInfo.Reputation
        c146v11 = _T.SyndicateInvInfo.RepReq
        c146v12 = "/Lotus/Language/Syndicates/SyndicateReputation"
        c146v8:SetProgress(c146v10, c146v11, c146v12)
        c146v8 = v92
        c146v9 = v32
        c146v9 = c146v9.Create
        c146v10 = mMovie
        c146v11 = "SellList.DailyStandingInfo"
        c146v12 = TitleCase
        c146v13 = mMovie
        c146v15 = "/Lotus/Language/Syndicates/DailyStandingCap"
        c146v16 = false
        c146v12 = c146v12(c146v13:GetLocalized(c146v15, c146v16))
        c146v13 = nil
        c146v14 = dailyStandingIcon
        c146v15 = nil
        c146v16 = nil
        c146v17 = nil
        c146v9 = c146v9(c146v10, c146v11, c146v12, c146v13, c146v14, c146v15, c146v16, c146v17)
        c146v8.DailyStandingInfo = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = true
        c146v8.mSkipResize = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = true
        c146v8.mHideProgressTarget = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 0.18
        c146v8.mVerticalTextOffset = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 0.3
        c146v8.mBackerEdgeAlpha = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 64
        c146v8.mIconSize = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 80
        c146v8.mIconBorderSize = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = -4
        c146v8.mIconPaddingX = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = -4
        c146v8.mIconPaddingY = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 12
        c146v8.mIconToTextPadding = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 0.3
        c146v8.mBackerIconAlpha = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 0.9
        c146v8.mBackerAlpha = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 80
        c146v8.mUnfocusedShadeAlpha = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = Color
        c146v10 = 0
        c146v11 = 0
        c146v12 = 0
        c146v9 = c146v9(c146v10, c146v11, c146v12)
        c146v8.mIconColor = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = Color
        c146v10 = 200
        c146v11 = 200
        c146v12 = 200
        c146v9 = c146v9(c146v10, c146v11, c146v12)
        c146v8.mIconBgColor = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = true
        c146v8.mShowIconHighlight = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = dailyStandingIconBacker
        c146v8.mIconBgExtra = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 176
        c146v8.mIconBgExtraWidth = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 176
        c146v8.mIconBgExtraHeight = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v8.mIconBgExtraColor = c146v7
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = 30
        c146v8.mIconBgExtraAlpha = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v10 = 370
        c146v8:SetWidth(c146v10)
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = true
        c146v8.mExtendedProgressBar = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v9 = true
        c146v8.mSeamlessProgressBar = c146v9
        c146v8 = v92
        c146v8 = c146v8.DailyStandingInfo
        c146v8:Redraw()
        c146v8 = c146v3:GetDailyStandingLimitBin()
        c146v9 = 0
        if c146v8 <= c146v9 then
          __renovice_state_1 = 88
        else
          __renovice_state_1 = 86
        end
      end
      if __renovice_state_1 == 86 then
        c146v9 = 15
        if c146v9 <= c146v8 then
          __renovice_state_1 = 88
        else
          __renovice_state_1 = 87
        end
      end
      if __renovice_state_1 == 87 then
        c146v9 = gGameData
        c146v9 = c146v9:GetDailyStandingLimit(c146v8)
        c146v10 = gGameConfig
        c146v12 = gGameData
        c146v10 = c146v10:Name__f73ffbcc(c146v12:Name__1d1bb34a())
        c146v11 = v28
        c146v11 = c146v11.GetRefreshTimeFormatted
        c146v12 = mMovie
        c146v11 = c146v11(c146v12)
        c146v12 = v92
        c146v12 = c146v12.DailyStandingInfo
        c146v16 = "/Lotus/Language/Syndicates/DailyStandingRemainingTime"
        c146v12:SetProgress(c146v9, c146v10, c146v16, c146v11)
        __renovice_state_1 = 89
      end
      if __renovice_state_1 == 88 then
        c146v9 = mMovie
        c146v11 = v92
        c146v11 = c146v11.DailyStandingInfo
        c146v11 = c146v11.mClipName
        c146v12 = 13
        c146v13 = false
        c146v9:Name__d9713943(c146v11, c146v12, c146v13)
        __renovice_state_1 = 89
      end
      if __renovice_state_1 == 89 then
        c146v9 = mMovie
        c146v11 = "SellList.SyndicateInfo"
        c146v12 = 1
        c146v9 = c146v9:GetNumberVariable(c146v11, c146v12)
        c146v10 = mMovie
        c146v12 = "SellList.BottomLine"
        c146v13 = 1
        c146v14 = c146v9 - 60
        c146v10:SetNumberVariable(c146v12, c146v13, c146v14)
        c146v10 = mMovie
        c146v12 = "SellList.Amount"
        c146v13 = 1
        c146v14 = c146v9 - 46
        c146v10:SetNumberVariable(c146v12, c146v13, c146v14)
        c146v10 = mMovie
        c146v12 = "SellList.Total"
        c146v13 = 1
        c146v14 = c146v9 - 46
        c146v10:SetNumberVariable(c146v12, c146v13, c146v14)
        c146v10 = 236
        v101 = c146v10
      end
    end
    c146v5 = mMovie
    __renovice_local_1 = "SellList.BottomLine"
    c146v7 = 1
    c146v5 = c146v5:GetNumberVariable(__renovice_local_1, c146v7)
    c146v6 = mMovie
    c146v7 = "SellList.TopLine"
    c146v8 = 1
    c146v6 = c146v6:GetNumberVariable(c146v7, c146v8)
    c146v4 = c146v5 - c146v6
    c146v3 = c146v4 - 26
    v66 = c146v3
    c146v3 = v23
    c146v3 = c146v3.RegisterHideHud
    c146v4 = true
    c146v3(c146v4)
    c146v3 = v95
    c146v4 = v94
    c146v4 = c146v4.INVENTORY
    if c146v3 == c146v4 then
      c146v3 = gGameRules
      c146v3 = c146v3:GetStoreManifest()
      v5 = c146v3
    end
    c146v3 = _T.UIInputEnabled
    if not c146v3 then
      c146v3 = true
      v41 = c146v3
      c146v3 = _T.EnableUIInput
      c146v3()
    end
    c146v3 = mMovie
    c146v5 = 0
    c146v3:SetBackgroundColor(c146v5)
    c146v3 = 0
    c146v4 = gFlashMgr
    c146v6 = tennoWayMovie
    c146v4 = c146v4:FindMovie(c146v6)
    if c146v4 == nil then
      c146v3 = 0.25
      c146v4 = mMovie
      c146v6 = "_root"
      __renovice_local_1 = 12
      c146v7 = 0
      c146v4:SetNumberVariable(c146v6, __renovice_local_1, c146v7)
      c146v4 = mMovie
      c146v6 = "_root"
      __renovice_local_1 = 4
      c146v7 = -5000
      c146v4:SetNumberVariable(c146v6, __renovice_local_1, c146v7)
      c146v4 = FlashInterpolate
      c146v5 = mMovie
      c146v6 = "_root"
      __renovice_local_1 = 8
      c146v8 = 4
      c146v9 = 12
      c146v7 = {c146v8, c146v9}
      c146v9 = 0
      c146v10 = 100
      c146v8 = {c146v9, c146v10}
      c146v4(c146v5, c146v6, __renovice_local_1, c146v7, c146v8, c146v3)
    end
    c146v5 = _T.ShowBackground
    c146v4 = IsNull
    c146v4 = c146v4(c146v5)
    if not c146v4 then
      c146v4 = _T.ShowBackground
      c146v6 = nil
      __renovice_local_1 = false
      c146v4(c146v3, c146v6, __renovice_local_1)
    end
    c146v4 = gPlayerProfileMgr
    c146v6 = 0
    c146v4 = c146v4:GetPlayerProfile(c146v6)
    c146v5 = IsNull
    c146v5 = c146v5(c146v4)
    if not c146v5 then
      c146v5 = c146v4:GetGameSpecificData()
      v46 = c146v5
      c146v5 = c146v4:Settings()
      v10 = c146v5
    end
    c146v6 = v10
    c146v5 = IsNull
    c146v5 = c146v5(c146v6)
    if not c146v5 then
      c146v5 = v10
      c146v5 = c146v5:HideEquippedInTrade()
      v87 = c146v5
    end
    c146v5 = v95
    c146v6 = v94
    c146v6 = c146v6.ENEMIES
    if c146v5 == c146v6 then
      c146v5 = gRegion
      c146v5 = c146v5:GetNpcMgr()
      c146v6 = IsNull
      c146v6 = c146v6(c146v5)
      if not c146v6 then
        c146v6 = c146v5:GetAiDirector()
        v8 = c146v6
      end
      c146v6 = v173
      c146v6()
      c146v6 = v168
      c146v6()
    end
    c146v5 = mMovie
    c146v7 = _T.RadialSolarMapOpen
    if c146v7 ~= true then
      __renovice_local_1 = false
    else
      __renovice_local_1 = true
    end
    c146v5:SetPreDrawUpdate(__renovice_local_1)
    c146v6 = v46
    c146v5 = IsNull
    c146v5 = c146v5(c146v6)
    if not c146v5 then
      local __renovice_state_2 = 111
      c146v5 = v46
      c146v5 = c146v5:GetInventory()
      c146v6 = IsNull
      c146v6 = c146v6(c146v5)
      if c146v6 then
      else
        __renovice_state_2 = 112
      end
      if __renovice_state_2 == 112 then
        c146v6 = v23
        c146v6 = c146v6.VerifyInventorySlots
        c146v7 = 0
        c146v6 = c146v6(c146v5, c146v7)
        if not c146v6 then
          __renovice_state_2 = 115
        else
          __renovice_state_2 = 113
        end
      end
      if __renovice_state_2 == 113 then
        c146v6 = v23
        c146v6 = c146v6.VerifyInventorySlots
        c146v7 = 1
        c146v6 = c146v6(c146v5, c146v7)
        if not c146v6 then
          __renovice_state_2 = 115
        else
          __renovice_state_2 = 114
        end
      end
      if __renovice_state_2 == 114 then
        c146v6 = v23
        c146v6 = c146v6.VerifyInventorySlots
        c146v7 = 2
        c146v6 = c146v6(c146v5, c146v7)
        if c146v6 then
        else
          __renovice_state_2 = 115
        end
      end
      if __renovice_state_2 == 115 then
        c146v6 = v23
        c146v6 = c146v6.ShowInvalidBinError
        __renovice_local_1 = "OnInvalidBinError"
        c146v6(__renovice_local_1)
      end
    end
    c146v5 = v26
    c146v5 = c146v5.DrawSeparator
    c146v6 = mMovie
    __renovice_local_1 = "SellList.TopLine"
    c146v7 = 380
    c146v5(c146v6, __renovice_local_1, c146v7)
    c146v5 = v26
    c146v5 = c146v5.DrawSeparator
    c146v6 = mMovie
    __renovice_local_1 = "SellList.BottomLine"
    c146v7 = 380
    c146v5(c146v6, __renovice_local_1, c146v7)
    c146v5 = v26
    c146v5 = c146v5.DrawSeparator
    c146v6 = mMovie
    __renovice_local_1 = "SellList.BottomLine2"
    c146v7 = 380
    c146v5(c146v6, __renovice_local_1, c146v7)
    c146v5 = mMovie
    __renovice_local_1 = "SellList.Tip"
    c146v7 = 14
    c146v8 = mMovie
    c146v10 = "SellList.List"
    c146v11 = 14
    c146v5:SetNumberVariable(__renovice_local_1, c146v7, c146v8:GetNumberVariable(c146v10, c146v11))
    c146v5 = mMovie
    __renovice_local_1 = "SellList.Tip"
    c146v7 = 0
    c146v8 = mMovie
    c146v10 = "SellList.List"
    c146v11 = 0
    c146v5:SetNumberVariable(__renovice_local_1, c146v7, c146v8:GetNumberVariable(c146v10, c146v11))
    c146v5 = Engine.IsMobile
    c146v5 = c146v5()
    if c146v5 then
      c146v5 = mMovie
      __renovice_local_1 = "SellList.Tip"
      c146v7 = 50
      c146v8 = 24
      c146v5:SetNumberVariable(__renovice_local_1, c146v7, c146v8)
    end
    c146v5 = mMovie
    __renovice_local_1 = "ScrollBar"
    c146v7 = 13
    c146v8 = false
    c146v5:Name__d9713943(__renovice_local_1, c146v7, c146v8)
    c146v5 = "/Lotus/Language/Menu/Loadout_Inventory"
    c146v6 = "/Lotus/Language/Menu/ItemSelection_Sell"
    __renovice_local_1 = v95
    c146v7 = v94
    c146v7 = c146v7.PRIMEPARTS
    if __renovice_local_1 == c146v7 then
      c146v6 = "/Lotus/Language/Menu/ItemInventory_SellingPrimeTitle"
    else
      local __renovice_state_3 = 120
      __renovice_local_1 = v95
      c146v7 = v94
      c146v7 = c146v7.TREASURE
      if __renovice_local_1 ~= c146v7 then
        __renovice_state_3 = 122
      else
        __renovice_state_3 = 121
      end
      if __renovice_state_3 == 121 then
        c146v6 = "/Lotus/Language/Menu/ItemInventory_SellingTreasureTitle"
      end
      if __renovice_state_3 == 122 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.ARCANE
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 124
        else
          __renovice_state_3 = 123
        end
      end
      if __renovice_state_3 == 123 then
        c146v5 = "/Lotus/Language/Labels/ItemInventory_SellingArcaneTitle"
        c146v6 = ""
      end
      if __renovice_state_3 == 124 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.SHIP_SCRAP
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 129
        else
          __renovice_state_3 = 125
        end
      end
      if __renovice_state_3 == 125 then
        __renovice_local_1 = _T.InventoryInfo
        if __renovice_local_1 == nil then
          __renovice_state_3 = 128
        else
          __renovice_state_3 = 126
        end
      end
      if __renovice_state_3 == 126 then
        __renovice_local_1 = _T.InventoryInfo.MinSellAmount
        if __renovice_local_1 == nil then
          __renovice_state_3 = 128
        else
          __renovice_state_3 = 127
        end
      end
      if __renovice_state_3 == 127 then
        __renovice_local_1 = mMovie
        c146v8 = "/Lotus/Language/Railjack/WreckageLimit_TitleWithCount"
        c146v9 = false
        c146v10 = { COUNT = nil }
        c146v11 = v24
        c146v11 = c146v11.FormatNumber
        c146v12 = _T.InventoryInfo.MinSellAmount
        c146v11 = c146v11(c146v12)
        c146v10.COUNT = c146v11
        c146v6 = __renovice_local_1:GetLocalized(c146v8, c146v9, c146v10)
      end
      if __renovice_state_3 == 128 then
        c146v6 = "/Lotus/Language/Railjack/ItemInventory_SellingShipWreckageTitle"
      end
      if __renovice_state_3 == 129 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.SHIP_PARTS
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 131
        else
          __renovice_state_3 = 130
        end
      end
      if __renovice_state_3 == 130 then
        c146v6 = "/Lotus/Language/Railjack/ItemInventory_SellingShipComponentsShortTitle"
      end
      if __renovice_state_3 == 131 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.SHIP_RAW
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 133
        else
          __renovice_state_3 = 132
        end
      end
      if __renovice_state_3 == 132 then
        c146v6 = "/Lotus/Language/Railjack/ItemInventory_SellingShipWreckageTitle"
      end
      if __renovice_state_3 == 133 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.FISH
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 137
        else
          __renovice_state_3 = 134
        end
      end
      if __renovice_state_3 == 134 then
        c146v7 = _T.CurrentConversation
        __renovice_local_1 = IsNull
        __renovice_local_1 = __renovice_local_1(c146v7)
        if __renovice_local_1 then
          __renovice_state_3 = 136
        else
          __renovice_state_3 = 135
        end
      end
      if __renovice_state_3 == 135 then
        c146v5 = _T.CurrentConversation.mSpeakerName
        __renovice_state_3 = 136
      end
      if __renovice_state_3 == 136 then
        c146v6 = _T.FishInvInfo.SellBtnLabel
      end
      if __renovice_state_3 == 137 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.ENEMIES
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 139
        else
          __renovice_state_3 = 138
        end
      end
      if __renovice_state_3 == 138 then
        c146v5 = "/Lotus/Language/Menu/EnemySelector_Title"
        c146v6 = "/Lotus/Language/Menu/EnemySelector_SubTitle"
      end
      if __renovice_state_3 == 139 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.DECODONATE
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 141
        else
          __renovice_state_3 = 140
        end
      end
      if __renovice_state_3 == 140 then
        c146v6 = "/Lotus/Language/Dojo/VaultContributionDeco"
      end
      if __renovice_state_3 == 141 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.RESDONATE
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 143
        else
          __renovice_state_3 = 142
        end
      end
      if __renovice_state_3 == 142 then
        c146v6 = "/Lotus/Language/Categories/RESOURCES"
      end
      if __renovice_state_3 == 143 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.SYNDDONATE
        if __renovice_local_1 ~= c146v7 then
          __renovice_state_3 = 146
        else
          __renovice_state_3 = 144
        end
      end
      if __renovice_state_3 == 144 then
        c146v7 = _T.CurrentConversation
        __renovice_local_1 = IsNull
        __renovice_local_1 = __renovice_local_1(c146v7)
        if __renovice_local_1 then
        else
          __renovice_state_3 = 145
        end
      end
      if __renovice_state_3 == 145 then
        c146v5 = _T.CurrentConversation.mSpeakerName
        c146v6 = "/Lotus/Language/Syndicates/Favors_RedeemReward"
      end
      if __renovice_state_3 == 146 then
        __renovice_local_1 = v129
        __renovice_local_1 = __renovice_local_1()
        if not __renovice_local_1 then
          __renovice_state_3 = 148
        else
          __renovice_state_3 = 147
        end
      end
      if __renovice_state_3 == 147 then
        c146v6 = "/Lotus/Language/Dojo/Trade"
      end
      if __renovice_state_3 == 148 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.MODS_SKIP_LIST
        if __renovice_local_1 ~= c146v7 then
        else
          __renovice_state_3 = 149
        end
      end
      if __renovice_state_3 == 149 then
        c146v5 = "/Lotus/Language/ModFusion/ModQuickSelectTitle"
        c146v6 = ""
      end
    end
    __renovice_local_1 = v120
    c146v7 = mMovie
    c146v10 = false
    c146v7 = c146v7:GetLocalized(c146v5, c146v10)
    c146v8 = mMovie
    c146v11 = false
    __renovice_local_1(c146v7, c146v8:GetLocalized(c146v6, c146v11))
    __renovice_local_1 = v176
    __renovice_local_1()
    __renovice_local_1 = v95
    c146v7 = v94
    c146v7 = c146v7.PRIMEPARTS
    if __renovice_local_1 == c146v7 then
      __renovice_local_1 = _T
      c146v7 = true
      __renovice_local_1.ShowPrimeBucks = c146v7
    else
      local __renovice_state_4 = 152
      __renovice_local_1 = v95
      c146v7 = v94
      c146v7 = c146v7.TREASURE
      if __renovice_local_1 == c146v7 then
        __renovice_state_4 = 155
      else
        __renovice_state_4 = 153
      end
      if __renovice_state_4 == 153 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.SHIP_SCRAP
        if __renovice_local_1 == c146v7 then
          __renovice_state_4 = 155
        else
          __renovice_state_4 = 154
        end
      end
      if __renovice_state_4 == 154 then
        __renovice_local_1 = v95
        c146v7 = v94
        c146v7 = c146v7.SHIP_RAW
        if __renovice_local_1 ~= c146v7 then
        else
          __renovice_state_4 = 155
        end
      end
      if __renovice_state_4 == 155 then
        __renovice_local_1 = _T
        c146v7 = true
        __renovice_local_1.ShowFusionPoints = c146v7
      end
    end
    __renovice_local_1 = v161
    __renovice_local_1()
    __renovice_local_1 = v158
    __renovice_local_1()
    __renovice_local_1 = v174
    __renovice_local_1()
    __renovice_local_1 = v153
    c146v7 = true
    __renovice_local_1(c146v7)
    __renovice_local_1 = mMovie
    c146v8 = "Mask"
    c146v9 = 15
    c146v11 = v43
    c146v11 = c146v11.mRows
    c146v12 = v43
    c146v12 = c146v12.mRowSeparation
    c146v10 = c146v11 * c146v12
    __renovice_local_1:SetNumberVariable(c146v8, c146v9, c146v10)
    __renovice_local_1 = v170
    __renovice_local_1()
    __renovice_local_1 = require
    c146v7 = "Lotus.Interface.Components.ThemedSpinner"
    __renovice_local_1 = __renovice_local_1(c146v7)
    c146v7 = __renovice_local_1.Create
    c146v8 = mMovie
    c146v9 = "Loading.Spinner"
    c146v7 = c146v7(c146v8, c146v9)
    v57 = c146v7
    c146v7 = mMovie
    c146v9 = "SellList.Tip"
    c146v10 = 88
    c146v11 = true
    c146v7:Name__d9713943(c146v9, c146v10, c146v11)
    c146v7 = v98
    c146v7 = c146v7.INVENTORY
    v99 = c146v7
    c146v7 = false
    c146v8 = v95
    c146v9 = v94
    c146v9 = c146v9.ENEMIES
    if c146v8 == c146v9 then
      c146v8 = _T.SelectingEnemiesManifest
      v9 = c146v8
      c146v8 = _T.StatScans
      if c146v8 == nil then
        c146v8 = IsNull
        c146v8 = c146v8(c146v4)
        if not c146v8 then
          c146v8 = c146v4:GetOnlineStats()
          c146v9 = _T
          c146v10 = c146v8.mScans
          c146v9.StatScans = c146v10
        end
      end
      c146v8 = v172
      c146v9 = _T.StatScans
      c146v8(c146v9)
    else
      c146v9 = v5
      c146v8 = IsNull
      c146v8 = c146v8(c146v9)
      if c146v8 then
        c146v7 = true
        c146v8 = v95
        c146v9 = v94
        c146v9 = c146v9.PRIMEPARTS
        if c146v8 == c146v9 then
          c146v8 = primeSellManifestType
          v6 = c146v8
        else
          c146v8 = v95
          c146v9 = v94
          c146v9 = c146v9.TREASURE
          if c146v8 == c146v9 then
            c146v8 = treasureSellManifestType
            v6 = c146v8
          else
            c146v8 = v95
            c146v9 = v94
            c146v9 = c146v9.FISH
            if c146v8 == c146v9 then
              c146v8 = _T.SelectingFishManifest
              v6 = c146v8
            else
              c146v8 = v95
              c146v9 = v94
              c146v9 = c146v9.RESDONATE
              if c146v8 == c146v9 then
                c146v8 = resDonateManifestType
                v6 = c146v8
              else
                c146v8 = gGameConfig
                c146v8 = c146v8:GetStoreManifest()
                v6 = c146v8
              end
            end
          end
        end
        c146v9 = v6
        c146v8 = IsNull
        c146v8 = c146v8(c146v9)
        if not c146v8 then
          c146v8 = v6
          c146v8 = c146v8:GetFullName()
          v6 = c146v8
          c146v8 = UISys.ScriptResLoader_Create
          c146v10 = v6
          c146v9 = {c146v10}
          c146v10 = true
          c146v8 = c146v8(c146v9, c146v10)
          v7 = c146v8
        end
      end
    end
    if c146v7 then
      c146v9 = v47
      c146v10 = v110
      c146v10 = c146v10.EXIT
      c146v8 = c146v9[c146v10]
      c146v9 = true
      c146v8.mVisible = c146v9
      c146v8 = v119
      c146v8()
      c146v8 = v57
      c146v8:SetActive(c146v7)
    else
      c146v8 = v112
      c146v8()
    end
    c146v8 = true
    v39 = c146v8
    c146v8 = mMovie
    c146v10 = true
    c146v8:Name__f7d22364(c146v10)
    c146v8 = _T
    c146v9 = true
    c146v8.InventoryScreenOpen = c146v9
    c146v8 = gGameStatsMgr
    if c146v8 ~= nil then
      c146v8 = gGameRules
      c146v10 = gLotusAttractModeGameRulesType
      c146v8 = c146v8:IsA(c146v10)
      if c146v8 then
        c146v8 = v95
        c146v9 = v94
        c146v9 = c146v9.INVENTORY
        if c146v8 == c146v9 then
          c146v8 = gGameStatsMgr
          c146v10 = Symbol
          c146v11 = "IN_SHIP_VIEW_TIME"
          c146v10 = c146v10(c146v11)
          c146v11 = "EQUIPMENT_INVENTORY"
          c146v8:StartTimer(c146v10, c146v11)
        end
      end
    end
    c146v8 = v95
    c146v9 = v94
    c146v9 = c146v9.INVENTORY
    if c146v8 == c146v9 then
      c146v8 = IsNull
      c146v8 = c146v8(c146v4)
      if not c146v8 then
        c146v8 = c146v4:Settings()
        c146v9 = IsNull
        c146v9 = c146v9(c146v8)
        if not c146v9 then
          c146v9 = c146v8:Name__dcb1013c()
          v65 = c146v9
        end
      end
      c146v8 = v125
      c146v9 = v65
      c146v8(c146v9)
    end
    c146v8 = mMovie
    c146v10 = "SellList.Slider"
    c146v11 = 13
    c146v12 = false
    c146v8:Name__d9713943(c146v10, c146v11, c146v12)
    c146v8 = mMovie
    c146v10 = "SellList.SliderValue"
    c146v11 = 13
    c146v12 = false
    c146v8:Name__d9713943(c146v10, c146v11, c146v12)
    c146v8 = v171
    c146v8()
    c146v8 = Engine.IsPlayingWithTouchscreen
    c146v8 = c146v8()
    if c146v8 then
      c146v8 = SetDropdownCategories
      c146v8()
    end
    do return end
  end
  Initialize = v177
  v177 = 0
  v178 = function(c148v0, c148v1, c148v2, c148v3)
    local c148v4, c148v5, c148v6, c148v7, c148v8
    c148v4 = TitleCase
    c148v5 = mMovie
    c148v8 = false
    c148v4 = c148v4(c148v5:GetLocalized(c148v1, c148v8))
    c148v5 = v37
    c148v7 = v177
    c148v8 = function()
      local c147v0, c147v1, c147v2, c147v3
      c147v0 = gFlashMgr
      c147v2 = rewardsMovie
      c147v0 = c147v0:FindMovie(c147v2)
      c147v1 = IsNull
      c147v1 = c147v1(c147v0)
      if c147v1 then
        c147v1 = gFlashMgr
        c147v3 = rewardsMovie
        c147v0 = c147v1:PushMovie(c147v3)
      end
      c147v1 = IsNull
      c147v1 = c147v1(c147v0)
      if not c147v1 then
        c147v1 = _T.DisplayReward
        if c147v1 ~= nil then
          c147v1 = { Name = nil, itemCount = nil, OverrideCount = nil, OverrideDisplayTime = nil, OverrideCatergory = nil }
          c147v2 = c148v4
          c147v1.Name = c147v2
          c147v2 = c148v2
          c147v1.itemCount = c147v2
          c147v2 = c148v2
          c147v1.OverrideCount = c147v2
          c147v2 = c148v3
          c147v1.OverrideDisplayTime = c147v2
          c147v2 = 11
          c147v1.OverrideCatergory = c147v2
          c147v2 = _T.DisplayReward
          c147v3 = c148v0
          c147v2(c147v3, c147v1)
        end
      end
      do return end
    end
    c148v5:AddTimer(c148v7, c148v8)
    c148v6 = v177
    c148v5 = c148v6 + 2.35
    v177 = c148v5
    do return end
  end
  v179 = function(c150v0, c150v1)
    local c150v2, c150v3, c150v4, c150v5, c150v6, c150v7, c150v8, c150v9, c150v10, c150v11, c150v12, c150v13
    local __renovice_state_0 = -1
    local __renovice_state_1 = -1
    repeat
      c150v7 = "SellGroupEmpty"
      c150v8 = "SellGroupPartialFull"
      c150v9 = "SellGroupAllFull"
      c150v6 = {c150v7, c150v8, c150v9}
      c150v3 = nil
      c150v2 = c150v6[c150v3]
      c150v3 = v102
      c150v3 = v103
      if not c150v3 then
        __renovice_state_1 = 81
        break
      end
      c150v5 = nil
      c150v6 = c150v3
      c150v7 = nil
      c150v8 = nil
      for __renovice_for_0_0, __renovice_for_0_1 in c150v6, c150v7, c150v8 do
        c150v11 = __renovice_for_0_1:IsBayonet()
        if c150v11 then
          __renovice_state_1 = 75
          break
        else
          c150v6 = gChallengeMgr
          c150v8 = gRegion
          c150v8 = c150v8:GetLocalPlayer()
          __renovice_for_0_0 = Symbol
          __renovice_for_0_1 = "TREASURE_SOLD"
          c150v6:NotifyTag(c150v8, __renovice_for_0_0(__renovice_for_0_1))
          c150v6 = gGameData
          c150v6:UploadChallengeProgress()
          c150v6 = _T
          c150v7 = _T.MarooDeco
          c150v6.LypSyncDeco = c150v7
          c150v6 = _T.PlayBackgroundTransmission
          c150v8 = transmissionSet
          c150v6 = c150v6(c150v2, c150v8)
          if c150v6 then
            c150v7 = _T.PlayBackgroundTransmission
            c150v8 = "AnythingElsePrompt"
            __renovice_for_0_0 = transmissionSet
            __renovice_for_0_1 = 2
            c150v7(c150v8, __renovice_for_0_0, __renovice_for_0_1)
          end
          c150v7 = v45
          c150v7 = c150v7.mElements
          c150v4 = nil
          c150v6 = c150v7[c150v4]
          c150v8 = c150v6.MatchedSockets
          c150v7 = IsNull
          c150v7 = c150v7(c150v8)
          if not c150v7 then
            c150v7 = c150v6.MatchedSockets
            __renovice_for_0_0 = c150v6.Sockets
            c150v8 = #__renovice_for_0_0
            if c150v7 == c150v8 then
              __renovice_for_0_0 = 3
              c150v7 = math.max
              c150v3 = c150v7(c150v3, __renovice_for_0_0)
            else
              __renovice_for_0_0 = 2
              c150v7 = math.max
              c150v3 = c150v7(c150v3, __renovice_for_0_0)
            end
          else
            __renovice_for_0_0 = 1
            c150v7 = math.max
            c150v3 = c150v7(c150v3, __renovice_for_0_0)
          end
          c150v7 = v24
          c150v7 = c150v7.Ternary
          __renovice_for_0_0 = SRandom
          __renovice_for_0_1 = 0
          c150v11 = 1
          __renovice_for_0_0 = __renovice_for_0_0(__renovice_for_0_1, c150v11)
          __renovice_for_0_1 = 0.3
          if __renovice_for_0_1 < __renovice_for_0_0 then
            c150v8 = false
          else
            c150v8 = true
          end
          __renovice_for_0_0 = "SellGeneric"
          __renovice_for_0_1 = ""
          c150v2 = c150v7(c150v8, __renovice_for_0_0, __renovice_for_0_1)
          if c150v2 == "" then
            c150v8 = "StarsOnly"
            __renovice_for_0_0 = "SculptureOnly"
            __renovice_for_0_1 = "CompleteTreasure"
            c150v7 = {c150v8, __renovice_for_0_0, __renovice_for_0_1}
            c150v2 = c150v7[c150v3]
          end
          c150v3 = _T.InventoryInfo
          if c150v3 ~= nil then
            c150v3 = _T.InventoryInfo.MinSellAmount
            if c150v3 ~= nil then
              c150v3 = v133
              c150v4 = true
              c150v3(c150v4)
            end
          end
          c150v3 = v45
          c150v3:RemoveElements()
          c150v3 = v139
          c150v5 = v58
          c150v4 = -c150v5
          c150v3(c150v4)
          c150v3 = v112
          c150v3()
          c150v3 = v134
          c150v3()
          c150v3 = v23
          c150v3 = c150v3.RefreshPetsAfterSell
          c150v3()
          c150v4 = _T.GenericVendor_UpdateOwned
          c150v3 = IsNull
          c150v3 = c150v3(c150v4)
          if not c150v3 then
            c150v3 = _T.GenericVendor_UpdateOwned
            c150v4 = true
            c150v3(c150v4)
          end
          c150v3 = v72
          if not c150v3 then
            __renovice_state_1 = 81
            break
          else
            c150v3 = nil
            c150v4 = nil
            c150v5 = v102
            if c150v5 then
              c150v5 = v72
              c150v3 = c150v5:GetLongGuns()
              c150v4 = 3
              c150v5 = nil
              v102 = c150v5
            end
            c150v5 = v103
            if c150v5 then
              c150v5 = v72
              c150v3 = c150v5:GetMelee()
              c150v4 = 2
              c150v5 = nil
              v103 = c150v5
            end
            if (not c150v3 or not c150v4) then
              __renovice_state_1 = 81
              break
            else
              local __renovice_state_2 = 49
              c150v3 = v95
              c150v4 = v94
              c150v4 = c150v4.SHIP_SCRAP
              if c150v3 == c150v4 then
                __renovice_state_2 = 52
              else
                __renovice_state_2 = 50
              end
              if __renovice_state_2 == 50 then
                c150v3 = v95
                c150v4 = v94
                c150v4 = c150v4.SHIP_PARTS
                if c150v3 == c150v4 then
                  __renovice_state_2 = 52
                else
                  __renovice_state_2 = 51
                end
              end
              if __renovice_state_2 == 51 then
                c150v3 = v95
                c150v4 = v94
                c150v4 = c150v4.SHIP_RAW
                if c150v3 ~= c150v4 then
                  __renovice_state_2 = 53
                else
                  __renovice_state_2 = 52
                end
              end
              if __renovice_state_2 == 52 then
                c150v3 = _T
                c150v4 = true
                c150v3.ShipParts_Sold = c150v4
              end
              if __renovice_state_2 == 53 then
                c150v3 = v95
                c150v4 = v94
                c150v4 = c150v4.ARCANE
                if c150v3 ~= c150v4 then
                else
                  __renovice_state_2 = 54
                end
              end
              if __renovice_state_2 == 54 then
                c150v4 = _T.PlayBackgroundTransmission
                c150v3 = IsNull
                c150v3 = c150v3(c150v4)
                if c150v3 then
                else
                  __renovice_state_2 = 55
                end
              end
              if __renovice_state_2 == 55 then
                c150v4 = v45
                c150v4 = c150v4.mElements
                c150v3 = #c150v4
                if c150v3 ~= 1 then
                  __renovice_state_2 = 58
                else
                  __renovice_state_2 = 56
                end
              end
              if __renovice_state_2 == 56 then
                c150v4 = v45
                c150v4 = c150v4.mElements
                c150v3 = c150v4[1]
                c150v3 = c150v3.Count
                if c150v3 ~= 1 then
                  __renovice_state_2 = 58
                else
                  __renovice_state_2 = 57
                end
              end
              if __renovice_state_2 == 57 then
                c150v3 = _T.PlayBackgroundTransmission
                c150v4 = "ArcaneSingle"
                c150v5 = arcaneTransmissionSet
                c150v6 = 2
                c150v3(c150v4, c150v5, c150v6)
              end
              if __renovice_state_2 == 58 then
                c150v3 = _T.PlayBackgroundTransmission
                c150v4 = "ArcaneMulti"
                c150v5 = arcaneTransmissionSet
                c150v6 = 2
                c150v3(c150v4, c150v5, c150v6)
              end
              c150v8 = v45
              c150v8 = c150v8.mElements
              c150v7 = #c150v8
              c150v6 = c150v7 - c150v5
              c150v7 = v45
              c150v7 = c150v7.mElements
              c150v6 = c150v7[c150v4]
              c150v6 = c150v6.Count
              c150v8 = 1
              __renovice_for_0_0 = v45
              __renovice_for_0_0 = __renovice_for_0_0.mElements
              c150v6 = #__renovice_for_0_0
              c150v7 = 1
              for __renovice_for_1_0 = c150v8, c150v6, c150v7 do
                __renovice_for_0_1 = v45
                __renovice_for_0_1 = __renovice_for_0_1.mElements
                __renovice_for_0_0 = __renovice_for_0_1[__renovice_for_1_0]
                __renovice_for_0_1 = __renovice_for_0_0.IsCostElement
                if __renovice_for_0_1 then
                  continue
                end
                c150v11 = __renovice_for_0_0.MatchedSockets
                __renovice_for_0_1 = IsNull
                __renovice_for_0_1 = __renovice_for_0_1(c150v11)
                if not __renovice_for_0_1 then
                  __renovice_for_0_1 = __renovice_for_0_0.MatchedSockets
                  if __renovice_for_0_1 == 0 then
                    c150v13 = 1
                    c150v11 = math.max
                    c150v11 = c150v11(c150v3, c150v13)
                    c150v12 = 2
                    __renovice_for_0_1 = math.min
                    c150v3 = __renovice_for_0_1(c150v11, c150v12)
                    continue
                  end
                  __renovice_for_0_1 = __renovice_for_0_0.MatchedSockets
                  c150v12 = __renovice_for_0_0.Sockets
                  c150v11 = #c150v12
                  if __renovice_for_0_1 == c150v11 then
                    if (c150v3 == 0 or c150v3 == 3) then
                      c150v3 = 3
                      continue
                    end
                    c150v3 = 2
                    continue
                  end
                  c150v3 = 2
                  continue
                end
                c150v13 = 1
                c150v11 = math.max
                c150v11 = c150v11(c150v3, c150v13)
                c150v12 = 2
                __renovice_for_0_1 = math.min
                c150v3 = __renovice_for_0_1(c150v11, c150v12)
              end
              if __renovice_state_1 ~= -1 then break end
              c150v4 = _T.PlayBackgroundTransmission
              c150v3 = IsNull
              c150v3 = c150v3(c150v4)
              c150v3 = 0
              c150v4 = 0
              c150v5 = 0
              c150v8 = 1
              __renovice_for_0_0 = v45
              __renovice_for_0_0 = __renovice_for_0_0.mElements
              c150v6 = #__renovice_for_0_0
              c150v7 = 1
              for __renovice_for_2_0 = c150v8, c150v6, c150v7 do
                __renovice_for_0_1 = v45
                __renovice_for_0_1 = __renovice_for_0_1.mElements
                __renovice_for_0_0 = __renovice_for_0_1[__renovice_for_2_0]
                __renovice_for_0_0 = __renovice_for_0_0.IsCostElement
                if __renovice_for_0_0 then
                  c150v5 = c150v5 + 1
                  continue
                end
                c150v4 = __renovice_for_2_0
              end
              if __renovice_state_1 ~= -1 then break end
              c150v2 = print
              c150v4 = "OnSellCompleted(result="
              __renovice_for_0_0 = tostring
              c150v5 = __renovice_for_0_0(c150v0)
              c150v6 = ", body="
              __renovice_for_0_0 = tostring
              c150v7 = __renovice_for_0_0(c150v1)
              c150v8 = ")"
              c150v3 = c150v4 .. c150v5 .. c150v6 .. c150v7 .. c150v8
              c150v2(c150v3)
              c150v2 = v57
              c150v4 = false
              c150v2:SetActive(c150v4)
              c150v2 = nil
              v91 = c150v2
              if not c150v0 then
                c150v2 = print
                c150v4 = "Inventory Sale Fail: "
                c150v3 = c150v4 .. c150v1
                c150v2(c150v3)
                c150v2 = v24
                c150v2 = c150v2.ShowMessage
                c150v3 = "/Lotus/Language/Menu/Item_SaleFailed"
                c150v2(c150v3)
                c150v2 = false
                v40 = c150v2
                do return end
              end
              c150v2 = 0
              v177 = c150v2
              c150v3 = _T.Manifest
              c150v2 = IsNull
              c150v2 = c150v2(c150v3)
              if not c150v2 then
                c150v2 = v95
                c150v3 = v94
                c150v3 = c150v3.SHIP_PARTS
                if c150v2 == c150v3 then
                  c150v2 = _T.Manifest.mITEMS
                  c150v5 = 1
                  c150v3 = #c150v2
                  c150v4 = 1
                  for __renovice_for_3_0 = c150v5, c150v3, c150v4 do
                    c150v6 = v178
                    c150v7 = c150v2[__renovice_for_3_0]
                    c150v7 = c150v7.StoreItem
                    c150v8 = c150v2[__renovice_for_3_0]
                    c150v8 = c150v8.Name
                    __renovice_for_0_0 = c150v2[__renovice_for_3_0]
                    __renovice_for_0_0 = __renovice_for_0_0.Count
                    __renovice_for_0_1 = 2
                    c150v6(c150v7, c150v8, __renovice_for_0_0, __renovice_for_0_1)
                  end
                  if __renovice_state_1 ~= -1 then break end
                end
              end
              c150v2 = v48
              c150v2 = c150v2.mSellPrice
              c150v3 = 0
              if c150v3 < c150v2 then
                c150v2 = v86
                c150v3 = v86
                c150v3 = c150v3:GetLocalizeTag()
                c150v3 = c150v3:c_str()
                c150v4 = v48
                c150v4 = c150v4.mSellCurrency
                c150v5 = 1
                if c150v4 == c150v5 then
                  c150v2 = ducatStoreItem
                  c150v3 = "/Lotus/Language/Items/PrimeBucks"
                else
                  c150v4 = v48
                  c150v4 = c150v4.mSellCurrency
                  c150v5 = 2
                  if c150v4 == c150v5 then
                    c150v2 = endoStoreItem
                    c150v3 = "/Lotus/Language/Items/FusionBundle"
                  else
                    c150v4 = v48
                    c150v4 = c150v4.mSellCurrency
                    c150v5 = 4
                    if c150v4 == c150v5 then
                      c150v2 = distillStoreItem
                      c150v3 = "/Lotus/Language/Items/DistillPoints"
                    end
                  end
                end
                c150v4 = v48
                c150v4 = c150v4.mSellPrice
                c150v5 = 0
                if c150v5 < c150v4 then
                  c150v5 = v178
                  c150v7 = TitleCase
                  c150v8 = mMovie
                  c150v11 = false
                  c150v7 = c150v7(c150v8:GetLocalized(c150v3, c150v11))
                  __renovice_for_0_0 = 3
                  c150v5(c150v2, c150v7, c150v4, __renovice_for_0_0)
                end
              end
              c150v2 = ""
              c150v3 = v95
              c150v4 = v94
              c150v4 = c150v4.TREASURE
            end
          end
        end
      end
      if __renovice_state_1 ~= -1 then break end
      break
    until true
    if __renovice_state_1 == 75 then
      c150v10 = nil
      c150v5 = c150v10.mAltWeaponModeId
      __renovice_state_0 = 77
    end
    if __renovice_state_0 == 77 then
      c150v6 = v72
      c150v8 = 0
      c150v9 = v72
      c150v11 = 0
      c150v6 = c150v6:GetPreset(c150v8, c150v9:Name__9adc88cf(c150v11))
      c150v7 = c150v6:GetEntry(c150v4)
      if c150v5 ~= nil then
        c150v8 = c150v5:IsZero()
        if not c150v8 then
          c150v7.mItemId = c150v5
        end
      end
      c150v8 = 0
      c150v7.mModSlot = c150v8
      c150v8 = 0
      c150v7.mCustSlot = c150v8
      c150v6:SetEntry(c150v4, c150v7)
      c150v8 = gGameData
      c150v10 = 0
      c150v8:ApplyLoadOutPreset(c150v10, c150v6)
      c150v8 = v72
      c150v10 = 0
      c150v8:SetLoadoutPreset(c150v10, c150v6)
    end
    c150v3 = gGameData
    c150v5 = function()
      do return end
    end
    c150v3:SyncInventoryFromDB(c150v5)
    do return end
  end
  OnSellCompleted = v179
  v179 = function(c151v0)
    local c151v1, c151v2, c151v3
    c151v1 = false
    v62 = c151v1
    c151v2 = gGameData
    c151v1 = IsNull
    c151v1 = c151v1(c151v2)
    if not c151v1 then
      c151v1 = tonumber
      c151v1 = c151v1(c151v0)
      c151v2 = 4
      if c151v1 == c151v2 then
        c151v1 = v57
        c151v3 = true
        c151v1:SetActive(c151v3)
        c151v3 = v91
        if c151v3 ~= nil then
          c151v2 = false
        else
          c151v2 = true
        end
        c151v1 = assert
        c151v1(c151v2)
        c151v1 = v23
        c151v1 = c151v1.AddMatchmakingLabelToSellOperation
        c151v2 = v48
        c151v1(c151v2)
        c151v1 = Lotus_Game.SellCommand
        c151v2 = v48
        c151v3 = "OnSellCompleted"
        c151v1 = c151v1(c151v2, c151v3)
        v91 = c151v1
        c151v1 = v91
        c151v1:Execute()
        c151v1 = v24
        c151v1 = c151v1.PlaySound
        c151v2 = _G
        c151v2 = c151v2.UISound_SweetenerTwo
        c151v1(c151v2)
        do return end
      end
    end
    c151v1 = false
    v40 = c151v1
    do return end
  end
  OnSellConfirmed = v179
  v179 = function(c152v0)
    local c152v1, c152v2, c152v3, c152v4, c152v5, c152v6, c152v7, c152v8, c152v9
    c152v1 = gGameData
    c152v1 = c152v1:GetInventory()
    c152v2 = nil
    c152v3 = false
    c152v4 = 0
    if c152v0 == c152v4 then
      c152v2 = c152v1:GetPistols()
      c152v3 = true
    else
      c152v4 = 1
      if c152v0 == c152v4 then
        c152v2 = c152v1:GetLongGuns()
        c152v3 = true
      else
        c152v4 = 3
        if c152v0 == c152v4 then
          c152v2 = c152v1:GetSuits()
          c152v3 = true
        else
          c152v4 = 5
          if c152v0 == c152v4 then
            c152v2 = c152v1:GetMelee()
            c152v3 = true
          else
            c152v4 = 16
            if c152v0 == c152v4 then
              c152v5 = c152v1:GetSentinels()
              c152v4 = #c152v5
              c152v5 = 0
              if c152v5 < c152v4 then
                c152v2 = c152v1:GetSentinelWeapons()
                c152v3 = true
              end
            else
              c152v4 = 6
              if c152v0 == c152v4 then
                c152v3 = true
              else
                c152v4 = 15
                if c152v0 == c152v4 then
                  c152v2 = c152v1:GetSentinels()
                  c152v3 = true
                else
                  c152v4 = 24
                  if c152v0 == c152v4 then
                    c152v2 = c152v1:GetKubrowPets()
                    c152v3 = true
                  else
                    c152v4 = 27
                    if c152v0 == c152v4 then
                      c152v2 = c152v1:GetSpaceSuits()
                      c152v3 = true
                    else
                      c152v4 = 28
                      if c152v0 == c152v4 then
                        c152v2 = c152v1:GetSpaceGuns()
                        c152v3 = true
                      else
                        c152v4 = 29
                        if c152v0 == c152v4 then
                          c152v2 = c152v1:GetSpaceMelee()
                          c152v3 = true
                        else
                          c152v4 = 39
                          if c152v0 == c152v4 then
                            c152v2 = c152v1:GetMoaPets()
                            c152v3 = true
                          else
                            c152v4 = 41
                            if c152v0 == c152v4 then
                              c152v2 = c152v1:GetHoverboards()
                              c152v3 = true
                            else
                              c152v4 = 50
                              if c152v0 == c152v4 then
                                c152v2 = c152v1:GetHorses()
                                c152v3 = true
                              else
                                c152v4 = 48
                                if c152v0 == c152v4 then
                                  c152v2 = c152v1:GetMechSuits()
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
          end
        end
      end
    end
    c152v4 = -1
    if c152v2 ~= nil then
      c152v4 = #c152v2
      if c152v3 then
        c152v7 = 1
        c152v5 = #c152v2
        c152v6 = 1
        for __renovice_for_0_0 = c152v7, c152v5, c152v6 do
          c152v8 = c152v2[__renovice_for_0_0]
          c152v9 = c152v8:IsTimeLimited()
          if not c152v9 then
            continue
          end
          c152v4 = c152v4 - 1
        end
      end
    end
    c152v5 = { Count = nil, CanHaveExpirables = nil }
    c152v5.Count = c152v4
    c152v5.CanHaveExpirables = c152v3
    do return c152v5 end
  end
  v180 = function()
    local c153v0, c153v1, c153v2, c153v3, c153v4, c153v5, c153v6, c153v7, c153v8, c153v9, c153v10, c153v11, c153v12, c153v13, c153v14, c153v15, c153v16
    c153v1 = v5
    c153v0 = IsNull
    c153v0 = c153v0(c153v1)
    if c153v0 then
      do return end
    end
    c153v0 = v48
    c153v1 = 5
    c153v0.mSellCurrency = c153v1
    c153v0 = {}
    c153v1 = ""
    c153v2 = ipairs
    c153v3 = v45
    c153v3 = c153v3.mElements
    c153v2, c153v3, c153v4 = c153v2(c153v3)
    for __renovice_for_0_0, __renovice_for_0_1 in c153v2, c153v3, c153v4 do
      c153v7 = v48
      c153v9 = __renovice_for_0_1.Category
      c153v10 = __renovice_for_0_1.UID
      c153v11 = 1
      c153v7:SellItem(c153v9, c153v10, c153v11)
      c153v7 = ipairs
      c153v8 = __renovice_for_0_1.ItemPrices
      c153v7, c153v8, c153v9 = c153v7(c153v8)
      for __renovice_for_1_0, __renovice_for_1_1 in c153v7, c153v8, c153v9 do
        c153v12 = __renovice_for_1_1.mItemType
        c153v1 = c153v12:GetFullName()
        c153v14 = c153v0[c153v1]
        c153v13 = c153v14 or 0
        c153v14 = __renovice_for_1_1.mItemCount
        c153v12 = c153v13 + c153v14
        c153v0[c153v1] = c153v12
      end
    end
    c153v2 = {}
    c153v3 = pairs
    c153v3, c153v4, c153v5 = c153v3(c153v0)
    for __renovice_for_2_0, __renovice_for_2_1 in c153v3, c153v4, c153v5 do
      c153v8 = v5
      c153v10 = WeakResource
      c153v8 = c153v8:Name__1dc35bd2(c153v10(__renovice_for_2_0))
      c153v9 = v22
      c153v9 = c153v9.GetIconTexture
      c153v11 = true
      c153v9, c153v10 = c153v9(c153v8, c153v11)
      c153v13 = { Name = nil, StoreItem = nil, Count = nil, Icon = nil, Themed = nil, LocalizedDesc = nil }
      c153v14 = Localize
      c153v15 = tostring
      c153v15 = c153v15(c153v8:GetLocalizeTag())
      c153v16 = {}
      c153v14 = c153v14(c153v15, c153v16)
      c153v13.Name = c153v14
      c153v13.StoreItem = c153v8
      c153v13.Count = __renovice_for_2_1
      c153v13.Icon = c153v9
      c153v13.Themed = c153v10
      c153v14 = Localize
      c153v15 = tostring
      c153v15 = c153v15(c153v8:GetLocalizeDescTag())
      c153v16 = {}
      c153v14 = c153v14(c153v15, c153v16)
      c153v13.LocalizedDesc = c153v14
      c153v11 = table.insert
      c153v11(c153v2, c153v13)
    end
    c153v3 = mMovie
    c153v5 = "/Lotus/Language/Railjack/SellRepairedSalvage"
    c153v6 = false
    c153v3 = c153v3:GetLocalized(c153v5, c153v6)
    c153v4 = mMovie
    c153v6 = "/Lotus/Language/Menu/Crafting_CancelBuildSubtitle"
    c153v7 = false
    c153v4 = c153v4:GetLocalized(c153v6, c153v7)
    c153v5 = _T
    c153v6 = { TITLE = nil, TIP = nil, mITEMS = nil, CONFIRM_LABEL = "/Lotus/Language/Menu/ItemSelection_OK" }
    c153v6.TITLE = c153v3
    c153v6.TIP = c153v4
    c153v6.mITEMS = c153v2
    c153v5.Manifest = c153v6
    c153v5 = mMovie
    c153v7 = graphicManifestMovie
    c153v5 = c153v5:PushChildMovie(c153v7)
    v82 = c153v5
    c153v6 = v82
    c153v5 = IsNull
    c153v5 = c153v5(c153v6)
    if not c153v5 then
      c153v5 = v82
      c153v7 = "SetCallback"
      c153v8 = "OnSellConfirmed"
      c153v5:Execute(c153v7, c153v8)
    end
    do return end
  end
  v181 = function()
    local c155v0, c155v1, c155v2, c155v3, c155v4, c155v5, c155v6, c155v7, c155v8, c155v9, c155v10, c155v11, c155v12, c155v13, c155v14, c155v15, c155v16
    local __renovice_local_0 = v40
    if __renovice_local_0 then
      do return end
    end
    __renovice_local_0 = v62
    if not __renovice_local_0 then
      c155v0 = gGameData
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c155v0)
      if not __renovice_local_0 then
        __renovice_local_0 = Lotus_Game.SellOperation
        __renovice_local_0 = __renovice_local_0()
        v48 = __renovice_local_0
        __renovice_local_0 = v95
        c155v0 = v94
        c155v0 = c155v0.SHIP_PARTS
        if __renovice_local_0 == c155v0 then
          __renovice_local_0 = v180
          __renovice_local_0()
          do return end
        end
        __renovice_local_0 = v95
        c155v0 = v94
        c155v0 = c155v0.PRIMEPARTS
        if __renovice_local_0 == c155v0 then
          __renovice_local_0 = v48
          c155v0 = 1
          __renovice_local_0.mSellCurrency = c155v0
        else
          local __renovice_state_0 = 9
          __renovice_local_0 = v95
          c155v0 = v94
          c155v0 = c155v0.TREASURE
          if __renovice_local_0 == c155v0 then
            __renovice_state_0 = 12
          else
            __renovice_state_0 = 10
          end
          if __renovice_state_0 == 10 then
            __renovice_local_0 = v95
            c155v0 = v94
            c155v0 = c155v0.SHIP_SCRAP
            if __renovice_local_0 == c155v0 then
              __renovice_state_0 = 12
            else
              __renovice_state_0 = 11
            end
          end
          if __renovice_state_0 == 11 then
            __renovice_local_0 = v95
            c155v0 = v94
            c155v0 = c155v0.SHIP_RAW
            if __renovice_local_0 ~= c155v0 then
              __renovice_state_0 = 13
            else
              __renovice_state_0 = 12
            end
          end
          if __renovice_state_0 == 12 then
            __renovice_local_0 = v48
            c155v0 = 2
            __renovice_local_0.mSellCurrency = c155v0
          end
          if __renovice_state_0 == 13 then
            __renovice_local_0 = v95
            c155v0 = v94
            c155v0 = c155v0.ARCANE
            if __renovice_local_0 ~= c155v0 then
            else
              __renovice_state_0 = 14
            end
          end
          if __renovice_state_0 == 14 then
            __renovice_local_0 = v48
            c155v0 = 4
            __renovice_local_0.mSellCurrency = c155v0
          end
        end
        __renovice_local_0 = {}
        c155v0 = {}
        c155v1 = {}
        c155v2 = 0
        v67 = c155v2
        c155v2 = 0
        c155v5 = 1
        c155v6 = v45
        c155v6 = c155v6.mElements
        c155v3 = #c155v6
        c155v4 = 1
        for __renovice_for_0_0 = c155v5, c155v3, c155v4 do
          c155v6 = ResetLineCount
          c155v7 = 0
          c155v6(c155v7)
          c155v7 = v45
          c155v7 = c155v7.mElements
          c155v6 = c155v7[__renovice_for_0_0]
          c155v7 = c155v6.SellingPrice
          c155v11 = c155v6.UID
          c155v11 = 4
          c155v11 = c155v6.SellingPrice
          c155v8 = nil
          c155v10 = c155v11 * c155v8
          c155v12 = c155v0[c155v7]
          c155v12 = c155v12.CanHaveExpirables
          c155v12 = 24
          c155v13 = v67
          c155v12 = c155v13 + c155v10
          v67 = c155v12
          c155v2 = c155v2 + c155v8
          c155v9 = 0
          c155v10 = c155v6.SellingPrice
          c155v11 = v95
          c155v12 = v94
          c155v12 = c155v12.ARCANE
          if c155v11 == c155v12 then
            c155v11 = mMovie
            c155v13 = "/Lotus/Language/SystemMessages/ConfirmDistillRankWarning"
            c155v14 = true
            c155v15 = { ITEM = nil, RANK = nil }
            c155v16 = c155v6.Name
            c155v15.ITEM = c155v16
            c155v16 = c155v6.ArcaneRank
            c155v15.RANK = c155v16
            c155v11 = c155v11:GetLocalized(c155v13, c155v14, c155v15)
            c155v12 = table.insert
            c155v12(c155v1, c155v11)
          end
          c155v12 = c155v6.RawItem
          c155v12 = c155v12:IsTimeLimited()
          if c155v12 then
            c155v12 = v24
            c155v12 = c155v12.ShowMessage
            c155v13 = "/Lotus/Language/Menu/ItemInventory_CantSellTimeLimited"
            c155v12(c155v13)
            do return end
          end
          c155v7 = c155v6.Category
          c155v8 = 18
          if c155v7 == c155v8 then
            c155v8 = gGameData
            c155v10 = c155v6.UID
            c155v8 = c155v8:IsResourceDroneDeployed(c155v10)
            if c155v8 then
              c155v8 = v24
              c155v8 = c155v8.ShowMessage
              c155v9 = "/Lotus/Language/Menu/ItemInventory_CantSellResourceDrone"
              c155v8(c155v9)
              do return end
            end
          end
          c155v8 = v24
          c155v8 = c155v8.Ternary
          c155v10 = c155v6.Count
          if c155v10 == nil then
            c155v9 = false
          else
            c155v9 = true
          end
          c155v10 = c155v6.Count
          c155v11 = 1
          c155v8 = c155v8(c155v9, c155v10, c155v11)
          c155v9 = c155v8
          c155v10 = 0
          c155v11 = c155v6.UID
          c155v11 = v24
          c155v11 = c155v11.Ternary
          c155v13 = c155v6.UID
          if c155v13 == nil then
            c155v12 = false
          else
            c155v12 = true
          end
          c155v13 = c155v6.UID
          c155v14 = c155v6.Type
          c155v11 = c155v11(c155v12, c155v13, c155v14:GetFullName())
          c155v12 = 34
          if c155v7 == c155v12 then
            c155v12 = c155v6.RawItem
            c155v11 = c155v12:Name__c9974427()
          end
          c155v12 = v48
          c155v12:SellItem(c155v7, c155v11, c155v9)
          c155v12 = __renovice_local_0[c155v7]
          if c155v12 == nil then
            c155v12 = 1
            __renovice_local_0[c155v7] = c155v12
            c155v12 = v179
            c155v12 = c155v12(c155v7)
            c155v0[c155v7] = c155v12
          else
            c155v13 = __renovice_local_0[c155v7]
            c155v12 = c155v13 + 1
            __renovice_local_0[c155v7] = c155v12
          end
          c155v12 = 1
          if c155v7 == c155v12 then
            c155v12 = c155v6.RawItem
            c155v12 = c155v12:IsBayonet()
            if c155v12 then
              c155v13 = 5
              c155v12 = __renovice_local_0[c155v13]
              if c155v12 == nil then
                c155v12 = 5
                c155v13 = 1
                __renovice_local_0[c155v12] = c155v13
                c155v12 = 5
                c155v13 = v179
                c155v14 = 5
                c155v13 = c155v13(c155v14)
                c155v0[c155v12] = c155v13
              else
                c155v12 = 5
                c155v15 = 5
                c155v14 = __renovice_local_0[c155v15]
                c155v13 = c155v14 + 1
                __renovice_local_0[c155v12] = c155v13
              end
            end
          end
          c155v12 = c155v0[c155v7]
        end
        c155v3 = v48
        c155v4 = v67
        c155v3.mSellPrice = c155v4
        c155v4 = 5
        c155v3 = c155v0[c155v4]
        if c155v3 then
          c155v4 = 5
          c155v3 = __renovice_local_0[c155v4]
          if c155v3 then
            c155v6 = 5
            c155v5 = c155v0[c155v6]
            c155v5 = c155v5.Count
            c155v7 = 5
            c155v6 = __renovice_local_0[c155v7]
            c155v4 = c155v5 - c155v6
            if c155v4 ~= 1 then
              c155v3 = false
            else
              c155v3 = true
            end
            v103 = c155v3
          end
        end
        c155v4 = 1
        c155v3 = c155v0[c155v4]
        if c155v3 then
          c155v4 = 1
          c155v3 = __renovice_local_0[c155v4]
          if c155v3 then
            c155v6 = 1
            c155v5 = c155v0[c155v6]
            c155v5 = c155v5.Count
            c155v7 = 1
            c155v6 = __renovice_local_0[c155v7]
            c155v4 = c155v5 - c155v6
            if c155v4 ~= 1 then
              c155v3 = false
            else
              c155v3 = true
            end
            v102 = c155v3
          end
        end
        c155v3 = pairs
        c155v3, c155v4, c155v5 = c155v3(__renovice_local_0)
        for __renovice_for_1_0, __renovice_for_1_1 in c155v3, c155v4, c155v5 do
          c155v8 = c155v0[__renovice_for_1_0]
          if c155v8 == nil then
            continue
          end
          c155v8 = c155v0[__renovice_for_1_0]
          c155v8 = c155v8.Count
          c155v9 = 0
          if c155v8 < c155v9 then
            continue
          end
          c155v8 = c155v0[__renovice_for_1_0]
          c155v8 = c155v8.Count
          if not (c155v8 <= __renovice_for_1_1) then
            continue
          end
          c155v8 = 15
          if __renovice_for_1_0 == c155v8 then
            c155v8 = v24
            c155v8 = c155v8.ShowMessage
            c155v9 = "/Lotus/Language/Menu/ItemInventory_CantSellLastSentinel"
            c155v8(c155v9)
            do return end
          end
          c155v8 = v24
          c155v8 = c155v8.ShowMessage
          c155v9 = "/Lotus/Language/Menu/ItemInventory_CantSellLastWeapon"
          c155v8(c155v9)
          do return end
        end
        c155v3 = v48
        c155v3 = c155v3.mSellPrice
        if c155v3 == 0 then
          c155v3 = v24
          c155v3 = c155v3.ShowMessage
          c155v4 = "/Lotus/Language/Menu/ItemInventory_NothingCanBeSold"
          c155v3(c155v4)
          do return end
        end
        c155v3 = true
        v40 = c155v3
        c155v3 = true
        v62 = c155v3
        c155v3 = "/Lotus/Language/Menu/ConfirmSellFormattedPrice"
        c155v5 = "/Lotus/Language/Menu/"
        c155v6 = v24
        c155v6 = c155v6.Ternary
        c155v8 = 1
        if c155v2 <= c155v8 then
          c155v7 = false
        else
          c155v7 = true
        end
        c155v8 = "ItemInventory_MiscItemPlural"
        c155v9 = "ItemInventory_MiscItemSingular"
        c155v6 = c155v6(c155v7, c155v8, c155v9)
        c155v4 = c155v5 .. c155v6
        c155v5 = v24
        c155v5 = c155v5.FormatNumber
        c155v6 = v67
        c155v5 = c155v5(c155v6)
        c155v6 = v95
        c155v7 = v94
        c155v7 = c155v7.PRIMEPARTS
        for __renovice_for_2_0, __renovice_for_2_1 in c155v3, c155v4, c155v5 do
          __renovice_for_2_0 = "<PRIME_BUCKS>"
          c155v5 = __renovice_for_2_0 .. c155v5
          local __renovice_state_1 = 76
          __renovice_for_2_0 = v95
          __renovice_for_2_1 = v94
          __renovice_for_2_1 = __renovice_for_2_1.TREASURE
          if __renovice_for_2_0 == __renovice_for_2_1 then
            __renovice_state_1 = 79
          else
            __renovice_state_1 = 77
          end
          if __renovice_state_1 == 77 then
            __renovice_for_2_0 = v95
            __renovice_for_2_1 = v94
            __renovice_for_2_1 = __renovice_for_2_1.SHIP_SCRAP
            if __renovice_for_2_0 == __renovice_for_2_1 then
              __renovice_state_1 = 79
            else
              __renovice_state_1 = 78
            end
          end
          if __renovice_state_1 == 78 then
            __renovice_for_2_0 = v95
            __renovice_for_2_1 = v94
            __renovice_for_2_1 = __renovice_for_2_1.SHIP_RAW
            if __renovice_for_2_0 ~= __renovice_for_2_1 then
              __renovice_state_1 = 82
            else
              __renovice_state_1 = 79
            end
          end
          if __renovice_state_1 == 79 then
            __renovice_for_2_0 = "<FUSION_POINTS>"
            c155v5 = __renovice_for_2_0 .. c155v5
            __renovice_for_2_0 = v95
            __renovice_for_2_1 = v94
            __renovice_for_2_1 = __renovice_for_2_1.SHIP_SCRAP
            if __renovice_for_2_0 == __renovice_for_2_1 then
              __renovice_state_1 = 81
            else
              __renovice_state_1 = 80
            end
          end
          if __renovice_state_1 == 80 then
            __renovice_for_2_0 = v95
            __renovice_for_2_1 = v94
            __renovice_for_2_1 = __renovice_for_2_1.SHIP_RAW
            if __renovice_for_2_0 ~= __renovice_for_2_1 then
            else
              __renovice_state_1 = 81
            end
          end
          if __renovice_state_1 == 81 then
            c155v3 = "/Lotus/Language/Railjack/ConfirmScrap"
          end
          if __renovice_state_1 == 82 then
            __renovice_for_2_0 = v95
            __renovice_for_2_1 = v94
            __renovice_for_2_1 = __renovice_for_2_1.ARCANE
            if __renovice_for_2_0 ~= __renovice_for_2_1 then
              __renovice_state_1 = 87
            else
              __renovice_state_1 = 83
            end
          end
          if __renovice_state_1 == 83 then
            __renovice_for_2_0 = "/Lotus/Language/SystemMessages/"
            __renovice_for_2_1 = v24
            __renovice_for_2_1 = __renovice_for_2_1.Ternary
            c155v9 = 1
            if c155v9 < c155v2 then
              __renovice_state_1 = 85
            else
              __renovice_state_1 = 84
            end
          end
          if __renovice_state_1 == 84 then
            c155v8 = false
            __renovice_state_1 = 86
          end
          if __renovice_state_1 == 85 then
            c155v8 = true
            __renovice_state_1 = 86
          end
          if __renovice_state_1 == 86 then
            c155v9 = "ItemInventory_CosmeticEnhancerPlural"
            c155v10 = "ItemInventory_CosmeticEnhancerSingular"
            __renovice_for_2_1 = __renovice_for_2_1(c155v8, c155v9, c155v10)
            c155v4 = __renovice_for_2_0 .. __renovice_for_2_1
            c155v3 = "/Lotus/Language/SystemMessages/ConfirmDistill"
            __renovice_for_2_0 = "<DISTILL_POINTS>"
            c155v5 = __renovice_for_2_0 .. c155v5
          end
          if __renovice_state_1 ~= 87 then
            continue
          end
          __renovice_for_2_0 = "<"
          c155v10 = v86
          c155v10 = c155v10:GetLongDesc()
          __renovice_for_2_1 = c155v10:c_str()
          c155v8 = ">"
          c155v5 = __renovice_for_2_0 .. __renovice_for_2_1 .. c155v8 .. c155v5
        end
        c155v6 = mMovie
        c155v9 = false
        c155v10 = { NUMBER = nil }
        c155v11 = v24
        c155v11 = c155v11.FormatNumber
        c155v11 = c155v11(c155v2)
        c155v10.NUMBER = c155v11
        c155v4 = c155v6:GetLocalized(c155v4, c155v9, c155v10)
        c155v6 = mMovie
        c155v9 = true
        c155v10 = { ITEMS = nil, FORMATTED_PRICE = nil }
        c155v10.ITEMS = c155v4
        c155v10.FORMATTED_PRICE = c155v5
        c155v6 = c155v6:GetLocalized(c155v3, c155v9, c155v10)
        c155v7 = v95
        c155v8 = v94
        c155v8 = c155v8.ARCANE
        if c155v7 == c155v8 then
          c155v7 = #c155v1
          c155v8 = 0
          c155v7 = table.sort
          c155v9 = function(c154v0, c154v1)
            local c154v2
            if c154v1 <= c154v0 then
              c154v2 = false
              do return c154v2 end
            end
            c154v2 = true
            do return c154v2 end
          end
          c155v7(c155v1, c155v9)
          c155v7 = ""
          c155v8 = ipairs
          c155v8, c155v9, c155v10 = c155v8(c155v1)
          for __renovice_for_3_0, __renovice_for_3_1 in c155v8, c155v9, c155v10 do
            c155v13 = 1
            if c155v13 < __renovice_for_3_0 then
              c155v14 = "\r\n"
              c155v7 = c155v7 .. c155v14
            end
            c155v7 = c155v7 .. __renovice_for_3_1
          end
          c155v9 = "\r\n\r\n"
          c155v6 = c155v7 .. c155v9 .. c155v6
          for __renovice_for_4_0, __renovice_for_4_1 in c155v8, c155v9, c155v10 do
          end
        end
        c155v7 = v24
        c155v7 = c155v7.ShowYesOrNoMessage
        c155v9 = "OnSellConfirmed"
        c155v7(c155v6, c155v9)
        do return end
      end
    end
    do return end
  end
  SellWithManifest = v181
  v181 = function()
    local c157v0, c157v1, c157v2, c157v3, c157v4, c157v5, c157v6, c157v7
    c157v0 = v40
    if c157v0 then
      do return end
    end
    c157v0 = v58
    c157v1 = v17
    if c157v1 < c157v0 then
      c157v0 = v24
      c157v0 = c157v0.ShowErrorMessage
      c157v1 = "/Lotus/Language/Menu/EnemySelector_MaxCountReached"
      c157v0(c157v1)
      do return end
    end
    c157v0 = v57
    c157v2 = true
    c157v0:SetActive(c157v2)
    c157v0 = {}
    c157v1 = _T
    c157v2 = {}
    c157v1.SpawnedEnemies = c157v2
    c157v1 = v45
    c157v3 = function(c156v0)
      local c156v1, c156v2, c156v3, c156v4
      c156v2 = c156v0.Type
      c156v1 = IsNull
      c156v1 = c156v1(c156v2)
      if not c156v1 then
        c156v2 = c157v0
        c156v3 = c156v0.Type
        c156v1 = table.insert
        c156v1(c156v2, c156v3:GetFullName())
        c156v2 = c157v0
        c156v3 = c156v0.SourceType
        c156v1 = table.insert
        c156v1(c156v2, c156v3:GetFullName())
        c156v2 = _T.SpawnedEnemies
        c156v3 = { Type = nil, SourceType = nil, Count = nil }
        c156v4 = c156v0.Type
        c156v3.Type = c156v4
        c156v4 = c156v0.SourceType
        c156v3.SourceType = c156v4
        c156v4 = c156v0.Count
        c156v3.Count = c156v4
        c156v1 = table.insert
        c156v1(c156v2, c156v3)
      end
      do return end
    end
    c157v1:RunForAllElements(c157v3)
    c157v2 = _T.SpawnedEnemies
    c157v1 = IsNull
    c157v1 = c157v1(c157v2)
    if not c157v1 then
      c157v2 = _T.SpawnedEnemies
      c157v1 = #c157v2
      if c157v1 ~= 0 then
        c157v2 = v10
        c157v1 = IsNull
        c157v1 = c157v1(c157v2)
        if not c157v1 then
          c157v2 = gPlayerProfileMgr
          c157v1 = IsNull
          c157v1 = c157v1(c157v2)
          if not c157v1 then
            c157v1 = {}
            c157v4 = 1
            c157v5 = _T.SpawnedEnemies
            c157v2 = #c157v5
            c157v3 = 1
            for __renovice_for_0_0 = c157v4, c157v2, c157v3 do
              c157v5 = Engine.SimulacrumSpawnedEnemy
              c157v5 = c157v5()
              c157v7 = _T.SpawnedEnemies
              c157v6 = c157v7[__renovice_for_0_0]
              c157v6 = c157v6.Type
              c157v6 = c157v6:GetFullName()
              c157v5.enemyType = c157v6
              c157v7 = _T.SpawnedEnemies
              c157v6 = c157v7[__renovice_for_0_0]
              c157v6 = c157v6.SourceType
              c157v6 = c157v6:GetFullName()
              c157v5.resourceType = c157v6
              c157v7 = _T.SpawnedEnemies
              c157v6 = c157v7[__renovice_for_0_0]
              c157v6 = c157v6.Count
              c157v5.enemyAmount = c157v6
              c157v1[__renovice_for_0_0] = c157v5
            end
            c157v2 = v10
            c157v2:Name__a50deb5f(c157v1)
            c157v2 = gPlayerProfileMgr
            c157v4 = 0
            c157v2:Name__4be6b7ba(c157v4)
          end
        end
      end
    end
    c157v1 = next
    c157v1 = c157v1(c157v0)
    if c157v1 ~= nil then
      c157v1 = gGameRules
      c157v4 = false
      c157v1 = c157v1:Name__1120c939(c157v0, c157v4)
      v15 = c157v1
      c157v1 = true
      v40 = c157v1
      c157v1 = true
      v14 = c157v1
    end
    do return end
  end
  LoadEnemies = v181
  v181 = function()
    local c158v0
    c158v0 = v131
    c158v0()
    do return end
  end
  Close = v181
  v181 = function()
    local c159v0
    c159v0 = v133
    c159v0()
    do return end
  end
  ExitScreen = v181
  v181 = function()
    local c160v0, c160v1, c160v2
    c160v0 = v40
    if c160v0 then
      do return end
    end
    c160v0 = v43
    c160v0 = c160v0.mSortMenu
    c160v0 = c160v0:IsExpanded()
    if c160v0 then
      c160v0 = mMovie
      c160v2 = 0.15
      c160v0:Name__6dd115e2(c160v2)
    end
    c160v0 = v99
    c160v1 = v98
    c160v1 = c160v1.INVENTORY
    if c160v0 == c160v1 then
      c160v0 = v43
      c160v0 = c160v0:onKeyUp_MENU_CANCEL()
      if c160v0 then
        do return end
      end
    end
    c160v1 = v47
    c160v2 = v110
    c160v2 = c160v2.EXIT
    c160v0 = c160v1[c160v2]
    c160v0 = c160v0.mCallback
    c160v0()
    do return end
  end
  onKeyUp_MENU_CANCEL = v181
  v181 = function(c161v0)
    local c161v1, c161v2, c161v3, c161v4, c161v5, c161v6
    c161v1 = Engine.IsPlayingWithTouchscreen
    c161v1 = c161v1()
    if not c161v1 then
      do return end
    end
    c161v1 = v124
    c161v1 = c161v1.popupState
    c161v2 = v123
    c161v2 = c161v2.SHOW_UNTIL_SCROLL_OR_TAP
    if c161v1 == c161v2 then
      do return end
    end
    c161v1 = v40
    if not c161v1 then
      local __renovice_state_0 = 5
      c161v2 = v43
      c161v1 = IsNull
      c161v1 = c161v1(c161v2)
      if c161v1 then
      else
        __renovice_state_0 = 6
      end
      if __renovice_state_0 == 6 then
        c161v1 = v43
        c161v3 = tonumber
        c161v3 = c161v3(c161v0)
        c161v1 = c161v1:GetElementById(c161v3)
        c161v2 = IsNull
        c161v2 = c161v2(c161v1)
        if not c161v2 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        do return end
      elseif __renovice_state_0 == 8 then
        c161v2 = v124
        c161v3 = v123
        c161v3 = c161v3.DEFAULT
        c161v2.popupState = c161v3
        c161v2 = v43
        c161v2 = c161v2:GetFocusedElement()
        c161v3 = IsNull
        c161v3 = c161v3(c161v2)
        if c161v3 then
          __renovice_state_0 = 11
        else
          __renovice_state_0 = 9
        end
      end
      if __renovice_state_0 == 9 then
        c161v3 = c161v2.Id
        c161v4 = c161v1.Id
        if c161v3 ~= c161v4 then
          __renovice_state_0 = 11
        else
          __renovice_state_0 = 10
        end
      end
      if __renovice_state_0 == 10 then
        c161v3 = v144
        c161v3(c161v1)
        __renovice_state_0 = 12
      end
      if __renovice_state_0 == 11 then
        c161v3 = v43
        c161v5 = c161v1.Id
        c161v3:FocusElementById(c161v5)
        __renovice_state_0 = 12
      end
      if __renovice_state_0 == 12 then
        c161v3 = v43
        c161v5 = c161v1.Id
        c161v6 = true
        c161v3:SelectElementById(c161v5, c161v6)
      end
    end
    do return end
  end
  GridItemSelected = v181
  v181 = function(c162v0)
    local c162v1, c162v2, c162v3
    c162v2 = v43
    c162v1 = IsNull
    c162v1 = c162v1(c162v2)
    if not c162v1 then
      c162v1 = Engine.IsPlayingWithTouchscreen
      c162v1 = c162v1()
      if c162v1 then
        c162v1 = v124
        c162v1 = c162v1.popupState
        c162v2 = v123
        c162v2 = c162v2.SHOW_UNTIL_SCROLL_OR_TAP
        if c162v1 == c162v2 then
          do return end
        end
        c162v1 = v124
        c162v2 = v123
        c162v2 = c162v2.HIDE_DURING_LONG_PRESS
        c162v1.popupState = c162v2
        c162v1 = v124
        c162v2 = RealTime
        c162v2 = c162v2()
        c162v1.focusStartTime = c162v2
        c162v1 = v124
        c162v2 = v43
        c162v2 = c162v2:GetScroll()
        c162v1.focusStartTimeScroll = c162v2
      end
      c162v1 = v43
      c162v3 = tonumber
      c162v3 = c162v3(c162v0)
      c162v1:FocusElementById(c162v3)
    end
    do return end
  end
  GridItemFocused = v181
  v181 = function(c163v0)
    local c163v1, c163v2, c163v3
    c163v1 = Engine.IsPlayingWithTouchscreen
    c163v1 = c163v1()
    if c163v1 then
      c163v1 = v124
      c163v1 = c163v1.popupState
      c163v2 = v123
      c163v2 = c163v2.SHOW_UNTIL_SCROLL_OR_TAP
      if c163v1 == c163v2 then
        do return end
      end
    end
    c163v2 = v43
    c163v1 = IsNull
    c163v1 = c163v1(c163v2)
    if not c163v1 then
      c163v1 = v43
      c163v3 = tonumber
      c163v3 = c163v3(c163v0)
      c163v1:UnfocusElementById(c163v3)
    end
    do return end
  end
  GridItemUnfocused = v181
  v181 = function(c164v0)
    local c164v1, c164v2, c164v3, c164v4
    c164v1 = Engine.IsPlayingWithTouchscreen
    c164v1 = c164v1()
    if c164v1 then
      do return end
    end
    c164v1 = v40
    if not c164v1 then
      c164v2 = v43
      c164v1 = IsNull
      c164v1 = c164v1(c164v2)
      if not c164v1 then
        c164v1 = v43
        c164v3 = tonumber
        c164v3 = c164v3(c164v0)
        c164v1:FocusElementById(c164v3)
        c164v1 = v43
        c164v3 = tonumber
        c164v3 = c164v3(c164v0)
        c164v4 = true
        c164v1:SelectElementById(c164v3, c164v4)
      end
    end
    do return end
  end
  GridItemPressed = v181
  v181 = function(c165v0)
    local c165v1, c165v2, c165v3
    c165v2 = v43
    c165v2 = c165v2.mCategoryMenu
    c165v1 = IsNull
    c165v1 = c165v1(c165v2)
    if not c165v1 then
      c165v1 = v43
      c165v1 = c165v1.mCategoryMenu
      c165v3 = tonumber
      c165v3 = c165v3(c165v0)
      c165v1:FocusElementById(c165v3)
    end
    do return end
  end
  CategoryFocused = v181
  v181 = function(c166v0)
    local c166v1, c166v2, c166v3
    c166v2 = v43
    c166v2 = c166v2.mCategoryMenu
    c166v1 = IsNull
    c166v1 = c166v1(c166v2)
    if not c166v1 then
      c166v1 = v43
      c166v1 = c166v1.mCategoryMenu
      c166v3 = tonumber
      c166v3 = c166v3(c166v0)
      c166v1:UnfocusElementById(c166v3)
    end
    do return end
  end
  CategoryUnfocused = v181
  v181 = function(c167v0)
    local c167v1, c167v2, c167v3, c167v4, c167v5, c167v6, c167v7
    c167v1 = v40
    if not c167v1 then
      c167v2 = v43
      c167v2 = c167v2.mCategoryMenu
      c167v1 = IsNull
      c167v1 = c167v1(c167v2)
      if not c167v1 then
        c167v1 = v43
        c167v1 = c167v1.mCategoryMenu
        c167v3 = tonumber
        c167v3 = c167v3(c167v0)
        c167v4 = true
        c167v1:SelectElementById(c167v3, c167v4)
        c167v1 = v95
        c167v2 = v94
        c167v2 = c167v2.FISH
        if c167v1 == c167v2 then
          if c167v0 == "1" then
            c167v2 = v47
            c167v3 = v110
            c167v3 = c167v3.FISH_CATEGORY
            c167v1 = c167v2[c167v3]
            c167v2 = "/Lotus/Language/Menu/ItemInventory_SelectAll"
            c167v1.mLabel = c167v2
          else
            if c167v0 == "2" then
              c167v1 = mMovie
              c167v3 = "/Lotus/Language/UiElements/SelectAllFishCategorySmall"
              c167v4 = true
              c167v1 = c167v1:GetLocalized(c167v3, c167v4)
              c167v3 = v47
              c167v4 = v110
              c167v4 = c167v4.FISH_CATEGORY
              c167v2 = c167v3[c167v4]
              c167v3 = mMovie
              c167v5 = "/Lotus/Language/UiElements/SelectAllFishCategory"
              c167v6 = false
              c167v7 = { CATEGORY = nil }
              c167v7.CATEGORY = c167v1
              c167v3 = c167v3:GetLocalized(c167v5, c167v6, c167v7)
              c167v2.mLabel = c167v3
            else
              if c167v0 == "3" then
                c167v1 = mMovie
                c167v3 = "/Lotus/Language/UiElements/SelectAllFishCategoryMedium"
                c167v4 = true
                c167v1 = c167v1:GetLocalized(c167v3, c167v4)
                c167v3 = v47
                c167v4 = v110
                c167v4 = c167v4.FISH_CATEGORY
                c167v2 = c167v3[c167v4]
                c167v3 = mMovie
                c167v5 = "/Lotus/Language/UiElements/SelectAllFishCategory"
                c167v6 = false
                c167v7 = { CATEGORY = nil }
                c167v7.CATEGORY = c167v1
                c167v3 = c167v3:GetLocalized(c167v5, c167v6, c167v7)
                c167v2.mLabel = c167v3
              else
                if c167v0 == "4" then
                  c167v1 = mMovie
                  c167v3 = "/Lotus/Language/UiElements/SelectAllFishCategoryLarge"
                  c167v4 = true
                  c167v1 = c167v1:GetLocalized(c167v3, c167v4)
                  c167v3 = v47
                  c167v4 = v110
                  c167v4 = c167v4.FISH_CATEGORY
                  c167v2 = c167v3[c167v4]
                  c167v3 = mMovie
                  c167v5 = "/Lotus/Language/UiElements/SelectAllFishCategory"
                  c167v6 = false
                  c167v7 = { CATEGORY = nil }
                  c167v7.CATEGORY = c167v1
                  c167v3 = c167v3:GetLocalized(c167v5, c167v6, c167v7)
                  c167v2.mLabel = c167v3
                end
              end
            end
          end
          c167v1 = v119
          c167v1()
        end
      end
    end
    do return end
  end
  CategoryPressed = v181
  v181 = function(c168v0)
    do return end
  end
  SortByFocused = v181
  v181 = function(c169v0)
    do return end
  end
  SortByUnfocused = v181
  v181 = function(c170v0)
    do return end
  end
  SortByPressed = v181
  v181 = function()
    local c171v0, c171v1, c171v2, c171v3
    c171v0 = v40
    if not c171v0 then
      c171v1 = v43
      c171v0 = IsNull
      c171v0 = c171v0(c171v1)
      if not c171v0 then
        c171v0 = v43
        c171v2 = v24
        c171v2 = c171v2.DECREMENT
        c171v3 = false
        c171v0:OnCategoryPress(c171v2, c171v3)
      end
    end
    c171v0 = true
    do return c171v0 end
  end
  onKeyUp_MENU_LTRIGGER2 = v181
  v181 = function()
    local c172v0, c172v1, c172v2, c172v3
    c172v0 = v40
    if not c172v0 then
      c172v1 = v43
      c172v0 = IsNull
      c172v0 = c172v0(c172v1)
      if not c172v0 then
        c172v0 = v43
        c172v2 = v24
        c172v2 = c172v2.INCREMENT
        c172v3 = false
        c172v0:OnCategoryPress(c172v2, c172v3)
      end
    end
    c172v0 = true
    do return c172v0 end
  end
  onKeyUp_MENU_RTRIGGER2 = v181
  v181 = function()
    local c173v0, c173v1, c173v2, c173v3
    c173v0 = v40
    if not c173v0 then
      c173v1 = v43
      c173v0 = IsNull
      c173v0 = c173v0(c173v1)
      if not c173v0 then
        c173v0 = v43
        c173v2 = v24
        c173v2 = c173v2.DECREMENT
        c173v3 = true
        c173v0:OnCategoryPress(c173v2, c173v3)
      end
    end
    c173v0 = true
    do return c173v0 end
  end
  onKeyDown_MENU_LTRIGGER2 = v181
  v181 = function()
    local c174v0, c174v1, c174v2, c174v3
    c174v0 = v40
    if not c174v0 then
      c174v1 = v43
      c174v0 = IsNull
      c174v0 = c174v0(c174v1)
      if not c174v0 then
        c174v0 = v43
        c174v2 = v24
        c174v2 = c174v2.INCREMENT
        c174v3 = true
        c174v0:OnCategoryPress(c174v2, c174v3)
      end
    end
    c174v0 = true
    do return c174v0 end
  end
  onKeyDown_MENU_RTRIGGER2 = v181
  v181 = function()
    local c175v0, c175v1
    c175v1 = v43
    c175v0 = IsNull
    c175v0 = c175v0(c175v1)
    if not c175v0 then
      c175v1 = v43
      c175v1 = c175v1.mSortMenu
      c175v0 = IsNull
      c175v0 = c175v0(c175v1)
      if not c175v0 then
        c175v0 = v43
        c175v0 = c175v0.mSortMenu
        c175v0:ArrowPressed()
      end
    end
    do return end
  end
  DropDownArrowPressed = v181
  v181 = function()
    local c176v0, c176v1
    c176v1 = v43
    c176v0 = IsNull
    c176v0 = c176v0(c176v1)
    if not c176v0 then
      c176v1 = v43
      c176v1 = c176v1.mSortMenu
      c176v0 = IsNull
      c176v0 = c176v0(c176v1)
      if not c176v0 then
        c176v0 = v43
        c176v0 = c176v0.mSortMenu
        c176v0:ArrowFocused()
      end
    end
    do return end
  end
  DropDownArrowFocused = v181
  v181 = function()
    local c177v0, c177v1
    c177v1 = v43
    c177v0 = IsNull
    c177v0 = c177v0(c177v1)
    if not c177v0 then
      c177v1 = v43
      c177v1 = c177v1.mSortMenu
      c177v0 = IsNull
      c177v0 = c177v0(c177v1)
      if not c177v0 then
        c177v0 = v43
        c177v0 = c177v0.mSortMenu
        c177v0:ArrowUnfocused()
      end
    end
    do return end
  end
  DropDownArrowUnfocused = v181
  v181 = function()
    local c178v0
    c178v0 = v40
    do return c178v0 end
  end
  IsInputBlocked = v181
  v181 = function()
    local c180v0, c180v1, c180v2, c180v3, c180v4
    c180v0 = v98
    c180v0 = c180v0.INVENTORY
    v99 = c180v0
    c180v0 = v43
    c180v2 = function(c179v0)
      local c179v1
      c179v1 = c179v0.Filler
      if not c179v1 then
        c179v1 = v114
        c179v1(c179v0)
      end
      do return end
    end
    c180v0:RunForAllVisibleElements(c180v2)
    c180v0 = v45
    c180v0 = c180v0:GetFocusedElement()
    c180v1 = IsNull
    c180v1 = c180v1(c180v0)
    if not c180v1 then
      c180v1 = mMovie
      c180v3 = "SellListItemUnfocused"
      c180v4 = c180v0.Id
      c180v1:Execute(c180v3, c180v4)
    end
    do return end
  end
  SelectAllCategoryItems = v181
  v114 = function(c181v0)
    local c181v1, c181v2, c181v3, c181v4, c181v5, c181v6
    c181v1 = IsNull
    c181v1 = c181v1(c181v0)
    if not c181v1 then
      c181v1 = v148
      c181v3 = false
      c181v4 = nil
      c181v5 = true
      c181v1(c181v0, c181v3, c181v4, c181v5)
      do return end
    end
    c181v2 = v43
    c181v1 = IsNull
    c181v1 = c181v1(c181v2)
    if not c181v1 then
      c181v1 = v43
      c181v1 = c181v1:GetFocusedElement()
      c181v2 = IsNull
      c181v2 = c181v2(c181v1)
      if not c181v2 then
        c181v2 = v24
        c181v2 = c181v2.PlaySound
        c181v3 = _G
        c181v3 = c181v3.UISound_Select
        c181v2(c181v3)
        c181v2 = v148
        c181v4 = false
        c181v5 = nil
        c181v6 = true
        c181v2(c181v1, c181v4, c181v5, c181v6)
        do return end
      end
    end
    c181v2 = v45
    c181v1 = IsNull
    c181v1 = c181v1(c181v2)
    if not c181v1 then
      c181v1 = v45
      c181v1 = c181v1:GetFocusedElement()
      c181v2 = IsNull
      c181v2 = c181v2(c181v1)
      if not c181v2 then
        c181v2 = v148
        c181v2(c181v1)
      end
    end
    do return end
  end
  v181 = function()
    local c182v0, c182v1
    c182v0 = v24
    c182v0 = c182v0.PlaySound
    c182v1 = _G
    c182v1 = c182v1.UISound_Focus
    c182v0(c182v1)
    do return end
  end
  RollOver = v181
  v181 = function(c183v0, c183v1)
    local c183v2, c183v3, c183v4, c183v5, c183v6
    c183v2 = v24
    c183v2 = c183v2.Ternary
    c183v4 = v99
    c183v5 = v98
    c183v5 = c183v5.SELL
    if c183v4 ~= c183v5 then
      c183v3 = false
    else
      c183v3 = true
    end
    c183v4 = v45
    c183v4 = c183v4.mScrollBar
    c183v5 = v43
    c183v5 = c183v5.mScrollBar
    c183v2 = c183v2(c183v3, c183v4, c183v5)
    c183v3 = v40
    if not c183v3 then
      c183v3 = IsNull
      c183v3 = c183v3(c183v2)
      if not c183v3 then
        c183v5 = tonumber
        c183v5 = c183v5(c183v1)
        c183v6 = _G
        c183v6 = c183v6.UISound_Scroll
        c183v2:ScrollByStep(c183v5, c183v6)
      end
    end
    do return end
  end
  onKeyDown_MENU_MOUSE_Z = v181
  v181 = function(c184v0, c184v1)
    local c184v2, c184v3, c184v4, c184v5, c184v6
    c184v2 = v43
    c184v4 = v55
    c184v2 = c184v2:GetUnfilteredElementById(c184v4)
    if c184v1 ~= nil then
      c184v3 = tonumber
      c184v3 = c184v3(c184v1)
      if c184v3 == 1 then
        c184v3 = tonumber
        c184v3 = c184v3(c184v0)
        c184v4 = 0
        if c184v4 < c184v3 then
          c184v3 = IsNull
          c184v3 = c184v3(c184v2)
          if not c184v3 then
            c184v3 = v142
            c184v5 = nil
            c184v6 = tonumber
            c184v6 = c184v6(c184v0)
            c184v3(c184v2, c184v5, c184v6)
          end
        end
      end
    end
    do return end
  end
  OKSaveSelectedCount = v181
  v181 = function(c185v0, c185v1)
    local c185v2, c185v3, c185v4, c185v5, c185v6, c185v7, c185v8, c185v9, c185v10, c185v11
    c185v2 = v43
    c185v4 = v55
    c185v2 = c185v2:GetUnfilteredElementById(c185v4)
    if c185v1 ~= nil then
      c185v3 = tonumber
      c185v3 = c185v3(c185v1)
      if c185v3 == 1 then
        c185v3 = tonumber
        c185v3 = c185v3(c185v0)
        c185v4 = 0
        if c185v4 < c185v3 then
          c185v3 = IsNull
          c185v3 = c185v3(c185v2)
          if not c185v3 then
            c185v3 = c185v2.mInstalled
            if c185v3 ~= nil then
              c185v3 = c185v2.Count
              c185v4 = tonumber
              c185v4 = c185v4(c185v0)
              if c185v3 == c185v4 then
                c185v3 = c185v2.Category
                c185v4 = 4
                if c185v3 == c185v4 then
                  c185v3 = -1
                  c185v4 = pairs
                  c185v5 = c185v2.mInstalled
                  c185v4, c185v5, c185v6 = c185v4(c185v5)
                  for __renovice_for_0_0, __renovice_for_0_1 in c185v4, c185v5, c185v6 do
                    c185v3 = c185v3 + 1
                  end
                  c185v4 = ""
                  c185v5 = 0
                  if c185v5 < c185v3 then
                    c185v5 = mMovie
                    c185v7 = "/Lotus/Language/SystemMessages/ConfirmDistillInstalledWarningExtra"
                    c185v8 = true
                    c185v9 = { COUNT = nil }
                    c185v9.COUNT = c185v3
                    c185v4 = c185v5:GetLocalized(c185v7, c185v8, c185v9)
                  end
                  c185v5 = mMovie
                  c185v7 = "/Lotus/Language/SystemMessages/ConfirmDistillInstalledWarning"
                  c185v8 = true
                  c185v9 = { ITEM = nil, NAME = nil, EXTRA = nil }
                  c185v10 = c185v2.Name
                  c185v9.ITEM = c185v10
                  c185v10 = string.upper
                  c185v11 = c185v2.FirstInstalledName
                  c185v10 = c185v10(c185v11)
                  c185v9.NAME = c185v10
                  c185v9.EXTRA = c185v4
                  c185v5 = c185v5:GetLocalized(c185v7, c185v8, c185v9)
                  c185v6 = tonumber
                  c185v6 = c185v6(c185v0)
                  v56 = c185v6
                  c185v6 = v24
                  c185v6 = c185v6.ShowYesOrNoMessage
                  c185v8 = "ConfirmMultiSelection"
                  c185v6(c185v5, c185v8)
                  do return end
                end
              end
            end
            c185v3 = OKSaveSelectedCount
            c185v3(c185v0, c185v1)
          end
        end
      end
    end
    do return end
  end
  OKSaveSelectedArcaneCount = v181
  v181 = function(c186v0)
    local c186v1, c186v2, c186v3, c186v4, c186v5, c186v6
    c186v1 = tonumber
    c186v1 = c186v1(c186v0)
    c186v2 = 4
    if c186v1 == c186v2 then
      c186v1 = v43
      c186v3 = v55
      c186v1 = c186v1:GetUnfilteredElementById(c186v3)
      c186v2 = IsNull
      c186v2 = c186v2(c186v1)
      if not c186v2 then
        c186v2 = v142
        c186v4 = nil
        c186v5 = 1
        c186v6 = true
        c186v2(c186v1, c186v4, c186v5, c186v6)
      end
    end
    do return end
  end
  ConfirmSelection = v181
  v181 = function(c187v0)
    local c187v1, c187v2, c187v3
    c187v1 = tonumber
    c187v1 = c187v1(c187v0)
    c187v2 = 4
    if c187v1 == c187v2 then
      c187v1 = OKSaveSelectedCount
      c187v2 = v56
      c187v3 = 1
      c187v1(c187v2, c187v3)
    end
    do return end
  end
  ConfirmMultiSelection = v181
  v181 = function(c188v0)
    local c188v1, c188v2, c188v3, c188v4, c188v5, c188v6
    c188v1 = v23
    c188v1 = c188v1.IsInHub
    c188v1 = c188v1()
    if not c188v1 then
      c188v1 = v23
      c188v1 = c188v1.MakeMainMenuAvatarKneel
      c188v1()
    end
    c188v1 = _T.LoadoutSaveRequired
    if c188v1 then
      c188v1 = _T.loadoutInProgress
      if c188v1 ~= nil then
        c188v2 = v46
        c188v1 = IsNull
        c188v1 = c188v1(c188v2)
        if not c188v1 then
          v52 = c188v0
          c188v1 = true
          v51 = c188v1
          c188v3 = 0
          c188v4 = 11
          c188v1 = c188v4 - 1
          c188v2 = 1
          for __renovice_for_0_0 = c188v3, c188v1, c188v2 do
            c188v4 = v46
            c188v4 = c188v4:GetInventory()
            c188v6 = _T.loadoutInProgress
            c188v5 = c188v6[__renovice_for_0_0]
            c188v4:SetLoadoutPreset(__renovice_for_0_0, c188v5)
          end
          c188v1 = v46
          c188v3 = "OnSaveLoadOutComplete"
          c188v1:SaveLoadOut(c188v3)
          c188v1 = _T
          c188v2 = nil
          c188v1.loadoutInProgress = c188v2
          c188v1 = _T
          c188v2 = nil
          c188v1.LoadoutSaveRequired = c188v2
          c188v1 = true
          do return c188v1 end
        end
      end
    end
    do return end
  end
  HandleCanBeClosed = v181
  v181 = function(c189v0, c189v1, c189v2, c189v3)
    local c189v4, c189v5
    c189v5 = v57
    c189v4 = IsNull
    c189v4 = c189v4(c189v5)
    if not c189v4 then
      c189v4 = v57
      c189v4:OnViewportSizeChanged()
    end
    c189v5 = v38
    c189v4 = IsNull
    c189v4 = c189v4(c189v5)
    if not c189v4 then
      c189v4 = v38
      c189v4:Update(c189v0, c189v1)
    end
    c189v5 = v43
    c189v4 = IsNull
    c189v4 = c189v4(c189v5)
    if not c189v4 then
      c189v5 = v45
      c189v4 = IsNull
      c189v4 = c189v4(c189v5)
      if not c189v4 then
        c189v4 = v153
        c189v4()
      end
    end
    do return end
  end
  onViewportSizeChanged = v181
  v181 = function(c190v0, c190v1)
    local c190v2, c190v3, c190v4, c190v5, c190v6, c190v7, c190v8, c190v9
    c190v3 = c190v1.x
    c190v4 = c190v0.x
    c190v2 = c190v3 - c190v4
    c190v4 = c190v1.y
    c190v5 = c190v0.y
    c190v3 = c190v4 - c190v5
    c190v5 = c190v1.z
    c190v6 = c190v0.z
    c190v4 = c190v5 - c190v6
    c190v8 = c190v2 * c190v2
    c190v9 = c190v3 * c190v3
    c190v7 = c190v8 + c190v9
    c190v8 = c190v4 * c190v4
    c190v6 = c190v7 + c190v8
    c190v5 = math.sqrt
    c190v5 = c190v5(c190v6)
    do return c190v5 end
  end
  CalculateDistance3DVector = v181
  v181 = function(c191v0, c191v1)
    local c191v2, c191v3, c191v4
    c191v2 = _T.InfoPopup_Data
    c191v3 = IsNull
    c191v3 = c191v3(c191v2)
    if c191v3 then
      c191v3 = false
      do return c191v3 end
    end
    c191v4 = c191v2.IsWithinPopup
    c191v3 = IsNull
    c191v3 = c191v3(c191v4)
    if c191v3 then
      c191v3 = false
      do return c191v3 end
    end
    c191v3 = c191v2.IsWithinPopup
    do return c191v3(c191v0, c191v1) end
  end
  v182 = function()
    local c192v0, c192v1
    c192v0 = v124
    c192v1 = false
    c192v0.mouseDown = c192v1
    c192v0 = v124
    c192v1 = false
    c192v0.dragStarted = c192v1
    c192v0 = v124
    c192v1 = RealTime
    c192v1 = c192v1()
    c192v0.mouseDownTime = c192v1
    c192v0 = v43
    c192v0:StopScrollDrag()
    do return end
  end
  clearMobileDrag = v182
  v182 = function(c193v0, c193v1, c193v2, c193v3)
    local c193v4, c193v5, c193v6, c193v7, c193v8, c193v9, c193v10, c193v11, c193v12
    c193v4 = string.find
    c193v6 = "MOUSE_B2"
    c193v4 = c193v4(c193v1, c193v6)
    if (c193v4 ~= nil and c193v2 == "0") then
      c193v4 = v114
      c193v4()
    end
    c193v4 = Engine.IsPlayingWithTouchscreen
    c193v4 = c193v4()
    if c193v4 then
      c193v4 = v40
      if c193v4 then
        c193v4 = clearMobileDrag
        c193v4()
        do return end
      end
    end
    c193v4 = Engine.IsPlayingWithTouchscreen
    c193v4 = c193v4()
    if c193v4 then
      c193v5 = v43
      c193v4 = IsNull
      c193v4 = c193v4(c193v5)
      if not c193v4 then
        c193v5 = mMovie
        c193v5 = c193v5:GetCursorX(c193v3)
        c193v6 = mMovie
        c193v6 = c193v6:GetViewportWidth()
        c193v4 = c193v5 / c193v6
        c193v6 = mMovie
        c193v6 = c193v6:GetCursorY(c193v3)
        c193v7 = mMovie
        c193v7 = c193v7:GetViewportHeight()
        c193v5 = c193v6 / c193v7
        c193v6 = { xMin = 0.04, xMax = 0.745, yMin = 0.17, yMax = 0.93 }
        c193v7 = false
        c193v8 = c193v6.xMin
        if c193v8 < c193v4 then
          c193v7 = false
          c193v8 = c193v6.xMax
          if c193v4 < c193v8 then
            c193v7 = false
            c193v8 = c193v6.yMin
            if c193v8 < c193v5 then
              c193v8 = c193v6.yMax
              if c193v8 <= c193v5 then
                c193v7 = false
              else
                c193v7 = true
              end
            end
          end
        end
        c193v8 = v181
        c193v8 = c193v8(c193v4, c193v5)
        c193v9 = string.find
        c193v11 = "MOUSE_B0"
        c193v9 = c193v9(c193v1, c193v11)
        if c193v9 ~= nil then
          if ((c193v2 == "1" and c193v7) and not c193v8) then
            c193v9 = Vector
            c193v10 = mMovie
            c193v10 = c193v10:GetCursorX(c193v3)
            c193v11 = mMovie
            c193v11 = c193v11:GetCursorY(c193v3)
            c193v12 = 0
            c193v9 = c193v9(c193v10, c193v11, c193v12)
            c193v10 = v124
            c193v11 = true
            c193v10.mouseDown = c193v11
            c193v10 = v124
            c193v11 = RealTime
            c193v11 = c193v11()
            c193v10.mouseDownTime = c193v11
            v124.mousePos = c193v9
          else
            if c193v2 == "0" then
              c193v9 = clearMobileDrag
              c193v9()
              c193v9 = v43
              c193v9:StopScrollDrag()
            end
          end
          if c193v2 == "1" then
            c193v9 = v124
            c193v9 = c193v9.popupState
            c193v10 = v123
            c193v10 = c193v10.SHOW_UNTIL_SCROLL_OR_TAP
            if (c193v9 == c193v10 and not c193v8) then
              c193v9 = v43
              c193v9 = c193v9:GetFocusedElement()
              c193v10 = IsNull
              c193v10 = c193v10(c193v9)
              if not c193v10 then
                c193v10 = v43
                c193v12 = c193v9.Id
                c193v10:UnfocusElementById(c193v12)
              end
            end
          end
        end
      end
    end
    c193v4 = _T.CapturaListBindings
    if c193v4 then
      c193v6 = 1
      c193v7 = _T.CapturaListBindings
      c193v4 = #c193v7
      c193v5 = 1
      for __renovice_for_0_0 = c193v6, c193v4, c193v5 do
        c193v7 = string.find
        c193v10 = _T.CapturaListBindings
        c193v9 = c193v10[__renovice_for_0_0]
        c193v9 = c193v9.Key
        c193v7 = c193v7(c193v1, c193v9)
        if c193v7 == nil then
          continue
        end
        c193v8 = _T.CapturaListBindings
        c193v7 = c193v8[__renovice_for_0_0]
        c193v7 = c193v7.IsDown
        if (c193v7 and c193v2 == "0") then
          c193v7 = _T
          c193v8 = nil
          c193v7.CapturaListBindings = c193v8
          c193v7 = Engine.IsMobile
          c193v7 = c193v7()
          if c193v7 then break end
          c193v7 = mMovie
          c193v9 = false
          c193v7:Name__f7d22364(c193v9)
          do return end
        end
        c193v8 = _T.CapturaListBindings
        c193v7 = c193v8[__renovice_for_0_0]
        if c193v2 ~= "1" then
          c193v8 = false
        else
          c193v8 = true
        end
        c193v7.IsDown = c193v8
      end
    end
    do return end
  end
  onRawInputEvent = v182
  v182 = function()
    local c194v0
    c194v0 = v40
    if not c194v0 then
      c194v0 = v133
      c194v0()
    end
    c194v0 = true
    do return c194v0 end
  end
  onKeyDown_HIDE_PAUSE_MENU = v182
  v182 = function(c195v0)
    v53 = c195v0
    do return end
  end
  SetOnMarkedToSellFunction = v182
  v182 = function()
    local c196v0, c196v1
    c196v0 = v171
    c196v0()
    c196v1 = _T.ShowBackground
    c196v0 = IsNull
    c196v0 = c196v0(c196v1)
    if not c196v0 then
      c196v0 = _T.ShowBackground
      c196v0()
    end
    do return end
  end
  OnStyleChangedCallback = v182
  v182 = function(c197v0)
    local c197v1, c197v2, c197v3, c197v4
    c197v2 = v47
    c197v3 = v110
    c197v3 = c197v3.SELECT_ALL
    c197v1 = c197v2[c197v3]
    if c197v1 ~= nil then
      c197v2 = v47
      c197v3 = v110
      c197v3 = c197v3.SELECT_ALL
      c197v1 = c197v2[c197v3]
      c197v2 = false
      c197v3 = v95
      c197v4 = v94
      c197v4 = c197v4.FISH
      if c197v3 ~= c197v4 then
        c197v2 = false
        c197v3 = v95
        c197v4 = v94
        c197v4 = c197v4.ENEMIES
        if c197v3 ~= c197v4 then
          c197v2 = false
          c197v3 = v95
          c197v4 = v94
          c197v4 = c197v4.SHIP_SCRAP
          if c197v3 ~= c197v4 then
            c197v2 = false
            c197v3 = v95
            c197v4 = v94
            c197v4 = c197v4.SHIP_PARTS
            if c197v3 ~= c197v4 then
              c197v2 = false
              c197v3 = v95
              c197v4 = v94
              c197v4 = c197v4.SHIP_RAW
              if c197v3 ~= c197v4 then
                c197v2 = Engine.IsPlayingWithController
                c197v2 = c197v2()
              end
            end
          end
        end
      end
      c197v1.mVisible = c197v2
    end
    c197v1 = v119
    c197v1()
    c197v1 = Engine.IsMobile
    c197v1 = c197v1()
    if c197v1 then
      c197v1 = v176
      c197v1()
    end
    do return end
  end
  OnGamepadTransition = v182
  v182 = function()
    local c198v0
    c198v0 = true
    do return c198v0 end
  end
  SupportsThemes = v182
  v111 = function()
    local c200v0, c200v1, c200v2, c200v3, c200v4, c200v5, c200v6, c200v7, c200v8, c200v9, c200v10, c200v11, c200v12, c200v13, c200v14, c200v15, c200v16, c200v17, c200v18, c200v19, c200v20, c200v21, c200v22, c200v23, c200v24, c200v25, c200v26, c200v27, c200v28, c200v29, c200v30, c200v31, c200v32
    c200v16 = true
    c200v18 = IsNull
    c200v12 = nil
    c200v18 = c200v18(c200v12)
    c200v18 = string.find
    c200v19 = c200v12:GetFullName()
    c200v20 = "SpaceBattle"
    c200v18 = c200v18(c200v19, c200v20)
    c200v16 = true
    c200v3 = nil
    c200v18 = c200v12:IsA(c200v3)
    c200v16 = true
    c200v20 = 1
    c200v21 = simulacrumSpawnableBossTypes
    c200v18 = #c200v21
    c200v19 = 1
    for __renovice_for_0_0 = c200v20, c200v18, c200v19 do
      c200v21 = simulacrumSpawnableBossTypes[__renovice_for_0_0]
      if c200v12 == c200v21 then break end
    end
    c200v16 = false
    c200v11 = nil
    c200v18 = c200v11.sourceType
    c200v19 = IsNull
    c200v19 = c200v19(c200v18)
    c200v19 = IsNull
    c200v19 = c200v19(c200v12)
    c200v20 = missingCodexEnemyAvatarTypes
    c200v19 = #c200v20
    c200v21 = missingCodexEnemyAgentTypes
    c200v20 = #c200v21
    c200v21 = 1
    c200v22 = missingCodexEnemyAvatarTypes
    c200v19 = #c200v22
    c200v20 = 1
    c200v22 = missingCodexEnemyAvatarTypes[c200v21]
    c200v18 = missingCodexEnemyAgentTypes[c200v21]
    c200v19 = print
    c200v20 = "Mismatch between codex enemy lists: missingCodexEnemyAvatarTypes and missingCodexEnemyAgentTypes"
    c200v19(c200v20)
    c200v18 = v12
    if c200v18 then
      c200v16 = false
    end
    c200v7 = nil
    c200v10 = nil
    c200v11 = c200v7[c200v10]
    c200v12 = c200v11.type
    c200v14 = v11
    c200v15 = c200v12:GetFullName()
    c200v13 = c200v14[c200v15]
    if not c200v13 then
      c200v13 = 0
    end
    c200v14 = true
    c200v15 = true
    c200v16 = false
    c200v17 = 3
    c200v18 = Clamp
    c200v20 = c200v11.reqScans
    c200v19 = c200v13 / c200v20
    c200v20 = 0
    c200v21 = 1
    c200v18 = c200v18(c200v19, c200v20, c200v21)
    if c200v18 == 1 then
      c200v14 = false
      c200v15 = false
      c200v17 = 1
    else
      c200v18 = 0
      if c200v18 < c200v13 then
        c200v15 = false
        c200v17 = 2
      end
    end
    c200v18 = c200v11.excludedFromSimulacrum
    c200v19 = IsNull
    c200v19 = c200v19(c200v18)
    if not c200v19 then
      c200v20 = c200v11.faction
      c200v4 = nil
      c200v19 = c200v4(c200v20)
      c200v20 = v30
      c200v20 = c200v20.GetLocalizedName
      c200v21 = mMovie
      c200v20 = c200v20(c200v21, c200v11)
      c200v21 = nil
      c200v22 = false
      if c200v15 then
        c200v23 = v13
        if not c200v23 then
          c200v21 = 8
          c200v22 = true
        end
      end
      c200v23 = { Name = nil, Categories = nil, Themed = true, CodexEntry = nil, Icon = nil, Type = nil, SourceType = nil, IsLeader = nil, Hidden = nil, Locked = nil, LockedMsg = nil, IconColor = nil, ShadowIcon = nil, ScannedId = nil, SellingPrice = 1 }
      c200v23.Name = c200v20
      c200v23.Categories = c200v19
      c200v23.CodexEntry = c200v11
      c200v24 = c200v11.icon
      c200v23.Icon = c200v24
      c200v23.Type = c200v12
      c200v23.SourceType = c200v18
      c200v24 = c200v11.isLeader
      c200v23.IsLeader = c200v24
      c200v24 = c200v15
      if c200v24 then
        c200v25 = v13
        c200v24 = not c200v25
      end
      c200v23.Hidden = c200v24
      c200v24 = c200v14
      if c200v24 then
        c200v25 = v13
        c200v24 = not c200v25
      end
      c200v23.Locked = c200v24
      c200v2 = nil
      c200v23.LockedMsg = c200v2
      c200v23.IconColor = c200v21
      c200v23.ShadowIcon = c200v22
      c200v23.ScannedId = c200v17
      c200v24 = ToSearchable
      c200v26 = c200v23.Name
      c200v27 = " "
      c200v28 = c200v11.faction
      c200v28 = c200v28:c_str()
      c200v25 = c200v26 .. c200v27 .. c200v28
      c200v24 = c200v24(c200v25)
      c200v23.SearchCache = c200v24
      c200v24 = c200v19[1]
      if c200v24 ~= nil then
        c200v6 = nil
        c200v25 = c200v6[c200v24]
        if c200v25 == nil then
          c200v25 = { Total = 0, Scanned = 0 }
          c200v6[c200v24] = c200v25
        end
        c200v25 = c200v6[c200v24]
        c200v26 = c200v25.Total
        c200v26 = c200v26 + 1
        c200v25.Total = c200v26
        c200v25 = c200v23.Locked
        if not c200v25 then
          c200v25 = c200v6[c200v24]
          c200v26 = c200v25.Scanned
          c200v26 = c200v26 + 1
          c200v25.Scanned = c200v26
        end
      end
      c200v25 = v43
      c200v28 = true
      c200v25:AddElement(c200v23, c200v28)
      c200v25 = c200v12:GetFullName()
      c200v5[c200v25] = c200v11
      c200v25 = _T.SpawnedEnemies
      c200v25 = ipairs
      c200v26 = _T.SpawnedEnemies
      c200v25, c200v26, c200v27 = c200v25(c200v26)
      for __renovice_for_1_0, __renovice_for_1_1 in c200v25, c200v26, c200v27 do
        c200v29 = __renovice_for_1_1.Type
        c200v30 = c200v12:GetFullName()
        if c200v29 ~= c200v30 then
          continue
        end
        c200v29 = c200v23.Hidden
        if c200v29 then
          continue
        end
        c200v29 = c200v23.Locked
        if c200v29 then
          continue
        end
        c200v29 = v142
        c200v31 = nil
        c200v32 = __renovice_for_1_1.Count
        c200v29(c200v23, c200v31, c200v32)
      end
      for __renovice_for_2_0, __renovice_for_2_1 in c200v25, c200v26, c200v27 do
      end
    end
    c200v1 = v9
    c200v0 = IsNull
    c200v0 = c200v0(c200v1)
    if c200v0 then
      do return end
    end
    c200v0 = v9
    c200v0 = c200v0:GetFilters()
    c200v1 = nil
    c200v4 = 1
    c200v2 = #c200v0
    c200v3 = 1
    for __renovice_for_3_0 = c200v4, c200v2, c200v3 do
      c200v5 = c200v0[__renovice_for_3_0]
      c200v5 = c200v5.tag
      c200v5 = c200v5:c_str()
      if c200v5 == "Enemy" then break end
      if c200v5 ~= "Enemy" then
        continue
      end
      c200v1 = c200v0[__renovice_for_3_0]
    end
    c200v2 = mMovie
    c200v4 = "/Lotus/Language/Menu/FocusLocked"
    c200v5 = false
    c200v2 = c200v2:GetLocalized(c200v4, c200v5)
    c200v3 = gLotusBossNpcAvatarType
    c200v4 = function(c199v0)
      local c199v1, c199v2, c199v3, c199v4
      c199v1 = {}
      if c199v0 == nil then
        do return c199v1 end
      end
      c199v2 = ToSearchable
      c199v0 = c199v2(c199v0:c_str())
      if c199v0 == "grineer" then
        c199v4 = v107
        c199v4 = c199v4.GRINEER
        c199v2 = table.insert
        c199v2(c199v1, c199v4)
        do return c199v1 end
      end
      if c199v0 == "corpus" then
        c199v4 = v107
        c199v4 = c199v4.CORPUS
        c199v2 = table.insert
        c199v2(c199v1, c199v4)
        do return c199v1 end
      end
      if c199v0 == "infestation" then
        c199v4 = v107
        c199v4 = c199v4.INFESTED
        c199v2 = table.insert
        c199v2(c199v1, c199v4)
        do return c199v1 end
      end
      if ((c199v0 ~= "neutral" and c199v0 ~= "predator") and (c199v0 ~= "prey" and c199v0 ~= "duviri")) then
        if c199v0 == "orokin" then
          c199v4 = v107
          c199v4 = c199v4.OROKIN
          c199v2 = table.insert
          c199v2(c199v1, c199v4)
          do return c199v1 end
        end
        if c199v0 == "sentient" then
          c199v4 = v107
          c199v4 = c199v4.SENTIENT
          c199v2 = table.insert
          c199v2(c199v1, c199v4)
          do return c199v1 end
        end
        if c199v0 == "narmer" then
          c199v4 = v107
          c199v4 = c199v4.NARMER
          c199v2 = table.insert
          c199v2(c199v1, c199v4)
          do return c199v1 end
        end
        if c199v0 == "mitw" then
          c199v4 = v107
          c199v4 = c199v4.MURMUR
          c199v2 = table.insert
          c199v2(c199v1, c199v4)
          do return c199v1 end
        end
        if c199v0 == "scaldra" then
          c199v4 = v107
          c199v4 = c199v4.SCALDRA
          c199v2 = table.insert
          c199v2(c199v1, c199v4)
          do return c199v1 end
        end
        if c199v0 == "techrot" then
          c199v4 = v107
          c199v4 = c199v4.TECHROT
          c199v2 = table.insert
          c199v2(c199v1, c199v4)
          do return c199v1 end
        end
        if c199v0 == "anarch" then
          c199v4 = v107
          c199v4 = c199v4.ANARCH
          c199v2 = table.insert
          c199v2(c199v1, c199v4)
          do return c199v1 end
        end
        c199v2 = print
        c199v4 = "Unknown Faction: "
        c199v3 = c199v4 .. c199v0
        c199v2(c199v3)
        do return c199v1 end
      end
      c199v4 = v107
      c199v4 = c199v4.WILD
      c199v2 = table.insert
      c199v2(c199v1, c199v4)
      do return c199v1 end
    end
    c200v5 = {}
    c200v6 = {}
    c200v7 = v9
    c200v7 = c200v7:Name__dc04892a(c200v1)
    c200v10 = 1
    c200v8 = #c200v7
    c200v9 = 1
    c200v8 = v12
    if c200v8 then
      c200v8 = WeakResource
      c200v9 = "/Lotus/Types/Enemies/Grineer/AIWeek/LoboGrineerLancer"
      c200v8 = c200v8(c200v9)
      c200v9 = { Name = "PUNCHING BAG", Categories = nil, Themed = true, CodexEntry = nil, Icon = nil, Type = nil, SourceType = nil, IsLeader = false, Hidden = false, Locked = false, LockedMsg = "", IconColor = nil, ShadowIcon = true, ScannedId = 1, SellingPrice = 1 }
      c200v11 = v107
      c200v11 = c200v11.GRINEER
      c200v10 = {c200v11}
      c200v9.Categories = c200v10
      c200v10 = categoryIcons[1]
      c200v9.Icon = c200v10
      c200v9.Type = c200v8
      c200v9.SourceType = c200v8
      c200v10 = ToSearchable
      c200v11 = c200v9.Name
      c200v10 = c200v10(c200v11)
      c200v9.SearchCache = c200v10
      c200v10 = v43
      c200v13 = true
      c200v10:AddElement(c200v9, c200v13)
    end
    c200v10 = 1
    c200v11 = squadPresets
    c200v8 = #c200v11
    c200v9 = 1
    if not ((c200v9 > 0 and c200v10 > c200v8) or (c200v9 < 0 and c200v10 < c200v8)) then
      c200v11 = squadPresets[c200v10]
      c200v12 = c200v11:GetCategory()
      c200v13 = c200v6[c200v12]
      c200v15 = c200v13.Scanned
      c200v16 = c200v13.Total
      c200v14 = c200v15 / c200v16
      c200v15 = 0.3
      c200v14 = { CustomEntry = true, Name = nil, IsPreset = true, Categories = nil, Themed = true, Icon = nil, Types = nil }
      c200v15 = mMovie
      c200v17 = c200v11:GetLocTag()
      c200v17 = c200v17:c_str()
      c200v18 = false
      c200v15 = c200v15:GetLocalized(c200v17, c200v18)
      c200v14.Name = c200v15
      c200v15 = {c200v12}
      c200v14.Categories = c200v15
      c200v15 = c200v11:GetIcon()
      c200v14.Icon = c200v15
      c200v15 = c200v11:GetEnemies()
      c200v14.Types = c200v15
      c200v15 = ToSearchable
      c200v16 = c200v14.Name
      c200v15 = c200v15(c200v16)
      c200v14.SearchCache = c200v15
      c200v15 = ""
      c200v18 = 1
      c200v19 = c200v14.Types
      c200v16 = #c200v19
      c200v17 = 1
      for __renovice_for_4_0 = c200v18, c200v16, c200v17 do
        c200v20 = c200v14.Types
        c200v19 = c200v20[__renovice_for_4_0]
        c200v24 = v24
        c200v24 = c200v24.FormatNumber
        c200v25 = c200v19.mCount
        c200v21 = c200v24(c200v25)
        c200v22 = " x "
        c200v23 = mMovie
        c200v25 = c200v19.mLocTag
        c200v26 = false
        c200v23 = c200v23:GetLocalized(c200v25, c200v26)
        c200v15 = c200v15 .. c200v21 .. c200v22 .. c200v23
        c200v20 = c200v15
        c200v21 = v24
        c200v21 = c200v21.Ternary
        c200v24 = c200v14.Types
        c200v23 = #c200v24
        if __renovice_for_4_0 ~= c200v23 then
          c200v22 = false
        else
          c200v22 = true
        end
        c200v23 = ""
        c200v24 = "\r\n"
        c200v21 = c200v21(c200v22, c200v23, c200v24)
        c200v15 = c200v20 .. c200v21
      end
      c200v16 = mMovie
      c200v18 = "/Lotus/Language/Codex/PresetSquad_Desc"
      c200v19 = false
      c200v20 = { ENEMIES = nil }
      c200v20.ENEMIES = c200v15
      c200v16 = c200v16:GetLocalized(c200v18, c200v19, c200v20)
      c200v14.LocalizedDesc = c200v16
      c200v17 = c200v14.Types
      c200v16 = #c200v17
      c200v17 = 0
      if c200v17 < c200v16 then
        c200v17 = c200v14.Types
        c200v16 = c200v17[1]
        c200v16 = c200v16.mAvatarType
        c200v17 = IsNull
        c200v17 = c200v17(c200v16)
        if not c200v17 then
          c200v17 = c200v16:GetFullName()
          c200v18 = c200v5[c200v17]
          if c200v18 ~= nil then
            c200v18 = c200v5[c200v17]
            c200v14.CodexEntry = c200v18
            c200v18 = true
            c200v14.SkipFaction = c200v18
            c200v18 = true
            c200v14.SkipRegions = c200v18
            c200v18 = true
            c200v14.SkipEnemyDesc = c200v18
          end
        end
      end
      c200v16 = v43
      c200v16:AddElement(c200v14)
    end
    do return end
  end
  v182 = function()
    local c201v0, c201v1, c201v2, c201v3, c201v4
    c201v0 = mMovie
    c201v2 = "InventoryGrid"
    c201v3 = 12
    c201v4 = 100
    c201v0:SetNumberVariable(c201v2, c201v3, c201v4)
    c201v0 = v153
    c201v1 = true
    c201v0(c201v1)
    c201v0 = false
    v40 = c201v0
    do return end
  end
  FishFunctionCancelled = v182
  v182 = function()
    local c202v0, c202v1, c202v2, c202v3, c202v4
    c202v0 = mMovie
    c202v2 = "InventoryGrid"
    c202v3 = 12
    c202v4 = 0
    c202v0:SetNumberVariable(c202v2, c202v3, c202v4)
    c202v1 = _T
    c202v2 = _T.FishInvInfo.FunctName
    c202v0 = c202v1[c202v2]
    c202v1 = v45
    c202v1 = c202v1.mElements
    c202v0(c202v1)
    c202v0 = true
    v40 = c202v0
    do return end
  end
  FishFunction = v182
  v182 = function(c205v0)
    local c205v1, c205v2, c205v3, c205v4, c205v5, c205v6, c205v7, c205v8, c205v9, c205v10, c205v11, c205v12, c205v13, c205v14, c205v15, c205v16, c205v17, c205v18, c205v19, c205v20, c205v21, c205v22, c205v23, c205v24, c205v25, c205v26, c205v27
    c205v1 = _T.SyndicateInvInfo.Syndicate
    c205v2 = v92
    c205v3 = Lotus_Game.SyndicateStandingBonusOperation
    c205v3 = c205v3()
    c205v2.SyndicateStandingBonusOperation = c205v3
    c205v2 = v92
    c205v2 = c205v2.SyndicateStandingBonusOperation
    c205v3 = c205v1:GetAffiliationTag()
    c205v2.mAffiliationTag = c205v3
    c205v2 = 0
    c205v3 = v45
    c205v5 = function(c203v0)
      local c203v1, c203v2, c203v3, c203v4, c203v5
      c203v2 = c205v2
      c203v4 = c203v0.Count
      c203v5 = c203v0.RawItem
      c203v5 = c203v5.mStanding
      c203v3 = c203v4 * c203v5
      c203v1 = c203v2 + c203v3
      c205v2 = c203v1
      c203v1 = v92
      c203v1 = c203v1.SyndicateStandingBonusOperation
      c203v3 = c203v0.Type
      c203v4 = c203v0.Count
      c203v1:AddItem(c203v3, c203v4)
      do return end
    end
    c205v3:RunForAllElements(c205v5)
    c205v5 = v58
    if c205v2 ~= c205v5 then
      c205v4 = false
    else
      c205v4 = true
    end
    c205v3 = assert
    c205v3(c205v4)
    c205v3 = v23
    c205v3 = c205v3.GetReputationInfoForSyndicate
    c205v3, c205v4, c205v5, c205v6, c205v7 = c205v3(c205v1)
    c205v8 = c205v1:StandingBonusesCappedByDailyLimit()
    if not c205v8 then
      c205v9 = 0
      if c205v5 < c205v9 then
        c205v9 = math.abs
        c205v7 = c205v9(c205v4)
      else
        c205v7 = c205v5 - c205v4
      end
    end
    if not c205v0 then
      if c205v7 == 0 then
        c205v9 = "/Lotus/Language/Menu/Syndicates_ReputationOverflow"
        c205v10 = c205v1:GetDailyStandingLimitBin()
        c205v11 = 0
        if c205v11 < c205v10 then
          c205v11 = 15
          if c205v10 < c205v11 then
            c205v11 = v46
            c205v11 = c205v11:GetDailyStandingLimit(c205v10)
            if c205v11 == 0 then
              c205v9 = "/Lotus/Language/Menu/Syndicates_DogTag_DailyLimit_Reached"
            end
          end
        end
        c205v11 = v24
        c205v11 = c205v11.ShowErrorMessage
        c205v11(c205v9)
      else
        c205v9 = v58
        if c205v7 < c205v9 then
          c205v9 = mMovie
          c205v11 = "/Lotus/Language/Menu/Syndicates_DogTag_StandingWasteWarning"
          c205v12 = true
          c205v13 = { STANDING = nil }
          c205v14 = v24
          c205v14 = c205v14.FormatNumber
          c205v16 = v58
          c205v15 = c205v16 - c205v7
          c205v14 = c205v14(c205v15)
          c205v13.STANDING = c205v14
          c205v9 = c205v9:GetLocalized(c205v11, c205v12, c205v13)
          c205v10 = v24
          c205v10 = c205v10.ShowYesOrNoMessage
          c205v12 = "ConfirmDogTagPartial"
          c205v10(c205v9, c205v12)
          do return end
        end
      end
    end
    c205v9 = v58
    c205v11 = v58
    c205v10 = math.min
    c205v10 = c205v10(c205v11, c205v7)
    c205v11 = {}
    c205v14 = { Name = nil, Rep = nil }
    c205v15 = c205v1:GetUIName()
    c205v14.Name = c205v15
    c205v14.Rep = c205v10
    c205v12 = table.insert
    c205v12(c205v11, c205v14)
    c205v12 = ipairs
    c205v12, c205v13, c205v14 = c205v12(c205v1:GetAlignments())
    for __renovice_for_0_0, __renovice_for_0_1 in c205v12, c205v13, c205v14 do
      c205v18 = __renovice_for_0_1.other
      c205v17 = IsNull
      c205v17 = c205v17(c205v18)
      if c205v17 then
        continue
      end
      c205v17 = Resource
      c205v18 = __renovice_for_0_1.other
      c205v17 = c205v17(c205v18:GetFullName())
      c205v20 = { Name = nil, Rep = nil }
      c205v21 = c205v17:GetUIName()
      c205v20.Name = c205v21
      c205v22 = __renovice_for_0_1.multiplier
      c205v21 = c205v9 * c205v22
      c205v20.Rep = c205v21
      c205v18 = table.insert
      c205v18(c205v11, c205v20)
    end
    c205v12 = table.sort
    c205v14 = function(c204v0, c204v1)
      local c204v2, c204v3, c204v4
      c204v3 = c204v0.Rep
      c204v4 = c204v1.Rep
      if c204v3 <= c204v4 then
        c204v2 = false
        do return c204v2 end
      end
      c204v2 = true
      do return c204v2 end
    end
    c205v12(c205v11, c205v14)
    c205v12 = ""
    c205v13 = ipairs
    c205v13, c205v14, c205v15 = c205v13(c205v11)
    for __renovice_for_1_0, __renovice_for_1_1 in c205v13, c205v14, c205v15 do
      c205v23 = v24
      c205v23 = c205v23.FormatNumber
      c205v24 = __renovice_for_1_1.Rep
      c205v25 = 0
      c205v19 = c205v23(c205v24, c205v25)
      c205v20 = " "
      c205v23 = string.upper
      c205v24 = mMovie
      c205v26 = __renovice_for_1_1.Name
      c205v26 = c205v26:c_str()
      c205v27 = false
      c205v21 = c205v23(c205v24:GetLocalized(c205v26, c205v27))
      c205v22 = "\r"
      c205v12 = c205v12 .. c205v19 .. c205v20 .. c205v21 .. c205v22
    end
    c205v13 = mMovie
    c205v15 = "/Lotus/Language/Menu/StandingChangeConfirm"
    c205v16 = false
    c205v17 = { CHANGES = nil }
    c205v17.CHANGES = c205v12
    c205v12 = c205v13:GetLocalized(c205v15, c205v16, c205v17)
    c205v13 = v24
    c205v13 = c205v13.ShowYesOrNoMessage
    c205v15 = "ConfirmDogTagAll"
    c205v13(c205v12, c205v15)
    do return end
  end
  v183 = function()
    local c206v0
    c206v0 = v182
    c206v0()
    do return end
  end
  DonateDogTags = v183
  v183 = function(c207v0)
    local c207v1, c207v2
    c207v1 = tonumber
    c207v1 = c207v1(c207v0)
    c207v2 = 4
    if c207v1 == c207v2 then
      c207v1 = v182
      c207v2 = true
      c207v1(c207v2)
    end
    do return end
  end
  ConfirmDogTagPartial = v183
  v183 = function(c208v0)
    local c208v1, c208v2, c208v3, c208v4
    c208v1 = tonumber
    c208v1 = c208v1(c208v0)
    c208v2 = 4
    if c208v1 == c208v2 then
      c208v1 = v46
      c208v3 = v92
      c208v3 = c208v3.SyndicateStandingBonusOperation
      c208v4 = "OnDonateDogTagsComplete"
      c208v1:Name__8fe5ab92(c208v3, c208v4)
      c208v1 = v23
      c208v1 = c208v1.GetActiveSoundSet
      c208v1 = c208v1()
      c208v2 = redeemStandingSounds[c208v1]
      c208v3 = IsNull
      c208v3 = c208v3(c208v2)
      if not c208v3 then
        c208v3 = v24
        c208v3 = c208v3.PlaySound
        c208v3(c208v2)
      end
    end
    do return end
  end
  ConfirmDogTagAll = v183
  v183 = function(c209v0, c209v1)
    local c209v2, c209v3, c209v4, c209v5, c209v6, c209v7, c209v8, c209v9, c209v10, c209v11
    if c209v0 then
      c209v3 = _T.SyndicateInvInfo.Syndicate
      c209v2 = IsNull
      c209v2 = c209v2(c209v3)
      if not c209v2 then
        c209v2 = _T.SyndicateInvInfo.Syndicate
        c209v3 = _T.SyndicateInvInfo.VendorTag
        c209v4 = v92
        c209v5 = true
        c209v4.MadeTrade = c209v5
        c209v4 = _T
        c209v5 = true
        c209v4.MadeSyndicateTrade = c209v5
        c209v4 = cjson.decode
        c209v4 = c209v4(c209v1)
        c209v5 = c209v4.AffiliationMods
        if c209v5 ~= nil then
          c209v5 = tostring
          c209v5 = c209v5(c209v2:GetAffiliationTag())
          c209v6 = ipairs
          c209v7 = c209v4.AffiliationMods
          c209v6, c209v7, c209v8 = c209v6(c209v7)
          for __renovice_for_0_0, __renovice_for_0_1 in c209v6, c209v7, c209v8 do
            c209v9 = __renovice_for_0_1.Tag
            if c209v9 == nil then
              continue
            end
            c209v9 = __renovice_for_0_1.Tag
            if c209v9 ~= c209v5 then
              continue
            end
            c209v9 = __renovice_for_0_1.Standing
            if c209v9 == nil then break end
            c209v9 = __renovice_for_0_1.Standing
            c209v10 = 0
            if c209v9 <= c209v10 then break end
            _T.StandingSyndicateRewarded = c209v2
            c209v9 = _T
            c209v10 = __renovice_for_0_1.Standing
            c209v9.StandingRewarded = c209v10
            c209v9 = gFlashMgr
            c209v11 = v105
            c209v9:PushMovie(c209v11)
            break
          end
        end
        if c209v3 ~= nil then
          c209v5 = "DogTagRedeemed"
          c209v6 = EMPTY_SYMBOL
          if c209v3 ~= c209v6 then
            c209v7 = c209v3:c_str()
            c209v5 = c209v5 .. c209v7
          end
          c209v6 = v28
          c209v6 = c209v6.PlaySyndicateTransmission
          c209v6(c209v2, c209v5)
        end
        c209v5 = v133
        c209v5()
        do return end
      end
    end
    do return end
  end
  OnDonateDogTagsComplete = v183
  v183 = function()
    local c210v0, c210v1
    c210v0 = _T.ShardSelected
    c210v1 = v45
    c210v1 = c210v1.mElements
    c210v0(c210v1)
    c210v0 = v133
    c210v0()
    do return end
  end
  ConvertShards = v183
  v183 = function()
    local c211v0, c211v1
    c211v0 = _T.DecosSelected
    c211v1 = v45
    c211v1 = c211v1.mElements
    c211v0(c211v1)
    c211v0 = v133
    c211v0()
    do return end
  end
  DonateDecorations = v183
  v183 = function()
    local c212v0, c212v1, c212v2, c212v3, c212v4, c212v5, c212v6, c212v7, c212v8
    c212v1 = v46
    c212v0 = IsNull
    c212v0 = c212v0(c212v1)
    if c212v0 then
      do return end
    end
    c212v0 = {}
    c212v1 = {}
    c212v4 = 1
    c212v5 = v45
    c212v5 = c212v5.mElements
    c212v2 = #c212v5
    c212v3 = 1
    for __renovice_for_0_0 = c212v4, c212v2, c212v3 do
      c212v5 = ResetLineCount
      c212v6 = 0
      c212v5(c212v6)
      c212v6 = v45
      c212v6 = c212v6.mElements
      c212v5 = c212v6[__renovice_for_0_0]
      c212v6 = c212v5.Category
      if c212v6 == nil then
        continue
      end
      c212v6 = c212v5.Category
      c212v7 = c212v0[c212v6]
      if c212v7 == nil then
        c212v7 = 1
        c212v0[c212v6] = c212v7
        c212v7 = v179
        c212v7 = c212v7(c212v6)
        c212v1[c212v6] = c212v7
        continue
      end
      c212v8 = c212v0[c212v6]
      c212v7 = c212v8 + 1
      c212v0[c212v6] = c212v7
    end
    c212v2 = pairs
    c212v2, c212v3, c212v4 = c212v2(c212v0)
    for __renovice_for_1_0, __renovice_for_1_1 in c212v2, c212v3, c212v4 do
      c212v7 = c212v1[__renovice_for_1_0]
      if c212v7 == nil then
        continue
      end
      c212v7 = c212v1[__renovice_for_1_0]
      c212v7 = c212v7.Count
      c212v8 = 0
      if c212v7 < c212v8 then
        continue
      end
      c212v7 = c212v1[__renovice_for_1_0]
      c212v7 = c212v7.Count
      if not (c212v7 <= __renovice_for_1_1) then
        continue
      end
      c212v7 = v24
      c212v7 = c212v7.ShowMessage
      c212v8 = "/Lotus/Language/Menu/ItemInventory_CantSellLastWeapon"
      c212v7(c212v8)
      do return end
    end
    c212v2 = Engine.IsMobile
    c212v2 = c212v2()
    if c212v2 then
      c212v3 = _T.TradeItemsSelected
      c212v2 = IsNull
      c212v2 = c212v2(c212v3)
      if not c212v2 then
        c212v3 = v45
        c212v2 = IsNull
        c212v2 = c212v2(c212v3)
        if not c212v2 then
          c212v3 = v45
          c212v3 = c212v3.mElements
          c212v2 = IsNull
          c212v2 = c212v2(c212v3)
          if not c212v2 then
            c212v2 = _T.TradeItemsSelected
            c212v3 = v45
            c212v3 = c212v3.mElements
            c212v2(c212v3)
          end
        end
      end
    else
      c212v2 = _T.TradeItemsSelected
      c212v3 = v45
      c212v3 = c212v3.mElements
      c212v2(c212v3)
    end
    c212v2 = v133
    c212v2()
    do return end
  end
  TradeItems = v183
  v183 = function()
    local c213v0, c213v1
    c213v1 = v46
    c213v0 = IsNull
    c213v0 = c213v0(c213v1)
    if c213v0 then
      do return end
    end
    c213v1 = _T.ModsSkipListSelected
    c213v0 = IsNull
    c213v0 = c213v0(c213v1)
    if not c213v0 then
      c213v1 = v45
      c213v0 = IsNull
      c213v0 = c213v0(c213v1)
      if not c213v0 then
        c213v1 = v45
        c213v1 = c213v1.mElements
        c213v0 = IsNull
        c213v0 = c213v0(c213v1)
        if not c213v0 then
          c213v0 = _T.ModsSkipListSelected
          c213v1 = v45
          c213v1 = c213v1.mElements
          c213v0(c213v1)
        end
      end
    end
    c213v0 = v133
    c213v0()
    do return end
  end
  ModsSkipListSelected = v183
  v120 = function(c214v0, c214v1, c214v2)
    local c214v3, c214v4
    c214v4 = _T.SetSquadOverlayTitle
    c214v3 = IsNull
    c214v3 = c214v3(c214v4)
    if not c214v3 then
      c214v3 = _T.SetSquadOverlayTitle
      c214v3(c214v0, c214v1, c214v2)
    end
    do return end
  end
  v183 = function(c215v0)
    local c215v1, c215v2, c215v3
    c215v1 = v120
    c215v2 = nil
    c215v3 = true
    c215v1(c215v0, c215v2, c215v3)
    do return end
  end
  SetTitle = v183
  v183 = function(c216v0)
    local c216v1, c216v2
    if c216v0 == "true" then
      c216v1 = false
      v81 = c216v1
      do return end
    end
    c216v1 = true
    v81 = c216v1
    c216v1 = v153
    c216v2 = true
    c216v1(c216v2)
    do return end
  end
  HideScreenForPlatPurchase = v183
  v183 = function(c217v0)
    v49 = c217v0
    do return end
  end
  SetCallback = v183
  v183 = function(c218v0)
    v50 = c218v0
    do return end
  end
  SetExtraInfoCallback = v183
  v183 = function()
    local c222v0, c222v1, c222v2, c222v3, c222v4, c222v5, c222v6, c222v7, c222v8, c222v9, c222v10, c222v11, c222v12, c222v13, c222v14, c222v15, c222v16, c222v17, c222v18
    c222v0 = v36
    c222v0 = c222v0.clips
    c222v0 = c222v0.Categories
    c222v1 = v36
    c222v1 = c222v1.clips
    c222v1 = c222v1.SearchAndSort
    c222v2 = v36
    c222v2 = c222v2.clips
    c222v2 = c222v2.InventoryGrid
    c222v3 = c222v1.components
    c222v3 = c222v3.SortMenu
    c222v6 = false
    c222v0:Show(c222v6)
    c222v6 = 120
    c222v1:SetScale(c222v6)
    c222v4 = c222v1:GetAnchorPosition()
    c222v8 = c222v4.x
    c222v7 = c222v8 - 122
    c222v9 = c222v4.y
    c222v8 = c222v9 - 20
    c222v1:SetAnchorPosition(c222v7, c222v8)
    c222v7 = v35
    c222v9 = { clipName = "Buttons" }
    c222v3:AddComponent(c222v7:New(c222v9))
    c222v7 = v35
    c222v9 = { clipName = "Backer" }
    c222v3:AddComponent(c222v7:New(c222v9))
    c222v7 = "CategoriesDropdown"
    c222v8 = 6000
    c222v5 = c222v3:Duplicate(c222v7, c222v8)
    c222v8 = v35
    c222v10 = { clipName = "Buttons" }
    c222v5:AddComponent(c222v8:New(c222v10))
    c222v8 = v35
    c222v10 = { clipName = "Backer" }
    c222v5:AddComponent(c222v8:New(c222v10))
    c222v6 = v95
    c222v7 = v94
    c222v7 = c222v7.INVENTORY
    if c222v6 == c222v7 then
      c222v6 = v35
      c222v8 = { clipName = "SellList", movie = nil }
      c222v9 = v36
      c222v8.movie = c222v9
      c222v6 = c222v6:New(c222v8)
      c222v7 = v35
      c222v9 = { clipName = "SellBtn" }
      c222v7 = c222v7:New(c222v9)
      c222v8 = v35
      c222v10 = { clipName = "Amount" }
      c222v8 = c222v8:New(c222v10)
      c222v9 = v35
      c222v11 = { clipName = "Total" }
      c222v9 = c222v9:New(c222v11)
      c222v10 = v35
      c222v12 = { clipName = "BottomLine" }
      c222v10 = c222v10:New(c222v12)
      c222v6:AddComponent(c222v7)
      c222v6:AddComponent(c222v8)
      c222v6:AddComponent(c222v9)
      c222v6:AddComponent(c222v10)
      c222v14 = c222v7:GetHeight()
      c222v13 = c222v14 * 2
      c222v7:SetHeight(c222v13)
      c222v14 = c222v8:GetHeight()
      c222v13 = c222v14 * 2
      c222v8:SetHeight(c222v13)
      c222v14 = c222v9:GetHeight()
      c222v13 = c222v14 * 2
      c222v9:SetHeight(c222v13)
      c222v14 = c222v7:GetPosition()
      c222v15 = Vector
      c222v16 = 0
      c222v17 = -50
      c222v18 = 0
      c222v15 = c222v15(c222v16, c222v17, c222v18)
      c222v13 = c222v14 + c222v15
      c222v7:SetPosition(c222v13)
      c222v14 = c222v8:GetPosition()
      c222v15 = Vector
      c222v16 = 0
      c222v17 = -50
      c222v18 = 0
      c222v15 = c222v15(c222v16, c222v17, c222v18)
      c222v13 = c222v14 + c222v15
      c222v8:SetPosition(c222v13)
      c222v14 = c222v9:GetPosition()
      c222v15 = Vector
      c222v16 = 0
      c222v17 = -50
      c222v18 = 0
      c222v15 = c222v15(c222v16, c222v17, c222v18)
      c222v13 = c222v14 + c222v15
      c222v9:SetPosition(c222v13)
      c222v14 = c222v10:GetPosition()
      c222v15 = Vector
      c222v16 = 0
      c222v17 = -50
      c222v18 = 0
      c222v15 = c222v15(c222v16, c222v17, c222v18)
      c222v13 = c222v14 + c222v15
      c222v10:SetPosition(c222v13)
    end
    c222v6 = require
    c222v7 = "Lotus.Interface.Components.DropDownMenu"
    c222v6 = c222v6(c222v7)
    c222v7 = c222v6.Create
    c222v8 = v36
    c222v8 = c222v8.instance
    c222v9 = c222v5.clipName
    c222v7 = c222v7(c222v8, c222v9)
    c222v5.dropdownInstance = c222v7
    c222v7 = c222v5.dropdownInstance
    c222v8 = true
    c222v7.mNewStyle = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v8 = 1
    c222v7.mDepthDirection = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v8 = tonumber
    c222v8 = c222v8(c222v3:GetDepth())
    c222v7.mStartingDepth = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v8 = 30
    c222v7.mForcedVerticalSeparation = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v9 = 100
    c222v7:SetMaxVisibleElements(c222v9)
    c222v7 = c222v5.dropdownInstance
    c222v9 = "SearchAndSort.CategoriesDropdown.Scrollbar"
    c222v10 = 0
    c222v7:AttachScrollBar(c222v9, c222v10)
    c222v7 = c222v5.dropdownInstance
    c222v8 = nil
    c222v7.mScrollBarHorizontalOffset = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v7:EnableSmoothScroll()
    c222v7 = c222v5.dropdownInstance
    c222v7:EnableDragScrolling()
    c222v7 = c222v5.dropdownInstance
    c222v8 = false
    c222v7.mStopDragScrollingOnSelection = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v8 = function(c219v0, c219v1)
      local c219v2
      c219v2 = c222v5
      c219v2 = c219v2.dropdownInstance
      c219v2 = c219v2.mScrollBar
      c219v0:UpdateScrollDrag(c219v2)
      do return end
    end
    c222v7.Update = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v8 = 1
    c222v7.mScroll = c222v8
    c222v7 = c222v5.dropdownInstance
    c222v7 = c222v7.ButtonOnSelected
    c222v8 = c222v5.dropdownInstance
    c222v9 = function(c220v0, c220v1)
      local c220v2, c220v3
      c220v2 = c222v7
      c220v2(c220v0, c220v1)
      c220v2 = CategoryPressed
      c220v3 = c220v1.Id
      c220v2(c220v3)
      do return end
    end
    c222v8.ButtonOnSelected = c222v9
    c222v8 = c222v5.dropdownInstance
    c222v8 = c222v8.mScrollBar
    c222v9 = function(c221v0, c221v1)
      local c221v2, c221v3
      c221v2 = 1
      if c221v0 < c221v1 then
        c221v2 = -1
      end
      c221v3 = c222v5
      c221v3 = c221v3.dropdownInstance
      c221v3 = c221v3.mScrollBar
      c221v3:ScrollBy(c221v2)
      do return end
    end
    c222v8.mScrollValueChangedCallback = c222v9
    c222v8 = c222v5.dropdownInstance
    c222v8 = c222v8.mScrollBar
    c222v8:Initialize()
    c222v8 = mMovie
    c222v10 = c222v5.dropdownInstance
    c222v10 = c222v10.mRootClipName
    c222v11 = "Buttons"
    c222v12 = 1
    c222v13 = c222v5.dropdownInstance
    c222v13 = c222v13.mForcedVerticalSeparation
    c222v8:Name__52c1b74e(c222v10, c222v11, c222v12, c222v13)
    c222v8 = mMovie
    c222v10 = c222v5.dropdownInstance
    c222v10 = c222v10.mRootClipName
    c222v11 = "Backer"
    c222v12 = 1
    c222v13 = c222v5.dropdownInstance
    c222v13 = c222v13.mForcedVerticalSeparation
    c222v8:Name__52c1b74e(c222v10, c222v11, c222v12, c222v13)
    c222v10 = true
    c222v5:Show(c222v10)
    c222v8 = c222v5:GetScreenPosition()
    c222v9 = mMovie
    c222v9 = c222v9:GetViewportWidth()
    c222v10 = mMovie
    c222v10 = c222v10:GetViewportHeight()
    c222v11 = c222v9 / c222v10
    c222v12 = 0.275
    c222v13 = 2.25
    if c222v13 < c222v11 then
      c222v14 = c222v11 - 1.78
      c222v13 = c222v14 * 0.23
      c222v12 = c222v12 + c222v13
    else
      c222v13 = 1.78
      if c222v13 < c222v11 then
        c222v14 = c222v11 - 1.78
        c222v13 = c222v14 * 0.26
        c222v12 = c222v12 + c222v13
      end
    end
    c222v16 = c222v8.x
    c222v17 = c222v9 * c222v12
    c222v15 = c222v16 - c222v17
    c222v16 = c222v8.y
    c222v5:SetScreenPosition(c222v15, c222v16)
    c222v13 = v36
    c222v13:UpdateAnchors()
    do return end
  end
  SetTouchLayout = v183
  v183 = function()
    local c223v0, c223v1, c223v2, c223v3, c223v4, c223v5, c223v6, c223v7, c223v8
    c223v0 = v36
    c223v0 = c223v0.clips
    c223v0 = c223v0.SearchAndSort
    c223v1 = c223v0.components
    c223v1 = c223v1.CategoriesDropdown
    c223v2 = v43
    c223v2 = c223v2.mUnfilteredCategories
    if c223v2 then
      c223v4 = 1
      c223v5 = v43
      c223v5 = c223v5.mUnfilteredCategories
      c223v2 = #c223v5
      c223v3 = 1
      for __renovice_for_0_0 = c223v4, c223v2, c223v3 do
        repeat
          c223v6 = v43
          c223v6 = c223v6.mUnfilteredCategories
          c223v5 = c223v6[__renovice_for_0_0]
          if __renovice_for_0_0 == 1 then
            c223v6 = v95
            c223v7 = v94
            c223v7 = c223v7.INVENTORY
            if c223v6 == c223v7 then
              c223v6 = c223v1.dropdownInstance
              c223v8 = table.clone
              c223v6:AddElement(c223v8(c223v5))
              break
            end
          end
          c223v6 = c223v1.dropdownInstance
          c223v6:AddElement(c223v5)
        until true
        if __renovice_for_0_0 ~= 1 then
          continue
        end
        c223v6 = c223v1.dropdownInstance
        c223v6 = c223v6.mMainButton
        c223v8 = c223v5.Name
        c223v6:SetText(c223v8)
      end
    end
    do return end
  end
  SetDropdownCategories = v183
  do return end
