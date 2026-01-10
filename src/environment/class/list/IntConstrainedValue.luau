local properties = setmetatable({
	Value = 0,
	MinValue = 0,
	MaxValue = 10,
}, {
	__newindex = function(v, key, value)
		if key == "Value" then
			value = math.round(value)
			rawset(v, key, math.clamp(value, rawget(v, "MinValue") or 0, rawget(v, "MaxValue") or 0))
		end
	end,
})

return {
	class = "IntConstrainedValue",
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
