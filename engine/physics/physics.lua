local Physics = {
	bodies = {},
}

function Physics.add(body)
	table.insert(Physics.bodies, body)
end

function Physics.update(dt)
	for _, b in ipairs(Physics.bodies) do
		b.position:add(b.velocity)
	end
end

return Physics
