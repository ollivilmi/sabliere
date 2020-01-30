Class = require 'lib/language/class'

require "src/network/Host"
require "src/network/Client"

function addClient(host)
    local client = Client{
        requests = require 'src/network/client/Requests',
        address = '127.0.0.1',
        port = 12345,
        tickrate = 0.05,
    }
    
    client:send(Data{request = 'connect'})
    host:receive()
    client:receive()

    -- Client is added to host
    assert(host.clients[client.status.id])

    assert(client.status.id)
    assert(client.status.connected)
    assert(not client.status.connecting)

    return client
end

function setupClientAndHost()
    local host = Host{
        requests = require 'src/network/server/Requests',
        interface = '*',
        port = 12345
    }
    local client = addClient(host)

    return client, host
end

function cleanup(client, host)
    client:setDisconnected()
    host:close()
end

function nextTick(client, host)
    host:update(host.tickrate)
    client:update(client.tickrate)
end

function nTicks(client, host, n)
    for i = 1, n do
        nextTick(client, host)
    end
end