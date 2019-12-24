require 'src/network/Connection'

Client = Class{__includes = Connection}

function Client:init(def)
    Connection:init(self, def)

    self.host = def.address or "127.0.0.1"
    self.port = def.port or 12345
    
    self.requests = require 'src/network/client/Requests'
    self.t = 0
    
    self.udp:setpeername(self.host, self.port)
    
    self.id = tostring(math.random(99999))
end

function Client:connect()
    local msg = self.encode(Data(self.id, 'connect', nil))

    self.udp:send(msg)
end

function Client:disconnect()
    local msg = self.encode(Data(self.id, 'quit', nil))

    self.udp:send(msg)
end

function Client:update(dt)
    self.t = self.t + dt

    if self.t > self.tickrate then
        for id, entity in pairs(self.entityUpdates) do
            self.udp:send(
                self.encode(
                    Data(id, 'update', entity:getState())
                )
            )
        end

        for _, update in pairs(self.updates) do
            self.udp:send(self.encode(update))
        end

        self.updates = {}

        self.t = self.t - self.tickrate
    end
    
    while true do
        local data, msg = self.udp:receive()
        if data then
            self:handleRequest(data)
        elseif msg ~= 'timeout' then 
            error("Network error: "..tostring(msg))
        else
            break
        end
    end
end