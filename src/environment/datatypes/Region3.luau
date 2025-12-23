local Vector3 = require("@Vector3")
local CFrame = require("@CFrame")

local Region3 = {}
Region3.__index = Region3
Region3.__type = "Region3"

function Region3.new(min: Vector3, max: Vector3)
    local diff = max - min

    return setmetatable({
        CFrame = CFrame.new(min + (diff/2)),
        Size = diff
    }, Region3)
end

function Region3:ExpandToGrid(resolution: number)
    -- TODO: actually implement this
    return self
end

return Region3