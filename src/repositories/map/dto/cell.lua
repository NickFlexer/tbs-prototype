---
-- cell.lua


local class = require "middleclass"


local Cell = class("Cell")

function Cell:initialize(data)
    self.terrain = data.terrain
    self.position = data.position
end

function Cell:get_terrain()
    return self.terrain
end

function Cell:get_position()
    return self.position
end

return Cell
