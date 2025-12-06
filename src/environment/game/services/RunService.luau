local Instance = require("@Instance")
local Signal = require("@signal")

local RunService = Instance.new("RunService")

RunService.PreRender = Signal.new()
RunService.RenderStepped = Signal.new()

RunService.PreAnimation = Signal.new()
RunService.PreSimulation = Signal.new()
RunService.Stepped = Signal.new()

RunService.PostSimulation = Signal.new()
RunService.Heartbeat = Signal.new()

RunService.InitRenderer = function(renderer)
    renderer.MainSignal:Connect(function(route, data)
        if route == "PreRender" or route == "RenderStepped" then
            RunService.PreRender:Fire(data)
            RunService.RenderStepped:Fire(data)
        elseif route == "Heartbeat" or route == "PostSimulation" then
            RunService.Heartbeat:Fire(data)
            RunService.PostSimulation:Fire(data)
        elseif route == "PreAnimation" or route == "PreSimulation" or route == "Stepped" then
            RunService.PreAnimation:Fire(data)
            RunService.PreSimulation:Fire(data)
            RunService.Stepped:Fire(data)
        end
    end)
end

return RunService