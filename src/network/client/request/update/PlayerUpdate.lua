require 'src/network/state/entity/Entity'
require 'src/client/states/play/entity/AnimatedEntity'

local models = require 'src/client/states/play/entity/models/playerModels'

local PlayerUpdate = {}

function PlayerUpdate.connect(data, client)
    if (data.headers.clientId ~= client.id) then
        client.state.level.players:createEntity(data.headers.clientId, data.payload)
    end
end

function PlayerUpdate.clientId(data, client)
    client:setConnected(data.payload.clientId)
end

function PlayerUpdate.update(data, client)
    if (data.headers.entityId ~= client.id) then
        client.state.level.players:updateState(data.headers.entityId, data.payload)
    end
end

function PlayerUpdate.disconnect(data, client)
    client.state.level.players:removeEntity(data.headers.clientId)
end

return PlayerUpdate