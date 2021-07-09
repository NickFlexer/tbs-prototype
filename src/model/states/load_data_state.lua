---
-- load_data_state.lua


local class = require "middleclass"

local BaseState = require "model.states.base_state"

local GameLoadedEvent = require "event_manager.events.game_loaded_event"


local LoadDataState = class("LoadDataState", BaseState)

function LoadDataState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(LoadDataState)

    self.actions = {}
    self.index = nil

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

function LoadDataState:_loading_end(owner)
    owner:get_event_manager():post(GameLoadedEvent())
end

return LoadDataState