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

return Duplex