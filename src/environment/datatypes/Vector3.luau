local Vector3 = {}
Vector3.__index = Vector3
Vector3.__type = "Vector3"

function Vector3.__index(self, key)
    if key == "Magnitude" then
        local x, y, z = rawget(self, "X"), rawget(self, "Y"), rawget(self, "Z")
        return math.sqrt(x*x + y*y + z*z)
    end
    -- __type wasnt working for vector3 so i had to improvise..
    if key == "__type" then
        return "Vector3"
    end
    return rawget(self, key)
end

function Vector3.new(x, y, z)
    return setmetatable({
        X = x or 0,
        Y = y or 0,
        Z = z or 0
    }, Vector3)
end

function Vector3:Magnitude()
    local x, y, z = self.X, self.Y, self.Z
    return math.sqrt(x*x + y*y + z*z)
end

function Vector3:Unit()
    local mag = self:Magnitude()
    if mag == 0 then
        return Vector3.new(0, 0, 0)
    end
    return Vector3.new(self.X / mag, self.Y / mag, self.Z / mag)
end

function Vector3:Dot(v)
    return self.X*v.X + self.Y*v.Y + self.Z*v.Z
end

function Vector3:Cross(v)
    return Vector3.new(
        self.Y*v.Z - self.Z*v.Y,
        self.Z*v.X - self.X*v.Z,
        self.X*v.Y - self.Y*v.X
    )
end

function Vector3:Lerp(v, alpha)
    return Vector3.new(
        self.X + (v.X - self.X) * alpha,
        self.Y + (v.Y - self.Y) * alpha,
        self.Z + (v.Z - self.Z) * alpha
    )
end

function Vector3:__tostring()
    return string.format("Vector3(%g, %g, %g)", self.X, self.Y, self.Z)
end

function Vector3.__add(a, b)
    return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end

function Vector3.__sub(a, b)
    return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end

function Vector3.__mul(a, b)
    if type(a) == "number" then
        return Vector3.new(a*b.X, a*b.Y, a*b.Z)
    elseif type(b) == "number" then
        return Vector3.new(a.X*b, a.Y*b, a.Z*b)
    end
    error("Vector3 * Vector3 is not allowed; multiplication is scalar only")
end

function Vector3.__div(a, b)
    if type(b) ~= "number" then
        error("Vector3 division only supports scalar division")
    end
    return Vector3.new(a.X/b, a.Y/b, a.Z/b)
end

function Vector3.__unm(a)
    return Vector3.new(-a.X, -a.Y, -a.Z)
end

-- Constants
Vector3.zero  = table.freeze(Vector3.new(0, 0, 0))
Vector3.one   = table.freeze(Vector3.new(1, 1, 1))
Vector3.xAxis = table.freeze(Vector3.new(1, 0, 0))
Vector3.yAxis = table.freeze(Vector3.new(0, 1, 0))
Vector3.zAxis = table.freeze(Vector3.new(0, 0, 1))

return Vector3