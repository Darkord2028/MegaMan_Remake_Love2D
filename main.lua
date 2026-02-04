local Push = require("engine.vendor.push")
local AssetManager  = require("engine.managers.assetManager")
local AssetManifest = require("assets.src.assetManifest")
local Game = require("game.game")

local game

VIRTUAL_WIDTH = 320 * 2
VIRTUAL_HEIGHT = 180 * 2

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    Push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        love.graphics.getWidth(),
        love.graphics.getHeight(),
        {
            fullscreen = false,
            resizable = false,
            pixelperfect = true,
            highdpi = false,
            canvas = true
        }
    )

    love.window.setMode(0, 0, {
        fullscreen = false,
        borderless = true
    })
    
    AssetManager.loadManifest(AssetManifest)

    game = Game.new()
    game:loadWorld("laboratory")

end

function love.update(dt)
    game:update(dt)
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.draw()
    Push:start()
        game:draw()
    Push:finish()
end
