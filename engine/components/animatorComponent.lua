local EntityComponent = require("engine.ecs.entityComponent")
local anim8 = require("engine.vendor.anim8")

local AnimatorComponent = EntityComponent:extend()
AnimatorComponent.__name = "AnimatorComponent"

function AnimatorComponent:new(spriteSheet)
	self.sheet = spriteSheet
	self.animations = {}
	self.current = nil
end

function AnimatorComponent:addAnimation(name, frames, duration, onLoop)
	self.animations[name] = anim8.newAnimation(frames, duration, onLoop)
end

function AnimatorComponent:play(name, force)
	local anim = self.animations[name]
	if not anim then
		return
	end

	if not force and self.current == anim then
		return
	end

	self.current = anim
	self.current:gotoFrame(1)
	self.current:resume()
end

function AnimatorComponent:update(dt)
	if self.current then
		self.current:update(dt)
	end
end

function AnimatorComponent:getFrame()
	if not self.current then
		return nil
	end
	return self.current.frames[self.current.position]
end

function AnimatorComponent:getImage()
	return self.sheet:getImage()
end

return AnimatorComponent
