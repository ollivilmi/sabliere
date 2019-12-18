Class = require 'lib/language/class'

require "lib/game/network/Host"
require "lib/game/network/Client"

function setupClientAndHost()
    local client = Client{
        requests = require 'src/client/Requests',
        address = '127.0.0.1',
        port = 12345,
    }

    local host = Host{
        requests = require 'src/server/Requests',
        interface = '*',
        port = 12345
    }

    return client, host
end

function nextTick(client, host)
    host:tick()
    client:update(0.05)
end

function connectClient(client, host, coords)
    -- Connect:
    -- Server receives ip, port, unique ID
    -- x, y for player coordinates
    client:connect(coords)
    nextTick(client, host)
end