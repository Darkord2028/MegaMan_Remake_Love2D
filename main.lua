local Time = require("engine.core.time")
local Input = require("engine.input.input")
local StateManager = require("engine.state.stateManager")

local PlayState = require("game.player.playerState")

function love.load()
	StateManager.switch(PlayState)
end

function love.update(dt)
	Time.update(dt)
	Input.update()
	StateManager.update(dt)
end

function love.draw()
	StateManager.draw()
end

function love.keypressed(key)
	Input.keyPressed(key)
end

function love.keyreleased(key)
	Input.keyReleased(key)
end
