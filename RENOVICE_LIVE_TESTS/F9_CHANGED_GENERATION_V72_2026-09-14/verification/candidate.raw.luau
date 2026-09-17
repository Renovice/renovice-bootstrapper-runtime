  local v0, v1, v2, v3, v4, v5
  v0 = false
  v1 = function(c1v0, c1v1, c1v2, c1v3)
    local c1v4, c1v5, c1v6
    c1v4 = v0
    if not c1v4 then
      do return end
    end
    c1v6 = 25
    local __renovice_local_0 = c1v0
    if __renovice_local_0 == c1v6 then
      c1v6 = 10
      __renovice_local_0 = c1v1
      if __renovice_local_0 == c1v6 then
        c1v4 = type
        c1v4 = c1v4(c1v3)
        c1v6 = "table"
        __renovice_local_0 = c1v4
        if __renovice_local_0 ~= c1v6 then
          do return end
        end
        c1v4 = c1v3[1]
        c1v5 = IsNull
        c1v5 = c1v5(c1v4)
        if c1v5 then
          do return end
        end
        c1v5 = false
        c1v4.maxSuitReq = c1v5
        do return end
      end
    end
    do return end
  end
  v2 = { generationProbe = "F9_CHANGED_GENERATION_V72", activate = nil, cleanup = nil, hooks = nil }
  v3 = function()
    local c2v0
    c2v0 = true
    v0 = c2v0
    do return end
  end
  v2.activate = v3
  v3 = function()
    local c3v0
    c3v0 = false
    v0 = c3v0
    do return end
  end
  v2.cleanup = v3
  v3 = { nativeCalls = nil }
  v4 = { BuildMissionForLocation = nil }
  v5 = { after = nil }
  v5.after = v1
  v4.BuildMissionForLocation = v5
  v3.nativeCalls = v4
  v2.hooks = v3
  do return v2 end
