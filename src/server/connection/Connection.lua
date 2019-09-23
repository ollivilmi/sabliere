require "src/server/connection/Decoder"

local socket = require "socket"
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 12345)

local Connection = {}
local commands = require "src/server/connection/command/Commands"
local decoder = Decoder(commands)

function Connection.send(data, ip, port)
	udp:sendto(data:toString(), ip, port)
end

function Connection.receive(sleep)
	data, msg_or_ip, port_or_nil = udp:receivefrom()
	
    if data then
		local data = decoder:decode(data)

		local command = commands[data.command]
		assert(command)
		command.execute(data, msg_or_ip, port_or_nil)
		
	elseif msg_or_ip ~= 'timeout' then
		error("Unknown network error: "..tostring(msg))
    end
    
	socket.sleep(sleep)
end

return Connection