local Object = require("engine.core.object")

local EntityComponent = Object:extend()
EntityComponent.__name = "EntityComponent"

function EntityComponent:new()
	self.entity = nil
	self.enabled = true
end

function EntityComponent:onEnable() end
function EntityComponent:onDisable() end
function EntityComponent:destroy() end

function EntityComponent:update() end
function EntityComponent:draw() end

return EntityComponent
