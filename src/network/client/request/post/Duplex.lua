local Duplex = {}

function Duplex.acknowledge(data, client)
    if client.updates:receiveACK(data) then
        if request ~= 'ACK' then
            client:send(
                Data({clientId = client.id, request = 'ACK'}, {request = 'ACK'})
            )
        end
    end
end

function Duplex.connect(data, client)
    client:setConnected(data.payload.clientId)
end

return Duplex