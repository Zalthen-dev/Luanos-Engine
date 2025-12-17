local Signal = require("@signal")
local rl = require("@raylib")
local imgui = require("@rimgui")
local utils = require("@utils")

local scripteditor = require("./gui/output")

local Skybox = require("./renderer/skybox")
local Mesh = require("./renderer/mesh")

local ffi = zune.ffi
local task = zune.task
local mem = zune.mem

local renderer = {}

renderer.CAMERA_SPEED = 25
renderer.MOUSE_SENSITIVITY = 0.008

local worldUp = vector.create(0, 1, 0)

local EngineState = nil

renderer.MainSignal = Signal.new()
renderer.RenderPool3D = {}
renderer.RenderPool2D = {}
renderer.RenderWindows = {}

local function DrawTextOutlined(text:string, posX:number, posY:number, fontSize:number, color: rl.Color, outlineSize:number, outlineColor:rl.Color)
    rl.DrawText(text, posX - outlineSize, posY - outlineSize, fontSize, outlineColor);
    rl.DrawText(text, posX, posY - outlineSize, fontSize, outlineColor);
    rl.DrawText(text, posX + outlineSize, posY - outlineSize, fontSize, outlineColor);

    rl.DrawText(text, posX - outlineSize, posY, fontSize, outlineColor);
    rl.DrawText(text, posX + outlineSize, posY, fontSize, outlineColor);

    rl.DrawText(text, posX - outlineSize, posY + outlineSize, fontSize, outlineColor);
    rl.DrawText(text, posX, posY + outlineSize, fontSize, outlineColor);
    rl.DrawText(text, posX + outlineSize, posY + outlineSize, fontSize, outlineColor);

    rl.DrawText(text, posX, posY, fontSize, color);
end

local function ShouldDrawPart(part, camera, cam_pos, cam_target, cam_fovy)
    local cx, cy, cz = part.Position.X, part.Position.Y, part.Position.Z
    local pos = vector.create(cx, cy, cz)

    local sx, sy, sz = part.Size.X, part.Size.Y, part.Size.Z
    local radius = vector.magnitude(vector.create(sx, sy, sz))*0.5

    local toPart = pos - cam_pos
    local dist = vector.magnitude(toPart)

    if dist > radius * 600 then
        return false
    end

    if dist < radius then
        return true
    end

    local forward = cam_target - cam_pos
    local fwdLen = vector.magnitude(forward)
    if fwdLen < 0.0001 then
        return true
    end
    forward = forward / fwdLen

    if vector.dot(forward, toPart) <= -radius then
        return false
    end

    local screen = rl.GetWorldToScreen(pos, camera)
    local w = rl.GetScreenWidth()
    local h = rl.GetScreenHeight()

    if screen.x >= -radius and screen.x <= w + radius
       and screen.y >= -radius and screen.y <= h + radius then
        return true
    end

    local projected_size =
        radius / dist * (h / math.tan(math.rad(cam_fovy*0.5)))

    if projected_size >= 1 then
        return true
    end

    return false
end

local camera_position = vector.create(0, 2, -5)
local camera_yaw = 0
local camera_pitch = 0
local camera_fovy = 70
local camera_target = vector.create(0, 2, 0)
local camera_rotatingCamera = false
local camera_warpingThisFrame = false
local mouse_anchorPos = vector.create(0, 0)

local camera = rl.Camera3D:new({
    position = vector.create(0, 2, -5),
    target = vector.create(0, 2, 0),
    up = vector.create(0, 1, 0),
    fovy = camera_fovy,
    projection = rl.CAMERA_PERSPECTIVE,
})

