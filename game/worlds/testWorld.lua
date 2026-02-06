local World = require("engine.ecs.world")
local Player = require("game.player.player")
local Enemy = require("game.enemy.enemy")

local sti = require("engine.vendor.sti")

local TestWorld = World:extend()
TestWorld.__name = "TestWorld"

function TestWorld:new()
    World.new(self)
    
    self.gameMap = sti('assets/maps/laboratory/laboratory.lua')

    local player = Player(50, 220)
    self:addEntity(player)

    for _, child in ipairs(player.children) do
        if child then
            self:addEntity(child)
        end
    end

    self:setCameraTarget(player)

end

return TestWorld
