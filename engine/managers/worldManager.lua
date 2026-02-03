local WorldManager = {}
WorldManager.__index = WorldManager

function WorldManager.new(registry)
    return setmetatable({
        registry  = registry,
        current   = nil,
        currentId = nil,
    }, WorldManager)
end

function WorldManager:load(id, params)
    local path = self.registry[id]
    assert(path, "World not registered: " .. tostring(id))

    if self.current then
        if self.current.onDisable then
            self.current:onDisable()
        end
        if self.current.destroy then
            self.current:destroy()
        end
    end

    local WorldClass = require(path)
    self.current = WorldClass(params)
    self.currentId = id

    -- Enable new world
    if self.current.onEnable then
        self.current:onEnable()
    end
end

function WorldManager:update(dt)
    if self.current and self.current.enabled ~= false then
        self.current:update(dt)
    end
end

function WorldManager:draw()
    if self.current and self.current.enabled ~= false then
        self.current:draw()
    end
end

function WorldManager:reload()
    if self.currentId then
        self:load(self.currentId)
    end
end

function WorldManager:getWorld()
    return self.current
end

return WorldManager
