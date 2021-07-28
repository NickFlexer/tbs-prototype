---
-- gameplay_state.lua


local class = require "middleclass"

local BaseState = require "model.states.base_state"

local QuitEvent = require "event_manager.events.quit_event"
local StartAnimationEvent = require "event_manager.events.start_animain_event"
local TurnNumberEvent = require "event_manager.events.turn_number_event"


local GameplayState = class("GameplayState", BaseState)

function GameplayState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(GameplayState)
end

function GameplayState:enter(owner)
    local logic = owner:get_logic()
    owner:get_event_manager():post(TurnNumberEvent(logic:get_turn()))
end

function GameplayState:execute(owner, dt)
    local logic = owner:get_logic()
    local action = logic:get_new_action()

    if action then
        owner:get_event_manager():post(StartAnimationEvent())
    end
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