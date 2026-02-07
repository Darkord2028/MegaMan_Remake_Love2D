local Entity = require("engine.ecs.entity")
local Vec2   = require("engine.math.vec2")
local Event  = require("engine.core.event")

local TransformComponent      = require("engine.components.transformComponent")
local SpriteRendererComponent = require("engine.components.spriteRendererComponent")
local AnimatorComponent       = require("engine.components.animatorComponent")
local WindComponent           = require("engine.components.windComponent")
local InputComponent          = require("engine.components.inputComponent")

local SpriteSheet = require("engine.graphics.spriteSheet")
local playerData  = require("game.player.playerData")

local Player = Entity:extend()
Player.__name = "Player"

function Player:new(x, y)
    Entity.new(self)

    -- SPRITE SHEET
    local sheet = SpriteSheet.new("playerSheet", 40, 40)

    -- TRANSFORM
    self.transform = TransformComponent()
    self:addComponent(self.transform)
    self.transform.position = Vec2(x, y)
    self.transform.scale    = Vec2(1, 1)

    -- RENDERER
    self.renderer = SpriteRendererComponent(sheet:getImage())
    self:addComponent(self.renderer)
    self.renderer:setOrderInLayer(0)

    -- ANIMATOR
    self.animator = AnimatorComponent(sheet)
    self:addComponent(self.animator)

    local grid = sheet:getGrid()
    self.animator:addAnimation("idle", grid("1-5", 1), 0.25)
    self.animator:addAnimation("run",  grid("1-8", 2), 0.08)
    self.animator:play("idle")

    self.currentAnim = "idle"

    -- PHYSICS (DYNAMIC BODY)
    self.wind = WindComponent(15, 27)
    self.wind:setOffset(-2, 5)
    self.wind:setBodyType("dynamic") -- 🔥 REQUIRED
    self:addComponent(self.wind)

    self.collider = nil

    -- INPUT
    self.input = InputComponent()
    self:addComponent(self.input)
    self:HandleInputEvent()

    self.input:addAction("move_left"):bindKey("a")
    self.input:addAction("move_right"):bindKey("d")
    self.input:addAction("jump"):bindKey("w")

    -- STATE
    self.facing      = 1
    self.moveDir     = 0
    self.isGrounded  = false

    -- VELOCITY
    self.vx = 0
    self.vy = 0

    -- JUMP SYSTEM
    self.jumpHeld        = false
    self.jumpBufferTimer = 0
    self.coyoteTimer     = 0
end

function Player:onEnable()
    Entity.onEnable(self)

    self.collider = self.wind:getCollider()

    if self.world then
        self.world:setCameraTarget(self)
    end
end

function Player:update(dt)
    Entity.update(self, dt)

    -- Read velocity
    self.vx, self.vy = self.collider:getLinearVelocity()

    local grounded = false

    if self.collider:enter("solid") then
        grounded = true
        self.coyoteTimer = playerData.coyoteTime
    elseif self.collider:stay("solid") then
        grounded = true
    end

    self.isGrounded = grounded

    if self.jumpBufferTimer > 0 and self.coyoteTimer > 0 then
        self.vy = -playerData.jumpForce
        self.jumpBufferTimer = 0
        self.coyoteTimer = 0
        self.isGrounded = false
    end

    self.coyoteTimer     = math.max(self.coyoteTimer - dt, 0)
    self.jumpBufferTimer = math.max(self.jumpBufferTimer - dt, 0)

    if not self.isGrounded then
        local gravity = playerData.gravity

        if self.vy < 0 and not self.jumpHeld then
            gravity = gravity * playerData.lowJumpMultiplier
        elseif self.vy > 0 then
            gravity = gravity * playerData.fallGravityMultiplier
        end

        self.vy = self.vy + gravity * dt
    else
        self.vy = math.max(self.vy, 0)
    end

    self:HandleMovement(dt)

    self.collider:setLinearVelocity(self.vx, self.vy)
    self.vx, self.vy = self.collider:getLinearVelocity()
    print(self.vx, self.vy)
end

function Player:HandleInputEvent()
    Event.on("input:started", function(entity, action)
        if entity ~= self then return end

        if action == "jump" then
            self.jumpBufferTimer = playerData.jumpBufferTime
            self.jumpHeld = true
        end
    end)

    Event.on("input:cancelled", function(entity, action)
        if entity ~= self then return end

        if action == "jump" then
            self.jumpHeld = false
        end
    end)
end

function Player:HandleMovement(dt)
    local left  = self.input.actions["move_left"]  and self.input.actions["move_left"].isDown
    local right = self.input.actions["move_right"] and self.input.actions["move_right"].isDown

    if left and not right then
        self.moveDir = -1
        self.facing = -1
    elseif right and not left then
        self.moveDir = 1
        self.facing = 1
    else
        self.moveDir = 0
    end

    self.vx = playerData.movementSpeed * self.moveDir

    if self.moveDir == 0 then
        self.currentAnim = "idle"
    else
        self.currentAnim = "run"
    end

    self.animator:play(self.currentAnim)
    self.renderer.flipX = self.facing < 0
end

return Player
