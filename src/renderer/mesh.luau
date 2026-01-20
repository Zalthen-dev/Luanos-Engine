local rl = require("@raylib")
local Enum = require("@Enum")

local mesh = {}
mesh.Meshes = {}
mesh.Models = {}

function mesh.Load()
    print("Loading meshes...")

    mesh.Meshes.Block = rl.GenMeshCube(1, 1, 1)
    mesh.Meshes.Sphere = rl.GenMeshSphere(0.5, 16, 16)
    mesh.Meshes.Cylinder = rl.GenMeshCylinder(0.5, 1, 16)
    mesh.Meshes.Torus = rl.GenMeshTorus(2, 0.3, 16, 16)

    for name, meshObj in pairs(mesh.Meshes) do
        mesh.Models[name] = rl.LoadModelFromMesh(meshObj)
    end

    print("Loaded meshes!")
end

function mesh.Unload()
    print("Unloading meshes...")

    table.clear(mesh.Meshes)
    table.clear(mesh.Models)

    print("Unloaded meshes!")
end

function mesh.Get(name: string|number)
    if type(name) == "number" then
        if name == Enum.PartType.Block then
            return mesh.Models.Block
        elseif name == Enum.PartType.Ball then
            return mesh.Models.Sphere
        elseif name == Enum.PartType.Cylinder then
            return mesh.Models.Cylinder
        elseif name == Enum.PartType.Torus then
            return mesh.Models.Torus
        end

        return mesh.Models.Block
    end

    return mesh.Models[name] or mesh.Models.Block
end

return mesh
