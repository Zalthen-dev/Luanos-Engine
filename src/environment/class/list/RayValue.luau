local Vector3 = require("@Vector3")
local Ray = require("@Ray")


local properties = {
	Value = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0))
}

return {
	class = "RayValue",
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