require 'lib/network/Connection'

Host = Class{__includes = Connection}

function Host:init(def)
    Connection:init(self, def)
	self.udp:setsockname(def.interface or '*', def.port or 12345)
end

function Host:send(data, ip, port)
	self.udp:sendto(data:toString(), ip, port)
end

function Host:receive(sleep)
	local data, msg_or_ip, port = self.udp:receivefrom()
	if data then
		self:handleRequest(data, msg_or_ip, port)
	elseif msg_or_ip ~= 'timeout' then 
        error("Network error: "..tostring(msg))
	end
	self.socket.sleep(sleep)
end

return Host