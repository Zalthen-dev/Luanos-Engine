local properties = {
    Name = "ModuleScript",
    Source = [[print("Hello World!")]]
}

return {
    class = "ModuleScript",
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
