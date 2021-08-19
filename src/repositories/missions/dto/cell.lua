---
-- cell.lua


local class = require "middleclass"


local Cell = class("Cell")

function Cell:initialize(data)
    self.position = data.position
    self.content = data.content
end

function Cell:get_position()
    return self.position
end

function Cell:get_content()
    return self.content
end

return Cell
