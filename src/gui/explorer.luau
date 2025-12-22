local imgui = require("@rimgui")
local window = require("@window")
local rl = require("@raylib")

local registry = require("@registry")

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


registry.getNameList()

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
		local flags = bit32.bor(imgui.IMGUI_TREENODEFLAGS_OPENONDOUBLECLICK, imgui.IMGUI_TREENODEFLAGS_OPENONARROW, imgui.IMGUI_TREENODEFLAGS_SPANFULLWIDTH)

		local children = obj:GetChildren()
		if #children == 0 then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_LEAF)
		end

		local isSelected = Selection:_IsSelected(obj)
		if isSelected then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_SELECTED)
		end

		if imgui.SmallButton("+##" .. obj.ClassName .. obj.UniqueId) == 1 then
			
		end

		imgui.SameLine()

		if obj._NODE_FORCE_EXPAND then
			imgui.SetNextItemOpen(true,0)
			obj._NODE_FORCE_EXPAND = nil
		end

		-- removed the if statement cause it was only returning 1 for objects with children when they were open.
		-- if the object was closed, the click event wouldnt trigger.
		-- it worked fine for objects without children though cause they always returned 1.
		local nodeResult = imgui.TreeNodeEx(obj.Name, flags)
		if imgui.IsItemClicked() == 1 then
			print(nodeResult)
			if Selection:_IsSelected(obj) then
				if rl.IsKeyDown(rl.KEY_LEFT_SHIFT) == 1 then
					Selection:Remove({ obj })
				else
					Selection:Set({})
				end
			else
				if rl.IsKeyDown(rl.KEY_LEFT_SHIFT) == 1 then
					Selection:Add(obj)
				else
					Selection:Set({ obj })
				end
			end
		end

		if rl.IsKeyPressed(rl.KEY_DELETE) == 1 and isSelected then
			Selection:Remove({ obj })
			obj:Destroy()
		end

		-- replaced BeginPopupContextWindow() with BeginPopupContextItem().
		-- im guessing BeginPopupContextWindow was using the first item (and its obj) which was UserInputService.
		if imgui.BeginPopupContextItem() == 1 then
			if imgui.Selectable("Select Children") == 1 then
				Selection:Set(obj:GetChildren())
				obj._NODE_FORCE_EXPAND = true
			end

			if imgui.Selectable("Select Parent") == 1 then
				local parent = obj.Parent
				if parent.ClassName ~= "DataModel" then
					Selection:Remove({obj})
					Selection:Add(parent)
				end
			end

			imgui.EndPopup()
		end
		

		if nodeResult == 1 then
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
