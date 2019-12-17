local get = require "src/client/request/Get"
local post = require "src/client/request/Post"

-- Requests are basically like an API call, client asks the server
-- to get or post some information
local Requests = {
    player = post.player.update,
}

return Requests