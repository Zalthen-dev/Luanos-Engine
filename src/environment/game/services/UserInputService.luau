local Vector2 = require("../../datatypes/Vector2")
local Enum = require("../../datatypes/Enum")
local Instance = require("@Instance")
local Signal = require("@signal")
local rl = require("@raylib")

local UserInputService = Instance.new("UserInputService")

UserInputService.GamepadConnected = Signal.new()
UserInputService.GamepadDisconnected = Signal.new()
UserInputService.InputBegan = Signal.new()
UserInputService.InputChanged = Signal.new()
UserInputService.InputEnded = Signal.new()
UserInputService.LastInputType = Enum.UserInputType.Unknown

local activeKeys = {} 
local Gamepads = {} 
local activeMouseButtons = {}

export type InputObject = {
    UserInputType: number,
    KeyCode: number?,
    UserInputState: Vector2?,
}

local INPUT_TYPE_LOOKUP:{[Enum.UserInputType]:string} = {}
local KEYCODE_LOOKUP:{[Enum.KeyCode]:string} = {}

local GAMEPAD_MAP = {
    [0] = Enum.KeyCode.Unknown,
    [1] = Enum.KeyCode.DPadUp,
    [2] = Enum.KeyCode.DPadRight,
    [3] = Enum.KeyCode.DPadDown,
    [4] = Enum.KeyCode.DPadLeft,
    [5] = Enum.KeyCode.ButtonY,
    [6] = Enum.KeyCode.ButtonB,
    [7] = Enum.KeyCode.ButtonA,
    [8] = Enum.KeyCode.ButtonX,
    [9] = Enum.KeyCode.ButtonL1,
    [10] = Enum.KeyCode.ButtonL2,
    [11] = Enum.KeyCode.ButtonR1,
    [12] = Enum.KeyCode.ButtonR2,
    [13] = Enum.KeyCode.ButtonSelect,
    [14] = Enum.KeyCode.Mode,
    [15] = Enum.KeyCode.ButtonStart,
    [16] = Enum.KeyCode.ButtonL3,
    [17] = Enum.KeyCode.ButtonR3,
}

local MOUSE_BUTTONS = {
    Enum.KeyCode.MouseLeftButton,
    Enum.KeyCode.MouseRightButton,
    Enum.KeyCode.MouseMiddleButton,
}

for i,keyCode in pairs(Enum.KeyCode) do
    KEYCODE_LOOKUP[keyCode] = i
end
for i,inputType in pairs(Enum.UserInputType) do
    INPUT_TYPE_LOOKUP[inputType] = i
end

local function createInputObject(inputType, keyCode, state):{UserInputType: number, KeyCode: number?, UserInputState: Vector2?}
    return {
        UserInputType = inputType,
        UserInputState = state,
        KeyCode = keyCode,
    }
end

function UserInputService.GetConnectedGamepads():{Enum.UserInputType}
    local connectedEnums = {}
    for id = 0, 3 do
        if rl.IsGamepadAvailable(id) == 1 then
            table.insert(connectedEnums, Enum.UserInputType["Gamepad"..tostring(id+1)])
        end
    end
    return connectedEnums
end

function UserInputService.GetStringForInputType(InputType: Enum.UserInputType): string
    if INPUT_TYPE_LOOKUP[InputType] then
        return INPUT_TYPE_LOOKUP[InputType]
    else
        return "Unknown"
    end
end

function UserInputService.GetStringForKeyCode(KeyCode: Enum.KeyCode): string
    if KEYCODE_LOOKUP[KeyCode] then
        return KEYCODE_LOOKUP[KeyCode]
    else
        return "Unknown"
    end
end

