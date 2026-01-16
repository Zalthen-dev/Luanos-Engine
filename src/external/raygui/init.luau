local platform = zune.platform
local ffi = zune.ffi

-- ===============================
-- C primitive types
-- ===============================
local void    = ffi.types.void
local int     = ffi.types.i32
local uint    = ffi.types.u32
local bool    = ffi.types.u8
local float   = ffi.types.float
local pointer = ffi.types.pointer
local cstring = ffi.types.pointer

type int = number
type uint = number
type bool = number
type float = number
type long = buffer
type double = number
type uint16 = number
type cstring = string | buffer | FFIPointer

local RayRectangle = ffi.struct({
    { x = float },
    { y = float },
    { width = float },
    { height = float },
})
type RayRectangle = typeof(RayRectangle:new({}))

local RayVector2 = ffi.struct({
    {x = float},
    {y = float}
})
type RayVector2 = typeof(RayVector2:new({}))

local RayColor = ffi.struct({
    {r = ffi.types.u8},
    {g = ffi.types.u8},
    {b = ffi.types.u8},
    {a = ffi.types.u8}
})
type RayColor = typeof(RayColor:new({}))

-- ===============================
-- Helper
-- ===============================
local function fn(returns: any, args: { any })
    return { returns = returns, args = args }
end

-- ===============================
-- Library location
-- ===============================
local libLocation = "./src/external/raygui/bin/raygui.so"

if platform.cpu.arch == "x86_64" then
    if platform.os == "windows" then
        libLocation = "./src/external/raygui/bin/raygui.dll"
    elseif platform.os == "linux" then
        libLocation = "./src/external/raygui/bin/raygui.so"
    end
end

-- ===============================
-- Function type map
-- ===============================
type Fns = {
    -- Global state
    GuiEnable: () -> (),
    GuiDisable: () -> (),
    GuiLock: () -> (),
    GuiUnlock: () -> (),
    GuiIsLocked: () -> bool,

    GuiSetAlpha: (alpha: float) -> (),
    GuiSetState: (state: int) -> (),
    GuiGetState: () -> int,

    -- Styles
    GuiSetStyle: (control: int, property: int, value: int) -> (),
    GuiGetStyle: (control: int, property: int) -> int,

    -- Containers
    GuiWindowBox: (bounds: RayRectangle, title: cstring) -> bool,
    GuiGroupBox: (bounds: RayRectangle, text: cstring) -> (),
    GuiLine: (bounds: RayRectangle, text: cstring) -> (),
    GuiPanel: (bounds: RayRectangle, text: cstring) -> (),
    GuiScrollPanel: (
        bounds: RayRectangle,
        text: cstring,
        content: any,
        scroll: FFIPointer,
        view: FFIPointer
    ) -> (),

    -- Basic controls
    GuiLabel: (bounds: RayRectangle, text: cstring) -> (),
    GuiButton: (bounds: RayRectangle, text: cstring) -> bool,
    GuiLabelButton: (bounds: RayRectangle, text: cstring) -> bool,
    GuiToggle: (bounds: RayRectangle, text: cstring, active: bool) -> bool,
    GuiToggleGroup: (bounds: RayRectangle, text: cstring, active: int) -> int,
    GuiCheckBox: (bounds: RayRectangle, text: cstring, checked: FFIPointer) -> bool,
    GuiComboBox: (bounds: RayRectangle, text: cstring, active: FFIPointer) -> int,
    GuiDropdownBox: (
        bounds: RayRectangle,
        text: cstring,
        active: FFIPointer,
        editMode: bool
    ) -> bool,

    -- Sliders / progress
    GuiSlider: (
        bounds: RayRectangle,
        textLeft: cstring,
        textRight: cstring,
        value: FFIPointer,
        minValue: float,
        maxValue: float
    ) -> float,

    GuiSliderBar: (
        bounds: RayRectangle,
        textLeft: cstring,
        textRight: cstring,
        value: FFIPointer,
        minValue: float,
        maxValue: float
    ) -> float,

    GuiProgressBar: (
        bounds: RayRectangle,
        textLeft: cstring,
        textRight: cstring,
        value: FFIPointer,
        minValue: float,
        maxValue: float
    ) -> float,

    GuiSpinner: (
        bounds: RayRectangle,
        text: cstring,
        value: FFIPointer,
        minValue: int,
        maxValue: int,
        editMode: bool
    ) -> bool,

    GuiValueBox: (
        bounds: RayRectangle,
        text: cstring,
        value: FFIPointer,
        minValue: int,
        maxValue: int,
        editMode: bool
    ) -> bool,

    -- Text input
    GuiTextBox: (
        bounds: RayRectangle,
        text: cstring,
        textSize: int,
        editMode: bool
    ) -> bool,

    -- Lists
    GuiListView: (
        bounds: RayRectangle,
        text: cstring,
        scrollIndex: FFIPointer,
        active: FFIPointer
    ) -> int,

    GuiListViewEx: (
        bounds: RayRectangle,
        text: FFIPointer,
        count: int,
        scrollIndex: FFIPointer,
        active: FFIPointer,
        focus: FFIPointer
    ) -> int,

    -- Color / image
    GuiColorPicker: (bounds: RayRectangle, text: cstring, color: FFIPointer) -> bool,
    GuiColorPanel: (bounds: RayRectangle, text: cstring, color: FFIPointer) -> any,
    GuiColorBarAlpha: (bounds: RayRectangle, text: cstring, alpha: FFIPointer) -> float,
    GuiColorBarHue: (bounds: RayRectangle, text: cstring, value: FFIPointer) -> float,

    -- Icons
    GuiIconText: (iconId: int, text: cstring) -> cstring,
    GuiSetIconScale: (scale: int) -> (),

    -- Tooltips & status
    GuiStatusBar: (bounds: RayRectangle, text: cstring) -> (),
    GuiDummyRec: (bounds: RayRectangle, text: cstring) -> (),

    -- Popups
    GuiMessageBox: (
        bounds: RayRectangle,
        title: cstring,
        message: cstring,
        buttons: cstring
    ) -> int,

    GuiTextInputBox: (
        bounds: RayRectangle,
        title: cstring,
        message: cstring,
        buttons: cstring,
        text: cstring,
        textMaxSize: int,
        secretViewActive: FFIPointer
    ) -> int,

    -- Font
    GuiLoadStyle: (fileName: cstring) -> (),
    GuiLoadStyleDefault: () -> (),
}

