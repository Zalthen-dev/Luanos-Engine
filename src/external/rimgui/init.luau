local platform = zune.platform;
local ffi = zune.ffi
local void = ffi.types.void
local int = ffi.types.i32
local uint = ffi.types.u32
local bool = ffi.types.u8
local float = ffi.types.float
local cstring = ffi.types.pointer
local pointer_bool = ffi.types.pointer
local pointer = ffi.types.pointer
local long = ffi.types.i64
local u16 = ffi.types.u16

type int = number
type uint = number
type bool = number
type float = number
type long = buffer
type double = number
type uint16 = number
type cstring = string | buffer | FFIPointer;

local ImVec2 = ffi.struct({
    {x = float},
    {y = float}
})
type ImVec2 = typeof(ImVec2:new({}))

local ImVec3 = ffi.struct({
    {x = float},
    {y = float},
    {z = float}
})
type ImVec3 = typeof(ImVec3:new({}))

local ImVec4 = ffi.struct({
    {x = float},
    {y = float},
    {z = float},
    {w = float}
})
type ImVec4 = typeof(ImVec4:new({}))

local ImGuiInputTextCallbackData = ffi.struct({
    { Ctx            = pointer },
    { EventFlag      = int },          -- ImGuiInputTextFlags
    { Flags          = int },          -- ImGuiInputTextFlags
    { UserData       = pointer },      -- void*

    { EventChar      = u16 },
    { EventKey       = int },

    { Buf            = pointer },      -- char*
    { BufTextLen     = int },          
    { BufSize        = int },

    { BufDirty       = bool },         -- bool
    { CursorPos      = int },
    { SelectionStart = int },
    { SelectionEnd   = int },
})
type ImGuiInputTextCallbackData = typeof(ImGuiInputTextCallbackData:new({}))

local function fn(returns: any, args: { any })
    return {
        returns = returns,
        args = args,
    };
end

type Fns = {
    rImGuiDisableIO: () -> (),
    rImGuiEnableIO: () -> (),

    rImGuiSetup: () -> (),
    rImGuiShutdown: () -> (),
    rImGuiBegin: () -> (),
    rImGuiEnd: () -> (),

    rImGui_ShowDemoWindow: () -> (),

    Begin: (cstring, FFIPointer, int?) -> (bool),
    End: () -> (),

    Text: (cstring) -> (),
    TextColored: (ImVec4, cstring) -> (),
    TextUnformatted: (cstring) -> (),
    TextDisabled: (cstring) -> (),
    TextWrapped: (cstring) -> (),
    LabelText: (cstring, cstring) -> (),
    BulletText: (cstring) -> (),
    Button: (cstring, ImVec2?) -> (bool),
    SmallButton: (cstring) -> (bool),
    Checkbox: (cstring, FFIPointer) -> (bool),
    RadioButton: (cstring, bool) -> (bool),

    InputTextMultiline: (cstring, FFIPointer, int, ImVec2, int, FFIPointer, FFIPointer) -> (bool),

    Separator: () -> (),

    MenuItem: (cstring, cstring) -> (bool),

    BeginMenu: (cstring) -> (bool),
    EndMenu: () -> (),
    BeginMenuBar: () -> (),
    EndMenuBar: () -> (),
    BeginMainMenuBar: () -> (bool),
    EndMainMenuBar: () -> (),

    GetWindowSize: () -> (ImVec2),
    GetContentRegionAvail: () -> (ImVec2),
    CalcTextSize: (cstring) -> (ImVec2),
    SetCursorPosX: (int) -> (),
    SetCursorPosY: (int) -> (),
    SetNextWindowSize: (ImVec2, int) -> (),

    IsAnyItemFocused: () -> (bool),
}

