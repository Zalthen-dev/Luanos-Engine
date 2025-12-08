local rl = require("@raylib")
local imgui = require("@rimgui")
local utils = require("@utils")

local window = {}
window.__index = window
window.__type = "Window"

function window.Create(title:string, drawFunc:() -> ())
    local self = {}
    self.title = title
    self.visible = utils.boolptr(1)

    function self:SetPosition(x, y)
        self.Position = vector.create(x or 0, y or 0)
    end

    function self:SetVisibility(visible)
        if visible then
            self.visible:writeu8(1)
        else
            self.visible:writeu8(0)
        end
    end

    function self:Draw()
        drawFunc()
    end

    return self
end

return window
