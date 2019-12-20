Class = require 'lib/language/class'

require "src/network/Host"
require "src/network/Client"

function setupClientAndHost()
    local client = Client{
        requests = require 'src/network/client/Requests',
        address = '127.0.0.1',
        port = 12345,
        tickrate = 0.05,
    }

    local host = Host{
        requests = require 'src/network/server/Requests',
        interface = '*',
        port = 12345
    }

    return client, host
end

function nextTick(client, host)
    host:tick()
    client:update(0.05)
end

function connectClient(client, host, player)
    -- Connect:
    -- Server receives ip, port, unique ID
    -- x, y for player coordinates
    client:connect(player)
    nextTick(client, host)
end