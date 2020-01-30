require 'lib/language/table'
require 'src/network/updates/Events'
require 'src/network/updates/PacketLoss'

Updates = Class{}

-- Response that is always sent to ACK requests
Updates.ACK = Data({request = "ACK", update = "ACK", duplex = true},{})

function Updates:init(self, connection)
    self.connection = connection
    -- eg. bullet spawned, reliable updates
    self.events = Events(connection.socket.gettime)

    -- entity:getUpdates(), unreliable movement updates
    self.entities = {}
end

function Updates:pushEvent(data)
	self.events.sequence:push(data)
end

function Updates:pushEntity(id, entity)
    self.entities[id] = entity
end

function Updates:getEntities()
    local entityData = {}

    for entityId, entity in pairs(self.entities) do
        table.insert(entityData,
            Data({entityId = entityId, request = 'updatePlayer'}, entity:getUpdates())
        )
    end

    return Data({batch = true}, entityData)
end

function Updates:isDuplex(headers)
    return headers.duplex
end

function Updates:isEvent(headers)
    return headers.seq
end

function Updates:respondDuplex(headers)
    if headers.request == 'ACK' then
        -- Receive = request can be closed
        self:receiveACK(headers)
    else
        -- Respond = duplex request has arrived
        self:sendACK(headers)
    end
end

function Updates:receiveEvents(headers)
    self:setLastReceived(headers.seq, headers.clientId)
    self.connection:resetTimeout(headers.clientId)
    self.connection:setPing(headers.sentTime, headers.clientId)

    -- Resend packets if missing
    if headers.ack then
        local lostPackets = self.events:lostPackets(headers)
        
        if #lostPackets > 0 then
            for __, data in pairs(lostPackets) do
                self.connection:send(data, headers.clientId)
            end
        end
    end
end

function Updates:handleHeaders(headers)
    if self:isDuplex(headers) then
        self:respondDuplex(headers)

    elseif self:isEvent(headers) then
        self:receiveEvents(headers)
    end
end