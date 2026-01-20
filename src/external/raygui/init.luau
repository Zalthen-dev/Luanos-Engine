local rl = require("@raylib")

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

-- ===============================
-- Helper
-- ===============================
local function fn(returns: any, args: { any })
    return { returns = returns, args = args }
end

-- ===============================
-- Library location
-- ===============================
local libLocation = "./vendor/libEngineLib.so"

if platform.cpu.arch == "x86_64" then
    if platform.os == "windows" then
        libLocation = "./vendor/libEngineLib.dll"
    elseif platform.os == "linux" then
        libLocation = "./vendor/libEngineLib.so"
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
    GuiWindowBox: (bounds: rl.Rectangle, title: cstring) -> bool,
    GuiGroupBox: (bounds: rl.Rectangle, text: cstring) -> (),
    GuiLine: (bounds: rl.Rectangle, text: cstring) -> (),
    GuiPanel: (bounds: rl.Rectangle, text: cstring) -> (),
    GuiScrollPanel: (
        bounds: rl.Rectangle,
        text: cstring,
        content: any,
        scroll: FFIPointer,
        view: FFIPointer
    ) -> (),

    -- Basic controls
    GuiLabel: (bounds: rl.Rectangle, text: cstring) -> (),
    GuiButton: (bounds: rl.Rectangle, text: cstring) -> bool,
    GuiLabelButton: (bounds: rl.Rectangle, text: cstring) -> bool,
    GuiToggle: (bounds: rl.Rectangle, text: cstring, active: bool) -> bool,
    GuiToggleGroup: (bounds: rl.Rectangle, text: cstring, active: int) -> int,
    GuiCheckBox: (bounds: rl.Rectangle, text: cstring, checked: FFIPointer) -> bool,
    GuiComboBox: (bounds: rl.Rectangle, text: cstring, active: FFIPointer) -> int,
    GuiDropdownBox: (
        bounds: rl.Rectangle,
        text: cstring,
        active: FFIPointer,
        editMode: bool
    ) -> bool,

    -- Sliders / progress
    GuiSlider: (
        bounds: rl.Rectangle,
        textLeft: cstring,
        textRight: cstring,
        value: FFIPointer,
        minValue: float,
        maxValue: float
    ) -> float,

    GuiSliderBar: (
        bounds: rl.Rectangle,
        textLeft: cstring,
        textRight: cstring,
        value: FFIPointer,
        minValue: float,
        maxValue: float
    ) -> float,

    GuiProgressBar: (
        bounds: rl.Rectangle,
        textLeft: cstring,
        textRight: cstring,
        value: FFIPointer,
        minValue: float,
        maxValue: float
    ) -> float,

    GuiSpinner: (
        bounds: rl.Rectangle,
        text: cstring,
        value: FFIPointer,
        minValue: int,
        maxValue: int,
        editMode: bool
    ) -> bool,

    GuiValueBox: (
        bounds: rl.Rectangle,
        text: cstring,
        value: FFIPointer,
        minValue: int,
        maxValue: int,
        editMode: bool
    ) -> bool,

    -- Text input
    GuiTextBox: (
        bounds: rl.Rectangle,
        text: cstring,
        textSize: int,
        editMode: bool
    ) -> bool,

    -- Lists
    GuiListView: (
        bounds: rl.Rectangle,
        text: cstring,
        scrollIndex: FFIPointer,
        active: FFIPointer
    ) -> int,

    GuiListViewEx: (
        bounds: rl.Rectangle,
        text: FFIPointer,
        count: int,
        scrollIndex: FFIPointer,
        active: FFIPointer,
        focus: FFIPointer
    ) -> int,

    -- Color / image
    GuiColorPicker: (bounds: rl.Rectangle, text: cstring, color: FFIPointer) -> bool,
    GuiColorPanel: (bounds: rl.Rectangle, text: cstring, color: FFIPointer) -> any,
    GuiColorBarAlpha: (bounds: rl.Rectangle, text: cstring, alpha: FFIPointer) -> float,
    GuiColorBarHue: (bounds: rl.Rectangle, text: cstring, value: FFIPointer) -> float,

    -- Icons
    GuiIconText: (iconId: int, text: cstring) -> cstring,
    GuiSetIconScale: (scale: int) -> (),

    -- Tooltips & status
    GuiStatusBar: (bounds: rl.Rectangle, text: cstring) -> (),
    GuiDummyRec: (bounds: rl.Rectangle, text: cstring) -> (),

    -- Popups
    GuiMessageBox: (
        bounds: rl.Rectangle,
        title: cstring,
        message: cstring,
        buttons: cstring
    ) -> int,

    GuiTextInputBox: (
        bounds: rl.Rectangle,
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

    GuiWindowBox = fn(bool, { rl.Rectangle, cstring }),
    GuiGroupBox  = fn(void, { rl.Rectangle, cstring }),
    GuiLine      = fn(void, { rl.Rectangle, cstring }),
    GuiPanel     = fn(void, { rl.Rectangle, cstring }),
    GuiScrollPanel = fn(void, { rl.Rectangle, cstring, rl.Rectangle, pointer, pointer }),

    GuiLabel        = fn(void, { rl.Rectangle, cstring }),
    GuiButton       = fn(bool, { rl.Rectangle, cstring }),
    GuiLabelButton  = fn(bool, { rl.Rectangle, cstring }),
    GuiToggle       = fn(bool, { rl.Rectangle, cstring, bool }),
    GuiToggleGroup  = fn(int, { rl.Rectangle, cstring, int }),
    GuiCheckBox     = fn(bool, { rl.Rectangle, cstring, pointer }),
    GuiComboBox     = fn(int, { rl.Rectangle, cstring, pointer }),
    GuiDropdownBox  = fn(bool, { rl.Rectangle, cstring, pointer, bool }),

    GuiSlider       = fn(float, { rl.Rectangle, cstring, cstring, pointer, float, float }),
    GuiSliderBar    = fn(float, { rl.Rectangle, cstring, cstring, pointer, float, float }),
    GuiProgressBar  = fn(float, { rl.Rectangle, cstring, cstring, pointer, float, float }),

    GuiSpinner  = fn(bool, { rl.Rectangle, cstring, pointer, int, int, bool }),
    GuiValueBox = fn(bool, { rl.Rectangle, cstring, pointer, int, int, bool }),

    GuiTextBox      = fn(bool, { rl.Rectangle, cstring, int, bool }),

    GuiListView   = fn(int, { rl.Rectangle, cstring, pointer, pointer }),
    GuiListViewEx = fn(int, { rl.Rectangle, pointer, int, pointer, pointer, pointer }),

    GuiColorPicker   = fn(bool, { rl.Rectangle, cstring, pointer }),
    GuiColorPanel    = fn(pointer, { rl.Rectangle, cstring, pointer }),
    GuiColorBarAlpha = fn(float, { rl.Rectangle, cstring, pointer }),
    GuiColorBarHue   = fn(float, { rl.Rectangle, cstring, pointer }),

    GuiIconText     = fn(cstring, { int, cstring }),
    GuiSetIconScale = fn(void, { int }),

    GuiStatusBar = fn(void, { rl.Rectangle, cstring }),
    GuiDummyRec  = fn(void, { rl.Rectangle, cstring }),

    GuiMessageBox = fn(int, { rl.Rectangle, cstring, cstring, cstring }),
    GuiTextInputBox = fn(
        int,
        { rl.Rectangle, cstring, cstring, cstring, cstring, int, pointer }
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
    NewRectangle = function(x:number,y:number,width:number,height:number)
        return rl.Rectangle:new({x=x,y=y,width=width,height=height})
    end,
    NewColor = function(r:number,g:number,b:number,a:number)
        return rl.Color:new({r=r,g=g,b=b,a=a})
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