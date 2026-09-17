-- RENOVICE_HASH_FIELD: CreateListContainer
-- RENOVICE_HASH_FIELD: CreateScrollBar
local v86_0
local v86_1
local v86_2
local v86_3
v86_0 = module
v86_1 = (select(1, ...))
v86_2 = package.seeall
v86_0(v86_1, v86_2)
v86_3 = function(p85_0, p85_1, p85_2)
    local frame_85 = {}
    frame_85[3] = p85_1
    p85_0:SetNumberVariable(frame_85[3], 12, 0)
    frame_85[8] = {}
    frame_85[8].mMovie = p85_0
    frame_85[9] = {}
    frame_85[8].mElements = frame_85[9]
    frame_85[10] = {}
    frame_85[8].mClips = frame_85[10]
    frame_85[8].mEnabled = true
    frame_85[8].mClipName = p85_1
    frame_85[8].mCurrentElementIndex = nil
    frame_85[8].mElementDrawCallback = nil
    frame_85[8].mOnFocusedCallback = nil
    frame_85[8].mOnUnfocusedCallback = nil
    frame_85[8].mOnSelectedCallback = nil
    frame_85[8].mOnRemovedCallback = nil
    frame_85[8].mOnPressedCallback = nil
    frame_85[8].mForcedVerticalSeparation = nil
    frame_85[8].mForcedHorizontalSeparation = nil
    frame_85[8].mPressElementCallback = nil
    frame_85[8].mSelectElementCallback = nil
    frame_85[8].mRollOverElementCallback = nil
    frame_85[8].mRollOutElementCallback = nil
    frame_85[8].mClipCreatedCallback = nil
    frame_85[8].mOnDraggedCallback = nil
    frame_85[8].mOnDragFocusedCallback = nil
    frame_85[8].mOnDragUnfocusedCallback = nil
    frame_85[29] = require
    frame_85[31] = frame_85[29]("EE.Interface.Utilities")
    frame_85[8].UTIL = frame_85[31]
    frame_85[8].mHasDrawn = false
    frame_85[8].mTopId = 0
    frame_85[8].mTopClipIndexUsed = 0
    frame_85[8].mLastPressTime = 0
    frame_85[8].mInitialDepth = 1000
    frame_85[8].mDepthDirection = -1
    frame_85[8].mElementTransitionTime = 0.2
    frame_85[8].mElementDelayTime = 0
    frame_85[8].mWrapAroundNavigation = true
    frame_85[41] = p85_1
    frame_85[45] = p85_0:GetNumberVariable(frame_85[41], 0)
    frame_85[8].mInitialX = frame_85[45]
    frame_85[46] = p85_1
    frame_85[50] = p85_0:GetNumberVariable(frame_85[46], 1)
    frame_85[8].mInitialY = frame_85[50]
    frame_85[8].mVisibleElements = p85_2
    frame_85[8].mScroll = nil
    frame_85[8].mScrollBarClipName = nil
    frame_85[8].mRedrawFromScrollBar = nil
    frame_85[8].mListContainer = nil
    frame_85[8].mSmoothScroll = false
    frame_85[8].mScrollAlwaysVisible = false
    frame_85[57] = p85_1
    frame_85[59] = (frame_85[57] .. ".Btn")
    frame_85[63] = p85_0:GetNumberVariable(frame_85[59], 15)
    frame_85[8].mOriginalButtonHeight = frame_85[63]
    frame_85[64] = p85_1
    frame_85[66] = (frame_85[64] .. ".Btn")
    frame_85[70] = p85_0:GetNumberVariable(frame_85[66], 14)
    frame_85[8].mOriginalButtonWidth = frame_85[70]
    frame_85[72] = p85_1
    frame_85[74] = ("List(" .. frame_85[72] .. ")::")
    frame_85[8].mPrefix = frame_85[74]
    frame_85[8].mEasing = 2
    frame_85[8].mLowerBoundBuffer = 0
    frame_85[8].mUpperBoundBuffer = 0
    frame_85[8].mIgnoreFiller = false
    frame_85[79] = {}
    frame_85[8].mClickDrag = frame_85[79]
    frame_85[80] = {}
    frame_85[8].mScrollDrag = frame_85[80]
    frame_85[8].UP = 1
    frame_85[8].RIGHT = 2
    frame_85[8].DOWN = 3
    frame_85[8].LEFT = 4
    frame_85[85] = p85_1
    frame_85[90] = p85_0:Name__d9713943(frame_85[85], 67, false)
    frame_85[8][1] = frame_85[90]
    frame_85[91] = {}
    frame_85[91][1] = 12
    frame_85[91][2] = 1
    frame_85[8].mInterpolationProps = frame_85[91]
    frame_85[94] = {}
    frame_85[94][1] = 100
    frame_85[94][2] = 0
    frame_85[8].mInterpolationValues = frame_85[94]
    frame_85[8].mStopDragScrollingOnSelection = true
    frame_85[8].mAllowElementSelectionOnScrollDragEnd = false
    frame_85[8].MOVE_NONE = 0
    frame_85[8].MOVE_VERTICAL = 1
    frame_85[8].MOVE_HORIZONTAL = 2
    frame_85[102] = function(p0_0, p0_1)
        local v0_2
        local v0_3
        local v0_4
        local v0_5
        v0_2 = print
        v0_3 = (p0_0).mPrefix
        v0_4 = p0_1
        v0_5 = (v0_3 .. v0_4)
        v0_2(v0_5)
        return
    end
    frame_85[8].Print = frame_85[102]
    frame_85[103] = function(p1_0)
        local v1_1
        local v1_2
        v1_1 = (p1_0).mElements
        v1_2 = (#v1_1)
        return v1_2
    end
    frame_85[8].GetHowManyElements = frame_85[103]
    frame_85[104] = function(p2_0)
        local v2_1
        local v2_2
        local v2_3
        local v2_4
        local v2_5
        local v2_6
        local v2_7
        local v2_8
        v2_1 = (p2_0).UTIL
        v2_2 = (v2_1).Ternary
        v2_3 = (p2_0).mVisibleElements
        if v2_3 == nil then
            v2_4 = true
        else
            v2_4 = false
        end
        v2_5 = (p2_0).mElements
        v2_6 = (#v2_5)
        v2_7 = (p2_0).mVisibleElements
        v2_8 = v2_2(v2_4, v2_6, v2_7)
        return v2_8
    end
    frame_85[8].GetHowManyVisibleElements = frame_85[104]
    frame_85[105] = function(p3_0)
        local v3_1
        local v3_2
        local v3_3
        local v3_4
        local v3_5
        local v3_6
        local v3_7
        v3_1 = (p3_0).mCurrentElementIndex
        v3_2 = IsNull
        v3_3 = v3_2(v3_1)
        if v3_3 then
            return nil
        else
            v3_4 = (p3_0).mElements
            v3_5 = (p3_0).mCurrentElementIndex
            v3_6 = v3_4[v3_5]
            return v3_6
        end
    end
    frame_85[8].GetFocusedElement = frame_85[105]
    frame_85[106] = function(p4_0)
        local v4_1
        v4_1 = (p4_0).mCurrentElementIndex
        return v4_1
    end
    frame_85[8].GetFocusedElementIndex = frame_85[106]
    frame_85[107] = function(p5_0, p5_1)
        local v5_2
        local v5_3
        v5_2 = (p5_0).mElements
        v5_3 = v5_2[p5_1]
        return v5_3
    end
    frame_85[8].GetElementInIndex = frame_85[107]
    frame_85[108] = function(p6_0, p6_1)
        local v6_2
        local v6_3
        local v6_4
        local v6_5
        local v6_6
        local v6_7
        local v6_8
        local v6_9
        v6_2 = 1
        v6_3 = (p6_0).mElements
        v6_4 = (#v6_3)
        v6_5 = 1
        for v6_2 = v6_2, v6_4, v6_5 do
            v6_6 = (p6_0).mElements
            v6_7 = v6_6[v6_2]
            v6_8 = (v6_7).Id
            if not (v6_8 ~= p6_1) then
                return v6_2
            end
        end
        return nil
    end
    frame_85[8].GetElementIndexById = frame_85[108]
    frame_85[109] = function(p7_0, p7_1, p7_2, p7_3)
        local v7_4
        local v7_5
        local v7_6
        local v7_7
        local v7_8
        local v7_9
        local v7_10
        local v7_11
        v7_4 = (p7_0).mElements
        v7_5 = v7_4[p7_1]
        v7_6 = (v7_5).Id
        p7_2.Id = v7_6
        v7_7 = (p7_0).mElements
        v7_7[p7_1] = p7_2
        if not (p7_3) then
            p7_0:Redraw(nil, true)
        end
        return
    end
    frame_85[8].UpdateElementInIndex = frame_85[109]
    frame_85[110] = function(p8_0, p8_1, p8_2, p8_3)
        local v8_4
        local v8_5
        local v8_6
        local v8_7
        local v8_8
        local v8_9
        local v8_10
        local v8_11
        local v8_12
        v8_4 = p8_1
        v8_7 = p8_0:GetElementIndexById(v8_4)
        v8_8 = v8_7
        v8_9 = p8_2
        v8_10 = p8_3
        p8_0:UpdateElementInIndex(v8_8, v8_9, v8_10)
        return
    end
    frame_85[8].UpdateElementById = frame_85[110]
    frame_85[111] = function(p9_0, p9_1)
        local v9_2
        local v9_3
        local v9_4
        local v9_5
        local v9_6
        local v9_7
        local v9_8
        local v9_9
        local v9_10
        v9_2 = p9_1
        v9_10 = p9_0:GetElementInIndex(p9_0:GetElementIndexById(v9_2))
        return v9_10
    end
    frame_85[8].GetElementById = frame_85[111]
    frame_85[112] = function(p10_0, p10_1)
        local v10_2
        local v10_3
        local v10_4
        p10_0.mClipName = p10_1
        v10_2 = p10_1
        p10_0:SetClipCallbacks(v10_2)
        return
    end
    frame_85[8].SetBaseClipName = frame_85[112]
    frame_85[113] = function(p11_0, p11_1)
        local v11_2
        local v11_3
        local v11_4
        v11_2 = (p11_0).mElements
        v11_3 = v11_2[p11_1]
        v11_4 = (v11_3).mClipName
        return v11_4
    end
    frame_85[8].GetClipName = frame_85[113]
    frame_85[114] = function(p12_0)
        local v12_1
        v12_1 = (p12_0).mScroll
        return v12_1
    end
    frame_85[8].GetScroll = frame_85[114]
    frame_85[115] = function(p13_0, p13_1)
        local v13_2
        local v13_3
        local v13_4
        local v13_5
        local v13_6
        local v13_7
        local v13_8
        local v13_9
        local v13_10
        local v13_11
        local v13_12
        local v13_13
        local v13_14
        local v13_15
        local v13_16
        local v13_17
        local v13_18
        local v13_19
        local v13_20
        local v13_21
        local v13_22
        local v13_23
        local v13_24
        local v13_25
        local v13_26
        v13_2 = (p13_1).mIndex
        if not (v13_2 ~= nil) then
            v13_3 = (p13_1).Id
            v13_6 = p13_0:GetElementIndexById(v13_3)
            v13_2 = v13_6
        end
        v13_7 = v13_2
        v13_8 = IsNull
        v13_9 = v13_8(v13_7)
        if not (v13_9) then
            v13_11 = (p13_0).mScroll
            v13_12 = IsNull
            v13_13 = v13_12(v13_11)
            if not (v13_13) then
                v13_14 = (p13_0).mScroll
                v13_15 = (v13_2 - v13_14)
                v13_2 = (v13_15 + 1)
            end
            v13_16 = 0
            v13_17 = (p13_0).mForcedHorizontalSeparation
            v13_18 = IsNull
            v13_19 = v13_18(v13_17)
            if not (v13_19) then
                v13_16 = (p13_0).mForcedHorizontalSeparation
            end
            v13_20 = (p13_0).UTIL
            v13_21 = (v13_20).Round
            v13_22 = (p13_0).mInitialX
            v13_23 = (v13_2 - 1)
            v13_24 = (v13_16 * v13_23)
            v13_25 = (v13_22 + v13_24)
            v13_26 = v13_21(v13_25)
            return v13_26
        else
            v13_10 = (p13_0).mInitialX
            return v13_10
        end
    end
    frame_85[8].CalculateX = frame_85[115]
    frame_85[116] = function(p14_0, p14_1)
        local v14_2
        local v14_3
        local v14_4
        local v14_5
        local v14_6
        local v14_7
        local v14_8
        local v14_9
        local v14_10
        local v14_11
        local v14_12
        local v14_13
        local v14_14
        local v14_15
        local v14_16
        local v14_17
        local v14_18
        local v14_19
        local v14_20
        local v14_21
        local v14_22
        local v14_23
        local v14_24
        local v14_25
        local v14_26
        local v14_27
        local v14_28
        local v14_29
        local v14_30
        local v14_31
        local v14_32
        local v14_33
        local v14_34
        local v14_35
        local v14_36
        v14_2 = (p14_1).mIndex
        if not (v14_2 ~= nil) then
            v14_3 = (p14_1).Id
            v14_6 = p14_0:GetElementIndexById(v14_3)
            v14_2 = v14_6
        end
        v14_7 = v14_2
        v14_8 = IsNull
        v14_9 = v14_8(v14_7)
        if not (v14_9) then
            v14_11 = (p14_0).mScroll
            v14_12 = IsNull
            v14_13 = v14_12(v14_11)
            if not (v14_13) then
                v14_14 = (p14_0).mScroll
                v14_15 = (v14_2 - v14_14)
                v14_2 = (v14_15 + 1)
            end
            v14_16 = nil
            v14_17 = (p14_0).mForcedVerticalSeparation
            v14_18 = IsNull
            v14_19 = v14_18(v14_17)
            if v14_19 then
                v14_21 = (p14_0).mMovie
                v14_22 = (p14_0).mClipName
                v14_26 = v14_21:GetNumberVariable(v14_22, 15)
                v14_20 = v14_26
            else
                v14_20 = (p14_0).mForcedVerticalSeparation
            end
            v14_27 = 0
            v14_28 = (p14_1).listExtraY
            if v14_28 then
                v14_27 = (p14_1).listExtraY
            end
            v14_29 = (p14_0).UTIL
            v14_30 = (v14_29).Round
            v14_31 = (p14_0).mInitialY
            v14_32 = (v14_2 - 1)
            v14_33 = (v14_20 * v14_32)
            v14_34 = (v14_31 + v14_33)
            v14_35 = v14_30(v14_34)
            v14_36 = (v14_35 + v14_27)
            return v14_36
        else
            v14_10 = (p14_0).mInitialY
            return v14_10
        end
    end
    frame_85[8].CalculateY = frame_85[116]
    frame_85[117] = function(p16_0, p16_1, p16_2, p16_3, p16_4, p16_5, p16_6, p16_7)
        local v16_8
        local v16_9
        local v16_10
        local v16_11
        local v16_12
        local v16_13
        p16_0.mSelectElementCallback = p16_1
        p16_0.mRollOverElementCallback = p16_2
        p16_0.mRollOutElementCallback = p16_3
        p16_0.mPressElementCallback = p16_4
        p16_0.mDragOverElementCallback = p16_5
        p16_0.mDragOutElementCallback = p16_6
        p16_0.mReleaseOutsideCallback = p16_7
        v16_8 = (p16_0).mClipName
        p16_0:SetClipCallbacks(v16_8)
        local cap_16_10_0 = p16_0
        v16_11 = function(p15_0)
            local v15_1
            local v15_2
            local v15_3
            local v15_4
            v15_1 = cap_16_10_0
            v15_2 = (p15_0).mClipName
            v15_1:SetClipCallbacks(v15_2)
            return
        end
        p16_0:RunForAllVisibleElements(v16_11)
        return
    end
    frame_85[8].SetCallbacks = frame_85[117]
    frame_85[118] = function(p17_0, p17_1)
        local frame_17 = {}
        local cfg_17 = 0
        while true do
            if cfg_17 == 0 then
                frame_17[2] = (p17_0).mRollOverElementCallback
                if frame_17[2] ~= nil then
                    cfg_17 = 4
                else
                    cfg_17 = 1
                end
            elseif cfg_17 == 1 then
                frame_17[3] = (p17_0).mRollOutElementCallback
                if frame_17[3] ~= nil then
                    cfg_17 = 4
                else
                    cfg_17 = 2
                end
            elseif cfg_17 == 2 then
                frame_17[4] = (p17_0).mSelectElementCallback
                if frame_17[4] ~= nil then
                    cfg_17 = 4
                else
                    cfg_17 = 3
                end
            elseif cfg_17 == 3 then
                frame_17[5] = (p17_0).mPressElementCallback
                if frame_17[5] == nil then
                    cfg_17 = 13
                else
                    cfg_17 = 4
                end
            elseif cfg_17 == 4 then
                frame_17[6] = (p17_0).mMovie
                frame_17[7] = p17_1
                frame_17[9] = (frame_17[7] .. ".Btn")
                frame_17[10] = (p17_0).mRollOverElementCallback
                frame_17[11] = (p17_0).mRollOutElementCallback
                frame_17[12] = (p17_0).mSelectElementCallback
                frame_17[13] = (p17_0).mPressElementCallback
                frame_17[16] = (frame_17[6]):SetCallbacks(frame_17[9], frame_17[10], frame_17[11], frame_17[12], frame_17[13])
                if frame_17[16] then
                    cfg_17 = 13
                else
                    cfg_17 = 5
                end
            elseif cfg_17 == 5 then
                frame_17[17] = (p17_0).mPressElementCallback
                frame_17[18] = IsNull
                frame_17[19] = frame_17[18](frame_17[17])
                if frame_17[19] then
                    cfg_17 = 7
                else
                    cfg_17 = 6
                end
            elseif cfg_17 == 6 then
                frame_17[20] = (p17_0).mMovie
                frame_17[21] = p17_1
                frame_17[23] = (p17_0).mPressElementCallback
                do (frame_17[20]):SetVariable(frame_17[21], "PressedCallback", frame_17[23]) end
                cfg_17 = 7
            elseif cfg_17 == 7 then
                frame_17[26] = (p17_0).mSelectElementCallback
                frame_17[27] = IsNull
                frame_17[28] = frame_17[27](frame_17[26])
                if frame_17[28] then
                    cfg_17 = 9
                else
                    cfg_17 = 8
                end
            elseif cfg_17 == 8 then
                frame_17[29] = (p17_0).mMovie
                frame_17[30] = p17_1
                frame_17[32] = (p17_0).mSelectElementCallback
                do (frame_17[29]):SetVariable(frame_17[30], "SelectCallback", frame_17[32]) end
                cfg_17 = 9
            elseif cfg_17 == 9 then
                frame_17[35] = (p17_0).mRollOverElementCallback
                frame_17[36] = IsNull
                frame_17[37] = frame_17[36](frame_17[35])
                if frame_17[37] then
                    cfg_17 = 11
                else
                    cfg_17 = 10
                end
            elseif cfg_17 == 10 then
                frame_17[38] = (p17_0).mMovie
                frame_17[39] = p17_1
                frame_17[41] = (p17_0).mRollOverElementCallback
                do (frame_17[38]):SetVariable(frame_17[39], "RollOverCallback", frame_17[41]) end
                cfg_17 = 11
            elseif cfg_17 == 11 then
                frame_17[44] = (p17_0).mRollOutElementCallback
                frame_17[45] = IsNull
                frame_17[46] = frame_17[45](frame_17[44])
                if frame_17[46] then
                    cfg_17 = 13
                else
                    cfg_17 = 12
                end
            elseif cfg_17 == 12 then
                frame_17[47] = (p17_0).mMovie
                frame_17[48] = p17_1
                frame_17[50] = (p17_0).mRollOutElementCallback
                do (frame_17[47]):SetVariable(frame_17[48], "RollOutCallback", frame_17[50]) end
                cfg_17 = 13
            elseif cfg_17 == 13 then
                frame_17[53] = (p17_0).mReleaseOutsideCallback
                if frame_17[53] == nil then
                    cfg_17 = 16
                else
                    cfg_17 = 14
                end
            elseif cfg_17 == 14 then
                frame_17[54] = (p17_0).mMovie
                frame_17[55] = p17_1
                frame_17[57] = (frame_17[55] .. ".Btn")
                frame_17[58] = (p17_0).mReleaseOutsideCallback
                frame_17[61] = (frame_17[54]):SetReleaseOutsideCallback(frame_17[57], frame_17[58])
                if frame_17[61] then
                    cfg_17 = 16
                else
                    cfg_17 = 15
                end
            elseif cfg_17 == 15 then
                frame_17[62] = (p17_0).mMovie
                frame_17[63] = p17_1
                frame_17[65] = (p17_0).mReleaseOutsideCallback
                do (frame_17[62]):SetVariable(frame_17[63], "ReleaseOutsideCallback", frame_17[65]) end
                cfg_17 = 16
            elseif cfg_17 == 16 then
                frame_17[68] = (p17_0).mDragOverElementCallback
                if frame_17[68] ~= nil then
                    cfg_17 = 18
                else
                    cfg_17 = 17
                end
            elseif cfg_17 == 17 then
                frame_17[69] = (p17_0).mDragOutElementCallback
                if frame_17[69] == nil then
                    cfg_17 = 23
                else
                    cfg_17 = 18
                end
            elseif cfg_17 == 18 then
                frame_17[70] = (p17_0).mMovie
                frame_17[71] = p17_1
                frame_17[73] = (frame_17[71] .. ".Btn")
                frame_17[74] = (p17_0).mDragOverElementCallback
                frame_17[75] = (p17_0).mDragOutElementCallback
                frame_17[78] = (frame_17[70]):SetDragCallbacks(frame_17[73], frame_17[74], frame_17[75])
                if frame_17[78] then
                    cfg_17 = 23
                else
                    cfg_17 = 19
                end
            elseif cfg_17 == 19 then
                frame_17[79] = (p17_0).mDragOverElementCallback
                frame_17[80] = IsNull
                frame_17[81] = frame_17[80](frame_17[79])
                if frame_17[81] then
                    cfg_17 = 21
                else
                    cfg_17 = 20
                end
            elseif cfg_17 == 20 then
                frame_17[82] = (p17_0).mMovie
                frame_17[83] = p17_1
                frame_17[85] = (p17_0).mDragOverElementCallback
                do (frame_17[82]):SetVariable(frame_17[83], "DragOverCallback", frame_17[85]) end
                cfg_17 = 21
            elseif cfg_17 == 21 then
                frame_17[88] = (p17_0).mDragOutElementCallback
                frame_17[89] = IsNull
                frame_17[90] = frame_17[89](frame_17[88])
                if frame_17[90] then
                    cfg_17 = 23
                else
                    cfg_17 = 22
                end
            elseif cfg_17 == 22 then
                frame_17[91] = (p17_0).mMovie
                frame_17[92] = p17_1
                frame_17[94] = (p17_0).mDragOutElementCallback
                do (frame_17[91]):SetVariable(frame_17[92], "DragOutCallback", frame_17[94]) end
                cfg_17 = 23
            elseif cfg_17 == 23 then
                return
            else
                error("invalid control state")
            end
        end
    end
    frame_85[8].SetClipCallbacks = frame_85[118]
    frame_85[119] = function(p18_0, p18_1, p18_2, p18_3, p18_4)
        local v18_5
        local v18_6
        local v18_7
        local v18_8
        local v18_9
        local v18_10
        local v18_11
        local v18_12
        local v18_13
        local v18_14
        local v18_15
        local v18_16
        local v18_17
        local v18_18
        local v18_19
        local v18_20
        local v18_21
        local v18_22
        local v18_23
        local v18_24
        local v18_25
        local v18_26
        local v18_27
        local v18_28
        local v18_29
        local v18_30
        local v18_31
        local v18_32
        local v18_33
        local v18_34
        local v18_35
        local v18_36
        local v18_37
        local v18_38
        local v18_39
        local v18_40
        local v18_41
        local v18_42
        local v18_43
        local v18_44
        local v18_45
        local v18_46
        local v18_47
        if not (p18_1 ~= nil) then
            p18_1 = 0
        end
        v18_7 = p18_0:GetHowManyElements()
        if 0 < v18_7 then
            while true do
                if not (p18_1 < 0) then break end
                p18_1 = (v18_7 + p18_1)
            end
            while true do
                v18_10 = (v18_7 + 1)
                if not (v18_10 < p18_1) then break end
                p18_1 = (p18_1 - v18_7)
            end
        end
        v18_11 = false
        local predicate_value_18_7 = (not (p18_1 == 0) and v18_7 ~= 0)
        if predicate_value_18_7 then
            if p18_1 <= v18_7 then
                v18_11 = true
            end
        else
            p18_1 = (v18_7 + 1)
        end
        v18_12 = (p18_2).Id
        v18_13 = IsNull
        v18_14 = v18_13(v18_12)
        if v18_14 then
            v18_15 = (p18_0).mTopId
            v18_16 = (v18_15 + 1)
            p18_2.Id = v18_16
        end
        v18_17 = (p18_2).Id
        v18_18 = (p18_0).mTopId
        v18_19 = math.max
        v18_20 = v18_19(v18_17, v18_18)
        p18_0.mTopId = v18_20
        p18_2.mInitialized = false
        p18_2.mClipName = nil
        p18_2.mClipEnabled = false
        p18_2.mIndex = p18_1
        v18_24 = (p18_0).mElements
        v18_25 = p18_1
        v18_26 = p18_2
        v18_27 = table.insert
        v18_27(v18_24, v18_25, v18_26)
        if v18_11 then
            v18_30 = p18_0:GetHowManyElements()
            v18_31 = v18_30
            v18_32 = ResetLineCount
            v18_32(0)
            v18_34 = 1
            v18_35 = v18_31
            v18_36 = 1
            for v18_34 = v18_34, v18_35, v18_36 do
                v18_37 = (p18_0).mElements
                v18_38 = v18_37[v18_34]
                v18_38.mIndex = v18_34
            end
        end
        v18_39 = (p18_2).mOverrideClipName
        if not (v18_39 == nil) then
            v18_40 = (p18_2).mOverrideClipName
            p18_0:SetClipCallbacks(v18_40)
        end
        if not (p18_3) then
            v18_44 = v18_11
            v18_45 = p18_4
            p18_0:Redraw(nil, v18_44, v18_45)
        end
        return p18_2
    end
    frame_85[8].InsertElement = frame_85[119]
    frame_85[120] = function(p19_0, p19_1, p19_2, p19_3)
        local v19_4
        local v19_5
        local v19_6
        local v19_7
        local v19_8
        local v19_9
        local v19_10
        local v19_11
        local v19_12
        local v19_13
        v19_6 = p19_0:GetHowManyElements()
        v19_7 = (v19_6 + 1)
        v19_8 = p19_1
        v19_9 = p19_2
        v19_10 = p19_3
        v19_13 = p19_0:InsertElement(v19_7, v19_8, v19_9, v19_10)
        return v19_13
    end
    frame_85[8].AddElement = frame_85[120]
    frame_85[121] = function(p21_0, p21_1, p21_2, p21_3, p21_4, p21_5, p21_6)
        local v21_7
        local v21_8
        local v21_9
        local v21_10
        local v21_11
        local v21_12
        local v21_13
        local v21_14
        local v21_15
        local v21_16
        local v21_17
        local v21_18
        local v21_19
        local v21_20
        local v21_21
        local v21_22
        local v21_23
        local v21_24
        local v21_25
        local v21_26
        local v21_27
        local v21_28
        local v21_29
        local v21_30
        local v21_31
        local v21_32
        local v21_33
        local v21_34
        local v21_35
        local v21_36
        local v21_37
        local v21_38
        local v21_39
        local v21_40
        local v21_41
        local v21_42
        local v21_43
        local v21_44
        local v21_45
        local v21_46
        local v21_47
        local v21_48
        local v21_49
        local v21_50
        local v21_51
        local v21_52
        local v21_53
        local v21_54
        local v21_55
        local v21_56
        local v21_57
        local v21_58
        local v21_59
        local v21_60
        local v21_61
        local v21_62
        local v21_63
        local v21_64
        local v21_65
        local v21_66
        local v21_67
        local v21_68
        local v21_69
        local v21_70
        local v21_71
        local v21_72
        local v21_73
        local v21_74
        local v21_75
        local v21_76
        local v21_77
        local v21_78
        local v21_79
        local v21_80
        local v21_81
        local v21_82
        local v21_83
        local v21_84
        local v21_85
        local v21_86
        local v21_87
        local v21_88
        local v21_89
        local v21_90
        local v21_91
        local v21_92
        local v21_93
        local v21_94
        local v21_95
        local v21_96
        local v21_97
        local v21_98
        local v21_99
        local v21_100
        local v21_101
        local v21_102
        local v21_103
        local v21_104
        local v21_105
        local v21_106
        local v21_107
        local v21_108
        local v21_109
        local v21_110
        local v21_111
        local v21_112
        local v21_113
        local v21_114
        local v21_115
        local v21_116
        local v21_117
        local v21_118
        local v21_119
        local v21_120
        if not (p21_3 ~= nil) then
            p21_3 = false
        end
        v21_7 = (p21_0).mElements
        v21_8 = v21_7[p21_1]
        v21_9 = IsNull
        v21_10 = v21_9(v21_8)
        if not (v21_10) then
            v21_11 = ResetLineCount
            v21_11(0)
            v21_15 = p21_0:GetHowManyElements()
            v21_16 = (p21_0).mElements
            v21_17 = v21_16[p21_1]
            v21_18 = (v21_17).mClipName
            v21_19 = (p21_0).mElements
            v21_20 = v21_19[p21_1]
            v21_21 = (v21_20).mOverrideClipName
            if v21_21 ~= nil then
                v21_22 = true
            else
                v21_22 = false
            end
            v21_25 = p21_0:GetHowManyVisibleElements()
            v21_26 = v21_18
            v21_27 = IsNull
            v21_28 = v21_27(v21_26)
            if not (v21_28) then
                local cap_21_29_0 = p21_5
                local cap_21_29_1 = p21_0
                local cap_21_29_2 = v21_15
                local cap_21_29_3 = v21_25
                local cap_21_29_4 = p21_4
                local cap_21_29_5 = v21_22
                local cap_21_29_6 = v21_18
                local cap_21_29_7 = p21_2
                v21_29 = function()
                    local v20_0
                    local v20_1
                    local v20_2
                    local v20_3
                    local v20_4
                    local v20_5
                    local v20_6
                    local v20_7
                    local v20_8
                    local v20_9
                    local v20_10
                    local v20_11
                    local v20_12
                    local v20_13
                    local v20_14
                    local v20_15
                    local v20_16
                    local v20_17
                    local v20_18
                    local v20_19
                    local v20_20
                    local v20_21
                    local v20_22
                    local v20_23
                    local v20_24
                    local v20_25
                    local v20_26
                    local v20_27
                    local v20_28
                    local v20_29
                    local v20_30
                    local v20_31
                    local v20_32
                    local v20_33
                    local v20_34
                    local v20_35
                    local v20_36
                    v20_0 = cap_21_29_0
                    if not (v20_0) then
                        v20_1 = cap_21_29_1
                        v20_2 = (v20_1).mVisibleElements
                        local sc_20_1
                        if v20_2 == nil then
                            sc_20_1 = true
                        else
                            v20_3 = cap_21_29_2
                            v20_4 = cap_21_29_3
                            if v20_3 <= v20_4 then
                                sc_20_1 = true
                            else
                                v20_5 = cap_21_29_4
                                sc_20_1 = v20_5
                            end
                        end
                        if sc_20_1 then
                            v20_6 = cap_21_29_5
                            local sc_20_4
                            if v20_6 then
                                sc_20_4 = true
                            else
                                v20_7 = cap_21_29_6
                                v20_8 = cap_21_29_1
                                v20_9 = (v20_8).mClipName
                                sc_20_4 = v20_7 == v20_9
                            end
                            if sc_20_4 then
                                v20_16 = cap_21_29_1
                                v20_17 = (v20_16).mMovie
                                v20_18 = cap_21_29_6
                                v20_17:SetNumberVariable(v20_18, 12, 0)
                                v20_23 = cap_21_29_1
                                v20_24 = (v20_23).mMovie
                                v20_25 = cap_21_29_6
                                v20_24:Name__d9713943(v20_25, 67, false)
                            else
                                v20_10 = FlashMethod
                                v20_11 = cap_21_29_1
                                v20_12 = (v20_11).mMovie
                                v20_13 = cap_21_29_6
                                v20_15 = (v20_13 .. ".removeMovieClip")
                                v20_10(v20_12, v20_15)
                            end
                        end
                    end
                    v20_30 = cap_21_29_7
                    if not (v20_30) then
                        v20_31 = cap_21_29_1
                        v20_34 = p21_3
                        v20_31:Redraw(nil, true, v20_34)
                    end
                    return
                end
                if not (p21_3) then
                    v21_35 = FlashInterpolate
                    v21_36 = (p21_0).mMovie
                    v21_37 = v21_18
                    v21_38 = (p21_0).mEasing
                    v21_39 = {}
                    v21_39[1] = 12
                    v21_39[2] = 1
                    v21_42 = {}
                    v21_44 = (p21_0).mElements
                    v21_45 = v21_44[p21_1]
                    v21_48 = p21_0:CalculateY(v21_45)
                    v21_49 = (v21_48 - 40)
                    v21_42[1] = 0
                    v21_42[2] = v21_49
                    v21_50 = (p21_0).mElementTransitionTime
                    v21_52 = v21_29
                    v21_35(v21_36, v21_37, v21_38, v21_39, v21_42, v21_50, 0, v21_52)
                else
                    v21_30 = (p21_0).mMovie
                    v21_31 = v21_18
                    v21_30:EnablePfdeco(v21_31)
                    v21_34 = v21_29
                    v21_34()
                end
                v21_53 = (p21_0).mVisibleElements
                local predicate_value_21_10 = ((not (v21_53 == nil) and not (v21_15 <= v21_25)) and not (p21_4))
                if predicate_value_21_10 then
                    v21_63 = (p21_0).mClips
                    v21_63[v21_18] = false
                    v21_65 = (p21_0).mMovie
                    v21_66 = v21_18
                    v21_65:SetNumberVariable(v21_66, 12, 0)
                    v21_71 = (p21_0).mClipName
                    if not (v21_18 == v21_71) then
                        v21_72 = (p21_0).mMovie
                        v21_73 = v21_18
                        v21_72:Name__d9713943(v21_73, 67, false)
                    end
                else
                    v21_54 = (p21_0).mOnRemovedCallback
                    v21_55 = IsNull
                    v21_56 = v21_55(v21_54)
                    if not (v21_56) then
                        v21_57 = (p21_0).mElements
                        v21_58 = v21_57[p21_1]
                        p21_0:mOnRemovedCallback(v21_58)
                    end
                    if not (p21_5) then
                        v21_61 = (p21_0).mClips
                        v21_61[v21_18] = nil
                    end
                end
                v21_78 = ResetLineCount
                v21_78(0)
            end
            v21_80 = (p21_0).mSelectedElement
            v21_81 = IsNull
            v21_82 = v21_81(v21_80)
            if not (v21_82) then
                v21_83 = (p21_0).mElements
                v21_84 = v21_83[p21_1]
                v21_85 = (v21_84).Id
                v21_86 = (p21_0).mSelectedElement
                v21_87 = (v21_86).Id
                if not (v21_85 ~= v21_87) then
                    p21_0.mSelectedElement = nil
                end
            end
            v21_89 = (p21_0).mElements
            v21_90 = v21_89[p21_1]
            v21_91 = (v21_90).Id
            v21_92 = table.remove
            v21_93 = (p21_0).mElements
            v21_94 = p21_1
            v21_92(v21_93, v21_94)
            v21_95 = v21_91
            v21_96 = IsNull
            v21_97 = v21_96(v21_95)
            if not (v21_97) then
                v21_98 = (p21_0).mTopId
                if not (v21_91 ~= v21_98) then
                    v21_101 = p21_0:GetHowManyElements()
                    v21_102 = 0
                    v21_103 = ResetLineCount
                    v21_103(0)
                    v21_105 = 1
                    v21_106 = v21_101
                    v21_107 = 1
                    for v21_105 = v21_105, v21_106, v21_107 do
                        v21_108 = (p21_0).mElements
                        v21_109 = v21_108[v21_105]
                        v21_110 = (v21_109).Id
                        if v21_102 < v21_110 then
                            v21_111 = (p21_0).mElements
                            v21_112 = v21_111[v21_105]
                            v21_102 = (v21_112).Id
                        end
                    end
                    p21_0.mTopId = v21_102
                end
            end
            if not (p21_6) then
                v21_115 = p21_0:GetHowManyElements()
                v21_116 = 1
                v21_117 = v21_115
                v21_118 = 1
                for v21_116 = v21_116, v21_117, v21_118 do
                    v21_119 = (p21_0).mElements
                    v21_120 = v21_119[v21_116]
                    v21_120.mIndex = v21_116
                end
            end
        end
        return
    end
    frame_85[8].RemoveElement = frame_85[121]
    frame_85[122] = function(p22_0, p22_1, p22_2, p22_3)
        local v22_4
        local v22_5
        local v22_6
        local v22_7
        local v22_8
        local v22_9
        local v22_10
        local v22_11
        v22_4 = p22_1
        v22_7 = p22_0:GetElementIndexById(v22_4)
        v22_8 = p22_2
        v22_9 = p22_3
        p22_0:RemoveElement(v22_7, v22_8, v22_9)
        return
    end
    frame_85[8].RemoveElementById = frame_85[122]
    frame_85[123] = function(p23_0, p23_1, p23_2)
        local v23_3
        local v23_4
        local v23_5
        local v23_6
        local v23_7
        local v23_8
        local v23_9
        local v23_10
        local v23_11
        local v23_12
        local v23_13
        local v23_14
        local v23_15
        local v23_16
        local v23_17
        local v23_18
        local v23_19
        local v23_20
        local v23_21
        local v23_22
        local v23_23
        local v23_24
        local v23_25
        local v23_26
        local v23_27
        local v23_28
        local v23_29
        local v23_30
        local v23_31
        local v23_32
        local v23_33
        local v23_34
        local v23_35
        local v23_36
        local v23_37
        local v23_38
        local v23_39
        local v23_40
        local v23_41
        local v23_42
        local v23_43
        local v23_44
        local v23_45
        local v23_46
        local v23_47
        local v23_48
        local v23_49
        local v23_50
        local v23_51
        local v23_52
        local v23_53
        local v23_54
        local v23_55
        local v23_56
        local v23_57
        local v23_58
        local v23_59
        v23_3 = (p23_0).mCurrentElementIndex
        v23_4 = IsNull
        v23_5 = v23_4(v23_3)
        if not (v23_5) then
            v23_6 = (p23_0).mCurrentElementIndex
            p23_0:UnfocusElement(v23_6)
        end
        v23_9 = (p23_0).mElements
        v23_10 = (#v23_9)
        p23_0.mTopId = 0
        v23_12 = 0
        v23_13 = (v23_10 - 1)
        v23_14 = 1
        for v23_12 = v23_12, v23_13, v23_14 do
            v23_15 = (v23_10 - v23_12)
            v23_16 = p23_1
            v23_17 = p23_2
            v23_19 = (p23_0).mPreserveClips
            p23_0:RemoveElement(v23_15, v23_16, v23_17, true, v23_19, true)
        end
        v23_23 = (p23_0).mScroll
        v23_24 = IsNull
        v23_25 = v23_24(v23_23)
        if not (v23_25) then
            p23_0:SetScroll(1, true)
        end
        p23_0.mTopClipIndexUsed = 0
        v23_31 = (p23_0).mPreserveClips
        if not (v23_31) then
            v23_33 = (p23_0).mClips
            for v23_51, v23_52 in pairs(v23_33) do
                v23_37 = (p23_0).mClipName
                if v23_51 == v23_37 then
                    v23_43 = (p23_0).mMovie
                    v23_44 = v23_51
                    v23_43:SetNumberVariable(v23_44, 12, 0)
                else
                    v23_38 = FlashMethod
                    v23_39 = (p23_0).mMovie
                    v23_40 = v23_51
                    v23_42 = (v23_40 .. ".removeMovieClip")
                    v23_38(v23_39, v23_42)
                end
                v23_49 = (p23_0).mClips
                v23_49[v23_51] = nil
            end
        end
        p23_0.mSelectedElement = nil
        v23_54 = (p23_0).mMovie
        v23_55 = (p23_0).mClipName
        v23_54:Name__d9713943(v23_55, 67, false)
        return
    end
    frame_85[8].RemoveElements = frame_85[123]
    frame_85[124] = function(p24_0)
        local v24_1
        local v24_2
        local v24_3
        p24_0:RemoveElements()
        v24_3 = nil
        return
    end
    frame_85[8].Remove = frame_85[124]
    frame_85[125] = function(p25_0, p25_1)
        local v25_2
        local v25_3
        local v25_4
        local v25_5
        local v25_6
        v25_2 = (p25_0).mOnUnfocusedCallback
        v25_3 = IsNull
        v25_4 = v25_3(v25_2)
        if not (v25_4) then
            v25_5 = (p25_0).mOnUnfocusedCallback
            v25_6 = p25_1
            v25_5(v25_6)
        end
        return
    end
    frame_85[8].OnUnfocused = frame_85[125]
    frame_85[126] = function(p26_0, p26_1)
        local v26_2
        local v26_3
        local v26_4
        local v26_5
        local v26_6
        local v26_7
        local v26_8
        local v26_9
        local v26_10
        local v26_11
        local v26_12
        local v26_13
        local v26_14
        v26_2 = (p26_0).mCurrentElementIndex
        if not (v26_2 ~= p26_1) then
            v26_3 = (p26_0).mElements
            v26_4 = v26_3[p26_1]
            v26_5 = IsNull
            v26_6 = v26_5(v26_4)
            if not (v26_6) then
                v26_7 = (p26_0).mElements
                v26_8 = v26_7[p26_1]
                v26_9 = (v26_8).mInitialized
                if v26_9 then
                    v26_10 = (p26_0).mElements
                    v26_11 = v26_10[p26_1]
                    p26_0:OnUnfocused(v26_11)
                    p26_0.mCurrentElementIndex = nil
                end
            end
        end
        return
    end
    frame_85[8].UnfocusElement = frame_85[126]
    frame_85[127] = function(p27_0, p27_1)
        local v27_2
        local v27_3
        local v27_4
        local v27_5
        local v27_6
        local v27_7
        local v27_8
        local v27_9
        local v27_10
        local v27_11
        v27_2 = p27_1
        v27_5 = p27_0:GetElementIndexById(v27_2)
        v27_6 = v27_5
        v27_7 = IsNull
        v27_8 = v27_7(v27_6)
        if not (v27_8) then
            v27_9 = v27_5
            p27_0:UnfocusElement(v27_9)
        end
        return
    end
    frame_85[8].UnfocusElementById = frame_85[127]
    frame_85[128] = function(p28_0, p28_1)
        local v28_2
        local v28_3
        local v28_4
        local v28_5
        local v28_6
        v28_2 = (p28_0).mOnFocusedCallback
        v28_3 = IsNull
        v28_4 = v28_3(v28_2)
        if not (v28_4) then
            v28_5 = (p28_0).mOnFocusedCallback
            v28_6 = p28_1
            v28_5(v28_6)
        end
        return
    end
    frame_85[8].OnFocused = frame_85[128]
    frame_85[129] = function(p29_0, p29_1, p29_2)
        local v29_3
        local v29_4
        local v29_5
        local v29_6
        local v29_7
        local v29_8
        local v29_9
        local v29_10
        local v29_11
        local v29_12
        local v29_13
        local v29_14
        local v29_15
        local v29_16
        local v29_17
        local v29_18
        local v29_19
        local v29_20
        local v29_21
        local v29_22
        local v29_23
        local v29_24
        local v29_25
        local v29_26
        local v29_27
        local v29_28
        local v29_29
        local v29_30
        local v29_31
        local v29_32
        local v29_33
        local v29_34
        local v29_35
        local v29_36
        local v29_37
        local v29_38
        local v29_39
        local v29_40
        local v29_41
        local v29_42
        local v29_43
        local v29_44
        local v29_45
        local v29_46
        local v29_47
        v29_3 = (p29_0).mCurrentElementIndex
        if not (v29_3 == p29_1) then
            v29_4 = (p29_0).mElements
            v29_5 = v29_4[p29_1]
            v29_6 = IsNull
            v29_7 = v29_6(v29_5)
            if v29_7 then
            else
                v29_8 = (p29_0).mElements
                v29_9 = v29_8[p29_1]
                v29_10 = (v29_9).mInitialized
                if v29_10 then
                    v29_11 = (p29_0).mCurrentElementIndex
                    v29_12 = IsNull
                    v29_13 = v29_12(v29_11)
                    if not (v29_13) then
                        v29_14 = (p29_0).mCurrentElementIndex
                        p29_0:UnfocusElement(v29_14)
                    end
                    v29_17 = (p29_0).mScroll
                    v29_18 = IsNull
                    v29_19 = v29_18(v29_17)
                    local predicate_value_29_6 = (not (v29_19) and not (p29_2))
                    if predicate_value_29_6 then
                        v29_20 = nil
                        v29_21 = (p29_0).mScroll
                        v29_24 = p29_0:GetHowManyVisibleElements()
                        v29_25 = (v29_21 + v29_24)
                        v29_26 = (v29_25 - 1)
                        v29_27 = (p29_0).mScroll
                        if not (p29_1 < v29_27) then
                            if v29_26 < p29_1 then
                                v29_30 = p29_0:GetHowManyVisibleElements()
                                v29_31 = (p29_1 - v29_30)
                                v29_20 = (v29_31 + 1)
                            end
                        else
                            v29_20 = p29_1
                        end
                        v29_32 = v29_20
                        v29_33 = IsNull
                        v29_34 = v29_33(v29_32)
                        if not (v29_34) then
                            v29_35 = v29_20
                            p29_0:SetScroll(v29_35, true)
                            p29_0:Redraw(nil, false, true)
                        end
                    end
                    p29_0.mCurrentElementIndex = p29_1
                    v29_44 = (p29_0).mElements
                    v29_45 = v29_44[p29_1]
                    p29_0:OnFocused(v29_45)
                    return
                end
            end
        end
        return
    end
    frame_85[8].FocusElement = frame_85[129]
    frame_85[130] = function(p30_0, p30_1, p30_2)
        local v30_3
        local v30_4
        local v30_5
        local v30_6
        local v30_7
        local v30_8
        local v30_9
        local v30_10
        local v30_11
        local v30_12
        local v30_13
        v30_3 = p30_1
        v30_6 = p30_0:GetElementIndexById(v30_3)
        v30_7 = v30_6
        v30_8 = IsNull
        v30_9 = v30_8(v30_7)
        if not (v30_9) then
            v30_10 = v30_6
            v30_11 = p30_2
            p30_0:FocusElement(v30_10, v30_11)
        end
        return
    end
    frame_85[8].FocusElementById = frame_85[130]
    frame_85[131] = function(p31_0, p31_1, p31_2)
        local v31_3
        local v31_4
        local v31_5
        local v31_6
        local v31_7
        local v31_8
        local v31_9
        local v31_10
        local v31_11
        local v31_12
        local v31_13
        local v31_14
        local v31_15
        local v31_16
        local v31_17
        local v31_18
        local v31_19
        local v31_20
        local v31_21
        local v31_22
        local v31_23
        local v31_24
        local v31_25
        local v31_26
        local v31_27
        local v31_28
        local v31_29
        local v31_30
        local v31_31
        local v31_32
        local v31_33
        local v31_34
        local v31_35
        local v31_36
        local v31_37
        local v31_38
        local v31_39
        local v31_40
        local v31_41
        local v31_42
        local v31_43
        local v31_44
        local v31_45
        local v31_46
        local v31_47
        local v31_48
        local v31_49
        local v31_50
        local v31_51
        local v31_52
        local v31_53
        local v31_54
        local v31_55
        local v31_56
        local v31_57
        local v31_58
        local v31_59
        local v31_60
        local v31_61
        local v31_62
        v31_3 = 0
        v31_4 = (p31_0).mScroll
        v31_5 = IsNull
        v31_6 = v31_5(v31_4)
        if not (v31_6) then
            v31_7 = (p31_0).mScroll
            v31_3 = (v31_7 - p31_1)
        end
        v31_8 = (p31_0).mCurrentElementIndex
        v31_9 = IsNull
        v31_10 = v31_9(v31_8)
        if not (v31_10) then
            v31_3 = (p31_0).mCurrentElementIndex
        end
        if p31_2 then
            v31_11 = (p31_0).mSelectedElement
            v31_12 = IsNull
            v31_13 = v31_12(v31_11)
            if not (v31_13) then
                v31_14 = (p31_0).mSelectedElement
                v31_3 = (v31_14).mIndex
            end
        end
        v31_15 = (p31_0).mScrollBar
        if not (v31_15 == nil) then
            v31_16 = (p31_0).DOWN
            local sc_31_8
            if p31_1 ~= v31_16 then
                sc_31_8 = true
            else
                v31_17 = (p31_0).mScroll
                v31_20 = p31_0:GetHowManyVisibleElements()
                v31_21 = (v31_17 + v31_20)
                v31_22 = (v31_21 - 1)
                if v31_3 ~= v31_22 then
                    sc_31_8 = true
                else
                    v31_23 = (p31_0).mScrollBar
                    v31_26 = v31_23:GetScrollValue()
                    sc_31_8 = not (v31_26 < 1)
                end
            end
            if sc_31_8 then
                v31_31 = (p31_0).UP
                if not (p31_1 ~= v31_31) then
                    v31_32 = (p31_0).mScroll
                    if not (v31_3 ~= v31_32) then
                        v31_33 = (p31_0).mScrollBar
                        v31_36 = v31_33:GetScrollValue()
                        if 0 < v31_36 then
                            v31_38 = (p31_0).mScrollBar
                            v31_38:ScrollUp()
                        end
                    end
                end
            else
                v31_28 = (p31_0).mScrollBar
                v31_28:ScrollDown()
            end
        end
        v31_41 = (p31_0).mWrapAroundNavigation
        if not (v31_41) then
            v31_53 = Clamp
            v31_54 = (v31_3 + p31_1)
            v31_61 = v31_53(v31_54, 1, p31_0:GetHowManyElements())
            v31_62 = v31_61
            return v31_62
        else
            v31_42 = (p31_0).UTIL
            v31_43 = (v31_42).ToggleValue
            v31_44 = v31_3
            v31_45 = p31_1
            v31_51 = v31_43(v31_44, v31_45, 1, p31_0:GetHowManyElements())
            v31_52 = v31_51
            return v31_52
        end
    end
    frame_85[8].GetIndexInDirection = frame_85[131]
    frame_85[132] = function(p32_0, p32_1)
        local v32_2
        local v32_3
        local v32_4
        local v32_5
        local v32_6
        local v32_7
        local v32_8
        local v32_9
        local v32_10
        local v32_11
        local v32_12
        local v32_13
        local v32_14
        local v32_15
        local v32_16
        local v32_17
        v32_2 = p32_1
        v32_5 = p32_0:GetIndexInDirection(v32_2)
        v32_6 = v32_5
        v32_9 = p32_0:GetElementById(v32_6)
        v32_10 = v32_9
        v32_11 = IsNull
        v32_12 = v32_11(v32_10)
        if not (v32_12) then
            v32_13 = (p32_0).mIgnoreFiller
            if not (v32_13) then
            else
                v32_14 = (v32_9).Filler
                if not (v32_14) then
                else
                    return
                end
            end
        end
        v32_15 = v32_5
        p32_0:FocusElement(v32_15)
        return
    end
    frame_85[8].ToggleFocusedElement = frame_85[132]
    frame_85[133] = function(p33_0)
        local v33_1
        local v33_2
        local v33_3
        local v33_4
        v33_1 = (p33_0).UTIL
        v33_2 = (v33_1).INCREMENT
        p33_0:ToggleFocusedElement(v33_2)
        return
    end
    frame_85[8].FocusNextElement = frame_85[133]
    frame_85[134] = function(p34_0)
        local v34_1
        local v34_2
        local v34_3
        local v34_4
        v34_1 = (p34_0).UTIL
        v34_2 = (v34_1).DECREMENT
        p34_0:ToggleFocusedElement(v34_2)
        return
    end
    frame_85[8].FocusPreviousElement = frame_85[134]
    frame_85[135] = function(p35_0, p35_1)
        local v35_2
        local v35_3
        local v35_4
        local v35_5
        local v35_6
        local v35_7
        local v35_8
        local v35_9
        local v35_10
        local v35_11
        local v35_12
        local v35_13
        local v35_14
        local v35_15
        local v35_16
        local v35_17
        local v35_18
        local v35_19
        local v35_20
        local v35_21
        local v35_22
        local v35_23
        local v35_24
        local v35_25
        local v35_26
        local v35_27
        local v35_28
        local v35_29
        local v35_30
        local v35_31
        local v35_32
        local v35_33
        local v35_34
        local v35_35
        local v35_36
        local v35_37
        local v35_38
        local v35_39
        v35_2 = (p35_0).mElements
        v35_3 = v35_2[p35_1]
        v35_4 = IsNull
        v35_5 = v35_4(v35_3)
        if not (v35_5) then
            v35_6 = (p35_0).mElements
            v35_7 = v35_6[p35_1]
            v35_8 = (v35_7).mInitialized
            if v35_8 then
                v35_9 = (p35_0).mElements
                v35_10 = v35_9[p35_1]
                v35_11 = (p35_0).mOnPressedCallback
                v35_12 = IsNull
                v35_13 = v35_12(v35_11)
                if v35_13 then
                    v35_16 = (p35_0).mClickDrag
                    v35_17 = (v35_16).Enabled
                    if v35_17 then
                        v35_18 = (p35_0).mClickDrag
                        v35_19 = (v35_10).Id
                        v35_18.DragId = v35_19
                        v35_20 = (p35_0).mClickDrag
                        v35_20.DragIndex = p35_1
                        v35_21 = (p35_0).mClickDrag
                        v35_22 = Vector
                        v35_23 = (p35_0).mMovie
                        v35_28 = v35_23:GetNumberVariable("_root", 30)
                        v35_29 = (p35_0).mMovie
                        v35_34 = v35_29:GetNumberVariable("_root", 31)
                        v35_36 = v35_22(v35_28, v35_34, 0)
                        v35_21.InitDownPos = v35_36
                    end
                else
                    v35_14 = (p35_0).mOnPressedCallback
                    v35_15 = v35_10
                    v35_14(v35_15)
                end
                v35_37 = p35_1
                p35_0:StartScrollDrag(v35_37)
            end
        end
        return
    end
    frame_85[8].PressedElement = frame_85[135]
    frame_85[136] = function(p36_0, p36_1)
        local v36_2
        local v36_3
        local v36_4
        local v36_5
        local v36_6
        local v36_7
        local v36_8
        local v36_9
        v36_2 = p36_1
        p36_0:PressedElement(p36_0:GetElementIndexById(v36_2))
        return
    end
    frame_85[8].PressedElementById = frame_85[136]
    frame_85[137] = function(p37_0)
        local v37_1
        local v37_2
        local v37_3
        local v37_4
        local v37_5
        local v37_6
        v37_1 = (p37_0).mCurrentElementIndex
        v37_2 = IsNull
        v37_3 = v37_2(v37_1)
        if not (v37_3) then
            v37_4 = (p37_0).mCurrentElementIndex
            p37_0:PressedElement(v37_4)
        end
        return
    end
    frame_85[8].PressCurrentElement = frame_85[137]
    frame_85[138] = function(p38_0, p38_1, p38_2)
        local frame_38 = {}
        local cfg_38 = 0
        while true do
            if cfg_38 == 0 then
                frame_38[3] = (p38_0).mScrollDrag
                frame_38[4] = (frame_38[3]).Enabled
                if not (frame_38[4]) then
                    cfg_38 = 12
                else
                    cfg_38 = 1
                end
            elseif cfg_38 == 1 then
                frame_38[5] = (p38_0).mScrollDrag
                frame_38[6] = (frame_38[5]).isPressed
                if frame_38[6] then
                    cfg_38 = 4
                else
                    cfg_38 = 2
                end
            elseif cfg_38 == 2 then
                frame_38[7] = (p38_0).mScrollDrag
                frame_38[8] = (frame_38[7]).isDragging
                if frame_38[8] then
                    cfg_38 = 4
                else
                    cfg_38 = 3
                end
            elseif cfg_38 == 3 then
                frame_38[9] = (p38_0).mScrollDrag
                frame_38[10] = (frame_38[9]).isStopping
                if not (frame_38[10]) then
                    cfg_38 = 12
                else
                    cfg_38 = 4
                end
            elseif cfg_38 == 4 then
                frame_38[11] = (p38_0).mScrollDrag
                frame_38[12] = (frame_38[11]).isDragging
                if frame_38[12] then
                    cfg_38 = 6
                else
                    cfg_38 = 5
                end
            elseif cfg_38 == 5 then
                frame_38[13] = (p38_0).mScrollDrag
                frame_38[12] = (frame_38[13]).isStopping
                cfg_38 = 6
            elseif cfg_38 == 6 then
                frame_38[14] = (p38_0).mStopDragScrollingOnSelection
                if not (frame_38[14]) then
                    cfg_38 = 8
                else
                    cfg_38 = 7
                end
            elseif cfg_38 == 7 then
                p38_0:StopScrollDrag()
                p38_0:StopDragging()
                cfg_38 = 8
            elseif cfg_38 == 8 then
                if not (frame_38[12]) then
                    cfg_38 = 22
                else
                    cfg_38 = 9
                end
            elseif cfg_38 == 9 then
                frame_38[19] = (p38_0).mAllowElementSelectionOnScrollDragEnd
                if frame_38[19] then
                    cfg_38 = 22
                else
                    cfg_38 = 10
                end
            elseif cfg_38 == 10 then
                return
            elseif cfg_38 == 12 then
                frame_38[20] = (p38_0).mClickDrag
                frame_38[21] = (frame_38[20]).Enabled
                if not (frame_38[21]) then
                    cfg_38 = 22
                else
                    cfg_38 = 13
                end
            elseif cfg_38 == 13 then
                frame_38[22] = (p38_0).mClickDrag
                frame_38[23] = (frame_38[22]).DragId
                if frame_38[23] == nil then
                    cfg_38 = 22
                else
                    cfg_38 = 14
                end
            elseif cfg_38 == 14 then
                frame_38[24] = true
                frame_38[25] = (p38_0).mClickDrag
                frame_38[25].DragId = nil
                frame_38[27] = (p38_0).mClickDrag
                frame_38[28] = (frame_38[27]).Dragging
                if not (frame_38[28]) then
                    cfg_38 = 20
                else
                    cfg_38 = 15
                end
            elseif cfg_38 == 15 then
                frame_38[29] = (p38_0).UTIL
                frame_38[30] = (frame_38[29]).PlaySound
                frame_38[31] = _G
                frame_38[32] = (frame_38[31]).UISound_EndDrag
                frame_38[30](frame_38[32])
                frame_38[33] = (p38_0).mClickDrag
                frame_38[34] = (frame_38[33]).FocusedIndex
                if frame_38[34] == nil then
                    cfg_38 = 19
                else
                    cfg_38 = 16
                end
            elseif cfg_38 == 16 then
                frame_38[35] = (p38_0).mClickDrag
                frame_38[36] = (frame_38[35]).FocusedIndex
                frame_38[37] = (p38_0).mClickDrag
                frame_38[38] = (frame_38[37]).DragIndex
                if frame_38[36] == frame_38[38] then
                    cfg_38 = 19
                else
                    cfg_38 = 17
                end
            elseif cfg_38 == 17 then
                frame_38[39] = (p38_0).mOnDraggedCallback
                frame_38[40] = IsNull
                frame_38[41] = frame_38[40](frame_38[39])
                if frame_38[41] then
                    cfg_38 = 19
                else
                    cfg_38 = 18
                end
            elseif cfg_38 == 18 then
                frame_38[42] = (p38_0).mOnDraggedCallback
                frame_38[42]()
                cfg_38 = 19
            elseif cfg_38 == 19 then
                frame_38[24] = false
                cfg_38 = 20
            elseif cfg_38 == 20 then
                p38_0:StopDragging()
                if frame_38[24] then
                    cfg_38 = 22
                else
                    cfg_38 = 21
                end
            elseif cfg_38 == 21 then
                return
            elseif cfg_38 == 22 then
                frame_38[45] = (p38_0).mSelectedElement
                frame_38[46] = false
                if frame_38[45] ~= p38_1 then
                    cfg_38 = 28
                else
                    cfg_38 = 23
                end
            elseif cfg_38 == 23 then
                frame_38[47] = (p38_0).mOnDoubleClickCallback
                frame_38[48] = IsNull
                frame_38[49] = frame_38[48](frame_38[47])
                frame_38[46] = (not frame_38[49])
                if not (frame_38[46]) then
                    cfg_38 = 28
                else
                    cfg_38 = 24
                end
            elseif cfg_38 == 24 then
                frame_38[50] = Engine.IsPlayingWithController
                frame_38[46] = frame_38[50]()
                if frame_38[46] then
                    cfg_38 = 28
                else
                    cfg_38 = 25
                end
            elseif cfg_38 == 25 then
                frame_38[51] = Time
                frame_38[52] = frame_38[51]()
                frame_38[53] = (p38_0).mLastPressTime
                frame_38[54] = (frame_38[52] - frame_38[53])
                if frame_38[54] < 0.5 then
                    cfg_38 = 27
                else
                    cfg_38 = 26
                end
            elseif cfg_38 == 26 then
                frame_38[46] = false
                cfg_38 = 28
            elseif cfg_38 == 27 then
                frame_38[46] = true
                cfg_38 = 28
            elseif cfg_38 == 28 then
                frame_38[56] = Time
                frame_38[57] = frame_38[56]()
                p38_0.mLastPressTime = frame_38[57]
                p38_0.mSelectedElement = p38_1
                if not (frame_38[46]) then
                    cfg_38 = 30
                else
                    cfg_38 = 29
                end
            elseif cfg_38 == 29 then
                frame_38[58] = (p38_0).mOnDoubleClickCallback
                frame_38[59] = p38_1
                frame_38[60] = p38_2
                frame_38[61] = frame_38[45]
                frame_38[58](frame_38[59], frame_38[60], frame_38[61])
                return
            elseif cfg_38 == 30 then
                frame_38[62] = (p38_0).mOnSelectedCallback
                frame_38[63] = IsNull
                frame_38[64] = frame_38[63](frame_38[62])
                if frame_38[64] then
                    cfg_38 = 32
                else
                    cfg_38 = 31
                end
            elseif cfg_38 == 31 then
                frame_38[65] = (p38_0).mOnSelectedCallback
                frame_38[66] = p38_1
                frame_38[67] = p38_2
                frame_38[68] = frame_38[45]
                frame_38[65](frame_38[66], frame_38[67], frame_38[68])
                cfg_38 = 32
            elseif cfg_38 == 32 then
                return
            else
                error("invalid control state")
            end
        end
    end
    frame_85[8].OnSelected = frame_85[138]
    frame_85[139] = function(p39_0, p39_1, p39_2)
        local v39_3
        local v39_4
        local v39_5
        local v39_6
        local v39_7
        local v39_8
        local v39_9
        local v39_10
        local v39_11
        local v39_12
        local v39_13
        local v39_14
        v39_3 = (p39_0).mElements
        v39_4 = v39_3[p39_1]
        v39_5 = IsNull
        v39_6 = v39_5(v39_4)
        if not (v39_6) then
            v39_7 = (p39_0).mElements
            v39_8 = v39_7[p39_1]
            v39_9 = (v39_8).mInitialized
            if v39_9 then
                v39_10 = (p39_0).mElements
                v39_11 = v39_10[p39_1]
                v39_12 = p39_2
                p39_0:OnSelected(v39_11, v39_12)
            end
        end
        return
    end
    frame_85[8].SelectElement = frame_85[139]
    frame_85[140] = function(p40_0, p40_1, p40_2)
        local v40_3
        local v40_4
        local v40_5
        local v40_6
        local v40_7
        local v40_8
        local v40_9
        local v40_10
        local v40_11
        local v40_12
        local v40_13
        v40_3 = p40_1
        v40_6 = p40_0:GetElementIndexById(v40_3)
        v40_7 = v40_6
        v40_8 = IsNull
        v40_9 = v40_8(v40_7)
        if not (v40_9) then
            v40_10 = v40_6
            v40_11 = p40_2
            p40_0:SelectElement(v40_10, v40_11)
        end
        return
    end
    frame_85[8].SelectElementById = frame_85[140]
    frame_85[141] = function(p41_0, p41_1)
        local v41_2
        local v41_3
        local v41_4
        local v41_5
        local v41_6
        local v41_7
        local v41_8
        v41_2 = (p41_0).mCurrentElementIndex
        v41_3 = IsNull
        v41_4 = v41_3(v41_2)
        if not (v41_4) then
            v41_5 = (p41_0).mCurrentElementIndex
            v41_6 = p41_1
            p41_0:SelectElement(v41_5, v41_6)
        end
        return
    end
    frame_85[8].SelectCurrentElement = frame_85[141]
    frame_85[142] = function(p42_0, p42_1, p42_2)
        local v42_3
        local v42_4
        local v42_5
        local v42_6
        local v42_7
        local v42_8
        local v42_9
        local v42_10
        local v42_11
        local v42_12
        local v42_13
        local v42_14
        local v42_15
        local v42_16
        local v42_17
        local v42_18
        local v42_19
        local v42_20
        v42_3 = p42_1
        v42_7 = p42_0:GetIndexInDirection(v42_3, true)
        v42_8 = v42_7
        v42_11 = p42_0:GetElementById(v42_8)
        v42_12 = v42_11
        v42_13 = IsNull
        v42_14 = v42_13(v42_12)
        if not (v42_14) then
            v42_15 = (p42_0).mIgnoreFiller
            if not (v42_15) then
            else
                v42_16 = (v42_11).Filler
                if not (v42_16) then
                else
                    return
                end
            end
        end
        v42_17 = v42_7
        v42_18 = p42_2
        p42_0:SelectElement(v42_17, v42_18)
        return
    end
    frame_85[8].SelectElementInDirection = frame_85[142]
    frame_85[143] = function(p43_0, p43_1)
        local v43_2
        local v43_3
        local v43_4
        local v43_5
        local v43_6
        local v43_7
        local v43_8
        local v43_9
        local v43_10
        local v43_11
        local v43_12
        local v43_13
        local v43_14
        local v43_15
        local v43_16
        local v43_17
        local v43_18
        local v43_19
        local v43_20
        local v43_21
        local v43_22
        local v43_23
        local v43_24
        local v43_25
        local v43_26
        local v43_27
        local v43_28
        local v43_29
        local v43_30
        local v43_31
        local v43_32
        local v43_33
        local v43_34
        local v43_35
        local v43_36
        local v43_37
        local v43_38
        local v43_39
        local v43_40
        local v43_41
        local v43_42
        local v43_43
        local v43_44
        local v43_45
        local v43_46
        v43_2 = nil
        v43_3 = nil
        v43_4 = (p43_0).mScroll
        if not (v43_4 == nil) then
            v43_5 = (p43_0).mOriginalButtonHeight
            if not (v43_5 == nil) then
                v43_6 = (p43_0).mScroll
                v43_9 = p43_0:GetHowManyVisibleElements()
                v43_10 = (v43_6 + v43_9)
                v43_11 = (v43_10 - 1)
                v43_12 = (p43_1).mIndex
                if not (v43_11 < v43_12) then
                    v43_20 = (p43_1).mIndex
                    v43_21 = (p43_0).mScroll
                    if not (v43_20 < v43_21) then
                        v43_2 = (p43_0).mOriginalButtonHeight
                        v43_3 = 0
                    else
                        v43_22 = (p43_0).mScroll
                        v43_23 = (p43_1).mIndex
                        v43_24 = (v43_22 - v43_23)
                        v43_25 = (1 - v43_24)
                        v43_26 = (p43_0).mForcedVerticalSeparation
                        v43_2 = (v43_25 * v43_26)
                        v43_27 = (p43_0).mForcedVerticalSeparation
                        v43_28 = (v43_27 - v43_2)
                        v43_3 = (v43_28 / 2)
                    end
                else
                    v43_13 = (p43_1).mIndex
                    v43_14 = (v43_13 - v43_11)
                    v43_15 = (1 - v43_14)
                    v43_16 = (p43_0).mForcedVerticalSeparation
                    v43_2 = (v43_15 * v43_16)
                    v43_17 = (p43_0).mForcedVerticalSeparation
                    v43_18 = (-v43_17)
                    v43_19 = (v43_18 + v43_2)
                    v43_3 = (v43_19 / 2)
                end
                if not (v43_2 == nil) then
                    v43_29 = v43_2
                    v43_31 = math.max
                    v43_32 = v43_31(v43_29, 0.01)
                    v43_2 = v43_32
                    v43_33 = (p43_0).mMovie
                    v43_34 = (p43_1).mClipName
                    v43_37 = v43_2
                    v43_33:Name__52c1b74e(v43_34, "Btn", 15, v43_37)
                    v43_40 = (p43_0).mMovie
                    v43_41 = (p43_1).mClipName
                    v43_44 = v43_3
                    v43_40:Name__52c1b74e(v43_41, "Btn", 1, v43_44)
                end
            end
        end
        return v43_2, v43_3
    end
    frame_85[8].RepositionButton = frame_85[143]
    frame_85[144] = function(p44_0, p44_1, p44_2)
        local v44_3
        local v44_4
        local v44_5
        local v44_6
        local v44_7
        local v44_8
        local v44_9
        local v44_10
        local v44_11
        local v44_12
        local v44_13
        local v44_14
        v44_3 = (p44_0).mSmoothScroll
        if v44_3 then
            v44_4 = p44_1
            p44_0:RepositionButton(v44_4)
        end
        if not (p44_2 ~= nil) then
            v44_7 = print
            v44_7("ERROR: pNeedsElementDrawCallback is nil!")
            v44_9 = Name__8e27a225
            v44_9()
            p44_2 = true
        end
        v44_10 = (p44_0).mElementDrawCallback
        v44_11 = IsNull
        v44_12 = v44_11(v44_10)
        local predicate_value_44_4 = (not (v44_12) and p44_2)
        if predicate_value_44_4 then
            v44_13 = (p44_0).mElementDrawCallback
            v44_14 = p44_1
            v44_13(v44_14)
        end
        return
    end
    frame_85[8].OnDraw = frame_85[144]
    frame_85[145] = function(p45_0, p45_1)
        return
    end
    frame_85[8].OnElementTransitionStarted = frame_85[145]
    frame_85[146] = function(p46_0, p46_1)
        return
    end
    frame_85[8].OnElementTransitionEnded = frame_85[146]
    frame_85[147] = function(p47_0, p47_1)
        local v47_2
        local v47_3
        local v47_4
        local v47_5
        local v47_6
        local v47_7
        local v47_8
        local v47_9
        local v47_10
        local v47_11
        v47_2 = p47_1
        v47_5 = p47_0:CalculateY(v47_2)
        v47_6 = (p47_0).mMovie
        v47_7 = (p47_1).mClipName
        v47_9 = (v47_5 - 20)
        v47_6:SetNumberVariable(v47_7, 1, v47_9)
        return
    end
    frame_85[8].SetupPreInterpolationValues = frame_85[147]
    frame_85[148] = function(p48_0, p48_1)
        local v48_2
        local v48_3
        local v48_4
        local v48_5
        local v48_6
        local v48_7
        local v48_8
        v48_2 = (p48_0).mInterpolationValues
        v48_3 = p48_1
        v48_6 = p48_0:CalculateY(v48_3)
        v48_2[2] = v48_6
        v48_7 = (p48_0).mInterpolationProps
        v48_8 = (p48_0).mInterpolationValues
        return v48_7, v48_8
    end
    frame_85[8].GetInterpolationProperties = frame_85[148]
    frame_85[149] = {}
    frame_85[149][1] = 12
    frame_85[8]._DefaultAlphaInterpolationVars = frame_85[149]
    frame_85[151] = {}
    frame_85[151][1] = 100
    frame_85[8]._DefaultAlphaInterpolationValues = frame_85[151]
    frame_85[153] = function(p49_0, p49_1)
        local v49_2
        local v49_3
        v49_2 = (p49_0)._DefaultAlphaInterpolationVars
        v49_3 = (p49_0)._DefaultAlphaInterpolationValues
        return v49_2, v49_3
    end
    frame_85[8].DefaultAlphaInterpolation = frame_85[153]
    frame_85[154] = function(p50_0)
        local frame_50 = {}
        local cfg_50 = 0
        while true do
            if cfg_50 == 0 then
                frame_50[3] = p50_0:GetHowManyElements()
                frame_50[6] = p50_0:GetHowManyVisibleElements()
                frame_50[7] = 1
                frame_50[8] = frame_50[3]
                frame_50[9] = (p50_0).mScroll
                if frame_50[9] == nil then
                    cfg_50 = 4
                else
                    cfg_50 = 1
                end
            elseif cfg_50 == 1 then
                frame_50[10] = (p50_0).mSmoothScroll
                if not (frame_50[10]) then
                    cfg_50 = 3
                else
                    cfg_50 = 2
                end
            elseif cfg_50 == 2 then
                frame_50[12] = frame_50[9]
                frame_50[13] = math.floor
                frame_50[14] = frame_50[13](frame_50[12])
                frame_50[15] = (p50_0).mLowerBoundBuffer
                frame_50[16] = (frame_50[14] - frame_50[15])
                frame_50[17] = math.max
                frame_50[18] = frame_50[17](1, frame_50[16])
                frame_50[19] = frame_50[18]
                frame_50[20] = (frame_50[19] + frame_50[6])
                frame_50[21] = math.floor
                frame_50[22] = frame_50[21](frame_50[20])
                frame_50[23] = (p50_0).mLowerBoundBuffer
                frame_50[24] = (frame_50[22] + frame_50[23])
                frame_50[25] = (p50_0).mUpperBoundBuffer
                frame_50[26] = (frame_50[24] + frame_50[25])
                return frame_50[19], frame_50[26]
            elseif cfg_50 == 3 then
                frame_50[7] = frame_50[9]
                frame_50[27] = (frame_50[9] + frame_50[6])
                frame_50[8] = (frame_50[27] - 1)
                cfg_50 = 4
            elseif cfg_50 == 4 then
                return frame_50[7], frame_50[8]
            else
                error("invalid control state")
            end
        end
    end
    frame_85[8].GetBounds = frame_85[154]
    frame_85[155] = function(p51_0)
        local v51_1
        local v51_2
        local v51_3
        local v51_4
        local v51_5
        v51_1 = (p51_0).mClipCreatedCallback
        if not (v51_1 == nil) then
            v51_2 = (p51_0).mClipCreatedCallback
            v51_3 = (p51_0).mClipName
            v51_4 = (p51_0).mElements
            v51_5 = v51_4[1]
            v51_2(v51_3, v51_5)
        end
        return
    end
    frame_85[8].OnFirstRedraw = frame_85[155]
    frame_85[156] = function(p53_0, p53_1, p53_2, p53_3)
        local frame_53 = {}
        local cfg_53 = 0
        while true do
            if cfg_53 == 0 then
                frame_53[4] = (p53_0).mMovie
                frame_53[5] = IsNull
                frame_53[6] = frame_53[5](frame_53[4])
                if not (frame_53[6]) then
                    cfg_53 = 2
                else
                    cfg_53 = 1
                end
            elseif cfg_53 == 1 then
                return
            elseif cfg_53 == 2 then
                frame_53[7] = (p53_0).mDisableRedraw
                if not (frame_53[7]) then
                    cfg_53 = 4
                else
                    cfg_53 = 3
                end
            elseif cfg_53 == 3 then
                return
            elseif cfg_53 == 4 then
                frame_53[8] = (p53_0).mHasDrawn
                if not (frame_53[8]) then
                    cfg_53 = 8
                else
                    cfg_53 = 5
                end
            elseif cfg_53 == 5 then
                if not (p53_2) then
                    cfg_53 = 9
                else
                    cfg_53 = 6
                end
            elseif cfg_53 == 6 then
                frame_53[9] = (p53_0).mElements
                frame_53[10] = frame_53[9][1]
                if frame_53[10] == nil then
                    cfg_53 = 9
                else
                    cfg_53 = 7
                end
            elseif cfg_53 == 7 then
                frame_53[11] = (p53_0).mElements
                frame_53[12] = frame_53[11][1]
                frame_53[13] = (frame_53[12]).mInitialized
                if frame_53[13] then
                    cfg_53 = 9
                else
                    cfg_53 = 8
                end
            elseif cfg_53 == 8 then
                p53_0:OnFirstRedraw()
                p53_0.mHasDrawn = true
                cfg_53 = 9
            elseif cfg_53 == 9 then
                frame_53[19] = p53_0:GetHowManyElements()
                frame_53[20] = nil
                frame_53[21] = 0
                frame_53[22] = true
                frame_53[23] = (p53_0).mElementTransitionTime
                if not (p53_3) then
                    cfg_53 = 11
                else
                    cfg_53 = 10
                end
            elseif cfg_53 == 10 then
                frame_53[21] = 0
                frame_53[23] = 0
                cfg_53 = 11
            elseif cfg_53 == 11 then
                if frame_53[19] ~= 0 then
                    cfg_53 = 14
                else
                    cfg_53 = 12
                end
            elseif cfg_53 == 12 then
                frame_53[24] = p53_1
                frame_53[25] = IsNull
                frame_53[26] = frame_53[25](frame_53[24])
                if frame_53[26] then
                    cfg_53 = 14
                else
                    cfg_53 = 13
                end
            elseif cfg_53 == 13 then
                frame_53[27] = p53_1
                frame_53[27]()
                cfg_53 = 14
            elseif cfg_53 == 14 then
                frame_53[30], frame_53[31] = p53_0:GetBounds()
                frame_53[32] = (p53_0).mScroll
                frame_53[33] = true
                frame_53[34] = 1
                frame_53[35] = frame_53[19]
                frame_53[36] = 1
                local leave_for_53_15 = false
                for for_value_53_15 = frame_53[34], frame_53[35], frame_53[36] do
                    frame_53[34] = for_value_53_15
                    cfg_53 = 15
                    while true do
                        if cfg_53 == 15 then
                            frame_53[37] = ResetLineCount
                            frame_53[37](0)
                            frame_53[39] = (p53_0).mElements
                            frame_53[40] = frame_53[39][frame_53[34]]
                            frame_53[41] = nil
                            frame_53[42] = false
                            if not (frame_53[30] <= frame_53[34]) then
                                cfg_53 = 19
                            else
                                cfg_53 = 16
                            end
                        elseif cfg_53 == 16 then
                            if frame_53[34] <= frame_53[31] then
                                cfg_53 = 18
                            else
                                cfg_53 = 17
                            end
                        elseif cfg_53 == 17 then
                            frame_53[42] = false
                            cfg_53 = 19
                        elseif cfg_53 == 18 then
                            frame_53[42] = true
                            cfg_53 = 19
                        elseif cfg_53 == 19 then
                            if not (frame_53[42]) then
                                cfg_53 = 36
                            else
                                cfg_53 = 20
                            end
                        elseif cfg_53 == 20 then
                            frame_53[43] = (frame_53[40]).mClipName
                            if not (frame_53[43]) then
                                cfg_53 = 23
                            else
                                cfg_53 = 21
                            end
                        elseif cfg_53 == 21 then
                            frame_53[44] = (p53_0).mClips
                            frame_53[45] = (frame_53[40]).mClipName
                            frame_53[46] = frame_53[44][frame_53[45]]
                            if frame_53[46] ~= true then
                                cfg_53 = 23
                            else
                                cfg_53 = 22
                            end
                        elseif cfg_53 == 22 then
                            frame_53[41] = (frame_53[40]).mClipName
                            cfg_53 = 34
                        elseif cfg_53 == 23 then
                            frame_53[47] = (frame_53[40]).mOverrideClipName
                            if frame_53[47] == nil then
                                cfg_53 = 25
                            else
                                cfg_53 = 24
                            end
                        elseif cfg_53 == 24 then
                            frame_53[41] = (frame_53[40]).mOverrideClipName
                            cfg_53 = 34
                        elseif cfg_53 == 25 then
                            frame_53[49] = (p53_0).mClips
                            local leave_for_53_28 = false
                            for for_value_53_28_0, for_value_53_28_1 in pairs(frame_53[49]) do
                                frame_53[53], frame_53[54] = for_value_53_28_0, for_value_53_28_1
                                cfg_53 = 26
                                while true do
                                    if cfg_53 == 26 then
                                        if frame_53[54] then
                                            cfg_53 = 28
                                        else
                                            cfg_53 = 27
                                            leave_for_53_28 = true
                                            break
                                        end
                                    elseif cfg_53 == 28 then
                                        break
                                    else
                                        error("invalid control state")
                                    end
                                end
                                if leave_for_53_28 then break end
                            end
                            if not leave_for_53_28 then
                                cfg_53 = 29
                            end
                            if cfg_53 ~= 15 and cfg_53 ~= 16 and cfg_53 ~= 17 and cfg_53 ~= 18 and cfg_53 ~= 19 and cfg_53 ~= 20 and cfg_53 ~= 21 and cfg_53 ~= 22 and cfg_53 ~= 23 and cfg_53 ~= 24 and cfg_53 ~= 25 and cfg_53 ~= 27 and cfg_53 ~= 29 and cfg_53 ~= 30 and cfg_53 ~= 31 and cfg_53 ~= 32 and cfg_53 ~= 33 and cfg_53 ~= 34 and cfg_53 ~= 35 and cfg_53 ~= 36 and cfg_53 ~= 37 and cfg_53 ~= 38 and cfg_53 ~= 39 and cfg_53 ~= 40 and cfg_53 ~= 41 and cfg_53 ~= 43 and cfg_53 ~= 44 and cfg_53 ~= 45 and cfg_53 ~= 46 and cfg_53 ~= 47 and cfg_53 ~= 48 and cfg_53 ~= 49 and cfg_53 ~= 50 and cfg_53 ~= 51 and cfg_53 ~= 52 and cfg_53 ~= 53 and cfg_53 ~= 54 and cfg_53 ~= 55 and cfg_53 ~= 56 and cfg_53 ~= 57 and cfg_53 ~= 58 and cfg_53 ~= 59 and cfg_53 ~= 60 and cfg_53 ~= 61 and cfg_53 ~= 62 and cfg_53 ~= 63 and cfg_53 ~= 64 and cfg_53 ~= 65 and cfg_53 ~= 66 and cfg_53 ~= 67 and cfg_53 ~= 68 and cfg_53 ~= 70 and cfg_53 ~= 71 and cfg_53 ~= 72 and cfg_53 ~= 73 and cfg_53 ~= 74 and cfg_53 ~= 75 then
                                leave_for_53_15 = true
                                break
                            end
                        elseif cfg_53 == 27 then
                            frame_53[41] = frame_53[53]
                            cfg_53 = 29
                        elseif cfg_53 == 29 then
                            frame_53[55] = frame_53[41]
                            frame_53[56] = IsNull
                            frame_53[57] = frame_53[56](frame_53[55])
                            if not (frame_53[57]) then
                                cfg_53 = 33
                            else
                                cfg_53 = 30
                            end
                        elseif cfg_53 == 30 then
                            frame_53[58] = (p53_0).mTopClipIndexUsed
                            frame_53[59] = (frame_53[58] + 1)
                            p53_0.mTopClipIndexUsed = frame_53[59]
                            frame_53[60] = (p53_0).mTopClipIndexUsed
                            if frame_53[60] ~= 1 then
                                cfg_53 = 32
                            else
                                cfg_53 = 31
                            end
                        elseif cfg_53 == 31 then
                            frame_53[41] = (p53_0).mClipName
                            cfg_53 = 33
                        elseif cfg_53 == 32 then
                            frame_53[61] = (p53_0).mClipName
                            frame_53[62] = (p53_0).mTopClipIndexUsed
                            frame_53[63] = tostring
                            frame_53[64] = frame_53[63](frame_53[62])
                            frame_53[41] = (frame_53[61] .. frame_53[64])
                            cfg_53 = 33
                        elseif cfg_53 == 33 then
                            frame_53[65] = (p53_0).mClips
                            frame_53[65][frame_53[41]] = true
                            cfg_53 = 34
                        elseif cfg_53 == 34 then
                            frame_53[67] = (p53_0).mHideExtraClips
                            if not (frame_53[67]) then
                                cfg_53 = 40
                            else
                                cfg_53 = 35
                            end
                        elseif cfg_53 == 35 then
                            frame_53[68] = (p53_0).mMovie
                            frame_53[69] = frame_53[41]
                            do (frame_53[68]):Name__d9713943(frame_53[69], 13, true) end
                            cfg_53 = 40
                        elseif cfg_53 == 36 then
                            frame_53[74] = (frame_53[40]).mClipName
                            if not (frame_53[74]) then
                                cfg_53 = 40
                            else
                                cfg_53 = 37
                            end
                        elseif cfg_53 == 37 then
                            frame_53[75] = (p53_0).mClips
                            frame_53[76] = (frame_53[40]).mClipName
                            frame_53[77] = frame_53[75][frame_53[76]]
                            if frame_53[77] ~= true then
                                cfg_53 = 40
                            else
                                cfg_53 = 38
                            end
                        elseif cfg_53 == 38 then
                            frame_53[78] = (p53_0).mHideExtraClips
                            if not (frame_53[78]) then
                                cfg_53 = 40
                            else
                                cfg_53 = 39
                            end
                        elseif cfg_53 == 39 then
                            frame_53[79] = (p53_0).mMovie
                            frame_53[80] = (frame_53[40]).mClipName
                            do (frame_53[79]):Name__d9713943(frame_53[80], 13, false) end
                            cfg_53 = 40
                        elseif cfg_53 == 40 then
                            frame_53[85] = (frame_53[40]).mForceRedraw
                            if frame_53[85] then
                                cfg_53 = 44
                            else
                                cfg_53 = 41
                            end
                        elseif cfg_53 == 41 then
                            frame_53[86] = (frame_53[40]).mClipName
                            if (frame_53[86] ~= frame_53[41] or p53_2) then
                                cfg_53 = 44
                            else
                                cfg_53 = 43
                            end
                        elseif cfg_53 == 43 then
                            frame_53[87] = (frame_53[40]).mOverrideClipName
                            if frame_53[87] == nil then
                                cfg_53 = 73
                            else
                                cfg_53 = 44
                            end
                        elseif cfg_53 == 44 then
                            frame_53[88] = true
                            frame_53[89] = (frame_53[40]).mClipName
                            if frame_53[89] ~= frame_53[41] then
                                cfg_53 = 50
                            else
                                cfg_53 = 45
                            end
                        elseif cfg_53 == 45 then
                            frame_53[88] = (frame_53[40]).mForceRedraw
                            if frame_53[88] then
                                cfg_53 = 50
                            else
                                cfg_53 = 46
                            end
                        elseif cfg_53 == 46 then
                            frame_53[88] = p53_2
                            if frame_53[88] then
                                cfg_53 = 50
                            else
                                cfg_53 = 47
                            end
                        elseif cfg_53 == 47 then
                            if frame_53[32] == nil then
                                cfg_53 = 49
                            else
                                cfg_53 = 48
                            end
                        elseif cfg_53 == 48 then
                            frame_53[88] = false
                            cfg_53 = 50
                        elseif cfg_53 == 49 then
                            frame_53[88] = true
                            cfg_53 = 50
                        elseif cfg_53 == 50 then
                            frame_53[90] = frame_53[88]
                            frame_53[91] = (frame_53[40]).mClipName
                            if not (frame_53[91]) then
                                cfg_53 = 54
                            else
                                cfg_53 = 51
                            end
                        elseif cfg_53 == 51 then
                            frame_53[92] = (frame_53[40]).mClipName
                            if frame_53[41] == frame_53[92] then
                                cfg_53 = 54
                            else
                                cfg_53 = 52
                            end
                        elseif cfg_53 == 52 then
                            frame_53[93] = (p53_0).mClips
                            frame_53[94] = (frame_53[40]).mClipName
                            frame_53[93][frame_53[94]] = false
                            if frame_53[41] ~= nil then
                                cfg_53 = 54
                            else
                                cfg_53 = 53
                            end
                        elseif cfg_53 == 53 then
                            frame_53[96] = (p53_0).mMovie
                            frame_53[97] = (frame_53[40]).mClipName
                            do (frame_53[96]):EnablePfdeco(frame_53[97]) end
                            frame_53[100] = (p53_0).mMovie
                            frame_53[101] = (frame_53[40]).mClipName
                            do (frame_53[100]):SetNumberVariable(frame_53[101], 12, 0) end
                            frame_53[106] = (p53_0).mMovie
                            frame_53[107] = (frame_53[40]).mClipName
                            do (frame_53[106]):Name__d9713943(frame_53[107], 67, false) end
                            frame_53[40].mClipEnabled = false
                            cfg_53 = 54
                        elseif cfg_53 == 54 then
                            frame_53[40].mClipName = frame_53[41]
                            frame_53[40].mForceRedraw = false
                            frame_53[114] = frame_53[41]
                            frame_53[115] = IsNull
                            frame_53[116] = frame_53[115](frame_53[114])
                            if frame_53[116] then
                                cfg_53 = 75
                            else
                                cfg_53 = 55
                            end
                        elseif cfg_53 == 55 then
                            frame_53[117] = (p53_0).mMovie
                            frame_53[118] = frame_53[41]
                            frame_53[121] = (frame_53[117]):HasVariable(frame_53[118])
                            if frame_53[121] then
                                cfg_53 = 60
                            else
                                cfg_53 = 56
                            end
                        elseif cfg_53 == 56 then
                            frame_53[122] = StringSplit
                            frame_53[124] = frame_53[41]
                            frame_53[125] = frame_53[122](".", frame_53[124])
                            frame_53[126] = FlashMethod
                            frame_53[127] = (p53_0).mMovie
                            frame_53[128] = (p53_0).mClipName
                            frame_53[130] = (frame_53[128] .. ".duplicateMovieClip")
                            frame_53[131] = (#frame_53[125])
                            frame_53[132] = frame_53[125][frame_53[131]]
                            frame_53[133] = (p53_0).mInitialDepth
                            frame_53[134] = (p53_0).mTopClipIndexUsed
                            frame_53[135] = (p53_0).mDepthDirection
                            frame_53[136] = (frame_53[134] * frame_53[135])
                            frame_53[137] = (frame_53[133] + frame_53[136])
                            frame_53[126](frame_53[127], frame_53[130], frame_53[132], frame_53[137])
                            frame_53[138] = (p53_0).mClipCreatedCallback
                            if frame_53[138] == nil then
                                cfg_53 = 58
                            else
                                cfg_53 = 57
                            end
                        elseif cfg_53 == 57 then
                            frame_53[139] = (p53_0).mClipCreatedCallback
                            frame_53[140] = frame_53[41]
                            frame_53[141] = frame_53[40]
                            frame_53[139](frame_53[140], frame_53[141])
                            cfg_53 = 58
                        elseif cfg_53 == 58 then
                            if p53_2 then
                                cfg_53 = 60
                            else
                                cfg_53 = 59
                            end
                        elseif cfg_53 == 59 then
                            frame_53[142] = frame_53[41]
                            p53_0:SetClipCallbacks(frame_53[142])
                            cfg_53 = 60
                        elseif cfg_53 == 60 then
                            if not (p53_2) then
                                cfg_53 = 62
                            else
                                cfg_53 = 61
                            end
                        elseif cfg_53 == 61 then
                            frame_53[145] = frame_53[41]
                            p53_0:SetClipCallbacks(frame_53[145])
                            cfg_53 = 62
                        elseif cfg_53 == 62 then
                            frame_53[148] = (frame_53[40]).mClipEnabled
                            if frame_53[148] then
                                cfg_53 = 64
                            else
                                cfg_53 = 63
                            end
                        elseif cfg_53 == 63 then
                            frame_53[149] = (p53_0).mMovie
                            frame_53[150] = (frame_53[40]).mClipName
                            do (frame_53[149]):Name__d9713943(frame_53[150], 67, true) end
                            frame_53[40].mClipEnabled = true
                            cfg_53 = 64
                        elseif cfg_53 == 64 then
                            frame_53[156] = (p53_0).mMovie
                            frame_53[157] = frame_53[41]
                            frame_53[159] = (frame_53[40]).Id
                            do (frame_53[156]):SetVariable(frame_53[157], "Id", frame_53[159]) end
                            frame_53[162] = (p53_0).mMovie
                            frame_53[163] = frame_53[41]
                            frame_53[165] = (frame_53[163] .. ".Btn")
                            frame_53[167] = (frame_53[40]).Id
                            do (frame_53[162]):SetNumberVariable(frame_53[165], 99, frame_53[167]) end
                            frame_53[170] = (p53_0).mMovie
                            frame_53[171] = frame_53[41]
                            frame_53[173] = frame_53[40]
                            do (frame_53[170]):SetNumberVariable(frame_53[171], 0, p53_0:CalculateX(frame_53[173])) end
                            frame_53[187] = (p53_0).mMovie
                            frame_53[188] = frame_53[41]
                            frame_53[190] = frame_53[40]
                            do (frame_53[187]):SetNumberVariable(frame_53[188], 1, p53_0:CalculateY(frame_53[190])) end
                            frame_53[204] = (frame_53[40]).mInitialized
                            if frame_53[204] then
                                cfg_53 = 66
                            else
                                cfg_53 = 65
                            end
                        elseif cfg_53 == 65 then
                            frame_53[205] = (p53_0).mMovie
                            frame_53[206] = frame_53[41]
                            do (frame_53[205]):SetNumberVariable(frame_53[206], 12, 1) end
                            frame_53[211] = frame_53[40]
                            p53_0:SetupPreInterpolationValues(frame_53[211])
                            cfg_53 = 66
                        elseif cfg_53 == 66 then
                            frame_53[214] = (p53_0).mElementDelayTime
                            frame_53[21] = (frame_53[21] + frame_53[214])
                            frame_53[215] = (p53_0).UTIL
                            frame_53[216] = (frame_53[215]).Ternary
                            frame_53[217] = frame_53[22]
                            frame_53[218] = p53_1
                            frame_53[220] = frame_53[216](frame_53[217], frame_53[218], nil)
                            frame_53[221] = frame_53[40]
                            frame_53[224], frame_53[225] = p53_0:GetInterpolationProperties(frame_53[221])
                            frame_53[226] = frame_53[40]
                            p53_0:OnElementTransitionStarted(frame_53[226])
                            if p53_3 then
                                cfg_53 = 68
                            else
                                cfg_53 = 67
                            end
                        elseif cfg_53 == 67 then
                            local cap_53_279_0 = p53_0
                            local cap_53_279_1 = frame_53[40]
                            local cap_53_279_2 = frame_53[220]
                            frame_53[229] = function()
                                local v52_0
                                local v52_1
                                local v52_2
                                local v52_3
                                local v52_4
                                local v52_5
                                local v52_6
                                local v52_7
                                v52_0 = cap_53_279_0
                                v52_1 = cap_53_279_1
                                v52_0:OnElementTransitionEnded(v52_1)
                                v52_4 = cap_53_279_2
                                v52_5 = IsNull
                                v52_6 = v52_5(v52_4)
                                if not (v52_6) then
                                    v52_7 = cap_53_279_2
                                    v52_7()
                                end
                                return
                            end
                            frame_53[230] = FlashInterpolate
                            frame_53[231] = (p53_0).mMovie
                            frame_53[232] = frame_53[41]
                            frame_53[233] = (p53_0).mEasing
                            frame_53[234] = frame_53[224]
                            frame_53[235] = frame_53[225]
                            frame_53[236] = frame_53[23]
                            frame_53[237] = frame_53[21]
                            frame_53[238] = frame_53[229]
                            frame_53[230](frame_53[231], frame_53[232], frame_53[233], frame_53[234], frame_53[235], frame_53[236], frame_53[237], frame_53[238])
                            cfg_53 = 72
                        elseif cfg_53 == 68 then
                            frame_53[239] = 1
                            frame_53[240] = (#frame_53[224])
                            frame_53[241] = 1
                            local leave_for_53_69 = false
                            for for_value_53_69 = frame_53[239], frame_53[240], frame_53[241] do
                                frame_53[239] = for_value_53_69
                                cfg_53 = 69
                                while true do
                                    if cfg_53 == 69 then
                                        frame_53[242] = (p53_0).mMovie
                                        frame_53[243] = frame_53[41]
                                        frame_53[244] = frame_53[224][frame_53[239]]
                                        frame_53[245] = frame_53[225][frame_53[239]]
                                        do (frame_53[242]):SetNumberVariable(frame_53[243], frame_53[244], frame_53[245]) end
                                        break
                                    else
                                        error("invalid control state")
                                    end
                                end
                                if leave_for_53_69 then break end
                            end
                            if not leave_for_53_69 then
                                cfg_53 = 70
                            end
                            if cfg_53 ~= 15 and cfg_53 ~= 16 and cfg_53 ~= 17 and cfg_53 ~= 18 and cfg_53 ~= 19 and cfg_53 ~= 20 and cfg_53 ~= 21 and cfg_53 ~= 22 and cfg_53 ~= 23 and cfg_53 ~= 24 and cfg_53 ~= 25 and cfg_53 ~= 27 and cfg_53 ~= 29 and cfg_53 ~= 30 and cfg_53 ~= 31 and cfg_53 ~= 32 and cfg_53 ~= 33 and cfg_53 ~= 34 and cfg_53 ~= 35 and cfg_53 ~= 36 and cfg_53 ~= 37 and cfg_53 ~= 38 and cfg_53 ~= 39 and cfg_53 ~= 40 and cfg_53 ~= 41 and cfg_53 ~= 43 and cfg_53 ~= 44 and cfg_53 ~= 45 and cfg_53 ~= 46 and cfg_53 ~= 47 and cfg_53 ~= 48 and cfg_53 ~= 49 and cfg_53 ~= 50 and cfg_53 ~= 51 and cfg_53 ~= 52 and cfg_53 ~= 53 and cfg_53 ~= 54 and cfg_53 ~= 55 and cfg_53 ~= 56 and cfg_53 ~= 57 and cfg_53 ~= 58 and cfg_53 ~= 59 and cfg_53 ~= 60 and cfg_53 ~= 61 and cfg_53 ~= 62 and cfg_53 ~= 63 and cfg_53 ~= 64 and cfg_53 ~= 65 and cfg_53 ~= 66 and cfg_53 ~= 67 and cfg_53 ~= 68 and cfg_53 ~= 70 and cfg_53 ~= 71 and cfg_53 ~= 72 and cfg_53 ~= 73 and cfg_53 ~= 74 and cfg_53 ~= 75 then
                                leave_for_53_15 = true
                                break
                            end
                        elseif cfg_53 == 70 then
                            frame_53[248] = frame_53[40]
                            p53_0:OnElementTransitionEnded(frame_53[248])
                            frame_53[251] = frame_53[220]
                            frame_53[252] = IsNull
                            frame_53[253] = frame_53[252](frame_53[251])
                            if frame_53[253] then
                                cfg_53 = 72
                            else
                                cfg_53 = 71
                            end
                        elseif cfg_53 == 71 then
                            frame_53[254] = frame_53[220]
                            frame_53[254]()
                            cfg_53 = 72
                        elseif cfg_53 == 72 then
                            frame_53[255] = frame_53[40]
                            frame_53[256] = frame_53[90]
                            p53_0:OnDraw(frame_53[255], frame_53[256])
                            frame_53[22] = false
                            cfg_53 = 75
                        elseif cfg_53 == 73 then
                            if frame_53[41] == nil then
                                cfg_53 = 75
                            else
                                cfg_53 = 74
                            end
                        elseif cfg_53 == 74 then
                            frame_53[259] = (p53_0).mMovie
                            frame_53[260] = frame_53[41]
                            frame_53[262] = frame_53[40]
                            do (frame_53[259]):SetNumberVariable(frame_53[260], 0, p53_0:CalculateX(frame_53[262])) end
                            frame_53[276] = (p53_0).mMovie
                            frame_53[277] = frame_53[41]
                            frame_53[279] = frame_53[40]
                            do (frame_53[276]):SetNumberVariable(frame_53[277], 1, p53_0:CalculateY(frame_53[279])) end
                            cfg_53 = 75
                        elseif cfg_53 == 75 then
                            frame_53[40].mInitialized = true
                            break
                        else
                            error("invalid control state")
                        end
                    end
                    if leave_for_53_15 then break end
                end
                if not leave_for_53_15 then
                    cfg_53 = 76
                end
            elseif cfg_53 == 76 then
                frame_53[294] = (p53_0).mRedrawFromScrollBar
                if not (frame_53[294]) then
                    cfg_53 = 78
                else
                    cfg_53 = 77
                end
            elseif cfg_53 == 77 then
                p53_0.mRedrawFromScrollBar = false
                return
            elseif cfg_53 == 78 then
                p53_0:RedrawScrollBar()
                return
            else
                error("invalid control state")
            end
        end
    end
    frame_85[8].Redraw = frame_85[156]
    frame_85[157] = function(p54_0, p54_1, p54_2)
        local v54_3
        local v54_4
        local v54_5
        local v54_6
        local v54_7
        local v54_8
        local v54_9
        local v54_10
        local v54_11
        local v54_12
        local v54_13
        v54_3 = Clamp
        v54_4 = p54_1
        v54_6 = (p54_0).mElements
        v54_7 = (#v54_6)
        v54_9 = math.max
        v54_10 = v54_9(v54_7, 1)
        v54_11 = v54_3(v54_4, 1, v54_10)
        p54_0.mScroll = v54_11
        if not (p54_2) then
            p54_0:Redraw()
        end
        return
    end
    frame_85[8].SetScroll = frame_85[157]
    frame_85[158] = function(p55_0, p55_1)
        local v55_2
        local v55_3
        local v55_4
        local v55_5
        local v55_6
        local v55_7
        local v55_8
        local v55_9
        local v55_10
        local v55_11
        local v55_12
        local v55_13
        v55_2 = p55_1
        v55_3 = IsNull
        v55_4 = v55_3(v55_2)
        if not (v55_4) then
            v55_5 = 1
            v55_6 = (p55_0).mElements
            v55_7 = (#v55_6)
            v55_8 = 1
            for v55_5 = v55_5, v55_7, v55_8 do
                v55_9 = ResetLineCount
                v55_9(0)
                v55_11 = p55_1
                v55_12 = (p55_0).mElements
                v55_13 = v55_12[v55_5]
                v55_11(v55_13)
            end
        end
        return
    end
    frame_85[8].RunForAllElements = frame_85[158]
    frame_85[159] = function(p56_0, p56_1, p56_2)
        local v56_3
        local v56_4
        local v56_5
        local v56_6
        local v56_7
        local v56_8
        local v56_9
        local v56_10
        local v56_11
        local v56_12
        local v56_13
        local v56_14
        local v56_15
        local v56_16
        local v56_17
        local v56_18
        local v56_19
        local v56_20
        local v56_21
        local v56_22
        local v56_23
        local v56_24
        local v56_25
        local v56_26
        v56_3 = 1
        v56_4 = nil
        if not (p56_2) then
            v56_16 = (p56_0).mElements
            v56_15 = (#v56_16)
        else
            v56_7, v56_8 = p56_0:GetBounds()
            v56_3 = v56_7
            v56_9 = v56_8
            v56_10 = (p56_0).mElements
            v56_11 = (#v56_10)
            v56_12 = v56_9
            v56_13 = math.min
            v56_14 = v56_13(v56_12, v56_11)
            v56_15 = v56_14
        end
        v56_17 = v56_3
        v56_18 = v56_15
        v56_19 = 1
        for v56_17 = v56_17, v56_18, v56_19 do
            v56_20 = (p56_0).mElements
            v56_21 = v56_20[v56_17]
            v56_22 = (v56_21).mClipName
            if not (v56_22 == nil) then
                v56_23 = ResetLineCount
                v56_23(0)
                v56_25 = p56_1
                v56_26 = v56_21
                v56_25(v56_26)
            end
        end
        return
    end
    frame_85[8]._RunForAllVisibleElements = frame_85[159]
    frame_85[160] = function(p57_0, p57_1, p57_2)
        local v57_3
        local v57_4
        local v57_5
        local v57_6
        local v57_7
        local v57_8
        local v57_9
        local v57_10
        local v57_11
        local v57_12
        local v57_13
        local v57_14
        local v57_15
        v57_3 = (p57_0).mScroll
        v57_4 = IsNull
        v57_5 = v57_4(v57_3)
        if not (v57_5) then
            v57_9 = p57_1
            v57_10 = IsNull
            v57_11 = v57_10(v57_9)
            if not (v57_11) then
                v57_12 = p57_1
                v57_13 = p57_2
                p57_0:_RunForAllVisibleElements(v57_12, v57_13)
            end
            return
        else
            v57_6 = p57_1
            p57_0:RunForAllElements(v57_6)
            return
        end
    end
    frame_85[8].RunForAllVisibleElements = frame_85[160]
    frame_85[161] = function(p58_0, p58_1)
        local v58_2
        local v58_3
        local v58_4
        local v58_5
        local v58_6
        local v58_7
        v58_2 = (p58_0).Height
        if v58_2 == nil then
            if not (p58_1) then
                p58_1 = 0
            end
            v58_4 = (p58_0).mVisibleElements
            v58_5 = (p58_0).mForcedVerticalSeparation
            v58_6 = (v58_4 * v58_5)
            v58_7 = (v58_6 + p58_1)
            return v58_7
        else
            v58_3 = (p58_0).Height
            return v58_3
        end
    end
    frame_85[8].CalculateScrollBarHeight = frame_85[161]
    frame_85[162] = function(p61_0, p61_1, p61_2)
        local v61_3
        local v61_4
        local v61_5
        local v61_6
        local v61_7
        local v61_8
        local v61_9
        local v61_10
        local v61_11
        local v61_12
        local v61_13
        local v61_14
        local v61_15
        local v61_16
        local v61_17
        local v61_18
        local v61_19
        local v61_20
        local v61_21
        local v61_22
        local v61_23
        local v61_24
        local v61_25
        local v61_26
        local v61_27
        local v61_28
        local v61_29
        local v61_30
        local v61_31
        local v61_32
        local v61_33
        local v61_34
        local v61_35
        local v61_36
        local v61_37
        local v61_38
        local v61_39
        local v61_40
        local v61_41
        local v61_42
        local v61_43
        local v61_44
        local v61_45
        local v61_46
        local v61_47
        local v61_48
        local v61_49
        local v61_50
        local v61_51
        local v61_52
        local v61_53
        local v61_54
        local v61_55
        local v61_56
        local v61_57
        local v61_58
        local v61_59
        local v61_60
        v61_5 = p61_0:GetHowManyElements()
        v61_6 = (p61_0).mVisibleElements
        v61_7 = (v61_5 - v61_6)
        v61_8 = (p61_0).mSmoothScroll
        if v61_8 then
            v61_32 = Clamp
            v61_33 = (v61_7 * p61_1)
            v61_35 = v61_7
            v61_36 = v61_32(v61_33, 0, v61_35)
            v61_37 = (v61_36 + 1)
            v61_38 = (p61_0).mScroll
            if not (v61_37 == v61_38) then
                v61_39 = v61_37
                v61_40 = math.floor
                v61_41 = v61_40(v61_39)
                v61_42 = (p61_0).mScroll
                v61_43 = math.floor
                v61_44 = v61_43(v61_42)
                v61_45 = (v61_41 - v61_44)
                v61_46 = v61_37
                p61_0:SetScroll(v61_46, true)
                local sc_61_4
                if 1 <= v61_45 then
                    sc_61_4 = true
                else
                    sc_61_4 = v61_45 <= -1
                end
                if sc_61_4 then
                    p61_0.mRedrawFromScrollBar = true
                    p61_0:Redraw(nil, false, true)
                end
                local cap_61_65_0 = p61_0
                v61_58 = function(p60_0)
                    local v60_1
                    local v60_2
                    local v60_3
                    local v60_4
                    local v60_5
                    local v60_6
                    local v60_7
                    local v60_8
                    local v60_9
                    local v60_10
                    local v60_11
                    local v60_12
                    local v60_13
                    local v60_14
                    local v60_15
                    local v60_16
                    local v60_17
                    v60_1 = cap_61_65_0
                    v60_2 = (v60_1).mMovie
                    v60_3 = (p60_0).mClipName
                    v60_5 = cap_61_65_0
                    v60_6 = p60_0
                    v60_2:SetNumberVariable(v60_3, 1, v60_5:CalculateY(v60_6))
                    v60_14 = cap_61_65_0
                    v60_15 = p60_0
                    v60_14:RepositionButton(v60_15)
                    return
                end
                p61_0:RunForAllVisibleElements(v61_58)
            end
        else
            v61_9 = Clamp
            v61_10 = (p61_0).UTIL
            v61_11 = (v61_10).Round
            v61_12 = (v61_7 * p61_1)
            v61_13 = v61_11(v61_12)
            v61_15 = v61_7
            v61_16 = v61_9(v61_13, 0, v61_15)
            v61_17 = (v61_16 + 1)
            v61_18 = (p61_0).mScroll
            if v61_17 == v61_18 then
            else
                v61_19 = v61_17
                p61_0:SetScroll(v61_19, true)
                p61_0.mRedrawFromScrollBar = true
                p61_0:Redraw(nil, false, true)
                local cap_61_28_0 = p61_0
                v61_29 = function(p59_0)
                    local v59_1
                    local v59_2
                    local v59_3
                    local v59_4
                    local v59_5
                    local v59_6
                    local v59_7
                    local v59_8
                    local v59_9
                    local v59_10
                    local v59_11
                    local v59_12
                    local v59_13
                    local v59_14
                    local v59_15
                    local v59_16
                    local v59_17
                    v59_1 = cap_61_28_0
                    v59_2 = (v59_1).mMovie
                    v59_3 = (p59_0).mClipName
                    v59_5 = cap_61_28_0
                    v59_6 = p59_0
                    v59_2:SetNumberVariable(v59_3, 1, v59_5:CalculateY(v59_6))
                    v59_14 = cap_61_28_0
                    v59_15 = p59_0
                    v59_14:RepositionButton(v59_15)
                    return
                end
                p61_0:RunForAllVisibleElements(v61_29)
                return
            end
        end
        return
    end
    frame_85[8].ScrollValueChangedCallback = frame_85[162]
    frame_85[163] = function(p62_0)
        local v62_1
        return true
    end
    frame_85[8].CanUseScrollBar = frame_85[163]
    frame_85[164] = function(p64_0, p64_1, p64_2, p64_3)
        local v64_4
        local v64_5
        local v64_6
        local v64_7
        local v64_8
        local v64_9
        local v64_10
        local v64_11
        local v64_12
        local v64_13
        local v64_14
        local v64_15
        local v64_16
        local v64_17
        local v64_18
        local v64_19
        local v64_20
        local v64_21
        local v64_22
        local v64_23
        local v64_24
        local v64_25
        local v64_26
        local v64_27
        local v64_28
        local v64_29
        local v64_30
        local v64_31
        local v64_32
        local v64_33
        local v64_34
        local v64_35
        local v64_36
        local v64_37
        local v64_38
        local v64_39
        p64_0.mScrollBarClipName = p64_1
        v64_4 = (p64_0).mScrollBarClipName
        if not (v64_4 == nil) then
            p64_0:SetScroll(1, true)
            v64_9 = (p64_2 or 0)
            p64_0.mDeltaScrollBarSize = v64_9
            v64_10 = require
            v64_12 = v64_10("EE.Interface.Components.ScrollBar")
            v64_13 = (v64_12).CreateScrollBar
            v64_14 = (p64_0).mMovie
            v64_15 = (p64_0).mScrollBarClipName
            v64_16 = (p64_0).mDeltaScrollBarSize
            v64_19 = p64_0:CalculateScrollBarHeight(v64_16)
            v64_21 = p64_3
            v64_22 = v64_13(v64_14, v64_15, v64_19, 0.5, v64_21)
            p64_0.mScrollBar = v64_22
            v64_23 = (p64_0).mMovie
            v64_24 = (p64_0).mScrollBarClipName
            v64_23:Name__d9713943(v64_24, 13, false)
            v64_29 = (p64_0).mScrollBar
            local cap_64_29_0 = p64_0
            v64_30 = function(p63_0, p63_1)
                local v63_2
                local v63_3
                local v63_4
                local v63_5
                local v63_6
                v63_2 = cap_64_29_0
                v63_3 = p63_0
                v63_4 = p63_1
                v63_2:ScrollValueChangedCallback(v63_3, v63_4)
                return
            end
            v64_29.mScrollValueChangedCallback = v64_30
            v64_31 = (p64_0).mScrollBar
            v64_31:HookUpCallbacks()
            v64_34 = (p64_0).mScrollBar
            v64_34:Initialize()
            v64_37 = p64_3
            p64_0:EnableDragScrolling(v64_37)
        end
        return
    end
    frame_85[8].AttachScrollBar = frame_85[164]
    frame_85[165] = function(p65_0)
        local v65_1
        local v65_2
        local v65_3
        local v65_4
        local v65_5
        local v65_6
        local v65_7
        local v65_8
        local v65_9
        local v65_10
        local v65_11
        local v65_12
        local v65_13
        local v65_14
        local v65_15
        local v65_16
        local v65_17
        local v65_18
        local v65_19
        local v65_20
        local v65_21
        local v65_22
        local v65_23
        local v65_24
        local v65_25
        local v65_26
        local v65_27
        local v65_28
        local v65_29
        local v65_30
        local v65_31
        local v65_32
        local v65_33
        local v65_34
        local v65_35
        local v65_36
        local v65_37
        local v65_38
        local v65_39
        local v65_40
        local v65_41
        local v65_42
        local v65_43
        local v65_44
        local v65_45
        local v65_46
        local v65_47
        local v65_48
        local v65_49
        local v65_50
        local v65_51
        local v65_52
        local v65_53
        local v65_54
        local v65_55
        v65_1 = (p65_0).mScrollBarClipName
        if not (v65_1 == nil) then
            v65_2 = (p65_0).mScrollBar
            if not (v65_2 == nil) then
                v65_3 = (p65_0).mScrollBar
                v65_4 = (v65_3).mDragging
                if not (v65_4) then
                    v65_7 = p65_0:GetHowManyElements()
                    v65_10 = p65_0:GetHowManyVisibleElements()
                    v65_11 = false
                    if v65_10 < v65_7 then
                        v65_11 = p65_0:CanUseScrollBar()
                    end
                    v65_14 = (p65_0).mMovie
                    v65_15 = (p65_0).mScrollBarClipName
                    v65_17 = (p65_0).mScrollAlwaysVisible
                    v65_18 = (v65_17 or v65_11)
                    v65_14:Name__d9713943(v65_15, 13, v65_18)
                    v65_21 = (p65_0).mMovie
                    v65_22 = (p65_0).mScrollBarClipName
                    v65_25 = v65_11
                    v65_21:Makeposshield(v65_22, "Scrub", 13, v65_25)
                    v65_28 = (p65_0).mScrollBar
                    v65_29 = v65_11
                    v65_28:SetEnabled(v65_29)
                    if v65_11 then
                        v65_34 = p65_0:GetHowManyElements()
                        v65_35 = (p65_0).mVisibleElements
                        v65_36 = (v65_34 - v65_35)
                        if not (v65_7 == 0) then
                            v65_37 = (p65_0).mScrollBar
                            v65_38 = (p65_0).mVisibleElements
                            v65_39 = (v65_38 / v65_7)
                            v65_37.mVisibleProp = v65_39
                        end
                        if not (v65_36 == 0) then
                            v65_40 = (p65_0).mScrollBar
                            v65_41 = (p65_0).mScroll
                            v65_42 = (v65_41 - 1)
                            v65_43 = (v65_42 / v65_36)
                            v65_40.mCurrentScroll = v65_43
                        end
                        v65_44 = (p65_0).mScrollBar
                        v65_45 = (p65_0).mDeltaScrollBarSize
                        v65_48 = p65_0:CalculateScrollBarHeight(v65_45)
                        v65_44:SetHeight(v65_48, true)
                        v65_52 = (p65_0).mVisibleElements
                        v65_53 = (v65_7 - v65_52)
                        if not (v65_53 == 0) then
                            v65_54 = (p65_0).mScrollBar
                            v65_55 = (1 / v65_53)
                            v65_54.mScrollStep = v65_55
                        end
                    end
                end
            end
        end
        return
    end
    frame_85[8].RedrawScrollBar = frame_85[165]
    frame_85[166] = function(p68_0, p68_1, p68_2, p68_3, p68_4, p68_5, p68_6, p68_7)
        local v68_8
        local v68_9
        local v68_10
        local v68_11
        local v68_12
        local v68_13
        local v68_14
        local v68_15
        local v68_16
        local v68_17
        local v68_18
        local v68_19
        local v68_20
        local v68_21
        local v68_22
        local v68_23
        local v68_24
        local v68_25
        local v68_26
        local v68_27
        local v68_28
        local v68_29
        local v68_30
        local v68_31
        local v68_32
        local v68_33
        local v68_34
        local v68_35
        local v68_36
        local v68_37
        local v68_38
        local v68_39
        local predicate_value_68_0 = (not (p68_1 == nil) and not (p68_2 == nil))
        if predicate_value_68_0 then
            v68_8 = require
            v68_10 = v68_8("EE.Interface.Components.ListContainer")
            v68_11 = (v68_10).CreateListContainer
            v68_12 = (p68_0).mMovie
            v68_13 = p68_1
            v68_14 = p68_2
            v68_15 = p68_3
            v68_16 = p68_4
            v68_17 = p68_5
            v68_18 = p68_6
            v68_19 = p68_7
            v68_20 = v68_11(v68_12, v68_13, v68_14, v68_15, v68_16, v68_17, v68_18, v68_19)
            p68_0.mListContainer = v68_20
            v68_21 = (p68_0).mMovie
            v68_22 = p68_1
            v68_24 = p68_2
            v68_25 = (v68_22 .. "." .. v68_24)
            v68_21:Name__d9713943(v68_25, 13, true)
            v68_30 = (p68_0).mListContainer
            v68_30:HookUpCallbacks()
            v68_33 = (p68_0).mListContainer
            v68_33:Initialize()
            v68_36 = (p68_0).mListContainer
            local cap_68_32_0 = p68_0
            v68_37 = function()
                local v66_0
                local v66_1
                local v66_2
                local v66_3
                v66_0 = cap_68_32_0
                v66_0:StartScrollDrag(nil)
                return
            end
            v68_36.mStartDragCallback = v68_37
            v68_38 = (p68_0).mListContainer
            local cap_68_36_0 = p68_0
            v68_39 = function()
                local v67_0
                local v67_1
                local v67_2
                v67_0 = cap_68_36_0
                v67_0:StopScrollDrag()
                return
            end
            v68_38.mStopDragCallback = v68_39
        end
        return
    end
    frame_85[8].AttachListContainer = frame_85[166]
    frame_85[167] = function(p69_0)
        local v69_1
        local v69_2
        local v69_3
        local v69_4
        local v69_5
        local v69_6
        local v69_7
        local v69_8
        local v69_9
        v69_1 = (p69_0).mScroll
        if not (v69_1 == nil) then
            v69_2 = (p69_0).mForcedVerticalSeparation
            if v69_2 ~= nil then
                p69_0.mSmoothScroll = true
                v69_8 = (p69_0).mScrollBar
                v69_8.mEnableSmoothScroll = true
                return
            end
        end
        v69_3 = print
        v69_3("Error: Smooth scroll dependencies failed!")
        v69_6 = assert
        v69_6(false)
        return
    end
    frame_85[8].EnableSmoothScroll = frame_85[167]
    frame_85[168] = function(p70_0)
        local v70_1
        local v70_2
        local v70_3
        local v70_4
        local v70_5
        local v70_6
        local v70_7
        local v70_8
        local v70_9
        local v70_10
        local v70_11
        local v70_12
        local v70_13
        local v70_14
        local v70_15
        local v70_16
        local v70_17
        local v70_18
        local v70_19
        local v70_20
        v70_1 = (p70_0).mClickDrag
        v70_1.DragId = nil
        v70_3 = (p70_0).mMovie
        v70_4 = (p70_0).mClickDrag
        v70_5 = (v70_4).DragClipName
        v70_3:Name__d9713943(v70_5, 13, false)
        v70_10 = (p70_0).mClickDrag
        v70_10.Dragging = false
        v70_12 = (p70_0).mClickDrag
        v70_12.FocusedIndex = nil
        v70_14 = (p70_0).mClickDrag
        v70_14.DragIndex = nil
        v70_16 = (p70_0).mOnDragEndCallback
        v70_17 = IsNull
        v70_18 = v70_17(v70_16)
        if not (v70_18) then
            p70_0:mOnDragEndCallback()
        end
        return
    end
    frame_85[8].StopDragging = frame_85[168]
    frame_85[169] = function(p71_0)
        local v71_1
        local v71_2
        local v71_3
        local v71_4
        local v71_5
        local v71_6
        local v71_7
        local v71_8
        local v71_9
        local v71_10
        local v71_11
        local v71_12
        local v71_13
        local v71_14
        local v71_15
        local v71_16
        local v71_17
        local v71_18
        local v71_19
        local v71_20
        local v71_21
        local v71_22
        local v71_23
        local v71_24
        local v71_25
        local v71_26
        local v71_27
        local v71_28
        local v71_29
        local v71_30
        local v71_31
        local v71_32
        v71_1 = { Enabled = true, Dragging = false, DistThresh = 20 }
        p71_0.mClickDrag = v71_1
        v71_2 = Engine.IsMobile
        v71_3 = v71_2()
        if v71_3 then
            v71_4 = (p71_0).mClickDrag
            v71_4.DistThresh = 5
        end
        v71_6 = StringSplit
        v71_8 = (p71_0).mClipName
        v71_9 = v71_6(".", v71_8)
        v71_10 = (p71_0).mClickDrag
        v71_10.RootClip = ""
        v71_12 = (#v71_9)
        if 1 < v71_12 then
            v71_14 = (#v71_9)
            v71_15 = (v71_14 - 1)
            v71_16 = 1
            v71_17 = v71_15
            v71_18 = 1
            for v71_16 = v71_16, v71_17, v71_18 do
                v71_19 = (p71_0).mClickDrag
                v71_20 = (p71_0).mClickDrag
                v71_21 = (v71_20).RootClip
                v71_22 = v71_9[v71_16]
                v71_23 = (v71_21 .. v71_22)
                v71_19.RootClip = v71_23
                if not (v71_16 == v71_15) then
                    v71_24 = (p71_0).mClickDrag
                    v71_25 = (p71_0).mClickDrag
                    v71_26 = (v71_25).RootClip
                    v71_28 = (v71_26 .. ".")
                    v71_24.RootClip = v71_28
                end
            end
        end
        v71_29 = (p71_0).mClickDrag
        v71_30 = (p71_0).mClipName
        v71_32 = (v71_30 .. "Drag")
        v71_29.DragClipName = v71_32
        return
    end
    frame_85[8].EnableDrag = frame_85[169]
    frame_85[170] = function(p72_0)
        local v72_1
        local v72_2
        local v72_3
        local v72_4
        local v72_5
        local v72_6
        local v72_7
        local v72_8
        local v72_9
        local v72_10
        local v72_11
        local v72_12
        local v72_13
        local v72_14
        local v72_15
        local v72_16
        local v72_17
        local v72_18
        local v72_19
        local v72_20
        local v72_21
        local v72_22
        local v72_23
        local v72_24
        local v72_25
        local v72_26
        local v72_27
        local v72_28
        local v72_29
        local v72_30
        local v72_31
        local v72_32
        local v72_33
        local v72_34
        local v72_35
        local v72_36
        local v72_37
        local v72_38
        local v72_39
        local v72_40
        local v72_41
        local v72_42
        local v72_43
        local v72_44
        local v72_45
        local v72_46
        local v72_47
        local v72_48
        local v72_49
        local v72_50
        local v72_51
        local v72_52
        local v72_53
        local v72_54
        local v72_55
        local v72_56
        local v72_57
        local v72_58
        local v72_59
        local v72_60
        local v72_61
        local v72_62
        local v72_63
        local v72_64
        local v72_65
        local v72_66
        local v72_67
        local v72_68
        local v72_69
        local v72_70
        local v72_71
        local v72_72
        local v72_73
        local v72_74
        local v72_75
        local v72_76
        local v72_77
        local v72_78
        local v72_79
        local v72_80
        local v72_81
        local v72_82
        local v72_83
        local v72_84
        local v72_85
        local v72_86
        local v72_87
        v72_1 = (p72_0).DragElement
        if v72_1 then
            v72_2 = (p72_0).mClickDrag
            v72_3 = (p72_0).DragElement
            v72_5 = (v72_3 .. "Drag")
            v72_2.DragClipName = v72_5
        end
        v72_6 = (p72_0).mMovie
        v72_7 = (p72_0).mClickDrag
        v72_8 = (v72_7).DragClipName
        v72_11 = v72_6:HasVariable(v72_8)
        if not (v72_11) then
            v72_12 = StringSplit
            v72_14 = (p72_0).mClipName
            v72_15 = v72_12(".", v72_14)
            v72_16 = (p72_0).mTopClipIndexUsed
            v72_17 = (v72_16 + 1)
            p72_0.mTopClipIndexUsed = v72_17
            v72_18 = (p72_0).mClipName
            v72_19 = (#v72_15)
            v72_20 = v72_15[v72_19]
            v72_21 = (p72_0).DragElement
            if v72_21 then
                v72_18 = (p72_0).DragElement
                v72_22 = StringSplit
                v72_24 = (p72_0).DragElement
                v72_25 = v72_22(".", v72_24)
                v72_26 = (#v72_25)
                v72_20 = v72_25[v72_26]
            end
            v72_27 = FlashMethod
            v72_28 = (p72_0).mMovie
            v72_29 = v72_18
            v72_31 = (v72_29 .. ".duplicateMovieClip")
            v72_32 = v72_20
            v72_34 = (v72_32 .. "Drag")
            v72_35 = (p72_0).mInitialDepth
            v72_36 = (p72_0).mTopClipIndexUsed
            v72_37 = (p72_0).mDepthDirection
            v72_38 = (v72_36 * v72_37)
            v72_39 = (v72_35 + v72_38)
            v72_27(v72_28, v72_31, v72_34, v72_39)
        end
        v72_40 = (p72_0).mClickDrag
        v72_41 = (v72_40).DragId
        v72_44 = p72_0:GetElementById(v72_41)
        v72_45 = (v72_44).mClipName
        v72_46 = (p72_0).mClickDrag
        v72_47 = (v72_46).DragClipName
        v72_44.mClipName = v72_47
        v72_48 = (p72_0).mClipCreatedCallback
        v72_49 = IsNull
        v72_50 = v72_49(v72_48)
        if not (v72_50) then
            v72_51 = (p72_0).mClipCreatedCallback
            v72_52 = (v72_44).mClipName
            v72_51(v72_52)
        end
        v72_53 = (p72_0).mElementDrawCallback
        v72_54 = IsNull
        v72_55 = v72_54(v72_53)
        if not (v72_55) then
            v72_56 = (p72_0).mElementDrawCallback
            v72_57 = v72_44
            v72_56(v72_57)
        end
        v72_44.mClipName = v72_45
        v72_58 = (p72_0).mMovie
        v72_59 = (p72_0).mClickDrag
        v72_60 = (v72_59).DragClipName
        v72_58:Name__d9713943(v72_60, 13, true)
        v72_65 = (p72_0).mMovie
        v72_66 = (p72_0).mClickDrag
        v72_67 = (v72_66).DragClipName
        v72_69 = (p72_0).mDragAlpha
        if v72_69 == nil then
            v72_70 = 60
        else
            v72_70 = (p72_0).mDragAlpha
        end
        v72_65:SetNumberVariable(v72_67, 12, v72_70)
        v72_73 = (p72_0).mMovie
        v72_74 = (p72_0).mClickDrag
        v72_75 = (v72_74).DragClipName
        v72_77 = (v72_75 .. "Btn")
        v72_73:Name__d9713943(v72_77, 67, false)
        v72_82 = (p72_0).mClickDrag
        v72_82.Dragging = true
        v72_84 = (p72_0).UTIL
        v72_85 = (v72_84).PlaySound
        v72_86 = _G
        v72_87 = (v72_86).UISound_StartDrag
        v72_85(v72_87)
        return
    end
    frame_85[8].CreateDragClip = frame_85[170]
    frame_85[171] = function(p74_0)
        local frame_74 = {}
        local cfg_74 = 0
        while true do
            if cfg_74 == 0 then
                frame_74[1] = Vector
                frame_74[2] = (p74_0).mMovie
                frame_74[7] = (frame_74[2]):GetNumberVariable("_root", 30)
                frame_74[8] = (p74_0).mMovie
                frame_74[13] = (frame_74[8]):GetNumberVariable("_root", 31)
                frame_74[15] = frame_74[1](frame_74[7], frame_74[13], 0)
                frame_74[16] = (p74_0).mClickDrag
                frame_74[17] = (frame_74[16]).Dragging
                if frame_74[17] then
                    cfg_74 = 9
                else
                    cfg_74 = 1
                end
            elseif cfg_74 == 1 then
                frame_74[18] = Distance
                frame_74[19] = frame_74[15]
                frame_74[20] = (p74_0).mClickDrag
                frame_74[21] = (frame_74[20]).InitDownPos
                frame_74[22] = frame_74[18](frame_74[19], frame_74[21])
                frame_74[23] = (p74_0).mClickDrag
                frame_74[24] = (frame_74[23]).DistThresh
                if not (frame_74[24] < frame_74[22]) then
                    cfg_74 = 9
                else
                    cfg_74 = 2
                end
            elseif cfg_74 == 2 then
                frame_74[25] = (p74_0).mClickDrag
                frame_74[26] = (frame_74[25]).DragId
                frame_74[29] = p74_0:GetElementById(frame_74[26])
                if not (frame_74[29]) then
                    cfg_74 = 6
                else
                    cfg_74 = 3
                end
            elseif cfg_74 == 3 then
                frame_74[30] = (frame_74[29]).DisableDrag
                if frame_74[30] == nil then
                    cfg_74 = 5
                else
                    cfg_74 = 4
                end
            elseif cfg_74 == 4 then
                frame_74[31] = (frame_74[29]).DisableDrag
                if frame_74[31] then
                    cfg_74 = 6
                else
                    cfg_74 = 5
                end
            elseif cfg_74 == 5 then
                p74_0:CreateDragClip()
                cfg_74 = 7
            elseif cfg_74 == 6 then
                frame_74[34] = (p74_0).mClickDrag
                frame_74[34].DragId = nil
                frame_74[36] = (p74_0).mClickDrag
                frame_74[36].DragIndex = nil
                cfg_74 = 7
            elseif cfg_74 == 7 then
                if not (frame_74[29]) then
                    cfg_74 = 9
                else
                    cfg_74 = 8
                end
            elseif cfg_74 == 8 then
                frame_74[38] = (frame_74[29]).Id
                p74_0:UnfocusElementById(frame_74[38])
                cfg_74 = 9
            elseif cfg_74 == 9 then
                frame_74[41] = (p74_0).mClickDrag
                frame_74[42] = (frame_74[41]).Dragging
                if not (frame_74[42]) then
                    cfg_74 = 24
                else
                    cfg_74 = 10
                end
            elseif cfg_74 == 10 then
                frame_74[43] = (frame_74[15]).x
                frame_74[44] = (frame_74[15]).y
                frame_74[45] = (p74_0).mClickDrag
                frame_74[46] = (frame_74[45]).RootClip
                if frame_74[46] == "" then
                    cfg_74 = 12
                else
                    cfg_74 = 11
                end
            elseif cfg_74 == 11 then
                frame_74[47] = (p74_0).UTIL
                frame_74[48] = (frame_74[47]).GetRootBasedPosition
                frame_74[49] = (p74_0).mMovie
                frame_74[50] = (p74_0).mClickDrag
                frame_74[51] = (frame_74[50]).RootClip
                frame_74[52], frame_74[53] = frame_74[48](frame_74[49], frame_74[51])
                frame_74[43] = (frame_74[43] - frame_74[52])
                frame_74[44] = (frame_74[44] - frame_74[53])
                cfg_74 = 12
            elseif cfg_74 == 12 then
                frame_74[54] = frame_74[43]
                frame_74[55] = frame_74[44]
                frame_74[56] = (p74_0).DragRootOverride
                if frame_74[56] == nil then
                    cfg_74 = 14
                else
                    cfg_74 = 13
                end
            elseif cfg_74 == 13 then
                frame_74[57] = (p74_0).UTIL
                frame_74[58] = (frame_74[57]).GetRootBasedPosition
                frame_74[59] = (p74_0).mMovie
                frame_74[60] = (p74_0).DragRootOverride
                frame_74[61], frame_74[62] = frame_74[58](frame_74[59], frame_74[60])
                frame_74[63] = (frame_74[15]).x
                frame_74[54] = (frame_74[63] - frame_74[61])
                frame_74[64] = (frame_74[15]).y
                frame_74[55] = (frame_74[64] - frame_74[62])
                cfg_74 = 14
            elseif cfg_74 == 14 then
                frame_74[65] = (p74_0).mMovie
                frame_74[66] = (p74_0).mClickDrag
                frame_74[67] = (frame_74[66]).DragClipName
                frame_74[69] = frame_74[54]
                do (frame_74[65]):SetNumberVariable(frame_74[67], 0, frame_74[69]) end
                frame_74[72] = (p74_0).mMovie
                frame_74[73] = (p74_0).mClickDrag
                frame_74[74] = (frame_74[73]).DragClipName
                frame_74[76] = frame_74[55]
                do (frame_74[72]):SetNumberVariable(frame_74[74], 1, frame_74[76]) end
                frame_74[79] = Vector
                frame_74[80] = frame_74[43]
                frame_74[81] = frame_74[44]
                frame_74[83] = frame_74[79](frame_74[80], frame_74[81], 0)
                frame_74[84] = nil
                frame_74[85] = 0
                local cap_74_96_0 = p74_0
                local cap_74_96_1 = frame_74[83]
                frame_74[86] = function(p73_0)
                    local v73_1
                    local v73_2
                    local v73_3
                    local v73_4
                    local v73_5
                    local v73_6
                    local v73_7
                    local v73_8
                    local v73_9
                    local v73_10
                    local v73_11
                    local v73_12
                    local v73_13
                    local v73_14
                    local v73_15
                    local v73_16
                    local v73_17
                    local v73_18
                    local v73_19
                    local v73_20
                    local v73_21
                    local v73_22
                    local v73_23
                    local v73_24
                    local v73_25
                    local v73_26
                    local v73_27
                    local v73_28
                    local v73_29
                    local v73_30
                    local v73_31
                    local v73_32
                    local v73_33
                    local v73_34
                    local v73_35
                    local v73_36
                    v73_1 = 0
                    v73_2 = 0
                    v73_3 = cap_74_96_0
                    v73_4 = (v73_3).mGetElementCenter
                    if v73_4 == nil then
                        v73_12 = cap_74_96_0
                        v73_13 = (v73_12).mMovie
                        v73_14 = (p73_0).mClipName
                        v73_18 = v73_13:GetNumberVariable(v73_14, 0)
                        v73_10 = v73_18
                        v73_19 = cap_74_96_0
                        v73_20 = (v73_19).mMovie
                        v73_21 = (p73_0).mClipName
                        v73_25 = v73_20:GetNumberVariable(v73_21, 1)
                        v73_11 = v73_25
                    else
                        v73_5 = cap_74_96_0
                        v73_6 = (v73_5).mGetElementCenter
                        v73_7 = p73_0
                        v73_8, v73_9 = v73_6(v73_7)
                        v73_10 = v73_8
                        v73_11 = v73_9
                    end
                    v73_26 = Distance
                    v73_27 = Vector
                    v73_28 = v73_10
                    v73_29 = v73_11
                    v73_31 = v73_27(v73_28, v73_29, 0)
                    v73_32 = cap_74_96_1
                    v73_33 = v73_26(v73_31, v73_32)
                    v73_34 = frame_74[84]
                    local bridge_73_3
                    if v73_34 == nil then
                        bridge_73_3 = true
                    else
                        v73_35 = frame_74[85]
                        bridge_73_3 = not (not (v73_33 < v73_35))
                    end
                    if bridge_73_3 then
                        v73_36 = (p73_0).mIndex
                        frame_74[84] = v73_36
                        frame_74[85] = v73_33
                    end
                    return
                end
                p74_0:RunForAllVisibleElements(frame_74[86])
                frame_74[89] = (p74_0).mClickDrag
                frame_74[90] = (frame_74[89]).FocusedIndex
                if frame_74[90] == nil then
                    cfg_74 = 16
                else
                    cfg_74 = 15
                end
            elseif cfg_74 == 15 then
                frame_74[91] = (p74_0).mClickDrag
                frame_74[92] = (frame_74[91]).FocusedIndex
                if frame_74[84] == frame_74[92] then
                    cfg_74 = 23
                else
                    cfg_74 = 16
                end
            elseif cfg_74 == 16 then
                frame_74[93] = (p74_0).mClickDrag
                frame_74[94] = (frame_74[93]).FocusedIndex
                if frame_74[94] == nil then
                    cfg_74 = 19
                else
                    cfg_74 = 17
                end
            elseif cfg_74 == 17 then
                frame_74[95] = (p74_0).mOnDragUnfocusedCallback
                if frame_74[95] == nil then
                    cfg_74 = 19
                else
                    cfg_74 = 18
                end
            elseif cfg_74 == 18 then
                frame_74[96] = (p74_0).mClickDrag
                frame_74[97] = (frame_74[96]).FocusedIndex
                frame_74[100] = p74_0:GetElementInIndex(frame_74[97])
                frame_74[101] = (p74_0).mOnDragUnfocusedCallback
                frame_74[102] = frame_74[100]
                frame_74[101](frame_74[102])
                cfg_74 = 19
            elseif cfg_74 == 19 then
                frame_74[103] = (p74_0).mClickDrag
                frame_74[104] = (frame_74[103]).DragIndex
                if frame_74[84] == frame_74[104] then
                    cfg_74 = 22
                else
                    cfg_74 = 20
                end
            elseif cfg_74 == 20 then
                frame_74[105] = (p74_0).mClickDrag
                frame_74[105].FocusedIndex = frame_74[84]
                frame_74[106] = (p74_0).mOnDragFocusedCallback
                if frame_74[106] == nil then
                    cfg_74 = 23
                else
                    cfg_74 = 21
                end
            elseif cfg_74 == 21 then
                frame_74[107] = (p74_0).mClickDrag
                frame_74[108] = (frame_74[107]).FocusedIndex
                frame_74[111] = p74_0:GetElementInIndex(frame_74[108])
                frame_74[112] = (p74_0).mOnDragFocusedCallback
                frame_74[113] = frame_74[111]
                frame_74[112](frame_74[113])
                cfg_74 = 23
            elseif cfg_74 == 22 then
                frame_74[114] = (p74_0).mClickDrag
                frame_74[114].FocusedIndex = nil
                cfg_74 = 23
            elseif cfg_74 == 23 then
                cfg_74 = 24
            elseif cfg_74 == 24 then
                return
            else
                error("invalid control state")
            end
        end
    end
    frame_85[8].UpdateDrag = frame_85[171]
    frame_85[172] = function(p77_0, p77_1)
        local v77_2
        local v77_3
        local v77_4
        local v77_5
        local v77_6
        v77_2 = Engine.IsMobile
        v77_3 = v77_2()
        if v77_3 then
            v77_4 = { Enabled = true, isPressed = false, isDragging = false, isStopping = false, ignoreDrag = false, isHorizontal = nil, DistThresh = 5, Sensitivity = 1 }
            v77_4.isHorizontal = p77_1
            p77_0.mScrollDrag = v77_4
            v77_5 = function(p75_0)
                local v75_1
                return 1
            end
            p77_0.GetDragScrollIncrement = v77_5
            v77_6 = function(p76_0)
                local v76_1
                local v76_2
                local v76_3
                local v76_4
                local v76_5
                local v76_6
                local v76_7
                local v76_8
                local v76_9
                local v76_10
                local v76_11
                local v76_12
                v76_1 = 0
                v76_2 = (p76_0).mForcedVerticalSeparation
                v76_3 = IsNull
                v76_4 = v76_3(v76_2)
                if v76_4 then
                    v76_6 = (p76_0).mMovie
                    v76_7 = (p76_0).mClipName
                    v76_11 = v76_6:GetNumberVariable(v76_7, 15)
                    v76_12 = v76_11
                    return v76_12
                else
                    v76_5 = (p76_0).mForcedVerticalSeparation
                    return v76_5
                end
            end
            p77_0.GetMouseDragScrollStep = v77_6
            return
        else
            return
        end
    end
    frame_85[8].EnableDragScrolling = frame_85[172]
    frame_85[173] = function(p80_0, p80_1, p80_2, p80_3, p80_4)
        local v80_5
        local v80_6
        local v80_7
        local v80_8
        local v80_9
        local v80_10
        local v80_11
        local v80_12
        local v80_13
        local v80_14
        local v80_15
        local v80_16
        local v80_17
        local v80_18
        local v80_19
        local v80_20
        local v80_21
        local v80_22
        local v80_23
        local v80_24
        local v80_25
        local v80_26
        local v80_27
        local v80_28
        local v80_29
        local v80_30
        local v80_31
        local v80_32
        local v80_33
        local v80_34
        v80_5 = function(p78_0, p78_1)
            local v78_2
            local v78_3
            local v78_4
            v78_2 = (p78_0 * p78_0)
            v78_3 = (p78_1 * p78_1)
            v78_4 = (v78_2 + v78_3)
            return v78_4
        end
        v80_6 = function(p79_0)
            local v79_1
            local v79_2
            v79_1 = (p79_0 * 180)
            v79_2 = (v79_1 / 3.141592653589793)
            return v79_2
        end
        v80_7 = (p80_2).x
        v80_8 = (p80_1).x
        v80_9 = (v80_7 - v80_8)
        v80_10 = (p80_2).y
        v80_11 = (p80_1).y
        v80_12 = (v80_10 - v80_11)
        v80_13 = (v80_9 * v80_9)
        v80_14 = (v80_12 * v80_12)
        v80_15 = (v80_13 + v80_14)
        v80_16 = (p80_3 * p80_3)
        if not (v80_15 < v80_16) then
            v80_18 = v80_9
            v80_19 = math.abs
            v80_20 = v80_19(v80_18)
            v80_21 = v80_20
            v80_22 = v80_12
            v80_23 = math.abs
            v80_24 = v80_23(v80_22)
            v80_25 = v80_24
            v80_26 = v80_21
            v80_27 = math.atan2
            v80_28 = v80_27(v80_25, v80_26)
            v80_29 = (v80_28 * 180)
            v80_30 = (v80_29 / 3.141592653589793)
            if not (v80_30 <= p80_4) then
                v80_32 = (90 - p80_4)
                if not (v80_32 <= v80_30) then
                    v80_34 = (p80_0).MOVE_NONE
                    return v80_34
                else
                    v80_33 = (p80_0).MOVE_VERTICAL
                    return v80_33
                end
            else
                v80_31 = (p80_0).MOVE_HORIZONTAL
                return v80_31
            end
        else
            v80_17 = (p80_0).MOVE_NONE
            return v80_17
        end
    end
    frame_85[8].GetTouchMoveDirection = frame_85[173]
    frame_85[174] = function(p81_0, p81_1, p81_2)
        local v81_3
        local v81_4
        local v81_5
        local v81_6
        local v81_7
        local v81_8
        local v81_9
        local v81_10
        local v81_11
        local v81_12
        local v81_13
        local v81_14
        local v81_15
        v81_3 = false
        v81_4 = (p81_0).mScrollDrag
        v81_5 = (v81_4).Enabled
        if v81_5 then
            v81_6 = p81_2
            v81_9 = p81_0:UpdateScrollDrag(v81_6)
            v81_3 = v81_9
        end
        if not (v81_3) then
            v81_10 = (p81_0).mClickDrag
            v81_11 = (v81_10).Enabled
            if v81_11 then
                v81_12 = (p81_0).mClickDrag
                v81_13 = (v81_12).DragId
                if not (v81_13 == nil) then
                    p81_0:UpdateDrag()
                end
            end
        end
        return v81_3
    end
    frame_85[8].Update = frame_85[174]
    frame_85[175] = function(p82_0, p82_1)
        local v82_2
        local v82_3
        local v82_4
        local v82_5
        local v82_6
        local v82_7
        local v82_8
        local v82_9
        local v82_10
        local v82_11
        local v82_12
        local v82_13
        local v82_14
        local v82_15
        local v82_16
        local v82_17
        local v82_18
        local v82_19
        local v82_20
        local v82_21
        local v82_22
        local v82_23
        local v82_24
        local v82_25
        local v82_26
        local v82_27
        local v82_28
        local v82_29
        local v82_30
        local v82_31
        local v82_32
        local v82_33
        local v82_34
        local v82_35
        local v82_36
        local v82_37
        local v82_38
        local v82_39
        local v82_40
        local v82_41
        local v82_42
        local v82_43
        local v82_44
        local v82_45
        v82_2 = (p82_0).mScrollDrag
        v82_3 = (v82_2).Enabled
        if v82_3 then
            v82_4 = p82_1
            v82_7 = p82_0:GetElementIndexById(v82_4)
            v82_8 = nil
            v82_9 = v82_7
            v82_10 = IsNull
            v82_11 = v82_10(v82_9)
            if not (v82_11) then
                v82_12 = (p82_0).mElements
                v82_13 = v82_12[v82_7]
                if not (v82_13 == nil) then
                    v82_14 = (p82_0).mMovie
                    v82_15 = (v82_13).mClipName
                    v82_19 = v82_14:GetStringVariable(v82_15, 23)
                    v82_8 = v82_19
                end
            end
            if not (v82_8 == nil) then
                v82_20 = (p82_0).mMovie
                v82_23 = v82_20:GetFocusParent()
                if not (v82_23 == v82_8) then
                    v82_24 = (p82_0).mScrollDrag
                    v82_24.ignoreDrag = true
                end
            end
            v82_26 = (p82_0).mScrollDrag
            v82_26.isPressed = true
            v82_28 = (p82_0).mScrollDrag
            v82_28.isStopping = false
            v82_30 = (p82_0).mScrollDrag
            v82_31 = Vector
            v82_32 = (p82_0).mMovie
            v82_37 = v82_32:GetNumberVariable("_root", 30)
            v82_38 = (p82_0).mMovie
            v82_43 = v82_38:GetNumberVariable("_root", 31)
            v82_45 = v82_31(v82_37, v82_43, 0)
            v82_30.InitDownPos = v82_45
        end
        return
    end
    frame_85[8].StartScrollDrag = frame_85[175]
    frame_85[176] = function(p83_0)
        local v83_1
        local v83_2
        local v83_3
        local v83_4
        local v83_5
        local v83_6
        local v83_7
        local v83_8
        local v83_9
        local v83_10
        local v83_11
        local v83_12
        v83_1 = (p83_0).mScrollDrag
        v83_1.isPressed = false
        v83_3 = (p83_0).mScrollDrag
        v83_4 = (v83_3).Enabled
        if v83_4 then
            v83_5 = (p83_0).mScrollDrag
            v83_6 = (v83_5).isDragging
            if v83_6 then
                v83_7 = (p83_0).mScrollDrag
                v83_7.isDragging = false
                v83_9 = (p83_0).mScrollDrag
                v83_9.isStopping = true
                v83_11 = (p83_0).mScrollDrag
                v83_11.ignoreDrag = false
            end
        end
        return
    end
    frame_85[8].StopScrollDrag = frame_85[176]
    frame_85[177] = function(p84_0, p84_1)
        local frame_84 = {}
        local cfg_84 = 0
        while true do
            if cfg_84 == 0 then
                frame_84[2] = (p84_0).mScrollDrag
                frame_84[3] = (frame_84[2]).Enabled
                if not (frame_84[3]) then
                    cfg_84 = 31
                else
                    cfg_84 = 1
                end
            elseif cfg_84 == 1 then
                frame_84[4] = (p84_0).mScrollDrag
                frame_84[5] = (frame_84[4]).isPressed
                if not (frame_84[5]) then
                    cfg_84 = 31
                else
                    cfg_84 = 2
                end
            elseif cfg_84 == 2 then
                frame_84[6] = Vector
                frame_84[7] = (p84_0).mMovie
                frame_84[12] = (frame_84[7]):GetNumberVariable("_root", 30)
                frame_84[13] = (p84_0).mMovie
                frame_84[18] = (frame_84[13]):GetNumberVariable("_root", 31)
                frame_84[20] = frame_84[6](frame_84[12], frame_84[18], 0)
                frame_84[21] = (p84_0).mScrollDrag
                frame_84[22] = (frame_84[21]).isDragging
                if not (frame_84[22]) then
                    cfg_84 = 24
                else
                    cfg_84 = 3
                end
            elseif cfg_84 == 3 then
                frame_84[23] = (p84_0).mScrollDrag
                frame_84[24] = (frame_84[23]).ignoreDrag
                if frame_84[24] then
                    cfg_84 = 24
                else
                    cfg_84 = 4
                end
            elseif cfg_84 == 4 then
                frame_84[25] = (p84_0).UTIL
                frame_84[26] = (frame_84[25]).Ternary
                frame_84[27] = (p84_0).mScrollBar
                frame_84[28] = IsNull
                frame_84[29] = frame_84[28](frame_84[27])
                frame_84[30] = (not frame_84[29])
                frame_84[31] = (p84_0).mScrollBar
                frame_84[32] = p84_1
                frame_84[33] = frame_84[26](frame_84[30], frame_84[31], frame_84[32])
                if not (frame_84[33]) then
                    cfg_84 = 12
                else
                    cfg_84 = 5
                end
            elseif cfg_84 == 5 then
                frame_84[34] = Vector
                frame_84[35] = (p84_0).mMovie
                frame_84[40] = (frame_84[35]):GetNumberVariable("_root", 30)
                frame_84[41] = (p84_0).mMovie
                frame_84[46] = (frame_84[41]):GetNumberVariable("_root", 31)
                frame_84[48] = frame_84[34](frame_84[40], frame_84[46], 0)
                frame_84[49] = (frame_84[48]).y
                frame_84[50] = (p84_0).mScrollDrag
                frame_84[51] = (frame_84[50]).InitDownPos
                frame_84[52] = (frame_84[51]).y
                frame_84[53] = (p84_0).mScrollDrag
                frame_84[54] = (frame_84[53]).isHorizontal
                if not (frame_84[54]) then
                    cfg_84 = 7
                else
                    cfg_84 = 6
                end
            elseif cfg_84 == 6 then
                frame_84[49] = (frame_84[48]).x
                frame_84[55] = (p84_0).mScrollDrag
                frame_84[56] = (frame_84[55]).InitDownPos
                frame_84[52] = (frame_84[56]).x
                cfg_84 = 7
            elseif cfg_84 == 7 then
                if not (0 < frame_84[49]) then
                    cfg_84 = 23
                else
                    cfg_84 = 8
                end
            elseif cfg_84 == 8 then
                frame_84[58] = (frame_84[49] - frame_84[52])
                frame_84[59] = (-frame_84[58])
                frame_84[60] = (p84_0).mScrollDrag
                frame_84[61] = (frame_84[60]).Sensitivity
                frame_84[62] = (frame_84[59] * frame_84[61])
                frame_84[63] = (p84_0).mScrollDrag
                frame_84[64] = (frame_84[63]).isHorizontal
                if not (frame_84[64]) then
                    cfg_84 = 10
                else
                    cfg_84 = 9
                end
            elseif cfg_84 == 9 then
                frame_84[65] = (p84_0).mScrollDrag
                frame_84[66] = (frame_84[65]).InitDownPos
                frame_84[66].x = frame_84[49]
                cfg_84 = 11
            elseif cfg_84 == 10 then
                frame_84[67] = (p84_0).mScrollDrag
                frame_84[68] = (frame_84[67]).InitDownPos
                frame_84[68].y = frame_84[49]
                cfg_84 = 11
            elseif cfg_84 == 11 then
                frame_84[71] = p84_0:GetMouseDragScrollStep()
                frame_84[72] = (frame_84[62] / frame_84[71])
                frame_84[73] = (frame_84[33]).mScrollStep
                frame_84[74] = (frame_84[72] * frame_84[73])
                frame_84[75] = (p84_0).mScrollDrag
                frame_84[76] = (frame_84[75]).Sensitivity
                frame_84[77] = (frame_84[74] * frame_84[76])
                frame_84[78] = frame_84[77]
                do (frame_84[33]):ScrollBy(frame_84[78]) end
                cfg_84 = 23
            elseif cfg_84 == 12 then
                frame_84[81] = (frame_84[20]).y
                frame_84[82] = (p84_0).mScrollDrag
                frame_84[83] = (frame_84[82]).InitDownPos
                frame_84[84] = (frame_84[83]).y
                frame_84[85] = (p84_0).mScrollDrag
                frame_84[86] = (frame_84[85]).isHorizontal
                if not (frame_84[86]) then
                    cfg_84 = 14
                else
                    cfg_84 = 13
                end
            elseif cfg_84 == 13 then
                frame_84[81] = (frame_84[20]).x
                frame_84[87] = (p84_0).mScrollDrag
                frame_84[88] = (frame_84[87]).InitDownPos
                frame_84[84] = (frame_84[88]).x
                cfg_84 = 14
            elseif cfg_84 == 14 then
                if not (0 < frame_84[81]) then
                    cfg_84 = 23
                else
                    cfg_84 = 15
                end
            elseif cfg_84 == 15 then
                frame_84[90] = (frame_84[81] - frame_84[84])
                frame_84[91] = (p84_0).mScrollDrag
                frame_84[92] = (frame_84[91]).Sensitivity
                frame_84[93] = (frame_84[90] * frame_84[92])
                frame_84[96] = p84_0:GetMouseDragScrollStep()
                frame_84[97] = (frame_84[93] / frame_84[96])
                frame_84[98] = math.modf
                frame_84[99] = frame_84[98](frame_84[97])
                if frame_84[99] == 0 then
                    cfg_84 = 23
                else
                    cfg_84 = 16
                end
            elseif cfg_84 == 16 then
                frame_84[100] = (frame_84[99] * frame_84[96])
                frame_84[101] = (p84_0).mScrollDrag
                frame_84[102] = (frame_84[101]).Sensitivity
                frame_84[103] = (frame_84[100] / frame_84[102])
                frame_84[104] = (frame_84[84] + frame_84[103])
                frame_84[105] = (p84_0).mScrollDrag
                frame_84[106] = (frame_84[105]).isHorizontal
                if not (frame_84[106]) then
                    cfg_84 = 18
                else
                    cfg_84 = 17
                end
            elseif cfg_84 == 17 then
                frame_84[107] = (p84_0).mScrollDrag
                frame_84[108] = (frame_84[107]).InitDownPos
                frame_84[108].x = frame_84[104]
                cfg_84 = 19
            elseif cfg_84 == 18 then
                frame_84[109] = (p84_0).mScrollDrag
                frame_84[110] = (frame_84[109]).InitDownPos
                frame_84[110].y = frame_84[104]
                cfg_84 = 19
            elseif cfg_84 == 19 then
                frame_84[113] = p84_0:GetDragScrollIncrement()
                frame_84[114] = (frame_84[99] * frame_84[113])
                frame_84[115] = (p84_0).mScroll
                frame_84[116] = (frame_84[115] - frame_84[114])
                frame_84[117] = (p84_0).GetClampedScroll
                if frame_84[117] == nil then
                    cfg_84 = 21
                else
                    cfg_84 = 20
                end
            elseif cfg_84 == 20 then
                frame_84[118] = frame_84[116]
                frame_84[121] = p84_0:GetClampedScroll(frame_84[118])
                frame_84[122] = frame_84[121]
                cfg_84 = 22
            elseif cfg_84 == 21 then
                frame_84[123] = Clamp
                frame_84[124] = frame_84[116]
                frame_84[128] = p84_0:GetHowManyElements()
                frame_84[131] = p84_0:GetHowManyVisibleElements()
                frame_84[132] = (frame_84[128] - frame_84[131])
                frame_84[133] = (frame_84[132] + 1)
                frame_84[134] = frame_84[123](frame_84[124], 1, frame_84[133])
                frame_84[122] = frame_84[134]
                cfg_84 = 22
            elseif cfg_84 == 22 then
                frame_84[135] = frame_84[122]
                p84_0:SetScroll(frame_84[135], true)
                cfg_84 = 23
            elseif cfg_84 == 23 then
                return true
            elseif cfg_84 == 24 then
                frame_84[140] = Distance
                frame_84[141] = frame_84[20]
                frame_84[142] = (p84_0).mScrollDrag
                frame_84[143] = (frame_84[142]).InitDownPos
                frame_84[144] = frame_84[140](frame_84[141], frame_84[143])
                frame_84[145] = (p84_0).mScrollDrag
                frame_84[146] = (frame_84[145]).DistThresh
                if not (frame_84[146] < frame_84[144]) then
                    cfg_84 = 31
                else
                    cfg_84 = 25
                end
            elseif cfg_84 == 25 then
                frame_84[147] = (p84_0).mScrollDrag
                frame_84[148] = (frame_84[147]).InitDownPos
                frame_84[149] = frame_84[20]
                frame_84[154] = p84_0:GetTouchMoveDirection(frame_84[148], frame_84[149], 1, 35)
                frame_84[155] = (p84_0).MOVE_HORIZONTAL
                if frame_84[154] ~= frame_84[155] then
                    cfg_84 = 27
                else
                    cfg_84 = 26
                end
            elseif cfg_84 == 26 then
                frame_84[156] = (p84_0).mScrollDrag
                frame_84[157] = (frame_84[156]).isHorizontal
                if frame_84[157] then
                    cfg_84 = 29
                else
                    cfg_84 = 27
                end
            elseif cfg_84 == 27 then
                frame_84[158] = (p84_0).MOVE_VERTICAL
                if frame_84[154] ~= frame_84[158] then
                    cfg_84 = 30
                else
                    cfg_84 = 28
                end
            elseif cfg_84 == 28 then
                frame_84[159] = (p84_0).mScrollDrag
                frame_84[160] = (frame_84[159]).isHorizontal
                if frame_84[160] then
                    cfg_84 = 30
                else
                    cfg_84 = 29
                end
            elseif cfg_84 == 29 then
                frame_84[161] = (p84_0).mScrollDrag
                frame_84[161].isDragging = true
                return true
            elseif cfg_84 == 30 then
                p84_0:StopScrollDrag()
                return false
            elseif cfg_84 == 31 then
                return false
            else
                error("invalid control state")
            end
        end
    end
    frame_85[8].UpdateScrollDrag = frame_85[177]
    return frame_85[8]
end
CreateList = v86_3
return
