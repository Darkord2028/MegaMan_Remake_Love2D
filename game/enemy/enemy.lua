local Entity = require("engine.ecs.entity")
local Vec2   = require("engine.math.vec2")

local TransformComponent = require("engine.components.transformComponent")
local SpriteRendererComponent = require("engine.components.spriteRendererComponent")
local AnimatorComponent = require("engine.components.animatorComponent")
local BumpComponent = require("engine.components.bumpComponent")

local SpriteSheet = require("engine.graphics.spriteSheet")

local Enemy = Entity:extend()
Enemy.__name = "Player"

function Enemy:new(x, y)
    Entity.new(self)

    -- SPRITE SHEET
    local playerSheet = SpriteSheet.new("playerSheet", 40, 40)

    -- TRANSFORM
    local transform = TransformComponent()
    transform.position = Vec2(x, y)
    transform.scale = Vec2(1, 1)
    self:addComponent(transform)

    -- RENDERER
    local renderer = SpriteRendererComponent(playerSheet:getImage())
    self:addComponent(renderer)
    self.renderer = renderer
    self.renderer:setOrderInLayer(1)

    -- ANIMATOR
    local animator = AnimatorComponent(playerSheet)
    self:addComponent(animator)
    self.animator = animator

    -- ANIMATIONS
    local grid = playerSheet:getGrid()
    animator:addAnimation("idle", grid("1-5", 1), 0.15)
    animator:addAnimation("run",  grid("1-8", 2), 0.08)
    animator:play("idle")

    -- PHYSICS
    local bump = BumpComponent(10, 10)
    self:addComponent(bump)
    self.bump = bump
    self.bump:setSize(18, 26, 0, 6)

end

return Enemy
