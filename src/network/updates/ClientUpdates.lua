require 'src/network/updates/Updates'
require 'src/network/updates/DuplexQueue'

ClientUpdates = Class{__includes = Updates}

function ClientUpdates:init(clientId)
    Updates:init(self)

    -- updates that require confirmation and must be sent in order
    self.duplexQueue = DuplexQueue(clientId)
end

function ClientUpdates:pushDuplex(data)
	self.duplexQueue:push(data)
end

function ClientUpdates:sendACK(data)
    self.duplexQueue:sendACK(data.headers.request)
end

-- Called upon completing current update in queue, move to next
function ClientUpdates:receiveACK(data)
    return self.duplexQueue:receiveACK(data.payload.request)
end

function ClientUpdates:clientUpdates()
    local updates = self:getUpdates()

    if self.duplexQueue:timedOut() then
        -- NOTIFY: CONNECTION TIMED OUT
    end

    local data = self.duplexQueue:refresh()
    if data then
        table.insert(updates, data)
    end

    return updates
end