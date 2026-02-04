local Object = require("engine.core.object")
local Camera = require("engine.vendor.humpCamera")
local Bump = require("engine.vendor.bump")

local World = Object:extend()
World.__name = "World"

function World:new()
    self.entities = {}
    self.enabled = true

    self.mainCamera = Camera(0, 0, 1)
    
    self.physicsWorld = nil
end

function World:addEntity(entity)
    table.insert(self.entities, entity)
    entity.world = self

    if self.enabled then
        entity:onEnable()
    end

    local bump = entity:getComponent("BumpComponent")
    local transform = entity:getComponent("TransformComponent")

    if bump and transform and self.physicsWorld then
        self.physicsWorld:add(
            entity,
            transform.position.x - bump.width / 2 + bump.offsetX,
            transform.position.y - bump.height / 2 + bump.offsetY,
            bump.width,
            bump.height
        )
    end
end

function World:removeEntity(entity)
    if self.physicsWorld and self.physicsWorld:hasItem(entity) then
        self.physicsWorld:remove(entity)
    end
    
    for i, e in ipairs(self.entities) do
        if e == entity then
            table.remove(self.entities, i)
            break
        end
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

    --self.mainCamera:attach()

    if self.gameMap then
        for _, layer in ipairs(self.gameMap.layers) do
            self.gameMap:drawLayer(layer)
        end
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

    self:drawPhysics()

    --self.mainCamera:detach()
end

function World:destroy()
    self:onDisable()

    for _, entity in ipairs(self.entities) do
        entity:destroy()
    end

    self.entities = {}
    self.enabled = false
    
    if self.physicsWorld then
        self.physicsWorld = nil
    end
end

function World:drawPhysics()
    if not self.physicsWorld then return end
    
    for _, item in ipairs(self.physicsWorld:getItems()) do
        local x, y, w, h = self.physicsWorld:getRect(item)
        love.graphics.setColor(1, 0, 0, 0.4)
        love.graphics.rectangle("line", x, y, w, h)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function World:queryRect(x, y, w, h, filter)
    if not self.physicsWorld then return {} end
    return self.physicsWorld:queryRect(x, y, w, h, filter)
end

function World:queryPoint(x, y, filter)
    if not self.physicsWorld then return {} end
    return self.physicsWorld:queryPoint(x, y, filter)
end

function World:setCameraTarget(entity)
    self.mainCamera:lookAt(entity.transform.position.x, entity.transform.position.y)
end

function World:setPhysicsWorld(cellSize)
    self.physicsWorld = Bump.newWorld(cellSize or 16)
end

return World