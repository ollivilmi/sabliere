require 'src/network/Connection'
require 'src/network/ClientStatus'
require 'src/network/updates/ClientUpdates'

Client = Class{__includes = Connection}

function Client:init(def)
    Connection:init(self, def)

    self.host = def.address or "127.0.0.1"
    self.port = def.port or 12345
    self.udp:setpeername(self.host, self.port)
    
    self.requests = require 'src/network/client/Requests'
    self.receiveFunction = self.udp.receive

    -- ping, connected, connecting...
    self.status = ClientStatus(self)

    -- add to game state for easy access to client status
    self.state.connectionStatus = self.status

    -- For duplex communication queue
    self.updates = ClientUpdates(self)
end

function Client:validClientId(clientId)
	if clientId == nil then return true end

	return self.status.id == clientId
end

function Client:send(data)
    data.headers.clientId = self.status.id
    self.udp:send(data:encode())
end

function Client:connect()
    self.status.connecting = true

    return coroutine.create(function()
        while self.status.connecting do
            self:send(Data{request = 'connect'})
            coroutine.yield()
        end
    end)
end

function Client:setConnected(clientId)
    self.status:setConnected(clientId)
    self:broadcastEvent('CONNECTED', clientId)
end

function Client:setDisconnected()
    self.status:setDisconnected()
    self:broadcastEvent('DISCONNECTED')
end

function Client:sendUpdates()
    if self.status.connected then
        for _, data in pairs(self.updates:clientUpdates()) do
            self:send(data)
        end

        -- Could be combined with playerUpdates for performance
        self:send(Data({request = 'ping'}, {sentTime = self.socket.gettime()}))
    end
end

function Client:checkTimeout(dt)
    if self.status:isTimedOut(dt) then
        self:setDisconnected()
        self:broadcastEvent('CONNECTION TIMED OUT')
    end
end