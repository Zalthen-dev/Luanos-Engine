local Vector3 = require("@Vector3")
local Color3 = require("@Color3")
local CFrame = require("@CFrame")

local propTable = {
	Position = Vector3.new(0, 0, 0),
	Size = Vector3.new(1, 1, 1),
	Color = Color3.new(1, 1, 1),
	Material = "Plastic",
	Transparency = 0,
	Anchored = false,
	CanCollide = true,
	Velocity = Vector3.new(0, 0, 0),
	Mass = 1,
	Elasticity = 0.5,
	Friction = 0.3,
	Shape = "Block",
	CastsShadow = true,
	Reflectance = 0,
	Locked = false,
	Orientation = Vector3.new(0, 0, 0),
	Rotation = Vector3.new(0, 0, 0),
	CFrame = CFrame.new(0, 0, 0),
	ElapsedTime = 0,
	Name = "Part",
}

return {
	class = "Part",
	callback = function(instance)
		instance:SetProperties(propTable)
		return instance
	end,
	
	inherit = function(tble)
		for prop, val in pairs(propTable) do
			tble[prop] = val
		end
	end,
}