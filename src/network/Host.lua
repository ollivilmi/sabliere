require 'src/network/Connection'
require 'src/network/Data'

Host = Class{__includes = Connection}

function Host:init(def)
    Connection:init(self, def)
	self.udp:setsockname(def.interface or '*', def.port or 12345)
    self.requests = require "src/network/server/Requests"

	-- code brevity
	self.clients = self.state.client
end

function Host:send(data, ip, port)
	local msg = self.encode(data)

	self.udp:sendto(msg, ip, port)
end

function Host:sendToClient(data, clientId)
	local client = self.state.client[clientId]

	self:send(data, client.ip, client.port)
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
		for entityId, entity in pairs(self.entityUpdates) do
			self:send(Data(entityId, 'update', entity:getState()), client.ip, client.port)
		end
	end

	for id, client in pairs(self.clients) do
		for _, update in pairs(self.updates) do
			self:send(update, client.ip, client.port)
		end
	end

	self.updates = {}
end

function Host:tick()
	self:receive()
	self:update()
end

function Host:addPlayer(clientId, player, ip, port)
    self.state.level.players[clientId] = player
    self.state.client[clientId] = {ip = ip, port = port}
    self.entityUpdates[clientId] = player
end

function Host:removePlayer(clientId)
    self.state.client[clientId] = nil
    self.state.level.players[clientId] = nil
    self.entityUpdates[clientId] = nil
end