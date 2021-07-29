---
-- current_phase_event.lua


local class = require "middleclass"


local CurrentPhaseEvent = class("CurrentPhaseEvent")

function CurrentPhaseEvent:initialize(phase_name)
    self.name = "current_phase_event"

    self.phase_name = phase_name
end

function CurrentPhaseEvent:get_name()
    return self.phase_name
end

function CurrentPhaseEvent:__tostring()
    return "CurrentPhaseEvent name [" .. tostring(self.phase_name) .. "]"
end

return CurrentPhaseEvent
