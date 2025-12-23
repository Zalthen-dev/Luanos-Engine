local Instance = require("@Instance")

local ModuleTrackerService = Instance.new("ModuleTrackerService")

-- TODO: implement this
-- the plan is to support most types of tracker modules
-- including .MOD, .S3M, and .IT
--
-- do we want the loaded trackers to be playable in a Sound instance?
-- or do we require the trackers to be handled in a separate ModuleTracker instance

function ModuleTrackerService:LoadTracker(path)
    error("ModuleTrackerService is not implemented")
end

return ModuleTrackerService