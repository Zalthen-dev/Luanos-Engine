local rl = require("@raylib")
local imgui = require("@rimgui")
local utils = require("@utils")

local enginesettings = require("../gui/enginesettings")
local gizmo = require("../gui/gizmo")
local scripteditor = require("../gui/scripteditor")
local explorer = require("../gui/explorer")
local output = require("../gui/output")
local properties = require("../gui/properties")
local toolbox = require("../gui/toolbox")
local toolbar = require("../gui/toolbar")
local statusbar = require("../gui/statusbar")
local viewport = require("../gui/viewport")

local ffi = zune.ffi
local mem = zune.mem
local fs = zune.fs

local function DockSplit(node_id: number, dir: number, ratio: number): (number, number)
	local out_at_dir = ffi.alloc(4)
	local out_at_opp = ffi.alloc(4)
	imgui.DockBuilderSplitNode(node_id, dir, ratio, out_at_dir, out_at_opp)
	return out_at_dir:readu32(0), out_at_opp:readu32(0)
end

local gui = {}

gui.rounding = 4
gui.renderer = nil

gui.dockFlags = bit32.bor(imgui.IMGUI_DOCKNODEFLAGS_NO_CLOSE_BUTTON)
gui._dockBuilt = false
gui.dockid = nil
gui.viewport = nil

local windows = {
	toolbar,
	statusbar,
	scripteditor,
	enginesettings, 
	explorer, 
	output, 
	properties, 
	toolbox, 
	viewport,
	gizmo,
}

local setStartupTheme = false

function gui.Draw()
	gui.dockid = imgui.GetID("GuiDockspace")
	gui.viewport = imgui.GetMainViewport()
	if not gui._dockBuilt then
		imgui.DockBuilderGetNode(gui.dockid)
		imgui.DockBuilderAddNode(gui.dockid, 0)

		local vpSize = imgui.GetViewportSize(gui.viewport)
		imgui.DockBuilderSetNodeSize(gui.dockid, vpSize)

		local dock_id_top, dock_id_main = DockSplit(gui.dockid, imgui.Dir.Up, 0.1)

		local dock_id_left, dock_id_main = DockSplit(dock_id_main, imgui.Dir.Left, 0.15)
		--local dock_id_left_top, dock_id_left_bottom = DockSplit(dock_id_left, imgui.Dir.Up, 0.50)

		local dock_id_right, dock_id_main = DockSplit(dock_id_main, imgui.Dir.Right, 0.2)
		local dock_id_right_top, dock_id_right_bottom = DockSplit(dock_id_right, imgui.Dir.Up, 0.5)

		local dock_id_bottom, dock_id_main = DockSplit(dock_id_main, imgui.Dir.Down, 0.2)

		--imgui.DockBuilderDockWindow("Toolbar", dock_id_top)
		imgui.DockBuilderDockWindow("Viewport", dock_id_main)
		imgui.DockBuilderDockWindow("Script Editor", dock_id_main)
		imgui.DockBuilderDockWindow("Toolbox", dock_id_left)
		imgui.DockBuilderDockWindow("Output", dock_id_bottom)
		imgui.DockBuilderDockWindow("Explorer", dock_id_right_top)
		imgui.DockBuilderDockWindow("Properties", dock_id_right_bottom)

		imgui.DockBuilderFinish(gui.dockid)
		gui._dockBuilt = true
	end
	
	if not setStartupTheme then
		local engineState = gui.renderer().EngineState
		local config = engineState.config

		local defaultTheme = config.engine.default_theme
		if typeof(defaultTheme) == "string" then
			local defaultThemeData = nil
			for _, themeData in enginesettings.Themes do
				if themeData.Name == defaultTheme then
					defaultThemeData = themeData
					break
				end
			end
			
			if defaultThemeData then
				enginesettings.Theme = defaultThemeData.Name
				defaultThemeData.Function()
			else
				print("WARN: Default theme in engine.toml isn't a valid theme! Using ImGui Dark instead")
			end
		end

		setStartupTheme = true
	end

	imgui.PushStyleVarFloat(imgui.StyleVar.DockingSeparatorSize,0)
	imgui.DockSpaceOverViewport(gui.dockid, gui.viewport, gui.dockFlags)
	imgui.PopStyleVar()
	if imgui.BeginMainMenuBar() == 1 then
		if imgui.BeginMenu("File") == 1 then
			imgui.MenuItem("New", "Ctrl+N")
			imgui.MenuItem("Save", "Ctrl+S")
			imgui.MenuItem("Open", "Ctrl+O")
			imgui.MenuItem("Save as", "Shift+Ctrl+N")
			imgui.MenuItem("Quit", "Alt+F4")

			imgui.Separator()

			if imgui.MenuItem("Engine Settings", "Alt+S") == 1 then
				enginesettings:SetVisibility(true)
			end

			imgui.EndMenu()
		end
		if imgui.BeginMenu("View") == 1 then
			for _, window in windows do
				if not window.title or window.title == "" or window.title == "Settings" then
					continue
				end
				imgui.Checkbox(window.title, window.visible)
			end
			imgui.EndMenu()
		end
		imgui.EndMainMenuBar()
	end

	if rl.IsKeyDown(rl.KEY_LEFT_ALT) == 1 and rl.IsKeyPressed(rl.KEY_S) == 1 then
		enginesettings:SetVisibility(not enginesettings:GetVisibility())
	end

	imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, gui.rounding)
	imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, gui.rounding)
	imgui.PushStyleVarFloat(imgui.StyleVar.PopupRounding, gui.rounding)
	imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, gui.rounding)
	imgui.PushStyleVarFloat(imgui.StyleVar.WindowBorderSize, 0)
	for _, window in windows do
		if not window.renderer then
			window.renderer = function()
				return gui.renderer()
			end
		end
		window:Draw()
	end
	imgui.PopStyleVar(5)
end

return gui
