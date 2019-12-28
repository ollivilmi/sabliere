require "src/network/state/GameState"

Connection = Class{}

-- Every message must be in this format to parse, delimited by spaces

-- First two variables are strings
-- 
-- String 1: client ID   String 2: command
--
-- Remainders: optional parameters for the command (JSON)
function Connection:init(self, def)
    self.state = GameState(self)
    self.tickrate = def.tickrate or 0.05
    
	self.socket = require "socket"
    self.udp = self.socket.udp()
    self.udp:settimeout(0)
    
    -- configure in child class
    self.updates = nil
    self.requests = nil
    self.receiveFunction = nil
end

function Connection:isDuplexRequest(data)
    return data.headers.duplex and data.headers.request ~= 'ACK'
end

function Connection:handleRequest(dataString, ip, port)
    if dataString then
        local decoded, data = pcall(Data.decode, dataString)
        
        if decoded then
            if self:isDuplexRequest(data) then
                self.updates:sendACK(data)
            end

            local requestHandler = self.requests[data.headers.request]

            if requestHandler then
                requestHandler(data, self, ip, port)
            end
        else
            -- add packet loss statistics here?
            print(data)
        end
    end
end

function Connection:close()
    self.udp:close()
end

function Connection:receive()
    while true do
        local data, msg_or_ip, port = self.receiveFunction(self.udp)
        if data then
            self:handleRequest(data, msg_or_ip, port)
        elseif msg_or_ip ~= 'timeout' then 
            error("Network error: "..tostring(msg))
        else
            break
        end
    end
end

