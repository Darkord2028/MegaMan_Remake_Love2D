local Object = require("engine.core.object")

local World = Object:extend()
World.__name = "World"

function World:new()
	self.entities = {}
end

function World:addEntity(entity)
	table.insert(self.entities, entity)
end

function World:update(dt)
	for _, entity in ipairs(self.entities) do
		entity:update(dt)
	end
end

function World:draw()
	for _, entity in ipairs(self.entities) do
		entity:draw()
	end
end

return World
