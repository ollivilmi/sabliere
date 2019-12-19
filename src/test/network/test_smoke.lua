luaunit = require 'src/test/luaunit'
Class = require 'lib/language/class'
local json = require 'lib/language/json'

require "src/network/Decoder"
require "src/network/Data"

require "src/test/network/setup"

function testDecoder()
    local message = "entity123 location " .. json.encode({x = 5, y = 15})

    local decoder = Decoder()
    local data = decoder:decode(message)

    assert(data.client == "entity123")
    assert(data.request == "location")
    assert(data.parameters.x == 5)
    assert(data.parameters.y == 15)
end

function testConnect()
    local client, host = setupClientAndHost()
    local entity = {x = 100, y = 100, width = 100, height = 100}

    client:connect(entity)
    host:receive()

    -- Player is added to state
    assert(host.state.level.entities[client.id].x == entity.x)
    assert(host.state.level.entities[client.id].y == entity.y)

    -- Client is added to state
    assert(host.state.client[client.id])

    -- State update is added to updates table
    assert(table.getn(host.updates) == 1)

    -- Send out update to clients
    host:update()

    -- Updates table should now be empty as the updates have
    -- been sent out
    assert(table.getn(host.updates) == 0)

    -- Receive update from server
    client:update(0)

    -- Client should now have updated player state from server
    assert(client.state.level.entities[client.id].x == 100)
    assert(client.state.level.entities[client.id].y == 100)

    client:close()
    host:close()
end

function testMove()
    local client, host = setupClientAndHost()
    local entity = {x = 100, y = 100, width = 100, height = 100}

    connectClient(client, host, entity)

    table.insert(client.inputs,
        Data(client.id, 'move', {x = 310, y = 240}))

    nextTick(client, host)
    nextTick(client, host)

    assert(host.state.level.entities[client.id].x == 310)
    
    client:close()
    host:close()
end

os.exit( luaunit.LuaUnit.run() )
