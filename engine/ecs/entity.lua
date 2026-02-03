local Object = require("engine.core.object")

local Entity = Object:extend()
Entity.__name = "Entity"

function Entity:new()
	self.components = {}
	self.enabled = true
end

-- COMPONENT MANAGEMENT

function Entity:addComponent(component)
	assert(component.__name, "Component must have __name")

	component.entity = self
	component.enabled = component.enabled ~= false
	self.components[component.__name] = component
end


function Entity:getComponent(name)
	return self.components[name]
end

function Entity:hasComponent(name)
	return self.components[name] ~= nil
end

-- LIFECYCLE

function Entity:onEnable()
	self.enabled = true
	for _, component in pairs(self.components) do
		if component.onEnable then component:onEnable() end
	end
end

function Entity:onDisable()
	self.enabled = false
	for _, component in pairs(self.components) do
		if component.onDisable then component:onDisable() end
	end
end

function Entity:update(dt)
	if not self.enabled then return end


	for _, component in pairs(self.components) do
		if component.update and component.enabled ~= false then
			component:update(dt)
		end
	end
end

function Entity:draw()
    if not self.enabled then return end

    for _, component in pairs(self.components) do
        if component.draw and component.enabled ~= false then
            component:draw()
        end
    end
end


function Entity:destroy()
	self:onDisable()

    for _, component in pairs(self.components) do
        if component.destroy then
            component:destroy()
        end
    end

    self.components = {}
    self.enabled = false
    self._destroyed = true
end

function Entity:setEnabled(value)
	if self.enabled == value then return end
	self.enabled = value

	if value then
		self:onEnable()
	else
		self:onDisable()
	end
end

return Entity
