Class = require 'lib/util/class'

gState = require 'src/server/state/State'
gConnection = require 'src/server/connection/Connection'

local running = true
-- reduce usage -- may need to adjust this in the future
local sleep = 0.01 

print "Beginning server loop."
while running do
	gConnection.receive(sleep) 
end
 
print "Thank you."