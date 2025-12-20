local rl = require("@raylib")
local imgui = require("@rimgui")
local utils = require("@utils")

-- TODO: move windows to separate files for better organization

local ffi = zune.ffi
local mem = zune.mem

local function DockSplit(node_id: number, dir: number, ratio: number): (number, number)
	local out_at_dir = ffi.alloc(4)
	local out_at_opp = ffi.alloc(4)
	imgui.DockBuilderSplitNode(node_id, dir, ratio, out_at_dir, out_at_opp)
	return out_at_dir:readu32(0), out_at_opp:readu32(0)
end

local function TextCenter(text)
	local availRegion = imgui.FromImVec2(imgui.GetWindowSize())
	local textSize = imgui.FromImVec2(imgui.CalcTextSize(text))

	imgui.SetCursorPosX((availRegion.x - textSize.x) / 2)
	imgui.SetCursorPosY((availRegion.y - textSize.y) / 2)

	imgui.Text(text)
end

local gui = {}
gui.settings = {}
gui.renderer = nil

gui.dockFlags = 0
gui._dockBuilt = false
gui.dockid = nil
gui.viewport = nil

gui.viewportSize = { x = rl.GetScreenWidth(), y = rl.GetScreenHeight() }

gui.settings.Themes = {
	{
		Name = "ImGui Dark",
		Function = imgui.SetStyleDark,
	},
	{
		Name = "ImGui Light",
		Function = imgui.SetStyleLight,
	},
	{
		Name = "Visual Studio Dark Blue",
		Function = imgui.SetStyleVisualStudioDarkBlue,
	},
}
gui.settings.Theme = gui.settings.Themes[1].Name
gui.settings.ShowCredits = false
gui.settings.Open = utils.BoolPtr(0)

gui.settings.CategoryCamera = {}
function gui.Settings()
	if utils.ValueFromBoolPtr(gui.settings.Open) == 0 then return end

    local function CategoryCameraOptions()
        -- create pointers if they dont exist
        if not gui.settings.CategoryCamera.CameraSpeed then
            gui.settings.CategoryCamera.CameraSpeed = utils.FloatPtr(gui.renderer().CAMERA_SPEED)
        end
        if not gui.settings.CategoryCamera.PanSpeed then
            gui.settings.CategoryCamera.PanSpeed = utils.FloatPtr(gui.renderer().CAMERA_PANSPEED)
        end
        if not gui.settings.CategoryCamera.ShiftSpeed then
            gui.settings.CategoryCamera.ShiftSpeed = utils.FloatPtr(gui.renderer().CAMERA_SHIFTSPEED)
        end
        if not gui.settings.CategoryCamera.ScrollSpeed then
            gui.settings.CategoryCamera.ScrollSpeed = utils.FloatPtr(gui.renderer().CAMERA_SCROLLSPEED)
        end
        if not gui.settings.CategoryCamera.ScrollTowardsCursor then
            gui.settings.CategoryCamera.ScrollTowardsCursor = utils.BoolPtr(gui.renderer().CAMERA_SCROLLTOWARDCURSOR)
        end

        -- inputs and stuff
        if imgui.InputFloat("Camera Speed", gui.settings.CategoryCamera.CameraSpeed, 0, 0, "%.3f", 0) == 1 then
            gui.renderer().CAMERA_SPEED = utils.ValueFromFloatPtr(gui.settings.CategoryCamera.CameraSpeed)
        end
        if imgui.InputFloat("Pan Speed", gui.settings.CategoryCamera.PanSpeed, 0, 0, "%.3f", 0) == 1 then
            gui.renderer().CAMERA_PANSPEED = utils.ValueFromFloatPtr(gui.settings.CategoryCamera.PanSpeed)
        end
        if imgui.InputFloat("Shift Speed", gui.settings.CategoryCamera.ShiftSpeed, 0, 0, "%.3f", 0) == 1 then
            gui.renderer().CAMERA_SHIFTSPEED = utils.ValueFromFloatPtr(gui.settings.CategoryCamera.ShiftSpeed)
        end
        if imgui.InputFloat("Scroll Speed", gui.settings.CategoryCamera.ScrollSpeed, 0, 0, "%.3f", 0) == 1 then
            gui.renderer().CAMERA_SCROLLSPEED = utils.ValueFromFloatPtr(gui.settings.CategoryCamera.ScrollSpeed)
        end
        if imgui.Checkbox("Scroll towards Cursor position", gui.settings.CategoryCamera.ScrollTowardsCursor) == 1 then
            gui.renderer().CAMERA_SCROLLTOWARDCURSOR = utils.AsBool(utils.ValueFromBoolPtr(gui.settings.CategoryCamera.ScrollTowardsCursor))
        end
    end

	local function CategoryGeneralOptions()
		if imgui.BeginCombo("Theme", gui.settings.Theme, 0) == 1 then
			for _, themeEntry in ipairs(gui.settings.Themes) do
				local name = themeEntry.Name
				local setTheme = themeEntry.Function

				if imgui.Selectable(name) == 1 then
					setTheme()
					gui.settings.Theme = name
				end
			end

			imgui.EndCombo()
		end

        
	end

	if imgui.Begin("Luanos Engine - Settings", gui.settings.Open) == 1 then
        if imgui.TreeNodeEx("Camera", imgui.IMGUI_TREENODEFLAGS_DEFAULTOPEN) == 1 then
            CategoryCameraOptions()
			imgui.TreePop()
		end
        
		if imgui.TreeNodeEx("General", imgui.IMGUI_TREENODEFLAGS_DEFAULTOPEN) == 1 then
            CategoryGeneralOptions()
			imgui.TreePop()
		end

		imgui.Text("Show Credits")
		if imgui.IsItemClicked() == 1 then
			gui.settings.ShowCredits = not gui.settings.ShowCredits
		end

		if gui.settings.ShowCredits then
			if imgui.BeginChild("Settings Credits", nil, true) == 1 then
				imgui.Text("Visual Studio Dark Blue Theme:")
				imgui.SameLine()
				imgui.TextLinkOpenURL("MomoDeve", "https://github.com/ocornut/imgui/issues/707#issuecomment-670976818")
			end
			imgui.EndChild()
		end
	end
	imgui.End()
