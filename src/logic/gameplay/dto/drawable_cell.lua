---
-- drawable_cell.lua


local class = require "middleclass"


local DrawableCell = class("DrawableCell")

function DrawableCell:initialize(data)
    self.tiles = data.tiles
    self.position = data.position
end

function DrawableCell:get_tiles()
    return self.tiles
end

function DrawableCell:get_position()
    return self.position
end

return DrawableCell
