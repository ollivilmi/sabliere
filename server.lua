Class = require 'lib/language/class'

require 'lib/game/network/Host'

local host = Host{
    requests = require "src/server/Requests",
    interface = '*',
    port = 12345
}

local running = true
-- reduce usage -- may need to adjust this in the future
local tickrate = 0.05

print("Sabliere server started on port 12345")

while running do
    host:tick()
    host.socket.sleep(tickrate)
end
