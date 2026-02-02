local InputAction = {}
InputAction.__index = InputAction

function InputAction.new(name)
	return setmetatable({
		name = name,
		keys = {},
		isDown = false,
	}, InputAction)
end

function InputAction:bindKey(key)
	table.insert(self.keys, key)
end

function InputAction:isPressed()
	for _, key in ipairs(self.keys) do
		if love.keyboard.isDown(key) then
			return true
		end
	end
	return false
end

return InputAction
