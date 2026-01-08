local Enum = require("@Enum")

local properties = {
    Name = "Script",
    Disabled = false,
    Enabled = true,
    RunContext = Enum.RunContext.Legacy,
    Source = [[print("Hello World!")]]
}

return {
    class = "Script",
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
