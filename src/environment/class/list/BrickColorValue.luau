local BrickColor = require("@BrickColor")

local properties = {
	Value = BrickColor.Gray()
}

return {
	class = "BrickColorValue",
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