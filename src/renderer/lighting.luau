--[[
	Module script to handle lighting effects including light from the sun/moon
]]

local rl = require("@raylib")

local lighting = {}

-- from raylib repository examples/shaders/resources/shaders/glsl330/lighting.vs
lighting.shader_vs = [[
#version 330

in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;

uniform mat4 mvp;
uniform mat4 matModel;
uniform mat4 matNormal;

out vec3 fragPosition;
out vec2 fragTexCoord;
out vec4 fragColor;
out vec3 fragNormal;

void main() {
    fragPosition = vec3(matModel*vec4(vertexPosition, 1.0));
    fragTexCoord = vertexTexCoord;
    fragColor = vertexColor;
    fragNormal = normalize(vec3(matNormal*vec4(vertexNormal, 1.0)));

    gl_Position = mvp*vec4(vertexPosition, 1.0);
}
]]

-- from raylib repository examples/shaders/resources/shaders/glsl330/lighting.fs
lighting.shader_fs = [[
#version 330

in vec3 fragPosition;
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragNormal;

uniform sampler2D texture0;
uniform vec4 colDiffuse;

out vec4 finalColor;

#define     MAX_LIGHTS              128
#define     LIGHT_DIRECTIONAL       0
#define     LIGHT_POINT             1

struct Light {
    int enabled;
    int type;
    vec3 position;
    vec3 target;
    vec4 color;
};

uniform Light lights[MAX_LIGHTS];
uniform vec4 ambient;
uniform vec3 viewPos;

void main() {
    vec4 texelColor = texture(texture0, fragTexCoord);
    vec3 lightDot = vec3(0.0);
    vec3 normal = normalize(fragNormal);
    vec3 viewD = normalize(viewPos - fragPosition);
    vec3 specular = vec3(0.0);

    vec4 tint = colDiffuse*fragColor;
    for (int i = 0; i < MAX_LIGHTS; i++) {
        if (lights[i].enabled == 1) {
            vec3 light = vec3(0.0);

            if (lights[i].type == LIGHT_DIRECTIONAL) {
                light = -normalize(lights[i].target - lights[i].position);
            }

            if (lights[i].type == LIGHT_POINT) {
                light = normalize(lights[i].position - fragPosition);
            }

            float NdotL = max(dot(normal, light), 0.0);
            lightDot += lights[i].color.rgb*NdotL;

            float specCo = 0.0;
            if (NdotL > 0.0) specCo = pow(max(0.0, dot(viewD, reflect(-(light), normal))), 16.0);
            specular += specCo;
        }
    }

    finalColor = (texelColor*((tint + vec4(specular, 1.0))*vec4(lightDot, 1.0)));
    finalColor += texelColor*(ambient/10.0)*tint;
    finalColor = pow(finalColor, vec4(1.0/2.2));
}
]]

-- implementation based on LibreBox's implementation
-- see https://github.com/StayBlue/librebox-demo/blob/main/librebox/bootstrap/Renderer.cpp
function lighting.SunDirectionFromClockTime(clockTime: number): vector 
	clockTime = math.max(clockTime, 0) % 24

	local phi = math.pi*0.25
	local noon = math.sin(1 / math.sqrt(3))
	local w = (2*math.pi/24) * (clockTime - 6)
	local alpha = noon*math.sin(w)

	local ca = math.cos(alpha)
	local sa = math.sin(alpha)

	local cphi = math.cos(phi)
	local sphi = math.sin(phi)

	return vector.create(ca*cphi, -sa, ca*sphi)
end

return lighting