---
-- team.lua


local class = require "middleclass"


local Team = class("Team")

function Team:initialize(data)
    self.name = data.name
end

function Team:get_name()
    return self.name
end

return Team
