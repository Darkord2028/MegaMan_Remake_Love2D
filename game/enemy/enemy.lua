local Entity = require("engine.ecs.entity")
local Vec2   = require("engine.math.vec2")

local TransformComponent = require("engine.components.transformComponent")
local SpriteRendererComponent = require("engine.components.spriteRendererComponent")
local AnimatorComponent = require("engine.components.animatorComponent")
local WindComponent = require("engine.components.windComponent")

local SpriteSheet = require("engine.graphics.spriteSheet")

local Enemy = Entity:extend()
Enemy.__name = "Enemy"

function Enemy:new(x, y)
    Entity.new(self)

    -- SPRITE SHEET
    local playerSheet = SpriteSheet.new("playerSheet", 40, 40)

    -- TRANSFORM
    local transform = TransformComponent()
    transform.position = Vec2(x, y)
    transform.scale = Vec2(1, 1)
    self:addComponent(transform)
    self.transform = transform

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

end

return Enemy
