---
-- remove_path_event.lua


local class = require "middleclass"


local RemovePathEvent = class("RemovePathEvent")

function RemovePathEvent:initialize(data)
    self.name = "remove_path_event"
end

return RemovePathEvent
