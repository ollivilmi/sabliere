require "src/network/state/GameState"
require 'lib/language/Listener'
Timer = require 'lib/game/love-utils/knife/timer'

Connection = Class{__includes = Listener}

function Connection:init(self, def)
    Listener:init(self)
    self.state = GameState()
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
    Timer.update(dt)
	self:receive()

    self.tickrateTimer = self.tickrateTimer + dt
    
    self:checkTimeout(dt)

    if self.tickrateTimer >= self.tickrate then
		self:sendUpdates(dt)

		self.tickrateTimer = self.tickrateTimer - self.tickrate
	end

    self.state:update(dt)
end

function Connection:handlePayload(data, ip, port)
    local requestHandler = self.requests[data.headers.request]

    if requestHandler then
        success, error = pcall(requestHandler, data, self, ip, port)

        if not success then
            print("Payload error: " .. error)
        end
    end
end

function Connection:handleBatch(batch, ip, port)
    for __, request in pairs(batch.payload) do
        request.headers.clientId = batch.headers.clientId
        self:handlePayload(request, ip, port)
    end
end

function Connection:handleMessage(dataString, ip, port)
    if dataString then
        local decoded, data = pcall(Data.decode, dataString)
        
        if decoded and self:validRequest(data, ip, port) then
            self.updates:handleHeaders(data.headers)

            if data.headers.batch then
                self:handleBatch(data, ip, port)
            else
                self:handlePayload(data, ip, port)
            end
        else
            print("Error: invalid message")
        end
    end
end

function Connection:receive()
    while true do
        local data, msg_or_ip, port = self.receiveFunction(self.udp)

        if data then
            self:handleMessage(data, msg_or_ip, port)
        elseif msg_or_ip ~= 'timeout' then 
            error("Network error: "..tostring(msg))
        else
            break
        end
    end
end

function Connection:close()
    self.udp:close()
end