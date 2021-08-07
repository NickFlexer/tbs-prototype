---
-- update_move_area_event.lua


local class = require "middleclass"


local UpdateMoveAreaEvent = class("UpdateMoveAreaEvent")

function UpdateMoveAreaEvent:initialize()
    self.name = "update_move_area_event"
end

return UpdateMoveAreaEvent
