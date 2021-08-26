---
-- base_state.lua


local class = require "middleclass"
local ABC = require "abc"


local BaseState = class("BaseState", ABC)

function BaseState:initialize()
    ABC.initialize(self)
    self:set_abstract_methods(BaseState)
end

function BaseState:enter(owner)
    return self.abstractmethod
end

function BaseState:execute(owner, dt)
    return self.abstractmethod
end

function BaseState:exit(owner)
    return self.abstractmethod
end

return BaseState