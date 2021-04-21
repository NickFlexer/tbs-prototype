---
-- prepare_world_state.lua


local class = require "middleclass"

local BaseState = require "data.logic.base_state"


local PrepareWorldState = class("PrepareWorldState", BaseState)

function PrepareWorldState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(PrepareWorldState)
end

function PrepareWorldState:enter(owner)
    -- body
end

function PrepareWorldState:execute(owner, dt, world)
    -- body
end

function PrepareWorldState:exit(owner)
    -- body
end

return PrepareWorldState
