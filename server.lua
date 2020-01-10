require 'lib/language/language-extensions'

require 'src/network/Host'

local host = Host{
    interface = '*',
    port = 12345
}

local running = true

print("Sabliere server started on port 12345")

local previousTime = host.socket.gettime()
local currentTime = host.socket.gettime()

local fiveseconds = host.socket.gettime()

Timer.every(5, function()
    host.state.level.players:print()
end)

while running do
    currentTime = host.socket.gettime()
    local dt = currentTime - previousTime
    previousTime = currentTime

    Timer.update(dt)
    host:update(dt)
end
