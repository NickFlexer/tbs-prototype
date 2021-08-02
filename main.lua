---
-- main.lua


package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


local Logger = require "utils.logger"

local TileDrawer = require "view.tile_drawer"

local GameEngine = require "model.game_engine"
local EventManager = require "event_manager.event_manager"
local ButtonController = require "controller.button_controller"
local CursorController = require "controller.cursor_controller"
local Viewer = require "view.viewer"
local UIViewer = require "view.ui_viewer"

local GameData = require "data.game_data"
local GameLogic = require "logic.game_logic"

local HumanTeamControl = require "logic.team_control.human_team_control"


local engine
local button_controller
local cursor_controller
local viewer
local ui_viewer


function love.load()
    local tile_size = 64

    local shift = {
        x = 0,
        y = 32
    }

    local logger = Logger()

    local event_manager = EventManager({
        logger = logger
    })

    engine = GameEngine({
        event_manager = event_manager,
        game_data = GameData({
            logger = logger
        }),
        game_logic = GameLogic({
            logger = logger,
            event_manager = event_manager,
            human_control = HumanTeamControl()
        })
    })

    button_controller = ButtonController({
        event_manager = event_manager
    })

    cursor_controller = CursorController({
        event_manager = event_manager,
        tile_size = tile_size,
        shift = shift
    })

    viewer = Viewer({
        event_manager = event_manager,
        model = engine,
        drawer = TileDrawer({
            file_path = "res/img/tileset01.png",
            tile_size = tile_size
        }),
        tile_size = tile_size,
        shift = shift
    })

    ui_viewer = UIViewer({
        event_manager = event_manager
    })
end


function love.update(dt)
    if not engine:is_running() then
        engine:init()
    end

    cursor_controller:update(dt)
    engine:update()
    viewer:update(dt)
    ui_viewer:update(dt)
end


function love.draw()
    viewer:render_all()
    ui_viewer:render_all()
end

function love.mousepressed(x, y, button, istouch)
    cursor_controller:mouse_pressed()
end
