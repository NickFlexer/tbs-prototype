---
-- unselect_unit_event.lua


local class = require "middleclass"


local UnselectUnitEvent = class("UnselectUnitEvent")

function UnselectUnitEvent:initialize()
    self.name = "unselect_unit_event"
end

return UnselectUnitEvent
