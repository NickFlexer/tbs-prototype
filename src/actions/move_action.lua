---
-- move_action.lua


local class = require "middleclass"


local MoveAction = class("MoveAction")

function MoveAction:initialize(data)
    self.unit = data.unit
    self.path = data.path

    self.stop = false
    self.index = 1
    self.target = nil
    self.index, self.target = next(self.path, self.index)
end

function MoveAction:iterate(tile_size)
    local x, y = self.unit:get_position()

    x = x - ((x - ((self.target.x - 1) * tile_size)) * (tile_size/8) * 0.1)
    y = y - ((y - ((self.target.y - 1) * tile_size)) * (tile_size / 8) * 0.1)

    print((self.target.x - 1) * tile_size, (self.target.y - 1) * tile_size)
    print(math.ceil(x), math.ceil(y))
    self.unit:set_position(math.ceil(x), math.ceil(y))

    if math.abs(x - ((self.target.x - 1) * tile_size)) <= 1 and math.abs(y - ((self.target.y - 1) * tile_size)) <=1 then
        self.index, self.target = next(self.path, self.index)

        if not self.target then
            self.stop = true
        end
    end
end

function MoveAction:continue()
    return not self.stop
end

return MoveAction
