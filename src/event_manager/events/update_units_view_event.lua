---
-- update_units_view_event.lua


local class = require "middleclass"


local UpdateUnitsViewEvent = class("UpdateUnitsViewEvent")

function UpdateUnitsViewEvent:initialize(data)
    self.name = "update_units_view_event"
end

return UpdateUnitsViewEvent
