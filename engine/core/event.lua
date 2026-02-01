local Event = {}

Event.listeners = {}

function Event.on(name, fn)
	Event.listeners[name] = Event.listeners[name] or {}
	table.insert(Event.listeners[name], fn)
end

function Event.emit(name, ...)
	if not Event.listeners[name] then
		return
	end
	for _, fn in ipairs(Event.listeners[name]) do
		fn(...)
	end
end

return Event
