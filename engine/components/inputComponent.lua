local EntityComponent = require("engine.ecs.entityComponent")
local Event = require("engine.core.event")
local InputAction = require("engine.input.inputAction")

local InputComponent = EntityComponent:extend()
InputComponent.__name = "InputComponent"

function InputComponent:new()
	self.actions = {}
end

function InputComponent:addAction(name)
	local action = InputAction.new(name)
	self.actions[name] = action
	return action
end

function InputComponent:update(dt)
	for name, action in pairs(self.actions) do
		local downNow = action:isPressed()
		local wasDown = action.isDown

		if downNow and not wasDown then
			Event.emit("input:started", self.entity, name)
		end

		if downNow then
			Event.emit("input:triggered", self.entity, name)
		end

		if not downNow and wasDown then
			Event.emit("input:cancelled", self.entity, name)
		end

		action.isDown = downNow
	end
end

return InputComponent
