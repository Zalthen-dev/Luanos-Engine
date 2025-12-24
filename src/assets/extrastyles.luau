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

    imgui.SetStyleColor(imgui.COL.TEXT, textColor)
    imgui.SetStyleColor(imgui.COL.TEXTDISABLED, textColorDisabled)
    imgui.SetStyleColor(imgui.COL.TEXTSELECTEDBG, selectedTextBgColor)

    imgui.SetStyleColor(imgui.COL.WINDOWBG, bgColor)
    imgui.SetStyleColor(imgui.COL.CHILDBG, bgColor)
    imgui.SetStyleColor(imgui.COL.POPUPBG, bgColor)

    imgui.SetStyleColor(imgui.COL.BORDER, borderColor)
    imgui.SetStyleColor(imgui.COL.BORDERSHADOW, bgColor)

    imgui.SetStyleColor(imgui.COL.FRAMEBG, panelColor)
    imgui.SetStyleColor(imgui.COL.FRAMEBGHOVERED, panelColorHovered)
    imgui.SetStyleColor(imgui.COL.FRAMEBGACTIVE, panelColorHovered)

    imgui.SetStyleColor(imgui.COL.TITLEBG, lightBgColor)
    imgui.SetStyleColor(imgui.COL.TITLEBGACTIVE, lightBgColor)
    imgui.SetStyleColor(imgui.COL.TITLEBGCOLLAPSED, lightBgColor)

    imgui.SetStyleColor(imgui.COL.MENUBARBG, panelColor)
    
    imgui.SetStyleColor(imgui.COL.SCROLLBARBG, scrollBarBgColor)
    imgui.SetStyleColor(imgui.COL.SCROLLBARGRAB, scrollBarColor)
    imgui.SetStyleColor(imgui.COL.SCROLLBARGRABHOVERED, scrollBarColor)
    imgui.SetStyleColor(imgui.COL.SCROLLBARGRABACTIVE, scrollBarColor)

    imgui.SetStyleColor(imgui.COL.CHECKMARK, checkmark)
    imgui.SetStyleColor(imgui.COL.SLIDERGRAB, panelColorActive)
    imgui.SetStyleColor(imgui.COL.SLIDERGRABACTIVE, panelColorActive)

    imgui.SetStyleColor(imgui.COL.BUTTON, bgColor)
    imgui.SetStyleColor(imgui.COL.BUTTONHOVERED, borderColor)
    imgui.SetStyleColor(imgui.COL.BUTTONACTIVE, buttonActiveColor)

    imgui.SetStyleColor(imgui.COL.HEADER, lightBgColor)
    imgui.SetStyleColor(imgui.COL.HEADERHOVERED, lightBgColor)
    imgui.SetStyleColor(imgui.COL.HEADERACTIVE, lightBgColor)

    imgui.SetStyleColor(imgui.COL.SEPARATOR, borderColor)
    imgui.SetStyleColor(imgui.COL.SEPARATORHOVERED, borderColor)
    imgui.SetStyleColor(imgui.COL.SEPARATORACTIVE, borderColor)

    imgui.SetStyleColor(imgui.COL.RESIZEGRIP, bgColor)
    imgui.SetStyleColor(imgui.COL.RESIZEGRIPHOVERED, panelColorActive)
    imgui.SetStyleColor(imgui.COL.RESIZEGRIPACTIVE, panelColorActive)

    imgui.SetStyleColor(imgui.COL.PLOTLINES, panelColor)
    imgui.SetStyleColor(imgui.COL.PLOTLINESHOVERED, panelColorHovered)
    imgui.SetStyleColor(imgui.COL.PLOTHISTOGRAM, panelColorActive)
    imgui.SetStyleColor(imgui.COL.PLOTHISTOGRAMHOVERED, panelColorHovered)

    imgui.SetStyleColor(imgui.COL.MODALWINDOWDIMGB, bgColor)
    imgui.SetStyleColor(imgui.COL.DRAGDROPTARGET, panelColorActive)
    imgui.SetStyleColor(imgui.COL.DRAGDROPTARGETBG, panelColorHovered)
    imgui.SetStyleColor(imgui.COL.NAVHIGHLIGHT, bgColor)
    imgui.SetStyleColor(imgui.COL.DOCKINGPREVIEW, lightBgColor)

    imgui.SetStyleColor(imgui.COL.TAB, bgColor)
    imgui.SetStyleColor(imgui.COL.TABACTIVE, borderColor)
    imgui.SetStyleColor(imgui.COL.TABUNFOCUSED, bgColor)
    imgui.SetStyleColor(imgui.COL.TABUNFOCUSEDACTIVE, bgColor)
    imgui.SetStyleColor(imgui.COL.TABHOVERED, borderColor)
    imgui.SetStyleColor(imgui.COL.TABDIMMED, bgColor)
    imgui.SetStyleColor(imgui.COL.TABDIMMEDSELECTED, bgColor)
    imgui.SetStyleColor(imgui.COL.TABDIMMEDSELECTEDOVERLINE, bgColor)

    imgui.SetStyleRounding(0, 0, 0, 0, 0, 0, 0)
end)

return styles
