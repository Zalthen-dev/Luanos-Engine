local Signal = require("@signal")
local rl = require("@raylib")

local Skybox = require("./renderer/skybox")
local Mesh = require("./renderer/mesh")

local task = zune.task
local mem = zune.mem

local renderer = {}

renderer.WindowFlags = rl.FLAG_WINDOW_RESIZABLE
renderer.TargetFPS = 360

renderer.CAMERA_SPEED = 25
renderer.MOUSE_SENSITIVITY = 0.008

local worldUp = vector.create(0, 1, 0)

renderer.MainSignal = Signal.new()
renderer.RenderPool = {}

local camera_position = vector.create(0, 2, -5)
local camera_yaw = 0
local camera_pitch = 0
local camera_rotatingCamera = false
local camera_warpingThisFrame = false
local mouse_anchorPos = vector.create(0, 0)
local camera = rl.Camera3D:new({
    position = vector.create(0, 2, -5),
    target = vector.create(0, 2, 0),
    up = vector.create(0, 1, 0),
    fovy = 70,
    projection = rl.CAMERA_PERSPECTIVE,
})

local function EulerToAxisAngleRad(euler: Vector3): (vector, number)
	local cx, sx = math.cos(euler.X / 2), math.sin(euler.X / 2)
	local cy, sy = math.cos(euler.Y / 2), math.sin(euler.Y / 2)
	local cz, sz = math.cos(euler.Z / 2), math.sin(euler.Z / 2)

	-- Quaternion multiplication: q = qz * qy * qx
	local qw = cz * cy * cx + sz * sy * sx
	local qx = cz * cy * sx - sz * sy * cx
	local qy = cz * sy * cx + sz * cy * sx
	local qz = sz * cy * cx - cz * sy * sx

	local angle = 2 * math.acos(math.clamp(qw, -1, 1))
	local s = math.sqrt(1 - qw * qw)
	if s < 0.0001 then
		-- If s is near zero, axis direction is arbitrary
		return vector.create(1, 0, 0), 0
	else
		return vector.create(qx / s, qy / s, qz / s), angle
	end
end

local function Color3ToRaylib(c, transparency)
	local r, g, b = c:ToRGB()
	return rl.Color:new({
		r = r,
		g = g,
		b = b,
		a = math.floor(255 * (1 - transparency)),
	})
end

function renderer.UpdateFreecam(camera: rl.Camera3D, delta: number)
    local mouseDelta = rl.GetMouseDelta()
    local mouseWheelDelta = rl.GetMouseWheelMove()
    local moveSpeed = renderer.CAMERA_SPEED * delta

    if rl.IsKeyDown(rl.KEY_LEFT_SHIFT) == 1 then
        moveSpeed *= 0.25
    end

    if mouseWheelDelta ~= 0 then
        local screenRay = rl.GetScreenToWorldRay(rl.GetMousePosition(), camera)
        camera_position += (mem.toVector3(screenRay, 12) * mouseWheelDelta)
    end

    if rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_RIGHT) == 1 then
        mouse_anchorPos = rl.GetMousePosition()
        camera_rotatingCamera = true
        camera_warpingThisFrame = true
    end

    if rl.IsMouseButtonReleased(rl.MOUSE_BUTTON_RIGHT) == 1 then
        camera_rotatingCamera = false
        camera_warpingThisFrame = false
    end

    if camera_rotatingCamera then
        if camera_warpingThisFrame then
            local limit = (math.pi/2)-0.01

            camera_yaw += mouseDelta.x * renderer.MOUSE_SENSITIVITY
            camera_pitch = math.clamp(camera_pitch - mouseDelta.y * renderer.MOUSE_SENSITIVITY, -limit, limit)
        else
            --rl.SetMousePosition(mouse_anchorPos.x, mouse_anchorPos.y)
        end

        camera_warpingThisFrame = not camera_warpingThisFrame
    end

    local forward = vector.create(
        math.cos(camera_pitch) * math.cos(camera_yaw),
        math.sin(camera_pitch),
        math.cos(camera_pitch) * math.sin(camera_yaw)
    )

    local right = vector.normalize(vector.cross(worldUp, forward))
    local up = vector.normalize(vector.cross(forward, right))

    local inputForward = rl.IsKeyDown(rl.KEY_W) - rl.IsKeyDown(rl.KEY_S)
    local inputSideway = rl.IsKeyDown(rl.KEY_A) - rl.IsKeyDown(rl.KEY_D)
    local inputUpward = (rl.IsKeyDown(rl.KEY_SPACE) or rl.IsKeyDown(rl.KEY_E)) - rl.IsKeyDown(rl.KEY_Q)

    camera_position += forward * (inputForward * moveSpeed)
    camera_position += right * (inputSideway * moveSpeed)
    camera_position += up * (inputUpward * moveSpeed)

    local target = camera_position + forward
    mem.writeVector3(camera, 0, camera_position)
    mem.writeVector3(camera, 12, target)
end

function renderer.DrawModel(model, part)
    local axis, angle = EulerToAxisAngleRad(part.Rotation)

    local position = vector.create(part.Position.X, part.Position.Y, part.Position.Z)
    local scale = vector.create(part.Size.X, part.Size.Y, part.Size.Z)
    local tint = Color3ToRaylib(part.Color, part.Transparency)

    rl.DrawModelEx(
        model, 
        position, 
        axis, 
        angle, 
        scale, 
        tint
    )
end
local function DrawPart(part)
    if part.ClassName == "MeshPart" then
        --renderer.DrawModel(Mesh.GetMesh(part.Shape), part)
    else
        renderer.DrawModel(Mesh.Get(part.Shape), part)
    end

    renderer.MainSignal:Fire("Rendered", part)
end

function renderer.SetTargetFPS(fps: number)
    renderer.TargetFPS = fps
    rl.SetTargetFPS(fps)
end

function renderer.AddToRenderPool(data)
    table.insert(renderer.RenderPool, data)
    renderer.MainSignal:Fire("AddedObjectToRenderPool", data())
end

function renderer.OnStart()
    Mesh.Load()
    Skybox.Load()
end

function renderer.OnEnd()
    Mesh.Unload()
    Skybox.Unload()
end

function renderer.RenderScene()
    local time = rl.GetTime()
    local delta = rl.GetFrameTime()

    renderer.MainSignal:Fire("PreRender", delta)
    do rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        renderer.UpdateFreecam(camera, delta)
        do rl.BeginMode3D(camera)
            Skybox.Draw()
            rl.DrawGrid(1024, 1)
            
            for _, part in renderer.RenderPool do
                local part = part()
                DrawPart(part)
            end

        end; rl.EndMode3D()

        rl.DrawFPS(10, 10)
        rl.DrawText(tostring(task.count()) .. " tasks", 10, 30, 20, rl.WHITE)
        rl.DrawText(tostring(#renderer.RenderPool) .. " render pool", 10, 50, 20, rl.WHITE)

    end; rl.EndDrawing()

    renderer.MainSignal:Fire("Heartbeat", delta)
    task.wait()
end

return renderer
