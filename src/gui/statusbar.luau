local imgui = require("@rimgui")
local window = require("@window")

local height = 24
local padding = vector.create(8, 8)
local paddingBuf = imgui.NewImVec2(padding.x, padding.y)
local flags = 0

local self = {}
self = window.Create(function()
    height = imgui.GetTextLineHeightWithSpacing() + padding.y
    if imgui.BeginViewportSideBar("StatusBar", imgui.GetMainViewport(), imgui.Dir.Down, height, flags) == 1 then
        imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, paddingBuf)
        local avail = imgui.GetContentRegionAvail()
        local availY = buffer.readf32(avail, 4)
        local offY = availY - padding.y * 2
        local height = vector.create(0,height-offY)
        imgui.SetCursorPosY(padding.y/2)
        imgui.Text("warning or smn")
        imgui.PopStyleVar()
    end

	imgui.End()
end)
return self