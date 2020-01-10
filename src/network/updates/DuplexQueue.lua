require 'lib/language/Dequeue'

DuplexQueue = Class{}

-- Class is meant for duplex communication, but can really be used
-- for anything that requires retries
function DuplexQueue:init(clientId, connection, maxRetries, retryInterval)
    self.clientId = clientId
    self.connection = connection
    -- Queue for data to be sent, to ensure orderness
    self.queue = Dequeue()
    self.maxRetries = maxRetries or 50
    self.sentCount = 0

    self.retryInterval = retryInterval or 2 -- n of ticks before next try
    self.previousTry = self.retryInterval
end

function DuplexQueue:push(data)
    data.headers.duplex = true
    data.headers.clientId = self.clientId
    self.queue:push(data)
    self:refresh()
end

function DuplexQueue:pushFirst(data)
    data.headers.duplex = true
    data.headers.clientId = self.clientId
    self.queue:pushFirst(data)
    self:refresh()
end

-- Called after receiving confirmation that the update was successful
function DuplexQueue:next()
    self.queue:pop()
    self.sentCount = 0
    self.previousTry = self.retryInterval
end

function DuplexQueue:timedOut()
    return self.sentCount >= self.maxRetries
end

function DuplexQueue:shouldRetry()
    self.previousTry = self.previousTry + 1

    return self.previousTry >= self.retryInterval
end

function DuplexQueue:addTry()
    self.sentCount = self.sentCount + 1
    self.previousTry = 0
end

function DuplexQueue:refresh()
    if not self.queue:isEmpty() then
        if self:shouldRetry() then
            self.connection:send(self.queue:peek(), self.clientId)
            self:addTry()
        end
    end
end

function DuplexQueue:currentRequest()
    if self.queue:isEmpty() then return nil end

    return self.queue:peek().headers.request
end

function DuplexQueue:sendACK(request)
    self:pushFirst(Data({request = 'ACK'},{request = request}))
end

function DuplexQueue:receiveACK(request)
    if self:currentRequest() == request then
        self:next()
        return true
    end
    return false
end