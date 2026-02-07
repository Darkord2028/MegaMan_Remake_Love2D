local Object = require("engine.core.object")
local Camera = require("engine.vendor.camera")
local Windfield = require("engine.vendor.windfield")
local MathUtils = require("engine.math.utils")

local World = Object:extend()
World.__name = "World"

function World:new()
    self.entities = {}
    self.enabled = true

    self.mainCamera = Camera(0, 0, 1, 0, Camera.smooth.damped(5))
    self.cameraTarget = nil
    self.cameraOffset = { x = 0, y = 0 }
    self.cameraOffsetTarget = { x = 0, y = 0}
    self.cameraLookAhead = 100
    self.cameraOffsetSpeed = 10
    
    self.physicsWorld = Windfield.newWorld()
    self.physicsWorld:addCollisionClass("solid")
    self.physicsWorld:addCollisionClass("player", { ignores = { "player" } })

    self.groundColliders = {}
end

function World:addEntity(entity)
    table.insert(self.entities, entity)
    entity.world = self

    if self.enabled then
        entity:onEnable()
    end

end

function World:removeEntity(entity)
    
    local wind = entity:getComponent("WindComponent")
    if wind and wind.collider then
        wind.collider:destroy()
        wind.collider = nil
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

    if self.gameMap.layers["GroundCollider"] then
        for i, obj in ipairs(self.gameMap.layers["GroundCollider"].objects) do
            local collider = self.physicsWorld:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collider:setType("static")
            collider:setCollisionClass("solid")
            table.insert(self.groundColliders, collider)
        end
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

    self.physicsWorld:update(dt)

    for _, entity in ipairs(self.entities) do
        entity:update(dt)
    end
    
    self:updateCamera()
end

function World:draw()
    if not self.enabled then return end

    self.mainCamera:attach()

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

    if self.physicsWorld then
        self.physicsWorld:draw(1)
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
    
    if self.physicsWorld then
        self.physicsWorld = nil
    end
end

function World:getPhysicsWorld()
    return self.physicsWorld
end

function World:setCameraTarget(entity)
    self.cameraTarget = entity
end

function World:setCameraOffset(x, y)
    self.cameraOffset.x = x
    self.cameraOffset.y = y
end

function World:updateCamera()
    if not self.cameraTarget or not self.gameMap then return end

    local pos = self.cameraTarget.transform.position

    if self.cameraTarget.facing then
        self.cameraOffsetTarget.x =
            self.cameraTarget.facing * self.cameraLookAhead
    end

    self.cameraOffset.x = MathUtils.lerp(
        self.cameraOffset.x,
        self.cameraOffsetTarget.x,
        love.timer.getDelta() * self.cameraOffsetSpeed
    )

    local mapW = self.gameMap.width  * self.gameMap.tilewidth
    local mapH = self.gameMap.height * self.gameMap.tileheight

    local halfW = VIRTUAL_WIDTH  / 2
    local halfH = VIRTUAL_HEIGHT / 2

    local camX = MathUtils.clamp(
        pos.x + self.cameraOffset.x,
        halfW,
        mapW - halfW
    )

    local camY = MathUtils.clamp(
        pos.y + self.cameraOffset.y,
        halfH,
        mapH - halfH
    )

    self.mainCamera:lockPosition(camX, camY)
end

return World