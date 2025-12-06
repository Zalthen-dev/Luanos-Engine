--!strict
local rl = require("@raylib")

local skybox = {}
skybox._loaded = false

-- Shader uniform locations
skybox.uInner = -1
skybox.uOuter = -1
skybox.uEnvMap = -1

-- Shader sources
skybox.SKY_VS = [[
#version 330
in vec3 vertexPosition;
out vec3 dir;
uniform mat4 matView;
uniform mat4 matProjection;

void main() {
    dir = vertexPosition;
    mat3 R = mat3(matView);
    mat4 viewNoTrans = mat4(
        vec4(R[0], 0.0),
        vec4(R[1], 0.0),
        vec4(R[2], 0.0),
        vec4(0.0, 0.0, 0.0, 1.0)
    );
    gl_Position = matProjection * viewNoTrans * vec4(vertexPosition, 1.0);
}
]]

skybox.SKY_FS = [[
#version 330
in vec3 dir;
out vec4 FragColor;

uniform vec3 innerColor;
uniform vec3 outerColor;
uniform samplerCube environmentMap;

void main() {
    vec3 nd = normalize(dir);
    float t = clamp(nd.y * 0.5 + 0.5, 0.0, 1.0);
    vec3 col = mix(innerColor, outerColor, t);

    // sample cubemap (optional, can be used to mix)
    vec3 env = texture(environmentMap, nd).rgb;
    col = mix(col, env, 0.5);

    // gamma correction
    FragColor = vec4(pow(col, vec3(1.0/2.2)), 1.0);
}
]]

skybox.SkyObject = {
    Mesh = nil,
    Shader = nil,
    Cubemap = nil
}

-- Load the skybox
function skybox.Load()
    if skybox._loaded then return end

    -- Cube mesh
    skybox.SkyObject.Mesh = rl.GenMeshCube(1, 1, 1)

    -- Shader
    skybox.SkyObject.Shader = rl.LoadShaderFromMemory(skybox.SKY_VS, skybox.SKY_FS)

    -- TODO: load your 6 skybox textures here
    -- Example:
    -- local cubemapFiles = { "right.png", "left.png", "top.png", "bottom.png", "front.png", "back.png" }
    -- skybox.SkyObject.Cubemap = rl.LoadTextureCubemap(cubemapFiles, rl.CUBEMAP_LAYOUT_AUTO)
    -- For now, we just create an empty cubemap placeholder
    skybox.SkyObject.Cubemap = rl.LoadTextureCubemap({
        "right.png", "left.png", "top.png", "bottom.png", "front.png", "back.png"
    }, rl.CUBEMAP_LAYOUT_AUTO_DETECT)

    -- Uniform locations
    skybox.uInner = rl.GetShaderLocation(skybox.SkyObject.Shader, "innerColor")
    skybox.uOuter = rl.GetShaderLocation(skybox.SkyObject.Shader, "outerColor")
    skybox.uEnvMap = rl.GetShaderLocation(skybox.SkyObject.Shader, "environmentMap")

    skybox._loaded = true
end

-- Unload skybox resources
function skybox.Unload()
    if not skybox._loaded then return end

    rl.UnloadMesh(skybox.SkyObject.Mesh)
    rl.UnloadShader(skybox.SkyObject.Shader)
    rl.UnloadTexture(skybox.SkyObject.Cubemap)

    skybox.SkyObject = {}
    skybox._loaded = false
end

-- Render skybox
function skybox.Render()
    assert(skybox._loaded, "Attempted to render skybox before loading")

    local shader = skybox.SkyObject.Shader
    local mesh = skybox.SkyObject.Mesh
    local cubemap = skybox.SkyObject.Cubemap

    -- Inner and outer colors
    local inner = rl.Color:new({0.25, 0.55, 0.65})
    local outer = rl.Color:new({0.05, 0.15, 0.45})

    rl.rlDisableDepthTest()
    rl.rlDisableDepthMask()
    rl.rlDisableBackfaceCulling()

    -- Begin shader mode
    rl.BeginShaderMode(shader)

    -- Set uniforms
    rl.SetShaderValue(shader, skybox.uInner, inner, rl.SHADER_UNIFORM_VEC3)
    rl.SetShaderValue(shader, skybox.uOuter, outer, rl.SHADER_UNIFORM_VEC3)
    rl.SetShaderValueTexture(shader, skybox.uEnvMap, cubemap)

    -- Draw cube
    rl.DrawMesh(mesh, rl.MatrixIdentity())

    rl.EndShaderMode()

    rl.rlEnableBackfaceCulling()
    rl.rlEnableDepthMask()
    rl.rlEnableDepthTest()
end

return skybox
