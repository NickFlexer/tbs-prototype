---
-- start_new_turn_event.lua


local class = require "middleclass"


local StartNewTurnEvent = class("StartNewTurnEvent")

function StartNewTurnEvent:initialize()
    self.name = "start_new_turn_event"
end

return StartNewTurnEvent
