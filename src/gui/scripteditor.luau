local imgui = require("@rimgui")
local window = require("@window")
local editor = require("@colortexteditor") 

local ffi = zune.ffi
local mem = zune.mem

local defaultSize = imgui.NewImVec2(600, 400)

local tab_Meta = {}
tab_Meta.__index = tab_Meta

local scriptEditor
scriptEditor = window.Create(function()
    for i = #scriptEditor.Tabs, 1, -1 do
        local tab = scriptEditor.Tabs[i]
        if tab.Visible:readu8(0) == 0 then
            -- fires if the tab (script) was closed.
            tab:Close()
            continue
        end
        local tabName = tab.Instance.Name
        tabName = tabName:len() > 0 and tabName or "LocalScript"
        imgui.SetNextWindowSize(defaultSize,imgui.IMGUI_COND_FIRST_USE_EVER)
        if imgui.Begin(string.format("%s##%s%s",tabName,tostring(tab.Instance),tostring(tab.Instance.UniqueId)), tab.Visible) == 1 then
            if tab.Editor:draw("##Editor",imgui.GetContentRegionAvail(), scriptEditor.flags) == 1 then
                -- fires on input
                -- maybe we make it save on an interval + on close later so its more efficient.
                tab:Save()
            end
        end
        imgui.End()
    end
end)

scriptEditor.flags = bit32.bor(imgui.IMGUI_INPUTTEXTFLAGS_MULTILINE, imgui.IMGUI_INPUTTEXTFLAGS_ALLOW_TAB_INPUT)
scriptEditor.Tabs = {}

-- script editor functions
function scriptEditor:Open(Script)
    if Script.Source then else return end
    for _, tab in ipairs(self.Tabs) do
        if tab.Instance == Script then
            return
        end
    end

    local newTab = {
        Instance = Script,
        Editor = editor.new(),
        Visible = ffi.create(ffi.types.u8)
    }
    newTab.Visible:writeu8(0, 1)
    newTab.Editor:setText(Script.Source)
    setmetatable(newTab, tab_Meta)
    table.insert(self.Tabs, newTab)
end

-- meta functions
function tab_Meta:Save()
    if self.Instance and self.Editor then else return end
    local Script = self.Instance
    local Code = self.Editor:getText()
    if Script and Script.Source then
        Script.Source = Code
    end
end

function tab_Meta:Close()
    self.Editor:destroy()
    local index = table.find(scriptEditor.Tabs, self)
    if index then
        table.remove(scriptEditor.Tabs, index)
    end
    self = nil
end

return scriptEditor