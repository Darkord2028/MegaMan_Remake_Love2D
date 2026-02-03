local Object = require("engine.core.object")
local Camera = require("engine.graphics.camera")

local World = Object:extend()
World.__name = "World"

function World:new()
	self.entities = {}
    self.enabled = true
	self.mainCamera = Camera.new(0, 0, 1)
end

function World:addEntity(entity)
	table.insert(self.entities, entity)

    if self.enabled then
        entity:onEnable()
    end
end

function World:onEnable()
    self.enabled = true
    
    for _, entity in ipairs(self.entities) do
        entity:onEnable()
    end
end

function World:onDisable()
    self.enabled = false

    for _, entity in ipairs(self.entities) do
        entity:onDisable()
    end
end

function World:update(dt)
    if not self.enabled then return end

    for _, entity in ipairs(self.entities) do
        entity:update(dt)
    end

    if self.mainCamera.update then
        self.mainCamera:update(dt)
    end
end


function World:draw()
    if not self.enabled then return end

    self.mainCamera:attach()

    if self.gameMap then
        self.gameMap:draw()
    end

    local renderers = {}

    for _, entity in ipairs(self.entities) do
        local renderer = entity:getComponent("SpriteRendererComponent")
        if renderer and renderer.visible then
            table.insert(renderers, renderer)
        end
    end

    table.sort(renderers, function(a, b)
        return a:getSortKey() < b:getSortKey()
    end)

    for _, renderer in ipairs(renderers) do
        renderer:draw()
    end

    self.mainCamera:detach()
end

function World:destroy()
    self:onDisable()

    for _, entity in ipairs(self.entities) do
        entity:destroy()
    end

    self.entities = {}
    self.enabled = false
end


function World:setCameraTarget(entity)
	self.mainCamera:follow(entity)
end

return World
