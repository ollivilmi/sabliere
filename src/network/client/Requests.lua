local get = require "src/network/client/request/Get"
local post = require "src/network/client/request/Post"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    connect = post.player.connect,
    move = post.player.move,
    tilemap = post.tilemap.snapshot
}

return Requests