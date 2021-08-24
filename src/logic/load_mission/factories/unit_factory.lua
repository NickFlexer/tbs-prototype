---
-- unit_factory.lua


local class = require "middleclass"

local Unit = require "repositories.units.dto.unit"

local Position = require "utils.position"
local IdGenerator = require "utils.id_generator"


local UnitFactory = class("UnitFactory")

function UnitFactory:initialize(data)
    if not data.map_settings_repository then
        error("UnitFactory:initialize(): no data.map_settings_repository argument!")
    end

    self.map_settings_repository = data.map_settings_repository
end

function UnitFactory:get_trooper(unit_data)
    local tile_size = self.map_settings_repository:get_tile_size()
    local raw_x, raw_y = unit_data:get_position():get()
    local x_pos = (raw_x - 1) * tile_size
    local y_pos = (raw_y - 1) * tile_size

    local trooper = Unit({
        id = IdGenerator:get_new_id(),
        type = unit_data:get_type(),
        team = unit_data:get_team(),
        position = Position(x_pos, y_pos)
    })

    return trooper
end

return UnitFactory
