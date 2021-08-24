---
-- unit.lua


local class = require "middleclass"


local Unit = class("Unit")

function Unit:initialize(data)
    self.type = data.type
    self.position = data.position
    self.team = data.team
end

function Unit:get_type()
    return self.type
end

function Unit:get_position()
    return self.position
end

function Unit:get_team()
    return self.team
end

return Unit
