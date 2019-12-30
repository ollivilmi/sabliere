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
    self.id = nil

    -- For duplex communication queue
    self.updates = ClientUpdates()

    self.connecting = false
end

function Client:send(data)
    self.udp:send(data:encode())
end

function Client:connect()
    self.connecting = true

    return coroutine.create(function()
        while self.connecting do
            self:send(Data{request = 'connect'})
            coroutine.yield()
        end
    
        self.updates:pushDuplex(Data{request = 'connectPlayer'})
    end)
end

-- Receive clientId from server
function Client:setConnected(clientId)
    self.connecting = false
    self.id = clientId
    self.updates:setClientId(clientId)
end

function Client:disconnect()
    self:send(Data{clientId = self.id, request = 'quit'})
end

function Client:sendUpdates()
    for _, data in pairs(self.updates:clientUpdates()) do
        self:send(data)
    end
end
