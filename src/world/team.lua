---
-- team.lua


local class = require "middleclass"


local Team = class("Team")

function Team:initialize(data)
    if not data.name then
        error("Team:initialize(): no data.name argument!")
    end

    if not data.owner then
        error("Team:initialize(): no data.owner argument!")
    end

    self.name = data.name
    self.owner = data.owner
    self.units = {}
end

function Team:get_name()
    return self.name
end

function Team:get_owner()
    return self.owner
end

function Team:add_unit(unit)
    table.insert(self.units, unit)
end

function Team:get_units()
    return self.units
end

return Team
