--!strict
--!optimize 2
--!native

local raylib = require("./raylib")

local ffi = zune.ffi
local void = ffi.types.void
local int = ffi.types.i32
local uint = ffi.types.u32
local double = ffi.types.double
local bool = ffi.types.u8
local float = ffi.types.float
local cstring = ffi.types.pointer
local long = ffi.types.i64
local FFIPointer = ffi.types.FFIPointer
local Vector3 = ffi.types.Vector3

type int = number
type uint = number
type bool = number
type float = number
type long = buffer
type double = number
type cstring = string | buffer | FFIPointer

local function fn(returns: any, args: { any })
	return {
		returns = returns,
		args = args,
	}
end

export type Fns = {
    Vector3Distance: (v1: Vector3, v2: Vector3) -> (float),
}

return {
    defs = {
        Vector3Distance = fn(float, {Vector3, Vector3}),
    }
}
