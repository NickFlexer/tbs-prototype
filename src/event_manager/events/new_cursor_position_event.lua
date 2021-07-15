---
-- new_cursor_position_event.lua


local class = require "middleclass"


local NewCursorPositionEvent = class("NewCursorPositionEvent")

function NewCursorPositionEvent:initialize(x, y)
    self.name = "new_cursor_position_event"

    self.x = x
    self.y = y
end

function NewCursorPositionEvent:get_position()
    return self.x, self.y
end

function NewCursorPositionEvent:__tostring()
    return "NewCursorPositionEvent [" .. tostring(self.x) ..  ", " .. tostring(self.y) .. "]"
end

return NewCursorPositionEvent
