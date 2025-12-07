local rl = require("@raylib")
local renderer = require("@renderer")
local filesystem = require("./modules/filesystem")
local sandboxer = require("./modules/sandboxer")
local engine_env = require("./environment/get")
local UserInputService = require("./environment/game/services/UserInputService")

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
--rl.rlSetClipPlanes(0.01, 32768)

local lastWindowIsFocused = rl.IsWindowFocused()

renderer.OnStart()

while rl.WindowShouldClose() == 0 do
	local windowIsFocused = rl.IsWindowFocused()
	if lastWindowIsFocused ~= windowIsFocused then
		if windowIsFocused == 1 then
			rl.SetTargetFPS(360)
		else
			rl.SetTargetFPS(10)
		end
	end
	UserInputService.Step()
    renderer.RenderScene()
	lastWindowIsFocused = windowIsFocused
end

if #threads > 0 then
	for _, currentThread in threads do
    	task.cancel(currentThread)
	end
end

renderer.OnEnd()
rl.CloseWindow()
zune.process.exit(0)
