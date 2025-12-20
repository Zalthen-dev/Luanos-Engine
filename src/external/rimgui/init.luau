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
    

    rImGui_ShowDemoWindow: () -> (),

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

    InputFloat: (label:cstring, value:FFIPointer, step:float, stepFast:float, format:cstring, flags:int) -> (bool),
    InputInt: (label:cstring, value:FFIPointer, step:int, stepFast:int, flags:int) -> (bool),
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

    GetStyleColor: (int) -> (ImVec4),
    GetWindowSize: () -> (ImVec2),
    GetContentRegionAvail: () -> (ImVec2),
    GetViewportSize: (FFIPointer) -> (ImVec2),
    GetCursorScreenPos: () -> (ImVec2),
    CalcTextSize: (cstring) -> (ImVec2),
    SetCursorPosX: (int) -> (),
    SetCursorPosY: (int) -> (),
    SetNextWindowSize: (ImVec2, int) -> (),

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

    igImage: (uint, float, float) -> (),

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

    SetStyleDark: () -> (),
    SetStyleLight: () -> (),
    SetStyleVisualStudioDarkBlue: () -> (),
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

    rImGui_ShowDemoWindow = fn(void, {}),

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

    InputFloat = fn(bool, {cstring, pointer, float, float, cstring, int}),
    InputInt = fn(bool, {cstring, pointer, int, int, int}),
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
    
    GetStyleColor = fn(ImVec4, {int}),
    GetWindowSize = fn(ImVec2, {}),
    GetContentRegionAvail = fn(ImVec2, {}),
    GetViewportSize = fn(ImVec2, {pointer}),
    GetCursorScreenPos = fn(ImVec2, {}),
    CalcTextSize = fn(ImVec2, {cstring}),
    SetCursorPosX = fn(void, {int}),
    SetCursorPosY = fn(void, {int}),
    SetNextWindowSize = fn(void, {ImVec2, int}),

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

    igImage = fn(void, {}),

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

    SetStyleDark = fn(void, {}),
    SetStyleLight = fn(void, {}),
    SetStyleVisualStudioDarkBlue = fn(void, {}),
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
    IMGUI_WINDOWFLAGS_NO_TITLE_BAR                = bit32.lshift(1, 0),
    IMGUI_WINDOWFLAGS_NO_RESIZE                   = bit32.lshift(1, 1),
    IMGUI_WINDOWFLAGS_NO_MOVE                     = bit32.lshift(1, 2),
    IMGUI_WINDOWFLAGS_NO_SCROLLBAR                = bit32.lshift(1, 3),
    IMGUI_WINDOWFLAGS_NO_SCROLL_WITH_MOUSE        = bit32.lshift(1, 4),
    IMGUI_WINDOWFLAGS_NO_COLLAPSE                 = bit32.lshift(1, 5),
    IMGUI_WINDOWFLAGS_ALWAYS_AUTO_RESIZE          = bit32.lshift(1, 6),
    IMGUI_WINDOWFLAGS_NO_BACKGROUND               = bit32.lshift(1, 7),
    IMGUI_WINDOWFLAGS_NO_SAVED_SETTINGS           = bit32.lshift(1, 8),
    IMGUI_WINDOWFLAGS_MENU_BAR                    = bit32.lshift(1, 10),
    IMGUI_WINDOWFLAGS_NO_MOUSE_INPUTS             = bit32.lshift(1, 10),
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
    IMGUI_WINDOWFLAGS_NO_NAV                      = bit32.lshift(1, 21),

    IMGUI_COND_NONE             = 0,
    IMGUI_COND_ALWAYS           = 1,
    IMGUI_COND_ONCE             = 2,
    IMGUI_COND_FIRST_USE_EVER   = 4,
    IMGUI_COND_APPEARING        = 8,

    IMGUI_COL_TEXT                  = 0,
    IMGUI_COL_TEXTDISABLED          = 1,
    IMGUI_COL_WINDOWBG              = 2,
    IMGUI_COL_CHILDBG               = 3,
    IMGUI_COL_POPUPBG               = 4,
    IMGUI_COL_BORDER                = 5,
    IMGUI_COL_BORDERSHADOW          = 6,
    IMGUI_COL_FRAMEBG               = 7,
    IMGUI_COL_FRAMEBGHOVERED        = 8,
    IMGUI_COL_FRAMEBGACTIVE         = 9,
    IMGUI_COL_TITLEBG               = 10,
    IMGUI_COL_TITLEBGACTIVE         = 11,
    IMGUI_COL_TITLEBGCOLLAPSED      = 12,
    IMGUI_COL_MENUBARBG             = 13,
    IMGUI_COL_SCROLLBARBG           = 14,
    IMGUI_COL_SCROLLBARGRAB         = 15,
    IMGUI_COL_SCROLLBARGRABHOVERED  = 16,
    IMGUI_COL_SCROLLBARGRABACTIVE   = 17,
    IMGUI_COL_CHECKMARK             = 18,
    IMGUI_COL_SLIDERGRAB            = 19,
    IMGUI_COL_SLIDERGRABACTIVE      = 20,
    IMGUI_COL_BUTTON                = 21,
    IMGUI_COL_BUTTONHOVERED         = 22,
    IMGUI_COL_BUTTONACTIVE          = 23,
    IMGUI_COL_HEADER                = 24,
    IMGUI_COL_HEADERHOVERED         = 25,
    IMGUI_COL_HEADERACTIVE          = 26,
    IMGUI_COL_SEPARATOR             = 27,
    IMGUI_COL_SEPARATORHOVERED      = 28,
    IMGUI_COL_SEPARATORACTIVE       = 29,
    IMGUI_COL_RESIZEGRIP            = 30,
    IMGUI_COL_RESIZEGRIPHOVERED     = 31,
    IMGUI_COL_RESIZEGRIPACTIVE      = 32,
    IMGUI_COL_TAB                   = 33,
    IMGUI_COL_TABHOVERED            = 34,
    IMGUI_COL_TABACTIVE             = 35,
    IMGUI_COL_TABUNFOCUSED          = 36,
    IMGUI_COL_TABUNFOCUSEDACTIVE    = 37,
    IMGUI_COL_PLOTLINES             = 38,
    IMGUI_COL_PLOTLINESHOVERED      = 39,
    IMGUI_COL_PLOTHISTOGRAM         = 40,
    IMGUI_COL_PLOTHISTOGRAMHOVERED  = 41,
    IMGUI_COL_TABLEHEADERBG         = 42,
    IMGUI_COL_TABLEBORDERSTRONG     = 43,
    IMGUI_COL_TABLEBORDERLIGHT      = 44,
    IMGUI_COL_TABLEROWBG            = 45,
    IMGUI_COL_TABLEROWBGALT         = 46,
    IMGUI_COL_TEXTSELECTEDBG        = 47,
    IMGUI_COL_DRAGDROPTARGET        = 48,
    IMGUI_COL_NAVHIGHLIGHT          = 49,
    IMGUI_COL_NAVWINDOWINGHIGHLIGHT = 50,
    IMGUI_COL_NAVWINDOWDIMBG        = 51,
    IMGUI_COL_MODALWINDOWDIMBG      = 52,

    IMGUI_INPUTTEXTFLAGS_NONE                   = 0,
    IMGUI_INPUTTEXTFLAGS_CHARS_DECIMAL          = 1,
    IMGUI_INPUTTEXTFLAGS_CHARS_HEXADECIMAL      = 2,
    IMGUI_INPUTTEXTFLAGS_CHARS_SCIENTIFIC       = 4,
    IMGUI_INPUTTEXTFLAGS_CHARS_UPPERCASE        = 8,
    IMGUI_INPUTTEXTFLAGS_CHARS_NOBLANK          = 16,
    IMGUI_INPUTTEXTFLAGS_ALLOW_TAB_INPUT        = 32,
    IMGUI_INPUTTEXTFLAGS_ENTER_RETURNS_TRUE     = 64,
    IMGUI_INPUTTEXTFLAGS_ESCAPE_CLEARS_ALL      = 128,
    IMGUI_INPUTTEXTFLAGS_CTRL_ENTER_NEWLINE     = 256,
    IMGUI_INPUTTEXTFLAGS_READONLY               = 512,
    IMGUI_INPUTTEXTFLAGS_PASSWORD               = 1024,
    IMGUI_INPUTTEXTFLAGS_ALWAYS_OVERWRITE       = 2048,
    IMGUI_INPUTTEXTFLAGS_AUTO_SELECT_ALL        = 4096,
    IMGUI_INPUTTEXTFLAGS_PARSE_EMPTY_REFVAL     = 8192,
    IMGUI_INPUTTEXTFLAGS_DISPLAY_EMPTY_REFVAL   = 16384,
    IMGUI_INPUTTEXTFLAGS_NO_HORIZONTAL_SCROLL   = 32768,
    IMGUI_INPUTTEXTFLAGS_NO_UNDO_REDO           = 65536,
    IMGUI_INPUTTEXTFLAGS_ELIDE_LEFT             = 131072,
    IMGUI_INPUTTEXTFLAGS_CALLBACK_COMPLETION    = 262144,
    IMGUI_INPUTTEXTFLAGS_CALLBACK_HISTORY       = 524288,
    IMGUI_INPUTTEXTFLAGS_CALLBACK_ALWAYS        = 1048576,
    IMGUI_INPUTTEXTFLAGS_CALLBACK_CHARFILTER    = 2097152,
    IMGUI_INPUTTEXTFLAGS_CALLBACK_RESIZE        = 4194304,
    IMGUI_INPUTTEXTFLAGS_CALLBACK_EDIT          = 8388608,
    IMGUI_INPUTTEXTFLAGS_WORDWRAP               = 16777216,
    IMGUI_INPUTTEXTFLAGS_MULTILINE              = 67108864,

    IMGUI_DOCKNODEFLAGS_NONE                  = 0,
    IMGUI_DOCKNODEFLAGS_KEEP_ALIVE_ONLY       = bit32.lshift(1, 0),
    IMGUI_DOCKNODEFLAGS_NO_DOCKING_IN_CENTRAL_NODE = bit32.lshift(1, 2),
    IMGUI_DOCKNODEFLAGS_PASSTHRU_CENTRAL_NODE = bit32.lshift(1, 3), -- Useful for transparent backgrounds
    IMGUI_DOCKNODEFLAGS_NO_SPLIT              = bit32.lshift(1, 4),
    IMGUI_DOCKNODEFLAGS_NO_RESIZE             = bit32.lshift(1, 5),
    IMGUI_DOCKNODEFLAGS_AUTO_HIDE_TAB_BAR     = bit32.lshift(1, 6),
    IMGUI_DOCKNODEFLAGS_NO_UNDOCKING          = bit32.lshift(1, 7),
    IMGUI_DOCKNODEFLAGS_NO_DOCKING_SPLIT_ME   = bit32.lshift(1, 8),
    IMGUI_DOCKNODEFLAGS_NO_DOCKING_OVER_ME    = bit32.lshift(1, 9),
    IMGUI_DOCKNODEFLAGS_NO_DOCKING_OVER_OTHER = bit32.lshift(1, 10),
    IMGUI_DOCKNODEFLAGS_NO_DOCKING_OVER_EMPTY = bit32.lshift(1, 11),
    IMGUI_DOCKNODEFLAGS_DOCK_SPACE            = bit32.lshift(1, 10),
    IMGUI_DOCKNODEFLAGS_CENTRAL_NODE          = bit32.lshift(1, 11),
    IMGUI_DOCKNODEFLAGS_NO_TAB_BAR            = bit32.lshift(1, 12),
    IMGUI_DOCKNODEFLAGS_HIDDEN_TAB_BAR        = bit32.lshift(1, 13),
    IMGUI_DOCKNODEFLAGS_NO_WINDOW_MENU_BUTTON = bit32.lshift(1, 14),
    IMGUI_DOCKNODEFLAGS_NO_CLOSE_BUTTON       = bit32.lshift(1, 15),
    IMGUI_DOCKNODEFLAGS_NO_RESIZE_X           = bit32.lshift(1, 16),
    IMGUI_DOCKNODEFLAGS_NO_RESIZE_Y           = bit32.lshift(1, 17),

    IMGUI_TREENODEFLAGS_SELECTED                = 1,
    IMGUI_TREENODEFLAGS_FRAMED                  = 2,
    IMGUI_TREENODEFLAGS_ALLOWOVERLAP            = 4,
    IMGUI_TREENODEFLAGS_NOTREEPUSHONOPEN        = 8,
    IMGUI_TREENODEFLAGS_NOAUTOOPENONLOG         = 16,
    IMGUI_TREENODEFLAGS_DEFAULTOPEN             = 32,
    IMGUI_TREENODEFLAGS_OPENONDOUBLECLICK       = 64,
    IMGUI_TREENODEFLAGS_OPENONARROW             = 128,
    IMGUI_TREENODEFLAGS_LEAF                    = 256,
    IMGUI_TREENODEFLAGS_FRAMEPADDING            = 1024,
    IMGUI_TREENODEFLAGS_SPANAVAILWIDTH          = 2048,
    IMGUI_TREENODEFLAGS_SPANFULLWIDTH           = 4096,
    IMGUI_TREENODEFLAGS_SPANTEXTWIDTH           = 8192,
    IMGUI_TREENODEFLAGS_SPANALLCOLUMNS          = 16384,
    IMGUI_TREENODEFLAGS_NAVLEFTJUMPSBACKHERE    = 32768,
    IMGUI_TREENODEFLAGS_COLLAPSINGHEADER        = 26,
    IMGUI_TREENODEFLAGS_ALL                     = 65535,

    IMGUI_TABBARFLAGS_NONE                          = 0,
    IMGUI_TABBARFLAGS_REORDERABLE                   = 1,
    IMGUI_TABBARFLAGS_AUTOSELECTNEWTABS             = 2,
    IMGUI_TABBARFLAGS_NOCLOSEWITHMIDDLEMOUSEBUTTON  = 4,
    IMGUI_TABBARFLAGS_NOTABLISTPOPUPBUTTON          = 8,
    IMGUI_TABBARFLAGS_NOTABLISTSCROLLINGBUTTONS     = 16,
    IMGUI_TABBARFLAGS_FITTINGPOLICYRESIZEDOWN       = 32,
    IMGUI_TABBARFLAGS_FITTINGPOLICYSCROLL           = 64,
    
    IMGUI_TABITEMFLAGS_NONE                         = 0,
    IMGUI_TABITEMFLAGS_UNSAVEDDOCUMENT              = 1,
    IMGUI_TABITEMFLAGS_SETSELECTED                  = 2,
    IMGUI_TABITEMFLAGS_NOCLOSEWITHMIDDLEMOUSEBUTTON = 4,
    IMGUI_TABITEMFLAGS_NOPUSHID                     = 8,
    IMGUI_TABITEMFLAGS_NOTOOLTIP                    = 16,
    IMGUI_TABITEMFLAGS_NOREORDER                    = 32,
    IMGUI_TABITEMFLAGS_LEADING                      = 64,
    IMGUI_TABITEMFLAGS_TRAILING                     = 128,
    IMGUI_TABITEMFLAGS_NOASSUMEDCLOSURE             = 256,

    IMGUI_SEPARATOR_NONE                     = bit32.lshift(1, 0),
    IMGUI_SEPARATOR_HORIZONTAL               = bit32.lshift(1, 0),
    IMGUI_SEPARATOR_VERTICAL                 = bit32.lshift(1, 1),
    IMGUI_SEPARATOR_SPAN_ALL_COLUMNS         = bit32.lshift(1, 2),

    IMGUI_COMBOFLAGS_NONE                    = 0,
    IMGUI_COMBOFLAGS_POPUP_ALIGN             = bit32.lshift(1, 0),
    IMGUI_COMBOFLAGS_HEIGHT_SMALL            = bit32.lshift(1, 1),
    IMGUI_COMBOFLAGS_HEIGHT_REGULAR          = bit32.lshift(1, 2),
    IMGUI_COMBOFLAGS_HEIGHT_LARGE            = bit32.lshift(1, 3),
    IMGUI_COMBOFLAGS_HEIGHT_LARGEST          = bit32.lshift(1, 4),
    IMGUI_COMBOFLAGS_NO_ARROW_BUTTON         = bit32.lshift(1, 5),
    IMGUI_COMBOFLAGS_NO_PREVIEW              = bit32.lshift(1, 6),
    IMGUI_COMBOFLAGS_WIDTH_FIT_PREVIEW       = bit32.lshift(1, 7),
    IMGUI_COMBOFLAGS_HEIGHT_MASK_            = bit32.bor(bit32.lshift(1, 1), bit32.lshift(1, 2), bit32.lshift(1, 3), bit32.lshift(1, 4)),

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
    rImGui_ShowDemoWindow = lib.rImGui_ShowDemoWindow,

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

    InputFloat = lib.InputFloat,
    InputInt = lib.InputInt,
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

    GetStyleColor = lib.GetStyleColor,
    GetWindowSize = lib.GetWindowSize,
    GetContentRegionAvail = lib.GetContentRegionAvail,
    GetViewportSize = lib.GetViewportSize,
    GetCursorScreenPos = lib.GetCursorScreenPos,
    CalcTextSize = lib.CalcTextSize,
    SetCursorPosX = lib.SetCursorPosX,
    SetCursorPosY = lib.SetCursorPosY,
    SetNextWindowSize = lib.SetNextWindowSize,

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

    SetStyleDark = lib.SetStyleDark,
    SetStyleLight = lib.SetStyleLight,
    SetStyleVisualStudioDarkBlue = lib.SetStyleVisualStudioDarkBlue,

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