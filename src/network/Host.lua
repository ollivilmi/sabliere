require 'src/network/Connection'
require 'src/network/Data'
require 'src/network/updates/ServerUpdates'

Host = Class{__includes = Connection}

function Host:init(def)
    Connection:init(self, def)
	self.udp:setsockname(def.interface or '*', def.port or 12345)
	
	self.requests = require "src/network/server/Requests"
	self.receiveFunction = self.udp.receivefrom

	-- [id] = ip, port
	self.clients = {}
    self.updates = ServerUpdates()
end

function Host:send(data, ip, port)
	self.udp:sendto(data:encode(), ip, port)
end

function Host:sendToClient(clientId, data)
	local client = self.clients[clientId]

	self:send(data, client.ip, client.port)
end

function Host:update()
	for clientId, client in pairs(self.clients) do
		for _, data in pairs(self.updates:getUpdates()) do
			self:send(data, client.ip, client.port)
		end

		for _, data in pairs(self.updates:getUpdatesForClient(clientId)) do
			self:send(data, client.ip, client.port)
		end
	end

	self.updates:clearEvents()
end

function Host:tick()
	self:receive()
	self:update()
end

function Host:addClient(clientId, ip, port)
    self.clients[clientId] = {ip = ip, port = port}
	self.updates:addClient(clientId)
end

function Host:removeClient(clientId)
	self.clients[clientId] = nil
	self.updates:removeClient(clientId)
end