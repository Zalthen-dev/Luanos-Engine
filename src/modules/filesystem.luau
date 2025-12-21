local fs = zune.fs
local serde = zune.serde

local filesystem = {}

function filesystem.entryloop(path, callback)
    local success, msg = pcall(function(...)  
        local entries = fs.entries(path)
        if entries then
            for _, entry in pairs(entries) do
                callback(entry)
            end
        end
    end)

    if not success and msg then
        print("WARN: " .. msg)
    end
    
    return success
end

function filesystem.read(file)
    return fs.readFile(file)
end

function filesystem.readtoml(file)
    return serde.toml.decode(fs.readFile(file))
end

return filesystem