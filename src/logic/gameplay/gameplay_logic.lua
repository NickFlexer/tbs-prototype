---
-- gameplay_logic.lua


local class = require "middleclass"

local DrawableCell = require "logic.gameplay.dto.drawable_cell"

local Position = require "utils.position"


local GameplayLogic = class("GameplayLogic")

function GameplayLogic:initialize(data)
    if not data.navigator then
        error("GameplayLogic:initialize(): no data.navigator argument!")
    end

    if not data.map_repository then
        error("GameplayLogic:initialize(): no data.map_repository argument!")
    end

    if not data.map_settings_repository then
        error("GameplayLogic:initialize(): no data.map_settings_repository argument!")
    end

    self.navigator = data.navigator
    self.map_repository = data.map_repository
    self.map_settings_repository = data.map_settings_repository

    self.map_update = true
end

function GameplayLogic:is_map_update()
    if self.map_update then
        self.map_update = false

        return true
    end

    return self.map_update
end

function GameplayLogic:get_full_map_size()
    local map_x, map_y = self.map_repository:get_size()
    local tile_size = self.map_settings_repository:get_tile_size()

    return map_x * tile_size, map_y * tile_size
end

function GameplayLogic:get_all_map_tiles()
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

function GameplayLogic:get_tile_size()
    return self.map_settings_repository:get_tile_size()
end

return GameplayLogic
