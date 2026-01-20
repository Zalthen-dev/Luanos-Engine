local imgui = require("@imgui")
local window = require("@window")
local Enum = require("@Enum")

local max_Logs = 500
local childSize = imgui.NewImVec2(-1, -1)
local self = {}
self = window.Create(function()

	local engineState = self.renderer().EngineState
    if not self.game then
        self.game = engineState.game
    end
    if not self.LogService then
        self.LogService = self.game:GetService("LogService")
    end
	
	if imgui.Begin("Output", self.visible, imgui.IMGUI_WINDOWFLAGS_MENU_BAR) == 1 then
		local logList = self.LogService._Logs
		local count = #logList
		local startIndex = (math.max(1,count - max_Logs))
		
		-- Menu bar
		imgui.BeginMenuBar()
		imgui.Text(tostring(count))
		if imgui.Button("Clear") == 1 then
			table.clear(logList)
		end
		imgui.EndMenuBar()

		if imgui.BeginChild(
				"OutputScrolling",
				childSize,
				false,
				imgui.IMGUI_WINDOWFLAGS_ALWAYS_VERTICAL_SCROLLBAR
			) == 1 then

			for i=startIndex, count do
				local log = logList[i]
				if log then
					local text = ("[ %010i ]: %s"):format(log.timestamp, log.message)
					imgui.PushStyleColor(0, log.color)
					imgui.TextWrapped(text)
					imgui.PopStyleColor()
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

self.title = "Output"
return self
