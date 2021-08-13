---
-- map_cell_factory.lua


local class = require "middleclass"

local Cell = require "world.cell"
local Terrain = require "data.enums.terrains"


local MapCellFactory = class("MapCellFactory")

function MapCellFactory:initialize(data)
    if not data.terrain_data then
        error("MapCellFactory:initialize(): no data.terrain_data argument!")
    end

    self.terrain_data = data.terrain_data
end

function MapCellFactory:get_water(x, y)
    local water = Cell({
        terrain = Terrain.water,
        move_cost = self.terrain_data:get(Terrain.water).mv_coast,
        position = {x = x, y = y}
    })

    return water
end

function MapCellFactory:get_ground(x, y)
    local ground = Cell({
        terrain = Terrain.ground,
        move_cost = self.terrain_data:get(Terrain.ground).mv_coast,
        position = {x = x, y = y}
    })

    return ground
end

return MapCellFactory
