local EntityComponent = require("engine.ecs.entityComponent")

local RenderComponent = EntityComponent:extend()
RenderComponent.__name = "RenderComponent"

function RenderComponent:new()
	self.visible = true
end

function RenderComponent:draw()
	if not self.visible then
		return
	end

	local transform = self.entity:getComponent("TransformComponent")
	if not transform then
		return
	end

	-- Prefer Animator if present
	local animator = self.entity:getComponent("AnimatorComponent")
	if animator then
		local image = animator:getImage()
		local quad = animator:getFrame()
		if image and quad then
			love.graphics.draw(image, quad, transform.x, transform.y)
		end
		return
	end

	-- Fallback to static sprite
	local sprite = self.entity:getComponent("SpriteComponent")
	if sprite then
		love.graphics.draw(sprite:getImage(), sprite:getQuad(), transform.x, transform.y)
	end
end

return RenderComponent
