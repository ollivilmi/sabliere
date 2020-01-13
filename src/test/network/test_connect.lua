luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'

require "src/network/Data"
require "src/test/network/clientHostSetup"

function testConnect()
    local client, host = setupClientAndHost()
    cleanup(client, host)
end

function testDisconnect()
    local client, host = setupClientAndHost()

    client:setDisconnected()
    host:receive()

    -- Client is removed
    assert(not host.clients[client.status.id])

    -- Player entity is removed
    assert(not host.state.players:getEntity(client.status.id))    

    host:close()
end

function testTimeout()
    local client, host = setupClientAndHost()
    connectPlayer(client, host)

    host:update(host.timeout + 1)

    -- Client is removed
    assert(not host.clients[client.status.id])

    -- Player entity is removed
    assert(not host.state.players:getEntity(client.status.id))

    client:update(client.timeout + 1)

    -- Client is disconnected
    assert(not client.connected)
    assert(client.status.lastMessage == 0 and not client.status.id)

    host:close()
end

function testPing()
    local client, host = setupClientAndHost()

    nextTick(client, host)

    assert(client.ping ~= 0)
    assert(client.rtt ~= 0)

    cleanup(client, host)
end

function testClientIdIsValidated()
    local client, host = setupClientAndHost()

    -- Client is not removed, no clientId
    assert(not host:validClientId('test'))
    assert(not client:validClientId('test'))

    assert(host:validClientId(client.status.id))
    assert(host:validClientId(client.status.id))

    cleanup(client, host)
end

os.exit( luaunit.LuaUnit.run() )
