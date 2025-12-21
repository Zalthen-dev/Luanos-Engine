local Signal = require("@signal")
local rl = require("@raylib")
local imgui = require("@rimgui")
local utils = require("@utils")

local gui = require("./renderer/gui")

local Skybox = require("./renderer/skybox")
local Mesh = require("./renderer/mesh")

local ffi = zune.ffi
local task = zune.task
local mem = zune.mem

local renderer = {}

renderer.CAMERA_SPEED = 5
renderer.CAMERA_PANSPEED = 1
renderer.CAMERA_SHIFTSPEED = 0.2
renderer.CAMERA_SCROLLSPEED = 15
renderer.CAMERA_SCROLLTOWARDCURSOR = true

renderer.MOUSE_SENSITIVITY = 0.008

local worldUp = vector.create(0, 1, 0)

renderer.EngineState = nil

renderer.MainSignal = Signal.new()
renderer.RenderPool3D = {}
renderer.RenderPool2D = {}

renderer.ViewportActive = true
renderer.Visible = true
renderer.ViewTexture = nil

renderer.ActuallyDrawn3D = 0

local function DrawTextOutlined(
	text: string,
	posX: number,
	posY: number,
	fontSize: number,
	color: rl.Color,
	outlineSize: number,
	outlineColor: rl.Color
)
	rl.DrawText(text, posX - outlineSize, posY - outlineSize, fontSize, outlineColor)
	rl.DrawText(text, posX, posY - outlineSize, fontSize, outlineColor)
	rl.DrawText(text, posX + outlineSize, posY - outlineSize, fontSize, outlineColor)

	rl.DrawText(text, posX - outlineSize, posY, fontSize, outlineColor)
	rl.DrawText(text, posX + outlineSize, posY, fontSize, outlineColor)

	rl.DrawText(text, posX - outlineSize, posY + outlineSize, fontSize, outlineColor)
	rl.DrawText(text, posX, posY + outlineSize, fontSize, outlineColor)
	rl.DrawText(text, posX + outlineSize, posY + outlineSize, fontSize, outlineColor)

	rl.DrawText(text, posX, posY, fontSize, color)
end

local function ShouldDrawPart(part, camera, cam_pos, cam_target, cam_fovy)
	local cx, cy, cz = part.Position.X, part.Position.Y, part.Position.Z
	local pos = vector.create(cx, cy, cz)

	local sx, sy, sz = part.Size.X, part.Size.Y, part.Size.Z
	local radius = vector.magnitude(vector.create(sx, sy, sz)) * 0.5

	local toPart = pos - cam_pos
	local dist = vector.magnitude(toPart)

	if dist > radius * 1000 then
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

	if screen.x >= -radius and screen.x <= w + radius and screen.y >= -radius and screen.y <= h + radius then
		return true
	end

	local projected_size = radius / dist * (h / math.tan(math.rad(cam_fovy * 0.5)))

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
	if not renderer.ViewportActive then
		return
	end

	local mouseDelta = rl.GetMouseDelta()
	local mouseWheelDelta = rl.GetMouseWheelMove()
	local moveSpeed = renderer.CAMERA_SPEED * 5 * delta

	if rl.IsKeyDown(rl.KEY_LEFT_SHIFT) == 1 then
		moveSpeed *= renderer.CAMERA_SHIFTSPEED
	end

	if mouseWheelDelta ~= 0 then
		local mousePos = rl.GetMousePosition()
		if not renderer.CAMERA_SCROLLTOWARDCURSOR then
			mousePos = vector.create(rl.GetScreenWidth() / 2, rl.GetScreenHeight() / 2)
		end

		local screenRay = rl.GetScreenToWorldRay(mousePos, camera)
		camera_position += (mem.toVector3(screenRay, 12) * mouseWheelDelta) * (renderer.CAMERA_SCROLLSPEED / 15)
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
			local limit = (math.pi / 2) - 0.01

            local mouseSensitivity = (renderer.MOUSE_SENSITIVITY * renderer.CAMERA_PANSPEED)

			camera_yaw += mouseDelta.x * mouseSensitivity
			camera_pitch = math.clamp(camera_pitch - mouseDelta.y * mouseSensitivity, -limit, limit)
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
		local inputUpward = math.max(rl.IsKeyDown(rl.KEY_SPACE), rl.IsKeyDown(rl.KEY_E)) - rl.IsKeyDown(rl.KEY_Q)

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

	rl.DrawModelEx(model, position, axis, angle, scale, tint)
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

function renderer.Render3DScene()
	renderer.UpdateFreecam(camera, rl.GetFrameTime())
	renderer.ActuallyDrawn3D = 0
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
				renderer.ActuallyDrawn3D += 1
			end
		end
	end; rl.EndMode3D()

	DrawTextOutlined(tostring(rl.GetFPS()) .. " FPS", 10, 10, 20, rl.GREEN, 2, rl.BLACK)
	DrawTextOutlined(tostring(task.count()) .. " tasks", 10, 30, 20, rl.WHITE, 2, rl.BLACK)
	DrawTextOutlined(tostring(#renderer.RenderPool3D) .. " render pool 3D", 10, 50, 20, rl.WHITE, 2, rl.BLACK)
	DrawTextOutlined(tostring(#renderer.RenderPool2D) .. " render pool 2D", 10, 70, 20, rl.WHITE, 2, rl.BLACK)
	DrawTextOutlined(tostring(renderer.ActuallyDrawn3D) .. " drawn parts", 10, 90, 20, rl.WHITE, 2, rl.BLACK)
end

function renderer.Render3DSceneToTexture(w: number, h: number)
	if not renderer.Visible then return end
	w = math.floor(w)
	h = math.floor(h)

	local currentWidth = buffer.readi32(renderer.ViewTexture, 8)
	local currentHeight = buffer.readi32(renderer.ViewTexture, 12)
	if (w ~= currentWidth or h ~= currentHeight) or not renderer.ViewTexture then
		if renderer.ViewTexture then
			rl.UnloadRenderTexture(renderer.ViewTexture)
		end
		renderer.ViewTexture = rl.LoadRenderTexture(w, h)
	end

	do rl.BeginTextureMode(renderer.ViewTexture)
		rl.ClearBackground(rl.BLACK)
		renderer.Render3DScene()
    end; rl.EndTextureMode()
end

function renderer.OnStart(engineState)
	renderer.EngineState = engineState

	print("Creating ViewTexture")
	renderer.ViewTexture = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
	renderer.Visible = true

	gui.renderer = function()
		return renderer
	end

	imgui.rImGuiSetup()
	imgui.rImGuiEnableDocking()
	imgui.rImGuiDisableIO()
	Mesh.Load()
	Skybox.Load()
end

function renderer.OnEnd()
	if renderer.ViewTexture ~= nil then
		print("Unloading ViewTexture")
		rl.UnloadRenderTexture(renderer.ViewTexture)
	end

	print("Unloading ImGui")
	imgui.rImGuiDisableDocking()
	imgui.rImGuiShutdown()
	Mesh.Unload()
	Skybox.Unload()
end

function renderer.RenderScene()
	local time = rl.GetTime()
	local delta = rl.GetFrameTime()

	renderer.MainSignal:Fire("PreRender", delta)
	do
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		imgui.rImGuiBegin()
		renderer.Render3DScene()
		gui.Draw()

		imgui.rImGuiEnd()
    end; rl.EndDrawing()

	renderer.MainSignal:Fire("Heartbeat", delta)
end

return renderer
