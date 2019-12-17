Class = require 'lib/util/class'

require 'lib/network/Host'

local connection = Host{
    requests = require "src/server/network/Requests",
    interface = '*',
    port = 12345
}

local running = true
-- reduce usage -- may need to adjust this in the future
local sleep = 0.01

print "Beginning server loop."
while running do
    connection:receive(sleep)
    -- todo: server simulation loop, which runs everything that has happened during previous tick
    -- state:update(tickrate)
end
 
print "Thank you."