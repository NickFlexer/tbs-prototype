---
-- animation_state.lua


local class = require "middleclass"

local BaseState = require "model.states.base_state"


local AnimationState = class("AnimationState", BaseState)

function AnimationState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(AnimationState)
end

function AnimationState:enter(owner)
    -- body
end

function AnimationState:execute(owner, dt)
    -- body
end

function AnimationState:exit(owner)
    -- body
end

function AnimationState:notify(owner, event)

end

return AnimationState