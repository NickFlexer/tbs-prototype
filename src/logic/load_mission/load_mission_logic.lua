---
-- load_mission_logic.lua


local class = require "middleclass"

local FrameTypes = require "frames.frame_types"

local CellFactory = require "logic.load_mission.factories.cell_factory"
local TeamFactory = require "logic.load_mission.factories.team_factory"
local UnitFactory = require "logic.load_mission.factories.unit_factory"

local InitializeScenarionCommand = require "logic.gameplay.command.initialize_scenarion_command"


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

    if not data.teams_repository then
        error("LoadMissionLogic:initialize(): no data.teams_repository argument!")
    end

    if not data.units_repository then
        error("LoadMissionLogic:initialize(): no data.units_repository argument!")
    end

    if not data.map_settings_repository then
        error("LoadMissionLogic:initialize(): no data.map_settings_repository argument!")
    end

    if not data.scenario_repository then
        error("LoadMissionLogic:initialize(): no data.scenario_repository argument!")
    end

    self.navigator = data.navigator
    self.mission_repository = data.mission_repository
    self.map_repository = data.map_repository
    self.teams_repository = data.teams_repository
    self.units_repository = data.units_repository
    self.map_settings_repository = data.map_settings_repository
    self.scenario_repository = data.scenario_repository

    self.actions = {}
    self.index = nil

    table.insert(self.actions, self._load_map)
    table.insert(self.actions, self._load_teams)
    table.insert(self.actions, self._load_units)
    table.insert(self.actions, self._load_scenario)
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

        if terrain == "~" then
            cell = cell_factory:get_water(x, y)
        end

        if terrain == "." then
            cell = cell_factory:get_ground(x, y)
        end

        self.map_repository:set_cell(x, y, cell)
    end
end

function LoadMissionLogic:_load_teams()
    local team_factory = TeamFactory()

    local mission = self.mission_repository:get_test_mission()
    local mission_teams = mission:get_teams()

    for _, mission_team in ipairs(mission_teams) do
        self.teams_repository:add_team(
            team_factory:get_new_team(mission_team)
        )
    end
end

function LoadMissionLogic:_load_units()
    local unit_factory = UnitFactory({
        map_settings_repository = self.map_settings_repository
    })

    local mission = self.mission_repository:get_test_mission()
    local mission_units = mission:get_units()

    for _, mission_unit in ipairs(mission_units) do
        if mission_unit:get_type() == "trooper" then
            self.units_repository:add(
                unit_factory:get_trooper(mission_unit)
            )
        end
    end
end

function LoadMissionLogic:_load_scenario()
    local mission = self.mission_repository:get_test_mission()
    local mission_teams = mission:get_teams()

    for _, team in ipairs(mission_teams) do
        self.scenario_repository:add_phase(team:get_name())
    end
end

function LoadMissionLogic:_loading_finish()
    self.navigator:navigate_to(
        FrameTypes.gameplay,
        InitializeScenarionCommand({
            scenario_repository = self.scenario_repository
        })
    )
end

return LoadMissionLogic
