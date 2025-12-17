local imgui = require("@rimgui")
local window = require("@window")
local Enum = require("@Enum")
local rl = require("@raylib")

local self
self = window.Create("Output", function(engineState)
    --[[
    if not self.newMessageEnv then
        engineState.game:GetService("LogService").MessageOut:Connect(function(message, messageType)
            table.insert(self.logs, {
                text = message,
                logType = messageType
            })
        end)
    end
    ]]

    imgui.Separator()

    local availSize = imgui.FromImVec2(imgui.GetContentRegionAvail())
    if imgui.BeginChild("OutputScrolling", imgui.NewImVec2(availSize.x, availSize.y), false, 0) then
        --[[
        if imgui.BeginPopupContextWindow() == 1 then

            if imgui.Selectable("Clear") == 1 then
                table.clear(self.logs)
            end

            imgui.EndPopup()
        end
        ]]

        local logList = engineState.game:GetService("LogService"):GetLogHistory()
        local count = #logList
        for i, log in logList do
            if i >= (count - 5000) then
                imgui.TextUnformatted(log.message)
            end
        end
    end; imgui.EndChild()    
end)

self.defaultSize = imgui.NewImVec2(520, 600)
--self.logs = {}
return self