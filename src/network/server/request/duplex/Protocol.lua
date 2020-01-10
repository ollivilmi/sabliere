local Duplex = {}

function Duplex.acknowledge(data, host)
    local clientId = data.headers.clientId
    local request = data.payload.request

    if host.updates:receiveACK(data) then
        if request ~= 'ACK' then
            host:send(Data({clientId = clientId, request = 'ACK'}, {request = 'ACK'}),clientId)
        end
    end
end

function Duplex.connect(data, host, ip, port)
    local clientId = ip .. ":" .. port

    host:addClient(clientId, ip, port)
    host:send(Data({request = 'connect'}, {clientId = clientId}), clientId)
end

function Duplex.ping(data, host, ip, port)
    data.payload.receivedTime = host.socket.gettime()
    host:resetTimeout(data.headers.clientId)
    host:send(data, data.headers.clientId)
end

return Duplex