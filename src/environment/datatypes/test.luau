local fs = zune.fs

local datatypes = {}

for _, file in pairs(fs.entries("./src/environment/datatypes")) do
	if file.name == "test.luau" then
		continue
	end

	local moduleName = file.name:gsub("%.luau$", "")
	datatypes[moduleName] = require("./" .. moduleName)
end

return datatypes