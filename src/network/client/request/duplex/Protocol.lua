local Duplex = {}

function Duplex.acknowledge(data, client)
    if client.updates:receiveACK(data) then
        if request ~= 'ACK' then
            client:send(
                Data({clientId = client.status.id, request = 'ACK'}, {request = 'ACK'})
            )
        end
    end
end

function Duplex.connect(data, client)
    client:setConnected(data.payload.clientId)
end

function Duplex.ping(data, client)
    client.status:setPing(data.payload)
end

return Duplex