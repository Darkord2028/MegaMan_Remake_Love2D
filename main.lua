local AssetManager  = require("engine.managers.assetManager")
local AssetManifest = require("assets.src.assetManifest")
local Game = require("game.game")

local game

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    AssetManager.loadManifest(AssetManifest)
    
    game = Game.new()
    game:loadWorld("test")
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
