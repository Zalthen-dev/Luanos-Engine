local Enum = require("@Enum")

local RaycastParams = {}
RaycastParams.__index = RaycastParams
RaycastParams.__type = "RaycastParams"

function RaycastParams.new()
    return setmetatable({
        FilterDescendantsInstances = {},
        FilterType = Enum.RaycastFilterType.Exclude,
        IgnoreWater = false,
        CollisionGroup = "",
        RespectCanCollide = false,
        BruteForceAllSlow = false
    }, RaycastParams)
end

return RaycastParams