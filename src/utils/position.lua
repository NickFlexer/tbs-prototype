---
-- position.lua


local class = require "middleclass"


local Position = class("Position")

function Position:initialize(x, y)
    self.x = x
    self.y = y
end

function Position:get()
    return self.x, self.y
end

return Position
