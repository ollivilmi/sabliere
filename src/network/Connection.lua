require "src/network/state/GameState"
local json = require 'lib/language/json'
local lzw = require 'lib/language/lzw'

Connection = Class{}

-- Every message must be in this format to parse, delimited by spaces

-- First two variables are strings
-- 
-- String 1: client ID   String 2: command
--
-- Remainders: optional parameters for the command (JSON)
function Connection:init(self, def)
    self.requests = nil
    self.state = GameState(self)
    self.tickrate = def.tickrate or 0.05

	self.socket = require "socket"
    self.udp = self.socket.udp()
    
    -- updates contains all the state updates from
    -- previous tick, eg. bullet spawned
	-- 
	-- the table should then be cleared for next tick
    self.updates = {}
    -- entityUpdates is a list of entities that need to update
    -- their current state to the host every tick
    self.entityUpdates = {}
	
	self.udp:settimeout(0)
end

function Connection.encode(data)
    local payload = data.parameters or '{}'

    payload = lzw.compress(json.encode(payload))

    return string.format("%s %s %s", data.client, data.request, payload)
end

function Connection.decode(data)
    local client, command, payload = data:match('^(%S*) (%S*) (.*)')

    local parameters = lzw.decompress(payload)

    parameters = json.decode(parameters)

    return Data(client, command, parameters)
end

function Connection:handleRequest(data, ip, port)
    if data then
        local message = self.decode(data)
        local request = self.requests[message.request]

        if request then
            request(message, self, ip, port)
        end
    end
end

function Connection:close()
    self.udp:close()
end

function Connection:pushUpdate(data)
	table.insert(self.updates, data)
end