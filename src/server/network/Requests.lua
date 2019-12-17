local get = require "src/server/network/request/Get"
local post = require "src/server/network/request/Post"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    connect = post.player.connect,
    move = post.player.move,
    quit = post.player.quit,

    -- also requested.. should not be. Add a different file, updates
    update = get.player.location
}

return Requests