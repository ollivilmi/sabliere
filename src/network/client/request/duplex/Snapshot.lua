local Snapshot = {}

function Snapshot.update(data, client)
    client.state:setSnapshot(data.headers.segment, data.payload)
    client:broadcastEvent('SNAPSHOT', data.headers.segment)
end

function Snapshot.connect(data, client)
    local player = client.state.players:getEntity(client.status.id)
    
    -- Periodically send movement updates to server
    client.updates:pushEntity(client.status.id, player)

    client:broadcastEvent('PLAYER CONNECTED', player)
end

return Snapshot