local rl = require("@raylib")
local renderer = require("@renderer")
local filesystem = require("./modules/filesystem")
local sandboxer = require("./modules/sandboxer")
local engine_env = require("./environment/get")

local task = zune.task

local threads = {}

local function execute(path, entry)
    local code = filesystem.read(path)
	local thread = task.spawn(function()
		sandboxer.run(code, entry.name)
	end)
	threads[path] = thread
end

local function callback(entry, base)
	local base = base or "src/sandboxed"
	local path = base .. "/" .. entry.name

	if entry.kind == "directory" then
		filesystem.entryloop(path, function(e)
			callback(e, path)
		end)
	else
		execute(path, entry)
	end
end

engine_env()
sandboxer.environment = require("./environment/datatypes/test")
execute("./src/sandboxed/test.luau", "file")

rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE)
rl.InitWindow(1200, 800, "Luanos Engine")
rl.SetTargetFPS(360)

--rl.SetExitKey(rl.KEY_NULL)

renderer.OnStart()
while rl.WindowShouldClose() == 0 do
    renderer.RenderScene()
end

for _, currentThread in threads do
    task.cancel(currentThread)
end

renderer.OnEnd()
rl.CloseWindow()
