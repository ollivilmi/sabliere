local Duplex = {}

function Duplex.connect(data, host, ip, port)
    local clientId = ip .. ":" .. port

    host:addClient(clientId, ip, port)
    host:send(Data({request = 'connect'}, {clientId = clientId}), clientId)
end

return Duplex