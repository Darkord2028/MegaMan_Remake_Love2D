local Class = require("engine.core.class")
local Entity = Class.extend()

function Entity:new()
	self.position = { x = 0, y = 0 }
end

function Entity:update(dt) end
function Entity:draw() end

return Entity
