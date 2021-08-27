---
-- game.lua


local class = require "middleclass"

local FrameTypes = require "frames.frame_types"

local DummyFrame = require "frames.dummy_frame.dummy_frame"
local LoadMissionFrame = require "frames.load_mission_frame.load_mission_frame"
local GameplayFrame = require "frames.gameplay_frame.gameplay_frame"

local LoadMissionLogic = require "logic.load_mission.load_mission_logic"
local GameplayLogic = require "logic.gameplay.gameplay_logic"

local MissionRepository = require "repositories.missions.mission_repository"
local MapRepository = require "repositories.map.map_repository"
local MapSettingsRepository = require "repositories.game_settings.map_settings_repository"
local TeamsRepository = require "repositories.teams.teams_repository"
local UnitsRepository = require "repositories.units.units_repository"
local ScenarioRepository = require "repositories.scenarios.scenario_repository"

local ViewContext = require "logic.gameplay.view_context"


local Game = class("Game")

function Game:initialize()
    self.current_frame = nil

    self.mission_repository = nil
    self.map_repository = nil
    self.map_settings_repository = nil
    self.teams_repository = nil
    self.units_repository = nil
    self.scenario_repository = nil
end

function Game:on_launched()
    self.mission_repository = MissionRepository()

    self:navigate_to(FrameTypes.load_mission)
end

function Game:navigate_to(frame_type, when_done_action)
    local frame = self:_create_frame(frame_type)

    if when_done_action then
        frame:when_done(when_done_action)
    end

    self.current_frame = frame
end

function Game:get_current_frame()
    return self.current_frame
end

function Game:_create_frame(frame_type)
    if frame_type == FrameTypes.dummy then
        local frame = DummyFrame()

        return frame
    end

    if frame_type == FrameTypes.load_mission then
        self.map_repository = MapRepository()
        self.teams_repository = TeamsRepository()
        self.units_repository = UnitsRepository()
        self.map_settings_repository = MapSettingsRepository()
        self.scenario_repository = ScenarioRepository()

        local frame = LoadMissionFrame({
            logic = LoadMissionLogic({
                navigator = self,
                mission_repository = self.mission_repository,
                map_repository = self.map_repository,
                teams_repository = self.teams_repository,
                units_repository = self.units_repository,
                map_settings_repository = self.map_settings_repository,
                scenario_repository = self.scenario_repository
            })
        })

        return frame
    end

    if frame_type == FrameTypes.gameplay then
        local view_context = ViewContext({
            map_repository = self.map_repository,
            map_settings_repository = self.map_settings_repository,
            units_repository = self.units_repository
        })

        local frame = GameplayFrame({
            view_context = view_context,
            logic = GameplayLogic({
                navigator = self,
                map_repository = self.map_repository,
                map_settings_repository = self.map_settings_repository,
                units_repository = self.units_repository,
                scenario_repository = self.scenario_repository,
                teams_repository = self.teams_repository,
                view_context = view_context
            })
        })

        return frame
    end
end

return Game
