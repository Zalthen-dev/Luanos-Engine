local imgui = require("@rimgui")

local ffi = zune.ffi
local mem = zune.mem

local Editor = {}
Editor.__index = Editor

function Editor.new(capacity)
    return setmetatable({
        _ptr = imgui.TextEditorCreate(capacity or 4096)
    }, Editor)
end

function Editor:draw(label, size, flags)
    return imgui.TextEditorDraw(
        self._ptr,
        label,
        size,
        flags or 0
    )
end

function Editor:getText()
    local textPtr = imgui.TextEditorGetText(self._ptr)
    local textLen = imgui.TextEditorGetLength(self._ptr)

    textPtr:size(textLen)
    local text = buffer.tostring(mem.slice(textPtr, 0))

    return text
end

function Editor:getLineCount()
    local _, count = self:getText():gsub("\n", "")

    return count+1
end

function Editor:setText(text)
    imgui.TextEditorSetText(self._ptr, text)
end

function Editor:destroy()
    imgui.TextEditorDestroy(self._ptr)
    self = nil
end

return Editor