function UserInputService.Step()
    -- handle key presses
    while true do
        local key = rl.GetKeyPressed()
        if key == 0 then break end
        local inputObj = createInputObject(Enum.UserInputType.Keyboard, key)
        activeKeys[key] = inputObj 
        UserInputService.InputBegan:Fire(inputObj, false)
        UserInputService.LastInputType = Enum.UserInputType.Keyboard
    end
    -- handle gamepad input
    for id = 0, 3 do
        if rl.IsGamepadAvailable(id) == 1 then
            if Gamepads[id] == nil then
                UserInputService.GamepadConnected:Fire(id+1)
                Gamepads[id] = {}
                Gamepads[id].Enum = Enum.UserInputType["Gamepad"..tostring(id+1)]
                Gamepads[id].Buttons = {}
                Gamepads[id].Axis = { 
                    [rl.GAMEPAD_AXIS_LEFT_TRIGGER] = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_LEFT_TRIGGER),
                    [rl.GAMEPAD_AXIS_RIGHT_TRIGGER] = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_RIGHT_TRIGGER),
                    [rl.GAMEPAD_AXIS_LEFT_X] = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_LEFT_X),
                    [rl.GAMEPAD_AXIS_LEFT_Y] = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_LEFT_Y),
                    [rl.GAMEPAD_AXIS_RIGHT_X] = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_RIGHT_X),
                    [rl.GAMEPAD_AXIS_RIGHT_Y] = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_RIGHT_Y),
                }
            end
            local gamepadEnum = Gamepads[id].Enum
            -- buttons
            for buttonId = 0, 17 do
                local enumKeyCode = GAMEPAD_MAP[buttonId] or Enum.KeyCode.Unknown
                if rl.IsGamepadButtonPressed(id, buttonId) == 1 and not Gamepads[id].Buttons[buttonId] then
                    local inputObj = createInputObject(gamepadEnum, enumKeyCode)
                    Gamepads[id].Buttons[buttonId] = inputObj
                    UserInputService.InputBegan:Fire(inputObj, false)
                    UserInputService.LastInputType = gamepadEnum
                elseif rl.IsGamepadButtonReleased(id, buttonId) == 1 and Gamepads[id].Buttons[buttonId] then
                    local inputObj = Gamepads[id].Buttons[buttonId]
                    if inputObj then
                        UserInputService.InputEnded:Fire(inputObj, false)
                        Gamepads[id].Buttons[buttonId] = nil
                    end
                end
            end
            -- l2/r2 triggers and thumbsticks
            local L2axisInput = (rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_LEFT_TRIGGER)+1)/2
            if L2axisInput ~= Gamepads[id].Axis[rl.GAMEPAD_AXIS_LEFT_TRIGGER] then
                local inputObj = createInputObject(gamepadEnum, Enum.KeyCode.ButtonL2, Vector2.new(0, L2axisInput))
                UserInputService.InputChanged:Fire(inputObj, false)
                Gamepads[id].Axis[rl.GAMEPAD_AXIS_LEFT_TRIGGER] = L2axisInput
            end
            local R2axisInput = (rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_RIGHT_TRIGGER)+1)/2
            if R2axisInput ~= Gamepads[id].Axis[rl.GAMEPAD_AXIS_RIGHT_TRIGGER] then
                local inputObj = createInputObject(gamepadEnum, Enum.KeyCode.ButtonR2, Vector2.new(0, R2axisInput))
                UserInputService.InputChanged:Fire(inputObj, false)
                Gamepads[id].Axis[rl.GAMEPAD_AXIS_RIGHT_TRIGGER] = R2axisInput
            end
            local LStickX,LStickY = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_LEFT_X),rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_LEFT_Y)
            if LStickX ~= Gamepads[id].Axis[rl.GAMEPAD_AXIS_LEFT_X] or LStickY ~= Gamepads[id].Axis[rl.GAMEPAD_AXIS_LEFT_Y] then
                local inputObj = createInputObject(gamepadEnum, nil, Vector2.new(LStickX, LStickY))
                UserInputService.InputChanged:Fire(inputObj, false)
                Gamepads[id].Axis[rl.GAMEPAD_AXIS_LEFT_X] = LStickX
                Gamepads[id].Axis[rl.GAMEPAD_AXIS_LEFT_Y] = LStickY
            end
            local RStickX,RStickY = rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_RIGHT_X),rl.GetGamepadAxisMovement(id, rl.GAMEPAD_AXIS_RIGHT_Y)
            if RStickX ~= Gamepads[id].Axis[rl.GAMEPAD_AXIS_RIGHT_X] or RStickY ~= Gamepads[id].Axis[rl.GAMEPAD_AXIS_RIGHT_Y] then
                local inputObj = createInputObject(gamepadEnum, nil, Vector2.new(RStickX, RStickY))
                UserInputService.InputChanged:Fire(inputObj, false)
                Gamepads[id].Axis[rl.GAMEPAD_AXIS_RIGHT_X] = RStickX
                Gamepads[id].Axis[rl.GAMEPAD_AXIS_RIGHT_Y] = RStickY
            end
        else
            if Gamepads[id] then
                UserInputService.GamepadDisconnected:Fire(id+1)
                Gamepads[id] = nil
            end
        end
    end
    -- handle mouse movement
    local mouseDelta = rl.GetMouseDelta()
    if mouseDelta.x ~= 0 or mouseDelta.y ~= 0 then
        local inputObj = createInputObject(Enum.UserInputType.MouseMovement, nil, Vector2.new(mouseDelta.x, mouseDelta.y))
        UserInputService.InputChanged:Fire(inputObj, false)
        UserInputService.LastInputType = Enum.UserInputType.MouseMovement
    end
    -- handle key releases
    for key, inputObj in pairs(activeKeys) do
        if rl.IsKeyReleased(key) == 1 then
            UserInputService.InputEnded:Fire(inputObj, false)
            activeKeys[key] = nil
        end
    end
    -- handle mouse button presses/releases
    for _, btn in ipairs(MOUSE_BUTTONS) do
        
        if rl.IsMouseButtonPressed(btn) == 1 and not activeMouseButtons[btn] then
            local inputType = Enum.UserInputType.Unknown
            if btn == Enum.KeyCode.MouseLeftButton then 
                inputType = Enum.UserInputType.MouseButton1
            elseif btn == Enum.KeyCode.MouseRightButton then 
                inputType = Enum.UserInputType.MouseButton2
            elseif btn == Enum.KeyCode.MouseMiddleButton then 
                inputType = Enum.UserInputType.MouseButton3
            end
            local inputObj = createInputObject(inputType, btn)
            activeMouseButtons[btn] = inputObj
            UserInputService.InputBegan:Fire(inputObj, false)
            UserInputService.LastInputType = inputType
        elseif rl.IsMouseButtonReleased(btn) == 1 then
            local inputObj = activeMouseButtons[btn]
            if inputObj then
                UserInputService.InputEnded:Fire(inputObj, false)
                activeMouseButtons[btn] = nil
            end
        end
    end
    local mouseWheelDelta = rl.GetMouseWheelMove()
    if mouseWheelDelta ~= 0 then
        local inputObj = createInputObject(Enum.UserInputType.MouseWheel, nil, Vector2.new(0, mouseWheelDelta))
        UserInputService.InputChanged:Fire(inputObj, false)
        UserInputService.LastInputType = Enum.UserInputType.MouseWheel
    end
end

return UserInputService
