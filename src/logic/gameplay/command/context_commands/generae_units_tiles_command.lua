---
-- generae_units_tiles_command.lua


local class = require "middleclass"

local DrawableCell = require "logic.gameplay.dto.drawable_cell"

local BaseCommand = require "logic.gameplay.command.base_command"


local GeneraeUnitsTilesCommand = class("GeneraeUnitsTilesCommand", BaseCommand)

function GeneraeUnitsTilesCommand:initialize(data)
    BaseCommand.initialize(self)
    self:check_abstract_methods(GeneraeUnitsTilesCommand)

    if not data.units_repository then
        error("GameplayLogic:initialize(): no data.units_repository argument!")
    end

    self.units_repository = data.units_repository
end

function GeneraeUnitsTilesCommand:execute()
    local result_units = {}
    local all_units = self.units_repository:get_all()

    for _, unit in ipairs(all_units) do
        local result_unit = DrawableCell({
            position = unit:get_position(),
            tiles = {
                tostring(unit:get_team() .. "_" .. unit:get_type())
            }
        })

        table.insert(result_units, result_unit)
    end

    return result_units
end

return GeneraeUnitsTilesCommand
