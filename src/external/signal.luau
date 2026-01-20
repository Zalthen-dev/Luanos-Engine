local Signal = {}
-- add signal type for properties.
Signal.__type = "Signal"
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection
Connection.__type = "Connection"

function Connection.new(signal, fn)
	local self = setmetatable({}, Connection)
	self._signal = signal
	self._fn = fn
	self.Connected = true
	return self
end

function Connection:Disconnect()
	if not self.Connected then
		return
	end
	self.Connected = false
	local sig = self._signal
	if sig and sig._connections then
		for i = #sig._connections, 1, -1 do
			if sig._connections[i] == self then
				table.remove(sig._connections, i)
				break
			end
		end
	end
	self._signal = nil
	self._fn = nil
end

function Connection:Fire(...)
	if self.Connected and self._fn then
		local args = {...}
		zune.task.spawn(function()
			local ok, err = pcall(self._fn, unpack(args))
			if not ok then
				print(err)
			end
		end)
	end
end

-- signal container
function Signal.new()
	local self = setmetatable({}, Signal)
	self._connections = {}
	return self
end

function Signal:Connect(fn)
	local conn = Connection.new(self, fn)
	table.insert(self._connections, conn)
	return conn
end

function Signal:Fire(...)
	for _, conn in ipairs(self._connections) do
		conn:Fire(...)
	end
end

function Signal:__tostring()
	return ("Signal(%d listeners)"):format(#self._connections)
end

return Signal