---
-- new_path_event.lua


local class = require "middleclass"


local NewPathEvent = class("NewPathEvent")

function NewPathEvent:initialize(path)
    self.name = "new_path_event"

    self.path = path
end

function NewPathEvent:get_path()
    return self.path
end

return NewPathEvent