-- ===============================
-- Definitions (C ABI)
-- ===============================
local defs = {
    GuiEnable  = fn(void, {}),
    GuiDisable = fn(void, {}),
    GuiLock    = fn(void, {}),
    GuiUnlock  = fn(void, {}),
    GuiIsLocked = fn(bool, {}),

    GuiSetAlpha = fn(void, { float }),
    GuiSetState = fn(void, { int }),
    GuiGetState = fn(int, {}),

    GuiSetStyle = fn(void, { int, int, int }),
    GuiGetStyle = fn(int, { int, int }),

    GuiWindowBox = fn(bool, { pointer, cstring }),
    GuiGroupBox  = fn(void, { pointer, cstring }),
    GuiLine      = fn(void, { pointer, cstring }),
    GuiPanel     = fn(void, { pointer, cstring }),
    GuiScrollPanel = fn(void, { pointer, cstring, pointer, pointer, pointer }),

    GuiLabel        = fn(void, { pointer, cstring }),
    GuiButton       = fn(bool, { pointer, cstring }),
    GuiLabelButton  = fn(bool, { pointer, cstring }),
    GuiToggle       = fn(bool, { pointer, cstring, bool }),
    GuiToggleGroup  = fn(int, { pointer, cstring, int }),
    GuiCheckBox     = fn(bool, { pointer, cstring, pointer }),
    GuiComboBox     = fn(int, { pointer, cstring, pointer }),
    GuiDropdownBox  = fn(bool, { pointer, cstring, pointer, bool }),

    GuiSlider       = fn(float, { pointer, cstring, cstring, pointer, float, float }),
    GuiSliderBar    = fn(float, { pointer, cstring, cstring, pointer, float, float }),
    GuiProgressBar  = fn(float, { pointer, cstring, cstring, pointer, float, float }),

    GuiSpinner  = fn(bool, { pointer, cstring, pointer, int, int, bool }),
    GuiValueBox = fn(bool, { pointer, cstring, pointer, int, int, bool }),

    GuiTextBox      = fn(bool, { pointer, cstring, int, bool }),

    GuiListView   = fn(int, { pointer, cstring, pointer, pointer }),
    GuiListViewEx = fn(int, { pointer, pointer, int, pointer, pointer, pointer }),

    GuiColorPicker   = fn(bool, { pointer, cstring, pointer }),
    GuiColorPanel    = fn(pointer, { pointer, cstring, pointer }),
    GuiColorBarAlpha = fn(float, { pointer, cstring, pointer }),
    GuiColorBarHue   = fn(float, { pointer, cstring, pointer }),

    GuiIconText     = fn(cstring, { int, cstring }),
    GuiSetIconScale = fn(void, { int }),

    GuiStatusBar = fn(void, { pointer, cstring }),
    GuiDummyRec  = fn(void, { pointer, cstring }),

    GuiMessageBox = fn(int, { pointer, cstring, cstring, cstring }),
    GuiTextInputBox = fn(
        int,
        { pointer, cstring, cstring, cstring, cstring, int, pointer }
    ),

    GuiLoadStyle        = fn(void, { cstring }),
    GuiLoadStyleDefault = fn(void, {}),
}

