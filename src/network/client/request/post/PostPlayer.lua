require 'src/network/state/entity/Entity'
require 'src/client/states/play/entity/AnimatedEntity'

local models = require 'src/client/states/play/entity/models/playerModels'

local PostPlayer = {}

function PostPlayer.connect(data, client)
    if (data.client ~= client.id) then
        local entity = Entity(data.parameters, client.state.level)
        client.state.level.players[data.client] = AnimatedEntity(entity, models[entity.model]())
    end
end

function PostPlayer.update(data, client)
    if (data.client ~= client.id) then
        -- todo interpolate
        local player = client.state.level.players[data.client]

        if player then
            player.entity:updateState(data.parameters)
        end
    end
end

function PostPlayer.disconnect(data, client)
    client.state.level.players[data.client] = nil
end

return PostPlayer