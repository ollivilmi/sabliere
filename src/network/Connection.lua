require "src/network/state/GameState"
require 'lib/language/Listener'

Connection = Class{__includes = Listener}

function Connection:init(self, def)
    Listener:init(self)
    self.state = GameState(self)
    self.tickrate = def.tickrate or 0.05
    
	self.socket = require "socket"
    self.udp = self.socket.udp()
    self.udp:settimeout(0)

    self.timeout = def.timeout or 1
    self.tickrateTimer = 0

    -- configure in child class
    self.updates = nil
    self.requests = nil
    self.receiveFunction = nil
end

function Connection:update(dt)
	self:receive()

    self.tickrateTimer = self.tickrateTimer + dt
    
    self:checkTimeout(dt)

    if self.tickrateTimer > self.tickrate then
		self:sendUpdates(dt)

		self.tickrateTimer = self.tickrateTimer - self.tickrate
		self.updates:clearEvents()
	end

	self.state:update(dt)
end

function Connection:isDuplexRequest(data)
    return data.headers.duplex and data.headers.clientId and data.headers.request ~= 'ACK'
end

function Connection:handleRequest(dataString, ip, port)
    if dataString then
        local decoded, data = pcall(Data.decode, dataString)
        
        if decoded and self:validClientId(data.headers.clientId) then
            if self:isDuplexRequest(data) then
                self.updates:sendACK(data)
            end

            local requestHandler = self.requests[data.headers.request]

            if requestHandler then
                success, error = pcall(requestHandler, data, self, ip, port)

                if not success then
                    print(error)
                end
            end
        else
            -- add packet loss statistics here?
            print(data:toString())
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

