local anim8 = require("engine.vendor.anim8")
local Assets = require("assets.src.assetManager")

local SpriteSheet = {}
SpriteSheet.__index = SpriteSheet

function SpriteSheet.new(imageName, frameW, frameH, left, top, border)
	local image = Assets.image(imageName)

	local grid = anim8.newGrid(frameW, frameH, image:getWidth(), image:getHeight(), left or 0, top or 0, border or 0)

	return setmetatable({
		image = image,
		grid = grid,
	}, SpriteSheet)
end

function SpriteSheet:getGrid()
	return self.grid
end

function SpriteSheet:getImage()
	return self.image
end

return SpriteSheet
