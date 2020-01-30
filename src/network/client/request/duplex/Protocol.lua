local Duplex = {}

function Duplex.connect(data, client)
    client:setConnected(data.payload.clientId)
end

return Duplex