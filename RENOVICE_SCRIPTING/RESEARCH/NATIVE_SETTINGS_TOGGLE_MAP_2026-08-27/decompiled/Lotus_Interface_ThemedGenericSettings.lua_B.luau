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
    local c1497v0, c1497v1, c1497v2, c1497v3
    c1497v0 = _T
    c1497v1 = nil
    c1497v0.gToolTip = c1497v1
    c1497v1 = v23
    c1497v0 = IsNull
    c1497v0 = c1497v0(c1497v1)
    if not c1497v0 then
      c1497v0 = v24
      if c1497v0 then
        c1497v0 = v23
        c1497v0:Close()
      else
        c1497v0 = v4
        c1497v0 = c1497v0.IsVisible
        c1497v0 = c1497v0()
        if c1497v0 then
          c1497v0 = v4
          c1497v0 = c1497v0.CloseIME
          c1497v1 = v23
          c1497v0(c1497v1)
        end
      end
    end
    c1497v0 = v19
    if not c1497v0 then
      c1497v1 = v18
      c1497v0 = IsNull
      c1497v0 = c1497v0(c1497v1)
      if not c1497v0 then
        c1497v2 = _T
        c1497v3 = v18
        c1497v1 = c1497v2[c1497v3]
        c1497v0 = IsNull
        c1497v0 = c1497v0(c1497v1)
        if not c1497v0 then
          c1497v0 = true
          v19 = c1497v0
          c1497v1 = _T
          c1497v2 = v18
          c1497v0 = c1497v1[c1497v2]
          c1497v1 = v21
          c1497v2 = true
          c1497v0(c1497v1, c1497v2)
        end
      end
    end
    do return end
  end
  Shutdown = v52
  v52 = function(c1498v0)
    local c1498v1, c1498v2
    c1498v2 = tostring
    c1498v2 = c1498v2(c1498v0)
    c1498v1 = string.len
    c1498v1 = c1498v1(c1498v2)
    do return c1498v1 end
  end
  v53 = function(c1501v0)
    local c1501v1, c1501v2, c1501v3, c1501v4, c1501v5, c1501v6, c1501v7, c1501v8, c1501v9, c1501v10
    c1501v1 = v37
    if not ((c1501v1 or not c1501v0)) then
      do return end
    end
    c1501v1 = true
    v11 = c1501v1
    c1501v1 = ipairs
    c1501v2 = v21
    c1501v1, c1501v2, c1501v3 = c1501v1(c1501v2)
    for c1501v4, c1501v5 in c1501v1, c1501v2, c1501v3 do
      c1501v6 = c1501v5.mChanged
      if c1501v6 then
        c1501v7 = c1501v5.mOnValidateSetting
        c1501v6 = IsNull
        c1501v6 = c1501v6(c1501v7)
        if not c1501v6 then
          c1501v6 = IsNull
          c1501v6 = c1501v6(c1501v0)
          if c1501v6 then
            c1501v6 = c1501v5.mOnValidateSetting
            c1501v6, c1501v7 = c1501v6()
            if not c1501v6 then
              c1501v8 = v1
              c1501v8 = c1501v8.ShowMessage
              c1501v8(c1501v7)
              c1501v8 = false
              v11 = c1501v8
              do return end
            end
          end
        end
      end
    end
    c1501v1 = FlashInterpolate
    c1501v2 = mMovie
    c1501v3 = "_root"
    c1501v4 = 0
    c1501v6 = 12
    c1501v5 = {c1501v6}
    c1501v7 = 0
    c1501v6 = {c1501v7}
    c1501v7 = 0.2
    c1501v1(c1501v2, c1501v3, c1501v4, c1501v5, c1501v6, c1501v7)
    c1501v1 = function(c1499v0)
      local c1499v1, c1499v3, c1499v4
      c1499v1 = mMovie
      c1499v4 = 1 - c1499v0
      c1499v3 = c1499v4 * 0.9
      c1499v1:SetBackgroundAlpha(c1499v3)
      do return end
    end
    c1501v2 = FlashInterpolate
    c1501v3 = mMovie
    c1501v4 = "_level0"
    c1501v5 = 0
    c1501v6 = {c1501v1}
    c1501v8 = 1
    c1501v7 = {c1501v8}
    c1501v8 = 0.3
    c1501v9 = 0.1
    c1501v10 = function()
      local c1500v0, c1500v1, c1500v2, c1500v3
      c1500v0 = v19
      if not c1500v0 then
        c1500v1 = v18
        c1500v0 = IsNull
        c1500v0 = c1500v0(c1500v1)
        if not c1500v0 then
          c1500v2 = _T
          c1500v3 = v18
          c1500v1 = c1500v2[c1500v3]
          c1500v0 = IsNull
          c1500v0 = c1500v0(c1500v1)
          if not c1500v0 then
            c1500v0 = true
            v19 = c1500v0
            c1500v1 = _T
            c1500v2 = v18
            c1500v0 = c1500v1[c1500v2]
            c1500v1 = v21
            c1500v2 = c1501v0
            c1500v0(c1500v1, c1500v2)
          end
        end
      end
      c1500v0 = mMovie
      c1500v0:Close()
      do return end
    end
    c1501v2(c1501v3, c1501v4, c1501v5, c1501v6, c1501v7, c1501v8, c1501v9, c1501v10)
    do return end
  end
  v54 = function()
    local c1502v0
    c1502v0 = v53
    c1502v0()
    do return end
  end
  TransitionOut = v54
  v54 = function()
    local c1504v0, c1504v2
    c1504v0 = {}
    v21 = c1504v0
    c1504v0 = v12
    c1504v2 = function(c1503v0)
      local c1503v1, c1503v2, c1503v3, c1503v4, c1503v5, c1503v6, c1503v8, c1503v9
      c1503v1 = c1503v0.mType
      c1503v2 = v21
      c1503v2 = c1503v2.INPUTBOX
      if c1503v1 == c1503v2 then
        c1503v1 = mMovie
        c1503v3 = c1503v0.InputField
        c1503v3 = c1503v3.mLabelClipName
        c1503v4 = 36
        c1503v1 = c1503v1:GetStringVariable(c1503v3, c1503v4)
        c1503v0.mContent = c1503v1
        c1503v1 = FindInvalidCharacter
        c1503v2 = c1503v0.mContent
        c1503v3 = nil
        c1503v1 = c1503v1(c1503v2, c1503v3)
        c1503v2 = 0
        if c1503v2 < c1503v1 then
          c1503v2 = v1
          c1503v2 = c1503v2.ShowErrorMessage
          c1503v6 = mMovie
          c1503v8 = "/Lotus/Language/Menu/SocialOverlay_InvalidCharacter"
          c1503v9 = false
          c1503v4 = c1503v6:GetLocalized(c1503v8, c1503v9)
          c1503v5 = Name__a2383d22
          c1503v6 = c1503v0.mContent
          c1503v5 = c1503v5(c1503v6, c1503v1, c1503v1)
          c1503v3 = c1503v4 .. c1503v5
          c1503v2(c1503v3)
          c1503v2 = c1503v0.mOriginalValue
          c1503v0.mContent = c1503v2
          c1503v2 = c1503v0.mContent
          if c1503v2 == nil then
            c1503v2 = ""
            c1503v0.mContent = c1503v2
          end
          c1503v2 = mMovie
          c1503v4 = c1503v0.InputField
          c1503v4 = c1503v4.mLabelClipName
          c1503v5 = 36
          c1503v6 = c1503v0.mOriginalValue
          c1503v2:SetStringVariable(c1503v4, c1503v5, c1503v6)
        end
      end
      c1503v2 = v21
      c1503v1 = table.insert
      c1503v1(c1503v2, c1503v0)
      do return end
    end
    c1504v0:RunForAllElements(c1504v2)
    do return end
  end
  v55 = function()
    local c1505v0, c1505v1, c1505v2
    c1505v0 = v37
    if not c1505v0 then
      do return end
    end
    c1505v0 = v54
    c1505v0()
    c1505v0 = false
    c1505v1 = v1
    c1505v1 = c1505v1.PlaySound
    c1505v2 = _G
    c1505v2 = c1505v2.UISound_WindowClose
    c1505v1(c1505v2)
    c1505v1 = _T.BackgroundMovie
    if c1505v1 ~= nil then
      c1505v1 = _T.IsInScreenStack
      c1505v2 = "ItemBrowsing"
      c1505v0 = c1505v1(c1505v2)
    end
    if c1505v0 then
      c1505v1 = _T.GoToPreviousScreen
      c1505v1()
      do return end
    end
    c1505v1 = v53
    c1505v2 = true
    c1505v1(c1505v2)
    do return end
  end
  v56 = function()
    local c1506v0
    c1506v0 = v54
    c1506v0()
    c1506v0 = v53
    c1506v0()
    do return end
  end
  v57 = function()
    local c1507v0, c1507v1, c1507v2, c1507v3, c1507v4, c1507v5, c1507v6, c1507v7, c1507v8, c1507v9, c1507v10, c1507v11, c1507v12
    c1507v0 = v27
    c1507v1 = v3
    c1507v1 = c1507v1.GetColor
    c1507v2 = 9
    c1507v3 = true
    c1507v1 = c1507v1(c1507v2, c1507v3)
    c1507v0.FloatingContent = c1507v1
    c1507v0 = v27
    c1507v1 = v3
    c1507v1 = c1507v1.GetColor
    c1507v2 = 10
    c1507v3 = true
    c1507v1 = c1507v1(c1507v2, c1507v3)
    c1507v0.FloatingContentHighlight = c1507v1
    c1507v0 = v27
    c1507v1 = v3
    c1507v1 = c1507v1.GetColor
    c1507v2 = 2
    c1507v3 = true
    c1507v1 = c1507v1(c1507v2, c1507v3)
    c1507v0.Background = c1507v1
    c1507v0 = v27
    c1507v1 = v3
    c1507v1 = c1507v1.GetColor
    c1507v2 = 6
    c1507v3 = true
    c1507v1 = c1507v1(c1507v2, c1507v3)
    c1507v0.Content = c1507v1
    c1507v0 = v27
    c1507v1 = v1
    c1507v1 = c1507v1.ConvertColorNumberToProceduralRGB
    c1507v2 = v27
    c1507v2 = c1507v2.Background
    c1507v1 = c1507v1(c1507v2)
    c1507v0.BackgroundProcedural = c1507v1
    c1507v0 = v27
    c1507v1 = v1
    c1507v1 = c1507v1.ConvertColorNumberToProceduralRGB
    c1507v2 = v27
    c1507v2 = c1507v2.FloatingContent
    c1507v1 = c1507v1(c1507v2)
    c1507v0.FloatingContentProcedural = c1507v1
    c1507v0 = v27
    c1507v1 = v1
    c1507v1 = c1507v1.ConvertColorNumberToProceduralRGB
    c1507v2 = v27
    c1507v2 = c1507v2.FloatingContentHighlight
    c1507v1 = c1507v1(c1507v2)
    c1507v0.FloatingContentHighlightProcedural = c1507v1
    c1507v0 = v27
    c1507v1 = v1
    c1507v1 = c1507v1.ConvertColorNumberToProceduralRGB
    c1507v2 = v27
    c1507v2 = c1507v2.Content
    c1507v1 = c1507v1(c1507v2)
    c1507v0.ContentHighlightProcedural = c1507v1
    c1507v0 = mMovie
    c1507v2 = "Container.Title"
    c1507v3 = 44
    c1507v4 = v27
    c1507v4 = c1507v4.FloatingContent
    c1507v0:SetNumberVariable(c1507v2, c1507v3, c1507v4)
    c1507v0 = mMovie
    c1507v2 = "Container.BgFill"
    c1507v3 = _G
    c1507v3 = c1507v3.UIMaterial_RectangleNoDepth
    c1507v0:OverrideMaterial(c1507v2, c1507v3)
    c1507v0 = mMovie
    c1507v2 = "Container.BgFill"
    c1507v3 = "RectInnerColor"
    c1507v4 = v27
    c1507v4 = c1507v4.BackgroundProcedural
    c1507v4 = c1507v4.r
    c1507v5 = v27
    c1507v5 = c1507v5.BackgroundProcedural
    c1507v5 = c1507v5.g
    c1507v6 = v27
    c1507v6 = c1507v6.BackgroundProcedural
    c1507v6 = c1507v6.b
    c1507v7 = 0.8
    c1507v0:Name__e243d995(c1507v2, c1507v3, c1507v4, c1507v5, c1507v6, c1507v7)
    c1507v0 = mMovie
    c1507v2 = "Container.BgFill"
    c1507v3 = "RectEdgeColor"
    c1507v4 = v27
    c1507v4 = c1507v4.FloatingContentProcedural
    c1507v4 = c1507v4.r
    c1507v5 = v27
    c1507v5 = c1507v5.FloatingContentProcedural
    c1507v5 = c1507v5.g
    c1507v6 = v27
    c1507v6 = c1507v6.FloatingContentProcedural
    c1507v6 = c1507v6.b
    c1507v7 = 0.1
    c1507v0:Name__e243d995(c1507v2, c1507v3, c1507v4, c1507v5, c1507v6, c1507v7)
    c1507v0 = mMovie
    c1507v2 = v27
    c1507v2 = c1507v2.Background
    c1507v0:SetBackgroundColor(c1507v2)
    c1507v1 = "FancyBits.LeftLines"
    c1507v2 = "FancyBits.RightLines"
    c1507v3 = "FancyBits.LeftSideLine.FadeLineTop"
    c1507v4 = "FancyBits.LeftSideLine.FadeLineMiddle"
    c1507v5 = "FancyBits.LeftSideLine.FadeLineBottom"
    c1507v6 = "FancyBits.RightSideLine.FadeLineTop"
    c1507v7 = "FancyBits.RightSideLine.FadeLineMiddle"
    c1507v8 = "FancyBits.RightSideLine.FadeLineBottom"
    c1507v0 = {c1507v1, c1507v2, c1507v3, c1507v4, c1507v5, c1507v6, c1507v7, c1507v8}
    c1507v3 = 1
    c1507v1 = #c1507v0
    c1507v2 = 1
    for c1507v3 = c1507v3, c1507v1, c1507v2 do
      c1507v4 = c1507v0[c1507v3]
      c1507v5 = mMovie
      c1507v8 = 11
      c1507v9 = v27
      c1507v9 = c1507v9.FloatingContent
      c1507v5:SetNumberVariable(c1507v4, c1507v8, c1507v9)
      c1507v5 = mMovie
      c1507v8 = "RipplesColor"
      c1507v9 = v27
      c1507v9 = c1507v9.ContentHighlightProcedural
      c1507v9 = c1507v9.r
      c1507v10 = v27
      c1507v10 = c1507v10.ContentHighlightProcedural
      c1507v10 = c1507v10.g
      c1507v11 = v27
      c1507v11 = c1507v11.ContentHighlightProcedural
      c1507v11 = c1507v11.b
      c1507v12 = 0.9
      c1507v5:Name__e243d995(c1507v4, c1507v8, c1507v9, c1507v10, c1507v11, c1507v12)
    end
    do return end
  end
  v58 = function()
    local c1508v0, c1508v1, c1508v2, c1508v3
    c1508v1 = v42
    c1508v1 = c1508v1.CustomBtn
    c1508v0 = IsNull
    c1508v0 = c1508v0(c1508v1)
    if c1508v0 then
      do return end
    end
    c1508v0 = v42
    c1508v0 = c1508v0.CustomBtn
    c1508v0 = c1508v0.Confirm
    if c1508v0 then
      c1508v0 = mMovie
      c1508v2 = "ShowCustomButtonConfirmation"
      c1508v3 = ""
      c1508v0:Execute(c1508v2, c1508v3)
      do return end
    end
    c1508v0 = v42
    c1508v0 = c1508v0.CustomBtn
    c1508v0 = c1508v0.CallBack
    c1508v0()
    do return end
  end
  OnCustomButtonPressed = v58
  v58 = function(c1509v0, c1509v1)
    local c1509v4, c1509v5, c1509v6, c1509v7, c1509v8, c1509v9, c1509v10, c1509v11
    local c1509v2 = v43
    if c1509v2 == 1 then
      c1509v5 = c1509v1 / 2
      c1509v7 = c1509v0.mMaxSize
      c1509v6 = c1509v7 / 2
      c1509v4 = c1509v5 - c1509v6
      c1509v0:SetPosition(c1509v4)
      do return end
    end
    c1509v2 = v43
    if c1509v2 ~= 1 then
      c1509v2 = Engine.IsMobile
      c1509v2 = c1509v2()
      if not c1509v2 then
        c1509v5 = c1509v1 / 2
        c1509v6 = v1
        c1509v6 = c1509v6.Ternary
        c1509v8 = c1509v0.PositionIdx
        if c1509v8 ~= 1 then
          c1509v7 = false
        else
          c1509v7 = true
        end
        c1509v10 = c1509v0.mMaxSize
        c1509v9 = -c1509v10
        c1509v8 = c1509v9 - 5
        c1509v9 = 5
        c1509v6 = c1509v6(c1509v7, c1509v8, c1509v9)
        c1509v4 = c1509v5 + c1509v6
        c1509v0:SetPosition(c1509v4)
        do return end
      end
      c1509v2 = v51
      if c1509v2 then
        c1509v5 = c1509v1 / 2
        c1509v6 = v1
        c1509v6 = c1509v6.Ternary
        c1509v8 = c1509v0.PositionIdx
        if c1509v8 ~= 1 then
          c1509v7 = false
        else
          c1509v7 = true
        end
        c1509v8 = 60
        c1509v11 = c1509v0.mMaxSize
        c1509v10 = -c1509v11
        c1509v9 = c1509v10 - 10
        c1509v6 = c1509v6(c1509v7, c1509v8, c1509v9)
        c1509v4 = c1509v5 + c1509v6
        c1509v0:SetPosition(c1509v4)
        do return end
      end
      c1509v5 = c1509v1 / 2
      c1509v6 = v1
      c1509v6 = c1509v6.Ternary
      c1509v8 = c1509v0.PositionIdx
      if c1509v8 ~= 1 then
        c1509v7 = false
      else
        c1509v7 = true
      end
      c1509v10 = c1509v0.mMaxSize
      c1509v9 = -c1509v10
      c1509v8 = c1509v9 - 10
      c1509v9 = 60
      c1509v6 = c1509v6(c1509v7, c1509v8, c1509v9)
      c1509v4 = c1509v5 + c1509v6
      c1509v0:SetPosition(c1509v4)
      do return end
    end
    c1509v2 = v43
    if c1509v2 == 3 then
      c1509v2 = c1509v0.PositionIdx
      if c1509v2 == 2 then
        c1509v5 = c1509v1 / 2
        c1509v7 = c1509v0.mMaxSize
        c1509v6 = c1509v7 / 2
        c1509v4 = c1509v5 - c1509v6
        c1509v0:SetPosition(c1509v4)
        do return end
      end
      c1509v5 = c1509v1 / 2
      c1509v6 = v1
      c1509v6 = c1509v6.Ternary
      c1509v8 = c1509v0.PositionIdx
      if c1509v8 ~= 1 then
        c1509v7 = false
      else
        c1509v7 = true
      end
      c1509v11 = c1509v0.mMaxSize
      c1509v10 = -c1509v11
      c1509v9 = c1509v10 * 1.5
      c1509v8 = c1509v9 - 10
      c1509v11 = c1509v0.mMaxSize
      c1509v10 = c1509v11 / 2
      c1509v9 = c1509v10 + 10
      c1509v6 = c1509v6(c1509v7, c1509v8, c1509v9)
      c1509v4 = c1509v5 + c1509v6
      c1509v0:SetPosition(c1509v4)
    end
    do return end
  end
  v59 = function()
    local c1510v0, c1510v1, c1510v2, c1510v3, c1510v4, c1510v5, c1510v6, c1510v7, c1510v8, c1510v9, c1510v10, c1510v11
    local p67 = 0
    if p67 == 0 then
      c1510v0 = 0
      v43 = c1510v0
      c1510v0 = false
      c1510v1 = Engine.IsMobile
      c1510v1 = c1510v1()
      if not c1510v1 then
        p67 = 3
      else
        p67 = 1
      end
    end
    if p67 == 1 then
      c1510v1 = _T.UseSpecialButtons
      if not c1510v1 then
        p67 = 3
      else
        p67 = 2
      end
    end
    if p67 == 2 then
      c1510v0 = true
      p67 = 3
    end
    if p67 == 3 then
      c1510v1 = v33
      if c1510v1 then
        p67 = 5
      else
        p67 = 4
      end
    end
    if p67 == 4 then
      c1510v1 = v32
      if not c1510v1 then
        p67 = 11
      else
        p67 = 5
      end
    end
    if p67 == 5 then
      c1510v1 = v42
      c1510v1 = c1510v1.ConfirmBtn
      if c1510v1 ~= nil then
        p67 = 9
      else
        p67 = 6
      end
    end
    if p67 == 6 then
      if not c1510v0 then
        p67 = 8
      else
        p67 = 7
      end
    end
    if p67 == 7 then
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.ConfirmButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.SpecialConfirmButton"
      c1510v4 = 13
      c1510v6 = v34
      c1510v5 = not c1510v6
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = v42
      c1510v2 = v8
      c1510v2 = c1510v2.Create
      c1510v3 = mMovie
      c1510v4 = "Container.ButtonContainer.SpecialConfirmButton"
      c1510v5 = v13
      c1510v6 = "FinishSelection"
      c1510v7 = "<MENU_GENERIC1>"
      c1510v2 = c1510v2(c1510v3, c1510v4, c1510v5, c1510v6, c1510v7)
      c1510v1.ConfirmBtn = c1510v2
      c1510v1 = v42
      c1510v1 = c1510v1.ConfirmBtn
      c1510v1:SetSpecialMode()
      c1510v1 = v42
      c1510v1 = c1510v1.ConfirmBtn
      c1510v1:Redraw()
      p67 = 9
    end
    if p67 == 8 then
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.ConfirmButton"
      c1510v4 = 13
      c1510v6 = v34
      c1510v5 = not c1510v6
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.SpecialConfirmButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = v42
      c1510v2 = v8
      c1510v2 = c1510v2.Create
      c1510v3 = mMovie
      c1510v4 = "Container.ButtonContainer.ConfirmButton"
      c1510v5 = v13
      c1510v6 = "FinishSelection"
      c1510v7 = "<MENU_GENERIC1>"
      c1510v2 = c1510v2(c1510v3, c1510v4, c1510v5, c1510v6, c1510v7)
      c1510v1.ConfirmBtn = c1510v2
      p67 = 9
    end
    if p67 == 9 then
      c1510v1 = v42
      c1510v1 = c1510v1.ConfirmBtn
      c1510v3 = v13
      c1510v1:SetText(c1510v3)
      c1510v1 = v42
      c1510v1 = c1510v1.ConfirmBtn
      c1510v3 = v33
      c1510v1:SetActive(c1510v3)
      c1510v1 = v34
      if c1510v1 then
        p67 = 12
      else
        p67 = 10
      end
    end
    if p67 == 10 then
      c1510v2 = v43
      c1510v1 = c1510v2 + 1
      v43 = c1510v1
      c1510v1 = v42
      c1510v1 = c1510v1.ConfirmBtn
      c1510v2 = v43
      c1510v1.PositionIdx = c1510v2
      p67 = 12
    end
    if p67 == 11 then
      c1510v1 = v42
      c1510v2 = nil
      c1510v1.ConfirmBtn = c1510v2
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.ConfirmButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.SpecialConfirmButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      p67 = 12
    end
    if p67 == 12 then
      c1510v2 = v39
      c1510v1 = IsNull
      c1510v1 = c1510v1(c1510v2)
      if c1510v1 then
        p67 = 24
      else
        p67 = 13
      end
    end
    if p67 == 13 then
      c1510v3 = _T
      c1510v4 = v39
      c1510v2 = c1510v3[c1510v4]
      c1510v1 = IsNull
      c1510v1 = c1510v1(c1510v2)
      if c1510v1 then
        p67 = 24
      else
        p67 = 14
      end
    end
    if p67 == 14 then
      c1510v2 = _T
      c1510v3 = v39
      c1510v1 = c1510v2[c1510v3]
      c1510v1 = c1510v1()
      c1510v2 = v42
      c1510v2 = c1510v2.CustomBtn
      if c1510v2 ~= nil then
        p67 = 18
      else
        p67 = 15
      end
    end
    if p67 == 15 then
      if not c1510v0 then
        p67 = 17
      else
        p67 = 16
      end
    end
    if p67 == 16 then
      c1510v2 = v42
      c1510v3 = v8
      c1510v3 = c1510v3.Create
      c1510v4 = mMovie
      c1510v5 = "Container.ButtonContainer.SpecialCustomButton"
      c1510v6 = c1510v1.Label
      c1510v7 = "OnCustomButtonPressed"
      c1510v9 = "<"
      c1510v10 = c1510v1.CallOut
      c1510v11 = ">"
      c1510v8 = c1510v9 .. c1510v10 .. c1510v11
      c1510v3 = c1510v3(c1510v4, c1510v5, c1510v6, c1510v7, c1510v8)
      c1510v2.CustomBtn = c1510v3
      c1510v2 = v42
      c1510v2 = c1510v2.CustomBtn
      c1510v2:SetSpecialMode()
      c1510v2 = v42
      c1510v2 = c1510v2.CustomBtn
      c1510v2:Redraw()
      p67 = 18
    end
    if p67 == 17 then
      c1510v2 = v42
      c1510v3 = v8
      c1510v3 = c1510v3.Create
      c1510v4 = mMovie
      c1510v5 = "Container.ButtonContainer.CustomButton"
      c1510v6 = c1510v1.Label
      c1510v7 = "OnCustomButtonPressed"
      c1510v9 = "<"
      c1510v10 = c1510v1.CallOut
      c1510v11 = ">"
      c1510v8 = c1510v9 .. c1510v10 .. c1510v11
      c1510v3 = c1510v3(c1510v4, c1510v5, c1510v6, c1510v7, c1510v8)
      c1510v2.CustomBtn = c1510v3
      p67 = 18
    end
    if p67 == 18 then
      c1510v3 = c1510v1.ConfirmCallback
      c1510v2 = IsNull
      c1510v2 = c1510v2(c1510v3)
      if c1510v2 then
        p67 = 20
      else
        p67 = 19
      end
    end
    if p67 == 19 then
      c1510v2 = v41
      c1510v3 = c1510v1.ConfirmLabel
      c1510v2.ConfirmLabel = c1510v3
      c1510v2 = c1510v1.ConfirmCallback
      v40 = c1510v2
      c1510v2 = v42
      c1510v2 = c1510v2.CustomBtn
      c1510v3 = true
      c1510v2.Confirm = c1510v3
      p67 = 21
    end
    if p67 == 20 then
      c1510v2 = v42
      c1510v2 = c1510v2.CustomBtn
      c1510v3 = nil
      c1510v2.Confirm = c1510v3
      c1510v2 = v42
      c1510v2 = c1510v2.CustomBtn
      c1510v3 = c1510v1.CallBack
      c1510v2.CallBack = c1510v3
      p67 = 21
    end
    if p67 == 21 then
      c1510v2 = v41
      c1510v3 = c1510v1.Label
      c1510v2.Label = c1510v3
      c1510v3 = v43
      c1510v2 = c1510v3 + 1
      v43 = c1510v2
      c1510v2 = v42
      c1510v2 = c1510v2.CustomBtn
      c1510v3 = v43
      c1510v2.PositionIdx = c1510v3
      if not c1510v0 then
        p67 = 23
      else
        p67 = 22
      end
    end
    if p67 == 22 then
      c1510v2 = mMovie
      c1510v4 = "Container.ButtonContainer.CustomButton"
      c1510v5 = 13
      c1510v6 = false
      c1510v2:Name__d9713943(c1510v4, c1510v5, c1510v6)
      c1510v2 = mMovie
      c1510v4 = "Container.ButtonContainer.SpecialCustomButton"
      c1510v5 = 13
      c1510v6 = true
      c1510v2:Name__d9713943(c1510v4, c1510v5, c1510v6)
      p67 = 25
    end
    if p67 == 23 then
      c1510v2 = mMovie
      c1510v4 = "Container.ButtonContainer.CustomButton"
      c1510v5 = 13
      c1510v6 = true
      c1510v2:Name__d9713943(c1510v4, c1510v5, c1510v6)
      c1510v2 = mMovie
      c1510v4 = "Container.ButtonContainer.SpecialCustomButton"
      c1510v5 = 13
      c1510v6 = false
      c1510v2:Name__d9713943(c1510v4, c1510v5, c1510v6)
      p67 = 25
    end
    if p67 == 24 then
      c1510v1 = v42
      c1510v2 = nil
      c1510v1.CustomBtn = c1510v2
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.CustomButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.SpecialCustomButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      p67 = 25
    end
    if p67 == 25 then
      c1510v1 = v37
      if not c1510v1 then
        p67 = 32
      else
        p67 = 26
      end
    end
    if p67 == 26 then
      c1510v1 = v42
      c1510v1 = c1510v1.CancelBtn
      if c1510v1 ~= nil then
        p67 = 30
      else
        p67 = 27
      end
    end
    if p67 == 27 then
      if not c1510v0 then
        p67 = 29
      else
        p67 = 28
      end
    end
    if p67 == 28 then
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.CancelButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.SpecialCancelButton"
      c1510v4 = 13
      c1510v6 = v38
      c1510v5 = not c1510v6
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = v42
      c1510v2 = v8
      c1510v2 = c1510v2.Create
      c1510v3 = mMovie
      c1510v4 = "Container.ButtonContainer.SpecialCancelButton"
      c1510v5 = "/Menu/Confirm_Item_Cancel"
      c1510v6 = "ExitScreen"
      c1510v7 = "<MENU_CANCEL>"
      c1510v2 = c1510v2(c1510v3, c1510v4, c1510v5, c1510v6, c1510v7)
      c1510v1.CancelBtn = c1510v2
      c1510v1 = v42
      c1510v1 = c1510v1.CancelBtn
      c1510v1:SetSpecialMode()
      c1510v1 = v42
      c1510v1 = c1510v1.CancelBtn
      c1510v1:Redraw()
      p67 = 30
    end
    if p67 == 29 then
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.CancelButton"
      c1510v4 = 13
      c1510v6 = v38
      c1510v5 = not c1510v6
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.SpecialCancelButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = v42
      c1510v2 = v8
      c1510v2 = c1510v2.Create
      c1510v3 = mMovie
      c1510v4 = "Container.ButtonContainer.CancelButton"
      c1510v5 = "/Menu/Confirm_Item_Cancel"
      c1510v6 = "ExitScreen"
      c1510v7 = "<MENU_CANCEL>"
      c1510v2 = c1510v2(c1510v3, c1510v4, c1510v5, c1510v6, c1510v7)
      c1510v1.CancelBtn = c1510v2
      p67 = 30
    end
    if p67 == 30 then
      c1510v1 = v42
      c1510v1 = c1510v1.CancelBtn
      c1510v3 = v36
      c1510v1:SetText(c1510v3)
      c1510v1 = v38
      if c1510v1 then
        p67 = 33
      else
        p67 = 31
      end
    end
    if p67 == 31 then
      c1510v2 = v43
      c1510v1 = c1510v2 + 1
      v43 = c1510v1
      c1510v1 = v42
      c1510v1 = c1510v1.CancelBtn
      c1510v2 = v43
      c1510v1.PositionIdx = c1510v2
      p67 = 33
    end
    if p67 == 32 then
      c1510v1 = v42
      c1510v2 = nil
      c1510v1.CancelBtn = c1510v2
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.CancelButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      c1510v1 = mMovie
      c1510v3 = "Container.ButtonContainer.SpecialCancelButton"
      c1510v4 = 13
      c1510v5 = false
      c1510v1:Name__d9713943(c1510v3, c1510v4, c1510v5)
      p67 = 33
    end
    if p67 == 33 then
      c1510v1 = v49
      c1510v1()
      c1510v1 = v43
      c1510v2 = 0
      if c1510v1 <= c1510v2 then
        p67 = 40
      else
        p67 = 34
      end
    end
    if p67 == 34 then
      c1510v1 = mMovie
      c1510v3 = "Container.BgFill"
      c1510v4 = 14
      c1510v1 = c1510v1:GetNumberVariable(c1510v3, c1510v4)
      c1510v4 = v43
      c1510v3 = c1510v4 + 1
      c1510v2 = c1510v1 / c1510v3
      c1510v3 = pairs
      c1510v4 = v42
      c1510v3, c1510v4, c1510v5 = c1510v3(c1510v4)
      p67 = 39
    end
    if p67 == 35 then
      c1510v8 = Engine.IsMobile
      c1510v8 = c1510v8()
      if not c1510v8 then
        p67 = 37
      else
        p67 = 36
      end
    end
    if p67 == 36 then
      c1510v10 = c1510v2 * 0.9
      c1510v7:SetWidth(c1510v10)
      p67 = 38
    end
    if p67 == 37 then
      c1510v7:SetWidth(c1510v2)
      p67 = 38
    end
    if p67 == 38 then
      c1510v8 = v58
      c1510v8(c1510v7, c1510v1)
      p67 = 39
    end
    if p67 == 39 then
      p67 = 40
    end
    if p67 == 40 then
      c1510v1 = _T.SetButtons
      c1510v2 = mMovie
      c1510v3 = nil
      c1510v1(c1510v2, c1510v3)
      do return end
    end
  end
  v60 = function(c1511v0)
    local c1511v1, c1511v2, c1511v3, c1511v4
    c1511v1 = v1
    c1511v1 = c1511v1.Ternary
    c1511v2 = IsNull
    c1511v2 = c1511v2(c1511v0)
    c1511v3 = v15
    c1511v0 = c1511v1(c1511v2, c1511v3, c1511v0)
    if c1511v0 == nil then
      do return end
    end
    c1511v1 = true
    c1511v0.mChanged = c1511v1
    c1511v1 = v16
    if c1511v1 ~= nil then
      c1511v1 = v16
      c1511v2 = true
      c1511v1.mChanged = c1511v2
    end
    c1511v1 = true
    v33 = c1511v1
    c1511v2 = v20
    c1511v1 = IsNull
    c1511v1 = c1511v1(c1511v2)
    if not c1511v1 then
      c1511v3 = _T
      c1511v4 = v20
      c1511v2 = c1511v3[c1511v4]
      c1511v1 = IsNull
      c1511v1 = c1511v1(c1511v2)
      if not c1511v1 then
        c1511v1 = c1511v0.mType
        c1511v2 = v0
        c1511v2 = c1511v2.INPUTCOUNT
        if c1511v1 == c1511v2 then
          c1511v2 = _T
          c1511v3 = v20
          c1511v1 = c1511v2[c1511v3]
          c1511v2 = c1511v0.mCount
          c1511v3 = c1511v0.mSetting
          c1511v1(c1511v2, c1511v3)
        else
          c1511v2 = _T
          c1511v3 = v20
          c1511v1 = c1511v2[c1511v3]
          c1511v2 = c1511v0.mValue
          c1511v3 = c1511v0.mSetting
          c1511v1(c1511v2, c1511v3)
        end
      end
    end
    c1511v1 = v59
    c1511v1()
    do return end
  end
  v61 = function(c1512v0)
    local c1512v1, c1512v2
    c1512v1 = v60
    c1512v1()
    c1512v1 = v15
    c1512v1.mValue = c1512v0
    c1512v1 = v15
    c1512v1 = c1512v1.mCallback
    if c1512v1 then
      c1512v1 = v15
      c1512v1 = c1512v1.mCallback
      c1512v1(c1512v0)
    end
    c1512v1 = v12
    c1512v1 = c1512v1.mElementDrawCallback
    c1512v2 = v15
    c1512v1(c1512v2)
    do return end
  end
  v49 = function()
    local c1515v0, c1515v1, c1515v2, c1515v3, c1515v4, c1515v5, c1515v6, c1515v7, c1515v8, c1515v9, c1515v10, c1515v11, c1515v12, c1515v13, c1515v14, c1515v15, c1515v16, c1515v17, c1515v18, c1515v19, c1515v20
    c1515v0 = v1
    c1515v0 = c1515v0.Ternary
    c1515v1 = v45
    c1515v2 = mMovie
    c1515v4 = "Container.Title"
    c1515v5 = 41
    c1515v2 = c1515v2:GetNumberVariable(c1515v4, c1515v5)
    c1515v3 = 0
    c1515v0 = c1515v0(c1515v1, c1515v2, c1515v3)
    c1515v1 = 0
    c1515v2 = 0
    c1515v3 = 0
    c1515v4 = {}
    c1515v5 = v12
    c1515v5 = c1515v5.UniformElementHeights
    if c1515v5 then
      c1515v5 = v12
      c1515v5 = c1515v5:GetHowManyVisibleElements()
      c1515v6 = v12
      c1515v6 = c1515v6.mForcedVerticalSeparation
      c1515v1 = c1515v5 * c1515v6
    end
    c1515v5 = v12
    c1515v7 = function(c1513v0)
      local c1513v1, c1513v2, c1513v3, c1513v4, c1513v5, c1513v6
      c1513v1 = c1515v2
      c1513v1 = c1513v1.UniformElementHeights
      if not c1513v1 then
        c1513v1 = c1515v1
        c1513v2 = c1515v2
        c1513v2 = c1513v2:CalculateHeight(c1513v0)
        c1513v1 = c1513v1 + c1513v2
        c1515v1 = c1513v1
      end
      c1513v1 = c1515v2
      c1513v1 = c1513v1:CalculateWidth(c1513v0)
      c1513v2 = c1515v2
      if c1513v2 < c1513v1 then
        c1515v2 = c1513v1
      end
      c1513v2 = c1513v0.mTextWidth
      if c1513v2 ~= nil then
        c1513v2 = c1513v0.mTextWidth
        c1513v3 = c1515v3
        if c1513v3 < c1513v2 then
          c1513v2 = c1513v0.mTextWidth
          c1515v3 = c1513v2
        end
      end
      c1513v2 = c1513v0.mType
      c1513v3 = v0
      c1513v3 = c1513v3.IMAGE
      if c1513v2 == c1513v3 then
        c1513v2 = mMovie
        c1513v4 = c1513v0.mClipName
        c1513v5 = "Image"
        c1513v6 = 14
        c1513v2 = c1513v2:Name__46690123(c1513v4, c1513v5, c1513v6)
        c1513v3 = 0
        if c1513v3 < c1513v2 then
          c1513v4 = c1515v4
          c1513v3 = table.insert
          c1513v3(c1513v4, c1513v0)
        end
      end
      c1513v2 = c1513v0.mType
      c1513v3 = v0
      c1513v3 = c1513v3.TITLE
      if c1513v2 == c1513v3 then
        c1513v3 = c1513v0.mClipName
        c1513v2 = #c1513v3
        c1513v3 = 0
        if c1513v3 < c1513v2 then
          c1513v3 = c1513v0.mAlignment
          c1513v2 = #c1513v3
          c1513v3 = 0
          if c1513v3 < c1513v2 then
            c1513v2 = mMovie
            c1513v5 = c1513v0.mClipName
            c1513v6 = ".Label"
            c1513v4 = c1513v5 .. c1513v6
            c1513v5 = 45
            c1513v6 = c1513v0.mAlignment
            c1513v2:SetStringVariable(c1513v4, c1513v5, c1513v6)
          end
        end
      end
      do return end
    end
    c1515v5:RunForAllElements(c1515v7)
    c1515v5 = v1
    c1515v5 = c1515v5.Ternary
    if c1515v0 ~= 0 then
      c1515v6 = false
    else
      c1515v6 = true
    end
    c1515v7 = -10
    c1515v8 = 33
    c1515v5 = c1515v5(c1515v6, c1515v7, c1515v8)
    c1515v9 = 100
    c1515v8 = math.max
    c1515v8 = c1515v8(c1515v9, c1515v1)
    c1515v7 = c1515v8 + c1515v0
    c1515v6 = c1515v7 + c1515v5
    c1515v8 = c1515v2 + 40
    c1515v9 = 100
    c1515v7 = math.max
    c1515v7 = c1515v7(c1515v8, c1515v9)
    c1515v8 = v44
    if not ((not c1515v8 or c1515v3 == 0)) then
      c1515v9 = c1515v7 - c1515v3
      c1515v8 = c1515v9 / 2
      c1515v9 = v12
      c1515v11 = function(c1514v0)
        local c1514v1, c1514v2, c1514v3, c1514v4, c1514v5, c1514v6
        local p6 = 0
        if p6 == 0 then
          c1514v1 = c1514v0.mType
          c1514v2 = v0
          c1514v2 = c1514v2.TITLE
          if c1514v1 == c1514v2 then
            p6 = 2
          else
            p6 = 1
          end
        end
        if p6 == 1 then
          c1514v1 = c1514v0.mType
          c1514v2 = v0
          c1514v2 = c1514v2.CHECKBOX
          if c1514v1 ~= c1514v2 then
            p6 = 4
          else
            p6 = 2
          end
        end
        if p6 == 2 then
          c1514v1 = mMovie
          c1514v3 = c1514v0.mClipName
          c1514v4 = 0
          c1514v5 = c1515v8
          c1514v1:SetNumberVariable(c1514v3, c1514v4, c1514v5)
          c1514v1 = c1514v0.mType
          c1514v2 = v0
          c1514v2 = c1514v2.CHECKBOX
          if c1514v1 ~= c1514v2 then
            p6 = 4
          else
            p6 = 3
          end
        end
        if p6 == 3 then
          c1514v1 = mMovie
          c1514v3 = c1514v0.mClipName
          c1514v4 = "Btn"
          c1514v5 = 14
          c1514v6 = c1515v3
          c1514v1:Name__52c1b74e(c1514v3, c1514v4, c1514v5, c1514v6)
          c1514v1 = mMovie
          c1514v3 = c1514v0.mClipName
          c1514v4 = "Bg"
          c1514v5 = 14
          c1514v6 = c1515v3
          c1514v1:Name__52c1b74e(c1514v3, c1514v4, c1514v5, c1514v6)
          c1514v1 = c1514v0.Checkbox
          c1514v4 = c1515v3
          c1514v3 = c1514v4 - 70
          c1514v1:SetPosition(c1514v3)
          p6 = 4
        end
        if p6 == 4 then
          do return end
        end
      end
      c1515v9:RunForAllElements(c1515v11)
    end
    c1515v10 = 1
    c1515v8 = #c1515v4
    c1515v9 = 1
    for c1515v10 = c1515v10, c1515v8, c1515v9 do
      c1515v11 = c1515v4[c1515v10]
      c1515v12 = c1515v11.mXOffset
      if c1515v12 == nil then
        c1515v12 = 0
        c1515v11.mXOffset = c1515v12
      end
      c1515v12 = c1515v11.mHorizontalAlignment
      if c1515v12 == "left" then
        c1515v12 = mMovie
        c1515v14 = c1515v11.mClipName
        c1515v15 = "Image"
        c1515v16 = 0
        c1515v17 = c1515v11.mXOffset
        c1515v12:Name__52c1b74e(c1515v14, c1515v15, c1515v16, c1515v17)
      else
        c1515v12 = c1515v11.mHorizontalAlignment
        if c1515v12 == "right" then
          c1515v12 = mMovie
          c1515v14 = c1515v11.mClipName
          c1515v15 = "Image"
          c1515v16 = 14
          c1515v12 = c1515v12:Name__46690123(c1515v14, c1515v15, c1515v16)
          c1515v13 = mMovie
          c1515v15 = c1515v11.mClipName
          c1515v16 = "Image"
          c1515v17 = 0
          c1515v19 = c1515v7 - c1515v12
          c1515v20 = c1515v11.mXOffset
          c1515v18 = c1515v19 + c1515v20
          c1515v13:Name__52c1b74e(c1515v15, c1515v16, c1515v17, c1515v18)
        else
          c1515v12 = mMovie
          c1515v14 = c1515v11.mClipName
          c1515v15 = "Image"
          c1515v16 = 14
          c1515v12 = c1515v12:Name__46690123(c1515v14, c1515v15, c1515v16)
          c1515v14 = c1515v7 - c1515v12
          c1515v13 = c1515v14 / 2
          c1515v14 = mMovie
          c1515v16 = c1515v11.mClipName
          c1515v17 = "Image"
          c1515v18 = 0
          c1515v20 = c1515v11.mXOffset
          c1515v19 = c1515v13 + c1515v20
          c1515v14:Name__52c1b74e(c1515v16, c1515v17, c1515v18, c1515v19)
        end
      end
    end
    c1515v8 = v1
    c1515v8 = c1515v8.Ternary
    c1515v9 = v45
    c1515v12 = mMovie
    c1515v14 = "Container.Title"
    c1515v15 = 1
    c1515v12 = c1515v12:GetNumberVariable(c1515v14, c1515v15)
    c1515v11 = c1515v12 + c1515v0
    c1515v10 = c1515v11 + 33
    c1515v11 = 0
    c1515v8 = c1515v8(c1515v9, c1515v10, c1515v11)
    c1515v9 = mMovie
    c1515v11 = "Container.OptionList"
    c1515v12 = 1
    c1515v9:SetNumberVariable(c1515v11, c1515v12, c1515v8)
    c1515v9 = mMovie
    c1515v11 = "Container.OptionListMask"
    c1515v12 = 1
    c1515v13 = c1515v8 - 20
    c1515v9:SetNumberVariable(c1515v11, c1515v12, c1515v13)
    c1515v9 = mMovie
    c1515v11 = "Container.ScrollBar"
    c1515v12 = 1
    c1515v13 = c1515v8 - 13
    c1515v9:SetNumberVariable(c1515v11, c1515v12, c1515v13)
    c1515v9 = v1
    c1515v9 = c1515v9.Ternary
    c1515v11 = v43
    c1515v12 = 0
    if c1515v11 <= c1515v12 then
      c1515v10 = false
    else
      c1515v10 = true
    end
    c1515v11 = 62
    c1515v12 = 15
    c1515v9 = c1515v9(c1515v10, c1515v11, c1515v12)
    c1515v10 = Engine.IsMobile
    c1515v10 = c1515v10()
    if c1515v10 then
      c1515v10 = mMovie
      c1515v12 = "Container.BgFill"
      c1515v13 = 14
      c1515v10 = c1515v10:GetNumberVariable(c1515v12, c1515v13)
      c1515v13 = mMovie
      c1515v13 = c1515v13:GetMovieHeight()
      c1515v12 = c1515v13 - c1515v10
      c1515v11 = c1515v12 / 2
      c1515v12 = mMovie
      c1515v14 = "Container.ButtonContainer"
      c1515v15 = 0
      c1515v17 = v50
      c1515v17 = c1515v17.ConfirmX
      c1515v16 = c1515v11 + c1515v17
      c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
      c1515v12 = mMovie
      c1515v14 = "Container.ButtonContainer"
      c1515v15 = 1
      c1515v17 = c1515v6 + 15
      c1515v18 = v50
      c1515v18 = c1515v18.ConfirmY
      c1515v16 = c1515v17 + c1515v18
      c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
    else
      c1515v10 = mMovie
      c1515v12 = "Container.ButtonContainer"
      c1515v13 = 1
      c1515v14 = c1515v6 + 15
      c1515v10:SetNumberVariable(c1515v12, c1515v13, c1515v14)
    end
    c1515v6 = c1515v6 + c1515v9
    c1515v10 = v1
    c1515v10 = c1515v10.Round
    c1515v13 = mMovie
    c1515v13 = c1515v13:GetMovieWidth()
    c1515v12 = c1515v13 - c1515v7
    c1515v11 = c1515v12 / 2
    c1515v10 = c1515v10(c1515v11)
    c1515v11 = mMovie
    c1515v13 = "Container.BgFill"
    c1515v14 = 15
    c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v6)
    c1515v11 = mMovie
    c1515v13 = "Container.BgFill"
    c1515v14 = 14
    c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v7)
    c1515v11 = mMovie
    c1515v13 = "Container"
    c1515v14 = 0
    c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v10)
    c1515v11 = mMovie
    c1515v13 = "Container"
    c1515v14 = 1
    c1515v17 = mMovie
    c1515v17 = c1515v17:GetMovieHeight()
    c1515v16 = c1515v17 / 2
    c1515v17 = c1515v6 / 2
    c1515v15 = c1515v16 - c1515v17
    c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v15)
    c1515v11 = Engine.IsMobile
    c1515v11 = c1515v11()
    if c1515v11 then
      c1515v11 = mMovie
      c1515v13 = "Container"
      c1515v14 = 0
      c1515v16 = v50
      c1515v16 = c1515v16.ContainerXPos
      c1515v15 = c1515v10 + c1515v16
      c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v15)
      c1515v11 = mMovie
      c1515v13 = "Container"
      c1515v14 = 1
      c1515v18 = mMovie
      c1515v18 = c1515v18:GetMovieHeight()
      c1515v17 = c1515v18 / 2
      c1515v18 = c1515v6 / 2
      c1515v16 = c1515v17 - c1515v18
      c1515v17 = v50
      c1515v17 = c1515v17.ContainerYPos
      c1515v15 = c1515v16 + c1515v17
      c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v15)
    end
    c1515v11 = mMovie
    c1515v13 = "Container.SearchBox"
    c1515v14 = 0
    c1515v17 = v35
    c1515v17 = c1515v17.mMaxSize
    c1515v16 = c1515v17 + 2
    c1515v15 = c1515v7 - c1515v16
    c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v15)
    c1515v11 = mMovie
    c1515v13 = "Container.ScrollBar"
    c1515v14 = 0
    c1515v15 = c1515v7 - 15
    c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v15)
    c1515v11 = v45
    if c1515v11 then
      c1515v11 = mMovie
      c1515v13 = "Container.Title"
      c1515v14 = 14
      c1515v11:SetNumberVariable(c1515v13, c1515v14, c1515v7)
    end
    c1515v11 = c1515v7 / 2
    c1515v12 = mMovie
    c1515v14 = "FancyBits.LeftLines"
    c1515v15 = 0
    c1515v17 = -c1515v11
    c1515v16 = c1515v17 + 1
    c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
    c1515v12 = mMovie
    c1515v14 = "FancyBits.RightLines"
    c1515v15 = 0
    c1515v16 = c1515v11 - 1
    c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
    c1515v12 = mMovie
    c1515v14 = "FancyBits.LeftSideLine"
    c1515v15 = 0
    c1515v17 = -c1515v11
    c1515v16 = c1515v17 + 2
    c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
    c1515v12 = mMovie
    c1515v14 = "FancyBits.RightSideLine"
    c1515v15 = 0
    c1515v16 = c1515v11 - 1
    c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
    c1515v12 = Engine.IsMobile
    c1515v12 = c1515v12()
    if c1515v12 then
      c1515v12 = mMovie
      c1515v14 = "FancyBits.LeftLines"
      c1515v15 = 0
      c1515v18 = -c1515v11
      c1515v17 = c1515v18 + 1
      c1515v18 = v50
      c1515v18 = c1515v18.ContainerXPos
      c1515v16 = c1515v17 + c1515v18
      c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
      c1515v12 = mMovie
      c1515v14 = "FancyBits.RightLines"
      c1515v15 = 0
      c1515v18 = c1515v11 - 1
      c1515v19 = v50
      c1515v19 = c1515v19.ContainerXPos
      c1515v17 = c1515v18 - c1515v19
      c1515v18 = v50
      c1515v18 = c1515v18.ExtraXOffset
      c1515v16 = c1515v17 - c1515v18
      c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
      c1515v12 = mMovie
      c1515v14 = "FancyBits.LeftSideLine"
      c1515v15 = 0
      c1515v18 = -c1515v11
      c1515v17 = c1515v18 + 2
      c1515v18 = v50
      c1515v18 = c1515v18.ContainerXPos
      c1515v16 = c1515v17 + c1515v18
      c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
      c1515v12 = mMovie
      c1515v14 = "FancyBits.RightSideLine"
      c1515v15 = 0
      c1515v18 = c1515v11 - 1
      c1515v19 = v50
      c1515v19 = c1515v19.ContainerXPos
      c1515v17 = c1515v18 - c1515v19
      c1515v18 = v50
      c1515v18 = c1515v18.ExtraXOffset
      c1515v16 = c1515v17 - c1515v18
      c1515v12:SetNumberVariable(c1515v14, c1515v15, c1515v16)
    end
    do return end
  end
  v62 = function(c1516v0)
    local c1516v1, c1516v2, c1516v3, c1516v4, c1516v5, c1516v6, c1516v7, c1516v8, c1516v9, c1516v10, c1516v11, c1516v12
    c1516v2 = v35
    c1516v1 = IsNull
    c1516v1 = c1516v1(c1516v2)
    c1516v2 = v12
    c1516v1 = IsNull
    c1516v1 = c1516v1(c1516v2)
    c1516v4 = v12
    c1516v6 = true
    c1516v7 = true
    c1516v4:RemoveElements(c1516v6, c1516v7)
    c1516v6 = 1
    c1516v7 = v12
    c1516v7 = c1516v7.mUnfilteredElements
    c1516v4 = #c1516v7
    c1516v5 = 1
    for c1516v6 = c1516v6, c1516v4, c1516v5 do
      c1516v8 = v12
      c1516v8 = c1516v8.mUnfilteredElements
      c1516v7 = c1516v8[c1516v6]
      if c1516v7 then
        c1516v8 = c1516v7.mSearchTerm
        c1516v8 = c1516v8:find(c1516v2)
        if c1516v8 then
          c1516v8 = v12
          c1516v10 = v1
          c1516v10 = c1516v10.CopyTable
          c1516v10 = c1516v10(c1516v7)
          c1516v11 = true
          c1516v12 = true
          c1516v8:AddElement(c1516v10, c1516v11, c1516v12)
        end
      end
    end
    c1516v1 = v35
    c1516v1 = c1516v1.mLabel
    c1516v2 = ToSearchable
    c1516v2 = c1516v2(c1516v1)
    c1516v4 = "[%(%)%.%%%+%-%*%?%[%]%^%$]"
    c1516v5 = "%%%0"
    c1516v5 = c1516v2:gsub(c1516v4, c1516v5)
    c1516v3 = c1516v0:find(c1516v5)
    if c1516v3 then
      c1516v3 = false
      if c1516v0 ~= "" then
        if c1516v2 == "" then
          c1516v3 = false
        else
          c1516v3 = true
        end
      end
    end
    if c1516v1 then
      do return end
    end
    if c1516v1 then
      c1516v4 = 1
      while true do
        c1516v6 = v12
        c1516v6 = c1516v6.mElements
        c1516v5 = #c1516v6
        if c1516v5 < c1516v4 then break end
        c1516v6 = v12
        c1516v6 = c1516v6.mElements
        c1516v5 = c1516v6[c1516v4]
        c1516v6 = c1516v5.mSearchTerm
        c1516v6 = c1516v6:find(c1516v2)
        if not c1516v6 then
          c1516v6 = v12
          c1516v8 = c1516v5.mIndex
          c1516v9 = true
          c1516v10 = true
          c1516v6:RemoveElement(c1516v8, c1516v9, c1516v10)
        else
          c1516v4 = c1516v4 + 1
        end
      end
    end
    c1516v4 = mMovie
    c1516v6 = v12
    c1516v6 = c1516v6.mScrollBarClipName
    c1516v7 = 13
    c1516v4 = c1516v4:Name__9d78ed52(c1516v6, c1516v7)
    c1516v5 = v12
    c1516v7 = nil
    c1516v8 = true
    c1516v9 = true
    c1516v5:Redraw(c1516v7, c1516v8, c1516v9)
    c1516v5 = mMovie
    c1516v7 = v12
    c1516v7 = c1516v7.mScrollBarClipName
    c1516v8 = 13
    c1516v5 = c1516v5:Name__9d78ed52(c1516v7, c1516v8)
    if c1516v4 ~= c1516v5 then
      c1516v6 = v49
      c1516v6()
    end
    do return end
  end
  v63 = function()
    local c1551v0, c1551v1, c1551v2, c1551v3, c1551v4, c1551v5, c1551v6, c1551v7, c1551v8
    c1551v0 = print
    c1551v1 = "InitializeSettings()"
    c1551v0(c1551v1)
    c1551v0 = mMovie
    c1551v2 = "Container.OptionListMask"
    c1551v3 = 15
    c1551v4 = 600
    c1551v0:SetNumberVariable(c1551v2, c1551v3, c1551v4)
    c1551v0 = require
    c1551v1 = "EE.Interface.Components.List"
    c1551v0 = c1551v0(c1551v1)
    c1551v1 = c1551v0.CreateList
    c1551v2 = mMovie
    c1551v3 = "Container.OptionList.MenuEntry1"
    c1551v1 = c1551v1(c1551v2, c1551v3)
    v12 = c1551v1
    c1551v1 = v12
    c1551v3 = "MenuEntryPressed"
    c1551v4 = "MenuEntryFocused"
    c1551v5 = "MenuEntryUnfocused"
    c1551v1:SetCallbacks(c1551v3, c1551v4, c1551v5)
    c1551v1 = v12
    c1551v2 = function(c1517v0, c1517v1)
      do return end
    end
    c1551v1.Print = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1518v0)
      local c1518v2, c1518v3, c1518v4, c1518v5, c1518v6, c1518v7, c1518v8
      local c1518v1 = c1518v0.mTooltip
      if c1518v1 then
        c1518v1 = _T
        c1518v2 = c1518v0.mTooltip
        c1518v1.gToolTip = c1518v2
      end
      v27 = c1518v0
      c1518v1 = true
      c1518v0.mFocused = c1518v1
      c1518v1 = c1518v0.mLocked
      if c1518v1 then
        do return end
      end
      c1518v1 = c1518v0.mType
      c1518v2 = v27
      c1518v2 = c1518v2.TITLE
      if not c1518v1 then
        c1518v1 = c1518v0.mType
        c1518v2 = v27
        c1518v2 = c1518v2.SPACER
        if c1518v1 ~= c1518v2 then
          c1518v1 = c1518v0.mType
          c1518v2 = v27
          c1518v2 = c1518v2.IMAGE
          if c1518v1 ~= c1518v2 then
            c1518v1 = c1518v0.mClipName
            if c1518v1 ~= nil then
              c1518v1 = v27
              c1518v1 = c1518v1.PlaySound
              c1518v2 = _G
              c1518v2 = c1518v2.UISound_Focus
              c1518v1(c1518v2)
              c1518v1 = mMovie
              c1518v4 = c1518v0.mClipName
              c1518v5 = ".Bg"
              c1518v3 = c1518v4 .. c1518v5
              c1518v4 = "RectEdgeColor"
              c1518v5 = v27
              c1518v5 = c1518v5.FloatingContentHighlightProcedural
              c1518v5 = c1518v5.r
              c1518v6 = v27
              c1518v6 = c1518v6.FloatingContentHighlightProcedural
              c1518v6 = c1518v6.g
              c1518v7 = v27
              c1518v7 = c1518v7.FloatingContentHighlightProcedural
              c1518v7 = c1518v7.b
              c1518v8 = 0.5
              c1518v1:Name__e243d995(c1518v3, c1518v4, c1518v5, c1518v6, c1518v7, c1518v8)
              c1518v1 = mMovie
              c1518v3 = c1518v0.mClipName
              c1518v4 = "Label"
              c1518v5 = 44
              c1518v6 = v27
              c1518v6 = c1518v6.FloatingContentHighlight
              c1518v1:Name__52c1b74e(c1518v3, c1518v4, c1518v5, c1518v6)
              c1518v1 = c1518v0.mType
              c1518v2 = v27
              c1518v2 = c1518v2.INPUTCOUNT
              if c1518v1 == c1518v2 then
                c1518v1 = mMovie
                c1518v3 = c1518v0.mClipName
                c1518v4 = "Callouts"
                c1518v5 = 13
                c1518v6 = Engine.IsPlayingWithController
                c1518v6 = c1518v6()
                if c1518v6 then
                  c1518v8 = v27
                  c1518v7 = IsNull
                  c1518v7 = c1518v7(c1518v8)
                  c1518v6 = not c1518v7
                  if c1518v6 then
                    c1518v7 = v27
                    c1518v7 = c1518v7.Id
                    c1518v8 = c1518v0.Id
                    if c1518v7 ~= c1518v8 then
                      c1518v6 = false
                    else
                      c1518v6 = true
                    end
                  end
                end
                c1518v1:Makeposshield(c1518v3, c1518v4, c1518v5, c1518v6)
                c1518v1 = Engine.IsPlayingWithController
                c1518v1 = c1518v1()
                if c1518v1 then
                  c1518v1 = mMovie
                  c1518v4 = c1518v0.mClipName
                  c1518v5 = ".Callouts.Right.Tf.text"
                  c1518v3 = c1518v4 .. c1518v5
                  c1518v4 = "<MENU_RTRIGGER2>"
                  c1518v1:SetLocalized(c1518v3, c1518v4)
                  c1518v1 = mMovie
                  c1518v4 = c1518v0.mClipName
                  c1518v5 = ".Callouts.Left.Tf.text"
                  c1518v3 = c1518v4 .. c1518v5
                  c1518v4 = "<MENU_LTRIGGER2>"
                  c1518v1:SetLocalized(c1518v3, c1518v4)
                  do return end
                end
              else
                c1518v1 = c1518v0.mType
                c1518v2 = v27
                c1518v2 = c1518v2.CHECKBOX
                if c1518v1 == c1518v2 then
                  c1518v1 = c1518v0.Checkbox
                  c1518v3 = true
                  c1518v1:TrySetFocus(c1518v3)
                end
              end
              do return end
            end
          end
        end
      end
      do return end
    end
    c1551v1.mOnFocusedCallback = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1519v0)
      local c1519v2, c1519v3, c1519v4, c1519v5, c1519v6, c1519v7, c1519v8
      local c1519v1 = c1519v0.mTooltip
      if c1519v1 then
        c1519v1 = _T
        c1519v2 = nil
        c1519v1.gToolTip = c1519v2
      end
      c1519v1 = false
      c1519v0.mFocused = c1519v1
      c1519v1 = c1519v0.mType
      c1519v2 = v0
      c1519v2 = c1519v2.TITLE
      if not c1519v1 then
        c1519v1 = c1519v0.mType
        c1519v2 = v0
        c1519v2 = c1519v2.SPACER
        if c1519v1 ~= c1519v2 then
          c1519v1 = c1519v0.mType
          c1519v2 = v0
          c1519v2 = c1519v2.IMAGE
          if c1519v1 ~= c1519v2 then
            c1519v1 = c1519v0.mClipName
            if c1519v1 ~= nil then
              c1519v1 = mMovie
              c1519v4 = c1519v0.mClipName
              c1519v5 = ".Bg"
              c1519v3 = c1519v4 .. c1519v5
              c1519v4 = "RectEdgeColor"
              c1519v5 = v27
              c1519v5 = c1519v5.FloatingContentProcedural
              c1519v5 = c1519v5.r
              c1519v6 = v27
              c1519v6 = c1519v6.FloatingContentProcedural
              c1519v6 = c1519v6.g
              c1519v7 = v27
              c1519v7 = c1519v7.FloatingContentProcedural
              c1519v7 = c1519v7.b
              c1519v8 = 0.1
              c1519v1:Name__e243d995(c1519v3, c1519v4, c1519v5, c1519v6, c1519v7, c1519v8)
              c1519v1 = mMovie
              c1519v3 = c1519v0.mClipName
              c1519v4 = "Label"
              c1519v5 = 44
              c1519v6 = v27
              c1519v6 = c1519v6.FloatingContent
              c1519v1:Name__52c1b74e(c1519v3, c1519v4, c1519v5, c1519v6)
              c1519v1 = c1519v0.mType
              c1519v2 = v0
              c1519v2 = c1519v2.INPUTCOUNT
              if c1519v1 == c1519v2 then
                c1519v1 = mMovie
                c1519v3 = c1519v0.mClipName
                c1519v4 = "Callouts"
                c1519v5 = 13
                c1519v6 = false
                c1519v1:Makeposshield(c1519v3, c1519v4, c1519v5, c1519v6)
                c1519v1 = Engine.IsPlayingWithController
                c1519v1 = c1519v1()
                if c1519v1 then
                  c1519v1 = mMovie
                  c1519v4 = c1519v0.mClipName
                  c1519v5 = ".Callouts.Right.Tf.text"
                  c1519v3 = c1519v4 .. c1519v5
                  c1519v4 = "<MENU_RTRIGGER2>"
                  c1519v1:SetLocalized(c1519v3, c1519v4)
                  c1519v1 = mMovie
                  c1519v4 = c1519v0.mClipName
                  c1519v5 = ".Callouts.Left.Tf.text"
                  c1519v3 = c1519v4 .. c1519v5
                  c1519v4 = "<MENU_LTRIGGER2>"
                  c1519v1:SetLocalized(c1519v3, c1519v4)
                  do return end
                end
              else
                c1519v1 = c1519v0.mType
                c1519v2 = v0
                c1519v2 = c1519v2.CHECKBOX
                if c1519v1 == c1519v2 then
                  c1519v1 = c1519v0.Checkbox
                  c1519v3 = false
                  c1519v1:TrySetFocus(c1519v3)
                end
              end
              do return end
            end
          end
        end
      end
      do return end
    end
    c1551v1.mOnUnfocusedCallback = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1522v0)
      local c1522v2, c1522v3, c1522v4, c1522v5
      local c1522v1 = c1522v0.mLocked
      if c1522v1 then
        do return end
      end
      c1522v1 = c1522v0.mType
      c1522v2 = v12
      c1522v2 = c1522v2.CHECKBOX
      if not c1522v1 then
        c1522v1 = c1522v0.Checkbox
        if c1522v1 ~= nil then
          c1522v1 = c1522v0.Checkbox
          c1522v3 = true
          c1522v1:TryPressed(c1522v3)
          do return end
        end
      else
        c1522v1 = c1522v0.mType
        c1522v2 = v12
        c1522v2 = c1522v2.BUTTON
        if c1522v1 == c1522v2 then
          c1522v1 = c1522v0.mCallback
          if c1522v1 ~= nil then
            c1522v1 = c1522v0.mCallback
            c1522v1()
            c1522v1 = v60
            c1522v1()
            do return end
          end
        else
          c1522v1 = c1522v0.mType
          c1522v2 = v12
          c1522v2 = c1522v2.COLOR
          if c1522v1 == c1522v2 then
            c1522v1 = v12
            c1522v1 = c1522v1.OpenColorPicker
            c1522v2 = mMovie
            c1522v3 = c1522v0.mCurrColor
            c1522v4 = function(c1520v0, c1520v1)
              local c1520v2, c1520v3
              if c1520v0 == nil then
                c1520v2 = c1522v0
                c1520v3 = nil
                c1520v2.mNewColor = c1520v3
                do return end
              end
              c1520v2 = c1522v0
              c1520v2.mNewColor = c1520v0
              do return end
            end
            c1522v5 = function(c1521v0)
              local c1521v1, c1521v2, c1521v3, c1521v4, c1521v5, c1521v6
              if c1521v0 then
                c1521v1 = c1522v0
                c1521v2 = c1522v0
                c1521v2 = c1521v2.mNewColor
                c1521v1.mCurrColor = c1521v2
                c1521v2 = c1522v0
                c1521v2 = c1521v2.mOnColorSelected
                c1521v1 = IsNull
                c1521v1 = c1521v1(c1521v2)
                if not c1521v1 then
                  c1521v1 = c1522v0
                  c1521v1 = c1521v1.mOnColorSelected
                  c1521v2 = c1522v0
                  c1521v2 = c1521v2.mCurrColor
                  c1521v1(c1521v2)
                end
                c1521v1 = mMovie
                c1521v3 = c1522v0
                c1521v3 = c1521v3.mClipName
                c1521v4 = "Color.Fill"
                c1521v5 = 11
                c1521v6 = c1522v0
                c1521v6 = c1521v6.mCurrColor
                c1521v1:Name__52c1b74e(c1521v3, c1521v4, c1521v5, c1521v6)
              end
              c1521v1 = c1522v0
              c1521v2 = nil
              c1521v1.mNewColor = c1521v2
              do return end
            end
            c1522v1(c1522v2, c1522v3, c1522v4, c1522v5)
            c1522v1 = v60
            c1522v1()
            do return end
          end
          c1522v1 = c1522v0.mType
          c1522v2 = v12
          c1522v2 = c1522v2.INPUTCOUNT
          if c1522v1 == c1522v2 then
            c1522v1 = v12
            c1522v1 = c1522v1.mElementDrawCallback
            c1522v1(c1522v0)
            do return end
          end
          c1522v1 = c1522v0.mType
          c1522v2 = v12
          c1522v2 = c1522v2.INPUTBOX
          if c1522v1 ~= c1522v2 then
            c1522v1 = mMovie
            c1522v3 = c1522v0.InputField
            c1522v3 = c1522v3.mLabelClipName
            c1522v4 = 52
            c1522v5 = c1522v0.mMultiLine
            c1522v1:Name__d9713943(c1522v3, c1522v4, c1522v5)
            c1522v2 = c1522v0.mMaxChars
            c1522v1 = IsNull
            c1522v1 = c1522v1(c1522v2)
            if not c1522v1 then
              c1522v1 = mMovie
              c1522v3 = c1522v0.InputField
              c1522v3 = c1522v3.mLabelClipName
              c1522v4 = 39
              c1522v5 = c1522v0.mMaxChars
              c1522v1:SetNumberVariable(c1522v3, c1522v4, c1522v5)
            end
            c1522v1 = c1522v0.InputField
            if c1522v1 ~= nil then
              c1522v1 = c1522v0.InputField
              c1522v3 = true
              c1522v1:Pressed(c1522v3)
            end
            c1522v1 = v60
            c1522v1()
          end
        end
      end
      do return end
    end
    c1551v1.mOnSelectedCallback = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1543v0)
      local c1543v3, c1543v4, c1543v5, c1543v6, c1543v7, c1543v8, c1543v9, c1543v10, c1543v11, c1543v12, c1543v13, c1543v14, c1543v15, c1543v16
      local c1543v1 = c1543v0.mClipName
      if c1543v1 == nil then
        do return end
      end
      local c1543v2 = c1543v0.mMultiLine
      if c1543v2 ~= true then
        c1543v1 = false
      else
        c1543v1 = true
      end
      c1543v0.mMultiLine = c1543v1
      c1543v1 = c1543v0.mType
      c1543v2 = v12
      c1543v2 = c1543v2.IMAGE
      if c1543v1 ~= nil then
        c1543v1 = FlashMethod
        c1543v2 = mMovie
        c1543v4 = c1543v0.mClipName
        c1543v5 = ".gotoAndStop"
        c1543v3 = c1543v4 .. c1543v5
        c1543v4 = "Image"
        c1543v1(c1543v2, c1543v3, c1543v4)
        c1543v1 = mMovie
        c1543v3 = c1543v0.mClipName
        c1543v4 = "Image"
        c1543v5 = 14
        c1543v6 = v27
        c1543v6 = c1543v6.Ternary
        c1543v8 = c1543v0.mWidth
        if c1543v8 == nil then
          c1543v7 = false
        else
          c1543v7 = true
        end
        c1543v8 = c1543v0.mWidth
        c1543v9 = 100
        c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6(c1543v7, c1543v8, c1543v9))
        c1543v1 = mMovie
        c1543v3 = c1543v0.mClipName
        c1543v4 = "Image"
        c1543v5 = 15
        c1543v6 = v27
        c1543v6 = c1543v6.Ternary
        c1543v8 = c1543v0.mHeight
        if c1543v8 == nil then
          c1543v7 = false
        else
          c1543v7 = true
        end
        c1543v8 = c1543v0.mHeight
        c1543v9 = 100
        c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6(c1543v7, c1543v8, c1543v9))
        c1543v1 = mMovie
        c1543v4 = c1543v0.mClipName
        c1543v5 = ".Image"
        c1543v3 = c1543v4 .. c1543v5
        c1543v4 = c1543v0.mImageResource
        c1543v1:OverrideTexture(c1543v3, c1543v4)
        c1543v1 = c1543v0.mInitialY
        if c1543v1 == nil then
          c1543v1 = mMovie
          c1543v3 = c1543v0.mClipName
          c1543v4 = "Image"
          c1543v5 = 1
          c1543v1 = c1543v1:Name__46690123(c1543v3, c1543v4, c1543v5)
          c1543v0.mInitialY = c1543v1
        end
        c1543v1 = c1543v0.mYOffset
        if c1543v1 ~= nil then
          c1543v1 = mMovie
          c1543v3 = c1543v0.mClipName
          c1543v4 = "Image"
          c1543v5 = 1
          c1543v7 = c1543v0.mInitialY
          c1543v8 = c1543v0.mYOffset
          c1543v6 = c1543v7 + c1543v8
          c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
        end
      else
        c1543v1 = c1543v0.mType
        c1543v2 = v12
        c1543v2 = c1543v2.SPACER
        if c1543v1 == c1543v2 then
          c1543v1 = FlashMethod
          c1543v2 = mMovie
          c1543v4 = c1543v0.mClipName
          c1543v5 = ".gotoAndStop"
          c1543v3 = c1543v4 .. c1543v5
          c1543v4 = "Title"
          c1543v1(c1543v2, c1543v3, c1543v4)
        else
          c1543v1 = c1543v0.mType
          c1543v2 = v12
          c1543v2 = c1543v2.TITLE
          if c1543v1 == c1543v2 then
            c1543v1 = FlashMethod
            c1543v2 = mMovie
            c1543v4 = c1543v0.mClipName
            c1543v5 = ".gotoAndStop"
            c1543v3 = c1543v4 .. c1543v5
            c1543v4 = "Title"
            c1543v1(c1543v2, c1543v3, c1543v4)
            c1543v1 = mMovie
            c1543v3 = c1543v0.mClipName
            c1543v4 = "Label"
            c1543v5 = 14
            c1543v6 = v27
            c1543v6 = c1543v6.Ternary
            c1543v8 = c1543v0.mWidth
            if c1543v8 == nil then
              c1543v7 = false
            else
              c1543v7 = true
            end
            c1543v8 = c1543v0.mWidth
            c1543v9 = 800
            c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6(c1543v7, c1543v8, c1543v9))
            c1543v1 = mMovie
            c1543v3 = c1543v0.mClipName
            c1543v4 = "Label"
            c1543v5 = 52
            c1543v6 = c1543v0.mMultiLine
            c1543v1:Makeposshield(c1543v3, c1543v4, c1543v5, c1543v6)
            c1543v1 = c1543v0.mInitialX
            if c1543v1 == nil then
              c1543v1 = mMovie
              c1543v4 = c1543v0.mClipName
              c1543v5 = ".Label"
              c1543v3 = c1543v4 .. c1543v5
              c1543v4 = 0
              c1543v1 = c1543v1:GetNumberVariable(c1543v3, c1543v4)
              c1543v0.mInitialX = c1543v1
            end
            c1543v1 = c1543v0.mInitialY
            if c1543v1 == nil then
              c1543v1 = mMovie
              c1543v4 = c1543v0.mClipName
              c1543v5 = ".Label"
              c1543v3 = c1543v4 .. c1543v5
              c1543v4 = 1
              c1543v1 = c1543v1:GetNumberVariable(c1543v3, c1543v4)
              c1543v0.mInitialY = c1543v1
            end
            c1543v1 = c1543v0.mVerticalPadding
            if c1543v1 ~= nil then
              c1543v1 = mMovie
              c1543v3 = c1543v0.mClipName
              c1543v4 = "Label"
              c1543v5 = 1
              c1543v7 = c1543v0.mInitialY
              c1543v8 = c1543v0.mVerticalPadding
              c1543v6 = c1543v7 + c1543v8
              c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
            end
            c1543v1 = c1543v0.mHorizontalPadding
            if c1543v1 ~= nil then
              c1543v1 = mMovie
              c1543v3 = c1543v0.mClipName
              c1543v4 = "Label"
              c1543v5 = 0
              c1543v7 = c1543v0.mInitialX
              c1543v8 = c1543v0.mHorizontalPadding
              c1543v6 = c1543v7 + c1543v8
              c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
            end
            c1543v1 = c1543v0.mFontSize
            if c1543v1 ~= nil then
              c1543v1 = mMovie
              c1543v3 = c1543v0.mClipName
              c1543v4 = "Label"
              c1543v5 = 50
              c1543v6 = c1543v0.mFontSize
              c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
            end
            c1543v1 = Engine.STACKSFollies
            c1543v1 = c1543v1()
            if c1543v1 then
              c1543v1 = mMovie
              c1543v3 = c1543v0.mClipName
              c1543v4 = "Label"
              c1543v5 = 49
              c1543v6 = "Arial Unicode MS"
              c1543v1:Name__f4a9016a(c1543v3, c1543v4, c1543v5, c1543v6)
            end
          else
            c1543v1 = c1543v0.mType
            c1543v2 = v12
            c1543v2 = c1543v2.CHECKBOX
            if c1543v1 == c1543v2 then
              c1543v1 = FlashMethod
              c1543v2 = mMovie
              c1543v4 = c1543v0.mClipName
              c1543v5 = ".gotoAndStop"
              c1543v3 = c1543v4 .. c1543v5
              c1543v4 = "Checkbox"
              c1543v1(c1543v2, c1543v3, c1543v4)
              c1543v1 = v12
              c1543v1 = c1543v1.mScroll
              if c1543v1 ~= nil then
                c1543v1 = nil
                c1543v0.Checkbox = c1543v1
              end
              c1543v1 = c1543v0.Checkbox
              if c1543v1 == nil then
                c1543v1 = v27
                c1543v1 = c1543v1.Create
                c1543v2 = mMovie
                c1543v4 = c1543v0.mClipName
                c1543v5 = ".Checkbox"
                c1543v3 = c1543v4 .. c1543v5
                c1543v4 = c1543v0.mValue
                c1543v1 = c1543v1(c1543v2, c1543v3, c1543v4)
                c1543v0.Checkbox = c1543v1
                c1543v1 = c1543v0.Checkbox
                c1543v2 = c1543v0.mId
                c1543v1.mParentId = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = 28
                c1543v1.mHeight = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = 64
                c1543v1.mMinSize = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = 64
                c1543v1.mMaxSize = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = 40
                c1543v1.mEdgeAlpha = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = 80
                c1543v1.mFocusedEdgeAlpha = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = 1
                c1543v1.mUnfocusedEdgeColor = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = Name__22e9352c
                c1543v1.mIconOn = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = crossIcon
                c1543v1.mIconOff = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = Name__03c949fb
                c1543v1.mIconDefault = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = c1543v0.mLocked
                c1543v1.mLocked = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = c1543v0.Checkbox
                c1543v2 = c1543v2.Pressed
                c1543v1.CheckboxPressed = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = function(c1523v0, c1523v1, c1523v2)
                  local c1523v3
                  c1523v3 = c1543v0
                  c1523v3 = c1523v3.mLocked
                  if not c1523v3 then
                    c1523v3 = c1543v0
                    c1523v3 = c1523v3.Checkbox
                    c1523v3 = c1523v3.CheckboxPressed
                    c1523v3(c1523v0, c1523v1, c1523v2)
                  end
                  do return end
                end
                c1543v1.Pressed = c1543v2
                c1543v1 = c1543v0.Checkbox
                c1543v2 = function(c1524v0)
                  local c1524v1, c1524v2
                  c1524v1 = c1543v0
                  c1524v2 = c1524v0.mChecked
                  c1524v1.mValue = c1524v2
                  c1524v1 = v15
                  c1524v1()
                  do return end
                end
                c1543v1.ValueChanged = c1543v2
              end
              c1543v1 = c1543v0.Checkbox
              c1543v1:Redraw()
              c1543v1 = c1543v0.mButtonWidth
              if c1543v1 ~= nil then
                c1543v1 = mMovie
                c1543v3 = c1543v0.mClipName
                c1543v4 = "Btn"
                c1543v5 = 14
                c1543v6 = c1543v0.mButtonWidth
                c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                c1543v1 = mMovie
                c1543v3 = c1543v0.mClipName
                c1543v4 = "Bg"
                c1543v5 = 14
                c1543v6 = c1543v0.mButtonWidth
                c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                c1543v1 = c1543v0.mValueOffset
                if c1543v1 ~= nil then
                  c1543v1 = c1543v0.Checkbox
                  c1543v5 = c1543v0.mButtonWidth
                  c1543v6 = c1543v0.Checkbox
                  c1543v6 = c1543v6.mMaxSize
                  c1543v4 = c1543v5 - c1543v6
                  c1543v5 = c1543v0.mValueOffset
                  c1543v3 = c1543v4 - c1543v5
                  c1543v1:SetPosition(c1543v3)
                else
                  c1543v1 = c1543v0.Checkbox
                  c1543v4 = c1543v0.mButtonWidth
                  c1543v3 = c1543v4 - 70
                  c1543v1:SetPosition(c1543v3)
                end
              end
            else
              c1543v1 = c1543v0.mType
              c1543v2 = v12
              c1543v2 = c1543v2.TOGGLE
              if c1543v1 == c1543v2 then
                c1543v1 = FlashMethod
                c1543v2 = mMovie
                c1543v4 = c1543v0.mClipName
                c1543v5 = ".gotoAndStop"
                c1543v3 = c1543v4 .. c1543v5
                c1543v4 = "Toggle"
                c1543v1(c1543v2, c1543v3, c1543v4)
                c1543v1 = v12
                c1543v1 = c1543v1.mScroll
                if c1543v1 ~= nil then
                  c1543v1 = nil
                  c1543v0.Toggle = c1543v1
                end
                c1543v1 = c1543v0.Toggle
                if c1543v1 == nil then
                  c1543v1 = v15
                  c1543v1 = c1543v1.Create
                  c1543v2 = mMovie
                  c1543v4 = c1543v0.mClipName
                  c1543v5 = ".Toggle"
                  c1543v3 = c1543v4 .. c1543v5
                  c1543v4 = c1543v0.mToggleValues
                  c1543v1 = c1543v1(c1543v2, c1543v3, c1543v4)
                  c1543v0.Toggle = c1543v1
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = c1543v0.Id
                  c1543v1.mParentId = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = 28
                  c1543v1.mHeight = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = 270
                  c1543v1.mMinSize = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = 270
                  c1543v1.mMaxSize = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = 40
                  c1543v1.mEdgeAlpha = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = 80
                  c1543v1.mFocusedEdgeAlpha = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = 1
                  c1543v1.mUnfocusedEdgeColor = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = arrowIcon
                  c1543v1.mArrowIcon = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v3 = c1543v0.mValue
                  c1543v1:SetIndexByValue(c1543v3)
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = c1543v0.Toggle
                  c1543v2 = c1543v2.TrySetFocus
                  c1543v1.ComponentTrySetFocus = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = function(c1525v0, c1525v1)
                    local c1525v2, c1525v4, c1525v5
                    c1525v0:ComponentTrySetFocus(c1525v1)
                    c1525v2 = v12
                    c1525v5 = c1543v0
                    c1525v5 = c1525v5.Id
                    c1525v4 = tonumber
                    c1525v4 = c1525v4(c1525v5)
                    c1525v2:FocusElementById(c1525v4)
                    do return end
                  end
                  c1543v1.TrySetFocus = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = c1543v0.Toggle
                  c1543v2 = c1543v2.TrySetAltFocus
                  c1543v1.ComponentTrySetAltFocus = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = function(c1526v0, c1526v1, c1526v2)
                    local c1526v3, c1526v5, c1526v6
                    c1526v0:ComponentTrySetAltFocus(c1526v1, c1526v2)
                    c1526v3 = v12
                    c1526v6 = c1543v0
                    c1526v6 = c1526v6.Id
                    c1526v5 = tonumber
                    c1526v5 = c1526v5(c1526v6)
                    c1526v3:FocusElementById(c1526v5)
                    do return end
                  end
                  c1543v1.TrySetAltFocus = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = c1543v0.Toggle
                  c1543v2 = c1543v2.TryPressed
                  c1543v1.ComponentTryPressed = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = function(c1527v0, c1527v1, c1527v2)
                    c1527v0:ComponentTryPressed(c1527v1, c1527v2)
                    do return end
                  end
                  c1543v1.TryPressed = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = c1543v0.Toggle
                  c1543v2 = c1543v2.TryAltPressed
                  c1543v1.ComponentTryAltPressed = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = function(c1528v0, c1528v1, c1528v2)
                    c1528v0:ComponentTryAltPressed(c1528v1, c1528v2)
                    do return end
                  end
                  c1543v1.TryAltPressed = c1543v2
                  c1543v1 = c1543v0.Toggle
                  c1543v2 = function(c1529v0)
                    local c1529v1, c1529v2, c1529v3, c1529v4
                    c1529v1 = c1543v0
                    c1529v3 = c1529v0.mOptions
                    c1529v4 = c1529v0.mIndex
                    c1529v2 = c1529v3[c1529v4]
                    c1529v2 = c1529v2.Value
                    c1529v1.mValue = c1529v2
                    c1529v1 = v15
                    c1529v1()
                    do return end
                  end
                  c1543v1.ValueChanged = c1543v2
                end
                c1543v1 = c1543v0.mButtonWidth
                if c1543v1 ~= nil then
                  c1543v1 = mMovie
                  c1543v3 = c1543v0.mClipName
                  c1543v4 = "Btn"
                  c1543v5 = 14
                  c1543v6 = c1543v0.mButtonWidth
                  c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                  c1543v1 = mMovie
                  c1543v3 = c1543v0.mClipName
                  c1543v4 = "Bg"
                  c1543v5 = 14
                  c1543v6 = c1543v0.mButtonWidth
                  c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                  c1543v1 = c1543v0.Toggle
                  c1543v5 = c1543v0.mButtonWidth
                  c1543v6 = c1543v0.Toggle
                  c1543v6 = c1543v6.mMaxSize
                  c1543v4 = c1543v5 - c1543v6
                  c1543v3 = c1543v4 - 4
                  c1543v1:SetPosition(c1543v3)
                else
                  c1543v1 = mMovie
                  c1543v4 = c1543v0.mClipName
                  c1543v5 = ".Btn"
                  c1543v3 = c1543v4 .. c1543v5
                  c1543v4 = 14
                  c1543v1 = c1543v1:GetNumberVariable(c1543v3, c1543v4)
                  c1543v2 = c1543v0.Toggle
                  c1543v6 = c1543v0.Toggle
                  c1543v6 = c1543v6.mMaxSize
                  c1543v5 = c1543v1 - c1543v6
                  c1543v4 = c1543v5 - 4
                  c1543v2:SetPosition(c1543v4)
                end
                c1543v1 = c1543v0.Toggle
                c1543v1:Redraw()
              else
                c1543v1 = c1543v0.mType
                c1543v2 = v12
                c1543v2 = c1543v2.BUTTON
                if c1543v1 == c1543v2 then
                  c1543v1 = FlashMethod
                  c1543v2 = mMovie
                  c1543v4 = c1543v0.mClipName
                  c1543v5 = ".gotoAndStop"
                  c1543v3 = c1543v4 .. c1543v5
                  c1543v4 = "button"
                  c1543v1(c1543v2, c1543v3, c1543v4)
                  c1543v1 = mMovie
                  c1543v3 = c1543v0.mClipName
                  c1543v4 = "Arrow"
                  c1543v5 = 11
                  c1543v6 = _G
                  c1543v6 = c1543v6.UIColor_MediumGrey
                  c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                  c1543v1 = c1543v0.mButtonWidth
                  if c1543v1 ~= nil then
                    c1543v1 = mMovie
                    c1543v3 = c1543v0.mClipName
                    c1543v4 = "Btn"
                    c1543v5 = 14
                    c1543v6 = c1543v0.mButtonWidth
                    c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                    c1543v1 = mMovie
                    c1543v3 = c1543v0.mClipName
                    c1543v4 = "Bg"
                    c1543v5 = 14
                    c1543v6 = c1543v0.mButtonWidth
                    c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                  end
                  c1543v1 = c1543v0.mSubLabel
                  if c1543v1 == nil then
                    c1543v1 = mMovie
                    c1543v3 = c1543v0.mClipName
                    c1543v4 = "SubLabel"
                    c1543v5 = 36
                    c1543v6 = c1543v0.mSubLabel
                    c1543v1:Name__f4a9016a(c1543v3, c1543v4, c1543v5, c1543v6)
                    c1543v1 = v27
                    c1543v1 = c1543v1.Ternary
                    c1543v3 = c1543v0.mSubLabelOffset
                    if c1543v3 == nil then
                      c1543v2 = false
                    else
                      c1543v2 = true
                    end
                    c1543v3 = c1543v0.mSubLabelOffset
                    c1543v4 = 100
                    c1543v1 = c1543v1(c1543v2, c1543v3, c1543v4)
                    c1543v2 = mMovie
                    c1543v4 = c1543v0.mClipName
                    c1543v5 = "SubLabel"
                    c1543v6 = 0
                    c1543v8 = c1543v0.mButtonWidth
                    c1543v7 = c1543v8 - c1543v1
                    c1543v2:Name__52c1b74e(c1543v4, c1543v5, c1543v6, c1543v7)
                    c1543v2 = mMovie
                    c1543v4 = c1543v0.mClipName
                    c1543v5 = "SubLabel"
                    c1543v6 = 44
                    c1543v7 = v27
                    c1543v7 = c1543v7.FloatingContent
                    c1543v2:Name__52c1b74e(c1543v4, c1543v5, c1543v6, c1543v7)
                  else
                    c1543v1 = mMovie
                    c1543v3 = c1543v0.mClipName
                    c1543v4 = "SubLabel"
                    c1543v5 = 13
                    c1543v6 = false
                    c1543v1:Makeposshield(c1543v3, c1543v4, c1543v5, c1543v6)
                  end
                else
                  c1543v1 = c1543v0.mType
                  c1543v2 = v12
                  c1543v2 = c1543v2.COLOR
                  if c1543v1 == c1543v2 then
                    c1543v1 = FlashMethod
                    c1543v2 = mMovie
                    c1543v4 = c1543v0.mClipName
                    c1543v5 = ".gotoAndStop"
                    c1543v3 = c1543v4 .. c1543v5
                    c1543v4 = "color"
                    c1543v1(c1543v2, c1543v3, c1543v4)
                    c1543v1 = c1543v0.mButtonWidth
                    if c1543v1 ~= nil then
                      c1543v1 = mMovie
                      c1543v3 = c1543v0.mClipName
                      c1543v4 = "Btn"
                      c1543v5 = 14
                      c1543v6 = c1543v0.mButtonWidth
                      c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                      c1543v1 = mMovie
                      c1543v3 = c1543v0.mClipName
                      c1543v4 = "Bg"
                      c1543v5 = 14
                      c1543v6 = c1543v0.mButtonWidth
                      c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                      c1543v1 = mMovie
                      c1543v3 = c1543v0.mClipName
                      c1543v4 = "Color"
                      c1543v5 = 0
                      c1543v7 = c1543v0.mButtonWidth
                      c1543v6 = c1543v7 - 35
                      c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                    end
                    c1543v1 = c1543v0.mCurrColor
                    if c1543v1 then
                      c1543v1 = mMovie
                      c1543v3 = c1543v0.mClipName
                      c1543v4 = "Color.Fill"
                      c1543v5 = 11
                      c1543v6 = c1543v0.mCurrColor
                      c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                    end
                  else
                    c1543v1 = c1543v0.mType
                    c1543v2 = v12
                    c1543v2 = c1543v2.INPUTBOX
                    if c1543v1 == c1543v2 then
                      c1543v1 = FlashMethod
                      c1543v2 = mMovie
                      c1543v4 = c1543v0.mClipName
                      c1543v5 = ".gotoAndStop"
                      c1543v3 = c1543v4 .. c1543v5
                      c1543v4 = "Inputbox"
                      c1543v1(c1543v2, c1543v3, c1543v4)
                      c1543v1 = mMovie
                      c1543v4 = c1543v0.mClipName
                      c1543v5 = ".InputBoxText"
                      c1543v3 = c1543v4 .. c1543v5
                      c1543v4 = nil
                      c1543v5 = nil
                      c1543v6 = "InputBoxTextLimited"
                      c1543v7 = nil
                      c1543v1:SetFocusedCallbacks(c1543v3, c1543v4, c1543v5, c1543v6, c1543v7)
                      c1543v1 = c1543v0.mHorizontalPadding
                      if c1543v1 ~= nil then
                        c1543v1 = mMovie
                        c1543v3 = c1543v0.mClipName
                        c1543v4 = 0
                        c1543v1 = c1543v1:GetNumberVariable(c1543v3, c1543v4)
                        c1543v2 = mMovie
                        c1543v4 = c1543v0.mClipName
                        c1543v5 = 0
                        c1543v7 = c1543v0.mHorizontalPadding
                        c1543v6 = c1543v1 + c1543v7
                        c1543v2:SetNumberVariable(c1543v4, c1543v5, c1543v6)
                      end
                      c1543v2 = c1543v0.mPassword
                      if c1543v2 ~= true then
                        c1543v1 = false
                      else
                        c1543v1 = true
                      end
                      c1543v0.mPassword = c1543v1
                      c1543v1 = 800
                      c1543v2 = c1543v0.mWidth
                      if c1543v2 ~= nil then
                        c1543v1 = c1543v0.mWidth
                      end
                      c1543v2 = 57
                      c1543v3 = c1543v0.mMultiLine
                      if not c1543v3 then
                        c1543v2 = 30
                      else
                        c1543v3 = c1543v0.mHeight
                        if c1543v3 ~= nil then
                          c1543v6 = c1543v0.mHeight
                          c1543v5 = c1543v6 - 50
                          c1543v3 = math.max
                          c1543v2 = c1543v3(c1543v2, c1543v5)
                        end
                      end
                      c1543v3 = mMovie
                      c1543v5 = c1543v0.mClipName
                      c1543v6 = "Btn"
                      c1543v7 = 14
                      c1543v8 = c1543v1 + 20
                      c1543v3:Name__52c1b74e(c1543v5, c1543v6, c1543v7, c1543v8)
                      c1543v3 = mMovie
                      c1543v5 = c1543v0.mClipName
                      c1543v6 = "Btn"
                      c1543v7 = 15
                      c1543v8 = c1543v2 + 41
                      c1543v3:Name__52c1b74e(c1543v5, c1543v6, c1543v7, c1543v8)
                      c1543v3 = mMovie
                      c1543v5 = c1543v0.mClipName
                      c1543v6 = "Bg"
                      c1543v7 = 14
                      c1543v8 = c1543v1 + 20
                      c1543v3:Name__52c1b74e(c1543v5, c1543v6, c1543v7, c1543v8)
                      c1543v3 = mMovie
                      c1543v5 = c1543v0.mClipName
                      c1543v6 = "Bg"
                      c1543v7 = 15
                      c1543v8 = c1543v2 + 41
                      c1543v3:Name__52c1b74e(c1543v5, c1543v6, c1543v7, c1543v8)
                      c1543v3 = c1543v0.InputField
                      if c1543v3 == nil then
                        c1543v3 = v15
                        c1543v3 = c1543v3.Create
                        c1543v4 = mMovie
                        c1543v6 = c1543v0.mClipName
                        c1543v7 = ".InputBox"
                        c1543v5 = c1543v6 .. c1543v7
                        c1543v6 = c1543v0.mContent
                        c1543v7 = nil
                        c1543v8 = nil
                        c1543v9 = nil
                        c1543v10 = nil
                        c1543v11 = nil
                        c1543v12 = c1543v0.mSkipAutoFocus
                        c1543v3 = c1543v3(c1543v4, c1543v5, c1543v6, c1543v7, c1543v8, c1543v9, c1543v10, c1543v11, c1543v12)
                        c1543v0.InputField = c1543v3
                        c1543v3 = c1543v0.InputField
                        c1543v4 = c1543v0.InputField
                        c1543v4 = c1543v4.InputFieldFocused
                        c1543v3.ComponentInputFieldFocused = c1543v4
                        c1543v3 = c1543v0.InputField
                        c1543v4 = function(c1530v0, c1530v1)
                          local c1530v2, c1530v4, c1530v5
                          c1530v2 = v12
                          c1530v5 = c1543v0
                          c1530v5 = c1530v5.Id
                          c1530v4 = tonumber
                          c1530v4 = c1530v4(c1530v5)
                          c1530v2:FocusElementById(c1530v4)
                          c1530v0:ComponentInputFieldFocused(c1530v1)
                          do return end
                        end
                        c1543v3.InputFieldFocused = c1543v4
                        c1543v3 = c1543v0.InputField
                        c1543v4 = function(c1531v0)
                          local c1531v1, c1531v3, c1531v4
                          c1531v1 = v12
                          c1531v4 = c1543v0
                          c1531v4 = c1531v4.Id
                          c1531v3 = tonumber
                          c1531v3 = c1531v3(c1531v4)
                          c1531v1:FocusElementById(c1531v3)
                          do return end
                        end
                        c1543v3.mOnFocusedCallback = c1543v4
                        c1543v3 = c1543v0.InputField
                        c1543v4 = c1543v0.InputField
                        c1543v4 = c1543v4.InputFieldTextChanged
                        c1543v3.BaseInputFieldTextChanged = c1543v4
                        c1543v3 = c1543v0.InputField
                        c1543v4 = function(c1532v0, c1532v1)
                          local c1532v2, c1532v3
                          c1532v1 = c1532v1 or ""
                          c1532v2 = c1532v0.mLabel
                          if c1532v2 ~= c1532v1 then
                            c1532v2 = v15
                            c1532v3 = c1543v0
                            c1532v2(c1532v3)
                          end
                          c1532v0:BaseInputFieldTextChanged(c1532v1)
                          do return end
                        end
                        c1543v3.InputFieldTextChanged = c1543v4
                        c1543v3 = c1543v0.InputField
                        c1543v4 = 100
                        c1543v3.mInnerAlpha = c1543v4
                        c1543v3 = c1543v0.InputField
                        c1543v4 = true
                        c1543v3.mAltButtonVisible = c1543v4
                        c1543v3 = Engine.STACKSFollies
                        c1543v3 = c1543v3()
                        if c1543v3 then
                          c1543v3 = mMovie
                          c1543v5 = c1543v0.InputField
                          c1543v5 = c1543v5.mLabelClipName
                          c1543v6 = 49
                          c1543v7 = "Arial Unicode MS"
                          c1543v3:SetStringVariable(c1543v5, c1543v6, c1543v7)
                        end
                      end
                      c1543v3 = c1543v0.InputField
                      c1543v3.mMinSize = c1543v1
                      c1543v3 = c1543v0.InputField
                      c1543v3.mMaxSize = c1543v1
                      c1543v3 = c1543v0.InputField
                      c1543v3.mHeight = c1543v2
                      c1543v3 = mMovie
                      c1543v5 = c1543v0.InputField
                      c1543v5 = c1543v5.mLabelClipName
                      c1543v6 = 15
                      c1543v3:SetNumberVariable(c1543v5, c1543v6, c1543v2)
                      c1543v3 = mMovie
                      c1543v5 = c1543v0.InputField
                      c1543v5 = c1543v5.mLabelClipName
                      c1543v6 = 52
                      c1543v7 = c1543v0.mMultiLine
                      c1543v3:Name__d9713943(c1543v5, c1543v6, c1543v7)
                      c1543v3 = mMovie
                      c1543v5 = c1543v0.InputField
                      c1543v5 = c1543v5.mLabelClipName
                      c1543v6 = 39
                      c1543v7 = c1543v0.mMaxChars
                      c1543v3:SetNumberVariable(c1543v5, c1543v6, c1543v7)
                      c1543v5 = mMovie
                      c1543v7 = c1543v0.InputField
                      c1543v7 = c1543v7.mLabelClipName
                      c1543v8 = 50
                      c1543v5 = c1543v5:GetNumberVariable(c1543v7, c1543v8)
                      c1543v4 = c1543v5 * 1.5
                      c1543v3 = c1543v2 / c1543v4
                      c1543v4 = c1543v0.InputField
                      c1543v6 = c1543v0.mMultiLine
                      c1543v4:SetMultiline(c1543v6, c1543v3)
                      c1543v4 = c1543v0.mPassword
                      if c1543v4 then
                        c1543v4 = mMovie
                        c1543v6 = "/Lotus/Language/Menu/MainMenu_Password"
                        c1543v7 = false
                        c1543v4 = c1543v4:GetLocalized(c1543v6, c1543v7)
                        c1543v5 = c1543v0.InputField
                        c1543v7 = c1543v0.InputField
                        c1543v7 = c1543v7.TYPE
                        c1543v7 = c1543v7.PASSWORD
                        c1543v5:SetType(c1543v7, c1543v4, c1543v4)
                      end
                      c1543v4 = c1543v0.InputField
                      c1543v4:Redraw()
                    else
                      c1543v1 = c1543v0.mType
                      c1543v2 = v12
                      c1543v2 = c1543v2.INPUTCOUNT
                      if c1543v1 == c1543v2 then
                        c1543v1 = FlashMethod
                        c1543v2 = mMovie
                        c1543v4 = c1543v0.mClipName
                        c1543v5 = ".gotoAndStop"
                        c1543v3 = c1543v4 .. c1543v5
                        c1543v4 = "InputCount"
                        c1543v1(c1543v2, c1543v3, c1543v4)
                        c1543v1 = c1543v0.mButtonInfo
                        if c1543v1 == nil then
                          c1543v2 = { Name = "Minus", Row = 1, Width = 32, Label = "<DECR_BUTTON>", Callout = "<MENU_LTRIGGER2>", Callback = "DecreaseCount", SendReleaseCallback = true }
                          c1543v3 = { Name = "Count", Row = 1, Width = 180, Label = nil, InputField = true }
                          c1543v4 = { Name = "Plus", Row = 1, Width = 32, Label = "<INCR_BUTTON>", Callout = "<MENU_RTRIGGER2>", Callback = "IncreaseCount", SendReleaseCallback = true }
                          c1543v1 = {c1543v2, c1543v3, c1543v4}
                          c1543v0.mButtonInfo = c1543v1
                          c1543v3 = 1
                          c1543v4 = c1543v0.mButtonInfo
                          c1543v1 = #c1543v4
                          c1543v2 = 1
                          for c1543v3 = c1543v3, c1543v1, c1543v2 do
                            c1543v5 = c1543v0.mButtonInfo
                            c1543v4 = c1543v5[c1543v3]
                            c1543v6 = c1543v0.mClipName
                            c1543v7 = "."
                            c1543v8 = c1543v4.Name
                            c1543v5 = c1543v6 .. c1543v7 .. c1543v8
                            c1543v6 = c1543v4.Button
                            c1543v7 = c1543v4.InputField
                            c1543v6 = v15
                            c1543v6 = v15
                            c1543v7 = c1543v6.Create
                            c1543v8 = mMovie
                            c1543v11 = c1543v4.Label
                            c1543v10 = c1543v11 or ""
                            c1543v11 = c1543v4.Callback
                            c1543v12 = c1543v4.Callout
                            c1543v13 = nil
                            c1543v14 = nil
                            c1543v15 = nil
                            c1543v16 = c1543v4.InputField
                            c1543v7 = c1543v7(c1543v8, c1543v5, c1543v10, c1543v11, c1543v12, c1543v13, c1543v14, c1543v15, c1543v16)
                            c1543v8 = c1543v4.Width
                            c1543v7.mMinSize = c1543v8
                            c1543v8 = c1543v4.Width
                            c1543v7.mMaxSize = c1543v8
                            c1543v8 = 100
                            c1543v7.mInnerAlpha = c1543v8
                            c1543v8 = c1543v7.SetFocus
                            c1543v7.BaseSetFocus = c1543v8
                            c1543v8 = function(c1533v0, c1533v1)
                              local c1533v2
                              c1533v2 = c1543v7
                              c1533v2:BaseSetFocus(c1533v1)
                              if not c1533v1 then
                                c1533v2 = ConcludeCount
                                c1533v2()
                              end
                              do return end
                            end
                            c1543v7.SetFocus = c1543v8
                            c1543v8 = c1543v4.SendReleaseCallback
                            if c1543v8 then
                              c1543v8 = c1543v7.mOnPressedCallback
                              c1543v7.mOnReleasedCallback = c1543v8
                            end
                            c1543v8 = c1543v7.OnGamepadTransition
                            c1543v7.BaseOnGamepadTransition = c1543v8
                            c1543v8 = function(c1534v0)
                              local c1534v1, c1534v2, c1534v4, c1534v5
                              c1534v1 = c1534v0.mCallout
                              if c1534v1 then
                                c1534v1 = c1534v0:IsPlayingWithController()
                                c1534v2 = c1543v4
                                c1534v2 = c1534v2.Ternary
                                c1534v4 = ""
                                c1534v5 = c1543v4
                                c1534v5 = c1534v5.Label
                                c1534v5 = c1534v2(c1534v1, c1534v4, c1534v5)
                                c1534v0:SetText(c1534v5)
                                c1534v0:BaseOnGamepadTransition()
                              end
                              do return end
                            end
                            c1543v7.OnGamepadTransition = c1543v8
                            c1543v8 = c1543v4.InputField
                            if c1543v8 then
                              c1543v8 = c1543v7.InputFieldFocused
                              c1543v7.BaseInputFieldFocused = c1543v8
                              c1543v8 = function(c1535v0, c1535v1)
                                local c1535v2, c1535v3, c1535v4, c1535v5, c1535v6, c1535v7
                                c1535v0:BaseInputFieldFocused(c1535v1)
                                if c1535v1 then
                                  c1535v3 = c1543v7
                                  c1535v3 = c1535v3.mLabel
                                  c1535v2 = tonumber
                                  c1535v2 = c1535v2(c1535v3)
                                  c1535v3 = c1543v0
                                  c1535v4 = v27
                                  c1535v4 = c1535v4.Ternary
                                  if c1535v2 ~= nil then
                                    c1535v5 = false
                                  else
                                    c1535v5 = true
                                  end
                                  c1535v6 = 1
                                  c1535v7 = c1543v0
                                  c1535v7 = c1535v7.mCount
                                  c1535v4 = c1535v4(c1535v5, c1535v6, c1535v7)
                                  c1535v3.mCount = c1535v4
                                  do return end
                                end
                                c1535v2 = v15
                                c1535v2()
                                c1535v3 = c1543v7
                                c1535v3 = c1535v3.mLabel
                                c1535v2 = tonumber
                                c1535v2 = c1535v2(c1535v3)
                                if c1535v2 == nil then
                                  c1535v3 = c1543v7
                                  c1535v5 = "1"
                                  c1535v3:SetText(c1535v5)
                                  c1535v2 = 1
                                end
                                c1535v3 = c1543v0
                                c1535v3.mCount = c1535v2
                                do return end
                              end
                              c1543v7.InputFieldFocused = c1543v8
                              c1543v10 = "center"
                              c1543v7:SetTextAlignment(c1543v10)
                              c1543v8 = mMovie
                              c1543v12 = "Callout.Label"
                              c1543v10 = c1543v5 .. c1543v12
                              c1543v11 = 14
                              c1543v12 = c1543v4.Width
                              c1543v8:SetNumberVariable(c1543v10, c1543v11, c1543v12)
                            end
                            c1543v7:Resize()
                            c1543v4.Button = c1543v7
                          end
                          c1543v1 = c1543v0.mCountButton
                          if c1543v1 == nil then
                            c1543v2 = c1543v0.mButtonInfo
                            c1543v1 = c1543v2[2]
                            c1543v1 = c1543v1.Button
                            c1543v0.mCountButton = c1543v1
                            c1543v1 = c1543v0.mCountButton
                            c1543v3 = c1543v0.mCount
                            c1543v1:SetText(c1543v3)
                          end
                          c1543v1 = c1543v0.Id
                          v15 = c1543v1
                        end
                        c1543v1 = c1543v0.mCallback
                        if c1543v1 ~= nil then
                          c1543v1 = c1543v0.mCallback
                          c1543v2 = c1543v0.mCount
                          c1543v1(c1543v2)
                        end
                      else
                        c1543v1 = c1543v0.mType
                        c1543v2 = v12
                        c1543v2 = c1543v2.ICONBUTTON
                        if c1543v1 == c1543v2 then
                          c1543v1 = FlashMethod
                          c1543v2 = mMovie
                          c1543v4 = c1543v0.mClipName
                          c1543v5 = ".gotoAndStop"
                          c1543v3 = c1543v4 .. c1543v5
                          c1543v4 = "IconSelector"
                          c1543v1(c1543v2, c1543v3, c1543v4)
                          c1543v1 = mMovie
                          c1543v3 = c1543v0.mClipName
                          c1543v4 = "Btn"
                          c1543v5 = "noMenuSelection"
                          c1543v6 = true
                          c1543v1:SetVariableEx(c1543v3, c1543v4, c1543v5, c1543v6)
                          c1543v1 = c1543v0.mButtonWidth
                          if c1543v1 ~= nil then
                            c1543v1 = mMovie
                            c1543v3 = c1543v0.mClipName
                            c1543v4 = "Btn"
                            c1543v5 = 14
                            c1543v6 = c1543v0.mButtonWidth
                            c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                            c1543v1 = mMovie
                            c1543v3 = c1543v0.mClipName
                            c1543v4 = "Bg"
                            c1543v5 = 14
                            c1543v6 = c1543v0.mButtonWidth
                            c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
                          end
                          c1543v2 = 50
                          c1543v4 = c1543v0.mRows
                          c1543v3 = c1543v4 * 42
                          c1543v1 = c1543v2 + c1543v3
                          c1543v2 = mMovie
                          c1543v4 = c1543v0.mClipName
                          c1543v5 = "Btn"
                          c1543v6 = 15
                          c1543v2:Name__52c1b74e(c1543v4, c1543v5, c1543v6, c1543v1)
                          c1543v2 = mMovie
                          c1543v4 = c1543v0.mClipName
                          c1543v5 = "Bg"
                          c1543v6 = 15
                          c1543v2:Name__52c1b74e(c1543v4, c1543v5, c1543v6, c1543v1)
                          c1543v2 = c1543v0.mHeight
                          if c1543v2 == nil then
                            c1543v2 = c1543v1 + 10
                            c1543v0.mHeight = c1543v2
                          end
                          c1543v2 = c1543v0.mIconGrid
                          if c1543v2 == nil then
                            c1543v2 = getfenv
                            c1543v3 = 1
                            c1543v2 = c1543v2(c1543v3)
                            c1543v4 = "IconFocused"
                            c1543v5 = c1543v0.Id
                            c1543v3 = c1543v4 .. c1543v5
                            c1543v4 = function(c1536v0)
                              local c1536v1, c1536v2, c1536v3, c1536v4
                              local p8 = 0
                              if p8 == 0 then
                                c1536v1 = v15
                                if c1536v1 == nil then
                                  p8 = 2
                                else
                                  p8 = 1
                                end
                              end
                              if p8 == 1 then
                                c1536v1 = v15
                                c1536v1 = c1536v1.Id
                                c1536v2 = c1543v0
                                c1536v2 = c1536v2.Id
                                if c1536v1 == c1536v2 then
                                  p8 = 3
                                else
                                  p8 = 2
                                end
                              end
                              if p8 == 2 then
                                c1536v1 = v12
                                c1536v4 = c1543v0
                                c1536v4 = c1536v4.Id
                                c1536v3 = tonumber
                                c1536v3 = c1536v3(c1536v4)
                                c1536v1:FocusElementById(c1536v3)
                                p8 = 3
                              end
                              if p8 == 3 then
                                c1536v2 = c1543v0
                                c1536v2 = c1536v2.mIconGrid
                                c1536v1 = IsNull
                                c1536v1 = c1536v1(c1536v2)
                                if c1536v1 then
                                  p8 = 5
                                else
                                  p8 = 4
                                end
                              end
                              if p8 == 4 then
                                c1536v1 = c1543v0
                                c1536v1 = c1536v1.mIconGrid
                                c1536v3 = tonumber
                                c1536v3 = c1536v3(c1536v0)
                                c1536v1:FocusElementById(c1536v3)
                                p8 = 5
                              end
                              if p8 == 5 then
                                do return end
                              end
                            end
                            c1543v2[c1543v3] = c1543v4
                            c1543v4 = "IconUnfocused"
                            c1543v5 = c1543v0.Id
                            c1543v3 = c1543v4 .. c1543v5
                            c1543v4 = function(c1537v0)
                              local c1537v1, c1537v2, c1537v3
                              c1537v2 = c1543v0
                              c1537v2 = c1537v2.mIconGrid
                              c1537v1 = IsNull
                              c1537v1 = c1537v1(c1537v2)
                              if not c1537v1 then
                                c1537v1 = c1543v0
                                c1537v1 = c1537v1.mIconGrid
                                c1537v3 = tonumber
                                c1537v3 = c1537v3(c1537v0)
                                c1537v1:UnfocusElementById(c1537v3)
                              end
                              do return end
                            end
                            c1543v2[c1543v3] = c1543v4
                            c1543v4 = "IconPressed"
                            c1543v5 = c1543v0.Id
                            c1543v3 = c1543v4 .. c1543v5
                            c1543v4 = function(c1538v0)
                              local c1538v1, c1538v2, c1538v3
                              c1538v2 = c1543v0
                              c1538v2 = c1538v2.mIconGrid
                              c1538v1 = IsNull
                              c1538v1 = c1538v1(c1538v2)
                              if not c1538v1 then
                                c1538v1 = c1543v0
                                c1538v1 = c1538v1.mIconGrid
                                c1538v3 = tonumber
                                c1538v3 = c1538v3(c1538v0)
                                c1538v1:SelectElementById(c1538v3)
                                c1538v1 = v27
                                c1538v1 = c1538v1.PlaySound
                                c1538v2 = _G
                                c1538v2 = c1538v2.UISound_Select
                                c1538v1(c1538v2)
                              end
                              do return end
                            end
                            c1543v2[c1543v3] = c1543v4
                            c1543v3 = require
                            c1543v4 = "EE.Interface.Components.Grid"
                            c1543v3 = c1543v3(c1543v4)
                            c1543v4 = c1543v3.CreateGrid
                            c1543v5 = mMovie
                            c1543v7 = c1543v0.mClipName
                            c1543v8 = ".IconElement"
                            c1543v6 = c1543v7 .. c1543v8
                            c1543v7 = nil
                            c1543v8 = c1543v0.mColumns
                            c1543v9 = c1543v0.mRows
                            c1543v4 = c1543v4(c1543v5, c1543v6, c1543v7, c1543v8, c1543v9)
                            c1543v0.mIconGrid = c1543v4
                            c1543v4 = c1543v0.mIconGrid
                            c1543v7 = "IconPressed"
                            c1543v8 = c1543v0.Id
                            c1543v6 = c1543v7 .. c1543v8
                            c1543v8 = "IconFocused"
                            c1543v9 = c1543v0.Id
                            c1543v7 = c1543v8 .. c1543v9
                            c1543v9 = "IconUnfocused"
                            c1543v10 = c1543v0.Id
                            c1543v8 = c1543v9 .. c1543v10
                            c1543v4:SetCallbacks(c1543v6, c1543v7, c1543v8)
                            c1543v4 = c1543v0.mIconGrid
                            c1543v5 = 42
                            c1543v4.mColumnSeparation = c1543v5
                            c1543v4 = c1543v0.mIconGrid
                            c1543v5 = 42
                            c1543v4.mRowSeparation = c1543v5
                            c1543v4 = c1543v0.mIconGrid
                            c1543v5 = function(c1539v0)
                              local c1539v1, c1539v2, c1539v3, c1539v4, c1539v5, c1539v6, c1539v7, c1539v8
                              c1539v1 = c1539v0.mIndex
                              c1539v2 = c1543v0
                              c1539v2 = c1539v2.mIconGrid
                              c1539v2 = c1539v2.mSelectedIndex
                              if c1539v1 ~= c1539v2 then
                                c1539v1 = mMovie
                                c1539v4 = c1539v0.mClipName
                                c1539v5 = ".Btn"
                                c1539v3 = c1539v4 .. c1539v5
                                c1539v4 = "RectEdgeColor"
                                c1539v5 = v27
                                c1539v5 = c1539v5.FloatingContentHighlightProcedural
                                c1539v5 = c1539v5.r
                                c1539v6 = v27
                                c1539v6 = c1539v6.FloatingContentHighlightProcedural
                                c1539v6 = c1539v6.g
                                c1539v7 = v27
                                c1539v7 = c1539v7.FloatingContentHighlightProcedural
                                c1539v7 = c1539v7.b
                                c1539v8 = 0.5
                                c1539v1:Name__e243d995(c1539v3, c1539v4, c1539v5, c1539v6, c1539v7, c1539v8)
                              end
                              do return end
                            end
                            c1543v4.mOnFocusedCallback = c1543v5
                            c1543v4 = c1543v0.mIconGrid
                            c1543v5 = function(c1540v0)
                              local c1540v1, c1540v2, c1540v3, c1540v4, c1540v5, c1540v6, c1540v7, c1540v8
                              c1540v1 = c1540v0.mIndex
                              c1540v2 = c1543v0
                              c1540v2 = c1540v2.mIconGrid
                              c1540v2 = c1540v2.mSelectedIndex
                              if c1540v1 ~= c1540v2 then
                                c1540v1 = mMovie
                                c1540v4 = c1540v0.mClipName
                                c1540v5 = ".Btn"
                                c1540v3 = c1540v4 .. c1540v5
                                c1540v4 = "RectEdgeColor"
                                c1540v5 = 0
                                c1540v6 = 0
                                c1540v7 = 0
                                c1540v8 = 0
                                c1540v1:Name__e243d995(c1540v3, c1540v4, c1540v5, c1540v6, c1540v7, c1540v8)
                              end
                              do return end
                            end
                            c1543v4.mOnUnfocusedCallback = c1543v5
                            c1543v4 = c1543v0.mIconGrid
                            c1543v5 = function(c1541v0)
                              local c1541v1, c1541v2, c1541v3, c1541v4, c1541v5, c1541v6, c1541v7, c1541v8
                              c1541v1 = c1543v0
                              c1541v1 = c1541v1.mIconGrid
                              c1541v1 = c1541v1.mSelectedIndex
                              if c1541v1 ~= nil then
                                c1541v1 = mMovie
                                c1541v6 = c1543v0
                                c1541v6 = c1541v6.mIconGrid
                                c1541v6 = c1541v6.mElements
                                c1541v7 = c1543v0
                                c1541v7 = c1541v7.mIconGrid
                                c1541v7 = c1541v7.mSelectedIndex
                                c1541v4 = c1541v6[c1541v7]
                                c1541v4 = c1541v4.mClipName
                                c1541v5 = ".Btn"
                                c1541v3 = c1541v4 .. c1541v5
                                c1541v4 = "RectEdgeColor"
                                c1541v5 = 0
                                c1541v6 = 0
                                c1541v7 = 0
                                c1541v8 = 0
                                c1541v1:Name__e243d995(c1541v3, c1541v4, c1541v5, c1541v6, c1541v7, c1541v8)
                                c1541v1 = c1543v0
                                c1541v1 = c1541v1.mIconGrid
                                c1541v1 = c1541v1.mSelectedIndex
                                c1541v2 = c1541v0.mIndex
                                if c1541v1 ~= c1541v2 then
                                  c1541v1 = v15
                                  c1541v1()
                                end
                              end
                              c1541v1 = c1543v0
                              c1541v1 = c1541v1.mIconGrid
                              c1541v2 = c1541v0.mIndex
                              c1541v1.mSelectedIndex = c1541v2
                              c1541v1 = mMovie
                              c1541v4 = c1541v0.mClipName
                              c1541v5 = ".Btn"
                              c1541v3 = c1541v4 .. c1541v5
                              c1541v4 = "RectEdgeColor"
                              c1541v5 = v27
                              c1541v5 = c1541v5.FloatingContentHighlightProcedural
                              c1541v5 = c1541v5.r
                              c1541v6 = v27
                              c1541v6 = c1541v6.FloatingContentHighlightProcedural
                              c1541v6 = c1541v6.g
                              c1541v7 = v27
                              c1541v7 = c1541v7.FloatingContentHighlightProcedural
                              c1541v7 = c1541v7.b
                              c1541v8 = 0.75
                              c1541v1:Name__e243d995(c1541v3, c1541v4, c1541v5, c1541v6, c1541v7, c1541v8)
                              do return end
                            end
                            c1543v4.mOnSelectedCallback = c1543v5
                            c1543v4 = c1543v0.mIconGrid
                            c1543v5 = function(c1542v0)
                              local c1542v1, c1542v3, c1542v4, c1542v5, c1542v6, c1542v7, c1542v8
                              c1542v1 = mMovie
                              c1542v4 = c1542v0.mClipName
                              c1542v5 = ".Btn"
                              c1542v3 = c1542v4 .. c1542v5
                              c1542v4 = _G
                              c1542v4 = c1542v4.UIMaterial_RectangleNoDepth
                              c1542v1:OverrideMaterial(c1542v3, c1542v4)
                              c1542v1 = mMovie
                              c1542v4 = c1542v0.mClipName
                              c1542v5 = ".Icon"
                              c1542v3 = c1542v4 .. c1542v5
                              c1542v4 = c1542v0.Icon
                              c1542v1:OverrideTexture(c1542v3, c1542v4)
                              c1542v1 = mMovie
                              c1542v3 = c1542v0.mClipName
                              c1542v4 = "Icon"
                              c1542v5 = 11
                              c1542v6 = v27
                              c1542v6 = c1542v6.Content
                              c1542v1:Name__52c1b74e(c1542v3, c1542v4, c1542v5, c1542v6)
                              c1542v1 = mMovie
                              c1542v4 = c1542v0.mClipName
                              c1542v5 = ".Btn"
                              c1542v3 = c1542v4 .. c1542v5
                              c1542v4 = "RectInnerColor"
                              c1542v5 = 0
                              c1542v6 = 0
                              c1542v7 = 0
                              c1542v8 = 0
                              c1542v1:Name__e243d995(c1542v3, c1542v4, c1542v5, c1542v6, c1542v7, c1542v8)
                              c1542v1 = mMovie
                              c1542v4 = c1542v0.mClipName
                              c1542v5 = ".Btn"
                              c1542v3 = c1542v4 .. c1542v5
                              c1542v4 = "RectEdgeColor"
                              c1542v5 = 0
                              c1542v6 = 0
                              c1542v7 = 0
                              c1542v8 = 0
                              c1542v1:Name__e243d995(c1542v3, c1542v4, c1542v5, c1542v6, c1542v7, c1542v8)
                              do return end
                            end
                            c1543v4.mElementDrawCallback = c1543v5
                            c1543v6 = 1
                            c1543v7 = c1543v0.mIcons
                            c1543v4 = #c1543v7
                            c1543v5 = 1
                            for c1543v6 = c1543v6, c1543v4, c1543v5 do
                              c1543v7 = c1543v0.mIconGrid
                              c1543v9 = {}
                              c1543v12 = c1543v0.mIcons
                              c1543v11 = c1543v12[c1543v6]
                              c1543v9.Icon = c1543v11
                              c1543v10 = true
                              c1543v9 = {c1543v10}
                              c1543v7:AddElement(c1543v9)
                            end
                            c1543v4 = c1543v0.mIconGrid
                            c1543v6 = nil
                            c1543v7 = true
                            c1543v8 = true
                            c1543v4:Redraw(c1543v6, c1543v7, c1543v8)
                            c1543v4 = c1543v0.mStartIndex
                            if c1543v4 ~= nil then
                              c1543v4 = c1543v0.mStartIndex
                              c1543v5 = c1543v0.mIconGrid
                              c1543v5 = c1543v5:GetHowManyElements()
                              if c1543v4 <= c1543v5 then
                                c1543v4 = c1543v0.mIconGrid
                                c1543v7 = c1543v0.mStartIndex
                                c1543v6 = tonumber
                                c1543v6 = c1543v6(c1543v7)
                                c1543v4:SelectElement(c1543v6)
                              end
                            end
                          end
                        else
                          c1543v1 = c1543v0.mType
                          c1543v2 = v12
                          c1543v2 = c1543v2.CHOICE
                          c1543v1 = FlashMethod
                          c1543v2 = mMovie
                          c1543v4 = c1543v0.mClipName
                          c1543v5 = ".gotoAndStop"
                          c1543v3 = c1543v4 .. c1543v5
                          c1543v4 = "Choice"
                          c1543v1(c1543v2, c1543v3, c1543v4)
                          c1543v1 = mMovie
                          c1543v3 = "<CHECKMARK_OUTLINE>"
                          c1543v4 = true
                          c1543v1 = c1543v1:GetLocalized(c1543v3, c1543v4)
                          c1543v2 = v15
                          c1543v2 = c1543v2.Create
                          c1543v3 = mMovie
                          c1543v5 = c1543v0.mClipName
                          c1543v6 = ".YesBtn"
                          c1543v4 = c1543v5 .. c1543v6
                          c1543v7 = " "
                          c1543v9 = c1543v0.mButtonValues
                          c1543v8 = c1543v9[1]
                          c1543v8 = c1543v8.mLabel
                          c1543v5 = c1543v1 .. c1543v7 .. c1543v8
                          c1543v6 = "YesButton"
                          c1543v7 = nil
                          c1543v8 = nil
                          c1543v9 = true
                          c1543v2 = c1543v2(c1543v3, c1543v4, c1543v5, c1543v6, c1543v7, c1543v8, c1543v9)
                          c1543v0.YesBtn = c1543v2
                          c1543v2 = c1543v0.YesBtn
                          c1543v4 = c1543v0.mButtonValues
                          c1543v3 = c1543v4[1]
                          c1543v3 = c1543v3.mLabel
                          c1543v2.mBaseLabel = c1543v3
                          c1543v2 = v15
                          c1543v2 = c1543v2.Create
                          c1543v3 = mMovie
                          c1543v5 = c1543v0.mClipName
                          c1543v6 = ".NoBtn"
                          c1543v4 = c1543v5 .. c1543v6
                          c1543v7 = " "
                          c1543v9 = c1543v0.mButtonValues
                          c1543v8 = c1543v9[2]
                          c1543v8 = c1543v8.mLabel
                          c1543v5 = c1543v1 .. c1543v7 .. c1543v8
                          c1543v6 = "NoButton"
                          c1543v7 = nil
                          c1543v8 = nil
                          c1543v9 = true
                          c1543v2 = c1543v2(c1543v3, c1543v4, c1543v5, c1543v6, c1543v7, c1543v8, c1543v9)
                          c1543v0.NoBtn = c1543v2
                          c1543v2 = c1543v0.NoBtn
                          c1543v4 = c1543v0.mButtonValues
                          c1543v3 = c1543v4[2]
                          c1543v3 = c1543v3.mLabel
                          c1543v2.mBaseLabel = c1543v3
                          c1543v2 = c1543v0.YesBtn
                          c1543v2.Parent = c1543v0
                          c1543v2 = c1543v0.NoBtn
                          c1543v2.Parent = c1543v0
                          c1543v2 = v27
                          c1543v2 = c1543v2.Ternary
                          c1543v4 = c1543v0.mWidth
                          if c1543v4 == nil then
                            c1543v3 = false
                          else
                            c1543v3 = true
                          end
                          c1543v4 = c1543v0.mWidth
                          c1543v5 = 800
                          c1543v2 = c1543v2(c1543v3, c1543v4, c1543v5)
                          c1543v3 = c1543v2 * 0.6
                          c1543v4 = v27
                          c1543v4 = c1543v4.Ternary
                          c1543v6 = c1543v0.mButtonSpacing
                          if c1543v6 == nil then
                            c1543v5 = false
                          else
                            c1543v5 = true
                          end
                          c1543v6 = c1543v0.mButtonSpacing
                          c1543v7 = 0
                          c1543v4 = c1543v4(c1543v5, c1543v6, c1543v7)
                          c1543v5 = 0
                          c1543v6 = mMovie
                          c1543v8 = c1543v0.mClipName
                          c1543v9 = "Label"
                          c1543v10 = 52
                          c1543v11 = c1543v0.mMultiLine
                          c1543v6:Makeposshield(c1543v8, c1543v9, c1543v10, c1543v11)
                          c1543v6 = mMovie
                          c1543v8 = c1543v0.mClipName
                          c1543v9 = "Btn"
                          c1543v10 = 14
                          c1543v6:Name__52c1b74e(c1543v8, c1543v9, c1543v10, c1543v2)
                          c1543v6 = mMovie
                          c1543v8 = c1543v0.mClipName
                          c1543v9 = "Bg"
                          c1543v10 = 14
                          c1543v6:Name__52c1b74e(c1543v8, c1543v9, c1543v10, c1543v2)
                          c1543v6 = mMovie
                          c1543v8 = c1543v0.mClipName
                          c1543v9 = "Label"
                          c1543v10 = 14
                          c1543v6:Name__52c1b74e(c1543v8, c1543v9, c1543v10, c1543v3)
                          c1543v6 = ipairs
                          c1543v9 = c1543v0.YesBtn
                          c1543v10 = c1543v0.NoBtn
                          c1543v7 = {c1543v9, c1543v10}
                          c1543v6, c1543v7, c1543v8 = c1543v6(c1543v7)
                          for c1543v9, c1543v10 in c1543v6, c1543v7, c1543v8 do
                            c1543v11 = "center"
                            c1543v10.mAlignment = c1543v11
                            c1543v10:Redraw()
                            c1543v12 = mMovie
                            c1543v15 = c1543v10.mClipName
                            c1543v16 = ".Label"
                            c1543v14 = c1543v15 .. c1543v16
                            c1543v15 = 40
                            c1543v12 = c1543v12:GetNumberVariable(c1543v14, c1543v15)
                            c1543v13 = v27
                            c1543v13 = c1543v13.Ternary
                            c1543v14 = Engine.IsPlayingWithController
                            c1543v14 = c1543v14()
                            c1543v15 = 45
                            c1543v16 = 20
                            c1543v13 = c1543v13(c1543v14, c1543v15, c1543v16)
                            c1543v11 = c1543v12 + c1543v13
                            c1543v14 = c1543v5 * c1543v4
                            c1543v13 = c1543v3 + c1543v14
                            c1543v12 = c1543v13 + c1543v11
                            c1543v10:SetPosition(c1543v12)
                            c1543v5 = c1543v5 + 1
                          end
                          for c1543v9, c1543v10 in c1543v6, c1543v7, c1543v8 do
                            c1543v1 = c1543v0.mType
                            c1543v2 = v12
                            c1543v2 = c1543v2.CHECKMARK
                            if c1543v1 == c1543v2 then
                              c1543v1 = Engine.IsMobile
                              c1543v1 = c1543v1()
                              if c1543v1 then
                                c1543v1 = FlashMethod
                                c1543v2 = mMovie
                                c1543v4 = c1543v0.mClipName
                                c1543v5 = ".gotoAndStop"
                                c1543v3 = c1543v4 .. c1543v5
                                c1543v4 = "Choice"
                                c1543v1(c1543v2, c1543v3, c1543v4)
                                c1543v1 = mMovie
                                c1543v3 = "<CHECKMARK_OUTLINE>"
                                c1543v4 = true
                                c1543v1 = c1543v1:GetLocalized(c1543v3, c1543v4)
                                c1543v2 = v15
                                c1543v2 = c1543v2.Create
                                c1543v3 = mMovie
                                c1543v5 = c1543v0.mClipName
                                c1543v6 = ".YesBtn"
                                c1543v4 = c1543v5 .. c1543v6
                                c1543v7 = "ACCEPT"
                                c1543v5 = c1543v1 .. c1543v7
                                c1543v6 = "CheckmarkButton"
                                c1543v7 = nil
                                c1543v8 = nil
                                c1543v9 = false
                                c1543v2 = c1543v2(c1543v3, c1543v4, c1543v5, c1543v6, c1543v7, c1543v8, c1543v9)
                                c1543v0.YesBtn = c1543v2
                                c1543v2 = c1543v0.YesBtn
                                c1543v3 = "ACCEPT"
                                c1543v2.mBaseLabel = c1543v3
                                c1543v2 = c1543v0.YesBtn
                                c1543v2.Parent = c1543v0
                                c1543v2 = c1543v0.YesBtn
                                c1543v3 = false
                                c1543v2.mShowUnderline2 = c1543v3
                                c1543v2 = c1543v0.YesBtn
                                c1543v3 = false
                                c1543v2.mShowBacker = c1543v3
                                c1543v2 = nil
                                c1543v0.NoBtn = c1543v2
                                c1543v2 = mMovie
                                c1543v5 = c1543v0.mClipName
                                c1543v6 = ".NoBtn"
                                c1543v4 = c1543v5 .. c1543v6
                                c1543v5 = 13
                                c1543v6 = false
                                c1543v2:Name__d9713943(c1543v4, c1543v5, c1543v6)
                                c1543v2 = v27
                                c1543v2 = c1543v2.Ternary
                                c1543v4 = c1543v0.mWidth
                                if c1543v4 == nil then
                                  c1543v3 = false
                                else
                                  c1543v3 = true
                                end
                                c1543v4 = c1543v0.mWidth
                                c1543v5 = 800
                                c1543v2 = c1543v2(c1543v3, c1543v4, c1543v5)
                                c1543v3 = c1543v2 * 0.6
                                c1543v4 = v27
                                c1543v4 = c1543v4.Ternary
                                c1543v6 = c1543v0.mButtonSpacing
                                if c1543v6 == nil then
                                  c1543v5 = false
                                else
                                  c1543v5 = true
                                end
                                c1543v6 = c1543v0.mButtonSpacing
                                c1543v7 = 0
                                c1543v4 = c1543v4(c1543v5, c1543v6, c1543v7)
                                c1543v5 = mMovie
                                c1543v7 = c1543v0.mClipName
                                c1543v8 = "Label"
                                c1543v9 = 52
                                c1543v10 = c1543v0.mMultiLine
                                c1543v5:Makeposshield(c1543v7, c1543v8, c1543v9, c1543v10)
                                c1543v5 = mMovie
                                c1543v7 = c1543v0.mClipName
                                c1543v8 = "Btn"
                                c1543v9 = 14
                                c1543v5:Name__52c1b74e(c1543v7, c1543v8, c1543v9, c1543v2)
                                c1543v5 = mMovie
                                c1543v7 = c1543v0.mClipName
                                c1543v8 = "Bg"
                                c1543v9 = 14
                                c1543v5:Name__52c1b74e(c1543v7, c1543v8, c1543v9, c1543v2)
                                c1543v5 = mMovie
                                c1543v7 = c1543v0.mClipName
                                c1543v8 = "Label"
                                c1543v9 = 14
                                c1543v5:Name__52c1b74e(c1543v7, c1543v8, c1543v9, c1543v3)
                                c1543v5 = c1543v0.YesBtn
                                c1543v6 = "center"
                                c1543v5.mAlignment = c1543v6
                                c1543v5:Redraw()
                                c1543v7 = mMovie
                                c1543v10 = c1543v5.mClipName
                                c1543v11 = ".Label"
                                c1543v9 = c1543v10 .. c1543v11
                                c1543v10 = 40
                                c1543v7 = c1543v7:GetNumberVariable(c1543v9, c1543v10)
                                c1543v8 = v27
                                c1543v8 = c1543v8.Ternary
                                c1543v9 = Engine.IsPlayingWithController
                                c1543v9 = c1543v9()
                                c1543v10 = 45
                                c1543v11 = 20
                                c1543v8 = c1543v8(c1543v9, c1543v10, c1543v11)
                                c1543v6 = c1543v7 + c1543v8
                                c1543v9 = c1543v4 / 2
                                c1543v8 = c1543v3 + c1543v9
                                c1543v7 = c1543v8 + c1543v6
                                c1543v5:SetPosition(c1543v7)
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
      c1543v1 = mMovie
      c1543v4 = c1543v0.mClipName
      c1543v5 = ".Lock"
      c1543v3 = c1543v4 .. c1543v5
      c1543v4 = 13
      c1543v6 = c1543v0.mLocked
      c1543v5 = c1543v6 or false
      c1543v1:Name__d9713943(c1543v3, c1543v4, c1543v5)
      c1543v1 = c1543v0.mLocked
      if c1543v1 then
        c1543v1 = mMovie
        c1543v4 = c1543v0.mClipName
        c1543v5 = ".Lock"
        c1543v3 = c1543v4 .. c1543v5
        c1543v4 = lockIcon
        c1543v1:OverrideTexture(c1543v3, c1543v4)
        c1543v1 = mMovie
        c1543v4 = c1543v0.mClipName
        c1543v5 = ".Lock"
        c1543v3 = c1543v4 .. c1543v5
        c1543v4 = 11
        c1543v5 = v27
        c1543v5 = c1543v5.FloatingContent
        c1543v1:SetNumberVariable(c1543v3, c1543v4, c1543v5)
        c1543v1 = mMovie
        c1543v3 = c1543v0.mClipName
        c1543v4 = "Label"
        c1543v5 = 12
        c1543v6 = 60
        c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
      end
      c1543v1 = mMovie
      c1543v4 = c1543v0.mClipName
      c1543v5 = ".Btn"
      c1543v3 = c1543v4 .. c1543v5
      c1543v4 = 99
      c1543v5 = c1543v0.Id
      c1543v1:SetNumberVariable(c1543v3, c1543v4, c1543v5)
      c1543v1 = mMovie
      c1543v4 = c1543v0.mClipName
      c1543v5 = ".Btn"
      c1543v3 = c1543v4 .. c1543v5
      c1543v4 = v12
      c1543v4 = c1543v4.mRollOverElementCallback
      c1543v5 = v12
      c1543v5 = c1543v5.mRollOutElementCallback
      c1543v6 = v12
      c1543v6 = c1543v6.mSelectElementCallback
      c1543v7 = v12
      c1543v7 = c1543v7.mPressElementCallback
      c1543v1:SetCallbacks(c1543v3, c1543v4, c1543v5, c1543v6, c1543v7)
      c1543v1 = mMovie
      c1543v4 = c1543v0.mClipName
      c1543v5 = ".Bg"
      c1543v3 = c1543v4 .. c1543v5
      c1543v4 = _G
      c1543v4 = c1543v4.UIMaterial_RectangleNoDepth
      c1543v1:OverrideMaterial(c1543v3, c1543v4)
      c1543v1 = mMovie
      c1543v4 = c1543v0.mClipName
      c1543v5 = ".Bg"
      c1543v3 = c1543v4 .. c1543v5
      c1543v4 = "RectInnerColor"
      c1543v5 = v27
      c1543v5 = c1543v5.BackgroundProcedural
      c1543v5 = c1543v5.r
      c1543v6 = v27
      c1543v6 = c1543v6.BackgroundProcedural
      c1543v6 = c1543v6.g
      c1543v7 = v27
      c1543v7 = c1543v7.BackgroundProcedural
      c1543v7 = c1543v7.b
      c1543v8 = 1
      c1543v1:Name__e243d995(c1543v3, c1543v4, c1543v5, c1543v6, c1543v7, c1543v8)
      c1543v1 = c1543v0.mLabel
      if c1543v1 ~= nil then
        c1543v1 = c1543v0.mSkipLocalize
        if c1543v1 then
          c1543v1 = mMovie
          c1543v3 = c1543v0.mClipName
          c1543v4 = "Label"
          c1543v5 = 36
          c1543v6 = c1543v0.mLabel
          c1543v1:Name__f4a9016a(c1543v3, c1543v4, c1543v5, c1543v6)
        else
          c1543v1 = mMovie
          c1543v4 = c1543v0.mClipName
          c1543v5 = ".Label.text"
          c1543v3 = c1543v4 .. c1543v5
          c1543v4 = c1543v0.mLabel
          c1543v1:SetLocalized(c1543v3, c1543v4)
        end
      end
      c1543v1 = mMovie
      c1543v3 = c1543v0.mClipName
      c1543v4 = "Label"
      c1543v5 = 44
      c1543v6 = v27
      c1543v6 = c1543v6.FloatingContent
      c1543v1:Name__52c1b74e(c1543v3, c1543v4, c1543v5, c1543v6)
      c1543v1 = mMovie
      c1543v3 = c1543v0.mClipName
      c1543v4 = "Label"
      c1543v5 = 40
      c1543v1 = c1543v1:Name__46690123(c1543v3, c1543v4, c1543v5)
      c1543v0.mTextWidth = c1543v1
      c1543v1 = mMovie
      c1543v4 = c1543v0.mClipName
      c1543v5 = ".Label"
      c1543v3 = c1543v4 .. c1543v5
      c1543v4 = "ShowHyperlinkItem"
      c1543v1:Name__ba8f9a73(c1543v3, c1543v4)
      c1543v1 = c1543v0.mFocused
      if not c1543v1 then
        c1543v1 = v12
        c1543v1 = c1543v1.mOnUnfocusedCallback
        c1543v1(c1543v0)
        do return end
      end
      c1543v1 = v12
      c1543v1 = c1543v1.mOnFocusedCallback
      c1543v1(c1543v0)
      do return end
    end
    c1551v1.mElementDrawCallback = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1544v0, c1544v1)
      local c1544v2, c1544v3, c1544v4, c1544v5, c1544v6, c1544v7, c1544v8, c1544v9, c1544v10, c1544v11, c1544v12, c1544v13, c1544v14, c1544v15
      local p44 = 0
      if p44 == 0 then
        c1544v2 = 0
        c1544v3 = IsNull
        c1544v3 = c1544v3(c1544v1)
        if c1544v3 then
          p44 = 2
        else
          p44 = 1
        end
      end
      if p44 == 1 then
        c1544v4 = c1544v1.mClipName
        c1544v3 = IsNull
        c1544v3 = c1544v3(c1544v4)
        if not c1544v3 then
          p44 = 3
        else
          p44 = 2
        end
      end
      if p44 == 2 then
        do return c1544v2 end
      end
      if p44 == 3 then
        c1544v4 = c1544v1.mHeight
        c1544v3 = IsNull
        c1544v3 = c1544v3(c1544v4)
        if c1544v3 then
          p44 = 5
        else
          p44 = 4
        end
      end
      if p44 == 4 then
        c1544v2 = c1544v1.mHeight
        do return c1544v2 end
      end
      if p44 == 5 then
        c1544v3 = c1544v1.mType
        c1544v4 = v50
        c1544v4 = c1544v4.TITLE
        if c1544v3 ~= c1544v4 then
          p44 = 11
        else
          p44 = 6
        end
      end
      if p44 == 6 then
        c1544v3 = c1544v1.mMultiLine
        if c1544v3 ~= true then
          p44 = 11
        else
          p44 = 7
        end
      end
      if p44 == 7 then
        c1544v4 = mMovie
        c1544v7 = c1544v1.mClipName
        c1544v8 = ".Label"
        c1544v6 = c1544v7 .. c1544v8
        c1544v7 = 41
        c1544v4 = c1544v4:GetNumberVariable(c1544v6, c1544v7)
        c1544v3 = c1544v4 + 20
        c1544v4 = v47
        c1544v4 = c1544v4.Ternary
        c1544v6 = c1544v1.mVerticalPadding
        if c1544v6 ~= nil then
          p44 = 9
        else
          p44 = 8
        end
      end
      if p44 == 8 then
        c1544v5 = false
        p44 = 10
      end
      if p44 == 9 then
        c1544v5 = true
        p44 = 10
      end
      if p44 == 10 then
        c1544v6 = c1544v1.mVerticalPadding
        c1544v7 = 0
        c1544v4 = c1544v4(c1544v5, c1544v6, c1544v7)
        c1544v2 = c1544v3 + c1544v4
        do return c1544v2 end
      end
      if p44 == 11 then
        c1544v3 = c1544v1.mType
        c1544v4 = v50
        c1544v4 = c1544v4.INPUTBOX
        if c1544v3 ~= c1544v4 then
          p44 = 14
        else
          p44 = 12
        end
      end
      if p44 == 12 then
        c1544v3 = c1544v1.mMultiLine
        if c1544v3 ~= false then
          p44 = 14
        else
          p44 = 13
        end
      end
      if p44 == 13 then
        c1544v2 = 80
        do return c1544v2 end
      end
      if p44 == 14 then
        c1544v3 = c1544v1.mType
        c1544v4 = v50
        c1544v4 = c1544v4.IMAGE
        if c1544v3 ~= c1544v4 then
          p44 = 16
        else
          p44 = 15
        end
      end
      if p44 == 15 then
        c1544v3 = mMovie
        c1544v6 = c1544v1.mClipName
        c1544v7 = ".Image"
        c1544v5 = c1544v6 .. c1544v7
        c1544v6 = 15
        c1544v2 = c1544v3:GetNumberVariable(c1544v5, c1544v6)
        do return c1544v2 end
      end
      if p44 == 16 then
        c1544v3 = c1544v1.mType
        c1544v4 = v50
        c1544v4 = c1544v4.CHOICE
        if c1544v3 ~= c1544v4 then
          p44 = 18
        else
          p44 = 17
        end
      end
      if p44 == 17 then
        c1544v3 = c1544v1.mMultiLine
        if c1544v3 == true then
          p44 = 21
        else
          p44 = 18
        end
      end
      if p44 == 18 then
        c1544v3 = c1544v1.mType
        c1544v4 = v50
        c1544v4 = c1544v4.CHECKMARK
        if c1544v3 ~= c1544v4 then
          p44 = 27
        else
          p44 = 19
        end
      end
      if p44 == 19 then
        c1544v3 = c1544v1.mMultiLine
        if c1544v3 ~= true then
          p44 = 27
        else
          p44 = 20
        end
      end
      if p44 == 20 then
        c1544v3 = Engine.IsMobile
        c1544v3 = c1544v3()
        if not c1544v3 then
          p44 = 27
        else
          p44 = 21
        end
      end
      if p44 == 21 then
        c1544v3 = mMovie
        c1544v6 = c1544v1.mClipName
        c1544v7 = ".Label"
        c1544v5 = c1544v6 .. c1544v7
        c1544v6 = 41
        c1544v3 = c1544v3:GetNumberVariable(c1544v5, c1544v6)
        c1544v2 = c1544v3 + 20
        c1544v3 = mMovie
        c1544v5 = c1544v1.mClipName
        c1544v6 = "Btn"
        c1544v7 = 15
        c1544v3:Name__52c1b74e(c1544v5, c1544v6, c1544v7, c1544v2)
        c1544v3 = mMovie
        c1544v5 = c1544v1.mClipName
        c1544v6 = "Bg"
        c1544v7 = 15
        c1544v3:Name__52c1b74e(c1544v5, c1544v6, c1544v7, c1544v2)
        c1544v3 = ipairs
        c1544v6 = c1544v1.YesBtn
        c1544v7 = c1544v1.NoBtn
        c1544v4 = {c1544v6, c1544v7}
        c1544v3, c1544v4, c1544v5 = c1544v3(c1544v4)
        p44 = 25
      end
      if p44 == 22 then
        c1544v8 = mMovie
        c1544v11 = c1544v7.mClipName
        c1544v12 = ".Label"
        c1544v10 = c1544v11 .. c1544v12
        c1544v11 = 41
        c1544v8 = c1544v8:GetNumberVariable(c1544v10, c1544v11)
        c1544v11 = c1544v2 * 0.5
        c1544v10 = c1544v11 - 15
        c1544v9 = c1544v10 - c1544v8
        c1544v10 = Engine.IsMobile
        c1544v10 = c1544v10()
        if not c1544v10 then
          p44 = 24
        else
          p44 = 23
        end
      end
      if p44 == 23 then
        c1544v10 = mMovie
        c1544v12 = c1544v7.mClipName
        c1544v13 = 1
        c1544v15 = v50
        c1544v15 = c1544v15.CheckboxY
        c1544v14 = c1544v9 + c1544v15
        c1544v10:SetNumberVariable(c1544v12, c1544v13, c1544v14)
        p44 = 25
      end
      if p44 == 24 then
        c1544v10 = mMovie
        c1544v12 = c1544v7.mClipName
        c1544v13 = 1
        c1544v10:SetNumberVariable(c1544v12, c1544v13, c1544v9)
        p44 = 25
      end
      if p44 == 25 then
        p44 = 26
      end
      if p44 == 26 then
        do return c1544v2 end
      end
      if p44 == 27 then
        c1544v3 = v47
        c1544v4 = c1544v1.mType
        c1544v2 = c1544v3[c1544v4]
        do return c1544v2 end
      end
    end
    c1551v1.CalculateHeight = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1545v0, c1545v1)
      local c1545v2, c1545v3, c1545v4, c1545v5, c1545v6, c1545v7
      c1545v2 = 0
      c1545v4 = c1545v1.mWidth
      c1545v3 = IsNull
      c1545v3 = c1545v3(c1545v4)
      if not c1545v3 then
        c1545v2 = c1545v1.mWidth
      else
        c1545v2 = 800
      end
      c1545v3 = mMovie
      c1545v5 = "Container.Scrollbar"
      c1545v6 = 13
      c1545v3 = c1545v3:Name__9d78ed52(c1545v5, c1545v6)
      c1545v4 = v1
      c1545v4 = c1545v4.Ternary
      c1545v6 = 20
      c1545v7 = 0
      c1545v4 = c1545v4(c1545v3, c1545v6, c1545v7)
      c1545v2 = c1545v2 + c1545v4
      do return c1545v2 end
    end
    c1551v1.CalculateWidth = c1551v2
    c1551v1 = v12
    c1551v2 = v12
    c1551v2 = c1551v2.CalculateX
    c1551v1._GenericSettings_CalculateX = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1546v0, c1546v1)
      local c1546v2, c1546v3
      c1546v3 = c1546v1.mOffsetX
      c1546v2 = IsNull
      c1546v2 = c1546v2(c1546v3)
      if not c1546v2 then
        c1546v2 = c1546v1.mOffsetX
        do return c1546v2 end
      end
      c1546v2 = v12
      c1546v2 = c1546v2:_GenericSettings_CalculateX(c1546v1)
      do return c1546v2 end
    end
    c1551v1.CalculateX = c1551v2
    c1551v1 = v12
    c1551v2 = v12
    c1551v2 = c1551v2.CalculateY
    c1551v1._GenericSettings_CalculateY = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1547v0, c1547v1)
      local c1547v2, c1547v3, c1547v4, c1547v5, c1547v6, c1547v7, c1547v8, c1547v9
      c1547v2 = c1547v0.UniformElementHeights
      if c1547v2 then
        do return c1547v0:_GenericSettings_CalculateY(c1547v1) end
      end
      c1547v4 = c1547v1.Id
      c1547v2 = c1547v0:GetElementIndexById(c1547v4)
      c1547v3 = IsNull
      c1547v3 = c1547v3(c1547v2)
      if c1547v3 then
        c1547v3 = c1547v0.mInitialY
        do return c1547v3 end
      end
      c1547v3 = 1
      c1547v5 = c1547v0.mScroll
      c1547v4 = IsNull
      c1547v4 = c1547v4(c1547v5)
      if not c1547v4 then
        c1547v5 = c1547v0.mScroll
        c1547v4 = math.floor
        c1547v3 = c1547v4(c1547v5)
      end
      c1547v4 = 0
      c1547v7 = c1547v3
      c1547v5 = c1547v2 - 1
      c1547v6 = 1
      for c1547v7 = c1547v7, c1547v5, c1547v6 do
        c1547v8 = v12
        c1547v8 = c1547v8:GetElementById(c1547v7)
        c1547v9 = v12
        c1547v9 = c1547v9:CalculateHeight(c1547v8)
        c1547v4 = c1547v4 + c1547v9
      end
      c1547v6 = c1547v0.mInitialY
      c1547v5 = c1547v6 + c1547v4
      do return c1547v5 end
    end
    c1551v1.CalculateY = c1551v2
    c1551v1 = v12
    c1551v2 = v12
    c1551v2 = c1551v2.CalculateScrollBarHeight
    c1551v1._GenericSettings_CalculateScrollBarHeight = c1551v2
    c1551v1 = v12
    c1551v2 = function(c1548v0, c1548v1)
      local c1548v2, c1548v3, c1548v4, c1548v5, c1548v6, c1548v7, c1548v8, c1548v9, c1548v10
      c1548v2 = c1548v0.UniformElementHeights
      if c1548v2 then
        do return c1548v0:_GenericSettings_CalculateScrollBarHeight(c1548v1) end
      end
      c1548v2, c1548v3 = c1548v0:GetBounds()
      if not c1548v1 then
        c1548v1 = 0
      end
      c1548v4 = 0
      c1548v7 = c1548v2
      c1548v5 = c1548v3
      c1548v6 = 1
      for c1548v7 = c1548v7, c1548v5, c1548v6 do
        c1548v4 = c1548v4 + c1548v9
        c1548v8 = v12
        c1548v8 = c1548v8:GetElementById(c1548v7)
        c1548v9 = v12
        c1548v9 = c1548v9:CalculateHeight(c1548v8)
        c1548v10 = c1548v0.mForcedVerticalSeparation
        if c1548v10 < c1548v9 then
          c1548v9 = c1548v9 * 0.6
        end
      end
      c1548v5 = c1548v4 + c1548v1
      do return c1548v5 end
    end
    c1551v1.CalculateScrollBarHeight = c1551v2
    c1551v1 = mMovie
    c1551v3 = "/Lotus/Language/Menu/SearchPrompt"
    c1551v4 = false
    c1551v1 = c1551v1:GetLocalized(c1551v3, c1551v4)
    c1551v2 = require
    c1551v3 = "Lotus.Interface.Components.ThemedInputField"
    c1551v2 = c1551v2(c1551v3)
    c1551v3 = c1551v2.Create
    c1551v4 = mMovie
    c1551v5 = "Container.SearchBox"
    c1551v6 = nil
    c1551v7 = nil
    c1551v8 = "<MENU_LTHUMB>"
    c1551v3 = c1551v3(c1551v4, c1551v5, c1551v6, c1551v7, c1551v8)
    v35 = c1551v3
    c1551v3 = v35
    c1551v5 = v35
    c1551v5 = c1551v5.TYPE
    c1551v5 = c1551v5.PLAIN
    c1551v3:SetType(c1551v5, c1551v1, c1551v1)
    c1551v3 = v35
    c1551v4 = 200
    c1551v3.mMinSize = c1551v4
    c1551v3 = v35
    c1551v4 = 200
    c1551v3.mMaxSize = c1551v4
    c1551v3 = v35
    c1551v4 = 4
    c1551v3.mTextBuffer = c1551v4
    c1551v3 = v35
    c1551v4 = _G
    c1551v4 = c1551v4.UITexture_Search
    c1551v3.mAltButtonIcon = c1551v4
    c1551v3 = v35
    c1551v4 = true
    c1551v3.mAltButtonVisible = c1551v4
    c1551v3 = v35
    c1551v4 = v35
    c1551v4 = c1551v4.InputFieldTextChanged
    c1551v3.BaseInputFieldTextChanged = c1551v4
    c1551v3 = v35
    c1551v4 = function(c1549v0, c1549v1)
      local c1549v2, c1549v3, c1549v4, c1549v6, c1549v7, c1549v8
      local p12 = 0
      if p12 == 0 then
        c1549v2 = c1549v0.mLabel
        c1549v0:BaseInputFieldTextChanged(c1549v1)
        c1549v4 = c1549v0.mLabel
        if c1549v4 ~= "" then
          p12 = 2
        else
          p12 = 1
        end
      end
      if p12 == 1 then
        c1549v3 = _G
        c1549v3 = c1549v3.UITexture_Search
        if c1549v3 then
          p12 = 3
        else
          p12 = 2
        end
      end
      if p12 == 2 then
        c1549v3 = _G
        c1549v3 = c1549v3.UITexture_ClearSearch
        p12 = 3
      end
      if p12 == 3 then
        c1549v4 = c1549v0.mAltButtonicon
        if c1549v4 == c1549v3 then
          p12 = 5
        else
          p12 = 4
        end
      end
      if p12 == 4 then
        c1549v0.mAltButtonicon = c1549v3
        c1549v4 = c1549v0.mMovie
        c1549v7 = c1549v0.mClipName
        c1549v8 = ".BtnAlt"
        c1549v6 = c1549v7 .. c1549v8
        c1549v4:OverrideTexture(c1549v6, c1549v3)
        p12 = 5
      end
      if p12 == 5 then
        c1549v4 = c1549v0.mLabel
        if c1549v2 == c1549v4 then
          p12 = 7
        else
          p12 = 6
        end
      end
      if p12 == 6 then
        c1549v4 = v62
        c1549v4(c1549v2)
        p12 = 7
      end
      if p12 == 7 then
        do return end
      end
    end
    c1551v3.InputFieldTextChanged = c1551v4
    c1551v3 = v35
    c1551v4 = v35
    c1551v4 = c1551v4.OnGamepadTransition
    c1551v3.BaseOnGamepadTransition = c1551v4
    c1551v3 = v35
    c1551v4 = function(c1550v0)
      local c1550v1, c1550v2, c1550v4, c1550v5, c1550v6
      c1550v0:BaseOnGamepadTransition()
      c1550v2 = Engine.IsPlayingWithController
      c1550v2 = c1550v2()
      c1550v1 = not c1550v2
      c1550v0.mAltButtonVisible = c1550v1
      c1550v2 = mMovie
      c1550v4 = c1550v0.mClipName
      c1550v5 = "BtnAlt"
      c1550v6 = 13
      c1550v2:Makeposshield(c1550v4, c1550v5, c1550v6, c1550v1)
      do return end
    end
    c1551v3.OnGamepadTransition = c1551v4
    c1551v3 = v35
    c1551v5 = "/Lotus/Language/Menu/SearchPrompt"
    c1551v3:SetHint(c1551v5)
    c1551v3 = v35
    c1551v3:Redraw()
    c1551v3 = v35
    c1551v5 = false
    c1551v3:SetVisible(c1551v5)
    do return end
  end
  v46 = function()
    local c1552v0, c1552v1, c1552v2, c1552v3, c1552v4, c1552v5, c1552v6, c1552v7
    c1552v0 = v12
    c1552v2 = v31
    c1552v0 = c1552v0:GetElementIndexById(c1552v2)
    c1552v1 = IsNull
    c1552v1 = c1552v1(c1552v0)
    if not c1552v1 then
      c1552v1 = v12
      c1552v1 = c1552v1:GetElementInIndex(c1552v0)
      c1552v2 = mMovie
      c1552v5 = c1552v1.mCountButton
      c1552v5 = c1552v5.mClipName
      c1552v6 = ".Label"
      c1552v4 = c1552v5 .. c1552v6
      c1552v5 = 36
      c1552v2 = c1552v2:GetStringVariable(c1552v4, c1552v5)
      c1552v3 = tonumber
      c1552v3 = c1552v3(c1552v2)
      c1552v4 = c1552v1.mCount
      if c1552v3 ~= c1552v4 then
        c1552v3 = string.gsub
        c1552v5 = "|"
        c1552v6 = ""
        c1552v3 = c1552v3(c1552v2, c1552v5, c1552v6)
        c1552v4 = tonumber
        c1552v3 = c1552v4(c1552v3)
        if c1552v3 ~= nil then
          c1552v4 = Clamp
          c1552v6 = 0
          c1552v7 = c1552v1.mMaxCount
          c1552v3 = c1552v4(c1552v3, c1552v6, c1552v7)
          c1552v4 = math.floor
          c1552v3 = c1552v4(c1552v3)
          c1552v4 = c1552v1.mCountButton
          c1552v4:SetText(c1552v3)
          c1552v1.mCount = c1552v3
        else
          c1552v4 = c1552v1.mCountButton
          c1552v6 = ""
          c1552v4:SetText(c1552v6)
        end
        c1552v4 = v60
        c1552v4(c1552v1)
      end
    end
    do return end
  end
  v64 = function()
    local c1553v1, c1553v2, c1553v3, c1553v4, c1553v5, c1553v6, c1553v7, c1553v8, c1553v9, c1553v10, c1553v11, c1553v12, c1553v13, c1553v14, c1553v15, c1553v16, c1553v17, c1553v18, c1553v19, c1553v20, c1553v21
    local c1553v0 = v15
    c1553v0 = c1553v0.InputField
    if c1553v0 == nil then
      do return end
    end
    c1553v0 = mMovie
    c1553v2 = v15
    c1553v2 = c1553v2.InputField
    c1553v2 = c1553v2.mLabelClipName
    c1553v3 = 36
    c1553v0 = c1553v0:GetStringVariable(c1553v2, c1553v3)
    c1553v2 = mMovie
    c1553v4 = v15
    c1553v4 = c1553v4.InputField
    c1553v4 = c1553v4.mLabelClipName
    c1553v5 = 84
    c1553v2 = c1553v2:GetNumberVariable(c1553v4, c1553v5)
    c1553v1 = c1553v2 or 0
    c1553v4 = 1
    c1553v2 = string.sub
    c1553v2 = c1553v2(c1553v0, c1553v4, c1553v1)
    c1553v3 = string.find
    c1553v4 = string.reverse
    c1553v4 = c1553v4(c1553v2)
    c1553v5 = ","
    c1553v3 = c1553v3(c1553v4, c1553v5)
    if c1553v3 ~= nil then
      c1553v5 = string.len
      c1553v5 = c1553v5(c1553v2)
      c1553v4 = c1553v5 - c1553v3
      c1553v3 = c1553v4 + 1
    end
    if not ((not (c1553v3 == nil) and c1553v3 <= c1553v1)) then
      c1553v3 = 0
    end
    c1553v4 = string.find
    c1553v6 = ","
    c1553v7 = c1553v1 + 1
    c1553v4 = c1553v4(c1553v0, c1553v6, c1553v7)
    c1553v5 = string.sub
    c1553v0 = c1553v5(c1553v0, c1553v3, c1553v4)
    c1553v5 = string.gsub
    c1553v7 = "[, ]"
    c1553v8 = ""
    c1553v0 = c1553v5(c1553v0, c1553v7, c1553v8)
    c1553v5 = string.lower
    c1553v0 = c1553v5(c1553v0)
    c1553v5 = false
    c1553v6 = v25
    if c1553v0 == c1553v6 then
      do return end
    end
    v25 = c1553v0
    c1553v6 = ""
    c1553v7 = 0
    if c1553v0 ~= nil then
      c1553v8 = ""
      c1553v9 = string.len
      c1553v9 = c1553v9(c1553v0)
      c1553v12 = 1
      c1553v13 = 1
      c1553v10 = string.sub
      c1553v10 = c1553v10(c1553v0, c1553v12, c1553v13)
      c1553v12 = v26
      c1553v12 = c1553v12.Indexer
      c1553v11 = c1553v12[c1553v10]
      if c1553v11 ~= nil then
        c1553v13 = v26
        c1553v13 = c1553v13.Tags
        c1553v12 = #c1553v13
        c1553v15 = c1553v11
        c1553v13 = c1553v12
        c1553v14 = 1
        for c1553v15 = c1553v15, c1553v13, c1553v14 do
          c1553v17 = v26
          c1553v17 = c1553v17.Tags
          c1553v16 = c1553v17[c1553v15]
          c1553v19 = 1
          c1553v17 = string.sub
          c1553v17 = c1553v17(c1553v16, c1553v19, c1553v9)
          c1553v19 = v26
          c1553v19 = c1553v19.Real
          c1553v18 = c1553v19[c1553v15]
          c1553v5 = true
          c1553v21 = v26
          c1553v21 = c1553v21.Real
          c1553v19 = c1553v21[c1553v15]
          c1553v20 = "|"
          c1553v6 = c1553v6 .. c1553v19 .. c1553v20
          c1553v7 = c1553v7 + 1
          c1553v18 = v26
          c1553v18 = c1553v18.Real
          c1553v8 = c1553v18[c1553v15]
          c1553v18 = 8
          if c1553v18 <= c1553v7 then break end
          c1553v20 = 1
          c1553v21 = 1
          c1553v18 = string.sub
          c1553v18 = c1553v18(c1553v16, c1553v20, c1553v21)
          if c1553v10 ~= c1553v18 then break end
        end
      end
    end
    if c1553v5 then
      c1553v9 = v25
      c1553v6 = c1553v6 .. c1553v9
      c1553v8 = v15
      v16 = c1553v8
      c1553v8 = v4
      c1553v8 = c1553v8.OpenIME
      c1553v9 = v23
      c1553v8(c1553v9)
      c1553v8 = v4
      c1553v8 = c1553v8.IMESetTip
      c1553v9 = v25
      c1553v10 = v23
      c1553v8(c1553v9, c1553v10)
      c1553v8 = v4
      c1553v8 = c1553v8.IMESetTipCursor
      c1553v10 = v25
      c1553v9 = string.len
      c1553v9 = c1553v9(c1553v10)
      c1553v10 = v23
      c1553v8(c1553v9, c1553v10)
      c1553v8 = v4
      c1553v8 = c1553v8.IMESetOptions
      c1553v10 = v23
      c1553v11 = false
      c1553v8(c1553v6, c1553v10, c1553v11)
      c1553v8 = mMovie
      c1553v10 = v15
      c1553v10 = c1553v10.InputField
      c1553v10 = c1553v10.mLabelClipName
      c1553v11 = 86
      c1553v12 = true
      c1553v8:Name__d9713943(c1553v10, c1553v11, c1553v12)
      do return end
    end
    c1553v8 = v4
    c1553v8 = c1553v8.IMESetOptions
    c1553v9 = ""
    c1553v10 = v23
    c1553v11 = false
    c1553v8(c1553v9, c1553v10, c1553v11)
    c1553v8 = v4
    c1553v8 = c1553v8.CloseIME
    c1553v9 = v23
    c1553v8(c1553v9)
    c1553v8 = mMovie
    c1553v10 = v15
    c1553v10 = c1553v10.InputField
    c1553v10 = c1553v10.mLabelClipName
    c1553v11 = 86
    c1553v12 = false
    c1553v8:Name__d9713943(c1553v10, c1553v11, c1553v12)
    c1553v8 = nil
    v16 = c1553v8
    do return end
  end
  v65 = function()
    local c1554v0, c1554v1, c1554v2, c1554v3, c1554v4, c1554v5, c1554v6, c1554v7, c1554v8, c1554v9, c1554v10, c1554v11, c1554v12
    c1554v0 = v4
    c1554v0 = c1554v0.IMEGetFocusedValue
    c1554v1 = v23
    c1554v0 = c1554v0(c1554v1)
    v25 = c1554v0
    c1554v2 = mMovie
    c1554v4 = v16
    c1554v4 = c1554v4.InputField
    c1554v4 = c1554v4.mLabelClipName
    c1554v5 = 84
    c1554v2 = c1554v2:GetNumberVariable(c1554v4, c1554v5)
    c1554v1 = c1554v2 or 0
    c1554v2 = mMovie
    c1554v4 = v16
    c1554v4 = c1554v4.InputField
    c1554v4 = c1554v4.mLabelClipName
    c1554v5 = 36
    c1554v2 = c1554v2:GetStringVariable(c1554v4, c1554v5)
    c1554v5 = 1
    c1554v3 = string.sub
    c1554v3 = c1554v3(c1554v2, c1554v5, c1554v1)
    c1554v4 = string.find
    c1554v5 = string.reverse
    c1554v5 = c1554v5(c1554v3)
    c1554v6 = ","
    c1554v4 = c1554v4(c1554v5, c1554v6)
    c1554v5 = ""
    if c1554v4 ~= nil then
      c1554v7 = string.len
      c1554v7 = c1554v7(c1554v3)
      c1554v6 = c1554v7 - c1554v4
      c1554v4 = c1554v6 + 1
      if c1554v4 < c1554v1 then
        c1554v10 = 1
        c1554v8 = string.sub
        c1554v6 = c1554v8(c1554v2, c1554v10, c1554v4)
        c1554v7 = " "
        c1554v5 = c1554v6 .. c1554v7
      end
    end
    c1554v6 = string.find
    c1554v8 = ","
    c1554v6 = c1554v6(c1554v2, c1554v8, c1554v1)
    c1554v7 = ", "
    c1554v9 = c1554v5 .. c1554v0 .. c1554v7
    c1554v8 = string.len
    c1554v1 = c1554v8(c1554v9)
    if c1554v6 ~= nil then
      c1554v8 = string.sub
      c1554v7 = c1554v8(c1554v2, c1554v6)
      c1554v9 = c1554v5 .. c1554v0
      c1554v8 = string.len
      c1554v1 = c1554v8(c1554v9)
    end
    c1554v8 = mMovie
    c1554v10 = v16
    c1554v10 = c1554v10.InputField
    c1554v10 = c1554v10.mLabelClipName
    c1554v11 = 36
    c1554v12 = c1554v5 .. c1554v0 .. c1554v7
    c1554v8:SetStringVariable(c1554v10, c1554v11, c1554v12)
    c1554v8 = mMovie
    c1554v10 = v16
    c1554v10 = c1554v10.InputField
    c1554v10 = c1554v10.mLabelClipName
    c1554v11 = 84
    c1554v8:SetNumberVariable(c1554v10, c1554v11, c1554v1)
    c1554v8 = v4
    c1554v8 = c1554v8.CloseIME
    c1554v9 = v23
    c1554v8(c1554v9)
    c1554v8 = v4
    c1554v8 = c1554v8.IMESetFocusedOption
    c1554v9 = 1
    c1554v10 = v23
    c1554v8(c1554v9, c1554v10)
    c1554v8 = mMovie
    c1554v10 = v16
    c1554v10 = c1554v10.InputField
    c1554v10 = c1554v10.mLabelClipName
    c1554v11 = 86
    c1554v12 = false
    c1554v8:Name__d9713943(c1554v10, c1554v11, c1554v12)
    c1554v8 = nil
    v16 = c1554v8
    c1554v8 = v60
    c1554v8()
    do return end
  end
  v66 = function()
    local c1556v1, c1556v2, c1556v3, c1556v4, c1556v5, c1556v6
    local c1556v0 = v10
    if c1556v0 then
      c1556v1 = mMovie
      c1556v0 = IsNull
      c1556v0 = c1556v0(c1556v1)
      if not c1556v0 then
        c1556v0 = mMovie
        c1556v2 = RealDeltaTime
        c1556v0:Name__b7f5bbc5(c1556v2())
        c1556v1 = v9
        c1556v0 = IsNull
        c1556v0 = c1556v0(c1556v1)
        if not c1556v0 then
          c1556v0 = v9
          c1556v2 = RealDeltaTime
          c1556v0:Update(c1556v2())
        end
        c1556v1 = v12
        c1556v1 = c1556v1.mScrollBar
        c1556v0 = IsNull
        c1556v0 = c1556v0(c1556v1)
        if not c1556v0 then
          c1556v0 = v12
          c1556v0 = c1556v0.mScrollBar
          c1556v2 = RealDeltaTime
          c1556v0:Update(c1556v2())
        end
        c1556v1 = v28
        c1556v0 = IsNull
        c1556v0 = c1556v0(c1556v1)
        if not c1556v0 then
          c1556v1 = v30
          c1556v2 = RealDeltaTime
          c1556v2 = c1556v2()
          c1556v0 = c1556v1 - c1556v2
          v30 = c1556v0
          c1556v0 = v30
          c1556v1 = 0
          if c1556v0 <= c1556v1 then
            c1556v0 = v29
            c1556v2 = v52
            c1556v3 = v15
            c1556v3 = c1556v3.mMaxCount
            c1556v2 = c1556v2(c1556v3)
            c1556v1 = c1556v2 - 1
            if c1556v0 < c1556v1 then
              c1556v1 = v29
              c1556v0 = c1556v1 + 0.2
              v29 = c1556v0
            end
            c1556v0 = 0.25
            v30 = c1556v0
            c1556v0 = v48
            c1556v2 = v28
            c1556v4 = 10
            c1556v6 = v29
            c1556v5 = math.floor
            c1556v5 = c1556v5(c1556v6)
            c1556v3 = math.pow
            c1556v3 = c1556v3(c1556v4, c1556v5)
            c1556v1 = c1556v2 * c1556v3
            c1556v0(c1556v1)
          end
        end
        c1556v0 = v12
        c1556v2 = function(c1555v0)
          local c1555v1, c1555v2
          c1555v2 = c1555v0.mOnUpdate
          c1555v1 = IsNull
          c1555v1 = c1555v1(c1555v2)
          if not c1555v1 then
            c1555v1 = c1555v0.mOnUpdate
            c1555v2 = c1555v0.Id
            c1555v1(c1555v2)
          end
          do return end
        end
        c1556v0:RunForAllElements(c1556v2)
        c1556v0 = v31
        if c1556v0 ~= nil then
          c1556v0 = v46
          c1556v0()
        end
        c1556v0 = gFlashMgr
        c1556v0 = c1556v0:Name__467fe636()
        if c1556v0 == nil then
          c1556v1 = v23
          c1556v0 = IsNull
          c1556v0 = c1556v0(c1556v1)
          if not c1556v0 then
            c1556v0 = v15
            if c1556v0 ~= nil then
              c1556v0 = v15
              c1556v0 = c1556v0.mType
              c1556v1 = v0
              c1556v1 = c1556v1.INPUTBOX
              if c1556v0 == c1556v1 then
                c1556v0 = v4
                c1556v0 = c1556v0.IMEGetAndClearClicked
                c1556v0 = c1556v0()
                if c1556v0 then
                  c1556v0 = v65
                  c1556v0()
                end
                c1556v0 = v64
                c1556v0()
              end
            end
            c1556v0 = v4
            c1556v0 = c1556v0.Update
            c1556v1 = v23
            c1556v0(c1556v1)
          end
        end
        do return end
      end
    end
    do return end
  end
  Update = v66
  v66 = function()
    local c1559v0, c1559v1, c1559v2, c1559v3, c1559v4, c1559v5, c1559v6, c1559v7, c1559v8, c1559v9, c1559v10, c1559v11, c1559v12
    c1559v3 = _T
    c1559v4 = v17
    c1559v2 = c1559v3[c1559v4]
    c1559v2 = c1559v2()
    c1559v5 = 1
    c1559v3 = #c1559v2
    c1559v4 = 1
    for c1559v5 = c1559v5, c1559v3, c1559v4 do
      c1559v7 = c1559v2[c1559v5]
      c1559v7 = c1559v7.mType
      c1559v8 = v0
      c1559v8 = c1559v8.INPUTBOX
      c1559v7 = c1559v2[c1559v5]
      c1559v7 = c1559v7.mMultiLine
      c1559v0 = false
      c1559v6 = ResetLineCount
      c1559v7 = 0
      c1559v6(c1559v7)
      c1559v6 = c1559v2[c1559v5]
      c1559v6 = c1559v6.mHeight
      if c1559v6 == nil then
        c1559v7 = v47
        c1559v8 = c1559v2[c1559v5]
        c1559v8 = c1559v8.mType
        c1559v6 = c1559v7[c1559v8]
      end
      c1559v1 = c1559v6
      c1559v7 = c1559v2[c1559v5]
      c1559v7.Id = c1559v5
      c1559v7 = c1559v2[c1559v5]
      c1559v8 = c1559v2[c1559v5]
      c1559v8 = c1559v8.mValue
      c1559v7.mOriginalValue = c1559v8
      c1559v7 = c1559v2[c1559v5]
      c1559v7 = c1559v7.mOriginalValue
      if c1559v7 == nil then
        c1559v7 = c1559v2[c1559v5]
        c1559v8 = c1559v2[c1559v5]
        c1559v8 = c1559v8.mContent
        c1559v7.mOriginalValue = c1559v8
      end
      c1559v7 = c1559v2[c1559v5]
      c1559v7 = c1559v7.mLabel
      if c1559v7 ~= nil then
        c1559v7 = c1559v2[c1559v5]
        c1559v8 = ToSearchable
        c1559v9 = c1559v2[c1559v5]
        c1559v9 = c1559v9.mLabel
        c1559v8 = c1559v8(c1559v9)
        c1559v7.mSearchTerm = c1559v8
      end
      c1559v8 = v12
      c1559v8 = c1559v8.mUnfilteredElements
      c1559v9 = v1
      c1559v9 = c1559v9.CopyTable
      c1559v10 = c1559v2[c1559v5]
      c1559v7 = table.insert
      c1559v7(c1559v8, c1559v9(c1559v10))
      c1559v7 = v12
      c1559v9 = c1559v2[c1559v5]
      c1559v10 = true
      c1559v7:AddElement(c1559v9, c1559v10)
    end
    c1559v0 = v17
    if c1559v0 == nil then
      c1559v1 = v22
      c1559v0 = c1559v1 + 1
      v22 = c1559v0
      c1559v0 = v22
      c1559v1 = 10
      if c1559v0 < c1559v1 then
        c1559v0 = v9
        c1559v2 = 0.1
        c1559v3 = v66
        c1559v0:AddTimer(c1559v2, c1559v3)
        do return end
      end
      c1559v0 = v53
      c1559v0()
      do return end
    end
    c1559v0 = true
    c1559v1 = 0
    c1559v2 = v12
    c1559v3 = {}
    c1559v2.mUnfilteredElements = c1559v3
    c1559v4 = _T
    c1559v5 = v17
    c1559v3 = c1559v4[c1559v5]
    c1559v2 = IsNull
    c1559v2 = c1559v2(c1559v3)
    local p43 = 18
    if p43 == 18 then
      c1559v2 = 0
      c1559v3 = 0
      if not c1559v0 then
        p43 = 20
      else
        p43 = 19
      end
    end
    if p43 == 19 then
      c1559v2 = 14
      c1559v4 = v12
      c1559v5 = 43
      c1559v4.mForcedVerticalSeparation = c1559v5
      c1559v5 = v12
      c1559v5 = c1559v5:GetHowManyElements()
      c1559v6 = v12
      c1559v6 = c1559v6.mForcedVerticalSeparation
      c1559v4 = c1559v5 * c1559v6
      c1559v3 = c1559v3 + c1559v4
      c1559v4 = v12
      c1559v5 = 36
      c1559v4.mOriginalButtonHeight = c1559v5
      p43 = 21
    end
    if p43 == 20 then
      c1559v4 = v12
      c1559v5 = 20
      c1559v4.mForcedVerticalSeparation = c1559v5
      c1559v4 = v12
      c1559v6 = function(c1557v0)
        local c1557v1, c1557v2, c1557v3
        c1557v2 = c1559v3
        c1557v3 = v12
        c1557v3 = c1557v3:CalculateHeight(c1557v0)
        c1557v1 = c1557v2 + c1557v3
        c1559v3 = c1557v1
        c1557v1 = c1559v3
        c1557v2 = 560
        if c1557v1 < c1557v2 then
          c1557v2 = c1559v2
          c1557v1 = c1557v2 + 1
          c1559v2 = c1557v1
        end
        do return end
      end
      c1559v4:RunForAllElements(c1559v6)
      p43 = 21
    end
    if p43 == 21 then
      c1559v4 = v12
      c1559v4.UniformElementHeights = c1559v0
      c1559v4 = v12
      c1559v4 = c1559v4.UniformElementHeights
      if not c1559v4 then
        p43 = 24
      else
        p43 = 22
      end
    end
    if p43 == 22 then
      c1559v4 = v12
      c1559v4 = c1559v4:GetHowManyElements()
      if c1559v4 <= c1559v2 then
        p43 = 24
      else
        p43 = 23
      end
    end
    if p43 == 23 then
      c1559v4 = v12
      c1559v4.mVisibleElements = c1559v2
      c1559v4 = v12
      c1559v5 = 0
      c1559v4.mElementTransitionTime = c1559v5
      c1559v4 = v12
      c1559v6 = "Container.ScrollBar"
      c1559v7 = -5
      c1559v4:AttachScrollBar(c1559v6, c1559v7)
      c1559v4 = v12
      c1559v4:EnableSmoothScroll()
      c1559v4 = mMovie
      c1559v6 = "Container.OptionListMask"
      c1559v7 = 15
      c1559v8 = 600
      c1559v4:SetNumberVariable(c1559v6, c1559v7, c1559v8)
      p43 = 25
    end
    if p43 == 24 then
      c1559v4 = mMovie
      c1559v6 = "Container.ScrollBar"
      c1559v7 = 13
      c1559v8 = false
      c1559v4:Name__d9713943(c1559v6, c1559v7, c1559v8)
      c1559v4 = mMovie
      c1559v6 = "Container.OptionListMask"
      c1559v7 = 15
      c1559v8 = mMovie
      c1559v4:SetNumberVariable(c1559v6, c1559v7, c1559v8:GetMovieHeight())
      p43 = 25
    end
    if p43 == 25 then
      c1559v4 = mMovie
      c1559v6 = "Container.Message"
      c1559v7 = 13
      c1559v9 = v12
      c1559v9 = c1559v9:GetHowManyElements()
      if c1559v9 == 0 then
        p43 = 27
      else
        p43 = 26
      end
    end
    if p43 == 26 then
      c1559v8 = false
      p43 = 28
    end
    if p43 == 27 then
      c1559v8 = true
      p43 = 28
    end
    if p43 == 28 then
      c1559v4:Name__d9713943(c1559v6, c1559v7, c1559v8)
      c1559v4 = FlashInterpolate
      c1559v5 = mMovie
      c1559v6 = "_root"
      c1559v7 = 2
      c1559v9 = 12
      c1559v10 = 4
      c1559v8 = {c1559v9, c1559v10}
      c1559v10 = 100
      c1559v11 = 0
      c1559v9 = {c1559v10, c1559v11}
      c1559v10 = 0.2
      c1559v11 = 0
      c1559v12 = function()
        local c1558v0
        c1558v0 = false
        v11 = c1558v0
        do return end
      end
      c1559v4(c1559v5, c1559v6, c1559v7, c1559v8, c1559v9, c1559v10, c1559v11, c1559v12)
      c1559v4 = v59
      c1559v4()
      c1559v4 = v12
      c1559v4:Redraw()
      c1559v4 = v49
      c1559v4()
      do return end
    end
  end
  v67 = function()
    local c1560v0, c1560v2, c1560v3, c1560v4
    c1560v0 = mMovie
    c1560v2 = "MouseCatcherBtn"
    c1560v3 = 14
    c1560v4 = mMovie
    c1560v0:SetNumberVariable(c1560v2, c1560v3, c1560v4:GetViewportWidth())
    c1560v0 = mMovie
    c1560v2 = "MouseCatcherBtn"
    c1560v3 = 15
    c1560v4 = mMovie
    c1560v0:SetNumberVariable(c1560v2, c1560v3, c1560v4:GetViewportHeight())
    do return end
  end
  v68 = function()
    local c1563v0, c1563v1, c1563v2, c1563v3, c1563v4, c1563v5, c1563v6, c1563v7, c1563v8, c1563v9, c1563v10, c1563v11
    c1563v0 = require
    c1563v1 = "Lotus.Interface.Libs.TimerMgr"
    c1563v0 = c1563v0(c1563v1)
    c1563v1 = c1563v0.CreateTimerMgr
    c1563v1 = c1563v1()
    v9 = c1563v1
    c1563v1 = v1
    c1563v1 = c1563v1.PlaySound
    c1563v2 = _G
    c1563v2 = c1563v2.UISound_WindowOpen
    c1563v1(c1563v2)
    c1563v1 = mMovie
    c1563v4 = _T.RadialSolarMapOpen
    if c1563v4 ~= true then
      c1563v3 = false
    else
      c1563v3 = true
    end
    c1563v1:SetPreDrawUpdate(c1563v3)
    c1563v1 = mMovie
    c1563v3 = "MouseCatcherBtn"
    c1563v4 = "noMenuSelection"
    c1563v5 = true
    c1563v1:SetVariable(c1563v3, c1563v4, c1563v5)
    c1563v1 = v67
    c1563v1()
    c1563v2 = "FancyBits.LeftLines"
    c1563v3 = "FancyBits.LeftSideLine.FadeLineTop"
    c1563v4 = "FancyBits.LeftSideLine.FadeLineMiddle"
    c1563v5 = "FancyBits.LeftSideLine.FadeLineBottom"
    c1563v1 = {c1563v2, c1563v3, c1563v4, c1563v5}
    c1563v4 = 1
    c1563v2 = #c1563v1
    c1563v3 = 1
    for c1563v4 = c1563v4, c1563v2, c1563v3 do
      c1563v5 = mMovie
      c1563v7 = c1563v1[c1563v4]
      c1563v8 = leftLineMaterial
      c1563v5:OverrideMaterial(c1563v7, c1563v8)
    end
    c1563v3 = "FancyBits.RightLines"
    c1563v4 = "FancyBits.RightSideLine.FadeLineTop"
    c1563v5 = "FancyBits.RightSideLine.FadeLineMiddle"
    c1563v6 = "FancyBits.RightSideLine.FadeLineBottom"
    c1563v1 = {c1563v3, c1563v4, c1563v5, c1563v6}
    c1563v4 = 1
    c1563v2 = #c1563v1
    c1563v3 = 1
    for c1563v4 = c1563v4, c1563v2, c1563v3 do
      c1563v5 = mMovie
      c1563v7 = c1563v1[c1563v4]
      c1563v8 = rightLineMaterial
      c1563v5:OverrideMaterial(c1563v7, c1563v8)
    end
    c1563v2 = v57
    c1563v2()
    c1563v2 = v63
    c1563v2()
    c1563v2 = mMovie
    c1563v4 = "MouseCatcherBtn"
    c1563v5 = nil
    c1563v6 = nil
    c1563v7 = nil
    c1563v8 = "MouseCatcherPressed"
    c1563v2:SetCallbacks(c1563v4, c1563v5, c1563v6, c1563v7, c1563v8)
    c1563v2 = mMovie
    c1563v4 = true
    c1563v2:Name__f7d22364(c1563v4)
    c1563v2 = mMovie
    c1563v4 = "_root"
    c1563v5 = 12
    c1563v6 = 0
    c1563v2:SetNumberVariable(c1563v4, c1563v5, c1563v6)
    c1563v2 = mMovie
    c1563v4 = "_root"
    c1563v5 = 4
    c1563v6 = -15000
    c1563v2:SetNumberVariable(c1563v4, c1563v5, c1563v6)
    c1563v2 = function(c1561v0)
      local c1561v1, c1561v3
      c1561v1 = mMovie
      c1561v3 = c1561v0 * 0.9
      c1561v1:SetBackgroundAlpha(c1561v3)
      do return end
    end
    c1563v4 = 0
    c1563v2(c1563v4)
    c1563v3 = FlashInterpolate
    c1563v4 = mMovie
    c1563v5 = "_root"
    c1563v6 = 0
    c1563v7 = {c1563v2}
    c1563v9 = 1
    c1563v8 = {c1563v9}
    c1563v9 = 0.15
    c1563v10 = 0
    c1563v11 = function()
      local c1562v0
      c1562v0 = v66
      c1562v0()
      do return end
    end
    c1563v3(c1563v4, c1563v5, c1563v6, c1563v7, c1563v8, c1563v9, c1563v10, c1563v11)
    c1563v3 = v59
    c1563v3()
    c1563v3 = true
    v10 = c1563v3
    do return end
  end
  Initialize = v68
  v68 = function(c1564v0)
    local c1564v1, c1564v3, c1564v4, c1564v5
    if c1564v0 ~= "true" then
      c1564v1 = false
    else
      c1564v1 = true
    end
    v45 = c1564v1
    c1564v1 = mMovie
    c1564v3 = "Container.Title"
    c1564v4 = 13
    c1564v5 = v45
    c1564v1:Name__d9713943(c1564v3, c1564v4, c1564v5)
    do return end
  end
  ShowTitle = v68
  v68 = function(c1565v0, c1565v1, c1565v2)
    local c1565v3, c1565v5, c1565v6, c1565v7
    c1565v3 = mMovie
    c1565v5 = "Container.Title"
    c1565v6 = 52
    if c1565v1 ~= "true" then
      c1565v7 = false
    else
      c1565v7 = true
    end
    c1565v3:Name__d9713943(c1565v5, c1565v6, c1565v7)
    c1565v3 = mMovie
    c1565v5 = "Container.Title.text"
    c1565v3:SetLocalized(c1565v5, c1565v0)
    do return end
  end
  SetTitle = v68
  v68 = function(c1566v0)
    local c1566v1
    v13 = c1566v0
    c1566v1 = v59
    c1566v1()
    do return end
  end
  SetConfirmButtonLabel = v68
  v68 = function(c1567v0)
    local c1567v1
    if c1567v0 ~= "true" then
      c1567v1 = false
    else
      c1567v1 = true
    end
    v32 = c1567v1
    do return end
  end
  SetConfirmButtonVisibleWhenInactive = v68
  v68 = function(c1568v0)
    local c1568v1
    if c1568v0 ~= "true" then
      c1568v1 = false
    else
      c1568v1 = true
    end
    v14 = c1568v1
    c1568v1 = v33
    if not c1568v1 then
      c1568v1 = v14
    end
    v33 = c1568v1
    c1568v1 = v59
    c1568v1()
    do return end
  end
  SetConfirmButtonActive = v68
  v68 = function(c1569v0)
    local c1569v1
    v34 = c1569v0
    c1569v1 = v59
    c1569v1()
    do return end
  end
  SetHideActiveConfirmButton = v68
  v68 = function(c1570v0)
    local c1570v1
    if c1570v0 ~= "true" then
      c1570v1 = false
    else
      c1570v1 = true
    end
    v33 = c1570v1
    c1570v1 = v59
    c1570v1()
    do return end
  end
  SetConfirmButtonActiveOverride = v68
  v68 = function(c1571v0)
    local c1571v1
    v36 = c1571v0
    c1571v1 = v59
    c1571v1()
    do return end
  end
  SetCancelButtonLabel = v68
  v68 = function(c1572v0)
    local c1572v1
    if c1572v0 ~= "true" then
      c1572v1 = false
    else
      c1572v1 = true
    end
    v37 = c1572v1
    c1572v1 = v59
    c1572v1()
    do return end
  end
  SetCancelButtonActive = v68
  v68 = function(c1573v0)
    local c1573v1
    v38 = c1573v0
    c1573v1 = v59
    c1573v1()
    do return end
  end
  SetHideActiveCancelButton = v68
  v68 = function(c1574v0)
    local c1574v1, c1574v3, c1574v4, c1574v5
    c1574v1 = mMovie
    c1574v3 = "Container.Message"
    c1574v4 = 46
    c1574v5 = "center"
    c1574v1:SetStringVariable(c1574v3, c1574v4, c1574v5)
    c1574v1 = mMovie
    c1574v3 = "Container.Message.text"
    c1574v1:SetLocalized(c1574v3, c1574v0)
    do return end
  end
  SetNoElementsMessage = v68
  v68 = function(c1575v0)
    v17 = c1575v0
    do return end
  end
  SetElementsFunction = v68
  v68 = function(c1576v0)
    v39 = c1576v0
    do return end
  end
  SetCustomButtonFunction = v68
  v68 = function(c1577v0)
    local c1577v1, c1577v2, c1577v3, c1577v4
    c1577v1 = v40
    if c1577v1 then
      c1577v1 = v40
      c1577v3 = tonumber
      c1577v3 = c1577v3(c1577v0)
      c1577v4 = 4
      if c1577v3 ~= c1577v4 then
        c1577v2 = false
      else
        c1577v2 = true
      end
      c1577v1(c1577v2)
    end
    do return end
  end
  OnCustomButtonConfirmation = v68
  v68 = function()
    local c1578v0, c1578v1, c1578v2
    c1578v0 = v1
    c1578v0 = c1578v0.ShowConfirmMessage
    c1578v1 = v41
    c1578v1 = c1578v1.ConfirmLabel
    c1578v2 = "OnCustomButtonConfirmation"
    c1578v0(c1578v1, c1578v2)
    do return end
  end
  ShowCustomButtonConfirmation = v68
  v68 = function(c1579v0)
    v18 = c1579v0
    do return end
  end
  SetCallBack = v68
  v68 = function(c1580v0)
    v20 = c1580v0
    do return end
  end
  SetValueChangedCallBack = v68
  v68 = function()
    local c1582v0, c1582v1, c1582v2, c1582v3, c1582v4, c1582v5, c1582v6, c1582v7, c1582v8
    c1582v0 = Engine.IsConsole
    c1582v0 = c1582v0()
    c1582v5 = v26
    c1582v5 = c1582v5.Tags
    c1582v6 = string.lower
    c1582v8 = v26
    c1582v8 = c1582v8.Real
    c1582v7 = c1582v8[c1582v3]
    c1582v4 = table.insert
    c1582v4(c1582v5, c1582v6(c1582v7))
    c1582v6 = v26
    c1582v6 = c1582v6.Tags
    c1582v5 = c1582v6[c1582v3]
    c1582v6 = 1
    c1582v7 = 1
    c1582v4 = string.sub
    c1582v4 = c1582v4(c1582v5, c1582v6, c1582v7)
    if c1582v4 ~= c1582v0 then
      c1582v0 = c1582v4
      c1582v5 = v26
      c1582v5 = c1582v5.Indexer
      c1582v5[c1582v4] = c1582v3
    end
    c1582v0 = gFlashMgr
    c1582v2 = IMEOverlayMovie
    c1582v0 = c1582v0:FindMovie(c1582v2)
    v23 = c1582v0
    c1582v1 = v23
    c1582v0 = IsNull
    c1582v0 = c1582v0(c1582v1)
    if c1582v0 then
      c1582v1 = IMEOverlayMovie
      c1582v0 = IsNull
      c1582v0 = c1582v0(c1582v1)
      if not c1582v0 then
        c1582v0 = mMovie
        c1582v2 = IMEOverlayMovie
        c1582v0 = c1582v0:PushChildMovie(c1582v2)
        v23 = c1582v0
        c1582v0 = true
        v24 = c1582v0
      end
    end
    c1582v1 = v23
    c1582v0 = IsNull
    c1582v0 = c1582v0(c1582v1)
    c1582v0 = v26
    c1582v1 = {}
    c1582v0.Real = c1582v1
    c1582v0 = v26
    c1582v1 = {}
    c1582v0.Tags = c1582v1
    c1582v0 = v26
    c1582v1 = {}
    c1582v0.Indexer = c1582v1
    c1582v0 = ipairs
    c1582v1 = gGameData
    c1582v0, c1582v1, c1582v2 = c1582v0(c1582v1:Name__2e54c833())
    for c1582v3, c1582v4 in c1582v0, c1582v1, c1582v2 do
      c1582v6 = v26
      c1582v6 = c1582v6.Real
      c1582v7 = c1582v4.mDisplayName
      c1582v5 = table.insert
      c1582v5(c1582v6, c1582v7)
    end
    c1582v0 = table.sort
    c1582v1 = v26
    c1582v1 = c1582v1.Real
    c1582v2 = function(c1581v0, c1581v1)
      local c1581v2, c1581v3, c1581v4
      c1581v3 = string.lower
      c1581v3 = c1581v3(c1581v0)
      c1581v4 = string.lower
      c1581v4 = c1581v4(c1581v1)
      if c1581v4 <= c1581v3 then
        c1581v2 = false
      else
        c1581v2 = true
      end
      do return c1581v2 end
    end
    c1582v0(c1582v1, c1582v2)
    c1582v0 = nil
    c1582v3 = 1
    c1582v4 = v26
    c1582v4 = c1582v4.Real
    c1582v1 = #c1582v4
    c1582v2 = 1
    for c1582v3, c1582v4 in c1582v0, c1582v1, c1582v2 do
    end
    do return end
  end
  EnableHints = v68
  v68 = function(c1583v0, c1583v1, c1583v2)
    local c1583v3, c1583v4, c1583v5, c1583v6, c1583v7, c1583v8, c1583v9, c1583v10, c1583v11
    if c1583v2 == "1" then
      c1583v3 = v11
      if not c1583v3 then
        c1583v3 = v4
        c1583v3 = c1583v3.IsVisible
        c1583v3 = c1583v3()
        if c1583v3 then
          c1583v4 = v4
          c1583v4 = c1583v4.mTargetMovie
          c1583v5 = mMovie
          if c1583v4 ~= c1583v5 then
            c1583v3 = false
          else
            c1583v3 = true
          end
        end
        c1583v4 = string.find
        c1583v6 = "_ENTER"
        c1583v4 = c1583v4(c1583v1, c1583v6)
        if not c1583v3 then
          c1583v4 = gFlashMgr
          c1583v6 = _G
          c1583v6 = c1583v6.UIMovie_ConfirmMovie
          c1583v4 = c1583v4:HasMovie(c1583v6)
          if not ((c1583v4 or not c1583v3)) then
            c1583v4 = v65
            c1583v4()
            do return end
          end
        else
          if c1583v3 then
            c1583v4 = 0
            c1583v5 = string.find
            c1583v7 = "EN_LEFT"
            c1583v5 = c1583v5(c1583v1, c1583v7)
            if c1583v5 then
              c1583v4 = -1
            else
              c1583v5 = string.find
              c1583v7 = "EN_RIGHT"
              c1583v5 = c1583v5(c1583v1, c1583v7)
              if c1583v5 then
                c1583v4 = 1
              end
            end
            if c1583v4 ~= 0 then
              c1583v6 = v4
              c1583v6 = c1583v6.IMEGetFocusedIndex
              c1583v7 = v23
              c1583v5 = tonumber
              c1583v5 = c1583v5(c1583v6(c1583v7))
              c1583v6 = v4
              c1583v6 = c1583v6.IMESetFocusedOption
              c1583v7 = c1583v5 + c1583v4
              c1583v8 = v23
              c1583v6 = c1583v6(c1583v7, c1583v8)
              if not c1583v6 then
                c1583v7 = mMovie
                c1583v9 = v15
                c1583v9 = c1583v9.InputField
                c1583v9 = c1583v9.mLabelClipName
                c1583v10 = 84
                c1583v7 = c1583v7:GetNumberVariable(c1583v9, c1583v10)
                c1583v6 = c1583v7 or 0
                c1583v7 = mMovie
                c1583v9 = v15
                c1583v9 = c1583v9.InputField
                c1583v9 = c1583v9.mLabelClipName
                c1583v10 = 84
                c1583v11 = c1583v6 + c1583v4
                c1583v7:SetNumberVariable(c1583v9, c1583v10, c1583v11)
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
    local c1584v0
    c1584v0 = v53
    c1584v0()
    do return end
  end
  Close = v68
  v68 = function()
    local c1585v0
    c1585v0 = v55
    c1585v0()
    do return end
  end
  ExitScreen = v68
  v68 = function()
    local c1586v0
    c1586v0 = v11
    if c1586v0 then
      do return end
    end
    c1586v0 = v56
    c1586v0()
    do return end
  end
  FinishSelection = v68
  v68 = function()
    local c1587v0, c1587v1
    c1587v0 = v11
    if not c1587v0 then
      c1587v1 = v12
      c1587v0 = IsNull
      c1587v0 = c1587v0(c1587v1)
      if not c1587v0 then
        c1587v0 = v12
        c1587v0:SelectCurrentElement()
      end
    end
    do return end
  end
  onKeyUp_MENU_SELECT = v68
  v68 = function()
    local c1588v0
    c1588v0 = v11
    do return c1588v0 end
  end
  IsInputBlocked = v68
  v68 = function(c1589v0, c1589v1)
    local c1589v2
    c1589v2 = v67
    c1589v2()
    do return end
  end
  onViewportSizeChanged = v68
  v68 = function(c1590v0)
    local c1590v1, c1590v2, c1590v3
    c1590v2 = v12
    c1590v1 = IsNull
    c1590v1 = c1590v1(c1590v2)
    if not c1590v1 then
      c1590v1 = v12
      c1590v3 = tonumber
      c1590v3 = c1590v3(c1590v0)
      c1590v1:FocusElementById(c1590v3)
    end
    do return end
  end
  MenuEntryFocused = v68
  v68 = function(c1591v0)
    local c1591v1, c1591v2, c1591v4
    c1591v2 = v12
    c1591v1 = IsNull
    c1591v1 = c1591v1(c1591v2)
    if not c1591v1 then
      c1591v1 = v12
      c1591v1 = c1591v1:GetElementById(c1591v0)
      c1591v2 = IsNull
      c1591v2 = c1591v2(c1591v1)
      if not c1591v2 then
        c1591v2 = c1591v1.mAlwaysUnfocus
        if c1591v2 then
          c1591v2 = v12
          c1591v4 = tonumber
          c1591v4 = c1591v4(c1591v0)
          c1591v2:UnfocusElementById(c1591v4)
        end
      end
    end
    do return end
  end
  MenuEntryUnfocused = v68
  v68 = function(c1592v0)
    local c1592v1, c1592v2, c1592v3, c1592v4
    c1592v1 = v11
    if not c1592v1 then
      c1592v2 = v12
      c1592v1 = IsNull
      c1592v1 = c1592v1(c1592v2)
      if not c1592v1 then
        c1592v1 = v12
        c1592v3 = tonumber
        c1592v3 = c1592v3(c1592v0)
        c1592v4 = true
        c1592v1:SelectElementById(c1592v3, c1592v4)
        c1592v1 = v1
        c1592v1 = c1592v1.PlaySound
        c1592v2 = _G
        c1592v2 = c1592v2.UISound_Select
        c1592v1(c1592v2)
      end
    end
    do return end
  end
  MenuEntryPressed = v68
  v68 = function(c1593v0, c1593v1)
    local c1593v2, c1593v3, c1593v4, c1593v5
    c1593v2 = v11
    if not c1593v2 then
      c1593v3 = v12
      c1593v3 = c1593v3.mScrollBar
      c1593v2 = IsNull
      c1593v2 = c1593v2(c1593v3)
      if not c1593v2 then
        c1593v2 = v12
        c1593v2 = c1593v2.mScrollBar
        c1593v4 = tonumber
        c1593v4 = c1593v4(c1593v1)
        c1593v5 = _G
        c1593v5 = c1593v5.UISound_Scroll
        c1593v2:ScrollByStep(c1593v4, c1593v5)
      end
    end
    do return end
  end
  onKeyDown_MENU_MOUSE_Z = v68
  v68 = function(c1594v0, c1594v1)
    local c1594v2, c1594v4, c1594v5
    if not c1594v0 then
      c1594v2 = mMovie
      c1594v4 = v15
      c1594v4 = c1594v4.InputField
      c1594v4 = c1594v4.mLabelClipName
      c1594v5 = 36
      c1594v2:SetStringVariable(c1594v4, c1594v5, c1594v1)
      c1594v2 = v15
      c1594v2.mContent = c1594v1
      c1594v2 = v60
      c1594v2()
    end
    do return end
  end
  OSKInputBoxCallback = v68
  v48 = function(c1595v0)
    local c1595v1, c1595v2, c1595v3, c1595v4, c1595v5, c1595v6, c1595v7, c1595v8, c1595v9, c1595v10, c1595v11
    c1595v3 = v15
    c1595v3 = c1595v3.mCount
    c1595v2 = tonumber
    c1595v2 = c1595v2(c1595v3)
    c1595v3 = tonumber
    c1595v3 = c1595v3(c1595v0)
    c1595v1 = c1595v2 + c1595v3
    c1595v2 = 0
    c1595v3 = v15
    c1595v3 = c1595v3.mMinCount
    if c1595v3 ~= nil then
      c1595v4 = v15
      c1595v4 = c1595v4.mMinCount
      c1595v3 = tonumber
      c1595v2 = c1595v3(c1595v4)
    end
    if c1595v1 < c1595v2 then
      c1595v1 = c1595v2
    end
    c1595v4 = v15
    c1595v4 = c1595v4.mMaxCount
    c1595v3 = tonumber
    c1595v3 = c1595v3(c1595v4)
    if c1595v3 < c1595v1 then
      c1595v3 = v15
      c1595v1 = c1595v3.mMaxCount
    end
    c1595v3 = Engine.IsPlayingWithController
    c1595v3 = c1595v3()
    if c1595v3 == nil then
      c1595v3 = v1
      c1595v3 = c1595v3.CreateParticles
      c1595v4 = mMovie
      c1595v6 = v15
      c1595v6 = c1595v6.mClipName
      c1595v7 = ".Callouts."
      c1595v8 = v1
      c1595v8 = c1595v8.Ternary
      c1595v10 = 0
      if c1595v0 <= c1595v10 then
        c1595v9 = false
      else
        c1595v9 = true
      end
      c1595v10 = "Right"
      c1595v11 = "Left"
      c1595v8 = c1595v8(c1595v9, c1595v10, c1595v11)
      c1595v5 = c1595v6 .. c1595v7 .. c1595v8
      c1595v6 = v1
      c1595v6 = c1595v6.Ternary
      c1595v8 = 0
      if c1595v0 <= c1595v8 then
        c1595v7 = false
      else
        c1595v7 = true
      end
      c1595v8 = _G
      c1595v8 = c1595v8.UIFx_RightBumperPress
      c1595v9 = _G
      c1595v9 = c1595v9.UIFx_LeftBumperPress
      c1595v6 = c1595v6(c1595v7, c1595v8, c1595v9)
      c1595v7 = 0
      c1595v8 = 0
      c1595v3(c1595v4, c1595v5, c1595v6, c1595v7, c1595v8)
    end
    c1595v3 = v15
    c1595v3.mCount = c1595v1
    c1595v3 = v15
    c1595v3 = c1595v3.mCountButton
    if c1595v3 then
      c1595v3 = v15
      c1595v3 = c1595v3.mCountButton
      c1595v6 = v1
      c1595v6 = c1595v6.FormatNumber
      c1595v7 = v15
      c1595v7 = c1595v7.mCount
      c1595v8 = 0
      c1595v5 = tostring
      c1595v5 = c1595v5(c1595v6(c1595v7, c1595v8))
      c1595v3:SetText(c1595v5)
    end
    c1595v3 = v15
    c1595v3 = c1595v3.mCallback
    if c1595v3 ~= nil then
      c1595v3 = v15
      c1595v3 = c1595v3.mCallback
      c1595v3(c1595v1)
    end
    c1595v3 = v60
    c1595v3()
    do return end
  end
  v68 = function(c1596v0)
    local c1596v1, c1596v2
    c1596v1 = v11
    if not c1596v1 then
      c1596v2 = v15
      c1596v1 = IsNull
      c1596v1 = c1596v1(c1596v2)
      if not c1596v1 then
        c1596v1 = v15
        c1596v1 = c1596v1.mType
        c1596v2 = v0
        c1596v2 = c1596v2.INPUTCOUNT
        if c1596v1 == c1596v2 then
          c1596v1 = v48
          c1596v2 = 1
          c1596v1(c1596v2)
          c1596v1 = 1
          v28 = c1596v1
          c1596v1 = 0
          v29 = c1596v1
          c1596v1 = 0.6
          v30 = c1596v1
        end
      end
    end
    do return end
  end
  v69 = function(c1597v0)
    local c1597v1, c1597v2
    c1597v1 = v11
    if not c1597v1 then
      c1597v2 = v15
      c1597v1 = IsNull
      c1597v1 = c1597v1(c1597v2)
      if not c1597v1 then
        c1597v1 = v15
        c1597v1 = c1597v1.mType
        c1597v2 = v0
        c1597v2 = c1597v2.INPUTCOUNT
        if c1597v1 == c1597v2 then
          c1597v1 = v48
          c1597v2 = -1
          c1597v1(c1597v2)
          c1597v1 = -1
          v28 = c1597v1
          c1597v1 = 0
          v29 = c1597v1
          c1597v1 = 0.6
          v30 = c1597v1
        end
      end
    end
    do return end
  end
  v70 = function()
    local c1598v0
    v28 = c1598v0
    do return end
  end
  v71 = function(c1599v0, c1599v1)
    local c1599v2
    if c1599v1 then
      c1599v2 = v68
      c1599v2(c1599v0)
      do return end
    end
    c1599v2 = v70
    c1599v2()
    do return end
  end
  IncreaseCount = v71
  v71 = function(c1600v0, c1600v1)
    local c1600v2
    if c1600v1 then
      c1600v2 = v69
      c1600v2(c1600v0)
      do return end
    end
    c1600v2 = v70
    c1600v2()
    do return end
  end
  DecreaseCount = v71
  v71 = function()
    local c1601v0
    c1601v0 = v70
    c1601v0()
    do return end
  end
  ConcludeCount = v71
  v71 = function()
    local c1602v0, c1602v1
    c1602v0 = v11
    if not c1602v0 then
      c1602v1 = v15
      c1602v0 = IsNull
      c1602v0 = c1602v0(c1602v1)
      if not c1602v0 then
        c1602v0 = v15
        c1602v0 = c1602v0.mType
        c1602v1 = v0
        c1602v1 = c1602v1.INPUTCOUNT
        if c1602v0 == c1602v1 then
          c1602v0 = v68
          c1602v1 = v15
          c1602v1 = c1602v1.Id
          c1602v0(c1602v1)
        end
      end
    end
    c1602v0 = true
    do return c1602v0 end
  end
  onKeyDown_MENU_RTRIGGER2 = v71
  v71 = function()
    local c1603v0, c1603v1
    c1603v0 = v11
    if not c1603v0 then
      c1603v1 = v15
      c1603v0 = IsNull
      c1603v0 = c1603v0(c1603v1)
      if not c1603v0 then
        c1603v0 = v15
        c1603v0 = c1603v0.mType
        c1603v1 = v0
        c1603v1 = c1603v1.INPUTCOUNT
        if c1603v0 == c1603v1 then
          c1603v0 = v69
          c1603v1 = v15
          c1603v1 = c1603v1.Id
          c1603v0(c1603v1)
        end
      end
    end
    c1603v0 = true
    do return c1603v0 end
  end
  onKeyDown_MENU_LTRIGGER2 = v71
  v71 = function()
    local c1604v0
    c1604v0 = v70
    c1604v0()
    c1604v0 = true
    do return c1604v0 end
  end
  onKeyUp_MENU_LTRIGGER2 = v71
  v71 = function()
    local c1605v0
    c1605v0 = v70
    c1605v0()
    c1605v0 = true
    do return c1605v0 end
  end
  onKeyUp_MENU_RTRIGGER2 = v71
  v71 = function()
    local c1606v0, c1606v1
    c1606v0 = v53
    c1606v1 = true
    c1606v0(c1606v1)
    c1606v0 = true
    do return c1606v0 end
  end
  onKeyUp_HIDE_PAUSE_MENU = v71
  v71 = function()
    local c1607v0, c1607v1, c1607v2, c1607v3, c1607v4, c1607v5, c1607v6, c1607v7
    c1607v4 = 1
    c1607v2 = c1607v1 - 1
    c1607v3 = 1
    for c1607v4 = c1607v4, c1607v2, c1607v3 do
      c1607v6 = v12
      c1607v6 = c1607v6.mElements
      c1607v5 = c1607v6[c1607v4]
      if c1607v5 then
        c1607v6 = c1607v5.mType
        c1607v7 = v0
        c1607v7 = c1607v7.INPUTBOX
        if c1607v6 == c1607v7 then
          c1607v1 = c1607v4
        end
      end
    end
    c1607v0 = v12
    c1607v0 = c1607v0.mSelectedElementIndex
    c1607v3 = 1
    c1607v4 = v12
    c1607v4 = c1607v4.mElements
    c1607v1 = #c1607v4
    c1607v2 = 1
    for c1607v3 = c1607v3, c1607v1, c1607v2 do
      c1607v5 = v12
      c1607v5 = c1607v5.mElements
      c1607v4 = c1607v5[c1607v3]
      if c1607v4 then
        c1607v5 = c1607v4.mType
        c1607v6 = v0
        c1607v6 = c1607v6.INPUTBOX
        if c1607v5 == c1607v6 then
          c1607v5 = c1607v4.InputField
          c1607v5 = c1607v5.mSelected
          if c1607v5 then
            c1607v0 = c1607v4.mIndex
          end
        end
      end
    end
    c1607v1 = c1607v0
    if c1607v1 == nil then
      do return end
    end
    c1607v4 = c1607v1 + 1
    c1607v5 = v12
    c1607v5 = c1607v5.mElements
    c1607v2 = #c1607v5
    c1607v3 = 1
    for c1607v4 = c1607v4, c1607v2, c1607v3 do
      c1607v6 = v12
      c1607v6 = c1607v6.mElements
      c1607v5 = c1607v6[c1607v4]
      if c1607v5 then
        c1607v6 = c1607v5.mType
        c1607v7 = v0
        c1607v7 = c1607v7.INPUTBOX
        if c1607v6 == c1607v7 then
          c1607v1 = c1607v4
        end
      end
    end
    if c1607v1 ~= c1607v0 then
      c1607v2 = print
      c1607v3 = "found"
      c1607v2(c1607v3, c1607v1)
      c1607v2 = v12
      c1607v2:SelectElement(c1607v1)
    end
    c1607v2 = true
    do return c1607v2 end
  end
  onKeyDown_NEXT_MENU = v71
  v71 = function(c1608v0)
    do return end
  end
  ConfirmPopup = v71
  v71 = function(c1609v0)
    local c1609v1, c1609v2
    c1609v1 = v1
    c1609v1 = c1609v1.DoOpenWebBrowser
    c1609v1(c1609v0)
    c1609v1 = v2
    c1609v1 = c1609v1.OnHyperlinkPressed
    c1609v2 = mMovie
    c1609v1(c1609v2)
    do return end
  end
  ShowHyperlinkItem = v71
  v71 = function(c1610v0)
    local c1610v1, c1610v2, c1610v3, c1610v4, c1610v5, c1610v7, c1610v8
    c1610v1 = IsNull
    c1610v1 = c1610v1(c1610v0)
    if not c1610v1 then
      c1610v1 = mMovie
      c1610v3 = "<CHECKMARK>"
      c1610v4 = true
      c1610v1 = c1610v1:GetLocalized(c1610v3, c1610v4)
      c1610v2 = mMovie
      c1610v4 = "<CHECKMARK_OUTLINE>"
      c1610v5 = true
      c1610v2 = c1610v2:GetLocalized(c1610v4, c1610v5)
      c1610v3 = c1610v0.Parent
      c1610v4 = true
      c1610v3.mValue = c1610v4
      c1610v7 = " "
      c1610v8 = c1610v0.mBaseLabel
      c1610v5 = c1610v1 .. c1610v7 .. c1610v8
      c1610v0:SetText(c1610v5)
      c1610v3 = c1610v0.Parent
      c1610v3 = c1610v3.NoBtn
      c1610v7 = " "
      c1610v8 = c1610v0.Parent
      c1610v8 = c1610v8.NoBtn
      c1610v8 = c1610v8.mBaseLabel
      c1610v5 = c1610v2 .. c1610v7 .. c1610v8
      c1610v3:SetText(c1610v5)
      c1610v3 = v60
      c1610v3()
    end
    do return end
  end
  YesButton = v71
  v71 = function(c1611v0)
    local c1611v1, c1611v2, c1611v3, c1611v4, c1611v5, c1611v7, c1611v8
    c1611v1 = IsNull
    c1611v1 = c1611v1(c1611v0)
    if not c1611v1 then
      c1611v1 = mMovie
      c1611v3 = "<CHECKMARK>"
      c1611v4 = true
      c1611v1 = c1611v1:GetLocalized(c1611v3, c1611v4)
      c1611v2 = mMovie
      c1611v4 = "<CHECKMARK_OUTLINE>"
      c1611v5 = true
      c1611v2 = c1611v2:GetLocalized(c1611v4, c1611v5)
      c1611v3 = c1611v0.Parent
      c1611v4 = false
      c1611v3.mValue = c1611v4
      c1611v7 = " "
      c1611v8 = c1611v0.mBaseLabel
      c1611v5 = c1611v1 .. c1611v7 .. c1611v8
      c1611v0:SetText(c1611v5)
      c1611v3 = c1611v0.Parent
      c1611v3 = c1611v3.YesBtn
      c1611v7 = " "
      c1611v8 = c1611v0.Parent
      c1611v8 = c1611v8.YesBtn
      c1611v8 = c1611v8.mBaseLabel
      c1611v5 = c1611v2 .. c1611v7 .. c1611v8
      c1611v3:SetText(c1611v5)
      c1611v3 = v60
      c1611v3()
    end
    do return end
  end
  NoButton = v71
  v71 = function(c1612v0)
    local c1612v1, c1612v2, c1612v3, c1612v4, c1612v5, c1612v6, c1612v7, c1612v8
    c1612v1 = IsNull
    c1612v1 = c1612v1(c1612v0)
    if not c1612v1 then
      c1612v1 = mMovie
      c1612v3 = "<CHECKMARK>"
      c1612v4 = true
      c1612v1 = c1612v1:GetLocalized(c1612v3, c1612v4)
      c1612v2 = mMovie
      c1612v4 = "<CHECKMARK_OUTLINE>"
      c1612v5 = true
      c1612v2 = c1612v2:GetLocalized(c1612v4, c1612v5)
      c1612v3 = c1612v0.Parent
      c1612v3 = c1612v3.mValue
      if not c1612v3 then
        c1612v3 = c1612v0.Parent
        c1612v4 = true
        c1612v3.mValue = c1612v4
        c1612v7 = c1612v0.mBaseLabel
        c1612v5 = c1612v1 .. c1612v7
        c1612v0:SetText(c1612v5)
        c1612v3 = _T
        c1612v5 = _T.PrivacyCounter
        c1612v4 = c1612v5 + 1
        c1612v3.PrivacyCounter = c1612v4
      else
        c1612v3 = c1612v0.Parent
        c1612v4 = false
        c1612v3.mValue = c1612v4
        c1612v7 = c1612v0.mBaseLabel
        c1612v5 = c1612v2 .. c1612v7
        c1612v0:SetText(c1612v5)
        c1612v3 = _T
        c1612v5 = _T.PrivacyCounter
        c1612v4 = c1612v5 - 1
        c1612v3.PrivacyCounter = c1612v4
      end
      c1612v3 = _T.PrivacyCounter
      c1612v4 = _T.SettingsAmount
      if c1612v4 <= c1612v3 then
        c1612v3 = SetConfirmButtonActive
        c1612v4 = "true"
        c1612v3(c1612v4)
        c1612v3 = SetConfirmButtonVisibleWhenInactive
        c1612v4 = "false"
        c1612v3(c1612v4)
      else
        c1612v3 = SetConfirmButtonVisibleWhenInactive
        c1612v4 = "true"
        c1612v3(c1612v4)
        c1612v3 = SetConfirmButtonActiveOverride
        c1612v4 = "false"
        c1612v3(c1612v4)
      end
      c1612v8 = _T.PrivacyCounter
      c1612v7 = tostring
      c1612v4 = c1612v7(c1612v8)
      c1612v5 = "/"
      c1612v6 = _T.SettingsAmount
      c1612v3 = c1612v4 .. c1612v5 .. c1612v6
      c1612v4 = mMovie
      c1612v6 = "Container.CounterElement.Label"
      c1612v7 = 36
      c1612v4:SetStringVariable(c1612v6, c1612v7, c1612v3)
      c1612v4 = v60
      c1612v4()
    end
    do return end
  end
  CheckmarkButton = v71
  v71 = function(c1613v0)
    local c1613v1, c1613v2, c1613v3, c1613v4, c1613v5, c1613v6, c1613v7, c1613v8, c1613v9, c1613v10, c1613v11, c1613v12, c1613v13, c1613v14
    c1613v1 = tonumber
    c1613v0 = c1613v1(c1613v0)
    c1613v1 = mMovie
    c1613v3 = "_root"
    c1613v4 = 0
    c1613v1 = c1613v1:GetNumberVariable(c1613v3, c1613v4)
    c1613v2 = mMovie
    c1613v4 = "_root"
    c1613v5 = 1
    c1613v2 = c1613v2:GetNumberVariable(c1613v4, c1613v5)
    c1613v3 = mMovie
    c1613v5 = "_root"
    c1613v6 = 14
    c1613v3 = c1613v3:GetNumberVariable(c1613v5, c1613v6)
    c1613v4 = mMovie
    c1613v6 = "_root"
    c1613v7 = 15
    c1613v4 = c1613v4:GetNumberVariable(c1613v6, c1613v7)
    c1613v5 = mMovie
    c1613v7 = "_root"
    c1613v8 = 5
    c1613v5:SetNumberVariable(c1613v7, c1613v8, c1613v0)
    c1613v5 = mMovie
    c1613v7 = "_root"
    c1613v8 = 6
    c1613v5:SetNumberVariable(c1613v7, c1613v8, c1613v0)
    c1613v5 = mMovie
    c1613v7 = "_root"
    c1613v8 = 0
    c1613v13 = c1613v0 / 100
    c1613v12 = c1613v3 * c1613v13
    c1613v11 = c1613v12 - c1613v3
    c1613v10 = c1613v11 / 2
    c1613v9 = c1613v1 - c1613v10
    c1613v5:SetNumberVariable(c1613v7, c1613v8, c1613v9)
    c1613v5 = mMovie
    c1613v7 = "_root"
    c1613v8 = 1
    c1613v14 = c1613v0 / 100
    c1613v13 = c1613v4 * c1613v14
    c1613v12 = c1613v13 - c1613v4
    c1613v11 = c1613v12 / 2
    c1613v10 = c1613v2 - c1613v11
    c1613v9 = c1613v10 - 30
    c1613v5:SetNumberVariable(c1613v7, c1613v8, c1613v9)
    do return end
  end
  SetScale = v71
  v71 = function(c1614v0)
    local c1614v1, c1614v2
    c1614v1 = v1
    c1614v1 = c1614v1.PlaySound
    c1614v2 = _G
    c1614v2 = c1614v2.UISound_Error
    c1614v1(c1614v2)
    do return end
  end
  InputBoxTextLimited = v71
  v71 = function(c1615v0)
    local c1615v1
    if c1615v0 ~= "true" then
      c1615v1 = false
    else
      c1615v1 = true
    end
    v44 = c1615v1
    do return end
  end
  CenterTitles = v71
  v71 = function()
    local c1616v0
    c1616v0 = true
    do return c1616v0 end
  end
  SupportsThemes = v71
  v71 = function()
    local c1617v0, c1617v1
    local p7 = 0
    if p7 == 0 then
      c1617v0 = Engine.IsMobile
      c1617v0 = c1617v0()
      if not c1617v0 then
        p7 = 6
      else
        p7 = 1
      end
    end
    if p7 == 1 then
      c1617v0 = v50
      c1617v1 = -4
      c1617v0.ConfirmY = c1617v1
      c1617v0 = v50
      c1617v1 = 20
      c1617v0.ConfirmX = c1617v1
      c1617v0 = v50
      c1617v1 = -7
      c1617v0.CheckboxY = c1617v1
      c1617v1 = _T.SettingsAmount
      c1617v0 = IsNull
      c1617v0 = c1617v0(c1617v1)
      if c1617v0 then
        p7 = 4
      else
        p7 = 2
      end
    end
    if p7 == 2 then
      c1617v0 = _T.SettingsAmount
      c1617v1 = 2
      if c1617v0 <= c1617v1 then
        p7 = 4
      else
        p7 = 3
      end
    end
    if p7 == 3 then
      c1617v0 = v50
      c1617v1 = -150
      c1617v0.ContainerYPos = c1617v1
      c1617v0 = v50
      c1617v1 = -85
      c1617v0.ContainerXPos = c1617v1
      p7 = 5
    end
    if p7 == 4 then
      c1617v0 = v50
      c1617v1 = -80
      c1617v0.ContainerYPos = c1617v1
      c1617v0 = v50
      c1617v1 = -85
      c1617v0.ContainerXPos = c1617v1
      p7 = 5
    end
    if p7 == 5 then
      c1617v0 = v50
      c1617v1 = -3
      c1617v0.ExtraXOffset = c1617v1
      p7 = 6
    end
    if p7 == 6 then
      do return end
    end
  end
  SetIOSPrivacyNoticeLayout = v71
  v71 = function(c1618v0)
    local c1618v1, c1618v2
    c1618v1 = Engine.IsMobile
    c1618v1 = c1618v1()
    if c1618v1 then
      c1618v1 = v50
      c1618v2 = -4
      c1618v1.ConfirmY = c1618v2
      c1618v1 = v50
      c1618v2 = -5
      c1618v1.ConfirmX = c1618v2
      c1618v1 = v50
      c1618v2 = -60
      c1618v1.ContainerYPos = c1618v2
      c1618v1 = v50
      c1618v2 = -130
      c1618v1.ContainerXPos = c1618v2
      c1618v1 = v50
      c1618v2 = 9
      c1618v1.ExtraXOffset = c1618v2
      c1618v1 = true
      v51 = c1618v1
    end
    do return end
  end
  SetIOSMarketingSignUpLayout = v71
  v71 = function()
    local c1619v0, c1619v1, c1619v2, c1619v3, c1619v4, c1619v5, c1619v6, c1619v7
    local p7 = 0
    if p7 == 0 then
      c1619v0 = Engine.IsMobile
      c1619v0 = c1619v0()
      if not c1619v0 then
        p7 = 6
      else
        p7 = 1
      end
    end
    if p7 == 1 then
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.SearchBox.duplicateMovieClip"
      c1619v3 = "CounterElement"
      c1619v4 = 1000
      c1619v0(c1619v1, c1619v2, c1619v3, c1619v4)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.Blurer.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.Backer.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.Underline2.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.Underline.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.HighlightMask.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.Highlight.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.Btn.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = FlashMethod
      c1619v1 = mMovie
      c1619v2 = "Container.CounterElement.BtnAlt.removeMovieClip"
      c1619v0(c1619v1, c1619v2)
      c1619v0 = mMovie
      c1619v2 = "Container.CounterElement.Hint"
      c1619v3 = 13
      c1619v4 = false
      c1619v0:Name__d9713943(c1619v2, c1619v3, c1619v4)
      c1619v0 = mMovie
      c1619v2 = "Container.CounterElement.Callout"
      c1619v3 = 13
      c1619v4 = false
      c1619v0:Name__d9713943(c1619v2, c1619v3, c1619v4)
      c1619v0 = mMovie
      c1619v2 = "Container.CounterElement.ClearSearchLabel"
      c1619v3 = 13
      c1619v4 = false
      c1619v0:Name__d9713943(c1619v2, c1619v3, c1619v4)
      c1619v0 = mMovie
      c1619v2 = "Container.ButtonContainer"
      c1619v3 = 0
      c1619v0 = c1619v0:GetNumberVariable(c1619v2, c1619v3)
      c1619v1 = mMovie
      c1619v3 = "Container.ButtonContainer"
      c1619v4 = 1
      c1619v1 = c1619v1:GetNumberVariable(c1619v3, c1619v4)
      c1619v3 = _T.SettingsAmount
      c1619v2 = IsNull
      c1619v2 = c1619v2(c1619v3)
      if c1619v2 then
        p7 = 4
      else
        p7 = 2
      end
    end
    if p7 == 2 then
      c1619v2 = _T.SettingsAmount
      c1619v3 = 2
      if c1619v2 <= c1619v3 then
        p7 = 4
      else
        p7 = 3
      end
    end
    if p7 == 3 then
      c1619v2 = mMovie
      c1619v4 = "Container.CounterElement"
      c1619v5 = 0
      c1619v6 = c1619v0 + 240
      c1619v2:SetNumberVariable(c1619v4, c1619v5, c1619v6)
      c1619v2 = mMovie
      c1619v4 = "Container.CounterElement"
      c1619v5 = 1
      c1619v6 = c1619v1 + 250
      c1619v2:SetNumberVariable(c1619v4, c1619v5, c1619v6)
      p7 = 5
    end
    if p7 == 4 then
      c1619v2 = mMovie
      c1619v4 = "Container.CounterElement"
      c1619v5 = 0
      c1619v6 = c1619v0 + 240
      c1619v2:SetNumberVariable(c1619v4, c1619v5, c1619v6)
      c1619v2 = mMovie
      c1619v4 = "Container.CounterElement"
      c1619v5 = 1
      c1619v2:SetNumberVariable(c1619v4, c1619v5, c1619v1)
      p7 = 5
    end
    if p7 == 5 then
      c1619v2 = mMovie
      c1619v4 = "Container.CounterElement.Label"
      c1619v5 = 44
      c1619v6 = v27
      c1619v6 = c1619v6.FloatingContent
      c1619v2:SetNumberVariable(c1619v4, c1619v5, c1619v6)
      c1619v7 = _T.PrivacyCounter
      c1619v6 = tostring
      c1619v3 = c1619v6(c1619v7)
      c1619v4 = "/"
      c1619v5 = _T.SettingsAmount
      c1619v2 = c1619v3 .. c1619v4 .. c1619v5
      c1619v3 = mMovie
      c1619v5 = "Container.CounterElement.Label"
      c1619v6 = 36
      c1619v3:SetStringVariable(c1619v5, c1619v6, c1619v2)
      c1619v3 = mMovie
      c1619v5 = "Container.CounterElement"
      c1619v6 = 13
      c1619v7 = true
      c1619v3:Name__d9713943(c1619v5, c1619v6, c1619v7)
      c1619v3 = v59
      c1619v3()
      p7 = 6
    end
    if p7 == 6 then
      do return end
    end
  end
  SetCounterElement = v71
  v71 = function(c1620v0)
    local c1620v1, c1620v3, c1620v4, c1620v5
    c1620v1 = mMovie
    c1620v3 = "_root"
    c1620v4 = 13
    if c1620v0 ~= "true" then
      c1620v5 = false
    else
      c1620v5 = true
    end
    c1620v1:Name__d9713943(c1620v3, c1620v4, c1620v5)
    do return end
  end
  ShowHideMenu = v71
  v71 = function(c1621v0)
    local c1621v1, c1621v2, c1621v3
    c1621v2 = v35
    c1621v1 = IsNull
    c1621v1 = c1621v1(c1621v2)
    if c1621v1 then
      do return end
    end
    c1621v1 = v35
    if c1621v0 ~= "true" then
      c1621v3 = false
    else
      c1621v3 = true
    end
    c1621v1:SetVisible(c1621v3)
    do return end
  end
  ShowHideSearchBox = v71
  do return end
