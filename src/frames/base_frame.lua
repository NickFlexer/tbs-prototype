---
-- base_frame.lua


local class = require "middleclass"
local ABC = require "abc"


local BaseFrame = class("BaseFrame", ABC)

function BaseFrame:initialize(data)
    ABC.initialize(self)
    self:set_abstract_methods(BaseFrame)
end

function BaseFrame:update(dt)
    return self.abstractmethod
end

function BaseFrame:draw()
    return self.abstractmethod
end

function BaseFrame:mouse_pressed(x, y, button, istouch)
    return self.abstractmethod
end

return BaseFrame
