local Entity = require("engine.ecs.entity")
local Vec2   = require("engine.math.vec2")
local Event = require("engine.core.event")

local TransformComponent = require("engine.components.transformComponent")
local SpriteRendererComponent = require("engine.components.spriteRendererComponent")
local AnimatorComponent = require("engine.components.animatorComponent")
local InputComponent = require("engine.components.inputComponent")

local SpriteSheet = require("engine.graphics.spriteSheet")

local Player = Entity:extend()
Player.__name = "Player"

function Player:new(x, y)
    Entity.new(self)

    -- SPRITE SHEET
    local playerSheet = SpriteSheet.new("playerSheet", 40, 40)

    -- TRANSFORM
    local transform = TransformComponent()
    transform.position = Vec2(x, y)
    transform.scale = Vec2(2, 2)
    self:addComponent(transform)

    -- RENDERER
    local renderer = SpriteRendererComponent(playerSheet:getImage())
    self:addComponent(renderer)
    self.renderer = renderer

    -- ANIMATOR
    local animator = AnimatorComponent(playerSheet)
    self:addComponent(animator)
    self.animator = animator

    -- ANIMATIONS
    local grid = playerSheet:getGrid()
    animator:addAnimation("idle", grid("1-5", 1), 0.15)
    animator:addAnimation("run",  grid("1-8", 2), 0.08)
    animator:play("idle")

    -- INPUT
    local input = InputComponent()
    self:addComponent(input)
    self.input = input

    -- Input Actions
    local moveLeft = input:addAction("move_left")
    moveLeft:bindKey("a")
    moveLeft:bindKey("left")

    local moveRight = input:addAction("move_right")
    moveRight:bindKey("d")
    moveRight:bindKey("right")

    self.moveDir = 0
    self.speed   = 140
    self.facing  = 1

    Event.on("input:started", function(entity, action)
        if entity ~= self then return end

        if action == "move_left" then
            self.moveDir = -1
            self.facing = -1
            self.animator:play("run")
        elseif action == "move_right" then
            self.moveDir = 1
            self.facing = 1
            self.animator:play("run")
        end
    end)


    Event.on("input:cancelled", function(entity, action)
        if entity ~= self then return end

        if action == "move_left" or action == "move_right" then
            self.moveDir = 0
            self.animator:play("idle")
        end
    end)

end

return Player
