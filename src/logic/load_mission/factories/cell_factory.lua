---
-- cell_factory.lua


local class = require "middleclass"

local Cell = require "repositories.map.dto.cell"

local TerrainTypes = require "repositories.map.enums.terrain_types"

local Position = require "utils.position"


local CellFactory = class("CellFactory")

function CellFactory:initialize(data)
    -- body
end

function CellFactory:get_water(x, y)
    local water = Cell({
        terrain = TerrainTypes.water,
        position = Position(x, y)
    })

    return water
end

function CellFactory:get_ground(x, y)
    local ground = Cell({
        terrain = TerrainTypes.ground,
        position = Position(x, y)
    })

    return ground
end

return CellFactory
