local Instance = require("@Instance")

local CollectionService = Instance.new("CollectionService")

function CollectionService:GetAllTags() end

function CollectionService:GetTagged(tag) end

function CollectionService:GetCollection(tag)
	return CollectionService:GetTagged(tag)
end

function CollectionService:GetTags(instance)
	return instance:GetTags()
end

function CollectionService:HasTag(instance, tag)
	return instance:HasTag(tag)
end

function CollectionService:AddTag(instance, tag)
	return instance:AddTag(tag)
end

function CollectionService:RemoveTag(instance, tag)
	return instance:RemoveTag(tag)
end

return CollectionService
