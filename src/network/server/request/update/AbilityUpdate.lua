require 'src/network/state/entity/Entity'

local AbilityUpdates = {}

function AbilityUpdates.handle(data, host, ip, port)
    local player = host.state.players:getEntity(data.headers.clientId)

    host.state.abilities[data.headers.abilityId]:use(player, data.payload.coords)

    -- Set clientId to entityId so that every client can receive it
    data.headers.entityId = data.headers.clientId
    data.headers.clientId = nil

    -- Add snapshot of player when the ability was triggered
    data.payload.player = player:getPos()

    host.updates:pushEvent(data)
end

return AbilityUpdates