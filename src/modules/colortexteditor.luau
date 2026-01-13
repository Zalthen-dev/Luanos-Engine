local imgui = require("@rimgui")

--local ffi = zune.ffi
local mem = zune.mem

local ColorTextEditor = {}
ColorTextEditor.__index = ColorTextEditor


-- the functions here are 1:1 with editor.luau (for now).

function ColorTextEditor.new(capacity)
    return setmetatable({
        _ptr = imgui.ColorTextEditorCreate(capacity or 4096)
    }, ColorTextEditor)
end

function ColorTextEditor:draw(label, size, flags)
    return imgui.ColorTextEditorDraw(
        self._ptr,
        label,
        size,
        flags or 0
    )
end

function ColorTextEditor:getText()
    local textPtr = imgui.ColorTextEditorGetText(self._ptr)
    local textLen = imgui.ColorTextEditorGetLength(self._ptr)
    textPtr:size(textLen)
    local text = buffer.tostring(mem.slice(textPtr, 0))
    return text
end

function ColorTextEditor:getLineCount()
    local _, count = self:getText():gsub("\n", "")

    return count+1
end

function ColorTextEditor:setText(text)
    imgui.ColorTextEditorSetText(self._ptr, text)
end

function ColorTextEditor:destroy()
    imgui.ColorTextEditorDestroy(self._ptr)
    self = nil
end

return ColorTextEditor
