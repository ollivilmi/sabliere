Class = require 'lib/language/class'

require 'src/network/Host'

local host = Host{
    interface = '*',
    port = 12345
}

local running = true
-- reduce usage -- may need to adjust this in the future
local tickrate = 0.05

print("Sabliere server started on port 12345")

local previousTime = host.socket.gettime()
local currentTime = host.socket.gettime()

while running do
    host:tick()
    host.socket.sleep(tickrate)
    
    -- update game state by delta time
    currentTime = host.socket.gettime()
    host.state:update(currentTime - previousTime)
    previousTime = currentTime
end
