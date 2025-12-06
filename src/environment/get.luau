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

    return data
end