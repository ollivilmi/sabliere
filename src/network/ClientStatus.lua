ClientStatus = Class{}

function ClientStatus:init(client)
    self.lastMessage = 0
    self.timeout = client.timeout
    -- todo: sequence
    self.ping = 0
    self.id = nil
    self.connecting = false
    self.connected = false

    self.gettime = client.socket.gettime
end

function ClientStatus:setConnected(clientId)
    self.connected = true 
    self.connecting = false
    self.id = clientId
end

function ClientStatus:setDisconnected()
    self.connected = false
    self.lastMessage = 0
    self.id = nil
end

function ClientStatus:setPing(sentTime)
    -- Todo: avg previous 50 entries
    self.ping = (self.gettime() - sentTime) * 1000 * 2
end

function ClientStatus:isTimedOut(dt)
    if self.connected then
        self.lastMessage = self.lastMessage + dt

        return self.lastMessage > self.timeout
    end
end