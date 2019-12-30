local Snapshot = {}

function Snapshot.set(data, client)
    client.state:setSnapshot(data.payload)
    client:broadcastEvent('SNAPSHOT')
end

return Snapshot