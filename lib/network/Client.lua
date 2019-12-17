require 'lib/network/Connection'

Client = Class{__includes = Connection}

function Client:init(def)
    Connection:init(self, def)
 
    self.host = def.address or "127.0.0.1"
    self.port = def.port or 12345

    -- 20 tick
    self.updaterate = def.updaterate or 0.05

    self.t = 0
    
    self.udp:setpeername(self.host, self.port)
    
    self.id = tostring(math.random(99999))
end

function Client:connect(coords)
    self.udp:send(Data(self.id, 'connect', coords):toString())
end

function Client:update(dt)
    self.t = self.t + dt

	if self.t > self.updaterate then
		local x, y = 0, 0
		if love.keyboard.isDown('up') then      y=y-(20*self.t) end
		if love.keyboard.isDown('down') then 	y=y+(20*self.t) end
		if love.keyboard.isDown('left') then 	x=x-(20*self.t) end
		if love.keyboard.isDown('right') then 	x=x+(20*self.t) end
    
        self.udp:send(Data(self.id, 'move', {x = x, y = y}):toString())
        self.udp:send(Data(self.id, 'update'):toString())

        self.t = self.t - self.updaterate
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