---
-- update_map_view_event.lua


local class = require "middleclass"


local UpdateMapViewEvent = class("UpdateMapViewEvent")

function UpdateMapViewEvent:initialize(data)
    self.name = "update_map_view_event"
end

return UpdateMapViewEvent
