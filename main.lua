---
-- main.lua


package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


local Logger = require "utils.logger"

local GameEngine = require "model.game_engine"
local EventManager = require "event_manager.event_manager"
local Controller = require "controller.controller"
local Viewer = require "view.viewer"


local engine
local controller
local viewer


function love.load()
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
        model = engine
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
