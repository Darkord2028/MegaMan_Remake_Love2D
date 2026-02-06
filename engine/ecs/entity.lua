local Object = require("engine.core.object")

local Entity = Object:extend()
Entity.__name = "Entity"

function Entity:new()
	self.components = {}
	self.enabled = true
	self.children = {}
	self.parent = nil
end

-- COMPONENT MANAGEMENT

function Entity:addComponent(component)
	assert(component.__name, "Component must have __name")

	component.entity = self
	component.enabled = component.enabled ~= false
	self.components[component.__name] = component
end

function Entity:addChild(childEntity)
	table.insert(self.children, childEntity)
	childEntity.parent = self
	
	if self.transform and childEntity.transform then
		childEntity.transform.parent = self.transform
	end
end

function Entity:getChildByName(childName)
	for _, child in ipairs(self.childEntity) do
		if child.__name == childName then
			return child
		end
	end
	return nil
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

	for _, child in ipairs(self.children) do
		if child.onEnable then child:onEnable() end
	end
end

function Entity:onDisable()
	self.enabled = false
	for _, component in pairs(self.components) do
		if component.onDisable then component:onDisable() end
	end

	for _, child in ipairs(self.children) do
		if child.onDisable then child:onDisable() end
	end
end

function Entity:update(dt)
	if not self.enabled then return end

	for _, component in pairs(self.components) do
		if component.update and component.enabled ~= false then
			component:update(dt)
		end
	end

	for _, child in ipairs(self.children) do
		if child.update then child:update(dt) end

		if child.transform and self.transform then
			child.transform.position.x = self.transform.position.x + (child.transform.localX or 0)
			child.transform.position.y = self.transform.position.y + (child.transform.localY or 0)
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

	for _, child in ipairs(self.children) do
		if child.draw then child:draw() end
	end

end


function Entity:destroy()
	self:onDisable()

    for _, component in pairs(self.components) do
        if component.destroy then
            component:destroy()
        end
    end

	for _, child in ipairs(self.children) do
		if child.destroy then child:destroy() end
	end

    self.components = {}
    self.enabled = false
    self._destroyed = true
	self.children = {}
end

function Entity:setEnabled(value)
	if self.enabled == value then return end
	if value then
		self:onEnable()
	else
		self:onDisable()
	end
end


return Entity
