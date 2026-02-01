local World = { entities = {} }

function World.add(entity)
	table.insert(World.entities, entity)
end

function World.update(dt)
	for _, e in ipairs(World.entities) do
		e:update(dt)
	end
end

function World.draw()
	for _, e in ipairs(World.entities) do
		e:draw()
	end
end

return World
