local Enum = require("@Enum")

local RayKey = {}
RayKey.KeyCode = {
    [Enum.KeyCode.Unknown] = 0,
    -- Special Keys
    [Enum.KeyCode.Space] = 32,
    [Enum.KeyCode.Escape] = 256,
    [Enum.KeyCode.Return] = 257,
    [Enum.KeyCode.Tab] = 258,
    [Enum.KeyCode.Backspace] = 259,
    [Enum.KeyCode.Insert] = 260,
    [Enum.KeyCode.Delete] = 261,
    [Enum.KeyCode.Right] = 262,
    [Enum.KeyCode.Left] = 263,
    [Enum.KeyCode.Down] = 264,
    [Enum.KeyCode.Up] = 265,
    [Enum.KeyCode.PageUp] = 266,
    [Enum.KeyCode.PageDown] = 267,
    [Enum.KeyCode.Home] = 268,
    [Enum.KeyCode.End] = 269,
    [Enum.KeyCode.CapsLock] = 280,
    [Enum.KeyCode.ScrollLock] = 281,
    [Enum.KeyCode.NumLock] = 282,
    [Enum.KeyCode.Print] = 283,
    [Enum.KeyCode.Pause] = 284,

    -- Function Keys
    [Enum.KeyCode.F1] = 290,
    [Enum.KeyCode.F2] = 291,
    [Enum.KeyCode.F3] = 292,
    [Enum.KeyCode.F4] = 293,
    [Enum.KeyCode.F5] = 294,
    [Enum.KeyCode.F6] = 295,
    [Enum.KeyCode.F7] = 296,
    [Enum.KeyCode.F8] = 297,
    [Enum.KeyCode.F9] = 298,
    [Enum.KeyCode.F10] = 299,
    [Enum.KeyCode.F11] = 300,
    [Enum.KeyCode.F12] = 301,

    -- Modifier Keys
    [Enum.KeyCode.LeftShift] = 340,
    [Enum.KeyCode.LeftControl] = 341,
    [Enum.KeyCode.LeftAlt] = 342,
    [Enum.KeyCode.LeftSuper] = 343, -- (Meta/Windows)
    [Enum.KeyCode.RightShift] = 344,
    [Enum.KeyCode.RightControl] = 345,
    [Enum.KeyCode.RightAlt] = 346,
    [Enum.KeyCode.RightSuper] = 347, -- (Meta/Windows)
    [Enum.KeyCode.Menu] = 348,

    -- Symbols (Physical Keys)
    [Enum.KeyCode.Quote] = 39,      -- '
    [Enum.KeyCode.Comma] = 44,      -- ,
    [Enum.KeyCode.Minus] = 45,      -- -
    [Enum.KeyCode.Period] = 46,     -- .
    [Enum.KeyCode.Slash] = 47,      -- /
    [Enum.KeyCode.Semicolon] = 59,  -- ;
    [Enum.KeyCode.Equals] = 61,     -- =
    [Enum.KeyCode.LeftBracket] = 91,  -- [
    [Enum.KeyCode.BackSlash] = 92,    -- \
    [Enum.KeyCode.RightBracket] = 93, -- ]
    [Enum.KeyCode.Backquote] = 96,    -- `

    -- Numbers
    [Enum.KeyCode.Zero] = 48,
    [Enum.KeyCode.One] = 49,
    [Enum.KeyCode.Two] = 50,
    [Enum.KeyCode.Three] = 51,
    [Enum.KeyCode.Four] = 52,
    [Enum.KeyCode.Five] = 53,
    [Enum.KeyCode.Six] = 54,
    [Enum.KeyCode.Seven] = 55,
    [Enum.KeyCode.Eight] = 56,
    [Enum.KeyCode.Nine] = 57,

    -- Letters
    [Enum.KeyCode.A] = 65,
    [Enum.KeyCode.B] = 66,
    [Enum.KeyCode.C] = 67,
    [Enum.KeyCode.D] = 68,
    [Enum.KeyCode.E] = 69,
    [Enum.KeyCode.F] = 70,
    [Enum.KeyCode.G] = 71,
    [Enum.KeyCode.H] = 72,
    [Enum.KeyCode.I] = 73,
    [Enum.KeyCode.J] = 74,
    [Enum.KeyCode.K] = 75,
    [Enum.KeyCode.L] = 76,
    [Enum.KeyCode.M] = 77,
    [Enum.KeyCode.N] = 78,
    [Enum.KeyCode.O] = 79,
    [Enum.KeyCode.P] = 80,
    [Enum.KeyCode.Q] = 81,
    [Enum.KeyCode.R] = 82,
    [Enum.KeyCode.S] = 83,
    [Enum.KeyCode.T] = 84,
    [Enum.KeyCode.U] = 85,
    [Enum.KeyCode.V] = 86,
    [Enum.KeyCode.W] = 87,
    [Enum.KeyCode.X] = 88,
    [Enum.KeyCode.Y] = 89,
    [Enum.KeyCode.Z] = 90,

    -- Keypad
    [Enum.KeyCode.KeypadZero] = 320,
    [Enum.KeyCode.KeypadOne] = 321,
    [Enum.KeyCode.KeypadTwo] = 322,
    [Enum.KeyCode.KeypadThree] = 323,
    [Enum.KeyCode.KeypadFour] = 324,
    [Enum.KeyCode.KeypadFive] = 325,
    [Enum.KeyCode.KeypadSix] = 326,
    [Enum.KeyCode.KeypadSeven] = 327,
    [Enum.KeyCode.KeypadEight] = 328,
    [Enum.KeyCode.KeypadNine] = 329,
    [Enum.KeyCode.KeypadPeriod] = 330,
    [Enum.KeyCode.KeypadDivide] = 331,
    [Enum.KeyCode.KeypadMultiply] = 332,
    [Enum.KeyCode.KeypadMinus] = 333,
    [Enum.KeyCode.KeypadPlus] = 334,
    [Enum.KeyCode.KeypadEnter] = 335,
    [Enum.KeyCode.KeypadEquals] = 336,

    -- Android / Media
    --[Enum.KeyCode.Back] = 4,
    --[Enum.KeyCode.MenuAndroid] = 5,
    --[Enum.KeyCode.VolumeUp] = 24,
    --[Enum.KeyCode.VolumeDown] = 25,
}

RayKey.ReverseKeyCode = {}
for k, v in pairs(RayKey.KeyCode) do
    RayKey.ReverseKeyCode[v] = k
end

return table.freeze(RayKey)
