---
-- gameplay_state.lua


local class = require "middleclass"

local BaseState = require "model.states.base_state"

local QuitEvent = require "event_manager.quit_event"


local GameplayState = class("GameplayState", BaseState)

function GameplayState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(GameplayState)
end

function GameplayState:enter(owner)
    -- body
end

function GameplayState:execute(owner, dt)
    -- body
end

function GameplayState:exit(owner)
    -- body
end

function GameplayState:notify(owner, event)
    if event:isInstanceOf(QuitEvent) then
        love.event.quit()
    end
end

return GameplayState