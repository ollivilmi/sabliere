require 'src/network/state/entity/Entity'

local AbilityUpdates = {}

function AbilityUpdates.handle(data, client, ip, port)
    local player = client.state.players:getEntity(data.headers.entityId)

    client.state.abilities[data.headers.abilityId]:use(player, data.payload.pos, data.payload.cursor)
end

return AbilityUpdates