local defs = {
    rImGuiDisableIO = fn(void, {}),
    rImGuiEnableIO = fn(void, {}),

    rImGuiSetup = fn(void, {}),
    rImGuiShutdown = fn(void, {}),
    rImGuiBegin = fn(void, {}),
    rImGuiEnd = fn(void, {}),

    rImGui_ShowDemoWindow = fn(void, {}),

    Begin = fn(bool, {cstring, pointer_bool, int}),
    End = fn(void, {}),

    Text = fn(void, {cstring}),
    TextColored = fn(void, {ImVec4}),
    TextUnformatted = fn(void, {cstring}),
    TextDisabled = fn(void, {cstring}),
    TextWrapped = fn(void, {cstring}),
    LabelText = fn(void, {cstring, cstring}),
    BulletText = fn(void, {cstring}),
    Button = fn(bool, {cstring, ImVec2}),
    SmallButton = fn(bool, {cstring}),
    Checkbox = fn(bool, {cstring, pointer_bool}),
    RadioButton = fn(bool, {cstring, bool}),

    InputTextMultiline = fn(bool, {cstring, pointer, int, ImVec2, int, pointer, pointer}),

    Separator = fn(void, {}),

    MenuItem = fn(bool, {cstring, cstring}),

    BeginMenu = fn(bool, {cstring}),
    EndMenu = fn(void, {}),
    BeginMenuBar = fn(bool, {}),
    EndMenuBar = fn(void, {}),
    BeginMainMenuBar = fn(bool, {}),
    EndMainMenuBar = fn(void, {}),
    
    GetWindowSize = fn(ImVec2, {}),
    GetContentRegionAvail = fn(ImVec2, {}),
    CalcTextSize = fn(ImVec2, {cstring}),
    SetCursorPosX = fn(void, {int}),
    SetCursorPosY = fn(void, {int}),
    SetNextWindowSize = fn(void, {ImVec2, int}),

    IsAnyItemFocused = fn(bool, {}),
}

local libLocation = "./src/external/rimgui/bin/librimgui.so"

if platform.cpu.arch == "x86_64" then
    if platform.os == "windows" then
        libLocation = "./src/external/rimgui/bin/librimgui.dll"
    elseif platform.os == "linux" then
        libLocation = "./src/external/rimgui/bin/librimgui.so"
    else
        -- other platforms
    end
else
    -- other archs
end

local lib = ffi.dlopen(libLocation, defs) :: {
    GetSymbol: (self: FFILibrary, symbol: string) -> FFIPointer?,
} & Fns

