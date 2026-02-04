local AssetManager  = require("engine.managers.assetManager")
local AssetManifest = require("assets.src.assetManifest")
local Game = require("game.game")

local game

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(false)
    AssetManager.loadManifest(AssetManifest)
    
    game = Game.new()
    game:loadWorld("laboratory")

end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
