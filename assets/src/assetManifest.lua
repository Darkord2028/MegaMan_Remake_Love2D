local Assets = require("engine.assets.AssetManager")
local SpriteSheet = require("engine.graphics.spriteSheet")

local Manifest = {}

function Manifest.loadPlayerAssets()
	Assets.loadImage("playerSpriteSheet", "Character_SpriteSheet(40x40).png")
end

function Manifest.loadPlayerAnimations()
	Manifest.playerSpriteSheet = SpriteSheet.new("playerSpriteSheet", 40, 40)

	local grid = Manifest.playerSpriteSheet:getGrid()

	Manifest.playerAnimations = {
		idle = { grid("1-5", 1), 0.15 },
		run = { grid("1-8", 2), 0.08 },
		jump = { grid("1-4", 5), 0.10 },
	}
end

return Manifest
