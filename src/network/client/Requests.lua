local get = require "src/network/client/request/Get"
local post = require "src/network/client/request/Post"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    connect = post.player.connect,
    move = post.player.move,
    update = post.player.update,
    disconnect = post.player.disconnect,
    snapshot = post.snapshot.set,
    chunk = post.tilemap.chunk,
}

return Requests