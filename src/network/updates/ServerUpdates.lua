require 'src/network/updates/Updates'
require 'src/network/updates/DuplexQueue'

ServerUpdates = Class{__includes = Updates}

function ServerUpdates:init()
    Updates:init(self)

    -- updates to specific client
    self.clientEvents = {}
    
    -- updates that require confirmation and must be sent in order
    self.duplexToClient = {}
end

function ServerUpdates:pushClientEvent(clientId, data)
	table.insert(self.clientEvents[clientId], data)
end

function ServerUpdates:pushDuplex(clientId, data)
	self.duplexToClient[clientId]:push(data)
end

function ServerUpdates:sendACK(data)
    self.duplexToClient[data.headers.clientId]:sendACK(data.headers.request)
end

-- Called upon completing current update in queue, move to next
function ServerUpdates:receiveACK(data)
    return self.duplexToClient[data.headers.clientId]:receiveACK(data.payload.request)
end

function ServerUpdates:addClient(clientId)
    self.duplexToClient[clientId] = DuplexQueue(clientId)
    self.clientEvents[clientId] = {}
end

function ServerUpdates:removeClient(clientId)
    self.duplexToClient[clientId] = nil
    self.clientEvents[clientId] = nil

    local player = self.entities[clientId]
    if player then
        self.entities[clientId] = nil
    end
end

function ServerUpdates:duplexData(clientId)
    local request = self.duplexToClient[clientId]

    if request:timedOut() then
        -- NOTIFY: CONNECTION TIMED OUT FOR CLIENT_ID
    end

    return request:refresh()
end

function ServerUpdates:getUpdatesForClient(clientId)
    local updates = {}

    for _, data in pairs(self.clientEvents[clientId]) do
        table.insert(updates, data)
    end

    local data = self:duplexData(clientId)
    if data then
        table.insert(updates, data)
    end

    return updates
end

function ServerUpdates:clearEvents()
    self.events = {}
    for clientId, _ in pairs(self.clientEvents) do
        self.clientEvents[clientId] = {}
    end
end