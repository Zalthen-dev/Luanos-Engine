local rl = require("@raylib")

local mesh = {}
mesh.Meshes = {}
mesh.Models = {}

function mesh.Load()
    mesh.Meshes.Block = rl.GenMeshCube(1, 1, 1)
    mesh.Meshes.Sphere = rl.GenMeshSphere(0.5, 16, 16)
    mesh.Meshes.Cylinder = rl.GenMeshCylinder(0.5, 1, 16)
    mesh.Meshes.Torus = rl.GenMeshTorus(1, 0.3, 16, 16)

    for name, meshObj in pairs(mesh.Meshes) do
        mesh.Models[name] = rl.LoadModelFromMesh(meshObj)
    end
end

function mesh.Unload()
    for _, mesh in pairs(mesh.Meshes) do
        rl.UnloadMesh(mesh)
    end

    for _, model in pairs(mesh.Models) do
        rl.UnloadModel(model)
    end

    mesh.Meshes = {}
    mesh.Models = {}
end

function mesh.Get(name)
    return mesh.Models[name] or mesh.Models.Block
end

return mesh