return {
    ImVec2 = ImVec2,
    ImVec3 = ImVec3,
    ImVec4 = ImVec4,
    ImGuiInputTextCallbackData = ImGuiInputTextCallbackData,

    IMGUI_WINDOWFLAGS_NONE                        = 0,
    IMGUI_WINDOWFLAGS_NO_TITLE_BAR                = bit32.lshift(1, 1),
    IMGUI_WINDOWFLAGS_NO_RESIZE                   = bit32.lshift(1, 2),
    IMGUI_WINDOWFLAGS_NO_MOVE                     = bit32.lshift(1, 3),
    IMGUI_WINDOWFLAGS_NO_SCROLLBAR                = bit32.lshift(1, 4),
    IMGUI_WINDOWFLAGS_NO_SCROLL_WITH_MOUSE        = bit32.lshift(1, 5),
    IMGUI_WINDOWFLAGS_NO_COLLAPSE                 = bit32.lshift(1, 6),
    IMGUI_WINDOWFLAGS_ALWAYS_AUTO_RESIZE          = bit32.lshift(1, 7),
    IMGUI_WINDOWFLAGS_NO_BACKGROUND               = bit32.lshift(1, 8),
    IMGUI_WINDOWFLAGS_NO_SAVED_SETTINGS           = bit32.lshift(1, 9),
    IMGUI_WINDOWFLAGS_MENU_BAR                    = bit32.lshift(1, 10),
    IMGUI_WINDOWFLAGS_HORIZONTAL_SCROLLBAR        = bit32.lshift(1, 11),
    IMGUI_WINDOWFLAGS_NO_FOCUS_ON_APPEARING       = bit32.lshift(1, 12),
    IMGUI_WINDOWFLAGS_NO_BRING_TO_FRONT_ON_FOCUS  = bit32.lshift(1, 13),
    IMGUI_WINDOWFLAGS_ALWAYS_VERTICAL_SCROLLBAR   = bit32.lshift(1, 14),
    IMGUI_WINDOWFLAGS_ALWAYS_HORIZONTAL_SCROLLBAR = bit32.lshift(1, 15),
    IMGUI_WINDOWFLAGS_ALWAYS_USE_WINDOW_PADDING   = bit32.lshift(1, 16),
    IMGUI_WINDOWFLAGS_NO_NAV_INPUT                = bit32.lshift(1, 17),
    IMGUI_WINDOWFLAGS_NO_NAV_FOCUS                = bit32.lshift(1, 18),
    IMGUI_WINDOWFLAGS_NO_MOUSE_INPUT              = bit32.lshift(1, 19),
    IMGUI_WINDOWFLAGS_MENU_MODE                   = bit32.lshift(1, 20),
    IMGUI_WINDOWFLAGS_NO_NAV                      = bit32.bor(bit32.lshift(1, 19), bit32.lshift(1, 20)),

    IMGUI_COND_NONE        = 0,
    IMGUI_COND_ALWAYS      = bit32.lshift(1, 1),
    IMGUI_COND_ONCE        = bit32.lshift(1, 2),
    IMGUI_COND_FIRST_USE_EVER = bit32.lshift(1, 3),
    IMGUI_COND_APPEARING   = bit32.lshift(1, 4),

    IMGUI_INPUTTEXTFLAGS_NONE                = 0,
    IMGUI_INPUTTEXTFLAGS_CHARS_DECIMAL       = bit32.lshift(1, 1),
    IMGUI_INPUTTEXTFLAGS_CHARS_HEXADECIMAL   = bit32.lshift(1, 2),
    IMGUI_INPUTTEXTFLAGS_CHARS_SCIENTIFIC    = bit32.lshift(1, 3),
    IMGUI_INPUTTEXTFLAGS_CHARS_UPPERCASE     = bit32.lshift(1, 4),
    IMGUI_INPUTTEXTFLAGS_CHARS_NOBLANK       = bit32.lshift(1, 5),

    IMGUI_INPUTTEXTFLAGS_ALLOW_TAB_INPUT     = bit32.lshift(1, 6),
    IMGUI_INPUTTEXTFLAGS_ENTER_RETURNS_TRUE  = bit32.lshift(1, 7),
    IMGUI_INPUTTEXTFLAGS_ESCAPE_CLEARS_ALL   = bit32.lshift(1, 8),
    IMGUI_INPUTTEXTFLAGS_CTRL_ENTER_NEWLINE  = bit32.lshift(1, 9),

    IMGUI_INPUTTEXTFLAGS_READONLY            = bit32.lshift(1, 10),
    IMGUI_INPUTTEXTFLAGS_PASSWORD            = bit32.lshift(1, 11),
    IMGUI_INPUTTEXTFLAGS_ALWAYS_OVERWRITE    = bit32.lshift(1, 12),
    IMGUI_INPUTTEXTFLAGS_AUTO_SELECT_ALL     = bit32.lshift(1, 13),
    IMGUI_INPUTTEXTFLAGS_PARSE_EMPTY_REFVAL  = bit32.lshift(1, 14),
    IMGUI_INPUTTEXTFLAGS_DISPLAY_EMPTY_REFVAL= bit32.lshift(1, 15),
    IMGUI_INPUTTEXTFLAGS_NO_HORIZONTAL_SCROLL= bit32.lshift(1, 16),
    IMGUI_INPUTTEXTFLAGS_NO_UNDO_REDO        = bit32.lshift(1, 17),
    
    IMGUI_INPUTTEXTFLAGS_ELIDE_LEFT          = bit32.lshift(1, 18),

    IMGUI_INPUTTEXTFLAGS_CALLBACK_COMPLETION = bit32.lshift(1, 19),
    IMGUI_INPUTTEXTFLAGS_CALLBACK_HISTORY    = bit32.lshift(1, 20),
    IMGUI_INPUTTEXTFLAGS_CALLBACK_ALWAYS     = bit32.lshift(1, 21),
    IMGUI_INPUTTEXTFLAGS_CALLBACK_CHARFILTER = bit32.lshift(1, 22),
    IMGUI_INPUTTEXTFLAGS_CALLBACK_RESIZE     = bit32.lshift(1, 23),
    IMGUI_INPUTTEXTFLAGS_CALLBACK_EDIT       = bit32.lshift(1, 24),

    IMGUI_INPUTTEXTFLAGS_WORDWRAP            = bit32.lshift(1, 25),

    rImGuiDisableIO = lib.rImGuiDisableIO,
    rImGuiEnableIO = lib.rImGuiEnableIO,

    rImGuiSetup = lib.rImGuiSetup,
    rImGuiShutdown = lib.rImGuiShutdown,
    rImGuiBegin = lib.rImGuiBegin,
    rImGuiEnd = lib.rImGuiEnd,
    rImGui_ShowDemoWindow = lib.rImGui_ShowDemoWindow,

    Begin = function(text: cstring, p_open: FFIPointer, flags: int?)
        if type(flags) ~= "number" then
            flags = 0
        end

        return lib.Begin(text, p_open, flags)
    end,
    End = lib.End,

    Text = lib.Text,
    TextColored = lib.TextColored,
    TextUnformatted = lib.TextUnformatted,
    TextDisabled = lib.TextDisabled,
    TextWrapped = lib.TextWrapped,
    LabelText = lib.LabelText,
    BulletText = lib.BulletText,

    InputTextMultiline = lib.InputTextMultiline,

    Separator = lib.Separator,

    Button = function(label: cstring, size: vector?)
        if not size then
            size = vector.zero
        end

        local imvec = ImVec2:new({x = size.x, y = size.y})
        return lib.Button(label, imvec)
    end,
    SmallButton = lib.SmallButton,
    Checkbox = lib.Checkbox,
    RadioButton = lib.RadioButton,

    MenuItem = function(label:cstring, keybind: cstring?)
        return lib.MenuItem(label, keybind or "")
    end,
    BeginMenu = lib.BeginMenu,
    EndMenu = lib.EndMenu,
    BeginMenuBar = lib.BeginMenuBar,
    EndMenuBar = lib.EndMenuBar,
    BeginMainMenuBar = lib.BeginMainMenuBar,
    EndMainMenuBar = lib.EndMainMenuBar,

    GetWindowSize = lib.GetWindowSize,
    GetContentRegionAvail = lib.GetContentRegionAvail,
    CalcTextSize = lib.CalcTextSize,
    SetCursorPosX = lib.SetCursorPosX,
    SetCursorPosY = lib.SetCursorPosY,
    SetNextWindowSize = lib.SetNextWindowSize,

    IsAnyItemFocused = lib.IsAnyItemFocused,

    NewImVec2 = function(x, y)
        return ImVec2:new({x=x, y=y})
    end,
    NewImVec3 = function(x, y, z)
        return ImVec3:new({x=x, y=y, z=z})
    end,
    NewImVec4 = function(x, y, z, w)
        return ImVec4:new({x=x, y=y, z=z, w=w})
    end,

    FromImVec2 = function(imvec)
        return {
            x = buffer.readf32(imvec, 0),
            y = buffer.readf32(imvec, 4),
        }  
    end,
    FromImVec3 = function(imvec)
        return {
            x = imvec:readf32(0),
            y = imvec:readf32(4),
            z = imvec:readf32(8),
        }
    end,
    FromImVec4 = function(imvec)
        
        return {
            x = buffer.readf32(imvec, 0),
            y = buffer.readf32(imvec, 4),
            z = buffer.readf32(imvec, 8),
            w = buffer.readf32(imvec, 12),
        }
    end,
}
