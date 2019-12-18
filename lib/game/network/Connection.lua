require "lib/game/network/Decoder"
require "lib/game/network/State"

Connection = Class{}

-- Every message must be in this format to parse, delimited by spaces

-- First two variables are strings
-- 
-- String 1: entity   String 2: command
--
-- Remainders: optional parameters for the command (JSON)
function Connection:init(self, def)
    self.requests = def.requests or {}
    self.decoder = Decoder()
	self.state = State(self)

	self.socket = require "socket"
	self.udp = self.socket.udp()
	
	self.udp:settimeout(0)
end

function Connection:handleRequest(data, ip, port)
    if data then
        local message = self.decoder:decode(data)
        local request = self.requests[message.request]

        if request then
            request(message, self, ip, port)
        end
    end
end

function Connection:close()
    self.udp:close()
end