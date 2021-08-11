---
-- animation_state.lua


local class = require "middleclass"
local Timer = require "hump.timer"

local BaseState = require "model.states.base_state"

local UpdateUnitsViewEvent = require "event_manager.events.update_units_view_event"
local StartGameplayEvent = require "event_manager.events.start_gameplay_event"


local AnimationState = class("AnimationState", BaseState)

function AnimationState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(AnimationState)

    self.timer = Timer.new()
    self.first_start = nil
    self.last_start = nil
end

function AnimationState:enter(owner)
    self.first_start = true
    self.last_start = false
end

function AnimationState:execute(owner, dt, game_data, game_logic, tile_size)
    if self.first_start then
        self.first_start = false

        local action = game_logic:get_next_action()

        self.timer:every(
            0.05,
            function ()
                action:iterate(tile_size)

                owner:get_event_manager():post(UpdateUnitsViewEvent())

                if not action:continue() then
                    self.last_start = true

                    return false
                end

                return true
            end
        )
    end

    self.timer:update(dt)

    if self.last_start then
        owner:get_event_manager():post(StartGameplayEvent())
    end
end

function AnimationState:exit(owner)
    -- body
end

function AnimationState:notify(owner, event)

end

return AnimationState