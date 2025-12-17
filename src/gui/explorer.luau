local imgui = require("@rimgui")
local window = require("@window")

local ffi = zune.ffi
local mem = zune.mem

local services = {
    "Workspace",
    "ServerScriptService",
    "ServerStorage",
    "StarterGui",
    "Debris",
    "HttpService",
    "LogService",
    "RunService",
    "Selection",
    "TweenService",
    "UserInputService",
}

local function GetServices(game)
    local servs = {}
    for _, name in ipairs(services) do
        local serv = game:FindService(name)
        if serv then
            table.insert(servs, serv)
        end
    end

    return servs
end

local self
self = window.Create("Explorer", function(engineState)
    local game = engineState.game
    local servs = GetServices(game)
        
    for _, serv in ipairs(servs) do
        self.TreeRender(game, serv)
    end
end)

self.defaultSize = imgui.NewImVec2(200, 600)

-- https://kahwei.dev/2022/06/20/imgui-tree-node/
-- above link helpful

local treeNodeFlags = bit32.bor(
    imgui.IMGUI_TREENODEFLAGS_OPENONARROW
)

function self.TreeRender(game, obj)
    local flags = treeNodeFlags
    local children = obj:GetChildren()
    if #children == 0 then
        flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_LEAF)
    end

    if imgui.TreeNodeEx(obj.Name, flags) == 1 then
        if imgui.IsItemClicked() then

        end

        if #children > 0 then
            for _, child in ipairs(children) do
                self.TreeRender(child)
            end
        end

        imgui.TreePop()
    end
end

return self
