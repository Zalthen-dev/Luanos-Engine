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
				oldParent.ChildRemoved:Fire(self)
				oldParent.DescendantRemoving:Fire(self)

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

			    value.ChildAdded:Fire(self)
				value.DescendantAdded:Fire(self)
	        end
        else
		    props[key] = value
	    end

	    if self.Changed then
	        self.Changed:Fire(key, value)
        end
    end,

	__tostring = function(self)
		if rawget(self, "Name") then
			return rawget(self, "Name")
		end

		if rawget(self, "ClassName") then
			return rawget(self, "ClassName")
		end

		return "Instance"
	end,
}

function Instance.new(className)
    local self = {
        ClassName = className,
        Name = className,
        Parent = nil,
        UniqueId = math.random(1, 9999999),
        Children = {},

		Attributes = {},
		Tags = {},

        ChildAdded = Signal.new(),
		DescendantAdded = Signal.new(),
		ChildRemoved = Signal.new(),
		DescendantRemoving = Signal.new(),

        Changed = Signal.new(),
		Destroying = Signal.new(),

		AttributeChanged = Signal.new(),

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

-- i changed how cloning works cause the vectors and such were shared between objects.
-- can probably be remade to be better
local function DeepClone(value, seen)
    if type(value) ~= "table" then
        return value
    end
    seen = seen or {}
    if seen[value] then
        return seen[value]
    end
    local out = {}
    seen[value] = out
    for k, v in pairs(value) do
        out[DeepClone(k, seen)] = DeepClone(v, seen)
    end
    local mt = getmetatable(value)
    if mt then
        setmetatable(out, mt)
    end
    return out
end

function Instance:Clone()
    local copy = Instance.new(self.ClassName)

    for k, v in pairs(self._props) do
        if k ~= "Parent" and k ~= "Children" then
            copy._props[k] = DeepClone(v)
        end
    end

    for _, child in ipairs(self.Children) do
        child:Clone().Parent = copy
    end

    return copy
end

-- attributes
function Instance:GetAttributes()
	return table.clone(self.Attributes)
end

function Instance:GetAttribute(attribute:string)
	return self.Attributes[attribute]
end

function Instance:SetAttribute(attribute:string, value)
	self.Attributes[attribute] = value
end

-- tags
function Instance:GetTags()
	return table.clone(self.Tags)
end

function Instance:AddTag(tag:string)
	if not table.find(self.Tags) then
		table.insert(self.Tags, tag)
	end
end

function Instance:RemoveTag(tag:string)
	local indice = table.find(self.Tags, tag)	
	if indice then
		table.remove(self.Tags, indice)
	end
end

function Instance:HasTag(tag:string):boolean
	return (table.find(self.Tags, tag) ~= nil)
end

function Instance:ClearAllChildren()
	for _, child in ipairs(self.Children) do
        child:Destroy()
	end

	self.Children = {}
end

function Instance:Destroy()
	self.Destroying:Fire()
	if self.Parent then
		self.Parent.ChildRemoved:Fire(self)
		self.Parent.DescendantRemoving:Fire(self)

		for i, child in ipairs(self.Parent.Children) do
			if child == self then
				table.remove(self.Parent.Children, i)
				break
			end
		end
	end
	
	table.clear(self._props)
	self._props = nil

	self.Parent = nil
	self.Children = nil
	self.Changed = nil

	table.clear(self)
	rawset(self, "Destroyed", true)
end

return Instance