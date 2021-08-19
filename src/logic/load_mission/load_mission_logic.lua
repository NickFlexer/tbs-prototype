---
-- load_mission_logic.lua


local class = require "middleclass"

local FrameTypes = require "frames.frame_types"
local TerrainTypes = require "repositories.map.enums.terrain_types"

local CellFactory = require "logic.load_mission.factories.cell_factory"


local LoadMissionLogic = class("LoadMissionLogic")

function LoadMissionLogic:initialize(data)
    if not data.navigator then
        error("LoadMissionLogic:initialize(): no data.navigator argument!")
    end

    if not data.mission_repository then
        error("LoadMissionLogic:initialize(): no data.mission_repository argument!")
    end

    if not data.map_repository then
        error("LoadMissionLogic:initialize(): no data.map_repository argument!")
    end

    self.navigator = data.navigator
    self.mission_repository = data.mission_repository
    self.map_repository = data.map_repository

    self.actions = {}
    self.index = nil

    table.insert(self.actions, self._load_map)
    table.insert(self.actions, self._loading_finish)
end

function LoadMissionLogic:load_mission()
    local func
    self.index, func = next(self.actions, self.index)

    if self.index then
        func(self)
    end
end

function LoadMissionLogic:_load_map()
    local cell_factory = CellFactory()

    local mission = self.mission_repository:get_test_mission()
    self.map_repository:set_size(mission:get_map():get_size())

    local map_cells = mission:get_map():get_cells()

    for _, map_cell in ipairs(map_cells) do
        local terrain = map_cell:get_content()
        local position = map_cell:get_position()

        local x, y = position:get()
        local cell = nil

        if terrain == TerrainTypes.water then
            cell = cell_factory:get_water(x, y)
        end

        if terrain == TerrainTypes.ground then
            cell = cell_factory:get_ground(x, y)
        end

        self.map_repository:set_cell(x, y, cell)
    end
end

function LoadMissionLogic:_loading_finish()
    self.navigator:navigate_to(FrameTypes.dummy)
end

return LoadMissionLogic
