local EntityComponent= require("engine.ecs.entityComponent")

local RenderComponent = EntityComponent:extend()

function RenderComponent:new(size)
    self.size = size or 20
end