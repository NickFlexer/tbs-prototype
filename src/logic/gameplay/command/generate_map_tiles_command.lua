---
-- generate_map_tiles_command.lua


local class = require "middleclass"

local BaseCommand = require "logic.gameplay.command.base_command"

local DrawableCell = require "logic.gameplay.dto.drawable_cell"
local Position = require "utils.position"

local TerrainTypes = require "repositories.map.enums.terrain_types"


local function ternary(cond , T , F)
    if cond then return T else return F end
end


local GenerateMapTilesCommand = class("GenerateMapTilesCommand", BaseCommand)

function GenerateMapTilesCommand:initialize(data)
    BaseCommand.initialize(self)
    self:check_abstract_methods(GenerateMapTilesCommand)

    if not data.map_repository then
        error("GenerateMapTilesCommand:initialize(): no data.map_repository argument!")
    end

    if not data.map_settings_repository then
        error("GenerateMapTilesCommand:initialize(): no data.map_settings_repository argument!")
    end

    self.map_repository = data.map_repository
    self.map_settings_repository = data.map_settings_repository
end

function GenerateMapTilesCommand:execute()
    local cells = self.map_repository:get_all_cells()
    local tile_size = self.map_settings_repository:get_tile_size()

    local tiles = {}

    for _, cell in ipairs(cells) do
        local cell_x, cell_y = cell:get_position():get()

        local terrain_tile = nil

        if cell:get_terrain() == TerrainTypes.water then
            terrain_tile = self:_solve_water_tiles(cell_x, cell_y   )
        else
            terrain_tile = cell:get_terrain()
        end

        local tile = DrawableCell({
            position = Position((cell_x - 1) * tile_size, (cell_y - 1) * tile_size),
            tiles = {terrain_tile}
        })

        table.insert(tiles, tile)
    end

    return tiles
end

function GenerateMapTilesCommand:_solve_water_tiles(x, y)
    local T = self:_terrain_at(TerrainTypes.ground, x, y - 1)
    local L = self:_terrain_at(TerrainTypes.ground, x - 1, y)
    local R = self:_terrain_at(TerrainTypes.ground, x + 1, y)
    local B = self:_terrain_at(TerrainTypes.ground, x, y + 1)

    local TL = ternary((T ~= 0 or L ~= 0), 0, self:_terrain_at(TerrainTypes.ground, x - 1, y - 1))
    local TR = ternary((T ~= 0 or R ~= 0), 0, self:_terrain_at(TerrainTypes.ground, x + 1, y - 1))
    local BL = ternary((B ~= 0 or L ~= 0), 0, self:_terrain_at(TerrainTypes.ground, x - 1, y + 1))
    local BR = ternary((B ~= 0 or R ~= 0), 0, self:_terrain_at(TerrainTypes.ground, x + 1, y + 1))

    local neigh_data = TL * 1 + T * 2 + TR * 4 + L * 8 + R * 16 + BL * 32 + B * 64 + BR * 128

    return (TerrainTypes.water .. "_" .. tostring(neigh_data))
end

function GenerateMapTilesCommand:_terrain_at(terrain, x, y)
    if not self.map_repository:get_cell(x, y) then
        return 0
    end

    if self.map_repository:get_cell(x, y):get_terrain() == terrain then
        return 1
    else
        return 0
    end
end

return GenerateMapTilesCommand
