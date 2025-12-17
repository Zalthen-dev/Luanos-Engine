local imgui = require("@rimgui")
local window = require("@window")
local editor = require("@editor")

local ffi = zune.ffi
local mem = zune.mem

local defaultText = [[print("Hello World")]]

local self
self = window.Create("Script Editor", function()
    local function Action_New()
        self:AddTab(defaultText)
    end

    local function Action_Close()
        local tab = self:GetCurrentTab()
        if tab then
            tab.Editor:destroy()
            table.remove(self.Tabs, self.CurrentTabIndice)

            if self.CurrentTabIndice > #self.Tabs and #self.Tabs > 0 then
                 self.CurrentTabIndice = #self.Tabs
            end
        end
    end

    if imgui.BeginMenuBar() == 1 then
        if imgui.BeginMenu("File") == 1 then
            if imgui.MenuItem("New", "Ctrl+N") == 1 then
                Action_New()
            end

            if imgui.MenuItem("Close", "Ctrl+W") == 1 then
                Action_Close()
            end

            imgui.EndMenu()
        end

        imgui.Separator()
        if #self.Tabs > 0 then
            for i, tab in self.Tabs do
                local name = tab.Name
                if self.CurrentTabIndice == i then
                    name = ("[ %s ]"):format(name)
                    imgui.MenuItem(name)
                else
                    if imgui.MenuItem(name) == 1 then
                        self.CurrentTabIndice = i
                    end
                end
            end
        end

        imgui.EndMenuBar()
    end

    local currentTab = self:GetCurrentTab()
    if currentTab then
        currentTab.Editor:draw("##ScriptEditorTextbox", imgui.GetContentRegionAvail(), imgui.IMGUI_INPUTTEXTFLAGS_ALLOW_TAB_INPUT)
    else
        local availRegion = imgui.FromImVec2(imgui.GetWindowSize())
        local text = "No scripts open"

        local textSize = imgui.FromImVec2(imgui.CalcTextSize(text))

        imgui.SetCursorPosX((availRegion.x - textSize.x)/2)
        imgui.SetCursorPosY((availRegion.y - textSize.y)/2)

        imgui.Text(text)
    end
end)

self.defaultSize = imgui.NewImVec2(800, 600)
self.flags = bit32.bor(self.flags, imgui.IMGUI_WINDOWFLAGS_MENU_BAR)
self.Tabs = {}
self.CurrentTabIndice = 1
function self:AddTab(text)
    local editorObj = editor.new()
    editorObj:setText(text)

    table.insert(self.Tabs, {
        Name = "Script " .. tostring(math.random(1, 999)),
        Editor = editorObj
    })
end

function self:GetCurrentTab()
    if #self.Tabs > 0 then
        self.CurrentTabIndice = math.clamp(self.CurrentTabIndice, 1, #self.Tabs)
        return self.Tabs[self.CurrentTabIndice]
    end
    return
end

return self