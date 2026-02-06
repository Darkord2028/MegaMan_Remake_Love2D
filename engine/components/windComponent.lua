local EntityComponent = require("engine.ecs.entityComponent")
local Windfield = require("engine.vendor.windfield")

local WindComponent = EntityComponent:extend()
WindComponent.__name = "WindComponent"

function WindComponent:new(gravity)
    self.world = Windfield.newWorld(gravity.x, gravity.y)
end