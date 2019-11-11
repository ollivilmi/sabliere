require "lib/network/Decoder"

Connection = Class{}

-- Every message must be in this format to parse, delimited by spaces

-- First two variables are strings
-- 
-- String 1: entity   String 2: command
--
-- Remainders: parameters for the command
local MESSAGE_FORMAT = '^(%S*) (%S*) (.*)'

function Connection:init(self, def)
    -- Commands is a list of possible messages server may receive or send
    assert(def.commands)
    self.commands = def.commands

    self.decoder = Decoder(self.commands, MESSAGE_FORMAT)

	self.socket = require "socket"
	self.udp = self.socket.udp()
	
	self.udp:settimeout(0)
end

function Connection:handleRequest(data, ip, port)
    if data then
        local message = self.decoder:decode(data)

        local command = self.commands[message.command]

        if command then
            command.execute(message, self, ip, port)
        end
    end
end