local imgui = require("@rimgui")
local window = require("@window")

local function TextCenter(text)
	local availRegion = imgui.FromImVec2(imgui.GetWindowSize())
	local textSize = imgui.FromImVec2(imgui.CalcTextSize(text))

	imgui.SetCursorPosX((availRegion.x - textSize.x) / 2)
	imgui.SetCursorPosY((availRegion.y - textSize.y) / 2)

	imgui.Text(text)
end

local self = {}
self = window.Create(function()
    if imgui.Begin("Toolbox", self.visible) == 1 then
		TextCenter("Not available")
	end
	imgui.End()
end)

return self