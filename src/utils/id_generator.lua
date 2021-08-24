---
-- id_generator.lua


local class = require "middleclass"


local IdGenerator = class("IdGenerator")

local id = 1

function IdGenerator:initialize()
    -- body
end

function IdGenerator.static:get_new_id()
    local res_id = id

    id = id + 1

    return res_id
end

return IdGenerator
