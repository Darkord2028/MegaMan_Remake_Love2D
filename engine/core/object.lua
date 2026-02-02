local Class = require("engine.core.class")
local Object = Class:extend()

function Object:new()
    self.id = tostring(self)
end
