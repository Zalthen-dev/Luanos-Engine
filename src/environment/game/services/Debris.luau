local Instance = require("@Instance")

local trackedObjects = {}
local Debris = Instance.new("Debris")

function Debris:AddItem(object, lifetime: number | nil)
    assert(type(lifetime) == "number" or "nil", "Debris:AddItem only accepts 'number' or 'nil' as the lifetime")

    trackedObjects[object] = {
        ExpireTime = os.clock() + (lifetime or 5)
    }
end

Debris.InitRenderer = function(renderer)
    renderer.MainSignal:Connect(function(route, dt)
        if route ~= "PreRender" then return end
        local now = os.clock()
        
        for object, info in pairs(trackedObjects) do
            if not object or object.Parent == nil then
			    trackedObjects[object] = nil
		    elseif now >= info.ExpireTime then
			    if object.Destroy then
				    object:Destroy()
			    else
				    object.Parent = nil
			    end
			    trackedObjects[object] = nil
		    end
        end
    end)
end

return Debris