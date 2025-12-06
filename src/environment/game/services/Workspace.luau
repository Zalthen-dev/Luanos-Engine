local Instance = require("@Instance")
local Vector3 = require("@Vector3")

local Workspace = Instance.new("Workspace")

local allowed_to_render = {
	["Part"] = "Part",
	["MeshPart"] = "MeshPart",
	["BasePart"] = "BasePart",
}

Workspace:SetProperties({
    Gravity = 196.2,
    GlobalWind = Vector3.new(0, 0, 0),

    FallenPartsDestroyHeight = -500,
    FallHeightEnabled = true,
})

local function LoopRegister(renderer, v)
    if v:IsA("Model") then
        local children = v:GetChildren()
        for _, child in children do
            renderer.AddToRenderPool(function()
                return child
            end)
        end

        v.ChildAdded:Connect(function(child)
            renderer.AddToRenderPool(function()
                return child
            end)
        end)
    else
        if allowed_to_render[v.ClassName] then
            renderer.AddToRenderPool(function() return v end)
        end
    end
end

Workspace.InitRenderer = function(renderer)
    Workspace.ChildAdded:Connect(function(child)
        LoopRegister(renderer, child)
    end)
end

return Workspace