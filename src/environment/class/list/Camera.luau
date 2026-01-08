local Enum = require("@Enum")
local CFrame = require("@CFrame")
local Vector2 = require("@Vector2")

local properties = {
	CameraSubject = nil,
	CameraType = Enum.CameraType.Fixed,

	CFrame = CFrame.new(0, 5, -5),
	Focus = CFrame.new(0, 5, 0),

	DiagonalFieldOfView = 0, -- Not implemented
	FieldOfView = 70,
	FieldOfViewMode = Enum.FieldOfViewMode.Vertical,
	MaxAxisFieldOfView = 70, -- Not implemented

	NearPlaneZ = 0.01,

	VRTiltAndRollEnabled = false, -- Not implemented
	HeadLocked = false, -- Not implemented
	HeadScale = 1,

	ViewportSize = Vector2.new(0, 0), -- Not implemented
}

return {
	class = "Folder",
	callback = function(instance)
		instance:SetProperties(properties)
		return instance
	end,
	inherit = function(tble)
		for prop, val in pairs(properties) do
			tble[prop] = val
		end
	end,
}