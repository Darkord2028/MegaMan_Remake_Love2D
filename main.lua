local AssetManager  = require("assets.src.assetManager")
local AssetManifest = require("assets.src.assetManifest")
local TestWorld     = require("game.worlds.testWorld")

local world

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    AssetManager.loadManifest(AssetManifest)
    world = TestWorld()
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end
