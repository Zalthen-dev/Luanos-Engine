local Signal = require("@signal")

local Instance = {}
local InstanceMetatable = {
    __index = function(self, key)
        local props = rawget(self, "_props")
        if props and props[key] ~= nil then
            return props[key]
        end

        return Instance[key]
    end,

    __newindex = function(self, key, value)
        local props = rawget(self, "_props")
	    if not props then
		    return
	    end

	    if key == "Parent" then
	        local oldParent = props.Parent
	        if oldParent then
			    for i, child in ipairs(oldParent.Children) do
			        if child == self then
				        table.remove(oldParent.Children, i)
				        break
			        end
			    end
		    end

		    props.Parent = value
	        if value then
		        table.insert(value.Children, self)

			    if value.ChildAdded then
			        value.ChildAdded:Fire(self)
		        end
	        end
        else
		    props[key] = value
	    end

	    if self.Changed then
	        self.Changed:Fire(key, value)
        end
    end
}


function Instance.new(className)
    local self = {
        ClassName = className,
        Name = className,
        Parent = nil,
        UniqueId = math.random(1, 9999999),
        Children = {},

        ChildAdded = Signal.new(),
        Changed = Signal.new(),

        _props = {
            ClassName = className,
            Name = className,
            Parent = nil,
            Children = {}
        }
    }

    return setmetatable(self, InstanceMetatable)
end

-- Utility methods
function Instance:GetProperties()
	return rawget(self, "_props")
end

function Instance:SetProperty(name, value)
	self[name] = value
end

function Instance:SetProperties(tbl)
	for k, v in pairs(tbl) do
		self:SetProperty(k, v)
	end
end

-- methods
function Instance:IsA(className)
	return self.ClassName == className
end

function Instance:FindFirstChild(name)
	for _, child in ipairs(self.Children) do
		if child.Name == name then
			return child
		end
	end
	return nil
end


function Instance:FindFirstChildOfClass(className)
	for _, child in ipairs(self.Children) do
		if child.ClassName == className then
			return child
		end
	end
	return nil
end

function Instance:WaitForChild(name: string, timeout: number?)
    local child = self:FindFirstChild(name)
    if child then
        return child
    end

    local start = os.clock()
    local didWarn = false
    local connection

    connection = self.ChildAdded:Connect(function(otherChild)
        if otherChild.Name == name then
            child = otherChild
            connection:Disconnect()
        end
    end)

    while not child do
        task.wait()
        if type(timeout) == "number" then
            if (os.clock() - start) > timeout then
                break
            end
        else
            if (os.clock() - start) > 5 and not didWarn then
                warn("Infinite yield possible for Instance:WaitForChild")
            end
        end
    end

    return child
end

function Instance:GetChildren()
	local copy = {}
	for i, child in ipairs(self.Children) do
		copy[i] = child
	end
	return copy
end

function Instance:GetDescendants()
	local result = {}

	local function scan(obj)
		for _, child in ipairs(obj.Children) do
			table.insert(result, child)
			scan(child)
		end
	end

	scan(self)
	return result
end

function Instance:Clone()
	local copy = Instance.new(self.ClassName)

	for k, v in pairs(self._props) do
		if k ~= "Parent" and k ~= "Children" then
			copy[k] = v
		end
	end

	for _, child in ipairs(self.Children) do
		child:Clone().Parent = copy
	end

	return copy
end

function Instance:ClearAllChildren()
	for _, child in ipairs(self.Children) do
        child:Destroy()
	end

	self.Children = {}
end

function Instance:Destroy()
	if self.Parent then
		for i, child in ipairs(self.Parent.Children) do
			if child == self then
				table.remove(self.Parent.Children, i)
				break
			end
		end
	end

	self.Parent = nil
	self._props = nil
	self.Children = nil
	self.Destroyed = true
end


return Instance