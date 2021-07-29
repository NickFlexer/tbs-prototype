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

    if not data.x then
        error("Unit:initialize(): no data.x argument!")
    end

    if not data.y then
        error("Unit:initialize(): no data.y argument!")
    end

    self.name = data.name
    self.team = data.team
    self.pos_x = data.x
    self.pos_y = data.y

    self.action_left = true
end

function Unit:get_name()
    return self.name
end

function Unit:get_position()
    return self.pos_x, self.pos_y
end

function Unit:get_team()
    return self.team
end

function Unit:is_action_left()
    return self.action_left
end

return Unit