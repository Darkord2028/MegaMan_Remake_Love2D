local EntityComponent = require("engine.ecs.entityComponent")
local Vec2 = require("engine.math.vec2")

local TransformComponent = EntityComponent:extend()
TransformComponent.__name = "TransformComponent"

function TransformComponent:new()
	self.position = Vec2(0, 0)
	self.localPosition = Vec2(0, 0)
	self.rotation = 0
	self.scale = Vec2(1, 1)
	self.parent = nil
end

function TransformComponent:setLocalPosition(localX, localY)
	self.localPosition = Vec2(localX, localY)
end

function TransformComponent:update(dt)
	if self.parent then
		self.position.x = self.parent.position.x + self.localPosition.x
		self.position.y = self.parent.position.y + self.localPosition.y
	end
end

return TransformComponent
