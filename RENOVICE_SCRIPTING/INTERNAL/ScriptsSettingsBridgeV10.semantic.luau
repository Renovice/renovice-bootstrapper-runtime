local v4_0
local v4_1
local v4_2
local v4_3
local v4_4
local v4_5
local v4_6
local v4_7
local v4_8
v4_0 = require
v4_2 = v4_0("Lotus.Interface.LotusUtilities")
local cap_4_4_0 = v4_2
v4_3 = function(p1_0, p1_1, p1_2, p1_3, p1_4)
    local v1_5
    local v1_6
    local v1_7
    local v1_8
    local v1_9
    local v1_10
    local v1_11
    local v1_12
    local v1_13
    local v1_14
    local v1_15
    local v1_16
    local v1_17
    local v1_18
    local v1_19
    local v1_20
    local v1_21
    local v1_22
    local v1_23
    local v1_24
    local v1_25
    local v1_26
    local v1_27
    local v1_28
    local v1_29
    local v1_30
    local v1_31
    local v1_32
    local v1_33
    local v1_34
    local v1_35
    local v1_36
    local v1_37
    local v1_38
    local v1_39
    local v1_40
    local v1_41
    local v1_42
    local v1_43
    local v1_44
    local v1_45
    local v1_46
    local v1_47
    local v1_48
    local v1_49
    local v1_50
    local v1_51
    local v1_52
    local v1_53
    local v1_54
    local v1_55
    local v1_56
    local v1_57
    local v1_58
    local v1_59
    local v1_60
    local v1_61
    local v1_62
    local v1_63
    local v1_64
    v1_5 = IsNull
    v1_6 = p1_0
    v1_7 = v1_5(v1_6)
    if not (v1_7) then
        v1_8 = IsNull
        v1_9 = p1_1
        v1_10 = v1_8(v1_9)
        if not (v1_10) then
            v1_12 = p1_1
            v1_15 = p1_0:PushChildMovie(v1_12)
            v1_16 = IsNull
            v1_17 = v1_15
            v1_18 = v1_16(v1_17)
            if not (v1_18) then
                v1_20 = _T._RENOVICEScriptsNativeElementsV10
                if v1_20 ~= nil then
                    v1_24 = cap_4_4_0
                    v1_25 = (v1_24).CHECKBOX
                    v1_26 = v1_25
                    v1_27 = type
                    v1_28 = v1_27(v1_26)
                    v1_30 = v1_28
                    if v1_30 == "number" then
                        v1_34 = _T
                        local cap_1_39_0 = v1_20
                        local cap_1_39_1 = v1_25
                        v1_35 = function()
                            local v0_0
                            local v0_1
                            local v0_2
                            local v0_3
                            v0_0 = cap_1_39_0
                            v0_1 = cap_1_39_1
                            return v0_0(v0_1)
                        end
                        v1_34[p1_2] = v1_35
                        v1_15:Execute("SetTitle", "SCRIPTS")
                        v1_15:Execute("SetNoElementsMessage", "NO SCRIPTS FOUND")
                        v1_15:Execute("SetConfirmButtonVisibleWhenInactive", "true")
                        v1_15:Execute("SetConfirmButtonActive", "true")
                        v1_53 = p1_4
                        v1_15:Execute("SetCallBack", v1_53)
                        v1_57 = p1_3
                        v1_15:Execute("SetValueChangedCallBack", v1_57)
                        v1_61 = p1_2
                        v1_15:Execute("SetElementsFunction", v1_61)
                        return true
                    else
                        v1_15:Close()
                        return false
                    end
                else
                    v1_15:Close()
                    return false
                end
            else
                return false
            end
        end
    end
    return false
end
v4_4 = _T
v4_4._RENOVICEScriptsOpenBridgeV10 = v4_3
v4_5 = { activate = nil, cleanup = nil, hooks = nil }
local cap_4_9_0 = v4_3
v4_6 = function()
    local v2_0
    local v2_1
    v2_0 = _T
    v2_1 = cap_4_9_0
    v2_0._RENOVICEScriptsOpenBridgeV10 = v2_1
    return
end
v4_5.activate = v4_6
local cap_4_12_0 = v4_3
v4_7 = function()
    local v3_0
    local v3_1
    local v3_2
    local v3_3
    v3_0 = _T._RENOVICEScriptsOpenBridgeV10
    v3_1 = cap_4_12_0
    if not (v3_0 ~= v3_1) then
        v3_2 = _T
        v3_2._RENOVICEScriptsOpenBridgeV10 = nil
    end
    return
end
v4_5.cleanup = v4_7
v4_8 = { openScriptsSettings = nil }
v4_8.openScriptsSettings = v4_3
v4_5.hooks = v4_8
return v4_5
