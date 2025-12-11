local NumberRange = {}

function NumberRange.new(...)
    local args = {...}

    local min = 0
    local max = 0

    if #args == 1 then
        local val = args[1]
        if type(val) ~= "number" then
            error("expected number when constructing NumberRange, got " .. typeof(val))
        end

        min = val
        max = val
    elseif #args == 2 then
        min = args[1]
        max = args[2]

        if type(min) ~= "number" then
            error("expected number when constructing NumberRange, got " .. typeof(min))
        end

        if type(max) ~= "number" then
            error("expected number when constructing NumberRange, got " .. typeof(max))
        end
    end

    if not min or not max then
        error("attempted to construct NumberRange without a minimum or a maximum")
    end

    return setmetatable({
        Min = min,
        Max = max
    }, NumberRange)
end

return NumberRange
