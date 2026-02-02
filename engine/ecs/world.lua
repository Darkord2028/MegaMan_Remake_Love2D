local Object = require("engine.core.object")
local Camera = require("engine.graphics.camera")

local World = Object:extend()
World.__name = "World"

function World:new()
	self.entities = {}
	self.mainCamera = Camera.new(0, 0, 1)
end

function World:addEntity(entity)
	table.insert(self.entities, entity)
end

function World:setCameraTarget(entity)
	self.mainCamera:follow(entity)
end

function World:update(dt)
	for _, entity in ipairs(self.entities) do
		entity:update(dt)
	end

	self.mainCamera:update()
end

function World:draw()
    self.mainCamera:attach()

    local renderers = {}

    for _, entity in ipairs(self.entities) do
        local renderer = entity:getComponent("SpriteRendererComponent")
        if renderer and renderer.visible then
            table.insert(renderers, renderer)
        end
    end

    table.sort(renderers, function(a, b)
        return a:getSortKey() < b:getSortKey()
    end)

    for _, renderer in ipairs(renderers) do
        renderer:draw()
    end

    self.mainCamera:detach()
end


return World
