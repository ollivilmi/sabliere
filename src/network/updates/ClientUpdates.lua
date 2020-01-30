require 'src/network/updates/Updates'
require 'src/network/updates/DuplexQueue'

ClientUpdates = Class{__includes = Updates}

function ClientUpdates:init(client)
    Updates:init(self, client)

    -- updates that require confirmation and must be sent in order
    -- requires clientId to work
    self.duplexQueue = DuplexQueue(nil, client)

    self.ackMask = PacketLoss.BITMASK
    self.lastReceived = 0

    client:addListener('CONNECTED', function(clientId)
        self.duplexQueue = DuplexQueue(clientId, client)
    end)

    client:addListener('DISCONNECTED', function()
        self.duplexQueue = DuplexQueue(nil, client)
    end)
end

function ClientUpdates:sendDuplex(data)
	self.duplexQueue:push(data)
end

-- eg. send ACK Snapshot received
function ClientUpdates:sendACK(headers)
    self.duplexQueue:sendACK(headers.request)
end

-- eg. receive ACK Snapshot received. -> Send ACK ACK
function ClientUpdates:receiveACK(headers)
    self.duplexQueue:receiveACK(headers.update)

    if headers.update ~= "ACK" then
        self.connection:send(Updates.ACK)
    end
end

function ClientUpdates:refreshDuplex()
    if self.duplexQueue:timedOut() then
        -- NOTIFY: CONNECTION TIMED OUT
        print("DUPLEX QUEUE TIMED OUT")
    end

    self.duplexQueue:refresh()
end

function ClientUpdates:setLastReceived(sequenceNumber)
    self.ackMask, self.lastReceived = 
    PacketLoss.update(self.ackMask, self.lastReceived, sequenceNumber)
end

function ClientUpdates:getEvents()
    local data = self.events:get()

    data.headers.ack = self.ackMask
    data.headers.last = self.lastReceived

    return data
end

function ClientUpdates:nextTick()
	self:refreshDuplex()
	self.events.sequence:next()
end