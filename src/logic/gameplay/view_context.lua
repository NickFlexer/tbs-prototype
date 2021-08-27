---
-- view_context.lua


local class = require "middleclass"

local GenerateMapTilesCommand = require "logic.gameplay.command.context_commands.generate_map_tiles_command"
local GeneraeUnitsTilesCommand = require "logic.gameplay.command.context_commands.generae_units_tiles_command"


local ViewContext = class("ViewContext")

function ViewContext:initialize(data)
    if not data.map_repository then
        error("ViewContext:initialize(): no data.map_repository argument!")
    end

    if not data.map_settings_repository then
        error("ViewContext:initialize(): no data.map_settings_repository argument!")
    end

    if not data.units_repository then
        error("ViewContext:initialize(): no data.units_repository argument!")
    end

    self.map_repository = data.map_repository
    self.map_settings_repository = data.map_settings_repository
    self.units_repository = data.units_repository

    self.map_update = false
    self.units_update = false
end

function ViewContext:update_map()
    self.map_update = true
end

function ViewContext:is_map_update()
    if self.map_update then
        self.map_update = false

        return true
    end

    return self.map_update
end

function ViewContext:update_units()
    self.units_update = true
end

function ViewContext:is_units_update()
    if self.units_update then
        self.units_update = false

        return true
    end

    return self.units_update
end

function ViewContext:get_all_map_tiles()
    local command = GenerateMapTilesCommand({
        map_settings_repository = self.map_settings_repository,
        map_repository = self.map_repository
    })

    return command:execute()
end

function ViewContext:get_all_unit_tiles()
    local command = GeneraeUnitsTilesCommand({
        units_repository = self.units_repository
    })

    return command:execute()
end

function ViewContext:get_tile_size()
    return self.map_settings_repository:get_tile_size()
end

return ViewContext
