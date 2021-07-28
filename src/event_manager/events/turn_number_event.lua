---
-- turn_number_event.lua


local class = require "middleclass"


local TurnNumberEvent = class("TurnNumberEvent")

function TurnNumberEvent:initialize(number)
    self.name = "turn_number_event"

    self.number = number
end

function TurnNumberEvent:get_number()
    return self.number
end

function TurnNumberEvent:__tostring()
    return "TurnNumberEvent turn [" .. tostring(self.number) .. "]"
end

return TurnNumberEvent
