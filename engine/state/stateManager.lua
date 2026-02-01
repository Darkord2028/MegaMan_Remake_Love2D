local StateManager = {
	current = nil,
}

function StateManager.switch(state)
	if StateManager.current and StateManager.current.exit then
		StateManager.current:exit()
	end
	StateManager.current = state
	if state.enter then
		state:enter()
	end
end

function StateManager.update(dt)
	if StateManager.current then
		StateManager.current:update(dt)
	end
end

function StateManager.draw()
	if StateManager.current then
		StateManager.current:draw()
	end
end

return StateManager
