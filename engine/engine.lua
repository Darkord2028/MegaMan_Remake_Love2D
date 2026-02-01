local Engine = {}

Engine.systems = {}

function Engine.add(system)
	table.insert(Engine.systems, system)
end

function Engine.update(dt)
	for _, sys in ipairs(Engine.systems) do
		if sys.update then
			sys:update(dt)
		end
	end
end

function Engine.draw()
	for _, sys in ipairs(Engine.systems) do
		if sys.draw then
			sys:draw()
		end
	end
end

return Engine
