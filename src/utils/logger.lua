---
-- logger.lua


local class = require "middleclass"


local Logger = class("Logger")

function Logger:initialize(data)
    -- body
end

function Logger:debug(msg)
    print(os.date("%d.%m.%Y %H:%M:%S") .. " [DEBUG] " .. tostring(msg))
end

return Logger
