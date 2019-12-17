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
        requests = require 'src/server/network/Requests',
        interface = '*',
        port = 12345,
        state = require 'src/server/state/State'
    }

    local client = Client{
        address = '127.0.0.1',
        port = 12345,
        updaterate = 0.05,
    }

    client:connect{x = 320, y = 240}
    host:receive(0)

    assert(host.state.player[client.id].x == 320)
    assert(host.state.player[client.id].y == 240)
end

os.exit( luaunit.LuaUnit.run() )
