luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'

require "src/network/Data"
require "src/test/network/setup"

function testConnect()
    local client, host = setupClientAndHost()

    client:connect()
    host:receive()

    -- Player is added to state
    assert(host.state.level.players:getEntity(client.id))

    -- Client is added to host
    assert(host.clients[client.id])

    -- Send out update to clients
    host:update()

    -- Updates table should now be empty as the updates have
    -- been sent out
    assert(table.getn(host.updates) == 0)

    -- Receive update from server
    client:update(0)

    client:close()
    host:close()
end

-- function testMove()
--     local client, host = setupClientAndHost()
--     local player = {x = 100, y = 100, width = 100, height = 100}

--     connectClient(client, host, player)

--     table.insert(client.inputs,
--         Data(client.id, 'update', {x = 310, y = 240}))

--     nextTick(client, host)
--     nextTick(client, host)

--     assert(host.state.level.players[client.id].x == 310)
    
--     client:close()
--     host:close()
-- end

os.exit( luaunit.LuaUnit.run() )
