-- RENOVICE_NAME_HASH_SEED: 768e5ed0
-- RENOVICE_HASH_FIELD: CreateListContainer
-- RENOVICE_HASH_FIELD: CreateScrollBar
-- RENOVICE_IMPORT_CLASS: package.seeall=SS
  local v0, v1, v2
  v0 = module
  v1 = ...
  v2 = package.seeall
  v0(v1, v2)
  v0 = function(c87v0, c87v1, c87v2)
    local c87v3, c87v4, c87v5, c87v6, c87v7, c87v8, c87v9
    c87v6 = 12
    c87v7 = 0
    c87v0:SetNumberVariable(c87v1, c87v6, c87v7)
    c87v3 = {}
    c87v3.mMovie = c87v0
    c87v5 = {}
    c87v3.mElements = c87v5
    c87v5 = {}
    c87v3.mClips = c87v5
    c87v5 = true
    c87v3.mEnabled = c87v5
    c87v3.mClipName = c87v1
    c87v5 = nil
    c87v3.mCurrentElementIndex = c87v5
    c87v5 = nil
    c87v3.mElementDrawCallback = c87v5
    c87v5 = nil
    c87v3.mOnFocusedCallback = c87v5
    c87v5 = nil
    c87v3.mOnUnfocusedCallback = c87v5
    c87v5 = nil
    c87v3.mOnSelectedCallback = c87v5
    c87v5 = nil
    c87v3.mOnRemovedCallback = c87v5
    c87v5 = nil
    c87v3.mOnPressedCallback = c87v5
    c87v5 = nil
    c87v3.mForcedVerticalSeparation = c87v5
    c87v5 = nil
    c87v3.mForcedHorizontalSeparation = c87v5
    c87v5 = nil
    c87v3.mPressElementCallback = c87v5
    c87v5 = nil
    c87v3.mSelectElementCallback = c87v5
    c87v5 = nil
    c87v3.mRollOverElementCallback = c87v5
    c87v5 = nil
    c87v3.mRollOutElementCallback = c87v5
    c87v5 = nil
    c87v3.mClipCreatedCallback = c87v5
    c87v5 = nil
    c87v3.mOnDraggedCallback = c87v5
    c87v5 = nil
    c87v3.mOnDragFocusedCallback = c87v5
    c87v5 = nil
    c87v3.mOnDragUnfocusedCallback = c87v5
    c87v5 = nil
    c87v3.mMaxElementsToDrawPerFrame = c87v5
    c87v5 = nil
    c87v3.mRedrawElementIndex = c87v5
    c87v5 = { Callback = nil, ForceUpdate = nil, InstantDraw = nil }
    c87v3.mRedrawCachedParams = c87v5
    c87v5 = require
    c87v6 = "EE.Interface.Utilities"
    c87v5 = c87v5(c87v6)
    c87v3.UTIL = c87v5
    c87v5 = false
    c87v3.mHasDrawn = c87v5
    c87v5 = 0
    c87v3.mTopId = c87v5
    c87v5 = 0
    c87v3.mTopClipIndexUsed = c87v5
    c87v5 = 0
    c87v3.mLastPressTime = c87v5
    c87v5 = 1000
    c87v3.mInitialDepth = c87v5
    c87v5 = -1
    c87v3.mDepthDirection = c87v5
    c87v5 = 0.2
    c87v3.mElementTransitionTime = c87v5
    c87v5 = 0
    c87v3.mElementDelayTime = c87v5
    c87v5 = true
    c87v3.mWrapAroundNavigation = c87v5
    c87v8 = 0
    c87v5 = c87v0:GetNumberVariable(c87v1, c87v8)
    c87v3.mInitialX = c87v5
    c87v8 = 1
    c87v5 = c87v0:GetNumberVariable(c87v1, c87v8)
    c87v3.mInitialY = c87v5
    c87v3.mVisibleElements = c87v2
    c87v5 = nil
    c87v3.mScroll = c87v5
    c87v5 = nil
    c87v3.mScrollBarClipName = c87v5
    c87v5 = nil
    c87v3.mRedrawFromScrollBar = c87v5
    c87v5 = nil
    c87v3.mListContainer = c87v5
    c87v5 = false
    c87v3.mSmoothScroll = c87v5
    c87v5 = false
    c87v3.mScrollAlwaysVisible = c87v5
    c87v9 = ".Btn"
    c87v7 = c87v1 .. c87v9
    c87v8 = 15
    c87v5 = c87v0:GetNumberVariable(c87v7, c87v8)
    c87v3.mOriginalButtonHeight = c87v5
    c87v9 = ".Btn"
    c87v7 = c87v1 .. c87v9
    c87v8 = 14
    c87v5 = c87v0:GetNumberVariable(c87v7, c87v8)
    c87v3.mOriginalButtonWidth = c87v5
    c87v6 = "List("
    c87v8 = ")::"
    c87v5 = c87v6 .. c87v1 .. c87v8
    c87v3.mPrefix = c87v5
    c87v5 = 2
    c87v3.mEasing = c87v5
    c87v5 = 0
    c87v3.mLowerBoundBuffer = c87v5
    c87v5 = 0
    c87v3.mUpperBoundBuffer = c87v5
    c87v5 = false
    c87v3.mIgnoreFiller = c87v5
    c87v5 = {}
    c87v3.mClickDrag = c87v5
    c87v5 = {}
    c87v3.mScrollDrag = c87v5
    c87v5 = 1
    c87v3.UP = c87v5
    c87v5 = 2
    c87v3.RIGHT = c87v5
    c87v5 = 3
    c87v3.DOWN = c87v5
    c87v5 = 4
    c87v3.LEFT = c87v5
    c87v7 = 67
    c87v8 = false
    c87v4 = c87v0:Name__863e56e7(c87v1, c87v7, c87v8)
    c87v3[1] = c87v4
    c87v6 = 12
    c87v7 = 1
    c87v5 = {c87v6, c87v7}
    c87v3.mInterpolationProps = c87v5
    c87v6 = 100
    c87v7 = 0
    c87v5 = {c87v6, c87v7}
    c87v3.mInterpolationValues = c87v5
    c87v5 = true
    c87v3.mStopDragScrollingOnSelection = c87v5
    c87v5 = false
    c87v3.mAllowElementSelectionOnScrollDragEnd = c87v5
    c87v5 = 0
    c87v3.MOVE_NONE = c87v5
    c87v5 = 1
    c87v3.MOVE_VERTICAL = c87v5
    c87v5 = 2
    c87v3.MOVE_HORIZONTAL = c87v5
    c87v5 = function(c1v0)
      local c1v1, c1v2
      c1v2 = c1v0.mRedrawElementIndex
      if c1v2 == nil then
        c1v1 = false
        do return c1v1 end
      end
      c1v1 = true
      do return c1v1 end
    end
    c87v3.IsRedrawing = c87v5
    c87v5 = function(c2v0, c2v1)
      local c2v2, c2v3, c2v4
      c2v2 = print
      c2v4 = c2v0.mPrefix
      c2v3 = c2v4 .. c2v1
      c2v2(c2v3)
      do return end
    end
    c87v3.Print = c87v5
    c87v5 = function(c3v0)
      local c3v1, c3v2
      c3v2 = c3v0.mElements
      c3v1 = #c3v2
      do return c3v1 end
    end
    c87v3.GetHowManyElements = c87v5
    c87v5 = function(c4v0)
      local c4v1, c4v2, c4v3, c4v4
      c4v1 = c4v0.UTIL
      c4v1 = c4v1.Ternary
      c4v3 = c4v0.mVisibleElements
      if c4v3 ~= nil then
        c4v2 = false
      else
        c4v2 = true
      end
      c4v4 = c4v0.mElements
      c4v3 = #c4v4
      c4v4 = c4v0.mVisibleElements
      c4v1 = c4v1(c4v2, c4v3, c4v4)
      do return c4v1 end
    end
    c87v3.GetHowManyVisibleElements = c87v5
    c87v5 = function(c5v0)
      local c5v1, c5v2, c5v3
      c5v2 = c5v0.mCurrentElementIndex
      c5v1 = IsNull
      c5v1 = c5v1(c5v2)
      if not c5v1 then
        c5v2 = c5v0.mElements
        c5v3 = c5v0.mCurrentElementIndex
        c5v1 = c5v2[c5v3]
        do return c5v1 end
      end
      c5v1 = nil
      do return c5v1 end
    end
    c87v3.GetFocusedElement = c87v5
    c87v5 = function(c6v0)
      local c6v1
      c6v1 = c6v0.mCurrentElementIndex
      do return c6v1 end
    end
    c87v3.GetFocusedElementIndex = c87v5
    c87v5 = function(c7v0, c7v1)
      local c7v2, c7v3
      c7v3 = c7v0.mElements
      c7v2 = c7v3[c7v1]
      do return c7v2 end
    end
    c87v3.GetElementInIndex = c87v5
    c87v5 = function(c8v0, c8v1)
      local c8v2, c8v3, c8v4, c8v5, c8v6
      c8v4 = 1
      c8v5 = c8v0.mElements
      c8v2 = #c8v5
      c8v3 = 1
      for __renovice_for_0_0 = c8v4, c8v2, c8v3 do
        c8v6 = c8v0.mElements
        c8v5 = c8v6[__renovice_for_0_0]
        c8v5 = c8v5.Id
        if c8v5 ~= c8v1 then
          continue
        end
        do return __renovice_for_0_0 end
      end
      c8v2 = nil
      do return c8v2 end
    end
    c87v3.GetElementIndexById = c87v5
    c87v5 = function(c9v0, c9v1, c9v2, c9v3)
      local c9v4, c9v5, c9v6, c9v7
      c9v5 = c9v0.mElements
      c9v4 = c9v5[c9v1]
      c9v4 = c9v4.Id
      c9v2.Id = c9v4
      c9v4 = c9v0.mElements
      c9v4[c9v1] = c9v2
      if not c9v3 then
        c9v6 = nil
        c9v7 = true
        c9v0:Redraw(c9v6, c9v7)
      end
      do return end
    end
    c87v3.UpdateElementInIndex = c87v5
    c87v5 = function(c10v0, c10v1, c10v2, c10v3)
      local c10v4
      c10v4 = c10v0:GetElementIndexById(c10v1)
      c10v0:UpdateElementInIndex(c10v4, c10v2, c10v3)
      do return end
    end
    c87v3.UpdateElementById = c87v5
    c87v5 = function(c11v0, c11v1)
      local c11v2
      c11v2 = c11v0:GetElementInIndex(c11v0:GetElementIndexById(c11v1))
      do return c11v2 end
    end
    c87v3.GetElementById = c87v5
    c87v5 = function(c12v0, c12v1)
      c12v0.mClipName = c12v1
      c12v0:SetClipCallbacks(c12v1)
      do return end
    end
    c87v3.SetBaseClipName = c87v5
    c87v5 = function(c13v0, c13v1)
      local c13v2, c13v3
      c13v3 = c13v0.mElements
      c13v2 = c13v3[c13v1]
      c13v2 = c13v2.mClipName
      do return c13v2 end
    end
    c87v3.GetClipName = c87v5
    c87v5 = function(c14v0)
      local c14v1
      c14v1 = c14v0.mScroll
      do return c14v1 end
    end
    c87v3.GetScroll = c87v5
    c87v5 = function(c15v0, c15v1)
      local c15v2, c15v3, c15v4, c15v5, c15v6, c15v7, c15v8
      c15v2 = c15v1.mIndex
      if c15v2 == nil then
        c15v5 = c15v1.Id
        c15v2 = c15v0:GetElementIndexById(c15v5)
      end
      c15v3 = IsNull
      c15v3 = c15v3(c15v2)
      if c15v3 then
        c15v3 = c15v0.mInitialX
        do return c15v3 end
      end
      c15v4 = c15v0.mScroll
      c15v3 = IsNull
      c15v3 = c15v3(c15v4)
      if not c15v3 then
        c15v4 = c15v0.mScroll
        c15v3 = c15v2 - c15v4
        c15v2 = c15v3 + 1
      end
      c15v3 = 0
      c15v5 = c15v0.mForcedHorizontalSeparation
      c15v4 = IsNull
      c15v4 = c15v4(c15v5)
      if not c15v4 then
        c15v3 = c15v0.mForcedHorizontalSeparation
      end
      c15v4 = c15v0.UTIL
      c15v4 = c15v4.Round
      c15v6 = c15v0.mInitialX
      c15v8 = c15v2 - 1
      c15v7 = c15v3 * c15v8
      c15v5 = c15v6 + c15v7
      c15v4 = c15v4(c15v5)
      do return c15v4 end
    end
    c87v3.CalculateX = c87v5
    c87v5 = function(c16v0, c16v1)
      local c16v2, c16v3, c16v4, c16v5, c16v6, c16v7, c16v8, c16v9, c16v10
      c16v2 = c16v1.mIndex
      if c16v2 == nil then
        c16v5 = c16v1.Id
        c16v2 = c16v0:GetElementIndexById(c16v5)
      end
      c16v3 = IsNull
      c16v3 = c16v3(c16v2)
      if c16v3 then
        c16v3 = c16v0.mInitialY
        do return c16v3 end
      end
      c16v4 = c16v0.mScroll
      c16v3 = IsNull
      c16v3 = c16v3(c16v4)
      if not c16v3 then
        c16v4 = c16v0.mScroll
        c16v3 = c16v2 - c16v4
        c16v2 = c16v3 + 1
      end
      c16v3 = nil
      c16v5 = c16v0.mForcedVerticalSeparation
      c16v4 = IsNull
      c16v4 = c16v4(c16v5)
      if not c16v4 then
        c16v3 = c16v0.mForcedVerticalSeparation
      else
        c16v4 = c16v0.mMovie
        c16v6 = c16v0.mClipName
        c16v7 = 15
        c16v3 = c16v4:GetNumberVariable(c16v6, c16v7)
      end
      c16v4 = 0
      c16v5 = c16v1.listExtraY
      if c16v5 then
        c16v4 = c16v1.listExtraY
      end
      c16v6 = c16v0.UTIL
      c16v6 = c16v6.Round
      c16v8 = c16v0.mInitialY
      c16v10 = c16v2 - 1
      c16v9 = c16v3 * c16v10
      c16v7 = c16v8 + c16v9
      c16v6 = c16v6(c16v7)
      c16v5 = c16v6 + c16v4
      do return c16v5 end
    end
    c87v3.CalculateY = c87v5
    c87v5 = function(c18v0, c18v1, c18v2, c18v3, c18v4, c18v5, c18v6, c18v7)
      local c18v8
      c18v0.mSelectElementCallback = c18v1
      c18v0.mRollOverElementCallback = c18v2
      c18v0.mRollOutElementCallback = c18v3
      c18v0.mPressElementCallback = c18v4
      c18v0.mDragOverElementCallback = c18v5
      c18v0.mDragOutElementCallback = c18v6
      c18v0.mReleaseOutsideCallback = c18v7
      c18v8 = c18v0.mClipName
      c18v0:SetClipCallbacks(c18v8)
      c18v8 = function(c17v0)
        local c17v1, c17v2
        c17v1 = c18v0
        c17v2 = c17v0.mClipName
        c17v1:SetClipCallbacks(c17v2)
        do return end
      end
      c18v0:RunForAllVisibleElements(c18v8)
      do return end
    end
    c87v3.SetCallbacks = c87v5
    c87v5 = function(c19v0, c19v1)
      local c19v2, c19v3, c19v4, c19v5, c19v6, c19v7
      local __renovice_state_0 = 0
      local __renovice_local_0 = c19v0.mRollOverElementCallback
      if __renovice_local_0 ~= nil then
        __renovice_state_0 = 4
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        __renovice_local_0 = c19v0.mRollOutElementCallback
        if __renovice_local_0 ~= nil then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        __renovice_local_0 = c19v0.mSelectElementCallback
        if __renovice_local_0 ~= nil then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        __renovice_local_0 = c19v0.mPressElementCallback
        if __renovice_local_0 == nil then
          __renovice_state_0 = 13
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        __renovice_local_0 = c19v0.mMovie
        c19v5 = ".Btn"
        c19v3 = c19v1 .. c19v5
        c19v4 = c19v0.mRollOverElementCallback
        c19v5 = c19v0.mRollOutElementCallback
        c19v6 = c19v0.mSelectElementCallback
        c19v7 = c19v0.mPressElementCallback
        __renovice_local_0 = __renovice_local_0:SetCallbacks(c19v3, c19v4, c19v5, c19v6, c19v7)
        if __renovice_local_0 then
          __renovice_state_0 = 13
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c19v2 = c19v0.mPressElementCallback
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c19v2)
        if __renovice_local_0 then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        __renovice_local_0 = c19v0.mMovie
        c19v4 = "PressedCallback"
        c19v5 = c19v0.mPressElementCallback
        __renovice_local_0:SetVariable(c19v1, c19v4, c19v5)
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 7 then
        c19v2 = c19v0.mSelectElementCallback
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c19v2)
        if __renovice_local_0 then
          __renovice_state_0 = 9
        else
          __renovice_state_0 = 8
        end
      end
      if __renovice_state_0 == 8 then
        __renovice_local_0 = c19v0.mMovie
        c19v4 = "SelectCallback"
        c19v5 = c19v0.mSelectElementCallback
        __renovice_local_0:SetVariable(c19v1, c19v4, c19v5)
        __renovice_state_0 = 9
      end
      if __renovice_state_0 == 9 then
        c19v2 = c19v0.mRollOverElementCallback
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c19v2)
        if __renovice_local_0 then
          __renovice_state_0 = 11
        else
          __renovice_state_0 = 10
        end
      end
      if __renovice_state_0 == 10 then
        __renovice_local_0 = c19v0.mMovie
        c19v4 = "RollOverCallback"
        c19v5 = c19v0.mRollOverElementCallback
        __renovice_local_0:SetVariable(c19v1, c19v4, c19v5)
        __renovice_state_0 = 11
      end
      if __renovice_state_0 == 11 then
        c19v2 = c19v0.mRollOutElementCallback
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c19v2)
        if __renovice_local_0 then
          __renovice_state_0 = 13
        else
          __renovice_state_0 = 12
        end
      end
      if __renovice_state_0 == 12 then
        __renovice_local_0 = c19v0.mMovie
        c19v4 = "RollOutCallback"
        c19v5 = c19v0.mRollOutElementCallback
        __renovice_local_0:SetVariable(c19v1, c19v4, c19v5)
        __renovice_state_0 = 13
      end
      if __renovice_state_0 == 13 then
        __renovice_local_0 = c19v0.mReleaseOutsideCallback
        if __renovice_local_0 == nil then
          __renovice_state_0 = 16
        else
          __renovice_state_0 = 14
        end
      end
      if __renovice_state_0 == 14 then
        __renovice_local_0 = c19v0.mMovie
        c19v5 = ".Btn"
        c19v3 = c19v1 .. c19v5
        c19v4 = c19v0.mReleaseOutsideCallback
        __renovice_local_0 = __renovice_local_0:SetReleaseOutsideCallback(c19v3, c19v4)
        if __renovice_local_0 then
          __renovice_state_0 = 16
        else
          __renovice_state_0 = 15
        end
      end
      if __renovice_state_0 == 15 then
        __renovice_local_0 = c19v0.mMovie
        c19v4 = "ReleaseOutsideCallback"
        c19v5 = c19v0.mReleaseOutsideCallback
        __renovice_local_0:SetVariable(c19v1, c19v4, c19v5)
        __renovice_state_0 = 16
      end
      if __renovice_state_0 == 16 then
        __renovice_local_0 = c19v0.mDragOverElementCallback
        if __renovice_local_0 ~= nil then
          __renovice_state_0 = 18
        else
          __renovice_state_0 = 17
        end
      end
      if __renovice_state_0 == 17 then
        __renovice_local_0 = c19v0.mDragOutElementCallback
        if __renovice_local_0 == nil then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 18
        end
      end
      if __renovice_state_0 == 18 then
        __renovice_local_0 = c19v0.mMovie
        c19v5 = ".Btn"
        c19v3 = c19v1 .. c19v5
        c19v4 = c19v0.mDragOverElementCallback
        c19v5 = c19v0.mDragOutElementCallback
        __renovice_local_0 = __renovice_local_0:SetDragCallbacks(c19v3, c19v4, c19v5)
        if __renovice_local_0 then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 19
        end
      end
      if __renovice_state_0 == 19 then
        c19v2 = c19v0.mDragOverElementCallback
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c19v2)
        if __renovice_local_0 then
          __renovice_state_0 = 21
        else
          __renovice_state_0 = 20
        end
      end
      if __renovice_state_0 == 20 then
        __renovice_local_0 = c19v0.mMovie
        c19v4 = "DragOverCallback"
        c19v5 = c19v0.mDragOverElementCallback
        __renovice_local_0:SetVariable(c19v1, c19v4, c19v5)
        __renovice_state_0 = 21
      end
      if __renovice_state_0 == 21 then
        c19v2 = c19v0.mDragOutElementCallback
        __renovice_local_0 = IsNull
        __renovice_local_0 = __renovice_local_0(c19v2)
        if __renovice_local_0 then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 22
        end
      end
      if __renovice_state_0 == 22 then
        __renovice_local_0 = c19v0.mMovie
        c19v4 = "DragOutCallback"
        c19v5 = c19v0.mDragOutElementCallback
        __renovice_local_0:SetVariable(c19v1, c19v4, c19v5)
        __renovice_state_0 = 23
      end
      if __renovice_state_0 == 23 then
        do return end
      end
      do return end
    end
    c87v3.SetClipCallbacks = c87v5
    c87v5 = function(c20v0, c20v1, c20v2, c20v3, c20v4)
      local c20v5, c20v6, c20v7, c20v8, c20v9, c20v10, c20v11
      if c20v1 == nil then
        c20v1 = 0
      end
      c20v5 = c20v0:GetHowManyElements()
      c20v6 = 0
      if c20v6 < c20v5 then
        while true do
          c20v6 = 0
          if not (c20v1 < c20v6) then break end
          c20v1 = c20v5 + c20v1
        end
        while true do
          c20v6 = c20v5 + 1
          if not (c20v6 < c20v1) then break end
          c20v1 = c20v1 - c20v5
        end
      end
      c20v6 = false
      if (c20v1 == 0 or c20v5 == 0) then
        c20v1 = c20v5 + 1
      else
        if c20v1 <= c20v5 then
          c20v6 = true
        end
      end
      c20v8 = c20v2.Id
      c20v7 = IsNull
      c20v7 = c20v7(c20v8)
      if c20v7 then
        c20v8 = c20v0.mTopId
        c20v7 = c20v8 + 1
        c20v2.Id = c20v7
      end
      c20v8 = c20v2.Id
      c20v9 = c20v0.mTopId
      c20v7 = math.max
      c20v7 = c20v7(c20v8, c20v9)
      c20v0.mTopId = c20v7
      c20v7 = false
      c20v2.mInitialized = c20v7
      c20v7 = nil
      c20v2.mClipName = c20v7
      c20v7 = false
      c20v2.mClipEnabled = c20v7
      c20v2.mIndex = c20v1
      c20v8 = c20v0.mElements
      c20v7 = table.insert
      c20v7(c20v8, c20v1, c20v2)
      if c20v6 then
        c20v5 = c20v0:GetHowManyElements()
        c20v7 = ResetLineCount
        c20v8 = 0
        c20v7(c20v8)
        c20v9 = 1
        c20v7 = c20v5
        c20v8 = 1
        for __renovice_for_0_0 = c20v9, c20v7, c20v8 do
          c20v11 = c20v0.mElements
          c20v10 = c20v11[__renovice_for_0_0]
          c20v10.mIndex = __renovice_for_0_0
        end
      end
      c20v7 = c20v2.mOverrideClipName
      if c20v7 ~= nil then
        c20v9 = c20v2.mOverrideClipName
        c20v0:SetClipCallbacks(c20v9)
      end
      if not c20v3 then
        c20v9 = nil
        c20v0:Redraw(c20v9, c20v6, c20v4)
      end
      do return c20v2 end
    end
    c87v3.InsertElement = c87v5
    c87v5 = function(c21v0, c21v1, c21v2, c21v3)
      local c21v4, c21v5, c21v6
      c21v6 = c21v0:GetHowManyElements()
      c21v5 = c21v6 + 1
      c21v4 = c21v0:InsertElement(c21v5, c21v1, c21v2, c21v3)
      do return c21v4 end
    end
    c87v3.AddElement = c87v5
    c87v5 = function(c23v0, c23v1, c23v2, c23v3, c23v4, c23v5, c23v6)
      local c23v7, c23v8, c23v9, c23v10, c23v11, c23v12, c23v13, c23v14, c23v15, c23v16, c23v17, c23v18, c23v19, c23v20, c23v21, c23v22
      if c23v3 == nil then
        c23v3 = false
      end
      c23v9 = c23v0.mElements
      c23v8 = c23v9[c23v1]
      c23v7 = IsNull
      c23v7 = c23v7(c23v8)
      if not c23v7 then
        c23v7 = ResetLineCount
        c23v8 = 0
        c23v7(c23v8)
        c23v7 = c23v0:GetHowManyElements()
        c23v9 = c23v0.mElements
        c23v8 = c23v9[c23v1]
        c23v8 = c23v8.mClipName
        c23v11 = c23v0.mElements
        c23v10 = c23v11[c23v1]
        c23v10 = c23v10.mOverrideClipName
        if c23v10 == nil then
          c23v9 = false
        else
          c23v9 = true
        end
        c23v10 = c23v0:GetHowManyVisibleElements()
        c23v11 = IsNull
        c23v11 = c23v11(c23v8)
        if not c23v11 then
          c23v11 = function()
            local c22v0, c22v1, c22v2, c22v3
            local __renovice_state_0 = 0
            local __renovice_local_0 = c23v5
            if __renovice_local_0 then
              __renovice_state_0 = 8
            else
              __renovice_state_0 = 1
            end
            if __renovice_state_0 == 1 then
              __renovice_local_0 = c23v0
              __renovice_local_0 = __renovice_local_0.mVisibleElements
              if __renovice_local_0 == nil then
                __renovice_state_0 = 4
              else
                __renovice_state_0 = 2
              end
            end
            if __renovice_state_0 == 2 then
              __renovice_local_0 = c23v7
              c22v0 = c23v10
              if __renovice_local_0 <= c22v0 then
                __renovice_state_0 = 4
              else
                __renovice_state_0 = 3
              end
            end
            if __renovice_state_0 == 3 then
              __renovice_local_0 = c23v4
              if not __renovice_local_0 then
                __renovice_state_0 = 8
              else
                __renovice_state_0 = 4
              end
            end
            if __renovice_state_0 == 4 then
              __renovice_local_0 = c23v9
              if __renovice_local_0 then
                __renovice_state_0 = 7
              else
                __renovice_state_0 = 5
              end
            end
            if __renovice_state_0 == 5 then
              __renovice_local_0 = c23v8
              c22v0 = c23v0
              c22v0 = c22v0.mClipName
              if __renovice_local_0 == c22v0 then
                __renovice_state_0 = 7
              else
                __renovice_state_0 = 6
              end
            end
            if __renovice_state_0 == 6 then
              __renovice_local_0 = FlashMethod
              c22v0 = c23v0
              c22v0 = c22v0.mMovie
              c22v2 = c23v8
              c22v3 = ".removeMovieClip"
              c22v1 = c22v2 .. c22v3
              __renovice_local_0(c22v0, c22v1)
              __renovice_state_0 = 8
            end
            if __renovice_state_0 == 7 then
              __renovice_local_0 = c23v0
              __renovice_local_0 = __renovice_local_0.mMovie
              c22v1 = c23v8
              c22v2 = 12
              c22v3 = 0
              __renovice_local_0:SetNumberVariable(c22v1, c22v2, c22v3)
              __renovice_local_0 = c23v0
              __renovice_local_0 = __renovice_local_0.mMovie
              c22v1 = c23v8
              c22v2 = 67
              c22v3 = false
              __renovice_local_0:Name__863e56e7(c22v1, c22v2, c22v3)
              __renovice_state_0 = 8
            end
            if __renovice_state_0 == 8 then
              __renovice_local_0 = c23v2
              if __renovice_local_0 then
                __renovice_state_0 = 10
              else
                __renovice_state_0 = 9
              end
            end
            if __renovice_state_0 == 9 then
              __renovice_local_0 = c23v0
              c22v1 = nil
              c22v2 = true
              c22v3 = c23v3
              __renovice_local_0:Redraw(c22v1, c22v2, c22v3)
              __renovice_state_0 = 10
            end
            if __renovice_state_0 == 10 then
              do return end
            end
            do return end
          end
          if c23v3 then
            c23v12 = c23v0.mMovie
            c23v12:Name__6fdbb52c(c23v8)
            c23v11()
          else
            c23v12 = FlashInterpolate
            c23v13 = c23v0.mMovie
            c23v15 = c23v0.mEasing
            c23v17 = 12
            c23v18 = 1
            c23v16 = {c23v17, c23v18}
            c23v18 = 0
            c23v22 = c23v0.mElements
            c23v21 = c23v22[c23v1]
            c23v20 = c23v0:CalculateY(c23v21)
            c23v19 = c23v20 - 40
            c23v17 = {c23v18, c23v19}
            c23v18 = c23v0.mElementTransitionTime
            c23v19 = 0
            c23v12(c23v13, c23v8, c23v15, c23v16, c23v17, c23v18, c23v19, c23v11)
          end
          c23v12 = c23v0.mVisibleElements
          if ((c23v12 == nil or c23v7 <= c23v10) or c23v4) then
            c23v13 = c23v0.mOnRemovedCallback
            c23v12 = IsNull
            c23v12 = c23v12(c23v13)
            if not c23v12 then
              c23v15 = c23v0.mElements
              c23v14 = c23v15[c23v1]
              c23v0:mOnRemovedCallback(c23v14)
            end
            if not c23v5 then
              c23v12 = c23v0.mClips
              c23v13 = nil
              c23v12[c23v8] = c23v13
            end
          else
            c23v12 = c23v0.mClips
            c23v13 = false
            c23v12[c23v8] = c23v13
            c23v12 = c23v0.mMovie
            c23v15 = 12
            c23v16 = 0
            c23v12:SetNumberVariable(c23v8, c23v15, c23v16)
            c23v12 = c23v0.mClipName
            if c23v8 ~= c23v12 then
              c23v12 = c23v0.mMovie
              c23v15 = 67
              c23v16 = false
              c23v12:Name__863e56e7(c23v8, c23v15, c23v16)
            end
          end
          c23v12 = ResetLineCount
          c23v13 = 0
          c23v12(c23v13)
        end
        c23v12 = c23v0.mSelectedElement
        c23v11 = IsNull
        c23v11 = c23v11(c23v12)
        if not c23v11 then
          c23v12 = c23v0.mElements
          c23v11 = c23v12[c23v1]
          c23v11 = c23v11.Id
          c23v12 = c23v0.mSelectedElement
          c23v12 = c23v12.Id
          if c23v11 == c23v12 then
            c23v11 = nil
            c23v0.mSelectedElement = c23v11
          end
        end
        c23v12 = c23v0.mElements
        c23v11 = c23v12[c23v1]
        c23v11 = c23v11.Id
        c23v12 = table.remove
        c23v13 = c23v0.mElements
        c23v12(c23v13, c23v1)
        c23v12 = IsNull
        c23v12 = c23v12(c23v11)
        if not c23v12 then
          c23v12 = c23v0.mTopId
          if c23v11 == c23v12 then
            c23v12 = c23v0:GetHowManyElements()
            c23v13 = 0
            c23v14 = ResetLineCount
            c23v15 = 0
            c23v14(c23v15)
            c23v16 = 1
            c23v14 = c23v12
            c23v15 = 1
            for __renovice_for_0_0 = c23v16, c23v14, c23v15 do
              c23v18 = c23v0.mElements
              c23v17 = c23v18[__renovice_for_0_0]
              c23v17 = c23v17.Id
              if not (c23v13 < c23v17) then
                continue
              end
              c23v18 = c23v0.mElements
              c23v17 = c23v18[__renovice_for_0_0]
              c23v13 = c23v17.Id
            end
            c23v0.mTopId = c23v13
          end
        end
        if not c23v6 then
          c23v12 = c23v0:GetHowManyElements()
          c23v15 = 1
          c23v13 = c23v12
          c23v14 = 1
          for __renovice_for_1_0 = c23v15, c23v13, c23v14 do
            c23v17 = c23v0.mElements
            c23v16 = c23v17[__renovice_for_1_0]
            c23v16.mIndex = __renovice_for_1_0
          end
        end
      end
      do return end
    end
    c87v3.RemoveElement = c87v5
    c87v5 = function(c24v0, c24v1, c24v2, c24v3)
      local c24v4
      c24v4 = c24v0:GetElementIndexById(c24v1)
      c24v0:RemoveElement(c24v4, c24v2, c24v3)
      do return end
    end
    c87v3.RemoveElementById = c87v5
    c87v5 = function(c25v0, c25v1, c25v2)
      local c25v3, c25v4, c25v5, c25v6, c25v7, c25v8, c25v9, c25v10, c25v11, c25v12, c25v13, c25v14
      c25v4 = c25v0.mCurrentElementIndex
      c25v3 = IsNull
      c25v3 = c25v3(c25v4)
      if not c25v3 then
        c25v5 = c25v0.mCurrentElementIndex
        c25v0:UnfocusElement(c25v5)
      end
      c25v4 = c25v0.mElements
      c25v3 = #c25v4
      c25v4 = 0
      c25v0.mTopId = c25v4
      c25v6 = 0
      c25v4 = c25v3 - 1
      c25v5 = 1
      for __renovice_for_0_0 = c25v6, c25v4, c25v5 do
        c25v9 = c25v3 - __renovice_for_0_0
        c25v12 = true
        c25v13 = c25v0.mPreserveClips
        c25v14 = true
        c25v0:RemoveElement(c25v9, c25v1, c25v2, c25v12, c25v13, c25v14)
      end
      c25v5 = c25v0.mScroll
      c25v4 = IsNull
      c25v4 = c25v4(c25v5)
      if not c25v4 then
        c25v6 = 1
        c25v7 = true
        c25v0:SetScroll(c25v6, c25v7)
      end
      c25v4 = 0
      c25v0.mTopClipIndexUsed = c25v4
      c25v4 = c25v0.mPreserveClips
      if not c25v4 then
        c25v4 = pairs
        c25v5 = c25v0.mClips
        c25v4, c25v5, c25v6 = c25v4(c25v5)
        for __renovice_for_1_0, __renovice_for_1_1 in c25v4, c25v5, c25v6 do
          c25v9 = c25v0.mClipName
          if __renovice_for_1_0 ~= c25v9 then
            c25v9 = FlashMethod
            c25v10 = c25v0.mMovie
            c25v13 = ".removeMovieClip"
            c25v11 = __renovice_for_1_0 .. c25v13
            c25v9(c25v10, c25v11)
          else
            c25v9 = c25v0.mMovie
            c25v12 = 12
            c25v13 = 0
            c25v9:SetNumberVariable(__renovice_for_1_0, c25v12, c25v13)
          end
          c25v9 = c25v0.mClips
          c25v10 = nil
          c25v9[__renovice_for_1_0] = c25v10
        end
      end
      c25v4 = nil
      c25v0.mSelectedElement = c25v4
      c25v4 = c25v0.mMovie
      c25v6 = c25v0.mClipName
      c25v7 = 67
      c25v8 = false
      c25v4:Name__863e56e7(c25v6, c25v7, c25v8)
      do return end
    end
    c87v3.RemoveElements = c87v5
    c87v5 = function(c26v0)
      c26v0:RemoveElements()
      c26v0 = nil
      do return end
    end
    c87v3.Remove = c87v5
    c87v5 = function(c27v0, c27v1)
      local c27v2, c27v3
      c27v3 = c27v0.mOnUnfocusedCallback
      c27v2 = IsNull
      c27v2 = c27v2(c27v3)
      if not c27v2 then
        c27v2 = c27v0.mOnUnfocusedCallback
        c27v2(c27v1)
      end
      do return end
    end
    c87v3.OnUnfocused = c87v5
    c87v5 = function(c28v0, c28v1)
      local c28v2, c28v3, c28v4, c28v5
      c28v2 = c28v0.mCurrentElementIndex
      if c28v2 == c28v1 then
        c28v4 = c28v0.mElements
        c28v3 = c28v4[c28v1]
        c28v2 = IsNull
        c28v2 = c28v2(c28v3)
        if not c28v2 then
          c28v3 = c28v0.mElements
          c28v2 = c28v3[c28v1]
          c28v2 = c28v2.mInitialized
          if c28v2 then
            c28v5 = c28v0.mElements
            c28v4 = c28v5[c28v1]
            c28v0:OnUnfocused(c28v4)
            c28v2 = nil
            c28v0.mCurrentElementIndex = c28v2
          end
        end
      end
      do return end
    end
    c87v3.UnfocusElement = c87v5
    c87v5 = function(c29v0, c29v1)
      local c29v2, c29v3
      c29v2 = c29v0:GetElementIndexById(c29v1)
      c29v3 = IsNull
      c29v3 = c29v3(c29v2)
      if not c29v3 then
        c29v0:UnfocusElement(c29v2)
      end
      do return end
    end
    c87v3.UnfocusElementById = c87v5
    c87v5 = function(c30v0, c30v1)
      local c30v2, c30v3
      c30v3 = c30v0.mOnFocusedCallback
      c30v2 = IsNull
      c30v2 = c30v2(c30v3)
      if not c30v2 then
        c30v2 = c30v0.mOnFocusedCallback
        c30v2(c30v1)
      end
      do return end
    end
    c87v3.OnFocused = c87v5
    c87v5 = function(c31v0, c31v1, c31v2)
      local c31v3, c31v4, c31v5, c31v6, c31v7, c31v8, c31v9
      c31v3 = c31v0.mCurrentElementIndex
      if c31v3 ~= c31v1 then
        c31v5 = c31v0.mElements
        c31v4 = c31v5[c31v1]
        c31v3 = IsNull
        c31v3 = c31v3(c31v4)
        if not c31v3 then
          c31v4 = c31v0.mElements
          c31v3 = c31v4[c31v1]
          c31v3 = c31v3.mInitialized
          if c31v3 then
            c31v4 = c31v0.mCurrentElementIndex
            c31v3 = IsNull
            c31v3 = c31v3(c31v4)
            if not c31v3 then
              c31v5 = c31v0.mCurrentElementIndex
              c31v0:UnfocusElement(c31v5)
            end
            c31v4 = c31v0.mScroll
            c31v3 = IsNull
            c31v3 = c31v3(c31v4)
            if (not c31v3 and not c31v2) then
              c31v3 = nil
              c31v6 = c31v0.mScroll
              c31v7 = c31v0:GetHowManyVisibleElements()
              c31v5 = c31v6 + c31v7
              c31v4 = c31v5 - 1
              c31v5 = c31v0.mScroll
              if c31v1 < c31v5 then
                c31v3 = c31v1
              else
                if c31v4 < c31v1 then
                  c31v6 = c31v0:GetHowManyVisibleElements()
                  c31v5 = c31v1 - c31v6
                  c31v3 = c31v5 + 1
                end
              end
              c31v5 = IsNull
              c31v5 = c31v5(c31v3)
              if not c31v5 then
                c31v8 = true
                c31v0:SetScroll(c31v3, c31v8)
                c31v7 = nil
                c31v8 = false
                c31v9 = true
                c31v0:Redraw(c31v7, c31v8, c31v9)
              end
            end
            c31v0.mCurrentElementIndex = c31v1
            c31v6 = c31v0.mElements
            c31v5 = c31v6[c31v1]
            c31v0:OnFocused(c31v5)
            do return end
          end
        end
      end
      do return end
    end
    c87v3.FocusElement = c87v5
    c87v5 = function(c32v0, c32v1, c32v2)
      local c32v3, c32v4
      c32v3 = c32v0:GetElementIndexById(c32v1)
      c32v4 = IsNull
      c32v4 = c32v4(c32v3)
      if not c32v4 then
        c32v0:FocusElement(c32v3, c32v2)
      end
      do return end
    end
    c87v3.FocusElementById = c87v5
    c87v5 = function(c33v0, c33v1, c33v2)
      local c33v3, c33v4, c33v5, c33v6, c33v7
      c33v3 = 0
      c33v5 = c33v0.mScroll
      c33v4 = IsNull
      c33v4 = c33v4(c33v5)
      if not c33v4 then
        c33v4 = c33v0.mScroll
        c33v3 = c33v4 - c33v1
      end
      c33v5 = c33v0.mCurrentElementIndex
      c33v4 = IsNull
      c33v4 = c33v4(c33v5)
      if not c33v4 then
        c33v3 = c33v0.mCurrentElementIndex
      end
      if c33v2 then
        c33v5 = c33v0.mSelectedElement
        c33v4 = IsNull
        c33v4 = c33v4(c33v5)
        if not c33v4 then
          c33v4 = c33v0.mSelectedElement
          c33v3 = c33v4.mIndex
        end
      end
      c33v4 = c33v0.mScrollBar
      if c33v4 ~= nil then
        local __renovice_state_0 = 8
        c33v4 = c33v0.DOWN
        if c33v1 ~= c33v4 then
          __renovice_state_0 = 12
        else
          __renovice_state_0 = 9
        end
        if __renovice_state_0 == 9 then
          c33v6 = c33v0.mScroll
          c33v7 = c33v0:GetHowManyVisibleElements()
          c33v5 = c33v6 + c33v7
          c33v4 = c33v5 - 1
          if c33v3 ~= c33v4 then
            __renovice_state_0 = 12
          else
            __renovice_state_0 = 10
          end
        end
        if __renovice_state_0 == 10 then
          c33v4 = c33v0.mScrollBar
          c33v4 = c33v4:GetScrollValue()
          c33v5 = 1
          if not (c33v4 < c33v5) then
            __renovice_state_0 = 12
          else
            __renovice_state_0 = 11
          end
        end
        if __renovice_state_0 == 11 then
          c33v4 = c33v0.mScrollBar
          c33v4:ScrollDown()
        end
        if __renovice_state_0 == 12 then
          c33v4 = c33v0.UP
          if c33v1 ~= c33v4 then
          else
            __renovice_state_0 = 13
          end
        end
        if __renovice_state_0 == 13 then
          c33v4 = c33v0.mScroll
          if c33v3 ~= c33v4 then
          else
            __renovice_state_0 = 14
          end
        end
        if __renovice_state_0 == 14 then
          c33v4 = c33v0.mScrollBar
          c33v4 = c33v4:GetScrollValue()
          c33v5 = 0
          if not (c33v5 < c33v4) then
          else
            __renovice_state_0 = 15
          end
        end
        if __renovice_state_0 == 15 then
          c33v4 = c33v0.mScrollBar
          c33v4:ScrollUp()
        end
      end
      c33v4 = c33v0.mWrapAroundNavigation
      if c33v4 then
        c33v4 = c33v0.UTIL
        c33v4 = c33v4.ToggleValue
        c33v7 = 1
        c33v3 = c33v4(c33v3, c33v1, c33v7, c33v0:GetHowManyElements())
        do return c33v3 end
      end
      c33v4 = Clamp
      c33v5 = c33v3 + c33v1
      c33v6 = 1
      c33v3 = c33v4(c33v5, c33v6, c33v0:GetHowManyElements())
      do return c33v3 end
    end
    c87v3.GetIndexInDirection = c87v5
    c87v5 = function(c34v0, c34v1)
      local c34v2, c34v3, c34v4, c34v5
      c34v2 = c34v0:GetIndexInDirection(c34v1)
      c34v5 = c34v2
      c34v3 = c34v0:GetElementById(c34v5)
      c34v4 = IsNull
      c34v4 = c34v4(c34v3)
      if not c34v4 then
        c34v4 = c34v0.mIgnoreFiller
        if c34v4 then
          c34v4 = c34v3.Filler
          if c34v4 then
            do return end
          end
        end
      end
      c34v0:FocusElement(c34v2)
      do return end
    end
    c87v3.ToggleFocusedElement = c87v5
    c87v5 = function(c35v0)
      local c35v1
      c35v1 = c35v0.UTIL
      c35v1 = c35v1.INCREMENT
      c35v0:ToggleFocusedElement(c35v1)
      do return end
    end
    c87v3.FocusNextElement = c87v5
    c87v5 = function(c36v0)
      local c36v1
      c36v1 = c36v0.UTIL
      c36v1 = c36v1.DECREMENT
      c36v0:ToggleFocusedElement(c36v1)
      do return end
    end
    c87v3.FocusPreviousElement = c87v5
    c87v5 = function(c37v0, c37v1)
      local c37v2, c37v3, c37v4, c37v5, c37v6, c37v7, c37v8, c37v9
      c37v4 = c37v0.mElements
      c37v3 = c37v4[c37v1]
      c37v2 = IsNull
      c37v2 = c37v2(c37v3)
      if not c37v2 then
        c37v3 = c37v0.mElements
        c37v2 = c37v3[c37v1]
        c37v2 = c37v2.mInitialized
        if c37v2 then
          c37v3 = c37v0.mElements
          c37v2 = c37v3[c37v1]
          c37v4 = c37v0.mOnPressedCallback
          c37v3 = IsNull
          c37v3 = c37v3(c37v4)
          if not c37v3 then
            c37v3 = c37v0.mOnPressedCallback
            c37v3(c37v2)
          else
            c37v3 = c37v0.mClickDrag
            c37v3 = c37v3.Enabled
            if c37v3 then
              c37v3 = c37v0.mClickDrag
              c37v4 = c37v2.Id
              c37v3.DragId = c37v4
              c37v3 = c37v0.mClickDrag
              c37v3.DragIndex = c37v1
              c37v3 = c37v0.mClickDrag
              c37v4 = Vector
              c37v5 = c37v0.mMovie
              c37v7 = "_root"
              c37v8 = 30
              c37v5 = c37v5:GetNumberVariable(c37v7, c37v8)
              c37v6 = c37v0.mMovie
              c37v8 = "_root"
              c37v9 = 31
              c37v6 = c37v6:GetNumberVariable(c37v8, c37v9)
              c37v7 = 0
              c37v4 = c37v4(c37v5, c37v6, c37v7)
              c37v3.InitDownPos = c37v4
            end
          end
          c37v0:StartScrollDrag(c37v1)
        end
      end
      do return end
    end
    c87v3.PressedElement = c87v5
    c87v5 = function(c38v0, c38v1)
      c38v0:PressedElement(c38v0:GetElementIndexById(c38v1))
      do return end
    end
    c87v3.PressedElementById = c87v5
    c87v5 = function(c39v0)
      local c39v1, c39v2, c39v3
      c39v2 = c39v0.mCurrentElementIndex
      c39v1 = IsNull
      c39v1 = c39v1(c39v2)
      if not c39v1 then
        c39v3 = c39v0.mCurrentElementIndex
        c39v0:PressedElement(c39v3)
      end
      do return end
    end
    c87v3.PressCurrentElement = c87v5
    c87v5 = function(c40v0, c40v1, c40v2)
      local c40v3, c40v4, c40v5, c40v6, c40v7
      local __renovice_state_0 = 0
      c40v3 = c40v0.mScrollDrag
      c40v3 = c40v3.Enabled
      if not c40v3 then
        __renovice_state_0 = 12
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c40v3 = c40v0.mScrollDrag
        c40v3 = c40v3.isPressed
        if c40v3 then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        c40v3 = c40v0.mScrollDrag
        c40v3 = c40v3.isDragging
        if c40v3 then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        c40v3 = c40v0.mScrollDrag
        c40v3 = c40v3.isStopping
        if not c40v3 then
          __renovice_state_0 = 12
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c40v3 = c40v0.mScrollDrag
        c40v3 = c40v3.isDragging
        if c40v3 then
          __renovice_state_0 = 6
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c40v3 = c40v0.mScrollDrag
        c40v3 = c40v3.isStopping
        __renovice_state_0 = 6
      end
      if __renovice_state_0 == 6 then
        c40v4 = c40v0.mStopDragScrollingOnSelection
        if not c40v4 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 7
        end
      end
      if __renovice_state_0 == 7 then
        c40v0:StopScrollDrag()
        c40v0:StopDragging()
        __renovice_state_0 = 8
      end
      if __renovice_state_0 == 8 then
        if not c40v3 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 9
        end
      end
      if __renovice_state_0 == 9 then
        c40v4 = c40v0.mAllowElementSelectionOnScrollDragEnd
        if c40v4 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 10
        end
      end
      if __renovice_state_0 == 10 then
        do return end
      end
      if __renovice_state_0 == 12 then
        c40v3 = c40v0.mClickDrag
        c40v3 = c40v3.Enabled
        if not c40v3 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 13
        end
      end
      if __renovice_state_0 == 13 then
        c40v3 = c40v0.mClickDrag
        c40v3 = c40v3.DragId
        if c40v3 == nil then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 14
        end
      end
      if __renovice_state_0 == 14 then
        c40v3 = true
        c40v4 = c40v0.mClickDrag
        c40v5 = nil
        c40v4.DragId = c40v5
        c40v4 = c40v0.mClickDrag
        c40v4 = c40v4.Dragging
        if not c40v4 then
          __renovice_state_0 = 20
        else
          __renovice_state_0 = 15
        end
      end
      if __renovice_state_0 == 15 then
        c40v4 = c40v0.UTIL
        c40v4 = c40v4.PlaySound
        c40v5 = _G
        c40v5 = c40v5.UISound_EndDrag
        c40v4(c40v5)
        c40v4 = c40v0.mClickDrag
        c40v4 = c40v4.FocusedIndex
        if c40v4 == nil then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 16
        end
      end
      if __renovice_state_0 == 16 then
        c40v4 = c40v0.mClickDrag
        c40v4 = c40v4.FocusedIndex
        c40v5 = c40v0.mClickDrag
        c40v5 = c40v5.DragIndex
        if c40v4 == c40v5 then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 17
        end
      end
      if __renovice_state_0 == 17 then
        c40v5 = c40v0.mOnDraggedCallback
        c40v4 = IsNull
        c40v4 = c40v4(c40v5)
        if c40v4 then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 18
        end
      end
      if __renovice_state_0 == 18 then
        c40v4 = c40v0.mOnDraggedCallback
        c40v4()
        __renovice_state_0 = 19
      end
      if __renovice_state_0 == 19 then
        c40v3 = false
        __renovice_state_0 = 20
      end
      if __renovice_state_0 == 20 then
        c40v0:StopDragging()
        if c40v3 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 21
        end
      end
      if __renovice_state_0 == 21 then
        do return end
      end
      if __renovice_state_0 == 22 then
        c40v3 = c40v0.mSelectedElement
        c40v4 = false
        if c40v3 ~= c40v1 then
          __renovice_state_0 = 28
        else
          __renovice_state_0 = 23
        end
      end
      if __renovice_state_0 == 23 then
        c40v6 = c40v0.mOnDoubleClickCallback
        c40v5 = IsNull
        c40v5 = c40v5(c40v6)
        c40v4 = not c40v5
        if not c40v4 then
          __renovice_state_0 = 28
        else
          __renovice_state_0 = 24
        end
      end
      if __renovice_state_0 == 24 then
        c40v4 = Engine.IsPlayingWithController
        c40v4 = c40v4()
        if c40v4 then
          __renovice_state_0 = 28
        else
          __renovice_state_0 = 25
        end
      end
      if __renovice_state_0 == 25 then
        c40v6 = Time
        c40v6 = c40v6()
        c40v7 = c40v0.mLastPressTime
        c40v5 = c40v6 - c40v7
        c40v6 = 0.5
        if c40v5 < c40v6 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 26
        end
      end
      if __renovice_state_0 == 26 then
        c40v4 = false
        __renovice_state_0 = 28
      end
      if __renovice_state_0 == 27 then
        c40v4 = true
        __renovice_state_0 = 28
      end
      if __renovice_state_0 == 28 then
        c40v5 = Time
        c40v5 = c40v5()
        c40v0.mLastPressTime = c40v5
        c40v0.mSelectedElement = c40v1
        if not c40v4 then
          __renovice_state_0 = 30
        else
          __renovice_state_0 = 29
        end
      end
      if __renovice_state_0 == 29 then
        c40v5 = c40v0.mOnDoubleClickCallback
        c40v5(c40v1, c40v2, c40v3)
        do return end
      end
      if __renovice_state_0 == 30 then
        c40v6 = c40v0.mOnSelectedCallback
        c40v5 = IsNull
        c40v5 = c40v5(c40v6)
        if c40v5 then
          __renovice_state_0 = 32
        else
          __renovice_state_0 = 31
        end
      end
      if __renovice_state_0 == 31 then
        c40v5 = c40v0.mOnSelectedCallback
        c40v5(c40v1, c40v2, c40v3)
        __renovice_state_0 = 32
      end
      if __renovice_state_0 == 32 then
        do return end
      end
      do return end
    end
    c87v3.OnSelected = c87v5
    c87v5 = function(c41v0, c41v1, c41v2)
      local c41v3, c41v4, c41v5, c41v6
      c41v5 = c41v0.mElements
      c41v4 = c41v5[c41v1]
      c41v3 = IsNull
      c41v3 = c41v3(c41v4)
      if not c41v3 then
        c41v4 = c41v0.mElements
        c41v3 = c41v4[c41v1]
        c41v3 = c41v3.mInitialized
        if c41v3 then
          c41v6 = c41v0.mElements
          c41v5 = c41v6[c41v1]
          c41v0:OnSelected(c41v5, c41v2)
        end
      end
      do return end
    end
    c87v3.SelectElement = c87v5
    c87v5 = function(c42v0, c42v1, c42v2)
      local c42v3, c42v4
      c42v3 = c42v0:GetElementIndexById(c42v1)
      c42v4 = IsNull
      c42v4 = c42v4(c42v3)
      if not c42v4 then
        c42v0:SelectElement(c42v3, c42v2)
      end
      do return end
    end
    c87v3.SelectElementById = c87v5
    c87v5 = function(c43v0, c43v1)
      local c43v2, c43v3, c43v4
      c43v3 = c43v0.mCurrentElementIndex
      c43v2 = IsNull
      c43v2 = c43v2(c43v3)
      if not c43v2 then
        c43v4 = c43v0.mCurrentElementIndex
        c43v0:SelectElement(c43v4, c43v1)
      end
      do return end
    end
    c87v3.SelectCurrentElement = c87v5
    c87v5 = function(c44v0, c44v1, c44v2)
      local c44v3, c44v4, c44v5, c44v6
      c44v6 = true
      c44v3 = c44v0:GetIndexInDirection(c44v1, c44v6)
      c44v6 = c44v3
      c44v4 = c44v0:GetElementById(c44v6)
      c44v5 = IsNull
      c44v5 = c44v5(c44v4)
      if not c44v5 then
        c44v5 = c44v0.mIgnoreFiller
        if c44v5 then
          c44v5 = c44v4.Filler
          if c44v5 then
            do return end
          end
        end
      end
      c44v0:SelectElement(c44v3, c44v2)
      do return end
    end
    c87v3.SelectElementInDirection = c87v5
    c87v5 = function(c45v0, c45v1)
      local c45v2, c45v3, c45v4, c45v5, c45v6, c45v7, c45v8, c45v9
      c45v4 = c45v0.mScroll
      if c45v4 ~= nil then
        c45v4 = c45v0.mOriginalButtonHeight
        if c45v4 ~= nil then
          c45v6 = c45v0.mScroll
          c45v7 = c45v0:GetHowManyVisibleElements()
          c45v5 = c45v6 + c45v7
          c45v4 = c45v5 - 1
          c45v5 = c45v1.mIndex
          if c45v4 < c45v5 then
            c45v7 = c45v1.mIndex
            c45v6 = c45v7 - c45v4
            c45v5 = 1 - c45v6
            c45v6 = c45v0.mForcedVerticalSeparation
            c45v2 = c45v5 * c45v6
            c45v7 = c45v0.mForcedVerticalSeparation
            c45v6 = -c45v7
            c45v5 = c45v6 + c45v2
            c45v3 = c45v5 / 2
          else
            c45v5 = c45v1.mIndex
            c45v6 = c45v0.mScroll
            if c45v5 < c45v6 then
              c45v7 = c45v0.mScroll
              c45v8 = c45v1.mIndex
              c45v6 = c45v7 - c45v8
              c45v5 = 1 - c45v6
              c45v6 = c45v0.mForcedVerticalSeparation
              c45v2 = c45v5 * c45v6
              c45v6 = c45v0.mForcedVerticalSeparation
              c45v5 = c45v6 - c45v2
              c45v3 = c45v5 / 2
            else
              c45v2 = c45v0.mOriginalButtonHeight
              c45v3 = 0
            end
          end
          if c45v2 ~= nil then
            c45v7 = 0.01
            c45v5 = math.max
            c45v2 = c45v5(c45v2, c45v7)
            c45v5 = c45v0.mMovie
            c45v7 = c45v1.mClipName
            c45v8 = "Btn"
            c45v9 = 15
            c45v5:Name__82f6549c(c45v7, c45v8, c45v9, c45v2)
            c45v5 = c45v0.mMovie
            c45v7 = c45v1.mClipName
            c45v8 = "Btn"
            c45v9 = 1
            c45v5:Name__82f6549c(c45v7, c45v8, c45v9, c45v3)
          end
        end
      end
      do return c45v2, c45v3 end
    end
    c87v3.RepositionButton = c87v5
    c87v5 = function(c46v0, c46v1, c46v2)
      local c46v3, c46v4
      c46v3 = c46v0.mSmoothScroll
      if c46v3 then
        c46v0:RepositionButton(c46v1)
      end
      if c46v2 == nil then
        c46v3 = print
        c46v4 = "ERROR: pNeedsElementDrawCallback is nil!"
        c46v3(c46v4)
        c46v3 = Name__b14cb768
        c46v3()
        c46v2 = true
      end
      c46v4 = c46v0.mElementDrawCallback
      c46v3 = IsNull
      c46v3 = c46v3(c46v4)
      if (not c46v3 and c46v2) then
        c46v3 = c46v0.mElementDrawCallback
        c46v3(c46v1)
      end
      do return end
    end
    c87v3.OnDraw = c87v5
    c87v5 = function(c47v0, c47v1)
      do return end
    end
    c87v3.OnElementTransitionStarted = c87v5
    c87v5 = function(c48v0, c48v1)
      do return end
    end
    c87v3.OnElementTransitionEnded = c87v5
    c87v5 = function(c49v0, c49v1)
      local c49v2, c49v3, c49v4, c49v5, c49v6
      c49v2 = c49v0:CalculateY(c49v1)
      c49v3 = c49v0.mMovie
      c49v4 = c49v1.mClipName
      c49v5 = 1
      c49v6 = c49v2 - 20
      c49v3:SetNumberVariable(c49v4, c49v5, c49v6)
      do return end
    end
    c87v3.SetupPreInterpolationValues = c87v5
    c87v5 = function(c50v0, c50v1)
      local c50v2, c50v3
      c50v2 = c50v0.mInterpolationValues
      c50v3 = c50v0:CalculateY(c50v1)
      c50v2[2] = c50v3
      c50v2 = c50v0.mInterpolationProps
      c50v3 = c50v0.mInterpolationValues
      do return c50v2, c50v3 end
    end
    c87v3.GetInterpolationProperties = c87v5
    c87v6 = 12
    c87v5 = {c87v6}
    c87v3._DefaultAlphaInterpolationVars = c87v5
    c87v6 = 100
    c87v5 = {c87v6}
    c87v3._DefaultAlphaInterpolationValues = c87v5
    c87v5 = function(c51v0, c51v1)
      local c51v2, c51v3
      c51v2 = c51v0._DefaultAlphaInterpolationVars
      c51v3 = c51v0._DefaultAlphaInterpolationValues
      do return c51v2, c51v3 end
    end
    c87v3.DefaultAlphaInterpolation = c87v5
    c87v5 = function(c52v0)
      local c52v1, c52v2, c52v3, c52v4, c52v5, c52v6, c52v7, c52v8, c52v9, c52v10
      c52v1 = c52v0:GetHowManyElements()
      c52v2 = c52v0:GetHowManyVisibleElements()
      c52v3 = 1
      c52v4 = c52v1
      c52v5 = c52v0.mScroll
      if c52v5 ~= nil then
        c52v6 = c52v0.mSmoothScroll
        if c52v6 then
          c52v7 = 1
          c52v9 = math.floor
          c52v9 = c52v9(c52v5)
          c52v10 = c52v0.mLowerBoundBuffer
          c52v8 = c52v9 - c52v10
          c52v6 = math.max
          c52v3 = c52v6(c52v7, c52v8)
          c52v8 = c52v3 + c52v2
          c52v7 = math.floor
          c52v7 = c52v7(c52v8)
          c52v8 = c52v0.mLowerBoundBuffer
          c52v6 = c52v7 + c52v8
          c52v7 = c52v0.mUpperBoundBuffer
          c52v4 = c52v6 + c52v7
          do return c52v3, c52v4 end
        end
        c52v3 = c52v5
        c52v6 = c52v5 + c52v2
        c52v4 = c52v6 - 1
      end
      do return c52v3, c52v4 end
    end
    c87v3.GetBounds = c87v5
    c87v5 = function(c53v0)
      local c53v1, c53v2, c53v3, c53v4
      c53v1 = c53v0.mClipCreatedCallback
      if c53v1 ~= nil then
        c53v1 = c53v0.mClipCreatedCallback
        c53v2 = c53v0.mClipName
        c53v4 = c53v0.mElements
        c53v3 = c53v4[1]
        c53v1(c53v2, c53v3)
      end
      do return end
    end
    c87v3.OnFirstRedraw = c87v5
    c87v5 = function(c55v0, c55v1, c55v2, c55v3)
      local c55v4, c55v5, c55v6, c55v7, c55v8, c55v9, c55v10, c55v11, c55v12, c55v13, c55v14, c55v15, c55v16, c55v17, c55v18, c55v19, c55v20, c55v21, c55v22, c55v23, c55v24, c55v25, c55v26, c55v27, c55v28, c55v29
      local __renovice_local_0 = c55v0.mMovie
      local __renovice_local_1 = IsNull
      __renovice_local_1 = __renovice_local_1(__renovice_local_0)
      if __renovice_local_1 then
        do return end
      end
      __renovice_local_1 = c55v0.mDisableRedraw
      if __renovice_local_1 then
        do return end
      end
      local __renovice_state_0 = -1
      __renovice_local_1 = c55v0.mHasDrawn
      if not __renovice_local_1 then
        __renovice_state_0 = -1
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        if not c55v2 then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        __renovice_local_0 = c55v0.mElements
        __renovice_local_1 = __renovice_local_0[1]
        if __renovice_local_1 == nil then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        __renovice_local_0 = c55v0.mElements
        __renovice_local_1 = __renovice_local_0[1]
        __renovice_local_1 = __renovice_local_1.mInitialized
        if __renovice_local_1 then
          __renovice_state_0 = 4
        else
          __renovice_state_0 = -1
        end
      end
      if __renovice_state_0 ~= 4 then
        c55v0:OnFirstRedraw()
        __renovice_local_1 = true
        c55v0.mHasDrawn = __renovice_local_1
      end
      __renovice_local_1 = c55v0:GetHowManyElements()
      __renovice_local_0 = nil
      c55v4 = 0
      c55v5 = true
      c55v6 = c55v0.mElementTransitionTime
      if c55v3 then
        c55v4 = 0
        c55v6 = 0
      end
      if __renovice_local_1 == 0 then
        c55v7 = IsNull
        c55v7 = c55v7(c55v1)
        if not c55v7 then
          c55v1()
        end
      end
      c55v7, c55v8 = c55v0:GetBounds()
      c55v9 = c55v0.mScroll
      c55v10 = true
      c55v11 = true
      c55v12 = 1
      c55v13 = __renovice_local_1
      c55v14 = c55v0.mMaxElementsToDrawPerFrame
      if c55v14 ~= nil then
        c55v14 = c55v0.mRedrawElementIndex
        if c55v14 == nil then
          c55v14 = { Callback = nil, ForceUpdate = nil, InstantDraw = nil }
          c55v14.Callback = c55v1
          c55v14.ForceUpdate = c55v2
          c55v14.InstantDraw = c55v3
          c55v0.mRedrawCachedParams = c55v14
        else
          c55v12 = c55v0.mRedrawElementIndex
        end
        c55v18 = c55v0.mMaxElementsToDrawPerFrame
        c55v17 = c55v18 - 1
        c55v16 = c55v12 + c55v17
        c55v14 = math.min
        c55v13 = c55v14(__renovice_local_1, c55v16)
        if c55v13 == __renovice_local_1 then
          c55v14 = nil
          c55v0.mRedrawElementIndex = c55v14
        else
          c55v14 = c55v13 + 1
          c55v0.mRedrawElementIndex = c55v14
          c55v10 = false
        end
      end
      c55v16 = c55v12
      c55v14 = c55v13
      c55v15 = 1
      for __renovice_for_0_0 = c55v16, c55v14, c55v15 do
        c55v17 = ResetLineCount
        c55v18 = 0
        c55v17(c55v18)
        c55v18 = c55v0.mElements
        c55v17 = c55v18[__renovice_for_0_0]
        __renovice_local_0 = nil
        c55v18 = false
        if c55v7 <= __renovice_for_0_0 then
          if not (__renovice_for_0_0 <= c55v8) then
            c55v18 = false
          else
            c55v18 = true
          end
        end
        if c55v18 then
          repeat
            c55v19 = c55v17.mClipName
            if c55v19 then
              c55v20 = c55v0.mClips
              c55v21 = c55v17.mClipName
              c55v19 = c55v20[c55v21]
              if c55v19 == true then
                __renovice_local_0 = c55v17.mClipName
                break
              end
            end
            c55v19 = c55v17.mOverrideClipName
            if c55v19 ~= nil then
              __renovice_local_0 = c55v17.mOverrideClipName
            else
              c55v19 = pairs
              c55v20 = c55v0.mClips
              c55v19, c55v20, c55v21 = c55v19(c55v20)
              for __renovice_for_1_0, __renovice_for_1_1 in c55v19, c55v20, c55v21 do
                if __renovice_for_1_1 then
                  continue
                end
                __renovice_local_0 = __renovice_for_1_0
                break
              end
              c55v19 = IsNull
              c55v19 = c55v19(__renovice_local_0)
              if c55v19 then
                c55v20 = c55v0.mTopClipIndexUsed
                c55v19 = c55v20 + 1
                c55v0.mTopClipIndexUsed = c55v19
                c55v19 = c55v0.mTopClipIndexUsed
                if c55v19 == 1 then
                  __renovice_local_0 = c55v0.mClipName
                else
                  c55v19 = c55v0.mClipName
                  c55v21 = c55v0.mTopClipIndexUsed
                  c55v20 = tostring
                  c55v20 = c55v20(c55v21)
                  __renovice_local_0 = c55v19 .. c55v20
                end
              end
              c55v19 = c55v0.mClips
              c55v20 = true
              c55v19[__renovice_local_0] = c55v20
            end
          until true
          c55v19 = c55v0.mHideExtraClips
          if c55v19 then
            c55v19 = c55v0.mMovie
            c55v22 = 13
            c55v23 = true
            c55v19:Name__863e56e7(__renovice_local_0, c55v22, c55v23)
          end
        else
          c55v19 = c55v17.mClipName
          if c55v19 then
            c55v20 = c55v0.mClips
            c55v21 = c55v17.mClipName
            c55v19 = c55v20[c55v21]
            if c55v19 == true then
              c55v19 = c55v0.mHideExtraClips
              if c55v19 then
                c55v19 = c55v0.mMovie
                c55v21 = c55v17.mClipName
                c55v22 = 13
                c55v23 = false
                c55v19:Name__863e56e7(c55v21, c55v22, c55v23)
              end
            end
          end
        end
        local __renovice_state_1 = -1
        c55v19 = c55v17.mForceRedraw
        if c55v19 then
          __renovice_state_1 = -1
        else
          __renovice_state_1 = 1
        end
        if __renovice_state_1 == 1 then
          c55v19 = c55v17.mClipName
          if (c55v19 ~= __renovice_local_0 or c55v2) then
            __renovice_state_1 = -1
          else
            __renovice_state_1 = 2
          end
        end
        if __renovice_state_1 == 2 then
          c55v19 = c55v17.mOverrideClipName
          if c55v19 == nil then
            __renovice_state_1 = 3
          else
            __renovice_state_1 = -1
          end
        end
        if __renovice_state_1 == 3 then
          if __renovice_local_0 == nil then
            __renovice_state_1 = 5
          else
            __renovice_state_1 = 4
          end
        end
        if __renovice_state_1 == 4 then
          c55v19 = c55v0.mMovie
          c55v22 = 0
          c55v19:SetNumberVariable(__renovice_local_0, c55v22, c55v0:CalculateX(c55v17))
          c55v19 = c55v0.mMovie
          c55v22 = 1
          c55v19:SetNumberVariable(__renovice_local_0, c55v22, c55v0:CalculateY(c55v17))
          __renovice_state_1 = 5
        end
        if __renovice_state_1 ~= 5 then
          c55v19 = true
          c55v20 = c55v17.mClipName
          if c55v20 == __renovice_local_0 then
            c55v19 = c55v17.mForceRedraw
            if not c55v19 then
              c55v19 = c55v2
              if not c55v19 then
                if c55v9 ~= nil then
                  c55v19 = false
                else
                  c55v19 = true
                end
              end
            end
          end
          c55v11 = c55v19
          c55v19 = c55v17.mClipName
          if c55v19 then
            c55v19 = c55v17.mClipName
            if __renovice_local_0 ~= c55v19 then
              c55v19 = c55v0.mClips
              c55v20 = c55v17.mClipName
              c55v21 = false
              c55v19[c55v20] = c55v21
              if __renovice_local_0 == nil then
                c55v19 = c55v0.mMovie
                c55v21 = c55v17.mClipName
                c55v19:Name__6fdbb52c(c55v21)
                c55v19 = c55v0.mMovie
                c55v21 = c55v17.mClipName
                c55v22 = 12
                c55v23 = 0
                c55v19:SetNumberVariable(c55v21, c55v22, c55v23)
                c55v19 = c55v0.mMovie
                c55v21 = c55v17.mClipName
                c55v22 = 67
                c55v23 = false
                c55v19:Name__863e56e7(c55v21, c55v22, c55v23)
                c55v19 = false
                c55v17.mClipEnabled = c55v19
              end
            end
          end
          c55v17.mClipName = __renovice_local_0
          c55v19 = false
          c55v17.mForceRedraw = c55v19
          c55v19 = IsNull
          c55v19 = c55v19(__renovice_local_0)
          if not c55v19 then
            c55v19 = c55v0.mMovie
            c55v19 = c55v19:HasVariable(__renovice_local_0)
            if not c55v19 then
              c55v19 = StringSplit
              c55v20 = "."
              c55v19 = c55v19(c55v20, __renovice_local_0)
              c55v20 = FlashMethod
              c55v21 = c55v0.mMovie
              c55v23 = c55v0.mClipName
              c55v24 = ".duplicateMovieClip"
              c55v22 = c55v23 .. c55v24
              c55v24 = #c55v19
              c55v23 = c55v19[c55v24]
              c55v25 = c55v0.mInitialDepth
              c55v27 = c55v0.mTopClipIndexUsed
              c55v28 = c55v0.mDepthDirection
              c55v26 = c55v27 * c55v28
              c55v24 = c55v25 + c55v26
              c55v20(c55v21, c55v22, c55v23, c55v24)
              c55v20 = c55v0.mClipCreatedCallback
              if c55v20 ~= nil then
                c55v20 = c55v0.mClipCreatedCallback
                c55v20(__renovice_local_0, c55v17)
              end
              if not c55v2 then
                c55v0:SetClipCallbacks(__renovice_local_0)
              end
            end
            if c55v2 then
              c55v0:SetClipCallbacks(__renovice_local_0)
            end
            c55v19 = c55v17.mClipEnabled
            if not c55v19 then
              c55v19 = c55v0.mMovie
              c55v21 = c55v17.mClipName
              c55v22 = 67
              c55v23 = true
              c55v19:Name__863e56e7(c55v21, c55v22, c55v23)
              c55v19 = true
              c55v17.mClipEnabled = c55v19
            end
            c55v19 = c55v0.mMovie
            c55v22 = "Id"
            c55v23 = c55v17.Id
            c55v19:SetVariable(__renovice_local_0, c55v22, c55v23)
            c55v19 = c55v0.mMovie
            c55v23 = ".Btn"
            c55v21 = __renovice_local_0 .. c55v23
            c55v22 = 99
            c55v23 = c55v17.Id
            c55v19:SetNumberVariable(c55v21, c55v22, c55v23)
            c55v19 = c55v0.mMovie
            c55v22 = 0
            c55v19:SetNumberVariable(__renovice_local_0, c55v22, c55v0:CalculateX(c55v17))
            c55v19 = c55v0.mMovie
            c55v22 = 1
            c55v19:SetNumberVariable(__renovice_local_0, c55v22, c55v0:CalculateY(c55v17))
            c55v19 = c55v17.mInitialized
            if not c55v19 then
              c55v19 = c55v0.mMovie
              c55v22 = 12
              c55v23 = 1
              c55v19:SetNumberVariable(__renovice_local_0, c55v22, c55v23)
              c55v0:SetupPreInterpolationValues(c55v17)
            end
            c55v19 = c55v0.mElementDelayTime
            c55v4 = c55v4 + c55v19
            c55v19 = c55v0.UTIL
            c55v19 = c55v19.Ternary
            c55v22 = nil
            c55v19 = c55v19(c55v5, c55v1, c55v22)
            c55v20, c55v21 = c55v0:GetInterpolationProperties(c55v17)
            c55v0:OnElementTransitionStarted(c55v17)
            if not c55v3 then
              local __renovice_capture_54_1 = c55v17
              local __renovice_capture_54_2 = c55v19
              c55v22 = function()
                local c54v0, c54v1, c54v2
                c54v0 = c55v0
                c54v2 = __renovice_capture_54_1
                c54v0:OnElementTransitionEnded(c54v2)
                c54v1 = __renovice_capture_54_2
                c54v0 = IsNull
                c54v0 = c54v0(c54v1)
                if not c54v0 then
                  c54v0 = __renovice_capture_54_2
                  c54v0()
                end
                do return end
              end
              c55v23 = FlashInterpolate
              c55v24 = c55v0.mMovie
              c55v26 = c55v0.mEasing
              c55v23(c55v24, __renovice_local_0, c55v26, c55v20, c55v21, c55v6, c55v4, c55v22)
            else
              c55v24 = 1
              c55v22 = #c55v20
              c55v23 = 1
              for __renovice_for_2_0 = c55v24, c55v22, c55v23 do
                c55v25 = c55v0.mMovie
                c55v28 = c55v20[__renovice_for_2_0]
                c55v29 = c55v21[__renovice_for_2_0]
                c55v25:SetNumberVariable(__renovice_local_0, c55v28, c55v29)
              end
              c55v0:OnElementTransitionEnded(c55v17)
              c55v22 = IsNull
              c55v22 = c55v22(c55v19)
              if not c55v22 then
                c55v19()
              end
            end
            c55v0:OnDraw(c55v17, c55v11)
            c55v5 = false
          end
        end
        c55v19 = true
        c55v17.mInitialized = c55v19
      end
      if c55v10 then
        c55v14 = c55v0.mRedrawFromScrollBar
        if c55v14 then
          c55v14 = false
          c55v0.mRedrawFromScrollBar = c55v14
          do return end
        end
        c55v0:RedrawScrollBar()
      end
      do return end
    end
    c87v3.Redraw = c87v5
    c87v5 = function(c56v0, c56v1, c56v2)
      local c56v3, c56v4, c56v5, c56v6, c56v7
      c56v3 = Clamp
      c56v4 = 1
      c56v7 = c56v0.mElements
      c56v6 = #c56v7
      c56v7 = 1
      c56v5 = math.max
      c56v5 = c56v5(c56v6, c56v7)
      c56v3 = c56v3(c56v1, c56v4, c56v5)
      c56v0.mScroll = c56v3
      if not c56v2 then
        c56v0:Redraw()
      end
      do return end
    end
    c87v3.SetScroll = c87v5
    c87v5 = function(c57v0, c57v1)
      local c57v2, c57v3, c57v4, c57v5, c57v6, c57v7
      c57v2 = IsNull
      c57v2 = c57v2(c57v1)
      if not c57v2 then
        c57v4 = 1
        c57v5 = c57v0.mElements
        c57v2 = #c57v5
        c57v3 = 1
        for __renovice_for_0_0 = c57v4, c57v2, c57v3 do
          c57v5 = ResetLineCount
          c57v6 = 0
          c57v5(c57v6)
          c57v7 = c57v0.mElements
          c57v6 = c57v7[__renovice_for_0_0]
          c57v1(c57v6)
        end
      end
      do return end
    end
    c87v3.RunForAllElements = c87v5
    c87v5 = function(c58v0, c58v1, c58v2)
      local c58v3, c58v4, c58v5, c58v6, c58v7, c58v8, c58v9, c58v10
      c58v3 = 1
      c58v4 = nil
      if c58v2 then
        c58v3, c58v4 = c58v0:GetBounds()
        c58v8 = c58v0.mElements
        c58v7 = #c58v8
        c58v5 = math.min
        c58v4 = c58v5(c58v4, c58v7)
      else
        c58v5 = c58v0.mElements
        c58v4 = #c58v5
      end
      c58v7 = c58v3
      c58v5 = c58v4
      c58v6 = 1
      for __renovice_for_0_0 = c58v7, c58v5, c58v6 do
        c58v9 = c58v0.mElements
        c58v8 = c58v9[__renovice_for_0_0]
        c58v9 = c58v8.mClipName
        if c58v9 == nil then
          continue
        end
        c58v9 = ResetLineCount
        c58v10 = 0
        c58v9(c58v10)
        c58v1(c58v8)
      end
      do return end
    end
    c87v3._RunForAllVisibleElements = c87v5
    c87v5 = function(c59v0, c59v1, c59v2)
      local c59v3, c59v4
      c59v4 = c59v0.mScroll
      c59v3 = IsNull
      c59v3 = c59v3(c59v4)
      if c59v3 then
        c59v0:RunForAllElements(c59v1)
        do return end
      end
      c59v3 = IsNull
      c59v3 = c59v3(c59v1)
      if not c59v3 then
        c59v0:_RunForAllVisibleElements(c59v1, c59v2)
      end
      do return end
    end
    c87v3.RunForAllVisibleElements = c87v5
    c87v5 = function(c60v0, c60v1)
      local c60v2, c60v3, c60v4, c60v5
      c60v2 = c60v0.Height
      if c60v2 ~= nil then
        c60v2 = c60v0.Height
        do return c60v2 end
      end
      if not c60v1 then
        c60v1 = 0
      end
      c60v4 = c60v0.mVisibleElements
      c60v5 = c60v0.mForcedVerticalSeparation
      c60v3 = c60v4 * c60v5
      c60v2 = c60v3 + c60v1
      do return c60v2 end
    end
    c87v3.CalculateScrollBarHeight = c87v5
    c87v5 = function(c63v0, c63v1, c63v2)
      local c63v3, c63v4, c63v5, c63v6, c63v7, c63v8, c63v9
      local __renovice_state_0 = 0
      local __renovice_local_0 = c63v0:GetHowManyElements()
      c63v4 = c63v0.mVisibleElements
      c63v3 = __renovice_local_0 - c63v4
      __renovice_local_0 = c63v0.mSmoothScroll
      if __renovice_local_0 then
        __renovice_state_0 = 3
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c63v4 = Clamp
        c63v5 = c63v0.UTIL
        c63v5 = c63v5.Round
        c63v6 = c63v3 * c63v1
        c63v5 = c63v5(c63v6)
        c63v6 = 0
        c63v4 = c63v4(c63v5, c63v6, c63v3)
        __renovice_local_0 = c63v4 + 1
        c63v4 = c63v0.mScroll
        if __renovice_local_0 == c63v4 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        c63v7 = true
        c63v0:SetScroll(__renovice_local_0, c63v7)
        c63v4 = true
        c63v0.mRedrawFromScrollBar = c63v4
        c63v6 = nil
        c63v7 = false
        c63v8 = true
        c63v0:Redraw(c63v6, c63v7, c63v8)
        c63v6 = function(c61v0)
          local c61v1, c61v2, c61v3, c61v4
          c61v1 = c63v0
          c61v1 = c61v1.mMovie
          c61v2 = c61v0.mClipName
          c61v3 = 1
          c61v4 = c63v0
          c61v1:SetNumberVariable(c61v2, c61v3, c61v4:CalculateY(c61v0))
          c61v1 = c63v0
          c61v1:RepositionButton(c61v0)
          do return end
        end
        c63v0:RunForAllVisibleElements(c63v6)
        do return end
      end
      if __renovice_state_0 == 3 then
        c63v4 = Clamp
        c63v5 = c63v3 * c63v1
        c63v6 = 0
        c63v4 = c63v4(c63v5, c63v6, c63v3)
        __renovice_local_0 = c63v4 + 1
        c63v4 = c63v0.mScroll
        if __renovice_local_0 == c63v4 then
          __renovice_state_0 = 8
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c63v5 = math.floor
        c63v5 = c63v5(__renovice_local_0)
        c63v7 = c63v0.mScroll
        c63v6 = math.floor
        c63v6 = c63v6(c63v7)
        c63v4 = c63v5 - c63v6
        c63v8 = true
        c63v0:SetScroll(__renovice_local_0, c63v8)
        c63v5 = 1
        if c63v5 <= c63v4 then
          __renovice_state_0 = 6
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c63v5 = -1
        if not (c63v4 <= c63v5) then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        c63v5 = true
        c63v0.mRedrawFromScrollBar = c63v5
        c63v7 = nil
        c63v8 = false
        c63v9 = true
        c63v0:Redraw(c63v7, c63v8, c63v9)
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 7 then
        c63v7 = function(c62v0)
          local c62v1, c62v2, c62v3, c62v4
          c62v1 = c63v0
          c62v1 = c62v1.mMovie
          c62v2 = c62v0.mClipName
          c62v3 = 1
          c62v4 = c63v0
          c62v1:SetNumberVariable(c62v2, c62v3, c62v4:CalculateY(c62v0))
          c62v1 = c63v0
          c62v1:RepositionButton(c62v0)
          do return end
        end
        c63v0:RunForAllVisibleElements(c63v7)
        __renovice_state_0 = 8
      end
      if __renovice_state_0 == 8 then
        do return end
      end
      do return end
    end
    c87v3.ScrollValueChangedCallback = c87v5
    c87v5 = function(c64v0)
      local c64v1
      c64v1 = true
      do return c64v1 end
    end
    c87v3.CanUseScrollBar = c87v5
    c87v5 = function(c66v0, c66v1, c66v2, c66v3)
      local c66v4, c66v5, c66v6, c66v7, c66v8, c66v9, c66v10
      c66v0.mScrollBarClipName = c66v1
      c66v4 = c66v0.mScrollBarClipName
      if c66v4 ~= nil then
        c66v6 = 1
        c66v7 = true
        c66v0:SetScroll(c66v6, c66v7)
        c66v4 = c66v2 or 0
        c66v0.mDeltaScrollBarSize = c66v4
        c66v4 = require
        c66v5 = "EE.Interface.Components.ScrollBar"
        c66v4 = c66v4(c66v5)
        c66v5 = c66v4.CreateScrollBar
        c66v6 = c66v0.mMovie
        c66v7 = c66v0.mScrollBarClipName
        c66v10 = c66v0.mDeltaScrollBarSize
        c66v8 = c66v0:CalculateScrollBarHeight(c66v10)
        c66v9 = 0.5
        c66v5 = c66v5(c66v6, c66v7, c66v8, c66v9, c66v3)
        c66v0.mScrollBar = c66v5
        c66v5 = c66v0.mMovie
        c66v7 = c66v0.mScrollBarClipName
        c66v8 = 13
        c66v9 = false
        c66v5:Name__863e56e7(c66v7, c66v8, c66v9)
        c66v5 = c66v0.mScrollBar
        c66v6 = function(c65v0, c65v1)
          local c65v2
          c65v2 = c66v0
          c65v2:ScrollValueChangedCallback(c65v0, c65v1)
          do return end
        end
        c66v5.mScrollValueChangedCallback = c66v6
        c66v5 = c66v0.mScrollBar
        c66v5:HookUpCallbacks()
        c66v5 = c66v0.mScrollBar
        c66v5:Initialize()
        c66v0:EnableDragScrolling(c66v3)
      end
      do return end
    end
    c87v3.AttachScrollBar = c87v5
    c87v5 = function(c67v0)
      local c67v1, c67v2, c67v3, c67v4, c67v5, c67v6, c67v7, c67v8, c67v9
      c67v1 = c67v0.mScrollBarClipName
      if c67v1 ~= nil then
        c67v1 = c67v0.mScrollBar
        if c67v1 ~= nil then
          c67v1 = c67v0.mScrollBar
          c67v1 = c67v1.mDragging
          if not c67v1 then
            c67v1 = c67v0:GetHowManyElements()
            c67v2 = c67v0:GetHowManyVisibleElements()
            c67v3 = false
            if c67v2 < c67v1 then
              c67v3 = c67v0:CanUseScrollBar()
            end
            c67v4 = c67v0.mMovie
            c67v6 = c67v0.mScrollBarClipName
            c67v7 = 13
            c67v9 = c67v0.mScrollAlwaysVisible
            c67v8 = c67v9 or c67v3
            c67v4:Name__863e56e7(c67v6, c67v7, c67v8)
            c67v4 = c67v0.mMovie
            c67v6 = c67v0.mScrollBarClipName
            c67v7 = "Scrub"
            c67v8 = 13
            c67v4:Name__e375fc94(c67v6, c67v7, c67v8, c67v3)
            c67v4 = c67v0.mScrollBar
            c67v4:SetEnabled(c67v3)
            if c67v3 then
              c67v5 = c67v0:GetHowManyElements()
              c67v6 = c67v0.mVisibleElements
              c67v4 = c67v5 - c67v6
              if c67v1 ~= 0 then
                c67v5 = c67v0.mScrollBar
                c67v7 = c67v0.mVisibleElements
                c67v6 = c67v7 / c67v1
                c67v5.mVisibleProp = c67v6
              end
              if c67v4 ~= 0 then
                c67v5 = c67v0.mScrollBar
                c67v8 = c67v0.mScroll
                c67v7 = c67v8 - 1
                c67v6 = c67v7 / c67v4
                c67v5.mCurrentScroll = c67v6
              end
              c67v5 = c67v0.mScrollBar
              c67v9 = c67v0.mDeltaScrollBarSize
              c67v7 = c67v0:CalculateScrollBarHeight(c67v9)
              c67v8 = true
              c67v5:SetHeight(c67v7, c67v8)
              c67v6 = c67v0.mVisibleElements
              c67v5 = c67v1 - c67v6
              if c67v5 ~= 0 then
                c67v6 = c67v0.mScrollBar
                c67v7 = 1 / c67v5
                c67v6.mScrollStep = c67v7
              end
            end
          end
        end
      end
      do return end
    end
    c87v3.RedrawScrollBar = c87v5
    c87v5 = function(c70v0, c70v1, c70v2, c70v3, c70v4, c70v5, c70v6, c70v7)
      local c70v8, c70v9, c70v10, c70v11, c70v12, c70v13
      if (c70v1 ~= nil and c70v2 ~= nil) then
        c70v8 = require
        c70v9 = "EE.Interface.Components.ListContainer"
        c70v8 = c70v8(c70v9)
        c70v9 = c70v8.CreateListContainer
        c70v10 = c70v0.mMovie
        c70v9 = c70v9(c70v10, c70v1, c70v2, c70v3, c70v4, c70v5, c70v6, c70v7)
        c70v0.mListContainer = c70v9
        c70v9 = c70v0.mMovie
        c70v13 = "."
        c70v11 = c70v1 .. c70v13 .. c70v2
        c70v12 = 13
        c70v13 = true
        c70v9:Name__863e56e7(c70v11, c70v12, c70v13)
        c70v9 = c70v0.mListContainer
        c70v9:HookUpCallbacks()
        c70v9 = c70v0.mListContainer
        c70v9:Initialize()
        c70v9 = c70v0.mListContainer
        c70v10 = function()
          local c68v0, c68v1
          c68v0 = c70v0
          c68v1 = nil
          c68v0:StartScrollDrag(c68v1)
          do return end
        end
        c70v9.mStartDragCallback = c70v10
        c70v9 = c70v0.mListContainer
        c70v10 = function()
          local c69v0
          c69v0 = c70v0
          c69v0:StopScrollDrag()
          do return end
        end
        c70v9.mStopDragCallback = c70v10
      end
      do return end
    end
    c87v3.AttachListContainer = c87v5
    c87v5 = function(c71v0)
      local c71v1, c71v2
      c71v1 = c71v0.mScroll
      if c71v1 ~= nil then
        c71v1 = c71v0.mForcedVerticalSeparation
        if c71v1 ~= nil then
          c71v1 = true
          c71v0.mSmoothScroll = c71v1
          c71v1 = c71v0.mScrollBar
          c71v2 = true
          c71v1.mEnableSmoothScroll = c71v2
          do return end
        end
      end
      c71v1 = print
      c71v2 = "Error: Smooth scroll dependencies failed!"
      c71v1(c71v2)
      c71v2 = false
      c71v1 = assert
      c71v1(c71v2)
      do return end
    end
    c87v3.EnableSmoothScroll = c87v5
    c87v5 = function(c72v0)
      local c72v1, c72v2, c72v3, c72v4, c72v5
      c72v1 = c72v0.mClickDrag
      c72v2 = nil
      c72v1.DragId = c72v2
      c72v1 = c72v0.mMovie
      c72v3 = c72v0.mClickDrag
      c72v3 = c72v3.DragClipName
      c72v4 = 13
      c72v5 = false
      c72v1:Name__863e56e7(c72v3, c72v4, c72v5)
      c72v1 = c72v0.mClickDrag
      c72v2 = false
      c72v1.Dragging = c72v2
      c72v1 = c72v0.mClickDrag
      c72v2 = nil
      c72v1.FocusedIndex = c72v2
      c72v1 = c72v0.mClickDrag
      c72v2 = nil
      c72v1.DragIndex = c72v2
      c72v2 = c72v0.mOnDragEndCallback
      c72v1 = IsNull
      c72v1 = c72v1(c72v2)
      if not c72v1 then
        c72v0:mOnDragEndCallback()
      end
      do return end
    end
    c87v3.StopDragging = c87v5
    c87v5 = function(c73v0)
      local c73v1, c73v2, c73v3, c73v4, c73v5, c73v6, c73v7, c73v8, c73v9
      c73v1 = { Enabled = true, Dragging = false, DistThresh = 20 }
      c73v0.mClickDrag = c73v1
      c73v1 = Engine.IsMobile
      c73v1 = c73v1()
      if c73v1 then
        c73v1 = c73v0.mClickDrag
        c73v2 = 5
        c73v1.DistThresh = c73v2
      end
      c73v1 = StringSplit
      c73v2 = "."
      c73v3 = c73v0.mClipName
      c73v1 = c73v1(c73v2, c73v3)
      c73v2 = c73v0.mClickDrag
      c73v3 = ""
      c73v2.RootClip = c73v3
      c73v2 = #c73v1
      c73v3 = 1
      if c73v3 < c73v2 then
        c73v3 = #c73v1
        c73v2 = c73v3 - 1
        c73v5 = 1
        c73v3 = c73v2
        c73v4 = 1
        for __renovice_for_0_0 = c73v5, c73v3, c73v4 do
          c73v6 = c73v0.mClickDrag
          c73v8 = c73v0.mClickDrag
          c73v8 = c73v8.RootClip
          c73v9 = c73v1[__renovice_for_0_0]
          c73v7 = c73v8 .. c73v9
          c73v6.RootClip = c73v7
          if __renovice_for_0_0 == c73v2 then
            continue
          end
          c73v6 = c73v0.mClickDrag
          c73v8 = c73v0.mClickDrag
          c73v8 = c73v8.RootClip
          c73v9 = "."
          c73v7 = c73v8 .. c73v9
          c73v6.RootClip = c73v7
        end
      end
      c73v2 = c73v0.mClickDrag
      c73v4 = c73v0.mClipName
      c73v5 = "Drag"
      c73v3 = c73v4 .. c73v5
      c73v2.DragClipName = c73v3
      do return end
    end
    c87v3.EnableDrag = c87v5
    c87v5 = function(c74v0)
      local c74v1, c74v2, c74v3, c74v4, c74v5, c74v6, c74v7, c74v8, c74v9, c74v10, c74v11, c74v12
      c74v1 = c74v0.DragElement
      if c74v1 then
        c74v1 = c74v0.mClickDrag
        c74v3 = c74v0.DragElement
        c74v4 = "Drag"
        c74v2 = c74v3 .. c74v4
        c74v1.DragClipName = c74v2
      end
      c74v1 = c74v0.mMovie
      c74v3 = c74v0.mClickDrag
      c74v3 = c74v3.DragClipName
      c74v1 = c74v1:HasVariable(c74v3)
      if not c74v1 then
        c74v1 = StringSplit
        c74v2 = "."
        c74v3 = c74v0.mClipName
        c74v1 = c74v1(c74v2, c74v3)
        c74v3 = c74v0.mTopClipIndexUsed
        c74v2 = c74v3 + 1
        c74v0.mTopClipIndexUsed = c74v2
        c74v2 = c74v0.mClipName
        c74v4 = #c74v1
        c74v3 = c74v1[c74v4]
        c74v4 = c74v0.DragElement
        if c74v4 then
          c74v2 = c74v0.DragElement
          c74v4 = StringSplit
          c74v5 = "."
          c74v6 = c74v0.DragElement
          c74v4 = c74v4(c74v5, c74v6)
          c74v5 = #c74v4
          c74v3 = c74v4[c74v5]
        end
        c74v4 = FlashMethod
        c74v5 = c74v0.mMovie
        c74v8 = ".duplicateMovieClip"
        c74v6 = c74v2 .. c74v8
        c74v9 = "Drag"
        c74v7 = c74v3 .. c74v9
        c74v9 = c74v0.mInitialDepth
        c74v11 = c74v0.mTopClipIndexUsed
        c74v12 = c74v0.mDepthDirection
        c74v10 = c74v11 * c74v12
        c74v8 = c74v9 + c74v10
        c74v4(c74v5, c74v6, c74v7, c74v8)
      end
      c74v3 = c74v0.mClickDrag
      c74v3 = c74v3.DragId
      c74v1 = c74v0:GetElementById(c74v3)
      c74v2 = c74v1.mClipName
      c74v3 = c74v0.mClickDrag
      c74v3 = c74v3.DragClipName
      c74v1.mClipName = c74v3
      c74v4 = c74v0.mClipCreatedCallback
      c74v3 = IsNull
      c74v3 = c74v3(c74v4)
      if not c74v3 then
        c74v3 = c74v0.mClipCreatedCallback
        c74v4 = c74v1.mClipName
        c74v3(c74v4)
      end
      c74v4 = c74v0.mElementDrawCallback
      c74v3 = IsNull
      c74v3 = c74v3(c74v4)
      if not c74v3 then
        c74v3 = c74v0.mElementDrawCallback
        c74v3(c74v1)
      end
      c74v1.mClipName = c74v2
      c74v3 = c74v0.mMovie
      c74v5 = c74v0.mClickDrag
      c74v5 = c74v5.DragClipName
      c74v6 = 13
      c74v7 = true
      c74v3:Name__863e56e7(c74v5, c74v6, c74v7)
      c74v3 = c74v0.mMovie
      c74v5 = c74v0.mClickDrag
      c74v5 = c74v5.DragClipName
      c74v6 = 12
      c74v8 = c74v0.mDragAlpha
      if c74v8 ~= nil then
        c74v7 = c74v0.mDragAlpha
      else
        c74v7 = 60
      end
      c74v3:SetNumberVariable(c74v5, c74v6, c74v7)
      c74v3 = c74v0.mMovie
      c74v6 = c74v0.mClickDrag
      c74v6 = c74v6.DragClipName
      c74v7 = "Btn"
      c74v5 = c74v6 .. c74v7
      c74v6 = 67
      c74v7 = false
      c74v3:Name__863e56e7(c74v5, c74v6, c74v7)
      c74v3 = c74v0.mClickDrag
      c74v4 = true
      c74v3.Dragging = c74v4
      c74v3 = c74v0.UTIL
      c74v3 = c74v3.PlaySound
      c74v4 = _G
      c74v4 = c74v4.UISound_StartDrag
      c74v3(c74v4)
      do return end
    end
    c87v3.CreateDragClip = c87v5
    c87v5 = function(c76v0)
      local c76v1, c76v2, c76v3, c76v4, c76v5, c76v6, c76v7, c76v8, c76v9, c76v10, c76v11
      local __renovice_state_0 = 0
      c76v1 = Vector
      c76v2 = c76v0.mMovie
      c76v4 = "_root"
      c76v5 = 30
      c76v2 = c76v2:GetNumberVariable(c76v4, c76v5)
      c76v3 = c76v0.mMovie
      c76v5 = "_root"
      c76v6 = 31
      c76v3 = c76v3:GetNumberVariable(c76v5, c76v6)
      c76v4 = 0
      c76v1 = c76v1(c76v2, c76v3, c76v4)
      c76v2 = c76v0.mClickDrag
      c76v2 = c76v2.Dragging
      if c76v2 then
        __renovice_state_0 = 9
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c76v2 = Distance
        c76v4 = c76v0.mClickDrag
        c76v4 = c76v4.InitDownPos
        c76v2 = c76v2(c76v1, c76v4)
        c76v3 = c76v0.mClickDrag
        c76v3 = c76v3.DistThresh
        if not (c76v3 < c76v2) then
          __renovice_state_0 = 9
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        c76v4 = c76v0.mClickDrag
        c76v4 = c76v4.DragId
        c76v2 = c76v0:GetElementById(c76v4)
        if not c76v2 then
          __renovice_state_0 = 6
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        c76v3 = c76v2.DisableDrag
        if c76v3 == nil then
          __renovice_state_0 = 5
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c76v3 = c76v2.DisableDrag
        if c76v3 then
          __renovice_state_0 = 6
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c76v0:CreateDragClip()
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 6 then
        c76v3 = c76v0.mClickDrag
        c76v4 = nil
        c76v3.DragId = c76v4
        c76v3 = c76v0.mClickDrag
        c76v4 = nil
        c76v3.DragIndex = c76v4
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 7 then
        if not c76v2 then
          __renovice_state_0 = 9
        else
          __renovice_state_0 = 8
        end
      end
      if __renovice_state_0 == 8 then
        c76v5 = c76v2.Id
        c76v0:UnfocusElementById(c76v5)
        __renovice_state_0 = 9
      end
      if __renovice_state_0 == 9 then
        c76v2 = c76v0.mClickDrag
        c76v2 = c76v2.Dragging
        if not c76v2 then
          __renovice_state_0 = 24
        else
          __renovice_state_0 = 10
        end
      end
      if __renovice_state_0 == 10 then
        c76v2 = c76v1.x
        c76v3 = c76v1.y
        c76v4 = c76v0.mClickDrag
        c76v4 = c76v4.RootClip
        if c76v4 == "" then
          __renovice_state_0 = 12
        else
          __renovice_state_0 = 11
        end
      end
      if __renovice_state_0 == 11 then
        c76v4 = c76v0.UTIL
        c76v4 = c76v4.GetRootBasedPosition
        c76v5 = c76v0.mMovie
        c76v6 = c76v0.mClickDrag
        c76v6 = c76v6.RootClip
        c76v4, c76v5 = c76v4(c76v5, c76v6)
        c76v2 = c76v2 - c76v4
        c76v3 = c76v3 - c76v5
        __renovice_state_0 = 12
      end
      if __renovice_state_0 == 12 then
        c76v4 = c76v2
        c76v5 = c76v3
        c76v6 = c76v0.DragRootOverride
        if c76v6 == nil then
          __renovice_state_0 = 14
        else
          __renovice_state_0 = 13
        end
      end
      if __renovice_state_0 == 13 then
        c76v6 = c76v0.UTIL
        c76v6 = c76v6.GetRootBasedPosition
        c76v7 = c76v0.mMovie
        c76v8 = c76v0.DragRootOverride
        c76v6, c76v7 = c76v6(c76v7, c76v8)
        c76v8 = c76v1.x
        c76v4 = c76v8 - c76v6
        c76v8 = c76v1.y
        c76v5 = c76v8 - c76v7
        __renovice_state_0 = 14
      end
      if __renovice_state_0 == 14 then
        c76v6 = c76v0.mMovie
        c76v8 = c76v0.mClickDrag
        c76v8 = c76v8.DragClipName
        c76v9 = 0
        c76v6:SetNumberVariable(c76v8, c76v9, c76v4)
        c76v6 = c76v0.mMovie
        c76v8 = c76v0.mClickDrag
        c76v8 = c76v8.DragClipName
        c76v9 = 1
        c76v6:SetNumberVariable(c76v8, c76v9, c76v5)
        c76v6 = Vector
        c76v9 = 0
        c76v6 = c76v6(c76v2, c76v3, c76v9)
        c76v7 = nil
        c76v8 = 0
        c76v11 = function(c75v0)
          local c75v1, c75v2, c75v3, c75v4, c75v5, c75v6, c75v7
          local __renovice_state_0 = 0
          c75v1 = 0
          c75v2 = 0
          c75v3 = c76v0
          c75v3 = c75v3.mGetElementCenter
          if c75v3 == nil then
            __renovice_state_0 = 2
          else
            __renovice_state_0 = 1
          end
          if __renovice_state_0 == 1 then
            c75v3 = c76v0
            c75v3 = c75v3.mGetElementCenter
            c75v1, c75v2 = c75v3(c75v0)
            __renovice_state_0 = 3
          end
          if __renovice_state_0 == 2 then
            c75v3 = c76v0
            c75v3 = c75v3.mMovie
            c75v5 = c75v0.mClipName
            c75v6 = 0
            c75v1 = c75v3:GetNumberVariable(c75v5, c75v6)
            c75v3 = c76v0
            c75v3 = c75v3.mMovie
            c75v5 = c75v0.mClipName
            c75v6 = 1
            c75v2 = c75v3:GetNumberVariable(c75v5, c75v6)
            __renovice_state_0 = 3
          end
          if __renovice_state_0 == 3 then
            c75v3 = Distance
            c75v4 = Vector
            c75v7 = 0
            c75v4 = c75v4(c75v1, c75v2, c75v7)
            c75v5 = c76v6
            c75v3 = c75v3(c75v4, c75v5)
            c75v4 = c76v7
            if c75v4 == nil then
              __renovice_state_0 = 5
            else
              __renovice_state_0 = 4
            end
          end
          if __renovice_state_0 == 4 then
            c75v4 = c76v8
            if not (c75v3 < c75v4) then
              __renovice_state_0 = 6
            else
              __renovice_state_0 = 5
            end
          end
          if __renovice_state_0 == 5 then
            c75v4 = c75v0.mIndex
            c76v7 = c75v4
            c76v8 = c75v3
            __renovice_state_0 = 6
          end
          if __renovice_state_0 == 6 then
            do return end
          end
          do return end
        end
        c76v0:RunForAllVisibleElements(c76v11)
        c76v9 = c76v0.mClickDrag
        c76v9 = c76v9.FocusedIndex
        if c76v9 == nil then
          __renovice_state_0 = 16
        else
          __renovice_state_0 = 15
        end
      end
      if __renovice_state_0 == 15 then
        c76v9 = c76v0.mClickDrag
        c76v9 = c76v9.FocusedIndex
        if c76v7 == c76v9 then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 16
        end
      end
      if __renovice_state_0 == 16 then
        c76v9 = c76v0.mClickDrag
        c76v9 = c76v9.FocusedIndex
        if c76v9 == nil then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 17
        end
      end
      if __renovice_state_0 == 17 then
        c76v9 = c76v0.mOnDragUnfocusedCallback
        if c76v9 == nil then
          __renovice_state_0 = 19
        else
          __renovice_state_0 = 18
        end
      end
      if __renovice_state_0 == 18 then
        c76v11 = c76v0.mClickDrag
        c76v11 = c76v11.FocusedIndex
        c76v9 = c76v0:GetElementInIndex(c76v11)
        c76v10 = c76v0.mOnDragUnfocusedCallback
        c76v10(c76v9)
        __renovice_state_0 = 19
      end
      if __renovice_state_0 == 19 then
        c76v9 = c76v0.mClickDrag
        c76v9 = c76v9.DragIndex
        if c76v7 == c76v9 then
          __renovice_state_0 = 22
        else
          __renovice_state_0 = 20
        end
      end
      if __renovice_state_0 == 20 then
        c76v9 = c76v0.mClickDrag
        c76v9.FocusedIndex = c76v7
        c76v9 = c76v0.mOnDragFocusedCallback
        if c76v9 == nil then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 21
        end
      end
      if __renovice_state_0 == 21 then
        c76v11 = c76v0.mClickDrag
        c76v11 = c76v11.FocusedIndex
        c76v9 = c76v0:GetElementInIndex(c76v11)
        c76v10 = c76v0.mOnDragFocusedCallback
        c76v10(c76v9)
        __renovice_state_0 = 23
      end
      if __renovice_state_0 == 22 then
        c76v9 = c76v0.mClickDrag
        c76v10 = nil
        c76v9.FocusedIndex = c76v10
        __renovice_state_0 = 23
      end
      if __renovice_state_0 == 23 then
        __renovice_state_0 = 24
      end
      if __renovice_state_0 == 24 then
        do return end
      end
      do return end
    end
    c87v3.UpdateDrag = c87v5
    c87v5 = function(c79v0, c79v1)
      local c79v2
      c79v2 = Engine.IsMobile
      c79v2 = c79v2()
      if not c79v2 then
        do return end
      end
      c79v2 = { Enabled = true, isPressed = false, isDragging = false, isStopping = false, ignoreDrag = false, isHorizontal = nil, DistThresh = 5, Sensitivity = 1 }
      c79v2.isHorizontal = c79v1
      c79v0.mScrollDrag = c79v2
      c79v2 = function(c77v0)
        local c77v1
        c77v1 = 1
        do return c77v1 end
      end
      c79v0.GetDragScrollIncrement = c79v2
      c79v2 = function(c78v0)
        local c78v1, c78v2, c78v3, c78v4, c78v5
        c78v1 = 0
        c78v3 = c78v0.mForcedVerticalSeparation
        c78v2 = IsNull
        c78v2 = c78v2(c78v3)
        if not c78v2 then
          c78v1 = c78v0.mForcedVerticalSeparation
          do return c78v1 end
        end
        c78v2 = c78v0.mMovie
        c78v4 = c78v0.mClipName
        c78v5 = 15
        c78v1 = c78v2:GetNumberVariable(c78v4, c78v5)
        do return c78v1 end
      end
      c79v0.GetMouseDragScrollStep = c79v2
      do return end
    end
    c87v3.EnableDragScrolling = c87v5
    c87v5 = function(c82v0, c82v1, c82v2, c82v3, c82v4)
      local c82v5, c82v6, c82v7, c82v8, c82v9, c82v10, c82v11, c82v12, c82v13
      c82v5 = function(c80v0, c80v1)
        local c80v2, c80v3, c80v4
        c80v3 = c80v0 * c80v0
        c80v4 = c80v1 * c80v1
        c80v2 = c80v3 + c80v4
        do return c80v2 end
      end
      c82v6 = function(c81v0)
        local c81v1, c81v2
        c81v2 = c81v0 * 180
        c81v1 = c81v2 / 3.141592653589793
        do return c81v1 end
      end
      c82v9 = c82v2.x
      c82v10 = c82v1.x
      c82v7 = c82v9 - c82v10
      c82v9 = c82v2.y
      c82v10 = c82v1.y
      c82v8 = c82v9 - c82v10
      c82v10 = c82v7 * c82v7
      c82v11 = c82v8 * c82v8
      c82v9 = c82v10 + c82v11
      c82v10 = c82v3 * c82v3
      if c82v9 < c82v10 then
        c82v9 = c82v0.MOVE_NONE
        do return c82v9 end
      end
      c82v11 = math.abs
      c82v9 = c82v11(c82v7)
      c82v10 = math.abs
      c82v10 = c82v10(c82v8)
      c82v12 = math.atan2
      c82v12 = c82v12(c82v10, c82v9)
      c82v13 = c82v12 * 180
      c82v11 = c82v13 / 3.141592653589793
      if c82v11 <= c82v4 then
        c82v12 = c82v0.MOVE_HORIZONTAL
        do return c82v12 end
      end
      c82v12 = 90 - c82v4
      if c82v12 <= c82v11 then
        c82v12 = c82v0.MOVE_VERTICAL
        do return c82v12 end
      end
      c82v12 = c82v0.MOVE_NONE
      do return c82v12 end
    end
    c87v3.GetTouchMoveDirection = c87v5
    c87v5 = function(c83v0, c83v1, c83v2)
      local c83v3, c83v4, c83v5, c83v6, c83v7
      c83v3 = false
      c83v4 = c83v0.mScrollDrag
      c83v4 = c83v4.Enabled
      if c83v4 then
        c83v3 = c83v0:UpdateScrollDrag(c83v2)
      end
      if not c83v3 then
        c83v4 = c83v0.mClickDrag
        c83v4 = c83v4.Enabled
        if c83v4 then
          c83v4 = c83v0.mClickDrag
          c83v4 = c83v4.DragId
          if c83v4 ~= nil then
            c83v0:UpdateDrag()
          end
        end
      end
      c83v4 = c83v0.mRedrawElementIndex
      if c83v4 ~= nil then
        c83v5 = c83v0.mRedrawCachedParams
        c83v5 = c83v5.Callback
        c83v6 = c83v0.mRedrawCachedParams
        c83v6 = c83v6.ForceUpdate
        c83v7 = c83v0.mRedrawCachedParams
        c83v7 = c83v7.InstantDraw
        c83v0:Redraw(c83v5, c83v6, c83v7)
      end
      do return c83v3 end
    end
    c87v3.Update = c87v5
    c87v5 = function(c84v0, c84v1)
      local c84v2, c84v3, c84v4, c84v5, c84v6, c84v7, c84v8, c84v9, c84v10
      c84v2 = c84v0.mScrollDrag
      c84v2 = c84v2.Enabled
      if c84v2 then
        c84v2 = c84v0:GetElementIndexById(c84v1)
        c84v3 = nil
        c84v4 = IsNull
        c84v4 = c84v4(c84v2)
        if not c84v4 then
          c84v5 = c84v0.mElements
          c84v4 = c84v5[c84v2]
          if c84v4 ~= nil then
            c84v5 = c84v0.mMovie
            c84v7 = c84v4.mClipName
            c84v8 = 23
            c84v3 = c84v5:GetStringVariable(c84v7, c84v8)
          end
        end
        if c84v3 ~= nil then
          c84v4 = c84v0.mMovie
          c84v4 = c84v4:GetFocusParent()
          if c84v4 ~= c84v3 then
            c84v4 = c84v0.mScrollDrag
            c84v5 = true
            c84v4.ignoreDrag = c84v5
          end
        end
        c84v4 = c84v0.mScrollDrag
        c84v5 = true
        c84v4.isPressed = c84v5
        c84v4 = c84v0.mScrollDrag
        c84v5 = false
        c84v4.isStopping = c84v5
        c84v4 = c84v0.mScrollDrag
        c84v5 = Vector
        c84v6 = c84v0.mMovie
        c84v8 = "_root"
        c84v9 = 30
        c84v6 = c84v6:GetNumberVariable(c84v8, c84v9)
        c84v7 = c84v0.mMovie
        c84v9 = "_root"
        c84v10 = 31
        c84v7 = c84v7:GetNumberVariable(c84v9, c84v10)
        c84v8 = 0
        c84v5 = c84v5(c84v6, c84v7, c84v8)
        c84v4.InitDownPos = c84v5
      end
      do return end
    end
    c87v3.StartScrollDrag = c87v5
    c87v5 = function(c85v0)
      local c85v1, c85v2
      c85v1 = c85v0.mScrollDrag
      c85v2 = false
      c85v1.isPressed = c85v2
      c85v1 = c85v0.mScrollDrag
      c85v1 = c85v1.Enabled
      if c85v1 then
        c85v1 = c85v0.mScrollDrag
        c85v1 = c85v1.isDragging
        if c85v1 then
          c85v1 = c85v0.mScrollDrag
          c85v2 = false
          c85v1.isDragging = c85v2
          c85v1 = c85v0.mScrollDrag
          c85v2 = true
          c85v1.isStopping = c85v2
          c85v1 = c85v0.mScrollDrag
          c85v2 = false
          c85v1.ignoreDrag = c85v2
        end
      end
      do return end
    end
    c87v3.StopScrollDrag = c87v5
    c87v5 = function(c86v0, c86v1)
      local c86v2, c86v3, c86v4, c86v5, c86v6, c86v7, c86v8, c86v9, c86v10, c86v11, c86v12, c86v13, c86v14, c86v15, c86v16
      local __renovice_state_0 = 0
      c86v2 = c86v0.mScrollDrag
      c86v2 = c86v2.Enabled
      if not c86v2 then
        __renovice_state_0 = 31
      else
        __renovice_state_0 = 1
      end
      if __renovice_state_0 == 1 then
        c86v2 = c86v0.mScrollDrag
        c86v2 = c86v2.isPressed
        if not c86v2 then
          __renovice_state_0 = 31
        else
          __renovice_state_0 = 2
        end
      end
      if __renovice_state_0 == 2 then
        c86v2 = Vector
        c86v3 = c86v0.mMovie
        c86v5 = "_root"
        c86v6 = 30
        c86v3 = c86v3:GetNumberVariable(c86v5, c86v6)
        c86v4 = c86v0.mMovie
        c86v6 = "_root"
        c86v7 = 31
        c86v4 = c86v4:GetNumberVariable(c86v6, c86v7)
        c86v5 = 0
        c86v2 = c86v2(c86v3, c86v4, c86v5)
        c86v3 = c86v0.mScrollDrag
        c86v3 = c86v3.isDragging
        if not c86v3 then
          __renovice_state_0 = 24
        else
          __renovice_state_0 = 3
        end
      end
      if __renovice_state_0 == 3 then
        c86v3 = c86v0.mScrollDrag
        c86v3 = c86v3.ignoreDrag
        if c86v3 then
          __renovice_state_0 = 24
        else
          __renovice_state_0 = 4
        end
      end
      if __renovice_state_0 == 4 then
        c86v3 = c86v0.UTIL
        c86v3 = c86v3.Ternary
        c86v6 = c86v0.mScrollBar
        c86v5 = IsNull
        c86v5 = c86v5(c86v6)
        c86v4 = not c86v5
        c86v5 = c86v0.mScrollBar
        c86v3 = c86v3(c86v4, c86v5, c86v1)
        if not c86v3 then
          __renovice_state_0 = 12
        else
          __renovice_state_0 = 5
        end
      end
      if __renovice_state_0 == 5 then
        c86v4 = Vector
        c86v5 = c86v0.mMovie
        c86v7 = "_root"
        c86v8 = 30
        c86v5 = c86v5:GetNumberVariable(c86v7, c86v8)
        c86v6 = c86v0.mMovie
        c86v8 = "_root"
        c86v9 = 31
        c86v6 = c86v6:GetNumberVariable(c86v8, c86v9)
        c86v7 = 0
        c86v4 = c86v4(c86v5, c86v6, c86v7)
        c86v5 = c86v4.y
        c86v6 = c86v0.mScrollDrag
        c86v6 = c86v6.InitDownPos
        c86v6 = c86v6.y
        c86v7 = c86v0.mScrollDrag
        c86v7 = c86v7.isHorizontal
        if not c86v7 then
          __renovice_state_0 = 7
        else
          __renovice_state_0 = 6
        end
      end
      if __renovice_state_0 == 6 then
        c86v5 = c86v4.x
        c86v7 = c86v0.mScrollDrag
        c86v7 = c86v7.InitDownPos
        c86v6 = c86v7.x
        __renovice_state_0 = 7
      end
      if __renovice_state_0 == 7 then
        c86v7 = 0
        if not (c86v7 < c86v5) then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 8
        end
      end
      if __renovice_state_0 == 8 then
        c86v9 = c86v5 - c86v6
        c86v8 = -c86v9
        c86v9 = c86v0.mScrollDrag
        c86v9 = c86v9.Sensitivity
        c86v7 = c86v8 * c86v9
        c86v8 = c86v0.mScrollDrag
        c86v8 = c86v8.isHorizontal
        if not c86v8 then
          __renovice_state_0 = 10
        else
          __renovice_state_0 = 9
        end
      end
      if __renovice_state_0 == 9 then
        c86v8 = c86v0.mScrollDrag
        c86v8 = c86v8.InitDownPos
        c86v8.x = c86v5
        __renovice_state_0 = 11
      end
      if __renovice_state_0 == 10 then
        c86v8 = c86v0.mScrollDrag
        c86v8 = c86v8.InitDownPos
        c86v8.y = c86v5
        __renovice_state_0 = 11
      end
      if __renovice_state_0 == 11 then
        c86v11 = c86v0:GetMouseDragScrollStep()
        c86v10 = c86v7 / c86v11
        c86v11 = c86v3.mScrollStep
        c86v9 = c86v10 * c86v11
        c86v10 = c86v0.mScrollDrag
        c86v10 = c86v10.Sensitivity
        c86v8 = c86v9 * c86v10
        c86v3:ScrollBy(c86v8)
        __renovice_state_0 = 23
      end
      if __renovice_state_0 == 12 then
        c86v4 = c86v2.y
        c86v5 = c86v0.mScrollDrag
        c86v5 = c86v5.InitDownPos
        c86v5 = c86v5.y
        c86v6 = c86v0.mScrollDrag
        c86v6 = c86v6.isHorizontal
        if not c86v6 then
          __renovice_state_0 = 14
        else
          __renovice_state_0 = 13
        end
      end
      if __renovice_state_0 == 13 then
        c86v4 = c86v2.x
        c86v6 = c86v0.mScrollDrag
        c86v6 = c86v6.InitDownPos
        c86v5 = c86v6.x
        __renovice_state_0 = 14
      end
      if __renovice_state_0 == 14 then
        c86v6 = 0
        if not (c86v6 < c86v4) then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 15
        end
      end
      if __renovice_state_0 == 15 then
        c86v7 = c86v4 - c86v5
        c86v8 = c86v0.mScrollDrag
        c86v8 = c86v8.Sensitivity
        c86v6 = c86v7 * c86v8
        c86v7 = c86v0:GetMouseDragScrollStep()
        c86v9 = c86v6 / c86v7
        c86v8 = math.modf
        c86v8 = c86v8(c86v9)
        if c86v8 == 0 then
          __renovice_state_0 = 23
        else
          __renovice_state_0 = 16
        end
      end
      if __renovice_state_0 == 16 then
        c86v10 = c86v8 * c86v7
        c86v11 = c86v0.mScrollDrag
        c86v11 = c86v11.Sensitivity
        c86v9 = c86v10 / c86v11
        c86v5 = c86v5 + c86v9
        c86v9 = c86v0.mScrollDrag
        c86v9 = c86v9.isHorizontal
        if not c86v9 then
          __renovice_state_0 = 18
        else
          __renovice_state_0 = 17
        end
      end
      if __renovice_state_0 == 17 then
        c86v9 = c86v0.mScrollDrag
        c86v9 = c86v9.InitDownPos
        c86v9.x = c86v5
        __renovice_state_0 = 19
      end
      if __renovice_state_0 == 18 then
        c86v9 = c86v0.mScrollDrag
        c86v9 = c86v9.InitDownPos
        c86v9.y = c86v5
        __renovice_state_0 = 19
      end
      if __renovice_state_0 == 19 then
        c86v9 = c86v0:GetDragScrollIncrement()
        c86v8 = c86v8 * c86v9
        c86v10 = c86v0.mScroll
        c86v9 = c86v10 - c86v8
        c86v10 = c86v0.GetClampedScroll
        if c86v10 == nil then
          __renovice_state_0 = 21
        else
          __renovice_state_0 = 20
        end
      end
      if __renovice_state_0 == 20 then
        c86v9 = c86v0:GetClampedScroll(c86v9)
        __renovice_state_0 = 22
      end
      if __renovice_state_0 == 21 then
        c86v10 = Clamp
        c86v12 = 1
        c86v15 = c86v0:GetHowManyElements()
        c86v16 = c86v0:GetHowManyVisibleElements()
        c86v14 = c86v15 - c86v16
        c86v13 = c86v14 + 1
        c86v9 = c86v10(c86v9, c86v12, c86v13)
        __renovice_state_0 = 22
      end
      if __renovice_state_0 == 22 then
        c86v13 = true
        c86v0:SetScroll(c86v9, c86v13)
        __renovice_state_0 = 23
      end
      if __renovice_state_0 == 23 then
        c86v4 = true
        do return c86v4 end
      end
      if __renovice_state_0 == 24 then
        c86v3 = Distance
        c86v5 = c86v0.mScrollDrag
        c86v5 = c86v5.InitDownPos
        c86v3 = c86v3(c86v2, c86v5)
        c86v4 = c86v0.mScrollDrag
        c86v4 = c86v4.DistThresh
        if not (c86v4 < c86v3) then
          __renovice_state_0 = 31
        else
          __renovice_state_0 = 25
        end
      end
      if __renovice_state_0 == 25 then
        c86v5 = c86v0.mScrollDrag
        c86v5 = c86v5.InitDownPos
        c86v7 = 1
        c86v8 = 35
        c86v3 = c86v0:GetTouchMoveDirection(c86v5, c86v2, c86v7, c86v8)
        c86v4 = c86v0.MOVE_HORIZONTAL
        if c86v3 ~= c86v4 then
          __renovice_state_0 = 27
        else
          __renovice_state_0 = 26
        end
      end
      if __renovice_state_0 == 26 then
        c86v4 = c86v0.mScrollDrag
        c86v4 = c86v4.isHorizontal
        if c86v4 then
          __renovice_state_0 = 29
        else
          __renovice_state_0 = 27
        end
      end
      if __renovice_state_0 == 27 then
        c86v4 = c86v0.MOVE_VERTICAL
        if c86v3 ~= c86v4 then
          __renovice_state_0 = 30
        else
          __renovice_state_0 = 28
        end
      end
      if __renovice_state_0 == 28 then
        c86v4 = c86v0.mScrollDrag
        c86v4 = c86v4.isHorizontal
        if c86v4 then
          __renovice_state_0 = 30
        else
          __renovice_state_0 = 29
        end
      end
      if __renovice_state_0 == 29 then
        c86v4 = c86v0.mScrollDrag
        c86v5 = true
        c86v4.isDragging = c86v5
        c86v4 = true
        do return c86v4 end
      end
      if __renovice_state_0 == 30 then
        c86v0:StopScrollDrag()
        c86v4 = false
        do return c86v4 end
      end
      if __renovice_state_0 == 31 then
        c86v2 = false
        do return c86v2 end
      end
      do return end
    end
    c87v3.UpdateScrollDrag = c87v5
    do return c87v3 end
  end
  CreateList = v0
  do return end
