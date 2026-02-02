local EntityComponent = require("engine.ecs.entityComponent")
local anim8 = require("engine.vendor.anim8")

local AnimatorComponent = EntityComponent:extend()
AnimatorComponent.__name = "AnimatorComponent"

function AnimatorComponent:new(spriteSheet)
    self.sheet = spriteSheet
    self.grid = spriteSheet:getGrid()
    self.animations = {}
    self.current = nil
end

function AnimatorComponent:addAnimation(name, frames, duration, onLoop)
    self.animations[name] =
        anim8.newAnimation(frames, duration, onLoop)
end

function AnimatorComponent:play(name, force)
    local anim = self.animations[name]
    if not anim then return end
    if not force and self.current == anim then return end

    self.current = anim
    anim:gotoFrame(1)
    anim:resume()
end

function AnimatorComponent:update(dt)
    if not self.current then return end

    self.current:update(dt)

    local spriteRenderer =
        self.entity:getComponent("SpriteRendererComponent")

    if spriteRenderer then
        spriteRenderer:setFrame(
            self.current.frames[self.current.position]
        )
    end
end

return AnimatorComponent
