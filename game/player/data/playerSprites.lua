local Assets = require("assets.src.assetManager")
local SpriteSheet = require("engine.graphics.spriteSheet")

local playerSheet = Assets.image("playerSheet")

return SpriteSheet.new(playerSheet, 40, 40)