local imgui = require("@rimgui")
local window = require("@window")
local rl = require("@raylib")

local registry = require("@registry")
local instance_List = registry.getNameList()

local insert_Target = nil
local open_InsertMenu = false

local services = {
	"Workspace",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"CollectionService",
	"Debris",
	"HttpService",
	"LogService",
	--"ModuleTrackerService",
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
		local flags = bit32.bor(
			imgui.IMGUI_TREENODEFLAGS_OPENONDOUBLECLICK,
			imgui.IMGUI_TREENODEFLAGS_OPENONARROW,
			imgui.IMGUI_TREENODEFLAGS_SPANFULLWIDTH
		)

		local children = obj:GetChildren()
		if #children == 0 then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_LEAF)
		end

		local isSelected = Selection:_IsSelected(obj)
		if isSelected then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_SELECTED)
		end

		if imgui.SmallButton("+##" .. obj.ClassName .. obj.UniqueId) == 1 then
			insert_Target = obj
			open_InsertMenu = true
		end
		
		imgui.SameLine()

		if obj._NODE_FORCE_EXPAND then
			imgui.SetNextItemOpen(true, 0)
			obj._NODE_FORCE_EXPAND = nil
		end

		-- ImGui doesnt permit us to have two objects with the same name
		-- so using the UniqueId should fix this
		local nodeName = obj.Name .. "##" .. obj.UniqueId
		local nodeResult = imgui.TreeNodeEx(nodeName, flags)
		if imgui.IsItemClicked() == 1 then
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

		if imgui.BeginPopupContextItem() == 1 then
			imgui.TextDisabled("Cut")
			imgui.TextDisabled("Copy")

			if imgui.Selectable("Duplicate") == 1 then
				local newObj = obj:Clone()
				newObj.Name = obj.Name
				newObj.Parent = obj.Parent

				Selection:Remove(obj)
				Selection:Add({ newObj })
			end

			if imgui.Selectable("Delete") == 1 then
				Selection:Remove({ obj })
				obj:Destroy()
			end

			imgui.TextDisabled("Rename")
			imgui.Separator()

			if imgui.Selectable("Select Children") == 1 then
				Selection:Set(obj:GetChildren())
				obj._NODE_FORCE_EXPAND = true
			end

			if imgui.Selectable("Select Parent") == 1 then
				local parent = obj.Parent
				if parent.ClassName ~= "DataModel" then
					Selection:Remove({ obj })
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
		open_InsertMenu = false
		for _, serv in ipairs(GetServices()) do
			TreeRender(serv)
		end
		if open_InsertMenu then
			-- for some reason putting openpopup in the + button causes it to break when calling it from descendants (tried with ###InsertMenu)
			imgui.OpenPopup("InsertMenu")
			open_InsertMenu = false
		end
		-- lo and behold: the insert menu.
		if imgui.BeginPopup("InsertMenu") == 1 then
			if insert_Target then
				for _, className in ipairs(instance_List) do
					if imgui.Selectable(className) == 1 then
						local newObj = engineState.Instance.new(className)
						newObj.Name = className
						newObj.Parent = insert_Target
						Selection:Remove({insert_Target})
						Selection:Add(newObj)
						insert_Target._NODE_FORCE_EXPAND = true
					end
				end
			end
			imgui.EndPopup()
		end
	end
	imgui.End()
end)

self.title = "Explorer"
return self
