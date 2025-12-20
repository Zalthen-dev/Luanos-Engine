local Instance = require("@Instance")

local Selection = Instance.new("Selection")
local selected = {}

function Selection:Get()
    return table.clone(selected)
end

function Selection:Add(object)
    table.insert(selected, object)
end

function Selection:Remove(objects)
    for _, object in objects do
        local indice = table.find(selected, object)
        if indice then
            table.remove(selected, indice)
        end
    end
end

function Selection:Set(objects)
    selected = {}
    for _, object in objects do
        table.insert(selected, object)
    end
end

function Selection:_IsSelected(object)
    return table.find(selected, object) ~= nil
end

return Selection