local camera2d = rl.Camera2D:new({vector.zero, vector.zero, 0, 1})

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

    if imgui.IsAnyItemFocused() == 0 then
        local inputForward = rl.IsKeyDown(rl.KEY_W) - rl.IsKeyDown(rl.KEY_S)
        local inputSideway = rl.IsKeyDown(rl.KEY_A) - rl.IsKeyDown(rl.KEY_D)
        local inputUpward = (rl.IsKeyDown(rl.KEY_SPACE) or rl.IsKeyDown(rl.KEY_E)) - rl.IsKeyDown(rl.KEY_Q)

        camera_position += forward * (inputForward * moveSpeed)
        camera_position += right * (inputSideway * moveSpeed)
        camera_position += up * (inputUpward * moveSpeed) 
    end

    camera_target = camera_position + forward
    mem.writeVector3(camera, 0, camera_position)
    mem.writeVector3(camera, 12, camera_target)
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

function renderer.AddToRenderPool3D(data)
    table.insert(renderer.RenderPool3D, data)
    renderer.MainSignal:Fire("AddedObjectToRenderPool3D", data())
end

function renderer.AddToRenderPool2D(data)
    table.insert(renderer.RenderPool2D, data)
    renderer.MainSignal:Fire("AddedObjectToRenderPool2D", data())
end

function renderer.OnStart(engineState)
    EngineState = engineState 

    imgui.rImGuiSetup()
    imgui.rImGuiDisableIO()
    Mesh.Load()
    Skybox.Load()
end

function renderer.OnEnd()
    imgui.rImGuiShutdown()
    Mesh.Unload()
    Skybox.Unload()
end

function renderer.RenderScene()
    local time = rl.GetTime()
    local delta = rl.GetFrameTime()

    renderer.MainSignal:Fire("PreRender", delta)

    do rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)

        local width = rl.GetScreenWidth()
        local height = rl.GetScreenHeight()

        local actuallyDrawn3d = 0

        renderer.UpdateFreecam(camera, delta)
        do rl.BeginMode3D(camera)
            Skybox.Draw(camera_position)
            
            for i, part in renderer.RenderPool3D do
                local part = part()
                if not part.Children or part.Destroyed then 
                    table.remove(renderer.RenderPool3D, i)
                    continue 
                end

                if ShouldDrawPart(part, camera, camera_position, camera_target, camera_fovy) then
                    DrawPart(part)
                    actuallyDrawn3d += 1
                end
            end

        end; rl.EndMode3D()

        DrawTextOutlined(tostring(rl.GetFPS()) .. " FPS", 10, 30, 20, rl.GREEN, 2, rl.BLACK)
        DrawTextOutlined(tostring(task.count()) .. " tasks", 10, 50, 20, rl.WHITE, 2, rl.BLACK)
        DrawTextOutlined(tostring(#renderer.RenderPool3D) .. " render pool 3D", 10, 70, 20, rl.WHITE, 2, rl.BLACK)
        DrawTextOutlined(tostring(#renderer.RenderPool2D) .. " render pool 2D", 10, 90, 20, rl.WHITE, 2, rl.BLACK)
        DrawTextOutlined(tostring(actuallyDrawn3d) .. " drawn parts", 10, 110, 20, rl.WHITE, 2, rl.BLACK)

        imgui.rImGuiBegin()
        scripteditor:Draw(EngineState);

        for _, window in renderer.RenderWindows do
            window:Draw(EngineState)
        end

        if imgui.BeginMainMenuBar() == 1 then
            if imgui.BeginMenu("File") == 1 then
                imgui.MenuItem("New", "Ctrl+N")
                imgui.MenuItem("Save", "Ctrl+S")
                imgui.MenuItem("Save as", "Shift+Ctrl+N")
                imgui.MenuItem("Quit", "Alt+F4")

                imgui.EndMenu()
            end

            if imgui.BeginMenu("Open") == 1 then

                imgui.Separator()
                if imgui.MenuItem("Debug Stats") == 1 then
                    
                end

                imgui.EndMenu()
            end

            imgui.EndMainMenuBar()
        end
        
        imgui.rImGuiEnd()
    end; rl.EndDrawing()

    renderer.MainSignal:Fire("Heartbeat", delta)
end

return renderer