end

function gui.Toolbox()
	if imgui.Begin("Toolbox") == 1 then
		TextCenter("Not available")
	end
	imgui.End()
end

function gui.Explorer()
	local engineState = gui.renderer().EngineState
	local game = engineState.game

	local Selection = game:GetService("Selection")

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

	if imgui.Begin("Explorer", nil, imgui.IMGUI_WINDOWFLAGS_HORIZONTAL_SCROLLBAR) == 1 then
		for _, serv in ipairs(GetServices()) do
			TreeRender(serv)
		end
	else
	end
	imgui.End()
end

function gui.Properties()
	if imgui.Begin("Properties") == 1 then
		TextCenter("No object selected")
	end
	imgui.End()
end

function gui.Output()
	local engineState = gui.renderer().EngineState
	local game = engineState.game

	local LogService = game:GetService("LogService")

	if imgui.Begin("Console") == 1 then
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
end

gui.viewportPos = vector.create(0, 0)
function gui.Viewport()
	imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.NewImVec2(0, 0))
	if imgui.Begin("Viewport") == 1 then
		gui.renderer().ViewportActive = (imgui.IsWindowHovered(0) == 1)
		gui.renderer().Visible = true

		local size = imgui.FromImVec2(imgui.GetContentRegionAvail())
		gui.renderer().Render3DSceneToTexture(math.floor(size.x), math.floor(size.y))

		TextCenter("If you see this, the viewport failed to draw :(     For now, hold LeftAlt to hide all GUI")
		if gui.renderer().ViewTexture then
			imgui.SetCursorPosX(0)
			imgui.SetCursorPosY(0)

			--gui.renderer().Render3DSceneToTexture()
			
			--local texture = mem.slice(gui.renderer().ViewTexture, rl.RenderTexture2D:offset("texture"), rl.Texture:size())
			--local width = buffer.readi32(texture, rl.Texture:offset("width"))
        	--local height = buffer.readi32(texture, rl.Texture:offset("height"))

			--local source = rl.Rectangle:new({x=0,y=height,width=width,height=-height})
        	--local dest = rl.Rectangle:new({x=gui.viewportPos.x, y=gui.viewportPos.y, width=width, height=height})

        	--rl.DrawTexturePro(texture, source, dest, vector.create(0, 0), 0, rl.WHITE)
			imgui.Image(buffer.readu32(gui.renderer().ViewTexture, rl.Texture2D:offset("id")), size.x, size.y)
		end
	else
		gui.renderer().ViewportActive = false
		gui.renderer().Visible = false
	end
	imgui.End()
	imgui.PopStyleVar()
