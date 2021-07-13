---
-- map.lua


local class = require "middleclass"
local Grid = require "grid"


local Map = class("Map")

function Map:initialize(data)
    self.map = nil
end

function Map:new_map(size_x, size_y)
    self.map = Grid(size_x, size_y)
end

function Map:set_cell(x, y, new_cell)
    self.map:set_cell(x, y, new_cell)
end

return Map
