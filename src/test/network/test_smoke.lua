luaunit = require 'src/test/luaunit'
Class = require 'lib/util/class'

require "lib/network/Decoder"
require "lib/network/Host"
require "lib/network/Client"

function testDecoder()
    local json = require 'lib/util/json'

    local message = "entity123 location " .. json.encode({x = 5, y = 15})

    local decoder = Decoder()
    local data = decoder:decode(message)

    assert(data.client == "entity123")
    assert(data.request == "location")
    assert(data.parameters.x == 5)
    assert(data.parameters.y == 15)
end

function testEndToEnd()
    local host = Host{
        requests = require 'src/server/Requests',
        interface = '*',
        port = 12345
    }

    local client = Client{
        requests = require 'src/client/Requests',
        address = '127.0.0.1',
        port = 12345,
    }

    -- Connect:
    -- Server receives ip, port, unique ID
    -- x, y for player coordinates
    client:connect{x = 320, y = 240}
    host:receive(0)

    -- Player is added to state
    assert(host.state.index.player[client.id].x == 320)
    assert(host.state.index.player[client.id].y == 240)

    -- Client is added to state
    assert(host.state.index.client[client.id])

    -- State update is added to updates table
    assert(table.getn(host.updates) == 1)

    -- Send out update to clients
    host:update(0)

    -- Updates table should now be empty as the updates have
    -- been sent out
    assert(table.getn(host.updates) == 0)

    -- Receive update from server
    client:update(0)

    -- Client should now have updated player state from server
    assert(client.state.index.player[client.id].x == 320)
    assert(client.state.index.player[client.id].y == 240)
end

os.exit( luaunit.LuaUnit.run() )
