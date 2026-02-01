local Renderer = {
	drawables = {},
}

function Renderer.add(obj)
	table.insert(Renderer.drawables, obj)
end

function Renderer.draw()
	for _, obj in ipairs(Renderer.drawables) do
		obj:draw()
	end
end

return Renderer
