local Enum = {
    EasingDirection = {
        In = 0,
        Out = 1,
        InOut = 2,
    },

    EasingStyle = {
        Linear = 0,
        Sine = 1,
        Back = 2,
        Quad = 3,
        Quart = 4,
        Quint = 5,
        Bounce = 6,
        Elastic = 7,
        Exponential = 8,
        Circular = 9,
        Cubic = 10
    },

    HorizontalAlignment = {
        Center = 0,
        Left = 1,
        Right = 2,
    },
    KeyCode = {

        Unknown = 0,

        -- Special Keys
        Space = 32,
        Escape = 256,
        Enter = 257,
        Tab = 258,
        Backspace = 259,
        Insert = 260,
        Delete = 261,
        Right = 262,
        Left = 263,
        Down = 264,
        Up = 265,
        PageUp = 266,
        PageDown = 267,
        Home = 268,
        End = 269,
        CapsLock = 280,
        ScrollLock = 281,
        NumLock = 282,
        Print = 283,
        Pause = 284,

        -- Function Keys
        F1 = 290,
        F2 = 291,
        F3 = 292,
        F4 = 293,
        F5 = 294,
        F6 = 295,
        F7 = 296,
        F8 = 297,
        F9 = 298,
        F10 = 299,
        F11 = 300,
        F12 = 301,

        -- Modifier Keys
        LeftShift = 340,
        LeftControl = 341,
        LeftAlt = 342,
        LeftSuper = 343, -- (Meta/Windows)
        RightShift = 344,
        RightControl = 345,
        RightAlt = 346,
        RightSuper = 347, -- (Meta/Windows)
        Menu = 348,

        -- Symbols (Physical Keys)
        Quote = 39,      -- '
        Comma = 44,      -- ,
        Minus = 45,      -- -
        Period = 46,     -- .
        Slash = 47,      -- /
        Semicolon = 59,  -- ;
        Equals = 61,     -- =
        LeftBracket = 91,  -- [
        BackSlash = 92,    -- \
        RightBracket = 93, -- ]
        Backquote = 96,    -- `

        -- Numbers
        Zero = 48,
        One = 49,
        Two = 50,
        Three = 51,
        Four = 52,
        Five = 53,
        Six = 54,
        Seven = 55,
        Eight = 56,
        Nine = 57,

        -- Letters
        A = 65,
        B = 66,
        C = 67,
        D = 68,
        E = 69,
        F = 70,
        G = 71,
        H = 72,
        I = 73,
        J = 74,
        K = 75,
        L = 76,
        M = 77,
        N = 78,
        O = 79,
        P = 80,
        Q = 81,
        R = 82,
        S = 83,
        T = 84,
        U = 85,
        V = 86,
        W = 87,
        X = 88,
        Y = 89,
        Z = 90,

        -- Keypad
        KeypadZero = 320,
        KeypadOne = 321,
        KeypadTwo = 322,
        KeypadThree = 323,
        KeypadFour = 324,
        KeypadFive = 325,
        KeypadSix = 326,
        KeypadSeven = 327,
        KeypadEight = 328,
        KeypadNine = 329,
        KeypadPeriod = 330,
        KeypadDivide = 331,
        KeypadMultiply = 332,
        KeypadMinus = 333,
        KeypadPlus = 334,
        KeypadEnter = 335,
        KeypadEquals = 336,

        -- Android / Media
        Back = 4,
        MenuAndroid = 5,
        VolumeUp = 24,
        VolumeDown = 25,

        ButtonX = 1000,
        ButtonY = 1001,
        ButtonA = 1002,
        ButtonB = 1003,
        ButtonR1 = 1004,
        ButtonL1 = 1005,
        ButtonR2 = 1006,
        ButtonL2 = 1007,
        ButtonR3 = 1008,
        ButtonL3 = 1009,
        ButtonStart = 1010,
        ButtonSelect = 1011,
        Mode = 1012,

        DPadLeft = 1013,
        DPadRight = 1014,
        DPadUp = 1015,
        DPadDown = 1016,

        Thumbstick1 = 1017,
        Thumbstick2 = 1018,

        Thumbstick1Up = 1019,
        Thumbstick1Down = 1020,
        Thumbstick1Left = 1021,
        Thumbstick1Right = 1022,
        Thumbstick2Up = 1023,
        Thumbstick2Down = 1024,
        Thumbstick2Left = 1025,
        Thumbstick2Right = 1026,

        MouseLeftButton = 1027,
        MouseRightButton = 1028,
        MouseMiddleButton = 1029,

        MousePosition = 133
    },
    Material = {
        Plastic = 256,
        SmoothPlastic = 272,
        Neon = 288,
        Wood = 512,
        WoodPlanks = 528,
        Marble = 784,
        Basalt = 788,
        Slate = 800,
        CrackedLava = 804,
        Concrete = 816,
        Limestone = 820,
        Granite = 832,
        Pavement = 836,
        Brick = 848,
        Pebble = 864,
        Cobblestone = 880,
        Rock = 896,
        Sandstone = 912,
        CorrodedMetal = 1040,
        DiamondPlate = 1056,
        Foil = 1072,
        Metal = 1088,
        Grass = 1280,
        LeafyGrass = 1284,
        Sand = 1296,
        Fabric = 1312,
        Snow = 1328,
        Mud = 1344,
        Ground = 1360,
        Asphalt = 1376,
        Salt = 1392,
        Ice = 1536,
        Glacier = 1552,
        Glass = 1568,
        ForceField = 1584,
        Air = 1792,
        Water = 2048,
        Cardboard = 2304,
        Carpet = 2305,
        CeramicTiles = 2306,
        ClayRoofTiles = 2307,
        RoofShingles = 2308,
        Leather = 2309,
        Plaster = 2310,
        Rubber = 2311,
    },

    PartType = {
        Ball = 0,
        Block = 1,
        Cylinder = 2,
        Wedge = 3,
        CornerWedge = 4,
        Torus = 5, -- custom
    },

    UserInputType = {
        Unknown = 9000,
        Keyboard = 9001,
        MouseMovement = 9002,
        Mouse = 9003,
        MouseButton1 = 9004,
        MouseButton2 = 9005,
        MouseButton3 = 9006,
        MouseWheel = 9007,
        Gamepad1 = 9008,
        Gamepad2 = 9009,
        Gamepad3 = 9010,
        Gamepad4 = 9011,
    },

    VerticalAlignment = {
        Center = 0,
        Top = 1,
        Bottom = 2,
    },
}

return table.freeze(Enum)
