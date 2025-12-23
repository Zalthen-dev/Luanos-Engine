local NumberSequenceKeypoint = {}
NumberSequenceKeypoint.__index = NumberSequenceKeypoint
NumberSequenceKeypoint.__type = NumberSequenceKeypoint

function NumberSequenceKeypoint.new(...)
    local args = {...}
    local kTime, value, envelope = 0, 0, 0

    if #args == 2 then
        kTime = args[1]
        value = args[2]
    elseif #args == 3 then
        kTime = args[1]
        value = args[2]
        envelope = args[3]
    else
        error("Invalid arguments for NumberSequenceKeypoint.new")
    end

    return setmetatable({
        Time = kTime,
        Value = value,
        Envelope = envelope
    }, NumberSequenceKeypoint)
end

return NumberSequenceKeypoint