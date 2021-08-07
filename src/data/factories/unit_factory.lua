---
-- unit_factory.lua


local class = require "middleclass"

local Unit = require "world.unit"

local Units = require "data.enums.units"


local UnitFactory = class("UnitFactory")

function UnitFactory:initialize(data)
    if not data.unit_data then
        error("UnitFactory:initialize(): no data.unit_data argument!")
    end

    self.unit_data = data.unit_data
end

function UnitFactory:get_trooper(team, unit_data)
    local trooper = Unit({
        name = Units.trooper,
        team = team,
        x = unit_data.position.x,
        y = unit_data.position.y,
        move = self.unit_data:get(Units.trooper).move
    })

    return trooper
end

return UnitFactory
