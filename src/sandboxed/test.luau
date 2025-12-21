local baseplate = Instance.new("Part")
baseplate.Size = Vector3.new(2048, 16, 2048)
baseplate.Position = Vector3.new(0, -8, 0)
baseplate.Color = Color3.fromRGB(109, 110, 108)
baseplate.Name = "Baseplate"
baseplate.Parent = workspace

--local RunService = game:GetService("RunService")
task.wait(1)


local parts = 500
local mpos = 2048
for i = 1, parts do
	local part = Instance.new("Part")
	part.Color = Color3.new(1, 1, 1)
	part.Size = Vector3.new(5, 5, 5)
	part.Position = Vector3.new(math.random(-mpos, mpos), 0.5 + math.random(0, mpos/2), math.random(-mpos, mpos))
	part.Name = "Part" .. tostring(i)
	part.Parent = workspace
end