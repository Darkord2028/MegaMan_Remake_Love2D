local Class = {}

function Class.extend(base)
	base = base or {}

	local cls = {}
	cls.__index = cls

	setmetatable(cls, {
		__index = base,
		__call = function(c, ...)
			local instance = setmetatable({}, c)
			if instance.new then
				instance:new(...)
			end
			return instance
		end,
	})

	function cls:extend()
		return Class.extend(self)
	end

	return cls
end

return Class