-- ===============================
-- Load library
-- ===============================
local lib = ffi.dlopen(libLocation, defs) :: {
    GetSymbol: (self: FFILibrary, symbol: string) -> FFIPointer?,
} & Fns

return {
    NewVector2 = function(x: number,y: number)
        return RayVector2:new({x=x,y=y})
    end,
    NewRectangle = function(x:number,y:number,width:number,height:number)
        return RayRectangle:new({x=x,y=y,width=width,height=height})
    end,
    NewColor = function(r:number,g:number,b:number,a:number)
        return RayColor:new({r=r,g=g,b=b,a=a})
    end,
    GuiEnable           = lib.GuiEnable,
    GuiDisable          = lib.GuiDisable,
    GuiLock             = lib.GuiLock,
    GuiUnlock           = lib.GuiUnlock,
    GuiIsLocked         = lib.GuiIsLocked,

    GuiSetAlpha         = lib.GuiSetAlpha,
    GuiSetState         = lib.GuiSetState,
    GuiGetState         = lib.GuiGetState,

    GuiSetStyle         = lib.GuiSetStyle,
    GuiGetStyle         = lib.GuiGetStyle,

    GuiWindowBox        = lib.GuiWindowBox,
    GuiGroupBox         = lib.GuiGroupBox,
    GuiLine             = lib.GuiLine,
    GuiPanel            = lib.GuiPanel,
    GuiScrollPanel      = lib.GuiScrollPanel,

    GuiLabel            = lib.GuiLabel,
    GuiButton           = lib.GuiButton,
    GuiLabelButton      = lib.GuiLabelButton,
    GuiToggle           = lib.GuiToggle,
    GuiToggleGroup      = lib.GuiToggleGroup,
    GuiCheckBox         = lib.GuiCheckBox,
    GuiComboBox         = lib.GuiComboBox,
    GuiDropdownBox      = lib.GuiDropdownBox,

    GuiSlider           = lib.GuiSlider,
    GuiSliderBar        = lib.GuiSliderBar,
    GuiProgressBar      = lib.GuiProgressBar,

    GuiSpinner          = lib.GuiSpinner,
    GuiValueBox         = lib.GuiValueBox,

    GuiTextBox          = lib.GuiTextBox,

    GuiListView         = lib.GuiListView,
    GuiListViewEx       = lib.GuiListViewEx,

    GuiColorPicker      = lib.GuiColorPicker,
    GuiColorPanel       = lib.GuiColorPanel,
    GuiColorBarAlpha    = lib.GuiColorBarAlpha,
    GuiColorBarHue      = lib.GuiColorBarHue,

    GuiIconText         = lib.GuiIconText,
    GuiSetIconScale     = lib.GuiSetIconScale,

    GuiStatusBar        = lib.GuiStatusBar,
    GuiDummyRec         = lib.GuiDummyRec,

    GuiMessageBox       = lib.GuiMessageBox,
    GuiTextInputBox     = lib.GuiTextInputBox,

    GuiLoadStyle        = lib.GuiLoadStyle,
    GuiLoadStyleDefault = lib.GuiLoadStyleDefault,
}