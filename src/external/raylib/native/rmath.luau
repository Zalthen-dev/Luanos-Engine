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

local Vector2 = raylib.Vector2
local Vector3 = raylib.Vector3
local Vector4 = raylib.Vector4
local Matrix = raylib.Matrix

type int = number
type uint = number
type bool = number
type float = number
type long = buffer
type double = number
type cstring = string | buffer | FFIPointer

type Vector2 = raylib.Vector4
type Vector4 = raylib.Vector4
type Vector4 = raylib.Vector4
type Matrix = raylib.Matrix

local function fn(returns: any, args: { any })
	return {
		returns = returns,
		args = args,
	}
end

export type Fns = {
	Vector2Zero: () -> Vector2,
	Vector2One: () -> Vector2,
	Vector2Add: (v1: Vector2, v2: Vector2) -> Vector2,
	Vector2AddValue: (v: Vector2, add: float) -> Vector2,
	Vector2Subtract: (v1: Vector2, v2: Vector2) -> Vector2,
	Vector2SubtractValue: (v: Vector2, add: float) -> Vector2,
	Vector2Length: (v: Vector2) -> float,
	Vector2LengthSqr: (v: Vector2) -> float,
	Vector2DotProduct: (v1: Vector2, v2: Vector2) -> float,
	Vector2CrossProduct: (v1: Vector2, v2: Vector2) -> float,
	Vector2Distance: (v1: Vector2, v2: Vector2) -> float,
	Vector2DistanceSqr: (v1: Vector2, v2: Vector2) -> float,
	Vector2Angle: (v1: Vector2, v2: Vector2) -> float,
	Vector2LineAngle: (v1: Vector2, v2: Vector2) -> float,
	Vector2Scale: (v: Vector2, scale: float) -> Vector2,
	Vector2Multiply: (v1: Vector2, v2: Vector2) -> Vector2,
	Vector2Negate: (v: Vector2) -> Vector2,
	Vector2Divide: (v1: Vector2, v2: Vector2) -> Vector2,
	Vector2Normalize: (v: Vector2) -> Vector2,
	Vector2Transform: (v: Vector2, mat: Matrix) -> Vector2,
	Vector2Lerp: (v1: Vector2, v2: Vector2, amount: float) -> Vector2,
	Vector2Reflect: (v: Vector2, normal: Vector2) -> Vector2,
	Vector2Min: (v1: Vector2, v2: Vector2) -> Vector2,
	Vector2Max: (v1: Vector2, v2: Vector2) -> Vector2,
	Vector2Rotate: (v: Vector2, angle: float) -> Vector2,
	Vector2MoveTowards: (v1: Vector2, target: Vector2, maxDistance: float) -> Vector2,

	Vector3Zero: () -> Vector3,
	Vector3One: () -> Vector3,

	Vector4Zero: () -> Vector4,
	Vector4One: () -> Vector4,

    Vector3Distance: (v1: Vector3, v2: Vector3) -> (float),
	Vector3DistanceSqr: (v1: Vector3, v2: Vector3) -> (float),
}

return {
    defs = {
        Vector3Distance = fn(float, {Vector3, Vector3}),
		Vector3DistanceSqr = fn(float, {Vector3, Vector3}),
    }
}
