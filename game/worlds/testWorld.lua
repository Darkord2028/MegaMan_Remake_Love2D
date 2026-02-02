local World = require("engine.ecs.world")
local Player = require("game.player.player")

local TestWorld = World:extend()
TestWorld.__name = "TestWorld"

function TestWorld:new()
    World:new()
    local player = Player(500, 500)
    self:addEntity(player)
end

return TestWorld
