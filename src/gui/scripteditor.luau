local imgui = require("@rimgui")
local window = require("@window")

local ffi = zune.ffi
local mem = zune.mem

local self
self = window.Create("Script Editor", function()
    imgui.SetNextWindowSize(imgui.NewImVec2(500, 300), imgui.IMGUI_COND_ONCE)
    if imgui.Begin(self.title, self.visible, imgui.IMGUI_WINDOWFLAGS_MENU_BAR) then
        local function Action_New()
            self:AddTab("print('Hello World')")
        end

        local function Action_Close()
            if self:GetCurrentTab() then
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
            imgui.InputTextMultiline(
                "##ScriptEditorTextbox",
                currentTab.TextBuffer,
                currentTab.TextBuffer:size() + 2,
                imgui.GetContentRegionAvail(),
                bit32.bor(imgui.IMGUI_INPUTTEXTFLAGS_ALLOW_TAB_INPUT, imgui.IMGUI_INPUTTEXTFLAGS_CALLBACK_RESIZE),
                self.TextCallback,
                currentTab.TextBuffer
            )
        else
            local availRegion = imgui.FromImVec2(imgui.GetWindowSize())
            local text = "No scripts open"

            local textSize = imgui.FromImVec2(imgui.CalcTextSize(text))

            imgui.SetCursorPosX((availRegion.x - textSize.x)/2)
            imgui.SetCursorPosY((availRegion.y - textSize.y)/2)

            imgui.Text(text)
        end

        imgui.End()
    end
end)

self.Tabs = {}
self.CurrentTabIndice = 1
function self:AddTab(text)
    table.insert(self.Tabs, {
        Name = "Script " .. tostring(math.random(1, 999)),
        TextBuffer = ffi.dupe(buffer.fromstring(text)),
    })
end

function self:GetCurrentTab()
    if #self.Tabs > 0 then
        self.CurrentTabIndice = math.clamp(self.CurrentTabIndice, 1, #self.Tabs)
        return self.Tabs[self.CurrentTabIndice]
    end
end

self.TextCallback = ffi.closure({
    args = { imgui.ImGuiInputTextCallbackData },
    returns = ffi.types.i32
}, function(data)

    local eventFlag = buffer.readi32(data, imgui.ImGuiInputTextCallbackData:offset("EventFlag"))
    print(eventFlag)
    print(imgui.IMGUI_INPUTTEXTFLAGS_CALLBACK_RESIZE)
    print(bit32.band(eventFlag, imgui.IMGUI_INPUTTEXTFLAGS_CALLBACK_RESIZE))
    if bit32.band(eventFlag, imgui.IMGUI_INPUTTEXTFLAGS_CALLBACK_RESIZE) <= imgui.IMGUI_INPUTTEXTFLAGS_CALLBACK_RESIZE then
        local tab = self:GetCurrentTab()
        if not tab then return 0 end

        local ptr = ffi.ptrFromAddress(data)

        local buf = ffi.ptrFromAddress(mem.slice(data, imgui.ImGuiInputTextCallbackData:offset("UserData"), 8))
        local text = buffer.tostring(mem.slice(buf, 0))
        print(text)

        local newBuf = ffi.alloc(tab.TextBuffer:size() + 2)
        mem.copy(newBuf, 0, tab.TextBuffer, 0)
        
        tab.TextBuffer = newBuf

        mem.copy(data, imgui.ImGuiInputTextCallbackData:offset("Buf"), newBuf, 0)
        buffer.writei32(data, imgui.ImGuiInputTextCallbackData:offset("BufTextLen"), newBuf:size())
        buffer.writei32(data, imgui.ImGuiInputTextCallbackData:offset("BufSize"), newBuf:size())
        buffer.writeu8(data, imgui.ImGuiInputTextCallbackData:offset("BufDirty"), 1)
    end

    return 0
end)

return self
