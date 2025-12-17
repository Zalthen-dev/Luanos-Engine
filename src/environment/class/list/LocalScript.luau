local Enum = require("@Enum")

local propTable = {
    Name = "LocalScript",
    Disabled = false,
    Enabled = true,
    Source = [[print("Hello World!")]]
}

return {
    class = "LocalScript",
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
