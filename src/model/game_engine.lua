---
-- game_engine.lua


local class = require "middleclass"
local FSM = require "fsm"

local GameplayState = require "model.states.gameplay_state"


local GameEngine = class("GameEngine")

function GameEngine:initialize(data)
    if not data.event_manager then
        error("GameEngine:initialize(): no data.event_manager argument!")
    end

    self.event_manager = data.event_manager
    self.fsm = FSM(self)

    self.states = {
        gameplay = GameplayState()
    }

    self.event_manager:register(self)
    self.running = false
end

function GameEngine:notify(event)
    if self.fsm:has_state() then
        self.fsm:get_current_state():notify(self, event)
    end
end

function GameEngine:init()
    self.running = true
    self.fsm:set_current_state(self.states.gameplay)
end

function GameEngine:is_running()
    return self.running
end

function GameEngine:update(dt)

end

function GameEngine:get_fsm()
    return self.fsm
end

function GameEngine:get_states()
    return self.states
end

return GameEngine
