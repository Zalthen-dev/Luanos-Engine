local imgui = require("@imgui")
local gizmo = require("@gizmo")
local window = require("@window")

local height = 48
local padding = vector.create(8, 8)
local paddingBuf = imgui.NewImVec2(padding.x, padding.y)
local flags = 0

gizmo:SetTool("Rotate")
gizmo:GetTool()
gizmo:SetSpace("Global")
gizmo:GetSpace()

local self = {}
self = window.Create(function()

    if imgui.BeginViewportSideBar("Toolbar", imgui.GetMainViewport(), imgui.Dir.Up, height, flags) == 1 then
        --imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, paddingBuf)

        local avail = imgui.GetContentRegionAvail()
        local availY = buffer.readf32(avail, 4)
        local offY = availY - padding.y * 2

        if imgui.Button("Select",vector.create(0,height-offY)) == 1 then
            gizmo:SetTool("Select")
        end
        imgui.SameLine()
        if imgui.Button("Move",vector.create(0,height-offY)) == 1 then
            if gizmo:GetTool() == "Move" then
                gizmo:SetTool("Select")
            else
                gizmo:SetTool("Move")
            end
        end
        imgui.SameLine()
        if imgui.Button("Scale",vector.create(0,height-offY)) == 1 then
            if gizmo:GetTool() == "Scale" then
                gizmo:SetTool("Select")
            else
                gizmo:SetTool("Scale")
            end
        end
        imgui.SameLine()
        if imgui.Button("Rotate",vector.create(0,height-offY)) == 1 then
            if gizmo:GetTool() == "Rotate" then
                gizmo:SetTool("Select")
            else
                gizmo:SetTool("Rotate")
            end
        end
        imgui.SameLine()
        --imgui.PopStyleVar()
    end

	imgui.End()
end)
return self