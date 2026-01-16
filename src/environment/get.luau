local Registry = require("@registry")
local Datatypes = require("./datatypes/test")
local DataModel = require("@DataModel")

return function()
    local mainDataModel = DataModel.new()
    local data = Datatypes

    data.Instance = {
        new = function(class)
            return Registry.new(class)
        end
    }

    data.task = zune.task
    data.game = mainDataModel
    data.workspace = mainDataModel:GetService("Workspace")
    data.typeof = function(value)
        local Type = type(value)
        if Type == "table" then
            if value.__type then
                return value.__type
            else
                return Type
            end
        else
            return Type
        end
    end
    data.settings = {
        CameraSpeed = 25,
        MouseSensitivity = 1,
    }

    return data
end