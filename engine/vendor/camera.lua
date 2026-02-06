local Object = require("engine.core.object")
local Push = require("engine.vendor.push")
local cos, sin = math.cos, math.sin

local Camera = Object:extend()
Camera.__name = "Camera"

-- Movement interpolators (for camera locking/windowing)
Camera.smooth = {}

function Camera.smooth.none()
    return function(dx, dy) return dx, dy end
end

function Camera.smooth.linear(speed)
    assert(type(speed) == "number", "Invalid parameter: speed = " .. tostring(speed))
    return function(dx, dy, s)
        -- normalize direction
        local d = math.sqrt(dx * dx + dy * dy)
        local dts = math.min((s or speed) * love.timer.getDelta(), d) -- prevent overshooting
        if d > 0 then
            dx, dy = dx / d, dy / d
        end
        return dx * dts, dy * dts
    end
end

function Camera.smooth.damped(stiffness)
    assert(type(stiffness) == "number", "Invalid parameter: stiffness = " .. tostring(stiffness))
    return function(dx, dy, s)
        local dts = love.timer.getDelta() * (s or stiffness)
        return dx * dts, dy * dts
    end
end

function Camera:new(x, y, zoom, rot, smoother)
    self.x = x or 0
    self.y = y or 0
    self.scale = zoom or 1
    self.rot = rot or 0
    self.smoother = smoother or Camera.smooth.none()
end

function Camera:lookAt(x, y)
    self.x = x - VIRTUAL_WIDTH / 2
    self.y = y - VIRTUAL_HEIGHT / 2
    return self
end

function Camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
    return self
end

function Camera:position()
    return self.x, self.y
end

function Camera:rotate(phi)
    self.rot = self.rot + phi
    return self
end

function Camera:rotateTo(phi)
    self.rot = phi
    return self
end

function Camera:zoom(mul)
    self.scale = self.scale * mul
    return self
end

function Camera:zoomTo(zoom)
    self.scale = zoom
    return self
end

function Camera:attach(x, y, w, h, noclip)
    x, y = x or 0, y or 0
    w, h = w or VIRTUAL_WIDTH, h or VIRTUAL_HEIGHT

    self._sx, self._sy, self._sw, self._sh = love.graphics.getScissor()
    if not noclip then
        love.graphics.setScissor(x, y, w, h)
    end

    local cx, cy = x + w / 2, y + h / 2
    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.scale(self.scale)
    love.graphics.rotate(self.rot)
    love.graphics.translate(-self.x - VIRTUAL_WIDTH / 2, -self.y - VIRTUAL_HEIGHT / 2)
end

function Camera:detach()
    love.graphics.pop()
    love.graphics.setScissor(self._sx, self._sy, self._sw, self._sh)
end

function Camera:draw(...)
    local x, y, w, h, noclip, func
    local nargs = select("#", ...)
    if nargs == 1 then
        func = ...
    elseif nargs == 5 then
        x, y, w, h, func = ...
    elseif nargs == 6 then
        x, y, w, h, noclip, func = ...
    else
        error("Invalid arguments to camera:draw()")
    end

    self:attach(x, y, w, h, noclip)
    func()
    self:detach()
end

-- World coordinates to camera coordinates
function Camera:cameraCoords(x, y, ox, oy, w, h)
    ox, oy = ox or 0, oy or 0
    w, h = w or VIRTUAL_WIDTH, h or VIRTUAL_HEIGHT

    local c, s = cos(self.rot), sin(self.rot)
    x, y = x - self.x - VIRTUAL_WIDTH / 2, y - self.y - VIRTUAL_HEIGHT / 2
    x, y = c * x - s * y, s * x + c * y
    return x * self.scale + w / 2 + ox, y * self.scale + h / 2 + oy
end

-- Camera coordinates to world coordinates
function Camera:worldCoords(x, y, ox, oy, w, h)
    ox, oy = ox or 0, oy or 0
    w, h = w or VIRTUAL_WIDTH, h or VIRTUAL_HEIGHT

    local c, s = cos(-self.rot), sin(-self.rot)
    x, y = (x - w / 2 - ox) / self.scale, (y - h / 2 - oy) / self.scale
    x, y = c * x - s * y, s * x + c * y
    return x + self.x + VIRTUAL_WIDTH / 2, y + self.y + VIRTUAL_HEIGHT / 2
end

function Camera:mousePosition(ox, oy, w, h)
    local mx, my = love.mouse.getPosition()
    if Push then
        mx, my = Push:toGame(mx, my)
    end
    return self:worldCoords(mx, my, ox, oy, w, h)
end

function Camera:lockX(x, smoother, ...)
    local dx, dy = (smoother or self.smoother)(x - self.x - VIRTUAL_WIDTH / 2, 0, ...)
    self.x = self.x + dx
    return self
end

function Camera:lockY(y, smoother, ...)
    local dx, dy = (smoother or self.smoother)(0, y - self.y - VIRTUAL_HEIGHT / 2, ...)
    self.y = self.y + dy
    return self
end

function Camera:lockPosition(x, y, smoother, ...)
    local targetX = x - VIRTUAL_WIDTH / 2
    local targetY = y - VIRTUAL_HEIGHT / 2
    return self:move((smoother or self.smoother)(targetX - self.x, targetY - self.y, ...))
end

function Camera:lockWindow(x, y, x_min, x_max, y_min, y_max, smoother, ...)
    x, y = self:cameraCoords(x, y)
    local dx, dy = 0, 0
    if x < x_min then
        dx = x - x_min
    elseif x > x_max then
        dx = x - x_max
    end
    if y < y_min then
        dy = y - y_min
    elseif y > y_max then
        dy = y - y_max
    end

    local c, s = cos(-self.rot), sin(-self.rot)
    dx, dy = (c * dx - s * dy) / self.scale, (s * dx + c * dy) / self.scale

    self:move((smoother or self.smoother)(dx, dy, ...))
end

return Camera