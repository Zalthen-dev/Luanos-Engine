local Enum = require("@Enum")

local Rect = {}
Rect.__index = Rect
Rect.__type = "Rect"

function Rect.new(...)
    local args = {...}
    local width, height = 0, 0
    local min, max = 0, 0

    if #args == 2 then
        local vec2_1 = args[1]
        local vec2_2 = args[2]
        width, height = vec2_1.x, vec2_1.y
        min, max = vec2_2.x, vec2_2.y
    elseif #args == 4 then
        min, width = args[1], args[2]
        max, height = args[3], args[4]
    else
        error("Invalid parameters for Rect.new")
    end

    return setmetatable({
        Width = width,
        Height = height,
        Min = min,
        Max = max
    }, Rect)
end

return Rect