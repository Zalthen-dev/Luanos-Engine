local imgui = require("@rimgui")
local window = require("@window")

local node_flags = bit32.bor(imgui.TREE_NODE_FLAGS.OPENONDOUBLECLICK, imgui.TREE_NODE_FLAGS.OPENONARROW, imgui.TREE_NODE_FLAGS.SPANFULLWIDTH)
local ffi = zune.ffi

-- we reuse pointers for props
local boolPtr = ffi.alloc(1)
local vector3Ptr = ffi.alloc(12)


local function TextCenter(text)
	local availRegion = imgui.FromImVec2(imgui.GetWindowSize())
	local textSize = imgui.FromImVec2(imgui.CalcTextSize(text))

	imgui.SetCursorPosX((availRegion.x - textSize.x) / 2)
	imgui.SetCursorPosY((availRegion.y - textSize.y) / 2)

	imgui.Text(text)
end

local function PropertiesObject(obj)
    local t = obj._props
    if not t then
        t = obj
    end

    for k, v in pairs(t) do
        local vType = typeof(v)
        
        if vType == "table" and v.__type then
            vType = v.__type
        end
        
        if vType == "function" then
            continue
        end

        if k == "Children" then
            continue
        end
        
        local readOnly = false

        if k == "ClassName" then
            readOnly = true
        end

        if k == "Parent" then
            v = v.Name
        end

        -- hide signals
        if vType == "Signal" then
            continue
        end

        -- hide internal properties
        if string.sub(k, 1, 1) == "_" then
            continue
        end

        if vType == "boolean" then
            boolPtr:writeu8(0, v and 1 or 0)
            if imgui.Checkbox(k, boolPtr) == 1 and not readOnly then
                t[k] = (boolPtr:readu8(0) ~= 0)
            end
            continue
        end

        if vType == "Vector3" then
            if imgui.TreeNodeEx(k..":",node_flags) == 1 then
                vector3Ptr:writef32(0, v.X)
                vector3Ptr:writef32(4, v.Y)
                vector3Ptr:writef32(8, v.Z)
                if imgui.DragFloat("X##"..k, vector3Ptr:offset(0), 0.05,0.0,0.0, "%.4f", 0) == 1 and not readOnly then
                    t[k].X = vector3Ptr:readf32(0)
                end
                if imgui.DragFloat("Y##"..k, vector3Ptr:offset(4), 0.05,0.0,0.0, "%.4f", 0) == 1 and not readOnly then
                    t[k].Y = vector3Ptr:readf32(4)
                end
                if imgui.DragFloat("Z##"..k, vector3Ptr:offset(8), 0.05,0.0,0.0, "%.4f", 0) == 1 and not readOnly then
                    t[k].Z = vector3Ptr:readf32(8)
                end
                imgui.TreePop()
            end
            continue
        end

        if vType == "Color3" then
            if imgui.TreeNodeEx(k..":",node_flags) == 1 then
                -- we can reuse the vector3 pointer here
                vector3Ptr:writef32(0, v.R)
                vector3Ptr:writef32(4, v.G)
                vector3Ptr:writef32(8, v.B)
                if imgui.DragFloat("R##"..k, vector3Ptr:offset(0), 0.001,0.0,1.0, "%f", 0) == 1 and not readOnly then
                    t[k].R = math.clamp(vector3Ptr:readf32(0),0,1)
                end
                if imgui.DragFloat("G##"..k, vector3Ptr:offset(4), 0.001,0.0,1.0, "%f", 0) == 1 and not readOnly then
                    t[k].G = math.clamp(vector3Ptr:readf32(4),0,1)
                end
                if imgui.DragFloat("B##"..k, vector3Ptr:offset(8), 0.001,0.0,1.0, "%f", 0) == 1 and not readOnly then
                    t[k].B = math.clamp(vector3Ptr:readf32(8),0,1)
                end
                imgui.TreePop()
            end
            continue
        end

        if vType == "CFrame" then
            if imgui.TreeNodeEx(k,node_flags) == 1 then
                if imgui.TreeNodeEx("Position",node_flags) == 1 then
                    vector3Ptr:writef32(0, v.Position.X)
                    vector3Ptr:writef32(4, v.Position.Y)
                    vector3Ptr:writef32(8, v.Position.Z)
                    if imgui.DragFloat("X##"..k, vector3Ptr:offset(0), 0.1,0.0,0.0, "%.4f", 0) == 1 and not readOnly then
                        t[k].Position.X = vector3Ptr:readf32(0)
                    end
                    if imgui.DragFloat("Y##"..k, vector3Ptr:offset(4), 0.1,0.0,0.0, "%.4f", 0) == 1 and not readOnly then
                        t[k].Position.Y = vector3Ptr:readf32(4)
                    end
                    if imgui.DragFloat("Z##"..k, vector3Ptr:offset(8), 0.1,0.0,0.0, "%.4f", 0) == 1 and not readOnly then
                        t[k].Position.Z = vector3Ptr:readf32(8)
                    end
                    imgui.TreePop()
                end
                if imgui.TreeNodeEx("Orientation",node_flags) == 1 then
                    imgui.Text("RightVector: "..table.concat(v.Rotation[1], ", "))
                    imgui.Text("UpVector: "..table.concat(v.Rotation[2], ", "))
                    imgui.Text("LookVector: "..table.concat(v.Rotation[3], ", "))
                    imgui.TreePop()
                end
                imgui.TreePop()
            end
            continue
        end
        -- TODO: add more editable properties

        imgui.Text(("%s: %s"):format(k, tostring(v)))
    end
end

local self = {}
self = window.Create(function()
    local engineState = self.renderer().EngineState
	local game = engineState.game

	local Selection = game:GetService("Selection")

    if imgui.Begin("Properties", self.visible) == 1 then
        local selectedObjects = Selection:Get()

        if #selectedObjects > 0 then
            if #selectedObjects == 1 then
                PropertiesObject(selectedObjects[1])
            else
                imgui.Text(("%i objects selected"):format(#selectedObjects))

                for _, obj in selectedObjects do
                    imgui.Separator()
                    PropertiesObject(obj)
                end
            end
        else
            TextCenter("No objects selected")
        end
		
	end
	imgui.End()
end)

return self