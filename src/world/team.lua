---
-- team.lua


local class = require "middleclass"


local Team = class("Team")

function Team:initialize(data)
    if not data.name then
        error("Team:initialize(): no data.name argument!")
    end

    self.name = data.name
end

function Team:get_name()
    return self.name
end

return Team
