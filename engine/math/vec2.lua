local Vec2 = {}
Vec2.__index = Vec2

function Vec2.new(x, y)
	return setmetatable({ x = x or 0, y = y or 0 }, Vec2)
end

function Vec2:add(v)
	self.x = self.x + v.x
	self.y = self.y + v.y
end

function Vec2:scale(s)
	self.x = self.x * s
	self.y = self.y * s
end

return Vec2
