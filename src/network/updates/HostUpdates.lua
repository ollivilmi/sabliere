require 'src/network/updates/Updates'
require 'src/network/updates/DuplexQueue'

HostUpdates = Class{__includes = Updates}

function HostUpdates:init(host)
    Updates:init(self, host)

    -- updates that require confirmation and must be sent in order
    self.duplexQueue = {}

    -- last Received / ackMask for each client
    self.packets = {}

	self.snapshotInterval = 30

    Timer.every(self.snapshotInterval, function()
		for clientId, __ in pairs(host.clients) do
			self:updateLevel(clientId)
		end
    end)
    
    local chunkHistory = {}

    host.state.players:addListener('PLAYER CHUNK', function(clientId, timeElapsed)
        if timeElapsed > self.snapshotInterval or timeElapsed == -1 then
            self:updateLevel(clientId)
        end
	end)
end

function HostUpdates:addClient(clientId)
    self.duplexQueue[clientId] = DuplexQueue(clientId, self.connection)
    self.packets[clientId] = {lastReceived = 0, ackMask = PacketLoss.BITMASK}
end

function HostUpdates:removeClient(clientId)
    self.duplexQueue[clientId] = nil
    self.packets[clientId] = nil

    local player = self.entities[clientId]
    if player then
        self.entities[clientId] = nil
    end
end

function HostUpdates:updateLevel(clientId)
	local snapshot = self.connection.state:getLevelSnapshot(clientId)

	for segment, payload in pairs(snapshot) do
		self:sendDuplex(clientId, Data({request = 'snapshot', segment = segment}, payload))
	end
end

function HostUpdates:sendACK(headers)
    self.duplexQueue[headers.clientId]:sendACK(headers.request)
end

function HostUpdates:receiveACK(headers)
    self.duplexQueue[headers.clientId]:receiveACK(headers.update)

    if headers.update ~= "ACK" then
        self.connection:send(Updates.ACK, headers.clientId)
    end
end

function HostUpdates:sendDuplex(clientId, data)
    self.duplexQueue[clientId]:push(data)
end

function HostUpdates:refreshDuplex(clientId)
    local duplex = self.duplexQueue[clientId]

    if duplex:timedOut() then
        -- NOTIFY: CONNECTION TIMED OUT FOR CLIENT_ID
        print("DUPLEX QUEUE TIMED OUT " .. clientId)
    else
        duplex:refresh()
    end
end

function HostUpdates:setLastReceived(sequenceNumber, clientId)
    self.packets[clientId].ackMask, self.packets[clientId].lastReceived = 
    PacketLoss.update(
        self.packets[clientId].ackMask,
        self.packets[clientId].lastReceived,
        sequenceNumber 
    )
end

function HostUpdates:getEvents(clientId)
    local data = self.events:get()

    data.headers.ack = self.packets[clientId].ackMask
    data.headers.last = self.packets[clientId].lastReceived

    return data
end

function HostUpdates:nextTick()
    for clientId, __ in pairs(self.duplexQueue) do
        self:refreshDuplex(clientId)
    end

	self.events.sequence:next()
end