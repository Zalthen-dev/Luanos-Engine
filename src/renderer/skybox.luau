local rl = require("@raylib")

local ffi = zune.ffi
local mem = zune.mem

local skybox = {}
skybox._loaded = false

local function loadMaterialOnModel(model, texture, const)
	local materials = ffi.ptrFromAddress(mem.slice(model, rl.Model:offset("materials"), 8))
	local maps = materials:readptr(rl.Material:offset("maps"))
	maps:write(const or 0, texture, 0, rl.TextureCubemap:size())
end

function skybox.Load(getMeshMethod)
    assert(not skybox._loaded, "attempted to load skybox after already loading it")
    print("Loading skybox...")

    skybox.Mesh = rl.GenMeshCube(1, 1, 1)
    skybox.Model = rl.LoadModelFromMesh(skybox.Mesh)
    skybox.Image = rl.LoadImage("./src/assets/sky/sky_default.png")
    skybox.CubeMap = rl.LoadTextureCubemap(skybox.Image, rl.CUBEMAP_LAYOUT_AUTO_DETECT)

    loadMaterialOnModel(skybox.Model, skybox.CubeMap, rl.MATERIAL_MAP_CUBEMAP)

    skybox._loaded = true
    print("Loaded skybox!")
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

function skybox.Draw(position)
    assert(skybox._loaded, "attempted to draw skybox before loading skybox")

    rl.rlDisableBackfaceCulling()
    rl.rlDisableDepthMask()

    rl.DrawModel(skybox.Model, position, 1, rl.WHITE)

    rl.rlEnableBackfaceCulling()
    rl.rlEnableDepthMask()
end

return skybox
