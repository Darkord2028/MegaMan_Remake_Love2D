local Input = {
	keys = {},
	mouse = {},
}

function Input.update()
	Input.mouse.x, Input.mouse.y = love.mouse.getPosition()
end

function Input.keyPressed(key)
	Input.keys[key] = true
end

function Input.keyReleased(key)
	Input.keys[key] = false
end

function Input.isDown(key)
	return love.keyboard.isDown(key)
end

return Input
