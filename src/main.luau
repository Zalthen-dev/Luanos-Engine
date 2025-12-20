local rl = require("@raylib")
local renderer = require("@renderer")
local filesystem = require("./modules/filesystem")
local sandboxer = require("./modules/sandboxer")

local InitializeEngine = require("./environment/get")

local task = zune.task
local process = zune.process

local threads = {}

local function ProcessArgs(args: {string}): ()
	table.remove(args, 1) -- unneeded
end

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

local config = filesystem.readtoml("engine.toml")
ProcessArgs(process.args)

local engineState = InitializeEngine()
sandboxer.environment = require("./environment/datatypes/test")
sandboxer.environment.time = rl.GetTime
sandboxer.environment.print = function(...)
	local args = {...}
	local str = table.concat(args, "	")
	engineState.game:GetService("LogService"):_AddLog(str, 0)
	--print(...)
end
sandboxer.environment.warn = function(...)
	local args = {...}
	local str = table.concat(args, "	")
	engineState.game:GetService("LogService"):_AddLog(str, 2)
	--print(...)
end
sandboxer.environment.loadstring = function(...)
	if not engineState.game:GetService("ServerScriptService").LoadStringEnabled then
		error("loadstring is disabled, to enable, set ServerScriptService.LoadStringEnabled to true")
	end

	return loadstring(...)
end

rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE)
rl.InitWindow(1200, 800, "Luanos Engine")
rl.SetTargetFPS(config.window.fps)
rl.rlSetClipPlanes(0.01, 32768)

if rl.IsWindowReady() == 0 then
	print("ERROR: Failed to initialize window, exiting")
	process.exit(0)
end

local lastWindowIsFocused = rl.IsWindowFocused()

renderer.OnStart(engineState)
execute("./src/sandboxed/test.luau", "file")

while rl.WindowShouldClose() == 0 do
	local windowIsFocused = rl.IsWindowFocused()
	if config.window.reduce_fps_on_unfocus then
		if lastWindowIsFocused ~= windowIsFocused then
			if windowIsFocused == 1 then
				rl.SetTargetFPS(config.window.fps)
			else
				rl.SetTargetFPS(config.window.fps_unfocused)
			end
		end
	end

    renderer.RenderScene()

	lastWindowIsFocused = windowIsFocused
	task.wait(0)
end

if #threads > 0 then
	for _, currentThread in threads do
    	task.cancel(currentThread)
	end
end

renderer.OnEnd()
rl.CloseWindow()
process.exit(0)