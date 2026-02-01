local Entity = require("engine.ecs.entity")
local Input = require("engine.input.input")

local Player = Entity:extend()

function Player:new()
	self.position = { x = 200, y = 200 }
	self.speed = 200
end

function Player:update(dt)
	if Input.isDown("a") then
		self.position.x = self.position.x - self.speed * dt
	end
	if Input.isDown("d") then
		self.position.x = self.position.x + self.speed * dt
	end
end

function Player:draw()
	love.graphics.rectangle("fill", self.position.x, self.position.y, 32, 32)
end

return Player
