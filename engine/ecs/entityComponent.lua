local Object = require("engine.core.object")
local EntityComponent = Object:extend()

function EntityComponent:new()
	self.entity = nil
end
function EntityComponent:update() end
function EntityComponent:draw() end

return EntityComponent
