local AssetManager = {
    images = {},
    sounds = {},
    fonts  = {},
}

-- Internal helpers

local function assertExists(path)
    assert(love.filesystem.getInfo(path), "ASSET NOT FOUND: " .. path)
end

-- Manifest loading

function AssetManager.loadManifest(manifest)
    -- Images
    for id, path in pairs(manifest.images or {}) do
        assertExists(path)
        AssetManager.images[id] = love.graphics.newImage(path)
    end

    -- Sounds
    for id, def in pairs(manifest.sounds or {}) do
        assertExists(def.path)
        AssetManager.sounds[id] =
            love.audio.newSource(def.path, def.type or "static")
    end

    -- Fonts
    for id, def in pairs(manifest.fonts or {}) do
        AssetManager.fonts[id] = AssetManager.fonts[id] or {}
        assertExists(def.path)
        AssetManager.fonts[id][def.size] =
            love.graphics.newFont(def.path, def.size)
    end
end

-- Getters (READ ONLY)

function AssetManager.image(id)
    assert(AssetManager.images[id], "IMAGE NOT LOADED: " .. id)
    return AssetManager.images[id]
end

function AssetManager.sound(id)
    assert(AssetManager.sounds[id], "SOUND NOT LOADED: " .. id)
    return AssetManager.sounds[id]:clone()
end

function AssetManager.font(id, size)
    assert(
        AssetManager.fonts[id] and AssetManager.fonts[id][size],
        "FONT NOT LOADED: " .. id .. " (" .. size .. ")"
    )
    return AssetManager.fonts[id][size]
end

-- Cleanup / reload

function AssetManager.clear()
    AssetManager.images = {}
    AssetManager.sounds = {}
    AssetManager.fonts  = {}
end

return AssetManager
