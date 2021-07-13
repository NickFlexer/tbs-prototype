---
-- load_data_state.lua


local class = require "middleclass"

local BaseState = require "model.states.base_state"

local GameLoadedEvent = require "event_manager.events.game_loaded_event"
local UpdateMapViewEvent = require "event_manager.events.update_map_view_event"

local MapCellFactory = require "data.factories.map_cell_factory"
local MapData = require "data.map_data"


local LoadDataState = class("LoadDataState", BaseState)

function LoadDataState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(LoadDataState)

    self.actions = {}
    self.index = nil

    table.insert(self.actions, self._load_map)
    table.insert(self.actions, self._loading_end)
end

function LoadDataState:enter(owner)
    -- body
end

function LoadDataState:execute(owner, dt)
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
    local terrain_factory = MapCellFactory()

    local map_data = MapData({
        file_path = "res/map/test_map.json"
    })

    local map = owner:get_map()

    local size_x, size_y = map_data:get_size()

    map:new_map(size_x, size_y)

    local map_str = map_data:get_map_string()
    local x, y = 1, 1

    for row in map_str:gmatch("[^\n]+") do
        x = 1

        for tile in row:gmatch(".") do
            if tile == "~" then
                map:set_cell(x, y, terrain_factory:get_water())
            end

            if tile == "." then
                map:set_cell(x, y, terrain_factory:get_ground())
            end

            x = x + 1
        end

        y = y + 1
    end

    owner:get_event_manager():post(UpdateMapViewEvent())
end

function LoadDataState:_loading_end(owner)
    owner:get_event_manager():post(GameLoadedEvent())
end

return LoadDataState