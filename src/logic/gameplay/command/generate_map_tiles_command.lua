---
-- generate_map_tiles_command.lua


local class = require "middleclass"

local BaseCommand = require "logic.gameplay.command.base_command"

local DrawableCell = require "logic.gameplay.dto.drawable_cell"
local Position = require "utils.position"


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

        local tile = DrawableCell({
            position = Position((cell_x - 1) * tile_size, (cell_y - 1) * tile_size),
            tiles = {cell:get_terrain()}
        })

        table.insert(tiles, tile)
    end

    return tiles
end

return GenerateMapTilesCommand
