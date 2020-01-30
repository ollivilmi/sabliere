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

function testPingIsUpdated()
    local client, host = setupClientAndHost()

    host.updates:pushEvent(Data{request = "test"},{})
    client.updates:pushEvent(Data{request = "test"},{})

    nTicks(client, host, 2)

    assert(client.status.ping > 0)
    assert(host.clients[client.status.id].ping > 0, host.clients[client.status.id].ping)

    cleanup(client, host)
end

function testUpdateHeadersAreCorrect()
    local client, host = setupClientAndHost()

    local data = client.updates:getEntities()
    assert(data.headers.batch, "Entity data should have batch header")

    local data = client.updates:getEvents()
    assert(data.headers.batch, "Events should have batch header")
    assert(data.headers.seq, "Events should have sequence number header")
    assert(data.headers.ack, "Events should have ackMask header")
    assert(data.headers.last, "Events should have lastReceived header")
    assert(data.headers.sentTime, "Events should have sentTime header")

    cleanup(client, host)
end

-- returns a table of bits, most significant first.
local function toBinary(num, bits)
     bits = bits or math.max(1, select(2, math.frexp(num)))
     local t = {} -- will contain the bits        
     for b = bits, 1, -1 do
         t[b] = math.fmod(num, 2)
         num = math.floor((num - t[b]) / 2)
     end
     return table.concat(t)
end

function testLastReceivedUpdatesAckMaskForPacketLoss()
    local client, host = setupClientAndHost()
    local msg = "Unexpected mask:  "

    local updates = client.updates
    
    updates:setLastReceived(1)
    assert(updates.lastReceived == 1)
    assert(toBinary(updates.ackMask, 16) == "1111111111111111", msg .. toBinary(updates.ackMask, 16))

    updates:setLastReceived(4)
    assert(updates.lastReceived == 4)
    assert(toBinary(updates.ackMask, 16) == "1111111111111001", msg .. toBinary(updates.ackMask, 16))

    updates:setLastReceived(5)
    assert(updates.lastReceived == 5)
    assert(toBinary(updates.ackMask, 16) == "1111111111110011", msg .. toBinary(updates.ackMask, 16))

    updates:setLastReceived(2)
    assert(updates.lastReceived == 5)
    assert(toBinary(updates.ackMask, 16) == "1111111111111011", msg .. toBinary(updates.ackMask, 16))

    updates:setLastReceived(3)
    assert(updates.lastReceived == 5)
    assert(toBinary(updates.ackMask, 16) == "1111111111111111", msg .. toBinary(updates.ackMask, 16))

    updates:setLastReceived(9)
    assert(updates.lastReceived == 9)
    assert(toBinary(updates.ackMask, 16) == "1111111111110001", msg .. toBinary(updates.ackMask, 16))

    updates:setLastReceived(6)
    assert(updates.lastReceived == 9)
    assert(toBinary(updates.ackMask, 16) == "1111111111111001", msg .. "Expected  " .. toBinary(updates.ackMask, 16))

    cleanup(client, host)
end

function testBatchDecode()
    local dataTable = {}

    table.insert(dataTable, Data({request = "test 1"}, {x = 1}))
    table.insert(dataTable, Data({request = "test 2"}, {x = 2}))

    local batch = Data({batch = true}, dataTable)

    local decodedBatch = Data.decode(batch:encode())

    assert(decodedBatch.payload[1].headers.request == "test 1")
    assert(decodedBatch.payload[2].headers.request == "test 2")

    assert(decodedBatch.payload[1].payload.x == 1)
    assert(decodedBatch.payload[2].payload.x == 2)
end

