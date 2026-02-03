local World = require("engine.ecs.world")
local Player = require("game.player.player")

local sti = require("engine.vendor.sti")

local TestWorld = World:extend()
TestWorld.__name = "TestWorld"

function TestWorld:new()
    World.new(self)

    local player = Player(500, 500)
    self:addEntity(player)

    self:setCameraTarget(player)
end

return TestWorld
