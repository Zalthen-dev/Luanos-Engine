--!strict
--!optimize 2
--!native

local raylib = require("./raylib")

local ffi = zune.ffi
local void = ffi.types.void
local int = ffi.types.i32
local uint = ffi.types.u32
local bool = ffi.types.u8
local float = ffi.types.float
local cstring = ffi.types.pointer
local long = ffi.types.i64
local FFIPointer = ffi.types.FFIPointer

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
    rlEnableDepthTest: () -> (),
    rlDisableDepthTest: () -> (),
    rlEnableDepthMask: () -> (),
    rlDisableDepthMask: () -> (),
    rlEnableBackfaceCulling: () -> (),
    rlDisableBackfaceCulling: () -> (),
}

return {
    def = {
        rlEnableDepthTest = fn(void, {}),
        rlDisableDepthTest = fn(void, {}),
        rlEnableDepthMask = fn(void, {}),
        rlDisableDepthMask = fn(void, {}),
        rlEnableBackfaceCulling = fn(void, {}),
        rlDisableBackfaceCulling = fn(void, {}),
    }
}