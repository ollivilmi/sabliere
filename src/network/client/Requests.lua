local duplex = require "src/network/client/request/DuplexIndex"
local update = require "src/network/client/request/UpdateIndex"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    ACK = duplex.protocol.acknowledge,
    connect = duplex.protocol.connect,
    ping = duplex.protocol.ping,

    connectPlayer = update.player.connect,
    updatePlayer = update.player.update,
    quitPlayer = update.player.disconnect,

    snapshot = duplex.snapshot.set,
    chunk = duplex.tilemap.chunk,
}

return Requests