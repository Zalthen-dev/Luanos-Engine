local rl = require("@raylib")

local core = {}
core.config = nil
core.args = nil
core.ConfigFlag = rl.FLAG_WINDOW_RESIZABLE

function core.hasArg(arg: string): boolean
    return (table.find(core.args, arg) ~= nil)
end

function core.LoadWindow()

end



function core.UnloadWindow()

end

return core