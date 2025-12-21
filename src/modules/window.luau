local rl = require("@raylib")
local imgui = require("@rimgui")
local utils = require("@utils")

local window = {}
window.__index = window
window.__type = "Window"

--[[
	Create a new window with custom content, handles opening & closing for you

	Make sure to use imgui.Begin and imgui.End as the window isn't handled automatically for you
]]
function window.Create(drawFunc: (any) -> ())
	local self = {}
	self.visible = utils.BoolPtr(1)

	function self:SetVisibility(visible: boolean)
		utils.SetBoolPtr(self.visible, visible and 1 or 0)
	end

	function self:Draw(...)
		if utils.ValueFromBoolPtr(self.visible) == 1 then
			drawFunc(...)
		end
	end

	return self
end

return window
