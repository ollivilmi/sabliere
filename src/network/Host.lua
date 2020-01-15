require 'src/network/Connection'
require 'src/network/Data'
require 'src/network/updates/ServerUpdates'
require 'src/network/state/ServerOnlyEvents'

Host = Class{__includes = Connection}

function Host:init(def)
    Connection:init(self, def)
	self.udp:setsockname(def.interface or '*', def.port or 12345)
	
	self.requests = require "src/network/server/Requests"
	self.receiveFunction = self.udp.receivefrom

	-- [id] = ip, port, time from last ping
	self.clients = {}
	self.updates = ServerUpdates(self)

	self.serverOnlyEvents = ServerOnlyEvents(self)

	self.t = 0

	self.state.level:addTestTiles()
end

function Host:validClientId(clientId)
	if clientId == nil then return true end

	return self.clients[clientId] ~= nil
end

function Host:send(data, clientId)
	local client = self.clients[clientId]

	self.udp:sendto(data:encode(), client.ip, client.port)
end

function Host:sendUpdates()
	for clientId, __ in pairs(self.clients) do
		for _, data in pairs(self.updates:getUpdates()) do
			self:send(data, clientId)
		end

		for _, data in pairs(self.updates:getUpdatesForClient(clientId)) do
			self:send(data, clientId)
		end
	end
end

function Host:addClient(clientId, ip, port)
    self.clients[clientId] = {ip = ip, port = port, lastMessage = 0}
	self.updates:addClient(clientId)
end

function Host:removeClient(clientId)
	self.clients[clientId] = nil
	self.updates:removeClient(clientId)
end

function Host:resetTimeout(clientId)
	if clientId then
		self.clients[clientId].lastMessage = 0
	end
end

function Host:checkTimeout(dt)
	for clientId, client in pairs(self.clients) do
		client.lastMessage = client.lastMessage + dt

		if client.lastMessage > self.timeout then
			self:removeClient(clientId)
			self.requests.quitPlayer({headers = {clientId = clientId}}, self)
		end
	end
end