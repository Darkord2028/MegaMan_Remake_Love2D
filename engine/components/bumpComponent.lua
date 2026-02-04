local EntityComponent = require("engine.ecs.entityComponent")
local WorldManager = require("engine.managers.worldManager")

local BumpComponent = EntityComponent:extend()
BumpComponent.__name = "BumpComponent"

function BumpComponent:new(width, height)
    self.width = width
    self.height = height
    self.offsetX = 0
    self.offsetY = 0
    self.solid = true
end

function BumpComponent:setSize(width, height, offsetX, offsetY)
    self.width = width
    self.height = height
    self.offsetX = offsetX or 0
    self.offsetY = offsetY or 0
end

function BumpComponent:getWorld()
    return self.entity.world
end

function BumpComponent:move(goalX, goalY, filter)
    local world = self:getWorld()
    if not world or not world.physicsWorld then
        print("World is nil")
        return goalX, goalY, {}, 0
    end
    
    if not world.physicsWorld:hasItem(self.entity) then
        return goalX, goalY, {}, 0
    end

    local transform = self.entity:getComponent("TransformComponent")
    if not transform then
        return goalX, goalY, {}, 0
    end

    filter = filter or function(item, other)
        local otherBump = other:getComponent("BumpComponent")
        if otherBump and otherBump.solid then
            return "slide"
        end
        return nil
    end

    local colliderX = goalX - self.width  / 2 + self.offsetX
    local colliderY = goalY - self.height / 2 + self.offsetY

    local actualX, actualY, cols, len =
        world.physicsWorld:move(
            self.entity,
            colliderX,
            colliderY,
            filter
        )

    -- convert back to center
    transform.position.x = actualX + self.width  / 2 - self.offsetX
    transform.position.y = actualY + self.height / 2 - self.offsetY


    return
    actualX + self.width  / 2 - self.offsetX,
    actualY + self.height / 2 - self.offsetY,
    cols,
    len

end

function BumpComponent:check(x, y, filter)
    local world = self:getWorld()
    if not world or not world.physicsWorld then
        return nil, 0
    end

    if not world.physicsWorld:hasItem(self.entity) then
        return nil, 0
    end

    filter = filter or function(item, other)
        local otherBump = other:getComponent("BumpComponent")
        if otherBump and otherBump.solid then
            return "slide"
        end
        return nil
    end

    return world.physicsWorld:check(
        self.entity,
        x + self.offsetX,
        y + self.offsetY,
        filter
    )
end

function BumpComponent:getPhysicsRect()
    local world = self:getWorld()
    if not world or not world.physicsWorld then
        return nil
    end

    if not world.physicsWorld:hasItem(self.entity) then
        return nil
    end

    return world.physicsWorld:getRect(self.entity)
end

function BumpComponent:syncToPhysics()
    local world = self:getWorld()
    if not world or not world.physicsWorld then
        return
    end

    if not world.physicsWorld:hasItem(self.entity) then
        return
    end

    local transform = self.entity:getComponent("TransformComponent")
    if not transform then
        return
    end

    -- world.physicsWorld:update(
    --     self.entity,
    --     transform.position.x + self.offsetX,
    --     transform.position.y + self.offsetY,
    --     self.width,
    --     self.height
    -- )
end

return BumpComponent