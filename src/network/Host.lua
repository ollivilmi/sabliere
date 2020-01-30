require 'src/network/Connection'
require 'src/network/Data'
require 'src/network/updates/HostUpdates'
require 'src/network/state/HostOnlyEvents'

Host = Class{__includes = Connection}

function Host:init(def)
    Connection:init(self, def)
	self.udp:setsockname(def.interface or '*', def.port or 12345)
	
	self.requests = require "src/network/server/Requests"
	self.receiveFunction = self.udp.receivefrom

	-- [id] = ip, port, time from last ping
	self.clients = {}
	self.updates = HostUpdates(self)

	self.serverOnlyEvents = HostOnlyEvents(self)

	self.state.level:addTestTiles()
end

function Host:send(data, clientId)
	local client = self.clients[clientId]

	self.udp:sendto(data:encode(), client.ip, client.port)
end

-- Requests must contain clientId header for a valid client
-- for anything other than a connect request
function Host:validRequest(data, ip, port)
	if data.headers.clientId then
		local client = self.clients[data.headers.clientId]
		
		return client and client.ip == ip and client.port == port
	end

	return data.headers.request == "connect"
end

function Host:sendUpdates()
	for clientId, __ in pairs(self.clients) do
		self:send(self.updates:getEntities(), clientId)
		self:send(self.updates:getEvents(clientId), clientId)
	end
	self.updates:nextTick()
end

function Host:addClient(clientId, ip, port)
    self.clients[clientId] = {ip = ip, port = port, lastMessage = 0, ping = 0}
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

function Host:setPing(sentTime, clientId)
	if clientId then
		self.clients[clientId].ping = (self.socket.gettime() - sentTime) * 1000 * 2
	end
end