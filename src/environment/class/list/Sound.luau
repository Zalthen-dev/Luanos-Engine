local Signal = require("@signal")
local rl = require("@raylib")

local properties = {
    Name = "Sound",
	_raySound = nil,
    SoundId = "",
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
		warn("Sounds don't work right now, I have no clue what is preventing them from working as intended...")

		instance:SetProperties(properties)

		instance.DidLoop = Signal.new()
		instance.Loaded = Signal.new()

		instance.Played = Signal.new()
		instance.Resumed = Signal.new()

		instance.Paused = Signal.new()
		instance.Ended = Signal.new()
		instance.Stopped = Signal.new()

		instance.Play = function(self)
			if not self.IsLoaded then
				instance._raySound = rl.LoadSound(instance.SoundId)
				instance.IsLoaded = (instance._raySound ~= nil)
			end

			if self.IsLoaded and not self.Playing then
				rl.PlaySound(self._raySound)
				self.Playing = true

				if self.Played then
					self.Played:Fire()
				end
			end
		end

		instance.Pause = function(self)
			if self.IsLoaded and self.Playing then
				rl.PauseSound(self._raySound)
				self.Playing = false
			end
		end

		instance.Resume = function(self)
			if self.IsLoaded and not self.Playing then
				rl.ResumeSound(self._raySound)
				self.Playing = true
			end
		end

		instance.Stop = function(self)
			if self.IsLoaded then
				rl.StopSound(self._raySound)

				self.Playing = false
				self.TimePosition = 0
			end
		end

		instance.Changed:Connect(function(prop)
			if instance.IsLoaded then
				if prop == "Volume" then
					rl.SetSoundVolume(instance._raySound, instance.Volume)
				elseif prop == "PlaybackSpeed" then
					rl.SetSoundPitch(instance._raySound, instance.PlaybackSpeed)
				end
			end
			
			if prop == "Playing" then
				if instance.Playing then
					instance:Play()
				else
					instance:Stop()
				end
			end

			if prop == "SoundId" then
				if instance._raySound then
					rl.UnloadSound(instance._raySound)
				end

				instance._raySound = rl.LoadSound(instance.SoundId)
				instance.IsLoaded = (instance._raySound ~= nil)
			end

			if prop == "Looped" or prop == "PlayOnRemove" then
				warn(("Sound.%s is not implemented yet and has no effect"):format(prop))
			end
		end)

		return instance
	end,
	
	inherit = function(tble)
		for prop, val in pairs(properties) do
			tble[prop] = val
		end
	end,
}
