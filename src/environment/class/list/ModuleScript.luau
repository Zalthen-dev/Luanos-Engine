local propTable = {
    Name = "ModuleScript",
    Source = [[print("Hello World!")]]
}

return {
    class = "ModuleScript",
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
