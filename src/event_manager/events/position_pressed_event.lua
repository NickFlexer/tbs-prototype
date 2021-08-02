---
-- position_pressed_event.lua


local class = require "middleclass"


local PositionPressedEvent = class("PositionPressedEvent")

function PositionPressedEvent:initialize(x, y)
    self.name = "position_pressed_event"

    self.x = x
    self.y = y
end

function PositionPressedEvent:get_position()
    return self.x, self.y
end

function PositionPressedEvent:__tostring()
    return "PositionPressedEvent [" .. tostring(self.x) ..  ", " .. tostring(self.y) .. "]"
end

return PositionPressedEvent
