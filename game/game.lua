local Event = require("engine.core.event")
local WorldManager = require("engine.managers.worldManager")
local WorldRegistry = require("game.worlds.WorldRegistry")

local Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)

    self.worlds = WorldManager.new(WorldRegistry)
    self._listeners = {}

    local fn

    fn = Event.on("world:load", function(worldId, params)
        self.worlds:load(worldId, params)
    end)
    table.insert(self._listeners, { name = "world:load", fn = fn })

    fn = Event.on("world:reload", function()
        self.worlds:reload()
    end)
    table.insert(self._listeners, { name = "world:reload", fn = fn })

    fn = Event.on("game:quit", function()
        love.event.quit()
    end)
    table.insert(self._listeners, { name = "game:quit", fn = fn })

    return self
end

function Game:update(dt)
    self.worlds:update(dt)
end

function Game:draw()
    self.worlds:draw()
end

function Game:loadWorld(id, params)
    self.worlds:load(id, params)
end

function Game:getWorld()
    return self.worlds:getWorld()
end

function Game:destroy()
    for _, l in ipairs(self._listeners) do
        Event.off(l.name, l.fn)
    end
    self._listeners = nil
end

return Game
