---
-- event_manager.lua


local class = require "middleclass"


local EventManager = class("EventManager")

function EventManager:initialize(data)
    self.logger = data.logger

    self.listeners = {}
end

function EventManager:register(listener)
    table.insert(self.listeners, listener)
end

function EventManager:unregister(listener)
    for pos, cur_listener in ipairs(self.listeners) do
        if cur_listener == listener then
            table.remove(self.listeners, pos)
            return
        end
    end
end

function EventManager:post(event)
    self.logger:debug(event)

    for _, listener in ipairs(self.listeners) do
        listener:notify(event)
    end
end

return EventManager
