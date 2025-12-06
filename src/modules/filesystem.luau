local fs = zune.fs

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
        print(msg)
    end
    
    return success
end

function filesystem.read(file)
    return fs.readFile(file)
end

return filesystem