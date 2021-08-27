---
-- get_new_action_state.lua


local class = require "middleclass"

local BaseState = require "logic.gameplay.states.base_state"


local GetNewActionState = class("GetNewActionState", BaseState)

function GetNewActionState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(GetNewActionState)
end

function GetNewActionState:enter(owner)
    --
end

function GetNewActionState:execute(owner, dt)
    -- body
end

function GetNewActionState:exit(owner)
    -- body
end

return GetNewActionState
