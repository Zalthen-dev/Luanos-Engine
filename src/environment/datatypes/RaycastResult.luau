local Enum = require("@Enum")

local RaycastParams = {}
RaycastParams.__index = RaycastParams
RaycastParams.__type = "RaycastParams"

function RaycastParams.new()
    return setmetatable({
        Distance = 0,
        Instance = nil,
        Material = nil,
        Position = nil,
        Normal = nil
    }, RaycastParams)
end

return RaycastParams