local Snapshot = {}

function Snapshot.update(data, client)
    client.state:setSnapshot(data.payload)
    client:broadcastEvent('SNAPSHOT')
end

function Snapshot.connect(data, client)
    client.state:setSnapshot(data.payload)

    local player = client.state.level.players:getEntity(client.status.id)
    
    -- Periodically send movement updates to server
    client.updates:pushEntity(client.status.id, player)

    client:broadcastEvent('PLAYER CONNECTED', player)
end

return Snapshot