  local v0, v1, v2, v3, v4, v5, v6, v7, v8, v9
  v2 = require
  v3 = "Lotus.Interface.Components.ThemedButton"
  v2 = v2(v3)
  v3 = require
  v4 = "EE.Interface.Utilities"
  v3 = v3(v4)
  v4 = require
  v5 = "Lotus.Interface.UIUtilities"
  v4 = v4(v5)
  v1 = nil
  v5 = function()
    local c8v0, c8v1, c8v2, c8v3, c8v4, c8v5
    c8v0 = require
    c8v1 = "EE.Interface.Components.List"
    c8v0 = c8v0(c8v1)
    c8v1 = c8v0.CreateList
    c8v2 = mMovie
    c8v3 = "ContextList.Button"
    c8v1 = c8v1(c8v2, c8v3)
    v1 = c8v1
    c8v1 = v1
    c8v2 = 32
    c8v1.mForcedVerticalSeparation = c8v2
    c8v1 = v1
    c8v2 = 0
    c8v1.mForcedHorizontalSeparation = c8v2
    c8v1 = v1
    c8v2 = 100
    c8v1.mElementWidth = c8v2
    c8v1 = v1
    c8v3 = "ContextItemPressed"
    c8v4 = "ContextItemFocused"
    c8v5 = "ContextItemUnfocused"
    c8v1:SetCallbacks(c8v3, c8v4, c8v5)
    c8v1 = v1
    c8v2 = function(c3v0)
      local c3v1, c3v2, c3v3, c3v4, c3v5, c3v6, c3v7, c3v8
      c3v1 = c3v0.mButton
      c3v2 = IsNull
      c3v2 = c3v2(c3v1)
      if c3v2 then
        c3v2 = v2
        c3v2 = c3v2.Create
        c3v3 = mMovie
        c3v4 = c3v0.mClipName
        c3v5 = nil
        c3v6 = nil
        c3v7 = c3v0.CallOut
        c3v1 = c3v2(c3v3, c3v4, c3v5, c3v6, c3v7)
        c3v4 = c3v0.Id
        c3v1:SetId(c3v4)
        c3v2 = function(c1v0)
          local c1v1, c1v2
          c1v1 = v1
          c1v2 = c1v0.mId
          c1v1:SelectElementById(c1v2)
          do return end
        end
        c3v1.mOnPressedCallback = c3v2
        c3v2 = c3v1.SetFocus
        c3v1.ContextListSetFocus = c3v2
        c3v2 = function(c2v0, c2v1)
          local c2v2, c2v3, c2v4, c2v5, c2v6, c2v7, c2v8, c2v9, c2v10, c2v11
          local __renovice_state_0 = 0
          c2v0:ContextListSetFocus(c2v1)
          if not c2v1 then
            __renovice_state_0 = 7
          else
            __renovice_state_0 = 1
          end
          if __renovice_state_0 == 1 then
            c2v3 = c2v0.Tooltip
            c2v2 = IsNull
            c2v2 = c2v2(c2v3)
            if c2v2 then
              __renovice_state_0 = 8
            else
              __renovice_state_0 = 2
            end
          end
          if __renovice_state_0 == 2 then
            c2v3 = c2v0.ShowTooltipCheck
            c2v2 = IsNull
            c2v2 = c2v2(c2v3)
            if c2v2 then
              __renovice_state_0 = 4
            else
              __renovice_state_0 = 3
            end
          end
          if __renovice_state_0 == 3 then
            c2v2 = c2v0.ShowTooltipCheck
            c2v2 = c2v2()
            if not c2v2 then
              __renovice_state_0 = 8
            else
              __renovice_state_0 = 4
            end
          end
          if __renovice_state_0 == 4 then
            c2v2 = c2v0.Tooltip
            c2v3 = mMovie
            c2v5 = c2v0.mClipName
            c2v6 = 2
            c2v3 = c2v3:GetNumberVariable(c2v5, c2v6)
            c2v4 = mMovie
            c2v6 = c2v0.mClipName
            c2v7 = 3
            c2v4 = c2v4:GetNumberVariable(c2v6, c2v7)
            if (c2v3 == nil or c2v4 == nil) then
              __renovice_state_0 = 8
            else
              __renovice_state_0 = 6
            end
          end
          if __renovice_state_0 == 6 then
            c2v5 = v4
            c2v5 = c2v5.SetItemInfoPopupRect
            c2v6 = mMovie
            c2v10 = c2v0.mWidth
            c2v9 = c2v10 / 2
            c2v8 = c2v3 + c2v9
            c2v11 = c2v0.mHeight
            c2v10 = c2v11 / 2
            c2v9 = c2v4 + c2v10
            c2v10 = c2v0.mWidth
            c2v11 = c2v0.mHeight
            c2v5(c2v6, c2v2, c2v8, c2v9, c2v10, c2v11)
            _T.InfoPopup_Data = c2v2
            c2v5 = _T
            c2v6 = v1
            c2v5.InfoPopup_Grid = c2v6
            do return end
          elseif __renovice_state_0 == 7 then
            c2v2 = _T
            c2v3 = nil
            c2v2.InfoPopup_Data = c2v3
            __renovice_state_0 = 8
          end
          if __renovice_state_0 == 8 then
            do return end
          end
          do return end
        end
        c3v1.SetFocus = c3v2
        c3v0.mButton = c3v1
      end
      c3v2 = false
      c3v3 = c3v0.IsLockedCheck
      if c3v3 ~= nil then
        c3v2 = c3v0.IsLockedCheck
        c3v2 = c3v2()
      end
      c3v0.Locked = c3v2
      c3v3 = v3
      c3v3 = c3v3.Ternary
      c3v5 = mMovie
      c3v7 = "<LOCKED>"
      c3v8 = true
      c3v5 = c3v5:GetLocalized(c3v7, c3v8)
      c3v6 = ""
      c3v3 = c3v3(c3v2, c3v5, c3v6)
      c3v1.mLabelPrefix = c3v3
      c3v4 = c3v0.FormatPrefix
      c3v3 = IsNull
      c3v3 = c3v3(c3v4)
      if not c3v3 then
        c3v3 = mMovie
        c3v5 = c3v0.FormatPrefix
        c3v6 = true
        c3v3 = c3v3:GetLocalized(c3v5, c3v6)
        c3v1.mFormatPrefix = c3v3
      end
      c3v3 = true
      c3v1.mForceBacker = c3v3
      c3v3 = c3v0.Tooltip
      c3v1.Tooltip = c3v3
      c3v3 = c3v0.ShowTooltipCheck
      c3v1.ShowTooltipCheck = c3v3
      c3v5 = c3v0.Name
      c3v1:SetText(c3v5)
      c3v5 = "left"
      c3v1:SetTextAlignment(c3v5)
      c3v1:OnGamepadTransition()
      do return end
    end
    c8v1.mElementDrawCallback = c8v2
    c8v1 = v1
    c8v2 = function(c4v0)
      local c4v1
      c4v1 = c4v0.SelectedCallback
      if c4v1 ~= nil then
        c4v1 = c4v0.Locked
        if not c4v1 then
          c4v1 = c4v0.SelectedCallback
          c4v1()
        end
      end
      do return end
    end
    c8v1.mOnSelectedCallback = c8v2
    c8v1 = v1
    c8v2 = function(c7v0)
      local c7v1, c7v2
      c7v1 = 100
      c7v2 = function(c5v0)
        local c5v1, c5v2
        c5v2 = c5v0.mButton
        c5v1 = IsNull
        c5v1 = c5v1(c5v2)
        if not c5v1 then
          c5v1 = c5v0.mButton
          c5v1 = c5v1.mWidth
          c5v2 = c7v1
          if c5v2 < c5v1 then
            c5v1 = c5v0.mButton
            c5v1 = c5v1.mWidth
            c7v1 = c5v1
          end
        end
        do return end
      end
      c7v0:RunForAllElements(c7v2)
      c7v2 = function(c6v0)
        local c6v1, c6v2, c6v3
        c6v2 = c6v0.mButton
        c6v1 = IsNull
        c6v1 = c6v1(c6v2)
        if not c6v1 then
          c6v1 = c6v0.mButton
          c6v3 = c7v1
          c6v1:SetWidth(c6v3)
        end
        do return end
      end
      c7v0:RunForAllElements(c7v2)
      do return end
    end
    c8v1.Resize = c8v2
    c8v1 = v1
    c8v3 = true
    c8v4 = true
    c8v1:RemoveElements(c8v3, c8v4)
    c8v1 = v1
    c8v3 = nil
    c8v4 = nil
    c8v5 = true
    c8v1:Redraw(c8v3, c8v4, c8v5)
    do return end
  end
  v0 = nil
  v6 = function()
    local c9v0, c9v1, c9v2, c9v3, c9v4, c9v5, c9v6, c9v7, c9v8, c9v9
    c9v1 = v0
    c9v0 = IsNull
    c9v0 = c9v0(c9v1)
    if not c9v0 then
      c9v0 = v0
      c9v0 = c9v0.Rect
      c9v1 = v3
      c9v1 = c9v1.TransformViewportToPixelCoordinates
      c9v2 = mMovie
      c9v3 = { x = nil, y = nil }
      c9v4 = c9v0.X
      c9v3.x = c9v4
      c9v4 = c9v0.Y
      c9v3.y = c9v4
      c9v1 = c9v1(c9v2, c9v3)
      c9v2 = c9v0.W
      c9v3 = c9v0.H
      c9v4 = v0
      c9v4 = c9v4.TopLeftAligned
      if not c9v4 then
        c9v2 = c9v2 / 2
        c9v3 = c9v3 / 2
      end
      c9v6 = c9v1.x
      c9v5 = c9v6 + c9v2
      c9v4 = c9v5 + 10
      c9v5 = c9v1.y
      c9v6 = v0
      c9v6 = c9v6.CenterAlign
      if c9v6 then
        c9v5 = c9v5 + c9v3
      else
        c9v6 = v0
        c9v6 = c9v6.TopLeftAligned
        if not c9v6 then
          c9v5 = c9v5 - c9v3
        end
      end
      c9v6 = mMovie
      c9v7 = "ContextList"
      c9v8 = 0
      c9v9 = math.ceil
      c9v9 = c9v9(c9v4)
      c9v6:SetNumberVariable(c9v7, c9v8, c9v9)
      c9v6 = mMovie
      c9v7 = "ContextList"
      c9v8 = 1
      c9v9 = math.ceil
      c9v9 = c9v9(c9v5)
      c9v6:SetNumberVariable(c9v7, c9v8, c9v9)
    end
    do return end
  end
  v7 = function()
    local c10v0, c10v1, c10v2
    c10v0 = 1
    c10v1 = nil
    while true do
      c10v2 = getfenv
      c10v1 = c10v2(c10v0)
      c10v0 = c10v0 + 1
      c10v2 = c10v1.mMovie
      if c10v2 then break end
    end
    do return c10v1 end
  end
  v8 = function()
    local c11v0, c11v1, c11v2, c11v3, c11v4, c11v5, c11v6, c11v7, c11v8, c11v9, c11v10, c11v11, c11v12
    c11v0 = v7
    c11v0 = c11v0()
    c11v1 = ipairs
    c11v2 = v0
    c11v2 = c11v2.Elements
    c11v1, c11v2, c11v3 = c11v1(c11v2)
    for __renovice_for_0_0, __renovice_for_0_1 in c11v1, c11v2, c11v3 do
      repeat
        c11v7 = __renovice_for_0_1.ShouldRemove
        c11v6 = IsNull
        c11v6 = c11v6(c11v7)
        if not c11v6 then
          c11v6 = __renovice_for_0_1.ShouldRemove
          c11v6 = c11v6()
          if c11v6 then break end
        end
        c11v6 = __renovice_for_0_1.CallOut
        if c11v6 ~= nil then
          c11v7 = "onKeyUp_"
          c11v9 = __renovice_for_0_1.CallOut
          c11v10 = 2
          c11v11 = -2
          c11v8 = string.sub
          c11v8 = c11v8(c11v9, c11v10, c11v11)
          c11v6 = c11v7 .. c11v8
          c11v8 = "onKeyDown_"
          c11v10 = __renovice_for_0_1.CallOut
          c11v11 = 2
          c11v12 = -2
          c11v9 = string.sub
          c11v9 = c11v9(c11v10, c11v11, c11v12)
          c11v7 = c11v8 .. c11v9
          c11v8 = nil
          c11v0[c11v6] = c11v8
          c11v8 = nil
          c11v0[c11v7] = c11v8
        end
        c11v6 = v1
        c11v9 = true
        c11v6:AddElement(__renovice_for_0_1, c11v9)
      until true
    end
    c11v1 = v1
    c11v3 = nil
    c11v4 = nil
    c11v5 = true
    c11v1:Redraw(c11v3, c11v4, c11v5)
    c11v1 = v1
    c11v1:Resize()
    do return end
  end
  v9 = function()
    local c12v0, c12v1
    c12v0 = mMovie
    c12v1 = true
    c12v0:SetIgnoreInput(c12v1)
    c12v0 = mMovie
    c12v1 = false
    c12v0:SetForcedInput(c12v1)
    c12v0 = mMovie
    c12v1 = true
    c12v0:Name__f7d22364(c12v1)
    c12v0 = v5
    c12v0()
    do return end
  end
  Initialize = v9
  v9 = function()
    local c14v0, c14v1, c14v2, c14v3, c14v4, c14v5, c14v6
    local __renovice_state_0 = 0
    c14v1 = mMovie
    c14v0 = IsNull
    c14v0 = c14v0(c14v1)
    if not c14v0 then
      __renovice_state_0 = 2
    else
      __renovice_state_0 = 1
    end
    if __renovice_state_0 == 1 then
      do return end
    elseif __renovice_state_0 == 2 then
      c14v0 = RealDeltaTime
      c14v0 = c14v0()
      c14v1 = mMovie
      c14v1:Name__b7f5bbc5(c14v0)
      c14v2 = v1
      c14v1 = IsNull
      c14v1 = c14v1(c14v2)
      if c14v1 then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 3
      end
    end
    if __renovice_state_0 == 3 then
      c14v1 = v1
      c14v1:Update(c14v0)
      __renovice_state_0 = 4
    end
    if __renovice_state_0 == 4 then
      c14v1 = _T.ContextMenu_Data
      c14v2 = v0
      if (c14v2 ~= nil or c14v1 ~= nil) then
        __renovice_state_0 = 7
      else
        __renovice_state_0 = 6
      end
    end
    if __renovice_state_0 == 6 then
      do return end
    elseif __renovice_state_0 == 7 then
      c14v2 = v0
      if c14v2 ~= c14v1 then
        __renovice_state_0 = 10
      else
        __renovice_state_0 = 8
      end
    end
    if __renovice_state_0 == 8 then
      if c14v1 == nil then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 9
      end
    end
    if __renovice_state_0 == 9 then
      c14v2 = c14v1.Refresh
      if not c14v2 then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 10
      end
    end
    if __renovice_state_0 == 10 then
      v0 = c14v1
      c14v3 = v0
      if c14v3 ~= nil then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 11
      end
    end
    if __renovice_state_0 == 11 then
      c14v2 = false
      __renovice_state_0 = 13
    end
    if __renovice_state_0 == 12 then
      c14v2 = true
      __renovice_state_0 = 13
    end
    if __renovice_state_0 == 13 then
      c14v3 = mMovie
      c14v3:SetVisible(c14v2)
      c14v3 = mMovie
      c14v5 = not c14v2
      c14v3:SetIgnoreInput(c14v5)
      c14v3 = mMovie
      c14v3:SetForcedInput(c14v2)
      c14v4 = v1
      c14v3 = IsNull
      c14v3 = c14v3(c14v4)
      if c14v3 then
        __renovice_state_0 = 15
      else
        __renovice_state_0 = 14
      end
    end
    if __renovice_state_0 == 14 then
      c14v3 = v1
      c14v5 = function(c13v0)
        local c13v1
        c13v1 = nil
        c13v0.mButton = c13v1
        do return end
      end
      c14v3:RunForAllElements(c14v5)
      c14v3 = v1
      c14v5 = true
      c14v6 = true
      c14v3:RemoveElements(c14v5, c14v6)
      __renovice_state_0 = 15
    end
    if __renovice_state_0 == 15 then
      c14v3 = v0
      if c14v3 == nil then
        __renovice_state_0 = 19
      else
        __renovice_state_0 = 16
      end
    end
    if __renovice_state_0 == 16 then
      c14v3 = v0
      c14v3 = c14v3.Refresh
      if c14v3 == nil then
        __renovice_state_0 = 18
      else
        __renovice_state_0 = 17
      end
    end
    if __renovice_state_0 == 17 then
      c14v3 = v0
      c14v4 = nil
      c14v3.Refresh = c14v4
      __renovice_state_0 = 18
    end
    if __renovice_state_0 == 18 then
      c14v3 = v6
      c14v3()
      c14v3 = v8
      c14v3()
      __renovice_state_0 = 19
    end
    if __renovice_state_0 == 19 then
      do return end
    end
    do return end
  end
  Update = v9
  v9 = function()
    local c15v0
    c15v0 = true
    do return c15v0 end
  end
  SupportsThemes = v9
  v9 = function()
    do return end
  end
  Shutdown = v9
  v9 = function(c17v0)
    local c17v1, c17v2, c17v3
    c17v2 = v1
    c17v1 = IsNull
    c17v1 = c17v1(c17v2)
    if not c17v1 then
      c17v1 = v1
      c17v3 = tonumber
      c17v3 = c17v3(c17v0)
      c17v1:FocusElementById(c17v3)
    end
    do return end
  end
  ContextItemFocused = v9
  v9 = function(c18v0)
    local c18v1, c18v2, c18v3
    c18v2 = v1
    c18v1 = IsNull
    c18v1 = c18v1(c18v2)
    if not c18v1 then
      c18v1 = v1
      c18v3 = tonumber
      c18v3 = c18v3(c18v0)
      c18v1:UnfocusElementById(c18v3)
    end
    do return end
  end
  ContextItemUnfocused = v9
  do return end
