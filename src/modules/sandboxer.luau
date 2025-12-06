local sandboxer = {}

local luau = zune.luau

sandboxer.environment = {
    task = {
        cancel = zune.task.cancel,
        defer = zune.task.defer,
        delay = zune.task.delay,
        spawn = zune.task.spawn,
        wait = zune.task.wait,
    }
}
sandboxer.native_code_gen = true

function sandboxer.run(code, chunk, env)
    local opts = {
        env = env or sandboxer.environment,
        chunk_name = chunk,
        native_code_gen = sandboxer.native_code_gen
    }

    local bytecode = luau.compile(code)
    return luau.load(bytecode, opts)()
end

return sandboxer