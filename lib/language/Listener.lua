Listener = Class{}

function Listener:init(self)
    self.listeners = {}
end

function Listener:addListener(event, callback)
	table.insert(self.listeners, {event = event, callback = callback})
end

function Listener:broadcastEvent(event, ...)
    for _, listener in pairs(self.listeners) do
        if event == listener.event then
            listener.callback(...)
        end
    end
end
