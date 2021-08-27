---
-- mission_repository.lua


local class = require "middleclass"
local json = require "json.json"

local Mission = require "repositories.missions.dto.mission"
local Map = require "repositories.missions.dto.map"
local Cell = require "repositories.missions.dto.cell"
local Unit = require "repositories.missions.dto.unit"

local Team = require "repositories.missions.dto.team"

local Position = require "utils.position"


local MissionRepository = class("MissionRepository")

function MissionRepository:initialize(data)
    -- body
end

function MissionRepository:get_test_mission()
    local test_mission = Mission()

    local mission_data = self:_read_mission_data("res/map/test_map.json")

    local mission_map = Map({
        x = #mission_data.world.map[1],
        y = #mission_data.world.map
    })

    local map_string = self:_get_map_string(mission_data.world.map)

    local x, y = 1, 1

    for row in map_string:gmatch("[^\n]+") do
        x = 1

        for tile in row:gmatch(".") do
            mission_map:add_cell(
                Cell({
                    content = tile,
                    position = Position(x, y)
                })
            )

            x = x + 1
        end

        y = y + 1
    end

    test_mission:set_map(mission_map)

    local teams = mission_data.teams

    for _, team in ipairs(teams) do
        test_mission:add_team(
            Team({
                name = team.name,
                owner = team.owner
            })
        )
    end

    self:_get_all_units(test_mission, teams)

    return test_mission
end

function MissionRepository:_read_mission_data(file_path)
    local file = assert(io.open(file_path, "rb"))
    local content = file:read("*all")
    file:close()

    return json.decode(content)
end

function MissionRepository:_get_map_string(map_data)
    local map = ""

    for _, line in ipairs(map_data) do
        map = map .. line .. "\n"
    end

    return map
end

function MissionRepository:_get_all_units(mission, teams_data)
    for _, team in ipairs(teams_data) do
        for _, unit in ipairs(team.units) do
            local unit_data = Unit({
                type = unit.type,
                position = Position(unit.position.x, unit.position.y),
                team = team.name
            })

            mission:add_unit(unit_data)
        end
    end
end

return MissionRepository
