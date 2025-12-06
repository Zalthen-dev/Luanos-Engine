local Instance = require("@Instance")
local Renderer = require("@renderer")

local fs = zune.fs

local DataModel = {}
DataModel.__index = DataModel
DataModel.__type = "DataModel"

function DataModel.new()
    local self = setmetatable({}, DataModel)
    self.Root = Instance.new("DataModel")
    self.Root.Name = "game"

    self.Services = {}
    for _, service in fs.entries("./src/environment/game/services") do
        local name = service.name:gsub(".luau", "")

        local returnedData = require("./game/services/" .. name)
        if returnedData then
            self.Services[name] = returnedData

            if returnedData.InitRenderer then
                returnedData.InitRenderer(Renderer)
            end
        end
    end
    
    for name, service in pairs(self.Services) do
        service.Name = name
        service.Parent = self.Root
    end
    
    function self:GetService(name)
        return self.Services[name]
    end

    function self:FindService(name)
        return self.Services[name]
    end

    return self
end

return DataModel