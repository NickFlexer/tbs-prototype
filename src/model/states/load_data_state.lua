---
-- load_data_state.lua


local class = require "middleclass"

local BaseState = require "model.states.base_state"

local GameLoadedEvent = require "event_manager.events.game_loaded_event"
local UpdateMapViewEvent = require "event_manager.events.update_map_view_event"
local UpdateUnitsViewEvent = require "event_manager.events.update_units_view_event"
local StartNewTurnEvent = require "event_manager.events.start_new_turn_event"

local MapCellFactory = require "data.factories.map_cell_factory"
local MapData = require "data.map_data"

local TeamFactory = require "data.factories.team_factory"
local UnitFactory = require "data.factories.unit_factory"

local Units = require "data.enums.units"


local LoadDataState = class("LoadDataState", BaseState)

function LoadDataState:initialize(data)
    if not data.terrain_data then
        error("LoadDataState:initialize(): no data.terrain_data argument!")
    end

    if not data.unit_data then
        error("LoadDataState:initialize(): no data.unit_data argument!")
    end

    if not data.tile_size then
        error("LoadDataState:initialize(): no data.tile_size argument!")
    end

    self.terrain_data = data.terrain_data
    self.unit_data = data.unit_data
    self.tile_size = data.tile_size

    BaseState.initialize(self)
    self:check_abstract_methods(LoadDataState)

    self.actions = {}
    self.index = nil

    table.insert(self.actions, self._load_map)
    table.insert(self.actions, self._load_units)
    table.insert(self.actions, self._loading_end)

    self.map_data = nil
end

function LoadDataState:enter(owner)
    -- body
end

function LoadDataState:execute(owner, game_data)
    local func
    self.index, func = next(self.actions, self.index)

    if self.index then
        func(self, owner)
    end
end

function LoadDataState:exit(owner)
    -- body
end

function LoadDataState:notify(owner, event)
    -- body
end

function LoadDataState:_load_map(owner)
    local terrain_factory = MapCellFactory({
        terrain_data = self.terrain_data
    })

    self.map_data = MapData({
        file_path = "res/map/test_map.json"
    })

    local map = owner:get_data():get_map()

    local size_x, size_y = self.map_data:get_size()

    map:new_map(size_x, size_y)

    local map_str = self.map_data:get_map_string()
    local x, y = 1, 1

    for row in map_str:gmatch("[^\n]+") do
        x = 1

        for tile in row:gmatch(".") do
            if tile == "~" then
                map:set_cell(x, y, terrain_factory:get_water(x, y))
            end

            if tile == "." then
                map:set_cell(x, y, terrain_factory:get_ground(x, y))
            end

            x = x + 1
        end

        y = y + 1
    end

    owner:get_event_manager():post(UpdateMapViewEvent())
end

function LoadDataState:_load_units(owner)
    local team_factory = TeamFactory()
    local unit_factory = UnitFactory({unit_data = self.unit_data})
    local game_data = owner:get_data()
    local logic = owner:get_logic()

    for _, new_team in ipairs(self.map_data:get_teams()) do
        local team = team_factory:new_team(new_team)
        game_data:add_new_team(team)
        logic:add_new_team(team)

        for _, unit_data in ipairs(new_team.units) do
            local new_unit = nil

            if unit_data.type == Units.trooper then
                new_unit = unit_factory:get_trooper(team, unit_data)
                new_unit:set_position(
                    (unit_data.position.x - 1) * self.tile_size,
                    (unit_data.position.y - 1) * self.tile_size
                )
            end

            game_data:add_new_unit(new_unit, team, unit_data.position.x, unit_data.position.y)
        end
    end

    owner:get_event_manager():post(UpdateUnitsViewEvent())
end

function LoadDataState:_loading_end(owner)
    owner:get_event_manager():post(GameLoadedEvent())
    owner:get_event_manager():post(StartNewTurnEvent())
end

return LoadDataState