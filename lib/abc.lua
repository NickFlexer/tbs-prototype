---
-- abc.lua


local class = require "middleclass"


local ABC = class("ABC")

function ABC:initialize()
    self.abstractmethod = "__ABSTRACT_METHOD__"
    self.abstractmethods = {}
end

function ABC:set_abstract_methods(cls)
    for k, v in pairs(cls.__declaredMethods) do
        if k ~= "initialize" then
            if v(self) == self.abstractmethod then
                self.abstractmethods[k] = v
            end
        end
    end

    if not next(self.abstractmethods, nil) then
        error("No abstract methods found! All abstract methods must return self.abstractmethod")
    end
end

function ABC:check_abstract_methods(cls)
    local not_implemented_methods = {}

    for k, _ in pairs(self.abstractmethods) do
        if not cls.__declaredMethods[k] then
            table.insert(not_implemented_methods, k)
        end
    end

    if #not_implemented_methods > 0 then
        local str = ""

        for _, method_name in ipairs(not_implemented_methods) do
            str = str .. " " .. method_name .. ","
        end

        error("Can't instantiate abstract class " .. cls.name .. " with abstract methods [" .. str .. "]")
    end
end

return ABC
