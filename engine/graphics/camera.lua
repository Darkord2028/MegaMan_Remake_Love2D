local humpCamera = require("engine.vendor.humpCamera")

local Camera = {}
Camera.__index = Camera

function Camera.new(x, y, zoom)
    local cam = humpCamera(x, y, zoom or 1)
    return setmetatable({
        cam = cam
    }, Camera)
end

function Camera:setPosition(x, y)
    self.cam:lookAt(x, y)
end

function Camera:attach()
    self.cam:attach()
end

function Camera:detach()
    self.cam:detach()
end

function Camera:follow(target)
    self.target = target
end

function Camera:update(dt)
    if not self.target then return end

    local transform = self.target:getComponent("TransformComponent")
    if not transform then return end

    local pos = transform.position

    self.cam:lookAt(
        math.floor(pos.x),
        math.floor(pos.y)
    )
end

return Camera
