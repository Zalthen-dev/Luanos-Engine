local rl = require("@raylib")
local rgizmo = require("@raygizmo")
local rayutils = require("@rayutils")
local Vector3 = require("@Vector3")

local ffi = zune.ffi
local EulerDegToQuaternion = rayutils.EulerDegToQuaternion
local QuaternionToEulerDeg = rayutils.QuaternionToEulerDeg

local LocalSpace = false
local Move = false
local Rotate = false
local Scale = false

local self = {
    _Dragging = false,
}
local PreviousScale = {x=0,y=0,z=0}
local gizmoTransform = ffi.alloc(12+16+12) -- Vector3,Vector4,Vector3

-- Read Offsets:
-- 0, 4, 8 = Position (x,y,z) (Vector3)
-- 12, 16, 20, 24 = Rotation (x,y,z,w) (Quaternion)
-- 28, 32, 36 = Scale (x,y,z) (Vector3)

function self:Draw()
    local renderer = self.renderer()
    local camera = renderer.Camera
    local engineState = renderer.EngineState
    local selection = engineState.game:GetService("Selection"):Get()

    -- make the mouse match the viewport pos/size
    rl.SetMouseOffset(-renderer.ViewportPosition.X, -renderer.ViewportPosition.Y)
    rl.SetMouseScale(rl.GetScreenWidth() / renderer.ViewportSize.X, rl.GetScreenHeight() / renderer.ViewportSize.Y)

    if #selection == 1 then
        local obj = selection[1]
        if obj:IsA("Part") then
            if obj.Position then
                rl.BeginTextureMode(renderer.ViewTexture)
                rl.BeginMode3D(camera)

                local objPos = obj.Position
                local objSize = obj.Size
                local flags = 0
                
                -- Write flags --
                -----------------
                if Move and not Scale then
                    flags = bit32.bor(flags, rgizmo.GIZMO_TRANSLATE)
                end
                -----------------
                if Rotate and not Scale then
                    flags = bit32.bor(flags, rgizmo.GIZMO_ROTATE)
                end
                -----------------
                if Scale then
                    gizmoTransform:writef32(0, objPos.X)
                    gizmoTransform:writef32(4, objPos.Y)
                    gizmoTransform:writef32(8, objPos.Z)
                    if rgizmo.DrawGizmo3D(rgizmo.GIZMO_SCALE, gizmoTransform) == 1 then
                        if not self._Dragging then
                            PreviousScale.x = objSize.X
                            PreviousScale.y = objSize.Y
                            PreviousScale.z = objSize.Z
                        end
                        self._Dragging = true
                        local deltaX = gizmoTransform:readf32(0) - objPos.X
                        local deltaY = gizmoTransform:readf32(4) - objPos.Y
                        local deltaZ = gizmoTransform:readf32(8) - objPos.Z

                        objSize.X = math.max(PreviousScale.x + deltaX,0.01)
                        objSize.Y = math.max(PreviousScale.y + deltaY,0.01)
                        objSize.Z = math.max(PreviousScale.z + deltaZ,0.01)
                    else
                        self._Dragging = false
                    end
                else
                    if flags ~= 0 then
                        -- Switch between Local/Global space (only affects Translate (Move) afaik).
                        if LocalSpace then
                            flags = bit32.bor(flags, rgizmo.GIZMO_LOCAL)
                        end
                        -- Write Position
                        gizmoTransform:writef32(0, objPos.X)
                        gizmoTransform:writef32(4, objPos.Y)
                        gizmoTransform:writef32(8, objPos.Z)

                        local qx,qy,qz,qw = EulerDegToQuaternion(obj.Rotation)
                        -- Write Rotation (not implemented)
                        gizmoTransform:writef32(12, qx)
                        gizmoTransform:writef32(16, qy)
                        gizmoTransform:writef32(20, qz)
                        gizmoTransform:writef32(24, qw)

                        rgizmo.DrawGizmo3D(flags, gizmoTransform)

                        -- Read Position into obj
                        objPos.X = gizmoTransform:readf32(0)
                        objPos.Y = gizmoTransform:readf32(4)
                        objPos.Z = gizmoTransform:readf32(8)

                        -- Read Rotation into obj

                        local rx,ry,rz = QuaternionToEulerDeg(
                            gizmoTransform:readf32(12),
                            gizmoTransform:readf32(16),
                            gizmoTransform:readf32(20),
                            gizmoTransform:readf32(24)
                        )
                        obj.Rotation = Vector3.new(rx, ry, rz)
                    end
                end
                rl.EndMode3D()
                rl.EndTextureMode()
            end
        end
    end

    rl.SetMouseOffset(0,0)
    rl.SetMouseScale(1,1)
end

-- Gizmo Set/Get functions:
function self:SetTool(Tool: "Select" | "Move" | "Rotate" | "Scale")
    if Tool == "Select" then
        Move = false
        Rotate = false
        Scale = false
    elseif Tool == "Move" then
        Move = true
        Rotate = false
        Scale = false
    elseif Tool == "Rotate" then
        Move = false
        Rotate = true
        Scale = false
    elseif Tool == "Scale" then
        Move = false
        Rotate = false
        Scale = true
    end
end

-- Returns "Select" | "Move" | "Rotate" | "Scale"
function self:GetTool(): "Select" | "Move" | "Rotate" | "Scale"
    if Move then return "Move"
    elseif Rotate then return "Rotate"
    elseif Scale then return "Scale" 
    else return "Select" end
end

-- 
function self:SetSpace(Space: "Global" | "Local")
    if Space == "Global" then
        LocalSpace = false
    elseif Space == "Local" then
        LocalSpace = true
    end
end

function self:GetSpace(): "Global" | "Local"
    if LocalSpace then
        return "Local"
    else 
        return "Global"
    end
end

return self