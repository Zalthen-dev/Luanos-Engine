local rl = require("@raylib")
local Instance = require("@Instance")
local Signal = require("@signal")
local Enum = require("@Enum")

local LogService = Instance.new("LogService")
LogService._Logs = {}

LogService.MessageOut = Signal.new()

function LogService:ClearOutput()
    table.clear(LogService._Logs)
end

function LogService:GetLogHistory()
    return table.clone(LogService._Logs)
end

function LogService:_AddLog(message, messageType)
    if messageType == Enum.MessageType.MessageOutput or
        messageType == Enum.MessageType.MessageInfo or
        messageType == Enum.MessageType.MessageWarning or
        messageType == Enum.MessageType.MessageError 
    then
        local messageData = {
            message = message,
            messageType = messageType,
            timestamp = rl.GetTime()
        }

        table.insert(LogService._Logs, messageData)
        LogService.MessageOut:Fire(message, messageType)
    end
end

return LogService