end

function gui.PreRender() 

end

function gui.Draw()
	gui.dockid = imgui.GetID("GuiDockspace")
	gui.viewport = imgui.GetMainViewport()
	if not gui._dockBuilt then
		imgui.DockBuilderGetNode(gui.dockid)
		imgui.DockBuilderAddNode(gui.dockid, 0)

		local vpSize = imgui.GetViewportSize(gui.viewport)
		imgui.DockBuilderSetNodeSize(gui.dockid, vpSize)

		local dock_id_top, dock_id_main = DockSplit(gui.dockid, imgui.Dir.Up, 0.1)

		local dock_id_left, dock_id_main = DockSplit(dock_id_main, imgui.Dir.Left, 0.2)
		--local dock_id_left_top, dock_id_left_bottom = DockSplit(dock_id_left, imgui.Dir.Up, 0.50)

		local dock_id_right, dock_id_main = DockSplit(dock_id_main, imgui.Dir.Right, 0.25)
		local dock_id_right_top, dock_id_right_bottom = DockSplit(dock_id_right, imgui.Dir.Up, 0.50)

		local dock_id_bottom, dock_id_main = DockSplit(dock_id_main, imgui.Dir.Down, 0.35)

		--imgui.DockBuilderDockWindow("Toolbar", dock_id_top)
		imgui.DockBuilderDockWindow("Viewport", dock_id_main)
		imgui.DockBuilderDockWindow("Script Editor", dock_id_main)
		imgui.DockBuilderDockWindow("Toolbox", dock_id_left)
		imgui.DockBuilderDockWindow("Console", dock_id_bottom)
		imgui.DockBuilderDockWindow("Explorer", dock_id_right_top)
		imgui.DockBuilderDockWindow("Properties", dock_id_right_bottom)

		imgui.DockBuilderFinish(gui.dockid)
		gui._dockBuilt = true
	end

	-- TEMP: hold alt to hide gui
	-- remove once viewport actually works
	if rl.IsKeyDown(rl.KEY_LEFT_ALT) == 1 then
		gui.renderer().ViewportActive = true

		local width = rl.GetScreenWidth()
		local height = rl.GetScreenHeight()
		local text = "UI Hidden"

		local size = rl.MeasureText(text, 20)
		rl.DrawText(text, (width / 2) - (size / 2), (height / 2) - 10, 20, rl.GRAY)
		return
	end

	imgui.DockSpaceOverViewport(gui.dockid, gui.viewport, gui.dockFlags)
	if imgui.BeginMainMenuBar() == 1 then
		if imgui.BeginMenu("File") == 1 then
			imgui.MenuItem("New", "Ctrl+N")
			imgui.MenuItem("Save", "Ctrl+S")
			imgui.MenuItem("Save as", "Shift+Ctrl+N")
			imgui.MenuItem("Quit", "Alt+F4")

			imgui.Separator()

			if imgui.MenuItem("Engine Settings") == 1 then
				utils.SetBoolPtr(gui.settings.Open, 1)
			end

			imgui.EndMenu()
		end

		imgui.EndMainMenuBar()
	end

	gui.Output()
	gui.Toolbox()
	gui.Explorer()
	gui.Properties()
	gui.Settings()
	gui.Viewport()
end

return gui
