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

function DuplexQueue:resetRetry()
    self.previousTry = self.retryInterval
    self.sentCount = 0
end

function DuplexQueue:addHeaders(data)
    data.headers.duplex = true
    data.headers.clientId = self.clientId
end

function DuplexQueue:push(data)
    self:addHeaders(data)
    self.queue:push(data)
end

function DuplexQueue:pushFirst(data)
    self:addHeaders(data)
    self.queue:pushFirst(data)
    self:resetRetry()
    self:refresh()
end

-- Called after receiving confirmation that the update was successful
function DuplexQueue:next()
    self.queue:pop()
    self:resetRetry()
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
    if self:shouldRetry() then
        local data = self.queue:peek()
        if data then
            self.connection:send(data, self.clientId)
            self:addTry()
        end
    end
end

function DuplexQueue:currentRequest()
    if self.queue:isEmpty() then return nil end

    return self.queue:peek().headers.request
end

function DuplexQueue:sendACK(request)
    self:pushFirst(Data({request = 'ACK', update = request},{}))
end

function DuplexQueue:receiveACK(request)
    if self:currentRequest() == request then
        self:next()
        return true
    end
    return false
end