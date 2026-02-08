local Entity = require("engine.ecs.entity")
local Vec2 = require("engine.math.vec2")
local Event = require("engine.core.event")

local TransformComponent = require("engine.components.transformComponent")
local SpriteRendererComponent = require("engine.components.spriteRendererComponent")
local AnimatorComponent = require("engine.components.animatorComponent")
local WindComponent = require("engine.components.windComponent")
local InputComponent = require("engine.components.inputComponent")

local SpriteSheet = require("engine.graphics.spriteSheet")
local playerData = require("game.player.playerData")

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
	self.transform.scale = Vec2(1, 1)

	-- RENDERER
	self.renderer = SpriteRendererComponent(sheet:getImage())
	self:addComponent(self.renderer)
	self.renderer:setOrderInLayer(0)

	-- ANIMATOR
	self.animator = AnimatorComponent(sheet)
	self:addComponent(self.animator)

	local grid = sheet:getGrid()
	self.animator:addAnimation("idle", grid("1-5", 1), 0.25)
	self.animator:addAnimation("run", grid("1-8", 2), 0.08)
	self.animator:addAnimation("jump", grid("3-3", 5), 0.08, false)
	self.animator:play("idle")

	self.currentAnim = "idle"

	-- PHYSICS (DYNAMIC BODY)
	self.wind = WindComponent(15, 27)
	self.wind:setOffset(-2, 5)
	self.wind:setBodyType("dynamic")
	self:addComponent(self.wind)

	self.collider = nil

	-- INPUT
	self.input = InputComponent()
	self:addComponent(self.input)
	self:HandleInputEvent()

	self.input:addAction("move_left"):bindKey("a")
	self.input:addAction("move_right"):bindKey("d")
	local jump = self.input:addAction("jump")
	jump:bindKey("space")
	jump:bindKey("w")

	-- STATE
	self.facing = 1
	self.moveDir = 0
	self.isGrounded = false

	-- VELOCITY
	self.vx = 0
	self.vy = 0

	-- JUMP SYSTEM
	self.jumpPressed = false
	self.jumpHeld = false
	self.jumpBufferTimer = 0
	self.coyoteTimer = 0
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

	-- Ground check
	local wasGrounded = self.isGrounded
	self.isGrounded = self:checkIfGrounded()

	if self.isGrounded and not wasGrounded then
		self.coyoteTimer = playerData.coyoteTime
	end

	-- Jump
	if self.jumpPressed and self.isGrounded then
		self.vy = -playerData.jumpForce
		self.jumpPressed = false
		self.isGrounded = false
	end

	-- Gravity
	if not self.isGrounded then
		self.vy = self.vy + playerData.gravity * dt
	end

	if not self.isGrounded and self.jumpPressed then
		self.jumpPressed = false
	end

	-- Horizontal movement
	self:HandleMovement(dt)

	-- Apply velocity
	self.collider:setLinearVelocity(self.vx, self.vy)
end

function Player:HandleInputEvent()
	Event.on("input:started", function(entity, action)
		if entity ~= self then
			return
		end

		if action == "jump" then
			self.jumpPressed = true
			self.jumpBufferTimer = playerData.jumpBufferTime
			self.jumpHeld = true
		end
	end)

	Event.on("input:cancelled", function(entity, action)
		if entity ~= self then
			return
		end

		if action == "jump" then
			self.jumpHeld = false
		end
	end)
end

function Player:HandleMovement(dt)

	local left = self.input.actions["move_left"] and self.input.actions["move_left"].isDown
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

	if self.moveDir == 0 and self.isGrounded then
		self.currentAnim = "idle"
	elseif self.moveDir ~= 0 and self.isGrounded then
		self.currentAnim = "run"
	else
		self.currentAnim = "jump"
	end

	self.animator:play(self.currentAnim)
	self.renderer.flipX = self.facing < 0
end

function Player:checkIfGrounded()
	if not self.collider and not self.world then
		return false
	end

	local world = self.world:getPhysicsWorld()

	local cx, cy = self.collider:getPosition()
	
	local halfW = 15 / 2
	local halfH = 27 / 2

	local x1 = cx
	local y1 = cy + halfH
	local x2 = cx
	local y2 = y1 + playerData.groundRayLength

	local hit = false
	world:rayCast(x1, y1, x2, y2, function (fixture, hx, hy, nx, ny, fraction)
		local collider = fixture:getUserData()
		if collider and collider.collision_class == "solid" then
			if ny < -0.7 then
				hit = true
				return 0
			end
		end
		return 1
	end)

	return hit

end

return Player
