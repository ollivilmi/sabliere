luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'

require "src/network/Data"
require "src/test/network/setup"

function testConnect()
    local client, host = setupClientAndHost()
    local player = {x = 100, y = 100, width = 100, height = 100}

    client:connect(player)
    host:receive()

    -- Player is added to state
    assert(host.state.level.players[client.id].x == player.x)
    assert(host.state.level.players[client.id].y == player.y)

    -- Client is added to state
    assert(host.state.client[client.id])

    -- State update is added to updates table
    assert(table.getn(host.updates) == 2, "Should have client connected and tilemap sent")

    -- Send out update to clients
    host:update()

    -- Updates table should now be empty as the updates have
    -- been sent out
    assert(table.getn(host.updates) == 0)

    -- Receive update from server
    client:update(0)

    -- Client should now have updated player state from server
    assert(client.state.level.players[client.id].x == 100)
    assert(client.state.level.players[client.id].y == 100)

    client:close()
    host:close()
end

function testMove()
    local client, host = setupClientAndHost()
    local player = {x = 100, y = 100, width = 100, height = 100}

    connectClient(client, host, player)

    table.insert(client.inputs,
        Data(client.id, 'move', {x = 310, y = 240}))

    nextTick(client, host)
    nextTick(client, host)

    assert(host.state.level.players[client.id].x == 310)
    
    client:close()
    host:close()
end

os.exit( luaunit.LuaUnit.run() )
