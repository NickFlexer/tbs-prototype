---
-- player_unit_selected_event.lua


local class = require "middleclass"


local PlayerUnitSelectedEvent = class("PlayerUnitSelectedEvent")

function PlayerUnitSelectedEvent:initialize(unit)
    self.name = "player_unit_selected_event"

    self.unit = unit
end

function PlayerUnitSelectedEvent:get_unit()
    return self.unit
end

return PlayerUnitSelectedEvent
