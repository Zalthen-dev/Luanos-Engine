local ffi = zune.ffi
local platform = zune.platform

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

local TextFFI = ffi.struct({
    {length = int},
    {text = cstring}
})
type TextFFI = typeof(TextFFI:new({}))

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
    rImGuiEnableDocking: () -> (),
    rImGuiDisableDocking: () -> (),

    GetMainViewport: () -> (FFIPointer),

    rImGuiSetup: () -> (),
    rImGuiShutdown: () -> (),
    rImGuiBegin: () -> (),
    rImGuiEnd: () -> (),
    
    ShowDemoWindow: () -> (),
    ShowStyleEditor: () -> (),

    Begin: (label:cstring, p_open:FFIPointer, flags:int?) -> (bool),
    End: () -> (),
    BeginChild: (label:cstring, size:ImVec2, border:bool, flags:int) -> (bool),
    EndChild: () -> (),
    BeginMenu: (label: cstring) -> (bool),
    EndMenu: () -> (),
    BeginMenuBar: () -> (),
    EndMenuBar: () -> (),
    BeginMainMenuBar: () -> (bool),
    EndMainMenuBar: () -> (),
    BeginPopupContextWindow: () -> (bool),
    BeginPopupContextItem: () -> (bool),
    EndPopup: () -> (),
    BeginCombo: (string, string, int) -> (bool),
    EndCombo: () -> (),

    GetID: (str_id:cstring) -> (uint),

    PushStyleColor: (idx:int, color:ImVec4) -> (),
    PopStyleColor: (count:int?) -> (),
    PushStyleVarFloat: (idx:int, val:float) -> (),
    PushStyleVarVec2: (idx:int, val:ImVec2) -> (),
    PopStyleVar: (count:int?) -> (),
    PushID: (str_id:cstring) -> (),
    PopID: () -> (),

    Text: (text:cstring) -> (),
    TextLinkOpenURL: (text:cstring, url:cstring) -> (),
    TextColored: (color:ImVec4, text:cstring) -> (),
    TextUnformatted: (text:cstring) -> (),
    TextDisabled: (text:cstring) -> (),
    TextWrapped: (text:cstring) -> (),
    LabelText: (cstring, cstring) -> (),
    BulletText: (cstring) -> (),
    Button: (cstring, ImVec2?) -> (bool),
    SmallButton: (cstring) -> (bool),
    Checkbox: (cstring, FFIPointer) -> (bool),
    RadioButton: (cstring, bool) -> (bool),

    DragFloat: (label:cstring, value:FFIPointer, speed:float, min:float, max:float, format:cstring, flags:int) -> (bool),
    DragInt: (label:cstring, value:FFIPointer, speed:float, min:int, max:int, format:cstring, flags:int) -> (bool),
    SliderFloat: (label:cstring, value:FFIPointer, min:float, max:float, format:cstring, flags:int) -> (bool),
    SliderInt: (label:cstring, value:FFIPointer, min:int, max:int, format:cstring, flags:int) -> (bool),
    InputFloat: (label:cstring, value:FFIPointer, step:float, stepFast:float, format:cstring, flags:int) -> (bool),
    InputInt: (label:cstring, value:FFIPointer, step:int, stepFast:int, flags:int) -> (bool),
    InputText: (cstring, FFIPointer, int, int) -> (bool),
    InputTextMultiline: (cstring, FFIPointer, int, ImVec2, int, FFIPointer, FFIPointer) -> (bool),

    Separator: () -> (),
    SameLine: () -> (),

    MenuItem: (cstring, cstring) -> (bool),
    Selectable: (cstring) -> (bool),

    TreeNode: (cstring) -> (bool),
    TreeNodeEx: (cstring, int) -> (bool),
    TreePop: () -> (),

    BeginTabBar: (cstring, int) -> (bool),
    EndTabBar: () -> (),
    BeginTabItem: (cstring, FFIPointer, int) -> (bool),
    EndTabItem: () -> (),

    GetWindowSize: () -> (ImVec2),
    GetContentRegionAvail: () -> (ImVec2),
    GetViewportSize: (FFIPointer) -> (ImVec2),
    GetCursorScreenPos: () -> (ImVec2),
    CalcTextSize: (cstring) -> (ImVec2),
    SetCursorPosX: (int) -> (),
    SetCursorPosY: (int) -> (),
    SetNextWindowSize: (ImVec2, int) -> (),
    SetNextItemOpen: (bool, int) -> (),

    IsItemClicked: () -> (),
    IsMouseDoubleClicked: (int) -> (bool),
    IsItemToggledSelection: () -> (bool),
    IsItemToggledOpen: () -> (bool),
    IsItemDeactivatedAfterEdit: () -> (bool),
    IsAnyItemFocused: () -> (bool),
    IsAnyItemHovered: () -> (bool),
    igIsWindowFocused: () -> (bool),
    IsWindowHovered: (int) -> (bool),
    IsItemHovered: (int) -> (bool),
    
    SetTooltip: (cstring) -> (),
    BeginTooltip: () -> (),
    EndTooltip: () -> (),

    igImage: (uint, float, float, ImVec2, ImVec2) -> (),

    GetScrollY: () -> (float),
    GetScrollMaxY: () -> (float),
    SetScrollHereY: (float) -> (),

    DockSpaceOverViewport: (idx:int, viewport:FFIPointer, flags:int) -> (int),
    DockBuilderGetNode: (uint) -> (FFIPointer),
    DockBuilderAddNode: (uint, int) -> (uint),
    DockBuilderSetNodeSize: (uint, ImVec2) -> (),
    DockBuilderSplitNode: (uint, int, float, FFIPointer, FFIPointer) -> (uint),
    DockBuilderDockWindow: (cstring, uint) -> (),
    DockBuilderFinish: (uint) -> (),

    TextEditorCreate: (int) -> (FFIPointer),
    TextEditorGetText: (FFIPointer) -> (cstring),
    TextEditorSetText: (FFIPointer, cstring) -> (),
    TextEditorGetLength: (FFIPointer) -> (int),
    TextEditorDraw: (FFIPointer, cstring, ImVec2, int) -> (),
    TextEditorDestroy: (FFIPointer) -> (),

    SetStyleRounding: (windowRounding: float, childRounding: float, frameRounding: float, grabRounding: float, popupRounding: float, scrollbarRounding: float, tabRounding: float) -> (),
    SetStyleColor: (int, ImVec4) -> (),
    GetStyleColor: (int) -> (ImVec4),
    SetStyleDark: () -> (),
    SetStyleLight: () -> (),
    SetStyleVisualStudioDarkBlue: () -> (),
    SetStyleClassicSteamVGUI: () -> (),
}

