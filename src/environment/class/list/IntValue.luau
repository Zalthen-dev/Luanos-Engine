local properties = setmetatable({
	Value = 0
}, {
	__newindex = function(v, key, value)
		if key == "Value" then
			value = math.round(value)
			rawset(v, key, value)
		end
	end
})

return {
	class = "IntValue",
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