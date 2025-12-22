local baseplate = Instance.new("Part")
baseplate.Size = Vector3.new(2048, 16, 2048)
baseplate.Position = Vector3.new(0, -8, 0)
baseplate.Color = Color3.fromRGB(109, 110, 108)
baseplate.Name = "Baseplate"
baseplate.Parent = workspace

local RunService = game:GetService("RunService")

local originPos = Vector3.new(0, 100, 0)
local center = Instance.new("Part")
center.Color = Color3.new(0, 0, 0)
center.Shape = "Sphere"
center.Size = Vector3.new(50, 50, 50)
center.Name = "Center"
center.Position = originPos
center.Parent = workspace

local parts = 500
local mpos = 1024
for i = 1, parts do
	local part = Instance.new("Part")
	part.Color = Color3.new(math.random(), math.random(), math.random())
	part.Size = Vector3.new(5, 5, 5)
	part.Position = originPos + Vector3.new(math.random(-mpos, mpos), 0, math.random(-mpos, mpos))
	part.Orientation = Vector3.new(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360))
	part.Name = "Part" .. tostring(i)
	part.Parent = workspace

	local offset = math.random(-1000, 1000)
	local dist = part.Position.Magnitude
	local orbitTime = (dist^2)/1000000
	RunService.PreRender:Connect(function(dt)
		local v = (time()+offset)/orbitTime
		part.Position = Vector3.new(
			math.sin(v)*dist,
			part.Position.Y,
			math.cos(v)*dist
		)
	end)
end