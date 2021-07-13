---
-- map_cell_factory.lua


local class = require "middleclass"

local Cell = require "world.cell"
local Terrain = require "data.enums.terrains"


local MapCellFactory = class("MapCellFactory")

function MapCellFactory:initialize(data)
    -- body
end

function MapCellFactory:get_water()
    local water = Cell({
        terrain = Terrain.water
    })

    return water
end

function MapCellFactory:get_ground()
    local ground = Cell({
        terrain = Terrain.ground
    })

    return ground
end

return MapCellFactory
