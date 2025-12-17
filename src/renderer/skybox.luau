local rl = require("@raylib")
local utils = require("@utils")
local rayutils = require("@rayutils")

local ffi = zune.ffi
local mem = zune.mem

local fs = [[
#version 330

// Input vertex attributes (from vertex shader)
in vec3 fragPosition;

// Input uniform values
uniform samplerCube environmentMap;
uniform bool vflipped;
uniform bool doGamma;

// Output fragment color
out vec4 finalColor;

void main()
{
    // Fetch color from texture map
    vec3 color = vec3(0.0);

    if (vflipped) color = texture(environmentMap, vec3(fragPosition.x, -fragPosition.y, fragPosition.z)).rgb;
    else color = texture(environmentMap, fragPosition).rgb;

    if (doGamma)// Apply gamma correction
    {
        color = color/(color + vec3(1.0));
        color = pow(color, vec3(1.0/2.2));
    }

    // Calculate final fragment color
    finalColor = vec4(color, 1.0);
}
]]

local vs = [[
#version 330

// Input vertex attributes
in vec3 vertexPosition;

// Input uniform values
uniform mat4 matProjection;
uniform mat4 matView;

// Output vertex attributes (to fragment shader)
out vec3 fragPosition;

void main()
{
    // Calculate fragment position based on model transformations
    fragPosition = vertexPosition;

    // Remove translation from the view matrix
    mat4 rotView = mat4(mat3(matView));
    vec4 clipPos = matProjection*rotView*vec4(vertexPosition, 1.0);

    // Calculate final vertex position
    gl_Position = clipPos;
}
]]

local skybox = {}
skybox._loaded = false

function skybox.Load()
    assert(not skybox._loaded, "attempted to load skybox after already loading it")
    print("Loading skybox...")

    skybox.Mesh = rl.GenMeshCube(1, 1, 1)
    skybox.Model = rl.LoadModelFromMesh(skybox.Mesh)

    skybox.Shader = rl.LoadShaderFromMemory(vs, fs)

    local envLoc = rl.GetShaderLocation(skybox.Shader, "environmentMap")
    assert(envLoc ~= -1, "skybox shader missing uniform: environmentMap")

    rayutils.SetShaderLocation(skybox.Shader, rl.SHADER_LOC_MAP_CUBEMAP, envLoc)
    rayutils.SetMaterialShaderOnModel(skybox.Model, skybox.Shader)

    local img = rl.LoadImage("./src/assets/sky/sky_default.png")
    skybox.CubeMap = rl.LoadTextureCubemap(img, rl.CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE)
    rl.UnloadImage(img)

    rayutils.SetMaterialMapTexture(skybox.Model, rl.MATERIAL_MAP_CUBEMAP, skybox.CubeMap)

    skybox._loaded = true
    print("Loaded skybox!")
end

function skybox.Unload()
    assert(skybox._loaded, "attempted to unload skybox after already unloading it")
    print("Unloading skybox...")

    skybox._loaded = false

    skybox.Mesh = nil
    skybox.Model = nil
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
