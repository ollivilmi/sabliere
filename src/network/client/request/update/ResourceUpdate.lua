local ResourceUpdate = {}

function ResourceUpdate.pickup(data, client)
    local coords = data.payload.coords
    local entity = client.state.players:getEntity(data.headers.entityId)

    for __, coords in pairs(data.payload.coords) do
        client.state.level.resources:removeIfExists(coords.x, coords.y)
        entity.resources = entity.resources + 1
    end
end

return ResourceUpdate