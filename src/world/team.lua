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

    if not data.enimy then
        error("Team:initialize(): no data.enimy argument!")
    end

    self.name = data.name
    self.owner = data.owner
    self.enimy = data.enimy
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

function Team:get_enimy()
    return self.enimy
end

function Team:unselect_all()
    for _, unit in ipairs(self.units) do
        unit:unselect()
    end
end

function Team:get_selected_unit()
    for _, unit in ipairs(self.units) do
        if unit:is_selected() then
            return unit
        end
    end
end

return Team
