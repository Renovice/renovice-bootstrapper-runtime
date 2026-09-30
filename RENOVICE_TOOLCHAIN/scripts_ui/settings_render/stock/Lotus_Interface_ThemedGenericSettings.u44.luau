-- RENOVICE_NAME_HASH_SEED: 768e5ed0
-- RENOVICE_HASH_FIELD: CloseIME
-- RENOVICE_HASH_FIELD: ConvertColorNumberToProceduralRGB
-- RENOVICE_HASH_FIELD: CopyTable
-- RENOVICE_HASH_FIELD: CreateGrid
-- RENOVICE_HASH_FIELD: CreateList
-- RENOVICE_HASH_FIELD: CreateParticles
-- RENOVICE_HASH_FIELD: CreateTimerMgr
-- RENOVICE_HASH_FIELD: Create__e256561c
-- RENOVICE_HASH_FIELD: DoOpenWebBrowser
-- RENOVICE_HASH_FIELD: FormatNumber
-- RENOVICE_HASH_FIELD: GetColor
-- RENOVICE_HASH_FIELD: IMEGetAndClearClicked
-- RENOVICE_HASH_FIELD: IMEGetFocusedIndex
-- RENOVICE_HASH_FIELD: IMEGetFocusedValue
-- RENOVICE_HASH_FIELD: IMESetFocusedOption
-- RENOVICE_HASH_FIELD: IMESetOptions
-- RENOVICE_HASH_FIELD: IMESetTip
-- RENOVICE_HASH_FIELD: IMESetTipCursor
-- RENOVICE_HASH_FIELD: IsVisible
-- RENOVICE_HASH_FIELD: OnHyperlinkPressed
-- RENOVICE_HASH_FIELD: OpenColorPicker
-- RENOVICE_HASH_FIELD: OpenIME
-- RENOVICE_HASH_FIELD: PlaySound
-- RENOVICE_HASH_FIELD: Round
-- RENOVICE_HASH_FIELD: ShowConfirmMessage
-- RENOVICE_HASH_FIELD: ShowErrorMessage
-- RENOVICE_HASH_FIELD: ShowMessage
-- RENOVICE_HASH_FIELD: Ternary
-- RENOVICE_HASH_FIELD: Update
  local v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, v60, v61, v62, v63, v64, v65, v66, v67, v68, v69, v70, v71
  v0 = require
  v1 = "Lotus.Interface.LotusUtilities"
  v0 = v0(v1)
  v1 = require
  v2 = "EE.Interface.Utilities"
  v1 = v1(v2)
  v2 = require
  v3 = "Lotus.Interface.UIUtilities"
  v2 = v2(v3)
  v3 = require
  v4 = "Lotus.Interface.UIStyleUtilities"
  v3 = v3(v4)
  v4 = require
  v5 = "Lotus.Interface.TextSuggest"
  v4 = v4(v5)
  v5 = require
  v6 = "Lotus.Interface.Components.ThemedCheckbox"
  v5 = v5(v6)
  v6 = require
  v7 = "Lotus.Interface.Components.ThemedToggle"
  v6 = v6(v7)
  v7 = require
  v8 = "Lotus.Interface.Components.ThemedInputField"
  v7 = v7(v8)
  v8 = require
  v9 = "Lotus.Interface.Components.ThemedButton"
  v8 = v8(v9)
  v9 = nil
  v10 = false
  v11 = true
  v12 = nil
  v13 = "/Lotus/Language/Menu/Global_Confirm"
  v14 = false
  v15 = nil
  v16 = nil
  v17 = nil
  v18 = nil
  v19 = false
  v20 = nil
  v21 = {}
  v22 = 0
  v23 = nil
  v24 = false
  v25 = ""
  v26 = { Real = nil, Tags = nil, Indexer = nil }
  v27 = {}
  v26.Real = v27
  v27 = {}
  v26.Tags = v27
  v27 = {}
  v26.Indexer = v27
  v27 = {}
  v28 = nil
  v29 = 0
  v30 = 0
  v31 = nil
  v32 = false
  v33 = false
  v34 = false
  v35 = nil
  v36 = "/Menu/Confirm_Item_Cancel"
  v37 = true
  v38 = false
  v39 = nil
  v40 = nil
  v41 = {}
  v42 = {}
  v43 = 0
  v44 = false
  v45 = true
  v46 = nil
  v48 = 44
  v49 = 44
  v50 = 44
  v51 = 44
  v52 = 24
  v53 = 108
  v54 = 8
  v55 = 44
  v56 = 87
  v57 = 84
  v58 = 44
  v47 = {v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58}
  v48 = nil
  v49 = nil
  v50 = { ConfirmY = 0, ConfirmX = 0, CheckboxY = 0, ContainerYPos = 0, ContainerXPos = 0, ExtraXOffset = 0 }
  v51 = false
  v52 = function()
    local c1v0, c1v1, c1v2, c1v3
    c1v0 = _T
    c1v1 = nil
    c1v0.gToolTip = c1v1
    c1v1 = v23
    c1v0 = IsNull
    c1v0 = c1v0(c1v1)
    if not c1v0 then
      c1v0 = v24
      if c1v0 then
        c1v0 = v23
        c1v0:Close()
      else
        c1v0 = v4
        c1v0 = c1v0.IsVisible
        c1v0 = c1v0()
        if c1v0 then
          c1v0 = v4
          c1v0 = c1v0.CloseIME
          c1v1 = v23
          c1v0(c1v1)
        end
      end
    end
    c1v0 = v19
    if not c1v0 then
      c1v1 = v18
      c1v0 = IsNull
      c1v0 = c1v0(c1v1)
      if not c1v0 then
        c1v2 = _T
        c1v3 = v18
        c1v1 = c1v2[c1v3]
        c1v0 = IsNull
        c1v0 = c1v0(c1v1)
        if not c1v0 then
          c1v0 = true
          v19 = c1v0
          c1v1 = _T
          c1v2 = v18
          c1v0 = c1v1[c1v2]
          c1v1 = v21
          c1v2 = true
          c1v0(c1v1, c1v2)
        end
      end
    end
    do return end
  end
  Shutdown = v52
  v52 = function(c2v0)
    local c2v1, c2v2
    c2v2 = tostring
    c2v2 = c2v2(c2v0)
    c2v1 = string.len
    c2v1 = c2v1(c2v2)
    do return c2v1 end
  end
  v53 = function(c5v0)
    local c5v1, c5v2, c5v3, c5v4, c5v5, c5v6, c5v7, c5v8, c5v9, c5v10
    c5v1 = v37
    if (not c5v1 and c5v0) then
      do return end
    end
    c5v1 = true
    v11 = c5v1
    c5v1 = ipairs
    c5v2 = v21
    c5v1, c5v2, c5v3 = c5v1(c5v2)
    for __renovice_for_0_0, __renovice_for_0_1 in c5v1, c5v2, c5v3 do
      c5v6 = __renovice_for_0_1.mChanged
      if not c5v6 then
        continue
      end
      c5v7 = __renovice_for_0_1.mOnValidateSetting
      c5v6 = IsNull
      c5v6 = c5v6(c5v7)
      if c5v6 then
        continue
      end
      c5v6 = IsNull
      c5v6 = c5v6(c5v0)
      if not c5v6 then
        continue
      end
      c5v6 = __renovice_for_0_1.mOnValidateSetting
      c5v6, c5v7 = c5v6()
      if c5v6 then
        continue
      end
      c5v8 = v1
      c5v8 = c5v8.ShowMessage
      c5v8(c5v7)
      c5v8 = false
      v11 = c5v8
      do return end
    end
    c5v1 = FlashInterpolate
    c5v2 = mMovie
    c5v3 = "_root"
    c5v4 = 0
    c5v6 = 12
    c5v5 = {c5v6}
    c5v7 = 0
    c5v6 = {c5v7}
    c5v7 = 0.2
    c5v1(c5v2, c5v3, c5v4, c5v5, c5v6, c5v7)
    c5v1 = function(c3v0)
      local c3v1, c3v2, c3v3
      c3v1 = mMovie
      c3v3 = 1 - c3v0
      c3v2 = c3v3 * 0.9
      c3v1:SetBackgroundAlpha(c3v2)
      do return end
    end
    c5v2 = FlashInterpolate
    c5v3 = mMovie
    c5v4 = "_level0"
    c5v5 = 0
    c5v6 = {c5v1}
    c5v8 = 1
    c5v7 = {c5v8}
    c5v8 = 0.3
    c5v9 = 0.1
    c5v10 = function()
      local c4v0, c4v1, c4v2, c4v3
      c4v0 = v19
      if not c4v0 then
        c4v1 = v18
        c4v0 = IsNull
        c4v0 = c4v0(c4v1)
        if not c4v0 then
          c4v2 = _T
          c4v3 = v18
          c4v1 = c4v2[c4v3]
          c4v0 = IsNull
          c4v0 = c4v0(c4v1)
          if not c4v0 then
            c4v0 = true
            v19 = c4v0
            c4v1 = _T
            c4v2 = v18
            c4v0 = c4v1[c4v2]
            c4v1 = v21
            c4v2 = c5v0
            c4v0(c4v1, c4v2)
          end
        end
      end
      c4v0 = mMovie
      c4v0:Close()
      do return end
    end
    c5v2(c5v3, c5v4, c5v5, c5v6, c5v7, c5v8, c5v9, c5v10)
    do return end
  end
  v54 = function()
    local c6v0
    c6v0 = v53
    c6v0()
    do return end
  end
  TransitionOut = v54
  v54 = function()
    local c8v0, c8v1
    c8v0 = {}
    v21 = c8v0
    c8v0 = v12
    c8v1 = function(c7v0)
      local c7v1, c7v2, c7v3, c7v4, c7v5, c7v6, c7v7, c7v8
      c7v1 = c7v0.mType
      c7v2 = v0
      c7v2 = c7v2.INPUTBOX
      if c7v1 == c7v2 then
        c7v1 = mMovie
        c7v3 = c7v0.InputField
        c7v3 = c7v3.mLabelClipName
        c7v4 = 36
        c7v1 = c7v1:GetStringVariable(c7v3, c7v4)
        c7v0.mContent = c7v1
        c7v1 = FindInvalidCharacter
        c7v2 = c7v0.mContent
        c7v3 = nil
        c7v1 = c7v1(c7v2, c7v3)
        c7v2 = 0
        if c7v2 < c7v1 then
          c7v2 = v1
          c7v2 = c7v2.ShowErrorMessage
          c7v6 = mMovie
          c7v7 = "/Lotus/Language/Menu/SocialOverlay_InvalidCharacter"
          c7v8 = false
          c7v4 = c7v6:GetLocalized(c7v7, c7v8)
          c7v5 = Name__837b59bc
          c7v6 = c7v0.mContent
          c7v5 = c7v5(c7v6, c7v1, c7v1)
          c7v3 = c7v4 .. c7v5
          c7v2(c7v3)
          c7v2 = c7v0.mOriginalValue
          c7v0.mContent = c7v2
          c7v2 = c7v0.mContent
          if c7v2 == nil then
            c7v2 = ""
            c7v0.mContent = c7v2
          end
          c7v2 = mMovie
          c7v4 = c7v0.InputField
          c7v4 = c7v4.mLabelClipName
          c7v5 = 36
          c7v6 = c7v0.mOriginalValue
          c7v2:SetStringVariable(c7v4, c7v5, c7v6)
        end
      end
      c7v2 = v21
      c7v1 = table.insert
      c7v1(c7v2, c7v0)
      do return end
    end
    c8v0:RunForAllElements(c8v1)
    do return end
  end
  v55 = function()
    local c9v0, c9v1, c9v2
    c9v0 = v37
    if not c9v0 then
      do return end
    end
    c9v0 = v54
    c9v0()
    c9v0 = false
    c9v1 = v1
    c9v1 = c9v1.PlaySound
    c9v2 = _G
    c9v2 = c9v2.UISound_WindowClose
    c9v1(c9v2)
    c9v1 = _T.BackgroundMovie
    if c9v1 ~= nil then
      c9v1 = _T.IsInScreenStack
      c9v2 = "ItemBrowsing"
      c9v0 = c9v1(c9v2)
    end
    if c9v0 then
      c9v1 = _T.GoToPreviousScreen
      c9v1()
      do return end
    end
    c9v1 = v53
    c9v2 = true
    c9v1(c9v2)
    do return end
  end
  v56 = function()
    local c10v0
    c10v0 = v54
    c10v0()
    c10v0 = v53
    c10v0()
    do return end
  end
  v57 = function()
    local c11v0, c11v1, c11v2, c11v3, c11v4, c11v5, c11v6, c11v7, c11v8, c11v9, c11v10, c11v11, c11v12
    c11v0 = v27
    c11v1 = v3
    c11v1 = c11v1.GetColor
    c11v2 = 9
    c11v3 = true
    c11v1 = c11v1(c11v2, c11v3)
    c11v0.FloatingContent = c11v1
    c11v0 = v27
    c11v1 = v3
    c11v1 = c11v1.GetColor
    c11v2 = 10
    c11v3 = true
    c11v1 = c11v1(c11v2, c11v3)
    c11v0.FloatingContentHighlight = c11v1
    c11v0 = v27
    c11v1 = v3
    c11v1 = c11v1.GetColor
    c11v2 = 2
    c11v3 = true
    c11v1 = c11v1(c11v2, c11v3)
    c11v0.Background = c11v1
    c11v0 = v27
    c11v1 = v3
    c11v1 = c11v1.GetColor
    c11v2 = 6
    c11v3 = true
    c11v1 = c11v1(c11v2, c11v3)
    c11v0.Content = c11v1
    c11v0 = v27
    c11v1 = v1
    c11v1 = c11v1.ConvertColorNumberToProceduralRGB
    c11v2 = v27
    c11v2 = c11v2.Background
    c11v1 = c11v1(c11v2)
    c11v0.BackgroundProcedural = c11v1
    c11v0 = v27
    c11v1 = v1
    c11v1 = c11v1.ConvertColorNumberToProceduralRGB
    c11v2 = v27
    c11v2 = c11v2.FloatingContent
    c11v1 = c11v1(c11v2)
    c11v0.FloatingContentProcedural = c11v1
    c11v0 = v27
    c11v1 = v1
    c11v1 = c11v1.ConvertColorNumberToProceduralRGB
    c11v2 = v27
    c11v2 = c11v2.FloatingContentHighlight
    c11v1 = c11v1(c11v2)
    c11v0.FloatingContentHighlightProcedural = c11v1
    c11v0 = v27
    c11v1 = v1
    c11v1 = c11v1.ConvertColorNumberToProceduralRGB
    c11v2 = v27
    c11v2 = c11v2.Content
    c11v1 = c11v1(c11v2)
    c11v0.ContentHighlightProcedural = c11v1
    c11v0 = mMovie
    c11v2 = "Container.Title"
    c11v3 = 44
    c11v4 = v27
    c11v4 = c11v4.FloatingContent
    c11v0:SetNumberVariable(c11v2, c11v3, c11v4)
    c11v0 = mMovie
    c11v2 = "Container.BgFill"
    c11v3 = _G
    c11v3 = c11v3.UIMaterial_RectangleNoDepth
    c11v0:OverrideMaterial(c11v2, c11v3)
    c11v0 = mMovie
    c11v2 = "Container.BgFill"
    c11v3 = "RectInnerColor"
    c11v4 = v27
    c11v4 = c11v4.BackgroundProcedural
    c11v4 = c11v4.r
    c11v5 = v27
    c11v5 = c11v5.BackgroundProcedural
    c11v5 = c11v5.g
    c11v6 = v27
    c11v6 = c11v6.BackgroundProcedural
    c11v6 = c11v6.b
    c11v7 = 0.8
    c11v0:Name__48ecbbab(c11v2, c11v3, c11v4, c11v5, c11v6, c11v7)
    c11v0 = mMovie
    c11v2 = "Container.BgFill"
    c11v3 = "RectEdgeColor"
    c11v4 = v27
    c11v4 = c11v4.FloatingContentProcedural
    c11v4 = c11v4.r
    c11v5 = v27
    c11v5 = c11v5.FloatingContentProcedural
    c11v5 = c11v5.g
    c11v6 = v27
    c11v6 = c11v6.FloatingContentProcedural
    c11v6 = c11v6.b
    c11v7 = 0.1
    c11v0:Name__48ecbbab(c11v2, c11v3, c11v4, c11v5, c11v6, c11v7)
    c11v0 = mMovie
    c11v2 = v27
    c11v2 = c11v2.Background
    c11v0:SetBackgroundColor(c11v2)
    c11v1 = "FancyBits.LeftLines"
    c11v2 = "FancyBits.RightLines"
    c11v3 = "FancyBits.LeftSideLine.FadeLineTop"
    c11v4 = "FancyBits.LeftSideLine.FadeLineMiddle"
    c11v5 = "FancyBits.LeftSideLine.FadeLineBottom"
    c11v6 = "FancyBits.RightSideLine.FadeLineTop"
    c11v7 = "FancyBits.RightSideLine.FadeLineMiddle"
    c11v8 = "FancyBits.RightSideLine.FadeLineBottom"
    c11v0 = {c11v1, c11v2, c11v3, c11v4, c11v5, c11v6, c11v7, c11v8}
    c11v3 = 1
    c11v1 = #c11v0
    c11v2 = 1
    for __renovice_for_0_0 = c11v3, c11v1, c11v2 do
      c11v4 = c11v0[__renovice_for_0_0]
      c11v5 = mMovie
      c11v8 = 11
      c11v9 = v27
      c11v9 = c11v9.FloatingContent
      c11v5:SetNumberVariable(c11v4, c11v8, c11v9)
      c11v5 = mMovie
      c11v8 = "RipplesColor"
      c11v9 = v27
      c11v9 = c11v9.ContentHighlightProcedural
      c11v9 = c11v9.r
      c11v10 = v27
      c11v10 = c11v10.ContentHighlightProcedural
      c11v10 = c11v10.g
      c11v11 = v27
      c11v11 = c11v11.ContentHighlightProcedural
      c11v11 = c11v11.b
      c11v12 = 0.9
      c11v5:Name__48ecbbab(c11v4, c11v8, c11v9, c11v10, c11v11, c11v12)
    end
    do return end
  end
  v58 = function()
    local c12v0, c12v1, c12v2, c12v3
    c12v1 = v42
    c12v1 = c12v1.CustomBtn
    c12v0 = IsNull
    c12v0 = c12v0(c12v1)
    if c12v0 then
      do return end
    end
    c12v0 = v42
    c12v0 = c12v0.CustomBtn
    c12v0 = c12v0.Confirm
    if c12v0 then
      c12v0 = mMovie
      c12v2 = "ShowCustomButtonConfirmation"
      c12v3 = ""
      c12v0:Execute(c12v2, c12v3)
      do return end
    end
    c12v0 = v42
    c12v0 = c12v0.CustomBtn
    c12v0 = c12v0.CallBack
    c12v0()
    do return end
  end
  OnCustomButtonPressed = v58
  v58 = function(c13v0, c13v1)
    local c13v2, c13v3, c13v4, c13v5, c13v6, c13v7, c13v8, c13v9
    local __renovice_local_0 = v43
    if __renovice_local_0 == 1 then
      c13v3 = c13v1 / 2
      c13v5 = c13v0.mMaxSize
      c13v4 = c13v5 / 2
      c13v2 = c13v3 - c13v4
      c13v0:SetPosition(c13v2)
      do return end
    end
    __renovice_local_0 = v43
    if __renovice_local_0 == 2 then
      __renovice_local_0 = Engine.IsMobile
      __renovice_local_0 = __renovice_local_0()
      if not __renovice_local_0 then
        c13v3 = c13v1 / 2
        c13v4 = v1
        c13v4 = c13v4.Ternary
        c13v6 = c13v0.PositionIdx
        if c13v6 ~= 1 then
          c13v5 = false
        else
          c13v5 = true
        end
        c13v8 = c13v0.mMaxSize
        c13v7 = -c13v8
        c13v6 = c13v7 - 5
        c13v7 = 5
        c13v4 = c13v4(c13v5, c13v6, c13v7)
        c13v2 = c13v3 + c13v4
        c13v0:SetPosition(c13v2)
        do return end
      end
      __renovice_local_0 = v51
      if __renovice_local_0 then
        c13v3 = c13v1 / 2
        c13v4 = v1
        c13v4 = c13v4.Ternary
        c13v6 = c13v0.PositionIdx
        if c13v6 ~= 1 then
          c13v5 = false
        else
          c13v5 = true
        end
        c13v6 = 60
        c13v9 = c13v0.mMaxSize
        c13v8 = -c13v9
        c13v7 = c13v8 - 10
        c13v4 = c13v4(c13v5, c13v6, c13v7)
        c13v2 = c13v3 + c13v4
        c13v0:SetPosition(c13v2)
        do return end
      end
      c13v3 = c13v1 / 2
      c13v4 = v1
      c13v4 = c13v4.Ternary
      c13v6 = c13v0.PositionIdx
      if c13v6 ~= 1 then
        c13v5 = false
      else
        c13v5 = true
      end
      c13v8 = c13v0.mMaxSize
      c13v7 = -c13v8
      c13v6 = c13v7 - 10
      c13v7 = 60
      c13v4 = c13v4(c13v5, c13v6, c13v7)
      c13v2 = c13v3 + c13v4
      c13v0:SetPosition(c13v2)
      do return end
    end
    __renovice_local_0 = v43
    if __renovice_local_0 == 3 then
      __renovice_local_0 = c13v0.PositionIdx
      if __renovice_local_0 == 2 then
        c13v3 = c13v1 / 2
        c13v5 = c13v0.mMaxSize
        c13v4 = c13v5 / 2
        c13v2 = c13v3 - c13v4
        c13v0:SetPosition(c13v2)
        do return end
      end
      c13v3 = c13v1 / 2
      c13v4 = v1
      c13v4 = c13v4.Ternary
      c13v6 = c13v0.PositionIdx
      if c13v6 ~= 1 then
        c13v5 = false
      else
        c13v5 = true
      end
      c13v9 = c13v0.mMaxSize
      c13v8 = -c13v9
      c13v7 = c13v8 * 1.5
      c13v6 = c13v7 - 10
      c13v9 = c13v0.mMaxSize
      c13v8 = c13v9 / 2
      c13v7 = c13v8 + 10
      c13v4 = c13v4(c13v5, c13v6, c13v7)
      c13v2 = c13v3 + c13v4
      c13v0:SetPosition(c13v2)
    end
    do return end
  end
  v59 = function()
    local c14v0, c14v1, c14v2, c14v3, c14v4, c14v5, c14v6, c14v7, c14v8, c14v9, c14v10
    c14v0 = 0
    v43 = c14v0
    c14v0 = false
    local __renovice_local_0 = Engine.IsMobile
    __renovice_local_0 = __renovice_local_0()
    if __renovice_local_0 then
      __renovice_local_0 = _T.UseSpecialButtons
      if __renovice_local_0 then
        c14v0 = true
      end
    end
    repeat
      __renovice_local_0 = v33
      if not __renovice_local_0 then
        __renovice_local_0 = v32
        if not __renovice_local_0 then
          __renovice_local_0 = v42
          c14v1 = nil
          __renovice_local_0.ConfirmBtn = c14v1
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.ConfirmButton"
          c14v3 = 13
          c14v4 = false
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.SpecialConfirmButton"
          c14v3 = 13
          c14v4 = false
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          break
        end
      end
      __renovice_local_0 = v42
      __renovice_local_0 = __renovice_local_0.ConfirmBtn
      if __renovice_local_0 == nil then
        if c14v0 then
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.ConfirmButton"
          c14v3 = 13
          c14v4 = false
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.SpecialConfirmButton"
          c14v3 = 13
          c14v5 = v34
          c14v4 = not c14v5
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = v42
          c14v1 = v8
          c14v1 = c14v1.Create__e256561c
          c14v2 = mMovie
          c14v3 = "Container.ButtonContainer.SpecialConfirmButton"
          c14v4 = v13
          c14v5 = "FinishSelection"
          c14v6 = "<MENU_GENERIC1>"
          c14v1 = c14v1(c14v2, c14v3, c14v4, c14v5, c14v6)
          __renovice_local_0.ConfirmBtn = c14v1
          __renovice_local_0 = v42
          __renovice_local_0 = __renovice_local_0.ConfirmBtn
          __renovice_local_0:SetSpecialMode()
          __renovice_local_0 = v42
          __renovice_local_0 = __renovice_local_0.ConfirmBtn
          __renovice_local_0:Redraw()
        else
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.ConfirmButton"
          c14v3 = 13
          c14v5 = v34
          c14v4 = not c14v5
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.SpecialConfirmButton"
          c14v3 = 13
          c14v4 = false
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = v42
          c14v1 = v8
          c14v1 = c14v1.Create__e256561c
          c14v2 = mMovie
          c14v3 = "Container.ButtonContainer.ConfirmButton"
          c14v4 = v13
          c14v5 = "FinishSelection"
          c14v6 = "<MENU_GENERIC1>"
          c14v1 = c14v1(c14v2, c14v3, c14v4, c14v5, c14v6)
          __renovice_local_0.ConfirmBtn = c14v1
        end
      end
      __renovice_local_0 = v42
      __renovice_local_0 = __renovice_local_0.ConfirmBtn
      c14v2 = v13
      __renovice_local_0:SetText(c14v2)
      __renovice_local_0 = v42
      __renovice_local_0 = __renovice_local_0.ConfirmBtn
      c14v2 = v33
      __renovice_local_0:SetActive(c14v2)
      __renovice_local_0 = v34
      if not __renovice_local_0 then
        c14v1 = v43
        __renovice_local_0 = c14v1 + 1
        v43 = __renovice_local_0
        __renovice_local_0 = v42
        __renovice_local_0 = __renovice_local_0.ConfirmBtn
        c14v1 = v43
        __renovice_local_0.PositionIdx = c14v1
      end
    until true
    local __renovice_state_0 = -1
    c14v1 = v39
    __renovice_local_0 = IsNull
    __renovice_local_0 = __renovice_local_0(c14v1)
    if __renovice_local_0 then
      __renovice_state_0 = -1
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c14v2 = _T
      c14v3 = v39
      c14v1 = c14v2[c14v3]
      __renovice_local_0 = IsNull
      __renovice_local_0 = __renovice_local_0(c14v1)
      if __renovice_local_0 then
        __renovice_state_0 = -1
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c14v1 = _T
      c14v2 = v39
      __renovice_local_0 = c14v1[c14v2]
      __renovice_local_0 = __renovice_local_0()
      c14v1 = v42
      c14v1 = c14v1.CustomBtn
      if c14v1 ~= nil then
        __renovice_state_0 = 6
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      if not c14v0 then
        __renovice_state_0 = 5
      else
        __renovice_state_0 = 4
      end
    end
    if __renovice_state_0 == 4 then
      c14v1 = v42
      c14v2 = v8
      c14v2 = c14v2.Create__e256561c
      c14v3 = mMovie
      c14v4 = "Container.ButtonContainer.SpecialCustomButton"
      c14v5 = __renovice_local_0.Label
      c14v6 = "OnCustomButtonPressed"
      c14v8 = "<"
      c14v9 = __renovice_local_0.CallOut
      c14v10 = ">"
      c14v7 = c14v8 .. c14v9 .. c14v10
      c14v2 = c14v2(c14v3, c14v4, c14v5, c14v6, c14v7)
      c14v1.CustomBtn = c14v2
      c14v1 = v42
      c14v1 = c14v1.CustomBtn
      c14v1:SetSpecialMode()
      c14v1 = v42
      c14v1 = c14v1.CustomBtn
      c14v1:Redraw()
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 5 then
      c14v1 = v42
      c14v2 = v8
      c14v2 = c14v2.Create__e256561c
      c14v3 = mMovie
      c14v4 = "Container.ButtonContainer.CustomButton"
      c14v5 = __renovice_local_0.Label
      c14v6 = "OnCustomButtonPressed"
      c14v8 = "<"
      c14v9 = __renovice_local_0.CallOut
      c14v10 = ">"
      c14v7 = c14v8 .. c14v9 .. c14v10
      c14v2 = c14v2(c14v3, c14v4, c14v5, c14v6, c14v7)
      c14v1.CustomBtn = c14v2
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 6 then
      c14v2 = __renovice_local_0.ConfirmCallback
      c14v1 = IsNull
      c14v1 = c14v1(c14v2)
      if c14v1 then
        __renovice_state_0 = 8
      else
        __renovice_state_0 = 7
      end
    end
    if __renovice_state_0 == 7 then
      c14v1 = v41
      c14v2 = __renovice_local_0.ConfirmLabel
      c14v1.ConfirmLabel = c14v2
      c14v1 = __renovice_local_0.ConfirmCallback
      v40 = c14v1
      c14v1 = v42
      c14v1 = c14v1.CustomBtn
      c14v2 = true
      c14v1.Confirm = c14v2
      __renovice_state_0 = 9
    end
    if __renovice_state_0 == 8 then
      c14v1 = v42
      c14v1 = c14v1.CustomBtn
      c14v2 = nil
      c14v1.Confirm = c14v2
      c14v1 = v42
      c14v1 = c14v1.CustomBtn
      c14v2 = __renovice_local_0.CallBack
      c14v1.CallBack = c14v2
      __renovice_state_0 = 9
    end
    if __renovice_state_0 == 9 then
      c14v1 = v41
      c14v2 = __renovice_local_0.Label
      c14v1.Label = c14v2
      c14v2 = v43
      c14v1 = c14v2 + 1
      v43 = c14v1
      c14v1 = v42
      c14v1 = c14v1.CustomBtn
      c14v2 = v43
      c14v1.PositionIdx = c14v2
      if not c14v0 then
        __renovice_state_0 = 11
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      c14v1 = mMovie
      c14v3 = "Container.ButtonContainer.CustomButton"
      c14v4 = 13
      c14v5 = false
      c14v1:Name__863e56e7(c14v3, c14v4, c14v5)
      c14v1 = mMovie
      c14v3 = "Container.ButtonContainer.SpecialCustomButton"
      c14v4 = 13
      c14v5 = true
      c14v1:Name__863e56e7(c14v3, c14v4, c14v5)
      __renovice_state_0 = 12
    end
    if __renovice_state_0 == 11 then
      c14v1 = mMovie
      c14v3 = "Container.ButtonContainer.CustomButton"
      c14v4 = 13
      c14v5 = true
      c14v1:Name__863e56e7(c14v3, c14v4, c14v5)
      c14v1 = mMovie
      c14v3 = "Container.ButtonContainer.SpecialCustomButton"
      c14v4 = 13
      c14v5 = false
      c14v1:Name__863e56e7(c14v3, c14v4, c14v5)
      __renovice_state_0 = 12
    end
    if __renovice_state_0 ~= 12 then
      __renovice_local_0 = v42
      c14v1 = nil
      __renovice_local_0.CustomBtn = c14v1
      __renovice_local_0 = mMovie
      c14v2 = "Container.ButtonContainer.CustomButton"
      c14v3 = 13
      c14v4 = false
      __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
      __renovice_local_0 = mMovie
      c14v2 = "Container.ButtonContainer.SpecialCustomButton"
      c14v3 = 13
      c14v4 = false
      __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
    end
    __renovice_local_0 = v37
    if __renovice_local_0 then
      __renovice_local_0 = v42
      __renovice_local_0 = __renovice_local_0.CancelBtn
      if __renovice_local_0 == nil then
        if c14v0 then
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.CancelButton"
          c14v3 = 13
          c14v4 = false
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.SpecialCancelButton"
          c14v3 = 13
          c14v5 = v38
          c14v4 = not c14v5
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = v42
          c14v1 = v8
          c14v1 = c14v1.Create__e256561c
          c14v2 = mMovie
          c14v3 = "Container.ButtonContainer.SpecialCancelButton"
          c14v4 = "/Menu/Confirm_Item_Cancel"
          c14v5 = "ExitScreen"
          c14v6 = "<MENU_CANCEL>"
          c14v1 = c14v1(c14v2, c14v3, c14v4, c14v5, c14v6)
          __renovice_local_0.CancelBtn = c14v1
          __renovice_local_0 = v42
          __renovice_local_0 = __renovice_local_0.CancelBtn
          __renovice_local_0:SetSpecialMode()
          __renovice_local_0 = v42
          __renovice_local_0 = __renovice_local_0.CancelBtn
          __renovice_local_0:Redraw()
        else
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.CancelButton"
          c14v3 = 13
          c14v5 = v38
          c14v4 = not c14v5
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = mMovie
          c14v2 = "Container.ButtonContainer.SpecialCancelButton"
          c14v3 = 13
          c14v4 = false
          __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
          __renovice_local_0 = v42
          c14v1 = v8
          c14v1 = c14v1.Create__e256561c
          c14v2 = mMovie
          c14v3 = "Container.ButtonContainer.CancelButton"
          c14v4 = "/Menu/Confirm_Item_Cancel"
          c14v5 = "ExitScreen"
          c14v6 = "<MENU_CANCEL>"
          c14v1 = c14v1(c14v2, c14v3, c14v4, c14v5, c14v6)
          __renovice_local_0.CancelBtn = c14v1
        end
      end
      __renovice_local_0 = v42
      __renovice_local_0 = __renovice_local_0.CancelBtn
      c14v2 = v36
      __renovice_local_0:SetText(c14v2)
      __renovice_local_0 = v38
      if not __renovice_local_0 then
        c14v1 = v43
        __renovice_local_0 = c14v1 + 1
        v43 = __renovice_local_0
        __renovice_local_0 = v42
        __renovice_local_0 = __renovice_local_0.CancelBtn
        c14v1 = v43
        __renovice_local_0.PositionIdx = c14v1
      end
    else
      __renovice_local_0 = v42
      c14v1 = nil
      __renovice_local_0.CancelBtn = c14v1
      __renovice_local_0 = mMovie
      c14v2 = "Container.ButtonContainer.CancelButton"
      c14v3 = 13
      c14v4 = false
      __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
      __renovice_local_0 = mMovie
      c14v2 = "Container.ButtonContainer.SpecialCancelButton"
      c14v3 = 13
      c14v4 = false
      __renovice_local_0:Name__863e56e7(c14v2, c14v3, c14v4)
    end
    __renovice_local_0 = v49
    __renovice_local_0()
    __renovice_local_0 = v43
    c14v1 = 0
    if c14v1 < __renovice_local_0 then
      __renovice_local_0 = mMovie
      c14v2 = "Container.BgFill"
      c14v3 = 14
      __renovice_local_0 = __renovice_local_0:GetNumberVariable(c14v2, c14v3)
      c14v3 = v43
      c14v2 = c14v3 + 1
      c14v1 = __renovice_local_0 / c14v2
      c14v2 = pairs
      c14v3 = v42
      c14v2, c14v3, c14v4 = c14v2(c14v3)
      for __renovice_for_0_0, __renovice_for_0_1 in c14v2, c14v3, c14v4 do
        c14v7 = Engine.IsMobile
        c14v7 = c14v7()
        if c14v7 then
          c14v9 = c14v1 * 0.9
          __renovice_for_0_1:SetWidth(c14v9)
        else
          __renovice_for_0_1:SetWidth(c14v1)
        end
        c14v7 = v58
        c14v7(__renovice_for_0_1, __renovice_local_0)
      end
    end
    __renovice_local_0 = _T.SetButtons
    c14v1 = mMovie
    c14v2 = nil
    __renovice_local_0(c14v1, c14v2)
    do return end
  end
  v60 = function(c15v0)
    local c15v1, c15v2, c15v3, c15v4
    c15v1 = v1
    c15v1 = c15v1.Ternary
    c15v2 = IsNull
    c15v2 = c15v2(c15v0)
    c15v3 = v15
    c15v0 = c15v1(c15v2, c15v3, c15v0)
    if c15v0 == nil then
      do return end
    end
    c15v1 = true
    c15v0.mChanged = c15v1
    c15v1 = v16
    if c15v1 ~= nil then
      c15v1 = v16
      c15v2 = true
      c15v1.mChanged = c15v2
    end
    c15v1 = true
    v33 = c15v1
    c15v2 = v20
    c15v1 = IsNull
    c15v1 = c15v1(c15v2)
    if not c15v1 then
      c15v3 = _T
      c15v4 = v20
      c15v2 = c15v3[c15v4]
      c15v1 = IsNull
      c15v1 = c15v1(c15v2)
      if not c15v1 then
        c15v1 = c15v0.mType
        c15v2 = v0
        c15v2 = c15v2.INPUTCOUNT
        if c15v1 == c15v2 then
          c15v2 = _T
          c15v3 = v20
          c15v1 = c15v2[c15v3]
          c15v2 = c15v0.mCount
          c15v3 = c15v0.mSetting
          c15v1(c15v2, c15v3)
        else
          c15v2 = _T
          c15v3 = v20
          c15v1 = c15v2[c15v3]
          c15v2 = c15v0.mValue
          c15v3 = c15v0.mSetting
          c15v1(c15v2, c15v3)
        end
      end
    end
    c15v1 = v59
    c15v1()
    do return end
  end
  v61 = function(c16v0)
    local c16v1, c16v2
    c16v1 = v60
    c16v1()
    v15.mValue = c16v0
    c16v1 = v15
    c16v1 = c16v1.mCallback
    if c16v1 then
      c16v1 = v15
      c16v1 = c16v1.mCallback
      c16v1(c16v0)
    end
    c16v1 = v12
    c16v1 = c16v1.mElementDrawCallback
    c16v2 = v15
    c16v1(c16v2)
    do return end
  end
  v49 = function()
    local c19v0, c19v1, c19v2, c19v3, c19v4, c19v5, c19v6, c19v7, c19v8, c19v9, c19v10, c19v11, c19v12, c19v13, c19v14, c19v15, c19v16, c19v17, c19v18, c19v19, c19v20
    c19v0 = v1
    c19v0 = c19v0.Ternary
    c19v1 = v45
    c19v2 = mMovie
    c19v4 = "Container.Title"
    c19v5 = 41
    c19v2 = c19v2:GetNumberVariable(c19v4, c19v5)
    c19v3 = 0
    c19v0 = c19v0(c19v1, c19v2, c19v3)
    c19v1 = 0
    c19v2 = 0
    c19v3 = 0
    c19v4 = {}
    c19v5 = v12
    c19v5 = c19v5.UniformElementHeights
    if c19v5 then
      c19v5 = v12
      c19v5 = c19v5:GetHowManyVisibleElements()
      c19v6 = v12
      c19v6 = c19v6.mForcedVerticalSeparation
      c19v1 = c19v5 * c19v6
    end
    c19v5 = v12
    c19v7 = function(c17v0)
      local c17v1, c17v2, c17v3, c17v4, c17v5, c17v6
      c17v1 = v12
      c17v1 = c17v1.UniformElementHeights
      if not c17v1 then
        c17v1 = c19v1
        c17v2 = v12
        c17v2 = c17v2:CalculateHeight(c17v0)
        c17v1 = c17v1 + c17v2
        c19v1 = c17v1
      end
      c17v1 = v12
      c17v1 = c17v1:CalculateWidth(c17v0)
      c17v2 = c19v2
      if c17v2 < c17v1 then
        c19v2 = c17v1
      end
      c17v2 = c17v0.mTextWidth
      if c17v2 ~= nil then
        c17v2 = c17v0.mTextWidth
        c17v3 = c19v3
        if c17v3 < c17v2 then
          c17v2 = c17v0.mTextWidth
          c19v3 = c17v2
        end
      end
      c17v2 = c17v0.mType
      c17v3 = v0
      c17v3 = c17v3.IMAGE
      if c17v2 == c17v3 then
        c17v2 = mMovie
        c17v4 = c17v0.mClipName
        c17v5 = "Image"
        c17v6 = 14
        c17v2 = c17v2:Name__fd1f2935(c17v4, c17v5, c17v6)
        c17v3 = 0
        if c17v3 < c17v2 then
          c17v4 = c19v4
          c17v3 = table.insert
          c17v3(c17v4, c17v0)
        end
      end
      c17v2 = c17v0.mType
      c17v3 = v0
      c17v3 = c17v3.TITLE
      if c17v2 == c17v3 then
        c17v3 = c17v0.mClipName
        c17v2 = #c17v3
        c17v3 = 0
        if c17v3 < c17v2 then
          c17v3 = c17v0.mAlignment
          c17v2 = #c17v3
          c17v3 = 0
          if c17v3 < c17v2 then
            c17v2 = mMovie
            c17v5 = c17v0.mClipName
            c17v6 = ".Label"
            c17v4 = c17v5 .. c17v6
            c17v5 = 45
            c17v6 = c17v0.mAlignment
            c17v2:SetStringVariable(c17v4, c17v5, c17v6)
          end
        end
      end
      do return end
    end
    c19v5:RunForAllElements(c19v7)
    c19v5 = v1
    c19v5 = c19v5.Ternary
    if c19v0 ~= 0 then
      c19v6 = false
    else
      c19v6 = true
    end
    c19v7 = -10
    c19v8 = 33
    c19v5 = c19v5(c19v6, c19v7, c19v8)
    c19v9 = 100
    c19v8 = math.max
    c19v8 = c19v8(c19v9, c19v1)
    c19v7 = c19v8 + c19v0
    c19v6 = c19v7 + c19v5
    c19v8 = c19v2 + 40
    c19v9 = 100
    c19v7 = math.max
    c19v7 = c19v7(c19v8, c19v9)
    c19v8 = v44
    if (c19v8 and c19v3 ~= 0) then
      c19v9 = c19v7 - c19v3
      c19v8 = c19v9 / 2
      c19v9 = v12
      local __renovice_capture_18_7 = c19v8
      c19v11 = function(c18v0)
        local c18v1, c18v2, c18v3, c18v4, c18v5, c18v6
        local __renovice_state_0 = 0
        c18v1 = c18v0.mType
        c18v2 = v0
        c18v2 = c18v2.TITLE
        if c18v1 == c18v2 then
          __renovice_state_0 = 2
        else
          __renovice_state_0 = 1
        end
        if __renovice_state_0 == 1 then
          c18v1 = c18v0.mType
          c18v2 = v0
          c18v2 = c18v2.CHECKBOX
          if c18v1 ~= c18v2 then
            __renovice_state_0 = 4
          else
            __renovice_state_0 = 2
          end
        end
        if __renovice_state_0 == 2 then
          c18v1 = mMovie
          c18v3 = c18v0.mClipName
          c18v4 = 0
          c18v5 = __renovice_capture_18_7
          c18v1:SetNumberVariable(c18v3, c18v4, c18v5)
          c18v1 = c18v0.mType
          c18v2 = v0
          c18v2 = c18v2.CHECKBOX
          if c18v1 ~= c18v2 then
            __renovice_state_0 = 4
          else
            __renovice_state_0 = 3
          end
        end
        if __renovice_state_0 == 3 then
          c18v1 = mMovie
          c18v3 = c18v0.mClipName
          c18v4 = "Btn"
          c18v5 = 14
          c18v6 = c19v3
          c18v1:Name__82f6549c(c18v3, c18v4, c18v5, c18v6)
          c18v1 = mMovie
          c18v3 = c18v0.mClipName
          c18v4 = "Bg"
          c18v5 = 14
          c18v6 = c19v3
          c18v1:Name__82f6549c(c18v3, c18v4, c18v5, c18v6)
          c18v1 = c18v0.Checkbox
          c18v4 = c19v3
          c18v3 = c18v4 - 70
          c18v1:SetPosition(c18v3)
          __renovice_state_0 = 4
        end
        if __renovice_state_0 == 4 then
          do return end
        end
        do return end
      end
      c19v9:RunForAllElements(c19v11)
    end
    c19v10 = 1
    c19v8 = #c19v4
    c19v9 = 1
    for __renovice_for_0_0 = c19v10, c19v8, c19v9 do
      c19v11 = c19v4[__renovice_for_0_0]
      c19v12 = c19v11.mXOffset
      if c19v12 == nil then
        c19v12 = 0
        c19v11.mXOffset = c19v12
      end
      c19v12 = c19v11.mHorizontalAlignment
      if c19v12 == "left" then
        c19v12 = mMovie
        c19v14 = c19v11.mClipName
        c19v15 = "Image"
        c19v16 = 0
        c19v17 = c19v11.mXOffset
        c19v12:Name__82f6549c(c19v14, c19v15, c19v16, c19v17)
        continue
      end
      c19v12 = c19v11.mHorizontalAlignment
      if c19v12 == "right" then
        c19v12 = mMovie
        c19v14 = c19v11.mClipName
        c19v15 = "Image"
        c19v16 = 14
        c19v12 = c19v12:Name__fd1f2935(c19v14, c19v15, c19v16)
        c19v13 = mMovie
        c19v15 = c19v11.mClipName
        c19v16 = "Image"
        c19v17 = 0
        c19v19 = c19v7 - c19v12
        c19v20 = c19v11.mXOffset
        c19v18 = c19v19 + c19v20
        c19v13:Name__82f6549c(c19v15, c19v16, c19v17, c19v18)
        continue
      end
      c19v12 = mMovie
      c19v14 = c19v11.mClipName
      c19v15 = "Image"
      c19v16 = 14
      c19v12 = c19v12:Name__fd1f2935(c19v14, c19v15, c19v16)
      c19v14 = c19v7 - c19v12
      c19v13 = c19v14 / 2
      c19v14 = mMovie
      c19v16 = c19v11.mClipName
      c19v17 = "Image"
      c19v18 = 0
      c19v20 = c19v11.mXOffset
      c19v19 = c19v13 + c19v20
      c19v14:Name__82f6549c(c19v16, c19v17, c19v18, c19v19)
    end
    c19v8 = v1
    c19v8 = c19v8.Ternary
    c19v9 = v45
    c19v12 = mMovie
    c19v14 = "Container.Title"
    c19v15 = 1
    c19v12 = c19v12:GetNumberVariable(c19v14, c19v15)
    c19v11 = c19v12 + c19v0
    c19v10 = c19v11 + 33
    c19v11 = 0
    c19v8 = c19v8(c19v9, c19v10, c19v11)
    c19v9 = mMovie
    c19v11 = "Container.OptionList"
    c19v12 = 1
    c19v9:SetNumberVariable(c19v11, c19v12, c19v8)
    c19v9 = mMovie
    c19v11 = "Container.OptionListMask"
    c19v12 = 1
    c19v13 = c19v8 - 20
    c19v9:SetNumberVariable(c19v11, c19v12, c19v13)
    c19v9 = mMovie
    c19v11 = "Container.ScrollBar"
    c19v12 = 1
    c19v13 = c19v8 - 13
    c19v9:SetNumberVariable(c19v11, c19v12, c19v13)
    c19v9 = v1
    c19v9 = c19v9.Ternary
    c19v11 = v43
    c19v12 = 0
    if not (c19v12 < c19v11) then
      c19v10 = false
    else
      c19v10 = true
    end
    c19v11 = 62
    c19v12 = 15
    c19v9 = c19v9(c19v10, c19v11, c19v12)
    c19v10 = Engine.IsMobile
    c19v10 = c19v10()
    if c19v10 then
      c19v10 = mMovie
      c19v12 = "Container.BgFill"
      c19v13 = 14
      c19v10 = c19v10:GetNumberVariable(c19v12, c19v13)
      c19v13 = mMovie
      c19v13 = c19v13:GetMovieHeight()
      c19v12 = c19v13 - c19v10
      c19v11 = c19v12 / 2
      c19v12 = mMovie
      c19v14 = "Container.ButtonContainer"
      c19v15 = 0
      c19v17 = v50
      c19v17 = c19v17.ConfirmX
      c19v16 = c19v11 + c19v17
      c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
      c19v12 = mMovie
      c19v14 = "Container.ButtonContainer"
      c19v15 = 1
      c19v17 = c19v6 + 15
      c19v18 = v50
      c19v18 = c19v18.ConfirmY
      c19v16 = c19v17 + c19v18
      c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
    else
      c19v10 = mMovie
      c19v12 = "Container.ButtonContainer"
      c19v13 = 1
      c19v14 = c19v6 + 15
      c19v10:SetNumberVariable(c19v12, c19v13, c19v14)
    end
    c19v6 = c19v6 + c19v9
    c19v10 = v1
    c19v10 = c19v10.Round
    c19v13 = mMovie
    c19v13 = c19v13:GetMovieWidth()
    c19v12 = c19v13 - c19v7
    c19v11 = c19v12 / 2
    c19v10 = c19v10(c19v11)
    c19v11 = mMovie
    c19v13 = "Container.BgFill"
    c19v14 = 15
    c19v11:SetNumberVariable(c19v13, c19v14, c19v6)
    c19v11 = mMovie
    c19v13 = "Container.BgFill"
    c19v14 = 14
    c19v11:SetNumberVariable(c19v13, c19v14, c19v7)
    c19v11 = mMovie
    c19v13 = "Container"
    c19v14 = 0
    c19v11:SetNumberVariable(c19v13, c19v14, c19v10)
    c19v11 = mMovie
    c19v13 = "Container"
    c19v14 = 1
    c19v17 = mMovie
    c19v17 = c19v17:GetMovieHeight()
    c19v16 = c19v17 / 2
    c19v17 = c19v6 / 2
    c19v15 = c19v16 - c19v17
    c19v11:SetNumberVariable(c19v13, c19v14, c19v15)
    c19v11 = Engine.IsMobile
    c19v11 = c19v11()
    if c19v11 then
      c19v11 = mMovie
      c19v13 = "Container"
      c19v14 = 0
      c19v16 = v50
      c19v16 = c19v16.ContainerXPos
      c19v15 = c19v10 + c19v16
      c19v11:SetNumberVariable(c19v13, c19v14, c19v15)
      c19v11 = mMovie
      c19v13 = "Container"
      c19v14 = 1
      c19v18 = mMovie
      c19v18 = c19v18:GetMovieHeight()
      c19v17 = c19v18 / 2
      c19v18 = c19v6 / 2
      c19v16 = c19v17 - c19v18
      c19v17 = v50
      c19v17 = c19v17.ContainerYPos
      c19v15 = c19v16 + c19v17
      c19v11:SetNumberVariable(c19v13, c19v14, c19v15)
    end
    c19v11 = mMovie
    c19v13 = "Container.SearchBox"
    c19v14 = 0
    c19v17 = v35
    c19v17 = c19v17.mMaxSize
    c19v16 = c19v17 + 2
    c19v15 = c19v7 - c19v16
    c19v11:SetNumberVariable(c19v13, c19v14, c19v15)
    c19v11 = mMovie
    c19v13 = "Container.ScrollBar"
    c19v14 = 0
    c19v15 = c19v7 - 15
    c19v11:SetNumberVariable(c19v13, c19v14, c19v15)
    c19v11 = v45
    if c19v11 then
      c19v11 = mMovie
      c19v13 = "Container.Title"
      c19v14 = 14
      c19v11:SetNumberVariable(c19v13, c19v14, c19v7)
    end
    c19v11 = c19v7 / 2
    c19v12 = mMovie
    c19v14 = "FancyBits.LeftLines"
    c19v15 = 0
    c19v17 = -c19v11
    c19v16 = c19v17 + 1
    c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
    c19v12 = mMovie
    c19v14 = "FancyBits.RightLines"
    c19v15 = 0
    c19v16 = c19v11 - 1
    c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
    c19v12 = mMovie
    c19v14 = "FancyBits.LeftSideLine"
    c19v15 = 0
    c19v17 = -c19v11
    c19v16 = c19v17 + 2
    c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
    c19v12 = mMovie
    c19v14 = "FancyBits.RightSideLine"
    c19v15 = 0
    c19v16 = c19v11 - 1
    c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
    c19v12 = Engine.IsMobile
    c19v12 = c19v12()
    if c19v12 then
      c19v12 = mMovie
      c19v14 = "FancyBits.LeftLines"
      c19v15 = 0
      c19v18 = -c19v11
      c19v17 = c19v18 + 1
      c19v18 = v50
      c19v18 = c19v18.ContainerXPos
      c19v16 = c19v17 + c19v18
      c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
      c19v12 = mMovie
      c19v14 = "FancyBits.RightLines"
      c19v15 = 0
      c19v18 = c19v11 - 1
      c19v19 = v50
      c19v19 = c19v19.ContainerXPos
      c19v17 = c19v18 - c19v19
      c19v18 = v50
      c19v18 = c19v18.ExtraXOffset
      c19v16 = c19v17 - c19v18
      c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
      c19v12 = mMovie
      c19v14 = "FancyBits.LeftSideLine"
      c19v15 = 0
      c19v18 = -c19v11
      c19v17 = c19v18 + 2
      c19v18 = v50
      c19v18 = c19v18.ContainerXPos
      c19v16 = c19v17 + c19v18
      c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
      c19v12 = mMovie
      c19v14 = "FancyBits.RightSideLine"
      c19v15 = 0
      c19v18 = c19v11 - 1
      c19v19 = v50
      c19v19 = c19v19.ContainerXPos
      c19v17 = c19v18 - c19v19
      c19v18 = v50
      c19v18 = c19v18.ExtraXOffset
      c19v16 = c19v17 - c19v18
      c19v12:SetNumberVariable(c19v14, c19v15, c19v16)
    end
    do return end
  end
  v62 = function(c20v0)
    local c20v1, c20v2, c20v3, c20v4, c20v5, c20v6, c20v7, c20v8, c20v9, c20v10, c20v11, c20v12
    c20v2 = v35
    c20v1 = IsNull
    c20v1 = c20v1(c20v2)
    if not c20v1 then
      c20v2 = v12
      c20v1 = IsNull
      c20v1 = c20v1(c20v2)
      if not c20v1 then
        c20v1 = v35
        c20v1 = c20v1.mLabel
        c20v2 = ToSearchable
        c20v2 = c20v2(c20v1)
        c20v4 = "[%(%)%.%%%+%-%*%?%[%]%^%$]"
        c20v5 = "%%%0"
        c20v2 = c20v2:gsub(c20v4, c20v5)
        c20v5 = c20v2
        c20v3 = c20v0:find(c20v5)
        if c20v3 then
          c20v3 = false
          if c20v0 ~= "" then
            if c20v2 == "" then
              c20v3 = false
            else
              c20v3 = true
            end
          end
        end
        if c20v3 then
          c20v4 = 1
          while true do
            c20v6 = v12
            c20v6 = c20v6.mElements
            c20v5 = #c20v6
            if not (c20v4 <= c20v5) then break end
            c20v6 = v12
            c20v6 = c20v6.mElements
            c20v5 = c20v6[c20v4]
            c20v6 = c20v5.mSearchTerm
            c20v6 = c20v6:find(c20v2)
            if not c20v6 then
              c20v6 = v12
              c20v8 = c20v5.mIndex
              c20v9 = true
              c20v10 = true
              c20v6:RemoveElement(c20v8, c20v9, c20v10)
              continue
            end
            c20v4 = c20v4 + 1
          end
        else
          c20v4 = v12
          c20v6 = true
          c20v7 = true
          c20v4:RemoveElements(c20v6, c20v7)
          c20v6 = 1
          c20v7 = v12
          c20v7 = c20v7.mUnfilteredElements
          c20v4 = #c20v7
          c20v5 = 1
          for __renovice_for_0_0 = c20v6, c20v4, c20v5 do
            c20v8 = v12
            c20v8 = c20v8.mUnfilteredElements
            c20v7 = c20v8[__renovice_for_0_0]
            if not c20v7 then
              continue
            end
            c20v8 = c20v7.mSearchTerm
            c20v8 = c20v8:find(c20v2)
            if not c20v8 then
              continue
            end
            c20v8 = v12
            c20v10 = v1
            c20v10 = c20v10.CopyTable
            c20v10 = c20v10(c20v7)
            c20v11 = true
            c20v12 = true
            c20v8:AddElement(c20v10, c20v11, c20v12)
          end
        end
        c20v4 = mMovie
        c20v6 = v12
        c20v6 = c20v6.mScrollBarClipName
        c20v7 = 13
        c20v4 = c20v4:Name__a0674cc3(c20v6, c20v7)
        c20v5 = v12
        c20v7 = nil
        c20v8 = true
        c20v9 = true
        c20v5:Redraw(c20v7, c20v8, c20v9)
        c20v5 = mMovie
        c20v7 = v12
        c20v7 = c20v7.mScrollBarClipName
        c20v8 = 13
        c20v5 = c20v5:Name__a0674cc3(c20v7, c20v8)
        if c20v4 ~= c20v5 then
          c20v6 = v49
          c20v6()
        end
        do return end
      end
    end
    do return end
  end
  v63 = function()
    local c55v0, c55v1, c55v2, c55v3, c55v4, c55v5, c55v6, c55v7, c55v8
    c55v0 = print
    c55v1 = "InitializeSettings()"
    c55v0(c55v1)
    c55v0 = mMovie
    c55v2 = "Container.OptionListMask"
    c55v3 = 15
    c55v4 = 600
    c55v0:SetNumberVariable(c55v2, c55v3, c55v4)
    c55v0 = require
    c55v1 = "EE.Interface.Components.List"
    c55v0 = c55v0(c55v1)
    c55v1 = c55v0.CreateList
    c55v2 = mMovie
    c55v3 = "Container.OptionList.MenuEntry1"
    c55v1 = c55v1(c55v2, c55v3)
    v12 = c55v1
    c55v1 = v12
    c55v3 = "MenuEntryPressed"
    c55v4 = "MenuEntryFocused"
    c55v5 = "MenuEntryUnfocused"
    c55v1:SetCallbacks(c55v3, c55v4, c55v5)
    c55v1 = v12
    c55v2 = function(c21v0, c21v1)
      do return end
    end
    c55v1.Print = c55v2
    c55v1 = v12
    c55v2 = function(c22v0)
      local c22v1, c22v2, c22v3, c22v4, c22v5, c22v6, c22v7
      local __renovice_local_0 = c22v0.mTooltip
      if __renovice_local_0 then
        __renovice_local_0 = _T
        c22v1 = c22v0.mTooltip
        __renovice_local_0.gToolTip = c22v1
      end
      v15 = c22v0
      __renovice_local_0 = true
      c22v0.mFocused = __renovice_local_0
      __renovice_local_0 = c22v0.mLocked
      if __renovice_local_0 then
        do return end
      end
      __renovice_local_0 = c22v0.mType
      c22v1 = v0
      c22v1 = c22v1.TITLE
      if __renovice_local_0 ~= c22v1 then
        __renovice_local_0 = c22v0.mType
        c22v1 = v0
        c22v1 = c22v1.SPACER
        if __renovice_local_0 ~= c22v1 then
          __renovice_local_0 = c22v0.mType
          c22v1 = v0
          c22v1 = c22v1.IMAGE
          if __renovice_local_0 ~= c22v1 then
            __renovice_local_0 = c22v0.mClipName
            if __renovice_local_0 ~= nil then
              __renovice_local_0 = v1
              __renovice_local_0 = __renovice_local_0.PlaySound
              c22v1 = _G
              c22v1 = c22v1.UISound_Focus
              __renovice_local_0(c22v1)
              __renovice_local_0 = mMovie
              c22v3 = c22v0.mClipName
              c22v4 = ".Bg"
              c22v2 = c22v3 .. c22v4
              c22v3 = "RectEdgeColor"
              c22v4 = v27
              c22v4 = c22v4.FloatingContentHighlightProcedural
              c22v4 = c22v4.r
              c22v5 = v27
              c22v5 = c22v5.FloatingContentHighlightProcedural
              c22v5 = c22v5.g
              c22v6 = v27
              c22v6 = c22v6.FloatingContentHighlightProcedural
              c22v6 = c22v6.b
              c22v7 = 0.5
              __renovice_local_0:Name__48ecbbab(c22v2, c22v3, c22v4, c22v5, c22v6, c22v7)
              __renovice_local_0 = mMovie
              c22v2 = c22v0.mClipName
              c22v3 = "Label"
              c22v4 = 44
              c22v5 = v27
              c22v5 = c22v5.FloatingContentHighlight
              __renovice_local_0:Name__82f6549c(c22v2, c22v3, c22v4, c22v5)
              __renovice_local_0 = c22v0.mType
              c22v1 = v0
              c22v1 = c22v1.INPUTCOUNT
              if __renovice_local_0 == c22v1 then
                __renovice_local_0 = mMovie
                c22v2 = c22v0.mClipName
                c22v3 = "Callouts"
                c22v4 = 13
                c22v5 = Engine.IsPlayingWithController
                c22v5 = c22v5()
                if c22v5 then
                  c22v7 = v15
                  c22v6 = IsNull
                  c22v6 = c22v6(c22v7)
                  c22v5 = not c22v6
                  if c22v5 then
                    c22v6 = v15
                    c22v6 = c22v6.Id
                    c22v7 = c22v0.Id
                    if c22v6 ~= c22v7 then
                      c22v5 = false
                    else
                      c22v5 = true
                    end
                  end
                end
                __renovice_local_0:Name__e375fc94(c22v2, c22v3, c22v4, c22v5)
                __renovice_local_0 = Engine.IsPlayingWithController
                __renovice_local_0 = __renovice_local_0()
                if __renovice_local_0 then
                  __renovice_local_0 = mMovie
                  c22v3 = c22v0.mClipName
                  c22v4 = ".Callouts.Right.Tf.text"
                  c22v2 = c22v3 .. c22v4
                  c22v3 = "<MENU_RTRIGGER2>"
                  __renovice_local_0:SetLocalized(c22v2, c22v3)
                  __renovice_local_0 = mMovie
                  c22v3 = c22v0.mClipName
                  c22v4 = ".Callouts.Left.Tf.text"
                  c22v2 = c22v3 .. c22v4
                  c22v3 = "<MENU_LTRIGGER2>"
                  __renovice_local_0:SetLocalized(c22v2, c22v3)
                  do return end
                end
              else
                __renovice_local_0 = c22v0.mType
                c22v1 = v0
                c22v1 = c22v1.CHECKBOX
                if __renovice_local_0 == c22v1 then
                  __renovice_local_0 = c22v0.Checkbox
                  c22v2 = true
                  __renovice_local_0:TrySetFocus(c22v2)
                end
              end
              do return end
            end
          end
        end
      end
      do return end
    end
    c55v1.mOnFocusedCallback = c55v2
    c55v1 = v12
    c55v2 = function(c23v0)
      local c23v1, c23v2, c23v3, c23v4, c23v5, c23v6, c23v7
      local __renovice_local_0 = c23v0.mTooltip
      if __renovice_local_0 then
        __renovice_local_0 = _T
        c23v1 = nil
        __renovice_local_0.gToolTip = c23v1
      end
      __renovice_local_0 = false
      c23v0.mFocused = __renovice_local_0
      __renovice_local_0 = c23v0.mType
      c23v1 = v0
      c23v1 = c23v1.TITLE
      if __renovice_local_0 ~= c23v1 then
        __renovice_local_0 = c23v0.mType
        c23v1 = v0
        c23v1 = c23v1.SPACER
        if __renovice_local_0 ~= c23v1 then
          __renovice_local_0 = c23v0.mType
          c23v1 = v0
          c23v1 = c23v1.IMAGE
          if __renovice_local_0 ~= c23v1 then
            __renovice_local_0 = c23v0.mClipName
            if __renovice_local_0 ~= nil then
              __renovice_local_0 = mMovie
              c23v3 = c23v0.mClipName
              c23v4 = ".Bg"
              c23v2 = c23v3 .. c23v4
              c23v3 = "RectEdgeColor"
              c23v4 = v27
              c23v4 = c23v4.FloatingContentProcedural
              c23v4 = c23v4.r
              c23v5 = v27
              c23v5 = c23v5.FloatingContentProcedural
              c23v5 = c23v5.g
              c23v6 = v27
              c23v6 = c23v6.FloatingContentProcedural
              c23v6 = c23v6.b
              c23v7 = 0.1
              __renovice_local_0:Name__48ecbbab(c23v2, c23v3, c23v4, c23v5, c23v6, c23v7)
              __renovice_local_0 = mMovie
              c23v2 = c23v0.mClipName
              c23v3 = "Label"
              c23v4 = 44
              c23v5 = v27
              c23v5 = c23v5.FloatingContent
              __renovice_local_0:Name__82f6549c(c23v2, c23v3, c23v4, c23v5)
              __renovice_local_0 = c23v0.mType
              c23v1 = v0
              c23v1 = c23v1.INPUTCOUNT
              if __renovice_local_0 == c23v1 then
                __renovice_local_0 = mMovie
                c23v2 = c23v0.mClipName
                c23v3 = "Callouts"
                c23v4 = 13
                c23v5 = false
                __renovice_local_0:Name__e375fc94(c23v2, c23v3, c23v4, c23v5)
                __renovice_local_0 = Engine.IsPlayingWithController
                __renovice_local_0 = __renovice_local_0()
                if __renovice_local_0 then
                  __renovice_local_0 = mMovie
                  c23v3 = c23v0.mClipName
                  c23v4 = ".Callouts.Right.Tf.text"
                  c23v2 = c23v3 .. c23v4
                  c23v3 = "<MENU_RTRIGGER2>"
                  __renovice_local_0:SetLocalized(c23v2, c23v3)
                  __renovice_local_0 = mMovie
                  c23v3 = c23v0.mClipName
                  c23v4 = ".Callouts.Left.Tf.text"
                  c23v2 = c23v3 .. c23v4
                  c23v3 = "<MENU_LTRIGGER2>"
                  __renovice_local_0:SetLocalized(c23v2, c23v3)
                  do return end
                end
              else
                __renovice_local_0 = c23v0.mType
                c23v1 = v0
                c23v1 = c23v1.CHECKBOX
                if __renovice_local_0 == c23v1 then
                  __renovice_local_0 = c23v0.Checkbox
                  c23v2 = false
                  __renovice_local_0:TrySetFocus(c23v2)
                end
              end
              do return end
            end
          end
        end
      end
      do return end
    end
    c55v1.mOnUnfocusedCallback = c55v2
    c55v1 = v12
    c55v2 = function(c26v0)
      local c26v1, c26v2, c26v3, c26v4
      local __renovice_local_0 = c26v0.mLocked
      if __renovice_local_0 then
        do return end
      end
      __renovice_local_0 = c26v0.mType
      c26v1 = v0
      c26v1 = c26v1.CHECKBOX
      if __renovice_local_0 == c26v1 then
        __renovice_local_0 = c26v0.Checkbox
        if __renovice_local_0 ~= nil then
          __renovice_local_0 = c26v0.Checkbox
          c26v2 = true
          __renovice_local_0:TryPressed(c26v2)
        end
      else
        __renovice_local_0 = c26v0.mType
        c26v1 = v0
        c26v1 = c26v1.BUTTON
        if __renovice_local_0 == c26v1 then
          __renovice_local_0 = c26v0.mCallback
          if __renovice_local_0 ~= nil then
            __renovice_local_0 = c26v0.mCallback
            __renovice_local_0()
            __renovice_local_0 = v60
            __renovice_local_0()
          end
        else
          __renovice_local_0 = c26v0.mType
          c26v1 = v0
          c26v1 = c26v1.COLOR
          if __renovice_local_0 == c26v1 then
            __renovice_local_0 = v0
            __renovice_local_0 = __renovice_local_0.OpenColorPicker
            c26v1 = mMovie
            c26v2 = c26v0.mCurrColor
            c26v3 = function(c24v0, c24v1)
              local c24v2, c24v3
              if c24v0 == nil then
                c24v2 = c26v0
                c24v3 = nil
                c24v2.mNewColor = c24v3
                do return end
              end
              c26v0.mNewColor = c24v0
              do return end
            end
            c26v4 = function(c25v0)
              local c25v1, c25v2, c25v3, c25v4, c25v5, c25v6
              if c25v0 then
                c25v1 = c26v0
                c25v2 = c26v0
                c25v2 = c25v2.mNewColor
                c25v1.mCurrColor = c25v2
                c25v2 = c26v0
                c25v2 = c25v2.mOnColorSelected
                c25v1 = IsNull
                c25v1 = c25v1(c25v2)
                if not c25v1 then
                  c25v1 = c26v0
                  c25v1 = c25v1.mOnColorSelected
                  c25v2 = c26v0
                  c25v2 = c25v2.mCurrColor
                  c25v1(c25v2)
                end
                c25v1 = mMovie
                c25v3 = c26v0
                c25v3 = c25v3.mClipName
                c25v4 = "Color.Fill"
                c25v5 = 11
                c25v6 = c26v0
                c25v6 = c25v6.mCurrColor
                c25v1:Name__82f6549c(c25v3, c25v4, c25v5, c25v6)
              end
              c25v1 = c26v0
              c25v2 = nil
              c25v1.mNewColor = c25v2
              do return end
            end
            __renovice_local_0(c26v1, c26v2, c26v3, c26v4)
            __renovice_local_0 = v60
            __renovice_local_0()
            do return end
          end
          __renovice_local_0 = c26v0.mType
          c26v1 = v0
          c26v1 = c26v1.INPUTCOUNT
          if __renovice_local_0 == c26v1 then
            __renovice_local_0 = v12
            __renovice_local_0 = __renovice_local_0.mElementDrawCallback
            __renovice_local_0(c26v0)
            do return end
          end
          __renovice_local_0 = c26v0.mType
          c26v1 = v0
          c26v1 = c26v1.INPUTBOX
          if __renovice_local_0 == c26v1 then
            __renovice_local_0 = mMovie
            c26v2 = c26v0.InputField
            c26v2 = c26v2.mLabelClipName
            c26v3 = 52
            c26v4 = c26v0.mMultiLine
            __renovice_local_0:Name__863e56e7(c26v2, c26v3, c26v4)
            c26v1 = c26v0.mMaxChars
            __renovice_local_0 = IsNull
            __renovice_local_0 = __renovice_local_0(c26v1)
            if not __renovice_local_0 then
              __renovice_local_0 = mMovie
              c26v2 = c26v0.InputField
              c26v2 = c26v2.mLabelClipName
              c26v3 = 39
              c26v4 = c26v0.mMaxChars
              __renovice_local_0:SetNumberVariable(c26v2, c26v3, c26v4)
            end
            __renovice_local_0 = c26v0.InputField
            if __renovice_local_0 ~= nil then
              __renovice_local_0 = c26v0.InputField
              c26v2 = true
              __renovice_local_0:Pressed(c26v2)
            end
            __renovice_local_0 = v60
            __renovice_local_0()
          end
        end
      end
      do return end
    end
    c55v1.mOnSelectedCallback = c55v2
    c55v1 = v12
    c55v2 = function(c47v0)
      local c47v1, c47v2, c47v3, c47v4, c47v5, c47v6, c47v7, c47v8, c47v9, c47v10, c47v11, c47v12, c47v13, c47v14
      local __renovice_local_0 = c47v0.mClipName
      if __renovice_local_0 == nil then
        do return end
      end
      local __renovice_local_1 = c47v0.mMultiLine
      if __renovice_local_1 ~= true then
        __renovice_local_0 = false
      else
        __renovice_local_0 = true
      end
      c47v0.mMultiLine = __renovice_local_0
      __renovice_local_0 = c47v0.mType
      __renovice_local_1 = v0
      __renovice_local_1 = __renovice_local_1.IMAGE
      if __renovice_local_0 == __renovice_local_1 then
        __renovice_local_0 = FlashMethod
        __renovice_local_1 = mMovie
        c47v2 = c47v0.mClipName
        c47v3 = ".gotoAndStop"
        c47v1 = c47v2 .. c47v3
        c47v2 = "Image"
        __renovice_local_0(__renovice_local_1, c47v1, c47v2)
        __renovice_local_0 = mMovie
        c47v1 = c47v0.mClipName
        c47v2 = "Image"
        c47v3 = 14
        c47v4 = v1
        c47v4 = c47v4.Ternary
        c47v6 = c47v0.mWidth
        if c47v6 == nil then
          c47v5 = false
        else
          c47v5 = true
        end
        c47v6 = c47v0.mWidth
        c47v7 = 100
        __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4(c47v5, c47v6, c47v7))
        __renovice_local_0 = mMovie
        c47v1 = c47v0.mClipName
        c47v2 = "Image"
        c47v3 = 15
        c47v4 = v1
        c47v4 = c47v4.Ternary
        c47v6 = c47v0.mHeight
        if c47v6 == nil then
          c47v5 = false
        else
          c47v5 = true
        end
        c47v6 = c47v0.mHeight
        c47v7 = 100
        __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4(c47v5, c47v6, c47v7))
        __renovice_local_0 = mMovie
        c47v2 = c47v0.mClipName
        c47v3 = ".Image"
        c47v1 = c47v2 .. c47v3
        c47v2 = c47v0.mImageResource
        __renovice_local_0:OverrideTexture(c47v1, c47v2)
        __renovice_local_0 = c47v0.mInitialY
        if __renovice_local_0 == nil then
          __renovice_local_0 = mMovie
          c47v1 = c47v0.mClipName
          c47v2 = "Image"
          c47v3 = 1
          __renovice_local_0 = __renovice_local_0:Name__fd1f2935(c47v1, c47v2, c47v3)
          c47v0.mInitialY = __renovice_local_0
        end
        __renovice_local_0 = c47v0.mYOffset
        if __renovice_local_0 ~= nil then
          __renovice_local_0 = mMovie
          c47v1 = c47v0.mClipName
          c47v2 = "Image"
          c47v3 = 1
          c47v5 = c47v0.mInitialY
          c47v6 = c47v0.mYOffset
          c47v4 = c47v5 + c47v6
          __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
        end
      else
        __renovice_local_0 = c47v0.mType
        __renovice_local_1 = v0
        __renovice_local_1 = __renovice_local_1.SPACER
        if __renovice_local_0 == __renovice_local_1 then
          __renovice_local_0 = FlashMethod
          __renovice_local_1 = mMovie
          c47v2 = c47v0.mClipName
          c47v3 = ".gotoAndStop"
          c47v1 = c47v2 .. c47v3
          c47v2 = "Title"
          __renovice_local_0(__renovice_local_1, c47v1, c47v2)
        else
          __renovice_local_0 = c47v0.mType
          __renovice_local_1 = v0
          __renovice_local_1 = __renovice_local_1.TITLE
          if __renovice_local_0 == __renovice_local_1 then
            __renovice_local_0 = FlashMethod
            __renovice_local_1 = mMovie
            c47v2 = c47v0.mClipName
            c47v3 = ".gotoAndStop"
            c47v1 = c47v2 .. c47v3
            c47v2 = "Title"
            __renovice_local_0(__renovice_local_1, c47v1, c47v2)
            __renovice_local_0 = mMovie
            c47v1 = c47v0.mClipName
            c47v2 = "Label"
            c47v3 = 14
            c47v4 = v1
            c47v4 = c47v4.Ternary
            c47v6 = c47v0.mWidth
            if c47v6 == nil then
              c47v5 = false
            else
              c47v5 = true
            end
            c47v6 = c47v0.mWidth
            c47v7 = 800
            __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4(c47v5, c47v6, c47v7))
            __renovice_local_0 = mMovie
            c47v1 = c47v0.mClipName
            c47v2 = "Label"
            c47v3 = 52
            c47v4 = c47v0.mMultiLine
            __renovice_local_0:Name__e375fc94(c47v1, c47v2, c47v3, c47v4)
            __renovice_local_0 = c47v0.mInitialX
            if __renovice_local_0 == nil then
              __renovice_local_0 = mMovie
              c47v2 = c47v0.mClipName
              c47v3 = ".Label"
              c47v1 = c47v2 .. c47v3
              c47v2 = 0
              __renovice_local_0 = __renovice_local_0:GetNumberVariable(c47v1, c47v2)
              c47v0.mInitialX = __renovice_local_0
            end
            __renovice_local_0 = c47v0.mInitialY
            if __renovice_local_0 == nil then
              __renovice_local_0 = mMovie
              c47v2 = c47v0.mClipName
              c47v3 = ".Label"
              c47v1 = c47v2 .. c47v3
              c47v2 = 1
              __renovice_local_0 = __renovice_local_0:GetNumberVariable(c47v1, c47v2)
              c47v0.mInitialY = __renovice_local_0
            end
            __renovice_local_0 = c47v0.mVerticalPadding
            if __renovice_local_0 ~= nil then
              __renovice_local_0 = mMovie
              c47v1 = c47v0.mClipName
              c47v2 = "Label"
              c47v3 = 1
              c47v5 = c47v0.mInitialY
              c47v6 = c47v0.mVerticalPadding
              c47v4 = c47v5 + c47v6
              __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
            end
            __renovice_local_0 = c47v0.mHorizontalPadding
            if __renovice_local_0 ~= nil then
              __renovice_local_0 = mMovie
              c47v1 = c47v0.mClipName
              c47v2 = "Label"
              c47v3 = 0
              c47v5 = c47v0.mInitialX
              c47v6 = c47v0.mHorizontalPadding
              c47v4 = c47v5 + c47v6
              __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
            end
            __renovice_local_0 = c47v0.mFontSize
            if __renovice_local_0 ~= nil then
              __renovice_local_0 = mMovie
              c47v1 = c47v0.mClipName
              c47v2 = "Label"
              c47v3 = 50
              c47v4 = c47v0.mFontSize
              __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
            end
            __renovice_local_0 = Engine.Name__c3e1c31d
            __renovice_local_0 = __renovice_local_0()
            if __renovice_local_0 then
              __renovice_local_0 = mMovie
              c47v1 = c47v0.mClipName
              c47v2 = "Label"
              c47v3 = 49
              c47v4 = "Arial Unicode MS"
              __renovice_local_0:Name__34a7a1c9(c47v1, c47v2, c47v3, c47v4)
            end
          else
            __renovice_local_0 = c47v0.mType
            __renovice_local_1 = v0
            __renovice_local_1 = __renovice_local_1.CHECKBOX
            if __renovice_local_0 == __renovice_local_1 then
              __renovice_local_0 = FlashMethod
              __renovice_local_1 = mMovie
              c47v2 = c47v0.mClipName
              c47v3 = ".gotoAndStop"
              c47v1 = c47v2 .. c47v3
              c47v2 = "Checkbox"
              __renovice_local_0(__renovice_local_1, c47v1, c47v2)
              __renovice_local_0 = v12
              __renovice_local_0 = __renovice_local_0.mScroll
              if __renovice_local_0 ~= nil then
                __renovice_local_0 = nil
                c47v0.Checkbox = __renovice_local_0
              end
              __renovice_local_0 = c47v0.Checkbox
              if __renovice_local_0 == nil then
                __renovice_local_0 = v5
                __renovice_local_0 = __renovice_local_0.Create__e256561c
                __renovice_local_1 = mMovie
                c47v2 = c47v0.mClipName
                c47v3 = ".Checkbox"
                c47v1 = c47v2 .. c47v3
                c47v2 = c47v0.mValue
                __renovice_local_0 = __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                c47v0.Checkbox = __renovice_local_0
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = c47v0.mId
                __renovice_local_0.mParentId = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = 28
                __renovice_local_0.mHeight = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = 64
                __renovice_local_0.mMinSize = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = 64
                __renovice_local_0.mMaxSize = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = 40
                __renovice_local_0.mEdgeAlpha = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = 80
                __renovice_local_0.mFocusedEdgeAlpha = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = 1
                __renovice_local_0.mUnfocusedEdgeColor = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = Name__3d365a52
                __renovice_local_0.mIconOn = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = crossIcon
                __renovice_local_0.mIconOff = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = Name__ed8f76ee
                __renovice_local_0.mIconDefault = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = c47v0.mLocked
                __renovice_local_0.mLocked = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = c47v0.Checkbox
                __renovice_local_1 = __renovice_local_1.Pressed
                __renovice_local_0.CheckboxPressed = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = function(c27v0, c27v1, c27v2)
                  local c27v3
                  c27v3 = c47v0
                  c27v3 = c27v3.mLocked
                  if not c27v3 then
                    c27v3 = c47v0
                    c27v3 = c27v3.Checkbox
                    c27v3 = c27v3.CheckboxPressed
                    c27v3(c27v0, c27v1, c27v2)
                  end
                  do return end
                end
                __renovice_local_0.Pressed = __renovice_local_1
                __renovice_local_0 = c47v0.Checkbox
                __renovice_local_1 = function(c28v0)
                  local c28v1, c28v2
                  c28v1 = c47v0
                  c28v2 = c28v0.mChecked
                  c28v1.mValue = c28v2
                  c28v1 = v60
                  c28v1()
                  do return end
                end
                __renovice_local_0.ValueChanged = __renovice_local_1
              end
              __renovice_local_0 = c47v0.Checkbox
              __renovice_local_0:Redraw()
              __renovice_local_0 = c47v0.mButtonWidth
              if __renovice_local_0 ~= nil then
                __renovice_local_0 = mMovie
                c47v1 = c47v0.mClipName
                c47v2 = "Btn"
                c47v3 = 14
                c47v4 = c47v0.mButtonWidth
                __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                __renovice_local_0 = mMovie
                c47v1 = c47v0.mClipName
                c47v2 = "Bg"
                c47v3 = 14
                c47v4 = c47v0.mButtonWidth
                __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                __renovice_local_0 = c47v0.mValueOffset
                if __renovice_local_0 ~= nil then
                  __renovice_local_0 = c47v0.Checkbox
                  c47v3 = c47v0.mButtonWidth
                  c47v4 = c47v0.Checkbox
                  c47v4 = c47v4.mMaxSize
                  c47v2 = c47v3 - c47v4
                  c47v3 = c47v0.mValueOffset
                  c47v1 = c47v2 - c47v3
                  __renovice_local_0:SetPosition(c47v1)
                else
                  __renovice_local_0 = c47v0.Checkbox
                  c47v2 = c47v0.mButtonWidth
                  c47v1 = c47v2 - 70
                  __renovice_local_0:SetPosition(c47v1)
                end
              end
            else
              __renovice_local_0 = c47v0.mType
              __renovice_local_1 = v0
              __renovice_local_1 = __renovice_local_1.TOGGLE
              if __renovice_local_0 == __renovice_local_1 then
                __renovice_local_0 = FlashMethod
                __renovice_local_1 = mMovie
                c47v2 = c47v0.mClipName
                c47v3 = ".gotoAndStop"
                c47v1 = c47v2 .. c47v3
                c47v2 = "Toggle"
                __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                __renovice_local_0 = v12
                __renovice_local_0 = __renovice_local_0.mScroll
                if __renovice_local_0 ~= nil then
                  __renovice_local_0 = nil
                  c47v0.Toggle = __renovice_local_0
                end
                __renovice_local_0 = c47v0.Toggle
                if __renovice_local_0 == nil then
                  __renovice_local_0 = v6
                  __renovice_local_0 = __renovice_local_0.Create__e256561c
                  __renovice_local_1 = mMovie
                  c47v2 = c47v0.mClipName
                  c47v3 = ".Toggle"
                  c47v1 = c47v2 .. c47v3
                  c47v2 = c47v0.mToggleValues
                  __renovice_local_0 = __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                  c47v0.Toggle = __renovice_local_0
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = c47v0.Id
                  __renovice_local_0.mParentId = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = 28
                  __renovice_local_0.mHeight = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = 270
                  __renovice_local_0.mMinSize = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = 270
                  __renovice_local_0.mMaxSize = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = 40
                  __renovice_local_0.mEdgeAlpha = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = 80
                  __renovice_local_0.mFocusedEdgeAlpha = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = 1
                  __renovice_local_0.mUnfocusedEdgeColor = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = arrowIcon
                  __renovice_local_0.mArrowIcon = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  c47v1 = c47v0.mValue
                  __renovice_local_0:SetIndexByValue(c47v1)
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = c47v0.Toggle
                  __renovice_local_1 = __renovice_local_1.TrySetFocus
                  __renovice_local_0.ComponentTrySetFocus = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = function(c29v0, c29v1)
                    local c29v2, c29v3, c29v4
                    c29v0:ComponentTrySetFocus(c29v1)
                    c29v2 = v12
                    c29v4 = c47v0
                    c29v4 = c29v4.Id
                    c29v3 = tonumber
                    c29v3 = c29v3(c29v4)
                    c29v2:FocusElementById(c29v3)
                    do return end
                  end
                  __renovice_local_0.TrySetFocus = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = c47v0.Toggle
                  __renovice_local_1 = __renovice_local_1.TrySetAltFocus
                  __renovice_local_0.ComponentTrySetAltFocus = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = function(c30v0, c30v1, c30v2)
                    local c30v3, c30v4, c30v5
                    c30v0:ComponentTrySetAltFocus(c30v1, c30v2)
                    c30v3 = v12
                    c30v5 = c47v0
                    c30v5 = c30v5.Id
                    c30v4 = tonumber
                    c30v4 = c30v4(c30v5)
                    c30v3:FocusElementById(c30v4)
                    do return end
                  end
                  __renovice_local_0.TrySetAltFocus = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = c47v0.Toggle
                  __renovice_local_1 = __renovice_local_1.TryPressed
                  __renovice_local_0.ComponentTryPressed = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = function(c31v0, c31v1, c31v2)
                    c31v0:ComponentTryPressed(c31v1, c31v2)
                    do return end
                  end
                  __renovice_local_0.TryPressed = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = c47v0.Toggle
                  __renovice_local_1 = __renovice_local_1.TryAltPressed
                  __renovice_local_0.ComponentTryAltPressed = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = function(c32v0, c32v1, c32v2)
                    c32v0:ComponentTryAltPressed(c32v1, c32v2)
                    do return end
                  end
                  __renovice_local_0.TryAltPressed = __renovice_local_1
                  __renovice_local_0 = c47v0.Toggle
                  __renovice_local_1 = function(c33v0)
                    local c33v1, c33v2, c33v3, c33v4
                    c33v1 = c47v0
                    c33v3 = c33v0.mOptions
                    c33v4 = c33v0.mIndex
                    c33v2 = c33v3[c33v4]
                    c33v2 = c33v2.Value
                    c33v1.mValue = c33v2
                    c33v1 = v60
                    c33v1()
                    do return end
                  end
                  __renovice_local_0.ValueChanged = __renovice_local_1
                end
                __renovice_local_0 = c47v0.mButtonWidth
                if __renovice_local_0 ~= nil then
                  __renovice_local_0 = mMovie
                  c47v1 = c47v0.mClipName
                  c47v2 = "Btn"
                  c47v3 = 14
                  c47v4 = c47v0.mButtonWidth
                  __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                  __renovice_local_0 = mMovie
                  c47v1 = c47v0.mClipName
                  c47v2 = "Bg"
                  c47v3 = 14
                  c47v4 = c47v0.mButtonWidth
                  __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                  __renovice_local_0 = c47v0.Toggle
                  c47v3 = c47v0.mButtonWidth
                  c47v4 = c47v0.Toggle
                  c47v4 = c47v4.mMaxSize
                  c47v2 = c47v3 - c47v4
                  c47v1 = c47v2 - 4
                  __renovice_local_0:SetPosition(c47v1)
                else
                  __renovice_local_0 = mMovie
                  c47v2 = c47v0.mClipName
                  c47v3 = ".Btn"
                  c47v1 = c47v2 .. c47v3
                  c47v2 = 14
                  __renovice_local_0 = __renovice_local_0:GetNumberVariable(c47v1, c47v2)
                  __renovice_local_1 = c47v0.Toggle
                  c47v4 = c47v0.Toggle
                  c47v4 = c47v4.mMaxSize
                  c47v3 = __renovice_local_0 - c47v4
                  c47v2 = c47v3 - 4
                  __renovice_local_1:SetPosition(c47v2)
                end
                __renovice_local_0 = c47v0.Toggle
                __renovice_local_0:Redraw()
              else
                __renovice_local_0 = c47v0.mType
                __renovice_local_1 = v0
                __renovice_local_1 = __renovice_local_1.BUTTON
                if __renovice_local_0 == __renovice_local_1 then
                  __renovice_local_0 = FlashMethod
                  __renovice_local_1 = mMovie
                  c47v2 = c47v0.mClipName
                  c47v3 = ".gotoAndStop"
                  c47v1 = c47v2 .. c47v3
                  c47v2 = "button"
                  __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                  __renovice_local_0 = mMovie
                  c47v1 = c47v0.mClipName
                  c47v2 = "Arrow"
                  c47v3 = 11
                  c47v4 = _G
                  c47v4 = c47v4.UIColor_MediumGrey
                  __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                  __renovice_local_0 = c47v0.mButtonWidth
                  if __renovice_local_0 ~= nil then
                    __renovice_local_0 = mMovie
                    c47v1 = c47v0.mClipName
                    c47v2 = "Btn"
                    c47v3 = 14
                    c47v4 = c47v0.mButtonWidth
                    __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                    __renovice_local_0 = mMovie
                    c47v1 = c47v0.mClipName
                    c47v2 = "Bg"
                    c47v3 = 14
                    c47v4 = c47v0.mButtonWidth
                    __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                  end
                  __renovice_local_0 = c47v0.mSubLabel
                  if __renovice_local_0 ~= nil then
                    __renovice_local_0 = mMovie
                    c47v1 = c47v0.mClipName
                    c47v2 = "SubLabel"
                    c47v3 = 36
                    c47v4 = c47v0.mSubLabel
                    __renovice_local_0:Name__34a7a1c9(c47v1, c47v2, c47v3, c47v4)
                    __renovice_local_0 = v1
                    __renovice_local_0 = __renovice_local_0.Ternary
                    c47v1 = c47v0.mSubLabelOffset
                    if c47v1 == nil then
                      __renovice_local_1 = false
                    else
                      __renovice_local_1 = true
                    end
                    c47v1 = c47v0.mSubLabelOffset
                    c47v2 = 100
                    __renovice_local_0 = __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                    __renovice_local_1 = mMovie
                    c47v2 = c47v0.mClipName
                    c47v3 = "SubLabel"
                    c47v4 = 0
                    c47v6 = c47v0.mButtonWidth
                    c47v5 = c47v6 - __renovice_local_0
                    __renovice_local_1:Name__82f6549c(c47v2, c47v3, c47v4, c47v5)
                    __renovice_local_1 = mMovie
                    c47v2 = c47v0.mClipName
                    c47v3 = "SubLabel"
                    c47v4 = 44
                    c47v5 = v27
                    c47v5 = c47v5.FloatingContent
                    __renovice_local_1:Name__82f6549c(c47v2, c47v3, c47v4, c47v5)
                  else
                    __renovice_local_0 = mMovie
                    c47v1 = c47v0.mClipName
                    c47v2 = "SubLabel"
                    c47v3 = 13
                    c47v4 = false
                    __renovice_local_0:Name__e375fc94(c47v1, c47v2, c47v3, c47v4)
                  end
                else
                  __renovice_local_0 = c47v0.mType
                  __renovice_local_1 = v0
                  __renovice_local_1 = __renovice_local_1.COLOR
                  if __renovice_local_0 == __renovice_local_1 then
                    __renovice_local_0 = FlashMethod
                    __renovice_local_1 = mMovie
                    c47v2 = c47v0.mClipName
                    c47v3 = ".gotoAndStop"
                    c47v1 = c47v2 .. c47v3
                    c47v2 = "color"
                    __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                    __renovice_local_0 = c47v0.mButtonWidth
                    if __renovice_local_0 ~= nil then
                      __renovice_local_0 = mMovie
                      c47v1 = c47v0.mClipName
                      c47v2 = "Btn"
                      c47v3 = 14
                      c47v4 = c47v0.mButtonWidth
                      __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                      __renovice_local_0 = mMovie
                      c47v1 = c47v0.mClipName
                      c47v2 = "Bg"
                      c47v3 = 14
                      c47v4 = c47v0.mButtonWidth
                      __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                      __renovice_local_0 = mMovie
                      c47v1 = c47v0.mClipName
                      c47v2 = "Color"
                      c47v3 = 0
                      c47v5 = c47v0.mButtonWidth
                      c47v4 = c47v5 - 35
                      __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                    end
                    __renovice_local_0 = c47v0.mCurrColor
                    if __renovice_local_0 then
                      __renovice_local_0 = mMovie
                      c47v1 = c47v0.mClipName
                      c47v2 = "Color.Fill"
                      c47v3 = 11
                      c47v4 = c47v0.mCurrColor
                      __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                    end
                  else
                    __renovice_local_0 = c47v0.mType
                    __renovice_local_1 = v0
                    __renovice_local_1 = __renovice_local_1.INPUTBOX
                    if __renovice_local_0 == __renovice_local_1 then
                      __renovice_local_0 = FlashMethod
                      __renovice_local_1 = mMovie
                      c47v2 = c47v0.mClipName
                      c47v3 = ".gotoAndStop"
                      c47v1 = c47v2 .. c47v3
                      c47v2 = "Inputbox"
                      __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                      __renovice_local_0 = mMovie
                      c47v2 = c47v0.mClipName
                      c47v3 = ".InputBoxText"
                      c47v1 = c47v2 .. c47v3
                      c47v2 = nil
                      c47v3 = nil
                      c47v4 = "InputBoxTextLimited"
                      c47v5 = nil
                      __renovice_local_0:SetFocusedCallbacks(c47v1, c47v2, c47v3, c47v4, c47v5)
                      __renovice_local_0 = c47v0.mHorizontalPadding
                      if __renovice_local_0 ~= nil then
                        __renovice_local_0 = mMovie
                        c47v1 = c47v0.mClipName
                        c47v2 = 0
                        __renovice_local_0 = __renovice_local_0:GetNumberVariable(c47v1, c47v2)
                        __renovice_local_1 = mMovie
                        c47v2 = c47v0.mClipName
                        c47v3 = 0
                        c47v5 = c47v0.mHorizontalPadding
                        c47v4 = __renovice_local_0 + c47v5
                        __renovice_local_1:SetNumberVariable(c47v2, c47v3, c47v4)
                      end
                      __renovice_local_1 = c47v0.mPassword
                      if __renovice_local_1 ~= true then
                        __renovice_local_0 = false
                      else
                        __renovice_local_0 = true
                      end
                      c47v0.mPassword = __renovice_local_0
                      __renovice_local_0 = 800
                      __renovice_local_1 = c47v0.mWidth
                      if __renovice_local_1 ~= nil then
                        __renovice_local_0 = c47v0.mWidth
                      end
                      __renovice_local_1 = 57
                      c47v1 = c47v0.mMultiLine
                      if not c47v1 then
                        __renovice_local_1 = 30
                      else
                        c47v1 = c47v0.mHeight
                        if c47v1 ~= nil then
                          c47v4 = c47v0.mHeight
                          c47v3 = c47v4 - 50
                          c47v1 = math.max
                          __renovice_local_1 = c47v1(__renovice_local_1, c47v3)
                        end
                      end
                      c47v1 = mMovie
                      c47v3 = c47v0.mClipName
                      c47v4 = "Btn"
                      c47v5 = 14
                      c47v6 = __renovice_local_0 + 20
                      c47v1:Name__82f6549c(c47v3, c47v4, c47v5, c47v6)
                      c47v1 = mMovie
                      c47v3 = c47v0.mClipName
                      c47v4 = "Btn"
                      c47v5 = 15
                      c47v6 = __renovice_local_1 + 41
                      c47v1:Name__82f6549c(c47v3, c47v4, c47v5, c47v6)
                      c47v1 = mMovie
                      c47v3 = c47v0.mClipName
                      c47v4 = "Bg"
                      c47v5 = 14
                      c47v6 = __renovice_local_0 + 20
                      c47v1:Name__82f6549c(c47v3, c47v4, c47v5, c47v6)
                      c47v1 = mMovie
                      c47v3 = c47v0.mClipName
                      c47v4 = "Bg"
                      c47v5 = 15
                      c47v6 = __renovice_local_1 + 41
                      c47v1:Name__82f6549c(c47v3, c47v4, c47v5, c47v6)
                      c47v1 = c47v0.InputField
                      if c47v1 == nil then
                        c47v1 = v7
                        c47v1 = c47v1.Create__e256561c
                        c47v2 = mMovie
                        c47v4 = c47v0.mClipName
                        c47v5 = ".InputBox"
                        c47v3 = c47v4 .. c47v5
                        c47v4 = c47v0.mContent
                        c47v5 = nil
                        c47v6 = nil
                        c47v7 = nil
                        c47v8 = nil
                        c47v9 = nil
                        c47v10 = c47v0.mSkipAutoFocus
                        c47v1 = c47v1(c47v2, c47v3, c47v4, c47v5, c47v6, c47v7, c47v8, c47v9, c47v10)
                        c47v0.InputField = c47v1
                        c47v1 = c47v0.InputField
                        c47v2 = c47v0.InputField
                        c47v2 = c47v2.InputFieldFocused
                        c47v1.ComponentInputFieldFocused = c47v2
                        c47v1 = c47v0.InputField
                        c47v2 = function(c34v0, c34v1)
                          local c34v2, c34v3, c34v4
                          c34v2 = v12
                          c34v4 = c47v0
                          c34v4 = c34v4.Id
                          c34v3 = tonumber
                          c34v3 = c34v3(c34v4)
                          c34v2:FocusElementById(c34v3)
                          c34v0:ComponentInputFieldFocused(c34v1)
                          do return end
                        end
                        c47v1.InputFieldFocused = c47v2
                        c47v1 = c47v0.InputField
                        c47v2 = function(c35v0)
                          local c35v1, c35v2, c35v3
                          c35v1 = v12
                          c35v3 = c47v0
                          c35v3 = c35v3.Id
                          c35v2 = tonumber
                          c35v2 = c35v2(c35v3)
                          c35v1:FocusElementById(c35v2)
                          do return end
                        end
                        c47v1.mOnFocusedCallback = c47v2
                        c47v1 = c47v0.InputField
                        c47v2 = c47v0.InputField
                        c47v2 = c47v2.InputFieldTextChanged
                        c47v1.BaseInputFieldTextChanged = c47v2
                        c47v1 = c47v0.InputField
                        c47v2 = function(c36v0, c36v1)
                          local c36v2, c36v3
                          c36v1 = c36v1 or ""
                          c36v2 = c36v0.mLabel
                          if c36v2 ~= c36v1 then
                            c36v2 = v60
                            c36v3 = c47v0
                            c36v2(c36v3)
                          end
                          c36v0:BaseInputFieldTextChanged(c36v1)
                          do return end
                        end
                        c47v1.InputFieldTextChanged = c47v2
                        c47v1 = c47v0.InputField
                        c47v2 = 100
                        c47v1.mInnerAlpha = c47v2
                        c47v1 = c47v0.InputField
                        c47v2 = true
                        c47v1.mAltButtonVisible = c47v2
                        c47v1 = Engine.Name__c3e1c31d
                        c47v1 = c47v1()
                        if c47v1 then
                          c47v1 = mMovie
                          c47v3 = c47v0.InputField
                          c47v3 = c47v3.mLabelClipName
                          c47v4 = 49
                          c47v5 = "Arial Unicode MS"
                          c47v1:SetStringVariable(c47v3, c47v4, c47v5)
                        end
                      end
                      c47v1 = c47v0.InputField
                      c47v1.mMinSize = __renovice_local_0
                      c47v1 = c47v0.InputField
                      c47v1.mMaxSize = __renovice_local_0
                      c47v1 = c47v0.InputField
                      c47v1.mHeight = __renovice_local_1
                      c47v1 = mMovie
                      c47v3 = c47v0.InputField
                      c47v3 = c47v3.mLabelClipName
                      c47v4 = 15
                      c47v1:SetNumberVariable(c47v3, c47v4, __renovice_local_1)
                      c47v1 = mMovie
                      c47v3 = c47v0.InputField
                      c47v3 = c47v3.mLabelClipName
                      c47v4 = 52
                      c47v5 = c47v0.mMultiLine
                      c47v1:Name__863e56e7(c47v3, c47v4, c47v5)
                      c47v1 = mMovie
                      c47v3 = c47v0.InputField
                      c47v3 = c47v3.mLabelClipName
                      c47v4 = 39
                      c47v5 = c47v0.mMaxChars
                      c47v1:SetNumberVariable(c47v3, c47v4, c47v5)
                      c47v3 = mMovie
                      c47v5 = c47v0.InputField
                      c47v5 = c47v5.mLabelClipName
                      c47v6 = 50
                      c47v3 = c47v3:GetNumberVariable(c47v5, c47v6)
                      c47v2 = c47v3 * 1.5
                      c47v1 = __renovice_local_1 / c47v2
                      c47v2 = c47v0.InputField
                      c47v4 = c47v0.mMultiLine
                      c47v2:SetMultiline(c47v4, c47v1)
                      c47v2 = c47v0.mPassword
                      if c47v2 then
                        c47v2 = mMovie
                        c47v4 = "/Lotus/Language/Menu/MainMenu_Password"
                        c47v5 = false
                        c47v2 = c47v2:GetLocalized(c47v4, c47v5)
                        c47v3 = c47v0.InputField
                        c47v5 = c47v0.InputField
                        c47v5 = c47v5.TYPE
                        c47v5 = c47v5.PASSWORD
                        c47v3:SetType(c47v5, c47v2, c47v2)
                      end
                      c47v2 = c47v0.InputField
                      c47v2:Redraw()
                    else
                      __renovice_local_0 = c47v0.mType
                      __renovice_local_1 = v0
                      __renovice_local_1 = __renovice_local_1.INPUTCOUNT
                      if __renovice_local_0 == __renovice_local_1 then
                        __renovice_local_0 = FlashMethod
                        __renovice_local_1 = mMovie
                        c47v2 = c47v0.mClipName
                        c47v3 = ".gotoAndStop"
                        c47v1 = c47v2 .. c47v3
                        c47v2 = "InputCount"
                        __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                        __renovice_local_0 = c47v0.mButtonInfo
                        if __renovice_local_0 == nil then
                          __renovice_local_1 = { Name = "Minus", Row = 1, Width = 32, Label = "<DECR_BUTTON>", Callout = "<MENU_LTRIGGER2>", Callback = "DecreaseCount", SendReleaseCallback = true }
                          c47v1 = { Name = "Count", Row = 1, Width = 180, Label = nil, InputField = true }
                          c47v2 = { Name = "Plus", Row = 1, Width = 32, Label = "<INCR_BUTTON>", Callout = "<MENU_RTRIGGER2>", Callback = "IncreaseCount", SendReleaseCallback = true }
                          __renovice_local_0 = {__renovice_local_1, c47v1, c47v2}
                          c47v0.mButtonInfo = __renovice_local_0
                          c47v1 = 1
                          c47v2 = c47v0.mButtonInfo
                          __renovice_local_0 = #c47v2
                          __renovice_local_1 = 1
                          for __renovice_for_0_0 = c47v1, __renovice_local_0, __renovice_local_1 do
                            c47v3 = c47v0.mButtonInfo
                            c47v2 = c47v3[__renovice_for_0_0]
                            c47v4 = c47v0.mClipName
                            c47v5 = "."
                            c47v6 = c47v2.Name
                            c47v3 = c47v4 .. c47v5 .. c47v6
                            c47v4 = c47v2.Button
                            if c47v4 ~= nil then
                              continue
                            end
                            repeat
                              c47v5 = c47v2.InputField
                              if c47v5 then
                                c47v4 = v7
                                if c47v4 then break end
                              end
                              c47v4 = v8
                            until true
                            c47v5 = c47v4.Create
                            c47v6 = mMovie
                            c47v9 = c47v2.Label
                            c47v8 = c47v9 or ""
                            c47v9 = c47v2.Callback
                            c47v10 = c47v2.Callout
                            c47v11 = nil
                            c47v12 = nil
                            c47v13 = nil
                            c47v14 = c47v2.InputField
                            c47v5 = c47v5(c47v6, c47v3, c47v8, c47v9, c47v10, c47v11, c47v12, c47v13, c47v14)
                            c47v6 = c47v2.Width
                            c47v5.mMinSize = c47v6
                            c47v6 = c47v2.Width
                            c47v5.mMaxSize = c47v6
                            c47v6 = 100
                            c47v5.mInnerAlpha = c47v6
                            c47v6 = c47v5.SetFocus
                            c47v5.BaseSetFocus = c47v6
                            local __renovice_capture_46_15 = c47v5
                            c47v6 = function(c37v0, c37v1)
                              local c37v2
                              c37v2 = __renovice_capture_46_15
                              c37v2:BaseSetFocus(c37v1)
                              if not c37v1 then
                                c37v2 = ConcludeCount
                                c37v2()
                              end
                              do return end
                            end
                            c47v5.SetFocus = c47v6
                            c47v6 = c47v2.SendReleaseCallback
                            if c47v6 then
                              c47v6 = c47v5.mOnPressedCallback
                              c47v5.mOnReleasedCallback = c47v6
                            end
                            c47v6 = c47v5.OnGamepadTransition
                            c47v5.BaseOnGamepadTransition = c47v6
                            local __renovice_capture_46_17 = c47v2
                            c47v6 = function(c38v0)
                              local c38v1, c38v2, c38v3, c38v4
                              c38v1 = c38v0.mCallout
                              if c38v1 then
                                c38v1 = c38v0:IsPlayingWithController()
                                c38v2 = v1
                                c38v2 = c38v2.Ternary
                                c38v3 = ""
                                c38v4 = __renovice_capture_46_17
                                c38v4 = c38v4.Label
                                c38v4 = c38v2(c38v1, c38v3, c38v4)
                                c38v0:SetText(c38v4)
                                c38v0:BaseOnGamepadTransition()
                              end
                              do return end
                            end
                            c47v5.OnGamepadTransition = c47v6
                            c47v6 = c47v2.InputField
                            if c47v6 then
                              c47v6 = c47v5.InputFieldFocused
                              c47v5.BaseInputFieldFocused = c47v6
                              local __renovice_capture_46_18 = c47v5
                              c47v6 = function(c39v0, c39v1)
                                local c39v2, c39v3, c39v4, c39v5, c39v6, c39v7
                                c39v0:BaseInputFieldFocused(c39v1)
                                if c39v1 then
                                  c39v3 = __renovice_capture_46_18
                                  c39v3 = c39v3.mLabel
                                  c39v2 = tonumber
                                  c39v2 = c39v2(c39v3)
                                  c39v3 = c47v0
                                  c39v4 = v1
                                  c39v4 = c39v4.Ternary
                                  if c39v2 ~= nil then
                                    c39v5 = false
                                  else
                                    c39v5 = true
                                  end
                                  c39v6 = 1
                                  c39v7 = c47v0
                                  c39v7 = c39v7.mCount
                                  c39v4 = c39v4(c39v5, c39v6, c39v7)
                                  c39v3.mCount = c39v4
                                  do return end
                                end
                                c39v2 = v46
                                c39v2()
                                c39v3 = __renovice_capture_46_18
                                c39v3 = c39v3.mLabel
                                c39v2 = tonumber
                                c39v2 = c39v2(c39v3)
                                if c39v2 == nil then
                                  c39v3 = __renovice_capture_46_18
                                  c39v5 = "1"
                                  c39v3:SetText(c39v5)
                                  c39v2 = 1
                                end
                                c47v0.mCount = c39v2
                                do return end
                              end
                              c47v5.InputFieldFocused = c47v6
                              c47v8 = "center"
                              c47v5:SetTextAlignment(c47v8)
                              c47v6 = mMovie
                              c47v10 = "Callout.Label"
                              c47v8 = c47v3 .. c47v10
                              c47v9 = 14
                              c47v10 = c47v2.Width
                              c47v6:SetNumberVariable(c47v8, c47v9, c47v10)
                            end
                            c47v5:Resize()
                            c47v2.Button = c47v5
                          end
                          __renovice_local_0 = c47v0.mCountButton
                          if __renovice_local_0 == nil then
                            __renovice_local_1 = c47v0.mButtonInfo
                            __renovice_local_0 = __renovice_local_1[2]
                            __renovice_local_0 = __renovice_local_0.Button
                            c47v0.mCountButton = __renovice_local_0
                            __renovice_local_0 = c47v0.mCountButton
                            c47v1 = c47v0.mCount
                            __renovice_local_0:SetText(c47v1)
                          end
                          __renovice_local_0 = c47v0.Id
                          v31 = __renovice_local_0
                        end
                        __renovice_local_0 = c47v0.mCallback
                        if __renovice_local_0 ~= nil then
                          __renovice_local_0 = c47v0.mCallback
                          __renovice_local_1 = c47v0.mCount
                          __renovice_local_0(__renovice_local_1)
                        end
                      else
                        __renovice_local_0 = c47v0.mType
                        __renovice_local_1 = v0
                        __renovice_local_1 = __renovice_local_1.ICONBUTTON
                        if __renovice_local_0 == __renovice_local_1 then
                          __renovice_local_0 = FlashMethod
                          __renovice_local_1 = mMovie
                          c47v2 = c47v0.mClipName
                          c47v3 = ".gotoAndStop"
                          c47v1 = c47v2 .. c47v3
                          c47v2 = "IconSelector"
                          __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                          __renovice_local_0 = mMovie
                          c47v1 = c47v0.mClipName
                          c47v2 = "Btn"
                          c47v3 = "noMenuSelection"
                          c47v4 = true
                          __renovice_local_0:SetVariableEx(c47v1, c47v2, c47v3, c47v4)
                          __renovice_local_0 = c47v0.mButtonWidth
                          if __renovice_local_0 ~= nil then
                            __renovice_local_0 = mMovie
                            c47v1 = c47v0.mClipName
                            c47v2 = "Btn"
                            c47v3 = 14
                            c47v4 = c47v0.mButtonWidth
                            __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                            __renovice_local_0 = mMovie
                            c47v1 = c47v0.mClipName
                            c47v2 = "Bg"
                            c47v3 = 14
                            c47v4 = c47v0.mButtonWidth
                            __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
                          end
                          __renovice_local_1 = 50
                          c47v2 = c47v0.mRows
                          c47v1 = c47v2 * 42
                          __renovice_local_0 = __renovice_local_1 + c47v1
                          __renovice_local_1 = mMovie
                          c47v2 = c47v0.mClipName
                          c47v3 = "Btn"
                          c47v4 = 15
                          __renovice_local_1:Name__82f6549c(c47v2, c47v3, c47v4, __renovice_local_0)
                          __renovice_local_1 = mMovie
                          c47v2 = c47v0.mClipName
                          c47v3 = "Bg"
                          c47v4 = 15
                          __renovice_local_1:Name__82f6549c(c47v2, c47v3, c47v4, __renovice_local_0)
                          __renovice_local_1 = c47v0.mHeight
                          if __renovice_local_1 == nil then
                            __renovice_local_1 = __renovice_local_0 + 10
                            c47v0.mHeight = __renovice_local_1
                          end
                          __renovice_local_1 = c47v0.mIconGrid
                          if __renovice_local_1 == nil then
                            __renovice_local_1 = getfenv
                            c47v1 = 1
                            __renovice_local_1 = __renovice_local_1(c47v1)
                            c47v2 = "IconFocused"
                            c47v3 = c47v0.Id
                            c47v1 = c47v2 .. c47v3
                            c47v2 = function(c40v0)
                              local c40v1, c40v2, c40v3
                              local __renovice_state_0 = 0
                              local __renovice_local_0 = v15
                              if __renovice_local_0 == nil then
                                __renovice_state_0 = 2
                              else
                                __renovice_state_0 = 1
                              end
                              if __renovice_state_0 == 1 then
                                __renovice_local_0 = v15
                                __renovice_local_0 = __renovice_local_0.Id
                                c40v1 = c47v0
                                c40v1 = c40v1.Id
                                if __renovice_local_0 == c40v1 then
                                  __renovice_state_0 = 3
                                else
                                  __renovice_state_0 = 2
                                end
                              end
                              if __renovice_state_0 == 2 then
                                __renovice_local_0 = v12
                                c40v3 = c47v0
                                c40v3 = c40v3.Id
                                c40v2 = tonumber
                                c40v2 = c40v2(c40v3)
                                __renovice_local_0:FocusElementById(c40v2)
                                __renovice_state_0 = 3
                              end
                              if __renovice_state_0 == 3 then
                                c40v1 = c47v0
                                c40v1 = c40v1.mIconGrid
                                __renovice_local_0 = IsNull
                                __renovice_local_0 = __renovice_local_0(c40v1)
                                if __renovice_local_0 then
                                  __renovice_state_0 = 5
                                else
                                  __renovice_state_0 = 4
                                end
                              end
                              if __renovice_state_0 == 4 then
                                __renovice_local_0 = c47v0
                                __renovice_local_0 = __renovice_local_0.mIconGrid
                                c40v2 = tonumber
                                c40v2 = c40v2(c40v0)
                                __renovice_local_0:FocusElementById(c40v2)
                                __renovice_state_0 = 5
                              end
                              if __renovice_state_0 == 5 then
                                do return end
                              end
                              do return end
                            end
                            __renovice_local_1[c47v1] = c47v2
                            c47v2 = "IconUnfocused"
                            c47v3 = c47v0.Id
                            c47v1 = c47v2 .. c47v3
                            c47v2 = function(c41v0)
                              local c41v1, c41v2, c41v3
                              c41v2 = c47v0
                              c41v2 = c41v2.mIconGrid
                              c41v1 = IsNull
                              c41v1 = c41v1(c41v2)
                              if not c41v1 then
                                c41v1 = c47v0
                                c41v1 = c41v1.mIconGrid
                                c41v3 = tonumber
                                c41v3 = c41v3(c41v0)
                                c41v1:UnfocusElementById(c41v3)
                              end
                              do return end
                            end
                            __renovice_local_1[c47v1] = c47v2
                            c47v2 = "IconPressed"
                            c47v3 = c47v0.Id
                            c47v1 = c47v2 .. c47v3
                            c47v2 = function(c42v0)
                              local c42v1, c42v2, c42v3
                              c42v2 = c47v0
                              c42v2 = c42v2.mIconGrid
                              c42v1 = IsNull
                              c42v1 = c42v1(c42v2)
                              if not c42v1 then
                                c42v1 = c47v0
                                c42v1 = c42v1.mIconGrid
                                c42v3 = tonumber
                                c42v3 = c42v3(c42v0)
                                c42v1:SelectElementById(c42v3)
                                c42v1 = v1
                                c42v1 = c42v1.PlaySound
                                c42v2 = _G
                                c42v2 = c42v2.UISound_Select
                                c42v1(c42v2)
                              end
                              do return end
                            end
                            __renovice_local_1[c47v1] = c47v2
                            c47v1 = require
                            c47v2 = "EE.Interface.Components.Grid"
                            c47v1 = c47v1(c47v2)
                            c47v2 = c47v1.CreateGrid
                            c47v3 = mMovie
                            c47v5 = c47v0.mClipName
                            c47v6 = ".IconElement"
                            c47v4 = c47v5 .. c47v6
                            c47v5 = nil
                            c47v6 = c47v0.mColumns
                            c47v7 = c47v0.mRows
                            c47v2 = c47v2(c47v3, c47v4, c47v5, c47v6, c47v7)
                            c47v0.mIconGrid = c47v2
                            c47v2 = c47v0.mIconGrid
                            c47v5 = "IconPressed"
                            c47v6 = c47v0.Id
                            c47v4 = c47v5 .. c47v6
                            c47v6 = "IconFocused"
                            c47v7 = c47v0.Id
                            c47v5 = c47v6 .. c47v7
                            c47v7 = "IconUnfocused"
                            c47v8 = c47v0.Id
                            c47v6 = c47v7 .. c47v8
                            c47v2:SetCallbacks(c47v4, c47v5, c47v6)
                            c47v2 = c47v0.mIconGrid
                            c47v3 = 42
                            c47v2.mColumnSeparation = c47v3
                            c47v2 = c47v0.mIconGrid
                            c47v3 = 42
                            c47v2.mRowSeparation = c47v3
                            c47v2 = c47v0.mIconGrid
                            c47v3 = function(c43v0)
                              local c43v1, c43v2, c43v3, c43v4, c43v5, c43v6, c43v7, c43v8
                              c43v1 = c43v0.mIndex
                              c43v2 = c47v0
                              c43v2 = c43v2.mIconGrid
                              c43v2 = c43v2.mSelectedIndex
                              if c43v1 ~= c43v2 then
                                c43v1 = mMovie
                                c43v4 = c43v0.mClipName
                                c43v5 = ".Btn"
                                c43v3 = c43v4 .. c43v5
                                c43v4 = "RectEdgeColor"
                                c43v5 = v27
                                c43v5 = c43v5.FloatingContentHighlightProcedural
                                c43v5 = c43v5.r
                                c43v6 = v27
                                c43v6 = c43v6.FloatingContentHighlightProcedural
                                c43v6 = c43v6.g
                                c43v7 = v27
                                c43v7 = c43v7.FloatingContentHighlightProcedural
                                c43v7 = c43v7.b
                                c43v8 = 0.5
                                c43v1:Name__48ecbbab(c43v3, c43v4, c43v5, c43v6, c43v7, c43v8)
                              end
                              do return end
                            end
                            c47v2.mOnFocusedCallback = c47v3
                            c47v2 = c47v0.mIconGrid
                            c47v3 = function(c44v0)
                              local c44v1, c44v2, c44v3, c44v4, c44v5, c44v6, c44v7, c44v8
                              c44v1 = c44v0.mIndex
                              c44v2 = c47v0
                              c44v2 = c44v2.mIconGrid
                              c44v2 = c44v2.mSelectedIndex
                              if c44v1 ~= c44v2 then
                                c44v1 = mMovie
                                c44v4 = c44v0.mClipName
                                c44v5 = ".Btn"
                                c44v3 = c44v4 .. c44v5
                                c44v4 = "RectEdgeColor"
                                c44v5 = 0
                                c44v6 = 0
                                c44v7 = 0
                                c44v8 = 0
                                c44v1:Name__48ecbbab(c44v3, c44v4, c44v5, c44v6, c44v7, c44v8)
                              end
                              do return end
                            end
                            c47v2.mOnUnfocusedCallback = c47v3
                            c47v2 = c47v0.mIconGrid
                            c47v3 = function(c45v0)
                              local c45v1, c45v2, c45v3, c45v4, c45v5, c45v6, c45v7, c45v8
                              c45v1 = c47v0
                              c45v1 = c45v1.mIconGrid
                              c45v1 = c45v1.mSelectedIndex
                              if c45v1 ~= nil then
                                c45v1 = mMovie
                                c45v6 = c47v0
                                c45v6 = c45v6.mIconGrid
                                c45v6 = c45v6.mElements
                                c45v7 = c47v0
                                c45v7 = c45v7.mIconGrid
                                c45v7 = c45v7.mSelectedIndex
                                c45v4 = c45v6[c45v7]
                                c45v4 = c45v4.mClipName
                                c45v5 = ".Btn"
                                c45v3 = c45v4 .. c45v5
                                c45v4 = "RectEdgeColor"
                                c45v5 = 0
                                c45v6 = 0
                                c45v7 = 0
                                c45v8 = 0
                                c45v1:Name__48ecbbab(c45v3, c45v4, c45v5, c45v6, c45v7, c45v8)
                                c45v1 = c47v0
                                c45v1 = c45v1.mIconGrid
                                c45v1 = c45v1.mSelectedIndex
                                c45v2 = c45v0.mIndex
                                if c45v1 ~= c45v2 then
                                  c45v1 = v60
                                  c45v1()
                                end
                              end
                              c45v1 = c47v0
                              c45v1 = c45v1.mIconGrid
                              c45v2 = c45v0.mIndex
                              c45v1.mSelectedIndex = c45v2
                              c45v1 = mMovie
                              c45v4 = c45v0.mClipName
                              c45v5 = ".Btn"
                              c45v3 = c45v4 .. c45v5
                              c45v4 = "RectEdgeColor"
                              c45v5 = v27
                              c45v5 = c45v5.FloatingContentHighlightProcedural
                              c45v5 = c45v5.r
                              c45v6 = v27
                              c45v6 = c45v6.FloatingContentHighlightProcedural
                              c45v6 = c45v6.g
                              c45v7 = v27
                              c45v7 = c45v7.FloatingContentHighlightProcedural
                              c45v7 = c45v7.b
                              c45v8 = 0.75
                              c45v1:Name__48ecbbab(c45v3, c45v4, c45v5, c45v6, c45v7, c45v8)
                              do return end
                            end
                            c47v2.mOnSelectedCallback = c47v3
                            c47v2 = c47v0.mIconGrid
                            c47v3 = function(c46v0)
                              local c46v1, c46v2, c46v3, c46v4, c46v5, c46v6, c46v7
                              c46v1 = mMovie
                              c46v3 = c46v0.mClipName
                              c46v4 = ".Btn"
                              c46v2 = c46v3 .. c46v4
                              c46v3 = _G
                              c46v3 = c46v3.UIMaterial_RectangleNoDepth
                              c46v1:OverrideMaterial(c46v2, c46v3)
                              c46v1 = mMovie
                              c46v3 = c46v0.mClipName
                              c46v4 = ".Icon"
                              c46v2 = c46v3 .. c46v4
                              c46v3 = c46v0.Icon
                              c46v1:OverrideTexture(c46v2, c46v3)
                              c46v1 = mMovie
                              c46v2 = c46v0.mClipName
                              c46v3 = "Icon"
                              c46v4 = 11
                              c46v5 = v27
                              c46v5 = c46v5.Content
                              c46v1:Name__82f6549c(c46v2, c46v3, c46v4, c46v5)
                              c46v1 = mMovie
                              c46v3 = c46v0.mClipName
                              c46v4 = ".Btn"
                              c46v2 = c46v3 .. c46v4
                              c46v3 = "RectInnerColor"
                              c46v4 = 0
                              c46v5 = 0
                              c46v6 = 0
                              c46v7 = 0
                              c46v1:Name__48ecbbab(c46v2, c46v3, c46v4, c46v5, c46v6, c46v7)
                              c46v1 = mMovie
                              c46v3 = c46v0.mClipName
                              c46v4 = ".Btn"
                              c46v2 = c46v3 .. c46v4
                              c46v3 = "RectEdgeColor"
                              c46v4 = 0
                              c46v5 = 0
                              c46v6 = 0
                              c46v7 = 0
                              c46v1:Name__48ecbbab(c46v2, c46v3, c46v4, c46v5, c46v6, c46v7)
                              do return end
                            end
                            c47v2.mElementDrawCallback = c47v3
                            c47v4 = 1
                            c47v5 = c47v0.mIcons
                            c47v2 = #c47v5
                            c47v3 = 1
                            for __renovice_for_1_0 = c47v4, c47v2, c47v3 do
                              c47v5 = c47v0.mIconGrid
                              c47v7 = {}
                              c47v10 = c47v0.mIcons
                              c47v9 = c47v10[__renovice_for_1_0]
                              c47v7.Icon = c47v9
                              c47v8 = true
                              c47v7[1] = c47v8
                              c47v5:AddElement(c47v7)
                            end
                            c47v2 = c47v0.mIconGrid
                            c47v4 = nil
                            c47v5 = true
                            c47v6 = true
                            c47v2:Redraw(c47v4, c47v5, c47v6)
                            c47v2 = c47v0.mStartIndex
                            if c47v2 ~= nil then
                              c47v2 = c47v0.mStartIndex
                              c47v3 = c47v0.mIconGrid
                              c47v3 = c47v3:GetHowManyElements()
                              if c47v2 <= c47v3 then
                                c47v2 = c47v0.mIconGrid
                                c47v5 = c47v0.mStartIndex
                                c47v4 = tonumber
                                c47v4 = c47v4(c47v5)
                                c47v2:SelectElement(c47v4)
                              end
                            end
                          end
                        else
                          __renovice_local_0 = c47v0.mType
                          __renovice_local_1 = v0
                          __renovice_local_1 = __renovice_local_1.CHOICE
                          if __renovice_local_0 == __renovice_local_1 then
                            __renovice_local_0 = FlashMethod
                            __renovice_local_1 = mMovie
                            c47v2 = c47v0.mClipName
                            c47v3 = ".gotoAndStop"
                            c47v1 = c47v2 .. c47v3
                            c47v2 = "Choice"
                            __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                            __renovice_local_0 = mMovie
                            c47v1 = "<CHECKMARK_OUTLINE>"
                            c47v2 = true
                            __renovice_local_0 = __renovice_local_0:GetLocalized(c47v1, c47v2)
                            __renovice_local_1 = v8
                            __renovice_local_1 = __renovice_local_1.Create__e256561c
                            c47v1 = mMovie
                            c47v3 = c47v0.mClipName
                            c47v4 = ".YesBtn"
                            c47v2 = c47v3 .. c47v4
                            c47v5 = " "
                            c47v7 = c47v0.mButtonValues
                            c47v6 = c47v7[1]
                            c47v6 = c47v6.mLabel
                            c47v3 = __renovice_local_0 .. c47v5 .. c47v6
                            c47v4 = "YesButton"
                            c47v5 = nil
                            c47v6 = nil
                            c47v7 = true
                            __renovice_local_1 = __renovice_local_1(c47v1, c47v2, c47v3, c47v4, c47v5, c47v6, c47v7)
                            c47v0.YesBtn = __renovice_local_1
                            __renovice_local_1 = c47v0.YesBtn
                            c47v2 = c47v0.mButtonValues
                            c47v1 = c47v2[1]
                            c47v1 = c47v1.mLabel
                            __renovice_local_1.mBaseLabel = c47v1
                            __renovice_local_1 = v8
                            __renovice_local_1 = __renovice_local_1.Create__e256561c
                            c47v1 = mMovie
                            c47v3 = c47v0.mClipName
                            c47v4 = ".NoBtn"
                            c47v2 = c47v3 .. c47v4
                            c47v5 = " "
                            c47v7 = c47v0.mButtonValues
                            c47v6 = c47v7[2]
                            c47v6 = c47v6.mLabel
                            c47v3 = __renovice_local_0 .. c47v5 .. c47v6
                            c47v4 = "NoButton"
                            c47v5 = nil
                            c47v6 = nil
                            c47v7 = true
                            __renovice_local_1 = __renovice_local_1(c47v1, c47v2, c47v3, c47v4, c47v5, c47v6, c47v7)
                            c47v0.NoBtn = __renovice_local_1
                            __renovice_local_1 = c47v0.NoBtn
                            c47v2 = c47v0.mButtonValues
                            c47v1 = c47v2[2]
                            c47v1 = c47v1.mLabel
                            __renovice_local_1.mBaseLabel = c47v1
                            __renovice_local_1 = c47v0.YesBtn
                            __renovice_local_1.Parent = c47v0
                            __renovice_local_1 = c47v0.NoBtn
                            __renovice_local_1.Parent = c47v0
                            __renovice_local_1 = v1
                            __renovice_local_1 = __renovice_local_1.Ternary
                            c47v2 = c47v0.mWidth
                            if c47v2 == nil then
                              c47v1 = false
                            else
                              c47v1 = true
                            end
                            c47v2 = c47v0.mWidth
                            c47v3 = 800
                            __renovice_local_1 = __renovice_local_1(c47v1, c47v2, c47v3)
                            c47v1 = __renovice_local_1 * 0.6
                            c47v2 = v1
                            c47v2 = c47v2.Ternary
                            c47v4 = c47v0.mButtonSpacing
                            if c47v4 == nil then
                              c47v3 = false
                            else
                              c47v3 = true
                            end
                            c47v4 = c47v0.mButtonSpacing
                            c47v5 = 0
                            c47v2 = c47v2(c47v3, c47v4, c47v5)
                            c47v3 = 0
                            c47v4 = mMovie
                            c47v6 = c47v0.mClipName
                            c47v7 = "Label"
                            c47v8 = 52
                            c47v9 = c47v0.mMultiLine
                            c47v4:Name__e375fc94(c47v6, c47v7, c47v8, c47v9)
                            c47v4 = mMovie
                            c47v6 = c47v0.mClipName
                            c47v7 = "Btn"
                            c47v8 = 14
                            c47v4:Name__82f6549c(c47v6, c47v7, c47v8, __renovice_local_1)
                            c47v4 = mMovie
                            c47v6 = c47v0.mClipName
                            c47v7 = "Bg"
                            c47v8 = 14
                            c47v4:Name__82f6549c(c47v6, c47v7, c47v8, __renovice_local_1)
                            c47v4 = mMovie
                            c47v6 = c47v0.mClipName
                            c47v7 = "Label"
                            c47v8 = 14
                            c47v4:Name__82f6549c(c47v6, c47v7, c47v8, c47v1)
                            c47v4 = ipairs
                            c47v7 = c47v0.YesBtn
                            c47v8 = c47v0.NoBtn
                            c47v5 = {c47v7, c47v8}
                            c47v4, c47v5, c47v6 = c47v4(c47v5)
                            for __renovice_for_2_0, __renovice_for_2_1 in c47v4, c47v5, c47v6 do
                              c47v9 = "center"
                              __renovice_for_2_1.mAlignment = c47v9
                              __renovice_for_2_1:Redraw()
                              c47v10 = mMovie
                              c47v13 = __renovice_for_2_1.mClipName
                              c47v14 = ".Label"
                              c47v12 = c47v13 .. c47v14
                              c47v13 = 40
                              c47v10 = c47v10:GetNumberVariable(c47v12, c47v13)
                              c47v11 = v1
                              c47v11 = c47v11.Ternary
                              c47v12 = Engine.IsPlayingWithController
                              c47v12 = c47v12()
                              c47v13 = 45
                              c47v14 = 20
                              c47v11 = c47v11(c47v12, c47v13, c47v14)
                              c47v9 = c47v10 + c47v11
                              c47v12 = c47v3 * c47v2
                              c47v11 = c47v1 + c47v12
                              c47v10 = c47v11 + c47v9
                              __renovice_for_2_1:SetPosition(c47v10)
                              c47v3 = c47v3 + 1
                            end
                          else
                            __renovice_local_0 = c47v0.mType
                            __renovice_local_1 = v0
                            __renovice_local_1 = __renovice_local_1.CHECKMARK
                            if __renovice_local_0 == __renovice_local_1 then
                              __renovice_local_0 = Engine.IsMobile
                              __renovice_local_0 = __renovice_local_0()
                              if __renovice_local_0 then
                                __renovice_local_0 = FlashMethod
                                __renovice_local_1 = mMovie
                                c47v2 = c47v0.mClipName
                                c47v3 = ".gotoAndStop"
                                c47v1 = c47v2 .. c47v3
                                c47v2 = "Choice"
                                __renovice_local_0(__renovice_local_1, c47v1, c47v2)
                                __renovice_local_0 = mMovie
                                c47v1 = "<CHECKMARK_OUTLINE>"
                                c47v2 = true
                                __renovice_local_0 = __renovice_local_0:GetLocalized(c47v1, c47v2)
                                __renovice_local_1 = v8
                                __renovice_local_1 = __renovice_local_1.Create__e256561c
                                c47v1 = mMovie
                                c47v3 = c47v0.mClipName
                                c47v4 = ".YesBtn"
                                c47v2 = c47v3 .. c47v4
                                c47v5 = "ACCEPT"
                                c47v3 = __renovice_local_0 .. c47v5
                                c47v4 = "CheckmarkButton"
                                c47v5 = nil
                                c47v6 = nil
                                c47v7 = false
                                __renovice_local_1 = __renovice_local_1(c47v1, c47v2, c47v3, c47v4, c47v5, c47v6, c47v7)
                                c47v0.YesBtn = __renovice_local_1
                                __renovice_local_1 = c47v0.YesBtn
                                c47v1 = "ACCEPT"
                                __renovice_local_1.mBaseLabel = c47v1
                                __renovice_local_1 = c47v0.YesBtn
                                __renovice_local_1.Parent = c47v0
                                __renovice_local_1 = c47v0.YesBtn
                                c47v1 = false
                                __renovice_local_1.mShowUnderline2 = c47v1
                                __renovice_local_1 = c47v0.YesBtn
                                c47v1 = false
                                __renovice_local_1.mShowBacker = c47v1
                                __renovice_local_1 = nil
                                c47v0.NoBtn = __renovice_local_1
                                __renovice_local_1 = mMovie
                                c47v3 = c47v0.mClipName
                                c47v4 = ".NoBtn"
                                c47v2 = c47v3 .. c47v4
                                c47v3 = 13
                                c47v4 = false
                                __renovice_local_1:Name__863e56e7(c47v2, c47v3, c47v4)
                                __renovice_local_1 = v1
                                __renovice_local_1 = __renovice_local_1.Ternary
                                c47v2 = c47v0.mWidth
                                if c47v2 == nil then
                                  c47v1 = false
                                else
                                  c47v1 = true
                                end
                                c47v2 = c47v0.mWidth
                                c47v3 = 800
                                __renovice_local_1 = __renovice_local_1(c47v1, c47v2, c47v3)
                                c47v1 = __renovice_local_1 * 0.6
                                c47v2 = v1
                                c47v2 = c47v2.Ternary
                                c47v4 = c47v0.mButtonSpacing
                                if c47v4 == nil then
                                  c47v3 = false
                                else
                                  c47v3 = true
                                end
                                c47v4 = c47v0.mButtonSpacing
                                c47v5 = 0
                                c47v2 = c47v2(c47v3, c47v4, c47v5)
                                c47v3 = mMovie
                                c47v5 = c47v0.mClipName
                                c47v6 = "Label"
                                c47v7 = 52
                                c47v8 = c47v0.mMultiLine
                                c47v3:Name__e375fc94(c47v5, c47v6, c47v7, c47v8)
                                c47v3 = mMovie
                                c47v5 = c47v0.mClipName
                                c47v6 = "Btn"
                                c47v7 = 14
                                c47v3:Name__82f6549c(c47v5, c47v6, c47v7, __renovice_local_1)
                                c47v3 = mMovie
                                c47v5 = c47v0.mClipName
                                c47v6 = "Bg"
                                c47v7 = 14
                                c47v3:Name__82f6549c(c47v5, c47v6, c47v7, __renovice_local_1)
                                c47v3 = mMovie
                                c47v5 = c47v0.mClipName
                                c47v6 = "Label"
                                c47v7 = 14
                                c47v3:Name__82f6549c(c47v5, c47v6, c47v7, c47v1)
                                c47v3 = c47v0.YesBtn
                                c47v4 = "center"
                                c47v3.mAlignment = c47v4
                                c47v3:Redraw()
                                c47v5 = mMovie
                                c47v8 = c47v3.mClipName
                                c47v9 = ".Label"
                                c47v7 = c47v8 .. c47v9
                                c47v8 = 40
                                c47v5 = c47v5:GetNumberVariable(c47v7, c47v8)
                                c47v6 = v1
                                c47v6 = c47v6.Ternary
                                c47v7 = Engine.IsPlayingWithController
                                c47v7 = c47v7()
                                c47v8 = 45
                                c47v9 = 20
                                c47v6 = c47v6(c47v7, c47v8, c47v9)
                                c47v4 = c47v5 + c47v6
                                c47v7 = c47v2 / 2
                                c47v6 = c47v1 + c47v7
                                c47v5 = c47v6 + c47v4
                                c47v3:SetPosition(c47v5)
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
      __renovice_local_0 = mMovie
      c47v2 = c47v0.mClipName
      c47v3 = ".Lock"
      c47v1 = c47v2 .. c47v3
      c47v2 = 13
      c47v4 = c47v0.mLocked
      c47v3 = c47v4 or false
      __renovice_local_0:Name__863e56e7(c47v1, c47v2, c47v3)
      __renovice_local_0 = c47v0.mLocked
      if __renovice_local_0 then
        __renovice_local_0 = mMovie
        c47v2 = c47v0.mClipName
        c47v3 = ".Lock"
        c47v1 = c47v2 .. c47v3
        c47v2 = lockIcon
        __renovice_local_0:OverrideTexture(c47v1, c47v2)
        __renovice_local_0 = mMovie
        c47v2 = c47v0.mClipName
        c47v3 = ".Lock"
        c47v1 = c47v2 .. c47v3
        c47v2 = 11
        c47v3 = v27
        c47v3 = c47v3.FloatingContent
        __renovice_local_0:SetNumberVariable(c47v1, c47v2, c47v3)
        __renovice_local_0 = mMovie
        c47v1 = c47v0.mClipName
        c47v2 = "Label"
        c47v3 = 12
        c47v4 = 60
        __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
      end
      __renovice_local_0 = mMovie
      c47v2 = c47v0.mClipName
      c47v3 = ".Btn"
      c47v1 = c47v2 .. c47v3
      c47v2 = 99
      c47v3 = c47v0.Id
      __renovice_local_0:SetNumberVariable(c47v1, c47v2, c47v3)
      __renovice_local_0 = mMovie
      c47v2 = c47v0.mClipName
      c47v3 = ".Btn"
      c47v1 = c47v2 .. c47v3
      c47v2 = v12
      c47v2 = c47v2.mRollOverElementCallback
      c47v3 = v12
      c47v3 = c47v3.mRollOutElementCallback
      c47v4 = v12
      c47v4 = c47v4.mSelectElementCallback
      c47v5 = v12
      c47v5 = c47v5.mPressElementCallback
      __renovice_local_0:SetCallbacks(c47v1, c47v2, c47v3, c47v4, c47v5)
      __renovice_local_0 = mMovie
      c47v2 = c47v0.mClipName
      c47v3 = ".Bg"
      c47v1 = c47v2 .. c47v3
      c47v2 = _G
      c47v2 = c47v2.UIMaterial_RectangleNoDepth
      __renovice_local_0:OverrideMaterial(c47v1, c47v2)
      __renovice_local_0 = mMovie
      c47v2 = c47v0.mClipName
      c47v3 = ".Bg"
      c47v1 = c47v2 .. c47v3
      c47v2 = "RectInnerColor"
      c47v3 = v27
      c47v3 = c47v3.BackgroundProcedural
      c47v3 = c47v3.r
      c47v4 = v27
      c47v4 = c47v4.BackgroundProcedural
      c47v4 = c47v4.g
      c47v5 = v27
      c47v5 = c47v5.BackgroundProcedural
      c47v5 = c47v5.b
      c47v6 = 1
      __renovice_local_0:Name__48ecbbab(c47v1, c47v2, c47v3, c47v4, c47v5, c47v6)
      __renovice_local_0 = c47v0.mLabel
      if __renovice_local_0 ~= nil then
        __renovice_local_0 = c47v0.mSkipLocalize
        if __renovice_local_0 then
          __renovice_local_0 = mMovie
          c47v1 = c47v0.mClipName
          c47v2 = "Label"
          c47v3 = 36
          c47v4 = c47v0.mLabel
          __renovice_local_0:Name__34a7a1c9(c47v1, c47v2, c47v3, c47v4)
        else
          __renovice_local_0 = mMovie
          c47v2 = c47v0.mClipName
          c47v3 = ".Label.text"
          c47v1 = c47v2 .. c47v3
          c47v2 = c47v0.mLabel
          __renovice_local_0:SetLocalized(c47v1, c47v2)
        end
      end
      __renovice_local_0 = mMovie
      c47v1 = c47v0.mClipName
      c47v2 = "Label"
      c47v3 = 44
      c47v4 = v27
      c47v4 = c47v4.FloatingContent
      __renovice_local_0:Name__82f6549c(c47v1, c47v2, c47v3, c47v4)
      __renovice_local_0 = mMovie
      c47v1 = c47v0.mClipName
      c47v2 = "Label"
      c47v3 = 40
      __renovice_local_0 = __renovice_local_0:Name__fd1f2935(c47v1, c47v2, c47v3)
      c47v0.mTextWidth = __renovice_local_0
      __renovice_local_0 = mMovie
      c47v2 = c47v0.mClipName
      c47v3 = ".Label"
      c47v1 = c47v2 .. c47v3
      c47v2 = "ShowHyperlinkItem"
      __renovice_local_0:Name__aee43a08(c47v1, c47v2)
      __renovice_local_0 = c47v0.mFocused
      if not __renovice_local_0 then
        __renovice_local_0 = v12
        __renovice_local_0 = __renovice_local_0.mOnUnfocusedCallback
        __renovice_local_0(c47v0)
        do return end
      end
      __renovice_local_0 = v12
      __renovice_local_0 = __renovice_local_0.mOnFocusedCallback
      __renovice_local_0(c47v0)
      do return end
    end
    c55v1.mElementDrawCallback = c55v2
    c55v1 = v12
    c55v2 = function(c48v0, c48v1)
      local c48v2, c48v3, c48v4, c48v5, c48v6, c48v7, c48v8, c48v9, c48v10, c48v11, c48v12, c48v13, c48v14, c48v15
      local __renovice_state_0 = 0
      c48v2 = 0
      c48v3 = IsNull
      c48v3 = c48v3(c48v1)
      if c48v3 then
        __renovice_state_0 = 2
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c48v4 = c48v1.mClipName
        c48v3 = IsNull
        c48v3 = c48v3(c48v4)
        if not c48v3 then
          __renovice_state_0 = 3
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        do return c48v2 end
      end
      if __renovice_state_0 == 3 then
        c48v4 = c48v1.mHeight
        c48v3 = IsNull
        c48v3 = c48v3(c48v4)
        if c48v3 then
          __renovice_state_0 = 5
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c48v2 = c48v1.mHeight
        do return c48v2 end
      end
      if __renovice_state_0 == 5 then
        c48v3 = c48v1.mType
        c48v4 = v0
        c48v4 = c48v4.TITLE
        if c48v3 ~= c48v4 then
          __renovice_state_0 = 11
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        c48v3 = c48v1.mMultiLine
        if c48v3 ~= true then
          __renovice_state_0 = 11
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        c48v4 = mMovie
        c48v7 = c48v1.mClipName
        c48v8 = ".Label"
        c48v6 = c48v7 .. c48v8
        c48v7 = 41
        c48v4 = c48v4:GetNumberVariable(c48v6, c48v7)
        c48v3 = c48v4 + 20
        c48v4 = v1
        c48v4 = c48v4.Ternary
        c48v6 = c48v1.mVerticalPadding
        if c48v6 ~= nil then
          __renovice_state_0 = 9
        else
          __renovice_state_0 = 8
        end
      end
      if __renovice_state_0 == 8 then
        c48v5 = false
        __renovice_state_0 = 10
      end
      if __renovice_state_0 == 9 then
        c48v5 = true
        __renovice_state_0 = 10
      end
      if __renovice_state_0 == 10 then
        c48v6 = c48v1.mVerticalPadding
        c48v7 = 0
        c48v4 = c48v4(c48v5, c48v6, c48v7)
        c48v2 = c48v3 + c48v4
        do return c48v2 end
      end
      if __renovice_state_0 == 11 then
        c48v3 = c48v1.mType
        c48v4 = v0
        c48v4 = c48v4.INPUTBOX
        if c48v3 ~= c48v4 then
          __renovice_state_0 = 14
        else
          __renovice_state_0 = 12
        end
      end
      if __renovice_state_0 == 12 then
        c48v3 = c48v1.mMultiLine
        if c48v3 ~= false then
          __renovice_state_0 = 14
        else
          __renovice_state_0 = 13
        end
      end
      if __renovice_state_0 == 13 then
        c48v2 = 80
        do return c48v2 end
      end
      if __renovice_state_0 == 14 then
        c48v3 = c48v1.mType
        c48v4 = v0
        c48v4 = c48v4.IMAGE
        if c48v3 ~= c48v4 then
          __renovice_state_0 = 16
        else
          __renovice_state_0 = 15
        end
      end
      if __renovice_state_0 == 15 then
        c48v3 = mMovie
        c48v6 = c48v1.mClipName
        c48v7 = ".Image"
        c48v5 = c48v6 .. c48v7
        c48v6 = 15
        c48v2 = c48v3:GetNumberVariable(c48v5, c48v6)
        do return c48v2 end
      end
      if __renovice_state_0 == 16 then
        c48v3 = c48v1.mType
        c48v4 = v0
        c48v4 = c48v4.CHOICE
        if c48v3 ~= c48v4 then
          __renovice_state_0 = 18
        else
          __renovice_state_0 = 17
        end
      end
      if __renovice_state_0 == 17 then
        c48v3 = c48v1.mMultiLine
        if c48v3 == true then
          __renovice_state_0 = 21
        else
          __renovice_state_0 = 18
        end
      end
      if __renovice_state_0 == 18 then
        c48v3 = c48v1.mType
        c48v4 = v0
        c48v4 = c48v4.CHECKMARK
        if c48v3 ~= c48v4 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 19
        end
      end
      if __renovice_state_0 == 19 then
        c48v3 = c48v1.mMultiLine
        if c48v3 ~= true then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 20
        end
      end
      if __renovice_state_0 == 20 then
        c48v3 = Engine.IsMobile
        c48v3 = c48v3()
        if not c48v3 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 21
        end
      end
      if __renovice_state_0 == 21 then
        local __renovice_state_1 = -1
        c48v3 = mMovie
        c48v6 = c48v1.mClipName
        c48v7 = ".Label"
        c48v5 = c48v6 .. c48v7
        c48v6 = 41
        c48v3 = c48v3:GetNumberVariable(c48v5, c48v6)
        c48v2 = c48v3 + 20
        c48v3 = mMovie
        c48v5 = c48v1.mClipName
        c48v6 = "Btn"
        c48v7 = 15
        c48v3:Name__82f6549c(c48v5, c48v6, c48v7, c48v2)
        c48v3 = mMovie
        c48v5 = c48v1.mClipName
        c48v6 = "Bg"
        c48v7 = 15
        c48v3:Name__82f6549c(c48v5, c48v6, c48v7, c48v2)
        c48v3 = ipairs
        c48v6 = c48v1.YesBtn
        c48v7 = c48v1.NoBtn
        c48v4 = {c48v6, c48v7}
        c48v3, c48v4, c48v5 = c48v3(c48v4)
        for __renovice_for_0_0, __renovice_for_0_1 in c48v3, c48v4, c48v5 do
          c48v8 = mMovie
          c48v11 = __renovice_for_0_1.mClipName
          c48v12 = ".Label"
          c48v10 = c48v11 .. c48v12
          c48v11 = 41
          c48v8 = c48v8:GetNumberVariable(c48v10, c48v11)
          c48v11 = c48v2 * 0.5
          c48v10 = c48v11 - 15
          c48v9 = c48v10 - c48v8
          c48v10 = Engine.IsMobile
          c48v10 = c48v10()
          if c48v10 then
            c48v10 = mMovie
            c48v12 = __renovice_for_0_1.mClipName
            c48v13 = 1
            c48v15 = v50
            c48v15 = c48v15.CheckboxY
            c48v14 = c48v9 + c48v15
            c48v10:SetNumberVariable(c48v12, c48v13, c48v14)
            continue
          end
          c48v10 = mMovie
          c48v12 = __renovice_for_0_1.mClipName
          c48v13 = 1
          c48v10:SetNumberVariable(c48v12, c48v13, c48v9)
        end
        if __renovice_state_1 == -1 then __renovice_state_1 = 26 end
        if __renovice_state_1 == 26 then
          __renovice_state_0 = 26
        end
      end
      if __renovice_state_0 == 26 then
        do return c48v2 end
      end
      if __renovice_state_0 == 27 then
        c48v3 = v47
        c48v4 = c48v1.mType
        c48v2 = c48v3[c48v4]
        do return c48v2 end
      end
      do return end
    end
    c55v1.CalculateHeight = c55v2
    c55v1 = v12
    c55v2 = function(c49v0, c49v1)
      local c49v2, c49v3, c49v4, c49v5, c49v6, c49v7
      c49v2 = 0
      c49v4 = c49v1.mWidth
      c49v3 = IsNull
      c49v3 = c49v3(c49v4)
      if not c49v3 then
        c49v2 = c49v1.mWidth
      else
        c49v2 = 800
      end
      c49v3 = mMovie
      c49v5 = "Container.Scrollbar"
      c49v6 = 13
      c49v3 = c49v3:Name__a0674cc3(c49v5, c49v6)
      c49v4 = v1
      c49v4 = c49v4.Ternary
      c49v6 = 20
      c49v7 = 0
      c49v4 = c49v4(c49v3, c49v6, c49v7)
      c49v2 = c49v2 + c49v4
      do return c49v2 end
    end
    c55v1.CalculateWidth = c55v2
    c55v1 = v12
    c55v2 = v12
    c55v2 = c55v2.CalculateX
    c55v1._GenericSettings_CalculateX = c55v2
    c55v1 = v12
    c55v2 = function(c50v0, c50v1)
      local c50v2, c50v3
      c50v3 = c50v1.mOffsetX
      c50v2 = IsNull
      c50v2 = c50v2(c50v3)
      if not c50v2 then
        c50v2 = c50v1.mOffsetX
        do return c50v2 end
      end
      c50v2 = v12
      c50v2 = c50v2:_GenericSettings_CalculateX(c50v1)
      do return c50v2 end
    end
    c55v1.CalculateX = c55v2
    c55v1 = v12
    c55v2 = v12
    c55v2 = c55v2.CalculateY
    c55v1._GenericSettings_CalculateY = c55v2
    c55v1 = v12
    c55v2 = function(c51v0, c51v1)
      local c51v2, c51v3, c51v4, c51v5, c51v6, c51v7, c51v8, c51v9
      c51v2 = c51v0.UniformElementHeights
      if c51v2 then
        do return c51v0:_GenericSettings_CalculateY(c51v1) end
      end
      c51v4 = c51v1.Id
      c51v2 = c51v0:GetElementIndexById(c51v4)
      c51v3 = IsNull
      c51v3 = c51v3(c51v2)
      if c51v3 then
        c51v3 = c51v0.mInitialY
        do return c51v3 end
      end
      c51v3 = 1
      c51v5 = c51v0.mScroll
      c51v4 = IsNull
      c51v4 = c51v4(c51v5)
      if not c51v4 then
        c51v5 = c51v0.mScroll
        c51v4 = math.floor
        c51v3 = c51v4(c51v5)
      end
      c51v4 = 0
      c51v7 = c51v3
      c51v5 = c51v2 - 1
      c51v6 = 1
      for __renovice_for_0_0 = c51v7, c51v5, c51v6 do
        c51v8 = v12
        c51v8 = c51v8:GetElementById(__renovice_for_0_0)
        c51v9 = v12
        c51v9 = c51v9:CalculateHeight(c51v8)
        c51v4 = c51v4 + c51v9
      end
      c51v6 = c51v0.mInitialY
      c51v5 = c51v6 + c51v4
      do return c51v5 end
    end
    c55v1.CalculateY = c55v2
    c55v1 = v12
    c55v2 = v12
    c55v2 = c55v2.CalculateScrollBarHeight
    c55v1._GenericSettings_CalculateScrollBarHeight = c55v2
    c55v1 = v12
    c55v2 = function(c52v0, c52v1)
      local c52v2, c52v3, c52v4, c52v5, c52v6, c52v7, c52v8, c52v9, c52v10
      c52v2 = c52v0.UniformElementHeights
      if c52v2 then
        do return c52v0:_GenericSettings_CalculateScrollBarHeight(c52v1) end
      end
      c52v2, c52v3 = c52v0:GetBounds()
      if not c52v1 then
        c52v1 = 0
      end
      c52v4 = 0
      c52v7 = c52v2
      c52v5 = c52v3
      c52v6 = 1
      for __renovice_for_0_0 = c52v7, c52v5, c52v6 do
        c52v8 = v12
        c52v8 = c52v8:GetElementById(__renovice_for_0_0)
        c52v9 = v12
        c52v9 = c52v9:CalculateHeight(c52v8)
        c52v10 = c52v0.mForcedVerticalSeparation
        if c52v10 < c52v9 then
          c52v9 = c52v9 * 0.6
        end
        c52v4 = c52v4 + c52v9
      end
      c52v5 = c52v4 + c52v1
      do return c52v5 end
    end
    c55v1.CalculateScrollBarHeight = c55v2
    c55v1 = mMovie
    c55v3 = "/Lotus/Language/Menu/SearchPrompt"
    c55v4 = false
    c55v1 = c55v1:GetLocalized(c55v3, c55v4)
    c55v2 = require
    c55v3 = "Lotus.Interface.Components.ThemedInputField"
    c55v2 = c55v2(c55v3)
    c55v3 = c55v2.Create__e256561c
    c55v4 = mMovie
    c55v5 = "Container.SearchBox"
    c55v6 = nil
    c55v7 = nil
    c55v8 = "<MENU_LTHUMB>"
    c55v3 = c55v3(c55v4, c55v5, c55v6, c55v7, c55v8)
    v35 = c55v3
    c55v3 = v35
    c55v5 = v35
    c55v5 = c55v5.TYPE
    c55v5 = c55v5.PLAIN
    c55v3:SetType(c55v5, c55v1, c55v1)
    c55v3 = v35
    c55v4 = 200
    c55v3.mMinSize = c55v4
    c55v3 = v35
    c55v4 = 200
    c55v3.mMaxSize = c55v4
    c55v3 = v35
    c55v4 = 4
    c55v3.mTextBuffer = c55v4
    c55v3 = v35
    c55v4 = _G
    c55v4 = c55v4.UITexture_Search
    c55v3.mAltButtonIcon = c55v4
    c55v3 = v35
    c55v4 = true
    c55v3.mAltButtonVisible = c55v4
    c55v3 = v35
    c55v4 = v35
    c55v4 = c55v4.InputFieldTextChanged
    c55v3.BaseInputFieldTextChanged = c55v4
    c55v3 = v35
    c55v4 = function(c53v0, c53v1)
      local c53v2, c53v3, c53v4, c53v5, c53v6, c53v7
      local __renovice_state_0 = 0
      c53v2 = c53v0.mLabel
      c53v0:BaseInputFieldTextChanged(c53v1)
      c53v4 = c53v0.mLabel
      if c53v4 ~= "" then
        __renovice_state_0 = 2
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c53v3 = _G
        c53v3 = c53v3.UITexture_Search
        if c53v3 then
          __renovice_state_0 = 3
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        c53v3 = _G
        c53v3 = c53v3.UITexture_ClearSearch
        __renovice_state_0 = 3
      end
      if __renovice_state_0 == 3 then
        c53v4 = c53v0.mAltButtonicon
        if c53v4 == c53v3 then
          __renovice_state_0 = 5
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c53v0.mAltButtonicon = c53v3
        c53v4 = c53v0.mMovie
        c53v6 = c53v0.mClipName
        c53v7 = ".BtnAlt"
        c53v5 = c53v6 .. c53v7
        c53v4:OverrideTexture(c53v5, c53v3)
        __renovice_state_0 = 5
      end
      if __renovice_state_0 == 5 then
        c53v4 = c53v0.mLabel
        if c53v2 == c53v4 then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        c53v4 = v62
        c53v4(c53v2)
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 7 then
        do return end
      end
      do return end
    end
    c55v3.InputFieldTextChanged = c55v4
    c55v3 = v35
    c55v4 = v35
    c55v4 = c55v4.OnGamepadTransition
    c55v3.BaseOnGamepadTransition = c55v4
    c55v3 = v35
    c55v4 = function(c54v0)
      local c54v1, c54v2, c54v3, c54v4, c54v5
      c54v0:BaseOnGamepadTransition()
      c54v2 = Engine.IsPlayingWithController
      c54v2 = c54v2()
      c54v1 = not c54v2
      c54v0.mAltButtonVisible = c54v1
      c54v2 = mMovie
      c54v3 = c54v0.mClipName
      c54v4 = "BtnAlt"
      c54v5 = 13
      c54v2:Name__e375fc94(c54v3, c54v4, c54v5, c54v1)
      do return end
    end
    c55v3.OnGamepadTransition = c55v4
    c55v3 = v35
    c55v5 = "/Lotus/Language/Menu/SearchPrompt"
    c55v3:SetHint(c55v5)
    c55v3 = v35
    c55v3:Redraw()
    c55v3 = v35
    c55v5 = false
    c55v3:SetVisible(c55v5)
    do return end
  end
  v46 = function()
    local c56v0, c56v1, c56v2, c56v3, c56v4, c56v5, c56v6, c56v7
    c56v0 = v12
    c56v2 = v31
    c56v0 = c56v0:GetElementIndexById(c56v2)
    c56v1 = IsNull
    c56v1 = c56v1(c56v0)
    if not c56v1 then
      c56v1 = v12
      c56v1 = c56v1:GetElementInIndex(c56v0)
      c56v2 = mMovie
      c56v5 = c56v1.mCountButton
      c56v5 = c56v5.mClipName
      c56v6 = ".Label"
      c56v4 = c56v5 .. c56v6
      c56v5 = 36
      c56v2 = c56v2:GetStringVariable(c56v4, c56v5)
      c56v3 = tonumber
      c56v3 = c56v3(c56v2)
      c56v4 = c56v1.mCount
      if c56v3 ~= c56v4 then
        c56v3 = string.gsub
        c56v5 = "|"
        c56v6 = ""
        c56v3 = c56v3(c56v2, c56v5, c56v6)
        c56v4 = tonumber
        c56v3 = c56v4(c56v3)
        if c56v3 ~= nil then
          c56v4 = Clamp
          c56v6 = 0
          c56v7 = c56v1.mMaxCount
          c56v3 = c56v4(c56v3, c56v6, c56v7)
          c56v4 = math.floor
          c56v3 = c56v4(c56v3)
          c56v4 = c56v1.mCountButton
          c56v4:SetText(c56v3)
          c56v1.mCount = c56v3
        else
          c56v4 = c56v1.mCountButton
          c56v6 = ""
          c56v4:SetText(c56v6)
        end
        c56v4 = v60
        c56v4(c56v1)
      end
    end
    do return end
  end
  v64 = function()
    local c57v0, c57v1, c57v2, c57v3, c57v4, c57v5, c57v6, c57v7, c57v8, c57v9, c57v10, c57v11, c57v12, c57v13, c57v14, c57v15, c57v16, c57v17, c57v18, c57v19, c57v20
    local __renovice_local_0 = v15
    __renovice_local_0 = __renovice_local_0.InputField
    if __renovice_local_0 == nil then
      do return end
    end
    __renovice_local_0 = mMovie
    c57v1 = v15
    c57v1 = c57v1.InputField
    c57v1 = c57v1.mLabelClipName
    c57v2 = 36
    __renovice_local_0 = __renovice_local_0:GetStringVariable(c57v1, c57v2)
    c57v1 = mMovie
    c57v3 = v15
    c57v3 = c57v3.InputField
    c57v3 = c57v3.mLabelClipName
    c57v4 = 84
    c57v1 = c57v1:GetNumberVariable(c57v3, c57v4)
    c57v0 = c57v1 or 0
    c57v3 = 1
    c57v1 = string.sub
    c57v1 = c57v1(__renovice_local_0, c57v3, c57v0)
    c57v2 = string.find
    c57v3 = string.reverse
    c57v3 = c57v3(c57v1)
    c57v4 = ","
    c57v2 = c57v2(c57v3, c57v4)
    if c57v2 ~= nil then
      c57v4 = string.len
      c57v4 = c57v4(c57v1)
      c57v3 = c57v4 - c57v2
      c57v2 = c57v3 + 1
    end
    if (c57v2 == nil or c57v0 < c57v2) then
      c57v2 = 0
    end
    c57v3 = string.find
    c57v5 = ","
    c57v6 = c57v0 + 1
    c57v3 = c57v3(__renovice_local_0, c57v5, c57v6)
    c57v4 = string.sub
    __renovice_local_0 = c57v4(__renovice_local_0, c57v2, c57v3)
    c57v4 = string.gsub
    c57v6 = "[, ]"
    c57v7 = ""
    __renovice_local_0 = c57v4(__renovice_local_0, c57v6, c57v7)
    c57v4 = string.lower
    __renovice_local_0 = c57v4(__renovice_local_0)
    c57v4 = false
    c57v5 = v25
    if __renovice_local_0 == c57v5 then
      do return end
    end
    v25 = __renovice_local_0
    c57v5 = ""
    c57v6 = 0
    if __renovice_local_0 ~= "" then
      c57v7 = ""
      c57v8 = string.len
      c57v8 = c57v8(__renovice_local_0)
      c57v11 = 1
      c57v12 = 1
      c57v9 = string.sub
      c57v9 = c57v9(__renovice_local_0, c57v11, c57v12)
      c57v11 = v26
      c57v11 = c57v11.Indexer
      c57v10 = c57v11[c57v9]
      if c57v10 ~= nil then
        c57v12 = v26
        c57v12 = c57v12.Tags
        c57v11 = #c57v12
        c57v14 = c57v10
        c57v12 = c57v11
        c57v13 = 1
        for __renovice_for_0_0 = c57v14, c57v12, c57v13 do
          c57v16 = v26
          c57v16 = c57v16.Tags
          c57v15 = c57v16[__renovice_for_0_0]
          c57v18 = 1
          c57v16 = string.sub
          c57v16 = c57v16(c57v15, c57v18, c57v8)
          if c57v16 == __renovice_local_0 then
            c57v18 = v26
            c57v18 = c57v18.Real
            c57v17 = c57v18[__renovice_for_0_0]
            if c57v7 ~= c57v17 then
              c57v4 = true
              c57v20 = v26
              c57v20 = c57v20.Real
              c57v18 = c57v20[__renovice_for_0_0]
              c57v19 = "|"
              c57v5 = c57v5 .. c57v18 .. c57v19
              c57v6 = c57v6 + 1
              c57v17 = v26
              c57v17 = c57v17.Real
              c57v7 = c57v17[__renovice_for_0_0]
              c57v17 = 8
              if c57v17 <= c57v6 then break end
              continue
            end
          end
          c57v19 = 1
          c57v20 = 1
          c57v17 = string.sub
          c57v17 = c57v17(c57v15, c57v19, c57v20)
          if c57v9 ~= c57v17 then break end
        end
      end
    end
    if c57v4 then
      c57v8 = v25
      c57v5 = c57v5 .. c57v8
      c57v7 = v15
      v16 = c57v7
      c57v7 = v4
      c57v7 = c57v7.OpenIME
      c57v8 = v23
      c57v7(c57v8)
      c57v7 = v4
      c57v7 = c57v7.IMESetTip
      c57v8 = v25
      c57v9 = v23
      c57v7(c57v8, c57v9)
      c57v7 = v4
      c57v7 = c57v7.IMESetTipCursor
      c57v9 = v25
      c57v8 = string.len
      c57v8 = c57v8(c57v9)
      c57v9 = v23
      c57v7(c57v8, c57v9)
      c57v7 = v4
      c57v7 = c57v7.IMESetOptions
      c57v9 = v23
      c57v10 = false
      c57v7(c57v5, c57v9, c57v10)
      c57v7 = mMovie
      c57v9 = v15
      c57v9 = c57v9.InputField
      c57v9 = c57v9.mLabelClipName
      c57v10 = 86
      c57v11 = true
      c57v7:Name__863e56e7(c57v9, c57v10, c57v11)
      do return end
    end
    c57v7 = v4
    c57v7 = c57v7.IMESetOptions
    c57v8 = ""
    c57v9 = v23
    c57v10 = false
    c57v7(c57v8, c57v9, c57v10)
    c57v7 = v4
    c57v7 = c57v7.CloseIME
    c57v8 = v23
    c57v7(c57v8)
    c57v7 = mMovie
    c57v9 = v15
    c57v9 = c57v9.InputField
    c57v9 = c57v9.mLabelClipName
    c57v10 = 86
    c57v11 = false
    c57v7:Name__863e56e7(c57v9, c57v10, c57v11)
    c57v7 = nil
    v16 = c57v7
    do return end
  end
  v65 = function()
    local c58v0, c58v1, c58v2, c58v3, c58v4, c58v5, c58v6, c58v7, c58v8, c58v9, c58v10, c58v11, c58v12
    c58v0 = v4
    c58v0 = c58v0.IMEGetFocusedValue
    c58v1 = v23
    c58v0 = c58v0(c58v1)
    v25 = c58v0
    c58v2 = mMovie
    c58v4 = v16
    c58v4 = c58v4.InputField
    c58v4 = c58v4.mLabelClipName
    c58v5 = 84
    c58v2 = c58v2:GetNumberVariable(c58v4, c58v5)
    c58v1 = c58v2 or 0
    c58v2 = mMovie
    c58v4 = v16
    c58v4 = c58v4.InputField
    c58v4 = c58v4.mLabelClipName
    c58v5 = 36
    c58v2 = c58v2:GetStringVariable(c58v4, c58v5)
    c58v5 = 1
    c58v3 = string.sub
    c58v3 = c58v3(c58v2, c58v5, c58v1)
    c58v4 = string.find
    c58v5 = string.reverse
    c58v5 = c58v5(c58v3)
    c58v6 = ","
    c58v4 = c58v4(c58v5, c58v6)
    c58v5 = ""
    if c58v4 ~= nil then
      c58v7 = string.len
      c58v7 = c58v7(c58v3)
      c58v6 = c58v7 - c58v4
      c58v4 = c58v6 + 1
      if c58v4 < c58v1 then
        c58v10 = 1
        c58v8 = string.sub
        c58v6 = c58v8(c58v2, c58v10, c58v4)
        c58v7 = " "
        c58v5 = c58v6 .. c58v7
      end
    end
    c58v6 = string.find
    c58v8 = ","
    c58v6 = c58v6(c58v2, c58v8, c58v1)
    c58v7 = ", "
    c58v9 = c58v5 .. c58v0 .. c58v7
    c58v8 = string.len
    c58v1 = c58v8(c58v9)
    if c58v6 ~= nil then
      c58v8 = string.sub
      c58v7 = c58v8(c58v2, c58v6)
      c58v9 = c58v5 .. c58v0
      c58v8 = string.len
      c58v1 = c58v8(c58v9)
    end
    c58v8 = mMovie
    c58v10 = v16
    c58v10 = c58v10.InputField
    c58v10 = c58v10.mLabelClipName
    c58v11 = 36
    c58v12 = c58v5 .. c58v0 .. c58v7
    c58v8:SetStringVariable(c58v10, c58v11, c58v12)
    c58v8 = mMovie
    c58v10 = v16
    c58v10 = c58v10.InputField
    c58v10 = c58v10.mLabelClipName
    c58v11 = 84
    c58v8:SetNumberVariable(c58v10, c58v11, c58v1)
    c58v8 = v4
    c58v8 = c58v8.CloseIME
    c58v9 = v23
    c58v8(c58v9)
    c58v8 = v4
    c58v8 = c58v8.IMESetFocusedOption
    c58v9 = 1
    c58v10 = v23
    c58v8(c58v9, c58v10)
    c58v8 = mMovie
    c58v10 = v16
    c58v10 = c58v10.InputField
    c58v10 = c58v10.mLabelClipName
    c58v11 = 86
    c58v12 = false
    c58v8:Name__863e56e7(c58v10, c58v11, c58v12)
    c58v8 = nil
    v16 = c58v8
    c58v8 = v60
    c58v8()
    do return end
  end
  v66 = function()
    local c60v0, c60v1, c60v2, c60v3, c60v4, c60v5, c60v6
    c60v0 = v10
    if c60v0 then
      c60v1 = mMovie
      c60v0 = IsNull
      c60v0 = c60v0(c60v1)
      if not c60v0 then
        c60v0 = mMovie
        c60v2 = RealDeltaTime
        c60v0:Name__3e8ea7a1(c60v2())
        c60v1 = v9
        c60v0 = IsNull
        c60v0 = c60v0(c60v1)
        if not c60v0 then
          c60v0 = v9
          c60v2 = RealDeltaTime
          c60v0:Update(c60v2())
        end
        c60v1 = v12
        c60v1 = c60v1.mScrollBar
        c60v0 = IsNull
        c60v0 = c60v0(c60v1)
        if not c60v0 then
          c60v0 = v12
          c60v0 = c60v0.mScrollBar
          c60v2 = RealDeltaTime
          c60v0:Update(c60v2())
        end
        c60v1 = v28
        c60v0 = IsNull
        c60v0 = c60v0(c60v1)
        if not c60v0 then
          c60v1 = v30
          c60v2 = RealDeltaTime
          c60v2 = c60v2()
          c60v0 = c60v1 - c60v2
          v30 = c60v0
          c60v0 = v30
          c60v1 = 0
          if c60v0 <= c60v1 then
            c60v0 = v29
            c60v2 = v52
            c60v3 = v15
            c60v3 = c60v3.mMaxCount
            c60v2 = c60v2(c60v3)
            c60v1 = c60v2 - 1
            if c60v0 < c60v1 then
              c60v1 = v29
              c60v0 = c60v1 + 0.2
              v29 = c60v0
            end
            c60v0 = 0.25
            v30 = c60v0
            c60v0 = v48
            c60v2 = v28
            c60v4 = 10
            c60v6 = v29
            c60v5 = math.floor
            c60v5 = c60v5(c60v6)
            c60v3 = math.pow
            c60v3 = c60v3(c60v4, c60v5)
            c60v1 = c60v2 * c60v3
            c60v0(c60v1)
          end
        end
        c60v0 = v12
        c60v2 = function(c59v0)
          local c59v1, c59v2
          c59v2 = c59v0.mOnUpdate
          c59v1 = IsNull
          c59v1 = c59v1(c59v2)
          if not c59v1 then
            c59v1 = c59v0.mOnUpdate
            c59v2 = c59v0.Id
            c59v1(c59v2)
          end
          do return end
        end
        c60v0:RunForAllElements(c60v2)
        c60v0 = v31
        if c60v0 ~= nil then
          c60v0 = v46
          c60v0()
        end
        c60v0 = gFlashMgr
        c60v0 = c60v0:Name__9711230b()
        if not c60v0 then
          c60v1 = v23
          c60v0 = IsNull
          c60v0 = c60v0(c60v1)
          if not c60v0 then
            c60v0 = v15
            if c60v0 ~= nil then
              c60v0 = v15
              c60v0 = c60v0.mType
              c60v1 = v0
              c60v1 = c60v1.INPUTBOX
              if c60v0 == c60v1 then
                c60v0 = v4
                c60v0 = c60v0.IMEGetAndClearClicked
                c60v0 = c60v0()
                if c60v0 then
                  c60v0 = v65
                  c60v0()
                end
                c60v0 = v64
                c60v0()
              end
            end
            c60v0 = v4
            c60v0 = c60v0.Update
            c60v1 = v23
            c60v0(c60v1)
          end
        end
        do return end
      end
    end
    do return end
  end
  Update = v66
  v66 = function()
    local c63v0, c63v1, c63v2, c63v3, c63v4, c63v5, c63v6, c63v7, c63v8, c63v9, c63v10, c63v11, c63v12
    c63v0 = v17
    if c63v0 == nil then
      c63v1 = v22
      c63v0 = c63v1 + 1
      v22 = c63v0
      c63v0 = v22
      c63v1 = 10
      if c63v0 < c63v1 then
        c63v0 = v9
        c63v2 = 0.1
        c63v3 = v66
        c63v0:AddTimer(c63v2, c63v3)
        do return end
      end
      c63v0 = v53
      c63v0()
      do return end
    end
    c63v0 = true
    c63v1 = 0
    c63v2 = v12
    c63v3 = {}
    c63v2.mUnfilteredElements = c63v3
    c63v4 = _T
    c63v5 = v17
    c63v3 = c63v4[c63v5]
    c63v2 = IsNull
    c63v2 = c63v2(c63v3)
    if not c63v2 then
      c63v3 = _T
      c63v4 = v17
      c63v2 = c63v3[c63v4]
      c63v2 = c63v2()
      c63v5 = 1
      c63v3 = #c63v2
      c63v4 = 1
      for __renovice_for_0_0 = c63v5, c63v3, c63v4 do
        c63v6 = ResetLineCount
        c63v7 = 0
        c63v6(c63v7)
        c63v6 = c63v2[__renovice_for_0_0]
        c63v6 = c63v6.mHeight
        if c63v6 == nil then
          c63v7 = v47
          c63v8 = c63v2[__renovice_for_0_0]
          c63v8 = c63v8.mType
          c63v6 = c63v7[c63v8]
        end
        repeat
          if (__renovice_for_0_0 == 1 or c63v1 == c63v6) then
            c63v7 = c63v2[__renovice_for_0_0]
            c63v7 = c63v7.mType
            c63v8 = v0
            c63v8 = c63v8.INPUTBOX
            if c63v7 ~= c63v8 then
              c63v7 = c63v2[__renovice_for_0_0]
              c63v7 = c63v7.mMultiLine
              if c63v7 ~= true then break end
            end
          end
          c63v0 = false
        until true
        c63v1 = c63v6
        c63v7 = c63v2[__renovice_for_0_0]
        c63v7.Id = __renovice_for_0_0
        c63v7 = c63v2[__renovice_for_0_0]
        c63v8 = c63v2[__renovice_for_0_0]
        c63v8 = c63v8.mValue
        c63v7.mOriginalValue = c63v8
        c63v7 = c63v2[__renovice_for_0_0]
        c63v7 = c63v7.mOriginalValue
        if c63v7 == nil then
          c63v7 = c63v2[__renovice_for_0_0]
          c63v8 = c63v2[__renovice_for_0_0]
          c63v8 = c63v8.mContent
          c63v7.mOriginalValue = c63v8
        end
        c63v7 = c63v2[__renovice_for_0_0]
        c63v7 = c63v7.mLabel
        if c63v7 ~= nil then
          c63v7 = c63v2[__renovice_for_0_0]
          c63v8 = ToSearchable
          c63v9 = c63v2[__renovice_for_0_0]
          c63v9 = c63v9.mLabel
          c63v8 = c63v8(c63v9)
          c63v7.mSearchTerm = c63v8
        end
        c63v8 = v12
        c63v8 = c63v8.mUnfilteredElements
        c63v9 = v1
        c63v9 = c63v9.CopyTable
        c63v10 = c63v2[__renovice_for_0_0]
        c63v7 = table.insert
        c63v7(c63v8, c63v9(c63v10))
        c63v7 = v12
        c63v9 = c63v2[__renovice_for_0_0]
        c63v10 = true
        c63v7:AddElement(c63v9, c63v10)
      end
    end
    c63v2 = 0
    c63v3 = 0
    if c63v0 then
      c63v2 = 14
      c63v4 = v12
      c63v5 = 43
      c63v4.mForcedVerticalSeparation = c63v5
      c63v5 = v12
      c63v5 = c63v5:GetHowManyElements()
      c63v6 = v12
      c63v6 = c63v6.mForcedVerticalSeparation
      c63v4 = c63v5 * c63v6
      c63v3 = c63v3 + c63v4
      c63v4 = v12
      c63v5 = 36
      c63v4.mOriginalButtonHeight = c63v5
    else
      c63v4 = v12
      c63v5 = 20
      c63v4.mForcedVerticalSeparation = c63v5
      c63v4 = v12
      c63v6 = function(c61v0)
        local c61v1, c61v2, c61v3
        c61v2 = c63v3
        c61v3 = v12
        c61v3 = c61v3:CalculateHeight(c61v0)
        c61v1 = c61v2 + c61v3
        c63v3 = c61v1
        c61v1 = c63v3
        c61v2 = 560
        if c61v1 < c61v2 then
          c61v2 = c63v2
          c61v1 = c61v2 + 1
          c63v2 = c61v1
        end
        do return end
      end
      c63v4:RunForAllElements(c63v6)
    end
    repeat
      v12.UniformElementHeights = c63v0
      c63v4 = v12
      c63v4 = c63v4.UniformElementHeights
      if c63v4 then
        c63v4 = v12
        c63v4 = c63v4:GetHowManyElements()
        if c63v2 < c63v4 then
          v12.mVisibleElements = c63v2
          c63v4 = v12
          c63v5 = 0
          c63v4.mElementTransitionTime = c63v5
          c63v4 = v12
          c63v6 = "Container.ScrollBar"
          c63v7 = -5
          c63v4:AttachScrollBar(c63v6, c63v7)
          c63v4 = v12
          c63v4:EnableSmoothScroll()
          c63v4 = mMovie
          c63v6 = "Container.OptionListMask"
          c63v7 = 15
          c63v8 = 600
          c63v4:SetNumberVariable(c63v6, c63v7, c63v8)
          break
        end
      end
      c63v4 = mMovie
      c63v6 = "Container.ScrollBar"
      c63v7 = 13
      c63v8 = false
      c63v4:Name__863e56e7(c63v6, c63v7, c63v8)
      c63v4 = mMovie
      c63v6 = "Container.OptionListMask"
      c63v7 = 15
      c63v8 = mMovie
      c63v4:SetNumberVariable(c63v6, c63v7, c63v8:GetMovieHeight())
    until true
    c63v4 = mMovie
    c63v6 = "Container.Message"
    c63v7 = 13
    c63v9 = v12
    c63v9 = c63v9:GetHowManyElements()
    if c63v9 ~= 0 then
      c63v8 = false
    else
      c63v8 = true
    end
    c63v4:Name__863e56e7(c63v6, c63v7, c63v8)
    c63v4 = FlashInterpolate
    c63v5 = mMovie
    c63v6 = "_root"
    c63v7 = 2
    c63v9 = 12
    c63v10 = 4
    c63v8 = {c63v9, c63v10}
    c63v10 = 100
    c63v11 = 0
    c63v9 = {c63v10, c63v11}
    c63v10 = 0.2
    c63v11 = 0
    c63v12 = function()
      local c62v0
      c62v0 = false
      v11 = c62v0
      do return end
    end
    c63v4(c63v5, c63v6, c63v7, c63v8, c63v9, c63v10, c63v11, c63v12)
    c63v4 = v59
    c63v4()
    c63v4 = v12
    c63v4:Redraw()
    c63v4 = v49
    c63v4()
    do return end
  end
  v67 = function()
    local c64v0, c64v1, c64v2, c64v3
    c64v0 = mMovie
    c64v1 = "MouseCatcherBtn"
    c64v2 = 14
    c64v3 = mMovie
    c64v0:SetNumberVariable(c64v1, c64v2, c64v3:GetViewportWidth())
    c64v0 = mMovie
    c64v1 = "MouseCatcherBtn"
    c64v2 = 15
    c64v3 = mMovie
    c64v0:SetNumberVariable(c64v1, c64v2, c64v3:GetViewportHeight())
    do return end
  end
  v68 = function()
    local c67v0, c67v1, c67v2, c67v3, c67v4, c67v5, c67v6, c67v7, c67v8, c67v9, c67v10, c67v11
    c67v0 = require
    c67v1 = "Lotus.Interface.Libs.TimerMgr"
    c67v0 = c67v0(c67v1)
    c67v1 = c67v0.CreateTimerMgr
    c67v1 = c67v1()
    v9 = c67v1
    c67v1 = v1
    c67v1 = c67v1.PlaySound
    c67v2 = _G
    c67v2 = c67v2.UISound_WindowOpen
    c67v1(c67v2)
    c67v1 = mMovie
    c67v4 = _T.RadialSolarMapOpen
    if c67v4 ~= true then
      c67v3 = false
    else
      c67v3 = true
    end
    c67v1:SetPreDrawUpdate(c67v3)
    c67v1 = mMovie
    c67v3 = "MouseCatcherBtn"
    c67v4 = "noMenuSelection"
    c67v5 = true
    c67v1:SetVariable(c67v3, c67v4, c67v5)
    c67v1 = v67
    c67v1()
    c67v2 = "FancyBits.LeftLines"
    c67v3 = "FancyBits.LeftSideLine.FadeLineTop"
    c67v4 = "FancyBits.LeftSideLine.FadeLineMiddle"
    c67v5 = "FancyBits.LeftSideLine.FadeLineBottom"
    c67v1 = {c67v2, c67v3, c67v4, c67v5}
    c67v4 = 1
    c67v2 = #c67v1
    c67v3 = 1
    for __renovice_for_0_0 = c67v4, c67v2, c67v3 do
      c67v5 = mMovie
      c67v7 = c67v1[__renovice_for_0_0]
      c67v8 = leftLineMaterial
      c67v5:OverrideMaterial(c67v7, c67v8)
    end
    c67v3 = "FancyBits.RightLines"
    c67v4 = "FancyBits.RightSideLine.FadeLineTop"
    c67v5 = "FancyBits.RightSideLine.FadeLineMiddle"
    c67v6 = "FancyBits.RightSideLine.FadeLineBottom"
    c67v1 = {c67v3, c67v4, c67v5, c67v6}
    c67v4 = 1
    c67v2 = #c67v1
    c67v3 = 1
    for __renovice_for_1_0 = c67v4, c67v2, c67v3 do
      c67v5 = mMovie
      c67v7 = c67v1[__renovice_for_1_0]
      c67v8 = rightLineMaterial
      c67v5:OverrideMaterial(c67v7, c67v8)
    end
    c67v2 = v57
    c67v2()
    c67v2 = v63
    c67v2()
    c67v2 = mMovie
    c67v4 = "MouseCatcherBtn"
    c67v5 = nil
    c67v6 = nil
    c67v7 = nil
    c67v8 = "MouseCatcherPressed"
    c67v2:SetCallbacks(c67v4, c67v5, c67v6, c67v7, c67v8)
    c67v2 = mMovie
    c67v4 = true
    c67v2:Name__6ad446ff(c67v4)
    c67v2 = mMovie
    c67v4 = "_root"
    c67v5 = 12
    c67v6 = 0
    c67v2:SetNumberVariable(c67v4, c67v5, c67v6)
    c67v2 = mMovie
    c67v4 = "_root"
    c67v5 = 4
    c67v6 = -15000
    c67v2:SetNumberVariable(c67v4, c67v5, c67v6)
    c67v2 = function(c65v0)
      local c65v1, c65v2
      c65v1 = mMovie
      c65v2 = c65v0 * 0.9
      c65v1:SetBackgroundAlpha(c65v2)
      do return end
    end
    c67v4 = 0
    c67v2(c67v4)
    c67v3 = FlashInterpolate
    c67v4 = mMovie
    c67v5 = "_root"
    c67v6 = 0
    c67v7 = {c67v2}
    c67v9 = 1
    c67v8 = {c67v9}
    c67v9 = 0.15
    c67v10 = 0
    c67v11 = function()
      local c66v0
      c66v0 = v66
      c66v0()
      do return end
    end
    c67v3(c67v4, c67v5, c67v6, c67v7, c67v8, c67v9, c67v10, c67v11)
    c67v3 = v59
    c67v3()
    c67v3 = true
    v10 = c67v3
    do return end
  end
  Initialize = v68
  v68 = function(c68v0)
    local c68v1, c68v2, c68v3, c68v4
    if c68v0 ~= "true" then
      c68v1 = false
    else
      c68v1 = true
    end
    v45 = c68v1
    c68v1 = mMovie
    c68v2 = "Container.Title"
    c68v3 = 13
    c68v4 = v45
    c68v1:Name__863e56e7(c68v2, c68v3, c68v4)
    do return end
  end
  ShowTitle = v68
  v68 = function(c69v0, c69v1, c69v2)
    local c69v3, c69v4, c69v5, c69v6
    c69v3 = mMovie
    c69v4 = "Container.Title"
    c69v5 = 52
    if c69v1 ~= "true" then
      c69v6 = false
    else
      c69v6 = true
    end
    c69v3:Name__863e56e7(c69v4, c69v5, c69v6)
    c69v3 = mMovie
    c69v4 = "Container.Title.text"
    c69v3:SetLocalized(c69v4, c69v0)
    do return end
  end
  SetTitle = v68
  v68 = function(c70v0)
    local c70v1
    v13 = c70v0
    c70v1 = v59
    c70v1()
    do return end
  end
  SetConfirmButtonLabel = v68
  v68 = function(c71v0)
    local c71v1
    if c71v0 ~= "true" then
      c71v1 = false
    else
      c71v1 = true
    end
    v32 = c71v1
    do return end
  end
  SetConfirmButtonVisibleWhenInactive = v68
  v68 = function(c72v0)
    local c72v1
    if c72v0 ~= "true" then
      c72v1 = false
    else
      c72v1 = true
    end
    v14 = c72v1
    c72v1 = v33
    if not c72v1 then
      c72v1 = v14
    end
    v33 = c72v1
    c72v1 = v59
    c72v1()
    do return end
  end
  SetConfirmButtonActive = v68
  v68 = function(c73v0)
    local c73v1
    v34 = c73v0
    c73v1 = v59
    c73v1()
    do return end
  end
  SetHideActiveConfirmButton = v68
  v68 = function(c74v0)
    local c74v1
    if c74v0 ~= "true" then
      c74v1 = false
    else
      c74v1 = true
    end
    v33 = c74v1
    c74v1 = v59
    c74v1()
    do return end
  end
  SetConfirmButtonActiveOverride = v68
  v68 = function(c75v0)
    local c75v1
    v36 = c75v0
    c75v1 = v59
    c75v1()
    do return end
  end
  SetCancelButtonLabel = v68
  v68 = function(c76v0)
    local c76v1
    if c76v0 ~= "true" then
      c76v1 = false
    else
      c76v1 = true
    end
    v37 = c76v1
    c76v1 = v59
    c76v1()
    do return end
  end
  SetCancelButtonActive = v68
  v68 = function(c77v0)
    local c77v1
    v38 = c77v0
    c77v1 = v59
    c77v1()
    do return end
  end
  SetHideActiveCancelButton = v68
  v68 = function(c78v0)
    local c78v1, c78v2, c78v3, c78v4
    c78v1 = mMovie
    c78v2 = "Container.Message"
    c78v3 = 46
    c78v4 = "center"
    c78v1:SetStringVariable(c78v2, c78v3, c78v4)
    c78v1 = mMovie
    c78v2 = "Container.Message.text"
    c78v1:SetLocalized(c78v2, c78v0)
    do return end
  end
  SetNoElementsMessage = v68
  v68 = function(c79v0)
    v17 = c79v0
    do return end
  end
  SetElementsFunction = v68
  v68 = function(c80v0)
    v39 = c80v0
    do return end
  end
  SetCustomButtonFunction = v68
  v68 = function(c81v0)
    local c81v1, c81v2, c81v3, c81v4
    c81v1 = v40
    if c81v1 then
      c81v1 = v40
      c81v3 = tonumber
      c81v3 = c81v3(c81v0)
      c81v4 = 4
      if c81v3 ~= c81v4 then
        c81v2 = false
      else
        c81v2 = true
      end
      c81v1(c81v2)
    end
    do return end
  end
  OnCustomButtonConfirmation = v68
  v68 = function()
    local c82v0, c82v1, c82v2
    c82v0 = v1
    c82v0 = c82v0.ShowConfirmMessage
    c82v1 = v41
    c82v1 = c82v1.ConfirmLabel
    c82v2 = "OnCustomButtonConfirmation"
    c82v0(c82v1, c82v2)
    do return end
  end
  ShowCustomButtonConfirmation = v68
  v68 = function(c83v0)
    v18 = c83v0
    do return end
  end
  SetCallBack = v68
  v68 = function(c84v0)
    v20 = c84v0
    do return end
  end
  SetValueChangedCallBack = v68
  v68 = function()
    local c86v0, c86v1, c86v2, c86v3, c86v4, c86v5, c86v6, c86v7, c86v8
    c86v0 = Engine.IsConsole
    c86v0 = c86v0()
    if not c86v0 then
      c86v0 = gFlashMgr
      c86v2 = IMEOverlayMovie
      c86v0 = c86v0:FindMovie(c86v2)
      v23 = c86v0
      c86v1 = v23
      c86v0 = IsNull
      c86v0 = c86v0(c86v1)
      if c86v0 then
        c86v1 = IMEOverlayMovie
        c86v0 = IsNull
        c86v0 = c86v0(c86v1)
        if not c86v0 then
          c86v0 = mMovie
          c86v2 = IMEOverlayMovie
          c86v0 = c86v0:PushChildMovie(c86v2)
          v23 = c86v0
          c86v0 = true
          v24 = c86v0
        end
      end
      c86v1 = v23
      c86v0 = IsNull
      c86v0 = c86v0(c86v1)
      if not c86v0 then
        c86v0 = v26
        c86v1 = {}
        c86v0.Real = c86v1
        c86v0 = v26
        c86v1 = {}
        c86v0.Tags = c86v1
        c86v0 = v26
        c86v1 = {}
        c86v0.Indexer = c86v1
        c86v0 = ipairs
        c86v1 = gGameData
        c86v0, c86v1, c86v2 = c86v0(c86v1:Name__c2a28467())
        for __renovice_for_0_0, __renovice_for_0_1 in c86v0, c86v1, c86v2 do
          c86v6 = v26
          c86v6 = c86v6.Real
          c86v7 = __renovice_for_0_1.mDisplayName
          c86v5 = table.insert
          c86v5(c86v6, c86v7)
        end
        c86v0 = table.sort
        c86v1 = v26
        c86v1 = c86v1.Real
        c86v2 = function(c85v0, c85v1)
          local c85v2, c85v3, c85v4
          c85v3 = string.lower
          c85v3 = c85v3(c85v0)
          c85v4 = string.lower
          c85v4 = c85v4(c85v1)
          if not (c85v3 < c85v4) then
            c85v2 = false
            do return c85v2 end
          end
          c85v2 = true
          do return c85v2 end
        end
        c86v0(c86v1, c86v2)
        c86v0 = nil
        c86v3 = 1
        c86v4 = v26
        c86v4 = c86v4.Real
        c86v1 = #c86v4
        c86v2 = 1
        for __renovice_for_1_0 = c86v3, c86v1, c86v2 do
          c86v5 = v26
          c86v5 = c86v5.Tags
          c86v6 = string.lower
          c86v8 = v26
          c86v8 = c86v8.Real
          c86v7 = c86v8[__renovice_for_1_0]
          c86v4 = table.insert
          c86v4(c86v5, c86v6(c86v7))
          c86v6 = v26
          c86v6 = c86v6.Tags
          c86v5 = c86v6[__renovice_for_1_0]
          c86v6 = 1
          c86v7 = 1
          c86v4 = string.sub
          c86v4 = c86v4(c86v5, c86v6, c86v7)
          if c86v4 == c86v0 then
            continue
          end
          c86v0 = c86v4
          c86v5 = v26
          c86v5 = c86v5.Indexer
          c86v5[c86v4] = __renovice_for_1_0
        end
      end
    end
    do return end
  end
  EnableHints = v68
  v68 = function(c87v0, c87v1, c87v2)
    local c87v3, c87v4, c87v5, c87v6, c87v7, c87v8, c87v9, c87v10, c87v11
    if c87v2 == "1" then
      c87v3 = v11
      if not c87v3 then
        c87v3 = v4
        c87v3 = c87v3.IsVisible
        c87v3 = c87v3()
        if c87v3 then
          c87v4 = v4
          c87v4 = c87v4.mTargetMovie
          c87v5 = mMovie
          if c87v4 ~= c87v5 then
            c87v3 = false
          else
            c87v3 = true
          end
        end
        c87v4 = string.find
        c87v6 = "_ENTER"
        c87v4 = c87v4(c87v1, c87v6)
        if c87v4 ~= nil then
          c87v4 = gFlashMgr
          c87v6 = _G
          c87v6 = c87v6.UIMovie_ConfirmMovie
          c87v4 = c87v4:HasMovie(c87v6)
          if (not c87v4 and c87v3) then
            c87v4 = v65
            c87v4()
          end
        else
          if c87v3 then
            c87v4 = 0
            c87v5 = string.find
            c87v7 = "EN_LEFT"
            c87v5 = c87v5(c87v1, c87v7)
            if c87v5 then
              c87v4 = -1
            else
              c87v5 = string.find
              c87v7 = "EN_RIGHT"
              c87v5 = c87v5(c87v1, c87v7)
              if c87v5 then
                c87v4 = 1
              end
            end
            if c87v4 ~= 0 then
              c87v6 = v4
              c87v6 = c87v6.IMEGetFocusedIndex
              c87v7 = v23
              c87v5 = tonumber
              c87v5 = c87v5(c87v6(c87v7))
              c87v6 = v4
              c87v6 = c87v6.IMESetFocusedOption
              c87v7 = c87v5 + c87v4
              c87v8 = v23
              c87v6 = c87v6(c87v7, c87v8)
              if not c87v6 then
                c87v7 = mMovie
                c87v9 = v15
                c87v9 = c87v9.InputField
                c87v9 = c87v9.mLabelClipName
                c87v10 = 84
                c87v7 = c87v7:GetNumberVariable(c87v9, c87v10)
                c87v6 = c87v7 or 0
                c87v7 = mMovie
                c87v9 = v15
                c87v9 = c87v9.InputField
                c87v9 = c87v9.mLabelClipName
                c87v10 = 84
                c87v11 = c87v6 + c87v4
                c87v7:SetNumberVariable(c87v9, c87v10, c87v11)
              end
            end
          end
        end
      end
    end
    do return end
  end
  onRawInputEvent = v68
  v68 = function()
    local c88v0
    c88v0 = v53
    c88v0()
    do return end
  end
  Close = v68
  v68 = function()
    local c89v0
    c89v0 = v55
    c89v0()
    do return end
  end
  ExitScreen = v68
  v68 = function()
    local c90v0
    c90v0 = v11
    if c90v0 then
      do return end
    end
    c90v0 = v56
    c90v0()
    do return end
  end
  FinishSelection = v68
  v68 = function()
    local c91v0, c91v1
    c91v0 = v11
    if not c91v0 then
      c91v1 = v12
      c91v0 = IsNull
      c91v0 = c91v0(c91v1)
      if not c91v0 then
        c91v0 = v12
        c91v0:SelectCurrentElement()
      end
    end
    do return end
  end
  onKeyUp_MENU_SELECT = v68
  v68 = function()
    local c92v0
    c92v0 = v11
    do return c92v0 end
  end
  IsInputBlocked = v68
  v68 = function(c93v0, c93v1)
    local c93v2
    c93v2 = v67
    c93v2()
    do return end
  end
  onViewportSizeChanged = v68
  v68 = function(c94v0)
    local c94v1, c94v2, c94v3
    c94v2 = v12
    c94v1 = IsNull
    c94v1 = c94v1(c94v2)
    if not c94v1 then
      c94v1 = v12
      c94v3 = tonumber
      c94v3 = c94v3(c94v0)
      c94v1:FocusElementById(c94v3)
    end
    do return end
  end
  MenuEntryFocused = v68
  v68 = function(c95v0)
    local c95v1, c95v2, c95v3
    c95v2 = v12
    c95v1 = IsNull
    c95v1 = c95v1(c95v2)
    if not c95v1 then
      c95v1 = v12
      c95v1 = c95v1:GetElementById(c95v0)
      c95v2 = IsNull
      c95v2 = c95v2(c95v1)
      if not c95v2 then
        c95v2 = c95v1.mAlwaysUnfocus
        if c95v2 then
          c95v2 = v12
          c95v3 = tonumber
          c95v3 = c95v3(c95v0)
          c95v2:UnfocusElementById(c95v3)
        end
      end
    end
    do return end
  end
  MenuEntryUnfocused = v68
  v68 = function(c96v0)
    local c96v1, c96v2, c96v3, c96v4
    c96v1 = v11
    if not c96v1 then
      c96v2 = v12
      c96v1 = IsNull
      c96v1 = c96v1(c96v2)
      if not c96v1 then
        c96v1 = v12
        c96v3 = tonumber
        c96v3 = c96v3(c96v0)
        c96v4 = true
        c96v1:SelectElementById(c96v3, c96v4)
        c96v1 = v1
        c96v1 = c96v1.PlaySound
        c96v2 = _G
        c96v2 = c96v2.UISound_Select
        c96v1(c96v2)
      end
    end
    do return end
  end
  MenuEntryPressed = v68
  v68 = function(c97v0, c97v1)
    local c97v2, c97v3, c97v4, c97v5
    c97v2 = v11
    if not c97v2 then
      c97v3 = v12
      c97v3 = c97v3.mScrollBar
      c97v2 = IsNull
      c97v2 = c97v2(c97v3)
      if not c97v2 then
        c97v2 = v12
        c97v2 = c97v2.mScrollBar
        c97v4 = tonumber
        c97v4 = c97v4(c97v1)
        c97v5 = _G
        c97v5 = c97v5.UISound_Scroll
        c97v2:ScrollByStep(c97v4, c97v5)
      end
    end
    do return end
  end
  onKeyDown_MENU_MOUSE_Z = v68
  v68 = function(c98v0, c98v1)
    local c98v2, c98v3, c98v4
    if not c98v0 then
      c98v2 = mMovie
      c98v3 = v15
      c98v3 = c98v3.InputField
      c98v3 = c98v3.mLabelClipName
      c98v4 = 36
      c98v2:SetStringVariable(c98v3, c98v4, c98v1)
      v15.mContent = c98v1
      c98v2 = v60
      c98v2()
    end
    do return end
  end
  OSKInputBoxCallback = v68
  v48 = function(c99v0)
    local c99v1, c99v2, c99v3, c99v4, c99v5, c99v6, c99v7, c99v8, c99v9, c99v10, c99v11
    c99v3 = v15
    c99v3 = c99v3.mCount
    c99v2 = tonumber
    c99v2 = c99v2(c99v3)
    c99v3 = tonumber
    c99v3 = c99v3(c99v0)
    c99v1 = c99v2 + c99v3
    c99v2 = 0
    c99v3 = v15
    c99v3 = c99v3.mMinCount
    if c99v3 ~= nil then
      c99v4 = v15
      c99v4 = c99v4.mMinCount
      c99v3 = tonumber
      c99v2 = c99v3(c99v4)
    end
    if c99v1 < c99v2 then
      c99v1 = c99v2
    end
    c99v4 = v15
    c99v4 = c99v4.mMaxCount
    c99v3 = tonumber
    c99v3 = c99v3(c99v4)
    if c99v3 < c99v1 then
      c99v1 = v15.mMaxCount
    end
    c99v3 = Engine.IsPlayingWithController
    c99v3 = c99v3()
    if c99v3 then
      c99v3 = v1
      c99v3 = c99v3.CreateParticles
      c99v4 = mMovie
      c99v6 = v15
      c99v6 = c99v6.mClipName
      c99v7 = ".Callouts."
      c99v8 = v1
      c99v8 = c99v8.Ternary
      c99v10 = 0
      if not (c99v10 < c99v0) then
        c99v9 = false
      else
        c99v9 = true
      end
      c99v10 = "Right"
      c99v11 = "Left"
      c99v8 = c99v8(c99v9, c99v10, c99v11)
      c99v5 = c99v6 .. c99v7 .. c99v8
      c99v6 = v1
      c99v6 = c99v6.Ternary
      c99v8 = 0
      if not (c99v8 < c99v0) then
        c99v7 = false
      else
        c99v7 = true
      end
      c99v8 = _G
      c99v8 = c99v8.UIFx_RightBumperPress
      c99v9 = _G
      c99v9 = c99v9.UIFx_LeftBumperPress
      c99v6 = c99v6(c99v7, c99v8, c99v9)
      c99v7 = 0
      c99v8 = 0
      c99v3(c99v4, c99v5, c99v6, c99v7, c99v8)
    end
    v15.mCount = c99v1
    c99v3 = v15
    c99v3 = c99v3.mCountButton
    if c99v3 then
      c99v3 = v15
      c99v3 = c99v3.mCountButton
      c99v6 = v1
      c99v6 = c99v6.FormatNumber
      c99v7 = v15
      c99v7 = c99v7.mCount
      c99v8 = 0
      c99v5 = tostring
      c99v5 = c99v5(c99v6(c99v7, c99v8))
      c99v3:SetText(c99v5)
    end
    c99v3 = v15
    c99v3 = c99v3.mCallback
    if c99v3 ~= nil then
      c99v3 = v15
      c99v3 = c99v3.mCallback
      c99v3(c99v1)
    end
    c99v3 = v60
    c99v3()
    do return end
  end
  v68 = function(c100v0)
    local c100v1, c100v2
    c100v1 = v11
    if not c100v1 then
      c100v2 = v15
      c100v1 = IsNull
      c100v1 = c100v1(c100v2)
      if not c100v1 then
        c100v1 = v15
        c100v1 = c100v1.mType
        c100v2 = v0
        c100v2 = c100v2.INPUTCOUNT
        if c100v1 == c100v2 then
          c100v1 = v48
          c100v2 = 1
          c100v1(c100v2)
          c100v1 = 1
          v28 = c100v1
          c100v1 = 0
          v29 = c100v1
          c100v1 = 0.6
          v30 = c100v1
        end
      end
    end
    do return end
  end
  v69 = function(c101v0)
    local c101v1, c101v2
    c101v1 = v11
    if not c101v1 then
      c101v2 = v15
      c101v1 = IsNull
      c101v1 = c101v1(c101v2)
      if not c101v1 then
        c101v1 = v15
        c101v1 = c101v1.mType
        c101v2 = v0
        c101v2 = c101v2.INPUTCOUNT
        if c101v1 == c101v2 then
          c101v1 = v48
          c101v2 = -1
          c101v1(c101v2)
          c101v1 = -1
          v28 = c101v1
          c101v1 = 0
          v29 = c101v1
          c101v1 = 0.6
          v30 = c101v1
        end
      end
    end
    do return end
  end
  v70 = function()
    local c102v0
    c102v0 = nil
    v28 = c102v0
    do return end
  end
  v71 = function(c103v0, c103v1)
    local c103v2
    if c103v1 then
      c103v2 = v68
      c103v2(c103v0)
      do return end
    end
    c103v2 = v70
    c103v2()
    do return end
  end
  IncreaseCount = v71
  v71 = function(c104v0, c104v1)
    local c104v2
    if c104v1 then
      c104v2 = v69
      c104v2(c104v0)
      do return end
    end
    c104v2 = v70
    c104v2()
    do return end
  end
  DecreaseCount = v71
  v71 = function()
    local c105v0
    c105v0 = v70
    c105v0()
    do return end
  end
  ConcludeCount = v71
  v71 = function()
    local c106v0, c106v1
    c106v0 = v11
    if not c106v0 then
      c106v1 = v15
      c106v0 = IsNull
      c106v0 = c106v0(c106v1)
      if not c106v0 then
        c106v0 = v15
        c106v0 = c106v0.mType
        c106v1 = v0
        c106v1 = c106v1.INPUTCOUNT
        if c106v0 == c106v1 then
          c106v0 = v68
          c106v1 = v15
          c106v1 = c106v1.Id
          c106v0(c106v1)
        end
      end
    end
    c106v0 = true
    do return c106v0 end
  end
  onKeyDown_MENU_RTRIGGER2 = v71
  v71 = function()
    local c107v0, c107v1
    c107v0 = v11
    if not c107v0 then
      c107v1 = v15
      c107v0 = IsNull
      c107v0 = c107v0(c107v1)
      if not c107v0 then
        c107v0 = v15
        c107v0 = c107v0.mType
        c107v1 = v0
        c107v1 = c107v1.INPUTCOUNT
        if c107v0 == c107v1 then
          c107v0 = v69
          c107v1 = v15
          c107v1 = c107v1.Id
          c107v0(c107v1)
        end
      end
    end
    c107v0 = true
    do return c107v0 end
  end
  onKeyDown_MENU_LTRIGGER2 = v71
  v71 = function()
    local c108v0
    c108v0 = v70
    c108v0()
    c108v0 = true
    do return c108v0 end
  end
  onKeyUp_MENU_LTRIGGER2 = v71
  v71 = function()
    local c109v0
    c109v0 = v70
    c109v0()
    c109v0 = true
    do return c109v0 end
  end
  onKeyUp_MENU_RTRIGGER2 = v71
  v71 = function()
    local c110v0, c110v1
    c110v0 = v53
    c110v1 = true
    c110v0(c110v1)
    c110v0 = true
    do return c110v0 end
  end
  onKeyUp_HIDE_PAUSE_MENU = v71
  v71 = function()
    local c111v0, c111v1, c111v2, c111v3, c111v4, c111v5, c111v6, c111v7
    c111v0 = v12
    c111v0 = c111v0.mSelectedElementIndex
    if c111v0 == nil then
      c111v3 = 1
      c111v4 = v12
      c111v4 = c111v4.mElements
      c111v1 = #c111v4
      c111v2 = 1
      for __renovice_for_0_0 = c111v3, c111v1, c111v2 do
        c111v5 = v12
        c111v5 = c111v5.mElements
        c111v4 = c111v5[__renovice_for_0_0]
        if not c111v4 then
          continue
        end
        c111v5 = c111v4.mType
        c111v6 = v0
        c111v6 = c111v6.INPUTBOX
        if c111v5 ~= c111v6 then
          continue
        end
        c111v5 = c111v4.InputField
        c111v5 = c111v5.mSelected
        if not c111v5 then
          continue
        end
        c111v0 = c111v4.mIndex
      end
    end
    c111v1 = c111v0
    if c111v1 == nil then
      do return end
    end
    c111v4 = c111v1 + 1
    c111v5 = v12
    c111v5 = c111v5.mElements
    c111v2 = #c111v5
    c111v3 = 1
    for __renovice_for_1_0 = c111v4, c111v2, c111v3 do
      c111v6 = v12
      c111v6 = c111v6.mElements
      c111v5 = c111v6[__renovice_for_1_0]
      if not c111v5 then
        continue
      end
      c111v6 = c111v5.mType
      c111v7 = v0
      c111v7 = c111v7.INPUTBOX
      if c111v6 ~= c111v7 then
        continue
      end
      c111v1 = __renovice_for_1_0
    end
    if c111v1 == c111v0 then
      c111v4 = 1
      c111v2 = c111v1 - 1
      c111v3 = 1
      for __renovice_for_2_0 = c111v4, c111v2, c111v3 do
        c111v6 = v12
        c111v6 = c111v6.mElements
        c111v5 = c111v6[__renovice_for_2_0]
        if not c111v5 then
          continue
        end
        c111v6 = c111v5.mType
        c111v7 = v0
        c111v7 = c111v7.INPUTBOX
        if c111v6 ~= c111v7 then
          continue
        end
        c111v1 = __renovice_for_2_0
      end
    end
    if c111v1 ~= c111v0 then
      c111v2 = print
      c111v3 = "found"
      c111v2(c111v3, c111v1)
      c111v2 = v12
      c111v2:SelectElement(c111v1)
    end
    c111v2 = true
    do return c111v2 end
  end
  onKeyDown_NEXT_MENU = v71
  v71 = function(c112v0)
    do return end
  end
  ConfirmPopup = v71
  v71 = function(c113v0)
    local c113v1, c113v2
    c113v1 = v1
    c113v1 = c113v1.DoOpenWebBrowser
    c113v1(c113v0)
    c113v1 = v2
    c113v1 = c113v1.OnHyperlinkPressed
    c113v2 = mMovie
    c113v1(c113v2)
    do return end
  end
  ShowHyperlinkItem = v71
  v71 = function(c114v0)
    local c114v1, c114v2, c114v3, c114v4, c114v5, c114v6, c114v7
    c114v1 = IsNull
    c114v1 = c114v1(c114v0)
    if not c114v1 then
      c114v1 = mMovie
      c114v3 = "<CHECKMARK>"
      c114v4 = true
      c114v1 = c114v1:GetLocalized(c114v3, c114v4)
      c114v2 = mMovie
      c114v4 = "<CHECKMARK_OUTLINE>"
      c114v5 = true
      c114v2 = c114v2:GetLocalized(c114v4, c114v5)
      c114v3 = c114v0.Parent
      c114v4 = true
      c114v3.mValue = c114v4
      c114v6 = " "
      c114v7 = c114v0.mBaseLabel
      c114v5 = c114v1 .. c114v6 .. c114v7
      c114v0:SetText(c114v5)
      c114v3 = c114v0.Parent
      c114v3 = c114v3.NoBtn
      c114v6 = " "
      c114v7 = c114v0.Parent
      c114v7 = c114v7.NoBtn
      c114v7 = c114v7.mBaseLabel
      c114v5 = c114v2 .. c114v6 .. c114v7
      c114v3:SetText(c114v5)
      c114v3 = v60
      c114v3()
    end
    do return end
  end
  YesButton = v71
  v71 = function(c115v0)
    local c115v1, c115v2, c115v3, c115v4, c115v5, c115v6, c115v7
    c115v1 = IsNull
    c115v1 = c115v1(c115v0)
    if not c115v1 then
      c115v1 = mMovie
      c115v3 = "<CHECKMARK>"
      c115v4 = true
      c115v1 = c115v1:GetLocalized(c115v3, c115v4)
      c115v2 = mMovie
      c115v4 = "<CHECKMARK_OUTLINE>"
      c115v5 = true
      c115v2 = c115v2:GetLocalized(c115v4, c115v5)
      c115v3 = c115v0.Parent
      c115v4 = false
      c115v3.mValue = c115v4
      c115v6 = " "
      c115v7 = c115v0.mBaseLabel
      c115v5 = c115v1 .. c115v6 .. c115v7
      c115v0:SetText(c115v5)
      c115v3 = c115v0.Parent
      c115v3 = c115v3.YesBtn
      c115v6 = " "
      c115v7 = c115v0.Parent
      c115v7 = c115v7.YesBtn
      c115v7 = c115v7.mBaseLabel
      c115v5 = c115v2 .. c115v6 .. c115v7
      c115v3:SetText(c115v5)
      c115v3 = v60
      c115v3()
    end
    do return end
  end
  NoButton = v71
  v71 = function(c116v0)
    local c116v1, c116v2, c116v3, c116v4, c116v5, c116v6, c116v7, c116v8
    c116v1 = IsNull
    c116v1 = c116v1(c116v0)
    if not c116v1 then
      c116v1 = mMovie
      c116v3 = "<CHECKMARK>"
      c116v4 = true
      c116v1 = c116v1:GetLocalized(c116v3, c116v4)
      c116v2 = mMovie
      c116v4 = "<CHECKMARK_OUTLINE>"
      c116v5 = true
      c116v2 = c116v2:GetLocalized(c116v4, c116v5)
      c116v3 = c116v0.Parent
      c116v3 = c116v3.mValue
      if not c116v3 then
        c116v3 = c116v0.Parent
        c116v4 = true
        c116v3.mValue = c116v4
        c116v7 = c116v0.mBaseLabel
        c116v5 = c116v1 .. c116v7
        c116v0:SetText(c116v5)
        c116v3 = _T
        c116v5 = _T.PrivacyCounter
        c116v4 = c116v5 + 1
        c116v3.PrivacyCounter = c116v4
      else
        c116v3 = c116v0.Parent
        c116v4 = false
        c116v3.mValue = c116v4
        c116v7 = c116v0.mBaseLabel
        c116v5 = c116v2 .. c116v7
        c116v0:SetText(c116v5)
        c116v3 = _T
        c116v5 = _T.PrivacyCounter
        c116v4 = c116v5 - 1
        c116v3.PrivacyCounter = c116v4
      end
      c116v3 = _T.PrivacyCounter
      c116v4 = _T.SettingsAmount
      if c116v4 <= c116v3 then
        c116v3 = SetConfirmButtonActive
        c116v4 = "true"
        c116v3(c116v4)
        c116v3 = SetConfirmButtonVisibleWhenInactive
        c116v4 = "false"
        c116v3(c116v4)
      else
        c116v3 = SetConfirmButtonVisibleWhenInactive
        c116v4 = "true"
        c116v3(c116v4)
        c116v3 = SetConfirmButtonActiveOverride
        c116v4 = "false"
        c116v3(c116v4)
      end
      c116v8 = _T.PrivacyCounter
      c116v7 = tostring
      c116v4 = c116v7(c116v8)
      c116v5 = "/"
      c116v6 = _T.SettingsAmount
      c116v3 = c116v4 .. c116v5 .. c116v6
      c116v4 = mMovie
      c116v6 = "Container.CounterElement.Label"
      c116v7 = 36
      c116v4:SetStringVariable(c116v6, c116v7, c116v3)
      c116v4 = v60
      c116v4()
    end
    do return end
  end
  CheckmarkButton = v71
  v71 = function(c117v0)
    local c117v1, c117v2, c117v3, c117v4, c117v5, c117v6, c117v7, c117v8, c117v9, c117v10, c117v11, c117v12, c117v13, c117v14
    c117v1 = tonumber
    c117v0 = c117v1(c117v0)
    c117v1 = mMovie
    c117v3 = "_root"
    c117v4 = 0
    c117v1 = c117v1:GetNumberVariable(c117v3, c117v4)
    c117v2 = mMovie
    c117v4 = "_root"
    c117v5 = 1
    c117v2 = c117v2:GetNumberVariable(c117v4, c117v5)
    c117v3 = mMovie
    c117v5 = "_root"
    c117v6 = 14
    c117v3 = c117v3:GetNumberVariable(c117v5, c117v6)
    c117v4 = mMovie
    c117v6 = "_root"
    c117v7 = 15
    c117v4 = c117v4:GetNumberVariable(c117v6, c117v7)
    c117v5 = mMovie
    c117v7 = "_root"
    c117v8 = 5
    c117v5:SetNumberVariable(c117v7, c117v8, c117v0)
    c117v5 = mMovie
    c117v7 = "_root"
    c117v8 = 6
    c117v5:SetNumberVariable(c117v7, c117v8, c117v0)
    c117v5 = mMovie
    c117v7 = "_root"
    c117v8 = 0
    c117v13 = c117v0 / 100
    c117v12 = c117v3 * c117v13
    c117v11 = c117v12 - c117v3
    c117v10 = c117v11 / 2
    c117v9 = c117v1 - c117v10
    c117v5:SetNumberVariable(c117v7, c117v8, c117v9)
    c117v5 = mMovie
    c117v7 = "_root"
    c117v8 = 1
    c117v14 = c117v0 / 100
    c117v13 = c117v4 * c117v14
    c117v12 = c117v13 - c117v4
    c117v11 = c117v12 / 2
    c117v10 = c117v2 - c117v11
    c117v9 = c117v10 - 30
    c117v5:SetNumberVariable(c117v7, c117v8, c117v9)
    do return end
  end
  SetScale = v71
  v71 = function(c118v0)
    local c118v1, c118v2
    c118v1 = v1
    c118v1 = c118v1.PlaySound
    c118v2 = _G
    c118v2 = c118v2.UISound_Error
    c118v1(c118v2)
    do return end
  end
  InputBoxTextLimited = v71
  v71 = function(c119v0)
    local c119v1
    if c119v0 ~= "true" then
      c119v1 = false
    else
      c119v1 = true
    end
    v44 = c119v1
    do return end
  end
  CenterTitles = v71
  v71 = function()
    local c120v0
    c120v0 = true
    do return c120v0 end
  end
  SupportsThemes = v71
  v71 = function()
    local c121v0, c121v1
    local __renovice_state_0 = 0
    c121v0 = Engine.IsMobile
    c121v0 = c121v0()
    if not c121v0 then
      __renovice_state_0 = 6
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c121v0 = v50
      c121v1 = -4
      c121v0.ConfirmY = c121v1
      c121v0 = v50
      c121v1 = 20
      c121v0.ConfirmX = c121v1
      c121v0 = v50
      c121v1 = -7
      c121v0.CheckboxY = c121v1
      c121v1 = _T.SettingsAmount
      c121v0 = IsNull
      c121v0 = c121v0(c121v1)
      if c121v0 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c121v0 = _T.SettingsAmount
      c121v1 = 2
      if not (c121v1 < c121v0) then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c121v0 = v50
      c121v1 = -150
      c121v0.ContainerYPos = c121v1
      c121v0 = v50
      c121v1 = -85
      c121v0.ContainerXPos = c121v1
      __renovice_state_0 = 5
    end
    if __renovice_state_0 == 4 then
      c121v0 = v50
      c121v1 = -80
      c121v0.ContainerYPos = c121v1
      c121v0 = v50
      c121v1 = -85
      c121v0.ContainerXPos = c121v1
      __renovice_state_0 = 5
    end
    if __renovice_state_0 == 5 then
      c121v0 = v50
      c121v1 = -3
      c121v0.ExtraXOffset = c121v1
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 6 then
      do return end
    end
    do return end
  end
  SetIOSPrivacyNoticeLayout = v71
  v71 = function(c122v0)
    local c122v1, c122v2
    c122v1 = Engine.IsMobile
    c122v1 = c122v1()
    if c122v1 then
      c122v1 = v50
      c122v2 = -4
      c122v1.ConfirmY = c122v2
      c122v1 = v50
      c122v2 = -5
      c122v1.ConfirmX = c122v2
      c122v1 = v50
      c122v2 = -60
      c122v1.ContainerYPos = c122v2
      c122v1 = v50
      c122v2 = -130
      c122v1.ContainerXPos = c122v2
      c122v1 = v50
      c122v2 = 9
      c122v1.ExtraXOffset = c122v2
      c122v1 = true
      v51 = c122v1
    end
    do return end
  end
  SetIOSMarketingSignUpLayout = v71
  v71 = function()
    local c123v0, c123v1, c123v2, c123v3, c123v4, c123v5, c123v6, c123v7
    local __renovice_state_0 = 0
    c123v0 = Engine.IsMobile
    c123v0 = c123v0()
    if not c123v0 then
      __renovice_state_0 = 6
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.SearchBox.duplicateMovieClip"
      c123v3 = "CounterElement"
      c123v4 = 1000
      c123v0(c123v1, c123v2, c123v3, c123v4)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.Blurer.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.Backer.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.Underline2.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.Underline.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.HighlightMask.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.Highlight.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.Btn.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = FlashMethod
      c123v1 = mMovie
      c123v2 = "Container.CounterElement.BtnAlt.removeMovieClip"
      c123v0(c123v1, c123v2)
      c123v0 = mMovie
      c123v2 = "Container.CounterElement.Hint"
      c123v3 = 13
      c123v4 = false
      c123v0:Name__863e56e7(c123v2, c123v3, c123v4)
      c123v0 = mMovie
      c123v2 = "Container.CounterElement.Callout"
      c123v3 = 13
      c123v4 = false
      c123v0:Name__863e56e7(c123v2, c123v3, c123v4)
      c123v0 = mMovie
      c123v2 = "Container.CounterElement.ClearSearchLabel"
      c123v3 = 13
      c123v4 = false
      c123v0:Name__863e56e7(c123v2, c123v3, c123v4)
      c123v0 = mMovie
      c123v2 = "Container.ButtonContainer"
      c123v3 = 0
      c123v0 = c123v0:GetNumberVariable(c123v2, c123v3)
      c123v1 = mMovie
      c123v3 = "Container.ButtonContainer"
      c123v4 = 1
      c123v1 = c123v1:GetNumberVariable(c123v3, c123v4)
      c123v3 = _T.SettingsAmount
      c123v2 = IsNull
      c123v2 = c123v2(c123v3)
      if c123v2 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 2
      end
    end
    if __renovice_state_0 == 2 then
      c123v2 = _T.SettingsAmount
      c123v3 = 2
      if not (c123v3 < c123v2) then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c123v2 = mMovie
      c123v4 = "Container.CounterElement"
      c123v5 = 0
      c123v6 = c123v0 + 240
      c123v2:SetNumberVariable(c123v4, c123v5, c123v6)
      c123v2 = mMovie
      c123v4 = "Container.CounterElement"
      c123v5 = 1
      c123v6 = c123v1 + 250
      c123v2:SetNumberVariable(c123v4, c123v5, c123v6)
      __renovice_state_0 = 5
    end
    if __renovice_state_0 == 4 then
      c123v2 = mMovie
      c123v4 = "Container.CounterElement"
      c123v5 = 0
      c123v6 = c123v0 + 240
      c123v2:SetNumberVariable(c123v4, c123v5, c123v6)
      c123v2 = mMovie
      c123v4 = "Container.CounterElement"
      c123v5 = 1
      c123v2:SetNumberVariable(c123v4, c123v5, c123v1)
      __renovice_state_0 = 5
    end
    if __renovice_state_0 == 5 then
      c123v2 = mMovie
      c123v4 = "Container.CounterElement.Label"
      c123v5 = 44
      c123v6 = v27
      c123v6 = c123v6.FloatingContent
      c123v2:SetNumberVariable(c123v4, c123v5, c123v6)
      c123v7 = _T.PrivacyCounter
      c123v6 = tostring
      c123v3 = c123v6(c123v7)
      c123v4 = "/"
      c123v5 = _T.SettingsAmount
      c123v2 = c123v3 .. c123v4 .. c123v5
      c123v3 = mMovie
      c123v5 = "Container.CounterElement.Label"
      c123v6 = 36
      c123v3:SetStringVariable(c123v5, c123v6, c123v2)
      c123v3 = mMovie
      c123v5 = "Container.CounterElement"
      c123v6 = 13
      c123v7 = true
      c123v3:Name__863e56e7(c123v5, c123v6, c123v7)
      c123v3 = v59
      c123v3()
      __renovice_state_0 = 6
    end
    if __renovice_state_0 == 6 then
      do return end
    end
    do return end
  end
  SetCounterElement = v71
  v71 = function(c124v0)
    local c124v1, c124v2, c124v3, c124v4
    c124v1 = mMovie
    c124v2 = "_root"
    c124v3 = 13
    if c124v0 ~= "true" then
      c124v4 = false
    else
      c124v4 = true
    end
    c124v1:Name__863e56e7(c124v2, c124v3, c124v4)
    do return end
  end
  ShowHideMenu = v71
  v71 = function(c125v0)
    local c125v1, c125v2, c125v3
    c125v2 = v35
    c125v1 = IsNull
    c125v1 = c125v1(c125v2)
    if c125v1 then
      do return end
    end
    c125v1 = v35
    if c125v0 ~= "true" then
      c125v3 = false
    else
      c125v3 = true
    end
    c125v1:SetVisible(c125v3)
    do return end
  end
  ShowHideSearchBox = v71
  do return end
