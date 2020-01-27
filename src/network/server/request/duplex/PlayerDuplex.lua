require 'src/network/state/entity/Entity'

local PlayerDuplex = {}

function PlayerDuplex.connect(data, host, ip, port)
    local clientId = data.headers.clientId
    print("New player connected: " .. clientId)
    local player = host.state.players:createEntity(clientId, {x = 700, y = 330, h = 100, w = 50})

    host.updates:pushEntity(clientId, player)
    
    -- Send state snapshot to connecting player
    local snapshot = host.state:getSnapshot(clientId)

    for segment, payload in pairs(snapshot) do
        host.updates:sendDuplex(clientId, Data({request = 'snapshot', segment = segment}, payload))
    end

    host.updates:sendDuplex(clientId, Data({request = 'playerConnected'}))

    -- Add update of new player for all clients
    host.updates:pushEvent(Data({
        entityId = clientId,
        request = 'connectPlayer'
    }, player:getState()))
end

return PlayerDuplex