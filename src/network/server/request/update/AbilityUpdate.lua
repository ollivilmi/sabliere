require 'src/network/state/entity/Entity'

local AbilityUpdates = {}

function AbilityUpdates.handle(data, host, ip, port)
    local player = host.state.players:getEntity(data.headers.clientId)

    -- Use position of player when the ability was triggered
    local pos = player:getPos()
    host.state.abilities[data.headers.abilityId]:use(player, pos, data.payload.cursor)

    -- Set clientId to entityId so that every client can receive it
    data.headers.entityId = data.headers.clientId
    data.headers.clientId = nil
    data.payload.pos = pos

    host.updates:pushEvent(data)
end

return AbilityUpdates