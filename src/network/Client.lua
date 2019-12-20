require 'src/network/Connection'

Client = Class{__includes = Connection}

function Client:init(def)
    Connection:init(self, def)

    self.host = def.address or "127.0.0.1"
    self.port = def.port or 12345
    
    self.requests = require 'src/network/client/Requests'
    self.t = 0
    
    self.udp:setpeername(self.host, self.port)
    self.inputs = {}
    
    self.id = tostring(math.random(99999))
end

function Client:connect(player)
    local msg = self.encode(Data(self.id, 'connect', player))

    self.udp:send(msg)
end

function Client:update(dt)
    self.t = self.t + dt

    if self.t > self.tickrate then
        for _, input in pairs(self.inputs) do
            self.udp:send(self.encode(input))
        end

        self.inputs = {}
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