function testSendEvent()
    local client, host = setupClientAndHost()

    host.updates:pushEvent(Data({request = "1"}))
    host.updates:pushEvent(Data({request = "2"}))
    
    local data = host.updates:getEvents(client.status.id)
    host.updates:nextTick()

    local hostEvents = host.updates.events
    local clientEvents = client.updates.events

    -- sequence number for data is 1
    assert(data.headers.seq == 1)
    -- current sequence number is 2
    assert(hostEvents.sequence.number == 2, hostEvents.sequence.number)
    
    -- Add previous packets to event history, 148 & 149
    hostEvents.sequence.data[147] =  {Data({request = "147"},{x = 1})}
    hostEvents.sequence.data[148] = {Data({request = "148"},{x = 2})}

    -- "Set latest" to 150
    hostEvents.sequence.number = 150
    hostEvents.sequence.data[150] = {}

    bit = require 'bit32'
    -- adjust mask to previous 2 packets missing
    local ackMask = bit.lshift(client.updates.ackMask, 3)
    client.updates.ackMask = bit.bor(ackMask, 1)
    client.updates.lastReceived = 149

    -- Updating the client sends ackMask, lastReceived to host
    client:update(client.tickrate)

    -- Updating the host responds with missing packets
    host:update(host.tickrate)
    assert(hostEvents.sequence.number == 151, "Host sends event on update, sn should be 151")
    
    -- Updating the client, receives missing packets
    client:update(client.tickrate)
    
    assert(client.updates.ackMask == PacketLoss.BITMASK, "Client ack mask should be complete after receiving missing packages")
    assert(client.updates.lastReceived == 150, "Client should also receive 150 after receiving update from host")

    cleanup(client, host)
end

function testEventHistoryIsLimitedTo1K()
    local client, host = setupClientAndHost()

    -- 1000 pops --> first one is removed
    for i = 1, Events.HISTORY_LENGTH do
        host.updates:pushEvent(Data({number = i}))
        host.updates:nextTick()
    end

    assert(#host.updates.events.sequence.data == Events.HISTORY_LENGTH)
    assert(host.updates.events.sequence.number ==  1, "Sequence n should be back to 1 after sequence is filled")
    assert(host.updates.events.sequence:get(0)[1].headers.number == 1000)
    assert(host.updates.events.sequence:get(-1)[1].headers.number == 999)

    cleanup(client, host)
end

function testMultipleClientsTrackPacketLoss()
    local client1, host = setupClientAndHost()
    local client2 = addClient(host)

    local host_rec_client1 = host.updates.packets[client1.status.id]
    local host_rec_client2 = host.updates.packets[client2.status.id]

    -- Initially, host should have lastReceived 0 and ackMask complete for new clients
    assert(host_rec_client1.lastReceived == 0 and host_rec_client2.lastReceived == 0)
    assert(host_rec_client1.ackMask == PacketLoss.BITMASK and host_rec_client2.ackMask == PacketLoss.BITMASK)

    -- Host event sequence number should be 1, none have been sent yet
    assert(host.updates.events.sequence.number == 1)
    host:update(host.tickrate)
    -- Host event sequence number should be 2, after one tick (events are sent every tick, even when empty)
    assert(host.updates.events.sequence.number == 2)

    client1:update(client1.tickrate)
    client2:update(client2.tickrate)
    
    -- Clients should have received event number 1 from host after update
    assert(client1.updates.lastReceived == 1 and client2.updates.lastReceived == 1)
    assert(client1.updates.ackMask == PacketLoss.BITMASK and client2.updates.ackMask == PacketLoss.BITMASK)

    host:update(host.tickrate)
    
    local host_rec_client1 = host.updates.packets[client1.status.id]
    local host_rec_client2 = host.updates.packets[client2.status.id]

    -- After updating the host again, it should receive updates from clients that they have received the previous event
    assert(host_rec_client1.lastReceived == 1 and host_rec_client2.lastReceived == 1)
    assert(host_rec_client1.ackMask == PacketLoss.BITMASK and host_rec_client2.ackMask == PacketLoss.BITMASK)

    client2:setDisconnected()
    cleanup(client1, host)
end

os.exit( luaunit.LuaUnit.run() )
