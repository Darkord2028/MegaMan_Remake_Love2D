local World = require("engine.ecs.world")
local Player = require("game.player.player")

local PlayState = {}

function PlayState:enter()
	World.entities = {}
	World.add(Player())
end

function PlayState:update(dt)
	World.update(dt)
end

function PlayState:draw()
	World.draw()
end

return PlayState
