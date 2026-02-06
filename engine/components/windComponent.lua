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