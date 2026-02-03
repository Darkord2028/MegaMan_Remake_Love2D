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

function Event.off(name, fn)
    local list = Event.listeners[name]
    if not list then return end

    for i = #list, 1, -1 do
        if list[i] == fn then
            table.remove(list, i)
        end
    end

    if #list == 0 then
        Event.listeners[name] = nil
    end
end

function Event.clear()
	Event.listeners = {}
end

return Event
