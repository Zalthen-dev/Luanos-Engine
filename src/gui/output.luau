local imgui = require("@rimgui")
local window = require("@window")

local self = {}
self = window.Create(function()
	local engineState = self.renderer().EngineState
	local game = engineState.game

	local LogService = game:GetService("LogService")

	if imgui.Begin("Output", self.visible) == 1 then
		local availSize = imgui.FromImVec2(imgui.GetContentRegionAvail())
		if
			imgui.BeginChild(
				"OutputScrolling",
				imgui.NewImVec2(availSize.x, availSize.y),
				false,
				imgui.IMGUI_WINDOWFLAGS_HORIZONTAL_SCROLLBAR
			)
		then
			local logList = LogService:GetLogHistory()

			local count = #logList
			for i, log in logList do
				if i >= (count - 5000) then
					local text = ("[ %010i ]: %s"):format(log.timestamp, log.message)
					imgui.TextUnformatted(text)
				end
			end

			if imgui.GetScrollY() >= imgui.GetScrollMaxY() - 1 then
				imgui.SetScrollHereY(1)
			end
		end
		imgui.EndChild()
	end
	imgui.End()
end)

return self
