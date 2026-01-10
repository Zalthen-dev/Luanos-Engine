local Vector3 = require("@Vector3")


local properties = {
	Value = Vector3.new(0, 0, 0)
}

return {
	class = "Vector3Value",
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