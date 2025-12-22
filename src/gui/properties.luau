local imgui = require("@rimgui")
local window = require("@window")

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
        local readOnly = false

        if vType == "table" and v.__type then
            vType = v.__type
        end
        
        if vType == "function" then
            continue
        end

        if k == "Children" then
            continue
        end

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