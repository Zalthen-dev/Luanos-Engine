local RunService = game:GetService("RunService")

local part = Instance.new("Part")
part.Anchored = true
part.Position = Vector3.new(0, 0.5, 0)
part.Parent = workspace

local t = 0
RunService.PreRender:Connect(function(dt)
    t += dt
    part.Color = Color3.fromHSV(t*0.2 % 1, 1, 1)
    part.Position = Vector3.new(math.sin(t)*5, 0.5, math.cos(t)*5)
end)