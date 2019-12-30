local get = require "src/network/client/request/Get"
local post = require "src/network/client/request/Post"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    -- duplex communication
    ACK = post.duplex.acknowledge,
    connect = post.duplex.connect,
    -- player
    connectPlayer = post.player.connect,
    update = post.player.update,
    disconnect = post.player.disconnect,
    -- level
    snapshot = post.snapshot.set,
    chunk = post.tilemap.chunk,
}

return Requests