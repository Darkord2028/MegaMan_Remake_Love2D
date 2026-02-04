local Entity = require("engine.ecs.entity")
local Vec2   = require("engine.math.vec2")
local Event = require("engine.core.event")

local TransformComponent = require("engine.components.transformComponent")
local SpriteRendererComponent = require("engine.components.spriteRendererComponent")
local AnimatorComponent = require("engine.components.animatorComponent")
local BumpComponent = require("engine.components.bumpComponent")
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
    self.transform = transform
    transform.position = Vec2(x, y)
    transform.scale = Vec2(2, 2)
    self:addComponent(transform)

    -- RENDERER
    local renderer = SpriteRendererComponent(playerSheet:getImage())
    self:addComponent(renderer)
    self.renderer = renderer
    self.renderer:setOrderInLayer(0)

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
    self.bump:setSize(28, 53, 0, 12)

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

    -- Movement variables
    self.moveDir = 0
    self.speed   = 140
    self.facing  = 1
    self.velocityY = 0
    self.gravity = 800
    self.jumpForce = 350
    self.isGrounded = false

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

function Player:onEnable()
    Entity.onEnable(self)

    if self.world then
        self.world:setCameraTarget(self)
    end
end

function Player:update(dt)
    Entity.update(self, dt)
    
    local transform = self:getComponent("TransformComponent")
    if not transform then return end

    -- Apply gravity
    --self.velocityY = self.velocityY + self.gravity * dt

    -- Calculate movement
    local dx = self.moveDir * self.speed * dt
    local dy = self.velocityY * dt

    -- Goal position
    local goalX = transform.position.x + dx
    local goalY = transform.position.y + dy

    -- Move with collision detection
    local actualX, actualY, cols, len = self.bump:move(goalX, goalY)

    -- Handle collisions
    self.isGrounded = false
    for i = 1, len do
        local col = cols[i]
        
        -- Hit ground (normal pointing up)
        if col.normal.y == -1 then
            self.velocityY = 0
            self.isGrounded = true
        end
        
        -- Hit ceiling (normal pointing down)
        if col.normal.y == 1 then
            self.velocityY = 0
        end
    end

    if self.renderer then
        self.renderer.flipX = self.facing < 0
    end

end

return Player