local defs = {
    rImGuiDisableIO = fn(void, {}),
    rImGuiEnableIO = fn(void, {}),
    rImGuiEnableDocking = fn(void, {}),
    rImGuiDisableDocking = fn(void, {}),

    GetMainViewport = fn(pointer, {}),

    rImGuiSetup = fn(void, {}),
    rImGuiShutdown = fn(void, {}),
    rImGuiBegin = fn(void, {}),
    rImGuiEnd = fn(void, {}),

    ShowDemoWindow = fn(void, {}),
    ShowStyleEditor = fn(void, {}),

    Begin = fn(bool, {cstring, pointer_bool, int}),
    End = fn(void, {}),
    BeginChild = fn(bool, {cstring, ImVec2, bool, int}),
    EndChild = fn(void, {}),
    BeginMenu = fn(bool, {cstring}),
    EndMenu = fn(void, {}),
    BeginMenuBar = fn(bool, {}),
    EndMenuBar = fn(void, {}),
    BeginMainMenuBar = fn(bool, {}),
    EndMainMenuBar = fn(void, {}),
    BeginPopupContextWindow = fn(bool, {}),
    BeginPopupContextItem = fn(bool, {}),
    EndPopup = fn(void, {}),
    BeginCombo = fn(bool, {cstring, cstring, int}),
    EndCombo = fn(void, {}),

    GetID = fn(uint, {cstring}),

    PushStyleColor = fn(void, {int, ImVec4}),
    PopStyleColor = fn(void, {}),
    PushStyleVarFloat = fn(void, {int, float}),
    PushStyleVarVec2 = fn(void, {int, ImVec2}),
    PopStyleVar = fn(void, {int}),
    PushID = fn(void, {cstring}),
    PopID = fn(void, {}),

    Text = fn(void, {cstring}),
    TextLinkOpenURL = fn(void, {cstring, cstring}),
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

    DragFloat = fn(bool, {cstring, pointer, float, float, float, cstring, int}),
    DragInt = fn(bool, {cstring, pointer, float, int, int, cstring, int}),
    SliderFloat = fn(bool, {cstring, pointer, float, float, cstring, int}),
    SliderInt = fn(bool, {cstring, pointer, int, int, cstring, int}),
    InputFloat = fn(bool, {cstring, pointer, float, float, cstring, int}),
    InputInt = fn(bool, {cstring, pointer, int, int, int}),
    InputText = fn(bool, {cstring, pointer, int, int}),
    InputTextMultiline = fn(bool, {cstring, pointer, int, ImVec2, int}),

    Separator = fn(void, {}),
    SameLine = fn(void, {}),

    MenuItem = fn(bool, {cstring, cstring}),
    Selectable = fn(bool, {cstring}),

    TreeNode = fn(bool, {cstring}),
    TreeNodeEx = fn(bool, {cstring, int}),
    TreePop = fn(void, {}),

    BeginTabBar = fn(bool, {cstring}),
    EndTabBar = fn(void, {}),
    BeginTabItem = fn(bool, {cstring, pointer, int}),
    EndTabItem = fn(void, {}),
    
    GetWindowSize = fn(ImVec2, {}),
    GetContentRegionAvail = fn(ImVec2, {}),
    GetViewportSize = fn(ImVec2, {pointer}),
    GetCursorScreenPos = fn(ImVec2, {}),
    CalcTextSize = fn(ImVec2, {cstring}),
    SetCursorPosX = fn(void, {int}),
    SetCursorPosY = fn(void, {int}),
    SetNextWindowSize = fn(void, {ImVec2, int}),
    SetNextItemOpen = fn(void, {bool, int}),

    IsItemClicked = fn(bool, {}),
    IsMouseDoubleClicked = fn(bool, {int}),
    IsItemToggledOpen = fn(bool, {}),
    IsItemToggledSelection = fn(bool, {}),
    IsAnyItemFocused = fn(bool, {}),
    IsAnyItemHovered = fn(bool, {}),
    IsItemDeactivatedAfterEdit = fn(bool, {}),
    igIsWindowFocused = fn(bool, {}),
    IsWindowHovered = fn(bool, {int}),
    IsItemHovered = fn(bool, {int}),

    BeginTooltip = fn(void, {}),
    EndTooltip = fn(void, {}),

    igImage = fn(void, {uint, float, float, ImVec2, ImVec2}),

    GetScrollY = fn(float, {}),
    GetScrollMaxY = fn(float, {}),
    SetScrollHereY = fn(void, {float}),

    DockSpaceOverViewport = fn(uint, {uint, pointer, int}),
    DockBuilderGetNode = fn(pointer, {uint}),
    DockBuilderAddNode = fn(uint, {uint, int}),
    DockBuilderSetNodeSize = fn(void, {uint, ImVec2}),
    DockBuilderSplitNode = fn(uint, {uint, int, float, pointer, pointer}),
    DockBuilderDockWindow = fn(void, {cstring, uint}),
    DockBuilderFinish = fn(void, {uint}),

    TextEditorCreate  = fn(pointer, {int}),
    TextEditorGetText = fn(cstring, {pointer}),
    TextEditorGetLength = fn(int, {pointer}),
    TextEditorSetText = fn(void, {pointer, cstring}),
    TextEditorDraw = fn(void, {pointer, cstring, ImVec2, int}),
    TextEditorDestroy = fn(void, {}),

    SetStyleRounding = fn(void, {float, float, float, float, float, float, float}),
    SetStyleColor = fn(void, {int, ImVec4}),
    GetStyleColor = fn(ImVec4, {int}),
    SetStyleDark = fn(void, {}),
    SetStyleLight = fn(void, {}),
    SetStyleVisualStudioDarkBlue = fn(void, {}),
    SetStyleClassicSteamVGUI = fn(void, {}),
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

    WINDOW_FLAGS = {
        NONE = 0,
        NO_TITLE_BAR = bit32.lshift(1, 0),
        NO_RESIZE = bit32.lshift(1, 1),
        NO_MOVE = bit32.lshift(1, 2),
        NO_SCROLLBAR = bit32.lshift(1, 3),
        NO_SCROLL_WITH_MOUSE = bit32.lshift(1, 4),
        NO_COLLAPSE = bit32.lshift(1, 5),
        ALWAYS_AUTO_RESIZE = bit32.lshift(1, 6),
        NO_BACKGROUND = bit32.lshift(1, 7),
        NO_SAVED_SETTINGS = bit32.lshift(1, 8),
        MENU_BAR = bit32.lshift(1, 10),
        NO_MOUSE_INPUTS = bit32.lshift(1, 10),
        HORIZONTAL_SCROLLBAR = bit32.lshift(1, 11),
        NO_FOCUS_ON_APPEARING = bit32.lshift(1, 12),
        NO_BRING_TO_FRONT_ON_FOCUS = bit32.lshift(1, 13),
        ALWAYS_VERTICAL_SCROLLBAR = bit32.lshift(1, 14),
        ALWAYS_HORIZONTAL_SCROLLBAR = bit32.lshift(1, 15),
        ALWAYS_USE_WINDOW_PADDING = bit32.lshift(1, 16),
        NO_NAV_INPUT = bit32.lshift(1, 17),
        NO_NAV_FOCUS = bit32.lshift(1, 18),
        NO_MOUSE_INPUT = bit32.lshift(1, 19),
        MENU_MODE = bit32.lshift(1, 20),
        NO_NAV = bit32.lshift(1, 21),
    },

    COND = {
        NONE = 0,
        ALWAYS = 1,
        ONCE = 2,
        FIRST_USE_EVER = 4,
        APPEARING = 8,
    },

    COL = {
        TEXT                  = 0,
        TEXTDISABLED          = 1,
        WINDOWBG              = 2,
        CHILDBG               = 3,
        POPUPBG               = 4,
        BORDER                = 5,
        BORDERSHADOW          = 6,
        FRAMEBG               = 7,
        FRAMEBGHOVERED        = 8,
        FRAMEBGACTIVE         = 9,
        TITLEBG               = 10,
        TITLEBGACTIVE         = 11,
        TITLEBGCOLLAPSED      = 12,
        MENUBARBG             = 13,
        SCROLLBARBG           = 14,
        SCROLLBARGRAB         = 15,
        SCROLLBARGRABHOVERED  = 16,
        SCROLLBARGRABACTIVE   = 17,
        CHECKMARK             = 18,
        SLIDERGRAB            = 19,
        SLIDERGRABACTIVE      = 20,
        BUTTON                = 21,
        BUTTONHOVERED         = 22,
        BUTTONACTIVE          = 23,
        HEADER                = 24,
        HEADERHOVERED         = 25,
        HEADERACTIVE          = 26,
        SEPARATOR             = 27,
        SEPARATORHOVERED      = 28,
        SEPARATORACTIVE       = 29,
        RESIZEGRIP            = 30,
        RESIZEGRIPHOVERED     = 31,
        RESIZEGRIPACTIVE      = 32,
        TAB                   = 33,
        TABHOVERED            = 34,
        TABACTIVE             = 35,
        TABUNFOCUSED          = 36,
        TABUNFOCUSEDACTIVE    = 37,
        TABDIMMED             = 38,
        TABDIMMEDSELECTED     = 39,
        TABDIMMEDSELECTEDOVERLINE = 40,
        DOCKINGPREVIEW        = 41,
        DOCKINGEMPTYBG        = 42,
        PLOTLINES             = 43,
        PLOTLINESHOVERED      = 44,
        PLOTHISTOGRAM         = 45,
        PLOTHISTOGRAMHOVERED  = 46,
        TABLEHEADERBG         = 47,
        TABLEBORDERSTRONG     = 48,
        TABLEBORDERLIGHT      = 49,
        TABLEROWBG            = 50,
        TABLEROWBGALT         = 51,
        TEXTLINK              = 52,
        TEXTSELECTEDBG        = 53,
        TREELINES             = 54,
        DRAGDROPTARGET        = 55,
        DRAGDROPTARGETBG      = 56,
        UNSAVEDMARKER         = 57,
        NAVHIGHLIGHT          = 58,
        NAVWINDOWINGHIGHLIGHT = 59,
        NAVWINDOWINGDIMBG     = 60,
        MODALWINDOWDIMGB      = 61,
        COUNT                 = 62,
    },
    
    INPUT_TEXT_FLAGS = {
        NONE                   = 0,
        CHARS_DECIMAL          = 1,
        CHARS_HEXADECIMAL      = 2,
        CHARS_SCIENTIFIC       = 4,
        CHARS_UPPERCASE        = 8,
        CHARS_NOBLANK          = 16,
        ALLOW_TAB_INPUT        = 32,
        ENTER_RETURNS_TRUE     = 64,
        ESCAPE_CLEARS_ALL      = 128,
        CTRL_ENTER_NEWLINE     = 256,
        READONLY               = 512,
        PASSWORD               = 1024,
        ALWAYS_OVERWRITE       = 2048,
        AUTO_SELECT_ALL        = 4096,
        PARSE_EMPTY_REFVAL     = 8192,
        DISPLAY_EMPTY_REFVAL   = 16384,
        NO_HORIZONTAL_SCROLL   = 32768,
        NO_UNDO_REDO           = 65536,
        ELIDE_LEFT             = 131072,
        CALLBACK_COMPLETION    = 262144,
        CALLBACK_HISTORY       = 524288,
        CALLBACK_ALWAYS        = 1048576,
        CALLBACK_CHARFILTER    = 2097152,
        CALLBACK_RESIZE        = 4194304,
        CALLBACK_EDIT          = 8388608,
        WORDWRAP               = 16777216,
        MULTILINE              = 67108864,
    },

    DOCK_NODE_FLAGS = {
        NONE                  = 0,
        KEEP_ALIVE_ONLY       = bit32.lshift(1, 0),
        NO_DOCKING_IN_CENTRAL_NODE = bit32.lshift(1, 2),
        PASSTHRU_CENTRAL_NODE = bit32.lshift(1, 3), -- Useful for transparent backgrounds
        NO_SPLIT              = bit32.lshift(1, 4),
        NO_RESIZE             = bit32.lshift(1, 5),
        AUTO_HIDE_TAB_BAR     = bit32.lshift(1, 6),
        NO_UNDOCKING          = bit32.lshift(1, 7),
        NO_DOCKING_SPLIT_ME   = bit32.lshift(1, 8),
        NO_DOCKING_OVER_ME    = bit32.lshift(1, 9),
        NO_DOCKING_OVER_OTHER = bit32.lshift(1, 10),
        NO_DOCKING_OVER_EMPTY = bit32.lshift(1, 11),
        DOCK_SPACE            = bit32.lshift(1, 10),
        CENTRAL_NODE          = bit32.lshift(1, 11),
        NO_TAB_BAR            = bit32.lshift(1, 12),
        HIDDEN_TAB_BAR        = bit32.lshift(1, 13),
        NO_WINDOW_MENU_BUTTON = bit32.lshift(1, 14),
        NO_CLOSE_BUTTON       = bit32.lshift(1, 15),
        NO_RESIZE_X           = bit32.lshift(1, 16),
        NO_RESIZE_Y           = bit32.lshift(1, 17),
    },

    TREE_NODE_FLAGS = {
        SELECTED                = 1,
        FRAMED                  = 2,
        ALLOWOVERLAP            = 4,
        NOTREEPUSHONOPEN        = 8,
        NOAUTOOPENONLOG         = 16,
        DEFAULTOPEN             = 32,
        OPENONDOUBLECLICK       = 64,
        OPENONARROW             = 128,
        LEAF                    = 256,
        FRAMEPADDING            = 1024,
        SPANAVAILWIDTH          = 2048,
        SPANFULLWIDTH           = 4096,
        SPANTEXTWIDTH           = 8192,
        SPANALLCOLUMNS          = 16384,
        NAVLEFTJUMPSBACKHERE    = 32768,
        COLLAPSINGHEADER        = 26,
        ALL                     = 65535,
    },

    TAB_BAR_FLAGS = {
        NONE                          = 0,
        REORDERABLE                   = 1,
        AUTOSELECTNEWTABS             = 2,
        NOCLOSEWITHMIDDLEMOUSEBUTTON  = 4,
        NOTABLISTPOPUPBUTTON          = 8,
        NOTABLISTSCROLLINGBUTTONS     = 16,
        FITTINGPOLICYRESIZEDOWN       = 32,
        FITTINGPOLICYSCROLL           = 64,
    },
    
    TAB_ITEM_FLAGS = {
        NONE                         = 0,
        UNSAVEDDOCUMENT              = 1,
        SETSELECTED                  = 2,
        NOCLOSEWITHMIDDLEMOUSEBUTTON = 4,
        NOPUSHID                     = 8,
        NOTOOLTIP                    = 16,
        NOREORDER                    = 32,
        LEADING                      = 64,
        TRAILING                     = 128,
        NOASSUMEDCLOSURE             = 256,
    },

    SEPARATOR = {
        NONE                     = bit32.lshift(1, 0),
        HORIZONTAL               = bit32.lshift(1, 0),
        VERTICAL                 = bit32.lshift(1, 1),
        SPAN_ALL_COLUMNS         = bit32.lshift(1, 2),
    },

    COMBO_FLAGS = {
        NONE                    = 0,
        POPUP_ALIGN             = bit32.lshift(1, 0),
        HEIGHT_SMALL            = bit32.lshift(1, 1),
        HEIGHT_REGULAR          = bit32.lshift(1, 2),
        HEIGHT_LARGE            = bit32.lshift(1, 3),
        HEIGHT_LARGEST          = bit32.lshift(1, 4),
        NO_ARROW_BUTTON         = bit32.lshift(1, 5),
        NO_PREVIEW              = bit32.lshift(1, 6),
        WIDTH_FIT_PREVIEW       = bit32.lshift(1, 7),
        HEIGHT_MASK_            = bit32.bor(bit32.lshift(1, 1), bit32.lshift(1, 2), bit32.lshift(1, 3), bit32.lshift(1, 4)),
    },

    Dir = {
        None  = -1,
        Left  = 0,
        Right = 1,
        Up    = 2,
        Down  = 3,
    },

    StyleVar = {
        Alpha               = 0,
        DisabledAlpha       = 1,
        WindowPadding       = 2,
        WindowRounding      = 3,
        WindowBorderSize    = 4,
        WindowMinSize       = 5,
        WindowTitleAlign    = 6,
        ChildRounding       = 7,
        ChildBorderSize     = 8,
        PopupRounding       = 9,
        PopupBorderSize     = 10,
        FramePadding        = 11,
        FrameRounding       = 12,
        FrameBorderSize     = 13,
        ItemSpacing         = 14,
        ItemInnerSpacing    = 15,
        IndentSpacing       = 16,
        CellPadding         = 17,
        ScrollbarSize       = 18,
        ScrollbarRounding   = 19,
        GrabMinSize         = 20,
        GrabRounding        = 21,
        TabRounding         = 22,
        ButtonTextAlign     = 23,
        SelectableTextAlign = 24,
        SeparatorTextBorderSize = 25,
        SeparatorTextAlign  = 26,
        SeparatorTextPadding= 27,
        DockingSeparatorSize= 28,
    },

    rImGuiDisableIO = lib.rImGuiDisableIO,
    rImGuiEnableIO = lib.rImGuiEnableIO,
    rImGuiEnableDocking = lib.rImGuiEnableDocking,
    rImGuiDisableDocking = lib.rImGuiDisableDocking,

    GetMainViewport = lib.GetMainViewport,

    rImGuiSetup = lib.rImGuiSetup,
    rImGuiShutdown = lib.rImGuiShutdown,
    rImGuiBegin = lib.rImGuiBegin,
    rImGuiEnd = lib.rImGuiEnd,

    ShowDemoWindow = lib.ShowDemoWindow,
    ShowStyleEditor = lib.ShowStyleEditor,

    Begin = function(text: string, p_open: FFIPointer?, flags: int?) return lib.Begin(text, p_open, flags or 0) end,
    End = lib.End,
    BeginChild = function(text: string, size: ImVec2?, border: boolean?, flags: int?)
        if not size then size = ImVec2:new({x = 0, y = 0}) end
        if type(border) ~= "boolean" then border = false end
        if type(flags) ~= "number" then flags = 0 end

        return lib.BeginChild(text, size, border, flags)
    end,
    EndChild = lib.EndChild,
    BeginMenu = lib.BeginMenu,
    EndMenu = lib.EndMenu,
    BeginMenuBar = lib.BeginMenuBar,
    EndMenuBar = lib.EndMenuBar,
    BeginMainMenuBar = lib.BeginMainMenuBar,
    EndMainMenuBar = lib.EndMainMenuBar,
    BeginPopupContextWindow = lib.BeginPopupContextWindow,
    BeginPopupContextItem = lib.BeginPopupContextItem,
    EndPopup = lib.EndPopup,
    BeginCombo = lib.BeginCombo,
    EndCombo = lib.EndCombo,

    GetID = lib.GetID,

    PushStyleColor = lib.PushStyleColor,
    PopStyleColor = function(count:int?) return lib.PopStyleColor(count or 1) end,
    PushStyleVarFloat = lib.PushStyleVarFloat,
    PushStyleVarVec2 = lib.PushStyleVarVec2,
    PopStyleVar = function(count:int?) return lib.PopStyleVar(count or 1) end,
    PushID = lib.PushID,
    PopID = lib.PopID,

    Text = lib.Text,
    TextLinkOpenURL = lib.TextLinkOpenURL,
    TextColored = lib.TextColored,
    TextUnformatted = lib.TextUnformatted,
    TextDisabled = lib.TextDisabled,
    TextWrapped = lib.TextWrapped,
    LabelText = lib.LabelText,
    BulletText = lib.BulletText,

    DragFloat = lib.DragFloat,
    DragInt = lib.DragInt,
    SliderFloat = lib.SliderFloat,
    SliderInt = lib.SliderInt,
    InputFloat = lib.InputFloat,
    InputInt = lib.InputInt,
    InputText = lib.InputText,
    InputTextMultiline = lib.InputTextMultiline,

    Separator = lib.Separator,
    SameLine = lib.SameLine,

    Button = function(label: cstring, size: vector?)
        if not size then size = vector.zero end

        local imvec = ImVec2:new({x = size.x, y = size.y})
        return lib.Button(label, imvec)
    end,
    SmallButton = lib.SmallButton,
    Checkbox = lib.Checkbox,
    RadioButton = lib.RadioButton,

    MenuItem = function(label:cstring, keybind: cstring?)
        return lib.MenuItem(label, keybind or "")
    end,

    Selectable = lib.Selectable,

    TreeNode = lib.TreeNode,
    TreeNodeEx = lib.TreeNodeEx,
    TreePop = lib.TreePop,

    BeginTabBar = lib.BeginTabBar,
    EndTabBar = lib.EndTabBar,
    BeginTabItem = lib.BeginTabItem,
    EndTabItem = lib.EndTabItem,

    GetWindowSize = lib.GetWindowSize,
    GetContentRegionAvail = lib.GetContentRegionAvail,
    GetViewportSize = lib.GetViewportSize,
    GetCursorScreenPos = lib.GetCursorScreenPos,
    CalcTextSize = lib.CalcTextSize,
    SetCursorPosX = lib.SetCursorPosX,
    SetCursorPosY = lib.SetCursorPosY,
    SetNextWindowSize = lib.SetNextWindowSize,
    SetNextItemOpen = lib.SetNextItemOpen,

    IsAnyItemFocused = lib.IsAnyItemFocused,
    IsItemHovered = function(flag: number?) 
        if not flag then flag = 0 end
        return lib.IsItemHovered(flag)
    end,
    IsItemClicked = lib.IsItemClicked,
    IsMouseDoubleClicked = lib.IsMouseDoubleClicked,
    IsItemToggledSelection = lib.IsItemToggledSelection,
    IsItemToggledOpen = lib.IsItemToggledOpen,
    IsItemDeactivatedAfterEdit = lib.IsItemDeactivatedAfterEdit,
    IsAnyItemHovered = lib.IsAnyItemHovered,
    IsAnyItemActive = lib.IsAnyItemFocused,
    IsWindowFocused = lib.igIsWindowFocused,
    IsWindowHovered = lib.IsWindowHovered,

    Image = lib.igImage,

    GetScrollY = lib.GetScrollY,
    GetScrollMaxY = lib.GetScrollMaxY,
    SetScrollHereY = lib.SetScrollHereY,
    
    SetTooltip = lib.SetTooltip,
    BeginTooltip = lib.BeginTooltip,
    EndTooltip = lib.EndTooltip,

    DockSpaceOverViewport = lib.DockSpaceOverViewport,
    DockBuilderGetNode = lib.DockBuilderGetNode,
    DockBuilderAddNode = lib.DockBuilderAddNode,
    DockBuilderSetNodeSize = lib.DockBuilderSetNodeSize,
    DockBuilderSplitNode = lib.DockBuilderSplitNode,
    DockBuilderDockWindow = lib.DockBuilderDockWindow,
    DockBuilderFinish = lib.DockBuilderFinish,

    TextEditorCreate = lib.TextEditorCreate,
    TextEditorGetText = lib.TextEditorGetText,
    TextEditorGetLength = lib.TextEditorGetLength,
    TextEditorSetText = lib.TextEditorSetText,
    TextEditorDraw = lib.TextEditorDraw,
    TextEditorDestroy = lib.TextEditorDestroy,

    SetStyleRounding = lib.SetStyleRounding,
    SetStyleColor = lib.SetStyleColor,
    GetStyleColor = lib.GetStyleColor,
    SetStyleDark = lib.SetStyleDark,
    SetStyleLight = lib.SetStyleLight,
    SetStyleVisualStudioDarkBlue = lib.SetStyleVisualStudioDarkBlue,
    SetStyleClassicSteamVGUI = lib.SetStyleClassicSteamVGUI,

    NewImVec2 = function(x, y)
        return ImVec2:new({x=x, y=y})
    end,
    NewImVec3 = function(x, y, z)
        return ImVec3:new({x=x, y=y, z=z})
    end,
    NewImVec4 = function(x, y, z, w)
        return ImVec4:new({x=x, y=y, z=z, w=w})
    end,

    FromImVec2 = function(imvec):vector
        return vector.create(
            buffer.readf32(imvec, 0),
            buffer.readf32(imvec, 4)
        )
    end,
    FromImVec3 = function(imvec):vector
        return vector.create(
            imvec:readf32(0),
            imvec:readf32(4),
            imvec:readf32(8)
        )
    end,
    FromImVec4 = function(imvec): {x: number, y: number, z: number, w: number}
        return {
            x = buffer.readf32(imvec, 0),
            y = buffer.readf32(imvec, 4),
            z = buffer.readf32(imvec, 8),
            w = buffer.readf32(imvec, 12)
        }
    end,
}