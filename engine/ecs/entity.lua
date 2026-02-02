local Object = require("engine.core.object")

local Entity = Object:extend()

function Entity:new()
	self.components = {}
end

-- COMPONENT MANAGEMENT

function Entity:addComponent(component)
	assert(component.__name, "Component must have __name")
	component.entity = self
	self.components[component.__name] = component
end

function Entity:getComponent(name)
	return self.components[name]
end

function Entity:hasComponent(name)
	return self.components[name] ~= nil
end

-- LIFECYCLE

function Entity:update(dt)
	for _, component in pairs(self.components) do
		if component.update then
			component:update(dt)
		end
	end
end

function Entity:draw()
	for _, component in pairs(self.components) do
		if component.draw then
			component:draw()
		end
	end
end

return Entity
