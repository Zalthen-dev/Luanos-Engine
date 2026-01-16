local renderer = require("@renderer")
local Instance = require("@Instance")

local Selection = Instance.new("Selection")
local selected = {}

local function addWireframe(object)
    if object.IsA and object:IsA("Part") then
        if not renderer.Wireframes[object] then
            renderer.Wireframes[object] = true
        end
    end
end

local function removeWireframe(object)
    if object.IsA and object:IsA("Part") then
        if renderer.Wireframes[object] then
            renderer.Wireframes[object] = nil
        end
    end
end

function Selection:Get()
    return table.clone(selected)
end

function Selection:Add(object)
    table.insert(selected, object)
    addWireframe(object)
end

function Selection:Remove(objects)
    for _, object in objects do
        local indice = table.find(selected, object)
        if indice then
            table.remove(selected, indice)
            removeWireframe(object)
        end
    end
end

function Selection:Clear()
    table.clear(selected)
    table.clear(renderer.Wireframes)
end

function Selection:Set(objects)
    Selection:Clear()
    for _, object in objects do
        table.insert(selected, object)
        addWireframe(object)
    end
end

function Selection:_IsSelected(object)
    return table.find(selected, object) ~= nil
end

return Selection