local AssetManager = {
	images = {},
	sounds = {},
	fonts = {},
	quads = {},
}

-- INTERNAL LOADERS

local function assertExists(path)
	assert(love.filesystem.getInfo(path), "ASSET NOT FOUND: " .. path)
end

-- IMAGE

function AssetManager.loadImage(name, path)
	if AssetManager.images[name] then
		return AssetManager.images[name]
	end

	assertExists(path)
	AssetManager.images[name] = love.graphics.newImage(path)
	return AssetManager.images[name]
end

function AssetManager.getImage(name)
	assert(AssetManager.images[name], "IMAGE NOT LOADED: " .. name)
	return AssetManager.images[name]
end

-- SOUND

function AssetManager.loadSound(name, path, type)
	if AssetManager.sounds[name] then
		return AssetManager.sounds[name]
	end

	assertExists(path)
	AssetManager.sounds[name] = love.audio.newSource(path, type or "static")
	return AssetManager.sounds[name]
end

function AssetManager.getSound(name)
	assert(AssetManager.sounds[name], "SOUND NOT LOADED: " .. name)
	return AssetManager.sounds[name]:clone()
end

-- FONT

function AssetManager.loadFont(name, path, size)
	AssetManager.fonts[name] = AssetManager.fonts[name] or {}
	if AssetManager.fonts[name][size] then
		return AssetManager.fonts[name][size]
	end

	assertExists(path)
	AssetManager.fonts[name][size] = love.graphics.newFont(path, size)
	return AssetManager.fonts[name][size]
end

function AssetManager.getFont(name, size)
	assert(
		AssetManager.fonts[name] and AssetManager.fonts[name][size],
		"FONT NOT LOADED: " .. name .. " (" .. size .. ")"
	)
	return AssetManager.fonts[name][size]
end

-- QUADS

function AssetManager.createQuad(name, imageName, x, y, w, h)
	local image = AssetManager.getImage(imageName)
	AssetManager.quads[name] = love.graphics.newQuad(x, y, w, h, image:getWidth(), image:getHeight())
end

function AssetManager.getQuad(name)
	assert(AssetManager.quads[name], "QUAD NOT FOUND: " .. name)
	return AssetManager.quads[name]
end

-- CLEANUP

function AssetManager.clear()
	AssetManager.images = {}
	AssetManager.sounds = {}
	AssetManager.fonts = {}
	AssetManager.quads = {}
end

return AssetManager
