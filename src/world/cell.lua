---
-- cell.lua


local class = require "middleclass"


local Cell = class("Cell")

function Cell:initialize(data)
    if not data.terrain then
        error("Cell:initialize(): no data.terrain argument!")
    end

    self.terrain = data.terrain
end

return Cell
