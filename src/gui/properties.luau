local imgui = require("@rimgui")
local window = require("@window")
local textEditor = require("@editor")

local node_flags = bit32.bor(
	imgui.IMGUI_TREENODEFLAGS_OPENONDOUBLECLICK,
	imgui.IMGUI_TREENODEFLAGS_OPENONARROW,
	imgui.IMGUI_TREENODEFLAGS_SPANFULLWIDTH
)

local ffi = zune.ffi

-- we reuse pointers for props
local boolPtr = ffi.alloc(1)
local numPtr = ffi.alloc(4)
local vector3Ptr = ffi.alloc(12)
local vector2Ptr = ffi.alloc(8)
local stringEditor = textEditor.new()
local stringEditorSize = imgui.NewImVec2(0, 0) -- i think this only matters if the editor's multiline.

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

		if vType == "function" then	continue end
        if vType == "Signal" then continue end
		if k == "Children" then continue end

		local readOnly = false
		local isService = false
		
		if t.Parent and t.Parent.Name == "game" then
			isService = true
		end

		if k == "Name" and isService then
			readOnly = true
		end

		if k == "ClassName" then
			readOnly = true
		end

		if k == "Source" then
			readOnly = true
		    local str = string.sub(v, 1, 32)
			if #v > 32 then
				str = str .. "..."
			end
			imgui.Text(string.format("Source: %s", str))
			continue
		end
		
		if k == "Parent" then
			v = v.Name
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
        elseif vType == "number" then
            numPtr:writef32(0, v)
            if imgui.InputFloat(k, numPtr, 0, 0, "%.4f", 0) == 1 and not readOnly then
                t[k] = numPtr:readf32(0)
            end
		elseif vType == "Vector2" then
			if imgui.TreeNode(k .. ":", node_flags) == 1 then
				vector2Ptr:writef32(0, v.X)
				vector2Ptr:writef32(4, v.Y)

				if imgui.DragFloat("X##" .. k, vector2Ptr:offset(0), 0.05, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
					t[k].X = vector2Ptr:readf32(0)
				end

				if imgui.DragFloat("Y##" .. k, vector2Ptr:offset(4), 0.05, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
					t[k].Y = vector2Ptr:readf32(4)
				end

				imgui.TreePop()
			else
				imgui.SameLine()

				local text = "%.4f, %.4f"
				imgui.Text(text:format(v.X, v.Y))
			end
		elseif vType == "Vector3" then
			if imgui.TreeNodeEx(k .. ":", node_flags) == 1 then
				vector3Ptr:writef32(0, v.X)
				vector3Ptr:writef32(4, v.Y)
				vector3Ptr:writef32(8, v.Z)
				
				if imgui.DragFloat("X##" .. k, vector3Ptr:offset(0), 0.05, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
					t[k].X = vector3Ptr:readf32(0)
				end

				if imgui.DragFloat("Y##" .. k, vector3Ptr:offset(4), 0.05, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
					t[k].Y = vector3Ptr:readf32(4)
				end

				if imgui.DragFloat("Z##" .. k, vector3Ptr:offset(8), 0.05, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
					t[k].Z = vector3Ptr:readf32(8)
				end
				imgui.TreePop()
			else
				imgui.SameLine()

				local text = "%.4f, %.4f, %.4f"
				imgui.Text(text:format(v.X, v.Y, v.Z))
			end
		elseif vType == "Color3" then
			if imgui.TreeNodeEx(k .. ":", node_flags) == 1 then
				-- we can reuse the vector3 pointer here
				vector3Ptr:writef32(0, v.R)
				vector3Ptr:writef32(4, v.G)
				vector3Ptr:writef32(8, v.B)
				if imgui.DragFloat("R##" .. k, vector3Ptr:offset(0), 0.001, 0.0, 1.0, "%f", 0) == 1 and not readOnly then
					t[k].R = math.clamp(vector3Ptr:readf32(0), 0, 1)
				end

				if imgui.DragFloat("G##" .. k, vector3Ptr:offset(4), 0.001, 0.0, 1.0, "%f", 0) == 1 and not readOnly then
					t[k].G = math.clamp(vector3Ptr:readf32(4), 0, 1)
				end

				if imgui.DragFloat("B##" .. k, vector3Ptr:offset(8), 0.001, 0.0, 1.0, "%f", 0) == 1 and not readOnly then
					t[k].B = math.clamp(vector3Ptr:readf32(8), 0, 1)
				end

				imgui.TreePop()
			else
				imgui.SameLine()

				local text = "%.4f, %.4f, %.4f"
				imgui.Text(text:format(v.R, v.G, v.B))
			end
		elseif vType == "CFrame" then
			if imgui.TreeNodeEx(k, node_flags) == 1 then
				if imgui.TreeNodeEx("Position", node_flags) == 1 then
					vector3Ptr:writef32(0, v.Position.X)
					vector3Ptr:writef32(4, v.Position.Y)
					vector3Ptr:writef32(8, v.Position.Z)
					if imgui.DragFloat("X##" .. k, vector3Ptr:offset(0), 0.1, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
						t[k].Position.X = vector3Ptr:readf32(0)
					end

					if imgui.DragFloat("Y##" .. k, vector3Ptr:offset(4), 0.1, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
						t[k].Position.Y = vector3Ptr:readf32(4)
					end

					if imgui.DragFloat("Z##" .. k, vector3Ptr:offset(8), 0.1, 0.0, 0.0, "%.4f", 0) == 1 and not readOnly then
						t[k].Position.Z = vector3Ptr:readf32(8)
					end

					imgui.TreePop()
				end
				if imgui.TreeNodeEx("Orientation", node_flags) == 1 then
					imgui.Text("RightVector: " .. table.concat(v.Rotation[1], ", "))
					imgui.Text("UpVector: " .. table.concat(v.Rotation[2], ", "))
					imgui.Text("LookVector: " .. table.concat(v.Rotation[3], ", "))
					imgui.TreePop()
				end
				imgui.TreePop()
			end
        elseif vType == "string" then
			-- i do obj[k] here instead of t[k] cause changes dont reflect in the explorer otherwise
			-- (the string in _props differs from the one in the object).
			-- u know more about how instances are supposed to be so ur prob now ;0
			stringEditor:setText(obj[k])
			-- without the unique id, if u edit the property and click on another instance without saving first, it will get applied to that instead.
			stringEditor:draw(k.."##"..tostring(obj), stringEditorSize, readOnly and imgui.IMGUI_INPUTTEXTFLAGS_READONLY or 0)
			if not readOnly and imgui.IsItemDeactivatedAfterEdit() == 1 then
				obj[k] = stringEditor:getText()
			end
		else
            -- TODO: add more editable properties
		    imgui.Text(("%s: %s"):format(k, tostring(v)))
		end
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

self.title = "Properties"
return self
