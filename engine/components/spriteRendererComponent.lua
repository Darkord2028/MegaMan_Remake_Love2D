local EntityComponent = require("engine.ecs.entityComponent")
local SortingLayers = require("engine.graphics.sortingLayers")

local SpriteRendererComponent = EntityComponent:extend()
SpriteRendererComponent.__name = "SpriteRendererComponent"

function SpriteRendererComponent:new(image)
    self.image = image
    self.quad = nil
    self.visible = true

    self.pivotX = 0.5
    self.pivotY = 0.5

    self.flipX = false
    self.flipY = false

    self.color = {1, 1, 1, 1}

    self.sortingLayer = SortingLayers.Default
    self.orderInLayer = 0
end

function SpriteRendererComponent:setFrame(quad)
    self.quad = quad
end

function SpriteRendererComponent:setFlipX(value)
    self.flipX = value
end

function SpriteRendererComponent:setFlipY(value)
    self.flipY = value
end

function SpriteRendererComponent:setColor(r, g, b, a)
    self.color[1] = 1 or r
    self.color[2] = 1 or g
    self.color[3] = 1 or b
    self.color[4] = 1 or a
end

function SpriteRendererComponent:setPivot(px, py)
    self.offsetX = px or 0
    self.offsetY = py or 0
end

function SpriteRendererComponent:setSortingLayer(layer)
    self.sortingLayer = layer
end

function SpriteRendererComponent:setOrderInLayer(order)
    self.orderInLayer = order
end

function SpriteRendererComponent:getSortKey()
    return self.sortingLayer * 10000 + self.orderInLayer
end

function SpriteRendererComponent:draw()
    if not self.visible or not self.image or not self.quad then
        return
    end

    local transform = self.entity:getComponent("TransformComponent")
    if not transform then return end

    local pos   = transform.position
    local scale = transform.scale

    local _, _, w, h = self.quad:getViewport()

    local ox = w * self.pivotX
    local oy = h * self.pivotY

    local drawX = math.floor(pos.x)
    local drawY = math.floor(pos.y)

    local sx = scale.x
    local sy = scale.y

    if self.flipX then
        sx = -sx
    end

    if self.flipY then
        sy = -sy
    end

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color)

    love.graphics.draw(
        self.image,
        self.quad,
        drawX,
        drawY,
        transform.rotation,
        sx,
        sy,
        ox,
        oy
    )

    love.graphics.setColor(r, g, b, a)

end


return SpriteRendererComponent
