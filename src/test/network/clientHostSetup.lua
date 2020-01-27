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

    client:send(Data{request = 'connect'})
    host:receive()
    client:receive()

    -- Client is added to host
    assert(host.clients[client.status.id])

    assert(client.status.id)
    assert(client.status.connected)
    assert(not client.status.connecting)

    return client, host
end

function connectPlayer(client, host)
    client.updates:sendDuplex(Data{request = 'connectPlayer'})

    -- local connecting = true
    -- client:addListener('PLAYER CONNECTED', function()
    --     connecting = false
    -- end)

    -- while connecting do
    --     client:sendUpdates(client.tickrate)
    --     host:receive()
    --     host:sendUpdates(host.tickrate)
    --     client:receive()
    -- end
end

function cleanup(client, host)
    client:setDisconnected()
    host:close()
end

function nextTick(client, host)
    host:update(host.tickrate)
    client:update(client.tickrate)
end