local imgui = require("@rimgui")
local rl = require("@raylib")
local window = require("@window")

local mem = zune.mem

local function TextCenter(text)
	local availRegion = imgui.FromImVec2(imgui.GetWindowSize())
	local textSize = imgui.FromImVec2(imgui.CalcTextSize(text))

	imgui.SetCursorPosX((availRegion.x - textSize.x) / 2)
	imgui.SetCursorPosY((availRegion.y - textSize.y) / 2)

	imgui.Text(text)
end

local self = {}
self = window.Create(function()  
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.NewImVec2(0, 0))
	if imgui.Begin("Viewport") == 1 then
		self.renderer().ViewportActive = (imgui.IsWindowHovered(0) == 1)
		self.renderer().Visible = true

		local size = imgui.FromImVec2(imgui.GetContentRegionAvail())
		self.renderer().Render3DSceneToTexture(math.floor(size.x), math.floor(size.y))

		if self.renderer().ViewTexture then
			local viewportUV0 = imgui.NewImVec2(0, 1)
			local viewportUV1 = imgui.NewImVec2(1, 0)

			local texture = mem.slice(self.renderer().ViewTexture, rl.RenderTexture2D:offset("texture"), rl.Texture:size())
			imgui.Image(texture, size.x, size.y, viewportUV0, viewportUV1)
		else
			TextCenter("If you see this, the viewport failed to draw :(")
		end
	else
		self.renderer().ViewportActive = false
		self.renderer().Visible = false
	end
	imgui.End()
	imgui.PopStyleVar()
end)

return self