local rl = require("@raylib")
local utils = require("@utils")

local rayutils = {}

function rayutils.MakeRect(x, y, w, h)
    return rl.Rectangle:new({x=x, y=y, width=w, height=h})
end

function rayutils.CubemapFromImages(imagePaths)
    assert(#imagePaths >= 6, ("ERROR: unable to build cubemap, needs 6 images, %i image(s) were provided"):format(#imagePaths))
    if #imagePaths > 6 then
        print("WARN: more than 6 images were provided, some may be unused")
    end

    local imgs = {}
    local sizes = {}

    for i, path in ipairs(imagePaths) do
        imgs[i] = rl.LoadImage(path)
        if imgs[i].data == nil then
            error("ERROR: failed to load image from path: " .. path)
        end

        local w = buffer.readi32(imgs[i], 4)
        local h = buffer.readi32(imgs[i], 4)

        sizes[i] = vector.create(w, h)
    end

    local w, h = sizes[1].x, sizes[1].y
    local cross = rl.GenImageColor(w*4, h*3, rl.WHITE)

    rl.ImageDraw(imgs[3], cross, rayutils.MakeRect(0, 0, sizes[3].x, sizes[3].y), rayutils.MakeRect(w, 0, sizes[3].x, sizes[3].y))
    rl.ImageDraw(imgs[4], cross, rayutils.MakeRect(0, 0, sizes[4].x, sizes[4].y), rayutils.MakeRect(w, h*2, sizes[4].x, sizes[4].y))
    rl.ImageDraw(imgs[2], cross, rayutils.MakeRect(0, 0, sizes[2].x, sizes[2].y), rayutils.MakeRect(0, h, sizes[2].x, sizes[2].y))
    rl.ImageDraw(imgs[5], cross, rayutils.MakeRect(0, 0, sizes[5].x, sizes[5].y), rayutils.MakeRect(w, h, sizes[5].x, sizes[5].y))
    rl.ImageDraw(imgs[1], cross, rayutils.MakeRect(0, 0, sizes[1].x, sizes[1].y), rayutils.MakeRect(w*2, h, sizes[1].x, sizes[1].y))
    rl.ImageDraw(imgs[6], cross, rayutils.MakeRect(0, 0, sizes[6].x, sizes[6].y), rayutils.MakeRect(w*3, h, sizes[6].x, sizes[6].y))

    for _, img in ipairs(imgs) do
        rl.UnloadImage(img)
    end

    local cubemap = rl.LoadTextureCubemap(cross, rl.CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE)
    rl.UnloadImage(cubemap)

    return cubemap
end

function rayutils.GetMaterialsPtr(model: buffer)
    return utils.ptrFromStructFieldBuf(model, rl.Model:offset("materials"))
end

function rayutils.SetMaterialShaderOnModel(model: buffer, shader: buffer)
    local materials = rayutils.GetMaterialsPtr(model)
    materials:write(rl.Material:offset("shader"), shader, 0, rl.Shader:size())
end

function rayutils.SetShaderLocation(shader: buffer, locIndex: number, locValue: number)
    local locs = utils.ptrFromStructFieldBuf(shader, rl.Shader:offset("locs"))
    locs:writei32(locIndex * 4, locValue)
end

function rayutils.SetMaterialMapTexture(model: buffer, mapIndex: number, texture: buffer)
    local materials = rayutils.GetMaterialsPtr(model)
    local maps = utils.ptrFromStructFieldPtr(materials, rl.Material:offset("maps"))
    local dst = mapIndex * rl.MaterialMap:size() + rl.MaterialMap:offset("texture")
    maps:write(dst, texture, 0, rl.TextureCubemap:size())
end

function rayutils.EulerDegToQuaternion(euler: Vector3): (number, number, number, number)
    local rx = math.rad(euler.X)
    local ry = math.rad(euler.Y)
    local rz = math.rad(euler.Z)

    local cx, sx = math.cos(rx * 0.5), math.sin(rx * 0.5)
    local cy, sy = math.cos(ry * 0.5), math.sin(ry * 0.5)
    local cz, sz = math.cos(rz * 0.5), math.sin(rz * 0.5)

    local w = cz * cy * cx + sz * sy * sx
    local x = cz * cy * sx - sz * sy * cx
    local y = cz * sy * cx + sz * cy * sx
    local z = sz * cy * cx - cz * sy * sx

    local len = math.sqrt(x*x + y*y + z*z + w*w)
    if len > 0 then
        x, y, z, w = x/len, y/len, z/len, w/len
    else
        x, y, z, w = 0, 0, 0, 1
    end
	
    return x, y, z, w
end

function rayutils.EulerToAxisAngle(eulerDeg)
	local qx,qy,qz,qw = rayutils.EulerDegToQuaternion(eulerDeg)

    qw = math.max(-1, math.min(1, qw))
    local angleRad = 2 * math.acos(qw)

    local s2 = 1 - qw * qw
    if s2 < 1e-12 then
        return vector.create(1, 0, 0), 0
    end

    local s = math.sqrt(s2)
    local ax, ay, az = qx / s, qy / s, qz / s

    local alen = math.sqrt(ax*ax + ay*ay + az*az)
    if alen == 0 then
        return vector.create(1, 0, 0), 0
    end
    ax, ay, az = ax/alen, ay/alen, az/alen

    return vector.create(ax, ay, az), math.deg(angleRad)
end

function rayutils.QuaternionToEulerDeg(x: number, y: number, z: number, w: number): (number, number, number)
    local len = math.sqrt(x*x + y*y + z*z + w*w)
    if len == 0 then
        return 0, 0, 0
    end
    x, y, z, w = x/len, y/len, z/len, w/len

    -- X (roll)
    local sinr_cosp = 2 * (w*x + y*z)
    local cosr_cosp = 1 - 2 * (x*x + y*y)
    local rx = math.atan2(sinr_cosp, cosr_cosp)

    -- Y (pitch)
    local sinp = 2 * (w*y - z*x)
    local ry
    if math.abs(sinp) >= 1 then
        ry = (sinp >= 0) and (math.pi/2) or (-math.pi/2) -- clamp
    else
        ry = math.asin(sinp)
    end

    -- Z (yaw)
    local siny_cosp = 2 * (w*z + x*y)
    local cosy_cosp = 1 - 2 * (y*y + z*z)
    local rz = math.atan2(siny_cosp, cosy_cosp)

    return math.deg(rx), math.deg(ry), math.deg(rz)
end

function rayutils.Color3ToRaylib(c, transparency)
	local r, g, b = c:ToRGB()
	return rl.Color:new({
		r = r,
		g = g,
		b = b,
		a = math.floor(255 * (1 - transparency)),
	})
end

function rayutils.MakeMatrix(position, rotation, scale): rl.Matrix
    scale = scale or { x = 1, y = 1, z = 1 }

    local px, py, pz = position.x, position.y, position.z
    local rx, ry, rz = rotation.x, rotation.y, rotation.z
    local sx, sy, sz = scale.x, scale.y, scale.z

    local cx, sxr = math.cos(rx), math.sin(rx)
    local cy, syr = math.cos(ry), math.sin(ry)
    local cz, szr = math.cos(rz), math.sin(rz)

    -- Rotation matrix (Rz * Ry * Rx)
    local r00 =  cy * cz
    local r01 =  cy * szr
    local r02 = -syr

    local r10 = sxr * syr * cz - cx * szr
    local r11 = sxr * syr * szr + cx * cz
    local r12 = sxr * cy

    local r20 = cx * syr * cz + sxr * szr
    local r21 = cx * syr * szr - sxr * cz
    local r22 = cx * cy

    -- Apply scale
    r00 *= sx; r01 *= sx; r02 *= sx
    r10 *= sy; r11 *= sy; r12 *= sy
    r20 *= sz; r21 *= sz; r22 *= sz

    -- Build Raylib Matrix (column-major, interleaved)
    return rl.Matrix:new({
        m0  = r00, m4  = r01, m8  = r02, m12 = px,
        m1  = r10, m5  = r11, m9  = r12, m13 = py,
        m2  = r20, m6  = r21, m10 = r22, m14 = pz,
        m3  = 0,   m7  = 0,   m11 = 0,   m15 = 1
    })
end

return rayutils