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

local GameData = require "data.game_data"


local engine
local button_controller
local cursor_controller
local viewer


function love.load()
    local tile_size = 64

    local logger = Logger()

    local event_manager = EventManager({
        logger = logger
    })

    engine = GameEngine({
        event_manager = event_manager,
        game_data = GameData({
            logger = logger
        })
    })

    button_controller = ButtonController({
        event_manager = event_manager
    })

    cursor_controller = CursorController({
        event_manager = event_manager,
        tile_size = tile_size
    })

    viewer = Viewer({
        event_manager = event_manager,
        model = engine,
        drawer = TileDrawer({
            file_path = "res/img/tileset01.png",
            tile_size = tile_size
        }),
        tile_size = tile_size
    })
end


function love.update(dt)
    if not engine:is_running() then
        engine:init()
    end

    cursor_controller:update()
    engine:update()
end


function love.draw()
    viewer:render_all()
end
