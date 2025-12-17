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

return rayutils
