local CFrame = require("@CFrame")

local properties = {
	Value = CFrame.new(0, 0, 0)
}

return {
	class = "CFrameValue",
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
