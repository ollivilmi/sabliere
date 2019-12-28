require 'src/network/Connection'
require 'src/network/updates/ClientUpdates'

Client = Class{__includes = Connection}

function Client:init(def)
    Connection:init(self, def)

    self.host = def.address or "127.0.0.1"
    self.port = def.port or 12345
    self.udp:setpeername(self.host, self.port)
    
    self.requests = require 'src/network/client/Requests'
    self.receiveFunction = self.udp.receive

    self.t = 0
    self.id = tostring(math.random(99999))

    -- For duplex communication queue
    self.updates = ClientUpdates(self.id)
end

function Client:send(data)
    self.udp:send(data:encode())
end

function Client:connect()
    -- todo: duplex
    self:send(Data({
        clientId = self.id,
        request = 'connect'
    }))
end

function Client:disconnect()
    self:send(Data({
        clientId = self.id,
        request = 'quit'
    }))
end

function Client:update(dt)
    self.t = self.t + dt

    if self.t > self.tickrate then
        for _, data in pairs(self.updates:clientUpdates()) do
            self:send(data)
        end

        self.updates:clearEvents()

        self.t = self.t - self.tickrate
    end
    
    self:receive()
end
