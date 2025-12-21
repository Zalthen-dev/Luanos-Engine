local imgui = require("@rimgui")
local window = require("@window")

local services = {
	"Workspace",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"Debris",
	"HttpService",
	"LogService",
	"RunService",
	"Selection",
	"TweenService",
	"UserInputService",
}

local self
self = window.Create(function()
	local engineState = self.renderer().EngineState
	local game = engineState.game

	local Selection = game:GetService("Selection")

	local function GetServices()
		local servs = {}
		for _, name in ipairs(services) do
			local serv = game:FindService(name)
			if serv then
				table.insert(servs, serv)
			end
		end

		return servs
	end

	local function TreeRender(obj)
		local flags = bit32.bor(imgui.IMGUI_TREENODEFLAGS_OPENONDOUBLECLICK, imgui.IMGUI_TREENODEFLAGS_OPENONARROW)

		local children = obj:GetChildren()
		if #children == 0 then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_LEAF)
		end

		local isSelected = Selection:_IsSelected(obj)
		if isSelected then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_SELECTED)
		end

		if imgui.TreeNodeEx(obj.Name, flags) == 1 then
			if #children > 0 then
				for _, child in ipairs(children) do
					TreeRender(child)
				end
			end

			imgui.TreePop()
		end
	end

	if imgui.Begin("Explorer", self.visible, imgui.IMGUI_WINDOWFLAGS_HORIZONTAL_SCROLLBAR) == 1 then
		for _, serv in ipairs(GetServices()) do
			TreeRender(serv)
		end
	end
	imgui.End()
end)

return self
