---
-- turn_end_event.lua


local class = require "middleclass"


local TurnEndEvent = class("TurnEndEvent")

function TurnEndEvent:initialize()
    self.name = "turn_end_event"
end

return TurnEndEvent
