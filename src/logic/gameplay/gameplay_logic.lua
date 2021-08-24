---
-- gameplay_logic.lua


local class = require "middleclass"

local GenerateMapTilesCommand = require "logic.gameplay.command.generate_map_tiles_command"
local GeneraeUnitsTilesCommand = require "logic.gameplay.command.generae_units_tiles_command"


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

    if not data.units_repository then
        error("GameplayLogic:initialize(): no data.units_repository argument!")
    end

    self.navigator = data.navigator
    self.map_repository = data.map_repository
    self.map_settings_repository = data.map_settings_repository
    self.units_repository = data.units_repository

    self.map_update = true
    self.units_update = true
end

function GameplayLogic:is_map_update()
    if self.map_update then
        self.map_update = false

        return true
    end

    return self.map_update
end

function GameplayLogic:is_units_update()
    if self.units_update then
        self.units_update = false

        return true
    end

    return self.units_update
end

function GameplayLogic:get_full_map_size()
    local map_x, map_y = self.map_repository:get_size()
    local tile_size = self.map_settings_repository:get_tile_size()

    return map_x * tile_size, map_y * tile_size
end

function GameplayLogic:get_all_map_tiles()
    local command = GenerateMapTilesCommand({
        map_settings_repository = self.map_settings_repository,
        map_repository = self.map_repository
    })

    return command:execute()
end

function GameplayLogic:get_all_unit_tiles()
    local command = GeneraeUnitsTilesCommand({
        units_repository = self.units_repository
    })

    return command:execute()
end

function GameplayLogic:get_tile_size()
    return self.map_settings_repository:get_tile_size()
end

return GameplayLogic
