local ffi = zune.ffi

local utils = {}
local U32 = 4294967296

function utils.AsBool(number): boolean
	return number ~= 0
end

function utils.BoolPtr(value: number): FFIPointer
	local ptr = ffi.create(ffi.types.u8)
	ptr:writeu8(0, value)
	return ptr
end

function utils.SetBoolPtr(ptr: FFIPointer, value: number)
	ptr:writeu8(0, value)
end

function utils.ValueFromBoolPtr(ptr: FFIPointer): number
	return ptr:readu8(0)
end

function utils.FloatPtr(value: number): FFIPointer
	local ptr = ffi.create(ffi.types.float)
	ptr:writef32(0, value)
	return ptr
end

function utils.SetFloatPtr(ptr: FFIPointer, value: float)
	ptr:writef32(value)
end

function utils.ValueFromFloatPtr(ptr: FFIPointer): float
	return ptr:readf32(0)
end

function utils.IntPtr(value: number): FFIPointer
	local ptr = ffi.create(ffi.types.i32)
	ptr:writei32(0, value)
	return ptr
end

function utils.ReadPtr64FromBuffer(buf: buffer, off: number): number
	local lo = buffer.readu32(buf, off)
	local hi = buffer.readu32(buf, off + 4)
	return hi * U32 + lo
end

function utils.ReadPtr64FromPtr(ptr, off: number): number
	local lo = ptr:readu32(off)
	local hi = ptr:readu32(off + 4)
	return hi * U32 + lo
end

function utils.ptrFromU64(addr: number)
	local b = buffer.create(8)
	local hi = math.floor(addr / U32)
	local lo = addr - hi * U32
	buffer.writeu32(b, 0, lo)
	buffer.writeu32(b, 4, hi)
	return ffi.ptrFromAddress(b)
end

function utils.ptrFromStructFieldBuf(structBuf: buffer, fieldOff: number): FFIPointer
	return utils.ptrFromU64(utils.ReadPtr64FromBuffer(structBuf, fieldOff))
end

function utils.ptrFromStructFieldPtr(structPtr: FFIPointer, fieldOff: number): FFIPointer
	return utils.ptrFromU64(utils.ReadPtr64FromPtr(structPtr, fieldOff))
end


function utils.isFinite(value: number)
	return (value == value) and (math.abs(value) < math.huge)
end

return utils
