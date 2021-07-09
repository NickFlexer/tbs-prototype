---
-- game_loaded_event.lua


local class = require "middleclass"


local GameLoadedEvent = class("GameLoadedEvent")

function GameLoadedEvent:initialize()
    self.name = "game_loaded_event"
end

return GameLoadedEvent
