local Object = require("engine.core.object")
local TransformComponent = require("engine.components.TransformComponent")

local Entity = Object:extend()

function Entity:new()
	self.components = {}

	-- Mandotary TransformComponent
	self:addComponent(TransformComponent())
end

-- COMPONENT MANAGEMENT

function Entity:addComponent(component)
	component.entity = self
	table.insert(self.components, component)
	return component
end

function Entity:getComponent(componentName)
	for _, component in ipairs(self.components) do
		if component.__name == componentName then
			return component
		end
	end
	return nil
end

function Entity:hasComponent(componentName)
	return self:getComponent(componentName) ~= nil
end

-- LIFECYCLE

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
