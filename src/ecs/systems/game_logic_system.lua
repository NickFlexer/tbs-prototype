---
-- game_logic_system.lua


local class = require "middleclass"

local FSM = require "fsm"

local PrepareWorldState = require "data.logic.prepare_world_state"


local GameLogicSystem = class("GameLogicSystem", System)

function GameLogicSystem:initialize(data)
    System.initialize(self)

    self.fsm = FSM(self)

    self.states = {
        prepare_world = PrepareWorldState()
    }

    self.fsm:set_current_state(self.states.prepare_world)
end

function GameLogicSystem:update(dt, world)
    self.fsm:update(dt, world)
end

function GameLogicSystem:requires()
    return {}
end

function GameLogicSystem:onAddEntity(entity)
    -- body
end

function GameLogicSystem:onRemoveEntity(entity)
    -- body
end

function GameLogicSystem:get_fsm()
    return self.fsm
end

function GameLogicSystem:get_sates()
    return self.states
end

return GameLogicSystem
