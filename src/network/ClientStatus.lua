ClientStatus = Class{}

function ClientStatus:init(client)
    self.lastMessage = 0
    self.timeout = client.timeout
    self.ping = 0
    self.rtt = 0
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

function ClientStatus:setPing(data)
    self.lastMessage = 0
    -- Todo: avg previous 50 entries
    self.ping = (data.receivedTime - data.sentTime) * 1000
    self.rtt = (self.gettime() - data.sentTime) * 1000
end

function ClientStatus:isTimedOut(dt)
    if self.connected then
        self.lastMessage = self.lastMessage + dt

        return self.lastMessage > self.timeout
    end
end