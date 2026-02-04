local World = require("engine.ecs.world")
local Player = require("game.player.player")

local sti = require("engine.vendor.sti")

local TestWorld = World:extend()
TestWorld.__name = "TestWorld"

function TestWorld:new()
    World.new(self)
    
    self.gameMap = sti('assets/maps/laboratory/laboratory.lua')
    self:setPhysicsWorld(16)

    local player = Player(500, 500)
    self:addEntity(player)

end

return TestWorld
