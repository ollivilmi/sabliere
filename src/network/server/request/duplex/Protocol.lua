local Duplex = {}

function Duplex.acknowledge(data, host)
    local clientId = data.headers.clientId
    local request = data.payload.request

    if host.updates:receiveACK(data) then
        if request ~= 'ACK' then
            host:sendToClient(clientId, 
            Data({clientId = clientId, request = 'ACK'}, {request = 'ACK'}))
        end
    end
end

function Duplex.connect(data, host, ip, port)
    local clientId = ip .. ":" .. port

    host:addClient(clientId, ip, port)
    host:send(Data({request = 'connect'}, {clientId = clientId}), ip, port)
end

function Duplex.ping(data, host, ip, port)
    data.payload.receivedTime = host.socket.gettime()
    host:resetTimeout(data.headers.clientId)
    host:send(data, ip, port)
end

return Duplex