---
-- start_animain_event.lua


local class = require "middleclass"


local StartAnimationEvent = class("StartAnimationEvent")

function StartAnimationEvent:initialize(data)
    self.name = "start_animain_event"
end

return StartAnimationEvent
