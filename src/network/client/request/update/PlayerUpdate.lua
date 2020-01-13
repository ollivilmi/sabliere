require 'src/network/state/entity/Entity'
require 'src/client/scenes/play/entity/AnimatedEntity'

local models = require 'src/client/scenes/play/entity/models/playerModels'

local PlayerUpdate = {}

function PlayerUpdate.connect(data, client)
    if (data.headers.entityId ~= client.status.id) then
        client.state.players:createEntity(data.headers.entityId, data.payload)
    end
end

function PlayerUpdate.update(data, client)
    if (data.headers.entityId ~= client.status.id) then
        local player = client.state.players:getEntity(data.headers.entityId)

        if player then
            player:tween(client.tickrate, data.payload)
            data.payload.x, data.payload.y = nil, nil
            player:updateState(data.payload)
        end
    end
end

function PlayerUpdate.disconnect(data, client)
    client.state.players:removeEntity(data.headers.entityId)
end

return PlayerUpdate