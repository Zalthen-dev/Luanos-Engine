local imgui = require("@rimgui")
local window = require("@window")
local utils = require("@utils")
local extraStyles = require("../assets/extrastyles")

local self = {}
self = window.Create(function()
    local function CategoryCameraOptions()
		-- create pointers if they dont exist
		if not self.CategoryCamera.CameraSpeed then
			self.CategoryCamera.CameraSpeed = utils.FloatPtr(self.renderer().CAMERA_SPEED)
		end
		if not self.CategoryCamera.PanSpeed then
			self.CategoryCamera.PanSpeed = utils.FloatPtr(self.renderer().CAMERA_PANSPEED)
		end
		if not self.CategoryCamera.ShiftSpeed then
			self.CategoryCamera.ShiftSpeed = utils.FloatPtr(self.renderer().CAMERA_SHIFTSPEED)
		end
		if not self.CategoryCamera.ScrollSpeed then
			self.CategoryCamera.ScrollSpeed = utils.FloatPtr(self.renderer().CAMERA_SCROLLSPEED)
		end
		if not self.CategoryCamera.ScrollTowardsCursor then
			self.CategoryCamera.ScrollTowardsCursor = utils.BoolPtr(self.renderer().CAMERA_SCROLLTOWARDCURSOR)
		end

		-- inputs and stuff
		if imgui.InputFloat("Camera Speed", self.CategoryCamera.CameraSpeed, 0, 0, "%.3f", 0) == 1 then
			self.renderer().CAMERA_SPEED = utils.ValueFromFloatPtr(self.CategoryCamera.CameraSpeed)
		end
		if imgui.InputFloat("Pan Speed", self.CategoryCamera.PanSpeed, 0, 0, "%.3f", 0) == 1 then
			self.renderer().CAMERA_PANSPEED = utils.ValueFromFloatPtr(self.CategoryCamera.PanSpeed)
		end
		if imgui.InputFloat("Shift Speed", self.CategoryCamera.ShiftSpeed, 0, 0, "%.3f", 0) == 1 then
			self.renderer().CAMERA_SHIFTSPEED = utils.ValueFromFloatPtr(self.CategoryCamera.ShiftSpeed)
		end
		if imgui.InputFloat("Scroll Speed", self.CategoryCamera.ScrollSpeed, 0, 0, "%.3f", 0) == 1 then
			self.renderer().CAMERA_SCROLLSPEED = utils.ValueFromFloatPtr(self.CategoryCamera.ScrollSpeed)
		end
		if imgui.Checkbox("Scroll towards Cursor position", self.CategoryCamera.ScrollTowardsCursor) == 1 then
			self.renderer().CAMERA_SCROLLTOWARDCURSOR =
				utils.AsBool(utils.ValueFromBoolPtr(self.CategoryCamera.ScrollTowardsCursor))
		end
	end

	local function CategoryGeneralOptions()
		if imgui.BeginCombo("Theme", self.Theme, 0) == 1 then
			for _, themeEntry in ipairs(self.Themes) do
				local name = themeEntry.Name
				local setTheme = themeEntry.Function

				if imgui.Selectable(name) == 1 then
					setTheme()
					self.Theme = name
				end
			end

			if #extraStyles > 0 then
				imgui.Separator()
				for _, themeEntry in ipairs(extraStyles) do
					local name = themeEntry.Name
					local setTheme = themeEntry.Function

					if imgui.Selectable(name) == 1 then
						setTheme()
						self.Theme = name
					end
				end
			end

			imgui.EndCombo()
		end
	end

	imgui.SetNextWindowSize(imgui.NewImVec2(400, 400), imgui.COND.APPEARING)
	if imgui.Begin("Luanos Engine - Settings", self.visible) == 1 then
		if imgui.TreeNodeEx("Camera", imgui.TREE_NODE_FLAGS.DEFAULTOPEN) == 1 then
			CategoryCameraOptions()
			imgui.TreePop()
		end

		if imgui.TreeNodeEx("General", imgui.TREE_NODE_FLAGS.DEFAULTOPEN) == 1 then
			CategoryGeneralOptions()
			imgui.TreePop()
		end

		imgui.Text("Show Credits")
		if imgui.IsItemClicked() == 1 then
			self.ShowCredits = not self.ShowCredits
		end

		if self.ShowCredits then
			if imgui.BeginChild("Settings Credits", nil, true) == 1 then
				imgui.Text("Visual Studio Dark Blue Theme:")
				imgui.SameLine()
				imgui.TextLinkOpenURL("MomoDeve", "https://github.com/ocornut/imgui/issues/707#issuecomment-670976818")

				imgui.Text("Classic Steam VGUI:")
				imgui.SameLine()
				imgui.TextLinkOpenURL(
					"metasprite",
					"https://github.com/ocornut/imgui/issues/707#issuecomment-576867100"
				)

				if #extraStyles > 0 then
					imgui.Separator()
					for _, themeEntry in ipairs(extraStyles) do
						local name = themeEntry.Name
						local creator = themeEntry.Creator
						local url = themeEntry.Url

						imgui.Text(name .. ":")
						imgui.SameLine()
						imgui.TextLinkOpenURL(creator, url)
					end
				end
			end
			imgui.EndChild()
		end
	end
	imgui.End()
end)
self.CategoryCamera = {}
self.ShowCredits = false
self.Themes = {
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
	{
		Name = "Classic Steam VGUI",
		Function = imgui.SetStyleClassicSteamVGUI,
	},
}
local defaultTheme = 1
self.Theme = self.Themes[defaultTheme].Name


self:SetVisibility(false)
return self