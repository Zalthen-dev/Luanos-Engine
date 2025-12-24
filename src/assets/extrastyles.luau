local imgui = require("@rimgui")

--[[
use ColorRGB to specify a color
internally ImGui uses ImVec4's for color where its values range from 0 to 1

use imgui.SetStyleColor(idx, ImVec4) to set a color
]]

local function ColorRGB(r: number, g: number, b: number, a: number?)
    return imgui.ImVec4:new({x=r/255, y=g/255, z=b/255, w=(a or 255)/255})
end

local styles = {}
local function AddStyle(name: string, creator: string, url: string, callback: () -> ())
	table.insert(styles, {
		Name = name,
        Creator = creator,
        Url = url,
		Function = callback,
	})
end

AddStyle("Roblox Studio Dark", "Zalthen-dev", "https://github.com/Zalthen-dev/", function() 
    local textColor = ColorRGB(225, 225, 225)
    local textColorDisabled = ColorRGB(85, 85, 85)
    local selectedTextBgColor = ColorRGB(11, 90, 175)

    local checkmark = ColorRGB(247, 247, 248)

    local bgColor = ColorRGB(46, 46, 46)
    local lightBgColor = ColorRGB(53, 53, 53)
    local borderColor = ColorRGB(34, 34, 34)

    local panelColor = ColorRGB(53, 53, 53)
    local panelColorHovered = ColorRGB(66, 66, 66)
    local panelColorActive = ColorRGB(0, 162, 255)

    local scrollBarBgColor = ColorRGB(41, 41, 41)
    local scrollBarColor = ColorRGB(56, 56, 56)

    local buttonActiveColor = ColorRGB(28, 28, 28)

    imgui.SetStyleColor(imgui.IMGUI_COL_TEXT, textColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TEXTDISABLED, textColorDisabled)
    imgui.SetStyleColor(imgui.IMGUI_COL_TEXTSELECTEDBG, selectedTextBgColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_WINDOWBG, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_CHILDBG, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_POPUPBG, bgColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_BORDER, borderColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_BORDERSHADOW, bgColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_FRAMEBG, panelColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_FRAMEBGHOVERED, panelColorHovered)
    imgui.SetStyleColor(imgui.IMGUI_COL_FRAMEBGACTIVE, panelColorHovered)

    imgui.SetStyleColor(imgui.IMGUI_COL_FRAMEBG, panelColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_FRAMEBGHOVERED, panelColorHovered)
    imgui.SetStyleColor(imgui.IMGUI_COL_FRAMEBGACTIVE, panelColorHovered)

    imgui.SetStyleColor(imgui.IMGUI_COL_MENUBARBG, panelColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_SCROLLBARBG, scrollBarBgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_SCROLLBARGRAB, scrollBarColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_SCROLLBARGRABHOVERED, scrollBarColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_SCROLLBARGRABACTIVE, scrollBarColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_CHECKMARK, checkmark)
    imgui.SetStyleColor(imgui.IMGUI_COL_SLIDERGRAB, panelColorActive)
    imgui.SetStyleColor(imgui.IMGUI_COL_SLIDERGRABACTIVE, panelColorActive)

    imgui.SetStyleColor(imgui.IMGUI_COL_BUTTON, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_BUTTONHOVERED, borderColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_BUTTONACTIVE, buttonActiveColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_HEADER, lightBgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_HEADERHOVERED, lightBgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_HEADERACTIVE, lightBgColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_SEPARATOR, borderColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_SEPARATORHOVERED, borderColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_SEPARATORACTIVE, borderColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_RESIZEGRIP, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_RESIZEGRIPHOVERED, panelColorActive)
    imgui.SetStyleColor(imgui.IMGUI_COL_RESIZEGRIPACTIVE, panelColorActive)

    imgui.SetStyleColor(imgui.IMGUI_COL_PLOTLINES, panelColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_PLOTLINESHOVERED, panelColorHovered)
    imgui.SetStyleColor(imgui.IMGUI_COL_PLOTHISTOGRAM, panelColorActive)
    imgui.SetStyleColor(imgui.IMGUI_COL_PLOTHISTOGRAMHOVERED, panelColorHovered)

    imgui.SetStyleColor(imgui.IMGUI_COL_MODALWINDOWDIMGB, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_DRAGDROPTARGET, panelColorActive)
    imgui.SetStyleColor(imgui.IMGUI_COL_DRAGDROPTARGETBG, panelColorHovered)
    imgui.SetStyleColor(imgui.IMGUI_COL_NAVHIGHLIGHT, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_DOCKINGPREVIEW, lightBgColor)

    imgui.SetStyleColor(imgui.IMGUI_COL_TAB, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TABACTIVE, borderColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TABUNFOCUSED, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TABUNFOCUSEDACTIVE, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TABHOVERED, borderColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TABDIMMED, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TABDIMMEDSELECTED, bgColor)
    imgui.SetStyleColor(imgui.IMGUI_COL_TABDIMMEDSELECTEDOVERLINE, bgColor)

    imgui.SetStyleRounding(0, 0, 0, 0, 0, 0, 0)
end)

return styles
