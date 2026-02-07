local EntityComponent = require("engine.ecs.entityComponent")
local Windfield = require("engine.vendor.windfield")

local WindComponent = EntityComponent:extend()
WindComponent.__name = "WindComponent"

function WindComponent:new(width, height)
    self.width = width
    self.height = height 
    self.offsetX = 0
    self.offsetY = 0

    self.bodyType = "dynamic"
    self.collisionClass = "player"
    self.isSensor = false

    self.collider = nil
end

function WindComponent:onEnable()
    local world = self.entity.world
    if not world and not world.physicsWorld then return end

    local transform = self.entity:getComponent("TransformComponent")
    if not transform then return end

    local x = transform.position.x + self.offsetX
    local y = transform.position.y + self.offsetY

    local collider = world.physicsWorld:newRectangleCollider(
        x, y, self.width, self.height
    )

    collider:setType(self.bodyType)
    collider:setCollisionClass(self.collisionClass)
    collider:setSensor(self.isSensor)
    collider:setFixedRotation(true)
    collider:setObject(self.entity)

    self.collider = collider
    self.collider:enter("solid", function (collision)
        print("Collided with something")
    end)
end

function WindComponent:update(dt)
    if not self.collider then return end

    local transform = self.entity:getComponent("TransformComponent")
    if not transform then return end

    local x, y = self.collider:getPosition()
    transform.position.x = x - self.offsetX
    transform.position.y = y - self.offsetY
end

function WindComponent:onDisable()
    if self.collider then
        self.collider:destroy()
        self.collider = nil
    end
end

function WindComponent:setOffset(x, y)
    self.offsetX = x or 0
    self.offsetY = y or 0
end

function WindComponent:setBodyType(type)
    self.bodyType = type
end

function WindComponent:setSensor(sensor)
    self.isSensor = sensor
end

function WindComponent:getCollider()
    return self.collider
end

return WindComponent