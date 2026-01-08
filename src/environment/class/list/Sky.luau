local properties = {
	Name = "Sky",

    CelestialBodiesShown = false, -- not implemented yet
    MoonAngularSize = 1, -- not implemented yet
    MoonTextureId = "", -- not implemented yet

    SkyboxBk = "",
    SkyboxDn = "",
    SkyboxFt = "",
    SkyboxLf = "",
    SkyboxRt = "",
    SkyboxUp = "",

    StarCount = 1000,  -- not implemented yet
    SunAngularSize = 2,  -- not implemented yet
    SunTextureId = "" -- not implemented yet
}

return {
	class = "Sky",
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