local Time = {
	dt = 0,
	time = 0,
}

function Time.update(dt)
	Time.dt = dt
	Time.time = Time.time + dt
end

return Time
