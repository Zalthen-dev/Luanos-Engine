local rl = require("@raylib")
local imgui = require("@rimgui")
local utils = require("@utils")

local window = {}
window.__index = window
window.__type = "Window"

type WindowAnchor = "left" | "right" | "top" | "bottom" | "fill" | "none"
type Window = {
    title: string,
    defaultSize: FFIPointer,
    flags: number,
    visible: FFIPointer,
    Contained: boolean,
    anchor: WindowAnchor,
    anchorPriority: number,

    SetPosition: (number, number) -> (),
    SetVisibility: (boolean) -> (),
    Draw: (any) -> (),
}

function window.Create(title: string, drawFunc:(any) -> ()): Window
    local self = {}
    self.title = title
    self.defaultSize = imgui.NewImVec2(600, 400)
    self.flags = imgui.IMGUI_WINDOWFLAGS_NO_COLLAPSE
    self.visible = utils.BoolPtr(1)
    self.Contained = false
    self.anchor = "none"

    function self:SetPosition(x, y)
        self.Position = vector.create(x or 0, y or 0)
    end

    function self:SetVisibility(visible)
        if visible then
            self.visible:writeu8(0, 1)
        else
            self.visible:writeu8(0, 0)
        end
    end

    function self:Draw(...)
        if utils.ValueFromBoolPtr(self.visible) == 1 then
            if not self.Contained then
                imgui.SetNextWindowSize(self.defaultSize, imgui.IMGUI_COND_ONCE)
                if imgui.Begin(self.title, self.visible, self.flags) then
                    drawFunc(...)
                end; imgui.End()
            else
                drawFunc(...)
            end
        end
    end

    return self
end

return window