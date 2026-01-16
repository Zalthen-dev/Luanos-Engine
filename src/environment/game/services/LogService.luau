local rl = require("@raylib")
local Instance = require("@Instance")
local Signal = require("@signal")
local Enum = require("@Enum")

local LogService = Instance.new("LogService")

local MaxLogs = 100000
LogService._Logs = {}

local function NewColor4(r,g,b,a)
    local color = buffer.create(16)
    buffer.writef32(color, 0, r)
    buffer.writef32(color, 4, g)
    buffer.writef32(color, 8, b)
    buffer.writef32(color, 12, a)
    return color
end

LogService._Colors = {
    [Enum.MessageType.MessageOutput] = NewColor4(0.9, 0.9, 0.9, 1.0),
    [Enum.MessageType.MessageInfo]  = NewColor4(0.5, 0.84, 1.0, 1.0),
    [Enum.MessageType.MessageWarning] = NewColor4(1.0, 0.55, 0.23, 1.0),
    [Enum.MessageType.MessageError] = NewColor4(1.0, 0.26, 0.26, 1.0)
}

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
        if #LogService._Logs > MaxLogs then
            table.remove(LogService._Logs,1)
        end
        local messageData = {
            message = message,
            color = LogService._Colors[messageType] or LogService._Colors[0],
            messageType = messageType,
            timestamp = rl.GetTime()
        }

        table.insert(LogService._Logs, messageData)
        LogService.MessageOut:Fire(message, messageType)
    end
end

return LogService