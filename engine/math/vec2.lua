local Vec2 = {}
Vec2.__index = Vec2

-- Constructor
function Vec2.new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0
    }, Vec2)
end

-- Allow Vec2(x, y)
setmetatable(Vec2, {
    __call = function(_, x, y)
        return Vec2.new(x, y)
    end
})

-- Basic operations
function Vec2:clone()
    return Vec2(self.x, self.y)
end

function Vec2:add(v)
    return Vec2(self.x + v.x, self.y + v.y)
end

function Vec2:sub(v)
    return Vec2(self.x - v.x, self.y - v.y)
end

function Vec2:scale(s)
    return Vec2(self.x * s, self.y * s)
end

function Vec2:dot(v)
    return self.x * v.x + self.y * v.y
end

-- Length & normalize
function Vec2:len()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:normalize()
    local l = self:len()
    if l == 0 then
        return Vec2(0, 0)
    end
    return self:scale(1 / l)
end

-- Utility
function Vec2:perpendicular()
    return Vec2(-self.y, self.x)
end

function Vec2:unpack()
    return self.x, self.y
end

-- Metamethods
function Vec2.__tostring(v)
    return string.format("(%.2f, %.2f)", v.x, v.y)
end

function Vec2.__add(a, b)
    return a:add(b)
end

function Vec2.__sub(a, b)
    return a:sub(b)
end

function Vec2.__mul(a, b)
    if type(b) == "number" then
        return a:scale(b)
    end
    return Vec2(a.x * b.x, a.y * b.y)
end

function Vec2.__div(a, b)
    if type(b) == "number" then
        return a:scale(1 / b)
    end
    return Vec2(a.x / b.x, a.y / b.y)
end

function Vec2.__unm(a)
    return Vec2(-a.x, -a.y)
end

function Vec2.__eq(a, b)
    return a.x == b.x and a.y == b.y
end

-- Constants
Vec2.ZERO  = Vec2(0, 0)
Vec2.RIGHT = Vec2(1, 0)
Vec2.UP    = Vec2(0, -1)

return Vec2
