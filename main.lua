---
-- main.lua


package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


local Logger = require "utils.logger"

local TileDrawer = require "view.tile_drawer"

local GameEngine = require "model.game_engine"
local EventManager = require "event_manager.event_manager"
local Controller = require "controller.controller"
local Viewer = require "view.viewer"


local engine
local controller
local viewer


function love.load()
    local tile_size = 64

    local logger = Logger()

    local event_manager = EventManager({
        logger = logger
    })

    engine = GameEngine({
        event_manager = event_manager
    })
    controller = Controller({
        event_manager = event_manager
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

    engine:update()
end


function love.draw()
    viewer:render_all()
end
