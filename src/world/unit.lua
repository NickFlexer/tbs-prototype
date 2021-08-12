---
-- unit.lua


local class = require "middleclass"


local Unit = class("Unit")

function Unit:initialize(data)
    if not data.name then
        error("Unit:initialize(): no data.name argument!")
    end

    if not data.team then
        error("Unit:initialize(): no data.team argument!")
    end

    if not data.move then
        error("Unit:initialize(): no data.move argument!")
    end

    self.name = data.name
    self.team = data.team
    self.pos_x = nil
    self.pos_y = nil
    self.move = data.move

    self.action_left = true

    self.selected = false
end

function Unit:get_name()
    return self.name
end

function Unit:get_position()
    return self.pos_x, self.pos_y
end

function Unit:set_position(x, y)
    self.pos_x, self.pos_y = x, y
end

function Unit:get_team()
    return self.team
end

function Unit:end_action()
    self.action_left = false
end

function Unit:reset_action()
    self.action_left = true
end

function Unit:is_action_left()
    return self.action_left
end

function Unit:get_move()
    return self.move
end

function Unit:select()
    self.selected = true
end

function Unit:unselect()
    self.selected = false
end

function Unit:is_selected()
    return self.selected
end

return Unit
