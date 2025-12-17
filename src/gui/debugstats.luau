local imgui = require("@rimgui")
local window = require("@window")
local rl = require("@raylib")

local task = zune.task

local self
self = window.Create("LuanosEngine - DebugStats", function(pool3d, pool2d, drawn3d)
    imgui.Text("Renderer Stats")
    if imgui.BeginChild("##Renderer Stats Container", nil, true) then
        imgui.Text(tostring(rl.GetFPS()) .. " FPS")
        imgui.Text(tostring(task.count()) .. " tasks")
        imgui.Text(tostring(pool3d) .. " 3D render pool")
        imgui.Text(tostring(pool2d) .. " 2D render pool")
        imgui.Text(tostring(drawn3d) .. " drawn objects")
    end; imgui.EndChild()
end)

self.defaultSize = imgui.NewImVec2(250, 350)
return self