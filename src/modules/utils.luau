local ffi = zune.ffi

local utils = {}

function utils.boolptr(value: number): FFIPointer
    local ptr = ffi.create(ffi.types.u8)
    ptr:writeu8(0, value)
    return ptr
end

function utils.AsBool(number)
    return math.round(number) ~= 0
end

return utils
