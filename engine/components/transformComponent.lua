local EntityComponent = require("engine.ecs.entityComponent")
local Vec2 = require("engine.math.vec2")

local TransformComponent = EntityComponent:extend()

function TransformComponent:new()
    self.position = Vec2(0, 0)
    self.rotation = 0
    self.scale = Vec2(1, 1)
end

return TransformComponent