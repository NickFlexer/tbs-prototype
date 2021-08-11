---
-- start_gameplay_event.lua


local class = require "middleclass"


local StartGameplayEvent = class("StartGameplayEvent")

function StartGameplayEvent:initialize()
    self.name = "start_gameplay_event"
end

return StartGameplayEvent
