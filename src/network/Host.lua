require 'src/network/Connection'

Host = Class{__includes = Connection}

function Host:init(def)
    Connection:init(self, def)
	self.udp:setsockname(def.interface or '*', def.port or 12345)
    self.requests = require "src/network/server/Requests"

	-- updates is a table that contains all the state updates from
	-- previous tick that will be sent to all clients
	-- 
	-- the table is then cleared for next tick
	self.updates = {}

	-- code brevity
	self.clients = self.state.client
end

function Host:send(data, ip, port)
	self.udp:sendto(data:toString(), ip, port)
end

function Host:receive()
	while true do
		local data, msg_or_ip, port = self.udp:receivefrom()
		if data then
			self:handleRequest(data, msg_or_ip, port)
		elseif msg_or_ip ~= 'timeout' then 
			error("Network error: "..tostring(msg))
		else
			break
		end
	end
end

function Host:update()
	for id, client in pairs(self.clients) do
		for _, update in pairs(self.updates) do
			self.udp:sendto(update:toString(), client.ip, client.port)
		end
	end

	self.updates = {}
end

function Host:tick()
	self:receive()
	self:update()
end

function Host:pushUpdate(substate, key, value)
	self.state:set(substate, key, value)
	table.insert(self.updates, Data(key, substate, value))
end