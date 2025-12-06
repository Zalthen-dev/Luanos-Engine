local rl = require("@raylib")

local ffi = zune.ffi
local mem = zune.mem

local skybox = {}
skybox._loaded = false

local function PutCubemapOntoModel(model, texture)
    local materials = ffi.ptrFromAddress(mem.slice(model, rl.Model:offset("materials"), 8))
    local maps = materials:readptr(rl.Material:offset("maps"))

    maps:write(rl.MATERIAL_MAP_CUBEMAP * rl.TextureCubemap:size(), texture, 0, rl.TextureCubemap:size())
end

function skybox.Load()
    assert(not skybox._loaded, "attempted to load skybox after already loading it")

    skybox.Mesh = rl.GenMeshCube(1, 1, 1)
    skybox.Model = rl.LoadModelFromMesh(skybox.Mesh)
    skybox.Image = rl.LoadImage("./src/assets/sky/sky_default.png")
    skybox.CubeMap = rl.LoadTextureCubemap(skybox.Image, rl.CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE)

    PutCubemapOntoModel(skybox.Model, skybox.CubeMap)
    
    skybox._loaded = true
end

function skybox.Unload()
    assert(skybox._loaded, "attempted to unload skybox after already unloading it")
    print("Unloading skybox...")
    skybox._loaded = false

    skybox.Mesh = nil
    skybox.Model = nil
    skybox.Image = nil
    skybox.CubeMap = nil

    print("Unloaded skybox!")
end

function skybox.Draw()
    assert(skybox._loaded, "attempted to draw skybox before loading skybox")

    rl.rlDisableDepthTest()
    rl.rlDisableDepthMask()
    rl.rlDisableBackfaceCulling()

    rl.DrawModel(skybox.Model, vector.zero, 100, rl.WHITE)

    rl.rlEnableBackfaceCulling()
    rl.rlEnableDepthMask()
    rl.rlEnableDepthTest()
end

return skybox
