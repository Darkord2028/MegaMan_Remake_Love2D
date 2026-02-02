local Object = require("engine.core.object")
local TransformComponent = require("engine.components.transformComponent")

local Entity = Object:extend()

function Entity:new()
	self.components = {}

	self.transform = TransformComponent()
	self.transform.owner = self
end

function Entity:addComponent(component)
	component.owner = self
	table.insert(self.components, component)
end

function Entity:update(dt)
	for _, component in ipairs(self.components) do
		if component.update then
			component:update(dt)
		end
	end
end
function Entity:draw()
	for _, component in ipairs(self.components) do
		if component.draw then
			component:draw()
		end
	end
end

return Entity
