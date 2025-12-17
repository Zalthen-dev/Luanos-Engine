local Enum = require("@Enum")

local propTable = {
    Name = "Script",
    Disabled = false,
    Enabled = true,
    RunContext = Enum.RunContext.Legacy,
    Source = [[print("Hello World!")]]
}

return {
    class = "Script",
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
