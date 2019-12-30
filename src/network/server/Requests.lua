local duplex = require "src/network/server/request/DuplexIndex"
local update = require "src/network/server/request/UpdateIndex"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    connect = duplex.protocol.connect,
    ACK = duplex.protocol.acknowledge,

    connectPlayer = update.player.connect,
    quitPlayer = update.player.quit,
    updatePlayer = update.player.update,
}

return Requests