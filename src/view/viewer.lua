---
-- viewer.lua


local class = require "middleclass"

local UpdateMapViewEvent = require "event_manager.events.update_map_view_event"


local Viewer = class("Viewer")

function Viewer:initialize(data)
    if not data.event_manager then
        error("Viewer:initialize(): no data.event_manager argument!")
    end

    if not data.model then
        error("Viewer:initialize(): no data.model argument!")
    end

    self.event_manager = data.event_manager
    self.model = data.model

    self.event_manager:register(self)
end

function Viewer:notify(event)
    if event:isInstanceOf(UpdateMapViewEvent) then

    end
end

function Viewer:render_all()
    -- body
end

return Viewer
