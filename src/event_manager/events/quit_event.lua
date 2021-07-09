---
-- quit_event.lua


local class = require "middleclass"


local QuitEvent = class("QuitEvent")

function QuitEvent:initialize()
    self.name = "quit_event"
end

return QuitEvent
