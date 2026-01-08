local Signal = require("@signal")

local properties = {
    Name = "Sound",
    SoundId = "./src/assets/sounds/bbqchickenalert.mp3",
    IsLoaded = false,

    Volume = 0.5,
    PlaybackSpeed = 1,
    Looped = false,
    Playing = false,
    PlayOnRemove = false,
}

return {
    class = "Sound",
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
