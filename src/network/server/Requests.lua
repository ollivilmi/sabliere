local get = require "src/network/server/request/Get"
local post = require "src/network/server/request/Post"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    connect = post.player.connect,
    move = post.player.move,
    quit = post.player.quit,
    update = post.player.update,
    ACK = post.duplex.acknowledge,
}

return Requests