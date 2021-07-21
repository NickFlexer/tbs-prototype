---
-- unit_factory.lua


local class = require "middleclass"

local Unit = require "world.unit"

local Units = require "data.enums.units"


local UnitFactory = class("UnitFactory")

function UnitFactory:initialize(data)
    -- body
end

function UnitFactory:get_trooper(team, unit_data)
    local trooper = Unit({
        name = Units.trooper,
        team = team,
        x = unit_data.position.x,
        y = unit_data.position.y
    })

    return trooper
end

return UnitFactory
