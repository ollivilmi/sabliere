Class = require 'lib/util/class'

gState = require 'src/server/state/State'
require 'lib/network/Host'

local connection = Host{
    commands = require "src/server/network/Commands",
    interface = '*',
    port = 12345
}

local running = true
-- reduce usage -- may need to adjust this in the future
local sleep = 0.01 

print "Beginning server loop."
while running do
	connection:receive(sleep) 
end
 
print "Thank you."