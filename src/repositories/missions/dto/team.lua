---
-- team.lua


local class = require "middleclass"


local Team = class("Team")

function Team:initialize(data)
    self.name = data.name
    self.owner = data.owner
end

function Team:get_name()
    return self.name
end

function Team:get_owner()
    return self.owner
end

return Team
